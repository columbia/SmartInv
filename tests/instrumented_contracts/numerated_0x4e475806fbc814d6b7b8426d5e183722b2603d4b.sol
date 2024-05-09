1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.3
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 
145 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.3
146 
147 
148 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Interface for the NFT Royalty Standard.
154  *
155  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
156  * support for royalty payments across all NFT marketplaces and ecosystem participants.
157  *
158  * _Available since v4.5._
159  */
160 interface IERC2981 is IERC165 {
161     /**
162      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
163      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
164      */
165     function royaltyInfo(uint256 tokenId, uint256 salePrice)
166         external
167         view
168         returns (address receiver, uint256 royaltyAmount);
169 }
170 
171 
172 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.3
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Implementation of the {IERC165} interface.
181  *
182  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
183  * for the additional interface id that will be supported. For example:
184  *
185  * ```solidity
186  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
187  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
188  * }
189  * ```
190  *
191  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
192  */
193 abstract contract ERC165 is IERC165 {
194     /**
195      * @dev See {IERC165-supportsInterface}.
196      */
197     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
198         return interfaceId == type(IERC165).interfaceId;
199     }
200 }
201 
202 
203 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.3
204 
205 
206 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
213  *
214  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
215  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
216  *
217  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
218  * fee is specified in basis points by default.
219  *
220  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
221  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
222  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
223  *
224  * _Available since v4.5._
225  */
226 abstract contract ERC2981 is IERC2981, ERC165 {
227     struct RoyaltyInfo {
228         address receiver;
229         uint96 royaltyFraction;
230     }
231 
232     RoyaltyInfo private _defaultRoyaltyInfo;
233     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
234 
235     /**
236      * @dev See {IERC165-supportsInterface}.
237      */
238     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
239         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
240     }
241 
242     /**
243      * @inheritdoc IERC2981
244      */
245     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
246         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
247 
248         if (royalty.receiver == address(0)) {
249             royalty = _defaultRoyaltyInfo;
250         }
251 
252         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
253 
254         return (royalty.receiver, royaltyAmount);
255     }
256 
257     /**
258      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
259      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
260      * override.
261      */
262     function _feeDenominator() internal pure virtual returns (uint96) {
263         return 10000;
264     }
265 
266     /**
267      * @dev Sets the royalty information that all ids in this contract will default to.
268      *
269      * Requirements:
270      *
271      * - `receiver` cannot be the zero address.
272      * - `feeNumerator` cannot be greater than the fee denominator.
273      */
274     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
275         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
276         require(receiver != address(0), "ERC2981: invalid receiver");
277 
278         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
279     }
280 
281     /**
282      * @dev Removes default royalty information.
283      */
284     function _deleteDefaultRoyalty() internal virtual {
285         delete _defaultRoyaltyInfo;
286     }
287 
288     /**
289      * @dev Sets the royalty information for a specific token id, overriding the global default.
290      *
291      * Requirements:
292      *
293      * - `receiver` cannot be the zero address.
294      * - `feeNumerator` cannot be greater than the fee denominator.
295      */
296     function _setTokenRoyalty(
297         uint256 tokenId,
298         address receiver,
299         uint96 feeNumerator
300     ) internal virtual {
301         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
302         require(receiver != address(0), "ERC2981: Invalid parameters");
303 
304         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
305     }
306 
307     /**
308      * @dev Resets royalty information for the token id back to the global default.
309      */
310     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
311         delete _tokenRoyaltyInfo[tokenId];
312     }
313 }
314 
315 
316 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.3
317 
318 
319 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
400      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
401      * understand this adds an external call which potentially creates a reentrancy vulnerability.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
420      * The approval is cleared when the token is transferred.
421      *
422      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Approve or remove `operator` as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
436      *
437      * Requirements:
438      *
439      * - The `operator` cannot be the caller.
440      *
441      * Emits an {ApprovalForAll} event.
442      */
443     function setApprovalForAll(address operator, bool _approved) external;
444 
445     /**
446      * @dev Returns the account approved for `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function getApproved(uint256 tokenId) external view returns (address operator);
453 
454     /**
455      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
456      *
457      * See {setApprovalForAll}
458      */
459     function isApprovedForAll(address owner, address operator) external view returns (bool);
460 }
461 
462 
463 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.3
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Metadata is IERC721 {
475     /**
476      * @dev Returns the token collection name.
477      */
478     function name() external view returns (string memory);
479 
480     /**
481      * @dev Returns the token collection symbol.
482      */
483     function symbol() external view returns (string memory);
484 
485     /**
486      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
487      */
488     function tokenURI(uint256 tokenId) external view returns (string memory);
489 }
490 
491 
492 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.3
493 
494 
495 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @title ERC721 token receiver interface
501  * @dev Interface for any contract that wants to support safeTransfers
502  * from ERC721 asset contracts.
503  */
504 interface IERC721Receiver {
505     /**
506      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
507      * by `operator` from `from`, this function is called.
508      *
509      * It must return its Solidity selector to confirm the token transfer.
510      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
511      *
512      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
513      */
514     function onERC721Received(
515         address operator,
516         address from,
517         uint256 tokenId,
518         bytes calldata data
519     ) external returns (bytes4);
520 }
521 
522 
523 // File @openzeppelin/contracts/utils/Address.sol@v4.8.3
524 
525 
526 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
527 
528 pragma solidity ^0.8.1;
529 
530 /**
531  * @dev Collection of functions related to the address type
532  */
533 library Address {
534     /**
535      * @dev Returns true if `account` is a contract.
536      *
537      * [IMPORTANT]
538      * ====
539      * It is unsafe to assume that an address for which this function returns
540      * false is an externally-owned account (EOA) and not a contract.
541      *
542      * Among others, `isContract` will return false for the following
543      * types of addresses:
544      *
545      *  - an externally-owned account
546      *  - a contract in construction
547      *  - an address where a contract will be created
548      *  - an address where a contract lived, but was destroyed
549      * ====
550      *
551      * [IMPORTANT]
552      * ====
553      * You shouldn't rely on `isContract` to protect against flash loan attacks!
554      *
555      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
556      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
557      * constructor.
558      * ====
559      */
560     function isContract(address account) internal view returns (bool) {
561         // This method relies on extcodesize/address.code.length, which returns 0
562         // for contracts in construction, since the code is only stored at the end
563         // of the constructor execution.
564 
565         return account.code.length > 0;
566     }
567 
568     /**
569      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
570      * `recipient`, forwarding all available gas and reverting on errors.
571      *
572      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
573      * of certain opcodes, possibly making contracts go over the 2300 gas limit
574      * imposed by `transfer`, making them unable to receive funds via
575      * `transfer`. {sendValue} removes this limitation.
576      *
577      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
578      *
579      * IMPORTANT: because control is transferred to `recipient`, care must be
580      * taken to not create reentrancy vulnerabilities. Consider using
581      * {ReentrancyGuard} or the
582      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
583      */
584     function sendValue(address payable recipient, uint256 amount) internal {
585         require(address(this).balance >= amount, "Address: insufficient balance");
586 
587         (bool success, ) = recipient.call{value: amount}("");
588         require(success, "Address: unable to send value, recipient may have reverted");
589     }
590 
591     /**
592      * @dev Performs a Solidity function call using a low level `call`. A
593      * plain `call` is an unsafe replacement for a function call: use this
594      * function instead.
595      *
596      * If `target` reverts with a revert reason, it is bubbled up by this
597      * function (like regular Solidity function calls).
598      *
599      * Returns the raw returned data. To convert to the expected return value,
600      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
601      *
602      * Requirements:
603      *
604      * - `target` must be a contract.
605      * - calling `target` with `data` must not revert.
606      *
607      * _Available since v3.1._
608      */
609     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
610         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
615      * `errorMessage` as a fallback revert reason when `target` reverts.
616      *
617      * _Available since v3.1._
618      */
619     function functionCall(
620         address target,
621         bytes memory data,
622         string memory errorMessage
623     ) internal returns (bytes memory) {
624         return functionCallWithValue(target, data, 0, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but also transferring `value` wei to `target`.
630      *
631      * Requirements:
632      *
633      * - the calling contract must have an ETH balance of at least `value`.
634      * - the called Solidity function must be `payable`.
635      *
636      * _Available since v3.1._
637      */
638     function functionCallWithValue(
639         address target,
640         bytes memory data,
641         uint256 value
642     ) internal returns (bytes memory) {
643         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
648      * with `errorMessage` as a fallback revert reason when `target` reverts.
649      *
650      * _Available since v3.1._
651      */
652     function functionCallWithValue(
653         address target,
654         bytes memory data,
655         uint256 value,
656         string memory errorMessage
657     ) internal returns (bytes memory) {
658         require(address(this).balance >= value, "Address: insufficient balance for call");
659         (bool success, bytes memory returndata) = target.call{value: value}(data);
660         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
665      * but performing a static call.
666      *
667      * _Available since v3.3._
668      */
669     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
670         return functionStaticCall(target, data, "Address: low-level static call failed");
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
675      * but performing a static call.
676      *
677      * _Available since v3.3._
678      */
679     function functionStaticCall(
680         address target,
681         bytes memory data,
682         string memory errorMessage
683     ) internal view returns (bytes memory) {
684         (bool success, bytes memory returndata) = target.staticcall(data);
685         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
690      * but performing a delegate call.
691      *
692      * _Available since v3.4._
693      */
694     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
695         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
700      * but performing a delegate call.
701      *
702      * _Available since v3.4._
703      */
704     function functionDelegateCall(
705         address target,
706         bytes memory data,
707         string memory errorMessage
708     ) internal returns (bytes memory) {
709         (bool success, bytes memory returndata) = target.delegatecall(data);
710         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
711     }
712 
713     /**
714      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
715      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
716      *
717      * _Available since v4.8._
718      */
719     function verifyCallResultFromTarget(
720         address target,
721         bool success,
722         bytes memory returndata,
723         string memory errorMessage
724     ) internal view returns (bytes memory) {
725         if (success) {
726             if (returndata.length == 0) {
727                 // only check isContract if the call was successful and the return data is empty
728                 // otherwise we already know that it was a contract
729                 require(isContract(target), "Address: call to non-contract");
730             }
731             return returndata;
732         } else {
733             _revert(returndata, errorMessage);
734         }
735     }
736 
737     /**
738      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
739      * revert reason or using the provided one.
740      *
741      * _Available since v4.3._
742      */
743     function verifyCallResult(
744         bool success,
745         bytes memory returndata,
746         string memory errorMessage
747     ) internal pure returns (bytes memory) {
748         if (success) {
749             return returndata;
750         } else {
751             _revert(returndata, errorMessage);
752         }
753     }
754 
755     function _revert(bytes memory returndata, string memory errorMessage) private pure {
756         // Look for revert reason and bubble it up if present
757         if (returndata.length > 0) {
758             // The easiest way to bubble the revert reason is using memory via assembly
759             /// @solidity memory-safe-assembly
760             assembly {
761                 let returndata_size := mload(returndata)
762                 revert(add(32, returndata), returndata_size)
763             }
764         } else {
765             revert(errorMessage);
766         }
767     }
768 }
769 
770 
771 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.3
772 
773 
774 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @dev Standard math utilities missing in the Solidity language.
780  */
781 library Math {
782     enum Rounding {
783         Down, // Toward negative infinity
784         Up, // Toward infinity
785         Zero // Toward zero
786     }
787 
788     /**
789      * @dev Returns the largest of two numbers.
790      */
791     function max(uint256 a, uint256 b) internal pure returns (uint256) {
792         return a > b ? a : b;
793     }
794 
795     /**
796      * @dev Returns the smallest of two numbers.
797      */
798     function min(uint256 a, uint256 b) internal pure returns (uint256) {
799         return a < b ? a : b;
800     }
801 
802     /**
803      * @dev Returns the average of two numbers. The result is rounded towards
804      * zero.
805      */
806     function average(uint256 a, uint256 b) internal pure returns (uint256) {
807         // (a + b) / 2 can overflow.
808         return (a & b) + (a ^ b) / 2;
809     }
810 
811     /**
812      * @dev Returns the ceiling of the division of two numbers.
813      *
814      * This differs from standard division with `/` in that it rounds up instead
815      * of rounding down.
816      */
817     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
818         // (a + b - 1) / b can overflow on addition, so we distribute.
819         return a == 0 ? 0 : (a - 1) / b + 1;
820     }
821 
822     /**
823      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
824      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
825      * with further edits by Uniswap Labs also under MIT license.
826      */
827     function mulDiv(
828         uint256 x,
829         uint256 y,
830         uint256 denominator
831     ) internal pure returns (uint256 result) {
832         unchecked {
833             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
834             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
835             // variables such that product = prod1 * 2^256 + prod0.
836             uint256 prod0; // Least significant 256 bits of the product
837             uint256 prod1; // Most significant 256 bits of the product
838             assembly {
839                 let mm := mulmod(x, y, not(0))
840                 prod0 := mul(x, y)
841                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
842             }
843 
844             // Handle non-overflow cases, 256 by 256 division.
845             if (prod1 == 0) {
846                 return prod0 / denominator;
847             }
848 
849             // Make sure the result is less than 2^256. Also prevents denominator == 0.
850             require(denominator > prod1);
851 
852             ///////////////////////////////////////////////
853             // 512 by 256 division.
854             ///////////////////////////////////////////////
855 
856             // Make division exact by subtracting the remainder from [prod1 prod0].
857             uint256 remainder;
858             assembly {
859                 // Compute remainder using mulmod.
860                 remainder := mulmod(x, y, denominator)
861 
862                 // Subtract 256 bit number from 512 bit number.
863                 prod1 := sub(prod1, gt(remainder, prod0))
864                 prod0 := sub(prod0, remainder)
865             }
866 
867             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
868             // See https://cs.stackexchange.com/q/138556/92363.
869 
870             // Does not overflow because the denominator cannot be zero at this stage in the function.
871             uint256 twos = denominator & (~denominator + 1);
872             assembly {
873                 // Divide denominator by twos.
874                 denominator := div(denominator, twos)
875 
876                 // Divide [prod1 prod0] by twos.
877                 prod0 := div(prod0, twos)
878 
879                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
880                 twos := add(div(sub(0, twos), twos), 1)
881             }
882 
883             // Shift in bits from prod1 into prod0.
884             prod0 |= prod1 * twos;
885 
886             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
887             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
888             // four bits. That is, denominator * inv = 1 mod 2^4.
889             uint256 inverse = (3 * denominator) ^ 2;
890 
891             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
892             // in modular arithmetic, doubling the correct bits in each step.
893             inverse *= 2 - denominator * inverse; // inverse mod 2^8
894             inverse *= 2 - denominator * inverse; // inverse mod 2^16
895             inverse *= 2 - denominator * inverse; // inverse mod 2^32
896             inverse *= 2 - denominator * inverse; // inverse mod 2^64
897             inverse *= 2 - denominator * inverse; // inverse mod 2^128
898             inverse *= 2 - denominator * inverse; // inverse mod 2^256
899 
900             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
901             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
902             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
903             // is no longer required.
904             result = prod0 * inverse;
905             return result;
906         }
907     }
908 
909     /**
910      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
911      */
912     function mulDiv(
913         uint256 x,
914         uint256 y,
915         uint256 denominator,
916         Rounding rounding
917     ) internal pure returns (uint256) {
918         uint256 result = mulDiv(x, y, denominator);
919         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
920             result += 1;
921         }
922         return result;
923     }
924 
925     /**
926      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
927      *
928      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
929      */
930     function sqrt(uint256 a) internal pure returns (uint256) {
931         if (a == 0) {
932             return 0;
933         }
934 
935         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
936         //
937         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
938         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
939         //
940         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
941         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
942         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
943         //
944         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
945         uint256 result = 1 << (log2(a) >> 1);
946 
947         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
948         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
949         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
950         // into the expected uint128 result.
951         unchecked {
952             result = (result + a / result) >> 1;
953             result = (result + a / result) >> 1;
954             result = (result + a / result) >> 1;
955             result = (result + a / result) >> 1;
956             result = (result + a / result) >> 1;
957             result = (result + a / result) >> 1;
958             result = (result + a / result) >> 1;
959             return min(result, a / result);
960         }
961     }
962 
963     /**
964      * @notice Calculates sqrt(a), following the selected rounding direction.
965      */
966     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
967         unchecked {
968             uint256 result = sqrt(a);
969             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
970         }
971     }
972 
973     /**
974      * @dev Return the log in base 2, rounded down, of a positive value.
975      * Returns 0 if given 0.
976      */
977     function log2(uint256 value) internal pure returns (uint256) {
978         uint256 result = 0;
979         unchecked {
980             if (value >> 128 > 0) {
981                 value >>= 128;
982                 result += 128;
983             }
984             if (value >> 64 > 0) {
985                 value >>= 64;
986                 result += 64;
987             }
988             if (value >> 32 > 0) {
989                 value >>= 32;
990                 result += 32;
991             }
992             if (value >> 16 > 0) {
993                 value >>= 16;
994                 result += 16;
995             }
996             if (value >> 8 > 0) {
997                 value >>= 8;
998                 result += 8;
999             }
1000             if (value >> 4 > 0) {
1001                 value >>= 4;
1002                 result += 4;
1003             }
1004             if (value >> 2 > 0) {
1005                 value >>= 2;
1006                 result += 2;
1007             }
1008             if (value >> 1 > 0) {
1009                 result += 1;
1010             }
1011         }
1012         return result;
1013     }
1014 
1015     /**
1016      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1017      * Returns 0 if given 0.
1018      */
1019     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1020         unchecked {
1021             uint256 result = log2(value);
1022             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1023         }
1024     }
1025 
1026     /**
1027      * @dev Return the log in base 10, rounded down, of a positive value.
1028      * Returns 0 if given 0.
1029      */
1030     function log10(uint256 value) internal pure returns (uint256) {
1031         uint256 result = 0;
1032         unchecked {
1033             if (value >= 10**64) {
1034                 value /= 10**64;
1035                 result += 64;
1036             }
1037             if (value >= 10**32) {
1038                 value /= 10**32;
1039                 result += 32;
1040             }
1041             if (value >= 10**16) {
1042                 value /= 10**16;
1043                 result += 16;
1044             }
1045             if (value >= 10**8) {
1046                 value /= 10**8;
1047                 result += 8;
1048             }
1049             if (value >= 10**4) {
1050                 value /= 10**4;
1051                 result += 4;
1052             }
1053             if (value >= 10**2) {
1054                 value /= 10**2;
1055                 result += 2;
1056             }
1057             if (value >= 10**1) {
1058                 result += 1;
1059             }
1060         }
1061         return result;
1062     }
1063 
1064     /**
1065      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1066      * Returns 0 if given 0.
1067      */
1068     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1069         unchecked {
1070             uint256 result = log10(value);
1071             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1072         }
1073     }
1074 
1075     /**
1076      * @dev Return the log in base 256, rounded down, of a positive value.
1077      * Returns 0 if given 0.
1078      *
1079      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1080      */
1081     function log256(uint256 value) internal pure returns (uint256) {
1082         uint256 result = 0;
1083         unchecked {
1084             if (value >> 128 > 0) {
1085                 value >>= 128;
1086                 result += 16;
1087             }
1088             if (value >> 64 > 0) {
1089                 value >>= 64;
1090                 result += 8;
1091             }
1092             if (value >> 32 > 0) {
1093                 value >>= 32;
1094                 result += 4;
1095             }
1096             if (value >> 16 > 0) {
1097                 value >>= 16;
1098                 result += 2;
1099             }
1100             if (value >> 8 > 0) {
1101                 result += 1;
1102             }
1103         }
1104         return result;
1105     }
1106 
1107     /**
1108      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1109      * Returns 0 if given 0.
1110      */
1111     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1112         unchecked {
1113             uint256 result = log256(value);
1114             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1115         }
1116     }
1117 }
1118 
1119 
1120 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.3
1121 
1122 
1123 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1124 
1125 pragma solidity ^0.8.0;
1126 
1127 /**
1128  * @dev String operations.
1129  */
1130 library Strings {
1131     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1132     uint8 private constant _ADDRESS_LENGTH = 20;
1133 
1134     /**
1135      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1136      */
1137     function toString(uint256 value) internal pure returns (string memory) {
1138         unchecked {
1139             uint256 length = Math.log10(value) + 1;
1140             string memory buffer = new string(length);
1141             uint256 ptr;
1142             /// @solidity memory-safe-assembly
1143             assembly {
1144                 ptr := add(buffer, add(32, length))
1145             }
1146             while (true) {
1147                 ptr--;
1148                 /// @solidity memory-safe-assembly
1149                 assembly {
1150                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1151                 }
1152                 value /= 10;
1153                 if (value == 0) break;
1154             }
1155             return buffer;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1161      */
1162     function toHexString(uint256 value) internal pure returns (string memory) {
1163         unchecked {
1164             return toHexString(value, Math.log256(value) + 1);
1165         }
1166     }
1167 
1168     /**
1169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1170      */
1171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1172         bytes memory buffer = new bytes(2 * length + 2);
1173         buffer[0] = "0";
1174         buffer[1] = "x";
1175         for (uint256 i = 2 * length + 1; i > 1; --i) {
1176             buffer[i] = _SYMBOLS[value & 0xf];
1177             value >>= 4;
1178         }
1179         require(value == 0, "Strings: hex length insufficient");
1180         return string(buffer);
1181     }
1182 
1183     /**
1184      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1185      */
1186     function toHexString(address addr) internal pure returns (string memory) {
1187         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1188     }
1189 }
1190 
1191 
1192 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.3
1193 
1194 
1195 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 /**
1206  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1207  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1208  * {ERC721Enumerable}.
1209  */
1210 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1211     using Address for address;
1212     using Strings for uint256;
1213 
1214     // Token name
1215     string private _name;
1216 
1217     // Token symbol
1218     string private _symbol;
1219 
1220     // Mapping from token ID to owner address
1221     mapping(uint256 => address) private _owners;
1222 
1223     // Mapping owner address to token count
1224     mapping(address => uint256) private _balances;
1225 
1226     // Mapping from token ID to approved address
1227     mapping(uint256 => address) private _tokenApprovals;
1228 
1229     // Mapping from owner to operator approvals
1230     mapping(address => mapping(address => bool)) private _operatorApprovals;
1231 
1232     /**
1233      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1234      */
1235     constructor(string memory name_, string memory symbol_) {
1236         _name = name_;
1237         _symbol = symbol_;
1238     }
1239 
1240     /**
1241      * @dev See {IERC165-supportsInterface}.
1242      */
1243     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1244         return
1245             interfaceId == type(IERC721).interfaceId ||
1246             interfaceId == type(IERC721Metadata).interfaceId ||
1247             super.supportsInterface(interfaceId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-balanceOf}.
1252      */
1253     function balanceOf(address owner) public view virtual override returns (uint256) {
1254         require(owner != address(0), "ERC721: address zero is not a valid owner");
1255         return _balances[owner];
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-ownerOf}.
1260      */
1261     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1262         address owner = _ownerOf(tokenId);
1263         require(owner != address(0), "ERC721: invalid token ID");
1264         return owner;
1265     }
1266 
1267     /**
1268      * @dev See {IERC721Metadata-name}.
1269      */
1270     function name() public view virtual override returns (string memory) {
1271         return _name;
1272     }
1273 
1274     /**
1275      * @dev See {IERC721Metadata-symbol}.
1276      */
1277     function symbol() public view virtual override returns (string memory) {
1278         return _symbol;
1279     }
1280 
1281     /**
1282      * @dev See {IERC721Metadata-tokenURI}.
1283      */
1284     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1285         _requireMinted(tokenId);
1286 
1287         string memory baseURI = _baseURI();
1288         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1289     }
1290 
1291     /**
1292      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1293      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1294      * by default, can be overridden in child contracts.
1295      */
1296     function _baseURI() internal view virtual returns (string memory) {
1297         return "";
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-approve}.
1302      */
1303     function approve(address to, uint256 tokenId) public virtual override {
1304         address owner = ERC721.ownerOf(tokenId);
1305         require(to != owner, "ERC721: approval to current owner");
1306 
1307         require(
1308             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1309             "ERC721: approve caller is not token owner or approved for all"
1310         );
1311 
1312         _approve(to, tokenId);
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-getApproved}.
1317      */
1318     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1319         _requireMinted(tokenId);
1320 
1321         return _tokenApprovals[tokenId];
1322     }
1323 
1324     /**
1325      * @dev See {IERC721-setApprovalForAll}.
1326      */
1327     function setApprovalForAll(address operator, bool approved) public virtual override {
1328         _setApprovalForAll(_msgSender(), operator, approved);
1329     }
1330 
1331     /**
1332      * @dev See {IERC721-isApprovedForAll}.
1333      */
1334     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1335         return _operatorApprovals[owner][operator];
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-transferFrom}.
1340      */
1341     function transferFrom(
1342         address from,
1343         address to,
1344         uint256 tokenId
1345     ) public virtual override {
1346         //solhint-disable-next-line max-line-length
1347         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1348 
1349         _transfer(from, to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-safeTransferFrom}.
1354      */
1355     function safeTransferFrom(
1356         address from,
1357         address to,
1358         uint256 tokenId
1359     ) public virtual override {
1360         safeTransferFrom(from, to, tokenId, "");
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-safeTransferFrom}.
1365      */
1366     function safeTransferFrom(
1367         address from,
1368         address to,
1369         uint256 tokenId,
1370         bytes memory data
1371     ) public virtual override {
1372         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1373         _safeTransfer(from, to, tokenId, data);
1374     }
1375 
1376     /**
1377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1379      *
1380      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1381      *
1382      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1383      * implement alternative mechanisms to perform token transfer, such as signature-based.
1384      *
1385      * Requirements:
1386      *
1387      * - `from` cannot be the zero address.
1388      * - `to` cannot be the zero address.
1389      * - `tokenId` token must exist and be owned by `from`.
1390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _safeTransfer(
1395         address from,
1396         address to,
1397         uint256 tokenId,
1398         bytes memory data
1399     ) internal virtual {
1400         _transfer(from, to, tokenId);
1401         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1402     }
1403 
1404     /**
1405      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1406      */
1407     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1408         return _owners[tokenId];
1409     }
1410 
1411     /**
1412      * @dev Returns whether `tokenId` exists.
1413      *
1414      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1415      *
1416      * Tokens start existing when they are minted (`_mint`),
1417      * and stop existing when they are burned (`_burn`).
1418      */
1419     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1420         return _ownerOf(tokenId) != address(0);
1421     }
1422 
1423     /**
1424      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1425      *
1426      * Requirements:
1427      *
1428      * - `tokenId` must exist.
1429      */
1430     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1431         address owner = ERC721.ownerOf(tokenId);
1432         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1433     }
1434 
1435     /**
1436      * @dev Safely mints `tokenId` and transfers it to `to`.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must not exist.
1441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1442      *
1443      * Emits a {Transfer} event.
1444      */
1445     function _safeMint(address to, uint256 tokenId) internal virtual {
1446         _safeMint(to, tokenId, "");
1447     }
1448 
1449     /**
1450      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1451      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1452      */
1453     function _safeMint(
1454         address to,
1455         uint256 tokenId,
1456         bytes memory data
1457     ) internal virtual {
1458         _mint(to, tokenId);
1459         require(
1460             _checkOnERC721Received(address(0), to, tokenId, data),
1461             "ERC721: transfer to non ERC721Receiver implementer"
1462         );
1463     }
1464 
1465     /**
1466      * @dev Mints `tokenId` and transfers it to `to`.
1467      *
1468      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1469      *
1470      * Requirements:
1471      *
1472      * - `tokenId` must not exist.
1473      * - `to` cannot be the zero address.
1474      *
1475      * Emits a {Transfer} event.
1476      */
1477     function _mint(address to, uint256 tokenId) internal virtual {
1478         require(to != address(0), "ERC721: mint to the zero address");
1479         require(!_exists(tokenId), "ERC721: token already minted");
1480 
1481         _beforeTokenTransfer(address(0), to, tokenId, 1);
1482 
1483         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1484         require(!_exists(tokenId), "ERC721: token already minted");
1485 
1486         unchecked {
1487             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1488             // Given that tokens are minted one by one, it is impossible in practice that
1489             // this ever happens. Might change if we allow batch minting.
1490             // The ERC fails to describe this case.
1491             _balances[to] += 1;
1492         }
1493 
1494         _owners[tokenId] = to;
1495 
1496         emit Transfer(address(0), to, tokenId);
1497 
1498         _afterTokenTransfer(address(0), to, tokenId, 1);
1499     }
1500 
1501     /**
1502      * @dev Destroys `tokenId`.
1503      * The approval is cleared when the token is burned.
1504      * This is an internal function that does not check if the sender is authorized to operate on the token.
1505      *
1506      * Requirements:
1507      *
1508      * - `tokenId` must exist.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _burn(uint256 tokenId) internal virtual {
1513         address owner = ERC721.ownerOf(tokenId);
1514 
1515         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1516 
1517         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1518         owner = ERC721.ownerOf(tokenId);
1519 
1520         // Clear approvals
1521         delete _tokenApprovals[tokenId];
1522 
1523         unchecked {
1524             // Cannot overflow, as that would require more tokens to be burned/transferred
1525             // out than the owner initially received through minting and transferring in.
1526             _balances[owner] -= 1;
1527         }
1528         delete _owners[tokenId];
1529 
1530         emit Transfer(owner, address(0), tokenId);
1531 
1532         _afterTokenTransfer(owner, address(0), tokenId, 1);
1533     }
1534 
1535     /**
1536      * @dev Transfers `tokenId` from `from` to `to`.
1537      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1538      *
1539      * Requirements:
1540      *
1541      * - `to` cannot be the zero address.
1542      * - `tokenId` token must be owned by `from`.
1543      *
1544      * Emits a {Transfer} event.
1545      */
1546     function _transfer(
1547         address from,
1548         address to,
1549         uint256 tokenId
1550     ) internal virtual {
1551         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1552         require(to != address(0), "ERC721: transfer to the zero address");
1553 
1554         _beforeTokenTransfer(from, to, tokenId, 1);
1555 
1556         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1557         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1558 
1559         // Clear approvals from the previous owner
1560         delete _tokenApprovals[tokenId];
1561 
1562         unchecked {
1563             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1564             // `from`'s balance is the number of token held, which is at least one before the current
1565             // transfer.
1566             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1567             // all 2**256 token ids to be minted, which in practice is impossible.
1568             _balances[from] -= 1;
1569             _balances[to] += 1;
1570         }
1571         _owners[tokenId] = to;
1572 
1573         emit Transfer(from, to, tokenId);
1574 
1575         _afterTokenTransfer(from, to, tokenId, 1);
1576     }
1577 
1578     /**
1579      * @dev Approve `to` to operate on `tokenId`
1580      *
1581      * Emits an {Approval} event.
1582      */
1583     function _approve(address to, uint256 tokenId) internal virtual {
1584         _tokenApprovals[tokenId] = to;
1585         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1586     }
1587 
1588     /**
1589      * @dev Approve `operator` to operate on all of `owner` tokens
1590      *
1591      * Emits an {ApprovalForAll} event.
1592      */
1593     function _setApprovalForAll(
1594         address owner,
1595         address operator,
1596         bool approved
1597     ) internal virtual {
1598         require(owner != operator, "ERC721: approve to caller");
1599         _operatorApprovals[owner][operator] = approved;
1600         emit ApprovalForAll(owner, operator, approved);
1601     }
1602 
1603     /**
1604      * @dev Reverts if the `tokenId` has not been minted yet.
1605      */
1606     function _requireMinted(uint256 tokenId) internal view virtual {
1607         require(_exists(tokenId), "ERC721: invalid token ID");
1608     }
1609 
1610     /**
1611      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1612      * The call is not executed if the target address is not a contract.
1613      *
1614      * @param from address representing the previous owner of the given token ID
1615      * @param to target address that will receive the tokens
1616      * @param tokenId uint256 ID of the token to be transferred
1617      * @param data bytes optional data to send along with the call
1618      * @return bool whether the call correctly returned the expected magic value
1619      */
1620     function _checkOnERC721Received(
1621         address from,
1622         address to,
1623         uint256 tokenId,
1624         bytes memory data
1625     ) private returns (bool) {
1626         if (to.isContract()) {
1627             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1628                 return retval == IERC721Receiver.onERC721Received.selector;
1629             } catch (bytes memory reason) {
1630                 if (reason.length == 0) {
1631                     revert("ERC721: transfer to non ERC721Receiver implementer");
1632                 } else {
1633                     /// @solidity memory-safe-assembly
1634                     assembly {
1635                         revert(add(32, reason), mload(reason))
1636                     }
1637                 }
1638             }
1639         } else {
1640             return true;
1641         }
1642     }
1643 
1644     /**
1645      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1646      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1647      *
1648      * Calling conditions:
1649      *
1650      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1651      * - When `from` is zero, the tokens will be minted for `to`.
1652      * - When `to` is zero, ``from``'s tokens will be burned.
1653      * - `from` and `to` are never both zero.
1654      * - `batchSize` is non-zero.
1655      *
1656      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1657      */
1658     function _beforeTokenTransfer(
1659         address from,
1660         address to,
1661         uint256 firstTokenId,
1662         uint256 batchSize
1663     ) internal virtual {}
1664 
1665     /**
1666      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1667      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1668      *
1669      * Calling conditions:
1670      *
1671      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1672      * - When `from` is zero, the tokens were minted for `to`.
1673      * - When `to` is zero, ``from``'s tokens were burned.
1674      * - `from` and `to` are never both zero.
1675      * - `batchSize` is non-zero.
1676      *
1677      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1678      */
1679     function _afterTokenTransfer(
1680         address from,
1681         address to,
1682         uint256 firstTokenId,
1683         uint256 batchSize
1684     ) internal virtual {}
1685 
1686     /**
1687      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1688      *
1689      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1690      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1691      * that `ownerOf(tokenId)` is `a`.
1692      */
1693     // solhint-disable-next-line func-name-mixedcase
1694     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1695         _balances[account] += amount;
1696     }
1697 }
1698 
1699 
1700 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.3
1701 
1702 
1703 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1704 
1705 pragma solidity ^0.8.0;
1706 
1707 /**
1708  * @dev Contract module that helps prevent reentrant calls to a function.
1709  *
1710  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1711  * available, which can be applied to functions to make sure there are no nested
1712  * (reentrant) calls to them.
1713  *
1714  * Note that because there is a single `nonReentrant` guard, functions marked as
1715  * `nonReentrant` may not call one another. This can be worked around by making
1716  * those functions `private`, and then adding `external` `nonReentrant` entry
1717  * points to them.
1718  *
1719  * TIP: If you would like to learn more about reentrancy and alternative ways
1720  * to protect against it, check out our blog post
1721  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1722  */
1723 abstract contract ReentrancyGuard {
1724     // Booleans are more expensive than uint256 or any type that takes up a full
1725     // word because each write operation emits an extra SLOAD to first read the
1726     // slot's contents, replace the bits taken up by the boolean, and then write
1727     // back. This is the compiler's defense against contract upgrades and
1728     // pointer aliasing, and it cannot be disabled.
1729 
1730     // The values being non-zero value makes deployment a bit more expensive,
1731     // but in exchange the refund on every call to nonReentrant will be lower in
1732     // amount. Since refunds are capped to a percentage of the total
1733     // transaction's gas, it is best to keep them low in cases like this one, to
1734     // increase the likelihood of the full refund coming into effect.
1735     uint256 private constant _NOT_ENTERED = 1;
1736     uint256 private constant _ENTERED = 2;
1737 
1738     uint256 private _status;
1739 
1740     constructor() {
1741         _status = _NOT_ENTERED;
1742     }
1743 
1744     /**
1745      * @dev Prevents a contract from calling itself, directly or indirectly.
1746      * Calling a `nonReentrant` function from another `nonReentrant`
1747      * function is not supported. It is possible to prevent this from happening
1748      * by making the `nonReentrant` function external, and making it call a
1749      * `private` function that does the actual work.
1750      */
1751     modifier nonReentrant() {
1752         _nonReentrantBefore();
1753         _;
1754         _nonReentrantAfter();
1755     }
1756 
1757     function _nonReentrantBefore() private {
1758         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1759         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1760 
1761         // Any calls to nonReentrant after this point will fail
1762         _status = _ENTERED;
1763     }
1764 
1765     function _nonReentrantAfter() private {
1766         // By storing the original value once again, a refund is triggered (see
1767         // https://eips.ethereum.org/EIPS/eip-2200)
1768         _status = _NOT_ENTERED;
1769     }
1770 }
1771 
1772 
1773 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.3
1774 
1775 
1776 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1777 
1778 pragma solidity ^0.8.0;
1779 
1780 /**
1781  * @dev These functions deal with verification of Merkle Tree proofs.
1782  *
1783  * The tree and the proofs can be generated using our
1784  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1785  * You will find a quickstart guide in the readme.
1786  *
1787  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1788  * hashing, or use a hash function other than keccak256 for hashing leaves.
1789  * This is because the concatenation of a sorted pair of internal nodes in
1790  * the merkle tree could be reinterpreted as a leaf value.
1791  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1792  * against this attack out of the box.
1793  */
1794 library MerkleProof {
1795     /**
1796      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1797      * defined by `root`. For this, a `proof` must be provided, containing
1798      * sibling hashes on the branch from the leaf to the root of the tree. Each
1799      * pair of leaves and each pair of pre-images are assumed to be sorted.
1800      */
1801     function verify(
1802         bytes32[] memory proof,
1803         bytes32 root,
1804         bytes32 leaf
1805     ) internal pure returns (bool) {
1806         return processProof(proof, leaf) == root;
1807     }
1808 
1809     /**
1810      * @dev Calldata version of {verify}
1811      *
1812      * _Available since v4.7._
1813      */
1814     function verifyCalldata(
1815         bytes32[] calldata proof,
1816         bytes32 root,
1817         bytes32 leaf
1818     ) internal pure returns (bool) {
1819         return processProofCalldata(proof, leaf) == root;
1820     }
1821 
1822     /**
1823      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1824      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1825      * hash matches the root of the tree. When processing the proof, the pairs
1826      * of leafs & pre-images are assumed to be sorted.
1827      *
1828      * _Available since v4.4._
1829      */
1830     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1831         bytes32 computedHash = leaf;
1832         for (uint256 i = 0; i < proof.length; i++) {
1833             computedHash = _hashPair(computedHash, proof[i]);
1834         }
1835         return computedHash;
1836     }
1837 
1838     /**
1839      * @dev Calldata version of {processProof}
1840      *
1841      * _Available since v4.7._
1842      */
1843     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1844         bytes32 computedHash = leaf;
1845         for (uint256 i = 0; i < proof.length; i++) {
1846             computedHash = _hashPair(computedHash, proof[i]);
1847         }
1848         return computedHash;
1849     }
1850 
1851     /**
1852      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1853      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1854      *
1855      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1856      *
1857      * _Available since v4.7._
1858      */
1859     function multiProofVerify(
1860         bytes32[] memory proof,
1861         bool[] memory proofFlags,
1862         bytes32 root,
1863         bytes32[] memory leaves
1864     ) internal pure returns (bool) {
1865         return processMultiProof(proof, proofFlags, leaves) == root;
1866     }
1867 
1868     /**
1869      * @dev Calldata version of {multiProofVerify}
1870      *
1871      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1872      *
1873      * _Available since v4.7._
1874      */
1875     function multiProofVerifyCalldata(
1876         bytes32[] calldata proof,
1877         bool[] calldata proofFlags,
1878         bytes32 root,
1879         bytes32[] memory leaves
1880     ) internal pure returns (bool) {
1881         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1882     }
1883 
1884     /**
1885      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1886      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1887      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1888      * respectively.
1889      *
1890      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1891      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1892      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1893      *
1894      * _Available since v4.7._
1895      */
1896     function processMultiProof(
1897         bytes32[] memory proof,
1898         bool[] memory proofFlags,
1899         bytes32[] memory leaves
1900     ) internal pure returns (bytes32 merkleRoot) {
1901         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1902         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1903         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1904         // the merkle tree.
1905         uint256 leavesLen = leaves.length;
1906         uint256 totalHashes = proofFlags.length;
1907 
1908         // Check proof validity.
1909         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1910 
1911         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1912         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1913         bytes32[] memory hashes = new bytes32[](totalHashes);
1914         uint256 leafPos = 0;
1915         uint256 hashPos = 0;
1916         uint256 proofPos = 0;
1917         // At each step, we compute the next hash using two values:
1918         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1919         //   get the next hash.
1920         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1921         //   `proof` array.
1922         for (uint256 i = 0; i < totalHashes; i++) {
1923             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1924             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1925             hashes[i] = _hashPair(a, b);
1926         }
1927 
1928         if (totalHashes > 0) {
1929             return hashes[totalHashes - 1];
1930         } else if (leavesLen > 0) {
1931             return leaves[0];
1932         } else {
1933             return proof[0];
1934         }
1935     }
1936 
1937     /**
1938      * @dev Calldata version of {processMultiProof}.
1939      *
1940      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1941      *
1942      * _Available since v4.7._
1943      */
1944     function processMultiProofCalldata(
1945         bytes32[] calldata proof,
1946         bool[] calldata proofFlags,
1947         bytes32[] memory leaves
1948     ) internal pure returns (bytes32 merkleRoot) {
1949         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1950         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1951         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1952         // the merkle tree.
1953         uint256 leavesLen = leaves.length;
1954         uint256 totalHashes = proofFlags.length;
1955 
1956         // Check proof validity.
1957         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1958 
1959         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1960         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1961         bytes32[] memory hashes = new bytes32[](totalHashes);
1962         uint256 leafPos = 0;
1963         uint256 hashPos = 0;
1964         uint256 proofPos = 0;
1965         // At each step, we compute the next hash using two values:
1966         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1967         //   get the next hash.
1968         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1969         //   `proof` array.
1970         for (uint256 i = 0; i < totalHashes; i++) {
1971             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1972             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1973             hashes[i] = _hashPair(a, b);
1974         }
1975 
1976         if (totalHashes > 0) {
1977             return hashes[totalHashes - 1];
1978         } else if (leavesLen > 0) {
1979             return leaves[0];
1980         } else {
1981             return proof[0];
1982         }
1983     }
1984 
1985     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1986         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1987     }
1988 
1989     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1990         /// @solidity memory-safe-assembly
1991         assembly {
1992             mstore(0x00, a)
1993             mstore(0x20, b)
1994             value := keccak256(0x00, 0x40)
1995         }
1996     }
1997 }
1998 
1999 
2000 // File operator-filter-registry/src/lib/Constants.sol@v1.4.1
2001 
2002 
2003 pragma solidity ^0.8.13;
2004 
2005 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2006 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2007 
2008 
2009 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.4.1
2010 
2011 
2012 pragma solidity ^0.8.13;
2013 
2014 interface IOperatorFilterRegistry {
2015     /**
2016      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2017      *         true if supplied registrant address is not registered.
2018      */
2019     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2020 
2021     /**
2022      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2023      */
2024     function register(address registrant) external;
2025 
2026     /**
2027      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2028      */
2029     function registerAndSubscribe(address registrant, address subscription) external;
2030 
2031     /**
2032      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2033      *         address without subscribing.
2034      */
2035     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2036 
2037     /**
2038      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2039      *         Note that this does not remove any filtered addresses or codeHashes.
2040      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2041      */
2042     function unregister(address addr) external;
2043 
2044     /**
2045      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2046      */
2047     function updateOperator(address registrant, address operator, bool filtered) external;
2048 
2049     /**
2050      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2051      */
2052     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2053 
2054     /**
2055      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2056      */
2057     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2058 
2059     /**
2060      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2061      */
2062     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2063 
2064     /**
2065      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2066      *         subscription if present.
2067      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2068      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2069      *         used.
2070      */
2071     function subscribe(address registrant, address registrantToSubscribe) external;
2072 
2073     /**
2074      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2075      */
2076     function unsubscribe(address registrant, bool copyExistingEntries) external;
2077 
2078     /**
2079      * @notice Get the subscription address of a given registrant, if any.
2080      */
2081     function subscriptionOf(address addr) external returns (address registrant);
2082 
2083     /**
2084      * @notice Get the set of addresses subscribed to a given registrant.
2085      *         Note that order is not guaranteed as updates are made.
2086      */
2087     function subscribers(address registrant) external returns (address[] memory);
2088 
2089     /**
2090      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2091      *         Note that order is not guaranteed as updates are made.
2092      */
2093     function subscriberAt(address registrant, uint256 index) external returns (address);
2094 
2095     /**
2096      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2097      */
2098     function copyEntriesOf(address registrant, address registrantToCopy) external;
2099 
2100     /**
2101      * @notice Returns true if operator is filtered by a given address or its subscription.
2102      */
2103     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2104 
2105     /**
2106      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2107      */
2108     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2109 
2110     /**
2111      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2112      */
2113     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2114 
2115     /**
2116      * @notice Returns a list of filtered operators for a given address or its subscription.
2117      */
2118     function filteredOperators(address addr) external returns (address[] memory);
2119 
2120     /**
2121      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2122      *         Note that order is not guaranteed as updates are made.
2123      */
2124     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2125 
2126     /**
2127      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2128      *         its subscription.
2129      *         Note that order is not guaranteed as updates are made.
2130      */
2131     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2132 
2133     /**
2134      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2135      *         its subscription.
2136      *         Note that order is not guaranteed as updates are made.
2137      */
2138     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2139 
2140     /**
2141      * @notice Returns true if an address has registered
2142      */
2143     function isRegistered(address addr) external returns (bool);
2144 
2145     /**
2146      * @dev Convenience method to compute the code hash of an arbitrary contract
2147      */
2148     function codeHashOf(address addr) external returns (bytes32);
2149 }
2150 
2151 
2152 // File operator-filter-registry/src/OperatorFilterer.sol@v1.4.1
2153 
2154 
2155 pragma solidity ^0.8.13;
2156 
2157 
2158 /**
2159  * @title  OperatorFilterer
2160  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2161  *         registrant's entries in the OperatorFilterRegistry.
2162  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2163  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2164  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2165  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2166  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2167  *         will be locked to the options set during construction.
2168  */
2169 
2170 abstract contract OperatorFilterer {
2171     /// @dev Emitted when an operator is not allowed.
2172     error OperatorNotAllowed(address operator);
2173 
2174     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2175         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2176 
2177     /// @dev The constructor that is called when the contract is being deployed.
2178     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2179         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2180         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2181         // order for the modifier to filter addresses.
2182         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2183             if (subscribe) {
2184                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2185             } else {
2186                 if (subscriptionOrRegistrantToCopy != address(0)) {
2187                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2188                 } else {
2189                     OPERATOR_FILTER_REGISTRY.register(address(this));
2190                 }
2191             }
2192         }
2193     }
2194 
2195     /**
2196      * @dev A helper function to check if an operator is allowed.
2197      */
2198     modifier onlyAllowedOperator(address from) virtual {
2199         // Allow spending tokens from addresses with balance
2200         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2201         // from an EOA.
2202         if (from != msg.sender) {
2203             _checkFilterOperator(msg.sender);
2204         }
2205         _;
2206     }
2207 
2208     /**
2209      * @dev A helper function to check if an operator approval is allowed.
2210      */
2211     modifier onlyAllowedOperatorApproval(address operator) virtual {
2212         _checkFilterOperator(operator);
2213         _;
2214     }
2215 
2216     /**
2217      * @dev A helper function to check if an operator is allowed.
2218      */
2219     function _checkFilterOperator(address operator) internal view virtual {
2220         // Check registry code length to facilitate testing in environments without a deployed registry.
2221         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2222             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2223             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2224             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2225                 revert OperatorNotAllowed(operator);
2226             }
2227         }
2228     }
2229 }
2230 
2231 
2232 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.4.1
2233 
2234 
2235 pragma solidity ^0.8.13;
2236 
2237 
2238 /**
2239  * @title  DefaultOperatorFilterer
2240  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2241  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2242  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2243  *         will be locked to the options set during construction.
2244  */
2245 
2246 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2247     /// @dev The constructor that is called when the contract is being deployed.
2248     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2249 }
2250 
2251 
2252 // File contracts/FusionistBetaBrawlerNFT.sol
2253 
2254 
2255 pragma solidity ^0.8.19;
2256 /** 
2257           / \
2258          /-^-\
2259         /_/_\_\
2260        /_/_/_\_\
2261        | Fusion|
2262        |  ist  |
2263        |   *   |
2264        |       |
2265        |       |
2266        |  /-\  |
2267        |  | |  |
2268        | /   \ |
2269        | \   / |
2270        |  \ /  |
2271        |   |   |
2272        |   |   |
2273        |___|___|
2274       [ [ [ [ [ ]
2275 */
2276 ///@author Charles
2277 contract FusionistBetaBrawlerNFT is
2278     ERC2981,
2279     Ownable,
2280     ReentrancyGuard,
2281     DefaultOperatorFilterer,
2282     ERC721
2283 {
2284     error IncorrectProof();
2285     error AllNFTsMinted();
2286     error CannotSetZeroAddress();
2287     error ShouldInHighIDRange();
2288     error YouAreNotOwner();
2289     error YouHaveMinted();
2290 
2291     uint256 public constant MAX_SUPPLY = 300;
2292     uint32 private constant KEY_ID_OFFSET = 10000;
2293 
2294     address public treasuryAddress;
2295     bytes32 public merkleRootForKeys;
2296     bytes32 public merkleRootForMedals;
2297 
2298     string private _baseTokenURI;
2299     uint16 private _totalMinted;
2300     mapping(address => bool) private _claimedKeys;
2301     mapping(address => bool) private _claimedMedals;
2302 
2303     constructor(
2304         address defaultTreasury,
2305         string memory defaultBaseURI
2306     ) ERC721("Pioneer of Fusionist", "POF") {
2307         setBaseURI(defaultBaseURI);
2308         setRoyaltyInfo(payable(defaultTreasury), 0);
2309     }
2310 
2311     //User Write ===========================
2312 
2313     ///@dev get the NFT for airdropping steam access
2314     function mintTheKey(
2315         bytes32[] calldata proof
2316     ) external payable nonReentrant {
2317         address account = msg.sender;
2318         if (_claimedKeys[account] == true) {
2319             revert YouHaveMinted();
2320         }        
2321         if (_totalMinted >= MAX_SUPPLY) {
2322             revert AllNFTsMinted();
2323         }
2324         if (_verify(_leaf(account), proof,merkleRootForKeys) == false) revert IncorrectProof();
2325 
2326         _claimedKeys[account] = true;
2327         uint256 tokenID = _totalMinted + KEY_ID_OFFSET + 1;//start from 10001
2328         ++_totalMinted;
2329         _mint(account, tokenID);
2330     }
2331 
2332     ///@dev burn a nft and get medal
2333     function mintTheMedal(
2334         uint256 theKeyNFTID,
2335         bytes32[] calldata proof
2336     ) external nonReentrant {
2337         address account = msg.sender;
2338         if (ownerOf(theKeyNFTID) != account) {
2339             revert YouAreNotOwner();
2340         }
2341         if(_claimedMedals[account] == true) {
2342             revert YouHaveMinted();
2343         }
2344         if (_verify(_leaf(account), proof, merkleRootForMedals) == false) revert IncorrectProof();
2345 
2346         _claimedMedals[account] = true;
2347         burnKeyAndMintMedal(account, theKeyNFTID);
2348     }
2349 
2350     // User Read ========================================================
2351 
2352     function totalSupply() external view returns (uint256) {
2353         return _totalMinted;
2354     }
2355 
2356     function hasClaimedKeysAndMedals(address who) external view returns (bool, bool) {
2357         return (_claimedKeys[who], _claimedMedals[who]);
2358     }
2359 
2360     ///@dev helper function for frontend
2361     function getAllNFTIDsOf(
2362         address who
2363     ) external view returns (uint256[] memory) {
2364         uint256 total = balanceOf(who);
2365         uint256[] memory nfts = new uint256[](total);
2366         uint256 count = 0;
2367         uint256 startIndex = 1;
2368         uint256 endIndex = startIndex + MAX_SUPPLY;
2369         for (uint256 i = startIndex; i < endIndex; ++i) {
2370             if( count == total ) break;
2371             if( _exists(i) == false ) continue;
2372             if(_ownerOf(i) == who){
2373                 nfts[count] = i;
2374                 ++count;
2375             }
2376         }
2377 
2378         startIndex = KEY_ID_OFFSET + 1;
2379         endIndex = startIndex + MAX_SUPPLY;
2380         for (uint256 i = startIndex; i < endIndex; ++i) {
2381             if( count == total ) break;
2382             if( _exists(i) == false ) continue;
2383             if(_ownerOf(i) == who){
2384                 nfts[count] = i;
2385                 ++count;
2386             }
2387         }
2388         return nfts;
2389     }
2390     // onlyOwner =======================================================
2391     function setBaseURI(string memory newBaseURI) public onlyOwner {
2392         _baseTokenURI = newBaseURI;
2393     }
2394 
2395     function setRoyaltyInfo(
2396         address payable newAddress,
2397         uint96 newRoyaltyPercentage
2398     ) public onlyOwner {
2399         if (newAddress == address(0)) revert CannotSetZeroAddress();
2400         treasuryAddress = newAddress;
2401         _setDefaultRoyalty(treasuryAddress, newRoyaltyPercentage);
2402     }
2403     function cannotMintKeysAnymore() public onlyOwner {
2404         setMerkeRootForKeys(0x0);
2405     }
2406     function setMerkeRootForKeys(bytes32 newRoot) public onlyOwner {
2407         merkleRootForKeys = newRoot;
2408     }
2409 
2410     function setMerkeRootForMedals(bytes32 newRoot) public onlyOwner {
2411         cannotMintKeysAnymore();
2412         merkleRootForMedals = newRoot;
2413     }
2414     //internal ===============================================
2415     function burnKeyAndMintMedal(
2416         address account,
2417         uint256 keyID
2418     ) internal returns (uint256) {
2419         if (keyID < KEY_ID_OFFSET) {
2420             revert ShouldInHighIDRange();
2421         }
2422         _burn(keyID);
2423         uint256 medalID = keyID - KEY_ID_OFFSET;
2424         _mint(account, medalID);
2425         return medalID;
2426     }
2427 
2428     function _baseURI() internal view override returns (string memory) {
2429         return _baseTokenURI;
2430     }
2431 
2432     function _verify(
2433         bytes32 leaf,
2434         bytes32[] calldata proof,
2435         bytes32 merkleRoot
2436     ) internal pure returns (bool) {
2437         return MerkleProof.verifyCalldata(proof, merkleRoot, leaf);
2438     }
2439 
2440     function _leaf(address account) internal pure returns (bytes32) {
2441         return keccak256(bytes.concat(keccak256(abi.encode(account))));
2442     }
2443 
2444     //===================== please don't touch them below =======================================
2445     function supportsInterface(
2446         bytes4 interfaceId
2447     ) public view override(ERC2981,ERC721) returns (bool) {
2448         return
2449             ERC2981.supportsInterface(interfaceId) ||
2450             super.supportsInterface(interfaceId);
2451     }
2452 
2453     function setApprovalForAll(
2454         address operator,
2455         bool approved
2456     ) public override( ERC721) onlyAllowedOperatorApproval(operator) {
2457         super.setApprovalForAll(operator, approved);
2458     }
2459 
2460     function approve(
2461         address operator,
2462         uint256 tokenId
2463     ) public override( ERC721) onlyAllowedOperatorApproval(operator) {
2464         super.approve(operator, tokenId);
2465     }
2466 
2467     function transferFrom(
2468         address from,
2469         address to,
2470         uint256 tokenId
2471     ) public override( ERC721) onlyAllowedOperator(from) {
2472         super.transferFrom(from, to, tokenId);
2473     }
2474 
2475     function safeTransferFrom(
2476         address from,
2477         address to,
2478         uint256 tokenId
2479     ) public override( ERC721) onlyAllowedOperator(from) {
2480         super.safeTransferFrom(from, to, tokenId);
2481     }
2482 
2483     function safeTransferFrom(
2484         address from,
2485         address to,
2486         uint256 tokenId,
2487         bytes memory data
2488     ) public override( ERC721) onlyAllowedOperator(from) {
2489         super.safeTransferFrom(from, to, tokenId, data);
2490     }
2491 }