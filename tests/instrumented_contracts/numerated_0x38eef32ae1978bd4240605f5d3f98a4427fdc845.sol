1 // Sources flattened with hardhat v2.9.2 https://hardhat.org
2 // SPDX-License-Identifier: MIT
3 
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
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
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
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
178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 
234 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
235 
236 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
237 
238 pragma solidity ^0.8.1;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      *
261      * [IMPORTANT]
262      * ====
263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
264      *
265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
267      * constructor.
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize/address.code.length, which returns 0
272         // for contracts in construction, since the code is only stored at the end
273         // of the constructor execution.
274 
275         return account.code.length > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         (bool success, ) = recipient.call{value: amount}("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain `call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         require(isContract(target), "Address: call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.call{value: value}(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
382         return functionStaticCall(target, data, "Address: low-level static call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal view returns (bytes memory) {
396         require(isContract(target), "Address: static call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.staticcall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
409         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(isContract(target), "Address: delegate call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.delegatecall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
431      * revert reason using the provided one.
432      *
433      * _Available since v4.3._
434      */
435     function verifyCallResult(
436         bool success,
437         bytes memory returndata,
438         string memory errorMessage
439     ) internal pure returns (bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 assembly {
448                     let returndata_size := mload(returndata)
449                     revert(add(32, returndata), returndata_size)
450                 }
451             } else {
452                 revert(errorMessage);
453             }
454         }
455     }
456 }
457 
458 
459 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev String operations.
494  */
495 library Strings {
496     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
500      */
501     function toString(uint256 value) internal pure returns (string memory) {
502         // Inspired by OraclizeAPI's implementation - MIT licence
503         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
504 
505         if (value == 0) {
506             return "0";
507         }
508         uint256 temp = value;
509         uint256 digits;
510         while (temp != 0) {
511             digits++;
512             temp /= 10;
513         }
514         bytes memory buffer = new bytes(digits);
515         while (value != 0) {
516             digits -= 1;
517             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
518             value /= 10;
519         }
520         return string(buffer);
521     }
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
525      */
526     function toHexString(uint256 value) internal pure returns (string memory) {
527         if (value == 0) {
528             return "0x00";
529         }
530         uint256 temp = value;
531         uint256 length = 0;
532         while (temp != 0) {
533             length++;
534             temp >>= 8;
535         }
536         return toHexString(value, length);
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
541      */
542     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
543         bytes memory buffer = new bytes(2 * length + 2);
544         buffer[0] = "0";
545         buffer[1] = "x";
546         for (uint256 i = 2 * length + 1; i > 1; --i) {
547             buffer[i] = _HEX_SYMBOLS[value & 0xf];
548             value >>= 4;
549         }
550         require(value == 0, "Strings: hex length insufficient");
551         return string(buffer);
552     }
553 }
554 
555 
556 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Implementation of the {IERC165} interface.
564  *
565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
566  * for the additional interface id that will be supported. For example:
567  *
568  * ```solidity
569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
571  * }
572  * ```
573  *
574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
575  */
576 abstract contract ERC165 is IERC165 {
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
581         return interfaceId == type(IERC165).interfaceId;
582     }
583 }
584 
585 
586 // File erc721a/contracts/ERC721A.sol@v3.1.0
587 
588 // Creator: Chiru Labs
589 
590 pragma solidity ^0.8.4;
591 
592 
593 
594 
595 
596 
597 
598 error ApprovalCallerNotOwnerNorApproved();
599 error ApprovalQueryForNonexistentToken();
600 error ApproveToCaller();
601 error ApprovalToCurrentOwner();
602 error BalanceQueryForZeroAddress();
603 error MintToZeroAddress();
604 error MintZeroQuantity();
605 error OwnerQueryForNonexistentToken();
606 error TransferCallerNotOwnerNorApproved();
607 error TransferFromIncorrectOwner();
608 error TransferToNonERC721ReceiverImplementer();
609 error TransferToZeroAddress();
610 error URIQueryForNonexistentToken();
611 
612 /**
613  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
614  * the Metadata extension. Built to optimize for lower gas during batch mints.
615  *
616  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
617  *
618  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
619  *
620  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
621  */
622 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
623     using Address for address;
624     using Strings for uint256;
625 
626     // Compiler will pack this into a single 256bit word.
627     struct TokenOwnership {
628         // The address of the owner.
629         address addr;
630         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
631         uint64 startTimestamp;
632         // Whether the token has been burned.
633         bool burned;
634     }
635 
636     // Compiler will pack this into a single 256bit word.
637     struct AddressData {
638         // Realistically, 2**64-1 is more than enough.
639         uint64 balance;
640         // Keeps track of mint count with minimal overhead for tokenomics.
641         uint64 numberMinted;
642         // Keeps track of burn count with minimal overhead for tokenomics.
643         uint64 numberBurned;
644         // For miscellaneous variable(s) pertaining to the address
645         // (e.g. number of whitelist mint slots used).
646         // If there are multiple variables, please pack them into a uint64.
647         uint64 aux;
648     }
649 
650     // The tokenId of the next token to be minted.
651     uint256 internal _currentIndex;
652 
653     // The number of tokens burned.
654     uint256 internal _burnCounter;
655 
656     // Token name
657     string private _name;
658 
659     // Token symbol
660     string private _symbol;
661 
662     // Mapping from token ID to ownership details
663     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
664     mapping(uint256 => TokenOwnership) internal _ownerships;
665 
666     // Mapping owner address to address data
667     mapping(address => AddressData) private _addressData;
668 
669     // Mapping from token ID to approved address
670     mapping(uint256 => address) private _tokenApprovals;
671 
672     // Mapping from owner to operator approvals
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     constructor(string memory name_, string memory symbol_) {
676         _name = name_;
677         _symbol = symbol_;
678         _currentIndex = _startTokenId();
679     }
680 
681     /**
682      * To change the starting tokenId, please override this function.
683      */
684     function _startTokenId() internal view virtual returns (uint256) {
685         return 0;
686     }
687 
688     /**
689      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
690      */
691     function totalSupply() public view returns (uint256) {
692         // Counter underflow is impossible as _burnCounter cannot be incremented
693         // more than _currentIndex - _startTokenId() times
694         unchecked {
695             return _currentIndex - _burnCounter - _startTokenId();
696         }
697     }
698 
699     /**
700      * Returns the total amount of tokens minted in the contract.
701      */
702     function _totalMinted() internal view returns (uint256) {
703         // Counter underflow is impossible as _currentIndex does not decrement,
704         // and it is initialized to _startTokenId()
705         unchecked {
706             return _currentIndex - _startTokenId();
707         }
708     }
709 
710     /**
711      * @dev See {IERC165-supportsInterface}.
712      */
713     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
714         return
715             interfaceId == type(IERC721).interfaceId ||
716             interfaceId == type(IERC721Metadata).interfaceId ||
717             super.supportsInterface(interfaceId);
718     }
719 
720     /**
721      * @dev See {IERC721-balanceOf}.
722      */
723     function balanceOf(address owner) public view override returns (uint256) {
724         if (owner == address(0)) revert BalanceQueryForZeroAddress();
725         return uint256(_addressData[owner].balance);
726     }
727 
728     /**
729      * Returns the number of tokens minted by `owner`.
730      */
731     function _numberMinted(address owner) internal view returns (uint256) {
732         return uint256(_addressData[owner].numberMinted);
733     }
734 
735     /**
736      * Returns the number of tokens burned by or on behalf of `owner`.
737      */
738     function _numberBurned(address owner) internal view returns (uint256) {
739         return uint256(_addressData[owner].numberBurned);
740     }
741 
742     /**
743      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
744      */
745     function _getAux(address owner) internal view returns (uint64) {
746         return _addressData[owner].aux;
747     }
748 
749     /**
750      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
751      * If there are multiple variables, please pack them into a uint64.
752      */
753     function _setAux(address owner, uint64 aux) internal {
754         _addressData[owner].aux = aux;
755     }
756 
757     /**
758      * Gas spent here starts off proportional to the maximum mint batch size.
759      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
760      */
761     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
762         uint256 curr = tokenId;
763 
764         unchecked {
765             if (_startTokenId() <= curr && curr < _currentIndex) {
766                 TokenOwnership memory ownership = _ownerships[curr];
767                 if (!ownership.burned) {
768                     if (ownership.addr != address(0)) {
769                         return ownership;
770                     }
771                     // Invariant:
772                     // There will always be an ownership that has an address and is not burned
773                     // before an ownership that does not have an address and is not burned.
774                     // Hence, curr will not underflow.
775                     while (true) {
776                         curr--;
777                         ownership = _ownerships[curr];
778                         if (ownership.addr != address(0)) {
779                             return ownership;
780                         }
781                     }
782                 }
783             }
784         }
785         revert OwnerQueryForNonexistentToken();
786     }
787 
788     /**
789      * @dev See {IERC721-ownerOf}.
790      */
791     function ownerOf(uint256 tokenId) public view override returns (address) {
792         return _ownershipOf(tokenId).addr;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-name}.
797      */
798     function name() public view virtual override returns (string memory) {
799         return _name;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-symbol}.
804      */
805     function symbol() public view virtual override returns (string memory) {
806         return _symbol;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-tokenURI}.
811      */
812     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
813         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
814 
815         string memory baseURI = _baseURI();
816         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
817     }
818 
819     /**
820      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
821      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
822      * by default, can be overriden in child contracts.
823      */
824     function _baseURI() internal view virtual returns (string memory) {
825         return '';
826     }
827 
828     /**
829      * @dev See {IERC721-approve}.
830      */
831     function approve(address to, uint256 tokenId) public override {
832         address owner = ERC721A.ownerOf(tokenId);
833         if (to == owner) revert ApprovalToCurrentOwner();
834 
835         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
836             revert ApprovalCallerNotOwnerNorApproved();
837         }
838 
839         _approve(to, tokenId, owner);
840     }
841 
842     /**
843      * @dev See {IERC721-getApproved}.
844      */
845     function getApproved(uint256 tokenId) public view override returns (address) {
846         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
847 
848         return _tokenApprovals[tokenId];
849     }
850 
851     /**
852      * @dev See {IERC721-setApprovalForAll}.
853      */
854     function setApprovalForAll(address operator, bool approved) public virtual override {
855         if (operator == _msgSender()) revert ApproveToCaller();
856 
857         _operatorApprovals[_msgSender()][operator] = approved;
858         emit ApprovalForAll(_msgSender(), operator, approved);
859     }
860 
861     /**
862      * @dev See {IERC721-isApprovedForAll}.
863      */
864     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
865         return _operatorApprovals[owner][operator];
866     }
867 
868     /**
869      * @dev See {IERC721-transferFrom}.
870      */
871     function transferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         _transfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         safeTransferFrom(from, to, tokenId, '');
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) public virtual override {
899         _transfer(from, to, tokenId);
900         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
901             revert TransferToNonERC721ReceiverImplementer();
902         }
903     }
904 
905     /**
906      * @dev Returns whether `tokenId` exists.
907      *
908      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
909      *
910      * Tokens start existing when they are minted (`_mint`),
911      */
912     function _exists(uint256 tokenId) internal view returns (bool) {
913         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
914             !_ownerships[tokenId].burned;
915     }
916 
917     function _safeMint(address to, uint256 quantity) internal {
918         _safeMint(to, quantity, '');
919     }
920 
921     /**
922      * @dev Safely mints `quantity` tokens and transfers them to `to`.
923      *
924      * Requirements:
925      *
926      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
927      * - `quantity` must be greater than 0.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeMint(
932         address to,
933         uint256 quantity,
934         bytes memory _data
935     ) internal {
936         _mint(to, quantity, _data, true);
937     }
938 
939     /**
940      * @dev Mints `quantity` tokens and transfers them to `to`.
941      *
942      * Requirements:
943      *
944      * - `to` cannot be the zero address.
945      * - `quantity` must be greater than 0.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _mint(
950         address to,
951         uint256 quantity,
952         bytes memory _data,
953         bool safe
954     ) internal {
955         uint256 startTokenId = _currentIndex;
956         if (to == address(0)) revert MintToZeroAddress();
957         if (quantity == 0) revert MintZeroQuantity();
958 
959         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
960 
961         // Overflows are incredibly unrealistic.
962         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
963         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
964         unchecked {
965             _addressData[to].balance += uint64(quantity);
966             _addressData[to].numberMinted += uint64(quantity);
967 
968             _ownerships[startTokenId].addr = to;
969             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
970 
971             uint256 updatedIndex = startTokenId;
972             uint256 end = updatedIndex + quantity;
973 
974             if (safe && to.isContract()) {
975                 do {
976                     emit Transfer(address(0), to, updatedIndex);
977                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
978                         revert TransferToNonERC721ReceiverImplementer();
979                     }
980                 } while (updatedIndex != end);
981                 // Reentrancy protection
982                 if (_currentIndex != startTokenId) revert();
983             } else {
984                 do {
985                     emit Transfer(address(0), to, updatedIndex++);
986                 } while (updatedIndex != end);
987             }
988             _currentIndex = updatedIndex;
989         }
990         _afterTokenTransfers(address(0), to, startTokenId, quantity);
991     }
992 
993     /**
994      * @dev Transfers `tokenId` from `from` to `to`.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must be owned by `from`.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _transfer(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) private {
1008         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1009 
1010         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1011 
1012         bool isApprovedOrOwner = (_msgSender() == from ||
1013             isApprovedForAll(from, _msgSender()) ||
1014             getApproved(tokenId) == _msgSender());
1015 
1016         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1017         if (to == address(0)) revert TransferToZeroAddress();
1018 
1019         _beforeTokenTransfers(from, to, tokenId, 1);
1020 
1021         // Clear approvals from the previous owner
1022         _approve(address(0), tokenId, from);
1023 
1024         // Underflow of the sender's balance is impossible because we check for
1025         // ownership above and the recipient's balance can't realistically overflow.
1026         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1027         unchecked {
1028             _addressData[from].balance -= 1;
1029             _addressData[to].balance += 1;
1030 
1031             TokenOwnership storage currSlot = _ownerships[tokenId];
1032             currSlot.addr = to;
1033             currSlot.startTimestamp = uint64(block.timestamp);
1034 
1035             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1036             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1037             uint256 nextTokenId = tokenId + 1;
1038             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1039             if (nextSlot.addr == address(0)) {
1040                 // This will suffice for checking _exists(nextTokenId),
1041                 // as a burned slot cannot contain the zero address.
1042                 if (nextTokenId != _currentIndex) {
1043                     nextSlot.addr = from;
1044                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1045                 }
1046             }
1047         }
1048 
1049         emit Transfer(from, to, tokenId);
1050         _afterTokenTransfers(from, to, tokenId, 1);
1051     }
1052 
1053     /**
1054      * @dev This is equivalent to _burn(tokenId, false)
1055      */
1056     function _burn(uint256 tokenId) internal virtual {
1057         _burn(tokenId, false);
1058     }
1059 
1060     /**
1061      * @dev Destroys `tokenId`.
1062      * The approval is cleared when the token is burned.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1071         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1072 
1073         address from = prevOwnership.addr;
1074 
1075         if (approvalCheck) {
1076             bool isApprovedOrOwner = (_msgSender() == from ||
1077                 isApprovedForAll(from, _msgSender()) ||
1078                 getApproved(tokenId) == _msgSender());
1079 
1080             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1081         }
1082 
1083         _beforeTokenTransfers(from, address(0), tokenId, 1);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId, from);
1087 
1088         // Underflow of the sender's balance is impossible because we check for
1089         // ownership above and the recipient's balance can't realistically overflow.
1090         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1091         unchecked {
1092             AddressData storage addressData = _addressData[from];
1093             addressData.balance -= 1;
1094             addressData.numberBurned += 1;
1095 
1096             // Keep track of who burned the token, and the timestamp of burning.
1097             TokenOwnership storage currSlot = _ownerships[tokenId];
1098             currSlot.addr = from;
1099             currSlot.startTimestamp = uint64(block.timestamp);
1100             currSlot.burned = true;
1101 
1102             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1103             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1104             uint256 nextTokenId = tokenId + 1;
1105             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1106             if (nextSlot.addr == address(0)) {
1107                 // This will suffice for checking _exists(nextTokenId),
1108                 // as a burned slot cannot contain the zero address.
1109                 if (nextTokenId != _currentIndex) {
1110                     nextSlot.addr = from;
1111                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1112                 }
1113             }
1114         }
1115 
1116         emit Transfer(from, address(0), tokenId);
1117         _afterTokenTransfers(from, address(0), tokenId, 1);
1118 
1119         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1120         unchecked {
1121             _burnCounter++;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Approve `to` to operate on `tokenId`
1127      *
1128      * Emits a {Approval} event.
1129      */
1130     function _approve(
1131         address to,
1132         uint256 tokenId,
1133         address owner
1134     ) private {
1135         _tokenApprovals[tokenId] = to;
1136         emit Approval(owner, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1141      *
1142      * @param from address representing the previous owner of the given token ID
1143      * @param to target address that will receive the tokens
1144      * @param tokenId uint256 ID of the token to be transferred
1145      * @param _data bytes optional data to send along with the call
1146      * @return bool whether the call correctly returned the expected magic value
1147      */
1148     function _checkContractOnERC721Received(
1149         address from,
1150         address to,
1151         uint256 tokenId,
1152         bytes memory _data
1153     ) private returns (bool) {
1154         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1155             return retval == IERC721Receiver(to).onERC721Received.selector;
1156         } catch (bytes memory reason) {
1157             if (reason.length == 0) {
1158                 revert TransferToNonERC721ReceiverImplementer();
1159             } else {
1160                 assembly {
1161                     revert(add(32, reason), mload(reason))
1162                 }
1163             }
1164         }
1165     }
1166 
1167     /**
1168      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1169      * And also called before burning one token.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, `tokenId` will be burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _beforeTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1191      * minting.
1192      * And also called after one token has been burned.
1193      *
1194      * startTokenId - the first token id to be transferred
1195      * quantity - the amount to be transferred
1196      *
1197      * Calling conditions:
1198      *
1199      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1200      * transferred to `to`.
1201      * - When `from` is zero, `tokenId` has been minted for `to`.
1202      * - When `to` is zero, `tokenId` has been burned by `from`.
1203      * - `from` and `to` are never both zero.
1204      */
1205     function _afterTokenTransfers(
1206         address from,
1207         address to,
1208         uint256 startTokenId,
1209         uint256 quantity
1210     ) internal virtual {}
1211 }
1212 
1213 
1214 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1215 
1216 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 /**
1221  * @dev Contract module which provides a basic access control mechanism, where
1222  * there is an account (an owner) that can be granted exclusive access to
1223  * specific functions.
1224  *
1225  * By default, the owner account will be the one that deploys the contract. This
1226  * can later be changed with {transferOwnership}.
1227  *
1228  * This module is used through inheritance. It will make available the modifier
1229  * `onlyOwner`, which can be applied to your functions to restrict their use to
1230  * the owner.
1231  */
1232 abstract contract Ownable is Context {
1233     address private _owner;
1234 
1235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1236 
1237     /**
1238      * @dev Initializes the contract setting the deployer as the initial owner.
1239      */
1240     constructor() {
1241         _transferOwnership(_msgSender());
1242     }
1243 
1244     /**
1245      * @dev Returns the address of the current owner.
1246      */
1247     function owner() public view virtual returns (address) {
1248         return _owner;
1249     }
1250 
1251     /**
1252      * @dev Throws if called by any account other than the owner.
1253      */
1254     modifier onlyOwner() {
1255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1256         _;
1257     }
1258 
1259     /**
1260      * @dev Leaves the contract without owner. It will not be possible to call
1261      * `onlyOwner` functions anymore. Can only be called by the current owner.
1262      *
1263      * NOTE: Renouncing ownership will leave the contract without an owner,
1264      * thereby removing any functionality that is only available to the owner.
1265      */
1266     function renounceOwnership() public virtual onlyOwner {
1267         _transferOwnership(address(0));
1268     }
1269 
1270     /**
1271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1272      * Can only be called by the current owner.
1273      */
1274     function transferOwnership(address newOwner) public virtual onlyOwner {
1275         require(newOwner != address(0), "Ownable: new owner is the zero address");
1276         _transferOwnership(newOwner);
1277     }
1278 
1279     /**
1280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1281      * Internal function without access restriction.
1282      */
1283     function _transferOwnership(address newOwner) internal virtual {
1284         address oldOwner = _owner;
1285         _owner = newOwner;
1286         emit OwnershipTransferred(oldOwner, newOwner);
1287     }
1288 }
1289 
1290 
1291 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.5.0
1292 
1293 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 /**
1298  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1299  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1300  *
1301  * _Available since v3.1._
1302  */
1303 interface IERC1155 is IERC165 {
1304     /**
1305      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1306      */
1307     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1308 
1309     /**
1310      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1311      * transfers.
1312      */
1313     event TransferBatch(
1314         address indexed operator,
1315         address indexed from,
1316         address indexed to,
1317         uint256[] ids,
1318         uint256[] values
1319     );
1320 
1321     /**
1322      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1323      * `approved`.
1324      */
1325     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1326 
1327     /**
1328      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1329      *
1330      * If an {URI} event was emitted for `id`, the standard
1331      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1332      * returned by {IERC1155MetadataURI-uri}.
1333      */
1334     event URI(string value, uint256 indexed id);
1335 
1336     /**
1337      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1338      *
1339      * Requirements:
1340      *
1341      * - `account` cannot be the zero address.
1342      */
1343     function balanceOf(address account, uint256 id) external view returns (uint256);
1344 
1345     /**
1346      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1347      *
1348      * Requirements:
1349      *
1350      * - `accounts` and `ids` must have the same length.
1351      */
1352     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1353         external
1354         view
1355         returns (uint256[] memory);
1356 
1357     /**
1358      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1359      *
1360      * Emits an {ApprovalForAll} event.
1361      *
1362      * Requirements:
1363      *
1364      * - `operator` cannot be the caller.
1365      */
1366     function setApprovalForAll(address operator, bool approved) external;
1367 
1368     /**
1369      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1370      *
1371      * See {setApprovalForAll}.
1372      */
1373     function isApprovedForAll(address account, address operator) external view returns (bool);
1374 
1375     /**
1376      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1377      *
1378      * Emits a {TransferSingle} event.
1379      *
1380      * Requirements:
1381      *
1382      * - `to` cannot be the zero address.
1383      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1384      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1385      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1386      * acceptance magic value.
1387      */
1388     function safeTransferFrom(
1389         address from,
1390         address to,
1391         uint256 id,
1392         uint256 amount,
1393         bytes calldata data
1394     ) external;
1395 
1396     /**
1397      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1398      *
1399      * Emits a {TransferBatch} event.
1400      *
1401      * Requirements:
1402      *
1403      * - `ids` and `amounts` must have the same length.
1404      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1405      * acceptance magic value.
1406      */
1407     function safeBatchTransferFrom(
1408         address from,
1409         address to,
1410         uint256[] calldata ids,
1411         uint256[] calldata amounts,
1412         bytes calldata data
1413     ) external;
1414 }
1415 
1416 
1417 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
1418 
1419 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 /**
1424  * @dev Interface of the ERC20 standard as defined in the EIP.
1425  */
1426 interface IERC20 {
1427     /**
1428      * @dev Returns the amount of tokens in existence.
1429      */
1430     function totalSupply() external view returns (uint256);
1431 
1432     /**
1433      * @dev Returns the amount of tokens owned by `account`.
1434      */
1435     function balanceOf(address account) external view returns (uint256);
1436 
1437     /**
1438      * @dev Moves `amount` tokens from the caller's account to `to`.
1439      *
1440      * Returns a boolean value indicating whether the operation succeeded.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function transfer(address to, uint256 amount) external returns (bool);
1445 
1446     /**
1447      * @dev Returns the remaining number of tokens that `spender` will be
1448      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1449      * zero by default.
1450      *
1451      * This value changes when {approve} or {transferFrom} are called.
1452      */
1453     function allowance(address owner, address spender) external view returns (uint256);
1454 
1455     /**
1456      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1457      *
1458      * Returns a boolean value indicating whether the operation succeeded.
1459      *
1460      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1461      * that someone may use both the old and the new allowance by unfortunate
1462      * transaction ordering. One possible solution to mitigate this race
1463      * condition is to first reduce the spender's allowance to 0 and set the
1464      * desired value afterwards:
1465      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1466      *
1467      * Emits an {Approval} event.
1468      */
1469     function approve(address spender, uint256 amount) external returns (bool);
1470 
1471     /**
1472      * @dev Moves `amount` tokens from `from` to `to` using the
1473      * allowance mechanism. `amount` is then deducted from the caller's
1474      * allowance.
1475      *
1476      * Returns a boolean value indicating whether the operation succeeded.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function transferFrom(
1481         address from,
1482         address to,
1483         uint256 amount
1484     ) external returns (bool);
1485 
1486     /**
1487      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1488      * another (`to`).
1489      *
1490      * Note that `value` may be zero.
1491      */
1492     event Transfer(address indexed from, address indexed to, uint256 value);
1493 
1494     /**
1495      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1496      * a call to {approve}. `value` is the new allowance.
1497      */
1498     event Approval(address indexed owner, address indexed spender, uint256 value);
1499 }
1500 
1501 
1502 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1503 
1504 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1505 
1506 pragma solidity ^0.8.0;
1507 
1508 /**
1509  * @dev These functions deal with verification of Merkle Trees proofs.
1510  *
1511  * The proofs can be generated using the JavaScript library
1512  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1513  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1514  *
1515  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1516  */
1517 library MerkleProof {
1518     /**
1519      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1520      * defined by `root`. For this, a `proof` must be provided, containing
1521      * sibling hashes on the branch from the leaf to the root of the tree. Each
1522      * pair of leaves and each pair of pre-images are assumed to be sorted.
1523      */
1524     function verify(
1525         bytes32[] memory proof,
1526         bytes32 root,
1527         bytes32 leaf
1528     ) internal pure returns (bool) {
1529         return processProof(proof, leaf) == root;
1530     }
1531 
1532     /**
1533      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1534      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1535      * hash matches the root of the tree. When processing the proof, the pairs
1536      * of leafs & pre-images are assumed to be sorted.
1537      *
1538      * _Available since v4.4._
1539      */
1540     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1541         bytes32 computedHash = leaf;
1542         for (uint256 i = 0; i < proof.length; i++) {
1543             bytes32 proofElement = proof[i];
1544             if (computedHash <= proofElement) {
1545                 // Hash(current computed hash + current element of the proof)
1546                 computedHash = _efficientHash(computedHash, proofElement);
1547             } else {
1548                 // Hash(current element of the proof + current computed hash)
1549                 computedHash = _efficientHash(proofElement, computedHash);
1550             }
1551         }
1552         return computedHash;
1553     }
1554 
1555     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1556         assembly {
1557             mstore(0x00, a)
1558             mstore(0x20, b)
1559             value := keccak256(0x00, 0x40)
1560         }
1561     }
1562 }
1563 
1564 
1565 // File @openzeppelin/contracts/utils/math/Math.sol@v4.5.0
1566 
1567 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1568 
1569 pragma solidity ^0.8.0;
1570 
1571 /**
1572  * @dev Standard math utilities missing in the Solidity language.
1573  */
1574 library Math {
1575     /**
1576      * @dev Returns the largest of two numbers.
1577      */
1578     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1579         return a >= b ? a : b;
1580     }
1581 
1582     /**
1583      * @dev Returns the smallest of two numbers.
1584      */
1585     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1586         return a < b ? a : b;
1587     }
1588 
1589     /**
1590      * @dev Returns the average of two numbers. The result is rounded towards
1591      * zero.
1592      */
1593     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1594         // (a + b) / 2 can overflow.
1595         return (a & b) + (a ^ b) / 2;
1596     }
1597 
1598     /**
1599      * @dev Returns the ceiling of the division of two numbers.
1600      *
1601      * This differs from standard division with `/` in that it rounds up instead
1602      * of rounding down.
1603      */
1604     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1605         // (a + b - 1) / b can overflow on addition, so we distribute.
1606         return a / b + (a % b == 0 ? 0 : 1);
1607     }
1608 }
1609 
1610 
1611 // File hardhat/console.sol@v2.9.2
1612 
1613 pragma solidity >= 0.4.22 <0.9.0;
1614 
1615 library console {
1616 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1617 
1618 	function _sendLogPayload(bytes memory payload) private view {
1619 		uint256 payloadLength = payload.length;
1620 		address consoleAddress = CONSOLE_ADDRESS;
1621 		assembly {
1622 			let payloadStart := add(payload, 32)
1623 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1624 		}
1625 	}
1626 
1627 	function log() internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log()"));
1629 	}
1630 
1631 	function logInt(int p0) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1633 	}
1634 
1635 	function logUint(uint p0) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1637 	}
1638 
1639 	function logString(string memory p0) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1641 	}
1642 
1643 	function logBool(bool p0) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1645 	}
1646 
1647 	function logAddress(address p0) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1649 	}
1650 
1651 	function logBytes(bytes memory p0) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1653 	}
1654 
1655 	function logBytes1(bytes1 p0) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1657 	}
1658 
1659 	function logBytes2(bytes2 p0) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1661 	}
1662 
1663 	function logBytes3(bytes3 p0) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1665 	}
1666 
1667 	function logBytes4(bytes4 p0) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1669 	}
1670 
1671 	function logBytes5(bytes5 p0) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1673 	}
1674 
1675 	function logBytes6(bytes6 p0) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1677 	}
1678 
1679 	function logBytes7(bytes7 p0) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1681 	}
1682 
1683 	function logBytes8(bytes8 p0) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1685 	}
1686 
1687 	function logBytes9(bytes9 p0) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1689 	}
1690 
1691 	function logBytes10(bytes10 p0) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1693 	}
1694 
1695 	function logBytes11(bytes11 p0) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1697 	}
1698 
1699 	function logBytes12(bytes12 p0) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1701 	}
1702 
1703 	function logBytes13(bytes13 p0) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1705 	}
1706 
1707 	function logBytes14(bytes14 p0) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1709 	}
1710 
1711 	function logBytes15(bytes15 p0) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1713 	}
1714 
1715 	function logBytes16(bytes16 p0) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1717 	}
1718 
1719 	function logBytes17(bytes17 p0) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1721 	}
1722 
1723 	function logBytes18(bytes18 p0) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1725 	}
1726 
1727 	function logBytes19(bytes19 p0) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1729 	}
1730 
1731 	function logBytes20(bytes20 p0) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1733 	}
1734 
1735 	function logBytes21(bytes21 p0) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1737 	}
1738 
1739 	function logBytes22(bytes22 p0) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1741 	}
1742 
1743 	function logBytes23(bytes23 p0) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1745 	}
1746 
1747 	function logBytes24(bytes24 p0) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1749 	}
1750 
1751 	function logBytes25(bytes25 p0) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1753 	}
1754 
1755 	function logBytes26(bytes26 p0) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1757 	}
1758 
1759 	function logBytes27(bytes27 p0) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1761 	}
1762 
1763 	function logBytes28(bytes28 p0) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1765 	}
1766 
1767 	function logBytes29(bytes29 p0) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1769 	}
1770 
1771 	function logBytes30(bytes30 p0) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1773 	}
1774 
1775 	function logBytes31(bytes31 p0) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1777 	}
1778 
1779 	function logBytes32(bytes32 p0) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1781 	}
1782 
1783 	function log(uint p0) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1785 	}
1786 
1787 	function log(string memory p0) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1789 	}
1790 
1791 	function log(bool p0) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1793 	}
1794 
1795 	function log(address p0) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1797 	}
1798 
1799 	function log(uint p0, uint p1) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1801 	}
1802 
1803 	function log(uint p0, string memory p1) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1805 	}
1806 
1807 	function log(uint p0, bool p1) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1809 	}
1810 
1811 	function log(uint p0, address p1) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1813 	}
1814 
1815 	function log(string memory p0, uint p1) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1817 	}
1818 
1819 	function log(string memory p0, string memory p1) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1821 	}
1822 
1823 	function log(string memory p0, bool p1) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1825 	}
1826 
1827 	function log(string memory p0, address p1) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1829 	}
1830 
1831 	function log(bool p0, uint p1) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1833 	}
1834 
1835 	function log(bool p0, string memory p1) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1837 	}
1838 
1839 	function log(bool p0, bool p1) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1841 	}
1842 
1843 	function log(bool p0, address p1) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1845 	}
1846 
1847 	function log(address p0, uint p1) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1849 	}
1850 
1851 	function log(address p0, string memory p1) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1853 	}
1854 
1855 	function log(address p0, bool p1) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1857 	}
1858 
1859 	function log(address p0, address p1) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1861 	}
1862 
1863 	function log(uint p0, uint p1, uint p2) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1865 	}
1866 
1867 	function log(uint p0, uint p1, string memory p2) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1869 	}
1870 
1871 	function log(uint p0, uint p1, bool p2) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1873 	}
1874 
1875 	function log(uint p0, uint p1, address p2) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1877 	}
1878 
1879 	function log(uint p0, string memory p1, uint p2) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1881 	}
1882 
1883 	function log(uint p0, string memory p1, string memory p2) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1885 	}
1886 
1887 	function log(uint p0, string memory p1, bool p2) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1889 	}
1890 
1891 	function log(uint p0, string memory p1, address p2) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1893 	}
1894 
1895 	function log(uint p0, bool p1, uint p2) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1897 	}
1898 
1899 	function log(uint p0, bool p1, string memory p2) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1901 	}
1902 
1903 	function log(uint p0, bool p1, bool p2) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1905 	}
1906 
1907 	function log(uint p0, bool p1, address p2) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1909 	}
1910 
1911 	function log(uint p0, address p1, uint p2) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1913 	}
1914 
1915 	function log(uint p0, address p1, string memory p2) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1917 	}
1918 
1919 	function log(uint p0, address p1, bool p2) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1921 	}
1922 
1923 	function log(uint p0, address p1, address p2) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1925 	}
1926 
1927 	function log(string memory p0, uint p1, uint p2) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1929 	}
1930 
1931 	function log(string memory p0, uint p1, string memory p2) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1933 	}
1934 
1935 	function log(string memory p0, uint p1, bool p2) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1937 	}
1938 
1939 	function log(string memory p0, uint p1, address p2) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1941 	}
1942 
1943 	function log(string memory p0, string memory p1, uint p2) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1945 	}
1946 
1947 	function log(string memory p0, string memory p1, string memory p2) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1949 	}
1950 
1951 	function log(string memory p0, string memory p1, bool p2) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1953 	}
1954 
1955 	function log(string memory p0, string memory p1, address p2) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1957 	}
1958 
1959 	function log(string memory p0, bool p1, uint p2) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1961 	}
1962 
1963 	function log(string memory p0, bool p1, string memory p2) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1965 	}
1966 
1967 	function log(string memory p0, bool p1, bool p2) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1969 	}
1970 
1971 	function log(string memory p0, bool p1, address p2) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1973 	}
1974 
1975 	function log(string memory p0, address p1, uint p2) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1977 	}
1978 
1979 	function log(string memory p0, address p1, string memory p2) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1981 	}
1982 
1983 	function log(string memory p0, address p1, bool p2) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1985 	}
1986 
1987 	function log(string memory p0, address p1, address p2) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1989 	}
1990 
1991 	function log(bool p0, uint p1, uint p2) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1993 	}
1994 
1995 	function log(bool p0, uint p1, string memory p2) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1997 	}
1998 
1999 	function log(bool p0, uint p1, bool p2) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
2001 	}
2002 
2003 	function log(bool p0, uint p1, address p2) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2005 	}
2006 
2007 	function log(bool p0, string memory p1, uint p2) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2009 	}
2010 
2011 	function log(bool p0, string memory p1, string memory p2) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2013 	}
2014 
2015 	function log(bool p0, string memory p1, bool p2) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2017 	}
2018 
2019 	function log(bool p0, string memory p1, address p2) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2021 	}
2022 
2023 	function log(bool p0, bool p1, uint p2) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2025 	}
2026 
2027 	function log(bool p0, bool p1, string memory p2) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2029 	}
2030 
2031 	function log(bool p0, bool p1, bool p2) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2033 	}
2034 
2035 	function log(bool p0, bool p1, address p2) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2037 	}
2038 
2039 	function log(bool p0, address p1, uint p2) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2041 	}
2042 
2043 	function log(bool p0, address p1, string memory p2) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2045 	}
2046 
2047 	function log(bool p0, address p1, bool p2) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2049 	}
2050 
2051 	function log(bool p0, address p1, address p2) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2053 	}
2054 
2055 	function log(address p0, uint p1, uint p2) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2057 	}
2058 
2059 	function log(address p0, uint p1, string memory p2) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2061 	}
2062 
2063 	function log(address p0, uint p1, bool p2) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2065 	}
2066 
2067 	function log(address p0, uint p1, address p2) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2069 	}
2070 
2071 	function log(address p0, string memory p1, uint p2) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2073 	}
2074 
2075 	function log(address p0, string memory p1, string memory p2) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2077 	}
2078 
2079 	function log(address p0, string memory p1, bool p2) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2081 	}
2082 
2083 	function log(address p0, string memory p1, address p2) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2085 	}
2086 
2087 	function log(address p0, bool p1, uint p2) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2089 	}
2090 
2091 	function log(address p0, bool p1, string memory p2) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2093 	}
2094 
2095 	function log(address p0, bool p1, bool p2) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2097 	}
2098 
2099 	function log(address p0, bool p1, address p2) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2101 	}
2102 
2103 	function log(address p0, address p1, uint p2) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2105 	}
2106 
2107 	function log(address p0, address p1, string memory p2) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2109 	}
2110 
2111 	function log(address p0, address p1, bool p2) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2113 	}
2114 
2115 	function log(address p0, address p1, address p2) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2117 	}
2118 
2119 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(uint p0, uint p1, address p2, address p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(uint p0, bool p1, address p2, address p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2321 	}
2322 
2323 	function log(uint p0, address p1, uint p2, address p3) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2325 	}
2326 
2327 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2329 	}
2330 
2331 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2332 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2333 	}
2334 
2335 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2336 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2337 	}
2338 
2339 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2340 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2341 	}
2342 
2343 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2344 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2345 	}
2346 
2347 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2348 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2349 	}
2350 
2351 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2352 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2353 	}
2354 
2355 	function log(uint p0, address p1, bool p2, address p3) internal view {
2356 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2357 	}
2358 
2359 	function log(uint p0, address p1, address p2, uint p3) internal view {
2360 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2361 	}
2362 
2363 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2364 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2365 	}
2366 
2367 	function log(uint p0, address p1, address p2, bool p3) internal view {
2368 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2369 	}
2370 
2371 	function log(uint p0, address p1, address p2, address p3) internal view {
2372 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2373 	}
2374 
2375 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2376 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2377 	}
2378 
2379 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2380 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2381 	}
2382 
2383 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2384 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2385 	}
2386 
2387 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2388 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2389 	}
2390 
2391 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2392 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2393 	}
2394 
2395 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2396 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2397 	}
2398 
2399 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2400 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2401 	}
2402 
2403 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2404 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2405 	}
2406 
2407 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2408 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2409 	}
2410 
2411 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2412 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2413 	}
2414 
2415 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2416 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2417 	}
2418 
2419 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2420 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2421 	}
2422 
2423 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2424 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2425 	}
2426 
2427 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2428 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2429 	}
2430 
2431 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2432 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2433 	}
2434 
2435 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2436 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2437 	}
2438 
2439 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2440 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2441 	}
2442 
2443 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2444 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2445 	}
2446 
2447 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2448 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2449 	}
2450 
2451 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2452 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2453 	}
2454 
2455 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2456 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2457 	}
2458 
2459 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2460 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2461 	}
2462 
2463 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2464 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2465 	}
2466 
2467 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2468 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2469 	}
2470 
2471 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2472 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2473 	}
2474 
2475 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2476 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2477 	}
2478 
2479 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2480 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2481 	}
2482 
2483 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2484 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2485 	}
2486 
2487 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2488 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2489 	}
2490 
2491 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2492 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2493 	}
2494 
2495 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2496 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2497 	}
2498 
2499 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2500 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2501 	}
2502 
2503 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2504 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2505 	}
2506 
2507 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2508 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2509 	}
2510 
2511 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2512 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2513 	}
2514 
2515 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2516 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2517 	}
2518 
2519 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2520 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2521 	}
2522 
2523 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2524 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2525 	}
2526 
2527 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2528 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2529 	}
2530 
2531 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2532 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2533 	}
2534 
2535 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2536 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2537 	}
2538 
2539 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2540 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2541 	}
2542 
2543 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2544 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2545 	}
2546 
2547 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2548 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2549 	}
2550 
2551 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2552 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2553 	}
2554 
2555 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2556 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2557 	}
2558 
2559 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2560 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2561 	}
2562 
2563 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2564 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2565 	}
2566 
2567 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2568 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2569 	}
2570 
2571 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2572 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2573 	}
2574 
2575 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2576 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2577 	}
2578 
2579 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2580 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2581 	}
2582 
2583 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2584 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2585 	}
2586 
2587 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2588 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2589 	}
2590 
2591 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2592 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2593 	}
2594 
2595 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2596 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2597 	}
2598 
2599 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2600 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2601 	}
2602 
2603 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2604 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2605 	}
2606 
2607 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2608 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2609 	}
2610 
2611 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2612 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2613 	}
2614 
2615 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2616 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2617 	}
2618 
2619 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2620 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2621 	}
2622 
2623 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2624 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2625 	}
2626 
2627 	function log(string memory p0, address p1, address p2, address p3) internal view {
2628 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2629 	}
2630 
2631 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2632 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2633 	}
2634 
2635 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2636 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2637 	}
2638 
2639 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2640 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2641 	}
2642 
2643 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2644 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2645 	}
2646 
2647 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2648 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2649 	}
2650 
2651 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2652 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2653 	}
2654 
2655 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2656 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2657 	}
2658 
2659 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2660 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2661 	}
2662 
2663 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2664 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2665 	}
2666 
2667 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2668 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2669 	}
2670 
2671 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2672 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2673 	}
2674 
2675 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2676 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2677 	}
2678 
2679 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2680 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2681 	}
2682 
2683 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2684 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2685 	}
2686 
2687 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2688 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2689 	}
2690 
2691 	function log(bool p0, uint p1, address p2, address p3) internal view {
2692 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2693 	}
2694 
2695 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2696 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2697 	}
2698 
2699 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2700 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2701 	}
2702 
2703 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2704 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2705 	}
2706 
2707 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2708 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2709 	}
2710 
2711 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2712 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2713 	}
2714 
2715 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2716 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2717 	}
2718 
2719 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2720 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2721 	}
2722 
2723 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2724 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2725 	}
2726 
2727 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2728 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2729 	}
2730 
2731 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2732 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2733 	}
2734 
2735 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2736 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2737 	}
2738 
2739 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2740 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2741 	}
2742 
2743 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2744 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2745 	}
2746 
2747 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2748 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2749 	}
2750 
2751 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2752 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2753 	}
2754 
2755 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2756 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2757 	}
2758 
2759 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2760 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2761 	}
2762 
2763 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2764 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2765 	}
2766 
2767 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2768 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2769 	}
2770 
2771 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2772 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2773 	}
2774 
2775 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2776 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2777 	}
2778 
2779 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2780 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2781 	}
2782 
2783 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2784 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2785 	}
2786 
2787 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2788 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2789 	}
2790 
2791 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2792 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2793 	}
2794 
2795 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2796 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2797 	}
2798 
2799 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2800 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2801 	}
2802 
2803 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2804 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2805 	}
2806 
2807 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2808 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2809 	}
2810 
2811 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2812 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2813 	}
2814 
2815 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2816 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2817 	}
2818 
2819 	function log(bool p0, bool p1, address p2, address p3) internal view {
2820 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2821 	}
2822 
2823 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2824 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2825 	}
2826 
2827 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2828 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2829 	}
2830 
2831 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2832 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2833 	}
2834 
2835 	function log(bool p0, address p1, uint p2, address p3) internal view {
2836 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2837 	}
2838 
2839 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2840 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2841 	}
2842 
2843 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2844 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2845 	}
2846 
2847 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2848 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2849 	}
2850 
2851 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2852 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2853 	}
2854 
2855 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2856 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2857 	}
2858 
2859 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2860 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2861 	}
2862 
2863 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2864 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2865 	}
2866 
2867 	function log(bool p0, address p1, bool p2, address p3) internal view {
2868 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2869 	}
2870 
2871 	function log(bool p0, address p1, address p2, uint p3) internal view {
2872 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2873 	}
2874 
2875 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2876 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2877 	}
2878 
2879 	function log(bool p0, address p1, address p2, bool p3) internal view {
2880 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2881 	}
2882 
2883 	function log(bool p0, address p1, address p2, address p3) internal view {
2884 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2885 	}
2886 
2887 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2888 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2889 	}
2890 
2891 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2892 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2893 	}
2894 
2895 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2896 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2897 	}
2898 
2899 	function log(address p0, uint p1, uint p2, address p3) internal view {
2900 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2901 	}
2902 
2903 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2904 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2905 	}
2906 
2907 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2908 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2909 	}
2910 
2911 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2912 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2913 	}
2914 
2915 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2916 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2917 	}
2918 
2919 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2920 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2921 	}
2922 
2923 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2924 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2925 	}
2926 
2927 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2928 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2929 	}
2930 
2931 	function log(address p0, uint p1, bool p2, address p3) internal view {
2932 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2933 	}
2934 
2935 	function log(address p0, uint p1, address p2, uint p3) internal view {
2936 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2937 	}
2938 
2939 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2940 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2941 	}
2942 
2943 	function log(address p0, uint p1, address p2, bool p3) internal view {
2944 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2945 	}
2946 
2947 	function log(address p0, uint p1, address p2, address p3) internal view {
2948 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2949 	}
2950 
2951 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2952 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2953 	}
2954 
2955 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2956 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2957 	}
2958 
2959 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2960 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2961 	}
2962 
2963 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2964 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2965 	}
2966 
2967 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2968 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2969 	}
2970 
2971 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2972 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2973 	}
2974 
2975 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2976 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2977 	}
2978 
2979 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2980 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2981 	}
2982 
2983 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2984 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2985 	}
2986 
2987 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2988 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2989 	}
2990 
2991 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2992 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2993 	}
2994 
2995 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2996 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2997 	}
2998 
2999 	function log(address p0, string memory p1, address p2, uint p3) internal view {
3000 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
3001 	}
3002 
3003 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3004 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3005 	}
3006 
3007 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3008 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3009 	}
3010 
3011 	function log(address p0, string memory p1, address p2, address p3) internal view {
3012 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3013 	}
3014 
3015 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3016 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3017 	}
3018 
3019 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3020 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3021 	}
3022 
3023 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3024 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3025 	}
3026 
3027 	function log(address p0, bool p1, uint p2, address p3) internal view {
3028 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3029 	}
3030 
3031 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3032 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3033 	}
3034 
3035 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3036 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3037 	}
3038 
3039 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3040 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3041 	}
3042 
3043 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3044 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3045 	}
3046 
3047 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3048 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3049 	}
3050 
3051 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3052 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3053 	}
3054 
3055 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3056 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3057 	}
3058 
3059 	function log(address p0, bool p1, bool p2, address p3) internal view {
3060 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3061 	}
3062 
3063 	function log(address p0, bool p1, address p2, uint p3) internal view {
3064 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3065 	}
3066 
3067 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3068 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3069 	}
3070 
3071 	function log(address p0, bool p1, address p2, bool p3) internal view {
3072 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3073 	}
3074 
3075 	function log(address p0, bool p1, address p2, address p3) internal view {
3076 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3077 	}
3078 
3079 	function log(address p0, address p1, uint p2, uint p3) internal view {
3080 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3081 	}
3082 
3083 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3084 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3085 	}
3086 
3087 	function log(address p0, address p1, uint p2, bool p3) internal view {
3088 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3089 	}
3090 
3091 	function log(address p0, address p1, uint p2, address p3) internal view {
3092 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3093 	}
3094 
3095 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3096 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3097 	}
3098 
3099 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3100 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3101 	}
3102 
3103 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3104 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3105 	}
3106 
3107 	function log(address p0, address p1, string memory p2, address p3) internal view {
3108 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3109 	}
3110 
3111 	function log(address p0, address p1, bool p2, uint p3) internal view {
3112 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3113 	}
3114 
3115 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3116 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3117 	}
3118 
3119 	function log(address p0, address p1, bool p2, bool p3) internal view {
3120 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3121 	}
3122 
3123 	function log(address p0, address p1, bool p2, address p3) internal view {
3124 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3125 	}
3126 
3127 	function log(address p0, address p1, address p2, uint p3) internal view {
3128 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3129 	}
3130 
3131 	function log(address p0, address p1, address p2, string memory p3) internal view {
3132 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3133 	}
3134 
3135 	function log(address p0, address p1, address p2, bool p3) internal view {
3136 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3137 	}
3138 
3139 	function log(address p0, address p1, address p2, address p3) internal view {
3140 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3141 	}
3142 
3143 }
3144 
3145 
3146 // File contracts/ForestSpirits.sol
3147 
3148 pragma solidity 0.8.10;
3149 
3150 
3151 
3152 
3153 
3154 
3155 
3156 
3157 contract ForestSpirits is ERC721A, Ownable {
3158     uint256 public immutable MAX_SUPPLY = 8888;
3159 
3160     // Contract URI.
3161     string public CONTRACT_URI;
3162 
3163     // Minting parameters.
3164     address public TREASURY;
3165     IERC20 public APE_TOKEN;
3166     uint256 public APE_PRICE = 32 ether;
3167     uint256 public PRICE = 0.1 ether;
3168     uint256 public PRICE_BONSAI = 0.08 ether;
3169     uint256 public WALLET_MINT_LIMIT = 8;
3170     bytes32 public BONSAI_MERKLE_ROOT;
3171     bytes32 public PARTNER_MERKLE_ROOT;
3172     bool public OPEN_BONSAI = false;
3173     bool public OPEN_PARTNER = false;
3174     bool public OPEN_PUBLIC = false;
3175     bool public didOwnerMint = false;
3176 
3177     // Token URI data.
3178     string public BASE_URI;
3179     mapping(uint256 => string) public tokenUriOverride;
3180 
3181     // Seedling data.
3182     IERC1155 public SEEDLING;
3183     IERC721 public BONSAI;
3184     IERC1155 public ROOTS;
3185     address public BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
3186 
3187     event AncestralSeedlingMint(
3188         uint256 spiritId,
3189         address bonsaiType,
3190         uint256 bonsaiId
3191     );
3192 
3193     address CREATOR_1 = 0xfb9685393939c1D65400f2609e7a612b2dA08aB9;
3194     address CREATOR_2 = 0xC9E2e7F50409cAfdf87991f5DA203b09F71Cc3C1;
3195     address CREATOR_3 = 0xfb9685393939c1D65400f2609e7a612b2dA08aB9;
3196 
3197     modifier onlyCreators() {
3198         require(
3199             msg.sender == owner() ||
3200                 msg.sender == CREATOR_1 ||
3201                 msg.sender == CREATOR_2 ||
3202                 msg.sender == CREATOR_3
3203         );
3204         _;
3205     }
3206 
3207     constructor(
3208         address treasury,
3209         address ape,
3210         address seedling,
3211         address bonsai,
3212         address roots,
3213         address contractOwner
3214     ) ERC721A("Forest Spirits", "SPIRIT") {
3215         TREASURY = treasury;
3216         APE_TOKEN = IERC20(ape);
3217         SEEDLING = IERC1155(seedling);
3218         BONSAI = IERC721(bonsai);
3219         ROOTS = IERC1155(roots);
3220         _safeMint(msg.sender, 1);
3221         transferOwnership(contractOwner);
3222     }
3223 
3224     // ===
3225     // Minting.
3226     // ===
3227 
3228     function ownerMint() external onlyOwner {
3229         require(!didOwnerMint);
3230         didOwnerMint = true;
3231         _safeMint(msg.sender, 72);
3232     }
3233 
3234     function mint(
3235         uint256 quantity,
3236         uint256 seedlings,
3237         uint256[] calldata bonsai,
3238         uint256 roots,
3239         uint256 reservedAmount,
3240         bytes32[] calldata proof,
3241         bool useApe,
3242         bool isBonsaiOwner
3243     ) external payable {
3244         require(OPEN_BONSAI, "Minting not allowed.");
3245         require(quantity > 0, "Must mint at least 1.");
3246         require(
3247             seedlings == bonsai.length + roots,
3248             "Invalid selection for Ancestral Seedlings."
3249         );
3250 
3251         uint256 allowed = getMintAllowance(
3252             msg.sender,
3253             reservedAmount,
3254             proof,
3255             isBonsaiOwner
3256         ) - _numberMinted(msg.sender);
3257 
3258         require(allowed > 0, "You can't mint any Forest Spirits.");
3259 
3260         // Limit buys
3261         if (quantity > allowed) {
3262             quantity = allowed;
3263         }
3264 
3265         // Limit buys that exceed MAX_SUPPLY
3266         if (quantity + _totalMinted() > MAX_SUPPLY) {
3267             quantity = MAX_SUPPLY - _totalMinted();
3268         }
3269 
3270         if (!useApe) {
3271             // Ensure enough ETH
3272             if (isBonsaiOwner) {
3273                 require(
3274                     msg.value >= quantity * PRICE_BONSAI,
3275                     "Not enough ETH sent."
3276                 );
3277             } else {
3278                 require(msg.value >= quantity * PRICE, "Not enough ETH sent.");
3279             }
3280         } else {
3281             require(msg.value == 0, "Sent ETH but buying with APE.");
3282         }
3283 
3284         // Log data for Ancestral Seedlings
3285         handleAncestralSeedlings(quantity, seedlings, bonsai, roots);
3286 
3287         // Mint
3288         _safeMint(msg.sender, quantity);
3289 
3290         if (!useApe) {
3291             // Return any remaining ether after the buy
3292             uint256 remaining = msg.value -
3293                 (
3294                     isBonsaiOwner
3295                         ? (quantity * PRICE_BONSAI)
3296                         : (quantity * PRICE)
3297                 );
3298             if (remaining > 0) {
3299                 (bool success, ) = msg.sender.call{value: remaining}("");
3300                 require(success);
3301             }
3302         } else {
3303             APE_TOKEN.transferFrom(msg.sender, TREASURY, quantity * APE_PRICE);
3304         }
3305     }
3306 
3307     function getMintAllowance(
3308         address user,
3309         uint256 amount,
3310         bytes32[] calldata proof,
3311         bool isBonsaiOwner
3312     ) public view returns (uint256) {
3313         bytes32 leaf = keccak256(abi.encodePacked(user, amount));
3314         bool isValidLeaf = MerkleProof.verify(
3315             proof,
3316             !isBonsaiOwner && OPEN_PARTNER
3317                 ? PARTNER_MERKLE_ROOT
3318                 : BONSAI_MERKLE_ROOT,
3319             leaf
3320         );
3321         if (!isValidLeaf) {
3322             amount = 0;
3323         }
3324         if (!OPEN_PUBLIC) {
3325             console.log(amount);
3326             return amount;
3327         } else {
3328             return WALLET_MINT_LIMIT + amount;
3329         }
3330     }
3331 
3332     function getNumberMinted(address _address) external view returns (uint256) {
3333         return _numberMinted(_address);
3334     }
3335 
3336     function handleAncestralSeedlings(
3337         uint256 quantity,
3338         uint256 seedlings,
3339         uint256[] calldata bonsai,
3340         uint256 roots
3341     ) private {
3342         uint256 maxSeedlings = Math.min(quantity, seedlings);
3343         uint256 usedSeedlings = 0;
3344         if (maxSeedlings == 0) {
3345             return;
3346         }
3347         uint256 id = _currentIndex;
3348         roots = Math.min(roots, ROOTS.balanceOf(msg.sender, 1));
3349         for (uint256 i = 0; i < roots; ++i) {
3350             if (usedSeedlings >= maxSeedlings) {
3351                 break;
3352             }
3353             emit AncestralSeedlingMint(id, address(ROOTS), 1);
3354             ++id;
3355             ++usedSeedlings;
3356         }
3357         for (uint256 i = 0; i < bonsai.length; ++i) {
3358             if (usedSeedlings >= maxSeedlings) {
3359                 break;
3360             }
3361             if (BONSAI.ownerOf(bonsai[i]) != msg.sender) {
3362                 continue;
3363             }
3364             emit AncestralSeedlingMint(id, address(BONSAI), bonsai[i]);
3365             ++id;
3366             ++usedSeedlings;
3367         }
3368         SEEDLING.safeTransferFrom(
3369             msg.sender,
3370             BURN_ADDRESS,
3371             1,
3372             usedSeedlings,
3373             ""
3374         );
3375     }
3376 
3377     function withdraw() external onlyCreators {
3378         uint256 bal = address(this).balance;
3379         payable(address(TREASURY)).call{value: bal}("");
3380     }
3381 
3382     function withdrawToken(address _address) external onlyCreators {
3383         IERC20 token = IERC20(_address);
3384         token.transferFrom(
3385             address(this),
3386             TREASURY,
3387             token.balanceOf(address(this))
3388         );
3389     }
3390 
3391     // ===
3392     // Token URI.
3393     // ===
3394 
3395     function _baseURI() internal view override returns (string memory) {
3396         return BASE_URI;
3397     }
3398 
3399     function tokenURI(uint256 tokenId)
3400         public
3401         view
3402         override
3403         returns (string memory)
3404     {
3405         string memory overrideTokenUri = tokenUriOverride[tokenId];
3406         if (bytes(overrideTokenUri).length == 0) {
3407             return super.tokenURI(tokenId);
3408         } else {
3409             return overrideTokenUri;
3410         }
3411     }
3412 
3413     // ===
3414     // Contract URI.
3415     // ===
3416 
3417     function contractURI() public view returns (string memory) {
3418         return CONTRACT_URI;
3419     }
3420 
3421     // ===
3422     // Setters.
3423     // ===
3424 
3425     function setTokenUri(uint256[] calldata ids, string[] calldata uris)
3426         public
3427         onlyOwner
3428     {
3429         for (uint256 i = 0; i < ids.length; i++) {
3430             tokenUriOverride[ids[i]] = uris[i];
3431         }
3432     }
3433 
3434     function setBaseUri(string calldata _baseUri) public onlyOwner {
3435         BASE_URI = _baseUri;
3436     }
3437 
3438     function setBonsaiMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
3439         BONSAI_MERKLE_ROOT = _merkleRoot;
3440     }
3441 
3442     function setPartnerMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
3443         PARTNER_MERKLE_ROOT = _merkleRoot;
3444     }
3445 
3446     function setOpenBonsai(bool _open) public onlyOwner {
3447         OPEN_BONSAI = _open;
3448     }
3449 
3450     function setOpenPartner(bool _open) public onlyOwner {
3451         OPEN_PARTNER = _open;
3452     }
3453 
3454     function setOpenPublic(bool _open) public onlyOwner {
3455         OPEN_PUBLIC = _open;
3456     }
3457 
3458     function setPrice(uint256 _price) public onlyOwner {
3459         PRICE = _price;
3460     }
3461 
3462     function setPriceBonsai(uint256 _price) public onlyOwner {
3463         PRICE_BONSAI = _price;
3464     }
3465 
3466     function setWalletMintLimit(uint256 _walletMintLimit) public onlyOwner {
3467         WALLET_MINT_LIMIT = _walletMintLimit;
3468     }
3469 
3470     function setBurnAddress(address _burnAddress) public onlyOwner {
3471         BURN_ADDRESS = _burnAddress;
3472     }
3473 
3474     function setContractUri(string calldata _contractUri) public onlyOwner {
3475         CONTRACT_URI = _contractUri;
3476     }
3477 
3478     function setApePrice(uint256 _price) public onlyOwner {
3479         APE_PRICE = _price;
3480     }
3481 
3482     function setApeToken(address _address) public onlyOwner {
3483         APE_TOKEN = IERC20(_address);
3484     }
3485 
3486     function setTreasury(address _address) public onlyOwner {
3487         TREASURY = _address;
3488     }
3489 
3490     function setCreator(uint256 i, address _address) public onlyOwner {
3491         if (i == 0) {
3492             CREATOR_1 = _address;
3493         } else if (i == 1) {
3494             CREATOR_2 = _address;
3495         } else if (i == 2) {
3496             CREATOR_3 = _address;
3497         }
3498     }
3499 }