1 /**
2 
3                                                                                                                                    
4 ,-----.                          ,--.      ,---.                    ,--.   ,--.                         ,-----.,--.        ,--.    
5 |  |) /_  ,---. ,--.--. ,---.  ,-|  |     /  O  \  ,---.  ,---.      \  `.'  /,---.  ,---.  ,--,--.    '  .--./|  |,--.,--.|  |-.  
6 |  .-.  \| .-. ||  .--'| .-. :' .-. |    |  .-.  || .-. || .-. :      '.    /| .-. || .-. |' ,-.  |    |  |    |  ||  ||  || .-. ' 
7 |  '--' /' '-' '|  |   \   --.\ `-' |    |  | |  || '-' '\   --.        |  | ' '-' '' '-' '\ '-'  |    '  '--'\|  |'  ''  '| `-' | 
8 `------'  `---' `--'    `----' `---'     `--' `--'|  |-'  `----'        `--'  `---' .`-  /  `--`--'     `-----'`--' `----'  `---'  
9                                                   `--'                              `---'                                          
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Context.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Address.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
115 
116 pragma solidity ^0.8.1;
117 
118 /**
119  * @dev Collection of functions related to the address type
120  */
121 library Address {
122     /**
123      * @dev Returns true if `account` is a contract.
124      *
125      * [IMPORTANT]
126      * ====
127      * It is unsafe to assume that an address for which this function returns
128      * false is an externally-owned account (EOA) and not a contract.
129      *
130      * Among others, `isContract` will return false for the following
131      * types of addresses:
132      *
133      *  - an externally-owned account
134      *  - a contract in construction
135      *  - an address where a contract will be created
136      *  - an address where a contract lived, but was destroyed
137      * ====
138      *
139      * [IMPORTANT]
140      * ====
141      * You shouldn't rely on `isContract` to protect against flash loan attacks!
142      *
143      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
144      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
145      * constructor.
146      * ====
147      */
148     function isContract(address account) internal view returns (bool) {
149         // This method relies on extcodesize/address.code.length, which returns 0
150         // for contracts in construction, since the code is only stored at the end
151         // of the constructor execution.
152 
153         return account.code.length > 0;
154     }
155 
156     /**
157      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
158      * `recipient`, forwarding all available gas and reverting on errors.
159      *
160      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161      * of certain opcodes, possibly making contracts go over the 2300 gas limit
162      * imposed by `transfer`, making them unable to receive funds via
163      * `transfer`. {sendValue} removes this limitation.
164      *
165      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166      *
167      * IMPORTANT: because control is transferred to `recipient`, care must be
168      * taken to not create reentrancy vulnerabilities. Consider using
169      * {ReentrancyGuard} or the
170      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171      */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionCall(target, data, "Address: low-level call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
203      * `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but also transferring `value` wei to `target`.
218      *
219      * Requirements:
220      *
221      * - the calling contract must have an ETH balance of at least `value`.
222      * - the called Solidity function must be `payable`.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
236      * with `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         require(isContract(target), "Address: call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.staticcall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(isContract(target), "Address: delegate call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.delegatecall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324 
325                 assembly {
326                     let returndata_size := mload(returndata)
327                     revert(add(32, returndata), returndata_size)
328                 }
329             } else {
330                 revert(errorMessage);
331             }
332         }
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @title ERC721 token receiver interface
345  * @dev Interface for any contract that wants to support safeTransfers
346  * from ERC721 asset contracts.
347  */
348 interface IERC721Receiver {
349     /**
350      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
351      * by `operator` from `from`, this function is called.
352      *
353      * It must return its Solidity selector to confirm the token transfer.
354      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
355      *
356      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
357      */
358     function onERC721Received(
359         address operator,
360         address from,
361         uint256 tokenId,
362         bytes calldata data
363     ) external returns (bytes4);
364 }
365 
366 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Interface of the ERC165 standard, as defined in the
375  * https://eips.ethereum.org/EIPS/eip-165[EIP].
376  *
377  * Implementers can declare support of contract interfaces, which can then be
378  * queried by others ({ERC165Checker}).
379  *
380  * For an implementation, see {ERC165}.
381  */
382 interface IERC165 {
383     /**
384      * @dev Returns true if this contract implements the interface defined by
385      * `interfaceId`. See the corresponding
386      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
387      * to learn more about how these ids are created.
388      *
389      * This function call must use less than 30 000 gas.
390      */
391     function supportsInterface(bytes4 interfaceId) external view returns (bool);
392 }
393 
394 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Implementation of the {IERC165} interface.
404  *
405  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
406  * for the additional interface id that will be supported. For example:
407  *
408  * ```solidity
409  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
411  * }
412  * ```
413  *
414  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
415  */
416 abstract contract ERC165 is IERC165 {
417     /**
418      * @dev See {IERC165-supportsInterface}.
419      */
420     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421         return interfaceId == type(IERC165).interfaceId;
422     }
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Required interface of an ERC721 compliant contract.
435  */
436 interface IERC721 is IERC165 {
437     /**
438      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
439      */
440     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
441 
442     /**
443      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
444      */
445     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
446 
447     /**
448      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
449      */
450     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
451 
452     /**
453      * @dev Returns the number of tokens in ``owner``'s account.
454      */
455     function balanceOf(address owner) external view returns (uint256 balance);
456 
457     /**
458      * @dev Returns the owner of the `tokenId` token.
459      *
460      * Requirements:
461      *
462      * - `tokenId` must exist.
463      */
464     function ownerOf(uint256 tokenId) external view returns (address owner);
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
468      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must exist and be owned by `from`.
475      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
477      *
478      * Emits a {Transfer} event.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Transfers `tokenId` token from `from` to `to`.
488      *
489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
508      * The approval is cleared when the token is transferred.
509      *
510      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
511      *
512      * Requirements:
513      *
514      * - The caller must own the token or be an approved operator.
515      * - `tokenId` must exist.
516      *
517      * Emits an {Approval} event.
518      */
519     function approve(address to, uint256 tokenId) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Approve or remove `operator` as an operator for the caller.
532      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
533      *
534      * Requirements:
535      *
536      * - The `operator` cannot be the caller.
537      *
538      * Emits an {ApprovalForAll} event.
539      */
540     function setApprovalForAll(address operator, bool _approved) external;
541 
542     /**
543      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
544      *
545      * See {setApprovalForAll}
546      */
547     function isApprovedForAll(address owner, address operator) external view returns (bool);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes calldata data
567     ) external;
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
580  * @dev See https://eips.ethereum.org/EIPS/eip-721
581  */
582 interface IERC721Metadata is IERC721 {
583     /**
584      * @dev Returns the token collection name.
585      */
586     function name() external view returns (string memory);
587 
588     /**
589      * @dev Returns the token collection symbol.
590      */
591     function symbol() external view returns (string memory);
592 
593     /**
594      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
595      */
596     function tokenURI(uint256 tokenId) external view returns (string memory);
597 }
598 
599 // File: contracts/new.sol
600 
601 
602 
603 
604 pragma solidity ^0.8.4;
605 
606 
607 
608 
609 
610 
611 
612 
613 error ApprovalCallerNotOwnerNorApproved();
614 error ApprovalQueryForNonexistentToken();
615 error ApproveToCaller();
616 error ApprovalToCurrentOwner();
617 error BalanceQueryForZeroAddress();
618 error MintToZeroAddress();
619 error MintZeroQuantity();
620 error OwnerQueryForNonexistentToken();
621 error TransferCallerNotOwnerNorApproved();
622 error TransferFromIncorrectOwner();
623 error TransferToNonERC721ReceiverImplementer();
624 error TransferToZeroAddress();
625 error URIQueryForNonexistentToken();
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata extension. Built to optimize for lower gas during batch mints.
630  *
631  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
632  *
633  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
634  *
635  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
636  */
637 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
638     using Address for address;
639     using Strings for uint256;
640 
641     // Compiler will pack this into a single 256bit word.
642     struct TokenOwnership {
643         // The address of the owner.
644         address addr;
645         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
646         uint64 startTimestamp;
647         // Whether the token has been burned.
648         bool burned;
649     }
650 
651     // Compiler will pack this into a single 256bit word.
652     struct AddressData {
653         // Realistically, 2**64-1 is more than enough.
654         uint64 balance;
655         // Keeps track of mint count with minimal overhead for tokenomics.
656         uint64 numberMinted;
657         // Keeps track of burn count with minimal overhead for tokenomics.
658         uint64 numberBurned;
659         // For miscellaneous variable(s) pertaining to the address
660         // (e.g. number of whitelist mint slots used).
661         // If there are multiple variables, please pack them into a uint64.
662         uint64 aux;
663     }
664 
665     // The tokenId of the next token to be minted.
666     uint256 internal _currentIndex;
667 
668     // The number of tokens burned.
669     uint256 internal _burnCounter;
670 
671     // Token name
672     string private _name;
673 
674     // Token symbol
675     string private _symbol;
676 
677     // Mapping from token ID to ownership details
678     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
679     mapping(uint256 => TokenOwnership) internal _ownerships;
680 
681     // Mapping owner address to address data
682     mapping(address => AddressData) private _addressData;
683 
684     // Mapping from token ID to approved address
685     mapping(uint256 => address) private _tokenApprovals;
686 
687     // Mapping from owner to operator approvals
688     mapping(address => mapping(address => bool)) private _operatorApprovals;
689 
690     constructor(string memory name_, string memory symbol_) {
691         _name = name_;
692         _symbol = symbol_;
693         _currentIndex = _startTokenId();
694     }
695 
696     /**
697      * To change the starting tokenId, please override this function.
698      */
699     function _startTokenId() internal view virtual returns (uint256) {
700         return 0;
701     }
702 
703     /**
704      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
705      */
706     function totalSupply() public view returns (uint256) {
707         // Counter underflow is impossible as _burnCounter cannot be incremented
708         // more than _currentIndex - _startTokenId() times
709         unchecked {
710             return _currentIndex - _burnCounter - _startTokenId();
711         }
712     }
713 
714     /**
715      * Returns the total amount of tokens minted in the contract.
716      */
717     function _totalMinted() internal view returns (uint256) {
718         // Counter underflow is impossible as _currentIndex does not decrement,
719         // and it is initialized to _startTokenId()
720         unchecked {
721             return _currentIndex - _startTokenId();
722         }
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      */
728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
729         return
730             interfaceId == type(IERC721).interfaceId ||
731             interfaceId == type(IERC721Metadata).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view override returns (uint256) {
739         if (owner == address(0)) revert BalanceQueryForZeroAddress();
740         return uint256(_addressData[owner].balance);
741     }
742 
743     /**
744      * Returns the number of tokens minted by `owner`.
745      */
746     function _numberMinted(address owner) internal view returns (uint256) {
747         return uint256(_addressData[owner].numberMinted);
748     }
749 
750     /**
751      * Returns the number of tokens burned by or on behalf of `owner`.
752      */
753     function _numberBurned(address owner) internal view returns (uint256) {
754         return uint256(_addressData[owner].numberBurned);
755     }
756 
757     /**
758      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
759      */
760     function _getAux(address owner) internal view returns (uint64) {
761         return _addressData[owner].aux;
762     }
763 
764     /**
765      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
766      * If there are multiple variables, please pack them into a uint64.
767      */
768     function _setAux(address owner, uint64 aux) internal {
769         _addressData[owner].aux = aux;
770     }
771 
772     /**
773      * Gas spent here starts off proportional to the maximum mint batch size.
774      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
775      */
776     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
777         uint256 curr = tokenId;
778 
779         unchecked {
780             if (_startTokenId() <= curr && curr < _currentIndex) {
781                 TokenOwnership memory ownership = _ownerships[curr];
782                 if (!ownership.burned) {
783                     if (ownership.addr != address(0)) {
784                         return ownership;
785                     }
786                     // Invariant:
787                     // There will always be an ownership that has an address and is not burned
788                     // before an ownership that does not have an address and is not burned.
789                     // Hence, curr will not underflow.
790                     while (true) {
791                         curr--;
792                         ownership = _ownerships[curr];
793                         if (ownership.addr != address(0)) {
794                             return ownership;
795                         }
796                     }
797                 }
798             }
799         }
800         revert OwnerQueryForNonexistentToken();
801     }
802 
803     /**
804      * @dev See {IERC721-ownerOf}.
805      */
806     function ownerOf(uint256 tokenId) public view override returns (address) {
807         return _ownershipOf(tokenId).addr;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-name}.
812      */
813     function name() public view virtual override returns (string memory) {
814         return _name;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-symbol}.
819      */
820     function symbol() public view virtual override returns (string memory) {
821         return _symbol;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-tokenURI}.
826      */
827     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
828         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
829 
830         string memory baseURI = _baseURI();
831         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
832     }
833 
834     /**
835      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
836      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
837      * by default, can be overriden in child contracts.
838      */
839     function _baseURI() internal view virtual returns (string memory) {
840         return '';
841     }
842 
843     /**
844      * @dev See {IERC721-approve}.
845      */
846     function approve(address to, uint256 tokenId) public override {
847         address owner = ERC721A.ownerOf(tokenId);
848         if (to == owner) revert ApprovalToCurrentOwner();
849 
850         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
851             revert ApprovalCallerNotOwnerNorApproved();
852         }
853 
854         _approve(to, tokenId, owner);
855     }
856 
857     /**
858      * @dev See {IERC721-getApproved}.
859      */
860     function getApproved(uint256 tokenId) public view override returns (address) {
861         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
862 
863         return _tokenApprovals[tokenId];
864     }
865 
866     /**
867      * @dev See {IERC721-setApprovalForAll}.
868      */
869     function setApprovalForAll(address operator, bool approved) public virtual override {
870         if (operator == _msgSender()) revert ApproveToCaller();
871 
872         _operatorApprovals[_msgSender()][operator] = approved;
873         emit ApprovalForAll(_msgSender(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-transferFrom}.
885      */
886     function transferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         _transfer(from, to, tokenId);
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) public virtual override {
914         _transfer(from, to, tokenId);
915         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
916             revert TransferToNonERC721ReceiverImplementer();
917         }
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      */
927     function _exists(uint256 tokenId) internal view returns (bool) {
928         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
929             !_ownerships[tokenId].burned;
930     }
931 
932     function _safeMint(address to, uint256 quantity) internal {
933         _safeMint(to, quantity, '');
934     }
935 
936     /**
937      * @dev Safely mints `quantity` tokens and transfers them to `to`.
938      *
939      * Requirements:
940      *
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
942      * - `quantity` must be greater than 0.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeMint(
947         address to,
948         uint256 quantity,
949         bytes memory _data
950     ) internal {
951         _mint(to, quantity, _data, true);
952     }
953 
954     /**
955      * @dev Mints `quantity` tokens and transfers them to `to`.
956      *
957      * Requirements:
958      *
959      * - `to` cannot be the zero address.
960      * - `quantity` must be greater than 0.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _mint(
965         address to,
966         uint256 quantity,
967         bytes memory _data,
968         bool safe
969     ) internal {
970         uint256 startTokenId = _currentIndex;
971         if (to == address(0)) revert MintToZeroAddress();
972         if (quantity == 0) revert MintZeroQuantity();
973 
974         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
975 
976         // Overflows are incredibly unrealistic.
977         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
978         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
979         unchecked {
980             _addressData[to].balance += uint64(quantity);
981             _addressData[to].numberMinted += uint64(quantity);
982 
983             _ownerships[startTokenId].addr = to;
984             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
985 
986             uint256 updatedIndex = startTokenId;
987             uint256 end = updatedIndex + quantity;
988 
989             if (safe && to.isContract()) {
990                 do {
991                     emit Transfer(address(0), to, updatedIndex);
992                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
993                         revert TransferToNonERC721ReceiverImplementer();
994                     }
995                 } while (updatedIndex != end);
996                 // Reentrancy protection
997                 if (_currentIndex != startTokenId) revert();
998             } else {
999                 do {
1000                     emit Transfer(address(0), to, updatedIndex++);
1001                 } while (updatedIndex != end);
1002             }
1003             _currentIndex = updatedIndex;
1004         }
1005         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1006     }
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must be owned by `from`.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _transfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) private {
1023         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1024 
1025         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1026 
1027         bool isApprovedOrOwner = (_msgSender() == from ||
1028             isApprovedForAll(from, _msgSender()) ||
1029             getApproved(tokenId) == _msgSender());
1030 
1031         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1032         if (to == address(0)) revert TransferToZeroAddress();
1033 
1034         _beforeTokenTransfers(from, to, tokenId, 1);
1035 
1036         // Clear approvals from the previous owner
1037         _approve(address(0), tokenId, from);
1038 
1039         // Underflow of the sender's balance is impossible because we check for
1040         // ownership above and the recipient's balance can't realistically overflow.
1041         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1042         unchecked {
1043             _addressData[from].balance -= 1;
1044             _addressData[to].balance += 1;
1045 
1046             TokenOwnership storage currSlot = _ownerships[tokenId];
1047             currSlot.addr = to;
1048             currSlot.startTimestamp = uint64(block.timestamp);
1049 
1050             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1051             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1052             uint256 nextTokenId = tokenId + 1;
1053             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1054             if (nextSlot.addr == address(0)) {
1055                 // This will suffice for checking _exists(nextTokenId),
1056                 // as a burned slot cannot contain the zero address.
1057                 if (nextTokenId != _currentIndex) {
1058                     nextSlot.addr = from;
1059                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1060                 }
1061             }
1062         }
1063 
1064         emit Transfer(from, to, tokenId);
1065         _afterTokenTransfers(from, to, tokenId, 1);
1066     }
1067 
1068     /**
1069      * @dev This is equivalent to _burn(tokenId, false)
1070      */
1071     function _burn(uint256 tokenId) internal virtual {
1072         _burn(tokenId, false);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1086         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1087 
1088         address from = prevOwnership.addr;
1089 
1090         if (approvalCheck) {
1091             bool isApprovedOrOwner = (_msgSender() == from ||
1092                 isApprovedForAll(from, _msgSender()) ||
1093                 getApproved(tokenId) == _msgSender());
1094 
1095             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1096         }
1097 
1098         _beforeTokenTransfers(from, address(0), tokenId, 1);
1099 
1100         // Clear approvals from the previous owner
1101         _approve(address(0), tokenId, from);
1102 
1103         // Underflow of the sender's balance is impossible because we check for
1104         // ownership above and the recipient's balance can't realistically overflow.
1105         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1106         unchecked {
1107             AddressData storage addressData = _addressData[from];
1108             addressData.balance -= 1;
1109             addressData.numberBurned += 1;
1110 
1111             // Keep track of who burned the token, and the timestamp of burning.
1112             TokenOwnership storage currSlot = _ownerships[tokenId];
1113             currSlot.addr = from;
1114             currSlot.startTimestamp = uint64(block.timestamp);
1115             currSlot.burned = true;
1116 
1117             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1118             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1119             uint256 nextTokenId = tokenId + 1;
1120             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1121             if (nextSlot.addr == address(0)) {
1122                 // This will suffice for checking _exists(nextTokenId),
1123                 // as a burned slot cannot contain the zero address.
1124                 if (nextTokenId != _currentIndex) {
1125                     nextSlot.addr = from;
1126                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1127                 }
1128             }
1129         }
1130 
1131         emit Transfer(from, address(0), tokenId);
1132         _afterTokenTransfers(from, address(0), tokenId, 1);
1133 
1134         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1135         unchecked {
1136             _burnCounter++;
1137         }
1138     }
1139 
1140     /**
1141      * @dev Approve `to` to operate on `tokenId`
1142      *
1143      * Emits a {Approval} event.
1144      */
1145     function _approve(
1146         address to,
1147         uint256 tokenId,
1148         address owner
1149     ) private {
1150         _tokenApprovals[tokenId] = to;
1151         emit Approval(owner, to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1156      *
1157      * @param from address representing the previous owner of the given token ID
1158      * @param to target address that will receive the tokens
1159      * @param tokenId uint256 ID of the token to be transferred
1160      * @param _data bytes optional data to send along with the call
1161      * @return bool whether the call correctly returned the expected magic value
1162      */
1163     function _checkContractOnERC721Received(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) private returns (bool) {
1169         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1170             return retval == IERC721Receiver(to).onERC721Received.selector;
1171         } catch (bytes memory reason) {
1172             if (reason.length == 0) {
1173                 revert TransferToNonERC721ReceiverImplementer();
1174             } else {
1175                 assembly {
1176                     revert(add(32, reason), mload(reason))
1177                 }
1178             }
1179         }
1180     }
1181 
1182     /**
1183      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1184      * And also called before burning one token.
1185      *
1186      * startTokenId - the first token id to be transferred
1187      * quantity - the amount to be transferred
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, `tokenId` will be burned by `from`.
1195      * - `from` and `to` are never both zero.
1196      */
1197     function _beforeTokenTransfers(
1198         address from,
1199         address to,
1200         uint256 startTokenId,
1201         uint256 quantity
1202     ) internal virtual {}
1203 
1204     /**
1205      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1206      * minting.
1207      * And also called after one token has been burned.
1208      *
1209      * startTokenId - the first token id to be transferred
1210      * quantity - the amount to be transferred
1211      *
1212      * Calling conditions:
1213      *
1214      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1215      * transferred to `to`.
1216      * - When `from` is zero, `tokenId` has been minted for `to`.
1217      * - When `to` is zero, `tokenId` has been burned by `from`.
1218      * - `from` and `to` are never both zero.
1219      */
1220     function _afterTokenTransfers(
1221         address from,
1222         address to,
1223         uint256 startTokenId,
1224         uint256 quantity
1225     ) internal virtual {}
1226 }
1227 
1228 abstract contract Ownable is Context {
1229     address private _owner;
1230 
1231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1232 
1233     /**
1234      * @dev Initializes the contract setting the deployer as the initial owner.
1235      */
1236     constructor() {
1237         _transferOwnership(_msgSender());
1238     }
1239 
1240     /**
1241      * @dev Returns the address of the current owner.
1242      */
1243     function owner() public view virtual returns (address) {
1244         return _owner;
1245     }
1246 
1247     /**
1248      * @dev Throws if called by any account other than the owner.
1249      */
1250     modifier onlyOwner() {
1251         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1252         _;
1253     }
1254 
1255     /**
1256      * @dev Leaves the contract without owner. It will not be possible to call
1257      * `onlyOwner` functions anymore. Can only be called by the current owner.
1258      *
1259      * NOTE: Renouncing ownership will leave the contract without an owner,
1260      * thereby removing any functionality that is only available to the owner.
1261      */
1262     function renounceOwnership() public virtual onlyOwner {
1263         _transferOwnership(address(0));
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Can only be called by the current owner.
1269      */
1270     function transferOwnership(address newOwner) public virtual onlyOwner {
1271         require(newOwner != address(0), "Ownable: new owner is the zero address");
1272         _transferOwnership(newOwner);
1273     }
1274 
1275     /**
1276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1277      * Internal function without access restriction.
1278      */
1279     function _transferOwnership(address newOwner) internal virtual {
1280         address oldOwner = _owner;
1281         _owner = newOwner;
1282         emit OwnershipTransferred(oldOwner, newOwner);
1283     }
1284 }
1285     pragma solidity ^0.8.7;
1286     
1287     contract BoredApeYogaClub is ERC721A, Ownable {
1288     using Strings for uint256;
1289 
1290 
1291   string private uriPrefix ;
1292   string private uriSuffix = ".json";
1293   string public hiddenURL;
1294 
1295   
1296   
1297 
1298   uint256 public cost = 0.0069 ether;
1299   uint256 public whiteListCost = 0 ;
1300   
1301 
1302   uint16 public maxSupply = 10000;
1303   uint8 public maxMintAmountPerTx = 11;
1304     uint8 public maxFreeMintAmountPerWallet = 1;
1305                                                              
1306   bool public WLpaused = true;
1307   bool public paused = true;
1308   bool public reveal =false;
1309   mapping (address => uint8) public NFTPerWLAddress;
1310    mapping (address => uint8) public NFTPerPublicAddress;
1311   mapping (address => bool) public isWhitelisted;
1312  
1313   
1314   
1315  
1316   
1317 
1318   constructor() ERC721A("Bored Ape Yoga Club", "BAYC") {
1319   }
1320 
1321   
1322  
1323   function mint(uint8 _mintAmount) external payable  {
1324      uint16 totalSupply = uint16(totalSupply());
1325      uint8 nft = NFTPerPublicAddress[msg.sender];
1326     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1327     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1328 
1329     require(!paused, "The contract is paused!");
1330     
1331       if(nft >= maxFreeMintAmountPerWallet)
1332     {
1333     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1334     }
1335     else {
1336          uint8 costAmount = _mintAmount + nft;
1337         if(costAmount > maxFreeMintAmountPerWallet)
1338        {
1339         costAmount = costAmount - maxFreeMintAmountPerWallet;
1340         require(msg.value >= cost * costAmount, "Insufficient funds!");
1341        }
1342        
1343          
1344     }
1345     
1346 
1347 
1348     _safeMint(msg.sender , _mintAmount);
1349 
1350     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1351      
1352      delete totalSupply;
1353      delete _mintAmount;
1354   }
1355   
1356   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1357      uint16 totalSupply = uint16(totalSupply());
1358     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1359      _safeMint(_receiver , _mintAmount);
1360      delete _mintAmount;
1361      delete _receiver;
1362      delete totalSupply;
1363   }
1364 
1365   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1366      uint16 totalSupply = uint16(totalSupply());
1367      uint totalAmount =   _amountPerAddress * addresses.length;
1368     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1369      for (uint256 i = 0; i < addresses.length; i++) {
1370             _safeMint(addresses[i], _amountPerAddress);
1371         }
1372 
1373      delete _amountPerAddress;
1374      delete totalSupply;
1375   }
1376 
1377  
1378 
1379   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1380       maxSupply = _maxSupply;
1381   }
1382 
1383 
1384 
1385    
1386   function tokenURI(uint256 _tokenId)
1387     public
1388     view
1389     virtual
1390     override
1391     returns (string memory)
1392   {
1393     require(
1394       _exists(_tokenId),
1395       "ERC721Metadata: URI query for nonexistent token"
1396     );
1397     
1398   
1399 if ( reveal == false)
1400 {
1401     return hiddenURL;
1402 }
1403     
1404 
1405     string memory currentBaseURI = _baseURI();
1406     return bytes(currentBaseURI).length > 0
1407         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1408         : "";
1409   }
1410  
1411    function setWLPaused() external onlyOwner {
1412     WLpaused = !WLpaused;
1413   }
1414   function setWLCost(uint256 _cost) external onlyOwner {
1415     whiteListCost = _cost;
1416     delete _cost;
1417   }
1418 
1419 
1420 
1421  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1422     maxFreeMintAmountPerWallet = _limit;
1423    delete _limit;
1424 
1425 }
1426 
1427     
1428   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1429         for(uint8 i = 0; i < entries.length; i++) {
1430             isWhitelisted[entries[i]] = true;
1431         }   
1432     }
1433 
1434     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1435         for(uint8 i = 0; i < entries.length; i++) {
1436              isWhitelisted[entries[i]] = false;
1437         }
1438     }
1439 
1440 function whitelistMint(uint8 _mintAmount) external payable {
1441         
1442     
1443         uint8 nft = NFTPerWLAddress[msg.sender];
1444        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1445 
1446        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1447       
1448 
1449 
1450     require(!WLpaused, "Whitelist minting is over!");
1451          if(nft >= maxFreeMintAmountPerWallet)
1452     {
1453     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1454     }
1455     else {
1456          uint8 costAmount = _mintAmount + nft;
1457         if(costAmount > maxFreeMintAmountPerWallet)
1458        {
1459         costAmount = costAmount - maxFreeMintAmountPerWallet;
1460         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1461        }
1462        
1463          
1464     }
1465     
1466     
1467 
1468      _safeMint(msg.sender , _mintAmount);
1469       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1470      
1471       delete _mintAmount;
1472        delete nft;
1473     
1474     }
1475 
1476   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1477     uriPrefix = _uriPrefix;
1478   }
1479    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1480     hiddenURL = _uriPrefix;
1481   }
1482 
1483 
1484   function setPaused() external onlyOwner {
1485     paused = !paused;
1486     WLpaused = true;
1487   }
1488 
1489   function setCost(uint _cost) external onlyOwner{
1490       cost = _cost;
1491 
1492   }
1493 
1494  function setRevealed() external onlyOwner{
1495      reveal = !reveal;
1496  }
1497 
1498   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1499       maxMintAmountPerTx = _maxtx;
1500 
1501   }
1502 
1503  
1504 
1505   function withdraw() external onlyOwner {
1506   uint _balance = address(this).balance;
1507      payable(msg.sender).transfer(_balance ); 
1508        
1509   }
1510 
1511 
1512   function _baseURI() internal view  override returns (string memory) {
1513     return uriPrefix;
1514   }
1515 }