1 // SPDX-License-Identifier: SimPL-2.0
2 /**
3  *Submitted for verification at Etherscan.io on 2022-06-01
4 */
5 
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/Address.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
107 
108 pragma solidity ^0.8.1;
109 
110 /**
111  * @dev Collection of functions related to the address type
112  */
113 library Address {
114     /**
115      * @dev Returns true if `account` is a contract.
116      *
117      * [IMPORTANT]
118      * ====
119      * It is unsafe to assume that an address for which this function returns
120      * false is an externally-owned account (EOA) and not a contract.
121      *
122      * Among others, `isContract` will return false for the following
123      * types of addresses:
124      *
125      *  - an externally-owned account
126      *  - a contract in construction
127      *  - an address where a contract will be created
128      *  - an address where a contract lived, but was destroyed
129      * ====
130      *
131      * [IMPORTANT]
132      * ====
133      * You shouldn't rely on `isContract` to protect against flash loan attacks!
134      *
135      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
136      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
137      * constructor.
138      * ====
139      */
140     function isContract(address account) internal view returns (bool) {
141         // This method relies on extcodesize/address.code.length, which returns 0
142         // for contracts in construction, since the code is only stored at the end
143         // of the constructor execution.
144 
145         return account.code.length > 0;
146     }
147 
148     /**
149      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
150      * `recipient`, forwarding all available gas and reverting on errors.
151      *
152      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
153      * of certain opcodes, possibly making contracts go over the 2300 gas limit
154      * imposed by `transfer`, making them unable to receive funds via
155      * `transfer`. {sendValue} removes this limitation.
156      *
157      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
158      *
159      * IMPORTANT: because control is transferred to `recipient`, care must be
160      * taken to not create reentrancy vulnerabilities. Consider using
161      * {ReentrancyGuard} or the
162      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
163      */
164     function sendValue(address payable recipient, uint256 amount) internal {
165         require(address(this).balance >= amount, "Address: insufficient balance");
166 
167         (bool success, ) = recipient.call{value: amount}("");
168         require(success, "Address: unable to send value, recipient may have reverted");
169     }
170 
171     /**
172      * @dev Performs a Solidity function call using a low level `call`. A
173      * plain `call` is an unsafe replacement for a function call: use this
174      * function instead.
175      *
176      * If `target` reverts with a revert reason, it is bubbled up by this
177      * function (like regular Solidity function calls).
178      *
179      * Returns the raw returned data. To convert to the expected return value,
180      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
181      *
182      * Requirements:
183      *
184      * - `target` must be a contract.
185      * - calling `target` with `data` must not revert.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
195      * `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but also transferring `value` wei to `target`.
210      *
211      * Requirements:
212      *
213      * - the calling contract must have an ETH balance of at least `value`.
214      * - the called Solidity function must be `payable`.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value
222     ) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
228      * with `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(address(this).balance >= value, "Address: insufficient balance for call");
239         require(isContract(target), "Address: call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.call{value: value}(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
252         return functionStaticCall(target, data, "Address: low-level static call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal view returns (bytes memory) {
266         require(isContract(target), "Address: static call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.staticcall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(isContract(target), "Address: delegate call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
301      * revert reason using the provided one.
302      *
303      * _Available since v4.3._
304      */
305     function verifyCallResult(
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) internal pure returns (bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @title ERC721 token receiver interface
337  * @dev Interface for any contract that wants to support safeTransfers
338  * from ERC721 asset contracts.
339  */
340 interface IERC721Receiver {
341     /**
342      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
343      * by `operator` from `from`, this function is called.
344      *
345      * It must return its Solidity selector to confirm the token transfer.
346      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
347      *
348      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
349      */
350     function onERC721Received(
351         address operator,
352         address from,
353         uint256 tokenId,
354         bytes calldata data
355     ) external returns (bytes4);
356 }
357 
358 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Interface of the ERC165 standard, as defined in the
367  * https://eips.ethereum.org/EIPS/eip-165[EIP].
368  *
369  * Implementers can declare support of contract interfaces, which can then be
370  * queried by others ({ERC165Checker}).
371  *
372  * For an implementation, see {ERC165}.
373  */
374 interface IERC165 {
375     /**
376      * @dev Returns true if this contract implements the interface defined by
377      * `interfaceId`. See the corresponding
378      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
379      * to learn more about how these ids are created.
380      *
381      * This function call must use less than 30 000 gas.
382      */
383     function supportsInterface(bytes4 interfaceId) external view returns (bool);
384 }
385 
386 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Implementation of the {IERC165} interface.
396  *
397  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
398  * for the additional interface id that will be supported. For example:
399  *
400  * ```solidity
401  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
402  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
403  * }
404  * ```
405  *
406  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
407  */
408 abstract contract ERC165 is IERC165 {
409     /**
410      * @dev See {IERC165-supportsInterface}.
411      */
412     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
413         return interfaceId == type(IERC165).interfaceId;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Required interface of an ERC721 compliant contract.
427  */
428 interface IERC721 is IERC165 {
429     /**
430      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
431      */
432     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
436      */
437     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
438 
439     /**
440      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
441      */
442     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
443 
444     /**
445      * @dev Returns the number of tokens in ``owner``'s account.
446      */
447     function balanceOf(address owner) external view returns (uint256 balance);
448 
449     /**
450      * @dev Returns the owner of the `tokenId` token.
451      *
452      * Requirements:
453      *
454      * - `tokenId` must exist.
455      */
456     function ownerOf(uint256 tokenId) external view returns (address owner);
457 
458     /**
459      * @dev Safely transfers `tokenId` token from `from` to `to`.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external;
477 
478     /**
479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Transfers `tokenId` token from `from` to `to`.
500      *
501      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(
513         address from,
514         address to,
515         uint256 tokenId
516     ) external;
517 
518     /**
519      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
520      * The approval is cleared when the token is transferred.
521      *
522      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
523      *
524      * Requirements:
525      *
526      * - The caller must own the token or be an approved operator.
527      * - `tokenId` must exist.
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address to, uint256 tokenId) external;
532 
533     /**
534      * @dev Approve or remove `operator` as an operator for the caller.
535      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
536      *
537      * Requirements:
538      *
539      * - The `operator` cannot be the caller.
540      *
541      * Emits an {ApprovalForAll} event.
542      */
543     function setApprovalForAll(address operator, bool _approved) external;
544 
545     /**
546      * @dev Returns the account approved for `tokenId` token.
547      *
548      * Requirements:
549      *
550      * - `tokenId` must exist.
551      */
552     function getApproved(uint256 tokenId) external view returns (address operator);
553 
554     /**
555      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
556      *
557      * See {setApprovalForAll}
558      */
559     function isApprovedForAll(address owner, address operator) external view returns (bool);
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Enumerable is IERC721 {
575     /**
576      * @dev Returns the total amount of tokens stored by the contract.
577      */
578     function totalSupply() external view returns (uint256);
579 
580     /**
581      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
582      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
583      */
584     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
585 
586     /**
587      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
588      * Use along with {totalSupply} to enumerate all tokens.
589      */
590     function tokenByIndex(uint256 index) external view returns (uint256);
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 
622 // File: ERC721A.sol
623 
624 
625 // Creator: Chiru Labs
626 
627 pragma solidity ^0.8.0;
628 
629 
630 
631 
632 
633 
634 
635 
636 
637 /**
638  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
639  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
640  *
641  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
642  *
643  * Does not support burning tokens to address(0).
644  *
645  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
646  */
647 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
648     using Address for address;
649     using Strings for uint256;
650 
651     struct TokenOwnership {
652         address addr;
653         uint64 startTimestamp;
654     }
655 
656     struct AddressData {
657         uint128 balance;
658         uint128 numberMinted;
659     }
660 
661     uint256 internal currentIndex;
662 
663     // Token name
664     string private _name;
665 
666     // Token symbol
667     string private _symbol;
668 
669     // Mapping from token ID to ownership details
670     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
671     mapping(uint256 => TokenOwnership) internal _ownerships;
672 
673     // Mapping owner address to address data
674     mapping(address => AddressData) private _addressData;
675 
676     // Mapping from token ID to approved address
677     mapping(uint256 => address) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685     }
686 
687     /**
688      * @dev See {IERC721Enumerable-totalSupply}.
689      */
690     function totalSupply() public view override returns (uint256) {
691         return currentIndex;
692     }
693 
694     /**
695      * @dev See {IERC721Enumerable-tokenByIndex}.
696      */
697     function tokenByIndex(uint256 index) public view override returns (uint256) {
698         require(index < totalSupply(), 'ERC721A: global index out of bounds');
699         return index;
700     }
701 
702     /**
703      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
704      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
705      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
706      */
707     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
708         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
709         uint256 numMintedSoFar = totalSupply();
710         uint256 tokenIdsIdx;
711         address currOwnershipAddr;
712 
713         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
714         unchecked {
715             for (uint256 i; i < numMintedSoFar; i++) {
716                 TokenOwnership memory ownership = _ownerships[i];
717                 if (ownership.addr != address(0)) {
718                     currOwnershipAddr = ownership.addr;
719                 }
720                 if (currOwnershipAddr == owner) {
721                     if (tokenIdsIdx == index) {
722                         return i;
723                     }
724                     tokenIdsIdx++;
725                 }
726             }
727         }
728 
729         revert('ERC721A: unable to get token of owner by index');
730     }
731 
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
736         return
737             interfaceId == type(IERC721).interfaceId ||
738             interfaceId == type(IERC721Metadata).interfaceId ||
739             interfaceId == type(IERC721Enumerable).interfaceId ||
740             super.supportsInterface(interfaceId);
741     }
742 
743     /**
744      * @dev See {IERC721-balanceOf}.
745      */
746     function balanceOf(address owner) public view override returns (uint256) {
747         require(owner != address(0), 'ERC721A: balance query for the zero address');
748         return uint256(_addressData[owner].balance);
749     }
750 
751     function _numberMinted(address owner) internal view returns (uint256) {
752         require(owner != address(0), 'ERC721A: number minted query for the zero address');
753         return uint256(_addressData[owner].numberMinted);
754     }
755 
756     /**
757      * Gas spent here starts off proportional to the maximum mint batch size.
758      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
759      */
760     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
761         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
762 
763         unchecked {
764             for (uint256 curr = tokenId; curr >= 0; curr--) {
765                 TokenOwnership memory ownership = _ownerships[curr];
766                 if (ownership.addr != address(0)) {
767                     return ownership;
768                 }
769             }
770         }
771 
772         revert('ERC721A: unable to determine the owner of token');
773     }
774 
775     /**
776      * @dev See {IERC721-ownerOf}.
777      */
778     function ownerOf(uint256 tokenId) public view override returns (address) {
779         return ownershipOf(tokenId).addr;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overriden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return '';
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public override {
819         address owner = ERC721A.ownerOf(tokenId);
820         require(to != owner, 'ERC721A: approval to current owner');
821 
822         require(
823             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             'ERC721A: approve caller is not owner nor approved for all'
825         );
826 
827         _approve(to, tokenId, owner);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view override returns (address) {
834         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public override {
843         require(operator != _msgSender(), 'ERC721A: approve to caller');
844 
845         _operatorApprovals[_msgSender()][operator] = approved;
846         emit ApprovalForAll(_msgSender(), operator, approved);
847     }
848 
849     /**
850      * @dev See {IERC721-isApprovedForAll}.
851      */
852     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
853         return _operatorApprovals[owner][operator];
854     }
855 
856     /**
857      * @dev See {IERC721-transferFrom}.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public override {
864         _transfer(from, to, tokenId);
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public override {
875         safeTransferFrom(from, to, tokenId, '');
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) public override {
887         _transfer(from, to, tokenId);
888         require(
889             _checkOnERC721Received(from, to, tokenId, _data),
890             'ERC721A: transfer to non ERC721Receiver implementer'
891         );
892     }
893 
894     /**
895      * @dev Returns whether `tokenId` exists.
896      *
897      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
898      *
899      * Tokens start existing when they are minted (`_mint`),
900      */
901     function _exists(uint256 tokenId) internal view returns (bool) {
902         return tokenId < currentIndex;
903     }
904 
905     function _safeMint(address to, uint256 quantity) internal {
906         _safeMint(to, quantity, '');
907     }
908 
909     /**
910      * @dev Safely mints `quantity` tokens and transfers them to `to`.
911      *
912      * Requirements:
913      *
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
915      * - `quantity` must be greater than 0.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeMint(
920         address to,
921         uint256 quantity,
922         bytes memory _data
923     ) internal {
924         _mint(to, quantity, _data, true);
925     }
926 
927     /**
928      * @dev Mints `quantity` tokens and transfers them to `to`.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `quantity` must be greater than 0.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _mint(
938         address to,
939         uint256 quantity,
940         bytes memory _data,
941         bool safe
942     ) internal {
943         uint256 startTokenId = currentIndex;
944         require(to != address(0), 'ERC721A: mint to the zero address');
945         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         // Overflows are incredibly unrealistic.
950         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
951         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
952         unchecked {
953             _addressData[to].balance += uint128(quantity);
954             _addressData[to].numberMinted += uint128(quantity);
955 
956             _ownerships[startTokenId].addr = to;
957             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
958 
959             uint256 updatedIndex = startTokenId;
960 
961             for (uint256 i; i < quantity; i++) {
962                 emit Transfer(address(0), to, updatedIndex);
963                 if (safe) {
964                     require(
965                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
966                         'ERC721A: transfer to non ERC721Receiver implementer'
967                     );
968                 }
969 
970                 updatedIndex++;
971             }
972 
973             currentIndex = updatedIndex;
974         }
975 
976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must be owned by `from`.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _transfer(
990         address from,
991         address to,
992         uint256 tokenId
993     ) private {
994         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
995 
996         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
997             getApproved(tokenId) == _msgSender() ||
998             isApprovedForAll(prevOwnership.addr, _msgSender()));
999 
1000         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1001 
1002         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1003         require(to != address(0), 'ERC721A: transfer to the zero address');
1004 
1005         _beforeTokenTransfers(from, to, tokenId, 1);
1006 
1007         // Clear approvals from the previous owner
1008         _approve(address(0), tokenId, prevOwnership.addr);
1009 
1010         // Underflow of the sender's balance is impossible because we check for
1011         // ownership above and the recipient's balance can't realistically overflow.
1012         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1013         unchecked {
1014             _addressData[from].balance -= 1;
1015             _addressData[to].balance += 1;
1016 
1017             _ownerships[tokenId].addr = to;
1018             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1019 
1020             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1021             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1022             uint256 nextTokenId = tokenId + 1;
1023             if (_ownerships[nextTokenId].addr == address(0)) {
1024                 if (_exists(nextTokenId)) {
1025                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1026                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1027                 }
1028             }
1029         }
1030 
1031         emit Transfer(from, to, tokenId);
1032         _afterTokenTransfers(from, to, tokenId, 1);
1033     }
1034 
1035     /**
1036      * @dev Approve `to` to operate on `tokenId`
1037      *
1038      * Emits a {Approval} event.
1039      */
1040     function _approve(
1041         address to,
1042         uint256 tokenId,
1043         address owner
1044     ) private {
1045         _tokenApprovals[tokenId] = to;
1046         emit Approval(owner, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1051      * The call is not executed if the target address is not a contract.
1052      *
1053      * @param from address representing the previous owner of the given token ID
1054      * @param to target address that will receive the tokens
1055      * @param tokenId uint256 ID of the token to be transferred
1056      * @param _data bytes optional data to send along with the call
1057      * @return bool whether the call correctly returned the expected magic value
1058      */
1059     function _checkOnERC721Received(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) private returns (bool) {
1065         if (to.isContract()) {
1066             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1067                 return retval == IERC721Receiver(to).onERC721Received.selector;
1068             } catch (bytes memory reason) {
1069                 if (reason.length == 0) {
1070                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1071                 } else {
1072                     assembly {
1073                         revert(add(32, reason), mload(reason))
1074                     }
1075                 }
1076             }
1077         } else {
1078             return true;
1079         }
1080     }
1081 
1082     /**
1083      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1084      *
1085      * startTokenId - the first token id to be transferred
1086      * quantity - the amount to be transferred
1087      *
1088      * Calling conditions:
1089      *
1090      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1091      * transferred to `to`.
1092      * - When `from` is zero, `tokenId` will be minted for `to`.
1093      */
1094     function _beforeTokenTransfers(
1095         address from,
1096         address to,
1097         uint256 startTokenId,
1098         uint256 quantity
1099     ) internal virtual {}
1100 
1101     /**
1102      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1103      * minting.
1104      *
1105      * startTokenId - the first token id to be transferred
1106      * quantity - the amount to be transferred
1107      *
1108      * Calling conditions:
1109      *
1110      * - when `from` and `to` are both non-zero.
1111      * - `from` and `to` are never both zero.
1112      */
1113     function _afterTokenTransfers(
1114         address from,
1115         address to,
1116         uint256 startTokenId,
1117         uint256 quantity
1118     ) internal virtual {}
1119 }
1120 // File: goblintownai-contract.sol
1121 
1122 
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 /**
1127  * @dev Contract module which allows children to implement an emergency stop
1128  * mechanism that can be triggered by an authorized account.
1129  *
1130  * This module is used through inheritance. It will make available the
1131  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1132  * the functions of your contract. Note that they will not be pausable by
1133  * simply including this module, only once the modifiers are put in place.
1134  */
1135 abstract contract Pausable is Context {
1136     /**
1137      * @dev Emitted when the pause is triggered by `account`.
1138      */
1139     event Paused(address account);
1140 
1141     /**
1142      * @dev Emitted when the pause is lifted by `account`.
1143      */
1144     event Unpaused(address account);
1145 
1146     bool private _paused;
1147 
1148     /**
1149      * @dev Initializes the contract in unpaused state.
1150      */
1151     constructor() {
1152         _paused = false;
1153     }
1154 
1155     /**
1156      * @dev Returns true if the contract is paused, and false otherwise.
1157      */
1158     function paused() public view virtual returns (bool) {
1159         return _paused;
1160     }
1161 
1162     /**
1163      * @dev Modifier to make a function callable only when the contract is not paused.
1164      *
1165      * Requirements:
1166      *
1167      * - The contract must not be paused.
1168      */
1169     modifier whenNotPaused() {
1170         require(!paused(), "Pausable: paused");
1171         _;
1172     }
1173 
1174     /**
1175      * @dev Modifier to make a function callable only when the contract is paused.
1176      *
1177      * Requirements:
1178      *
1179      * - The contract must be paused.
1180      */
1181     modifier whenPaused() {
1182         require(paused(), "Pausable: not paused");
1183         _;
1184     }
1185 
1186     /**
1187      * @dev Triggers stopped state.
1188      *
1189      * Requirements:
1190      *
1191      * - The contract must not be paused.
1192      */
1193     function _pause() internal virtual whenNotPaused {
1194         _paused = true;
1195         emit Paused(_msgSender());
1196     }
1197 
1198     /**
1199      * @dev Returns to normal state.
1200      *
1201      * Requirements:
1202      *
1203      * - The contract must be paused.
1204      */
1205     function _unpause() internal virtual whenPaused {
1206         _paused = false;
1207         emit Unpaused(_msgSender());
1208     }
1209 }
1210 
1211 // Ownable.sol
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 /**
1216  * @dev Contract module which provides a basic access control mechanism, where
1217  * there is an account (an owner) that can be granted exclusive access to
1218  * specific functions.
1219  *
1220  * By default, the owner account will be the one that deploys the contract. This
1221  * can later be changed with {transferOwnership}.
1222  *
1223  * This module is used through inheritance. It will make available the modifier
1224  * `onlyOwner`, which can be applied to your functions to restrict their use to
1225  * the owner.
1226  */
1227 abstract contract Ownable is Context {
1228     address private _owner;
1229 
1230     event OwnershipTransferred(
1231         address indexed previousOwner,
1232         address indexed newOwner
1233     );
1234 
1235     /**
1236      * @dev Initializes the contract setting the deployer as the initial owner.
1237      */
1238     constructor() {
1239         _setOwner(_msgSender());
1240     }
1241 
1242     /**
1243      * @dev Returns the address of the current owner.
1244      */
1245     function owner() public view virtual returns (address) {
1246         return _owner;
1247     }
1248 
1249     /**
1250      * @dev Throws if called by any account other than the owner.
1251      */
1252     modifier onlyOwner() {
1253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1254         _;
1255     }
1256 
1257     /**
1258      * @dev Leaves the contract without owner. It will not be possible to call
1259      * `onlyOwner` functions anymore. Can only be called by the current owner.
1260      *
1261      * NOTE: Renouncing ownership will leave the contract without an owner,
1262      * thereby removing any functionality that is only available to the owner.
1263      */
1264     function renounceOwnership() public virtual onlyOwner {
1265         _setOwner(address(0));
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Can only be called by the current owner.
1271      */
1272     function transferOwnership(address newOwner) public virtual onlyOwner {
1273         require(
1274             newOwner != address(0),
1275             "Ownable: new owner is the zero address"
1276         );
1277         _setOwner(newOwner);
1278     }
1279 
1280     function _setOwner(address newOwner) private {
1281         address oldOwner = _owner;
1282         _owner = newOwner;
1283         emit OwnershipTransferred(oldOwner, newOwner);
1284     }
1285 }
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 /**
1290  * @dev Contract module that helps prevent reentrant calls to a function.
1291  *
1292  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1293  * available, which can be applied to functions to make sure there are no nested
1294  * (reentrant) calls to them.
1295  *
1296  * Note that because there is a single `nonReentrant` guard, functions marked as
1297  * `nonReentrant` may not call one another. This can be worked around by making
1298  * those functions `private`, and then adding `external` `nonReentrant` entry
1299  * points to them.
1300  *
1301  * TIP: If you would like to learn more about reentrancy and alternative ways
1302  * to protect against it, check out our blog post
1303  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1304  */
1305 abstract contract ReentrancyGuard {
1306     // Booleans are more expensive than uint256 or any type that takes up a full
1307     // word because each write operation emits an extra SLOAD to first read the
1308     // slot's contents, replace the bits taken up by the boolean, and then write
1309     // back. This is the compiler's defense against contract upgrades and
1310     // pointer aliasing, and it cannot be disabled.
1311 
1312     // The values being non-zero value makes deployment a bit more expensive,
1313     // but in exchange the refund on every call to nonReentrant will be lower in
1314     // amount. Since refunds are capped to a percentage of the total
1315     // transaction's gas, it is best to keep them low in cases like this one, to
1316     // increase the likelihood of the full refund coming into effect.
1317     uint256 private constant _NOT_ENTERED = 1;
1318     uint256 private constant _ENTERED = 2;
1319 
1320     uint256 private _status;
1321 
1322     constructor() {
1323         _status = _NOT_ENTERED;
1324     }
1325 
1326     /**
1327      * @dev Prevents a contract from calling itself, directly or indirectly.
1328      * Calling a `nonReentrant` function from another `nonReentrant`
1329      * function is not supported. It is possible to prevent this from happening
1330      * by making the `nonReentrant` function external, and make it call a
1331      * `private` function that does the actual work.
1332      */
1333     modifier nonReentrant() {
1334         // On the first call to nonReentrant, _notEntered will be true
1335         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1336 
1337         // Any calls to nonReentrant after this point will fail
1338         _status = _ENTERED;
1339 
1340         _;
1341 
1342         // By storing the original value once again, a refund is triggered (see
1343         // https://eips.ethereum.org/EIPS/eip-2200)
1344         _status = _NOT_ENTERED;
1345     }
1346 }
1347 
1348 //newerc.sol
1349 pragma solidity ^0.8.0;
1350 
1351 
1352 contract BokiGirls is ERC721A, Ownable, Pausable, ReentrancyGuard {
1353     using Strings for uint256;
1354     string public baseURI;
1355     uint256 public cost = 0.003 ether;
1356     uint256 public maxSupply = 5000;
1357     uint256 public maxFree = 5000;
1358     uint256 public maxperAddressFreeLimit = 1;
1359     uint256 public maxperAddressPublicMint = 10;
1360 
1361     mapping(address => uint256) public addressFreeMintedBalance;
1362 
1363     constructor() ERC721A("BokiGirls", "BokiGirls") {
1364         setBaseURI("");
1365 
1366     }
1367 
1368     function _baseURI() internal view virtual override returns (string memory) {
1369         return baseURI;
1370     }
1371 
1372     function mintFree(uint256 _mintAmount) public payable nonReentrant{
1373 		uint256 s = totalSupply();
1374         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1375         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "Max BokiGirls per address exceeded");
1376 		require(_mintAmount > 0, "Cant mint 0 BokiGirls" );
1377 		require(s + _mintAmount <= maxFree, "Cant exceed BokiGirls supply" );
1378 		for (uint256 i = 0; i < _mintAmount; ++i) {
1379             addressFreeMintedBalance[msg.sender]++;
1380 
1381 		}
1382         _safeMint(msg.sender, _mintAmount);
1383 		delete s;
1384         delete addressFreeMintedCount;
1385 	}
1386 
1387 
1388     function mint(uint256 _mintAmount) public payable nonReentrant {
1389         uint256 s = totalSupply();
1390         require(_mintAmount > 0, "Cant mint 0 BokiGirls");
1391         require(_mintAmount <= maxperAddressPublicMint, "Cant mint more BokiGirls" );
1392         require(s + _mintAmount <= maxSupply, "Cant exceed BokiGirls supply");
1393         require(msg.value >= cost * _mintAmount);
1394         _safeMint(msg.sender, _mintAmount);
1395         delete s;
1396     }
1397 
1398     function gift(uint256[] calldata quantity, address[] calldata recipient)
1399         external
1400         onlyOwner
1401     {
1402         require(
1403             quantity.length == recipient.length,
1404             "Provide quantities and recipients"
1405         );
1406         uint256 totalQuantity = 0;
1407         uint256 s = totalSupply();
1408         for (uint256 i = 0; i < quantity.length; ++i) {
1409             totalQuantity += quantity[i];
1410         }
1411         require(s + totalQuantity <= maxSupply, "Too many");
1412         delete totalQuantity;
1413         for (uint256 i = 0; i < recipient.length; ++i) {
1414             _safeMint(recipient[i], quantity[i]);
1415         }
1416         delete s;
1417     }
1418 
1419     function tokenURI(uint256 tokenId)
1420         public
1421         view
1422         virtual
1423         override
1424         returns (string memory)
1425     {
1426         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1427         string memory currentBaseURI = _baseURI();
1428         return
1429             bytes(currentBaseURI).length > 0
1430                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1431                 : "";
1432     }
1433 
1434 
1435 
1436     function setCost(uint256 _newCost) public onlyOwner {
1437         cost = _newCost;
1438     }
1439 
1440     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1441         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1442         maxSupply = _newMaxSupply;
1443     }
1444      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1445                maxFree = _newMaxFreeSupply;
1446     }
1447 
1448     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1449         baseURI = _newBaseURI;
1450     }
1451 
1452     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1453         maxperAddressPublicMint = _amount;
1454     }
1455 
1456     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1457         maxperAddressFreeLimit = _amount;
1458     }
1459     function withdraw() public payable onlyOwner {
1460         (bool success, ) = payable(msg.sender).call{
1461             value: address(this).balance
1462         }("");
1463         require(success);
1464     }
1465 
1466     function withdrawAny(uint256 _amount) public payable onlyOwner {
1467         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1468         require(success);
1469     }
1470 }