1 /**
2   _________                              _____                 __                        
3  /   _____/__________    ____  ____     /     \   ____   ____ |  | __ ____ ___.__. ______
4  \_____  \\____ \__  \ _/ ___\/ __ \   /  \ /  \ /  _ \ /    \|  |/ // __ <   |  |/  ___/
5  /        \  |_> > __ \\  \__\  ___/  /    Y    (  <_> )   |  \    <\  ___/\___  |\___ \ 
6 /_______  /   __(____  /\___  >___  > \____|__  /\____/|___|  /__|_ \\___  > ____/____  >
7         \/|__|       \/     \/    \/          \/            \/     \/    \/\/         \/ 
8 
9 */
10 // @author divergence.xyz
11 // SPDX-License-Identifier: MIT 
12 // File: @openzeppelin/contracts/utils/Strings.sol
13 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Address.sol
81 
82 
83 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
84 
85 pragma solidity ^0.8.1;
86 
87 /**
88  * @dev Collection of functions related to the address type
89  */
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      *
108      * [IMPORTANT]
109      * ====
110      * You shouldn't rely on `isContract` to protect against flash loan attacks!
111      *
112      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
113      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
114      * constructor.
115      * ====
116      */
117     function isContract(address account) internal view returns (bool) {
118         // This method relies on extcodesize/address.code.length, which returns 0
119         // for contracts in construction, since the code is only stored at the end
120         // of the constructor execution.
121 
122         return account.code.length > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev Interface of the ERC165 standard, as defined in the
344  * https://eips.ethereum.org/EIPS/eip-165[EIP].
345  *
346  * Implementers can declare support of contract interfaces, which can then be
347  * queried by others ({ERC165Checker}).
348  *
349  * For an implementation, see {ERC165}.
350  */
351 interface IERC165 {
352     /**
353      * @dev Returns true if this contract implements the interface defined by
354      * `interfaceId`. See the corresponding
355      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
356      * to learn more about how these ids are created.
357      *
358      * This function call must use less than 30 000 gas.
359      */
360     function supportsInterface(bytes4 interfaceId) external view returns (bool);
361 }
362 
363 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 
371 /**
372  * @dev Implementation of the {IERC165} interface.
373  *
374  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
375  * for the additional interface id that will be supported. For example:
376  *
377  * ```solidity
378  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
380  * }
381  * ```
382  *
383  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
384  */
385 abstract contract ERC165 is IERC165 {
386     /**
387      * @dev See {IERC165-supportsInterface}.
388      */
389     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
390         return interfaceId == type(IERC165).interfaceId;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Required interface of an ERC721 compliant contract.
404  */
405 interface IERC721 is IERC165 {
406     /**
407      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
413      */
414     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
418      */
419     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
420 
421     /**
422      * @dev Returns the number of tokens in ``owner``'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
437      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Transfers `tokenId` token from `from` to `to`.
457      *
458      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      *
467      * Emits a {Transfer} event.
468      */
469     function transferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
477      * The approval is cleared when the token is transferred.
478      *
479      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
480      *
481      * Requirements:
482      *
483      * - The caller must own the token or be an approved operator.
484      * - `tokenId` must exist.
485      *
486      * Emits an {Approval} event.
487      */
488     function approve(address to, uint256 tokenId) external;
489 
490     /**
491      * @dev Returns the account approved for `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function getApproved(uint256 tokenId) external view returns (address operator);
498 
499     /**
500      * @dev Approve or remove `operator` as an operator for the caller.
501      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
502      *
503      * Requirements:
504      *
505      * - The `operator` cannot be the caller.
506      *
507      * Emits an {ApprovalForAll} event.
508      */
509     function setApprovalForAll(address operator, bool _approved) external;
510 
511     /**
512      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
513      *
514      * See {setApprovalForAll}
515      */
516     function isApprovedForAll(address owner, address operator) external view returns (bool);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId,
535         bytes calldata data
536     ) external;
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
549  * @dev See https://eips.ethereum.org/EIPS/eip-721
550  */
551 interface IERC721Metadata is IERC721 {
552     /**
553      * @dev Returns the token collection name.
554      */
555     function name() external view returns (string memory);
556 
557     /**
558      * @dev Returns the token collection symbol.
559      */
560     function symbol() external view returns (string memory);
561 
562     /**
563      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
564      */
565     function tokenURI(uint256 tokenId) external view returns (string memory);
566 }
567 
568 // File: @openzeppelin/contracts/utils/Context.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address) {
587         return msg.sender;
588     }
589 
590     function _msgData() internal view virtual returns (bytes calldata) {
591         return msg.data;
592     }
593 }
594 
595 // File: erc721a/contracts/ERC721A.sol
596 
597 
598 // Creator: Chiru Labs
599 
600 pragma solidity ^0.8.4;
601 
602 
603 
604 
605 
606 
607 
608 
609 error ApprovalCallerNotOwnerNorApproved();
610 error ApprovalQueryForNonexistentToken();
611 error ApproveToCaller();
612 error ApprovalToCurrentOwner();
613 error BalanceQueryForZeroAddress();
614 error MintToZeroAddress();
615 error MintZeroQuantity();
616 error OwnerQueryForNonexistentToken();
617 error TransferCallerNotOwnerNorApproved();
618 error TransferFromIncorrectOwner();
619 error TransferToNonERC721ReceiverImplementer();
620 error TransferToZeroAddress();
621 error URIQueryForNonexistentToken();
622 
623 /**
624  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
625  * the Metadata extension. Built to optimize for lower gas during batch mints.
626  *
627  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
628  *
629  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
630  *
631  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
632  */
633 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
634     using Address for address;
635     using Strings for uint256;
636 
637     // Compiler will pack this into a single 256bit word.
638     struct TokenOwnership {
639         // The address of the owner.
640         address addr;
641         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
642         uint64 startTimestamp;
643         // Whether the token has been burned.
644         bool burned;
645     }
646 
647     // Compiler will pack this into a single 256bit word.
648     struct AddressData {
649         // Realistically, 2**64-1 is more than enough.
650         uint64 balance;
651         // Keeps track of mint count with minimal overhead for tokenomics.
652         uint64 numberMinted;
653         // Keeps track of burn count with minimal overhead for tokenomics.
654         uint64 numberBurned;
655         // For miscellaneous variable(s) pertaining to the address
656         // (e.g. number of whitelist mint slots used).
657         // If there are multiple variables, please pack them into a uint64.
658         uint64 aux;
659     }
660 
661     // The tokenId of the next token to be minted.
662     uint256 internal _currentIndex;
663 
664     // The number of tokens burned.
665     uint256 internal _burnCounter;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to ownership details
674     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
675     mapping(uint256 => TokenOwnership) internal _ownerships;
676 
677     // Mapping owner address to address data
678     mapping(address => AddressData) private _addressData;
679 
680     // Mapping from token ID to approved address
681     mapping(uint256 => address) private _tokenApprovals;
682 
683     // Mapping from owner to operator approvals
684     mapping(address => mapping(address => bool)) private _operatorApprovals;
685 
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689         _currentIndex = _startTokenId();
690     }
691 
692     /**
693      * To change the starting tokenId, please override this function.
694      */
695     function _startTokenId() internal view virtual returns (uint256) {
696         return 0;
697     }
698 
699     /**
700      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
701      */
702     function totalSupply() public view returns (uint256) {
703         // Counter underflow is impossible as _burnCounter cannot be incremented
704         // more than _currentIndex - _startTokenId() times
705         unchecked {
706             return _currentIndex - _burnCounter - _startTokenId();
707         }
708     }
709 
710     /**
711      * Returns the total amount of tokens minted in the contract.
712      */
713     function _totalMinted() internal view returns (uint256) {
714         // Counter underflow is impossible as _currentIndex does not decrement,
715         // and it is initialized to _startTokenId()
716         unchecked {
717             return _currentIndex - _startTokenId();
718         }
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726             interfaceId == type(IERC721).interfaceId ||
727             interfaceId == type(IERC721Metadata).interfaceId ||
728             super.supportsInterface(interfaceId);
729     }
730 
731     /**
732      * @dev See {IERC721-balanceOf}.
733      */
734     function balanceOf(address owner) public view override returns (uint256) {
735         if (owner == address(0)) revert BalanceQueryForZeroAddress();
736         return uint256(_addressData[owner].balance);
737     }
738 
739     /**
740      * Returns the number of tokens minted by `owner`.
741      */
742     function _numberMinted(address owner) internal view returns (uint256) {
743         return uint256(_addressData[owner].numberMinted);
744     }
745 
746     /**
747      * Returns the number of tokens burned by or on behalf of `owner`.
748      */
749     function _numberBurned(address owner) internal view returns (uint256) {
750         return uint256(_addressData[owner].numberBurned);
751     }
752 
753     /**
754      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
755      */
756     function _getAux(address owner) internal view returns (uint64) {
757         return _addressData[owner].aux;
758     }
759 
760     /**
761      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
762      * If there are multiple variables, please pack them into a uint64.
763      */
764     function _setAux(address owner, uint64 aux) internal {
765         _addressData[owner].aux = aux;
766     }
767 
768     /**
769      * Gas spent here starts off proportional to the maximum mint batch size.
770      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
771      */
772     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
773         uint256 curr = tokenId;
774 
775         unchecked {
776             if (_startTokenId() <= curr && curr < _currentIndex) {
777                 TokenOwnership memory ownership = _ownerships[curr];
778                 if (!ownership.burned) {
779                     if (ownership.addr != address(0)) {
780                         return ownership;
781                     }
782                     // Invariant:
783                     // There will always be an ownership that has an address and is not burned
784                     // before an ownership that does not have an address and is not burned.
785                     // Hence, curr will not underflow.
786                     while (true) {
787                         curr--;
788                         ownership = _ownerships[curr];
789                         if (ownership.addr != address(0)) {
790                             return ownership;
791                         }
792                     }
793                 }
794             }
795         }
796         revert OwnerQueryForNonexistentToken();
797     }
798 
799     /**
800      * @dev See {IERC721-ownerOf}.
801      */
802     function ownerOf(uint256 tokenId) public view override returns (address) {
803         return _ownershipOf(tokenId).addr;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-name}.
808      */
809     function name() public view virtual override returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-symbol}.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-tokenURI}.
822      */
823     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
824         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
825 
826         string memory baseURI = _baseURI();
827         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
828     }
829 
830     /**
831      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
832      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
833      * by default, can be overriden in child contracts.
834      */
835     function _baseURI() internal view virtual returns (string memory) {
836         return '';
837     }
838 
839     /**
840      * @dev See {IERC721-approve}.
841      */
842     function approve(address to, uint256 tokenId) public override {
843         address owner = ERC721A.ownerOf(tokenId);
844         if (to == owner) revert ApprovalToCurrentOwner();
845 
846         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
847             revert ApprovalCallerNotOwnerNorApproved();
848         }
849 
850         _approve(to, tokenId, owner);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view override returns (address) {
857         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         if (operator == _msgSender()) revert ApproveToCaller();
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         _transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public virtual override {
910         _transfer(from, to, tokenId);
911         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
912             revert TransferToNonERC721ReceiverImplementer();
913         }
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      */
923     function _exists(uint256 tokenId) internal view returns (bool) {
924         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
925     }
926 
927     function _safeMint(address to, uint256 quantity) internal {
928         _safeMint(to, quantity, '');
929     }
930 
931     /**
932      * @dev Safely mints `quantity` tokens and transfers them to `to`.
933      *
934      * Requirements:
935      *
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
937      * - `quantity` must be greater than 0.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeMint(
942         address to,
943         uint256 quantity,
944         bytes memory _data
945     ) internal {
946         _mint(to, quantity, _data, true);
947     }
948 
949     /**
950      * @dev Mints `quantity` tokens and transfers them to `to`.
951      *
952      * Requirements:
953      *
954      * - `to` cannot be the zero address.
955      * - `quantity` must be greater than 0.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _mint(
960         address to,
961         uint256 quantity,
962         bytes memory _data,
963         bool safe
964     ) internal {
965         uint256 startTokenId = _currentIndex;
966         if (to == address(0)) revert MintToZeroAddress();
967         if (quantity == 0) revert MintZeroQuantity();
968 
969         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
970 
971         // Overflows are incredibly unrealistic.
972         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
973         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
974         unchecked {
975             _addressData[to].balance += uint64(quantity);
976             _addressData[to].numberMinted += uint64(quantity);
977 
978             _ownerships[startTokenId].addr = to;
979             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
980 
981             uint256 updatedIndex = startTokenId;
982             uint256 end = updatedIndex + quantity;
983 
984             if (safe && to.isContract()) {
985                 do {
986                     emit Transfer(address(0), to, updatedIndex);
987                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
988                         revert TransferToNonERC721ReceiverImplementer();
989                     }
990                 } while (updatedIndex != end);
991                 // Reentrancy protection
992                 if (_currentIndex != startTokenId) revert();
993             } else {
994                 do {
995                     emit Transfer(address(0), to, updatedIndex++);
996                 } while (updatedIndex != end);
997             }
998             _currentIndex = updatedIndex;
999         }
1000         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1001     }
1002 
1003     /**
1004      * @dev Transfers `tokenId` from `from` to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must be owned by `from`.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _transfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) private {
1018         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1019 
1020         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1021 
1022         bool isApprovedOrOwner = (_msgSender() == from ||
1023             isApprovedForAll(from, _msgSender()) ||
1024             getApproved(tokenId) == _msgSender());
1025 
1026         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1027         if (to == address(0)) revert TransferToZeroAddress();
1028 
1029         _beforeTokenTransfers(from, to, tokenId, 1);
1030 
1031         // Clear approvals from the previous owner
1032         _approve(address(0), tokenId, from);
1033 
1034         // Underflow of the sender's balance is impossible because we check for
1035         // ownership above and the recipient's balance can't realistically overflow.
1036         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1037         unchecked {
1038             _addressData[from].balance -= 1;
1039             _addressData[to].balance += 1;
1040 
1041             TokenOwnership storage currSlot = _ownerships[tokenId];
1042             currSlot.addr = to;
1043             currSlot.startTimestamp = uint64(block.timestamp);
1044 
1045             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1046             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1047             uint256 nextTokenId = tokenId + 1;
1048             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1049             if (nextSlot.addr == address(0)) {
1050                 // This will suffice for checking _exists(nextTokenId),
1051                 // as a burned slot cannot contain the zero address.
1052                 if (nextTokenId != _currentIndex) {
1053                     nextSlot.addr = from;
1054                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1055                 }
1056             }
1057         }
1058 
1059         emit Transfer(from, to, tokenId);
1060         _afterTokenTransfers(from, to, tokenId, 1);
1061     }
1062 
1063     /**
1064      * @dev This is equivalent to _burn(tokenId, false)
1065      */
1066     function _burn(uint256 tokenId) internal virtual {
1067         _burn(tokenId, false);
1068     }
1069 
1070     /**
1071      * @dev Destroys `tokenId`.
1072      * The approval is cleared when the token is burned.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1081         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1082 
1083         address from = prevOwnership.addr;
1084 
1085         if (approvalCheck) {
1086             bool isApprovedOrOwner = (_msgSender() == from ||
1087                 isApprovedForAll(from, _msgSender()) ||
1088                 getApproved(tokenId) == _msgSender());
1089 
1090             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1091         }
1092 
1093         _beforeTokenTransfers(from, address(0), tokenId, 1);
1094 
1095         // Clear approvals from the previous owner
1096         _approve(address(0), tokenId, from);
1097 
1098         // Underflow of the sender's balance is impossible because we check for
1099         // ownership above and the recipient's balance can't realistically overflow.
1100         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1101         unchecked {
1102             AddressData storage addressData = _addressData[from];
1103             addressData.balance -= 1;
1104             addressData.numberBurned += 1;
1105 
1106             // Keep track of who burned the token, and the timestamp of burning.
1107             TokenOwnership storage currSlot = _ownerships[tokenId];
1108             currSlot.addr = from;
1109             currSlot.startTimestamp = uint64(block.timestamp);
1110             currSlot.burned = true;
1111 
1112             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1113             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1114             uint256 nextTokenId = tokenId + 1;
1115             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1116             if (nextSlot.addr == address(0)) {
1117                 // This will suffice for checking _exists(nextTokenId),
1118                 // as a burned slot cannot contain the zero address.
1119                 if (nextTokenId != _currentIndex) {
1120                     nextSlot.addr = from;
1121                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1122                 }
1123             }
1124         }
1125 
1126         emit Transfer(from, address(0), tokenId);
1127         _afterTokenTransfers(from, address(0), tokenId, 1);
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
1225 
1226 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1227 
1228 pragma solidity ^0.8.0;
1229 
1230 
1231 /**
1232  * @dev Contract module which provides a basic access control mechanism, where
1233  * there is an account (an owner) that can be granted exclusive access to
1234  * specific functions.
1235  *
1236  * By default, the owner account will be the one that deploys the contract. This
1237  * can later be changed with {transferOwnership}.
1238  *
1239  * This module is used through inheritance. It will make available the modifier
1240  * `onlyOwner`, which can be applied to your functions to restrict their use to
1241  * the owner.
1242  */
1243 abstract contract Ownable is Context {
1244     address private _owner;
1245 
1246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1247 
1248     /**
1249      * @dev Initializes the contract setting the deployer as the initial owner.
1250      */
1251     constructor() {
1252         _transferOwnership(_msgSender());
1253     }
1254 
1255     /**
1256      * @dev Returns the address of the current owner.
1257      */
1258     function owner() public view virtual returns (address) {
1259         return _owner;
1260     }
1261 
1262     /**
1263      * @dev Throws if called by any account other than the owner.
1264      */
1265     modifier onlyOwner() {
1266         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1267         _;
1268     }
1269 
1270     /**
1271      * @dev Leaves the contract without owner. It will not be possible to call
1272      * `onlyOwner` functions anymore. Can only be called by the current owner.
1273      *
1274      * NOTE: Renouncing ownership will leave the contract without an owner,
1275      * thereby removing any functionality that is only available to the owner.
1276      */
1277     function renounceOwnership() public virtual onlyOwner {
1278         _transferOwnership(address(0));
1279     }
1280 
1281     /**
1282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1283      * Can only be called by the current owner.
1284      */
1285     function transferOwnership(address newOwner) public virtual onlyOwner {
1286         require(newOwner != address(0), "Ownable: new owner is the zero address");
1287         _transferOwnership(newOwner);
1288     }
1289 
1290     /**
1291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1292      * Internal function without access restriction.
1293      */
1294     function _transferOwnership(address newOwner) internal virtual {
1295         address oldOwner = _owner;
1296         _owner = newOwner;
1297         emit OwnershipTransferred(oldOwner, newOwner);
1298     }
1299 }
1300 
1301 // File: contracts/SpaceMonkeysNFT.sol
1302 
1303 
1304 pragma solidity >=0.8.0 <0.9.0;
1305 
1306 
1307 
1308 
1309 
1310 contract SpaceMonkeysNFT is ERC721A, Ownable { 
1311 
1312   using Strings for uint256;
1313 
1314   string public uriPrefix = "ipfs://QmW2skLdSsXxfwQjKYf7RN9pnp9DB171Gryz9HraJrLquQ/";
1315   string public uriSuffix = ".json"; 
1316   string public hiddenMetadataUri;
1317   
1318   uint256 public cost = 0.003 ether; 
1319 
1320   uint256 public maxSupply = 7000; 
1321   uint256 public maxMintAmountPerTx = 10; 
1322   uint256 public totalMaxMintAmount = 12; 
1323 
1324   uint256 public freeMaxMintAmount = 2; 
1325 
1326   bool public paused = true;
1327   bool public publicSale = false;
1328   bool public revealed = true;
1329 
1330   mapping(address => uint256) public addressMintedBalance; 
1331 
1332   constructor() ERC721A("Space Monkeys NFT", "SMONKEYS") { 
1333         setHiddenMetadataUri("ipfs://__CID__/hidden.json"); 
1334             ownerMint(50); 
1335     } 
1336 
1337   // MODIFIERS 
1338   
1339   modifier mintCompliance(uint256 _mintAmount) {
1340     if (msg.sender != owner()) { 
1341         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1342     }
1343     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1344     _;
1345   } 
1346 
1347   modifier mintPriceCompliance(uint256 _mintAmount) {
1348     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1349    if (ownerMintedCount >= freeMaxMintAmount) {
1350         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1351    }
1352         _;
1353   }
1354 
1355   // MINTS 
1356 
1357    function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1358     require(!paused, 'The contract is paused!'); 
1359     require(publicSale, "Not open to public yet!");
1360     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1361 
1362     if (ownerMintedCount < freeMaxMintAmount) {  
1363             require(ownerMintedCount + _mintAmount <= freeMaxMintAmount, "Exceeded Free Mint Limit");
1364         } else if (ownerMintedCount >= freeMaxMintAmount) { 
1365             require(ownerMintedCount + _mintAmount <= totalMaxMintAmount, "Exceeded Mint Limit");
1366         }
1367 
1368     _safeMint(_msgSender(), _mintAmount);
1369     for (uint256 i = 1; i <=_mintAmount; i++){
1370         addressMintedBalance[msg.sender]++;
1371     }
1372   }
1373 
1374   function ownerMint(uint256 _mintAmount) public payable onlyOwner {
1375      require(_mintAmount > 0, 'Invalid mint amount!');
1376      require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1377     _safeMint(_msgSender(), _mintAmount);
1378   }
1379 
1380 function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1381     _safeMint(_receiver, _mintAmount);
1382   }
1383   
1384   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1385     uint256 ownerTokenCount = balanceOf(_owner);
1386     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1387     uint256 currentTokenId = _startTokenId();
1388     uint256 ownedTokenIndex = 0;
1389     address latestOwnerAddress;
1390 
1391     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1392       TokenOwnership memory ownership = _ownerships[currentTokenId];
1393 
1394       if (!ownership.burned && ownership.addr != address(0)) {
1395         latestOwnerAddress = ownership.addr;
1396       }
1397 
1398       if (latestOwnerAddress == _owner) {
1399         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1400 
1401         ownedTokenIndex++;
1402       }
1403 
1404       currentTokenId++;
1405     }
1406 
1407     return ownedTokenIds;
1408   }
1409 
1410   function _startTokenId() internal view virtual override returns (uint256) {
1411     return 1;
1412   }
1413 
1414   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1415     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1416 
1417     if (revealed == false) {
1418       return hiddenMetadataUri;
1419     }
1420 
1421     string memory currentBaseURI = _baseURI();
1422     return bytes(currentBaseURI).length > 0
1423         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1424         : '';
1425   }
1426 
1427   function setRevealed(bool _state) public onlyOwner {
1428     revealed = _state;
1429   }
1430 
1431   function setCost(uint256 _cost) public onlyOwner {
1432     cost = _cost; 
1433   }
1434 
1435    function setFreeMaxMintAmount(uint256 _freeMaxMintAmount) public onlyOwner {
1436     freeMaxMintAmount = _freeMaxMintAmount; 
1437   }
1438 
1439   function setTotalMaxMintAmount(uint _amount) public onlyOwner {
1440       require(_amount <= maxSupply, "Exceed total amount");
1441       totalMaxMintAmount = _amount;
1442   }
1443 
1444   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1445     maxMintAmountPerTx = _maxMintAmountPerTx;
1446   }
1447 
1448   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1449     hiddenMetadataUri = _hiddenMetadataUri;
1450   }
1451 
1452   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1453     uriPrefix = _uriPrefix;
1454   }
1455 
1456   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1457     uriSuffix = _uriSuffix;
1458   }
1459 
1460   function setPaused(bool _state) public onlyOwner {
1461     paused = _state;
1462   }
1463 
1464   function setPublicSale(bool _state) public onlyOwner {
1465     publicSale = _state;
1466   }
1467 
1468   // WITHDRAW
1469     function withdraw() public payable onlyOwner {
1470   
1471     (bool os, ) = payable(owner()).call{value: address(this).balance}(""); 
1472     require(os);
1473    
1474   }
1475 
1476   function _baseURI() internal view virtual override returns (string memory) {
1477     return uriPrefix;
1478   }
1479 }