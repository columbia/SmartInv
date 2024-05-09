1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Implementation of the {IERC165} interface.
32  *
33  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
34  * for the additional interface id that will be supported. For example:
35  *
36  * ```solidity
37  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
38  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
39  * }
40  * ```
41  *
42  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
43  */
44 abstract contract ERC165 is IERC165 {
45     /**
46      * @dev See {IERC165-supportsInterface}.
47      */
48     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
49         return interfaceId == type(IERC165).interfaceId;
50     }
51 }
52 
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 }
118 
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 
143 pragma solidity ^0.8.1;
144 
145 /**
146  * @dev Collection of functions related to the address type
147  */
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      *
166      * [IMPORTANT]
167      * ====
168      * You shouldn't rely on `isContract` to protect against flash loan attacks!
169      *
170      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
171      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
172      * constructor.
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize/address.code.length, which returns 0
177         // for contracts in construction, since the code is only stored at the end
178         // of the constructor execution.
179 
180         return account.code.length > 0;
181     }
182 
183     /**
184      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
185      * `recipient`, forwarding all available gas and reverting on errors.
186      *
187      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
188      * of certain opcodes, possibly making contracts go over the 2300 gas limit
189      * imposed by `transfer`, making them unable to receive funds via
190      * `transfer`. {sendValue} removes this limitation.
191      *
192      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
193      *
194      * IMPORTANT: because control is transferred to `recipient`, care must be
195      * taken to not create reentrancy vulnerabilities. Consider using
196      * {ReentrancyGuard} or the
197      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
198      */
199     function sendValue(address payable recipient, uint256 amount) internal {
200         require(address(this).balance >= amount, "Address: insufficient balance");
201 
202         (bool success, ) = recipient.call{value: amount}("");
203         require(success, "Address: unable to send value, recipient may have reverted");
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain `call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionCall(target, data, "Address: low-level call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
230      * `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
263      * with `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(address(this).balance >= value, "Address: insufficient balance for call");
274         require(isContract(target), "Address: call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.call{value: value}(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
287         return functionStaticCall(target, data, "Address: low-level static call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         require(isContract(target), "Address: static call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.staticcall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(isContract(target), "Address: delegate call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.delegatecall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
336      * revert reason using the provided one.
337      *
338      * _Available since v4.3._
339      */
340     function verifyCallResult(
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal pure returns (bytes memory) {
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @title ERC721 token receiver interface
369  * @dev Interface for any contract that wants to support safeTransfers
370  * from ERC721 asset contracts.
371  */
372 interface IERC721Receiver {
373     /**
374      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
375      * by `operator` from `from`, this function is called.
376      *
377      * It must return its Solidity selector to confirm the token transfer.
378      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
379      *
380      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
381      */
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 
391 
392 pragma solidity ^0.8.0;
393 
394 
395 
396 /**
397  * @dev Required interface of an ERC721 compliant contract.
398  */
399 interface IERC721 is IERC165 {
400     /**
401      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
404 
405     /**
406      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
407      */
408     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
412      */
413     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
414 
415     /**
416      * @dev Returns the number of tokens in ``owner``'s account.
417      */
418     function balanceOf(address owner) external view returns (uint256 balance);
419 
420     /**
421      * @dev Returns the owner of the `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function ownerOf(uint256 tokenId) external view returns (address owner);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
431      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Transfers `tokenId` token from `from` to `to`.
451      *
452      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
471      * The approval is cleared when the token is transferred.
472      *
473      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
474      *
475      * Requirements:
476      *
477      * - The caller must own the token or be an approved operator.
478      * - `tokenId` must exist.
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address to, uint256 tokenId) external;
483 
484     /**
485      * @dev Returns the account approved for `tokenId` token.
486      *
487      * Requirements:
488      *
489      * - `tokenId` must exist.
490      */
491     function getApproved(uint256 tokenId) external view returns (address operator);
492 
493     /**
494      * @dev Approve or remove `operator` as an operator for the caller.
495      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
496      *
497      * Requirements:
498      *
499      * - The `operator` cannot be the caller.
500      *
501      * Emits an {ApprovalForAll} event.
502      */
503     function setApprovalForAll(address operator, bool _approved) external;
504 
505     /**
506      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
507      *
508      * See {setApprovalForAll}
509      */
510     function isApprovedForAll(address owner, address operator) external view returns (bool);
511 
512     /**
513      * @dev Safely transfers `tokenId` token from `from` to `to`.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must exist and be owned by `from`.
520      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
521      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
522      *
523      * Emits a {Transfer} event.
524      */
525     function safeTransferFrom(
526         address from,
527         address to,
528         uint256 tokenId,
529         bytes calldata data
530     ) external;
531 }
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
538  * @dev See https://eips.ethereum.org/EIPS/eip-721
539  */
540 interface IERC721Metadata is IERC721 {
541     /**
542      * @dev Returns the token collection name.
543      */
544     function name() external view returns (string memory);
545 
546     /**
547      * @dev Returns the token collection symbol.
548      */
549     function symbol() external view returns (string memory);
550 
551     /**
552      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
553      */
554     function tokenURI(uint256 tokenId) external view returns (string memory);
555 }
556 
557 
558 
559 
560 pragma solidity ^0.8.4;
561 
562 
563 
564 /**
565  * @dev Interface of an ERC721A compliant contract.
566  */
567 interface IERC721A is IERC721, IERC721Metadata {
568     /**
569      * The caller must own the token or be an approved operator.
570      */
571     error ApprovalCallerNotOwnerNorApproved();
572 
573     /**
574      * The token does not exist.
575      */
576     error ApprovalQueryForNonexistentToken();
577 
578     /**
579      * The caller cannot approve to their own address.
580      */
581     error ApproveToCaller();
582 
583     /**
584      * The caller cannot approve to the current owner.
585      */
586     error ApprovalToCurrentOwner();
587 
588     /**
589      * Cannot query the balance for the zero address.
590      */
591     error BalanceQueryForZeroAddress();
592 
593     /**
594      * Cannot mint to the zero address.
595      */
596     error MintToZeroAddress();
597 
598     /**
599      * The quantity of tokens minted must be more than zero.
600      */
601     error MintZeroQuantity();
602 
603     /**
604      * The token does not exist.
605      */
606     error OwnerQueryForNonexistentToken();
607 
608     /**
609      * The caller must own the token or be an approved operator.
610      */
611     error TransferCallerNotOwnerNorApproved();
612 
613     /**
614      * The token must be owned by `from`.
615      */
616     error TransferFromIncorrectOwner();
617 
618     /**
619      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
620      */
621     error TransferToNonERC721ReceiverImplementer();
622 
623     /**
624      * Cannot transfer to the zero address.
625      */
626     error TransferToZeroAddress();
627 
628     /**
629      * The token does not exist.
630      */
631     error URIQueryForNonexistentToken();
632 
633     // Compiler will pack this into a single 256bit word.
634     struct TokenOwnership {
635         // The address of the owner.
636         address addr;
637         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
638         uint64 startTimestamp;
639         // Whether the token has been burned.
640         bool burned;
641     }
642 
643     // Compiler will pack this into a single 256bit word.
644     struct AddressData {
645         // Realistically, 2**64-1 is more than enough.
646         uint64 balance;
647         // Keeps track of mint count with minimal overhead for tokenomics.
648         uint64 numberMinted;
649         // Keeps track of burn count with minimal overhead for tokenomics.
650         uint64 numberBurned;
651         // For miscellaneous variable(s) pertaining to the address
652         // (e.g. number of whitelist mint slots used).
653         // If there are multiple variables, please pack them into a uint64.
654         uint64 aux;
655     }
656 
657     /**
658      * @dev Returns the total amount of tokens stored by the contract.
659      * 
660      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
661      */
662     function totalSupply() external view returns (uint256);
663 }
664 
665 
666 
667 pragma solidity ^0.8.4;
668 
669 /**
670  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
671  * the Metadata extension. Built to optimize for lower gas during batch mints.
672  *
673  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
674  *
675  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
676  *
677  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
678  */
679 contract ERC721A is Context, ERC165, IERC721A {
680     using Address for address;
681     using Strings for uint256;
682 
683     // The tokenId of the next token to be minted.
684     uint256 internal _currentIndex;
685 
686     // The number of tokens burned.
687     uint256 internal _burnCounter;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to ownership details
696     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
697     mapping(uint256 => TokenOwnership) internal _ownerships;
698 
699     // Mapping owner address to address data
700     mapping(address => AddressData) private _addressData;
701 
702     // Mapping from token ID to approved address
703     mapping(uint256 => address) private _tokenApprovals;
704 
705     // Mapping from owner to operator approvals
706     mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711         _currentIndex = _startTokenId();
712     }
713 
714     /**
715      * To change the starting tokenId, please override this function.
716      */
717     function _startTokenId() internal view virtual returns (uint256) {
718         return 0;
719     }
720 
721     /**
722      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
723      */
724     function totalSupply() public view override returns (uint256) {
725         // Counter underflow is impossible as _burnCounter cannot be incremented
726         // more than _currentIndex - _startTokenId() times
727         unchecked {
728             return _currentIndex - _burnCounter - _startTokenId();
729         }
730     }
731 
732     /**
733      * Returns the total amount of tokens minted in the contract.
734      */
735     function _totalMinted() internal view returns (uint256) {
736         // Counter underflow is impossible as _currentIndex does not decrement,
737         // and it is initialized to _startTokenId()
738         unchecked {
739             return _currentIndex - _startTokenId();
740         }
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748             interfaceId == type(IERC721).interfaceId ||
749             interfaceId == type(IERC721Metadata).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view override returns (uint256) {
757         if (owner == address(0)) revert BalanceQueryForZeroAddress();
758         return uint256(_addressData[owner].balance);
759     }
760 
761     /**
762      * Returns the number of tokens minted by `owner`.
763      */
764     function _numberMinted(address owner) internal view returns (uint256) {
765         return uint256(_addressData[owner].numberMinted);
766     }
767 
768     /**
769      * Returns the number of tokens burned by or on behalf of `owner`.
770      */
771     function _numberBurned(address owner) internal view returns (uint256) {
772         return uint256(_addressData[owner].numberBurned);
773     }
774 
775     /**
776      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
777      */
778     function _getAux(address owner) internal view returns (uint64) {
779         return _addressData[owner].aux;
780     }
781 
782     /**
783      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
784      * If there are multiple variables, please pack them into a uint64.
785      */
786     function _setAux(address owner, uint64 aux) internal {
787         _addressData[owner].aux = aux;
788     }
789 
790     /**
791      * Gas spent here starts off proportional to the maximum mint batch size.
792      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
793      */
794     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
795         uint256 curr = tokenId;
796 
797         unchecked {
798             if (_startTokenId() <= curr) if (curr < _currentIndex) {
799                 TokenOwnership memory ownership = _ownerships[curr];
800                 if (!ownership.burned) {
801                     if (ownership.addr != address(0)) {
802                         return ownership;
803                     }
804                     // Invariant:
805                     // There will always be an ownership that has an address and is not burned
806                     // before an ownership that does not have an address and is not burned.
807                     // Hence, curr will not underflow.
808                     while (true) {
809                         curr--;
810                         ownership = _ownerships[curr];
811                         if (ownership.addr != address(0)) {
812                             return ownership;
813                         }
814                     }
815                 }
816             }
817         }
818         revert OwnerQueryForNonexistentToken();
819     }
820 
821     /**
822      * @dev See {IERC721-ownerOf}.
823      */
824     function ownerOf(uint256 tokenId) public view override returns (address) {
825         return _ownershipOf(tokenId).addr;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return '';
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public override {
865         address owner = ERC721A.ownerOf(tokenId);
866         if (to == owner) revert ApprovalToCurrentOwner();
867 
868         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
869             revert ApprovalCallerNotOwnerNorApproved();
870         }
871 
872         _approve(to, tokenId, owner);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId) public view override returns (address) {
879         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved) public virtual override {
888         if (operator == _msgSender()) revert ApproveToCaller();
889 
890         _operatorApprovals[_msgSender()][operator] = approved;
891         emit ApprovalForAll(_msgSender(), operator, approved);
892     }
893 
894     /**
895      * @dev See {IERC721-isApprovedForAll}.
896      */
897     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
898         return _operatorApprovals[owner][operator];
899     }
900 
901     /**
902      * @dev See {IERC721-transferFrom}.
903      */
904     function transferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         _transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, '');
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         _transfer(from, to, tokenId);
933         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
934             revert TransferToNonERC721ReceiverImplementer();
935         }
936     }
937 
938     /**
939      * @dev Returns whether `tokenId` exists.
940      *
941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
942      *
943      * Tokens start existing when they are minted (`_mint`),
944      */
945     function _exists(uint256 tokenId) internal view returns (bool) {
946         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
947     }
948 
949     /**
950      * @dev Equivalent to `_safeMint(to, quantity, '')`.
951      */
952     function _safeMint(address to, uint256 quantity) internal {
953         _safeMint(to, quantity, '');
954     }
955 
956     /**
957      * @dev Safely mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - If `to` refers to a smart contract, it must implement
962      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
963      * - `quantity` must be greater than 0.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeMint(
968         address to,
969         uint256 quantity,
970         bytes memory _data
971     ) internal {
972         uint256 startTokenId = _currentIndex;
973         if (to == address(0)) revert MintToZeroAddress();
974         if (quantity == 0) revert MintZeroQuantity();
975 
976         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
977 
978         // Overflows are incredibly unrealistic.
979         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
980         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
981         unchecked {
982             _addressData[to].balance += uint64(quantity);
983             _addressData[to].numberMinted += uint64(quantity);
984 
985             _ownerships[startTokenId].addr = to;
986             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
987 
988             uint256 updatedIndex = startTokenId;
989             uint256 end = updatedIndex + quantity;
990 
991             if (to.isContract()) {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex);
994                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
995                         revert TransferToNonERC721ReceiverImplementer();
996                     }
997                 } while (updatedIndex < end);
998                 // Reentrancy protection
999                 if (_currentIndex != startTokenId) revert();
1000             } else {
1001                 do {
1002                     emit Transfer(address(0), to, updatedIndex++);
1003                 } while (updatedIndex < end);
1004             }
1005             _currentIndex = updatedIndex;
1006         }
1007         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1008     }
1009 
1010     /**
1011      * @dev Mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _mint(address to, uint256 quantity) internal {
1021         uint256 startTokenId = _currentIndex;
1022         if (to == address(0)) revert MintToZeroAddress();
1023         if (quantity == 0) revert MintZeroQuantity();
1024 
1025         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1026 
1027         // Overflows are incredibly unrealistic.
1028         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1029         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1030         unchecked {
1031             _addressData[to].balance += uint64(quantity);
1032             _addressData[to].numberMinted += uint64(quantity);
1033 
1034             _ownerships[startTokenId].addr = to;
1035             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1036 
1037             uint256 updatedIndex = startTokenId;
1038             uint256 end = updatedIndex + quantity;
1039 
1040             do {
1041                 emit Transfer(address(0), to, updatedIndex++);
1042             } while (updatedIndex < end);
1043 
1044             _currentIndex = updatedIndex;
1045         }
1046         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1047     }
1048 
1049     /**
1050      * @dev Transfers `tokenId` from `from` to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) private {
1064         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1065 
1066         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1067 
1068         bool isApprovedOrOwner = (_msgSender() == from ||
1069             isApprovedForAll(from, _msgSender()) ||
1070             getApproved(tokenId) == _msgSender());
1071 
1072         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1073         if (to == address(0)) revert TransferToZeroAddress();
1074 
1075         _beforeTokenTransfers(from, to, tokenId, 1);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId, from);
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1083         unchecked {
1084             _addressData[from].balance -= 1;
1085             _addressData[to].balance += 1;
1086 
1087             TokenOwnership storage currSlot = _ownerships[tokenId];
1088             currSlot.addr = to;
1089             currSlot.startTimestamp = uint64(block.timestamp);
1090 
1091             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1092             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1093             uint256 nextTokenId = tokenId + 1;
1094             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1095             if (nextSlot.addr == address(0)) {
1096                 // This will suffice for checking _exists(nextTokenId),
1097                 // as a burned slot cannot contain the zero address.
1098                 if (nextTokenId != _currentIndex) {
1099                     nextSlot.addr = from;
1100                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1101                 }
1102             }
1103         }
1104 
1105         emit Transfer(from, to, tokenId);
1106         _afterTokenTransfers(from, to, tokenId, 1);
1107     }
1108 
1109     /**
1110      * @dev Equivalent to `_burn(tokenId, false)`.
1111      */
1112     function _burn(uint256 tokenId) internal virtual {
1113         _burn(tokenId, false);
1114     }
1115 
1116     /**
1117      * @dev Destroys `tokenId`.
1118      * The approval is cleared when the token is burned.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1127         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1128 
1129         address from = prevOwnership.addr;
1130 
1131         if (approvalCheck) {
1132             bool isApprovedOrOwner = (_msgSender() == from ||
1133                 isApprovedForAll(from, _msgSender()) ||
1134                 getApproved(tokenId) == _msgSender());
1135 
1136             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1137         }
1138 
1139         _beforeTokenTransfers(from, address(0), tokenId, 1);
1140 
1141         // Clear approvals from the previous owner
1142         _approve(address(0), tokenId, from);
1143 
1144         // Underflow of the sender's balance is impossible because we check for
1145         // ownership above and the recipient's balance can't realistically overflow.
1146         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1147         unchecked {
1148             AddressData storage addressData = _addressData[from];
1149             addressData.balance -= 1;
1150             addressData.numberBurned += 1;
1151 
1152             // Keep track of who burned the token, and the timestamp of burning.
1153             TokenOwnership storage currSlot = _ownerships[tokenId];
1154             currSlot.addr = from;
1155             currSlot.startTimestamp = uint64(block.timestamp);
1156             currSlot.burned = true;
1157 
1158             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1159             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1160             uint256 nextTokenId = tokenId + 1;
1161             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1162             if (nextSlot.addr == address(0)) {
1163                 // This will suffice for checking _exists(nextTokenId),
1164                 // as a burned slot cannot contain the zero address.
1165                 if (nextTokenId != _currentIndex) {
1166                     nextSlot.addr = from;
1167                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1168                 }
1169             }
1170         }
1171 
1172         emit Transfer(from, address(0), tokenId);
1173         _afterTokenTransfers(from, address(0), tokenId, 1);
1174 
1175         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1176         unchecked {
1177             _burnCounter++;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Approve `to` to operate on `tokenId`
1183      *
1184      * Emits a {Approval} event.
1185      */
1186     function _approve(
1187         address to,
1188         uint256 tokenId,
1189         address owner
1190     ) private {
1191         _tokenApprovals[tokenId] = to;
1192         emit Approval(owner, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkContractOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1211             return retval == IERC721Receiver(to).onERC721Received.selector;
1212         } catch (bytes memory reason) {
1213             if (reason.length == 0) {
1214                 revert TransferToNonERC721ReceiverImplementer();
1215             } else {
1216                 assembly {
1217                     revert(add(32, reason), mload(reason))
1218                 }
1219             }
1220         }
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1225      * And also called before burning one token.
1226      *
1227      * startTokenId - the first token id to be transferred
1228      * quantity - the amount to be transferred
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      * - When `to` is zero, `tokenId` will be burned by `from`.
1236      * - `from` and `to` are never both zero.
1237      */
1238     function _beforeTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1247      * minting.
1248      * And also called after one token has been burned.
1249      *
1250      * startTokenId - the first token id to be transferred
1251      * quantity - the amount to be transferred
1252      *
1253      * Calling conditions:
1254      *
1255      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1256      * transferred to `to`.
1257      * - When `from` is zero, `tokenId` has been minted for `to`.
1258      * - When `to` is zero, `tokenId` has been burned by `from`.
1259      * - `from` and `to` are never both zero.
1260      */
1261     function _afterTokenTransfers(
1262         address from,
1263         address to,
1264         uint256 startTokenId,
1265         uint256 quantity
1266     ) internal virtual {}
1267 }
1268 
1269 
1270 pragma solidity ^0.8.4;
1271 
1272 
1273 /**
1274  * @dev Interface of an ERC721AQueryable compliant contract.
1275  */
1276 interface IERC721AQueryable is IERC721A {
1277     /**
1278      * Invalid query range (`start` >= `stop`).
1279      */
1280     error InvalidQueryRange();
1281 
1282     /**
1283      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1284      *
1285      * If the `tokenId` is out of bounds:
1286      *   - `addr` = `address(0)`
1287      *   - `startTimestamp` = `0`
1288      *   - `burned` = `false`
1289      *
1290      * If the `tokenId` is burned:
1291      *   - `addr` = `<Address of owner before token was burned>`
1292      *   - `startTimestamp` = `<Timestamp when token was burned>`
1293      *   - `burned = `true`
1294      *
1295      * Otherwise:
1296      *   - `addr` = `<Address of owner>`
1297      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1298      *   - `burned = `false`
1299      */
1300     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1301 
1302     /**
1303      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1304      * See {ERC721AQueryable-explicitOwnershipOf}
1305      */
1306     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1307 
1308     /**
1309      * @dev Returns an array of token IDs owned by `owner`,
1310      * in the range [`start`, `stop`)
1311      * (i.e. `start <= tokenId < stop`).
1312      *
1313      * This function allows for tokens to be queried if the collection
1314      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1315      *
1316      * Requirements:
1317      *
1318      * - `start` < `stop`
1319      */
1320     function tokensOfOwnerIn(
1321         address owner,
1322         uint256 start,
1323         uint256 stop
1324     ) external view returns (uint256[] memory);
1325 
1326     /**
1327      * @dev Returns an array of token IDs owned by `owner`.
1328      *
1329      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1330      * It is meant to be called off-chain.
1331      *
1332      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1333      * multiple smaller scans if the collection is large enough to cause
1334      * an out-of-gas error (10K pfp collections should be fine).
1335      */
1336     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1337 }
1338 
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 /**
1343  * @dev Contract module that helps prevent reentrant calls to a function.
1344  *
1345  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1346  * available, which can be applied to functions to make sure there are no nested
1347  * (reentrant) calls to them.
1348  *
1349  * Note that because there is a single `nonReentrant` guard, functions marked as
1350  * `nonReentrant` may not call one another. This can be worked around by making
1351  * those functions `private`, and then adding `external` `nonReentrant` entry
1352  * points to them.
1353  *
1354  * TIP: If you would like to learn more about reentrancy and alternative ways
1355  * to protect against it, check out our blog post
1356  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1357  */
1358 abstract contract ReentrancyGuard {
1359     // Booleans are more expensive than uint256 or any type that takes up a full
1360     // word because each write operation emits an extra SLOAD to first read the
1361     // slot's contents, replace the bits taken up by the boolean, and then write
1362     // back. This is the compiler's defense against contract upgrades and
1363     // pointer aliasing, and it cannot be disabled.
1364 
1365     // The values being non-zero value makes deployment a bit more expensive,
1366     // but in exchange the refund on every call to nonReentrant will be lower in
1367     // amount. Since refunds are capped to a percentage of the total
1368     // transaction's gas, it is best to keep them low in cases like this one, to
1369     // increase the likelihood of the full refund coming into effect.
1370     uint256 private constant _NOT_ENTERED = 1;
1371     uint256 private constant _ENTERED = 2;
1372 
1373     uint256 private _status;
1374 
1375     constructor() {
1376         _status = _NOT_ENTERED;
1377     }
1378 
1379     /**
1380      * @dev Prevents a contract from calling itself, directly or indirectly.
1381      * Calling a `nonReentrant` function from another `nonReentrant`
1382      * function is not supported. It is possible to prevent this from happening
1383      * by making the `nonReentrant` function external, and making it call a
1384      * `private` function that does the actual work.
1385      */
1386     modifier nonReentrant() {
1387         // On the first call to nonReentrant, _notEntered will be true
1388         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1389 
1390         // Any calls to nonReentrant after this point will fail
1391         _status = _ENTERED;
1392 
1393         _;
1394 
1395         // By storing the original value once again, a refund is triggered (see
1396         // https://eips.ethereum.org/EIPS/eip-2200)
1397         _status = _NOT_ENTERED;
1398     }
1399 }
1400 
1401 
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @dev These functions deal with verification of Merkle Trees proofs.
1407  *
1408  * The proofs can be generated using the JavaScript library
1409  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1410  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1411  *
1412  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1413  */
1414 library MerkleProof {
1415     /**
1416      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1417      * defined by `root`. For this, a `proof` must be provided, containing
1418      * sibling hashes on the branch from the leaf to the root of the tree. Each
1419      * pair of leaves and each pair of pre-images are assumed to be sorted.
1420      */
1421     function verify(
1422         bytes32[] memory proof,
1423         bytes32 root,
1424         bytes32 leaf
1425     ) internal pure returns (bool) {
1426         return processProof(proof, leaf) == root;
1427     }
1428 
1429     /**
1430      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1431      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1432      * hash matches the root of the tree. When processing the proof, the pairs
1433      * of leafs & pre-images are assumed to be sorted.
1434      *
1435      * _Available since v4.4._
1436      */
1437     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1438         bytes32 computedHash = leaf;
1439         for (uint256 i = 0; i < proof.length; i++) {
1440             bytes32 proofElement = proof[i];
1441             if (computedHash <= proofElement) {
1442                 // Hash(current computed hash + current element of the proof)
1443                 computedHash = _efficientHash(computedHash, proofElement);
1444             } else {
1445                 // Hash(current element of the proof + current computed hash)
1446                 computedHash = _efficientHash(proofElement, computedHash);
1447             }
1448         }
1449         return computedHash;
1450     }
1451 
1452     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1453         assembly {
1454             mstore(0x00, a)
1455             mstore(0x20, b)
1456             value := keccak256(0x00, 0x40)
1457         }
1458     }
1459 }
1460 
1461 
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 
1466 /**
1467  * @dev Contract module which provides a basic access control mechanism, where
1468  * there is an account (an owner) that can be granted exclusive access to
1469  * specific functions.
1470  *
1471  * By default, the owner account will be the one that deploys the contract. This
1472  * can later be changed with {transferOwnership}.
1473  *
1474  * This module is used through inheritance. It will make available the modifier
1475  * `onlyOwner`, which can be applied to your functions to restrict their use to
1476  * the owner.
1477  */
1478 abstract contract Ownable is Context {
1479     address private _owner;
1480 
1481     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1482 
1483     /**
1484      * @dev Initializes the contract setting the deployer as the initial owner.
1485      */
1486     constructor() {
1487         _transferOwnership(_msgSender());
1488     }
1489 
1490     /**
1491      * @dev Returns the address of the current owner.
1492      */
1493     function owner() public view virtual returns (address) {
1494         return _owner;
1495     }
1496 
1497     /**
1498      * @dev Throws if called by any account other than the owner.
1499      */
1500     modifier onlyOwner() {
1501         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1502         _;
1503     }
1504 
1505     /**
1506      * @dev Leaves the contract without owner. It will not be possible to call
1507      * `onlyOwner` functions anymore. Can only be called by the current owner.
1508      *
1509      * NOTE: Renouncing ownership will leave the contract without an owner,
1510      * thereby removing any functionality that is only available to the owner.
1511      */
1512     function renounceOwnership() public virtual onlyOwner {
1513         _transferOwnership(address(0));
1514     }
1515 
1516     /**
1517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1518      * Can only be called by the current owner.
1519      */
1520     function transferOwnership(address newOwner) public virtual onlyOwner {
1521         require(newOwner != address(0), "Ownable: new owner is the zero address");
1522         _transferOwnership(newOwner);
1523     }
1524 
1525     /**
1526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1527      * Internal function without access restriction.
1528      */
1529     function _transferOwnership(address newOwner) internal virtual {
1530         address oldOwner = _owner;
1531         _owner = newOwner;
1532         emit OwnershipTransferred(oldOwner, newOwner);
1533     }
1534 }
1535 
1536 
1537 
1538 pragma solidity ^0.8.4;
1539 
1540 
1541 /**
1542  * @title ERC721A Queryable
1543  * @dev ERC721A subclass with convenience query functions.
1544  */
1545 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1546     /**
1547      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1548      *
1549      * If the `tokenId` is out of bounds:
1550      *   - `addr` = `address(0)`
1551      *   - `startTimestamp` = `0`
1552      *   - `burned` = `false`
1553      *
1554      * If the `tokenId` is burned:
1555      *   - `addr` = `<Address of owner before token was burned>`
1556      *   - `startTimestamp` = `<Timestamp when token was burned>`
1557      *   - `burned = `true`
1558      *
1559      * Otherwise:
1560      *   - `addr` = `<Address of owner>`
1561      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1562      *   - `burned = `false`
1563      */
1564     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1565         TokenOwnership memory ownership;
1566         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1567             return ownership;
1568         }
1569         ownership = _ownerships[tokenId];
1570         if (ownership.burned) {
1571             return ownership;
1572         }
1573         return _ownershipOf(tokenId);
1574     }
1575 
1576     /**
1577      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1578      * See {ERC721AQueryable-explicitOwnershipOf}
1579      */
1580     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1581         unchecked {
1582             uint256 tokenIdsLength = tokenIds.length;
1583             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1584             for (uint256 i; i != tokenIdsLength; ++i) {
1585                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1586             }
1587             return ownerships;
1588         }
1589     }
1590 
1591     /**
1592      * @dev Returns an array of token IDs owned by `owner`,
1593      * in the range [`start`, `stop`)
1594      * (i.e. `start <= tokenId < stop`).
1595      *
1596      * This function allows for tokens to be queried if the collection
1597      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1598      *
1599      * Requirements:
1600      *
1601      * - `start` < `stop`
1602      */
1603     function tokensOfOwnerIn(
1604         address owner,
1605         uint256 start,
1606         uint256 stop
1607     ) external view override returns (uint256[] memory) {
1608         unchecked {
1609             if (start >= stop) revert InvalidQueryRange();
1610             uint256 tokenIdsIdx;
1611             uint256 stopLimit = _currentIndex;
1612             // Set `start = max(start, _startTokenId())`.
1613             if (start < _startTokenId()) {
1614                 start = _startTokenId();
1615             }
1616             // Set `stop = min(stop, _currentIndex)`.
1617             if (stop > stopLimit) {
1618                 stop = stopLimit;
1619             }
1620             uint256 tokenIdsMaxLength = balanceOf(owner);
1621             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1622             // to cater for cases where `balanceOf(owner)` is too big.
1623             if (start < stop) {
1624                 uint256 rangeLength = stop - start;
1625                 if (rangeLength < tokenIdsMaxLength) {
1626                     tokenIdsMaxLength = rangeLength;
1627                 }
1628             } else {
1629                 tokenIdsMaxLength = 0;
1630             }
1631             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1632             if (tokenIdsMaxLength == 0) {
1633                 return tokenIds;
1634             }
1635             // We need to call `explicitOwnershipOf(start)`,
1636             // because the slot at `start` may not be initialized.
1637             TokenOwnership memory ownership = explicitOwnershipOf(start);
1638             address currOwnershipAddr;
1639             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1640             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1641             if (!ownership.burned) {
1642                 currOwnershipAddr = ownership.addr;
1643             }
1644             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1645                 ownership = _ownerships[i];
1646                 if (ownership.burned) {
1647                     continue;
1648                 }
1649                 if (ownership.addr != address(0)) {
1650                     currOwnershipAddr = ownership.addr;
1651                 }
1652                 if (currOwnershipAddr == owner) {
1653                     tokenIds[tokenIdsIdx++] = i;
1654                 }
1655             }
1656             // Downsize the array to fit.
1657             assembly {
1658                 mstore(tokenIds, tokenIdsIdx)
1659             }
1660             return tokenIds;
1661         }
1662     }
1663 
1664     /**
1665      * @dev Returns an array of token IDs owned by `owner`.
1666      *
1667      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1668      * It is meant to be called off-chain.
1669      *
1670      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1671      * multiple smaller scans if the collection is large enough to cause
1672      * an out-of-gas error (10K pfp collections should be fine).
1673      */
1674     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1675         unchecked {
1676             uint256 tokenIdsIdx;
1677             address currOwnershipAddr;
1678             uint256 tokenIdsLength = balanceOf(owner);
1679             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1680             TokenOwnership memory ownership;
1681             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1682                 ownership = _ownerships[i];
1683                 if (ownership.burned) {
1684                     continue;
1685                 }
1686                 if (ownership.addr != address(0)) {
1687                     currOwnershipAddr = ownership.addr;
1688                 }
1689                 if (currOwnershipAddr == owner) {
1690                     tokenIds[tokenIdsIdx++] = i;
1691                 }
1692             }
1693             return tokenIds;
1694         }
1695     }
1696 }
1697 
1698 
1699 pragma solidity >=0.8.9 <0.9.0;
1700 
1701 contract LegendMaster is ERC721AQueryable, Ownable, ReentrancyGuard {
1702 
1703   using Strings for uint256;
1704 
1705   bytes32 public merkleRoot;
1706   mapping(address => bool) public whitelistClaimed;
1707   uint256 public currentWhitelistMintAmount;
1708 
1709   string public uriPrefix = '';
1710   string public uriSuffix = '.json';
1711   string public hiddenMetadataUri;
1712   
1713   uint256 public cost;
1714   uint256 public maxSupply;
1715   uint256 public maxMintAmountPerTx;
1716 
1717   bool public paused = true;
1718   bool public whitelistMintEnabled = false;
1719   bool public revealed = false;
1720 
1721   constructor(
1722     string memory _tokenName,
1723     string memory _tokenSymbol,
1724     uint256 _cost,
1725     uint256 _maxSupply,
1726     uint256 _maxMintAmountPerTx,
1727     string memory _hiddenMetadataUri
1728   ) ERC721A(_tokenName, _tokenSymbol) {
1729     setCost(_cost);
1730     maxSupply = _maxSupply;
1731     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1732     setHiddenMetadataUri(_hiddenMetadataUri);
1733   }
1734 
1735   modifier mintCompliance(uint256 _mintAmount) {
1736     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1737     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1738     _;
1739   }
1740 
1741   modifier mintPriceCompliance(uint256 _mintAmount) {
1742     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1743     _;
1744   }
1745 
1746   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1747     // Verify whitelist requirements
1748     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1749     require(currentWhitelistMintAmount + _mintAmount <= 6000, 'The whitelist mint amount is full!');
1750     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1751     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1752     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1753 
1754     currentWhitelistMintAmount += _mintAmount;
1755     whitelistClaimed[_msgSender()] = true;
1756     _safeMint(_msgSender(), _mintAmount);
1757   }
1758 
1759   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1760     require(!paused, 'The contract is paused!');
1761 
1762     _safeMint(_msgSender(), _mintAmount);
1763   }
1764   
1765   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1766     _safeMint(_receiver, _mintAmount);
1767   }
1768 
1769   function _startTokenId() internal view virtual override returns (uint256) {
1770     return 1;
1771   }
1772 
1773   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1774     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1775 
1776     if (revealed == false) {
1777       return hiddenMetadataUri;
1778     }
1779 
1780     string memory currentBaseURI = _baseURI();
1781     return bytes(currentBaseURI).length > 0
1782         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1783         : '';
1784   }
1785 
1786   function setRevealed(bool _state) public onlyOwner {
1787     revealed = _state;
1788   }
1789 
1790   function setCost(uint256 _cost) public onlyOwner {
1791     cost = _cost;
1792   }
1793 
1794   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1795     maxMintAmountPerTx = _maxMintAmountPerTx;
1796   }
1797 
1798   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1799     hiddenMetadataUri = _hiddenMetadataUri;
1800   }
1801 
1802   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1803     uriPrefix = _uriPrefix;
1804   }
1805 
1806   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1807     uriSuffix = _uriSuffix;
1808   }
1809 
1810   function setPaused(bool _state) public onlyOwner {
1811     paused = _state;
1812   }
1813 
1814   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1815     merkleRoot = _merkleRoot;
1816   }
1817 
1818   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1819     whitelistMintEnabled = _state;
1820   }
1821 
1822   function withdraw() public onlyOwner nonReentrant {
1823     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1824     require(os);
1825   }
1826 
1827   function _baseURI() internal view virtual override returns (string memory) {
1828     return uriPrefix;
1829   }
1830 }