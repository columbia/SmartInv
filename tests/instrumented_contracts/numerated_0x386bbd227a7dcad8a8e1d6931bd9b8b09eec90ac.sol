1 /**
2 
3            <-. (`-')_  _(`-')    (`-')  _(`-')  _ _(`-')             (`-') (`-')  _ <-. (`-')   _  (`-') (`-').-> 
4      .->      \( OO) )( (OO ).-> ( OO).-/(OO ).-/( (OO ).->         _(OO ) (OO ).-/    \(OO )_  \-.(OO ) ( OO)_   
5 ,--.(,--.  ,--./ ,--/  \    .'_ (,------./ ,---.  \    .'_     ,--.(_/,-.\ / ,---.  ,--./  ,-.) _.'    \(_)--\_)  
6 |  | |(`-')|   \ |  |  '`'-..__) |  .---'| \ /`.\ '`'-..__)    \   \ / (_/ | \ /`.\ |   `.'   |(_...--''/    _ /  
7 |  | |(OO )|  . '|  |) |  |  ' |(|  '--. '-'|_.' ||  |  ' |     \   /   /  '-'|_.' ||  |'.'|  ||  |_.' |\_..`--.  
8 |  | | |  \|  |\    |  |  |  / : |  .--'(|  .-.  ||  |  / :    _ \     /_)(|  .-.  ||  |   |  ||  .___.'.-._)   \ 
9 \  '-'(_ .'|  | \   |  |  '-'  / |  `---.|  | |  ||  '-'  /    \-'\   /    |  | |  ||  |   |  ||  |     \       / 
10  `-----'   `--'  `--'  `------'  `------'`--' `--'`------'         `-'     `--' `--'`--'   `--'`--'      `-----'  
11 
12 */
13 // SPDX-License-Identifier: MIT
14 //Developer Info:
15 
16 
17 
18 // File: @openzeppelin/contracts/utils/Strings.sol
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev String operations.
26  */
27 library Strings {
28     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
29 
30     /**
31      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
32      */
33     function toString(uint256 value) internal pure returns (string memory) {
34         // Inspired by OraclizeAPI's implementation - MIT licence
35         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
36 
37         if (value == 0) {
38             return "0";
39         }
40         uint256 temp = value;
41         uint256 digits;
42         while (temp != 0) {
43             digits++;
44             temp /= 10;
45         }
46         bytes memory buffer = new bytes(digits);
47         while (value != 0) {
48             digits -= 1;
49             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
50             value /= 10;
51         }
52         return string(buffer);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
57      */
58     function toHexString(uint256 value) internal pure returns (string memory) {
59         if (value == 0) {
60             return "0x00";
61         }
62         uint256 temp = value;
63         uint256 length = 0;
64         while (temp != 0) {
65             length++;
66             temp >>= 8;
67         }
68         return toHexString(value, length);
69     }
70 
71     /**
72      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
73      */
74     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
75         bytes memory buffer = new bytes(2 * length + 2);
76         buffer[0] = "0";
77         buffer[1] = "x";
78         for (uint256 i = 2 * length + 1; i > 1; --i) {
79             buffer[i] = _HEX_SYMBOLS[value & 0xf];
80             value >>= 4;
81         }
82         require(value == 0, "Strings: hex length insufficient");
83         return string(buffer);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Context.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/Address.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
118 
119 pragma solidity ^0.8.1;
120 
121 /**
122  * @dev Collection of functions related to the address type
123  */
124 library Address {
125     /**
126      * @dev Returns true if `account` is a contract.
127      *
128      * [IMPORTANT]
129      * ====
130      * It is unsafe to assume that an address for which this function returns
131      * false is an externally-owned account (EOA) and not a contract.
132      *
133      * Among others, `isContract` will return false for the following
134      * types of addresses:
135      *
136      *  - an externally-owned account
137      *  - a contract in construction
138      *  - an address where a contract will be created
139      *  - an address where a contract lived, but was destroyed
140      * ====
141      *
142      * [IMPORTANT]
143      * ====
144      * You shouldn't rely on `isContract` to protect against flash loan attacks!
145      *
146      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
147      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
148      * constructor.
149      * ====
150      */
151     function isContract(address account) internal view returns (bool) {
152         // This method relies on extcodesize/address.code.length, which returns 0
153         // for contracts in construction, since the code is only stored at the end
154         // of the constructor execution.
155 
156         return account.code.length > 0;
157     }
158 
159     /**
160      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
161      * `recipient`, forwarding all available gas and reverting on errors.
162      *
163      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
164      * of certain opcodes, possibly making contracts go over the 2300 gas limit
165      * imposed by `transfer`, making them unable to receive funds via
166      * `transfer`. {sendValue} removes this limitation.
167      *
168      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
169      *
170      * IMPORTANT: because control is transferred to `recipient`, care must be
171      * taken to not create reentrancy vulnerabilities. Consider using
172      * {ReentrancyGuard} or the
173      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
174      */
175     function sendValue(address payable recipient, uint256 amount) internal {
176         require(address(this).balance >= amount, "Address: insufficient balance");
177 
178         (bool success, ) = recipient.call{value: amount}("");
179         require(success, "Address: unable to send value, recipient may have reverted");
180     }
181 
182     /**
183      * @dev Performs a Solidity function call using a low level `call`. A
184      * plain `call` is an unsafe replacement for a function call: use this
185      * function instead.
186      *
187      * If `target` reverts with a revert reason, it is bubbled up by this
188      * function (like regular Solidity function calls).
189      *
190      * Returns the raw returned data. To convert to the expected return value,
191      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
192      *
193      * Requirements:
194      *
195      * - `target` must be a contract.
196      * - calling `target` with `data` must not revert.
197      *
198      * _Available since v3.1._
199      */
200     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionCall(target, data, "Address: low-level call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
206      * `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, 0, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but also transferring `value` wei to `target`.
221      *
222      * Requirements:
223      *
224      * - the calling contract must have an ETH balance of at least `value`.
225      * - the called Solidity function must be `payable`.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value
233     ) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
239      * with `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCallWithValue(
244         address target,
245         bytes memory data,
246         uint256 value,
247         string memory errorMessage
248     ) internal returns (bytes memory) {
249         require(address(this).balance >= value, "Address: insufficient balance for call");
250         require(isContract(target), "Address: call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.call{value: value}(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a static call.
259      *
260      * _Available since v3.3._
261      */
262     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
263         return functionStaticCall(target, data, "Address: low-level static call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal view returns (bytes memory) {
277         require(isContract(target), "Address: static call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.staticcall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but performing a delegate call.
286      *
287      * _Available since v3.4._
288      */
289     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
295      * but performing a delegate call.
296      *
297      * _Available since v3.4._
298      */
299     function functionDelegateCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         require(isContract(target), "Address: delegate call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.delegatecall(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
312      * revert reason using the provided one.
313      *
314      * _Available since v4.3._
315      */
316     function verifyCallResult(
317         bool success,
318         bytes memory returndata,
319         string memory errorMessage
320     ) internal pure returns (bytes memory) {
321         if (success) {
322             return returndata;
323         } else {
324             // Look for revert reason and bubble it up if present
325             if (returndata.length > 0) {
326                 // The easiest way to bubble the revert reason is using memory via assembly
327 
328                 assembly {
329                     let returndata_size := mload(returndata)
330                     revert(add(32, returndata), returndata_size)
331                 }
332             } else {
333                 revert(errorMessage);
334             }
335         }
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @title ERC721 token receiver interface
348  * @dev Interface for any contract that wants to support safeTransfers
349  * from ERC721 asset contracts.
350  */
351 interface IERC721Receiver {
352     /**
353      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
354      * by `operator` from `from`, this function is called.
355      *
356      * It must return its Solidity selector to confirm the token transfer.
357      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
358      *
359      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
360      */
361     function onERC721Received(
362         address operator,
363         address from,
364         uint256 tokenId,
365         bytes calldata data
366     ) external returns (bytes4);
367 }
368 
369 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Interface of the ERC165 standard, as defined in the
378  * https://eips.ethereum.org/EIPS/eip-165[EIP].
379  *
380  * Implementers can declare support of contract interfaces, which can then be
381  * queried by others ({ERC165Checker}).
382  *
383  * For an implementation, see {ERC165}.
384  */
385 interface IERC165 {
386     /**
387      * @dev Returns true if this contract implements the interface defined by
388      * `interfaceId`. See the corresponding
389      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
390      * to learn more about how these ids are created.
391      *
392      * This function call must use less than 30 000 gas.
393      */
394     function supportsInterface(bytes4 interfaceId) external view returns (bool);
395 }
396 
397 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev Implementation of the {IERC165} interface.
407  *
408  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
409  * for the additional interface id that will be supported. For example:
410  *
411  * ```solidity
412  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
413  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
414  * }
415  * ```
416  *
417  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
418  */
419 abstract contract ERC165 is IERC165 {
420     /**
421      * @dev See {IERC165-supportsInterface}.
422      */
423     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424         return interfaceId == type(IERC165).interfaceId;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 
436 /**
437  * @dev Required interface of an ERC721 compliant contract.
438  */
439 interface IERC721 is IERC165 {
440     /**
441      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
447      */
448     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
449 
450     /**
451      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
452      */
453     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
454 
455     /**
456      * @dev Returns the number of tokens in ``owner``'s account.
457      */
458     function balanceOf(address owner) external view returns (uint256 balance);
459 
460     /**
461      * @dev Returns the owner of the `tokenId` token.
462      *
463      * Requirements:
464      *
465      * - `tokenId` must exist.
466      */
467     function ownerOf(uint256 tokenId) external view returns (address owner);
468 
469     /**
470      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
471      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must exist and be owned by `from`.
478      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
480      *
481      * Emits a {Transfer} event.
482      */
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Transfers `tokenId` token from `from` to `to`.
491      *
492      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
493      *
494      * Requirements:
495      *
496      * - `from` cannot be the zero address.
497      * - `to` cannot be the zero address.
498      * - `tokenId` token must be owned by `from`.
499      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
500      *
501      * Emits a {Transfer} event.
502      */
503     function transferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
511      * The approval is cleared when the token is transferred.
512      *
513      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
514      *
515      * Requirements:
516      *
517      * - The caller must own the token or be an approved operator.
518      * - `tokenId` must exist.
519      *
520      * Emits an {Approval} event.
521      */
522     function approve(address to, uint256 tokenId) external;
523 
524     /**
525      * @dev Returns the account approved for `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function getApproved(uint256 tokenId) external view returns (address operator);
532 
533     /**
534      * @dev Approve or remove `operator` as an operator for the caller.
535      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
536      *
537      * Requirements:
538      *
539      * - The `operator` cannot be the caller.
540      *
541      * Emits an {ApprovalForAll} event.
542      */
543     function setApprovalForAll(address operator, bool _approved) external;
544 
545     /**
546      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
547      *
548      * See {setApprovalForAll}
549      */
550     function isApprovedForAll(address owner, address operator) external view returns (bool);
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId,
569         bytes calldata data
570     ) external;
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
583  * @dev See https://eips.ethereum.org/EIPS/eip-721
584  */
585 interface IERC721Metadata is IERC721 {
586     /**
587      * @dev Returns the token collection name.
588      */
589     function name() external view returns (string memory);
590 
591     /**
592      * @dev Returns the token collection symbol.
593      */
594     function symbol() external view returns (string memory);
595 
596     /**
597      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
598      */
599     function tokenURI(uint256 tokenId) external view returns (string memory);
600 }
601 
602 // File: contracts/new.sol
603 
604 
605 
606 
607 pragma solidity ^0.8.4;
608 
609 
610 
611 
612 
613 
614 
615 
616 error ApprovalCallerNotOwnerNorApproved();
617 error ApprovalQueryForNonexistentToken();
618 error ApproveToCaller();
619 error ApprovalToCurrentOwner();
620 error BalanceQueryForZeroAddress();
621 error MintToZeroAddress();
622 error MintZeroQuantity();
623 error OwnerQueryForNonexistentToken();
624 error TransferCallerNotOwnerNorApproved();
625 error TransferFromIncorrectOwner();
626 error TransferToNonERC721ReceiverImplementer();
627 error TransferToZeroAddress();
628 error URIQueryForNonexistentToken();
629 
630 /**
631  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
632  * the Metadata extension. Built to optimize for lower gas during batch mints.
633  *
634  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
635  *
636  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
637  *
638  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
639  */
640 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
641     using Address for address;
642     using Strings for uint256;
643 
644     // Compiler will pack this into a single 256bit word.
645     struct TokenOwnership {
646         // The address of the owner.
647         address addr;
648         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
649         uint64 startTimestamp;
650         // Whether the token has been burned.
651         bool burned;
652     }
653 
654     // Compiler will pack this into a single 256bit word.
655     struct AddressData {
656         // Realistically, 2**64-1 is more than enough.
657         uint64 balance;
658         // Keeps track of mint count with minimal overhead for tokenomics.
659         uint64 numberMinted;
660         // Keeps track of burn count with minimal overhead for tokenomics.
661         uint64 numberBurned;
662         // For miscellaneous variable(s) pertaining to the address
663         // (e.g. number of whitelist mint slots used).
664         // If there are multiple variables, please pack them into a uint64.
665         uint64 aux;
666     }
667 
668     // The tokenId of the next token to be minted.
669     uint256 internal _currentIndex;
670 
671     // The number of tokens burned.
672     uint256 internal _burnCounter;
673 
674     // Token name
675     string private _name;
676 
677     // Token symbol
678     string private _symbol;
679 
680     // Mapping from token ID to ownership details
681     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
682     mapping(uint256 => TokenOwnership) internal _ownerships;
683 
684     // Mapping owner address to address data
685     mapping(address => AddressData) private _addressData;
686 
687     // Mapping from token ID to approved address
688     mapping(uint256 => address) private _tokenApprovals;
689 
690     // Mapping from owner to operator approvals
691     mapping(address => mapping(address => bool)) private _operatorApprovals;
692 
693     constructor(string memory name_, string memory symbol_) {
694         _name = name_;
695         _symbol = symbol_;
696         _currentIndex = _startTokenId();
697     }
698 
699     /**
700      * To change the starting tokenId, please override this function.
701      */
702     function _startTokenId() internal view virtual returns (uint256) {
703         return 0;
704     }
705 
706     /**
707      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
708      */
709     function totalSupply() public view returns (uint256) {
710         // Counter underflow is impossible as _burnCounter cannot be incremented
711         // more than _currentIndex - _startTokenId() times
712         unchecked {
713             return _currentIndex - _burnCounter - _startTokenId();
714         }
715     }
716 
717     /**
718      * Returns the total amount of tokens minted in the contract.
719      */
720     function _totalMinted() internal view returns (uint256) {
721         // Counter underflow is impossible as _currentIndex does not decrement,
722         // and it is initialized to _startTokenId()
723         unchecked {
724             return _currentIndex - _startTokenId();
725         }
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner) public view override returns (uint256) {
742         if (owner == address(0)) revert BalanceQueryForZeroAddress();
743         return uint256(_addressData[owner].balance);
744     }
745 
746     /**
747      * Returns the number of tokens minted by `owner`.
748      */
749     function _numberMinted(address owner) internal view returns (uint256) {
750         return uint256(_addressData[owner].numberMinted);
751     }
752 
753     /**
754      * Returns the number of tokens burned by or on behalf of `owner`.
755      */
756     function _numberBurned(address owner) internal view returns (uint256) {
757         return uint256(_addressData[owner].numberBurned);
758     }
759 
760     /**
761      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
762      */
763     function _getAux(address owner) internal view returns (uint64) {
764         return _addressData[owner].aux;
765     }
766 
767     /**
768      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
769      * If there are multiple variables, please pack them into a uint64.
770      */
771     function _setAux(address owner, uint64 aux) internal {
772         _addressData[owner].aux = aux;
773     }
774 
775     /**
776      * Gas spent here starts off proportional to the maximum mint batch size.
777      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
778      */
779     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
780         uint256 curr = tokenId;
781 
782         unchecked {
783             if (_startTokenId() <= curr && curr < _currentIndex) {
784                 TokenOwnership memory ownership = _ownerships[curr];
785                 if (!ownership.burned) {
786                     if (ownership.addr != address(0)) {
787                         return ownership;
788                     }
789                     // Invariant:
790                     // There will always be an ownership that has an address and is not burned
791                     // before an ownership that does not have an address and is not burned.
792                     // Hence, curr will not underflow.
793                     while (true) {
794                         curr--;
795                         ownership = _ownerships[curr];
796                         if (ownership.addr != address(0)) {
797                             return ownership;
798                         }
799                     }
800                 }
801             }
802         }
803         revert OwnerQueryForNonexistentToken();
804     }
805 
806     /**
807      * @dev See {IERC721-ownerOf}.
808      */
809     function ownerOf(uint256 tokenId) public view override returns (address) {
810         return _ownershipOf(tokenId).addr;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-name}.
815      */
816     function name() public view virtual override returns (string memory) {
817         return _name;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-symbol}.
822      */
823     function symbol() public view virtual override returns (string memory) {
824         return _symbol;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-tokenURI}.
829      */
830     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
831         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
832 
833         string memory baseURI = _baseURI();
834         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
835     }
836 
837     /**
838      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840      * by default, can be overriden in child contracts.
841      */
842     function _baseURI() internal view virtual returns (string memory) {
843         return '';
844     }
845 
846     /**
847      * @dev See {IERC721-approve}.
848      */
849     function approve(address to, uint256 tokenId) public override {
850         address owner = ERC721A.ownerOf(tokenId);
851         if (to == owner) revert ApprovalToCurrentOwner();
852 
853         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
854             revert ApprovalCallerNotOwnerNorApproved();
855         }
856 
857         _approve(to, tokenId, owner);
858     }
859 
860     /**
861      * @dev See {IERC721-getApproved}.
862      */
863     function getApproved(uint256 tokenId) public view override returns (address) {
864         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
865 
866         return _tokenApprovals[tokenId];
867     }
868 
869     /**
870      * @dev See {IERC721-setApprovalForAll}.
871      */
872     function setApprovalForAll(address operator, bool approved) public virtual override {
873         if (operator == _msgSender()) revert ApproveToCaller();
874 
875         _operatorApprovals[_msgSender()][operator] = approved;
876         emit ApprovalForAll(_msgSender(), operator, approved);
877     }
878 
879     /**
880      * @dev See {IERC721-isApprovedForAll}.
881      */
882     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
883         return _operatorApprovals[owner][operator];
884     }
885 
886     /**
887      * @dev See {IERC721-transferFrom}.
888      */
889     function transferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         _transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, '');
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) public virtual override {
917         _transfer(from, to, tokenId);
918         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
919             revert TransferToNonERC721ReceiverImplementer();
920         }
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      */
930     function _exists(uint256 tokenId) internal view returns (bool) {
931         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
932             !_ownerships[tokenId].burned;
933     }
934 
935     function _safeMint(address to, uint256 quantity) internal {
936         _safeMint(to, quantity, '');
937     }
938 
939     /**
940      * @dev Safely mints `quantity` tokens and transfers them to `to`.
941      *
942      * Requirements:
943      *
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
945      * - `quantity` must be greater than 0.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _safeMint(
950         address to,
951         uint256 quantity,
952         bytes memory _data
953     ) internal {
954         _mint(to, quantity, _data, true);
955     }
956 
957     /**
958      * @dev Mints `quantity` tokens and transfers them to `to`.
959      *
960      * Requirements:
961      *
962      * - `to` cannot be the zero address.
963      * - `quantity` must be greater than 0.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _mint(
968         address to,
969         uint256 quantity,
970         bytes memory _data,
971         bool safe
972     ) internal {
973         uint256 startTokenId = _currentIndex;
974         if (to == address(0)) revert MintToZeroAddress();
975         if (quantity == 0) revert MintZeroQuantity();
976 
977         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
978 
979         // Overflows are incredibly unrealistic.
980         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
981         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
982         unchecked {
983             _addressData[to].balance += uint64(quantity);
984             _addressData[to].numberMinted += uint64(quantity);
985 
986             _ownerships[startTokenId].addr = to;
987             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
988 
989             uint256 updatedIndex = startTokenId;
990             uint256 end = updatedIndex + quantity;
991 
992             if (safe && to.isContract()) {
993                 do {
994                     emit Transfer(address(0), to, updatedIndex);
995                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
996                         revert TransferToNonERC721ReceiverImplementer();
997                     }
998                 } while (updatedIndex != end);
999                 // Reentrancy protection
1000                 if (_currentIndex != startTokenId) revert();
1001             } else {
1002                 do {
1003                     emit Transfer(address(0), to, updatedIndex++);
1004                 } while (updatedIndex != end);
1005             }
1006             _currentIndex = updatedIndex;
1007         }
1008         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1009     }
1010 
1011     /**
1012      * @dev Transfers `tokenId` from `from` to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must be owned by `from`.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _transfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) private {
1026         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1027 
1028         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1029 
1030         bool isApprovedOrOwner = (_msgSender() == from ||
1031             isApprovedForAll(from, _msgSender()) ||
1032             getApproved(tokenId) == _msgSender());
1033 
1034         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1035         if (to == address(0)) revert TransferToZeroAddress();
1036 
1037         _beforeTokenTransfers(from, to, tokenId, 1);
1038 
1039         // Clear approvals from the previous owner
1040         _approve(address(0), tokenId, from);
1041 
1042         // Underflow of the sender's balance is impossible because we check for
1043         // ownership above and the recipient's balance can't realistically overflow.
1044         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1045         unchecked {
1046             _addressData[from].balance -= 1;
1047             _addressData[to].balance += 1;
1048 
1049             TokenOwnership storage currSlot = _ownerships[tokenId];
1050             currSlot.addr = to;
1051             currSlot.startTimestamp = uint64(block.timestamp);
1052 
1053             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1054             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1055             uint256 nextTokenId = tokenId + 1;
1056             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1057             if (nextSlot.addr == address(0)) {
1058                 // This will suffice for checking _exists(nextTokenId),
1059                 // as a burned slot cannot contain the zero address.
1060                 if (nextTokenId != _currentIndex) {
1061                     nextSlot.addr = from;
1062                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1063                 }
1064             }
1065         }
1066 
1067         emit Transfer(from, to, tokenId);
1068         _afterTokenTransfers(from, to, tokenId, 1);
1069     }
1070 
1071     /**
1072      * @dev This is equivalent to _burn(tokenId, false)
1073      */
1074     function _burn(uint256 tokenId) internal virtual {
1075         _burn(tokenId, false);
1076     }
1077 
1078     /**
1079      * @dev Destroys `tokenId`.
1080      * The approval is cleared when the token is burned.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must exist.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1089         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1090 
1091         address from = prevOwnership.addr;
1092 
1093         if (approvalCheck) {
1094             bool isApprovedOrOwner = (_msgSender() == from ||
1095                 isApprovedForAll(from, _msgSender()) ||
1096                 getApproved(tokenId) == _msgSender());
1097 
1098             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1099         }
1100 
1101         _beforeTokenTransfers(from, address(0), tokenId, 1);
1102 
1103         // Clear approvals from the previous owner
1104         _approve(address(0), tokenId, from);
1105 
1106         // Underflow of the sender's balance is impossible because we check for
1107         // ownership above and the recipient's balance can't realistically overflow.
1108         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1109         unchecked {
1110             AddressData storage addressData = _addressData[from];
1111             addressData.balance -= 1;
1112             addressData.numberBurned += 1;
1113 
1114             // Keep track of who burned the token, and the timestamp of burning.
1115             TokenOwnership storage currSlot = _ownerships[tokenId];
1116             currSlot.addr = from;
1117             currSlot.startTimestamp = uint64(block.timestamp);
1118             currSlot.burned = true;
1119 
1120             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1121             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1122             uint256 nextTokenId = tokenId + 1;
1123             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1124             if (nextSlot.addr == address(0)) {
1125                 // This will suffice for checking _exists(nextTokenId),
1126                 // as a burned slot cannot contain the zero address.
1127                 if (nextTokenId != _currentIndex) {
1128                     nextSlot.addr = from;
1129                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1130                 }
1131             }
1132         }
1133 
1134         emit Transfer(from, address(0), tokenId);
1135         _afterTokenTransfers(from, address(0), tokenId, 1);
1136 
1137         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1138         unchecked {
1139             _burnCounter++;
1140         }
1141     }
1142 
1143     /**
1144      * @dev Approve `to` to operate on `tokenId`
1145      *
1146      * Emits a {Approval} event.
1147      */
1148     function _approve(
1149         address to,
1150         uint256 tokenId,
1151         address owner
1152     ) private {
1153         _tokenApprovals[tokenId] = to;
1154         emit Approval(owner, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1159      *
1160      * @param from address representing the previous owner of the given token ID
1161      * @param to target address that will receive the tokens
1162      * @param tokenId uint256 ID of the token to be transferred
1163      * @param _data bytes optional data to send along with the call
1164      * @return bool whether the call correctly returned the expected magic value
1165      */
1166     function _checkContractOnERC721Received(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) private returns (bool) {
1172         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1173             return retval == IERC721Receiver(to).onERC721Received.selector;
1174         } catch (bytes memory reason) {
1175             if (reason.length == 0) {
1176                 revert TransferToNonERC721ReceiverImplementer();
1177             } else {
1178                 assembly {
1179                     revert(add(32, reason), mload(reason))
1180                 }
1181             }
1182         }
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1187      * And also called before burning one token.
1188      *
1189      * startTokenId - the first token id to be transferred
1190      * quantity - the amount to be transferred
1191      *
1192      * Calling conditions:
1193      *
1194      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1195      * transferred to `to`.
1196      * - When `from` is zero, `tokenId` will be minted for `to`.
1197      * - When `to` is zero, `tokenId` will be burned by `from`.
1198      * - `from` and `to` are never both zero.
1199      */
1200     function _beforeTokenTransfers(
1201         address from,
1202         address to,
1203         uint256 startTokenId,
1204         uint256 quantity
1205     ) internal virtual {}
1206 
1207     /**
1208      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1209      * minting.
1210      * And also called after one token has been burned.
1211      *
1212      * startTokenId - the first token id to be transferred
1213      * quantity - the amount to be transferred
1214      *
1215      * Calling conditions:
1216      *
1217      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1218      * transferred to `to`.
1219      * - When `from` is zero, `tokenId` has been minted for `to`.
1220      * - When `to` is zero, `tokenId` has been burned by `from`.
1221      * - `from` and `to` are never both zero.
1222      */
1223     function _afterTokenTransfers(
1224         address from,
1225         address to,
1226         uint256 startTokenId,
1227         uint256 quantity
1228     ) internal virtual {}
1229 }
1230 
1231 abstract contract Ownable is Context {
1232     address private _owner;
1233 
1234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1235 
1236     /**
1237      * @dev Initializes the contract setting the deployer as the initial owner.
1238      */
1239     constructor() {
1240         _transferOwnership(_msgSender());
1241     }
1242 
1243     /**
1244      * @dev Returns the address of the current owner.
1245      */
1246     function owner() public view virtual returns (address) {
1247         return _owner;
1248     }
1249 
1250     /**
1251      * @dev Throws if called by any account other than the owner.
1252      */
1253     modifier onlyOwner() {
1254         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1255         _;
1256     }
1257 
1258     /**
1259      * @dev Leaves the contract without owner. It will not be possible to call
1260      * `onlyOwner` functions anymore. Can only be called by the current owner.
1261      *
1262      * NOTE: Renouncing ownership will leave the contract without an owner,
1263      * thereby removing any functionality that is only available to the owner.
1264      */
1265     function renounceOwnership() public virtual onlyOwner {
1266         _transferOwnership(address(0));
1267     }
1268 
1269     /**
1270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1271      * Can only be called by the current owner.
1272      */
1273     function transferOwnership(address newOwner) public virtual onlyOwner {
1274         require(newOwner != address(0), "Ownable: new owner is the zero address");
1275         _transferOwnership(newOwner);
1276     }
1277 
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Internal function without access restriction.
1281      */
1282     function _transferOwnership(address newOwner) internal virtual {
1283         address oldOwner = _owner;
1284         _owner = newOwner;
1285         emit OwnershipTransferred(oldOwner, newOwner);
1286     }
1287 }
1288     pragma solidity ^0.8.7;
1289     
1290     contract UNDEADVAMPS is ERC721A, Ownable {
1291     using Strings for uint256;
1292 
1293 
1294   string private uriPrefix ;
1295   string private uriSuffix = ".json";
1296   string public hiddenURL;
1297 
1298   
1299   
1300 
1301   uint256 public cost = 0.003 ether;
1302  
1303   
1304 
1305   uint16 public maxSupply = 4140;
1306   uint8 public maxMintAmountPerTx = 11;
1307     uint8 public maxFreeMintAmountPerWallet = 1;
1308                                                              
1309  
1310   bool public paused = true;
1311   bool public reveal =false;
1312 
1313    mapping (address => uint8) public NFTPerPublicAddress;
1314 
1315  
1316   
1317   
1318  
1319   
1320 
1321   constructor() ERC721A("UNDEAD VAMPS", "UV") {
1322   }
1323 
1324 
1325   
1326  
1327   function mint(uint8 _mintAmount) external payable  {
1328      uint16 totalSupply = uint16(totalSupply());
1329      uint8 nft = NFTPerPublicAddress[msg.sender];
1330     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1331     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1332 
1333     require(!paused, "The contract is paused!");
1334     
1335       if(nft >= maxFreeMintAmountPerWallet)
1336     {
1337     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1338     }
1339     else {
1340          uint8 costAmount = _mintAmount + nft;
1341         if(costAmount > maxFreeMintAmountPerWallet)
1342        {
1343         costAmount = costAmount - maxFreeMintAmountPerWallet;
1344         require(msg.value >= cost * costAmount, "Insufficient funds!");
1345        }
1346        
1347          
1348     }
1349     
1350 
1351 
1352     _safeMint(msg.sender , _mintAmount);
1353 
1354     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1355      
1356      delete totalSupply;
1357      delete _mintAmount;
1358   }
1359   
1360   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1361      uint16 totalSupply = uint16(totalSupply());
1362     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1363      _safeMint(_receiver , _mintAmount);
1364      delete _mintAmount;
1365      delete _receiver;
1366      delete totalSupply;
1367   }
1368 
1369   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1370      uint16 totalSupply = uint16(totalSupply());
1371      uint totalAmount =   _amountPerAddress * addresses.length;
1372     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1373      for (uint256 i = 0; i < addresses.length; i++) {
1374             _safeMint(addresses[i], _amountPerAddress);
1375         }
1376 
1377      delete _amountPerAddress;
1378      delete totalSupply;
1379   }
1380 
1381  
1382 
1383   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1384       maxSupply = _maxSupply;
1385   }
1386 
1387 
1388 
1389    
1390   function tokenURI(uint256 _tokenId)
1391     public
1392     view
1393     virtual
1394     override
1395     returns (string memory)
1396   {
1397     require(
1398       _exists(_tokenId),
1399       "ERC721Metadata: URI query for nonexistent token"
1400     );
1401     
1402   
1403 if ( reveal == false)
1404 {
1405     return hiddenURL;
1406 }
1407     
1408 
1409     string memory currentBaseURI = _baseURI();
1410     return bytes(currentBaseURI).length > 0
1411         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1412         : "";
1413   }
1414  
1415  
1416 
1417 
1418  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1419     maxFreeMintAmountPerWallet = _limit;
1420    delete _limit;
1421 
1422 }
1423 
1424     
1425   
1426 
1427   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1428     uriPrefix = _uriPrefix;
1429   }
1430    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1431     hiddenURL = _uriPrefix;
1432   }
1433 
1434 
1435   function setPaused() external onlyOwner {
1436     paused = !paused;
1437    
1438   }
1439 
1440   function setCost(uint _cost) external onlyOwner{
1441       cost = _cost;
1442 
1443   }
1444 
1445  function setRevealed() external onlyOwner{
1446      reveal = !reveal;
1447  }
1448 
1449   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1450       maxMintAmountPerTx = _maxtx;
1451 
1452   }
1453 
1454  
1455 
1456   function withdraw() external onlyOwner {
1457   uint _balance = address(this).balance;
1458      payable(msg.sender).transfer(_balance ); 
1459        
1460   }
1461 
1462 
1463   function _baseURI() internal view  override returns (string memory) {
1464     return uriPrefix;
1465   }
1466 }