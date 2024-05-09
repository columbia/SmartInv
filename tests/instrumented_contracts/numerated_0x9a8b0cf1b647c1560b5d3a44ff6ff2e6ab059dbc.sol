1 /**
2         ██████████            
3       ██          ██          
4       ██            ██        
5     ██  ██      ██  ██        
6     ██  ██      ██    ██      
7     ██░░░░      ░░░░  ██      
8       ██            ██        
9         ██████████████        
10     ████    ██      ████      
11   ██      ██        ██  ██    
12 ██    ██          ██      ██  
13 ██      ██████████      ██  ██
14 ██                      ██  ██
15   ██                  ████  ██
16     ██████████████████    ██  
17 
18  */
19 // SPDX-License-Identifier: MIT
20 //Developer Info:
21 
22 
23 
24 // File: @openzeppelin/contracts/utils/Strings.sol
25 
26 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev String operations.
32  */
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 
93 // File: @openzeppelin/contracts/utils/Context.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Address.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
124 
125 pragma solidity ^0.8.1;
126 
127 /**
128  * @dev Collection of functions related to the address type
129  */
130 library Address {
131     /**
132      * @dev Returns true if `account` is a contract.
133      *
134      * [IMPORTANT]
135      * ====
136      * It is unsafe to assume that an address for which this function returns
137      * false is an externally-owned account (EOA) and not a contract.
138      *
139      * Among others, `isContract` will return false for the following
140      * types of addresses:
141      *
142      *  - an externally-owned account
143      *  - a contract in construction
144      *  - an address where a contract will be created
145      *  - an address where a contract lived, but was destroyed
146      * ====
147      *
148      * [IMPORTANT]
149      * ====
150      * You shouldn't rely on `isContract` to protect against flash loan attacks!
151      *
152      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
153      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
154      * constructor.
155      * ====
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize/address.code.length, which returns 0
159         // for contracts in construction, since the code is only stored at the end
160         // of the constructor execution.
161 
162         return account.code.length > 0;
163     }
164 
165     /**
166      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
167      * `recipient`, forwarding all available gas and reverting on errors.
168      *
169      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
170      * of certain opcodes, possibly making contracts go over the 2300 gas limit
171      * imposed by `transfer`, making them unable to receive funds via
172      * `transfer`. {sendValue} removes this limitation.
173      *
174      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
175      *
176      * IMPORTANT: because control is transferred to `recipient`, care must be
177      * taken to not create reentrancy vulnerabilities. Consider using
178      * {ReentrancyGuard} or the
179      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
180      */
181     function sendValue(address payable recipient, uint256 amount) internal {
182         require(address(this).balance >= amount, "Address: insufficient balance");
183 
184         (bool success, ) = recipient.call{value: amount}("");
185         require(success, "Address: unable to send value, recipient may have reverted");
186     }
187 
188     /**
189      * @dev Performs a Solidity function call using a low level `call`. A
190      * plain `call` is an unsafe replacement for a function call: use this
191      * function instead.
192      *
193      * If `target` reverts with a revert reason, it is bubbled up by this
194      * function (like regular Solidity function calls).
195      *
196      * Returns the raw returned data. To convert to the expected return value,
197      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
198      *
199      * Requirements:
200      *
201      * - `target` must be a contract.
202      * - calling `target` with `data` must not revert.
203      *
204      * _Available since v3.1._
205      */
206     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionCall(target, data, "Address: low-level call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
212      * `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, 0, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but also transferring `value` wei to `target`.
227      *
228      * Requirements:
229      *
230      * - the calling contract must have an ETH balance of at least `value`.
231      * - the called Solidity function must be `payable`.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
245      * with `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(address(this).balance >= value, "Address: insufficient balance for call");
256         require(isContract(target), "Address: call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.call{value: value}(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a static call.
265      *
266      * _Available since v3.3._
267      */
268     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
269         return functionStaticCall(target, data, "Address: low-level static call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a static call.
275      *
276      * _Available since v3.3._
277      */
278     function functionStaticCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal view returns (bytes memory) {
283         require(isContract(target), "Address: static call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.staticcall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but performing a delegate call.
292      *
293      * _Available since v3.4._
294      */
295     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
301      * but performing a delegate call.
302      *
303      * _Available since v3.4._
304      */
305     function functionDelegateCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(isContract(target), "Address: delegate call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.delegatecall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
318      * revert reason using the provided one.
319      *
320      * _Available since v4.3._
321      */
322     function verifyCallResult(
323         bool success,
324         bytes memory returndata,
325         string memory errorMessage
326     ) internal pure returns (bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             // Look for revert reason and bubble it up if present
331             if (returndata.length > 0) {
332                 // The easiest way to bubble the revert reason is using memory via assembly
333 
334                 assembly {
335                     let returndata_size := mload(returndata)
336                     revert(add(32, returndata), returndata_size)
337                 }
338             } else {
339                 revert(errorMessage);
340             }
341         }
342     }
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @title ERC721 token receiver interface
354  * @dev Interface for any contract that wants to support safeTransfers
355  * from ERC721 asset contracts.
356  */
357 interface IERC721Receiver {
358     /**
359      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
360      * by `operator` from `from`, this function is called.
361      *
362      * It must return its Solidity selector to confirm the token transfer.
363      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
364      *
365      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
366      */
367     function onERC721Received(
368         address operator,
369         address from,
370         uint256 tokenId,
371         bytes calldata data
372     ) external returns (bytes4);
373 }
374 
375 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Interface of the ERC165 standard, as defined in the
384  * https://eips.ethereum.org/EIPS/eip-165[EIP].
385  *
386  * Implementers can declare support of contract interfaces, which can then be
387  * queried by others ({ERC165Checker}).
388  *
389  * For an implementation, see {ERC165}.
390  */
391 interface IERC165 {
392     /**
393      * @dev Returns true if this contract implements the interface defined by
394      * `interfaceId`. See the corresponding
395      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
396      * to learn more about how these ids are created.
397      *
398      * This function call must use less than 30 000 gas.
399      */
400     function supportsInterface(bytes4 interfaceId) external view returns (bool);
401 }
402 
403 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 /**
412  * @dev Implementation of the {IERC165} interface.
413  *
414  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
415  * for the additional interface id that will be supported. For example:
416  *
417  * ```solidity
418  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
420  * }
421  * ```
422  *
423  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
424  */
425 abstract contract ERC165 is IERC165 {
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430         return interfaceId == type(IERC165).interfaceId;
431     }
432 }
433 
434 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 
442 /**
443  * @dev Required interface of an ERC721 compliant contract.
444  */
445 interface IERC721 is IERC165 {
446     /**
447      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
448      */
449     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
453      */
454     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
458      */
459     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
460 
461     /**
462      * @dev Returns the number of tokens in ``owner``'s account.
463      */
464     function balanceOf(address owner) external view returns (uint256 balance);
465 
466     /**
467      * @dev Returns the owner of the `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function ownerOf(uint256 tokenId) external view returns (address owner);
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
477      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must exist and be owned by `from`.
484      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486      *
487      * Emits a {Transfer} event.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Transfers `tokenId` token from `from` to `to`.
497      *
498      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must be owned by `from`.
505      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
506      *
507      * Emits a {Transfer} event.
508      */
509     function transferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
517      * The approval is cleared when the token is transferred.
518      *
519      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
520      *
521      * Requirements:
522      *
523      * - The caller must own the token or be an approved operator.
524      * - `tokenId` must exist.
525      *
526      * Emits an {Approval} event.
527      */
528     function approve(address to, uint256 tokenId) external;
529 
530     /**
531      * @dev Returns the account approved for `tokenId` token.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function getApproved(uint256 tokenId) external view returns (address operator);
538 
539     /**
540      * @dev Approve or remove `operator` as an operator for the caller.
541      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
542      *
543      * Requirements:
544      *
545      * - The `operator` cannot be the caller.
546      *
547      * Emits an {ApprovalForAll} event.
548      */
549     function setApprovalForAll(address operator, bool _approved) external;
550 
551     /**
552      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
553      *
554      * See {setApprovalForAll}
555      */
556     function isApprovedForAll(address owner, address operator) external view returns (bool);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must exist and be owned by `from`.
566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
568      *
569      * Emits a {Transfer} event.
570      */
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId,
575         bytes calldata data
576     ) external;
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Metadata is IERC721 {
592     /**
593      * @dev Returns the token collection name.
594      */
595     function name() external view returns (string memory);
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() external view returns (string memory);
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) external view returns (string memory);
606 }
607 
608 // File: contracts/new.sol
609 
610 
611 
612 
613 pragma solidity ^0.8.4;
614 
615 
616 
617 
618 
619 
620 
621 
622 error ApprovalCallerNotOwnerNorApproved();
623 error ApprovalQueryForNonexistentToken();
624 error ApproveToCaller();
625 error ApprovalToCurrentOwner();
626 error BalanceQueryForZeroAddress();
627 error MintToZeroAddress();
628 error MintZeroQuantity();
629 error OwnerQueryForNonexistentToken();
630 error TransferCallerNotOwnerNorApproved();
631 error TransferFromIncorrectOwner();
632 error TransferToNonERC721ReceiverImplementer();
633 error TransferToZeroAddress();
634 error URIQueryForNonexistentToken();
635 
636 /**
637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
638  * the Metadata extension. Built to optimize for lower gas during batch mints.
639  *
640  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
641  *
642  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
643  *
644  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
645  */
646 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
647     using Address for address;
648     using Strings for uint256;
649 
650     // Compiler will pack this into a single 256bit word.
651     struct TokenOwnership {
652         // The address of the owner.
653         address addr;
654         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
655         uint64 startTimestamp;
656         // Whether the token has been burned.
657         bool burned;
658     }
659 
660     // Compiler will pack this into a single 256bit word.
661     struct AddressData {
662         // Realistically, 2**64-1 is more than enough.
663         uint64 balance;
664         // Keeps track of mint count with minimal overhead for tokenomics.
665         uint64 numberMinted;
666         // Keeps track of burn count with minimal overhead for tokenomics.
667         uint64 numberBurned;
668         // For miscellaneous variable(s) pertaining to the address
669         // (e.g. number of whitelist mint slots used).
670         // If there are multiple variables, please pack them into a uint64.
671         uint64 aux;
672     }
673 
674     // The tokenId of the next token to be minted.
675     uint256 internal _currentIndex;
676 
677     // The number of tokens burned.
678     uint256 internal _burnCounter;
679 
680     // Token name
681     string private _name;
682 
683     // Token symbol
684     string private _symbol;
685 
686     // Mapping from token ID to ownership details
687     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
688     mapping(uint256 => TokenOwnership) internal _ownerships;
689 
690     // Mapping owner address to address data
691     mapping(address => AddressData) private _addressData;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702         _currentIndex = _startTokenId();
703     }
704 
705     /**
706      * To change the starting tokenId, please override this function.
707      */
708     function _startTokenId() internal view virtual returns (uint256) {
709         return 0;
710     }
711 
712     /**
713      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
714      */
715     function totalSupply() public view returns (uint256) {
716         // Counter underflow is impossible as _burnCounter cannot be incremented
717         // more than _currentIndex - _startTokenId() times
718         unchecked {
719             return _currentIndex - _burnCounter - _startTokenId();
720         }
721     }
722 
723     /**
724      * Returns the total amount of tokens minted in the contract.
725      */
726     function _totalMinted() internal view returns (uint256) {
727         // Counter underflow is impossible as _currentIndex does not decrement,
728         // and it is initialized to _startTokenId()
729         unchecked {
730             return _currentIndex - _startTokenId();
731         }
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             super.supportsInterface(interfaceId);
742     }
743 
744     /**
745      * @dev See {IERC721-balanceOf}.
746      */
747     function balanceOf(address owner) public view override returns (uint256) {
748         if (owner == address(0)) revert BalanceQueryForZeroAddress();
749         return uint256(_addressData[owner].balance);
750     }
751 
752     /**
753      * Returns the number of tokens minted by `owner`.
754      */
755     function _numberMinted(address owner) internal view returns (uint256) {
756         return uint256(_addressData[owner].numberMinted);
757     }
758 
759     /**
760      * Returns the number of tokens burned by or on behalf of `owner`.
761      */
762     function _numberBurned(address owner) internal view returns (uint256) {
763         return uint256(_addressData[owner].numberBurned);
764     }
765 
766     /**
767      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
768      */
769     function _getAux(address owner) internal view returns (uint64) {
770         return _addressData[owner].aux;
771     }
772 
773     /**
774      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
775      * If there are multiple variables, please pack them into a uint64.
776      */
777     function _setAux(address owner, uint64 aux) internal {
778         _addressData[owner].aux = aux;
779     }
780 
781     /**
782      * Gas spent here starts off proportional to the maximum mint batch size.
783      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
784      */
785     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
786         uint256 curr = tokenId;
787 
788         unchecked {
789             if (_startTokenId() <= curr && curr < _currentIndex) {
790                 TokenOwnership memory ownership = _ownerships[curr];
791                 if (!ownership.burned) {
792                     if (ownership.addr != address(0)) {
793                         return ownership;
794                     }
795                     // Invariant:
796                     // There will always be an ownership that has an address and is not burned
797                     // before an ownership that does not have an address and is not burned.
798                     // Hence, curr will not underflow.
799                     while (true) {
800                         curr--;
801                         ownership = _ownerships[curr];
802                         if (ownership.addr != address(0)) {
803                             return ownership;
804                         }
805                     }
806                 }
807             }
808         }
809         revert OwnerQueryForNonexistentToken();
810     }
811 
812     /**
813      * @dev See {IERC721-ownerOf}.
814      */
815     function ownerOf(uint256 tokenId) public view override returns (address) {
816         return _ownershipOf(tokenId).addr;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-name}.
821      */
822     function name() public view virtual override returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-symbol}.
828      */
829     function symbol() public view virtual override returns (string memory) {
830         return _symbol;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-tokenURI}.
835      */
836     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
837         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
838 
839         string memory baseURI = _baseURI();
840         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
841     }
842 
843     /**
844      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
845      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
846      * by default, can be overriden in child contracts.
847      */
848     function _baseURI() internal view virtual returns (string memory) {
849         return '';
850     }
851 
852     /**
853      * @dev See {IERC721-approve}.
854      */
855     function approve(address to, uint256 tokenId) public override {
856         address owner = ERC721A.ownerOf(tokenId);
857         if (to == owner) revert ApprovalToCurrentOwner();
858 
859         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
860             revert ApprovalCallerNotOwnerNorApproved();
861         }
862 
863         _approve(to, tokenId, owner);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId) public view override returns (address) {
870         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
871 
872         return _tokenApprovals[tokenId];
873     }
874 
875     /**
876      * @dev See {IERC721-setApprovalForAll}.
877      */
878     function setApprovalForAll(address operator, bool approved) public virtual override {
879         if (operator == _msgSender()) revert ApproveToCaller();
880 
881         _operatorApprovals[_msgSender()][operator] = approved;
882         emit ApprovalForAll(_msgSender(), operator, approved);
883     }
884 
885     /**
886      * @dev See {IERC721-isApprovedForAll}.
887      */
888     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
889         return _operatorApprovals[owner][operator];
890     }
891 
892     /**
893      * @dev See {IERC721-transferFrom}.
894      */
895     function transferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, '');
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public virtual override {
923         _transfer(from, to, tokenId);
924         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
925             revert TransferToNonERC721ReceiverImplementer();
926         }
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are minted (`_mint`),
935      */
936     function _exists(uint256 tokenId) internal view returns (bool) {
937         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
938             !_ownerships[tokenId].burned;
939     }
940 
941     function _safeMint(address to, uint256 quantity) internal {
942         _safeMint(to, quantity, '');
943     }
944 
945     /**
946      * @dev Safely mints `quantity` tokens and transfers them to `to`.
947      *
948      * Requirements:
949      *
950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
951      * - `quantity` must be greater than 0.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeMint(
956         address to,
957         uint256 quantity,
958         bytes memory _data
959     ) internal {
960         _mint(to, quantity, _data, true);
961     }
962 
963     /**
964      * @dev Mints `quantity` tokens and transfers them to `to`.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - `quantity` must be greater than 0.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _mint(
974         address to,
975         uint256 quantity,
976         bytes memory _data,
977         bool safe
978     ) internal {
979         uint256 startTokenId = _currentIndex;
980         if (to == address(0)) revert MintToZeroAddress();
981         if (quantity == 0) revert MintZeroQuantity();
982 
983         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
984 
985         // Overflows are incredibly unrealistic.
986         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
987         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
988         unchecked {
989             _addressData[to].balance += uint64(quantity);
990             _addressData[to].numberMinted += uint64(quantity);
991 
992             _ownerships[startTokenId].addr = to;
993             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
994 
995             uint256 updatedIndex = startTokenId;
996             uint256 end = updatedIndex + quantity;
997 
998             if (safe && to.isContract()) {
999                 do {
1000                     emit Transfer(address(0), to, updatedIndex);
1001                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1002                         revert TransferToNonERC721ReceiverImplementer();
1003                     }
1004                 } while (updatedIndex != end);
1005                 // Reentrancy protection
1006                 if (_currentIndex != startTokenId) revert();
1007             } else {
1008                 do {
1009                     emit Transfer(address(0), to, updatedIndex++);
1010                 } while (updatedIndex != end);
1011             }
1012             _currentIndex = updatedIndex;
1013         }
1014         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _transfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) private {
1032         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1033 
1034         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1035 
1036         bool isApprovedOrOwner = (_msgSender() == from ||
1037             isApprovedForAll(from, _msgSender()) ||
1038             getApproved(tokenId) == _msgSender());
1039 
1040         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1041         if (to == address(0)) revert TransferToZeroAddress();
1042 
1043         _beforeTokenTransfers(from, to, tokenId, 1);
1044 
1045         // Clear approvals from the previous owner
1046         _approve(address(0), tokenId, from);
1047 
1048         // Underflow of the sender's balance is impossible because we check for
1049         // ownership above and the recipient's balance can't realistically overflow.
1050         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1051         unchecked {
1052             _addressData[from].balance -= 1;
1053             _addressData[to].balance += 1;
1054 
1055             TokenOwnership storage currSlot = _ownerships[tokenId];
1056             currSlot.addr = to;
1057             currSlot.startTimestamp = uint64(block.timestamp);
1058 
1059             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1060             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1061             uint256 nextTokenId = tokenId + 1;
1062             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1063             if (nextSlot.addr == address(0)) {
1064                 // This will suffice for checking _exists(nextTokenId),
1065                 // as a burned slot cannot contain the zero address.
1066                 if (nextTokenId != _currentIndex) {
1067                     nextSlot.addr = from;
1068                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1069                 }
1070             }
1071         }
1072 
1073         emit Transfer(from, to, tokenId);
1074         _afterTokenTransfers(from, to, tokenId, 1);
1075     }
1076 
1077     /**
1078      * @dev This is equivalent to _burn(tokenId, false)
1079      */
1080     function _burn(uint256 tokenId) internal virtual {
1081         _burn(tokenId, false);
1082     }
1083 
1084     /**
1085      * @dev Destroys `tokenId`.
1086      * The approval is cleared when the token is burned.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1095         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1096 
1097         address from = prevOwnership.addr;
1098 
1099         if (approvalCheck) {
1100             bool isApprovedOrOwner = (_msgSender() == from ||
1101                 isApprovedForAll(from, _msgSender()) ||
1102                 getApproved(tokenId) == _msgSender());
1103 
1104             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1105         }
1106 
1107         _beforeTokenTransfers(from, address(0), tokenId, 1);
1108 
1109         // Clear approvals from the previous owner
1110         _approve(address(0), tokenId, from);
1111 
1112         // Underflow of the sender's balance is impossible because we check for
1113         // ownership above and the recipient's balance can't realistically overflow.
1114         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1115         unchecked {
1116             AddressData storage addressData = _addressData[from];
1117             addressData.balance -= 1;
1118             addressData.numberBurned += 1;
1119 
1120             // Keep track of who burned the token, and the timestamp of burning.
1121             TokenOwnership storage currSlot = _ownerships[tokenId];
1122             currSlot.addr = from;
1123             currSlot.startTimestamp = uint64(block.timestamp);
1124             currSlot.burned = true;
1125 
1126             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1127             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1128             uint256 nextTokenId = tokenId + 1;
1129             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1130             if (nextSlot.addr == address(0)) {
1131                 // This will suffice for checking _exists(nextTokenId),
1132                 // as a burned slot cannot contain the zero address.
1133                 if (nextTokenId != _currentIndex) {
1134                     nextSlot.addr = from;
1135                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1136                 }
1137             }
1138         }
1139 
1140         emit Transfer(from, address(0), tokenId);
1141         _afterTokenTransfers(from, address(0), tokenId, 1);
1142 
1143         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1144         unchecked {
1145             _burnCounter++;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Approve `to` to operate on `tokenId`
1151      *
1152      * Emits a {Approval} event.
1153      */
1154     function _approve(
1155         address to,
1156         uint256 tokenId,
1157         address owner
1158     ) private {
1159         _tokenApprovals[tokenId] = to;
1160         emit Approval(owner, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1165      *
1166      * @param from address representing the previous owner of the given token ID
1167      * @param to target address that will receive the tokens
1168      * @param tokenId uint256 ID of the token to be transferred
1169      * @param _data bytes optional data to send along with the call
1170      * @return bool whether the call correctly returned the expected magic value
1171      */
1172     function _checkContractOnERC721Received(
1173         address from,
1174         address to,
1175         uint256 tokenId,
1176         bytes memory _data
1177     ) private returns (bool) {
1178         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1179             return retval == IERC721Receiver(to).onERC721Received.selector;
1180         } catch (bytes memory reason) {
1181             if (reason.length == 0) {
1182                 revert TransferToNonERC721ReceiverImplementer();
1183             } else {
1184                 assembly {
1185                     revert(add(32, reason), mload(reason))
1186                 }
1187             }
1188         }
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1193      * And also called before burning one token.
1194      *
1195      * startTokenId - the first token id to be transferred
1196      * quantity - the amount to be transferred
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, `tokenId` will be burned by `from`.
1204      * - `from` and `to` are never both zero.
1205      */
1206     function _beforeTokenTransfers(
1207         address from,
1208         address to,
1209         uint256 startTokenId,
1210         uint256 quantity
1211     ) internal virtual {}
1212 
1213     /**
1214      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1215      * minting.
1216      * And also called after one token has been burned.
1217      *
1218      * startTokenId - the first token id to be transferred
1219      * quantity - the amount to be transferred
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` has been minted for `to`.
1226      * - When `to` is zero, `tokenId` has been burned by `from`.
1227      * - `from` and `to` are never both zero.
1228      */
1229     function _afterTokenTransfers(
1230         address from,
1231         address to,
1232         uint256 startTokenId,
1233         uint256 quantity
1234     ) internal virtual {}
1235 }
1236 
1237 abstract contract Ownable is Context {
1238     address private _owner;
1239 
1240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1241 
1242     /**
1243      * @dev Initializes the contract setting the deployer as the initial owner.
1244      */
1245     constructor() {
1246         _transferOwnership(_msgSender());
1247     }
1248 
1249     /**
1250      * @dev Returns the address of the current owner.
1251      */
1252     function owner() public view virtual returns (address) {
1253         return _owner;
1254     }
1255 
1256     /**
1257      * @dev Throws if called by any account other than the owner.
1258      */
1259     modifier onlyOwner() {
1260         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1261         _;
1262     }
1263 
1264     /**
1265      * @dev Leaves the contract without owner. It will not be possible to call
1266      * `onlyOwner` functions anymore. Can only be called by the current owner.
1267      *
1268      * NOTE: Renouncing ownership will leave the contract without an owner,
1269      * thereby removing any functionality that is only available to the owner.
1270      */
1271     function renounceOwnership() public virtual onlyOwner {
1272         _transferOwnership(address(0));
1273     }
1274 
1275     /**
1276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1277      * Can only be called by the current owner.
1278      */
1279     function transferOwnership(address newOwner) public virtual onlyOwner {
1280         require(newOwner != address(0), "Ownable: new owner is the zero address");
1281         _transferOwnership(newOwner);
1282     }
1283 
1284     /**
1285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1286      * Internal function without access restriction.
1287      */
1288     function _transferOwnership(address newOwner) internal virtual {
1289         address oldOwner = _owner;
1290         _owner = newOwner;
1291         emit OwnershipTransferred(oldOwner, newOwner);
1292     }
1293 }
1294 pragma solidity ^0.8.13;
1295 
1296 interface IOperatorFilterRegistry {
1297     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1298     function register(address registrant) external;
1299     function registerAndSubscribe(address registrant, address subscription) external;
1300     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1301     function updateOperator(address registrant, address operator, bool filtered) external;
1302     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1303     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1304     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1305     function subscribe(address registrant, address registrantToSubscribe) external;
1306     function unsubscribe(address registrant, bool copyExistingEntries) external;
1307     function subscriptionOf(address addr) external returns (address registrant);
1308     function subscribers(address registrant) external returns (address[] memory);
1309     function subscriberAt(address registrant, uint256 index) external returns (address);
1310     function copyEntriesOf(address registrant, address registrantToCopy) external;
1311     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1312     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1313     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1314     function filteredOperators(address addr) external returns (address[] memory);
1315     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1316     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1317     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1318     function isRegistered(address addr) external returns (bool);
1319     function codeHashOf(address addr) external returns (bytes32);
1320 }
1321 pragma solidity ^0.8.13;
1322 
1323 
1324 
1325 abstract contract OperatorFilterer {
1326     error OperatorNotAllowed(address operator);
1327 
1328     IOperatorFilterRegistry constant operatorFilterRegistry =
1329         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1330 
1331     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1332         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1333         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1334         // order for the modifier to filter addresses.
1335         if (address(operatorFilterRegistry).code.length > 0) {
1336             if (subscribe) {
1337                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1338             } else {
1339                 if (subscriptionOrRegistrantToCopy != address(0)) {
1340                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1341                 } else {
1342                     operatorFilterRegistry.register(address(this));
1343                 }
1344             }
1345         }
1346     }
1347 
1348     modifier onlyAllowedOperator(address from) virtual {
1349         // Check registry code length to facilitate testing in environments without a deployed registry.
1350         if (address(operatorFilterRegistry).code.length > 0) {
1351             // Allow spending tokens from addresses with balance
1352             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1353             // from an EOA.
1354             if (from == msg.sender) {
1355                 _;
1356                 return;
1357             }
1358             if (
1359                 !(
1360                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1361                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1362                 )
1363             ) {
1364                 revert OperatorNotAllowed(msg.sender);
1365             }
1366         }
1367         _;
1368     }
1369 }
1370 pragma solidity ^0.8.13;
1371 
1372 
1373 
1374 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1375     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1376 
1377     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1378 }
1379     pragma solidity ^0.8.7;
1380     
1381     contract sneakysnakes is ERC721A, DefaultOperatorFilterer , Ownable {
1382     using Strings for uint256;
1383 
1384 
1385   string private uriPrefix ;
1386   string private uriSuffix = ".json";
1387   string public hiddenURL;
1388 
1389   
1390   
1391 
1392   uint256 public cost = 0.1 ether;
1393  
1394   
1395 
1396   uint16 public maxSupply = 999;
1397   uint8 public maxMintAmountPerTx = 1;
1398     uint8 public maxFreeMintAmountPerWallet = 1;
1399                                                              
1400  
1401   bool public paused = true;
1402   bool public reveal =false;
1403 
1404    mapping (address => uint8) public NFTPerPublicAddress;
1405 
1406  
1407   
1408   
1409  
1410   
1411 
1412   constructor() ERC721A("sneaky snakes", "snky") {
1413   }
1414 
1415 
1416   
1417  
1418   function mint(uint8 _mintAmount) external payable  {
1419      uint16 totalSupply = uint16(totalSupply());
1420      uint8 nft = NFTPerPublicAddress[msg.sender];
1421     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1422     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1423 
1424     require(!paused, "The contract is paused!");
1425     
1426       if(nft >= maxFreeMintAmountPerWallet)
1427     {
1428     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1429     }
1430     else {
1431          uint8 costAmount = _mintAmount + nft;
1432         if(costAmount > maxFreeMintAmountPerWallet)
1433        {
1434         costAmount = costAmount - maxFreeMintAmountPerWallet;
1435         require(msg.value >= cost * costAmount, "Insufficient funds!");
1436        }
1437        
1438          
1439     }
1440     
1441 
1442 
1443     _safeMint(msg.sender , _mintAmount);
1444 
1445     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1446      
1447      delete totalSupply;
1448      delete _mintAmount;
1449   }
1450   
1451   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1452      uint16 totalSupply = uint16(totalSupply());
1453     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1454      _safeMint(_receiver , _mintAmount);
1455      delete _mintAmount;
1456      delete _receiver;
1457      delete totalSupply;
1458   }
1459 
1460   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1461      uint16 totalSupply = uint16(totalSupply());
1462      uint totalAmount =   _amountPerAddress * addresses.length;
1463     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1464      for (uint256 i = 0; i < addresses.length; i++) {
1465             _safeMint(addresses[i], _amountPerAddress);
1466         }
1467 
1468      delete _amountPerAddress;
1469      delete totalSupply;
1470   }
1471 
1472  
1473 
1474   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1475       maxSupply = _maxSupply;
1476   }
1477 
1478 
1479 
1480    
1481   function tokenURI(uint256 _tokenId)
1482     public
1483     view
1484     virtual
1485     override
1486     returns (string memory)
1487   {
1488     require(
1489       _exists(_tokenId),
1490       "ERC721Metadata: URI query for nonexistent token"
1491     );
1492     
1493   
1494 if ( reveal == false)
1495 {
1496     return hiddenURL;
1497 }
1498     
1499 
1500     string memory currentBaseURI = _baseURI();
1501     return bytes(currentBaseURI).length > 0
1502         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1503         : "";
1504   }
1505  
1506  
1507 
1508 
1509  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1510     maxFreeMintAmountPerWallet = _limit;
1511    delete _limit;
1512 
1513 }
1514 
1515     
1516   
1517 
1518   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1519     uriPrefix = _uriPrefix;
1520   }
1521    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1522     hiddenURL = _uriPrefix;
1523   }
1524 
1525 
1526   function setPaused() external onlyOwner {
1527     paused = !paused;
1528    
1529   }
1530 
1531   function setCost(uint _cost) external onlyOwner{
1532       cost = _cost;
1533 
1534   }
1535 
1536  function setRevealed() external onlyOwner{
1537      reveal = !reveal;
1538  }
1539 
1540   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1541       maxMintAmountPerTx = _maxtx;
1542 
1543   }
1544 
1545  
1546 
1547   function withdraw() external onlyOwner {
1548   uint _balance = address(this).balance;
1549      payable(msg.sender).transfer(_balance ); 
1550        
1551   }
1552 
1553 
1554   function _baseURI() internal view  override returns (string memory) {
1555     return uriPrefix;
1556   }
1557 
1558     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1559         super.transferFrom(from, to, tokenId);
1560     }
1561 
1562     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1563         super.safeTransferFrom(from, to, tokenId);
1564     }
1565 
1566     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1567         public
1568         override
1569         onlyAllowedOperator(from)
1570     {
1571         super.safeTransferFrom(from, to, tokenId, data);
1572     }
1573 }