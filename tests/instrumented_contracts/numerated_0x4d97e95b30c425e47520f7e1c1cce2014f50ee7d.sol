1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         assembly {
33             size := extcodesize(account)
34         }
35         return size > 0;
36     }
37 
38     /**
39      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40      * `recipient`, forwarding all available gas and reverting on errors.
41      *
42      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43      * of certain opcodes, possibly making contracts go over the 2300 gas limit
44      * imposed by `transfer`, making them unable to receive funds via
45      * `transfer`. {sendValue} removes this limitation.
46      *
47      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48      *
49      * IMPORTANT: because control is transferred to `recipient`, care must be
50      * taken to not create reentrancy vulnerabilities. Consider using
51      * {ReentrancyGuard} or the
52      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53      */
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(address(this).balance >= amount, "Address: insufficient balance");
56 
57         (bool success, ) = recipient.call{value: amount}("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain `call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80         return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(
90         address target,
91         bytes memory data,
92         string memory errorMessage
93     ) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(
109         address target,
110         bytes memory data,
111         uint256 value
112     ) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
118      * with `errorMessage` as a fallback revert reason when `target` reverts.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value,
126         string memory errorMessage
127     ) internal returns (bytes memory) {
128         require(address(this).balance >= value, "Address: insufficient balance for call");
129         require(isContract(target), "Address: call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.call{value: value}(data);
132         return _verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
142         return functionStaticCall(target, data, "Address: low-level static call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal view returns (bytes memory) {
156         require(isContract(target), "Address: static call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return _verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but performing a delegate call.
165      *
166      * _Available since v3.4._
167      */
168     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(isContract(target), "Address: delegate call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.delegatecall(data);
186         return _verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     function _verifyCallResult(
190         bool success,
191         bytes memory returndata,
192         string memory errorMessage
193     ) private pure returns (bytes memory) {
194         if (success) {
195             return returndata;
196         } else {
197             // Look for revert reason and bubble it up if present
198             if (returndata.length > 0) {
199                 // The easiest way to bubble the revert reason is using memory via assembly
200 
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 
212 /**
213  * @dev Interface of the ERC165 standard, as defined in the
214  * https://eips.ethereum.org/EIPS/eip-165[EIP].
215  *
216  * Implementers can declare support of contract interfaces, which can then be
217  * queried by others ({ERC165Checker}).
218  *
219  * For an implementation, see {ERC165}.
220  */
221 interface IERC165 {
222     /**
223      * @dev Returns true if this contract implements the interface defined by
224      * `interfaceId`. See the corresponding
225      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
226      * to learn more about how these ids are created.
227      *
228      * This function call must use less than 30 000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
231 }
232 
233 /**
234  * @dev Implementation of the {IERC165} interface.
235  *
236  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
237  * for the additional interface id that will be supported. For example:
238  *
239  * ```solidity
240  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
241  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
242  * }
243  * ```
244  *
245  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
246  */
247 abstract contract ERC165 is IERC165 {
248     /**
249      * @dev See {IERC165-supportsInterface}.
250      */
251     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
252         return interfaceId == type(IERC165).interfaceId;
253     }
254 }
255 
256 /*
257  * @dev Provides information about the current execution context, including the
258  * sender of the transaction and its data. While these are generally available
259  * via msg.sender and msg.data, they should not be accessed in such a direct
260  * manner, since when dealing with meta-transactions the account sending and
261  * paying for execution may not be the actual sender (as far as an application
262  * is concerned).
263  *
264  * This contract is only required for intermediate, library-like contracts.
265  */
266 abstract contract Context {
267     function _msgSender() internal view virtual returns (address) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view virtual returns (bytes calldata) {
272         return msg.data;
273     }
274 }
275 
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * By default, the owner account will be the one that deploys the contract. This
282  * can later be changed with {transferOwnership}.
283  *
284  * This module is used through inheritance. It will make available the modifier
285  * `onlyOwner`, which can be applied to your functions to restrict their use to
286  * the owner.
287  */
288 abstract contract Ownable is Context {
289     address private _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev Initializes the contract setting the deployer as the initial owner.
295      */
296     constructor() {
297         _setOwner(_msgSender());
298     }
299 
300     /**
301      * @dev Returns the address of the current owner.
302      */
303     function owner() public view virtual returns (address) {
304         return _owner;
305     }
306 
307     /**
308      * @dev Throws if called by any account other than the owner.
309      */
310     modifier onlyOwner() {
311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     /**
316      * @dev Leaves the contract without owner. It will not be possible to call
317      * `onlyOwner` functions anymore. Can only be called by the current owner.
318      *
319      * NOTE: Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public virtual onlyOwner {
323         _setOwner(address(0));
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         _setOwner(newOwner);
333     }
334 
335     function _setOwner(address newOwner) private {
336         address oldOwner = _owner;
337         _owner = newOwner;
338         emit OwnershipTransferred(oldOwner, newOwner);
339     }
340 }
341 
342 /**
343  * @dev Contract module that helps prevent reentrant calls to a function.
344  *
345  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
346  * available, which can be applied to functions to make sure there are no nested
347  * (reentrant) calls to them.
348  *
349  * Note that because there is a single `nonReentrant` guard, functions marked as
350  * `nonReentrant` may not call one another. This can be worked around by making
351  * those functions `private`, and then adding `external` `nonReentrant` entry
352  * points to them.
353  *
354  * TIP: If you would like to learn more about reentrancy and alternative ways
355  * to protect against it, check out our blog post
356  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
357  */
358 abstract contract ReentrancyGuard {
359     // Booleans are more expensive than uint256 or any type that takes up a full
360     // word because each write operation emits an extra SLOAD to first read the
361     // slot's contents, replace the bits taken up by the boolean, and then write
362     // back. This is the compiler's defense against contract upgrades and
363     // pointer aliasing, and it cannot be disabled.
364 
365     // The values being non-zero value makes deployment a bit more expensive,
366     // but in exchange the refund on every call to nonReentrant will be lower in
367     // amount. Since refunds are capped to a percentage of the total
368     // transaction's gas, it is best to keep them low in cases like this one, to
369     // increase the likelihood of the full refund coming into effect.
370     uint256 private constant _NOT_ENTERED = 1;
371     uint256 private constant _ENTERED = 2;
372 
373     uint256 private _status;
374 
375     constructor() {
376         _status = _NOT_ENTERED;
377     }
378 
379     /**
380      * @dev Prevents a contract from calling itself, directly or indirectly.
381      * Calling a `nonReentrant` function from another `nonReentrant`
382      * function is not supported. It is possible to prevent this from happening
383      * by making the `nonReentrant` function external, and make it call a
384      * `private` function that does the actual work.
385      */
386     modifier nonReentrant() {
387         // On the first call to nonReentrant, _notEntered will be true
388         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
389 
390         // Any calls to nonReentrant after this point will fail
391         _status = _ENTERED;
392 
393         _;
394 
395         // By storing the original value once again, a refund is triggered (see
396         // https://eips.ethereum.org/EIPS/eip-2200)
397         _status = _NOT_ENTERED;
398     }
399 }
400 
401 
402 /**
403  * @dev String operations.
404  */
405 library Strings {
406     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
407 
408     /**
409      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
410      */
411     function toString(uint256 value) internal pure returns (string memory) {
412         // Inspired by OraclizeAPI's implementation - MIT licence
413         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
414 
415         if (value == 0) {
416             return "0";
417         }
418         uint256 temp = value;
419         uint256 digits;
420         while (temp != 0) {
421             digits++;
422             temp /= 10;
423         }
424         bytes memory buffer = new bytes(digits);
425         while (value != 0) {
426             digits -= 1;
427             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
428             value /= 10;
429         }
430         return string(buffer);
431     }
432 
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
435      */
436     function toHexString(uint256 value) internal pure returns (string memory) {
437         if (value == 0) {
438             return "0x00";
439         }
440         uint256 temp = value;
441         uint256 length = 0;
442         while (temp != 0) {
443             length++;
444             temp >>= 8;
445         }
446         return toHexString(value, length);
447     }
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
451      */
452     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
453         bytes memory buffer = new bytes(2 * length + 2);
454         buffer[0] = "0";
455         buffer[1] = "x";
456         for (uint256 i = 2 * length + 1; i > 1; --i) {
457             buffer[i] = _HEX_SYMBOLS[value & 0xf];
458             value >>= 4;
459         }
460         require(value == 0, "Strings: hex length insufficient");
461         return string(buffer);
462     }
463 }
464 
465 
466 /**
467  * @dev Required interface of an ERC721 compliant contract.
468  */
469 interface IERC721 is IERC165 {
470     /**
471      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
472      */
473     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
474 
475     /**
476      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
477      */
478     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
479 
480     /**
481      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
482      */
483     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
484 
485     /**
486      * @dev Returns the number of tokens in ``owner``'s account.
487      */
488     function balanceOf(address owner) external view returns (uint256 balance);
489 
490     /**
491      * @dev Returns the owner of the `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function ownerOf(uint256 tokenId) external view returns (address owner);
498 
499     /**
500      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
501      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must exist and be owned by `from`.
508      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
510      *
511      * Emits a {Transfer} event.
512      */
513     function safeTransferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519     /**
520      * @dev Transfers `tokenId` token from `from` to `to`.
521      *
522      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must be owned by `from`.
529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
530      *
531      * Emits a {Transfer} event.
532      */
533     function transferFrom(
534         address from,
535         address to,
536         uint256 tokenId
537     ) external;
538 
539     /**
540      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
541      * The approval is cleared when the token is transferred.
542      *
543      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
544      *
545      * Requirements:
546      *
547      * - The caller must own the token or be an approved operator.
548      * - `tokenId` must exist.
549      *
550      * Emits an {Approval} event.
551      */
552     function approve(address to, uint256 tokenId) external;
553 
554     /**
555      * @dev Returns the account approved for `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function getApproved(uint256 tokenId) external view returns (address operator);
562 
563     /**
564      * @dev Approve or remove `operator` as an operator for the caller.
565      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
566      *
567      * Requirements:
568      *
569      * - The `operator` cannot be the caller.
570      *
571      * Emits an {ApprovalForAll} event.
572      */
573     function setApprovalForAll(address operator, bool _approved) external;
574 
575     /**
576      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
577      *
578      * See {setApprovalForAll}
579      */
580     function isApprovedForAll(address owner, address operator) external view returns (bool);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId,
599         bytes calldata data
600     ) external;
601 }
602 
603 
604 /**
605  * @title ERC721 token receiver interface
606  * @dev Interface for any contract that wants to support safeTransfers
607  * from ERC721 asset contracts.
608  */
609 interface IERC721Receiver {
610     /**
611      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
612      * by `operator` from `from`, this function is called.
613      *
614      * It must return its Solidity selector to confirm the token transfer.
615      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
616      *
617      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
618      */
619     function onERC721Received(
620         address operator,
621         address from,
622         uint256 tokenId,
623         bytes calldata data
624     ) external returns (bytes4);
625 }
626 
627 /**
628  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
629  * @dev See https://eips.ethereum.org/EIPS/eip-721
630  */
631 interface IERC721Metadata is IERC721 {
632     /**
633      * @dev Returns the token collection name.
634      */
635     function name() external view returns (string memory);
636 
637     /**
638      * @dev Returns the token collection symbol.
639      */
640     function symbol() external view returns (string memory);
641 
642     /**
643      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
644      */
645     function tokenURI(uint256 tokenId) external view returns (string memory);
646 }
647 
648 
649 /**
650  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
651  * @dev See https://eips.ethereum.org/EIPS/eip-721
652  */
653 interface IERC721Enumerable is IERC721 {
654     /**
655      * @dev Returns the total amount of tokens stored by the contract.
656      */
657     function totalSupply() external view returns (uint256);
658 
659     /**
660      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
661      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
662      */
663     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
664 
665     /**
666      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
667      * Use along with {totalSupply} to enumerate all tokens.
668      */
669     function tokenByIndex(uint256 index) external view returns (uint256);
670 }
671 
672 /**
673  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
674  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
675  *
676  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
677  *
678  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
679  *
680  * Does not support burning tokens to address(0).
681  */
682 contract ERC721A is
683   Context,
684   ERC165,
685   IERC721,
686   IERC721Metadata,
687   IERC721Enumerable
688 {
689   using Address for address;
690   using Strings for uint256;
691 
692   struct TokenOwnership {
693     address addr;
694     uint64 startTimestamp;
695   }
696 
697   struct AddressData {
698     uint128 balance;
699     uint128 numberMinted;
700   }
701 
702   uint256 private currentIndex = 0;
703 
704   uint256 internal collectionSize;
705   uint256 internal maxBatchSize;
706 
707   // Token name
708   string private _name;
709 
710   // Token symbol
711   string private _symbol;
712 
713   // Mapping from token ID to ownership details
714   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
715   mapping(uint256 => TokenOwnership) private _ownerships;
716 
717   // Mapping owner address to address data
718   mapping(address => AddressData) private _addressData;
719 
720   // Mapping from token ID to approved address
721   mapping(uint256 => address) private _tokenApprovals;
722 
723   // Mapping from owner to operator approvals
724   mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726   /**
727    * @dev
728    * `maxBatchSize` refers to how much a minter can mint at a time.
729    * `collectionSize_` refers to how many tokens are in the collection.
730    */
731   constructor(
732     string memory name_,
733     string memory symbol_,
734     uint256 maxBatchSize_,
735     uint256 collectionSize_
736   ) {
737     require(
738       collectionSize_ > 0,
739       "ERC721A: collection must have a nonzero supply"
740     );
741     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
742     _name = name_;
743     _symbol = symbol_;
744     maxBatchSize = maxBatchSize_;
745     collectionSize = collectionSize_;
746   }
747 
748   /**
749    * @dev See {IERC721Enumerable-totalSupply}.
750    */
751   function totalSupply() public view override returns (uint256) {
752     return currentIndex;
753   }
754 
755   /**
756    * @dev See {IERC721Enumerable-tokenByIndex}.
757    */
758   function tokenByIndex(uint256 index) public view override returns (uint256) {
759     require(index < totalSupply(), "ERC721A: global index out of bounds");
760     return index;
761   }
762 
763   /**
764    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
765    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
766    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
767    */
768   function tokenOfOwnerByIndex(address owner, uint256 index)
769     public
770     view
771     override
772     returns (uint256)
773   {
774     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
775     uint256 numMintedSoFar = totalSupply();
776     uint256 tokenIdsIdx = 0;
777     address currOwnershipAddr = address(0);
778     for (uint256 i = 0; i < numMintedSoFar; i++) {
779       TokenOwnership memory ownership = _ownerships[i];
780       if (ownership.addr != address(0)) {
781         currOwnershipAddr = ownership.addr;
782       }
783       if (currOwnershipAddr == owner) {
784         if (tokenIdsIdx == index) {
785           return i;
786         }
787         tokenIdsIdx++;
788       }
789     }
790     revert("ERC721A: unable to get token of owner by index");
791   }
792 
793   /**
794    * @dev See {IERC165-supportsInterface}.
795    */
796   function supportsInterface(bytes4 interfaceId)
797     public
798     view
799     virtual
800     override(ERC165, IERC165)
801     returns (bool)
802   {
803     return
804       interfaceId == type(IERC721).interfaceId ||
805       interfaceId == type(IERC721Metadata).interfaceId ||
806       interfaceId == type(IERC721Enumerable).interfaceId ||
807       super.supportsInterface(interfaceId);
808   }
809 
810   /**
811    * @dev See {IERC721-balanceOf}.
812    */
813   function balanceOf(address owner) public view override returns (uint256) {
814     require(owner != address(0), "ERC721A: balance query for the zero address");
815     return uint256(_addressData[owner].balance);
816   }
817 
818   function _numberMinted(address owner) internal view returns (uint256) {
819     require(
820       owner != address(0),
821       "ERC721A: number minted query for the zero address"
822     );
823     return uint256(_addressData[owner].numberMinted);
824   }
825 
826   function ownershipOf(uint256 tokenId)
827     internal
828     view
829     returns (TokenOwnership memory)
830   {
831     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
832 
833     uint256 lowestTokenToCheck;
834     if (tokenId >= maxBatchSize) {
835       lowestTokenToCheck = tokenId - maxBatchSize + 1;
836     }
837 
838     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
839       TokenOwnership memory ownership = _ownerships[curr];
840       if (ownership.addr != address(0)) {
841         return ownership;
842       }
843     }
844 
845     revert("ERC721A: unable to determine the owner of token");
846   }
847 
848   /**
849    * @dev See {IERC721-ownerOf}.
850    */
851   function ownerOf(uint256 tokenId) public view override returns (address) {
852     return ownershipOf(tokenId).addr;
853   }
854 
855   /**
856    * @dev See {IERC721Metadata-name}.
857    */
858   function name() public view virtual override returns (string memory) {
859     return _name;
860   }
861 
862   /**
863    * @dev See {IERC721Metadata-symbol}.
864    */
865   function symbol() public view virtual override returns (string memory) {
866     return _symbol;
867   }
868 
869   /**
870    * @dev See {IERC721Metadata-tokenURI}.
871    */
872   function tokenURI(uint256 tokenId)
873     public
874     view
875     virtual
876     override
877     returns (string memory)
878   {
879     require(
880       _exists(tokenId),
881       "ERC721Metadata: URI query for nonexistent token"
882     );
883 
884     string memory baseURI = _baseURI();
885     return
886       bytes(baseURI).length > 0
887         ? string(abi.encodePacked(baseURI, tokenId.toString()))
888         : "";
889   }
890 
891   /**
892    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894    * by default, can be overriden in child contracts.
895    */
896   function _baseURI() internal view virtual returns (string memory) {
897     return "";
898   }
899 
900   /**
901    * @dev See {IERC721-approve}.
902    */
903   function approve(address to, uint256 tokenId) public override {
904     address owner = ERC721A.ownerOf(tokenId);
905     require(to != owner, "ERC721A: approval to current owner");
906 
907     require(
908       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
909       "ERC721A: approve caller is not owner nor approved for all"
910     );
911 
912     _approve(to, tokenId, owner);
913   }
914 
915   /**
916    * @dev See {IERC721-getApproved}.
917    */
918   function getApproved(uint256 tokenId) public view override returns (address) {
919     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
920 
921     return _tokenApprovals[tokenId];
922   }
923 
924   /**
925    * @dev See {IERC721-setApprovalForAll}.
926    */
927   function setApprovalForAll(address operator, bool approved) public override {
928     require(operator != _msgSender(), "ERC721A: approve to caller");
929 
930     _operatorApprovals[_msgSender()][operator] = approved;
931     emit ApprovalForAll(_msgSender(), operator, approved);
932   }
933 
934   /**
935    * @dev See {IERC721-isApprovedForAll}.
936    */
937   function isApprovedForAll(address owner, address operator)
938     public
939     view
940     virtual
941     override
942     returns (bool)
943   {
944     return _operatorApprovals[owner][operator];
945   }
946 
947   /**
948    * @dev See {IERC721-transferFrom}.
949    */
950   function transferFrom(
951     address from,
952     address to,
953     uint256 tokenId
954   ) public override {
955     _transfer(from, to, tokenId);
956   }
957 
958   /**
959    * @dev See {IERC721-safeTransferFrom}.
960    */
961   function safeTransferFrom(
962     address from,
963     address to,
964     uint256 tokenId
965   ) public override {
966     safeTransferFrom(from, to, tokenId, "");
967   }
968 
969   /**
970    * @dev See {IERC721-safeTransferFrom}.
971    */
972   function safeTransferFrom(
973     address from,
974     address to,
975     uint256 tokenId,
976     bytes memory _data
977   ) public override {
978     _transfer(from, to, tokenId);
979     require(
980       _checkOnERC721Received(from, to, tokenId, _data),
981       "ERC721A: transfer to non ERC721Receiver implementer"
982     );
983   }
984 
985   /**
986    * @dev Returns whether `tokenId` exists.
987    *
988    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
989    *
990    * Tokens start existing when they are minted (`_mint`),
991    */
992   function _exists(uint256 tokenId) internal view returns (bool) {
993     return tokenId < currentIndex;
994   }
995 
996   function _safeMint(address to, uint256 quantity) internal {
997     _safeMint(to, quantity, "");
998   }
999 
1000   /**
1001    * @dev Mints `quantity` tokens and transfers them to `to`.
1002    *
1003    * Requirements:
1004    *
1005    * - there must be `quantity` tokens remaining unminted in the total collection.
1006    * - `to` cannot be the zero address.
1007    * - `quantity` cannot be larger than the max batch size.
1008    *
1009    * Emits a {Transfer} event.
1010    */
1011   function _safeMint(
1012     address to,
1013     uint256 quantity,
1014     bytes memory _data
1015   ) internal {
1016     uint256 startTokenId = currentIndex;
1017     require(to != address(0), "ERC721A: mint to the zero address");
1018     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1019     require(!_exists(startTokenId), "ERC721A: token already minted");
1020     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1021 
1022     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1023 
1024     AddressData memory addressData = _addressData[to];
1025     _addressData[to] = AddressData(
1026       addressData.balance + uint128(quantity),
1027       addressData.numberMinted + uint128(quantity)
1028     );
1029     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1030 
1031     uint256 updatedIndex = startTokenId;
1032 
1033     for (uint256 i = 0; i < quantity; i++) {
1034       emit Transfer(address(0), to, updatedIndex);
1035       require(
1036         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1037         "ERC721A: transfer to non ERC721Receiver implementer"
1038       );
1039       updatedIndex++;
1040     }
1041 
1042     currentIndex = updatedIndex;
1043     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1044   }
1045 
1046   /**
1047    * @dev Transfers `tokenId` from `from` to `to`.
1048    *
1049    * Requirements:
1050    *
1051    * - `to` cannot be the zero address.
1052    * - `tokenId` token must be owned by `from`.
1053    *
1054    * Emits a {Transfer} event.
1055    */
1056   function _transfer(
1057     address from,
1058     address to,
1059     uint256 tokenId
1060   ) private {
1061     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1062 
1063     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1064       getApproved(tokenId) == _msgSender() ||
1065       isApprovedForAll(prevOwnership.addr, _msgSender()));
1066 
1067     require(
1068       isApprovedOrOwner,
1069       "ERC721A: transfer caller is not owner nor approved"
1070     );
1071 
1072     require(
1073       prevOwnership.addr == from,
1074       "ERC721A: transfer from incorrect owner"
1075     );
1076     require(to != address(0), "ERC721A: transfer to the zero address");
1077 
1078     _beforeTokenTransfers(from, to, tokenId, 1);
1079 
1080     // Clear approvals from the previous owner
1081     _approve(address(0), tokenId, prevOwnership.addr);
1082 
1083     _addressData[from].balance -= 1;
1084     _addressData[to].balance += 1;
1085     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1086 
1087     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1088     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1089     uint256 nextTokenId = tokenId + 1;
1090     if (_ownerships[nextTokenId].addr == address(0)) {
1091       if (_exists(nextTokenId)) {
1092         _ownerships[nextTokenId] = TokenOwnership(
1093           prevOwnership.addr,
1094           prevOwnership.startTimestamp
1095         );
1096       }
1097     }
1098 
1099     emit Transfer(from, to, tokenId);
1100     _afterTokenTransfers(from, to, tokenId, 1);
1101   }
1102 
1103   /**
1104    * @dev Approve `to` to operate on `tokenId`
1105    *
1106    * Emits a {Approval} event.
1107    */
1108   function _approve(
1109     address to,
1110     uint256 tokenId,
1111     address owner
1112   ) private {
1113     _tokenApprovals[tokenId] = to;
1114     emit Approval(owner, to, tokenId);
1115   }
1116 
1117   uint256 public nextOwnerToExplicitlySet = 0;
1118 
1119   /**
1120    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1121    */
1122   function _setOwnersExplicit(uint256 quantity) internal {
1123     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1124     require(quantity > 0, "quantity must be nonzero");
1125     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1126     if (endIndex > collectionSize - 1) {
1127       endIndex = collectionSize - 1;
1128     }
1129     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1130     require(_exists(endIndex), "not enough minted yet for this cleanup");
1131     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1132       if (_ownerships[i].addr == address(0)) {
1133         TokenOwnership memory ownership = ownershipOf(i);
1134         _ownerships[i] = TokenOwnership(
1135           ownership.addr,
1136           ownership.startTimestamp
1137         );
1138       }
1139     }
1140     nextOwnerToExplicitlySet = endIndex + 1;
1141   }
1142 
1143   /**
1144    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1145    * The call is not executed if the target address is not a contract.
1146    *
1147    * @param from address representing the previous owner of the given token ID
1148    * @param to target address that will receive the tokens
1149    * @param tokenId uint256 ID of the token to be transferred
1150    * @param _data bytes optional data to send along with the call
1151    * @return bool whether the call correctly returned the expected magic value
1152    */
1153   function _checkOnERC721Received(
1154     address from,
1155     address to,
1156     uint256 tokenId,
1157     bytes memory _data
1158   ) private returns (bool) {
1159     if (to.isContract()) {
1160       try
1161         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1162       returns (bytes4 retval) {
1163         return retval == IERC721Receiver(to).onERC721Received.selector;
1164       } catch (bytes memory reason) {
1165         if (reason.length == 0) {
1166           revert("ERC721A: transfer to non ERC721Receiver implementer");
1167         } else {
1168           assembly {
1169             revert(add(32, reason), mload(reason))
1170           }
1171         }
1172       }
1173     } else {
1174       return true;
1175     }
1176   }
1177 
1178   /**
1179    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1180    *
1181    * startTokenId - the first token id to be transferred
1182    * quantity - the amount to be transferred
1183    *
1184    * Calling conditions:
1185    *
1186    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1187    * transferred to `to`.
1188    * - When `from` is zero, `tokenId` will be minted for `to`.
1189    */
1190   function _beforeTokenTransfers(
1191     address from,
1192     address to,
1193     uint256 startTokenId,
1194     uint256 quantity
1195   ) internal virtual {}
1196 
1197   /**
1198    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1199    * minting.
1200    *
1201    * startTokenId - the first token id to be transferred
1202    * quantity - the amount to be transferred
1203    *
1204    * Calling conditions:
1205    *
1206    * - when `from` and `to` are both non-zero.
1207    * - `from` and `to` are never both zero.
1208    */
1209   function _afterTokenTransfers(
1210     address from,
1211     address to,
1212     uint256 startTokenId,
1213     uint256 quantity
1214   ) internal virtual {}
1215 }
1216 
1217 interface IERC20 {
1218 
1219     function totalSupply() external view returns (uint256);
1220 
1221     /**
1222      * @dev Returns the amount of tokens owned by `account`.
1223      */
1224     function balanceOf(address account) external view returns (uint256);
1225 
1226     /**
1227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1228      *
1229      * Returns a boolean value indicating whether the operation succeeded.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function transfer(address recipient, uint256 amount) external returns (bool);
1234 
1235     /**
1236      * @dev Returns the remaining number of tokens that `spender` will be
1237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1238      * zero by default.
1239      *
1240      * This value changes when {approve} or {transferFrom} are called.
1241      */
1242     function allowance(address owner, address spender) external view returns (uint256);
1243 
1244     /**
1245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1246      *
1247      * Returns a boolean value indicating whether the operation succeeded.
1248      *
1249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1250      * that someone may use both the old and the new allowance by unfortunate
1251      * transaction ordering. One possible solution to mitigate this race
1252      * condition is to first reduce the spender's allowance to 0 and set the
1253      * desired value afterwards:
1254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1255      *
1256      * Emits an {Approval} event.
1257      */
1258     function approve(address spender, uint256 amount) external returns (bool);
1259 
1260     /**
1261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1262      * allowance mechanism. `amount` is then deducted from the caller's
1263      * allowance.
1264      *
1265      * Returns a boolean value indicating whether the operation succeeded.
1266      *
1267      * Emits a {Transfer} event.
1268      */
1269     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1270 
1271     /**
1272      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1273      * another (`to`).
1274      *
1275      * Note that `value` may be zero.
1276      */
1277     event Transfer(address indexed from, address indexed to, uint256 value);
1278 
1279     /**
1280      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1281      * a call to {approve}. `value` is the new allowance.
1282      */
1283     event Approval(address indexed owner, address indexed spender, uint256 value);
1284 }
1285 
1286 contract Apelanders is ERC721A, Ownable, ReentrancyGuard{
1287     using Strings for uint256;
1288     uint256 public mintPrice = .02 ether;
1289     uint256 public mintPriceApe = 0.15 ether;
1290     uint256 public maxTokens = 6969;
1291     uint256 public maxPerMint = 100;
1292     uint256 public minted;
1293     uint256 public reserved;
1294     uint256 public reserveMinted;
1295     
1296     bool public mintEnabled;
1297     bool public claimEnabled;
1298     bool public revealed;
1299     string private unrevealed = 'https://ipfs.io/ipfs/bafybeihs3mjd3eyniy2v42alhuvh7f5aw3ngq3cgg5jhk7nzx5rhgxqtd4/images/Placeholder.gif';
1300     string private baseURI;
1301     struct mintData{
1302         uint256 amount;
1303         }
1304     IERC20 public APE = IERC20(0x40E0a6eF9DbADfc83C5e0d15262FEB4638588D77);
1305     struct claimData{
1306         uint256 amount;
1307         bool sent;
1308         }
1309 
1310     mapping(address => claimData) public claimers;
1311 
1312 
1313 
1314     constructor() ERC721A("APE LANDERS", "APE LANDERS", maxPerMint, maxTokens){
1315       
1316     }
1317 
1318     modifier humanOnly() {
1319       require(tx.origin == msg.sender, "The caller is another contract");
1320       _;
1321     }
1322 
1323     function _baseURI() internal view virtual override returns (string memory) {
1324         return baseURI;
1325     }
1326 
1327     function revealNFT(string memory _baseURI) external onlyOwner{
1328       baseURI = _baseURI;
1329       revealed = true;
1330     }
1331 
1332     function mintRemainingToDao(address _dao, uint256 amount) external onlyOwner{
1333       uint256 remaining = reserved - reserveMinted;
1334       require(amount <= remaining);
1335       uint256 numtimes = amount/maxPerMint;
1336       uint256 extra = amount%maxPerMint;
1337       for(uint256 i = 0; i < numtimes;i++){
1338         minted += maxPerMint;
1339         _safeMint(_dao,maxPerMint);
1340       }
1341       if(extra >0){
1342         minted +=extra;
1343          _safeMint(_dao,extra);
1344       }
1345   }
1346 
1347     function mint(uint256 amount) external payable humanOnly{
1348 	    require(mintEnabled);
1349 	    require(minted + amount  <= (maxTokens - reserved));
1350 	    require(amount <= maxPerMint);
1351 	    require(msg.value >= mintPrice * amount);
1352 	    minted += amount;
1353 	    _safeMint(msg.sender,amount);
1354     }
1355 
1356     function mintWithApe(uint256 amount) external humanOnly{
1357 	    require(mintEnabled);
1358 	    require(minted + amount  <= (maxTokens - reserved));
1359 	    require(amount <= maxPerMint);
1360 	    require(APE.balanceOf(msg.sender) >= mintPriceApe * amount);
1361       APE.transferFrom(msg.sender,address(this),mintPriceApe * amount);
1362 	    minted += amount;
1363 	    _safeMint(msg.sender,amount);
1364     }
1365 
1366     function claimApelander() external {
1367 	    require((reserveMinted + claimers[msg.sender].amount <= reserved) &&  (minted + claimers[msg.sender].amount <=maxTokens));
1368 	    require(!claimers[msg.sender].sent);
1369       require(claimEnabled);
1370 	    claimers[msg.sender].sent = true;
1371 	    minted += claimers[msg.sender].amount;
1372       reserveMinted +=claimers[msg.sender].amount;
1373 	    _safeMint(msg.sender,claimers[msg.sender].amount);
1374 
1375     }
1376 
1377     function addClaimers(address[] calldata _claim, uint256[] calldata _amount) external onlyOwner {
1378         for (uint256 i = 0; i < _claim.length; i++) {
1379             claimers[_claim[i]].amount = _amount[i];
1380             reserved += _amount[i];
1381         }
1382     }
1383 
1384     function unclaimed() external view returns(uint256){
1385       return reserved - reserveMinted;
1386     }
1387 
1388     function withdraw() external onlyOwner {
1389         payable(owner()).transfer(address(this).balance);
1390         APE.transfer(owner(), APE.balanceOf(address(this)));
1391     }
1392 
1393     function setmintStatus(bool _claimEnabled, bool _mintEnabled) external onlyOwner {
1394         claimEnabled = _claimEnabled;
1395 	      mintEnabled = _mintEnabled;
1396     }
1397 
1398     function setMintPrice(uint256 _mintPrice, uint256 _mintPriceApe) external onlyOwner{
1399         mintPrice = _mintPrice;
1400         mintPriceApe = _mintPriceApe;
1401     }
1402 
1403     function setUpdateCollectionSize(uint256 _maxTokens) external onlyOwner{
1404         maxTokens = _maxTokens;
1405         collectionSize = _maxTokens;
1406     }
1407     function numberMinted(address owner) public view returns (uint256) {
1408         return _numberMinted(owner);
1409     }
1410 
1411     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1412         return ownershipOf(tokenId);
1413     }
1414 
1415    function tokenURI(uint256 tokenId) public view override returns (string memory) {
1416 	    require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1417       if(!revealed){
1418 	    string memory metadata = string(abi.encodePacked('{"name": "Ape Lander #',
1419 	    tokenId.toString(),
1420 	    '", "description": "6969 Ape Landers living on the Ethereum Block Chain", "image": "',
1421 	    unrevealed,'",',
1422 	    '"attributes": [{"trait_type":"unrevealed","value": "Apelander"}]}'));
1423 
1424         return string(abi.encodePacked("data:application/json;base64,",base64(bytes(metadata))));
1425       } else{
1426             string memory baseURI = _baseURI();
1427             return
1428       bytes(baseURI).length > 0
1429         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1430         : "";
1431       }
1432     }
1433 
1434   /** BASE 64 - Written by Brech Devos */
1435   
1436     string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1437 
1438     function base64(bytes memory data) internal pure returns (string memory) {
1439         if (data.length == 0) return '';
1440 
1441         // load the table into memory
1442         string memory table = TABLE;
1443 
1444         // multiply by 4/3 rounded up
1445         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1446 
1447         // add some extra buffer at the end required for the writing
1448         string memory result = new string(encodedLen + 32);
1449 
1450         assembly {
1451             // set the actual output length
1452             mstore(result, encodedLen)
1453             
1454             // prepare the lookup table
1455             let tablePtr := add(table, 1)
1456             
1457             // input ptr
1458             let dataPtr := data
1459             let endPtr := add(dataPtr, mload(data))
1460             
1461             // result ptr, jump over length
1462             let resultPtr := add(result, 32)
1463             
1464             // run over the input, 3 bytes at a time
1465             for {} lt(dataPtr, endPtr) {}
1466             {
1467                 dataPtr := add(dataPtr, 3)
1468                 
1469                 // read 3 bytes
1470                 let input := mload(dataPtr)
1471                 
1472                 // write 4 characters
1473                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
1474                 resultPtr := add(resultPtr, 1)
1475                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
1476                 resultPtr := add(resultPtr, 1)
1477                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
1478                 resultPtr := add(resultPtr, 1)
1479                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
1480                 resultPtr := add(resultPtr, 1)
1481             }
1482             
1483             // padding with '='
1484             switch mod(mload(data), 3)
1485             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
1486             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
1487         }
1488 
1489         return result;
1490     }
1491 }