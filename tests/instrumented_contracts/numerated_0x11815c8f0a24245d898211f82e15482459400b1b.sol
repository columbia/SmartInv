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
149 // File: contracts/interfaces/IAxonsVoting.sol
150 
151 
152 
153 /// @title Interface for Axons Auction Houses
154 
155 pragma solidity ^0.8.6;
156 
157 interface IAxonsVoting {
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
171     }
172 
173     function currentWinnerForAuction(uint256 counter) external view returns (uint256);
174 
175     function setupVoting(uint256 auctionCounter) external;
176 }
177 // File: contracts/interfaces/IAxonsAuctionHouse.sol
178 
179 
180 
181 /// @title Interface for Axons Auction Houses
182 
183 pragma solidity ^0.8.6;
184 
185 interface IAxonsAuctionHouse {
186     struct Auction {
187         // ID for the Axon (ERC721 token ID)
188         uint256 axonId;
189         // The current highest bid amount
190         uint256 amount;
191         // The time that the auction started
192         uint256 startTime;
193         // The time that the auction is scheduled to end
194         uint256 endTime;
195         // The address of the current highest bid
196         address payable bidder;
197         // Whether or not the auction has been settled
198         bool settled;
199         // The auction counter
200         uint256 counter;
201     }
202 
203     event AuctionCreated(uint256 indexed axonId, uint256 startTime, uint256 endTime);
204 
205     event AuctionBid(uint256 indexed axonId, address sender, uint256 value, bool extended);
206 
207     event AuctionExtended(uint256 indexed axonId, uint256 endTime);
208 
209     event AuctionSettled(uint256 indexed axonId, address winner, uint256 amount);
210 
211     event AuctionTimeBufferUpdated(uint256 timeBuffer);
212 
213     event AuctionReservePriceUpdated(uint256 reservePrice);
214 
215     event AuctionMinBidIncrementPercentageUpdated(uint256 minBidIncrementPercentage);
216 
217     function currentAuction() external view returns(IAxonsAuctionHouse.Auction memory);
218 
219     function settleAuction() external;
220 
221     function settleCurrentAndCreateNewAuction() external;
222 
223     function createBid(uint256 axonId, uint256 amount) external;
224 
225     function pause() external;
226 
227     function unpause() external;
228 
229     function setTimeBuffer(uint256 timeBuffer) external;
230 
231     function setReservePrice(uint256 reservePrice) external;
232 
233     function setMinBidIncrementPercentage(uint8 minBidIncrementPercentage) external;
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
613 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
614 
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Contract module that helps prevent reentrant calls to a function.
622  *
623  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
624  * available, which can be applied to functions to make sure there are no nested
625  * (reentrant) calls to them.
626  *
627  * Note that because there is a single `nonReentrant` guard, functions marked as
628  * `nonReentrant` may not call one another. This can be worked around by making
629  * those functions `private`, and then adding `external` `nonReentrant` entry
630  * points to them.
631  *
632  * TIP: If you would like to learn more about reentrancy and alternative ways
633  * to protect against it, check out our blog post
634  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
635  */
636 abstract contract ReentrancyGuardUpgradeable is Initializable {
637     // Booleans are more expensive than uint256 or any type that takes up a full
638     // word because each write operation emits an extra SLOAD to first read the
639     // slot's contents, replace the bits taken up by the boolean, and then write
640     // back. This is the compiler's defense against contract upgrades and
641     // pointer aliasing, and it cannot be disabled.
642 
643     // The values being non-zero value makes deployment a bit more expensive,
644     // but in exchange the refund on every call to nonReentrant will be lower in
645     // amount. Since refunds are capped to a percentage of the total
646     // transaction's gas, it is best to keep them low in cases like this one, to
647     // increase the likelihood of the full refund coming into effect.
648     uint256 private constant _NOT_ENTERED = 1;
649     uint256 private constant _ENTERED = 2;
650 
651     uint256 private _status;
652 
653     function __ReentrancyGuard_init() internal initializer {
654         __ReentrancyGuard_init_unchained();
655     }
656 
657     function __ReentrancyGuard_init_unchained() internal initializer {
658         _status = _NOT_ENTERED;
659     }
660 
661     /**
662      * @dev Prevents a contract from calling itself, directly or indirectly.
663      * Calling a `nonReentrant` function from another `nonReentrant`
664      * function is not supported. It is possible to prevent this from happening
665      * by making the `nonReentrant` function external, and make it call a
666      * `private` function that does the actual work.
667      */
668     modifier nonReentrant() {
669         // On the first call to nonReentrant, _notEntered will be true
670         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
671 
672         // Any calls to nonReentrant after this point will fail
673         _status = _ENTERED;
674 
675         _;
676 
677         // By storing the original value once again, a refund is triggered (see
678         // https://eips.ethereum.org/EIPS/eip-2200)
679         _status = _NOT_ENTERED;
680     }
681     uint256[49] private __gap;
682 }
683 
684 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
685 
686 
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @dev Provides information about the current execution context, including the
693  * sender of the transaction and its data. While these are generally available
694  * via msg.sender and msg.data, they should not be accessed in such a direct
695  * manner, since when dealing with meta-transactions the account sending and
696  * paying for execution may not be the actual sender (as far as an application
697  * is concerned).
698  *
699  * This contract is only required for intermediate, library-like contracts.
700  */
701 abstract contract ContextUpgradeable is Initializable {
702     function __Context_init() internal initializer {
703         __Context_init_unchained();
704     }
705 
706     function __Context_init_unchained() internal initializer {
707     }
708     function _msgSender() internal view virtual returns (address) {
709         return msg.sender;
710     }
711 
712     function _msgData() internal view virtual returns (bytes calldata) {
713         return msg.data;
714     }
715     uint256[50] private __gap;
716 }
717 
718 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
719 
720 
721 
722 pragma solidity ^0.8.0;
723 
724 
725 
726 /**
727  * @dev Contract module which provides a basic access control mechanism, where
728  * there is an account (an owner) that can be granted exclusive access to
729  * specific functions.
730  *
731  * By default, the owner account will be the one that deploys the contract. This
732  * can later be changed with {transferOwnership}.
733  *
734  * This module is used through inheritance. It will make available the modifier
735  * `onlyOwner`, which can be applied to your functions to restrict their use to
736  * the owner.
737  */
738 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
739     address private _owner;
740 
741     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
742 
743     /**
744      * @dev Initializes the contract setting the deployer as the initial owner.
745      */
746     function __Ownable_init() internal initializer {
747         __Context_init_unchained();
748         __Ownable_init_unchained();
749     }
750 
751     function __Ownable_init_unchained() internal initializer {
752         _setOwner(_msgSender());
753     }
754 
755     /**
756      * @dev Returns the address of the current owner.
757      */
758     function owner() public view virtual returns (address) {
759         return _owner;
760     }
761 
762     /**
763      * @dev Throws if called by any account other than the owner.
764      */
765     modifier onlyOwner() {
766         require(owner() == _msgSender(), "Ownable: caller is not the owner");
767         _;
768     }
769 
770     /**
771      * @dev Leaves the contract without owner. It will not be possible to call
772      * `onlyOwner` functions anymore. Can only be called by the current owner.
773      *
774      * NOTE: Renouncing ownership will leave the contract without an owner,
775      * thereby removing any functionality that is only available to the owner.
776      */
777     function renounceOwnership() public virtual onlyOwner {
778         _setOwner(address(0));
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
783      * Can only be called by the current owner.
784      */
785     function transferOwnership(address newOwner) public virtual onlyOwner {
786         require(newOwner != address(0), "Ownable: new owner is the zero address");
787         _setOwner(newOwner);
788     }
789 
790     function _setOwner(address newOwner) private {
791         address oldOwner = _owner;
792         _owner = newOwner;
793         emit OwnershipTransferred(oldOwner, newOwner);
794     }
795     uint256[49] private __gap;
796 }
797 
798 // File: @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol
799 
800 
801 
802 pragma solidity ^0.8.0;
803 
804 
805 
806 /**
807  * @dev Contract module which allows children to implement an emergency stop
808  * mechanism that can be triggered by an authorized account.
809  *
810  * This module is used through inheritance. It will make available the
811  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
812  * the functions of your contract. Note that they will not be pausable by
813  * simply including this module, only once the modifiers are put in place.
814  */
815 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
816     /**
817      * @dev Emitted when the pause is triggered by `account`.
818      */
819     event Paused(address account);
820 
821     /**
822      * @dev Emitted when the pause is lifted by `account`.
823      */
824     event Unpaused(address account);
825 
826     bool private _paused;
827 
828     /**
829      * @dev Initializes the contract in unpaused state.
830      */
831     function __Pausable_init() internal initializer {
832         __Context_init_unchained();
833         __Pausable_init_unchained();
834     }
835 
836     function __Pausable_init_unchained() internal initializer {
837         _paused = false;
838     }
839 
840     /**
841      * @dev Returns true if the contract is paused, and false otherwise.
842      */
843     function paused() public view virtual returns (bool) {
844         return _paused;
845     }
846 
847     /**
848      * @dev Modifier to make a function callable only when the contract is not paused.
849      *
850      * Requirements:
851      *
852      * - The contract must not be paused.
853      */
854     modifier whenNotPaused() {
855         require(!paused(), "Pausable: paused");
856         _;
857     }
858 
859     /**
860      * @dev Modifier to make a function callable only when the contract is paused.
861      *
862      * Requirements:
863      *
864      * - The contract must be paused.
865      */
866     modifier whenPaused() {
867         require(paused(), "Pausable: not paused");
868         _;
869     }
870 
871     /**
872      * @dev Triggers stopped state.
873      *
874      * Requirements:
875      *
876      * - The contract must not be paused.
877      */
878     function _pause() internal virtual whenNotPaused {
879         _paused = true;
880         emit Paused(_msgSender());
881     }
882 
883     /**
884      * @dev Returns to normal state.
885      *
886      * Requirements:
887      *
888      * - The contract must be paused.
889      */
890     function _unpause() internal virtual whenPaused {
891         _paused = false;
892         emit Unpaused(_msgSender());
893     }
894     uint256[49] private __gap;
895 }
896 
897 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
898 
899 
900 
901 pragma solidity ^0.8.0;
902 
903 // CAUTION
904 // This version of SafeMath should only be used with Solidity 0.8 or later,
905 // because it relies on the compiler's built in overflow checks.
906 
907 /**
908  * @dev Wrappers over Solidity's arithmetic operations.
909  *
910  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
911  * now has built in overflow checking.
912  */
913 library SafeMath {
914     /**
915      * @dev Returns the addition of two unsigned integers, with an overflow flag.
916      *
917      * _Available since v3.4._
918      */
919     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
920         unchecked {
921             uint256 c = a + b;
922             if (c < a) return (false, 0);
923             return (true, c);
924         }
925     }
926 
927     /**
928      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
929      *
930      * _Available since v3.4._
931      */
932     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
933         unchecked {
934             if (b > a) return (false, 0);
935             return (true, a - b);
936         }
937     }
938 
939     /**
940      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
941      *
942      * _Available since v3.4._
943      */
944     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
945         unchecked {
946             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
947             // benefit is lost if 'b' is also tested.
948             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
949             if (a == 0) return (true, 0);
950             uint256 c = a * b;
951             if (c / a != b) return (false, 0);
952             return (true, c);
953         }
954     }
955 
956     /**
957      * @dev Returns the division of two unsigned integers, with a division by zero flag.
958      *
959      * _Available since v3.4._
960      */
961     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
962         unchecked {
963             if (b == 0) return (false, 0);
964             return (true, a / b);
965         }
966     }
967 
968     /**
969      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
970      *
971      * _Available since v3.4._
972      */
973     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
974         unchecked {
975             if (b == 0) return (false, 0);
976             return (true, a % b);
977         }
978     }
979 
980     /**
981      * @dev Returns the addition of two unsigned integers, reverting on
982      * overflow.
983      *
984      * Counterpart to Solidity's `+` operator.
985      *
986      * Requirements:
987      *
988      * - Addition cannot overflow.
989      */
990     function add(uint256 a, uint256 b) internal pure returns (uint256) {
991         return a + b;
992     }
993 
994     /**
995      * @dev Returns the subtraction of two unsigned integers, reverting on
996      * overflow (when the result is negative).
997      *
998      * Counterpart to Solidity's `-` operator.
999      *
1000      * Requirements:
1001      *
1002      * - Subtraction cannot overflow.
1003      */
1004     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1005         return a - b;
1006     }
1007 
1008     /**
1009      * @dev Returns the multiplication of two unsigned integers, reverting on
1010      * overflow.
1011      *
1012      * Counterpart to Solidity's `*` operator.
1013      *
1014      * Requirements:
1015      *
1016      * - Multiplication cannot overflow.
1017      */
1018     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1019         return a * b;
1020     }
1021 
1022     /**
1023      * @dev Returns the integer division of two unsigned integers, reverting on
1024      * division by zero. The result is rounded towards zero.
1025      *
1026      * Counterpart to Solidity's `/` operator.
1027      *
1028      * Requirements:
1029      *
1030      * - The divisor cannot be zero.
1031      */
1032     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1033         return a / b;
1034     }
1035 
1036     /**
1037      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1038      * reverting when dividing by zero.
1039      *
1040      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1041      * opcode (which leaves remaining gas untouched) while Solidity uses an
1042      * invalid opcode to revert (consuming all remaining gas).
1043      *
1044      * Requirements:
1045      *
1046      * - The divisor cannot be zero.
1047      */
1048     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1049         return a % b;
1050     }
1051 
1052     /**
1053      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1054      * overflow (when the result is negative).
1055      *
1056      * CAUTION: This function is deprecated because it requires allocating memory for the error
1057      * message unnecessarily. For custom revert reasons use {trySub}.
1058      *
1059      * Counterpart to Solidity's `-` operator.
1060      *
1061      * Requirements:
1062      *
1063      * - Subtraction cannot overflow.
1064      */
1065     function sub(
1066         uint256 a,
1067         uint256 b,
1068         string memory errorMessage
1069     ) internal pure returns (uint256) {
1070         unchecked {
1071             require(b <= a, errorMessage);
1072             return a - b;
1073         }
1074     }
1075 
1076     /**
1077      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1078      * division by zero. The result is rounded towards zero.
1079      *
1080      * Counterpart to Solidity's `/` operator. Note: this function uses a
1081      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1082      * uses an invalid opcode to revert (consuming all remaining gas).
1083      *
1084      * Requirements:
1085      *
1086      * - The divisor cannot be zero.
1087      */
1088     function div(
1089         uint256 a,
1090         uint256 b,
1091         string memory errorMessage
1092     ) internal pure returns (uint256) {
1093         unchecked {
1094             require(b > 0, errorMessage);
1095             return a / b;
1096         }
1097     }
1098 
1099     /**
1100      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1101      * reverting with custom message when dividing by zero.
1102      *
1103      * CAUTION: This function is deprecated because it requires allocating memory for the error
1104      * message unnecessarily. For custom revert reasons use {tryMod}.
1105      *
1106      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1107      * opcode (which leaves remaining gas untouched) while Solidity uses an
1108      * invalid opcode to revert (consuming all remaining gas).
1109      *
1110      * Requirements:
1111      *
1112      * - The divisor cannot be zero.
1113      */
1114     function mod(
1115         uint256 a,
1116         uint256 b,
1117         string memory errorMessage
1118     ) internal pure returns (uint256) {
1119         unchecked {
1120             require(b > 0, errorMessage);
1121             return a % b;
1122         }
1123     }
1124 }
1125 
1126 // File: contracts/AxonsAuctionHouse.sol
1127 
1128 
1129 
1130 /// @title The Axons auction house
1131 
1132 // LICENSE
1133 // AxonsAuctionHouse.sol is a modified version of NounsAuctionHouse.sol:
1134 // https://raw.githubusercontent.com/nounsDAO/nouns-monorepo/master/packages/nouns-contracts/contracts/NounsAuctionHouse.sol
1135 //
1136 // AuctionHouse.sol source code Copyright Zora licensed under the GPL-3.0 license.
1137 // With modifications by Axons.
1138 
1139 pragma solidity ^0.8.6;
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 
1150 
1151 contract AxonsAuctionHouse is IAxonsAuctionHouse, PausableUpgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable {
1152     using SafeMath for uint256;
1153     
1154     // The Axons ERC721 token contract
1155     IAxons public axons;
1156 
1157     // The voting contract
1158     IAxonsVoting public axonsVoting;
1159 
1160     // The address of the AxonToken contract
1161     address public axonsToken;
1162 
1163     // The minimum amount of time left in an auction after a new bid is created
1164     uint256 public timeBuffer;
1165 
1166     // The minimum price accepted in an auction
1167     uint256 public reservePrice;
1168 
1169     // The minimum percentage difference between the last bid amount and the current bid
1170     uint8 public minBidIncrementPercentage;
1171 
1172     // The duration of a single auction
1173     uint256 public duration;
1174 
1175     // Auction counter
1176     uint256 public auctionCounter = 0;
1177 
1178     // The active auction
1179     IAxonsAuctionHouse.Auction public auction;
1180 
1181     /**
1182      * @notice Initialize the auction house and base contracts,
1183      * populate configuration values, and pause the contract.
1184      * @dev This function can only be called once.
1185      */
1186     function initialize(
1187         IAxons _axons,
1188         IAxonsVoting _axonsVoting,
1189         address _axonsToken,
1190         uint256 _timeBuffer,
1191         uint256 _reservePrice,
1192         uint8 _minBidIncrementPercentage,
1193         uint256 _duration
1194     ) external initializer {
1195         __Pausable_init();
1196         __ReentrancyGuard_init();
1197         __Ownable_init();
1198 
1199         _pause();
1200 
1201         axons = _axons;
1202         axonsToken = _axonsToken;
1203         axonsVoting = _axonsVoting;
1204         timeBuffer = _timeBuffer;
1205         reservePrice = _reservePrice * 10**18;
1206         minBidIncrementPercentage = _minBidIncrementPercentage;
1207         duration = _duration;
1208     }
1209 
1210     function currentAuction() external view override returns(IAxonsAuctionHouse.Auction memory) {
1211         IAxonsAuctionHouse.Auction memory _auction = auction;
1212         return _auction;
1213     }
1214 
1215     /**
1216      * @dev Generates a random axon number
1217      * @param _a The address to be used within the hash.
1218      */
1219     function randomAxonNumber(
1220         address _a,
1221         uint256 _c
1222     ) internal view returns (uint256) {
1223         uint256 _rand = uint256(
1224             uint256(
1225                 keccak256(
1226                     abi.encodePacked(
1227                         block.timestamp,
1228                         block.difficulty,
1229                         _a,
1230                         _c
1231                     )
1232                 )
1233             ) % 900719925474000
1234         );
1235 
1236         return _rand;
1237     }
1238 
1239     /**
1240      * @notice Settle the current auction, mint a new Axon, and put it up for auction.
1241      */
1242     function settleCurrentAndCreateNewAuction() external override nonReentrant whenNotPaused {
1243         IAxonsAuctionHouse.Auction memory _auction = auction;
1244         _settleAuction();
1245         uint256 nextAxonNumber = IAxonsVoting(axonsVoting).currentWinnerForAuction(_auction.counter);
1246         _createAuction(nextAxonNumber);
1247         IAxonsVoting(axonsVoting).setupVoting(_auction.counter+1);
1248     }
1249 
1250     /**
1251      * @notice Settle the current auction.
1252      * @dev This function can only be called when the contract is paused.
1253      */
1254     function settleAuction() external override whenPaused nonReentrant onlyOwner {
1255         _settleAuction();
1256     }
1257 
1258     /**
1259      * @notice Create a bid for an Axon, with a given amount.
1260      * @dev This contract only accepts payment in $AXON.
1261      */
1262     function createBid(uint256 axonId, uint256 amount) external override nonReentrant {
1263         IAxonsAuctionHouse.Auction memory _auction = auction;
1264 
1265         require(_auction.axonId == axonId, 'Axon not up for auction');
1266         require(block.timestamp < _auction.endTime, 'Auction expired');
1267         require(amount >= reservePrice, 'Must send at least reservePrice');
1268         require(
1269             amount >= _auction.amount + ((_auction.amount * minBidIncrementPercentage) / 100),
1270             'Must send more than last bid by minBidIncrementPercentage amount'
1271         );
1272 
1273         address payable lastBidder = _auction.bidder;
1274 
1275         // Refund the last bidder, if applicable
1276         if (lastBidder != address(0)) {
1277             IAxonsToken(axonsToken).transferFrom(address(this), lastBidder, _auction.amount);
1278         }
1279         
1280         // We must check the balance that was actually transferred to the auction,
1281         // as some tokens impose a transfer fee and would not actually transfer the
1282         // full amount to the market, resulting in potentally locked funds
1283         IAxonsToken token = IAxonsToken(axonsToken);
1284         uint256 beforeBalance = token.balanceOf(address(this));
1285         token.transferFrom(msg.sender, address(this), amount);
1286         uint256 afterBalance = token.balanceOf(address(this));
1287         require(beforeBalance.add(amount) == afterBalance, "Token transfer call did not transfer expected amount");
1288 
1289         auction.amount = amount;
1290         auction.bidder = payable(msg.sender);
1291 
1292         // Extend the auction if the bid was received within `timeBuffer` of the auction end time
1293         bool extended = _auction.endTime - block.timestamp < timeBuffer;
1294         if (extended) {
1295             auction.endTime = _auction.endTime = block.timestamp + timeBuffer;
1296         }
1297 
1298         emit AuctionBid(_auction.axonId, msg.sender, amount, extended);
1299 
1300         if (extended) {
1301             emit AuctionExtended(_auction.axonId, _auction.endTime);
1302         }
1303     }
1304 
1305     /**
1306      * @notice Pause the Axons auction house.
1307      * @dev This function can only be called by the owner when the
1308      * contract is unpaused. While no new auctions can be started when paused,
1309      * anyone can settle an ongoing auction.
1310      */
1311     function pause() external override onlyOwner {
1312         _pause();
1313     }
1314 
1315     /**
1316      * @notice Unpause the Axons auction house.
1317      * @dev This function can only be called by the owner when the
1318      * contract is paused. If required, this function will start a new auction.
1319      */
1320     function unpause() external override onlyOwner {
1321         _unpause();
1322 
1323         if (auction.startTime == 0 || auction.settled) {
1324             _createAuction(randomAxonNumber(address(this),69420));
1325             IAxonsAuctionHouse.Auction memory _auction = auction;
1326             IAxonsVoting(axonsVoting).setupVoting(_auction.counter);
1327         }
1328     }
1329 
1330     /**
1331      * @notice Set the auction time buffer.
1332      * @dev Only callable by the owner.
1333      */
1334     function setTimeBuffer(uint256 _timeBuffer) external override onlyOwner {
1335         timeBuffer = _timeBuffer;
1336 
1337         emit AuctionTimeBufferUpdated(_timeBuffer);
1338     }
1339 
1340     /**
1341      * @notice Set the auction reserve price.
1342      * @dev Only callable by the owner.
1343      */
1344     function setReservePrice(uint256 _reservePrice) external override onlyOwner {
1345         reservePrice = _reservePrice;
1346 
1347         emit AuctionReservePriceUpdated(_reservePrice);
1348     }
1349 
1350     /**
1351      * @notice Set the auction minimum bid increment percentage.
1352      * @dev Only callable by the owner.
1353      */
1354     function setMinBidIncrementPercentage(uint8 _minBidIncrementPercentage) external override onlyOwner {
1355         minBidIncrementPercentage = _minBidIncrementPercentage;
1356 
1357         emit AuctionMinBidIncrementPercentageUpdated(_minBidIncrementPercentage);
1358     }
1359 
1360     /**
1361      * @notice Create an auction.
1362      * @dev Store the auction details in the `auction` state variable and emit an AuctionCreated event.
1363      * If the mint reverts, the minter was updated without pausing this contract first. To remedy this,
1364      * catch the revert and pause this contract.
1365      */
1366     function _createAuction(uint256 axonId) internal {
1367         try axons.mint(axonId) returns (uint256 tokenId) {
1368             uint256 startTime = block.timestamp;
1369             uint256 endTime = startTime + duration;
1370 
1371             auction = Auction({
1372                 axonId: tokenId,
1373                 amount: 0,
1374                 startTime: startTime,
1375                 endTime: endTime,
1376                 bidder: payable(0),
1377                 settled: false,
1378                 counter: auctionCounter
1379             });
1380 
1381             emit AuctionCreated(axonId, startTime, endTime);
1382 
1383             auctionCounter++;
1384         } catch Error(string memory) {
1385             _pause();
1386         }
1387     }
1388 
1389     /**
1390      * @notice Settle an auction, finalizing the bid and paying out to the owner.
1391      * @dev If there are no bids, the Axon is burned.
1392      */
1393     function _settleAuction() internal {
1394         IAxonsAuctionHouse.Auction memory _auction = auction;
1395 
1396         require(_auction.startTime != 0, "Auction hasn't begun");
1397         require(!_auction.settled, 'Auction has already been settled');
1398         require(block.timestamp >= _auction.endTime, "Auction hasn't completed");
1399 
1400         auction.settled = true;
1401 
1402         if (_auction.bidder == address(0)) {
1403             axons.burn(_auction.axonId);
1404         } else {
1405             axons.transferFrom(address(this), _auction.bidder, _auction.axonId);
1406         }
1407 
1408         if (_auction.amount > 0) {
1409             IAxonsToken(axonsToken).transferFrom(address(this), msg.sender, 1 * 10**18);
1410             IAxonsToken(axonsToken).burn(_auction.amount - (1 * 10**18));
1411         }
1412 
1413         emit AuctionSettled(_auction.axonId, _auction.bidder, _auction.amount);
1414     }
1415 }