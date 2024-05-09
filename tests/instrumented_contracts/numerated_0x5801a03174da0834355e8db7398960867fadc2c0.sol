1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 interface IAdventureApproval {
5     function setAdventuresApprovedForAll(address operator, bool approved) external;
6     function areAdventuresApprovedForAll(address owner, address operator) external view returns (bool);
7     function isAdventureWhitelisted(address account) external view returns (bool);
8 }
9 
10 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
13 
14 /**
15  * @dev Interface of the ERC165 standard, as defined in the
16  * https://eips.ethereum.org/EIPS/eip-165[EIP].
17  *
18  * Implementers can declare support of contract interfaces, which can then be
19  * queried by others ({ERC165Checker}).
20  *
21  * For an implementation, see {ERC165}.
22  */
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId,
85         bytes calldata data
86     ) external;
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 }
171 
172 contract DragonCustodian {
173     constructor(address babyDragons, address dragonEssence, address dragonAdventure) {
174         IERC721(dragonEssence).setApprovalForAll(dragonAdventure, true);
175         IERC721(babyDragons).setApprovalForAll(dragonAdventure, true);
176         IAdventureApproval(dragonEssence).setAdventuresApprovedForAll(dragonAdventure, true);
177         IAdventureApproval(babyDragons).setAdventuresApprovedForAll(dragonAdventure, true);
178     }
179 }
180 
181 /**
182  * @dev Required interface of mintable Giant Dragon contracts.
183  */
184 interface IMintableGiantDragon {
185     /**
186      * @notice Mints multiple Giant Dragons evolved with the specified Baby Dragon and Dragon Essence tokens.
187      */
188     function mintDragonsBatch(
189         address to,
190         uint256[] calldata babyDragonTokenIds,
191         uint256[] calldata dragonEssenceTokenIds
192     ) external;
193 }
194 
195 /**
196  * @dev Required interface to determine if a minter is whitelisted
197  */
198 interface IMinterWhitelist {
199     /**
200      * @notice Determines if an address is a whitelisted minter
201      */
202     function whitelistedMinters(address account) external view returns (bool);
203 }
204 
205 /**
206  * @title IAdventure
207  * @author Limit Break, Inc.
208  * @notice The base interface that all `Adventure` contracts must conform to.
209  * @dev All contracts that implement the adventure/quest system and interact with an {IAdventurous} token are required to implement this interface.
210  */
211 interface IAdventure is IERC165 {
212 
213     /**
214      * @dev Returns whether or not quests on this adventure lock tokens.
215      * Developers of adventure contract should ensure that this is immutable 
216      * after deployment of the adventure contract.  Failure to do so
217      * can lead to error that deadlock token transfers.
218      */
219     function questsLockTokens() external view returns (bool);
220 
221     /**
222      * @dev A callback function that AdventureERC721 must invoke when a quest has been successfully entered.
223      * Throws if the caller is not an expected AdventureERC721 contract designed to work with the Adventure.
224      * Not permitted to throw in any other case, as this could lead to tokens being locked in quests.
225      */
226     function onQuestEntered(address adventurer, uint256 tokenId, uint256 questId) external;
227 
228     /**
229      * @dev A callback function that AdventureERC721 must invoke when a quest has been successfully exited.
230      * Throws if the caller is not an expected AdventureERC721 contract designed to work with the Adventure.
231      * Not permitted to throw in any other case, as this could lead to tokens being locked in quests.
232      */
233     function onQuestExited(address adventurer, uint256 tokenId, uint256 questId, uint256 questStartTimestamp) external;
234 }
235 
236 /**
237  * @title Quest
238  * @author Limit Break, Inc.
239  * @notice Quest data structure for {IAdventurous} contracts.
240  */
241 struct Quest {
242     bool isActive;
243     uint32 questId;
244     uint64 startTimestamp;
245     uint32 arrayIndex;
246 }
247 
248 /**
249  * @title IAdventurous
250  * @author Limit Break, Inc.
251  * @notice The base interface that all `Adventurous` token contracts must conform to in order to support adventures and quests.
252  * @dev All contracts that support adventures and quests are required to implement this interface.
253  */
254 interface IAdventurous is IERC165 {
255 
256     /**
257      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets, for special in-game adventures.
258      */ 
259     event AdventureApprovalForAll(address indexed tokenOwner, address indexed operator, bool approved);
260 
261     /**
262      * @dev Emitted when a token enters or exits a quest
263      */
264     event QuestUpdated(uint256 indexed tokenId, address indexed tokenOwner, address indexed adventure, uint256 questId, bool active, bool booted);
265 
266     /**
267      * @notice Transfers a player's token if they have opted into an authorized, whitelisted adventure.
268      */
269     function adventureTransferFrom(address from, address to, uint256 tokenId) external;
270 
271     /**
272      * @notice Safe transfers a player's token if they have opted into an authorized, whitelisted adventure.
273      */
274     function adventureSafeTransferFrom(address from, address to, uint256 tokenId) external;
275 
276     /**
277      * @notice Burns a player's token if they have opted into an authorized, whitelisted adventure.
278      */
279     function adventureBurn(uint256 tokenId) external;
280 
281     /**
282      * @notice Enters a player's token into a quest if they have opted into an authorized, whitelisted adventure.
283      */
284     function enterQuest(uint256 tokenId, uint256 questId) external;
285 
286     /**
287      * @notice Exits a player's token from a quest if they have opted into an authorized, whitelisted adventure.
288      */
289     function exitQuest(uint256 tokenId, uint256 questId) external;
290 
291     /**
292      * @notice Returns the number of quests a token is actively participating in for a specified adventure
293      */
294     function getQuestCount(uint256 tokenId, address adventure) external view returns (uint256);
295 
296     /**
297      * @notice Returns the amount of time a token has been participating in the specified quest
298      */
299     function getTimeOnQuest(uint256 tokenId, address adventure, uint256 questId) external view returns (uint256);
300 
301     /**
302      * @notice Returns whether or not a token is currently participating in the specified quest as well as the time it was started and the quest index
303      */
304     function isParticipatingInQuest(uint256 tokenId, address adventure, uint256 questId) external view returns (bool participatingInQuest, uint256 startTimestamp, uint256 index);
305 
306     /**
307      * @notice Returns a list of all active quests for the specified token id and adventure
308      */
309     function getActiveQuests(uint256 tokenId, address adventure) external view returns (Quest[] memory activeQuests);
310 }
311 
312 /**
313  * @title IAdventurousERC721
314  * @author Limit Break, Inc.
315  * @notice Combines all {IAdventurous} and all {IERC721} functionality into a single, unified interface.
316  * @dev This interface may be used as a convenience to interact with tokens that support both interface standards.
317  */
318 interface IAdventurousERC721 is IERC721, IAdventurous {
319 
320 }
321 
322 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
323 
324 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
325 
326 /**
327  * @dev Provides information about the current execution context, including the
328  * sender of the transaction and its data. While these are generally available
329  * via msg.sender and msg.data, they should not be accessed in such a direct
330  * manner, since when dealing with meta-transactions the account sending and
331  * paying for execution may not be the actual sender (as far as an application
332  * is concerned).
333  *
334  * This contract is only required for intermediate, library-like contracts.
335  */
336 abstract contract Context {
337     function _msgSender() internal view virtual returns (address) {
338         return msg.sender;
339     }
340 
341     function _msgData() internal view virtual returns (bytes calldata) {
342         return msg.data;
343     }
344 }
345 
346 /**
347  * @dev Contract module which provides a basic access control mechanism, where
348  * there is an account (an owner) that can be granted exclusive access to
349  * specific functions.
350  *
351  * By default, the owner account will be the one that deploys the contract. This
352  * can later be changed with {transferOwnership}.
353  *
354  * This module is used through inheritance. It will make available the modifier
355  * `onlyOwner`, which can be applied to your functions to restrict their use to
356  * the owner.
357  */
358 abstract contract Ownable is Context {
359     address private _owner;
360 
361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363     /**
364      * @dev Initializes the contract setting the deployer as the initial owner.
365      */
366     constructor() {
367         _transferOwnership(_msgSender());
368     }
369 
370     /**
371      * @dev Throws if called by any account other than the owner.
372      */
373     modifier onlyOwner() {
374         _checkOwner();
375         _;
376     }
377 
378     /**
379      * @dev Returns the address of the current owner.
380      */
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     /**
386      * @dev Throws if the sender is not the owner.
387      */
388     function _checkOwner() internal view virtual {
389         require(owner() == _msgSender(), "Ownable: caller is not the owner");
390     }
391 
392     /**
393      * @dev Leaves the contract without owner. It will not be possible to call
394      * `onlyOwner` functions anymore. Can only be called by the current owner.
395      *
396      * NOTE: Renouncing ownership will leave the contract without an owner,
397      * thereby removing any functionality that is only available to the owner.
398      */
399     function renounceOwnership() public virtual onlyOwner {
400         _transferOwnership(address(0));
401     }
402 
403     /**
404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
405      * Can only be called by the current owner.
406      */
407     function transferOwnership(address newOwner) public virtual onlyOwner {
408         require(newOwner != address(0), "Ownable: new owner is the zero address");
409         _transferOwnership(newOwner);
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Internal function without access restriction.
415      */
416     function _transferOwnership(address newOwner) internal virtual {
417         address oldOwner = _owner;
418         _owner = newOwner;
419         emit OwnershipTransferred(oldOwner, newOwner);
420     }
421 }
422 
423 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
424 
425 /**
426  * @dev Contract module which allows children to implement an emergency stop
427  * mechanism that can be triggered by an authorized account.
428  *
429  * This module is used through inheritance. It will make available the
430  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
431  * the functions of your contract. Note that they will not be pausable by
432  * simply including this module, only once the modifiers are put in place.
433  */
434 abstract contract Pausable is Context {
435     /**
436      * @dev Emitted when the pause is triggered by `account`.
437      */
438     event Paused(address account);
439 
440     /**
441      * @dev Emitted when the pause is lifted by `account`.
442      */
443     event Unpaused(address account);
444 
445     bool private _paused;
446 
447     /**
448      * @dev Initializes the contract in unpaused state.
449      */
450     constructor() {
451         _paused = false;
452     }
453 
454     /**
455      * @dev Modifier to make a function callable only when the contract is not paused.
456      *
457      * Requirements:
458      *
459      * - The contract must not be paused.
460      */
461     modifier whenNotPaused() {
462         _requireNotPaused();
463         _;
464     }
465 
466     /**
467      * @dev Modifier to make a function callable only when the contract is paused.
468      *
469      * Requirements:
470      *
471      * - The contract must be paused.
472      */
473     modifier whenPaused() {
474         _requirePaused();
475         _;
476     }
477 
478     /**
479      * @dev Returns true if the contract is paused, and false otherwise.
480      */
481     function paused() public view virtual returns (bool) {
482         return _paused;
483     }
484 
485     /**
486      * @dev Throws if the contract is paused.
487      */
488     function _requireNotPaused() internal view virtual {
489         require(!paused(), "Pausable: paused");
490     }
491 
492     /**
493      * @dev Throws if the contract is not paused.
494      */
495     function _requirePaused() internal view virtual {
496         require(paused(), "Pausable: not paused");
497     }
498 
499     /**
500      * @dev Triggers stopped state.
501      *
502      * Requirements:
503      *
504      * - The contract must not be paused.
505      */
506     function _pause() internal virtual whenNotPaused {
507         _paused = true;
508         emit Paused(_msgSender());
509     }
510 
511     /**
512      * @dev Returns to normal state.
513      *
514      * Requirements:
515      *
516      * - The contract must be paused.
517      */
518     function _unpause() internal virtual whenPaused {
519         _paused = false;
520         emit Unpaused(_msgSender());
521     }
522 }
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
525 
526 /**
527  * @dev Implementation of the {IERC165} interface.
528  *
529  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
530  * for the additional interface id that will be supported. For example:
531  *
532  * ```solidity
533  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
535  * }
536  * ```
537  *
538  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
539  */
540 abstract contract ERC165 is IERC165 {
541     /**
542      * @dev See {IERC165-supportsInterface}.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545         return interfaceId == type(IERC165).interfaceId;
546     }
547 }
548 
549 /**
550  * @title GiantDragonAdventure
551  * @author Limit Break, Inc.
552  * @notice An adventure that combines your Baby Dragon and a provided Dragon Essence.
553  */
554 contract GiantDragonAdventure is Ownable, Pausable, ERC165, IAdventure {
555     error GiantDragonAdventure__CallbackNotImplemented();
556     error GiantDragonAdventure__CallerNotOwnerOfBabyDragon();
557     error GiantDragonAdventure__CallerNotOwnerOfDragonEssence();
558     error GiantDragonAdventure__CannotSpecifyAddressZeroForBabyDragons();
559     error GiantDragonAdventure__CannotSpecifyAddressZeroForGiantDragon();
560     error GiantDragonAdventure__CannotSpecifyAddressZeroForDragonEssence();
561     error GiantDragonAdventure__InputArrayLengthMismatch();
562     error GiantDragonAdventure__QuantityMustBeGreaterThanZero();
563 
564     /// @dev An unchangeable reference to the Baby Dragons contract used in the dragon quest.
565     IAdventurousERC721 public immutable babyDragons;
566 
567     /// @dev An unchangeable reference to the Dragon Essence contract used in the dragon quest.
568     IAdventurousERC721 public immutable dragonEssence;
569 
570     /// @dev An unchangeable reference to the Giant Dragons contract given at the end of the quest.
571     IMintableGiantDragon public immutable giantDragons;
572 
573     constructor(address babyDragonAddress, address dragonEssenceAddress, address giantDragonAddress) {
574         if (babyDragonAddress == address(0)) {
575             revert GiantDragonAdventure__CannotSpecifyAddressZeroForBabyDragons();
576         }
577         if (dragonEssenceAddress == address(0)) {
578             revert GiantDragonAdventure__CannotSpecifyAddressZeroForDragonEssence();
579         }
580         if (giantDragonAddress == address(0)) {
581             revert GiantDragonAdventure__CannotSpecifyAddressZeroForGiantDragon();
582         }
583 
584         babyDragons = IAdventurousERC721(babyDragonAddress);
585         dragonEssence = IAdventurousERC721(dragonEssenceAddress);
586         giantDragons = IMintableGiantDragon(giantDragonAddress);
587     }
588 
589     /// @dev A callback function that AdventureERC721 must invoke when a quest has been successfully entered.
590     /// Throws in all cases quest entry for this adventure is fulfilled via adventureTransferFrom instead of onQuestEntered, and this callback should not be triggered.
591     function onQuestEntered(address, /*adventurer*/ uint256, /*tokenId*/ uint256 /*questId*/ ) external pure override {
592         revert GiantDragonAdventure__CallbackNotImplemented();
593     }
594 
595     /// @dev A callback function that AdventureERC721 must invoke when a quest has been successfully exited.
596     /// Throws in all cases quest exit for this adventure is fulfilled via transferFrom or adventureBurn instead of onQuestExited, and this callback should not be triggered.
597     function onQuestExited(
598         address, /*adventurer*/
599         uint256, /*tokenId*/
600         uint256, /*questId*/
601         uint256 /*questStartTimestamp*/
602     ) external pure override {
603         revert GiantDragonAdventure__CallbackNotImplemented();
604     }
605 
606     /// @notice Returns false - this quest uses hard staking.
607     function questsLockTokens() external pure override returns (bool) {
608         return false;
609     }
610 
611     /**
612      * @notice Pauses new quest entries for the quest.
613      *
614      * @dev    Throws if the caller is not the owner.
615      *
616      * @dev    <h4>Postconditions:</h4>
617      * @dev    1. `_pause` is set to true.
618      */
619     function pauseNewQuestEntries() external onlyOwner {
620         _pause();
621     }
622 
623     /**
624      * @notice Unpauses new quest entries for the quest.
625      *
626      * @dev    Throws if the caller is not the owner.
627      *
628      * @dev    <h4>Postconditions:</h4>
629      * @dev    1. `_pause` is set to false.
630      */
631     function unpauseNewQuestEntries() external onlyOwner {
632         _unpause();
633     }
634 
635     /**
636      * @notice Combines the provided Baby Dragons and Dragon Essences to form Giant Dragons
637      *
638      * @dev    Throws when `quantity` is zero, where `quantity` is the length of the Baby Dragons Token IDs array.
639      * @dev    Throws when the lengths of the Baby Dragon Token IDs and Dragon Essence Token IDs do not match.
640      *
641      * @dev    <h4>Postconditions:</h4>
642      * @dev    1. The Baby Dragons used to complete the quest have been burnt.
643      * @dev    2. The Dragon Essences used to complete the quest have been burnt.
644      * @dev    3. A Giant Dragon has been minted to the adventurer who has completed the quest.
645      * @dev    4. `quantity` DragonMinted events are emitted, where `quantity` is the length of the provided Baby Dragon token IDs.
646      *
647      * @param babyDragonTokenIds    Array of token IDs to enter the quest with.
648      * @param dragonEssenceTokenIds Array of token IDs to combine with Baby Dragons.
649      */
650     function combineDragonsWithEssences(uint256[] calldata babyDragonTokenIds, uint256[] calldata dragonEssenceTokenIds) external {
651         _requireNotPaused();
652 
653         if (babyDragonTokenIds.length != dragonEssenceTokenIds.length) {
654             revert GiantDragonAdventure__InputArrayLengthMismatch();
655         }
656         
657         if (babyDragonTokenIds.length == 0) {
658             revert GiantDragonAdventure__QuantityMustBeGreaterThanZero();
659         }
660 
661         for (uint256 i = 0; i < babyDragonTokenIds.length;) {
662             uint256 babyDragonTokenId = babyDragonTokenIds[i];
663             uint256 dragonEssenceTokenId = dragonEssenceTokenIds[i];
664 
665             if (babyDragons.ownerOf(babyDragonTokenId) != _msgSender()) {
666                 revert GiantDragonAdventure__CallerNotOwnerOfBabyDragon();
667             }
668 
669             if (dragonEssence.ownerOf(dragonEssenceTokenId) != _msgSender()) {
670                 revert GiantDragonAdventure__CallerNotOwnerOfDragonEssence();
671             }
672 
673             babyDragons.adventureBurn(babyDragonTokenId);
674             dragonEssence.adventureBurn(dragonEssenceTokenId);
675             unchecked {
676                 ++i;
677             }
678         }
679 
680         giantDragons.mintDragonsBatch(_msgSender(), babyDragonTokenIds, dragonEssenceTokenIds);
681     }
682 
683     /// @notice ERC-165 interface support
684     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
685         return interfaceId == type(IAdventure).interfaceId || super.supportsInterface(interfaceId);
686     }
687 }