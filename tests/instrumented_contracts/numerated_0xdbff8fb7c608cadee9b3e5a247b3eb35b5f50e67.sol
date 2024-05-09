1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = _efficientHash(computedHash, proofElement);
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = _efficientHash(proofElement, computedHash);
52             }
53         }
54         return computedHash;
55     }
56 
57     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
58         assembly {
59             mstore(0x00, a)
60             mstore(0x20, b)
61             value := keccak256(0x00, 0x40)
62         }
63     }
64 }
65 
66 // File: contracts/IWhitelistable.sol
67 
68 
69 
70 /**
71 * Author: Lambdalf the White
72 * Edit  : Squeebo
73 */
74 
75 pragma solidity 0.8.10;
76 
77 
78 abstract contract IWhitelistable {
79 	// Errors
80 	error IWhitelistable_NOT_SET();
81 	error IWhitelistable_CONSUMED();
82 	error IWhitelistable_FORBIDDEN();
83 	error IWhitelistable_NO_ALLOWANCE();
84 
85 	bytes32 private _root;
86 	mapping( address => uint256 ) private _consumed;
87 
88 	modifier isWhitelisted( address account_, bytes32[] memory proof_, uint256 passMax_, uint256 qty_ ) {
89 		if ( qty_ > passMax_ ) {
90 			revert IWhitelistable_FORBIDDEN();
91 		}
92 
93 		uint256 _allowed_ = _checkWhitelistAllowance( account_, proof_, passMax_ );
94 
95 		if ( _allowed_ < qty_ ) {
96 			revert IWhitelistable_FORBIDDEN();
97 		}
98 
99 		_;
100 	}
101 
102 	/**
103 	* @dev Sets the pass to protect the whitelist.
104 	*/
105 	function _setWhitelist( bytes32 root_ ) internal virtual {
106 		_root = root_;
107 	}
108 
109 	/**
110 	* @dev Returns the amount that `account_` is allowed to access from the whitelist.
111 	* 
112 	* Requirements:
113 	* 
114 	* - `_root` must be set.
115 	* 
116 	* See {IWhitelistable-_consumeWhitelist}.
117 	*/
118 	function _checkWhitelistAllowance( address account_, bytes32[] memory proof_, uint256 passMax_ ) internal view returns ( uint256 ) {
119 		if ( _root == 0 ) {
120 			revert IWhitelistable_NOT_SET();
121 		}
122 
123 		if ( _consumed[ account_ ] >= passMax_ ) {
124 			revert IWhitelistable_CONSUMED();
125 		}
126 
127 		if ( ! _computeProof( account_, proof_ ) ) {
128 			revert IWhitelistable_FORBIDDEN();
129 		}
130 
131 		uint256 _res_;
132 		unchecked {
133 			_res_ = passMax_ - _consumed[ account_ ];
134 		}
135 
136 		return _res_;
137 	}
138 
139 	function _computeProof( address account_, bytes32[] memory proof_ ) private view returns ( bool ) {
140 		bytes32 leaf = keccak256(abi.encodePacked(account_));
141 		return MerkleProof.processProof( proof_, leaf ) == _root;
142 	}
143 
144 	/**
145 	* @dev Consumes `amount_` pass passes from `account_`.
146 	* 
147 	* Note: Before calling this function, eligibility should be checked through {IWhitelistable-checkWhitelistAllowance}.
148 	*/
149 	function _consumeWhitelist( address account_, uint256 qty_ ) internal {
150 		unchecked {
151 			_consumed[ account_ ] += qty_;
152 		}
153 	}
154 }
155 
156 // File: contracts/ITradable.sol
157 
158 
159 
160 /**
161 * Author: Lambdalf the White
162 */
163 
164 pragma solidity 0.8.10;
165 
166 contract OwnableDelegateProxy {}
167 
168 contract ProxyRegistry {
169 	mapping( address => OwnableDelegateProxy ) public proxies;
170 }
171 
172 abstract contract ITradable {
173 	// OpenSea proxy registry address
174 	address[] internal _proxyRegistries;
175 
176 	function _setProxyRegistry( address proxyRegistryAddress_ ) internal {
177 		_proxyRegistries.push( proxyRegistryAddress_ );
178 	}
179 
180 	/**
181 	* @dev Checks if `operator_` is the registered proxy for `tokenOwner_`.
182 	* 
183 	* Note: Use this function to allow whitelisting of registered proxy.
184 	*/
185 	function _isRegisteredProxy( address tokenOwner_, address operator_ ) internal view returns ( bool ) {
186 		for ( uint256 i; i < _proxyRegistries.length; i++ ) {
187 			ProxyRegistry _proxyRegistry_ = ProxyRegistry( _proxyRegistries[ i ] );
188 			if ( address( _proxyRegistry_.proxies( tokenOwner_ ) ) == operator_ ) {
189 				return true;
190 			}
191 		}
192 		return false;
193 	}
194 }
195 // File: contracts/IPausable.sol
196 
197 
198 
199 /**
200 * Author: Lambdalf the White
201 */
202 
203 pragma solidity 0.8.10;
204 
205 abstract contract IPausable {
206 	// Errors
207 	error IPausable_SALE_NOT_CLOSED();
208 	error IPausable_SALE_NOT_OPEN();
209 	error IPausable_PRESALE_NOT_OPEN();
210 
211 	// Enum to represent the sale state, defaults to ``CLOSED``.
212 	enum SaleState { CLOSED, PRESALE, SALE }
213 
214 	// The current state of the contract
215 	SaleState public saleState;
216 
217 	/**
218 	* @dev Emitted when the sale state changes
219 	*/
220 	event SaleStateChanged( SaleState indexed previousState, SaleState indexed newState );
221 
222 	/**
223 	* @dev Sale state can have one of 3 values, ``CLOSED``, ``PRESALE``, or ``SALE``.
224 	*/
225 	function _setSaleState( SaleState newState_ ) internal virtual {
226 		SaleState _previousState_ = saleState;
227 		saleState = newState_;
228 		emit SaleStateChanged( _previousState_, newState_ );
229 	}
230 
231 	/**
232 	* @dev Throws if sale state is not ``CLOSED``.
233 	*/
234 	modifier saleClosed {
235 		if ( saleState != SaleState.CLOSED ) {
236 			revert IPausable_SALE_NOT_CLOSED();
237 		}
238 		_;
239 	}
240 
241 	/**
242 	* @dev Throws if sale state is not ``SALE``.
243 	*/
244 	modifier saleOpen {
245 		if ( saleState != SaleState.SALE ) {
246 			revert IPausable_SALE_NOT_OPEN();
247 		}
248 		_;
249 	}
250 
251 	/**
252 	* @dev Throws if sale state is not ``PRESALE``.
253 	*/
254 	modifier presaleOpen {
255 		if ( saleState != SaleState.PRESALE ) {
256 			revert IPausable_PRESALE_NOT_OPEN();
257 		}
258 		_;
259 	}
260 }
261 
262 // File: contracts/IOwnable.sol
263 
264 
265 
266 /**
267 * Author: Lambdalf the White
268 */
269 
270 pragma solidity 0.8.10;
271 
272 /**
273 * @dev Contract module which provides a basic access control mechanism, where
274 * there is an account (an owner) that can be granted exclusive access to
275 * specific functions.
276 *
277 * By default, the owner account will be the one that deploys the contract. This
278 * can later be changed with {transferOwnership}.
279 *
280 * This module is used through inheritance. It will make available the modifier
281 * `onlyOwner`, which can be applied to your functions to restrict their use to
282 * the owner.
283 */
284 abstract contract IOwnable {
285 	// Errors
286 	error IOwnable_NOT_OWNER();
287 
288 	// The owner of the contract
289 	address private _owner;
290 
291 	/**
292 	* @dev Emitted when contract ownership changes.
293 	*/
294 	event OwnershipTransferred( address indexed previousOwner, address indexed newOwner );
295 
296 	/**
297 	* @dev Initializes the contract setting the deployer as the initial owner.
298 	*/
299 	function _initIOwnable( address owner_ ) internal {
300 		_owner = owner_;
301 	}
302 
303 	/**
304 	* @dev Returns the address of the current owner.
305 	*/
306 	function owner() public view virtual returns ( address ) {
307 		return _owner;
308 	}
309 
310 	/**
311 	* @dev Throws if called by any account other than the owner.
312 	*/
313 	modifier onlyOwner() {
314 		if ( owner() != msg.sender ) {
315 			revert IOwnable_NOT_OWNER();
316 		}
317 		_;
318 	}
319 
320 	/**
321 	* @dev Transfers ownership of the contract to a new account (`newOwner`).
322 	* Can only be called by the current owner.
323 	*/
324 	function transferOwnership( address newOwner_ ) public virtual onlyOwner {
325 		address _oldOwner_ = _owner;
326 		_owner = newOwner_;
327 		emit OwnershipTransferred( _oldOwner_, newOwner_ );
328 	}
329 }
330 
331 // File: contracts/IERC2981.sol
332 
333 
334 pragma solidity 0.8.10;
335 
336 interface IERC2981 {
337   /**
338   * @dev ERC165 bytes to add to interface array - set in parent contract
339   * implementing this standard
340   *
341   * bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
342   * bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
343   * _registerInterface(_INTERFACE_ID_ERC2981);
344   *
345   * @notice Called with the sale price to determine how much royalty
346   *           is owed and to whom.
347   * @param _tokenId - the NFT asset queried for royalty information
348   * @param _salePrice - the sale price of the NFT asset specified by _tokenId
349   * @return receiver - address of who should be sent the royalty payment
350   * @return royaltyAmount - the royalty payment amount for _salePrice
351   */
352   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
353 }
354 
355 // File: contracts/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: contracts/IERC721Receiver.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 /**
390  * @title ERC721 token receiver interface
391  * @dev Interface for any contract that wants to support safeTransfers
392  * from ERC721 asset contracts.
393  */
394 interface IERC721Receiver {
395     /**
396      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
397      * by `operator` from `from`, this function is called.
398      *
399      * It must return its Solidity selector to confirm the token transfer.
400      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
401      *
402      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
403      */
404     function onERC721Received(
405         address operator,
406         address from,
407         uint256 tokenId,
408         bytes calldata data
409     ) external returns (bytes4);
410 }
411 
412 // File: contracts/IERC165.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
416 
417 pragma solidity 0.8.10;
418 
419 /**
420  * @dev Interface of the ERC165 standard, as defined in the
421  * https://eips.ethereum.org/EIPS/eip-165[EIP].
422  *
423  * Implementers can declare support of contract interfaces, which can then be
424  * queried by others ({ERC165Checker}).
425  *
426  * For an implementation, see {ERC165}.
427  */
428 interface IERC165 {
429     /**
430      * @dev Returns true if this contract implements the interface defined by
431      * `interfaceId`. See the corresponding
432      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
433      * to learn more about how these ids are created.
434      *
435      * This function call must use less than 30 000 gas.
436      */
437     function supportsInterface(bytes4 interfaceId) external view returns (bool);
438 }
439 
440 // File: contracts/ERC2981Base.sol
441 
442 
443 
444 /**
445 * Author: Lambdalf the White
446 */
447 
448 pragma solidity 0.8.10;
449 
450 
451 
452 abstract contract ERC2981Base is IERC165, IERC2981 {
453 	// Errors
454 	error IERC2981_INVALID_ROYALTIES();
455 
456 	// Royalty rate is stored out of 10,000 instead of a percentage to allow for
457 	// up to two digits below the unit such as 2.5% or 1.25%.
458 	uint private constant ROYALTY_BASE = 10000;
459 
460 	// Represents the percentage of royalties on each sale on secondary markets.
461 	// Set to 0 to have no royalties.
462 	uint256 private _royaltyRate;
463 
464 	// Address of the recipient of the royalties.
465 	address private _royaltyRecipient;
466 
467 	function _initERC2981Base( address royaltyRecipient_, uint256 royaltyRate_ ) internal {
468 		_setRoyaltyInfo( royaltyRecipient_, royaltyRate_ );
469 	}
470 
471 	/**
472 	* @dev See {IERC2981-royaltyInfo}.
473 	* 
474 	* Note: This function should be overriden to revert on a query for non existent token.
475 	*/
476 	function royaltyInfo( uint256, uint256 salePrice_ ) public view virtual override returns ( address, uint256 ) {
477 		if ( salePrice_ == 0 || _royaltyRate == 0 ) {
478 			return ( _royaltyRecipient, 0 );
479 		}
480 		uint256 _royaltyAmount_ = _royaltyRate * salePrice_ / ROYALTY_BASE;
481 		return ( _royaltyRecipient, _royaltyAmount_ );
482 	}
483 
484 	/**
485 	* @dev Sets the royalty rate to `royaltyRate_` and the royalty recipient to `royaltyRecipient_`.
486 	* 
487 	* Requirements: 
488 	* 
489 	* - `royaltyRate_` cannot be higher than `ROYALTY_BASE`;
490 	*/
491 	function _setRoyaltyInfo( address royaltyRecipient_, uint256 royaltyRate_ ) internal virtual {
492 		if ( royaltyRate_ > ROYALTY_BASE ) {
493 			revert IERC2981_INVALID_ROYALTIES();
494 		}
495 		_royaltyRate      = royaltyRate_;
496 		_royaltyRecipient = royaltyRecipient_;
497 	}
498 
499 	/**
500 	* @dev See {IERC165-supportsInterface}.
501 	*/
502 	function supportsInterface( bytes4 interfaceId_ ) public view virtual override returns ( bool ) {
503 		return 
504 			interfaceId_ == type( IERC2981 ).interfaceId ||
505 			interfaceId_ == type( IERC165 ).interfaceId;
506 	}
507 }
508 
509 // File: contracts/IERC721.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Required interface of an ERC721 compliant contract.
519  */
520 interface IERC721 is IERC165 {
521     /**
522      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
523      */
524     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
533      */
534     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
535 
536     /**
537      * @dev Returns the number of tokens in ``owner``'s account.
538      */
539     function balanceOf(address owner) external view returns (uint256 balance);
540 
541     /**
542      * @dev Returns the owner of the `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function ownerOf(uint256 tokenId) external view returns (address owner);
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
552      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Transfers `tokenId` token from `from` to `to`.
572      *
573      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      *
582      * Emits a {Transfer} event.
583      */
584     function transferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
592      * The approval is cleared when the token is transferred.
593      *
594      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Returns the account approved for `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     /**
615      * @dev Approve or remove `operator` as an operator for the caller.
616      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
617      *
618      * Requirements:
619      *
620      * - The `operator` cannot be the caller.
621      *
622      * Emits an {ApprovalForAll} event.
623      */
624     function setApprovalForAll(address operator, bool _approved) external;
625 
626     /**
627      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
628      *
629      * See {setApprovalForAll}
630      */
631     function isApprovedForAll(address owner, address operator) external view returns (bool);
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId,
650         bytes calldata data
651     ) external;
652 }
653 
654 // File: contracts/IERC721Metadata.sol
655 
656 
657 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
664  * @dev See https://eips.ethereum.org/EIPS/eip-721
665  */
666 interface IERC721Metadata is IERC721 {
667     /**
668      * @dev Returns the token collection name.
669      */
670     function name() external view returns (string memory);
671 
672     /**
673      * @dev Returns the token collection symbol.
674      */
675     function symbol() external view returns (string memory);
676 
677     /**
678      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
679      */
680     function tokenURI(uint256 tokenId) external view returns (string memory);
681 }
682 
683 // File: contracts/ERC721Batch.sol
684 
685 
686 
687 /**
688 * Author: Lambdalf the White
689 */
690 
691 pragma solidity 0.8.10;
692 
693 
694 
695 
696 /**
697 * @dev Required interface of an ERC721 compliant contract.
698 */
699 abstract contract ERC721Batch is Context, IERC721Metadata {
700 	// Errors
701 	error IERC721_APPROVE_OWNER();
702 	error IERC721_APPROVE_CALLER();
703 	error IERC721_CALLER_NOT_APPROVED();
704 	error IERC721_NONEXISTANT_TOKEN();
705 	error IERC721_NON_ERC721_RECEIVER();
706 	error IERC721_NULL_ADDRESS_BALANCE();
707 	error IERC721_NULL_ADDRESS_TRANSFER();
708 
709 	// Token name
710 	string private _name;
711 
712 	// Token symbol
713 	string private _symbol;
714 
715 	// Token Base URI
716 	string private _baseURI;
717 
718 	// Token IDs
719 	uint256 private _numTokens;
720 
721 	// List of owner addresses
722 	mapping( uint256 => address ) private _owners;
723 
724 	// Mapping from token ID to approved address
725 	mapping( uint256 => address ) private _tokenApprovals;
726 
727 	// Mapping from owner to operator approvals
728 	mapping( address => mapping( address => bool ) ) private _operatorApprovals;
729 
730 	/**
731 	* @dev Ensures the token exist. 
732 	* A token exists if it has been minted and is not owned by the null address.
733 	* 
734 	* @param tokenId_ uint256 ID of the token to verify
735 	*/
736 	modifier exists( uint256 tokenId_ ) {
737 		if ( ! _exists( tokenId_ ) ) {
738 			revert IERC721_NONEXISTANT_TOKEN();
739 		}
740 		_;
741 	}
742 
743 	// **************************************
744 	// *****          INTERNAL          *****
745 	// **************************************
746 		/**
747 		* @dev Internal function returning the number of tokens in `tokenOwner_`'s account.
748 		*/
749 		function _balanceOf( address tokenOwner_ ) internal view virtual returns ( uint256 ) {
750 			if ( tokenOwner_ == address( 0 ) ) {
751 				return 0;
752 			}
753 
754 			uint256 _supplyMinted_ = _supplyMinted();
755 			uint256 _count_ = 0;
756 			address _currentTokenOwner_;
757 			for ( uint256 i; i < _supplyMinted_; i++ ) {
758 				if ( _owners[ i ] != address( 0 ) ) {
759 					_currentTokenOwner_ = _owners[ i ];
760 				}
761 				if ( tokenOwner_ == _currentTokenOwner_ ) {
762 					_count_++;
763 				}
764 			}
765 			return _count_;
766 		}
767 
768 		/**
769 		* @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
770 		* The call is not executed if the target address is not a contract.
771 		*
772 		* @param from_ address representing the previous owner of the given token ID
773 		* @param to_ target address that will receive the tokens
774 		* @param tokenId_ uint256 ID of the token to be transferred
775 		* @param data_ bytes optional data to send along with the call
776 		* @return bool whether the call correctly returned the expected magic value
777 		*/
778 		function _checkOnERC721Received( address from_, address to_, uint256 tokenId_, bytes memory data_ ) internal virtual returns ( bool ) {
779 			// This method relies on extcodesize, which returns 0 for contracts in
780 			// construction, since the code is only stored at the end of the
781 			// constructor execution.
782 			// 
783 			// IMPORTANT
784 			// It is unsafe to assume that an address not flagged by this method
785 			// is an externally-owned account (EOA) and not a contract.
786 			//
787 			// Among others, the following types of addresses will not be flagged:
788 			//
789 			//  - an externally-owned account
790 			//  - a contract in construction
791 			//  - an address where a contract will be created
792 			//  - an address where a contract lived, but was destroyed
793 			uint256 _size_;
794 			assembly {
795 				_size_ := extcodesize( to_ )
796 			}
797 
798 			// If address is a contract, check that it is aware of how to handle ERC721 tokens
799 			if ( _size_ > 0 ) {
800 				try IERC721Receiver( to_ ).onERC721Received( _msgSender(), from_, tokenId_, data_ ) returns ( bytes4 retval ) {
801 					return retval == IERC721Receiver.onERC721Received.selector;
802 				}
803 				catch ( bytes memory reason ) {
804 					if ( reason.length == 0 ) {
805 						revert IERC721_NON_ERC721_RECEIVER();
806 					}
807 					else {
808 						assembly {
809 							revert( add( 32, reason ), mload( reason ) )
810 						}
811 					}
812 				}
813 			}
814 			else {
815 				return true;
816 			}
817 		}
818 
819 		/**
820 		* @dev Internal function returning whether a token exists. 
821 		* A token exists if it has been minted and is not owned by the null address.
822 		* 
823 		* @param tokenId_ uint256 ID of the token to verify
824 		* 
825 		* @return bool whether the token exists
826 		*/
827 		function _exists( uint256 tokenId_ ) internal view virtual returns ( bool ) {
828 			return tokenId_ < _numTokens;
829 		}
830 
831 		/**
832 		* @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
833 		*/
834 		function _initERC721BatchMetadata( string memory name_, string memory symbol_ ) internal {
835 			_name   = name_;
836 			_symbol = symbol_;
837 		}
838 
839 		/**
840 		* @dev Internal function returning whether `operator_` is allowed 
841 		* to manage tokens on behalf of `tokenOwner_`.
842 		* 
843 		* @param tokenOwner_ address that owns tokens
844 		* @param operator_ address that tries to manage tokens
845 		* 
846 		* @return bool whether `operator_` is allowed to handle the token
847 		*/
848 		function _isApprovedForAll( address tokenOwner_, address operator_ ) internal view virtual returns ( bool ) {
849 			return _operatorApprovals[ tokenOwner_ ][ operator_ ];
850 		}
851 
852 		/**
853 		* @dev Internal function returning whether `operator_` is allowed to handle `tokenId_`
854 		* 
855 		* Note: To avoid multiple checks for the same data, it is assumed that existence of `tokeId_` 
856 		* has been verified prior via {_exists}
857 		* If it hasn't been verified, this function might panic
858 		* 
859 		* @param operator_ address that tries to handle the token
860 		* @param tokenId_ uint256 ID of the token to be handled
861 		* 
862 		* @return bool whether `operator_` is allowed to handle the token
863 		*/
864 		function _isApprovedOrOwner( address tokenOwner_, address operator_, uint256 tokenId_ ) internal view virtual returns ( bool ) {
865 			bool _isApproved_ = operator_ == tokenOwner_ ||
866 													operator_ == _tokenApprovals[ tokenId_ ] ||
867 													_isApprovedForAll( tokenOwner_, operator_ );
868 			return _isApproved_;
869 		}
870 
871 		/**
872 		* @dev Mints `qty_` tokens and transfers them to `to_`.
873 		* 
874 		* This internal function can be used to perform token minting.
875 		* 
876 		* Emits a {ConsecutiveTransfer} event.
877 		*/
878 		function _mint( address to_, uint256 qty_ ) internal virtual {
879 			uint256 _firstToken_ = _numTokens;
880 			uint256 _lastToken_ = _firstToken_ + qty_ - 1;
881 
882 			_owners[ _firstToken_ ] = to_;
883 			if ( _lastToken_ > _firstToken_ ) {
884 				_owners[ _lastToken_ ] = to_;
885 			}
886 			for ( uint256 i; i < qty_; i ++ ) {
887 				emit Transfer( address( 0 ), to_, _firstToken_ + i );
888 			}
889 			_numTokens = _lastToken_ + 1;
890 		}
891 
892 		/**
893 		* @dev Internal function returning the owner of the `tokenId_` token.
894 		* 
895 		* @param tokenId_ uint256 ID of the token to verify
896 		* 
897 		* @return address the address of the token owner
898 		*/
899 		function _ownerOf( uint256 tokenId_ ) internal view virtual returns ( address ) {
900 			uint256 _tokenId_ = tokenId_;
901 			address _tokenOwner_ = _owners[ _tokenId_ ];
902 			while ( _tokenOwner_ == address( 0 ) ) {
903 				_tokenId_ --;
904 				_tokenOwner_ = _owners[ _tokenId_ ];
905 			}
906 
907 			return _tokenOwner_;
908 		}
909 
910 		/**
911 		* @dev Internal function used to set the base URI of the collection.
912 		*/
913 		function _setBaseURI( string memory baseURI_ ) internal virtual {
914 			_baseURI = baseURI_;
915 		}
916 
917 		/**
918 		* @dev Internal function returning the total number of tokens minted
919 		* 
920 		* @return uint256 the number of tokens that have been minted so far
921 		*/
922 		function _supplyMinted() internal view virtual returns ( uint256 ) {
923 			return _numTokens;
924 		}
925 
926 		/**
927 		* @dev Converts a `uint256` to its ASCII `string` decimal representation.
928 		*/
929 		function _toString( uint256 value ) internal pure returns ( string memory ) {
930 			// Inspired by OraclizeAPI's implementation - MIT licence
931 			// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
932 			if ( value == 0 ) {
933 				return "0";
934 			}
935 			uint256 temp = value;
936 			uint256 digits;
937 			while ( temp != 0 ) {
938 				digits ++;
939 				temp /= 10;
940 			}
941 			bytes memory buffer = new bytes( digits );
942 			while ( value != 0 ) {
943 				digits -= 1;
944 				buffer[ digits ] = bytes1( uint8( 48 + uint256( value % 10 ) ) );
945 				value /= 10;
946 			}
947 			return string( buffer );
948 		}
949 
950 		/**
951 		* @dev Transfers `tokenId_` from `from_` to `to_`.
952 		*
953 		* This internal function can be used to implement alternative mechanisms to perform 
954 		* token transfer, such as signature-based, or token burning.
955 		* 
956 		* Emits a {Transfer} event.
957 		*/
958 		function _transfer( address from_, address to_, uint256 tokenId_ ) internal virtual {
959 			_tokenApprovals[ tokenId_ ] = address( 0 );
960 			uint256 _previousId_ = tokenId_ > 0 ? tokenId_ - 1 : 0;
961 			uint256 _nextId_     = tokenId_ + 1;
962 			bool _previousShouldUpdate_ = _previousId_ < tokenId_ &&
963 																		_exists( _previousId_ ) &&
964 																		_owners[ _previousId_ ] == address( 0 );
965 			bool _nextShouldUpdate_ = _exists( _nextId_ ) &&
966 																_owners[ _nextId_ ] == address( 0 );
967 
968 			if ( _previousShouldUpdate_ ) {
969 				_owners[ _previousId_ ] = from_;
970 			}
971 
972 			if ( _nextShouldUpdate_ ) {
973 				_owners[ _nextId_ ] = from_;
974 			}
975 
976 			_owners[ tokenId_ ] = to_;
977 
978 			emit Transfer( from_, to_, tokenId_ );
979 		}
980 
981 	// **************************************
982 	// *****           PUBLIC           *****
983 	// **************************************
984 		/**
985 		* @dev See {IERC721-approve}.
986 		*/
987 		function approve( address to_, uint256 tokenId_ ) external virtual exists( tokenId_ ) {
988 			address _operator_ = _msgSender();
989 			address _tokenOwner_ = _ownerOf( tokenId_ );
990 			bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );
991 
992 			if ( ! _isApproved_ ) {
993 				revert IERC721_CALLER_NOT_APPROVED();
994 			}
995 
996 			if ( to_ == _tokenOwner_ ) {
997 				revert IERC721_APPROVE_OWNER();
998 			}
999 
1000 			_tokenApprovals[ tokenId_ ] = to_;
1001 			emit Approval( _tokenOwner_, to_, tokenId_ );
1002 		}
1003 
1004 		/**
1005 		* @dev See {IERC721-safeTransferFrom}.
1006 		* 
1007 		* Note: We can ignore `from_` as we can compare everything to the actual token owner, 
1008 		* but we cannot remove this parameter to stay in conformity with IERC721
1009 		*/
1010 		function safeTransferFrom( address, address to_, uint256 tokenId_ ) external virtual exists( tokenId_ ) {
1011 			address _operator_ = _msgSender();
1012 			address _tokenOwner_ = _ownerOf( tokenId_ );
1013 			bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );
1014 
1015 			if ( ! _isApproved_ ) {
1016 				revert IERC721_CALLER_NOT_APPROVED();
1017 			}
1018 
1019 			if ( to_ == address( 0 ) ) {
1020 				revert IERC721_NULL_ADDRESS_TRANSFER();
1021 			}
1022 
1023 			_transfer( _tokenOwner_, to_, tokenId_ );
1024 
1025 			if ( ! _checkOnERC721Received( _tokenOwner_, to_, tokenId_, "" ) ) {
1026 				revert IERC721_NON_ERC721_RECEIVER();
1027 			}
1028 		}
1029 
1030 		/**
1031 		* @dev See {IERC721-safeTransferFrom}.
1032 		* 
1033 		* Note: We can ignore `from_` as we can compare everything to the actual token owner, 
1034 		* but we cannot remove this parameter to stay in conformity with IERC721
1035 		*/
1036 		function safeTransferFrom( address, address to_, uint256 tokenId_, bytes calldata data_ ) external virtual exists( tokenId_ ) {
1037 			address _operator_ = _msgSender();
1038 			address _tokenOwner_ = _ownerOf( tokenId_ );
1039 			bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );
1040 
1041 			if ( ! _isApproved_ ) {
1042 				revert IERC721_CALLER_NOT_APPROVED();
1043 			}
1044 
1045 			if ( to_ == address( 0 ) ) {
1046 				revert IERC721_NULL_ADDRESS_TRANSFER();
1047 			}
1048 
1049 			_transfer( _tokenOwner_, to_, tokenId_ );
1050 
1051 			if ( ! _checkOnERC721Received( _tokenOwner_, to_, tokenId_, data_ ) ) {
1052 				revert IERC721_NON_ERC721_RECEIVER();
1053 			}
1054 		}
1055 
1056 		/**
1057 		* @dev See {IERC721-setApprovalForAll}.
1058 		*/
1059 		function setApprovalForAll( address operator_, bool approved_ ) public virtual override {
1060 			address _account_ = _msgSender();
1061 			if ( operator_ == _account_ ) {
1062 				revert IERC721_APPROVE_CALLER();
1063 			}
1064 
1065 			_operatorApprovals[ _account_ ][ operator_ ] = approved_;
1066 			emit ApprovalForAll( _account_, operator_, approved_ );
1067 		}
1068 
1069 		/**
1070 		* @dev See {IERC721-transferFrom}.
1071 		* 
1072 		* Note: We can ignore `from_` as we can compare everything to the actual token owner, 
1073 		* but we cannot remove this parameter to stay in conformity with IERC721
1074 		*/
1075 		function transferFrom( address, address to_, uint256 tokenId_ ) external virtual exists( tokenId_ ) {
1076 			address _operator_ = _msgSender();
1077 			address _tokenOwner_ = _ownerOf( tokenId_ );
1078 			bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );
1079 
1080 			if ( ! _isApproved_ ) {
1081 				revert IERC721_CALLER_NOT_APPROVED();
1082 			}
1083 
1084 			if ( to_ == address( 0 ) ) {
1085 				revert IERC721_NULL_ADDRESS_TRANSFER();
1086 			}
1087 
1088 			_transfer( _tokenOwner_, to_, tokenId_ );
1089 		}
1090 
1091 	// **************************************
1092 	// *****            VIEW            *****
1093 	// **************************************
1094 		/**
1095 		* @dev Returns the number of tokens in `tokenOwner_`'s account.
1096 		*/
1097 		function balanceOf( address tokenOwner_ ) external view virtual returns ( uint256 ) {
1098 			return _balanceOf( tokenOwner_ );
1099 		}
1100 
1101 		/**
1102 		* @dev Returns the account approved for `tokenId_` token.
1103 		*
1104 		* Requirements:
1105 		*
1106 		* - `tokenId_` must exist.
1107 		*/
1108 		function getApproved( uint256 tokenId_ ) external view virtual exists( tokenId_ ) returns ( address ) {
1109 			return _tokenApprovals[ tokenId_ ];
1110 		}
1111 
1112 		/**
1113 		* @dev Returns if the `operator_` is allowed to manage all of the assets of `tokenOwner_`.
1114 		*
1115 		* See {setApprovalForAll}
1116 		*/
1117 		function isApprovedForAll( address tokenOwner_, address operator_ ) external view virtual returns ( bool ) {
1118 			return _isApprovedForAll( tokenOwner_, operator_ );
1119 		}
1120 
1121 		/**
1122 		* @dev See {IERC721Metadata-name}.
1123 		*/
1124 		function name() public view virtual override returns ( string memory ) {
1125 			return _name;
1126 		}
1127 
1128 		/**
1129 		* @dev Returns the owner of the `tokenId_` token.
1130 		*
1131 		* Requirements:
1132 		*
1133 		* - `tokenId_` must exist.
1134 		*/
1135 		function ownerOf( uint256 tokenId_ ) external view virtual exists( tokenId_ ) returns ( address ) {
1136 			return _ownerOf( tokenId_ );
1137 		}
1138 
1139 		/**
1140 		* @dev See {IERC165-supportsInterface}.
1141 		*/
1142 		function supportsInterface( bytes4 interfaceId_ ) public view virtual override returns ( bool ) {
1143 			return 
1144 				interfaceId_ == type( IERC721Metadata ).interfaceId ||
1145 				interfaceId_ == type( IERC721 ).interfaceId ||
1146 				interfaceId_ == type( IERC165 ).interfaceId;
1147 		}
1148 
1149 		/**
1150 		* @dev See {IERC721Metadata-symbol}.
1151 		*/
1152 		function symbol() public view virtual override returns ( string memory ) {
1153 			return _symbol;
1154 		}
1155 
1156 		/**
1157 		* @dev See {IERC721Metadata-tokenURI}.
1158 		*/
1159 		function tokenURI( uint256 tokenId_ ) public view virtual override exists( tokenId_ ) returns ( string memory ) {
1160 			return bytes( _baseURI ).length > 0 ? string( abi.encodePacked( _baseURI, _toString( tokenId_ ) ) ) : _toString( tokenId_ );
1161 		}
1162 }
1163 
1164 // File: contracts/ERC721BatchStakable.sol
1165 
1166 
1167 
1168 /**
1169 * Author: Lambdalf the White
1170 */
1171 
1172 pragma solidity 0.8.10;
1173 
1174 
1175 
1176 /**
1177 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1178 * the Metadata extension and the Enumerable extension.
1179 * 
1180 * Note: This implementation is only compatible with a sequential order of tokens minted.
1181 * If you need to mint tokens in a random order, you will need to override the following functions:
1182 * Note also that this implementations is fairly inefficient and as such, 
1183 * those functions should be avoided inside non-view functions.
1184 */
1185 abstract contract ERC721BatchStakable is ERC721Batch, IERC721Receiver {
1186 	// Mapping of tokenId to stakeholder address
1187 	mapping( uint256 => address ) internal _stakedOwners;
1188 
1189 	// **************************************
1190 	// *****          INTERNAL          *****
1191 	// **************************************
1192 		/**
1193 		* @dev Internal function returning the number of tokens staked by `tokenOwner_`.
1194 		*/
1195 		function _balanceOfStaked( address tokenOwner_ ) internal view virtual returns ( uint256 ) {
1196 			if ( tokenOwner_ == address( 0 ) ) {
1197 				return 0;
1198 			}
1199 
1200 			uint256 _supplyMinted_ = _supplyMinted();
1201 			uint256 _count_ = 0;
1202 			for ( uint256 i; i < _supplyMinted_; i++ ) {
1203 				if ( _stakedOwners[ i ] == tokenOwner_ ) {
1204 					_count_++;
1205 				}
1206 			}
1207 			return _count_;
1208 		}
1209 
1210 		/**
1211 		* @dev Internal function that mints `qtyMinted_` tokens and stakes `qtyStaked_` of them to the count of `tokenOwner_`.
1212 		*/
1213 		function _mintAndStake( address tokenOwner_, uint256 qtyMinted_, uint256 qtyStaked_ ) internal {
1214 			uint256 _qtyNotStaked_;
1215 			uint256 _qtyStaked_ = qtyStaked_;
1216 			if ( qtyStaked_ > qtyMinted_ ) {
1217 				_qtyStaked_ = qtyMinted_;
1218 			}
1219 			else if ( qtyStaked_ < qtyMinted_ ) {
1220 				_qtyNotStaked_ = qtyMinted_ - qtyStaked_;
1221 			}
1222 			if ( _qtyStaked_ > 0 ) {
1223 				_mintInContract( tokenOwner_, _qtyStaked_ );
1224 			}
1225 			if ( _qtyNotStaked_ > 0 ) {
1226 				_mint( tokenOwner_, _qtyNotStaked_ );
1227 			}
1228 		}
1229 
1230 		/**
1231 		* @dev Internal function that mints `qtyStaked_` tokens and stakes them to the count of `tokenOwner_`.
1232 		*/
1233 		function _mintInContract( address tokenOwner_, uint256 qtyStaked_ ) internal {
1234 			uint256 _currentToken_ = _supplyMinted();
1235 			uint256 _lastToken_ = _currentToken_ + qtyStaked_ - 1;
1236 
1237 			while ( _currentToken_ <= _lastToken_ ) {
1238 				_stakedOwners[ _currentToken_ ] = tokenOwner_;
1239 				_currentToken_ ++;
1240 			}
1241 
1242 			_mint( address( this ), qtyStaked_ );
1243 		}
1244 
1245 		/**
1246 		* @dev Internal function returning the owner of the staked token number `tokenId_`.
1247 		*
1248 		* Requirements:
1249 		*
1250 		* - `tokenId_` must exist.
1251 		*/
1252 		function _ownerOfStaked( uint256 tokenId_ ) internal view virtual returns ( address ) {
1253 			return _stakedOwners[ tokenId_ ];
1254 		}
1255 
1256 		/**
1257 		* @dev Internal function that stakes the token number `tokenId_` to the count of `tokenOwner_`.
1258 		*/
1259 		function _stake( address tokenOwner_, uint256 tokenId_ ) internal {
1260 			_stakedOwners[ tokenId_ ] = tokenOwner_;
1261 			_transfer( tokenOwner_, address( this ), tokenId_ );
1262 		}
1263 
1264 		/**
1265 		* @dev Internal function that unstakes the token `tokenId_` and transfers it back to `tokenOwner_`.
1266 		*/
1267 		function _unstake( address tokenOwner_, uint256 tokenId_ ) internal {
1268 			_transfer( address( this ), tokenOwner_, tokenId_ );
1269 			delete _stakedOwners[ tokenId_ ];
1270 		}
1271 	// **************************************
1272 
1273 	// **************************************
1274 	// *****           PUBLIC           *****
1275 	// **************************************
1276 		/**
1277 		* @dev Stakes the token `tokenId_` to the count of its owner.
1278 		* 
1279 		* Requirements:
1280 		* 
1281 		* - Caller must be allowed to manage `tokenId_` or its owner's tokens.
1282 		* - `tokenId_` must exist.
1283 		*/
1284 		function stake( uint256 tokenId_ ) external exists( tokenId_ ) {
1285 			address _operator_ = _msgSender();
1286 			address _tokenOwner_ = _ownerOf( tokenId_ );
1287 			bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );
1288 
1289 			if ( ! _isApproved_ ) {
1290 				revert IERC721_CALLER_NOT_APPROVED();
1291 			}
1292 			_stake( _tokenOwner_, tokenId_ );
1293 		}
1294 
1295 		/**
1296 		* @dev Unstakes the token `tokenId_` and returns it to its owner.
1297 		* 
1298 		* Requirements:
1299 		* 
1300 		* - Caller must be allowed to manage `tokenId_` or its owner's tokens.
1301 		* - `tokenId_` must exist.
1302 		*/
1303 		function unstake( uint256 tokenId_ ) external exists( tokenId_ ) {
1304 			address _operator_ = _msgSender();
1305 			address _tokenOwner_ = _ownerOfStaked( tokenId_ );
1306 			bool _isApproved_ = _isApprovedOrOwner( _tokenOwner_, _operator_, tokenId_ );
1307 
1308 			if ( ! _isApproved_ ) {
1309 				revert IERC721_CALLER_NOT_APPROVED();
1310 			}
1311 			_unstake( _tokenOwner_, tokenId_ );
1312 		}
1313 	// **************************************
1314 
1315 	// **************************************
1316 	// *****            VIEW            *****
1317 	// **************************************
1318 		/**
1319 		* @dev Returns the number of tokens owned by `tokenOwner_`.
1320 		*/
1321 		function balanceOf( address tokenOwner_ ) public view virtual override returns ( uint256 balance ) {
1322 			return _balanceOfStaked( tokenOwner_ ) + _balanceOf( tokenOwner_ );
1323 		}
1324 
1325 		/**
1326 		* @dev Returns the number of tokens staked by `tokenOwner_`.
1327 		*/
1328 		function balanceOfStaked( address tokenOwner_ ) public view virtual returns ( uint256 ) {
1329 			return _balanceOfStaked( tokenOwner_ );
1330 		}
1331 
1332 		/**
1333 		* @dev Returns the owner of token number `tokenId_`.
1334 		*
1335 		* Requirements:
1336 		*
1337 		* - `tokenId_` must exist.
1338 		*/
1339 		function ownerOf( uint256 tokenId_ ) public view virtual override exists( tokenId_ ) returns ( address ) {
1340 			address _tokenOwner_ = _ownerOf( tokenId_ );
1341 			if ( _tokenOwner_ == address( this ) ) {
1342 				return _ownerOfStaked( tokenId_ );
1343 			}
1344 			return _tokenOwner_;
1345 		}
1346 
1347 		/**
1348 		* @dev Returns the owner of staked token number `tokenId_`.
1349 		*
1350 		* Requirements:
1351 		*
1352 		* - `tokenId_` must exist.
1353 		*/
1354 		function ownerOfStaked( uint256 tokenId_ ) public view virtual exists( tokenId_ ) returns ( address ) {
1355 			return _ownerOfStaked( tokenId_ );
1356 		}
1357 	// **************************************
1358 
1359 	// **************************************
1360 	// *****            PURE            *****
1361 	// **************************************
1362 		/**
1363 		* @dev Signals that this contract knows how to handle ERC721 tokens.
1364 		*/
1365 		function onERC721Received( address, address, uint256, bytes memory ) public override pure returns ( bytes4 ) {
1366 			return type( IERC721Receiver ).interfaceId;
1367 		}
1368 	// **************************************
1369 }
1370 
1371 // File: contracts/IERC721Enumerable.sol
1372 
1373 
1374 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1375 
1376 pragma solidity ^0.8.0;
1377 
1378 
1379 /**
1380  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1381  * @dev See https://eips.ethereum.org/EIPS/eip-721
1382  */
1383 interface IERC721Enumerable is IERC721 {
1384     /**
1385      * @dev Returns the total amount of tokens stored by the contract.
1386      */
1387     function totalSupply() external view returns (uint256);
1388 
1389     /**
1390      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1391      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1392      */
1393     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1394 
1395     /**
1396      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1397      * Use along with {totalSupply} to enumerate all tokens.
1398      */
1399     function tokenByIndex(uint256 index) external view returns (uint256);
1400 }
1401 
1402 // File: contracts/ERC721BatchEnumerable.sol
1403 
1404 
1405 
1406 /**
1407 * Author: Lambdalf the White
1408 */
1409 
1410 pragma solidity 0.8.10;
1411 
1412 
1413 
1414 /**
1415 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1416 * the Metadata extension and the Enumerable extension.
1417 * 
1418 * Note: This implementation is only compatible with a sequential order of tokens minted.
1419 * If you need to mint tokens in a random order, you will need to override the following functions:
1420 * Note also that this implementations is fairly inefficient and as such, 
1421 * those functions should be avoided inside non-view functions.
1422 */
1423 abstract contract ERC721BatchEnumerable is ERC721Batch, IERC721Enumerable {
1424 	// Errors
1425 	error IERC721Enumerable_OWNER_INDEX_OUT_OF_BOUNDS();
1426 	error IERC721Enumerable_INDEX_OUT_OF_BOUNDS();
1427 
1428 	/**
1429 	* @dev See {IERC165-supportsInterface}.
1430 	*/
1431 	function supportsInterface( bytes4 interfaceId_ ) public view virtual override(IERC165, ERC721Batch) returns ( bool ) {
1432 		return 
1433 			interfaceId_ == type( IERC721Enumerable ).interfaceId ||
1434 			super.supportsInterface( interfaceId_ );
1435 	}
1436 
1437 	/**
1438 	* @dev See {IERC721Enumerable-tokenByIndex}.
1439 	*/
1440 	function tokenByIndex( uint256 index_ ) public view virtual override returns ( uint256 ) {
1441 		if ( index_ >= _supplyMinted() ) {
1442 			revert IERC721Enumerable_INDEX_OUT_OF_BOUNDS();
1443 		}
1444 		return index_;
1445 	}
1446 
1447 	/**
1448 	* @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1449 	*/
1450 	function tokenOfOwnerByIndex( address tokenOwner_, uint256 index_ ) public view virtual override returns ( uint256 tokenId ) {
1451 		uint256 _supplyMinted_ = _supplyMinted();
1452 		if ( index_ >= _balanceOf( tokenOwner_ ) ) {
1453 			revert IERC721Enumerable_OWNER_INDEX_OUT_OF_BOUNDS();
1454 		}
1455 
1456 		uint256 _count_ = 0;
1457 		for ( uint256 i = 0; i < _supplyMinted_; i++ ) {
1458 			if ( _exists( i ) && tokenOwner_ == _ownerOf( i ) ) {
1459 				if ( index_ == _count_ ) {
1460 					return i;
1461 				}
1462 				_count_++;
1463 			}
1464 		}
1465 	}
1466 
1467 	/**
1468 	* @dev See {IERC721Enumerable-totalSupply}.
1469 	*/
1470 	function totalSupply() public view virtual override returns ( uint256 ) {
1471 		uint256 _supplyMinted_ = _supplyMinted();
1472 		uint256 _count_ = 0;
1473 		for ( uint256 i; i < _supplyMinted_; i++ ) {
1474 			if ( _exists( i ) ) {
1475 				_count_++;
1476 			}
1477 		}
1478 		return _count_;
1479 	}
1480 }
1481 
1482 // File: contracts/CCFoundersKeys.sol
1483 
1484 
1485 
1486 /**
1487 * Author: Lambdalf the White
1488 */
1489 
1490 pragma solidity 0.8.10;
1491 
1492 
1493 
1494 contract CCFoundersKeys is ERC721BatchEnumerable, ERC721BatchStakable, ERC2981Base, IOwnable, IPausable, ITradable, IWhitelistable {
1495 	// Events
1496 	event PaymentReleased( address indexed from, address[] indexed tos, uint256[] indexed amounts );
1497 
1498 	// Errors
1499 	error CCFoundersKeys_ARRAY_LENGTH_MISMATCH();
1500 	error CCFoundersKeys_FORBIDDEN();
1501 	error CCFoundersKeys_INCORRECT_PRICE();
1502 	error CCFoundersKeys_INSUFFICIENT_KEY_BALANCE();
1503 	error CCFoundersKeys_MAX_BATCH();
1504 	error CCFoundersKeys_MAX_RESERVE();
1505 	error CCFoundersKeys_MAX_SUPPLY();
1506 	error CCFoundersKeys_NO_ETHER_BALANCE();
1507 	error CCFoundersKeys_TRANSFER_FAIL();
1508 
1509 	// Founders Key whitelist mint price
1510 	uint public immutable WL_MINT_PRICE; // = 0.069 ether;
1511 
1512 	// Founders Key public mint price
1513 	uint public immutable PUBLIC_MINT_PRICE; // = 0.1 ether;
1514 
1515 	// Max supply
1516 	uint public immutable MAX_SUPPLY;
1517 
1518 	// Max TX
1519 	uint public immutable MAX_BATCH;
1520 
1521 	// 2C Safe wallet ~ 90%
1522 	address private immutable _CC_SAFE;
1523 
1524 	// 2C Operations wallet ~ 5%
1525 	address private immutable _CC_CHARITY;
1526 
1527 	// 2C Founders wallet ~ 2.5%
1528 	address private immutable _CC_FOUNDERS;
1529 
1530 	// 2C Community wallet ~ 2.5%
1531 	address private immutable _CC_COMMUNITY;
1532 
1533 	// Mapping of Anon holders to amount of free key claimable
1534 	mapping( address => uint256 ) public anonClaimList;
1535 
1536 	uint256 private _reserve;
1537 
1538 	constructor(
1539 		uint256 reserve_,
1540 		uint256 maxBatch_,
1541 		uint256 maxSupply_,
1542 		uint256 royaltyRate_,
1543 		uint256 wlMintPrice_,
1544 		uint256 publicMintPrice_,
1545 		string memory name_,
1546 		string memory symbol_,
1547 		string memory baseURI_,
1548 		// address devAddress_,
1549 		address[] memory wallets_
1550 	) {
1551 		address _contractOwner_ = _msgSender();
1552 		_initIOwnable( _contractOwner_ );
1553 		_initERC2981Base( _contractOwner_, royaltyRate_ );
1554 		_initERC721BatchMetadata( name_, symbol_ );
1555 		_setBaseURI( baseURI_ );
1556 		_CC_SAFE          = wallets_[ 0 ];
1557 		_CC_CHARITY       = wallets_[ 1 ];
1558 		_CC_FOUNDERS      = wallets_[ 2 ];
1559 		_CC_COMMUNITY     = wallets_[ 3 ];
1560 		_reserve          = reserve_;
1561 		MAX_BATCH         = maxBatch_;
1562 		MAX_SUPPLY        = maxSupply_;
1563 		WL_MINT_PRICE     = wlMintPrice_;
1564 		PUBLIC_MINT_PRICE = publicMintPrice_;
1565 		// _mintAndStake( devAddress_, 5 );
1566 	}
1567 
1568 	// **************************************
1569 	// *****          INTERNAL          *****
1570 	// **************************************
1571 		/**
1572 		* @dev Internal function returning whether `operator_` is allowed to manage tokens on behalf of `tokenOwner_`.
1573 		* 
1574 		* @param tokenOwner_ address that owns tokens
1575 		* @param operator_ address that tries to manage tokens
1576 		* 
1577 		* @return bool whether `operator_` is allowed to manage the token
1578 		*/
1579 		function _isApprovedForAll( address tokenOwner_, address operator_ ) internal view virtual override returns ( bool ) {
1580 			return _isRegisteredProxy( tokenOwner_, operator_ ) ||
1581 						 super._isApprovedForAll( tokenOwner_, operator_ );
1582 		}
1583 
1584 		/**
1585 		* @dev Replacement for Solidity's `transfer`: sends `amount_` wei to
1586 		* `recipient_`, forwarding all available gas and reverting on errors.
1587 		*
1588 		* https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1589 		* of certain opcodes, possibly making contracts go over the 2300 gas limit
1590 		* imposed by `transfer`, making them unable to receive funds via
1591 		* `transfer`. {sendValue} removes this limitation.
1592 		*
1593 		* https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1594 		*
1595 		* IMPORTANT: because control is transferred to `recipient`, care must be
1596 		* taken to not create reentrancy vulnerabilities. Consider using
1597 		* {ReentrancyGuard} or the
1598 		* https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1599 		*/
1600 		function _sendValue( address payable recipient_, uint256 amount_ ) internal {
1601 			if ( address( this ).balance < amount_ ) {
1602 				revert CCFoundersKeys_INCORRECT_PRICE();
1603 			}
1604 			( bool _success_, ) = recipient_.call{ value: amount_ }( "" );
1605 			if ( ! _success_ ) {
1606 				revert CCFoundersKeys_TRANSFER_FAIL();
1607 			}
1608 		}
1609 	// **************************************
1610 
1611 	// **************************************
1612 	// *****           PUBLIC           *****
1613 	// **************************************
1614 		/**
1615 		* @dev Mints `qty_` tokens and transfers them to the caller.
1616 		* 
1617 		* Requirements:
1618 		* 
1619 		* - Sale state must be {SaleState.PRESALE}.
1620 		* - There must be enough tokens left to mint outside of the reserve.
1621 		* - Caller must be whitelisted.
1622 		*/
1623 		function claim( uint256 qty_ ) external presaleOpen {
1624 			address _account_   = _msgSender();
1625 			if ( qty_ > anonClaimList[ _account_ ] ) {
1626 				revert CCFoundersKeys_FORBIDDEN();
1627 			}
1628 
1629 			uint256 _endSupply_ = _supplyMinted() + qty_;
1630 			if ( _endSupply_ > MAX_SUPPLY - _reserve ) {
1631 				revert CCFoundersKeys_MAX_SUPPLY();
1632 			}
1633 
1634 			unchecked {
1635 				anonClaimList[ _account_ ] -= qty_;
1636 			}
1637 			_mint( _account_, qty_ );
1638 		}
1639 
1640 		/**
1641 		* @dev Mints `qty_` tokens, stakes `qtyStaked_` of them to the count of the caller, and transfers the remaining to them.
1642 		* 
1643 		* Requirements:
1644 		* 
1645 		* - Sale state must be {SaleState.PRESALE}.
1646 		* - There must be enough tokens left to mint outside of the reserve.
1647 		* - Caller must be whitelisted.
1648 		* - If `qtyStaked_` is higher than `qty_`, only `qty_` tokens are staked.
1649 		*/
1650 		function claimAndStake( uint256 qty_, uint256 qtyStaked_ ) external presaleOpen {
1651 			address _account_   = _msgSender();
1652 			if ( qty_ > anonClaimList[ _account_ ] ) {
1653 				revert CCFoundersKeys_FORBIDDEN();
1654 			}
1655 
1656 			uint256 _endSupply_ = _supplyMinted() + qty_;
1657 			if ( _endSupply_ > MAX_SUPPLY - _reserve ) {
1658 				revert CCFoundersKeys_MAX_SUPPLY();
1659 			}
1660 
1661 			unchecked {
1662 				anonClaimList[ _account_ ] -= qty_;
1663 			}
1664 			_mintAndStake( _account_, qty_, qtyStaked_ );
1665 		}
1666 
1667 		/**
1668 		* @dev Mints a token and transfers it to the caller.
1669 		* 
1670 		* Requirements:
1671 		* 
1672 		* - Sale state must be {SaleState.PRESALE}.
1673 		* - There must be enough tokens left to mint outside of the reserve.
1674 		* - Caller must send enough ether to pay for 1 token at presale price.
1675 		* - Caller must be whitelisted.
1676 		*/
1677 		function mintPreSale( bytes32[] memory proof_ ) external payable presaleOpen isWhitelisted( _msgSender(), proof_, 1, 1 ) {
1678 			if ( _supplyMinted() + 1 > MAX_SUPPLY - _reserve ) {
1679 				revert CCFoundersKeys_MAX_SUPPLY();
1680 			}
1681 
1682 			if ( WL_MINT_PRICE != msg.value ) {
1683 				revert CCFoundersKeys_INCORRECT_PRICE();
1684 			}
1685 
1686 			address _account_    = _msgSender();
1687 			_consumeWhitelist( _account_, 1 );
1688 			_mint( _account_, 1 );
1689 		}
1690 
1691 		/**
1692 		* @dev Mints a token and stakes it to the count of the caller.
1693 		* 
1694 		* Requirements:
1695 		* 
1696 		* - Sale state must be {SaleState.PRESALE}.
1697 		* - There must be enough tokens left to mint outside of the reserve.
1698 		* - Caller must send enough ether to pay for 1 token at presale price.
1699 		* - Caller must be whitelisted.
1700 		*/
1701 		function mintPreSaleAndStake( bytes32[] memory proof_ ) external payable presaleOpen isWhitelisted( _msgSender(), proof_, 1, 1 ) {
1702 			if ( _supplyMinted() + 1 > MAX_SUPPLY - _reserve ) {
1703 				revert CCFoundersKeys_MAX_SUPPLY();
1704 			}
1705 
1706 			if ( WL_MINT_PRICE != msg.value ) {
1707 				revert CCFoundersKeys_INCORRECT_PRICE();
1708 			}
1709 
1710 			address _account_    = _msgSender();
1711 			_consumeWhitelist( _account_, 1 );
1712 			_mintAndStake( _account_, 1, 1 );
1713 		}
1714 
1715 		/**
1716 		* @dev Mints `qty_` tokens and transfers them to the caller.
1717 		* 
1718 		* Requirements:
1719 		* 
1720 		* - Sale state must be {SaleState.SALE}.
1721 		* - There must be enough tokens left to mint outside of the reserve.
1722 		* - Caller must send enough ether to pay for `qty_` tokens at public sale price.
1723 		*/
1724 		function mint( uint256 qty_ ) external payable saleOpen {
1725 			if ( qty_ > MAX_BATCH ) {
1726 				revert CCFoundersKeys_MAX_BATCH();
1727 			}
1728 
1729 			uint256 _endSupply_  = _supplyMinted() + qty_;
1730 			if ( _endSupply_ > MAX_SUPPLY - _reserve ) {
1731 				revert CCFoundersKeys_MAX_SUPPLY();
1732 			}
1733 
1734 			if ( qty_ * PUBLIC_MINT_PRICE != msg.value ) {
1735 				revert CCFoundersKeys_INCORRECT_PRICE();
1736 			}
1737 			address _account_    = _msgSender();
1738 			_mint( _account_, qty_ );
1739 		}
1740 
1741 		/**
1742 		* @dev Mints `qty_` tokens, stakes `qtyStaked_` of them to the count of the caller, and transfers the remaining to them.
1743 		* 
1744 		* Requirements:
1745 		* 
1746 		* - Sale state must be {SaleState.SALE}.
1747 		* - There must be enough tokens left to mint outside of the reserve.
1748 		* - Caller must send enough ether to pay for `qty_` tokens at public sale price.
1749 		* - If `qtyStaked_` is higher than `qty_`, only `qty_` tokens are staked.
1750 		*/
1751 		function mintAndStake( uint256 qty_, uint256 qtyStaked_ ) external payable saleOpen {
1752 			if ( qty_ > MAX_BATCH ) {
1753 				revert CCFoundersKeys_MAX_BATCH();
1754 			}
1755 
1756 			uint256 _endSupply_  = _supplyMinted() + qty_;
1757 			if ( _endSupply_ > MAX_SUPPLY - _reserve ) {
1758 				revert CCFoundersKeys_MAX_SUPPLY();
1759 			}
1760 
1761 			if ( qty_ * PUBLIC_MINT_PRICE != msg.value ) {
1762 				revert CCFoundersKeys_INCORRECT_PRICE();
1763 			}
1764 			address _account_    = _msgSender();
1765 			_mintAndStake( _account_, qty_, qtyStaked_ );
1766 		}
1767 	// **************************************
1768 
1769 	// **************************************
1770 	// *****       CONTRACT_OWNER       *****
1771 	// **************************************
1772 		/**
1773 		* @dev Mints `amounts_` tokens and transfers them to `accounts_`.
1774 		* 
1775 		* Requirements:
1776 		* 
1777 		* - Caller must be the contract owner.
1778 		* - `accounts_` and `amounts_` must have the same length.
1779 		* - There must be enough tokens left in the reserve.
1780 		*/
1781 		function airdrop( address[] memory accounts_, uint256[] memory amounts_ ) external onlyOwner {
1782 			uint256 _len_ = amounts_.length;
1783 			if ( _len_ != accounts_.length ) {
1784 				revert CCFoundersKeys_ARRAY_LENGTH_MISMATCH();
1785 			}
1786 			uint _totalQty_;
1787 			for ( uint256 i = _len_; i > 0; i -- ) {
1788 				_totalQty_ += amounts_[ i - 1 ];
1789 			}
1790 			if ( _totalQty_ > _reserve ) {
1791 				revert CCFoundersKeys_MAX_RESERVE();
1792 			}
1793 			unchecked {
1794 				_reserve -= _totalQty_;
1795 			}
1796 			for ( uint256 i = _len_; i > 0; i -- ) {
1797 				_mint( accounts_[ i - 1], amounts_[ i - 1] );
1798 			}
1799 		}
1800 
1801 		/**
1802 		* @dev Saves `accounts_` in the anon claim list.
1803 		* 
1804 		* Requirements:
1805 		* 
1806 		* - Caller must be the contract owner.
1807 		* - Sale state must be {SaleState.CLOSED}.
1808 		* - `accounts_` and `amounts_` must have the same length.
1809 		*/
1810 		function setAnonClaimList( address[] memory accounts_, uint256[] memory amounts_ ) external onlyOwner saleClosed {
1811 			uint256 _len_ = amounts_.length;
1812 			if ( _len_ != accounts_.length ) {
1813 				revert CCFoundersKeys_ARRAY_LENGTH_MISMATCH();
1814 			}
1815 			for ( uint256 i; i < _len_; i ++ ) {
1816 				anonClaimList[ accounts_[ i ] ] = amounts_[ i ];
1817 			}
1818 		}
1819 
1820 		/**
1821 		* @dev See {ITradable-setProxyRegistry}.
1822 		* 
1823 		* Requirements:
1824 		* 
1825 		* - Caller must be the contract owner.
1826 		*/
1827 		function setProxyRegistry( address proxyRegistryAddress_ ) external onlyOwner {
1828 			_setProxyRegistry( proxyRegistryAddress_ );
1829 		}
1830 
1831 		/**
1832 		* @dev Updates the royalty recipient and rate.
1833 		* 
1834 		* Requirements:
1835 		* 
1836 		* - Caller must be the contract owner.
1837 		*/
1838 		function setRoyaltyInfo( address royaltyRecipient_, uint256 royaltyRate_ ) external onlyOwner {
1839 			_setRoyaltyInfo( royaltyRecipient_, royaltyRate_ );
1840 		}
1841 
1842 		/**
1843 		* @dev See {IPausable-setSaleState}.
1844 		* 
1845 		* Requirements:
1846 		* 
1847 		* - Caller must be the contract owner.
1848 		*/
1849 		function setSaleState( SaleState newState_ ) external onlyOwner {
1850 			_setSaleState( newState_ );
1851 		}
1852 
1853 		/**
1854 		* @dev See {IWhitelistable-setWhitelist}.
1855 		* 
1856 		* Requirements:
1857 		* 
1858 		* - Caller must be the contract owner.
1859 		* - Sale state must be {SaleState.CLOSED}.
1860 		*/
1861 		function setWhitelist( bytes32 root_ ) external onlyOwner saleClosed {
1862 			_setWhitelist( root_ );
1863 		}
1864 
1865 		/**
1866 		* @dev Withdraws all the money stored in the contract and splits it amongst the set wallets.
1867 		* 
1868 		* Requirements:
1869 		* 
1870 		* - Caller must be the contract owner.
1871 		*/
1872 		function withdraw() external onlyOwner {
1873 			uint256 _balance_ = address(this).balance;
1874 			if ( _balance_ == 0 ) {
1875 				revert CCFoundersKeys_NO_ETHER_BALANCE();
1876 			}
1877 
1878 			uint256 _safeShare_ = _balance_ * 900 / 1000;
1879 			uint256 _charityShare_ = _balance_ * 50 / 1000;
1880 			uint256 _othersShare_ = _charityShare_ / 2;
1881 			_sendValue( payable( _CC_COMMUNITY ), _othersShare_ );
1882 			_sendValue( payable( _CC_FOUNDERS ), _othersShare_ );
1883 			_sendValue( payable( _CC_CHARITY ), _charityShare_ );
1884 			_sendValue( payable( _CC_SAFE ), _safeShare_ );
1885 
1886 			address[] memory _tos_ = new address[]( 4 );
1887 			_tos_[ 0 ] = _CC_COMMUNITY;
1888 			_tos_[ 1 ] = _CC_FOUNDERS;
1889 			_tos_[ 2 ] = _CC_CHARITY;
1890 			_tos_[ 3 ] = _CC_SAFE;
1891 			uint256[] memory _amounts_ = new uint256[]( 4 );
1892 			_amounts_[ 0 ] = _othersShare_;
1893 			_amounts_[ 1 ] = _othersShare_;
1894 			_amounts_[ 2 ] = _charityShare_;
1895 			_amounts_[ 3 ] = _safeShare_;
1896 			emit PaymentReleased( address( this ), _tos_, _amounts_ );
1897 		}
1898 	// **************************************
1899 
1900 	// **************************************
1901 	// *****            VIEW            *****
1902 	// **************************************
1903 		/**
1904 		* @dev Returns the number of tokens owned by `tokenOwner_`.
1905 		*/
1906 		function balanceOf( address tokenOwner_ ) public view virtual override(ERC721Batch, ERC721BatchStakable) returns ( uint256 balance ) {
1907 			return ERC721BatchStakable.balanceOf( tokenOwner_ );
1908 		}
1909 
1910 		/**
1911 		* @dev Returns the owner of token number `tokenId_`.
1912 		*
1913 		* Requirements:
1914 		*
1915 		* - `tokenId_` must exist.
1916 		*/
1917 		function ownerOf( uint256 tokenId_ ) public view virtual override(ERC721Batch, ERC721BatchStakable) exists( tokenId_ ) returns ( address ) {
1918 			return ERC721BatchStakable.ownerOf( tokenId_ );
1919 		}
1920 
1921 		/**
1922 		* @dev See {IERC2981-royaltyInfo}.
1923 		*
1924 		* Requirements:
1925 		*
1926 		* - `tokenId_` must exist.
1927 		*/
1928 		function royaltyInfo( uint256 tokenId_, uint256 salePrice_ ) public view virtual override exists( tokenId_ ) returns ( address, uint256 ) {
1929 			return super.royaltyInfo( tokenId_, salePrice_ );
1930 		}
1931 
1932 		/**
1933 		* @dev See {IERC165-supportsInterface}.
1934 		*/
1935 		function supportsInterface( bytes4 interfaceId_ ) public view virtual override(ERC721BatchEnumerable, ERC721Batch, ERC2981Base) returns ( bool ) {
1936 			return 
1937 				interfaceId_ == type( IERC2981 ).interfaceId ||
1938 				ERC721Batch.supportsInterface( interfaceId_ ) ||
1939 				ERC721BatchEnumerable.supportsInterface( interfaceId_ );
1940 		}
1941 	// **************************************
1942 }