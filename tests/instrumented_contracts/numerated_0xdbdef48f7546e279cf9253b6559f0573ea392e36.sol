1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-15
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11                                                                                                                                                                                                            
12                                                                                                                                                                                                            
13 
14 //             __     __                    ______                                                             __   
15 //            /  |   /  |                  /      \                                                          _/  |  
16 //  __     __ $$ |   $$ | __     __       /$$$$$$  |  ______    ______    _______   ______   _______        / $$ |  
17 // /  \   /  |$$ |   $$ |/  \   /  |      $$ \__$$/  /      \  /      \  /       | /      \ /       \       $$$$ |  
18 // $$  \ /$$/ $$  \ /$$/ $$  \ /$$/       $$      \ /$$$$$$  | $$$$$$  |/$$$$$$$/ /$$$$$$  |$$$$$$$  |        $$ |  
19 //  $$  /$$/   $$  /$$/   $$  /$$/         $$$$$$  |$$    $$ | /    $$ |$$      \ $$ |  $$ |$$ |  $$ |        $$ |  
20 //   $$ $$/     $$ $$/     $$ $$/         /  \__$$ |$$$$$$$$/ /$$$$$$$ | $$$$$$  |$$ \__$$ |$$ |  $$ |       _$$ |_ 
21 //    $$$/       $$$/       $$$/          $$    $$/ $$       |$$    $$ |/     $$/ $$    $$/ $$ |  $$ |      / $$   |
22 //     $/         $/         $/            $$$$$$/   $$$$$$$/  $$$$$$$/ $$$$$$$/   $$$$$$/  $$/   $$/       $$$$$$/ 
23 
24 pragma solidity ^0.8.0;
25 
26 /*
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _setOwner(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _setOwner(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _setOwner(newOwner);
103     }
104 
105     function _setOwner(address newOwner) private {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 /**
113  * @dev Interface of the ERC165 standard, as defined in the
114  * https://eips.ethereum.org/EIPS/eip-165[EIP].
115  *
116  * Implementers can declare support of contract interfaces, which can then be
117  * queried by others ({ERC165Checker}).
118  *
119  * For an implementation, see {ERC165}.
120  */
121 interface IERC165 {
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30 000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 }
132 
133 /**
134  * @dev Required interface of an ERC721 compliant contract.
135  */
136 interface IERC721 is IERC165 {
137     /**
138      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
144      */
145     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
149      */
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of tokens in ``owner``'s account.
154      */
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
168      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external;
185 
186     /**
187      * @dev Transfers `tokenId` token from `from` to `to`.
188      *
189      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must be owned by `from`.
196      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external;
205 
206     /**
207      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
208      * The approval is cleared when the token is transferred.
209      *
210      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
211      *
212      * Requirements:
213      *
214      * - The caller must own the token or be an approved operator.
215      * - `tokenId` must exist.
216      *
217      * Emits an {Approval} event.
218      */
219     function approve(address to, uint256 tokenId) external;
220 
221     /**
222      * @dev Returns the account approved for `tokenId` token.
223      *
224      * Requirements:
225      *
226      * - `tokenId` must exist.
227      */
228     function getApproved(uint256 tokenId) external view returns (address operator);
229 
230     /**
231      * @dev Approve or remove `operator` as an operator for the caller.
232      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
244      *
245      * See {setApprovalForAll}
246      */
247     function isApprovedForAll(address owner, address operator) external view returns (bool);
248 
249     /**
250      * @dev Safely transfers `tokenId` token from `from` to `to`.
251      *
252      * Requirements:
253      *
254      * - `from` cannot be the zero address.
255      * - `to` cannot be the zero address.
256      * - `tokenId` token must exist and be owned by `from`.
257      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
258      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
259      *
260      * Emits a {Transfer} event.
261      */
262     function safeTransferFrom(
263         address from,
264         address to,
265         uint256 tokenId,
266         bytes calldata data
267     ) external;
268 }
269 /**
270  * @title ERC721 token receiver interface
271  * @dev Interface for any contract that wants to support safeTransfers
272  * from ERC721 asset contracts.
273  */
274 interface IERC721Receiver {
275     /**
276      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
277      * by `operator` from `from`, this function is called.
278      *
279      * It must return its Solidity selector to confirm the token transfer.
280      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
281      *
282      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
283      */
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 interface IERC721Metadata is IERC721 {
293     /**
294      * @dev Returns the token collection name.
295      */
296     function name() external view returns (string memory);
297 
298     /**
299      * @dev Returns the token collection symbol.
300      */
301     function symbol() external view returns (string memory);
302 
303     /**
304      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
305      */
306     function tokenURI(uint256 tokenId) external view returns (string memory);
307 }
308 /**
309  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
310  * @dev See https://eips.ethereum.org/EIPS/eip-721
311  */
312 interface IERC721Enumerable is IERC721 {
313     /**
314      * @dev Returns the total amount of tokens stored by the contract.
315      */
316     function totalSupply() external view returns (uint256);
317 
318     /**
319      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
320      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
321      */
322     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
323 
324     /**
325      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
326      * Use along with {totalSupply} to enumerate all tokens.
327      */
328     function tokenByIndex(uint256 index) external view returns (uint256);
329 }
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize, which returns 0 for contracts in
354         // construction, since the code is only stored at the end of the
355         // constructor execution.
356 
357         uint256 size;
358         assembly {
359             size := extcodesize(account)
360         }
361         return size > 0;
362     }
363 
364     /**
365      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
366      * `recipient`, forwarding all available gas and reverting on errors.
367      *
368      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
369      * of certain opcodes, possibly making contracts go over the 2300 gas limit
370      * imposed by `transfer`, making them unable to receive funds via
371      * `transfer`. {sendValue} removes this limitation.
372      *
373      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
374      *
375      * IMPORTANT: because control is transferred to `recipient`, care must be
376      * taken to not create reentrancy vulnerabilities. Consider using
377      * {ReentrancyGuard} or the
378      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
379      */
380     function sendValue(address payable recipient, uint256 amount) internal {
381         require(address(this).balance >= amount, "Address: insufficient balance");
382 
383         (bool success, ) = recipient.call{value: amount}("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388      * @dev Performs a Solidity function call using a low level `call`. A
389      * plain `call` is an unsafe replacement for a function call: use this
390      * function instead.
391      *
392      * If `target` reverts with a revert reason, it is bubbled up by this
393      * function (like regular Solidity function calls).
394      *
395      * Returns the raw returned data. To convert to the expected return value,
396      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397      *
398      * Requirements:
399      *
400      * - `target` must be a contract.
401      * - calling `target` with `data` must not revert.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411      * `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, 0, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but also transferring `value` wei to `target`.
426      *
427      * Requirements:
428      *
429      * - the calling contract must have an ETH balance of at least `value`.
430      * - the called Solidity function must be `payable`.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(address(this).balance >= value, "Address: insufficient balance for call");
455         require(isContract(target), "Address: call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.call{value: value}(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
468         return functionStaticCall(target, data, "Address: low-level static call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal view returns (bytes memory) {
482         require(isContract(target), "Address: static call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.staticcall(data);
485         return _verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(isContract(target), "Address: delegate call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.delegatecall(data);
512         return _verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     function _verifyCallResult(
516         bool success,
517         bytes memory returndata,
518         string memory errorMessage
519     ) private pure returns (bytes memory) {
520         if (success) {
521             return returndata;
522         } else {
523             // Look for revert reason and bubble it up if present
524             if (returndata.length > 0) {
525                 // The easiest way to bubble the revert reason is using memory via assembly
526 
527                 assembly {
528                     let returndata_size := mload(returndata)
529                     revert(add(32, returndata), returndata_size)
530                 }
531             } else {
532                 revert(errorMessage);
533             }
534         }
535     }
536 }
537 
538 
539 
540 /**
541  * @dev Implementation of the {IERC165} interface.
542  *
543  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
544  * for the additional interface id that will be supported. For example:
545  *
546  * ```solidity
547  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
549  * }
550  * ```
551  *
552  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
553  */
554 abstract contract ERC165 is IERC165 {
555     /**
556      * @dev See {IERC165-supportsInterface}.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         return interfaceId == type(IERC165).interfaceId;
560     }
561 }
562 
563 /**
564  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
565  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
566  *
567  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
568  *
569  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
570  *
571  * Does not support burning tokens to address(0).
572  */
573 contract ERC721A is
574   Context,
575   ERC165,
576   IERC721,
577   IERC721Metadata,
578   IERC721Enumerable
579 {
580   using Address for address;
581   using Strings for uint256;
582 
583   struct TokenOwnership {
584     address addr;
585     uint64 startTimestamp;
586   }
587 
588   struct AddressData {
589     uint128 balance;
590     uint128 numberMinted;
591   }
592 
593   uint256 private currentIndex = 0;
594 
595   uint256 internal immutable collectionSize;
596   uint256 internal immutable maxBatchSize;
597 
598   // Token name
599   string private _name;
600 
601   // Token symbol
602   string private _symbol;
603 
604   // Mapping from token ID to ownership details
605   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
606   mapping(uint256 => TokenOwnership) private _ownerships;
607 
608   // Mapping owner address to address data
609   mapping(address => AddressData) private _addressData;
610 
611   // Mapping from token ID to approved address
612   mapping(uint256 => address) private _tokenApprovals;
613 
614   // Mapping from owner to operator approvals
615   mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617   /**
618    * @dev
619    * `maxBatchSize` refers to how much a minter can mint at a time.
620    * `collectionSize_` refers to how many tokens are in the collection.
621    */
622   constructor(
623     string memory name_,
624     string memory symbol_,
625     uint256 maxBatchSize_,
626     uint256 collectionSize_
627   ) {
628     require(
629       collectionSize_ > 0,
630       "ERC721A: collection must have a nonzero supply"
631     );
632     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
633     _name = name_;
634     _symbol = symbol_;
635     maxBatchSize = maxBatchSize_;
636     collectionSize = collectionSize_;
637   }
638 
639   /**
640    * @dev See {IERC721Enumerable-totalSupply}.
641    */
642   function totalSupply() public view override returns (uint256) {
643     return currentIndex;
644   }
645 
646   /**
647    * @dev See {IERC721Enumerable-tokenByIndex}.
648    */
649   function tokenByIndex(uint256 index) public view override returns (uint256) {
650     require(index < totalSupply(), "ERC721A: global index out of bounds");
651     return index;
652   }
653 
654   /**
655    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
656    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
657    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
658    */
659   function tokenOfOwnerByIndex(address owner, uint256 index)
660     public
661     view
662     override
663     returns (uint256)
664   {
665     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
666     uint256 numMintedSoFar = totalSupply();
667     uint256 tokenIdsIdx = 0;
668     address currOwnershipAddr = address(0);
669     for (uint256 i = 0; i < numMintedSoFar; i++) {
670       TokenOwnership memory ownership = _ownerships[i];
671       if (ownership.addr != address(0)) {
672         currOwnershipAddr = ownership.addr;
673       }
674       if (currOwnershipAddr == owner) {
675         if (tokenIdsIdx == index) {
676           return i;
677         }
678         tokenIdsIdx++;
679       }
680     }
681     revert("ERC721A: unable to get token of owner by index");
682   }
683 
684   /**
685    * @dev See {IERC165-supportsInterface}.
686    */
687   function supportsInterface(bytes4 interfaceId)
688     public
689     view
690     virtual
691     override(ERC165, IERC165)
692     returns (bool)
693   {
694     return
695       interfaceId == type(IERC721).interfaceId ||
696       interfaceId == type(IERC721Metadata).interfaceId ||
697       interfaceId == type(IERC721Enumerable).interfaceId ||
698       super.supportsInterface(interfaceId);
699   }
700 
701   /**
702    * @dev See {IERC721-balanceOf}.
703    */
704   function balanceOf(address owner) public view override returns (uint256) {
705     require(owner != address(0), "ERC721A: balance query for the zero address");
706     return uint256(_addressData[owner].balance);
707   }
708 
709   function _numberMinted(address owner) internal view returns (uint256) {
710     require(
711       owner != address(0),
712       "ERC721A: number minted query for the zero address"
713     );
714     return uint256(_addressData[owner].numberMinted);
715   }
716 
717   function ownershipOf(uint256 tokenId)
718     internal
719     view
720     returns (TokenOwnership memory)
721   {
722     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
723 
724     uint256 lowestTokenToCheck;
725     if (tokenId >= maxBatchSize) {
726       lowestTokenToCheck = tokenId - maxBatchSize + 1;
727     }
728 
729     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
730       TokenOwnership memory ownership = _ownerships[curr];
731       if (ownership.addr != address(0)) {
732         return ownership;
733       }
734     }
735 
736     revert("ERC721A: unable to determine the owner of token");
737   }
738 
739   /**
740    * @dev See {IERC721-ownerOf}.
741    */
742   function ownerOf(uint256 tokenId) public view override returns (address) {
743     return ownershipOf(tokenId).addr;
744   }
745 
746   /**
747    * @dev See {IERC721Metadata-name}.
748    */
749   function name() public view virtual override returns (string memory) {
750     return _name;
751   }
752 
753   /**
754    * @dev See {IERC721Metadata-symbol}.
755    */
756   function symbol() public view virtual override returns (string memory) {
757     return _symbol;
758   }
759 
760   /**
761    * @dev See {IERC721Metadata-tokenURI}.
762    */
763   function tokenURI(uint256 tokenId)
764     public
765     view
766     virtual
767     override
768     returns (string memory)
769   {
770     require(
771       _exists(tokenId),
772       "ERC721Metadata: URI query for nonexistent token"
773     );
774 
775     string memory baseURI = _baseURI();
776     return
777       bytes(baseURI).length > 0
778         ? string(abi.encodePacked(baseURI, tokenId.toString()))
779         : "";
780   }
781 
782   /**
783    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
784    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
785    * by default, can be overriden in child contracts.
786    */
787   function _baseURI() internal view virtual returns (string memory) {
788     return "";
789   }
790 
791   /**
792    * @dev See {IERC721-approve}.
793    */
794   function approve(address to, uint256 tokenId) public override {
795     address owner = ERC721A.ownerOf(tokenId);
796     require(to != owner, "ERC721A: approval to current owner");
797 
798     require(
799       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
800       "ERC721A: approve caller is not owner nor approved for all"
801     );
802 
803     _approve(to, tokenId, owner);
804   }
805 
806   /**
807    * @dev See {IERC721-getApproved}.
808    */
809   function getApproved(uint256 tokenId) public view override returns (address) {
810     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
811 
812     return _tokenApprovals[tokenId];
813   }
814 
815   /**
816    * @dev See {IERC721-setApprovalForAll}.
817    */
818   function setApprovalForAll(address operator, bool approved) public override {
819     require(operator != _msgSender(), "ERC721A: approve to caller");
820 
821     _operatorApprovals[_msgSender()][operator] = approved;
822     emit ApprovalForAll(_msgSender(), operator, approved);
823   }
824 
825   /**
826    * @dev See {IERC721-isApprovedForAll}.
827    */
828   function isApprovedForAll(address owner, address operator)
829     public
830     view
831     virtual
832     override
833     returns (bool)
834   {
835     return _operatorApprovals[owner][operator];
836   }
837 
838   /**
839    * @dev See {IERC721-transferFrom}.
840    */
841   function transferFrom(
842     address from,
843     address to,
844     uint256 tokenId
845   ) public override {
846     _transfer(from, to, tokenId);
847   }
848 
849   /**
850    * @dev See {IERC721-safeTransferFrom}.
851    */
852   function safeTransferFrom(
853     address from,
854     address to,
855     uint256 tokenId
856   ) public override {
857     safeTransferFrom(from, to, tokenId, "");
858   }
859 
860   /**
861    * @dev See {IERC721-safeTransferFrom}.
862    */
863   function safeTransferFrom(
864     address from,
865     address to,
866     uint256 tokenId,
867     bytes memory _data
868   ) public override {
869     _transfer(from, to, tokenId);
870     require(
871       _checkOnERC721Received(from, to, tokenId, _data),
872       "ERC721A: transfer to non ERC721Receiver implementer"
873     );
874   }
875 
876   /**
877    * @dev Returns whether `tokenId` exists.
878    *
879    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
880    *
881    * Tokens start existing when they are minted (`_mint`),
882    */
883   function _exists(uint256 tokenId) internal view returns (bool) {
884     return tokenId < currentIndex;
885   }
886 
887   function _safeMint(address to, uint256 quantity) internal {
888     _safeMint(to, quantity, "");
889   }
890 
891   /**
892    * @dev Mints `quantity` tokens and transfers them to `to`.
893    *
894    * Requirements:
895    *
896    * - there must be `quantity` tokens remaining unminted in the total collection.
897    * - `to` cannot be the zero address.
898    * - `quantity` cannot be larger than the max batch size.
899    *
900    * Emits a {Transfer} event.
901    */
902   function _safeMint(
903     address to,
904     uint256 quantity,
905     bytes memory _data
906   ) internal {
907     uint256 startTokenId = currentIndex;
908     require(to != address(0), "ERC721A: mint to the zero address");
909     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
910     require(!_exists(startTokenId), "ERC721A: token already minted");
911     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
912 
913     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
914 
915     AddressData memory addressData = _addressData[to];
916     _addressData[to] = AddressData(
917       addressData.balance + uint128(quantity),
918       addressData.numberMinted + uint128(quantity)
919     );
920     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
921 
922     uint256 updatedIndex = startTokenId;
923 
924     for (uint256 i = 0; i < quantity; i++) {
925       emit Transfer(address(0), to, updatedIndex);
926       require(
927         _checkOnERC721Received(address(0), to, updatedIndex, _data),
928         "ERC721A: transfer to non ERC721Receiver implementer"
929       );
930       updatedIndex++;
931     }
932 
933     currentIndex = updatedIndex;
934     _afterTokenTransfers(address(0), to, startTokenId, quantity);
935   }
936 
937   /**
938    * @dev Transfers `tokenId` from `from` to `to`.
939    *
940    * Requirements:
941    *
942    * - `to` cannot be the zero address.
943    * - `tokenId` token must be owned by `from`.
944    *
945    * Emits a {Transfer} event.
946    */
947   function _transfer(
948     address from,
949     address to,
950     uint256 tokenId
951   ) private {
952     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
953 
954     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
955       getApproved(tokenId) == _msgSender() ||
956       isApprovedForAll(prevOwnership.addr, _msgSender()));
957 
958     require(
959       isApprovedOrOwner,
960       "ERC721A: transfer caller is not owner nor approved"
961     );
962 
963     require(
964       prevOwnership.addr == from,
965       "ERC721A: transfer from incorrect owner"
966     );
967     require(to != address(0), "ERC721A: transfer to the zero address");
968 
969     _beforeTokenTransfers(from, to, tokenId, 1);
970 
971     // Clear approvals from the previous owner
972     _approve(address(0), tokenId, prevOwnership.addr);
973 
974     _addressData[from].balance -= 1;
975     _addressData[to].balance += 1;
976     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
977 
978     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
979     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
980     uint256 nextTokenId = tokenId + 1;
981     if (_ownerships[nextTokenId].addr == address(0)) {
982       if (_exists(nextTokenId)) {
983         _ownerships[nextTokenId] = TokenOwnership(
984           prevOwnership.addr,
985           prevOwnership.startTimestamp
986         );
987       }
988     }
989 
990     emit Transfer(from, to, tokenId);
991     _afterTokenTransfers(from, to, tokenId, 1);
992   }
993 
994   /**
995    * @dev Approve `to` to operate on `tokenId`
996    *
997    * Emits a {Approval} event.
998    */
999   function _approve(
1000     address to,
1001     uint256 tokenId,
1002     address owner
1003   ) private {
1004     _tokenApprovals[tokenId] = to;
1005     emit Approval(owner, to, tokenId);
1006   }
1007 
1008   uint256 public nextOwnerToExplicitlySet = 0;
1009 
1010   /**
1011    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1012    */
1013   function _setOwnersExplicit(uint256 quantity) internal {
1014     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1015     require(quantity > 0, "quantity must be nonzero");
1016     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1017     if (endIndex > collectionSize - 1) {
1018       endIndex = collectionSize - 1;
1019     }
1020     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1021     require(_exists(endIndex), "not enough minted yet for this cleanup");
1022     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1023       if (_ownerships[i].addr == address(0)) {
1024         TokenOwnership memory ownership = ownershipOf(i);
1025         _ownerships[i] = TokenOwnership(
1026           ownership.addr,
1027           ownership.startTimestamp
1028         );
1029       }
1030     }
1031     nextOwnerToExplicitlySet = endIndex + 1;
1032   }
1033 
1034   /**
1035    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1036    * The call is not executed if the target address is not a contract.
1037    *
1038    * @param from address representing the previous owner of the given token ID
1039    * @param to target address that will receive the tokens
1040    * @param tokenId uint256 ID of the token to be transferred
1041    * @param _data bytes optional data to send along with the call
1042    * @return bool whether the call correctly returned the expected magic value
1043    */
1044   function _checkOnERC721Received(
1045     address from,
1046     address to,
1047     uint256 tokenId,
1048     bytes memory _data
1049   ) private returns (bool) {
1050     if (to.isContract()) {
1051       try
1052         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1053       returns (bytes4 retval) {
1054         return retval == IERC721Receiver(to).onERC721Received.selector;
1055       } catch (bytes memory reason) {
1056         if (reason.length == 0) {
1057           revert("ERC721A: transfer to non ERC721Receiver implementer");
1058         } else {
1059           assembly {
1060             revert(add(32, reason), mload(reason))
1061           }
1062         }
1063       }
1064     } else {
1065       return true;
1066     }
1067   }
1068 
1069   /**
1070    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1071    *
1072    * startTokenId - the first token id to be transferred
1073    * quantity - the amount to be transferred
1074    *
1075    * Calling conditions:
1076    *
1077    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1078    * transferred to `to`.
1079    * - When `from` is zero, `tokenId` will be minted for `to`.
1080    */
1081   function _beforeTokenTransfers(
1082     address from,
1083     address to,
1084     uint256 startTokenId,
1085     uint256 quantity
1086   ) internal virtual {}
1087 
1088   /**
1089    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1090    * minting.
1091    *
1092    * startTokenId - the first token id to be transferred
1093    * quantity - the amount to be transferred
1094    *
1095    * Calling conditions:
1096    *
1097    * - when `from` and `to` are both non-zero.
1098    * - `from` and `to` are never both zero.
1099    */
1100   function _afterTokenTransfers(
1101     address from,
1102     address to,
1103     uint256 startTokenId,
1104     uint256 quantity
1105   ) internal virtual {}
1106 }
1107 pragma solidity ^0.8.0;
1108 
1109 /**
1110  * @dev String operations.
1111  */
1112 library Strings {
1113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1114 
1115     /**
1116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1117      */
1118     function toString(uint256 value) internal pure returns (string memory) {
1119         // Inspired by OraclizeAPI's implementation - MIT licence
1120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1121 
1122         if (value == 0) {
1123             return "0";
1124         }
1125         uint256 temp = value;
1126         uint256 digits;
1127         while (temp != 0) {
1128             digits++;
1129             temp /= 10;
1130         }
1131         bytes memory buffer = new bytes(digits);
1132         while (value != 0) {
1133             digits -= 1;
1134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1135             value /= 10;
1136         }
1137         return string(buffer);
1138     }
1139 
1140     /**
1141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1142      */
1143     function toHexString(uint256 value) internal pure returns (string memory) {
1144         if (value == 0) {
1145             return "0x00";
1146         }
1147         uint256 temp = value;
1148         uint256 length = 0;
1149         while (temp != 0) {
1150             length++;
1151             temp >>= 8;
1152         }
1153         return toHexString(value, length);
1154     }
1155 
1156     /**
1157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1158      */
1159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1160         bytes memory buffer = new bytes(2 * length + 2);
1161         buffer[0] = "0";
1162         buffer[1] = "x";
1163         for (uint256 i = 2 * length + 1; i > 1; --i) {
1164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1165             value >>= 4;
1166         }
1167         require(value == 0, "Strings: hex length insufficient");
1168         return string(buffer);
1169     }
1170 }
1171 
1172 contract vVvSeason1 is Ownable, ERC721A {
1173   
1174   constructor(
1175     uint256 maxBatchSize_,
1176     uint256 collectionSize_
1177   ) ERC721A("vVv Season 1", "VVVS1", maxBatchSize_, collectionSize_) {
1178   }
1179 
1180   function freeMint(uint256 quantity) public onlyOwner {
1181     require(
1182       totalSupply() + quantity <= collectionSize,
1183       "quantity is too many"
1184     );
1185       _safeMint(msg.sender, quantity);
1186   }
1187 
1188   // // metadata URI
1189   string private _baseTokenURI;
1190 
1191   function _baseURI() internal view virtual override returns (string memory) {
1192     return _baseTokenURI;
1193   }
1194 
1195   function setBaseURI(string calldata baseURI) external onlyOwner {
1196     _baseTokenURI = baseURI;
1197   }
1198 
1199   function numberMinted(address owner) public view returns (uint256) {
1200     return _numberMinted(owner);
1201   }
1202 
1203   function getOwnershipData(uint256 tokenId)
1204     external
1205     view
1206     returns (TokenOwnership memory)
1207   {
1208     return ownershipOf(tokenId);
1209   }
1210 }