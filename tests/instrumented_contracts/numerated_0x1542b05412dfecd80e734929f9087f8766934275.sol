1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5 ╭━━━┳━━┳━━┳╮╭┳━━┳━┳━━╮
6 ┣━━┃┃╭╮┃╭╮┃╰╯┃┃━┫╭┫━━┫
7 ┃┃━━┫╰╯┃╰╯┃┃┃┃┃━┫┃┣━━┃
8 ╰━━━┻━━┻━━┻┻┻┻━━┻╯╰━━╯
9 
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
36 
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
181 
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
212 
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
241 
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
272 
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
498 
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
526 
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
597 
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
628 
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
1240 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
1241 
1242 
1243 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 
1253 /**
1254  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1255  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1256  * {ERC721Enumerable}.
1257  */
1258 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1259     using Address for address;
1260     using Strings for uint256;
1261 
1262     // Token name
1263     string private _name;
1264 
1265     // Token symbol
1266     string private _symbol;
1267 
1268     // Mapping from token ID to owner address
1269     mapping(uint256 => address) private _owners;
1270 
1271     // Mapping owner address to token count
1272     mapping(address => uint256) private _balances;
1273 
1274     // Mapping from token ID to approved address
1275     mapping(uint256 => address) private _tokenApprovals;
1276 
1277     // Mapping from owner to operator approvals
1278     mapping(address => mapping(address => bool)) private _operatorApprovals;
1279 
1280     /**
1281      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1282      */
1283     constructor(string memory name_, string memory symbol_) {
1284         _name = name_;
1285         _symbol = symbol_;
1286     }
1287 
1288     /**
1289      * @dev See {IERC165-supportsInterface}.
1290      */
1291     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1292         return
1293             interfaceId == type(IERC721).interfaceId ||
1294             interfaceId == type(IERC721Metadata).interfaceId ||
1295             super.supportsInterface(interfaceId);
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-balanceOf}.
1300      */
1301     function balanceOf(address owner) public view virtual override returns (uint256) {
1302         require(owner != address(0), "ERC721: balance query for the zero address");
1303         return _balances[owner];
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-ownerOf}.
1308      */
1309     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1310         address owner = _owners[tokenId];
1311         require(owner != address(0), "ERC721: owner query for nonexistent token");
1312         return owner;
1313     }
1314 
1315     /**
1316      * @dev See {IERC721Metadata-name}.
1317      */
1318     function name() public view virtual override returns (string memory) {
1319         return _name;
1320     }
1321 
1322     /**
1323      * @dev See {IERC721Metadata-symbol}.
1324      */
1325     function symbol() public view virtual override returns (string memory) {
1326         return _symbol;
1327     }
1328 
1329     /**
1330      * @dev See {IERC721Metadata-tokenURI}.
1331      */
1332     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1333         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1334 
1335         string memory baseURI = _baseURI();
1336         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1337     }
1338 
1339     /**
1340      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1341      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1342      * by default, can be overriden in child contracts.
1343      */
1344     function _baseURI() internal view virtual returns (string memory) {
1345         return "";
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-approve}.
1350      */
1351     function approve(address to, uint256 tokenId) public virtual override {
1352         address owner = ERC721.ownerOf(tokenId);
1353         require(to != owner, "ERC721: approval to current owner");
1354 
1355         require(
1356             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1357             "ERC721: approve caller is not owner nor approved for all"
1358         );
1359 
1360         _approve(to, tokenId);
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-getApproved}.
1365      */
1366     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1367         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1368 
1369         return _tokenApprovals[tokenId];
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-setApprovalForAll}.
1374      */
1375     function setApprovalForAll(address operator, bool approved) public virtual override {
1376         _setApprovalForAll(_msgSender(), operator, approved);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-isApprovedForAll}.
1381      */
1382     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1383         return _operatorApprovals[owner][operator];
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-transferFrom}.
1388      */
1389     function transferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         //solhint-disable-next-line max-line-length
1395         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1396 
1397         _transfer(from, to, tokenId);
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-safeTransferFrom}.
1402      */
1403     function safeTransferFrom(
1404         address from,
1405         address to,
1406         uint256 tokenId
1407     ) public virtual override {
1408         safeTransferFrom(from, to, tokenId, "");
1409     }
1410 
1411     /**
1412      * @dev See {IERC721-safeTransferFrom}.
1413      */
1414     function safeTransferFrom(
1415         address from,
1416         address to,
1417         uint256 tokenId,
1418         bytes memory _data
1419     ) public virtual override {
1420         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1421         _safeTransfer(from, to, tokenId, _data);
1422     }
1423 
1424     /**
1425      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1426      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1427      *
1428      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1429      *
1430      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1431      * implement alternative mechanisms to perform token transfer, such as signature-based.
1432      *
1433      * Requirements:
1434      *
1435      * - `from` cannot be the zero address.
1436      * - `to` cannot be the zero address.
1437      * - `tokenId` token must exist and be owned by `from`.
1438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1439      *
1440      * Emits a {Transfer} event.
1441      */
1442     function _safeTransfer(
1443         address from,
1444         address to,
1445         uint256 tokenId,
1446         bytes memory _data
1447     ) internal virtual {
1448         _transfer(from, to, tokenId);
1449         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1450     }
1451 
1452     /**
1453      * @dev Returns whether `tokenId` exists.
1454      *
1455      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1456      *
1457      * Tokens start existing when they are minted (`_mint`),
1458      * and stop existing when they are burned (`_burn`).
1459      */
1460     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1461         return _owners[tokenId] != address(0);
1462     }
1463 
1464     /**
1465      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1466      *
1467      * Requirements:
1468      *
1469      * - `tokenId` must exist.
1470      */
1471     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1472         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1473         address owner = ERC721.ownerOf(tokenId);
1474         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1475     }
1476 
1477     /**
1478      * @dev Safely mints `tokenId` and transfers it to `to`.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must not exist.
1483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _safeMint(address to, uint256 tokenId) internal virtual {
1488         _safeMint(to, tokenId, "");
1489     }
1490 
1491     /**
1492      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1493      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1494      */
1495     function _safeMint(
1496         address to,
1497         uint256 tokenId,
1498         bytes memory _data
1499     ) internal virtual {
1500         _mint(to, tokenId);
1501         require(
1502             _checkOnERC721Received(address(0), to, tokenId, _data),
1503             "ERC721: transfer to non ERC721Receiver implementer"
1504         );
1505     }
1506 
1507     /**
1508      * @dev Mints `tokenId` and transfers it to `to`.
1509      *
1510      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1511      *
1512      * Requirements:
1513      *
1514      * - `tokenId` must not exist.
1515      * - `to` cannot be the zero address.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function _mint(address to, uint256 tokenId) internal virtual {
1520         require(to != address(0), "ERC721: mint to the zero address");
1521         require(!_exists(tokenId), "ERC721: token already minted");
1522 
1523         _beforeTokenTransfer(address(0), to, tokenId);
1524 
1525         _balances[to] += 1;
1526         _owners[tokenId] = to;
1527 
1528         emit Transfer(address(0), to, tokenId);
1529 
1530         _afterTokenTransfer(address(0), to, tokenId);
1531     }
1532 
1533     /**
1534      * @dev Destroys `tokenId`.
1535      * The approval is cleared when the token is burned.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must exist.
1540      *
1541      * Emits a {Transfer} event.
1542      */
1543     function _burn(uint256 tokenId) internal virtual {
1544         address owner = ERC721.ownerOf(tokenId);
1545 
1546         _beforeTokenTransfer(owner, address(0), tokenId);
1547 
1548         // Clear approvals
1549         _approve(address(0), tokenId);
1550 
1551         _balances[owner] -= 1;
1552         delete _owners[tokenId];
1553 
1554         emit Transfer(owner, address(0), tokenId);
1555 
1556         _afterTokenTransfer(owner, address(0), tokenId);
1557     }
1558 
1559     /**
1560      * @dev Transfers `tokenId` from `from` to `to`.
1561      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1562      *
1563      * Requirements:
1564      *
1565      * - `to` cannot be the zero address.
1566      * - `tokenId` token must be owned by `from`.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function _transfer(
1571         address from,
1572         address to,
1573         uint256 tokenId
1574     ) internal virtual {
1575         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1576         require(to != address(0), "ERC721: transfer to the zero address");
1577 
1578         _beforeTokenTransfer(from, to, tokenId);
1579 
1580         // Clear approvals from the previous owner
1581         _approve(address(0), tokenId);
1582 
1583         _balances[from] -= 1;
1584         _balances[to] += 1;
1585         _owners[tokenId] = to;
1586 
1587         emit Transfer(from, to, tokenId);
1588 
1589         _afterTokenTransfer(from, to, tokenId);
1590     }
1591 
1592     /**
1593      * @dev Approve `to` to operate on `tokenId`
1594      *
1595      * Emits a {Approval} event.
1596      */
1597     function _approve(address to, uint256 tokenId) internal virtual {
1598         _tokenApprovals[tokenId] = to;
1599         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1600     }
1601 
1602     /**
1603      * @dev Approve `operator` to operate on all of `owner` tokens
1604      *
1605      * Emits a {ApprovalForAll} event.
1606      */
1607     function _setApprovalForAll(
1608         address owner,
1609         address operator,
1610         bool approved
1611     ) internal virtual {
1612         require(owner != operator, "ERC721: approve to caller");
1613         _operatorApprovals[owner][operator] = approved;
1614         emit ApprovalForAll(owner, operator, approved);
1615     }
1616 
1617     /**
1618      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1619      * The call is not executed if the target address is not a contract.
1620      *
1621      * @param from address representing the previous owner of the given token ID
1622      * @param to target address that will receive the tokens
1623      * @param tokenId uint256 ID of the token to be transferred
1624      * @param _data bytes optional data to send along with the call
1625      * @return bool whether the call correctly returned the expected magic value
1626      */
1627     function _checkOnERC721Received(
1628         address from,
1629         address to,
1630         uint256 tokenId,
1631         bytes memory _data
1632     ) private returns (bool) {
1633         if (to.isContract()) {
1634             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1635                 return retval == IERC721Receiver.onERC721Received.selector;
1636             } catch (bytes memory reason) {
1637                 if (reason.length == 0) {
1638                     revert("ERC721: transfer to non ERC721Receiver implementer");
1639                 } else {
1640                     assembly {
1641                         revert(add(32, reason), mload(reason))
1642                     }
1643                 }
1644             }
1645         } else {
1646             return true;
1647         }
1648     }
1649 
1650     /**
1651      * @dev Hook that is called before any token transfer. This includes minting
1652      * and burning.
1653      *
1654      * Calling conditions:
1655      *
1656      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1657      * transferred to `to`.
1658      * - When `from` is zero, `tokenId` will be minted for `to`.
1659      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1660      * - `from` and `to` are never both zero.
1661      *
1662      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1663      */
1664     function _beforeTokenTransfer(
1665         address from,
1666         address to,
1667         uint256 tokenId
1668     ) internal virtual {}
1669 
1670     /**
1671      * @dev Hook that is called after any transfer of tokens. This includes
1672      * minting and burning.
1673      *
1674      * Calling conditions:
1675      *
1676      * - when `from` and `to` are both non-zero.
1677      * - `from` and `to` are never both zero.
1678      *
1679      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1680      */
1681     function _afterTokenTransfer(
1682         address from,
1683         address to,
1684         uint256 tokenId
1685     ) internal virtual {}
1686 }
1687 
1688 
1689 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1690 
1691 
1692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1693 
1694 
1695 
1696 
1697 /**
1698  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1699  * enumerability of all the token ids in the contract as well as all token ids owned by each
1700  * account.
1701  */
1702 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1703     // Mapping from owner to list of owned token IDs
1704     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1705 
1706     // Mapping from token ID to index of the owner tokens list
1707     mapping(uint256 => uint256) private _ownedTokensIndex;
1708 
1709     // Array with all token ids, used for enumeration
1710     uint256[] private _allTokens;
1711 
1712     // Mapping from token id to position in the allTokens array
1713     mapping(uint256 => uint256) private _allTokensIndex;
1714 
1715     /**
1716      * @dev See {IERC165-supportsInterface}.
1717      */
1718     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1719         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1720     }
1721 
1722     /**
1723      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1724      */
1725     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1726         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1727         return _ownedTokens[owner][index];
1728     }
1729 
1730     /**
1731      * @dev See {IERC721Enumerable-totalSupply}.
1732      */
1733     function totalSupply() public view virtual override returns (uint256) {
1734         return _allTokens.length;
1735     }
1736 
1737     /**
1738      * @dev See {IERC721Enumerable-tokenByIndex}.
1739      */
1740     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1741         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1742         return _allTokens[index];
1743     }
1744 
1745     /**
1746      * @dev Hook that is called before any token transfer. This includes minting
1747      * and burning.
1748      *
1749      * Calling conditions:
1750      *
1751      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1752      * transferred to `to`.
1753      * - When `from` is zero, `tokenId` will be minted for `to`.
1754      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1755      * - `from` cannot be the zero address.
1756      * - `to` cannot be the zero address.
1757      *
1758      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1759      */
1760     function _beforeTokenTransfer(
1761         address from,
1762         address to,
1763         uint256 tokenId
1764     ) internal virtual override {
1765         super._beforeTokenTransfer(from, to, tokenId);
1766 
1767         if (from == address(0)) {
1768             _addTokenToAllTokensEnumeration(tokenId);
1769         } else if (from != to) {
1770             _removeTokenFromOwnerEnumeration(from, tokenId);
1771         }
1772         if (to == address(0)) {
1773             _removeTokenFromAllTokensEnumeration(tokenId);
1774         } else if (to != from) {
1775             _addTokenToOwnerEnumeration(to, tokenId);
1776         }
1777     }
1778 
1779     /**
1780      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1781      * @param to address representing the new owner of the given token ID
1782      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1783      */
1784     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1785         uint256 length = ERC721.balanceOf(to);
1786         _ownedTokens[to][length] = tokenId;
1787         _ownedTokensIndex[tokenId] = length;
1788     }
1789 
1790     /**
1791      * @dev Private function to add a token to this extension's token tracking data structures.
1792      * @param tokenId uint256 ID of the token to be added to the tokens list
1793      */
1794     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1795         _allTokensIndex[tokenId] = _allTokens.length;
1796         _allTokens.push(tokenId);
1797     }
1798 
1799     /**
1800      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1801      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1802      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1803      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1804      * @param from address representing the previous owner of the given token ID
1805      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1806      */
1807     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1808         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1809         // then delete the last slot (swap and pop).
1810 
1811         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1812         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1813 
1814         // When the token to delete is the last token, the swap operation is unnecessary
1815         if (tokenIndex != lastTokenIndex) {
1816             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1817 
1818             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1819             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1820         }
1821 
1822         // This also deletes the contents at the last position of the array
1823         delete _ownedTokensIndex[tokenId];
1824         delete _ownedTokens[from][lastTokenIndex];
1825     }
1826 
1827     /**
1828      * @dev Private function to remove a token from this extension's token tracking data structures.
1829      * This has O(1) time complexity, but alters the order of the _allTokens array.
1830      * @param tokenId uint256 ID of the token to be removed from the tokens list
1831      */
1832     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1833         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1834         // then delete the last slot (swap and pop).
1835 
1836         uint256 lastTokenIndex = _allTokens.length - 1;
1837         uint256 tokenIndex = _allTokensIndex[tokenId];
1838 
1839         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1840         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1841         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1842         uint256 lastTokenId = _allTokens[lastTokenIndex];
1843 
1844         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1845         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1846 
1847         // This also deletes the contents at the last position of the array
1848         delete _allTokensIndex[tokenId];
1849         _allTokens.pop();
1850     }
1851 }
1852 
1853 
1854 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1855 
1856 
1857 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1858 
1859 
1860 
1861 /**
1862  * @dev Contract module which provides a basic access control mechanism, where
1863  * there is an account (an owner) that can be granted exclusive access to
1864  * specific functions.
1865  *
1866  * By default, the owner account will be the one that deploys the contract. This
1867  * can later be changed with {transferOwnership}.
1868  *
1869  * This module is used through inheritance. It will make available the modifier
1870  * `onlyOwner`, which can be applied to your functions to restrict their use to
1871  * the owner.
1872  */
1873 abstract contract Ownable is Context {
1874     address private _owner;
1875 
1876     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1877 
1878     /**
1879      * @dev Initializes the contract setting the deployer as the initial owner.
1880      */
1881     constructor() {
1882         _transferOwnership(_msgSender());
1883     }
1884 
1885     /**
1886      * @dev Returns the address of the current owner.
1887      */
1888     function owner() public view virtual returns (address) {
1889         return _owner;
1890     }
1891 
1892     /**
1893      * @dev Throws if called by any account other than the owner.
1894      */
1895     modifier onlyOwner() {
1896         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1897         _;
1898     }
1899 
1900     /**
1901      * @dev Leaves the contract without owner. It will not be possible to call
1902      * `onlyOwner` functions anymore. Can only be called by the current owner.
1903      *
1904      * NOTE: Renouncing ownership will leave the contract without an owner,
1905      * thereby removing any functionality that is only available to the owner.
1906      */
1907     function renounceOwnership() public virtual onlyOwner {
1908         _transferOwnership(address(0));
1909     }
1910 
1911     /**
1912      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1913      * Can only be called by the current owner.
1914      */
1915     function transferOwnership(address newOwner) public virtual onlyOwner {
1916         require(newOwner != address(0), "Ownable: new owner is the zero address");
1917         _transferOwnership(newOwner);
1918     }
1919 
1920     /**
1921      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1922      * Internal function without access restriction.
1923      */
1924     function _transferOwnership(address newOwner) internal virtual {
1925         address oldOwner = _owner;
1926         _owner = newOwner;
1927         emit OwnershipTransferred(oldOwner, newOwner);
1928     }
1929 }
1930 
1931 
1932 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1933 
1934 
1935 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1936 
1937 
1938 
1939 /**
1940  * @dev Contract module that helps prevent reentrant calls to a function.
1941  *
1942  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1943  * available, which can be applied to functions to make sure there are no nested
1944  * (reentrant) calls to them.
1945  *
1946  * Note that because there is a single `nonReentrant` guard, functions marked as
1947  * `nonReentrant` may not call one another. This can be worked around by making
1948  * those functions `private`, and then adding `external` `nonReentrant` entry
1949  * points to them.
1950  *
1951  * TIP: If you would like to learn more about reentrancy and alternative ways
1952  * to protect against it, check out our blog post
1953  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1954  */
1955 abstract contract ReentrancyGuard {
1956     // Booleans are more expensive than uint256 or any type that takes up a full
1957     // word because each write operation emits an extra SLOAD to first read the
1958     // slot's contents, replace the bits taken up by the boolean, and then write
1959     // back. This is the compiler's defense against contract upgrades and
1960     // pointer aliasing, and it cannot be disabled.
1961 
1962     // The values being non-zero value makes deployment a bit more expensive,
1963     // but in exchange the refund on every call to nonReentrant will be lower in
1964     // amount. Since refunds are capped to a percentage of the total
1965     // transaction's gas, it is best to keep them low in cases like this one, to
1966     // increase the likelihood of the full refund coming into effect.
1967     uint256 private constant _NOT_ENTERED = 1;
1968     uint256 private constant _ENTERED = 2;
1969 
1970     uint256 private _status;
1971 
1972     constructor() {
1973         _status = _NOT_ENTERED;
1974     }
1975 
1976     /**
1977      * @dev Prevents a contract from calling itself, directly or indirectly.
1978      * Calling a `nonReentrant` function from another `nonReentrant`
1979      * function is not supported. It is possible to prevent this from happening
1980      * by making the `nonReentrant` function external, and making it call a
1981      * `private` function that does the actual work.
1982      */
1983     modifier nonReentrant() {
1984         // On the first call to nonReentrant, _notEntered will be true
1985         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1986 
1987         // Any calls to nonReentrant after this point will fail
1988         _status = _ENTERED;
1989 
1990         _;
1991 
1992         // By storing the original value once again, a refund is triggered (see
1993         // https://eips.ethereum.org/EIPS/eip-2200)
1994         _status = _NOT_ENTERED;
1995     }
1996 }
1997 
1998 
1999 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
2000 
2001 
2002 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
2003 
2004 
2005 
2006 /**
2007  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2008  *
2009  * These functions can be used to verify that a message was signed by the holder
2010  * of the private keys of a given address.
2011  */
2012 library ECDSA {
2013     enum RecoverError {
2014         NoError,
2015         InvalidSignature,
2016         InvalidSignatureLength,
2017         InvalidSignatureS,
2018         InvalidSignatureV
2019     }
2020 
2021     function _throwError(RecoverError error) private pure {
2022         if (error == RecoverError.NoError) {
2023             return; // no error: do nothing
2024         } else if (error == RecoverError.InvalidSignature) {
2025             revert("ECDSA: invalid signature");
2026         } else if (error == RecoverError.InvalidSignatureLength) {
2027             revert("ECDSA: invalid signature length");
2028         } else if (error == RecoverError.InvalidSignatureS) {
2029             revert("ECDSA: invalid signature 's' value");
2030         } else if (error == RecoverError.InvalidSignatureV) {
2031             revert("ECDSA: invalid signature 'v' value");
2032         }
2033     }
2034 
2035     /**
2036      * @dev Returns the address that signed a hashed message (`hash`) with
2037      * `signature` or error string. This address can then be used for verification purposes.
2038      *
2039      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2040      * this function rejects them by requiring the `s` value to be in the lower
2041      * half order, and the `v` value to be either 27 or 28.
2042      *
2043      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2044      * verification to be secure: it is possible to craft signatures that
2045      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2046      * this is by receiving a hash of the original message (which may otherwise
2047      * be too long), and then calling {toEthSignedMessageHash} on it.
2048      *
2049      * Documentation for signature generation:
2050      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2051      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2052      *
2053      * _Available since v4.3._
2054      */
2055     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2056         // Check the signature length
2057         // - case 65: r,s,v signature (standard)
2058         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
2059         if (signature.length == 65) {
2060             bytes32 r;
2061             bytes32 s;
2062             uint8 v;
2063             // ecrecover takes the signature parameters, and the only way to get them
2064             // currently is to use assembly.
2065             assembly {
2066                 r := mload(add(signature, 0x20))
2067                 s := mload(add(signature, 0x40))
2068                 v := byte(0, mload(add(signature, 0x60)))
2069             }
2070             return tryRecover(hash, v, r, s);
2071         } else if (signature.length == 64) {
2072             bytes32 r;
2073             bytes32 vs;
2074             // ecrecover takes the signature parameters, and the only way to get them
2075             // currently is to use assembly.
2076             assembly {
2077                 r := mload(add(signature, 0x20))
2078                 vs := mload(add(signature, 0x40))
2079             }
2080             return tryRecover(hash, r, vs);
2081         } else {
2082             return (address(0), RecoverError.InvalidSignatureLength);
2083         }
2084     }
2085 
2086     /**
2087      * @dev Returns the address that signed a hashed message (`hash`) with
2088      * `signature`. This address can then be used for verification purposes.
2089      *
2090      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2091      * this function rejects them by requiring the `s` value to be in the lower
2092      * half order, and the `v` value to be either 27 or 28.
2093      *
2094      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2095      * verification to be secure: it is possible to craft signatures that
2096      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2097      * this is by receiving a hash of the original message (which may otherwise
2098      * be too long), and then calling {toEthSignedMessageHash} on it.
2099      */
2100     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2101         (address recovered, RecoverError error) = tryRecover(hash, signature);
2102         _throwError(error);
2103         return recovered;
2104     }
2105 
2106     /**
2107      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2108      *
2109      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2110      *
2111      * _Available since v4.3._
2112      */
2113     function tryRecover(
2114         bytes32 hash,
2115         bytes32 r,
2116         bytes32 vs
2117     ) internal pure returns (address, RecoverError) {
2118         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2119         uint8 v = uint8((uint256(vs) >> 255) + 27);
2120         return tryRecover(hash, v, r, s);
2121     }
2122 
2123     /**
2124      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2125      *
2126      * _Available since v4.2._
2127      */
2128     function recover(
2129         bytes32 hash,
2130         bytes32 r,
2131         bytes32 vs
2132     ) internal pure returns (address) {
2133         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2134         _throwError(error);
2135         return recovered;
2136     }
2137 
2138     /**
2139      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2140      * `r` and `s` signature fields separately.
2141      *
2142      * _Available since v4.3._
2143      */
2144     function tryRecover(
2145         bytes32 hash,
2146         uint8 v,
2147         bytes32 r,
2148         bytes32 s
2149     ) internal pure returns (address, RecoverError) {
2150         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2151         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2152         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2153         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2154         //
2155         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2156         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2157         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2158         // these malleable signatures as well.
2159         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2160             return (address(0), RecoverError.InvalidSignatureS);
2161         }
2162         if (v != 27 && v != 28) {
2163             return (address(0), RecoverError.InvalidSignatureV);
2164         }
2165 
2166         // If the signature is valid (and not malleable), return the signer address
2167         address signer = ecrecover(hash, v, r, s);
2168         if (signer == address(0)) {
2169             return (address(0), RecoverError.InvalidSignature);
2170         }
2171 
2172         return (signer, RecoverError.NoError);
2173     }
2174 
2175     /**
2176      * @dev Overload of {ECDSA-recover} that receives the `v`,
2177      * `r` and `s` signature fields separately.
2178      */
2179     function recover(
2180         bytes32 hash,
2181         uint8 v,
2182         bytes32 r,
2183         bytes32 s
2184     ) internal pure returns (address) {
2185         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2186         _throwError(error);
2187         return recovered;
2188     }
2189 
2190     /**
2191      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2192      * produces hash corresponding to the one signed with the
2193      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2194      * JSON-RPC method as part of EIP-191.
2195      *
2196      * See {recover}.
2197      */
2198     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2199         // 32 is the length in bytes of hash,
2200         // enforced by the type signature above
2201         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2202     }
2203 
2204     /**
2205      * @dev Returns an Ethereum Signed Message, created from `s`. This
2206      * produces hash corresponding to the one signed with the
2207      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2208      * JSON-RPC method as part of EIP-191.
2209      *
2210      * See {recover}.
2211      */
2212     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2213         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2214     }
2215 
2216     /**
2217      * @dev Returns an Ethereum Signed Typed Data, created from a
2218      * `domainSeparator` and a `structHash`. This produces hash corresponding
2219      * to the one signed with the
2220      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2221      * JSON-RPC method as part of EIP-712.
2222      *
2223      * See {recover}.
2224      */
2225     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2226         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2227     }
2228 }
2229 
2230 
2231 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.5.0
2232 
2233 
2234 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
2235 
2236 
2237 
2238 /**
2239  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
2240  *
2241  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
2242  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
2243  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
2244  *
2245  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
2246  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
2247  * ({_hashTypedDataV4}).
2248  *
2249  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
2250  * the chain id to protect against replay attacks on an eventual fork of the chain.
2251  *
2252  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
2253  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
2254  *
2255  * _Available since v3.4._
2256  */
2257 abstract contract EIP712 {
2258     /* solhint-disable var-name-mixedcase */
2259     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
2260     // invalidate the cached domain separator if the chain id changes.
2261     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
2262     uint256 private immutable _CACHED_CHAIN_ID;
2263     address private immutable _CACHED_THIS;
2264 
2265     bytes32 private immutable _HASHED_NAME;
2266     bytes32 private immutable _HASHED_VERSION;
2267     bytes32 private immutable _TYPE_HASH;
2268 
2269     /* solhint-enable var-name-mixedcase */
2270 
2271     /**
2272      * @dev Initializes the domain separator and parameter caches.
2273      *
2274      * The meaning of `name` and `version` is specified in
2275      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
2276      *
2277      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
2278      * - `version`: the current major version of the signing domain.
2279      *
2280      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
2281      * contract upgrade].
2282      */
2283     constructor(string memory name, string memory version) {
2284         bytes32 hashedName = keccak256(bytes(name));
2285         bytes32 hashedVersion = keccak256(bytes(version));
2286         bytes32 typeHash = keccak256(
2287             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
2288         );
2289         _HASHED_NAME = hashedName;
2290         _HASHED_VERSION = hashedVersion;
2291         _CACHED_CHAIN_ID = block.chainid;
2292         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
2293         _CACHED_THIS = address(this);
2294         _TYPE_HASH = typeHash;
2295     }
2296 
2297     /**
2298      * @dev Returns the domain separator for the current chain.
2299      */
2300     function _domainSeparatorV4() internal view returns (bytes32) {
2301         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
2302             return _CACHED_DOMAIN_SEPARATOR;
2303         } else {
2304             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
2305         }
2306     }
2307 
2308     function _buildDomainSeparator(
2309         bytes32 typeHash,
2310         bytes32 nameHash,
2311         bytes32 versionHash
2312     ) private view returns (bytes32) {
2313         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
2314     }
2315 
2316     /**
2317      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
2318      * function returns the hash of the fully encoded EIP712 message for this domain.
2319      *
2320      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
2321      *
2322      * ```solidity
2323      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
2324      *     keccak256("Mail(address to,string contents)"),
2325      *     mailTo,
2326      *     keccak256(bytes(mailContents))
2327      * )));
2328      * address signer = ECDSA.recover(digest, signature);
2329      * ```
2330      */
2331     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
2332         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
2333     }
2334 }
2335 
2336 
2337 // File contracts/NFT.sol
2338 
2339 
2340 
2341 
2342 
2343 
2344 
2345 
2346 
2347 
2348 contract MoonHeadsZooMers is EIP712, ERC721A, Ownable {
2349     using Strings for uint256;
2350 
2351     string private constant SIGNING_DOMAIN = "NFT";
2352     string private constant SIGNATURE_VERSION = "1";
2353 
2354     uint256 public constant MAX_SUPPLY = 5000;
2355     uint256 public constant MAX_PUBLIC_MINT_PER_TRANSACTION = 10;
2356 
2357     address private whiteListeSigner =
2358         0x134296f1C8C636F191e79Dee1Ba2457c89D9117A;
2359     bool public whitelistSaleIsActive = false;
2360     mapping(address => uint256) public whitelistAmountMintedPerWallet;
2361 
2362     bool public saleIsActive = false;
2363 
2364     uint256 public tokenPrice = 0 ether;
2365 
2366     struct FeesWallets {
2367         address wallet;
2368         uint256 fees; // Percentage X 100
2369     }
2370     FeesWallets[] public feesWallets;
2371 
2372     struct Reveal {
2373         uint256 index;
2374         uint256 amount;
2375         uint256 endIndex;
2376         uint256 rand;
2377     }
2378     Reveal[] private reveals;
2379 
2380     string public unrevealedTokenUri = "";
2381     bool public isRevealed = false;
2382     bool public isBaseUrlFrozen = false;
2383     string public baseUri;
2384 
2385     constructor()
2386         ERC721A("MoonHeads ZooMers", "ZOOMER")
2387         EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION)
2388     {
2389         // Smartcontract Dev fees
2390         feesWallets.push(
2391             FeesWallets(0xffe6788BE411C4353B3b2c546D0401D4d8B2b3eD, 500)
2392         );
2393     }
2394 
2395     function buyTokens(uint256 numberOfTokens) public payable {
2396         require(saleIsActive, "sale not open");
2397         applyBuyToken(numberOfTokens, tokenPrice);
2398     }
2399 
2400     function applyBuyToken(uint256 numberOfTokens, uint256 price) private {
2401         uint256 ts = totalSupply();
2402         require(msg.sender == tx.origin);
2403         require(ts + numberOfTokens <= MAX_SUPPLY, "not enough supply");
2404         require(price * numberOfTokens <= msg.value, "invalid ethers sent");
2405         require(
2406             numberOfTokens <= MAX_PUBLIC_MINT_PER_TRANSACTION,
2407             "too many token per transaction"
2408         );
2409         _safeMint(msg.sender, numberOfTokens);
2410     }
2411 
2412     function buyTokenWithWhiteList(
2413         uint256 numberOfTokens,
2414         uint256 price,
2415         uint256 maxPerWallet,
2416         bytes calldata signature
2417     ) public payable {
2418         require(whitelistSaleIsActive, "whitelist sale not open");
2419         verifyWhitelistSignature(signature, msg.sender, price, maxPerWallet);
2420         whitelistAmountMintedPerWallet[msg.sender] += numberOfTokens;
2421         require(
2422             whitelistAmountMintedPerWallet[msg.sender] <= maxPerWallet,
2423             "Max minted with whitelist"
2424         );
2425         applyBuyToken(numberOfTokens, price);
2426     }
2427 
2428     function verifyWhitelistSignature(
2429         bytes calldata signature,
2430         address targetWallet,
2431         uint256 price,
2432         uint256 maxPerWallet
2433     ) internal view {
2434         bytes32 digest = hashWhitelisteSignature(targetWallet, price, maxPerWallet);
2435         address result = ECDSA.recover(digest, signature);
2436         require(result == whiteListeSigner, "bad signature");
2437     }
2438 
2439     function hashWhitelisteSignature(address targetWallet, uint256 price, uint256 maxPerWallet)
2440         internal
2441         view
2442         returns (bytes32)
2443     {
2444         return
2445             _hashTypedDataV4(
2446                 keccak256(
2447                     abi.encode(
2448                         keccak256("Ticket(address wallet,uint256 price,uint256 maxPerWallet)"),
2449                         targetWallet,
2450                         price,
2451                         maxPerWallet
2452                     )
2453                 )
2454             );
2455     }
2456 
2457     function tokenURI(uint256 tokenId)
2458         public
2459         view
2460         override
2461         returns (string memory)
2462     {
2463         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2464         if (reveals.length == 0) {
2465             return unrevealedTokenUri;
2466         }
2467         uint256 baseReveal = reveals[0].rand % MAX_SUPPLY;
2468         for (uint256 i = 0; i < reveals.length; i++) {
2469             Reveal memory currentReveal = reveals[i];
2470             if (
2471                 tokenId >= currentReveal.index &&
2472                 tokenId <= currentReveal.endIndex
2473             ) {
2474                 uint256 localStart = (currentReveal.rand %
2475                     currentReveal.amount);
2476                 uint256 localId = currentReveal.index +
2477                     ((localStart + tokenId) % currentReveal.amount);
2478                 uint256 baseTokenId = (localId + (baseReveal * 7)) % MAX_SUPPLY;
2479                 return
2480                     bytes(baseUri).length > 0
2481                         ? string(
2482                             abi.encodePacked(baseUri, baseTokenId.toString())
2483                         )
2484                         : "";
2485             }
2486         }
2487         return unrevealedTokenUri;
2488     }
2489 
2490     // Admins functions ############################################################################################
2491 
2492     function reveal() external onlyOwner {
2493         Reveal memory newReveal;
2494         uint256 supply = totalSupply();
2495         uint256 rand = uint256(
2496             keccak256(abi.encodePacked(block.difficulty, block.timestamp))
2497         ) % block.timestamp;
2498         if (reveals.length == 0) {
2499             newReveal.index = 0;
2500             newReveal.amount = supply;
2501             newReveal.endIndex = supply - 1;
2502             newReveal.rand = rand;
2503         } else {
2504             uint256 index = reveals[reveals.length - 1].endIndex + 1;
2505             uint256 amount = supply - index;
2506             uint256 endIndex = supply - 1;
2507             newReveal.index = index;
2508             newReveal.amount = amount;
2509             newReveal.endIndex = endIndex;
2510             newReveal.rand = rand;
2511         }
2512         reveals.push(newReveal);
2513     }
2514 
2515     function setBaseURI(string memory newBaseUri) external onlyOwner {
2516         require(!isBaseUrlFrozen, "Base URI is frozen");
2517         baseUri = newBaseUri;
2518     }
2519 
2520     function freezeBaseUrl() external onlyOwner {
2521         isBaseUrlFrozen = true;
2522     }
2523 
2524     function setUnrevealedURI(string memory unrevealedTokenUri_)
2525         external
2526         onlyOwner
2527     {
2528         unrevealedTokenUri = unrevealedTokenUri_;
2529     }
2530 
2531     function setSaleState(bool newState) public onlyOwner {
2532         saleIsActive = newState;
2533     }
2534 
2535     function setWhitelisteSaleState(bool newState) public onlyOwner {
2536         whitelistSaleIsActive = newState;
2537     }
2538 
2539     function setWhiteListSigner(address signer) external onlyOwner {
2540         whiteListeSigner = signer;
2541     }
2542 
2543     function setTokenPrice(uint256 priceInWei) external onlyOwner {
2544         tokenPrice = priceInWei;
2545     }
2546 
2547     function addFeesWallet(address wallet, uint256 feesPercentageX100)
2548         public
2549         onlyOwner
2550     {
2551         uint256 totalFees = 0;
2552         for (uint256 i = 0; i < feesWallets.length; i++) {
2553             totalFees += feesWallets[i].fees;
2554         }
2555         require(
2556             totalFees + feesPercentageX100 < 10000,
2557             "Total percent over 100"
2558         );
2559         feesWallets.push(FeesWallets(wallet, feesPercentageX100));
2560     }
2561 
2562     function withdraw() external onlyOwner {
2563         uint256 balance = address(this).balance;
2564         for (uint256 i = 0; i < feesWallets.length; i++) {
2565             uint256 fee = (balance * feesWallets[i].fees) / 10000;
2566             payable(feesWallets[i].wallet).call{value: fee}("");
2567         }
2568         payable(msg.sender).call{value: address(this).balance}("");
2569     }
2570 }