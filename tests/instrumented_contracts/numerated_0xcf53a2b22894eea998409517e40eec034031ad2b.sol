1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Address.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
178 
179 pragma solidity ^0.8.1;
180 
181 /**
182  * @dev Collection of functions related to the address type
183  */
184 library Address {
185     /**
186      * @dev Returns true if `account` is a contract.
187      *
188      * [IMPORTANT]
189      * ====
190      * It is unsafe to assume that an address for which this function returns
191      * false is an externally-owned account (EOA) and not a contract.
192      *
193      * Among others, `isContract` will return false for the following
194      * types of addresses:
195      *
196      *  - an externally-owned account
197      *  - a contract in construction
198      *  - an address where a contract will be created
199      *  - an address where a contract lived, but was destroyed
200      * ====
201      *
202      * [IMPORTANT]
203      * ====
204      * You shouldn't rely on `isContract` to protect against flash loan attacks!
205      *
206      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
207      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
208      * constructor.
209      * ====
210      */
211     function isContract(address account) internal view returns (bool) {
212         // This method relies on extcodesize/address.code.length, which returns 0
213         // for contracts in construction, since the code is only stored at the end
214         // of the constructor execution.
215 
216         return account.code.length > 0;
217     }
218 
219     /**
220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
221      * `recipient`, forwarding all available gas and reverting on errors.
222      *
223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
225      * imposed by `transfer`, making them unable to receive funds via
226      * `transfer`. {sendValue} removes this limitation.
227      *
228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
229      *
230      * IMPORTANT: because control is transferred to `recipient`, care must be
231      * taken to not create reentrancy vulnerabilities. Consider using
232      * {ReentrancyGuard} or the
233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
234      */
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     /**
243      * @dev Performs a Solidity function call using a low level `call`. A
244      * plain `call` is an unsafe replacement for a function call: use this
245      * function instead.
246      *
247      * If `target` reverts with a revert reason, it is bubbled up by this
248      * function (like regular Solidity function calls).
249      *
250      * Returns the raw returned data. To convert to the expected return value,
251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
252      *
253      * Requirements:
254      *
255      * - `target` must be a contract.
256      * - calling `target` with `data` must not revert.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but also transferring `value` wei to `target`.
281      *
282      * Requirements:
283      *
284      * - the calling contract must have an ETH balance of at least `value`.
285      * - the called Solidity function must be `payable`.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
299      * with `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(address(this).balance >= value, "Address: insufficient balance for call");
310         require(isContract(target), "Address: call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.call{value: value}(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
323         return functionStaticCall(target, data, "Address: low-level static call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         require(isContract(target), "Address: static call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.staticcall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
372      * revert reason using the provided one.
373      *
374      * _Available since v4.3._
375      */
376     function verifyCallResult(
377         bool success,
378         bytes memory returndata,
379         string memory errorMessage
380     ) internal pure returns (bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @title ERC721 token receiver interface
408  * @dev Interface for any contract that wants to support safeTransfers
409  * from ERC721 asset contracts.
410  */
411 interface IERC721Receiver {
412     /**
413      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
414      * by `operator` from `from`, this function is called.
415      *
416      * It must return its Solidity selector to confirm the token transfer.
417      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
418      *
419      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
420      */
421     function onERC721Received(
422         address operator,
423         address from,
424         uint256 tokenId,
425         bytes calldata data
426     ) external returns (bytes4);
427 }
428 
429 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @dev Interface of the ERC165 standard, as defined in the
438  * https://eips.ethereum.org/EIPS/eip-165[EIP].
439  *
440  * Implementers can declare support of contract interfaces, which can then be
441  * queried by others ({ERC165Checker}).
442  *
443  * For an implementation, see {ERC165}.
444  */
445 interface IERC165 {
446     /**
447      * @dev Returns true if this contract implements the interface defined by
448      * `interfaceId`. See the corresponding
449      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
450      * to learn more about how these ids are created.
451      *
452      * This function call must use less than 30 000 gas.
453      */
454     function supportsInterface(bytes4 interfaceId) external view returns (bool);
455 }
456 
457 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Implementation of the {IERC165} interface.
467  *
468  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
469  * for the additional interface id that will be supported. For example:
470  *
471  * ```solidity
472  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
474  * }
475  * ```
476  *
477  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
478  */
479 abstract contract ERC165 is IERC165 {
480     /**
481      * @dev See {IERC165-supportsInterface}.
482      */
483     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484         return interfaceId == type(IERC165).interfaceId;
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Required interface of an ERC721 compliant contract.
498  */
499 interface IERC721 is IERC165 {
500     /**
501      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
502      */
503     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
504 
505     /**
506      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
507      */
508     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
512      */
513     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
514 
515     /**
516      * @dev Returns the number of tokens in ``owner``'s account.
517      */
518     function balanceOf(address owner) external view returns (uint256 balance);
519 
520     /**
521      * @dev Returns the owner of the `tokenId` token.
522      *
523      * Requirements:
524      *
525      * - `tokenId` must exist.
526      */
527     function ownerOf(uint256 tokenId) external view returns (address owner);
528 
529     /**
530      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
531      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) external;
548 
549     /**
550      * @dev Transfers `tokenId` token from `from` to `to`.
551      *
552      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      *
561      * Emits a {Transfer} event.
562      */
563     function transferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external;
568 
569     /**
570      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
571      * The approval is cleared when the token is transferred.
572      *
573      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
574      *
575      * Requirements:
576      *
577      * - The caller must own the token or be an approved operator.
578      * - `tokenId` must exist.
579      *
580      * Emits an {Approval} event.
581      */
582     function approve(address to, uint256 tokenId) external;
583 
584     /**
585      * @dev Returns the account approved for `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function getApproved(uint256 tokenId) external view returns (address operator);
592 
593     /**
594      * @dev Approve or remove `operator` as an operator for the caller.
595      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
596      *
597      * Requirements:
598      *
599      * - The `operator` cannot be the caller.
600      *
601      * Emits an {ApprovalForAll} event.
602      */
603     function setApprovalForAll(address operator, bool _approved) external;
604 
605     /**
606      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
607      *
608      * See {setApprovalForAll}
609      */
610     function isApprovedForAll(address owner, address operator) external view returns (bool);
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes calldata data
630     ) external;
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
643  * @dev See https://eips.ethereum.org/EIPS/eip-721
644  */
645 interface IERC721Metadata is IERC721 {
646     /**
647      * @dev Returns the token collection name.
648      */
649     function name() external view returns (string memory);
650 
651     /**
652      * @dev Returns the token collection symbol.
653      */
654     function symbol() external view returns (string memory);
655 
656     /**
657      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
658      */
659     function tokenURI(uint256 tokenId) external view returns (string memory);
660 }
661 
662 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
663 
664 
665 // Creator: Chiru Labs
666 
667 pragma solidity ^0.8.4;
668 
669 
670 
671 
672 
673 
674 
675 
676 error ApprovalCallerNotOwnerNorApproved();
677 error ApprovalQueryForNonexistentToken();
678 error ApproveToCaller();
679 error ApprovalToCurrentOwner();
680 error BalanceQueryForZeroAddress();
681 error MintToZeroAddress();
682 error MintZeroQuantity();
683 error OwnerQueryForNonexistentToken();
684 error TransferCallerNotOwnerNorApproved();
685 error TransferFromIncorrectOwner();
686 error TransferToNonERC721ReceiverImplementer();
687 error TransferToZeroAddress();
688 error URIQueryForNonexistentToken();
689 
690 /**
691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
692  * the Metadata extension. Built to optimize for lower gas during batch mints.
693  *
694  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
695  *
696  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
697  *
698  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
699  */
700 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
701     using Address for address;
702     using Strings for uint256;
703 
704     // Compiler will pack this into a single 256bit word.
705     struct TokenOwnership {
706         // The address of the owner.
707         address addr;
708         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
709         uint64 startTimestamp;
710         // Whether the token has been burned.
711         bool burned;
712     }
713 
714     // Compiler will pack this into a single 256bit word.
715     struct AddressData {
716         // Realistically, 2**64-1 is more than enough.
717         uint64 balance;
718         // Keeps track of mint count with minimal overhead for tokenomics.
719         uint64 numberMinted;
720         // Keeps track of burn count with minimal overhead for tokenomics.
721         uint64 numberBurned;
722         // For miscellaneous variable(s) pertaining to the address
723         // (e.g. number of whitelist mint slots used).
724         // If there are multiple variables, please pack them into a uint64.
725         uint64 aux;
726     }
727 
728     // The tokenId of the next token to be minted.
729     uint256 internal _currentIndex;
730 
731     // The number of tokens burned.
732     uint256 internal _burnCounter;
733 
734     // Token name
735     string private _name;
736 
737     // Token symbol
738     string private _symbol;
739 
740     // Mapping from token ID to ownership details
741     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
742     mapping(uint256 => TokenOwnership) internal _ownerships;
743 
744     // Mapping owner address to address data
745     mapping(address => AddressData) private _addressData;
746 
747     // Mapping from token ID to approved address
748     mapping(uint256 => address) private _tokenApprovals;
749 
750     // Mapping from owner to operator approvals
751     mapping(address => mapping(address => bool)) private _operatorApprovals;
752 
753     constructor(string memory name_, string memory symbol_) {
754         _name = name_;
755         _symbol = symbol_;
756         _currentIndex = _startTokenId();
757     }
758 
759     /**
760      * To change the starting tokenId, please override this function.
761      */
762     function _startTokenId() internal view virtual returns (uint256) {
763         return 0;
764     }
765 
766     /**
767      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
768      */
769     function totalSupply() public view returns (uint256) {
770         // Counter underflow is impossible as _burnCounter cannot be incremented
771         // more than _currentIndex - _startTokenId() times
772         unchecked {
773             return _currentIndex - _burnCounter - _startTokenId();
774         }
775     }
776 
777     /**
778      * Returns the total amount of tokens minted in the contract.
779      */
780     function _totalMinted() internal view returns (uint256) {
781         // Counter underflow is impossible as _currentIndex does not decrement,
782         // and it is initialized to _startTokenId()
783         unchecked {
784             return _currentIndex - _startTokenId();
785         }
786     }
787 
788     /**
789      * @dev See {IERC165-supportsInterface}.
790      */
791     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
792         return
793             interfaceId == type(IERC721).interfaceId ||
794             interfaceId == type(IERC721Metadata).interfaceId ||
795             super.supportsInterface(interfaceId);
796     }
797 
798     /**
799      * @dev See {IERC721-balanceOf}.
800      */
801     function balanceOf(address owner) public view override returns (uint256) {
802         if (owner == address(0)) revert BalanceQueryForZeroAddress();
803         return uint256(_addressData[owner].balance);
804     }
805 
806     /**
807      * Returns the number of tokens minted by `owner`.
808      */
809     function _numberMinted(address owner) internal view returns (uint256) {
810         return uint256(_addressData[owner].numberMinted);
811     }
812 
813     /**
814      * Returns the number of tokens burned by or on behalf of `owner`.
815      */
816     function _numberBurned(address owner) internal view returns (uint256) {
817         return uint256(_addressData[owner].numberBurned);
818     }
819 
820     /**
821      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
822      */
823     function _getAux(address owner) internal view returns (uint64) {
824         return _addressData[owner].aux;
825     }
826 
827     /**
828      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
829      * If there are multiple variables, please pack them into a uint64.
830      */
831     function _setAux(address owner, uint64 aux) internal {
832         _addressData[owner].aux = aux;
833     }
834 
835     /**
836      * Gas spent here starts off proportional to the maximum mint batch size.
837      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
838      */
839     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
840         uint256 curr = tokenId;
841 
842         unchecked {
843             if (_startTokenId() <= curr && curr < _currentIndex) {
844                 TokenOwnership memory ownership = _ownerships[curr];
845                 if (!ownership.burned) {
846                     if (ownership.addr != address(0)) {
847                         return ownership;
848                     }
849                     // Invariant:
850                     // There will always be an ownership that has an address and is not burned
851                     // before an ownership that does not have an address and is not burned.
852                     // Hence, curr will not underflow.
853                     while (true) {
854                         curr--;
855                         ownership = _ownerships[curr];
856                         if (ownership.addr != address(0)) {
857                             return ownership;
858                         }
859                     }
860                 }
861             }
862         }
863         revert OwnerQueryForNonexistentToken();
864     }
865 
866     /**
867      * @dev See {IERC721-ownerOf}.
868      */
869     function ownerOf(uint256 tokenId) public view override returns (address) {
870         return _ownershipOf(tokenId).addr;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-name}.
875      */
876     function name() public view virtual override returns (string memory) {
877         return _name;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-symbol}.
882      */
883     function symbol() public view virtual override returns (string memory) {
884         return _symbol;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-tokenURI}.
889      */
890     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
891         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
892 
893         string memory baseURI = _baseURI();
894         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
895     }
896 
897     /**
898      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900      * by default, can be overriden in child contracts.
901      */
902     function _baseURI() internal view virtual returns (string memory) {
903         return '';
904     }
905 
906     /**
907      * @dev See {IERC721-approve}.
908      */
909     function approve(address to, uint256 tokenId) public override {
910         address owner = ERC721A.ownerOf(tokenId);
911         if (to == owner) revert ApprovalToCurrentOwner();
912 
913         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
914             revert ApprovalCallerNotOwnerNorApproved();
915         }
916 
917         _approve(to, tokenId, owner);
918     }
919 
920     /**
921      * @dev See {IERC721-getApproved}.
922      */
923     function getApproved(uint256 tokenId) public view override returns (address) {
924         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
925 
926         return _tokenApprovals[tokenId];
927     }
928 
929     /**
930      * @dev See {IERC721-setApprovalForAll}.
931      */
932     function setApprovalForAll(address operator, bool approved) public virtual override {
933         if (operator == _msgSender()) revert ApproveToCaller();
934 
935         _operatorApprovals[_msgSender()][operator] = approved;
936         emit ApprovalForAll(_msgSender(), operator, approved);
937     }
938 
939     /**
940      * @dev See {IERC721-isApprovedForAll}.
941      */
942     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
943         return _operatorApprovals[owner][operator];
944     }
945 
946     /**
947      * @dev See {IERC721-transferFrom}.
948      */
949     function transferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         _transfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) public virtual override {
965         safeTransferFrom(from, to, tokenId, '');
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) public virtual override {
977         _transfer(from, to, tokenId);
978         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
979             revert TransferToNonERC721ReceiverImplementer();
980         }
981     }
982 
983     /**
984      * @dev Returns whether `tokenId` exists.
985      *
986      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
987      *
988      * Tokens start existing when they are minted (`_mint`),
989      */
990     function _exists(uint256 tokenId) internal view returns (bool) {
991         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
992             !_ownerships[tokenId].burned;
993     }
994 
995     function _safeMint(address to, uint256 quantity) internal {
996         _safeMint(to, quantity, '');
997     }
998 
999     /**
1000      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeMint(
1010         address to,
1011         uint256 quantity,
1012         bytes memory _data
1013     ) internal {
1014         _mint(to, quantity, _data, true);
1015     }
1016 
1017     /**
1018      * @dev Mints `quantity` tokens and transfers them to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `quantity` must be greater than 0.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _mint(
1028         address to,
1029         uint256 quantity,
1030         bytes memory _data,
1031         bool safe
1032     ) internal {
1033         uint256 startTokenId = _currentIndex;
1034         if (to == address(0)) revert MintToZeroAddress();
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1041         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1042         unchecked {
1043             _addressData[to].balance += uint64(quantity);
1044             _addressData[to].numberMinted += uint64(quantity);
1045 
1046             _ownerships[startTokenId].addr = to;
1047             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1048 
1049             uint256 updatedIndex = startTokenId;
1050             uint256 end = updatedIndex + quantity;
1051 
1052             if (safe && to.isContract()) {
1053                 do {
1054                     emit Transfer(address(0), to, updatedIndex);
1055                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1056                         revert TransferToNonERC721ReceiverImplementer();
1057                     }
1058                 } while (updatedIndex != end);
1059                 // Reentrancy protection
1060                 if (_currentIndex != startTokenId) revert();
1061             } else {
1062                 do {
1063                     emit Transfer(address(0), to, updatedIndex++);
1064                 } while (updatedIndex != end);
1065             }
1066             _currentIndex = updatedIndex;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `tokenId` token must be owned by `from`.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _transfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) private {
1086         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1087 
1088         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1089 
1090         bool isApprovedOrOwner = (_msgSender() == from ||
1091             isApprovedForAll(from, _msgSender()) ||
1092             getApproved(tokenId) == _msgSender());
1093 
1094         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1095         if (to == address(0)) revert TransferToZeroAddress();
1096 
1097         _beforeTokenTransfers(from, to, tokenId, 1);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId, from);
1101 
1102         // Underflow of the sender's balance is impossible because we check for
1103         // ownership above and the recipient's balance can't realistically overflow.
1104         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1105         unchecked {
1106             _addressData[from].balance -= 1;
1107             _addressData[to].balance += 1;
1108 
1109             TokenOwnership storage currSlot = _ownerships[tokenId];
1110             currSlot.addr = to;
1111             currSlot.startTimestamp = uint64(block.timestamp);
1112 
1113             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1114             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1115             uint256 nextTokenId = tokenId + 1;
1116             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1117             if (nextSlot.addr == address(0)) {
1118                 // This will suffice for checking _exists(nextTokenId),
1119                 // as a burned slot cannot contain the zero address.
1120                 if (nextTokenId != _currentIndex) {
1121                     nextSlot.addr = from;
1122                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, to, tokenId);
1128         _afterTokenTransfers(from, to, tokenId, 1);
1129     }
1130 
1131     /**
1132      * @dev This is equivalent to _burn(tokenId, false)
1133      */
1134     function _burn(uint256 tokenId) internal virtual {
1135         _burn(tokenId, false);
1136     }
1137 
1138     /**
1139      * @dev Destroys `tokenId`.
1140      * The approval is cleared when the token is burned.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1149         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1150 
1151         address from = prevOwnership.addr;
1152 
1153         if (approvalCheck) {
1154             bool isApprovedOrOwner = (_msgSender() == from ||
1155                 isApprovedForAll(from, _msgSender()) ||
1156                 getApproved(tokenId) == _msgSender());
1157 
1158             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1159         }
1160 
1161         _beforeTokenTransfers(from, address(0), tokenId, 1);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId, from);
1165 
1166         // Underflow of the sender's balance is impossible because we check for
1167         // ownership above and the recipient's balance can't realistically overflow.
1168         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1169         unchecked {
1170             AddressData storage addressData = _addressData[from];
1171             addressData.balance -= 1;
1172             addressData.numberBurned += 1;
1173 
1174             // Keep track of who burned the token, and the timestamp of burning.
1175             TokenOwnership storage currSlot = _ownerships[tokenId];
1176             currSlot.addr = from;
1177             currSlot.startTimestamp = uint64(block.timestamp);
1178             currSlot.burned = true;
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1184             if (nextSlot.addr == address(0)) {
1185                 // This will suffice for checking _exists(nextTokenId),
1186                 // as a burned slot cannot contain the zero address.
1187                 if (nextTokenId != _currentIndex) {
1188                     nextSlot.addr = from;
1189                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, address(0), tokenId);
1195         _afterTokenTransfers(from, address(0), tokenId, 1);
1196 
1197         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1198         unchecked {
1199             _burnCounter++;
1200         }
1201     }
1202 
1203     /**
1204      * @dev Approve `to` to operate on `tokenId`
1205      *
1206      * Emits a {Approval} event.
1207      */
1208     function _approve(
1209         address to,
1210         uint256 tokenId,
1211         address owner
1212     ) private {
1213         _tokenApprovals[tokenId] = to;
1214         emit Approval(owner, to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1219      *
1220      * @param from address representing the previous owner of the given token ID
1221      * @param to target address that will receive the tokens
1222      * @param tokenId uint256 ID of the token to be transferred
1223      * @param _data bytes optional data to send along with the call
1224      * @return bool whether the call correctly returned the expected magic value
1225      */
1226     function _checkContractOnERC721Received(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) private returns (bool) {
1232         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1233             return retval == IERC721Receiver(to).onERC721Received.selector;
1234         } catch (bytes memory reason) {
1235             if (reason.length == 0) {
1236                 revert TransferToNonERC721ReceiverImplementer();
1237             } else {
1238                 assembly {
1239                     revert(add(32, reason), mload(reason))
1240                 }
1241             }
1242         }
1243     }
1244 
1245     /**
1246      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1247      * And also called before burning one token.
1248      *
1249      * startTokenId - the first token id to be transferred
1250      * quantity - the amount to be transferred
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` will be minted for `to`.
1257      * - When `to` is zero, `tokenId` will be burned by `from`.
1258      * - `from` and `to` are never both zero.
1259      */
1260     function _beforeTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 
1267     /**
1268      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1269      * minting.
1270      * And also called after one token has been burned.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` has been minted for `to`.
1280      * - When `to` is zero, `tokenId` has been burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _afterTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 }
1290 
1291 // File: contracts/elf.sol
1292 
1293 /**
1294  *Submitted for verification at Etherscan.io on 2022-02-21
1295 */
1296 
1297 // File: @openzeppelin/contracts/utils/Strings.sol
1298 
1299 
1300 
1301 
1302 pragma solidity >=0.8.9 <0.9.0;
1303 
1304 
1305 
1306 
1307 contract ForbiddenRealmsElfSyndicate is Ownable, ERC721A {
1308     
1309 
1310     uint constant maxSupply = 6900;
1311     uint public totalNFTSupply = 0;
1312     uint public devReserve = 690; // developer reserve
1313     bool public isPublicOpen = true;
1314     uint public walletLimit = 2;
1315     string public baseURI;
1316     uint public maxPerTransaction = 2;  //Max Limit for Sale
1317 
1318 
1319 
1320     // claim mapping
1321     mapping(address => uint) private elvesClaimed;
1322 
1323 
1324     constructor() ERC721A("ForbiddenRealmsElfSyndicate", "FRES"){}
1325 
1326 
1327     // buy elves
1328    function freeMint(uint _count) external {
1329        
1330          require(isPublicOpen == true, "Sale is Paused.");
1331         require(_count > 0, "mint at least one token");
1332         require(_count <= maxPerTransaction, "max per transaction 2");
1333         require(totalNFTSupply + devReserve + _count <= maxSupply, "Not enough tokens left");
1334         require(elvesClaimed[msg.sender] < walletLimit, "Wallet limit reached!");
1335 
1336       
1337         _safeMint(msg.sender, _count);
1338         elvesClaimed[msg.sender] += _count;
1339         totalNFTSupply += _count;
1340     }
1341 
1342 
1343 
1344     // gift elves
1345     function sendEleves(address _wallet, uint _count) public onlyOwner{
1346         require(_count > 0, "mint at least one token");
1347         require(totalNFTSupply +  _count  <= maxSupply, "not enough tokens left");
1348         _safeMint(_wallet, _count);
1349             
1350         totalNFTSupply += _count;
1351     }
1352     
1353 
1354     function setPublicSaleStatus(bool temp) external onlyOwner {
1355         isPublicOpen = temp;
1356     }
1357 
1358     function getPublicSaleStatus() public view returns(uint){
1359       require(isPublicOpen == true,"Sale not Started Yet.");
1360         return 1;
1361      }
1362 
1363        
1364     function setWaletLimit(uint _limit) external onlyOwner{
1365         walletLimit = _limit;
1366     }
1367 
1368   
1369     function setBaseUri(string memory _uri) external onlyOwner {
1370         baseURI = _uri;
1371     }
1372 
1373     function _baseURI() internal view virtual override returns (string memory) {
1374         return baseURI;
1375     }
1376 
1377     /**
1378      * @dev See {IERC165-supportsInterface}.
1379      */
1380     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
1381         return super.supportsInterface(interfaceId);
1382     }
1383 }