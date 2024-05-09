1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         //
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // SPDX-License-Identifier: MIT
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
76 
77 pragma solidity ^0.8.1;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      *
100      * [IMPORTANT]
101      * ====
102      * You shouldn't rely on `isContract` to protect against flash loan attacks!
103      *
104      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
105      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
106      * constructor.
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize/address.code.length, which returns 0
111         // for contracts in construction, since the code is only stored at the end
112         // of the constructor execution.
113 
114         return account.code.length > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * [EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      *  //diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * //solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use //solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC165 standard, as defined in the
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * //eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
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
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
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
529 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
538  * @dev See //eips.ethereum.org/EIPS/eip-721
539  */
540 interface IERC721Enumerable is IERC721 {
541     /**
542      * @dev Returns the total amount of tokens stored by the contract.
543      */
544     function totalSupply() external view returns (uint256);
545 
546     /**
547      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
548      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
549      */
550     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
551 
552     /**
553      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
554      * Use along with {totalSupply} to enumerate all tokens.
555      */
556     function tokenByIndex(uint256 index) external view returns (uint256);
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
568  * @dev See //eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Metadata is IERC721 {
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 // File: @openzeppelin/contracts/utils/Context.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Provides information about the current execution context, including the
596  * sender of the transaction and its data. While these are generally available
597  * via msg.sender and msg.data, they should not be accessed in such a direct
598  * manner, since when dealing with meta-transactions the account sending and
599  * paying for execution may not be the actual sender (as far as an application
600  * is concerned).
601  *
602  * This contract is only required for intermediate, library-like contracts.
603  */
604 abstract contract Context {
605     function _msgSender() internal view virtual returns (address) {
606         return msg.sender;
607     }
608 
609     function _msgData() internal view virtual returns (bytes calldata) {
610         return msg.data;
611     }
612 }
613 
614 // File: erc721a/contracts/ERC721A.sol
615 
616 
617 // Creator: Chiru Labs
618 
619 pragma solidity ^0.8.4;
620 
621 error ApprovalCallerNotOwnerNorApproved();
622 error ApprovalQueryForNonexistentToken();
623 error ApproveToCaller();
624 error ApprovalToCurrentOwner();
625 error BalanceQueryForZeroAddress();
626 error MintedQueryForZeroAddress();
627 error BurnedQueryForZeroAddress();
628 error AuxQueryForZeroAddress();
629 error MintToZeroAddress();
630 error MintZeroQuantity();
631 error OwnerIndexOutOfBounds();
632 error OwnerQueryForNonexistentToken();
633 error TokenIndexOutOfBounds();
634 error TransferCallerNotOwnerNorApproved();
635 error TransferFromIncorrectOwner();
636 error TransferToNonERC721ReceiverImplementer();
637 error TransferToZeroAddress();
638 error URIQueryForNonexistentToken();
639 
640 /**
641  * @dev Implementation of //eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata extension. Built to optimize for lower gas during batch mints.
643  *
644  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
645  *
646  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
647  *
648  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
649  */
650 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
651     using Address for address;
652     using Strings for uint256;
653 
654     // Compiler will pack this into a single 256bit word.
655     struct TokenOwnership {
656         // The address of the owner.
657         address addr;
658         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
659         uint64 startTimestamp;
660         // Whether the token has been burned.
661         bool burned;
662     }
663 
664     // Compiler will pack this into a single 256bit word.
665     struct AddressData {
666         // Realistically, 2**64-1 is more than enough.
667         uint64 balance;
668         // Keeps track of mint count with minimal overhead for tokenomics.
669         uint64 numberMinted;
670         // Keeps track of burn count with minimal overhead for tokenomics.
671         uint64 numberBurned;
672         // For miscellaneous variable(s) pertaining to the address
673         // (e.g. number of whitelist mint slots used).
674         // If there are multiple variables, please pack them into a uint64.
675         uint64 aux;
676     }
677 
678     // The tokenId of the next token to be minted.
679     uint256 internal _currentIndex;
680 
681     // The number of tokens burned.
682     uint256 internal _burnCounter;
683 
684     // Token name
685     string private _name;
686 
687     // Token symbol
688     string private _symbol;
689 
690     // Mapping from token ID to ownership details
691     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
692     mapping(uint256 => TokenOwnership) internal _ownerships;
693 
694     // Mapping owner address to address data
695     mapping(address => AddressData) private _addressData;
696 
697     // Mapping from token ID to approved address
698     mapping(uint256 => address) private _tokenApprovals;
699 
700     // Mapping from owner to operator approvals
701     mapping(address => mapping(address => bool)) private _operatorApprovals;
702 
703     constructor(string memory name_, string memory symbol_) {
704         _name = name_;
705         _symbol = symbol_;
706         _currentIndex = _startTokenId();
707     }
708 
709     /**
710      * To change the starting tokenId, please override this function.
711      */
712     function _startTokenId() internal view virtual returns (uint256) {
713         return 1;
714     }
715 
716     /**
717      * @dev See {IERC721Enumerable-totalSupply}.
718      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
719      */
720     function totalSupply() public view returns (uint256) {
721         // Counter underflow is impossible as _burnCounter cannot be incremented
722         // more than _currentIndex - _startTokenId() times
723         unchecked {
724             return _currentIndex - _burnCounter - _startTokenId();
725         }
726     }
727 
728     /**
729      * Returns the total amount of tokens minted in the contract.
730      */
731     function _totalMinted() internal view returns (uint256) {
732         // Counter underflow is impossible as _currentIndex does not decrement,
733         // and it is initialized to _startTokenId()
734         unchecked {
735             return _currentIndex - _startTokenId();
736         }
737     }
738 
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
743         return
744             interfaceId == type(IERC721).interfaceId ||
745             interfaceId == type(IERC721Metadata).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view override returns (uint256) {
753         if (owner == address(0)) revert BalanceQueryForZeroAddress();
754         return uint256(_addressData[owner].balance);
755     }
756 
757     /**
758      * Returns the number of tokens minted by `owner`.
759      */
760     function _numberMinted(address owner) internal view returns (uint256) {
761         if (owner == address(0)) revert MintedQueryForZeroAddress();
762         return uint256(_addressData[owner].numberMinted);
763     }
764 
765     /**
766      * Returns the number of tokens burned by or on behalf of `owner`.
767      */
768     function _numberBurned(address owner) internal view returns (uint256) {
769         if (owner == address(0)) revert BurnedQueryForZeroAddress();
770         return uint256(_addressData[owner].numberBurned);
771     }
772 
773     /**
774      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
775      */
776     function _getAux(address owner) internal view returns (uint64) {
777         if (owner == address(0)) revert AuxQueryForZeroAddress();
778         return _addressData[owner].aux;
779     }
780 
781     /**
782      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
783      * If there are multiple variables, please pack them into a uint64.
784      */
785     function _setAux(address owner, uint64 aux) internal {
786         if (owner == address(0)) revert AuxQueryForZeroAddress();
787         _addressData[owner].aux = aux;
788     }
789 
790     /**
791      * Gas spent here starts off proportional to the maximum mint batch size.
792      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
793      */
794     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
795         uint256 curr = tokenId;
796 
797         unchecked {
798             if (_startTokenId() <= curr && curr < _currentIndex) {
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
825         return ownershipOf(tokenId).addr;
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
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
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
868         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
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
887     function setApprovalForAll(address operator, bool approved) public override {
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
933         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
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
946         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
947             !_ownerships[tokenId].burned;
948     }
949 
950     function _safeMint(address to, uint256 quantity) internal {
951         _safeMint(to, quantity, '');
952     }
953 
954     /**
955      * @dev Safely mints `quantity` tokens and transfers them to `to`.
956      *
957      * Requirements:
958      *
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
960      * - `quantity` must be greater than 0.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeMint(
965         address to,
966         uint256 quantity,
967         bytes memory _data
968     ) internal {
969         _mint(to, quantity, _data, true);
970     }
971 
972     /**
973      * @dev Mints `quantity` tokens and transfers them to `to`.
974      *
975      * Requirements:
976      *
977      * - `to` cannot be the zero address.
978      * - `quantity` must be greater than 0.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(
983         address to,
984         uint256 quantity,
985         bytes memory _data,
986         bool safe
987     ) internal {
988         uint256 startTokenId = _currentIndex;
989         if (to == address(0)) revert MintToZeroAddress();
990         if (quantity == 0) revert MintZeroQuantity();
991 
992         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
993 
994         // Overflows are incredibly unrealistic.
995         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
996         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
997         unchecked {
998             _addressData[to].balance += uint64(quantity);
999             _addressData[to].numberMinted += uint64(quantity);
1000 
1001             _ownerships[startTokenId].addr = to;
1002             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1003 
1004             uint256 updatedIndex = startTokenId;
1005             uint256 end = updatedIndex + quantity;
1006 
1007             if (safe && to.isContract()) {
1008                 do {
1009                     emit Transfer(address(0), to, updatedIndex);
1010                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1011                         revert TransferToNonERC721ReceiverImplementer();
1012                     }
1013                 } while (updatedIndex != end);
1014                 // Reentrancy protection
1015                 if (_currentIndex != startTokenId) revert();
1016             } else {
1017                 do {
1018                     emit Transfer(address(0), to, updatedIndex++);
1019                 } while (updatedIndex != end);
1020             }
1021             _currentIndex = updatedIndex;
1022         }
1023         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1024     }
1025 
1026     /**
1027      * @dev Transfers `tokenId` from `from` to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) private {
1041         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1042 
1043         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1044             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1045             getApproved(tokenId) == _msgSender());
1046 
1047         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1048         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1049         if (to == address(0)) revert TransferToZeroAddress();
1050 
1051         _beforeTokenTransfers(from, to, tokenId, 1);
1052 
1053         // Clear approvals from the previous owner
1054         _approve(address(0), tokenId, prevOwnership.addr);
1055 
1056         // Underflow of the sender's balance is impossible because we check for
1057         // ownership above and the recipient's balance can't realistically overflow.
1058         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1059         unchecked {
1060             _addressData[from].balance -= 1;
1061             _addressData[to].balance += 1;
1062 
1063             _ownerships[tokenId].addr = to;
1064             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1065 
1066             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1067             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1068             uint256 nextTokenId = tokenId + 1;
1069             if (_ownerships[nextTokenId].addr == address(0)) {
1070                 // This will suffice for checking _exists(nextTokenId),
1071                 // as a burned slot cannot contain the zero address.
1072                 if (nextTokenId < _currentIndex) {
1073                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1074                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1075                 }
1076             }
1077         }
1078 
1079         emit Transfer(from, to, tokenId);
1080         _afterTokenTransfers(from, to, tokenId, 1);
1081     }
1082 
1083     /**
1084      * @dev Destroys `tokenId`.
1085      * The approval is cleared when the token is burned.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _burn(uint256 tokenId) internal virtual {
1094         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1095 
1096         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId, prevOwnership.addr);
1100 
1101         // Underflow of the sender's balance is impossible because we check for
1102         // ownership above and the recipient's balance can't realistically overflow.
1103         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1104         unchecked {
1105             _addressData[prevOwnership.addr].balance -= 1;
1106             _addressData[prevOwnership.addr].numberBurned += 1;
1107 
1108             // Keep track of who burned the token, and the timestamp of burning.
1109             _ownerships[tokenId].addr = prevOwnership.addr;
1110             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1111             _ownerships[tokenId].burned = true;
1112 
1113             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1114             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1115             uint256 nextTokenId = tokenId + 1;
1116             if (_ownerships[nextTokenId].addr == address(0)) {
1117                 // This will suffice for checking _exists(nextTokenId),
1118                 // as a burned slot cannot contain the zero address.
1119                 if (nextTokenId < _currentIndex) {
1120                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1121                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1122                 }
1123             }
1124         }
1125 
1126         emit Transfer(prevOwnership.addr, address(0), tokenId);
1127         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1128 
1129         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1130         unchecked {
1131             _burnCounter++;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Approve `to` to operate on `tokenId`
1137      *
1138      * Emits a {Approval} event.
1139      */
1140     function _approve(
1141         address to,
1142         uint256 tokenId,
1143         address owner
1144     ) private {
1145         _tokenApprovals[tokenId] = to;
1146         emit Approval(owner, to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1151      *
1152      * @param from address representing the previous owner of the given token ID
1153      * @param to target address that will receive the tokens
1154      * @param tokenId uint256 ID of the token to be transferred
1155      * @param _data bytes optional data to send along with the call
1156      * @return bool whether the call correctly returned the expected magic value
1157      */
1158     function _checkContractOnERC721Received(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) private returns (bool) {
1164         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1165             return retval == IERC721Receiver(to).onERC721Received.selector;
1166         } catch (bytes memory reason) {
1167             if (reason.length == 0) {
1168                 revert TransferToNonERC721ReceiverImplementer();
1169             } else {
1170                 assembly {
1171                     revert(add(32, reason), mload(reason))
1172                 }
1173             }
1174         }
1175     }
1176 
1177     /**
1178      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1179      * And also called before burning one token.
1180      *
1181      * startTokenId - the first token id to be transferred
1182      * quantity - the amount to be transferred
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, `tokenId` will be burned by `from`.
1190      * - `from` and `to` are never both zero.
1191      */
1192     function _beforeTokenTransfers(
1193         address from,
1194         address to,
1195         uint256 startTokenId,
1196         uint256 quantity
1197     ) internal virtual {}
1198 
1199     /**
1200      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1201      * minting.
1202      * And also called after one token has been burned.
1203      *
1204      * startTokenId - the first token id to be transferred
1205      * quantity - the amount to be transferred
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` has been minted for `to`.
1212      * - When `to` is zero, `tokenId` has been burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _afterTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 }
1222 
1223 // File: @openzeppelin/contracts/access/Ownable.sol
1224 
1225 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 
1230 /**
1231  * @dev Contract module which provides a basic access control mechanism, where
1232  * there is an account (an owner) that can be granted exclusive access to
1233  * specific functions.
1234  *
1235  * By default, the owner account will be the one that deploys the contract. This
1236  * can later be changed with {transferOwnership}.
1237  *
1238  * This module is used through inheritance. It will make available the modifier
1239  * `onlyOwner`, which can be applied to your functions to restrict their use to
1240  * the owner.
1241  */
1242 abstract contract Ownable is Context {
1243     address private _owner;
1244 
1245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1246 
1247     /**
1248      * @dev Initializes the contract setting the deployer as the initial owner.
1249      */
1250     constructor() {
1251         _transferOwnership(_msgSender());
1252     }
1253 
1254     /**
1255      * @dev Returns the address of the current owner.
1256      */
1257     function owner() public view virtual returns (address) {
1258         return _owner;
1259     }
1260 
1261     /**
1262      * @dev Throws if called by any account other than the owner.
1263      */
1264     modifier onlyOwner() {
1265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1266         _;
1267     }
1268 
1269     /**
1270      * @dev Leaves the contract without owner. It will not be possible to call
1271      * `onlyOwner` functions anymore. Can only be called by the current owner.
1272      *
1273      * NOTE: Renouncing ownership will leave the contract without an owner,
1274      * thereby removing any functionality that is only available to the owner.
1275      */
1276     function renounceOwnership() public virtual onlyOwner {
1277         _transferOwnership(address(0));
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Can only be called by the current owner.
1283      */
1284     function transferOwnership(address newOwner) public virtual onlyOwner {
1285         require(newOwner != address(0), "Ownable: new owner is the zero address");
1286         _transferOwnership(newOwner);
1287     }
1288 
1289     /**
1290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1291      * Internal function without access restriction.
1292      */
1293     function _transferOwnership(address newOwner) internal virtual {
1294         address oldOwner = _owner;
1295         _owner = newOwner;
1296         emit OwnershipTransferred(oldOwner, newOwner);
1297     }
1298 }
1299 
1300 // File: contracts/SquareFrens.sol
1301 
1302 
1303 pragma solidity ^0.8.4;
1304 
1305 contract SquareFrens is ERC721A, Ownable {
1306 
1307     uint256 constant public maxSupply = 8888;
1308     uint256 public freeSupply = 0;
1309     uint256 public mintPrice = 0.015 ether;
1310     uint256 constant public maxMint = 20;
1311 
1312     bool public isSaleLive = true;
1313     string public baseURI = "ipfs://QmU4e8w1No317kKEeRj6cVaa7eEQxHzWUXPJEQCtdfRn7Q/hidden.json";
1314 
1315     constructor() ERC721A("SquareFrens", "SF") {}
1316 
1317     function mint(uint256 quantity) external payable {
1318         require(isSaleLive, "Sale is not live");
1319         require(quantity > 0 && quantity <= maxMint, "Invalid quantity");
1320         uint256 supply = totalSupply();
1321         require(supply + quantity <= maxSupply, "Max amount of tokens minted");
1322         require (supply + quantity <= freeSupply || msg.value >= quantity * mintPrice, "Free mint exceeded or not enough eth sent");
1323  
1324         _safeMint(msg.sender, quantity);
1325     }
1326 
1327     function ownerMint(address to, uint256 quantity) external onlyOwner {
1328         require(totalSupply() + quantity <= maxSupply, "Minting exceeds max supply");
1329         require(quantity > 0, "Quantity less than 1");
1330 
1331         _safeMint(to, quantity);
1332     }
1333 
1334     function toggleSaleStatus() external onlyOwner {
1335         isSaleLive = !isSaleLive;
1336     }
1337 
1338     function setMintPrice(uint256 _MintPrice) external onlyOwner {
1339         mintPrice = _MintPrice;
1340     }
1341 
1342     function setFreeSupply(uint256 _freeSupply) external onlyOwner {
1343         freeSupply = _freeSupply;
1344     }
1345 
1346     function withdrawAll() external onlyOwner {
1347         payable(owner()).transfer(address(this).balance);
1348     }
1349 
1350     function setBaseURI(string calldata newURI) external onlyOwner {
1351         baseURI = newURI;
1352     }
1353 
1354     function _baseURI() internal view override returns (string memory) {
1355         return baseURI;
1356     }
1357 }