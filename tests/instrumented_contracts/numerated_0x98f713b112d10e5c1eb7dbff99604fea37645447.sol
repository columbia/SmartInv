1 // SPDX-License-Identifier: MIT
2 /*
3 
4 Generative of jumping skeletons
5 All animated gifs.
6 secret utilities ...
7 
8 3333 NFT - free mint
9 Max 2 per transaction
10                                                   
11                                                                                 
12                                      ////(&                                     
13                                     ////////                                    
14                                     /(@@@@/@                                    
15                                      #////@                                     
16                                   //@&@//@@@@/(                                 
17                                 @/ @@@@//%@@@ &(                                
18                                /@  @&@@////(@  ,/                               
19                              @//   *@@@@@@@@@   //                              
20                               /      @@%/@@.    @@                              
21                              #/    @/(%(/@(/&   (%                              
22                              &//     //////     @/@                             
23                              @@@@ .@///%(///##  /@@/.                           
24                              %@@@@/@         @/@  @@@                           
25                                @/                @/@                            
26                              @//                 @/@#                           
27                               ///              @/@                              
28                                  @/(         ,/@                                
29                                    @///@  @//@                                  
30                                    @//@  /////%@                                
31                               #@@@             @@@@       
32 
33                               💀 Are u a Jumper??? 💀                     
34     
35 */
36 
37 
38 // File: @openzeppelin/contracts/utils/Context.sol
39 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         return msg.data;
51     }
52 }
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
66      */
67     function toString(uint256 value) internal pure returns (string memory) {
68         // Inspired by OraclizeAPI's implementation - MIT licence
69         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
70 
71         if (value == 0) {
72             return "0";
73         }
74         uint256 temp = value;
75         uint256 digits;
76         while (temp != 0) {
77             digits++;
78             temp /= 10;
79         }
80         bytes memory buffer = new bytes(digits);
81         while (value != 0) {
82             digits -= 1;
83             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
84             value /= 10;
85         }
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
91      */
92     function toHexString(uint256 value) internal pure returns (string memory) {
93         if (value == 0) {
94             return "0x00";
95         }
96         uint256 temp = value;
97         uint256 length = 0;
98         while (temp != 0) {
99             length++;
100             temp >>= 8;
101         }
102         return toHexString(value, length);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
107      */
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 // File: @openzeppelin/contracts/access/Ownable.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Returns the address of the current owner.
154      */
155     function owner() public view virtual returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         require(owner() == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     /**
168      * @dev Leaves the contract without owner. It will not be possible to call
169      * `onlyOwner` functions anymore. Can only be called by the current owner.
170      *
171      * NOTE: Renouncing ownership will leave the contract without an owner,
172      * thereby removing any functionality that is only available to the owner.
173      */
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Internal function without access restriction.
190      */
191     function _transferOwnership(address newOwner) internal virtual {
192         address oldOwner = _owner;
193         _owner = newOwner;
194         emit OwnershipTransferred(oldOwner, newOwner);
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Address.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize, which returns 0 for contracts in
228         // construction, since the code is only stored at the end of the
229         // constructor execution.
230 
231         uint256 size;
232         assembly {
233             size := extcodesize(account)
234         }
235         return size > 0;
236     }
237 
238    
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     
247     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionCall(target, data, "Address: low-level call failed");
249     }
250 
251    
252     function functionCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, 0, errorMessage);
258     }
259 
260    
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269    
270     function functionCallWithValue(
271         address target,
272         bytes memory data,
273         uint256 value,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(address(this).balance >= value, "Address: insufficient balance for call");
277         require(isContract(target), "Address: call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.call{value: value}(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283    
284     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
285         return functionStaticCall(target, data, "Address: low-level static call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal view returns (bytes memory) {
299         require(isContract(target), "Address: static call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.staticcall(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(isContract(target), "Address: delegate call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.delegatecall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
334      * revert reason using the provided one.
335      *
336      * _Available since v4.3._
337      */
338     function verifyCallResult(
339         bool success,
340         bytes memory returndata,
341         string memory errorMessage
342     ) internal pure returns (bytes memory) {
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
361 
362 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Interface of the ERC165 standard, as defined in the
371  * https://eips.ethereum.org/EIPS/eip-165[EIP].
372  *
373  * Implementers can declare support of contract interfaces, which can then be
374  * queried by others ({ERC165Checker}).
375  *
376  * For an implementation, see {ERC165}.
377  */
378 interface IERC165 {
379     /**
380      * @dev Returns true if this contract implements the interface defined by
381      * `interfaceId`. See the corresponding
382      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
383      * to learn more about how these ids are created.
384      *
385      * This function call must use less than 30 000 gas.
386      */
387     function supportsInterface(bytes4 interfaceId) external view returns (bool);
388 }
389 
390 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Implementation of the {IERC165} interface.
400  *
401  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
402  * for the additional interface id that will be supported. For example:
403  *
404  * ```solidity
405  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
406  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
407  * }
408  * ```
409  *
410  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
411  */
412 abstract contract ERC165 is IERC165 {
413     /**
414      * @dev See {IERC165-supportsInterface}.
415      */
416     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
417         return interfaceId == type(IERC165).interfaceId;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @title ERC721 token receiver interface
430  * @dev Interface for any contract that wants to support safeTransfers
431  * from ERC721 asset contracts.
432  */
433 interface IERC721Receiver {
434     /**
435      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
436      * by `operator` from `from`, this function is called.
437      *
438      * It must return its Solidity selector to confirm the token transfer.
439      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
440      *
441      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
442      */
443     function onERC721Received(
444         address operator,
445         address from,
446         uint256 tokenId,
447         bytes calldata data
448     ) external returns (bytes4);
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Required interface of an ERC721 compliant contract.
461  */
462 interface IERC721 is IERC165 {
463     /**
464      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
465      */
466     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
470      */
471     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
475      */
476     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
477 
478     /**
479      * @dev Returns the number of tokens in ``owner``'s account.
480      */
481     function balanceOf(address owner) external view returns (uint256 balance);
482 
483     /**
484      * @dev Returns the owner of the `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function ownerOf(uint256 tokenId) external view returns (address owner);
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
494      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Transfers `tokenId` token from `from` to `to`.
514      *
515      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must be owned by `from`.
522      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
523      *
524      * Emits a {Transfer} event.
525      */
526     function transferFrom(
527         address from,
528         address to,
529         uint256 tokenId
530     ) external;
531 
532     /**
533      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
534      * The approval is cleared when the token is transferred.
535      *
536      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
537      *
538      * Requirements:
539      *
540      * - The caller must own the token or be an approved operator.
541      * - `tokenId` must exist.
542      *
543      * Emits an {Approval} event.
544      */
545     function approve(address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Returns the account approved for `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function getApproved(uint256 tokenId) external view returns (address operator);
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
570      *
571      * See {setApprovalForAll}
572      */
573     function isApprovedForAll(address owner, address operator) external view returns (bool);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId,
592         bytes calldata data
593     ) external;
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
606  * @dev See https://eips.ethereum.org/EIPS/eip-721
607  */
608 interface IERC721Enumerable is IERC721 {
609     /**
610      * @dev Returns the total amount of tokens stored by the contract.
611      */
612     function totalSupply() external view returns (uint256);
613 
614     /**
615      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
616      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
617      */
618     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
619 
620     /**
621      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
622      * Use along with {totalSupply} to enumerate all tokens.
623      */
624     function tokenByIndex(uint256 index) external view returns (uint256);
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 /**
636  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
637  * @dev See https://eips.ethereum.org/EIPS/eip-721
638  */
639 interface IERC721Metadata is IERC721 {
640     /**
641      * @dev Returns the token collection name.
642      */
643     function name() external view returns (string memory);
644 
645     /**
646      * @dev Returns the token collection symbol.
647      */
648     function symbol() external view returns (string memory);
649 
650     /**
651      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
652      */
653     function tokenURI(uint256 tokenId) external view returns (string memory);
654 }
655 
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
662  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
663  *
664  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
665  *
666  * Does not support burning tokens to address(0).
667  *
668  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
669  */
670 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
671     using Address for address;
672     using Strings for uint256;
673 
674     struct TokenOwnership {
675         address addr;
676         uint64 startTimestamp;
677     }
678 
679     struct AddressData {
680         uint128 balance;
681         uint128 numberMinted;
682     }
683 
684     uint256 internal currentIndex = 0;
685 
686     uint256 internal immutable maxBatchSize;
687 
688     // Token name
689     string private _name;
690 
691     // Token symbol
692     string private _symbol;
693 
694     // Mapping from token ID to ownership details
695     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
696     mapping(uint256 => TokenOwnership) internal _ownerships;
697 
698     // Mapping owner address to address data
699     mapping(address => AddressData) private _addressData;
700 
701     // Mapping from token ID to approved address
702     mapping(uint256 => address) private _tokenApprovals;
703 
704     // Mapping from owner to operator approvals
705     mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707     /**
708      * @dev
709      * `maxBatchSize` refers to how much a minter can mint at a time.
710      */
711     constructor(
712         string memory name_,
713         string memory symbol_,
714         uint256 maxBatchSize_
715     ) {
716         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
717         _name = name_;
718         _symbol = symbol_;
719         maxBatchSize = maxBatchSize_;
720     }
721 
722     /**
723      * @dev See {IERC721Enumerable-totalSupply}.
724      */
725     function totalSupply() public view override returns (uint256) {
726         return currentIndex;
727     }
728 
729     /**
730      * @dev See {IERC721Enumerable-tokenByIndex}.
731      */
732     function tokenByIndex(uint256 index) public view override returns (uint256) {
733         require(index < totalSupply(), 'ERC721A: global index out of bounds');
734         return index;
735     }
736 
737     /**
738      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
739      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
740      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
741      */
742     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
743         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
744         uint256 numMintedSoFar = totalSupply();
745         uint256 tokenIdsIdx = 0;
746         address currOwnershipAddr = address(0);
747         for (uint256 i = 0; i < numMintedSoFar; i++) {
748             TokenOwnership memory ownership = _ownerships[i];
749             if (ownership.addr != address(0)) {
750                 currOwnershipAddr = ownership.addr;
751             }
752             if (currOwnershipAddr == owner) {
753                 if (tokenIdsIdx == index) {
754                     return i;
755                 }
756                 tokenIdsIdx++;
757             }
758         }
759         revert('ERC721A: unable to get token of owner by index');
760     }
761 
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      */
765     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
766         return
767             interfaceId == type(IERC721).interfaceId ||
768             interfaceId == type(IERC721Metadata).interfaceId ||
769             interfaceId == type(IERC721Enumerable).interfaceId ||
770             super.supportsInterface(interfaceId);
771     }
772 
773     /**
774      * @dev See {IERC721-balanceOf}.
775      */
776     function balanceOf(address owner) public view override returns (uint256) {
777         require(owner != address(0), 'ERC721A: balance query for the zero address');
778         return uint256(_addressData[owner].balance);
779     }
780 
781     function _numberMinted(address owner) internal view returns (uint256) {
782         require(owner != address(0), 'ERC721A: number minted query for the zero address');
783         return uint256(_addressData[owner].numberMinted);
784     }
785 
786     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
787         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
788 
789         uint256 lowestTokenToCheck;
790         if (tokenId >= maxBatchSize) {
791             lowestTokenToCheck = tokenId - maxBatchSize + 1;
792         }
793 
794         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
795             TokenOwnership memory ownership = _ownerships[curr];
796             if (ownership.addr != address(0)) {
797                 return ownership;
798             }
799         }
800 
801         revert('ERC721A: unable to determine the owner of token');
802     }
803 
804     /**
805      * @dev See {IERC721-ownerOf}.
806      */
807     function ownerOf(uint256 tokenId) public view override returns (address) {
808         return ownershipOf(tokenId).addr;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-name}.
813      */
814     function name() public view virtual override returns (string memory) {
815         return _name;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-symbol}.
820      */
821     function symbol() public view virtual override returns (string memory) {
822         return _symbol;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-tokenURI}.
827      */
828     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
829         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
830 
831         string memory baseURI = _baseURI();
832         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
833     }
834 
835     /**
836      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
837      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
838      * by default, can be overriden in child contracts.
839      */
840     function _baseURI() internal view virtual returns (string memory) {
841         return '';
842     }
843 
844     /**
845      * @dev See {IERC721-approve}.
846      */
847     function approve(address to, uint256 tokenId) public override {
848         address owner = ERC721A.ownerOf(tokenId);
849         require(to != owner, 'ERC721A: approval to current owner');
850 
851         require(
852             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
853             'ERC721A: approve caller is not owner nor approved for all'
854         );
855 
856         _approve(to, tokenId, owner);
857     }
858 
859     /**
860      * @dev See {IERC721-getApproved}.
861      */
862     function getApproved(uint256 tokenId) public view override returns (address) {
863         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
864 
865         return _tokenApprovals[tokenId];
866     }
867 
868     /**
869      * @dev See {IERC721-setApprovalForAll}.
870      */
871     function setApprovalForAll(address operator, bool approved) public override {
872         require(operator != _msgSender(), 'ERC721A: approve to caller');
873 
874         _operatorApprovals[_msgSender()][operator] = approved;
875         emit ApprovalForAll(_msgSender(), operator, approved);
876     }
877 
878     /**
879      * @dev See {IERC721-isApprovedForAll}.
880      */
881     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev See {IERC721-transferFrom}.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public override {
893         _transfer(from, to, tokenId);
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public override {
904         safeTransferFrom(from, to, tokenId, '');
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) public override {
916         _transfer(from, to, tokenId);
917         require(
918             _checkOnERC721Received(from, to, tokenId, _data),
919             'ERC721A: transfer to non ERC721Receiver implementer'
920         );
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      */
930     function _exists(uint256 tokenId) internal view returns (bool) {
931         return tokenId < currentIndex;
932     }
933 
934     function _safeMint(address to, uint256 quantity) internal {
935         _safeMint(to, quantity, '');
936     }
937 
938     /**
939      * @dev Mints `quantity` tokens and transfers them to `to`.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `quantity` cannot be larger than the max batch size.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(
949         address to,
950         uint256 quantity,
951         bytes memory _data
952     ) internal {
953         uint256 startTokenId = currentIndex;
954         require(to != address(0), 'ERC721A: mint to the zero address');
955         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
956         require(!_exists(startTokenId), 'ERC721A: token already minted');
957         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
958         require(quantity > 0, 'ERC721A: quantity must be greater 0');
959 
960         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
961 
962         AddressData memory addressData = _addressData[to];
963         _addressData[to] = AddressData(
964             addressData.balance + uint128(quantity),
965             addressData.numberMinted + uint128(quantity)
966         );
967         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
968 
969         uint256 updatedIndex = startTokenId;
970 
971         for (uint256 i = 0; i < quantity; i++) {
972             emit Transfer(address(0), to, updatedIndex);
973             require(
974                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
975                 'ERC721A: transfer to non ERC721Receiver implementer'
976             );
977             updatedIndex++;
978         }
979 
980         currentIndex = updatedIndex;
981         _afterTokenTransfers(address(0), to, startTokenId, quantity);
982     }
983 
984     /**
985      * @dev Transfers `tokenId` from `from` to `to`.
986      *
987      * Requirements:
988      *
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must be owned by `from`.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _transfer(
995         address from,
996         address to,
997         uint256 tokenId
998     ) private {
999         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1000 
1001         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1002             getApproved(tokenId) == _msgSender() ||
1003             isApprovedForAll(prevOwnership.addr, _msgSender()));
1004 
1005         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1006 
1007         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1008         require(to != address(0), 'ERC721A: transfer to the zero address');
1009 
1010         _beforeTokenTransfers(from, to, tokenId, 1);
1011 
1012         // Clear approvals from the previous owner
1013         _approve(address(0), tokenId, prevOwnership.addr);
1014 
1015         // Underflow of the sender's balance is impossible because we check for
1016         // ownership above and the recipient's balance can't realistically overflow.
1017         unchecked {
1018             _addressData[from].balance -= 1;
1019             _addressData[to].balance += 1;
1020         }
1021 
1022         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1023 
1024         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1025         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1026         uint256 nextTokenId = tokenId + 1;
1027         if (_ownerships[nextTokenId].addr == address(0)) {
1028             if (_exists(nextTokenId)) {
1029                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1030             }
1031         }
1032 
1033         emit Transfer(from, to, tokenId);
1034         _afterTokenTransfers(from, to, tokenId, 1);
1035     }
1036 
1037     /**
1038      * @dev Approve `to` to operate on `tokenId`
1039      *
1040      * Emits a {Approval} event.
1041      */
1042     function _approve(
1043         address to,
1044         uint256 tokenId,
1045         address owner
1046     ) private {
1047         _tokenApprovals[tokenId] = to;
1048         emit Approval(owner, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1053      * The call is not executed if the target address is not a contract.
1054      *
1055      * @param from address representing the previous owner of the given token ID
1056      * @param to target address that will receive the tokens
1057      * @param tokenId uint256 ID of the token to be transferred
1058      * @param _data bytes optional data to send along with the call
1059      * @return bool whether the call correctly returned the expected magic value
1060      */
1061     function _checkOnERC721Received(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) private returns (bool) {
1067         if (to.isContract()) {
1068             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1069                 return retval == IERC721Receiver(to).onERC721Received.selector;
1070             } catch (bytes memory reason) {
1071                 if (reason.length == 0) {
1072                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1073                 } else {
1074                     assembly {
1075                         revert(add(32, reason), mload(reason))
1076                     }
1077                 }
1078             }
1079         } else {
1080             return true;
1081         }
1082     }
1083 
1084     /**
1085      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1086      *
1087      * startTokenId - the first token id to be transferred
1088      * quantity - the amount to be transferred
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      */
1096     function _beforeTokenTransfers(
1097         address from,
1098         address to,
1099         uint256 startTokenId,
1100         uint256 quantity
1101     ) internal virtual {}
1102 
1103     /**
1104      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1105      * minting.
1106      *
1107      * startTokenId - the first token id to be transferred
1108      * quantity - the amount to be transferred
1109      *
1110      * Calling conditions:
1111      *
1112      * - when `from` and `to` are both non-zero.
1113      * - `from` and `to` are never both zero.
1114      */
1115     function _afterTokenTransfers(
1116         address from,
1117         address to,
1118         uint256 startTokenId,
1119         uint256 quantity
1120     ) internal virtual {}
1121 }
1122 
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 contract SkeletonJump is ERC721A, Ownable {
1127   using Strings for uint256;
1128 
1129   string private uriPrefix = "";
1130   string private uriSuffix = ".json";
1131   string public hiddenMetadataUri;
1132   
1133   uint256 public price = 0 ether; 
1134   uint256 public maxSupply = 3333; 
1135   uint256 public maxMintAmountPerTx = 2; 
1136   
1137   bool public paused = false;
1138   bool public revealed = false;
1139   mapping(address => uint256) public addressMintedBalance;
1140 
1141 
1142   constructor() ERC721A("SkeletonJump", "$JUMP", maxMintAmountPerTx) {
1143     setHiddenMetadataUri("ipfs://Qmer2Ne2TjaRyD44QgmytXz87iLuRomFeK6D84opEKdQgi");
1144   }
1145 
1146   modifier mintCompliance(uint256 _mintAmount) {
1147     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1148     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1149     _;
1150   }
1151 
1152   
1153 
1154    
1155   function $jumptoadd(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1156     _safeMint(_to, _mintAmount);
1157   }
1158 function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1159    {
1160     require(!paused, "The contract is paused!");
1161     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1162     
1163     
1164     _safeMint(msg.sender, _mintAmount);
1165   }
1166  
1167   function walletOfOwner(address _owner)
1168     public
1169     view
1170     returns (uint256[] memory)
1171   {
1172     uint256 ownerTokenCount = balanceOf(_owner);
1173     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1174     uint256 currentTokenId = 0;
1175     uint256 ownedTokenIndex = 0;
1176 
1177     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1178       address currentTokenOwner = ownerOf(currentTokenId);
1179 
1180       if (currentTokenOwner == _owner) {
1181         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1182 
1183         ownedTokenIndex++;
1184       }
1185 
1186       currentTokenId++;
1187     }
1188 
1189     return ownedTokenIds;
1190   }
1191 
1192   function tokenURI(uint256 _tokenId)
1193     public
1194     view
1195     virtual
1196     override
1197     returns (string memory)
1198   {
1199     require(
1200       _exists(_tokenId),
1201       "ERC721Metadata: URI query for nonexistent token"
1202     );
1203 
1204     if (revealed == false) {
1205       return hiddenMetadataUri;
1206     }
1207 
1208     string memory currentBaseURI = _baseURI();
1209     return bytes(currentBaseURI).length > 0
1210         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1211         : "";
1212   }
1213 
1214   function setRevealed(bool _state) public onlyOwner {
1215     revealed = _state;
1216   
1217   }
1218 
1219   function setPrice(uint256 _price) public onlyOwner {
1220     price = _price;
1221 
1222   }
1223  
1224   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1225     hiddenMetadataUri = _hiddenMetadataUri;
1226   }
1227 
1228 
1229 
1230   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1231     uriPrefix = _uriPrefix;
1232   }
1233 
1234   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1235     uriSuffix = _uriSuffix;
1236   }
1237 
1238   function setPaused(bool _state) public onlyOwner {
1239     paused = _state;
1240   }
1241 
1242   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1243       _safeMint(_receiver, _mintAmount);
1244   }
1245 
1246   function _baseURI() internal view virtual override returns (string memory) {
1247     return uriPrefix;
1248     
1249   }
1250 
1251     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1252     maxMintAmountPerTx = _maxMintAmountPerTx;
1253 
1254   }
1255 
1256     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1257     maxSupply = _maxSupply;
1258 
1259   }
1260 
1261 
1262   // withdrawall addresses
1263   address t1 = 0x733369Cd27405Da929C2Dbf649233Dc2D4bdB529; 
1264   
1265 
1266   function withdrawall() public onlyOwner {
1267         uint256 _balance = address(this).balance;
1268         
1269         require(payable(t1).send(_balance * 100 / 100 ));
1270         
1271     }
1272 
1273   function withdraw() public onlyOwner {
1274     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1275     require(os);
1276     
1277 
1278  
1279   }
1280   
1281 }