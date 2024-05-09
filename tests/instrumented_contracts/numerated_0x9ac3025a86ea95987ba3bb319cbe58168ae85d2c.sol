1 // SPDX-License-Identifier: MIT
2 //Developer Info: FACELESS CULT
3 /**
4 
5  ________ ________  ________  _______   ___       _______   ________   ________      
6 |\  _____\\   __  \|\   ____\|\  ___ \ |\  \     |\  ___ \ |\   ____\ |\   ____\     
7 \ \  \__/\ \  \|\  \ \  \___|\ \   __/|\ \  \    \ \   __/|\ \  \___|_\ \  \___|_    
8  \ \   __\\ \   __  \ \  \    \ \  \_|/_\ \  \    \ \  \_|/_\ \_____  \\ \_____  \   
9   \ \  \_| \ \  \ \  \ \  \____\ \  \_|\ \ \  \____\ \  \_|\ \|____|\  \\|____|\  \  
10    \ \__\   \ \__\ \__\ \_______\ \_______\ \_______\ \_______\____\_\  \ ____\_\  \ 
11     \|__|    \|__|\|__|\|_______|\|_______|\|_______|\|_______|\_________\\_________\
12                                                               \|_________\|_________|
13                                                                                      
14                                                                                      
15  ________  ___  ___  ___   _________                                                 
16 |\   ____\|\  \|\  \|\  \ |\___   ___\                                               
17 \ \  \___|\ \  \\\  \ \  \\|___ \  \_|                                               
18  \ \  \    \ \  \\\  \ \  \    \ \  \                                                
19   \ \  \____\ \  \\\  \ \  \____\ \  \                                               
20    \ \_______\ \_______\ \_______\ \__\                                              
21     \|_______|\|_______|\|_______|\|__|                                              
22                                                                                                                                                                                                                                                                
23  */
24 
25 
26 // File: @openzeppelin/contracts/utils/Strings.sol
27 
28 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev String operations.
34  */
35 library Strings {
36     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
40      */
41     function toString(uint256 value) internal pure returns (string memory) {
42         // Inspired by OraclizeAPI's implementation - MIT licence
43         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
44 
45         if (value == 0) {
46             return "0";
47         }
48         uint256 temp = value;
49         uint256 digits;
50         while (temp != 0) {
51             digits++;
52             temp /= 10;
53         }
54         bytes memory buffer = new bytes(digits);
55         while (value != 0) {
56             digits -= 1;
57             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
58             value /= 10;
59         }
60         return string(buffer);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
65      */
66     function toHexString(uint256 value) internal pure returns (string memory) {
67         if (value == 0) {
68             return "0x00";
69         }
70         uint256 temp = value;
71         uint256 length = 0;
72         while (temp != 0) {
73             length++;
74             temp >>= 8;
75         }
76         return toHexString(value, length);
77     }
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
81      */
82     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Context.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         return msg.data;
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Address.sol
123 
124 
125 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
126 
127 pragma solidity ^0.8.1;
128 
129 /**
130  * @dev Collection of functions related to the address type
131  */
132 library Address {
133     /**
134      * @dev Returns true if `account` is a contract.
135      *
136      * [IMPORTANT]
137      * ====
138      * It is unsafe to assume that an address for which this function returns
139      * false is an externally-owned account (EOA) and not a contract.
140      *
141      * Among others, `isContract` will return false for the following
142      * types of addresses:
143      *
144      *  - an externally-owned account
145      *  - a contract in construction
146      *  - an address where a contract will be created
147      *  - an address where a contract lived, but was destroyed
148      * ====
149      *
150      * [IMPORTANT]
151      * ====
152      * You shouldn't rely on `isContract` to protect against flash loan attacks!
153      *
154      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
155      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
156      * constructor.
157      * ====
158      */
159     function isContract(address account) internal view returns (bool) {
160         // This method relies on extcodesize/address.code.length, which returns 0
161         // for contracts in construction, since the code is only stored at the end
162         // of the constructor execution.
163 
164         return account.code.length > 0;
165     }
166 
167     /**
168      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
169      * `recipient`, forwarding all available gas and reverting on errors.
170      *
171      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
172      * of certain opcodes, possibly making contracts go over the 2300 gas limit
173      * imposed by `transfer`, making them unable to receive funds via
174      * `transfer`. {sendValue} removes this limitation.
175      *
176      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
177      *
178      * IMPORTANT: because control is transferred to `recipient`, care must be
179      * taken to not create reentrancy vulnerabilities. Consider using
180      * {ReentrancyGuard} or the
181      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
182      */
183     function sendValue(address payable recipient, uint256 amount) internal {
184         require(address(this).balance >= amount, "Address: insufficient balance");
185 
186         (bool success, ) = recipient.call{value: amount}("");
187         require(success, "Address: unable to send value, recipient may have reverted");
188     }
189 
190     /**
191      * @dev Performs a Solidity function call using a low level `call`. A
192      * plain `call` is an unsafe replacement for a function call: use this
193      * function instead.
194      *
195      * If `target` reverts with a revert reason, it is bubbled up by this
196      * function (like regular Solidity function calls).
197      *
198      * Returns the raw returned data. To convert to the expected return value,
199      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
200      *
201      * Requirements:
202      *
203      * - `target` must be a contract.
204      * - calling `target` with `data` must not revert.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
209         return functionCall(target, data, "Address: low-level call failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
214      * `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(
219         address target,
220         bytes memory data,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, 0, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but also transferring `value` wei to `target`.
229      *
230      * Requirements:
231      *
232      * - the calling contract must have an ETH balance of at least `value`.
233      * - the called Solidity function must be `payable`.
234      *
235      * _Available since v3.1._
236      */
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
247      * with `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCallWithValue(
252         address target,
253         bytes memory data,
254         uint256 value,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(address(this).balance >= value, "Address: insufficient balance for call");
258         require(isContract(target), "Address: call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.call{value: value}(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but performing a static call.
267      *
268      * _Available since v3.3._
269      */
270     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
271         return functionStaticCall(target, data, "Address: low-level static call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal view returns (bytes memory) {
285         require(isContract(target), "Address: static call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.staticcall(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but performing a delegate call.
294      *
295      * _Available since v3.4._
296      */
297     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(isContract(target), "Address: delegate call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.delegatecall(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
320      * revert reason using the provided one.
321      *
322      * _Available since v4.3._
323      */
324     function verifyCallResult(
325         bool success,
326         bytes memory returndata,
327         string memory errorMessage
328     ) internal pure returns (bytes memory) {
329         if (success) {
330             return returndata;
331         } else {
332             // Look for revert reason and bubble it up if present
333             if (returndata.length > 0) {
334                 // The easiest way to bubble the revert reason is using memory via assembly
335 
336                 assembly {
337                     let returndata_size := mload(returndata)
338                     revert(add(32, returndata), returndata_size)
339                 }
340             } else {
341                 revert(errorMessage);
342             }
343         }
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @title ERC721 token receiver interface
356  * @dev Interface for any contract that wants to support safeTransfers
357  * from ERC721 asset contracts.
358  */
359 interface IERC721Receiver {
360     /**
361      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
362      * by `operator` from `from`, this function is called.
363      *
364      * It must return its Solidity selector to confirm the token transfer.
365      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
366      *
367      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
368      */
369     function onERC721Received(
370         address operator,
371         address from,
372         uint256 tokenId,
373         bytes calldata data
374     ) external returns (bytes4);
375 }
376 
377 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @dev Interface of the ERC165 standard, as defined in the
386  * https://eips.ethereum.org/EIPS/eip-165[EIP].
387  *
388  * Implementers can declare support of contract interfaces, which can then be
389  * queried by others ({ERC165Checker}).
390  *
391  * For an implementation, see {ERC165}.
392  */
393 interface IERC165 {
394     /**
395      * @dev Returns true if this contract implements the interface defined by
396      * `interfaceId`. See the corresponding
397      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
398      * to learn more about how these ids are created.
399      *
400      * This function call must use less than 30 000 gas.
401      */
402     function supportsInterface(bytes4 interfaceId) external view returns (bool);
403 }
404 
405 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @dev Implementation of the {IERC165} interface.
415  *
416  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
417  * for the additional interface id that will be supported. For example:
418  *
419  * ```solidity
420  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
422  * }
423  * ```
424  *
425  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
426  */
427 abstract contract ERC165 is IERC165 {
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         return interfaceId == type(IERC165).interfaceId;
433     }
434 }
435 
436 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 
444 /**
445  * @dev Required interface of an ERC721 compliant contract.
446  */
447 interface IERC721 is IERC165 {
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId) external view returns (address operator);
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId,
577         bytes calldata data
578     ) external;
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
591  * @dev See https://eips.ethereum.org/EIPS/eip-721
592  */
593 interface IERC721Metadata is IERC721 {
594     /**
595      * @dev Returns the token collection name.
596      */
597     function name() external view returns (string memory);
598 
599     /**
600      * @dev Returns the token collection symbol.
601      */
602     function symbol() external view returns (string memory);
603 
604     /**
605      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
606      */
607     function tokenURI(uint256 tokenId) external view returns (string memory);
608 }
609 
610 // File: contracts/new.sol
611 
612 
613 
614 
615 pragma solidity ^0.8.4;
616 
617 
618 
619 
620 
621 
622 
623 
624 error ApprovalCallerNotOwnerNorApproved();
625 error ApprovalQueryForNonexistentToken();
626 error ApproveToCaller();
627 error ApprovalToCurrentOwner();
628 error BalanceQueryForZeroAddress();
629 error MintToZeroAddress();
630 error MintZeroQuantity();
631 error OwnerQueryForNonexistentToken();
632 error TransferCallerNotOwnerNorApproved();
633 error TransferFromIncorrectOwner();
634 error TransferToNonERC721ReceiverImplementer();
635 error TransferToZeroAddress();
636 error URIQueryForNonexistentToken();
637 
638 /**
639  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
640  * the Metadata extension. Built to optimize for lower gas during batch mints.
641  *
642  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
643  *
644  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
645  *
646  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
647  */
648 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
649     using Address for address;
650     using Strings for uint256;
651 
652     // Compiler will pack this into a single 256bit word.
653     struct TokenOwnership {
654         // The address of the owner.
655         address addr;
656         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
657         uint64 startTimestamp;
658         // Whether the token has been burned.
659         bool burned;
660     }
661 
662     // Compiler will pack this into a single 256bit word.
663     struct AddressData {
664         // Realistically, 2**64-1 is more than enough.
665         uint64 balance;
666         // Keeps track of mint count with minimal overhead for tokenomics.
667         uint64 numberMinted;
668         // Keeps track of burn count with minimal overhead for tokenomics.
669         uint64 numberBurned;
670         // For miscellaneous variable(s) pertaining to the address
671         // (e.g. number of whitelist mint slots used).
672         // If there are multiple variables, please pack them into a uint64.
673         uint64 aux;
674     }
675 
676     // The tokenId of the next token to be minted.
677     uint256 internal _currentIndex;
678 
679     // The number of tokens burned.
680     uint256 internal _burnCounter;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to ownership details
689     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
690     mapping(uint256 => TokenOwnership) internal _ownerships;
691 
692     // Mapping owner address to address data
693     mapping(address => AddressData) private _addressData;
694 
695     // Mapping from token ID to approved address
696     mapping(uint256 => address) private _tokenApprovals;
697 
698     // Mapping from owner to operator approvals
699     mapping(address => mapping(address => bool)) private _operatorApprovals;
700 
701     constructor(string memory name_, string memory symbol_) {
702         _name = name_;
703         _symbol = symbol_;
704         _currentIndex = _startTokenId();
705     }
706 
707     /**
708      * To change the starting tokenId, please override this function.
709      */
710     function _startTokenId() internal view virtual returns (uint256) {
711         return 0;
712     }
713 
714     /**
715      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
716      */
717     function totalSupply() public view returns (uint256) {
718         // Counter underflow is impossible as _burnCounter cannot be incremented
719         // more than _currentIndex - _startTokenId() times
720         unchecked {
721             return _currentIndex - _burnCounter - _startTokenId();
722         }
723     }
724 
725     /**
726      * Returns the total amount of tokens minted in the contract.
727      */
728     function _totalMinted() internal view returns (uint256) {
729         // Counter underflow is impossible as _currentIndex does not decrement,
730         // and it is initialized to _startTokenId()
731         unchecked {
732             return _currentIndex - _startTokenId();
733         }
734     }
735 
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
740         return
741             interfaceId == type(IERC721).interfaceId ||
742             interfaceId == type(IERC721Metadata).interfaceId ||
743             super.supportsInterface(interfaceId);
744     }
745 
746     /**
747      * @dev See {IERC721-balanceOf}.
748      */
749     function balanceOf(address owner) public view override returns (uint256) {
750         if (owner == address(0)) revert BalanceQueryForZeroAddress();
751         return uint256(_addressData[owner].balance);
752     }
753 
754     /**
755      * Returns the number of tokens minted by `owner`.
756      */
757     function _numberMinted(address owner) internal view returns (uint256) {
758         return uint256(_addressData[owner].numberMinted);
759     }
760 
761     /**
762      * Returns the number of tokens burned by or on behalf of `owner`.
763      */
764     function _numberBurned(address owner) internal view returns (uint256) {
765         return uint256(_addressData[owner].numberBurned);
766     }
767 
768     /**
769      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
770      */
771     function _getAux(address owner) internal view returns (uint64) {
772         return _addressData[owner].aux;
773     }
774 
775     /**
776      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
777      * If there are multiple variables, please pack them into a uint64.
778      */
779     function _setAux(address owner, uint64 aux) internal {
780         _addressData[owner].aux = aux;
781     }
782 
783     /**
784      * Gas spent here starts off proportional to the maximum mint batch size.
785      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
786      */
787     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
788         uint256 curr = tokenId;
789 
790         unchecked {
791             if (_startTokenId() <= curr && curr < _currentIndex) {
792                 TokenOwnership memory ownership = _ownerships[curr];
793                 if (!ownership.burned) {
794                     if (ownership.addr != address(0)) {
795                         return ownership;
796                     }
797                     // Invariant:
798                     // There will always be an ownership that has an address and is not burned
799                     // before an ownership that does not have an address and is not burned.
800                     // Hence, curr will not underflow.
801                     while (true) {
802                         curr--;
803                         ownership = _ownerships[curr];
804                         if (ownership.addr != address(0)) {
805                             return ownership;
806                         }
807                     }
808                 }
809             }
810         }
811         revert OwnerQueryForNonexistentToken();
812     }
813 
814     /**
815      * @dev See {IERC721-ownerOf}.
816      */
817     function ownerOf(uint256 tokenId) public view override returns (address) {
818         return _ownershipOf(tokenId).addr;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-name}.
823      */
824     function name() public view virtual override returns (string memory) {
825         return _name;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-symbol}.
830      */
831     function symbol() public view virtual override returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-tokenURI}.
837      */
838     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
839         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
840 
841         string memory baseURI = _baseURI();
842         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
843     }
844 
845     /**
846      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
847      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
848      * by default, can be overriden in child contracts.
849      */
850     function _baseURI() internal view virtual returns (string memory) {
851         return '';
852     }
853 
854     /**
855      * @dev See {IERC721-approve}.
856      */
857     function approve(address to, uint256 tokenId) public override {
858         address owner = ERC721A.ownerOf(tokenId);
859         if (to == owner) revert ApprovalToCurrentOwner();
860 
861         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
862             revert ApprovalCallerNotOwnerNorApproved();
863         }
864 
865         _approve(to, tokenId, owner);
866     }
867 
868     /**
869      * @dev See {IERC721-getApproved}.
870      */
871     function getApproved(uint256 tokenId) public view override returns (address) {
872         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
873 
874         return _tokenApprovals[tokenId];
875     }
876 
877     /**
878      * @dev See {IERC721-setApprovalForAll}.
879      */
880     function setApprovalForAll(address operator, bool approved) public virtual override {
881         if (operator == _msgSender()) revert ApproveToCaller();
882 
883         _operatorApprovals[_msgSender()][operator] = approved;
884         emit ApprovalForAll(_msgSender(), operator, approved);
885     }
886 
887     /**
888      * @dev See {IERC721-isApprovedForAll}.
889      */
890     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
891         return _operatorApprovals[owner][operator];
892     }
893 
894     /**
895      * @dev See {IERC721-transferFrom}.
896      */
897     function transferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         _transfer(from, to, tokenId);
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         safeTransferFrom(from, to, tokenId, '');
914     }
915 
916     /**
917      * @dev See {IERC721-safeTransferFrom}.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) public virtual override {
925         _transfer(from, to, tokenId);
926         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
927             revert TransferToNonERC721ReceiverImplementer();
928         }
929     }
930 
931     /**
932      * @dev Returns whether `tokenId` exists.
933      *
934      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
935      *
936      * Tokens start existing when they are minted (`_mint`),
937      */
938     function _exists(uint256 tokenId) internal view returns (bool) {
939         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
940             !_ownerships[tokenId].burned;
941     }
942 
943     function _safeMint(address to, uint256 quantity) internal {
944         _safeMint(to, quantity, '');
945     }
946 
947     /**
948      * @dev Safely mints `quantity` tokens and transfers them to `to`.
949      *
950      * Requirements:
951      *
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(
958         address to,
959         uint256 quantity,
960         bytes memory _data
961     ) internal {
962         _mint(to, quantity, _data, true);
963     }
964 
965     /**
966      * @dev Mints `quantity` tokens and transfers them to `to`.
967      *
968      * Requirements:
969      *
970      * - `to` cannot be the zero address.
971      * - `quantity` must be greater than 0.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _mint(
976         address to,
977         uint256 quantity,
978         bytes memory _data,
979         bool safe
980     ) internal {
981         uint256 startTokenId = _currentIndex;
982         if (to == address(0)) revert MintToZeroAddress();
983         if (quantity == 0) revert MintZeroQuantity();
984 
985         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
986 
987         // Overflows are incredibly unrealistic.
988         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
989         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
990         unchecked {
991             _addressData[to].balance += uint64(quantity);
992             _addressData[to].numberMinted += uint64(quantity);
993 
994             _ownerships[startTokenId].addr = to;
995             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
996 
997             uint256 updatedIndex = startTokenId;
998             uint256 end = updatedIndex + quantity;
999 
1000             if (safe && to.isContract()) {
1001                 do {
1002                     emit Transfer(address(0), to, updatedIndex);
1003                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1004                         revert TransferToNonERC721ReceiverImplementer();
1005                     }
1006                 } while (updatedIndex != end);
1007                 // Reentrancy protection
1008                 if (_currentIndex != startTokenId) revert();
1009             } else {
1010                 do {
1011                     emit Transfer(address(0), to, updatedIndex++);
1012                 } while (updatedIndex != end);
1013             }
1014             _currentIndex = updatedIndex;
1015         }
1016         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) private {
1034         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1035 
1036         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1037 
1038         bool isApprovedOrOwner = (_msgSender() == from ||
1039             isApprovedForAll(from, _msgSender()) ||
1040             getApproved(tokenId) == _msgSender());
1041 
1042         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1043         if (to == address(0)) revert TransferToZeroAddress();
1044 
1045         _beforeTokenTransfers(from, to, tokenId, 1);
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId, from);
1049 
1050         // Underflow of the sender's balance is impossible because we check for
1051         // ownership above and the recipient's balance can't realistically overflow.
1052         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1053         unchecked {
1054             _addressData[from].balance -= 1;
1055             _addressData[to].balance += 1;
1056 
1057             TokenOwnership storage currSlot = _ownerships[tokenId];
1058             currSlot.addr = to;
1059             currSlot.startTimestamp = uint64(block.timestamp);
1060 
1061             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063             uint256 nextTokenId = tokenId + 1;
1064             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1065             if (nextSlot.addr == address(0)) {
1066                 // This will suffice for checking _exists(nextTokenId),
1067                 // as a burned slot cannot contain the zero address.
1068                 if (nextTokenId != _currentIndex) {
1069                     nextSlot.addr = from;
1070                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1071                 }
1072             }
1073         }
1074 
1075         emit Transfer(from, to, tokenId);
1076         _afterTokenTransfers(from, to, tokenId, 1);
1077     }
1078 
1079     /**
1080      * @dev This is equivalent to _burn(tokenId, false)
1081      */
1082     function _burn(uint256 tokenId) internal virtual {
1083         _burn(tokenId, false);
1084     }
1085 
1086     /**
1087      * @dev Destroys `tokenId`.
1088      * The approval is cleared when the token is burned.
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must exist.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1097         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1098 
1099         address from = prevOwnership.addr;
1100 
1101         if (approvalCheck) {
1102             bool isApprovedOrOwner = (_msgSender() == from ||
1103                 isApprovedForAll(from, _msgSender()) ||
1104                 getApproved(tokenId) == _msgSender());
1105 
1106             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1107         }
1108 
1109         _beforeTokenTransfers(from, address(0), tokenId, 1);
1110 
1111         // Clear approvals from the previous owner
1112         _approve(address(0), tokenId, from);
1113 
1114         // Underflow of the sender's balance is impossible because we check for
1115         // ownership above and the recipient's balance can't realistically overflow.
1116         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1117         unchecked {
1118             AddressData storage addressData = _addressData[from];
1119             addressData.balance -= 1;
1120             addressData.numberBurned += 1;
1121 
1122             // Keep track of who burned the token, and the timestamp of burning.
1123             TokenOwnership storage currSlot = _ownerships[tokenId];
1124             currSlot.addr = from;
1125             currSlot.startTimestamp = uint64(block.timestamp);
1126             currSlot.burned = true;
1127 
1128             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1129             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1130             uint256 nextTokenId = tokenId + 1;
1131             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1132             if (nextSlot.addr == address(0)) {
1133                 // This will suffice for checking _exists(nextTokenId),
1134                 // as a burned slot cannot contain the zero address.
1135                 if (nextTokenId != _currentIndex) {
1136                     nextSlot.addr = from;
1137                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1138                 }
1139             }
1140         }
1141 
1142         emit Transfer(from, address(0), tokenId);
1143         _afterTokenTransfers(from, address(0), tokenId, 1);
1144 
1145         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1146         unchecked {
1147             _burnCounter++;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Approve `to` to operate on `tokenId`
1153      *
1154      * Emits a {Approval} event.
1155      */
1156     function _approve(
1157         address to,
1158         uint256 tokenId,
1159         address owner
1160     ) private {
1161         _tokenApprovals[tokenId] = to;
1162         emit Approval(owner, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkContractOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181             return retval == IERC721Receiver(to).onERC721Received.selector;
1182         } catch (bytes memory reason) {
1183             if (reason.length == 0) {
1184                 revert TransferToNonERC721ReceiverImplementer();
1185             } else {
1186                 assembly {
1187                     revert(add(32, reason), mload(reason))
1188                 }
1189             }
1190         }
1191     }
1192 
1193     /**
1194      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1195      * And also called before burning one token.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, `tokenId` will be burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _beforeTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 
1215     /**
1216      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1217      * minting.
1218      * And also called after one token has been burned.
1219      *
1220      * startTokenId - the first token id to be transferred
1221      * quantity - the amount to be transferred
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` has been minted for `to`.
1228      * - When `to` is zero, `tokenId` has been burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _afterTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 }
1238 
1239 abstract contract Ownable is Context {
1240     address private _owner;
1241 
1242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1243 
1244     /**
1245      * @dev Initializes the contract setting the deployer as the initial owner.
1246      */
1247     constructor() {
1248         _transferOwnership(_msgSender());
1249     }
1250 
1251     /**
1252      * @dev Returns the address of the current owner.
1253      */
1254     function owner() public view virtual returns (address) {
1255         return _owner;
1256     }
1257 
1258     /**
1259      * @dev Throws if called by any account other than the owner.
1260      */
1261     modifier onlyOwner() {
1262         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1263         _;
1264     }
1265 
1266     /**
1267      * @dev Leaves the contract without owner. It will not be possible to call
1268      * `onlyOwner` functions anymore. Can only be called by the current owner.
1269      *
1270      * NOTE: Renouncing ownership will leave the contract without an owner,
1271      * thereby removing any functionality that is only available to the owner.
1272      */
1273     function renounceOwnership() public virtual onlyOwner {
1274         _transferOwnership(address(0));
1275     }
1276 
1277     /**
1278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1279      * Can only be called by the current owner.
1280      */
1281     function transferOwnership(address newOwner) public virtual onlyOwner {
1282         require(newOwner != address(0), "Ownable: new owner is the zero address");
1283         _transferOwnership(newOwner);
1284     }
1285 
1286     /**
1287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1288      * Internal function without access restriction.
1289      */
1290     function _transferOwnership(address newOwner) internal virtual {
1291         address oldOwner = _owner;
1292         _owner = newOwner;
1293         emit OwnershipTransferred(oldOwner, newOwner);
1294     }
1295 }
1296 pragma solidity ^0.8.13;
1297 
1298 interface IOperatorFilterRegistry {
1299     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1300     function register(address registrant) external;
1301     function registerAndSubscribe(address registrant, address subscription) external;
1302     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1303     function updateOperator(address registrant, address operator, bool filtered) external;
1304     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1305     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1306     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1307     function subscribe(address registrant, address registrantToSubscribe) external;
1308     function unsubscribe(address registrant, bool copyExistingEntries) external;
1309     function subscriptionOf(address addr) external returns (address registrant);
1310     function subscribers(address registrant) external returns (address[] memory);
1311     function subscriberAt(address registrant, uint256 index) external returns (address);
1312     function copyEntriesOf(address registrant, address registrantToCopy) external;
1313     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1314     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1315     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1316     function filteredOperators(address addr) external returns (address[] memory);
1317     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1318     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1319     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1320     function isRegistered(address addr) external returns (bool);
1321     function codeHashOf(address addr) external returns (bytes32);
1322 }
1323 pragma solidity ^0.8.13;
1324 
1325 
1326 
1327 abstract contract OperatorFilterer {
1328     error OperatorNotAllowed(address operator);
1329 
1330     IOperatorFilterRegistry constant operatorFilterRegistry =
1331         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1332 
1333     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1334         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1335         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1336         // order for the modifier to filter addresses.
1337         if (address(operatorFilterRegistry).code.length > 0) {
1338             if (subscribe) {
1339                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1340             } else {
1341                 if (subscriptionOrRegistrantToCopy != address(0)) {
1342                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1343                 } else {
1344                     operatorFilterRegistry.register(address(this));
1345                 }
1346             }
1347         }
1348     }
1349 
1350     modifier onlyAllowedOperator(address from) virtual {
1351         // Check registry code length to facilitate testing in environments without a deployed registry.
1352         if (address(operatorFilterRegistry).code.length > 0) {
1353             // Allow spending tokens from addresses with balance
1354             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1355             // from an EOA.
1356             if (from == msg.sender) {
1357                 _;
1358                 return;
1359             }
1360             if (
1361                 !(
1362                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1363                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1364                 )
1365             ) {
1366                 revert OperatorNotAllowed(msg.sender);
1367             }
1368         }
1369         _;
1370     }
1371 }
1372 pragma solidity ^0.8.13;
1373 
1374 
1375 
1376 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1377     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1378 
1379     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1380 }
1381     pragma solidity ^0.8.7;
1382     
1383     contract FACELESSCULT is ERC721A, DefaultOperatorFilterer , Ownable {
1384     using Strings for uint256;
1385 
1386 
1387   string private uriPrefix ;
1388   string private uriSuffix = ".json";
1389   string public hiddenURL;
1390 
1391   
1392   
1393 
1394   uint256 public cost = 0.003 ether;
1395  
1396   
1397 
1398   uint16 public maxSupply = 6666;
1399   uint8 public maxMintAmountPerTx = 20;
1400     uint8 public maxFreeMintAmountPerWallet = 1;
1401                                                              
1402  
1403   bool public paused = true;
1404   bool public reveal =false;
1405 
1406    mapping (address => uint8) public NFTPerPublicAddress;
1407 
1408  
1409   
1410   
1411  
1412   
1413 
1414   constructor() ERC721A("FACELESS CULT", "CULT") {
1415   }
1416 
1417 
1418   
1419  
1420   function mint(uint8 _mintAmount) external payable  {
1421      uint16 totalSupply = uint16(totalSupply());
1422      uint8 nft = NFTPerPublicAddress[msg.sender];
1423     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1424     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1425     require(msg.sender == tx.origin , "No Bots Allowed");
1426 
1427     require(!paused, "The contract is paused!");
1428     
1429       if(nft >= maxFreeMintAmountPerWallet)
1430     {
1431     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1432     }
1433     else {
1434          uint8 costAmount = _mintAmount + nft;
1435         if(costAmount > maxFreeMintAmountPerWallet)
1436        {
1437         costAmount = costAmount - maxFreeMintAmountPerWallet;
1438         require(msg.value >= cost * costAmount, "Insufficient funds!");
1439        }
1440        
1441          
1442     }
1443     
1444 
1445 
1446     _safeMint(msg.sender , _mintAmount);
1447 
1448     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1449      
1450      delete totalSupply;
1451      delete _mintAmount;
1452   }
1453   
1454   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1455      uint16 totalSupply = uint16(totalSupply());
1456     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1457      _safeMint(_receiver , _mintAmount);
1458      delete _mintAmount;
1459      delete _receiver;
1460      delete totalSupply;
1461   }
1462 
1463   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1464      uint16 totalSupply = uint16(totalSupply());
1465      uint totalAmount =   _amountPerAddress * addresses.length;
1466     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1467      for (uint256 i = 0; i < addresses.length; i++) {
1468             _safeMint(addresses[i], _amountPerAddress);
1469         }
1470 
1471      delete _amountPerAddress;
1472      delete totalSupply;
1473   }
1474 
1475  
1476 
1477   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1478       maxSupply = _maxSupply;
1479   }
1480 
1481 
1482 
1483    
1484   function tokenURI(uint256 _tokenId)
1485     public
1486     view
1487     virtual
1488     override
1489     returns (string memory)
1490   {
1491     require(
1492       _exists(_tokenId),
1493       "ERC721Metadata: URI query for nonexistent token"
1494     );
1495     
1496   
1497 if ( reveal == false)
1498 {
1499     return hiddenURL;
1500 }
1501     
1502 
1503     string memory currentBaseURI = _baseURI();
1504     return bytes(currentBaseURI).length > 0
1505         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1506         : "";
1507   }
1508  
1509  
1510 
1511 
1512  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1513     maxFreeMintAmountPerWallet = _limit;
1514    delete _limit;
1515 
1516 }
1517 
1518     
1519   
1520 
1521   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1522     uriPrefix = _uriPrefix;
1523   }
1524    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1525     hiddenURL = _uriPrefix;
1526   }
1527 
1528 
1529   function setPaused() external onlyOwner {
1530     paused = !paused;
1531    
1532   }
1533 
1534   function setCost(uint _cost) external onlyOwner{
1535       cost = _cost;
1536 
1537   }
1538 
1539  function setRevealed() external onlyOwner{
1540      reveal = !reveal;
1541  }
1542 
1543   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1544       maxMintAmountPerTx = _maxtx;
1545 
1546   }
1547 
1548  
1549 
1550   function withdraw() external onlyOwner {
1551   uint _balance = address(this).balance;
1552      payable(msg.sender).transfer(_balance ); 
1553        
1554   }
1555 
1556 
1557   function _baseURI() internal view  override returns (string memory) {
1558     return uriPrefix;
1559   }
1560 
1561     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1562         super.transferFrom(from, to, tokenId);
1563     }
1564 
1565     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1566         super.safeTransferFrom(from, to, tokenId);
1567     }
1568 
1569     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1570         public
1571         override
1572         onlyAllowedOperator(from)
1573     {
1574         super.safeTransferFrom(from, to, tokenId, data);
1575     }
1576 }