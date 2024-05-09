1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 library Counters {
10     struct Counter {
11         uint256 _value;
12     }
13 
14     function current(Counter storage counter) internal view returns (uint256) {
15         return counter._value;
16     }
17 
18     function increment(Counter storage counter) internal {
19         unchecked {
20             counter._value += 1;
21         }
22     }
23 
24     function decrement(Counter storage counter) internal {
25         uint256 value = counter._value;
26         require(value > 0, "Counter: decrement overflow");
27         unchecked {
28             counter._value = value - 1;
29         }
30     }
31 
32     function reset(Counter storage counter) internal {
33         counter._value = 0;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/utils/Strings.sol
38 
39 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 library Strings {
44     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
45 
46     function toString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     function toHexString(uint256 value, uint256 length)
79         internal
80         pure
81         returns (string memory)
82     {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Context.sol
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
112 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 library ECDSA {
117     enum RecoverError {
118         NoError,
119         InvalidSignature,
120         InvalidSignatureLength,
121         InvalidSignatureS,
122         InvalidSignatureV // Deprecated in v4.8
123     }
124 
125     function _throwError(RecoverError error) private pure {
126         if (error == RecoverError.NoError) {
127             return; // no error: do nothing
128         } else if (error == RecoverError.InvalidSignature) {
129             revert("ECDSA: invalid signature");
130         } else if (error == RecoverError.InvalidSignatureLength) {
131             revert("ECDSA: invalid signature length");
132         } else if (error == RecoverError.InvalidSignatureS) {
133             revert("ECDSA: invalid signature 's' value");
134         }
135     }
136 
137     /**
138      * @dev Returns the address that signed a hashed message (`hash`) with
139      * `signature` or error string. This address can then be used for verification purposes.
140      *
141      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
142      * this function rejects them by requiring the `s` value to be in the lower
143      * half order, and the `v` value to be either 27 or 28.
144      *
145      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
146      * verification to be secure: it is possible to craft signatures that
147      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
148      * this is by receiving a hash of the original message (which may otherwise
149      * be too long), and then calling {toEthSignedMessageHash} on it.
150      *
151      * Documentation for signature generation:
152      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
153      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
154      *
155      * _Available since v4.3._
156      */
157     function tryRecover(bytes32 hash, bytes memory signature)
158         internal
159         pure
160         returns (address, RecoverError)
161     {
162         if (signature.length == 65) {
163             bytes32 r;
164             bytes32 s;
165             uint8 v;
166             // ecrecover takes the signature parameters, and the only way to get them
167             // currently is to use assembly.
168             /// @solidity memory-safe-assembly
169             assembly {
170                 r := mload(add(signature, 0x20))
171                 s := mload(add(signature, 0x40))
172                 v := byte(0, mload(add(signature, 0x60)))
173             }
174             return tryRecover(hash, v, r, s);
175         } else {
176             return (address(0), RecoverError.InvalidSignatureLength);
177         }
178     }
179 
180     /**
181      * @dev Returns the address that signed a hashed message (`hash`) with
182      * `signature`. This address can then be used for verification purposes.
183      *
184      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
185      * this function rejects them by requiring the `s` value to be in the lower
186      * half order, and the `v` value to be either 27 or 28.
187      *
188      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
189      * verification to be secure: it is possible to craft signatures that
190      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
191      * this is by receiving a hash of the original message (which may otherwise
192      * be too long), and then calling {toEthSignedMessageHash} on it.
193      */
194     function recover(bytes32 hash, bytes memory signature)
195         internal
196         pure
197         returns (address)
198     {
199         (address recovered, RecoverError error) = tryRecover(hash, signature);
200         _throwError(error);
201         return recovered;
202     }
203 
204     /**
205      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
206      *
207      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
208      *
209      * _Available since v4.3._
210      */
211     function tryRecover(
212         bytes32 hash,
213         bytes32 r,
214         bytes32 vs
215     ) internal pure returns (address, RecoverError) {
216         bytes32 s = vs &
217             bytes32(
218                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
219             );
220         uint8 v = uint8((uint256(vs) >> 255) + 27);
221         return tryRecover(hash, v, r, s);
222     }
223 
224     /**
225      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
226      *
227      * _Available since v4.2._
228      */
229     function recover(
230         bytes32 hash,
231         bytes32 r,
232         bytes32 vs
233     ) internal pure returns (address) {
234         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
235         _throwError(error);
236         return recovered;
237     }
238 
239     /**
240      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
241      * `r` and `s` signature fields separately.
242      *
243      * _Available since v4.3._
244      */
245     function tryRecover(
246         bytes32 hash,
247         uint8 v,
248         bytes32 r,
249         bytes32 s
250     ) internal pure returns (address, RecoverError) {
251         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
252         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
253         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
254         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
255         //
256         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
257         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
258         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
259         // these malleable signatures as well.
260         if (
261             uint256(s) >
262             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
263         ) {
264             return (address(0), RecoverError.InvalidSignatureS);
265         }
266 
267         // If the signature is valid (and not malleable), return the signer address
268         address signer = ecrecover(hash, v, r, s);
269         if (signer == address(0)) {
270             return (address(0), RecoverError.InvalidSignature);
271         }
272 
273         return (signer, RecoverError.NoError);
274     }
275 
276     /**
277      * @dev Overload of {ECDSA-recover} that receives the `v`,
278      * `r` and `s` signature fields separately.
279      */
280     function recover(
281         bytes32 hash,
282         uint8 v,
283         bytes32 r,
284         bytes32 s
285     ) internal pure returns (address) {
286         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
287         _throwError(error);
288         return recovered;
289     }
290 
291     /**
292      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
293      * produces hash corresponding to the one signed with the
294      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
295      * JSON-RPC method as part of EIP-191.
296      *
297      * See {recover}.
298      */
299     function toEthSignedMessageHash(bytes32 hash)
300         internal
301         pure
302         returns (bytes32)
303     {
304         // 32 is the length in bytes of hash,
305         // enforced by the type signature above
306         return
307             keccak256(
308                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
309             );
310     }
311 
312     /**
313      * @dev Returns an Ethereum Signed Message, created from `s`. This
314      * produces hash corresponding to the one signed with the
315      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
316      * JSON-RPC method as part of EIP-191.
317      *
318      * See {recover}.
319      */
320     function toEthSignedMessageHash(bytes memory s)
321         internal
322         pure
323         returns (bytes32)
324     {
325         return
326             keccak256(
327                 abi.encodePacked(
328                     "\x19Ethereum Signed Message:\n",
329                     Strings.toString(s.length),
330                     s
331                 )
332             );
333     }
334 
335     /**
336      * @dev Returns an Ethereum Signed Typed Data, created from a
337      * `domainSeparator` and a `structHash`. This produces hash corresponding
338      * to the one signed with the
339      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
340      * JSON-RPC method as part of EIP-712.
341      *
342      * See {recover}.
343      */
344     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
345         internal
346         pure
347         returns (bytes32)
348     {
349         return
350             keccak256(
351                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
352             );
353     }
354 }
355 
356 // File: @openzeppelin/contracts/access/Ownable.sol
357 
358 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 abstract contract Ownable is Context {
363     address private _owner;
364 
365     event OwnershipTransferred(
366         address indexed previousOwner,
367         address indexed newOwner
368     );
369 
370     constructor() {
371         _transferOwnership(_msgSender());
372     }
373 
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     modifier onlyOwner() {
379         require(owner() == _msgSender(), "Ownable: caller is not the owner");
380         _;
381     }
382 
383     function renounceOwnership() public virtual onlyOwner {
384         _transferOwnership(address(0));
385     }
386 
387     function transferOwnership(address newOwner) public virtual onlyOwner {
388         require(
389             newOwner != address(0),
390             "Ownable: new owner is the zero address"
391         );
392         _transferOwnership(newOwner);
393     }
394 
395     function _transferOwnership(address newOwner) internal virtual {
396         address oldOwner = _owner;
397         _owner = newOwner;
398         emit OwnershipTransferred(oldOwner, newOwner);
399     }
400 }
401 
402 // File: @openzeppelin/contracts/utils/Address.sol
403 
404 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 library Address {
409     function isContract(address account) internal view returns (bool) {
410         uint256 size;
411         assembly {
412             size := extcodesize(account)
413         }
414         return size > 0;
415     }
416 
417     function sendValue(address payable recipient, uint256 amount) internal {
418         require(
419             address(this).balance >= amount,
420             "Address: insufficient balance"
421         );
422 
423         (bool success, ) = recipient.call{value: amount}("");
424         require(
425             success,
426             "Address: unable to send value, recipient may have reverted"
427         );
428     }
429 
430     function functionCall(address target, bytes memory data)
431         internal
432         returns (bytes memory)
433     {
434         return functionCall(target, data, "Address: low-level call failed");
435     }
436 
437     function functionCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, 0, errorMessage);
443     }
444 
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return
451             functionCallWithValue(
452                 target,
453                 data,
454                 value,
455                 "Address: low-level call with value failed"
456             );
457     }
458 
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(
466             address(this).balance >= value,
467             "Address: insufficient balance for call"
468         );
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(
472             data
473         );
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     function functionStaticCall(address target, bytes memory data)
478         internal
479         view
480         returns (bytes memory)
481     {
482         return
483             functionStaticCall(
484                 target,
485                 data,
486                 "Address: low-level static call failed"
487             );
488     }
489 
490     function functionStaticCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal view returns (bytes memory) {
495         require(isContract(target), "Address: static call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.staticcall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     function functionDelegateCall(address target, bytes memory data)
502         internal
503         returns (bytes memory)
504     {
505         return
506             functionDelegateCall(
507                 target,
508                 data,
509                 "Address: low-level delegate call failed"
510             );
511     }
512 
513     function functionDelegateCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(isContract(target), "Address: delegate call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.delegatecall(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     function verifyCallResult(
525         bool success,
526         bytes memory returndata,
527         string memory errorMessage
528     ) internal pure returns (bytes memory) {
529         if (success) {
530             return returndata;
531         } else {
532             if (returndata.length > 0) {
533                 assembly {
534                     let returndata_size := mload(returndata)
535                     revert(add(32, returndata), returndata_size)
536                 }
537             } else {
538                 revert(errorMessage);
539             }
540         }
541     }
542 }
543 
544 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
545 
546 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 library MerkleProof {
551     /**
552      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
553      * defined by `root`. For this, a `proof` must be provided, containing
554      * sibling hashes on the branch from the leaf to the root of the tree. Each
555      * pair of leaves and each pair of pre-images are assumed to be sorted.
556      */
557     function verify(
558         bytes32[] memory proof,
559         bytes32 root,
560         bytes32 leaf
561     ) internal pure returns (bool) {
562         return processProof(proof, leaf) == root;
563     }
564 
565     /**
566      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
567      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
568      * hash matches the root of the tree. When processing the proof, the pairs
569      * of leafs & pre-images are assumed to be sorted.
570      *
571      * _Available since v4.4._
572      */
573     function processProof(bytes32[] memory proof, bytes32 leaf)
574         internal
575         pure
576         returns (bytes32)
577     {
578         bytes32 computedHash = leaf;
579         for (uint256 i = 0; i < proof.length; i++) {
580             bytes32 proofElement = proof[i];
581             if (computedHash <= proofElement) {
582                 // Hash(current computed hash + current element of the proof)
583                 computedHash = _efficientHash(computedHash, proofElement);
584             } else {
585                 // Hash(current element of the proof + current computed hash)
586                 computedHash = _efficientHash(proofElement, computedHash);
587             }
588         }
589         return computedHash;
590     }
591 
592     function _efficientHash(bytes32 a, bytes32 b)
593         private
594         pure
595         returns (bytes32 value)
596     {
597         assembly {
598             mstore(0x00, a)
599             mstore(0x20, b)
600             value := keccak256(0x00, 0x40)
601         }
602     }
603 }
604 
605 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
606 
607 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 interface IERC721Receiver {
612     function onERC721Received(
613         address operator,
614         address from,
615         uint256 tokenId,
616         bytes calldata data
617     ) external returns (bytes4);
618 }
619 
620 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
621 
622 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 interface IERC165 {
627     function supportsInterface(bytes4 interfaceId) external view returns (bool);
628 }
629 
630 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
631 
632 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 abstract contract ERC165 is IERC165 {
637     function supportsInterface(bytes4 interfaceId)
638         public
639         view
640         virtual
641         override
642         returns (bool)
643     {
644         return interfaceId == type(IERC165).interfaceId;
645     }
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 interface IERC721 is IERC165 {
655     event Transfer(
656         address indexed from,
657         address indexed to,
658         uint256 indexed tokenId
659     );
660 
661     event Approval(
662         address indexed owner,
663         address indexed approved,
664         uint256 indexed tokenId
665     );
666 
667     event ApprovalForAll(
668         address indexed owner,
669         address indexed operator,
670         bool approved
671     );
672 
673     function balanceOf(address owner) external view returns (uint256 balance);
674 
675     function ownerOf(uint256 tokenId) external view returns (address owner);
676 
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) external;
682 
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) external;
688 
689     function approve(address to, uint256 tokenId) external;
690 
691     function getApproved(uint256 tokenId)
692         external
693         view
694         returns (address operator);
695 
696     function setApprovalForAll(address operator, bool _approved) external;
697 
698     function isApprovedForAll(address owner, address operator)
699         external
700         view
701         returns (bool);
702 
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes calldata data
708     ) external;
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
712 
713 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  */
720 interface IERC721Metadata is IERC721 {
721     function name() external view returns (string memory);
722 
723     function symbol() external view returns (string memory);
724 
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
729 
730 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     string private _name;
739 
740     string private _symbol;
741 
742     mapping(uint256 => address) private _owners;
743 
744     mapping(address => uint256) private _balances;
745 
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     function supportsInterface(bytes4 interfaceId)
756         public
757         view
758         virtual
759         override(ERC165, IERC165)
760         returns (bool)
761     {
762         return
763             interfaceId == type(IERC721).interfaceId ||
764             interfaceId == type(IERC721Metadata).interfaceId ||
765             super.supportsInterface(interfaceId);
766     }
767 
768     function balanceOf(address owner)
769         public
770         view
771         virtual
772         override
773         returns (uint256)
774     {
775         require(
776             owner != address(0),
777             "ERC721: balance query for the zero address"
778         );
779         return _balances[owner];
780     }
781 
782     function ownerOf(uint256 tokenId)
783         public
784         view
785         virtual
786         override
787         returns (address)
788     {
789         address owner = _owners[tokenId];
790         require(
791             owner != address(0),
792             "ERC721: owner query for nonexistent token"
793         );
794         return owner;
795     }
796 
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     function symbol() public view virtual override returns (string memory) {
802         return _symbol;
803     }
804 
805     function tokenURI(uint256 tokenId)
806         public
807         view
808         virtual
809         override
810         returns (string memory)
811     {
812         require(
813             _exists(tokenId),
814             "ERC721Metadata: URI query for nonexistent token"
815         );
816 
817         string memory baseURI = _baseURI();
818         return
819             bytes(baseURI).length > 0
820                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
821                 : "";
822     }
823 
824     function _baseURI() internal view virtual returns (string memory) {
825         return "";
826     }
827 
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721: approve caller is not owner nor approved for all"
835         );
836 
837         _approve(to, tokenId);
838     }
839 
840     function getApproved(uint256 tokenId)
841         public
842         view
843         virtual
844         override
845         returns (address)
846     {
847         require(
848             _exists(tokenId),
849             "ERC721: approved query for nonexistent token"
850         );
851 
852         return _tokenApprovals[tokenId];
853     }
854 
855     function setApprovalForAll(address operator, bool approved)
856         public
857         virtual
858         override
859     {
860         _setApprovalForAll(_msgSender(), operator, approved);
861     }
862 
863     function isApprovedForAll(address owner, address operator)
864         public
865         view
866         virtual
867         override
868         returns (bool)
869     {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     function transferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         //solhint-disable-next-line max-line-length
879         require(
880             _isApprovedOrOwner(_msgSender(), tokenId),
881             "ERC721: transfer caller is not owner nor approved"
882         );
883 
884         _transfer(from, to, tokenId);
885     }
886 
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         safeTransferFrom(from, to, tokenId, "");
893     }
894 
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) public virtual override {
901         require(
902             _isApprovedOrOwner(_msgSender(), tokenId),
903             "ERC721: transfer caller is not owner nor approved"
904         );
905         _safeTransfer(from, to, tokenId, _data);
906     }
907 
908     function _safeTransfer(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) internal virtual {
914         _transfer(from, to, tokenId);
915         require(
916             _checkOnERC721Received(from, to, tokenId, _data),
917             "ERC721: transfer to non ERC721Receiver implementer"
918         );
919     }
920 
921     function _exists(uint256 tokenId) internal view virtual returns (bool) {
922         return _owners[tokenId] != address(0);
923     }
924 
925     function _isApprovedOrOwner(address spender, uint256 tokenId)
926         internal
927         view
928         virtual
929         returns (bool)
930     {
931         require(
932             _exists(tokenId),
933             "ERC721: operator query for nonexistent token"
934         );
935         address owner = ERC721.ownerOf(tokenId);
936         return (spender == owner ||
937             getApproved(tokenId) == spender ||
938             isApprovedForAll(owner, spender));
939     }
940 
941     function _safeMint(address to, uint256 tokenId) internal virtual {
942         _safeMint(to, tokenId, "");
943     }
944 
945     function _safeMint(
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) internal virtual {
950         _mint(to, tokenId);
951         require(
952             _checkOnERC721Received(address(0), to, tokenId, _data),
953             "ERC721: transfer to non ERC721Receiver implementer"
954         );
955     }
956 
957     function _mint(address to, uint256 tokenId) internal virtual {
958         require(to != address(0), "ERC721: mint to the zero address");
959         require(!_exists(tokenId), "ERC721: token already minted");
960 
961         _beforeTokenTransfer(address(0), to, tokenId);
962 
963         _balances[to] += 1;
964         _owners[tokenId] = to;
965 
966         emit Transfer(address(0), to, tokenId);
967     }
968 
969     function _burn(uint256 tokenId) internal virtual {
970         address owner = ERC721.ownerOf(tokenId);
971 
972         _beforeTokenTransfer(owner, address(0), tokenId);
973 
974         _approve(address(0), tokenId);
975 
976         _balances[owner] -= 1;
977         delete _owners[tokenId];
978 
979         emit Transfer(owner, address(0), tokenId);
980     }
981 
982     function _transfer(
983         address from,
984         address to,
985         uint256 tokenId
986     ) internal virtual {
987         require(
988             ERC721.ownerOf(tokenId) == from,
989             "ERC721: transfer of token that is not own"
990         );
991         require(to != address(0), "ERC721: transfer to the zero address");
992 
993         _beforeTokenTransfer(from, to, tokenId);
994 
995         _approve(address(0), tokenId);
996 
997         _balances[from] -= 1;
998         _balances[to] += 1;
999         _owners[tokenId] = to;
1000 
1001         emit Transfer(from, to, tokenId);
1002     }
1003 
1004     function _approve(address to, uint256 tokenId) internal virtual {
1005         _tokenApprovals[tokenId] = to;
1006         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1007     }
1008 
1009     function _setApprovalForAll(
1010         address owner,
1011         address operator,
1012         bool approved
1013     ) internal virtual {
1014         require(owner != operator, "ERC721: approve to caller");
1015         _operatorApprovals[owner][operator] = approved;
1016         emit ApprovalForAll(owner, operator, approved);
1017     }
1018 
1019     function _checkOnERC721Received(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) private returns (bool) {
1025         if (to.isContract()) {
1026             try
1027                 IERC721Receiver(to).onERC721Received(
1028                     _msgSender(),
1029                     from,
1030                     tokenId,
1031                     _data
1032                 )
1033             returns (bytes4 retval) {
1034                 return retval == IERC721Receiver.onERC721Received.selector;
1035             } catch (bytes memory reason) {
1036                 if (reason.length == 0) {
1037                     revert(
1038                         "ERC721: transfer to non ERC721Receiver implementer"
1039                     );
1040                 } else {
1041                     assembly {
1042                         revert(add(32, reason), mload(reason))
1043                     }
1044                 }
1045             }
1046         } else {
1047             return true;
1048         }
1049     }
1050 
1051     function _beforeTokenTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {}
1056 }
1057 
1058 pragma solidity >=0.7.0 <0.9.0;
1059 
1060 contract Amygdala is ERC721, Ownable {
1061     using ECDSA for bytes32;
1062     using Strings for uint256;
1063     using Counters for Counters.Counter;
1064 
1065     Counters.Counter private supply;
1066     address private signerAddress = 0x3546bba3D0e308894223C828bB2A3664b8748071;
1067     string public uriPrefix = "";
1068     string public uriSuffix = ".json";
1069     string public hiddenMetadataUri;
1070 
1071     uint256 public cost = 0.0 ether;
1072     uint256 public maxSupply = 2500;
1073     uint256 public maxMintAmountPerTx = 250;
1074     uint256 public nftPerAddressLimit = 250;
1075 
1076     bool public paused = false;
1077     bool public revealed = false;
1078     bool public onlyWhitelisted = true;
1079 
1080     bytes32 public merkleRoot = 0x1f326643335daabb5d7873451234ca21f4e6b50e79ca2f9c5492309bd37547ff;
1081 
1082     constructor() ERC721("Amygdala", "AMY") {
1083         setHiddenMetadataUri(
1084             "ipfs://QmQw6QSnYjqkF23QvJzb5SY2hHfVLNsp27AK7bjHqutvSA/hidden.json"
1085         );
1086     }
1087 
1088     modifier mintCompliance(uint256 _mintAmount) {
1089         require(
1090             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
1091             "Invalid mint amount!"
1092         );
1093         require(
1094             supply.current() + _mintAmount <= maxSupply,
1095             "Max supply exceeded!"
1096         );
1097         _;
1098     }
1099 
1100     function verifyAddressSigner(bytes memory signature)
1101         private
1102         view
1103         returns (bool)
1104     {
1105         bytes32 messageHash = keccak256(abi.encodePacked(msg.sender));
1106         return
1107             signerAddress ==
1108             messageHash.toEthSignedMessageHash().recover(signature);
1109     }
1110 
1111     function totalSupply() public view returns (uint256) {
1112         return supply.current();
1113     }
1114 
1115     function mint(uint256 _mintAmount)
1116         public
1117         payable
1118         mintCompliance(_mintAmount)
1119     {
1120         require(!paused, "The contract is paused!");
1121         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1122         require(!onlyWhitelisted, "Whitelisted is on!");
1123         uint256 ownerTokenCount = balanceOf(msg.sender);
1124         require(ownerTokenCount < nftPerAddressLimit, "Max supply exceeded!");
1125         _mintLoop(msg.sender, _mintAmount);
1126     }
1127 
1128     function mintForWhitelisted(
1129         uint256 _mintAmount,
1130         bytes32[] calldata _merkleProof
1131     ) public payable mintCompliance(_mintAmount) {
1132         require(!paused, "The contract is paused!");
1133         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1134         if (onlyWhitelisted == true) {
1135             require(isWhitelisted(_merkleProof), "User is not whitelisted");
1136         }
1137         uint256 ownerTokenCount = balanceOf(msg.sender);
1138         require(ownerTokenCount < nftPerAddressLimit, "Max supply exceeded!");
1139         _mintLoop(msg.sender, _mintAmount);
1140     }
1141 
1142     function mintForWhitelistedContract(
1143         uint256 _mintAmount,
1144         bytes memory signature
1145     ) public payable mintCompliance(_mintAmount) {
1146         require(!paused, "The contract is paused!");
1147         require(verifyAddressSigner(signature), "SIGNATURE_VALIDATION_FAILED");
1148         uint256 ownerTokenCount = balanceOf(msg.sender);
1149         require(ownerTokenCount < nftPerAddressLimit, "Max supply exceeded!");
1150         _mintLoop(msg.sender, _mintAmount);
1151     }
1152 
1153     function isWhitelisted(bytes32[] calldata _merkleProof)
1154         public
1155         view
1156         returns (bool)
1157     {
1158         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1159         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1160     }
1161 
1162     function checkingWhitelisted(
1163         address sender,
1164         bytes32[] calldata _merkleProof
1165     ) public view returns (bool) {
1166         bytes32 leaf = keccak256(abi.encodePacked(sender));
1167         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1168     }
1169 
1170     function mintForAddress(uint256 _mintAmount, address _receiver)
1171         public
1172         mintCompliance(_mintAmount)
1173         onlyOwner
1174     {
1175         _mintLoop(_receiver, _mintAmount);
1176     }
1177 
1178     function walletOfOwner(address _owner)
1179         public
1180         view
1181         returns (uint256[] memory)
1182     {
1183         uint256 ownerTokenCount = balanceOf(_owner);
1184         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1185         uint256 currentTokenId = 1;
1186         uint256 ownedTokenIndex = 0;
1187 
1188         while (
1189             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1190         ) {
1191             address currentTokenOwner = ownerOf(currentTokenId);
1192 
1193             if (currentTokenOwner == _owner) {
1194                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1195 
1196                 ownedTokenIndex++;
1197             }
1198 
1199             currentTokenId++;
1200         }
1201 
1202         return ownedTokenIds;
1203     }
1204 
1205     function tokenURI(uint256 _tokenId)
1206         public
1207         view
1208         virtual
1209         override
1210         returns (string memory)
1211     {
1212         require(
1213             _exists(_tokenId),
1214             "ERC721Metadata: URI query for nonexistent token"
1215         );
1216 
1217         if (revealed == false) {
1218             return hiddenMetadataUri;
1219         }
1220 
1221         string memory currentBaseURI = _baseURI();
1222         return
1223             bytes(currentBaseURI).length > 0
1224                 ? string(
1225                     abi.encodePacked(
1226                         currentBaseURI,
1227                         _tokenId.toString(),
1228                         uriSuffix
1229                     )
1230                 )
1231                 : "";
1232     }
1233 
1234     function setRevealed(bool _state) public onlyOwner {
1235         revealed = _state;
1236     }
1237 
1238     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1239         nftPerAddressLimit = _limit;
1240     }
1241 
1242     function setCost(uint256 _cost) public onlyOwner {
1243         cost = _cost;
1244     }
1245 
1246     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1247         public
1248         onlyOwner
1249     {
1250         maxMintAmountPerTx = _maxMintAmountPerTx;
1251     }
1252 
1253     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1254         public
1255         onlyOwner
1256     {
1257         hiddenMetadataUri = _hiddenMetadataUri;
1258     }
1259 
1260     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1261         uriPrefix = _uriPrefix;
1262     }
1263 
1264     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1265         uriSuffix = _uriSuffix;
1266     }
1267 
1268     function setPaused(bool _state) public onlyOwner {
1269         paused = _state;
1270     }
1271 
1272     function setOnlyWhitelisted(bool _state) public onlyOwner {
1273         onlyWhitelisted = _state;
1274     }
1275 
1276     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1277         merkleRoot = _merkleRoot;
1278     }
1279 
1280     function withdraw() public onlyOwner {
1281         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1282         require(os);
1283     }
1284 
1285     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1286         for (uint256 i = 0; i < _mintAmount; i++) {
1287             supply.increment();
1288             _safeMint(_receiver, supply.current());
1289         }
1290     }
1291 
1292     function _baseURI() internal view virtual override returns (string memory) {
1293         return uriPrefix;
1294     }
1295 }