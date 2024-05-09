1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title ERC721 token receiver interface
12  * @dev Interface for any contract that wants to support safeTransfers
13  * from ERC721 asset contracts.
14  */
15 interface IERC721Receiver {
16     /**
17      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
18      * by `operator` from `from`, this function is called.
19      *
20      * It must return its Solidity selector to confirm the token transfer.
21      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
22      *
23      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
24      */
25     function onERC721Received(
26         address operator,
27         address from,
28         uint256 tokenId,
29         bytes calldata data
30     ) external returns (bytes4);
31 }
32 
33 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45  * queried by others ({ERC165Checker}).
46  *
47  * For an implementation, see {ERC165}.
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
62 
63 
64 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 
69 /**
70  * @dev Required interface of an ERC721 compliant contract.
71  */
72 interface IERC721 is IERC165 {
73     /**
74      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
77 
78     /**
79      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
80      */
81     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
82 
83     /**
84      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
85      */
86     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
87 
88     /**
89      * @dev Returns the number of tokens in ``owner``'s account.
90      */
91     function balanceOf(address owner) external view returns (uint256 balance);
92 
93     /**
94      * @dev Returns the owner of the `tokenId` token.
95      *
96      * Requirements:
97      *
98      * - `tokenId` must exist.
99      */
100     function ownerOf(uint256 tokenId) external view returns (address owner);
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must exist and be owned by `from`.
111      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
113      *
114      * Emits a {Transfer} event.
115      */
116     function safeTransferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address from,
138         address to,
139         uint256 tokenId
140     ) external;
141 
142     /**
143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
144      * The approval is cleared when the token is transferred.
145      *
146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
147      *
148      * Requirements:
149      *
150      * - The caller must own the token or be an approved operator.
151      * - `tokenId` must exist.
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Approve or remove `operator` as an operator for the caller.
168      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
169      *
170      * Requirements:
171      *
172      * - The `operator` cannot be the caller.
173      *
174      * Emits an {ApprovalForAll} event.
175      */
176     function setApprovalForAll(address operator, bool _approved) external;
177 
178     /**
179      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
180      *
181      * See {setApprovalForAll}
182      */
183     function isApprovedForAll(address owner, address operator) external view returns (bool);
184 
185     /**
186      * @dev Safely transfers `tokenId` token from `from` to `to`.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must exist and be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
194      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195      *
196      * Emits a {Transfer} event.
197      */
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId,
202         bytes calldata data
203     ) external;
204 }
205 
206 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
207 
208 
209 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
210 
211 pragma solidity ^0.8.0;
212 
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Enumerable is IERC721 {
219     /**
220      * @dev Returns the total amount of tokens stored by the contract.
221      */
222     function totalSupply() external view returns (uint256);
223 
224     /**
225      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
226      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
227      */
228     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
229 
230     /**
231      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
232      * Use along with {totalSupply} to enumerate all tokens.
233      */
234     function tokenByIndex(uint256 index) external view returns (uint256);
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 
245 /**
246  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
247  * @dev See https://eips.ethereum.org/EIPS/eip-721
248  */
249 interface IERC721Metadata is IERC721 {
250     /**
251      * @dev Returns the token collection name.
252      */
253     function name() external view returns (string memory);
254 
255     /**
256      * @dev Returns the token collection symbol.
257      */
258     function symbol() external view returns (string memory);
259 
260     /**
261      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
262      */
263     function tokenURI(uint256 tokenId) external view returns (string memory);
264 }
265 
266 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @dev Implementation of the {IERC165} interface.
276  *
277  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
278  * for the additional interface id that will be supported. For example:
279  *
280  * ```solidity
281  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
282  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
283  * }
284  * ```
285  *
286  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
287  */
288 abstract contract ERC165 is IERC165 {
289     /**
290      * @dev See {IERC165-supportsInterface}.
291      */
292     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
293         return interfaceId == type(IERC165).interfaceId;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
301 
302 pragma solidity ^0.8.1;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      *
325      * [IMPORTANT]
326      * ====
327      * You shouldn't rely on `isContract` to protect against flash loan attacks!
328      *
329      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
330      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
331      * constructor.
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize/address.code.length, which returns 0
336         // for contracts in construction, since the code is only stored at the end
337         // of the constructor execution.
338 
339         return account.code.length > 0;
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      */
358     function sendValue(address payable recipient, uint256 amount) internal {
359         require(address(this).balance >= amount, "Address: insufficient balance");
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain `call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
422      * with `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         require(isContract(target), "Address: call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.call{value: value}(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal view returns (bytes memory) {
460         require(isContract(target), "Address: static call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(isContract(target), "Address: delegate call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: @openzeppelin/contracts/utils/Strings.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
537      */
538     function toString(uint256 value) internal pure returns (string memory) {
539         // Inspired by OraclizeAPI's implementation - MIT licence
540         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
541 
542         if (value == 0) {
543             return "0";
544         }
545         uint256 temp = value;
546         uint256 digits;
547         while (temp != 0) {
548             digits++;
549             temp /= 10;
550         }
551         bytes memory buffer = new bytes(digits);
552         while (value != 0) {
553             digits -= 1;
554             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
555             value /= 10;
556         }
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
562      */
563     function toHexString(uint256 value) internal pure returns (string memory) {
564         if (value == 0) {
565             return "0x00";
566         }
567         uint256 temp = value;
568         uint256 length = 0;
569         while (temp != 0) {
570             length++;
571             temp >>= 8;
572         }
573         return toHexString(value, length);
574     }
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
578      */
579     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
580         bytes memory buffer = new bytes(2 * length + 2);
581         buffer[0] = "0";
582         buffer[1] = "x";
583         for (uint256 i = 2 * length + 1; i > 1; --i) {
584             buffer[i] = _HEX_SYMBOLS[value & 0xf];
585             value >>= 4;
586         }
587         require(value == 0, "Strings: hex length insufficient");
588         return string(buffer);
589     }
590 }
591 
592 // File: @openzeppelin/contracts/utils/Context.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Provides information about the current execution context, including the
601  * sender of the transaction and its data. While these are generally available
602  * via msg.sender and msg.data, they should not be accessed in such a direct
603  * manner, since when dealing with meta-transactions the account sending and
604  * paying for execution may not be the actual sender (as far as an application
605  * is concerned).
606  *
607  * This contract is only required for intermediate, library-like contracts.
608  */
609 abstract contract Context {
610     function _msgSender() internal view virtual returns (address) {
611         return msg.sender;
612     }
613 
614     function _msgData() internal view virtual returns (bytes calldata) {
615         return msg.data;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/access/Ownable.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @dev Contract module which provides a basic access control mechanism, where
629  * there is an account (an owner) that can be granted exclusive access to
630  * specific functions.
631  *
632  * By default, the owner account will be the one that deploys the contract. This
633  * can later be changed with {transferOwnership}.
634  *
635  * This module is used through inheritance. It will make available the modifier
636  * `onlyOwner`, which can be applied to your functions to restrict their use to
637  * the owner.
638  */
639 abstract contract Ownable is Context {
640     address private _owner;
641 
642     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
643 
644     /**
645      * @dev Initializes the contract setting the deployer as the initial owner.
646      */
647     constructor() {
648         _transferOwnership(_msgSender());
649     }
650 
651     /**
652      * @dev Returns the address of the current owner.
653      */
654     function owner() public view virtual returns (address) {
655         return _owner;
656     }
657 
658     /**
659      * @dev Throws if called by any account other than the owner.
660      */
661     modifier onlyOwner() {
662         require(owner() == _msgSender(), "Ownable: caller is not the owner");
663         _;
664     }
665 
666     /**
667      * @dev Leaves the contract without owner. It will not be possible to call
668      * `onlyOwner` functions anymore. Can only be called by the current owner.
669      *
670      * NOTE: Renouncing ownership will leave the contract without an owner,
671      * thereby removing any functionality that is only available to the owner.
672      */
673     function renounceOwnership() public virtual onlyOwner {
674         _transferOwnership(address(0));
675     }
676 
677     /**
678      * @dev Transfers ownership of the contract to a new account (`newOwner`).
679      * Can only be called by the current owner.
680      */
681     function transferOwnership(address newOwner) public virtual onlyOwner {
682         require(newOwner != address(0), "Ownable: new owner is the zero address");
683         _transferOwnership(newOwner);
684     }
685 
686     /**
687      * @dev Transfers ownership of the contract to a new account (`newOwner`).
688      * Internal function without access restriction.
689      */
690     function _transferOwnership(address newOwner) internal virtual {
691         address oldOwner = _owner;
692         _owner = newOwner;
693         emit OwnershipTransferred(oldOwner, newOwner);
694     }
695 }
696 
697 // File: contracts/1_Storage.sol
698 
699 
700 
701 
702 
703 
704 
705 
706 
707 
708 
709 pragma solidity ^0.8.7;
710 
711 contract ERC721A is Context, ERC165, IERC721Metadata, IERC721Enumerable {
712   using Address for address;
713   using Strings for uint256;
714 
715   struct TokenOwnership {
716     address addr;
717     uint64 startTimestamp;
718   }
719 
720   struct AddressData {
721     uint128 balance;
722     uint128 numberMinted;
723   }
724 
725   uint256 private currentIndex = 1;
726 
727   uint256 internal immutable collectionSize;
728   uint256 internal immutable maxBatchSize;
729 
730   // Token name
731   string private _name;
732 
733   // Token symbol
734   string private _symbol;
735 
736   // Mapping from token ID to ownership details
737   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
738   mapping(uint256 => TokenOwnership) private _ownerships;
739 
740   // Mapping owner address to address data
741   mapping(address => AddressData) private _addressData;
742 
743   // Mapping from token ID to approved address
744   mapping(uint256 => address) private _tokenApprovals;
745 
746   // Mapping from owner to operator approvals
747   mapping(address => mapping(address => bool)) private _operatorApprovals;
748 
749   /**
750    * @dev
751    * `maxBatchSize` refers to how much a minter can mint at a time.
752    * `collectionSize_` refers to how many tokens are in the collection.
753    */
754   constructor(
755     string memory name_,
756     string memory symbol_,
757     uint256 maxBatchSize_,
758     uint256 collectionSize_
759   ) {
760     require(
761       collectionSize_ > 0,
762       "ERC721A: collection must have a nonzero supply"
763     );
764     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
765     _name = name_;
766     _symbol = symbol_;
767     maxBatchSize = maxBatchSize_;
768     collectionSize = collectionSize_;
769   }
770 
771   /**
772    * @dev See {IERC721Enumerable-totalSupply}.
773    */
774   function totalSupply() public view override returns (uint256) {
775     return currentIndex - 1;
776   }
777 
778   /**
779    * @dev See {IERC721Enumerable-tokenByIndex}.
780    */
781   function tokenByIndex(uint256 index) public view override returns (uint256) {
782     require(index < totalSupply(), "ERC721A: global index out of bounds");
783     return index;
784   }
785 
786   /**
787    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
788    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
789    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
790    */
791   function tokenOfOwnerByIndex(address owner, uint256 index)
792     public
793     view
794     override
795     returns (uint256)
796   {
797     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
798     uint256 numMintedSoFar = totalSupply();
799     uint256 tokenIdsIdx = 0;
800     address currOwnershipAddr = address(0);
801     for (uint256 i = 0; i < numMintedSoFar; i++) {
802       TokenOwnership memory ownership = _ownerships[i];
803       if (ownership.addr != address(0)) {
804         currOwnershipAddr = ownership.addr;
805       }
806       if (currOwnershipAddr == owner) {
807         if (tokenIdsIdx == index) {
808           return i;
809         }
810         tokenIdsIdx++;
811       }
812     }
813     revert("ERC721A: unable to get token of owner by index");
814   }
815 
816   /**
817    * @dev See {IERC165-supportsInterface}.
818    */
819   function supportsInterface(bytes4 interfaceId)
820     public
821     view
822     virtual
823     override(ERC165, IERC165)
824     returns (bool)
825   {
826     return
827       interfaceId == type(IERC721).interfaceId ||
828       interfaceId == type(IERC721Metadata).interfaceId ||
829       interfaceId == type(IERC721Enumerable).interfaceId ||
830       super.supportsInterface(interfaceId);
831   }
832 
833   /**
834    * @dev See {IERC721-balanceOf}.
835    */
836   function balanceOf(address owner) public view override returns (uint256) {
837     require(owner != address(0), "ERC721A: balance query for the zero address");
838     return uint256(_addressData[owner].balance);
839   }
840 
841   function _numberMinted(address owner) internal view returns (uint256) {
842     require(
843       owner != address(0),
844       "ERC721A: number minted query for the zero address"
845     );
846     return uint256(_addressData[owner].numberMinted);
847   }
848 
849   function ownershipOf(uint256 tokenId)
850     internal
851     view
852     returns (TokenOwnership memory)
853   {
854     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
855 
856     uint256 lowestTokenToCheck;
857     if (tokenId >= maxBatchSize) {
858       lowestTokenToCheck = tokenId - maxBatchSize + 1;
859     }
860 
861     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
862       TokenOwnership memory ownership = _ownerships[curr];
863       if (ownership.addr != address(0)) {
864         return ownership;
865       }
866     }
867 
868     revert("ERC721A: unable to determine the owner of token");
869   }
870 
871   /**
872    * @dev See {IERC721-ownerOf}.
873    */
874   function ownerOf(uint256 tokenId) public view override returns (address) {
875     return ownershipOf(tokenId).addr;
876   }
877 
878   /**
879    * @dev See {IERC721Metadata-name}.
880    */
881   function name() public view virtual override returns (string memory) {
882     return _name;
883   }
884 
885   /**
886    * @dev See {IERC721Metadata-symbol}.
887    */
888   function symbol() public view virtual override returns (string memory) {
889     return _symbol;
890   }
891 
892   /**
893    * @dev See {IERC721Metadata-tokenURI}.
894    */
895   function tokenURI(uint256 tokenId)
896     public
897     view
898     virtual
899     override
900     returns (string memory)
901   {
902     require(
903       _exists(tokenId),
904       "ERC721Metadata: URI query for nonexistent token"
905     );
906 
907     string memory baseURI = _baseURI();
908     return
909       bytes(baseURI).length > 0
910         ? string(abi.encodePacked(baseURI, tokenId.toString()))
911         : "";
912   }
913 
914   /**
915    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
916    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
917    * by default, can be overriden in child contracts.
918    */
919   function _baseURI() internal view virtual returns (string memory) {
920     return "";
921   }
922 
923   /**
924    * @dev See {IERC721-approve}.
925    */
926   function approve(address to, uint256 tokenId) public override {
927     address owner = ERC721A.ownerOf(tokenId);
928     require(to != owner, "ERC721A: approval to current owner");
929 
930     require(
931       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
932       "ERC721A: approve caller is not owner nor approved for all"
933     );
934 
935     _approve(to, tokenId, owner);
936   }
937 
938   /**
939    * @dev See {IERC721-getApproved}.
940    */
941   function getApproved(uint256 tokenId) public view override returns (address) {
942     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
943 
944     return _tokenApprovals[tokenId];
945   }
946 
947   /**
948    * @dev See {IERC721-setApprovalForAll}.
949    */
950   function setApprovalForAll(address operator, bool approved) public override {
951     require(operator != _msgSender(), "ERC721A: approve to caller");
952 
953     _operatorApprovals[_msgSender()][operator] = approved;
954     emit ApprovalForAll(_msgSender(), operator, approved);
955   }
956 
957   /**
958    * @dev See {IERC721-isApprovedForAll}.
959    */
960   function isApprovedForAll(address owner, address operator)
961     public
962     view
963     virtual
964     override
965     returns (bool)
966   {
967     return _operatorApprovals[owner][operator];
968   }
969 
970   /**
971    * @dev See {IERC721-transferFrom}.
972    */
973   function transferFrom(
974     address from,
975     address to,
976     uint256 tokenId
977   ) public override {
978     _transfer(from, to, tokenId);
979   }
980 
981   /**
982    * @dev See {IERC721-safeTransferFrom}.
983    */
984   function safeTransferFrom(
985     address from,
986     address to,
987     uint256 tokenId
988   ) public override {
989     safeTransferFrom(from, to, tokenId, "");
990   }
991 
992   /**
993    * @dev See {IERC721-safeTransferFrom}.
994    */
995   function safeTransferFrom(
996     address from,
997     address to,
998     uint256 tokenId,
999     bytes memory _data
1000   ) public override {
1001     _transfer(from, to, tokenId);
1002     require(
1003       _checkOnERC721Received(from, to, tokenId, _data),
1004       "ERC721A: transfer to non ERC721Receiver implementer"
1005     );
1006   }
1007 
1008   /**
1009    * @dev Returns whether `tokenId` exists.
1010    *
1011    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012    *
1013    * Tokens start existing when they are minted (`_mint`),
1014    */
1015   function _exists(uint256 tokenId) internal view returns (bool) {
1016     return tokenId < currentIndex;
1017   }
1018 
1019   function _safeMint(address to, uint256 quantity) internal {
1020     _safeMint(to, quantity, "");
1021   }
1022 
1023   /**
1024    * @dev Mints `quantity` tokens and transfers them to `to`.
1025    *
1026    * Requirements:
1027    *
1028    * - there must be `quantity` tokens remaining unminted in the total collection.
1029    * - `to` cannot be the zero address.
1030    * - `quantity` cannot be larger than the max batch size.
1031    *
1032    * Emits a {Transfer} event.
1033    */
1034   function _safeMint(
1035     address to,
1036     uint256 quantity,
1037     bytes memory _data
1038   ) internal {
1039     uint256 startTokenId = currentIndex;
1040     require(to != address(0), "ERC721A: mint to the zero address");
1041     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1042     require(!_exists(startTokenId), "ERC721A: token already minted");
1043     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1044 
1045     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1046 
1047     AddressData memory addressData = _addressData[to];
1048     _addressData[to] = AddressData(
1049       addressData.balance + uint128(quantity),
1050       addressData.numberMinted + uint128(quantity)
1051     );
1052     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1053 
1054     uint256 updatedIndex = startTokenId;
1055 
1056     for (uint256 i = 0; i < quantity; i++) {
1057       emit Transfer(address(0), to, updatedIndex);
1058       require(
1059         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1060         "ERC721A: transfer to non ERC721Receiver implementer"
1061       );
1062       updatedIndex++;
1063     }
1064 
1065     currentIndex = updatedIndex;
1066     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1067   }
1068 
1069   /**
1070    * @dev Transfers `tokenId` from `from` to `to`.
1071    *
1072    * Requirements:
1073    *
1074    * - `to` cannot be the zero address.
1075    * - `tokenId` token must be owned by `from`.
1076    *
1077    * Emits a {Transfer} event.
1078    */
1079   function _transfer(
1080     address from,
1081     address to,
1082     uint256 tokenId
1083   ) private {
1084     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1085 
1086     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1087       getApproved(tokenId) == _msgSender() ||
1088       isApprovedForAll(prevOwnership.addr, _msgSender()));
1089 
1090     require(
1091       isApprovedOrOwner,
1092       "ERC721A: transfer caller is not owner nor approved"
1093     );
1094 
1095     require(
1096       prevOwnership.addr == from,
1097       "ERC721A: transfer from incorrect owner"
1098     );
1099     require(to != address(0), "ERC721A: transfer to the zero address");
1100 
1101     _beforeTokenTransfers(from, to, tokenId, 1);
1102 
1103     // Clear approvals from the previous owner
1104     _approve(address(0), tokenId, prevOwnership.addr);
1105 
1106     _addressData[from].balance -= 1;
1107     _addressData[to].balance += 1;
1108     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1109 
1110     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1111     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1112     uint256 nextTokenId = tokenId + 1;
1113     if (_ownerships[nextTokenId].addr == address(0)) {
1114       if (_exists(nextTokenId)) {
1115         _ownerships[nextTokenId] = TokenOwnership(
1116           prevOwnership.addr,
1117           prevOwnership.startTimestamp
1118         );
1119       }
1120     }
1121 
1122     emit Transfer(from, to, tokenId);
1123     _afterTokenTransfers(from, to, tokenId, 1);
1124   }
1125 
1126   /**
1127    * @dev Approve `to` to operate on `tokenId`
1128    *
1129    * Emits a {Approval} event.
1130    */
1131   function _approve(
1132     address to,
1133     uint256 tokenId,
1134     address owner
1135   ) private {
1136     _tokenApprovals[tokenId] = to;
1137     emit Approval(owner, to, tokenId);
1138   }
1139 
1140   uint256 public nextOwnerToExplicitlySet = 0;
1141 
1142   /**
1143    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1144    */
1145   function _setOwnersExplicit(uint256 quantity) internal {
1146     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1147     require(quantity > 0, "quantity must be nonzero");
1148     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1149     if (endIndex > collectionSize - 1) {
1150       endIndex = collectionSize - 1;
1151     }
1152     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1153     require(_exists(endIndex), "not enough minted yet for this cleanup");
1154     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1155       if (_ownerships[i].addr == address(0)) {
1156         TokenOwnership memory ownership = ownershipOf(i);
1157         _ownerships[i] = TokenOwnership(
1158           ownership.addr,
1159           ownership.startTimestamp
1160         );
1161       }
1162     }
1163     nextOwnerToExplicitlySet = endIndex + 1;
1164   }
1165 
1166   /**
1167    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1168    * The call is not executed if the target address is not a contract.
1169    *
1170    * @param from address representing the previous owner of the given token ID
1171    * @param to target address that will receive the tokens
1172    * @param tokenId uint256 ID of the token to be transferred
1173    * @param _data bytes optional data to send along with the call
1174    * @return bool whether the call correctly returned the expected magic value
1175    */
1176   function _checkOnERC721Received(
1177     address from,
1178     address to,
1179     uint256 tokenId,
1180     bytes memory _data
1181   ) private returns (bool) {
1182     if (to.isContract()) {
1183       try
1184         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1185       returns (bytes4 retval) {
1186         return retval == IERC721Receiver(to).onERC721Received.selector;
1187       } catch (bytes memory reason) {
1188         if (reason.length == 0) {
1189           revert("ERC721A: transfer to non ERC721Receiver implementer");
1190         } else {
1191           assembly {
1192             revert(add(32, reason), mload(reason))
1193           }
1194         }
1195       }
1196     } else {
1197       return true;
1198     }
1199   }
1200 
1201   /**
1202    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1203    *
1204    * startTokenId - the first token id to be transferred
1205    * quantity - the amount to be transferred
1206    *
1207    * Calling conditions:
1208    *
1209    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1210    * transferred to `to`.
1211    * - When `from` is zero, `tokenId` will be minted for `to`.
1212    */
1213   function _beforeTokenTransfers(
1214     address from,
1215     address to,
1216     uint256 startTokenId,
1217     uint256 quantity
1218   ) internal virtual {}
1219 
1220   /**
1221    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1222    * minting.
1223    *
1224    * startTokenId - the first token id to be transferred
1225    * quantity - the amount to be transferred
1226    *
1227    * Calling conditions:
1228    *
1229    * - when `from` and `to` are both non-zero.
1230    * - `from` and `to` are never both zero.
1231    */
1232   function _afterTokenTransfers(
1233     address from,
1234     address to,
1235     uint256 startTokenId,
1236     uint256 quantity
1237   ) internal virtual {}
1238 }
1239 
1240 
1241 pragma solidity ^0.8.7;
1242 
1243 contract GuildAlphaPass is ERC721A, Ownable {
1244 
1245     uint256 public maxSupply = 500;
1246 
1247     string public _baseTokenURI = "ipfs://QmYEgySW9wje8xW8joDTa8CCu6whA8yU3mzqKoVnEYKSQG/METADATA.json";
1248 
1249     constructor() ERC721A("Guild Alpha Pass", "GUILD", 20, 500) {}
1250 
1251     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1252         require(_exists(tokenId), "Token does not exist!");
1253         return _baseTokenURI;
1254     }
1255 
1256     function airdrop(address[] memory addresses, uint256[] memory counts) external onlyOwner {
1257         require(addresses.length == counts.length, "Arrays must be the same size.");
1258         
1259         for (uint256 i = 0; i < addresses.length; i++) {
1260             require(counts[i] > 0 && totalSupply() + counts[i] <= maxSupply, "Count must be greater than 0 and lower than maximum allowed supply.");
1261         
1262             _safeMint(addresses[i], counts[i]);
1263         } 
1264     }
1265 
1266 }