1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
140 
141 
142 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 // CAUTION
147 // This version of SafeMath should only be used with Solidity 0.8 or later,
148 // because it relies on the compiler's built in overflow checks.
149 
150 /**
151  * @dev Wrappers over Solidity's arithmetic operations.
152  *
153  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
154  * now has built in overflow checking.
155  */
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             uint256 c = a + b;
165             if (c < a) return (false, 0);
166             return (true, c);
167         }
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
172      *
173      * _Available since v3.4._
174      */
175     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         unchecked {
177             if (b > a) return (false, 0);
178             return (true, a - b);
179         }
180     }
181 
182     /**
183      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         unchecked {
189             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190             // benefit is lost if 'b' is also tested.
191             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192             if (a == 0) return (true, 0);
193             uint256 c = a * b;
194             if (c / a != b) return (false, 0);
195             return (true, c);
196         }
197     }
198 
199     /**
200      * @dev Returns the division of two unsigned integers, with a division by zero flag.
201      *
202      * _Available since v3.4._
203      */
204     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             if (b == 0) return (false, 0);
207             return (true, a / b);
208         }
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
213      *
214      * _Available since v3.4._
215      */
216     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         unchecked {
218             if (b == 0) return (false, 0);
219             return (true, a % b);
220         }
221     }
222 
223     /**
224      * @dev Returns the addition of two unsigned integers, reverting on
225      * overflow.
226      *
227      * Counterpart to Solidity's `+` operator.
228      *
229      * Requirements:
230      *
231      * - Addition cannot overflow.
232      */
233     function add(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a + b;
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a - b;
249     }
250 
251     /**
252      * @dev Returns the multiplication of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `*` operator.
256      *
257      * Requirements:
258      *
259      * - Multiplication cannot overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a * b;
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers, reverting on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator.
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a / b;
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * reverting when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a % b;
293     }
294 
295     /**
296      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
297      * overflow (when the result is negative).
298      *
299      * CAUTION: This function is deprecated because it requires allocating memory for the error
300      * message unnecessarily. For custom revert reasons use {trySub}.
301      *
302      * Counterpart to Solidity's `-` operator.
303      *
304      * Requirements:
305      *
306      * - Subtraction cannot overflow.
307      */
308     function sub(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b <= a, errorMessage);
315             return a - b;
316         }
317     }
318 
319     /**
320      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
321      * division by zero. The result is rounded towards zero.
322      *
323      * Counterpart to Solidity's `/` operator. Note: this function uses a
324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
325      * uses an invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function div(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a / b;
339         }
340     }
341 
342     /**
343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
344      * reverting with custom message when dividing by zero.
345      *
346      * CAUTION: This function is deprecated because it requires allocating memory for the error
347      * message unnecessarily. For custom revert reasons use {tryMod}.
348      *
349      * Counterpart to Solidity's `%` operator. This function uses a `revert`
350      * opcode (which leaves remaining gas untouched) while Solidity uses an
351      * invalid opcode to revert (consuming all remaining gas).
352      *
353      * Requirements:
354      *
355      * - The divisor cannot be zero.
356      */
357     function mod(
358         uint256 a,
359         uint256 b,
360         string memory errorMessage
361     ) internal pure returns (uint256) {
362         unchecked {
363             require(b > 0, errorMessage);
364             return a % b;
365         }
366     }
367 }
368 
369 // File: @openzeppelin/contracts/utils/Context.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Provides information about the current execution context, including the
378  * sender of the transaction and its data. While these are generally available
379  * via msg.sender and msg.data, they should not be accessed in such a direct
380  * manner, since when dealing with meta-transactions the account sending and
381  * paying for execution may not be the actual sender (as far as an application
382  * is concerned).
383  *
384  * This contract is only required for intermediate, library-like contracts.
385  */
386 abstract contract Context {
387     function _msgSender() internal view virtual returns (address) {
388         return msg.sender;
389     }
390 
391     function _msgData() internal view virtual returns (bytes calldata) {
392         return msg.data;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/access/Ownable.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Contract module which provides a basic access control mechanism, where
406  * there is an account (an owner) that can be granted exclusive access to
407  * specific functions.
408  *
409  * By default, the owner account will be the one that deploys the contract. This
410  * can later be changed with {transferOwnership}.
411  *
412  * This module is used through inheritance. It will make available the modifier
413  * `onlyOwner`, which can be applied to your functions to restrict their use to
414  * the owner.
415  */
416 abstract contract Ownable is Context {
417     address private _owner;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor() {
425         _transferOwnership(_msgSender());
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view virtual returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         _transferOwnership(address(0));
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Can only be called by the current owner.
457      */
458     function transferOwnership(address newOwner) public virtual onlyOwner {
459         require(newOwner != address(0), "Ownable: new owner is the zero address");
460         _transferOwnership(newOwner);
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Internal function without access restriction.
466      */
467     function _transferOwnership(address newOwner) internal virtual {
468         address oldOwner = _owner;
469         _owner = newOwner;
470         emit OwnershipTransferred(oldOwner, newOwner);
471     }
472 }
473 
474 // File: contracts/IERC721A.sol
475 
476 
477 // ERC721A Contracts v4.0.0
478 // Creator: Chiru Labs
479 
480 pragma solidity ^0.8.4;
481 
482 /**
483  * @dev Interface of an ERC721A compliant contract.
484  */
485 interface IERC721A {
486     /**
487      * The caller must own the token or be an approved operator.
488      */
489     error ApprovalCallerNotOwnerNorApproved();
490 
491     /**
492      * The token does not exist.
493      */
494     error ApprovalQueryForNonexistentToken();
495 
496     /**
497      * The caller cannot approve to their own address.
498      */
499     error ApproveToCaller();
500 
501     /**
502      * The caller cannot approve to the current owner.
503      */
504     error ApprovalToCurrentOwner();
505 
506     /**
507      * Cannot query the balance for the zero address.
508      */
509     error BalanceQueryForZeroAddress();
510 
511     /**
512      * Cannot mint to the zero address.
513      */
514     error MintToZeroAddress();
515 
516     /**
517      * The quantity of tokens minted must be more than zero.
518      */
519     error MintZeroQuantity();
520 
521     /**
522      * The token does not exist.
523      */
524     error OwnerQueryForNonexistentToken();
525 
526     /**
527      * The caller must own the token or be an approved operator.
528      */
529     error TransferCallerNotOwnerNorApproved();
530 
531     /**
532      * The token must be owned by `from`.
533      */
534     error TransferFromIncorrectOwner();
535 
536     /**
537      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
538      */
539     error TransferToNonERC721ReceiverImplementer();
540 
541     /**
542      * Cannot transfer to the zero address.
543      */
544     error TransferToZeroAddress();
545 
546     /**
547      * The token does not exist.
548      */
549     error URIQueryForNonexistentToken();
550 
551     struct TokenOwnership {
552         // The address of the owner.
553         address addr;
554         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
555         uint64 startTimestamp;
556         // Whether the token has been burned.
557         bool burned;
558     }
559 
560     /**
561      * @dev Returns the total amount of tokens stored by the contract.
562      *
563      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
564      */
565     function totalSupply() external view returns (uint256);
566 
567     // ==============================
568     //            IERC165
569     // ==============================
570 
571     /**
572      * @dev Returns true if this contract implements the interface defined by
573      * `interfaceId`. See the corresponding
574      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
575      * to learn more about how these ids are created.
576      *
577      * This function call must use less than 30 000 gas.
578      */
579     function supportsInterface(bytes4 interfaceId) external view returns (bool);
580 
581     // ==============================
582     //            IERC721
583     // ==============================
584 
585     /**
586      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
587      */
588     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
592      */
593     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
597      */
598     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
599 
600     /**
601      * @dev Returns the number of tokens in ``owner``'s account.
602      */
603     function balanceOf(address owner) external view returns (uint256 balance);
604 
605     /**
606      * @dev Returns the owner of the `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function ownerOf(uint256 tokenId) external view returns (address owner);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
633 
634     /**
635      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
636      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Transfers `tokenId` token from `from` to `to`.
656      *
657      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
676      * The approval is cleared when the token is transferred.
677      *
678      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
679      *
680      * Requirements:
681      *
682      * - The caller must own the token or be an approved operator.
683      * - `tokenId` must exist.
684      *
685      * Emits an {Approval} event.
686      */
687     function approve(address to, uint256 tokenId) external;
688 
689     /**
690      * @dev Approve or remove `operator` as an operator for the caller.
691      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
692      *
693      * Requirements:
694      *
695      * - The `operator` cannot be the caller.
696      *
697      * Emits an {ApprovalForAll} event.
698      */
699     function setApprovalForAll(address operator, bool _approved) external;
700 
701     /**
702      * @dev Returns the account approved for `tokenId` token.
703      *
704      * Requirements:
705      *
706      * - `tokenId` must exist.
707      */
708     function getApproved(uint256 tokenId) external view returns (address operator);
709 
710     /**
711      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
712      *
713      * See {setApprovalForAll}
714      */
715     function isApprovedForAll(address owner, address operator) external view returns (bool);
716 
717     // ==============================
718     //        IERC721Metadata
719     // ==============================
720 
721     /**
722      * @dev Returns the token collection name.
723      */
724     function name() external view returns (string memory);
725 
726     /**
727      * @dev Returns the token collection symbol.
728      */
729     function symbol() external view returns (string memory);
730 
731     /**
732      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
733      */
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 // File: contracts/ERC721A.sol
738 
739 
740 // ERC721A Contracts v4.0.0
741 // Creator: Chiru Labs
742 
743 pragma solidity ^0.8.4;
744 
745 
746 /**
747  * @dev ERC721 token receiver interface.
748  */
749 interface ERC721A__IERC721Receiver {
750     function onERC721Received(
751         address operator,
752         address from,
753         uint256 tokenId,
754         bytes calldata data
755     ) external returns (bytes4);
756 }
757 
758 /**
759  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
760  * the Metadata extension. Built to optimize for lower gas during batch mints.
761  *
762  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
763  *
764  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
765  *
766  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
767  */
768 contract ERC721A is IERC721A {
769     // Mask of an entry in packed address data.
770     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
771 
772     // The bit position of `numberMinted` in packed address data.
773     uint256 private constant BITPOS_NUMBER_MINTED = 64;
774 
775     // The bit position of `numberBurned` in packed address data.
776     uint256 private constant BITPOS_NUMBER_BURNED = 128;
777 
778     // The bit position of `aux` in packed address data.
779     uint256 private constant BITPOS_AUX = 192;
780 
781     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
782     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
783 
784     // The bit position of `startTimestamp` in packed ownership.
785     uint256 private constant BITPOS_START_TIMESTAMP = 160;
786 
787     // The bit mask of the `burned` bit in packed ownership.
788     uint256 private constant BITMASK_BURNED = 1 << 224;
789     
790     // The bit position of the `nextInitialized` bit in packed ownership.
791     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
792 
793     // The bit mask of the `nextInitialized` bit in packed ownership.
794     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
795 
796     // The tokenId of the next token to be minted.
797     uint256 private _currentIndex;
798 
799     // The number of tokens burned.
800     uint256 private _burnCounter;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to ownership details
809     // An empty struct value does not necessarily mean the token is unowned.
810     // See `_packedOwnershipOf` implementation for details.
811     //
812     // Bits Layout:
813     // - [0..159]   `addr`
814     // - [160..223] `startTimestamp`
815     // - [224]      `burned`
816     // - [225]      `nextInitialized`
817     mapping(uint256 => uint256) private _packedOwnerships;
818 
819     // Mapping owner address to address data.
820     //
821     // Bits Layout:
822     // - [0..63]    `balance`
823     // - [64..127]  `numberMinted`
824     // - [128..191] `numberBurned`
825     // - [192..255] `aux`
826     mapping(address => uint256) private _packedAddressData;
827 
828     // Mapping from token ID to approved address.
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837         _currentIndex = _startTokenId();
838     }
839 
840     /**
841      * @dev Returns the starting token ID. 
842      * To change the starting token ID, please override this function.
843      */
844     function _startTokenId() internal view virtual returns (uint256) {
845         return 0;
846     }
847 
848     /**
849      * @dev Returns the next token ID to be minted.
850      */
851     function _nextTokenId() internal view returns (uint256) {
852         return _currentIndex;
853     }
854 
855     /**
856      * @dev Returns the total number of tokens in existence.
857      * Burned tokens will reduce the count. 
858      * To get the total number of tokens minted, please see `_totalMinted`.
859      */
860     function totalSupply() public view override returns (uint256) {
861         // Counter underflow is impossible as _burnCounter cannot be incremented
862         // more than `_currentIndex - _startTokenId()` times.
863         unchecked {
864             return _currentIndex - _burnCounter - _startTokenId();
865         }
866     }
867 
868     /**
869      * @dev Returns the total amount of tokens minted in the contract.
870      */
871     function _totalMinted() internal view returns (uint256) {
872         // Counter underflow is impossible as _currentIndex does not decrement,
873         // and it is initialized to `_startTokenId()`
874         unchecked {
875             return _currentIndex - _startTokenId();
876         }
877     }
878 
879     /**
880      * @dev Returns the total number of tokens burned.
881      */
882     function _totalBurned() internal view returns (uint256) {
883         return _burnCounter;
884     }
885 
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
890         // The interface IDs are constants representing the first 4 bytes of the XOR of
891         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
892         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
893         return
894             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
895             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
896             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
897     }
898 
899     /**
900      * @dev See {IERC721-balanceOf}.
901      */
902     function balanceOf(address owner) public view override returns (uint256) {
903         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
904         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
905     }
906 
907     /**
908      * Returns the number of tokens minted by `owner`.
909      */
910     function _numberMinted(address owner) internal view returns (uint256) {
911         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
912     }
913 
914     /**
915      * Returns the number of tokens burned by or on behalf of `owner`.
916      */
917     function _numberBurned(address owner) internal view returns (uint256) {
918         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
919     }
920 
921     /**
922      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
923      */
924     function _getAux(address owner) internal view returns (uint64) {
925         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
926     }
927 
928     /**
929      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
930      * If there are multiple variables, please pack them into a uint64.
931      */
932     function _setAux(address owner, uint64 aux) internal {
933         uint256 packed = _packedAddressData[owner];
934         uint256 auxCasted;
935         assembly { // Cast aux without masking.
936             auxCasted := aux
937         }
938         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
939         _packedAddressData[owner] = packed;
940     }
941 
942     /**
943      * Returns the packed ownership data of `tokenId`.
944      */
945     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
946         uint256 curr = tokenId;
947 
948         unchecked {
949             if (_startTokenId() <= curr)
950                 if (curr < _currentIndex) {
951                     uint256 packed = _packedOwnerships[curr];
952                     // If not burned.
953                     if (packed & BITMASK_BURNED == 0) {
954                         // Invariant:
955                         // There will always be an ownership that has an address and is not burned
956                         // before an ownership that does not have an address and is not burned.
957                         // Hence, curr will not underflow.
958                         //
959                         // We can directly compare the packed value.
960                         // If the address is zero, packed is zero.
961                         while (packed == 0) {
962                             packed = _packedOwnerships[--curr];
963                         }
964                         return packed;
965                     }
966                 }
967         }
968         revert OwnerQueryForNonexistentToken();
969     }
970 
971     /**
972      * Returns the unpacked `TokenOwnership` struct from `packed`.
973      */
974     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
975         ownership.addr = address(uint160(packed));
976         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
977         ownership.burned = packed & BITMASK_BURNED != 0;
978     }
979 
980     /**
981      * Returns the unpacked `TokenOwnership` struct at `index`.
982      */
983     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
984         return _unpackedOwnership(_packedOwnerships[index]);
985     }
986 
987     /**
988      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
989      */
990     function _initializeOwnershipAt(uint256 index) internal {
991         if (_packedOwnerships[index] == 0) {
992             _packedOwnerships[index] = _packedOwnershipOf(index);
993         }
994     }
995 
996     /**
997      * Gas spent here starts off proportional to the maximum mint batch size.
998      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
999      */
1000     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1001         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-ownerOf}.
1006      */
1007     function ownerOf(uint256 tokenId) public view override returns (address) {
1008         return address(uint160(_packedOwnershipOf(tokenId)));
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-name}.
1013      */
1014     function name() public view virtual override returns (string memory) {
1015         return _name;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-symbol}.
1020      */
1021     function symbol() public view virtual override returns (string memory) {
1022         return _symbol;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-tokenURI}.
1027      */
1028     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1029         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1030 
1031         string memory baseURI = _baseURI();
1032         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1033     }
1034 
1035     /**
1036      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1037      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1038      * by default, can be overriden in child contracts.
1039      */
1040     function _baseURI() internal view virtual returns (string memory) {
1041         return '';
1042     }
1043 
1044     /**
1045      * @dev Casts the address to uint256 without masking.
1046      */
1047     function _addressToUint256(address value) private pure returns (uint256 result) {
1048         assembly {
1049             result := value
1050         }
1051     }
1052 
1053     /**
1054      * @dev Casts the boolean to uint256 without branching.
1055      */
1056     function _boolToUint256(bool value) private pure returns (uint256 result) {
1057         assembly {
1058             result := value
1059         }
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-approve}.
1064      */
1065     function approve(address to, uint256 tokenId) public override {
1066         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1067         if (to == owner) revert ApprovalToCurrentOwner();
1068 
1069         if (_msgSenderERC721A() != owner)
1070             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1071                 revert ApprovalCallerNotOwnerNorApproved();
1072             }
1073 
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(owner, to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-getApproved}.
1080      */
1081     function getApproved(uint256 tokenId) public view override returns (address) {
1082         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1083 
1084         return _tokenApprovals[tokenId];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-setApprovalForAll}.
1089      */
1090     function setApprovalForAll(address operator, bool approved) public virtual override {
1091         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1092 
1093         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1094         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-isApprovedForAll}.
1099      */
1100     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1101         return _operatorApprovals[owner][operator];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-transferFrom}.
1106      */
1107     function transferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public virtual override {
1112         _transfer(from, to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-safeTransferFrom}.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) public virtual override {
1123         safeTransferFrom(from, to, tokenId, '');
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-safeTransferFrom}.
1128      */
1129     function safeTransferFrom(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) public virtual override {
1135         _transfer(from, to, tokenId);
1136         if (to.code.length != 0)
1137             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1138                 revert TransferToNonERC721ReceiverImplementer();
1139             }
1140     }
1141 
1142     /**
1143      * @dev Returns whether `tokenId` exists.
1144      *
1145      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1146      *
1147      * Tokens start existing when they are minted (`_mint`),
1148      */
1149     function _exists(uint256 tokenId) internal view returns (bool) {
1150         return
1151             _startTokenId() <= tokenId &&
1152             tokenId < _currentIndex && // If within bounds,
1153             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1154     }
1155 
1156     /**
1157      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1158      */
1159     function _safeMint(address to, uint256 quantity) internal {
1160         _safeMint(to, quantity, '');
1161     }
1162 
1163     /**
1164      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - If `to` refers to a smart contract, it must implement
1169      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1170      * - `quantity` must be greater than 0.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _safeMint(
1175         address to,
1176         uint256 quantity,
1177         bytes memory _data
1178     ) internal {
1179         uint256 startTokenId = _currentIndex;
1180         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1181         if (quantity == 0) revert MintZeroQuantity();
1182 
1183         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1184 
1185         // Overflows are incredibly unrealistic.
1186         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1187         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1188         unchecked {
1189             // Updates:
1190             // - `balance += quantity`.
1191             // - `numberMinted += quantity`.
1192             //
1193             // We can directly add to the balance and number minted.
1194             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1195 
1196             // Updates:
1197             // - `address` to the owner.
1198             // - `startTimestamp` to the timestamp of minting.
1199             // - `burned` to `false`.
1200             // - `nextInitialized` to `quantity == 1`.
1201             _packedOwnerships[startTokenId] =
1202                 _addressToUint256(to) |
1203                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1204                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1205 
1206             uint256 updatedIndex = startTokenId;
1207             uint256 end = updatedIndex + quantity;
1208 
1209             if (to.code.length != 0) {
1210                 do {
1211                     emit Transfer(address(0), to, updatedIndex);
1212                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1213                         revert TransferToNonERC721ReceiverImplementer();
1214                     }
1215                 } while (updatedIndex < end);
1216                 // Reentrancy protection
1217                 if (_currentIndex != startTokenId) revert();
1218             } else {
1219                 do {
1220                     emit Transfer(address(0), to, updatedIndex++);
1221                 } while (updatedIndex < end);
1222             }
1223             _currentIndex = updatedIndex;
1224         }
1225         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1226     }
1227 
1228     /**
1229      * @dev Mints `quantity` tokens and transfers them to `to`.
1230      *
1231      * Requirements:
1232      *
1233      * - `to` cannot be the zero address.
1234      * - `quantity` must be greater than 0.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _mint(address to, uint256 quantity) internal {
1239         uint256 startTokenId = _currentIndex;
1240         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1241         if (quantity == 0) revert MintZeroQuantity();
1242 
1243         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1244 
1245         // Overflows are incredibly unrealistic.
1246         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1247         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1248         unchecked {
1249             // Updates:
1250             // - `balance += quantity`.
1251             // - `numberMinted += quantity`.
1252             //
1253             // We can directly add to the balance and number minted.
1254             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1255 
1256             // Updates:
1257             // - `address` to the owner.
1258             // - `startTimestamp` to the timestamp of minting.
1259             // - `burned` to `false`.
1260             // - `nextInitialized` to `quantity == 1`.
1261             _packedOwnerships[startTokenId] =
1262                 _addressToUint256(to) |
1263                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1264                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1265 
1266             uint256 updatedIndex = startTokenId;
1267             uint256 end = updatedIndex + quantity;
1268 
1269             do {
1270                 emit Transfer(address(0), to, updatedIndex++);
1271             } while (updatedIndex < end);
1272 
1273             _currentIndex = updatedIndex;
1274         }
1275         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1276     }
1277 
1278     /**
1279      * @dev Transfers `tokenId` from `from` to `to`.
1280      *
1281      * Requirements:
1282      *
1283      * - `to` cannot be the zero address.
1284      * - `tokenId` token must be owned by `from`.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function _transfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) private {
1293         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1294 
1295         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1296 
1297         address approvedAddress = _tokenApprovals[tokenId];
1298 
1299         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1300             isApprovedForAll(from, _msgSenderERC721A()) ||
1301             approvedAddress == _msgSenderERC721A());
1302 
1303         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1304         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1305 
1306         _beforeTokenTransfers(from, to, tokenId, 1);
1307 
1308         // Clear approvals from the previous owner.
1309         if (_addressToUint256(approvedAddress) != 0) {
1310             delete _tokenApprovals[tokenId];
1311         }
1312 
1313         // Underflow of the sender's balance is impossible because we check for
1314         // ownership above and the recipient's balance can't realistically overflow.
1315         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1316         unchecked {
1317             // We can directly increment and decrement the balances.
1318             --_packedAddressData[from]; // Updates: `balance -= 1`.
1319             ++_packedAddressData[to]; // Updates: `balance += 1`.
1320 
1321             // Updates:
1322             // - `address` to the next owner.
1323             // - `startTimestamp` to the timestamp of transfering.
1324             // - `burned` to `false`.
1325             // - `nextInitialized` to `true`.
1326             _packedOwnerships[tokenId] =
1327                 _addressToUint256(to) |
1328                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1329                 BITMASK_NEXT_INITIALIZED;
1330 
1331             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1332             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1333                 uint256 nextTokenId = tokenId + 1;
1334                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1335                 if (_packedOwnerships[nextTokenId] == 0) {
1336                     // If the next slot is within bounds.
1337                     if (nextTokenId != _currentIndex) {
1338                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1339                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1340                     }
1341                 }
1342             }
1343         }
1344 
1345         emit Transfer(from, to, tokenId);
1346         _afterTokenTransfers(from, to, tokenId, 1);
1347     }
1348 
1349     /**
1350      * @dev Equivalent to `_burn(tokenId, false)`.
1351      */
1352     function _burn(uint256 tokenId) internal virtual {
1353         _burn(tokenId, false);
1354     }
1355 
1356     /**
1357      * @dev Destroys `tokenId`.
1358      * The approval is cleared when the token is burned.
1359      *
1360      * Requirements:
1361      *
1362      * - `tokenId` must exist.
1363      *
1364      * Emits a {Transfer} event.
1365      */
1366     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1367         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1368 
1369         address from = address(uint160(prevOwnershipPacked));
1370         address approvedAddress = _tokenApprovals[tokenId];
1371 
1372         if (approvalCheck) {
1373             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1374                 isApprovedForAll(from, _msgSenderERC721A()) ||
1375                 approvedAddress == _msgSenderERC721A());
1376 
1377             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1378         }
1379 
1380         _beforeTokenTransfers(from, address(0), tokenId, 1);
1381 
1382         // Clear approvals from the previous owner.
1383         if (_addressToUint256(approvedAddress) != 0) {
1384             delete _tokenApprovals[tokenId];
1385         }
1386 
1387         // Underflow of the sender's balance is impossible because we check for
1388         // ownership above and the recipient's balance can't realistically overflow.
1389         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1390         unchecked {
1391             // Updates:
1392             // - `balance -= 1`.
1393             // - `numberBurned += 1`.
1394             //
1395             // We can directly decrement the balance, and increment the number burned.
1396             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1397             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1398 
1399             // Updates:
1400             // - `address` to the last owner.
1401             // - `startTimestamp` to the timestamp of burning.
1402             // - `burned` to `true`.
1403             // - `nextInitialized` to `true`.
1404             _packedOwnerships[tokenId] =
1405                 _addressToUint256(from) |
1406                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1407                 BITMASK_BURNED | 
1408                 BITMASK_NEXT_INITIALIZED;
1409 
1410             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1411             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1412                 uint256 nextTokenId = tokenId + 1;
1413                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1414                 if (_packedOwnerships[nextTokenId] == 0) {
1415                     // If the next slot is within bounds.
1416                     if (nextTokenId != _currentIndex) {
1417                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1418                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1419                     }
1420                 }
1421             }
1422         }
1423 
1424         emit Transfer(from, address(0), tokenId);
1425         _afterTokenTransfers(from, address(0), tokenId, 1);
1426 
1427         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1428         unchecked {
1429             _burnCounter++;
1430         }
1431     }
1432 
1433     /**
1434      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1435      *
1436      * @param from address representing the previous owner of the given token ID
1437      * @param to target address that will receive the tokens
1438      * @param tokenId uint256 ID of the token to be transferred
1439      * @param _data bytes optional data to send along with the call
1440      * @return bool whether the call correctly returned the expected magic value
1441      */
1442     function _checkContractOnERC721Received(
1443         address from,
1444         address to,
1445         uint256 tokenId,
1446         bytes memory _data
1447     ) private returns (bool) {
1448         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1449             bytes4 retval
1450         ) {
1451             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1452         } catch (bytes memory reason) {
1453             if (reason.length == 0) {
1454                 revert TransferToNonERC721ReceiverImplementer();
1455             } else {
1456                 assembly {
1457                     revert(add(32, reason), mload(reason))
1458                 }
1459             }
1460         }
1461     }
1462 
1463     /**
1464      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1465      * And also called before burning one token.
1466      *
1467      * startTokenId - the first token id to be transferred
1468      * quantity - the amount to be transferred
1469      *
1470      * Calling conditions:
1471      *
1472      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1473      * transferred to `to`.
1474      * - When `from` is zero, `tokenId` will be minted for `to`.
1475      * - When `to` is zero, `tokenId` will be burned by `from`.
1476      * - `from` and `to` are never both zero.
1477      */
1478     function _beforeTokenTransfers(
1479         address from,
1480         address to,
1481         uint256 startTokenId,
1482         uint256 quantity
1483     ) internal virtual {}
1484 
1485     /**
1486      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1487      * minting.
1488      * And also called after one token has been burned.
1489      *
1490      * startTokenId - the first token id to be transferred
1491      * quantity - the amount to be transferred
1492      *
1493      * Calling conditions:
1494      *
1495      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1496      * transferred to `to`.
1497      * - When `from` is zero, `tokenId` has been minted for `to`.
1498      * - When `to` is zero, `tokenId` has been burned by `from`.
1499      * - `from` and `to` are never both zero.
1500      */
1501     function _afterTokenTransfers(
1502         address from,
1503         address to,
1504         uint256 startTokenId,
1505         uint256 quantity
1506     ) internal virtual {}
1507 
1508     /**
1509      * @dev Returns the message sender (defaults to `msg.sender`).
1510      *
1511      * If you are writing GSN compatible contracts, you need to override this function.
1512      */
1513     function _msgSenderERC721A() internal view virtual returns (address) {
1514         return msg.sender;
1515     }
1516 
1517     /**
1518      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1519      */
1520     function _toString(uint256 value) internal pure returns (string memory ptr) {
1521         assembly {
1522             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1523             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1524             // We will need 1 32-byte word to store the length, 
1525             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1526             ptr := add(mload(0x40), 128)
1527             // Update the free memory pointer to allocate.
1528             mstore(0x40, ptr)
1529 
1530             // Cache the end of the memory to calculate the length later.
1531             let end := ptr
1532 
1533             // We write the string from the rightmost digit to the leftmost digit.
1534             // The following is essentially a do-while loop that also handles the zero case.
1535             // Costs a bit more than early returning for the zero case,
1536             // but cheaper in terms of deployment and overall runtime costs.
1537             for { 
1538                 // Initialize and perform the first pass without check.
1539                 let temp := value
1540                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1541                 ptr := sub(ptr, 1)
1542                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1543                 mstore8(ptr, add(48, mod(temp, 10)))
1544                 temp := div(temp, 10)
1545             } temp { 
1546                 // Keep dividing `temp` until zero.
1547                 temp := div(temp, 10)
1548             } { // Body of the for loop.
1549                 ptr := sub(ptr, 1)
1550                 mstore8(ptr, add(48, mod(temp, 10)))
1551             }
1552             
1553             let length := sub(end, ptr)
1554             // Move the pointer 32 bytes leftwards to make room for the length.
1555             ptr := sub(ptr, 32)
1556             // Store the length.
1557             mstore(ptr, length)
1558         }
1559     }
1560 }
1561 
1562 // File: contracts/VIVID.sol
1563 
1564 
1565 
1566 pragma solidity ^0.8.10;
1567 
1568 //         ▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1569 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1570 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1571 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1572 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1573 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1574 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1575 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1576 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1577 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓
1578 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓
1579 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓
1580 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓     ▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓
1581 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓
1582 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓
1583 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓
1584 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓
1585 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓
1586 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓
1587 //           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓
1588 //              ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓
1589 //         ▓▓▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▒▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓
1590 //         ▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓
1591 //         ▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▒     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1592 //         ▓▓▓▓▓▓▓▓▓▓▓▒    ▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1593 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1594 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1595 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1596 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1597 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1598 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1599 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1600 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓░    ▓▓▓▓▓▓▓▓▓▒     ▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓
1601 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓     ▓▓▓▓▓▓      ▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓
1602 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▓▓      ▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓
1603 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓         ▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓
1604 //         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓
1605 //
1606 //
1607 //          ▓▓▓▓▓        ▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓▓       ▓▓▓▓▓▓  ▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1608 //          ▓▓▓▓▓▓      ▓▓▓▓▓   ▓▓▓▓▓   ▓▓▓▓▓▓     ▓▓▓▓▓▓   ▓▓▓▓▓   ▒▓        ▓▓▓▓▓▓
1609 //           ▓▓▓▓▓▓    ▓▓▓▓▓▒   ▓▓▓▓▓    ▓▓▓▓▓    ▓▓▓▓▓▓    ▓▓▓▓▓   ▒▓▓▓▓      ▓▓▓▓▓▓▓
1610 //            ▓▓▓▓▓▓   ▓▓▓▓     ▓▓▓▓▓     ▓▓▓▓▓   ▓▓▓▓▓     ▓▓▓▓▓   ▒▓▓▓▓▓▓░   ▓▓▓▓▓▓▓
1611 //             ▓▓▓▓▓▓   ▓▓▓     ▓▓▓▓▓      ▓▓▓▓▓   ▓▓▓      ▓▓▓▓▓   ▒▓▓▓▓     ▓▓▓▓▓▓
1612 //              ▓▓▓▓▓  ▓▓▓      ▓▓▓▓▓▓▒    ▓▓▓▓▓▓ ▓▓▓       ▓▓▓▓▓▓  ▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓
1613 //              
1614 //  https://vivid.limited
1615 
1616 
1617 
1618 
1619 
1620 
1621 contract Vivid is ERC721A, Ownable {
1622     using Strings for uint256;
1623 
1624     uint256 public tokenSupply = 8888;
1625 
1626     uint256 public price = 0.3 ether;
1627     uint256 public wlPrice = 0.25 ether;
1628     uint256 public maxMint = 2;
1629     uint256 public maxWlMint = 2;
1630     bool public publicSale = false;
1631     bool public whitelistSale = false;
1632 
1633     mapping(address => uint256) public _whitelistClaimed;
1634 
1635     string public baseURI = "https://vivid.limited";
1636     bytes32 public merkleRoot = 0xed60684dc9b8c04fd3cc6bb928ab4d2f714314124cd429b681bae2bbb976d07f;
1637 
1638     constructor() ERC721A("VIVID", "VIVID") {
1639     }
1640 
1641     function toggleWhitelistSale() external onlyOwner {
1642         whitelistSale = !whitelistSale;
1643     }
1644 
1645     function togglePublicSale() external onlyOwner {
1646         publicSale = !publicSale;
1647     }
1648 
1649     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1650         baseURI = _newBaseURI;
1651     }
1652 
1653     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1654         merkleRoot = _merkleRoot;
1655     }
1656 
1657     function setPrice(uint256 _price) public onlyOwner {
1658         price = _price;
1659     }
1660 
1661     function setWlPrice(uint256 _wlprice) public onlyOwner {
1662         wlPrice = _wlprice;
1663     }
1664 
1665     function _baseURI() internal view override returns (string memory) {
1666         return baseURI;
1667     }
1668 
1669     function setMaxMint(uint256 _newMaxMint) external onlyOwner {
1670         maxMint = _newMaxMint;
1671     }
1672 
1673     function setMaxWlMint(uint256 _newMaxMint) external onlyOwner {
1674         maxWlMint = _newMaxMint;
1675     }
1676 
1677     function setSupply(uint256 _newSupply) external onlyOwner {
1678         tokenSupply = _newSupply;
1679     }
1680 
1681     function whitelistMint(uint256 tokens, bytes32[] calldata merkleProof) external payable {
1682         require(whitelistSale, "Mint is innactive.");
1683         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not on Whitelist.");
1684         require(balanceOf(_msgSender()) + tokens <= maxWlMint, "This would exceed the per address whitelist mint limit.");
1685         require(totalSupply() + tokens <= tokenSupply, "This would exceed the token supply.");
1686         require(tokens > 0, "Must mint atleast 1.");
1687         require(msg.value >= wlPrice * tokens, "Not Enough Ether.");
1688 
1689         _safeMint(_msgSender(), tokens);
1690         _whitelistClaimed[_msgSender()] += tokens;
1691     }
1692 
1693     function mint(uint256 tokens) external payable {
1694         require(publicSale, "Mint is innactive.");
1695         require(balanceOf(_msgSender()) + tokens <= maxMint, "This would exceed the per address mint limit.");
1696         require(totalSupply() + tokens <= tokenSupply, "This would exceed the token supply.");
1697         require(tokens > 0, "Must mint atleast 1.");
1698         require(msg.value >= price * tokens, "Not Enough Ether.");
1699 
1700         _safeMint(_msgSender(), tokens);
1701     }
1702 
1703     function airdrop(address to, uint256 tokens) external onlyOwner {
1704         require(totalSupply() + tokens <= tokenSupply, "QTY would exceed supply.");
1705         require(tokens > 0, "Token Qty must be atleast 1.");
1706         _safeMint(to, tokens);
1707     }
1708 
1709     function withdraw() public onlyOwner {
1710         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1711         require(os);
1712   }
1713 }