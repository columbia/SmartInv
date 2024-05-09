1 /**
2 
3 ╭━━━┳━━━┳━━━╮╭━━┳╮╱╱╭╮╭╮╭╮╭┳━━━┳━━━┳╮╱╭┳━━━┳╮
4 ┃╭━╮┃╭━╮┃╭━╮┃┃╭╮┃╰╮╭╯┃┃┃┃┃┃┃╭━╮┃╭━╮┃┃╱┃┃╭━╮┃┃
5 ┃╰━╯┃┃╱┃┃╰━╯┃┃╰╯╰╮╰╯╭╯┃┃┃┃┃┃┃╱┃┃╰━╯┃╰━╯┃┃╱┃┃┃
6 ┃╭━━┫┃╱┃┃╭━━╯┃╭━╮┣╮╭╯╱┃╰╯╰╯┃╰━╯┃╭╮╭┫╭━╮┃┃╱┃┃┃╱╭╮
7 ┃┃╱╱┃╰━╯┃┃╱╱╱┃╰━╯┃┃┃╱╱╰╮╭╮╭┫╭━╮┃┃┃╰┫┃╱┃┃╰━╯┃╰━╯┃
8 ╰╯╱╱╰━━━┻╯╱╱╱╰━━━╯╰╯╱╱╱╰╯╰╯╰╯╱╰┻╯╰━┻╯╱╰┻━━━┻━━━╯
9 
10  */
11 // SPDX-License-Identifier: MIT
12 
13 // File: @openzeppelin/contracts/utils/Strings.sol
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/utils/Address.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
113 
114 pragma solidity ^0.8.1;
115 
116 /**
117  * @dev Collection of functions related to the address type
118  */
119 library Address {
120     /**
121      * @dev Returns true if `account` is a contract.
122      *
123      * [IMPORTANT]
124      * ====
125      * It is unsafe to assume that an address for which this function returns
126      * false is an externally-owned account (EOA) and not a contract.
127      *
128      * Among others, `isContract` will return false for the following
129      * types of addresses:
130      *
131      *  - an externally-owned account
132      *  - a contract in construction
133      *  - an address where a contract will be created
134      *  - an address where a contract lived, but was destroyed
135      * ====
136      *
137      * [IMPORTANT]
138      * ====
139      * You shouldn't rely on `isContract` to protect against flash loan attacks!
140      *
141      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
142      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
143      * constructor.
144      * ====
145      */
146     function isContract(address account) internal view returns (bool) {
147         // This method relies on extcodesize/address.code.length, which returns 0
148         // for contracts in construction, since the code is only stored at the end
149         // of the constructor execution.
150 
151         return account.code.length > 0;
152     }
153 
154     /**
155      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
156      * `recipient`, forwarding all available gas and reverting on errors.
157      *
158      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
159      * of certain opcodes, possibly making contracts go over the 2300 gas limit
160      * imposed by `transfer`, making them unable to receive funds via
161      * `transfer`. {sendValue} removes this limitation.
162      *
163      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
164      *
165      * IMPORTANT: because control is transferred to `recipient`, care must be
166      * taken to not create reentrancy vulnerabilities. Consider using
167      * {ReentrancyGuard} or the
168      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
169      */
170     function sendValue(address payable recipient, uint256 amount) internal {
171         require(address(this).balance >= amount, "Address: insufficient balance");
172 
173         (bool success, ) = recipient.call{value: amount}("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177     /**
178      * @dev Performs a Solidity function call using a low level `call`. A
179      * plain `call` is an unsafe replacement for a function call: use this
180      * function instead.
181      *
182      * If `target` reverts with a revert reason, it is bubbled up by this
183      * function (like regular Solidity function calls).
184      *
185      * Returns the raw returned data. To convert to the expected return value,
186      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187      *
188      * Requirements:
189      *
190      * - `target` must be a contract.
191      * - calling `target` with `data` must not revert.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionCall(target, data, "Address: low-level call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201      * `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, 0, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but also transferring `value` wei to `target`.
216      *
217      * Requirements:
218      *
219      * - the calling contract must have an ETH balance of at least `value`.
220      * - the called Solidity function must be `payable`.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
234      * with `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         require(address(this).balance >= value, "Address: insufficient balance for call");
245         require(isContract(target), "Address: call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.call{value: value}(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
258         return functionStaticCall(target, data, "Address: low-level static call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal view returns (bytes memory) {
272         require(isContract(target), "Address: static call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(isContract(target), "Address: delegate call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.delegatecall(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
307      * revert reason using the provided one.
308      *
309      * _Available since v4.3._
310      */
311     function verifyCallResult(
312         bool success,
313         bytes memory returndata,
314         string memory errorMessage
315     ) internal pure returns (bytes memory) {
316         if (success) {
317             return returndata;
318         } else {
319             // Look for revert reason and bubble it up if present
320             if (returndata.length > 0) {
321                 // The easiest way to bubble the revert reason is using memory via assembly
322 
323                 assembly {
324                     let returndata_size := mload(returndata)
325                     revert(add(32, returndata), returndata_size)
326                 }
327             } else {
328                 revert(errorMessage);
329             }
330         }
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @title ERC721 token receiver interface
343  * @dev Interface for any contract that wants to support safeTransfers
344  * from ERC721 asset contracts.
345  */
346 interface IERC721Receiver {
347     /**
348      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
349      * by `operator` from `from`, this function is called.
350      *
351      * It must return its Solidity selector to confirm the token transfer.
352      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
353      *
354      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
355      */
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Interface of the ERC165 standard, as defined in the
373  * https://eips.ethereum.org/EIPS/eip-165[EIP].
374  *
375  * Implementers can declare support of contract interfaces, which can then be
376  * queried by others ({ERC165Checker}).
377  *
378  * For an implementation, see {ERC165}.
379  */
380 interface IERC165 {
381     /**
382      * @dev Returns true if this contract implements the interface defined by
383      * `interfaceId`. See the corresponding
384      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
385      * to learn more about how these ids are created.
386      *
387      * This function call must use less than 30 000 gas.
388      */
389     function supportsInterface(bytes4 interfaceId) external view returns (bool);
390 }
391 
392 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Implementation of the {IERC165} interface.
402  *
403  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
404  * for the additional interface id that will be supported. For example:
405  *
406  * ```solidity
407  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
409  * }
410  * ```
411  *
412  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
413  */
414 abstract contract ERC165 is IERC165 {
415     /**
416      * @dev See {IERC165-supportsInterface}.
417      */
418     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419         return interfaceId == type(IERC165).interfaceId;
420     }
421 }
422 
423 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 /**
432  * @dev Required interface of an ERC721 compliant contract.
433  */
434 interface IERC721 is IERC165 {
435     /**
436      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
437      */
438     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
439 
440     /**
441      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
442      */
443     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
447      */
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449 
450     /**
451      * @dev Returns the number of tokens in ``owner``'s account.
452      */
453     function balanceOf(address owner) external view returns (uint256 balance);
454 
455     /**
456      * @dev Returns the owner of the `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function ownerOf(uint256 tokenId) external view returns (address owner);
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
466      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external;
483 
484     /**
485      * @dev Transfers `tokenId` token from `from` to `to`.
486      *
487      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must be owned by `from`.
494      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     /**
505      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
506      * The approval is cleared when the token is transferred.
507      *
508      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 
547     /**
548      * @dev Safely transfers `tokenId` token from `from` to `to`.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must exist and be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557      *
558      * Emits a {Transfer} event.
559      */
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId,
564         bytes calldata data
565     ) external;
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
578  * @dev See https://eips.ethereum.org/EIPS/eip-721
579  */
580 interface IERC721Metadata is IERC721 {
581     /**
582      * @dev Returns the token collection name.
583      */
584     function name() external view returns (string memory);
585 
586     /**
587      * @dev Returns the token collection symbol.
588      */
589     function symbol() external view returns (string memory);
590 
591     /**
592      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
593      */
594     function tokenURI(uint256 tokenId) external view returns (string memory);
595 }
596 
597 // File: contracts/new.sol
598 
599 
600 
601 
602 pragma solidity ^0.8.4;
603 
604 
605 
606 
607 
608 
609 
610 
611 error ApprovalCallerNotOwnerNorApproved();
612 error ApprovalQueryForNonexistentToken();
613 error ApproveToCaller();
614 error ApprovalToCurrentOwner();
615 error BalanceQueryForZeroAddress();
616 error MintToZeroAddress();
617 error MintZeroQuantity();
618 error OwnerQueryForNonexistentToken();
619 error TransferCallerNotOwnerNorApproved();
620 error TransferFromIncorrectOwner();
621 error TransferToNonERC721ReceiverImplementer();
622 error TransferToZeroAddress();
623 error URIQueryForNonexistentToken();
624 
625 /**
626  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
627  * the Metadata extension. Built to optimize for lower gas during batch mints.
628  *
629  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
630  *
631  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
632  *
633  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
634  */
635 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
636     using Address for address;
637     using Strings for uint256;
638 
639     // Compiler will pack this into a single 256bit word.
640     struct TokenOwnership {
641         // The address of the owner.
642         address addr;
643         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
644         uint64 startTimestamp;
645         // Whether the token has been burned.
646         bool burned;
647     }
648 
649     // Compiler will pack this into a single 256bit word.
650     struct AddressData {
651         // Realistically, 2**64-1 is more than enough.
652         uint64 balance;
653         // Keeps track of mint count with minimal overhead for tokenomics.
654         uint64 numberMinted;
655         // Keeps track of burn count with minimal overhead for tokenomics.
656         uint64 numberBurned;
657         // For miscellaneous variable(s) pertaining to the address
658         // (e.g. number of whitelist mint slots used).
659         // If there are multiple variables, please pack them into a uint64.
660         uint64 aux;
661     }
662 
663     // The tokenId of the next token to be minted.
664     uint256 internal _currentIndex;
665 
666     // The number of tokens burned.
667     uint256 internal _burnCounter;
668 
669     // Token name
670     string private _name;
671 
672     // Token symbol
673     string private _symbol;
674 
675     // Mapping from token ID to ownership details
676     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
677     mapping(uint256 => TokenOwnership) internal _ownerships;
678 
679     // Mapping owner address to address data
680     mapping(address => AddressData) private _addressData;
681 
682     // Mapping from token ID to approved address
683     mapping(uint256 => address) private _tokenApprovals;
684 
685     // Mapping from owner to operator approvals
686     mapping(address => mapping(address => bool)) private _operatorApprovals;
687 
688     constructor(string memory name_, string memory symbol_) {
689         _name = name_;
690         _symbol = symbol_;
691         _currentIndex = _startTokenId();
692     }
693 
694     /**
695      * To change the starting tokenId, please override this function.
696      */
697     function _startTokenId() internal view virtual returns (uint256) {
698         return 0;
699     }
700 
701     /**
702      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
703      */
704     function totalSupply() public view returns (uint256) {
705         // Counter underflow is impossible as _burnCounter cannot be incremented
706         // more than _currentIndex - _startTokenId() times
707         unchecked {
708             return _currentIndex - _burnCounter - _startTokenId();
709         }
710     }
711 
712     /**
713      * Returns the total amount of tokens minted in the contract.
714      */
715     function _totalMinted() internal view returns (uint256) {
716         // Counter underflow is impossible as _currentIndex does not decrement,
717         // and it is initialized to _startTokenId()
718         unchecked {
719             return _currentIndex - _startTokenId();
720         }
721     }
722 
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
727         return
728             interfaceId == type(IERC721).interfaceId ||
729             interfaceId == type(IERC721Metadata).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view override returns (uint256) {
737         if (owner == address(0)) revert BalanceQueryForZeroAddress();
738         return uint256(_addressData[owner].balance);
739     }
740 
741     /**
742      * Returns the number of tokens minted by `owner`.
743      */
744     function _numberMinted(address owner) internal view returns (uint256) {
745         return uint256(_addressData[owner].numberMinted);
746     }
747 
748     /**
749      * Returns the number of tokens burned by or on behalf of `owner`.
750      */
751     function _numberBurned(address owner) internal view returns (uint256) {
752         return uint256(_addressData[owner].numberBurned);
753     }
754 
755     /**
756      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
757      */
758     function _getAux(address owner) internal view returns (uint64) {
759         return _addressData[owner].aux;
760     }
761 
762     /**
763      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
764      * If there are multiple variables, please pack them into a uint64.
765      */
766     function _setAux(address owner, uint64 aux) internal {
767         _addressData[owner].aux = aux;
768     }
769 
770     /**
771      * Gas spent here starts off proportional to the maximum mint batch size.
772      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
773      */
774     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
775         uint256 curr = tokenId;
776 
777         unchecked {
778             if (_startTokenId() <= curr && curr < _currentIndex) {
779                 TokenOwnership memory ownership = _ownerships[curr];
780                 if (!ownership.burned) {
781                     if (ownership.addr != address(0)) {
782                         return ownership;
783                     }
784                     // Invariant:
785                     // There will always be an ownership that has an address and is not burned
786                     // before an ownership that does not have an address and is not burned.
787                     // Hence, curr will not underflow.
788                     while (true) {
789                         curr--;
790                         ownership = _ownerships[curr];
791                         if (ownership.addr != address(0)) {
792                             return ownership;
793                         }
794                     }
795                 }
796             }
797         }
798         revert OwnerQueryForNonexistentToken();
799     }
800 
801     /**
802      * @dev See {IERC721-ownerOf}.
803      */
804     function ownerOf(uint256 tokenId) public view override returns (address) {
805         return _ownershipOf(tokenId).addr;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
826         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
827 
828         string memory baseURI = _baseURI();
829         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
830     }
831 
832     /**
833      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
834      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
835      * by default, can be overriden in child contracts.
836      */
837     function _baseURI() internal view virtual returns (string memory) {
838         return '';
839     }
840 
841     /**
842      * @dev See {IERC721-approve}.
843      */
844     function approve(address to, uint256 tokenId) public override {
845         address owner = ERC721A.ownerOf(tokenId);
846         if (to == owner) revert ApprovalToCurrentOwner();
847 
848         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
849             revert ApprovalCallerNotOwnerNorApproved();
850         }
851 
852         _approve(to, tokenId, owner);
853     }
854 
855     /**
856      * @dev See {IERC721-getApproved}.
857      */
858     function getApproved(uint256 tokenId) public view override returns (address) {
859         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     /**
865      * @dev See {IERC721-setApprovalForAll}.
866      */
867     function setApprovalForAll(address operator, bool approved) public virtual override {
868         if (operator == _msgSender()) revert ApproveToCaller();
869 
870         _operatorApprovals[_msgSender()][operator] = approved;
871         emit ApprovalForAll(_msgSender(), operator, approved);
872     }
873 
874     /**
875      * @dev See {IERC721-isApprovedForAll}.
876      */
877     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
878         return _operatorApprovals[owner][operator];
879     }
880 
881     /**
882      * @dev See {IERC721-transferFrom}.
883      */
884     function transferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         _transfer(from, to, tokenId);
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         safeTransferFrom(from, to, tokenId, '');
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) public virtual override {
912         _transfer(from, to, tokenId);
913         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
914             revert TransferToNonERC721ReceiverImplementer();
915         }
916     }
917 
918     /**
919      * @dev Returns whether `tokenId` exists.
920      *
921      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
922      *
923      * Tokens start existing when they are minted (`_mint`),
924      */
925     function _exists(uint256 tokenId) internal view returns (bool) {
926         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
927             !_ownerships[tokenId].burned;
928     }
929 
930     function _safeMint(address to, uint256 quantity) internal {
931         _safeMint(to, quantity, '');
932     }
933 
934     /**
935      * @dev Safely mints `quantity` tokens and transfers them to `to`.
936      *
937      * Requirements:
938      *
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
940      * - `quantity` must be greater than 0.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeMint(
945         address to,
946         uint256 quantity,
947         bytes memory _data
948     ) internal {
949         _mint(to, quantity, _data, true);
950     }
951 
952     /**
953      * @dev Mints `quantity` tokens and transfers them to `to`.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - `quantity` must be greater than 0.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _mint(
963         address to,
964         uint256 quantity,
965         bytes memory _data,
966         bool safe
967     ) internal {
968         uint256 startTokenId = _currentIndex;
969         if (to == address(0)) revert MintToZeroAddress();
970         if (quantity == 0) revert MintZeroQuantity();
971 
972         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
973 
974         // Overflows are incredibly unrealistic.
975         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
976         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
977         unchecked {
978             _addressData[to].balance += uint64(quantity);
979             _addressData[to].numberMinted += uint64(quantity);
980 
981             _ownerships[startTokenId].addr = to;
982             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
983 
984             uint256 updatedIndex = startTokenId;
985             uint256 end = updatedIndex + quantity;
986 
987             if (safe && to.isContract()) {
988                 do {
989                     emit Transfer(address(0), to, updatedIndex);
990                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
991                         revert TransferToNonERC721ReceiverImplementer();
992                     }
993                 } while (updatedIndex != end);
994                 // Reentrancy protection
995                 if (_currentIndex != startTokenId) revert();
996             } else {
997                 do {
998                     emit Transfer(address(0), to, updatedIndex++);
999                 } while (updatedIndex != end);
1000             }
1001             _currentIndex = updatedIndex;
1002         }
1003         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1004     }
1005 
1006     /**
1007      * @dev Transfers `tokenId` from `from` to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must be owned by `from`.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) private {
1021         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1022 
1023         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1024 
1025         bool isApprovedOrOwner = (_msgSender() == from ||
1026             isApprovedForAll(from, _msgSender()) ||
1027             getApproved(tokenId) == _msgSender());
1028 
1029         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1030         if (to == address(0)) revert TransferToZeroAddress();
1031 
1032         _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId, from);
1036 
1037         // Underflow of the sender's balance is impossible because we check for
1038         // ownership above and the recipient's balance can't realistically overflow.
1039         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1040         unchecked {
1041             _addressData[from].balance -= 1;
1042             _addressData[to].balance += 1;
1043 
1044             TokenOwnership storage currSlot = _ownerships[tokenId];
1045             currSlot.addr = to;
1046             currSlot.startTimestamp = uint64(block.timestamp);
1047 
1048             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1049             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1050             uint256 nextTokenId = tokenId + 1;
1051             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1052             if (nextSlot.addr == address(0)) {
1053                 // This will suffice for checking _exists(nextTokenId),
1054                 // as a burned slot cannot contain the zero address.
1055                 if (nextTokenId != _currentIndex) {
1056                     nextSlot.addr = from;
1057                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1058                 }
1059             }
1060         }
1061 
1062         emit Transfer(from, to, tokenId);
1063         _afterTokenTransfers(from, to, tokenId, 1);
1064     }
1065 
1066     /**
1067      * @dev This is equivalent to _burn(tokenId, false)
1068      */
1069     function _burn(uint256 tokenId) internal virtual {
1070         _burn(tokenId, false);
1071     }
1072 
1073     /**
1074      * @dev Destroys `tokenId`.
1075      * The approval is cleared when the token is burned.
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must exist.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1084         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1085 
1086         address from = prevOwnership.addr;
1087 
1088         if (approvalCheck) {
1089             bool isApprovedOrOwner = (_msgSender() == from ||
1090                 isApprovedForAll(from, _msgSender()) ||
1091                 getApproved(tokenId) == _msgSender());
1092 
1093             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1094         }
1095 
1096         _beforeTokenTransfers(from, address(0), tokenId, 1);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId, from);
1100 
1101         // Underflow of the sender's balance is impossible because we check for
1102         // ownership above and the recipient's balance can't realistically overflow.
1103         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1104         unchecked {
1105             AddressData storage addressData = _addressData[from];
1106             addressData.balance -= 1;
1107             addressData.numberBurned += 1;
1108 
1109             // Keep track of who burned the token, and the timestamp of burning.
1110             TokenOwnership storage currSlot = _ownerships[tokenId];
1111             currSlot.addr = from;
1112             currSlot.startTimestamp = uint64(block.timestamp);
1113             currSlot.burned = true;
1114 
1115             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1116             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1117             uint256 nextTokenId = tokenId + 1;
1118             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1119             if (nextSlot.addr == address(0)) {
1120                 // This will suffice for checking _exists(nextTokenId),
1121                 // as a burned slot cannot contain the zero address.
1122                 if (nextTokenId != _currentIndex) {
1123                     nextSlot.addr = from;
1124                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1125                 }
1126             }
1127         }
1128 
1129         emit Transfer(from, address(0), tokenId);
1130         _afterTokenTransfers(from, address(0), tokenId, 1);
1131 
1132         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1133         unchecked {
1134             _burnCounter++;
1135         }
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits a {Approval} event.
1142      */
1143     function _approve(
1144         address to,
1145         uint256 tokenId,
1146         address owner
1147     ) private {
1148         _tokenApprovals[tokenId] = to;
1149         emit Approval(owner, to, tokenId);
1150     }
1151 
1152     /**
1153      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1154      *
1155      * @param from address representing the previous owner of the given token ID
1156      * @param to target address that will receive the tokens
1157      * @param tokenId uint256 ID of the token to be transferred
1158      * @param _data bytes optional data to send along with the call
1159      * @return bool whether the call correctly returned the expected magic value
1160      */
1161     function _checkContractOnERC721Received(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) private returns (bool) {
1167         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1168             return retval == IERC721Receiver(to).onERC721Received.selector;
1169         } catch (bytes memory reason) {
1170             if (reason.length == 0) {
1171                 revert TransferToNonERC721ReceiverImplementer();
1172             } else {
1173                 assembly {
1174                     revert(add(32, reason), mload(reason))
1175                 }
1176             }
1177         }
1178     }
1179 
1180     /**
1181      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1182      * And also called before burning one token.
1183      *
1184      * startTokenId - the first token id to be transferred
1185      * quantity - the amount to be transferred
1186      *
1187      * Calling conditions:
1188      *
1189      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1190      * transferred to `to`.
1191      * - When `from` is zero, `tokenId` will be minted for `to`.
1192      * - When `to` is zero, `tokenId` will be burned by `from`.
1193      * - `from` and `to` are never both zero.
1194      */
1195     function _beforeTokenTransfers(
1196         address from,
1197         address to,
1198         uint256 startTokenId,
1199         uint256 quantity
1200     ) internal virtual {}
1201 
1202     /**
1203      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1204      * minting.
1205      * And also called after one token has been burned.
1206      *
1207      * startTokenId - the first token id to be transferred
1208      * quantity - the amount to be transferred
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` has been minted for `to`.
1215      * - When `to` is zero, `tokenId` has been burned by `from`.
1216      * - `from` and `to` are never both zero.
1217      */
1218     function _afterTokenTransfers(
1219         address from,
1220         address to,
1221         uint256 startTokenId,
1222         uint256 quantity
1223     ) internal virtual {}
1224 }
1225 
1226 abstract contract Ownable is Context {
1227     address private _owner;
1228 
1229     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1230 
1231     /**
1232      * @dev Initializes the contract setting the deployer as the initial owner.
1233      */
1234     constructor() {
1235         _transferOwnership(_msgSender());
1236     }
1237 
1238     /**
1239      * @dev Returns the address of the current owner.
1240      */
1241     function owner() public view virtual returns (address) {
1242         return _owner;
1243     }
1244 
1245     /**
1246      * @dev Throws if called by any account other than the owner.
1247      */
1248     modifier onlyOwner() {
1249         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1250         _;
1251     }
1252 
1253     /**
1254      * @dev Leaves the contract without owner. It will not be possible to call
1255      * `onlyOwner` functions anymore. Can only be called by the current owner.
1256      *
1257      * NOTE: Renouncing ownership will leave the contract without an owner,
1258      * thereby removing any functionality that is only available to the owner.
1259      */
1260     function renounceOwnership() public virtual onlyOwner {
1261         _transferOwnership(address(0));
1262     }
1263 
1264     /**
1265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1266      * Can only be called by the current owner.
1267      */
1268     function transferOwnership(address newOwner) public virtual onlyOwner {
1269         require(newOwner != address(0), "Ownable: new owner is the zero address");
1270         _transferOwnership(newOwner);
1271     }
1272 
1273     /**
1274      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1275      * Internal function without access restriction.
1276      */
1277     function _transferOwnership(address newOwner) internal virtual {
1278         address oldOwner = _owner;
1279         _owner = newOwner;
1280         emit OwnershipTransferred(oldOwner, newOwner);
1281     }
1282 }
1283 pragma solidity ^0.8.13;
1284 
1285 interface IOperatorFilterRegistry {
1286     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1287     function register(address registrant) external;
1288     function registerAndSubscribe(address registrant, address subscription) external;
1289     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1290     function updateOperator(address registrant, address operator, bool filtered) external;
1291     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1292     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1293     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1294     function subscribe(address registrant, address registrantToSubscribe) external;
1295     function unsubscribe(address registrant, bool copyExistingEntries) external;
1296     function subscriptionOf(address addr) external returns (address registrant);
1297     function subscribers(address registrant) external returns (address[] memory);
1298     function subscriberAt(address registrant, uint256 index) external returns (address);
1299     function copyEntriesOf(address registrant, address registrantToCopy) external;
1300     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1301     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1302     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1303     function filteredOperators(address addr) external returns (address[] memory);
1304     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1305     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1306     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1307     function isRegistered(address addr) external returns (bool);
1308     function codeHashOf(address addr) external returns (bytes32);
1309 }
1310 pragma solidity ^0.8.13;
1311 
1312 
1313 
1314 abstract contract OperatorFilterer {
1315     error OperatorNotAllowed(address operator);
1316 
1317     IOperatorFilterRegistry constant operatorFilterRegistry =
1318         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1319 
1320     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1321         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1322         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1323         // order for the modifier to filter addresses.
1324         if (address(operatorFilterRegistry).code.length > 0) {
1325             if (subscribe) {
1326                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1327             } else {
1328                 if (subscriptionOrRegistrantToCopy != address(0)) {
1329                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1330                 } else {
1331                     operatorFilterRegistry.register(address(this));
1332                 }
1333             }
1334         }
1335     }
1336 
1337     modifier onlyAllowedOperator(address from) virtual {
1338         // Check registry code length to facilitate testing in environments without a deployed registry.
1339         if (address(operatorFilterRegistry).code.length > 0) {
1340             // Allow spending tokens from addresses with balance
1341             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1342             // from an EOA.
1343             if (from == msg.sender) {
1344                 _;
1345                 return;
1346             }
1347             if (
1348                 !(
1349                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1350                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1351                 )
1352             ) {
1353                 revert OperatorNotAllowed(msg.sender);
1354             }
1355         }
1356         _;
1357     }
1358 }
1359 pragma solidity ^0.8.13;
1360 
1361 
1362 
1363 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1364     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1365 
1366     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1367 }
1368     pragma solidity ^0.8.7;
1369     
1370     contract POPbyWARHOL is ERC721A, DefaultOperatorFilterer , Ownable {
1371     using Strings for uint256;
1372 
1373 
1374   string private uriPrefix ;
1375   string private uriSuffix = ".json";
1376   string public hiddenURL;
1377 
1378   
1379   
1380 
1381   uint256 public cost = 0 ether;
1382  
1383   
1384 
1385   uint16 public maxSupply = 333;
1386   uint8 public maxMintAmountPerTx = 1;
1387     uint8 public maxFreeMintAmountPerWallet = 1;
1388                                                              
1389  
1390   bool public paused = true;
1391   bool public reveal =false;
1392 
1393    mapping (address => uint8) public NFTPerPublicAddress;
1394 
1395  
1396   
1397   
1398  
1399   
1400 
1401   constructor() ERC721A("POP by WARHOL", "POP") {
1402   }
1403 
1404 
1405   
1406  
1407   function mint(uint8 _mintAmount) external payable  {
1408      uint16 totalSupply = uint16(totalSupply());
1409      uint8 nft = NFTPerPublicAddress[msg.sender];
1410     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1411     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1412 
1413     require(!paused, "The contract is paused!");
1414     
1415       if(nft >= maxFreeMintAmountPerWallet)
1416     {
1417     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1418     }
1419     else {
1420          uint8 costAmount = _mintAmount + nft;
1421         if(costAmount > maxFreeMintAmountPerWallet)
1422        {
1423         costAmount = costAmount - maxFreeMintAmountPerWallet;
1424         require(msg.value >= cost * costAmount, "Insufficient funds!");
1425        }
1426        
1427          
1428     }
1429     
1430 
1431 
1432     _safeMint(msg.sender , _mintAmount);
1433 
1434     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1435      
1436      delete totalSupply;
1437      delete _mintAmount;
1438   }
1439   
1440   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1441      uint16 totalSupply = uint16(totalSupply());
1442     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1443      _safeMint(_receiver , _mintAmount);
1444      delete _mintAmount;
1445      delete _receiver;
1446      delete totalSupply;
1447   }
1448 
1449   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1450      uint16 totalSupply = uint16(totalSupply());
1451      uint totalAmount =   _amountPerAddress * addresses.length;
1452     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1453      for (uint256 i = 0; i < addresses.length; i++) {
1454             _safeMint(addresses[i], _amountPerAddress);
1455         }
1456 
1457      delete _amountPerAddress;
1458      delete totalSupply;
1459   }
1460 
1461  
1462 
1463   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1464       maxSupply = _maxSupply;
1465   }
1466 
1467 
1468 
1469    
1470   function tokenURI(uint256 _tokenId)
1471     public
1472     view
1473     virtual
1474     override
1475     returns (string memory)
1476   {
1477     require(
1478       _exists(_tokenId),
1479       "ERC721Metadata: URI query for nonexistent token"
1480     );
1481     
1482   
1483 if ( reveal == false)
1484 {
1485     return hiddenURL;
1486 }
1487     
1488 
1489     string memory currentBaseURI = _baseURI();
1490     return bytes(currentBaseURI).length > 0
1491         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1492         : "";
1493   }
1494  
1495  
1496 
1497 
1498  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1499     maxFreeMintAmountPerWallet = _limit;
1500    delete _limit;
1501 
1502 }
1503 
1504     
1505   
1506 
1507   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1508     uriPrefix = _uriPrefix;
1509   }
1510    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1511     hiddenURL = _uriPrefix;
1512   }
1513 
1514 
1515   function setPaused() external onlyOwner {
1516     paused = !paused;
1517    
1518   }
1519 
1520   function setCost(uint _cost) external onlyOwner{
1521       cost = _cost;
1522 
1523   }
1524 
1525  function setRevealed() external onlyOwner{
1526      reveal = !reveal;
1527  }
1528 
1529   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1530       maxMintAmountPerTx = _maxtx;
1531 
1532   }
1533 
1534  
1535 
1536   function withdraw() external onlyOwner {
1537   uint _balance = address(this).balance;
1538      payable(msg.sender).transfer(_balance ); 
1539        
1540   }
1541 
1542 
1543   function _baseURI() internal view  override returns (string memory) {
1544     return uriPrefix;
1545   }
1546 
1547     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1548         super.transferFrom(from, to, tokenId);
1549     }
1550 
1551     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1552         super.safeTransferFrom(from, to, tokenId);
1553     }
1554 
1555     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1556         public
1557         override
1558         onlyAllowedOperator(from)
1559     {
1560         super.safeTransferFrom(from, to, tokenId, data);
1561     }
1562 }