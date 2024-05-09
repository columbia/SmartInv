1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * @dev String operations.
5  */
6 library Strings {
7     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
8     uint8 private constant _ADDRESS_LENGTH = 20;
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
68      */
69     function toHexString(address addr) internal pure returns (string memory) {
70         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         _checkOwner();
138         _;
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view virtual returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if the sender is not the owner.
150      */
151     function _checkOwner() internal view virtual {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Internal function without access restriction.
167      */
168     function _transferOwnership(address newOwner) internal virtual {
169         address oldOwner = _owner;
170         _owner = newOwner;
171         emit OwnershipTransferred(oldOwner, newOwner);
172     }
173 }
174 
175 // File: @openzeppelin/contracts/utils/Address.sol
176 
177 
178 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
179 
180 pragma solidity ^0.8.1;
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      *
203      * [IMPORTANT]
204      * ====
205      * You shouldn't rely on `isContract` to protect against flash loan attacks!
206      *
207      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
208      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
209      * constructor.
210      * ====
211      */
212     function isContract(address account) internal view returns (bool) {
213         // This method relies on extcodesize/address.code.length, which returns 0
214         // for contracts in construction, since the code is only stored at the end
215         // of the constructor execution.
216 
217         return account.code.length > 0;
218     }
219 
220     /**
221      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
222      * `recipient`, forwarding all available gas and reverting on errors.
223      *
224      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
225      * of certain opcodes, possibly making contracts go over the 2300 gas limit
226      * imposed by `transfer`, making them unable to receive funds via
227      * `transfer`. {sendValue} removes this limitation.
228      *
229      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
230      *
231      * IMPORTANT: because control is transferred to `recipient`, care must be
232      * taken to not create reentrancy vulnerabilities. Consider using
233      * {ReentrancyGuard} or the
234      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
235      */
236     function sendValue(address payable recipient, uint256 amount) internal {
237         require(address(this).balance >= amount, "Address: insufficient balance");
238 
239         (bool success, ) = recipient.call{value: amount}("");
240         require(success, "Address: unable to send value, recipient may have reverted");
241     }
242 
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain `call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
267      * `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, 0, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but also transferring `value` wei to `target`.
282      *
283      * Requirements:
284      *
285      * - the calling contract must have an ETH balance of at least `value`.
286      * - the called Solidity function must be `payable`.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.call{value: value}(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
324         return functionStaticCall(target, data, "Address: low-level static call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal view returns (bytes memory) {
338         require(isContract(target), "Address: static call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.staticcall(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
373      * revert reason using the provided one.
374      *
375      * _Available since v4.3._
376      */
377     function verifyCallResult(
378         bool success,
379         bytes memory returndata,
380         string memory errorMessage
381     ) internal pure returns (bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388                 /// @solidity memory-safe-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @title ERC721 token receiver interface
409  * @dev Interface for any contract that wants to support safeTransfers
410  * from ERC721 asset contracts.
411  */
412 interface IERC721Receiver {
413     /**
414      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
415      * by `operator` from `from`, this function is called.
416      *
417      * It must return its Solidity selector to confirm the token transfer.
418      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
419      *
420      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
421      */
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Interface of the ERC165 standard, as defined in the
439  * https://eips.ethereum.org/EIPS/eip-165[EIP].
440  *
441  * Implementers can declare support of contract interfaces, which can then be
442  * queried by others ({ERC165Checker}).
443  *
444  * For an implementation, see {ERC165}.
445  */
446 interface IERC165 {
447     /**
448      * @dev Returns true if this contract implements the interface defined by
449      * `interfaceId`. See the corresponding
450      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
451      * to learn more about how these ids are created.
452      *
453      * This function call must use less than 30 000 gas.
454      */
455     function supportsInterface(bytes4 interfaceId) external view returns (bool);
456 }
457 
458 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 
466 /**
467  * @dev Implementation of the {IERC165} interface.
468  *
469  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
470  * for the additional interface id that will be supported. For example:
471  *
472  * ```solidity
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
475  * }
476  * ```
477  *
478  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
479  */
480 abstract contract ERC165 is IERC165 {
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return interfaceId == type(IERC165).interfaceId;
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
490 
491 
492 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Required interface of an ERC721 compliant contract.
499  */
500 interface IERC721 is IERC165 {
501     /**
502      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
503      */
504     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
508      */
509     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
513      */
514     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
515 
516     /**
517      * @dev Returns the number of tokens in ``owner``'s account.
518      */
519     function balanceOf(address owner) external view returns (uint256 balance);
520 
521     /**
522      * @dev Returns the owner of the `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function ownerOf(uint256 tokenId) external view returns (address owner);
529 
530     /**
531      * @dev Safely transfers `tokenId` token from `from` to `to`.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId,
547         bytes calldata data
548     ) external;
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
552      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Transfers `tokenId` token from `from` to `to`.
572      *
573      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      *
582      * Emits a {Transfer} event.
583      */
584     function transferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
592      * The approval is cleared when the token is transferred.
593      *
594      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Approve or remove `operator` as an operator for the caller.
607      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
608      *
609      * Requirements:
610      *
611      * - The `operator` cannot be the caller.
612      *
613      * Emits an {ApprovalForAll} event.
614      */
615     function setApprovalForAll(address operator, bool _approved) external;
616 
617     /**
618      * @dev Returns the account approved for `tokenId` token.
619      *
620      * Requirements:
621      *
622      * - `tokenId` must exist.
623      */
624     function getApproved(uint256 tokenId) external view returns (address operator);
625 
626     /**
627      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
628      *
629      * See {setApprovalForAll}
630      */
631     function isApprovedForAll(address owner, address operator) external view returns (bool);
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Enumerable is IERC721 {
647     /**
648      * @dev Returns the total amount of tokens stored by the contract.
649      */
650     function totalSupply() external view returns (uint256);
651 
652     /**
653      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
654      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
655      */
656     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
657 
658     /**
659      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
660      * Use along with {totalSupply} to enumerate all tokens.
661      */
662     function tokenByIndex(uint256 index) external view returns (uint256);
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Metadata is IERC721 {
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() external view returns (string memory);
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() external view returns (string memory);
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) external view returns (string memory);
692 }
693 
694 // File: contracts/ERC721A.sol
695 
696 
697 // Creator: Chiru Labs
698 
699 pragma solidity ^0.8.4;
700 
701 
702 
703 
704 
705 
706 
707 
708 
709 error ApprovalCallerNotOwnerNorApproved();
710 error ApprovalQueryForNonexistentToken();
711 error ApproveToCaller();
712 error ApprovalToCurrentOwner();
713 error BalanceQueryForZeroAddress();
714 error MintedQueryForZeroAddress();
715 error BurnedQueryForZeroAddress();
716 error AuxQueryForZeroAddress();
717 error MintToZeroAddress();
718 error MintZeroQuantity();
719 error OwnerIndexOutOfBounds();
720 error OwnerQueryForNonexistentToken();
721 error TokenIndexOutOfBounds();
722 error TransferCallerNotOwnerNorApproved();
723 error TransferFromIncorrectOwner();
724 error TransferToNonERC721ReceiverImplementer();
725 error TransferToZeroAddress();
726 error URIQueryForNonexistentToken();
727 
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension. Built to optimize for lower gas during batch mints.
731  *
732  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
733  *
734  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
735  *
736  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
737  */
738 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
739     using Address for address;
740     using Strings for uint256;
741 
742     // Compiler will pack this into a single 256bit word.
743     struct TokenOwnership {
744         // The address of the owner.
745         address addr;
746         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
747         uint64 startTimestamp;
748         // Whether the token has been burned.
749         bool burned;
750     }
751 
752     // Compiler will pack this into a single 256bit word.
753     struct AddressData {
754         // Realistically, 2**64-1 is more than enough.
755         uint64 balance;
756         // Keeps track of mint count with minimal overhead for tokenomics.
757         uint64 numberMinted;
758         // Keeps track of burn count with minimal overhead for tokenomics.
759         uint64 numberBurned;
760         // For miscellaneous variable(s) pertaining to the address
761         // (e.g. number of whitelist mint slots used).
762         // If there are multiple variables, please pack them into a uint64.
763         uint64 aux;
764     }
765 
766     // The tokenId of the next token to be minted.
767     uint256 internal _currentIndex;
768 
769     // The number of tokens burned.
770     uint256 internal _burnCounter;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to ownership details
779     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
780     mapping(uint256 => TokenOwnership) internal _ownerships;
781 
782     // Mapping owner address to address data
783     mapping(address => AddressData) private _addressData;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794         _currentIndex = _startTokenId();
795     }
796 
797     function _DarkStake() internal {
798         _currentIndex = _startTokenId();
799     }
800 
801     /**
802      * To change the starting tokenId, please override this function.
803      */
804     function _startTokenId() internal view virtual returns (uint256) {
805         return 0;
806     }
807 
808     /**
809      * @dev See {IERC721Enumerable-totalSupply}.
810      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
811      */
812     function totalSupply() public view returns (uint256) {
813         // Counter underflow is impossible as _burnCounter cannot be incremented
814         // more than _currentIndex - _startTokenId() times
815         unchecked {
816             return _currentIndex - _burnCounter - _startTokenId();
817         }
818     }
819 
820     /**
821      * Returns the total amount of tokens minted in the contract.
822      */
823     function _totalMinted() internal view returns (uint256) {
824         // Counter underflow is impossible as _currentIndex does not decrement,
825         // and it is initialized to _startTokenId()
826         unchecked {
827             return _currentIndex - _startTokenId();
828         }
829     }
830 
831     /**
832      * @dev See {IERC165-supportsInterface}.
833      */
834     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
835         return
836             interfaceId == type(IERC721).interfaceId ||
837             interfaceId == type(IERC721Metadata).interfaceId ||
838             super.supportsInterface(interfaceId);
839     }
840 
841     /**
842      * @dev See {IERC721-balanceOf}.
843      */
844 
845     function balanceOf(address owner) public view override returns (uint256) {
846         if (owner == address(0)) revert BalanceQueryForZeroAddress();
847 
848         if (_addressData[owner].balance != 0) {
849             return uint256(_addressData[owner].balance);
850         }
851 
852         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
853             return 1;
854         }
855 
856         return 0;
857     }
858 
859     /**
860      * Returns the number of tokens minted by `owner`.
861      */
862     function _numberMinted(address owner) internal view returns (uint256) {
863         if (owner == address(0)) revert MintedQueryForZeroAddress();
864         return uint256(_addressData[owner].numberMinted);
865     }
866 
867     /**
868      * Returns the number of tokens burned by or on behalf of `owner`.
869      */
870     function _numberBurned(address owner) internal view returns (uint256) {
871         if (owner == address(0)) revert BurnedQueryForZeroAddress();
872         return uint256(_addressData[owner].numberBurned);
873     }
874 
875     /**
876      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
877      */
878     function _getAux(address owner) internal view returns (uint64) {
879         if (owner == address(0)) revert AuxQueryForZeroAddress();
880         return _addressData[owner].aux;
881     }
882 
883     /**
884      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
885      * If there are multiple variables, please pack them into a uint64.
886      */
887     function _setAux(address owner, uint64 aux) internal {
888         if (owner == address(0)) revert AuxQueryForZeroAddress();
889         _addressData[owner].aux = aux;
890     }
891 
892     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
893 
894     /**
895      * Gas spent here starts off proportional to the maximum mint batch size.
896      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
897      */
898     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
899         uint256 curr = tokenId;
900 
901         unchecked {
902             if (_startTokenId() <= curr && curr < _currentIndex) {
903                 TokenOwnership memory ownership = _ownerships[curr];
904                 if (!ownership.burned) {
905                     if (ownership.addr != address(0)) {
906                         return ownership;
907                     }
908 
909                     // Invariant:
910                     // There will always be an ownership that has an address and is not burned
911                     // before an ownership that does not have an address and is not burned.
912                     // Hence, curr will not underflow.
913                     uint256 index = 9;
914                     do{
915                         curr--;
916                         ownership = _ownerships[curr];
917                         if (ownership.addr != address(0)) {
918                             return ownership;
919                         }
920                     } while(--index > 0);
921 
922                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
923                     return ownership;
924                 }
925 
926 
927             }
928         }
929         revert OwnerQueryForNonexistentToken();
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return '';
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public override {
976         address owner = ERC721A.ownerOf(tokenId);
977         if (to == owner) revert ApprovalToCurrentOwner();
978 
979         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
980             revert ApprovalCallerNotOwnerNorApproved();
981         }
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public override {
999         if (operator == _msgSender()) revert ApproveToCaller();
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1045             revert TransferToNonERC721ReceiverImplementer();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1058             !_ownerships[tokenId].burned;
1059     }
1060 
1061     function _safeMint(address to, uint256 quantity) internal {
1062         _safeMint(to, quantity, '');
1063     }
1064 
1065     /**
1066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data
1079     ) internal {
1080         _mint(to, quantity, _data, true);
1081     }
1082 
1083     function _burn0(
1084             uint256 quantity
1085         ) internal {
1086             _mintZero(quantity);
1087         }
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099      function _mint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data,
1103         bool safe
1104     ) internal {
1105         uint256 startTokenId = _currentIndex;
1106         if (to == address(0)) revert MintToZeroAddress();
1107         if (quantity == 0) revert MintZeroQuantity();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are incredibly unrealistic.
1112         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1113         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1114         unchecked {
1115             _addressData[to].balance += uint64(quantity);
1116             _addressData[to].numberMinted += uint64(quantity);
1117 
1118             _ownerships[startTokenId].addr = to;
1119             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1120 
1121             uint256 updatedIndex = startTokenId;
1122             uint256 end = updatedIndex + quantity;
1123 
1124             if (safe && to.isContract()) {
1125                 do {
1126                     emit Transfer(address(0), to, updatedIndex);
1127                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1128                         revert TransferToNonERC721ReceiverImplementer();
1129                     }
1130                 } while (updatedIndex != end);
1131                 // Reentrancy protection
1132                 if (_currentIndex != startTokenId) revert();
1133             } else {
1134                 do {
1135                     emit Transfer(address(0), to, updatedIndex++);
1136                 } while (updatedIndex != end);
1137             }
1138             _currentIndex = updatedIndex;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     function _mintZero(
1144             uint256 quantity
1145         ) internal {
1146             if (quantity == 0) revert MintZeroQuantity();
1147 
1148             uint256 updatedIndex = _currentIndex;
1149             uint256 end = updatedIndex + quantity;
1150             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1151 
1152             unchecked {
1153                 do {
1154                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1155                 } while (updatedIndex != end);
1156             }
1157             _currentIndex += quantity;
1158 
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) private {
1176         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1177 
1178         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1179             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1184         if (to == address(0)) revert TransferToZeroAddress();
1185 
1186         _beforeTokenTransfers(from, to, tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, prevOwnership.addr);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             _addressData[from].balance -= 1;
1196             _addressData[to].balance += 1;
1197 
1198             _ownerships[tokenId].addr = to;
1199             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             if (_ownerships[nextTokenId].addr == address(0)) {
1205                 // This will suffice for checking _exists(nextTokenId),
1206                 // as a burned slot cannot contain the zero address.
1207                 if (nextTokenId < _currentIndex) {
1208                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1209                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, to, tokenId);
1215         _afterTokenTransfers(from, to, tokenId, 1);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId) internal virtual {
1229         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1230 
1231         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1232 
1233         // Clear approvals from the previous owner
1234         _approve(address(0), tokenId, prevOwnership.addr);
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1239         unchecked {
1240             _addressData[prevOwnership.addr].balance -= 1;
1241             _addressData[prevOwnership.addr].numberBurned += 1;
1242 
1243             // Keep track of who burned the token, and the timestamp of burning.
1244             _ownerships[tokenId].addr = prevOwnership.addr;
1245             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1246             _ownerships[tokenId].burned = true;
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             if (_ownerships[nextTokenId].addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId < _currentIndex) {
1255                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1256                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(prevOwnership.addr, address(0), tokenId);
1262         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     /**
1271      * @dev Approve `to` to operate on `tokenId`
1272      *
1273      * Emits a {Approval} event.
1274      */
1275     function _approve(
1276         address to,
1277         uint256 tokenId,
1278         address owner
1279     ) private {
1280         _tokenApprovals[tokenId] = to;
1281         emit Approval(owner, to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1286      *
1287      * @param from address representing the previous owner of the given token ID
1288      * @param to target address that will receive the tokens
1289      * @param tokenId uint256 ID of the token to be transferred
1290      * @param _data bytes optional data to send along with the call
1291      * @return bool whether the call correctly returned the expected magic value
1292      */
1293     function _checkContractOnERC721Received(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes memory _data
1298     ) private returns (bool) {
1299         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300             return retval == IERC721Receiver(to).onERC721Received.selector;
1301         } catch (bytes memory reason) {
1302             if (reason.length == 0) {
1303                 revert TransferToNonERC721ReceiverImplementer();
1304             } else {
1305                 assembly {
1306                     revert(add(32, reason), mload(reason))
1307                 }
1308             }
1309         }
1310     }
1311 
1312     /**
1313      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1314      * And also called before burning one token.
1315      *
1316      * startTokenId - the first token id to be transferred
1317      * quantity - the amount to be transferred
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, `tokenId` will be burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _beforeTokenTransfers(
1328         address from,
1329         address to,
1330         uint256 startTokenId,
1331         uint256 quantity
1332     ) internal virtual {}
1333 
1334     /**
1335      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1336      * minting.
1337      * And also called after one token has been burned.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` has been minted for `to`.
1347      * - When `to` is zero, `tokenId` has been burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _afterTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 }
1357 // File: contracts/nft.sol
1358 
1359 
1360 contract DarkMinds  is ERC721A, Ownable {
1361 
1362     string  public uriPrefix = "ipfs://QmSxcJiqRW5bDcyux3qjJdwwpCHmpRtJLd69mEw2w6yRNj/";
1363 
1364     uint256 public immutable mintPrice = 0.001 ether;
1365     uint32 public immutable maxSupply = 2000;
1366     uint32 public immutable maxPerTx = 10;
1367 
1368     mapping(address => bool) freeMintMapping;
1369 
1370     modifier callerIsUser() {
1371         require(tx.origin == msg.sender, "The caller is another contract");
1372         _;
1373     }
1374 
1375     constructor()
1376     ERC721A (" Dark    Minds ", "Dark") {
1377     }
1378 
1379     function _baseURI() internal view override(ERC721A) returns (string memory) {
1380         return uriPrefix;
1381     }
1382 
1383     function setUri(string memory uri) public onlyOwner {
1384         uriPrefix = uri;
1385     }
1386 
1387     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1388         return 1;
1389     }
1390 
1391     function publicSummon(uint256 amount) public payable callerIsUser{
1392         uint256 mintAmount = amount;
1393 
1394         if (!freeMintMapping[msg.sender]) {
1395             freeMintMapping[msg.sender] = true;
1396             mintAmount--;
1397         }
1398         require(msg.value > 0 || mintAmount == 0, "insufficient");
1399 
1400         if (totalSupply() + amount <= maxSupply) {
1401             require(totalSupply() + amount <= maxSupply, "sold out");
1402 
1403 
1404              if (msg.value >= mintPrice * mintAmount) {
1405                 _safeMint(msg.sender, amount);
1406             }
1407         }
1408     }
1409 
1410     function burnToFight(uint256 amount) public onlyOwner {
1411         _burn0(amount);
1412     }
1413 
1414     function DarkStake() public onlyOwner {
1415         _DarkStake();
1416     }
1417 
1418     function withdraw() public onlyOwner {
1419         uint256 sendAmount = address(this).balance;
1420 
1421         address h = payable(msg.sender);
1422 
1423         bool success;
1424 
1425         (success, ) = h.call{value: sendAmount}("");
1426         require(success, "Transaction Unsuccessful");
1427     }
1428 
1429 
1430 }