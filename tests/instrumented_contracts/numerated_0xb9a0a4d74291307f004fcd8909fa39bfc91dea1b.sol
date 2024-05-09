1 // File: ShuffleSale/ShuffleSale/Shuffler.sol
2 
3 
4 // Copyright (c) 2023 Fellowship
5 
6 pragma solidity ^0.8.20;
7 
8 /// @notice A contract that draws (without replacement) pseudorandom shuffled values
9 /// @dev Uses prevrandao and Fisher-Yates shuffle to return values one at a time
10 contract Shuffler {
11     uint256 internal remainingValueCount;
12     /// @notice Mapping that lets `drawNext` find values that are still available
13     /// @dev This is effectively the Fisher-Yates in-place array. Zero values stand in for their key to avoid costly
14     ///  initialization. All other values are off-by-one so that zero can be represented. Keys from remainingValueCount
15     ///  onward have their values set back to zero since they aren't needed once they've been drawn.
16     mapping(uint256 => uint256) private shuffleValues;
17 
18     constructor(uint256 shuffleSize) {
19         // CHECKS
20         require(shuffleSize <= type(uint16).max, "Shuffle size is too large");
21 
22         // EFFECTS
23         remainingValueCount = shuffleSize;
24     }
25 
26     function drawNext() internal returns (uint256) {
27         // CHECKS
28         require(remainingValueCount > 0, "Shuffled values have been exhausted");
29 
30         // EFFECTS
31         uint256 swapValue;
32         unchecked {
33             // Unchecked arithmetic: remainingValueCount is nonzero
34             swapValue = shuffleValues[remainingValueCount - 1];
35         }
36         if (swapValue == 0) {
37             swapValue = remainingValueCount;
38         } else {
39             shuffleValues[remainingValueCount - 1] = 0;
40         }
41 
42         if (remainingValueCount == 1) {
43             // swapValue is the last value left; just return it
44             remainingValueCount = 0;
45             unchecked {
46                 return swapValue - 1;
47             }
48         }
49 
50         uint256 randomIndex = uint256(keccak256(abi.encodePacked(remainingValueCount, block.prevrandao))) %
51             remainingValueCount;
52         unchecked {
53             // Unchecked arithmetic: remainingValueCount is nonzero
54             remainingValueCount--;
55             // Check if swapValue was drawn
56             // Unchecked arithmetic: swapValue is nonzero
57             if (randomIndex == remainingValueCount) return swapValue - 1;
58         }
59 
60         // Draw the value at randomIndex and put swapValue in its place
61         uint256 drawnValue = shuffleValues[randomIndex];
62         shuffleValues[randomIndex] = swapValue;
63 
64         unchecked {
65             // Unchecked arithmetic: only subtract if drawnValue is nonzero
66             return drawnValue > 0 ? drawnValue - 1 : randomIndex;
67         }
68     }
69 }
70 // File: ShuffleSale/ShuffleSale/interfaces/IDelegationRegistry.sol
71 
72 
73 pragma solidity ^0.8.17;
74 
75 /**
76  * @title An immutable registry contract to be deployed as a standalone primitive
77  * @dev See EIP-5639, new project launches can read previous cold wallet -> hot wallet delegations
78  * from here and integrate those permissions into their flow
79  */
80 interface IDelegationRegistry {
81     /// @notice Delegation type
82     enum DelegationType {
83         NONE,
84         ALL,
85         CONTRACT,
86         TOKEN
87     }
88 
89     /// @notice Info about a single delegation, used for onchain enumeration
90     struct DelegationInfo {
91         DelegationType type_;
92         address vault;
93         address delegate;
94         address contract_;
95         uint256 tokenId;
96     }
97 
98     /// @notice Info about a single contract-level delegation
99     struct ContractDelegation {
100         address contract_;
101         address delegate;
102     }
103 
104     /// @notice Info about a single token-level delegation
105     struct TokenDelegation {
106         address contract_;
107         uint256 tokenId;
108         address delegate;
109     }
110 
111     /// @notice Emitted when a user delegates their entire wallet
112     event DelegateForAll(address vault, address delegate, bool value);
113 
114     /// @notice Emitted when a user delegates a specific contract
115     event DelegateForContract(address vault, address delegate, address contract_, bool value);
116 
117     /// @notice Emitted when a user delegates a specific token
118     event DelegateForToken(address vault, address delegate, address contract_, uint256 tokenId, bool value);
119 
120     /// @notice Emitted when a user revokes all delegations
121     event RevokeAllDelegates(address vault);
122 
123     /// @notice Emitted when a user revoes all delegations for a given delegate
124     event RevokeDelegate(address vault, address delegate);
125 
126     /**
127      * -----------  WRITE -----------
128      */
129 
130     /**
131      * @notice Allow the delegate to act on your behalf for all contracts
132      * @param delegate The hotwallet to act on your behalf
133      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
134      */
135     function delegateForAll(address delegate, bool value) external;
136 
137     /**
138      * @notice Allow the delegate to act on your behalf for a specific contract
139      * @param delegate The hotwallet to act on your behalf
140      * @param contract_ The address for the contract you're delegating
141      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
142      */
143     function delegateForContract(address delegate, address contract_, bool value) external;
144 
145     /**
146      * @notice Allow the delegate to act on your behalf for a specific token
147      * @param delegate The hotwallet to act on your behalf
148      * @param contract_ The address for the contract you're delegating
149      * @param tokenId The token id for the token you're delegating
150      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
151      */
152     function delegateForToken(address delegate, address contract_, uint256 tokenId, bool value) external;
153 
154     /**
155      * @notice Revoke all delegates
156      */
157     function revokeAllDelegates() external;
158 
159     /**
160      * @notice Revoke a specific delegate for all their permissions
161      * @param delegate The hotwallet to revoke
162      */
163     function revokeDelegate(address delegate) external;
164 
165     /**
166      * @notice Remove yourself as a delegate for a specific vault
167      * @param vault The vault which delegated to the msg.sender, and should be removed
168      */
169     function revokeSelf(address vault) external;
170 
171     /**
172      * -----------  READ -----------
173      */
174 
175     /**
176      * @notice Returns all active delegations a given delegate is able to claim on behalf of
177      * @param delegate The delegate that you would like to retrieve delegations for
178      * @return info Array of DelegationInfo structs
179      */
180     function getDelegationsByDelegate(address delegate) external view returns (DelegationInfo[] memory);
181 
182     /**
183      * @notice Returns an array of wallet-level delegates for a given vault
184      * @param vault The cold wallet who issued the delegation
185      * @return addresses Array of wallet-level delegates for a given vault
186      */
187     function getDelegatesForAll(address vault) external view returns (address[] memory);
188 
189     /**
190      * @notice Returns an array of contract-level delegates for a given vault and contract
191      * @param vault The cold wallet who issued the delegation
192      * @param contract_ The address for the contract you're delegating
193      * @return addresses Array of contract-level delegates for a given vault and contract
194      */
195     function getDelegatesForContract(address vault, address contract_) external view returns (address[] memory);
196 
197     /**
198      * @notice Returns an array of contract-level delegates for a given vault's token
199      * @param vault The cold wallet who issued the delegation
200      * @param contract_ The address for the contract holding the token
201      * @param tokenId The token id for the token you're delegating
202      * @return addresses Array of contract-level delegates for a given vault's token
203      */
204     function getDelegatesForToken(address vault, address contract_, uint256 tokenId)
205         external
206         view
207         returns (address[] memory);
208 
209     /**
210      * @notice Returns all contract-level delegations for a given vault
211      * @param vault The cold wallet who issued the delegations
212      * @return delegations Array of ContractDelegation structs
213      */
214     function getContractLevelDelegations(address vault)
215         external
216         view
217         returns (ContractDelegation[] memory delegations);
218 
219     /**
220      * @notice Returns all token-level delegations for a given vault
221      * @param vault The cold wallet who issued the delegations
222      * @return delegations Array of TokenDelegation structs
223      */
224     function getTokenLevelDelegations(address vault) external view returns (TokenDelegation[] memory delegations);
225 
226     /**
227      * @notice Returns true if the address is delegated to act on the entire vault
228      * @param delegate The hotwallet to act on your behalf
229      * @param vault The cold wallet who issued the delegation
230      */
231     function checkDelegateForAll(address delegate, address vault) external view returns (bool);
232 
233     /**
234      * @notice Returns true if the address is delegated to act on your behalf for a token contract or an entire vault
235      * @param delegate The hotwallet to act on your behalf
236      * @param contract_ The address for the contract you're delegating
237      * @param vault The cold wallet who issued the delegation
238      */
239     function checkDelegateForContract(address delegate, address vault, address contract_)
240         external
241         view
242         returns (bool);
243 
244     /**
245      * @notice Returns true if the address is delegated to act on your behalf for a specific token, the token's contract or an entire vault
246      * @param delegate The hotwallet to act on your behalf
247      * @param contract_ The address for the contract you're delegating
248      * @param tokenId The token id for the token you're delegating
249      * @param vault The cold wallet who issued the delegation
250      */
251     function checkDelegateForToken(address delegate, address vault, address contract_, uint256 tokenId)
252         external
253         view
254         returns (bool);
255 }
256 // File: @openzeppelin/contracts/utils/Context.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Provides information about the current execution context, including the
265  * sender of the transaction and its data. While these are generally available
266  * via msg.sender and msg.data, they should not be accessed in such a direct
267  * manner, since when dealing with meta-transactions the account sending and
268  * paying for execution may not be the actual sender (as far as an application
269  * is concerned).
270  *
271  * This contract is only required for intermediate, library-like contracts.
272  */
273 abstract contract Context {
274     function _msgSender() internal view virtual returns (address) {
275         return msg.sender;
276     }
277 
278     function _msgData() internal view virtual returns (bytes calldata) {
279         return msg.data;
280     }
281 }
282 
283 // File: @openzeppelin/contracts/security/Pausable.sol
284 
285 
286 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 
291 /**
292  * @dev Contract module which allows children to implement an emergency stop
293  * mechanism that can be triggered by an authorized account.
294  *
295  * This module is used through inheritance. It will make available the
296  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
297  * the functions of your contract. Note that they will not be pausable by
298  * simply including this module, only once the modifiers are put in place.
299  */
300 abstract contract Pausable is Context {
301     /**
302      * @dev Emitted when the pause is triggered by `account`.
303      */
304     event Paused(address account);
305 
306     /**
307      * @dev Emitted when the pause is lifted by `account`.
308      */
309     event Unpaused(address account);
310 
311     bool private _paused;
312 
313     /**
314      * @dev Initializes the contract in unpaused state.
315      */
316     constructor() {
317         _paused = false;
318     }
319 
320     /**
321      * @dev Modifier to make a function callable only when the contract is not paused.
322      *
323      * Requirements:
324      *
325      * - The contract must not be paused.
326      */
327     modifier whenNotPaused() {
328         _requireNotPaused();
329         _;
330     }
331 
332     /**
333      * @dev Modifier to make a function callable only when the contract is paused.
334      *
335      * Requirements:
336      *
337      * - The contract must be paused.
338      */
339     modifier whenPaused() {
340         _requirePaused();
341         _;
342     }
343 
344     /**
345      * @dev Returns true if the contract is paused, and false otherwise.
346      */
347     function paused() public view virtual returns (bool) {
348         return _paused;
349     }
350 
351     /**
352      * @dev Throws if the contract is paused.
353      */
354     function _requireNotPaused() internal view virtual {
355         require(!paused(), "Pausable: paused");
356     }
357 
358     /**
359      * @dev Throws if the contract is not paused.
360      */
361     function _requirePaused() internal view virtual {
362         require(paused(), "Pausable: not paused");
363     }
364 
365     /**
366      * @dev Triggers stopped state.
367      *
368      * Requirements:
369      *
370      * - The contract must not be paused.
371      */
372     function _pause() internal virtual whenNotPaused {
373         _paused = true;
374         emit Paused(_msgSender());
375     }
376 
377     /**
378      * @dev Returns to normal state.
379      *
380      * Requirements:
381      *
382      * - The contract must be paused.
383      */
384     function _unpause() internal virtual whenPaused {
385         _paused = false;
386         emit Unpaused(_msgSender());
387     }
388 }
389 
390 // File: @openzeppelin/contracts/access/Ownable.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Contract module which provides a basic access control mechanism, where
400  * there is an account (an owner) that can be granted exclusive access to
401  * specific functions.
402  *
403  * By default, the owner account will be the one that deploys the contract. This
404  * can later be changed with {transferOwnership}.
405  *
406  * This module is used through inheritance. It will make available the modifier
407  * `onlyOwner`, which can be applied to your functions to restrict their use to
408  * the owner.
409  */
410 abstract contract Ownable is Context {
411     address private _owner;
412 
413     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
414 
415     /**
416      * @dev Initializes the contract setting the deployer as the initial owner.
417      */
418     constructor() {
419         _transferOwnership(_msgSender());
420     }
421 
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         _checkOwner();
427         _;
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view virtual returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if the sender is not the owner.
439      */
440     function _checkOwner() internal view virtual {
441         require(owner() == _msgSender(), "Ownable: caller is not the owner");
442     }
443 
444     /**
445      * @dev Leaves the contract without owner. It will not be possible to call
446      * `onlyOwner` functions. Can only be called by the current owner.
447      *
448      * NOTE: Renouncing ownership will leave the contract without an owner,
449      * thereby disabling any functionality that is only available to the owner.
450      */
451     function renounceOwnership() public virtual onlyOwner {
452         _transferOwnership(address(0));
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) public virtual onlyOwner {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         _transferOwnership(newOwner);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Internal function without access restriction.
467      */
468     function _transferOwnership(address newOwner) internal virtual {
469         address oldOwner = _owner;
470         _owner = newOwner;
471         emit OwnershipTransferred(oldOwner, newOwner);
472     }
473 }
474 
475 // File: ShuffleSale/ShuffleSale/ShuffleSale.sol
476 
477 
478 
479 pragma solidity ^0.8.20;
480 
481 
482 
483 
484 
485 contract ShuffleSale is Shuffler, Ownable, Pausable {
486     Collection[] public COLLECTIONS;
487     address private constant DELEGATION_REGISTRY = 0x00000000000076A84feF008CDAbe6409d2FE638B;
488     uint256 private constant EARLY_ACCESS_PERIOD = 30 minutes;
489     address private constant FPP = 0xA8A425864dB32fCBB459Bf527BdBb8128e6abF21;
490     uint256 private constant FPP_PROJECT_ID = 4;
491     uint256 private constant MINT_LIMIT = 1_200;
492     uint256 private constant PASS_LIMIT_EARLY = 1;
493     uint256 private constant PASS_LIMIT_PUBLIC = 2;
494     uint256 private constant PRICE_FOR_FPP_HOLDER = 0.1 ether;
495     uint256 private constant PRICE_FOR_PUBLIC = 0.2 ether;
496     uint256 private constant RESERVED_AMOUNT = 2;
497     uint256 public immutable START_TIME;
498 
499     mapping(address => uint256) private reservedMints;
500     mapping(address => uint256) public publicMints;
501 
502     struct Collection {
503         address tokenAddress;
504         uint96 offset;
505     }
506 
507     event Purchase(address indexed purchaser, address tokenContract, uint256 tokenId, uint256 price);
508 
509     error SoldOut();
510 
511     constructor(
512         uint256 startTime,
513         address[] memory collectionAddresses,
514         uint96[] memory collectionOffsets
515     ) Shuffler(MINT_LIMIT) {
516         START_TIME = startTime;
517         require(collectionAddresses.length == collectionOffsets.length);
518         for(uint256 i; i<collectionAddresses.length; ++i) {
519             COLLECTIONS.push(
520                 Collection(collectionAddresses[i], collectionOffsets[i])
521             );
522         }
523     }
524 
525     // PUBLIC FUNCTIONS
526 
527     function mint() external payable whenNotPaused {
528         if (remainingValueCount == 0) revert SoldOut();
529         require(msg.value == PRICE_FOR_PUBLIC, "Insufficient payment");
530         require(isPublic(), "Public mint not open");
531         require(publicMints[msg.sender] == 0);
532         publicMints[msg.sender]++;
533         _mint(PRICE_FOR_PUBLIC);
534     }
535 
536     function mintFromPass(
537         uint256 passId
538     ) external payable whenNotPaused {
539         if (remainingValueCount == 0) revert SoldOut();
540         require(msg.value == PRICE_FOR_FPP_HOLDER, "Insufficient payment");
541         require(passAllowance(passId) > 0, "No mints remaining for provided pass");
542         require(block.timestamp >= START_TIME, "Auction not started");
543 
544         IFPP(FPP).logPassUse(passId, FPP_PROJECT_ID);
545         _mint(PRICE_FOR_FPP_HOLDER);
546     }
547 
548     function mintMultipleFromPasses(
549         uint256 quantity,
550         uint256[] calldata passIds
551     ) external payable whenNotPaused {
552         uint256 remaining = remainingValueCount;
553         if (remaining == 0) revert SoldOut();
554         require(block.timestamp >= START_TIME, "Auction not started");
555 
556         if (quantity > remaining) {
557             quantity = remaining;
558         }
559 
560         uint256 passUses;
561         for (uint256 i; i < passIds.length; ++i) {
562             uint256 passId = passIds[i];
563 
564             uint256 allowance = passAllowance(passId);
565 
566             for (uint256 j; j < allowance && passUses < quantity; ++j) {
567                 IFPP(FPP).logPassUse(passId, FPP_PROJECT_ID);
568                 passUses++;
569                 _mint(PRICE_FOR_FPP_HOLDER);
570             }
571 
572             if (passUses == quantity) break;
573         }
574 
575         uint256 amountAtPublicPrice = quantity - passUses;
576         if (amountAtPublicPrice > 1) amountAtPublicPrice = 1;
577         if (!isPublic() || publicMints[msg.sender] > 0) amountAtPublicPrice = 0;
578         if (amountAtPublicPrice == 1) {
579             publicMints[msg.sender]++;
580             _mint(PRICE_FOR_PUBLIC);
581         }
582 
583         uint256 totalCost = PRICE_FOR_FPP_HOLDER * passUses + PRICE_FOR_PUBLIC * amountAtPublicPrice;
584         require(
585             msg.value >= totalCost,
586             "Insufficient payment"
587         );
588 
589         uint256 refund = msg.value - totalCost;
590         if (refund > 0) {
591             (bool refunded, ) = msg.sender.call{value: refund}("");
592             require(refunded, "Refund failed");
593         }
594     }
595 
596     // OWNER ONLY FUNCTIONS
597 
598     function emergencyPause() external onlyOwner {
599         _pause();
600     }
601 
602     function withdraw(
603         address recipient
604     ) external onlyOwner {
605         (bool success,) = recipient.call{value: address(this).balance}("");
606         require(success, "Withdraw failed");
607     }
608 
609     // INTERNAL FUNCTIONS
610 
611     function _mint(uint256 price) internal {
612         uint256 metaId = drawNext();
613         (address tokenContract, uint256 tokenId) = getTokenFromMetaId(metaId);
614         // Reserved Token Logic
615         if (reservedMints[tokenContract] < RESERVED_AMOUNT) {
616             reservedMints[tokenContract]++;
617             emit Purchase(owner(), tokenContract, tokenId, 0);
618             IMint(tokenContract).mint(owner(), tokenId);
619             metaId = drawNext();
620             (tokenContract, tokenId) = getTokenFromMetaId(metaId);
621         }
622 
623         emit Purchase(msg.sender, tokenContract, tokenId, price);
624         IMint(tokenContract).mint(msg.sender, tokenId);
625     }
626 
627     function getTokenFromMetaId(
628         uint256 metaId
629     ) internal view returns (address, uint256) {
630         Collection memory collection = COLLECTIONS[metaId / 100];
631         // + 1 on tokenId to account for 1-indexing
632         return (
633             collection.tokenAddress,
634             metaId % 100 + collection.offset + 1
635         );
636     }
637 
638     function isPublic() internal view returns (bool) {
639         return block.timestamp >= START_TIME + EARLY_ACCESS_PERIOD;
640     }
641 
642     function passAllowance(
643         uint256 passId
644     ) internal view returns (uint256) {
645         address passOwner = IFPP(FPP).ownerOf(passId);
646         require(
647             passOwner == msg.sender ||
648             IDelegationRegistry(DELEGATION_REGISTRY).checkDelegateForToken(
649                 msg.sender,
650                 passOwner,
651                 FPP,
652                 passId
653             ),
654             "Pass not owned or delegated"
655         );
656         uint256 uses = IFPP(FPP).passUses(passId, FPP_PROJECT_ID);
657         return uses >= passLimit() ? 0 : passLimit() - uses;
658     }
659 
660     function passLimit() internal view returns (uint256) {
661         return isPublic() ? PASS_LIMIT_PUBLIC : PASS_LIMIT_EARLY;
662     }
663 }
664 
665 interface IFPP {
666   function logPassUse(uint256 tokenId, uint256 projectId) external;
667   function ownerOf(uint256 tokenId) external view returns (address);
668   function passUses(uint256 tokenId, uint256 projectId) external view returns (uint256);
669 }
670 
671 interface IMint {
672     function mint(address to, uint256 tokenId) external;
673 }