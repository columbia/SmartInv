1 /**
2                                         ████                                            
3                                       ████████                                          
4                                       ██    ██                                          
5                                       ██    ████                                        
6                                       ██      ████                                      
7                                       ██        ████                                    
8                                       ██          ██                                    
9                                   ██████████      ████                                  
10                                 ██  ██      ██      ██                                  
11                                 ████████    ██      ██                                  
12                                 ██  ██      ██      ██                                  
13                                   ██████████    ██  ██                                  
14                                     ██      ██████  ██                                  
15                                     ████████▒▒▒▒██  ██                                  
16                                       ██▒▒▒▒▒▒██    ██                                  
17                                       ██▒▒████      ██                                  
18                                     ██████          ██                                  
19                         ██████      ██            ████  ██████                          
20                       ██    ████  ████            ██  ████    ██                        
21                       ██      ██  ██            ████  ██      ██                        
22                       ██    ████  ██            ██    ████    ██                        
23                         ██████  ████          ████    ▒▒██████                          
24                             ▒▒  ██          ████▒▒  ▒▒▒▒                                
25                             ▒▒▒▒████    ██████  ▒▒▒▒▒▒                                  
26                           ▒▒▒▒▒▒██████████▒▒▒▒▒▒▒▒▒▒                                    
27                         ██████                ▒▒██████                                  
28                       ██      ██████      ██████      ██                                
29                       ██          ██      ██          ██                                
30                         ▓▓▓▓████▓▓██      ██▓▓▓▓▓▓████ 
31 
32 Twitter: https://twitter.com/BoringApesNFT
33 Website: https://BoringApes.xyz
34 
35 This ones for you
36 
37 
38  */
39 // SPDX-License-Identifier: MIT
40 
41 // File: @openzeppelin/contracts/utils/Strings.sol
42 
43 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev String operations.
49  */
50 library Strings {
51     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
55      */
56     function toString(uint256 value) internal pure returns (string memory) {
57         // Inspired by OraclizeAPI's implementation - MIT licence
58         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
59 
60         if (value == 0) {
61             return "0";
62         }
63         uint256 temp = value;
64         uint256 digits;
65         while (temp != 0) {
66             digits++;
67             temp /= 10;
68         }
69         bytes memory buffer = new bytes(digits);
70         while (value != 0) {
71             digits -= 1;
72             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
73             value /= 10;
74         }
75         return string(buffer);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
80      */
81     function toHexString(uint256 value) internal pure returns (string memory) {
82         if (value == 0) {
83             return "0x00";
84         }
85         uint256 temp = value;
86         uint256 length = 0;
87         while (temp != 0) {
88             length++;
89             temp >>= 8;
90         }
91         return toHexString(value, length);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
96      */
97     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
98         bytes memory buffer = new bytes(2 * length + 2);
99         buffer[0] = "0";
100         buffer[1] = "x";
101         for (uint256 i = 2 * length + 1; i > 1; --i) {
102             buffer[i] = _HEX_SYMBOLS[value & 0xf];
103             value >>= 4;
104         }
105         require(value == 0, "Strings: hex length insufficient");
106         return string(buffer);
107     }
108 }
109 
110 // File: @openzeppelin/contracts/utils/Context.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Address.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
141 
142 pragma solidity ^0.8.1;
143 
144 /**
145  * @dev Collection of functions related to the address type
146  */
147 library Address {
148     /**
149      * @dev Returns true if `account` is a contract.
150      *
151      * [IMPORTANT]
152      * ====
153      * It is unsafe to assume that an address for which this function returns
154      * false is an externally-owned account (EOA) and not a contract.
155      *
156      * Among others, `isContract` will return false for the following
157      * types of addresses:
158      *
159      *  - an externally-owned account
160      *  - a contract in construction
161      *  - an address where a contract will be created
162      *  - an address where a contract lived, but was destroyed
163      * ====
164      *
165      * [IMPORTANT]
166      * ====
167      * You shouldn't rely on `isContract` to protect against flash loan attacks!
168      *
169      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
170      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
171      * constructor.
172      * ====
173      */
174     function isContract(address account) internal view returns (bool) {
175         // This method relies on extcodesize/address.code.length, which returns 0
176         // for contracts in construction, since the code is only stored at the end
177         // of the constructor execution.
178 
179         return account.code.length > 0;
180     }
181 
182     /**
183      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
184      * `recipient`, forwarding all available gas and reverting on errors.
185      *
186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
188      * imposed by `transfer`, making them unable to receive funds via
189      * `transfer`. {sendValue} removes this limitation.
190      *
191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
192      *
193      * IMPORTANT: because control is transferred to `recipient`, care must be
194      * taken to not create reentrancy vulnerabilities. Consider using
195      * {ReentrancyGuard} or the
196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
197      */
198     function sendValue(address payable recipient, uint256 amount) internal {
199         require(address(this).balance >= amount, "Address: insufficient balance");
200 
201         (bool success, ) = recipient.call{value: amount}("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 
205     /**
206      * @dev Performs a Solidity function call using a low level `call`. A
207      * plain `call` is an unsafe replacement for a function call: use this
208      * function instead.
209      *
210      * If `target` reverts with a revert reason, it is bubbled up by this
211      * function (like regular Solidity function calls).
212      *
213      * Returns the raw returned data. To convert to the expected return value,
214      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
215      *
216      * Requirements:
217      *
218      * - `target` must be a contract.
219      * - calling `target` with `data` must not revert.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionCall(target, data, "Address: low-level call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
229      * `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, 0, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but also transferring `value` wei to `target`.
244      *
245      * Requirements:
246      *
247      * - the calling contract must have an ETH balance of at least `value`.
248      * - the called Solidity function must be `payable`.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
262      * with `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(
267         address target,
268         bytes memory data,
269         uint256 value,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         require(isContract(target), "Address: call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.call{value: value}(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal view returns (bytes memory) {
300         require(isContract(target), "Address: static call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.staticcall(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(isContract(target), "Address: delegate call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.delegatecall(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
335      * revert reason using the provided one.
336      *
337      * _Available since v4.3._
338      */
339     function verifyCallResult(
340         bool success,
341         bytes memory returndata,
342         string memory errorMessage
343     ) internal pure returns (bytes memory) {
344         if (success) {
345             return returndata;
346         } else {
347             // Look for revert reason and bubble it up if present
348             if (returndata.length > 0) {
349                 // The easiest way to bubble the revert reason is using memory via assembly
350 
351                 assembly {
352                     let returndata_size := mload(returndata)
353                     revert(add(32, returndata), returndata_size)
354                 }
355             } else {
356                 revert(errorMessage);
357             }
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @title ERC721 token receiver interface
371  * @dev Interface for any contract that wants to support safeTransfers
372  * from ERC721 asset contracts.
373  */
374 interface IERC721Receiver {
375     /**
376      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
377      * by `operator` from `from`, this function is called.
378      *
379      * It must return its Solidity selector to confirm the token transfer.
380      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
381      *
382      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
383      */
384     function onERC721Received(
385         address operator,
386         address from,
387         uint256 tokenId,
388         bytes calldata data
389     ) external returns (bytes4);
390 }
391 
392 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev Interface of the ERC165 standard, as defined in the
401  * https://eips.ethereum.org/EIPS/eip-165[EIP].
402  *
403  * Implementers can declare support of contract interfaces, which can then be
404  * queried by others ({ERC165Checker}).
405  *
406  * For an implementation, see {ERC165}.
407  */
408 interface IERC165 {
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30 000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 }
419 
420 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @dev Implementation of the {IERC165} interface.
430  *
431  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
432  * for the additional interface id that will be supported. For example:
433  *
434  * ```solidity
435  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
436  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
437  * }
438  * ```
439  *
440  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
441  */
442 abstract contract ERC165 is IERC165 {
443     /**
444      * @dev See {IERC165-supportsInterface}.
445      */
446     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447         return interfaceId == type(IERC165).interfaceId;
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Required interface of an ERC721 compliant contract.
461  */
462 interface IERC721 is IERC165 {
463     /**
464      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
465      */
466     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
470      */
471     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
475      */
476     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
477 
478     /**
479      * @dev Returns the number of tokens in ``owner``'s account.
480      */
481     function balanceOf(address owner) external view returns (uint256 balance);
482 
483     /**
484      * @dev Returns the owner of the `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function ownerOf(uint256 tokenId) external view returns (address owner);
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
494      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Transfers `tokenId` token from `from` to `to`.
514      *
515      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must be owned by `from`.
522      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
523      *
524      * Emits a {Transfer} event.
525      */
526     function transferFrom(
527         address from,
528         address to,
529         uint256 tokenId
530     ) external;
531 
532     /**
533      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
534      * The approval is cleared when the token is transferred.
535      *
536      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
537      *
538      * Requirements:
539      *
540      * - The caller must own the token or be an approved operator.
541      * - `tokenId` must exist.
542      *
543      * Emits an {Approval} event.
544      */
545     function approve(address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Returns the account approved for `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function getApproved(uint256 tokenId) external view returns (address operator);
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
570      *
571      * See {setApprovalForAll}
572      */
573     function isApprovedForAll(address owner, address operator) external view returns (bool);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId,
592         bytes calldata data
593     ) external;
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
606  * @dev See https://eips.ethereum.org/EIPS/eip-721
607  */
608 interface IERC721Metadata is IERC721 {
609     /**
610      * @dev Returns the token collection name.
611      */
612     function name() external view returns (string memory);
613 
614     /**
615      * @dev Returns the token collection symbol.
616      */
617     function symbol() external view returns (string memory);
618 
619     /**
620      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
621      */
622     function tokenURI(uint256 tokenId) external view returns (string memory);
623 }
624 
625 // File: contracts/new.sol
626 
627 
628 
629 
630 pragma solidity ^0.8.4;
631 
632 
633 
634 
635 
636 
637 
638 
639 error ApprovalCallerNotOwnerNorApproved();
640 error ApprovalQueryForNonexistentToken();
641 error ApproveToCaller();
642 error ApprovalToCurrentOwner();
643 error BalanceQueryForZeroAddress();
644 error MintToZeroAddress();
645 error MintZeroQuantity();
646 error OwnerQueryForNonexistentToken();
647 error TransferCallerNotOwnerNorApproved();
648 error TransferFromIncorrectOwner();
649 error TransferToNonERC721ReceiverImplementer();
650 error TransferToZeroAddress();
651 error URIQueryForNonexistentToken();
652 
653 /**
654  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
655  * the Metadata extension. Built to optimize for lower gas during batch mints.
656  *
657  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
658  *
659  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
660  *
661  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
662  */
663 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
664     using Address for address;
665     using Strings for uint256;
666 
667     // Compiler will pack this into a single 256bit word.
668     struct TokenOwnership {
669         // The address of the owner.
670         address addr;
671         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
672         uint64 startTimestamp;
673         // Whether the token has been burned.
674         bool burned;
675     }
676 
677     // Compiler will pack this into a single 256bit word.
678     struct AddressData {
679         // Realistically, 2**64-1 is more than enough.
680         uint64 balance;
681         // Keeps track of mint count with minimal overhead for tokenomics.
682         uint64 numberMinted;
683         // Keeps track of burn count with minimal overhead for tokenomics.
684         uint64 numberBurned;
685         // For miscellaneous variable(s) pertaining to the address
686         // (e.g. number of whitelist mint slots used).
687         // If there are multiple variables, please pack them into a uint64.
688         uint64 aux;
689     }
690 
691     // The tokenId of the next token to be minted.
692     uint256 internal _currentIndex;
693 
694     // The number of tokens burned.
695     uint256 internal _burnCounter;
696 
697     // Token name
698     string private _name;
699 
700     // Token symbol
701     string private _symbol;
702 
703     // Mapping from token ID to ownership details
704     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
705     mapping(uint256 => TokenOwnership) internal _ownerships;
706 
707     // Mapping owner address to address data
708     mapping(address => AddressData) private _addressData;
709 
710     // Mapping from token ID to approved address
711     mapping(uint256 => address) private _tokenApprovals;
712 
713     // Mapping from owner to operator approvals
714     mapping(address => mapping(address => bool)) private _operatorApprovals;
715 
716     constructor(string memory name_, string memory symbol_) {
717         _name = name_;
718         _symbol = symbol_;
719         _currentIndex = _startTokenId();
720     }
721 
722     /**
723      * To change the starting tokenId, please override this function.
724      */
725     function _startTokenId() internal view virtual returns (uint256) {
726         return 0;
727     }
728 
729     /**
730      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
731      */
732     function totalSupply() public view returns (uint256) {
733         // Counter underflow is impossible as _burnCounter cannot be incremented
734         // more than _currentIndex - _startTokenId() times
735         unchecked {
736             return _currentIndex - _burnCounter - _startTokenId();
737         }
738     }
739 
740     /**
741      * Returns the total amount of tokens minted in the contract.
742      */
743     function _totalMinted() internal view returns (uint256) {
744         // Counter underflow is impossible as _currentIndex does not decrement,
745         // and it is initialized to _startTokenId()
746         unchecked {
747             return _currentIndex - _startTokenId();
748         }
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
755         return
756             interfaceId == type(IERC721).interfaceId ||
757             interfaceId == type(IERC721Metadata).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view override returns (uint256) {
765         if (owner == address(0)) revert BalanceQueryForZeroAddress();
766         return uint256(_addressData[owner].balance);
767     }
768 
769     /**
770      * Returns the number of tokens minted by `owner`.
771      */
772     function _numberMinted(address owner) internal view returns (uint256) {
773         return uint256(_addressData[owner].numberMinted);
774     }
775 
776     /**
777      * Returns the number of tokens burned by or on behalf of `owner`.
778      */
779     function _numberBurned(address owner) internal view returns (uint256) {
780         return uint256(_addressData[owner].numberBurned);
781     }
782 
783     /**
784      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
785      */
786     function _getAux(address owner) internal view returns (uint64) {
787         return _addressData[owner].aux;
788     }
789 
790     /**
791      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
792      * If there are multiple variables, please pack them into a uint64.
793      */
794     function _setAux(address owner, uint64 aux) internal {
795         _addressData[owner].aux = aux;
796     }
797 
798     /**
799      * Gas spent here starts off proportional to the maximum mint batch size.
800      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
801      */
802     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
803         uint256 curr = tokenId;
804 
805         unchecked {
806             if (_startTokenId() <= curr && curr < _currentIndex) {
807                 TokenOwnership memory ownership = _ownerships[curr];
808                 if (!ownership.burned) {
809                     if (ownership.addr != address(0)) {
810                         return ownership;
811                     }
812                     // Invariant:
813                     // There will always be an ownership that has an address and is not burned
814                     // before an ownership that does not have an address and is not burned.
815                     // Hence, curr will not underflow.
816                     while (true) {
817                         curr--;
818                         ownership = _ownerships[curr];
819                         if (ownership.addr != address(0)) {
820                             return ownership;
821                         }
822                     }
823                 }
824             }
825         }
826         revert OwnerQueryForNonexistentToken();
827     }
828 
829     /**
830      * @dev See {IERC721-ownerOf}.
831      */
832     function ownerOf(uint256 tokenId) public view override returns (address) {
833         return _ownershipOf(tokenId).addr;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-name}.
838      */
839     function name() public view virtual override returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-symbol}.
845      */
846     function symbol() public view virtual override returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-tokenURI}.
852      */
853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
854         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
855 
856         string memory baseURI = _baseURI();
857         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
858     }
859 
860     /**
861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
863      * by default, can be overriden in child contracts.
864      */
865     function _baseURI() internal view virtual returns (string memory) {
866         return '';
867     }
868 
869     /**
870      * @dev See {IERC721-approve}.
871      */
872     function approve(address to, uint256 tokenId) public override {
873         address owner = ERC721A.ownerOf(tokenId);
874         if (to == owner) revert ApprovalToCurrentOwner();
875 
876         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
877             revert ApprovalCallerNotOwnerNorApproved();
878         }
879 
880         _approve(to, tokenId, owner);
881     }
882 
883     /**
884      * @dev See {IERC721-getApproved}.
885      */
886     function getApproved(uint256 tokenId) public view override returns (address) {
887         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
888 
889         return _tokenApprovals[tokenId];
890     }
891 
892     /**
893      * @dev See {IERC721-setApprovalForAll}.
894      */
895     function setApprovalForAll(address operator, bool approved) public virtual override {
896         if (operator == _msgSender()) revert ApproveToCaller();
897 
898         _operatorApprovals[_msgSender()][operator] = approved;
899         emit ApprovalForAll(_msgSender(), operator, approved);
900     }
901 
902     /**
903      * @dev See {IERC721-isApprovedForAll}.
904      */
905     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
906         return _operatorApprovals[owner][operator];
907     }
908 
909     /**
910      * @dev See {IERC721-transferFrom}.
911      */
912     function transferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) public virtual override {
917         _transfer(from, to, tokenId);
918     }
919 
920     /**
921      * @dev See {IERC721-safeTransferFrom}.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         safeTransferFrom(from, to, tokenId, '');
929     }
930 
931     /**
932      * @dev See {IERC721-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) public virtual override {
940         _transfer(from, to, tokenId);
941         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
942             revert TransferToNonERC721ReceiverImplementer();
943         }
944     }
945 
946     /**
947      * @dev Returns whether `tokenId` exists.
948      *
949      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
950      *
951      * Tokens start existing when they are minted (`_mint`),
952      */
953     function _exists(uint256 tokenId) internal view returns (bool) {
954         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
955             !_ownerships[tokenId].burned;
956     }
957 
958     function _safeMint(address to, uint256 quantity) internal {
959         _safeMint(to, quantity, '');
960     }
961 
962     /**
963      * @dev Safely mints `quantity` tokens and transfers them to `to`.
964      *
965      * Requirements:
966      *
967      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
968      * - `quantity` must be greater than 0.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(
973         address to,
974         uint256 quantity,
975         bytes memory _data
976     ) internal {
977         _mint(to, quantity, _data, true);
978     }
979 
980     /**
981      * @dev Mints `quantity` tokens and transfers them to `to`.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `quantity` must be greater than 0.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _mint(
991         address to,
992         uint256 quantity,
993         bytes memory _data,
994         bool safe
995     ) internal {
996         uint256 startTokenId = _currentIndex;
997         if (to == address(0)) revert MintToZeroAddress();
998         if (quantity == 0) revert MintZeroQuantity();
999 
1000         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1001 
1002         // Overflows are incredibly unrealistic.
1003         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1004         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1005         unchecked {
1006             _addressData[to].balance += uint64(quantity);
1007             _addressData[to].numberMinted += uint64(quantity);
1008 
1009             _ownerships[startTokenId].addr = to;
1010             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1011 
1012             uint256 updatedIndex = startTokenId;
1013             uint256 end = updatedIndex + quantity;
1014 
1015             if (safe && to.isContract()) {
1016                 do {
1017                     emit Transfer(address(0), to, updatedIndex);
1018                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1019                         revert TransferToNonERC721ReceiverImplementer();
1020                     }
1021                 } while (updatedIndex != end);
1022                 // Reentrancy protection
1023                 if (_currentIndex != startTokenId) revert();
1024             } else {
1025                 do {
1026                     emit Transfer(address(0), to, updatedIndex++);
1027                 } while (updatedIndex != end);
1028             }
1029             _currentIndex = updatedIndex;
1030         }
1031         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1032     }
1033 
1034     /**
1035      * @dev Transfers `tokenId` from `from` to `to`.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) private {
1049         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1050 
1051         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1052 
1053         bool isApprovedOrOwner = (_msgSender() == from ||
1054             isApprovedForAll(from, _msgSender()) ||
1055             getApproved(tokenId) == _msgSender());
1056 
1057         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1058         if (to == address(0)) revert TransferToZeroAddress();
1059 
1060         _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, from);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1068         unchecked {
1069             _addressData[from].balance -= 1;
1070             _addressData[to].balance += 1;
1071 
1072             TokenOwnership storage currSlot = _ownerships[tokenId];
1073             currSlot.addr = to;
1074             currSlot.startTimestamp = uint64(block.timestamp);
1075 
1076             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1077             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1078             uint256 nextTokenId = tokenId + 1;
1079             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1080             if (nextSlot.addr == address(0)) {
1081                 // This will suffice for checking _exists(nextTokenId),
1082                 // as a burned slot cannot contain the zero address.
1083                 if (nextTokenId != _currentIndex) {
1084                     nextSlot.addr = from;
1085                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1086                 }
1087             }
1088         }
1089 
1090         emit Transfer(from, to, tokenId);
1091         _afterTokenTransfers(from, to, tokenId, 1);
1092     }
1093 
1094     /**
1095      * @dev This is equivalent to _burn(tokenId, false)
1096      */
1097     function _burn(uint256 tokenId) internal virtual {
1098         _burn(tokenId, false);
1099     }
1100 
1101     /**
1102      * @dev Destroys `tokenId`.
1103      * The approval is cleared when the token is burned.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1112         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1113 
1114         address from = prevOwnership.addr;
1115 
1116         if (approvalCheck) {
1117             bool isApprovedOrOwner = (_msgSender() == from ||
1118                 isApprovedForAll(from, _msgSender()) ||
1119                 getApproved(tokenId) == _msgSender());
1120 
1121             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1122         }
1123 
1124         _beforeTokenTransfers(from, address(0), tokenId, 1);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId, from);
1128 
1129         // Underflow of the sender's balance is impossible because we check for
1130         // ownership above and the recipient's balance can't realistically overflow.
1131         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1132         unchecked {
1133             AddressData storage addressData = _addressData[from];
1134             addressData.balance -= 1;
1135             addressData.numberBurned += 1;
1136 
1137             // Keep track of who burned the token, and the timestamp of burning.
1138             TokenOwnership storage currSlot = _ownerships[tokenId];
1139             currSlot.addr = from;
1140             currSlot.startTimestamp = uint64(block.timestamp);
1141             currSlot.burned = true;
1142 
1143             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1144             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1145             uint256 nextTokenId = tokenId + 1;
1146             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1147             if (nextSlot.addr == address(0)) {
1148                 // This will suffice for checking _exists(nextTokenId),
1149                 // as a burned slot cannot contain the zero address.
1150                 if (nextTokenId != _currentIndex) {
1151                     nextSlot.addr = from;
1152                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1153                 }
1154             }
1155         }
1156 
1157         emit Transfer(from, address(0), tokenId);
1158         _afterTokenTransfers(from, address(0), tokenId, 1);
1159 
1160         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1161         unchecked {
1162             _burnCounter++;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Approve `to` to operate on `tokenId`
1168      *
1169      * Emits a {Approval} event.
1170      */
1171     function _approve(
1172         address to,
1173         uint256 tokenId,
1174         address owner
1175     ) private {
1176         _tokenApprovals[tokenId] = to;
1177         emit Approval(owner, to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint256 ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkContractOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1196             return retval == IERC721Receiver(to).onERC721Received.selector;
1197         } catch (bytes memory reason) {
1198             if (reason.length == 0) {
1199                 revert TransferToNonERC721ReceiverImplementer();
1200             } else {
1201                 assembly {
1202                     revert(add(32, reason), mload(reason))
1203                 }
1204             }
1205         }
1206     }
1207 
1208     /**
1209      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1210      * And also called before burning one token.
1211      *
1212      * startTokenId - the first token id to be transferred
1213      * quantity - the amount to be transferred
1214      *
1215      * Calling conditions:
1216      *
1217      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1218      * transferred to `to`.
1219      * - When `from` is zero, `tokenId` will be minted for `to`.
1220      * - When `to` is zero, `tokenId` will be burned by `from`.
1221      * - `from` and `to` are never both zero.
1222      */
1223     function _beforeTokenTransfers(
1224         address from,
1225         address to,
1226         uint256 startTokenId,
1227         uint256 quantity
1228     ) internal virtual {}
1229 
1230     /**
1231      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1232      * minting.
1233      * And also called after one token has been burned.
1234      *
1235      * startTokenId - the first token id to be transferred
1236      * quantity - the amount to be transferred
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` has been minted for `to`.
1243      * - When `to` is zero, `tokenId` has been burned by `from`.
1244      * - `from` and `to` are never both zero.
1245      */
1246     function _afterTokenTransfers(
1247         address from,
1248         address to,
1249         uint256 startTokenId,
1250         uint256 quantity
1251     ) internal virtual {}
1252 }
1253 
1254 abstract contract Ownable is Context {
1255     address private _owner;
1256 
1257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1258 
1259     /**
1260      * @dev Initializes the contract setting the deployer as the initial owner.
1261      */
1262     constructor() {
1263         _transferOwnership(_msgSender());
1264     }
1265 
1266     /**
1267      * @dev Returns the address of the current owner.
1268      */
1269     function owner() public view virtual returns (address) {
1270         return _owner;
1271     }
1272 
1273     /**
1274      * @dev Throws if called by any account other than the owner.
1275      */
1276     modifier onlyOwner() {
1277         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1278         _;
1279     }
1280 
1281     /**
1282      * @dev Leaves the contract without owner. It will not be possible to call
1283      * `onlyOwner` functions anymore. Can only be called by the current owner.
1284      *
1285      * NOTE: Renouncing ownership will leave the contract without an owner,
1286      * thereby removing any functionality that is only available to the owner.
1287      */
1288     function renounceOwnership() public virtual onlyOwner {
1289         _transferOwnership(address(0));
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Can only be called by the current owner.
1295      */
1296     function transferOwnership(address newOwner) public virtual onlyOwner {
1297         require(newOwner != address(0), "Ownable: new owner is the zero address");
1298         _transferOwnership(newOwner);
1299     }
1300 
1301     /**
1302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1303      * Internal function without access restriction.
1304      */
1305     function _transferOwnership(address newOwner) internal virtual {
1306         address oldOwner = _owner;
1307         _owner = newOwner;
1308         emit OwnershipTransferred(oldOwner, newOwner);
1309     }
1310 }
1311 pragma solidity ^0.8.13;
1312 
1313 interface IOperatorFilterRegistry {
1314     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1315     function register(address registrant) external;
1316     function registerAndSubscribe(address registrant, address subscription) external;
1317     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1318     function updateOperator(address registrant, address operator, bool filtered) external;
1319     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1320     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1321     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1322     function subscribe(address registrant, address registrantToSubscribe) external;
1323     function unsubscribe(address registrant, bool copyExistingEntries) external;
1324     function subscriptionOf(address addr) external returns (address registrant);
1325     function subscribers(address registrant) external returns (address[] memory);
1326     function subscriberAt(address registrant, uint256 index) external returns (address);
1327     function copyEntriesOf(address registrant, address registrantToCopy) external;
1328     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1329     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1330     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1331     function filteredOperators(address addr) external returns (address[] memory);
1332     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1333     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1334     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1335     function isRegistered(address addr) external returns (bool);
1336     function codeHashOf(address addr) external returns (bytes32);
1337 }
1338 pragma solidity ^0.8.13;
1339 
1340 
1341 
1342 abstract contract OperatorFilterer {
1343     error OperatorNotAllowed(address operator);
1344 
1345     IOperatorFilterRegistry constant operatorFilterRegistry =
1346         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1347 
1348     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1349         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1350         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1351         // order for the modifier to filter addresses.
1352         if (address(operatorFilterRegistry).code.length > 0) {
1353             if (subscribe) {
1354                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1355             } else {
1356                 if (subscriptionOrRegistrantToCopy != address(0)) {
1357                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1358                 } else {
1359                     operatorFilterRegistry.register(address(this));
1360                 }
1361             }
1362         }
1363     }
1364 
1365     modifier onlyAllowedOperator(address from) virtual {
1366         // Check registry code length to facilitate testing in environments without a deployed registry.
1367         if (address(operatorFilterRegistry).code.length > 0) {
1368             // Allow spending tokens from addresses with balance
1369             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1370             // from an EOA.
1371             if (from == msg.sender) {
1372                 _;
1373                 return;
1374             }
1375             if (
1376                 !(
1377                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1378                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1379                 )
1380             ) {
1381                 revert OperatorNotAllowed(msg.sender);
1382             }
1383         }
1384         _;
1385     }
1386 }
1387 pragma solidity ^0.8.13;
1388 
1389 
1390 
1391 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1392     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1393 
1394     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1395 }
1396     pragma solidity ^0.8.7;
1397     
1398     contract BoringApes is ERC721A, DefaultOperatorFilterer , Ownable {
1399     using Strings for uint256;
1400 
1401 
1402   string private uriPrefix ;
1403   string private uriSuffix = ".json";
1404   string public hiddenURL;
1405 
1406   
1407   
1408 
1409   uint256 public cost = 0.004 ether;
1410  
1411   
1412 
1413   uint16 public maxSupply = 7777;
1414   uint8 public maxMintAmountPerTx = 21;
1415     uint8 public maxFreeMintAmountPerWallet = 1;
1416                                                              
1417  
1418   bool public paused = true;
1419   bool public reveal =false;
1420 
1421    mapping (address => uint8) public NFTPerPublicAddress;
1422 
1423  
1424   
1425   
1426  
1427   
1428 
1429   constructor() ERC721A("BoringApes", "BORING") {
1430   }
1431 
1432 
1433   
1434  
1435   function publicMint(uint8 _mintAmount) external payable  {
1436      uint16 totalSupply = uint16(totalSupply());
1437      uint8 nft = NFTPerPublicAddress[msg.sender];
1438     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1439     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1440 
1441     require(!paused, "The contract is paused!");
1442     
1443       if(nft >= maxFreeMintAmountPerWallet)
1444     {
1445     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1446     }
1447     else {
1448          uint8 costAmount = _mintAmount + nft;
1449         if(costAmount > maxFreeMintAmountPerWallet)
1450        {
1451         costAmount = costAmount - maxFreeMintAmountPerWallet;
1452         require(msg.value >= cost * costAmount, "Insufficient funds!");
1453        }
1454        
1455          
1456     }
1457     
1458 
1459 
1460     _safeMint(msg.sender , _mintAmount);
1461 
1462     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1463      
1464      delete totalSupply;
1465      delete _mintAmount;
1466   }
1467   
1468   function Treasury(uint16 _mintAmount, address _receiver) external onlyOwner {
1469      uint16 totalSupply = uint16(totalSupply());
1470     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1471      _safeMint(_receiver , _mintAmount);
1472      delete _mintAmount;
1473      delete _receiver;
1474      delete totalSupply;
1475   }
1476 
1477   function  SendNFT(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1478      uint16 totalSupply = uint16(totalSupply());
1479      uint totalAmount =   _amountPerAddress * addresses.length;
1480     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1481      for (uint256 i = 0; i < addresses.length; i++) {
1482             _safeMint(addresses[i], _amountPerAddress);
1483         }
1484 
1485      delete _amountPerAddress;
1486      delete totalSupply;
1487   }
1488 
1489  
1490 
1491   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1492       maxSupply = _maxSupply;
1493   }
1494 
1495 
1496 
1497    
1498   function tokenURI(uint256 _tokenId)
1499     public
1500     view
1501     virtual
1502     override
1503     returns (string memory)
1504   {
1505     require(
1506       _exists(_tokenId),
1507       "ERC721Metadata: URI query for nonexistent token"
1508     );
1509     
1510   
1511 if ( reveal == false)
1512 {
1513     return hiddenURL;
1514 }
1515     
1516 
1517     string memory currentBaseURI = _baseURI();
1518     return bytes(currentBaseURI).length > 0
1519         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1520         : "";
1521   }
1522  
1523  
1524 
1525 
1526  function setFreeMaxLimit(uint8 _limit) external onlyOwner{
1527     maxFreeMintAmountPerWallet = _limit;
1528    delete _limit;
1529 
1530 }
1531 
1532     
1533   
1534 
1535   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1536     uriPrefix = _uriPrefix;
1537   }
1538    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1539     hiddenURL = _uriPrefix;
1540   }
1541 
1542 
1543   function togglePaused() external onlyOwner {
1544     paused = !paused;
1545    
1546   }
1547 
1548   function setCost(uint _cost) external onlyOwner{
1549       cost = _cost;
1550 
1551   }
1552 
1553  function setRevealed() external onlyOwner{
1554      reveal = !reveal;
1555  }
1556 
1557   function setMaxMintPerTx(uint8 _maxtx) external onlyOwner{
1558       maxMintAmountPerTx = _maxtx;
1559 
1560   }
1561 
1562  
1563 
1564   function withdraw() external onlyOwner {
1565   uint _balance = address(this).balance;
1566      payable(msg.sender).transfer(_balance ); 
1567        
1568   }
1569 
1570 
1571   function _baseURI() internal view  override returns (string memory) {
1572     return uriPrefix;
1573   }
1574 
1575     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1576         super.transferFrom(from, to, tokenId);
1577     }
1578 
1579     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1580         super.safeTransferFrom(from, to, tokenId);
1581     }
1582 
1583     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1584         public
1585         override
1586         onlyAllowedOperator(from)
1587     {
1588         super.safeTransferFrom(from, to, tokenId, data);
1589     }
1590 }