1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
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
72      * @dev Safely transfers `tokenId` token from `from` to `to`.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId,
88         bytes calldata data
89     ) external;
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
196      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
207 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
211 
212 pragma solidity ^0.8.0;
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Metadata is IERC721 {
218     /**
219      * @dev Returns the token collection name.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the token collection symbol.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
230      */
231     function tokenURI(uint256 tokenId) external view returns (string memory);
232 }
233 
234 
235 // File @openzeppelin/contracts/utils/Address.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
239 
240 pragma solidity ^0.8.1;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      *
263      * [IMPORTANT]
264      * ====
265      * You shouldn't rely on `isContract` to protect against flash loan attacks!
266      *
267      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
268      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
269      * constructor.
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // This method relies on extcodesize/address.code.length, which returns 0
274         // for contracts in construction, since the code is only stored at the end
275         // of the constructor execution.
276 
277         return account.code.length > 0;
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         (bool success, ) = recipient.call{value: amount}("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain `call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
360      * with `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         require(isContract(target), "Address: call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.call{value: value}(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
384         return functionStaticCall(target, data, "Address: low-level static call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a static call.
390      *
391      * _Available since v3.3._
392      */
393     function functionStaticCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal view returns (bytes memory) {
398         require(isContract(target), "Address: static call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.staticcall(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a delegate call.
417      *
418      * _Available since v3.4._
419      */
420     function functionDelegateCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(isContract(target), "Address: delegate call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.delegatecall(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
433      * revert reason using the provided one.
434      *
435      * _Available since v4.3._
436      */
437     function verifyCallResult(
438         bool success,
439         bytes memory returndata,
440         string memory errorMessage
441     ) internal pure returns (bytes memory) {
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 assembly {
450                     let returndata_size := mload(returndata)
451                     revert(add(32, returndata), returndata_size)
452                 }
453             } else {
454                 revert(errorMessage);
455             }
456         }
457     }
458 }
459 
460 
461 // File @openzeppelin/contracts/utils/Context.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Provides information about the current execution context, including the
470  * sender of the transaction and its data. While these are generally available
471  * via msg.sender and msg.data, they should not be accessed in such a direct
472  * manner, since when dealing with meta-transactions the account sending and
473  * paying for execution may not be the actual sender (as far as an application
474  * is concerned).
475  *
476  * This contract is only required for intermediate, library-like contracts.
477  */
478 abstract contract Context {
479     function _msgSender() internal view virtual returns (address) {
480         return msg.sender;
481     }
482 
483     function _msgData() internal view virtual returns (bytes calldata) {
484         return msg.data;
485     }
486 }
487 
488 
489 // File @openzeppelin/contracts/utils/Strings.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev String operations.
498  */
499 library Strings {
500     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
504      */
505     function toString(uint256 value) internal pure returns (string memory) {
506         // Inspired by OraclizeAPI's implementation - MIT licence
507         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
508 
509         if (value == 0) {
510             return "0";
511         }
512         uint256 temp = value;
513         uint256 digits;
514         while (temp != 0) {
515             digits++;
516             temp /= 10;
517         }
518         bytes memory buffer = new bytes(digits);
519         while (value != 0) {
520             digits -= 1;
521             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
522             value /= 10;
523         }
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
529      */
530     function toHexString(uint256 value) internal pure returns (string memory) {
531         if (value == 0) {
532             return "0x00";
533         }
534         uint256 temp = value;
535         uint256 length = 0;
536         while (temp != 0) {
537             length++;
538             temp >>= 8;
539         }
540         return toHexString(value, length);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
545      */
546     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
547         bytes memory buffer = new bytes(2 * length + 2);
548         buffer[0] = "0";
549         buffer[1] = "x";
550         for (uint256 i = 2 * length + 1; i > 1; --i) {
551             buffer[i] = _HEX_SYMBOLS[value & 0xf];
552             value >>= 4;
553         }
554         require(value == 0, "Strings: hex length insufficient");
555         return string(buffer);
556     }
557 }
558 
559 
560 // File @openzeppelin/contracts/utils/introspection/ERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 /**
567  * @dev Implementation of the {IERC165} interface.
568  *
569  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
570  * for the additional interface id that will be supported. For example:
571  *
572  * ```solidity
573  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
575  * }
576  * ```
577  *
578  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
579  */
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 
590 // File erc721a/contracts/ERC721A.sol
591 
592 
593 
594 
595 pragma solidity ^0.8.4;
596 error ApprovalCallerNotOwnerNorApproved();
597 error ApprovalQueryForNonexistentToken();
598 error ApproveToCaller();
599 error ApprovalToCurrentOwner();
600 error BalanceQueryForZeroAddress();
601 error MintToZeroAddress();
602 error MintZeroQuantity();
603 error OwnerQueryForNonexistentToken();
604 error TransferCallerNotOwnerNorApproved();
605 error TransferFromIncorrectOwner();
606 error TransferToNonERC721ReceiverImplementer();
607 error TransferToZeroAddress();
608 error URIQueryForNonexistentToken();
609 
610 /**
611  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
612  * the Metadata extension. Built to optimize for lower gas during batch mints.
613  *
614  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
615  *
616  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
617  *
618  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
619  */
620 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
621     using Address for address;
622     using Strings for uint256;
623 
624     // Compiler will pack this into a single 256bit word.
625     struct TokenOwnership {
626         // The address of the owner.
627         address addr;
628         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
629         uint64 startTimestamp;
630         // Whether the token has been burned.
631         bool burned;
632     }
633 
634     // Compiler will pack this into a single 256bit word.
635     struct AddressData {
636         // Realistically, 2**64-1 is more than enough.
637         uint64 balance;
638         // Keeps track of mint count with minimal overhead for tokenomics.
639         uint64 numberMinted;
640         // Keeps track of burn count with minimal overhead for tokenomics.
641         uint64 numberBurned;
642         // For miscellaneous variable(s) pertaining to the address
643         // (e.g. number of whitelist mint slots used).
644         // If there are multiple variables, please pack them into a uint64.
645         uint64 aux;
646     }
647 
648     // The tokenId of the next token to be minted.
649     uint256 internal _currentIndex;
650 
651     // The number of tokens burned.
652     uint256 internal _burnCounter;
653 
654     // Token name
655     string private _name;
656 
657     // Token symbol
658     string private _symbol;
659 
660     // Mapping from token ID to ownership details
661     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
662     mapping(uint256 => TokenOwnership) internal _ownerships;
663 
664     // Mapping owner address to address data
665     mapping(address => AddressData) private _addressData;
666 
667     // Mapping from token ID to approved address
668     mapping(uint256 => address) private _tokenApprovals;
669 
670     // Mapping from owner to operator approvals
671     mapping(address => mapping(address => bool)) private _operatorApprovals;
672 
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676         _currentIndex = _startTokenId();
677     }
678 
679     /**
680      * To change the starting tokenId, please override this function.
681      */
682     function _startTokenId() internal view virtual returns (uint256) {
683         return 0;
684     }
685 
686     /**
687      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
688      */
689     function totalSupply() public view returns (uint256) {
690         // Counter underflow is impossible as _burnCounter cannot be incremented
691         // more than _currentIndex - _startTokenId() times
692         unchecked {
693             return _currentIndex - _burnCounter - _startTokenId();
694         }
695     }
696 
697     /**
698      * Returns the total amount of tokens minted in the contract.
699      */
700     function _totalMinted() internal view returns (uint256) {
701         // Counter underflow is impossible as _currentIndex does not decrement,
702         // and it is initialized to _startTokenId()
703         unchecked {
704             return _currentIndex - _startTokenId();
705         }
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713             interfaceId == type(IERC721).interfaceId ||
714             interfaceId == type(IERC721Metadata).interfaceId ||
715             super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view override returns (uint256) {
722         if (owner == address(0)) revert BalanceQueryForZeroAddress();
723         return uint256(_addressData[owner].balance);
724     }
725 
726     /**
727      * Returns the number of tokens minted by `owner`.
728      */
729     function _numberMinted(address owner) internal view returns (uint256) {
730         return uint256(_addressData[owner].numberMinted);
731     }
732 
733     /**
734      * Returns the number of tokens burned by or on behalf of `owner`.
735      */
736     function _numberBurned(address owner) internal view returns (uint256) {
737         return uint256(_addressData[owner].numberBurned);
738     }
739 
740     /**
741      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
742      */
743     function _getAux(address owner) internal view returns (uint64) {
744         return _addressData[owner].aux;
745     }
746 
747     /**
748      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
749      * If there are multiple variables, please pack them into a uint64.
750      */
751     function _setAux(address owner, uint64 aux) internal {
752         _addressData[owner].aux = aux;
753     }
754 
755     /**
756      * Gas spent here starts off proportional to the maximum mint batch size.
757      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
758      */
759     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
760         uint256 curr = tokenId;
761 
762         unchecked {
763             if (_startTokenId() <= curr && curr < _currentIndex) {
764                 TokenOwnership memory ownership = _ownerships[curr];
765                 if (!ownership.burned) {
766                     if (ownership.addr != address(0)) {
767                         return ownership;
768                     }
769                     // Invariant:
770                     // There will always be an ownership that has an address and is not burned
771                     // before an ownership that does not have an address and is not burned.
772                     // Hence, curr will not underflow.
773                     while (true) {
774                         curr--;
775                         ownership = _ownerships[curr];
776                         if (ownership.addr != address(0)) {
777                             return ownership;
778                         }
779                     }
780                 }
781             }
782         }
783         revert OwnerQueryForNonexistentToken();
784     }
785 
786     /**
787      * @dev See {IERC721-ownerOf}.
788      */
789     function ownerOf(uint256 tokenId) public view override returns (address) {
790         return _ownershipOf(tokenId).addr;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-name}.
795      */
796     function name() public view virtual override returns (string memory) {
797         return _name;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-symbol}.
802      */
803     function symbol() public view virtual override returns (string memory) {
804         return _symbol;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-tokenURI}.
809      */
810     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
811         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
812 
813         string memory baseURI = _baseURI();
814         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
815     }
816 
817     /**
818      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
819      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
820      * by default, can be overriden in child contracts.
821      */
822     function _baseURI() internal view virtual returns (string memory) {
823         return '';
824     }
825 
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public override {
830         address owner = ERC721A.ownerOf(tokenId);
831         if (to == owner) revert ApprovalToCurrentOwner();
832 
833         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
834             revert ApprovalCallerNotOwnerNorApproved();
835         }
836 
837         _approve(to, tokenId, owner);
838     }
839 
840     /**
841      * @dev See {IERC721-getApproved}.
842      */
843     function getApproved(uint256 tokenId) public view override returns (address) {
844         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
845 
846         return _tokenApprovals[tokenId];
847     }
848 
849     /**
850      * @dev See {IERC721-setApprovalForAll}.
851      */
852     function setApprovalForAll(address operator, bool approved) public virtual override {
853         if (operator == _msgSender()) revert ApproveToCaller();
854 
855         _operatorApprovals[_msgSender()][operator] = approved;
856         emit ApprovalForAll(_msgSender(), operator, approved);
857     }
858 
859     /**
860      * @dev See {IERC721-isApprovedForAll}.
861      */
862     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
863         return _operatorApprovals[owner][operator];
864     }
865 
866     /**
867      * @dev See {IERC721-transferFrom}.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public virtual override {
874         _transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         safeTransferFrom(from, to, tokenId, '');
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) public virtual override {
897         _transfer(from, to, tokenId);
898         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
899             revert TransferToNonERC721ReceiverImplementer();
900         }
901     }
902 
903     /**
904      * @dev Returns whether `tokenId` exists.
905      *
906      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907      *
908      * Tokens start existing when they are minted (`_mint`),
909      */
910     function _exists(uint256 tokenId) internal view returns (bool) {
911         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
912     }
913 
914     function _safeMint(address to, uint256 quantity) internal {
915         _safeMint(to, quantity, '');
916     }
917 
918     /**
919      * @dev Safely mints `quantity` tokens and transfers them to `to`.
920      *
921      * Requirements:
922      *
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
924      * - `quantity` must be greater than 0.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeMint(
929         address to,
930         uint256 quantity,
931         bytes memory _data
932     ) internal {
933         _mint(to, quantity, _data, true);
934     }
935 
936     /**
937      * @dev Mints `quantity` tokens and transfers them to `to`.
938      *
939      * Requirements:
940      *
941      * - `to` cannot be the zero address.
942      * - `quantity` must be greater than 0.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _mint(
947         address to,
948         uint256 quantity,
949         bytes memory _data,
950         bool safe
951     ) internal {
952         uint256 startTokenId = _currentIndex;
953         if (to == address(0)) revert MintToZeroAddress();
954         if (quantity == 0) revert MintZeroQuantity();
955 
956         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
957 
958         // Overflows are incredibly unrealistic.
959         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
960         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
961         unchecked {
962             _addressData[to].balance += uint64(quantity);
963             _addressData[to].numberMinted += uint64(quantity);
964 
965             _ownerships[startTokenId].addr = to;
966             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
967 
968             uint256 updatedIndex = startTokenId;
969             uint256 end = updatedIndex + quantity;
970 
971             if (safe && to.isContract()) {
972                 do {
973                     emit Transfer(address(0), to, updatedIndex);
974                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
975                         revert TransferToNonERC721ReceiverImplementer();
976                     }
977                 } while (updatedIndex != end);
978                 // Reentrancy protection
979                 if (_currentIndex != startTokenId) revert();
980             } else {
981                 do {
982                     emit Transfer(address(0), to, updatedIndex++);
983                 } while (updatedIndex != end);
984             }
985             _currentIndex = updatedIndex;
986         }
987         _afterTokenTransfers(address(0), to, startTokenId, quantity);
988     }
989 
990     /**
991      * @dev Transfers `tokenId` from `from` to `to`.
992      *
993      * Requirements:
994      *
995      * - `to` cannot be the zero address.
996      * - `tokenId` token must be owned by `from`.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _transfer(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) private {
1005         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1006 
1007         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1008 
1009         bool isApprovedOrOwner = (_msgSender() == from ||
1010             isApprovedForAll(from, _msgSender()) ||
1011             getApproved(tokenId) == _msgSender());
1012 
1013         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1014         if (to == address(0)) revert TransferToZeroAddress();
1015 
1016         _beforeTokenTransfers(from, to, tokenId, 1);
1017 
1018         // Clear approvals from the previous owner
1019         _approve(address(0), tokenId, from);
1020 
1021         // Underflow of the sender's balance is impossible because we check for
1022         // ownership above and the recipient's balance can't realistically overflow.
1023         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1024         unchecked {
1025             _addressData[from].balance -= 1;
1026             _addressData[to].balance += 1;
1027 
1028             TokenOwnership storage currSlot = _ownerships[tokenId];
1029             currSlot.addr = to;
1030             currSlot.startTimestamp = uint64(block.timestamp);
1031 
1032             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1033             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1034             uint256 nextTokenId = tokenId + 1;
1035             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1036             if (nextSlot.addr == address(0)) {
1037                 // This will suffice for checking _exists(nextTokenId),
1038                 // as a burned slot cannot contain the zero address.
1039                 if (nextTokenId != _currentIndex) {
1040                     nextSlot.addr = from;
1041                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, to, tokenId);
1047         _afterTokenTransfers(from, to, tokenId, 1);
1048     }
1049 
1050     /**
1051      * @dev This is equivalent to _burn(tokenId, false)
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         _burn(tokenId, false);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1068         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1069 
1070         address from = prevOwnership.addr;
1071 
1072         if (approvalCheck) {
1073             bool isApprovedOrOwner = (_msgSender() == from ||
1074                 isApprovedForAll(from, _msgSender()) ||
1075                 getApproved(tokenId) == _msgSender());
1076 
1077             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1078         }
1079 
1080         _beforeTokenTransfers(from, address(0), tokenId, 1);
1081 
1082         // Clear approvals from the previous owner
1083         _approve(address(0), tokenId, from);
1084 
1085         // Underflow of the sender's balance is impossible because we check for
1086         // ownership above and the recipient's balance can't realistically overflow.
1087         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1088         unchecked {
1089             AddressData storage addressData = _addressData[from];
1090             addressData.balance -= 1;
1091             addressData.numberBurned += 1;
1092 
1093             // Keep track of who burned the token, and the timestamp of burning.
1094             TokenOwnership storage currSlot = _ownerships[tokenId];
1095             currSlot.addr = from;
1096             currSlot.startTimestamp = uint64(block.timestamp);
1097             currSlot.burned = true;
1098 
1099             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1100             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1101             uint256 nextTokenId = tokenId + 1;
1102             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1103             if (nextSlot.addr == address(0)) {
1104                 // This will suffice for checking _exists(nextTokenId),
1105                 // as a burned slot cannot contain the zero address.
1106                 if (nextTokenId != _currentIndex) {
1107                     nextSlot.addr = from;
1108                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1109                 }
1110             }
1111         }
1112 
1113         emit Transfer(from, address(0), tokenId);
1114         _afterTokenTransfers(from, address(0), tokenId, 1);
1115 
1116         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1117         unchecked {
1118             _burnCounter++;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Approve `to` to operate on `tokenId`
1124      *
1125      * Emits a {Approval} event.
1126      */
1127     function _approve(
1128         address to,
1129         uint256 tokenId,
1130         address owner
1131     ) private {
1132         _tokenApprovals[tokenId] = to;
1133         emit Approval(owner, to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1138      *
1139      * @param from address representing the previous owner of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkContractOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1152             return retval == IERC721Receiver(to).onERC721Received.selector;
1153         } catch (bytes memory reason) {
1154             if (reason.length == 0) {
1155                 revert TransferToNonERC721ReceiverImplementer();
1156             } else {
1157                 assembly {
1158                     revert(add(32, reason), mload(reason))
1159                 }
1160             }
1161         }
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1166      * And also called before burning one token.
1167      *
1168      * startTokenId - the first token id to be transferred
1169      * quantity - the amount to be transferred
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` will be minted for `to`.
1176      * - When `to` is zero, `tokenId` will be burned by `from`.
1177      * - `from` and `to` are never both zero.
1178      */
1179     function _beforeTokenTransfers(
1180         address from,
1181         address to,
1182         uint256 startTokenId,
1183         uint256 quantity
1184     ) internal virtual {}
1185 
1186     /**
1187      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1188      * minting.
1189      * And also called after one token has been burned.
1190      *
1191      * startTokenId - the first token id to be transferred
1192      * quantity - the amount to be transferred
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` has been minted for `to`.
1199      * - When `to` is zero, `tokenId` has been burned by `from`.
1200      * - `from` and `to` are never both zero.
1201      */
1202     function _afterTokenTransfers(
1203         address from,
1204         address to,
1205         uint256 startTokenId,
1206         uint256 quantity
1207     ) internal virtual {}
1208 }
1209 
1210 
1211 // File @openzeppelin/contracts/access/Ownable.sol
1212 
1213 
1214 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1215 
1216 pragma solidity ^0.8.0;
1217 /**
1218  * @dev Contract module which provides a basic access control mechanism, where
1219  * there is an account (an owner) that can be granted exclusive access to
1220  * specific functions.
1221  *
1222  * By default, the owner account will be the one that deploys the contract. This
1223  * can later be changed with {transferOwnership}.
1224  *
1225  * This module is used through inheritance. It will make available the modifier
1226  * `onlyOwner`, which can be applied to your functions to restrict their use to
1227  * the owner.
1228  */
1229 abstract contract Ownable is Context {
1230     address private _owner;
1231 
1232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1233 
1234     /**
1235      * @dev Initializes the contract setting the deployer as the initial owner.
1236      */
1237     constructor() {
1238         _transferOwnership(_msgSender());
1239     }
1240 
1241     /**
1242      * @dev Returns the address of the current owner.
1243      */
1244     function owner() public view virtual returns (address) {
1245         return _owner;
1246     }
1247 
1248     /**
1249      * @dev Throws if called by any account other than the owner.
1250      */
1251     modifier onlyOwner() {
1252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1253         _;
1254     }
1255 
1256     /**
1257      * @dev Leaves the contract without owner. It will not be possible to call
1258      * `onlyOwner` functions anymore. Can only be called by the current owner.
1259      *
1260      * NOTE: Renouncing ownership will leave the contract without an owner,
1261      * thereby removing any functionality that is only available to the owner.
1262      */
1263     function renounceOwnership() public virtual onlyOwner {
1264         _transferOwnership(address(0));
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Can only be called by the current owner.
1270      */
1271     function transferOwnership(address newOwner) public virtual onlyOwner {
1272         require(newOwner != address(0), "Ownable: new owner is the zero address");
1273         _transferOwnership(newOwner);
1274     }
1275 
1276     /**
1277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1278      * Internal function without access restriction.
1279      */
1280     function _transferOwnership(address newOwner) internal virtual {
1281         address oldOwner = _owner;
1282         _owner = newOwner;
1283         emit OwnershipTransferred(oldOwner, newOwner);
1284     }
1285 }
1286 
1287 
1288 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1289 
1290 
1291 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 /**
1296  * @dev These functions deal with verification of Merkle Trees proofs.
1297  *
1298  * The proofs can be generated using the JavaScript library
1299  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1300  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1301  *
1302  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1303  *
1304  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1305  * hashing, or use a hash function other than keccak256 for hashing leaves.
1306  * This is because the concatenation of a sorted pair of internal nodes in
1307  * the merkle tree could be reinterpreted as a leaf value.
1308  */
1309 library MerkleProof {
1310     /**
1311      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1312      * defined by `root`. For this, a `proof` must be provided, containing
1313      * sibling hashes on the branch from the leaf to the root of the tree. Each
1314      * pair of leaves and each pair of pre-images are assumed to be sorted.
1315      */
1316     function verify(
1317         bytes32[] memory proof,
1318         bytes32 root,
1319         bytes32 leaf
1320     ) internal pure returns (bool) {
1321         return processProof(proof, leaf) == root;
1322     }
1323 
1324     /**
1325      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1326      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1327      * hash matches the root of the tree. When processing the proof, the pairs
1328      * of leafs & pre-images are assumed to be sorted.
1329      *
1330      * _Available since v4.4._
1331      */
1332     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1333         bytes32 computedHash = leaf;
1334         for (uint256 i = 0; i < proof.length; i++) {
1335             bytes32 proofElement = proof[i];
1336             if (computedHash <= proofElement) {
1337                 // Hash(current computed hash + current element of the proof)
1338                 computedHash = _efficientHash(computedHash, proofElement);
1339             } else {
1340                 // Hash(current element of the proof + current computed hash)
1341                 computedHash = _efficientHash(proofElement, computedHash);
1342             }
1343         }
1344         return computedHash;
1345     }
1346 
1347     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1348         assembly {
1349             mstore(0x00, a)
1350             mstore(0x20, b)
1351             value := keccak256(0x00, 0x40)
1352         }
1353     }
1354 }
1355 
1356 
1357 // File @openzeppelin/contracts/security/ReentrancyGuard.sol
1358 
1359 
1360 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1361 
1362 pragma solidity ^0.8.0;
1363 
1364 /**
1365  * @dev Contract module that helps prevent reentrant calls to a function.
1366  *
1367  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1368  * available, which can be applied to functions to make sure there are no nested
1369  * (reentrant) calls to them.
1370  *
1371  * Note that because there is a single `nonReentrant` guard, functions marked as
1372  * `nonReentrant` may not call one another. This can be worked around by making
1373  * those functions `private`, and then adding `external` `nonReentrant` entry
1374  * points to them.
1375  *
1376  * TIP: If you would like to learn more about reentrancy and alternative ways
1377  * to protect against it, check out our blog post
1378  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1379  */
1380 abstract contract ReentrancyGuard {
1381     // Booleans are more expensive than uint256 or any type that takes up a full
1382     // word because each write operation emits an extra SLOAD to first read the
1383     // slot's contents, replace the bits taken up by the boolean, and then write
1384     // back. This is the compiler's defense against contract upgrades and
1385     // pointer aliasing, and it cannot be disabled.
1386 
1387     // The values being non-zero value makes deployment a bit more expensive,
1388     // but in exchange the refund on every call to nonReentrant will be lower in
1389     // amount. Since refunds are capped to a percentage of the total
1390     // transaction's gas, it is best to keep them low in cases like this one, to
1391     // increase the likelihood of the full refund coming into effect.
1392     uint256 private constant _NOT_ENTERED = 1;
1393     uint256 private constant _ENTERED = 2;
1394 
1395     uint256 private _status;
1396 
1397     constructor() {
1398         _status = _NOT_ENTERED;
1399     }
1400 
1401     /**
1402      * @dev Prevents a contract from calling itself, directly or indirectly.
1403      * Calling a `nonReentrant` function from another `nonReentrant`
1404      * function is not supported. It is possible to prevent this from happening
1405      * by making the `nonReentrant` function external, and making it call a
1406      * `private` function that does the actual work.
1407      */
1408     modifier nonReentrant() {
1409         // On the first call to nonReentrant, _notEntered will be true
1410         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1411 
1412         // Any calls to nonReentrant after this point will fail
1413         _status = _ENTERED;
1414 
1415         _;
1416 
1417         // By storing the original value once again, a refund is triggered (see
1418         // https://eips.ethereum.org/EIPS/eip-2200)
1419         _status = _NOT_ENTERED;
1420     }
1421 }
1422 
1423 
1424 // File contracts/Bags.sol
1425 
1426 
1427 
1428 pragma solidity >=0.8.9 <0.9.0;
1429 contract bags is ERC721A, Ownable, ReentrancyGuard {
1430 
1431   using Strings for uint256;
1432 
1433   bytes32 public merkleRoot;
1434   mapping(address => bool) public whitelistClaimed;
1435 
1436   string public uriPrefix = '';
1437   string public uriSuffix = '.json';
1438   string public hiddenMetadataUri;
1439   
1440   uint256 public cost;
1441   uint256 public maxSupply;
1442   uint256 public maxMintAmountPerTx;
1443 
1444   bool public paused = true;
1445   bool public whitelistMintEnabled = false;
1446   bool public revealed = false;
1447 
1448   constructor(
1449     string memory _tokenName,
1450     string memory _tokenSymbol,
1451     uint256 _cost,
1452     uint256 _maxSupply,
1453     uint256 _maxMintAmountPerTx,
1454     string memory _hiddenMetadataUri
1455   ) ERC721A(_tokenName, _tokenSymbol) {
1456     setCost(_cost);
1457     maxSupply = _maxSupply;
1458     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1459     setHiddenMetadataUri(_hiddenMetadataUri);
1460   }
1461 
1462   modifier mintCompliance(uint256 _mintAmount) {
1463     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1464     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1465     _;
1466   }
1467 
1468   modifier mintPriceCompliance(uint256 _mintAmount) {
1469     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1470     _;
1471   }
1472 
1473   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1474     // Verify whitelist requirements
1475     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1476     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1477     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1478     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1479 
1480     whitelistClaimed[_msgSender()] = true;
1481     _safeMint(_msgSender(), _mintAmount);
1482   }
1483 
1484   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1485     require(!paused, 'The contract is paused!');
1486 
1487     _safeMint(_msgSender(), _mintAmount);
1488   }
1489   
1490   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1491     _safeMint(_receiver, _mintAmount);
1492   }
1493 
1494   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1495     uint256 ownerTokenCount = balanceOf(_owner);
1496     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1497     uint256 currentTokenId = _startTokenId();
1498     uint256 ownedTokenIndex = 0;
1499     address latestOwnerAddress;
1500 
1501     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1502       if (_exists(currentTokenId)) {
1503         TokenOwnership memory ownership = _ownerships[currentTokenId];
1504 
1505         if (ownership.addr != address(0)) {
1506           latestOwnerAddress = ownership.addr;
1507         }
1508 
1509         if (latestOwnerAddress == _owner) {
1510           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1511 
1512           ownedTokenIndex++;
1513         }
1514       }
1515 
1516       currentTokenId++;
1517     }
1518 
1519     return ownedTokenIds;
1520   }
1521 
1522   function _startTokenId() internal view virtual override returns (uint256) {
1523     return 1;
1524   }
1525 
1526   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1527     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1528 
1529     if (revealed == false) {
1530       return hiddenMetadataUri;
1531     }
1532 
1533     string memory currentBaseURI = _baseURI();
1534     return bytes(currentBaseURI).length > 0
1535         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1536         : '';
1537   }
1538 
1539   function setRevealed(bool _state) public onlyOwner {
1540     revealed = _state;
1541   }
1542 
1543   function setCost(uint256 _cost) public onlyOwner {
1544     cost = _cost;
1545   }
1546 
1547   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1548     maxMintAmountPerTx = _maxMintAmountPerTx;
1549   }
1550 
1551   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1552     hiddenMetadataUri = _hiddenMetadataUri;
1553   }
1554 
1555   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1556     uriPrefix = _uriPrefix;
1557   }
1558 
1559   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1560     uriSuffix = _uriSuffix;
1561   }
1562 
1563   function setPaused(bool _state) public onlyOwner {
1564     paused = _state;
1565   }
1566 
1567   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1568     merkleRoot = _merkleRoot;
1569   }
1570 
1571   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1572     whitelistMintEnabled = _state;
1573   }
1574 
1575   function withdraw() public onlyOwner nonReentrant {
1576    
1577     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1578     require(os);
1579   }
1580 
1581   function _baseURI() internal view virtual override returns (string memory) {
1582     return uriPrefix;
1583   }
1584 }