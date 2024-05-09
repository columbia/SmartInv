1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _setOwner(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _setOwner(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _setOwner(newOwner);
82     }
83 
84     function _setOwner(address newOwner) private {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 }
153 
154 /**
155  * @dev Collection of functions related to the address type
156  */
157 library Address {
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize, which returns 0 for contracts in
177         // construction, since the code is only stored at the end of the
178         // constructor execution.
179 
180         uint256 size;
181         assembly {
182             size := extcodesize(account)
183         }
184         return size > 0;
185     }
186 
187     /**
188      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
189      * `recipient`, forwarding all available gas and reverting on errors.
190      *
191      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
192      * of certain opcodes, possibly making contracts go over the 2300 gas limit
193      * imposed by `transfer`, making them unable to receive funds via
194      * `transfer`. {sendValue} removes this limitation.
195      *
196      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
197      *
198      * IMPORTANT: because control is transferred to `recipient`, care must be
199      * taken to not create reentrancy vulnerabilities. Consider using
200      * {ReentrancyGuard} or the
201      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
202      */
203     function sendValue(address payable recipient, uint256 amount) internal {
204         require(address(this).balance >= amount, "Address: insufficient balance");
205 
206         (bool success, ) = recipient.call{value: amount}("");
207         require(success, "Address: unable to send value, recipient may have reverted");
208     }
209 
210     /**
211      * @dev Performs a Solidity function call using a low level `call`. A
212      * plain `call` is an unsafe replacement for a function call: use this
213      * function instead.
214      *
215      * If `target` reverts with a revert reason, it is bubbled up by this
216      * function (like regular Solidity function calls).
217      *
218      * Returns the raw returned data. To convert to the expected return value,
219      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
220      *
221      * Requirements:
222      *
223      * - `target` must be a contract.
224      * - calling `target` with `data` must not revert.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
229         return functionCall(target, data, "Address: low-level call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
234      * `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, 0, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but also transferring `value` wei to `target`.
249      *
250      * Requirements:
251      *
252      * - the calling contract must have an ETH balance of at least `value`.
253      * - the called Solidity function must be `payable`.
254      *
255      * _Available since v3.1._
256      */
257     function functionCallWithValue(
258         address target,
259         bytes memory data,
260         uint256 value
261     ) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(address(this).balance >= value, "Address: insufficient balance for call");
278         require(isContract(target), "Address: call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.call{value: value}(data);
281         return _verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
291         return functionStaticCall(target, data, "Address: low-level static call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal view returns (bytes memory) {
305         require(isContract(target), "Address: static call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.staticcall(data);
308         return _verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(isContract(target), "Address: delegate call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.delegatecall(data);
335         return _verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     function _verifyCallResult(
339         bool success,
340         bytes memory returndata,
341         string memory errorMessage
342     ) private pure returns (bytes memory) {
343         if (success) {
344             return returndata;
345         } else {
346             // Look for revert reason and bubble it up if present
347             if (returndata.length > 0) {
348                 // The easiest way to bubble the revert reason is using memory via assembly
349 
350                 assembly {
351                     let returndata_size := mload(returndata)
352                     revert(add(32, returndata), returndata_size)
353                 }
354             } else {
355                 revert(errorMessage);
356             }
357         }
358     }
359 }
360 
361 /**
362  * @dev Contract module that helps prevent reentrant calls to a function.
363  *
364  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
365  * available, which can be applied to functions to make sure there are no nested
366  * (reentrant) calls to them.
367  *
368  * Note that because there is a single `nonReentrant` guard, functions marked as
369  * `nonReentrant` may not call one another. This can be worked around by making
370  * those functions `private`, and then adding `external` `nonReentrant` entry
371  * points to them.
372  *
373  * TIP: If you would like to learn more about reentrancy and alternative ways
374  * to protect against it, check out our blog post
375  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
376  */
377 abstract contract ReentrancyGuard {
378     // Booleans are more expensive than uint256 or any type that takes up a full
379     // word because each write operation emits an extra SLOAD to first read the
380     // slot's contents, replace the bits taken up by the boolean, and then write
381     // back. This is the compiler's defense against contract upgrades and
382     // pointer aliasing, and it cannot be disabled.
383 
384     // The values being non-zero value makes deployment a bit more expensive,
385     // but in exchange the refund on every call to nonReentrant will be lower in
386     // amount. Since refunds are capped to a percentage of the total
387     // transaction's gas, it is best to keep them low in cases like this one, to
388     // increase the likelihood of the full refund coming into effect.
389     uint256 private constant _NOT_ENTERED = 1;
390     uint256 private constant _ENTERED = 2;
391 
392     uint256 private _status;
393 
394     constructor() {
395         _status = _NOT_ENTERED;
396     }
397 
398     /**
399      * @dev Prevents a contract from calling itself, directly or indirectly.
400      * Calling a `nonReentrant` function from another `nonReentrant`
401      * function is not supported. It is possible to prevent this from happening
402      * by making the `nonReentrant` function external, and make it call a
403      * `private` function that does the actual work.
404      */
405     modifier nonReentrant() {
406         // On the first call to nonReentrant, _notEntered will be true
407         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
408 
409         // Any calls to nonReentrant after this point will fail
410         _status = _ENTERED;
411 
412         _;
413 
414         // By storing the original value once again, a refund is triggered (see
415         // https://eips.ethereum.org/EIPS/eip-2200)
416         _status = _NOT_ENTERED;
417     }
418 }
419 
420 /**
421  * @dev Interface of the ERC165 standard, as defined in the
422  * https://eips.ethereum.org/EIPS/eip-165[EIP].
423  *
424  * Implementers can declare support of contract interfaces, which can then be
425  * queried by others ({ERC165Checker}).
426  *
427  * For an implementation, see {ERC165}.
428  */
429 interface IERC165 {
430     /**
431      * @dev Returns true if this contract implements the interface defined by
432      * `interfaceId`. See the corresponding
433      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
434      * to learn more about how these ids are created.
435      *
436      * This function call must use less than 30 000 gas.
437      */
438     function supportsInterface(bytes4 interfaceId) external view returns (bool);
439 }
440 
441 /**
442  * @dev Implementation of the {IERC165} interface.
443  *
444  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
445  * for the additional interface id that will be supported. For example:
446  *
447  * ```solidity
448  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
450  * }
451  * ```
452  *
453  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
454  */
455 abstract contract ERC165 is IERC165 {
456     /**
457      * @dev See {IERC165-supportsInterface}.
458      */
459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460         return interfaceId == type(IERC165).interfaceId;
461     }
462 }
463 
464 /**
465  * @dev Required interface of an ERC721 compliant contract.
466  */
467 interface IERC721 is IERC165 {
468     /**
469      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
470      */
471     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
475      */
476     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
480      */
481     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
482 
483     /**
484      * @dev Returns the number of tokens in ``owner``'s account.
485      */
486     function balanceOf(address owner) external view returns (uint256 balance);
487 
488     /**
489      * @dev Returns the owner of the `tokenId` token.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must exist.
494      */
495     function ownerOf(uint256 tokenId) external view returns (address owner);
496 
497     /**
498      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
499      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Transfers `tokenId` token from `from` to `to`.
519      *
520      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      *
529      * Emits a {Transfer} event.
530      */
531     function transferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     /**
538      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
539      * The approval is cleared when the token is transferred.
540      *
541      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
542      *
543      * Requirements:
544      *
545      * - The caller must own the token or be an approved operator.
546      * - `tokenId` must exist.
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address to, uint256 tokenId) external;
551 
552     /**
553      * @dev Returns the account approved for `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function getApproved(uint256 tokenId) external view returns (address operator);
560 
561     /**
562      * @dev Approve or remove `operator` as an operator for the caller.
563      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
564      *
565      * Requirements:
566      *
567      * - The `operator` cannot be the caller.
568      *
569      * Emits an {ApprovalForAll} event.
570      */
571     function setApprovalForAll(address operator, bool _approved) external;
572 
573     /**
574      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
575      *
576      * See {setApprovalForAll}
577      */
578     function isApprovedForAll(address owner, address operator) external view returns (bool);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must exist and be owned by `from`.
588      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
589      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
590      *
591      * Emits a {Transfer} event.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 tokenId,
597         bytes calldata data
598     ) external;
599 }
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 
622 /**
623  * @title ERC721 token receiver interface
624  * @dev Interface for any contract that wants to support safeTransfers
625  * from ERC721 asset contracts.
626  */
627 interface IERC721Receiver {
628     /**
629      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
630      * by `operator` from `from`, this function is called.
631      *
632      * It must return its Solidity selector to confirm the token transfer.
633      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
634      *
635      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
636      */
637     function onERC721Received(
638         address operator,
639         address from,
640         uint256 tokenId,
641         bytes calldata data
642     ) external returns (bytes4);
643 }
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Enumerable is IERC721 {
650     /**
651      * @dev Returns the total amount of tokens stored by the contract.
652      */
653     function totalSupply() external view returns (uint256);
654 
655     /**
656      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
657      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
658      */
659     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
660 
661     /**
662      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
663      * Use along with {totalSupply} to enumerate all tokens.
664      */
665     function tokenByIndex(uint256 index) external view returns (uint256);
666 }
667 
668 /**
669  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
670  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
671  *
672  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
673  *
674  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
675  *
676  * Does not support burning tokens to address(0).
677  */
678  contract ERC721A is
679  Context,
680  ERC165,
681  IERC721,
682  IERC721Metadata,
683  IERC721Enumerable
684 {
685  using Address for address;
686  using Strings for uint256;
687 
688  struct TokenOwnership {
689    address addr;
690    uint64 startTimestamp;
691  }
692 
693  struct AddressData {
694    uint128 balance;
695    uint128 numberMinted;
696  }
697 
698  uint256 private currentIndex = 1;
699 
700  uint256 internal immutable collectionSize;
701  uint256 internal immutable maxBatchSize;
702 
703  // Token name
704  string private _name;
705 
706  // Token symbol
707  string private _symbol;
708 
709  // Mapping from token ID to ownership details
710  // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
711  mapping(uint256 => TokenOwnership) private _ownerships;
712 
713  // Mapping owner address to address data
714  mapping(address => AddressData) private _addressData;
715 
716  // Mapping from token ID to approved address
717  mapping(uint256 => address) private _tokenApprovals;
718 
719  // Mapping from owner to operator approvals
720  mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722  /**
723   * @dev
724   * `maxBatchSize` refers to how much a minter can mint at a time.
725   * `collectionSize_` refers to how many tokens are in the collection.
726   */
727  constructor(
728    string memory name_,
729    string memory symbol_,
730    uint256 maxBatchSize_,
731    uint256 collectionSize_
732  ) {
733    require(
734      collectionSize_ > 0,
735      "ERC721A: collection must have a nonzero supply"
736    );
737    require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
738    _name = name_;
739    _symbol = symbol_;
740    maxBatchSize = maxBatchSize_;
741    collectionSize = collectionSize_;
742  }
743 
744  /**
745   * @dev See {IERC721Enumerable-totalSupply}.
746   */
747  function totalSupply() public view override returns (uint256) {
748    return currentIndex - 1;
749  }
750 
751  /**
752   * @dev See {IERC721Enumerable-tokenByIndex}.
753   */
754  function tokenByIndex(uint256 index) public view override returns (uint256) {
755    require(index < totalSupply() + 1, "ERC721A: global index out of bounds");
756    return index;
757  }
758 
759  /**
760   * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
761   * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
762   * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
763   */
764  function tokenOfOwnerByIndex(address owner, uint256 index)
765    public
766    view
767    override
768    returns (uint256)
769  {
770    require(index < balanceOf(owner) + 1, "ERC721A: owner index out of bounds");
771    uint256 numMintedSoFar = totalSupply() + 1;
772    uint256 tokenIdsIdx = 1;
773    address currOwnershipAddr = address(0);
774    for (uint256 i = 1; i < numMintedSoFar; i++) {
775      TokenOwnership memory ownership = _ownerships[i];
776      if (ownership.addr != address(0)) {
777        currOwnershipAddr = ownership.addr;
778      }
779      if (currOwnershipAddr == owner) {
780        if (tokenIdsIdx == index) {
781          return i;
782        }
783        tokenIdsIdx++;
784      }
785    }
786    revert("ERC721A: unable to get token of owner by index");
787  }
788 
789  /**
790   * @dev See {IERC165-supportsInterface}.
791   */
792  function supportsInterface(bytes4 interfaceId)
793    public
794    view
795    virtual
796    override(ERC165, IERC165)
797    returns (bool)
798  {
799    return
800      interfaceId == type(IERC721).interfaceId ||
801      interfaceId == type(IERC721Metadata).interfaceId ||
802      interfaceId == type(IERC721Enumerable).interfaceId ||
803      super.supportsInterface(interfaceId);
804  }
805 
806  /**
807   * @dev See {IERC721-balanceOf}.
808   */
809  function balanceOf(address owner) public view override returns (uint256) {
810    require(owner != address(0), "ERC721A: balance query for the zero address");
811    return uint256(_addressData[owner].balance);
812  }
813 
814  function _numberMinted(address owner) internal view returns (uint256) {
815    require(
816      owner != address(0),
817      "ERC721A: number minted query for the zero address"
818    );
819    return uint256(_addressData[owner].numberMinted);
820  }
821 
822  function ownershipOf(uint256 tokenId)
823    internal
824    view
825    returns (TokenOwnership memory)
826  {
827    require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
828 
829    uint256 lowestTokenToCheck;
830    if (tokenId >= maxBatchSize) {
831      lowestTokenToCheck = tokenId - maxBatchSize + 1;
832    }
833 
834    for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
835      TokenOwnership memory ownership = _ownerships[curr];
836      if (ownership.addr != address(0)) {
837        return ownership;
838      }
839    }
840 
841    revert("ERC721A: unable to determine the owner of token");
842  }
843 
844  /**
845   * @dev See {IERC721-ownerOf}.
846   */
847  function ownerOf(uint256 tokenId) public view override returns (address) {
848    return ownershipOf(tokenId).addr;
849  }
850 
851  /**
852   * @dev See {IERC721Metadata-name}.
853   */
854  function name() public view virtual override returns (string memory) {
855    return _name;
856  }
857 
858  /**
859   * @dev See {IERC721Metadata-symbol}.
860   */
861  function symbol() public view virtual override returns (string memory) {
862    return _symbol;
863  }
864 
865  /**
866   * @dev See {IERC721Metadata-tokenURI}.
867   */
868  function tokenURI(uint256 tokenId)
869    public
870    view
871    virtual
872    override
873    returns (string memory)
874  {
875    require(
876      _exists(tokenId),
877      "ERC721Metadata: URI query for nonexistent token"
878    );
879 
880    string memory baseURI = _baseURI();
881    return
882      bytes(baseURI).length > 0
883        ? string(abi.encodePacked(baseURI, tokenId.toString()))
884        : "";
885  }
886 
887  /**
888   * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
889   * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
890   * by default, can be overriden in child contracts.
891   */
892  function _baseURI() internal view virtual returns (string memory) {
893    return "";
894  }
895 
896  /**
897   * @dev See {IERC721-approve}.
898   */
899  function approve(address to, uint256 tokenId) public override {
900    address owner = ERC721A.ownerOf(tokenId);
901    require(to != owner, "ERC721A: approval to current owner");
902 
903    require(
904      _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
905      "ERC721A: approve caller is not owner nor approved for all"
906    );
907 
908    _approve(to, tokenId, owner);
909  }
910 
911  /**
912   * @dev See {IERC721-getApproved}.
913   */
914  function getApproved(uint256 tokenId) public view override returns (address) {
915    require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
916 
917    return _tokenApprovals[tokenId];
918  }
919 
920  /**
921   * @dev See {IERC721-setApprovalForAll}.
922   */
923  function setApprovalForAll(address operator, bool approved) public override {
924    require(operator != _msgSender(), "ERC721A: approve to caller");
925 
926    _operatorApprovals[_msgSender()][operator] = approved;
927    emit ApprovalForAll(_msgSender(), operator, approved);
928  }
929 
930  /**
931   * @dev See {IERC721-isApprovedForAll}.
932   */
933  function isApprovedForAll(address owner, address operator)
934    public
935    view
936    virtual
937    override
938    returns (bool)
939  {
940    return _operatorApprovals[owner][operator];
941  }
942 
943  /**
944   * @dev See {IERC721-transferFrom}.
945   */
946  function transferFrom(
947    address from,
948    address to,
949    uint256 tokenId
950  ) public override {
951    _transfer(from, to, tokenId);
952  }
953 
954  /**
955   * @dev See {IERC721-safeTransferFrom}.
956   */
957  function safeTransferFrom(
958    address from,
959    address to,
960    uint256 tokenId
961  ) public override {
962    safeTransferFrom(from, to, tokenId, "");
963  }
964 
965  /**
966   * @dev See {IERC721-safeTransferFrom}.
967   */
968  function safeTransferFrom(
969    address from,
970    address to,
971    uint256 tokenId,
972    bytes memory _data
973  ) public override {
974    _transfer(from, to, tokenId);
975    require(
976      _checkOnERC721Received(from, to, tokenId, _data),
977      "ERC721A: transfer to non ERC721Receiver implementer"
978    );
979  }
980 
981  /**
982   * @dev Returns whether `tokenId` exists.
983   *
984   * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
985   *
986   * Tokens start existing when they are minted (`_mint`),
987   */
988  function _exists(uint256 tokenId) internal view returns (bool) {
989    return tokenId < currentIndex;
990  }
991 
992  function _safeMint(address to, uint256 quantity) internal {
993    _safeMint(to, quantity, "");
994  }
995 
996  /**
997   * @dev Mints `quantity` tokens and transfers them to `to`.
998   *
999   * Requirements:
1000   *
1001   * - there must be `quantity` tokens remaining unminted in the total collection.
1002   * - `to` cannot be the zero address.
1003   * - `quantity` cannot be larger than the max batch size.
1004   *
1005   * Emits a {Transfer} event.
1006   */
1007  function _safeMint(
1008    address to,
1009    uint256 quantity,
1010    bytes memory _data
1011  ) internal {
1012    uint256 startTokenId = currentIndex;
1013    require(to != address(0), "ERC721A: mint to the zero address");
1014    // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1015    require(!_exists(startTokenId), "ERC721A: token already minted");
1016    require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1017 
1018    _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1019 
1020    AddressData memory addressData = _addressData[to];
1021    _addressData[to] = AddressData(
1022      addressData.balance + uint128(quantity),
1023      addressData.numberMinted + uint128(quantity)
1024    );
1025    _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1026 
1027    uint256 updatedIndex = startTokenId;
1028 
1029    for (uint256 i = 0; i < quantity; i++) {
1030      emit Transfer(address(0), to, updatedIndex);
1031      require(
1032        _checkOnERC721Received(address(0), to, updatedIndex, _data),
1033        "ERC721A: transfer to non ERC721Receiver implementer"
1034      );
1035      updatedIndex++;
1036    }
1037 
1038    currentIndex = updatedIndex;
1039    _afterTokenTransfers(address(0), to, startTokenId, quantity);
1040  }
1041 
1042  /**
1043   * @dev Transfers `tokenId` from `from` to `to`.
1044   *
1045   * Requirements:
1046   *
1047   * - `to` cannot be the zero address.
1048   * - `tokenId` token must be owned by `from`.
1049   *
1050   * Emits a {Transfer} event.
1051   */
1052  function _transfer(
1053    address from,
1054    address to,
1055    uint256 tokenId
1056  ) private {
1057    TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1058 
1059    bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1060      getApproved(tokenId) == _msgSender() ||
1061      isApprovedForAll(prevOwnership.addr, _msgSender()));
1062 
1063    require(
1064      isApprovedOrOwner,
1065      "ERC721A: transfer caller is not owner nor approved"
1066    );
1067 
1068    require(
1069      prevOwnership.addr == from,
1070      "ERC721A: transfer from incorrect owner"
1071    );
1072    require(to != address(0), "ERC721A: transfer to the zero address");
1073 
1074    _beforeTokenTransfers(from, to, tokenId, 1);
1075 
1076    // Clear approvals from the previous owner
1077    _approve(address(0), tokenId, prevOwnership.addr);
1078 
1079    _addressData[from].balance -= 1;
1080    _addressData[to].balance += 1;
1081    _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1082 
1083    // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1084    // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1085    uint256 nextTokenId = tokenId + 1;
1086    if (_ownerships[nextTokenId].addr == address(0)) {
1087      if (_exists(nextTokenId)) {
1088        _ownerships[nextTokenId] = TokenOwnership(
1089          prevOwnership.addr,
1090          prevOwnership.startTimestamp
1091        );
1092      }
1093    }
1094 
1095    emit Transfer(from, to, tokenId);
1096    _afterTokenTransfers(from, to, tokenId, 1);
1097  }
1098 
1099  /**
1100   * @dev Approve `to` to operate on `tokenId`
1101   *
1102   * Emits a {Approval} event.
1103   */
1104  function _approve(
1105    address to,
1106    uint256 tokenId,
1107    address owner
1108  ) private {
1109    _tokenApprovals[tokenId] = to;
1110    emit Approval(owner, to, tokenId);
1111  }
1112 
1113  uint256 public nextOwnerToExplicitlySet = 0;
1114 
1115  /**
1116   * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1117   */
1118  function _setOwnersExplicit(uint256 quantity) internal {
1119    uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1120    require(quantity > 0, "quantity must be nonzero");
1121    uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1122    if (endIndex > collectionSize - 1) {
1123      endIndex = collectionSize - 1;
1124    }
1125    // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1126    require(_exists(endIndex), "not enough minted yet for this cleanup");
1127    for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1128      if (_ownerships[i].addr == address(0)) {
1129        TokenOwnership memory ownership = ownershipOf(i);
1130        _ownerships[i] = TokenOwnership(
1131          ownership.addr,
1132          ownership.startTimestamp
1133        );
1134      }
1135    }
1136    nextOwnerToExplicitlySet = endIndex + 1;
1137  }
1138 
1139  /**
1140   * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1141   * The call is not executed if the target address is not a contract.
1142   *
1143   * @param from address representing the previous owner of the given token ID
1144   * @param to target address that will receive the tokens
1145   * @param tokenId uint256 ID of the token to be transferred
1146   * @param _data bytes optional data to send along with the call
1147   * @return bool whether the call correctly returned the expected magic value
1148   */
1149  function _checkOnERC721Received(
1150    address from,
1151    address to,
1152    uint256 tokenId,
1153    bytes memory _data
1154  ) private returns (bool) {
1155    if (to.isContract()) {
1156      try
1157        IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1158      returns (bytes4 retval) {
1159        return retval == IERC721Receiver(to).onERC721Received.selector;
1160      } catch (bytes memory reason) {
1161        if (reason.length == 0) {
1162          revert("ERC721A: transfer to non ERC721Receiver implementer");
1163        } else {
1164          assembly {
1165            revert(add(32, reason), mload(reason))
1166          }
1167        }
1168      }
1169    } else {
1170      return true;
1171    }
1172  }
1173 
1174  /**
1175   * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1176   *
1177   * startTokenId - the first token id to be transferred
1178   * quantity - the amount to be transferred
1179   *
1180   * Calling conditions:
1181   *
1182   * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1183   * transferred to `to`.
1184   * - When `from` is zero, `tokenId` will be minted for `to`.
1185   */
1186  function _beforeTokenTransfers(
1187    address from,
1188    address to,
1189    uint256 startTokenId,
1190    uint256 quantity
1191  ) internal virtual {}
1192 
1193  /**
1194   * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1195   * minting.
1196   *
1197   * startTokenId - the first token id to be transferred
1198   * quantity - the amount to be transferred
1199   *
1200   * Calling conditions:
1201   *
1202   * - when `from` and `to` are both non-zero.
1203   * - `from` and `to` are never both zero.
1204   */
1205  function _afterTokenTransfers(
1206    address from,
1207    address to,
1208    uint256 startTokenId,
1209    uint256 quantity
1210  ) internal virtual {}
1211 }
1212 
1213 /// @title ArchienekoNFT
1214 /// @notice A contract for pixelnauts in the starlink ecosystem
1215 contract ArchienekoNFT is Ownable, ERC721A, ReentrancyGuard {
1216     using   Strings for uint256;
1217 
1218     // uint256 cost = 0.1 ether;
1219     uint256 public maxSupply = 25000;
1220     // mapping(address => bool) public privateSaleList;
1221     // mapping(address => uint256) public mintedAmountonPrivateSale;
1222     uint256 public mintStartTime;
1223     // uint256 public privateSaleAmount = 10;
1224     string private _baseTokenURI;
1225     bool public onPublicSale = false;
1226     constructor (string memory _pendingURI, uint256 _mintStartTime) ERC721A("ArchienekoNFT", "ARCHIENEKONFT", maxSupply, maxSupply) {
1227         _baseTokenURI = _pendingURI;
1228         mintStartTime = _mintStartTime;
1229     }
1230 
1231     modifier callerIsUser() {
1232       require(tx.origin == msg.sender, "The caller is another contract");
1233       _;
1234     }
1235 
1236     function mint(uint256 _mintAmount) external payable callerIsUser{
1237       uint256 supply = totalSupply();
1238       require(block.timestamp > mintStartTime, "Mint Not started");
1239       require(_mintAmount > 0);
1240       require(supply + _mintAmount <= maxSupply, "Total supply exceed");
1241       require(_msgSender() == owner(), "Only owner can mint");
1242 
1243       _safeMint(msg.sender, _mintAmount);
1244 
1245       // if (msg.sender != owner() && !privateSaleList[msg.sender]) {
1246       //   require(onPublicSale, "PublicSale is not started yet");
1247       //   uint256 totalCost = cost * _mintAmount;
1248       //   _safeMint(msg.sender, _mintAmount);
1249       //   refundIfOver(totalCost);
1250       // } else if (privateSaleList[msg.sender]) {
1251       //   require(mintedAmountonPrivateSale[msg.sender] + _mintAmount <= privateSaleAmount, "PrivateSaleAmount exceed for this wallet");
1252       //   _safeMint(msg.sender, _mintAmount);
1253       //   mintedAmountonPrivateSale[msg.sender] += _mintAmount;
1254       //   if (mintedAmountonPrivateSale[msg.sender] == privateSaleAmount) {
1255       //     privateSaleList[msg.sender] = false;
1256       //   }
1257       // } else {
1258       //   _safeMint(msg.sender, _mintAmount);
1259       // }
1260     }
1261 
1262     function _baseURI() internal view virtual override returns (string memory) {
1263       return _baseTokenURI;
1264     }
1265 
1266     function refundIfOver(uint256 price) private {
1267       require(msg.value >= price, "Need to send more ETH.");
1268       if (msg.value > price) {
1269         payable(msg.sender).transfer(msg.value - price);
1270       }
1271     }
1272 
1273     function setBaseURI(string calldata baseURI) external onlyOwner {
1274       _baseTokenURI = baseURI;
1275     }
1276 
1277     function withdrawMoney() external onlyOwner nonReentrant {
1278       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1279       require(success, "Transfer failed.");
1280     }
1281     
1282     function setMintStartTime(uint256 _mintStartTime) external onlyOwner {
1283         mintStartTime = _mintStartTime;
1284     }
1285 
1286     // function setPrivateSaleListForWallets(address[] memory addresses) external onlyOwner {
1287     //     for (uint256 i = 0; i < addresses.length; i++) {
1288     //       privateSaleList[addresses[i]] = true;
1289     //     }
1290     // }
1291 
1292     function setPubliscSale() external onlyOwner {
1293           onPublicSale = true;
1294     } 
1295 
1296     // function setPrivateSaleListForOneWallet(address wallet) external onlyOwner {
1297     //       privateSaleList[wallet] = true;
1298     // }
1299 
1300     // function RemovePrivateSaleList(address wallet) external onlyOwner {
1301     //       privateSaleList[wallet] = false;
1302     // }
1303 
1304     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1305     _setOwnersExplicit(quantity);
1306     }
1307 
1308     function numberMinted(address owner) public view returns (uint256) {
1309       return _numberMinted(owner);
1310     }
1311 
1312     function getOwnershipData(uint256 tokenId)
1313       external
1314       view
1315       returns (TokenOwnership memory)
1316     {
1317       return ownershipOf(tokenId);
1318     }    
1319 }