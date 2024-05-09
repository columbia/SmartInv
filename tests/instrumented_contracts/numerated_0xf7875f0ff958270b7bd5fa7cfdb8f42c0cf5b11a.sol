1 // File: contracts/AnonymiceLibrary.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 library AnonymiceLibrary {
7     string internal constant TABLE =
8         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
9 
10     function encode(bytes memory data) internal pure returns (string memory) {
11         if (data.length == 0) return "";
12 
13         // load the table into memory
14         string memory table = TABLE;
15 
16         // multiply by 4/3 rounded up
17         uint256 encodedLen = 4 * ((data.length + 2) / 3);
18 
19         // add some extra buffer at the end required for the writing
20         string memory result = new string(encodedLen + 32);
21 
22         assembly {
23             // set the actual output length
24             mstore(result, encodedLen)
25 
26             // prepare the lookup table
27             let tablePtr := add(table, 1)
28 
29             // input ptr
30             let dataPtr := data
31             let endPtr := add(dataPtr, mload(data))
32 
33             // result ptr, jump over length
34             let resultPtr := add(result, 32)
35 
36             // run over the input, 3 bytes at a time
37             for {
38 
39             } lt(dataPtr, endPtr) {
40 
41             } {
42                 dataPtr := add(dataPtr, 3)
43 
44                 // read 3 bytes
45                 let input := mload(dataPtr)
46 
47                 // write 4 characters
48                 mstore(
49                     resultPtr,
50                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
51                 )
52                 resultPtr := add(resultPtr, 1)
53                 mstore(
54                     resultPtr,
55                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
56                 )
57                 resultPtr := add(resultPtr, 1)
58                 mstore(
59                     resultPtr,
60                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
61                 )
62                 resultPtr := add(resultPtr, 1)
63                 mstore(
64                     resultPtr,
65                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
66                 )
67                 resultPtr := add(resultPtr, 1)
68             }
69 
70             // padding with '='
71             switch mod(mload(data), 3)
72             case 1 {
73                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
74             }
75             case 2 {
76                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
77             }
78         }
79 
80         return result;
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     function parseInt(string memory _a)
106         internal
107         pure
108         returns (uint8 _parsedInt)
109     {
110         bytes memory bresult = bytes(_a);
111         uint8 mint = 0;
112         for (uint8 i = 0; i < bresult.length; i++) {
113             if (
114                 (uint8(uint8(bresult[i])) >= 48) &&
115                 (uint8(uint8(bresult[i])) <= 57)
116             ) {
117                 mint *= 10;
118                 mint += uint8(bresult[i]) - 48;
119             }
120         }
121         return mint;
122     }
123 
124     function substring(
125         string memory str,
126         uint256 startIndex,
127         uint256 endIndex
128     ) internal pure returns (string memory) {
129         bytes memory strBytes = bytes(str);
130         bytes memory result = new bytes(endIndex - startIndex);
131         for (uint256 i = startIndex; i < endIndex; i++) {
132             result[i - startIndex] = strBytes[i];
133         }
134         return string(result);
135     }
136 
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize, which returns 0 for contracts in
139         // construction, since the code is only stored at the end of the
140         // constructor execution.
141 
142         uint256 size;
143         assembly {
144             size := extcodesize(account)
145         }
146         return size > 0;
147     }
148 }
149 // File: contracts/interfaces/IAxonsAuctionHouse.sol
150 
151 
152 
153 /// @title Interface for Axons Auction Houses
154 
155 pragma solidity ^0.8.6;
156 
157 interface IAxonsAuctionHouse {
158     struct Auction {
159         // ID for the Axon (ERC721 token ID)
160         uint256 axonId;
161         // The current highest bid amount
162         uint256 amount;
163         // The time that the auction started
164         uint256 startTime;
165         // The time that the auction is scheduled to end
166         uint256 endTime;
167         // The address of the current highest bid
168         address payable bidder;
169         // Whether or not the auction has been settled
170         bool settled;
171         // The auction counter
172         uint256 counter;
173     }
174 
175     event AuctionCreated(uint256 indexed axonId, uint256 startTime, uint256 endTime);
176 
177     event AuctionBid(uint256 indexed axonId, address sender, uint256 value, bool extended);
178 
179     event AuctionExtended(uint256 indexed axonId, uint256 endTime);
180 
181     event AuctionSettled(uint256 indexed axonId, address winner, uint256 amount);
182 
183     event AuctionTimeBufferUpdated(uint256 timeBuffer);
184 
185     event AuctionReservePriceUpdated(uint256 reservePrice);
186 
187     event AuctionMinBidIncrementPercentageUpdated(uint256 minBidIncrementPercentage);
188 
189     function currentAuction() external view returns(IAxonsAuctionHouse.Auction memory);
190 
191     function settleAuction() external;
192 
193     function settleCurrentAndCreateNewAuction() external;
194 
195     function createBid(uint256 axonId, uint256 amount) external;
196 
197     function pause() external;
198 
199     function unpause() external;
200 
201     function setTimeBuffer(uint256 timeBuffer) external;
202 
203     function setReservePrice(uint256 reservePrice) external;
204 
205     function setMinBidIncrementPercentage(uint8 minBidIncrementPercentage) external;
206 }
207 // File: contracts/interfaces/IAxonsVoting.sol
208 
209 
210 
211 /// @title Interface for Axons Auction Houses
212 
213 pragma solidity ^0.8.6;
214 
215 interface IAxonsVoting {
216     struct Auction {
217         // ID for the Axon (ERC721 token ID)
218         uint256 axonId;
219         // The current highest bid amount
220         uint256 amount;
221         // The time that the auction started
222         uint256 startTime;
223         // The time that the auction is scheduled to end
224         uint256 endTime;
225         // The address of the current highest bid
226         address payable bidder;
227         // Whether or not the auction has been settled
228         bool settled;
229     }
230 
231     function currentWinnerForAuction(uint256 counter) external view returns (uint256);
232 
233     function setupVoting(uint256 auctionCounter) external;
234 }
235 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
236 
237 
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Interface of the ERC20 standard as defined in the EIP.
243  */
244 interface IERC20 {
245     /**
246      * @dev Returns the amount of tokens in existence.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns the amount of tokens owned by `account`.
252      */
253     function balanceOf(address account) external view returns (uint256);
254 
255     /**
256      * @dev Moves `amount` tokens from the caller's account to `recipient`.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transfer(address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Returns the remaining number of tokens that `spender` will be
266      * allowed to spend on behalf of `owner` through {transferFrom}. This is
267      * zero by default.
268      *
269      * This value changes when {approve} or {transferFrom} are called.
270      */
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * IMPORTANT: Beware that changing an allowance with this method brings the risk
279      * that someone may use both the old and the new allowance by unfortunate
280      * transaction ordering. One possible solution to mitigate this race
281      * condition is to first reduce the spender's allowance to 0 and set the
282      * desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address spender, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Moves `amount` tokens from `sender` to `recipient` using the
291      * allowance mechanism. `amount` is then deducted from the caller's
292      * allowance.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) external returns (bool);
303 
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 
319 // File: contracts/interfaces/IAxonsToken.sol
320 
321 
322 
323 /// @title Interface for AxonsToken
324 
325 pragma solidity ^0.8.6;
326 
327 
328 interface IAxonsToken is IERC20 {
329     event Claimed(address account, uint256 amount);
330     
331     function generateReward(address recipient, uint256 amount) external;
332     function isGenesisAddress(address addressToCheck) external view returns(bool);
333     function burn(uint256 amount) external;
334 }
335 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
363 
364 
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Required interface of an ERC721 compliant contract.
371  */
372 interface IERC721 is IERC165 {
373     /**
374      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
375      */
376     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
377 
378     /**
379      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
380      */
381     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
385      */
386     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
387 
388     /**
389      * @dev Returns the number of tokens in ``owner``'s account.
390      */
391     function balanceOf(address owner) external view returns (uint256 balance);
392 
393     /**
394      * @dev Returns the owner of the `tokenId` token.
395      *
396      * Requirements:
397      *
398      * - `tokenId` must exist.
399      */
400     function ownerOf(uint256 tokenId) external view returns (address owner);
401 
402     /**
403      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
404      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
405      *
406      * Requirements:
407      *
408      * - `from` cannot be the zero address.
409      * - `to` cannot be the zero address.
410      * - `tokenId` token must exist and be owned by `from`.
411      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
412      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) external;
421 
422     /**
423      * @dev Transfers `tokenId` token from `from` to `to`.
424      *
425      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must be owned by `from`.
432      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     /**
443      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
444      * The approval is cleared when the token is transferred.
445      *
446      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
447      *
448      * Requirements:
449      *
450      * - The caller must own the token or be an approved operator.
451      * - `tokenId` must exist.
452      *
453      * Emits an {Approval} event.
454      */
455     function approve(address to, uint256 tokenId) external;
456 
457     /**
458      * @dev Returns the account approved for `tokenId` token.
459      *
460      * Requirements:
461      *
462      * - `tokenId` must exist.
463      */
464     function getApproved(uint256 tokenId) external view returns (address operator);
465 
466     /**
467      * @dev Approve or remove `operator` as an operator for the caller.
468      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
469      *
470      * Requirements:
471      *
472      * - The `operator` cannot be the caller.
473      *
474      * Emits an {ApprovalForAll} event.
475      */
476     function setApprovalForAll(address operator, bool _approved) external;
477 
478     /**
479      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
480      *
481      * See {setApprovalForAll}
482      */
483     function isApprovedForAll(address owner, address operator) external view returns (bool);
484 
485     /**
486      * @dev Safely transfers `tokenId` token from `from` to `to`.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must exist and be owned by `from`.
493      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
494      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId,
502         bytes calldata data
503     ) external;
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
515  * @dev See https://eips.ethereum.org/EIPS/eip-721
516  */
517 interface IERC721Enumerable is IERC721 {
518     /**
519      * @dev Returns the total amount of tokens stored by the contract.
520      */
521     function totalSupply() external view returns (uint256);
522 
523     /**
524      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
525      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
526      */
527     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
528 
529     /**
530      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
531      * Use along with {totalSupply} to enumerate all tokens.
532      */
533     function tokenByIndex(uint256 index) external view returns (uint256);
534 }
535 
536 // File: contracts/interfaces/IAxons.sol
537 
538 
539 
540 /// @title Interface for Axons
541 
542 pragma solidity ^0.8.6;
543 
544 
545 interface IAxons is IERC721Enumerable {
546     event AxonCreated(uint256 indexed tokenId);
547     
548     event AxonBurned(uint256 indexed tokenId);
549 
550     event MinterUpdated(address minter);
551 
552     event MinterLocked();
553 
554     function mint(uint256 axonId) external returns (uint256);
555     
556     function burn(uint256 tokenId) external;
557 
558     function dataURI(uint256 tokenId) external returns (string memory);
559 
560     function setMinter(address minter) external;
561 
562     function lockMinter() external;
563 }
564 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
565 
566 
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
572  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
573  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
574  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
575  *
576  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
577  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
578  *
579  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
580  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
581  */
582 abstract contract Initializable {
583     /**
584      * @dev Indicates that the contract has been initialized.
585      */
586     bool private _initialized;
587 
588     /**
589      * @dev Indicates that the contract is in the process of being initialized.
590      */
591     bool private _initializing;
592 
593     /**
594      * @dev Modifier to protect an initializer function from being invoked twice.
595      */
596     modifier initializer() {
597         require(_initializing || !_initialized, "Initializable: contract is already initialized");
598 
599         bool isTopLevelCall = !_initializing;
600         if (isTopLevelCall) {
601             _initializing = true;
602             _initialized = true;
603         }
604 
605         _;
606 
607         if (isTopLevelCall) {
608             _initializing = false;
609         }
610     }
611 }
612 
613 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
614 
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Provides information about the current execution context, including the
622  * sender of the transaction and its data. While these are generally available
623  * via msg.sender and msg.data, they should not be accessed in such a direct
624  * manner, since when dealing with meta-transactions the account sending and
625  * paying for execution may not be the actual sender (as far as an application
626  * is concerned).
627  *
628  * This contract is only required for intermediate, library-like contracts.
629  */
630 abstract contract ContextUpgradeable is Initializable {
631     function __Context_init() internal initializer {
632         __Context_init_unchained();
633     }
634 
635     function __Context_init_unchained() internal initializer {
636     }
637     function _msgSender() internal view virtual returns (address) {
638         return msg.sender;
639     }
640 
641     function _msgData() internal view virtual returns (bytes calldata) {
642         return msg.data;
643     }
644     uint256[50] private __gap;
645 }
646 
647 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
648 
649 
650 
651 pragma solidity ^0.8.0;
652 
653 
654 
655 /**
656  * @dev Contract module which provides a basic access control mechanism, where
657  * there is an account (an owner) that can be granted exclusive access to
658  * specific functions.
659  *
660  * By default, the owner account will be the one that deploys the contract. This
661  * can later be changed with {transferOwnership}.
662  *
663  * This module is used through inheritance. It will make available the modifier
664  * `onlyOwner`, which can be applied to your functions to restrict their use to
665  * the owner.
666  */
667 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
668     address private _owner;
669 
670     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
671 
672     /**
673      * @dev Initializes the contract setting the deployer as the initial owner.
674      */
675     function __Ownable_init() internal initializer {
676         __Context_init_unchained();
677         __Ownable_init_unchained();
678     }
679 
680     function __Ownable_init_unchained() internal initializer {
681         _setOwner(_msgSender());
682     }
683 
684     /**
685      * @dev Returns the address of the current owner.
686      */
687     function owner() public view virtual returns (address) {
688         return _owner;
689     }
690 
691     /**
692      * @dev Throws if called by any account other than the owner.
693      */
694     modifier onlyOwner() {
695         require(owner() == _msgSender(), "Ownable: caller is not the owner");
696         _;
697     }
698 
699     /**
700      * @dev Leaves the contract without owner. It will not be possible to call
701      * `onlyOwner` functions anymore. Can only be called by the current owner.
702      *
703      * NOTE: Renouncing ownership will leave the contract without an owner,
704      * thereby removing any functionality that is only available to the owner.
705      */
706     function renounceOwnership() public virtual onlyOwner {
707         _setOwner(address(0));
708     }
709 
710     /**
711      * @dev Transfers ownership of the contract to a new account (`newOwner`).
712      * Can only be called by the current owner.
713      */
714     function transferOwnership(address newOwner) public virtual onlyOwner {
715         require(newOwner != address(0), "Ownable: new owner is the zero address");
716         _setOwner(newOwner);
717     }
718 
719     function _setOwner(address newOwner) private {
720         address oldOwner = _owner;
721         _owner = newOwner;
722         emit OwnershipTransferred(oldOwner, newOwner);
723     }
724     uint256[49] private __gap;
725 }
726 
727 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
728 
729 
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Contract module that helps prevent reentrant calls to a function.
736  *
737  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
738  * available, which can be applied to functions to make sure there are no nested
739  * (reentrant) calls to them.
740  *
741  * Note that because there is a single `nonReentrant` guard, functions marked as
742  * `nonReentrant` may not call one another. This can be worked around by making
743  * those functions `private`, and then adding `external` `nonReentrant` entry
744  * points to them.
745  *
746  * TIP: If you would like to learn more about reentrancy and alternative ways
747  * to protect against it, check out our blog post
748  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
749  */
750 abstract contract ReentrancyGuardUpgradeable is Initializable {
751     // Booleans are more expensive than uint256 or any type that takes up a full
752     // word because each write operation emits an extra SLOAD to first read the
753     // slot's contents, replace the bits taken up by the boolean, and then write
754     // back. This is the compiler's defense against contract upgrades and
755     // pointer aliasing, and it cannot be disabled.
756 
757     // The values being non-zero value makes deployment a bit more expensive,
758     // but in exchange the refund on every call to nonReentrant will be lower in
759     // amount. Since refunds are capped to a percentage of the total
760     // transaction's gas, it is best to keep them low in cases like this one, to
761     // increase the likelihood of the full refund coming into effect.
762     uint256 private constant _NOT_ENTERED = 1;
763     uint256 private constant _ENTERED = 2;
764 
765     uint256 private _status;
766 
767     function __ReentrancyGuard_init() internal initializer {
768         __ReentrancyGuard_init_unchained();
769     }
770 
771     function __ReentrancyGuard_init_unchained() internal initializer {
772         _status = _NOT_ENTERED;
773     }
774 
775     /**
776      * @dev Prevents a contract from calling itself, directly or indirectly.
777      * Calling a `nonReentrant` function from another `nonReentrant`
778      * function is not supported. It is possible to prevent this from happening
779      * by making the `nonReentrant` function external, and make it call a
780      * `private` function that does the actual work.
781      */
782     modifier nonReentrant() {
783         // On the first call to nonReentrant, _notEntered will be true
784         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
785 
786         // Any calls to nonReentrant after this point will fail
787         _status = _ENTERED;
788 
789         _;
790 
791         // By storing the original value once again, a refund is triggered (see
792         // https://eips.ethereum.org/EIPS/eip-2200)
793         _status = _NOT_ENTERED;
794     }
795     uint256[49] private __gap;
796 }
797 
798 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
799 
800 
801 
802 pragma solidity ^0.8.0;
803 
804 // CAUTION
805 // This version of SafeMath should only be used with Solidity 0.8 or later,
806 // because it relies on the compiler's built in overflow checks.
807 
808 /**
809  * @dev Wrappers over Solidity's arithmetic operations.
810  *
811  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
812  * now has built in overflow checking.
813  */
814 library SafeMath {
815     /**
816      * @dev Returns the addition of two unsigned integers, with an overflow flag.
817      *
818      * _Available since v3.4._
819      */
820     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
821         unchecked {
822             uint256 c = a + b;
823             if (c < a) return (false, 0);
824             return (true, c);
825         }
826     }
827 
828     /**
829      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
830      *
831      * _Available since v3.4._
832      */
833     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
834         unchecked {
835             if (b > a) return (false, 0);
836             return (true, a - b);
837         }
838     }
839 
840     /**
841      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
842      *
843      * _Available since v3.4._
844      */
845     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
846         unchecked {
847             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
848             // benefit is lost if 'b' is also tested.
849             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
850             if (a == 0) return (true, 0);
851             uint256 c = a * b;
852             if (c / a != b) return (false, 0);
853             return (true, c);
854         }
855     }
856 
857     /**
858      * @dev Returns the division of two unsigned integers, with a division by zero flag.
859      *
860      * _Available since v3.4._
861      */
862     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
863         unchecked {
864             if (b == 0) return (false, 0);
865             return (true, a / b);
866         }
867     }
868 
869     /**
870      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
871      *
872      * _Available since v3.4._
873      */
874     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
875         unchecked {
876             if (b == 0) return (false, 0);
877             return (true, a % b);
878         }
879     }
880 
881     /**
882      * @dev Returns the addition of two unsigned integers, reverting on
883      * overflow.
884      *
885      * Counterpart to Solidity's `+` operator.
886      *
887      * Requirements:
888      *
889      * - Addition cannot overflow.
890      */
891     function add(uint256 a, uint256 b) internal pure returns (uint256) {
892         return a + b;
893     }
894 
895     /**
896      * @dev Returns the subtraction of two unsigned integers, reverting on
897      * overflow (when the result is negative).
898      *
899      * Counterpart to Solidity's `-` operator.
900      *
901      * Requirements:
902      *
903      * - Subtraction cannot overflow.
904      */
905     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
906         return a - b;
907     }
908 
909     /**
910      * @dev Returns the multiplication of two unsigned integers, reverting on
911      * overflow.
912      *
913      * Counterpart to Solidity's `*` operator.
914      *
915      * Requirements:
916      *
917      * - Multiplication cannot overflow.
918      */
919     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
920         return a * b;
921     }
922 
923     /**
924      * @dev Returns the integer division of two unsigned integers, reverting on
925      * division by zero. The result is rounded towards zero.
926      *
927      * Counterpart to Solidity's `/` operator.
928      *
929      * Requirements:
930      *
931      * - The divisor cannot be zero.
932      */
933     function div(uint256 a, uint256 b) internal pure returns (uint256) {
934         return a / b;
935     }
936 
937     /**
938      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
939      * reverting when dividing by zero.
940      *
941      * Counterpart to Solidity's `%` operator. This function uses a `revert`
942      * opcode (which leaves remaining gas untouched) while Solidity uses an
943      * invalid opcode to revert (consuming all remaining gas).
944      *
945      * Requirements:
946      *
947      * - The divisor cannot be zero.
948      */
949     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
950         return a % b;
951     }
952 
953     /**
954      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
955      * overflow (when the result is negative).
956      *
957      * CAUTION: This function is deprecated because it requires allocating memory for the error
958      * message unnecessarily. For custom revert reasons use {trySub}.
959      *
960      * Counterpart to Solidity's `-` operator.
961      *
962      * Requirements:
963      *
964      * - Subtraction cannot overflow.
965      */
966     function sub(
967         uint256 a,
968         uint256 b,
969         string memory errorMessage
970     ) internal pure returns (uint256) {
971         unchecked {
972             require(b <= a, errorMessage);
973             return a - b;
974         }
975     }
976 
977     /**
978      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
979      * division by zero. The result is rounded towards zero.
980      *
981      * Counterpart to Solidity's `/` operator. Note: this function uses a
982      * `revert` opcode (which leaves remaining gas untouched) while Solidity
983      * uses an invalid opcode to revert (consuming all remaining gas).
984      *
985      * Requirements:
986      *
987      * - The divisor cannot be zero.
988      */
989     function div(
990         uint256 a,
991         uint256 b,
992         string memory errorMessage
993     ) internal pure returns (uint256) {
994         unchecked {
995             require(b > 0, errorMessage);
996             return a / b;
997         }
998     }
999 
1000     /**
1001      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1002      * reverting with custom message when dividing by zero.
1003      *
1004      * CAUTION: This function is deprecated because it requires allocating memory for the error
1005      * message unnecessarily. For custom revert reasons use {tryMod}.
1006      *
1007      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1008      * opcode (which leaves remaining gas untouched) while Solidity uses an
1009      * invalid opcode to revert (consuming all remaining gas).
1010      *
1011      * Requirements:
1012      *
1013      * - The divisor cannot be zero.
1014      */
1015     function mod(
1016         uint256 a,
1017         uint256 b,
1018         string memory errorMessage
1019     ) internal pure returns (uint256) {
1020         unchecked {
1021             require(b > 0, errorMessage);
1022             return a % b;
1023         }
1024     }
1025 }
1026 
1027 // File: contracts/AxonsVoting.sol
1028 
1029 
1030 
1031 /// @title The Axons auction house
1032 
1033 // LICENSE
1034 // AxonsAuctionHouse.sol is a modified version of NounsAuctionHouse.sol:
1035 // https://raw.githubusercontent.com/nounsDAO/nouns-monorepo/master/packages/nouns-contracts/contracts/NounsAuctionHouse.sol
1036 //
1037 // AuctionHouse.sol source code Copyright Zora licensed under the GPL-3.0 license.
1038 // With modifications by Axons.
1039 
1040 pragma solidity ^0.8.6;
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 
1049 
1050 
1051 contract AxonsVoting is IAxonsVoting, ReentrancyGuardUpgradeable, OwnableUpgradeable {
1052     using SafeMath for uint256;
1053     
1054     // The Axons ERC721 token contract
1055     IAxons public axons;
1056 
1057     IAxonsAuctionHouse public auctionHouse;
1058 
1059     // The address of the AxonToken contract
1060     address public axonsToken;
1061 
1062     // The address of the Filaments contract
1063     address public filaments = 0x0a57e26e480355510028b5310FD251df96e2274b;
1064 
1065     // The amount of time that must pass to re-register to vote with a specific Axon or Filament
1066     uint256 public registrationCooldown = 86400;
1067 
1068     // Voting
1069     mapping(uint256 => uint256[]) public currentAxonsNumbersForVotes;
1070     mapping(uint256 => uint256[]) public currentVotesForAxonNumbers;
1071     mapping(uint256 => uint256) public currentNumberOfVotes;
1072     mapping(uint256 => mapping(address => bool)) public votersForAuctionNumber;
1073     mapping(address => uint256) public votesToClaim;
1074     mapping(uint256 => bool) internal axonNumberToGenerated;
1075 
1076     // Voter registration
1077     mapping(uint256 => address) public registeredAxonToAddress;
1078     mapping(uint256 => address) public registeredFilamentToAddress;
1079     mapping(address => uint256) public registeredVoters;
1080     mapping(uint256 => uint256) public registeredAxonToTimestamp;
1081     mapping(uint256 => uint256) public registeredFilamentToTimestamp;
1082 
1083     /**
1084      * @notice Require that the sender is the auction house.
1085      */
1086     modifier onlyAuctionHouse() {
1087         require(msg.sender == address(auctionHouse), 'Sender is not the auction house');
1088         _;
1089     }
1090 
1091     /**
1092      * @notice Initialize the voting contracts,
1093      * @dev This function can only be called once.
1094      */
1095     function initialize(
1096         IAxons _axons,
1097         address _axonsToken,
1098         IAxonsAuctionHouse _auctionHouse
1099     ) external initializer {
1100         __ReentrancyGuard_init();
1101         __Ownable_init();
1102 
1103         axons = _axons;
1104         axonsToken = _axonsToken;
1105         auctionHouse = _auctionHouse;
1106     }
1107 
1108     /**
1109      * @dev Generates a random axon number
1110      * @param _a The address to be used within the hash.
1111      */
1112     function randomAxonNumber(
1113         address _a,
1114         uint256 _c
1115     ) internal returns (uint256) {
1116         uint256 _rand = uint256(
1117             uint256(
1118                 keccak256(
1119                     abi.encodePacked(
1120                         block.timestamp,
1121                         block.difficulty,
1122                         _a,
1123                         _c
1124                     )
1125                 )
1126             ) % 900719925474000
1127         );
1128 
1129         if (axonNumberToGenerated[_rand]) return randomAxonNumber(_a, _c + 1);
1130 
1131         axonNumberToGenerated[_rand] = true;
1132 
1133         return _rand;
1134     }
1135 
1136     function registerVoterWithFilament(uint256 tokenId) public {
1137         require(!AnonymiceLibrary.isContract(msg.sender)); // Prevent contracts because I don't know enough Solidity to comfortably allow them
1138         require(IERC721Enumerable(filaments).ownerOf(tokenId) == msg.sender, "Can't register for a Filament you don't own");
1139 
1140         address registeredAddress = registeredFilamentToAddress[tokenId]; // Get address that filament is currently registered to
1141         require(registeredAddress != msg.sender, "Already registered to you! Don't waste your gas");
1142         require(registeredFilamentToTimestamp[tokenId] == 0 || (block.timestamp > (registeredFilamentToTimestamp[tokenId] + registrationCooldown)), "Must wait a total of 24 hours to register to vote with this Filament");
1143 
1144         registeredFilamentToTimestamp[tokenId] = block.timestamp;
1145 
1146         registeredFilamentToAddress[tokenId] = msg.sender; // Register Filament to sender
1147         registeredVoters[msg.sender]++; // Register to vote
1148         
1149         if (registeredAddress == address(0)) {
1150             // Never been registered, return
1151             return;
1152         }
1153         
1154         // Remove registration from prior owner
1155         if (registeredVoters[registeredAddress] > 0) {
1156             registeredVoters[registeredAddress]--;
1157         }
1158     }
1159 
1160     function registerVoterWithAxon(uint256 tokenId) public {
1161         require(!AnonymiceLibrary.isContract(msg.sender)); // Prevent contracts because I don't know enough Solidity to comfortably allow them
1162         require(IAxons(axons).ownerOf(tokenId) == msg.sender, "Can't register for an Axon you don't own");
1163 
1164         address registeredAddress = registeredAxonToAddress[tokenId]; // Get address that axon is currently registered to
1165         require(registeredAddress != msg.sender, "Already registered to you! Don't waste your gas");
1166         require(registeredAxonToTimestamp[tokenId] == 0 || (block.timestamp > (registeredAxonToTimestamp[tokenId] + registrationCooldown)), "Must wait a total of 24 hours to register to vote with this Axon");
1167 
1168         registeredAxonToTimestamp[tokenId] = block.timestamp;
1169 
1170         registeredAxonToAddress[tokenId] = msg.sender; // Register Axon to sender
1171         registeredVoters[msg.sender]++; // Register to vote
1172         
1173         if (registeredAddress == address(0)) {
1174             // Never been registered, return
1175             return;
1176         }
1177 
1178         // Remove registration from prior owner
1179         if (registeredVoters[registeredAddress] > 0) {
1180             registeredVoters[registeredAddress]--;
1181         }
1182     }
1183 
1184     function vote(bool[10] memory votes, uint256 auctionCounter) public {
1185         require(votersForAuctionNumber[auctionCounter][msg.sender] == false, 'Can only vote once per day');
1186 
1187         IAxonsAuctionHouse.Auction memory _auction = auctionHouse.currentAuction();
1188         require(block.timestamp < _auction.endTime, 'Auction expired');
1189         require(auctionCounter == _auction.counter, 'Can only vote for current auction');
1190         require(!AnonymiceLibrary.isContract(msg.sender));
1191 
1192         require(registeredVoters[msg.sender] > 0 || IAxonsToken(axonsToken).isGenesisAddress(msg.sender), 'Must own a Filament or Axon (and register it to vote) or be a genesis $AXON holder to vote');
1193 
1194         // Record voting for today
1195         votersForAuctionNumber[auctionCounter][msg.sender] = true;
1196 
1197         // Add upvotes
1198         for (uint i=0; i<10; i++) {
1199             if (votes[i] == true) {
1200                 currentVotesForAxonNumbers[auctionCounter][i]++;
1201             }
1202         }
1203 
1204         // Track total votes
1205         currentNumberOfVotes[auctionCounter]++;
1206         votesToClaim[msg.sender]++;
1207     }
1208 
1209     function claimAxonToken() public {
1210         uint256 amount = votesToClaim[msg.sender];
1211         require(amount > 0,'No votes to claim');
1212         require(!AnonymiceLibrary.isContract(msg.sender));
1213 
1214         votesToClaim[msg.sender] = 0;
1215 
1216         // Distribute $AXON
1217         IAxonsToken(axonsToken).generateReward(msg.sender, amount);
1218     }
1219 
1220     /**
1221      * @dev Generates random axon numbers at the start of a day
1222      */
1223     function newAxonNumbersForVotes() internal returns (uint256[10] memory) {
1224         uint256[10] memory axonNumbers = [
1225                                 randomAxonNumber(address(this),3),
1226                                 randomAxonNumber(address(this),103),
1227                                 randomAxonNumber(address(this),203),
1228                                 randomAxonNumber(address(this),303),
1229                                 randomAxonNumber(address(this),403),
1230                                 randomAxonNumber(address(this),503),
1231                                 randomAxonNumber(address(this),603),
1232                                 randomAxonNumber(address(this),703),
1233                                 randomAxonNumber(address(this),803),
1234                                 randomAxonNumber(address(this),903)
1235                                 ];
1236         return axonNumbers;    
1237     }
1238 
1239     function currentWinnerForAuction(uint256 counter) external view override returns (uint256) {
1240         return _determineWinner(counter);
1241     }
1242 
1243     /**
1244      * @notice Determine winner by tallying votes
1245      */
1246     function _determineWinner(uint256 counter) internal view returns (uint256) {
1247         uint256 winner = currentAxonsNumbersForVotes[counter][0];
1248         uint256 highestVoteCount = 0;
1249 
1250         for (uint i=0; i<10; i++) {
1251             uint256 currentAxonNumber = currentAxonsNumbersForVotes[counter][i];
1252             uint256 currentVotesCount = currentVotesForAxonNumbers[counter][i];
1253 
1254             if (currentVotesCount > highestVoteCount) {
1255                 winner = currentAxonNumber;
1256                 highestVoteCount = currentVotesCount;
1257             }
1258         }
1259 
1260         return winner;
1261     }
1262 
1263     /**
1264      * @notice Set up voting for next auction period
1265      */
1266     function setupVoting(uint256 auctionCounter) external override onlyAuctionHouse {
1267         currentVotesForAxonNumbers[auctionCounter] = [0,0,0,0,0,0,0,0,0,0];
1268         currentAxonsNumbersForVotes[auctionCounter] = newAxonNumbersForVotes();
1269         currentNumberOfVotes[auctionCounter] = 0;
1270     }
1271 }