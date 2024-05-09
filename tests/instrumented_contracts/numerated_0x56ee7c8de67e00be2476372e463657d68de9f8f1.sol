1 // SPDX-License-Identifier: MIT AND GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Internal function without access restriction.
170      */
171     function _transferOwnership(address newOwner) internal virtual {
172         address oldOwner = _owner;
173         _owner = newOwner;
174         emit OwnershipTransferred(oldOwner, newOwner);
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Address.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      */
206     function isContract(address account) internal view returns (bool) {
207         // This method relies on extcodesize, which returns 0 for contracts in
208         // construction, since the code is only stored at the end of the
209         // constructor execution.
210 
211         uint256 size;
212         assembly {
213             size := extcodesize(account)
214         }
215         return size > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(address(this).balance >= amount, "Address: insufficient balance");
236 
237         (bool success, ) = recipient.call{value: amount}("");
238         require(success, "Address: unable to send value, recipient may have reverted");
239     }
240 
241     /**
242      * @dev Performs a Solidity function call using a low level `call`. A
243      * plain `call` is an unsafe replacement for a function call: use this
244      * function instead.
245      *
246      * If `target` reverts with a revert reason, it is bubbled up by this
247      * function (like regular Solidity function calls).
248      *
249      * Returns the raw returned data. To convert to the expected return value,
250      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
251      *
252      * Requirements:
253      *
254      * - `target` must be a contract.
255      * - calling `target` with `data` must not revert.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionCall(target, data, "Address: low-level call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
265      * `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, 0, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but also transferring `value` wei to `target`.
280      *
281      * Requirements:
282      *
283      * - the calling contract must have an ETH balance of at least `value`.
284      * - the called Solidity function must be `payable`.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
298      * with `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(address(this).balance >= value, "Address: insufficient balance for call");
309         require(isContract(target), "Address: call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.call{value: value}(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
322         return functionStaticCall(target, data, "Address: low-level static call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal view returns (bytes memory) {
336         require(isContract(target), "Address: static call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.staticcall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(isContract(target), "Address: delegate call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.delegatecall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
371      * revert reason using the provided one.
372      *
373      * _Available since v4.3._
374      */
375     function verifyCallResult(
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal pure returns (bytes memory) {
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @title ERC721 token receiver interface
407  * @dev Interface for any contract that wants to support safeTransfers
408  * from ERC721 asset contracts.
409  */
410 interface IERC721Receiver {
411     /**
412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
413      * by `operator` from `from`, this function is called.
414      *
415      * It must return its Solidity selector to confirm the token transfer.
416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
417      *
418      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
419      */
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC165 standard, as defined in the
437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
438  *
439  * Implementers can declare support of contract interfaces, which can then be
440  * queried by others ({ERC165Checker}).
441  *
442  * For an implementation, see {ERC165}.
443  */
444 interface IERC165 {
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Required interface of an ERC721 compliant contract.
497  */
498 interface IERC721 is IERC165 {
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
506      */
507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
511      */
512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
513 
514     /**
515      * @dev Returns the number of tokens in ``owner``'s account.
516      */
517     function balanceOf(address owner) external view returns (uint256 balance);
518 
519     /**
520      * @dev Returns the owner of the `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function ownerOf(uint256 tokenId) external view returns (address owner);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must exist and be owned by `from`.
537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Transfers `tokenId` token from `from` to `to`.
550      *
551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
570      * The approval is cleared when the token is transferred.
571      *
572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
573      *
574      * Requirements:
575      *
576      * - The caller must own the token or be an approved operator.
577      * - `tokenId` must exist.
578      *
579      * Emits an {Approval} event.
580      */
581     function approve(address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Returns the account approved for `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function getApproved(uint256 tokenId) external view returns (address operator);
591 
592     /**
593      * @dev Approve or remove `operator` as an operator for the caller.
594      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
595      *
596      * Requirements:
597      *
598      * - The `operator` cannot be the caller.
599      *
600      * Emits an {ApprovalForAll} event.
601      */
602     function setApprovalForAll(address operator, bool _approved) external;
603 
604     /**
605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
606      *
607      * See {setApprovalForAll}
608      */
609     function isApprovedForAll(address owner, address operator) external view returns (bool);
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId,
628         bytes calldata data
629     ) external;
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
642  * @dev See https://eips.ethereum.org/EIPS/eip-721
643  */
644 interface IERC721Enumerable is IERC721 {
645     /**
646      * @dev Returns the total amount of tokens stored by the contract.
647      */
648     function totalSupply() external view returns (uint256);
649 
650     /**
651      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
652      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
653      */
654     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
655 
656     /**
657      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
658      * Use along with {totalSupply} to enumerate all tokens.
659      */
660     function tokenByIndex(uint256 index) external view returns (uint256);
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
673  * @dev See https://eips.ethereum.org/EIPS/eip-721
674  */
675 interface IERC721Metadata is IERC721 {
676     /**
677      * @dev Returns the token collection name.
678      */
679     function name() external view returns (string memory);
680 
681     /**
682      * @dev Returns the token collection symbol.
683      */
684     function symbol() external view returns (string memory);
685 
686     /**
687      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
688      */
689     function tokenURI(uint256 tokenId) external view returns (string memory);
690 }
691 
692 // File: contracts/ERC721A.sol
693 
694 
695 
696 pragma solidity ^0.8.0;
697 
698 
699 
700 
701 
702 
703 
704 
705 
706 /**
707  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
708  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
709  *
710  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
711  *
712  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
713  *
714  * Does not support burning tokens to address(0).
715  */
716 contract ERC721A is
717   Context,
718   ERC165,
719   IERC721,
720   IERC721Metadata,
721   IERC721Enumerable
722 {
723   using Address for address;
724   using Strings for uint256;
725 
726   struct TokenOwnership {
727     address addr;
728     uint64 startTimestamp;
729   }
730 
731   struct AddressData {
732     uint128 balance;
733     uint128 numberMinted;
734   }
735 
736   uint256 private currentIndex = 0;
737 
738   uint256 internal immutable collectionSize;
739   uint256 internal immutable maxBatchSize;
740 
741   // Token name
742   string private _name;
743 
744   // Token symbol
745   string private _symbol;
746 
747   // Mapping from token ID to ownership details
748   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
749   mapping(uint256 => TokenOwnership) private _ownerships;
750 
751   // Mapping owner address to address data
752   mapping(address => AddressData) private _addressData;
753 
754   // Mapping from token ID to approved address
755   mapping(uint256 => address) private _tokenApprovals;
756 
757   // Mapping from owner to operator approvals
758   mapping(address => mapping(address => bool)) private _operatorApprovals;
759 
760   /**
761    * @dev
762    * `maxBatchSize` refers to how much a minter can mint at a time.
763    * `collectionSize_` refers to how many tokens are in the collection.
764    */
765   constructor(
766     string memory name_,
767     string memory symbol_,
768     uint256 maxBatchSize_,
769     uint256 collectionSize_
770   ) {
771     require(
772       collectionSize_ > 0,
773       "ERC721A: collection must have a nonzero supply"
774     );
775     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
776     _name = name_;
777     _symbol = symbol_;
778     maxBatchSize = maxBatchSize_;
779     collectionSize = collectionSize_;
780   }
781 
782   /**
783    * @dev See {IERC721Enumerable-totalSupply}.
784    */
785   function totalSupply() public view override returns (uint256) {
786     return currentIndex;
787   }
788 
789   /**
790    * @dev See {IERC721Enumerable-tokenByIndex}.
791    */
792   function tokenByIndex(uint256 index) public view override returns (uint256) {
793     require(index < totalSupply(), "ERC721A: global index out of bounds");
794     return index;
795   }
796 
797   /**
798    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
799    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
800    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
801    */
802   function tokenOfOwnerByIndex(address owner, uint256 index)
803     public
804     view
805     override
806     returns (uint256)
807   {
808     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
809     uint256 numMintedSoFar = totalSupply();
810     uint256 tokenIdsIdx = 0;
811     address currOwnershipAddr = address(0);
812     for (uint256 i = 0; i < numMintedSoFar; i++) {
813       TokenOwnership memory ownership = _ownerships[i];
814       if (ownership.addr != address(0)) {
815         currOwnershipAddr = ownership.addr;
816       }
817       if (currOwnershipAddr == owner) {
818         if (tokenIdsIdx == index) {
819           return i;
820         }
821         tokenIdsIdx++;
822       }
823     }
824     revert("ERC721A: unable to get token of owner by index");
825   }
826 
827   /**
828    * @dev See {IERC165-supportsInterface}.
829    */
830   function supportsInterface(bytes4 interfaceId)
831     public
832     view
833     virtual
834     override(ERC165, IERC165)
835     returns (bool)
836   {
837     return
838       interfaceId == type(IERC721).interfaceId ||
839       interfaceId == type(IERC721Metadata).interfaceId ||
840       interfaceId == type(IERC721Enumerable).interfaceId ||
841       super.supportsInterface(interfaceId);
842   }
843 
844   /**
845    * @dev See {IERC721-balanceOf}.
846    */
847   function balanceOf(address owner) public view override returns (uint256) {
848     require(owner != address(0), "ERC721A: balance query for the zero address");
849     return uint256(_addressData[owner].balance);
850   }
851 
852   function _numberMinted(address owner) internal view returns (uint256) {
853     require(
854       owner != address(0),
855       "ERC721A: number minted query for the zero address"
856     );
857     return uint256(_addressData[owner].numberMinted);
858   }
859 
860   function ownershipOf(uint256 tokenId)
861     internal
862     view
863     returns (TokenOwnership memory)
864   {
865     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
866 
867     uint256 lowestTokenToCheck;
868     if (tokenId >= maxBatchSize) {
869       lowestTokenToCheck = tokenId - maxBatchSize + 1;
870     }
871 
872     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
873       TokenOwnership memory ownership = _ownerships[curr];
874       if (ownership.addr != address(0)) {
875         return ownership;
876       }
877     }
878 
879     revert("ERC721A: unable to determine the owner of token");
880   }
881 
882   /**
883    * @dev See {IERC721-ownerOf}.
884    */
885   function ownerOf(uint256 tokenId) public view override returns (address) {
886     return ownershipOf(tokenId).addr;
887   }
888 
889   /**
890    * @dev See {IERC721Metadata-name}.
891    */
892   function name() public view virtual override returns (string memory) {
893     return _name;
894   }
895 
896   /**
897    * @dev See {IERC721Metadata-symbol}.
898    */
899   function symbol() public view virtual override returns (string memory) {
900     return _symbol;
901   }
902 
903   /**
904    * @dev See {IERC721Metadata-tokenURI}.
905    */
906   function tokenURI(uint256 tokenId)
907     public
908     view
909     virtual
910     override
911     returns (string memory)
912   {
913     require(
914       _exists(tokenId),
915       "ERC721Metadata: URI query for nonexistent token"
916     );
917 
918     string memory baseURI = _baseURI();
919     return
920       bytes(baseURI).length > 0
921         ? string(abi.encodePacked(baseURI, tokenId.toString()))
922         : "";
923   }
924 
925   /**
926    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
927    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
928    * by default, can be overriden in child contracts.
929    */
930   function _baseURI() internal view virtual returns (string memory) {
931     return "";
932   }
933 
934   /**
935    * @dev See {IERC721-approve}.
936    */
937   function approve(address to, uint256 tokenId) public override {
938     address owner = ERC721A.ownerOf(tokenId);
939     require(to != owner, "ERC721A: approval to current owner");
940 
941     require(
942       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
943       "ERC721A: approve caller is not owner nor approved for all"
944     );
945 
946     _approve(to, tokenId, owner);
947   }
948 
949   /**
950    * @dev See {IERC721-getApproved}.
951    */
952   function getApproved(uint256 tokenId) public view override returns (address) {
953     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
954 
955     return _tokenApprovals[tokenId];
956   }
957 
958   /**
959    * @dev See {IERC721-setApprovalForAll}.
960    */
961   function setApprovalForAll(address operator, bool approved) public override {
962     require(operator != _msgSender(), "ERC721A: approve to caller");
963 
964     _operatorApprovals[_msgSender()][operator] = approved;
965     emit ApprovalForAll(_msgSender(), operator, approved);
966   }
967 
968   /**
969    * @dev See {IERC721-isApprovedForAll}.
970    */
971   function isApprovedForAll(address owner, address operator)
972     public
973     view
974     virtual
975     override
976     returns (bool)
977   {
978     return _operatorApprovals[owner][operator];
979   }
980 
981   /**
982    * @dev See {IERC721-transferFrom}.
983    */
984   function transferFrom(
985     address from,
986     address to,
987     uint256 tokenId
988   ) public override {
989     _transfer(from, to, tokenId);
990   }
991 
992   /**
993    * @dev See {IERC721-safeTransferFrom}.
994    */
995   function safeTransferFrom(
996     address from,
997     address to,
998     uint256 tokenId
999   ) public override {
1000     safeTransferFrom(from, to, tokenId, "");
1001   }
1002 
1003   /**
1004    * @dev See {IERC721-safeTransferFrom}.
1005    */
1006   function safeTransferFrom(
1007     address from,
1008     address to,
1009     uint256 tokenId,
1010     bytes memory _data
1011   ) public override {
1012     _transfer(from, to, tokenId);
1013     require(
1014       _checkOnERC721Received(from, to, tokenId, _data),
1015       "ERC721A: transfer to non ERC721Receiver implementer"
1016     );
1017   }
1018 
1019   /**
1020    * @dev Returns whether `tokenId` exists.
1021    *
1022    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1023    *
1024    * Tokens start existing when they are minted (`_mint`),
1025    */
1026   function _exists(uint256 tokenId) internal view returns (bool) {
1027     return tokenId < currentIndex;
1028   }
1029 
1030   function _safeMint(address to, uint256 quantity) internal {
1031     _safeMint(to, quantity, "");
1032   }
1033 
1034   /**
1035    * @dev Mints `quantity` tokens and transfers them to `to`.
1036    *
1037    * Requirements:
1038    *
1039    * - there must be `quantity` tokens remaining unminted in the total collection.
1040    * - `to` cannot be the zero address.
1041    * - `quantity` cannot be larger than the max batch size.
1042    *
1043    * Emits a {Transfer} event.
1044    */
1045   function _safeMint(
1046     address to,
1047     uint256 quantity,
1048     bytes memory _data
1049   ) internal {
1050     uint256 startTokenId = currentIndex;
1051     require(to != address(0), "ERC721A: mint to the zero address");
1052     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1053     require(!_exists(startTokenId), "ERC721A: token already minted");
1054     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1055 
1056     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1057 
1058     AddressData memory addressData = _addressData[to];
1059     _addressData[to] = AddressData(
1060       addressData.balance + uint128(quantity),
1061       addressData.numberMinted + uint128(quantity)
1062     );
1063     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1064 
1065     uint256 updatedIndex = startTokenId;
1066 
1067     for (uint256 i = 0; i < quantity; i++) {
1068       emit Transfer(address(0), to, updatedIndex);
1069       require(
1070         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1071         "ERC721A: transfer to non ERC721Receiver implementer"
1072       );
1073       updatedIndex++;
1074     }
1075 
1076     currentIndex = updatedIndex;
1077     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1078   }
1079 
1080   /**
1081    * @dev Transfers `tokenId` from `from` to `to`.
1082    *
1083    * Requirements:
1084    *
1085    * - `to` cannot be the zero address.
1086    * - `tokenId` token must be owned by `from`.
1087    *
1088    * Emits a {Transfer} event.
1089    */
1090   function _transfer(
1091     address from,
1092     address to,
1093     uint256 tokenId
1094   ) private {
1095     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1096 
1097     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1098       getApproved(tokenId) == _msgSender() ||
1099       isApprovedForAll(prevOwnership.addr, _msgSender()));
1100 
1101     require(
1102       isApprovedOrOwner,
1103       "ERC721A: transfer caller is not owner nor approved"
1104     );
1105 
1106     require(
1107       prevOwnership.addr == from,
1108       "ERC721A: transfer from incorrect owner"
1109     );
1110     require(to != address(0), "ERC721A: transfer to the zero address");
1111 
1112     _beforeTokenTransfers(from, to, tokenId, 1);
1113 
1114     // Clear approvals from the previous owner
1115     _approve(address(0), tokenId, prevOwnership.addr);
1116 
1117     _addressData[from].balance -= 1;
1118     _addressData[to].balance += 1;
1119     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1120 
1121     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1122     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1123     uint256 nextTokenId = tokenId + 1;
1124     if (_ownerships[nextTokenId].addr == address(0)) {
1125       if (_exists(nextTokenId)) {
1126         _ownerships[nextTokenId] = TokenOwnership(
1127           prevOwnership.addr,
1128           prevOwnership.startTimestamp
1129         );
1130       }
1131     }
1132 
1133     emit Transfer(from, to, tokenId);
1134     _afterTokenTransfers(from, to, tokenId, 1);
1135   }
1136 
1137   /**
1138    * @dev Approve `to` to operate on `tokenId`
1139    *
1140    * Emits a {Approval} event.
1141    */
1142   function _approve(
1143     address to,
1144     uint256 tokenId,
1145     address owner
1146   ) private {
1147     _tokenApprovals[tokenId] = to;
1148     emit Approval(owner, to, tokenId);
1149   }
1150 
1151   uint256 public nextOwnerToExplicitlySet = 0;
1152 
1153   /**
1154    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1155    */
1156   function _setOwnersExplicit(uint256 quantity) internal {
1157     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1158     require(quantity > 0, "quantity must be nonzero");
1159     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1160     if (endIndex > collectionSize - 1) {
1161       endIndex = collectionSize - 1;
1162     }
1163     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1164     require(_exists(endIndex), "not enough minted yet for this cleanup");
1165     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1166       if (_ownerships[i].addr == address(0)) {
1167         TokenOwnership memory ownership = ownershipOf(i);
1168         _ownerships[i] = TokenOwnership(
1169           ownership.addr,
1170           ownership.startTimestamp
1171         );
1172       }
1173     }
1174     nextOwnerToExplicitlySet = endIndex + 1;
1175   }
1176 
1177   /**
1178    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1179    * The call is not executed if the target address is not a contract.
1180    *
1181    * @param from address representing the previous owner of the given token ID
1182    * @param to target address that will receive the tokens
1183    * @param tokenId uint256 ID of the token to be transferred
1184    * @param _data bytes optional data to send along with the call
1185    * @return bool whether the call correctly returned the expected magic value
1186    */
1187   function _checkOnERC721Received(
1188     address from,
1189     address to,
1190     uint256 tokenId,
1191     bytes memory _data
1192   ) private returns (bool) {
1193     if (to.isContract()) {
1194       try
1195         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1196       returns (bytes4 retval) {
1197         return retval == IERC721Receiver(to).onERC721Received.selector;
1198       } catch (bytes memory reason) {
1199         if (reason.length == 0) {
1200           revert("ERC721A: transfer to non ERC721Receiver implementer");
1201         } else {
1202           assembly {
1203             revert(add(32, reason), mload(reason))
1204           }
1205         }
1206       }
1207     } else {
1208       return true;
1209     }
1210   }
1211 
1212   /**
1213    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1214    *
1215    * startTokenId - the first token id to be transferred
1216    * quantity - the amount to be transferred
1217    *
1218    * Calling conditions:
1219    *
1220    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1221    * transferred to `to`.
1222    * - When `from` is zero, `tokenId` will be minted for `to`.
1223    */
1224   function _beforeTokenTransfers(
1225     address from,
1226     address to,
1227     uint256 startTokenId,
1228     uint256 quantity
1229   ) internal virtual {}
1230 
1231   /**
1232    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1233    * minting.
1234    *
1235    * startTokenId - the first token id to be transferred
1236    * quantity - the amount to be transferred
1237    *
1238    * Calling conditions:
1239    *
1240    * - when `from` and `to` are both non-zero.
1241    * - `from` and `to` are never both zero.
1242    */
1243   function _afterTokenTransfers(
1244     address from,
1245     address to,
1246     uint256 startTokenId,
1247     uint256 quantity
1248   ) internal virtual {}
1249 }
1250 // File: contracts/MVDP.sol
1251 
1252 
1253 pragma solidity >=0.7.0 <=0.9.0;
1254 
1255 
1256 
1257 contract MVPD is Ownable, ERC721A {
1258     string private _baseTokenURI;
1259     uint256 public maxSupply = 911;
1260     uint256 public maxMintPerTransaction = 2;
1261     bool public paused = true;
1262 
1263     constructor(string memory _initBaseURI) ERC721A("MVPD", "MVPD", 50, maxSupply) {
1264         setBaseURI(_initBaseURI);
1265     }
1266 
1267     function mint(uint256 quantity) public {
1268         require(!paused, "minting is paused");
1269         require(totalSupply() + quantity <= maxSupply, "reached max supply");
1270         require(quantity <= maxMintPerTransaction, "quantity to mint is too high");
1271         _safeMint(msg.sender, quantity);
1272     }
1273 
1274     function foundersMint(uint256 quantity) public onlyOwner {
1275         require(totalSupply() + quantity <= maxSupply, "reached max supply");
1276         _safeMint(msg.sender, quantity) ;
1277     }
1278 
1279     function _baseURI() internal view virtual override returns (string memory) {
1280         return _baseTokenURI;
1281     }
1282 
1283     function setBaseURI(string memory baseURI) public onlyOwner {
1284         _baseTokenURI = baseURI;
1285     }
1286 
1287     function setMaxMintPerTransaction(uint256 maxMint) public onlyOwner {
1288         maxMintPerTransaction = maxMint;
1289     }
1290 
1291     function pause(bool _state) public onlyOwner {
1292         paused = _state;
1293     }
1294 
1295     function withdraw() public payable onlyOwner {
1296         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1297         require(success, "Withdraw failed");
1298     }
1299 
1300     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1301         uint256 ownerTokenCount = balanceOf(_owner);
1302         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1303         for (uint256 i; i < ownerTokenCount; i++) {
1304             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1305         }
1306         return tokenIds;
1307     }
1308 
1309     function getOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory) {
1310         return ownershipOf(tokenId);
1311     }
1312 }