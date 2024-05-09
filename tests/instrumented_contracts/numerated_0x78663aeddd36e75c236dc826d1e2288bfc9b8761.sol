1 /**
2 
3    ___                                              
4   / __|___ _ __  ____ __ _____ ___ _ __  ___ _ _ ___
5  | (_ / -_) '  \(_-< V  V / -_) -_) '_ \/ -_) '_(_-<
6   \___\___|_|_|_/__/\_/\_/\___\___| .__/\___|_| /__/
7                                   |_|               
8                       
9  */
10 // SPDX-License-Identifier: MIT
11 
12 // File: @openzeppelin/contracts/utils/Strings.sol
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/utils/Address.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
112 
113 pragma solidity ^0.8.1;
114 
115 /**
116  * @dev Collection of functions related to the address type
117  */
118 library Address {
119     /**
120      * @dev Returns true if `account` is a contract.
121      *
122      * [IMPORTANT]
123      * ====
124      * It is unsafe to assume that an address for which this function returns
125      * false is an externally-owned account (EOA) and not a contract.
126      *
127      * Among others, `isContract` will return false for the following
128      * types of addresses:
129      *
130      *  - an externally-owned account
131      *  - a contract in construction
132      *  - an address where a contract will be created
133      *  - an address where a contract lived, but was destroyed
134      * ====
135      *
136      * [IMPORTANT]
137      * ====
138      * You shouldn't rely on `isContract` to protect against flash loan attacks!
139      *
140      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
141      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
142      * constructor.
143      * ====
144      */
145     function isContract(address account) internal view returns (bool) {
146         // This method relies on extcodesize/address.code.length, which returns 0
147         // for contracts in construction, since the code is only stored at the end
148         // of the constructor execution.
149 
150         return account.code.length > 0;
151     }
152 
153     /**
154      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155      * `recipient`, forwarding all available gas and reverting on errors.
156      *
157      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158      * of certain opcodes, possibly making contracts go over the 2300 gas limit
159      * imposed by `transfer`, making them unable to receive funds via
160      * `transfer`. {sendValue} removes this limitation.
161      *
162      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163      *
164      * IMPORTANT: because control is transferred to `recipient`, care must be
165      * taken to not create reentrancy vulnerabilities. Consider using
166      * {ReentrancyGuard} or the
167      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168      */
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     /**
177      * @dev Performs a Solidity function call using a low level `call`. A
178      * plain `call` is an unsafe replacement for a function call: use this
179      * function instead.
180      *
181      * If `target` reverts with a revert reason, it is bubbled up by this
182      * function (like regular Solidity function calls).
183      *
184      * Returns the raw returned data. To convert to the expected return value,
185      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
186      *
187      * Requirements:
188      *
189      * - `target` must be a contract.
190      * - calling `target` with `data` must not revert.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionCall(target, data, "Address: low-level call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
200      * `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, 0, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but also transferring `value` wei to `target`.
215      *
216      * Requirements:
217      *
218      * - the calling contract must have an ETH balance of at least `value`.
219      * - the called Solidity function must be `payable`.
220      *
221      * _Available since v3.1._
222      */
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
233      * with `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         require(address(this).balance >= value, "Address: insufficient balance for call");
244         require(isContract(target), "Address: call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.call{value: value}(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
257         return functionStaticCall(target, data, "Address: low-level static call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal view returns (bytes memory) {
271         require(isContract(target), "Address: static call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.staticcall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(isContract(target), "Address: delegate call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.delegatecall(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
306      * revert reason using the provided one.
307      *
308      * _Available since v4.3._
309      */
310     function verifyCallResult(
311         bool success,
312         bytes memory returndata,
313         string memory errorMessage
314     ) internal pure returns (bytes memory) {
315         if (success) {
316             return returndata;
317         } else {
318             // Look for revert reason and bubble it up if present
319             if (returndata.length > 0) {
320                 // The easiest way to bubble the revert reason is using memory via assembly
321 
322                 assembly {
323                     let returndata_size := mload(returndata)
324                     revert(add(32, returndata), returndata_size)
325                 }
326             } else {
327                 revert(errorMessage);
328             }
329         }
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @title ERC721 token receiver interface
342  * @dev Interface for any contract that wants to support safeTransfers
343  * from ERC721 asset contracts.
344  */
345 interface IERC721Receiver {
346     /**
347      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
348      * by `operator` from `from`, this function is called.
349      *
350      * It must return its Solidity selector to confirm the token transfer.
351      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
352      *
353      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
354      */
355     function onERC721Received(
356         address operator,
357         address from,
358         uint256 tokenId,
359         bytes calldata data
360     ) external returns (bytes4);
361 }
362 
363 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Interface of the ERC165 standard, as defined in the
372  * https://eips.ethereum.org/EIPS/eip-165[EIP].
373  *
374  * Implementers can declare support of contract interfaces, which can then be
375  * queried by others ({ERC165Checker}).
376  *
377  * For an implementation, see {ERC165}.
378  */
379 interface IERC165 {
380     /**
381      * @dev Returns true if this contract implements the interface defined by
382      * `interfaceId`. See the corresponding
383      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
384      * to learn more about how these ids are created.
385      *
386      * This function call must use less than 30 000 gas.
387      */
388     function supportsInterface(bytes4 interfaceId) external view returns (bool);
389 }
390 
391 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Implementation of the {IERC165} interface.
401  *
402  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
403  * for the additional interface id that will be supported. For example:
404  *
405  * ```solidity
406  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
407  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
408  * }
409  * ```
410  *
411  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
412  */
413 abstract contract ERC165 is IERC165 {
414     /**
415      * @dev See {IERC165-supportsInterface}.
416      */
417     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
418         return interfaceId == type(IERC165).interfaceId;
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 
430 /**
431  * @dev Required interface of an ERC721 compliant contract.
432  */
433 interface IERC721 is IERC165 {
434     /**
435      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
436      */
437     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
438 
439     /**
440      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
441      */
442     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
443 
444     /**
445      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
446      */
447     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
448 
449     /**
450      * @dev Returns the number of tokens in ``owner``'s account.
451      */
452     function balanceOf(address owner) external view returns (uint256 balance);
453 
454     /**
455      * @dev Returns the owner of the `tokenId` token.
456      *
457      * Requirements:
458      *
459      * - `tokenId` must exist.
460      */
461     function ownerOf(uint256 tokenId) external view returns (address owner);
462 
463     /**
464      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
465      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
466      *
467      * Requirements:
468      *
469      * - `from` cannot be the zero address.
470      * - `to` cannot be the zero address.
471      * - `tokenId` token must exist and be owned by `from`.
472      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
473      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
474      *
475      * Emits a {Transfer} event.
476      */
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Transfers `tokenId` token from `from` to `to`.
485      *
486      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must be owned by `from`.
493      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
494      *
495      * Emits a {Transfer} event.
496      */
497     function transferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
505      * The approval is cleared when the token is transferred.
506      *
507      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
508      *
509      * Requirements:
510      *
511      * - The caller must own the token or be an approved operator.
512      * - `tokenId` must exist.
513      *
514      * Emits an {Approval} event.
515      */
516     function approve(address to, uint256 tokenId) external;
517 
518     /**
519      * @dev Returns the account approved for `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function getApproved(uint256 tokenId) external view returns (address operator);
526 
527     /**
528      * @dev Approve or remove `operator` as an operator for the caller.
529      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
530      *
531      * Requirements:
532      *
533      * - The `operator` cannot be the caller.
534      *
535      * Emits an {ApprovalForAll} event.
536      */
537     function setApprovalForAll(address operator, bool _approved) external;
538 
539     /**
540      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
541      *
542      * See {setApprovalForAll}
543      */
544     function isApprovedForAll(address owner, address operator) external view returns (bool);
545 
546     /**
547      * @dev Safely transfers `tokenId` token from `from` to `to`.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes calldata data
564     ) external;
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
577  * @dev See https://eips.ethereum.org/EIPS/eip-721
578  */
579 interface IERC721Metadata is IERC721 {
580     /**
581      * @dev Returns the token collection name.
582      */
583     function name() external view returns (string memory);
584 
585     /**
586      * @dev Returns the token collection symbol.
587      */
588     function symbol() external view returns (string memory);
589 
590     /**
591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
592      */
593     function tokenURI(uint256 tokenId) external view returns (string memory);
594 }
595 
596 // File: contracts/new.sol
597 
598 
599 
600 
601 pragma solidity ^0.8.4;
602 
603 
604 
605 
606 
607 
608 
609 
610 error ApprovalCallerNotOwnerNorApproved();
611 error ApprovalQueryForNonexistentToken();
612 error ApproveToCaller();
613 error ApprovalToCurrentOwner();
614 error BalanceQueryForZeroAddress();
615 error MintToZeroAddress();
616 error MintZeroQuantity();
617 error OwnerQueryForNonexistentToken();
618 error TransferCallerNotOwnerNorApproved();
619 error TransferFromIncorrectOwner();
620 error TransferToNonERC721ReceiverImplementer();
621 error TransferToZeroAddress();
622 error URIQueryForNonexistentToken();
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension. Built to optimize for lower gas during batch mints.
627  *
628  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
629  *
630  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
631  *
632  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
633  */
634 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
635     using Address for address;
636     using Strings for uint256;
637 
638     // Compiler will pack this into a single 256bit word.
639     struct TokenOwnership {
640         // The address of the owner.
641         address addr;
642         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
643         uint64 startTimestamp;
644         // Whether the token has been burned.
645         bool burned;
646     }
647 
648     // Compiler will pack this into a single 256bit word.
649     struct AddressData {
650         // Realistically, 2**64-1 is more than enough.
651         uint64 balance;
652         // Keeps track of mint count with minimal overhead for tokenomics.
653         uint64 numberMinted;
654         // Keeps track of burn count with minimal overhead for tokenomics.
655         uint64 numberBurned;
656         // For miscellaneous variable(s) pertaining to the address
657         // (e.g. number of whitelist mint slots used).
658         // If there are multiple variables, please pack them into a uint64.
659         uint64 aux;
660     }
661 
662     // The tokenId of the next token to be minted.
663     uint256 internal _currentIndex;
664 
665     // The number of tokens burned.
666     uint256 internal _burnCounter;
667 
668     // Token name
669     string private _name;
670 
671     // Token symbol
672     string private _symbol;
673 
674     // Mapping from token ID to ownership details
675     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
676     mapping(uint256 => TokenOwnership) internal _ownerships;
677 
678     // Mapping owner address to address data
679     mapping(address => AddressData) private _addressData;
680 
681     // Mapping from token ID to approved address
682     mapping(uint256 => address) private _tokenApprovals;
683 
684     // Mapping from owner to operator approvals
685     mapping(address => mapping(address => bool)) private _operatorApprovals;
686 
687     constructor(string memory name_, string memory symbol_) {
688         _name = name_;
689         _symbol = symbol_;
690         _currentIndex = _startTokenId();
691     }
692 
693     /**
694      * To change the starting tokenId, please override this function.
695      */
696     function _startTokenId() internal view virtual returns (uint256) {
697         return 0;
698     }
699 
700     /**
701      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
702      */
703     function totalSupply() public view returns (uint256) {
704         // Counter underflow is impossible as _burnCounter cannot be incremented
705         // more than _currentIndex - _startTokenId() times
706         unchecked {
707             return _currentIndex - _burnCounter - _startTokenId();
708         }
709     }
710 
711     /**
712      * Returns the total amount of tokens minted in the contract.
713      */
714     function _totalMinted() internal view returns (uint256) {
715         // Counter underflow is impossible as _currentIndex does not decrement,
716         // and it is initialized to _startTokenId()
717         unchecked {
718             return _currentIndex - _startTokenId();
719         }
720     }
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
726         return
727             interfaceId == type(IERC721).interfaceId ||
728             interfaceId == type(IERC721Metadata).interfaceId ||
729             super.supportsInterface(interfaceId);
730     }
731 
732     /**
733      * @dev See {IERC721-balanceOf}.
734      */
735     function balanceOf(address owner) public view override returns (uint256) {
736         if (owner == address(0)) revert BalanceQueryForZeroAddress();
737         return uint256(_addressData[owner].balance);
738     }
739 
740     /**
741      * Returns the number of tokens minted by `owner`.
742      */
743     function _numberMinted(address owner) internal view returns (uint256) {
744         return uint256(_addressData[owner].numberMinted);
745     }
746 
747     /**
748      * Returns the number of tokens burned by or on behalf of `owner`.
749      */
750     function _numberBurned(address owner) internal view returns (uint256) {
751         return uint256(_addressData[owner].numberBurned);
752     }
753 
754     /**
755      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
756      */
757     function _getAux(address owner) internal view returns (uint64) {
758         return _addressData[owner].aux;
759     }
760 
761     /**
762      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
763      * If there are multiple variables, please pack them into a uint64.
764      */
765     function _setAux(address owner, uint64 aux) internal {
766         _addressData[owner].aux = aux;
767     }
768 
769     /**
770      * Gas spent here starts off proportional to the maximum mint batch size.
771      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
772      */
773     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
774         uint256 curr = tokenId;
775 
776         unchecked {
777             if (_startTokenId() <= curr && curr < _currentIndex) {
778                 TokenOwnership memory ownership = _ownerships[curr];
779                 if (!ownership.burned) {
780                     if (ownership.addr != address(0)) {
781                         return ownership;
782                     }
783                     // Invariant:
784                     // There will always be an ownership that has an address and is not burned
785                     // before an ownership that does not have an address and is not burned.
786                     // Hence, curr will not underflow.
787                     while (true) {
788                         curr--;
789                         ownership = _ownerships[curr];
790                         if (ownership.addr != address(0)) {
791                             return ownership;
792                         }
793                     }
794                 }
795             }
796         }
797         revert OwnerQueryForNonexistentToken();
798     }
799 
800     /**
801      * @dev See {IERC721-ownerOf}.
802      */
803     function ownerOf(uint256 tokenId) public view override returns (address) {
804         return _ownershipOf(tokenId).addr;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-name}.
809      */
810     function name() public view virtual override returns (string memory) {
811         return _name;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-symbol}.
816      */
817     function symbol() public view virtual override returns (string memory) {
818         return _symbol;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-tokenURI}.
823      */
824     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
825         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
826 
827         string memory baseURI = _baseURI();
828         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
829     }
830 
831     /**
832      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
833      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
834      * by default, can be overriden in child contracts.
835      */
836     function _baseURI() internal view virtual returns (string memory) {
837         return '';
838     }
839 
840     /**
841      * @dev See {IERC721-approve}.
842      */
843     function approve(address to, uint256 tokenId) public override {
844         address owner = ERC721A.ownerOf(tokenId);
845         if (to == owner) revert ApprovalToCurrentOwner();
846 
847         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
848             revert ApprovalCallerNotOwnerNorApproved();
849         }
850 
851         _approve(to, tokenId, owner);
852     }
853 
854     /**
855      * @dev See {IERC721-getApproved}.
856      */
857     function getApproved(uint256 tokenId) public view override returns (address) {
858         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
859 
860         return _tokenApprovals[tokenId];
861     }
862 
863     /**
864      * @dev See {IERC721-setApprovalForAll}.
865      */
866     function setApprovalForAll(address operator, bool approved) public virtual override {
867         if (operator == _msgSender()) revert ApproveToCaller();
868 
869         _operatorApprovals[_msgSender()][operator] = approved;
870         emit ApprovalForAll(_msgSender(), operator, approved);
871     }
872 
873     /**
874      * @dev See {IERC721-isApprovedForAll}.
875      */
876     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
877         return _operatorApprovals[owner][operator];
878     }
879 
880     /**
881      * @dev See {IERC721-transferFrom}.
882      */
883     function transferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) public virtual override {
888         _transfer(from, to, tokenId);
889     }
890 
891     /**
892      * @dev See {IERC721-safeTransferFrom}.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         safeTransferFrom(from, to, tokenId, '');
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) public virtual override {
911         _transfer(from, to, tokenId);
912         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
913             revert TransferToNonERC721ReceiverImplementer();
914         }
915     }
916 
917     /**
918      * @dev Returns whether `tokenId` exists.
919      *
920      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
921      *
922      * Tokens start existing when they are minted (`_mint`),
923      */
924     function _exists(uint256 tokenId) internal view returns (bool) {
925         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
926             !_ownerships[tokenId].burned;
927     }
928 
929     function _safeMint(address to, uint256 quantity) internal {
930         _safeMint(to, quantity, '');
931     }
932 
933     /**
934      * @dev Safely mints `quantity` tokens and transfers them to `to`.
935      *
936      * Requirements:
937      *
938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(
944         address to,
945         uint256 quantity,
946         bytes memory _data
947     ) internal {
948         _mint(to, quantity, _data, true);
949     }
950 
951     /**
952      * @dev Mints `quantity` tokens and transfers them to `to`.
953      *
954      * Requirements:
955      *
956      * - `to` cannot be the zero address.
957      * - `quantity` must be greater than 0.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _mint(
962         address to,
963         uint256 quantity,
964         bytes memory _data,
965         bool safe
966     ) internal {
967         uint256 startTokenId = _currentIndex;
968         if (to == address(0)) revert MintToZeroAddress();
969         if (quantity == 0) revert MintZeroQuantity();
970 
971         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
972 
973         // Overflows are incredibly unrealistic.
974         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
975         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
976         unchecked {
977             _addressData[to].balance += uint64(quantity);
978             _addressData[to].numberMinted += uint64(quantity);
979 
980             _ownerships[startTokenId].addr = to;
981             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
982 
983             uint256 updatedIndex = startTokenId;
984             uint256 end = updatedIndex + quantity;
985 
986             if (safe && to.isContract()) {
987                 do {
988                     emit Transfer(address(0), to, updatedIndex);
989                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
990                         revert TransferToNonERC721ReceiverImplementer();
991                     }
992                 } while (updatedIndex != end);
993                 // Reentrancy protection
994                 if (_currentIndex != startTokenId) revert();
995             } else {
996                 do {
997                     emit Transfer(address(0), to, updatedIndex++);
998                 } while (updatedIndex != end);
999             }
1000             _currentIndex = updatedIndex;
1001         }
1002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1003     }
1004 
1005     /**
1006      * @dev Transfers `tokenId` from `from` to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) private {
1020         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1021 
1022         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1023 
1024         bool isApprovedOrOwner = (_msgSender() == from ||
1025             isApprovedForAll(from, _msgSender()) ||
1026             getApproved(tokenId) == _msgSender());
1027 
1028         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1029         if (to == address(0)) revert TransferToZeroAddress();
1030 
1031         _beforeTokenTransfers(from, to, tokenId, 1);
1032 
1033         // Clear approvals from the previous owner
1034         _approve(address(0), tokenId, from);
1035 
1036         // Underflow of the sender's balance is impossible because we check for
1037         // ownership above and the recipient's balance can't realistically overflow.
1038         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1039         unchecked {
1040             _addressData[from].balance -= 1;
1041             _addressData[to].balance += 1;
1042 
1043             TokenOwnership storage currSlot = _ownerships[tokenId];
1044             currSlot.addr = to;
1045             currSlot.startTimestamp = uint64(block.timestamp);
1046 
1047             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1048             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1049             uint256 nextTokenId = tokenId + 1;
1050             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1051             if (nextSlot.addr == address(0)) {
1052                 // This will suffice for checking _exists(nextTokenId),
1053                 // as a burned slot cannot contain the zero address.
1054                 if (nextTokenId != _currentIndex) {
1055                     nextSlot.addr = from;
1056                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1057                 }
1058             }
1059         }
1060 
1061         emit Transfer(from, to, tokenId);
1062         _afterTokenTransfers(from, to, tokenId, 1);
1063     }
1064 
1065     /**
1066      * @dev This is equivalent to _burn(tokenId, false)
1067      */
1068     function _burn(uint256 tokenId) internal virtual {
1069         _burn(tokenId, false);
1070     }
1071 
1072     /**
1073      * @dev Destroys `tokenId`.
1074      * The approval is cleared when the token is burned.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1083         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1084 
1085         address from = prevOwnership.addr;
1086 
1087         if (approvalCheck) {
1088             bool isApprovedOrOwner = (_msgSender() == from ||
1089                 isApprovedForAll(from, _msgSender()) ||
1090                 getApproved(tokenId) == _msgSender());
1091 
1092             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1093         }
1094 
1095         _beforeTokenTransfers(from, address(0), tokenId, 1);
1096 
1097         // Clear approvals from the previous owner
1098         _approve(address(0), tokenId, from);
1099 
1100         // Underflow of the sender's balance is impossible because we check for
1101         // ownership above and the recipient's balance can't realistically overflow.
1102         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1103         unchecked {
1104             AddressData storage addressData = _addressData[from];
1105             addressData.balance -= 1;
1106             addressData.numberBurned += 1;
1107 
1108             // Keep track of who burned the token, and the timestamp of burning.
1109             TokenOwnership storage currSlot = _ownerships[tokenId];
1110             currSlot.addr = from;
1111             currSlot.startTimestamp = uint64(block.timestamp);
1112             currSlot.burned = true;
1113 
1114             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1115             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1116             uint256 nextTokenId = tokenId + 1;
1117             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1118             if (nextSlot.addr == address(0)) {
1119                 // This will suffice for checking _exists(nextTokenId),
1120                 // as a burned slot cannot contain the zero address.
1121                 if (nextTokenId != _currentIndex) {
1122                     nextSlot.addr = from;
1123                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1124                 }
1125             }
1126         }
1127 
1128         emit Transfer(from, address(0), tokenId);
1129         _afterTokenTransfers(from, address(0), tokenId, 1);
1130 
1131         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1132         unchecked {
1133             _burnCounter++;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Approve `to` to operate on `tokenId`
1139      *
1140      * Emits a {Approval} event.
1141      */
1142     function _approve(
1143         address to,
1144         uint256 tokenId,
1145         address owner
1146     ) private {
1147         _tokenApprovals[tokenId] = to;
1148         emit Approval(owner, to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1153      *
1154      * @param from address representing the previous owner of the given token ID
1155      * @param to target address that will receive the tokens
1156      * @param tokenId uint256 ID of the token to be transferred
1157      * @param _data bytes optional data to send along with the call
1158      * @return bool whether the call correctly returned the expected magic value
1159      */
1160     function _checkContractOnERC721Received(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) private returns (bool) {
1166         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1167             return retval == IERC721Receiver(to).onERC721Received.selector;
1168         } catch (bytes memory reason) {
1169             if (reason.length == 0) {
1170                 revert TransferToNonERC721ReceiverImplementer();
1171             } else {
1172                 assembly {
1173                     revert(add(32, reason), mload(reason))
1174                 }
1175             }
1176         }
1177     }
1178 
1179     /**
1180      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1181      * And also called before burning one token.
1182      *
1183      * startTokenId - the first token id to be transferred
1184      * quantity - the amount to be transferred
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` will be minted for `to`.
1191      * - When `to` is zero, `tokenId` will be burned by `from`.
1192      * - `from` and `to` are never both zero.
1193      */
1194     function _beforeTokenTransfers(
1195         address from,
1196         address to,
1197         uint256 startTokenId,
1198         uint256 quantity
1199     ) internal virtual {}
1200 
1201     /**
1202      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1203      * minting.
1204      * And also called after one token has been burned.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` has been minted for `to`.
1214      * - When `to` is zero, `tokenId` has been burned by `from`.
1215      * - `from` and `to` are never both zero.
1216      */
1217     function _afterTokenTransfers(
1218         address from,
1219         address to,
1220         uint256 startTokenId,
1221         uint256 quantity
1222     ) internal virtual {}
1223 }
1224 
1225 abstract contract Ownable is Context {
1226     address private _owner;
1227 
1228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1229 
1230     /**
1231      * @dev Initializes the contract setting the deployer as the initial owner.
1232      */
1233     constructor() {
1234         _transferOwnership(_msgSender());
1235     }
1236 
1237     /**
1238      * @dev Returns the address of the current owner.
1239      */
1240     function owner() public view virtual returns (address) {
1241         return _owner;
1242     }
1243 
1244     /**
1245      * @dev Throws if called by any account other than the owner.
1246      */
1247     modifier onlyOwner() {
1248         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1249         _;
1250     }
1251 
1252     /**
1253      * @dev Leaves the contract without owner. It will not be possible to call
1254      * `onlyOwner` functions anymore. Can only be called by the current owner.
1255      *
1256      * NOTE: Renouncing ownership will leave the contract without an owner,
1257      * thereby removing any functionality that is only available to the owner.
1258      */
1259     function renounceOwnership() public virtual onlyOwner {
1260         _transferOwnership(address(0));
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Can only be called by the current owner.
1266      */
1267     function transferOwnership(address newOwner) public virtual onlyOwner {
1268         require(newOwner != address(0), "Ownable: new owner is the zero address");
1269         _transferOwnership(newOwner);
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Internal function without access restriction.
1275      */
1276     function _transferOwnership(address newOwner) internal virtual {
1277         address oldOwner = _owner;
1278         _owner = newOwner;
1279         emit OwnershipTransferred(oldOwner, newOwner);
1280     }
1281 }
1282 pragma solidity ^0.8.13;
1283 
1284 interface IOperatorFilterRegistry {
1285     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1286     function register(address registrant) external;
1287     function registerAndSubscribe(address registrant, address subscription) external;
1288     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1289     function updateOperator(address registrant, address operator, bool filtered) external;
1290     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1291     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1292     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1293     function subscribe(address registrant, address registrantToSubscribe) external;
1294     function unsubscribe(address registrant, bool copyExistingEntries) external;
1295     function subscriptionOf(address addr) external returns (address registrant);
1296     function subscribers(address registrant) external returns (address[] memory);
1297     function subscriberAt(address registrant, uint256 index) external returns (address);
1298     function copyEntriesOf(address registrant, address registrantToCopy) external;
1299     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1300     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1301     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1302     function filteredOperators(address addr) external returns (address[] memory);
1303     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1304     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1305     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1306     function isRegistered(address addr) external returns (bool);
1307     function codeHashOf(address addr) external returns (bytes32);
1308 }
1309 pragma solidity ^0.8.13;
1310 
1311 
1312 
1313 abstract contract OperatorFilterer {
1314     error OperatorNotAllowed(address operator);
1315 
1316     IOperatorFilterRegistry constant operatorFilterRegistry =
1317         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1318 
1319     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1320         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1321         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1322         // order for the modifier to filter addresses.
1323         if (address(operatorFilterRegistry).code.length > 0) {
1324             if (subscribe) {
1325                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1326             } else {
1327                 if (subscriptionOrRegistrantToCopy != address(0)) {
1328                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1329                 } else {
1330                     operatorFilterRegistry.register(address(this));
1331                 }
1332             }
1333         }
1334     }
1335 
1336     modifier onlyAllowedOperator(address from) virtual {
1337         // Check registry code length to facilitate testing in environments without a deployed registry.
1338         if (address(operatorFilterRegistry).code.length > 0) {
1339             // Allow spending tokens from addresses with balance
1340             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1341             // from an EOA.
1342             if (from == msg.sender) {
1343                 _;
1344                 return;
1345             }
1346             if (
1347                 !(
1348                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1349                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1350                 )
1351             ) {
1352                 revert OperatorNotAllowed(msg.sender);
1353             }
1354         }
1355         _;
1356     }
1357 }
1358 pragma solidity ^0.8.13;
1359 
1360 
1361 
1362 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1363     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1364 
1365     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1366 }
1367     pragma solidity ^0.8.7;
1368     
1369     contract Gemsweepers is ERC721A, DefaultOperatorFilterer , Ownable {
1370     using Strings for uint256;
1371 
1372 
1373   string private uriPrefix = "ipfs://QmXqnR8QVhB8VjueLnLm8XfHzgiD9yrRcJ6pR5rQ16tEXE";
1374   string private uriSuffix = ".json";
1375   string public hiddenURL;
1376 
1377   
1378   
1379 
1380   uint256 public cost = 0.004 ether;
1381  
1382   
1383 
1384   uint16 public maxSupply = 6969;
1385   uint8 public maxMintAmountPerTx = 21;
1386     uint8 public maxFreeMintAmountPerWallet = 1;
1387                                                              
1388  
1389   bool public paused = true;
1390   bool public reveal = true;
1391 
1392    mapping (address => uint8) public NFTPerPublicAddress;
1393 
1394  
1395   
1396   
1397  
1398   
1399 
1400   constructor() ERC721A("Gemsweepers", "GEM") {
1401   }
1402 
1403 
1404   
1405  
1406   function Mint(uint8 _mintAmount) external payable  {
1407      uint16 totalSupply = uint16(totalSupply());
1408      uint8 nft = NFTPerPublicAddress[msg.sender];
1409     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1410     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1411 
1412     require(!paused, "The contract is paused!");
1413     
1414       if(nft >= maxFreeMintAmountPerWallet)
1415     {
1416     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1417     }
1418     else {
1419          uint8 costAmount = _mintAmount + nft;
1420         if(costAmount > maxFreeMintAmountPerWallet)
1421        {
1422         costAmount = costAmount - maxFreeMintAmountPerWallet;
1423         require(msg.value >= cost * costAmount, "Insufficient funds!");
1424        }
1425        
1426          
1427     }
1428     
1429 
1430 
1431     _safeMint(msg.sender , _mintAmount);
1432 
1433     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1434      
1435      delete totalSupply;
1436      delete _mintAmount;
1437   }
1438   
1439   function ownerMint(uint16 _mintAmount, address _receiver) external onlyOwner {
1440      uint16 totalSupply = uint16(totalSupply());
1441     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1442      _safeMint(_receiver , _mintAmount);
1443      delete _mintAmount;
1444      delete _receiver;
1445      delete totalSupply;
1446   }
1447 
1448   function  airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1449      uint16 totalSupply = uint16(totalSupply());
1450      uint totalAmount =   _amountPerAddress * addresses.length;
1451     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1452      for (uint256 i = 0; i < addresses.length; i++) {
1453             _safeMint(addresses[i], _amountPerAddress);
1454         }
1455 
1456      delete _amountPerAddress;
1457      delete totalSupply;
1458   }
1459 
1460  
1461 
1462   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1463       maxSupply = _maxSupply;
1464   }
1465 
1466 
1467 
1468    
1469   function tokenURI(uint256 _tokenId)
1470     public
1471     view
1472     virtual
1473     override
1474     returns (string memory)
1475   {
1476     require(
1477       _exists(_tokenId),
1478       "ERC721Metadata: URI query for nonexistent token"
1479     );
1480     
1481   
1482 if ( reveal == false)
1483 {
1484     return hiddenURL;
1485 }
1486     
1487 
1488     string memory currentBaseURI = _baseURI();
1489     return bytes(currentBaseURI).length > 0
1490         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1491         : "";
1492   }
1493  
1494  
1495 
1496 
1497  function setFreeMaxLimit(uint8 _limit) external onlyOwner{
1498     maxFreeMintAmountPerWallet = _limit;
1499    delete _limit;
1500 
1501 }
1502 
1503     
1504   
1505 
1506   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1507     uriPrefix = _uriPrefix;
1508   }
1509    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1510     hiddenURL = _uriPrefix;
1511   }
1512 
1513 
1514   function setPaused() external onlyOwner {
1515     paused = !paused;
1516    
1517   }
1518 
1519   function setCost(uint _cost) external onlyOwner{
1520       cost = _cost;
1521 
1522   }
1523 
1524  function setRevealed() external onlyOwner{
1525      reveal = !reveal;
1526  }
1527 
1528   function setMaxMintPerTx(uint8 _maxtx) external onlyOwner{
1529       maxMintAmountPerTx = _maxtx;
1530 
1531   }
1532 
1533  
1534 
1535   function withdraw() external onlyOwner {
1536   uint _balance = address(this).balance;
1537      payable(msg.sender).transfer(_balance ); 
1538        
1539   }
1540 
1541 
1542   function _baseURI() internal view  override returns (string memory) {
1543     return uriPrefix;
1544   }
1545 
1546     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1547         super.transferFrom(from, to, tokenId);
1548     }
1549 
1550     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1551         super.safeTransferFrom(from, to, tokenId);
1552     }
1553 
1554     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1555         public
1556         override
1557         onlyAllowedOperator(from)
1558     {
1559         super.safeTransferFrom(from, to, tokenId, data);
1560     }
1561 }