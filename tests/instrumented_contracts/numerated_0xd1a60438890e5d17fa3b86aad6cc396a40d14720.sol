1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
4 
5 // 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
33 
34 // 
35 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId,
89         bytes calldata data
90     ) external;
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
178 
179 // 
180 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
209 
210 // 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
238 
239 // 
240 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
464 
465 // 
466 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes calldata) {
486         return msg.data;
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
492 
493 // 
494 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev String operations.
500  */
501 library Strings {
502     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
506      */
507     function toString(uint256 value) internal pure returns (string memory) {
508         // Inspired by OraclizeAPI's implementation - MIT licence
509         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
510 
511         if (value == 0) {
512             return "0";
513         }
514         uint256 temp = value;
515         uint256 digits;
516         while (temp != 0) {
517             digits++;
518             temp /= 10;
519         }
520         bytes memory buffer = new bytes(digits);
521         while (value != 0) {
522             digits -= 1;
523             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
524             value /= 10;
525         }
526         return string(buffer);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
531      */
532     function toHexString(uint256 value) internal pure returns (string memory) {
533         if (value == 0) {
534             return "0x00";
535         }
536         uint256 temp = value;
537         uint256 length = 0;
538         while (temp != 0) {
539             length++;
540             temp >>= 8;
541         }
542         return toHexString(value, length);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
547      */
548     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
549         bytes memory buffer = new bytes(2 * length + 2);
550         buffer[0] = "0";
551         buffer[1] = "x";
552         for (uint256 i = 2 * length + 1; i > 1; --i) {
553             buffer[i] = _HEX_SYMBOLS[value & 0xf];
554             value >>= 4;
555         }
556         require(value == 0, "Strings: hex length insufficient");
557         return string(buffer);
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
563 
564 // 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Implementation of the {IERC165} interface.
571  *
572  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
573  * for the additional interface id that will be supported. For example:
574  *
575  * ```solidity
576  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
578  * }
579  * ```
580  *
581  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
582  */
583 abstract contract ERC165 is IERC165 {
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         return interfaceId == type(IERC165).interfaceId;
589     }
590 }
591 
592 
593 // File erc721a/contracts/ERC721A.sol@v3.2.0
594 
595 // 
596 // Creator: Chiru Labs
597 
598 pragma solidity ^0.8.4;
599 
600 
601 
602 
603 
604 
605 
606 error ApprovalCallerNotOwnerNorApproved();
607 error ApprovalQueryForNonexistentToken();
608 error ApproveToCaller();
609 error ApprovalToCurrentOwner();
610 error BalanceQueryForZeroAddress();
611 error MintToZeroAddress();
612 error MintZeroQuantity();
613 error OwnerQueryForNonexistentToken();
614 error TransferCallerNotOwnerNorApproved();
615 error TransferFromIncorrectOwner();
616 error TransferToNonERC721ReceiverImplementer();
617 error TransferToZeroAddress();
618 error URIQueryForNonexistentToken();
619 
620 /**
621  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
622  * the Metadata extension. Built to optimize for lower gas during batch mints.
623  *
624  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
625  *
626  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
627  *
628  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
629  */
630 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
631     using Address for address;
632     using Strings for uint256;
633 
634     // Compiler will pack this into a single 256bit word.
635     struct TokenOwnership {
636         // The address of the owner.
637         address addr;
638         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
639         uint64 startTimestamp;
640         // Whether the token has been burned.
641         bool burned;
642     }
643 
644     // Compiler will pack this into a single 256bit word.
645     struct AddressData {
646         // Realistically, 2**64-1 is more than enough.
647         uint64 balance;
648         // Keeps track of mint count with minimal overhead for tokenomics.
649         uint64 numberMinted;
650         // Keeps track of burn count with minimal overhead for tokenomics.
651         uint64 numberBurned;
652         // For miscellaneous variable(s) pertaining to the address
653         // (e.g. number of whitelist mint slots used).
654         // If there are multiple variables, please pack them into a uint64.
655         uint64 aux;
656     }
657 
658     // The tokenId of the next token to be minted.
659     uint256 internal _currentIndex;
660 
661     // The number of tokens burned.
662     uint256 internal _burnCounter;
663 
664     // Token name
665     string private _name;
666 
667     // Token symbol
668     string private _symbol;
669 
670     // Mapping from token ID to ownership details
671     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
672     mapping(uint256 => TokenOwnership) internal _ownerships;
673 
674     // Mapping owner address to address data
675     mapping(address => AddressData) private _addressData;
676 
677     // Mapping from token ID to approved address
678     mapping(uint256 => address) private _tokenApprovals;
679 
680     // Mapping from owner to operator approvals
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     constructor(string memory name_, string memory symbol_) {
684         _name = name_;
685         _symbol = symbol_;
686         _currentIndex = _startTokenId();
687     }
688 
689     /**
690      * To change the starting tokenId, please override this function.
691      */
692     function _startTokenId() internal view virtual returns (uint256) {
693         return 0;
694     }
695 
696     /**
697      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
698      */
699     function totalSupply() public view returns (uint256) {
700         // Counter underflow is impossible as _burnCounter cannot be incremented
701         // more than _currentIndex - _startTokenId() times
702         unchecked {
703             return _currentIndex - _burnCounter - _startTokenId();
704         }
705     }
706 
707     /**
708      * Returns the total amount of tokens minted in the contract.
709      */
710     function _totalMinted() internal view returns (uint256) {
711         // Counter underflow is impossible as _currentIndex does not decrement,
712         // and it is initialized to _startTokenId()
713         unchecked {
714             return _currentIndex - _startTokenId();
715         }
716     }
717 
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
722         return
723             interfaceId == type(IERC721).interfaceId ||
724             interfaceId == type(IERC721Metadata).interfaceId ||
725             super.supportsInterface(interfaceId);
726     }
727 
728     /**
729      * @dev See {IERC721-balanceOf}.
730      */
731     function balanceOf(address owner) public view override returns (uint256) {
732         if (owner == address(0)) revert BalanceQueryForZeroAddress();
733         return uint256(_addressData[owner].balance);
734     }
735 
736     /**
737      * Returns the number of tokens minted by `owner`.
738      */
739     function _numberMinted(address owner) internal view returns (uint256) {
740         return uint256(_addressData[owner].numberMinted);
741     }
742 
743     /**
744      * Returns the number of tokens burned by or on behalf of `owner`.
745      */
746     function _numberBurned(address owner) internal view returns (uint256) {
747         return uint256(_addressData[owner].numberBurned);
748     }
749 
750     /**
751      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
752      */
753     function _getAux(address owner) internal view returns (uint64) {
754         return _addressData[owner].aux;
755     }
756 
757     /**
758      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
759      * If there are multiple variables, please pack them into a uint64.
760      */
761     function _setAux(address owner, uint64 aux) internal {
762         _addressData[owner].aux = aux;
763     }
764 
765     /**
766      * Gas spent here starts off proportional to the maximum mint batch size.
767      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
768      */
769     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
770         uint256 curr = tokenId;
771 
772         unchecked {
773             if (_startTokenId() <= curr && curr < _currentIndex) {
774                 TokenOwnership memory ownership = _ownerships[curr];
775                 if (!ownership.burned) {
776                     if (ownership.addr != address(0)) {
777                         return ownership;
778                     }
779                     // Invariant:
780                     // There will always be an ownership that has an address and is not burned
781                     // before an ownership that does not have an address and is not burned.
782                     // Hence, curr will not underflow.
783                     while (true) {
784                         curr--;
785                         ownership = _ownerships[curr];
786                         if (ownership.addr != address(0)) {
787                             return ownership;
788                         }
789                     }
790                 }
791             }
792         }
793         revert OwnerQueryForNonexistentToken();
794     }
795 
796     /**
797      * @dev See {IERC721-ownerOf}.
798      */
799     function ownerOf(uint256 tokenId) public view override returns (address) {
800         return _ownershipOf(tokenId).addr;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-name}.
805      */
806     function name() public view virtual override returns (string memory) {
807         return _name;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-symbol}.
812      */
813     function symbol() public view virtual override returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-tokenURI}.
819      */
820     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
821         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
822 
823         string memory baseURI = _baseURI();
824         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
825     }
826 
827     /**
828      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
829      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
830      * by default, can be overriden in child contracts.
831      */
832     function _baseURI() internal view virtual returns (string memory) {
833         return '';
834     }
835 
836     /**
837      * @dev See {IERC721-approve}.
838      */
839     function approve(address to, uint256 tokenId) public override {
840         address owner = ERC721A.ownerOf(tokenId);
841         if (to == owner) revert ApprovalToCurrentOwner();
842 
843         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
844             revert ApprovalCallerNotOwnerNorApproved();
845         }
846 
847         _approve(to, tokenId, owner);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view override returns (address) {
854         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         if (operator == _msgSender()) revert ApproveToCaller();
864 
865         _operatorApprovals[_msgSender()][operator] = approved;
866         emit ApprovalForAll(_msgSender(), operator, approved);
867     }
868 
869     /**
870      * @dev See {IERC721-isApprovedForAll}.
871      */
872     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
873         return _operatorApprovals[owner][operator];
874     }
875 
876     /**
877      * @dev See {IERC721-transferFrom}.
878      */
879     function transferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, '');
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public virtual override {
907         _transfer(from, to, tokenId);
908         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
909             revert TransferToNonERC721ReceiverImplementer();
910         }
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      */
920     function _exists(uint256 tokenId) internal view returns (bool) {
921         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
922     }
923 
924     function _safeMint(address to, uint256 quantity) internal {
925         _safeMint(to, quantity, '');
926     }
927 
928     /**
929      * @dev Safely mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _safeMint(
939         address to,
940         uint256 quantity,
941         bytes memory _data
942     ) internal {
943         _mint(to, quantity, _data, true);
944     }
945 
946     /**
947      * @dev Mints `quantity` tokens and transfers them to `to`.
948      *
949      * Requirements:
950      *
951      * - `to` cannot be the zero address.
952      * - `quantity` must be greater than 0.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _mint(
957         address to,
958         uint256 quantity,
959         bytes memory _data,
960         bool safe
961     ) internal {
962         uint256 startTokenId = _currentIndex;
963         if (to == address(0)) revert MintToZeroAddress();
964         if (quantity == 0) revert MintZeroQuantity();
965 
966         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
967 
968         // Overflows are incredibly unrealistic.
969         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
970         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
971         unchecked {
972             _addressData[to].balance += uint64(quantity);
973             _addressData[to].numberMinted += uint64(quantity);
974 
975             _ownerships[startTokenId].addr = to;
976             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
977 
978             uint256 updatedIndex = startTokenId;
979             uint256 end = updatedIndex + quantity;
980 
981             if (safe && to.isContract()) {
982                 do {
983                     emit Transfer(address(0), to, updatedIndex);
984                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
985                         revert TransferToNonERC721ReceiverImplementer();
986                     }
987                 } while (updatedIndex != end);
988                 // Reentrancy protection
989                 if (_currentIndex != startTokenId) revert();
990             } else {
991                 do {
992                     emit Transfer(address(0), to, updatedIndex++);
993                 } while (updatedIndex != end);
994             }
995             _currentIndex = updatedIndex;
996         }
997         _afterTokenTransfers(address(0), to, startTokenId, quantity);
998     }
999 
1000     /**
1001      * @dev Transfers `tokenId` from `from` to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _transfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) private {
1015         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1016 
1017         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1018 
1019         bool isApprovedOrOwner = (_msgSender() == from ||
1020             isApprovedForAll(from, _msgSender()) ||
1021             getApproved(tokenId) == _msgSender());
1022 
1023         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1024         if (to == address(0)) revert TransferToZeroAddress();
1025 
1026         _beforeTokenTransfers(from, to, tokenId, 1);
1027 
1028         // Clear approvals from the previous owner
1029         _approve(address(0), tokenId, from);
1030 
1031         // Underflow of the sender's balance is impossible because we check for
1032         // ownership above and the recipient's balance can't realistically overflow.
1033         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1034         unchecked {
1035             _addressData[from].balance -= 1;
1036             _addressData[to].balance += 1;
1037 
1038             TokenOwnership storage currSlot = _ownerships[tokenId];
1039             currSlot.addr = to;
1040             currSlot.startTimestamp = uint64(block.timestamp);
1041 
1042             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1043             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1044             uint256 nextTokenId = tokenId + 1;
1045             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1046             if (nextSlot.addr == address(0)) {
1047                 // This will suffice for checking _exists(nextTokenId),
1048                 // as a burned slot cannot contain the zero address.
1049                 if (nextTokenId != _currentIndex) {
1050                     nextSlot.addr = from;
1051                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1052                 }
1053             }
1054         }
1055 
1056         emit Transfer(from, to, tokenId);
1057         _afterTokenTransfers(from, to, tokenId, 1);
1058     }
1059 
1060     /**
1061      * @dev This is equivalent to _burn(tokenId, false)
1062      */
1063     function _burn(uint256 tokenId) internal virtual {
1064         _burn(tokenId, false);
1065     }
1066 
1067     /**
1068      * @dev Destroys `tokenId`.
1069      * The approval is cleared when the token is burned.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1078         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1079 
1080         address from = prevOwnership.addr;
1081 
1082         if (approvalCheck) {
1083             bool isApprovedOrOwner = (_msgSender() == from ||
1084                 isApprovedForAll(from, _msgSender()) ||
1085                 getApproved(tokenId) == _msgSender());
1086 
1087             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1088         }
1089 
1090         _beforeTokenTransfers(from, address(0), tokenId, 1);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId, from);
1094 
1095         // Underflow of the sender's balance is impossible because we check for
1096         // ownership above and the recipient's balance can't realistically overflow.
1097         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1098         unchecked {
1099             AddressData storage addressData = _addressData[from];
1100             addressData.balance -= 1;
1101             addressData.numberBurned += 1;
1102 
1103             // Keep track of who burned the token, and the timestamp of burning.
1104             TokenOwnership storage currSlot = _ownerships[tokenId];
1105             currSlot.addr = from;
1106             currSlot.startTimestamp = uint64(block.timestamp);
1107             currSlot.burned = true;
1108 
1109             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1110             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1111             uint256 nextTokenId = tokenId + 1;
1112             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1113             if (nextSlot.addr == address(0)) {
1114                 // This will suffice for checking _exists(nextTokenId),
1115                 // as a burned slot cannot contain the zero address.
1116                 if (nextTokenId != _currentIndex) {
1117                     nextSlot.addr = from;
1118                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1119                 }
1120             }
1121         }
1122 
1123         emit Transfer(from, address(0), tokenId);
1124         _afterTokenTransfers(from, address(0), tokenId, 1);
1125 
1126         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1127         unchecked {
1128             _burnCounter++;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Approve `to` to operate on `tokenId`
1134      *
1135      * Emits a {Approval} event.
1136      */
1137     function _approve(
1138         address to,
1139         uint256 tokenId,
1140         address owner
1141     ) private {
1142         _tokenApprovals[tokenId] = to;
1143         emit Approval(owner, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1148      *
1149      * @param from address representing the previous owner of the given token ID
1150      * @param to target address that will receive the tokens
1151      * @param tokenId uint256 ID of the token to be transferred
1152      * @param _data bytes optional data to send along with the call
1153      * @return bool whether the call correctly returned the expected magic value
1154      */
1155     function _checkContractOnERC721Received(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) private returns (bool) {
1161         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1162             return retval == IERC721Receiver(to).onERC721Received.selector;
1163         } catch (bytes memory reason) {
1164             if (reason.length == 0) {
1165                 revert TransferToNonERC721ReceiverImplementer();
1166             } else {
1167                 assembly {
1168                     revert(add(32, reason), mload(reason))
1169                 }
1170             }
1171         }
1172     }
1173 
1174     /**
1175      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1176      * And also called before burning one token.
1177      *
1178      * startTokenId - the first token id to be transferred
1179      * quantity - the amount to be transferred
1180      *
1181      * Calling conditions:
1182      *
1183      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1184      * transferred to `to`.
1185      * - When `from` is zero, `tokenId` will be minted for `to`.
1186      * - When `to` is zero, `tokenId` will be burned by `from`.
1187      * - `from` and `to` are never both zero.
1188      */
1189     function _beforeTokenTransfers(
1190         address from,
1191         address to,
1192         uint256 startTokenId,
1193         uint256 quantity
1194     ) internal virtual {}
1195 
1196     /**
1197      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1198      * minting.
1199      * And also called after one token has been burned.
1200      *
1201      * startTokenId - the first token id to be transferred
1202      * quantity - the amount to be transferred
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` has been minted for `to`.
1209      * - When `to` is zero, `tokenId` has been burned by `from`.
1210      * - `from` and `to` are never both zero.
1211      */
1212     function _afterTokenTransfers(
1213         address from,
1214         address to,
1215         uint256 startTokenId,
1216         uint256 quantity
1217     ) internal virtual {}
1218 }
1219 
1220 
1221 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v3.2.0
1222 
1223 // 
1224 // Creator: Chiru Labs
1225 
1226 pragma solidity ^0.8.4;
1227 
1228 error InvalidQueryRange();
1229 
1230 /**
1231  * @title ERC721A Queryable
1232  * @dev ERC721A subclass with convenience query functions.
1233  */
1234 abstract contract ERC721AQueryable is ERC721A {
1235     /**
1236      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1237      *
1238      * If the `tokenId` is out of bounds:
1239      *   - `addr` = `address(0)`
1240      *   - `startTimestamp` = `0`
1241      *   - `burned` = `false`
1242      *
1243      * If the `tokenId` is burned:
1244      *   - `addr` = `<Address of owner before token was burned>`
1245      *   - `startTimestamp` = `<Timestamp when token was burned>`
1246      *   - `burned = `true`
1247      *
1248      * Otherwise:
1249      *   - `addr` = `<Address of owner>`
1250      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1251      *   - `burned = `false`
1252      */
1253     function explicitOwnershipOf(uint256 tokenId) public view returns (TokenOwnership memory) {
1254         TokenOwnership memory ownership;
1255         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1256             return ownership;
1257         }
1258         ownership = _ownerships[tokenId];
1259         if (ownership.burned) {
1260             return ownership;
1261         }
1262         return _ownershipOf(tokenId);
1263     }
1264 
1265     /**
1266      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1267      * See {ERC721AQueryable-explicitOwnershipOf}
1268      */
1269     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory) {
1270         unchecked {
1271             uint256 tokenIdsLength = tokenIds.length;
1272             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1273             for (uint256 i; i != tokenIdsLength; ++i) {
1274                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1275             }
1276             return ownerships;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns an array of token IDs owned by `owner`,
1282      * in the range [`start`, `stop`)
1283      * (i.e. `start <= tokenId < stop`).
1284      *
1285      * This function allows for tokens to be queried if the collection
1286      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1287      *
1288      * Requirements:
1289      *
1290      * - `start` < `stop`
1291      */
1292     function tokensOfOwnerIn(
1293         address owner,
1294         uint256 start,
1295         uint256 stop
1296     ) external view returns (uint256[] memory) {
1297         unchecked {
1298             if (start >= stop) revert InvalidQueryRange();
1299             uint256 tokenIdsIdx;
1300             uint256 stopLimit = _currentIndex;
1301             // Set `start = max(start, _startTokenId())`.
1302             if (start < _startTokenId()) {
1303                 start = _startTokenId();
1304             }
1305             // Set `stop = min(stop, _currentIndex)`.
1306             if (stop > stopLimit) {
1307                 stop = stopLimit;
1308             }
1309             uint256 tokenIdsMaxLength = balanceOf(owner);
1310             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1311             // to cater for cases where `balanceOf(owner)` is too big.
1312             if (start < stop) {
1313                 uint256 rangeLength = stop - start;
1314                 if (rangeLength < tokenIdsMaxLength) {
1315                     tokenIdsMaxLength = rangeLength;
1316                 }
1317             } else {
1318                 tokenIdsMaxLength = 0;
1319             }
1320             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1321             if (tokenIdsMaxLength == 0) {
1322                 return tokenIds;
1323             }
1324             // We need to call `explicitOwnershipOf(start)`,
1325             // because the slot at `start` may not be initialized.
1326             TokenOwnership memory ownership = explicitOwnershipOf(start);
1327             address currOwnershipAddr;
1328             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1329             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1330             if (!ownership.burned) {
1331                 currOwnershipAddr = ownership.addr;
1332             }
1333             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1334                 ownership = _ownerships[i];
1335                 if (ownership.burned) {
1336                     continue;
1337                 }
1338                 if (ownership.addr != address(0)) {
1339                     currOwnershipAddr = ownership.addr;
1340                 }
1341                 if (currOwnershipAddr == owner) {
1342                     tokenIds[tokenIdsIdx++] = i;
1343                 }
1344             }
1345             // Downsize the array to fit.
1346             assembly {
1347                 mstore(tokenIds, tokenIdsIdx)
1348             }
1349             return tokenIds;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Returns an array of token IDs owned by `owner`.
1355      *
1356      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1357      * It is meant to be called off-chain.
1358      *
1359      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1360      * multiple smaller scans if the collection is large enough to cause
1361      * an out-of-gas error (10K pfp collections should be fine).
1362      */
1363     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1364         unchecked {
1365             uint256 tokenIdsIdx;
1366             address currOwnershipAddr;
1367             uint256 tokenIdsLength = balanceOf(owner);
1368             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1369             TokenOwnership memory ownership;
1370             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1371                 ownership = _ownerships[i];
1372                 if (ownership.burned) {
1373                     continue;
1374                 }
1375                 if (ownership.addr != address(0)) {
1376                     currOwnershipAddr = ownership.addr;
1377                 }
1378                 if (currOwnershipAddr == owner) {
1379                     tokenIds[tokenIdsIdx++] = i;
1380                 }
1381             }
1382             return tokenIds;
1383         }
1384     }
1385 }
1386 
1387 
1388 // File @openzeppelin/contracts/security/Pausable.sol@v4.6.0
1389 
1390 // 
1391 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 /**
1396  * @dev Contract module which allows children to implement an emergency stop
1397  * mechanism that can be triggered by an authorized account.
1398  *
1399  * This module is used through inheritance. It will make available the
1400  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1401  * the functions of your contract. Note that they will not be pausable by
1402  * simply including this module, only once the modifiers are put in place.
1403  */
1404 abstract contract Pausable is Context {
1405     /**
1406      * @dev Emitted when the pause is triggered by `account`.
1407      */
1408     event Paused(address account);
1409 
1410     /**
1411      * @dev Emitted when the pause is lifted by `account`.
1412      */
1413     event Unpaused(address account);
1414 
1415     bool private _paused;
1416 
1417     /**
1418      * @dev Initializes the contract in unpaused state.
1419      */
1420     constructor() {
1421         _paused = false;
1422     }
1423 
1424     /**
1425      * @dev Returns true if the contract is paused, and false otherwise.
1426      */
1427     function paused() public view virtual returns (bool) {
1428         return _paused;
1429     }
1430 
1431     /**
1432      * @dev Modifier to make a function callable only when the contract is not paused.
1433      *
1434      * Requirements:
1435      *
1436      * - The contract must not be paused.
1437      */
1438     modifier whenNotPaused() {
1439         require(!paused(), "Pausable: paused");
1440         _;
1441     }
1442 
1443     /**
1444      * @dev Modifier to make a function callable only when the contract is paused.
1445      *
1446      * Requirements:
1447      *
1448      * - The contract must be paused.
1449      */
1450     modifier whenPaused() {
1451         require(paused(), "Pausable: not paused");
1452         _;
1453     }
1454 
1455     /**
1456      * @dev Triggers stopped state.
1457      *
1458      * Requirements:
1459      *
1460      * - The contract must not be paused.
1461      */
1462     function _pause() internal virtual whenNotPaused {
1463         _paused = true;
1464         emit Paused(_msgSender());
1465     }
1466 
1467     /**
1468      * @dev Returns to normal state.
1469      *
1470      * Requirements:
1471      *
1472      * - The contract must be paused.
1473      */
1474     function _unpause() internal virtual whenPaused {
1475         _paused = false;
1476         emit Unpaused(_msgSender());
1477     }
1478 }
1479 
1480 
1481 // File erc721a/contracts/extensions/ERC721APausable.sol@v3.2.0
1482 
1483 // 
1484 // Creator: Chiru Labs
1485 
1486 pragma solidity ^0.8.4;
1487 
1488 
1489 error ContractPaused();
1490 
1491 /**
1492  * @dev ERC721A token with pausable token transfers, minting and burning.
1493  *
1494  * Based off of OpenZeppelin's ERC721Pausable extension.
1495  *
1496  * Useful for scenarios such as preventing trades until the end of an evaluation
1497  * period, or having an emergency switch for freezing all token transfers in the
1498  * event of a large bug.
1499  */
1500 abstract contract ERC721APausable is ERC721A, Pausable {
1501     /**
1502      * @dev See {ERC721A-_beforeTokenTransfers}.
1503      *
1504      * Requirements:
1505      *
1506      * - the contract must not be paused.
1507      */
1508     function _beforeTokenTransfers(
1509         address from,
1510         address to,
1511         uint256 startTokenId,
1512         uint256 quantity
1513     ) internal virtual override {
1514         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1515         if (paused()) revert ContractPaused();
1516     }
1517 }
1518 
1519 
1520 // File erc721a/contracts/extensions/ERC721ABurnable.sol@v3.2.0
1521 
1522 // 
1523 // Creator: Chiru Labs
1524 
1525 pragma solidity ^0.8.4;
1526 
1527 /**
1528  * @title ERC721A Burnable Token
1529  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1530  */
1531 abstract contract ERC721ABurnable is ERC721A {
1532     /**
1533      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1534      *
1535      * Requirements:
1536      *
1537      * - The caller must own `tokenId` or be an approved operator.
1538      */
1539     function burn(uint256 tokenId) public virtual {
1540         _burn(tokenId, true);
1541     }
1542 }
1543 
1544 
1545 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1546 
1547 // 
1548 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1549 
1550 pragma solidity ^0.8.0;
1551 
1552 /**
1553  * @dev Contract module which provides a basic access control mechanism, where
1554  * there is an account (an owner) that can be granted exclusive access to
1555  * specific functions.
1556  *
1557  * By default, the owner account will be the one that deploys the contract. This
1558  * can later be changed with {transferOwnership}.
1559  *
1560  * This module is used through inheritance. It will make available the modifier
1561  * `onlyOwner`, which can be applied to your functions to restrict their use to
1562  * the owner.
1563  */
1564 abstract contract Ownable is Context {
1565     address private _owner;
1566 
1567     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1568 
1569     /**
1570      * @dev Initializes the contract setting the deployer as the initial owner.
1571      */
1572     constructor() {
1573         _transferOwnership(_msgSender());
1574     }
1575 
1576     /**
1577      * @dev Returns the address of the current owner.
1578      */
1579     function owner() public view virtual returns (address) {
1580         return _owner;
1581     }
1582 
1583     /**
1584      * @dev Throws if called by any account other than the owner.
1585      */
1586     modifier onlyOwner() {
1587         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1588         _;
1589     }
1590 
1591     /**
1592      * @dev Leaves the contract without owner. It will not be possible to call
1593      * `onlyOwner` functions anymore. Can only be called by the current owner.
1594      *
1595      * NOTE: Renouncing ownership will leave the contract without an owner,
1596      * thereby removing any functionality that is only available to the owner.
1597      */
1598     function renounceOwnership() public virtual onlyOwner {
1599         _transferOwnership(address(0));
1600     }
1601 
1602     /**
1603      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1604      * Can only be called by the current owner.
1605      */
1606     function transferOwnership(address newOwner) public virtual onlyOwner {
1607         require(newOwner != address(0), "Ownable: new owner is the zero address");
1608         _transferOwnership(newOwner);
1609     }
1610 
1611     /**
1612      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1613      * Internal function without access restriction.
1614      */
1615     function _transferOwnership(address newOwner) internal virtual {
1616         address oldOwner = _owner;
1617         _owner = newOwner;
1618         emit OwnershipTransferred(oldOwner, newOwner);
1619     }
1620 }
1621 
1622 
1623 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
1624 
1625 // 
1626 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1627 
1628 pragma solidity ^0.8.0;
1629 
1630 /**
1631  * @dev Contract module that helps prevent reentrant calls to a function.
1632  *
1633  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1634  * available, which can be applied to functions to make sure there are no nested
1635  * (reentrant) calls to them.
1636  *
1637  * Note that because there is a single `nonReentrant` guard, functions marked as
1638  * `nonReentrant` may not call one another. This can be worked around by making
1639  * those functions `private`, and then adding `external` `nonReentrant` entry
1640  * points to them.
1641  *
1642  * TIP: If you would like to learn more about reentrancy and alternative ways
1643  * to protect against it, check out our blog post
1644  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1645  */
1646 abstract contract ReentrancyGuard {
1647     // Booleans are more expensive than uint256 or any type that takes up a full
1648     // word because each write operation emits an extra SLOAD to first read the
1649     // slot's contents, replace the bits taken up by the boolean, and then write
1650     // back. This is the compiler's defense against contract upgrades and
1651     // pointer aliasing, and it cannot be disabled.
1652 
1653     // The values being non-zero value makes deployment a bit more expensive,
1654     // but in exchange the refund on every call to nonReentrant will be lower in
1655     // amount. Since refunds are capped to a percentage of the total
1656     // transaction's gas, it is best to keep them low in cases like this one, to
1657     // increase the likelihood of the full refund coming into effect.
1658     uint256 private constant _NOT_ENTERED = 1;
1659     uint256 private constant _ENTERED = 2;
1660 
1661     uint256 private _status;
1662 
1663     constructor() {
1664         _status = _NOT_ENTERED;
1665     }
1666 
1667     /**
1668      * @dev Prevents a contract from calling itself, directly or indirectly.
1669      * Calling a `nonReentrant` function from another `nonReentrant`
1670      * function is not supported. It is possible to prevent this from happening
1671      * by making the `nonReentrant` function external, and making it call a
1672      * `private` function that does the actual work.
1673      */
1674     modifier nonReentrant() {
1675         // On the first call to nonReentrant, _notEntered will be true
1676         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1677 
1678         // Any calls to nonReentrant after this point will fail
1679         _status = _ENTERED;
1680 
1681         _;
1682 
1683         // By storing the original value once again, a refund is triggered (see
1684         // https://eips.ethereum.org/EIPS/eip-2200)
1685         _status = _NOT_ENTERED;
1686     }
1687 }
1688 
1689 
1690 // File contracts/GoblinDickWTF.sol
1691 
1692 // 
1693 
1694 pragma solidity ^0.8.4;
1695 
1696 
1697 
1698 
1699 
1700 
1701 /**
1702 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0kdlclox0NMMMMMMMMM
1703 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo;.',;:::;;:oONMMMMMM
1704 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO:. .cxOOOOOkd:'.,xNMMMM
1705 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOc. .ck0000OOOo:dx:..c0WMM
1706 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXx;..;lkOOOO0000Oc;xOkl. .dNM
1707 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk;.;oxOOOOO000KKK0xxOOOko. .cX
1708 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKc.,oO0OOO000KKXXXXXKK0OOOOo. .o
1709 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXd'.:xOOO000KKXXXXXXXXXK00OOOO:  ;
1710 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO;..lkOO00KKXXXXXXXXXXXXKK0OOO0o. '
1711 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKl. 'oOO00KKXXXXXXXXXXXXXXK00OOO0x. '
1712 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNd'  ;xO000KXXXKKKKKXXXXXXXXK0OOOOOc  ,
1713 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOo;  .ck000KKKOddkO0000KKXXKKK00OOOkc. .x
1714 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo.   .oO00KKXXKOxl:cxOOO000KKK00OOOOc. .oN
1715 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk,    ;x000KXXXXXKK0kc:dOOOO00000OOOOl. .oNM
1716 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKl.  .,lk00KKXXXXXXXK00Ol,lkOOOOOOOOOkc. ,kNMM
1717 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk'   ,xO000KKXXXXXXXXXK00kc..,:loooolc,..oXWMMM
1718 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKc.  .lO000KKXXXXXXXXXXXXK00Od;.        .c0WMMMMM
1719 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx'  .;x000KKKXXXXXXXXXXXXXKKK000xlc:,.  .xNMMMMMMM
1720 MMMMMMMMMMMMMMMMMMMMMMMMMMMW0:   .oO00KKKXXXXXXXXXXXKKKKKKKK00OOOd,  'OWMMMMMMMM
1721 MMMMMMMMMMMMMMMMMMMMMMMMMMXo.  .:x000KKXXXXXXXXXXKKK00000KK00OOOo.  ;OWMMMMMMMMM
1722 MMMMMMMMMMMMMMMMMMWMMMMMWk,   'oO00KKXXXXXXXXKKKK0Odok00000OOOOd.  ;0WMMMMMMMMMM
1723 MMMMMMMMMMMMMMMMMKxKMMWKl.  .lk00KKXXXXXXXKKKK0xl:;cxO0000OOOOx,  :KWMMMMMMMMMMM
1724 MMMMMMMMMMMMMMMMMx'oWNd'  .;x0KKKXXXXXKKKK0Odc,..;dO00000OOOOx; .lXMMMMMMMMMMMMM
1725 MMMMMMMMMMMMMMMMWd.,d:   'o0KKKKXXKKK0Okkxl:;;cok0000000OOOOd, .oNMMMMMMMMMMMMMM
1726 MMMMMMMMMMMMMMMMWo.    .ck00KKKK0kdllloxkkkO000OOO00000OOOOo. .dNMMMMMMMMMMMMMMM
1727 MMMMMMMNOKWMMMMMXc    ;d00000OdlccloxO0KK0koc;'';d0000OOOkc. .kWMMMMMMMMMMMMMMMM
1728 MMMMMMMWOldXMMWO:   'oO00000Oxddk00KK0Odc:,,,:lok0000OOOx;  'kWMMMMMMMMMMMMMMMMM
1729 MMMMMMMMWKl:k0l.   .o000KK0OkxdddxO000OxdxkO0000K000OOOd'  ,OWMMMMMMMMMMMMMMMMMM
1730 MMMMMMMMMMNo..  .,,ckKKKKKKOxdddxk000000K000000000OOOkl.  ,OWMMMMMMMMMMMMMMMMMMM
1731 MMMMMMMMMNk,  .;x00KKKKKKKKK00KK00000000000000000OOOkc.  ,OWMMMMMMMMMMMMMMMMMMMM
1732 MMMMMMMNk;.  'oOKKKXXXXKKKK0000Odlclx00000000000OOOx:.  ,0WMMMMMMMMMMMMMMMMMMMMM
1733 MMMMMMXl.  .lk00KKXXXXXKK0000000kxxkO0000000000OOOx;   ;0MMMMMMMMMMMMMMMMMMMMMMM
1734 MMMMNk,  .:x00KKKXXXXXXKK00K00000000000000000OOOOd,   :KMMMMMMMMMMMMMMMMMMMMMMMM
1735 MMW0c. .;x000KKXXXXXXXXKK00KK0KK00000000K000OOOOo.   :KMMMMMMMMMMMMMMMMMMMMMMMMM
1736 MXd.  ,o0KKKKXXXXXXKKKKKKKKKK0K000000000000OOOk:.    lNMMMMMMMMMMMMMMMMMMMMMMMMM
1737 O;   :0KKKKXXXXXKKKKKKKKKKKK0000KKKK000000OOOd,  .   .xWMMMMMMMMMMMMMMMMMMMMMMMM
1738 c    .ldxOKXXXXKKKKKKKKKKKKK000KKKKK000OOOOkl...cdc.  ,KMMMMMMMMMMMMMMMMMMMMMMMM
1739 Ko;..   ..;okKXKKKKKKKKKKKKK0KKKKKK00OOOOOd:',lxOOk;  .kMMMMMMMMMMMMMMMMMMMMMMMM
1740 MMWX0xl;.   .,oO0KKKKK00KKKKKKKKK00OOOOxol:cdkkdxOOl. .dWMMMMMMMMMMMMMMMMMMMMMMM
1741 MMMMMMMWXkc'   .ck0KKKKKKKXXKKKK00OO00kdodkkdl:cdOOo. .dWMMMMMMMMMMMMMMMMMMMMMMM
1742 MMMMMMMMMMWXx;.  .ckKKXXXXXXKK00OOOOO0Okxdc;,:okOOOo. .kMMMMMMMMMMMMMMMMMMMMMMMM
1743 MMMMMMMMMMMMMNk;.  'dKXXXKkoooollllllcc::::lxOOOOOOl. '0MMMMMMMMMMMMMMMMMMMMMMMM
1744 MMMMMMMMMMMMMMMNx'  .cOK0kdoodk00000OkkkkkOOOOOOOOx,  cNMMMMMMMMMMMMMMMMMMMMMMMM
1745 MMMMMMMMMMMMMMMMMKc.  ,xkdooddk0KKK000OOOOOOOOOOOkc. .kWMMMMMMMMMMMMMMMMMMMMMMMM
1746 MMMMMMMMMMMMMMMMMMNd.  .dKKKKKKKKK00OOOOOOOOOOOOkl.  lNMMMMMMMMMMMMMMMMMMMMMMMMM
1747 MMMMMMMMMMMMMMMMMMMWx.  .o0KKKKK000OOOOOOOOOOOOkl.  ;KMMMMMMMMMMMMMMMMMMMMMMMMMM
1748 MMMMMMMMMMMMMMMMMMMMWk.  .o0KKK000OOOOOOOOOOOOx:.  ,0WMMMMMMMMMMMMMMMMMMMMMMMMMM
1749 MMMMMMMMMMMMMMMMMMMMMWx.  .d0000OOOOOOOOOOOOOd,   ,0WMMMMMMMMMMMMMMMMMMMMMMMMMMM
1750 MMMMMMMMMMMMMMMMMMMMMMWx.  'd0OOOOOOOOOOOOOxc.  .cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1751 MMMMMMMMMMMMMMMMMMMMMMMNd.  ,xOOOOOOOOOOOxc.  .:OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1752 MMMMMMMMMMMMMMMMMMMMMMMMNl   :kOOOOOOkdc;.  .lOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1753 MMMMMMMMMMMMMMMMMMMMMMMMMK:  .oOOOkdc,.  .;dKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1754 MMMMMMMMMMMMMMMMMMMMMMMMMWk.  :do:'. .,ox0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1755 MMMMMMMMMMMMMMMMMMMMMMMMMMXc   .  .;d0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1756 MMMMMMMMMMMMMMMMMMMMMMMMMMWd..':okXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1757 MMMMMMMMMMMMMMMMMMMMMMMMMMW0dkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1758 **/
1759 contract GoblinDickWTF is ERC721A, ERC721AQueryable, ERC721APausable, ERC721ABurnable, Ownable, ReentrancyGuard {
1760     uint public PRICE;
1761     uint public MAX_SUPPLY;
1762     uint public MAX_MINT_AMOUNT_PER_TX;
1763     uint16 public MAX_FREE_MINTS_PER_WALLET;
1764     string private BASE_URI;
1765     bool public SALE_IS_ACTIVE = true;
1766     bool public METADATA_FROZEN;
1767 
1768     uint public totalFreeMinted;
1769 
1770     constructor(uint price,
1771         uint maxSupply,
1772         uint maxMintPerTx,
1773         uint16 maxFreeMintsPerWallet,
1774         string memory baseUri) ERC721A("GoblinDick.WTF", "GOBD") {
1775         PRICE = price;
1776         MAX_SUPPLY = maxSupply;
1777         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1778         MAX_FREE_MINTS_PER_WALLET = maxFreeMintsPerWallet;
1779         BASE_URI = baseUri;
1780     }
1781 
1782     function _startTokenId() internal view virtual override returns (uint256) {
1783         return 1;
1784     }
1785 
1786     function _baseURI() internal view virtual override returns (string memory) {
1787         return BASE_URI;
1788     }
1789 
1790     function maxSupply() external view returns (uint) {
1791         return MAX_SUPPLY;
1792     }
1793 
1794     function getFreeMints(address addy) external view returns (uint64) {
1795         return _getAux(addy);
1796     }
1797 
1798     function setPrice(uint price) external onlyOwner {
1799         PRICE = price;
1800     }
1801 
1802     function setMaxMintPerTx(uint maxMint) external onlyOwner {
1803         MAX_MINT_AMOUNT_PER_TX = maxMint;
1804     }
1805 
1806     function setMaxFreeMintsPerWallet(uint16 maxFreeMintsPerWallet) external onlyOwner {
1807         MAX_FREE_MINTS_PER_WALLET = maxFreeMintsPerWallet;
1808     }
1809 
1810     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1811         require(!METADATA_FROZEN, "Metadata frozen!");
1812         BASE_URI = customBaseURI_;
1813     }
1814 
1815     function setSaleState(bool state) external onlyOwner {
1816         SALE_IS_ACTIVE = state;
1817     }
1818 
1819     function freezeMetadata() external onlyOwner {
1820         METADATA_FROZEN = true;
1821     }
1822 
1823     function pause() external onlyOwner {
1824         _pause();
1825     }
1826 
1827     function unpause() external onlyOwner {
1828         _unpause();
1829     }
1830 
1831     modifier mintCompliance(uint _mintAmount) {
1832         require(_currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1833         require(_mintAmount > 0, "Invalid mint amount!");
1834         _;
1835     }
1836 
1837     function getDickPic(uint32 _mintAmount) public payable mintCompliance(_mintAmount) {
1838         require(_mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Mint limit exceeded!");
1839         require(SALE_IS_ACTIVE, "Sale not started");
1840 
1841         uint price = PRICE * _mintAmount;
1842 
1843         uint64 usedFreeMints = _getAux(msg.sender);
1844         uint64 remainingFreeMints = 0;
1845         if (MAX_FREE_MINTS_PER_WALLET > usedFreeMints) {
1846             remainingFreeMints = MAX_FREE_MINTS_PER_WALLET - usedFreeMints;
1847         }
1848         uint64 freeMinted = 0;
1849 
1850         if (remainingFreeMints > 0) {
1851             if (_mintAmount >= remainingFreeMints) {
1852                 price -= remainingFreeMints * PRICE;
1853                 freeMinted = remainingFreeMints;
1854                 remainingFreeMints = 0;
1855             } else {
1856                 price -= _mintAmount * PRICE;
1857                 freeMinted = _mintAmount;
1858                 remainingFreeMints -= _mintAmount;
1859             }
1860         }
1861 
1862         require(msg.value >= price, "Insufficient funds!");
1863         _safeMint(msg.sender, _mintAmount);
1864 
1865         totalFreeMinted += freeMinted;
1866         _setAux(msg.sender, usedFreeMints + freeMinted);
1867     }
1868 
1869     function sendDickPic(address _to, uint _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1870         _safeMint(_to, _mintAmount);
1871     }
1872 
1873     function withdraw() public onlyOwner nonReentrant {
1874         uint balance = address(this).balance;
1875         Address.sendValue(payable(owner()), balance);
1876     }
1877 
1878     function _beforeTokenTransfers(
1879         address from,
1880         address to,
1881         uint startTokenId,
1882         uint quantity
1883     ) internal virtual override(ERC721A, ERC721APausable) {
1884         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1885     }
1886 }