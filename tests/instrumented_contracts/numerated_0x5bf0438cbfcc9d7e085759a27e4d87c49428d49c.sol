1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @title ERC721 token receiver interface
185  * @dev Interface for any contract that wants to support safeTransfers
186  * from ERC721 asset contracts.
187  */
188 interface IERC721Receiver {
189     /**
190      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
191      * by `operator` from `from`, this function is called.
192      *
193      * It must return its Solidity selector to confirm the token transfer.
194      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
195      *
196      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
197      */
198     function onERC721Received(
199         address operator,
200         address from,
201         uint256 tokenId,
202         bytes calldata data
203     ) external returns (bytes4);
204 }
205 
206 
207 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 
236 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
237 
238 
239 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
240 
241 pragma solidity ^0.8.1;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      *
264      * [IMPORTANT]
265      * ====
266      * You shouldn't rely on `isContract` to protect against flash loan attacks!
267      *
268      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
269      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
270      * constructor.
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize/address.code.length, which returns 0
275         // for contracts in construction, since the code is only stored at the end
276         // of the constructor execution.
277 
278         return account.code.length > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         (bool success, ) = recipient.call{value: amount}("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain `call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
385         return functionStaticCall(target, data, "Address: low-level static call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal view returns (bytes memory) {
399         require(isContract(target), "Address: static call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.staticcall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(isContract(target), "Address: delegate call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.delegatecall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
434      * revert reason using the provided one.
435      *
436      * _Available since v4.3._
437      */
438     function verifyCallResult(
439         bool success,
440         bytes memory returndata,
441         string memory errorMessage
442     ) internal pure returns (bytes memory) {
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 
462 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Provides information about the current execution context, including the
471  * sender of the transaction and its data. While these are generally available
472  * via msg.sender and msg.data, they should not be accessed in such a direct
473  * manner, since when dealing with meta-transactions the account sending and
474  * paying for execution may not be the actual sender (as far as an application
475  * is concerned).
476  *
477  * This contract is only required for intermediate, library-like contracts.
478  */
479 abstract contract Context {
480     function _msgSender() internal view virtual returns (address) {
481         return msg.sender;
482     }
483 
484     function _msgData() internal view virtual returns (bytes calldata) {
485         return msg.data;
486     }
487 }
488 
489 
490 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev String operations.
499  */
500 library Strings {
501     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
505      */
506     function toString(uint256 value) internal pure returns (string memory) {
507         // Inspired by OraclizeAPI's implementation - MIT licence
508         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
509 
510         if (value == 0) {
511             return "0";
512         }
513         uint256 temp = value;
514         uint256 digits;
515         while (temp != 0) {
516             digits++;
517             temp /= 10;
518         }
519         bytes memory buffer = new bytes(digits);
520         while (value != 0) {
521             digits -= 1;
522             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
523             value /= 10;
524         }
525         return string(buffer);
526     }
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
530      */
531     function toHexString(uint256 value) internal pure returns (string memory) {
532         if (value == 0) {
533             return "0x00";
534         }
535         uint256 temp = value;
536         uint256 length = 0;
537         while (temp != 0) {
538             length++;
539             temp >>= 8;
540         }
541         return toHexString(value, length);
542     }
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
546      */
547     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
548         bytes memory buffer = new bytes(2 * length + 2);
549         buffer[0] = "0";
550         buffer[1] = "x";
551         for (uint256 i = 2 * length + 1; i > 1; --i) {
552             buffer[i] = _HEX_SYMBOLS[value & 0xf];
553             value >>= 4;
554         }
555         require(value == 0, "Strings: hex length insufficient");
556         return string(buffer);
557     }
558 }
559 
560 
561 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Implementation of the {IERC165} interface.
570  *
571  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
572  * for the additional interface id that will be supported. For example:
573  *
574  * ```solidity
575  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
577  * }
578  * ```
579  *
580  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
581  */
582 abstract contract ERC165 is IERC165 {
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 
592 // File erc721a/contracts/ERC721A.sol@v3.1.0
593 
594 
595 // Creator: Chiru Labs
596 
597 pragma solidity ^0.8.4;
598 
599 error ApprovalCallerNotOwnerNorApproved();
600 error ApprovalQueryForNonexistentToken();
601 error ApproveToCaller();
602 error ApprovalToCurrentOwner();
603 error BalanceQueryForZeroAddress();
604 error MintToZeroAddress();
605 error MintZeroQuantity();
606 error OwnerQueryForNonexistentToken();
607 error TransferCallerNotOwnerNorApproved();
608 error TransferFromIncorrectOwner();
609 error TransferToNonERC721ReceiverImplementer();
610 error TransferToZeroAddress();
611 error URIQueryForNonexistentToken();
612 
613 /**
614  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
615  * the Metadata extension. Built to optimize for lower gas during batch mints.
616  *
617  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
618  *
619  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
620  *
621  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
622  */
623 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
624     using Address for address;
625     using Strings for uint256;
626 
627     // Compiler will pack this into a single 256bit word.
628     struct TokenOwnership {
629         // The address of the owner.
630         address addr;
631         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
632         uint64 startTimestamp;
633         // Whether the token has been burned.
634         bool burned;
635     }
636 
637     // Compiler will pack this into a single 256bit word.
638     struct AddressData {
639         // Realistically, 2**64-1 is more than enough.
640         uint64 balance;
641         // Keeps track of mint count with minimal overhead for tokenomics.
642         uint64 numberMinted;
643         // Keeps track of burn count with minimal overhead for tokenomics.
644         uint64 numberBurned;
645         // For miscellaneous variable(s) pertaining to the address
646         // (e.g. number of whitelist mint slots used).
647         // If there are multiple variables, please pack them into a uint64.
648         uint64 aux;
649     }
650 
651     // The tokenId of the next token to be minted.
652     uint256 internal _currentIndex;
653 
654     // The number of tokens burned.
655     uint256 internal _burnCounter;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to ownership details
664     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
665     mapping(uint256 => TokenOwnership) internal _ownerships;
666 
667     // Mapping owner address to address data
668     mapping(address => AddressData) private _addressData;
669 
670     // Mapping from token ID to approved address
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     constructor(string memory name_, string memory symbol_) {
677         _name = name_;
678         _symbol = symbol_;
679         _currentIndex = _startTokenId();
680     }
681 
682     /**
683      * To change the starting tokenId, please override this function.
684      */
685     function _startTokenId() internal view virtual returns (uint256) {
686         return 0;
687     }
688 
689     /**
690      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
691      */
692     function totalSupply() public view returns (uint256) {
693         // Counter underflow is impossible as _burnCounter cannot be incremented
694         // more than _currentIndex - _startTokenId() times
695         unchecked {
696             return _currentIndex - _burnCounter - _startTokenId();
697         }
698     }
699 
700     /**
701      * Returns the total amount of tokens minted in the contract.
702      */
703     function _totalMinted() internal view returns (uint256) {
704         // Counter underflow is impossible as _currentIndex does not decrement,
705         // and it is initialized to _startTokenId()
706         unchecked {
707             return _currentIndex - _startTokenId();
708         }
709     }
710 
711     /**
712      * @dev See {IERC165-supportsInterface}.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
715         return
716             interfaceId == type(IERC721).interfaceId ||
717             interfaceId == type(IERC721Metadata).interfaceId ||
718             super.supportsInterface(interfaceId);
719     }
720 
721     /**
722      * @dev See {IERC721-balanceOf}.
723      */
724     function balanceOf(address owner) public view override returns (uint256) {
725         if (owner == address(0)) revert BalanceQueryForZeroAddress();
726         return uint256(_addressData[owner].balance);
727     }
728 
729     /**
730      * Returns the number of tokens minted by `owner`.
731      */
732     function _numberMinted(address owner) internal view returns (uint256) {
733         return uint256(_addressData[owner].numberMinted);
734     }
735 
736     /**
737      * Returns the number of tokens burned by or on behalf of `owner`.
738      */
739     function _numberBurned(address owner) internal view returns (uint256) {
740         return uint256(_addressData[owner].numberBurned);
741     }
742 
743     /**
744      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
745      */
746     function _getAux(address owner) internal view returns (uint64) {
747         return _addressData[owner].aux;
748     }
749 
750     /**
751      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
752      * If there are multiple variables, please pack them into a uint64.
753      */
754     function _setAux(address owner, uint64 aux) internal {
755         _addressData[owner].aux = aux;
756     }
757 
758     /**
759      * Gas spent here starts off proportional to the maximum mint batch size.
760      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
761      */
762     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
763         uint256 curr = tokenId;
764 
765         unchecked {
766             if (_startTokenId() <= curr && curr < _currentIndex) {
767                 TokenOwnership memory ownership = _ownerships[curr];
768                 if (!ownership.burned) {
769                     if (ownership.addr != address(0)) {
770                         return ownership;
771                     }
772                     // Invariant:
773                     // There will always be an ownership that has an address and is not burned
774                     // before an ownership that does not have an address and is not burned.
775                     // Hence, curr will not underflow.
776                     while (true) {
777                         curr--;
778                         ownership = _ownerships[curr];
779                         if (ownership.addr != address(0)) {
780                             return ownership;
781                         }
782                     }
783                 }
784             }
785         }
786         revert OwnerQueryForNonexistentToken();
787     }
788 
789     /**
790      * @dev See {IERC721-ownerOf}.
791      */
792     function ownerOf(uint256 tokenId) public view override returns (address) {
793         return _ownershipOf(tokenId).addr;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-name}.
798      */
799     function name() public view virtual override returns (string memory) {
800         return _name;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-symbol}.
805      */
806     function symbol() public view virtual override returns (string memory) {
807         return _symbol;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-tokenURI}.
812      */
813     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
814         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
815 
816         string memory baseURI = _baseURI();
817         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
818     }
819 
820     /**
821      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
822      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
823      * by default, can be overriden in child contracts.
824      */
825     function _baseURI() internal view virtual returns (string memory) {
826         return '';
827     }
828 
829     /**
830      * @dev See {IERC721-approve}.
831      */
832     function approve(address to, uint256 tokenId) public override {
833         address owner = ERC721A.ownerOf(tokenId);
834         if (to == owner) revert ApprovalToCurrentOwner();
835 
836         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
837             revert ApprovalCallerNotOwnerNorApproved();
838         }
839 
840         _approve(to, tokenId, owner);
841     }
842 
843     /**
844      * @dev See {IERC721-getApproved}.
845      */
846     function getApproved(uint256 tokenId) public view override returns (address) {
847         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
848 
849         return _tokenApprovals[tokenId];
850     }
851 
852     /**
853      * @dev See {IERC721-setApprovalForAll}.
854      */
855     function setApprovalForAll(address operator, bool approved) public virtual override {
856         if (operator == _msgSender()) revert ApproveToCaller();
857 
858         _operatorApprovals[_msgSender()][operator] = approved;
859         emit ApprovalForAll(_msgSender(), operator, approved);
860     }
861 
862     /**
863      * @dev See {IERC721-isApprovedForAll}.
864      */
865     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
866         return _operatorApprovals[owner][operator];
867     }
868 
869     /**
870      * @dev See {IERC721-transferFrom}.
871      */
872     function transferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public virtual override {
877         _transfer(from, to, tokenId);
878     }
879 
880     /**
881      * @dev See {IERC721-safeTransferFrom}.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) public virtual override {
888         safeTransferFrom(from, to, tokenId, '');
889     }
890 
891     /**
892      * @dev See {IERC721-safeTransferFrom}.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId,
898         bytes memory _data
899     ) public virtual override {
900         _transfer(from, to, tokenId);
901         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
902             revert TransferToNonERC721ReceiverImplementer();
903         }
904     }
905 
906     /**
907      * @dev Returns whether `tokenId` exists.
908      *
909      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
910      *
911      * Tokens start existing when they are minted (`_mint`),
912      */
913     function _exists(uint256 tokenId) internal view returns (bool) {
914         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
915             !_ownerships[tokenId].burned;
916     }
917 
918     function _safeMint(address to, uint256 quantity) internal {
919         _safeMint(to, quantity, '');
920     }
921 
922     /**
923      * @dev Safely mints `quantity` tokens and transfers them to `to`.
924      *
925      * Requirements:
926      *
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
928      * - `quantity` must be greater than 0.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _safeMint(
933         address to,
934         uint256 quantity,
935         bytes memory _data
936     ) internal {
937         _mint(to, quantity, _data, true);
938     }
939 
940     /**
941      * @dev Mints `quantity` tokens and transfers them to `to`.
942      *
943      * Requirements:
944      *
945      * - `to` cannot be the zero address.
946      * - `quantity` must be greater than 0.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _mint(
951         address to,
952         uint256 quantity,
953         bytes memory _data,
954         bool safe
955     ) internal {
956         uint256 startTokenId = _currentIndex;
957         if (to == address(0)) revert MintToZeroAddress();
958         if (quantity == 0) revert MintZeroQuantity();
959 
960         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
961 
962         // Overflows are incredibly unrealistic.
963         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
964         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
965         unchecked {
966             _addressData[to].balance += uint64(quantity);
967             _addressData[to].numberMinted += uint64(quantity);
968 
969             _ownerships[startTokenId].addr = to;
970             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
971 
972             uint256 updatedIndex = startTokenId;
973             uint256 end = updatedIndex + quantity;
974 
975             if (safe && to.isContract()) {
976                 do {
977                     emit Transfer(address(0), to, updatedIndex);
978                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
979                         revert TransferToNonERC721ReceiverImplementer();
980                     }
981                 } while (updatedIndex != end);
982                 // Reentrancy protection
983                 if (_currentIndex != startTokenId) revert();
984             } else {
985                 do {
986                     emit Transfer(address(0), to, updatedIndex++);
987                 } while (updatedIndex != end);
988             }
989             _currentIndex = updatedIndex;
990         }
991         _afterTokenTransfers(address(0), to, startTokenId, quantity);
992     }
993 
994     /**
995      * @dev Transfers `tokenId` from `from` to `to`.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must be owned by `from`.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) private {
1009         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1010 
1011         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1012 
1013         bool isApprovedOrOwner = (_msgSender() == from ||
1014             isApprovedForAll(from, _msgSender()) ||
1015             getApproved(tokenId) == _msgSender());
1016 
1017         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1018         if (to == address(0)) revert TransferToZeroAddress();
1019 
1020         _beforeTokenTransfers(from, to, tokenId, 1);
1021 
1022         // Clear approvals from the previous owner
1023         _approve(address(0), tokenId, from);
1024 
1025         // Underflow of the sender's balance is impossible because we check for
1026         // ownership above and the recipient's balance can't realistically overflow.
1027         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1028         unchecked {
1029             _addressData[from].balance -= 1;
1030             _addressData[to].balance += 1;
1031 
1032             TokenOwnership storage currSlot = _ownerships[tokenId];
1033             currSlot.addr = to;
1034             currSlot.startTimestamp = uint64(block.timestamp);
1035 
1036             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1037             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1038             uint256 nextTokenId = tokenId + 1;
1039             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1040             if (nextSlot.addr == address(0)) {
1041                 // This will suffice for checking _exists(nextTokenId),
1042                 // as a burned slot cannot contain the zero address.
1043                 if (nextTokenId != _currentIndex) {
1044                     nextSlot.addr = from;
1045                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1046                 }
1047             }
1048         }
1049 
1050         emit Transfer(from, to, tokenId);
1051         _afterTokenTransfers(from, to, tokenId, 1);
1052     }
1053 
1054     /**
1055      * @dev This is equivalent to _burn(tokenId, false)
1056      */
1057     function _burn(uint256 tokenId) internal virtual {
1058         _burn(tokenId, false);
1059     }
1060 
1061     /**
1062      * @dev Destroys `tokenId`.
1063      * The approval is cleared when the token is burned.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1072         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1073 
1074         address from = prevOwnership.addr;
1075 
1076         if (approvalCheck) {
1077             bool isApprovedOrOwner = (_msgSender() == from ||
1078                 isApprovedForAll(from, _msgSender()) ||
1079                 getApproved(tokenId) == _msgSender());
1080 
1081             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1082         }
1083 
1084         _beforeTokenTransfers(from, address(0), tokenId, 1);
1085 
1086         // Clear approvals from the previous owner
1087         _approve(address(0), tokenId, from);
1088 
1089         // Underflow of the sender's balance is impossible because we check for
1090         // ownership above and the recipient's balance can't realistically overflow.
1091         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1092         unchecked {
1093             AddressData storage addressData = _addressData[from];
1094             addressData.balance -= 1;
1095             addressData.numberBurned += 1;
1096 
1097             // Keep track of who burned the token, and the timestamp of burning.
1098             TokenOwnership storage currSlot = _ownerships[tokenId];
1099             currSlot.addr = from;
1100             currSlot.startTimestamp = uint64(block.timestamp);
1101             currSlot.burned = true;
1102 
1103             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1104             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1105             uint256 nextTokenId = tokenId + 1;
1106             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1107             if (nextSlot.addr == address(0)) {
1108                 // This will suffice for checking _exists(nextTokenId),
1109                 // as a burned slot cannot contain the zero address.
1110                 if (nextTokenId != _currentIndex) {
1111                     nextSlot.addr = from;
1112                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1113                 }
1114             }
1115         }
1116 
1117         emit Transfer(from, address(0), tokenId);
1118         _afterTokenTransfers(from, address(0), tokenId, 1);
1119 
1120         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1121         unchecked {
1122             _burnCounter++;
1123         }
1124     }
1125 
1126     /**
1127      * @dev Approve `to` to operate on `tokenId`
1128      *
1129      * Emits a {Approval} event.
1130      */
1131     function _approve(
1132         address to,
1133         uint256 tokenId,
1134         address owner
1135     ) private {
1136         _tokenApprovals[tokenId] = to;
1137         emit Approval(owner, to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1142      *
1143      * @param from address representing the previous owner of the given token ID
1144      * @param to target address that will receive the tokens
1145      * @param tokenId uint256 ID of the token to be transferred
1146      * @param _data bytes optional data to send along with the call
1147      * @return bool whether the call correctly returned the expected magic value
1148      */
1149     function _checkContractOnERC721Received(
1150         address from,
1151         address to,
1152         uint256 tokenId,
1153         bytes memory _data
1154     ) private returns (bool) {
1155         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1156             return retval == IERC721Receiver(to).onERC721Received.selector;
1157         } catch (bytes memory reason) {
1158             if (reason.length == 0) {
1159                 revert TransferToNonERC721ReceiverImplementer();
1160             } else {
1161                 assembly {
1162                     revert(add(32, reason), mload(reason))
1163                 }
1164             }
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1170      * And also called before burning one token.
1171      *
1172      * startTokenId - the first token id to be transferred
1173      * quantity - the amount to be transferred
1174      *
1175      * Calling conditions:
1176      *
1177      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1178      * transferred to `to`.
1179      * - When `from` is zero, `tokenId` will be minted for `to`.
1180      * - When `to` is zero, `tokenId` will be burned by `from`.
1181      * - `from` and `to` are never both zero.
1182      */
1183     function _beforeTokenTransfers(
1184         address from,
1185         address to,
1186         uint256 startTokenId,
1187         uint256 quantity
1188     ) internal virtual {}
1189 
1190     /**
1191      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1192      * minting.
1193      * And also called after one token has been burned.
1194      *
1195      * startTokenId - the first token id to be transferred
1196      * quantity - the amount to be transferred
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` has been minted for `to`.
1203      * - When `to` is zero, `tokenId` has been burned by `from`.
1204      * - `from` and `to` are never both zero.
1205      */
1206     function _afterTokenTransfers(
1207         address from,
1208         address to,
1209         uint256 startTokenId,
1210         uint256 quantity
1211     ) internal virtual {}
1212 }
1213 
1214 
1215 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1216 
1217 
1218 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 /**
1223  * @dev Contract module which provides a basic access control mechanism, where
1224  * there is an account (an owner) that can be granted exclusive access to
1225  * specific functions.
1226  *
1227  * By default, the owner account will be the one that deploys the contract. This
1228  * can later be changed with {transferOwnership}.
1229  *
1230  * This module is used through inheritance. It will make available the modifier
1231  * `onlyOwner`, which can be applied to your functions to restrict their use to
1232  * the owner.
1233  */
1234 abstract contract Ownable is Context {
1235     address private _owner;
1236 
1237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1238 
1239     /**
1240      * @dev Initializes the contract setting the deployer as the initial owner.
1241      */
1242     constructor() {
1243         _transferOwnership(_msgSender());
1244     }
1245 
1246     /**
1247      * @dev Returns the address of the current owner.
1248      */
1249     function owner() public view virtual returns (address) {
1250         return _owner;
1251     }
1252 
1253     /**
1254      * @dev Throws if called by any account other than the owner.
1255      */
1256     modifier onlyOwner() {
1257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1258         _;
1259     }
1260 
1261     /**
1262      * @dev Leaves the contract without owner. It will not be possible to call
1263      * `onlyOwner` functions anymore. Can only be called by the current owner.
1264      *
1265      * NOTE: Renouncing ownership will leave the contract without an owner,
1266      * thereby removing any functionality that is only available to the owner.
1267      */
1268     function renounceOwnership() public virtual onlyOwner {
1269         _transferOwnership(address(0));
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Can only be called by the current owner.
1275      */
1276     function transferOwnership(address newOwner) public virtual onlyOwner {
1277         require(newOwner != address(0), "Ownable: new owner is the zero address");
1278         _transferOwnership(newOwner);
1279     }
1280 
1281     /**
1282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1283      * Internal function without access restriction.
1284      */
1285     function _transferOwnership(address newOwner) internal virtual {
1286         address oldOwner = _owner;
1287         _owner = newOwner;
1288         emit OwnershipTransferred(oldOwner, newOwner);
1289     }
1290 }
1291 
1292 
1293 // File @openzeppelin/contracts/interfaces/IERC165.sol@v4.5.0
1294 
1295 
1296 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 
1301 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.5.0
1302 
1303 
1304 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1305 
1306 pragma solidity ^0.8.0;
1307 
1308 /**
1309  * @dev Interface for the NFT Royalty Standard.
1310  *
1311  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1312  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1313  *
1314  * _Available since v4.5._
1315  */
1316 interface IERC2981 is IERC165 {
1317     /**
1318      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1319      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1320      */
1321     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1322         external
1323         view
1324         returns (address receiver, uint256 royaltyAmount);
1325 }
1326 
1327 
1328 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.5.0
1329 
1330 
1331 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 
1336 /**
1337  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1338  *
1339  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1340  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1341  *
1342  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1343  * fee is specified in basis points by default.
1344  *
1345  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1346  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1347  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1348  *
1349  * _Available since v4.5._
1350  */
1351 abstract contract ERC2981 is IERC2981, ERC165 {
1352     struct RoyaltyInfo {
1353         address receiver;
1354         uint96 royaltyFraction;
1355     }
1356 
1357     RoyaltyInfo private _defaultRoyaltyInfo;
1358     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1359 
1360     /**
1361      * @dev See {IERC165-supportsInterface}.
1362      */
1363     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1364         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1365     }
1366 
1367     /**
1368      * @inheritdoc IERC2981
1369      */
1370     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1371         external
1372         view
1373         virtual
1374         override
1375         returns (address, uint256)
1376     {
1377         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1378 
1379         if (royalty.receiver == address(0)) {
1380             royalty = _defaultRoyaltyInfo;
1381         }
1382 
1383         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1384 
1385         return (royalty.receiver, royaltyAmount);
1386     }
1387 
1388     /**
1389      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1390      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1391      * override.
1392      */
1393     function _feeDenominator() internal pure virtual returns (uint96) {
1394         return 10000;
1395     }
1396 
1397     /**
1398      * @dev Sets the royalty information that all ids in this contract will default to.
1399      *
1400      * Requirements:
1401      *
1402      * - `receiver` cannot be the zero address.
1403      * - `feeNumerator` cannot be greater than the fee denominator.
1404      */
1405     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1406         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1407         require(receiver != address(0), "ERC2981: invalid receiver");
1408 
1409         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1410     }
1411 
1412     /**
1413      * @dev Removes default royalty information.
1414      */
1415     function _deleteDefaultRoyalty() internal virtual {
1416         delete _defaultRoyaltyInfo;
1417     }
1418 
1419     /**
1420      * @dev Sets the royalty information for a specific token id, overriding the global default.
1421      *
1422      * Requirements:
1423      *
1424      * - `tokenId` must be already minted.
1425      * - `receiver` cannot be the zero address.
1426      * - `feeNumerator` cannot be greater than the fee denominator.
1427      */
1428     function _setTokenRoyalty(
1429         uint256 tokenId,
1430         address receiver,
1431         uint96 feeNumerator
1432     ) internal virtual {
1433         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1434         require(receiver != address(0), "ERC2981: Invalid parameters");
1435 
1436         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1437     }
1438 
1439     /**
1440      * @dev Resets royalty information for the token id back to the global default.
1441      */
1442     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1443         delete _tokenRoyaltyInfo[tokenId];
1444     }
1445 }
1446 
1447 /******************************************************************************
1448     Smart contract generated on https://bueno.art
1449 
1450     Bueno is a suite of tools that allow artists to create generative art, 
1451     deploy smart contracts, and more -- all with no code.
1452 
1453     Bueno is not associated or affiliated with this project.
1454     Bueno is not liable for any bugs or minting issues associated with this contract.
1455 /******************************************************************************/
1456 
1457 pragma solidity ^0.8.7;
1458 
1459 error SaleInactive();
1460 error SoldOut();
1461 error InvalidPrice();
1462 error WithdrawFailed();
1463 error InvalidQuantity();
1464 
1465 contract Goblins is ERC721A, Ownable, ERC2981 {
1466     uint256 public price = 0.00666 ether;
1467     uint256 public maxPerWallet = 2;
1468     
1469 
1470     uint256 public immutable supply = 666;
1471 
1472     enum SaleState {
1473         CLOSED,
1474         OPEN
1475     }
1476 
1477     SaleState public saleState = SaleState.CLOSED;
1478 
1479     string public _baseTokenURI;
1480 
1481     mapping(address => uint256) public addressMintBalance;
1482 
1483     address[] public withdrawAddresses = [0x985AFcA097414E5510c2C4faEbDb287E4F237A1B, 0x59D382d17F0f56aA1Aba43B20A7Da00Ae14F2327];
1484     uint256[] public withdrawPercentages = [5, 95];
1485 
1486     constructor(
1487         string memory _name,
1488         string memory _symbol,
1489         string memory _baseUri,
1490         uint96 _royaltyAmount
1491     ) ERC721A(_name, _symbol) {
1492         _baseTokenURI = _baseUri;
1493         _setDefaultRoyalty(0x59D382d17F0f56aA1Aba43B20A7Da00Ae14F2327, _royaltyAmount);
1494     }
1495 
1496     function mint(uint256 qty) external payable {
1497         if (saleState != SaleState.OPEN) revert SaleInactive();
1498         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1499         if (msg.value != price * qty) revert InvalidPrice();
1500 
1501         if (addressMintBalance[msg.sender] + qty > maxPerWallet) revert InvalidQuantity();
1502         
1503         addressMintBalance[msg.sender] += qty;
1504 
1505         _safeMint(msg.sender, qty);
1506 
1507     }
1508 
1509     function _startTokenId() internal view virtual override returns (uint256) {
1510         return 1;
1511     }
1512 
1513     function _baseURI() internal view virtual override returns (string memory) {
1514         return _baseTokenURI;
1515     }
1516 
1517     
1518 
1519     function setBaseURI(string memory baseURI) external onlyOwner {
1520         _baseTokenURI = baseURI;
1521     }
1522 
1523     function setPrice(uint256 newPrice) external onlyOwner {
1524         price = newPrice;
1525     }
1526 
1527     function setSaleState(uint8 _state) external onlyOwner {
1528         saleState = SaleState(_state);
1529     }
1530 
1531     function freeMint(uint256 qty, address recipient) external onlyOwner {
1532         if (_currentIndex + (qty - 1) > supply) revert SoldOut();
1533         _safeMint(recipient, qty);
1534     }
1535 
1536     function setPerWalletMax(uint256 _val) external onlyOwner {
1537         maxPerWallet = _val;
1538     }
1539 
1540     
1541 
1542     function _withdraw(address _address, uint256 _amount) private {
1543         (bool success, ) = _address.call{value: _amount}("");
1544         if (!success) revert WithdrawFailed();
1545     }
1546 
1547     function withdraw() external onlyOwner {
1548         uint256 balance = address(this).balance;
1549 
1550         for (uint256 i; i < withdrawAddresses.length; i++) {
1551             _withdraw(withdrawAddresses[i], (balance * withdrawPercentages[i]) / 100);
1552         }
1553     }
1554 
1555     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
1556         external
1557         onlyOwner
1558     {
1559         _setDefaultRoyalty(receiver, feeBasisPoints);
1560     }
1561 
1562     function supportsInterface(bytes4 interfaceId)
1563         public
1564         view
1565         override(ERC721A, ERC2981)
1566         returns (bool)
1567     {
1568         return super.supportsInterface(interfaceId);
1569     }
1570 }