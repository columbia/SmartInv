1 // SPDX-License-Identifier: MIT
2 
3 //                     _     _           _                 _          _    __ 
4 //  _______  _ __ ___ | |__ (_) ___  ___| | __ _ _ __   __| |_      _| |_ / _|
5 // |_  / _ \| '_ ` _ \| '_ \| |/ _ \/ __| |/ _` | '_ \ / _` \ \ /\ / / __| |_ 
6 //  / / (_) | | | | | | |_) | |  __/\__ \ | (_| | | | | (_| |\ V  V /| |_|  _|
7 // /___\___/|_| |_| |_|_.__/|_|\___||___/_|\__,_|_| |_|\__,_(_)_/\_/  \__|_|  
8                                                                                                                                                                                         
9 
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Contract module that helps prevent reentrant calls to a function.
18  *
19  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
20  * available, which can be applied to functions to make sure there are no nested
21  * (reentrant) calls to them.
22  *
23  * Note that because there is a single `nonReentrant` guard, functions marked as
24  * `nonReentrant` may not call one another. This can be worked around by making
25  * those functions `private`, and then adding `external` `nonReentrant` entry
26  * points to them.
27  *
28  * TIP: If you would like to learn more about reentrancy and alternative ways
29  * to protect against it, check out our blog post
30  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
31  */
32 abstract contract ReentrancyGuard {
33     // Booleans are more expensive than uint256 or any type that takes up a full
34     // word because each write operation emits an extra SLOAD to first read the
35     // slot's contents, replace the bits taken up by the boolean, and then write
36     // back. This is the compiler's defense against contract upgrades and
37     // pointer aliasing, and it cannot be disabled.
38 
39     // The values being non-zero value makes deployment a bit more expensive,
40     // but in exchange the refund on every call to nonReentrant will be lower in
41     // amount. Since refunds are capped to a percentage of the total
42     // transaction's gas, it is best to keep them low in cases like this one, to
43     // increase the likelihood of the full refund coming into effect.
44     uint256 private constant _NOT_ENTERED = 1;
45     uint256 private constant _ENTERED = 2;
46 
47     uint256 private _status;
48 
49     constructor() {
50         _status = _NOT_ENTERED;
51     }
52 
53     /**
54      * @dev Prevents a contract from calling itself, directly or indirectly.
55      * Calling a `nonReentrant` function from another `nonReentrant`
56      * function is not supported. It is possible to prevent this from happening
57      * by making the `nonReentrant` function external, and making it call a
58      * `private` function that does the actual work.
59      */
60     modifier nonReentrant() {
61         // On the first call to nonReentrant, _notEntered will be true
62         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
63 
64         // Any calls to nonReentrant after this point will fail
65         _status = _ENTERED;
66 
67         _;
68 
69         // By storing the original value once again, a refund is triggered (see
70         // https://eips.ethereum.org/EIPS/eip-2200)
71         _status = _NOT_ENTERED;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev These functions deal with verification of Merkle Trees proofs.
84  *
85  * The proofs can be generated using the JavaScript library
86  * https://github.com/miguelmota/merkletreejs[merkletreejs].
87  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
88  *
89  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
90  *
91  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
92  * hashing, or use a hash function other than keccak256 for hashing leaves.
93  * This is because the concatenation of a sorted pair of internal nodes in
94  * the merkle tree could be reinterpreted as a leaf value.
95  */
96 library MerkleProof {
97     /**
98      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
99      * defined by `root`. For this, a `proof` must be provided, containing
100      * sibling hashes on the branch from the leaf to the root of the tree. Each
101      * pair of leaves and each pair of pre-images are assumed to be sorted.
102      */
103     function verify(
104         bytes32[] memory proof,
105         bytes32 root,
106         bytes32 leaf
107     ) internal pure returns (bool) {
108         return processProof(proof, leaf) == root;
109     }
110 
111     /**
112      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
113      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
114      * hash matches the root of the tree. When processing the proof, the pairs
115      * of leafs & pre-images are assumed to be sorted.
116      *
117      * _Available since v4.4._
118      */
119     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
120         bytes32 computedHash = leaf;
121         for (uint256 i = 0; i < proof.length; i++) {
122             bytes32 proofElement = proof[i];
123             if (computedHash <= proofElement) {
124                 // Hash(current computed hash + current element of the proof)
125                 computedHash = _efficientHash(computedHash, proofElement);
126             } else {
127                 // Hash(current element of the proof + current computed hash)
128                 computedHash = _efficientHash(proofElement, computedHash);
129             }
130         }
131         return computedHash;
132     }
133 
134     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
135         assembly {
136             mstore(0x00, a)
137             mstore(0x20, b)
138             value := keccak256(0x00, 0x40)
139         }
140     }
141 }
142 
143 // File: @openzeppelin/contracts/utils/Strings.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev String operations.
152  */
153 library Strings {
154     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
158      */
159     function toString(uint256 value) internal pure returns (string memory) {
160         // Inspired by OraclizeAPI's implementation - MIT licence
161         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
162 
163         if (value == 0) {
164             return "0";
165         }
166         uint256 temp = value;
167         uint256 digits;
168         while (temp != 0) {
169             digits++;
170             temp /= 10;
171         }
172         bytes memory buffer = new bytes(digits);
173         while (value != 0) {
174             digits -= 1;
175             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
176             value /= 10;
177         }
178         return string(buffer);
179     }
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
183      */
184     function toHexString(uint256 value) internal pure returns (string memory) {
185         if (value == 0) {
186             return "0x00";
187         }
188         uint256 temp = value;
189         uint256 length = 0;
190         while (temp != 0) {
191             length++;
192             temp >>= 8;
193         }
194         return toHexString(value, length);
195     }
196 
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
199      */
200     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
201         bytes memory buffer = new bytes(2 * length + 2);
202         buffer[0] = "0";
203         buffer[1] = "x";
204         for (uint256 i = 2 * length + 1; i > 1; --i) {
205             buffer[i] = _HEX_SYMBOLS[value & 0xf];
206             value >>= 4;
207         }
208         require(value == 0, "Strings: hex length insufficient");
209         return string(buffer);
210     }
211 }
212 
213 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
214 
215 
216 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 // CAUTION
221 // This version of SafeMath should only be used with Solidity 0.8 or later,
222 // because it relies on the compiler's built in overflow checks.
223 
224 /**
225  * @dev Wrappers over Solidity's arithmetic operations.
226  *
227  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
228  * now has built in overflow checking.
229  */
230 library SafeMath {
231     /**
232      * @dev Returns the addition of two unsigned integers, with an overflow flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             uint256 c = a + b;
239             if (c < a) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
246      *
247      * _Available since v3.4._
248      */
249     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b > a) return (false, 0);
252             return (true, a - b);
253         }
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
258      *
259      * _Available since v3.4._
260      */
261     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264             // benefit is lost if 'b' is also tested.
265             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266             if (a == 0) return (true, 0);
267             uint256 c = a * b;
268             if (c / a != b) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     /**
274      * @dev Returns the division of two unsigned integers, with a division by zero flag.
275      *
276      * _Available since v3.4._
277      */
278     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a / b);
282         }
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
287      *
288      * _Available since v3.4._
289      */
290     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b == 0) return (false, 0);
293             return (true, a % b);
294         }
295     }
296 
297     /**
298      * @dev Returns the addition of two unsigned integers, reverting on
299      * overflow.
300      *
301      * Counterpart to Solidity's `+` operator.
302      *
303      * Requirements:
304      *
305      * - Addition cannot overflow.
306      */
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a + b;
309     }
310 
311     /**
312      * @dev Returns the subtraction of two unsigned integers, reverting on
313      * overflow (when the result is negative).
314      *
315      * Counterpart to Solidity's `-` operator.
316      *
317      * Requirements:
318      *
319      * - Subtraction cannot overflow.
320      */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a - b;
323     }
324 
325     /**
326      * @dev Returns the multiplication of two unsigned integers, reverting on
327      * overflow.
328      *
329      * Counterpart to Solidity's `*` operator.
330      *
331      * Requirements:
332      *
333      * - Multiplication cannot overflow.
334      */
335     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a * b;
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator.
344      *
345      * Requirements:
346      *
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a / b;
351     }
352 
353     /**
354      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
355      * reverting when dividing by zero.
356      *
357      * Counterpart to Solidity's `%` operator. This function uses a `revert`
358      * opcode (which leaves remaining gas untouched) while Solidity uses an
359      * invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      *
363      * - The divisor cannot be zero.
364      */
365     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a % b;
367     }
368 
369     /**
370      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
371      * overflow (when the result is negative).
372      *
373      * CAUTION: This function is deprecated because it requires allocating memory for the error
374      * message unnecessarily. For custom revert reasons use {trySub}.
375      *
376      * Counterpart to Solidity's `-` operator.
377      *
378      * Requirements:
379      *
380      * - Subtraction cannot overflow.
381      */
382     function sub(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b <= a, errorMessage);
389             return a - b;
390         }
391     }
392 
393     /**
394      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
395      * division by zero. The result is rounded towards zero.
396      *
397      * Counterpart to Solidity's `/` operator. Note: this function uses a
398      * `revert` opcode (which leaves remaining gas untouched) while Solidity
399      * uses an invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function div(
406         uint256 a,
407         uint256 b,
408         string memory errorMessage
409     ) internal pure returns (uint256) {
410         unchecked {
411             require(b > 0, errorMessage);
412             return a / b;
413         }
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * reverting with custom message when dividing by zero.
419      *
420      * CAUTION: This function is deprecated because it requires allocating memory for the error
421      * message unnecessarily. For custom revert reasons use {tryMod}.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function mod(
432         uint256 a,
433         uint256 b,
434         string memory errorMessage
435     ) internal pure returns (uint256) {
436         unchecked {
437             require(b > 0, errorMessage);
438             return a % b;
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/Context.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Provides information about the current execution context, including the
452  * sender of the transaction and its data. While these are generally available
453  * via msg.sender and msg.data, they should not be accessed in such a direct
454  * manner, since when dealing with meta-transactions the account sending and
455  * paying for execution may not be the actual sender (as far as an application
456  * is concerned).
457  *
458  * This contract is only required for intermediate, library-like contracts.
459  */
460 abstract contract Context {
461     function _msgSender() internal view virtual returns (address) {
462         return msg.sender;
463     }
464 
465     function _msgData() internal view virtual returns (bytes calldata) {
466         return msg.data;
467     }
468 }
469 
470 // File: @openzeppelin/contracts/access/Ownable.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 abstract contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor() {
499         _transferOwnership(_msgSender());
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view virtual returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(owner() == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         _transferOwnership(address(0));
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         _transferOwnership(newOwner);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Internal function without access restriction.
540      */
541     function _transferOwnership(address newOwner) internal virtual {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 // File: IERC721A.sol
549 
550 
551 // ERC721A Contracts v4.0.0
552 // Creator: Chiru Labs
553 
554 pragma solidity ^0.8.4;
555 
556 /**
557  * @dev Interface of an ERC721A compliant contract.
558  */
559 interface IERC721A {
560     /**
561      * The caller must own the token or be an approved operator.
562      */
563     error ApprovalCallerNotOwnerNorApproved();
564 
565     /**
566      * The token does not exist.
567      */
568     error ApprovalQueryForNonexistentToken();
569 
570     /**
571      * The caller cannot approve to their own address.
572      */
573     error ApproveToCaller();
574 
575     /**
576      * Cannot query the balance for the zero address.
577      */
578     error BalanceQueryForZeroAddress();
579 
580     /**
581      * Cannot mint to the zero address.
582      */
583     error MintToZeroAddress();
584 
585     /**
586      * The quantity of tokens minted must be more than zero.
587      */
588     error MintZeroQuantity();
589 
590     /**
591      * The token does not exist.
592      */
593     error OwnerQueryForNonexistentToken();
594 
595     /**
596      * The caller must own the token or be an approved operator.
597      */
598     error TransferCallerNotOwnerNorApproved();
599 
600     /**
601      * The token must be owned by `from`.
602      */
603     error TransferFromIncorrectOwner();
604 
605     /**
606      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
607      */
608     error TransferToNonERC721ReceiverImplementer();
609 
610     /**
611      * Cannot transfer to the zero address.
612      */
613     error TransferToZeroAddress();
614 
615     /**
616      * The token does not exist.
617      */
618     error URIQueryForNonexistentToken();
619 
620     struct TokenOwnership {
621         // The address of the owner.
622         address addr;
623         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
624         uint64 startTimestamp;
625         // Whether the token has been burned.
626         bool burned;
627     }
628 
629     /**
630      * @dev Returns the total amount of tokens stored by the contract.
631      *
632      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
633      */
634     function totalSupply() external view returns (uint256);
635 
636     // ==============================
637     //            IERC165
638     // ==============================
639 
640     /**
641      * @dev Returns true if this contract implements the interface defined by
642      * `interfaceId`. See the corresponding
643      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
644      * to learn more about how these ids are created.
645      *
646      * This function call must use less than 30 000 gas.
647      */
648     function supportsInterface(bytes4 interfaceId) external view returns (bool);
649 
650     // ==============================
651     //            IERC721
652     // ==============================
653 
654     /**
655      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
656      */
657     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
658 
659     /**
660      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
661      */
662     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
663 
664     /**
665      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
666      */
667     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
668 
669     /**
670      * @dev Returns the number of tokens in ``owner``'s account.
671      */
672     function balanceOf(address owner) external view returns (uint256 balance);
673 
674     /**
675      * @dev Returns the owner of the `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function ownerOf(uint256 tokenId) external view returns (address owner);
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes calldata data
701     ) external;
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
705      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must exist and be owned by `from`.
712      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
714      *
715      * Emits a {Transfer} event.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) external;
722 
723     /**
724      * @dev Transfers `tokenId` token from `from` to `to`.
725      *
726      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
727      *
728      * Requirements:
729      *
730      * - `from` cannot be the zero address.
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must be owned by `from`.
733      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
734      *
735      * Emits a {Transfer} event.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) external;
742 
743     /**
744      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
745      * The approval is cleared when the token is transferred.
746      *
747      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
748      *
749      * Requirements:
750      *
751      * - The caller must own the token or be an approved operator.
752      * - `tokenId` must exist.
753      *
754      * Emits an {Approval} event.
755      */
756     function approve(address to, uint256 tokenId) external;
757 
758     /**
759      * @dev Approve or remove `operator` as an operator for the caller.
760      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
761      *
762      * Requirements:
763      *
764      * - The `operator` cannot be the caller.
765      *
766      * Emits an {ApprovalForAll} event.
767      */
768     function setApprovalForAll(address operator, bool _approved) external;
769 
770     /**
771      * @dev Returns the account approved for `tokenId` token.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function getApproved(uint256 tokenId) external view returns (address operator);
778 
779     /**
780      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
781      *
782      * See {setApprovalForAll}
783      */
784     function isApprovedForAll(address owner, address operator) external view returns (bool);
785 
786     // ==============================
787     //        IERC721Metadata
788     // ==============================
789 
790     /**
791      * @dev Returns the token collection name.
792      */
793     function name() external view returns (string memory);
794 
795     /**
796      * @dev Returns the token collection symbol.
797      */
798     function symbol() external view returns (string memory);
799 
800     /**
801      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
802      */
803     function tokenURI(uint256 tokenId) external view returns (string memory);
804 }
805 // File: ERC721A.sol
806 
807 
808 // ERC721A Contracts v4.0.0
809 // Creator: Chiru Labs
810 
811 pragma solidity ^0.8.4;
812 
813 
814 /**
815  * @dev ERC721 token receiver interface.
816  */
817 interface ERC721A__IERC721Receiver {
818     function onERC721Received(
819         address operator,
820         address from,
821         uint256 tokenId,
822         bytes calldata data
823     ) external returns (bytes4);
824 }
825 
826 /**
827  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
828  * the Metadata extension. Built to optimize for lower gas during batch mints.
829  *
830  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
831  *
832  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
833  *
834  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
835  */
836 contract ERC721A is IERC721A {
837     // Mask of an entry in packed address data.
838     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
839 
840     // The bit position of `numberMinted` in packed address data.
841     uint256 private constant BITPOS_NUMBER_MINTED = 64;
842 
843     // The bit position of `numberBurned` in packed address data.
844     uint256 private constant BITPOS_NUMBER_BURNED = 128;
845 
846     // The bit position of `aux` in packed address data.
847     uint256 private constant BITPOS_AUX = 192;
848 
849     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
850     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
851 
852     // The bit position of `startTimestamp` in packed ownership.
853     uint256 private constant BITPOS_START_TIMESTAMP = 160;
854 
855     // The bit mask of the `burned` bit in packed ownership.
856     uint256 private constant BITMASK_BURNED = 1 << 224;
857 
858     // The bit position of the `nextInitialized` bit in packed ownership.
859     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
860 
861     // The bit mask of the `nextInitialized` bit in packed ownership.
862     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
863 
864     // The tokenId of the next token to be minted.
865     uint256 private _currentIndex;
866 
867     // The number of tokens burned.
868     uint256 private _burnCounter;
869 
870     // Token name
871     string private _name;
872 
873     // Token symbol
874     string private _symbol;
875 
876     // Mapping from token ID to ownership details
877     // An empty struct value does not necessarily mean the token is unowned.
878     // See `_packedOwnershipOf` implementation for details.
879     //
880     // Bits Layout:
881     // - [0..159]   `addr`
882     // - [160..223] `startTimestamp`
883     // - [224]      `burned`
884     // - [225]      `nextInitialized`
885     mapping(uint256 => uint256) private _packedOwnerships;
886 
887     // Mapping owner address to address data.
888     //
889     // Bits Layout:
890     // - [0..63]    `balance`
891     // - [64..127]  `numberMinted`
892     // - [128..191] `numberBurned`
893     // - [192..255] `aux`
894     mapping(address => uint256) private _packedAddressData;
895 
896     // Mapping from token ID to approved address.
897     mapping(uint256 => address) private _tokenApprovals;
898 
899     // Mapping from owner to operator approvals
900     mapping(address => mapping(address => bool)) private _operatorApprovals;
901 
902     constructor(string memory name_, string memory symbol_) {
903         _name = name_;
904         _symbol = symbol_;
905         _currentIndex = _startTokenId();
906     }
907 
908     /**
909      * @dev Returns the starting token ID.
910      * To change the starting token ID, please override this function.
911      */
912     function _startTokenId() internal view virtual returns (uint256) {
913         return 0;
914     }
915 
916     /**
917      * @dev Returns the next token ID to be minted.
918      */
919     function _nextTokenId() internal view returns (uint256) {
920         return _currentIndex;
921     }
922 
923     /**
924      * @dev Returns the total number of tokens in existence.
925      * Burned tokens will reduce the count.
926      * To get the total number of tokens minted, please see `_totalMinted`.
927      */
928     function totalSupply() public view override returns (uint256) {
929         // Counter underflow is impossible as _burnCounter cannot be incremented
930         // more than `_currentIndex - _startTokenId()` times.
931         unchecked {
932             return _currentIndex - _burnCounter - _startTokenId();
933         }
934     }
935 
936     /**
937      * @dev Returns the total amount of tokens minted in the contract.
938      */
939     function _totalMinted() internal view returns (uint256) {
940         // Counter underflow is impossible as _currentIndex does not decrement,
941         // and it is initialized to `_startTokenId()`
942         unchecked {
943             return _currentIndex - _startTokenId();
944         }
945     }
946 
947     /**
948      * @dev Returns the total number of tokens burned.
949      */
950     function _totalBurned() internal view returns (uint256) {
951         return _burnCounter;
952     }
953 
954     /**
955      * @dev See {IERC165-supportsInterface}.
956      */
957     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
958         // The interface IDs are constants representing the first 4 bytes of the XOR of
959         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
960         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
961         return
962             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
963             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
964             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
965     }
966 
967     /**
968      * @dev See {IERC721-balanceOf}.
969      */
970     function balanceOf(address owner) public view override returns (uint256) {
971         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
972         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
973     }
974 
975     /**
976      * Returns the number of tokens minted by `owner`.
977      */
978     function _numberMinted(address owner) internal view returns (uint256) {
979         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
980     }
981 
982     /**
983      * Returns the number of tokens burned by or on behalf of `owner`.
984      */
985     function _numberBurned(address owner) internal view returns (uint256) {
986         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
987     }
988 
989     /**
990      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
991      */
992     function _getAux(address owner) internal view returns (uint64) {
993         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
994     }
995 
996     /**
997      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
998      * If there are multiple variables, please pack them into a uint64.
999      */
1000     function _setAux(address owner, uint64 aux) internal {
1001         uint256 packed = _packedAddressData[owner];
1002         uint256 auxCasted;
1003         assembly {
1004             // Cast aux without masking.
1005             auxCasted := aux
1006         }
1007         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1008         _packedAddressData[owner] = packed;
1009     }
1010 
1011     /**
1012      * Returns the packed ownership data of `tokenId`.
1013      */
1014     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1015         uint256 curr = tokenId;
1016 
1017         unchecked {
1018             if (_startTokenId() <= curr)
1019                 if (curr < _currentIndex) {
1020                     uint256 packed = _packedOwnerships[curr];
1021                     // If not burned.
1022                     if (packed & BITMASK_BURNED == 0) {
1023                         // Invariant:
1024                         // There will always be an ownership that has an address and is not burned
1025                         // before an ownership that does not have an address and is not burned.
1026                         // Hence, curr will not underflow.
1027                         //
1028                         // We can directly compare the packed value.
1029                         // If the address is zero, packed is zero.
1030                         while (packed == 0) {
1031                             packed = _packedOwnerships[--curr];
1032                         }
1033                         return packed;
1034                     }
1035                 }
1036         }
1037         revert OwnerQueryForNonexistentToken();
1038     }
1039 
1040     /**
1041      * Returns the unpacked `TokenOwnership` struct from `packed`.
1042      */
1043     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1044         ownership.addr = address(uint160(packed));
1045         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1046         ownership.burned = packed & BITMASK_BURNED != 0;
1047     }
1048 
1049     /**
1050      * Returns the unpacked `TokenOwnership` struct at `index`.
1051      */
1052     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1053         return _unpackedOwnership(_packedOwnerships[index]);
1054     }
1055 
1056     /**
1057      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1058      */
1059     function _initializeOwnershipAt(uint256 index) internal {
1060         if (_packedOwnerships[index] == 0) {
1061             _packedOwnerships[index] = _packedOwnershipOf(index);
1062         }
1063     }
1064 
1065     /**
1066      * Gas spent here starts off proportional to the maximum mint batch size.
1067      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1068      */
1069     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1070         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-ownerOf}.
1075      */
1076     function ownerOf(uint256 tokenId) public view override returns (address) {
1077         return address(uint160(_packedOwnershipOf(tokenId)));
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-name}.
1082      */
1083     function name() public view virtual override returns (string memory) {
1084         return _name;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-symbol}.
1089      */
1090     function symbol() public view virtual override returns (string memory) {
1091         return _symbol;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Metadata-tokenURI}.
1096      */
1097     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1098         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1099 
1100         string memory baseURI = _baseURI();
1101         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1102     }
1103 
1104     /**
1105      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1106      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1107      * by default, can be overriden in child contracts.
1108      */
1109     function _baseURI() internal view virtual returns (string memory) {
1110         return '';
1111     }
1112 
1113     /**
1114      * @dev Casts the address to uint256 without masking.
1115      */
1116     function _addressToUint256(address value) private pure returns (uint256 result) {
1117         assembly {
1118             result := value
1119         }
1120     }
1121 
1122     /**
1123      * @dev Casts the boolean to uint256 without branching.
1124      */
1125     function _boolToUint256(bool value) private pure returns (uint256 result) {
1126         assembly {
1127             result := value
1128         }
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-approve}.
1133      */
1134     function approve(address to, uint256 tokenId) public override {
1135         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1136 
1137         if (_msgSenderERC721A() != owner)
1138             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1139                 revert ApprovalCallerNotOwnerNorApproved();
1140             }
1141 
1142         _tokenApprovals[tokenId] = to;
1143         emit Approval(owner, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-getApproved}.
1148      */
1149     function getApproved(uint256 tokenId) public view override returns (address) {
1150         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1151 
1152         return _tokenApprovals[tokenId];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-setApprovalForAll}.
1157      */
1158     function setApprovalForAll(address operator, bool approved) public virtual override {
1159         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1160 
1161         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1162         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-isApprovedForAll}.
1167      */
1168     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1169         return _operatorApprovals[owner][operator];
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-transferFrom}.
1174      */
1175     function transferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) public virtual override {
1180         _transfer(from, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-safeTransferFrom}.
1185      */
1186     function safeTransferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) public virtual override {
1191         safeTransferFrom(from, to, tokenId, '');
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-safeTransferFrom}.
1196      */
1197     function safeTransferFrom(
1198         address from,
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) public virtual override {
1203         _transfer(from, to, tokenId);
1204         if (to.code.length != 0)
1205             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1206                 revert TransferToNonERC721ReceiverImplementer();
1207             }
1208     }
1209 
1210     /**
1211      * @dev Returns whether `tokenId` exists.
1212      *
1213      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1214      *
1215      * Tokens start existing when they are minted (`_mint`),
1216      */
1217     function _exists(uint256 tokenId) internal view returns (bool) {
1218         return
1219             _startTokenId() <= tokenId &&
1220             tokenId < _currentIndex && // If within bounds,
1221             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1222     }
1223 
1224     /**
1225      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1226      */
1227     function _safeMint(address to, uint256 quantity) internal {
1228         _safeMint(to, quantity, '');
1229     }
1230 
1231     /**
1232      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1233      *
1234      * Requirements:
1235      *
1236      * - If `to` refers to a smart contract, it must implement
1237      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1238      * - `quantity` must be greater than 0.
1239      *
1240      * Emits a {Transfer} event for each mint.
1241      */
1242     function _safeMint(
1243         address to,
1244         uint256 quantity,
1245         bytes memory _data
1246     ) internal {
1247         _mint(to, quantity);
1248 
1249         unchecked {
1250             if (to.code.length != 0) {
1251                 uint256 end = _currentIndex;
1252                 uint256 index = end - quantity;
1253                 do {
1254                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1255                         revert TransferToNonERC721ReceiverImplementer();
1256                     }
1257                 } while (index < end);
1258                 // Reentrancy protection.
1259                 if (_currentIndex != end) revert();
1260             }
1261         }
1262     }
1263 
1264     /**
1265      * @dev Mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - `to` cannot be the zero address.
1270      * - `quantity` must be greater than 0.
1271      *
1272      * Emits a {Transfer} event for each mint.
1273      */
1274     function _mint(address to, uint256 quantity) internal {
1275         uint256 startTokenId = _currentIndex;
1276         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1277         if (quantity == 0) revert MintZeroQuantity();
1278 
1279         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1280 
1281         // Overflows are incredibly unrealistic.
1282         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1283         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1284         unchecked {
1285             // Updates:
1286             // - `balance += quantity`.
1287             // - `numberMinted += quantity`.
1288             //
1289             // We can directly add to the balance and number minted.
1290             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1291 
1292             // Updates:
1293             // - `address` to the owner.
1294             // - `startTimestamp` to the timestamp of minting.
1295             // - `burned` to `false`.
1296             // - `nextInitialized` to `quantity == 1`.
1297             _packedOwnerships[startTokenId] =
1298                 _addressToUint256(to) |
1299                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1300                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1301 
1302             uint256 offset;
1303             do {
1304                 emit Transfer(address(0), to, startTokenId + offset++);
1305             } while (offset < quantity);
1306 
1307             _currentIndex = startTokenId + quantity;
1308         }
1309         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1310     }
1311 
1312     /**
1313      * @dev Transfers `tokenId` from `from` to `to`.
1314      *
1315      * Requirements:
1316      *
1317      * - `to` cannot be the zero address.
1318      * - `tokenId` token must be owned by `from`.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function _transfer(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) private {
1327         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1328 
1329         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1330 
1331         address approvedAddress = _tokenApprovals[tokenId];
1332 
1333         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1334             isApprovedForAll(from, _msgSenderERC721A()) ||
1335             approvedAddress == _msgSenderERC721A());
1336 
1337         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1338         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1339 
1340         _beforeTokenTransfers(from, to, tokenId, 1);
1341 
1342         // Clear approvals from the previous owner.
1343         if (_addressToUint256(approvedAddress) != 0) {
1344             delete _tokenApprovals[tokenId];
1345         }
1346 
1347         // Underflow of the sender's balance is impossible because we check for
1348         // ownership above and the recipient's balance can't realistically overflow.
1349         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1350         unchecked {
1351             // We can directly increment and decrement the balances.
1352             --_packedAddressData[from]; // Updates: `balance -= 1`.
1353             ++_packedAddressData[to]; // Updates: `balance += 1`.
1354 
1355             // Updates:
1356             // - `address` to the next owner.
1357             // - `startTimestamp` to the timestamp of transfering.
1358             // - `burned` to `false`.
1359             // - `nextInitialized` to `true`.
1360             _packedOwnerships[tokenId] =
1361                 _addressToUint256(to) |
1362                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1363                 BITMASK_NEXT_INITIALIZED;
1364 
1365             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1366             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1367                 uint256 nextTokenId = tokenId + 1;
1368                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1369                 if (_packedOwnerships[nextTokenId] == 0) {
1370                     // If the next slot is within bounds.
1371                     if (nextTokenId != _currentIndex) {
1372                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1373                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1374                     }
1375                 }
1376             }
1377         }
1378 
1379         emit Transfer(from, to, tokenId);
1380         _afterTokenTransfers(from, to, tokenId, 1);
1381     }
1382 
1383     /**
1384      * @dev Equivalent to `_burn(tokenId, false)`.
1385      */
1386     function _burn(uint256 tokenId) internal virtual {
1387         _burn(tokenId, false);
1388     }
1389 
1390     /**
1391      * @dev Destroys `tokenId`.
1392      * The approval is cleared when the token is burned.
1393      *
1394      * Requirements:
1395      *
1396      * - `tokenId` must exist.
1397      *
1398      * Emits a {Transfer} event.
1399      */
1400     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1401         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1402 
1403         address from = address(uint160(prevOwnershipPacked));
1404         address approvedAddress = _tokenApprovals[tokenId];
1405 
1406         if (approvalCheck) {
1407             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1408                 isApprovedForAll(from, _msgSenderERC721A()) ||
1409                 approvedAddress == _msgSenderERC721A());
1410 
1411             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1412         }
1413 
1414         _beforeTokenTransfers(from, address(0), tokenId, 1);
1415 
1416         // Clear approvals from the previous owner.
1417         if (_addressToUint256(approvedAddress) != 0) {
1418             delete _tokenApprovals[tokenId];
1419         }
1420 
1421         // Underflow of the sender's balance is impossible because we check for
1422         // ownership above and the recipient's balance can't realistically overflow.
1423         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1424         unchecked {
1425             // Updates:
1426             // - `balance -= 1`.
1427             // - `numberBurned += 1`.
1428             //
1429             // We can directly decrement the balance, and increment the number burned.
1430             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1431             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1432 
1433             // Updates:
1434             // - `address` to the last owner.
1435             // - `startTimestamp` to the timestamp of burning.
1436             // - `burned` to `true`.
1437             // - `nextInitialized` to `true`.
1438             _packedOwnerships[tokenId] =
1439                 _addressToUint256(from) |
1440                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1441                 BITMASK_BURNED |
1442                 BITMASK_NEXT_INITIALIZED;
1443 
1444             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1445             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1446                 uint256 nextTokenId = tokenId + 1;
1447                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1448                 if (_packedOwnerships[nextTokenId] == 0) {
1449                     // If the next slot is within bounds.
1450                     if (nextTokenId != _currentIndex) {
1451                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1452                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1453                     }
1454                 }
1455             }
1456         }
1457 
1458         emit Transfer(from, address(0), tokenId);
1459         _afterTokenTransfers(from, address(0), tokenId, 1);
1460 
1461         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1462         unchecked {
1463             _burnCounter++;
1464         }
1465     }
1466 
1467     /**
1468      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1469      *
1470      * @param from address representing the previous owner of the given token ID
1471      * @param to target address that will receive the tokens
1472      * @param tokenId uint256 ID of the token to be transferred
1473      * @param _data bytes optional data to send along with the call
1474      * @return bool whether the call correctly returned the expected magic value
1475      */
1476     function _checkContractOnERC721Received(
1477         address from,
1478         address to,
1479         uint256 tokenId,
1480         bytes memory _data
1481     ) private returns (bool) {
1482         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1483             bytes4 retval
1484         ) {
1485             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1486         } catch (bytes memory reason) {
1487             if (reason.length == 0) {
1488                 revert TransferToNonERC721ReceiverImplementer();
1489             } else {
1490                 assembly {
1491                     revert(add(32, reason), mload(reason))
1492                 }
1493             }
1494         }
1495     }
1496 
1497     /**
1498      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1499      * And also called before burning one token.
1500      *
1501      * startTokenId - the first token id to be transferred
1502      * quantity - the amount to be transferred
1503      *
1504      * Calling conditions:
1505      *
1506      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1507      * transferred to `to`.
1508      * - When `from` is zero, `tokenId` will be minted for `to`.
1509      * - When `to` is zero, `tokenId` will be burned by `from`.
1510      * - `from` and `to` are never both zero.
1511      */
1512     function _beforeTokenTransfers(
1513         address from,
1514         address to,
1515         uint256 startTokenId,
1516         uint256 quantity
1517     ) internal virtual {}
1518 
1519     /**
1520      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1521      * minting.
1522      * And also called after one token has been burned.
1523      *
1524      * startTokenId - the first token id to be transferred
1525      * quantity - the amount to be transferred
1526      *
1527      * Calling conditions:
1528      *
1529      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1530      * transferred to `to`.
1531      * - When `from` is zero, `tokenId` has been minted for `to`.
1532      * - When `to` is zero, `tokenId` has been burned by `from`.
1533      * - `from` and `to` are never both zero.
1534      */
1535     function _afterTokenTransfers(
1536         address from,
1537         address to,
1538         uint256 startTokenId,
1539         uint256 quantity
1540     ) internal virtual {}
1541 
1542     /**
1543      * @dev Returns the message sender (defaults to `msg.sender`).
1544      *
1545      * If you are writing GSN compatible contracts, you need to override this function.
1546      */
1547     function _msgSenderERC721A() internal view virtual returns (address) {
1548         return msg.sender;
1549     }
1550 
1551     /**
1552      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1553      */
1554     function _toString(uint256 value) internal pure returns (string memory ptr) {
1555         assembly {
1556             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1557             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1558             // We will need 1 32-byte word to store the length,
1559             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1560             ptr := add(mload(0x40), 128)
1561             // Update the free memory pointer to allocate.
1562             mstore(0x40, ptr)
1563 
1564             // Cache the end of the memory to calculate the length later.
1565             let end := ptr
1566 
1567             // We write the string from the rightmost digit to the leftmost digit.
1568             // The following is essentially a do-while loop that also handles the zero case.
1569             // Costs a bit more than early returning for the zero case,
1570             // but cheaper in terms of deployment and overall runtime costs.
1571             for {
1572                 // Initialize and perform the first pass without check.
1573                 let temp := value
1574                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1575                 ptr := sub(ptr, 1)
1576                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1577                 mstore8(ptr, add(48, mod(temp, 10)))
1578                 temp := div(temp, 10)
1579             } temp {
1580                 // Keep dividing `temp` until zero.
1581                 temp := div(temp, 10)
1582             } {
1583                 // Body of the for loop.
1584                 ptr := sub(ptr, 1)
1585                 mstore8(ptr, add(48, mod(temp, 10)))
1586             }
1587 
1588             let length := sub(end, ptr)
1589             // Move the pointer 32 bytes leftwards to make room for the length.
1590             ptr := sub(ptr, 32)
1591             // Store the length.
1592             mstore(ptr, length)
1593         }
1594     }
1595 }
1596 // File: nft.sol
1597 
1598 pragma solidity 0.8.9;
1599 
1600 contract zombieslandwtf is ERC721A, Ownable, ReentrancyGuard{
1601 
1602     using SafeMath for uint256;
1603     
1604     uint256 public      constant MAX_TOKENS = 7777;
1605     uint256 public      price = 0.02 ether;
1606     uint public         maxPerWallet = 2;
1607     bool public         holderMintEnabled;
1608     bool public         publicMintEnabled;
1609 
1610     string public baseURI;
1611 
1612     bytes32 private     merkleRootOne = 0x9d5fc6b3e379b816cf02ba3739df4839a15166ef3f49eb51426ecdd6eae05720;
1613     bytes32 private     merkleRootTwo = 0x590858ca57a9d69978cd281b9c08429755e9f1b739a30d7f2cccfea963beb119;
1614     bytes32 private     merkleRootThree = 0x73198db5a6bdc6526ccd4dc903acc9df7d56f444a00d5e09a631c57d2dba3007;
1615 
1616 
1617     mapping(address => uint256) public validNumberOfTokensPerBuyerMap;
1618     
1619     constructor() ERC721A("zombiesland.wtf", "ZL") ReentrancyGuard(){
1620     }
1621 
1622     function getMerkleeTreeOne() public view returns (bytes32) {
1623         return merkleRootOne;
1624     }
1625 
1626     function getMerkleeTreeTwo() public view returns (bytes32) {
1627         return merkleRootTwo;
1628     }
1629 
1630     function getMerkleeTreeThree() public view returns (bytes32) {
1631         return merkleRootThree;
1632     }
1633 
1634     function getMerkleOne(address sampleAddress, bytes32[] calldata _merkleProof) public view returns (bool){
1635         bytes32 leaf = keccak256(abi.encodePacked(sampleAddress));
1636         return MerkleProof.verify(_merkleProof, merkleRootOne, leaf);
1637     }
1638 
1639     function getMerkleTwo(address sampleAddress, bytes32[] calldata _merkleProof) public view returns (bool){
1640         bytes32 leaf = keccak256(abi.encodePacked(sampleAddress));
1641         return MerkleProof.verify(_merkleProof, merkleRootTwo, leaf);
1642     }
1643 
1644     function getMerkleThree(address sampleAddress, bytes32[] calldata _merkleProof) public view returns (bool){
1645         bytes32 leaf = keccak256(abi.encodePacked(sampleAddress));
1646         return MerkleProof.verify(_merkleProof, merkleRootThree, leaf);
1647     }
1648 
1649     function setMerkleRootOne(bytes32 _merkleRoot) public onlyOwner {
1650         merkleRootOne = _merkleRoot;
1651     }
1652 
1653     function setMerkleRootTwo(bytes32 _merkleRoot) public onlyOwner {
1654         merkleRootTwo = _merkleRoot;
1655     }
1656 
1657     function setMerkleRootThree(bytes32 _merkleRoot) public onlyOwner {
1658         merkleRootThree = _merkleRoot;
1659     }
1660 
1661     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1662         maxPerWallet = maxPerWallet_;
1663     }
1664 
1665     function setPrice(uint256 price_) external onlyOwner {
1666         price = price_;
1667     }
1668 
1669     function togglePublicMinting() external onlyOwner {
1670         publicMintEnabled = !publicMintEnabled;
1671     }
1672 
1673     function toggleHolderMinting() external onlyOwner {
1674         holderMintEnabled = !holderMintEnabled;
1675     }
1676 
1677     function setBaseURI(string calldata baseURI_) external onlyOwner {
1678         baseURI = baseURI_;
1679     }
1680 
1681     /*
1682     * holder addresses with more than three valid number of nfts
1683     */
1684     function holderAddresses(address[] calldata wallets, uint256[] calldata validTokens) public onlyOwner {
1685         for(uint256 i=0; i<wallets.length;i++) {
1686             validNumberOfTokensPerBuyerMap[wallets[i]] = validTokens[i];
1687         }
1688     }
1689 
1690     function holderMint(uint256 numberOfTokens, bytes32[] calldata _merkleProof) public nonReentrant() {
1691         require(holderMintEnabled, "holder minting is not open yet");
1692         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "no more zombielands");
1693 
1694         if (validNumberOfTokensPerBuyerMap[msg.sender] == 0){
1695             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1696             if(MerkleProof.verify(_merkleProof, merkleRootOne, leaf)){
1697                 validNumberOfTokensPerBuyerMap[msg.sender]= 1;
1698             } else if (MerkleProof.verify(_merkleProof, merkleRootTwo, leaf)){
1699                 validNumberOfTokensPerBuyerMap[msg.sender] = 2;
1700             } else if (MerkleProof.verify(_merkleProof, merkleRootThree, leaf)){
1701                 validNumberOfTokensPerBuyerMap[msg.sender] = 3;
1702             }else{
1703                 require(false, "your address is not allowlisted");
1704             }
1705         }
1706 
1707         require(numberMinted(msg.sender) + numberOfTokens <= validNumberOfTokensPerBuyerMap[msg.sender], "you have reached your maximum number of mints");
1708     
1709         _safeMint(msg.sender, numberOfTokens);
1710     }
1711 
1712     function ownerBatchMint(uint256 amount) external onlyOwner
1713     {
1714         require(totalSupply() + amount < MAX_TOKENS + 1,"too many!");
1715 
1716         _safeMint(msg.sender, amount);
1717     }
1718 
1719     function publicMint(uint256 numberOfTokens) external payable {
1720         require(publicMintEnabled, "public minting is not open yet");
1721         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "no more zombielands");
1722         require(msg.sender == tx.origin, "be yourself, honey.");
1723         require(msg.value >= numberOfTokens * price, "please send the exact amount");
1724         require(numberMinted(msg.sender) + numberOfTokens <= maxPerWallet, "max per Wallet reached");
1725 
1726         _safeMint(msg.sender, numberOfTokens);
1727     }
1728 
1729 
1730     function numberMinted(address owner) public view returns (uint256) {
1731         return _numberMinted(owner);
1732     }
1733 
1734     function getValidNumberOfTokens(address checkAddress) public view returns (uint256){
1735         return validNumberOfTokensPerBuyerMap[checkAddress];
1736     }
1737 
1738     function _baseURI() internal view virtual override returns (string memory) {
1739         return baseURI;
1740     }
1741 
1742     function withdraw() external onlyOwner nonReentrant {
1743         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1744         require(success, "Transfer failed.");
1745     }
1746 
1747 }