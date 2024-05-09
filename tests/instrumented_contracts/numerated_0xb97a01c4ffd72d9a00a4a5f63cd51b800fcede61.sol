1 /**
2 
3           _          _                _        _            _
4         /\ \       /\ \             /\ \     /\ \         /\ \
5        /  \ \     /  \ \            \ \ \   /  \ \        \_\ \
6       / /\ \ \   / /\ \ \           /\ \_\ / /\ \ \       /\__ \
7      / / /\ \_\ / / /\ \_\         / /\/_// / /\ \ \     / /_ \ \
8     / / /_/ / // / /_/ / /_       / / /  / / /  \ \_\   / / /\ \ \
9    / / /__\/ // / /__\/ //\ \    / / /  / / /    \/_/  / / /  \/_/
10   / / /_____// / /_____/ \ \_\  / / /  / / /          / / /
11  / / /      / / /\ \ \   / / /_/ / /  / / /________  / / /
12 / / /      / / /  \ \ \ / / /__\/ /  / / /_________\/_/ /
13 \/_/       \/_/    \_\/ \/_______/   \/____________/\_\/
14 
15 Created by: https://prjct.tools
16 
17 prjct.tools helps you build and launch a generative nft project: we provide
18 the core libraries, APIs, workflows and front-end tools while you focus on
19 art and ideas. Merging infinite creativity with structured machine learning
20 and computational algorithms.
21 
22 Let's build art together.
23  */
24 
25 // SPDX-License-Identifier: MIT
26 
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Required interface of an ERC721 compliant contract.
55  */
56 interface IERC721 is IERC165 {
57     /**
58      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
59      */
60     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
64      */
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
69      */
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     /**
73      * @dev Returns the number of tokens in ``owner``'s account.
74      */
75     function balanceOf(address owner) external view returns (uint256 balance);
76 
77     /**
78      * @dev Returns the owner of the `tokenId` token.
79      *
80      * Requirements:
81      *
82      * - `tokenId` must exist.
83      */
84     function ownerOf(uint256 tokenId) external view returns (address owner);
85 
86     /**
87      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
88      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must exist and be owned by `from`.
95      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
96      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
97      *
98      * Emits a {Transfer} event.
99      */
100     function safeTransferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Transfers `tokenId` token from `from` to `to`.
108      *
109      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(
121         address from,
122         address to,
123         uint256 tokenId
124     ) external;
125 
126     /**
127      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
128      * The approval is cleared when the token is transferred.
129      *
130      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
131      *
132      * Requirements:
133      *
134      * - The caller must own the token or be an approved operator.
135      * - `tokenId` must exist.
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address to, uint256 tokenId) external;
140 
141     /**
142      * @dev Returns the account approved for `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function getApproved(uint256 tokenId) external view returns (address operator);
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator) external view returns (bool);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external;
188 }
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Implementation of the {IERC165} interface.
194  *
195  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
196  * for the additional interface id that will be supported. For example:
197  *
198  * ```solidity
199  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
200  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
201  * }
202  * ```
203  *
204  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
205  */
206 abstract contract ERC165 is IERC165 {
207     /**
208      * @dev See {IERC165-supportsInterface}.
209      */
210     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
211         return interfaceId == type(IERC165).interfaceId;
212     }
213 }
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev String operations.
219  */
220 library Strings {
221     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
225      */
226     function toString(uint256 value) internal pure returns (string memory) {
227         // Inspired by OraclizeAPI's implementation - MIT licence
228         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
229 
230         if (value == 0) {
231             return "0";
232         }
233         uint256 temp = value;
234         uint256 digits;
235         while (temp != 0) {
236             digits++;
237             temp /= 10;
238         }
239         bytes memory buffer = new bytes(digits);
240         while (value != 0) {
241             digits -= 1;
242             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
243             value /= 10;
244         }
245         return string(buffer);
246     }
247 
248     /**
249      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
250      */
251     function toHexString(uint256 value) internal pure returns (string memory) {
252         if (value == 0) {
253             return "0x00";
254         }
255         uint256 temp = value;
256         uint256 length = 0;
257         while (temp != 0) {
258             length++;
259             temp >>= 8;
260         }
261         return toHexString(value, length);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
266      */
267     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
268         bytes memory buffer = new bytes(2 * length + 2);
269         buffer[0] = "0";
270         buffer[1] = "x";
271         for (uint256 i = 2 * length + 1; i > 1; --i) {
272             buffer[i] = _HEX_SYMBOLS[value & 0xf];
273             value >>= 4;
274         }
275         require(value == 0, "Strings: hex length insufficient");
276         return string(buffer);
277     }
278 }
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Provides information about the current execution context, including the
284  * sender of the transaction and its data. While these are generally available
285  * via msg.sender and msg.data, they should not be accessed in such a direct
286  * manner, since when dealing with meta-transactions the account sending and
287  * paying for execution may not be the actual sender (as far as an application
288  * is concerned).
289  *
290  * This contract is only required for intermediate, library-like contracts.
291  */
292 abstract contract Context {
293     function _msgSender() internal view virtual returns (address) {
294         return msg.sender;
295     }
296 
297     function _msgData() internal view virtual returns (bytes calldata) {
298         return msg.data;
299     }
300 }
301 
302 pragma solidity ^0.8.1;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      *
325      * [IMPORTANT]
326      * ====
327      * You shouldn't rely on `isContract` to protect against flash loan attacks!
328      *
329      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
330      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
331      * constructor.
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize/address.code.length, which returns 0
336         // for contracts in construction, since the code is only stored at the end
337         // of the constructor execution.
338 
339         return account.code.length > 0;
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      */
358     function sendValue(address payable recipient, uint256 amount) internal {
359         require(address(this).balance >= amount, "Address: insufficient balance");
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain `call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
422      * with `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         require(isContract(target), "Address: call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.call{value: value}(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal view returns (bytes memory) {
460         require(isContract(target), "Address: static call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(isContract(target), "Address: delegate call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Enumerable is IERC721 {
529     /**
530      * @dev Returns the total amount of tokens stored by the contract.
531      */
532     function totalSupply() external view returns (uint256);
533 
534     /**
535      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
536      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
537      */
538     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
539 
540     /**
541      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
542      * Use along with {totalSupply} to enumerate all tokens.
543      */
544     function tokenByIndex(uint256 index) external view returns (uint256);
545 }
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
551  * @dev See https://eips.ethereum.org/EIPS/eip-721
552  */
553 interface IERC721Metadata is IERC721 {
554     /**
555      * @dev Returns the token collection name.
556      */
557     function name() external view returns (string memory);
558 
559     /**
560      * @dev Returns the token collection symbol.
561      */
562     function symbol() external view returns (string memory);
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view returns (string memory);
568 }
569 
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @title ERC721 token receiver interface
575  * @dev Interface for any contract that wants to support safeTransfers
576  * from ERC721 asset contracts.
577  */
578 interface IERC721Receiver {
579     /**
580      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
581      * by `operator` from `from`, this function is called.
582      *
583      * It must return its Solidity selector to confirm the token transfer.
584      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
585      *
586      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
587      */
588     function onERC721Received(
589         address operator,
590         address from,
591         uint256 tokenId,
592         bytes calldata data
593     ) external returns (bytes4);
594 }
595 
596 
597 pragma solidity ^0.8.4;
598 
599 error ApprovalCallerNotOwnerNorApproved();
600 error ApprovalQueryForNonexistentToken();
601 error ApproveToCaller();
602 error ApprovalToCurrentOwner();
603 error BalanceQueryForZeroAddress();
604 error MintedQueryForZeroAddress();
605 error MintToZeroAddress();
606 error MintZeroQuantity();
607 error OwnerIndexOutOfBounds();
608 error OwnerQueryForNonexistentToken();
609 error TokenIndexOutOfBounds();
610 error TransferCallerNotOwnerNorApproved();
611 error TransferFromIncorrectOwner();
612 error TransferToNonERC721ReceiverImplementer();
613 error TransferToZeroAddress();
614 error UnableDetermineTokenOwner();
615 error URIQueryForNonexistentToken();
616 
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
620  *
621  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
622  *
623  * Does not support burning tokens to address(0).
624  *
625  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
626  */
627 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
628     using Address for address;
629     using Strings for uint256;
630 
631     struct TokenOwnership {
632         address addr;
633         uint64 startTimestamp;
634     }
635 
636     struct AddressData {
637         uint128 balance;
638         uint128 numberMinted;
639     }
640 
641     uint256 internal _currentIndex = 1;
642 
643     // Token name
644     string private _name;
645 
646     // Token symbol
647     string private _symbol;
648 
649     // Mapping from token ID to ownership details
650     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
651     mapping(uint256 => TokenOwnership) internal _ownerships;
652 
653     // Mapping owner address to address data
654     mapping(address => AddressData) private _addressData;
655 
656     // Mapping from token ID to approved address
657     mapping(uint256 => address) private _tokenApprovals;
658 
659     // Mapping from owner to operator approvals
660     mapping(address => mapping(address => bool)) private _operatorApprovals;
661 
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665     }
666 
667     /**
668      * @dev See {IERC721Enumerable-totalSupply}.
669      */
670     function totalSupply() public view override returns (uint256) {
671         return _currentIndex;
672     }
673 
674     /**
675      * @dev See {IERC721Enumerable-tokenByIndex}.
676      */
677     function tokenByIndex(uint256 index) public view override returns (uint256) {
678         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
679         return index;
680     }
681 
682     /**
683      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
684      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
685      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
686      */
687     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
688         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
689         uint256 numMintedSoFar = totalSupply();
690         uint256 tokenIdsIdx;
691         address currOwnershipAddr;
692 
693         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
694         unchecked {
695             for (uint256 i; i < numMintedSoFar; i++) {
696                 TokenOwnership memory ownership = _ownerships[i];
697                 if (ownership.addr != address(0)) {
698                     currOwnershipAddr = ownership.addr;
699                 }
700                 if (currOwnershipAddr == owner) {
701                     if (tokenIdsIdx == index) {
702                         return i;
703                     }
704                     tokenIdsIdx++;
705                 }
706             }
707         }
708 
709         // Execution should never reach this point.
710         assert(false);
711         return 0;
712     }
713 
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
718         return
719             interfaceId == type(IERC721).interfaceId ||
720             interfaceId == type(IERC721Metadata).interfaceId ||
721             interfaceId == type(IERC721Enumerable).interfaceId ||
722             super.supportsInterface(interfaceId);
723     }
724 
725     /**
726      * @dev See {IERC721-balanceOf}.
727      */
728     function balanceOf(address owner) public view override returns (uint256) {
729         if (owner == address(0)) revert BalanceQueryForZeroAddress();
730         return uint256(_addressData[owner].balance);
731     }
732 
733     function _numberMinted(address owner) internal view returns (uint256) {
734         if (owner == address(0)) revert MintedQueryForZeroAddress();
735         return uint256(_addressData[owner].numberMinted);
736     }
737 
738     /**
739      * Gas spent here starts off proportional to the maximum mint batch size.
740      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
741      */
742     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
743         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
744 
745         unchecked {
746             for (uint256 curr = tokenId;; curr--) {
747                 TokenOwnership memory ownership = _ownerships[curr];
748                 if (ownership.addr != address(0)) {
749                     return ownership;
750                 }
751             }
752         }
753         return _ownerships[0];
754     }
755 
756     /**
757      * @dev See {IERC721-ownerOf}.
758      */
759     function ownerOf(uint256 tokenId) public view override returns (address) {
760         return ownershipOf(tokenId).addr;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-name}.
765      */
766     function name() public view virtual override returns (string memory) {
767         return _name;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-symbol}.
772      */
773     function symbol() public view virtual override returns (string memory) {
774         return _symbol;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-tokenURI}.
779      */
780     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
781         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
782 
783         string memory baseURI = _baseURI();
784         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
785     }
786 
787     /**
788      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
789      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
790      * by default, can be overriden in child contracts.
791      */
792     function _baseURI() internal view virtual returns (string memory) {
793         return '';
794     }
795 
796     /**
797      * @dev See {IERC721-approve}.
798      */
799     function approve(address to, uint256 tokenId) public override {
800         address owner = ERC721A.ownerOf(tokenId);
801         if (to == owner) revert ApprovalToCurrentOwner();
802 
803         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
804 
805         _approve(to, tokenId, owner);
806     }
807 
808     /**
809      * @dev See {IERC721-getApproved}.
810      */
811     function getApproved(uint256 tokenId) public view override returns (address) {
812         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
813 
814         return _tokenApprovals[tokenId];
815     }
816 
817     /**
818      * @dev See {IERC721-setApprovalForAll}.
819      */
820     function setApprovalForAll(address operator, bool approved) public override {
821         if (operator == _msgSender()) revert ApproveToCaller();
822 
823         _operatorApprovals[_msgSender()][operator] = approved;
824         emit ApprovalForAll(_msgSender(), operator, approved);
825     }
826 
827     /**
828      * @dev See {IERC721-isApprovedForAll}.
829      */
830     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
831         return _operatorApprovals[owner][operator];
832     }
833 
834     /**
835      * @dev See {IERC721-transferFrom}.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) public virtual override {
842         _transfer(from, to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-safeTransferFrom}.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         safeTransferFrom(from, to, tokenId, '');
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) public override {
865         _transfer(from, to, tokenId);
866         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
867     }
868 
869     /**
870      * @dev Returns whether `tokenId` exists.
871      *
872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
873      *
874      * Tokens start existing when they are minted (`_mint`),
875      */
876     function _exists(uint256 tokenId) internal view returns (bool) {
877         return tokenId < _currentIndex;
878     }
879 
880     function _safeMint(address to, uint256 quantity) internal {
881         _safeMint(to, quantity, '');
882     }
883 
884     /**
885      * @dev Safely mints `quantity` tokens and transfers them to `to`.
886      *
887      * Requirements:
888      *
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
890      * - `quantity` must be greater than 0.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _safeMint(
895         address to,
896         uint256 quantity,
897         bytes memory _data
898     ) internal {
899         _mint(to, quantity, _data, true);
900     }
901 
902     /**
903      * @dev Mints `quantity` tokens and transfers them to `to`.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `quantity` must be greater than 0.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _mint(
913         address to,
914         uint256 quantity,
915         bytes memory _data,
916         bool safe
917     ) internal {
918         uint256 startTokenId = _currentIndex;
919         if (to == address(0)) revert MintToZeroAddress();
920         if (quantity == 0) revert MintZeroQuantity();
921 
922         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
923 
924         // Overflows are incredibly unrealistic.
925         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
926         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
927         unchecked {
928             _addressData[to].balance += uint128(quantity);
929             _addressData[to].numberMinted += uint128(quantity);
930 
931             _ownerships[startTokenId].addr = to;
932             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
933 
934             uint256 updatedIndex = startTokenId;
935 
936             for (uint256 i; i < quantity; i++) {
937                 emit Transfer(address(0), to, updatedIndex);
938                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
939                     revert TransferToNonERC721ReceiverImplementer();
940                 }
941 
942                 updatedIndex++;
943             }
944 
945             _currentIndex = updatedIndex;
946         }
947 
948         _afterTokenTransfers(address(0), to, startTokenId, quantity);
949     }
950 
951     /**
952      * @dev Transfers `tokenId` from `from` to `to`.
953      *
954      * Requirements:
955      *
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must be owned by `from`.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _transfer(
962         address from,
963         address to,
964         uint256 tokenId
965     ) private {
966         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
967 
968         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
969             getApproved(tokenId) == _msgSender() ||
970             isApprovedForAll(prevOwnership.addr, _msgSender()));
971 
972         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
973         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
974         if (to == address(0)) revert TransferToZeroAddress();
975 
976         _beforeTokenTransfers(from, to, tokenId, 1);
977 
978         // Clear approvals from the previous owner
979         _approve(address(0), tokenId, prevOwnership.addr);
980 
981         // Underflow of the sender's balance is impossible because we check for
982         // ownership above and the recipient's balance can't realistically overflow.
983         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
984         unchecked {
985             _addressData[from].balance -= 1;
986             _addressData[to].balance += 1;
987 
988             _ownerships[tokenId].addr = to;
989             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
990 
991             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
992             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
993             uint256 nextTokenId = tokenId + 1;
994             if (_ownerships[nextTokenId].addr == address(0)) {
995                 if (_exists(nextTokenId)) {
996                     _ownerships[nextTokenId].addr = prevOwnership.addr;
997                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
998                 }
999             }
1000         }
1001 
1002         emit Transfer(from, to, tokenId);
1003         _afterTokenTransfers(from, to, tokenId, 1);
1004     }
1005 
1006     /**
1007      * @dev Approve `to` to operate on `tokenId`
1008      *
1009      * Emits a {Approval} event.
1010      */
1011     function _approve(
1012         address to,
1013         uint256 tokenId,
1014         address owner
1015     ) private {
1016         _tokenApprovals[tokenId] = to;
1017         emit Approval(owner, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1022      * The call is not executed if the target address is not a contract.
1023      *
1024      * @param from address representing the previous owner of the given token ID
1025      * @param to target address that will receive the tokens
1026      * @param tokenId uint256 ID of the token to be transferred
1027      * @param _data bytes optional data to send along with the call
1028      * @return bool whether the call correctly returned the expected magic value
1029      */
1030     function _checkOnERC721Received(
1031         address from,
1032         address to,
1033         uint256 tokenId,
1034         bytes memory _data
1035     ) private returns (bool) {
1036         if (to.isContract()) {
1037             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1038                 return retval == IERC721Receiver(to).onERC721Received.selector;
1039             } catch (bytes memory reason) {
1040                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1041                 else {
1042                     assembly {
1043                         revert(add(32, reason), mload(reason))
1044                     }
1045                 }
1046             }
1047         } else {
1048             return true;
1049         }
1050     }
1051 
1052     /**
1053      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1054      *
1055      * startTokenId - the first token id to be transferred
1056      * quantity - the amount to be transferred
1057      *
1058      * Calling conditions:
1059      *
1060      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1061      * transferred to `to`.
1062      * - When `from` is zero, `tokenId` will be minted for `to`.
1063      */
1064     function _beforeTokenTransfers(
1065         address from,
1066         address to,
1067         uint256 startTokenId,
1068         uint256 quantity
1069     ) internal virtual {}
1070 
1071     /**
1072      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1073      * minting.
1074      *
1075      * startTokenId - the first token id to be transferred
1076      * quantity - the amount to be transferred
1077      *
1078      * Calling conditions:
1079      *
1080      * - when `from` and `to` are both non-zero.
1081      * - `from` and `to` are never both zero.
1082      */
1083     function _afterTokenTransfers(
1084         address from,
1085         address to,
1086         uint256 startTokenId,
1087         uint256 quantity
1088     ) internal virtual {}
1089 }
1090 
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 
1095 /**
1096  * @dev Contract module which provides a basic access control mechanism, where
1097  * there is an account (an owner) that can be granted exclusive access to
1098  * specific functions.
1099  *
1100  * By default, the owner account will be the one that deploys the contract. This
1101  * can later be changed with {transferOwnership}.
1102  *
1103  * This module is used through inheritance. It will make available the modifier
1104  * `onlyOwner`, which can be applied to your functions to restrict their use to
1105  * the owner.
1106  */
1107 abstract contract Ownable is Context {
1108     address private _owner;
1109 
1110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1111 
1112     /**
1113      * @dev Initializes the contract setting the deployer as the initial owner.
1114      */
1115     constructor() {
1116         _setOwner(_msgSender());
1117     }
1118 
1119     /**
1120      * @dev Returns the address of the current owner.
1121      */
1122     function owner() public view virtual returns (address) {
1123         return _owner;
1124     }
1125 
1126     /**
1127      * @dev Throws if called by any account other than the owner.
1128      */
1129     modifier onlyOwner() {
1130         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1131         _;
1132     }
1133 
1134     /**
1135      * @dev Leaves the contract without owner. It will not be possible to call
1136      * `onlyOwner` functions anymore. Can only be called by the current owner.
1137      *
1138      * NOTE: Renouncing ownership will leave the contract without an owner,
1139      * thereby removing any functionality that is only available to the owner.
1140      */
1141     function renounceOwnership() public virtual onlyOwner {
1142         _setOwner(address(0));
1143     }
1144 
1145     /**
1146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1147      * Can only be called by the current owner.
1148      */
1149     function transferOwnership(address newOwner) public virtual onlyOwner {
1150         require(newOwner != address(0), "Ownable: new owner is the zero address");
1151         _setOwner(newOwner);
1152     }
1153 
1154     function _setOwner(address newOwner) private {
1155         address oldOwner = _owner;
1156         _owner = newOwner;
1157         emit OwnershipTransferred(oldOwner, newOwner);
1158     }
1159 }
1160 
1161 
1162 pragma solidity ^0.8.0;
1163 
1164 contract rugimalsPFP is Ownable, ERC721A {
1165 
1166     // OG List :: previous supporters, get NFTs for free (gas only)
1167     // Whitelist :: marketed supporters, get sales price and advanced purchase
1168     // Public sale :: regular price, till they all sell
1169 
1170     uint public max_supply = 1350;
1171 
1172     uint public public_max = 3;
1173 
1174     uint public public_price = 0.0 ether;
1175 
1176     bool public public_sale_status = true;
1177 
1178     uint public total_supply = 0;
1179 
1180     string public baseURI = "ipfs://QmcJ3UPkuhknkL8rswdtw25osqGeP12vHUUSEJFBRTWYwQ/";
1181 
1182     constructor() ERC721A("Rugimals PFP", "RPFP"){}
1183 
1184     function buy(uint _count) public payable {
1185       require(public_sale_status == true, "Sale is paused.");
1186       require(_count > 0, "Mint at least one token.");
1187       require(_count <= public_max, "You have selected too many to mint (max 20).");
1188       require(total_supply + _count <= max_supply, "Not enough tokens available.");
1189       require(msg.value >= public_price * _count, "Incorrect ETH amount.");
1190 
1191       _safeMint(msg.sender, _count);
1192       total_supply += _count;
1193     }
1194 
1195     function is_public_active() public view returns(uint){
1196       require(public_sale_status == true, "Public sale not active.");
1197       return 1;
1198     }
1199 
1200     // onlyOwner
1201 
1202     function buy_rey(uint _count) public onlyOwner {
1203       require(_count > 0, "Mint at least one token.");
1204       require(total_supply + _count<= max_supply, "Not enough tokens available.");
1205 
1206       _safeMint(msg.sender, _count);
1207       total_supply += _count;
1208     }
1209 
1210     function public_status(bool enable) external onlyOwner {
1211       public_sale_status = enable;
1212     }
1213 
1214     function update_public_price(uint price) external onlyOwner {
1215       public_price = price;
1216     }
1217     function update_public_max(uint total) external onlyOwner {
1218       public_max = total;
1219     }
1220     function update_max_supply(uint total) external onlyOwner {
1221       max_supply = total;
1222     }
1223 
1224     function _baseURI() internal view virtual override returns (string memory) {
1225       return baseURI;
1226     }
1227     function setBaseUri(string memory _uri) external onlyOwner {
1228       baseURI = _uri;
1229     }
1230 
1231     function getMintedAmount() public view returns (uint256) {
1232       return total_supply;
1233     }
1234 
1235     function withdraw() external onlyOwner {
1236       uint _balance = address(this).balance;
1237       payable(0xe3a426413Caafd88d94e6D593ce8ba8eC119C389).transfer(_balance); // project wallet
1238     }
1239 
1240 }