1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(
94             newOwner != address(0),
95             "Ownable: new owner is the zero address"
96         );
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Interface of the ERC165 standard, as defined in the
119  * https://eips.ethereum.org/EIPS/eip-165[EIP].
120  *
121  * Implementers can declare support of contract interfaces, which can then be
122  * queried by others ({ERC165Checker}).
123  *
124  * For an implementation, see {ERC165}.
125  */
126 interface IERC165 {
127     /**
128      * @dev Returns true if this contract implements the interface defined by
129      * `interfaceId`. See the corresponding
130      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
131      * to learn more about how these ids are created.
132      *
133      * This function call must use less than 30 000 gas.
134      */
135     function supportsInterface(bytes4 interfaceId) external view returns (bool);
136 }
137 
138 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.6.0
139 
140 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Interface for the NFT Royalty Standard.
146  *
147  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
148  * support for royalty payments across all NFT marketplaces and ecosystem participants.
149  *
150  * _Available since v4.5._
151  */
152 interface IERC2981 is IERC165 {
153     /**
154      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
155      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
156      */
157     function royaltyInfo(uint256 tokenId, uint256 salePrice)
158         external
159         view
160         returns (address receiver, uint256 royaltyAmount);
161 }
162 
163 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Implementation of the {IERC165} interface.
171  *
172  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
173  * for the additional interface id that will be supported. For example:
174  *
175  * ```solidity
176  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
177  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
178  * }
179  * ```
180  *
181  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
182  */
183 abstract contract ERC165 is IERC165 {
184     /**
185      * @dev See {IERC165-supportsInterface}.
186      */
187     function supportsInterface(bytes4 interfaceId)
188         public
189         view
190         virtual
191         override
192         returns (bool)
193     {
194         return interfaceId == type(IERC165).interfaceId;
195     }
196 }
197 
198 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.6.0
199 
200 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
206  *
207  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
208  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
209  *
210  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
211  * fee is specified in basis points by default.
212  *
213  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
214  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
215  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
216  *
217  * _Available since v4.5._
218  */
219 abstract contract ERC2981 is IERC2981, ERC165 {
220     struct RoyaltyInfo {
221         address receiver;
222         uint96 royaltyFraction;
223     }
224 
225     RoyaltyInfo private _defaultRoyaltyInfo;
226     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
227 
228     /**
229      * @dev See {IERC165-supportsInterface}.
230      */
231     function supportsInterface(bytes4 interfaceId)
232         public
233         view
234         virtual
235         override(IERC165, ERC165)
236         returns (bool)
237     {
238         return
239             interfaceId == type(IERC2981).interfaceId ||
240             super.supportsInterface(interfaceId);
241     }
242 
243     /**
244      * @inheritdoc IERC2981
245      */
246     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
247         public
248         view
249         virtual
250         override
251         returns (address, uint256)
252     {
253         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
254 
255         if (royalty.receiver == address(0)) {
256             royalty = _defaultRoyaltyInfo;
257         }
258 
259         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
260             _feeDenominator();
261 
262         return (royalty.receiver, royaltyAmount);
263     }
264 
265     /**
266      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
267      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
268      * override.
269      */
270     function _feeDenominator() internal pure virtual returns (uint96) {
271         return 10000;
272     }
273 
274     /**
275      * @dev Sets the royalty information that all ids in this contract will default to.
276      *
277      * Requirements:
278      *
279      * - `receiver` cannot be the zero address.
280      * - `feeNumerator` cannot be greater than the fee denominator.
281      */
282     function _setDefaultRoyalty(address receiver, uint96 feeNumerator)
283         internal
284         virtual
285     {
286         require(
287             feeNumerator <= _feeDenominator(),
288             "ERC2981: royalty fee will exceed salePrice"
289         );
290         require(receiver != address(0), "ERC2981: invalid receiver");
291 
292         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
293     }
294 
295     /**
296      * @dev Removes default royalty information.
297      */
298     function _deleteDefaultRoyalty() internal virtual {
299         delete _defaultRoyaltyInfo;
300     }
301 
302     /**
303      * @dev Sets the royalty information for a specific token id, overriding the global default.
304      *
305      * Requirements:
306      *
307      * - `tokenId` must be already minted.
308      * - `receiver` cannot be the zero address.
309      * - `feeNumerator` cannot be greater than the fee denominator.
310      */
311     function _setTokenRoyalty(
312         uint256 tokenId,
313         address receiver,
314         uint96 feeNumerator
315     ) internal virtual {
316         require(
317             feeNumerator <= _feeDenominator(),
318             "ERC2981: royalty fee will exceed salePrice"
319         );
320         require(receiver != address(0), "ERC2981: Invalid parameters");
321 
322         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
323     }
324 
325     /**
326      * @dev Resets royalty information for the token id back to the global default.
327      */
328     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
329         delete _tokenRoyaltyInfo[tokenId];
330     }
331 }
332 
333 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
334 
335 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Required interface of an ERC721 compliant contract.
341  */
342 interface IERC721 is IERC165 {
343     /**
344      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
345      */
346     event Transfer(
347         address indexed from,
348         address indexed to,
349         uint256 indexed tokenId
350     );
351 
352     /**
353      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
354      */
355     event Approval(
356         address indexed owner,
357         address indexed approved,
358         uint256 indexed tokenId
359     );
360 
361     /**
362      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
363      */
364     event ApprovalForAll(
365         address indexed owner,
366         address indexed operator,
367         bool approved
368     );
369 
370     /**
371      * @dev Returns the number of tokens in ``owner``'s account.
372      */
373     function balanceOf(address owner) external view returns (uint256 balance);
374 
375     /**
376      * @dev Returns the owner of the `tokenId` token.
377      *
378      * Requirements:
379      *
380      * - `tokenId` must exist.
381      */
382     function ownerOf(uint256 tokenId) external view returns (address owner);
383 
384     /**
385      * @dev Safely transfers `tokenId` token from `from` to `to`.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
394      *
395      * Emits a {Transfer} event.
396      */
397     function safeTransferFrom(
398         address from,
399         address to,
400         uint256 tokenId,
401         bytes calldata data
402     ) external;
403 
404     /**
405      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
406      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must exist and be owned by `from`.
413      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
414      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
415      *
416      * Emits a {Transfer} event.
417      */
418     function safeTransferFrom(
419         address from,
420         address to,
421         uint256 tokenId
422     ) external;
423 
424     /**
425      * @dev Transfers `tokenId` token from `from` to `to`.
426      *
427      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
446      * The approval is cleared when the token is transferred.
447      *
448      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
449      *
450      * Requirements:
451      *
452      * - The caller must own the token or be an approved operator.
453      * - `tokenId` must exist.
454      *
455      * Emits an {Approval} event.
456      */
457     function approve(address to, uint256 tokenId) external;
458 
459     /**
460      * @dev Approve or remove `operator` as an operator for the caller.
461      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
462      *
463      * Requirements:
464      *
465      * - The `operator` cannot be the caller.
466      *
467      * Emits an {ApprovalForAll} event.
468      */
469     function setApprovalForAll(address operator, bool _approved) external;
470 
471     /**
472      * @dev Returns the account approved for `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function getApproved(uint256 tokenId)
479         external
480         view
481         returns (address operator);
482 
483     /**
484      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
485      *
486      * See {setApprovalForAll}
487      */
488     function isApprovedForAll(address owner, address operator)
489         external
490         view
491         returns (bool);
492 }
493 
494 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
502  * @dev See https://eips.ethereum.org/EIPS/eip-721
503  */
504 interface IERC721Metadata is IERC721 {
505     /**
506      * @dev Returns the token collection name.
507      */
508     function name() external view returns (string memory);
509 
510     /**
511      * @dev Returns the token collection symbol.
512      */
513     function symbol() external view returns (string memory);
514 
515     /**
516      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
517      */
518     function tokenURI(uint256 tokenId) external view returns (string memory);
519 }
520 
521 // File contracts/interfaces/IERC721A.sol
522 
523 // ERC721A Contracts v3.3.0
524 // Creator: Chiru Labs
525 
526 pragma solidity ^0.8.4;
527 
528 /**
529  * @dev Interface of an ERC721A compliant contract.
530  */
531 interface IERC721A is IERC721, IERC721Metadata {
532     /**
533      * The caller must own the token or be an approved operator.
534      */
535     error ApprovalCallerNotOwnerNorApproved();
536 
537     /**
538      * The token does not exist.
539      */
540     error ApprovalQueryForNonexistentToken();
541 
542     /**
543      * The caller cannot approve to their own address.
544      */
545     error ApproveToCaller();
546 
547     /**
548      * The caller cannot approve to the current owner.
549      */
550     error ApprovalToCurrentOwner();
551 
552     /**
553      * Cannot query the balance for the zero address.
554      */
555     error BalanceQueryForZeroAddress();
556 
557     /**
558      * Cannot mint to the zero address.
559      */
560     error MintToZeroAddress();
561 
562     /**
563      * The quantity of tokens minted must be more than zero.
564      */
565     error MintZeroQuantity();
566 
567     /**
568      * The token does not exist.
569      */
570     error OwnerQueryForNonexistentToken();
571 
572     /**
573      * The caller must own the token or be an approved operator.
574      */
575     error TransferCallerNotOwnerNorApproved();
576 
577     /**
578      * The token must be owned by `from`.
579      */
580     error TransferFromIncorrectOwner();
581 
582     /**
583      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
584      */
585     error TransferToNonERC721ReceiverImplementer();
586 
587     /**
588      * Cannot transfer to the zero address.
589      */
590     error TransferToZeroAddress();
591 
592     /**
593      * The token does not exist.
594      */
595     error URIQueryForNonexistentToken();
596 
597     // Compiler will pack this into a single 256bit word.
598     struct TokenOwnership {
599         // The address of the owner.
600         address addr;
601         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
602         uint64 startTimestamp;
603         // Whether the token has been burned.
604         bool burned;
605     }
606 
607     // Compiler will pack this into a single 256bit word.
608     struct AddressData {
609         // Realistically, 2**64-1 is more than enough.
610         uint64 balance;
611         // Keeps track of mint count with minimal overhead for tokenomics.
612         uint64 numberMinted;
613         // Keeps track of burn count with minimal overhead for tokenomics.
614         uint64 numberBurned;
615         // For miscellaneous variable(s) pertaining to the address
616         // (e.g. number of whitelist mint slots used).
617         // If there are multiple variables, please pack them into a uint64.
618         uint64 aux;
619     }
620 
621     /**
622      * @dev Returns the total amount of tokens stored by the contract.
623      *
624      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
625      */
626     function totalSupply() external view returns (uint256);
627 }
628 
629 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
630 
631 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 /**
636  * @title ERC721 token receiver interface
637  * @dev Interface for any contract that wants to support safeTransfers
638  * from ERC721 asset contracts.
639  */
640 interface IERC721Receiver {
641     /**
642      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
643      * by `operator` from `from`, this function is called.
644      *
645      * It must return its Solidity selector to confirm the token transfer.
646      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
647      *
648      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
649      */
650     function onERC721Received(
651         address operator,
652         address from,
653         uint256 tokenId,
654         bytes calldata data
655     ) external returns (bytes4);
656 }
657 
658 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
659 
660 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
661 
662 pragma solidity ^0.8.1;
663 
664 /**
665  * @dev Collection of functions related to the address type
666  */
667 library Address {
668     /**
669      * @dev Returns true if `account` is a contract.
670      *
671      * [IMPORTANT]
672      * ====
673      * It is unsafe to assume that an address for which this function returns
674      * false is an externally-owned account (EOA) and not a contract.
675      *
676      * Among others, `isContract` will return false for the following
677      * types of addresses:
678      *
679      *  - an externally-owned account
680      *  - a contract in construction
681      *  - an address where a contract will be created
682      *  - an address where a contract lived, but was destroyed
683      * ====
684      *
685      * [IMPORTANT]
686      * ====
687      * You shouldn't rely on `isContract` to protect against flash loan attacks!
688      *
689      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
690      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
691      * constructor.
692      * ====
693      */
694     function isContract(address account) internal view returns (bool) {
695         // This method relies on extcodesize/address.code.length, which returns 0
696         // for contracts in construction, since the code is only stored at the end
697         // of the constructor execution.
698 
699         return account.code.length > 0;
700     }
701 
702     /**
703      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
704      * `recipient`, forwarding all available gas and reverting on errors.
705      *
706      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
707      * of certain opcodes, possibly making contracts go over the 2300 gas limit
708      * imposed by `transfer`, making them unable to receive funds via
709      * `transfer`. {sendValue} removes this limitation.
710      *
711      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
712      *
713      * IMPORTANT: because control is transferred to `recipient`, care must be
714      * taken to not create reentrancy vulnerabilities. Consider using
715      * {ReentrancyGuard} or the
716      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
717      */
718     function sendValue(address payable recipient, uint256 amount) internal {
719         require(
720             address(this).balance >= amount,
721             "Address: insufficient balance"
722         );
723 
724         (bool success, ) = recipient.call{value: amount}("");
725         require(
726             success,
727             "Address: unable to send value, recipient may have reverted"
728         );
729     }
730 
731     /**
732      * @dev Performs a Solidity function call using a low level `call`. A
733      * plain `call` is an unsafe replacement for a function call: use this
734      * function instead.
735      *
736      * If `target` reverts with a revert reason, it is bubbled up by this
737      * function (like regular Solidity function calls).
738      *
739      * Returns the raw returned data. To convert to the expected return value,
740      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
741      *
742      * Requirements:
743      *
744      * - `target` must be a contract.
745      * - calling `target` with `data` must not revert.
746      *
747      * _Available since v3.1._
748      */
749     function functionCall(address target, bytes memory data)
750         internal
751         returns (bytes memory)
752     {
753         return functionCall(target, data, "Address: low-level call failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
758      * `errorMessage` as a fallback revert reason when `target` reverts.
759      *
760      * _Available since v3.1._
761      */
762     function functionCall(
763         address target,
764         bytes memory data,
765         string memory errorMessage
766     ) internal returns (bytes memory) {
767         return functionCallWithValue(target, data, 0, errorMessage);
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
772      * but also transferring `value` wei to `target`.
773      *
774      * Requirements:
775      *
776      * - the calling contract must have an ETH balance of at least `value`.
777      * - the called Solidity function must be `payable`.
778      *
779      * _Available since v3.1._
780      */
781     function functionCallWithValue(
782         address target,
783         bytes memory data,
784         uint256 value
785     ) internal returns (bytes memory) {
786         return
787             functionCallWithValue(
788                 target,
789                 data,
790                 value,
791                 "Address: low-level call with value failed"
792             );
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
797      * with `errorMessage` as a fallback revert reason when `target` reverts.
798      *
799      * _Available since v3.1._
800      */
801     function functionCallWithValue(
802         address target,
803         bytes memory data,
804         uint256 value,
805         string memory errorMessage
806     ) internal returns (bytes memory) {
807         require(
808             address(this).balance >= value,
809             "Address: insufficient balance for call"
810         );
811         require(isContract(target), "Address: call to non-contract");
812 
813         (bool success, bytes memory returndata) = target.call{value: value}(
814             data
815         );
816         return verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but performing a static call.
822      *
823      * _Available since v3.3._
824      */
825     function functionStaticCall(address target, bytes memory data)
826         internal
827         view
828         returns (bytes memory)
829     {
830         return
831             functionStaticCall(
832                 target,
833                 data,
834                 "Address: low-level static call failed"
835             );
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
840      * but performing a static call.
841      *
842      * _Available since v3.3._
843      */
844     function functionStaticCall(
845         address target,
846         bytes memory data,
847         string memory errorMessage
848     ) internal view returns (bytes memory) {
849         require(isContract(target), "Address: static call to non-contract");
850 
851         (bool success, bytes memory returndata) = target.staticcall(data);
852         return verifyCallResult(success, returndata, errorMessage);
853     }
854 
855     /**
856      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
857      * but performing a delegate call.
858      *
859      * _Available since v3.4._
860      */
861     function functionDelegateCall(address target, bytes memory data)
862         internal
863         returns (bytes memory)
864     {
865         return
866             functionDelegateCall(
867                 target,
868                 data,
869                 "Address: low-level delegate call failed"
870             );
871     }
872 
873     /**
874      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
875      * but performing a delegate call.
876      *
877      * _Available since v3.4._
878      */
879     function functionDelegateCall(
880         address target,
881         bytes memory data,
882         string memory errorMessage
883     ) internal returns (bytes memory) {
884         require(isContract(target), "Address: delegate call to non-contract");
885 
886         (bool success, bytes memory returndata) = target.delegatecall(data);
887         return verifyCallResult(success, returndata, errorMessage);
888     }
889 
890     /**
891      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
892      * revert reason using the provided one.
893      *
894      * _Available since v4.3._
895      */
896     function verifyCallResult(
897         bool success,
898         bytes memory returndata,
899         string memory errorMessage
900     ) internal pure returns (bytes memory) {
901         if (success) {
902             return returndata;
903         } else {
904             // Look for revert reason and bubble it up if present
905             if (returndata.length > 0) {
906                 // The easiest way to bubble the revert reason is using memory via assembly
907 
908                 assembly {
909                     let returndata_size := mload(returndata)
910                     revert(add(32, returndata), returndata_size)
911                 }
912             } else {
913                 revert(errorMessage);
914             }
915         }
916     }
917 }
918 
919 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @dev String operations.
927  */
928 library Strings {
929     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
930 
931     /**
932      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
933      */
934     function toString(uint256 value) internal pure returns (string memory) {
935         // Inspired by OraclizeAPI's implementation - MIT licence
936         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
937 
938         if (value == 0) {
939             return "0";
940         }
941         uint256 temp = value;
942         uint256 digits;
943         while (temp != 0) {
944             digits++;
945             temp /= 10;
946         }
947         bytes memory buffer = new bytes(digits);
948         while (value != 0) {
949             digits -= 1;
950             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
951             value /= 10;
952         }
953         return string(buffer);
954     }
955 
956     /**
957      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
958      */
959     function toHexString(uint256 value) internal pure returns (string memory) {
960         if (value == 0) {
961             return "0x00";
962         }
963         uint256 temp = value;
964         uint256 length = 0;
965         while (temp != 0) {
966             length++;
967             temp >>= 8;
968         }
969         return toHexString(value, length);
970     }
971 
972     /**
973      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
974      */
975     function toHexString(uint256 value, uint256 length)
976         internal
977         pure
978         returns (string memory)
979     {
980         bytes memory buffer = new bytes(2 * length + 2);
981         buffer[0] = "0";
982         buffer[1] = "x";
983         for (uint256 i = 2 * length + 1; i > 1; --i) {
984             buffer[i] = _HEX_SYMBOLS[value & 0xf];
985             value >>= 4;
986         }
987         require(value == 0, "Strings: hex length insufficient");
988         return string(buffer);
989     }
990 }
991 
992 // File contracts/ERC721A.sol
993 
994 // ERC721A Contracts v3.3.0
995 // Creator: Chiru Labs
996 
997 pragma solidity ^0.8.4;
998 
999 /**
1000  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1001  * the Metadata extension. Built to optimize for lower gas during batch mints.
1002  *
1003  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1004  *
1005  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1006  *
1007  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1008  */
1009 contract ERC721A is Context, ERC165, IERC721A {
1010     using Address for address;
1011     using Strings for uint256;
1012 
1013     // The tokenId of the next token to be minted.
1014     uint256 internal _currentIndex;
1015 
1016     // The number of tokens burned.
1017     uint256 internal _burnCounter;
1018 
1019     // Token name
1020     string private _name;
1021 
1022     // Token symbol
1023     string private _symbol;
1024 
1025     // Mapping from token ID to ownership details
1026     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1027     mapping(uint256 => TokenOwnership) internal _ownerships;
1028 
1029     // Mapping owner address to address data
1030     mapping(address => AddressData) private _addressData;
1031 
1032     // Mapping from token ID to approved address
1033     mapping(uint256 => address) private _tokenApprovals;
1034 
1035     // Mapping from owner to operator approvals
1036     mapping(address => mapping(address => bool)) private _operatorApprovals;
1037 
1038     constructor(string memory name_, string memory symbol_) {
1039         _name = name_;
1040         _symbol = symbol_;
1041         _currentIndex = _startTokenId();
1042     }
1043 
1044     /**
1045      * To change the starting tokenId, please override this function.
1046      */
1047     function _startTokenId() internal view virtual returns (uint256) {
1048         return 0;
1049     }
1050 
1051     /**
1052      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1053      */
1054     function totalSupply() public view override returns (uint256) {
1055         // Counter underflow is impossible as _burnCounter cannot be incremented
1056         // more than _currentIndex - _startTokenId() times
1057         unchecked {
1058             return _currentIndex - _burnCounter - _startTokenId();
1059         }
1060     }
1061 
1062     /**
1063      * Returns the total amount of tokens minted in the contract.
1064      */
1065     function _totalMinted() internal view returns (uint256) {
1066         // Counter underflow is impossible as _currentIndex does not decrement,
1067         // and it is initialized to _startTokenId()
1068         unchecked {
1069             return _currentIndex - _startTokenId();
1070         }
1071     }
1072 
1073     /**
1074      * @dev See {IERC165-supportsInterface}.
1075      */
1076     function supportsInterface(bytes4 interfaceId)
1077         public
1078         view
1079         virtual
1080         override(ERC165, IERC165)
1081         returns (bool)
1082     {
1083         return
1084             interfaceId == type(IERC721).interfaceId ||
1085             interfaceId == type(IERC721Metadata).interfaceId ||
1086             super.supportsInterface(interfaceId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-balanceOf}.
1091      */
1092     function balanceOf(address owner) public view override returns (uint256) {
1093         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1094         return uint256(_addressData[owner].balance);
1095     }
1096 
1097     /**
1098      * Returns the number of tokens minted by `owner`.
1099      */
1100     function _numberMinted(address owner) internal view returns (uint256) {
1101         return uint256(_addressData[owner].numberMinted);
1102     }
1103 
1104     /**
1105      * Returns the number of tokens burned by or on behalf of `owner`.
1106      */
1107     function _numberBurned(address owner) internal view returns (uint256) {
1108         return uint256(_addressData[owner].numberBurned);
1109     }
1110 
1111     /**
1112      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1113      */
1114     function _getAux(address owner) internal view returns (uint64) {
1115         return _addressData[owner].aux;
1116     }
1117 
1118     /**
1119      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1120      * If there are multiple variables, please pack them into a uint64.
1121      */
1122     function _setAux(address owner, uint64 aux) internal {
1123         _addressData[owner].aux = aux;
1124     }
1125 
1126     /**
1127      * Gas spent here starts off proportional to the maximum mint batch size.
1128      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1129      */
1130     function _ownershipOf(uint256 tokenId)
1131         internal
1132         view
1133         returns (TokenOwnership memory)
1134     {
1135         uint256 curr = tokenId;
1136 
1137         unchecked {
1138             if (_startTokenId() <= curr)
1139                 if (curr < _currentIndex) {
1140                     TokenOwnership memory ownership = _ownerships[curr];
1141                     if (!ownership.burned) {
1142                         if (ownership.addr != address(0)) {
1143                             return ownership;
1144                         }
1145                         // Invariant:
1146                         // There will always be an ownership that has an address and is not burned
1147                         // before an ownership that does not have an address and is not burned.
1148                         // Hence, curr will not underflow.
1149                         while (true) {
1150                             curr--;
1151                             ownership = _ownerships[curr];
1152                             if (ownership.addr != address(0)) {
1153                                 return ownership;
1154                             }
1155                         }
1156                     }
1157                 }
1158         }
1159         revert OwnerQueryForNonexistentToken();
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-ownerOf}.
1164      */
1165     function ownerOf(uint256 tokenId) public view override returns (address) {
1166         return _ownershipOf(tokenId).addr;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Metadata-name}.
1171      */
1172     function name() public view virtual override returns (string memory) {
1173         return _name;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Metadata-symbol}.
1178      */
1179     function symbol() public view virtual override returns (string memory) {
1180         return _symbol;
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Metadata-tokenURI}.
1185      */
1186     function tokenURI(uint256 tokenId)
1187         public
1188         view
1189         virtual
1190         override
1191         returns (string memory)
1192     {
1193         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1194 
1195         string memory baseURI = _baseURI();
1196         return
1197             bytes(baseURI).length != 0
1198                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1199                 : "";
1200     }
1201 
1202     /**
1203      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1204      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1205      * by default, can be overriden in child contracts.
1206      */
1207     function _baseURI() internal view virtual returns (string memory) {
1208         return "";
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-approve}.
1213      */
1214     function approve(address to, uint256 tokenId) public override {
1215         address owner = ERC721A.ownerOf(tokenId);
1216         if (to == owner) revert ApprovalToCurrentOwner();
1217 
1218         if (_msgSender() != owner)
1219             if (!isApprovedForAll(owner, _msgSender())) {
1220                 revert ApprovalCallerNotOwnerNorApproved();
1221             }
1222 
1223         _approve(to, tokenId, owner);
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-getApproved}.
1228      */
1229     function getApproved(uint256 tokenId)
1230         public
1231         view
1232         override
1233         returns (address)
1234     {
1235         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1236 
1237         return _tokenApprovals[tokenId];
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-setApprovalForAll}.
1242      */
1243     function setApprovalForAll(address operator, bool approved)
1244         public
1245         virtual
1246         override
1247     {
1248         if (operator == _msgSender()) revert ApproveToCaller();
1249 
1250         _operatorApprovals[_msgSender()][operator] = approved;
1251         emit ApprovalForAll(_msgSender(), operator, approved);
1252     }
1253 
1254     /**
1255      * @dev See {IERC721-isApprovedForAll}.
1256      */
1257     function isApprovedForAll(address owner, address operator)
1258         public
1259         view
1260         virtual
1261         override
1262         returns (bool)
1263     {
1264         return _operatorApprovals[owner][operator];
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-transferFrom}.
1269      */
1270     function transferFrom(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) public virtual override {
1275         _transfer(from, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-safeTransferFrom}.
1280      */
1281     function safeTransferFrom(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) public virtual override {
1286         safeTransferFrom(from, to, tokenId, "");
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-safeTransferFrom}.
1291      */
1292     function safeTransferFrom(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory _data
1297     ) public virtual override {
1298         _transfer(from, to, tokenId);
1299         if (to.isContract())
1300             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1301                 revert TransferToNonERC721ReceiverImplementer();
1302             }
1303     }
1304 
1305     /**
1306      * @dev Returns whether `tokenId` exists.
1307      *
1308      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1309      *
1310      * Tokens start existing when they are minted (`_mint`),
1311      */
1312     function _exists(uint256 tokenId) internal view returns (bool) {
1313         return
1314             _startTokenId() <= tokenId &&
1315             tokenId < _currentIndex &&
1316             !_ownerships[tokenId].burned;
1317     }
1318 
1319     /**
1320      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1321      */
1322     function _safeMint(address to, uint256 quantity) internal {
1323         _safeMint(to, quantity, "");
1324     }
1325 
1326     /**
1327      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1328      *
1329      * Requirements:
1330      *
1331      * - If `to` refers to a smart contract, it must implement
1332      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1333      * - `quantity` must be greater than 0.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _safeMint(
1338         address to,
1339         uint256 quantity,
1340         bytes memory _data
1341     ) internal {
1342         uint256 startTokenId = _currentIndex;
1343         if (to == address(0)) revert MintToZeroAddress();
1344         if (quantity == 0) revert MintZeroQuantity();
1345 
1346         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1347 
1348         // Overflows are incredibly unrealistic.
1349         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1350         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1351         unchecked {
1352             _addressData[to].balance += uint64(quantity);
1353             _addressData[to].numberMinted += uint64(quantity);
1354 
1355             _ownerships[startTokenId].addr = to;
1356             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1357 
1358             uint256 updatedIndex = startTokenId;
1359             uint256 end = updatedIndex + quantity;
1360 
1361             if (to.isContract()) {
1362                 do {
1363                     emit Transfer(address(0), to, updatedIndex);
1364                     if (
1365                         !_checkContractOnERC721Received(
1366                             address(0),
1367                             to,
1368                             updatedIndex++,
1369                             _data
1370                         )
1371                     ) {
1372                         revert TransferToNonERC721ReceiverImplementer();
1373                     }
1374                 } while (updatedIndex < end);
1375                 // Reentrancy protection
1376                 if (_currentIndex != startTokenId) revert();
1377             } else {
1378                 do {
1379                     emit Transfer(address(0), to, updatedIndex++);
1380                 } while (updatedIndex < end);
1381             }
1382             _currentIndex = updatedIndex;
1383         }
1384         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1385     }
1386 
1387     /**
1388      * @dev Mints `quantity` tokens and transfers them to `to`.
1389      *
1390      * Requirements:
1391      *
1392      * - `to` cannot be the zero address.
1393      * - `quantity` must be greater than 0.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _mint(address to, uint256 quantity) internal {
1398         uint256 startTokenId = _currentIndex;
1399         if (to == address(0)) revert MintToZeroAddress();
1400         if (quantity == 0) revert MintZeroQuantity();
1401 
1402         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1403 
1404         // Overflows are incredibly unrealistic.
1405         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1406         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1407         unchecked {
1408             _addressData[to].balance += uint64(quantity);
1409             _addressData[to].numberMinted += uint64(quantity);
1410 
1411             _ownerships[startTokenId].addr = to;
1412             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1413 
1414             uint256 updatedIndex = startTokenId;
1415             uint256 end = updatedIndex + quantity;
1416 
1417             do {
1418                 emit Transfer(address(0), to, updatedIndex++);
1419             } while (updatedIndex < end);
1420 
1421             _currentIndex = updatedIndex;
1422         }
1423         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1424     }
1425 
1426     /**
1427      * @dev Transfers `tokenId` from `from` to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `to` cannot be the zero address.
1432      * - `tokenId` token must be owned by `from`.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _transfer(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) private {
1441         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1442 
1443         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1444 
1445         bool isApprovedOrOwner = (_msgSender() == from ||
1446             isApprovedForAll(from, _msgSender()) ||
1447             getApproved(tokenId) == _msgSender());
1448 
1449         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1450         if (to == address(0)) revert TransferToZeroAddress();
1451 
1452         _beforeTokenTransfers(from, to, tokenId, 1);
1453 
1454         // Clear approvals from the previous owner
1455         _approve(address(0), tokenId, from);
1456 
1457         // Underflow of the sender's balance is impossible because we check for
1458         // ownership above and the recipient's balance can't realistically overflow.
1459         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1460         unchecked {
1461             _addressData[from].balance -= 1;
1462             _addressData[to].balance += 1;
1463 
1464             TokenOwnership storage currSlot = _ownerships[tokenId];
1465             currSlot.addr = to;
1466             currSlot.startTimestamp = uint64(block.timestamp);
1467 
1468             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1469             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1470             uint256 nextTokenId = tokenId + 1;
1471             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1472             if (nextSlot.addr == address(0)) {
1473                 // This will suffice for checking _exists(nextTokenId),
1474                 // as a burned slot cannot contain the zero address.
1475                 if (nextTokenId != _currentIndex) {
1476                     nextSlot.addr = from;
1477                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1478                 }
1479             }
1480         }
1481 
1482         emit Transfer(from, to, tokenId);
1483         _afterTokenTransfers(from, to, tokenId, 1);
1484     }
1485 
1486     /**
1487      * @dev Equivalent to `_burn(tokenId, false)`.
1488      */
1489     function _burn(uint256 tokenId) internal virtual {
1490         _burn(tokenId, false);
1491     }
1492 
1493     /**
1494      * @dev Destroys `tokenId`.
1495      * The approval is cleared when the token is burned.
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must exist.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1504         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1505 
1506         address from = prevOwnership.addr;
1507 
1508         if (approvalCheck) {
1509             bool isApprovedOrOwner = (_msgSender() == from ||
1510                 isApprovedForAll(from, _msgSender()) ||
1511                 getApproved(tokenId) == _msgSender());
1512 
1513             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1514         }
1515 
1516         _beforeTokenTransfers(from, address(0), tokenId, 1);
1517 
1518         // Clear approvals from the previous owner
1519         _approve(address(0), tokenId, from);
1520 
1521         // Underflow of the sender's balance is impossible because we check for
1522         // ownership above and the recipient's balance can't realistically overflow.
1523         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1524         unchecked {
1525             AddressData storage addressData = _addressData[from];
1526             addressData.balance -= 1;
1527             addressData.numberBurned += 1;
1528 
1529             // Keep track of who burned the token, and the timestamp of burning.
1530             TokenOwnership storage currSlot = _ownerships[tokenId];
1531             currSlot.addr = from;
1532             currSlot.startTimestamp = uint64(block.timestamp);
1533             currSlot.burned = true;
1534 
1535             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1536             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1537             uint256 nextTokenId = tokenId + 1;
1538             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1539             if (nextSlot.addr == address(0)) {
1540                 // This will suffice for checking _exists(nextTokenId),
1541                 // as a burned slot cannot contain the zero address.
1542                 if (nextTokenId != _currentIndex) {
1543                     nextSlot.addr = from;
1544                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1545                 }
1546             }
1547         }
1548 
1549         emit Transfer(from, address(0), tokenId);
1550         _afterTokenTransfers(from, address(0), tokenId, 1);
1551 
1552         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1553         unchecked {
1554             _burnCounter++;
1555         }
1556     }
1557 
1558     /**
1559      * @dev Approve `to` to operate on `tokenId`
1560      *
1561      * Emits a {Approval} event.
1562      */
1563     function _approve(
1564         address to,
1565         uint256 tokenId,
1566         address owner
1567     ) private {
1568         _tokenApprovals[tokenId] = to;
1569         emit Approval(owner, to, tokenId);
1570     }
1571 
1572     /**
1573      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1574      *
1575      * @param from address representing the previous owner of the given token ID
1576      * @param to target address that will receive the tokens
1577      * @param tokenId uint256 ID of the token to be transferred
1578      * @param _data bytes optional data to send along with the call
1579      * @return bool whether the call correctly returned the expected magic value
1580      */
1581     function _checkContractOnERC721Received(
1582         address from,
1583         address to,
1584         uint256 tokenId,
1585         bytes memory _data
1586     ) private returns (bool) {
1587         try
1588             IERC721Receiver(to).onERC721Received(
1589                 _msgSender(),
1590                 from,
1591                 tokenId,
1592                 _data
1593             )
1594         returns (bytes4 retval) {
1595             return retval == IERC721Receiver(to).onERC721Received.selector;
1596         } catch (bytes memory reason) {
1597             if (reason.length == 0) {
1598                 revert TransferToNonERC721ReceiverImplementer();
1599             } else {
1600                 assembly {
1601                     revert(add(32, reason), mload(reason))
1602                 }
1603             }
1604         }
1605     }
1606 
1607     /**
1608      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1609      * And also called before burning one token.
1610      *
1611      * startTokenId - the first token id to be transferred
1612      * quantity - the amount to be transferred
1613      *
1614      * Calling conditions:
1615      *
1616      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1617      * transferred to `to`.
1618      * - When `from` is zero, `tokenId` will be minted for `to`.
1619      * - When `to` is zero, `tokenId` will be burned by `from`.
1620      * - `from` and `to` are never both zero.
1621      */
1622     function _beforeTokenTransfers(
1623         address from,
1624         address to,
1625         uint256 startTokenId,
1626         uint256 quantity
1627     ) internal virtual {}
1628 
1629     /**
1630      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1631      * minting.
1632      * And also called after one token has been burned.
1633      *
1634      * startTokenId - the first token id to be transferred
1635      * quantity - the amount to be transferred
1636      *
1637      * Calling conditions:
1638      *
1639      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1640      * transferred to `to`.
1641      * - When `from` is zero, `tokenId` has been minted for `to`.
1642      * - When `to` is zero, `tokenId` has been burned by `from`.
1643      * - `from` and `to` are never both zero.
1644      */
1645     function _afterTokenTransfers(
1646         address from,
1647         address to,
1648         uint256 startTokenId,
1649         uint256 quantity
1650     ) internal virtual {}
1651 }
1652 
1653 // File contracts/Something.sol
1654 
1655 pragma solidity 0.8.9;
1656 
1657 /*
1658  *   ___                                  __
1659  *  )_  _   _ )   \  X  / o _)_ ( _     (_ ` _   _ _   _  _)_ ( _  o  _   _
1660  * (__ ) ) (_(     \/ \/  ( (_   ) )   .__) (_) ) ) ) )_) (_   ) ) ( ) ) (_(
1661  *                                                   (_                    _)
1662  *  ---------------------------------------------
1663  * | We end with SOMETHING when AI meets NOTHING
1664  * | Website: https://endwithsomething.xyz
1665  * | Twitter: https://twitter.com/EndWithSth
1666  * | Opensea: https://opensea.io/collection/end-with-something
1667  */
1668 contract Something is Ownable, ERC721A, ERC2981 {
1669     uint256 public constant mintingPrice = 3 * 10**15;
1670     uint64 public constant mintingCapPerTx = 2;
1671     uint64 public constant freeMintingCapPerAddress = 1;
1672     uint64 public constant maxSupply = 1000;
1673     uint64 public freeQuota = 0;
1674 
1675     string public baseURI;
1676     bool public mintingActive = false;
1677 
1678     mapping(address => uint256) private addressToFreeMinted;
1679 
1680     constructor(uint64 initialFreeQuota) ERC721A("Something", "STH") {
1681         freeQuota = initialFreeQuota;
1682         _setDefaultRoyalty(msg.sender, 500);
1683     }
1684 
1685     function mint(uint256 amount) external payable {
1686         require(msg.sender == tx.origin, "EOA only");
1687         require(mintingActive, "minting inactive");
1688         require(amount > 0, "amount = 0");
1689         require(amount <= mintingCapPerTx, "exceed mintingCapPerTx");
1690         require(_totalMinted() + amount <= maxSupply, "exceed maxSupply");
1691 
1692         uint256 totalCost = 0;
1693         uint256 freeMintedAmount = 0;
1694         uint256 prevMintedTotal = _totalMinted();
1695         uint256 newMintedTotal = prevMintedTotal + amount;
1696         if (newMintedTotal > freeQuota) {
1697             if (prevMintedTotal < freeQuota) {
1698                 // partial free minting
1699                 freeMintedAmount = freeQuota - prevMintedTotal;
1700                 totalCost += mintingPrice * (newMintedTotal - freeQuota);
1701             } else {
1702                 // paid minting
1703                 totalCost += mintingPrice * (newMintedTotal - prevMintedTotal);
1704             }
1705         } else {
1706             // free minting
1707             freeMintedAmount = amount;
1708         }
1709         // ensure payment is sufficient
1710         require(msg.value >= totalCost, "insufficient payment");
1711 
1712         // ensure free-minting cap is not hit
1713         if (freeMintedAmount > 0) {
1714             uint256 freeMintedUpdated = addressToFreeMinted[msg.sender] +
1715                 freeMintedAmount;
1716             require(
1717                 freeMintedUpdated <= freeMintingCapPerAddress,
1718                 "exceed freeMintingCapPerAddress"
1719             );
1720             addressToFreeMinted[msg.sender] = freeMintedUpdated;
1721         }
1722 
1723         _safeMint(msg.sender, amount);
1724     }
1725 
1726     function withdraw() external onlyOwner {
1727         uint256 balance = address(this).balance;
1728         if (balance > 0) {
1729             payable(msg.sender).transfer(balance);
1730         }
1731     }
1732 
1733     function enableMinting() external onlyOwner {
1734         require(!mintingActive, "minting enabled already");
1735         mintingActive = true;
1736     }
1737 
1738     function disableMinting() external onlyOwner {
1739         require(mintingActive, "minting disabled already");
1740         mintingActive = false;
1741     }
1742 
1743     function setFreeQuota(uint64 newFreeQuota) external onlyOwner {
1744         require(newFreeQuota <= maxSupply, "freeQuota > maxSupply");
1745 
1746         uint256 minted = _totalMinted();
1747         // ensure nobody ever pays to protect fairness
1748         require(minted <= freeQuota, "minted > freeQuota");
1749         require(minted <= newFreeQuota, "minted > newFreeQuota");
1750         freeQuota = newFreeQuota;
1751     }
1752 
1753     function setBaseURI(string memory newBaseURI) external onlyOwner {
1754         baseURI = newBaseURI;
1755     }
1756 
1757     function totalMinted() external view returns (uint256) {
1758         return _totalMinted();
1759     }
1760 
1761     function getTotalFreeMintedByUser(address user)
1762         external
1763         view
1764         returns (uint256)
1765     {
1766         return addressToFreeMinted[user];
1767     }
1768 
1769     function supportsInterface(bytes4 interfaceId)
1770         public
1771         view
1772         virtual
1773         override(ERC721A, ERC2981)
1774         returns (bool)
1775     {
1776         return super.supportsInterface(interfaceId);
1777     }
1778 
1779     function _baseURI() internal view override returns (string memory) {
1780         return baseURI;
1781     }
1782 }