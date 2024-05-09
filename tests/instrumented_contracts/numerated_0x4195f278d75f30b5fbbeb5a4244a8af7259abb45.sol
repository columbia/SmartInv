1 // File: interfaces/IToeken.sol
2 
3 
4 pragma solidity ^0.8.12;
5 
6 interface IToeken {
7     function update(address from, address to) external;
8 }
9 // File: @openzeppelin/contracts/utils/Address.sol
10 
11 
12 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
13 
14 pragma solidity ^0.8.1;
15 
16 /**
17  * @dev Collection of functions related to the address type
18  */
19 library Address {
20     /**
21      * @dev Returns true if `account` is a contract.
22      *
23      * [IMPORTANT]
24      * ====
25      * It is unsafe to assume that an address for which this function returns
26      * false is an externally-owned account (EOA) and not a contract.
27      *
28      * Among others, `isContract` will return false for the following
29      * types of addresses:
30      *
31      *  - an externally-owned account
32      *  - a contract in construction
33      *  - an address where a contract will be created
34      *  - an address where a contract lived, but was destroyed
35      * ====
36      *
37      * [IMPORTANT]
38      * ====
39      * You shouldn't rely on `isContract` to protect against flash loan attacks!
40      *
41      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
42      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
43      * constructor.
44      * ====
45      */
46     function isContract(address account) internal view returns (bool) {
47         // This method relies on extcodesize/address.code.length, which returns 0
48         // for contracts in construction, since the code is only stored at the end
49         // of the constructor execution.
50 
51         return account.code.length > 0;
52     }
53 
54     /**
55      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
56      * `recipient`, forwarding all available gas and reverting on errors.
57      *
58      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
59      * of certain opcodes, possibly making contracts go over the 2300 gas limit
60      * imposed by `transfer`, making them unable to receive funds via
61      * `transfer`. {sendValue} removes this limitation.
62      *
63      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
64      *
65      * IMPORTANT: because control is transferred to `recipient`, care must be
66      * taken to not create reentrancy vulnerabilities. Consider using
67      * {ReentrancyGuard} or the
68      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
69      */
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(address(this).balance >= amount, "Address: insufficient balance");
72 
73         (bool success, ) = recipient.call{value: amount}("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76 
77     /**
78      * @dev Performs a Solidity function call using a low level `call`. A
79      * plain `call` is an unsafe replacement for a function call: use this
80      * function instead.
81      *
82      * If `target` reverts with a revert reason, it is bubbled up by this
83      * function (like regular Solidity function calls).
84      *
85      * Returns the raw returned data. To convert to the expected return value,
86      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
87      *
88      * Requirements:
89      *
90      * - `target` must be a contract.
91      * - calling `target` with `data` must not revert.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(
106         address target,
107         bytes memory data,
108         string memory errorMessage
109     ) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
115      * but also transferring `value` wei to `target`.
116      *
117      * Requirements:
118      *
119      * - the calling contract must have an ETH balance of at least `value`.
120      * - the called Solidity function must be `payable`.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value
128     ) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
134      * with `errorMessage` as a fallback revert reason when `target` reverts.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(
139         address target,
140         bytes memory data,
141         uint256 value,
142         string memory errorMessage
143     ) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         require(isContract(target), "Address: call to non-contract");
146 
147         (bool success, bytes memory returndata) = target.call{value: value}(data);
148         return verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
158         return functionStaticCall(target, data, "Address: low-level static call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal view returns (bytes memory) {
172         require(isContract(target), "Address: static call to non-contract");
173 
174         (bool success, bytes memory returndata) = target.staticcall(data);
175         return verifyCallResult(success, returndata, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(isContract(target), "Address: delegate call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.delegatecall(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
207      * revert reason using the provided one.
208      *
209      * _Available since v4.3._
210      */
211     function verifyCallResult(
212         bool success,
213         bytes memory returndata,
214         string memory errorMessage
215     ) internal pure returns (bytes memory) {
216         if (success) {
217             return returndata;
218         } else {
219             // Look for revert reason and bubble it up if present
220             if (returndata.length > 0) {
221                 // The easiest way to bubble the revert reason is using memory via assembly
222 
223                 assembly {
224                     let returndata_size := mload(returndata)
225                     revert(add(32, returndata), returndata_size)
226                 }
227             } else {
228                 revert(errorMessage);
229             }
230         }
231     }
232 }
233 
234 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title ERC721 token receiver interface
243  * @dev Interface for any contract that wants to support safeTransfers
244  * from ERC721 asset contracts.
245  */
246 interface IERC721Receiver {
247     /**
248      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
249      * by `operator` from `from`, this function is called.
250      *
251      * It must return its Solidity selector to confirm the token transfer.
252      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
253      *
254      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
255      */
256     function onERC721Received(
257         address operator,
258         address from,
259         uint256 tokenId,
260         bytes calldata data
261     ) external returns (bytes4);
262 }
263 
264 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
265 
266 
267 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev Interface of the ERC165 standard, as defined in the
273  * https://eips.ethereum.org/EIPS/eip-165[EIP].
274  *
275  * Implementers can declare support of contract interfaces, which can then be
276  * queried by others ({ERC165Checker}).
277  *
278  * For an implementation, see {ERC165}.
279  */
280 interface IERC165 {
281     /**
282      * @dev Returns true if this contract implements the interface defined by
283      * `interfaceId`. See the corresponding
284      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
285      * to learn more about how these ids are created.
286      *
287      * This function call must use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) external view returns (bool);
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 
300 /**
301  * @dev Required interface of an ERC721 compliant contract.
302  */
303 interface IERC721 is IERC165 {
304     /**
305      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
306      */
307     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
308 
309     /**
310      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
311      */
312     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
316      */
317     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
318 
319     /**
320      * @dev Returns the number of tokens in ``owner``'s account.
321      */
322     function balanceOf(address owner) external view returns (uint256 balance);
323 
324     /**
325      * @dev Returns the owner of the `tokenId` token.
326      *
327      * Requirements:
328      *
329      * - `tokenId` must exist.
330      */
331     function ownerOf(uint256 tokenId) external view returns (address owner);
332 
333     /**
334      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
335      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must exist and be owned by `from`.
342      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
344      *
345      * Emits a {Transfer} event.
346      */
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId
351     ) external;
352 
353     /**
354      * @dev Transfers `tokenId` token from `from` to `to`.
355      *
356      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `tokenId` token must be owned by `from`.
363      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) external;
372 
373     /**
374      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
375      * The approval is cleared when the token is transferred.
376      *
377      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
378      *
379      * Requirements:
380      *
381      * - The caller must own the token or be an approved operator.
382      * - `tokenId` must exist.
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address to, uint256 tokenId) external;
387 
388     /**
389      * @dev Returns the account approved for `tokenId` token.
390      *
391      * Requirements:
392      *
393      * - `tokenId` must exist.
394      */
395     function getApproved(uint256 tokenId) external view returns (address operator);
396 
397     /**
398      * @dev Approve or remove `operator` as an operator for the caller.
399      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
400      *
401      * Requirements:
402      *
403      * - The `operator` cannot be the caller.
404      *
405      * Emits an {ApprovalForAll} event.
406      */
407     function setApprovalForAll(address operator, bool _approved) external;
408 
409     /**
410      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
411      *
412      * See {setApprovalForAll}
413      */
414     function isApprovedForAll(address owner, address operator) external view returns (bool);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes calldata data
434     ) external;
435 }
436 
437 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
438 
439 
440 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
447  * @dev See https://eips.ethereum.org/EIPS/eip-721
448  */
449 interface IERC721Enumerable is IERC721 {
450     /**
451      * @dev Returns the total amount of tokens stored by the contract.
452      */
453     function totalSupply() external view returns (uint256);
454 
455     /**
456      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
457      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
458      */
459     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
460 
461     /**
462      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
463      * Use along with {totalSupply} to enumerate all tokens.
464      */
465     function tokenByIndex(uint256 index) external view returns (uint256);
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 /**
477  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
478  * @dev See https://eips.ethereum.org/EIPS/eip-721
479  */
480 interface IERC721Metadata is IERC721 {
481     /**
482      * @dev Returns the token collection name.
483      */
484     function name() external view returns (string memory);
485 
486     /**
487      * @dev Returns the token collection symbol.
488      */
489     function symbol() external view returns (string memory);
490 
491     /**
492      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
493      */
494     function tokenURI(uint256 tokenId) external view returns (string memory);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Implementation of the {IERC165} interface.
507  *
508  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
509  * for the additional interface id that will be supported. For example:
510  *
511  * ```solidity
512  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
514  * }
515  * ```
516  *
517  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
518  */
519 abstract contract ERC165 is IERC165 {
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524         return interfaceId == type(IERC165).interfaceId;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/interfaces/IERC165.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
537 
538 
539 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Interface for the NFT Royalty Standard.
546  *
547  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
548  * support for royalty payments across all NFT marketplaces and ecosystem participants.
549  *
550  * _Available since v4.5._
551  */
552 interface IERC2981 is IERC165 {
553     /**
554      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
555      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
556      */
557     function royaltyInfo(uint256 tokenId, uint256 salePrice)
558         external
559         view
560         returns (address receiver, uint256 royaltyAmount);
561 }
562 
563 // File: @openzeppelin/contracts/token/common/ERC2981.sol
564 
565 
566 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 
572 /**
573  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
574  *
575  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
576  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
577  *
578  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
579  * fee is specified in basis points by default.
580  *
581  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
582  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
583  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
584  *
585  * _Available since v4.5._
586  */
587 abstract contract ERC2981 is IERC2981, ERC165 {
588     struct RoyaltyInfo {
589         address receiver;
590         uint96 royaltyFraction;
591     }
592 
593     RoyaltyInfo private _defaultRoyaltyInfo;
594     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
595 
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
600         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
601     }
602 
603     /**
604      * @inheritdoc IERC2981
605      */
606     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
607         external
608         view
609         virtual
610         override
611         returns (address, uint256)
612     {
613         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
614 
615         if (royalty.receiver == address(0)) {
616             royalty = _defaultRoyaltyInfo;
617         }
618 
619         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
620 
621         return (royalty.receiver, royaltyAmount);
622     }
623 
624     /**
625      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
626      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
627      * override.
628      */
629     function _feeDenominator() internal pure virtual returns (uint96) {
630         return 10000;
631     }
632 
633     /**
634      * @dev Sets the royalty information that all ids in this contract will default to.
635      *
636      * Requirements:
637      *
638      * - `receiver` cannot be the zero address.
639      * - `feeNumerator` cannot be greater than the fee denominator.
640      */
641     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
642         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
643         require(receiver != address(0), "ERC2981: invalid receiver");
644 
645         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
646     }
647 
648     /**
649      * @dev Removes default royalty information.
650      */
651     function _deleteDefaultRoyalty() internal virtual {
652         delete _defaultRoyaltyInfo;
653     }
654 
655     /**
656      * @dev Sets the royalty information for a specific token id, overriding the global default.
657      *
658      * Requirements:
659      *
660      * - `tokenId` must be already minted.
661      * - `receiver` cannot be the zero address.
662      * - `feeNumerator` cannot be greater than the fee denominator.
663      */
664     function _setTokenRoyalty(
665         uint256 tokenId,
666         address receiver,
667         uint96 feeNumerator
668     ) internal virtual {
669         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
670         require(receiver != address(0), "ERC2981: Invalid parameters");
671 
672         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
673     }
674 
675     /**
676      * @dev Resets royalty information for the token id back to the global default.
677      */
678     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
679         delete _tokenRoyaltyInfo[tokenId];
680     }
681 }
682 
683 // File: @openzeppelin/contracts/utils/Strings.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev String operations.
692  */
693 library Strings {
694     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
695 
696     /**
697      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
698      */
699     function toString(uint256 value) internal pure returns (string memory) {
700         // Inspired by OraclizeAPI's implementation - MIT licence
701         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
702 
703         if (value == 0) {
704             return "0";
705         }
706         uint256 temp = value;
707         uint256 digits;
708         while (temp != 0) {
709             digits++;
710             temp /= 10;
711         }
712         bytes memory buffer = new bytes(digits);
713         while (value != 0) {
714             digits -= 1;
715             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
716             value /= 10;
717         }
718         return string(buffer);
719     }
720 
721     /**
722      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
723      */
724     function toHexString(uint256 value) internal pure returns (string memory) {
725         if (value == 0) {
726             return "0x00";
727         }
728         uint256 temp = value;
729         uint256 length = 0;
730         while (temp != 0) {
731             length++;
732             temp >>= 8;
733         }
734         return toHexString(value, length);
735     }
736 
737     /**
738      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
739      */
740     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
741         bytes memory buffer = new bytes(2 * length + 2);
742         buffer[0] = "0";
743         buffer[1] = "x";
744         for (uint256 i = 2 * length + 1; i > 1; --i) {
745             buffer[i] = _HEX_SYMBOLS[value & 0xf];
746             value >>= 4;
747         }
748         require(value == 0, "Strings: hex length insufficient");
749         return string(buffer);
750     }
751 }
752 
753 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
754 
755 
756 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 /**
761  * @dev These functions deal with verification of Merkle Trees proofs.
762  *
763  * The proofs can be generated using the JavaScript library
764  * https://github.com/miguelmota/merkletreejs[merkletreejs].
765  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
766  *
767  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
768  */
769 library MerkleProof {
770     /**
771      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
772      * defined by `root`. For this, a `proof` must be provided, containing
773      * sibling hashes on the branch from the leaf to the root of the tree. Each
774      * pair of leaves and each pair of pre-images are assumed to be sorted.
775      */
776     function verify(
777         bytes32[] memory proof,
778         bytes32 root,
779         bytes32 leaf
780     ) internal pure returns (bool) {
781         return processProof(proof, leaf) == root;
782     }
783 
784     /**
785      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
786      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
787      * hash matches the root of the tree. When processing the proof, the pairs
788      * of leafs & pre-images are assumed to be sorted.
789      *
790      * _Available since v4.4._
791      */
792     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
793         bytes32 computedHash = leaf;
794         for (uint256 i = 0; i < proof.length; i++) {
795             bytes32 proofElement = proof[i];
796             if (computedHash <= proofElement) {
797                 // Hash(current computed hash + current element of the proof)
798                 computedHash = _efficientHash(computedHash, proofElement);
799             } else {
800                 // Hash(current element of the proof + current computed hash)
801                 computedHash = _efficientHash(proofElement, computedHash);
802             }
803         }
804         return computedHash;
805     }
806 
807     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
808         assembly {
809             mstore(0x00, a)
810             mstore(0x20, b)
811             value := keccak256(0x00, 0x40)
812         }
813     }
814 }
815 
816 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
817 
818 
819 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @dev Contract module that helps prevent reentrant calls to a function.
825  *
826  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
827  * available, which can be applied to functions to make sure there are no nested
828  * (reentrant) calls to them.
829  *
830  * Note that because there is a single `nonReentrant` guard, functions marked as
831  * `nonReentrant` may not call one another. This can be worked around by making
832  * those functions `private`, and then adding `external` `nonReentrant` entry
833  * points to them.
834  *
835  * TIP: If you would like to learn more about reentrancy and alternative ways
836  * to protect against it, check out our blog post
837  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
838  */
839 abstract contract ReentrancyGuard {
840     // Booleans are more expensive than uint256 or any type that takes up a full
841     // word because each write operation emits an extra SLOAD to first read the
842     // slot's contents, replace the bits taken up by the boolean, and then write
843     // back. This is the compiler's defense against contract upgrades and
844     // pointer aliasing, and it cannot be disabled.
845 
846     // The values being non-zero value makes deployment a bit more expensive,
847     // but in exchange the refund on every call to nonReentrant will be lower in
848     // amount. Since refunds are capped to a percentage of the total
849     // transaction's gas, it is best to keep them low in cases like this one, to
850     // increase the likelihood of the full refund coming into effect.
851     uint256 private constant _NOT_ENTERED = 1;
852     uint256 private constant _ENTERED = 2;
853 
854     uint256 private _status;
855 
856     constructor() {
857         _status = _NOT_ENTERED;
858     }
859 
860     /**
861      * @dev Prevents a contract from calling itself, directly or indirectly.
862      * Calling a `nonReentrant` function from another `nonReentrant`
863      * function is not supported. It is possible to prevent this from happening
864      * by making the `nonReentrant` function external, and making it call a
865      * `private` function that does the actual work.
866      */
867     modifier nonReentrant() {
868         // On the first call to nonReentrant, _notEntered will be true
869         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
870 
871         // Any calls to nonReentrant after this point will fail
872         _status = _ENTERED;
873 
874         _;
875 
876         // By storing the original value once again, a refund is triggered (see
877         // https://eips.ethereum.org/EIPS/eip-2200)
878         _status = _NOT_ENTERED;
879     }
880 }
881 
882 // File: @openzeppelin/contracts/utils/Context.sol
883 
884 
885 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 /**
890  * @dev Provides information about the current execution context, including the
891  * sender of the transaction and its data. While these are generally available
892  * via msg.sender and msg.data, they should not be accessed in such a direct
893  * manner, since when dealing with meta-transactions the account sending and
894  * paying for execution may not be the actual sender (as far as an application
895  * is concerned).
896  *
897  * This contract is only required for intermediate, library-like contracts.
898  */
899 abstract contract Context {
900     function _msgSender() internal view virtual returns (address) {
901         return msg.sender;
902     }
903 
904     function _msgData() internal view virtual returns (bytes calldata) {
905         return msg.data;
906     }
907 }
908 
909 // File: https://github.com/chiru-labs/ERC721A/blob/v2.2.0/contracts/ERC721A.sol
910 
911 
912 // Creator: Chiru Labs
913 
914 pragma solidity ^0.8.4;
915 
916 
917 
918 
919 
920 
921 
922 
923 
924 error ApprovalCallerNotOwnerNorApproved();
925 error ApprovalQueryForNonexistentToken();
926 error ApproveToCaller();
927 error ApprovalToCurrentOwner();
928 error BalanceQueryForZeroAddress();
929 error MintedQueryForZeroAddress();
930 error BurnedQueryForZeroAddress();
931 error MintToZeroAddress();
932 error MintZeroQuantity();
933 error OwnerIndexOutOfBounds();
934 error OwnerQueryForNonexistentToken();
935 error TokenIndexOutOfBounds();
936 error TransferCallerNotOwnerNorApproved();
937 error TransferFromIncorrectOwner();
938 error TransferToNonERC721ReceiverImplementer();
939 error TransferToZeroAddress();
940 error URIQueryForNonexistentToken();
941 
942 /**
943  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
944  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
945  *
946  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
947  *
948  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
949  *
950  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
951  */
952 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
953     using Address for address;
954     using Strings for uint256;
955 
956     // Compiler will pack this into a single 256bit word.
957     struct TokenOwnership {
958         // The address of the owner.
959         address addr;
960         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
961         uint64 startTimestamp;
962         // Whether the token has been burned.
963         bool burned;
964     }
965 
966     // Compiler will pack this into a single 256bit word.
967     struct AddressData {
968         // Realistically, 2**64-1 is more than enough.
969         uint64 balance;
970         // Keeps track of mint count with minimal overhead for tokenomics.
971         uint64 numberMinted;
972         // Keeps track of burn count with minimal overhead for tokenomics.
973         uint64 numberBurned;
974     }
975 
976     // Compiler will pack the following 
977     // _currentIndex and _burnCounter into a single 256bit word.
978     
979     // The tokenId of the next token to be minted.
980     uint128 internal _currentIndex;
981 
982     // The number of tokens burned.
983     uint128 internal _burnCounter;
984 
985     // Token name
986     string private _name;
987 
988     // Token symbol
989     string private _symbol;
990 
991     // Mapping from token ID to ownership details
992     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
993     mapping(uint256 => TokenOwnership) internal _ownerships;
994 
995     // Mapping owner address to address data
996     mapping(address => AddressData) private _addressData;
997 
998     // Mapping from token ID to approved address
999     mapping(uint256 => address) private _tokenApprovals;
1000 
1001     // Mapping from owner to operator approvals
1002     mapping(address => mapping(address => bool)) private _operatorApprovals;
1003 
1004     constructor(string memory name_, string memory symbol_) {
1005         _name = name_;
1006         _symbol = symbol_;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Enumerable-totalSupply}.
1011      */
1012     function totalSupply() public view override returns (uint256) {
1013         // Counter underflow is impossible as _burnCounter cannot be incremented
1014         // more than _currentIndex times
1015         unchecked {
1016             return _currentIndex - _burnCounter;    
1017         }
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-tokenByIndex}.
1022      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1023      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1024      */
1025     function tokenByIndex(uint256 index) public view override returns (uint256) {
1026         uint256 numMintedSoFar = _currentIndex;
1027         uint256 tokenIdsIdx;
1028 
1029         // Counter overflow is impossible as the loop breaks when
1030         // uint256 i is equal to another uint256 numMintedSoFar.
1031         unchecked {
1032             for (uint256 i; i < numMintedSoFar; i++) {
1033                 TokenOwnership memory ownership = _ownerships[i];
1034                 if (!ownership.burned) {
1035                     if (tokenIdsIdx == index) {
1036                         return i;
1037                     }
1038                     tokenIdsIdx++;
1039                 }
1040             }
1041         }
1042         revert TokenIndexOutOfBounds();
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1047      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1048      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1049      */
1050     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1051         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1052         uint256 numMintedSoFar = _currentIndex;
1053         uint256 tokenIdsIdx;
1054         address currOwnershipAddr;
1055 
1056         // Counter overflow is impossible as the loop breaks when
1057         // uint256 i is equal to another uint256 numMintedSoFar.
1058         unchecked {
1059             for (uint256 i; i < numMintedSoFar; i++) {
1060                 TokenOwnership memory ownership = _ownerships[i];
1061                 if (ownership.burned) {
1062                     continue;
1063                 }
1064                 if (ownership.addr != address(0)) {
1065                     currOwnershipAddr = ownership.addr;
1066                 }
1067                 if (currOwnershipAddr == owner) {
1068                     if (tokenIdsIdx == index) {
1069                         return i;
1070                     }
1071                     tokenIdsIdx++;
1072                 }
1073             }
1074         }
1075 
1076         // Execution should never reach this point.
1077         revert();
1078     }
1079 
1080     /**
1081      * @dev See {IERC165-supportsInterface}.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1084         return
1085             interfaceId == type(IERC721).interfaceId ||
1086             interfaceId == type(IERC721Metadata).interfaceId ||
1087             interfaceId == type(IERC721Enumerable).interfaceId ||
1088             super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-balanceOf}.
1093      */
1094     function balanceOf(address owner) public view override returns (uint256) {
1095         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1096         return uint256(_addressData[owner].balance);
1097     }
1098 
1099     function _numberMinted(address owner) internal view returns (uint256) {
1100         if (owner == address(0)) revert MintedQueryForZeroAddress();
1101         return uint256(_addressData[owner].numberMinted);
1102     }
1103 
1104     function _numberBurned(address owner) internal view returns (uint256) {
1105         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1106         return uint256(_addressData[owner].numberBurned);
1107     }
1108 
1109     /**
1110      * Gas spent here starts off proportional to the maximum mint batch size.
1111      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1112      */
1113     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1114         uint256 curr = tokenId;
1115 
1116         unchecked {
1117             if (curr < _currentIndex) {
1118                 TokenOwnership memory ownership = _ownerships[curr];
1119                 if (!ownership.burned) {
1120                     if (ownership.addr != address(0)) {
1121                         return ownership;
1122                     }
1123                     // Invariant: 
1124                     // There will always be an ownership that has an address and is not burned 
1125                     // before an ownership that does not have an address and is not burned.
1126                     // Hence, curr will not underflow.
1127                     while (true) {
1128                         curr--;
1129                         ownership = _ownerships[curr];
1130                         if (ownership.addr != address(0)) {
1131                             return ownership;
1132                         }
1133                     }
1134                 }
1135             }
1136         }
1137         revert OwnerQueryForNonexistentToken();
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-ownerOf}.
1142      */
1143     function ownerOf(uint256 tokenId) public view override returns (address) {
1144         return ownershipOf(tokenId).addr;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Metadata-name}.
1149      */
1150     function name() public view virtual override returns (string memory) {
1151         return _name;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-symbol}.
1156      */
1157     function symbol() public view virtual override returns (string memory) {
1158         return _symbol;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-tokenURI}.
1163      */
1164     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1165         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1166 
1167         string memory baseURI = _baseURI();
1168         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1169     }
1170 
1171     /**
1172      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1173      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1174      * by default, can be overriden in child contracts.
1175      */
1176     function _baseURI() internal view virtual returns (string memory) {
1177         return '';
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-approve}.
1182      */
1183     function approve(address to, uint256 tokenId) public override {
1184         address owner = ERC721A.ownerOf(tokenId);
1185         if (to == owner) revert ApprovalToCurrentOwner();
1186 
1187         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1188             revert ApprovalCallerNotOwnerNorApproved();
1189         }
1190 
1191         _approve(to, tokenId, owner);
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-getApproved}.
1196      */
1197     function getApproved(uint256 tokenId) public view override returns (address) {
1198         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1199 
1200         return _tokenApprovals[tokenId];
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-setApprovalForAll}.
1205      */
1206     function setApprovalForAll(address operator, bool approved) public override {
1207         if (operator == _msgSender()) revert ApproveToCaller();
1208 
1209         _operatorApprovals[_msgSender()][operator] = approved;
1210         emit ApprovalForAll(_msgSender(), operator, approved);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-isApprovedForAll}.
1215      */
1216     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1217         return _operatorApprovals[owner][operator];
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-transferFrom}.
1222      */
1223     function transferFrom(
1224         address from,
1225         address to,
1226         uint256 tokenId
1227     ) public virtual override {
1228         _transfer(from, to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-safeTransferFrom}.
1233      */
1234     function safeTransferFrom(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) public virtual override {
1239         safeTransferFrom(from, to, tokenId, '');
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-safeTransferFrom}.
1244      */
1245     function safeTransferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes memory _data
1250     ) public virtual override {
1251         _transfer(from, to, tokenId);
1252         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1253             revert TransferToNonERC721ReceiverImplementer();
1254         }
1255     }
1256 
1257     /**
1258      * @dev Returns whether `tokenId` exists.
1259      *
1260      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1261      *
1262      * Tokens start existing when they are minted (`_mint`),
1263      */
1264     function _exists(uint256 tokenId) internal view returns (bool) {
1265         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1266     }
1267 
1268     function _safeMint(address to, uint256 quantity) internal {
1269         _safeMint(to, quantity, '');
1270     }
1271 
1272     /**
1273      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1274      *
1275      * Requirements:
1276      *
1277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1278      * - `quantity` must be greater than 0.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _safeMint(
1283         address to,
1284         uint256 quantity,
1285         bytes memory _data
1286     ) internal {
1287         _mint(to, quantity, _data, true);
1288     }
1289 
1290     /**
1291      * @dev Mints `quantity` tokens and transfers them to `to`.
1292      *
1293      * Requirements:
1294      *
1295      * - `to` cannot be the zero address.
1296      * - `quantity` must be greater than 0.
1297      *
1298      * Emits a {Transfer} event.
1299      */
1300     function _mint(
1301         address to,
1302         uint256 quantity,
1303         bytes memory _data,
1304         bool safe
1305     ) internal {
1306         uint256 startTokenId = _currentIndex;
1307         if (to == address(0)) revert MintToZeroAddress();
1308         if (quantity == 0) revert MintZeroQuantity();
1309 
1310         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1311 
1312         // Overflows are incredibly unrealistic.
1313         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1314         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1315         unchecked {
1316             _addressData[to].balance += uint64(quantity);
1317             _addressData[to].numberMinted += uint64(quantity);
1318 
1319             _ownerships[startTokenId].addr = to;
1320             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1321 
1322             uint256 updatedIndex = startTokenId;
1323 
1324             for (uint256 i; i < quantity; i++) {
1325                 emit Transfer(address(0), to, updatedIndex);
1326                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1327                     revert TransferToNonERC721ReceiverImplementer();
1328                 }
1329                 updatedIndex++;
1330             }
1331 
1332             _currentIndex = uint128(updatedIndex);
1333         }
1334         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1335     }
1336 
1337     /**
1338      * @dev Transfers `tokenId` from `from` to `to`.
1339      *
1340      * Requirements:
1341      *
1342      * - `to` cannot be the zero address.
1343      * - `tokenId` token must be owned by `from`.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _transfer(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) private {
1352         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1353 
1354         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1355             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1356             getApproved(tokenId) == _msgSender());
1357 
1358         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1359         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1360         if (to == address(0)) revert TransferToZeroAddress();
1361 
1362         _beforeTokenTransfers(from, to, tokenId, 1);
1363 
1364         // Clear approvals from the previous owner
1365         _approve(address(0), tokenId, prevOwnership.addr);
1366 
1367         // Underflow of the sender's balance is impossible because we check for
1368         // ownership above and the recipient's balance can't realistically overflow.
1369         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
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
1381                 // This will suffice for checking _exists(nextTokenId),
1382                 // as a burned slot cannot contain the zero address.
1383                 if (nextTokenId < _currentIndex) {
1384                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1385                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1386                 }
1387             }
1388         }
1389 
1390         emit Transfer(from, to, tokenId);
1391         _afterTokenTransfers(from, to, tokenId, 1);
1392     }
1393 
1394     /**
1395      * @dev Destroys `tokenId`.
1396      * The approval is cleared when the token is burned.
1397      *
1398      * Requirements:
1399      *
1400      * - `tokenId` must exist.
1401      *
1402      * Emits a {Transfer} event.
1403      */
1404     function _burn(uint256 tokenId) internal virtual {
1405         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1406 
1407         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1408 
1409         // Clear approvals from the previous owner
1410         _approve(address(0), tokenId, prevOwnership.addr);
1411 
1412         // Underflow of the sender's balance is impossible because we check for
1413         // ownership above and the recipient's balance can't realistically overflow.
1414         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1415         unchecked {
1416             _addressData[prevOwnership.addr].balance -= 1;
1417             _addressData[prevOwnership.addr].numberBurned += 1;
1418 
1419             // Keep track of who burned the token, and the timestamp of burning.
1420             _ownerships[tokenId].addr = prevOwnership.addr;
1421             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1422             _ownerships[tokenId].burned = true;
1423 
1424             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1425             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1426             uint256 nextTokenId = tokenId + 1;
1427             if (_ownerships[nextTokenId].addr == address(0)) {
1428                 // This will suffice for checking _exists(nextTokenId),
1429                 // as a burned slot cannot contain the zero address.
1430                 if (nextTokenId < _currentIndex) {
1431                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1432                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1433                 }
1434             }
1435         }
1436 
1437         emit Transfer(prevOwnership.addr, address(0), tokenId);
1438         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1439 
1440         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1441         unchecked { 
1442             _burnCounter++;
1443         }
1444     }
1445 
1446     /**
1447      * @dev Approve `to` to operate on `tokenId`
1448      *
1449      * Emits a {Approval} event.
1450      */
1451     function _approve(
1452         address to,
1453         uint256 tokenId,
1454         address owner
1455     ) private {
1456         _tokenApprovals[tokenId] = to;
1457         emit Approval(owner, to, tokenId);
1458     }
1459 
1460     /**
1461      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1462      * The call is not executed if the target address is not a contract.
1463      *
1464      * @param from address representing the previous owner of the given token ID
1465      * @param to target address that will receive the tokens
1466      * @param tokenId uint256 ID of the token to be transferred
1467      * @param _data bytes optional data to send along with the call
1468      * @return bool whether the call correctly returned the expected magic value
1469      */
1470     function _checkOnERC721Received(
1471         address from,
1472         address to,
1473         uint256 tokenId,
1474         bytes memory _data
1475     ) private returns (bool) {
1476         if (to.isContract()) {
1477             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1478                 return retval == IERC721Receiver(to).onERC721Received.selector;
1479             } catch (bytes memory reason) {
1480                 if (reason.length == 0) {
1481                     revert TransferToNonERC721ReceiverImplementer();
1482                 } else {
1483                     assembly {
1484                         revert(add(32, reason), mload(reason))
1485                     }
1486                 }
1487             }
1488         } else {
1489             return true;
1490         }
1491     }
1492 
1493     /**
1494      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1495      * And also called before burning one token.
1496      *
1497      * startTokenId - the first token id to be transferred
1498      * quantity - the amount to be transferred
1499      *
1500      * Calling conditions:
1501      *
1502      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1503      * transferred to `to`.
1504      * - When `from` is zero, `tokenId` will be minted for `to`.
1505      * - When `to` is zero, `tokenId` will be burned by `from`.
1506      * - `from` and `to` are never both zero.
1507      */
1508     function _beforeTokenTransfers(
1509         address from,
1510         address to,
1511         uint256 startTokenId,
1512         uint256 quantity
1513     ) internal virtual {}
1514 
1515     /**
1516      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1517      * minting.
1518      * And also called after one token has been burned.
1519      *
1520      * startTokenId - the first token id to be transferred
1521      * quantity - the amount to be transferred
1522      *
1523      * Calling conditions:
1524      *
1525      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1526      * transferred to `to`.
1527      * - When `from` is zero, `tokenId` has been minted for `to`.
1528      * - When `to` is zero, `tokenId` has been burned by `from`.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _afterTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 }
1538 
1539 // File: @openzeppelin/contracts/access/Ownable.sol
1540 
1541 
1542 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 
1547 /**
1548  * @dev Contract module which provides a basic access control mechanism, where
1549  * there is an account (an owner) that can be granted exclusive access to
1550  * specific functions.
1551  *
1552  * By default, the owner account will be the one that deploys the contract. This
1553  * can later be changed with {transferOwnership}.
1554  *
1555  * This module is used through inheritance. It will make available the modifier
1556  * `onlyOwner`, which can be applied to your functions to restrict their use to
1557  * the owner.
1558  */
1559 abstract contract Ownable is Context {
1560     address private _owner;
1561 
1562     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1563 
1564     /**
1565      * @dev Initializes the contract setting the deployer as the initial owner.
1566      */
1567     constructor() {
1568         _transferOwnership(_msgSender());
1569     }
1570 
1571     /**
1572      * @dev Returns the address of the current owner.
1573      */
1574     function owner() public view virtual returns (address) {
1575         return _owner;
1576     }
1577 
1578     /**
1579      * @dev Throws if called by any account other than the owner.
1580      */
1581     modifier onlyOwner() {
1582         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1583         _;
1584     }
1585 
1586     /**
1587      * @dev Leaves the contract without owner. It will not be possible to call
1588      * `onlyOwner` functions anymore. Can only be called by the current owner.
1589      *
1590      * NOTE: Renouncing ownership will leave the contract without an owner,
1591      * thereby removing any functionality that is only available to the owner.
1592      */
1593     function renounceOwnership() public virtual onlyOwner {
1594         _transferOwnership(address(0));
1595     }
1596 
1597     /**
1598      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1599      * Can only be called by the current owner.
1600      */
1601     function transferOwnership(address newOwner) public virtual onlyOwner {
1602         require(newOwner != address(0), "Ownable: new owner is the zero address");
1603         _transferOwnership(newOwner);
1604     }
1605 
1606     /**
1607      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1608      * Internal function without access restriction.
1609      */
1610     function _transferOwnership(address newOwner) internal virtual {
1611         address oldOwner = _owner;
1612         _owner = newOwner;
1613         emit OwnershipTransferred(oldOwner, newOwner);
1614     }
1615 }
1616 
1617 // File: TiptoePunks.sol
1618 
1619 
1620 pragma solidity ^0.8.12;
1621 
1622 
1623 
1624 
1625 
1626 
1627 
1628 
1629 contract TiptoePunks is ERC721A, ERC2981, Ownable, ReentrancyGuard {
1630     using Strings for uint256;
1631 
1632     IToeken public Toeken;
1633 
1634     string internal _baseTokenURI;
1635     string internal _unrevealedURI;
1636 
1637     uint256 internal reserved;
1638 
1639     bool public revealed;
1640     bool public presaleActive;
1641     bool public saleActive;
1642 
1643     uint256 public presaleMintPrice = 0.04 ether;
1644     uint256 public publicMintPrice = 0.06 ether;
1645     uint256 public currentSupplyCap = 2_500;
1646 
1647     // presale info
1648     bytes32 public merkleRoot;
1649     mapping(address => bool) public whitelistUsed;
1650 
1651     uint256 public constant AMOUNT_PER_DROP = 2_500;
1652     uint256 public constant MAX_TOTAL_SUPPLY = 10_000;
1653     uint256 public constant MAX_RESERVED_AMOUNT = 250;
1654     uint256 public constant MAX_AMOUNT_PER_MINT = 20;
1655     uint96 public constant ROYALTY_BPS = 1_000; // 10%
1656 
1657     event Mint(address indexed owner, uint256 indexed amountMinted);
1658 
1659     constructor(string memory URI, bytes32 root) ERC721A("TiptoePunks", "TIPTOE") {
1660         _unrevealedURI = URI;
1661         merkleRoot = root;
1662         _setDefaultRoyalty(msg.sender, ROYALTY_BPS);
1663     }
1664 
1665     function supportsInterface(bytes4 interfaceId) public view override(ERC2981, ERC721A) returns (bool) {
1666         return super.supportsInterface(interfaceId);
1667     }
1668 
1669     // URI FUNCTIONS
1670 
1671     function _baseURI() internal view virtual override returns (string memory) {
1672         return _baseTokenURI;
1673     }
1674 
1675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1676         if (!revealed) {
1677             return _unrevealedURI;
1678         }
1679         string memory baseURI = _baseURI();
1680         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1681     }
1682 
1683     // OWNER FUNCTIONS
1684 
1685     function setBaseURI(string calldata baseURI) external onlyOwner {
1686         _baseTokenURI = baseURI;
1687     }
1688 
1689     function setUnrevealedURI(string calldata unrevealedURI) external onlyOwner {
1690         _unrevealedURI = unrevealedURI;
1691     }
1692 
1693     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1694         merkleRoot = _merkleRoot;
1695     }
1696 
1697     function setToekenAddress(address toeken) public onlyOwner {
1698         Toeken = IToeken(toeken);
1699     }
1700 
1701     function setPresaleMintPrice(uint256 price) public onlyOwner {
1702         presaleMintPrice = price;
1703     }
1704 
1705     function setPublicMintPrice(uint256 price) public onlyOwner {
1706         publicMintPrice = price;
1707     }
1708 
1709     function increaseSupplyCap() public onlyOwner {
1710         require(currentSupplyCap < MAX_TOTAL_SUPPLY, "Supply cap already maxed out");
1711         currentSupplyCap += AMOUNT_PER_DROP;
1712     }
1713 
1714     function flipPresaleStatus() public onlyOwner {
1715         presaleActive = !presaleActive;
1716     }
1717 
1718     function flipSaleStatus() public onlyOwner {
1719         saleActive = !saleActive;
1720     }
1721 
1722     function reveal() public onlyOwner {
1723         require(!revealed, "Already revealed");
1724         revealed = true;
1725     }
1726 
1727     function withdraw() external onlyOwner nonReentrant {
1728         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1729         require(success, "Withdraw failed");
1730     }
1731 
1732     // MINTING FUNCTIONS
1733 
1734     // verifies a merkle proof for whitelist checking
1735     function verify(
1736         bytes32 root,
1737         bytes32 leaf,
1738         bytes32[] memory proof
1739     ) public pure returns (bool) {
1740         return MerkleProof.verify(proof, root, leaf);
1741     }
1742 
1743     // function to mint based off of whitelist allocation
1744     function presaleMint(
1745         uint256 amount,
1746         bytes32 leaf,
1747         bytes32[] memory proof
1748     ) external payable {
1749         require(presaleActive, "Presale not active");
1750 
1751         // create storage element tracking user mints if this is the first mint for them
1752         if (!whitelistUsed[msg.sender]) {
1753             // verify that msg.sender corresponds to Merkle leaf
1754             require(keccak256(abi.encodePacked(msg.sender)) == leaf, "Sender doesn't match Merkle leaf");
1755 
1756             // verify that (leaf, proof) matches the Merkle root
1757             require(verify(merkleRoot, leaf, proof), "Not a valid leaf in the Merkle tree");
1758 
1759             whitelistUsed[msg.sender] = true;
1760         }
1761 
1762         require(amount <= MAX_AMOUNT_PER_MINT, "Minting too many at a time");
1763         require(msg.value == amount * presaleMintPrice, "Not enough ETH sent");
1764         require(amount + totalSupply() <= currentSupplyCap, "Would exceed max supply");
1765 
1766         _safeMint(msg.sender, amount);
1767 
1768         emit Mint(msg.sender, amount);
1769     }
1770 
1771     // function to mint in public sale
1772     function publicMint(uint256 amount) external payable {
1773         require(saleActive, "Public sale not active");
1774         require(amount <= MAX_AMOUNT_PER_MINT, "Minting too many at a time");
1775         require(msg.value == amount * publicMintPrice, "Not enough ETH sent");
1776         require(amount + totalSupply() <= currentSupplyCap, "Would exceed max supply");
1777 
1778         // _safeMint(msg.sender, amount);
1779         _mint(msg.sender, amount, "", false);
1780 
1781         emit Mint(msg.sender, amount);
1782     }
1783 
1784     // reserves 'amount' NFTs minted direct to a specified wallet
1785     function reserve(address to, uint256 amount) external onlyOwner {
1786         require(amount + totalSupply() < currentSupplyCap, "Would exceed max supply");
1787         require(reserved + amount <= MAX_RESERVED_AMOUNT, "Would exceed max reserved amount");
1788 
1789         _safeMint(to, amount);
1790         reserved += amount;
1791 
1792         emit Mint(to, amount);
1793     }
1794 
1795     // OVERRIDES
1796 
1797     function transferFrom(
1798         address from,
1799         address to,
1800         uint256 tokenId
1801     ) public override {
1802         if (address(Toeken) != address(0)) {
1803             Toeken.update(from, to);
1804         }
1805 
1806         super.transferFrom(from, to, tokenId);
1807     }
1808 
1809     function safeTransferFrom(
1810         address from,
1811         address to,
1812         uint256 tokenId
1813     ) public override {
1814         if (address(Toeken) != address(0)) {
1815             Toeken.update(from, to);
1816         }
1817 
1818         super.safeTransferFrom(from, to, tokenId, '');
1819     }
1820 
1821     function safeTransferFrom(
1822         address from,
1823         address to,
1824         uint256 tokenId,
1825         bytes memory data
1826     ) public override {
1827         if (address(Toeken) != address(0)) {
1828             Toeken.update(from, to);
1829         }
1830 
1831         super.safeTransferFrom(from, to, tokenId, data);
1832     }
1833 }