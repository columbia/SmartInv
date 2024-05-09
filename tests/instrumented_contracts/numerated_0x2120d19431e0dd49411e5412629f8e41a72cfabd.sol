1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
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
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
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
206 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
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
234 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
237 
238 pragma solidity ^0.8.0;
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
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 
454 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 
480 
481 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev String operations.
489  */
490 library Strings {
491     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
495      */
496     function toString(uint256 value) internal pure returns (string memory) {
497         // Inspired by OraclizeAPI's implementation - MIT licence
498         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
499 
500         if (value == 0) {
501             return "0";
502         }
503         uint256 temp = value;
504         uint256 digits;
505         while (temp != 0) {
506             digits++;
507             temp /= 10;
508         }
509         bytes memory buffer = new bytes(digits);
510         while (value != 0) {
511             digits -= 1;
512             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
513             value /= 10;
514         }
515         return string(buffer);
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
520      */
521     function toHexString(uint256 value) internal pure returns (string memory) {
522         if (value == 0) {
523             return "0x00";
524         }
525         uint256 temp = value;
526         uint256 length = 0;
527         while (temp != 0) {
528             length++;
529             temp >>= 8;
530         }
531         return toHexString(value, length);
532     }
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
536      */
537     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
538         bytes memory buffer = new bytes(2 * length + 2);
539         buffer[0] = "0";
540         buffer[1] = "x";
541         for (uint256 i = 2 * length + 1; i > 1; --i) {
542             buffer[i] = _HEX_SYMBOLS[value & 0xf];
543             value >>= 4;
544         }
545         require(value == 0, "Strings: hex length insufficient");
546         return string(buffer);
547     }
548 }
549 
550 
551 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Implementation of the {IERC165} interface.
559  *
560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
561  * for the additional interface id that will be supported. For example:
562  *
563  * ```solidity
564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
566  * }
567  * ```
568  *
569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
570  */
571 abstract contract ERC165 is IERC165 {
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 
581 // File erc721a/contracts/ERC721A.sol@v3.2.0
582 
583 // Creator: Chiru Labs
584 
585 pragma solidity ^0.8.4;
586 
587 
588 
589 
590 
591 
592 
593 error ApprovalCallerNotOwnerNorApproved();
594 error ApprovalQueryForNonexistentToken();
595 error ApproveToCaller();
596 error ApprovalToCurrentOwner();
597 error BalanceQueryForZeroAddress();
598 error MintToZeroAddress();
599 error MintZeroQuantity();
600 error OwnerQueryForNonexistentToken();
601 error TransferCallerNotOwnerNorApproved();
602 error TransferFromIncorrectOwner();
603 error TransferToNonERC721ReceiverImplementer();
604 error TransferToZeroAddress();
605 error URIQueryForNonexistentToken();
606 
607 /**
608  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
609  * the Metadata extension. Built to optimize for lower gas during batch mints.
610  *
611  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
612  *
613  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
614  *
615  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
616  */
617 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
618     using Address for address;
619     using Strings for uint256;
620 
621     // Compiler will pack this into a single 256bit word.
622     struct TokenOwnership {
623         // The address of the owner.
624         address addr;
625         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
626         uint64 startTimestamp;
627         // Whether the token has been burned.
628         bool burned;
629     }
630 
631     // Compiler will pack this into a single 256bit word.
632     struct AddressData {
633         // Realistically, 2**64-1 is more than enough.
634         uint64 balance;
635         // Keeps track of mint count with minimal overhead for tokenomics.
636         uint64 numberMinted;
637         // Keeps track of burn count with minimal overhead for tokenomics.
638         uint64 numberBurned;
639         // For miscellaneous variable(s) pertaining to the address
640         // (e.g. number of whitelist mint slots used).
641         // If there are multiple variables, please pack them into a uint64.
642         uint64 aux;
643     }
644 
645     // The tokenId of the next token to be minted.
646     uint256 internal _currentIndex;
647 
648     // The number of tokens burned.
649     uint256 internal _burnCounter;
650 
651     // Token name
652     string private _name;
653 
654     // Token symbol
655     string private _symbol;
656 
657     // Mapping from token ID to ownership details
658     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
659     mapping(uint256 => TokenOwnership) internal _ownerships;
660 
661     // Mapping owner address to address data
662     mapping(address => AddressData) private _addressData;
663 
664     // Mapping from token ID to approved address
665     mapping(uint256 => address) private _tokenApprovals;
666 
667     // Mapping from owner to operator approvals
668     mapping(address => mapping(address => bool)) private _operatorApprovals;
669 
670     constructor(string memory name_, string memory symbol_) {
671         _name = name_;
672         _symbol = symbol_;
673         _currentIndex = _startTokenId();
674     }
675 
676     /**
677      * To change the starting tokenId, please override this function.
678      */
679     function _startTokenId() internal view virtual returns (uint256) {
680         return 0;
681     }
682 
683     /**
684      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
685      */
686     function totalSupply() public view returns (uint256) {
687         // Counter underflow is impossible as _burnCounter cannot be incremented
688         // more than _currentIndex - _startTokenId() times
689         unchecked {
690             return _currentIndex - _burnCounter - _startTokenId();
691         }
692     }
693 
694     /**
695      * Returns the total amount of tokens minted in the contract.
696      */
697     function _totalMinted() internal view returns (uint256) {
698         // Counter underflow is impossible as _currentIndex does not decrement,
699         // and it is initialized to _startTokenId()
700         unchecked {
701             return _currentIndex - _startTokenId();
702         }
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
709         return
710             interfaceId == type(IERC721).interfaceId ||
711             interfaceId == type(IERC721Metadata).interfaceId ||
712             super.supportsInterface(interfaceId);
713     }
714 
715     /**
716      * @dev See {IERC721-balanceOf}.
717      */
718     function balanceOf(address owner) public view override returns (uint256) {
719         if (owner == address(0)) revert BalanceQueryForZeroAddress();
720         return uint256(_addressData[owner].balance);
721     }
722 
723     /**
724      * Returns the number of tokens minted by `owner`.
725      */
726     function _numberMinted(address owner) internal view returns (uint256) {
727         return uint256(_addressData[owner].numberMinted);
728     }
729 
730     /**
731      * Returns the number of tokens burned by or on behalf of `owner`.
732      */
733     function _numberBurned(address owner) internal view returns (uint256) {
734         return uint256(_addressData[owner].numberBurned);
735     }
736 
737     /**
738      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
739      */
740     function _getAux(address owner) internal view returns (uint64) {
741         return _addressData[owner].aux;
742     }
743 
744     /**
745      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
746      * If there are multiple variables, please pack them into a uint64.
747      */
748     function _setAux(address owner, uint64 aux) internal {
749         _addressData[owner].aux = aux;
750     }
751 
752     /**
753      * Gas spent here starts off proportional to the maximum mint batch size.
754      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
755      */
756     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
757         uint256 curr = tokenId;
758 
759         unchecked {
760             if (_startTokenId() <= curr && curr < _currentIndex) {
761                 TokenOwnership memory ownership = _ownerships[curr];
762                 if (!ownership.burned) {
763                     if (ownership.addr != address(0)) {
764                         return ownership;
765                     }
766                     // Invariant:
767                     // There will always be an ownership that has an address and is not burned
768                     // before an ownership that does not have an address and is not burned.
769                     // Hence, curr will not underflow.
770                     while (true) {
771                         curr--;
772                         ownership = _ownerships[curr];
773                         if (ownership.addr != address(0)) {
774                             return ownership;
775                         }
776                     }
777                 }
778             }
779         }
780         revert OwnerQueryForNonexistentToken();
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view override returns (address) {
787         return _ownershipOf(tokenId).addr;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-name}.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-symbol}.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-tokenURI}.
806      */
807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
808         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
809 
810         string memory baseURI = _baseURI();
811         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
812     }
813 
814     /**
815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
817      * by default, can be overriden in child contracts.
818      */
819     function _baseURI() internal view virtual returns (string memory) {
820         return '';
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public override {
827         address owner = ERC721A.ownerOf(tokenId);
828         if (to == owner) revert ApprovalToCurrentOwner();
829 
830         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
831             revert ApprovalCallerNotOwnerNorApproved();
832         }
833 
834         _approve(to, tokenId, owner);
835     }
836 
837     /**
838      * @dev See {IERC721-getApproved}.
839      */
840     function getApproved(uint256 tokenId) public view override returns (address) {
841         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
842 
843         return _tokenApprovals[tokenId];
844     }
845 
846     /**
847      * @dev See {IERC721-setApprovalForAll}.
848      */
849     function setApprovalForAll(address operator, bool approved) public virtual override {
850         if (operator == _msgSender()) revert ApproveToCaller();
851 
852         _operatorApprovals[_msgSender()][operator] = approved;
853         emit ApprovalForAll(_msgSender(), operator, approved);
854     }
855 
856     /**
857      * @dev See {IERC721-isApprovedForAll}.
858      */
859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
860         return _operatorApprovals[owner][operator];
861     }
862 
863     /**
864      * @dev See {IERC721-transferFrom}.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         _transfer(from, to, tokenId);
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId
881     ) public virtual override {
882         safeTransferFrom(from, to, tokenId, '');
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes memory _data
893     ) public virtual override {
894         _transfer(from, to, tokenId);
895         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
896             revert TransferToNonERC721ReceiverImplementer();
897         }
898     }
899 
900     /**
901      * @dev Returns whether `tokenId` exists.
902      *
903      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
904      *
905      * Tokens start existing when they are minted (`_mint`),
906      */
907     function _exists(uint256 tokenId) internal view returns (bool) {
908         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
909     }
910 
911     function _safeMint(address to, uint256 quantity) internal {
912         _safeMint(to, quantity, '');
913     }
914 
915     /**
916      * @dev Safely mints `quantity` tokens and transfers them to `to`.
917      *
918      * Requirements:
919      *
920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
921      * - `quantity` must be greater than 0.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeMint(
926         address to,
927         uint256 quantity,
928         bytes memory _data
929     ) internal {
930         _mint(to, quantity, _data, true);
931     }
932 
933     /**
934      * @dev Mints `quantity` tokens and transfers them to `to`.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _mint(
944         address to,
945         uint256 quantity,
946         bytes memory _data,
947         bool safe
948     ) internal {
949         uint256 startTokenId = _currentIndex;
950         if (to == address(0)) revert MintToZeroAddress();
951         if (quantity == 0) revert MintZeroQuantity();
952 
953         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
954 
955         // Overflows are incredibly unrealistic.
956         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
957         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
958         unchecked {
959             _addressData[to].balance += uint64(quantity);
960             _addressData[to].numberMinted += uint64(quantity);
961 
962             _ownerships[startTokenId].addr = to;
963             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
964 
965             uint256 updatedIndex = startTokenId;
966             uint256 end = updatedIndex + quantity;
967 
968             if (safe && to.isContract()) {
969                 do {
970                     emit Transfer(address(0), to, updatedIndex);
971                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
972                         revert TransferToNonERC721ReceiverImplementer();
973                     }
974                 } while (updatedIndex != end);
975                 // Reentrancy protection
976                 if (_currentIndex != startTokenId) revert();
977             } else {
978                 do {
979                     emit Transfer(address(0), to, updatedIndex++);
980                 } while (updatedIndex != end);
981             }
982             _currentIndex = updatedIndex;
983         }
984         _afterTokenTransfers(address(0), to, startTokenId, quantity);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must be owned by `from`.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _transfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) private {
1002         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1003 
1004         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1005 
1006         bool isApprovedOrOwner = (_msgSender() == from ||
1007             isApprovedForAll(from, _msgSender()) ||
1008             getApproved(tokenId) == _msgSender());
1009 
1010         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1011         if (to == address(0)) revert TransferToZeroAddress();
1012 
1013         _beforeTokenTransfers(from, to, tokenId, 1);
1014 
1015         // Clear approvals from the previous owner
1016         _approve(address(0), tokenId, from);
1017 
1018         // Underflow of the sender's balance is impossible because we check for
1019         // ownership above and the recipient's balance can't realistically overflow.
1020         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1021         unchecked {
1022             _addressData[from].balance -= 1;
1023             _addressData[to].balance += 1;
1024 
1025             TokenOwnership storage currSlot = _ownerships[tokenId];
1026             currSlot.addr = to;
1027             currSlot.startTimestamp = uint64(block.timestamp);
1028 
1029             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1030             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1031             uint256 nextTokenId = tokenId + 1;
1032             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1033             if (nextSlot.addr == address(0)) {
1034                 // This will suffice for checking _exists(nextTokenId),
1035                 // as a burned slot cannot contain the zero address.
1036                 if (nextTokenId != _currentIndex) {
1037                     nextSlot.addr = from;
1038                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1039                 }
1040             }
1041         }
1042 
1043         emit Transfer(from, to, tokenId);
1044         _afterTokenTransfers(from, to, tokenId, 1);
1045     }
1046 
1047     /**
1048      * @dev This is equivalent to _burn(tokenId, false)
1049      */
1050     function _burn(uint256 tokenId) internal virtual {
1051         _burn(tokenId, false);
1052     }
1053 
1054     /**
1055      * @dev Destroys `tokenId`.
1056      * The approval is cleared when the token is burned.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1065         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1066 
1067         address from = prevOwnership.addr;
1068 
1069         if (approvalCheck) {
1070             bool isApprovedOrOwner = (_msgSender() == from ||
1071                 isApprovedForAll(from, _msgSender()) ||
1072                 getApproved(tokenId) == _msgSender());
1073 
1074             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1075         }
1076 
1077         _beforeTokenTransfers(from, address(0), tokenId, 1);
1078 
1079         // Clear approvals from the previous owner
1080         _approve(address(0), tokenId, from);
1081 
1082         // Underflow of the sender's balance is impossible because we check for
1083         // ownership above and the recipient's balance can't realistically overflow.
1084         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1085         unchecked {
1086             AddressData storage addressData = _addressData[from];
1087             addressData.balance -= 1;
1088             addressData.numberBurned += 1;
1089 
1090             // Keep track of who burned the token, and the timestamp of burning.
1091             TokenOwnership storage currSlot = _ownerships[tokenId];
1092             currSlot.addr = from;
1093             currSlot.startTimestamp = uint64(block.timestamp);
1094             currSlot.burned = true;
1095 
1096             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1097             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1098             uint256 nextTokenId = tokenId + 1;
1099             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1100             if (nextSlot.addr == address(0)) {
1101                 // This will suffice for checking _exists(nextTokenId),
1102                 // as a burned slot cannot contain the zero address.
1103                 if (nextTokenId != _currentIndex) {
1104                     nextSlot.addr = from;
1105                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1106                 }
1107             }
1108         }
1109 
1110         emit Transfer(from, address(0), tokenId);
1111         _afterTokenTransfers(from, address(0), tokenId, 1);
1112 
1113         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1114         unchecked {
1115             _burnCounter++;
1116         }
1117     }
1118 
1119     /**
1120      * @dev Approve `to` to operate on `tokenId`
1121      *
1122      * Emits a {Approval} event.
1123      */
1124     function _approve(
1125         address to,
1126         uint256 tokenId,
1127         address owner
1128     ) private {
1129         _tokenApprovals[tokenId] = to;
1130         emit Approval(owner, to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1135      *
1136      * @param from address representing the previous owner of the given token ID
1137      * @param to target address that will receive the tokens
1138      * @param tokenId uint256 ID of the token to be transferred
1139      * @param _data bytes optional data to send along with the call
1140      * @return bool whether the call correctly returned the expected magic value
1141      */
1142     function _checkContractOnERC721Received(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes memory _data
1147     ) private returns (bool) {
1148         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1149             return retval == IERC721Receiver(to).onERC721Received.selector;
1150         } catch (bytes memory reason) {
1151             if (reason.length == 0) {
1152                 revert TransferToNonERC721ReceiverImplementer();
1153             } else {
1154                 assembly {
1155                     revert(add(32, reason), mload(reason))
1156                 }
1157             }
1158         }
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1163      * And also called before burning one token.
1164      *
1165      * startTokenId - the first token id to be transferred
1166      * quantity - the amount to be transferred
1167      *
1168      * Calling conditions:
1169      *
1170      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1171      * transferred to `to`.
1172      * - When `from` is zero, `tokenId` will be minted for `to`.
1173      * - When `to` is zero, `tokenId` will be burned by `from`.
1174      * - `from` and `to` are never both zero.
1175      */
1176     function _beforeTokenTransfers(
1177         address from,
1178         address to,
1179         uint256 startTokenId,
1180         uint256 quantity
1181     ) internal virtual {}
1182 
1183     /**
1184      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1185      * minting.
1186      * And also called after one token has been burned.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` has been minted for `to`.
1196      * - When `to` is zero, `tokenId` has been burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _afterTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 }
1206 
1207 
1208 // File @openzeppelin/contracts/security/Pausable.sol@v4.4.2
1209 
1210 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @dev Contract module which allows children to implement an emergency stop
1216  * mechanism that can be triggered by an authorized account.
1217  *
1218  * This module is used through inheritance. It will make available the
1219  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1220  * the functions of your contract. Note that they will not be pausable by
1221  * simply including this module, only once the modifiers are put in place.
1222  */
1223 abstract contract Pausable is Context {
1224     /**
1225      * @dev Emitted when the pause is triggered by `account`.
1226      */
1227     event Paused(address account);
1228 
1229     /**
1230      * @dev Emitted when the pause is lifted by `account`.
1231      */
1232     event Unpaused(address account);
1233 
1234     bool private _paused;
1235 
1236     /**
1237      * @dev Initializes the contract in unpaused state.
1238      */
1239     constructor() {
1240         _paused = false;
1241     }
1242 
1243     /**
1244      * @dev Returns true if the contract is paused, and false otherwise.
1245      */
1246     function paused() public view virtual returns (bool) {
1247         return _paused;
1248     }
1249 
1250     /**
1251      * @dev Modifier to make a function callable only when the contract is not paused.
1252      *
1253      * Requirements:
1254      *
1255      * - The contract must not be paused.
1256      */
1257     modifier whenNotPaused() {
1258         require(!paused(), "Pausable: paused");
1259         _;
1260     }
1261 
1262     /**
1263      * @dev Modifier to make a function callable only when the contract is paused.
1264      *
1265      * Requirements:
1266      *
1267      * - The contract must be paused.
1268      */
1269     modifier whenPaused() {
1270         require(paused(), "Pausable: not paused");
1271         _;
1272     }
1273 
1274     /**
1275      * @dev Triggers stopped state.
1276      *
1277      * Requirements:
1278      *
1279      * - The contract must not be paused.
1280      */
1281     function _pause() internal virtual whenNotPaused {
1282         _paused = true;
1283         emit Paused(_msgSender());
1284     }
1285 
1286     /**
1287      * @dev Returns to normal state.
1288      *
1289      * Requirements:
1290      *
1291      * - The contract must be paused.
1292      */
1293     function _unpause() internal virtual whenPaused {
1294         _paused = false;
1295         emit Unpaused(_msgSender());
1296     }
1297 }
1298 
1299 
1300 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
1301 
1302 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 /**
1307  * @dev Contract module that helps prevent reentrant calls to a function.
1308  *
1309  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1310  * available, which can be applied to functions to make sure there are no nested
1311  * (reentrant) calls to them.
1312  *
1313  * Note that because there is a single `nonReentrant` guard, functions marked as
1314  * `nonReentrant` may not call one another. This can be worked around by making
1315  * those functions `private`, and then adding `external` `nonReentrant` entry
1316  * points to them.
1317  *
1318  * TIP: If you would like to learn more about reentrancy and alternative ways
1319  * to protect against it, check out our blog post
1320  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1321  */
1322 abstract contract ReentrancyGuard {
1323     // Booleans are more expensive than uint256 or any type that takes up a full
1324     // word because each write operation emits an extra SLOAD to first read the
1325     // slot's contents, replace the bits taken up by the boolean, and then write
1326     // back. This is the compiler's defense against contract upgrades and
1327     // pointer aliasing, and it cannot be disabled.
1328 
1329     // The values being non-zero value makes deployment a bit more expensive,
1330     // but in exchange the refund on every call to nonReentrant will be lower in
1331     // amount. Since refunds are capped to a percentage of the total
1332     // transaction's gas, it is best to keep them low in cases like this one, to
1333     // increase the likelihood of the full refund coming into effect.
1334     uint256 private constant _NOT_ENTERED = 1;
1335     uint256 private constant _ENTERED = 2;
1336 
1337     uint256 private _status;
1338 
1339     constructor() {
1340         _status = _NOT_ENTERED;
1341     }
1342 
1343     /**
1344      * @dev Prevents a contract from calling itself, directly or indirectly.
1345      * Calling a `nonReentrant` function from another `nonReentrant`
1346      * function is not supported. It is possible to prevent this from happening
1347      * by making the `nonReentrant` function external, and making it call a
1348      * `private` function that does the actual work.
1349      */
1350     modifier nonReentrant() {
1351         // On the first call to nonReentrant, _notEntered will be true
1352         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1353 
1354         // Any calls to nonReentrant after this point will fail
1355         _status = _ENTERED;
1356 
1357         _;
1358 
1359         // By storing the original value once again, a refund is triggered (see
1360         // https://eips.ethereum.org/EIPS/eip-2200)
1361         _status = _NOT_ENTERED;
1362     }
1363 }
1364 
1365 
1366 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
1367 
1368 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 /**
1373  * @dev Contract module which provides a basic access control mechanism, where
1374  * there is an account (an owner) that can be granted exclusive access to
1375  * specific functions.
1376  *
1377  * By default, the owner account will be the one that deploys the contract. This
1378  * can later be changed with {transferOwnership}.
1379  *
1380  * This module is used through inheritance. It will make available the modifier
1381  * `onlyOwner`, which can be applied to your functions to restrict their use to
1382  * the owner.
1383  */
1384 abstract contract Ownable is Context {
1385     address private _owner;
1386 
1387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1388 
1389     /**
1390      * @dev Initializes the contract setting the deployer as the initial owner.
1391      */
1392     constructor() {
1393         _transferOwnership(_msgSender());
1394     }
1395 
1396     /**
1397      * @dev Returns the address of the current owner.
1398      */
1399     function owner() public view virtual returns (address) {
1400         return _owner;
1401     }
1402 
1403     /**
1404      * @dev Throws if called by any account other than the owner.
1405      */
1406     modifier onlyOwner() {
1407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1408         _;
1409     }
1410 
1411     /**
1412      * @dev Leaves the contract without owner. It will not be possible to call
1413      * `onlyOwner` functions anymore. Can only be called by the current owner.
1414      *
1415      * NOTE: Renouncing ownership will leave the contract without an owner,
1416      * thereby removing any functionality that is only available to the owner.
1417      */
1418     function renounceOwnership() public virtual onlyOwner {
1419         _transferOwnership(address(0));
1420     }
1421 
1422     /**
1423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1424      * Can only be called by the current owner.
1425      */
1426     function transferOwnership(address newOwner) public virtual onlyOwner {
1427         require(newOwner != address(0), "Ownable: new owner is the zero address");
1428         _transferOwnership(newOwner);
1429     }
1430 
1431     /**
1432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1433      * Internal function without access restriction.
1434      */
1435     function _transferOwnership(address newOwner) internal virtual {
1436         address oldOwner = _owner;
1437         _owner = newOwner;
1438         emit OwnershipTransferred(oldOwner, newOwner);
1439     }
1440 }
1441 
1442 
1443 // File contracts/interfaces/IRandomNumberGenerator.sol
1444 
1445 pragma solidity 0.8.11;
1446 
1447 interface IRandomNumberGenerator {
1448   function getRandomNumber() external;
1449   function randomNumber() external view returns (uint256);
1450 }
1451 
1452 
1453 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.2
1454 
1455 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1456 
1457 pragma solidity ^0.8.0;
1458 
1459 /**
1460  * @dev These functions deal with verification of Merkle Trees proofs.
1461  *
1462  * The proofs can be generated using the JavaScript library
1463  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1464  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1465  *
1466  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1467  */
1468 library MerkleProof {
1469     /**
1470      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1471      * defined by `root`. For this, a `proof` must be provided, containing
1472      * sibling hashes on the branch from the leaf to the root of the tree. Each
1473      * pair of leaves and each pair of pre-images are assumed to be sorted.
1474      */
1475     function verify(
1476         bytes32[] memory proof,
1477         bytes32 root,
1478         bytes32 leaf
1479     ) internal pure returns (bool) {
1480         return processProof(proof, leaf) == root;
1481     }
1482 
1483     /**
1484      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1485      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1486      * hash matches the root of the tree. When processing the proof, the pairs
1487      * of leafs & pre-images are assumed to be sorted.
1488      *
1489      * _Available since v4.4._
1490      */
1491     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1492         bytes32 computedHash = leaf;
1493         for (uint256 i = 0; i < proof.length; i++) {
1494             bytes32 proofElement = proof[i];
1495             if (computedHash <= proofElement) {
1496                 // Hash(current computed hash + current element of the proof)
1497                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1498             } else {
1499                 // Hash(current element of the proof + current computed hash)
1500                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1501             }
1502         }
1503         return computedHash;
1504     }
1505 }
1506 
1507 
1508 // File hardhat/console.sol@v2.8.3
1509 
1510 pragma solidity >= 0.4.22 <0.9.0;
1511 
1512 library console {
1513 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1514 
1515 	function _sendLogPayload(bytes memory payload) private view {
1516 		uint256 payloadLength = payload.length;
1517 		address consoleAddress = CONSOLE_ADDRESS;
1518 		assembly {
1519 			let payloadStart := add(payload, 32)
1520 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1521 		}
1522 	}
1523 
1524 	function log() internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log()"));
1526 	}
1527 
1528 	function logInt(int p0) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1530 	}
1531 
1532 	function logUint(uint p0) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1534 	}
1535 
1536 	function logString(string memory p0) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1538 	}
1539 
1540 	function logBool(bool p0) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1542 	}
1543 
1544 	function logAddress(address p0) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1546 	}
1547 
1548 	function logBytes(bytes memory p0) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1550 	}
1551 
1552 	function logBytes1(bytes1 p0) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1554 	}
1555 
1556 	function logBytes2(bytes2 p0) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1558 	}
1559 
1560 	function logBytes3(bytes3 p0) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1562 	}
1563 
1564 	function logBytes4(bytes4 p0) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1566 	}
1567 
1568 	function logBytes5(bytes5 p0) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1570 	}
1571 
1572 	function logBytes6(bytes6 p0) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1574 	}
1575 
1576 	function logBytes7(bytes7 p0) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1578 	}
1579 
1580 	function logBytes8(bytes8 p0) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1582 	}
1583 
1584 	function logBytes9(bytes9 p0) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1586 	}
1587 
1588 	function logBytes10(bytes10 p0) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1590 	}
1591 
1592 	function logBytes11(bytes11 p0) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1594 	}
1595 
1596 	function logBytes12(bytes12 p0) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1598 	}
1599 
1600 	function logBytes13(bytes13 p0) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1602 	}
1603 
1604 	function logBytes14(bytes14 p0) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1606 	}
1607 
1608 	function logBytes15(bytes15 p0) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1610 	}
1611 
1612 	function logBytes16(bytes16 p0) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1614 	}
1615 
1616 	function logBytes17(bytes17 p0) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1618 	}
1619 
1620 	function logBytes18(bytes18 p0) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1622 	}
1623 
1624 	function logBytes19(bytes19 p0) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1626 	}
1627 
1628 	function logBytes20(bytes20 p0) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1630 	}
1631 
1632 	function logBytes21(bytes21 p0) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1634 	}
1635 
1636 	function logBytes22(bytes22 p0) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1638 	}
1639 
1640 	function logBytes23(bytes23 p0) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1642 	}
1643 
1644 	function logBytes24(bytes24 p0) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1646 	}
1647 
1648 	function logBytes25(bytes25 p0) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1650 	}
1651 
1652 	function logBytes26(bytes26 p0) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1654 	}
1655 
1656 	function logBytes27(bytes27 p0) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1658 	}
1659 
1660 	function logBytes28(bytes28 p0) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1662 	}
1663 
1664 	function logBytes29(bytes29 p0) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1666 	}
1667 
1668 	function logBytes30(bytes30 p0) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1670 	}
1671 
1672 	function logBytes31(bytes31 p0) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1674 	}
1675 
1676 	function logBytes32(bytes32 p0) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1678 	}
1679 
1680 	function log(uint p0) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1682 	}
1683 
1684 	function log(string memory p0) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1686 	}
1687 
1688 	function log(bool p0) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1690 	}
1691 
1692 	function log(address p0) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1694 	}
1695 
1696 	function log(uint p0, uint p1) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1698 	}
1699 
1700 	function log(uint p0, string memory p1) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1702 	}
1703 
1704 	function log(uint p0, bool p1) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1706 	}
1707 
1708 	function log(uint p0, address p1) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1710 	}
1711 
1712 	function log(string memory p0, uint p1) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1714 	}
1715 
1716 	function log(string memory p0, string memory p1) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1718 	}
1719 
1720 	function log(string memory p0, bool p1) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1722 	}
1723 
1724 	function log(string memory p0, address p1) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1726 	}
1727 
1728 	function log(bool p0, uint p1) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1730 	}
1731 
1732 	function log(bool p0, string memory p1) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1734 	}
1735 
1736 	function log(bool p0, bool p1) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1738 	}
1739 
1740 	function log(bool p0, address p1) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1742 	}
1743 
1744 	function log(address p0, uint p1) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1746 	}
1747 
1748 	function log(address p0, string memory p1) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1750 	}
1751 
1752 	function log(address p0, bool p1) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1754 	}
1755 
1756 	function log(address p0, address p1) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1758 	}
1759 
1760 	function log(uint p0, uint p1, uint p2) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1762 	}
1763 
1764 	function log(uint p0, uint p1, string memory p2) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1766 	}
1767 
1768 	function log(uint p0, uint p1, bool p2) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1770 	}
1771 
1772 	function log(uint p0, uint p1, address p2) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1774 	}
1775 
1776 	function log(uint p0, string memory p1, uint p2) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1778 	}
1779 
1780 	function log(uint p0, string memory p1, string memory p2) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1782 	}
1783 
1784 	function log(uint p0, string memory p1, bool p2) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1786 	}
1787 
1788 	function log(uint p0, string memory p1, address p2) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1790 	}
1791 
1792 	function log(uint p0, bool p1, uint p2) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1794 	}
1795 
1796 	function log(uint p0, bool p1, string memory p2) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1798 	}
1799 
1800 	function log(uint p0, bool p1, bool p2) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1802 	}
1803 
1804 	function log(uint p0, bool p1, address p2) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1806 	}
1807 
1808 	function log(uint p0, address p1, uint p2) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1810 	}
1811 
1812 	function log(uint p0, address p1, string memory p2) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1814 	}
1815 
1816 	function log(uint p0, address p1, bool p2) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1818 	}
1819 
1820 	function log(uint p0, address p1, address p2) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1822 	}
1823 
1824 	function log(string memory p0, uint p1, uint p2) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1826 	}
1827 
1828 	function log(string memory p0, uint p1, string memory p2) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1830 	}
1831 
1832 	function log(string memory p0, uint p1, bool p2) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1834 	}
1835 
1836 	function log(string memory p0, uint p1, address p2) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1838 	}
1839 
1840 	function log(string memory p0, string memory p1, uint p2) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1842 	}
1843 
1844 	function log(string memory p0, string memory p1, string memory p2) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1846 	}
1847 
1848 	function log(string memory p0, string memory p1, bool p2) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1850 	}
1851 
1852 	function log(string memory p0, string memory p1, address p2) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1854 	}
1855 
1856 	function log(string memory p0, bool p1, uint p2) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1858 	}
1859 
1860 	function log(string memory p0, bool p1, string memory p2) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1862 	}
1863 
1864 	function log(string memory p0, bool p1, bool p2) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1866 	}
1867 
1868 	function log(string memory p0, bool p1, address p2) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1870 	}
1871 
1872 	function log(string memory p0, address p1, uint p2) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1874 	}
1875 
1876 	function log(string memory p0, address p1, string memory p2) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1878 	}
1879 
1880 	function log(string memory p0, address p1, bool p2) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1882 	}
1883 
1884 	function log(string memory p0, address p1, address p2) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1886 	}
1887 
1888 	function log(bool p0, uint p1, uint p2) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1890 	}
1891 
1892 	function log(bool p0, uint p1, string memory p2) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1894 	}
1895 
1896 	function log(bool p0, uint p1, bool p2) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1898 	}
1899 
1900 	function log(bool p0, uint p1, address p2) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1902 	}
1903 
1904 	function log(bool p0, string memory p1, uint p2) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1906 	}
1907 
1908 	function log(bool p0, string memory p1, string memory p2) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1910 	}
1911 
1912 	function log(bool p0, string memory p1, bool p2) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1914 	}
1915 
1916 	function log(bool p0, string memory p1, address p2) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1918 	}
1919 
1920 	function log(bool p0, bool p1, uint p2) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1922 	}
1923 
1924 	function log(bool p0, bool p1, string memory p2) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1926 	}
1927 
1928 	function log(bool p0, bool p1, bool p2) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1930 	}
1931 
1932 	function log(bool p0, bool p1, address p2) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1934 	}
1935 
1936 	function log(bool p0, address p1, uint p2) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1938 	}
1939 
1940 	function log(bool p0, address p1, string memory p2) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1942 	}
1943 
1944 	function log(bool p0, address p1, bool p2) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1946 	}
1947 
1948 	function log(bool p0, address p1, address p2) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1950 	}
1951 
1952 	function log(address p0, uint p1, uint p2) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1954 	}
1955 
1956 	function log(address p0, uint p1, string memory p2) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1958 	}
1959 
1960 	function log(address p0, uint p1, bool p2) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1962 	}
1963 
1964 	function log(address p0, uint p1, address p2) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1966 	}
1967 
1968 	function log(address p0, string memory p1, uint p2) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1970 	}
1971 
1972 	function log(address p0, string memory p1, string memory p2) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1974 	}
1975 
1976 	function log(address p0, string memory p1, bool p2) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1978 	}
1979 
1980 	function log(address p0, string memory p1, address p2) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1982 	}
1983 
1984 	function log(address p0, bool p1, uint p2) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1986 	}
1987 
1988 	function log(address p0, bool p1, string memory p2) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1990 	}
1991 
1992 	function log(address p0, bool p1, bool p2) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1994 	}
1995 
1996 	function log(address p0, bool p1, address p2) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1998 	}
1999 
2000 	function log(address p0, address p1, uint p2) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2002 	}
2003 
2004 	function log(address p0, address p1, string memory p2) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2006 	}
2007 
2008 	function log(address p0, address p1, bool p2) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2010 	}
2011 
2012 	function log(address p0, address p1, address p2) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2014 	}
2015 
2016 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(uint p0, uint p1, address p2, address p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(uint p0, bool p1, address p2, address p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(uint p0, address p1, uint p2, address p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(uint p0, address p1, bool p2, address p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(uint p0, address p1, address p2, uint p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(uint p0, address p1, address p2, bool p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(uint p0, address p1, address p2, address p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(string memory p0, address p1, address p2, address p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(bool p0, uint p1, address p2, address p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(bool p0, bool p1, address p2, address p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(bool p0, address p1, uint p2, address p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(bool p0, address p1, bool p2, address p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(bool p0, address p1, address p2, uint p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(bool p0, address p1, address p2, bool p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(bool p0, address p1, address p2, address p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(address p0, uint p1, uint p2, address p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(address p0, uint p1, bool p2, address p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(address p0, uint p1, address p2, uint p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(address p0, uint p1, address p2, bool p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2842 	}
2843 
2844 	function log(address p0, uint p1, address p2, address p3) internal view {
2845 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2846 	}
2847 
2848 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2849 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2850 	}
2851 
2852 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2853 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2854 	}
2855 
2856 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2857 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2858 	}
2859 
2860 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2861 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2862 	}
2863 
2864 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2865 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2866 	}
2867 
2868 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2869 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2870 	}
2871 
2872 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2873 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2874 	}
2875 
2876 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2877 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2878 	}
2879 
2880 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2881 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2882 	}
2883 
2884 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2885 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2886 	}
2887 
2888 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2889 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2890 	}
2891 
2892 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2893 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2894 	}
2895 
2896 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2897 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2898 	}
2899 
2900 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2901 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2902 	}
2903 
2904 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2905 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2906 	}
2907 
2908 	function log(address p0, string memory p1, address p2, address p3) internal view {
2909 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2910 	}
2911 
2912 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2913 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2914 	}
2915 
2916 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2917 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2918 	}
2919 
2920 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2921 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2922 	}
2923 
2924 	function log(address p0, bool p1, uint p2, address p3) internal view {
2925 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2926 	}
2927 
2928 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2929 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2930 	}
2931 
2932 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2933 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2934 	}
2935 
2936 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2937 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2938 	}
2939 
2940 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2941 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2942 	}
2943 
2944 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2945 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2946 	}
2947 
2948 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2949 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2950 	}
2951 
2952 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2953 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2954 	}
2955 
2956 	function log(address p0, bool p1, bool p2, address p3) internal view {
2957 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2958 	}
2959 
2960 	function log(address p0, bool p1, address p2, uint p3) internal view {
2961 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2962 	}
2963 
2964 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2965 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2966 	}
2967 
2968 	function log(address p0, bool p1, address p2, bool p3) internal view {
2969 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2970 	}
2971 
2972 	function log(address p0, bool p1, address p2, address p3) internal view {
2973 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2974 	}
2975 
2976 	function log(address p0, address p1, uint p2, uint p3) internal view {
2977 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2978 	}
2979 
2980 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2981 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2982 	}
2983 
2984 	function log(address p0, address p1, uint p2, bool p3) internal view {
2985 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2986 	}
2987 
2988 	function log(address p0, address p1, uint p2, address p3) internal view {
2989 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2990 	}
2991 
2992 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2993 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2994 	}
2995 
2996 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2997 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2998 	}
2999 
3000 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3001 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3002 	}
3003 
3004 	function log(address p0, address p1, string memory p2, address p3) internal view {
3005 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3006 	}
3007 
3008 	function log(address p0, address p1, bool p2, uint p3) internal view {
3009 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3010 	}
3011 
3012 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3013 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3014 	}
3015 
3016 	function log(address p0, address p1, bool p2, bool p3) internal view {
3017 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3018 	}
3019 
3020 	function log(address p0, address p1, bool p2, address p3) internal view {
3021 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3022 	}
3023 
3024 	function log(address p0, address p1, address p2, uint p3) internal view {
3025 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3026 	}
3027 
3028 	function log(address p0, address p1, address p2, string memory p3) internal view {
3029 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3030 	}
3031 
3032 	function log(address p0, address p1, address p2, bool p3) internal view {
3033 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3034 	}
3035 
3036 	function log(address p0, address p1, address p2, address p3) internal view {
3037 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3038 	}
3039 
3040 }
3041 
3042 
3043 // File contracts/libs/Raffle.sol
3044 
3045 pragma solidity 0.8.11;
3046 
3047 
3048 library Raffle {
3049   struct State {
3050     uint256 raffleStartTs;
3051     uint256 raffleEndTs;
3052     uint256 raffleCap;
3053     bytes32 raffleMerkleRoot;
3054 
3055     address[] registeredUsers;
3056     mapping(address => uint256) raffleMap;
3057   }
3058 
3059   function initialize(
3060     State storage self,
3061     uint256 raffleStartTs,
3062     uint256 raffleEndTs,
3063     uint256 raffleCap  
3064   ) public {
3065     self.raffleStartTs = raffleStartTs;
3066     self.raffleEndTs = raffleEndTs;
3067     self.raffleCap = raffleCap;
3068   }
3069 
3070   function getRaffleInfo(
3071     State storage self,
3072     uint256 skip,
3073     uint256 size
3074   ) view public returns(uint256, uint256, uint256, uint256, address[] memory, uint256[] memory) {
3075     uint256 count = size;
3076     uint256[] memory numOfNfts = new uint256[](count);
3077     uint256 iterations = skip + size;
3078 
3079     for (uint256 i = skip; i < iterations; i++) {
3080       numOfNfts[i] = self.raffleMap[self.registeredUsers[i]];
3081     }
3082 
3083     return (
3084       self.raffleStartTs,
3085       self.raffleEndTs,
3086       self.raffleCap,
3087       self.registeredUsers.length,
3088       self.registeredUsers,
3089       numOfNfts
3090     );
3091   }
3092 
3093   function setRaffleMerkleRoot(
3094     State storage self,
3095     bytes32 raffleMerkleRoot
3096   ) public  {
3097     self.raffleMerkleRoot = raffleMerkleRoot;
3098   }
3099 
3100   function verifyMerklePath(
3101     State storage,
3102     address account,
3103     bytes32 merkleRoot,
3104     bytes32[] memory proof,
3105     uint256 alloc
3106   ) pure public returns(bool) {
3107     return MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(keccak256(abi.encodePacked(account, alloc)))));
3108   }
3109 
3110   function registerRaffle(
3111     State storage self,
3112     address user,
3113     uint256 qty,
3114     uint256 publicPrice
3115   ) public {
3116     require(block.timestamp >= self.raffleStartTs, "raffle reg not open");
3117     require(block.timestamp <= self.raffleEndTs, "raffle reg closed");
3118     require(qty <= self.raffleCap, "raffle cap");
3119     require(self.raffleMap[user] == 0, "already registered");
3120     require(user.balance >= qty * publicPrice, "not enough funds");
3121 
3122     self.raffleMap[user] = qty;
3123     self.registeredUsers.push(user);
3124   }
3125 
3126   function buy(
3127     State storage self,
3128     address user,
3129     bytes32[] memory proof,
3130     uint256 qty
3131   ) public {
3132     uint256 alloc = self.raffleMap[user];
3133     require(alloc > 0, "not registered or already claimed");
3134 
3135     self.raffleMap[user] = 0;
3136 
3137     require(
3138       verifyMerklePath(self, user, self.raffleMerkleRoot, proof, qty),
3139       "not a winner"
3140     );
3141   }
3142 }
3143 
3144 
3145 // File contracts/JapaneseBoredApeSociety.sol
3146 
3147 pragma solidity 0.8.11;
3148 
3149 
3150 
3151 
3152 
3153 
3154 
3155 contract JapaneseBoredApeSociety is Ownable, Pausable, ReentrancyGuard, ERC721A {
3156   using Strings for uint256;
3157   using Raffle for Raffle.State;
3158 
3159   Raffle.State private raffleState;
3160 
3161   string public baseURI;
3162   address[2] public treasury;
3163   uint256 public immutable teamAllocation;
3164   uint256 public immutable personalCap;
3165   uint256 public immutable preSaleEndTs;
3166   uint256 public immutable publicStartTs;
3167   uint256 public maxSupply;
3168   uint256 public revealTimestamp;
3169   uint256 public whitelistSold;
3170   uint256 public presalePrice;
3171   uint256 public publicPrice;
3172   bytes32 public provenanceHash;
3173   bytes32 public whitelistMerkleRoot;
3174   IRandomNumberGenerator public randomGenerator;
3175   bool private randomNumberReqSent;
3176 
3177   mapping(address => uint256) public userCount;
3178   mapping (address => uint256) public whitelistAccounts;
3179 
3180   event Presale(address indexed user, uint256 amount);
3181   event Registered(address indexed user, uint256 qty);
3182 
3183   constructor(
3184     string memory name,
3185     string memory symbol,
3186     address[2] memory _treasury,
3187     address _randomGenerator,
3188     uint256[2] memory _maxSupplyAndTeamAlloc,
3189     uint256 _raffleCap,
3190     uint256 _personalCap,
3191     uint256[2] memory prices,
3192     uint256[5] memory _timestamps,
3193     bytes32[2] memory provenanceAndMerkeRoot
3194   ) ERC721A(name, symbol) {
3195     treasury = _treasury;
3196     randomGenerator = IRandomNumberGenerator(_randomGenerator);
3197     maxSupply = _maxSupplyAndTeamAlloc[0];
3198     teamAllocation = _maxSupplyAndTeamAlloc[1];
3199     personalCap = _personalCap;
3200     presalePrice = prices[0];
3201     publicPrice = prices[1];
3202     preSaleEndTs = _timestamps[0];
3203     publicStartTs = _timestamps[3];
3204     revealTimestamp = _timestamps[4];
3205     provenanceHash = provenanceAndMerkeRoot[0];
3206     whitelistMerkleRoot = provenanceAndMerkeRoot[1];
3207 
3208     raffleState.initialize(
3209       _timestamps[1],
3210       _timestamps[2],
3211       _raffleCap
3212     );
3213 
3214     _mint(teamAllocation, treasury[0]);
3215   }
3216 
3217   function setMaxSupply(uint256 _maxSupply) external onlyOwner {
3218     maxSupply = _maxSupply;
3219   }
3220 
3221   function pause() public onlyOwner {
3222     _pause();
3223   }
3224 
3225   function unpause() public onlyOwner {
3226     _unpause();
3227   }
3228 
3229   function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
3230     whitelistMerkleRoot = _whitelistMerkleRoot;
3231   }
3232 
3233   function setRaffleMerkleRoot(bytes32 raffleMerkleRoot) external onlyOwner {
3234     raffleState.setRaffleMerkleRoot(raffleMerkleRoot);
3235   }
3236 
3237   function setPrices(uint256 _presalePrice, uint256 _publicPrice) external onlyOwner {
3238     presalePrice = _presalePrice;
3239     publicPrice = _publicPrice;
3240   }
3241 
3242   function startingIndex() public view returns(uint256) {
3243     return randomGenerator.randomNumber();
3244   }
3245 
3246   function setBaseURI(string memory _baseUri) external onlyOwner {
3247     baseURI = _baseUri;
3248   }
3249 
3250   // return the re
3251   function getRaffleInfo(uint256 skip, uint256 size) view external returns(
3252     uint256,
3253     uint256,
3254     uint256,
3255     uint256,
3256     address[] memory,
3257     uint256[] memory
3258   ) {
3259     return raffleState.getRaffleInfo(skip, size);
3260   }
3261 
3262   function tokenURI(uint256 tokenId) public view override returns (string memory) {
3263     if(randomGenerator.randomNumber() == 0){
3264       return baseURI;
3265     }
3266     require(_exists(tokenId), "nonexistent token");
3267     uint256 tokenPath = (startingIndex() + tokenId) % maxSupply;
3268 
3269     return string(abi.encodePacked(baseURI, tokenPath.toString()));
3270   }
3271 
3272   function verifyMerklePath(
3273     address account,
3274     bytes32 merkleRoot,
3275     bytes32[] memory proof,
3276     uint256 alloc
3277   ) view public returns(bool) {
3278     return raffleState.verifyMerklePath(account, merkleRoot, proof, alloc);
3279   }
3280 
3281   function transferFunds(uint256 totalCost) private {
3282     require(msg.value == totalCost, "wrong amount");
3283     // send the purchase price to treausury
3284     uint256 amountA = (totalCost * 7000) / 10_000;
3285     (bool success, ) = payable(treasury[0]).call{value: amountA}("");
3286     require(success, "transfer failed");
3287 
3288     (bool success2, ) = payable(treasury[1]).call{value: totalCost - amountA}("");
3289     require(success2, "transfer failed");
3290   }
3291 
3292   /// @notice Allows whitelisted addresses to participate in the presale
3293   /// @param proof the merkle proof that the given user with the provided allocation is in the merke tree
3294   /// @param alloc the initial allocation to this whitelisted account
3295   /// @param amount the amount of NFTs to mint
3296   function presale(
3297     bytes32[] memory proof,
3298     uint256 alloc,
3299     uint256 amount
3300   ) payable external nonReentrant whenNotPaused {
3301     require(
3302       verifyMerklePath(_msgSender(), whitelistMerkleRoot, proof, alloc),
3303       "not whitelisted"
3304     );
3305     require(whitelistAccounts[_msgSender()] + amount <= alloc, "all NFTs purchased");
3306     require(block.timestamp <= preSaleEndTs, "presale finished");
3307 
3308     whitelistSold += amount;
3309     whitelistAccounts[_msgSender()] += amount;
3310 
3311     // send the purchase price to treausury
3312     transferFunds(amount * presalePrice);
3313     _mint(amount, _msgSender());
3314 
3315     emit Presale(_msgSender(), amount);
3316   }
3317 
3318   function registerRaffle(uint256 qty) external nonReentrant whenNotPaused {
3319     require(qty + userCount[_msgSender()] <= personalCap, "too many mints");
3320     raffleState.registerRaffle(_msgSender(), qty, publicPrice);
3321     emit Registered(_msgSender(), qty);
3322   }
3323 
3324   function raffleWinnerBuy(bytes32[] memory proof, uint256 qty) external payable {
3325     raffleState.buy(_msgSender(), proof, qty);
3326 
3327     // send the purchase price to treausury
3328     transferFunds(qty * publicPrice);
3329     _mint(qty, _msgSender());
3330   }
3331   
3332   function _mint(uint256 qty, address recipient) private {
3333     require(totalSupply() + qty <= maxSupply, "max supply");
3334 
3335     if(qty > 0) {
3336       _safeMint(recipient, qty);
3337       userCount[recipient] += qty;
3338     }
3339   }
3340 
3341   function publicSale(uint256 qty) external payable nonReentrant whenNotPaused {
3342     require(block.timestamp > publicStartTs, "public sale not open");
3343     require(qty + userCount[_msgSender()] <= personalCap, "too many mints");
3344 
3345     transferFunds(qty * publicPrice);
3346     _mint(qty, _msgSender());
3347   }
3348 
3349   function reveal() external onlyOwner {
3350     if (!randomNumberReqSent && block.timestamp >= revealTimestamp) {
3351       randomNumberReqSent = true;
3352       randomGenerator.getRandomNumber();
3353     }
3354   }
3355 }