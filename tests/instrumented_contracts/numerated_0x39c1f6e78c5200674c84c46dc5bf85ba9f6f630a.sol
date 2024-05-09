1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
4 
5 // SPDX-License-Identifier: MIT
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
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
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
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
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
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
237 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
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
458 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
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
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
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
557 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
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
588 // File contracts/ERC721A.sol
589 
590 
591 // Creator: Chiru Labs
592 
593 pragma solidity ^0.8.4;
594 error ApprovalCallerNotOwnerNorApproved();
595 error ApprovalQueryForNonexistentToken();
596 error ApproveToCaller();
597 error ApprovalToCurrentOwner();
598 error BalanceQueryForZeroAddress();
599 error MintToZeroAddress();
600 error MintZeroQuantity();
601 error OwnerQueryForNonexistentToken();
602 error TransferCallerNotOwnerNorApproved();
603 error TransferFromIncorrectOwner();
604 error TransferToNonERC721ReceiverImplementer();
605 error TransferToZeroAddress();
606 error URIQueryForNonexistentToken();
607 
608 /**
609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
610  * the Metadata extension. Built to optimize for lower gas during batch mints.
611  *
612  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
613  *
614  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
615  *
616  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
617  */
618 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
619     using Address for address;
620     using Strings for uint256;
621 
622     // Compiler will pack this into a single 256bit word.
623     struct TokenOwnership {
624         // The address of the owner.
625         address addr;
626         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
627         uint64 startTimestamp;
628         // Whether the token has been burned.
629         bool burned;
630     }
631 
632     // Compiler will pack this into a single 256bit word.
633     struct AddressData {
634         // Realistically, 2**64-1 is more than enough.
635         uint64 balance;
636         // Keeps track of mint count with minimal overhead for tokenomics.
637         uint64 numberMinted;
638         // Keeps track of burn count with minimal overhead for tokenomics.
639         uint64 numberBurned;
640     }
641 
642     // The tokenId of the next token to be minted.
643     uint256 internal _currentIndex;
644 
645     // The number of tokens burned.
646     uint256 internal _burnCounter;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     // Mapping from token ID to ownership details
655     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
656     mapping(uint256 => TokenOwnership) internal _ownerships;
657 
658     // Mapping owner address to address data
659     mapping(address => AddressData) private _addressData;
660 
661     // Mapping from token ID to approved address
662     mapping(uint256 => address) private _tokenApprovals;
663 
664     // Mapping from owner to operator approvals
665     mapping(address => mapping(address => bool)) private _operatorApprovals;
666 
667     constructor(string memory name_, string memory symbol_) {
668         _name = name_;
669         _symbol = symbol_;
670         _currentIndex = _startTokenId();
671     }
672 
673     /**
674      * To change the starting tokenId, please override this function.
675      */
676     function _startTokenId() internal view virtual returns (uint256) {
677         return 0;
678     }
679 
680     /**
681      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
682      */
683     function totalSupply() public view returns (uint256) {
684         // Counter underflow is impossible as _burnCounter cannot be incremented
685         // more than _currentIndex - _startTokenId() times
686         unchecked {
687             return _currentIndex - _burnCounter - _startTokenId();
688         }
689     }
690 
691     /**
692      * Returns the total amount of tokens minted in the contract.
693      */
694     function _totalMinted() internal view returns (uint256) {
695         // Counter underflow is impossible as _currentIndex does not decrement,
696         // and it is initialized to _startTokenId()
697         unchecked {
698             return _currentIndex - _startTokenId();
699         }
700     }
701 
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
706         return
707             interfaceId == type(IERC721).interfaceId ||
708             interfaceId == type(IERC721Metadata).interfaceId ||
709             super.supportsInterface(interfaceId);
710     }
711 
712     /**
713      * @dev See {IERC721-balanceOf}.
714      */
715     function balanceOf(address owner) public view override returns (uint256) {
716         if (owner == address(0)) revert BalanceQueryForZeroAddress();
717         return uint256(_addressData[owner].balance);
718     }
719 
720     /**
721      * Returns the number of tokens minted by `owner`.
722      */
723     function _numberMinted(address owner) internal view returns (uint256) {
724         return uint256(_addressData[owner].numberMinted);
725     }
726 
727     /**
728      * Returns the number of tokens burned by or on behalf of `owner`.
729      */
730     function _numberBurned(address owner) internal view returns (uint256) {
731         return uint256(_addressData[owner].numberBurned);
732     }
733 
734     /**
735      * Gas spent here starts off proportional to the maximum mint batch size.
736      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
737      */
738     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
739         uint256 curr = tokenId;
740 
741         unchecked {
742             if (_startTokenId() <= curr && curr < _currentIndex) {
743                 TokenOwnership memory ownership = _ownerships[curr];
744                 if (!ownership.burned) {
745                     if (ownership.addr != address(0)) {
746                         return ownership;
747                     }
748                     // Invariant:
749                     // There will always be an ownership that has an address and is not burned
750                     // before an ownership that does not have an address and is not burned.
751                     // Hence, curr will not underflow.
752                     while (true) {
753                         curr--;
754                         ownership = _ownerships[curr];
755                         if (ownership.addr != address(0)) {
756                             return ownership;
757                         }
758                     }
759                 }
760             }
761         }
762         revert OwnerQueryForNonexistentToken();
763     }
764 
765     /**
766      * @dev See {IERC721-ownerOf}.
767      */
768     function ownerOf(uint256 tokenId) public view override returns (address) {
769         return _ownershipOf(tokenId).addr;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-name}.
774      */
775     function name() public view virtual override returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-symbol}.
781      */
782     function symbol() public view virtual override returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-tokenURI}.
788      */
789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
790         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
791 
792         string memory baseURI = _baseURI();
793         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
794     }
795 
796     /**
797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
799      * by default, can be overriden in child contracts.
800      */
801     function _baseURI() internal view virtual returns (string memory) {
802         return '';
803     }
804 
805     /**
806      * @dev See {IERC721-approve}.
807      */
808     function approve(address to, uint256 tokenId) public override {
809         address owner = ERC721A.ownerOf(tokenId);
810         if (to == owner) revert ApprovalToCurrentOwner();
811 
812         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
813             revert ApprovalCallerNotOwnerNorApproved();
814         }
815 
816         _approve(to, tokenId, owner);
817     }
818 
819     /**
820      * @dev See {IERC721-getApproved}.
821      */
822     function getApproved(uint256 tokenId) public view override returns (address) {
823         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
824 
825         return _tokenApprovals[tokenId];
826     }
827 
828     /**
829      * @dev See {IERC721-setApprovalForAll}.
830      */
831     function setApprovalForAll(address operator, bool approved) public virtual override {
832         if (operator == _msgSender()) revert ApproveToCaller();
833 
834         _operatorApprovals[_msgSender()][operator] = approved;
835         emit ApprovalForAll(_msgSender(), operator, approved);
836     }
837 
838     /**
839      * @dev See {IERC721-isApprovedForAll}.
840      */
841     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
842         return _operatorApprovals[owner][operator];
843     }
844 
845     /**
846      * @dev See {IERC721-transferFrom}.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         _transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         safeTransferFrom(from, to, tokenId, '');
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) public virtual override {
876         _transfer(from, to, tokenId);
877         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
878             revert TransferToNonERC721ReceiverImplementer();
879         }
880     }
881 
882     /**
883      * @dev Returns whether `tokenId` exists.
884      *
885      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
886      *
887      * Tokens start existing when they are minted (`_mint`),
888      */
889     function _exists(uint256 tokenId) internal view returns (bool) {
890         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
891             !_ownerships[tokenId].burned;
892     }
893 
894     function _safeMint(address to, uint256 quantity) internal {
895         _safeMint(to, quantity, '');
896     }
897 
898     /**
899      * @dev Safely mints `quantity` tokens and transfers them to `to`.
900      *
901      * Requirements:
902      *
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
904      * - `quantity` must be greater than 0.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _safeMint(
909         address to,
910         uint256 quantity,
911         bytes memory _data
912     ) internal {
913         _mint(to, quantity, _data, true);
914     }
915 
916     /**
917      * @dev Mints `quantity` tokens and transfers them to `to`.
918      *
919      * Requirements:
920      *
921      * - `to` cannot be the zero address.
922      * - `quantity` must be greater than 0.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _mint(
927         address to,
928         uint256 quantity,
929         bytes memory _data,
930         bool safe
931     ) internal {
932         uint256 startTokenId = _currentIndex;
933         if (to == address(0)) revert MintToZeroAddress();
934         if (quantity == 0) revert MintZeroQuantity();
935 
936         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
937 
938         // Overflows are incredibly unrealistic.
939         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
940         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
941         unchecked {
942             _addressData[to].balance += uint64(quantity);
943             _addressData[to].numberMinted += uint64(quantity);
944 
945             _ownerships[startTokenId].addr = to;
946             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
947 
948             uint256 updatedIndex = startTokenId;
949             uint256 end = updatedIndex + quantity;
950 
951             if (safe && to.isContract()) {
952                 do {
953                     emit Transfer(address(0), to, updatedIndex);
954                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
955                         revert TransferToNonERC721ReceiverImplementer();
956                     }
957                 } while (updatedIndex != end);
958                 // Reentrancy protection
959                 if (_currentIndex != startTokenId) revert();
960             } else {
961                 do {
962                     emit Transfer(address(0), to, updatedIndex++);
963                 } while (updatedIndex != end);
964             }
965             _currentIndex = updatedIndex;
966         }
967         _afterTokenTransfers(address(0), to, startTokenId, quantity);
968     }
969 
970     /**
971      * @dev Transfers `tokenId` from `from` to `to`.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must be owned by `from`.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _transfer(
981         address from,
982         address to,
983         uint256 tokenId
984     ) private {
985         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
986 
987         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
988 
989         bool isApprovedOrOwner = (_msgSender() == from ||
990             isApprovedForAll(from, _msgSender()) ||
991             getApproved(tokenId) == _msgSender());
992 
993         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
994         if (to == address(0)) revert TransferToZeroAddress();
995 
996         _beforeTokenTransfers(from, to, tokenId, 1);
997 
998         // Clear approvals from the previous owner
999         _approve(address(0), tokenId, from);
1000 
1001         // Underflow of the sender's balance is impossible because we check for
1002         // ownership above and the recipient's balance can't realistically overflow.
1003         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1004         unchecked {
1005             _addressData[from].balance -= 1;
1006             _addressData[to].balance += 1;
1007 
1008             TokenOwnership storage currSlot = _ownerships[tokenId];
1009             currSlot.addr = to;
1010             currSlot.startTimestamp = uint64(block.timestamp);
1011 
1012             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1013             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1014             uint256 nextTokenId = tokenId + 1;
1015             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1016             if (nextSlot.addr == address(0)) {
1017                 // This will suffice for checking _exists(nextTokenId),
1018                 // as a burned slot cannot contain the zero address.
1019                 if (nextTokenId != _currentIndex) {
1020                     nextSlot.addr = from;
1021                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1022                 }
1023             }
1024         }
1025 
1026         emit Transfer(from, to, tokenId);
1027         _afterTokenTransfers(from, to, tokenId, 1);
1028     }
1029 
1030     /**
1031      * @dev This is equivalent to _burn(tokenId, false)
1032      */
1033     function _burn(uint256 tokenId) internal virtual {
1034         _burn(tokenId, false);
1035     }
1036 
1037     /**
1038      * @dev Destroys `tokenId`.
1039      * The approval is cleared when the token is burned.
1040      *
1041      * Requirements:
1042      *
1043      * - `tokenId` must exist.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1048         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1049 
1050         address from = prevOwnership.addr;
1051 
1052         if (approvalCheck) {
1053             bool isApprovedOrOwner = (_msgSender() == from ||
1054                 isApprovedForAll(from, _msgSender()) ||
1055                 getApproved(tokenId) == _msgSender());
1056 
1057             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1058         }
1059 
1060         _beforeTokenTransfers(from, address(0), tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, from);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1068         unchecked {
1069             AddressData storage addressData = _addressData[from];
1070             addressData.balance -= 1;
1071             addressData.numberBurned += 1;
1072 
1073             // Keep track of who burned the token, and the timestamp of burning.
1074             TokenOwnership storage currSlot = _ownerships[tokenId];
1075             currSlot.addr = from;
1076             currSlot.startTimestamp = uint64(block.timestamp);
1077             currSlot.burned = true;
1078 
1079             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1080             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1081             uint256 nextTokenId = tokenId + 1;
1082             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1083             if (nextSlot.addr == address(0)) {
1084                 // This will suffice for checking _exists(nextTokenId),
1085                 // as a burned slot cannot contain the zero address.
1086                 if (nextTokenId != _currentIndex) {
1087                     nextSlot.addr = from;
1088                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1089                 }
1090             }
1091         }
1092 
1093         emit Transfer(from, address(0), tokenId);
1094         _afterTokenTransfers(from, address(0), tokenId, 1);
1095 
1096         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1097         unchecked {
1098             _burnCounter++;
1099         }
1100     }
1101 
1102     /**
1103      * @dev Approve `to` to operate on `tokenId`
1104      *
1105      * Emits a {Approval} event.
1106      */
1107     function _approve(
1108         address to,
1109         uint256 tokenId,
1110         address owner
1111     ) private {
1112         _tokenApprovals[tokenId] = to;
1113         emit Approval(owner, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1118      *
1119      * @param from address representing the previous owner of the given token ID
1120      * @param to target address that will receive the tokens
1121      * @param tokenId uint256 ID of the token to be transferred
1122      * @param _data bytes optional data to send along with the call
1123      * @return bool whether the call correctly returned the expected magic value
1124      */
1125     function _checkContractOnERC721Received(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) private returns (bool) {
1131         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1132             return retval == IERC721Receiver(to).onERC721Received.selector;
1133         } catch (bytes memory reason) {
1134             if (reason.length == 0) {
1135                 revert TransferToNonERC721ReceiverImplementer();
1136             } else {
1137                 assembly {
1138                     revert(add(32, reason), mload(reason))
1139                 }
1140             }
1141         }
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1146      * And also called before burning one token.
1147      *
1148      * startTokenId - the first token id to be transferred
1149      * quantity - the amount to be transferred
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, `tokenId` will be burned by `from`.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _beforeTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 
1166     /**
1167      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1168      * minting.
1169      * And also called after one token has been burned.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` has been minted for `to`.
1179      * - When `to` is zero, `tokenId` has been burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _afterTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 }
1189 
1190 
1191 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1192 
1193 
1194 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 /**
1199  * @dev Contract module which provides a basic access control mechanism, where
1200  * there is an account (an owner) that can be granted exclusive access to
1201  * specific functions.
1202  *
1203  * By default, the owner account will be the one that deploys the contract. This
1204  * can later be changed with {transferOwnership}.
1205  *
1206  * This module is used through inheritance. It will make available the modifier
1207  * `onlyOwner`, which can be applied to your functions to restrict their use to
1208  * the owner.
1209  */
1210 abstract contract Ownable is Context {
1211     address private _owner;
1212 
1213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1214 
1215     /**
1216      * @dev Initializes the contract setting the deployer as the initial owner.
1217      */
1218     constructor() {
1219         _transferOwnership(_msgSender());
1220     }
1221 
1222     /**
1223      * @dev Returns the address of the current owner.
1224      */
1225     function owner() public view virtual returns (address) {
1226         return _owner;
1227     }
1228 
1229     /**
1230      * @dev Throws if called by any account other than the owner.
1231      */
1232     modifier onlyOwner() {
1233         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1234         _;
1235     }
1236 
1237     /**
1238      * @dev Leaves the contract without owner. It will not be possible to call
1239      * `onlyOwner` functions anymore. Can only be called by the current owner.
1240      *
1241      * NOTE: Renouncing ownership will leave the contract without an owner,
1242      * thereby removing any functionality that is only available to the owner.
1243      */
1244     function renounceOwnership() public virtual onlyOwner {
1245         _transferOwnership(address(0));
1246     }
1247 
1248     /**
1249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1250      * Can only be called by the current owner.
1251      */
1252     function transferOwnership(address newOwner) public virtual onlyOwner {
1253         require(newOwner != address(0), "Ownable: new owner is the zero address");
1254         _transferOwnership(newOwner);
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Internal function without access restriction.
1260      */
1261     function _transferOwnership(address newOwner) internal virtual {
1262         address oldOwner = _owner;
1263         _owner = newOwner;
1264         emit OwnershipTransferred(oldOwner, newOwner);
1265     }
1266 }
1267 
1268 
1269 // File contracts/MerkleProof.sol
1270 
1271 
1272 
1273 pragma solidity ^0.8.4;
1274 
1275 /**
1276  * @dev These functions deal with verification of Merkle trees (hash trees),
1277  */
1278 library MerkleProof {
1279     /**
1280      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1281      * defined by `root`. For this, a `proof` must be provided, containing
1282      * sibling hashes on the branch from the leaf to the root of the tree. Each
1283      * pair of leaves and each pair of pre-images are assumed to be sorted.
1284      */
1285     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1286         bytes32 computedHash = leaf;
1287 
1288         for (uint256 i = 0; i < proof.length; i++) {
1289             bytes32 proofElement = proof[i];
1290 
1291             if (computedHash <= proofElement) {
1292                 // Hash(current computed hash + current element of the proof)
1293                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1294             } else {
1295                 // Hash(current element of the proof + current computed hash)
1296                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1297             }
1298         }
1299 
1300         // Check if the computed hash (root) is equal to the provided root
1301         return computedHash == root;
1302     }
1303 }
1304 
1305 
1306 // File contracts/BaoElder.sol
1307 
1308 pragma solidity ^0.8.4;
1309 contract BaoElder is ERC721A, Ownable {
1310         using Strings for uint256;
1311         using MerkleProof for bytes32[];
1312 
1313         uint256 public constant MAX_SUPPLY = 40000;
1314         uint256 public constant MAX_PER_CALL = 1;
1315 
1316         bytes32 public merkleRoot;
1317 
1318         string public uri;
1319         string public suffix;
1320 
1321         mapping(address => bool) public whitelistClaimed;
1322 
1323         uint256 public whitelistSale;
1324 
1325         event BaoGMinted(uint256 indexed tokenId, address indexed receiver);
1326 
1327         constructor(uint256 _whitelistSale, bytes32 _root) ERC721A("BaoElder", "BaoG") {
1328                 whitelistSale = _whitelistSale;
1329                 merkleRoot = _root;
1330         }
1331 
1332         function _baseURI() internal override view returns (string memory) {
1333                 return uri;
1334         }
1335 
1336     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1337         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1338 
1339         string memory baseURI = _baseURI();
1340         return bytes(baseURI).length > 0
1341             ? string(abi.encodePacked(baseURI, suffix))
1342             : '';
1343     }
1344 
1345         function updateURI(string memory _newURI) public onlyOwner {
1346                 uri = _newURI;
1347         }
1348 
1349         function updateWhitelistSale(uint256 _whitelistSale) public onlyOwner {
1350                 whitelistSale = _whitelistSale;
1351         }
1352 
1353         function updateMerkleRoot(bytes32 _root) external onlyOwner {
1354         merkleRoot = _root;
1355     }
1356 
1357         function updateSuffix(string memory _suffix) public onlyOwner {
1358                 suffix = _suffix;
1359         }
1360 
1361         function mintBaoGWithSignature(bytes32[] calldata _proof) public {
1362                 require(block.timestamp >= whitelistSale, "Public sale not ready");
1363                 require(!whitelistClaimed[msg.sender], "Caller not part of tree");
1364 
1365                 bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1366                 require (MerkleProof.verify(_proof, merkleRoot, leaf), "Invalid proof");
1367 
1368                 whitelistClaimed[msg.sender] = true;
1369 
1370     uint256 supply = totalSupply();
1371     require(supply + 1 <= MAX_SUPPLY, "Can't mint over limit");
1372     _safeMint(msg.sender, 1);
1373     emit BaoGMinted(supply + 1, msg.sender);
1374  }
1375 
1376         function fetchEther() external onlyOwner {
1377                 payable(msg.sender).transfer(address(this).balance);
1378         }
1379 }