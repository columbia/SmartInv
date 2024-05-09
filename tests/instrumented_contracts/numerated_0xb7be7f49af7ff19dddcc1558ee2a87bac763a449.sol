1 /**
2 Beneath the moon, a secret tale takes flight,
3 An artist hidden, shrouded by the night.
4 In verses crafted, find the cipher key,
5 Unlock their world, and set the mystery free.
6 
7 To start, two I's will guide you on your quest,
8 Then l's in four, their Twitter tale addressed.
9 Three I's return, and five l's follow near,
10 Combined, they form a handle to revere.
11 
12 In artful whispers, journey to explore,
13 The secrets held, the wisdom to implore.
14 Unearth their tweet, a treasure trove concealed,
15 Embrace the unknown, let the truth be revealed.                                          
16  */
17 // SPDX-License-Identifier: MIT
18 
19 // File: @openzeppelin/contracts/utils/Strings.sol
20 
21 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev String operations.
27  */
28 library Strings {
29     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Context.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/utils/Address.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
119 
120 pragma solidity ^0.8.1;
121 
122 /**
123  * @dev Collection of functions related to the address type
124  */
125 library Address {
126     /**
127      * @dev Returns true if `account` is a contract.
128      *
129      * [IMPORTANT]
130      * ====
131      * It is unsafe to assume that an address for which this function returns
132      * false is an externally-owned account (EOA) and not a contract.
133      *
134      * Among others, `isContract` will return false for the following
135      * types of addresses:
136      *
137      *  - an externally-owned account
138      *  - a contract in construction
139      *  - an address where a contract will be created
140      *  - an address where a contract lived, but was destroyed
141      * ====
142      *
143      * [IMPORTANT]
144      * ====
145      * You shouldn't rely on `isContract` to protect against flash loan attacks!
146      *
147      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
148      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
149      * constructor.
150      * ====
151      */
152     function isContract(address account) internal view returns (bool) {
153         // This method relies on extcodesize/address.code.length, which returns 0
154         // for contracts in construction, since the code is only stored at the end
155         // of the constructor execution.
156 
157         return account.code.length > 0;
158     }
159 
160     /**
161      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
162      * `recipient`, forwarding all available gas and reverting on errors.
163      *
164      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
165      * of certain opcodes, possibly making contracts go over the 2300 gas limit
166      * imposed by `transfer`, making them unable to receive funds via
167      * `transfer`. {sendValue} removes this limitation.
168      *
169      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
170      *
171      * IMPORTANT: because control is transferred to `recipient`, care must be
172      * taken to not create reentrancy vulnerabilities. Consider using
173      * {ReentrancyGuard} or the
174      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
175      */
176     function sendValue(address payable recipient, uint256 amount) internal {
177         require(address(this).balance >= amount, "Address: insufficient balance");
178 
179         (bool success, ) = recipient.call{value: amount}("");
180         require(success, "Address: unable to send value, recipient may have reverted");
181     }
182 
183     /**
184      * @dev Performs a Solidity function call using a low level `call`. A
185      * plain `call` is an unsafe replacement for a function call: use this
186      * function instead.
187      *
188      * If `target` reverts with a revert reason, it is bubbled up by this
189      * function (like regular Solidity function calls).
190      *
191      * Returns the raw returned data. To convert to the expected return value,
192      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
193      *
194      * Requirements:
195      *
196      * - `target` must be a contract.
197      * - calling `target` with `data` must not revert.
198      *
199      * _Available since v3.1._
200      */
201     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
202         return functionCall(target, data, "Address: low-level call failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
207      * `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCall(
212         address target,
213         bytes memory data,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, 0, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but also transferring `value` wei to `target`.
222      *
223      * Requirements:
224      *
225      * - the calling contract must have an ETH balance of at least `value`.
226      * - the called Solidity function must be `payable`.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
240      * with `errorMessage` as a fallback revert reason when `target` reverts.
241      *
242      * _Available since v3.1._
243      */
244     function functionCallWithValue(
245         address target,
246         bytes memory data,
247         uint256 value,
248         string memory errorMessage
249     ) internal returns (bytes memory) {
250         require(address(this).balance >= value, "Address: insufficient balance for call");
251         require(isContract(target), "Address: call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.call{value: value}(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a static call.
260      *
261      * _Available since v3.3._
262      */
263     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
264         return functionStaticCall(target, data, "Address: low-level static call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal view returns (bytes memory) {
278         require(isContract(target), "Address: static call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.staticcall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(isContract(target), "Address: delegate call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.delegatecall(data);
308         return verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     /**
312      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
313      * revert reason using the provided one.
314      *
315      * _Available since v4.3._
316      */
317     function verifyCallResult(
318         bool success,
319         bytes memory returndata,
320         string memory errorMessage
321     ) internal pure returns (bytes memory) {
322         if (success) {
323             return returndata;
324         } else {
325             // Look for revert reason and bubble it up if present
326             if (returndata.length > 0) {
327                 // The easiest way to bubble the revert reason is using memory via assembly
328 
329                 assembly {
330                     let returndata_size := mload(returndata)
331                     revert(add(32, returndata), returndata_size)
332                 }
333             } else {
334                 revert(errorMessage);
335             }
336         }
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @title ERC721 token receiver interface
349  * @dev Interface for any contract that wants to support safeTransfers
350  * from ERC721 asset contracts.
351  */
352 interface IERC721Receiver {
353     /**
354      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
355      * by `operator` from `from`, this function is called.
356      *
357      * It must return its Solidity selector to confirm the token transfer.
358      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
359      *
360      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
361      */
362     function onERC721Received(
363         address operator,
364         address from,
365         uint256 tokenId,
366         bytes calldata data
367     ) external returns (bytes4);
368 }
369 
370 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Interface of the ERC165 standard, as defined in the
379  * https://eips.ethereum.org/EIPS/eip-165[EIP].
380  *
381  * Implementers can declare support of contract interfaces, which can then be
382  * queried by others ({ERC165Checker}).
383  *
384  * For an implementation, see {ERC165}.
385  */
386 interface IERC165 {
387     /**
388      * @dev Returns true if this contract implements the interface defined by
389      * `interfaceId`. See the corresponding
390      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
391      * to learn more about how these ids are created.
392      *
393      * This function call must use less than 30 000 gas.
394      */
395     function supportsInterface(bytes4 interfaceId) external view returns (bool);
396 }
397 
398 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev Implementation of the {IERC165} interface.
408  *
409  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
410  * for the additional interface id that will be supported. For example:
411  *
412  * ```solidity
413  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
414  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
415  * }
416  * ```
417  *
418  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
419  */
420 abstract contract ERC165 is IERC165 {
421     /**
422      * @dev See {IERC165-supportsInterface}.
423      */
424     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
425         return interfaceId == type(IERC165).interfaceId;
426     }
427 }
428 
429 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Required interface of an ERC721 compliant contract.
439  */
440 interface IERC721 is IERC165 {
441     /**
442      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
443      */
444     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
445 
446     /**
447      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
448      */
449     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
453      */
454     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
455 
456     /**
457      * @dev Returns the number of tokens in ``owner``'s account.
458      */
459     function balanceOf(address owner) external view returns (uint256 balance);
460 
461     /**
462      * @dev Returns the owner of the `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function ownerOf(uint256 tokenId) external view returns (address owner);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Returns the account approved for `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function getApproved(uint256 tokenId) external view returns (address operator);
533 
534     /**
535      * @dev Approve or remove `operator` as an operator for the caller.
536      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes calldata data
571     ) external;
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
584  * @dev See https://eips.ethereum.org/EIPS/eip-721
585  */
586 interface IERC721Metadata is IERC721 {
587     /**
588      * @dev Returns the token collection name.
589      */
590     function name() external view returns (string memory);
591 
592     /**
593      * @dev Returns the token collection symbol.
594      */
595     function symbol() external view returns (string memory);
596 
597     /**
598      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
599      */
600     function tokenURI(uint256 tokenId) external view returns (string memory);
601 }
602 
603 // File: contracts/new.sol
604 
605 
606 
607 
608 pragma solidity ^0.8.4;
609 
610 
611 
612 
613 
614 
615 
616 
617 error ApprovalCallerNotOwnerNorApproved();
618 error ApprovalQueryForNonexistentToken();
619 error ApproveToCaller();
620 error ApprovalToCurrentOwner();
621 error BalanceQueryForZeroAddress();
622 error MintToZeroAddress();
623 error MintZeroQuantity();
624 error OwnerQueryForNonexistentToken();
625 error TransferCallerNotOwnerNorApproved();
626 error TransferFromIncorrectOwner();
627 error TransferToNonERC721ReceiverImplementer();
628 error TransferToZeroAddress();
629 error URIQueryForNonexistentToken();
630 
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata extension. Built to optimize for lower gas during batch mints.
634  *
635  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
636  *
637  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
638  *
639  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
640  */
641 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
642     using Address for address;
643     using Strings for uint256;
644 
645     // Compiler will pack this into a single 256bit word.
646     struct TokenOwnership {
647         // The address of the owner.
648         address addr;
649         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
650         uint64 startTimestamp;
651         // Whether the token has been burned.
652         bool burned;
653     }
654 
655     // Compiler will pack this into a single 256bit word.
656     struct AddressData {
657         // Realistically, 2**64-1 is more than enough.
658         uint64 balance;
659         // Keeps track of mint count with minimal overhead for tokenomics.
660         uint64 numberMinted;
661         // Keeps track of burn count with minimal overhead for tokenomics.
662         uint64 numberBurned;
663         // For miscellaneous variable(s) pertaining to the address
664         // (e.g. number of whitelist mint slots used).
665         // If there are multiple variables, please pack them into a uint64.
666         uint64 aux;
667     }
668 
669     // The tokenId of the next token to be minted.
670     uint256 internal _currentIndex;
671 
672     // The number of tokens burned.
673     uint256 internal _burnCounter;
674 
675     // Token name
676     string private _name;
677 
678     // Token symbol
679     string private _symbol;
680 
681     // Mapping from token ID to ownership details
682     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
683     mapping(uint256 => TokenOwnership) internal _ownerships;
684 
685     // Mapping owner address to address data
686     mapping(address => AddressData) private _addressData;
687 
688     // Mapping from token ID to approved address
689     mapping(uint256 => address) private _tokenApprovals;
690 
691     // Mapping from owner to operator approvals
692     mapping(address => mapping(address => bool)) private _operatorApprovals;
693 
694     constructor(string memory name_, string memory symbol_) {
695         _name = name_;
696         _symbol = symbol_;
697         _currentIndex = _startTokenId();
698     }
699 
700     /**
701      * To change the starting tokenId, please override this function.
702      */
703     function _startTokenId() internal view virtual returns (uint256) {
704         return 0;
705     }
706 
707     /**
708      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
709      */
710     function totalSupply() public view returns (uint256) {
711         // Counter underflow is impossible as _burnCounter cannot be incremented
712         // more than _currentIndex - _startTokenId() times
713         unchecked {
714             return _currentIndex - _burnCounter - _startTokenId();
715         }
716     }
717 
718     /**
719      * Returns the total amount of tokens minted in the contract.
720      */
721     function _totalMinted() internal view returns (uint256) {
722         // Counter underflow is impossible as _currentIndex does not decrement,
723         // and it is initialized to _startTokenId()
724         unchecked {
725             return _currentIndex - _startTokenId();
726         }
727     }
728 
729     /**
730      * @dev See {IERC165-supportsInterface}.
731      */
732     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
733         return
734             interfaceId == type(IERC721).interfaceId ||
735             interfaceId == type(IERC721Metadata).interfaceId ||
736             super.supportsInterface(interfaceId);
737     }
738 
739     /**
740      * @dev See {IERC721-balanceOf}.
741      */
742     function balanceOf(address owner) public view override returns (uint256) {
743         if (owner == address(0)) revert BalanceQueryForZeroAddress();
744         return uint256(_addressData[owner].balance);
745     }
746 
747     /**
748      * Returns the number of tokens minted by `owner`.
749      */
750     function _numberMinted(address owner) internal view returns (uint256) {
751         return uint256(_addressData[owner].numberMinted);
752     }
753 
754     /**
755      * Returns the number of tokens burned by or on behalf of `owner`.
756      */
757     function _numberBurned(address owner) internal view returns (uint256) {
758         return uint256(_addressData[owner].numberBurned);
759     }
760 
761     /**
762      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
763      */
764     function _getAux(address owner) internal view returns (uint64) {
765         return _addressData[owner].aux;
766     }
767 
768     /**
769      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
770      * If there are multiple variables, please pack them into a uint64.
771      */
772     function _setAux(address owner, uint64 aux) internal {
773         _addressData[owner].aux = aux;
774     }
775 
776     /**
777      * Gas spent here starts off proportional to the maximum mint batch size.
778      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
779      */
780     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
781         uint256 curr = tokenId;
782 
783         unchecked {
784             if (_startTokenId() <= curr && curr < _currentIndex) {
785                 TokenOwnership memory ownership = _ownerships[curr];
786                 if (!ownership.burned) {
787                     if (ownership.addr != address(0)) {
788                         return ownership;
789                     }
790                     // Invariant:
791                     // There will always be an ownership that has an address and is not burned
792                     // before an ownership that does not have an address and is not burned.
793                     // Hence, curr will not underflow.
794                     while (true) {
795                         curr--;
796                         ownership = _ownerships[curr];
797                         if (ownership.addr != address(0)) {
798                             return ownership;
799                         }
800                     }
801                 }
802             }
803         }
804         revert OwnerQueryForNonexistentToken();
805     }
806 
807     /**
808      * @dev See {IERC721-ownerOf}.
809      */
810     function ownerOf(uint256 tokenId) public view override returns (address) {
811         return _ownershipOf(tokenId).addr;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-name}.
816      */
817     function name() public view virtual override returns (string memory) {
818         return _name;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-symbol}.
823      */
824     function symbol() public view virtual override returns (string memory) {
825         return _symbol;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-tokenURI}.
830      */
831     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
832         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
833 
834         string memory baseURI = _baseURI();
835         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
836     }
837 
838     /**
839      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
840      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
841      * by default, can be overriden in child contracts.
842      */
843     function _baseURI() internal view virtual returns (string memory) {
844         return '';
845     }
846 
847     /**
848      * @dev See {IERC721-approve}.
849      */
850     function approve(address to, uint256 tokenId) public override {
851         address owner = ERC721A.ownerOf(tokenId);
852         if (to == owner) revert ApprovalToCurrentOwner();
853 
854         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
855             revert ApprovalCallerNotOwnerNorApproved();
856         }
857 
858         _approve(to, tokenId, owner);
859     }
860 
861     /**
862      * @dev See {IERC721-getApproved}.
863      */
864     function getApproved(uint256 tokenId) public view override returns (address) {
865         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
866 
867         return _tokenApprovals[tokenId];
868     }
869 
870     /**
871      * @dev See {IERC721-setApprovalForAll}.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         if (operator == _msgSender()) revert ApproveToCaller();
875 
876         _operatorApprovals[_msgSender()][operator] = approved;
877         emit ApprovalForAll(_msgSender(), operator, approved);
878     }
879 
880     /**
881      * @dev See {IERC721-isApprovedForAll}.
882      */
883     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
884         return _operatorApprovals[owner][operator];
885     }
886 
887     /**
888      * @dev See {IERC721-transferFrom}.
889      */
890     function transferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public virtual override {
918         _transfer(from, to, tokenId);
919         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
920             revert TransferToNonERC721ReceiverImplementer();
921         }
922     }
923 
924     /**
925      * @dev Returns whether `tokenId` exists.
926      *
927      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
928      *
929      * Tokens start existing when they are minted (`_mint`),
930      */
931     function _exists(uint256 tokenId) internal view returns (bool) {
932         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
933             !_ownerships[tokenId].burned;
934     }
935 
936     function _safeMint(address to, uint256 quantity) internal {
937         _safeMint(to, quantity, '');
938     }
939 
940     /**
941      * @dev Safely mints `quantity` tokens and transfers them to `to`.
942      *
943      * Requirements:
944      *
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
946      * - `quantity` must be greater than 0.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeMint(
951         address to,
952         uint256 quantity,
953         bytes memory _data
954     ) internal {
955         _mint(to, quantity, _data, true);
956     }
957 
958     /**
959      * @dev Mints `quantity` tokens and transfers them to `to`.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `quantity` must be greater than 0.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(
969         address to,
970         uint256 quantity,
971         bytes memory _data,
972         bool safe
973     ) internal {
974         uint256 startTokenId = _currentIndex;
975         if (to == address(0)) revert MintToZeroAddress();
976         if (quantity == 0) revert MintZeroQuantity();
977 
978         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
979 
980         // Overflows are incredibly unrealistic.
981         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
982         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
983         unchecked {
984             _addressData[to].balance += uint64(quantity);
985             _addressData[to].numberMinted += uint64(quantity);
986 
987             _ownerships[startTokenId].addr = to;
988             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
989 
990             uint256 updatedIndex = startTokenId;
991             uint256 end = updatedIndex + quantity;
992 
993             if (safe && to.isContract()) {
994                 do {
995                     emit Transfer(address(0), to, updatedIndex);
996                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
997                         revert TransferToNonERC721ReceiverImplementer();
998                     }
999                 } while (updatedIndex != end);
1000                 // Reentrancy protection
1001                 if (_currentIndex != startTokenId) revert();
1002             } else {
1003                 do {
1004                     emit Transfer(address(0), to, updatedIndex++);
1005                 } while (updatedIndex != end);
1006             }
1007             _currentIndex = updatedIndex;
1008         }
1009         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1010     }
1011 
1012     /**
1013      * @dev Transfers `tokenId` from `from` to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _transfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) private {
1027         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1028 
1029         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1030 
1031         bool isApprovedOrOwner = (_msgSender() == from ||
1032             isApprovedForAll(from, _msgSender()) ||
1033             getApproved(tokenId) == _msgSender());
1034 
1035         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1036         if (to == address(0)) revert TransferToZeroAddress();
1037 
1038         _beforeTokenTransfers(from, to, tokenId, 1);
1039 
1040         // Clear approvals from the previous owner
1041         _approve(address(0), tokenId, from);
1042 
1043         // Underflow of the sender's balance is impossible because we check for
1044         // ownership above and the recipient's balance can't realistically overflow.
1045         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1046         unchecked {
1047             _addressData[from].balance -= 1;
1048             _addressData[to].balance += 1;
1049 
1050             TokenOwnership storage currSlot = _ownerships[tokenId];
1051             currSlot.addr = to;
1052             currSlot.startTimestamp = uint64(block.timestamp);
1053 
1054             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1055             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1056             uint256 nextTokenId = tokenId + 1;
1057             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1058             if (nextSlot.addr == address(0)) {
1059                 // This will suffice for checking _exists(nextTokenId),
1060                 // as a burned slot cannot contain the zero address.
1061                 if (nextTokenId != _currentIndex) {
1062                     nextSlot.addr = from;
1063                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1064                 }
1065             }
1066         }
1067 
1068         emit Transfer(from, to, tokenId);
1069         _afterTokenTransfers(from, to, tokenId, 1);
1070     }
1071 
1072     /**
1073      * @dev This is equivalent to _burn(tokenId, false)
1074      */
1075     function _burn(uint256 tokenId) internal virtual {
1076         _burn(tokenId, false);
1077     }
1078 
1079     /**
1080      * @dev Destroys `tokenId`.
1081      * The approval is cleared when the token is burned.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1090         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1091 
1092         address from = prevOwnership.addr;
1093 
1094         if (approvalCheck) {
1095             bool isApprovedOrOwner = (_msgSender() == from ||
1096                 isApprovedForAll(from, _msgSender()) ||
1097                 getApproved(tokenId) == _msgSender());
1098 
1099             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1100         }
1101 
1102         _beforeTokenTransfers(from, address(0), tokenId, 1);
1103 
1104         // Clear approvals from the previous owner
1105         _approve(address(0), tokenId, from);
1106 
1107         // Underflow of the sender's balance is impossible because we check for
1108         // ownership above and the recipient's balance can't realistically overflow.
1109         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1110         unchecked {
1111             AddressData storage addressData = _addressData[from];
1112             addressData.balance -= 1;
1113             addressData.numberBurned += 1;
1114 
1115             // Keep track of who burned the token, and the timestamp of burning.
1116             TokenOwnership storage currSlot = _ownerships[tokenId];
1117             currSlot.addr = from;
1118             currSlot.startTimestamp = uint64(block.timestamp);
1119             currSlot.burned = true;
1120 
1121             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1122             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1123             uint256 nextTokenId = tokenId + 1;
1124             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1125             if (nextSlot.addr == address(0)) {
1126                 // This will suffice for checking _exists(nextTokenId),
1127                 // as a burned slot cannot contain the zero address.
1128                 if (nextTokenId != _currentIndex) {
1129                     nextSlot.addr = from;
1130                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1131                 }
1132             }
1133         }
1134 
1135         emit Transfer(from, address(0), tokenId);
1136         _afterTokenTransfers(from, address(0), tokenId, 1);
1137 
1138         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1139         unchecked {
1140             _burnCounter++;
1141         }
1142     }
1143 
1144     /**
1145      * @dev Approve `to` to operate on `tokenId`
1146      *
1147      * Emits a {Approval} event.
1148      */
1149     function _approve(
1150         address to,
1151         uint256 tokenId,
1152         address owner
1153     ) private {
1154         _tokenApprovals[tokenId] = to;
1155         emit Approval(owner, to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1160      *
1161      * @param from address representing the previous owner of the given token ID
1162      * @param to target address that will receive the tokens
1163      * @param tokenId uint256 ID of the token to be transferred
1164      * @param _data bytes optional data to send along with the call
1165      * @return bool whether the call correctly returned the expected magic value
1166      */
1167     function _checkContractOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) private returns (bool) {
1173         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1174             return retval == IERC721Receiver(to).onERC721Received.selector;
1175         } catch (bytes memory reason) {
1176             if (reason.length == 0) {
1177                 revert TransferToNonERC721ReceiverImplementer();
1178             } else {
1179                 assembly {
1180                     revert(add(32, reason), mload(reason))
1181                 }
1182             }
1183         }
1184     }
1185 
1186     /**
1187      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1188      * And also called before burning one token.
1189      *
1190      * startTokenId - the first token id to be transferred
1191      * quantity - the amount to be transferred
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` will be minted for `to`.
1198      * - When `to` is zero, `tokenId` will be burned by `from`.
1199      * - `from` and `to` are never both zero.
1200      */
1201     function _beforeTokenTransfers(
1202         address from,
1203         address to,
1204         uint256 startTokenId,
1205         uint256 quantity
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1210      * minting.
1211      * And also called after one token has been burned.
1212      *
1213      * startTokenId - the first token id to be transferred
1214      * quantity - the amount to be transferred
1215      *
1216      * Calling conditions:
1217      *
1218      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1219      * transferred to `to`.
1220      * - When `from` is zero, `tokenId` has been minted for `to`.
1221      * - When `to` is zero, `tokenId` has been burned by `from`.
1222      * - `from` and `to` are never both zero.
1223      */
1224     function _afterTokenTransfers(
1225         address from,
1226         address to,
1227         uint256 startTokenId,
1228         uint256 quantity
1229     ) internal virtual {}
1230 }
1231 
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
1255         require(owner() == _msgSender() , "Ownable: caller is not the owner");
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
1289 pragma solidity ^0.8.13;
1290 
1291 interface IOperatorFilterRegistry {
1292     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1293     function register(address registrant) external;
1294     function registerAndSubscribe(address registrant, address subscription) external;
1295     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1296     function updateOperator(address registrant, address operator, bool filtered) external;
1297     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1298     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1299     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1300     function subscribe(address registrant, address registrantToSubscribe) external;
1301     function unsubscribe(address registrant, bool copyExistingEntries) external;
1302     function subscriptionOf(address addr) external returns (address registrant);
1303     function subscribers(address registrant) external returns (address[] memory);
1304     function subscriberAt(address registrant, uint256 index) external returns (address);
1305     function copyEntriesOf(address registrant, address registrantToCopy) external;
1306     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1307     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1308     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1309     function filteredOperators(address addr) external returns (address[] memory);
1310     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1311     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1312     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1313     function isRegistered(address addr) external returns (bool);
1314     function codeHashOf(address addr) external returns (bytes32);
1315 }
1316 pragma solidity ^0.8.13;
1317 
1318 
1319 
1320 abstract contract OperatorFilterer {
1321     error OperatorNotAllowed(address operator);
1322 
1323     IOperatorFilterRegistry constant operatorFilterRegistry =
1324         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1325 
1326     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1327         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1328         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1329         // order for the modifier to filter addresses.
1330         if (address(operatorFilterRegistry).code.length > 0) {
1331             if (subscribe) {
1332                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1333             } else {
1334                 if (subscriptionOrRegistrantToCopy != address(0)) {
1335                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1336                 } else {
1337                     operatorFilterRegistry.register(address(this));
1338                 }
1339             }
1340         }
1341     }
1342 
1343     modifier onlyAllowedOperator(address from) virtual {
1344         // Check registry code length to facilitate testing in environments without a deployed registry.
1345         if (address(operatorFilterRegistry).code.length > 0) {
1346             // Allow spending tokens from addresses with balance
1347             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1348             // from an EOA.
1349             if (from == msg.sender) {
1350                 _;
1351                 return;
1352             }
1353             if (
1354                 !(
1355                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1356                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1357                 )
1358             ) {
1359                 revert OperatorNotAllowed(msg.sender);
1360             }
1361         }
1362         _;
1363     }
1364 }
1365 pragma solidity ^0.8.13;
1366 
1367 
1368 
1369 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1370     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1371 
1372     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1373 }
1374     pragma solidity ^0.8.7;
1375     
1376     contract ArtistAnonymous is ERC721A, DefaultOperatorFilterer , Ownable {
1377     using Strings for uint256;
1378 
1379 
1380   string private uriPrefix ;
1381   string private uriSuffix = ".json";
1382   string public hiddenURL;
1383 
1384   
1385   
1386 
1387   uint256 public cost = 0.001 ether;
1388  
1389   
1390 
1391   uint16 public maxSupply = 500;
1392   uint8 public maxMintAmountPerTx = 1;
1393     uint8 public maxFreeMintAmountPerWallet = 0;
1394                                                              
1395  
1396   bool public paused = true;
1397   bool public reveal =false;
1398 
1399    mapping (address => uint8) public NFTPerPublicAddress;
1400 
1401  
1402   
1403   
1404  
1405   
1406 
1407   constructor() ERC721A("Artist Anonymous", "POEM") {
1408   }
1409 
1410 
1411   
1412  
1413   function mintART(uint8 _mintAmount) external payable  {
1414      uint16 totalSupply = uint16(totalSupply());
1415      uint8 nft = NFTPerPublicAddress[msg.sender];
1416     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1417     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1418 
1419     require(!paused, "The contract is paused!");
1420     
1421       if(nft >= maxFreeMintAmountPerWallet)
1422     {
1423     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1424     }
1425     else {
1426          uint8 costAmount = _mintAmount + nft;
1427         if(costAmount > maxFreeMintAmountPerWallet)
1428        {
1429         costAmount = costAmount - maxFreeMintAmountPerWallet;
1430         require(msg.value >= cost * costAmount, "Insufficient funds!");
1431        }
1432        
1433          
1434     }
1435     
1436 
1437 
1438     _safeMint(msg.sender , _mintAmount);
1439 
1440     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1441      
1442      delete totalSupply;
1443      delete _mintAmount;
1444   }
1445   
1446   function ReserveART(uint16 _mintAmount, address _receiver) external onlyOwner {
1447      uint16 totalSupply = uint16(totalSupply());
1448     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1449      _safeMint(_receiver , _mintAmount);
1450      delete _mintAmount;
1451      delete _receiver;
1452      delete totalSupply;
1453   }
1454 
1455   function  AirdropART(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1456      uint16 totalSupply = uint16(totalSupply());
1457      uint totalAmount =   _amountPerAddress * addresses.length;
1458     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1459      for (uint256 i = 0; i < addresses.length; i++) {
1460             _safeMint(addresses[i], _amountPerAddress);
1461         }
1462 
1463      delete _amountPerAddress;
1464      delete totalSupply;
1465   }
1466 
1467  
1468 
1469   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1470       maxSupply = _maxSupply;
1471   }
1472 
1473 
1474 
1475    
1476   function tokenURI(uint256 _tokenId)
1477     public
1478     view
1479     virtual
1480     override
1481     returns (string memory)
1482   {
1483     require(
1484       _exists(_tokenId),
1485       "ERC721Metadata: URI query for nonexistent token"
1486     );
1487     
1488   
1489 if ( reveal == false)
1490 {
1491     return hiddenURL;
1492 }
1493     
1494 
1495     string memory currentBaseURI = _baseURI();
1496     return bytes(currentBaseURI).length > 0
1497         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1498         : "";
1499   }
1500  
1501  
1502 
1503 
1504  function setFreeMaxLimit(uint8 _limit) external onlyOwner{
1505     maxFreeMintAmountPerWallet = _limit;
1506    delete _limit;
1507 
1508 }
1509 
1510     
1511   
1512 
1513   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1514     uriPrefix = _uriPrefix;
1515   }
1516    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1517     hiddenURL = _uriPrefix;
1518   }
1519 
1520 
1521   function togglePaused() external onlyOwner {
1522     paused = !paused;
1523    
1524   }
1525 
1526   function setCost(uint _cost) external onlyOwner{
1527       cost = _cost;
1528 
1529   }
1530 
1531  function setRevealed() external onlyOwner{
1532      reveal = !reveal;
1533  }
1534 
1535   function setMaxMintPerTx(uint8 _maxtx) external onlyOwner{
1536       maxMintAmountPerTx = _maxtx;
1537 
1538   }
1539 
1540  
1541 
1542   function withdraw() external onlyOwner {
1543   uint _balance = address(this).balance;
1544      payable(msg.sender).transfer(_balance ); 
1545        
1546   }
1547 
1548 
1549   function _baseURI() internal view  override returns (string memory) {
1550     return uriPrefix;
1551   }
1552 
1553     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1554         super.transferFrom(from, to, tokenId);
1555     }
1556 
1557     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1558         super.safeTransferFrom(from, to, tokenId);
1559     }
1560 
1561     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1562         public
1563         override
1564         onlyAllowedOperator(from)
1565     {
1566         super.safeTransferFrom(from, to, tokenId, data);
1567     }
1568 }