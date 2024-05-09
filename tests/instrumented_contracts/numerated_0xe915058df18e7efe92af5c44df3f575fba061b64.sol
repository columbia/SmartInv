1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity ^0.7.0;
3 pragma experimental ABIEncoderV2;
4 // File: contracts/iface/Wallet.sol
5 
6 // Copyright 2017 Loopring Technology Limited.
7 
8 
9 /// @title Wallet
10 /// @dev Base contract for smart wallets.
11 ///      Sub-contracts must NOT use non-default constructor to initialize
12 ///      wallet states, instead, `init` shall be used. This is to enable
13 ///      proxies to be deployed in front of the real wallet contract for
14 ///      saving gas.
15 ///
16 /// @author Daniel Wang - <daniel@loopring.org>
17 interface Wallet
18 {
19     function version() external pure returns (string memory);
20 
21     function owner() external view returns (address);
22 
23     /// @dev Set a new owner.
24     function setOwner(address newOwner) external;
25 
26     /// @dev Adds a new module. The `init` method of the module
27     ///      will be called with `address(this)` as the parameter.
28     ///      This method must throw if the module has already been added.
29     /// @param _module The module's address.
30     function addModule(address _module) external;
31 
32     /// @dev Removes an existing module. This method must throw if the module
33     ///      has NOT been added or the module is the wallet's only module.
34     /// @param _module The module's address.
35     function removeModule(address _module) external;
36 
37     /// @dev Checks if a module has been added to this wallet.
38     /// @param _module The module to check.
39     /// @return True if the module exists; False otherwise.
40     function hasModule(address _module) external view returns (bool);
41 
42     /// @dev Binds a method from the given module to this
43     ///      wallet so the method can be invoked using this wallet's default
44     ///      function.
45     ///      Note that this method must throw when the given module has
46     ///      not been added to this wallet.
47     /// @param _method The method's 4-byte selector.
48     /// @param _module The module's address. Use address(0) to unbind the method.
49     function bindMethod(bytes4 _method, address _module) external;
50 
51     /// @dev Returns the module the given method has been bound to.
52     /// @param _method The method's 4-byte selector.
53     /// @return _module The address of the bound module. If no binding exists,
54     ///                 returns address(0) instead.
55     function boundMethodModule(bytes4 _method) external view returns (address _module);
56 
57     /// @dev Performs generic transactions. Any module that has been added to this
58     ///      wallet can use this method to transact on any third-party contract with
59     ///      msg.sender as this wallet itself.
60     ///
61     ///      Note: 1) this method must ONLY allow invocations from a module that has
62     ///      been added to this wallet. The wallet owner shall NOT be permitted
63     ///      to call this method directly. 2) Reentrancy inside this function should
64     ///      NOT cause any problems.
65     ///
66     /// @param mode The transaction mode, 1 for CALL, 2 for DELEGATECALL.
67     /// @param to The desitination address.
68     /// @param value The amount of Ether to transfer.
69     /// @param data The data to send over using `to.call{value: value}(data)`
70     /// @return returnData The transaction's return value.
71     function transact(
72         uint8    mode,
73         address  to,
74         uint     value,
75         bytes    calldata data
76         )
77         external
78         returns (bytes memory returnData);
79 }
80 
81 // File: contracts/lib/AddressUtil.sol
82 
83 // Copyright 2017 Loopring Technology Limited.
84 
85 
86 /// @title Utility Functions for addresses
87 /// @author Daniel Wang - <daniel@loopring.org>
88 /// @author Brecht Devos - <brecht@loopring.org>
89 library AddressUtil
90 {
91     using AddressUtil for *;
92 
93     function isContract(
94         address addr
95         )
96         internal
97         view
98         returns (bool)
99     {
100         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
101         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
102         // for accounts without code, i.e. `keccak256('')`
103         bytes32 codehash;
104         // solhint-disable-next-line no-inline-assembly
105         assembly { codehash := extcodehash(addr) }
106         return (codehash != 0x0 &&
107                 codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
108     }
109 
110     function toPayable(
111         address addr
112         )
113         internal
114         pure
115         returns (address payable)
116     {
117         return payable(addr);
118     }
119 
120     // Works like address.send but with a customizable gas limit
121     // Make sure your code is safe for reentrancy when using this function!
122     function sendETH(
123         address to,
124         uint    amount,
125         uint    gasLimit
126         )
127         internal
128         returns (bool success)
129     {
130         if (amount == 0) {
131             return true;
132         }
133         address payable recipient = to.toPayable();
134         /* solium-disable-next-line */
135         (success,) = recipient.call{value: amount, gas: gasLimit}("");
136     }
137 
138     // Works like address.transfer but with a customizable gas limit
139     // Make sure your code is safe for reentrancy when using this function!
140     function sendETHAndVerify(
141         address to,
142         uint    amount,
143         uint    gasLimit
144         )
145         internal
146         returns (bool success)
147     {
148         success = to.sendETH(amount, gasLimit);
149         require(success, "TRANSFER_FAILURE");
150     }
151 
152     // Works like call but is slightly more efficient when data
153     // needs to be copied from memory to do the call.
154     function fastCall(
155         address to,
156         uint    gasLimit,
157         uint    value,
158         bytes   memory data
159         )
160         internal
161         returns (bool success, bytes memory returnData)
162     {
163         if (to != address(0)) {
164             assembly {
165                 // Do the call
166                 success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
167                 // Copy the return data
168                 let size := returndatasize()
169                 returnData := mload(0x40)
170                 mstore(returnData, size)
171                 returndatacopy(add(returnData, 32), 0, size)
172                 // Update free memory pointer
173                 mstore(0x40, add(returnData, add(32, size)))
174             }
175         }
176     }
177 
178     // Like fastCall, but throws when the call is unsuccessful.
179     function fastCallAndVerify(
180         address to,
181         uint    gasLimit,
182         uint    value,
183         bytes   memory data
184         )
185         internal
186         returns (bytes memory returnData)
187     {
188         bool success;
189         (success, returnData) = fastCall(to, gasLimit, value, data);
190         if (!success) {
191             assembly {
192                 revert(add(returnData, 32), mload(returnData))
193             }
194         }
195     }
196 }
197 
198 // File: contracts/lib/ERC1271.sol
199 
200 // Copyright 2017 Loopring Technology Limited.
201 
202 abstract contract ERC1271 {
203     // bytes4(keccak256("isValidSignature(bytes32,bytes)")
204     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
205 
206     function isValidSignature(
207         bytes32      _hash,
208         bytes memory _signature)
209         public
210         view
211         virtual
212         returns (bytes4 magicValueB32);
213 }
214 
215 // File: contracts/thirdparty/BytesUtil.sol
216 
217 //Mainly taken from https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
218 
219 library BytesUtil {
220     function slice(
221         bytes memory _bytes,
222         uint _start,
223         uint _length
224     )
225         internal
226         pure
227         returns (bytes memory)
228     {
229         require(_bytes.length >= (_start + _length));
230 
231         bytes memory tempBytes;
232 
233         assembly {
234             switch iszero(_length)
235             case 0 {
236                 // Get a location of some free memory and store it in tempBytes as
237                 // Solidity does for memory variables.
238                 tempBytes := mload(0x40)
239 
240                 // The first word of the slice result is potentially a partial
241                 // word read from the original array. To read it, we calculate
242                 // the length of that partial word and start copying that many
243                 // bytes into the array. The first word we copy will start with
244                 // data we don't care about, but the last `lengthmod` bytes will
245                 // land at the beginning of the contents of the new array. When
246                 // we're done copying, we overwrite the full first word with
247                 // the actual length of the slice.
248                 let lengthmod := and(_length, 31)
249 
250                 // The multiplication in the next line is necessary
251                 // because when slicing multiples of 32 bytes (lengthmod == 0)
252                 // the following copy loop was copying the origin's length
253                 // and then ending prematurely not copying everything it should.
254                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
255                 let end := add(mc, _length)
256 
257                 for {
258                     // The multiplication in the next line has the same exact purpose
259                     // as the one above.
260                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
261                 } lt(mc, end) {
262                     mc := add(mc, 0x20)
263                     cc := add(cc, 0x20)
264                 } {
265                     mstore(mc, mload(cc))
266                 }
267 
268                 mstore(tempBytes, _length)
269 
270                 //update free-memory pointer
271                 //allocating the array padded to 32 bytes like the compiler does now
272                 mstore(0x40, and(add(mc, 31), not(31)))
273             }
274             //if we want a zero-length slice let's just return a zero-length array
275             default {
276                 tempBytes := mload(0x40)
277 
278                 mstore(0x40, add(tempBytes, 0x20))
279             }
280         }
281 
282         return tempBytes;
283     }
284 
285     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
286         require(_bytes.length >= (_start + 20));
287         address tempAddress;
288 
289         assembly {
290             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
291         }
292 
293         return tempAddress;
294     }
295 
296     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
297         require(_bytes.length >= (_start + 1));
298         uint8 tempUint;
299 
300         assembly {
301             tempUint := mload(add(add(_bytes, 0x1), _start))
302         }
303 
304         return tempUint;
305     }
306 
307     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
308         require(_bytes.length >= (_start + 2));
309         uint16 tempUint;
310 
311         assembly {
312             tempUint := mload(add(add(_bytes, 0x2), _start))
313         }
314 
315         return tempUint;
316     }
317 
318     function toUint24(bytes memory _bytes, uint _start) internal  pure returns (uint24) {
319         require(_bytes.length >= (_start + 3));
320         uint24 tempUint;
321 
322         assembly {
323             tempUint := mload(add(add(_bytes, 0x3), _start))
324         }
325 
326         return tempUint;
327     }
328 
329     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
330         require(_bytes.length >= (_start + 4));
331         uint32 tempUint;
332 
333         assembly {
334             tempUint := mload(add(add(_bytes, 0x4), _start))
335         }
336 
337         return tempUint;
338     }
339 
340     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
341         require(_bytes.length >= (_start + 8));
342         uint64 tempUint;
343 
344         assembly {
345             tempUint := mload(add(add(_bytes, 0x8), _start))
346         }
347 
348         return tempUint;
349     }
350 
351     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
352         require(_bytes.length >= (_start + 12));
353         uint96 tempUint;
354 
355         assembly {
356             tempUint := mload(add(add(_bytes, 0xc), _start))
357         }
358 
359         return tempUint;
360     }
361 
362     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
363         require(_bytes.length >= (_start + 16));
364         uint128 tempUint;
365 
366         assembly {
367             tempUint := mload(add(add(_bytes, 0x10), _start))
368         }
369 
370         return tempUint;
371     }
372 
373     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
374         require(_bytes.length >= (_start + 32));
375         uint256 tempUint;
376 
377         assembly {
378             tempUint := mload(add(add(_bytes, 0x20), _start))
379         }
380 
381         return tempUint;
382     }
383 
384     function toBytes4(bytes memory _bytes, uint _start) internal  pure returns (bytes4) {
385         require(_bytes.length >= (_start + 4));
386         bytes4 tempBytes4;
387 
388         assembly {
389             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
390         }
391 
392         return tempBytes4;
393     }
394 
395     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
396         require(_bytes.length >= (_start + 32));
397         bytes32 tempBytes32;
398 
399         assembly {
400             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
401         }
402 
403         return tempBytes32;
404     }
405 
406     function fastSHA256(
407         bytes memory data
408         )
409         internal
410         view
411         returns (bytes32)
412     {
413         bytes32[] memory result = new bytes32[](1);
414         bool success;
415         assembly {
416              let ptr := add(data, 32)
417              success := staticcall(sub(gas(), 2000), 2, ptr, mload(data), add(result, 32), 32)
418         }
419         require(success, "SHA256_FAILED");
420         return result[0];
421     }
422 }
423 
424 // File: contracts/lib/MathUint.sol
425 
426 // Copyright 2017 Loopring Technology Limited.
427 
428 
429 /// @title Utility Functions for uint
430 /// @author Daniel Wang - <daniel@loopring.org>
431 library MathUint
432 {
433     function mul(
434         uint a,
435         uint b
436         )
437         internal
438         pure
439         returns (uint c)
440     {
441         c = a * b;
442         require(a == 0 || c / a == b, "MUL_OVERFLOW");
443     }
444 
445     function sub(
446         uint a,
447         uint b
448         )
449         internal
450         pure
451         returns (uint)
452     {
453         require(b <= a, "SUB_UNDERFLOW");
454         return a - b;
455     }
456 
457     function add(
458         uint a,
459         uint b
460         )
461         internal
462         pure
463         returns (uint c)
464     {
465         c = a + b;
466         require(c >= a, "ADD_OVERFLOW");
467     }
468 }
469 
470 // File: contracts/lib/SignatureUtil.sol
471 
472 // Copyright 2017 Loopring Technology Limited.
473 
474 
475 
476 
477 
478 
479 /// @title SignatureUtil
480 /// @author Daniel Wang - <daniel@loopring.org>
481 /// @dev This method supports multihash standard. Each signature's last byte indicates
482 ///      the signature's type.
483 library SignatureUtil
484 {
485     using BytesUtil     for bytes;
486     using MathUint      for uint;
487     using AddressUtil   for address;
488 
489     enum SignatureType {
490         ILLEGAL,
491         INVALID,
492         EIP_712,
493         ETH_SIGN,
494         WALLET   // deprecated
495     }
496 
497     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
498 
499     function verifySignatures(
500         bytes32          signHash,
501         address[] memory signers,
502         bytes[]   memory signatures
503         )
504         internal
505         view
506         returns (bool)
507     {
508         require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
509         address lastSigner;
510         for (uint i = 0; i < signers.length; i++) {
511             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
512             lastSigner = signers[i];
513             if (!verifySignature(signHash, signers[i], signatures[i])) {
514                 return false;
515             }
516         }
517         return true;
518     }
519 
520     function verifySignature(
521         bytes32        signHash,
522         address        signer,
523         bytes   memory signature
524         )
525         internal
526         view
527         returns (bool)
528     {
529         if (signer == address(0)) {
530             return false;
531         }
532 
533         return signer.isContract()?
534             verifyERC1271Signature(signHash, signer, signature):
535             verifyEOASignature(signHash, signer, signature);
536     }
537 
538     function recoverECDSASigner(
539         bytes32      signHash,
540         bytes memory signature
541         )
542         internal
543         pure
544         returns (address)
545     {
546         if (signature.length != 65) {
547             return address(0);
548         }
549 
550         bytes32 r;
551         bytes32 s;
552         uint8   v;
553         // we jump 32 (0x20) as the first slot of bytes contains the length
554         // we jump 65 (0x41) per signature
555         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
556         assembly {
557             r := mload(add(signature, 0x20))
558             s := mload(add(signature, 0x40))
559             v := and(mload(add(signature, 0x41)), 0xff)
560         }
561         // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
562         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
563             return address(0);
564         }
565         if (v == 27 || v == 28) {
566             return ecrecover(signHash, v, r, s);
567         } else {
568             return address(0);
569         }
570     }
571 
572     function verifyEOASignature(
573         bytes32        signHash,
574         address        signer,
575         bytes   memory signature
576         )
577         private
578         pure
579         returns (bool success)
580     {
581         if (signer == address(0)) {
582             return false;
583         }
584 
585         uint signatureTypeOffset = signature.length.sub(1);
586         SignatureType signatureType = SignatureType(signature.toUint8(signatureTypeOffset));
587 
588         // Strip off the last byte of the signature by updating the length
589         assembly {
590             mstore(signature, signatureTypeOffset)
591         }
592 
593         if (signatureType == SignatureType.EIP_712) {
594             success = (signer == recoverECDSASigner(signHash, signature));
595         } else if (signatureType == SignatureType.ETH_SIGN) {
596             bytes32 hash = keccak256(
597                 abi.encodePacked("\x19Ethereum Signed Message:\n32", signHash)
598             );
599             success = (signer == recoverECDSASigner(hash, signature));
600         } else {
601             success = false;
602         }
603 
604         // Restore the signature length
605         assembly {
606             mstore(signature, add(signatureTypeOffset, 1))
607         }
608 
609         return success;
610     }
611 
612     function verifyERC1271Signature(
613         bytes32 signHash,
614         address signer,
615         bytes   memory signature
616         )
617         private
618         view
619         returns (bool)
620     {
621         bytes memory callData = abi.encodeWithSelector(
622             ERC1271.isValidSignature.selector,
623             signHash,
624             signature
625         );
626         (bool success, bytes memory result) = signer.staticcall(callData);
627         return (
628             success &&
629             result.length == 32 &&
630             result.toBytes4(0) == ERC1271_MAGICVALUE
631         );
632     }
633 }
634 
635 // File: contracts/lib/EIP712.sol
636 
637 // Copyright 2017 Loopring Technology Limited.
638 
639 library EIP712
640 {
641     struct Domain {
642         string  name;
643         string  version;
644         address verifyingContract;
645     }
646 
647     bytes32 constant internal EIP712_DOMAIN_TYPEHASH = keccak256(
648         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
649     );
650 
651     string constant internal EIP191_HEADER = "\x19\x01";
652 
653     function hash(Domain memory domain)
654         internal
655         pure
656         returns (bytes32)
657     {
658         uint _chainid;
659         assembly { _chainid := chainid() }
660 
661         return keccak256(
662             abi.encode(
663                 EIP712_DOMAIN_TYPEHASH,
664                 keccak256(bytes(domain.name)),
665                 keccak256(bytes(domain.version)),
666                 _chainid,
667                 domain.verifyingContract
668             )
669         );
670     }
671 
672     function hashPacked(
673         bytes32 domainSeperator,
674         bytes   memory encodedData
675         )
676         internal
677         pure
678         returns (bytes32)
679     {
680         return keccak256(
681             abi.encodePacked(EIP191_HEADER, domainSeperator, keccak256(encodedData))
682         );
683     }
684 }
685 
686 // File: contracts/lib/Ownable.sol
687 
688 // Copyright 2017 Loopring Technology Limited.
689 
690 
691 /// @title Ownable
692 /// @author Brecht Devos - <brecht@loopring.org>
693 /// @dev The Ownable contract has an owner address, and provides basic
694 ///      authorization control functions, this simplifies the implementation of
695 ///      "user permissions".
696 contract Ownable
697 {
698     address public owner;
699 
700     event OwnershipTransferred(
701         address indexed previousOwner,
702         address indexed newOwner
703     );
704 
705     /// @dev The Ownable constructor sets the original `owner` of the contract
706     ///      to the sender.
707     constructor()
708     {
709         owner = msg.sender;
710     }
711 
712     /// @dev Throws if called by any account other than the owner.
713     modifier onlyOwner()
714     {
715         require(msg.sender == owner, "UNAUTHORIZED");
716         _;
717     }
718 
719     /// @dev Allows the current owner to transfer control of the contract to a
720     ///      new owner.
721     /// @param newOwner The address to transfer ownership to.
722     function transferOwnership(
723         address newOwner
724         )
725         public
726         virtual
727         onlyOwner
728     {
729         require(newOwner != address(0), "ZERO_ADDRESS");
730         emit OwnershipTransferred(owner, newOwner);
731         owner = newOwner;
732     }
733 
734     function renounceOwnership()
735         public
736         onlyOwner
737     {
738         emit OwnershipTransferred(owner, address(0));
739         owner = address(0);
740     }
741 }
742 
743 // File: contracts/iface/Module.sol
744 
745 // Copyright 2017 Loopring Technology Limited.
746 
747 
748 
749 
750 /// @title Module
751 /// @dev Base contract for all smart wallet modules.
752 ///
753 /// @author Daniel Wang - <daniel@loopring.org>
754 interface Module
755 {
756     /// @dev Activates the module for the given wallet (msg.sender) after the module is added.
757     ///      Warning: this method shall ONLY be callable by a wallet.
758     function activate() external;
759 
760     /// @dev Deactivates the module for the given wallet (msg.sender) before the module is removed.
761     ///      Warning: this method shall ONLY be callable by a wallet.
762     function deactivate() external;
763 }
764 
765 // File: contracts/lib/ERC20.sol
766 
767 // Copyright 2017 Loopring Technology Limited.
768 
769 
770 /// @title ERC20 Token Interface
771 /// @dev see https://github.com/ethereum/EIPs/issues/20
772 /// @author Daniel Wang - <daniel@loopring.org>
773 abstract contract ERC20
774 {
775     function totalSupply()
776         public
777         view
778         virtual
779         returns (uint);
780 
781     function balanceOf(
782         address who
783         )
784         public
785         view
786         virtual
787         returns (uint);
788 
789     function allowance(
790         address owner,
791         address spender
792         )
793         public
794         view
795         virtual
796         returns (uint);
797 
798     function transfer(
799         address to,
800         uint value
801         )
802         public
803         virtual
804         returns (bool);
805 
806     function transferFrom(
807         address from,
808         address to,
809         uint    value
810         )
811         public
812         virtual
813         returns (bool);
814 
815     function approve(
816         address spender,
817         uint    value
818         )
819         public
820         virtual
821         returns (bool);
822 }
823 
824 // File: contracts/iface/ModuleRegistry.sol
825 
826 // Copyright 2017 Loopring Technology Limited.
827 
828 
829 /// @title ModuleRegistry
830 /// @dev A registry for modules.
831 ///
832 /// @author Daniel Wang - <daniel@loopring.org>
833 interface ModuleRegistry
834 {
835 	/// @dev Registers and enables a new module.
836     function registerModule(address module) external;
837 
838     /// @dev Disables a module
839     function disableModule(address module) external;
840 
841     /// @dev Returns true if the module is registered and enabled.
842     function isModuleEnabled(address module) external view returns (bool);
843 
844     /// @dev Returns the list of enabled modules.
845     function enabledModules() external view returns (address[] memory _modules);
846 
847     /// @dev Returns the number of enbaled modules.
848     function numOfEnabledModules() external view returns (uint);
849 
850     /// @dev Returns true if the module is ever registered.
851     function isModuleRegistered(address module) external view returns (bool);
852 }
853 
854 // File: contracts/base/Controller.sol
855 
856 // Copyright 2017 Loopring Technology Limited.
857 
858 
859 
860 /// @title Controller
861 ///
862 /// @author Daniel Wang - <daniel@loopring.org>
863 abstract contract Controller
864 {
865     function moduleRegistry()
866         external
867         view
868         virtual
869         returns (ModuleRegistry);
870 
871     function walletFactory()
872         external
873         view
874         virtual
875         returns (address);
876 }
877 
878 // File: contracts/iface/PriceOracle.sol
879 
880 // Copyright 2017 Loopring Technology Limited.
881 
882 
883 /// @title PriceOracle
884 interface PriceOracle
885 {
886     // @dev Return's the token's value in ETH
887     function tokenValue(address token, uint amount)
888         external
889         view
890         returns (uint value);
891 }
892 
893 // File: contracts/lib/Claimable.sol
894 
895 // Copyright 2017 Loopring Technology Limited.
896 
897 
898 
899 /// @title Claimable
900 /// @author Brecht Devos - <brecht@loopring.org>
901 /// @dev Extension for the Ownable contract, where the ownership needs
902 ///      to be claimed. This allows the new owner to accept the transfer.
903 contract Claimable is Ownable
904 {
905     address public pendingOwner;
906 
907     /// @dev Modifier throws if called by any account other than the pendingOwner.
908     modifier onlyPendingOwner() {
909         require(msg.sender == pendingOwner, "UNAUTHORIZED");
910         _;
911     }
912 
913     /// @dev Allows the current owner to set the pendingOwner address.
914     /// @param newOwner The address to transfer ownership to.
915     function transferOwnership(
916         address newOwner
917         )
918         public
919         override
920         onlyOwner
921     {
922         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
923         pendingOwner = newOwner;
924     }
925 
926     /// @dev Allows the pendingOwner address to finalize the transfer.
927     function claimOwnership()
928         public
929         onlyPendingOwner
930     {
931         emit OwnershipTransferred(owner, pendingOwner);
932         owner = pendingOwner;
933         pendingOwner = address(0);
934     }
935 }
936 
937 // File: contracts/base/DataStore.sol
938 
939 // Copyright 2017 Loopring Technology Limited.
940 
941 
942 
943 /// @title DataStore
944 /// @dev Modules share states by accessing the same storage instance.
945 ///      Using ModuleStorage will achieve better module decoupling.
946 ///
947 /// @author Daniel Wang - <daniel@loopring.org>
948 abstract contract DataStore
949 {
950     modifier onlyWalletModule(address wallet)
951     {
952         requireWalletModule(wallet);
953         _;
954     }
955 
956     function requireWalletModule(address wallet) view internal
957     {
958         require(Wallet(wallet).hasModule(msg.sender), "UNAUTHORIZED");
959     }
960 }
961 
962 // File: contracts/stores/HashStore.sol
963 
964 // Copyright 2017 Loopring Technology Limited.
965 
966 
967 
968 
969 /// @title HashStore
970 /// @dev This store maintains all hashes for SignedRequest.
971 contract HashStore is DataStore
972 {
973     // wallet => hash => consumed
974     mapping(address => mapping(bytes32 => bool)) public hashes;
975 
976     constructor() {}
977 
978     function verifyAndUpdate(address wallet, bytes32 hash)
979         external
980     {
981         require(!hashes[wallet][hash], "HASH_EXIST");
982         requireWalletModule(wallet);
983         hashes[wallet][hash] = true;
984     }
985 }
986 
987 // File: contracts/thirdparty/SafeCast.sol
988 
989 // Taken from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/SafeCast.sol
990 
991 
992 
993 /**
994  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
995  * checks.
996  *
997  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
998  * easily result in undesired exploitation or bugs, since developers usually
999  * assume that overflows raise errors. `SafeCast` restores this intuition by
1000  * reverting the transaction when such an operation overflows.
1001  *
1002  * Using this library instead of the unchecked operations eliminates an entire
1003  * class of bugs, so it's recommended to use it always.
1004  *
1005  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1006  * all math on `uint256` and `int256` and then downcasting.
1007  */
1008 library SafeCast {
1009 
1010     /**
1011      * @dev Returns the downcasted uint128 from uint256, reverting on
1012      * overflow (when the input is greater than largest uint128).
1013      *
1014      * Counterpart to Solidity's `uint128` operator.
1015      *
1016      * Requirements:
1017      *
1018      * - input must fit into 128 bits
1019      */
1020     function toUint128(uint256 value) internal pure returns (uint128) {
1021         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1022         return uint128(value);
1023     }
1024 
1025     /**
1026      * @dev Returns the downcasted uint96 from uint256, reverting on
1027      * overflow (when the input is greater than largest uint96).
1028      *
1029      * Counterpart to Solidity's `uint96` operator.
1030      *
1031      * Requirements:
1032      *
1033      * - input must fit into 96 bits
1034      */
1035     function toUint96(uint256 value) internal pure returns (uint96) {
1036         require(value < 2**96, "SafeCast: value doesn\'t fit in 96 bits");
1037         return uint96(value);
1038     }
1039 
1040     /**
1041      * @dev Returns the downcasted uint64 from uint256, reverting on
1042      * overflow (when the input is greater than largest uint64).
1043      *
1044      * Counterpart to Solidity's `uint64` operator.
1045      *
1046      * Requirements:
1047      *
1048      * - input must fit into 64 bits
1049      */
1050     function toUint64(uint256 value) internal pure returns (uint64) {
1051         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1052         return uint64(value);
1053     }
1054 
1055     /**
1056      * @dev Returns the downcasted uint32 from uint256, reverting on
1057      * overflow (when the input is greater than largest uint32).
1058      *
1059      * Counterpart to Solidity's `uint32` operator.
1060      *
1061      * Requirements:
1062      *
1063      * - input must fit into 32 bits
1064      */
1065     function toUint32(uint256 value) internal pure returns (uint32) {
1066         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1067         return uint32(value);
1068     }
1069 
1070     /**
1071      * @dev Returns the downcasted uint40 from uint256, reverting on
1072      * overflow (when the input is greater than largest uint40).
1073      *
1074      * Counterpart to Solidity's `uint32` operator.
1075      *
1076      * Requirements:
1077      *
1078      * - input must fit into 40 bits
1079      */
1080     function toUint40(uint256 value) internal pure returns (uint40) {
1081         require(value < 2**40, "SafeCast: value doesn\'t fit in 40 bits");
1082         return uint40(value);
1083     }
1084 
1085     /**
1086      * @dev Returns the downcasted uint16 from uint256, reverting on
1087      * overflow (when the input is greater than largest uint16).
1088      *
1089      * Counterpart to Solidity's `uint16` operator.
1090      *
1091      * Requirements:
1092      *
1093      * - input must fit into 16 bits
1094      */
1095     function toUint16(uint256 value) internal pure returns (uint16) {
1096         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1097         return uint16(value);
1098     }
1099 
1100     /**
1101      * @dev Returns the downcasted uint8 from uint256, reverting on
1102      * overflow (when the input is greater than largest uint8).
1103      *
1104      * Counterpart to Solidity's `uint8` operator.
1105      *
1106      * Requirements:
1107      *
1108      * - input must fit into 8 bits.
1109      */
1110     function toUint8(uint256 value) internal pure returns (uint8) {
1111         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1112         return uint8(value);
1113     }
1114 
1115     /**
1116      * @dev Converts a signed int256 into an unsigned uint256.
1117      *
1118      * Requirements:
1119      *
1120      * - input must be greater than or equal to 0.
1121      */
1122     function toUint256(int256 value) internal pure returns (uint256) {
1123         require(value >= 0, "SafeCast: value must be positive");
1124         return uint256(value);
1125     }
1126 
1127     /**
1128      * @dev Returns the downcasted int128 from int256, reverting on
1129      * overflow (when the input is less than smallest int128 or
1130      * greater than largest int128).
1131      *
1132      * Counterpart to Solidity's `int128` operator.
1133      *
1134      * Requirements:
1135      *
1136      * - input must fit into 128 bits
1137      *
1138      * _Available since v3.1._
1139      */
1140     function toInt128(int256 value) internal pure returns (int128) {
1141         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
1142         return int128(value);
1143     }
1144 
1145     /**
1146      * @dev Returns the downcasted int64 from int256, reverting on
1147      * overflow (when the input is less than smallest int64 or
1148      * greater than largest int64).
1149      *
1150      * Counterpart to Solidity's `int64` operator.
1151      *
1152      * Requirements:
1153      *
1154      * - input must fit into 64 bits
1155      *
1156      * _Available since v3.1._
1157      */
1158     function toInt64(int256 value) internal pure returns (int64) {
1159         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
1160         return int64(value);
1161     }
1162 
1163     /**
1164      * @dev Returns the downcasted int32 from int256, reverting on
1165      * overflow (when the input is less than smallest int32 or
1166      * greater than largest int32).
1167      *
1168      * Counterpart to Solidity's `int32` operator.
1169      *
1170      * Requirements:
1171      *
1172      * - input must fit into 32 bits
1173      *
1174      * _Available since v3.1._
1175      */
1176     function toInt32(int256 value) internal pure returns (int32) {
1177         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
1178         return int32(value);
1179     }
1180 
1181     /**
1182      * @dev Returns the downcasted int16 from int256, reverting on
1183      * overflow (when the input is less than smallest int16 or
1184      * greater than largest int16).
1185      *
1186      * Counterpart to Solidity's `int16` operator.
1187      *
1188      * Requirements:
1189      *
1190      * - input must fit into 16 bits
1191      *
1192      * _Available since v3.1._
1193      */
1194     function toInt16(int256 value) internal pure returns (int16) {
1195         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
1196         return int16(value);
1197     }
1198 
1199     /**
1200      * @dev Returns the downcasted int8 from int256, reverting on
1201      * overflow (when the input is less than smallest int8 or
1202      * greater than largest int8).
1203      *
1204      * Counterpart to Solidity's `int8` operator.
1205      *
1206      * Requirements:
1207      *
1208      * - input must fit into 8 bits.
1209      *
1210      * _Available since v3.1._
1211      */
1212     function toInt8(int256 value) internal pure returns (int8) {
1213         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
1214         return int8(value);
1215     }
1216 
1217     /**
1218      * @dev Converts an unsigned uint256 into a signed int256.
1219      *
1220      * Requirements:
1221      *
1222      * - input must be less than or equal to maxInt256.
1223      */
1224     function toInt256(uint256 value) internal pure returns (int256) {
1225         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1226         return int256(value);
1227     }
1228 }
1229 
1230 // File: contracts/stores/QuotaStore.sol
1231 
1232 // Copyright 2017 Loopring Technology Limited.
1233 
1234 
1235 
1236 
1237 
1238 /// @title QuotaStore
1239 /// @dev This store maintains daily spending quota for each wallet.
1240 ///      A rolling daily limit is used.
1241 contract QuotaStore is DataStore
1242 {
1243     using MathUint for uint;
1244     using SafeCast for uint;
1245 
1246     uint128 public constant MAX_QUOTA = uint128(-1);
1247 
1248     // Optimized to fit into 64 bytes (2 slots)
1249     struct Quota
1250     {
1251         uint128 currentQuota;
1252         uint128 pendingQuota;
1253         uint128 spentAmount;
1254         uint64  spentTimestamp;
1255         uint64  pendingUntil;
1256     }
1257 
1258     mapping (address => Quota) public quotas;
1259 
1260     event QuotaScheduled(
1261         address wallet,
1262         uint    pendingQuota,
1263         uint64  pendingUntil
1264     );
1265 
1266     constructor()
1267         DataStore()
1268     {
1269     }
1270 
1271     // 0 for newQuota indicates unlimited quota, or daily quota is disabled.
1272     function changeQuota(
1273         address wallet,
1274         uint    newQuota,
1275         uint    effectiveTime
1276         )
1277         external
1278         onlyWalletModule(wallet)
1279     {
1280         require(newQuota <= MAX_QUOTA, "INVALID_VALUE");
1281         if (newQuota == MAX_QUOTA) {
1282             newQuota = 0;
1283         }
1284 
1285         quotas[wallet].currentQuota = currentQuota(wallet).toUint128();
1286         quotas[wallet].pendingQuota = newQuota.toUint128();
1287         quotas[wallet].pendingUntil = effectiveTime.toUint64();
1288 
1289         emit QuotaScheduled(
1290             wallet,
1291             newQuota,
1292             quotas[wallet].pendingUntil
1293         );
1294     }
1295 
1296     function checkAndAddToSpent(
1297         address     wallet,
1298         address     token,
1299         uint        amount,
1300         PriceOracle priceOracle
1301         )
1302         external
1303     {
1304         Quota memory q = quotas[wallet];
1305         uint available = _availableQuota(q);
1306         if (available != MAX_QUOTA) {
1307             uint value = (token == address(0)) ?
1308                 amount :
1309                 priceOracle.tokenValue(token, amount);
1310             if (value > 0) {
1311                 require(available >= value, "QUOTA_EXCEEDED");
1312                 requireWalletModule(wallet);
1313                 _addToSpent(wallet, q, value);
1314             }
1315         }
1316     }
1317 
1318     function addToSpent(
1319         address wallet,
1320         uint    amount
1321         )
1322         external
1323         onlyWalletModule(wallet)
1324     {
1325         _addToSpent(wallet, quotas[wallet], amount);
1326     }
1327 
1328     // Returns 0 to indiciate unlimited quota
1329     function currentQuota(address wallet)
1330         public
1331         view
1332         returns (uint)
1333     {
1334         return _currentQuota(quotas[wallet]);
1335     }
1336 
1337     // Returns 0 to indiciate unlimited quota
1338     function pendingQuota(address wallet)
1339         public
1340         view
1341         returns (
1342             uint __pendingQuota,
1343             uint __pendingUntil
1344         )
1345     {
1346         return _pendingQuota(quotas[wallet]);
1347     }
1348 
1349     function spentQuota(address wallet)
1350         public
1351         view
1352         returns (uint)
1353     {
1354         return _spentQuota(quotas[wallet]);
1355     }
1356 
1357     function availableQuota(address wallet)
1358         public
1359         view
1360         returns (uint)
1361     {
1362         return _availableQuota(quotas[wallet]);
1363     }
1364 
1365     function hasEnoughQuota(
1366         address wallet,
1367         uint    requiredAmount
1368         )
1369         public
1370         view
1371         returns (bool)
1372     {
1373         return _hasEnoughQuota(quotas[wallet], requiredAmount);
1374     }
1375 
1376     // Internal
1377 
1378     function _currentQuota(Quota memory q)
1379         private
1380         view
1381         returns (uint)
1382     {
1383         return q.pendingUntil <= block.timestamp ? q.pendingQuota : q.currentQuota;
1384     }
1385 
1386     function _pendingQuota(Quota memory q)
1387         private
1388         view
1389         returns (
1390             uint __pendingQuota,
1391             uint __pendingUntil
1392         )
1393     {
1394         if (q.pendingUntil > 0 && q.pendingUntil > block.timestamp) {
1395             __pendingQuota = q.pendingQuota;
1396             __pendingUntil = q.pendingUntil;
1397         }
1398     }
1399 
1400     function _spentQuota(Quota memory q)
1401         private
1402         view
1403         returns (uint)
1404     {
1405         uint timeSinceLastSpent = block.timestamp.sub(q.spentTimestamp);
1406         if (timeSinceLastSpent < 1 days) {
1407             return uint(q.spentAmount).sub(timeSinceLastSpent.mul(q.spentAmount) / 1 days);
1408         } else {
1409             return 0;
1410         }
1411     }
1412 
1413     function _availableQuota(Quota memory q)
1414         private
1415         view
1416         returns (uint)
1417     {
1418         uint quota = _currentQuota(q);
1419         if (quota == 0) {
1420             return MAX_QUOTA;
1421         }
1422         uint spent = _spentQuota(q);
1423         return quota > spent ? quota - spent : 0;
1424     }
1425 
1426     function _hasEnoughQuota(
1427         Quota   memory q,
1428         uint    requiredAmount
1429         )
1430         private
1431         view
1432         returns (bool)
1433     {
1434         return _availableQuota(q) >= requiredAmount;
1435     }
1436 
1437     function _addToSpent(
1438         address wallet,
1439         Quota   memory q,
1440         uint    amount
1441         )
1442         private
1443     {
1444         Quota storage s = quotas[wallet];
1445         s.spentAmount = _spentQuota(q).add(amount).toUint128();
1446         s.spentTimestamp = uint64(block.timestamp);
1447     }
1448 }
1449 
1450 // File: contracts/stores/Data.sol
1451 
1452 // Copyright 2017 Loopring Technology Limited.
1453 
1454 
1455 library Data
1456 {
1457     enum GuardianStatus {
1458         REMOVE,    // Being removed or removed after validUntil timestamp
1459         ADD        // Being added or added after validSince timestamp.
1460     }
1461 
1462     // Optimized to fit into 32 bytes (1 slot)
1463     struct Guardian
1464     {
1465         address addr;
1466         uint8   status;
1467         uint64  timestamp; // validSince if status = ADD; validUntil if adding = REMOVE;
1468     }
1469 }
1470 
1471 // File: contracts/stores/GuardianStore.sol
1472 
1473 // Copyright 2017 Loopring Technology Limited.
1474 
1475 
1476 
1477 
1478 
1479 
1480 /// @title GuardianStore
1481 ///
1482 /// @author Daniel Wang - <daniel@loopring.org>
1483 abstract contract GuardianStore is DataStore
1484 {
1485     using MathUint      for uint;
1486     using SafeCast      for uint;
1487 
1488     struct Wallet
1489     {
1490         address    inheritor;
1491         uint32     inheritWaitingPeriod;
1492         uint64     lastActive; // the latest timestamp the owner is considered to be active
1493         bool       locked;
1494 
1495         Data.Guardian[]            guardians;
1496         mapping (address => uint)  guardianIdx;
1497     }
1498 
1499     mapping (address => Wallet) public wallets;
1500 
1501     constructor() DataStore() {}
1502 
1503     function isGuardian(
1504         address wallet,
1505         address addr,
1506         bool    includePendingAddition
1507         )
1508         public
1509         view
1510         returns (bool)
1511     {
1512         Data.Guardian memory g = _getGuardian(wallet, addr);
1513         return _isActiveOrPendingAddition(g, includePendingAddition);
1514     }
1515 
1516     function guardians(
1517         address wallet,
1518         bool    includePendingAddition
1519         )
1520         public
1521         view
1522         returns (Data.Guardian[] memory _guardians)
1523     {
1524         Wallet storage w = wallets[wallet];
1525         _guardians = new Data.Guardian[](w.guardians.length);
1526         uint index = 0;
1527         for (uint i = 0; i < w.guardians.length; i++) {
1528             Data.Guardian memory g = w.guardians[i];
1529             if (_isActiveOrPendingAddition(g, includePendingAddition)) {
1530                 _guardians[index] = g;
1531                 index++;
1532             }
1533         }
1534         assembly { mstore(_guardians, index) }
1535     }
1536 
1537     function numGuardians(
1538         address wallet,
1539         bool    includePendingAddition
1540         )
1541         public
1542         view
1543         returns (uint count)
1544     {
1545         Wallet storage w = wallets[wallet];
1546         for (uint i = 0; i < w.guardians.length; i++) {
1547             Data.Guardian memory g = w.guardians[i];
1548             if (_isActiveOrPendingAddition(g, includePendingAddition)) {
1549                 count++;
1550             }
1551         }
1552     }
1553 
1554     function removeAllGuardians(address wallet)
1555         external
1556     {
1557         Wallet storage w = wallets[wallet];
1558         uint size = w.guardians.length;
1559         if (size == 0) return;
1560 
1561         requireWalletModule(wallet);
1562         for (uint i = 0; i < w.guardians.length; i++) {
1563             delete w.guardianIdx[w.guardians[i].addr];
1564         }
1565         delete w.guardians;
1566     }
1567 
1568     function cancelPendingGuardians(address wallet)
1569         external
1570     {
1571         bool cancelled = false;
1572         Wallet storage w = wallets[wallet];
1573         for (uint i = 0; i < w.guardians.length; i++) {
1574             Data.Guardian memory g = w.guardians[i];
1575             if (_isPendingAddition(g)) {
1576                 w.guardians[i].status = uint8(Data.GuardianStatus.REMOVE);
1577                 w.guardians[i].timestamp = 0;
1578                 cancelled = true;
1579             }
1580             if (_isPendingRemoval(g)) {
1581                 w.guardians[i].status = uint8(Data.GuardianStatus.ADD);
1582                 w.guardians[i].timestamp = 0;
1583                 cancelled = true;
1584             }
1585         }
1586         if (cancelled) {
1587             requireWalletModule(wallet);
1588         }
1589         _cleanRemovedGuardians(wallet, true);
1590     }
1591 
1592     function cleanRemovedGuardians(address wallet)
1593         external
1594     {
1595         _cleanRemovedGuardians(wallet, true);
1596     }
1597 
1598     function addGuardian(
1599         address wallet,
1600         address addr,
1601         uint    validSince,
1602         bool    alwaysOverride
1603         )
1604         external
1605         onlyWalletModule(wallet)
1606         returns (uint)
1607     {
1608         require(validSince >= block.timestamp, "INVALID_VALID_SINCE");
1609         require(addr != address(0), "ZERO_ADDRESS");
1610 
1611         Wallet storage w = wallets[wallet];
1612         uint pos = w.guardianIdx[addr];
1613 
1614         if(pos == 0) {
1615             // Add the new guardian
1616             Data.Guardian memory g = Data.Guardian(
1617                 addr,
1618                 uint8(Data.GuardianStatus.ADD),
1619                 validSince.toUint64()
1620             );
1621             w.guardians.push(g);
1622             w.guardianIdx[addr] = w.guardians.length;
1623 
1624             _cleanRemovedGuardians(wallet, false);
1625             return validSince;
1626         }
1627 
1628         Data.Guardian memory g = w.guardians[pos - 1];
1629 
1630         if (_isRemoved(g)) {
1631             w.guardians[pos - 1].status = uint8(Data.GuardianStatus.ADD);
1632             w.guardians[pos - 1].timestamp = validSince.toUint64();
1633             return validSince;
1634         }
1635 
1636         if (_isPendingRemoval(g)) {
1637             w.guardians[pos - 1].status = uint8(Data.GuardianStatus.ADD);
1638             w.guardians[pos - 1].timestamp = 0;
1639             return 0;
1640         }
1641 
1642         if (_isPendingAddition(g)) {
1643             if (!alwaysOverride) return g.timestamp;
1644 
1645             w.guardians[pos - 1].timestamp = validSince.toUint64();
1646             return validSince;
1647         }
1648 
1649         require(_isAdded(g), "UNEXPECTED_RESULT");
1650         return 0;
1651     }
1652 
1653     function removeGuardian(
1654         address wallet,
1655         address addr,
1656         uint    validUntil,
1657         bool    alwaysOverride
1658         )
1659         external
1660         onlyWalletModule(wallet)
1661         returns (uint)
1662     {
1663         require(validUntil >= block.timestamp, "INVALID_VALID_UNTIL");
1664         require(addr != address(0), "ZERO_ADDRESS");
1665 
1666         Wallet storage w = wallets[wallet];
1667         uint pos = w.guardianIdx[addr];
1668         require(pos > 0, "GUARDIAN_NOT_EXISTS");
1669 
1670         Data.Guardian memory g = w.guardians[pos - 1];
1671 
1672         if (_isAdded(g)) {
1673             w.guardians[pos - 1].status = uint8(Data.GuardianStatus.REMOVE);
1674             w.guardians[pos - 1].timestamp = validUntil.toUint64();
1675             return validUntil;
1676         }
1677 
1678         if (_isPendingAddition(g)) {
1679             w.guardians[pos - 1].status = uint8(Data.GuardianStatus.REMOVE);
1680             w.guardians[pos - 1].timestamp = 0;
1681             return 0;
1682         }
1683 
1684         if (_isPendingRemoval(g)) {
1685             if (!alwaysOverride) return g.timestamp;
1686 
1687             w.guardians[pos - 1].timestamp = validUntil.toUint64();
1688             return validUntil;
1689         }
1690 
1691         require(_isRemoved(g), "UNEXPECTED_RESULT");
1692         return 0;
1693     }
1694 
1695     // ---- internal functions ---
1696 
1697     function _getGuardian(
1698         address wallet,
1699         address addr
1700         )
1701         private
1702         view
1703         returns (Data.Guardian memory)
1704     {
1705         Wallet storage w = wallets[wallet];
1706         uint pos = w.guardianIdx[addr];
1707         if (pos > 0) {
1708             return w.guardians[pos - 1];
1709         }
1710     }
1711 
1712     function _isAdded(Data.Guardian memory guardian)
1713         private
1714         view
1715         returns (bool)
1716     {
1717         return guardian.status == uint8(Data.GuardianStatus.ADD) &&
1718             guardian.timestamp <= block.timestamp;
1719     }
1720 
1721     function _isPendingAddition(Data.Guardian memory guardian)
1722         private
1723         view
1724         returns (bool)
1725     {
1726         return guardian.status == uint8(Data.GuardianStatus.ADD) &&
1727             guardian.timestamp > block.timestamp;
1728     }
1729 
1730     function _isRemoved(Data.Guardian memory guardian)
1731         private
1732         view
1733         returns (bool)
1734     {
1735         return guardian.status == uint8(Data.GuardianStatus.REMOVE) &&
1736             guardian.timestamp <= block.timestamp;
1737     }
1738 
1739     function _isPendingRemoval(Data.Guardian memory guardian)
1740         private
1741         view
1742         returns (bool)
1743     {
1744          return guardian.status == uint8(Data.GuardianStatus.REMOVE) &&
1745             guardian.timestamp > block.timestamp;
1746     }
1747 
1748     function _isActive(Data.Guardian memory guardian)
1749         private
1750         view
1751         returns (bool)
1752     {
1753         return _isAdded(guardian) || _isPendingRemoval(guardian);
1754     }
1755 
1756     function _isActiveOrPendingAddition(
1757         Data.Guardian memory guardian,
1758         bool includePendingAddition
1759         )
1760         private
1761         view
1762         returns (bool)
1763     {
1764         return _isActive(guardian) || includePendingAddition && _isPendingAddition(guardian);
1765     }
1766 
1767     function _cleanRemovedGuardians(
1768         address wallet,
1769         bool    force
1770         )
1771         private
1772     {
1773         Wallet storage w = wallets[wallet];
1774         uint count = w.guardians.length;
1775         if (!force && count < 10) return;
1776 
1777         for (int i = int(count) - 1; i >= 0; i--) {
1778             Data.Guardian memory g = w.guardians[uint(i)];
1779             if (_isRemoved(g)) {
1780                 Data.Guardian memory lastGuardian = w.guardians[w.guardians.length - 1];
1781 
1782                 if (g.addr != lastGuardian.addr) {
1783                     w.guardians[uint(i)] = lastGuardian;
1784                     w.guardianIdx[lastGuardian.addr] = uint(i) + 1;
1785                 }
1786                 w.guardians.pop();
1787                 delete w.guardianIdx[g.addr];
1788             }
1789         }
1790     }
1791 }
1792 
1793 // File: contracts/stores/SecurityStore.sol
1794 
1795 // Copyright 2017 Loopring Technology Limited.
1796 
1797 
1798 /// @title SecurityStore
1799 ///
1800 /// @author Daniel Wang - <daniel@loopring.org>
1801 contract SecurityStore is GuardianStore
1802 {
1803     using MathUint for uint;
1804     using SafeCast for uint;
1805 
1806     constructor() GuardianStore() {}
1807 
1808     function setLock(
1809         address wallet,
1810         bool    locked
1811         )
1812         external
1813         onlyWalletModule(wallet)
1814     {
1815         wallets[wallet].locked = locked;
1816     }
1817 
1818     function touchLastActive(address wallet)
1819         external
1820         onlyWalletModule(wallet)
1821     {
1822         wallets[wallet].lastActive = uint64(block.timestamp);
1823     }
1824 
1825     function touchLastActiveWhenRequired(
1826         address wallet,
1827         uint    minInternval
1828         )
1829         external
1830     {
1831         if (wallets[wallet].inheritor != address(0) &&
1832             block.timestamp > lastActive(wallet) + minInternval) {
1833             requireWalletModule(wallet);
1834             wallets[wallet].lastActive = uint64(block.timestamp);
1835         }
1836     }
1837 
1838     function setInheritor(
1839         address wallet,
1840         address who,
1841         uint32 _inheritWaitingPeriod
1842         )
1843         external
1844         onlyWalletModule(wallet)
1845     {
1846         wallets[wallet].inheritor = who;
1847         wallets[wallet].inheritWaitingPeriod = _inheritWaitingPeriod;
1848         wallets[wallet].lastActive = uint64(block.timestamp);
1849     }
1850 
1851     function isLocked(address wallet)
1852         public
1853         view
1854         returns (bool)
1855     {
1856         return wallets[wallet].locked;
1857     }
1858 
1859     function lastActive(address wallet)
1860         public
1861         view
1862         returns (uint)
1863     {
1864         return wallets[wallet].lastActive;
1865     }
1866 
1867     function inheritor(address wallet)
1868         public
1869         view
1870         returns (
1871             address _who,
1872             uint    _effectiveTimestamp
1873         )
1874     {
1875         address _inheritor = wallets[wallet].inheritor;
1876         if (_inheritor == address(0)) {
1877              return (address(0), 0);
1878         }
1879 
1880         uint32 _inheritWaitingPeriod = wallets[wallet].inheritWaitingPeriod;
1881         if (_inheritWaitingPeriod == 0) {
1882             return (address(0), 0);
1883         }
1884 
1885         uint64 _lastActive = wallets[wallet].lastActive;
1886 
1887         if (_lastActive == 0) {
1888             _lastActive = uint64(block.timestamp);
1889         }
1890 
1891         _who = _inheritor;
1892         _effectiveTimestamp = _lastActive + _inheritWaitingPeriod;
1893     }
1894 }
1895 
1896 // File: contracts/lib/AddressSet.sol
1897 
1898 // Copyright 2017 Loopring Technology Limited.
1899 
1900 
1901 /// @title AddressSet
1902 /// @author Daniel Wang - <daniel@loopring.org>
1903 contract AddressSet
1904 {
1905     struct Set
1906     {
1907         address[] addresses;
1908         mapping (address => uint) positions;
1909         uint count;
1910     }
1911     mapping (bytes32 => Set) private sets;
1912 
1913     function addAddressToSet(
1914         bytes32 key,
1915         address addr,
1916         bool    maintainList
1917         ) internal
1918     {
1919         Set storage set = sets[key];
1920         require(set.positions[addr] == 0, "ALREADY_IN_SET");
1921 
1922         if (maintainList) {
1923             require(set.addresses.length == set.count, "PREVIOUSLY_NOT_MAINTAILED");
1924             set.addresses.push(addr);
1925         } else {
1926             require(set.addresses.length == 0, "MUST_MAINTAIN");
1927         }
1928 
1929         set.count += 1;
1930         set.positions[addr] = set.count;
1931     }
1932 
1933     function removeAddressFromSet(
1934         bytes32 key,
1935         address addr
1936         )
1937         internal
1938     {
1939         Set storage set = sets[key];
1940         uint pos = set.positions[addr];
1941         require(pos != 0, "NOT_IN_SET");
1942 
1943         delete set.positions[addr];
1944         set.count -= 1;
1945 
1946         if (set.addresses.length > 0) {
1947             address lastAddr = set.addresses[set.count];
1948             if (lastAddr != addr) {
1949                 set.addresses[pos - 1] = lastAddr;
1950                 set.positions[lastAddr] = pos;
1951             }
1952             set.addresses.pop();
1953         }
1954     }
1955 
1956     function removeSet(bytes32 key)
1957         internal
1958     {
1959         delete sets[key];
1960     }
1961 
1962     function isAddressInSet(
1963         bytes32 key,
1964         address addr
1965         )
1966         internal
1967         view
1968         returns (bool)
1969     {
1970         return sets[key].positions[addr] != 0;
1971     }
1972 
1973     function numAddressesInSet(bytes32 key)
1974         internal
1975         view
1976         returns (uint)
1977     {
1978         Set storage set = sets[key];
1979         return set.count;
1980     }
1981 
1982     function addressesInSet(bytes32 key)
1983         internal
1984         view
1985         returns (address[] memory)
1986     {
1987         Set storage set = sets[key];
1988         require(set.count == set.addresses.length, "NOT_MAINTAINED");
1989         return sets[key].addresses;
1990     }
1991 }
1992 
1993 // File: contracts/lib/OwnerManagable.sol
1994 
1995 // Copyright 2017 Loopring Technology Limited.
1996 
1997 
1998 
1999 
2000 contract OwnerManagable is Claimable, AddressSet
2001 {
2002     bytes32 internal constant MANAGER = keccak256("__MANAGED__");
2003 
2004     event ManagerAdded  (address indexed manager);
2005     event ManagerRemoved(address indexed manager);
2006 
2007     modifier onlyManager
2008     {
2009         require(isManager(msg.sender), "NOT_MANAGER");
2010         _;
2011     }
2012 
2013     modifier onlyOwnerOrManager
2014     {
2015         require(msg.sender == owner || isManager(msg.sender), "NOT_OWNER_OR_MANAGER");
2016         _;
2017     }
2018 
2019     constructor() Claimable() {}
2020 
2021     /// @dev Gets the managers.
2022     /// @return The list of managers.
2023     function managers()
2024         public
2025         view
2026         returns (address[] memory)
2027     {
2028         return addressesInSet(MANAGER);
2029     }
2030 
2031     /// @dev Gets the number of managers.
2032     /// @return The numer of managers.
2033     function numManagers()
2034         public
2035         view
2036         returns (uint)
2037     {
2038         return numAddressesInSet(MANAGER);
2039     }
2040 
2041     /// @dev Checks if an address is a manger.
2042     /// @param addr The address to check.
2043     /// @return True if the address is a manager, False otherwise.
2044     function isManager(address addr)
2045         public
2046         view
2047         returns (bool)
2048     {
2049         return isAddressInSet(MANAGER, addr);
2050     }
2051 
2052     /// @dev Adds a new manager.
2053     /// @param manager The new address to add.
2054     function addManager(address manager)
2055         public
2056         onlyOwner
2057     {
2058         addManagerInternal(manager);
2059     }
2060 
2061     /// @dev Removes a manager.
2062     /// @param manager The manager to remove.
2063     function removeManager(address manager)
2064         public
2065         onlyOwner
2066     {
2067         removeAddressFromSet(MANAGER, manager);
2068         emit ManagerRemoved(manager);
2069     }
2070 
2071     function addManagerInternal(address manager)
2072         internal
2073     {
2074         addAddressToSet(MANAGER, manager, true);
2075         emit ManagerAdded(manager);
2076     }
2077 }
2078 
2079 // File: contracts/stores/WhitelistStore.sol
2080 
2081 // Copyright 2017 Loopring Technology Limited.
2082 
2083 
2084 
2085 
2086 
2087 /// @title WhitelistStore
2088 /// @dev This store maintains a wallet's whitelisted addresses.
2089 contract WhitelistStore is DataStore, AddressSet, OwnerManagable
2090 {
2091     bytes32 internal constant DAPPS = keccak256("__DAPPS__");
2092 
2093     // wallet => whitelisted_addr => effective_since
2094     mapping(address => mapping(address => uint)) public effectiveTimeMap;
2095 
2096     event Whitelisted(
2097         address wallet,
2098         address addr,
2099         bool    whitelisted,
2100         uint    effectiveTime
2101     );
2102 
2103     event DappWhitelisted(
2104         address addr,
2105         bool    whitelisted
2106     );
2107 
2108     constructor() DataStore() {}
2109 
2110     function addToWhitelist(
2111         address wallet,
2112         address addr,
2113         uint    effectiveTime
2114         )
2115         external
2116         onlyWalletModule(wallet)
2117     {
2118         addAddressToSet(_walletKey(wallet), addr, true);
2119         uint effective = effectiveTime >= block.timestamp ? effectiveTime : block.timestamp;
2120         effectiveTimeMap[wallet][addr] = effective;
2121         emit Whitelisted(wallet, addr, true, effective);
2122     }
2123 
2124     function removeFromWhitelist(
2125         address wallet,
2126         address addr
2127         )
2128         external
2129         onlyWalletModule(wallet)
2130     {
2131         removeAddressFromSet(_walletKey(wallet), addr);
2132         delete effectiveTimeMap[wallet][addr];
2133         emit Whitelisted(wallet, addr, false, 0);
2134     }
2135 
2136     function addDapp(address addr)
2137         external
2138         onlyManager
2139     {
2140         addAddressToSet(DAPPS, addr, true);
2141         emit DappWhitelisted(addr, true);
2142     }
2143 
2144     function removeDapp(address addr)
2145         external
2146         onlyManager
2147     {
2148         removeAddressFromSet(DAPPS, addr);
2149         emit DappWhitelisted(addr, false);
2150     }
2151 
2152     function whitelist(address wallet)
2153         public
2154         view
2155         returns (
2156             address[] memory addresses,
2157             uint[]    memory effectiveTimes
2158         )
2159     {
2160         addresses = addressesInSet(_walletKey(wallet));
2161         effectiveTimes = new uint[](addresses.length);
2162         for (uint i = 0; i < addresses.length; i++) {
2163             effectiveTimes[i] = effectiveTimeMap[wallet][addresses[i]];
2164         }
2165     }
2166 
2167     function isWhitelisted(
2168         address wallet,
2169         address addr
2170         )
2171         public
2172         view
2173         returns (
2174             bool isWhitelistedAndEffective,
2175             uint effectiveTime
2176         )
2177     {
2178         effectiveTime = effectiveTimeMap[wallet][addr];
2179         isWhitelistedAndEffective = effectiveTime > 0 && effectiveTime <= block.timestamp;
2180     }
2181 
2182     function whitelistSize(address wallet)
2183         public
2184         view
2185         returns (uint)
2186     {
2187         return numAddressesInSet(_walletKey(wallet));
2188     }
2189 
2190     function dapps()
2191         public
2192         view
2193         returns (
2194             address[] memory addresses
2195         )
2196     {
2197         return addressesInSet(DAPPS);
2198     }
2199 
2200     function isDapp(
2201         address addr
2202         )
2203         public
2204         view
2205         returns (bool)
2206     {
2207         return isAddressInSet(DAPPS, addr);
2208     }
2209 
2210     function numDapps()
2211         public
2212         view
2213         returns (uint)
2214     {
2215         return numAddressesInSet(DAPPS);
2216     }
2217 
2218     function isDappOrWhitelisted(
2219         address wallet,
2220         address addr
2221         )
2222         public
2223         view
2224         returns (bool res)
2225     {
2226         (res,) = isWhitelisted(wallet, addr);
2227         return res || isAddressInSet(DAPPS, addr);
2228     }
2229 
2230     function _walletKey(address addr)
2231         private
2232         pure
2233         returns (bytes32)
2234     {
2235         return keccak256(abi.encodePacked("__WHITELIST__", addr));
2236     }
2237 
2238 }
2239 
2240 // File: contracts/thirdparty/strings.sol
2241 
2242 /*
2243  * @title String & slice utility library for Solidity contracts.
2244  * @author Nick Johnson <arachnid@notdot.net>
2245  *
2246  * @dev Functionality in this library is largely implemented using an
2247  *      abstraction called a 'slice'. A slice represents a part of a string -
2248  *      anything from the entire string to a single character, or even no
2249  *      characters at all (a 0-length slice). Since a slice only has to specify
2250  *      an offset and a length, copying and manipulating slices is a lot less
2251  *      expensive than copying and manipulating the strings they reference.
2252  *
2253  *      To further reduce gas costs, most functions on slice that need to return
2254  *      a slice modify the original one instead of allocating a new one; for
2255  *      instance, `s.split(".")` will return the text up to the first '.',
2256  *      modifying s to only contain the remainder of the string after the '.'.
2257  *      In situations where you do not want to modify the original slice, you
2258  *      can make a copy first with `.copy()`, for example:
2259  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
2260  *      Solidity has no memory management, it will result in allocating many
2261  *      short-lived slices that are later discarded.
2262  *
2263  *      Functions that return two slices come in two versions: a non-allocating
2264  *      version that takes the second slice as an argument, modifying it in
2265  *      place, and an allocating version that allocates and returns the second
2266  *      slice; see `nextRune` for example.
2267  *
2268  *      Functions that have to copy string data will return strings rather than
2269  *      slices; these can be cast back to slices for further processing if
2270  *      required.
2271  *
2272  *      For convenience, some functions are provided with non-modifying
2273  *      variants that create a new slice and return both; for instance,
2274  *      `s.splitNew('.')` leaves s unmodified, and returns two values
2275  *      corresponding to the left and right parts of the string.
2276  */
2277 
2278 
2279 /* solium-disable */
2280 library strings {
2281     struct slice {
2282         uint _len;
2283         uint _ptr;
2284     }
2285 
2286     function memcpy(uint dest, uint src, uint len) private pure {
2287         // Copy word-length chunks while possible
2288         for(; len >= 32; len -= 32) {
2289             assembly {
2290                 mstore(dest, mload(src))
2291             }
2292             dest += 32;
2293             src += 32;
2294         }
2295 
2296         // Copy remaining bytes
2297         uint mask = 256 ** (32 - len) - 1;
2298         assembly {
2299             let srcpart := and(mload(src), not(mask))
2300             let destpart := and(mload(dest), mask)
2301             mstore(dest, or(destpart, srcpart))
2302         }
2303     }
2304 
2305     /*
2306      * @dev Returns a slice containing the entire string.
2307      * @param self The string to make a slice from.
2308      * @return A newly allocated slice containing the entire string.
2309      */
2310     function toSlice(string memory self) internal pure returns (slice memory) {
2311         uint ptr;
2312         assembly {
2313             ptr := add(self, 0x20)
2314         }
2315         return slice(bytes(self).length, ptr);
2316     }
2317 
2318     /*
2319      * @dev Returns the length of a null-terminated bytes32 string.
2320      * @param self The value to find the length of.
2321      * @return The length of the string, from 0 to 32.
2322      */
2323     function len(bytes32 self) internal pure returns (uint) {
2324         uint ret;
2325         if (self == 0)
2326             return 0;
2327         if (uint256(self) & 0xffffffffffffffffffffffffffffffff == 0) {
2328             ret += 16;
2329             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
2330         }
2331         if (uint256(self) & 0xffffffffffffffff == 0) {
2332             ret += 8;
2333             self = bytes32(uint(self) / 0x10000000000000000);
2334         }
2335         if (uint256(self) & 0xffffffff == 0) {
2336             ret += 4;
2337             self = bytes32(uint(self) / 0x100000000);
2338         }
2339         if (uint256(self) & 0xffff == 0) {
2340             ret += 2;
2341             self = bytes32(uint(self) / 0x10000);
2342         }
2343         if (uint256(self) & 0xff == 0) {
2344             ret += 1;
2345         }
2346         return 32 - ret;
2347     }
2348 
2349     /*
2350      * @dev Returns a slice containing the entire bytes32, interpreted as a
2351      *      null-terminated utf-8 string.
2352      * @param self The bytes32 value to convert to a slice.
2353      * @return A new slice containing the value of the input argument up to the
2354      *         first null.
2355      */
2356     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
2357         // Allocate space for `self` in memory, copy it there, and point ret at it
2358         assembly {
2359             let ptr := mload(0x40)
2360             mstore(0x40, add(ptr, 0x20))
2361             mstore(ptr, self)
2362             mstore(add(ret, 0x20), ptr)
2363         }
2364         ret._len = len(self);
2365     }
2366 
2367     /*
2368      * @dev Returns a new slice containing the same data as the current slice.
2369      * @param self The slice to copy.
2370      * @return A new slice containing the same data as `self`.
2371      */
2372     function copy(slice memory self) internal pure returns (slice memory) {
2373         return slice(self._len, self._ptr);
2374     }
2375 
2376     /*
2377      * @dev Copies a slice to a new string.
2378      * @param self The slice to copy.
2379      * @return A newly allocated string containing the slice's text.
2380      */
2381     function toString(slice memory self) internal pure returns (string memory) {
2382         string memory ret = new string(self._len);
2383         uint retptr;
2384         assembly { retptr := add(ret, 32) }
2385 
2386         memcpy(retptr, self._ptr, self._len);
2387         return ret;
2388     }
2389 
2390     /*
2391      * @dev Returns the length in runes of the slice. Note that this operation
2392      *      takes time proportional to the length of the slice; avoid using it
2393      *      in loops, and call `slice.empty()` if you only need to kblock.timestamp whether
2394      *      the slice is empty or not.
2395      * @param self The slice to operate on.
2396      * @return The length of the slice in runes.
2397      */
2398     function len(slice memory self) internal pure returns (uint l) {
2399         // Starting at ptr-31 means the LSB will be the byte we care about
2400         uint ptr = self._ptr - 31;
2401         uint end = ptr + self._len;
2402         for (l = 0; ptr < end; l++) {
2403             uint8 b;
2404             assembly { b := and(mload(ptr), 0xFF) }
2405             if (b < 0x80) {
2406                 ptr += 1;
2407             } else if(b < 0xE0) {
2408                 ptr += 2;
2409             } else if(b < 0xF0) {
2410                 ptr += 3;
2411             } else if(b < 0xF8) {
2412                 ptr += 4;
2413             } else if(b < 0xFC) {
2414                 ptr += 5;
2415             } else {
2416                 ptr += 6;
2417             }
2418         }
2419     }
2420 
2421     /*
2422      * @dev Returns true if the slice is empty (has a length of 0).
2423      * @param self The slice to operate on.
2424      * @return True if the slice is empty, False otherwise.
2425      */
2426     function empty(slice memory self) internal pure returns (bool) {
2427         return self._len == 0;
2428     }
2429 
2430     /*
2431      * @dev Returns a positive number if `other` comes lexicographically after
2432      *      `self`, a negative number if it comes before, or zero if the
2433      *      contents of the two slices are equal. Comparison is done per-rune,
2434      *      on unicode codepoints.
2435      * @param self The first slice to compare.
2436      * @param other The second slice to compare.
2437      * @return The result of the comparison.
2438      */
2439     function compare(slice memory self, slice memory other) internal pure returns (int) {
2440         uint shortest = self._len;
2441         if (other._len < self._len)
2442             shortest = other._len;
2443 
2444         uint selfptr = self._ptr;
2445         uint otherptr = other._ptr;
2446         for (uint idx = 0; idx < shortest; idx += 32) {
2447             uint a;
2448             uint b;
2449             assembly {
2450                 a := mload(selfptr)
2451                 b := mload(otherptr)
2452             }
2453             if (a != b) {
2454                 // Mask out irrelevant bytes and check again
2455                 uint256 mask = uint256(-1); // 0xffff...
2456                 if(shortest < 32) {
2457                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
2458                 }
2459                 uint256 diff = (a & mask) - (b & mask);
2460                 if (diff != 0)
2461                     return int(diff);
2462             }
2463             selfptr += 32;
2464             otherptr += 32;
2465         }
2466         return int(self._len) - int(other._len);
2467     }
2468 
2469     /*
2470      * @dev Returns true if the two slices contain the same text.
2471      * @param self The first slice to compare.
2472      * @param self The second slice to compare.
2473      * @return True if the slices are equal, false otherwise.
2474      */
2475     function equals(slice memory self, slice memory other) internal pure returns (bool) {
2476         return compare(self, other) == 0;
2477     }
2478 
2479     /*
2480      * @dev Extracts the first rune in the slice into `rune`, advancing the
2481      *      slice to point to the next rune and returning `self`.
2482      * @param self The slice to operate on.
2483      * @param rune The slice that will contain the first rune.
2484      * @return `rune`.
2485      */
2486     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
2487         rune._ptr = self._ptr;
2488 
2489         if (self._len == 0) {
2490             rune._len = 0;
2491             return rune;
2492         }
2493 
2494         uint l;
2495         uint b;
2496         // Load the first byte of the rune into the LSBs of b
2497         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
2498         if (b < 0x80) {
2499             l = 1;
2500         } else if(b < 0xE0) {
2501             l = 2;
2502         } else if(b < 0xF0) {
2503             l = 3;
2504         } else {
2505             l = 4;
2506         }
2507 
2508         // Check for truncated codepoints
2509         if (l > self._len) {
2510             rune._len = self._len;
2511             self._ptr += self._len;
2512             self._len = 0;
2513             return rune;
2514         }
2515 
2516         self._ptr += l;
2517         self._len -= l;
2518         rune._len = l;
2519         return rune;
2520     }
2521 
2522     /*
2523      * @dev Returns the first rune in the slice, advancing the slice to point
2524      *      to the next rune.
2525      * @param self The slice to operate on.
2526      * @return A slice containing only the first rune from `self`.
2527      */
2528     function nextRune(slice memory self) internal pure returns (slice memory ret) {
2529         nextRune(self, ret);
2530     }
2531 
2532     /*
2533      * @dev Returns the number of the first codepoint in the slice.
2534      * @param self The slice to operate on.
2535      * @return The number of the first codepoint in the slice.
2536      */
2537     function ord(slice memory self) internal pure returns (uint ret) {
2538         if (self._len == 0) {
2539             return 0;
2540         }
2541 
2542         uint word;
2543         uint length;
2544         uint divisor = 2 ** 248;
2545 
2546         // Load the rune into the MSBs of b
2547         assembly { word:= mload(mload(add(self, 32))) }
2548         uint b = word / divisor;
2549         if (b < 0x80) {
2550             ret = b;
2551             length = 1;
2552         } else if(b < 0xE0) {
2553             ret = b & 0x1F;
2554             length = 2;
2555         } else if(b < 0xF0) {
2556             ret = b & 0x0F;
2557             length = 3;
2558         } else {
2559             ret = b & 0x07;
2560             length = 4;
2561         }
2562 
2563         // Check for truncated codepoints
2564         if (length > self._len) {
2565             return 0;
2566         }
2567 
2568         for (uint i = 1; i < length; i++) {
2569             divisor = divisor / 256;
2570             b = (word / divisor) & 0xFF;
2571             if (b & 0xC0 != 0x80) {
2572                 // Invalid UTF-8 sequence
2573                 return 0;
2574             }
2575             ret = (ret * 64) | (b & 0x3F);
2576         }
2577 
2578         return ret;
2579     }
2580 
2581     /*
2582      * @dev Returns the keccak-256 hash of the slice.
2583      * @param self The slice to hash.
2584      * @return The hash of the slice.
2585      */
2586     function keccak(slice memory self) internal pure returns (bytes32 ret) {
2587         assembly {
2588             ret := keccak256(mload(add(self, 32)), mload(self))
2589         }
2590     }
2591 
2592     /*
2593      * @dev Returns true if `self` starts with `needle`.
2594      * @param self The slice to operate on.
2595      * @param needle The slice to search for.
2596      * @return True if the slice starts with the provided text, false otherwise.
2597      */
2598     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2599         if (self._len < needle._len) {
2600             return false;
2601         }
2602 
2603         if (self._ptr == needle._ptr) {
2604             return true;
2605         }
2606 
2607         bool equal;
2608         assembly {
2609             let length := mload(needle)
2610             let selfptr := mload(add(self, 0x20))
2611             let needleptr := mload(add(needle, 0x20))
2612             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2613         }
2614         return equal;
2615     }
2616 
2617     /*
2618      * @dev If `self` starts with `needle`, `needle` is removed from the
2619      *      beginning of `self`. Otherwise, `self` is unmodified.
2620      * @param self The slice to operate on.
2621      * @param needle The slice to search for.
2622      * @return `self`
2623      */
2624     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
2625         if (self._len < needle._len) {
2626             return self;
2627         }
2628 
2629         bool equal = true;
2630         if (self._ptr != needle._ptr) {
2631             assembly {
2632                 let length := mload(needle)
2633                 let selfptr := mload(add(self, 0x20))
2634                 let needleptr := mload(add(needle, 0x20))
2635                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2636             }
2637         }
2638 
2639         if (equal) {
2640             self._len -= needle._len;
2641             self._ptr += needle._len;
2642         }
2643 
2644         return self;
2645     }
2646 
2647     /*
2648      * @dev Returns true if the slice ends with `needle`.
2649      * @param self The slice to operate on.
2650      * @param needle The slice to search for.
2651      * @return True if the slice starts with the provided text, false otherwise.
2652      */
2653     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2654         if (self._len < needle._len) {
2655             return false;
2656         }
2657 
2658         uint selfptr = self._ptr + self._len - needle._len;
2659 
2660         if (selfptr == needle._ptr) {
2661             return true;
2662         }
2663 
2664         bool equal;
2665         assembly {
2666             let length := mload(needle)
2667             let needleptr := mload(add(needle, 0x20))
2668             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2669         }
2670 
2671         return equal;
2672     }
2673 
2674     /*
2675      * @dev If `self` ends with `needle`, `needle` is removed from the
2676      *      end of `self`. Otherwise, `self` is unmodified.
2677      * @param self The slice to operate on.
2678      * @param needle The slice to search for.
2679      * @return `self`
2680      */
2681     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
2682         if (self._len < needle._len) {
2683             return self;
2684         }
2685 
2686         uint selfptr = self._ptr + self._len - needle._len;
2687         bool equal = true;
2688         if (selfptr != needle._ptr) {
2689             assembly {
2690                 let length := mload(needle)
2691                 let needleptr := mload(add(needle, 0x20))
2692                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2693             }
2694         }
2695 
2696         if (equal) {
2697             self._len -= needle._len;
2698         }
2699 
2700         return self;
2701     }
2702 
2703     // Returns the memory address of the first byte of the first occurrence of
2704     // `needle` in `self`, or the first byte after `self` if not found.
2705     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2706         uint ptr = selfptr;
2707         uint idx;
2708 
2709         if (needlelen <= selflen) {
2710             if (needlelen <= 32) {
2711                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2712 
2713                 bytes32 needledata;
2714                 assembly { needledata := and(mload(needleptr), mask) }
2715 
2716                 uint end = selfptr + selflen - needlelen;
2717                 bytes32 ptrdata;
2718                 assembly { ptrdata := and(mload(ptr), mask) }
2719 
2720                 while (ptrdata != needledata) {
2721                     if (ptr >= end)
2722                         return selfptr + selflen;
2723                     ptr++;
2724                     assembly { ptrdata := and(mload(ptr), mask) }
2725                 }
2726                 return ptr;
2727             } else {
2728                 // For long needles, use hashing
2729                 bytes32 hash;
2730                 assembly { hash := keccak256(needleptr, needlelen) }
2731 
2732                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2733                     bytes32 testHash;
2734                     assembly { testHash := keccak256(ptr, needlelen) }
2735                     if (hash == testHash)
2736                         return ptr;
2737                     ptr += 1;
2738                 }
2739             }
2740         }
2741         return selfptr + selflen;
2742     }
2743 
2744     // Returns the memory address of the first byte after the last occurrence of
2745     // `needle` in `self`, or the address of `self` if not found.
2746     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2747         uint ptr;
2748 
2749         if (needlelen <= selflen) {
2750             if (needlelen <= 32) {
2751                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2752 
2753                 bytes32 needledata;
2754                 assembly { needledata := and(mload(needleptr), mask) }
2755 
2756                 ptr = selfptr + selflen - needlelen;
2757                 bytes32 ptrdata;
2758                 assembly { ptrdata := and(mload(ptr), mask) }
2759 
2760                 while (ptrdata != needledata) {
2761                     if (ptr <= selfptr)
2762                         return selfptr;
2763                     ptr--;
2764                     assembly { ptrdata := and(mload(ptr), mask) }
2765                 }
2766                 return ptr + needlelen;
2767             } else {
2768                 // For long needles, use hashing
2769                 bytes32 hash;
2770                 assembly { hash := keccak256(needleptr, needlelen) }
2771                 ptr = selfptr + (selflen - needlelen);
2772                 while (ptr >= selfptr) {
2773                     bytes32 testHash;
2774                     assembly { testHash := keccak256(ptr, needlelen) }
2775                     if (hash == testHash)
2776                         return ptr + needlelen;
2777                     ptr -= 1;
2778                 }
2779             }
2780         }
2781         return selfptr;
2782     }
2783 
2784     /*
2785      * @dev Modifies `self` to contain everything from the first occurrence of
2786      *      `needle` to the end of the slice. `self` is set to the empty slice
2787      *      if `needle` is not found.
2788      * @param self The slice to search and modify.
2789      * @param needle The text to search for.
2790      * @return `self`.
2791      */
2792     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
2793         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2794         self._len -= ptr - self._ptr;
2795         self._ptr = ptr;
2796         return self;
2797     }
2798 
2799     /*
2800      * @dev Modifies `self` to contain the part of the string from the start of
2801      *      `self` to the end of the first occurrence of `needle`. If `needle`
2802      *      is not found, `self` is set to the empty slice.
2803      * @param self The slice to search and modify.
2804      * @param needle The text to search for.
2805      * @return `self`.
2806      */
2807     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
2808         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2809         self._len = ptr - self._ptr;
2810         return self;
2811     }
2812 
2813     /*
2814      * @dev Splits the slice, setting `self` to everything after the first
2815      *      occurrence of `needle`, and `token` to everything before it. If
2816      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2817      *      and `token` is set to the entirety of `self`.
2818      * @param self The slice to split.
2819      * @param needle The text to search for in `self`.
2820      * @param token An output parameter to which the first token is written.
2821      * @return `token`.
2822      */
2823     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2824         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2825         token._ptr = self._ptr;
2826         token._len = ptr - self._ptr;
2827         if (ptr == self._ptr + self._len) {
2828             // Not found
2829             self._len = 0;
2830         } else {
2831             self._len -= token._len + needle._len;
2832             self._ptr = ptr + needle._len;
2833         }
2834         return token;
2835     }
2836 
2837     /*
2838      * @dev Splits the slice, setting `self` to everything after the first
2839      *      occurrence of `needle`, and returning everything before it. If
2840      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2841      *      and the entirety of `self` is returned.
2842      * @param self The slice to split.
2843      * @param needle The text to search for in `self`.
2844      * @return The part of `self` up to the first occurrence of `delim`.
2845      */
2846     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2847         split(self, needle, token);
2848     }
2849 
2850     /*
2851      * @dev Splits the slice, setting `self` to everything before the last
2852      *      occurrence of `needle`, and `token` to everything after it. If
2853      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2854      *      and `token` is set to the entirety of `self`.
2855      * @param self The slice to split.
2856      * @param needle The text to search for in `self`.
2857      * @param token An output parameter to which the first token is written.
2858      * @return `token`.
2859      */
2860     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2861         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2862         token._ptr = ptr;
2863         token._len = self._len - (ptr - self._ptr);
2864         if (ptr == self._ptr) {
2865             // Not found
2866             self._len = 0;
2867         } else {
2868             self._len -= token._len + needle._len;
2869         }
2870         return token;
2871     }
2872 
2873     /*
2874      * @dev Splits the slice, setting `self` to everything before the last
2875      *      occurrence of `needle`, and returning everything after it. If
2876      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2877      *      and the entirety of `self` is returned.
2878      * @param self The slice to split.
2879      * @param needle The text to search for in `self`.
2880      * @return The part of `self` after the last occurrence of `delim`.
2881      */
2882     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2883         rsplit(self, needle, token);
2884     }
2885 
2886     /*
2887      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2888      * @param self The slice to search.
2889      * @param needle The text to search for in `self`.
2890      * @return The number of occurrences of `needle` found in `self`.
2891      */
2892     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
2893         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2894         while (ptr <= self._ptr + self._len) {
2895             cnt++;
2896             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2897         }
2898     }
2899 
2900     /*
2901      * @dev Returns True if `self` contains `needle`.
2902      * @param self The slice to search.
2903      * @param needle The text to search for in `self`.
2904      * @return True if `needle` is found in `self`, false otherwise.
2905      */
2906     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
2907         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2908     }
2909 
2910     /*
2911      * @dev Returns a newly allocated string containing the concatenation of
2912      *      `self` and `other`.
2913      * @param self The first slice to concatenate.
2914      * @param other The second slice to concatenate.
2915      * @return The concatenation of the two strings.
2916      */
2917     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
2918         string memory ret = new string(self._len + other._len);
2919         uint retptr;
2920         assembly { retptr := add(ret, 32) }
2921         memcpy(retptr, self._ptr, self._len);
2922         memcpy(retptr + self._len, other._ptr, other._len);
2923         return ret;
2924     }
2925 
2926     /*
2927      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2928      *      newly allocated string.
2929      * @param self The delimiter to use.
2930      * @param parts A list of slices to join.
2931      * @return A newly allocated string containing all the slices in `parts`,
2932      *         joined with `self`.
2933      */
2934     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
2935         if (parts.length == 0)
2936             return "";
2937 
2938         uint length = self._len * (parts.length - 1);
2939         for(uint i = 0; i < parts.length; i++)
2940             length += parts[i]._len;
2941 
2942         string memory ret = new string(length);
2943         uint retptr;
2944         assembly { retptr := add(ret, 32) }
2945 
2946         for(uint i = 0; i < parts.length; i++) {
2947             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2948             retptr += parts[i]._len;
2949             if (i < parts.length - 1) {
2950                 memcpy(retptr, self._ptr, self._len);
2951                 retptr += self._len;
2952             }
2953         }
2954 
2955         return ret;
2956     }
2957 }
2958 
2959 // File: contracts/thirdparty/ens/ENS.sol
2960 
2961 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ENS.sol
2962 // with few modifications.
2963 
2964 
2965 /**
2966  * ENS Registry interface.
2967  */
2968 interface ENSRegistry {
2969     // Logged when the owner of a node assigns a new owner to a subnode.
2970     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
2971 
2972     // Logged when the owner of a node transfers ownership to a new account.
2973     event Transfer(bytes32 indexed node, address owner);
2974 
2975     // Logged when the resolver for a node changes.
2976     event NewResolver(bytes32 indexed node, address resolver);
2977 
2978     // Logged when the TTL of a node changes
2979     event NewTTL(bytes32 indexed node, uint64 ttl);
2980 
2981     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
2982     function setResolver(bytes32 node, address resolver) external;
2983     function setOwner(bytes32 node, address owner) external;
2984     function setTTL(bytes32 node, uint64 ttl) external;
2985     function owner(bytes32 node) external view returns (address);
2986     function resolver(bytes32 node) external view returns (address);
2987     function ttl(bytes32 node) external view returns (uint64);
2988 }
2989 
2990 
2991 /**
2992  * ENS Resolver interface.
2993  */
2994 abstract contract ENSResolver {
2995     function addr(bytes32 _node) public view virtual returns (address);
2996     function setAddr(bytes32 _node, address _addr) public virtual;
2997     function name(bytes32 _node) public view virtual returns (string memory);
2998     function setName(bytes32 _node, string memory _name) public virtual;
2999 }
3000 
3001 /**
3002  * ENS Reverse Registrar interface.
3003  */
3004 abstract contract ENSReverseRegistrar {
3005     function claim(address _owner) public virtual returns (bytes32 _node);
3006     function claimWithResolver(address _owner, address _resolver) public virtual returns (bytes32);
3007     function setName(string memory _name) public virtual returns (bytes32);
3008     function node(address _addr) public view virtual returns (bytes32);
3009 }
3010 
3011 // File: contracts/thirdparty/ens/ENSConsumer.sol
3012 
3013 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ENSConsumer.sol
3014 // with few modifications.
3015 
3016 
3017 
3018 
3019 /**
3020  * @title ENSConsumer
3021  * @dev Helper contract to resolve ENS names.
3022  * @author Julien Niset - <julien@argent.im>
3023  */
3024 contract ENSConsumer {
3025 
3026     using strings for *;
3027 
3028     // namehash('addr.reverse')
3029     bytes32 public constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
3030 
3031     // the address of the ENS registry
3032     address immutable ensRegistry;
3033 
3034     /**
3035     * @dev No address should be provided when deploying on Mainnet to avoid storage cost. The
3036     * contract will use the hardcoded value.
3037     */
3038     constructor(address _ensRegistry) {
3039         ensRegistry = _ensRegistry;
3040     }
3041 
3042     /**
3043     * @dev Resolves an ENS name to an address.
3044     * @param _node The namehash of the ENS name.
3045     */
3046     function resolveEns(bytes32 _node) public view returns (address) {
3047         address resolver = getENSRegistry().resolver(_node);
3048         return ENSResolver(resolver).addr(_node);
3049     }
3050 
3051     /**
3052     * @dev Gets the official ENS registry.
3053     */
3054     function getENSRegistry() public view returns (ENSRegistry) {
3055         return ENSRegistry(ensRegistry);
3056     }
3057 
3058     /**
3059     * @dev Gets the official ENS reverse registrar.
3060     */
3061     function getENSReverseRegistrar() public view returns (ENSReverseRegistrar) {
3062         return ENSReverseRegistrar(getENSRegistry().owner(ADDR_REVERSE_NODE));
3063     }
3064 }
3065 
3066 // File: contracts/thirdparty/ens/BaseENSManager.sol
3067 
3068 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ArgentENSManager.sol
3069 // with few modifications.
3070 
3071 
3072 
3073 
3074 
3075 
3076 
3077 /**
3078  * @dev Interface for an ENS Mananger.
3079  */
3080 interface IENSManager {
3081     function changeRootnodeOwner(address _newOwner) external;
3082 
3083     function isAvailable(bytes32 _subnode) external view returns (bool);
3084 
3085     function resolveName(address _wallet) external view returns (string memory);
3086 
3087     function register(
3088         address _wallet,
3089         address _owner,
3090         string  calldata _label,
3091         bytes   calldata _approval
3092     ) external;
3093 }
3094 
3095 /**
3096  * @title BaseENSManager
3097  * @dev Implementation of an ENS manager that orchestrates the complete
3098  * registration of subdomains for a single root (e.g. argent.eth).
3099  * The contract defines a manager role who is the only role that can trigger the registration of
3100  * a new subdomain.
3101  * @author Julien Niset - <julien@argent.im>
3102  */
3103 contract BaseENSManager is IENSManager, OwnerManagable, ENSConsumer {
3104 
3105     using strings for *;
3106     using BytesUtil     for bytes;
3107     using MathUint      for uint;
3108 
3109     // The managed root name
3110     string public rootName;
3111     // The managed root node
3112     bytes32 public immutable rootNode;
3113     // The address of the ENS resolver
3114     address public ensResolver;
3115 
3116     // *************** Events *************************** //
3117 
3118     event RootnodeOwnerChange(bytes32 indexed _rootnode, address indexed _newOwner);
3119     event ENSResolverChanged(address addr);
3120     event Registered(address indexed _wallet, address _owner, string _ens);
3121     event Unregistered(string _ens);
3122 
3123     // *************** Constructor ********************** //
3124 
3125     /**
3126      * @dev Constructor that sets the ENS root name and root node to manage.
3127      * @param _rootName The root name (e.g. argentx.eth).
3128      * @param _rootNode The node of the root name (e.g. namehash(argentx.eth)).
3129      */
3130     constructor(string memory _rootName, bytes32 _rootNode, address _ensRegistry, address _ensResolver)
3131         ENSConsumer(_ensRegistry)
3132     {
3133         rootName = _rootName;
3134         rootNode = _rootNode;
3135         ensResolver = _ensResolver;
3136     }
3137 
3138     // *************** External Functions ********************* //
3139 
3140     /**
3141      * @dev This function must be called when the ENS Manager contract is replaced
3142      * and the address of the new Manager should be provided.
3143      * @param _newOwner The address of the new ENS manager that will manage the root node.
3144      */
3145     function changeRootnodeOwner(address _newOwner) external override onlyOwner {
3146         getENSRegistry().setOwner(rootNode, _newOwner);
3147         emit RootnodeOwnerChange(rootNode, _newOwner);
3148     }
3149 
3150     /**
3151      * @dev Lets the owner change the address of the ENS resolver contract.
3152      * @param _ensResolver The address of the ENS resolver contract.
3153      */
3154     function changeENSResolver(address _ensResolver) external onlyOwner {
3155         require(_ensResolver != address(0), "WF: address cannot be null");
3156         ensResolver = _ensResolver;
3157         emit ENSResolverChanged(_ensResolver);
3158     }
3159 
3160     /**
3161     * @dev Lets the manager assign an ENS subdomain of the root node to a target address.
3162     * Registers both the forward and reverse ENS.
3163     * @param _wallet The wallet which owns the subdomain.
3164     * @param _owner The wallet's owner.
3165     * @param _label The subdomain label.
3166     * @param _approval The signature of _wallet, _owner and _label by a manager.
3167     */
3168     function register(
3169         address _wallet,
3170         address _owner,
3171         string  calldata _label,
3172         bytes   calldata _approval
3173         )
3174         external
3175         override
3176         onlyManager
3177     {
3178         verifyApproval(_wallet, _owner, _label, _approval);
3179 
3180         ENSRegistry _ensRegistry = getENSRegistry();
3181         ENSResolver _ensResolver = ENSResolver(ensResolver);
3182         bytes32 labelNode = keccak256(abi.encodePacked(_label));
3183         bytes32 node = keccak256(abi.encodePacked(rootNode, labelNode));
3184         address currentOwner = _ensRegistry.owner(node);
3185         require(currentOwner == address(0), "AEM: _label is alrealdy owned");
3186 
3187         // Forward ENS
3188         _ensRegistry.setSubnodeOwner(rootNode, labelNode, address(this));
3189         _ensRegistry.setResolver(node, address(_ensResolver));
3190         _ensRegistry.setOwner(node, _wallet);
3191         _ensResolver.setAddr(node, _wallet);
3192 
3193         // Reverse ENS
3194         strings.slice[] memory parts = new strings.slice[](2);
3195         parts[0] = _label.toSlice();
3196         parts[1] = rootName.toSlice();
3197         string memory name = ".".toSlice().join(parts);
3198         bytes32 reverseNode = getENSReverseRegistrar().node(_wallet);
3199         _ensResolver.setName(reverseNode, name);
3200 
3201         emit Registered(_wallet, _owner, name);
3202     }
3203 
3204     // *************** Public Functions ********************* //
3205 
3206     /**
3207     * @dev Resolves an address to an ENS name
3208     * @param _wallet The ENS owner address
3209     */
3210     function resolveName(address _wallet) public view override returns (string memory) {
3211         bytes32 reverseNode = getENSReverseRegistrar().node(_wallet);
3212         return ENSResolver(ensResolver).name(reverseNode);
3213     }
3214 
3215     /**
3216      * @dev Returns true is a given subnode is available.
3217      * @param _subnode The target subnode.
3218      * @return true if the subnode is available.
3219      */
3220     function isAvailable(bytes32 _subnode) public view override returns (bool) {
3221         bytes32 node = keccak256(abi.encodePacked(rootNode, _subnode));
3222         address currentOwner = getENSRegistry().owner(node);
3223         if(currentOwner == address(0)) {
3224             return true;
3225         }
3226         return false;
3227     }
3228 
3229     function verifyApproval(
3230         address _wallet,
3231         address _owner,
3232         string  calldata _label,
3233         bytes   calldata _approval
3234         )
3235         internal
3236         view
3237     {
3238         bytes32 messageHash = keccak256(
3239             abi.encodePacked(
3240                 _wallet,
3241                 _owner,
3242                 _label
3243             )
3244         );
3245 
3246         bytes32 hash = keccak256(
3247             abi.encodePacked(
3248                 "\x19Ethereum Signed Message:\n32",
3249                 messageHash
3250             )
3251         );
3252 
3253         address signer = SignatureUtil.recoverECDSASigner(hash, _approval);
3254         require(isManager(signer), "UNAUTHORIZED");
3255     }
3256 
3257 }
3258 
3259 // File: contracts/modules/ControllerImpl.sol
3260 
3261 // Copyright 2017 Loopring Technology Limited.
3262 
3263 
3264 
3265 
3266 
3267 
3268 
3269 
3270 
3271 
3272 /// @title ControllerImpl
3273 /// @dev Basic implementation of a Controller.
3274 ///
3275 /// @author Daniel Wang - <daniel@loopring.org>
3276 contract ControllerImpl is Claimable, Controller
3277 {
3278     HashStore           public immutable hashStore;
3279     QuotaStore          public immutable quotaStore;
3280     SecurityStore       public immutable securityStore;
3281     WhitelistStore      public immutable whitelistStore;
3282     ModuleRegistry      public immutable override moduleRegistry;
3283     address             public override  walletFactory;
3284     address             public immutable feeCollector;
3285     BaseENSManager      public immutable ensManager;
3286     PriceOracle         public immutable priceOracle;
3287 
3288     event AddressChanged(
3289         string   name,
3290         address  addr
3291     );
3292 
3293     constructor(
3294         HashStore         _hashStore,
3295         QuotaStore        _quotaStore,
3296         SecurityStore     _securityStore,
3297         WhitelistStore    _whitelistStore,
3298         ModuleRegistry    _moduleRegistry,
3299         address           _feeCollector,
3300         BaseENSManager    _ensManager,
3301         PriceOracle       _priceOracle
3302         )
3303     {
3304         hashStore = _hashStore;
3305         quotaStore = _quotaStore;
3306         securityStore = _securityStore;
3307         whitelistStore = _whitelistStore;
3308         moduleRegistry = _moduleRegistry;
3309 
3310         require(_feeCollector != address(0), "ZERO_ADDRESS");
3311         feeCollector = _feeCollector;
3312 
3313         ensManager = _ensManager;
3314         priceOracle = _priceOracle;
3315     }
3316 
3317     function initWalletFactory(address _walletFactory)
3318         external
3319         onlyOwner
3320     {
3321         require(walletFactory == address(0), "INITIALIZED_ALREADY");
3322         require(_walletFactory != address(0), "ZERO_ADDRESS");
3323         walletFactory = _walletFactory;
3324         emit AddressChanged("WalletFactory", walletFactory);
3325     }
3326 }
3327 
3328 // File: contracts/modules/base/BaseModule.sol
3329 
3330 // Copyright 2017 Loopring Technology Limited.
3331 
3332 
3333 
3334 
3335 
3336 
3337 
3338 
3339 /// @title BaseModule
3340 /// @dev This contract implements some common functions that are likely
3341 ///      be useful for all modules.
3342 ///
3343 /// @author Daniel Wang - <daniel@loopring.org>
3344 abstract contract BaseModule is Module
3345 {
3346     using MathUint      for uint;
3347     using AddressUtil   for address;
3348 
3349     event Activated   (address wallet);
3350     event Deactivated (address wallet);
3351 
3352     ModuleRegistry public immutable moduleRegistry;
3353     SecurityStore  public immutable securityStore;
3354     WhitelistStore public immutable whitelistStore;
3355     QuotaStore     public immutable quotaStore;
3356     HashStore      public immutable hashStore;
3357     address        public immutable walletFactory;
3358     PriceOracle    public immutable priceOracle;
3359     address        public immutable feeCollector;
3360 
3361     function logicalSender()
3362         internal
3363         view
3364         virtual
3365         returns (address payable)
3366     {
3367         return msg.sender;
3368     }
3369 
3370     modifier onlyWalletOwner(address wallet, address addr)
3371         virtual
3372     {
3373         require(Wallet(wallet).owner() == addr, "NOT_WALLET_OWNER");
3374         _;
3375     }
3376 
3377     modifier notWalletOwner(address wallet, address addr)
3378         virtual
3379     {
3380         require(Wallet(wallet).owner() != addr, "IS_WALLET_OWNER");
3381         _;
3382     }
3383 
3384     modifier eligibleWalletOwner(address addr)
3385     {
3386         require(addr != address(0) && !addr.isContract(), "INVALID_OWNER");
3387         _;
3388     }
3389 
3390     constructor(ControllerImpl _controller)
3391     {
3392         moduleRegistry = _controller.moduleRegistry();
3393         securityStore = _controller.securityStore();
3394         whitelistStore = _controller.whitelistStore();
3395         quotaStore = _controller.quotaStore();
3396         hashStore = _controller.hashStore();
3397         walletFactory = _controller.walletFactory();
3398         priceOracle = _controller.priceOracle();
3399         feeCollector = _controller.feeCollector();
3400     }
3401 
3402     /// @dev This method will cause an re-entry to the same module contract.
3403     function activate()
3404         external
3405         override
3406         virtual
3407     {
3408         address wallet = logicalSender();
3409         bindMethods(wallet);
3410         emit Activated(wallet);
3411     }
3412 
3413     /// @dev This method will cause an re-entry to the same module contract.
3414     function deactivate()
3415         external
3416         override
3417         virtual
3418     {
3419         address wallet = logicalSender();
3420         unbindMethods(wallet);
3421         emit Deactivated(wallet);
3422     }
3423 
3424     ///.@dev Gets the list of methods for binding to wallets.
3425     ///      Sub-contracts should override this method to provide methods for
3426     ///      wallet binding.
3427     /// @return methods A list of method selectors for binding to the wallet
3428     ///         when this module is activated for the wallet.
3429     function bindableMethods()
3430         public
3431         pure
3432         virtual
3433         returns (bytes4[] memory methods)
3434     {
3435     }
3436 
3437     // ===== internal & private methods =====
3438 
3439     /// @dev Binds all methods to the given wallet.
3440     function bindMethods(address wallet)
3441         internal
3442     {
3443         Wallet w = Wallet(wallet);
3444         bytes4[] memory methods = bindableMethods();
3445         for (uint i = 0; i < methods.length; i++) {
3446             w.bindMethod(methods[i], address(this));
3447         }
3448     }
3449 
3450     /// @dev Unbinds all methods from the given wallet.
3451     function unbindMethods(address wallet)
3452         internal
3453     {
3454         Wallet w = Wallet(wallet);
3455         bytes4[] memory methods = bindableMethods();
3456         for (uint i = 0; i < methods.length; i++) {
3457             w.bindMethod(methods[i], address(0));
3458         }
3459     }
3460 
3461     function transactCall(
3462         address wallet,
3463         address to,
3464         uint    value,
3465         bytes   memory data
3466         )
3467         internal
3468         returns (bytes memory)
3469     {
3470         return Wallet(wallet).transact(uint8(1), to, value, data);
3471     }
3472 
3473     // Special case for transactCall to support transfers on "bad" ERC20 tokens
3474     function transactTokenTransfer(
3475         address wallet,
3476         address token,
3477         address to,
3478         uint    amount
3479         )
3480         internal
3481     {
3482         if (token == address(0)) {
3483             transactCall(wallet, to, amount, "");
3484             return;
3485         }
3486 
3487         bytes memory txData = abi.encodeWithSelector(
3488             ERC20.transfer.selector,
3489             to,
3490             amount
3491         );
3492         bytes memory returnData = transactCall(wallet, token, 0, txData);
3493         // `transactCall` will revert if the call was unsuccessful.
3494         // The only extra check we have to do is verify if the return value (if there is any) is correct.
3495         bool success = returnData.length == 0 ? true :  abi.decode(returnData, (bool));
3496         require(success, "ERC20_TRANSFER_FAILED");
3497     }
3498 
3499     // Special case for transactCall to support approvals on "bad" ERC20 tokens
3500     function transactTokenApprove(
3501         address wallet,
3502         address token,
3503         address spender,
3504         uint    amount
3505         )
3506         internal
3507     {
3508         require(token != address(0), "INVALID_TOKEN");
3509         bytes memory txData = abi.encodeWithSelector(
3510             ERC20.approve.selector,
3511             spender,
3512             amount
3513         );
3514         bytes memory returnData = transactCall(wallet, token, 0, txData);
3515         // `transactCall` will revert if the call was unsuccessful.
3516         // The only extra check we have to do is verify if the return value (if there is any) is correct.
3517         bool success = returnData.length == 0 ? true :  abi.decode(returnData, (bool));
3518         require(success, "ERC20_APPROVE_FAILED");
3519     }
3520 
3521     function transactDelegateCall(
3522         address wallet,
3523         address to,
3524         uint    value,
3525         bytes   calldata data
3526         )
3527         internal
3528         returns (bytes memory)
3529     {
3530         return Wallet(wallet).transact(uint8(2), to, value, data);
3531     }
3532 
3533     function transactStaticCall(
3534         address wallet,
3535         address to,
3536         bytes   calldata data
3537         )
3538         internal
3539         returns (bytes memory)
3540     {
3541         return Wallet(wallet).transact(uint8(3), to, 0, data);
3542     }
3543 
3544     function reimburseGasFee(
3545         address     wallet,
3546         address     recipient,
3547         address     gasToken,
3548         uint        gasPrice,
3549         uint        gasAmount
3550         )
3551         internal
3552     {
3553         uint gasCost = gasAmount.mul(gasPrice);
3554 
3555         quotaStore.checkAndAddToSpent(
3556             wallet,
3557             gasToken,
3558             gasAmount,
3559             priceOracle
3560         );
3561 
3562         transactTokenTransfer(wallet, gasToken, recipient, gasCost);
3563     }
3564 }
3565 
3566 // File: contracts/modules/base/MetaTxAware.sol
3567 
3568 // Copyright 2017 Loopring Technology Limited.
3569 
3570 
3571 
3572 
3573 /// @title MetaTxAware
3574 /// @author Daniel Wang - <daniel@loopring.org>
3575 ///
3576 /// The design of this contract is inspired by GSN's contract codebase:
3577 /// https://github.com/opengsn/gsn/contracts
3578 ///
3579 /// @dev Inherit this abstract contract to make a module meta-transaction
3580 ///      aware. `msgSender()` shall be used to replace `msg.sender` for
3581 ///      verifying permissions.
3582 abstract contract MetaTxAware
3583 {
3584     using AddressUtil for address;
3585     using BytesUtil   for bytes;
3586 
3587     address public immutable metaTxForwarder;
3588 
3589     constructor(address _metaTxForwarder)
3590     {
3591         metaTxForwarder = _metaTxForwarder;
3592     }
3593 
3594     modifier txAwareHashNotAllowed()
3595     {
3596         require(txAwareHash() == 0, "INVALID_TX_AWARE_HASH");
3597         _;
3598     }
3599 
3600     /// @dev Return's the function's logicial message sender. This method should be
3601     // used to replace `msg.sender` for all meta-tx enabled functions.
3602     function msgSender()
3603         internal
3604         view
3605         returns (address payable)
3606     {
3607         if (msg.data.length >= 56 && msg.sender == metaTxForwarder) {
3608             return msg.data.toAddress(msg.data.length - 52).toPayable();
3609         } else {
3610             return msg.sender;
3611         }
3612     }
3613 
3614     function txAwareHash()
3615         internal
3616         view
3617         returns (bytes32)
3618     {
3619         if (msg.data.length >= 56 && msg.sender == metaTxForwarder) {
3620             return msg.data.toBytes32(msg.data.length - 32);
3621         } else {
3622             return 0;
3623         }
3624     }
3625 }
3626 
3627 // File: contracts/modules/base/MetaTxModule.sol
3628 
3629 // Copyright 2017 Loopring Technology Limited.
3630 
3631 
3632 
3633 
3634 
3635 
3636 /// @title MetaTxModule
3637 /// @dev Base contract for all modules that support meta-transactions.
3638 ///
3639 /// @author Daniel Wang - <daniel@loopring.org>
3640 ///
3641 /// The design of this contract is inspired by GSN's contract codebase:
3642 /// https://github.com/opengsn/gsn/contracts
3643 abstract contract MetaTxModule is MetaTxAware, BaseModule
3644 {
3645     using SignatureUtil for bytes32;
3646 
3647     constructor(
3648         ControllerImpl _controller,
3649         address        _metaTxForwarder
3650         )
3651         MetaTxAware(_metaTxForwarder)
3652         BaseModule(_controller)
3653     {
3654     }
3655 
3656    function logicalSender()
3657         internal
3658         view
3659         virtual
3660         override
3661         returns (address payable)
3662     {
3663         return msgSender();
3664     }
3665 }
3666 
3667 // File: contracts/modules/security/GuardianUtils.sol
3668 
3669 // Copyright 2017 Loopring Technology Limited.
3670 
3671 
3672 
3673 
3674 /// @title GuardianUtils
3675 /// @author Brecht Devos - <brecht@loopring.org>
3676 library GuardianUtils
3677 {
3678     enum SigRequirement
3679     {
3680         MAJORITY_OWNER_NOT_ALLOWED,
3681         MAJORITY_OWNER_ALLOWED,
3682         MAJORITY_OWNER_REQUIRED,
3683         OWNER_OR_ANY_GUARDIAN,
3684         ANY_GUARDIAN
3685     }
3686 
3687     function requireMajority(
3688         SecurityStore   securityStore,
3689         address         wallet,
3690         address[]       memory signers,
3691         SigRequirement  requirement
3692         )
3693         internal
3694         view
3695         returns (bool)
3696     {
3697         // We always need at least one signer
3698         if (signers.length == 0) {
3699             return false;
3700         }
3701 
3702         // Calculate total group sizes
3703         Data.Guardian[] memory allGuardians = securityStore.guardians(wallet, false);
3704         require(allGuardians.length > 0, "NO_GUARDIANS");
3705 
3706         address lastSigner;
3707         bool walletOwnerSigned = false;
3708         address owner = Wallet(wallet).owner();
3709         for (uint i = 0; i < signers.length; i++) {
3710             // Check for duplicates
3711             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
3712             lastSigner = signers[i];
3713 
3714             if (signers[i] == owner) {
3715                 walletOwnerSigned = true;
3716             } else {
3717                 require(_isWalletGuardian(allGuardians, signers[i]), "SIGNER_NOT_GUARDIAN");
3718             }
3719         }
3720 
3721         if (requirement == SigRequirement.OWNER_OR_ANY_GUARDIAN) {
3722             return signers.length == 1;
3723         } else if (requirement == SigRequirement.ANY_GUARDIAN) {
3724             require(!walletOwnerSigned, "WALLET_OWNER_SIGNATURE_NOT_ALLOWED");
3725             return signers.length == 1;
3726         }
3727 
3728         // Check owner requirements
3729         if (requirement == SigRequirement.MAJORITY_OWNER_REQUIRED) {
3730             require(walletOwnerSigned, "WALLET_OWNER_SIGNATURE_REQUIRED");
3731         } else if (requirement == SigRequirement.MAJORITY_OWNER_NOT_ALLOWED) {
3732             require(!walletOwnerSigned, "WALLET_OWNER_SIGNATURE_NOT_ALLOWED");
3733         }
3734 
3735         uint numExtendedSigners = allGuardians.length;
3736         if (walletOwnerSigned) {
3737             numExtendedSigners += 1;
3738             require(signers.length > 1, "NO_GUARDIAN_SIGNED_BESIDES_OWNER");
3739         }
3740 
3741         return _hasMajority(signers.length, numExtendedSigners);
3742     }
3743 
3744     function _isWalletGuardian(
3745         Data.Guardian[] memory allGuardians,
3746         address signer
3747         )
3748         private
3749         pure
3750         returns (bool)
3751     {
3752         for (uint i = 0; i < allGuardians.length; i++) {
3753             if (allGuardians[i].addr == signer) {
3754                 return true;
3755             }
3756         }
3757         return false;
3758     }
3759 
3760     function _hasMajority(
3761         uint signed,
3762         uint total
3763         )
3764         private
3765         pure
3766         returns (bool)
3767     {
3768         return total > 0 && signed >= (total >> 1) + 1;
3769     }
3770 }
3771 
3772 // File: contracts/modules/security/SignedRequest.sol
3773 
3774 // Copyright 2017 Loopring Technology Limited.
3775 
3776 
3777 
3778 
3779 
3780 
3781 
3782 /// @title SignedRequest
3783 /// @dev Utility library for better handling of signed wallet requests.
3784 ///      This library must be deployed and linked to other modules.
3785 ///
3786 /// @author Daniel Wang - <daniel@loopring.org>
3787 library SignedRequest {
3788     using SignatureUtil for bytes32;
3789 
3790     struct Request {
3791         address[] signers;
3792         bytes[]   signatures;
3793         uint      validUntil;
3794         address   wallet;
3795     }
3796 
3797     function verifyRequest(
3798         HashStore                    hashStore,
3799         SecurityStore                securityStore,
3800         bytes32                      domainSeperator,
3801         bytes32                      txAwareHash,
3802         GuardianUtils.SigRequirement sigRequirement,
3803         Request memory               request,
3804         bytes   memory               encodedRequest
3805         )
3806         public
3807     {
3808         require(block.timestamp <= request.validUntil, "EXPIRED_SIGNED_REQUEST");
3809 
3810         bytes32 _txAwareHash = EIP712.hashPacked(domainSeperator, encodedRequest);
3811 
3812         // If txAwareHash from the meta-transaction is non-zero,
3813         // we must verify it matches the hash signed by the respective signers.
3814         require(
3815             txAwareHash == 0 || txAwareHash == _txAwareHash,
3816             "TX_INNER_HASH_MISMATCH"
3817         );
3818 
3819         // Save hash to prevent replay attacks
3820         hashStore.verifyAndUpdate(request.wallet, _txAwareHash);
3821 
3822         require(
3823             _txAwareHash.verifySignatures(request.signers, request.signatures),
3824             "INVALID_SIGNATURES"
3825         );
3826 
3827         require(
3828             GuardianUtils.requireMajority(
3829                 securityStore,
3830                 request.wallet,
3831                 request.signers,
3832                 sigRequirement
3833             ),
3834             "PERMISSION_DENIED"
3835         );
3836     }
3837 }
3838 
3839 // File: contracts/modules/security/SecurityModule.sol
3840 
3841 // Copyright 2017 Loopring Technology Limited.
3842 
3843 
3844 
3845 
3846 
3847 /// @title SecurityStore
3848 ///
3849 /// @author Daniel Wang - <daniel@loopring.org>
3850 abstract contract SecurityModule is MetaTxModule
3851 {
3852 
3853     // The minimal number of guardians for recovery and locking.
3854     uint public constant TOUCH_GRACE_PERIOD = 30 days;
3855 
3856     event WalletLocked(
3857         address indexed wallet,
3858         address         by,
3859         bool            locked
3860     );
3861 
3862     constructor(
3863         ControllerImpl _controller,
3864         address        _metaTxForwarder
3865         )
3866         MetaTxModule(_controller, _metaTxForwarder)
3867     {
3868     }
3869 
3870     modifier onlyFromWalletOrOwnerWhenUnlocked(address wallet)
3871     {
3872         address payable _logicalSender = logicalSender();
3873         // If the wallet's signature verfication passes, the wallet must be unlocked.
3874         require(
3875             _logicalSender == wallet ||
3876             (_logicalSender == Wallet(wallet).owner() && !_isWalletLocked(wallet)),
3877              "NOT_FROM_WALLET_OR_OWNER_OR_WALLET_LOCKED"
3878         );
3879         securityStore.touchLastActiveWhenRequired(wallet, TOUCH_GRACE_PERIOD);
3880         _;
3881     }
3882 
3883     modifier onlyWalletGuardian(address wallet, address guardian)
3884     {
3885         require(securityStore.isGuardian(wallet, guardian, false), "NOT_GUARDIAN");
3886         _;
3887     }
3888 
3889     modifier notWalletGuardian(address wallet, address guardian)
3890     {
3891         require(!securityStore.isGuardian(wallet, guardian, false), "IS_GUARDIAN");
3892         _;
3893     }
3894 
3895     // ----- internal methods -----
3896 
3897     function _lockWallet(address wallet, address by, bool locked)
3898         internal
3899     {
3900         securityStore.setLock(wallet, locked);
3901         emit WalletLocked(wallet, by, locked);
3902     }
3903 
3904     function _isWalletLocked(address wallet)
3905         internal
3906         view
3907         returns (bool)
3908     {
3909         return securityStore.isLocked(wallet);
3910     }
3911 
3912     function _updateQuota(
3913         QuotaStore qs,
3914         address    wallet,
3915         address    token,
3916         uint       amount
3917         )
3918         internal
3919     {
3920         if (amount == 0) return;
3921         if (qs == QuotaStore(0)) return;
3922 
3923         qs.checkAndAddToSpent(
3924             wallet,
3925             token,
3926             amount,
3927             priceOracle
3928         );
3929     }
3930 }
3931 
3932 // File: contracts/modules/core/ERC1271Module.sol
3933 
3934 // Copyright 2017 Loopring Technology Limited.
3935 
3936 
3937 
3938 
3939 
3940 
3941 
3942 
3943 /// @title ERC1271Module
3944 /// @dev This module enables our smart wallets to message signers.
3945 /// @author Brecht Devos - <brecht@loopring.org>
3946 /// @author Daniel Wang - <daniel@loopring.org>
3947 abstract contract ERC1271Module is ERC1271, SecurityModule
3948 {
3949     using SignatureUtil for bytes;
3950     using SignatureUtil for bytes32;
3951     using AddressUtil   for address;
3952 
3953     function bindableMethodsForERC1271()
3954         internal
3955         pure
3956         returns (bytes4[] memory methods)
3957     {
3958         methods = new bytes4[](1);
3959         methods[0] = ERC1271.isValidSignature.selector;
3960     }
3961 
3962     // Will use msg.sender to detect the wallet, so this function should be called through
3963     // the bounded method on the wallet itself, not directly on this module.
3964     //
3965     // Note that we allow chained wallet ownership:
3966     // Wallet1 owned by Wallet2, Wallet2 owned by Wallet3, ..., WaleltN owned by an EOA.
3967     // The verificaiton of Wallet1's signature will succeed if the final EOA's signature is
3968     // valid.
3969     function isValidSignature(
3970         bytes32      _signHash,
3971         bytes memory _signature
3972         )
3973         public
3974         view
3975         override
3976         returns (bytes4 magicValue)
3977     {
3978         address wallet = msg.sender;
3979         if (securityStore.isLocked(wallet)) {
3980             return 0;
3981         }
3982 
3983         if (_signHash.verifySignature(Wallet(wallet).owner(), _signature)) {
3984             return ERC1271_MAGICVALUE;
3985         } else {
3986             return 0;
3987         }
3988     }
3989 }
3990 
3991 // File: contracts/lib/ReentrancyGuard.sol
3992 
3993 // Copyright 2017 Loopring Technology Limited.
3994 
3995 
3996 /// @title ReentrancyGuard
3997 /// @author Brecht Devos - <brecht@loopring.org>
3998 /// @dev Exposes a modifier that guards a function against reentrancy
3999 ///      Changing the value of the same storage value multiple times in a transaction
4000 ///      is cheap (starting from Istanbul) so there is no need to minimize
4001 ///      the number of times the value is changed
4002 contract ReentrancyGuard
4003 {
4004     //The default value must be 0 in order to work behind a proxy.
4005     uint private _guardValue;
4006 
4007     modifier nonReentrant()
4008     {
4009         require(_guardValue == 0, "REENTRANCY");
4010         _guardValue = 1;
4011         _;
4012         _guardValue = 0;
4013     }
4014 }
4015 
4016 // File: contracts/base/BaseWallet.sol
4017 
4018 // Copyright 2017 Loopring Technology Limited.
4019 
4020 
4021 
4022 
4023 
4024 
4025 
4026 /// @title BaseWallet
4027 /// @dev This contract provides basic implementation for a Wallet.
4028 ///
4029 /// @author Daniel Wang - <daniel@loopring.org>
4030 abstract contract BaseWallet is ReentrancyGuard, Wallet
4031 {
4032     // WARNING: do not delete wallet state data to make this implementation
4033     // compatible with early versions.
4034     //
4035     //  ----- DATA LAYOUT BEGINS -----
4036     address internal _owner;
4037 
4038     mapping (address => bool) private modules;
4039 
4040     Controller public controller;
4041 
4042     mapping (bytes4  => address) internal methodToModule;
4043     //  ----- DATA LAYOUT ENDS -----
4044 
4045     event OwnerChanged          (address newOwner);
4046     event ControllerChanged     (address newController);
4047     event ModuleAdded           (address module);
4048     event ModuleRemoved         (address module);
4049     event MethodBound           (bytes4  method, address module);
4050     event WalletSetup           (address owner);
4051 
4052     modifier onlyFromModule
4053     {
4054         require(modules[msg.sender], "MODULE_UNAUTHORIZED");
4055         _;
4056     }
4057 
4058     modifier onlyFromFactory
4059     {
4060         require(
4061             msg.sender == controller.walletFactory(),
4062             "UNAUTHORIZED"
4063         );
4064         _;
4065     }
4066 
4067     /// @dev We need to make sure the Factory address cannot be changed without wallet owner's
4068     ///      explicit authorization.
4069     modifier onlyFromFactoryOrModule
4070     {
4071         require(
4072             modules[msg.sender] || msg.sender == controller.walletFactory(),
4073             "UNAUTHORIZED"
4074         );
4075         _;
4076     }
4077 
4078     /// @dev Set up this wallet by assigning an original owner
4079     ///
4080     ///      Note that calling this method more than once will throw.
4081     ///
4082     /// @param _initialOwner The owner of this wallet, must not be address(0).
4083     function initOwner(
4084         address _initialOwner
4085         )
4086         external
4087         onlyFromFactory
4088     {
4089         require(controller != Controller(0), "NO_CONTROLLER");
4090         require(_owner == address(0), "INITIALIZED_ALREADY");
4091         require(_initialOwner != address(0), "ZERO_ADDRESS");
4092 
4093         _owner = _initialOwner;
4094         emit WalletSetup(_initialOwner);
4095     }
4096 
4097     /// @dev Set up this wallet by assigning a controller and initial modules.
4098     ///
4099     ///      Note that calling this method more than once will throw.
4100     ///      And this method must be invoked before owner is initialized
4101     ///
4102     /// @param _controller The Controller instance.
4103     /// @param _modules The initial modules.
4104     function init(
4105         Controller _controller,
4106         address[]  calldata _modules
4107         )
4108         external
4109     {
4110         require(
4111             _owner == address(0) &&
4112             controller == Controller(0) &&
4113             _controller != Controller(0),
4114             "CONTROLLER_INIT_FAILED"
4115         );
4116 
4117         controller = _controller;
4118 
4119         ModuleRegistry moduleRegistry = controller.moduleRegistry();
4120         for (uint i = 0; i < _modules.length; i++) {
4121             _addModule(_modules[i], moduleRegistry);
4122         }
4123     }
4124 
4125     function owner()
4126         override
4127         public
4128         view
4129         returns (address)
4130     {
4131         return _owner;
4132     }
4133 
4134     function setOwner(address newOwner)
4135         external
4136         override
4137         onlyFromModule
4138     {
4139         require(newOwner != address(0), "ZERO_ADDRESS");
4140         require(newOwner != address(this), "PROHIBITED");
4141         require(newOwner != _owner, "SAME_ADDRESS");
4142         _owner = newOwner;
4143         emit OwnerChanged(newOwner);
4144     }
4145 
4146     function setController(Controller newController)
4147         external
4148         onlyFromModule
4149     {
4150         require(newController != controller, "SAME_CONTROLLER");
4151         require(newController != Controller(0), "INVALID_CONTROLLER");
4152         controller = newController;
4153         emit ControllerChanged(address(newController));
4154     }
4155 
4156     function addModule(address _module)
4157         external
4158         override
4159         onlyFromFactoryOrModule
4160     {
4161         _addModule(_module, controller.moduleRegistry());
4162     }
4163 
4164     function removeModule(address _module)
4165         external
4166         override
4167         onlyFromModule
4168     {
4169         // Allow deactivate to fail to make sure the module can be removed
4170         require(modules[_module], "MODULE_NOT_EXISTS");
4171         try Module(_module).deactivate() {} catch {}
4172         delete modules[_module];
4173         emit ModuleRemoved(_module);
4174     }
4175 
4176     function hasModule(address _module)
4177         public
4178         view
4179         override
4180         returns (bool)
4181     {
4182         return modules[_module];
4183     }
4184 
4185     function bindMethod(bytes4 _method, address _module)
4186         external
4187         override
4188         onlyFromModule
4189     {
4190         require(_method != bytes4(0), "BAD_METHOD");
4191         if (_module != address(0)) {
4192             require(modules[_module], "MODULE_UNAUTHORIZED");
4193         }
4194 
4195         methodToModule[_method] = _module;
4196         emit MethodBound(_method, _module);
4197     }
4198 
4199     function boundMethodModule(bytes4 _method)
4200         public
4201         view
4202         override
4203         returns (address)
4204     {
4205         return methodToModule[_method];
4206     }
4207 
4208     function transact(
4209         uint8    mode,
4210         address  to,
4211         uint     value,
4212         bytes    calldata data
4213         )
4214         external
4215         override
4216         onlyFromFactoryOrModule
4217         returns (bytes memory returnData)
4218     {
4219         bool success;
4220         (success, returnData) = _call(mode, to, value, data);
4221 
4222         if (!success) {
4223             assembly {
4224                 returndatacopy(0, 0, returndatasize())
4225                 revert(0, returndatasize())
4226             }
4227         }
4228     }
4229 
4230     receive()
4231         external
4232         payable
4233     {
4234     }
4235 
4236     /// @dev This default function can receive Ether or perform queries to modules
4237     ///      using bound methods.
4238     fallback()
4239         external
4240         payable
4241     {
4242         address module = methodToModule[msg.sig];
4243         require(modules[module], "MODULE_UNAUTHORIZED");
4244 
4245         (bool success, bytes memory returnData) = module.call{value: msg.value}(msg.data);
4246         assembly {
4247             switch success
4248             case 0 { revert(add(returnData, 32), mload(returnData)) }
4249             default { return(add(returnData, 32), mload(returnData)) }
4250         }
4251     }
4252 
4253     function _addModule(address _module, ModuleRegistry moduleRegistry)
4254         internal
4255     {
4256         require(_module != address(0), "NULL_MODULE");
4257         require(modules[_module] == false, "MODULE_EXISTS");
4258         require(
4259             moduleRegistry.isModuleEnabled(_module),
4260             "INVALID_MODULE"
4261         );
4262         modules[_module] = true;
4263         emit ModuleAdded(_module);
4264         Module(_module).activate();
4265     }
4266 
4267     function _call(
4268         uint8          mode,
4269         address        target,
4270         uint           value,
4271         bytes calldata data
4272         )
4273         private
4274         returns (
4275             bool success,
4276             bytes memory returnData
4277         )
4278     {
4279         if (mode == 1) {
4280             // solium-disable-next-line security/no-call-value
4281             (success, returnData) = target.call{value: value}(data);
4282         } else if (mode == 2) {
4283             // solium-disable-next-line security/no-call-value
4284             (success, returnData) = target.delegatecall(data);
4285         } else if (mode == 3) {
4286             require(value == 0, "INVALID_VALUE");
4287             // solium-disable-next-line security/no-call-value
4288             (success, returnData) = target.staticcall(data);
4289         } else {
4290             revert("UNSUPPORTED_MODE");
4291         }
4292     }
4293 }
4294 
4295 // File: contracts/thirdparty/Create2.sol
4296 
4297 // Taken from: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/970f687f04d20e01138a3e8ccf9278b1d4b3997b/contracts/utils/Create2.sol
4298 
4299 
4300 /**
4301  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
4302  * `CREATE2` can be used to compute in advance the address where a smart
4303  * contract will be deployed, which allows for interesting new mechanisms known
4304  * as 'counterfactual interactions'.
4305  *
4306  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
4307  * information.
4308  */
4309 library Create2 {
4310     /**
4311      * @dev Deploys a contract using `CREATE2`. The address where the contract
4312      * will be deployed can be known in advance via {computeAddress}. Note that
4313      * a contract cannot be deployed twice using the same salt.
4314      */
4315     function deploy(bytes32 salt, bytes memory bytecode) internal returns (address payable) {
4316         address payable addr;
4317         // solhint-disable-next-line no-inline-assembly
4318         assembly {
4319             addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
4320         }
4321         require(addr != address(0), "CREATE2_FAILED");
4322         return addr;
4323     }
4324 
4325     /**
4326      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the `bytecode`
4327      * or `salt` will result in a new destination address.
4328      */
4329     function computeAddress(bytes32 salt, bytes memory bytecode) internal view returns (address) {
4330         return computeAddress(salt, bytecode, address(this));
4331     }
4332 
4333     /**
4334      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
4335      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
4336      */
4337     function computeAddress(bytes32 salt, bytes memory bytecodeHash, address deployer) internal pure returns (address) {
4338         bytes32 bytecodeHashHash = keccak256(bytecodeHash);
4339         bytes32 _data = keccak256(
4340             abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHashHash)
4341         );
4342         return address(bytes20(_data << 96));
4343     }
4344 }
4345 
4346 // File: contracts/thirdparty/proxy/CloneFactory.sol
4347 
4348 // This code is taken from https://eips.ethereum.org/EIPS/eip-1167
4349 // Modified to a library and generalized to support create/create2.
4350 
4351 /*
4352 The MIT License (MIT)
4353 
4354 Copyright (c) 2018 Murray Software, LLC.
4355 
4356 Permission is hereby granted, free of charge, to any person obtaining
4357 a copy of this software and associated documentation files (the
4358 "Software"), to deal in the Software without restriction, including
4359 without limitation the rights to use, copy, modify, merge, publish,
4360 distribute, sublicense, and/or sell copies of the Software, and to
4361 permit persons to whom the Software is furnished to do so, subject to
4362 the following conditions:
4363 
4364 The above copyright notice and this permission notice shall be included
4365 in all copies or substantial portions of the Software.
4366 
4367 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
4368 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
4369 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
4370 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
4371 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
4372 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
4373 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
4374 */
4375 //solhint-disable max-line-length
4376 //solhint-disable no-inline-assembly
4377 
4378 library CloneFactory {
4379   function getByteCode(address target) internal pure returns (bytes memory byteCode) {
4380     bytes20 targetBytes = bytes20(target);
4381     assembly {
4382       byteCode := mload(0x40)
4383       mstore(byteCode, 0x37)
4384 
4385       let clone := add(byteCode, 0x20)
4386       mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
4387       mstore(add(clone, 0x14), targetBytes)
4388       mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
4389 
4390       mstore(0x40, add(byteCode, 0x60))
4391     }
4392   }
4393 }
4394 
4395 // File: contracts/modules/core/WalletFactory.sol
4396 
4397 // Copyright 2017 Loopring Technology Limited.
4398 
4399 
4400 
4401 
4402 
4403 
4404 
4405 
4406 
4407 
4408 
4409 
4410 
4411 
4412 /// @title WalletFactory
4413 /// @dev A factory contract to create a new wallet by deploying a proxy
4414 ///      in front of a real wallet.
4415 ///
4416 /// @author Daniel Wang - <daniel@loopring.org>
4417 contract WalletFactory
4418 {
4419     using AddressUtil for address;
4420     using SignatureUtil for bytes32;
4421 
4422     event BlankDeployed (address blank,  bytes32 version);
4423     event BlankConsumed (address blank);
4424     event WalletCreated (address wallet, string ensLabel, address owner, bool blankUsed);
4425 
4426     string public constant WALLET_CREATION = "WALLET_CREATION";
4427 
4428     bytes32 public constant CREATE_WALLET_TYPEHASH = keccak256(
4429         "createWallet(address owner,uint256 salt,address blankAddress,string ensLabel,bool ensRegisterReverse,address[] modules)"
4430     );
4431 
4432     mapping(address => bytes32) blanks;
4433 
4434     bytes32             public immutable DOMAIN_SEPERATOR;
4435     ControllerImpl      public immutable controller;
4436     address             public immutable walletImplementation;
4437     bool                public immutable allowEmptyENS; // MUST be false in production
4438 
4439     BaseENSManager      public immutable ensManager;
4440     address             public immutable ensResolver;
4441     ENSReverseRegistrar public immutable ensReverseRegistrar;
4442 
4443     constructor(
4444         ControllerImpl _controller,
4445         address        _walletImplementation,
4446         bool           _allowEmptyENS
4447         )
4448     {
4449         DOMAIN_SEPERATOR = EIP712.hash(
4450             EIP712.Domain("WalletFactory", "1.2.0", address(this))
4451         );
4452         controller = _controller;
4453         walletImplementation = _walletImplementation;
4454         allowEmptyENS = _allowEmptyENS;
4455 
4456         BaseENSManager _ensManager = _controller.ensManager();
4457         ensManager = _ensManager;
4458         ensResolver = _ensManager.ensResolver();
4459         ensReverseRegistrar = _ensManager.getENSReverseRegistrar();
4460     }
4461 
4462     /// @dev Create a set of new wallet blanks to be used in the future.
4463     /// @param modules The wallet's modules.
4464     /// @param salts The salts that can be used to generate nice addresses.
4465     function createBlanks(
4466         address[] calldata modules,
4467         uint[]    calldata salts
4468         )
4469         external
4470     {
4471         for (uint i = 0; i < salts.length; i++) {
4472             _createBlank(modules, salts[i]);
4473         }
4474     }
4475 
4476     /// @dev Create a new wallet by deploying a proxy.
4477     /// @param _owner The wallet's owner.
4478     /// @param _salt A salt to adjust address.
4479     /// @param _ensLabel The ENS subdomain to register, use "" to skip.
4480     /// @param _ensApproval The signature for ENS subdomain approval.
4481     /// @param _ensRegisterReverse True to register reverse ENS.
4482     /// @param _modules The wallet's modules.
4483     /// @param _signature The wallet owner's signature.
4484     /// @return _wallet The new wallet address
4485     function createWallet(
4486         address            _owner,
4487         uint               _salt,
4488         string    calldata _ensLabel,
4489         bytes     calldata _ensApproval,
4490         bool               _ensRegisterReverse,
4491         address[] calldata _modules,
4492         bytes     calldata _signature
4493         )
4494         external
4495         payable
4496         returns (address _wallet)
4497     {
4498         _validateRequest(
4499             _owner,
4500             _salt,
4501             address(0),
4502             _ensLabel,
4503             _ensRegisterReverse,
4504             _modules,
4505             _signature
4506         );
4507 
4508         _wallet = _deploy(_modules, _owner, _salt);
4509 
4510         _initializeWallet(
4511             _wallet,
4512             _owner,
4513             _ensLabel,
4514             _ensApproval,
4515             _ensRegisterReverse,
4516             false
4517         );
4518     }
4519 
4520     /// @dev Create a new wallet by using a pre-deployed blank.
4521     /// @param _owner The wallet's owner.
4522     /// @param _blank The address of the blank to use.
4523     /// @param _ensLabel The ENS subdomain to register, use "" to skip.
4524     /// @param _ensApproval The signature for ENS subdomain approval.
4525     /// @param _ensRegisterReverse True to register reverse ENS.
4526     /// @param _modules The wallet's modules.
4527     /// @param _signature The wallet owner's signature.
4528     /// @return _wallet The new wallet address
4529     function createWallet2(
4530         address            _owner,
4531         address            _blank,
4532         string    calldata _ensLabel,
4533         bytes     calldata _ensApproval,
4534         bool               _ensRegisterReverse,
4535         address[] calldata _modules,
4536         bytes     calldata _signature
4537         )
4538         external
4539         payable
4540         returns (address _wallet)
4541     {
4542         _validateRequest(
4543             _owner,
4544             0,
4545             _blank,
4546             _ensLabel,
4547             _ensRegisterReverse,
4548             _modules,
4549             _signature
4550         );
4551 
4552         _wallet = _consumeBlank(_blank, _modules);
4553 
4554         _initializeWallet(
4555             _wallet,
4556             _owner,
4557             _ensLabel,
4558             _ensApproval,
4559             _ensRegisterReverse,
4560             true
4561         );
4562     }
4563 
4564     function registerENS(
4565         address         _wallet,
4566         address         _owner,
4567         string calldata _ensLabel,
4568         bytes  calldata _ensApproval,
4569         bool            _ensRegisterReverse
4570         )
4571         external
4572     {
4573         _registerENS(_wallet, _owner, _ensLabel, _ensApproval, _ensRegisterReverse);
4574     }
4575 
4576     function computeWalletAddress(address owner, uint salt)
4577         public
4578         view
4579         returns (address)
4580     {
4581         return _computeAddress(owner, salt);
4582     }
4583 
4584     function computeBlankAddress(uint salt)
4585         public
4586         view
4587         returns (address)
4588     {
4589         return _computeAddress(address(0), salt);
4590     }
4591 
4592     function getWalletCreationCode()
4593         public
4594         view
4595         returns (bytes memory)
4596     {
4597         return CloneFactory.getByteCode(walletImplementation);
4598     }
4599 
4600     function _consumeBlank(
4601         address blank,
4602         address[] calldata modules
4603         )
4604         internal
4605         returns (address)
4606     {
4607         bytes32 version = keccak256(abi.encode(modules));
4608         require(blanks[blank] == version, "INVALID_ADOBE");
4609         delete blanks[blank];
4610         emit BlankConsumed(blank);
4611         return blank;
4612     }
4613 
4614     function _createBlank(
4615         address[] calldata modules,
4616         uint      salt
4617         )
4618         internal
4619         returns (address blank)
4620     {
4621         blank = _deploy(modules, address(0), salt);
4622         bytes32 version = keccak256(abi.encode(modules));
4623         blanks[blank] = version;
4624 
4625         emit BlankDeployed(blank, version);
4626     }
4627 
4628     function _deploy(
4629         address[] calldata modules,
4630         address            owner,
4631         uint               salt
4632         )
4633         internal
4634         returns (address payable wallet)
4635     {
4636         wallet = Create2.deploy(
4637             keccak256(abi.encodePacked(WALLET_CREATION, owner, salt)),
4638             CloneFactory.getByteCode(walletImplementation)
4639         );
4640 
4641         BaseWallet(wallet).init(controller, modules);
4642     }
4643 
4644     function _validateRequest(
4645         address            _owner,
4646         uint               _salt,
4647         address            _blankAddress,
4648         string    memory   _ensLabel,
4649         bool               _ensRegisterReverse,
4650         address[] memory   _modules,
4651         bytes     memory   _signature
4652         )
4653         private
4654         view
4655     {
4656         require(_owner != address(0) && !_owner.isContract(), "INVALID_OWNER");
4657         require(_modules.length > 0, "EMPTY_MODULES");
4658 
4659         bytes memory encodedRequest = abi.encode(
4660             CREATE_WALLET_TYPEHASH,
4661             _owner,
4662             _salt,
4663             _blankAddress,
4664             keccak256(bytes(_ensLabel)),
4665             _ensRegisterReverse,
4666             keccak256(abi.encode(_modules))
4667         );
4668 
4669         bytes32 signHash = EIP712.hashPacked(DOMAIN_SEPERATOR, encodedRequest);
4670         require(signHash.verifySignature(_owner, _signature), "INVALID_SIGNATURE");
4671     }
4672 
4673     function _initializeWallet(
4674         address       _wallet,
4675         address       _owner,
4676         string memory _ensLabel,
4677         bytes  memory _ensApproval,
4678         bool          _ensRegisterReverse,
4679         bool          _blankUsed
4680         )
4681         private
4682     {
4683         BaseWallet(_wallet.toPayable()).initOwner(_owner);
4684 
4685         if (bytes(_ensLabel).length > 0) {
4686             _registerENS(_wallet, _owner, _ensLabel, _ensApproval, _ensRegisterReverse);
4687         } else {
4688             require(allowEmptyENS, "EMPTY_ENS_NOT_ALLOWED");
4689         }
4690 
4691         emit WalletCreated(_wallet, _ensLabel, _owner, _blankUsed);
4692     }
4693 
4694     function _computeAddress(
4695         address owner,
4696         uint    salt
4697         )
4698         private
4699         view
4700         returns (address)
4701     {
4702         return Create2.computeAddress(
4703             keccak256(abi.encodePacked(WALLET_CREATION, owner, salt)),
4704             CloneFactory.getByteCode(walletImplementation)
4705         );
4706     }
4707 
4708     function _registerENS(
4709         address       wallet,
4710         address       owner,
4711         string memory ensLabel,
4712         bytes  memory ensApproval,
4713         bool          ensRegisterReverse
4714         )
4715         private
4716     {
4717         require(
4718             bytes(ensLabel).length > 0 &&
4719             ensApproval.length > 0,
4720             "INVALID_LABEL_OR_SIGNATURE"
4721         );
4722 
4723         ensManager.register(wallet, owner, ensLabel, ensApproval);
4724 
4725         if (ensRegisterReverse) {
4726             bytes memory data = abi.encodeWithSelector(
4727                 ENSReverseRegistrar.claimWithResolver.selector,
4728                 address(0), // the owner of the reverse record
4729                 ensResolver
4730             );
4731 
4732             Wallet(wallet).transact(
4733                 uint8(1),
4734                 address(ensReverseRegistrar),
4735                 0, // value
4736                 data
4737             );
4738         }
4739     }
4740 }
4741 
4742 // File: contracts/modules/core/ForwarderModule.sol
4743 
4744 // Copyright 2017 Loopring Technology Limited.
4745 
4746 
4747 
4748 
4749 
4750 
4751 
4752 
4753 
4754 /// @title ForwarderModule
4755 /// @dev A module to support wallet meta-transactions.
4756 ///
4757 /// @author Daniel Wang - <daniel@loopring.org>
4758 abstract contract ForwarderModule is SecurityModule
4759 {
4760     using AddressUtil   for address;
4761     using BytesUtil     for bytes;
4762     using MathUint      for uint;
4763     using SignatureUtil for bytes32;
4764 
4765     bytes32 public immutable FORWARDER_DOMAIN_SEPARATOR;
4766 
4767     uint    public constant MAX_REIMBURSTMENT_OVERHEAD = 63000;
4768 
4769     bytes32 public constant META_TX_TYPEHASH = keccak256(
4770         "MetaTx(address from,address to,uint256 nonce,bytes32 txAwareHash,address gasToken,uint256 gasPrice,uint256 gasLimit,bytes data)"
4771     );
4772 
4773     mapping(address => uint) public nonces;
4774 
4775     event MetaTxExecuted(
4776         address relayer,
4777         address from,
4778         uint    nonce,
4779         bytes32 txAwareHash,
4780         bool    success,
4781         uint    gasUsed
4782     );
4783 
4784     struct MetaTx {
4785         address from; // the wallet
4786         address to;
4787         uint    nonce;
4788         bytes32 txAwareHash;
4789         address gasToken;
4790         uint    gasPrice;
4791         uint    gasLimit;
4792     }
4793 
4794     constructor(ControllerImpl _controller)
4795         SecurityModule(_controller, address(this))
4796     {
4797         FORWARDER_DOMAIN_SEPARATOR = EIP712.hash(
4798             EIP712.Domain("ForwarderModule", "1.2.0", address(this))
4799         );
4800     }
4801 
4802     function validateMetaTx(
4803         address from, // the wallet
4804         address to,
4805         uint    nonce,
4806         bytes32 txAwareHash,
4807         address gasToken,
4808         uint    gasPrice,
4809         uint    gasLimit,
4810         bytes   memory data,
4811         bytes   memory signature
4812         )
4813         public
4814         view
4815     {
4816         verifyTo(to, from, data);
4817         require(
4818             msg.sender != address(this) ||
4819             data.toBytes4(0) == ForwarderModule.batchCall.selector,
4820             "INVALID_TARGET"
4821         );
4822 
4823         require(
4824             nonce == 0 && txAwareHash != 0 ||
4825             nonce != 0 && txAwareHash == 0,
4826             "INVALID_NONCE"
4827         );
4828 
4829         bytes memory data_ = txAwareHash == 0 ? data : data.slice(0, 4); // function selector
4830 
4831         bytes memory encoded = abi.encode(
4832             META_TX_TYPEHASH,
4833             from,
4834             to,
4835             nonce,
4836             txAwareHash,
4837             gasToken,
4838             gasPrice,
4839             gasLimit,
4840             keccak256(data_)
4841         );
4842 
4843         bytes32 metaTxHash = EIP712.hashPacked(FORWARDER_DOMAIN_SEPARATOR, encoded);
4844 
4845         // Instead of always taking the expensive path through ER1271,
4846         // skip directly to the wallet owner here (which could still be another contract).
4847         //require(metaTxHash.verifySignature(from, signature), "INVALID_SIGNATURE");
4848         require(!securityStore.isLocked(from), "WALLET_LOCKED");
4849         require(metaTxHash.verifySignature(Wallet(from).owner(), signature), "INVALID_SIGNATURE");
4850     }
4851 
4852     function executeMetaTx(
4853         address from, // the wallet
4854         address to,
4855         uint    nonce,
4856         bytes32 txAwareHash,
4857         address gasToken,
4858         uint    gasPrice,
4859         uint    gasLimit,
4860         bytes   calldata data,
4861         bytes   calldata signature
4862         )
4863         external
4864         returns (
4865             bool success
4866         )
4867     {
4868         MetaTx memory metaTx = MetaTx(
4869             from,
4870             to,
4871             nonce,
4872             txAwareHash,
4873             gasToken,
4874             gasPrice,
4875             gasLimit
4876         );
4877 
4878         uint gasLeft = gasleft();
4879         require(gasLeft >= (gasLimit.mul(64) / 63), "OPERATOR_INSUFFICIENT_GAS");
4880 
4881         // Update the nonce before the call to protect against reentrancy
4882         if (metaTx.nonce != 0) {
4883             require(isNonceValid(metaTx.from, metaTx.nonce), "INVALID_NONCE");
4884             nonces[metaTx.from] = metaTx.nonce;
4885         }
4886 
4887         // The trick is to append the really logical message sender and the
4888         // transaction-aware hash to the end of the call data.
4889         (success, ) = metaTx.to.call{gas : metaTx.gasLimit, value : 0}(
4890             abi.encodePacked(data, metaTx.from, metaTx.txAwareHash)
4891         );
4892 
4893         // It's ok to do the validation after the 'call'. This is also necessary
4894         // in the case of creating the wallet, otherwise, wallet signature validation
4895         // will fail before the wallet is created.
4896         validateMetaTx(
4897             metaTx.from,
4898             metaTx.to,
4899             metaTx.nonce,
4900             metaTx.txAwareHash,
4901             metaTx.gasToken,
4902             metaTx.gasPrice,
4903             metaTx.gasLimit,
4904             data,
4905             signature
4906         );
4907 
4908         uint gasUsed = gasLeft - gasleft() +
4909             (signature.length + data.length + 7 * 32) * 16 + // data input cost
4910             447 +  // cost of MetaTxExecuted = 375 + 9 * 8
4911             23000; // transaction cost;
4912 
4913         // Fees are not to be charged by a relayer if the transaction fails with a
4914         // non-zero txAwareHash. The reason is that relayer can pick arbitrary 'data'
4915         // to make the transaction fail. Charging fees for such failures can drain
4916         // wallet funds.
4917         bool needReimburse = metaTx.gasPrice > 0 && (metaTx.txAwareHash == 0 || success);
4918 
4919         if (needReimburse) {
4920             gasUsed = gasUsed +
4921                 MAX_REIMBURSTMENT_OVERHEAD + // near-worst case cost
4922                 2300; // 2*SLOAD+1*CALL = 2*800+1*700=2300
4923 
4924             if (metaTx.gasToken == address(0)) {
4925                 gasUsed -= 15000; // diff between an regular ERC20 transfer and an ETH send
4926             }
4927 
4928             uint gasToReimburse = gasUsed <= metaTx.gasLimit ? gasUsed : metaTx.gasLimit;
4929 
4930             reimburseGasFee(
4931                 metaTx.from,
4932                 feeCollector,
4933                 metaTx.gasToken,
4934                 metaTx.gasPrice,
4935                 gasToReimburse
4936             );
4937         }
4938 
4939         emit MetaTxExecuted(
4940             msg.sender,
4941             metaTx.from,
4942             metaTx.nonce,
4943             metaTx.txAwareHash,
4944             success,
4945             gasUsed
4946         );
4947     }
4948 
4949     function batchCall(
4950         address   wallet,
4951         address[] calldata to,
4952         bytes[]   calldata data
4953         )
4954         external
4955         txAwareHashNotAllowed()
4956         onlyFromWalletOrOwnerWhenUnlocked(wallet)
4957     {
4958         require(to.length == data.length, "INVALID_DATA");
4959 
4960         for (uint i = 0; i < to.length; i++) {
4961             require(to[i] != address(this), "INVALID_TARGET");
4962             verifyTo(to[i], wallet, data[i]);
4963             // The trick is to append the really logical message sender and the
4964             // transaction-aware hash to the end of the call data.
4965             (bool success, ) = to[i].call(
4966                 abi.encodePacked(data[i], wallet, bytes32(0))
4967             );
4968             require(success, "BATCHED_CALL_FAILED");
4969         }
4970     }
4971 
4972     function lastNonce(address wallet)
4973         public
4974         view
4975         returns (uint)
4976     {
4977         return nonces[wallet];
4978     }
4979 
4980     function isNonceValid(address wallet, uint nonce)
4981         public
4982         view
4983         returns (bool)
4984     {
4985         return nonce > nonces[wallet] && (nonce >> 128) <= block.number;
4986     }
4987 
4988     function verifyTo(
4989         address to,
4990         address wallet,
4991         bytes   memory data
4992         )
4993         private
4994         view
4995     {
4996         // Since this contract is a module, we need to prevent wallet from interacting with
4997         // Stores via this module. Therefore, we must carefully check the 'to' address as follows,
4998         // so no Store can be used as 'to'.
4999         require(
5000             moduleRegistry.isModuleRegistered(to) ||
5001 
5002             // We only allow the wallet to call itself to addModule
5003             (to == wallet) &&
5004             data.toBytes4(0) == Wallet.addModule.selector ||
5005 
5006             to == walletFactory,
5007             "INVALID_DESTINATION_OR_METHOD"
5008         );
5009     }
5010 }
5011 
5012 // File: contracts/modules/core/FinalCoreModule.sol
5013 
5014 // Copyright 2017 Loopring Technology Limited.
5015 
5016 
5017 
5018 
5019 /// @title FinalCoreModule
5020 /// @dev This module combines multiple small modules to
5021 ///      minimize the number of modules to reduce gas used
5022 ///      by wallet creation.
5023 contract FinalCoreModule is
5024     ERC1271Module,
5025     ForwarderModule
5026 {
5027     ControllerImpl private immutable controller_;
5028 
5029     constructor(ControllerImpl _controller)
5030         ForwarderModule(_controller)
5031     {
5032         controller_ = _controller;
5033     }
5034 
5035     function bindableMethods()
5036         public
5037         pure
5038         override
5039         returns (bytes4[] memory)
5040     {
5041         return bindableMethodsForERC1271();
5042     }
5043 }