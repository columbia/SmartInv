1 // SPDX-License-Identifier: MIT 
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Address.sol
71 
72 
73 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
74 
75 pragma solidity ^0.8.1;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      *
98      * [IMPORTANT]
99      * ====
100      * You shouldn't rely on `isContract` to protect against flash loan attacks!
101      *
102      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
103      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
104      * constructor.
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies on extcodesize/address.code.length, which returns 0
109         // for contracts in construction, since the code is only stored at the end
110         // of the constructor execution.
111 
112         return account.code.length > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         (bool success, ) = recipient.call{value: amount}("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
219         return functionStaticCall(target, data, "Address: low-level static call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal view returns (bytes memory) {
233         require(isContract(target), "Address: static call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.delegatecall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
268      * revert reason using the provided one.
269      *
270      * _Available since v4.3._
271      */
272     function verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) internal pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 
295 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @title ERC721 token receiver interface
304  * @dev Interface for any contract that wants to support safeTransfers
305  * from ERC721 asset contracts.
306  */
307 interface IERC721Receiver {
308     /**
309      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
310      * by `operator` from `from`, this function is called.
311      *
312      * It must return its Solidity selector to confirm the token transfer.
313      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
314      *
315      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
316      */
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC165 standard, as defined in the
334  * https://eips.ethereum.org/EIPS/eip-165[EIP].
335  *
336  * Implementers can declare support of contract interfaces, which can then be
337  * queried by others ({ERC165Checker}).
338  *
339  * For an implementation, see {ERC165}.
340  */
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Implementation of the {IERC165} interface.
363  *
364  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
365  * for the additional interface id that will be supported. For example:
366  *
367  * ```solidity
368  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
369  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
370  * }
371  * ```
372  *
373  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
374  */
375 abstract contract ERC165 is IERC165 {
376     /**
377      * @dev See {IERC165-supportsInterface}.
378      */
379     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380         return interfaceId == type(IERC165).interfaceId;
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 
392 /**
393  * @dev Required interface of an ERC721 compliant contract.
394  */
395 interface IERC721 is IERC165 {
396     /**
397      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
398      */
399     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
403      */
404     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
408      */
409     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
410 
411     /**
412      * @dev Returns the number of tokens in ``owner``'s account.
413      */
414     function balanceOf(address owner) external view returns (uint256 balance);
415 
416     /**
417      * @dev Returns the owner of the `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function ownerOf(uint256 tokenId) external view returns (address owner);
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
427      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Transfers `tokenId` token from `from` to `to`.
447      *
448      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
467      * The approval is cleared when the token is transferred.
468      *
469      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
470      *
471      * Requirements:
472      *
473      * - The caller must own the token or be an approved operator.
474      * - `tokenId` must exist.
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address to, uint256 tokenId) external;
479 
480     /**
481      * @dev Returns the account approved for `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function getApproved(uint256 tokenId) external view returns (address operator);
488 
489     /**
490      * @dev Approve or remove `operator` as an operator for the caller.
491      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
492      *
493      * Requirements:
494      *
495      * - The `operator` cannot be the caller.
496      *
497      * Emits an {ApprovalForAll} event.
498      */
499     function setApprovalForAll(address operator, bool _approved) external;
500 
501     /**
502      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
503      *
504      * See {setApprovalForAll}
505      */
506     function isApprovedForAll(address owner, address operator) external view returns (bool);
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId,
525         bytes calldata data
526     ) external;
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
539  * @dev See https://eips.ethereum.org/EIPS/eip-721
540  */
541 interface IERC721Metadata is IERC721 {
542     /**
543      * @dev Returns the token collection name.
544      */
545     function name() external view returns (string memory);
546 
547     /**
548      * @dev Returns the token collection symbol.
549      */
550     function symbol() external view returns (string memory);
551 
552     /**
553      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
554      */
555     function tokenURI(uint256 tokenId) external view returns (string memory);
556 }
557 
558 // File: @openzeppelin/contracts/utils/Context.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev Provides information about the current execution context, including the
567  * sender of the transaction and its data. While these are generally available
568  * via msg.sender and msg.data, they should not be accessed in such a direct
569  * manner, since when dealing with meta-transactions the account sending and
570  * paying for execution may not be the actual sender (as far as an application
571  * is concerned).
572  *
573  * This contract is only required for intermediate, library-like contracts.
574  */
575 abstract contract Context {
576     function _msgSender() internal view virtual returns (address) {
577         return msg.sender;
578     }
579 
580     function _msgData() internal view virtual returns (bytes calldata) {
581         return msg.data;
582     }
583 }
584 
585 // File: erc721a/contracts/ERC721A.sol
586 
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
914         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
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
1213 // File: @openzeppelin/contracts/access/Ownable.sol
1214 
1215 
1216 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 
1221 /**
1222  * @dev Contract module which provides a basic access control mechanism, where
1223  * there is an account (an owner) that can be granted exclusive access to
1224  * specific functions.
1225  *
1226  * By default, the owner account will be the one that deploys the contract. This
1227  * can later be changed with {transferOwnership}.
1228  *
1229  * This module is used through inheritance. It will make available the modifier
1230  * `onlyOwner`, which can be applied to your functions to restrict their use to
1231  * the owner.
1232  */
1233 abstract contract Ownable is Context {
1234     address private _owner;
1235 
1236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1237 
1238     /**
1239      * @dev Initializes the contract setting the deployer as the initial owner.
1240      */
1241     constructor() {
1242         _transferOwnership(_msgSender());
1243     }
1244 
1245     /**
1246      * @dev Returns the address of the current owner.
1247      */
1248     function owner() public view virtual returns (address) {
1249         return _owner;
1250     }
1251 
1252     /**
1253      * @dev Throws if called by any account other than the owner.
1254      */
1255     modifier onlyOwner() {
1256         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1257         _;
1258     }
1259 
1260     /**
1261      * @dev Leaves the contract without owner. It will not be possible to call
1262      * `onlyOwner` functions anymore. Can only be called by the current owner.
1263      *
1264      * NOTE: Renouncing ownership will leave the contract without an owner,
1265      * thereby removing any functionality that is only available to the owner.
1266      */
1267     function renounceOwnership() public virtual onlyOwner {
1268         _transferOwnership(address(0));
1269     }
1270 
1271     /**
1272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1273      * Can only be called by the current owner.
1274      */
1275     function transferOwnership(address newOwner) public virtual onlyOwner {
1276         require(newOwner != address(0), "Ownable: new owner is the zero address");
1277         _transferOwnership(newOwner);
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Internal function without access restriction.
1283      */
1284     function _transferOwnership(address newOwner) internal virtual {
1285         address oldOwner = _owner;
1286         _owner = newOwner;
1287         emit OwnershipTransferred(oldOwner, newOwner);
1288     }
1289 }
1290 
1291 // File: contracts/MOONMOON.sol
1292 
1293 
1294 pragma solidity >=0.8.0 <0.9.0;
1295 
1296 
1297 
1298 
1299 
1300 contract moonmoon is ERC721A, Ownable { 
1301 
1302   using Strings for uint256;
1303 
1304   string private uriPrefix = "ipfs://QmdchXXfbCrxms9Xis997dVVxz6U25MbVbwrD5SLe8q23r/";
1305   string public uriSuffix = ".json"; 
1306   string public hiddenMetadataUri;
1307   
1308   uint256 public cost = 0.00 ether; 
1309 
1310   uint256 public maxSupply = 2000; 
1311   uint256 public maxMintAmountPerTx = 1; 
1312   uint256 public totalMaxMintAmount = 1; 
1313 
1314   uint256 public freeMaxMintAmount = 1; 
1315 
1316   bool public paused = true;
1317   bool public publicSale = false;
1318   bool public revealed = false;
1319 
1320   mapping(address => uint256) public addressMintedBalance; 
1321 
1322   constructor() ERC721A("moonmoon", "MOON") { 
1323          setHiddenMetadataUri("ipfs://QmarkEM8ZJjq8dRuFZ8t45FN5jcDbwq9pRsYEkRQ8nNc9s/hidden.json"); 
1324             ownerMint(5); 
1325     } 
1326 
1327   // MODIFIERS 
1328   
1329   modifier mintCompliance(uint256 _mintAmount) {
1330     if (msg.sender != owner()) { 
1331         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1332     }
1333     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1334     _;
1335   } 
1336 
1337   modifier mintPriceCompliance(uint256 _mintAmount) {
1338     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1339    if (ownerMintedCount >= freeMaxMintAmount) {
1340         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1341    }
1342         _;
1343   }
1344 
1345   // MINTS 
1346 
1347    function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1348     require(!paused, 'The contract is paused!'); 
1349     require(publicSale, "Not open to public yet!");
1350     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1351 
1352     if (ownerMintedCount < freeMaxMintAmount) {  
1353             require(ownerMintedCount + _mintAmount <= freeMaxMintAmount, "Exceeded Free Mint Limit");
1354         } else if (ownerMintedCount >= freeMaxMintAmount) { 
1355             require(ownerMintedCount + _mintAmount <= totalMaxMintAmount, "Exceeded Mint Limit");
1356         }
1357 
1358     _safeMint(_msgSender(), _mintAmount);
1359     for (uint256 i = 1; i <=_mintAmount; i++){
1360         addressMintedBalance[msg.sender]++;
1361     }
1362   }
1363 
1364   function ownerMint(uint256 _mintAmount) public payable onlyOwner {
1365      require(_mintAmount > 0, 'Invalid mint amount!');
1366      require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1367     _safeMint(_msgSender(), _mintAmount);
1368   }
1369 
1370 function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1371     _safeMint(_receiver, _mintAmount);
1372   }
1373   
1374   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1375     uint256 ownerTokenCount = balanceOf(_owner);
1376     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1377     uint256 currentTokenId = _startTokenId();
1378     uint256 ownedTokenIndex = 0;
1379     address latestOwnerAddress;
1380 
1381     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1382       TokenOwnership memory ownership = _ownerships[currentTokenId];
1383 
1384       if (!ownership.burned && ownership.addr != address(0)) {
1385         latestOwnerAddress = ownership.addr;
1386       }
1387 
1388       if (latestOwnerAddress == _owner) {
1389         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1390 
1391         ownedTokenIndex++;
1392       }
1393 
1394       currentTokenId++;
1395     }
1396 
1397     return ownedTokenIds;
1398   }
1399 
1400   function _startTokenId() internal view virtual override returns (uint256) {
1401     return 1;
1402   }
1403 
1404   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1405     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1406 
1407     if (revealed == false) {
1408       return hiddenMetadataUri;
1409     }
1410 
1411     string memory currentBaseURI = _baseURI();
1412     return bytes(currentBaseURI).length > 0
1413         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1414         : '';
1415   }
1416 
1417   function setRevealed(bool _state) public onlyOwner {
1418     revealed = _state;
1419   }
1420 
1421   function setCost(uint256 _cost) public onlyOwner {
1422     cost = _cost; 
1423   }
1424 
1425    function setFreeMaxMintAmount(uint256 _freeMaxMintAmount) public onlyOwner {
1426     freeMaxMintAmount = _freeMaxMintAmount; 
1427   }
1428 
1429   function setTotalMaxMintAmount(uint _amount) public onlyOwner {
1430       require(_amount <= maxSupply, "Exceed total amount");
1431       totalMaxMintAmount = _amount;
1432   }
1433 
1434   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1435     maxMintAmountPerTx = _maxMintAmountPerTx;
1436   }
1437 
1438   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1439     hiddenMetadataUri = _hiddenMetadataUri;
1440   }
1441 
1442   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1443     uriPrefix = _uriPrefix;
1444   }
1445 
1446   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1447     uriSuffix = _uriSuffix;
1448   }
1449 
1450   function setPaused(bool _state) public onlyOwner {
1451     paused = _state;
1452   }
1453 
1454   function setPublicSale(bool _state) public onlyOwner {
1455     publicSale = _state;
1456   }
1457 
1458   // WITHDRAW
1459     function withdraw() public payable onlyOwner {
1460   
1461     (bool os, ) = payable(owner()).call{value: address(this).balance}(""); 
1462     require(os);
1463    
1464   }
1465 
1466   function _baseURI() internal view virtual override returns (string memory) {
1467     return uriPrefix;
1468   }
1469 }