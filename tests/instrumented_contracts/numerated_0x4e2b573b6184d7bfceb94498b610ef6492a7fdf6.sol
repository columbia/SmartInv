1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 // CAUTION
113 // This version of SafeMath should only be used with Solidity 0.8 or later,
114 // because it relies on the compiler's built in overflow checks.
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations.
118  *
119  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
120  * now has built in overflow checking.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         unchecked {
130             uint256 c = a + b;
131             if (c < a) return (false, 0);
132             return (true, c);
133         }
134     }
135 
136     /**
137      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
138      *
139      * _Available since v3.4._
140      */
141     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             if (b > a) return (false, 0);
144             return (true, a - b);
145         }
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156             // benefit is lost if 'b' is also tested.
157             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158             if (a == 0) return (true, 0);
159             uint256 c = a * b;
160             if (c / a != b) return (false, 0);
161             return (true, c);
162         }
163     }
164 
165     /**
166      * @dev Returns the division of two unsigned integers, with a division by zero flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         unchecked {
172             if (b == 0) return (false, 0);
173             return (true, a / b);
174         }
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             if (b == 0) return (false, 0);
185             return (true, a % b);
186         }
187     }
188 
189     /**
190      * @dev Returns the addition of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `+` operator.
194      *
195      * Requirements:
196      *
197      * - Addition cannot overflow.
198      */
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a + b;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a - b;
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `*` operator.
222      *
223      * Requirements:
224      *
225      * - Multiplication cannot overflow.
226      */
227     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a * b;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers, reverting on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator.
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         return a / b;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * reverting when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a % b;
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * CAUTION: This function is deprecated because it requires allocating memory for the error
266      * message unnecessarily. For custom revert reasons use {trySub}.
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      *
272      * - Subtraction cannot overflow.
273      */
274     function sub(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b <= a, errorMessage);
281             return a - b;
282         }
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a / b;
305         }
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting with custom message when dividing by zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryMod}.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a % b;
331         }
332     }
333 }
334 
335 
336 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Interface of the ERC165 standard, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-165[EIP].
346  *
347  * Implementers can declare support of contract interfaces, which can then be
348  * queried by others ({ERC165Checker}).
349  *
350  * For an implementation, see {ERC165}.
351  */
352 interface IERC165 {
353     /**
354      * @dev Returns true if this contract implements the interface defined by
355      * `interfaceId`. See the corresponding
356      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
357      * to learn more about how these ids are created.
358      *
359      * This function call must use less than 30 000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool);
362 }
363 
364 
365 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @dev Required interface of an ERC721 compliant contract.
374  */
375 interface IERC721 is IERC165 {
376     /**
377      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
383      */
384     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
388      */
389     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
390 
391     /**
392      * @dev Returns the number of tokens in ``owner``'s account.
393      */
394     function balanceOf(address owner) external view returns (uint256 balance);
395 
396     /**
397      * @dev Returns the owner of the `tokenId` token.
398      *
399      * Requirements:
400      *
401      * - `tokenId` must exist.
402      */
403     function ownerOf(uint256 tokenId) external view returns (address owner);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` token from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
447      * The approval is cleared when the token is transferred.
448      *
449      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
450      *
451      * Requirements:
452      *
453      * - The caller must own the token or be an approved operator.
454      * - `tokenId` must exist.
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address to, uint256 tokenId) external;
459 
460     /**
461      * @dev Returns the account approved for `tokenId` token.
462      *
463      * Requirements:
464      *
465      * - `tokenId` must exist.
466      */
467     function getApproved(uint256 tokenId) external view returns (address operator);
468 
469     /**
470      * @dev Approve or remove `operator` as an operator for the caller.
471      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
472      *
473      * Requirements:
474      *
475      * - The `operator` cannot be the caller.
476      *
477      * Emits an {ApprovalForAll} event.
478      */
479     function setApprovalForAll(address operator, bool _approved) external;
480 
481     /**
482      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
483      *
484      * See {setApprovalForAll}
485      */
486     function isApprovedForAll(address owner, address operator) external view returns (bool);
487 
488     /**
489      * @dev Safely transfers `tokenId` token from `from` to `to`.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId,
505         bytes calldata data
506     ) external;
507 }
508 
509 
510 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Contract module that helps prevent reentrant calls to a function.
519  *
520  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
521  * available, which can be applied to functions to make sure there are no nested
522  * (reentrant) calls to them.
523  *
524  * Note that because there is a single `nonReentrant` guard, functions marked as
525  * `nonReentrant` may not call one another. This can be worked around by making
526  * those functions `private`, and then adding `external` `nonReentrant` entry
527  * points to them.
528  *
529  * TIP: If you would like to learn more about reentrancy and alternative ways
530  * to protect against it, check out our blog post
531  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
532  */
533 abstract contract ReentrancyGuard {
534     // Booleans are more expensive than uint256 or any type that takes up a full
535     // word because each write operation emits an extra SLOAD to first read the
536     // slot's contents, replace the bits taken up by the boolean, and then write
537     // back. This is the compiler's defense against contract upgrades and
538     // pointer aliasing, and it cannot be disabled.
539 
540     // The values being non-zero value makes deployment a bit more expensive,
541     // but in exchange the refund on every call to nonReentrant will be lower in
542     // amount. Since refunds are capped to a percentage of the total
543     // transaction's gas, it is best to keep them low in cases like this one, to
544     // increase the likelihood of the full refund coming into effect.
545     uint256 private constant _NOT_ENTERED = 1;
546     uint256 private constant _ENTERED = 2;
547 
548     uint256 private _status;
549 
550     constructor() {
551         _status = _NOT_ENTERED;
552     }
553 
554     /**
555      * @dev Prevents a contract from calling itself, directly or indirectly.
556      * Calling a `nonReentrant` function from another `nonReentrant`
557      * function is not supported. It is possible to prevent this from happening
558      * by making the `nonReentrant` function external, and making it call a
559      * `private` function that does the actual work.
560      */
561     modifier nonReentrant() {
562         // On the first call to nonReentrant, _notEntered will be true
563         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
564 
565         // Any calls to nonReentrant after this point will fail
566         _status = _ENTERED;
567 
568         _;
569 
570         // By storing the original value once again, a refund is triggered (see
571         // https://eips.ethereum.org/EIPS/eip-2200)
572         _status = _NOT_ENTERED;
573     }
574 }
575 
576 
577 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
578 
579 
580 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 /**
585  * @dev These functions deal with verification of Merkle Trees proofs.
586  *
587  * The proofs can be generated using the JavaScript library
588  * https://github.com/miguelmota/merkletreejs[merkletreejs].
589  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
590  *
591  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
592  */
593 library MerkleProof {
594     /**
595      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
596      * defined by `root`. For this, a `proof` must be provided, containing
597      * sibling hashes on the branch from the leaf to the root of the tree. Each
598      * pair of leaves and each pair of pre-images are assumed to be sorted.
599      */
600     function verify(
601         bytes32[] memory proof,
602         bytes32 root,
603         bytes32 leaf
604     ) internal pure returns (bool) {
605         return processProof(proof, leaf) == root;
606     }
607 
608     /**
609      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
610      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
611      * hash matches the root of the tree. When processing the proof, the pairs
612      * of leafs & pre-images are assumed to be sorted.
613      *
614      * _Available since v4.4._
615      */
616     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
617         bytes32 computedHash = leaf;
618         for (uint256 i = 0; i < proof.length; i++) {
619             bytes32 proofElement = proof[i];
620             if (computedHash <= proofElement) {
621                 // Hash(current computed hash + current element of the proof)
622                 computedHash = _efficientHash(computedHash, proofElement);
623             } else {
624                 // Hash(current element of the proof + current computed hash)
625                 computedHash = _efficientHash(proofElement, computedHash);
626             }
627         }
628         return computedHash;
629     }
630 
631     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
632         assembly {
633             mstore(0x00, a)
634             mstore(0x20, b)
635             value := keccak256(0x00, 0x40)
636         }
637     }
638 }
639 
640 
641 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 /**
649  * @title ERC721 token receiver interface
650  * @dev Interface for any contract that wants to support safeTransfers
651  * from ERC721 asset contracts.
652  */
653 interface IERC721Receiver {
654     /**
655      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
656      * by `operator` from `from`, this function is called.
657      *
658      * It must return its Solidity selector to confirm the token transfer.
659      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
660      *
661      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
662      */
663     function onERC721Received(
664         address operator,
665         address from,
666         uint256 tokenId,
667         bytes calldata data
668     ) external returns (bytes4);
669 }
670 
671 
672 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Metadata is IERC721 {
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 }
699 
700 
701 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
702 
703 
704 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
705 
706 pragma solidity ^0.8.1;
707 
708 /**
709  * @dev Collection of functions related to the address type
710  */
711 library Address {
712     /**
713      * @dev Returns true if `account` is a contract.
714      *
715      * [IMPORTANT]
716      * ====
717      * It is unsafe to assume that an address for which this function returns
718      * false is an externally-owned account (EOA) and not a contract.
719      *
720      * Among others, `isContract` will return false for the following
721      * types of addresses:
722      *
723      *  - an externally-owned account
724      *  - a contract in construction
725      *  - an address where a contract will be created
726      *  - an address where a contract lived, but was destroyed
727      * ====
728      *
729      * [IMPORTANT]
730      * ====
731      * You shouldn't rely on `isContract` to protect against flash loan attacks!
732      *
733      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
734      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
735      * constructor.
736      * ====
737      */
738     function isContract(address account) internal view returns (bool) {
739         // This method relies on extcodesize/address.code.length, which returns 0
740         // for contracts in construction, since the code is only stored at the end
741         // of the constructor execution.
742 
743         return account.code.length > 0;
744     }
745 
746     /**
747      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
748      * `recipient`, forwarding all available gas and reverting on errors.
749      *
750      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
751      * of certain opcodes, possibly making contracts go over the 2300 gas limit
752      * imposed by `transfer`, making them unable to receive funds via
753      * `transfer`. {sendValue} removes this limitation.
754      *
755      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
756      *
757      * IMPORTANT: because control is transferred to `recipient`, care must be
758      * taken to not create reentrancy vulnerabilities. Consider using
759      * {ReentrancyGuard} or the
760      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
761      */
762     function sendValue(address payable recipient, uint256 amount) internal {
763         require(address(this).balance >= amount, "Address: insufficient balance");
764 
765         (bool success, ) = recipient.call{value: amount}("");
766         require(success, "Address: unable to send value, recipient may have reverted");
767     }
768 
769     /**
770      * @dev Performs a Solidity function call using a low level `call`. A
771      * plain `call` is an unsafe replacement for a function call: use this
772      * function instead.
773      *
774      * If `target` reverts with a revert reason, it is bubbled up by this
775      * function (like regular Solidity function calls).
776      *
777      * Returns the raw returned data. To convert to the expected return value,
778      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
779      *
780      * Requirements:
781      *
782      * - `target` must be a contract.
783      * - calling `target` with `data` must not revert.
784      *
785      * _Available since v3.1._
786      */
787     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
788         return functionCall(target, data, "Address: low-level call failed");
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
793      * `errorMessage` as a fallback revert reason when `target` reverts.
794      *
795      * _Available since v3.1._
796      */
797     function functionCall(
798         address target,
799         bytes memory data,
800         string memory errorMessage
801     ) internal returns (bytes memory) {
802         return functionCallWithValue(target, data, 0, errorMessage);
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
807      * but also transferring `value` wei to `target`.
808      *
809      * Requirements:
810      *
811      * - the calling contract must have an ETH balance of at least `value`.
812      * - the called Solidity function must be `payable`.
813      *
814      * _Available since v3.1._
815      */
816     function functionCallWithValue(
817         address target,
818         bytes memory data,
819         uint256 value
820     ) internal returns (bytes memory) {
821         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
822     }
823 
824     /**
825      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
826      * with `errorMessage` as a fallback revert reason when `target` reverts.
827      *
828      * _Available since v3.1._
829      */
830     function functionCallWithValue(
831         address target,
832         bytes memory data,
833         uint256 value,
834         string memory errorMessage
835     ) internal returns (bytes memory) {
836         require(address(this).balance >= value, "Address: insufficient balance for call");
837         require(isContract(target), "Address: call to non-contract");
838 
839         (bool success, bytes memory returndata) = target.call{value: value}(data);
840         return verifyCallResult(success, returndata, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but performing a static call.
846      *
847      * _Available since v3.3._
848      */
849     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
850         return functionStaticCall(target, data, "Address: low-level static call failed");
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
855      * but performing a static call.
856      *
857      * _Available since v3.3._
858      */
859     function functionStaticCall(
860         address target,
861         bytes memory data,
862         string memory errorMessage
863     ) internal view returns (bytes memory) {
864         require(isContract(target), "Address: static call to non-contract");
865 
866         (bool success, bytes memory returndata) = target.staticcall(data);
867         return verifyCallResult(success, returndata, errorMessage);
868     }
869 
870     /**
871      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
872      * but performing a delegate call.
873      *
874      * _Available since v3.4._
875      */
876     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
877         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
878     }
879 
880     /**
881      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
882      * but performing a delegate call.
883      *
884      * _Available since v3.4._
885      */
886     function functionDelegateCall(
887         address target,
888         bytes memory data,
889         string memory errorMessage
890     ) internal returns (bytes memory) {
891         require(isContract(target), "Address: delegate call to non-contract");
892 
893         (bool success, bytes memory returndata) = target.delegatecall(data);
894         return verifyCallResult(success, returndata, errorMessage);
895     }
896 
897     /**
898      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
899      * revert reason using the provided one.
900      *
901      * _Available since v4.3._
902      */
903     function verifyCallResult(
904         bool success,
905         bytes memory returndata,
906         string memory errorMessage
907     ) internal pure returns (bytes memory) {
908         if (success) {
909             return returndata;
910         } else {
911             // Look for revert reason and bubble it up if present
912             if (returndata.length > 0) {
913                 // The easiest way to bubble the revert reason is using memory via assembly
914 
915                 assembly {
916                     let returndata_size := mload(returndata)
917                     revert(add(32, returndata), returndata_size)
918                 }
919             } else {
920                 revert(errorMessage);
921             }
922         }
923     }
924 }
925 
926 
927 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
928 
929 
930 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 /**
935  * @dev String operations.
936  */
937 library Strings {
938     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
939 
940     /**
941      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
942      */
943     function toString(uint256 value) internal pure returns (string memory) {
944         // Inspired by OraclizeAPI's implementation - MIT licence
945         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
946 
947         if (value == 0) {
948             return "0";
949         }
950         uint256 temp = value;
951         uint256 digits;
952         while (temp != 0) {
953             digits++;
954             temp /= 10;
955         }
956         bytes memory buffer = new bytes(digits);
957         while (value != 0) {
958             digits -= 1;
959             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
960             value /= 10;
961         }
962         return string(buffer);
963     }
964 
965     /**
966      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
967      */
968     function toHexString(uint256 value) internal pure returns (string memory) {
969         if (value == 0) {
970             return "0x00";
971         }
972         uint256 temp = value;
973         uint256 length = 0;
974         while (temp != 0) {
975             length++;
976             temp >>= 8;
977         }
978         return toHexString(value, length);
979     }
980 
981     /**
982      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
983      */
984     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
985         bytes memory buffer = new bytes(2 * length + 2);
986         buffer[0] = "0";
987         buffer[1] = "x";
988         for (uint256 i = 2 * length + 1; i > 1; --i) {
989             buffer[i] = _HEX_SYMBOLS[value & 0xf];
990             value >>= 4;
991         }
992         require(value == 0, "Strings: hex length insufficient");
993         return string(buffer);
994     }
995 }
996 
997 
998 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
999 
1000 
1001 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 /**
1006  * @dev Implementation of the {IERC165} interface.
1007  *
1008  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1009  * for the additional interface id that will be supported. For example:
1010  *
1011  * ```solidity
1012  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1013  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1014  * }
1015  * ```
1016  *
1017  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1018  */
1019 abstract contract ERC165 is IERC165 {
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      */
1023     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1024         return interfaceId == type(IERC165).interfaceId;
1025     }
1026 }
1027 
1028 
1029 // File contracts/ERC721A.sol
1030 
1031 
1032 // Creator: Chiru Labs
1033 
1034 pragma solidity ^0.8.0;
1035 /**
1036  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1037  * the Metadata extension. Built to optimize for lower gas during batch mints.
1038  *
1039  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1040  *
1041  * Does not support burning tokens to address(0).
1042  *
1043  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1044  */
1045 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1046     using Address for address;
1047     using Strings for uint256;
1048 
1049     struct TokenOwnership {
1050         address addr;
1051         uint64 startTimestamp;
1052     }
1053 
1054     struct AddressData {
1055         uint128 balance;
1056         uint128 numberMinted;
1057     }
1058     uint256 private constant START_TOKEN_ID = 10000;
1059 
1060     uint256 internal currentIndex;
1061 
1062     // Token name
1063     string private _name;
1064 
1065     // Token symbol
1066     string private _symbol;
1067 
1068     // Mapping from token ID to ownership details
1069     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1070     mapping(uint256 => TokenOwnership) internal _ownerships;
1071 
1072     // Mapping owner address to address data
1073     mapping(address => AddressData) private _addressData;
1074 
1075     // Mapping from token ID to approved address
1076     mapping(uint256 => address) private _tokenApprovals;
1077 
1078     // Mapping from owner to operator approvals
1079     mapping(address => mapping(address => bool)) private _operatorApprovals;
1080 
1081     constructor(string memory name_, string memory symbol_) {
1082         _name = name_;
1083         _symbol = symbol_;
1084     }
1085 
1086     function totalSupply() public view returns (uint256) {
1087         return currentIndex;
1088     }
1089 
1090     /**
1091      * @dev See {IERC165-supportsInterface}.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1094         return
1095         interfaceId == type(IERC721).interfaceId ||
1096         interfaceId == type(IERC721Metadata).interfaceId ||
1097         super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-balanceOf}.
1102      */
1103     function balanceOf(address owner) public view override returns (uint256) {
1104         require(owner != address(0), 'ERC721A: balance query for the zero address');
1105         return uint256(_addressData[owner].balance);
1106     }
1107 
1108     function _numberMinted(address owner) internal view returns (uint256) {
1109         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1110         return uint256(_addressData[owner].numberMinted);
1111     }
1112 
1113     /**
1114      * Gas spent here starts off proportional to the maximum mint batch size.
1115      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1116      */
1117     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1118         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1119 
1120         unchecked {
1121             for (uint256 curr = tokenId; curr >= START_TOKEN_ID; curr--) {
1122                 TokenOwnership memory ownership = _ownerships[curr];
1123                 if (ownership.addr != address(0)) {
1124                     return ownership;
1125                 }
1126             }
1127         }
1128 
1129         revert('ERC721A: unable to determine the owner of token');
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-ownerOf}.
1134      */
1135     function ownerOf(uint256 tokenId) public view override returns (address) {
1136         return ownershipOf(tokenId).addr;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Metadata-name}.
1141      */
1142     function name() public view virtual override returns (string memory) {
1143         return _name;
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Metadata-symbol}.
1148      */
1149     function symbol() public view virtual override returns (string memory) {
1150         return _symbol;
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Metadata-tokenURI}.
1155      */
1156     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1157         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1158 
1159         string memory baseURI = _baseURI();
1160         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1161     }
1162 
1163     /**
1164      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1165      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1166      * by default, can be overriden in child contracts.
1167      */
1168     function _baseURI() internal view virtual returns (string memory) {
1169         return '';
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-approve}.
1174      */
1175     function approve(address to, uint256 tokenId) public override {
1176         address owner = ERC721A.ownerOf(tokenId);
1177         require(to != owner, 'ERC721A: approval to current owner');
1178 
1179         require(
1180             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1181             'ERC721A: approve caller is not owner nor approved for all'
1182         );
1183 
1184         _approve(to, tokenId, owner);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-getApproved}.
1189      */
1190     function getApproved(uint256 tokenId) public view override returns (address) {
1191         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1192 
1193         return _tokenApprovals[tokenId];
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-setApprovalForAll}.
1198      */
1199     function setApprovalForAll(address operator, bool approved) public override {
1200         require(operator != _msgSender(), 'ERC721A: approve to caller');
1201 
1202         _operatorApprovals[_msgSender()][operator] = approved;
1203         emit ApprovalForAll(_msgSender(), operator, approved);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-isApprovedForAll}.
1208      */
1209     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1210         return _operatorApprovals[owner][operator];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-transferFrom}.
1215      */
1216     function transferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) public override {
1221         _transfer(from, to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-safeTransferFrom}.
1226      */
1227     function safeTransferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) public override {
1232         safeTransferFrom(from, to, tokenId, '');
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-safeTransferFrom}.
1237      */
1238     function safeTransferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId,
1242         bytes memory _data
1243     ) public override {
1244         _transfer(from, to, tokenId);
1245         require(
1246             _checkOnERC721Received(from, to, tokenId, _data),
1247             'ERC721A: transfer to non ERC721Receiver implementer'
1248         );
1249     }
1250 
1251     /**
1252      * @dev Returns whether `tokenId` exists.
1253      *
1254      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1255      *
1256      * Tokens start existing when they are minted (`_mint`),
1257      */
1258     function _exists(uint256 tokenId) internal view returns (bool) {
1259         return tokenId - START_TOKEN_ID < currentIndex;
1260     }
1261 
1262     function _safeMint(address to, uint256 quantity) internal {
1263         _safeMint(to, quantity, '');
1264     }
1265 
1266     /**
1267      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1268      *
1269      * Requirements:
1270      *
1271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1272      * - `quantity` must be greater than 0.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _safeMint(
1277         address to,
1278         uint256 quantity,
1279         bytes memory _data
1280     ) internal {
1281         _mint(to, quantity, _data, true);
1282     }
1283 
1284     /**
1285      * @dev Mints `quantity` tokens and transfers them to `to`.
1286      *
1287      * Requirements:
1288      *
1289      * - `to` cannot be the zero address.
1290      * - `quantity` must be greater than 0.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function _mint(
1295         address to,
1296         uint256 quantity,
1297         bytes memory _data,
1298         bool safe
1299     ) internal {
1300         uint256 startTokenId = currentIndex + START_TOKEN_ID;
1301         require(to != address(0), 'ERC721A: mint to the zero address');
1302         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1303 
1304         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1305 
1306         // Overflows are incredibly unrealistic.
1307         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1308         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1309         unchecked {
1310             _addressData[to].balance += uint128(quantity);
1311             _addressData[to].numberMinted += uint128(quantity);
1312 
1313             _ownerships[startTokenId].addr = to;
1314             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1315 
1316             uint256 updatedIndex = startTokenId;
1317 
1318             for (uint256 i; i < quantity; i++) {
1319                 emit Transfer(address(0), to, updatedIndex);
1320                 if (safe) {
1321                     require(
1322                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1323                         'ERC721A: transfer to non ERC721Receiver implementer'
1324                     );
1325                 }
1326 
1327                 updatedIndex++;
1328             }
1329 
1330             currentIndex += quantity;
1331         }
1332 
1333         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1334     }
1335 
1336     /**
1337      * @dev Transfers `tokenId` from `from` to `to`.
1338      *
1339      * Requirements:
1340      *
1341      * - `to` cannot be the zero address.
1342      * - `tokenId` token must be owned by `from`.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function _transfer(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) private {
1351         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1352 
1353         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1354         getApproved(tokenId) == _msgSender() ||
1355         isApprovedForAll(prevOwnership.addr, _msgSender()));
1356 
1357         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1358 
1359         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1360         require(to != address(0), 'ERC721A: transfer to the zero address');
1361 
1362         _beforeTokenTransfers(from, to, tokenId, 1);
1363 
1364         // Clear approvals from the previous owner
1365         _approve(address(0), tokenId, prevOwnership.addr);
1366 
1367         // Underflow of the sender's balance is impossible because we check for
1368         // ownership above and the recipient's balance can't realistically overflow.
1369         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1370         unchecked {
1371             _addressData[from].balance -= 1;
1372             _addressData[to].balance += 1;
1373 
1374             _ownerships[tokenId].addr = to;
1375             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1376 
1377             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1378             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1379             uint256 nextTokenId = tokenId + 1;
1380             if (_ownerships[nextTokenId].addr == address(0)) {
1381                 if (_exists(nextTokenId)) {
1382                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1383                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1384                 }
1385             }
1386         }
1387 
1388         emit Transfer(from, to, tokenId);
1389         _afterTokenTransfers(from, to, tokenId, 1);
1390     }
1391 
1392     /**
1393      * @dev Approve `to` to operate on `tokenId`
1394      *
1395      * Emits a {Approval} event.
1396      */
1397     function _approve(
1398         address to,
1399         uint256 tokenId,
1400         address owner
1401     ) private {
1402         _tokenApprovals[tokenId] = to;
1403         emit Approval(owner, to, tokenId);
1404     }
1405 
1406     /**
1407      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1408      * The call is not executed if the target address is not a contract.
1409      *
1410      * @param from address representing the previous owner of the given token ID
1411      * @param to target address that will receive the tokens
1412      * @param tokenId uint256 ID of the token to be transferred
1413      * @param _data bytes optional data to send along with the call
1414      * @return bool whether the call correctly returned the expected magic value
1415      */
1416     function _checkOnERC721Received(
1417         address from,
1418         address to,
1419         uint256 tokenId,
1420         bytes memory _data
1421     ) private returns (bool) {
1422         if (to.isContract()) {
1423             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1424                 return retval == IERC721Receiver(to).onERC721Received.selector;
1425             } catch (bytes memory reason) {
1426                 if (reason.length == 0) {
1427                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1428                 } else {
1429                     assembly {
1430                         revert(add(32, reason), mload(reason))
1431                     }
1432                 }
1433             }
1434         } else {
1435             return true;
1436         }
1437     }
1438 
1439     /**
1440      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1441      *
1442      * startTokenId - the first token id to be transferred
1443      * quantity - the amount to be transferred
1444      *
1445      * Calling conditions:
1446      *
1447      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1448      * transferred to `to`.
1449      * - When `from` is zero, `tokenId` will be minted for `to`.
1450      */
1451     function _beforeTokenTransfers(
1452         address from,
1453         address to,
1454         uint256 startTokenId,
1455         uint256 quantity
1456     ) internal virtual {}
1457 
1458     /**
1459      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1460      * minting.
1461      *
1462      * startTokenId - the first token id to be transferred
1463      * quantity - the amount to be transferred
1464      *
1465      * Calling conditions:
1466      *
1467      * - when `from` and `to` are both non-zero.
1468      * - `from` and `to` are never both zero.
1469      */
1470     function _afterTokenTransfers(
1471         address from,
1472         address to,
1473         uint256 startTokenId,
1474         uint256 quantity
1475     ) internal virtual {}
1476 }
1477 
1478 
1479 // File contracts/MellowCats.sol
1480 
1481 
1482 
1483 pragma solidity ^0.8.0;
1484 contract MellowCats is Ownable, ERC721A, ReentrancyGuard {
1485     using SafeMath for uint256;
1486    
1487     bool private _isActive = false;
1488 
1489     uint256 public constant MAX_SUPPLY = 9999;
1490 
1491     uint256 public constant maxCountPerMint = 20;
1492     
1493     uint256 public price1 = 0.015 ether;
1494     uint256 public price2 = 0.02 ether;
1495 
1496     bytes32 public merkleRoot;
1497     uint256 public freeMintCount = 25;     // Commnunity freee mint count
1498 
1499     string private _tokenBaseURI = "";
1500 
1501     address private constant devAddr = 0x08E7d2BCdEf1FEae4D0293822049470865bF240e;
1502 
1503     address private constant coolCatAddr = 0x1A92f7381B9F03921564a437210bB9396471050C;
1504     address private constant xApesAddr = 0x22C08C358f62f35B742D023Bf2fAF67e30e5376E;
1505     address private constant xPunkAddr = 0x0D0167A823C6619D430B1a96aD85B888bcF97C37;
1506     address private constant xAzukiAddr = 0x2eb6be120eF111553F768FcD509B6368e82D1661;
1507 
1508     modifier onlyActive() {
1509         require(_isActive && totalSupply() < MAX_SUPPLY, 'not active');
1510         _;
1511     }
1512 
1513     constructor(bytes32 _merkleRoot) ERC721A("MellowCat", "MellowCat") {
1514         merkleRoot = _merkleRoot;
1515     }
1516 
1517     function mint(uint256 numberOfTokens, bytes32[] calldata merkleProof) external payable onlyActive nonReentrant() {
1518         require(numberOfTokens > 0, "zero count");
1519         require(numberOfTokens <= maxCountPerMint, "exceeded max limit per mint");
1520         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1521         
1522         uint256 costForMinting = costForMint(numberOfTokens, msg.sender, merkleProof);
1523         require(msg.value >= costForMinting, "insufficient funds!");
1524 
1525         _safeMint(msg.sender, numberOfTokens);
1526     }
1527 
1528     function mintOwner(uint256 numberOfTokens) external onlyActive onlyOwner {
1529         require(numberOfTokens > 0, "zero count");
1530         require(numberOfTokens <= maxCountPerMint, "exceeded max limit per mint");
1531         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1532         require(freeMintCount >= numberOfTokens, "exceeded max free limit");
1533 
1534         freeMintCount -= numberOfTokens;
1535 
1536         _safeMint(msg.sender, numberOfTokens);
1537     }
1538 
1539     function costForMint(uint256 _numToMint, address account, bytes32[] calldata merkleProof) public view returns(uint256) {
1540         uint256 price = 0;
1541         if(IERC721(coolCatAddr).balanceOf(account) > 0) {
1542             price = price1;
1543         } else if (IERC721(xApesAddr).balanceOf(account) > 0) {
1544             price = price1;
1545         } else if (IERC721(xPunkAddr).balanceOf(account) > 0) {
1546             price = price1;
1547         } else if (IERC721(xAzukiAddr).balanceOf(account) > 0) {
1548             price = price1;
1549         } else if (isWhiteList(account, merkleProof)) {
1550             price = price1;
1551         } else {
1552             price = price2;
1553         }
1554 
1555         return price.mul(_numToMint);
1556     }
1557 
1558     function isWhiteList(address account, bytes32[] calldata merkleProof) public view returns(bool) {
1559         // Verify the merkle proof.
1560         bytes32 node = keccak256(abi.encodePacked(account));
1561         return MerkleProof.verify(merkleProof, merkleRoot, node);
1562     }
1563 
1564 
1565     function _baseURI() internal view override returns (string memory) {
1566         return _tokenBaseURI;
1567     }
1568 
1569     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory)
1570     {
1571         return super.tokenURI(tokenId);
1572     }
1573 
1574     
1575     /////////////////////////////////////////////////////////////
1576     //////////////////   Admin Functions ////////////////////////
1577     /////////////////////////////////////////////////////////////
1578     function startSale() external onlyOwner {
1579         _isActive = true;
1580     }
1581 
1582     function endSale() external onlyOwner {
1583         _isActive = false;
1584     }
1585 
1586     function setPriceForWhitelist(uint256 _price) external onlyOwner {
1587         price1 = _price;
1588     }
1589 
1590     function setPriceForNonWhitelist(uint256 _price) external onlyOwner {
1591         price2 = _price;
1592     }
1593 
1594     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1595         merkleRoot = _merkleRoot;
1596     }
1597 
1598     function setTokenBaseURI(string memory URI) external onlyOwner {
1599         _tokenBaseURI = URI;
1600     }
1601 
1602     function withdraw() external onlyOwner nonReentrant {
1603         uint256 balance = address(this).balance;
1604         uint256 devAmount = balance.div(10);
1605         Address.sendValue(payable(devAddr), devAmount);
1606         Address.sendValue(payable(owner()), balance.sub(devAmount));
1607     }
1608 
1609     receive() external payable {}
1610 }