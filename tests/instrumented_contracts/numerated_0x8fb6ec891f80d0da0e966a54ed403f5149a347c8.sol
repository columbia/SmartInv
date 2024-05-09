1 // Sources flattened with hardhat v2.9.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 //
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
178 
179 //
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
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
237 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
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
463 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
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
491 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
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
562 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
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
593 // File erc721a/contracts/ERC721A.sol@v3.1.0
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
921         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
922             !_ownerships[tokenId].burned;
923     }
924 
925     function _safeMint(address to, uint256 quantity) internal {
926         _safeMint(to, quantity, '');
927     }
928 
929     /**
930      * @dev Safely mints `quantity` tokens and transfers them to `to`.
931      *
932      * Requirements:
933      *
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
935      * - `quantity` must be greater than 0.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeMint(
940         address to,
941         uint256 quantity,
942         bytes memory _data
943     ) internal {
944         _mint(to, quantity, _data, true);
945     }
946 
947     /**
948      * @dev Mints `quantity` tokens and transfers them to `to`.
949      *
950      * Requirements:
951      *
952      * - `to` cannot be the zero address.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(
958         address to,
959         uint256 quantity,
960         bytes memory _data,
961         bool safe
962     ) internal {
963         uint256 startTokenId = _currentIndex;
964         if (to == address(0)) revert MintToZeroAddress();
965         if (quantity == 0) revert MintZeroQuantity();
966 
967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969         // Overflows are incredibly unrealistic.
970         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
971         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
972         unchecked {
973             _addressData[to].balance += uint64(quantity);
974             _addressData[to].numberMinted += uint64(quantity);
975 
976             _ownerships[startTokenId].addr = to;
977             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
978 
979             uint256 updatedIndex = startTokenId;
980             uint256 end = updatedIndex + quantity;
981 
982             if (safe && to.isContract()) {
983                 do {
984                     emit Transfer(address(0), to, updatedIndex);
985                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
986                         revert TransferToNonERC721ReceiverImplementer();
987                     }
988                 } while (updatedIndex != end);
989                 // Reentrancy protection
990                 if (_currentIndex != startTokenId) revert();
991             } else {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex++);
994                 } while (updatedIndex != end);
995             }
996             _currentIndex = updatedIndex;
997         }
998         _afterTokenTransfers(address(0), to, startTokenId, quantity);
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _transfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) private {
1016         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1017 
1018         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1019 
1020         bool isApprovedOrOwner = (_msgSender() == from ||
1021             isApprovedForAll(from, _msgSender()) ||
1022             getApproved(tokenId) == _msgSender());
1023 
1024         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1025         if (to == address(0)) revert TransferToZeroAddress();
1026 
1027         _beforeTokenTransfers(from, to, tokenId, 1);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId, from);
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1035         unchecked {
1036             _addressData[from].balance -= 1;
1037             _addressData[to].balance += 1;
1038 
1039             TokenOwnership storage currSlot = _ownerships[tokenId];
1040             currSlot.addr = to;
1041             currSlot.startTimestamp = uint64(block.timestamp);
1042 
1043             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1044             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1045             uint256 nextTokenId = tokenId + 1;
1046             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1047             if (nextSlot.addr == address(0)) {
1048                 // This will suffice for checking _exists(nextTokenId),
1049                 // as a burned slot cannot contain the zero address.
1050                 if (nextTokenId != _currentIndex) {
1051                     nextSlot.addr = from;
1052                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1053                 }
1054             }
1055         }
1056 
1057         emit Transfer(from, to, tokenId);
1058         _afterTokenTransfers(from, to, tokenId, 1);
1059     }
1060 
1061     /**
1062      * @dev This is equivalent to _burn(tokenId, false)
1063      */
1064     function _burn(uint256 tokenId) internal virtual {
1065         _burn(tokenId, false);
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1079         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1080 
1081         address from = prevOwnership.addr;
1082 
1083         if (approvalCheck) {
1084             bool isApprovedOrOwner = (_msgSender() == from ||
1085                 isApprovedForAll(from, _msgSender()) ||
1086                 getApproved(tokenId) == _msgSender());
1087 
1088             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1089         }
1090 
1091         _beforeTokenTransfers(from, address(0), tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, from);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             AddressData storage addressData = _addressData[from];
1101             addressData.balance -= 1;
1102             addressData.numberBurned += 1;
1103 
1104             // Keep track of who burned the token, and the timestamp of burning.
1105             TokenOwnership storage currSlot = _ownerships[tokenId];
1106             currSlot.addr = from;
1107             currSlot.startTimestamp = uint64(block.timestamp);
1108             currSlot.burned = true;
1109 
1110             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1111             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1112             uint256 nextTokenId = tokenId + 1;
1113             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1114             if (nextSlot.addr == address(0)) {
1115                 // This will suffice for checking _exists(nextTokenId),
1116                 // as a burned slot cannot contain the zero address.
1117                 if (nextTokenId != _currentIndex) {
1118                     nextSlot.addr = from;
1119                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1120                 }
1121             }
1122         }
1123 
1124         emit Transfer(from, address(0), tokenId);
1125         _afterTokenTransfers(from, address(0), tokenId, 1);
1126 
1127         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1128         unchecked {
1129             _burnCounter++;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Approve `to` to operate on `tokenId`
1135      *
1136      * Emits a {Approval} event.
1137      */
1138     function _approve(
1139         address to,
1140         uint256 tokenId,
1141         address owner
1142     ) private {
1143         _tokenApprovals[tokenId] = to;
1144         emit Approval(owner, to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1149      *
1150      * @param from address representing the previous owner of the given token ID
1151      * @param to target address that will receive the tokens
1152      * @param tokenId uint256 ID of the token to be transferred
1153      * @param _data bytes optional data to send along with the call
1154      * @return bool whether the call correctly returned the expected magic value
1155      */
1156     function _checkContractOnERC721Received(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) private returns (bool) {
1162         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163             return retval == IERC721Receiver(to).onERC721Received.selector;
1164         } catch (bytes memory reason) {
1165             if (reason.length == 0) {
1166                 revert TransferToNonERC721ReceiverImplementer();
1167             } else {
1168                 assembly {
1169                     revert(add(32, reason), mload(reason))
1170                 }
1171             }
1172         }
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1177      * And also called before burning one token.
1178      *
1179      * startTokenId - the first token id to be transferred
1180      * quantity - the amount to be transferred
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, `tokenId` will be burned by `from`.
1188      * - `from` and `to` are never both zero.
1189      */
1190     function _beforeTokenTransfers(
1191         address from,
1192         address to,
1193         uint256 startTokenId,
1194         uint256 quantity
1195     ) internal virtual {}
1196 
1197     /**
1198      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1199      * minting.
1200      * And also called after one token has been burned.
1201      *
1202      * startTokenId - the first token id to be transferred
1203      * quantity - the amount to be transferred
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` has been minted for `to`.
1210      * - When `to` is zero, `tokenId` has been burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _afterTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 }
1220 
1221 
1222 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1223 
1224 //
1225 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 /**
1230  * @dev Contract module which provides a basic access control mechanism, where
1231  * there is an account (an owner) that can be granted exclusive access to
1232  * specific functions.
1233  *
1234  * By default, the owner account will be the one that deploys the contract. This
1235  * can later be changed with {transferOwnership}.
1236  *
1237  * This module is used through inheritance. It will make available the modifier
1238  * `onlyOwner`, which can be applied to your functions to restrict their use to
1239  * the owner.
1240  */
1241 abstract contract Ownable is Context {
1242     address private _owner;
1243 
1244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1245 
1246     /**
1247      * @dev Initializes the contract setting the deployer as the initial owner.
1248      */
1249     constructor() {
1250         _transferOwnership(_msgSender());
1251     }
1252 
1253     /**
1254      * @dev Returns the address of the current owner.
1255      */
1256     function owner() public view virtual returns (address) {
1257         return _owner;
1258     }
1259 
1260     /**
1261      * @dev Throws if called by any account other than the owner.
1262      */
1263     modifier onlyOwner() {
1264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1265         _;
1266     }
1267 
1268     /**
1269      * @dev Leaves the contract without owner. It will not be possible to call
1270      * `onlyOwner` functions anymore. Can only be called by the current owner.
1271      *
1272      * NOTE: Renouncing ownership will leave the contract without an owner,
1273      * thereby removing any functionality that is only available to the owner.
1274      */
1275     function renounceOwnership() public virtual onlyOwner {
1276         _transferOwnership(address(0));
1277     }
1278 
1279     /**
1280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1281      * Can only be called by the current owner.
1282      */
1283     function transferOwnership(address newOwner) public virtual onlyOwner {
1284         require(newOwner != address(0), "Ownable: new owner is the zero address");
1285         _transferOwnership(newOwner);
1286     }
1287 
1288     /**
1289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1290      * Internal function without access restriction.
1291      */
1292     function _transferOwnership(address newOwner) internal virtual {
1293         address oldOwner = _owner;
1294         _owner = newOwner;
1295         emit OwnershipTransferred(oldOwner, newOwner);
1296     }
1297 }
1298 
1299 
1300 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1301 
1302 //
1303 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 /**
1308  * @dev These functions deal with verification of Merkle Trees proofs.
1309  *
1310  * The proofs can be generated using the JavaScript library
1311  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1312  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1313  *
1314  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1315  */
1316 library MerkleProof {
1317     /**
1318      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1319      * defined by `root`. For this, a `proof` must be provided, containing
1320      * sibling hashes on the branch from the leaf to the root of the tree. Each
1321      * pair of leaves and each pair of pre-images are assumed to be sorted.
1322      */
1323     function verify(
1324         bytes32[] memory proof,
1325         bytes32 root,
1326         bytes32 leaf
1327     ) internal pure returns (bool) {
1328         return processProof(proof, leaf) == root;
1329     }
1330 
1331     /**
1332      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1333      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1334      * hash matches the root of the tree. When processing the proof, the pairs
1335      * of leafs & pre-images are assumed to be sorted.
1336      *
1337      * _Available since v4.4._
1338      */
1339     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1340         bytes32 computedHash = leaf;
1341         for (uint256 i = 0; i < proof.length; i++) {
1342             bytes32 proofElement = proof[i];
1343             if (computedHash <= proofElement) {
1344                 // Hash(current computed hash + current element of the proof)
1345                 computedHash = _efficientHash(computedHash, proofElement);
1346             } else {
1347                 // Hash(current element of the proof + current computed hash)
1348                 computedHash = _efficientHash(proofElement, computedHash);
1349             }
1350         }
1351         return computedHash;
1352     }
1353 
1354     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1355         assembly {
1356             mstore(0x00, a)
1357             mstore(0x20, b)
1358             value := keccak256(0x00, 0x40)
1359         }
1360     }
1361 }
1362 
1363 
1364 // File contracts/SmartContract.sol
1365 
1366 //
1367 pragma solidity ^0.8.4;
1368 
1369 
1370 
1371 contract HONKV1MintContract is ERC721A, Ownable {
1372 
1373     using Strings for uint256;
1374 
1375     string public baseURI;
1376     string public uriExtension = '.json';
1377     string public hiddenURI;
1378 
1379     //***************************************************************************************************
1380     //Pricing
1381     //***************************************************************************************************
1382     uint256 public pricePartner = 0.0 ether; //set NFT price
1383     uint256 public pricePresale = 0.0 ether; //set NFT price
1384     uint256 public pricePublic = 0.0 ether; //set NFT price
1385 
1386     //***************************************************************************************************
1387     //Supply and Reserve
1388     //***************************************************************************************************
1389     uint256 public maxSupply = 5555; // set max supply according to your need
1390     uint256 public reserve = 10; // management tokens
1391 
1392     //***************************************************************************************************
1393     //Max per Wallets
1394     //***************************************************************************************************
1395     uint256 public maxPartnerMint = 1; //set how many NFTs can be minted per wallet for partner
1396     uint256 public maxPreSaleMint = 1; //set how many NFTs can be minted per wallet in pre sale
1397     uint256 public maxPublicSaleMint = 1; //set how many NFTs can be minted per wallet in public sale
1398 
1399     //***************************************************************************************************
1400     //Sale Controls and Allow List
1401     //***************************************************************************************************
1402     bool public isPartnerSaleActive = false;
1403     bool public isPreSaleActive = false;
1404     bool public isPublicSaleActive = false;
1405     bool public isRevealed = false;
1406     bytes32 public merkleRootPartner;
1407     bytes32 public merkleRootPresale;
1408 
1409     //***************************************************************************************************
1410     //Owner Withdraw Address
1411     //***************************************************************************************************
1412     address public immutable ownerWithdrawAddress;
1413 
1414     //***************************************************************************************************
1415     //Developer Settings
1416     //***************************************************************************************************
1417     address public immutable devAddress;
1418     uint256 public immutable devShare;
1419 
1420     //***************************************************************************************************
1421     //Constructor
1422     //***************************************************************************************************
1423     constructor(
1424         string memory _name,
1425         string memory _symbol,
1426         string memory _initBaseURI,
1427         string memory _initHiddenURI
1428     ) ERC721A(_name, _symbol) {
1429         baseURI = _initBaseURI;
1430         hiddenURI = _initHiddenURI;
1431         devAddress = 0xB9cD42c60d23C5475D4B23325eD96a157B738A93; //Dev
1432         devShare = 10; //Dev Fee
1433         ownerWithdrawAddress = 0x77Aa3fE7667Ab5d5cB5C7e4fF09E2C3B8F1E5DF6;//Owner
1434     }
1435 
1436     //***************************************************************************************************
1437     // Use #1..
1438     //***************************************************************************************************
1439     function _startTokenId() internal view virtual override returns (uint256) { return 1; }
1440     //***************************************************************************************************
1441     //Mint tokens for management (pulls a reserve amount)
1442     //***************************************************************************************************
1443     function mintReserve() external onlyOwner {
1444         uint256 supply = totalSupply();
1445         require(supply + reserve <= maxSupply,  'This transaction would exceed max supply.');
1446 
1447         _safeMint(msg.sender, reserve);
1448     }
1449 
1450     //***************************************************************************************************
1451     //Partner Mint
1452     //***************************************************************************************************
1453     function partnerMint(bytes32[] calldata __proof, uint256 __count) external payable {
1454         uint256 supply = totalSupply();
1455         uint256 tokenCount = numberMinted(msg.sender);
1456 
1457         require(isPartnerSaleActive,           'Partner Sale is not active');
1458         require(__count > 0,                   'Count can not be 0');
1459         require(__count <= maxPartnerMint,     string(abi.encodePacked('You can only mint ', maxPartnerMint.toString())));
1460         require(tokenCount + __count <= maxPartnerMint,  string(abi.encodePacked('You can only mint ', maxPartnerMint.toString())));
1461         require(tokenCount <= maxPartnerMint,  string(abi.encodePacked('You can only mint ', maxPartnerMint.toString())));
1462         require(supply + __count <= maxSupply, 'This transaction would exceed max supply.');
1463         require(msg.value >= pricePartner * __count,  'Ether value is too low');
1464 
1465         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1466         require(MerkleProof.verify(__proof, merkleRootPartner, leaf), "Not in partner list.");
1467 
1468         _safeMint(msg.sender, __count);
1469     }
1470 
1471     //***************************************************************************************************
1472     //Presale Mint
1473     //***************************************************************************************************
1474     function preSale(bytes32[] calldata __proof, uint256 __count) external payable {
1475         uint256 supply = totalSupply();
1476         uint256 tokenCount = numberMinted(msg.sender);
1477 
1478         require(isPreSaleActive,               'Pre sale is not active');
1479         require(__count > 0,                   'Count can not be 0');
1480         require(__count <= maxPreSaleMint,     string(abi.encodePacked('You can only mint ', maxPreSaleMint.toString())));
1481         require(tokenCount + __count <= maxPreSaleMint,  string(abi.encodePacked('You can only mint ', maxPreSaleMint.toString())));
1482         require(tokenCount <= maxPreSaleMint,  string(abi.encodePacked('You can only mint ', maxPreSaleMint.toString())));
1483         require(supply + __count <= maxSupply, 'This transaction would exceed max supply.');
1484         require(msg.value >= pricePresale * __count,  'Ether value is too low');
1485 
1486         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1487         require(MerkleProof.verify(__proof, merkleRootPresale, leaf), "Not whitelisted.");
1488 
1489         _safeMint(msg.sender, __count);
1490     }
1491 
1492     //***************************************************************************************************
1493     //Public Mint
1494     //***************************************************************************************************
1495     function publicSale(uint256 __count) external payable {
1496         uint256 supply = totalSupply();
1497         uint256 tokenCount = numberMinted(msg.sender);
1498 
1499         require(isPublicSaleActive,               'Public sale is not active');
1500         require(__count > 0,                      'Count can not be 0');
1501         require(__count <= maxPublicSaleMint,     string(abi.encodePacked('You can only mint ', maxPublicSaleMint.toString())));
1502         require(tokenCount + __count <= maxPublicSaleMint,  string(abi.encodePacked('You can only mint ', maxPublicSaleMint.toString())));
1503         require(tokenCount <= maxPublicSaleMint,  string(abi.encodePacked('You can only mint ', maxPublicSaleMint.toString())));
1504         require(supply + __count <= maxSupply,    'This transaction would exceed max supply.');
1505         require(msg.value >= pricePublic * __count,     'Ether value is too low');
1506 
1507         _safeMint(msg.sender, __count);
1508     }
1509 
1510     //***************************************************************************************************
1511     //***************************************************************************************************
1512     function gift(address _address, uint256 __count) external onlyOwner {
1513         uint256 supply = totalSupply();
1514         require(__count > 0,                      'Count can not be 0');
1515         require(supply + __count <= maxSupply,    'This transaction would exceed max supply.');
1516 
1517         _safeMint(_address, __count);
1518     }
1519 
1520     //***************************************************************************************************
1521     //returns baseURI of collection
1522     //***************************************************************************************************
1523     function _baseURI() internal view virtual override returns (string memory) { return baseURI; }
1524 
1525     //***************************************************************************************************
1526     // MetaData
1527     //***************************************************************************************************
1528     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1529 
1530         // return not revealed URI
1531         if (!isRevealed) { return hiddenURI; }
1532 
1533         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1534 
1535         return bytes(baseURI).length != 0 ? string(abi.encodePacked(_baseURI(), tokenId.toString(), uriExtension)) : '';
1536     }
1537 
1538     //***************************************************************************************************
1539     //Change baseURI or hiddenURI of collection
1540     //***************************************************************************************************
1541     function setBaseURI(string memory __baseURI) public onlyOwner { baseURI = __baseURI; }
1542     function setHiddenURI(string memory __hiddenURI) public onlyOwner { hiddenURI = __hiddenURI; }
1543 
1544     //***************************************************************************************************
1545     //Change prices of NFT
1546     //***************************************************************************************************
1547     function setPartnerPrice(uint256 __price) public onlyOwner { pricePartner = __price; }
1548     function setPresalePrice(uint256 __price) public onlyOwner { pricePresale = __price; }
1549     function setPublicPrice(uint256 __price) public onlyOwner { pricePublic = __price; }
1550 
1551     //***************************************************************************************************
1552     //Change how many NFTs can be minted per wallets
1553     //***************************************************************************************************
1554     function setMaxPartnerSale(uint256 __number) public onlyOwner { maxPartnerMint = __number; }
1555     function setMaxPreSale(uint256 __number) public onlyOwner { maxPreSaleMint = __number; }
1556     function setMaxPublicSale(uint256 __number) public onlyOwner { maxPublicSaleMint = __number; }
1557 
1558     //***************************************************************************************************
1559     //Change merkle roots
1560     //***************************************************************************************************
1561     function setPartnerMerkleRoot(bytes32 __merkleRoot) public onlyOwner { merkleRootPartner = __merkleRoot; }
1562     function setPresaleMerkleRoot(bytes32 __merkleRoot) public onlyOwner { merkleRootPresale = __merkleRoot; }
1563 
1564     //***************************************************************************************************
1565     //Change revealed state of collection
1566     //***************************************************************************************************
1567     function flipRevealed() public onlyOwner { isRevealed = !isRevealed; }
1568 
1569     //***************************************************************************************************
1570     //Change pre sale state of collection
1571     //***************************************************************************************************
1572     function flipPartnerSale() public onlyOwner { isPartnerSaleActive = !isPartnerSaleActive; }
1573     function flipPreSale() public onlyOwner { isPreSaleActive = !isPreSaleActive; }
1574     function flipPublicSale() public onlyOwner { isPublicSaleActive = !isPublicSaleActive; }
1575 
1576     //***************************************************************************************************
1577     //Returns total minted NFTs by specific user
1578     //***************************************************************************************************
1579     function numberMinted(address owner) public view returns (uint256) { return _numberMinted(owner); }
1580 
1581     //***************************************************************************************************
1582     //Ownership
1583     //***************************************************************************************************
1584     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1585     {
1586         return _ownershipOf(tokenId);
1587     }
1588 
1589     //***************************************************************************************************
1590     //Withdraw Funds
1591     //***************************************************************************************************
1592     function withdraw() external onlyOwner {
1593         uint256 balance = address(this).balance;
1594 
1595         require(balance > 0, "No ether to withdraw");
1596 
1597         uint256 devCut = balance * devShare / 100;
1598         uint remaining = balance - devCut;
1599 
1600         payable(devAddress).transfer(devCut);
1601         payable(ownerWithdrawAddress).transfer(remaining);
1602     }
1603 
1604     //***************************************************************************************************
1605     //Fallback function for receiving Ether
1606     //***************************************************************************************************
1607     receive() external payable {  }
1608 
1609 }