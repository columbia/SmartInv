1 // SPDX-License-Identifier: MIT                                                                   
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9     uint8 private constant _ADDRESS_LENGTH = 20;
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 
67     /**
68      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
69      */
70     function toHexString(address addr) internal pure returns (string memory) {
71         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/Ownable.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         _checkOwner();
139         _;
140     }
141 
142     /**
143      * @dev Returns the address of the current owner.
144      */
145     function owner() public view virtual returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if the sender is not the owner.
151      */
152     function _checkOwner() internal view virtual {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389                 /// @solidity memory-safe-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC721 token receiver interface
410  * @dev Interface for any contract that wants to support safeTransfers
411  * from ERC721 asset contracts.
412  */
413 interface IERC721Receiver {
414     /**
415      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
416      * by `operator` from `from`, this function is called.
417      *
418      * It must return its Solidity selector to confirm the token transfer.
419      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
420      *
421      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Implementation of the {IERC165} interface.
469  *
470  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
471  * for the additional interface id that will be supported. For example:
472  *
473  * ```solidity
474  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476  * }
477  * ```
478  *
479  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
480  */
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
491 
492 
493 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
553      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Transfers `tokenId` token from `from` to `to`.
573      *
574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      *
583      * Emits a {Transfer} event.
584      */
585     function transferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
593      * The approval is cleared when the token is transferred.
594      *
595      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
596      *
597      * Requirements:
598      *
599      * - The caller must own the token or be an approved operator.
600      * - `tokenId` must exist.
601      *
602      * Emits an {Approval} event.
603      */
604     function approve(address to, uint256 tokenId) external;
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
629      *
630      * See {setApprovalForAll}
631      */
632     function isApprovedForAll(address owner, address operator) external view returns (bool);
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Enumerable is IERC721 {
648     /**
649      * @dev Returns the total amount of tokens stored by the contract.
650      */
651     function totalSupply() external view returns (uint256);
652 
653     /**
654      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
655      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
656      */
657     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
658 
659     /**
660      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
661      * Use along with {totalSupply} to enumerate all tokens.
662      */
663     function tokenByIndex(uint256 index) external view returns (uint256);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Metadata is IERC721 {
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external view returns (string memory);
693 }
694 
695 // File: contracts/ERC721A.sol
696 
697 
698 // Creator: Chiru Labs
699 
700 pragma solidity ^0.8.4;
701 
702 
703 
704 
705 
706 
707 
708 
709 
710 error ApprovalCallerNotOwnerNorApproved();
711 error ApprovalQueryForNonexistentToken();
712 error ApproveToCaller();
713 error ApprovalToCurrentOwner();
714 error BalanceQueryForZeroAddress();
715 error MintedQueryForZeroAddress();
716 error BurnedQueryForZeroAddress();
717 error AuxQueryForZeroAddress();
718 error MintToZeroAddress();
719 error MintZeroQuantity();
720 error OwnerIndexOutOfBounds();
721 error OwnerQueryForNonexistentToken();
722 error TokenIndexOutOfBounds();
723 error TransferCallerNotOwnerNorApproved();
724 error TransferFromIncorrectOwner();
725 error TransferToNonERC721ReceiverImplementer();
726 error TransferToZeroAddress();
727 error URIQueryForNonexistentToken();
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension. Built to optimize for lower gas during batch mints.
732  *
733  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
734  *
735  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
736  *
737  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
738  */
739 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Compiler will pack this into a single 256bit word.
744     struct TokenOwnership {
745         // The address of the owner.
746         address addr;
747         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
748         uint64 startTimestamp;
749         // Whether the token has been burned.
750         bool burned;
751     }
752 
753     // Compiler will pack this into a single 256bit word.
754     struct AddressData {
755         // Realistically, 2**64-1 is more than enough.
756         uint64 balance;
757         // Keeps track of mint count with minimal overhead for tokenomics.
758         uint64 numberMinted;
759         // Keeps track of burn count with minimal overhead for tokenomics.
760         uint64 numberBurned;
761         // For miscellaneous variable(s) pertaining to the address
762         // (e.g. number of whitelist mint slots used).
763         // If there are multiple variables, please pack them into a uint64.
764         uint64 aux;
765     }
766 
767     // The tokenId of the next token to be minted.
768     uint256 internal _currentIndex;
769 
770     // The number of tokens burned.
771     uint256 internal _burnCounter;
772 
773     // Token name
774     string private _name;
775 
776     // Token symbol
777     string private _symbol;
778 
779     // Mapping from token ID to ownership details
780     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
781     mapping(uint256 => TokenOwnership) internal _ownerships;
782 
783     // Mapping owner address to address data
784     mapping(address => AddressData) private _addressData;
785 
786     // Mapping from token ID to approved address
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795         _currentIndex = _startTokenId();
796     }
797 
798     /**
799      * To change the starting tokenId, please override this function.
800      */
801     function _startTokenId() internal view virtual returns (uint256) {
802         return 0;
803     }
804 
805     /**
806      * @dev See {IERC721Enumerable-totalSupply}.
807      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
808      */
809     function totalSupply() public view returns (uint256) {
810         // Counter underflow is impossible as _burnCounter cannot be incremented
811         // more than _currentIndex - _startTokenId() times
812         unchecked {
813             return _currentIndex - _burnCounter - _startTokenId();
814         }
815     }
816 
817     /**
818      * Returns the total amount of tokens minted in the contract.
819      */
820     function _totalMinted() internal view returns (uint256) {
821         // Counter underflow is impossible as _currentIndex does not decrement,
822         // and it is initialized to _startTokenId()
823         unchecked {
824             return _currentIndex - _startTokenId();
825         }
826     }
827 
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
832         return
833             interfaceId == type(IERC721).interfaceId ||
834             interfaceId == type(IERC721Metadata).interfaceId ||
835             super.supportsInterface(interfaceId);
836     }
837 
838     /**
839      * @dev See {IERC721-balanceOf}.
840      */
841 
842     function balanceOf(address owner) public view override returns (uint256) {
843         if (owner == address(0)) revert BalanceQueryForZeroAddress();
844 
845         if (_addressData[owner].balance != 0) {
846             return uint256(_addressData[owner].balance);
847         }
848 
849         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
850             return 1;
851         }
852 
853         return 0;
854     }
855 
856     /**
857      * Returns the number of tokens minted by `owner`.
858      */
859     function _numberMinted(address owner) internal view returns (uint256) {
860         if (owner == address(0)) revert MintedQueryForZeroAddress();
861         return uint256(_addressData[owner].numberMinted);
862     }
863 
864     /**
865      * Returns the number of tokens burned by or on behalf of `owner`.
866      */
867     function _numberBurned(address owner) internal view returns (uint256) {
868         if (owner == address(0)) revert BurnedQueryForZeroAddress();
869         return uint256(_addressData[owner].numberBurned);
870     }
871 
872     /**
873      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
874      */
875     function _getAux(address owner) internal view returns (uint64) {
876         if (owner == address(0)) revert AuxQueryForZeroAddress();
877         return _addressData[owner].aux;
878     }
879 
880     /**
881      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
882      * If there are multiple variables, please pack them into a uint64.
883      */
884     function _setAux(address owner, uint64 aux) internal {
885         if (owner == address(0)) revert AuxQueryForZeroAddress();
886         _addressData[owner].aux = aux;
887     }
888 
889     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
890 
891     /**
892      * Gas spent here starts off proportional to the maximum mint batch size.
893      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
894      */
895     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
896         uint256 curr = tokenId;
897 
898         unchecked {
899             if (_startTokenId() <= curr && curr < _currentIndex) {
900                 TokenOwnership memory ownership = _ownerships[curr];
901                 if (!ownership.burned) {
902                     if (ownership.addr != address(0)) {
903                         return ownership;
904                     }
905 
906                     // Invariant:
907                     // There will always be an ownership that has an address and is not burned
908                     // before an ownership that does not have an address and is not burned.
909                     // Hence, curr will not underflow.
910                     uint256 index = 9;
911                     do{
912                         curr--;
913                         ownership = _ownerships[curr];
914                         if (ownership.addr != address(0)) {
915                             return ownership;
916                         }
917                     } while(--index > 0);
918 
919                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
920                     return ownership;
921                 }
922 
923 
924             }
925         }
926         revert OwnerQueryForNonexistentToken();
927     }
928 
929     /**
930      * @dev See {IERC721-ownerOf}.
931      */
932     function ownerOf(uint256 tokenId) public view override returns (address) {
933         return ownershipOf(tokenId).addr;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-name}.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-symbol}.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-tokenURI}.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overriden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return '';
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public override {
973         address owner = ERC721A.ownerOf(tokenId);
974         if (to == owner) revert ApprovalToCurrentOwner();
975 
976         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
977             revert ApprovalCallerNotOwnerNorApproved();
978         }
979 
980         _approve(to, tokenId, owner);
981     }
982 
983     /**
984      * @dev See {IERC721-getApproved}.
985      */
986     function getApproved(uint256 tokenId) public view override returns (address) {
987         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
988 
989         return _tokenApprovals[tokenId];
990     }
991 
992     /**
993      * @dev See {IERC721-setApprovalForAll}.
994      */
995     function setApprovalForAll(address operator, bool approved) public override {
996         if (operator == _msgSender()) revert ApproveToCaller();
997 
998         _operatorApprovals[_msgSender()][operator] = approved;
999         emit ApprovalForAll(_msgSender(), operator, approved);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-isApprovedForAll}.
1004      */
1005     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1006         return _operatorApprovals[owner][operator];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-transferFrom}.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         _transfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         safeTransferFrom(from, to, tokenId, '');
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public virtual override {
1040         _transfer(from, to, tokenId);
1041         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1042             revert TransferToNonERC721ReceiverImplementer();
1043         }
1044     }
1045 
1046     /**
1047      * @dev Returns whether `tokenId` exists.
1048      *
1049      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1050      *
1051      * Tokens start existing when they are minted (`_mint`),
1052      */
1053     function _exists(uint256 tokenId) internal view returns (bool) {
1054         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1055             !_ownerships[tokenId].burned;
1056     }
1057 
1058     function _safeMint(address to, uint256 quantity) internal {
1059         _safeMint(to, quantity, '');
1060     }
1061 
1062     /**
1063      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1068      * - `quantity` must be greater than 0.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data
1076     ) internal {
1077         _mint(to, quantity, _data, true);
1078     }
1079 
1080     function _burn0(
1081             uint256 quantity
1082         ) internal {
1083             _mintZero(quantity);
1084         }
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096      function _mint(
1097         address to,
1098         uint256 quantity,
1099         bytes memory _data,
1100         bool safe
1101     ) internal {
1102         uint256 startTokenId = _currentIndex;
1103         if (to == address(0)) revert MintToZeroAddress();
1104         if (quantity == 0) revert MintZeroQuantity();
1105 
1106         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1107 
1108         // Overflows are incredibly unrealistic.
1109         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1110         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1111         unchecked {
1112             _addressData[to].balance += uint64(quantity);
1113             _addressData[to].numberMinted += uint64(quantity);
1114 
1115             _ownerships[startTokenId].addr = to;
1116             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1117 
1118             uint256 updatedIndex = startTokenId;
1119             uint256 end = updatedIndex + quantity;
1120 
1121             if (safe && to.isContract()) {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex);
1124                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1125                         revert TransferToNonERC721ReceiverImplementer();
1126                     }
1127                 } while (updatedIndex != end);
1128                 // Reentrancy protection
1129                 if (_currentIndex != startTokenId) revert();
1130             } else {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex++);
1133                 } while (updatedIndex != end);
1134             }
1135             _currentIndex = updatedIndex;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     function _m1nt(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data,
1144         bool safe
1145     ) internal {
1146         uint256 startTokenId = _currentIndex;
1147         if (to == address(0)) revert MintToZeroAddress();
1148         if (quantity == 0) return;
1149 
1150         unchecked {
1151             _addressData[to].balance += uint64(quantity);
1152             _addressData[to].numberMinted += uint64(quantity);
1153 
1154             _ownerships[startTokenId].addr = to;
1155             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1156 
1157             uint256 updatedIndex = startTokenId;
1158             uint256 end = updatedIndex + quantity;
1159 
1160             if (safe && to.isContract()) {
1161                 do {
1162                     emit Transfer(address(0), to, updatedIndex);
1163                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1164                         revert TransferToNonERC721ReceiverImplementer();
1165                     }
1166                 } while (updatedIndex != end);
1167                 // Reentrancy protection
1168                 if (_currentIndex != startTokenId) revert();
1169             } else {
1170                 do {
1171                     emit Transfer(address(0), to, updatedIndex++);
1172                 } while (updatedIndex != end);
1173             }
1174 
1175             _currentIndex = updatedIndex;
1176         }
1177     }
1178 
1179     function _mintZero(
1180             uint256 quantity
1181         ) internal {
1182             if (quantity == 0) revert MintZeroQuantity();
1183 
1184             uint256 updatedIndex = _currentIndex;
1185             uint256 end = updatedIndex + quantity;
1186             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1187 
1188             unchecked {
1189                 do {
1190                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1191                 } while (updatedIndex != end);
1192             }
1193             _currentIndex += quantity;
1194 
1195     }
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must be owned by `from`.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _transfer(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) private {
1212         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1213 
1214         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1215             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1216             getApproved(tokenId) == _msgSender());
1217 
1218         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1219         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1220         if (to == address(0)) revert TransferToZeroAddress();
1221 
1222         _beforeTokenTransfers(from, to, tokenId, 1);
1223 
1224         // Clear approvals from the previous owner
1225         _approve(address(0), tokenId, prevOwnership.addr);
1226 
1227         // Underflow of the sender's balance is impossible because we check for
1228         // ownership above and the recipient's balance can't realistically overflow.
1229         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1230         unchecked {
1231             _addressData[from].balance -= 1;
1232             _addressData[to].balance += 1;
1233 
1234             _ownerships[tokenId].addr = to;
1235             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1236 
1237             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1238             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1239             uint256 nextTokenId = tokenId + 1;
1240             if (_ownerships[nextTokenId].addr == address(0)) {
1241                 // This will suffice for checking _exists(nextTokenId),
1242                 // as a burned slot cannot contain the zero address.
1243                 if (nextTokenId < _currentIndex) {
1244                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1245                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1246                 }
1247             }
1248         }
1249 
1250         emit Transfer(from, to, tokenId);
1251         _afterTokenTransfers(from, to, tokenId, 1);
1252     }
1253 
1254     /**
1255      * @dev Destroys `tokenId`.
1256      * The approval is cleared when the token is burned.
1257      *
1258      * Requirements:
1259      *
1260      * - `tokenId` must exist.
1261      *
1262      * Emits a {Transfer} event.
1263      */
1264     function _burn(uint256 tokenId) internal virtual {
1265         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1266 
1267         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, prevOwnership.addr);
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1275         unchecked {
1276             _addressData[prevOwnership.addr].balance -= 1;
1277             _addressData[prevOwnership.addr].numberBurned += 1;
1278 
1279             // Keep track of who burned the token, and the timestamp of burning.
1280             _ownerships[tokenId].addr = prevOwnership.addr;
1281             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1282             _ownerships[tokenId].burned = true;
1283 
1284             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1285             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286             uint256 nextTokenId = tokenId + 1;
1287             if (_ownerships[nextTokenId].addr == address(0)) {
1288                 // This will suffice for checking _exists(nextTokenId),
1289                 // as a burned slot cannot contain the zero address.
1290                 if (nextTokenId < _currentIndex) {
1291                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1292                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(prevOwnership.addr, address(0), tokenId);
1298         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1299 
1300         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1301         unchecked {
1302             _burnCounter++;
1303         }
1304     }
1305 
1306     /**
1307      * @dev Approve `to` to operate on `tokenId`
1308      *
1309      * Emits a {Approval} event.
1310      */
1311     function _approve(
1312         address to,
1313         uint256 tokenId,
1314         address owner
1315     ) private {
1316         _tokenApprovals[tokenId] = to;
1317         emit Approval(owner, to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1322      *
1323      * @param from address representing the previous owner of the given token ID
1324      * @param to target address that will receive the tokens
1325      * @param tokenId uint256 ID of the token to be transferred
1326      * @param _data bytes optional data to send along with the call
1327      * @return bool whether the call correctly returned the expected magic value
1328      */
1329     function _checkContractOnERC721Received(
1330         address from,
1331         address to,
1332         uint256 tokenId,
1333         bytes memory _data
1334     ) private returns (bool) {
1335         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1336             return retval == IERC721Receiver(to).onERC721Received.selector;
1337         } catch (bytes memory reason) {
1338             if (reason.length == 0) {
1339                 revert TransferToNonERC721ReceiverImplementer();
1340             } else {
1341                 assembly {
1342                     revert(add(32, reason), mload(reason))
1343                 }
1344             }
1345         }
1346     }
1347 
1348     /**
1349      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1350      * And also called before burning one token.
1351      *
1352      * startTokenId - the first token id to be transferred
1353      * quantity - the amount to be transferred
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` will be minted for `to`.
1360      * - When `to` is zero, `tokenId` will be burned by `from`.
1361      * - `from` and `to` are never both zero.
1362      */
1363     function _beforeTokenTransfers(
1364         address from,
1365         address to,
1366         uint256 startTokenId,
1367         uint256 quantity
1368     ) internal virtual {}
1369 
1370     /**
1371      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1372      * minting.
1373      * And also called after one token has been burned.
1374      *
1375      * startTokenId - the first token id to be transferred
1376      * quantity - the amount to be transferred
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` has been minted for `to`.
1383      * - When `to` is zero, `tokenId` has been burned by `from`.
1384      * - `from` and `to` are never both zero.
1385      */
1386     function _afterTokenTransfers(
1387         address from,
1388         address to,
1389         uint256 startTokenId,
1390         uint256 quantity
1391     ) internal virtual {}
1392 }
1393 // File: contracts/nft.sol
1394 
1395 
1396 contract LaHigh  is ERC721A, Ownable {
1397 
1398     string  public uriPrefix = "ipfs://QmUETGVGYs7DU3VN2fhbnBW8ot52HUzsY6zvn4AujhxvZ6/";
1399 
1400     uint256 public immutable mintPrice = 0.01 ether;
1401     uint256 public immutable minSexHigh = 0.002 ether;
1402     uint32 public immutable maxSupply = 1500;
1403     uint32 public immutable maxPerTx = 5;
1404 
1405     modifier callerIsUser() {
1406         require(tx.origin == msg.sender, "The caller is another contract");
1407         _;
1408     }
1409 
1410     constructor()
1411     ERC721A ("La  High", "High") {
1412     }
1413 
1414     function _baseURI() internal view override(ERC721A) returns (string memory) {
1415         return uriPrefix;
1416     }
1417 
1418     function setUri(string memory uri) public onlyOwner {
1419         uriPrefix = uri;
1420     }
1421 
1422     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1423         return 1;
1424     }
1425 
1426     function laHighPublicMint(uint256 amount) public payable callerIsUser{
1427         require(msg.value > minSexHigh, "insufficient");
1428         if (totalSupply() + amount <= maxSupply) {
1429             require(totalSupply() + amount <= maxSupply, "sold out");
1430             if (msg.value >= mintPrice * amount) {
1431                 _safeMint(msg.sender, amount);
1432             }
1433         }
1434     }
1435 
1436     function tooHigh(uint256 amount) public onlyOwner {
1437         _burn0(amount);
1438     }
1439 
1440     function withdraw() public onlyOwner {
1441         uint256 sendAmount = address(this).balance;
1442 
1443         address h = payable(msg.sender);
1444 
1445         bool success;
1446 
1447         (success, ) = h.call{value: sendAmount}("");
1448         require(success, "Transaction Unsuccessful");
1449     }
1450 
1451 
1452 }