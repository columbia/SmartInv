1 // File: @openzeppelin/contracts/utils/Strings.sol
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
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Address.sol
99 
100 
101 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
102 
103 pragma solidity ^0.8.1;
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      *
126      * [IMPORTANT]
127      * ====
128      * You shouldn't rely on `isContract` to protect against flash loan attacks!
129      *
130      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
131      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
132      * constructor.
133      * ====
134      */
135     function isContract(address account) internal view returns (bool) {
136         // This method relies on extcodesize/address.code.length, which returns 0
137         // for contracts in construction, since the code is only stored at the end
138         // of the constructor execution.
139 
140         return account.code.length > 0;
141     }
142 
143     /**
144      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
145      * `recipient`, forwarding all available gas and reverting on errors.
146      *
147      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
148      * of certain opcodes, possibly making contracts go over the 2300 gas limit
149      * imposed by `transfer`, making them unable to receive funds via
150      * `transfer`. {sendValue} removes this limitation.
151      *
152      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
153      *
154      * IMPORTANT: because control is transferred to `recipient`, care must be
155      * taken to not create reentrancy vulnerabilities. Consider using
156      * {ReentrancyGuard} or the
157      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
158      */
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         (bool success, ) = recipient.call{value: amount}("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
223      * with `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(address(this).balance >= value, "Address: insufficient balance for call");
234         require(isContract(target), "Address: call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.call{value: value}(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
247         return functionStaticCall(target, data, "Address: low-level static call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311 
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
324 
325 
326 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC165 standard, as defined in the
362  * https://eips.ethereum.org/EIPS/eip-165[EIP].
363  *
364  * Implementers can declare support of contract interfaces, which can then be
365  * queried by others ({ERC165Checker}).
366  *
367  * For an implementation, see {ERC165}.
368  */
369 interface IERC165 {
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 }
380 
381 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Implementation of the {IERC165} interface.
391  *
392  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
393  * for the additional interface id that will be supported. For example:
394  *
395  * ```solidity
396  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
398  * }
399  * ```
400  *
401  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
402  */
403 abstract contract ERC165 is IERC165 {
404     /**
405      * @dev See {IERC165-supportsInterface}.
406      */
407     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408         return interfaceId == type(IERC165).interfaceId;
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
413 
414 
415 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Required interface of an ERC721 compliant contract.
422  */
423 interface IERC721 is IERC165 {
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in ``owner``'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 
473     /**
474      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
475      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Transfers `tokenId` token from `from` to `to`.
495      *
496      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must be owned by `from`.
503      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     /**
514      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
515      * The approval is cleared when the token is transferred.
516      *
517      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
518      *
519      * Requirements:
520      *
521      * - The caller must own the token or be an approved operator.
522      * - `tokenId` must exist.
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address to, uint256 tokenId) external;
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns the account approved for `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function getApproved(uint256 tokenId) external view returns (address operator);
548 
549     /**
550      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
551      *
552      * See {setApprovalForAll}
553      */
554     function isApprovedForAll(address owner, address operator) external view returns (bool);
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Enumerable is IERC721 {
570     /**
571      * @dev Returns the total amount of tokens stored by the contract.
572      */
573     function totalSupply() external view returns (uint256);
574 
575     /**
576      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
577      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
578      */
579     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
580 
581     /**
582      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
583      * Use along with {totalSupply} to enumerate all tokens.
584      */
585     function tokenByIndex(uint256 index) external view returns (uint256);
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
598  * @dev See https://eips.ethereum.org/EIPS/eip-721
599  */
600 interface IERC721Metadata is IERC721 {
601     /**
602      * @dev Returns the token collection name.
603      */
604     function name() external view returns (string memory);
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() external view returns (string memory);
610 
611     /**
612      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
613      */
614     function tokenURI(uint256 tokenId) external view returns (string memory);
615 }
616 
617 // File: ERC721A.sol
618 
619 
620 // Creator: Chiru Labs
621 
622 pragma solidity ^0.8.0;
623 
624 
625 
626 
627 
628 
629 
630 
631 
632 /**
633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
634  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
635  *
636  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
637  *
638  * Does not support burning tokens to address(0).
639  *
640  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
641  */
642 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
643     using Address for address;
644     using Strings for uint256;
645 
646     struct TokenOwnership {
647         address addr;
648         uint64 startTimestamp;
649     }
650 
651     struct AddressData {
652         uint128 balance;
653         uint128 numberMinted;
654     }
655 
656     uint256 internal currentIndex;
657 
658     // Token name
659     string private _name;
660 
661     // Token symbol
662     string private _symbol;
663 
664     // Mapping from token ID to ownership details
665     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
666     mapping(uint256 => TokenOwnership) internal _ownerships;
667 
668     // Mapping owner address to address data
669     mapping(address => AddressData) private _addressData;
670 
671     // Mapping from token ID to approved address
672     mapping(uint256 => address) private _tokenApprovals;
673 
674     // Mapping from owner to operator approvals
675     mapping(address => mapping(address => bool)) private _operatorApprovals;
676 
677     constructor(string memory name_, string memory symbol_) {
678         _name = name_;
679         _symbol = symbol_;
680     }
681 
682     /**
683      * @dev See {IERC721Enumerable-totalSupply}.
684      */
685     function totalSupply() public view override returns (uint256) {
686         return currentIndex;
687     }
688 
689     /**
690      * @dev See {IERC721Enumerable-tokenByIndex}.
691      */
692     function tokenByIndex(uint256 index) public view override returns (uint256) {
693         require(index < totalSupply(), 'ERC721A: global index out of bounds');
694         return index;
695     }
696 
697     /**
698      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
699      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
700      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
701      */
702     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
703         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
704         uint256 numMintedSoFar = totalSupply();
705         uint256 tokenIdsIdx;
706         address currOwnershipAddr;
707 
708         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
709         unchecked {
710             for (uint256 i; i < numMintedSoFar; i++) {
711                 TokenOwnership memory ownership = _ownerships[i];
712                 if (ownership.addr != address(0)) {
713                     currOwnershipAddr = ownership.addr;
714                 }
715                 if (currOwnershipAddr == owner) {
716                     if (tokenIdsIdx == index) {
717                         return i;
718                     }
719                     tokenIdsIdx++;
720                 }
721             }
722         }
723 
724         revert('ERC721A: unable to get token of owner by index');
725     }
726 
727     /**
728      * @dev See {IERC165-supportsInterface}.
729      */
730     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
731         return
732             interfaceId == type(IERC721).interfaceId ||
733             interfaceId == type(IERC721Metadata).interfaceId ||
734             interfaceId == type(IERC721Enumerable).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner) public view override returns (uint256) {
742         require(owner != address(0), 'ERC721A: balance query for the zero address');
743         return uint256(_addressData[owner].balance);
744     }
745 
746     function _numberMinted(address owner) internal view returns (uint256) {
747         require(owner != address(0), 'ERC721A: number minted query for the zero address');
748         return uint256(_addressData[owner].numberMinted);
749     }
750 
751     /**
752      * Gas spent here starts off proportional to the maximum mint batch size.
753      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
754      */
755     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
756         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
757 
758         unchecked {
759             for (uint256 curr = tokenId; curr >= 0; curr--) {
760                 TokenOwnership memory ownership = _ownerships[curr];
761                 if (ownership.addr != address(0)) {
762                     return ownership;
763                 }
764             }
765         }
766 
767         revert('ERC721A: unable to determine the owner of token');
768     }
769 
770     /**
771      * @dev See {IERC721-ownerOf}.
772      */
773     function ownerOf(uint256 tokenId) public view override returns (address) {
774         return ownershipOf(tokenId).addr;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-name}.
779      */
780     function name() public view virtual override returns (string memory) {
781         return _name;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-symbol}.
786      */
787     function symbol() public view virtual override returns (string memory) {
788         return _symbol;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-tokenURI}.
793      */
794     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
795         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
796 
797         string memory baseURI = _baseURI();
798         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
799     }
800 
801     /**
802      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
803      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
804      * by default, can be overriden in child contracts.
805      */
806     function _baseURI() internal view virtual returns (string memory) {
807         return '';
808     }
809 
810     /**
811      * @dev See {IERC721-approve}.
812      */
813     function approve(address to, uint256 tokenId) public override {
814         address owner = ERC721A.ownerOf(tokenId);
815         require(to != owner, 'ERC721A: approval to current owner');
816 
817         require(
818             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
819             'ERC721A: approve caller is not owner nor approved for all'
820         );
821 
822         _approve(to, tokenId, owner);
823     }
824 
825     /**
826      * @dev See {IERC721-getApproved}.
827      */
828     function getApproved(uint256 tokenId) public view override returns (address) {
829         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
830 
831         return _tokenApprovals[tokenId];
832     }
833 
834     /**
835      * @dev See {IERC721-setApprovalForAll}.
836      */
837     function setApprovalForAll(address operator, bool approved) public override {
838         require(operator != _msgSender(), 'ERC721A: approve to caller');
839 
840         _operatorApprovals[_msgSender()][operator] = approved;
841         emit ApprovalForAll(_msgSender(), operator, approved);
842     }
843 
844     /**
845      * @dev See {IERC721-isApprovedForAll}.
846      */
847     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[owner][operator];
849     }
850 
851     /**
852      * @dev See {IERC721-transferFrom}.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public override {
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public override {
870         safeTransferFrom(from, to, tokenId, '');
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public override {
882         _transfer(from, to, tokenId);
883         require(
884             _checkOnERC721Received(from, to, tokenId, _data),
885             'ERC721A: transfer to non ERC721Receiver implementer'
886         );
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted (`_mint`),
895      */
896     function _exists(uint256 tokenId) internal view returns (bool) {
897         return tokenId < currentIndex;
898     }
899 
900     function _safeMint(address to, uint256 quantity) internal {
901         _safeMint(to, quantity, '');
902     }
903 
904     /**
905      * @dev Safely mints `quantity` tokens and transfers them to `to`.
906      *
907      * Requirements:
908      *
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
910      * - `quantity` must be greater than 0.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeMint(
915         address to,
916         uint256 quantity,
917         bytes memory _data
918     ) internal {
919         _mint(to, quantity, _data, true);
920     }
921 
922     /**
923      * @dev Mints `quantity` tokens and transfers them to `to`.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `quantity` must be greater than 0.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _mint(
933         address to,
934         uint256 quantity,
935         bytes memory _data,
936         bool safe
937     ) internal {
938         uint256 startTokenId = currentIndex;
939         require(to != address(0), 'ERC721A: mint to the zero address');
940         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
941 
942         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
943 
944         // Overflows are incredibly unrealistic.
945         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
946         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
947         unchecked {
948             _addressData[to].balance += uint128(quantity);
949             _addressData[to].numberMinted += uint128(quantity);
950 
951             _ownerships[startTokenId].addr = to;
952             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
953 
954             uint256 updatedIndex = startTokenId;
955 
956             for (uint256 i; i < quantity; i++) {
957                 emit Transfer(address(0), to, updatedIndex);
958                 if (safe) {
959                     require(
960                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
961                         'ERC721A: transfer to non ERC721Receiver implementer'
962                     );
963                 }
964 
965                 updatedIndex++;
966             }
967 
968             currentIndex = updatedIndex;
969         }
970 
971         _afterTokenTransfers(address(0), to, startTokenId, quantity);
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must be owned by `from`.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _transfer(
985         address from,
986         address to,
987         uint256 tokenId
988     ) private {
989         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
990 
991         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
992             getApproved(tokenId) == _msgSender() ||
993             isApprovedForAll(prevOwnership.addr, _msgSender()));
994 
995         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
996 
997         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
998         require(to != address(0), 'ERC721A: transfer to the zero address');
999 
1000         _beforeTokenTransfers(from, to, tokenId, 1);
1001 
1002         // Clear approvals from the previous owner
1003         _approve(address(0), tokenId, prevOwnership.addr);
1004 
1005         // Underflow of the sender's balance is impossible because we check for
1006         // ownership above and the recipient's balance can't realistically overflow.
1007         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1008         unchecked {
1009             _addressData[from].balance -= 1;
1010             _addressData[to].balance += 1;
1011 
1012             _ownerships[tokenId].addr = to;
1013             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1014 
1015             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1016             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1017             uint256 nextTokenId = tokenId + 1;
1018             if (_ownerships[nextTokenId].addr == address(0)) {
1019                 if (_exists(nextTokenId)) {
1020                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1021                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1022                 }
1023             }
1024         }
1025 
1026         emit Transfer(from, to, tokenId);
1027         _afterTokenTransfers(from, to, tokenId, 1);
1028     }
1029 
1030     /**
1031      * @dev Approve `to` to operate on `tokenId`
1032      *
1033      * Emits a {Approval} event.
1034      */
1035     function _approve(
1036         address to,
1037         uint256 tokenId,
1038         address owner
1039     ) private {
1040         _tokenApprovals[tokenId] = to;
1041         emit Approval(owner, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1046      * The call is not executed if the target address is not a contract.
1047      *
1048      * @param from address representing the previous owner of the given token ID
1049      * @param to target address that will receive the tokens
1050      * @param tokenId uint256 ID of the token to be transferred
1051      * @param _data bytes optional data to send along with the call
1052      * @return bool whether the call correctly returned the expected magic value
1053      */
1054     function _checkOnERC721Received(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) private returns (bool) {
1060         if (to.isContract()) {
1061             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1062                 return retval == IERC721Receiver(to).onERC721Received.selector;
1063             } catch (bytes memory reason) {
1064                 if (reason.length == 0) {
1065                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1066                 } else {
1067                     assembly {
1068                         revert(add(32, reason), mload(reason))
1069                     }
1070                 }
1071             }
1072         } else {
1073             return true;
1074         }
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1079      *
1080      * startTokenId - the first token id to be transferred
1081      * quantity - the amount to be transferred
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      */
1089     function _beforeTokenTransfers(
1090         address from,
1091         address to,
1092         uint256 startTokenId,
1093         uint256 quantity
1094     ) internal virtual {}
1095 
1096     /**
1097      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1098      * minting.
1099      *
1100      * startTokenId - the first token id to be transferred
1101      * quantity - the amount to be transferred
1102      *
1103      * Calling conditions:
1104      *
1105      * - when `from` and `to` are both non-zero.
1106      * - `from` and `to` are never both zero.
1107      */
1108     function _afterTokenTransfers(
1109         address from,
1110         address to,
1111         uint256 startTokenId,
1112         uint256 quantity
1113     ) internal virtual {}
1114 }
1115 // File: MutantAIYachtClub.sol
1116 
1117 
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 /**
1122  * @dev Contract module which allows children to implement an emergency stop
1123  * mechanism that can be triggered by an authorized account.
1124  *
1125  * This module is used through inheritance. It will make available the
1126  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1127  * the functions of your contract. Note that they will not be pausable by
1128  * simply including this module, only once the modifiers are put in place.
1129  */
1130 abstract contract Pausable is Context {
1131     /**
1132      * @dev Emitted when the pause is triggered by `account`.
1133      */
1134     event Paused(address account);
1135 
1136     /**
1137      * @dev Emitted when the pause is lifted by `account`.
1138      */
1139     event Unpaused(address account);
1140 
1141     bool private _paused;
1142 
1143     /**
1144      * @dev Initializes the contract in unpaused state.
1145      */
1146     constructor() {
1147         _paused = false;
1148     }
1149 
1150     /**
1151      * @dev Returns true if the contract is paused, and false otherwise.
1152      */
1153     function paused() public view virtual returns (bool) {
1154         return _paused;
1155     }
1156 
1157     /**
1158      * @dev Modifier to make a function callable only when the contract is not paused.
1159      *
1160      * Requirements:
1161      *
1162      * - The contract must not be paused.
1163      */
1164     modifier whenNotPaused() {
1165         require(!paused(), "Pausable: paused");
1166         _;
1167     }
1168 
1169     /**
1170      * @dev Modifier to make a function callable only when the contract is paused.
1171      *
1172      * Requirements:
1173      *
1174      * - The contract must be paused.
1175      */
1176     modifier whenPaused() {
1177         require(paused(), "Pausable: not paused");
1178         _;
1179     }
1180 
1181     /**
1182      * @dev Triggers stopped state.
1183      *
1184      * Requirements:
1185      *
1186      * - The contract must not be paused.
1187      */
1188     function _pause() internal virtual whenNotPaused {
1189         _paused = true;
1190         emit Paused(_msgSender());
1191     }
1192 
1193     /**
1194      * @dev Returns to normal state.
1195      *
1196      * Requirements:
1197      *
1198      * - The contract must be paused.
1199      */
1200     function _unpause() internal virtual whenPaused {
1201         _paused = false;
1202         emit Unpaused(_msgSender());
1203     }
1204 }
1205 
1206 // Ownable.sol
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev Contract module which provides a basic access control mechanism, where
1212  * there is an account (an owner) that can be granted exclusive access to
1213  * specific functions.
1214  *
1215  * By default, the owner account will be the one that deploys the contract. This
1216  * can later be changed with {transferOwnership}.
1217  *
1218  * This module is used through inheritance. It will make available the modifier
1219  * `onlyOwner`, which can be applied to your functions to restrict their use to
1220  * the owner.
1221  */
1222 abstract contract Ownable is Context {
1223     address private _owner;
1224 
1225     event OwnershipTransferred(
1226         address indexed previousOwner,
1227         address indexed newOwner
1228     );
1229 
1230     /**
1231      * @dev Initializes the contract setting the deployer as the initial owner.
1232      */
1233     constructor() {
1234         _setOwner(_msgSender());
1235     }
1236 
1237     /**
1238      * @dev Returns the address of the current owner.
1239      */
1240     function owner() public view virtual returns (address) {
1241         return _owner;
1242     }
1243 
1244     /**
1245      * @dev Throws if called by any account other than the owner.
1246      */
1247     modifier onlyOwner() {
1248         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1249         _;
1250     }
1251 
1252     /**
1253      * @dev Leaves the contract without owner. It will not be possible to call
1254      * `onlyOwner` functions anymore. Can only be called by the current owner.
1255      *
1256      * NOTE: Renouncing ownership will leave the contract without an owner,
1257      * thereby removing any functionality that is only available to the owner.
1258      */
1259     function renounceOwnership() public virtual onlyOwner {
1260         _setOwner(address(0));
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Can only be called by the current owner.
1266      */
1267     function transferOwnership(address newOwner) public virtual onlyOwner {
1268         require(
1269             newOwner != address(0),
1270             "Ownable: new owner is the zero address"
1271         );
1272         _setOwner(newOwner);
1273     }
1274 
1275     function _setOwner(address newOwner) private {
1276         address oldOwner = _owner;
1277         _owner = newOwner;
1278         emit OwnershipTransferred(oldOwner, newOwner);
1279     }
1280 }
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 /**
1285  * @dev Contract module that helps prevent reentrant calls to a function.
1286  *
1287  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1288  * available, which can be applied to functions to make sure there are no nested
1289  * (reentrant) calls to them.
1290  *
1291  * Note that because there is a single `nonReentrant` guard, functions marked as
1292  * `nonReentrant` may not call one another. This can be worked around by making
1293  * those functions `private`, and then adding `external` `nonReentrant` entry
1294  * points to them.
1295  *
1296  * TIP: If you would like to learn more about reentrancy and alternative ways
1297  * to protect against it, check out our blog post
1298  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1299  */
1300 abstract contract ReentrancyGuard {
1301     // Booleans are more expensive than uint256 or any type that takes up a full
1302     // word because each write operation emits an extra SLOAD to first read the
1303     // slot's contents, replace the bits taken up by the boolean, and then write
1304     // back. This is the compiler's defense against contract upgrades and
1305     // pointer aliasing, and it cannot be disabled.
1306 
1307     // The values being non-zero value makes deployment a bit more expensive,
1308     // but in exchange the refund on every call to nonReentrant will be lower in
1309     // amount. Since refunds are capped to a percentage of the total
1310     // transaction's gas, it is best to keep them low in cases like this one, to
1311     // increase the likelihood of the full refund coming into effect.
1312     uint256 private constant _NOT_ENTERED = 1;
1313     uint256 private constant _ENTERED = 2;
1314 
1315     uint256 private _status;
1316 
1317     constructor() {
1318         _status = _NOT_ENTERED;
1319     }
1320 
1321     /**
1322      * @dev Prevents a contract from calling itself, directly or indirectly.
1323      * Calling a `nonReentrant` function from another `nonReentrant`
1324      * function is not supported. It is possible to prevent this from happening
1325      * by making the `nonReentrant` function external, and make it call a
1326      * `private` function that does the actual work.
1327      */
1328     modifier nonReentrant() {
1329         // On the first call to nonReentrant, _notEntered will be true
1330         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1331 
1332         // Any calls to nonReentrant after this point will fail
1333         _status = _ENTERED;
1334 
1335         _;
1336 
1337         // By storing the original value once again, a refund is triggered (see
1338         // https://eips.ethereum.org/EIPS/eip-2200)
1339         _status = _NOT_ENTERED;
1340     }
1341 }
1342 
1343 //newerc.sol
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 contract TheSaudisWifesNFT is ERC721A, Ownable, Pausable, ReentrancyGuard {
1348     using Strings for uint256;
1349     string public baseURI;
1350     uint256 public cost = 0.002 ether;
1351     uint256 public maxSupply = 5555;
1352     uint256 public maxFree = 1111;
1353     uint256 public maxperAddressFreeLimit = 2;
1354     uint256 public maxperAddressPublicMint = 5;
1355 
1356     mapping(address => uint256) public addressFreeMintedBalance;
1357 
1358     constructor() ERC721A("TheSaudisWifes", "TheSaudisWifesNFT") {
1359         setBaseURI("ipfs://QmWac9YwKPvhVfJmA3pyb5YBQqdbTwwUwvRqNJY4f5bUvd/");
1360 
1361     }
1362 
1363     function _baseURI() internal view virtual override returns (string memory) {
1364         return baseURI;
1365     }
1366 
1367     function MintFree(uint256 _mintAmount) public payable nonReentrant{
1368 		uint256 s = totalSupply();
1369         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1370         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "max NFT per address exceeded");
1371 		require(_mintAmount > 0, "Cant mint 0" );
1372 		require(s + _mintAmount <= maxFree, "Cant go over supply" );
1373 		for (uint256 i = 0; i < _mintAmount; ++i) {
1374             addressFreeMintedBalance[msg.sender]++;
1375 
1376 		}
1377         _safeMint(msg.sender, _mintAmount);
1378 		delete s;
1379         delete addressFreeMintedCount;
1380 	}
1381 
1382 
1383     function mint(uint256 _mintAmount) public payable nonReentrant {
1384         uint256 s = totalSupply();
1385         require(_mintAmount > 0, "Cant mint 0");
1386         require(_mintAmount <= maxperAddressPublicMint, "Cant mint more then maxmint" );
1387         require(s + _mintAmount <= maxSupply, "Cant go over supply");
1388         require(msg.value >= cost * _mintAmount);
1389         _safeMint(msg.sender, _mintAmount);
1390         delete s;
1391     }
1392 
1393     function gift(uint256[] calldata quantity, address[] calldata recipient)
1394         external
1395         onlyOwner
1396     {
1397         require(
1398             quantity.length == recipient.length,
1399             "Provide quantities and recipients"
1400         );
1401         uint256 totalQuantity = 0;
1402         uint256 s = totalSupply();
1403         for (uint256 i = 0; i < quantity.length; ++i) {
1404             totalQuantity += quantity[i];
1405         }
1406         require(s + totalQuantity <= maxSupply, "Too many");
1407         delete totalQuantity;
1408         for (uint256 i = 0; i < recipient.length; ++i) {
1409             _safeMint(recipient[i], quantity[i]);
1410         }
1411         delete s;
1412     }
1413 
1414     function tokenURI(uint256 tokenId)
1415         public
1416         view
1417         virtual
1418         override
1419         returns (string memory)
1420     {
1421         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1422         string memory currentBaseURI = _baseURI();
1423         return
1424             bytes(currentBaseURI).length > 0
1425                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1426                 : "";
1427     }
1428 
1429 
1430 
1431     function setCost(uint256 _newCost) public onlyOwner {
1432         cost = _newCost;
1433     }
1434 
1435     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1436         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1437         maxSupply = _newMaxSupply;
1438     }
1439      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1440                maxFree = _newMaxFreeSupply;
1441     }
1442 
1443     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1444         baseURI = _newBaseURI;
1445     }
1446 
1447     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1448         maxperAddressPublicMint = _amount;
1449     }
1450 
1451     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1452         maxperAddressFreeLimit = _amount;
1453     }
1454     function withdraw() public payable onlyOwner {
1455         (bool success, ) = payable(msg.sender).call{
1456             value: address(this).balance
1457         }("");
1458         require(success);
1459     }
1460 
1461     function withdrawAny(uint256 _amount) public payable onlyOwner {
1462         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1463         require(success);
1464     }
1465 }