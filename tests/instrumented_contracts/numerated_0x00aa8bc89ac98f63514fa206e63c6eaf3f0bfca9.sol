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
362 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
363 
364 
365 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Required interface of an ERC721 compliant contract.
372  */
373 interface IERC721 is IERC165 {
374     /**
375      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
376      */
377     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
378 
379     /**
380      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
381      */
382     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
383 
384     /**
385      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
386      */
387     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
388 
389     /**
390      * @dev Returns the number of tokens in ``owner``'s account.
391      */
392     function balanceOf(address owner) external view returns (uint256 balance);
393 
394     /**
395      * @dev Returns the owner of the `tokenId` token.
396      *
397      * Requirements:
398      *
399      * - `tokenId` must exist.
400      */
401     function ownerOf(uint256 tokenId) external view returns (address owner);
402 
403     /**
404      * @dev Safely transfers `tokenId` token from `from` to `to`.
405      *
406      * Requirements:
407      *
408      * - `from` cannot be the zero address.
409      * - `to` cannot be the zero address.
410      * - `tokenId` token must exist and be owned by `from`.
411      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
412      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId,
420         bytes calldata data
421     ) external;
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must exist and be owned by `from`.
432      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
434      *
435      * Emits a {Transfer} event.
436      */
437     function safeTransferFrom(
438         address from,
439         address to,
440         uint256 tokenId
441     ) external;
442 
443     /**
444      * @dev Transfers `tokenId` token from `from` to `to`.
445      *
446      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `tokenId` token must be owned by `from`.
453      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
465      * The approval is cleared when the token is transferred.
466      *
467      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
468      *
469      * Requirements:
470      *
471      * - The caller must own the token or be an approved operator.
472      * - `tokenId` must exist.
473      *
474      * Emits an {Approval} event.
475      */
476     function approve(address to, uint256 tokenId) external;
477 
478     /**
479      * @dev Approve or remove `operator` as an operator for the caller.
480      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
481      *
482      * Requirements:
483      *
484      * - The `operator` cannot be the caller.
485      *
486      * Emits an {ApprovalForAll} event.
487      */
488     function setApprovalForAll(address operator, bool _approved) external;
489 
490     /**
491      * @dev Returns the account approved for `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function getApproved(uint256 tokenId) external view returns (address operator);
498 
499     /**
500      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
501      *
502      * See {setApprovalForAll}
503      */
504     function isApprovedForAll(address owner, address operator) external view returns (bool);
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
517  * @dev See https://eips.ethereum.org/EIPS/eip-721
518  */
519 interface IERC721Metadata is IERC721 {
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 }
535 
536 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
568 
569 
570 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @dev Interface for the NFT Royalty Standard.
577  *
578  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
579  * support for royalty payments across all NFT marketplaces and ecosystem participants.
580  *
581  * _Available since v4.5._
582  */
583 interface IERC2981 is IERC165 {
584     /**
585      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
586      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
587      */
588     function royaltyInfo(uint256 tokenId, uint256 salePrice)
589         external
590         view
591         returns (address receiver, uint256 royaltyAmount);
592 }
593 
594 // File: @openzeppelin/contracts/token/common/ERC2981.sol
595 
596 
597 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 
603 /**
604  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
605  *
606  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
607  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
608  *
609  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
610  * fee is specified in basis points by default.
611  *
612  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
613  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
614  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
615  *
616  * _Available since v4.5._
617  */
618 abstract contract ERC2981 is IERC2981, ERC165 {
619     struct RoyaltyInfo {
620         address receiver;
621         uint96 royaltyFraction;
622     }
623 
624     RoyaltyInfo private _defaultRoyaltyInfo;
625     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
626 
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
631         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
632     }
633 
634     /**
635      * @inheritdoc IERC2981
636      */
637     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
638         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
639 
640         if (royalty.receiver == address(0)) {
641             royalty = _defaultRoyaltyInfo;
642         }
643 
644         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
645 
646         return (royalty.receiver, royaltyAmount);
647     }
648 
649     /**
650      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
651      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
652      * override.
653      */
654     function _feeDenominator() internal pure virtual returns (uint96) {
655         return 10000;
656     }
657 
658     /**
659      * @dev Sets the royalty information that all ids in this contract will default to.
660      *
661      * Requirements:
662      *
663      * - `receiver` cannot be the zero address.
664      * - `feeNumerator` cannot be greater than the fee denominator.
665      */
666     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
667         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
668         require(receiver != address(0), "ERC2981: invalid receiver");
669 
670         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
671     }
672 
673     /**
674      * @dev Removes default royalty information.
675      */
676     function _deleteDefaultRoyalty() internal virtual {
677         delete _defaultRoyaltyInfo;
678     }
679 
680     /**
681      * @dev Sets the royalty information for a specific token id, overriding the global default.
682      *
683      * Requirements:
684      *
685      * - `receiver` cannot be the zero address.
686      * - `feeNumerator` cannot be greater than the fee denominator.
687      */
688     function _setTokenRoyalty(
689         uint256 tokenId,
690         address receiver,
691         uint96 feeNumerator
692     ) internal virtual {
693         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
694         require(receiver != address(0), "ERC2981: Invalid parameters");
695 
696         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
697     }
698 
699     /**
700      * @dev Resets royalty information for the token id back to the global default.
701      */
702     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
703         delete _tokenRoyaltyInfo[tokenId];
704     }
705 }
706 
707 // File: @openzeppelin/contracts/utils/Context.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @dev Provides information about the current execution context, including the
716  * sender of the transaction and its data. While these are generally available
717  * via msg.sender and msg.data, they should not be accessed in such a direct
718  * manner, since when dealing with meta-transactions the account sending and
719  * paying for execution may not be the actual sender (as far as an application
720  * is concerned).
721  *
722  * This contract is only required for intermediate, library-like contracts.
723  */
724 abstract contract Context {
725     function _msgSender() internal view virtual returns (address) {
726         return msg.sender;
727     }
728 
729     function _msgData() internal view virtual returns (bytes calldata) {
730         return msg.data;
731     }
732 }
733 
734 // File: ERC721A.sol
735 
736 
737 // Creator: Chiru Labs
738 
739 pragma solidity ^0.8.4;
740 
741 
742 
743 
744 
745 
746 
747 
748 error ApprovalCallerNotOwnerNorApproved();
749 error ApprovalQueryForNonexistentToken();
750 error ApproveToCaller();
751 error ApprovalToCurrentOwner();
752 error BalanceQueryForZeroAddress();
753 error MintToZeroAddress();
754 error MintZeroQuantity();
755 error OwnerQueryForNonexistentToken();
756 error TransferCallerNotOwnerNorApproved();
757 error TransferFromIncorrectOwner();
758 error TransferToNonERC721ReceiverImplementer();
759 error TransferToZeroAddress();
760 error URIQueryForNonexistentToken();
761 
762 /**
763  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
764  * the Metadata extension. Built to optimize for lower gas during batch mints.
765  *
766  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
767  *
768  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
769  *
770  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
771  */
772 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
773     using Address for address;
774     using Strings for uint256;
775 
776     // Compiler will pack this into a single 256bit word.
777     struct TokenOwnership {
778         // The address of the owner.
779         address addr;
780         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
781         uint64 startTimestamp;
782         // Whether the token has been burned.
783         bool burned;
784     }
785 
786     // Compiler will pack this into a single 256bit word.
787     struct AddressData {
788         // Realistically, 2**64-1 is more than enough.
789         uint64 balance;
790         // Keeps track of mint count with minimal overhead for tokenomics.
791         uint64 numberMinted;
792         // Keeps track of burn count with minimal overhead for tokenomics.
793         uint64 numberBurned;
794         // For miscellaneous variable(s) pertaining to the address
795         // (e.g. number of whitelist mint slots used).
796         // If there are multiple variables, please pack them into a uint64.
797         uint64 aux;
798     }
799 
800     // The tokenId of the next token to be minted.
801     uint256 internal _currentIndex;
802 
803     // The number of tokens burned.
804     uint256 internal _burnCounter;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to ownership details
813     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
814     mapping(uint256 => TokenOwnership) internal _ownerships;
815 
816     // Mapping owner address to address data
817     mapping(address => AddressData) private _addressData;
818 
819     // Mapping from token ID to approved address
820     mapping(uint256 => address) private _tokenApprovals;
821 
822     // Mapping from owner to operator approvals
823     mapping(address => mapping(address => bool)) private _operatorApprovals;
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828         _currentIndex = _startTokenId();
829     }
830 
831     /**
832      * To change the starting tokenId, please override this function.
833      */
834     function _startTokenId() internal view virtual returns (uint256) {
835         return 0;
836     }
837 
838     /**
839      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
840      */
841     function totalSupply() public view returns (uint256) {
842         // Counter underflow is impossible as _burnCounter cannot be incremented
843         // more than _currentIndex - _startTokenId() times
844         unchecked {
845             return _currentIndex - _burnCounter - _startTokenId();
846         }
847     }
848 
849     /**
850      * Returns the total amount of tokens minted in the contract.
851      */
852     function _totalMinted() internal view returns (uint256) {
853         // Counter underflow is impossible as _currentIndex does not decrement,
854         // and it is initialized to _startTokenId()
855         unchecked {
856             return _currentIndex - _startTokenId();
857         }
858     }
859 
860     /**
861      * @dev See {IERC165-supportsInterface}.
862      */
863     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
864         return
865             interfaceId == type(IERC721).interfaceId ||
866             interfaceId == type(IERC721Metadata).interfaceId ||
867             super.supportsInterface(interfaceId);
868     }
869 
870     /**
871      * @dev See {IERC721-balanceOf}.
872      */
873     function balanceOf(address owner) public view override returns (uint256) {
874         if (owner == address(0)) revert BalanceQueryForZeroAddress();
875         return uint256(_addressData[owner].balance);
876     }
877 
878     /**
879      * Returns the number of tokens minted by `owner`.
880      */
881     function _numberMinted(address owner) internal view returns (uint256) {
882         return uint256(_addressData[owner].numberMinted);
883     }
884 
885     /**
886      * Returns the number of tokens burned by or on behalf of `owner`.
887      */
888     function _numberBurned(address owner) internal view returns (uint256) {
889         return uint256(_addressData[owner].numberBurned);
890     }
891 
892     /**
893      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      */
895     function _getAux(address owner) internal view returns (uint64) {
896         return _addressData[owner].aux;
897     }
898 
899     /**
900      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      * If there are multiple variables, please pack them into a uint64.
902      */
903     function _setAux(address owner, uint64 aux) internal {
904         _addressData[owner].aux = aux;
905     }
906 
907     /**
908      * Gas spent here starts off proportional to the maximum mint batch size.
909      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
910      */
911     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
912         uint256 curr = tokenId;
913 
914         unchecked {
915             if (_startTokenId() <= curr && curr < _currentIndex) {
916                 TokenOwnership memory ownership = _ownerships[curr];
917                 if (!ownership.burned) {
918                     if (ownership.addr != address(0)) {
919                         return ownership;
920                     }
921                     // Invariant:
922                     // There will always be an ownership that has an address and is not burned
923                     // before an ownership that does not have an address and is not burned.
924                     // Hence, curr will not underflow.
925                     while (true) {
926                         curr--;
927                         ownership = _ownerships[curr];
928                         if (ownership.addr != address(0)) {
929                             return ownership;
930                         }
931                     }
932                 }
933             }
934         }
935         revert OwnerQueryForNonexistentToken();
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view override returns (address) {
942         return _ownershipOf(tokenId).addr;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
963         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
964 
965         string memory baseURI = _baseURI();
966         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
967     }
968 
969     /**
970      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
971      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
972      * by default, can be overriden in child contracts.
973      */
974     function _baseURI() internal view virtual returns (string memory) {
975         return '';
976     }
977 
978     /**
979      * @dev See {IERC721-approve}.
980      */
981     function approve(address to, uint256 tokenId) public override {
982         address owner = ERC721A.ownerOf(tokenId);
983         if (to == owner) revert ApprovalToCurrentOwner();
984 
985         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
986             revert ApprovalCallerNotOwnerNorApproved();
987         }
988 
989         _approve(to, tokenId, owner);
990     }
991 
992     /**
993      * @dev See {IERC721-getApproved}.
994      */
995     function getApproved(uint256 tokenId) public view override returns (address) {
996         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
997 
998         return _tokenApprovals[tokenId];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-setApprovalForAll}.
1003      */
1004     function setApprovalForAll(address operator, bool approved) public virtual override {
1005         if (operator == _msgSender()) revert ApproveToCaller();
1006 
1007         _operatorApprovals[_msgSender()][operator] = approved;
1008         emit ApprovalForAll(_msgSender(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         safeTransferFrom(from, to, tokenId, '');
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1051             revert TransferToNonERC721ReceiverImplementer();
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns whether `tokenId` exists.
1057      *
1058      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1059      *
1060      * Tokens start existing when they are minted (`_mint`),
1061      */
1062     function _exists(uint256 tokenId) internal view returns (bool) {
1063         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1064     }
1065 
1066     function _safeMint(address to, uint256 quantity) internal {
1067         _safeMint(to, quantity, '');
1068     }
1069 
1070     /**
1071      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data
1084     ) internal {
1085         _mint(to, quantity, _data, true);
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _mint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data,
1102         bool safe
1103     ) internal {
1104         uint256 startTokenId = _currentIndex;
1105         if (to == address(0)) revert MintToZeroAddress();
1106         if (quantity == 0) revert MintZeroQuantity();
1107 
1108         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1109 
1110         // Overflows are incredibly unrealistic.
1111         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1112         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1113         unchecked {
1114             _addressData[to].balance += uint64(quantity);
1115             _addressData[to].numberMinted += uint64(quantity);
1116 
1117             _ownerships[startTokenId].addr = to;
1118             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1119 
1120             uint256 updatedIndex = startTokenId;
1121             uint256 end = updatedIndex + quantity;
1122 
1123             if (safe && to.isContract()) {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex);
1126                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1127                         revert TransferToNonERC721ReceiverImplementer();
1128                     }
1129                 } while (updatedIndex != end);
1130                 // Reentrancy protection
1131                 if (_currentIndex != startTokenId) revert();
1132             } else {
1133                 do {
1134                     emit Transfer(address(0), to, updatedIndex++);
1135                 } while (updatedIndex != end);
1136             }
1137             _currentIndex = updatedIndex;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `tokenId` token must be owned by `from`.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) private {
1157         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1158 
1159         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1160 
1161         bool isApprovedOrOwner = (_msgSender() == from ||
1162             isApprovedForAll(from, _msgSender()) ||
1163             getApproved(tokenId) == _msgSender());
1164 
1165         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1166         if (to == address(0)) revert TransferToZeroAddress();
1167 
1168         _beforeTokenTransfers(from, to, tokenId, 1);
1169 
1170         // Clear approvals from the previous owner
1171         _approve(address(0), tokenId, from);
1172 
1173         // Underflow of the sender's balance is impossible because we check for
1174         // ownership above and the recipient's balance can't realistically overflow.
1175         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1176         unchecked {
1177             _addressData[from].balance -= 1;
1178             _addressData[to].balance += 1;
1179 
1180             TokenOwnership storage currSlot = _ownerships[tokenId];
1181             currSlot.addr = to;
1182             currSlot.startTimestamp = uint64(block.timestamp);
1183 
1184             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1185             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1186             uint256 nextTokenId = tokenId + 1;
1187             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1188             if (nextSlot.addr == address(0)) {
1189                 // This will suffice for checking _exists(nextTokenId),
1190                 // as a burned slot cannot contain the zero address.
1191                 if (nextTokenId != _currentIndex) {
1192                     nextSlot.addr = from;
1193                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1194                 }
1195             }
1196         }
1197 
1198         emit Transfer(from, to, tokenId);
1199         _afterTokenTransfers(from, to, tokenId, 1);
1200     }
1201 
1202     /**
1203      * @dev This is equivalent to _burn(tokenId, false)
1204      */
1205     function _burn(uint256 tokenId) internal virtual {
1206         _burn(tokenId, false);
1207     }
1208 
1209     /**
1210      * @dev Destroys `tokenId`.
1211      * The approval is cleared when the token is burned.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1220         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1221 
1222         address from = prevOwnership.addr;
1223 
1224         if (approvalCheck) {
1225             bool isApprovedOrOwner = (_msgSender() == from ||
1226                 isApprovedForAll(from, _msgSender()) ||
1227                 getApproved(tokenId) == _msgSender());
1228 
1229             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1230         }
1231 
1232         _beforeTokenTransfers(from, address(0), tokenId, 1);
1233 
1234         // Clear approvals from the previous owner
1235         _approve(address(0), tokenId, from);
1236 
1237         // Underflow of the sender's balance is impossible because we check for
1238         // ownership above and the recipient's balance can't realistically overflow.
1239         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1240         unchecked {
1241             AddressData storage addressData = _addressData[from];
1242             addressData.balance -= 1;
1243             addressData.numberBurned += 1;
1244 
1245             // Keep track of who burned the token, and the timestamp of burning.
1246             TokenOwnership storage currSlot = _ownerships[tokenId];
1247             currSlot.addr = from;
1248             currSlot.startTimestamp = uint64(block.timestamp);
1249             currSlot.burned = true;
1250 
1251             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1252             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1253             uint256 nextTokenId = tokenId + 1;
1254             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1255             if (nextSlot.addr == address(0)) {
1256                 // This will suffice for checking _exists(nextTokenId),
1257                 // as a burned slot cannot contain the zero address.
1258                 if (nextTokenId != _currentIndex) {
1259                     nextSlot.addr = from;
1260                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, address(0), tokenId);
1266         _afterTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1269         unchecked {
1270             _burnCounter++;
1271         }
1272     }
1273 
1274     /**
1275      * @dev Approve `to` to operate on `tokenId`
1276      *
1277      * Emits a {Approval} event.
1278      */
1279     function _approve(
1280         address to,
1281         uint256 tokenId,
1282         address owner
1283     ) private {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(owner, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkContractOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) private returns (bool) {
1303         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1304             return retval == IERC721Receiver(to).onERC721Received.selector;
1305         } catch (bytes memory reason) {
1306             if (reason.length == 0) {
1307                 revert TransferToNonERC721ReceiverImplementer();
1308             } else {
1309                 assembly {
1310                     revert(add(32, reason), mload(reason))
1311                 }
1312             }
1313         }
1314     }
1315 
1316     /**
1317      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1318      * And also called before burning one token.
1319      *
1320      * startTokenId - the first token id to be transferred
1321      * quantity - the amount to be transferred
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
1328      * - When `to` is zero, `tokenId` will be burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _beforeTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 
1338     /**
1339      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1340      * minting.
1341      * And also called after one token has been burned.
1342      *
1343      * startTokenId - the first token id to be transferred
1344      * quantity - the amount to be transferred
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` has been minted for `to`.
1351      * - When `to` is zero, `tokenId` has been burned by `from`.
1352      * - `from` and `to` are never both zero.
1353      */
1354     function _afterTokenTransfers(
1355         address from,
1356         address to,
1357         uint256 startTokenId,
1358         uint256 quantity
1359     ) internal virtual {}
1360 }
1361 // File: @openzeppelin/contracts/access/Ownable.sol
1362 
1363 
1364 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 
1369 /**
1370  * @dev Contract module which provides a basic access control mechanism, where
1371  * there is an account (an owner) that can be granted exclusive access to
1372  * specific functions.
1373  *
1374  * By default, the owner account will be the one that deploys the contract. This
1375  * can later be changed with {transferOwnership}.
1376  *
1377  * This module is used through inheritance. It will make available the modifier
1378  * `onlyOwner`, which can be applied to your functions to restrict their use to
1379  * the owner.
1380  */
1381 abstract contract Ownable is Context {
1382     address private _owner;
1383 
1384     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1385 
1386     /**
1387      * @dev Initializes the contract setting the deployer as the initial owner.
1388      */
1389     constructor() {
1390         _transferOwnership(_msgSender());
1391     }
1392 
1393     /**
1394      * @dev Throws if called by any account other than the owner.
1395      */
1396     modifier onlyOwner() {
1397         _checkOwner();
1398         _;
1399     }
1400 
1401     /**
1402      * @dev Returns the address of the current owner.
1403      */
1404     function owner() public view virtual returns (address) {
1405         return _owner;
1406     }
1407 
1408     /**
1409      * @dev Throws if the sender is not the owner.
1410      */
1411     function _checkOwner() internal view virtual {
1412         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1413     }
1414 
1415     /**
1416      * @dev Leaves the contract without owner. It will not be possible to call
1417      * `onlyOwner` functions anymore. Can only be called by the current owner.
1418      *
1419      * NOTE: Renouncing ownership will leave the contract without an owner,
1420      * thereby removing any functionality that is only available to the owner.
1421      */
1422     function renounceOwnership() public virtual onlyOwner {
1423         _transferOwnership(address(0));
1424     }
1425 
1426     /**
1427      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1428      * Can only be called by the current owner.
1429      */
1430     function transferOwnership(address newOwner) public virtual onlyOwner {
1431         require(newOwner != address(0), "Ownable: new owner is the zero address");
1432         _transferOwnership(newOwner);
1433     }
1434 
1435     /**
1436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1437      * Internal function without access restriction.
1438      */
1439     function _transferOwnership(address newOwner) internal virtual {
1440         address oldOwner = _owner;
1441         _owner = newOwner;
1442         emit OwnershipTransferred(oldOwner, newOwner);
1443     }
1444 }
1445 
1446 // File: Specter.sol
1447 
1448 
1449 
1450 pragma solidity ^0.8.4;
1451 
1452 
1453 
1454 
1455 contract Specter is ERC2981, ERC721A, Ownable {
1456     using Strings for uint256;
1457 
1458     uint32 public constant MAX_SUPPLY = 888;
1459 
1460     uint32 public FREE_SUPPLY = 444;
1461 
1462     uint32 public _freeMintTotal;
1463 
1464     uint32 public _MintPerWallet = 10;
1465     uint32 public _freeLimitPerWallet = 1;
1466     bool public _publicMintActive = true;
1467     bool public _freeMintActive = true;
1468     uint256 public _price = 0.001 ether;
1469 
1470     string public _prerevealURI = "ipfs://QmX36KvRzgVBkqKQY5M6Z6eEQTYTYLHUay8kkAYvPLo6jf";
1471     string public _matadataURI;
1472 
1473     constructor() ERC721A("specter", "SR") {
1474         _setDefaultRoyalty(msg.sender, 750);
1475     }
1476 
1477 
1478     modifier callerIsUser() {
1479         require(tx.origin == msg.sender, "Contract caller forbidden");
1480         _;
1481     }
1482 
1483     modifier supplyCompliance(uint32 amount) {
1484         require(_totalMinted() + amount <= MAX_SUPPLY, "Exceed max supply");
1485         _;
1486     }
1487 
1488     modifier publicCompliance(uint32 amount) {
1489         require(_publicMintActive, "Public mint is inactive");
1490         require(msg.value == _price * amount, "Value error");
1491         require(
1492 
1493             _numberMinted(msg.sender) + amount <= _MintPerWallet,
1494             "Exceed public mint limit per wallet"
1495         );
1496         _;
1497     }
1498     
1499     modifier freeCompliance(uint32 amount) {
1500         require(_freeMintActive, "Free mint is inactive");
1501         require(_freeMintTotal < FREE_SUPPLY, "Exceed free supply");
1502         require(
1503             _getAux(msg.sender) + amount <= _freeLimitPerWallet,
1504             "Exceed free mint limit per wallet"
1505         );
1506         _;
1507     }
1508 
1509 
1510     // Public Read
1511 
1512     function tokenURI(uint256 tokenId)
1513         public
1514         view
1515 
1516         override
1517         returns (string memory)
1518     {
1519         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1520 
1521         string memory baseURI = _matadataURI;
1522         return
1523             bytes(baseURI).length != 0
1524                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1525                 : _prerevealURI;
1526     }
1527 
1528 
1529     function _startTokenId() internal pure override returns (uint256) {
1530         return 1;
1531     }
1532 
1533     function numberMinted(address owner) public view returns (uint256) {
1534         return _numberMinted(owner);
1535     }
1536 
1537 
1538 
1539     function supportsInterface(bytes4 interfaceId)
1540         public
1541         view
1542         virtual
1543         override(ERC2981, ERC721A)
1544         returns (bool)
1545     {
1546         return
1547             interfaceId == type(IERC2981).interfaceId ||
1548             interfaceId == type(IERC721).interfaceId ||
1549             super.supportsInterface(interfaceId);
1550     }
1551 
1552     // Public Write
1553     function mint(uint32 amount)
1554         external
1555         payable
1556         supplyCompliance(amount)
1557         publicCompliance(amount)
1558         callerIsUser
1559     {
1560         _mint(msg.sender, amount, "", false);
1561     }
1562 
1563     function freeMint()
1564         external
1565         supplyCompliance(1)
1566         freeCompliance(1)
1567         callerIsUser
1568     {
1569         _setAux(msg.sender, _getAux(msg.sender) + 1);
1570         _freeMintTotal += 1;
1571         _mint(msg.sender, 1, "", false);
1572     }
1573     // Only Owner
1574 
1575    
1576     function setPublicLimitPerWallet(uint32 MintPerWallet) external onlyOwner {
1577         _MintPerWallet = MintPerWallet;
1578     }
1579 
1580     function set_free_supply(uint32 FREE_SUPPLY_NUM) external onlyOwner {
1581         FREE_SUPPLY = FREE_SUPPLY_NUM;
1582     }
1583 
1584     function flipPublicMintActive() external onlyOwner {
1585         _publicMintActive = !_publicMintActive;
1586     }
1587     function flipFreeMintActive() external onlyOwner {
1588         _freeMintActive = !_freeMintActive;
1589     }
1590 
1591     function setPrerevealURI(string calldata prerevealURI) external onlyOwner {
1592         _prerevealURI = prerevealURI;
1593     }
1594     
1595     function setMetadataURI(string calldata metadataURI) external onlyOwner {
1596         _matadataURI = metadataURI;
1597     }
1598 
1599     function setPrice(uint256 price) external onlyOwner {
1600         _price = price;
1601     }
1602 
1603     function setFeeNumerator(address receiver, uint96 feeNumerator) public onlyOwner {
1604         _setDefaultRoyalty(receiver, feeNumerator);
1605     }
1606 
1607     function withdraw(address to) external onlyOwner {
1608         payable(to).transfer(address(this).balance);
1609     }
1610 }