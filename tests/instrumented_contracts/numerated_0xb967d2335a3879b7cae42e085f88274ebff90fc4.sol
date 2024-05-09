1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292                 /// @solidity memory-safe-assembly
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
363 
364 
365 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Interface for the NFT Royalty Standard.
372  *
373  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
374  * support for royalty payments across all NFT marketplaces and ecosystem participants.
375  *
376  * _Available since v4.5._
377  */
378 interface IERC2981 is IERC165 {
379     /**
380      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
381      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
382      */
383     function royaltyInfo(uint256 tokenId, uint256 salePrice)
384         external
385         view
386         returns (address receiver, uint256 royaltyAmount);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Implementation of the {IERC165} interface.
399  *
400  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
401  * for the additional interface id that will be supported. For example:
402  *
403  * ```solidity
404  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
406  * }
407  * ```
408  *
409  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
410  */
411 abstract contract ERC165 is IERC165 {
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      */
415     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416         return interfaceId == type(IERC165).interfaceId;
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/common/ERC2981.sol
421 
422 
423 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 
428 
429 /**
430  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
431  *
432  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
433  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
434  *
435  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
436  * fee is specified in basis points by default.
437  *
438  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
439  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
440  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
441  *
442  * _Available since v4.5._
443  */
444 abstract contract ERC2981 is IERC2981, ERC165 {
445     struct RoyaltyInfo {
446         address receiver;
447         uint96 royaltyFraction;
448     }
449 
450     RoyaltyInfo private _defaultRoyaltyInfo;
451     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
452 
453     /**
454      * @dev See {IERC165-supportsInterface}.
455      */
456     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
457         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
458     }
459 
460     /**
461      * @inheritdoc IERC2981
462      */
463     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
464         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
465 
466         if (royalty.receiver == address(0)) {
467             royalty = _defaultRoyaltyInfo;
468         }
469 
470         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
471 
472         return (royalty.receiver, royaltyAmount);
473     }
474 
475     /**
476      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
477      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
478      * override.
479      */
480     function _feeDenominator() internal pure virtual returns (uint96) {
481         return 10000;
482     }
483 
484     /**
485      * @dev Sets the royalty information that all ids in this contract will default to.
486      *
487      * Requirements:
488      *
489      * - `receiver` cannot be the zero address.
490      * - `feeNumerator` cannot be greater than the fee denominator.
491      */
492     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
493         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
494         require(receiver != address(0), "ERC2981: invalid receiver");
495 
496         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
497     }
498 
499     /**
500      * @dev Removes default royalty information.
501      */
502     function _deleteDefaultRoyalty() internal virtual {
503         delete _defaultRoyaltyInfo;
504     }
505 
506     /**
507      * @dev Sets the royalty information for a specific token id, overriding the global default.
508      *
509      * Requirements:
510      *
511      * - `receiver` cannot be the zero address.
512      * - `feeNumerator` cannot be greater than the fee denominator.
513      */
514     function _setTokenRoyalty(
515         uint256 tokenId,
516         address receiver,
517         uint96 feeNumerator
518     ) internal virtual {
519         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
520         require(receiver != address(0), "ERC2981: Invalid parameters");
521 
522         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
523     }
524 
525     /**
526      * @dev Resets royalty information for the token id back to the global default.
527      */
528     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
529         delete _tokenRoyaltyInfo[tokenId];
530     }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Required interface of an ERC721 compliant contract.
543  */
544 interface IERC721 is IERC165 {
545     /**
546      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
552      */
553     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
557      */
558     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
559 
560     /**
561      * @dev Returns the number of tokens in ``owner``'s account.
562      */
563     function balanceOf(address owner) external view returns (uint256 balance);
564 
565     /**
566      * @dev Returns the owner of the `tokenId` token.
567      *
568      * Requirements:
569      *
570      * - `tokenId` must exist.
571      */
572     function ownerOf(uint256 tokenId) external view returns (address owner);
573 
574     /**
575      * @dev Safely transfers `tokenId` token from `from` to `to`.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId,
591         bytes calldata data
592     ) external;
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
596      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must exist and be owned by `from`.
603      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
605      *
606      * Emits a {Transfer} event.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Transfers `tokenId` token from `from` to `to`.
616      *
617      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
636      * The approval is cleared when the token is transferred.
637      *
638      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
639      *
640      * Requirements:
641      *
642      * - The caller must own the token or be an approved operator.
643      * - `tokenId` must exist.
644      *
645      * Emits an {Approval} event.
646      */
647     function approve(address to, uint256 tokenId) external;
648 
649     /**
650      * @dev Approve or remove `operator` as an operator for the caller.
651      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
652      *
653      * Requirements:
654      *
655      * - The `operator` cannot be the caller.
656      *
657      * Emits an {ApprovalForAll} event.
658      */
659     function setApprovalForAll(address operator, bool _approved) external;
660 
661     /**
662      * @dev Returns the account approved for `tokenId` token.
663      *
664      * Requirements:
665      *
666      * - `tokenId` must exist.
667      */
668     function getApproved(uint256 tokenId) external view returns (address operator);
669 
670     /**
671      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
672      *
673      * See {setApprovalForAll}
674      */
675     function isApprovedForAll(address owner, address operator) external view returns (bool);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
688  * @dev See https://eips.ethereum.org/EIPS/eip-721
689  */
690 interface IERC721Enumerable is IERC721 {
691     /**
692      * @dev Returns the total amount of tokens stored by the contract.
693      */
694     function totalSupply() external view returns (uint256);
695 
696     /**
697      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
698      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
699      */
700     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
701 
702     /**
703      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
704      * Use along with {totalSupply} to enumerate all tokens.
705      */
706     function tokenByIndex(uint256 index) external view returns (uint256);
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Metadata is IERC721 {
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @dev These functions deal with verification of Merkle Tree proofs.
747  *
748  * The proofs can be generated using the JavaScript library
749  * https://github.com/miguelmota/merkletreejs[merkletreejs].
750  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
751  *
752  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
753  *
754  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
755  * hashing, or use a hash function other than keccak256 for hashing leaves.
756  * This is because the concatenation of a sorted pair of internal nodes in
757  * the merkle tree could be reinterpreted as a leaf value.
758  */
759 library MerkleProof {
760     /**
761      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
762      * defined by `root`. For this, a `proof` must be provided, containing
763      * sibling hashes on the branch from the leaf to the root of the tree. Each
764      * pair of leaves and each pair of pre-images are assumed to be sorted.
765      */
766     function verify(
767         bytes32[] memory proof,
768         bytes32 root,
769         bytes32 leaf
770     ) internal pure returns (bool) {
771         return processProof(proof, leaf) == root;
772     }
773 
774     /**
775      * @dev Calldata version of {verify}
776      *
777      * _Available since v4.7._
778      */
779     function verifyCalldata(
780         bytes32[] calldata proof,
781         bytes32 root,
782         bytes32 leaf
783     ) internal pure returns (bool) {
784         return processProofCalldata(proof, leaf) == root;
785     }
786 
787     /**
788      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
789      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
790      * hash matches the root of the tree. When processing the proof, the pairs
791      * of leafs & pre-images are assumed to be sorted.
792      *
793      * _Available since v4.4._
794      */
795     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
796         bytes32 computedHash = leaf;
797         for (uint256 i = 0; i < proof.length; i++) {
798             computedHash = _hashPair(computedHash, proof[i]);
799         }
800         return computedHash;
801     }
802 
803     /**
804      * @dev Calldata version of {processProof}
805      *
806      * _Available since v4.7._
807      */
808     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
809         bytes32 computedHash = leaf;
810         for (uint256 i = 0; i < proof.length; i++) {
811             computedHash = _hashPair(computedHash, proof[i]);
812         }
813         return computedHash;
814     }
815 
816     /**
817      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
818      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
819      *
820      * _Available since v4.7._
821      */
822     function multiProofVerify(
823         bytes32[] memory proof,
824         bool[] memory proofFlags,
825         bytes32 root,
826         bytes32[] memory leaves
827     ) internal pure returns (bool) {
828         return processMultiProof(proof, proofFlags, leaves) == root;
829     }
830 
831     /**
832      * @dev Calldata version of {multiProofVerify}
833      *
834      * _Available since v4.7._
835      */
836     function multiProofVerifyCalldata(
837         bytes32[] calldata proof,
838         bool[] calldata proofFlags,
839         bytes32 root,
840         bytes32[] memory leaves
841     ) internal pure returns (bool) {
842         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
843     }
844 
845     /**
846      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
847      * consuming from one or the other at each step according to the instructions given by
848      * `proofFlags`.
849      *
850      * _Available since v4.7._
851      */
852     function processMultiProof(
853         bytes32[] memory proof,
854         bool[] memory proofFlags,
855         bytes32[] memory leaves
856     ) internal pure returns (bytes32 merkleRoot) {
857         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
858         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
859         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
860         // the merkle tree.
861         uint256 leavesLen = leaves.length;
862         uint256 totalHashes = proofFlags.length;
863 
864         // Check proof validity.
865         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
866 
867         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
868         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
869         bytes32[] memory hashes = new bytes32[](totalHashes);
870         uint256 leafPos = 0;
871         uint256 hashPos = 0;
872         uint256 proofPos = 0;
873         // At each step, we compute the next hash using two values:
874         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
875         //   get the next hash.
876         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
877         //   `proof` array.
878         for (uint256 i = 0; i < totalHashes; i++) {
879             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
880             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
881             hashes[i] = _hashPair(a, b);
882         }
883 
884         if (totalHashes > 0) {
885             return hashes[totalHashes - 1];
886         } else if (leavesLen > 0) {
887             return leaves[0];
888         } else {
889             return proof[0];
890         }
891     }
892 
893     /**
894      * @dev Calldata version of {processMultiProof}
895      *
896      * _Available since v4.7._
897      */
898     function processMultiProofCalldata(
899         bytes32[] calldata proof,
900         bool[] calldata proofFlags,
901         bytes32[] memory leaves
902     ) internal pure returns (bytes32 merkleRoot) {
903         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
904         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
905         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
906         // the merkle tree.
907         uint256 leavesLen = leaves.length;
908         uint256 totalHashes = proofFlags.length;
909 
910         // Check proof validity.
911         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
912 
913         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
914         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
915         bytes32[] memory hashes = new bytes32[](totalHashes);
916         uint256 leafPos = 0;
917         uint256 hashPos = 0;
918         uint256 proofPos = 0;
919         // At each step, we compute the next hash using two values:
920         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
921         //   get the next hash.
922         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
923         //   `proof` array.
924         for (uint256 i = 0; i < totalHashes; i++) {
925             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
926             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
927             hashes[i] = _hashPair(a, b);
928         }
929 
930         if (totalHashes > 0) {
931             return hashes[totalHashes - 1];
932         } else if (leavesLen > 0) {
933             return leaves[0];
934         } else {
935             return proof[0];
936         }
937     }
938 
939     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
940         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
941     }
942 
943     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
944         /// @solidity memory-safe-assembly
945         assembly {
946             mstore(0x00, a)
947             mstore(0x20, b)
948             value := keccak256(0x00, 0x40)
949         }
950     }
951 }
952 
953 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
954 
955 
956 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @dev Contract module that helps prevent reentrant calls to a function.
962  *
963  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
964  * available, which can be applied to functions to make sure there are no nested
965  * (reentrant) calls to them.
966  *
967  * Note that because there is a single `nonReentrant` guard, functions marked as
968  * `nonReentrant` may not call one another. This can be worked around by making
969  * those functions `private`, and then adding `external` `nonReentrant` entry
970  * points to them.
971  *
972  * TIP: If you would like to learn more about reentrancy and alternative ways
973  * to protect against it, check out our blog post
974  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
975  */
976 abstract contract ReentrancyGuard {
977     // Booleans are more expensive than uint256 or any type that takes up a full
978     // word because each write operation emits an extra SLOAD to first read the
979     // slot's contents, replace the bits taken up by the boolean, and then write
980     // back. This is the compiler's defense against contract upgrades and
981     // pointer aliasing, and it cannot be disabled.
982 
983     // The values being non-zero value makes deployment a bit more expensive,
984     // but in exchange the refund on every call to nonReentrant will be lower in
985     // amount. Since refunds are capped to a percentage of the total
986     // transaction's gas, it is best to keep them low in cases like this one, to
987     // increase the likelihood of the full refund coming into effect.
988     uint256 private constant _NOT_ENTERED = 1;
989     uint256 private constant _ENTERED = 2;
990 
991     uint256 private _status;
992 
993     constructor() {
994         _status = _NOT_ENTERED;
995     }
996 
997     /**
998      * @dev Prevents a contract from calling itself, directly or indirectly.
999      * Calling a `nonReentrant` function from another `nonReentrant`
1000      * function is not supported. It is possible to prevent this from happening
1001      * by making the `nonReentrant` function external, and making it call a
1002      * `private` function that does the actual work.
1003      */
1004     modifier nonReentrant() {
1005         // On the first call to nonReentrant, _notEntered will be true
1006         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1007 
1008         // Any calls to nonReentrant after this point will fail
1009         _status = _ENTERED;
1010 
1011         _;
1012 
1013         // By storing the original value once again, a refund is triggered (see
1014         // https://eips.ethereum.org/EIPS/eip-2200)
1015         _status = _NOT_ENTERED;
1016     }
1017 }
1018 
1019 // File: @openzeppelin/contracts/utils/Context.sol
1020 
1021 
1022 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 /**
1027  * @dev Provides information about the current execution context, including the
1028  * sender of the transaction and its data. While these are generally available
1029  * via msg.sender and msg.data, they should not be accessed in such a direct
1030  * manner, since when dealing with meta-transactions the account sending and
1031  * paying for execution may not be the actual sender (as far as an application
1032  * is concerned).
1033  *
1034  * This contract is only required for intermediate, library-like contracts.
1035  */
1036 abstract contract Context {
1037     function _msgSender() internal view virtual returns (address) {
1038         return msg.sender;
1039     }
1040 
1041     function _msgData() internal view virtual returns (bytes calldata) {
1042         return msg.data;
1043     }
1044 }
1045 
1046 // File: ERC721A.sol
1047 
1048 
1049 // ERC721A Contracts v4.0.0
1050 // Creator: Chiru Labs
1051 
1052 pragma solidity ^0.8.4;
1053 
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 error ApprovalCallerNotOwnerNorApproved();
1065 error ApprovalQueryForNonexistentToken();
1066 error ApproveToCaller();
1067 error ApprovalToCurrentOwner();
1068 error BalanceQueryForZeroAddress();
1069 error MintedQueryForZeroAddress();
1070 error MintToZeroAddress();
1071 error MintZeroQuantity();
1072 error OwnerIndexOutOfBounds();
1073 error OwnerQueryForNonexistentToken();
1074 error TokenIndexOutOfBounds();
1075 error TransferCallerNotOwnerNorApproved();
1076 error TransferFromIncorrectOwner();
1077 error TransferToNonERC721ReceiverImplementer();
1078 error TransferToZeroAddress();
1079 error UnableDetermineTokenOwner();
1080 error URIQueryForNonexistentToken();
1081 
1082 /**
1083  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1084  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1085  *
1086  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1087  *
1088  * Does not support burning tokens to address(0).
1089  *
1090  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1091  */
1092 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1093     using Address for address;
1094     using Strings for uint256;
1095 
1096     struct TokenOwnership {
1097         address addr;
1098         uint64 startTimestamp;
1099     }
1100 
1101     struct AddressData {
1102         uint128 balance;
1103         uint128 numberMinted;
1104     }
1105 
1106     uint256 internal _currentIndex;
1107 
1108     // Token name
1109     string private _name;
1110 
1111     // Token symbol
1112     string private _symbol;
1113 
1114     // Mapping from token ID to ownership details
1115     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1116     mapping(uint256 => TokenOwnership) internal _ownerships;
1117 
1118     // Mapping owner address to address data
1119     mapping(address => AddressData) private _addressData;
1120 
1121     // Mapping from token ID to approved address
1122     mapping(uint256 => address) private _tokenApprovals;
1123 
1124     // Mapping from owner to operator approvals
1125     mapping(address => mapping(address => bool)) private _operatorApprovals;
1126 
1127     constructor(string memory name_, string memory symbol_) {
1128         _name = name_;
1129         _symbol = symbol_;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Enumerable-totalSupply}.
1134      */
1135     function totalSupply() public view override returns (uint256) {
1136         return _currentIndex;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Enumerable-tokenByIndex}.
1141      */
1142     function tokenByIndex(uint256 index) public view override returns (uint256) {
1143         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
1144         return index;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1149      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1150      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1151      */
1152     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1153         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1154         uint256 numMintedSoFar = totalSupply();
1155         uint256 tokenIdsIdx;
1156         address currOwnershipAddr;
1157 
1158         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1159         unchecked {
1160             for (uint256 i; i < numMintedSoFar; i++) {
1161                 TokenOwnership memory ownership = _ownerships[i];
1162                 if (ownership.addr != address(0)) {
1163                     currOwnershipAddr = ownership.addr;
1164                 }
1165                 if (currOwnershipAddr == owner) {
1166                     if (tokenIdsIdx == index) {
1167                         return i;
1168                     }
1169                     tokenIdsIdx++;
1170                 }
1171             }
1172         }
1173 
1174         // Execution should never reach this point.
1175         assert(false);
1176 
1177          return tokenIdsIdx; // or simply return 0;
1178     }
1179 
1180     /**
1181      * @dev See {IERC165-supportsInterface}.
1182      */
1183     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1184         return
1185             interfaceId == type(IERC721).interfaceId ||
1186             interfaceId == type(IERC721Metadata).interfaceId ||
1187             interfaceId == type(IERC721Enumerable).interfaceId ||
1188             super.supportsInterface(interfaceId);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-balanceOf}.
1193      */
1194     function balanceOf(address owner) public view override returns (uint256) {
1195         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1196         return uint256(_addressData[owner].balance);
1197     }
1198 
1199     function _numberMinted(address owner) internal view returns (uint256) {
1200         if (owner == address(0)) revert MintedQueryForZeroAddress();
1201         return uint256(_addressData[owner].numberMinted);
1202     }
1203 
1204     /**
1205      * Gas spent here starts off proportional to the maximum mint batch size.
1206      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1207      */
1208     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1209         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
1210 
1211         unchecked {
1212             for (uint256 curr = tokenId; curr >= 0; curr--) {
1213                 TokenOwnership memory ownership = _ownerships[curr];
1214                 if (ownership.addr != address(0)) {
1215                     return ownership;
1216                 }
1217             }
1218         }
1219 
1220         revert UnableDetermineTokenOwner();
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-ownerOf}.
1225      */
1226     function ownerOf(uint256 tokenId) public view override returns (address) {
1227         return ownershipOf(tokenId).addr;
1228     }
1229 
1230     /**
1231      * @dev See {IERC721Metadata-name}.
1232      */
1233     function name() public view virtual override returns (string memory) {
1234         return _name;
1235     }
1236 
1237     /**
1238      * @dev See {IERC721Metadata-symbol}.
1239      */
1240     function symbol() public view virtual override returns (string memory) {
1241         return _symbol;
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Metadata-tokenURI}.
1246      */
1247     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1248         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1249 
1250         string memory baseURI = _baseURI();
1251         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1252     }
1253 
1254     /**
1255      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1256      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1257      * by default, can be overriden in child contracts.
1258      */
1259     function _baseURI() internal view virtual returns (string memory) {
1260         return '';
1261     }
1262 
1263     /**
1264      * @dev See {IERC721-approve}.
1265      */
1266     function approve(address to, uint256 tokenId) public override {
1267         address owner = ERC721A.ownerOf(tokenId);
1268         if (to == owner) revert ApprovalToCurrentOwner();
1269 
1270         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
1271 
1272         _approve(to, tokenId, owner);
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-getApproved}.
1277      */
1278     function getApproved(uint256 tokenId) public view override returns (address) {
1279         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1280 
1281         return _tokenApprovals[tokenId];
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-setApprovalForAll}.
1286      */
1287     function setApprovalForAll(address operator, bool approved) public override {
1288         if (operator == _msgSender()) revert ApproveToCaller();
1289 
1290         _operatorApprovals[_msgSender()][operator] = approved;
1291         emit ApprovalForAll(_msgSender(), operator, approved);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721-isApprovedForAll}.
1296      */
1297     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1298         return _operatorApprovals[owner][operator];
1299     }
1300 
1301     /**
1302      * @dev See {IERC721-transferFrom}.
1303      */
1304     function transferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) public virtual override {
1309         _transfer(from, to, tokenId);
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-safeTransferFrom}.
1314      */
1315     function safeTransferFrom(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) public virtual override {
1320         safeTransferFrom(from, to, tokenId, '');
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) public override {
1332         _transfer(from, to, tokenId);
1333         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1334     }
1335 
1336     /**
1337      * @dev Returns whether `tokenId` exists.
1338      *
1339      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1340      *
1341      * Tokens start existing when they are minted (`_mint`),
1342      */
1343     function _exists(uint256 tokenId) internal view returns (bool) {
1344         return tokenId < _currentIndex;
1345     }
1346 
1347     function _safeMint(address to, uint256 quantity) internal {
1348         _safeMint(to, quantity, '');
1349     }
1350 
1351     /**
1352      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1353      *
1354      * Requirements:
1355      *
1356      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1357      * - `quantity` must be greater than 0.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _safeMint(
1362         address to,
1363         uint256 quantity,
1364         bytes memory _data
1365     ) internal {
1366         _mint(to, quantity, _data, true);
1367     }
1368 
1369     /**
1370      * @dev Mints `quantity` tokens and transfers them to `to`.
1371      *
1372      * Requirements:
1373      *
1374      * - `to` cannot be the zero address.
1375      * - `quantity` must be greater than 0.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _mint(
1380         address to,
1381         uint256 quantity,
1382         bytes memory _data,
1383         bool safe
1384     ) internal {
1385         uint256 startTokenId = _currentIndex;
1386         if (to == address(0)) revert MintToZeroAddress();
1387         if (quantity == 0) revert MintZeroQuantity();
1388 
1389         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1390 
1391         // Overflows are incredibly unrealistic.
1392         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1393         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1394         unchecked {
1395             _addressData[to].balance += uint128(quantity);
1396             _addressData[to].numberMinted += uint128(quantity);
1397 
1398             _ownerships[startTokenId].addr = to;
1399             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1400 
1401             uint256 updatedIndex = startTokenId;
1402 
1403             for (uint256 i; i < quantity; i++) {
1404                 emit Transfer(address(0), to, updatedIndex);
1405                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1406                     revert TransferToNonERC721ReceiverImplementer();
1407                 }
1408 
1409                 updatedIndex++;
1410             }
1411 
1412             _currentIndex = updatedIndex;
1413         }
1414 
1415         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1416     }
1417 
1418     /**
1419      * @dev Transfers `tokenId` from `from` to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `to` cannot be the zero address.
1424      * - `tokenId` token must be owned by `from`.
1425      *
1426      * Emits a {Transfer} event.
1427      */
1428     function _transfer(
1429         address from,
1430         address to,
1431         uint256 tokenId
1432     ) private {
1433         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1434 
1435         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1436             getApproved(tokenId) == _msgSender() ||
1437             isApprovedForAll(prevOwnership.addr, _msgSender()));
1438 
1439         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1440         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1441         if (to == address(0)) revert TransferToZeroAddress();
1442 
1443         _beforeTokenTransfers(from, to, tokenId, 1);
1444 
1445         // Clear approvals from the previous owner
1446         _approve(address(0), tokenId, prevOwnership.addr);
1447 
1448         // Underflow of the sender's balance is impossible because we check for
1449         // ownership above and the recipient's balance can't realistically overflow.
1450         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1451         unchecked {
1452             _addressData[from].balance -= 1;
1453             _addressData[to].balance += 1;
1454 
1455             _ownerships[tokenId].addr = to;
1456             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1457 
1458             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1459             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1460             uint256 nextTokenId = tokenId + 1;
1461             if (_ownerships[nextTokenId].addr == address(0)) {
1462                 if (_exists(nextTokenId)) {
1463                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1464                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1465                 }
1466             }
1467         }
1468 
1469         emit Transfer(from, to, tokenId);
1470         _afterTokenTransfers(from, to, tokenId, 1);
1471     }
1472 
1473     /**
1474      * @dev Approve `to` to operate on `tokenId`
1475      *
1476      * Emits a {Approval} event.
1477      */
1478     function _approve(
1479         address to,
1480         uint256 tokenId,
1481         address owner
1482     ) private {
1483         _tokenApprovals[tokenId] = to;
1484         emit Approval(owner, to, tokenId);
1485     }
1486 
1487     /**
1488      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1489      * The call is not executed if the target address is not a contract.
1490      *
1491      * @param from address representing the previous owner of the given token ID
1492      * @param to target address that will receive the tokens
1493      * @param tokenId uint256 ID of the token to be transferred
1494      * @param _data bytes optional data to send along with the call
1495      * @return bool whether the call correctly returned the expected magic value
1496      */
1497     function _checkOnERC721Received(
1498         address from,
1499         address to,
1500         uint256 tokenId,
1501         bytes memory _data
1502     ) private returns (bool) {
1503         if (to.isContract()) {
1504             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1505                 return retval == IERC721Receiver(to).onERC721Received.selector;
1506             } catch (bytes memory reason) {
1507                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1508                 else {
1509                     assembly {
1510                         revert(add(32, reason), mload(reason))
1511                     }
1512                 }
1513             }
1514         } else {
1515             return true;
1516         }
1517     }
1518 
1519     /**
1520      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1521      *
1522      * startTokenId - the first token id to be transferred
1523      * quantity - the amount to be transferred
1524      *
1525      * Calling conditions:
1526      *
1527      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1528      * transferred to `to`.
1529      * - When `from` is zero, `tokenId` will be minted for `to`.
1530      */
1531     function _beforeTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 
1538     /**
1539      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1540      * minting.
1541      *
1542      * startTokenId - the first token id to be transferred
1543      * quantity - the amount to be transferred
1544      *
1545      * Calling conditions:
1546      *
1547      * - when `from` and `to` are both non-zero.
1548      * - `from` and `to` are never both zero.
1549      */
1550     function _afterTokenTransfers(
1551         address from,
1552         address to,
1553         uint256 startTokenId,
1554         uint256 quantity
1555     ) internal virtual {}
1556 }
1557 // File: @openzeppelin/contracts/access/Ownable.sol
1558 
1559 
1560 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 
1565 /**
1566  * @dev Contract module which provides a basic access control mechanism, where
1567  * there is an account (an owner) that can be granted exclusive access to
1568  * specific functions.
1569  *
1570  * By default, the owner account will be the one that deploys the contract. This
1571  * can later be changed with {transferOwnership}.
1572  *
1573  * This module is used through inheritance. It will make available the modifier
1574  * `onlyOwner`, which can be applied to your functions to restrict their use to
1575  * the owner.
1576  */
1577 abstract contract Ownable is Context {
1578     address private _owner;
1579 
1580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1581 
1582     /**
1583      * @dev Initializes the contract setting the deployer as the initial owner.
1584      */
1585     constructor() {
1586         _transferOwnership(_msgSender());
1587     }
1588 
1589     /**
1590      * @dev Throws if called by any account other than the owner.
1591      */
1592     modifier onlyOwner() {
1593         _checkOwner();
1594         _;
1595     }
1596 
1597     /**
1598      * @dev Returns the address of the current owner.
1599      */
1600     function owner() public view virtual returns (address) {
1601         return _owner;
1602     }
1603 
1604     /**
1605      * @dev Throws if the sender is not the owner.
1606      */
1607     function _checkOwner() internal view virtual {
1608         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1609     }
1610 
1611     /**
1612      * @dev Leaves the contract without owner. It will not be possible to call
1613      * `onlyOwner` functions anymore. Can only be called by the current owner.
1614      *
1615      * NOTE: Renouncing ownership will leave the contract without an owner,
1616      * thereby removing any functionality that is only available to the owner.
1617      */
1618     function renounceOwnership() public virtual onlyOwner {
1619         _transferOwnership(address(0));
1620     }
1621 
1622     /**
1623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1624      * Can only be called by the current owner.
1625      */
1626     function transferOwnership(address newOwner) public virtual onlyOwner {
1627         require(newOwner != address(0), "Ownable: new owner is the zero address");
1628         _transferOwnership(newOwner);
1629     }
1630 
1631     /**
1632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1633      * Internal function without access restriction.
1634      */
1635     function _transferOwnership(address newOwner) internal virtual {
1636         address oldOwner = _owner;
1637         _owner = newOwner;
1638         emit OwnershipTransferred(oldOwner, newOwner);
1639     }
1640 }
1641 
1642 // File: contract.sol
1643 
1644 
1645 
1646 pragma solidity ^0.8.4;
1647 
1648 /* 
1649 \ gas optimized mint
1650 */
1651 
1652 
1653 
1654 
1655 
1656 error CannotSetZeroAddress();
1657 
1658 contract NYDz is ERC721A, ERC2981, ReentrancyGuard, Ownable {
1659 
1660     address private treasuryAddress;
1661     address wallet1 = 0x446C23066B2B15bD1728F2bADd2Ba72c1C717906;
1662     
1663     bool public publicSale = false;
1664     bool public whitelistSale = false;
1665     bool public revealed = false;
1666 
1667     uint256 private countPay;
1668     uint256 private countFree;
1669     uint256 private countowner;
1670 
1671     uint256 private maxPerTx = 5;
1672     uint256 private maxPerAddress = 5;
1673     uint256 public maxToken = 7777;
1674     uint256 public price = 0.005 ether;
1675     uint256 private FREE_maxToken = 2000;
1676     uint256 private maxFreePerAddress = 1;
1677     uint256 private reserved = 777;
1678     
1679     string private _baseTokenURI;
1680     string private notRevealedUri = "ipfs://QmTbPNerfgShtCV2Pw5ajQ6eZzEyTFFDiZk86D7kjkiKzo/notreveal.json";
1681 
1682     bytes32 root;
1683 
1684     mapping (address => bool) public freeMinted;
1685 
1686     address defaultTreasury = 0x9A7f7dF4B038C77249c29ad24465098c37aE8067;
1687     
1688     constructor() ERC721A("NYDz", "NYDz") {
1689         setTreasuryAddress(payable(defaultTreasury));
1690         setRoyaltyInfo(750);
1691     }
1692 
1693     modifier callerIsUser() {
1694         require(tx.origin == msg.sender, "The caller is another contract");
1695         _;
1696     }
1697 
1698     function numberMinted(address owner) public view returns (uint256) {
1699         return _numberMinted(owner);
1700     }
1701 
1702     function getOwnershipData(uint256 tokenId)
1703         external
1704         view
1705         returns (TokenOwnership memory)
1706     {
1707         return ownershipOf(tokenId);
1708     }
1709 
1710     function verify(bytes32[] memory proof) internal view returns (bool) {
1711         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1712         return MerkleProof.verify(proof, root, leaf);
1713     }
1714 
1715     function mint(uint256 quantity) external payable callerIsUser {
1716         require(publicSale, "SALE_HAS_NOT_STARTED_YET");
1717         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
1718         require(quantity > 0, "INVALID_QUANTITY");
1719 
1720         address _caller = _msgSender();
1721         require(maxToken >= quantity + totalSupply() + reserved, "Exceeds max supply");
1722         require(tx.origin == _caller, "No contracts");
1723       
1724         if(freeMinted[msg.sender] == false && quantity * price == msg.value){
1725             require(maxPerTx >= quantity , "Excess max per tx");
1726             require(quantity * price == msg.value, "Invalid funds provided for tx"); 
1727             countPay = countPay + quantity;
1728         }else if(freeMinted[msg.sender] == false && FREE_maxToken + countowner > totalSupply() - countPay){
1729             require(maxPerTx >= quantity , "Excess max per tx");
1730             require((quantity - 1) * price == msg.value, "Invalid funds provided"); 
1731             countPay = countPay + (quantity - 1);
1732             countFree++;
1733 		    freeMinted[msg.sender] = true;
1734         }else{
1735 		    require(maxPerTx >= quantity , "Excess max per tx");
1736             require(quantity * price == msg.value, "Invalid funds provided");
1737 			countPay = countPay + quantity;
1738 		}
1739 
1740         _safeMint(_caller, quantity);
1741     }
1742 
1743     function WhitelistMint(uint256 quantity) external payable callerIsUser {
1744         require(whitelistSale, "SALE_HAS_NOT_STARTED_YET");
1745         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
1746         require(quantity > 0, "INVALID_QUANTITY");
1747 
1748         address _caller = _msgSender();
1749         require(maxToken >= quantity + totalSupply() + reserved, "Exceeds max supply");
1750         require(tx.origin == _caller, "No contracts");
1751                 
1752         if(freeMinted[msg.sender] == false && quantity * price == msg.value){
1753             require(maxPerTx >= quantity , "Excess max per tx");
1754             require(quantity * price == msg.value, "Invalid funds provided for tx"); 
1755             countPay = countPay + quantity;
1756         }else if(freeMinted[msg.sender] == false && FREE_maxToken + countowner > totalSupply() - countPay){
1757             require(maxPerTx >= quantity , "Excess max per tx");
1758             require((quantity - 1) * price == msg.value, "Invalid funds provided"); 
1759             countPay = countPay + (quantity - 1);
1760             countFree++;
1761 		    freeMinted[msg.sender] = true;
1762         }else{
1763 		    require(maxPerTx >= quantity , "Excess max per tx");
1764             require(quantity * price == msg.value, "Invalid funds provided");
1765 			countPay = countPay + quantity;
1766 		}
1767 
1768         _safeMint(_caller, quantity);
1769     }
1770 
1771     function ownerMint(address _address, uint256 quantity) external onlyOwner {
1772         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT");
1773         _safeMint(_address, quantity);
1774         reserved = reserved - quantity;
1775         countowner = countowner + quantity;
1776     }
1777 
1778 
1779     function tokenURI(uint256 tokenId)
1780         public
1781         view
1782         virtual
1783         override
1784         returns (string memory)
1785     {
1786         require(
1787             _exists(tokenId),
1788             "ERC721Metadata: URI query for nonexistent token"
1789         );
1790 
1791         if (revealed == false) {
1792             return notRevealedUri;
1793         }
1794 
1795         string memory _tokenURI = super.tokenURI(tokenId);
1796         return
1797             bytes(_tokenURI).length > 0
1798                 ? string(abi.encodePacked(_tokenURI, ".json"))
1799                 : "";
1800     }
1801 
1802     function _baseURI() internal view virtual override returns (string memory) {
1803         return _baseTokenURI;
1804     }
1805 
1806     function setPrice(uint256 _PriceInWEI) external onlyOwner {
1807         price = _PriceInWEI;
1808     }
1809 
1810     function setRoot(bytes32 _root) external onlyOwner {
1811         root = _root;
1812     }
1813 
1814     function flipPublicSaleState() external onlyOwner {
1815         publicSale = !publicSale;
1816     }
1817 
1818     function flipWhitelistState() external onlyOwner {
1819         whitelistSale = !whitelistSale;
1820     }
1821 
1822     function setBaseURI(string calldata baseURI) external onlyOwner {
1823         _baseTokenURI = baseURI;
1824     }
1825 
1826     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
1827         notRevealedUri = _notRevealedURI;
1828     }
1829 
1830     function reveal() external onlyOwner {
1831         revealed = !revealed;
1832     }
1833 
1834         /**
1835      * @dev Update the royalty percentage (750 = 7,5%)
1836      */
1837     function setRoyaltyInfo(uint96 newRoyaltyPercentage) public onlyOwner {
1838         _setDefaultRoyalty(treasuryAddress, newRoyaltyPercentage);
1839     }
1840 
1841       /**
1842      * @dev Update the royalty wallet address
1843      */
1844     function setTreasuryAddress(address payable newAddress) public onlyOwner {
1845         if (newAddress == address(0)) revert CannotSetZeroAddress();
1846         treasuryAddress = newAddress;
1847     }
1848 
1849         /**
1850      * @dev Withdraw funds to treasuryAddress
1851      */    
1852      function withdrawAll() external onlyOwner {
1853         uint256 currentBalance = address(this).balance;
1854         uint256 twentyfivePercent = (currentBalance/100)*25;
1855 
1856         require(payable(wallet1).send(twentyfivePercent));
1857         Address.sendValue(payable(treasuryAddress), address(this).balance);
1858     }
1859 
1860         /**
1861      * @dev {ERC165-supportsInterface} Adding IERC2981
1862      */
1863     function supportsInterface(bytes4 interfaceId)
1864         public
1865         view
1866         override(ERC721A, ERC2981)
1867         returns (bool)
1868     {
1869         return
1870             ERC2981.supportsInterface(interfaceId) ||
1871             super.supportsInterface(interfaceId);
1872     }
1873 
1874 }