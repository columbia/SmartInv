1 // SPDX-License-Identifier: Unlicense
2 // Sources flattened with hardhat v2.8.3 https://hardhat.org
3 pragma solidity ^0.8.4;
4 
5 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
31 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
172 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
173 
174 /**
175  * @title ERC721 token receiver interface
176  * @dev Interface for any contract that wants to support safeTransfers
177  * from ERC721 asset contracts.
178  */
179 interface IERC721Receiver {
180     /**
181      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
182      * by `operator` from `from`, this function is called.
183      *
184      * It must return its Solidity selector to confirm the token transfer.
185      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
186      *
187      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
188      */
189     function onERC721Received(
190         address operator,
191         address from,
192         uint256 tokenId,
193         bytes calldata data
194     ) external returns (bytes4);
195 }
196 
197 
198 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
199 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Metadata is IERC721 {
206     /**
207      * @dev Returns the token collection name.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the token collection symbol.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
218      */
219     function tokenURI(uint256 tokenId) external view returns (string memory);
220 }
221 
222 
223 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
224 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Enumerable is IERC721 {
231     /**
232      * @dev Returns the total amount of tokens stored by the contract.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
238      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
239      */
240     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
241 
242     /**
243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
244      * Use along with {totalSupply} to enumerate all tokens.
245      */
246     function tokenByIndex(uint256 index) external view returns (uint256);
247 }
248 
249 
250 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
251 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize, which returns 0 for contracts in
276         // construction, since the code is only stored at the end of the
277         // constructor execution.
278 
279         uint256 size;
280         assembly {
281             size := extcodesize(account)
282         }
283         return size > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal view returns (bytes memory) {
404         require(isContract(target), "Address: static call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.staticcall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.delegatecall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
439      * revert reason using the provided one.
440      *
441      * _Available since v4.3._
442      */
443     function verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) internal pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 
467 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
468 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
469 
470 /**
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes calldata) {
486         return msg.data;
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
492 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
493 
494 /**
495  * @dev String operations.
496  */
497 library Strings {
498     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
502      */
503     function toString(uint256 value) internal pure returns (string memory) {
504         // Inspired by OraclizeAPI's implementation - MIT licence
505         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
506 
507         if (value == 0) {
508             return "0";
509         }
510         uint256 temp = value;
511         uint256 digits;
512         while (temp != 0) {
513             digits++;
514             temp /= 10;
515         }
516         bytes memory buffer = new bytes(digits);
517         while (value != 0) {
518             digits -= 1;
519             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
520             value /= 10;
521         }
522         return string(buffer);
523     }
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
527      */
528     function toHexString(uint256 value) internal pure returns (string memory) {
529         if (value == 0) {
530             return "0x00";
531         }
532         uint256 temp = value;
533         uint256 length = 0;
534         while (temp != 0) {
535             length++;
536             temp >>= 8;
537         }
538         return toHexString(value, length);
539     }
540 
541     /**
542      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
543      */
544     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
545         bytes memory buffer = new bytes(2 * length + 2);
546         buffer[0] = "0";
547         buffer[1] = "x";
548         for (uint256 i = 2 * length + 1; i > 1; --i) {
549             buffer[i] = _HEX_SYMBOLS[value & 0xf];
550             value >>= 4;
551         }
552         require(value == 0, "Strings: hex length insufficient");
553         return string(buffer);
554     }
555 }
556 
557 
558 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
560 
561 /**
562  * @dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 
585 // File erc721a/contracts/ERC721A.sol@v2.2.0
586 // Creator: Chiru Labs
587 
588 error ApprovalCallerNotOwnerNorApproved();
589 error ApprovalQueryForNonexistentToken();
590 error ApproveToCaller();
591 error ApprovalToCurrentOwner();
592 error BalanceQueryForZeroAddress();
593 error MintedQueryForZeroAddress();
594 error BurnedQueryForZeroAddress();
595 error MintToZeroAddress();
596 error MintZeroQuantity();
597 error OwnerIndexOutOfBounds();
598 error OwnerQueryForNonexistentToken();
599 error TokenIndexOutOfBounds();
600 error TransferCallerNotOwnerNorApproved();
601 error TransferFromIncorrectOwner();
602 error TransferToNonERC721ReceiverImplementer();
603 error TransferToZeroAddress();
604 error URIQueryForNonexistentToken();
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
609  *
610  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
611  *
612  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
613  *
614  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
615  */
616 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
617     using Address for address;
618     using Strings for uint256;
619 
620     // Compiler will pack this into a single 256bit word.
621     struct TokenOwnership {
622         // The address of the owner.
623         address addr;
624         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
625         uint64 startTimestamp;
626         // Whether the token has been burned.
627         bool burned;
628     }
629 
630     // Compiler will pack this into a single 256bit word.
631     struct AddressData {
632         // Realistically, 2**64-1 is more than enough.
633         uint64 balance;
634         // Keeps track of mint count with minimal overhead for tokenomics.
635         uint64 numberMinted;
636         // Keeps track of burn count with minimal overhead for tokenomics.
637         uint64 numberBurned;
638     }
639 
640     // Compiler will pack the following 
641     // _currentIndex and _burnCounter into a single 256bit word.
642     
643     // The tokenId of the next token to be minted.
644     uint128 internal _currentIndex;
645 
646     // The number of tokens burned.
647     uint128 internal _burnCounter;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to ownership details
656     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
657     mapping(uint256 => TokenOwnership) internal _ownerships;
658 
659     // Mapping owner address to address data
660     mapping(address => AddressData) private _addressData;
661 
662     // Mapping from token ID to approved address
663     mapping(uint256 => address) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671     }
672 
673     /**
674      * @dev See {IERC721Enumerable-totalSupply}.
675      */
676     function totalSupply() public view override returns (uint256) {
677         // Counter underflow is impossible as _burnCounter cannot be incremented
678         // more than _currentIndex times
679         unchecked {
680             return _currentIndex - _burnCounter;    
681         }
682     }
683 
684     /**
685      * @dev See {IERC721Enumerable-tokenByIndex}.
686      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
687      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
688      */
689     function tokenByIndex(uint256 index) public view override returns (uint256) {
690         uint256 numMintedSoFar = _currentIndex;
691         uint256 tokenIdsIdx;
692 
693         // Counter overflow is impossible as the loop breaks when
694         // uint256 i is equal to another uint256 numMintedSoFar.
695         unchecked {
696             for (uint256 i; i < numMintedSoFar; i++) {
697                 TokenOwnership memory ownership = _ownerships[i];
698                 if (!ownership.burned) {
699                     if (tokenIdsIdx == index) {
700                         return i;
701                     }
702                     tokenIdsIdx++;
703                 }
704             }
705         }
706         revert TokenIndexOutOfBounds();
707     }
708 
709     /**
710      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
711      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
712      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
713      */
714     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
715         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
716         uint256 numMintedSoFar = _currentIndex;
717         uint256 tokenIdsIdx;
718         address currOwnershipAddr;
719 
720         // Counter overflow is impossible as the loop breaks when
721         // uint256 i is equal to another uint256 numMintedSoFar.
722         unchecked {
723             for (uint256 i; i < numMintedSoFar; i++) {
724                 TokenOwnership memory ownership = _ownerships[i];
725                 if (ownership.burned) {
726                     continue;
727                 }
728                 if (ownership.addr != address(0)) {
729                     currOwnershipAddr = ownership.addr;
730                 }
731                 if (currOwnershipAddr == owner) {
732                     if (tokenIdsIdx == index) {
733                         return i;
734                     }
735                     tokenIdsIdx++;
736                 }
737             }
738         }
739 
740         // Execution should never reach this point.
741         revert();
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
748         return
749             interfaceId == type(IERC721).interfaceId ||
750             interfaceId == type(IERC721Metadata).interfaceId ||
751             interfaceId == type(IERC721Enumerable).interfaceId ||
752             super.supportsInterface(interfaceId);
753     }
754 
755     /**
756      * @dev See {IERC721-balanceOf}.
757      */
758     function balanceOf(address owner) public view override returns (uint256) {
759         if (owner == address(0)) revert BalanceQueryForZeroAddress();
760         return uint256(_addressData[owner].balance);
761     }
762 
763     function _numberMinted(address owner) internal view returns (uint256) {
764         if (owner == address(0)) revert MintedQueryForZeroAddress();
765         return uint256(_addressData[owner].numberMinted);
766     }
767 
768     function _numberBurned(address owner) internal view returns (uint256) {
769         if (owner == address(0)) revert BurnedQueryForZeroAddress();
770         return uint256(_addressData[owner].numberBurned);
771     }
772 
773     /**
774      * Gas spent here starts off proportional to the maximum mint batch size.
775      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
776      */
777     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
778         uint256 curr = tokenId;
779 
780         unchecked {
781             if (curr < _currentIndex) {
782                 TokenOwnership memory ownership = _ownerships[curr];
783                 if (!ownership.burned) {
784                     if (ownership.addr != address(0)) {
785                         return ownership;
786                     }
787                     // Invariant: 
788                     // There will always be an ownership that has an address and is not burned 
789                     // before an ownership that does not have an address and is not burned.
790                     // Hence, curr will not underflow.
791                     while (true) {
792                         curr--;
793                         ownership = _ownerships[curr];
794                         if (ownership.addr != address(0)) {
795                             return ownership;
796                         }
797                     }
798                 }
799             }
800         }
801         revert OwnerQueryForNonexistentToken();
802     }
803 
804     /**
805      * @dev See {IERC721-ownerOf}.
806      */
807     function ownerOf(uint256 tokenId) public view override returns (address) {
808         return ownershipOf(tokenId).addr;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-name}.
813      */
814     function name() public view virtual override returns (string memory) {
815         return _name;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-symbol}.
820      */
821     function symbol() public view virtual override returns (string memory) {
822         return _symbol;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-tokenURI}.
827      */
828     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
829         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
830 
831         string memory baseURI = _baseURI();
832         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
833     }
834 
835     /**
836      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
837      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
838      * by default, can be overriden in child contracts.
839      */
840     function _baseURI() internal view virtual returns (string memory) {
841         return '';
842     }
843 
844     /**
845      * @dev See {IERC721-approve}.
846      */
847     function approve(address to, uint256 tokenId) public override {
848         address owner = ERC721A.ownerOf(tokenId);
849         if (to == owner) revert ApprovalToCurrentOwner();
850 
851         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
852             revert ApprovalCallerNotOwnerNorApproved();
853         }
854 
855         _approve(to, tokenId, owner);
856     }
857 
858     /**
859      * @dev See {IERC721-getApproved}.
860      */
861     function getApproved(uint256 tokenId) public view override returns (address) {
862         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
863 
864         return _tokenApprovals[tokenId];
865     }
866 
867     /**
868      * @dev See {IERC721-setApprovalForAll}.
869      */
870     function setApprovalForAll(address operator, bool approved) public override {
871         if (operator == _msgSender()) revert ApproveToCaller();
872 
873         _operatorApprovals[_msgSender()][operator] = approved;
874         emit ApprovalForAll(_msgSender(), operator, approved);
875     }
876 
877     /**
878      * @dev See {IERC721-isApprovedForAll}.
879      */
880     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
881         return _operatorApprovals[owner][operator];
882     }
883 
884     /**
885      * @dev See {IERC721-transferFrom}.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         _transfer(from, to, tokenId);
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public virtual override {
903         safeTransferFrom(from, to, tokenId, '');
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) public virtual override {
915         _transfer(from, to, tokenId);
916         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
917             revert TransferToNonERC721ReceiverImplementer();
918         }
919     }
920 
921     /**
922      * @dev Returns whether `tokenId` exists.
923      *
924      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
925      *
926      * Tokens start existing when they are minted (`_mint`),
927      */
928     function _exists(uint256 tokenId) internal view returns (bool) {
929         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
930     }
931 
932     function _safeMint(address to, uint256 quantity) internal {
933         _safeMint(to, quantity, '');
934     }
935 
936     /**
937      * @dev Safely mints `quantity` tokens and transfers them to `to`.
938      *
939      * Requirements:
940      *
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
942      * - `quantity` must be greater than 0.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeMint(
947         address to,
948         uint256 quantity,
949         bytes memory _data
950     ) internal {
951         _mint(to, quantity, _data, true);
952     }
953 
954     /**
955      * @dev Mints `quantity` tokens and transfers them to `to`.
956      *
957      * Requirements:
958      *
959      * - `to` cannot be the zero address.
960      * - `quantity` must be greater than 0.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _mint(
965         address to,
966         uint256 quantity,
967         bytes memory _data,
968         bool safe
969     ) internal {
970         uint256 startTokenId = _currentIndex;
971         if (to == address(0)) revert MintToZeroAddress();
972         if (quantity == 0) revert MintZeroQuantity();
973 
974         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
975 
976         // Overflows are incredibly unrealistic.
977         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
978         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
979         unchecked {
980             _addressData[to].balance += uint64(quantity);
981             _addressData[to].numberMinted += uint64(quantity);
982 
983             _ownerships[startTokenId].addr = to;
984             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
985 
986             uint256 updatedIndex = startTokenId;
987 
988             for (uint256 i; i < quantity; i++) {
989                 emit Transfer(address(0), to, updatedIndex);
990                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
991                     revert TransferToNonERC721ReceiverImplementer();
992                 }
993                 updatedIndex++;
994             }
995 
996             _currentIndex = uint128(updatedIndex);
997         }
998         _afterTokenTransfers(address(0), to, startTokenId, quantity);
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _transfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) private {
1016         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1017 
1018         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1019             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1020             getApproved(tokenId) == _msgSender());
1021 
1022         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1023         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1024         if (to == address(0)) revert TransferToZeroAddress();
1025 
1026         _beforeTokenTransfers(from, to, tokenId, 1);
1027 
1028         // Clear approvals from the previous owner
1029         _approve(address(0), tokenId, prevOwnership.addr);
1030 
1031         // Underflow of the sender's balance is impossible because we check for
1032         // ownership above and the recipient's balance can't realistically overflow.
1033         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1034         unchecked {
1035             _addressData[from].balance -= 1;
1036             _addressData[to].balance += 1;
1037 
1038             _ownerships[tokenId].addr = to;
1039             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1040 
1041             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1042             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1043             uint256 nextTokenId = tokenId + 1;
1044             if (_ownerships[nextTokenId].addr == address(0)) {
1045                 // This will suffice for checking _exists(nextTokenId),
1046                 // as a burned slot cannot contain the zero address.
1047                 if (nextTokenId < _currentIndex) {
1048                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1049                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1050                 }
1051             }
1052         }
1053 
1054         emit Transfer(from, to, tokenId);
1055         _afterTokenTransfers(from, to, tokenId, 1);
1056     }
1057 
1058     /**
1059      * @dev Destroys `tokenId`.
1060      * The approval is cleared when the token is burned.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _burn(uint256 tokenId) internal virtual {
1069         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1070 
1071         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId, prevOwnership.addr);
1075 
1076         // Underflow of the sender's balance is impossible because we check for
1077         // ownership above and the recipient's balance can't realistically overflow.
1078         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1079         unchecked {
1080             _addressData[prevOwnership.addr].balance -= 1;
1081             _addressData[prevOwnership.addr].numberBurned += 1;
1082 
1083             // Keep track of who burned the token, and the timestamp of burning.
1084             _ownerships[tokenId].addr = prevOwnership.addr;
1085             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1086             _ownerships[tokenId].burned = true;
1087 
1088             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1089             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1090             uint256 nextTokenId = tokenId + 1;
1091             if (_ownerships[nextTokenId].addr == address(0)) {
1092                 // This will suffice for checking _exists(nextTokenId),
1093                 // as a burned slot cannot contain the zero address.
1094                 if (nextTokenId < _currentIndex) {
1095                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1096                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1097                 }
1098             }
1099         }
1100 
1101         emit Transfer(prevOwnership.addr, address(0), tokenId);
1102         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1103 
1104         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1105         unchecked { 
1106             _burnCounter++;
1107         }
1108     }
1109 
1110     /**
1111      * @dev Approve `to` to operate on `tokenId`
1112      *
1113      * Emits a {Approval} event.
1114      */
1115     function _approve(
1116         address to,
1117         uint256 tokenId,
1118         address owner
1119     ) private {
1120         _tokenApprovals[tokenId] = to;
1121         emit Approval(owner, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1126      * The call is not executed if the target address is not a contract.
1127      *
1128      * @param from address representing the previous owner of the given token ID
1129      * @param to target address that will receive the tokens
1130      * @param tokenId uint256 ID of the token to be transferred
1131      * @param _data bytes optional data to send along with the call
1132      * @return bool whether the call correctly returned the expected magic value
1133      */
1134     function _checkOnERC721Received(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) private returns (bool) {
1140         if (to.isContract()) {
1141             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1142                 return retval == IERC721Receiver(to).onERC721Received.selector;
1143             } catch (bytes memory reason) {
1144                 if (reason.length == 0) {
1145                     revert TransferToNonERC721ReceiverImplementer();
1146                 } else {
1147                     assembly {
1148                         revert(add(32, reason), mload(reason))
1149                     }
1150                 }
1151             }
1152         } else {
1153             return true;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1159      * And also called before burning one token.
1160      *
1161      * startTokenId - the first token id to be transferred
1162      * quantity - the amount to be transferred
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` will be minted for `to`.
1169      * - When `to` is zero, `tokenId` will be burned by `from`.
1170      * - `from` and `to` are never both zero.
1171      */
1172     function _beforeTokenTransfers(
1173         address from,
1174         address to,
1175         uint256 startTokenId,
1176         uint256 quantity
1177     ) internal virtual {}
1178 
1179     /**
1180      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1181      * minting.
1182      * And also called after one token has been burned.
1183      *
1184      * startTokenId - the first token id to be transferred
1185      * quantity - the amount to be transferred
1186      *
1187      * Calling conditions:
1188      *
1189      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1190      * transferred to `to`.
1191      * - When `from` is zero, `tokenId` has been minted for `to`.
1192      * - When `to` is zero, `tokenId` has been burned by `from`.
1193      * - `from` and `to` are never both zero.
1194      */
1195     function _afterTokenTransfers(
1196         address from,
1197         address to,
1198         uint256 startTokenId,
1199         uint256 quantity
1200     ) internal virtual {}
1201 }
1202 
1203 
1204 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
1205 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1206 
1207 /**
1208  * @dev Contract module which provides a basic access control mechanism, where
1209  * there is an account (an owner) that can be granted exclusive access to
1210  * specific functions.
1211  *
1212  * By default, the owner account will be the one that deploys the contract. This
1213  * can later be changed with {transferOwnership}.
1214  *
1215  * This module is used through inheritance. It will make available the modifier
1216  * `onlyOwner`, which can be applied to your functions to restrict their use to
1217  * the owner.
1218  */
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1223 
1224     /**
1225      * @dev Initializes the contract setting the deployer as the initial owner.
1226      */
1227     constructor() {
1228         _transferOwnership(_msgSender());
1229     }
1230 
1231     /**
1232      * @dev Returns the address of the current owner.
1233      */
1234     function owner() public view virtual returns (address) {
1235         return _owner;
1236     }
1237 
1238     /**
1239      * @dev Throws if called by any account other than the owner.
1240      */
1241     modifier onlyOwner() {
1242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Leaves the contract without owner. It will not be possible to call
1248      * `onlyOwner` functions anymore. Can only be called by the current owner.
1249      *
1250      * NOTE: Renouncing ownership will leave the contract without an owner,
1251      * thereby removing any functionality that is only available to the owner.
1252      */
1253     function renounceOwnership() public virtual onlyOwner {
1254         _transferOwnership(address(0));
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Can only be called by the current owner.
1260      */
1261     function transferOwnership(address newOwner) public virtual onlyOwner {
1262         require(newOwner != address(0), "Ownable: new owner is the zero address");
1263         _transferOwnership(newOwner);
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Internal function without access restriction.
1269      */
1270     function _transferOwnership(address newOwner) internal virtual {
1271         address oldOwner = _owner;
1272         _owner = newOwner;
1273         emit OwnershipTransferred(oldOwner, newOwner);
1274     }
1275 }
1276 
1277 
1278 // File contracts/MHDC.sol
1279 // MHDC ERC721A Contract
1280 
1281 contract MHDC is ERC721A, Ownable {
1282     // amounts sold per address in each sale
1283     mapping(address => uint256) private _primary;
1284     mapping(address => uint256) private _public;
1285 
1286     // total amounts sold
1287     uint256 private _primarySold;
1288     uint256 private _publicSold;
1289 
1290     // whitelist
1291     mapping(address => bool) private _primaryList;
1292 
1293     // primary distributions
1294     struct Dist {
1295         uint256 share;
1296         uint256 loc;
1297         string name;
1298     }
1299 
1300     mapping(address => Dist) private _distMap;
1301     address[] private _distList;
1302     uint256 private _shareTotal = 0;
1303 
1304     uint256 private _primaryMaxAmount = 6000;
1305     uint256 private _publicMaxAmount = 600;
1306     uint256 private _price = 0.0666 ether;
1307     uint256 private _primaryLimit = 3;
1308     uint256 private _publicLimit = 2;
1309 
1310     bool private _isPrimarySale = true;
1311     bool private _isPublicSale;
1312 
1313     event PrimarySale(bool isPrimarySale);
1314     event PublicSale(bool isPublicSale);
1315     event Distribution(uint256 amount);
1316     event DistributionListChange(address indexed target, bool isIncluded);
1317 
1318     constructor(
1319         address[] memory addresses,
1320         string[] memory names,
1321         uint256[] memory shares,
1322         address[] memory premintAddresses,
1323         uint256[] memory premintQuantity
1324     ) ERC721A("Murder Head Death Club", "MHDC") {
1325         for (uint256 i = 0; i < addresses.length; i++) {
1326             addDist(addresses[i], names[i], shares[i]);
1327         }
1328 
1329         for (uint256 i = 0; i < premintAddresses.length; i++) {
1330             _safeMint(premintAddresses[i], premintQuantity[i]);
1331         }
1332 
1333         emit PrimarySale(true);
1334     }
1335 
1336     receive() external payable {}
1337 
1338     fallback() external payable {}
1339 
1340     function _baseURI() internal pure override returns (string memory) {
1341         return "https://murderheaddeathclub.com/api/nft/";
1342     }
1343 
1344     function getShareTotal() public view returns (uint256) {
1345         return _shareTotal;
1346     }
1347 
1348     function getShare(address account) public view returns (uint256) {
1349         return _distMap[account].share;
1350     }
1351 
1352     function getName(address account) public view returns (string memory) {
1353         return _distMap[account].name;
1354     }
1355 
1356     function allDist() public view returns (address[] memory) {
1357         return _distList;
1358     }
1359 
1360     function isDist(address account) public view returns (bool) {
1361         return (getShare(account) > 0);
1362     }
1363 
1364     function setPrice(uint256 price) external onlyOwner {
1365         _price = price;
1366     }
1367 
1368     function getPrice() public view returns (uint256) {
1369         return _price;
1370     }
1371 
1372     function setPrimaryLimit(uint256 lim) external onlyOwner {
1373         _primaryLimit = lim;
1374     }
1375 
1376     function setPublicLimit(uint256 lim) external onlyOwner {
1377         _publicLimit = lim;
1378     }
1379 
1380     function getPrimaryLimit() public view returns (uint256) {
1381         return _primaryLimit;
1382     }
1383 
1384     function getPublicLimit() public view returns (uint256) {
1385         return _publicLimit;
1386     }
1387 
1388     function isPrimarySale() public view returns (bool) {
1389         return _isPrimarySale;
1390     }
1391 
1392     function isPublicSale() public view returns (bool) {
1393         return _isPublicSale;
1394     }
1395 
1396     function getPrimarySold() public view returns (uint256) {
1397         return _primarySold;
1398     }
1399 
1400     function getPublicSold() public view returns (uint256) {
1401         return _publicSold;
1402     }
1403 
1404     function getTotalSold() public view returns (uint256) {
1405         return _primarySold + _publicSold;
1406     }
1407 
1408     function getAddressPrimarySold(address target)
1409         public
1410         view
1411         returns (uint256)
1412     {
1413         return _primary[target];
1414     }
1415 
1416     function getAddressPublicSold(address target)
1417         public
1418         view
1419         returns (uint256)
1420     {
1421         return _public[target];
1422     }
1423 
1424     function isPrimaryAddress(address target) public view returns (bool) {
1425         return _primaryList[target];
1426     }
1427 
1428     function setPrimaryAddresses(address[] memory _addresses, bool _state)
1429         external
1430         onlyOwner
1431     {
1432         for (uint256 i = 0; i < _addresses.length; i++) {
1433             _primaryList[_addresses[i]] = _state;
1434         }
1435     }
1436 
1437     function shareTotal() private {
1438         uint256 sum;
1439         for (uint256 i = 0; i < _distList.length; i++) {
1440             sum += _distMap[_distList[i]].share;
1441         }
1442         _shareTotal = sum;
1443     }
1444 
1445     function addDist(
1446         address _address,
1447         string memory _Name,
1448         uint256 _share
1449     ) public onlyOwner {
1450         require(_address != address(0), "Invalid address");
1451         require(_share > 0, "Share must be greater than zero");
1452         Dist storage d = _distMap[_address];
1453         require(d.share == 0, "Address already in distribution list");
1454 
1455         d.share = _share;
1456         d.loc = _distList.length;
1457         d.name = _Name;
1458 
1459         _distList.push(_address);
1460         emit DistributionListChange(_address, true);
1461         shareTotal();
1462     }
1463 
1464     function removeDist(address _address) public onlyOwner {
1465         Dist storage d = _distMap[_address];
1466         require(d.share > 0, "Address not in distribution list");
1467         d.share = 0;
1468 
1469         address _last = _distList[_distList.length - 1];
1470         _distMap[_last].loc = d.loc;
1471         _distList[d.loc] = _last;
1472         _distList.pop();
1473 
1474         emit DistributionListChange(_address, false);
1475         shareTotal();
1476     }
1477 
1478     function editDistName(address _address, string memory _Name)
1479         external
1480         onlyOwner
1481     {
1482         Dist storage d = _distMap[_address];
1483         require(d.share > 0, "Address not in distribution list");
1484         d.name = _Name;
1485     }
1486 
1487     function editDistShare(address _address, uint256 _share)
1488         external
1489         onlyOwner
1490     {
1491         require(_share > 0, "To set share to zero, use removeDist()");
1492         Dist storage d = _distMap[_address];
1493         require(d.share > 0, "Address not in distribution list");
1494 
1495         d.share = _share;
1496         shareTotal();
1497     }
1498 
1499     function editDistAddress(string memory _Name, address _newAddress)
1500 	external
1501 	onlyOwner
1502     {
1503 	address _oldAddress;
1504 	Dist memory d;
1505 
1506 	for (uint256 i = 0; i < _distList.length; i++) {
1507 	_oldAddress = _distList[i];
1508 	d = _distMap[_oldAddress];
1509 
1510 	    if (keccak256(bytes(d.name)) == keccak256(bytes(_Name))) {
1511 		removeDist(_oldAddress);
1512 		addDist(_newAddress, _Name, d.share);
1513 	    }
1514 	}
1515     }
1516 
1517     function primaryMint(uint256 quantity) external payable {
1518         require(_isPrimarySale, "No ongoing primary sale");
1519         require(
1520             _primaryList[_msgSender()],
1521             "Address not allowed to participate in primary sale"
1522         );
1523         require(
1524             msg.value == _price * quantity,
1525             "Payment amount not equal to the price of token(s)"
1526         );
1527 
1528         uint256 _newPrimarySold = _primarySold + quantity;
1529         require(
1530             _newPrimarySold <= _primaryMaxAmount,
1531             "Transaction quantity exceeds the number of available tokens in primary sale"
1532         );
1533 
1534         uint256 _newSold = _primary[_msgSender()] + quantity;
1535         require(_newSold <= _primaryLimit, "Insufficient allowance");
1536 
1537         _primarySold = _newPrimarySold;
1538         _primary[_msgSender()] = _newSold;
1539         _safeMint(_msgSender(), quantity);
1540     }
1541 
1542     function publicMint(uint256 quantity) external payable {
1543         require(_isPublicSale, "No ongoing public sale");
1544         require(
1545             msg.value == _price * quantity,
1546             "Payment amount not equal to the price of token(s)"
1547         );
1548 
1549         uint256 _newPublicSold = _publicSold + quantity;
1550         require(
1551             _newPublicSold <= _publicMaxAmount,
1552             "Transaction quantity exceeds the number of available tokens in public sale"
1553         );
1554 
1555         uint256 _newSold = _public[_msgSender()] + quantity;
1556         require(_newSold <= _publicLimit, "Insufficient allowance");
1557 
1558         _publicSold = _newPublicSold;
1559         _public[_msgSender()] = _newSold;
1560         _safeMint(_msgSender(), quantity);
1561     }
1562 
1563     function setPrimarySale(bool state) external onlyOwner {
1564         require(_isPrimarySale != state, "Primary sale already in this state");
1565         _isPrimarySale = state;
1566 
1567         if (!state) {
1568             _publicMaxAmount += _primaryMaxAmount - _primarySold;
1569             _primaryMaxAmount = _primarySold;
1570         }
1571         emit PrimarySale(state);
1572     }
1573 
1574     function setPublicSale(bool state) external onlyOwner {
1575         require(_isPublicSale != state, "Public sale already in this state");
1576         _isPublicSale = state;
1577         emit PublicSale(state);
1578     }
1579 
1580     function distribute() external onlyOwner {
1581         if (_distList.length > 0) {
1582             uint256 balance = address(this).balance;
1583             uint256 unit = balance / _shareTotal;
1584             address _address;
1585 
1586             for (uint256 i = 0; i < _distList.length; i++) {
1587                 _address = _distList[i];
1588                 payable(_address).transfer(_distMap[_address].share * unit);
1589             }
1590             emit Distribution(balance);
1591         }
1592     }
1593 }