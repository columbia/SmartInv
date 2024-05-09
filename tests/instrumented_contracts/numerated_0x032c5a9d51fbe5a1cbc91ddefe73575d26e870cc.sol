1 // File: contracts/libraries/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 // File: contracts/libraries/Address.sol
71 
72 
73 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
74 
75 pragma solidity ^0.8.1;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      *
98      * [IMPORTANT]
99      * ====
100      * You shouldn't rely on `isContract` to protect against flash loan attacks!
101      *
102      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
103      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
104      * constructor.
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies on extcodesize/address.code.length, which returns 0
109         // for contracts in construction, since the code is only stored at the end
110         // of the constructor execution.
111 
112         return account.code.length > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         (bool success, ) = recipient.call{value: amount}("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
219         return functionStaticCall(target, data, "Address: low-level static call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal view returns (bytes memory) {
233         require(isContract(target), "Address: static call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.delegatecall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
268      * revert reason using the provided one.
269      *
270      * _Available since v4.3._
271      */
272     function verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) internal pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 // File: contracts/interfaces/IERC721Receiver.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 // File: contracts/interfaces/IERC165.sol
323 
324 
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 // File: contracts/interfaces/IERC2981.sol
349 
350 
351 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 
356 /**
357  * @dev Interface for the NFT Royalty Standard.
358  *
359  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
360  * support for royalty payments across all NFT marketplaces and ecosystem participants.
361  *
362  * _Available since v4.5._
363  */
364 interface IERC2981 is IERC165 {
365     /**
366      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
367      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
368      */
369     function royaltyInfo(uint256 tokenId, uint256 salePrice)
370         external
371         view
372         returns (address receiver, uint256 royaltyAmount);
373 }
374 // File: contracts/ERC165.sol
375 
376 
377 
378 pragma solidity ^0.8.0;
379 
380 
381 /**
382  * @dev Implementation of the {IERC165} interface.
383  *
384  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
385  * for the additional interface id that will be supported. For example:
386  *
387  * ```solidity
388  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
390  * }
391  * ```
392  *
393  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
394  */
395 abstract contract ERC165 is IERC165 {
396     /**
397      * @dev See {IERC165-supportsInterface}.
398      */
399     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
400         return interfaceId == type(IERC165).interfaceId;
401     }
402 }
403 // File: contracts/ERC2981.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 
412 /**
413  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
414  *
415  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
416  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
417  *
418  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
419  * fee is specified in basis points by default.
420  *
421  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
422  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
423  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
424  *
425  * _Available since v4.5._
426  */
427 abstract contract ERC2981 is IERC2981, ERC165 {
428     struct RoyaltyInfo {
429         address receiver;
430         uint96 royaltyFraction;
431     }
432 
433     RoyaltyInfo private _defaultRoyaltyInfo;
434     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
435 
436     /**
437      * @dev See {IERC165-supportsInterface}.
438      */
439     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
440         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
441     }
442 
443     /**
444      * @inheritdoc IERC2981
445      */
446     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
447         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
448 
449         if (royalty.receiver == address(0)) {
450             royalty = _defaultRoyaltyInfo;
451         }
452 
453         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
454 
455         return (royalty.receiver, royaltyAmount);
456     }
457 
458     /**
459      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
460      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
461      * override.
462      */
463     function _feeDenominator() internal pure virtual returns (uint96) {
464         return 10000;
465     }
466 
467     /**
468      * @dev Sets the royalty information that all ids in this contract will default to.
469      *
470      * Requirements:
471      *
472      * - `receiver` cannot be the zero address.
473      * - `feeNumerator` cannot be greater than the fee denominator.
474      */
475     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
476         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
477         require(receiver != address(0), "ERC2981: invalid receiver");
478 
479         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
480     }
481 
482     /**
483      * @dev Removes default royalty information.
484      */
485     function _deleteDefaultRoyalty() internal virtual {
486         delete _defaultRoyaltyInfo;
487     }
488 
489     /**
490      * @dev Sets the royalty information for a specific token id, overriding the global default.
491      *
492      * Requirements:
493      *
494      * - `receiver` cannot be the zero address.
495      * - `feeNumerator` cannot be greater than the fee denominator.
496      */
497     function _setTokenRoyalty(
498         uint256 tokenId,
499         address receiver,
500         uint96 feeNumerator
501     ) internal virtual {
502         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
503         require(receiver != address(0), "ERC2981: Invalid parameters");
504 
505         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
506     }
507 
508     /**
509      * @dev Resets royalty information for the token id back to the global default.
510      */
511     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
512         delete _tokenRoyaltyInfo[tokenId];
513     }
514 }
515 // File: contracts/interfaces/IERC721.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @dev Required interface of an ERC721 compliant contract.
524  */
525 interface IERC721 is IERC165 {
526     /**
527      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
528      */
529     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
533      */
534     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
535 
536     /**
537      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
538      */
539     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
540 
541     /**
542      * @dev Returns the number of tokens in ``owner``'s account.
543      */
544     function balanceOf(address owner) external view returns (uint256 balance);
545 
546     /**
547      * @dev Returns the owner of the `tokenId` token.
548      *
549      * Requirements:
550      *
551      * - `tokenId` must exist.
552      */
553     function ownerOf(uint256 tokenId) external view returns (address owner);
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must exist and be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external;
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
577      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId
593     ) external;
594 
595     /**
596      * @dev Transfers `tokenId` token from `from` to `to`.
597      *
598      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
617      * The approval is cleared when the token is transferred.
618      *
619      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
620      *
621      * Requirements:
622      *
623      * - The caller must own the token or be an approved operator.
624      * - `tokenId` must exist.
625      *
626      * Emits an {Approval} event.
627      */
628     function approve(address to, uint256 tokenId) external;
629 
630     /**
631      * @dev Approve or remove `operator` as an operator for the caller.
632      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
633      *
634      * Requirements:
635      *
636      * - The `operator` cannot be the caller.
637      *
638      * Emits an {ApprovalForAll} event.
639      */
640     function setApprovalForAll(address operator, bool _approved) external;
641 
642     /**
643      * @dev Returns the account approved for `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function getApproved(uint256 tokenId) external view returns (address operator);
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 }
658 // File: contracts/interfaces/IERC721Metadata.sol
659 
660 
661 
662 pragma solidity ^0.8.0;
663 
664 
665 /**
666  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
667  * @dev See https://eips.ethereum.org/EIPS/eip-721
668  */
669 interface IERC721Metadata is IERC721 {
670     /**
671      * @dev Returns the token collection name.
672      */
673     function name() external view returns (string memory);
674 
675     /**
676      * @dev Returns the token collection symbol.
677      */
678     function symbol() external view returns (string memory);
679 
680     /**
681      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
682      */
683     function tokenURI(uint256 tokenId) external view returns (string memory);
684 }
685 // File: contracts/interfaces/IERC721A.sol
686 
687 
688 // ERC721A Contracts v3.3.0
689 // Creator: Chiru Labs
690 
691 pragma solidity ^0.8.4;
692 
693 
694 
695 /**
696  * @dev Interface of an ERC721A compliant contract.
697  */
698 interface IERC721A is IERC721, IERC721Metadata {
699     /**
700      * The caller must own the token or be an approved operator.
701      */
702     error ApprovalCallerNotOwnerNorApproved();
703 
704     /**
705      * The token does not exist.
706      */
707     error ApprovalQueryForNonexistentToken();
708 
709     /**
710      * The caller cannot approve to their own address.
711      */
712     error ApproveToCaller();
713 
714     /**
715      * The caller cannot approve to the current owner.
716      */
717     error ApprovalToCurrentOwner();
718 
719     /**
720      * Cannot query the balance for the zero address.
721      */
722     error BalanceQueryForZeroAddress();
723 
724     /**
725      * Cannot mint to the zero address.
726      */
727     error MintToZeroAddress();
728 
729     /**
730      * The quantity of tokens minted must be more than zero.
731      */
732     error MintZeroQuantity();
733 
734     /**
735      * The token does not exist.
736      */
737     error OwnerQueryForNonexistentToken();
738 
739     /**
740      * The caller must own the token or be an approved operator.
741      */
742     error TransferCallerNotOwnerNorApproved();
743 
744     /**
745      * The token must be owned by `from`.
746      */
747     error TransferFromIncorrectOwner();
748 
749     /**
750      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
751      */
752     error TransferToNonERC721ReceiverImplementer();
753 
754     /**
755      * Cannot transfer to the zero address.
756      */
757     error TransferToZeroAddress();
758 
759     /**
760      * The token does not exist.
761      */
762     error URIQueryForNonexistentToken();
763 
764     // Compiler will pack this into a single 256bit word.
765     struct TokenOwnership {
766         // The address of the owner.
767         address addr;
768         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
769         uint64 startTimestamp;
770         // Whether the token has been burned.
771         bool burned;
772     }
773 
774     // Compiler will pack this into a single 256bit word.
775     struct AddressData {
776         // Realistically, 2**64-1 is more than enough.
777         uint64 balance;
778         // Keeps track of mint count with minimal overhead for tokenomics.
779         uint64 numberMinted;
780         // Keeps track of burn count with minimal overhead for tokenomics.
781         uint64 numberBurned;
782         // For miscellaneous variable(s) pertaining to the address
783         // (e.g. number of whitelist mint slots used).
784         // If there are multiple variables, please pack them into a uint64.
785         uint64 aux;
786     }
787 
788     /**
789      * @dev Returns the total amount of tokens stored by the contract.
790      * 
791      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
792      */
793     function totalSupply() external view returns (uint256);
794 
795     /**
796      * @dev Burns `tokenId`. See {ERC721A-_burn}.
797      *
798      * Requirements:
799      *
800      * - The caller must own `tokenId` or be an approved operator.
801      */
802     function burn(uint256 tokenId) external;
803 }
804 // File: contracts/interfaces/IOperatorFilterRegistry.sol
805 
806 
807 pragma solidity ^0.8.13;
808 
809 interface IOperatorFilterRegistry {
810     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
811     function register(address registrant) external;
812     function registerAndSubscribe(address registrant, address subscription) external;
813     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
814     function unregister(address addr) external;
815     function updateOperator(address registrant, address operator, bool filtered) external;
816     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
817     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
818     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
819     function subscribe(address registrant, address registrantToSubscribe) external;
820     function unsubscribe(address registrant, bool copyExistingEntries) external;
821     function subscriptionOf(address addr) external returns (address registrant);
822     function subscribers(address registrant) external returns (address[] memory);
823     function subscriberAt(address registrant, uint256 index) external returns (address);
824     function copyEntriesOf(address registrant, address registrantToCopy) external;
825     function isOperatorFiltered(address registrant, address operator) external returns (bool);
826     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
827     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
828     function filteredOperators(address addr) external returns (address[] memory);
829     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
830     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
831     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
832     function isRegistered(address addr) external returns (bool);
833     function codeHashOf(address addr) external returns (bytes32);
834 }
835 
836 // File: contracts/abstracts/OperatorFilterer.sol
837 
838 
839 pragma solidity ^0.8.13;
840 
841 
842 /**
843  * @title  OperatorFilterer
844  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
845  *         registrant's entries in the OperatorFilterRegistry.
846  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
847  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
848  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
849  */
850 abstract contract OperatorFilterer {
851     error OperatorNotAllowed(address operator);
852 
853     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
854         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
855 
856     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
857         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
858         // will not revert, but the contract will need to be registered with the registry once it is deployed in
859         // order for the modifier to filter addresses.
860         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
861             if (subscribe) {
862                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
863             } else {
864                 if (subscriptionOrRegistrantToCopy != address(0)) {
865                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
866                 } else {
867                     OPERATOR_FILTER_REGISTRY.register(address(this));
868                 }
869             }
870         }
871     }
872 
873     modifier onlyAllowedOperator(address from) virtual {
874         // Allow spending tokens from addresses with balance
875         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
876         // from an EOA.
877         if (from != msg.sender) {
878             _checkFilterOperator(msg.sender);
879         }
880         _;
881     }
882 
883     modifier onlyAllowedOperatorApproval(address operator) virtual {
884         _checkFilterOperator(operator);
885         _;
886     }
887 
888     function _checkFilterOperator(address operator) internal view virtual {
889         // Check registry code length to facilitate testing in environments without a deployed registry.
890         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
891             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
892                 revert OperatorNotAllowed(operator);
893             }
894         }
895     }
896 }
897 
898 // File: contracts/abstracts/DefaultOperatorFilterer.sol
899 
900 
901 pragma solidity ^0.8.13;
902 
903 
904 /**
905  * @title  DefaultOperatorFilterer
906  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
907  */
908 abstract contract DefaultOperatorFilterer is OperatorFilterer {
909     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
910 
911     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
912 }
913 
914 // File: contracts/abstracts/ReentrancyGuard.sol
915 
916 
917 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 /**
922  * @dev Contract module that helps prevent reentrant calls to a function.
923  *
924  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
925  * available, which can be applied to functions to make sure there are no nested
926  * (reentrant) calls to them.
927  *
928  * Note that because there is a single `nonReentrant` guard, functions marked as
929  * `nonReentrant` may not call one another. This can be worked around by making
930  * those functions `private`, and then adding `external` `nonReentrant` entry
931  * points to them.
932  *
933  * TIP: If you would like to learn more about reentrancy and alternative ways
934  * to protect against it, check out our blog post
935  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
936  */
937 abstract contract ReentrancyGuard {
938     // Booleans are more expensive than uint256 or any type that takes up a full
939     // word because each write operation emits an extra SLOAD to first read the
940     // slot's contents, replace the bits taken up by the boolean, and then write
941     // back. This is the compiler's defense against contract upgrades and
942     // pointer aliasing, and it cannot be disabled.
943 
944     // The values being non-zero value makes deployment a bit more expensive,
945     // but in exchange the refund on every call to nonReentrant will be lower in
946     // amount. Since refunds are capped to a percentage of the total
947     // transaction's gas, it is best to keep them low in cases like this one, to
948     // increase the likelihood of the full refund coming into effect.
949     uint256 private constant _NOT_ENTERED = 1;
950     uint256 private constant _ENTERED = 2;
951 
952     uint256 private _status;
953 
954     constructor() {
955         _status = _NOT_ENTERED;
956     }
957 
958     /**
959      * @dev Prevents a contract from calling itself, directly or indirectly.
960      * Calling a `nonReentrant` function from another `nonReentrant`
961      * function is not supported. It is possible to prevent this from happening
962      * by making the `nonReentrant` function external, and making it call a
963      * `private` function that does the actual work.
964      */
965     modifier nonReentrant() {
966         // On the first call to nonReentrant, _notEntered will be true
967         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
968 
969         // Any calls to nonReentrant after this point will fail
970         _status = _ENTERED;
971 
972         _;
973 
974         // By storing the original value once again, a refund is triggered (see
975         // https://eips.ethereum.org/EIPS/eip-2200)
976         _status = _NOT_ENTERED;
977     }
978 }
979 // File: contracts/abstracts/Context.sol
980 
981 
982 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 /**
987  * @dev Provides information about the current execution context, including the
988  * sender of the transaction and its data. While these are generally available
989  * via msg.sender and msg.data, they should not be accessed in such a direct
990  * manner, since when dealing with meta-transactions the account sending and
991  * paying for execution may not be the actual sender (as far as an application
992  * is concerned).
993  *
994  * This contract is only required for intermediate, library-like contracts.
995  */
996 abstract contract Context {
997     function _msgSender() internal view virtual returns (address) {
998         return msg.sender;
999     }
1000 
1001     function _msgData() internal view virtual returns (bytes calldata) {
1002         return msg.data;
1003     }
1004 }
1005 // File: contracts/abstracts/Ownable.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 /**
1014  * @dev Contract module which provides a basic access control mechanism, where
1015  * there is an account (an owner) that can be granted exclusive access to
1016  * specific functions.
1017  *
1018  * By default, the owner account will be the one that deploys the contract. This
1019  * can later be changed with {transferOwnership}.
1020  *
1021  * This module is used through inheritance. It will make available the modifier
1022  * `onlyOwner`, which can be applied to your functions to restrict their use to
1023  * the owner.
1024  */
1025 abstract contract Ownable is Context {
1026     address private _owner;
1027 
1028     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1029 
1030     /**
1031      * @dev Initializes the contract setting the deployer as the initial owner.
1032      */
1033     constructor() {
1034         _transferOwnership(_msgSender());
1035     }
1036 
1037     /**
1038      * @dev Returns the address of the current owner.
1039      */
1040     function owner() public view virtual returns (address) {
1041         return _owner;
1042     }
1043 
1044     /**
1045      * @dev Throws if called by any account other than the owner.
1046      */
1047     modifier onlyOwner() {
1048         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1049         _;
1050     }
1051 
1052     /**
1053      * @dev Leaves the contract without owner. It will not be possible to call
1054      * `onlyOwner` functions anymore. Can only be called by the current owner.
1055      *
1056      * NOTE: Renouncing ownership will leave the contract without an owner,
1057      * thereby removing any functionality that is only available to the owner.
1058      */
1059     function renounceOwnership() public virtual onlyOwner {
1060         _transferOwnership(address(0));
1061     }
1062 
1063     /**
1064      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1065      * Can only be called by the current owner.
1066      */
1067     function transferOwnership(address newOwner) public virtual onlyOwner {
1068         require(newOwner != address(0), "Ownable: new owner is the zero address");
1069         _transferOwnership(newOwner);
1070     }
1071 
1072     /**
1073      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1074      * Internal function without access restriction.
1075      */
1076     function _transferOwnership(address newOwner) internal virtual {
1077         address oldOwner = _owner;
1078         _owner = newOwner;
1079         emit OwnershipTransferred(oldOwner, newOwner);
1080     }
1081 }
1082 // File: contracts/JRS.sol
1083 
1084 
1085 // ERC721A with Royalties ERC2981
1086 
1087 /*
1088                       888888888888                                                                
1089                     8888888888888888            888888888   888888888888             8888888   
1090                    888888888888888888            8888888     8888888888888         888888888888 
1091                   88888888888888888888             8888       888      8888      8888       8888 
1092                   88888888888888888888              888       888       8888     8888         88 
1093                    888888888888888888               888       888       8888      888888         
1094                    888    8888    888               888       888      8888        8888888888    
1095                    888    8888    888               888       88888888888            8888888888 
1096             88      8888888  8888888     88         888       888     888                 888888
1097           8888888      8888888888     8888888       888       888      888      88         88888
1098           88888888888    888888    88888888888      888       888        888    888         8888 
1099            888    8888888      88888888    88       888      88888       8888    88888888888888 
1100                      8888888888888                  888    888888888    8888888    888888888     
1101              8888  8888888    8888888  888    88   8888                                            
1102               888888888            88888888   88888888                                             
1103                88                     888       8888
1104 */
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 
1116 
1117 
1118 /**
1119  * @dev Implementation of ERC721A Non-Fungible Token Standard, including
1120  * the Metadata extension. Built to optimize for lower gas during batch mints.
1121  */
1122 contract JRS is Context, ERC165, IERC721A, ERC2981, Ownable, ReentrancyGuard, DefaultOperatorFilterer{
1123     using Address for address;
1124     using Strings for uint256;
1125 
1126     // The tokenId of the next token to be minted.
1127     uint256 internal _currentIndex;
1128 
1129     // The number of tokens burned.
1130     uint256 internal _burnCounter;
1131 
1132     string private constant _name = "Jolly Roger Society";
1133     string private constant _symbol = "JRS";
1134     uint16 public constant _max = 4444;
1135 
1136     // Mapping from token ID to ownership details
1137     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1138     mapping(uint256 => TokenOwnership) internal _ownerships;
1139 
1140     // Mapping owner address to address data
1141     mapping(address => AddressData) private _addressData;
1142 
1143     // Mapping from token ID to approved address
1144     mapping(uint256 => address) private _tokenApprovals;
1145 
1146     // Mapping from owner to operator approvals
1147     mapping(address => mapping(address => bool)) private _operatorApprovals;
1148 
1149     /**
1150      * To change the starting tokenId, please override this function.
1151      */
1152     function _startTokenId() internal view virtual returns (uint256) {
1153         return 1;
1154     }
1155 
1156     /**
1157      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1158      */
1159     function totalSupply() public view override returns (uint256) {
1160         // Counter underflow is impossible as _burnCounter cannot be incremented
1161         // more than _currentIndex - _startTokenId() times
1162         unchecked {
1163             return _currentIndex - _burnCounter - _startTokenId();
1164         }
1165     }
1166 
1167     /**
1168      * Returns the total amount of tokens minted in the contract.
1169      */
1170     function _totalMinted() internal view returns (uint256) {
1171         // Counter underflow is impossible as _currentIndex does not decrement,
1172         // and it is initialized to _startTokenId()
1173         unchecked {
1174             return _currentIndex - _startTokenId();
1175         }
1176     }
1177 
1178     /**
1179      * @dev See {IERC165-supportsInterface}.
1180      */
1181     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165, ERC2981) returns (bool) {
1182         return
1183             interfaceId == type(IERC721).interfaceId ||
1184             interfaceId == type(IERC721Metadata).interfaceId ||
1185             super.supportsInterface(interfaceId);
1186     }
1187 
1188     /**
1189      * @dev See {IERC721-balanceOf}.
1190      */
1191     function balanceOf(address owner) public view override returns (uint256) {
1192         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1193         return uint256(_addressData[owner].balance);
1194     }
1195 
1196     /**
1197      * Returns the number of tokens minted by `owner`.
1198      */
1199     function _numberMinted(address owner) internal view returns (uint256) {
1200         return uint256(_addressData[owner].numberMinted);
1201     }
1202 
1203     /**
1204      * Returns the number of tokens burned by or on behalf of `owner`.
1205      */
1206     function _numberBurned(address owner) internal view returns (uint256) {
1207         return uint256(_addressData[owner].numberBurned);
1208     }
1209 
1210     /**
1211      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1212      */
1213     function _getAux(address owner) internal view returns (uint64) {
1214         return _addressData[owner].aux;
1215     }
1216 
1217     /**
1218      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1219      * If there are multiple variables, please pack them into a uint64.
1220      */
1221     function _setAux(address owner, uint64 aux) internal {
1222         _addressData[owner].aux = aux;
1223     }
1224 
1225     /**
1226      * Gas spent here starts off proportional to the maximum mint batch size.
1227      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1228      */
1229     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1230         uint256 curr = tokenId;
1231 
1232         unchecked {
1233             if (_startTokenId() <= curr && curr < _currentIndex) {
1234                 TokenOwnership memory ownership = _ownerships[curr];
1235                 if (!ownership.burned) {
1236                     if (ownership.addr != address(0)) {
1237                         return ownership;
1238                     }
1239                     // Invariant:
1240                     // There will always be an ownership that has an address and is not burned
1241                     // before an ownership that does not have an address and is not burned.
1242                     // Hence, curr will not underflow.
1243                     while (true) {
1244                         curr--;
1245                         ownership = _ownerships[curr];
1246                         if (ownership.addr != address(0)) {
1247                             return ownership;
1248                         }
1249                     }
1250                 }
1251             }
1252         }
1253         revert OwnerQueryForNonexistentToken();
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-ownerOf}.
1258      */
1259     function ownerOf(uint256 tokenId) public view override returns (address) {
1260         return _ownershipOf(tokenId).addr;
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Metadata-name}.
1265      */
1266     function name() public view virtual override returns (string memory) {
1267         return _name;
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Metadata-symbol}.
1272      */
1273     function symbol() public view virtual override returns (string memory) {
1274         return _symbol;
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-approve}.
1279      */
1280     function approve(address to, uint256 tokenId) public override {
1281         address owner = ownerOf(tokenId);
1282         if (to == owner) revert ApprovalToCurrentOwner();
1283 
1284         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1285             revert ApprovalCallerNotOwnerNorApproved();
1286         }
1287 
1288         _approve(to, tokenId, owner);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-getApproved}.
1293      */
1294     function getApproved(uint256 tokenId) public view override returns (address) {
1295         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1296 
1297         return _tokenApprovals[tokenId];
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-setApprovalForAll}.
1302      */
1303     function setApprovalForAll(address operator, bool approved) public virtual override {
1304         if (operator == _msgSender()) revert ApproveToCaller();
1305 
1306         _operatorApprovals[_msgSender()][operator] = approved;
1307         emit ApprovalForAll(_msgSender(), operator, approved);
1308     }
1309 
1310     /**
1311      * @dev See {IERC721-isApprovedForAll}.
1312      */
1313     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1314         return _operatorApprovals[owner][operator];
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-transferFrom}.
1319      */
1320     function transferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) public virtual override onlyAllowedOperator(from) {
1325         _transfer(from, to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-safeTransferFrom}.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) public virtual override onlyAllowedOperator(from) {
1336         safeTransferFrom(from, to, tokenId, '');
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-safeTransferFrom}.
1341      */
1342     function safeTransferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) public virtual override onlyAllowedOperator(from) {
1348         _transfer(from, to, tokenId);
1349         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1350             revert TransferToNonERC721ReceiverImplementer();
1351         }
1352     }
1353 
1354     /**
1355      * @dev Returns whether `tokenId` exists.
1356      *
1357      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1358      *
1359      * Tokens start existing when they are minted (`_mint`),
1360      */
1361     function _exists(uint256 tokenId) internal view returns (bool) {
1362         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1363     }
1364 
1365     /**
1366      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1367      */
1368     function _safeMint(address to, uint256 quantity) internal {
1369         _safeMint(to, quantity, '');
1370     }
1371 
1372     /**
1373      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - If `to` refers to a smart contract, it must implement
1378      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1379      * - `quantity` must be greater than 0.
1380      *
1381      * Emits a {Transfer} event.
1382      */
1383     function _safeMint(
1384         address to,
1385         uint256 quantity,
1386         bytes memory _data
1387     ) internal {
1388         uint256 startTokenId = _currentIndex;
1389         if (to == address(0)) revert MintToZeroAddress();
1390         if (quantity == 0) revert MintZeroQuantity();
1391 
1392         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1393 
1394         // Overflows are incredibly unrealistic.
1395         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1396         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1397         unchecked {
1398             _addressData[to].balance += uint64(quantity);
1399             _addressData[to].numberMinted += uint64(quantity);
1400 
1401             _ownerships[startTokenId].addr = to;
1402             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1403 
1404             uint256 updatedIndex = startTokenId;
1405             uint256 end = updatedIndex + quantity;
1406 
1407             if (to.isContract()) {
1408                 do {
1409                     emit Transfer(address(0), to, updatedIndex);
1410                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1411                         revert TransferToNonERC721ReceiverImplementer();
1412                     }
1413                 } while (updatedIndex < end);
1414                 // Reentrancy protection
1415                 if (_currentIndex != startTokenId) revert();
1416             } else {
1417                 do {
1418                     emit Transfer(address(0), to, updatedIndex++);
1419                 } while (updatedIndex < end);
1420             }
1421             _currentIndex = updatedIndex;
1422         }
1423         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1424     }
1425 
1426     /**
1427      * @dev Mints `quantity` tokens and transfers them to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `to` cannot be the zero address.
1432      * - `quantity` must be greater than 0.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _mint(address to, uint256 quantity) internal {
1437         uint256 startTokenId = _currentIndex;
1438         if (to == address(0)) revert MintToZeroAddress();
1439         if (quantity == 0) revert MintZeroQuantity();
1440 
1441         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1442 
1443         // Overflows are incredibly unrealistic.
1444         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1445         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1446         unchecked {
1447             _addressData[to].balance += uint64(quantity);
1448             _addressData[to].numberMinted += uint64(quantity);
1449 
1450             _ownerships[startTokenId].addr = to;
1451             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1452 
1453             uint256 updatedIndex = startTokenId;
1454             uint256 end = updatedIndex + quantity;
1455 
1456             do {
1457                 emit Transfer(address(0), to, updatedIndex++);
1458             } while (updatedIndex < end);
1459 
1460             _currentIndex = updatedIndex;
1461         }
1462         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1463     }
1464 
1465     /**
1466      * @dev Transfers `tokenId` from `from` to `to`.
1467      *
1468      * Requirements:
1469      *
1470      * - `to` cannot be the zero address.
1471      * - `tokenId` token must be owned by `from`.
1472      *
1473      * Emits a {Transfer} event.
1474      */
1475     function _transfer(
1476         address from,
1477         address to,
1478         uint256 tokenId
1479     ) private {
1480         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1481 
1482         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1483 
1484         bool isApprovedOrOwner = (_msgSender() == from ||
1485             isApprovedForAll(from, _msgSender()) ||
1486             getApproved(tokenId) == _msgSender());
1487 
1488         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1489         if (to == address(0)) revert TransferToZeroAddress();
1490 
1491         _beforeTokenTransfers(from, to, tokenId, 1);
1492 
1493         // Clear approvals from the previous owner
1494         _approve(address(0), tokenId, from);
1495 
1496         // Underflow of the sender's balance is impossible because we check for
1497         // ownership above and the recipient's balance can't realistically overflow.
1498         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1499         unchecked {
1500             _addressData[from].balance -= 1;
1501             _addressData[to].balance += 1;
1502 
1503             TokenOwnership storage currSlot = _ownerships[tokenId];
1504             currSlot.addr = to;
1505             currSlot.startTimestamp = uint64(block.timestamp);
1506 
1507             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1508             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1509             uint256 nextTokenId = tokenId + 1;
1510             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1511             if (nextSlot.addr == address(0)) {
1512                 // This will suffice for checking _exists(nextTokenId),
1513                 // as a burned slot cannot contain the zero address.
1514                 if (nextTokenId != _currentIndex) {
1515                     nextSlot.addr = from;
1516                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1517                 }
1518             }
1519         }
1520 
1521         emit Transfer(from, to, tokenId);
1522         _afterTokenTransfers(from, to, tokenId, 1);
1523     }
1524 
1525     /**
1526      * @dev Equivalent to `_burn(tokenId, false)`.
1527      */
1528     function _burn(uint256 tokenId) internal virtual {
1529         _burn(tokenId, false);
1530     }
1531 
1532     /**
1533      * @dev Destroys `tokenId`.
1534      * The approval is cleared when the token is burned.
1535      *
1536      * Requirements:
1537      *
1538      * - `tokenId` must exist.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1543         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1544 
1545         address from = prevOwnership.addr;
1546 
1547         if (approvalCheck) {
1548             bool isApprovedOrOwner = (_msgSender() == from ||
1549                 isApprovedForAll(from, _msgSender()) ||
1550                 getApproved(tokenId) == _msgSender());
1551 
1552             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1553         }
1554 
1555         _beforeTokenTransfers(from, address(0), tokenId, 1);
1556 
1557         // Clear approvals from the previous owner
1558         _approve(address(0), tokenId, from);
1559 
1560         // Underflow of the sender's balance is impossible because we check for
1561         // ownership above and the recipient's balance can't realistically overflow.
1562         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1563         unchecked {
1564             AddressData storage addressData = _addressData[from];
1565             addressData.balance -= 1;
1566             addressData.numberBurned += 1;
1567 
1568             // Keep track of who burned the token, and the timestamp of burning.
1569             TokenOwnership storage currSlot = _ownerships[tokenId];
1570             currSlot.addr = from;
1571             currSlot.startTimestamp = uint64(block.timestamp);
1572             currSlot.burned = true;
1573 
1574             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1575             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1576             uint256 nextTokenId = tokenId + 1;
1577             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1578             if (nextSlot.addr == address(0)) {
1579                 // This will suffice for checking _exists(nextTokenId),
1580                 // as a burned slot cannot contain the zero address.
1581                 if (nextTokenId != _currentIndex) {
1582                     nextSlot.addr = from;
1583                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1584                 }
1585             }
1586         }
1587 
1588         emit Transfer(from, address(0), tokenId);
1589         _afterTokenTransfers(from, address(0), tokenId, 1);
1590 
1591         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1592         unchecked {
1593             _burnCounter++;
1594         }
1595     }
1596 
1597     /**
1598      * @dev Approve `to` to operate on `tokenId`
1599      *
1600      * Emits a {Approval} event.
1601      */
1602     function _approve(
1603         address to,
1604         uint256 tokenId,
1605         address owner
1606     ) private {
1607         _tokenApprovals[tokenId] = to;
1608         emit Approval(owner, to, tokenId);
1609     }
1610 
1611     /**
1612      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1613      *
1614      * @param from address representing the previous owner of the given token ID
1615      * @param to target address that will receive the tokens
1616      * @param tokenId uint256 ID of the token to be transferred
1617      * @param _data bytes optional data to send along with the call
1618      * @return bool whether the call correctly returned the expected magic value
1619      */
1620     function _checkContractOnERC721Received(
1621         address from,
1622         address to,
1623         uint256 tokenId,
1624         bytes memory _data
1625     ) private returns (bool) {
1626         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1627             return retval == IERC721Receiver(to).onERC721Received.selector;
1628         } catch (bytes memory reason) {
1629             if (reason.length == 0) {
1630                 revert TransferToNonERC721ReceiverImplementer();
1631             } else {
1632                 assembly {
1633                     revert(add(32, reason), mload(reason))
1634                 }
1635             }
1636         }
1637     }
1638 
1639     /**
1640      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1641      * And also called before burning one token.
1642      *
1643      * startTokenId - the first token id to be transferred
1644      * quantity - the amount to be transferred
1645      *
1646      * Calling conditions:
1647      *
1648      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1649      * transferred to `to`.
1650      * - When `from` is zero, `tokenId` will be minted for `to`.
1651      * - When `to` is zero, `tokenId` will be burned by `from`.
1652      * - `from` and `to` are never both zero.
1653      */
1654     function _beforeTokenTransfers(
1655         address from,
1656         address to,
1657         uint256 startTokenId,
1658         uint256 quantity
1659     ) internal virtual {}
1660 
1661     /**
1662      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1663      * minting.
1664      * And also called after one token has been burned.
1665      *
1666      * startTokenId - the first token id to be transferred
1667      * quantity - the amount to be transferred
1668      *
1669      * Calling conditions:
1670      *
1671      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1672      * transferred to `to`.
1673      * - When `from` is zero, `tokenId` has been minted for `to`.
1674      * - When `to` is zero, `tokenId` has been burned by `from`.
1675      * - `from` and `to` are never both zero.
1676      */
1677     function _afterTokenTransfers(
1678         address from,
1679         address to,
1680         uint256 startTokenId,
1681         uint256 quantity
1682     ) internal virtual {}
1683 
1684 
1685     /**
1686      * @dev burnable token
1687      */
1688 
1689     function burn(uint256 tokenId) public virtual override onlyOwner {
1690         _burn(tokenId, true);
1691     }
1692 
1693     /**
1694      * @dev Set Royalties
1695      */
1696 
1697     function setRoyaltyInfo(address receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1698         _setDefaultRoyalty(receiver, _royaltyFeesInBips);
1699     }
1700 
1701     function deleteDefaultRoyalty() public onlyOwner() {
1702         _deleteDefaultRoyalty();
1703     }
1704 
1705     string private _contractURI;
1706 
1707     function contractURI() public view returns (string memory) {
1708         return _contractURI;
1709     }
1710 
1711     function setContractURI(string calldata _uri) public onlyOwner() {
1712         _contractURI = _uri;
1713     }
1714 
1715     /**
1716      * @dev Token URI
1717      */
1718 
1719     string public _baseURI;
1720 
1721     function setBaseURI(string memory newURI) external virtual onlyOwner() {
1722         _baseURI = newURI;
1723     }
1724     
1725     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1726         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1727         string memory baseURI = _baseURI;
1728         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1729     }
1730 
1731     /**
1732      * @dev Minting Token
1733      */
1734     receive() external payable {}
1735 
1736     /**
1737      * @dev white listing
1738      */
1739 
1740      bytes32 public root;
1741 
1742      function setRoot(bytes32 _root) external onlyOwner() {
1743          root = _root;
1744      }
1745 
1746     function mint(uint256 quantity) public isPaused() nonReentrant() returns (uint) {
1747         
1748         require(totalSupply() + quantity <= _max, "Max JRS Mint Reached");
1749         require(_numberMinted(_msgSender()) + quantity <= 2 || owner() == _msgSender(), "Max JRS per address is 2");
1750         _safeMint(_msgSender(), quantity);
1751         return _currentIndex;
1752     }
1753 
1754     function numberMinted(address owner) public view returns (uint256) {
1755         return _numberMinted(owner);
1756     }
1757 
1758     function totalMinted() public view returns (uint256) {
1759         return _totalMinted();
1760     }
1761 
1762     function exists(uint256 tokenId) public view returns (bool) {
1763         return _exists(tokenId);
1764     }
1765 
1766     /**
1767      * @dev Get and set Auxiliaries
1768      */
1769 
1770     function getAux(address owner) public view returns (uint64) {
1771         return _getAux(owner);
1772     }
1773 
1774     function setAux(address owner, uint64 aux) public onlyOwner() {
1775         _setAux(owner, aux);
1776     }
1777 
1778     /**
1779      * @dev pausable mint
1780      */
1781     
1782     bool public pause;
1783 
1784     function pauseMinting() external onlyOwner() {
1785         pause = !pause;
1786     }
1787 
1788     modifier isPaused() {
1789         require(!pause, 'mint has been paused');
1790         _;
1791     }
1792 
1793 
1794     /**
1795      * @dev Instantiate Contract Constructor
1796      */
1797     constructor() {
1798         _currentIndex = _startTokenId();
1799     }
1800 
1801 }