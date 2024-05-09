1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 /// @title Chaos Clownz
5 /// @author André Costa @ Terratecc
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
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
101 
102 pragma solidity ^0.8.0;
103 
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _setOwner(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _setOwner(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _setOwner(newOwner);
162     }
163 
164     function _setOwner(address newOwner) private {
165         address oldOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(oldOwner, newOwner);
168     }
169 }
170 
171 // File: @openzeppelin/contracts/utils/Address.sol
172 
173 
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev Collection of functions related to the address type
179  */
180 library Address {
181     /**
182      * @dev Returns true if `account` is a contract.
183      *
184      * [IMPORTANT]
185      * ====
186      * It is unsafe to assume that an address for which this function returns
187      * false is an externally-owned account (EOA) and not a contract.
188      *
189      * Among others, `isContract` will return false for the following
190      * types of addresses:
191      *
192      *  - an externally-owned account
193      *  - a contract in construction
194      *  - an address where a contract will be created
195      *  - an address where a contract lived, but was destroyed
196      * ====
197      */
198     function isContract(address account) internal view returns (bool) {
199         // This method relies on extcodesize, which returns 0 for contracts in
200         // construction, since the code is only stored at the end of the
201         // constructor execution.
202 
203         uint256 size;
204         assembly {
205             size := extcodesize(account)
206         }
207         return size > 0;
208     }
209 
210     /**
211      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
212      * `recipient`, forwarding all available gas and reverting on errors.
213      *
214      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
215      * of certain opcodes, possibly making contracts go over the 2300 gas limit
216      * imposed by `transfer`, making them unable to receive funds via
217      * `transfer`. {sendValue} removes this limitation.
218      *
219      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
220      *
221      * IMPORTANT: because control is transferred to `recipient`, care must be
222      * taken to not create reentrancy vulnerabilities. Consider using
223      * {ReentrancyGuard} or the
224      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
225      */
226     function sendValue(address payable recipient, uint256 amount) internal {
227         require(address(this).balance >= amount, "Address: insufficient balance");
228 
229         (bool success, ) = recipient.call{value: amount}("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain `call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionCall(target, data, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, 0, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but also transferring `value` wei to `target`.
272      *
273      * Requirements:
274      *
275      * - the calling contract must have an ETH balance of at least `value`.
276      * - the called Solidity function must be `payable`.
277      *
278      * _Available since v3.1._
279      */
280     function functionCallWithValue(
281         address target,
282         bytes memory data,
283         uint256 value
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
290      * with `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(address(this).balance >= value, "Address: insufficient balance for call");
301         require(isContract(target), "Address: call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.call{value: value}(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a static call.
310      *
311      * _Available since v3.3._
312      */
313     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
314         return functionStaticCall(target, data, "Address: low-level static call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal view returns (bytes memory) {
328         require(isContract(target), "Address: static call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.staticcall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a delegate call.
337      *
338      * _Available since v3.4._
339      */
340     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(isContract(target), "Address: delegate call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.delegatecall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
363      * revert reason using the provided one.
364      *
365      * _Available since v4.3._
366      */
367     function verifyCallResult(
368         bool success,
369         bytes memory returndata,
370         string memory errorMessage
371     ) internal pure returns (bytes memory) {
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
391 
392 
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @title ERC721 token receiver interface
398  * @dev Interface for any contract that wants to support safeTransfers
399  * from ERC721 asset contracts.
400  */
401 interface IERC721Receiver {
402     /**
403      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
404      * by `operator` from `from`, this function is called.
405      *
406      * It must return its Solidity selector to confirm the token transfer.
407      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
408      *
409      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
410      */
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external returns (bytes4);
417 }
418 
419 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
420 
421 
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Interface of the ERC165 standard, as defined in the
427  * https://eips.ethereum.org/EIPS/eip-165[EIP].
428  *
429  * Implementers can declare support of contract interfaces, which can then be
430  * queried by others ({ERC165Checker}).
431  *
432  * For an implementation, see {ERC165}.
433  */
434 interface IERC165 {
435     /**
436      * @dev Returns true if this contract implements the interface defined by
437      * `interfaceId`. See the corresponding
438      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
439      * to learn more about how these ids are created.
440      *
441      * This function call must use less than 30 000 gas.
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
447 
448 
449 
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @dev Implementation of the {IERC165} interface.
455  *
456  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
457  * for the additional interface id that will be supported. For example:
458  *
459  * ```solidity
460  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
461  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
462  * }
463  * ```
464  *
465  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
466  */
467 abstract contract ERC165 is IERC165 {
468     /**
469      * @dev See {IERC165-supportsInterface}.
470      */
471     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472         return interfaceId == type(IERC165).interfaceId;
473     }
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
477 
478 
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Required interface of an ERC721 compliant contract.
485  */
486 interface IERC721 is IERC165 {
487     /**
488      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
489      */
490     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
494      */
495     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
499      */
500     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
501 
502     /**
503      * @dev Returns the number of tokens in ``owner``'s account.
504      */
505     function balanceOf(address owner) external view returns (uint256 balance);
506 
507     /**
508      * @dev Returns the owner of the `tokenId` token.
509      *
510      * Requirements:
511      *
512      * - `tokenId` must exist.
513      */
514     function ownerOf(uint256 tokenId) external view returns (address owner);
515 
516     /**
517      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
518      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must exist and be owned by `from`.
525      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
526      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
527      *
528      * Emits a {Transfer} event.
529      */
530     function safeTransferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external;
535 
536     /**
537      * @dev Transfers `tokenId` token from `from` to `to`.
538      *
539      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must be owned by `from`.
546      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) external;
555 
556     /**
557      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
558      * The approval is cleared when the token is transferred.
559      *
560      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
561      *
562      * Requirements:
563      *
564      * - The caller must own the token or be an approved operator.
565      * - `tokenId` must exist.
566      *
567      * Emits an {Approval} event.
568      */
569     function approve(address to, uint256 tokenId) external;
570 
571     /**
572      * @dev Returns the account approved for `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function getApproved(uint256 tokenId) external view returns (address operator);
579 
580     /**
581      * @dev Approve or remove `operator` as an operator for the caller.
582      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
583      *
584      * Requirements:
585      *
586      * - The `operator` cannot be the caller.
587      *
588      * Emits an {ApprovalForAll} event.
589      */
590     function setApprovalForAll(address operator, bool _approved) external;
591 
592     /**
593      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
594      *
595      * See {setApprovalForAll}
596      */
597     function isApprovedForAll(address owner, address operator) external view returns (bool);
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId,
616         bytes calldata data
617     ) external;
618 }
619 
620 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
621 
622 
623 
624 pragma solidity ^0.8.0;
625 
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
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Enumerable is IERC721 {
653     /**
654      * @dev Returns the total amount of tokens stored by the contract.
655      */
656     function totalSupply() external view returns (uint256);
657 
658     /**
659      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
660      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
661      */
662     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
663 
664     /**
665      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
666      * Use along with {totalSupply} to enumerate all tokens.
667      */
668     function tokenByIndex(uint256 index) external view returns (uint256);
669 }
670 
671 contract ERC721A is
672   Context,
673   ERC165,
674   IERC721,
675   IERC721Metadata,
676   IERC721Enumerable
677 {
678   using Address for address;
679   using Strings for uint256;
680 
681   struct TokenOwnership {
682     address addr;
683     uint64 startTimestamp;
684   }
685 
686   struct AddressData {
687     uint128 balance;
688     uint128 numberMinted;
689   }
690 
691   uint256 private currentIndex = 0;
692 
693   uint256 internal immutable collectionSize;
694   uint256 internal immutable maxBatchSize;
695 
696   // Token name
697   string private _name;
698 
699   // Token symbol
700   string private _symbol;
701 
702   // Mapping from token ID to ownership details
703   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
704   mapping(uint256 => TokenOwnership) private _ownerships;
705 
706   // Mapping owner address to address data
707   mapping(address => AddressData) private _addressData;
708 
709   // Mapping from token ID to approved address
710   mapping(uint256 => address) private _tokenApprovals;
711 
712   // Mapping from owner to operator approvals
713   mapping(address => mapping(address => bool)) private _operatorApprovals;
714 
715   /**
716    * @dev
717    * `maxBatchSize` refers to how much a minter can mint at a time.
718    * `collectionSize_` refers to how many tokens are in the collection.
719    */
720   constructor(
721     string memory name_,
722     string memory symbol_,
723     uint256 maxBatchSize_,
724     uint256 collectionSize_
725   ) {
726     require(
727       collectionSize_ > 0,
728       "ERC721A: collection must have a nonzero supply"
729     );
730     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
731     _name = name_;
732     _symbol = symbol_;
733     maxBatchSize = maxBatchSize_;
734     collectionSize = collectionSize_;
735   }
736 
737   /**
738    * @dev See {IERC721Enumerable-totalSupply}.
739    */
740   function totalSupply() public view override returns (uint256) {
741     return currentIndex;
742   }
743 
744   /**
745    * @dev See {IERC721Enumerable-tokenByIndex}.
746    */
747   function tokenByIndex(uint256 index) public view override returns (uint256) {
748     require(index < totalSupply(), "ERC721A: global index out of bounds");
749     return index;
750   }
751 
752   /**
753    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
754    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
755    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
756    */
757   function tokenOfOwnerByIndex(address owner, uint256 index)
758     public
759     view
760     override
761     returns (uint256)
762   {
763     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
764     uint256 numMintedSoFar = totalSupply();
765     uint256 tokenIdsIdx = 0;
766     address currOwnershipAddr = address(0);
767     for (uint256 i = 0; i < numMintedSoFar; i++) {
768       TokenOwnership memory ownership = _ownerships[i];
769       if (ownership.addr != address(0)) {
770         currOwnershipAddr = ownership.addr;
771       }
772       if (currOwnershipAddr == owner) {
773         if (tokenIdsIdx == index) {
774           return i;
775         }
776         tokenIdsIdx++;
777       }
778     }
779     revert("ERC721A: unable to get token of owner by index");
780   }
781 
782   /**
783    * @dev See {IERC165-supportsInterface}.
784    */
785   function supportsInterface(bytes4 interfaceId)
786     public
787     view
788     virtual
789     override(ERC165, IERC165)
790     returns (bool)
791   {
792     return
793       interfaceId == type(IERC721).interfaceId ||
794       interfaceId == type(IERC721Metadata).interfaceId ||
795       interfaceId == type(IERC721Enumerable).interfaceId ||
796       super.supportsInterface(interfaceId);
797   }
798 
799   /**
800    * @dev See {IERC721-balanceOf}.
801    */
802   function balanceOf(address owner) public view override returns (uint256) {
803     require(owner != address(0), "ERC721A: balance query for the zero address");
804     return uint256(_addressData[owner].balance);
805   }
806 
807   function _numberMinted(address owner) internal view returns (uint256) {
808     require(
809       owner != address(0),
810       "ERC721A: number minted query for the zero address"
811     );
812     return uint256(_addressData[owner].numberMinted);
813   }
814 
815   function ownershipOf(uint256 tokenId)
816     internal
817     view
818     returns (TokenOwnership memory)
819   {
820     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
821 
822     uint256 lowestTokenToCheck;
823     if (tokenId >= maxBatchSize) {
824       lowestTokenToCheck = tokenId - maxBatchSize + 1;
825     }
826 
827     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
828       TokenOwnership memory ownership = _ownerships[curr];
829       if (ownership.addr != address(0)) {
830         return ownership;
831       }
832     }
833 
834     revert("ERC721A: unable to determine the owner of token");
835   }
836 
837   /**
838    * @dev See {IERC721-ownerOf}.
839    */
840   function ownerOf(uint256 tokenId) public view override returns (address) {
841     return ownershipOf(tokenId).addr;
842   }
843 
844   /**
845    * @dev See {IERC721Metadata-name}.
846    */
847   function name() public view virtual override returns (string memory) {
848     return _name;
849   }
850 
851   /**
852    * @dev See {IERC721Metadata-symbol}.
853    */
854   function symbol() public view virtual override returns (string memory) {
855     return _symbol;
856   }
857 
858   /**
859    * @dev See {IERC721Metadata-tokenURI}.
860    */
861   function tokenURI(uint256 tokenId)
862     public
863     view
864     virtual
865     override
866     returns (string memory)
867   {
868     require(
869       _exists(tokenId),
870       "ERC721Metadata: URI query for nonexistent token"
871     );
872 
873     string memory baseURI = _baseURI();
874     return
875       bytes(baseURI).length > 0
876         ? string(abi.encodePacked(baseURI, tokenId.toString()))
877         : "";
878   }
879 
880   /**
881    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883    * by default, can be overriden in child contracts.
884    */
885   function _baseURI() internal view virtual returns (string memory) {
886     return "";
887   }
888 
889   /**
890    * @dev See {IERC721-approve}.
891    */
892   function approve(address to, uint256 tokenId) public override {
893     address owner = ERC721A.ownerOf(tokenId);
894     require(to != owner, "ERC721A: approval to current owner");
895 
896     require(
897       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
898       "ERC721A: approve caller is not owner nor approved for all"
899     );
900 
901     _approve(to, tokenId, owner);
902   }
903 
904   /**
905    * @dev See {IERC721-getApproved}.
906    */
907   function getApproved(uint256 tokenId) public view override returns (address) {
908     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
909 
910     return _tokenApprovals[tokenId];
911   }
912 
913   /**
914    * @dev See {IERC721-setApprovalForAll}.
915    */
916   function setApprovalForAll(address operator, bool approved) public override {
917     require(operator != _msgSender(), "ERC721A: approve to caller");
918 
919     _operatorApprovals[_msgSender()][operator] = approved;
920     emit ApprovalForAll(_msgSender(), operator, approved);
921   }
922 
923   /**
924    * @dev See {IERC721-isApprovedForAll}.
925    */
926   function isApprovedForAll(address owner, address operator)
927     public
928     view
929     virtual
930     override
931     returns (bool)
932   {
933     return _operatorApprovals[owner][operator];
934   }
935 
936   /**
937    * @dev See {IERC721-transferFrom}.
938    */
939   function transferFrom(
940     address from,
941     address to,
942     uint256 tokenId
943   ) public override {
944     _transfer(from, to, tokenId);
945   }
946 
947   /**
948    * @dev See {IERC721-safeTransferFrom}.
949    */
950   function safeTransferFrom(
951     address from,
952     address to,
953     uint256 tokenId
954   ) public override {
955     safeTransferFrom(from, to, tokenId, "");
956   }
957 
958   /**
959    * @dev See {IERC721-safeTransferFrom}.
960    */
961   function safeTransferFrom(
962     address from,
963     address to,
964     uint256 tokenId,
965     bytes memory _data
966   ) public override {
967     _transfer(from, to, tokenId);
968     require(
969       _checkOnERC721Received(from, to, tokenId, _data),
970       "ERC721A: transfer to non ERC721Receiver implementer"
971     );
972   }
973 
974   /**
975    * @dev Returns whether `tokenId` exists.
976    *
977    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
978    *
979    * Tokens start existing when they are minted (`_mint`),
980    */
981   function _exists(uint256 tokenId) internal view returns (bool) {
982     return tokenId < currentIndex;
983   }
984 
985   function _safeMint(address to, uint256 quantity) internal {
986     _safeMint(to, quantity, "");
987   }
988 
989   /**
990    * @dev Mints `quantity` tokens and transfers them to `to`.
991    *
992    * Requirements:
993    *
994    * - there must be `quantity` tokens remaining unminted in the total collection.
995    * - `to` cannot be the zero address.
996    * - `quantity` cannot be larger than the max batch size.
997    *
998    * Emits a {Transfer} event.
999    */
1000   function _safeMint(
1001     address to,
1002     uint256 quantity,
1003     bytes memory _data
1004   ) internal {
1005     uint256 startTokenId = currentIndex;
1006     require(to != address(0), "ERC721A: mint to the zero address");
1007     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1008     require(!_exists(startTokenId), "ERC721A: token already minted");
1009     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1010 
1011     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1012 
1013     AddressData memory addressData = _addressData[to];
1014     _addressData[to] = AddressData(
1015       addressData.balance + uint128(quantity),
1016       addressData.numberMinted + uint128(quantity)
1017     );
1018     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1019 
1020     uint256 updatedIndex = startTokenId;
1021 
1022     for (uint256 i = 0; i < quantity; i++) {
1023       emit Transfer(address(0), to, updatedIndex);
1024       require(
1025         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1026         "ERC721A: transfer to non ERC721Receiver implementer"
1027       );
1028       updatedIndex++;
1029     }
1030 
1031     currentIndex = updatedIndex;
1032     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1033   }
1034 
1035   /**
1036    * @dev Transfers `tokenId` from `from` to `to`.
1037    *
1038    * Requirements:
1039    *
1040    * - `to` cannot be the zero address.
1041    * - `tokenId` token must be owned by `from`.
1042    *
1043    * Emits a {Transfer} event.
1044    */
1045   function _transfer(
1046     address from,
1047     address to,
1048     uint256 tokenId
1049   ) private {
1050     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1051 
1052     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1053       getApproved(tokenId) == _msgSender() ||
1054       isApprovedForAll(prevOwnership.addr, _msgSender()));
1055 
1056     require(
1057       isApprovedOrOwner,
1058       "ERC721A: transfer caller is not owner nor approved"
1059     );
1060 
1061     require(
1062       prevOwnership.addr == from,
1063       "ERC721A: transfer from incorrect owner"
1064     );
1065     require(to != address(0), "ERC721A: transfer to the zero address");
1066 
1067     _beforeTokenTransfers(from, to, tokenId, 1);
1068 
1069     // Clear approvals from the previous owner
1070     _approve(address(0), tokenId, prevOwnership.addr);
1071 
1072     _addressData[from].balance -= 1;
1073     _addressData[to].balance += 1;
1074     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1075 
1076     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1077     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1078     uint256 nextTokenId = tokenId + 1;
1079     if (_ownerships[nextTokenId].addr == address(0)) {
1080       if (_exists(nextTokenId)) {
1081         _ownerships[nextTokenId] = TokenOwnership(
1082           prevOwnership.addr,
1083           prevOwnership.startTimestamp
1084         );
1085       }
1086     }
1087 
1088     emit Transfer(from, to, tokenId);
1089     _afterTokenTransfers(from, to, tokenId, 1);
1090   }
1091 
1092   /**
1093    * @dev Approve `to` to operate on `tokenId`
1094    *
1095    * Emits a {Approval} event.
1096    */
1097   function _approve(
1098     address to,
1099     uint256 tokenId,
1100     address owner
1101   ) private {
1102     _tokenApprovals[tokenId] = to;
1103     emit Approval(owner, to, tokenId);
1104   }
1105 
1106   uint256 public nextOwnerToExplicitlySet = 0;
1107 
1108   /**
1109    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1110    */
1111   function _setOwnersExplicit(uint256 quantity) internal {
1112     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1113     require(quantity > 0, "quantity must be nonzero");
1114     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1115     if (endIndex > collectionSize - 1) {
1116       endIndex = collectionSize - 1;
1117     }
1118     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1119     require(_exists(endIndex), "not enough minted yet for this cleanup");
1120     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1121       if (_ownerships[i].addr == address(0)) {
1122         TokenOwnership memory ownership = ownershipOf(i);
1123         _ownerships[i] = TokenOwnership(
1124           ownership.addr,
1125           ownership.startTimestamp
1126         );
1127       }
1128     }
1129     nextOwnerToExplicitlySet = endIndex + 1;
1130   }
1131 
1132   /**
1133    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1134    * The call is not executed if the target address is not a contract.
1135    *
1136    * @param from address representing the previous owner of the given token ID
1137    * @param to target address that will receive the tokens
1138    * @param tokenId uint256 ID of the token to be transferred
1139    * @param _data bytes optional data to send along with the call
1140    * @return bool whether the call correctly returned the expected magic value
1141    */
1142   function _checkOnERC721Received(
1143     address from,
1144     address to,
1145     uint256 tokenId,
1146     bytes memory _data
1147   ) private returns (bool) {
1148     if (to.isContract()) {
1149       try
1150         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1151       returns (bytes4 retval) {
1152         return retval == IERC721Receiver(to).onERC721Received.selector;
1153       } catch (bytes memory reason) {
1154         if (reason.length == 0) {
1155           revert("ERC721A: transfer to non ERC721Receiver implementer");
1156         } else {
1157           assembly {
1158             revert(add(32, reason), mload(reason))
1159           }
1160         }
1161       }
1162     } else {
1163       return true;
1164     }
1165   }
1166 
1167   /**
1168    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1169    *
1170    * startTokenId - the first token id to be transferred
1171    * quantity - the amount to be transferred
1172    *
1173    * Calling conditions:
1174    *
1175    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1176    * transferred to `to`.
1177    * - When `from` is zero, `tokenId` will be minted for `to`.
1178    */
1179   function _beforeTokenTransfers(
1180     address from,
1181     address to,
1182     uint256 startTokenId,
1183     uint256 quantity
1184   ) internal virtual {}
1185 
1186   /**
1187    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1188    * minting.
1189    *
1190    * startTokenId - the first token id to be transferred
1191    * quantity - the amount to be transferred
1192    *
1193    * Calling conditions:
1194    *
1195    * - when `from` and `to` are both non-zero.
1196    * - `from` and `to` are never both zero.
1197    */
1198   function _afterTokenTransfers(
1199     address from,
1200     address to,
1201     uint256 startTokenId,
1202     uint256 quantity
1203   ) internal virtual {}
1204 }
1205 
1206 contract ChaosClownz is ERC721A, Ownable {
1207     using Strings for uint256;
1208     
1209     //initial part of the URI for the metadata
1210     string private _currentBaseURI;
1211         
1212     //cost of mints depending on state of sale    
1213     uint private mintCost_ = 0.03 ether;
1214     
1215     //maximum amount of mints allowed per person
1216     uint256 public constant maxMintPresale = 3;
1217     
1218     //the amount of reserved mints that have currently been executed by creator and giveaways
1219     uint private _reservedMints = 0;
1220     
1221     //the maximum amount of reserved mints allowed for creator and giveaways
1222     uint private maxReservedMints = 200;
1223     
1224     //dummy address that we use to sign the mint transaction to make sure it is valid
1225     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1226     
1227     //marks the timestamp of when the respective sales open
1228     uint256 internal presaleLaunchTime;
1229     uint256 internal publicSaleLaunchTime;
1230     uint256 internal revealTime;
1231 
1232     //amount of mints that each address has executed
1233     mapping(address => uint256) public mintsPerAddress;
1234     
1235     //current state os sale
1236     enum State {NoSale, Presale, PublicSale}
1237 
1238     //defines the uri for when the NFTs have not been yet revealed
1239     string public unrevealedURI;
1240     
1241     //declaring initial values for variables
1242     constructor() ERC721A('Chaos Clownz', 'CC', 10, 999) {
1243 
1244         unrevealedURI = "ipfs://QmfCc521c8y2CLKwhZi2cmnmfyuL8egSe6njoQJDC57YE1/";
1245     }
1246     
1247     //in case somebody accidentaly sends funds or transaction to contract
1248     receive() payable external {}
1249     fallback() payable external {
1250         revert();
1251     }
1252     
1253     //visualize baseURI
1254     function _baseURI() internal view virtual override returns (string memory) {
1255         return _currentBaseURI;
1256     }
1257     
1258     //change baseURI in case needed for IPFS
1259     function changeBaseURI(string memory baseURI_) public onlyOwner {
1260         _currentBaseURI = baseURI_;
1261     }
1262 
1263     function changeUnrevealedURI(string memory unrevealedURI_) public onlyOwner {
1264         unrevealedURI = unrevealedURI_;
1265     }
1266 
1267     function switchToPresale() public onlyOwner {
1268         require(saleState() == State.NoSale, 'Sale is already Open!');
1269         presaleLaunchTime = block.timestamp;
1270     }
1271 
1272     function switchToPublicSale() public onlyOwner {
1273         require(saleState() == State.Presale, 'Sale must be in Presale!');
1274         publicSaleLaunchTime = block.timestamp;
1275     }
1276     
1277     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1278         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1279         _;
1280     }
1281  
1282     /* 
1283     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1284     *      Assumes Geth signature prefix.
1285     * @param _add Address of agent with access
1286     * @param _v ECDSA signature parameter v.
1287     * @param _r ECDSA signature parameters r.
1288     * @param _s ECDSA signature parameters s.
1289     * @return Validity of access message for a given address.
1290     */
1291     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1292         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1293         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1294     }
1295     
1296     //mint a @param number of NFTs in presale
1297     function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public payable {
1298         State saleState_ = saleState();
1299         require(saleState_ != State.NoSale, "Sale in not open yet!");
1300         require(saleState_ != State.PublicSale, "Presale has closed, Check out Public Sale!");
1301         require(totalSupply() + number <= collectionSize - (maxReservedMints  - _reservedMints), "Not enough NFTs left to mint..");
1302         require(mintsPerAddress[msg.sender] + number <= maxMintPresale, "Maximum 3 Mints per Address allowed!");
1303         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.03 ether each NFT)");
1304 
1305         _safeMint(msg.sender, number);
1306         mintsPerAddress[msg.sender] += number;
1307 
1308     }
1309 
1310     //mint a @param number of NFTs in public sale
1311     function publicSaleMint(uint256 number) public payable {
1312         State saleState_ = saleState();
1313         require(saleState_ == State.PublicSale, "Public Sale in not open yet!");
1314         require(totalSupply() + number <= collectionSize - (maxReservedMints - _reservedMints), "Not enough NFTs left to mint..");
1315         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.03 ether for each NFT)");
1316 
1317 
1318         _safeMint(msg.sender, number);
1319         mintsPerAddress[msg.sender] += number;
1320 
1321     }
1322     
1323     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1324         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1325         
1326         //check to see that 24 hours have passed since beginning of publicsale launch
1327         if (revealTime == 0) {
1328             return unrevealedURI;
1329         }
1330         
1331         else {
1332             string memory baseURI = _baseURI();
1333             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), '.json')) : "";
1334         }    
1335     }
1336     
1337     //reserved NFTs for creator
1338     function reservedMint(uint number, address recipient) public onlyOwner {
1339         require(_reservedMints + number <= maxReservedMints, "Not enough Reserved NFTs left to mint..");
1340 
1341         _safeMint(recipient, number);
1342         mintsPerAddress[recipient] += number;
1343         _reservedMints += number;
1344         
1345     }
1346     
1347     //se the current account balance
1348     function accountBalance() public onlyOwner view returns(uint) {
1349         return address(this).balance;
1350     }
1351     
1352     //retrieve all funds recieved from minting
1353     function withdraw() public onlyOwner {
1354         uint256 balance = accountBalance();
1355         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1356 
1357         _withdraw(payable(0x9cE6671D8cc327a3E6F164db0B7d5E2dD7D57761), balance); 
1358     }
1359     
1360     //send the percentage of funds to a shareholder´s wallet
1361     function _withdraw(address payable account, uint256 amount) internal {
1362         (bool sent, ) = account.call{value: amount}("");
1363         require(sent, "Failed to send Ether");
1364     }
1365     
1366     //change the dummy account used for signing transactions
1367     function changeDummy(address _dummy) public onlyOwner {
1368         dummy = _dummy;
1369     }
1370     
1371     //to see the total amount of reserved mints left 
1372     function reservedMintsLeft() public onlyOwner view returns(uint) {
1373         return maxReservedMints - _reservedMints;
1374     }
1375     
1376     //see current state of sale
1377     //see the current state of the sale
1378     function saleState() public view returns(State){
1379         if (presaleLaunchTime == 0) {
1380             return State.NoSale;
1381         }
1382         else if (publicSaleLaunchTime == 0) {
1383             return State.Presale;
1384         }
1385         else {
1386             return State.PublicSale;
1387         }
1388     }
1389     
1390     //gets the cost of current mint
1391     function mintCost() public view returns(uint) {
1392         return mintCost_; 
1393     }
1394 
1395     //see when NFTs will be revealed
1396     function timeOfReveal() public view returns(uint256) {
1397         require(revealTime != 0, 'NFT Reveal Time has not been determined yet!');
1398         return revealTime;
1399     }
1400 
1401     function reveal() public onlyOwner {
1402         require(revealTime == 0, "Collection has already been revealed!");
1403         revealTime = block.timestamp;
1404     }
1405 
1406     function changeMintCost(uint256 newCost) public onlyOwner {
1407         mintCost_ = newCost;
1408     }
1409     
1410    
1411 }