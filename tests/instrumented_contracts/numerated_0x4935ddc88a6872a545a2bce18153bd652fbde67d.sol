1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.9.0 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
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
236 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
237 
238 
239 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
245  * @dev See https://eips.ethereum.org/EIPS/eip-721
246  */
247 interface IERC721Enumerable is IERC721 {
248     /**
249      * @dev Returns the total amount of tokens stored by the contract.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
255      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
256      */
257     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
258 
259     /**
260      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
261      * Use along with {totalSupply} to enumerate all tokens.
262      */
263     function tokenByIndex(uint256 index) external view returns (uint256);
264 }
265 
266 
267 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
268 
269 
270 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
271 
272 pragma solidity ^0.8.1;
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      *
295      * [IMPORTANT]
296      * ====
297      * You shouldn't rely on `isContract` to protect against flash loan attacks!
298      *
299      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
300      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
301      * constructor.
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies on extcodesize/address.code.length, which returns 0
306         // for contracts in construction, since the code is only stored at the end
307         // of the constructor execution.
308 
309         return account.code.length > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         (bool success, ) = recipient.call{value: amount}("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain `call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         require(isContract(target), "Address: call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.call{value: value}(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
416         return functionStaticCall(target, data, "Address: low-level static call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal view returns (bytes memory) {
430         require(isContract(target), "Address: static call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.staticcall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(isContract(target), "Address: delegate call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
465      * revert reason using the provided one.
466      *
467      * _Available since v4.3._
468      */
469     function verifyCallResult(
470         bool success,
471         bytes memory returndata,
472         string memory errorMessage
473     ) internal pure returns (bytes memory) {
474         if (success) {
475             return returndata;
476         } else {
477             // Look for revert reason and bubble it up if present
478             if (returndata.length > 0) {
479                 // The easiest way to bubble the revert reason is using memory via assembly
480 
481                 assembly {
482                     let returndata_size := mload(returndata)
483                     revert(add(32, returndata), returndata_size)
484                 }
485             } else {
486                 revert(errorMessage);
487             }
488         }
489     }
490 }
491 
492 
493 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Provides information about the current execution context, including the
502  * sender of the transaction and its data. While these are generally available
503  * via msg.sender and msg.data, they should not be accessed in such a direct
504  * manner, since when dealing with meta-transactions the account sending and
505  * paying for execution may not be the actual sender (as far as an application
506  * is concerned).
507  *
508  * This contract is only required for intermediate, library-like contracts.
509  */
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 
521 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev String operations.
530  */
531 library Strings {
532     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
536      */
537     function toString(uint256 value) internal pure returns (string memory) {
538         // Inspired by OraclizeAPI's implementation - MIT licence
539         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
540 
541         if (value == 0) {
542             return "0";
543         }
544         uint256 temp = value;
545         uint256 digits;
546         while (temp != 0) {
547             digits++;
548             temp /= 10;
549         }
550         bytes memory buffer = new bytes(digits);
551         while (value != 0) {
552             digits -= 1;
553             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
554             value /= 10;
555         }
556         return string(buffer);
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
561      */
562     function toHexString(uint256 value) internal pure returns (string memory) {
563         if (value == 0) {
564             return "0x00";
565         }
566         uint256 temp = value;
567         uint256 length = 0;
568         while (temp != 0) {
569             length++;
570             temp >>= 8;
571         }
572         return toHexString(value, length);
573     }
574 
575     /**
576      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
577      */
578     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
579         bytes memory buffer = new bytes(2 * length + 2);
580         buffer[0] = "0";
581         buffer[1] = "x";
582         for (uint256 i = 2 * length + 1; i > 1; --i) {
583             buffer[i] = _HEX_SYMBOLS[value & 0xf];
584             value >>= 4;
585         }
586         require(value == 0, "Strings: hex length insufficient");
587         return string(buffer);
588     }
589 }
590 
591 
592 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Implementation of the {IERC165} interface.
601  *
602  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
603  * for the additional interface id that will be supported. For example:
604  *
605  * ```solidity
606  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
607  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
608  * }
609  * ```
610  *
611  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
612  */
613 abstract contract ERC165 is IERC165 {
614     /**
615      * @dev See {IERC165-supportsInterface}.
616      */
617     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618         return interfaceId == type(IERC165).interfaceId;
619     }
620 }
621 
622 
623 // File erc721a/contracts/ERC721A.sol@v3.0.0
624 
625 
626 // Creator: Chiru Labs
627 
628 pragma solidity ^0.8.4;
629 
630 
631 
632 
633 
634 
635 
636 
637 error ApprovalCallerNotOwnerNorApproved();
638 error ApprovalQueryForNonexistentToken();
639 error ApproveToCaller();
640 error ApprovalToCurrentOwner();
641 error BalanceQueryForZeroAddress();
642 error MintedQueryForZeroAddress();
643 error BurnedQueryForZeroAddress();
644 error AuxQueryForZeroAddress();
645 error MintToZeroAddress();
646 error MintZeroQuantity();
647 error OwnerIndexOutOfBounds();
648 error OwnerQueryForNonexistentToken();
649 error TokenIndexOutOfBounds();
650 error TransferCallerNotOwnerNorApproved();
651 error TransferFromIncorrectOwner();
652 error TransferToNonERC721ReceiverImplementer();
653 error TransferToZeroAddress();
654 error URIQueryForNonexistentToken();
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension. Built to optimize for lower gas during batch mints.
659  *
660  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
661  *
662  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
663  *
664  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
665  */
666 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Compiler will pack this into a single 256bit word.
671     struct TokenOwnership {
672         // The address of the owner.
673         address addr;
674         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
675         uint64 startTimestamp;
676         // Whether the token has been burned.
677         bool burned;
678     }
679 
680     // Compiler will pack this into a single 256bit word.
681     struct AddressData {
682         // Realistically, 2**64-1 is more than enough.
683         uint64 balance;
684         // Keeps track of mint count with minimal overhead for tokenomics.
685         uint64 numberMinted;
686         // Keeps track of burn count with minimal overhead for tokenomics.
687         uint64 numberBurned;
688         // For miscellaneous variable(s) pertaining to the address
689         // (e.g. number of whitelist mint slots used).
690         // If there are multiple variables, please pack them into a uint64.
691         uint64 aux;
692     }
693 
694     // The tokenId of the next token to be minted.
695     uint256 internal _currentIndex;
696 
697     // The number of tokens burned.
698     uint256 internal _burnCounter;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to ownership details
707     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
708     mapping(uint256 => TokenOwnership) internal _ownerships;
709 
710     // Mapping owner address to address data
711     mapping(address => AddressData) private _addressData;
712 
713     // Mapping from token ID to approved address
714     mapping(uint256 => address) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722         _currentIndex = _startTokenId();
723     }
724 
725     /**
726      * To change the starting tokenId, please override this function.
727      */
728     function _startTokenId() internal view virtual returns (uint256) {
729         return 0;
730     }
731 
732     /**
733      * @dev See {IERC721Enumerable-totalSupply}.
734      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
735      */
736     function totalSupply() public view returns (uint256) {
737         // Counter underflow is impossible as _burnCounter cannot be incremented
738         // more than _currentIndex - _startTokenId() times
739         unchecked {
740             return _currentIndex - _burnCounter - _startTokenId();
741         }
742     }
743 
744     /**
745      * Returns the total amount of tokens minted in the contract.
746      */
747     function _totalMinted() internal view returns (uint256) {
748         // Counter underflow is impossible as _currentIndex does not decrement,
749         // and it is initialized to _startTokenId()
750         unchecked {
751             return _currentIndex - _startTokenId();
752         }
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
759         return
760             interfaceId == type(IERC721).interfaceId ||
761             interfaceId == type(IERC721Metadata).interfaceId ||
762             super.supportsInterface(interfaceId);
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view override returns (uint256) {
769         if (owner == address(0)) revert BalanceQueryForZeroAddress();
770         return uint256(_addressData[owner].balance);
771     }
772 
773     /**
774      * Returns the number of tokens minted by `owner`.
775      */
776     function _numberMinted(address owner) internal view returns (uint256) {
777         if (owner == address(0)) revert MintedQueryForZeroAddress();
778         return uint256(_addressData[owner].numberMinted);
779     }
780 
781     /**
782      * Returns the number of tokens burned by or on behalf of `owner`.
783      */
784     function _numberBurned(address owner) internal view returns (uint256) {
785         if (owner == address(0)) revert BurnedQueryForZeroAddress();
786         return uint256(_addressData[owner].numberBurned);
787     }
788 
789     /**
790      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
791      */
792     function _getAux(address owner) internal view returns (uint64) {
793         if (owner == address(0)) revert AuxQueryForZeroAddress();
794         return _addressData[owner].aux;
795     }
796 
797     /**
798      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
799      * If there are multiple variables, please pack them into a uint64.
800      */
801     function _setAux(address owner, uint64 aux) internal {
802         if (owner == address(0)) revert AuxQueryForZeroAddress();
803         _addressData[owner].aux = aux;
804     }
805 
806     /**
807      * Gas spent here starts off proportional to the maximum mint batch size.
808      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
809      */
810     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
811         uint256 curr = tokenId;
812 
813         unchecked {
814             if (_startTokenId() <= curr && curr < _currentIndex) {
815                 TokenOwnership memory ownership = _ownerships[curr];
816                 if (!ownership.burned) {
817                     if (ownership.addr != address(0)) {
818                         return ownership;
819                     }
820                     // Invariant:
821                     // There will always be an ownership that has an address and is not burned
822                     // before an ownership that does not have an address and is not burned.
823                     // Hence, curr will not underflow.
824                     while (true) {
825                         curr--;
826                         ownership = _ownerships[curr];
827                         if (ownership.addr != address(0)) {
828                             return ownership;
829                         }
830                     }
831                 }
832             }
833         }
834         revert OwnerQueryForNonexistentToken();
835     }
836 
837     /**
838      * @dev See {IERC721-ownerOf}.
839      */
840     function ownerOf(uint256 tokenId) public view override returns (address) {
841         return ownershipOf(tokenId).addr;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-name}.
846      */
847     function name() public view virtual override returns (string memory) {
848         return _name;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-symbol}.
853      */
854     function symbol() public view virtual override returns (string memory) {
855         return _symbol;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-tokenURI}.
860      */
861     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
862         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
863 
864         string memory baseURI = _baseURI();
865         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
866     }
867 
868     /**
869      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
870      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
871      * by default, can be overriden in child contracts.
872      */
873     function _baseURI() internal view virtual returns (string memory) {
874         return '';
875     }
876 
877     /**
878      * @dev See {IERC721-approve}.
879      */
880     function approve(address to, uint256 tokenId) public override {
881         address owner = ERC721A.ownerOf(tokenId);
882         if (to == owner) revert ApprovalToCurrentOwner();
883 
884         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
885             revert ApprovalCallerNotOwnerNorApproved();
886         }
887 
888         _approve(to, tokenId, owner);
889     }
890 
891     /**
892      * @dev See {IERC721-getApproved}.
893      */
894     function getApproved(uint256 tokenId) public view override returns (address) {
895         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
896 
897         return _tokenApprovals[tokenId];
898     }
899 
900     /**
901      * @dev See {IERC721-setApprovalForAll}.
902      */
903     function setApprovalForAll(address operator, bool approved) public override {
904         if (operator == _msgSender()) revert ApproveToCaller();
905 
906         _operatorApprovals[_msgSender()][operator] = approved;
907         emit ApprovalForAll(_msgSender(), operator, approved);
908     }
909 
910     /**
911      * @dev See {IERC721-isApprovedForAll}.
912      */
913     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
914         return _operatorApprovals[owner][operator];
915     }
916 
917     /**
918      * @dev See {IERC721-transferFrom}.
919      */
920     function transferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public virtual override {
925         _transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public virtual override {
936         safeTransferFrom(from, to, tokenId, '');
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public virtual override {
948         _transfer(from, to, tokenId);
949         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
950             revert TransferToNonERC721ReceiverImplementer();
951         }
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
963             !_ownerships[tokenId].burned;
964     }
965 
966     function _safeMint(address to, uint256 quantity) internal {
967         _safeMint(to, quantity, '');
968     }
969 
970     /**
971      * @dev Safely mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
976      * - `quantity` must be greater than 0.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(
981         address to,
982         uint256 quantity,
983         bytes memory _data
984     ) internal {
985         _mint(to, quantity, _data, true);
986     }
987 
988     /**
989      * @dev Mints `quantity` tokens and transfers them to `to`.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `quantity` must be greater than 0.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _mint(
999         address to,
1000         uint256 quantity,
1001         bytes memory _data,
1002         bool safe
1003     ) internal {
1004         uint256 startTokenId = _currentIndex;
1005         if (to == address(0)) revert MintToZeroAddress();
1006         if (quantity == 0) revert MintZeroQuantity();
1007 
1008         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010         // Overflows are incredibly unrealistic.
1011         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1012         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1013         unchecked {
1014             _addressData[to].balance += uint64(quantity);
1015             _addressData[to].numberMinted += uint64(quantity);
1016 
1017             _ownerships[startTokenId].addr = to;
1018             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1019 
1020             uint256 updatedIndex = startTokenId;
1021             uint256 end = updatedIndex + quantity;
1022 
1023             if (safe && to.isContract()) {
1024                 do {
1025                     emit Transfer(address(0), to, updatedIndex);
1026                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1027                         revert TransferToNonERC721ReceiverImplementer();
1028                     }
1029                 } while (updatedIndex != end);
1030                 // Reentrancy protection
1031                 if (_currentIndex != startTokenId) revert();
1032             } else {
1033                 do {
1034                     emit Transfer(address(0), to, updatedIndex++);
1035                 } while (updatedIndex != end);
1036             }
1037             _currentIndex = updatedIndex;
1038         }
1039         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1040     }
1041 
1042     /**
1043      * @dev Transfers `tokenId` from `from` to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must be owned by `from`.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _transfer(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) private {
1057         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1058 
1059         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1060             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1061             getApproved(tokenId) == _msgSender());
1062 
1063         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1064         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1065         if (to == address(0)) revert TransferToZeroAddress();
1066 
1067         _beforeTokenTransfers(from, to, tokenId, 1);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId, prevOwnership.addr);
1071 
1072         // Underflow of the sender's balance is impossible because we check for
1073         // ownership above and the recipient's balance can't realistically overflow.
1074         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1075         unchecked {
1076             _addressData[from].balance -= 1;
1077             _addressData[to].balance += 1;
1078 
1079             _ownerships[tokenId].addr = to;
1080             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1081 
1082             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1083             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1084             uint256 nextTokenId = tokenId + 1;
1085             if (_ownerships[nextTokenId].addr == address(0)) {
1086                 // This will suffice for checking _exists(nextTokenId),
1087                 // as a burned slot cannot contain the zero address.
1088                 if (nextTokenId < _currentIndex) {
1089                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1090                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1091                 }
1092             }
1093         }
1094 
1095         emit Transfer(from, to, tokenId);
1096         _afterTokenTransfers(from, to, tokenId, 1);
1097     }
1098 
1099     /**
1100      * @dev Destroys `tokenId`.
1101      * The approval is cleared when the token is burned.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _burn(uint256 tokenId) internal virtual {
1110         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1111 
1112         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1113 
1114         // Clear approvals from the previous owner
1115         _approve(address(0), tokenId, prevOwnership.addr);
1116 
1117         // Underflow of the sender's balance is impossible because we check for
1118         // ownership above and the recipient's balance can't realistically overflow.
1119         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1120         unchecked {
1121             _addressData[prevOwnership.addr].balance -= 1;
1122             _addressData[prevOwnership.addr].numberBurned += 1;
1123 
1124             // Keep track of who burned the token, and the timestamp of burning.
1125             _ownerships[tokenId].addr = prevOwnership.addr;
1126             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1127             _ownerships[tokenId].burned = true;
1128 
1129             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1130             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1131             uint256 nextTokenId = tokenId + 1;
1132             if (_ownerships[nextTokenId].addr == address(0)) {
1133                 // This will suffice for checking _exists(nextTokenId),
1134                 // as a burned slot cannot contain the zero address.
1135                 if (nextTokenId < _currentIndex) {
1136                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1137                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1138                 }
1139             }
1140         }
1141 
1142         emit Transfer(prevOwnership.addr, address(0), tokenId);
1143         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1144 
1145         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1146         unchecked {
1147             _burnCounter++;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Approve `to` to operate on `tokenId`
1153      *
1154      * Emits a {Approval} event.
1155      */
1156     function _approve(
1157         address to,
1158         uint256 tokenId,
1159         address owner
1160     ) private {
1161         _tokenApprovals[tokenId] = to;
1162         emit Approval(owner, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkContractOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181             return retval == IERC721Receiver(to).onERC721Received.selector;
1182         } catch (bytes memory reason) {
1183             if (reason.length == 0) {
1184                 revert TransferToNonERC721ReceiverImplementer();
1185             } else {
1186                 assembly {
1187                     revert(add(32, reason), mload(reason))
1188                 }
1189             }
1190         }
1191     }
1192 
1193     /**
1194      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1195      * And also called before burning one token.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, `tokenId` will be burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _beforeTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 
1215     /**
1216      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1217      * minting.
1218      * And also called after one token has been burned.
1219      *
1220      * startTokenId - the first token id to be transferred
1221      * quantity - the amount to be transferred
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` has been minted for `to`.
1228      * - When `to` is zero, `tokenId` has been burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _afterTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 }
1238 
1239 
1240 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1241 
1242 
1243 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 /**
1248  * @dev Contract module which provides a basic access control mechanism, where
1249  * there is an account (an owner) that can be granted exclusive access to
1250  * specific functions.
1251  *
1252  * By default, the owner account will be the one that deploys the contract. This
1253  * can later be changed with {transferOwnership}.
1254  *
1255  * This module is used through inheritance. It will make available the modifier
1256  * `onlyOwner`, which can be applied to your functions to restrict their use to
1257  * the owner.
1258  */
1259 abstract contract Ownable is Context {
1260     address private _owner;
1261 
1262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1263 
1264     /**
1265      * @dev Initializes the contract setting the deployer as the initial owner.
1266      */
1267     constructor() {
1268         _transferOwnership(_msgSender());
1269     }
1270 
1271     /**
1272      * @dev Returns the address of the current owner.
1273      */
1274     function owner() public view virtual returns (address) {
1275         return _owner;
1276     }
1277 
1278     /**
1279      * @dev Throws if called by any account other than the owner.
1280      */
1281     modifier onlyOwner() {
1282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Leaves the contract without owner. It will not be possible to call
1288      * `onlyOwner` functions anymore. Can only be called by the current owner.
1289      *
1290      * NOTE: Renouncing ownership will leave the contract without an owner,
1291      * thereby removing any functionality that is only available to the owner.
1292      */
1293     function renounceOwnership() public virtual onlyOwner {
1294         _transferOwnership(address(0));
1295     }
1296 
1297     /**
1298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1299      * Can only be called by the current owner.
1300      */
1301     function transferOwnership(address newOwner) public virtual onlyOwner {
1302         require(newOwner != address(0), "Ownable: new owner is the zero address");
1303         _transferOwnership(newOwner);
1304     }
1305 
1306     /**
1307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1308      * Internal function without access restriction.
1309      */
1310     function _transferOwnership(address newOwner) internal virtual {
1311         address oldOwner = _owner;
1312         _owner = newOwner;
1313         emit OwnershipTransferred(oldOwner, newOwner);
1314     }
1315 }
1316 
1317 
1318 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1319 
1320 
1321 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 /**
1326  * @dev These functions deal with verification of Merkle Trees proofs.
1327  *
1328  * The proofs can be generated using the JavaScript library
1329  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1330  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1331  *
1332  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1333  */
1334 library MerkleProof {
1335     /**
1336      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1337      * defined by `root`. For this, a `proof` must be provided, containing
1338      * sibling hashes on the branch from the leaf to the root of the tree. Each
1339      * pair of leaves and each pair of pre-images are assumed to be sorted.
1340      */
1341     function verify(
1342         bytes32[] memory proof,
1343         bytes32 root,
1344         bytes32 leaf
1345     ) internal pure returns (bool) {
1346         return processProof(proof, leaf) == root;
1347     }
1348 
1349     /**
1350      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1351      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1352      * hash matches the root of the tree. When processing the proof, the pairs
1353      * of leafs & pre-images are assumed to be sorted.
1354      *
1355      * _Available since v4.4._
1356      */
1357     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1358         bytes32 computedHash = leaf;
1359         for (uint256 i = 0; i < proof.length; i++) {
1360             bytes32 proofElement = proof[i];
1361             if (computedHash <= proofElement) {
1362                 // Hash(current computed hash + current element of the proof)
1363                 computedHash = _efficientHash(computedHash, proofElement);
1364             } else {
1365                 // Hash(current element of the proof + current computed hash)
1366                 computedHash = _efficientHash(proofElement, computedHash);
1367             }
1368         }
1369         return computedHash;
1370     }
1371 
1372     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1373         assembly {
1374             mstore(0x00, a)
1375             mstore(0x20, b)
1376             value := keccak256(0x00, 0x40)
1377         }
1378     }
1379 }
1380 
1381 
1382 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1383 
1384 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 /**
1389  * @dev Contract module that helps prevent reentrant calls to a function.
1390  *
1391  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1392  * available, which can be applied to functions to make sure there are no nested
1393  * (reentrant) calls to them.
1394  *
1395  * Note that because there is a single `nonReentrant` guard, functions marked as
1396  * `nonReentrant` may not call one another. This can be worked around by making
1397  * those functions `private`, and then adding `external` `nonReentrant` entry
1398  * points to them.
1399  *
1400  * TIP: If you would like to learn more about reentrancy and alternative ways
1401  * to protect against it, check out our blog post
1402  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1403  */
1404 abstract contract ReentrancyGuard {
1405     // Booleans are more expensive than uint256 or any type that takes up a full
1406     // word because each write operation emits an extra SLOAD to first read the
1407     // slot's contents, replace the bits taken up by the boolean, and then write
1408     // back. This is the compiler's defense against contract upgrades and
1409     // pointer aliasing, and it cannot be disabled.
1410 
1411     // The values being non-zero value makes deployment a bit more expensive,
1412     // but in exchange the refund on every call to nonReentrant will be lower in
1413     // amount. Since refunds are capped to a percentage of the total
1414     // transaction's gas, it is best to keep them low in cases like this one, to
1415     // increase the likelihood of the full refund coming into effect.
1416     uint256 private constant _NOT_ENTERED = 1;
1417     uint256 private constant _ENTERED = 2;
1418 
1419     uint256 private _status;
1420 
1421     constructor() {
1422         _status = _NOT_ENTERED;
1423     }
1424 
1425     /**
1426      * @dev Prevents a contract from calling itself, directly or indirectly.
1427      * Calling a `nonReentrant` function from another `nonReentrant`
1428      * function is not supported. It is possible to prevent this from happening
1429      * by making the `nonReentrant` function external, and making it call a
1430      * `private` function that does the actual work.
1431      */
1432     modifier nonReentrant() {
1433         // On the first call to nonReentrant, _notEntered will be true
1434         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1435 
1436         // Any calls to nonReentrant after this point will fail
1437         _status = _ENTERED;
1438 
1439         _;
1440 
1441         // By storing the original value once again, a refund is triggered (see
1442         // https://eips.ethereum.org/EIPS/eip-2200)
1443         _status = _NOT_ENTERED;
1444     }
1445 }
1446 
1447 
1448 // File contracts/BunnnyLoveYou.sol
1449 
1450 
1451 pragma solidity >=0.8.9 <0.9.0;
1452 
1453 
1454 
1455 
1456 contract BunnnyLoveYou is ERC721A, Ownable, ReentrancyGuard {
1457 
1458   using Strings for uint256;
1459 
1460   bytes32 public merkleRoot;
1461   mapping(address => bool) public whitelistClaimed;
1462 
1463   string public uriPrefix = '';
1464   string public uriSuffix = '.json';
1465   string public hiddenMetadataUri;
1466   
1467   uint256 public cost;
1468   uint256 public maxSupply;
1469   uint256 public maxMintAmountPerTx;
1470 
1471   bool public paused = true;
1472   bool public whitelistMintEnabled = false;
1473   bool public revealed = false;
1474 
1475   constructor(
1476     string memory _tokenName,
1477     string memory _tokenSymbol,
1478     uint256 _cost,
1479     uint256 _maxSupply,
1480     uint256 _maxMintAmountPerTx,
1481     string memory _hiddenMetadataUri
1482   ) ERC721A(_tokenName, _tokenSymbol) {
1483     cost = _cost;
1484     maxSupply = _maxSupply;
1485     maxMintAmountPerTx = _maxMintAmountPerTx;
1486     setHiddenMetadataUri(_hiddenMetadataUri);
1487   }
1488 
1489   modifier mintCompliance(uint256 _mintAmount) {
1490     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1491     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1492     _;
1493   }
1494 
1495   modifier mintPriceCompliance(uint256 _mintAmount) {
1496     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1497     _;
1498   }
1499 
1500   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1501     // Verify whitelist requirements
1502     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1503     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1504     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1505     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1506 
1507     whitelistClaimed[_msgSender()] = true;
1508     _safeMint(_msgSender(), _mintAmount);
1509   }
1510 
1511   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1512     require(!paused, 'The contract is paused!');
1513 
1514     _safeMint(_msgSender(), _mintAmount);
1515   }
1516   
1517   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1518     _safeMint(_receiver, _mintAmount);
1519   }
1520 
1521   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1522     uint256 ownerTokenCount = balanceOf(_owner);
1523     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1524     uint256 currentTokenId = _startTokenId();
1525     uint256 ownedTokenIndex = 0;
1526     address latestOwnerAddress;
1527 
1528     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1529       TokenOwnership memory ownership = _ownerships[currentTokenId];
1530 
1531       if (!ownership.burned && ownership.addr != address(0)) {
1532         latestOwnerAddress = ownership.addr;
1533       }
1534 
1535       if (latestOwnerAddress == _owner) {
1536         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1537 
1538         ownedTokenIndex++;
1539       }
1540 
1541       currentTokenId++;
1542     }
1543 
1544     return ownedTokenIds;
1545   }
1546 
1547   function _startTokenId() internal view virtual override returns (uint256) {
1548         return 1;
1549     }
1550 
1551   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1552     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1553 
1554     if (revealed == false) {
1555       return hiddenMetadataUri;
1556     }
1557 
1558     string memory currentBaseURI = _baseURI();
1559     return bytes(currentBaseURI).length > 0
1560         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1561         : '';
1562   }
1563 
1564   function setRevealed(bool _state) public onlyOwner {
1565     revealed = _state;
1566   }
1567 
1568   function setCost(uint256 _cost) public onlyOwner {
1569     cost = _cost;
1570   }
1571 
1572   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1573     maxMintAmountPerTx = _maxMintAmountPerTx;
1574   }
1575 
1576   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1577     hiddenMetadataUri = _hiddenMetadataUri;
1578   }
1579 
1580   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1581     uriPrefix = _uriPrefix;
1582   }
1583 
1584   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1585     uriSuffix = _uriSuffix;
1586   }
1587 
1588   function setPaused(bool _state) public onlyOwner {
1589     paused = _state;
1590   }
1591 
1592   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1593     merkleRoot = _merkleRoot;
1594   }
1595 
1596   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1597     whitelistMintEnabled = _state;
1598   }
1599 
1600   function withdraw() public onlyOwner nonReentrant {
1601     // This will transfer the remaining contract balance to the owner.
1602     // Do not remove this otherwise you will not be able to withdraw the funds.
1603     // =============================================================================
1604     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1605     require(os);
1606     // =============================================================================
1607   }
1608 
1609   function _baseURI() internal view virtual override returns (string memory) {
1610     return uriPrefix;
1611   }
1612 }