1 /**
2  ______                                                _                      _______               _            
3 |_   _ `.                                             / |_                   |_   __ \             / |_          
4   | | `. \  __   _    _ .--..--.    _ .--.    .--.   `| |-'  .---.   _ .--.    | |__) |    ,--.   `| |-'  ____   
5   | |  | | [  | | |  [ `.-. .-. |  [ '/'`\ \ ( (`\]   | |   / /__\\ [ `/'`\]   |  __ /    `'_\ :   | |   [_   ]  
6  _| |_.' /  | \_/ |,  | | | | | |   | \__/ |  `'.'.   | |,  | \__.,  | |      _| |  \ \_  // | |,  | |,   .' /_  
7 |______.'   '.__.'_/ [___||__||__]  | ;.__/  [\__) )  \__/   '.__.' [___]    |____| |___| \'-;__/  \__/  [_____] 
8                                    [__|                                                                          
9  */
10 
11 
12 // SPDX-License-Identifier: MIT
13 
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev String operations.
22  */
23 library Strings {
24     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
25 
26     /**
27      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
28      */
29     function toString(uint256 value) internal pure returns (string memory) {
30         // Inspired by OraclizeAPI's implementation - MIT licence
31         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
32 
33         if (value == 0) {
34             return "0";
35         }
36         uint256 temp = value;
37         uint256 digits;
38         while (temp != 0) {
39             digits++;
40             temp /= 10;
41         }
42         bytes memory buffer = new bytes(digits);
43         while (value != 0) {
44             digits -= 1;
45             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
46             value /= 10;
47         }
48         return string(buffer);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
53      */
54     function toHexString(uint256 value) internal pure returns (string memory) {
55         if (value == 0) {
56             return "0x00";
57         }
58         uint256 temp = value;
59         uint256 length = 0;
60         while (temp != 0) {
61             length++;
62             temp >>= 8;
63         }
64         return toHexString(value, length);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
69      */
70     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
71         bytes memory buffer = new bytes(2 * length + 2);
72         buffer[0] = "0";
73         buffer[1] = "x";
74         for (uint256 i = 2 * length + 1; i > 1; --i) {
75             buffer[i] = _HEX_SYMBOLS[value & 0xf];
76             value >>= 4;
77         }
78         require(value == 0, "Strings: hex length insufficient");
79         return string(buffer);
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Context.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/utils/Address.sol
111 
112 
113 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
114 
115 pragma solidity ^0.8.1;
116 
117 /**
118  * @dev Collection of functions related to the address type
119  */
120 library Address {
121     /**
122      * @dev Returns true if `account` is a contract.
123      *
124      * [IMPORTANT]
125      * ====
126      * It is unsafe to assume that an address for which this function returns
127      * false is an externally-owned account (EOA) and not a contract.
128      *
129      * Among others, `isContract` will return false for the following
130      * types of addresses:
131      *
132      *  - an externally-owned account
133      *  - a contract in construction
134      *  - an address where a contract will be created
135      *  - an address where a contract lived, but was destroyed
136      * ====
137      *
138      * [IMPORTANT]
139      * ====
140      * You shouldn't rely on `isContract` to protect against flash loan attacks!
141      *
142      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
143      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
144      * constructor.
145      * ====
146      */
147     function isContract(address account) internal view returns (bool) {
148         // This method relies on extcodesize/address.code.length, which returns 0
149         // for contracts in construction, since the code is only stored at the end
150         // of the constructor execution.
151 
152         return account.code.length > 0;
153     }
154 
155     /**
156      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
157      * `recipient`, forwarding all available gas and reverting on errors.
158      *
159      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
160      * of certain opcodes, possibly making contracts go over the 2300 gas limit
161      * imposed by `transfer`, making them unable to receive funds via
162      * `transfer`. {sendValue} removes this limitation.
163      *
164      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
165      *
166      * IMPORTANT: because control is transferred to `recipient`, care must be
167      * taken to not create reentrancy vulnerabilities. Consider using
168      * {ReentrancyGuard} or the
169      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
170      */
171     function sendValue(address payable recipient, uint256 amount) internal {
172         require(address(this).balance >= amount, "Address: insufficient balance");
173 
174         (bool success, ) = recipient.call{value: amount}("");
175         require(success, "Address: unable to send value, recipient may have reverted");
176     }
177 
178     /**
179      * @dev Performs a Solidity function call using a low level `call`. A
180      * plain `call` is an unsafe replacement for a function call: use this
181      * function instead.
182      *
183      * If `target` reverts with a revert reason, it is bubbled up by this
184      * function (like regular Solidity function calls).
185      *
186      * Returns the raw returned data. To convert to the expected return value,
187      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
188      *
189      * Requirements:
190      *
191      * - `target` must be a contract.
192      * - calling `target` with `data` must not revert.
193      *
194      * _Available since v3.1._
195      */
196     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
197         return functionCall(target, data, "Address: low-level call failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
202      * `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         return functionCallWithValue(target, data, 0, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but also transferring `value` wei to `target`.
217      *
218      * Requirements:
219      *
220      * - the calling contract must have an ETH balance of at least `value`.
221      * - the called Solidity function must be `payable`.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value
229     ) internal returns (bytes memory) {
230         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
235      * with `errorMessage` as a fallback revert reason when `target` reverts.
236      *
237      * _Available since v3.1._
238      */
239     function functionCallWithValue(
240         address target,
241         bytes memory data,
242         uint256 value,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         require(address(this).balance >= value, "Address: insufficient balance for call");
246         require(isContract(target), "Address: call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.call{value: value}(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
259         return functionStaticCall(target, data, "Address: low-level static call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a static call.
265      *
266      * _Available since v3.3._
267      */
268     function functionStaticCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal view returns (bytes memory) {
273         require(isContract(target), "Address: static call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.staticcall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a delegate call.
282      *
283      * _Available since v3.4._
284      */
285     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
286         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a delegate call.
292      *
293      * _Available since v3.4._
294      */
295     function functionDelegateCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(isContract(target), "Address: delegate call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.delegatecall(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
308      * revert reason using the provided one.
309      *
310      * _Available since v4.3._
311      */
312     function verifyCallResult(
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal pure returns (bytes memory) {
317         if (success) {
318             return returndata;
319         } else {
320             // Look for revert reason and bubble it up if present
321             if (returndata.length > 0) {
322                 // The easiest way to bubble the revert reason is using memory via assembly
323 
324                 assembly {
325                     let returndata_size := mload(returndata)
326                     revert(add(32, returndata), returndata_size)
327                 }
328             } else {
329                 revert(errorMessage);
330             }
331         }
332     }
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @title ERC721 token receiver interface
344  * @dev Interface for any contract that wants to support safeTransfers
345  * from ERC721 asset contracts.
346  */
347 interface IERC721Receiver {
348     /**
349      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
350      * by `operator` from `from`, this function is called.
351      *
352      * It must return its Solidity selector to confirm the token transfer.
353      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
354      *
355      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
356      */
357     function onERC721Received(
358         address operator,
359         address from,
360         uint256 tokenId,
361         bytes calldata data
362     ) external returns (bytes4);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @dev Interface of the ERC165 standard, as defined in the
374  * https://eips.ethereum.org/EIPS/eip-165[EIP].
375  *
376  * Implementers can declare support of contract interfaces, which can then be
377  * queried by others ({ERC165Checker}).
378  *
379  * For an implementation, see {ERC165}.
380  */
381 interface IERC165 {
382     /**
383      * @dev Returns true if this contract implements the interface defined by
384      * `interfaceId`. See the corresponding
385      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
386      * to learn more about how these ids are created.
387      *
388      * This function call must use less than 30 000 gas.
389      */
390     function supportsInterface(bytes4 interfaceId) external view returns (bool);
391 }
392 
393 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Implementation of the {IERC165} interface.
403  *
404  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
405  * for the additional interface id that will be supported. For example:
406  *
407  * ```solidity
408  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
410  * }
411  * ```
412  *
413  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
414  */
415 abstract contract ERC165 is IERC165 {
416     /**
417      * @dev See {IERC165-supportsInterface}.
418      */
419     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420         return interfaceId == type(IERC165).interfaceId;
421     }
422 }
423 
424 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
425 
426 
427 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
428 
429 pragma solidity ^0.8.0;
430 
431 
432 /**
433  * @dev Required interface of an ERC721 compliant contract.
434  */
435 interface IERC721 is IERC165 {
436     /**
437      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
438      */
439     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
440 
441     /**
442      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
443      */
444     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
445 
446     /**
447      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
448      */
449     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
450 
451     /**
452      * @dev Returns the number of tokens in ``owner``'s account.
453      */
454     function balanceOf(address owner) external view returns (uint256 balance);
455 
456     /**
457      * @dev Returns the owner of the `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function ownerOf(uint256 tokenId) external view returns (address owner);
464 
465     /**
466      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
467      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
468      *
469      * Requirements:
470      *
471      * - `from` cannot be the zero address.
472      * - `to` cannot be the zero address.
473      * - `tokenId` token must exist and be owned by `from`.
474      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
476      *
477      * Emits a {Transfer} event.
478      */
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 tokenId
483     ) external;
484 
485     /**
486      * @dev Transfers `tokenId` token from `from` to `to`.
487      *
488      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must be owned by `from`.
495      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
496      *
497      * Emits a {Transfer} event.
498      */
499     function transferFrom(
500         address from,
501         address to,
502         uint256 tokenId
503     ) external;
504 
505     /**
506      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
507      * The approval is cleared when the token is transferred.
508      *
509      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
510      *
511      * Requirements:
512      *
513      * - The caller must own the token or be an approved operator.
514      * - `tokenId` must exist.
515      *
516      * Emits an {Approval} event.
517      */
518     function approve(address to, uint256 tokenId) external;
519 
520     /**
521      * @dev Returns the account approved for `tokenId` token.
522      *
523      * Requirements:
524      *
525      * - `tokenId` must exist.
526      */
527     function getApproved(uint256 tokenId) external view returns (address operator);
528 
529     /**
530      * @dev Approve or remove `operator` as an operator for the caller.
531      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
532      *
533      * Requirements:
534      *
535      * - The `operator` cannot be the caller.
536      *
537      * Emits an {ApprovalForAll} event.
538      */
539     function setApprovalForAll(address operator, bool _approved) external;
540 
541     /**
542      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
543      *
544      * See {setApprovalForAll}
545      */
546     function isApprovedForAll(address owner, address operator) external view returns (bool);
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must exist and be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
558      *
559      * Emits a {Transfer} event.
560      */
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId,
565         bytes calldata data
566     ) external;
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Metadata is IERC721 {
582     /**
583      * @dev Returns the token collection name.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594      */
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 // File: contracts/new.sol
599 
600 
601 
602 
603 pragma solidity ^0.8.4;
604 
605 
606 
607 
608 
609 
610 
611 
612 error ApprovalCallerNotOwnerNorApproved();
613 error ApprovalQueryForNonexistentToken();
614 error ApproveToCaller();
615 error ApprovalToCurrentOwner();
616 error BalanceQueryForZeroAddress();
617 error MintToZeroAddress();
618 error MintZeroQuantity();
619 error OwnerQueryForNonexistentToken();
620 error TransferCallerNotOwnerNorApproved();
621 error TransferFromIncorrectOwner();
622 error TransferToNonERC721ReceiverImplementer();
623 error TransferToZeroAddress();
624 error URIQueryForNonexistentToken();
625 
626 /**
627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
628  * the Metadata extension. Built to optimize for lower gas during batch mints.
629  *
630  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
631  *
632  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
633  *
634  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
635  */
636 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
637     using Address for address;
638     using Strings for uint256;
639 
640     // Compiler will pack this into a single 256bit word.
641     struct TokenOwnership {
642         // The address of the owner.
643         address addr;
644         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
645         uint64 startTimestamp;
646         // Whether the token has been burned.
647         bool burned;
648     }
649 
650     // Compiler will pack this into a single 256bit word.
651     struct AddressData {
652         // Realistically, 2**64-1 is more than enough.
653         uint64 balance;
654         // Keeps track of mint count with minimal overhead for tokenomics.
655         uint64 numberMinted;
656         // Keeps track of burn count with minimal overhead for tokenomics.
657         uint64 numberBurned;
658         // For miscellaneous variable(s) pertaining to the address
659         // (e.g. number of whitelist mint slots used).
660         // If there are multiple variables, please pack them into a uint64.
661         uint64 aux;
662     }
663 
664     // The tokenId of the next token to be minted.
665     uint256 internal _currentIndex;
666 
667     // The number of tokens burned.
668     uint256 internal _burnCounter;
669 
670     // Token name
671     string private _name;
672 
673     // Token symbol
674     string private _symbol;
675 
676     // Mapping from token ID to ownership details
677     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
678     mapping(uint256 => TokenOwnership) internal _ownerships;
679 
680     // Mapping owner address to address data
681     mapping(address => AddressData) private _addressData;
682 
683     // Mapping from token ID to approved address
684     mapping(uint256 => address) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692         _currentIndex = _startTokenId();
693     }
694 
695     /**
696      * To change the starting tokenId, please override this function.
697      */
698     function _startTokenId() internal view virtual returns (uint256) {
699         return 1;
700     }
701 
702     /**
703      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
704      */
705     function totalSupply() public view returns (uint256) {
706         // Counter underflow is impossible as _burnCounter cannot be incremented
707         // more than _currentIndex - _startTokenId() times
708         unchecked {
709             return _currentIndex - _burnCounter - _startTokenId();
710         }
711     }
712 
713     /**
714      * Returns the total amount of tokens minted in the contract.
715      */
716     function _totalMinted() internal view returns (uint256) {
717         // Counter underflow is impossible as _currentIndex does not decrement,
718         // and it is initialized to _startTokenId()
719         unchecked {
720             return _currentIndex - _startTokenId();
721         }
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             super.supportsInterface(interfaceId);
732     }
733 
734     /**
735      * @dev See {IERC721-balanceOf}.
736      */
737     function balanceOf(address owner) public view override returns (uint256) {
738         if (owner == address(0)) revert BalanceQueryForZeroAddress();
739         return uint256(_addressData[owner].balance);
740     }
741 
742     /**
743      * Returns the number of tokens minted by `owner`.
744      */
745     function _numberMinted(address owner) internal view returns (uint256) {
746         return uint256(_addressData[owner].numberMinted);
747     }
748 
749     /**
750      * Returns the number of tokens burned by or on behalf of `owner`.
751      */
752     function _numberBurned(address owner) internal view returns (uint256) {
753         return uint256(_addressData[owner].numberBurned);
754     }
755 
756     /**
757      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
758      */
759     function _getAux(address owner) internal view returns (uint64) {
760         return _addressData[owner].aux;
761     }
762 
763     /**
764      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
765      * If there are multiple variables, please pack them into a uint64.
766      */
767     function _setAux(address owner, uint64 aux) internal {
768         _addressData[owner].aux = aux;
769     }
770 
771     /**
772      * Gas spent here starts off proportional to the maximum mint batch size.
773      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
774      */
775     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
776         uint256 curr = tokenId;
777 
778         unchecked {
779             if (_startTokenId() <= curr && curr < _currentIndex) {
780                 TokenOwnership memory ownership = _ownerships[curr];
781                 if (!ownership.burned) {
782                     if (ownership.addr != address(0)) {
783                         return ownership;
784                     }
785                     // Invariant:
786                     // There will always be an ownership that has an address and is not burned
787                     // before an ownership that does not have an address and is not burned.
788                     // Hence, curr will not underflow.
789                     while (true) {
790                         curr--;
791                         ownership = _ownerships[curr];
792                         if (ownership.addr != address(0)) {
793                             return ownership;
794                         }
795                     }
796                 }
797             }
798         }
799         revert OwnerQueryForNonexistentToken();
800     }
801 
802     /**
803      * @dev See {IERC721-ownerOf}.
804      */
805     function ownerOf(uint256 tokenId) public view override returns (address) {
806         return _ownershipOf(tokenId).addr;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-name}.
811      */
812     function name() public view virtual override returns (string memory) {
813         return _name;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-symbol}.
818      */
819     function symbol() public view virtual override returns (string memory) {
820         return _symbol;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-tokenURI}.
825      */
826     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
827         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
828 
829         string memory baseURI = _baseURI();
830         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
831     }
832 
833     /**
834      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
835      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
836      * by default, can be overriden in child contracts.
837      */
838     function _baseURI() internal view virtual returns (string memory) {
839         return '';
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public override {
846         address owner = ERC721A.ownerOf(tokenId);
847         if (to == owner) revert ApprovalToCurrentOwner();
848 
849         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
850             revert ApprovalCallerNotOwnerNorApproved();
851         }
852 
853         _approve(to, tokenId, owner);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view override returns (address) {
860         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public virtual override {
869         if (operator == _msgSender()) revert ApproveToCaller();
870 
871         _operatorApprovals[_msgSender()][operator] = approved;
872         emit ApprovalForAll(_msgSender(), operator, approved);
873     }
874 
875     /**
876      * @dev See {IERC721-isApprovedForAll}.
877      */
878     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
879         return _operatorApprovals[owner][operator];
880     }
881 
882     /**
883      * @dev See {IERC721-transferFrom}.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         _transfer(from, to, tokenId);
914         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
915             revert TransferToNonERC721ReceiverImplementer();
916         }
917     }
918 
919     /**
920      * @dev Returns whether `tokenId` exists.
921      *
922      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
923      *
924      * Tokens start existing when they are minted (`_mint`),
925      */
926     function _exists(uint256 tokenId) internal view returns (bool) {
927         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
928             !_ownerships[tokenId].burned;
929     }
930 
931     function _safeMint(address to, uint256 quantity) internal {
932         _safeMint(to, quantity, '');
933     }
934 
935     /**
936      * @dev Safely mints `quantity` tokens and transfers them to `to`.
937      *
938      * Requirements:
939      *
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeMint(
946         address to,
947         uint256 quantity,
948         bytes memory _data
949     ) internal {
950         _mint(to, quantity, _data, true);
951     }
952 
953     /**
954      * @dev Mints `quantity` tokens and transfers them to `to`.
955      *
956      * Requirements:
957      *
958      * - `to` cannot be the zero address.
959      * - `quantity` must be greater than 0.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _mint(
964         address to,
965         uint256 quantity,
966         bytes memory _data,
967         bool safe
968     ) internal {
969         uint256 startTokenId = _currentIndex;
970         if (to == address(0)) revert MintToZeroAddress();
971         if (quantity == 0) revert MintZeroQuantity();
972 
973         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
974 
975         // Overflows are incredibly unrealistic.
976         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
977         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
978         unchecked {
979             _addressData[to].balance += uint64(quantity);
980             _addressData[to].numberMinted += uint64(quantity);
981 
982             _ownerships[startTokenId].addr = to;
983             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
984 
985             uint256 updatedIndex = startTokenId;
986             uint256 end = updatedIndex + quantity;
987 
988             if (safe && to.isContract()) {
989                 do {
990                     emit Transfer(address(0), to, updatedIndex);
991                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
992                         revert TransferToNonERC721ReceiverImplementer();
993                     }
994                 } while (updatedIndex != end);
995                 // Reentrancy protection
996                 if (_currentIndex != startTokenId) revert();
997             } else {
998                 do {
999                     emit Transfer(address(0), to, updatedIndex++);
1000                 } while (updatedIndex != end);
1001             }
1002             _currentIndex = updatedIndex;
1003         }
1004         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1005     }
1006 
1007     /**
1008      * @dev Transfers `tokenId` from `from` to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) private {
1022         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1023 
1024         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1025 
1026         bool isApprovedOrOwner = (_msgSender() == from ||
1027             isApprovedForAll(from, _msgSender()) ||
1028             getApproved(tokenId) == _msgSender());
1029 
1030         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1031         if (to == address(0)) revert TransferToZeroAddress();
1032 
1033         _beforeTokenTransfers(from, to, tokenId, 1);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId, from);
1037 
1038         // Underflow of the sender's balance is impossible because we check for
1039         // ownership above and the recipient's balance can't realistically overflow.
1040         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1041         unchecked {
1042             _addressData[from].balance -= 1;
1043             _addressData[to].balance += 1;
1044 
1045             TokenOwnership storage currSlot = _ownerships[tokenId];
1046             currSlot.addr = to;
1047             currSlot.startTimestamp = uint64(block.timestamp);
1048 
1049             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1050             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1051             uint256 nextTokenId = tokenId + 1;
1052             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1053             if (nextSlot.addr == address(0)) {
1054                 // This will suffice for checking _exists(nextTokenId),
1055                 // as a burned slot cannot contain the zero address.
1056                 if (nextTokenId != _currentIndex) {
1057                     nextSlot.addr = from;
1058                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1059                 }
1060             }
1061         }
1062 
1063         emit Transfer(from, to, tokenId);
1064         _afterTokenTransfers(from, to, tokenId, 1);
1065     }
1066 
1067     /**
1068      * @dev This is equivalent to _burn(tokenId, false)
1069      */
1070     function _burn(uint256 tokenId) internal virtual {
1071         _burn(tokenId, false);
1072     }
1073 
1074     /**
1075      * @dev Destroys `tokenId`.
1076      * The approval is cleared when the token is burned.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1085         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1086 
1087         address from = prevOwnership.addr;
1088 
1089         if (approvalCheck) {
1090             bool isApprovedOrOwner = (_msgSender() == from ||
1091                 isApprovedForAll(from, _msgSender()) ||
1092                 getApproved(tokenId) == _msgSender());
1093 
1094             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1095         }
1096 
1097         _beforeTokenTransfers(from, address(0), tokenId, 1);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId, from);
1101 
1102         // Underflow of the sender's balance is impossible because we check for
1103         // ownership above and the recipient's balance can't realistically overflow.
1104         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1105         unchecked {
1106             AddressData storage addressData = _addressData[from];
1107             addressData.balance -= 1;
1108             addressData.numberBurned += 1;
1109 
1110             // Keep track of who burned the token, and the timestamp of burning.
1111             TokenOwnership storage currSlot = _ownerships[tokenId];
1112             currSlot.addr = from;
1113             currSlot.startTimestamp = uint64(block.timestamp);
1114             currSlot.burned = true;
1115 
1116             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1117             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1118             uint256 nextTokenId = tokenId + 1;
1119             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1120             if (nextSlot.addr == address(0)) {
1121                 // This will suffice for checking _exists(nextTokenId),
1122                 // as a burned slot cannot contain the zero address.
1123                 if (nextTokenId != _currentIndex) {
1124                     nextSlot.addr = from;
1125                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1126                 }
1127             }
1128         }
1129 
1130         emit Transfer(from, address(0), tokenId);
1131         _afterTokenTransfers(from, address(0), tokenId, 1);
1132 
1133         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1134         unchecked {
1135             _burnCounter++;
1136         }
1137     }
1138 
1139     /**
1140      * @dev Approve `to` to operate on `tokenId`
1141      *
1142      * Emits a {Approval} event.
1143      */
1144     function _approve(
1145         address to,
1146         uint256 tokenId,
1147         address owner
1148     ) private {
1149         _tokenApprovals[tokenId] = to;
1150         emit Approval(owner, to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1155      *
1156      * @param from address representing the previous owner of the given token ID
1157      * @param to target address that will receive the tokens
1158      * @param tokenId uint256 ID of the token to be transferred
1159      * @param _data bytes optional data to send along with the call
1160      * @return bool whether the call correctly returned the expected magic value
1161      */
1162     function _checkContractOnERC721Received(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) private returns (bool) {
1168         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1169             return retval == IERC721Receiver(to).onERC721Received.selector;
1170         } catch (bytes memory reason) {
1171             if (reason.length == 0) {
1172                 revert TransferToNonERC721ReceiverImplementer();
1173             } else {
1174                 assembly {
1175                     revert(add(32, reason), mload(reason))
1176                 }
1177             }
1178         }
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1183      * And also called before burning one token.
1184      *
1185      * startTokenId - the first token id to be transferred
1186      * quantity - the amount to be transferred
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` will be minted for `to`.
1193      * - When `to` is zero, `tokenId` will be burned by `from`.
1194      * - `from` and `to` are never both zero.
1195      */
1196     function _beforeTokenTransfers(
1197         address from,
1198         address to,
1199         uint256 startTokenId,
1200         uint256 quantity
1201     ) internal virtual {}
1202 
1203     /**
1204      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1205      * minting.
1206      * And also called after one token has been burned.
1207      *
1208      * startTokenId - the first token id to be transferred
1209      * quantity - the amount to be transferred
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` has been minted for `to`.
1216      * - When `to` is zero, `tokenId` has been burned by `from`.
1217      * - `from` and `to` are never both zero.
1218      */
1219     function _afterTokenTransfers(
1220         address from,
1221         address to,
1222         uint256 startTokenId,
1223         uint256 quantity
1224     ) internal virtual {}
1225 }
1226 
1227 abstract contract Ownable is Context {
1228     address private _owner;
1229 
1230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1231 
1232     /**
1233      * @dev Initializes the contract setting the deployer as the initial owner.
1234      */
1235     constructor() {
1236         _transferOwnership(_msgSender());
1237     }
1238 
1239     /**
1240      * @dev Returns the address of the current owner.
1241      */
1242     function owner() public view virtual returns (address) {
1243         return _owner;
1244     }
1245 
1246     /**
1247      * @dev Throws if called by any account other than the owner.
1248      */
1249     modifier onlyOwner() {
1250         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1251         _;
1252     }
1253 
1254     /**
1255      * @dev Leaves the contract without owner. It will not be possible to call
1256      * `onlyOwner` functions anymore. Can only be called by the current owner.
1257      *
1258      * NOTE: Renouncing ownership will leave the contract without an owner,
1259      * thereby removing any functionality that is only available to the owner.
1260      */
1261     function renounceOwnership() public virtual onlyOwner {
1262         _transferOwnership(address(0));
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Can only be called by the current owner.
1268      */
1269     function transferOwnership(address newOwner) public virtual onlyOwner {
1270         require(newOwner != address(0), "Ownable: new owner is the zero address");
1271         _transferOwnership(newOwner);
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Internal function without access restriction.
1277      */
1278     function _transferOwnership(address newOwner) internal virtual {
1279         address oldOwner = _owner;
1280         _owner = newOwner;
1281         emit OwnershipTransferred(oldOwner, newOwner);
1282     }
1283 }
1284 pragma solidity ^0.8.13;
1285 
1286 interface IOperatorFilterRegistry {
1287     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1288     function register(address registrant) external;
1289     function registerAndSubscribe(address registrant, address subscription) external;
1290     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1291     function updateOperator(address registrant, address operator, bool filtered) external;
1292     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1293     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1294     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1295     function subscribe(address registrant, address registrantToSubscribe) external;
1296     function unsubscribe(address registrant, bool copyExistingEntries) external;
1297     function subscriptionOf(address addr) external returns (address registrant);
1298     function subscribers(address registrant) external returns (address[] memory);
1299     function subscriberAt(address registrant, uint256 index) external returns (address);
1300     function copyEntriesOf(address registrant, address registrantToCopy) external;
1301     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1302     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1303     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1304     function filteredOperators(address addr) external returns (address[] memory);
1305     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1306     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1307     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1308     function isRegistered(address addr) external returns (bool);
1309     function codeHashOf(address addr) external returns (bytes32);
1310 }
1311 
1312 abstract contract OperatorFilterer {
1313     error OperatorNotAllowed(address operator);
1314 
1315     IOperatorFilterRegistry constant operatorFilterRegistry =
1316         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1317 
1318     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1319         if (address(operatorFilterRegistry).code.length > 0) {
1320             if (subscribe) {
1321                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1322             } else {
1323                 if (subscriptionOrRegistrantToCopy != address(0)) {
1324                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1325                 } else {
1326                     operatorFilterRegistry.register(address(this));
1327                 }
1328             }
1329         }
1330     }
1331 
1332     modifier onlyAllowedOperator(address from) virtual {
1333         if (address(operatorFilterRegistry).code.length > 0) {
1334             if (from == msg.sender) {
1335                 _;
1336                 return;
1337             }
1338             if (
1339                 !(
1340                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1341                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1342                 )
1343             ) {
1344                 revert OperatorNotAllowed(msg.sender);
1345             }
1346         }
1347         _;
1348     }
1349 }
1350 
1351 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1352     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1353 
1354     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1355 }
1356 
1357 contract DumpsterRatz is ERC721A, DefaultOperatorFilterer, Ownable {
1358     using Strings for uint256;
1359 
1360     string private uriPrefix;
1361     string private uriSuffix = ".json";
1362     string public hiddenURL;
1363 
1364     uint256 public cost = 0.003 ether;
1365     uint16 public maxSupply = 8000;
1366     uint8 public maxMintAmountPerTx = 10;
1367     uint8 public maxFreeMintAmountPerWallet = 1;
1368     uint8 public maxPerWallet = 50; 
1369 
1370     bool public paused = true;
1371     bool public reveal = false;
1372 
1373     mapping(address => uint8) public nftPerPublicAddress;
1374 
1375     constructor() ERC721A("DumpsterRatz", "DRATZ") {}
1376 
1377     function mint(uint8 _mintAmount) external payable {
1378         uint16 totalSupply = uint16(totalSupply());
1379         uint8 nft = nftPerPublicAddress[msg.sender];
1380         require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1381         require(_mintAmount <= maxMintAmountPerTx, "Exceeds max per transaction.");
1382         require(!paused, "The contract is paused!");
1383 
1384         if (nft >= maxFreeMintAmountPerWallet) {
1385             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1386         } else {
1387             uint8 costAmount = _mintAmount + nft;
1388             if (costAmount > maxFreeMintAmountPerWallet) {
1389                 costAmount = costAmount - maxFreeMintAmountPerWallet;
1390                 require(msg.value >= cost * costAmount, "Insufficient funds!");
1391             }
1392         }
1393 
1394         require(nft + _mintAmount <= maxPerWallet, "Exceeds max per wallet."); // Check max per wallet limit
1395 
1396         _safeMint(msg.sender, _mintAmount);
1397 
1398         nftPerPublicAddress[msg.sender] = _mintAmount + nft;
1399         delete totalSupply;
1400         delete _mintAmount;
1401     }
1402   
1403   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1404      uint16 totalSupply = uint16(totalSupply());
1405     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1406      _safeMint(_receiver , _mintAmount);
1407      delete _mintAmount;
1408      delete _receiver;
1409      delete totalSupply;
1410   }
1411 
1412   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1413      uint16 totalSupply = uint16(totalSupply());
1414      uint totalAmount =   _amountPerAddress * addresses.length;
1415     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1416      for (uint256 i = 0; i < addresses.length; i++) {
1417             _safeMint(addresses[i], _amountPerAddress);
1418         }
1419 
1420      delete _amountPerAddress;
1421      delete totalSupply;
1422   }
1423 
1424  
1425 
1426   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1427       maxSupply = _maxSupply;
1428   }
1429 
1430 
1431 
1432    
1433   function tokenURI(uint256 _tokenId)
1434     public
1435     view
1436     virtual
1437     override
1438     returns (string memory)
1439   {
1440     require(
1441       _exists(_tokenId),
1442       "ERC721Metadata: URI query for nonexistent token"
1443     );
1444     
1445   
1446 if ( reveal == false)
1447 {
1448     return hiddenURL;
1449 }
1450     
1451 
1452     string memory currentBaseURI = _baseURI();
1453     return bytes(currentBaseURI).length > 0
1454         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1455         : "";
1456   }
1457  
1458  
1459 
1460 
1461  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1462     maxFreeMintAmountPerWallet = _limit;
1463    delete _limit;
1464 
1465 }
1466 
1467     
1468   
1469 
1470   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1471     uriPrefix = _uriPrefix;
1472   }
1473    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1474     hiddenURL = _uriPrefix;
1475   }
1476 
1477 
1478   function setPaused() external onlyOwner {
1479     paused = !paused;
1480    
1481   }
1482 
1483   function setCost(uint _cost) external onlyOwner{
1484       cost = _cost;
1485 
1486   }
1487 
1488  function setRevealed() external onlyOwner{
1489      reveal = !reveal;
1490  }
1491 
1492   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1493       maxMintAmountPerTx = _maxtx;
1494 
1495   }
1496 
1497  
1498 
1499   function withdraw() external onlyOwner {
1500   uint _balance = address(this).balance;
1501      payable(msg.sender).transfer(_balance ); 
1502        
1503   }
1504 
1505 
1506   function _baseURI() internal view  override returns (string memory) {
1507     return uriPrefix;
1508   }
1509 
1510     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1511         super.transferFrom(from, to, tokenId);
1512     }
1513 
1514     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1515         super.safeTransferFrom(from, to, tokenId);
1516     }
1517 
1518     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1519         public
1520         override
1521         onlyAllowedOperator(from)
1522     {
1523         super.safeTransferFrom(from, to, tokenId, data);
1524     }
1525 }