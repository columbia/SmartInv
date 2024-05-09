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
13     function UintToString(uint256 value) internal pure returns (string memory) {
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
35 }
36 
37 /*
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * By default, the owner account will be the one that deploys the contract. This
63  * can later be changed with {transferOwnership}.
64  *
65  * This module is used through inheritance. It will make available the modifier
66  * `onlyOwner`, which can be applied to your functions to restrict their use to
67  * the owner.
68  */
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() {
78         _setOwner(_msgSender());
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     /**
97      * @dev Leaves the contract without owner. It will not be possible to call
98      * `onlyOwner` functions anymore. Can only be called by the current owner.
99      *
100      * NOTE: Renouncing ownership will leave the contract without an owner,
101      * thereby removing any functionality that is only available to the owner.
102      */
103     function renounceOwnership() public virtual onlyOwner {
104         _setOwner(address(0));
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _setOwner(newOwner);
114     }
115 
116     function _setOwner(address newOwner) private {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 
146 /**
147  * @dev Implementation of the {IERC165} interface.
148  *
149  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
150  * for the additional interface id that will be supported. For example:
151  *
152  * ```solidity
153  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
154  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
155  * }
156  * ```
157  *
158  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
159  */
160 abstract contract ERC165 is IERC165 {
161     /**
162      * @dev See {IERC165-supportsInterface}.
163      */
164     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
165         return interfaceId == type(IERC165).interfaceId;
166     }
167 }
168 
169 /**
170  * @dev Required interface of an ERC721 compliant contract.
171  */
172 interface IERC721 is IERC165 {
173     /**
174      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
177 
178     /**
179      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
180      */
181     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
182 
183     /**
184      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
185      */
186     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
187 
188     /**
189      * @dev Returns the number of tokens in ``owner``'s account.
190      */
191     function balanceOf(address owner) external view returns (uint256 balance);
192 
193     /**
194      * @dev Returns the owner of the `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function ownerOf(uint256 tokenId) external view returns (address owner);
201 
202     /**
203      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
204      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Transfers `tokenId` token from `from` to `to`.
224      *
225      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external;
241 
242     /**
243      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
244      * The approval is cleared when the token is transferred.
245      *
246      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
247      *
248      * Requirements:
249      *
250      * - The caller must own the token or be an approved operator.
251      * - `tokenId` must exist.
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address to, uint256 tokenId) external;
256 
257     /**
258      * @dev Returns the account approved for `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function getApproved(uint256 tokenId) external view returns (address operator);
265 
266     /**
267      * @dev Approve or remove `operator` as an operator for the caller.
268      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
269      *
270      * Requirements:
271      *
272      * - The `operator` cannot be the caller.
273      *
274      * Emits an {ApprovalForAll} event.
275      */
276     function setApprovalForAll(address operator, bool _approved) external;
277 
278     /**
279      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
280      *
281      * See {setApprovalForAll}
282      */
283     function isApprovedForAll(address owner, address operator) external view returns (bool);
284 
285     /**
286      * @dev Safely transfers `tokenId` token from `from` to `to`.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must exist and be owned by `from`.
293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
295      *
296      * Emits a {Transfer} event.
297      */
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId,
302         bytes calldata data
303     ) external;
304 }
305 
306 
307 /**
308  * @title ERC721 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  * from ERC721 asset contracts.
311  */
312 interface IERC721Receiver {
313     /**
314      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
315      * by `operator` from `from`, this function is called.
316      *
317      * It must return its Solidity selector to confirm the token transfer.
318      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
319      *
320      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
321      */
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 
331 /**
332  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
333  * @dev See https://eips.ethereum.org/EIPS/eip-721
334  */
335 interface IERC721Metadata is IERC721 {
336     /**
337      * @dev Returns the token collection name.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the token collection symbol.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
348      */
349     function tokenURI(uint256 tokenId) external view returns (string memory);
350 }
351 
352 
353 /**
354  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
355  * @dev See https://eips.ethereum.org/EIPS/eip-721
356  */
357 interface IERC721Enumerable is IERC721 {
358     /**
359      * @dev Returns the total amount of tokens stored by the contract.
360      */
361     function totalSupply() external view returns (uint256);
362 
363     /**
364      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
365      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
366      */
367     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
368 
369     /**
370      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
371      * Use along with {totalSupply} to enumerate all tokens.
372      */
373     function tokenByIndex(uint256 index) external view returns (uint256);
374 }
375 
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies on extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         uint256 size;
404         assembly {
405             size := extcodesize(account)
406         }
407         return size > 0;
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      */
426     function sendValue(address payable recipient, uint256 amount) internal {
427         require(address(this).balance >= amount, "Address: insufficient balance");
428 
429         (bool success, ) = recipient.call{value: amount}("");
430         require(success, "Address: unable to send value, recipient may have reverted");
431     }
432 
433     /**
434      * @dev Performs a Solidity function call using a low level `call`. A
435      * plain `call` is an unsafe replacement for a function call: use this
436      * function instead.
437      *
438      * If `target` reverts with a revert reason, it is bubbled up by this
439      * function (like regular Solidity function calls).
440      *
441      * Returns the raw returned data. To convert to the expected return value,
442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
443      *
444      * Requirements:
445      *
446      * - `target` must be a contract.
447      * - calling `target` with `data` must not revert.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
452         return functionCall(target, data, "Address: low-level call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
457      * `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         return functionCallWithValue(target, data, 0, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but also transferring `value` wei to `target`.
472      *
473      * Requirements:
474      *
475      * - the calling contract must have an ETH balance of at least `value`.
476      * - the called Solidity function must be `payable`.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value
484     ) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
490      * with `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(address(this).balance >= value, "Address: insufficient balance for call");
501         require(isContract(target), "Address: call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.call{value: value}(data);
504         return _verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a static call.
510      *
511      * _Available since v3.3._
512      */
513     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
514         return functionStaticCall(target, data, "Address: low-level static call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal view returns (bytes memory) {
528         require(isContract(target), "Address: static call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.staticcall(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a delegate call.
537      *
538      * _Available since v3.4._
539      */
540     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         require(isContract(target), "Address: delegate call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.delegatecall(data);
558         return _verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     function _verifyCallResult(
562         bool success,
563         bytes memory returndata,
564         string memory errorMessage
565     ) private pure returns (bytes memory) {
566         if (success) {
567             return returndata;
568         } else {
569             // Look for revert reason and bubble it up if present
570             if (returndata.length > 0) {
571                 // The easiest way to bubble the revert reason is using memory via assembly
572 
573                 assembly {
574                     let returndata_size := mload(returndata)
575                     revert(add(32, returndata), returndata_size)
576                 }
577             } else {
578                 revert(errorMessage);
579             }
580         }
581     }
582 }
583 
584 /**
585  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
586  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
587  *
588  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
589  *
590  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
591  *
592  * Does not support burning tokens to address(0).
593  */
594 contract ERC721A is
595   Context,
596   ERC165,
597   IERC721,
598   IERC721Metadata,
599   IERC721Enumerable
600 {
601   using Address for address;
602   using Strings for uint256;
603 
604   struct TokenOwnership {
605     address addr;
606     uint64 startTimestamp;
607   }
608 
609   struct AddressData {
610     uint128 balance;
611     uint128 numberMinted;
612   }
613 
614   uint256 private currentIndex = 0;
615 
616   uint256 internal immutable collectionSize;
617   uint256 internal immutable maxBatchSize;
618 
619   // Token name
620   string private _name;
621 
622   // Token symbol
623   string private _symbol;
624 
625   // Mapping from token ID to ownership details
626   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
627   mapping(uint256 => TokenOwnership) private _ownerships;
628 
629   // Mapping owner address to address data
630   mapping(address => AddressData) private _addressData;
631 
632   // Mapping from token ID to approved address
633   mapping(uint256 => address) private _tokenApprovals;
634 
635   // Mapping from owner to operator approvals
636   mapping(address => mapping(address => bool)) private _operatorApprovals;
637 
638   /**
639    * @dev
640    * `maxBatchSize` refers to how much a minter can mint at a time.
641    * `collectionSize_` refers to how many tokens are in the collection.
642    */
643   constructor(
644     string memory name_,
645     string memory symbol_,
646     uint256 maxBatchSize_,
647     uint256 collectionSize_
648   ) {
649     require(
650       collectionSize_ > 0,
651       "ERC721A: collection must have a nonzero supply"
652     );
653     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
654     _name = name_;
655     _symbol = symbol_;
656     maxBatchSize = maxBatchSize_;
657     collectionSize = collectionSize_;
658   }
659 
660   /**
661    * @dev See {IERC721Enumerable-totalSupply}.
662    */
663   function totalSupply() public view override returns (uint256) {
664     return currentIndex;
665   }
666 
667   /**
668    * @dev See {IERC721Enumerable-tokenByIndex}.
669    */
670   function tokenByIndex(uint256 index) public view override returns (uint256) {
671     require(index < totalSupply(), "ERC721A: global index out of bounds");
672     return index;
673   }
674 
675   /**
676    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
677    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
678    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
679    */
680   function tokenOfOwnerByIndex(address owner, uint256 index)
681     public
682     view
683     override
684     returns (uint256)
685   {
686     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
687     uint256 numMintedSoFar = totalSupply();
688     uint256 tokenIdsIdx = 0;
689     address currOwnershipAddr = address(0);
690     for (uint256 i = 0; i < numMintedSoFar; i++) {
691       TokenOwnership memory ownership = _ownerships[i];
692       if (ownership.addr != address(0)) {
693         currOwnershipAddr = ownership.addr;
694       }
695       if (currOwnershipAddr == owner) {
696         if (tokenIdsIdx == index) {
697           return i;
698         }
699         tokenIdsIdx++;
700       }
701     }
702     revert("ERC721A: unable to get token of owner by index");
703   }
704 
705   /**
706    * @dev See {IERC165-supportsInterface}.
707    */
708   function supportsInterface(bytes4 interfaceId)
709     public
710     view
711     virtual
712     override(ERC165, IERC165)
713     returns (bool)
714   {
715     return
716       interfaceId == type(IERC721).interfaceId ||
717       interfaceId == type(IERC721Metadata).interfaceId ||
718       interfaceId == type(IERC721Enumerable).interfaceId ||
719       super.supportsInterface(interfaceId);
720   }
721 
722   /**
723    * @dev See {IERC721-balanceOf}.
724    */
725   function balanceOf(address owner) public view override returns (uint256) {
726     require(owner != address(0), "ERC721A: balance query for the zero address");
727     return uint256(_addressData[owner].balance);
728   }
729 
730   function _numberMinted(address owner) internal view returns (uint256) {
731     require(
732       owner != address(0),
733       "ERC721A: number minted query for the zero address"
734     );
735     return uint256(_addressData[owner].numberMinted);
736   }
737 
738   function ownershipOf(uint256 tokenId)
739     internal
740     view
741     returns (TokenOwnership memory)
742   {
743     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
744 
745     uint256 lowestTokenToCheck;
746     if (tokenId >= maxBatchSize) {
747       lowestTokenToCheck = tokenId - maxBatchSize + 1;
748     }
749 
750     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
751       TokenOwnership memory ownership = _ownerships[curr];
752       if (ownership.addr != address(0)) {
753         return ownership;
754       }
755     }
756 
757     revert("ERC721A: unable to determine the owner of token");
758   }
759 
760   /**
761    * @dev See {IERC721-ownerOf}.
762    */
763   function ownerOf(uint256 tokenId) public view override returns (address) {
764     return ownershipOf(tokenId).addr;
765   }
766 
767   /**
768    * @dev See {IERC721Metadata-name}.
769    */
770   function name() public view virtual override returns (string memory) {
771     return _name;
772   }
773 
774   /**
775    * @dev See {IERC721Metadata-symbol}.
776    */
777   function symbol() public view virtual override returns (string memory) {
778     return _symbol;
779   }
780 
781   /**
782    * @dev See {IERC721Metadata-tokenURI}.
783    */
784   function tokenURI(uint256 tokenId)
785     public
786     view
787     virtual
788     override
789     returns (string memory)
790   {
791     require(
792       _exists(tokenId),
793       "ERC721Metadata: URI query for nonexistent token"
794     );
795 
796     string memory baseURI = _baseURI();
797     return
798       bytes(baseURI).length > 0
799         ? string(abi.encodePacked(baseURI, tokenId.UintToString()))
800         : "";
801   }
802 
803   /**
804    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
805    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
806    * by default, can be overriden in child contracts.
807    */
808   function _baseURI() internal view virtual returns (string memory) {
809     return "";
810   }
811 
812   /**
813    * @dev See {IERC721-approve}.
814    */
815   function approve(address to, uint256 tokenId) public override {
816     address owner = ERC721A.ownerOf(tokenId);
817     require(to != owner, "ERC721A: approval to current owner");
818 
819     require(
820       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
821       "ERC721A: approve caller is not owner nor approved for all"
822     );
823 
824     _approve(to, tokenId, owner);
825   }
826 
827   /**
828    * @dev See {IERC721-getApproved}.
829    */
830   function getApproved(uint256 tokenId) public view override returns (address) {
831     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
832 
833     return _tokenApprovals[tokenId];
834   }
835 
836   /**
837    * @dev See {IERC721-setApprovalForAll}.
838    */
839   function setApprovalForAll(address operator, bool approved) public override {
840     require(operator != _msgSender(), "ERC721A: approve to caller");
841 
842     _operatorApprovals[_msgSender()][operator] = approved;
843     emit ApprovalForAll(_msgSender(), operator, approved);
844   }
845 
846   /**
847    * @dev See {IERC721-isApprovedForAll}.
848    */
849   function isApprovedForAll(address owner, address operator)
850     public
851     view
852     virtual
853     override
854     returns (bool)
855   {
856     return _operatorApprovals[owner][operator];
857   }
858 
859   /**
860    * @dev See {IERC721-transferFrom}.
861    */
862   function transferFrom(
863     address from,
864     address to,
865     uint256 tokenId
866   ) public override {
867     _transfer(from, to, tokenId);
868   }
869 
870   /**
871    * @dev See {IERC721-safeTransferFrom}.
872    */
873   function safeTransferFrom(
874     address from,
875     address to,
876     uint256 tokenId
877   ) public override {
878     safeTransferFrom(from, to, tokenId, "");
879   }
880 
881   /**
882    * @dev See {IERC721-safeTransferFrom}.
883    */
884   function safeTransferFrom(
885     address from,
886     address to,
887     uint256 tokenId,
888     bytes memory _data
889   ) public override {
890     _transfer(from, to, tokenId);
891     require(
892       _checkOnERC721Received(from, to, tokenId, _data),
893       "ERC721A: transfer to non ERC721Receiver implementer"
894     );
895   }
896 
897   /**
898    * @dev Returns whether `tokenId` exists.
899    *
900    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901    *
902    * Tokens start existing when they are minted (`_mint`),
903    */
904   function _exists(uint256 tokenId) internal view returns (bool) {
905     return tokenId < currentIndex;
906   }
907 
908   function _safeMint(address to, uint256 quantity) internal {
909     _safeMint(to, quantity, "");
910   }
911 
912   /**
913    * @dev Mints `quantity` tokens and transfers them to `to`.
914    *
915    * Requirements:
916    *
917    * - there must be `quantity` tokens remaining unminted in the total collection.
918    * - `to` cannot be the zero address.
919    * - `quantity` cannot be larger than the max batch size.
920    *
921    * Emits a {Transfer} event.
922    */
923   function _safeMint(
924     address to,
925     uint256 quantity,
926     bytes memory _data
927   ) internal {
928     uint256 startTokenId = currentIndex;
929     require(to != address(0), "ERC721A: mint to the zero address");
930     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
931     require(!_exists(startTokenId), "ERC721A: token already minted");
932     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
933 
934     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
935 
936     AddressData memory addressData = _addressData[to];
937     _addressData[to] = AddressData(
938       addressData.balance + uint128(quantity),
939       addressData.numberMinted + uint128(quantity)
940     );
941     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
942 
943     uint256 updatedIndex = startTokenId;
944 
945     for (uint256 i = 0; i < quantity; i++) {
946       emit Transfer(address(0), to, updatedIndex);
947       require(
948         _checkOnERC721Received(address(0), to, updatedIndex, _data),
949         "ERC721A: transfer to non ERC721Receiver implementer"
950       );
951       updatedIndex++;
952     }
953 
954     currentIndex = updatedIndex;
955     _afterTokenTransfers(address(0), to, startTokenId, quantity);
956   }
957 
958   /**
959    * @dev Transfers `tokenId` from `from` to `to`.
960    *
961    * Requirements:
962    *
963    * - `to` cannot be the zero address.
964    * - `tokenId` token must be owned by `from`.
965    *
966    * Emits a {Transfer} event.
967    */
968   function _transfer(
969     address from,
970     address to,
971     uint256 tokenId
972   ) private {
973     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
974 
975     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
976       getApproved(tokenId) == _msgSender() ||
977       isApprovedForAll(prevOwnership.addr, _msgSender()));
978 
979     require(
980       isApprovedOrOwner,
981       "ERC721A: transfer caller is not owner nor approved"
982     );
983 
984     require(
985       prevOwnership.addr == from,
986       "ERC721A: transfer from incorrect owner"
987     );
988     require(to != address(0), "ERC721A: transfer to the zero address");
989 
990     _beforeTokenTransfers(from, to, tokenId, 1);
991 
992     // Clear approvals from the previous owner
993     _approve(address(0), tokenId, prevOwnership.addr);
994 
995     _addressData[from].balance -= 1;
996     _addressData[to].balance += 1;
997     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
998 
999     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1000     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1001     uint256 nextTokenId = tokenId + 1;
1002     if (_ownerships[nextTokenId].addr == address(0)) {
1003       if (_exists(nextTokenId)) {
1004         _ownerships[nextTokenId] = TokenOwnership(
1005           prevOwnership.addr,
1006           prevOwnership.startTimestamp
1007         );
1008       }
1009     }
1010 
1011     emit Transfer(from, to, tokenId);
1012     _afterTokenTransfers(from, to, tokenId, 1);
1013   }
1014 
1015   /**
1016    * @dev Approve `to` to operate on `tokenId`
1017    *
1018    * Emits a {Approval} event.
1019    */
1020   function _approve(
1021     address to,
1022     uint256 tokenId,
1023     address owner
1024   ) private {
1025     _tokenApprovals[tokenId] = to;
1026     emit Approval(owner, to, tokenId);
1027   }
1028 
1029   uint256 public nextOwnerToExplicitlySet = 0;
1030 
1031   /**
1032    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1033    */
1034   function _setOwnersExplicit(uint256 quantity) internal {
1035     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1036     require(quantity > 0, "quantity must be nonzero");
1037     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1038     if (endIndex > collectionSize - 1) {
1039       endIndex = collectionSize - 1;
1040     }
1041     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1042     require(_exists(endIndex), "not enough minted yet for this cleanup");
1043     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1044       if (_ownerships[i].addr == address(0)) {
1045         TokenOwnership memory ownership = ownershipOf(i);
1046         _ownerships[i] = TokenOwnership(
1047           ownership.addr,
1048           ownership.startTimestamp
1049         );
1050       }
1051     }
1052     nextOwnerToExplicitlySet = endIndex + 1;
1053   }
1054 
1055   /**
1056    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057    * The call is not executed if the target address is not a contract.
1058    *
1059    * @param from address representing the previous owner of the given token ID
1060    * @param to target address that will receive the tokens
1061    * @param tokenId uint256 ID of the token to be transferred
1062    * @param _data bytes optional data to send along with the call
1063    * @return bool whether the call correctly returned the expected magic value
1064    */
1065   function _checkOnERC721Received(
1066     address from,
1067     address to,
1068     uint256 tokenId,
1069     bytes memory _data
1070   ) private returns (bool) {
1071     if (to.isContract()) {
1072       try
1073         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1074       returns (bytes4 retval) {
1075         return retval == IERC721Receiver(to).onERC721Received.selector;
1076       } catch (bytes memory reason) {
1077         if (reason.length == 0) {
1078           revert("ERC721A: transfer to non ERC721Receiver implementer");
1079         } else {
1080           assembly {
1081             revert(add(32, reason), mload(reason))
1082           }
1083         }
1084       }
1085     } else {
1086       return true;
1087     }
1088   }
1089 
1090   /**
1091    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1092    *
1093    * startTokenId - the first token id to be transferred
1094    * quantity - the amount to be transferred
1095    *
1096    * Calling conditions:
1097    *
1098    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1099    * transferred to `to`.
1100    * - When `from` is zero, `tokenId` will be minted for `to`.
1101    */
1102   function _beforeTokenTransfers(
1103     address from,
1104     address to,
1105     uint256 startTokenId,
1106     uint256 quantity
1107   ) internal virtual {}
1108 
1109   /**
1110    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1111    * minting.
1112    *
1113    * startTokenId - the first token id to be transferred
1114    * quantity - the amount to be transferred
1115    *
1116    * Calling conditions:
1117    *
1118    * - when `from` and `to` are both non-zero.
1119    * - `from` and `to` are never both zero.
1120    */
1121   function _afterTokenTransfers(
1122     address from,
1123     address to,
1124     uint256 startTokenId,
1125     uint256 quantity
1126   ) internal virtual {}
1127 }
1128 
1129 //Behold, I present to you... The Code
1130 contract Code is ERC721A, Ownable {
1131 
1132   using Strings for uint256;
1133 
1134   string[555] internal Codes = [
1135     "LO","FIRST!","PSSST.... PSSST... YOU WANNA MAKE SOME REAL MOTHERFUCKIN MONEY?","HODL","RUB THE SCREEN TO CLAIM YOUR 3 WISHES","APES. TOGETHER. STRONG.","BLESSED BE THY INVESTMENT PORTFOLIO","WILL YOU KEEP ME SAFE?","THERE IS NO 'I' IN WAGMI","A MAN MUST HAVE A CODE","SELL THIS AND BUY YOURSELF A SPACESHIP SON",":)","HOW DO YOU DO FELLOW KIDS?","I CAN DO ANYTHING","I'M THE KING OF THE WORLD!","YOU ARE THE SPECIAL, MOST EXTRAORDINARY PERSON IN THE UNIVERSE!","I LOVE MY MOM","THE FUTURE IS NOW OLD MAN","WHAT IF I TOLD YOU, YOU ARE IN A SIMULATION RIGHT NOW","I'M NOT A QUITTER","THE JOURNEY OF A THOUSAND MILES BEGINS WITH ONE STEP","STOP PAPERING","WHAT AM I WORTH TO YOU?","OH NO SOMETHING WENT WRONG! YOU WEREN'T SUPPOSED TO GET THIS!","YOU KNOW, I'M SOMETHING OF AN NFT MYSELF","I WON'T FUD","GO TOUCH GRASS","WHATEVER YOU CHOOSE TO DO IN LIFE, YOU'LL BE GREAT AT IT","DON'T WORRY! WE ARE TRYING TO GET YOU OUT OF THE SIMULATION","BUY THE DIP","NFT OWNER GETS ALL THE ETH THEY LIST FOR","IF I DIE, DELETE MY BROWSER HISTORY","LETS PUT A SMILE ON THAT FACE","GM","BEFORE DOING ANYTHING, ASK YOURSELF... WOULD AN IDIOT DO THIS?","I WANT US TO BE EXCLUSIVE","BOOM! BIG REVEAL! I TURNED MYSELF INTO AN NFT!","I'VE CAUGHT A BAD CASE OF THE FOMO","WORLD'S BEST DAD!","FORTUNE FAVORS THE BRAVE","I'M AWESOME","THIS NFT WILL GRANT YOU THE POWER OF IMMORTALITY","THIS NFT LOVES YOU","MAY THE FORCE BE WITH YOU","FEAR WILL NOT RULE ME","I CAME BACK FROM THE FUTURE TO TELL MY PAST SELF TO BUY THIS","MO MONEY, MO PROBLEMS","I DON'T UNDERCUT THE FLOOR, I LET THE FLOOR COME TO ME","I AM SATOSHI NAKAMOTO","IT'S ONE SMALL STEP FOR A MAN, ONE GIANT LEAP FOR MANKIND","TODAY IS GOING TO BE A GREAT DAY","LIFE HACK: IF YOU DON'T TRY, YOU CAN'T FAIL... RIGHT? RIGHT???","IT DOESN'T HAPPEN TO EVERY GUY","THIS TEXT IS UNAVAILABLE AT THIS TIME, CHECK BACK LATER","I TOLD YOU SO","WE SHALL OVERCOME","OH YEAH BABY","I BOUGHT THIS NFT AND THEN MY FATHER TOLD ME HE WAS PROUD OF ME","WELCOME TO THE REAL WORLD. IT SUCKS. YOU'RE GONNA LOVE IT.","OH GOSH LOOK AT THE TIME IT'S 4:20 SOMEWHERE","IF YOU HIDE UNDER A BLANKET, THE GHOSTS CAN'T GET TO YOU","BUY LOW, SELL HIGH","ON BEHALF OF THE COMMUNITY, I THANK YOU FOR YOUR PURCHASE","YOU KNOW WHAT MUST BE DONE","DRUGS ARE BAD, MMKAY","NO SACRIFICE, NO VICTORY","FUGAYZI, FUGAZI. IT'S A WHAZY. IT'S A WOOZIE. IT'S FAIRY DUST!","I'M A GAMER GIRL, IF YOU BUY THIS NFT I'LL BE YOUR GIRLFRIEND","I'M A VIRGIN","NICE","WHAT'S THE WORST THAT CAN HAPPEN?","MY STRANGE ADDICTION IS THAT I CAN'T STOP MINTING NFTS","DON'T YOU DARE","YOU CAN'T HANDLE THE TRUTH!","YOU'RE SUCH A GOOD FREN","NEVER GONNA SAY GOODBYE","CARPE DIEM","5G TOWERS SPREAD COVID","WORLD'S BEST MOM!","IT IS NEVER TOO LATE TO BE WHO YOU MIGHT HAVE BEEN","DO THE RIGHT THING","IT'S GLUTEN-FREE","DEEZ NFTS","WE ARE ALL EQUALS","DON'T WORRY, YOU GOT A GOOD ONE","CATCH ME OUTSIDE HOW BOUT THAT","I'M SPEECHLESS","YO, CAN YOU HOLD THIS BAG REAL QUICK? BRB","SEIZE THE DAY","SEND NUDE NFTS","LOOK INSIDE","I AM THE ALPHA MALE","THEY THOUGHT I WAS A JOKE","YOU CAN'T LIVE LIFE WITHOUT A CODE","I AM A SHAPE-SHIFTING LIZARD","I WANT YOU TO DEAL WITH YOUR PROBLEMS BY BECOMING RICH!","FUCK ME! NO I MEAN REALLY. PLEASE FUCK ME. I HAVE MONEY!","ALIENS INVADED THE MOON ON JULY 20TH, 1969","I'M A DEGEN","THIS IS THE WAY","I'M BATMAN","MY FATHER THINKS THIS IS A BAD INVESTMENT","TAKE A CHILL PILL","LOVE YOURSELF","SMOKING KILLS","EXCUSE ME, I'M VEGAN","WHAT IF WE USED 100 PERCENT OF OUR BRAINS?","I ACTUALLY LIKED THE BEE MOVIE","PEACE BE UPON YOU","BROS BEFORE HOES","FINANCIAL ADVICE: BUY THE CODE",":!","MAKE YOUR DREAMS COME TRUE","THIS IS GOING TO 0","I DON'T KNOW WHAT TO DO! MY WHOLE BRAIN IS CRYING!","OMAE WA MOU SHINDERU!","PLACEHOLDER","I BOUGHT THIS NFT FROM AN IDIOT","ROADS? WHERE WE'RE GOING WE DON'T NEED ROADS","STOP PUTTING IT OFF","I AM THE DANGER","TRUE BEAUTY IS ON THE INSIDE","I'M WORTH IT! YOU'LL SEE. YOU'LL ALL SEE!","I LOST MY SEED PHRASE! HAS ANYONE SEEN MY LITTLE PONY NOTEBOOK?","10 OUT OF 10 BEST NFT EVER!","SOMETIMES I START A SENTENCE AND I DON'T KNOW WHERE IT'S GOING","I'M NOT A VAMPIRE I JUST LIKE DRINKING WINE AND GOING OUT LATE","HELP! I'M BEING HELD IN THIS WALLET AGAINST MY WILL!","LOOK ON THE BRIGHT SIDE","ROSEBUD","FUCK! I FAT-FINGERED THE LISTING PRICE! DON'T BUY!","WHEN THE GOING GETS TOUGH, THE TOUGH GET GOING","FLOOR GO BRRR!","SHOW ME THE MONEY!","I'LL BE BACK","I'M A REAL BOY!","SELL IF YOU DON'T WANNA MAKE IT","GLOBAL WARMING IS MELTING THE ABOMINABLE SNOWMAN!","MY PRECIOUS","1X LUCKY NFT: HOLDING THIS ITEM WILL BRING YOU GOOD LUCK","GO AHEAD, MAKE MY DAY","GROUND CONTROL TO MAJOR TOM","YOU HAVE BEEN COMPROMISED PROCEED TO THE EXTRACTION POINT","NFTS, I CHOOSE YOU!","LIVE LONG AND PROSPER!","YOU. SHALL. NOT. PASS!","NO REGRETS","NOT SLEEPING ON THIS","GIRLS DON'T POOP... NOT THE PRETTY ONES","AH SHIT, HERE WE GO AGAIN","EWWW","ALL IS WELL","I HAD BLUE WAFFLES FOR BREAKFAST","OKAY BOOMER","MY STRANGE ADDICTION IS CONSTANTLY CHECKING FLOOR PRICES","YOU ONLY LIVE ONCE, BUT IF YOU DO IT RIGHT, ONCE IS ENOUGH","YOU MISS 100 PERCENT OF THE SHOTS YOU NEVER TAKE","I KNOW I SAID THE WORLD WOULD END TODAY BUT IT'LL END TOMORROW","LIFE IS TOO SHORT","IT ALWAYS SEEMS IMPOSSIBLE UNTIL IT'S DONE","I BOUGHT THIS NFT AND THEN MY DAD LEFT TO GET MILK","SLOW AND STEADY WINS THE RACE","SMELLS LIKE UPDOG IN HERE","YOU KNOW NOTHING","BELIEVE IT!","THIS NFT IS CURSED. YOU WILL BE VISITED BY THE BOOGEYMAN.","HELLO? ANYBODY THERE?","IT'S ALIVE. IT'S ALIVE!","BUYING THIS NFT WILL CHANGE YOUR LIFE, ITS THE BUTTERFLY EFFECT","GOOD PURCHASE!","NEVER GONNA MAKE YOU CRY","THE FUTURE BELONGS TO THOSE WHO PREPARE FOR IT TODAY","THIS GUY FUCKS! AM I RIGHT?","OH FUCK YEAH!","THIS NFT IS AWESOME, CHANGE MY MIND","WHO AM I?","WHAT'S AN ABSURD AMOUNT FOR A PICTURE ON THE INTERNET?","*DICK PIC*","I HAVE NO IDEA WHAT'S GOING ON, BUT I AM EXCITED","LUCKY YOU","JUST DANCE","WHY SO SERIOUS?","BELIEVE IN YOURSELF","I'M CONFUSED... WHEN DO WE GET OUR ICE CREAM?","8 AM - SOMEONE POISONS THE COFFEE","IF I SELL THIS, I'M NGMI","ABOVE ALL ELSE, DON'T FORGET TO HAVE FUN","I GOT LOST IN THE BERMUDA TRIANGLE","DO NOT TOUCH","NEVER GONNA RUN AROUND AND DESERT YOU","YOU ARE NOT ALONE","CAN ANYBODY HEAR ME? OR AM I TALKING TO MYSELF?","WE WILL! WE WILL! ROCK YOU!","MAY THE ODDS BE EVER IN YOUR FAVOR","NOTICE ME SENPAI","GIVE IT YOUR BEST SHOT","EAT MY SHORTS!","SHOUT 'EXIT SIMULATION!' TO EXIT THE SIMULATION","I AM THE HACKERMAN","FUCK! I KNEW I SHOULD HAVE BOUGHT MORE!","CONGRAJA-FUCKING-LATIONS","GET OFF YOUR LAZY ASS!","SIMON SAYS HOLD THIS NFT","I BOUGHT THIS NFT AND NOW I'M BROKE","A HACKER STOLE THIS NFT! DON'T BUY IT!","YOU HAD ME AT NFT","LIVE LIFE TO THE FULLEST","VIOLENCE IS NEVER THE ANSWER","I LIKE TO BE LIKED. I ENJOY BEING LIKED. I HAVE TO BE LIKED!","GUY BUYS THIS NFT... INSTANTLY REGRETS IT!","MATH IS FUN","THIS IS GARBAGE","HEHE THEY DON'T KNOW I OWN A CODE NFT","IF YOU BUY THIS, IT'S THE TOP SIGNAL","I SLAYED THE DRAGON IN THE MOUNTAIN","LMAO SUCKER!","MOM! PLEASE! PLEASE BUY ME THIS NFT! ALL THE COOL KIDS HAVE ONE","ANYTHING CAN HAPPEN","NFTS ARE THE WAVE OF THE FUTURE, THESE THINGS SELL THEMSELVES","NEVER GONNA TELL A LIE AND HURT YOU","I WILL BRING HONOR TO MY FAMILY","MAMA SAYS LIFE IS LIKE A BOX OF CHOCOLATES","XD","WHAT WERE YOU THINKING?","YOU WON'T BELIEVE WHAT THIS NFT CAN DO. IT WILL BLOW YOUR MIND!","NO NO NO ANYTHING BUT THE CONVERTER!","STRIVE FOR GREATNESS, NOT FOR ETH","WITH GREAT ETHEREUM, COMES GREAT SWEEPING RESPONSIBILITY","I WAS WALKING AND THEN SUDDENLY! I TRIPPED ON THE BLOCKCHAIN!","IT'S BIG BRAIN TIME","EVERYBODY BETRAY ME! I'M FED UP WITH THIS WORLD!","THOSE ARE ROOKIE NUMBERS! YOU GOTTA PUMP THOSE NUMBERS UP!","I HAVE UNDERINVESTED... BY A LOT","I'M NOT USUALLY THE BUTT OF THE JOKE, I'M USUALLY THE FACE","I GOT LEFT AT THE ALTER","NOBODY EXISTS ON PURPOSE. EVERYBODY'S GONNA DIE SOMEDAY.","YOU IS KIND. YOU IS SMART. YOU IS IMPORTANT.","WHAT HAPPENED TO THE FLOOR PRICE?","YES LADIES, I OWN THIS NFT. FORM A SINGLE FILE LINE PLEASE.","NOBODY KNOWS IF IT'S GOING UP, DOWN OR FUCKING SIDEWAYS","NEVER GONNA LET YOU DOWN","WE LIVE IN A SOCIETY","TO NFT OR NOT TO NFT?","YO MAMA SO FAT","I'M A WINNER","WHAT ARE YOU DOING STEP-BRO?","A MONSTER LIVES UNDER YOUR BED","I CAN'T FIND MY WALLET AND KEYS","I WANNA BE THE VERY BEST! LIKE NO ONE EVER WAS!","THIS NFT HACKED ME! DON'T SIGN ANY TRANSACTIONS!","YOU ARE MADE OF STUPID","*BADUM TISS*","IT'S OVER! WE HAVE THE HIGH FLOOR!","PLEASE BUY THIS! I HAVE MOUTHS TO FEED!","ACTIONS HAVE CONSEQUENCES","YOU'RE THE RETARDED OFFSPRING OF MONKEYS. CONGRATULATIONS.","NO REFUNDS","BUY THIS NFT. YOU WON'T BELIEVE WHAT HAPPENS NEXT!","WHAT DID IT COST?","DON'T LET YOUR DREAMS BE DREAMS","LEMME SMASH","HOPE YOU HAVE A FANTASTIC DAY FULL OF POSITIVITY AND HAPPINESS","FUCK YOU","FRIENDS DON'T LIE","WINDS HOWLING","IN THE NAME OF THE LORD I COMMAND YOU TO BUY THIS NFT","YOU KEEP DOING YOU","I'VE BEEN BAMBOOZLED","THIS IS GOING TO BE LEGEN-WAIT-FOR-IT-DARY. LEGENDARY!","I'M A GNOME AND YOU'VE BEEN GNOOOMED!","BETTER LATE THAN NEVER","SAVE THE PLANET!","DO MORE","THE PEN IS MIGHTIER THAN THE SWORD","IF (SMART) THEN (HOLD)","THIS IS FINE","YOLO","I KNOW KUNG-FU","NO CHEATING","THE NAME'S BOND, JAMES BOND","WE LIKE TO HAVE FUN AROUND HERE","THE PROPHECY FORETOLD THE COMING OF CRYPTO","SUIT UP!","WANT A BIGGER PEE PEE? BUY THIS","FINALLY! MY GREAT EVIL PLAN IS SET IN MOTION! MUAHA MUAHAHAA!!!","THE END IS NEAR","RAID AREA 51! FREE THE ALIENS!","OKAY GOOGLE, HOW DO I CONVERT BINARY TO ENGLISH?","I SIMP FOR NFTS","UNIVERSAL HEALTHCARE IS A HUMAN RIGHT","LOGIC IS THE BEGINNING OF WISDOM, NOT THE END","WHAT YOU SEE IS WHAT YOU GET","YOU'RE JUST JEALOUS I OWN THIS NFT","FINE! LIST ME BITCH! I DARE YOU! LETS SEE WHAT HAPPENS!","ANYWAY, HOW'S YOUR SEX LIFE?","JUST KEEP SWIMMING","TAKE THE RED PILL, I'LL SHOW YOU HOW DEEP THE RABBIT HOLE GOES","WHEN LIFE GIVES YOU ETH, MINT NFTS","JUST HAVE A LITTLE FAITH","I AM HUMAN","WAIT! DON'T SELL YET, THE FLOOR WILL PUMP A LITTLE HIGHER","THEY SAID I COULDN'T DO IT","IT GOES ON","I AM YOUR FATHER","WHY DID YOU EVEN BUY THIS SHITTY NFT?","I GOT THE VACCINE AND NOW I'M ARTISTIC","THIS SOUNDS LIKE A GET RICH QUICK SCHEME","SAY NO TO DRUGS","I BOUGHT THIS NFT AND NOW I'M SEXY","BUY THIS! IT'S AN EASY 2X","ELEMENTARY, MY DEAR WATSON","RUG PULL! HAHA! YOU JUST GOT RUGGED!","HATERS GONNA HATE","A LION DOESN'T CONCERN HIMSELF WITH THE OPINIONS OF SHEEP","TO THE MOON!","CALL ME DIAMOND HANDS","WE HAVE NOTHING TO FEAR BUT FEAR ITSELF","I'LL JUST BE FIPPIN BURGERS TILL THIS MOONS","HEY BABY, YOU WANNA HAVE A GOOD TIME?","APPRECIATE THE LITTLE THINGS","I'M A BARBIE GIRL, IN THIS BARBIE WORLD!","LIFE IS EITHER A DARING ADVENTURE OR NOTHING AT ALL","SHH! DON'T TELL ON ME TO THE TAXMAN","EASY PEASY, LEMON SQUEEZY","NFT OWNER'S DREAMS COME TRUE!","WINTER IS COMING","I BOUGHT THIS NFT AND NOW I HAVE A BIG PEE PEE","PINEAPPLE BELONGS ON A PIZZA","NEVER GIVE UP","THINK OUTSIDE THE BOX","IT'S JUST A SOCIAL EXPERIMENT BRO","RULE 34: IF IT EXISTS, THERE IS PORN OF IT","WELL, I DON'T MEAN TO BRAG BUT I HAVE KISSED OVER FOUR WOMEN",":'C","LEGALIZE PSYCHEDELICS","YIPPIE-KI-YAY, MOTHERFUCKER!","I AM THE ONE WHO KNOCKS","PLEASE PLEASE PLEASE SOMEONE BUY THIS! I NEED LIQUIDITY NOW!","DREAM BIG AND DARE TO FAIL","THERE'S A LOT OF BEAUTY IN ORDINARY THINGS","WHATCHA GONNA DO TODAY?","LIFE'S WHAT HAPPENS TO YOU WHILE YOU'RE BUSY MAKING OTHER PLANS","PROBABLY NOTHING","I'M NON-FUNGIBLE TOKEN RIIICK!","KNOCK KNOCK","I BOUGHT THIS NFT AND THAT'S HOW I GOT OUT OF THE FRIEND ZONE","THE EARTH IS FLAT","I DRINK AND I KNOW THINGS","HELLO? WHERE AM I? LET ME OUT! OR I'M CALLING THE CYBER POLICE!","THERE'S NO PLACE LIKE HOME","MY MOM SAYS I'M SPECIAL","REPORTING: EVERYTHING'S GOOD, THEY'VE BOUGHT IT","WHERE WERE YOU? YOU WERE LOOKING AT OTHER NFTS, WEREN'T YOU?","I BOUGHT THIS NFT AND NOW I'M ONE OF THE COOL KIDS","NO REST FOR THE WICKED","IT WAS THE BEST OF TIMES, IT WAS THE WORST OF TIMES","LOOK AT THIS ONE, IT'S JUST MARVELOUS. DON'T YOU THINK?","CRYPTOCURRENCY IS A BUBBLE... A BUBBLE-BLOWING PARTY!","SEND DICK PIC NFTS","98 PERCENT OF PEOPLE WON'T GET THIS","HAKUNA MATATA","EH, WHAT'S UP DOC?","WUBBA LUBBA DUB DUB!","THIS MESSAGE HAS TRAVELLED THROUGH SPACE AND TIME TO INFORM YOU","WILL YOU MARRY ME?","I'M HOPELESS AND AWKWARD AND DESPERATE FOR LOVE!","YOU WERE THE CHOSEN ONE!","I'M THANKFUL","TO INFINITY AND BEYOND!","I BOUGHT THIS NFT AND NOW I SEE DEAD PEOPLE","KEEP CALM AND CARRY ON","SHH... IT'S A SECRET","IS THIS AN NFT?","POST-PURCHASE CLARITY HITS HARD","GREETINGS FELLOW HUMANS","PUCK PUCK PAKAAAK","I AM LEGEND","IT WAS AT THIS MOMENT THAT HE KNEW... HE FUCKED UP","IF YOU MULTIPLY A CENTURY, YOU GET A PRETTY NICE MEMBER","OH CAPTAIN! MY CAPTAIN!","YOU'VE BEEN BRAINWASHED","HOW YOU DOIN?","NO LOW BALL OFFERS. I KNOW WHAT I HAVE.","WHY THE FUCK DID THE STUPID CHICKEN CROSS THE ROAD? WHY?","ARE YA WINNIN SON?","DID YOU REMEMBER TO TAKE YOUR MEDS TODAY?","SAY THE MAGIC WORDS","BINGO","ALL POWER TO THE PEOPLE","OKAY BUY THIS, FLIP IT QUICK AND LET THE NEXT GUY HOLD THE BAG","FP THIS LOW IS HIGH-KEY SUS, NO CAP","I'M TOO OLD FOR THIS SHIT","ISN'T THIS KICK-YOU-IN-THE-CROTCH, SPIT-ON-YOUR-NECK FANTASTIC?","FASTEN YOUR SEATBELTS. IT'S GOING TO BE A BUMPY RIDE!","DELIST! DELIST! DELIST!","ARE YOU DUMPING ME?","LIVE AS IF YOU WERE TO DIE TOMORROW","CLASSIFIED","NFT 101 - A SCREENSHOT OF AN NFT DOES NOT MEAN YOU OWN THE NFT","I BOUGHT THIS NFT, THAT'S WHY MY WIFE LEFT ME AND TOOK THE KIDS","THE FLOOR IS LAVA!","*DUN DUN DUUUUUN*","GO FUCK YOURSELF","YO YO YO YO N TO THE F TO THE T YA SEE!",":P","DO NOT BUY THIS! I WILL REGRET SELLING IT TO YOU","REMEMBER... ALL I OFFER YOU IS THE TRUTH. NOTHING MORE.","I HAVE A DREAM","SUCCESS IS NOT FINAL AND FAILURE IS NOT FATAL","DO WHAT YOU LOVE","CLIMATE CHANGE IS REAL!","WAIT A MINUTE, WHO ARE YOU?","TO LIVE IS TO RISK IT ALL","NOT LISTING THIS BELOW FLOOR, PINKY PROMISE","HEY LOOK MA I MADE IT!","WE ARE CLEARED FOR TAKE-OFF","STUPID IS AS STUPID DOES","YOU MATTER","YUM I LIKE EATING BOOGERS","CAN SOMEONE HELP ME? I'M TRYING TO MINT THIS NFT","SMOKE WEED EVERYDAY","I HOPE I MAKE THE NICE LIST THIS CHRISTMAS","1X UNLUCKY NFT: HOLDING THIS ITEM WILL BRING YOU BAD LUCK","YES I CAN","I DESERVE HAPPINESS","OH YEAH, IT'S ALL COMING TOGETHER","I DESERVE BETTER","I'M WATCHING YOU","TIME TO SWEEP THE FLOOR","SHARE THIS WITH 5 PEOPLE OR YOU WILL HAVE BAD LUCK","I BOUGHT THIS NFT AND THEN I FOUND TRUE LOVE","HELLO? RICH PEOPLE? I'LL BE JOINING YOU... YES, I'LL HOLD.","BY OWNING THIS NFT I HEREBY ACCEPT THE HARVEST OF MY ORGANS","I'VE COME FROM THE FUTURE TO WARN YOU THE WORLD WILL END ON THE","ALIENS ARE STEALING OUR COWS GOD DAMN IT!","EAT SLEEP NFT REPEAT","THAT'S WHAT SHE SAID","DON'T WASTE A SINGLE DAY","HELP! HELP! THIS PSYCHO TRAPPED ME IN HIS SHITTY WALLET! EWWW!","I'M PREGNANT","UWU","ARE YOU FROM TENNESSEE? BECAUSE YOU ARE THE ONLY 10 I SEE","I APED IN","I AM THE GOAT",":(","TODAY, I CONSIDER MYSELF THE LUCKIEST MAN ON THE FACE OF EARTH","HURRY UP AND LIST! BEFORE THE FLOOR CRASHES!","LIKE TAKING CANDY FROM A BABY","FAKE IT TILL YOU MAKE IT","WHO'S A GOOD BOY? YOU! YES YOU ARE! YOU'RE A GOOD BOY!","DON'T, EVER, FOR ANY REASON, DO ANYTHING, TO ANYONE, WHATSOEVER","YOU CRACKED THE CODE","HELLO WORLD","I BOUGHT THIS NFT AND THEN, I LOST MY VIRGINITY","THE FBI IS MONITORING YOU","JUST DO IT!","I WANT PEOPLE TO BE AFRAID OF HOW MUCH THEY LOVE ME","ONLY GOOD VIBES","C'MON DO IT! SIGN THAT TRANSACTION. SEE WHAT HAPPENS!","I LOVE YOU","TAKE PROFITS","MODERN PROBLEMS REQUIRE MODERN SOLUTIONS","YOU MUST BE THE CHANGE YOU WISH TO SEE IN THE WORLD","THE ILLUMINATI CONTROL THE WORLD ORDER","COME ON BARBIE LETS GO PARTY!","I'M FOREVER 21","BEAUTY IS IN THE EYE OF THE BEHOLDER","I EAT RAINBOWS AND POOP BUTTERFLIES","THE AVOCADO TASTE IS ABSENT... FALSE, I'LL JUST ADD SOME HONEY","NOOO, YOU'RE AN NFT","DO OR DO NOT. THERE IS NO TRY.","THE FIRST RULE OF NFT CLUB: YOU TALK ABOUT NFT CLUB","NO, YOU DON'T LOVE ME, YOU'RE JUST GONNA SELL ME OFF TO SOMEONE","BACK IN MY DAY, WE USED TO HAVE GOOD OLD-FASHIONED PAINTINGS","*PLOP* *PLOP* *FLUSH*","THIS IS MY LIFE!","DO SOMETHING THAT MAKES YOU FEEL ALIVE","DINOSAURS NEVER EXISTED","WHEN YOU PLAY THE GAME OF NFTS YOU EITHER WIN OR YOU GO TO 0","BE YOURSELF","*FART*","WITCHES KIDNAP KIDS AND COOK EM IN A BIG STEW","YOU'RE PERFECT","I... DECLARE... BANKRUPTCY!","OH. MY. GOD.","I GOT THIS","YOU TALKIN' TO ME?","CROP CIRCLES ARE MADE BY ALIENS","I'M A 1 OF 1","OK OK OK I NEED THE PRICE TO GO UP","SHOOT FOR THE STARS","I AM FREE","AGH! YOU DON'T GET IT DAD! THIS IS A FINANCIAL ASSET!","KNOWLEDGE IS POWER","LET IT GO","I BOUGHT THIS NFT AND NOW I'M IRRESISTIBLE TO WOMEN","BACK IN MY DAY, WE DIDN'T HAVE NFTS","ACTIONS SPEAK LOUDER THAN WORDS","SEX IS GREAT BUT HAVE YOU EVER MINTED A RARE NFT?","HELLO DARKNESS MY OLD FRIEND","01000011 01001111 01000100 01000101","WHEN I GET SAD, I STOP BEING SAD AND BE AWESOME INSTEAD","I MARRIED A PFP NFT","MY DAD MADE HIS FACE WINK, JUST FOR A BRIEF SECOND","IF I LIST THIS, I'VE GONE CRAZY! SEND ME TO A PSYCH WARD","IT IS FORETOLD THAT CRYPTO SHALL REACH THE HEAVENS!","WHETHER YOU THINK YOU CAN OR YOU THINK YOU CAN'T, YOU'RE RIGHT","I LIKE BIG BUTTS AND I CAN NOT LIE","STOP FRIVOLOUS SPENDING! CUT IT TO JUST WATER, BREAD AND NFTS!","LEARN FROM YOUR MISTAKES","HOW MUCH DO YOU THINK THIS IS WORTH?","YOU HAVE SOMETHING IN YOUR TEETH","DO YOU HAVE ANY IDEA WHO YOU'RE TALKING TO?","WAKE UP","GIRLS HAVE COOTIES","IT'S A WONDERFUL LIFE","NOTHING TO SEE HERE, MOVE ALONG","I SAW BIGFOOT","DON'T SELL ME... PRETTY PLEASE?","YEAH, SCIENCE!","SPEAK YOUR MIND","WHY ARE YOU THE WAY THAT YOU ARE?","DON'T BE AN IDIOT","FACE YOUR FEARS","I LIKE YOU, YOU'RE COOL","BUY AND HOLD THIS NFT. GOD WILLS IT!","I AM INEVITABLE","I'M ON TOP OF THE WORLD!","DO WHAT YOU CAN'T","OH NO NO NO NO, THIS IS DEFINITELY NOT A RUG PULL! TRUST ME!","STONKS","THERE ARE ALWAYS A MILLION REASONS NOT TO DO SOMETHING","SIZE DOESN'T MATTER","LEGALIZE MARIJUANA","SAVE LOCH NESS FROM THIS MONSTROUS POLLUTING!","HOLD ME","IT'S ALL FAKE NEWS","MY DAD IS MY HERO","YOU'RE BEAUTIFUL","VALAR MORGHULIS","I BOUGHT THIS NFT AND THAT'S WHY MY GIRLFRIEND DUMPED ME","LIFE IS GOOD","THE MOON LANDING WAS FAKE","GONNA TELL MY KIDS THIS IS CRYPTOPUNKS","ASTALA VISTA, BABY!","DON'T PANIC! WAGMI!","I SHIT THE BED","NEVER GONNA GIVE YOU UP","I HAVE A GIRLFRIEND! SHE JUST GOES TO A DIFFERENT METAVERSE","AH, I SEE YOU ARE A MAN OF CULTURE","WHAZAAA","IT'S SIMPLE PONZINOMICS, MORE PEOPLE INVEST, MORE MONEY WE MAKE","LEPRECHAUNS CONTROL THE SUPPLY OF GOLD","THE DUDE ABIDES","*-*"
1136   ];
1137 
1138   string internal URIStart = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 2000 2000'><style>@font-face{font-family:'font';src:url(data:application/font-woff2;charset=utf-8;base64,d09GMgABAAAAAAcQAA8AAAAAFYAAAAa2AAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP0ZGVE0cGh4bdBxABmAAgnIRCAqXSJAoC24AATYCJAOBWAQgBYcIB4EkG20QUVRympB9eWCToasY/oO5Gk+G2eowOyWatqb50k0heNr4Dwh3TA48Wi4jqN8P3bv3AwgSUZFDmYlOysZXkiw7GRCqLHSnNnC01ubFfN8FUzl79RKxkDRkMs1DJVSi8bzt3v5dhEPP04A0w3S+715fybLlF/kqsfPe/52Id7PyMSZNjmBbwCbjY0KafmyVz9f/2t7doVoT19WEUuoiTPRC8HXi37jYChnISHnwK+Xdt3xns0l3eVGJTjad0pRAODRC7c3O/ntzcyWlLUtrKaXsHXRheDEKYWu3GAsOhezGIzTGKK6xFfHjReFwpY26Ii5xVf9PDAE/XucA/Pz/GPydHnhFQzN6gRRYRVMhEWi0axljf3J+HZSnUUwDuiflLAQw4fEfk22Ml1gxC1wmTSrJwUSnIJpZkgXe0TsGK8w1nrsTFWZXNb15woq6f1hxEMuPLh/gkYNsqm0gjvyG/iYgffFnGyEagvqH7R/SS12gboCvgHJXLoBxdBQUDKOBVxgCw5hOgXZSDDDCyqfXbv/8q3RH3AIGex+/Ft/4pnqAhnWLWsLxRyI1lMpTa2rr6jU0NjW3tLa94U8D+N37v89qszucLrfH6/MHgqFwJBqLJ0D8rUI8sgFrAK+AA1DOAco/AupBAlKwNA9GuiIp0ngrWRXFFalIHWVRtsBuBbKdPat9SaLjqq61GX3yAiyYYB3AWV22kM8t63bJZyf05Ww/mR95xS7mvYOdUT0gfs1q48ZORqaNGoGNuHGrxsZOjZoaGYWxE8H2R4HbA4hH52HKSeO4WTwZcTLLo/er+7sKfVTBY3LacuVaA6JNpaQ5DFJryd2Bcy5g6igEuriRJch6vAG/1ryw15k+adOHHnUdvM2jXyIwajNGudR5zk4O0qPBR3ds0qSHbgzzus4Ecj6QPGAqEo2FZ6qcvNAShETa9qKADvrGrGtpwT7ZrykECXX0jgtC3vcFku8Ce6cHY+rsRAGlPI/2eGO6KCtx+D6xToOu5FRGaD7wrS7GG+2jQPEgz158H8aD6Brq3GIy8m+Wp7bi2OENARNBOLFsST13GnQ18sb6PWpQO6YIj0Bc8T0kknLutafwRVv01HFbkN5JK1BrD+8pvbrVxjNQ/xr4F/SF1H0FnmmbrtnKJ5dQHRcTK0E+PFuydMuq5yZuoVNLpzwKb8mlQUMFy8XMoucysoxid/dl7jxPPoIGvYb2r4tm/5fKJ3lOkOhFjfb3DWitOIJgYRIpylU1Cj8qpVriJ/R1mag/02P20ANSYxClJHoUbiOw6zj+N61nY1ykosMYBkqzHOr7DQwF92MkoPI3OI6GOVwgZKH9J2bqoa39a7hgjBj1sAjvklMzA+8Mjud9jUMMYxyN2uPyHxapF005rIiMxAvJbImeEM68/Id2rhh52ahTHwqmfUbMdVgDrqBw9GT2VLre1i7tDI9aAtIlneXTmYKC+uMBCDa9Iq7Pkpp3x9HVj7diQW1o6NGzIZk+8ONvq4QD69ykPqvndO7nXYRVAOYaOsPPvHPBNDnKDGu0WXZW4fM6rnyaISLqaWXhjdX/+3G20PG4z5RSQs+4u+y8uROAvjM7dPKvrl/oF3ev2kGX/iLWdYydmgF0TOtJpzEWMOK0tu/MYPuboCn1AAGF3bDIynudynp1EDX01YXvfPhG1iNJ/+cK6mb+8z4dHhN6zLpAUy81FtTNDEkLVC27AI2gNeijAPICoCwcMIvv5HB1VdQcoDeCG50bxAxWSMFhFV0XB0iBiR8jsMaIAYJ4U7tnDFE1YBJkMgyyyVRvRxYbxmVlWlvWqPVN1pp0Kxs0upLNJn3Klpj0LVutRS2vqDMvr0VyKm9w833LLXF+eMV3gcHce4DERGQSTEajkKn4U0fllC2j1GHScijnkDUnskptNu0cfmxIXN/uSJ9OKUqD9FqN3gFNrtPMTlxLKscd80p6hQXBp8rRkCxsMr6ORCGISZdVRlWJwDfXnCjCoFZKM3EGSIy5RxVG55koAmdMc+2MeciSPMw3evu8tgjwJqcS4xzMRYUkI6cKMUuO2BNVbinpiTgFpauhXIAWwHQjVjJVFb25Z2J2yZkiakll5kJKhv4UITlFhLAlk+Y1lm/BnMKDhnAqIqMVyMiOCQV3044dekUkTneI3IEBtSlYLPJ4hhQTFe8q2YIK4+LyB6bRgUc3XRFf5RqIjKKoNGrSrEWbdjJyCkoqahpaOnoGRiZWNnYOTi5uHl4+fgFBIWERUTFxCR06denWo1effgPFrH2abuTJ6H5tjFPJUrGOyTE=) format('woff2')}</style><rect width='100%' height='100%'/><defs><filter id='filter' x='0' y='0' width='100%' height='100%'><feGaussianBlur result='blurOut' stdDeviation='5'/><feBlend in='SourceGraphic' in2='blurOut' mode='multiply'/></filter><mask id='mask'><rect width='100%' height='100%' fill='#fff' fill-opacity='.90'/><rect x='-15%' width='15%' height='100%' fill='#fff' transform='skewX(-10)'><animate attributeName='x' from='-15%' to='115%' dur='10s' repeatCount='indefinite'/></rect></mask></defs>";
1139 
1140   mapping(uint256 => bool) public isDecoded;
1141 
1142   mapping(bytes1 => string) BinaryMap;
1143   function SetMapping() internal {
1144 
1145     BinaryMap [0x20] = "00100000 " ; //Space
1146     BinaryMap [0x21] = "00100001 " ; //!
1147     BinaryMap [0x27] = "00100111 " ; //'
1148     BinaryMap [0x28] = "00101000 " ; //(
1149     BinaryMap [0x29] = "00101001 " ; //)
1150     BinaryMap [0x2A] = "00101010 " ; //*
1151     BinaryMap [0x2C] = "00101100 " ; //,
1152     BinaryMap [0x2D] = "00101101 " ; //-
1153     BinaryMap [0x2E] = "00101110 " ; //.
1154     BinaryMap [0x3A] = "00111010 " ; //:
1155     BinaryMap [0x3F] = "00111111 " ; //?
1156     
1157     BinaryMap [0x41] = "01000001 " ;//A
1158     BinaryMap [0x42] = "01000010 " ;//B
1159     BinaryMap [0x43] = "01000011 " ;//C
1160     BinaryMap [0x44] = "01000100 " ;//D
1161     BinaryMap [0x45] = "01000101 " ;//E
1162     BinaryMap [0x46] = "01000110 " ;//F
1163     BinaryMap [0x47] = "01000111 " ;//G
1164     BinaryMap [0x48] = "01001000 " ;//H
1165     BinaryMap [0x49] = "01001001 " ;//I
1166     BinaryMap [0x4A] = "01001010 " ;//J
1167     BinaryMap [0x4B] = "01001011 " ;//K
1168     BinaryMap [0x4C] = "01001100 " ;//L
1169     BinaryMap [0x4D] = "01001101 " ;//M
1170     BinaryMap [0x4E] = "01001110 " ;//N
1171     BinaryMap [0x4F] = "01001111 " ;//O
1172     BinaryMap [0x50] = "01010000 " ;//P
1173     BinaryMap [0x51] = "01010001 " ;//Q
1174     BinaryMap [0x52] = "01010010 " ;//R
1175     BinaryMap [0x53] = "01010011 " ;//S
1176     BinaryMap [0x54] = "01010100 " ;//T
1177     BinaryMap [0x55] = "01010101 " ;//U
1178     BinaryMap [0x56] = "01010110 " ;//V
1179     BinaryMap [0x57] = "01010111 " ;//W
1180     BinaryMap [0x58] = "01011000 " ;//X
1181     BinaryMap [0x59] = "01011001 " ;//Y
1182     BinaryMap [0x5A] = "01011010 " ;//Z
1183 
1184     BinaryMap [0x30] = "00110000 " ;//0
1185     BinaryMap [0x31] = "00110001 " ;//1
1186     BinaryMap [0x32] = "00110010 " ;//2
1187     BinaryMap [0x33] = "00110011 " ;//3
1188     BinaryMap [0x34] = "00110100 " ;//4
1189     BinaryMap [0x35] = "00110101 " ;//5
1190     BinaryMap [0x36] = "00110110 " ;//6
1191   //BinaryMap [0x37] = "00110111 " ;//7
1192     BinaryMap [0x38] = "00111000 " ;//8
1193     BinaryMap [0x39] = "00111001 " ;//9
1194   }
1195 
1196   constructor() ERC721A("THE CODE", "CODE", 10, 555) {
1197     SetMapping();
1198   }
1199 
1200   bool public mintingEnabled;
1201   function ToggleMinting() external onlyOwner {
1202     mintingEnabled = !mintingEnabled;
1203   }
1204 
1205   mapping(address => uint8) addressMinted;
1206   function mint() external payable{
1207     require(mintingEnabled, "Wait for it");
1208     require(msg.value == 55500000000000000, "Mint price for The Code");
1209     require(addressMinted[_msgSender()] < 1 ,"Hey no refills");
1210     require(totalSupply() + 1 <= collectionSize, "Sold out!");
1211     addressMinted[_msgSender()]++;
1212     _safeMint(_msgSender(), 1); 
1213   }
1214 
1215   function TheCodeMints(uint mintAmount) external onlyOwner{
1216     require(totalSupply() + mintAmount <= collectionSize, "Not enough supply");
1217     _safeMint(_msgSender(), mintAmount);
1218   }
1219 
1220   function Decode(uint256 tokenId, string memory DecodedMessage) external{
1221     require(ownerOf(tokenId) == _msgSender(),"You don't own this code");
1222     require(!isDecoded[tokenId],"You already have the Decoded message");
1223     require(keccak256(bytes(DecodedMessage)) == keccak256(bytes(Codes[tokenId])), "Decoded input is incorrect");
1224     isDecoded[tokenId] = true;
1225   }
1226 
1227   function Encode(uint256 tokenId) external{
1228     require(ownerOf(tokenId) == _msgSender(),"You don't own this code");
1229     require(isDecoded[tokenId],"You already have the Encoded message");
1230     isDecoded[tokenId] = false;
1231   }
1232 
1233   mapping(uint256 => string) Color;
1234   function TextColor(uint256 tokenId, string memory color) external {
1235     require(ownerOf(tokenId) == _msgSender());
1236     Color[tokenId] = color;
1237   }
1238 
1239   function getCode(uint256 tokenId) public view returns (string memory) {
1240     require(isDecoded[tokenId],"First, you must decode your code");
1241     return Codes[tokenId];
1242   }
1243 
1244   function HexToBinary(bytes memory BytesData) private view returns (string[] memory) {
1245     uint pointer;
1246     uint inc;
1247     string[] memory Binary = new string[](21);
1248     while (pointer < BytesData.length){
1249       for (uint three = 0; three < 3 ; three++) {
1250         if (pointer < BytesData.length){
1251           Binary[inc]  =  string(abi.encodePacked (Binary[inc] , BinaryMap[BytesData[pointer]]));                      
1252           pointer++;  
1253           }
1254         }
1255         inc++;
1256     }
1257     return Binary;
1258   }
1259 
1260   function HexToEnglish(bytes calldata BytesData) public pure returns(string[] memory){
1261     uint counter;
1262     uint pointerFrom;
1263     uint pointerTill = 22;
1264     bytes memory MemoryData = BytesData;
1265     string[] memory English = new string[](3);
1266     bytes memory temp;
1267 
1268     uint remaining = BytesData.length;
1269     while (remaining > 22){
1270       while (MemoryData[pointerTill] != hex"20" && BytesData.length -1 > pointerTill){
1271         pointerTill++;
1272       }
1273       if (MemoryData[pointerTill] == hex"20"){
1274         temp = BytesData[pointerFrom:pointerTill];
1275         English[counter] = string(temp);
1276         remaining = BytesData.length - pointerTill;
1277         pointerFrom = pointerTill +1;
1278         pointerTill+=20;
1279         counter++;
1280       }else {               
1281         remaining = 3;
1282       }  
1283     }
1284     if (remaining > 0){
1285       temp = BytesData[pointerFrom:BytesData.length];
1286       English[counter] = string(temp);
1287     }
1288     return(English);
1289   }
1290 
1291   function tokenURI(uint256 tokenId) override public view returns (string memory) {
1292     string memory output;
1293     string[22] memory parts;
1294   
1295     if (!isDecoded[tokenId]){
1296       string[] memory Binary = HexToBinary(bytes(Codes[tokenId]));
1297       string memory json;
1298       if (keccak256(bytes(Color[tokenId])) == keccak256(bytes(""))){
1299         parts[0] = "<text x='6%' y='8%' style='fill:#0f0;font-family:font;font-size:64px;letter-spacing:.32em;text-anchor:left' mask='url(#mask)' filter='url(#filter)'>";
1300       }else{
1301         parts[0] =string(abi.encodePacked("<text x='6%' y='8%' style='fill:", Color[tokenId], ";font-family:font;font-size:64px;letter-spacing:.32em;text-anchor:left' mask='url(#mask)' filter='url(#filter)'>"));
1302       }
1303         parts[1] =  string(abi.encodePacked( Binary[0] , "<tspan x='6%' dy='1.35em'>"));
1304       for (uint i2 = 1 ; i2<21; i2++){
1305         parts[i2+1] = string(abi.encodePacked( Binary[i2] , "</tspan><tspan x='6%' dy='1.35em'>"));
1306       }
1307       
1308       output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
1309       output = string(abi.encodePacked(output, parts[8], parts[9], parts[10], parts[11], parts[12], parts[13]));
1310       output = string(abi.encodePacked(output, parts[14], parts[15], parts[16], parts[17], parts[18], parts[19]));
1311       output = string(abi.encodePacked(URIStart, output, parts[20], parts[21], "</tspan></text></svg>"));
1312      
1313       json = Base64.encode(bytes(abi.encodePacked('{"name": "CODE #', tokenId.UintToString(), '", "attributes": [{"trait_type": "State","value":"Encoded"} , {"trait_type": "Color","value":"',Color[tokenId],'"}], "description": "The Code speaks to you, it speaks for you, it speaks for itself, its meaning is open to interpretation. Never be speechless with this in your wallet.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}')));
1314       output = string(abi.encodePacked("data:application/json;base64,", json));
1315     }
1316     else if (isDecoded[tokenId]){
1317       string[] memory English = this.HexToEnglish(bytes(Codes[tokenId]));
1318       string memory json;
1319       if (keccak256(bytes(Color[tokenId])) == keccak256(bytes(""))){
1320         parts[1] = "<text x='50%' y='47%' style='fill:#0f0;font-family:font;font-size:85px;text-anchor:middle' mask='url(#mask)' filter='url(#filter)'>";
1321       }else{
1322         parts[1] = string(abi.encodePacked("<text x='50%' y='47%' style='fill:", Color[tokenId], ";font-family:font;font-size:85px;text-anchor:middle' mask='url(#mask)' filter='url(#filter)'>"));
1323       }
1324       parts[2] =  string(abi.encodePacked( English[0] , "<tspan x='50%' dy='1.3em'>"));
1325       parts[3] =  string(abi.encodePacked( English[1] , "</tspan><tspan x='50%' dy='1.3em'>"));
1326       parts[4] =  string(abi.encodePacked( English[2] , "</tspan></text></svg>"));            
1327       output = string(abi.encodePacked(URIStart, parts[1], parts[2], parts[3], parts[4]));
1328     
1329       json = Base64.encode(bytes(abi.encodePacked('{"name": "CODE #', tokenId.UintToString(), '", "attributes": [{"trait_type": "State","value":"Decoded"} , {"trait_type": "Color","value":"',Color[tokenId],'"}], "description": "The Code speaks to you, it speaks for you, it speaks for itself, its meaning is open to interpretation. Never be speechless with this in your wallet.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}')));
1330       output = string(abi.encodePacked("data:application/json;base64,", json)); 
1331     }
1332     return output;
1333   }
1334 
1335   function withdraw() external onlyOwner {
1336     bool success = payable(_msgSender()).send(address(this).balance);
1337     require(success, "Payment did not go through!");
1338   }
1339 }
1340 
1341 /// [MIT License]
1342 /// @title Base64
1343 /// @notice Provides a function for encoding some bytes in base64
1344 /// @author Brecht Devos <brecht@loopring.org>
1345 library Base64 {
1346     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1347     /// @notice Encodes some bytes to the base64 representation
1348     function encode(bytes memory data) internal pure returns (string memory) {
1349         uint256 len = data.length;
1350         if (len == 0) return "";
1351         // multiply by 4/3 rounded up
1352         uint256 encodedLen = 4 * ((len + 2) / 3);
1353         // Add some extra buffer at the end
1354         bytes memory result = new bytes(encodedLen + 32);
1355         bytes memory table = TABLE;
1356         assembly {
1357             let tablePtr := add(table, 1)
1358             let resultPtr := add(result, 32)
1359             for {
1360                 let i := 0
1361             } lt(i, len) {
1362             } {
1363                 i := add(i, 3)
1364                 let input := and(mload(add(data, i)), 0xffffff)
1365 
1366                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1367                 out := shl(8, out)
1368                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1369                 out := shl(8, out)
1370                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1371                 out := shl(8, out)
1372                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1373                 out := shl(224, out)
1374                 mstore(resultPtr, out)
1375                 resultPtr := add(resultPtr, 4)
1376             }
1377             switch mod(len, 3)
1378             case 1 {
1379                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1380             }
1381             case 2 {
1382                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1383             }
1384             mstore(result, encodedLen)
1385         }
1386         return string(result);
1387     }
1388 }