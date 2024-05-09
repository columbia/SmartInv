1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
65 }
66 
67 /**
68  * @dev Collection of functions related to the address type
69  */
70 library Address {
71     /**
72      * @dev Returns true if `account` is a contract.
73      *
74      * [IMPORTANT]
75      * ====
76      * It is unsafe to assume that an address for which this function returns
77      * false is an externally-owned account (EOA) and not a contract.
78      *
79      * Among others, `isContract` will return false for the following
80      * types of addresses:
81      *
82      *  - an externally-owned account
83      *  - a contract in construction
84      *  - an address where a contract will be created
85      *  - an address where a contract lived, but was destroyed
86      * ====
87      */
88     function isContract(address account) internal view returns (bool) {
89         // This method relies on extcodesize, which returns 0 for contracts in
90         // construction, since the code is only stored at the end of the
91         // constructor execution.
92 
93         uint256 size;
94         assembly {
95             size := extcodesize(account)
96         }
97         return size > 0;
98     }
99 
100     /**
101      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
102      * `recipient`, forwarding all available gas and reverting on errors.
103      *
104      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
105      * of certain opcodes, possibly making contracts go over the 2300 gas limit
106      * imposed by `transfer`, making them unable to receive funds via
107      * `transfer`. {sendValue} removes this limitation.
108      *
109      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
110      *
111      * IMPORTANT: because control is transferred to `recipient`, care must be
112      * taken to not create reentrancy vulnerabilities. Consider using
113      * {ReentrancyGuard} or the
114      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
115      */
116     function sendValue(address payable recipient, uint256 amount) internal {
117         require(address(this).balance >= amount, "Address: insufficient balance");
118 
119         (bool success, ) = recipient.call{value: amount}("");
120         require(success, "Address: unable to send value, recipient may have reverted");
121     }
122 
123     /**
124      * @dev Performs a Solidity function call using a low level `call`. A
125      * plain `call` is an unsafe replacement for a function call: use this
126      * function instead.
127      *
128      * If `target` reverts with a revert reason, it is bubbled up by this
129      * function (like regular Solidity function calls).
130      *
131      * Returns the raw returned data. To convert to the expected return value,
132      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
133      *
134      * Requirements:
135      *
136      * - `target` must be a contract.
137      * - calling `target` with `data` must not revert.
138      *
139      * _Available since v3.1._
140      */
141     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
147      * `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but also transferring `value` wei to `target`.
162      *
163      * Requirements:
164      *
165      * - the calling contract must have an ETH balance of at least `value`.
166      * - the called Solidity function must be `payable`.
167      *
168      * _Available since v3.1._
169      */
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
180      * with `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a static call.
200      *
201      * _Available since v3.3._
202      */
203     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
204         return functionStaticCall(target, data, "Address: low-level static call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         require(isContract(target), "Address: delegate call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
253      * revert reason using the provided one.
254      *
255      * _Available since v4.3._
256      */
257     function verifyCallResult(
258         bool success,
259         bytes memory returndata,
260         string memory errorMessage
261     ) internal pure returns (bytes memory) {
262         if (success) {
263             return returndata;
264         } else {
265             // Look for revert reason and bubble it up if present
266             if (returndata.length > 0) {
267                 // The easiest way to bubble the revert reason is using memory via assembly
268 
269                 assembly {
270                     let returndata_size := mload(returndata)
271                     revert(add(32, returndata), returndata_size)
272                 }
273             } else {
274                 revert(errorMessage);
275             }
276         }
277     }
278 }
279 
280 /**
281  * @title ERC721 token receiver interface
282  * @dev Interface for any contract that wants to support safeTransfers
283  * from ERC721 asset contracts.
284  */
285 interface IERC721Receiver {
286     /**
287      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
288      * by `operator` from `from`, this function is called.
289      *
290      * It must return its Solidity selector to confirm the token transfer.
291      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
292      *
293      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
294      */
295     function onERC721Received(
296         address operator,
297         address from,
298         uint256 tokenId,
299         bytes calldata data
300     ) external returns (bytes4);
301 }
302 
303 /**
304  * @dev Interface of the ERC165 standard, as defined in the
305  * https://eips.ethereum.org/EIPS/eip-165[EIP].
306  *
307  * Implementers can declare support of contract interfaces, which can then be
308  * queried by others ({ERC165Checker}).
309  *
310  * For an implementation, see {ERC165}.
311  */
312 interface IERC165 {
313     /**
314      * @dev Returns true if this contract implements the interface defined by
315      * `interfaceId`. See the corresponding
316      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
317      * to learn more about how these ids are created.
318      *
319      * This function call must use less than 30 000 gas.
320      */
321     function supportsInterface(bytes4 interfaceId) external view returns (bool);
322 }
323 
324 /**
325  * @dev Implementation of the {IERC165} interface.
326  *
327  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
328  * for the additional interface id that will be supported. For example:
329  *
330  * ```solidity
331  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
332  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
333  * }
334  * ```
335  *
336  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
337  */
338 abstract contract ERC165 is IERC165 {
339     /**
340      * @dev See {IERC165-supportsInterface}.
341      */
342     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
343         return interfaceId == type(IERC165).interfaceId;
344     }
345 }
346 
347 /**
348  * @dev Required interface of an ERC721 compliant contract.
349  */
350 interface IERC721 is IERC165 {
351     /**
352      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
353      */
354     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
358      */
359     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
363      */
364     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
365 
366     /**
367      * @dev Returns the number of tokens in ``owner``'s account.
368      */
369     function balanceOf(address owner) external view returns (uint256 balance);
370 
371     /**
372      * @dev Returns the owner of the `tokenId` token.
373      *
374      * Requirements:
375      *
376      * - `tokenId` must exist.
377      */
378     function ownerOf(uint256 tokenId) external view returns (address owner);
379 
380     /**
381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must exist and be owned by `from`.
389      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Transfers `tokenId` token from `from` to `to`.
402      *
403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must be owned by `from`.
410      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
422      * The approval is cleared when the token is transferred.
423      *
424      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
425      *
426      * Requirements:
427      *
428      * - The caller must own the token or be an approved operator.
429      * - `tokenId` must exist.
430      *
431      * Emits an {Approval} event.
432      */
433     function approve(address to, uint256 tokenId) external;
434 
435     /**
436      * @dev Returns the account approved for `tokenId` token.
437      *
438      * Requirements:
439      *
440      * - `tokenId` must exist.
441      */
442     function getApproved(uint256 tokenId) external view returns (address operator);
443 
444     /**
445      * @dev Approve or remove `operator` as an operator for the caller.
446      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
447      *
448      * Requirements:
449      *
450      * - The `operator` cannot be the caller.
451      *
452      * Emits an {ApprovalForAll} event.
453      */
454     function setApprovalForAll(address operator, bool _approved) external;
455 
456     /**
457      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
458      *
459      * See {setApprovalForAll}
460      */
461     function isApprovedForAll(address owner, address operator) external view returns (bool);
462 
463     /**
464      * @dev Safely transfers `tokenId` token from `from` to `to`.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must exist and be owned by `from`.
471      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId,
480         bytes calldata data
481     ) external;
482 }
483 
484 /**
485  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
486  * @dev See https://eips.ethereum.org/EIPS/eip-721
487  */
488 interface IERC721Enumerable is IERC721 {
489     /**
490      * @dev Returns the total amount of tokens stored by the contract.
491      */
492     function totalSupply() external view returns (uint256);
493 
494     /**
495      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
496      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
497      */
498     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
499 
500     /**
501      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
502      * Use along with {totalSupply} to enumerate all tokens.
503      */
504     function tokenByIndex(uint256 index) external view returns (uint256);
505 }
506 
507 /**
508  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
509  * @dev See https://eips.ethereum.org/EIPS/eip-721
510  */
511 interface IERC721Metadata is IERC721 {
512     /**
513      * @dev Returns the token collection name.
514      */
515     function name() external view returns (string memory);
516 
517     /**
518      * @dev Returns the token collection symbol.
519      */
520     function symbol() external view returns (string memory);
521 
522     /**
523      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
524      */
525     function tokenURI(uint256 tokenId) external view returns (string memory);
526 }
527 
528 /**
529  * @dev Contract module that helps prevent reentrant calls to a function.
530  *
531  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
532  * available, which can be applied to functions to make sure there are no nested
533  * (reentrant) calls to them.
534  *
535  * Note that because there is a single `nonReentrant` guard, functions marked as
536  * `nonReentrant` may not call one another. This can be worked around by making
537  * those functions `private`, and then adding `external` `nonReentrant` entry
538  * points to them.
539  *
540  * TIP: If you would like to learn more about reentrancy and alternative ways
541  * to protect against it, check out our blog post
542  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
543  */
544 abstract contract ReentrancyGuard {
545     // Booleans are more expensive than uint256 or any type that takes up a full
546     // word because each write operation emits an extra SLOAD to first read the
547     // slot's contents, replace the bits taken up by the boolean, and then write
548     // back. This is the compiler's defense against contract upgrades and
549     // pointer aliasing, and it cannot be disabled.
550 
551     // The values being non-zero value makes deployment a bit more expensive,
552     // but in exchange the refund on every call to nonReentrant will be lower in
553     // amount. Since refunds are capped to a percentage of the total
554     // transaction's gas, it is best to keep them low in cases like this one, to
555     // increase the likelihood of the full refund coming into effect.
556     uint256 private constant _NOT_ENTERED = 1;
557     uint256 private constant _ENTERED = 2;
558 
559     uint256 private _status;
560 
561     constructor() {
562         _status = _NOT_ENTERED;
563     }
564 
565     /**
566      * @dev Prevents a contract from calling itself, directly or indirectly.
567      * Calling a `nonReentrant` function from another `nonReentrant`
568      * function is not supported. It is possible to prevent this from happening
569      * by making the `nonReentrant` function external, and making it call a
570      * `private` function that does the actual work.
571      */
572     modifier nonReentrant() {
573         // On the first call to nonReentrant, _notEntered will be true
574         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
575 
576         // Any calls to nonReentrant after this point will fail
577         _status = _ENTERED;
578 
579         _;
580 
581         // By storing the original value once again, a refund is triggered (see
582         // https://eips.ethereum.org/EIPS/eip-2200)
583         _status = _NOT_ENTERED;
584     }
585 }
586 
587 /**
588  * @dev Provides information about the current execution context, including the
589  * sender of the transaction and its data. While these are generally available
590  * via msg.sender and msg.data, they should not be accessed in such a direct
591  * manner, since when dealing with meta-transactions the account sending and
592  * paying for execution may not be the actual sender (as far as an application
593  * is concerned).
594  *
595  * This contract is only required for intermediate, library-like contracts.
596  */
597 abstract contract Context {
598     function _msgSender() internal view virtual returns (address) {
599         return msg.sender;
600     }
601 
602     function _msgData() internal view virtual returns (bytes calldata) {
603         return msg.data;
604     }
605 }
606 
607 /**
608  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
609  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
610  *
611  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
612  *
613  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
614  *
615  * Does not support burning tokens to address(0).
616  */
617 contract ERC721A is
618   Context,
619   ERC165,
620   IERC721,
621   IERC721Metadata,
622   IERC721Enumerable
623 {
624   using Address for address;
625   using Strings for uint256;
626 
627   struct TokenOwnership {
628     address addr;
629     uint64 startTimestamp;
630   }
631 
632   struct AddressData {
633     uint128 balance;
634     uint128 numberMinted;
635   }
636 
637   uint256 private currentIndex = 0;
638 
639   uint256 internal collectionSize;
640   uint256 internal maxBatchSize;
641 
642   // Token name
643   string private _name;
644 
645   // Token symbol
646   string private _symbol;
647 
648   // Mapping from token ID to ownership details
649   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
650   mapping(uint256 => TokenOwnership) private _ownerships;
651 
652   // Mapping owner address to address data
653   mapping(address => AddressData) private _addressData;
654 
655   // Mapping from token ID to approved address
656   mapping(uint256 => address) private _tokenApprovals;
657 
658   // Mapping from owner to operator approvals
659   mapping(address => mapping(address => bool)) private _operatorApprovals;
660 
661   /**
662    * @dev
663    * `maxBatchSize` refers to how much a minter can mint at a time.
664    * `collectionSize_` refers to how many tokens are in the collection.
665    */
666   constructor(
667     string memory name_,
668     string memory symbol_,
669     uint256 maxBatchSize_,
670     uint256 collectionSize_
671   ) {
672     require(
673       collectionSize_ > 0,
674       "ERC721A: collection must have a nonzero supply"
675     );
676     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
677     _name = name_;
678     _symbol = symbol_;
679     maxBatchSize = maxBatchSize_;
680     collectionSize = collectionSize_;
681   }
682 
683    /**
684    * @dev See maxBatchSize Functionality..
685    */
686   function changeMaxBatchSize(uint256 newBatch) public{
687     maxBatchSize = newBatch;
688   }
689 
690   function changeCollectionSize(uint256 newCollectionSize) public{
691     collectionSize = newCollectionSize;
692   }
693 
694   /**
695    * @dev See {IERC721Enumerable-totalSupply}.
696    */
697   function totalSupply() public view override returns (uint256) {
698     return currentIndex;
699   }
700 
701   /**
702    * @dev See {IERC721Enumerable-tokenByIndex}.
703    */
704   function tokenByIndex(uint256 index) public view override returns (uint256) {
705     require(index < totalSupply(), "ERC721A: global index out of bounds");
706     return index;
707   }
708 
709   /**
710    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
711    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
712    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
713    */
714   function tokenOfOwnerByIndex(address owner, uint256 index)
715     public
716     view
717     override
718     returns (uint256)
719   {
720     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
721     uint256 numMintedSoFar = totalSupply();
722     uint256 tokenIdsIdx = 0;
723     address currOwnershipAddr = address(0);
724     for (uint256 i = 0; i < numMintedSoFar; i++) {
725       TokenOwnership memory ownership = _ownerships[i];
726       if (ownership.addr != address(0)) {
727         currOwnershipAddr = ownership.addr;
728       }
729       if (currOwnershipAddr == owner) {
730         if (tokenIdsIdx == index) {
731           return i;
732         }
733         tokenIdsIdx++;
734       }
735     }
736     revert("ERC721A: unable to get token of owner by index");
737   }
738 
739   /**
740    * @dev See {IERC165-supportsInterface}.
741    */
742   function supportsInterface(bytes4 interfaceId)
743     public
744     view
745     virtual
746     override(ERC165, IERC165)
747     returns (bool)
748   {
749     return
750       interfaceId == type(IERC721).interfaceId ||
751       interfaceId == type(IERC721Metadata).interfaceId ||
752       interfaceId == type(IERC721Enumerable).interfaceId ||
753       super.supportsInterface(interfaceId);
754   }
755 
756   /**
757    * @dev See {IERC721-balanceOf}.
758    */
759   function balanceOf(address owner) public view override returns (uint256) {
760     require(owner != address(0), "ERC721A: balance query for the zero address");
761     return uint256(_addressData[owner].balance);
762   }
763 
764   function _numberMinted(address owner) internal view returns (uint256) {
765     require(
766       owner != address(0),
767       "ERC721A: number minted query for the zero address"
768     );
769     return uint256(_addressData[owner].numberMinted);
770   }
771 
772   function ownershipOf(uint256 tokenId)
773     internal
774     view
775     returns (TokenOwnership memory)
776   {
777     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
778 
779     uint256 lowestTokenToCheck;
780     if (tokenId >= maxBatchSize) {
781       lowestTokenToCheck = tokenId - maxBatchSize + 1;
782     }
783 
784     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
785       TokenOwnership memory ownership = _ownerships[curr];
786       if (ownership.addr != address(0)) {
787         return ownership;
788       }
789     }
790 
791     revert("ERC721A: unable to determine the owner of token");
792   }
793 
794   /**
795    * @dev See {IERC721-ownerOf}.
796    */
797   function ownerOf(uint256 tokenId) public view override returns (address) {
798     return ownershipOf(tokenId).addr;
799   }
800 
801   /**
802    * @dev See {IERC721Metadata-name}.
803    */
804   function name() public view virtual override returns (string memory) {
805     return _name;
806   }
807 
808   /**
809    * @dev See {IERC721Metadata-symbol}.
810    */
811   function symbol() public view virtual override returns (string memory) {
812     return _symbol;
813   }
814 
815   /**
816    * @dev See {IERC721Metadata-tokenURI}.
817    */
818   function tokenURI(uint256 tokenId)
819     public
820     view
821     virtual
822     override
823     returns (string memory)
824   {
825     require(
826       _exists(tokenId),
827       "ERC721Metadata: URI query for nonexistent token"
828     );
829 
830     string memory baseURI = _baseURI();
831     return
832       bytes(baseURI).length > 0
833         ? string(abi.encodePacked(baseURI, tokenId.toString()))
834         : "";
835   }
836 
837   /**
838    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840    * by default, can be overriden in child contracts.
841    */
842   function _baseURI() internal view virtual returns (string memory) {
843     return "";
844   }
845 
846   /**
847    * @dev See {IERC721-approve}.
848    */
849   function approve(address to, uint256 tokenId) public override {
850     address owner = ERC721A.ownerOf(tokenId);
851     require(to != owner, "ERC721A: approval to current owner");
852 
853     require(
854       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
855       "ERC721A: approve caller is not owner nor approved for all"
856     );
857 
858     _approve(to, tokenId, owner);
859   }
860 
861   /**
862    * @dev See {IERC721-getApproved}.
863    */
864   function getApproved(uint256 tokenId) public view override returns (address) {
865     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
866 
867     return _tokenApprovals[tokenId];
868   }
869 
870   /**
871    * @dev See {IERC721-setApprovalForAll}.
872    */
873   function setApprovalForAll(address operator, bool approved) public override {
874     require(operator != _msgSender(), "ERC721A: approve to caller");
875 
876     _operatorApprovals[_msgSender()][operator] = approved;
877     emit ApprovalForAll(_msgSender(), operator, approved);
878   }
879 
880   /**
881    * @dev See {IERC721-isApprovedForAll}.
882    */
883   function isApprovedForAll(address owner, address operator)
884     public
885     view
886     virtual
887     override
888     returns (bool)
889   {
890     return _operatorApprovals[owner][operator];
891   }
892 
893   /**
894    * @dev See {IERC721-transferFrom}.
895    */
896   function transferFrom(
897     address from,
898     address to,
899     uint256 tokenId
900   ) public override {
901     _transfer(from, to, tokenId);
902   }
903 
904   /**
905    * @dev See {IERC721-safeTransferFrom}.
906    */
907   function safeTransferFrom(
908     address from,
909     address to,
910     uint256 tokenId
911   ) public override {
912     safeTransferFrom(from, to, tokenId, "");
913   }
914 
915   /**
916    * @dev See {IERC721-safeTransferFrom}.
917    */
918   function safeTransferFrom(
919     address from,
920     address to,
921     uint256 tokenId,
922     bytes memory _data
923   ) public override {
924     _transfer(from, to, tokenId);
925     require(
926       _checkOnERC721Received(from, to, tokenId, _data),
927       "ERC721A: transfer to non ERC721Receiver implementer"
928     );
929   }
930 
931   /**
932    * @dev Returns whether `tokenId` exists.
933    *
934    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
935    *
936    * Tokens start existing when they are minted (`_mint`),
937    */
938   function _exists(uint256 tokenId) internal view returns (bool) {
939     return tokenId < currentIndex;
940   }
941 
942   function _safeMint(address to, uint256 quantity) internal {
943     _safeMint(to, quantity, "");
944   }
945 
946   /**
947    * @dev Mints `quantity` tokens and transfers them to `to`.
948    *
949    * Requirements:
950    *
951    * - there must be `quantity` tokens remaining unminted in the total collection.
952    * - `to` cannot be the zero address.
953    * - `quantity` cannot be larger than the max batch size.
954    *
955    * Emits a {Transfer} event.
956    */
957   function _safeMint(
958     address to,
959     uint256 quantity,
960     bytes memory _data
961   ) internal {
962     uint256 startTokenId = currentIndex;
963     require(to != address(0), "ERC721A: mint to the zero address");
964     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
965     require(!_exists(startTokenId), "ERC721A: token already minted");
966     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
967 
968     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
969 
970     AddressData memory addressData = _addressData[to];
971     _addressData[to] = AddressData(
972       addressData.balance + uint128(quantity),
973       addressData.numberMinted + uint128(quantity)
974     );
975     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
976 
977     uint256 updatedIndex = startTokenId;
978 
979     for (uint256 i = 0; i < quantity; i++) {
980       emit Transfer(address(0), to, updatedIndex);
981       require(
982         _checkOnERC721Received(address(0), to, updatedIndex, _data),
983         "ERC721A: transfer to non ERC721Receiver implementer"
984       );
985       updatedIndex++;
986     }
987 
988     currentIndex = updatedIndex;
989     _afterTokenTransfers(address(0), to, startTokenId, quantity);
990   }
991 
992   /**
993    * @dev Transfers `tokenId` from `from` to `to`.
994    *
995    * Requirements:
996    *
997    * - `to` cannot be the zero address.
998    * - `tokenId` token must be owned by `from`.
999    *
1000    * Emits a {Transfer} event.
1001    */
1002   function _transfer(
1003     address from,
1004     address to,
1005     uint256 tokenId
1006   ) private {
1007     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1008 
1009     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1010       getApproved(tokenId) == _msgSender() ||
1011       isApprovedForAll(prevOwnership.addr, _msgSender()));
1012 
1013     require(
1014       isApprovedOrOwner,
1015       "ERC721A: transfer caller is not owner nor approved"
1016     );
1017 
1018     require(
1019       prevOwnership.addr == from,
1020       "ERC721A: transfer from incorrect owner"
1021     );
1022     require(to != address(0), "ERC721A: transfer to the zero address");
1023 
1024     _beforeTokenTransfers(from, to, tokenId, 1);
1025 
1026     // Clear approvals from the previous owner
1027     _approve(address(0), tokenId, prevOwnership.addr);
1028 
1029     _addressData[from].balance -= 1;
1030     _addressData[to].balance += 1;
1031     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1032 
1033     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1034     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1035     uint256 nextTokenId = tokenId + 1;
1036     if (_ownerships[nextTokenId].addr == address(0)) {
1037       if (_exists(nextTokenId)) {
1038         _ownerships[nextTokenId] = TokenOwnership(
1039           prevOwnership.addr,
1040           prevOwnership.startTimestamp
1041         );
1042       }
1043     }
1044 
1045     emit Transfer(from, to, tokenId);
1046     _afterTokenTransfers(from, to, tokenId, 1);
1047   }
1048 
1049   /**
1050    * @dev Approve `to` to operate on `tokenId`
1051    *
1052    * Emits a {Approval} event.
1053    */
1054   function _approve(
1055     address to,
1056     uint256 tokenId,
1057     address owner
1058   ) private {
1059     _tokenApprovals[tokenId] = to;
1060     emit Approval(owner, to, tokenId);
1061   }
1062 
1063   uint256 public nextOwnerToExplicitlySet = 0;
1064 
1065   /**
1066    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1067    */
1068   function _setOwnersExplicit(uint256 quantity) internal {
1069     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1070     require(quantity > 0, "quantity must be nonzero");
1071     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1072     if (endIndex > collectionSize - 1) {
1073       endIndex = collectionSize - 1;
1074     }
1075     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1076     require(_exists(endIndex), "not enough minted yet for this cleanup");
1077     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1078       if (_ownerships[i].addr == address(0)) {
1079         TokenOwnership memory ownership = ownershipOf(i);
1080         _ownerships[i] = TokenOwnership(
1081           ownership.addr,
1082           ownership.startTimestamp
1083         );
1084       }
1085     }
1086     nextOwnerToExplicitlySet = endIndex + 1;
1087   }
1088 
1089   /**
1090    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091    * The call is not executed if the target address is not a contract.
1092    *
1093    * @param from address representing the previous owner of the given token ID
1094    * @param to target address that will receive the tokens
1095    * @param tokenId uint256 ID of the token to be transferred
1096    * @param _data bytes optional data to send along with the call
1097    * @return bool whether the call correctly returned the expected magic value
1098    */
1099   function _checkOnERC721Received(
1100     address from,
1101     address to,
1102     uint256 tokenId,
1103     bytes memory _data
1104   ) private returns (bool) {
1105     if (to.isContract()) {
1106       try
1107         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1108       returns (bytes4 retval) {
1109         return retval == IERC721Receiver(to).onERC721Received.selector;
1110       } catch (bytes memory reason) {
1111         if (reason.length == 0) {
1112           revert("ERC721A: transfer to non ERC721Receiver implementer");
1113         } else {
1114           assembly {
1115             revert(add(32, reason), mload(reason))
1116           }
1117         }
1118       }
1119     } else {
1120       return true;
1121     }
1122   }
1123 
1124   /**
1125    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1126    *
1127    * startTokenId - the first token id to be transferred
1128    * quantity - the amount to be transferred
1129    *
1130    * Calling conditions:
1131    *
1132    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1133    * transferred to `to`.
1134    * - When `from` is zero, `tokenId` will be minted for `to`.
1135    */
1136   function _beforeTokenTransfers(
1137     address from,
1138     address to,
1139     uint256 startTokenId,
1140     uint256 quantity
1141   ) internal virtual {}
1142 
1143   /**
1144    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1145    * minting.
1146    *
1147    * startTokenId - the first token id to be transferred
1148    * quantity - the amount to be transferred
1149    *
1150    * Calling conditions:
1151    *
1152    * - when `from` and `to` are both non-zero.
1153    * - `from` and `to` are never both zero.
1154    */
1155   function _afterTokenTransfers(
1156     address from,
1157     address to,
1158     uint256 startTokenId,
1159     uint256 quantity
1160   ) internal virtual {}
1161 }
1162 
1163 /**
1164  * @dev Contract module which provides a basic access control mechanism, where
1165  * there is an account (an owner) that can be granted exclusive access to
1166  * specific functions.
1167  *
1168  * By default, the owner account will be the one that deploys the contract. This
1169  * can later be changed with {transferOwnership}.
1170  *
1171  * This module is used through inheritance. It will make available the modifier
1172  * `onlyOwner`, which can be applied to your functions to restrict their use to
1173  * the owner.
1174  */
1175 abstract contract Ownable is Context {
1176     address private _owner;
1177 
1178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1179 
1180     /**
1181      * @dev Initializes the contract setting the deployer as the initial owner.
1182      */
1183     constructor() {
1184         _transferOwnership(_msgSender());
1185     }
1186 
1187     /**
1188      * @dev Returns the address of the current owner.
1189      */
1190     function owner() public view virtual returns (address) {
1191         return _owner;
1192     }
1193 
1194     /**
1195      * @dev Throws if called by any account other than the owner.
1196      */
1197     modifier onlyOwner() {
1198         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1199         _;
1200     }
1201 
1202     /**
1203      * @dev Leaves the contract without owner. It will not be possible to call
1204      * `onlyOwner` functions anymore. Can only be called by the current owner.
1205      *
1206      * NOTE: Renouncing ownership will leave the contract without an owner,
1207      * thereby removing any functionality that is only available to the owner.
1208      */
1209     function renounceOwnership() public virtual onlyOwner {
1210         _transferOwnership(address(0));
1211     }
1212 
1213     /**
1214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1215      * Can only be called by the current owner.
1216      */
1217     function transferOwnership(address newOwner) public virtual onlyOwner {
1218         require(newOwner != address(0), "Ownable: new owner is the zero address");
1219         _transferOwnership(newOwner);
1220     }
1221 
1222     /**
1223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1224      * Internal function without access restriction.
1225      */
1226     function _transferOwnership(address newOwner) internal virtual {
1227         address oldOwner = _owner;
1228         _owner = newOwner;
1229         emit OwnershipTransferred(oldOwner, newOwner);
1230     }
1231 }
1232 
1233 contract SommerRayDAO is Ownable, ERC721A, ReentrancyGuard {
1234 
1235   constructor(
1236     uint256 maxBatchSize_,
1237     uint256 collectionSize_,
1238     uint256 amountForAuctionAndDev_
1239   ) ERC721A("SommerRayDAO", "SommerDAO", maxBatchSize_, collectionSize_) {
1240     require(amountForAuctionAndDev_ <= collectionSize_, "larger collection size needed" );
1241   }
1242     
1243    uint256 pricePer = 0.01 ether;
1244    uint256 totalCost;
1245    address private constant MIKE = 0xc5376f2831D28CB20707A0F015146a9D219bEfDA;
1246    address private constant FUEGO = 0x9E862Ce07c0e47f7a7601aaC69b74aeE87699f53;
1247    address private constant CHICK = 0x11f0F466B52762E30f2456b4985208AE9296D2C9;
1248 
1249   function mintGiveaway(uint quantity) external onlyOwner {
1250       require(totalSupply() + quantity <= 1111, 'sold out');
1251       _safeMint(msg.sender, quantity);
1252   }
1253 
1254   function mint(uint256 quantity) external payable {
1255     require(quantity <= 10, 'Cant mint more than 10');
1256     if (totalSupply() > 300){
1257         totalCost = quantity * pricePer;
1258     }
1259     if (totalSupply() <= 300){
1260         totalCost = 0;
1261     }
1262     require(totalSupply() + quantity <= 1111, 'sold out');
1263     require(msg.value >= totalCost, 'Not enough Eth sent');
1264     _safeMint(msg.sender, quantity);
1265   }
1266 
1267   // // metadata URI
1268   string private _baseTokenURI;
1269 
1270   function _baseURI() internal view virtual override returns (string memory) {
1271     return _baseTokenURI;
1272   }
1273 
1274   function setBaseURI(string calldata baseURI) external onlyOwner {
1275     _baseTokenURI = baseURI;
1276   }
1277 
1278   function withdrawAll() public onlyOwner {
1279       uint256 balance = address(this).balance;
1280       require(balance > 0, "Insufficent balance");
1281       _withdraw(MIKE, ((balance * 33) / 100));
1282       _withdraw(FUEGO, ((balance * 33) / 100));
1283       _withdraw(CHICK, ((balance * 33) / 100));
1284       _withdraw(MIKE, address(this).balance);
1285   }
1286 
1287   function _withdraw(address _address, uint256 _amount) private {
1288       (bool success, ) = _address.call{ value: _amount }("");
1289       require(success, "Failed to widthdraw Ether");
1290   }  
1291   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1292     _setOwnersExplicit(quantity);
1293   }
1294 
1295   function numberMinted(address owner) public view returns (uint256) {
1296     return _numberMinted(owner);
1297   }
1298 
1299   function getOwnershipData(uint256 tokenId)
1300     external
1301     view
1302     returns (TokenOwnership memory)
1303   {
1304     return ownershipOf(tokenId);
1305   }
1306 }