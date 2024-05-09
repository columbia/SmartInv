1 // Sources flattened with hardhat v2.9.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
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
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize, which returns 0 for contracts in
267         // construction, since the code is only stored at the end of the
268         // constructor execution.
269 
270         uint256 size;
271         assembly {
272             size := extcodesize(account)
273         }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 
458 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
459 
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
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev String operations.
495  */
496 library Strings {
497     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
501      */
502     function toString(uint256 value) internal pure returns (string memory) {
503         // Inspired by OraclizeAPI's implementation - MIT licence
504         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
505 
506         if (value == 0) {
507             return "0";
508         }
509         uint256 temp = value;
510         uint256 digits;
511         while (temp != 0) {
512             digits++;
513             temp /= 10;
514         }
515         bytes memory buffer = new bytes(digits);
516         while (value != 0) {
517             digits -= 1;
518             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
519             value /= 10;
520         }
521         return string(buffer);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
526      */
527     function toHexString(uint256 value) internal pure returns (string memory) {
528         if (value == 0) {
529             return "0x00";
530         }
531         uint256 temp = value;
532         uint256 length = 0;
533         while (temp != 0) {
534             length++;
535             temp >>= 8;
536         }
537         return toHexString(value, length);
538     }
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
542      */
543     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
544         bytes memory buffer = new bytes(2 * length + 2);
545         buffer[0] = "0";
546         buffer[1] = "x";
547         for (uint256 i = 2 * length + 1; i > 1; --i) {
548             buffer[i] = _HEX_SYMBOLS[value & 0xf];
549             value >>= 4;
550         }
551         require(value == 0, "Strings: hex length insufficient");
552         return string(buffer);
553     }
554 }
555 
556 
557 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165).interfaceId;
584     }
585 }
586 
587 
588 // File erc721a/contracts/ERC721A.sol@v3.1.0
589 
590 
591 // Creator: Chiru Labs
592 
593 pragma solidity ^0.8.4;
594 
595 
596 
597 
598 
599 
600 
601 error ApprovalCallerNotOwnerNorApproved();
602 error ApprovalQueryForNonexistentToken();
603 error ApproveToCaller();
604 error ApprovalToCurrentOwner();
605 error BalanceQueryForZeroAddress();
606 error MintToZeroAddress();
607 error MintZeroQuantity();
608 error OwnerQueryForNonexistentToken();
609 error TransferCallerNotOwnerNorApproved();
610 error TransferFromIncorrectOwner();
611 error TransferToNonERC721ReceiverImplementer();
612 error TransferToZeroAddress();
613 error URIQueryForNonexistentToken();
614 
615 /**
616  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
617  * the Metadata extension. Built to optimize for lower gas during batch mints.
618  *
619  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
620  *
621  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
622  *
623  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
624  */
625 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
626     using Address for address;
627     using Strings for uint256;
628 
629     // Compiler will pack this into a single 256bit word.
630     struct TokenOwnership {
631         // The address of the owner.
632         address addr;
633         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
634         uint64 startTimestamp;
635         // Whether the token has been burned.
636         bool burned;
637     }
638 
639     // Compiler will pack this into a single 256bit word.
640     struct AddressData {
641         // Realistically, 2**64-1 is more than enough.
642         uint64 balance;
643         // Keeps track of mint count with minimal overhead for tokenomics.
644         uint64 numberMinted;
645         // Keeps track of burn count with minimal overhead for tokenomics.
646         uint64 numberBurned;
647         // For miscellaneous variable(s) pertaining to the address
648         // (e.g. number of whitelist mint slots used).
649         // If there are multiple variables, please pack them into a uint64.
650         uint64 aux;
651     }
652 
653     // The tokenId of the next token to be minted.
654     uint256 internal _currentIndex;
655 
656     // The number of tokens burned.
657     uint256 internal _burnCounter;
658 
659     // Token name
660     string private _name;
661 
662     // Token symbol
663     string private _symbol;
664 
665     // Mapping from token ID to ownership details
666     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
667     mapping(uint256 => TokenOwnership) internal _ownerships;
668 
669     // Mapping owner address to address data
670     mapping(address => AddressData) private _addressData;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     constructor(string memory name_, string memory symbol_) {
679         _name = name_;
680         _symbol = symbol_;
681         _currentIndex = _startTokenId();
682     }
683 
684     /**
685      * To change the starting tokenId, please override this function.
686      */
687     function _startTokenId() internal view virtual returns (uint256) {
688         return 0;
689     }
690 
691     /**
692      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
693      */
694     function totalSupply() public view returns (uint256) {
695         // Counter underflow is impossible as _burnCounter cannot be incremented
696         // more than _currentIndex - _startTokenId() times
697         unchecked {
698             return _currentIndex - _burnCounter - _startTokenId();
699         }
700     }
701 
702     /**
703      * Returns the total amount of tokens minted in the contract.
704      */
705     function _totalMinted() internal view returns (uint256) {
706         // Counter underflow is impossible as _currentIndex does not decrement,
707         // and it is initialized to _startTokenId()
708         unchecked {
709             return _currentIndex - _startTokenId();
710         }
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
717         return
718             interfaceId == type(IERC721).interfaceId ||
719             interfaceId == type(IERC721Metadata).interfaceId ||
720             super.supportsInterface(interfaceId);
721     }
722 
723     /**
724      * @dev See {IERC721-balanceOf}.
725      */
726     function balanceOf(address owner) public view override returns (uint256) {
727         if (owner == address(0)) revert BalanceQueryForZeroAddress();
728         return uint256(_addressData[owner].balance);
729     }
730 
731     /**
732      * Returns the number of tokens minted by `owner`.
733      */
734     function _numberMinted(address owner) internal view returns (uint256) {
735         return uint256(_addressData[owner].numberMinted);
736     }
737 
738     /**
739      * Returns the number of tokens burned by or on behalf of `owner`.
740      */
741     function _numberBurned(address owner) internal view returns (uint256) {
742         return uint256(_addressData[owner].numberBurned);
743     }
744 
745     /**
746      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
747      */
748     function _getAux(address owner) internal view returns (uint64) {
749         return _addressData[owner].aux;
750     }
751 
752     /**
753      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
754      * If there are multiple variables, please pack them into a uint64.
755      */
756     function _setAux(address owner, uint64 aux) internal {
757         _addressData[owner].aux = aux;
758     }
759 
760     /**
761      * Gas spent here starts off proportional to the maximum mint batch size.
762      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
763      */
764     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
765         uint256 curr = tokenId;
766 
767         unchecked {
768             if (_startTokenId() <= curr && curr < _currentIndex) {
769                 TokenOwnership memory ownership = _ownerships[curr];
770                 if (!ownership.burned) {
771                     if (ownership.addr != address(0)) {
772                         return ownership;
773                     }
774                     // Invariant:
775                     // There will always be an ownership that has an address and is not burned
776                     // before an ownership that does not have an address and is not burned.
777                     // Hence, curr will not underflow.
778                     while (true) {
779                         curr--;
780                         ownership = _ownerships[curr];
781                         if (ownership.addr != address(0)) {
782                             return ownership;
783                         }
784                     }
785                 }
786             }
787         }
788         revert OwnerQueryForNonexistentToken();
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view override returns (address) {
795         return _ownershipOf(tokenId).addr;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
816         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
817 
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overriden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return '';
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public override {
835         address owner = ERC721A.ownerOf(tokenId);
836         if (to == owner) revert ApprovalToCurrentOwner();
837 
838         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
839             revert ApprovalCallerNotOwnerNorApproved();
840         }
841 
842         _approve(to, tokenId, owner);
843     }
844 
845     /**
846      * @dev See {IERC721-getApproved}.
847      */
848     function getApproved(uint256 tokenId) public view override returns (address) {
849         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
850 
851         return _tokenApprovals[tokenId];
852     }
853 
854     /**
855      * @dev See {IERC721-setApprovalForAll}.
856      */
857     function setApprovalForAll(address operator, bool approved) public virtual override {
858         if (operator == _msgSender()) revert ApproveToCaller();
859 
860         _operatorApprovals[_msgSender()][operator] = approved;
861         emit ApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         _transfer(from, to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         safeTransferFrom(from, to, tokenId, '');
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) public virtual override {
902         _transfer(from, to, tokenId);
903         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
904             revert TransferToNonERC721ReceiverImplementer();
905         }
906     }
907 
908     /**
909      * @dev Returns whether `tokenId` exists.
910      *
911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
912      *
913      * Tokens start existing when they are minted (`_mint`),
914      */
915     function _exists(uint256 tokenId) internal view returns (bool) {
916         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
917             !_ownerships[tokenId].burned;
918     }
919 
920     function _safeMint(address to, uint256 quantity) internal {
921         _safeMint(to, quantity, '');
922     }
923 
924     /**
925      * @dev Safely mints `quantity` tokens and transfers them to `to`.
926      *
927      * Requirements:
928      *
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
930      * - `quantity` must be greater than 0.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeMint(
935         address to,
936         uint256 quantity,
937         bytes memory _data
938     ) internal {
939         _mint(to, quantity, _data, true);
940     }
941 
942     /**
943      * @dev Mints `quantity` tokens and transfers them to `to`.
944      *
945      * Requirements:
946      *
947      * - `to` cannot be the zero address.
948      * - `quantity` must be greater than 0.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _mint(
953         address to,
954         uint256 quantity,
955         bytes memory _data,
956         bool safe
957     ) internal {
958         uint256 startTokenId = _currentIndex;
959         if (to == address(0)) revert MintToZeroAddress();
960         if (quantity == 0) revert MintZeroQuantity();
961 
962         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
963 
964         // Overflows are incredibly unrealistic.
965         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
966         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
967         unchecked {
968             _addressData[to].balance += uint64(quantity);
969             _addressData[to].numberMinted += uint64(quantity);
970 
971             _ownerships[startTokenId].addr = to;
972             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
973 
974             uint256 updatedIndex = startTokenId;
975             uint256 end = updatedIndex + quantity;
976 
977             if (safe && to.isContract()) {
978                 do {
979                     emit Transfer(address(0), to, updatedIndex);
980                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
981                         revert TransferToNonERC721ReceiverImplementer();
982                     }
983                 } while (updatedIndex != end);
984                 // Reentrancy protection
985                 if (_currentIndex != startTokenId) revert();
986             } else {
987                 do {
988                     emit Transfer(address(0), to, updatedIndex++);
989                 } while (updatedIndex != end);
990             }
991             _currentIndex = updatedIndex;
992         }
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) private {
1011         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1012 
1013         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1014 
1015         bool isApprovedOrOwner = (_msgSender() == from ||
1016             isApprovedForAll(from, _msgSender()) ||
1017             getApproved(tokenId) == _msgSender());
1018 
1019         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1020         if (to == address(0)) revert TransferToZeroAddress();
1021 
1022         _beforeTokenTransfers(from, to, tokenId, 1);
1023 
1024         // Clear approvals from the previous owner
1025         _approve(address(0), tokenId, from);
1026 
1027         // Underflow of the sender's balance is impossible because we check for
1028         // ownership above and the recipient's balance can't realistically overflow.
1029         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1030         unchecked {
1031             _addressData[from].balance -= 1;
1032             _addressData[to].balance += 1;
1033 
1034             TokenOwnership storage currSlot = _ownerships[tokenId];
1035             currSlot.addr = to;
1036             currSlot.startTimestamp = uint64(block.timestamp);
1037 
1038             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1039             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1040             uint256 nextTokenId = tokenId + 1;
1041             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1042             if (nextSlot.addr == address(0)) {
1043                 // This will suffice for checking _exists(nextTokenId),
1044                 // as a burned slot cannot contain the zero address.
1045                 if (nextTokenId != _currentIndex) {
1046                     nextSlot.addr = from;
1047                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1048                 }
1049             }
1050         }
1051 
1052         emit Transfer(from, to, tokenId);
1053         _afterTokenTransfers(from, to, tokenId, 1);
1054     }
1055 
1056     /**
1057      * @dev This is equivalent to _burn(tokenId, false)
1058      */
1059     function _burn(uint256 tokenId) internal virtual {
1060         _burn(tokenId, false);
1061     }
1062 
1063     /**
1064      * @dev Destroys `tokenId`.
1065      * The approval is cleared when the token is burned.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must exist.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1074         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1075 
1076         address from = prevOwnership.addr;
1077 
1078         if (approvalCheck) {
1079             bool isApprovedOrOwner = (_msgSender() == from ||
1080                 isApprovedForAll(from, _msgSender()) ||
1081                 getApproved(tokenId) == _msgSender());
1082 
1083             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1084         }
1085 
1086         _beforeTokenTransfers(from, address(0), tokenId, 1);
1087 
1088         // Clear approvals from the previous owner
1089         _approve(address(0), tokenId, from);
1090 
1091         // Underflow of the sender's balance is impossible because we check for
1092         // ownership above and the recipient's balance can't realistically overflow.
1093         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1094         unchecked {
1095             AddressData storage addressData = _addressData[from];
1096             addressData.balance -= 1;
1097             addressData.numberBurned += 1;
1098 
1099             // Keep track of who burned the token, and the timestamp of burning.
1100             TokenOwnership storage currSlot = _ownerships[tokenId];
1101             currSlot.addr = from;
1102             currSlot.startTimestamp = uint64(block.timestamp);
1103             currSlot.burned = true;
1104 
1105             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1106             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1107             uint256 nextTokenId = tokenId + 1;
1108             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1109             if (nextSlot.addr == address(0)) {
1110                 // This will suffice for checking _exists(nextTokenId),
1111                 // as a burned slot cannot contain the zero address.
1112                 if (nextTokenId != _currentIndex) {
1113                     nextSlot.addr = from;
1114                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1115                 }
1116             }
1117         }
1118 
1119         emit Transfer(from, address(0), tokenId);
1120         _afterTokenTransfers(from, address(0), tokenId, 1);
1121 
1122         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1123         unchecked {
1124             _burnCounter++;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Approve `to` to operate on `tokenId`
1130      *
1131      * Emits a {Approval} event.
1132      */
1133     function _approve(
1134         address to,
1135         uint256 tokenId,
1136         address owner
1137     ) private {
1138         _tokenApprovals[tokenId] = to;
1139         emit Approval(owner, to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1144      *
1145      * @param from address representing the previous owner of the given token ID
1146      * @param to target address that will receive the tokens
1147      * @param tokenId uint256 ID of the token to be transferred
1148      * @param _data bytes optional data to send along with the call
1149      * @return bool whether the call correctly returned the expected magic value
1150      */
1151     function _checkContractOnERC721Received(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) private returns (bool) {
1157         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1158             return retval == IERC721Receiver(to).onERC721Received.selector;
1159         } catch (bytes memory reason) {
1160             if (reason.length == 0) {
1161                 revert TransferToNonERC721ReceiverImplementer();
1162             } else {
1163                 assembly {
1164                     revert(add(32, reason), mload(reason))
1165                 }
1166             }
1167         }
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1172      * And also called before burning one token.
1173      *
1174      * startTokenId - the first token id to be transferred
1175      * quantity - the amount to be transferred
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, `tokenId` will be burned by `from`.
1183      * - `from` and `to` are never both zero.
1184      */
1185     function _beforeTokenTransfers(
1186         address from,
1187         address to,
1188         uint256 startTokenId,
1189         uint256 quantity
1190     ) internal virtual {}
1191 
1192     /**
1193      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1194      * minting.
1195      * And also called after one token has been burned.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` has been minted for `to`.
1205      * - When `to` is zero, `tokenId` has been burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _afterTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 }
1215 
1216 
1217 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
1218 
1219 
1220 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1221 
1222 pragma solidity ^0.8.0;
1223 
1224 /**
1225  * @dev Contract module which provides a basic access control mechanism, where
1226  * there is an account (an owner) that can be granted exclusive access to
1227  * specific functions.
1228  *
1229  * By default, the owner account will be the one that deploys the contract. This
1230  * can later be changed with {transferOwnership}.
1231  *
1232  * This module is used through inheritance. It will make available the modifier
1233  * `onlyOwner`, which can be applied to your functions to restrict their use to
1234  * the owner.
1235  */
1236 abstract contract Ownable is Context {
1237     address private _owner;
1238 
1239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1240 
1241     /**
1242      * @dev Initializes the contract setting the deployer as the initial owner.
1243      */
1244     constructor() {
1245         _transferOwnership(_msgSender());
1246     }
1247 
1248     /**
1249      * @dev Returns the address of the current owner.
1250      */
1251     function owner() public view virtual returns (address) {
1252         return _owner;
1253     }
1254 
1255     /**
1256      * @dev Throws if called by any account other than the owner.
1257      */
1258     modifier onlyOwner() {
1259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Leaves the contract without owner. It will not be possible to call
1265      * `onlyOwner` functions anymore. Can only be called by the current owner.
1266      *
1267      * NOTE: Renouncing ownership will leave the contract without an owner,
1268      * thereby removing any functionality that is only available to the owner.
1269      */
1270     function renounceOwnership() public virtual onlyOwner {
1271         _transferOwnership(address(0));
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Can only be called by the current owner.
1277      */
1278     function transferOwnership(address newOwner) public virtual onlyOwner {
1279         require(newOwner != address(0), "Ownable: new owner is the zero address");
1280         _transferOwnership(newOwner);
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Internal function without access restriction.
1286      */
1287     function _transferOwnership(address newOwner) internal virtual {
1288         address oldOwner = _owner;
1289         _owner = newOwner;
1290         emit OwnershipTransferred(oldOwner, newOwner);
1291     }
1292 }
1293 
1294 
1295 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
1296 
1297 
1298 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1299 
1300 pragma solidity ^0.8.0;
1301 
1302 /**
1303  * @dev Contract module that helps prevent reentrant calls to a function.
1304  *
1305  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1306  * available, which can be applied to functions to make sure there are no nested
1307  * (reentrant) calls to them.
1308  *
1309  * Note that because there is a single `nonReentrant` guard, functions marked as
1310  * `nonReentrant` may not call one another. This can be worked around by making
1311  * those functions `private`, and then adding `external` `nonReentrant` entry
1312  * points to them.
1313  *
1314  * TIP: If you would like to learn more about reentrancy and alternative ways
1315  * to protect against it, check out our blog post
1316  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1317  */
1318 abstract contract ReentrancyGuard {
1319     // Booleans are more expensive than uint256 or any type that takes up a full
1320     // word because each write operation emits an extra SLOAD to first read the
1321     // slot's contents, replace the bits taken up by the boolean, and then write
1322     // back. This is the compiler's defense against contract upgrades and
1323     // pointer aliasing, and it cannot be disabled.
1324 
1325     // The values being non-zero value makes deployment a bit more expensive,
1326     // but in exchange the refund on every call to nonReentrant will be lower in
1327     // amount. Since refunds are capped to a percentage of the total
1328     // transaction's gas, it is best to keep them low in cases like this one, to
1329     // increase the likelihood of the full refund coming into effect.
1330     uint256 private constant _NOT_ENTERED = 1;
1331     uint256 private constant _ENTERED = 2;
1332 
1333     uint256 private _status;
1334 
1335     constructor() {
1336         _status = _NOT_ENTERED;
1337     }
1338 
1339     /**
1340      * @dev Prevents a contract from calling itself, directly or indirectly.
1341      * Calling a `nonReentrant` function from another `nonReentrant`
1342      * function is not supported. It is possible to prevent this from happening
1343      * by making the `nonReentrant` function external, and making it call a
1344      * `private` function that does the actual work.
1345      */
1346     modifier nonReentrant() {
1347         // On the first call to nonReentrant, _notEntered will be true
1348         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1349 
1350         // Any calls to nonReentrant after this point will fail
1351         _status = _ENTERED;
1352 
1353         _;
1354 
1355         // By storing the original value once again, a refund is triggered (see
1356         // https://eips.ethereum.org/EIPS/eip-2200)
1357         _status = _NOT_ENTERED;
1358     }
1359 }
1360 
1361 
1362 // File base64-sol/base64.sol@v1.1.0
1363 
1364 
1365 
1366 pragma solidity >=0.6.0;
1367 
1368 /// @title Base64
1369 /// @author Brecht Devos - <brecht@loopring.org>
1370 /// @notice Provides functions for encoding/decoding base64
1371 library Base64 {
1372     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1373     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
1374                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
1375                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
1376                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
1377 
1378     function encode(bytes memory data) internal pure returns (string memory) {
1379         if (data.length == 0) return '';
1380 
1381         // load the table into memory
1382         string memory table = TABLE_ENCODE;
1383 
1384         // multiply by 4/3 rounded up
1385         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1386 
1387         // add some extra buffer at the end required for the writing
1388         string memory result = new string(encodedLen + 32);
1389 
1390         assembly {
1391             // set the actual output length
1392             mstore(result, encodedLen)
1393 
1394             // prepare the lookup table
1395             let tablePtr := add(table, 1)
1396 
1397             // input ptr
1398             let dataPtr := data
1399             let endPtr := add(dataPtr, mload(data))
1400 
1401             // result ptr, jump over length
1402             let resultPtr := add(result, 32)
1403 
1404             // run over the input, 3 bytes at a time
1405             for {} lt(dataPtr, endPtr) {}
1406             {
1407                 // read 3 bytes
1408                 dataPtr := add(dataPtr, 3)
1409                 let input := mload(dataPtr)
1410 
1411                 // write 4 characters
1412                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1413                 resultPtr := add(resultPtr, 1)
1414                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1415                 resultPtr := add(resultPtr, 1)
1416                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
1417                 resultPtr := add(resultPtr, 1)
1418                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
1419                 resultPtr := add(resultPtr, 1)
1420             }
1421 
1422             // padding with '='
1423             switch mod(mload(data), 3)
1424             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
1425             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
1426         }
1427 
1428         return result;
1429     }
1430 
1431     function decode(string memory _data) internal pure returns (bytes memory) {
1432         bytes memory data = bytes(_data);
1433 
1434         if (data.length == 0) return new bytes(0);
1435         require(data.length % 4 == 0, "invalid base64 decoder input");
1436 
1437         // load the table into memory
1438         bytes memory table = TABLE_DECODE;
1439 
1440         // every 4 characters represent 3 bytes
1441         uint256 decodedLen = (data.length / 4) * 3;
1442 
1443         // add some extra buffer at the end required for the writing
1444         bytes memory result = new bytes(decodedLen + 32);
1445 
1446         assembly {
1447             // padding with '='
1448             let lastBytes := mload(add(data, mload(data)))
1449             if eq(and(lastBytes, 0xFF), 0x3d) {
1450                 decodedLen := sub(decodedLen, 1)
1451                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
1452                     decodedLen := sub(decodedLen, 1)
1453                 }
1454             }
1455 
1456             // set the actual output length
1457             mstore(result, decodedLen)
1458 
1459             // prepare the lookup table
1460             let tablePtr := add(table, 1)
1461 
1462             // input ptr
1463             let dataPtr := data
1464             let endPtr := add(dataPtr, mload(data))
1465 
1466             // result ptr, jump over length
1467             let resultPtr := add(result, 32)
1468 
1469             // run over the input, 4 characters at a time
1470             for {} lt(dataPtr, endPtr) {}
1471             {
1472                // read 4 characters
1473                dataPtr := add(dataPtr, 4)
1474                let input := mload(dataPtr)
1475 
1476                // write 3 bytes
1477                let output := add(
1478                    add(
1479                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
1480                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
1481                    add(
1482                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
1483                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
1484                     )
1485                 )
1486                 mstore(resultPtr, shl(232, output))
1487                 resultPtr := add(resultPtr, 3)
1488             }
1489         }
1490 
1491         return result;
1492     }
1493 }
1494 
1495 
1496 // File contracts/XDAOMintPass.sol
1497 
1498 pragma solidity ^0.8.4;
1499 
1500 
1501 
1502 
1503 contract XDAOMintPass is ERC721A, ReentrancyGuard, Ownable {
1504 
1505     bool MINT_ENABLED = false;
1506 
1507     constructor() ERC721A("XDao Mint Pass", "XDMP") Ownable() {}
1508 
1509     function mint() external payable {
1510         require(MINT_ENABLED, "Minting is not enabled for this mint pass right now.");
1511         require(balanceOf(msg.sender) == 0, "Cannot mint to a wallet that already has this mint pass.");
1512 
1513         _safeMint(msg.sender, 2);
1514     }
1515 
1516     function enableMint() public onlyOwner {
1517         MINT_ENABLED = true;
1518     }
1519 
1520     function disableMint() public onlyOwner {
1521         MINT_ENABLED = false;
1522     }
1523 
1524     function mintEnabled() public view returns (bool){
1525         return MINT_ENABLED;
1526     }
1527 
1528     function reserveToAddress(address recipient) public onlyOwner {
1529         _safeMint(recipient, 1000);
1530         enableMint();
1531     }
1532 
1533     function tokenURI(uint tokenId) override public view returns (string memory) {
1534         string memory json;
1535 
1536         if (tokenId % 2 == 0) {
1537             json = Base64.encode(bytes(string(abi.encodePacked('{"name": "xDAO Mint Pass", "description": "Mint pass for xDAO.", "image": "https://api.withcomet.com/comet/uploads/xmp.jpg"}'))));
1538         } else {
1539             json = Base64.encode(bytes(string(abi.encodePacked('{"name": "xDAO Mint Pass +1", "description": "Mint pass +1 for xDAO.", "image": "https://api.withcomet.com/comet/uploads/xmp_plus_one.jpg"}'))));
1540         }
1541 
1542         string memory output = string(abi.encodePacked('data:application/json;base64,', json));
1543         return output;
1544     }
1545 }