1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
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
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
389 
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
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
421      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
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
698 
699 // Creator: Chiru Labs
700 
701 
702 
703 pragma solidity ^0.8.4;
704 
705 
706 
707 
708 
709 
710 
711 
712 
713 
714 
715 error ApprovalCallerNotOwnerNorApproved();
716 
717 error ApprovalQueryForNonexistentToken();
718 
719 error ApproveToCaller();
720 
721 error ApprovalToCurrentOwner();
722 
723 error BalanceQueryForZeroAddress();
724 
725 error MintedQueryForZeroAddress();
726 
727 error BurnedQueryForZeroAddress();
728 
729 error AuxQueryForZeroAddress();
730 
731 error MintToZeroAddress();
732 
733 error MintZeroQuantity();
734 
735 error OwnerIndexOutOfBounds();
736 
737 error OwnerQueryForNonexistentToken();
738 
739 error TokenIndexOutOfBounds();
740 
741 error TransferCallerNotOwnerNorApproved();
742 
743 error TransferFromIncorrectOwner();
744 
745 error TransferToNonERC721ReceiverImplementer();
746 
747 error TransferToZeroAddress();
748 
749 error URIQueryForNonexistentToken();
750 
751 
752 
753 /**
754 
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756 
757  * the Metadata extension. Built to optimize for lower gas during batch mints.
758 
759  *
760 
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762 
763  *
764 
765  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
766 
767  *
768 
769  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
770 
771  */
772 
773 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
774 
775     using Address for address;
776 
777     using Strings for uint256;
778 
779 
780 
781     // Compiler will pack this into a single 256bit word.
782 
783     struct TokenOwnership {
784 
785         // The address of the owner.
786 
787         address addr;
788 
789         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
790 
791         uint64 startTimestamp;
792 
793         // Whether the token has been burned.
794 
795         bool burned;
796 
797     }
798 
799 
800 
801     // Compiler will pack this into a single 256bit word.
802 
803     struct AddressData {
804 
805         // Realistically, 2**64-1 is more than enough.
806 
807         uint64 balance;
808 
809         // Keeps track of mint count with minimal overhead for tokenomics.
810 
811         uint64 numberMinted;
812 
813         // Keeps track of burn count with minimal overhead for tokenomics.
814 
815         uint64 numberBurned;
816 
817         // For miscellaneous variable(s) pertaining to the address
818 
819         // (e.g. number of whitelist mint slots used).
820 
821         // If there are multiple variables, please pack them into a uint64.
822 
823         uint64 aux;
824 
825     }
826 
827 
828 
829     // The tokenId of the next token to be minted.
830 
831     uint256 internal _currentIndex;
832 
833 
834 
835     // The number of tokens burned.
836 
837     uint256 internal _burnCounter;
838 
839 
840 
841     // Token name
842 
843     string private _name;
844 
845 
846 
847     // Token symbol
848 
849     string private _symbol;
850 
851 
852 
853     // Mapping from token ID to ownership details
854 
855     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
856 
857     mapping(uint256 => TokenOwnership) internal _ownerships;
858 
859 
860 
861     // Mapping owner address to address data
862 
863     mapping(address => AddressData) private _addressData;
864 
865 
866 
867     // Mapping from token ID to approved address
868 
869     mapping(uint256 => address) private _tokenApprovals;
870 
871 
872 
873     // Mapping from owner to operator approvals
874 
875     mapping(address => mapping(address => bool)) private _operatorApprovals;
876 
877 
878 
879     constructor(string memory name_, string memory symbol_) {
880 
881         _name = name_;
882 
883         _symbol = symbol_;
884 
885         _currentIndex = _startTokenId();
886 
887     }
888 
889 
890 
891     /**
892 
893      * To change the starting tokenId, please override this function.
894 
895      */
896 
897     function _startTokenId() internal view virtual returns (uint256) {
898 
899         return 0;
900 
901     }
902 
903 
904 
905     /**
906 
907      * @dev See {IERC721Enumerable-totalSupply}.
908 
909      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
910 
911      */
912 
913     function totalSupply() public view returns (uint256) {
914 
915         // Counter underflow is impossible as _burnCounter cannot be incremented
916 
917         // more than _currentIndex - _startTokenId() times
918 
919         unchecked {
920 
921             return _currentIndex - _burnCounter - _startTokenId();
922 
923         }
924 
925     }
926 
927 
928 
929     /**
930 
931      * Returns the total amount of tokens minted in the contract.
932 
933      */
934 
935     function _totalMinted() internal view returns (uint256) {
936 
937         // Counter underflow is impossible as _currentIndex does not decrement,
938 
939         // and it is initialized to _startTokenId()
940 
941         unchecked {
942 
943             return _currentIndex - _startTokenId();
944 
945         }
946 
947     }
948 
949 
950 
951     /**
952 
953      * @dev See {IERC165-supportsInterface}.
954 
955      */
956 
957     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
958 
959         return
960 
961             interfaceId == type(IERC721).interfaceId ||
962 
963             interfaceId == type(IERC721Metadata).interfaceId ||
964 
965             super.supportsInterface(interfaceId);
966 
967     }
968 
969 
970 
971     /**
972 
973      * @dev See {IERC721-balanceOf}.
974 
975      */
976 
977     function balanceOf(address owner) public view override returns (uint256) {
978 
979         if (owner == address(0)) revert BalanceQueryForZeroAddress();
980 
981         return uint256(_addressData[owner].balance);
982 
983     }
984 
985 
986 
987     /**
988 
989      * Returns the number of tokens minted by `owner`.
990 
991      */
992 
993     function _numberMinted(address owner) internal view returns (uint256) {
994 
995         if (owner == address(0)) revert MintedQueryForZeroAddress();
996 
997         return uint256(_addressData[owner].numberMinted);
998 
999     }
1000 
1001 
1002 
1003     /**
1004 
1005      * Returns the number of tokens burned by or on behalf of `owner`.
1006 
1007      */
1008 
1009     function _numberBurned(address owner) internal view returns (uint256) {
1010 
1011         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1012 
1013         return uint256(_addressData[owner].numberBurned);
1014 
1015     }
1016 
1017 
1018 
1019     /**
1020 
1021      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1022 
1023      */
1024 
1025     function _getAux(address owner) internal view returns (uint64) {
1026 
1027         if (owner == address(0)) revert AuxQueryForZeroAddress();
1028 
1029         return _addressData[owner].aux;
1030 
1031     }
1032 
1033 
1034 
1035     /**
1036 
1037      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1038 
1039      * If there are multiple variables, please pack them into a uint64.
1040 
1041      */
1042 
1043     function _setAux(address owner, uint64 aux) internal {
1044 
1045         if (owner == address(0)) revert AuxQueryForZeroAddress();
1046 
1047         _addressData[owner].aux = aux;
1048 
1049     }
1050 
1051 
1052 
1053     /**
1054 
1055      * Gas spent here starts off proportional to the maximum mint batch size.
1056 
1057      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1058 
1059      */
1060 
1061     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1062 
1063         uint256 curr = tokenId;
1064 
1065 
1066 
1067         unchecked {
1068 
1069             if (_startTokenId() <= curr && curr < _currentIndex) {
1070 
1071                 TokenOwnership memory ownership = _ownerships[curr];
1072 
1073                 if (!ownership.burned) {
1074 
1075                     if (ownership.addr != address(0)) {
1076 
1077                         return ownership;
1078 
1079                     }
1080 
1081                     // Invariant:
1082 
1083                     // There will always be an ownership that has an address and is not burned
1084 
1085                     // before an ownership that does not have an address and is not burned.
1086 
1087                     // Hence, curr will not underflow.
1088 
1089                     while (true) {
1090 
1091                         curr--;
1092 
1093                         ownership = _ownerships[curr];
1094 
1095                         if (ownership.addr != address(0)) {
1096 
1097                             return ownership;
1098 
1099                         }
1100 
1101                     }
1102 
1103                 }
1104 
1105             }
1106 
1107         }
1108 
1109         revert OwnerQueryForNonexistentToken();
1110 
1111     }
1112 
1113 
1114 
1115     /**
1116 
1117      * @dev See {IERC721-ownerOf}.
1118 
1119      */
1120 
1121     function ownerOf(uint256 tokenId) public view override returns (address) {
1122 
1123         return ownershipOf(tokenId).addr;
1124 
1125     }
1126 
1127 
1128 
1129     /**
1130 
1131      * @dev See {IERC721Metadata-name}.
1132 
1133      */
1134 
1135     function name() public view virtual override returns (string memory) {
1136 
1137         return _name;
1138 
1139     }
1140 
1141 
1142 
1143     /**
1144 
1145      * @dev See {IERC721Metadata-symbol}.
1146 
1147      */
1148 
1149     function symbol() public view virtual override returns (string memory) {
1150 
1151         return _symbol;
1152 
1153     }
1154 
1155 
1156 
1157     /**
1158 
1159      * @dev See {IERC721Metadata-tokenURI}.
1160 
1161      */
1162 
1163     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1164 
1165         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1166 
1167 
1168 
1169         string memory baseURI = _baseURI();
1170 
1171         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1172 
1173     }
1174 
1175 
1176 
1177     /**
1178 
1179      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1180 
1181      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1182 
1183      * by default, can be overriden in child contracts.
1184 
1185      */
1186 
1187     function _baseURI() internal view virtual returns (string memory) {
1188 
1189         return '';
1190 
1191     }
1192 
1193 
1194 
1195     /**
1196 
1197      * @dev See {IERC721-approve}.
1198 
1199      */
1200 
1201     function approve(address to, uint256 tokenId) public override {
1202 
1203         address owner = ERC721A.ownerOf(tokenId);
1204 
1205         if (to == owner) revert ApprovalToCurrentOwner();
1206 
1207 
1208 
1209         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1210 
1211             revert ApprovalCallerNotOwnerNorApproved();
1212 
1213         }
1214 
1215 
1216 
1217         _approve(to, tokenId, owner);
1218 
1219     }
1220 
1221 
1222 
1223     /**
1224 
1225      * @dev See {IERC721-getApproved}.
1226 
1227      */
1228 
1229     function getApproved(uint256 tokenId) public view override returns (address) {
1230 
1231         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1232 
1233 
1234 
1235         return _tokenApprovals[tokenId];
1236 
1237     }
1238 
1239 
1240 
1241     /**
1242 
1243      * @dev See {IERC721-setApprovalForAll}.
1244 
1245      */
1246 
1247     function setApprovalForAll(address operator, bool approved) public override {
1248 
1249         if (operator == _msgSender()) revert ApproveToCaller();
1250 
1251 
1252 
1253         _operatorApprovals[_msgSender()][operator] = approved;
1254 
1255         emit ApprovalForAll(_msgSender(), operator, approved);
1256 
1257     }
1258 
1259 
1260 
1261     /**
1262 
1263      * @dev See {IERC721-isApprovedForAll}.
1264 
1265      */
1266 
1267     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1268 
1269         return _operatorApprovals[owner][operator];
1270 
1271     }
1272 
1273 
1274 
1275     /**
1276 
1277      * @dev See {IERC721-transferFrom}.
1278 
1279      */
1280 
1281     function transferFrom(
1282 
1283         address from,
1284 
1285         address to,
1286 
1287         uint256 tokenId
1288 
1289     ) public virtual override {
1290 
1291         _transfer(from, to, tokenId);
1292 
1293     }
1294 
1295 
1296 
1297     /**
1298 
1299      * @dev See {IERC721-safeTransferFrom}.
1300 
1301      */
1302 
1303     function safeTransferFrom(
1304 
1305         address from,
1306 
1307         address to,
1308 
1309         uint256 tokenId
1310 
1311     ) public virtual override {
1312 
1313         safeTransferFrom(from, to, tokenId, '');
1314 
1315     }
1316 
1317 
1318 
1319     /**
1320 
1321      * @dev See {IERC721-safeTransferFrom}.
1322 
1323      */
1324 
1325     function safeTransferFrom(
1326 
1327         address from,
1328 
1329         address to,
1330 
1331         uint256 tokenId,
1332 
1333         bytes memory _data
1334 
1335     ) public virtual override {
1336 
1337         _transfer(from, to, tokenId);
1338 
1339         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1340 
1341             revert TransferToNonERC721ReceiverImplementer();
1342 
1343         }
1344 
1345     }
1346 
1347 
1348 
1349     /**
1350 
1351      * @dev Returns whether `tokenId` exists.
1352 
1353      *
1354 
1355      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1356 
1357      *
1358 
1359      * Tokens start existing when they are minted (`_mint`),
1360 
1361      */
1362 
1363     function _exists(uint256 tokenId) internal view returns (bool) {
1364 
1365         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1366 
1367             !_ownerships[tokenId].burned;
1368 
1369     }
1370 
1371 
1372 
1373     function _safeMint(address to, uint256 quantity) internal {
1374 
1375         _safeMint(to, quantity, '');
1376 
1377     }
1378 
1379 
1380 
1381     /**
1382 
1383      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1384 
1385      *
1386 
1387      * Requirements:
1388 
1389      *
1390 
1391      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1392 
1393      * - `quantity` must be greater than 0.
1394 
1395      *
1396 
1397      * Emits a {Transfer} event.
1398 
1399      */
1400 
1401     function _safeMint(
1402 
1403         address to,
1404 
1405         uint256 quantity,
1406 
1407         bytes memory _data
1408 
1409     ) internal {
1410 
1411         _mint(to, quantity, _data, true);
1412 
1413     }
1414 
1415 
1416 
1417     /**
1418 
1419      * @dev Mints `quantity` tokens and transfers them to `to`.
1420 
1421      *
1422 
1423      * Requirements:
1424 
1425      *
1426 
1427      * - `to` cannot be the zero address.
1428 
1429      * - `quantity` must be greater than 0.
1430 
1431      *
1432 
1433      * Emits a {Transfer} event.
1434 
1435      */
1436 
1437     function _mint(
1438 
1439         address to,
1440 
1441         uint256 quantity,
1442 
1443         bytes memory _data,
1444 
1445         bool safe
1446 
1447     ) internal {
1448 
1449         uint256 startTokenId = _currentIndex;
1450 
1451         if (to == address(0)) revert MintToZeroAddress();
1452 
1453         if (quantity == 0) revert MintZeroQuantity();
1454 
1455 
1456 
1457         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1458 
1459 
1460 
1461         // Overflows are incredibly unrealistic.
1462 
1463         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1464 
1465         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1466 
1467         unchecked {
1468 
1469             _addressData[to].balance += uint64(quantity);
1470 
1471             _addressData[to].numberMinted += uint64(quantity);
1472 
1473 
1474 
1475             _ownerships[startTokenId].addr = to;
1476 
1477             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1478 
1479 
1480 
1481             uint256 updatedIndex = startTokenId;
1482 
1483             uint256 end = updatedIndex + quantity;
1484 
1485 
1486 
1487             if (safe && to.isContract()) {
1488 
1489                 do {
1490 
1491                     emit Transfer(address(0), to, updatedIndex);
1492 
1493                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1494 
1495                         revert TransferToNonERC721ReceiverImplementer();
1496 
1497                     }
1498 
1499                 } while (updatedIndex != end);
1500 
1501                 // Reentrancy protection
1502 
1503                 if (_currentIndex != startTokenId) revert();
1504 
1505             } else {
1506 
1507                 do {
1508 
1509                     emit Transfer(address(0), to, updatedIndex++);
1510 
1511                 } while (updatedIndex != end);
1512 
1513             }
1514 
1515             _currentIndex = updatedIndex;
1516 
1517         }
1518 
1519         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1520 
1521     }
1522 
1523 
1524 
1525     /**
1526 
1527      * @dev Transfers `tokenId` from `from` to `to`.
1528 
1529      *
1530 
1531      * Requirements:
1532 
1533      *
1534 
1535      * - `to` cannot be the zero address.
1536 
1537      * - `tokenId` token must be owned by `from`.
1538 
1539      *
1540 
1541      * Emits a {Transfer} event.
1542 
1543      */
1544 
1545     function _transfer(
1546 
1547         address from,
1548 
1549         address to,
1550 
1551         uint256 tokenId
1552 
1553     ) private {
1554 
1555         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1556 
1557 
1558 
1559         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1560 
1561             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1562 
1563             getApproved(tokenId) == _msgSender());
1564 
1565 
1566 
1567         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1568 
1569         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1570 
1571         if (to == address(0)) revert TransferToZeroAddress();
1572 
1573 
1574 
1575         _beforeTokenTransfers(from, to, tokenId, 1);
1576 
1577 
1578 
1579         // Clear approvals from the previous owner
1580 
1581         _approve(address(0), tokenId, prevOwnership.addr);
1582 
1583 
1584 
1585         // Underflow of the sender's balance is impossible because we check for
1586 
1587         // ownership above and the recipient's balance can't realistically overflow.
1588 
1589         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1590 
1591         unchecked {
1592 
1593             _addressData[from].balance -= 1;
1594 
1595             _addressData[to].balance += 1;
1596 
1597 
1598 
1599             _ownerships[tokenId].addr = to;
1600 
1601             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1602 
1603 
1604 
1605             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1606 
1607             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1608 
1609             uint256 nextTokenId = tokenId + 1;
1610 
1611             if (_ownerships[nextTokenId].addr == address(0)) {
1612 
1613                 // This will suffice for checking _exists(nextTokenId),
1614 
1615                 // as a burned slot cannot contain the zero address.
1616 
1617                 if (nextTokenId < _currentIndex) {
1618 
1619                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1620 
1621                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1622 
1623                 }
1624 
1625             }
1626 
1627         }
1628 
1629 
1630 
1631         emit Transfer(from, to, tokenId);
1632 
1633         _afterTokenTransfers(from, to, tokenId, 1);
1634 
1635     }
1636 
1637 
1638 
1639     /**
1640 
1641      * @dev Destroys `tokenId`.
1642 
1643      * The approval is cleared when the token is burned.
1644 
1645      *
1646 
1647      * Requirements:
1648 
1649      *
1650 
1651      * - `tokenId` must exist.
1652 
1653      *
1654 
1655      * Emits a {Transfer} event.
1656 
1657      */
1658 
1659     function _burn(uint256 tokenId) internal virtual {
1660 
1661         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1662 
1663 
1664 
1665         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1666 
1667 
1668 
1669         // Clear approvals from the previous owner
1670 
1671         _approve(address(0), tokenId, prevOwnership.addr);
1672 
1673 
1674 
1675         // Underflow of the sender's balance is impossible because we check for
1676 
1677         // ownership above and the recipient's balance can't realistically overflow.
1678 
1679         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1680 
1681         unchecked {
1682 
1683             _addressData[prevOwnership.addr].balance -= 1;
1684 
1685             _addressData[prevOwnership.addr].numberBurned += 1;
1686 
1687 
1688 
1689             // Keep track of who burned the token, and the timestamp of burning.
1690 
1691             _ownerships[tokenId].addr = prevOwnership.addr;
1692 
1693             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1694 
1695             _ownerships[tokenId].burned = true;
1696 
1697 
1698 
1699             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1700 
1701             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1702 
1703             uint256 nextTokenId = tokenId + 1;
1704 
1705             if (_ownerships[nextTokenId].addr == address(0)) {
1706 
1707                 // This will suffice for checking _exists(nextTokenId),
1708 
1709                 // as a burned slot cannot contain the zero address.
1710 
1711                 if (nextTokenId < _currentIndex) {
1712 
1713                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1714 
1715                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1716 
1717                 }
1718 
1719             }
1720 
1721         }
1722 
1723 
1724 
1725         emit Transfer(prevOwnership.addr, address(0), tokenId);
1726 
1727         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1728 
1729 
1730 
1731         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1732 
1733         unchecked {
1734 
1735             _burnCounter++;
1736 
1737         }
1738 
1739     }
1740 
1741 
1742 
1743     /**
1744 
1745      * @dev Approve `to` to operate on `tokenId`
1746 
1747      *
1748 
1749      * Emits a {Approval} event.
1750 
1751      */
1752 
1753     function _approve(
1754 
1755         address to,
1756 
1757         uint256 tokenId,
1758 
1759         address owner
1760 
1761     ) private {
1762 
1763         _tokenApprovals[tokenId] = to;
1764 
1765         emit Approval(owner, to, tokenId);
1766 
1767     }
1768 
1769 
1770 
1771     /**
1772 
1773      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1774 
1775      *
1776 
1777      * @param from address representing the previous owner of the given token ID
1778 
1779      * @param to target address that will receive the tokens
1780 
1781      * @param tokenId uint256 ID of the token to be transferred
1782 
1783      * @param _data bytes optional data to send along with the call
1784 
1785      * @return bool whether the call correctly returned the expected magic value
1786 
1787      */
1788 
1789     function _checkContractOnERC721Received(
1790 
1791         address from,
1792 
1793         address to,
1794 
1795         uint256 tokenId,
1796 
1797         bytes memory _data
1798 
1799     ) private returns (bool) {
1800 
1801         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1802 
1803             return retval == IERC721Receiver(to).onERC721Received.selector;
1804 
1805         } catch (bytes memory reason) {
1806 
1807             if (reason.length == 0) {
1808 
1809                 revert TransferToNonERC721ReceiverImplementer();
1810 
1811             } else {
1812 
1813                 assembly {
1814 
1815                     revert(add(32, reason), mload(reason))
1816 
1817                 }
1818 
1819             }
1820 
1821         }
1822 
1823     }
1824 
1825 
1826 
1827     /**
1828 
1829      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1830 
1831      * And also called before burning one token.
1832 
1833      *
1834 
1835      * startTokenId - the first token id to be transferred
1836 
1837      * quantity - the amount to be transferred
1838 
1839      *
1840 
1841      * Calling conditions:
1842 
1843      *
1844 
1845      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1846 
1847      * transferred to `to`.
1848 
1849      * - When `from` is zero, `tokenId` will be minted for `to`.
1850 
1851      * - When `to` is zero, `tokenId` will be burned by `from`.
1852 
1853      * - `from` and `to` are never both zero.
1854 
1855      */
1856 
1857     function _beforeTokenTransfers(
1858 
1859         address from,
1860 
1861         address to,
1862 
1863         uint256 startTokenId,
1864 
1865         uint256 quantity
1866 
1867     ) internal virtual {}
1868 
1869 
1870 
1871     /**
1872 
1873      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1874 
1875      * minting.
1876 
1877      * And also called after one token has been burned.
1878 
1879      *
1880 
1881      * startTokenId - the first token id to be transferred
1882 
1883      * quantity - the amount to be transferred
1884 
1885      *
1886 
1887      * Calling conditions:
1888 
1889      *
1890 
1891      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1892 
1893      * transferred to `to`.
1894 
1895      * - When `from` is zero, `tokenId` has been minted for `to`.
1896 
1897      * - When `to` is zero, `tokenId` has been burned by `from`.
1898 
1899      * - `from` and `to` are never both zero.
1900 
1901      */
1902 
1903     function _afterTokenTransfers(
1904 
1905         address from,
1906 
1907         address to,
1908 
1909         uint256 startTokenId,
1910 
1911         uint256 quantity
1912 
1913     ) internal virtual {}
1914 
1915 }
1916 
1917 
1918 // File: contracts/RezdRobs.sol
1919 
1920 
1921 
1922 pragma solidity ^0.8.4;
1923 
1924 
1925 
1926 
1927 
1928 
1929 contract RezdRobs is ERC721A, Ownable {
1930 
1931     string uriBase = "ipfs://QmcQ9TJ5cKNuneFgjRJuCDMopyur1tH7fiVBvjNsJeHr87/";
1932 
1933     string public baseExtension = ".json";
1934 
1935     uint256 public maxSupply = 7777;
1936 
1937     uint256 public maxFreeAmount = 500;
1938 
1939     uint256 public freeCount = 0;
1940 
1941     bool public isFree = true;
1942 
1943     uint256 public cost = 0.03 ether;
1944 
1945     uint256 public maxMintPerWallet = 5;
1946 
1947     bool public isSale = false;
1948 
1949     mapping(address => uint256) public addressesMintedBalance;
1950 
1951 
1952 
1953     constructor() ERC721A("Rezd Robs", "REZ") { }
1954 
1955 
1956 
1957     /// @notice mints a token, using the ERC721A. Paying the cost if free mint has ended
1958 
1959     /// @dev mint a token, using ERC721A. Owner mints free and don't apply to the freeCount. If freeCount >= maxFreeAmount the user have to pay.
1960 
1961     function mint (uint256 quantity) external payable {
1962 
1963         uint256 supply = totalSupply();
1964 
1965 
1966 
1967         require(quantity > 0, "Invalid mint amount.");
1968 
1969         require(supply + quantity <= maxSupply, "Not enough tokens left.");
1970 
1971 
1972 
1973        if (msg.sender != owner()) {
1974 
1975             require(quantity <= maxMintPerWallet, "Mint amount exceeds the maximum amount per wallet.");
1976 
1977             require(isSale, "Contract is paused.");
1978 
1979 
1980 
1981             if (freeCount + quantity >= maxFreeAmount) {
1982 
1983                 if(isFree)
1984 
1985                 {
1986 
1987                     uint256 difference = (freeCount + quantity) - maxFreeAmount;
1988 
1989                     require(msg.value >= cost * difference, "Not enough ether sent.");
1990 
1991                     isFree = false;
1992 
1993                     freeCount += difference;
1994 
1995                 }
1996 
1997                 else
1998 
1999                 {
2000 
2001                     require(msg.value >= cost * quantity, "Not enough ether sent.");
2002 
2003                 }
2004 
2005             }
2006 
2007 
2008 
2009             uint256 senderMintedCount = addressesMintedBalance[msg.sender];
2010 
2011 
2012 
2013             require(senderMintedCount + quantity <= maxMintPerWallet, "Max. NFT per address exceeded.");
2014 
2015 
2016 
2017             addressesMintedBalance[msg.sender] += quantity;
2018 
2019 
2020 
2021             if(isFree)
2022 
2023                 freeCount += quantity;
2024 
2025        }
2026 
2027 
2028 
2029        _safeMint(msg.sender, quantity);
2030 
2031     }
2032 
2033 
2034 
2035     function _baseURI() internal view override returns (string memory) {
2036 
2037         return uriBase;
2038 
2039     }
2040 
2041 
2042 
2043     /// @dev returns base URI for token
2044 
2045     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2046 
2047         require(_exists(tokenId), "Token already exists");
2048 
2049         return bytes(uriBase).length != 0 ? string(abi.encodePacked(uriBase, Strings.toString(tokenId), baseExtension)) : '';
2050 
2051     }
2052 
2053 
2054 
2055     /// @dev overriding the ERC721A startTokenID to 1. Otherwise the first token will be 0.
2056 
2057     function _startTokenId() internal view virtual override returns (uint256) {
2058 
2059         return 1;
2060 
2061     }
2062 
2063 
2064 
2065     /// @dev set the maxMintPerWallet amount of tokens that can be minted from a wallet.
2066 
2067     function setMaxMintAmount(uint256 _newAmount) public onlyOwner {
2068 
2069         maxMintPerWallet = _newAmount;
2070 
2071     }
2072 
2073 
2074 
2075     /// @dev set the cost
2076 
2077     function setCost(uint256 _newCost) public onlyOwner {
2078 
2079         cost = _newCost;
2080 
2081     }
2082 
2083 
2084 
2085     /// @dev set the actual individual token image URI (IPFS)
2086 
2087     function setBaseURI(string memory _newURI) public onlyOwner {
2088 
2089         uriBase = _newURI;
2090 
2091     }
2092 
2093 
2094 
2095     /// @dev set the baseExtension of the Metadata (e.G json, xml,..)
2096 
2097     function setBaseExtension(string memory _newBaseExtension) public onlyOwner
2098 
2099     {
2100 
2101         baseExtension = _newBaseExtension;
2102 
2103     }
2104 
2105 
2106 
2107     /// @dev set isSale. True: Users can mint; False: only owner can mint
2108 
2109     function setIsSale(bool _state) public onlyOwner {
2110 
2111         isSale = _state;
2112 
2113     }
2114 
2115 
2116 
2117     function withdraw() external payable onlyOwner {
2118 
2119         payable(owner()).transfer(address(this).balance);
2120 
2121     }
2122 
2123 }