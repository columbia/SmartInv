1 // File: contracts/interfaces/IPublicLock.sol
2 
3 pragma solidity 0.5.17;
4 
5 /**
6 * @title The PublicLock Interface
7 * @author Nick Furfaro (unlock-protocol.com)
8  */
9 
10 
11 contract IPublicLock
12 {
13 
14 // See indentationissue description here:
15 // https://github.com/duaraghav8/Ethlint/issues/268
16 // solium-disable indentation
17 
18   /// Functions
19 
20   function initialize(
21     address _lockCreator,
22     uint _expirationDuration,
23     address _tokenAddress,
24     uint _keyPrice,
25     uint _maxNumberOfKeys,
26     string calldata _lockName
27   ) external;
28 
29   /**
30    * @notice Allow the contract to accept tips in ETH sent directly to the contract.
31    * @dev This is okay to use even if the lock is priced in ERC-20 tokens
32    */
33   function() external payable;
34 
35   /**
36    * @dev Never used directly
37    */
38   function initialize() external;
39 
40   /**
41   * @notice The version number of the current implementation on this network.
42   * @return The current version number.
43   */
44   function publicLockVersion() public pure returns (uint);
45 
46   /**
47   * @notice Gets the current balance of the account provided.
48   * @param _tokenAddress The token type to retrieve the balance of.
49   * @param _account The account to get the balance of.
50   * @return The number of tokens of the given type for the given address, possibly 0.
51   */
52   function getBalance(
53     address _tokenAddress,
54     address _account
55   ) external view
56     returns (uint);
57 
58   /**
59   * @notice Used to disable lock before migrating keys and/or destroying contract.
60   * @dev Throws if called by other than a lock manager.
61   * @dev Throws if lock contract has already been disabled.
62   */
63   function disableLock() external;
64 
65   /**
66    * @dev Called by a lock manager or beneficiary to withdraw all funds from the lock and send them to the `beneficiary`.
67    * @dev Throws if called by other than a lock manager or beneficiary
68    * @param _tokenAddress specifies the token address to withdraw or 0 for ETH. This is usually
69    * the same as `tokenAddress` in MixinFunds.
70    * @param _amount specifies the max amount to withdraw, which may be reduced when
71    * considering the available balance. Set to 0 or MAX_UINT to withdraw everything.
72    *  -- however be wary of draining funds as it breaks the `cancelAndRefund` and `expireAndRefundFor`
73    * use cases.
74    */
75   function withdraw(
76     address _tokenAddress,
77     uint _amount
78   ) external;
79 
80   /**
81    * A function which lets a Lock manager of the lock to change the price for future purchases.
82    * @dev Throws if called by other than a Lock manager
83    * @dev Throws if lock has been disabled
84    * @dev Throws if _tokenAddress is not a valid token
85    * @param _keyPrice The new price to set for keys
86    * @param _tokenAddress The address of the erc20 token to use for pricing the keys,
87    * or 0 to use ETH
88    */
89   function updateKeyPricing( uint _keyPrice, address _tokenAddress ) external;
90 
91   /**
92    * A function which lets a Lock manager update the beneficiary account,
93    * which receives funds on withdrawal.
94    * @dev Throws if called by other than a Lock manager or beneficiary
95    * @dev Throws if _beneficiary is address(0)
96    * @param _beneficiary The new address to set as the beneficiary
97    */
98   function updateBeneficiary( address _beneficiary ) external;
99 
100     /**
101    * Checks if the user has a non-expired key.
102    * @param _user The address of the key owner
103    */
104   function getHasValidKey(
105     address _user
106   ) external view returns (bool);
107 
108   /**
109    * @notice Find the tokenId for a given user
110    * @return The tokenId of the NFT, else returns 0
111    * @param _account The address of the key owner
112   */
113   function getTokenIdFor(
114     address _account
115   ) external view returns (uint);
116 
117   /**
118   * A function which returns a subset of the keys for this Lock as an array
119   * @param _page the page of key owners requested when faceted by page size
120   * @param _pageSize the number of Key Owners requested per page
121   * @dev Throws if there are no key owners yet
122   */
123   function getOwnersByPage(
124     uint _page,
125     uint _pageSize
126   ) external view returns (address[] memory);
127 
128   /**
129    * Checks if the given address owns the given tokenId.
130    * @param _tokenId The tokenId of the key to check
131    * @param _keyOwner The potential key owners address
132    */
133   function isKeyOwner(
134     uint _tokenId,
135     address _keyOwner
136   ) external view returns (bool);
137 
138   /**
139   * @dev Returns the key's ExpirationTimestamp field for a given owner.
140   * @param _keyOwner address of the user for whom we search the key
141   * @dev Returns 0 if the owner has never owned a key for this lock
142   */
143   function keyExpirationTimestampFor(
144     address _keyOwner
145   ) external view returns (uint timestamp);
146 
147   /**
148    * Public function which returns the total number of unique owners (both expired
149    * and valid).  This may be larger than totalSupply.
150    */
151   function numberOfOwners() external view returns (uint);
152 
153   /**
154    * Allows a Lock manager to assign a descriptive name for this Lock.
155    * @param _lockName The new name for the lock
156    * @dev Throws if called by other than a Lock manager
157    */
158   function updateLockName(
159     string calldata _lockName
160   ) external;
161 
162   /**
163    * Allows a Lock manager to assign a Symbol for this Lock.
164    * @param _lockSymbol The new Symbol for the lock
165    * @dev Throws if called by other than a Lock manager
166    */
167   function updateLockSymbol(
168     string calldata _lockSymbol
169   ) external;
170 
171   /**
172     * @dev Gets the token symbol
173     * @return string representing the token symbol
174     */
175   function symbol()
176     external view
177     returns(string memory);
178 
179     /**
180    * Allows a Lock manager to update the baseTokenURI for this Lock.
181    * @dev Throws if called by other than a Lock manager
182    * @param _baseTokenURI String representing the base of the URI for this lock.
183    */
184   function setBaseTokenURI(
185     string calldata _baseTokenURI
186   ) external;
187 
188   /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
189    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
190    *  3986. The URI may point to a JSON file that conforms to the "ERC721
191    *  Metadata JSON Schema".
192    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
193    * @param _tokenId The tokenID we're inquiring about
194    * @return String representing the URI for the requested token
195    */
196   function tokenURI(
197     uint256 _tokenId
198   ) external view returns(string memory);
199 
200   /**
201    * @notice Allows a Lock manager to add or remove an event hook
202    */
203   function setEventHooks(
204     address _onKeyPurchaseHook,
205     address _onKeyCancelHook
206   ) external;
207 
208   /**
209    * Allows a Lock manager to give a collection of users a key with no charge.
210    * Each key may be assigned a different expiration date.
211    * @dev Throws if called by other than a Lock manager
212    * @param _recipients An array of receiving addresses
213    * @param _expirationTimestamps An array of expiration Timestamps for the keys being granted
214    */
215   function grantKeys(
216     address[] calldata _recipients,
217     uint[] calldata _expirationTimestamps,
218     address[] calldata _keyManagers
219   ) external;
220 
221   /**
222   * @dev Purchase function
223   * @param _value the number of tokens to pay for this purchase >= the current keyPrice - any applicable discount
224   * (_value is ignored when using ETH)
225   * @param _recipient address of the recipient of the purchased key
226   * @param _referrer address of the user making the referral
227   * @param _data arbitrary data populated by the front-end which initiated the sale
228   * @dev Throws if lock is disabled. Throws if lock is sold-out. Throws if _recipient == address(0).
229   * @dev Setting _value to keyPrice exactly doubles as a security feature. That way if a Lock manager increases the
230   * price while my transaction is pending I can't be charged more than I expected (only applicable to ERC-20 when more
231   * than keyPrice is approved for spending).
232   */
233   function purchase(
234     uint256 _value,
235     address _recipient,
236     address _referrer,
237     bytes calldata _data
238   ) external payable;
239 
240   /**
241    * @notice returns the minimum price paid for a purchase with these params.
242    * @dev this considers any discount from Unlock or the OnKeyPurchase hook.
243    */
244   function purchasePriceFor(
245     address _recipient,
246     address _referrer,
247     bytes calldata _data
248   ) external view
249     returns (uint);
250 
251   /**
252    * Allow a Lock manager to change the transfer fee.
253    * @dev Throws if called by other than a Lock manager
254    * @param _transferFeeBasisPoints The new transfer fee in basis-points(bps).
255    * Ex: 200 bps = 2%
256    */
257   function updateTransferFee(
258     uint _transferFeeBasisPoints
259   ) external;
260 
261   /**
262    * Determines how much of a fee a key owner would need to pay in order to
263    * transfer the key to another account.  This is pro-rated so the fee goes down
264    * overtime.
265    * @dev Throws if _keyOwner does not have a valid key
266    * @param _keyOwner The owner of the key check the transfer fee for.
267    * @param _time The amount of time to calculate the fee for.
268    * @return The transfer fee in seconds.
269    */
270   function getTransferFee(
271     address _keyOwner,
272     uint _time
273   ) external view returns (uint);
274 
275   /**
276    * @dev Invoked by a Lock manager to expire the user's key and perform a refund and cancellation of the key
277    * @param _keyOwner The key owner to whom we wish to send a refund to
278    * @param amount The amount to refund the key-owner
279    * @dev Throws if called by other than a Lock manager
280    * @dev Throws if _keyOwner does not have a valid key
281    */
282   function expireAndRefundFor(
283     address _keyOwner,
284     uint amount
285   ) external;
286 
287    /**
288    * @dev allows the key manager to expire a given tokenId
289    * and send a refund to the keyOwner based on the amount of time remaining.
290    * @param _tokenId The id of the key to cancel.
291    */
292   function cancelAndRefund(uint _tokenId) external;
293 
294   /**
295    * @dev Cancels a key managed by a different user and sends the funds to the keyOwner.
296    * @param _keyManager the key managed by this user will be canceled
297    * @param _v _r _s getCancelAndRefundApprovalHash signed by the _keyManager
298    * @param _tokenId The key to cancel
299    */
300   function cancelAndRefundFor(
301     address _keyManager,
302     uint8 _v,
303     bytes32 _r,
304     bytes32 _s,
305     uint _tokenId
306   ) external;
307 
308   /**
309    * @notice Sets the minimum nonce for a valid off-chain approval message from the
310    * senders account.
311    * @dev This can be used to invalidate a previously signed message.
312    */
313   function invalidateOffchainApproval(
314     uint _nextAvailableNonce
315   ) external;
316 
317   /**
318    * Allow a Lock manager to change the refund penalty.
319    * @dev Throws if called by other than a Lock manager
320    * @param _freeTrialLength The new duration of free trials for this lock
321    * @param _refundPenaltyBasisPoints The new refund penaly in basis-points(bps)
322    */
323   function updateRefundPenalty(
324     uint _freeTrialLength,
325     uint _refundPenaltyBasisPoints
326   ) external;
327 
328   /**
329    * @dev Determines how much of a refund a key owner would receive if they issued
330    * @param _keyOwner The key owner to get the refund value for.
331    * a cancelAndRefund block.timestamp.
332    * Note that due to the time required to mine a tx, the actual refund amount will be lower
333    * than what the user reads from this call.
334    */
335   function getCancelAndRefundValueFor(
336     address _keyOwner
337   ) external view returns (uint refund);
338 
339   function keyManagerToNonce(address ) external view returns (uint256 );
340 
341   /**
342    * @notice returns the hash to sign in order to allow another user to cancel on your behalf.
343    * @dev this can be computed in JS instead of read from the contract.
344    * @param _keyManager The key manager's address (also the message signer)
345    * @param _txSender The address cancelling cancel on behalf of the keyOwner
346    * @return approvalHash The hash to sign
347    */
348   function getCancelAndRefundApprovalHash(
349     address _keyManager,
350     address _txSender
351   ) external view returns (bytes32 approvalHash);
352 
353   function addKeyGranter(address account) external;
354 
355   function addLockManager(address account) external;
356 
357   function isKeyGranter(address account) external view returns (bool);
358 
359   function isLockManager(address account) external view returns (bool);
360 
361   function onKeyPurchaseHook() external view returns(address);
362 
363   function onKeyCancelHook() external view returns(address);
364 
365   function revokeKeyGranter(address _granter) external;
366 
367   function renounceLockManager() external;
368 
369   ///===================================================================
370   /// Auto-generated getter functions from public state variables
371 
372   function beneficiary() external view returns (address );
373 
374   function expirationDuration() external view returns (uint256 );
375 
376   function freeTrialLength() external view returns (uint256 );
377 
378   function isAlive() external view returns (bool );
379 
380   function keyPrice() external view returns (uint256 );
381 
382   function maxNumberOfKeys() external view returns (uint256 );
383 
384   function owners(uint256 ) external view returns (address );
385 
386   function refundPenaltyBasisPoints() external view returns (uint256 );
387 
388   function tokenAddress() external view returns (address );
389 
390   function transferFeeBasisPoints() external view returns (uint256 );
391 
392   function unlockProtocol() external view returns (address );
393 
394   function keyManagerOf(uint) external view returns (address );
395 
396   ///===================================================================
397 
398   /**
399   * @notice Allows the key owner to safely share their key (parent key) by
400   * transferring a portion of the remaining time to a new key (child key).
401   * @dev Throws if key is not valid.
402   * @dev Throws if `_to` is the zero address
403   * @param _to The recipient of the shared key
404   * @param _tokenId the key to share
405   * @param _timeShared The amount of time shared
406   * checks if `_to` is a smart contract (code size > 0). If so, it calls
407   * `onERC721Received` on `_to` and throws if the return value is not
408   * `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
409   * @dev Emit Transfer event
410   */
411   function shareKey(
412     address _to,
413     uint _tokenId,
414     uint _timeShared
415   ) external;
416 
417   /**
418   * @notice Update transfer and cancel rights for a given key
419   * @param _tokenId The id of the key to assign rights for
420   * @param _keyManager The address to assign the rights to for the given key
421   */
422   function setKeyManagerOf(
423     uint _tokenId,
424     address _keyManager
425   ) external;
426 
427   /// @notice A descriptive name for a collection of NFTs in this contract
428   function name() external view returns (string memory _name);
429   ///===================================================================
430 
431   /// From ERC165.sol
432   function supportsInterface(bytes4 interfaceId) external view returns (bool );
433   ///===================================================================
434 
435   /// From ERC-721
436   /**
437      * @dev Returns the number of NFTs in `owner`'s account.
438      */
439     function balanceOf(address _owner) public view returns (uint256 balance);
440 
441     /**
442      * @dev Returns the owner of the NFT specified by `tokenId`.
443      */
444     function ownerOf(uint256 tokenId) public view returns (address _owner);
445 
446     /**
447      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
448      * another (`to`).
449      *
450      *
451      *
452      * Requirements:
453      * - `from`, `to` cannot be zero.
454      * - `tokenId` must be owned by `from`.
455      * - If the caller is not `from`, it must be have been allowed to move this
456      * NFT by either {approve} or {setApprovalForAll}.
457      */
458     function safeTransferFrom(address from, address to, uint256 tokenId) public;
459     /**
460      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
461      * another (`to`).
462      *
463      * Requirements:
464      * - If the caller is not `from`, it must be approved to move this NFT by
465      * either {approve} or {setApprovalForAll}.
466      */
467     function transferFrom(address from, address to, uint256 tokenId) public;
468     function approve(address to, uint256 tokenId) public;
469 
470     /**
471     * @notice Get the approved address for a single NFT
472     * @dev Throws if `_tokenId` is not a valid NFT.
473     * @param _tokenId The NFT to find the approved address for
474     * @return The approved address for this NFT, or the zero address if there is none
475     */
476     function getApproved(uint256 _tokenId) public view returns (address operator);
477 
478     function setApprovalForAll(address operator, bool _approved) public;
479     function isApprovedForAll(address _owner, address operator) public view returns (bool);
480 
481     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
482 
483     function totalSupply() public view returns (uint256);
484     function tokenOfOwnerByIndex(address _owner, uint256 index) public view returns (uint256 tokenId);
485 
486     function tokenByIndex(uint256 index) public view returns (uint256);
487 }
488 
489 // File: @openzeppelin/upgrades/contracts/Initializable.sol
490 
491 pragma solidity >=0.4.24 <0.7.0;
492 
493 
494 /**
495  * @title Initializable
496  *
497  * @dev Helper contract to support initializer functions. To use it, replace
498  * the constructor with a function that has the `initializer` modifier.
499  * WARNING: Unlike constructors, initializer functions must be manually
500  * invoked. This applies both to deploying an Initializable contract, as well
501  * as extending an Initializable contract via inheritance.
502  * WARNING: When used with inheritance, manual care must be taken to not invoke
503  * a parent initializer twice, or ensure that all initializers are idempotent,
504  * because this is not dealt with automatically as with constructors.
505  */
506 contract Initializable {
507 
508   /**
509    * @dev Indicates that the contract has been initialized.
510    */
511   bool private initialized;
512 
513   /**
514    * @dev Indicates that the contract is in the process of being initialized.
515    */
516   bool private initializing;
517 
518   /**
519    * @dev Modifier to use in the initializer function of a contract.
520    */
521   modifier initializer() {
522     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
523 
524     bool isTopLevelCall = !initializing;
525     if (isTopLevelCall) {
526       initializing = true;
527       initialized = true;
528     }
529 
530     _;
531 
532     if (isTopLevelCall) {
533       initializing = false;
534     }
535   }
536 
537   /// @dev Returns true if and only if the function is running in the constructor
538   function isConstructor() private view returns (bool) {
539     // extcodesize checks the size of the code stored in an address, and
540     // address returns the current address. Since the code is still not
541     // deployed when running a constructor, any checks on its code size will
542     // yield zero, making it an effective way to detect if a contract is
543     // under construction or not.
544     address self = address(this);
545     uint256 cs;
546     assembly { cs := extcodesize(self) }
547     return cs == 0;
548   }
549 
550   // Reserved storage space to allow for layout changes in the future.
551   uint256[50] private ______gap;
552 }
553 
554 // File: @openzeppelin/contracts-ethereum-package/contracts/introspection/IERC165.sol
555 
556 pragma solidity ^0.5.0;
557 
558 /**
559  * @dev Interface of the ERC165 standard, as defined in the
560  * https://eips.ethereum.org/EIPS/eip-165[EIP].
561  *
562  * Implementers can declare support of contract interfaces, which can then be
563  * queried by others ({ERC165Checker}).
564  *
565  * For an implementation, see {ERC165}.
566  */
567 interface IERC165 {
568     /**
569      * @dev Returns true if this contract implements the interface defined by
570      * `interfaceId`. See the corresponding
571      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
572      * to learn more about how these ids are created.
573      *
574      * This function call must use less than 30 000 gas.
575      */
576     function supportsInterface(bytes4 interfaceId) external view returns (bool);
577 }
578 
579 // File: @openzeppelin/contracts-ethereum-package/contracts/introspection/ERC165.sol
580 
581 pragma solidity ^0.5.0;
582 
583 
584 
585 /**
586  * @dev Implementation of the {IERC165} interface.
587  *
588  * Contracts may inherit from this and call {_registerInterface} to declare
589  * their support of an interface.
590  */
591 contract ERC165 is Initializable, IERC165 {
592     /*
593      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
594      */
595     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
596 
597     /**
598      * @dev Mapping of interface ids to whether or not it's supported.
599      */
600     mapping(bytes4 => bool) private _supportedInterfaces;
601 
602     function initialize() public initializer {
603         // Derived contracts need only register support for their own interfaces,
604         // we register support for ERC165 itself here
605         _registerInterface(_INTERFACE_ID_ERC165);
606     }
607 
608     /**
609      * @dev See {IERC165-supportsInterface}.
610      *
611      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
612      */
613     function supportsInterface(bytes4 interfaceId) public view returns (bool) {
614         return _supportedInterfaces[interfaceId];
615     }
616 
617     /**
618      * @dev Registers the contract as an implementer of the interface defined by
619      * `interfaceId`. Support of the actual ERC165 interface is automatic and
620      * registering its interface id is not required.
621      *
622      * See {IERC165-supportsInterface}.
623      *
624      * Requirements:
625      *
626      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
627      */
628     function _registerInterface(bytes4 interfaceId) internal {
629         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
630         _supportedInterfaces[interfaceId] = true;
631     }
632 
633     uint256[50] private ______gap;
634 }
635 
636 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
637 
638 pragma solidity ^0.5.0;
639 
640 /**
641  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
642  * the optional functions; to access them see {ERC20Detailed}.
643  */
644 interface IERC20 {
645     /**
646      * @dev Returns the amount of tokens in existence.
647      */
648     function totalSupply() external view returns (uint256);
649 
650     /**
651      * @dev Returns the amount of tokens owned by `account`.
652      */
653     function balanceOf(address account) external view returns (uint256);
654 
655     /**
656      * @dev Moves `amount` tokens from the caller's account to `recipient`.
657      *
658      * Returns a boolean value indicating whether the operation succeeded.
659      *
660      * Emits a {Transfer} event.
661      */
662     function transfer(address recipient, uint256 amount) external returns (bool);
663 
664     /**
665      * @dev Returns the remaining number of tokens that `spender` will be
666      * allowed to spend on behalf of `owner` through {transferFrom}. This is
667      * zero by default.
668      *
669      * This value changes when {approve} or {transferFrom} are called.
670      */
671     function allowance(address owner, address spender) external view returns (uint256);
672 
673     /**
674      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
675      *
676      * Returns a boolean value indicating whether the operation succeeded.
677      *
678      * IMPORTANT: Beware that changing an allowance with this method brings the risk
679      * that someone may use both the old and the new allowance by unfortunate
680      * transaction ordering. One possible solution to mitigate this race
681      * condition is to first reduce the spender's allowance to 0 and set the
682      * desired value afterwards:
683      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
684      *
685      * Emits an {Approval} event.
686      */
687     function approve(address spender, uint256 amount) external returns (bool);
688 
689     /**
690      * @dev Moves `amount` tokens from `sender` to `recipient` using the
691      * allowance mechanism. `amount` is then deducted from the caller's
692      * allowance.
693      *
694      * Returns a boolean value indicating whether the operation succeeded.
695      *
696      * Emits a {Transfer} event.
697      */
698     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
699 
700     /**
701      * @dev Emitted when `value` tokens are moved from one account (`from`) to
702      * another (`to`).
703      *
704      * Note that `value` may be zero.
705      */
706     event Transfer(address indexed from, address indexed to, uint256 value);
707 
708     /**
709      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
710      * a call to {approve}. `value` is the new allowance.
711      */
712     event Approval(address indexed owner, address indexed spender, uint256 value);
713 }
714 
715 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
716 
717 pragma solidity ^0.5.5;
718 
719 /**
720  * @dev Collection of functions related to the address type
721  */
722 library Address {
723     /**
724      * @dev Returns true if `account` is a contract.
725      *
726      * This test is non-exhaustive, and there may be false-negatives: during the
727      * execution of a contract's constructor, its address will be reported as
728      * not containing a contract.
729      *
730      * IMPORTANT: It is unsafe to assume that an address for which this
731      * function returns false is an externally-owned account (EOA) and not a
732      * contract.
733      */
734     function isContract(address account) internal view returns (bool) {
735         // This method relies in extcodesize, which returns 0 for contracts in
736         // construction, since the code is only stored at the end of the
737         // constructor execution.
738 
739         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
740         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
741         // for accounts without code, i.e. `keccak256('')`
742         bytes32 codehash;
743         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
744         // solhint-disable-next-line no-inline-assembly
745         assembly { codehash := extcodehash(account) }
746         return (codehash != 0x0 && codehash != accountHash);
747     }
748 
749     /**
750      * @dev Converts an `address` into `address payable`. Note that this is
751      * simply a type cast: the actual underlying value is not changed.
752      *
753      * _Available since v2.4.0._
754      */
755     function toPayable(address account) internal pure returns (address payable) {
756         return address(uint160(account));
757     }
758 
759     /**
760      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
761      * `recipient`, forwarding all available gas and reverting on errors.
762      *
763      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
764      * of certain opcodes, possibly making contracts go over the 2300 gas limit
765      * imposed by `transfer`, making them unable to receive funds via
766      * `transfer`. {sendValue} removes this limitation.
767      *
768      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
769      *
770      * IMPORTANT: because control is transferred to `recipient`, care must be
771      * taken to not create reentrancy vulnerabilities. Consider using
772      * {ReentrancyGuard} or the
773      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
774      *
775      * _Available since v2.4.0._
776      */
777     function sendValue(address payable recipient, uint256 amount) internal {
778         require(address(this).balance >= amount, "Address: insufficient balance");
779 
780         // solhint-disable-next-line avoid-call-value
781         (bool success, ) = recipient.call.value(amount)("");
782         require(success, "Address: unable to send value, recipient may have reverted");
783     }
784 }
785 
786 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
787 
788 pragma solidity ^0.5.0;
789 
790 /**
791  * @dev Wrappers over Solidity's arithmetic operations with added overflow
792  * checks.
793  *
794  * Arithmetic operations in Solidity wrap on overflow. This can easily result
795  * in bugs, because programmers usually assume that an overflow raises an
796  * error, which is the standard behavior in high level programming languages.
797  * `SafeMath` restores this intuition by reverting the transaction when an
798  * operation overflows.
799  *
800  * Using this library instead of the unchecked operations eliminates an entire
801  * class of bugs, so it's recommended to use it always.
802  */
803 library SafeMath {
804     /**
805      * @dev Returns the addition of two unsigned integers, reverting on
806      * overflow.
807      *
808      * Counterpart to Solidity's `+` operator.
809      *
810      * Requirements:
811      * - Addition cannot overflow.
812      */
813     function add(uint256 a, uint256 b) internal pure returns (uint256) {
814         uint256 c = a + b;
815         require(c >= a, "SafeMath: addition overflow");
816 
817         return c;
818     }
819 
820     /**
821      * @dev Returns the subtraction of two unsigned integers, reverting on
822      * overflow (when the result is negative).
823      *
824      * Counterpart to Solidity's `-` operator.
825      *
826      * Requirements:
827      * - Subtraction cannot overflow.
828      */
829     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
830         return sub(a, b, "SafeMath: subtraction overflow");
831     }
832 
833     /**
834      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
835      * overflow (when the result is negative).
836      *
837      * Counterpart to Solidity's `-` operator.
838      *
839      * Requirements:
840      * - Subtraction cannot overflow.
841      *
842      * _Available since v2.4.0._
843      */
844     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
845         require(b <= a, errorMessage);
846         uint256 c = a - b;
847 
848         return c;
849     }
850 
851     /**
852      * @dev Returns the multiplication of two unsigned integers, reverting on
853      * overflow.
854      *
855      * Counterpart to Solidity's `*` operator.
856      *
857      * Requirements:
858      * - Multiplication cannot overflow.
859      */
860     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
861         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
862         // benefit is lost if 'b' is also tested.
863         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
864         if (a == 0) {
865             return 0;
866         }
867 
868         uint256 c = a * b;
869         require(c / a == b, "SafeMath: multiplication overflow");
870 
871         return c;
872     }
873 
874     /**
875      * @dev Returns the integer division of two unsigned integers. Reverts on
876      * division by zero. The result is rounded towards zero.
877      *
878      * Counterpart to Solidity's `/` operator. Note: this function uses a
879      * `revert` opcode (which leaves remaining gas untouched) while Solidity
880      * uses an invalid opcode to revert (consuming all remaining gas).
881      *
882      * Requirements:
883      * - The divisor cannot be zero.
884      */
885     function div(uint256 a, uint256 b) internal pure returns (uint256) {
886         return div(a, b, "SafeMath: division by zero");
887     }
888 
889     /**
890      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
891      * division by zero. The result is rounded towards zero.
892      *
893      * Counterpart to Solidity's `/` operator. Note: this function uses a
894      * `revert` opcode (which leaves remaining gas untouched) while Solidity
895      * uses an invalid opcode to revert (consuming all remaining gas).
896      *
897      * Requirements:
898      * - The divisor cannot be zero.
899      *
900      * _Available since v2.4.0._
901      */
902     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
903         // Solidity only automatically asserts when dividing by 0
904         require(b > 0, errorMessage);
905         uint256 c = a / b;
906         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
907 
908         return c;
909     }
910 
911     /**
912      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
913      * Reverts when dividing by zero.
914      *
915      * Counterpart to Solidity's `%` operator. This function uses a `revert`
916      * opcode (which leaves remaining gas untouched) while Solidity uses an
917      * invalid opcode to revert (consuming all remaining gas).
918      *
919      * Requirements:
920      * - The divisor cannot be zero.
921      */
922     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
923         return mod(a, b, "SafeMath: modulo by zero");
924     }
925 
926     /**
927      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
928      * Reverts with custom message when dividing by zero.
929      *
930      * Counterpart to Solidity's `%` operator. This function uses a `revert`
931      * opcode (which leaves remaining gas untouched) while Solidity uses an
932      * invalid opcode to revert (consuming all remaining gas).
933      *
934      * Requirements:
935      * - The divisor cannot be zero.
936      *
937      * _Available since v2.4.0._
938      */
939     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
940         require(b != 0, errorMessage);
941         return a % b;
942     }
943 }
944 
945 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol
946 
947 pragma solidity ^0.5.0;
948 
949 
950 
951 
952 /**
953  * @title SafeERC20
954  * @dev Wrappers around ERC20 operations that throw on failure (when the token
955  * contract returns false). Tokens that return no value (and instead revert or
956  * throw on failure) are also supported, non-reverting calls are assumed to be
957  * successful.
958  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
959  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
960  */
961 library SafeERC20 {
962     using SafeMath for uint256;
963     using Address for address;
964 
965     function safeTransfer(IERC20 token, address to, uint256 value) internal {
966         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
967     }
968 
969     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
970         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
971     }
972 
973     function safeApprove(IERC20 token, address spender, uint256 value) internal {
974         // safeApprove should only be called when setting an initial allowance,
975         // or when resetting it to zero. To increase and decrease it, use
976         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
977         // solhint-disable-next-line max-line-length
978         require((value == 0) || (token.allowance(address(this), spender) == 0),
979             "SafeERC20: approve from non-zero to non-zero allowance"
980         );
981         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
982     }
983 
984     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
985         uint256 newAllowance = token.allowance(address(this), spender).add(value);
986         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
987     }
988 
989     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
990         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
991         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
992     }
993 
994     /**
995      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
996      * on the return value: the return value is optional (but if data is returned, it must not be false).
997      * @param token The token targeted by the call.
998      * @param data The call data (encoded using abi.encode or one of its variants).
999      */
1000     function callOptionalReturn(IERC20 token, bytes memory data) private {
1001         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1002         // we're implementing it ourselves.
1003 
1004         // A Solidity high level call has three parts:
1005         //  1. The target address is checked to verify it contains contract code
1006         //  2. The call itself is made, and success asserted
1007         //  3. The return value is decoded, which in turn checks the size of the returned data.
1008         // solhint-disable-next-line max-line-length
1009         require(address(token).isContract(), "SafeERC20: call to non-contract");
1010 
1011         // solhint-disable-next-line avoid-low-level-calls
1012         (bool success, bytes memory returndata) = address(token).call(data);
1013         require(success, "SafeERC20: low-level call failed");
1014 
1015         if (returndata.length > 0) { // Return data is optional
1016             // solhint-disable-next-line max-line-length
1017             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1018         }
1019     }
1020 }
1021 
1022 // File: contracts/mixins/MixinFunds.sol
1023 
1024 pragma solidity 0.5.17;
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * @title An implementation of the money related functions.
1032  * @author HardlyDifficult (unlock-protocol.com)
1033  */
1034 contract MixinFunds
1035 {
1036   using Address for address payable;
1037   using SafeERC20 for IERC20;
1038 
1039   /**
1040    * The token-type that this Lock is priced in.  If 0, then use ETH, else this is
1041    * a ERC20 token address.
1042    */
1043   address public tokenAddress;
1044 
1045   function _initializeMixinFunds(
1046     address _tokenAddress
1047   ) internal
1048   {
1049     tokenAddress = _tokenAddress;
1050     require(
1051       _tokenAddress == address(0) || IERC20(_tokenAddress).totalSupply() > 0,
1052       'INVALID_TOKEN'
1053     );
1054   }
1055 
1056   /**
1057    * Gets the current balance of the account provided.
1058    */
1059   function getBalance(
1060     address _tokenAddress,
1061     address _account
1062   ) public view
1063     returns (uint)
1064   {
1065     if(_tokenAddress == address(0)) {
1066       return _account.balance;
1067     } else {
1068       return IERC20(_tokenAddress).balanceOf(_account);
1069     }
1070   }
1071 
1072   /**
1073    * Transfers funds from the contract to the account provided.
1074    *
1075    * Security: be wary of re-entrancy when calling this function.
1076    */
1077   function _transfer(
1078     address _tokenAddress,
1079     address _to,
1080     uint _amount
1081   ) internal
1082   {
1083     if(_amount > 0) {
1084       if(_tokenAddress == address(0)) {
1085         // https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/
1086         address(uint160(_to)).sendValue(_amount);
1087       } else {
1088         IERC20 token = IERC20(_tokenAddress);
1089         token.safeTransfer(_to, _amount);
1090       }
1091     }
1092   }
1093 }
1094 
1095 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol
1096 
1097 pragma solidity ^0.5.0;
1098 
1099 /**
1100  * @title Roles
1101  * @dev Library for managing addresses assigned to a Role.
1102  */
1103 library Roles {
1104     struct Role {
1105         mapping (address => bool) bearer;
1106     }
1107 
1108     /**
1109      * @dev Give an account access to this role.
1110      */
1111     function add(Role storage role, address account) internal {
1112         require(!has(role, account), "Roles: account already has role");
1113         role.bearer[account] = true;
1114     }
1115 
1116     /**
1117      * @dev Remove an account's access to this role.
1118      */
1119     function remove(Role storage role, address account) internal {
1120         require(has(role, account), "Roles: account does not have role");
1121         role.bearer[account] = false;
1122     }
1123 
1124     /**
1125      * @dev Check if an account has this role.
1126      * @return bool
1127      */
1128     function has(Role storage role, address account) internal view returns (bool) {
1129         require(account != address(0), "Roles: account is the zero address");
1130         return role.bearer[account];
1131     }
1132 }
1133 
1134 // File: contracts/mixins/MixinLockManagerRole.sol
1135 
1136 pragma solidity 0.5.17;
1137 
1138 // This contract mostly follows the pattern established by openzeppelin in
1139 // openzeppelin/contracts-ethereum-package/contracts/access/roles
1140 
1141 
1142 
1143 contract MixinLockManagerRole {
1144   using Roles for Roles.Role;
1145 
1146   event LockManagerAdded(address indexed account);
1147   event LockManagerRemoved(address indexed account);
1148 
1149   Roles.Role private lockManagers;
1150 
1151   function _initializeMixinLockManagerRole(address sender) internal {
1152     if (!isLockManager(sender)) {
1153       lockManagers.add(sender);
1154     }
1155   }
1156 
1157   modifier onlyLockManager() {
1158     require(isLockManager(msg.sender), 'MixinLockManager: caller does not have the LockManager role');
1159     _;
1160   }
1161 
1162   function isLockManager(address account) public view returns (bool) {
1163     return lockManagers.has(account);
1164   }
1165 
1166   function addLockManager(address account) public onlyLockManager {
1167     lockManagers.add(account);
1168     emit LockManagerAdded(account);
1169   }
1170 
1171   function renounceLockManager() public {
1172     lockManagers.remove(msg.sender);
1173     emit LockManagerRemoved(msg.sender);
1174   }
1175 }
1176 
1177 // File: contracts/mixins/MixinDisable.sol
1178 
1179 pragma solidity 0.5.17;
1180 
1181 
1182 
1183 /**
1184  * @title Mixin allowing the Lock owner to disable a Lock (preventing new purchases)
1185  * and then destroy it.
1186  * @author HardlyDifficult
1187  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1188  * separates logically groupings of code to ease readability.
1189  */
1190 contract MixinDisable is
1191   MixinLockManagerRole,
1192   MixinFunds
1193 {
1194   // Used to disable payable functions when deprecating an old lock
1195   bool public isAlive;
1196 
1197   event Disable();
1198 
1199   function _initializeMixinDisable(
1200   ) internal
1201   {
1202     isAlive = true;
1203   }
1204 
1205   // Only allow usage when contract is Alive
1206   modifier onlyIfAlive() {
1207     require(isAlive, 'LOCK_DEPRECATED');
1208     _;
1209   }
1210 
1211   /**
1212   * @dev Used to disable lock before migrating keys and/or destroying contract
1213    */
1214   function disableLock()
1215     external
1216     onlyLockManager
1217     onlyIfAlive
1218   {
1219     emit Disable();
1220     isAlive = false;
1221   }
1222 }
1223 
1224 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721.sol
1225 
1226 pragma solidity ^0.5.0;
1227 
1228 
1229 
1230 /**
1231  * @dev Required interface of an ERC721 compliant contract.
1232  */
1233 contract IERC721 is Initializable, IERC165 {
1234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1235     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1236     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1237 
1238     /**
1239      * @dev Returns the number of NFTs in `owner`'s account.
1240      */
1241     function balanceOf(address owner) public view returns (uint256 balance);
1242 
1243     /**
1244      * @dev Returns the owner of the NFT specified by `tokenId`.
1245      */
1246     function ownerOf(uint256 tokenId) public view returns (address owner);
1247 
1248     /**
1249      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1250      * another (`to`).
1251      *
1252      *
1253      *
1254      * Requirements:
1255      * - `from`, `to` cannot be zero.
1256      * - `tokenId` must be owned by `from`.
1257      * - If the caller is not `from`, it must be have been allowed to move this
1258      * NFT by either {approve} or {setApprovalForAll}.
1259      */
1260     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1261     /**
1262      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1263      * another (`to`).
1264      *
1265      * Requirements:
1266      * - If the caller is not `from`, it must be approved to move this NFT by
1267      * either {approve} or {setApprovalForAll}.
1268      */
1269     function transferFrom(address from, address to, uint256 tokenId) public;
1270     function approve(address to, uint256 tokenId) public;
1271     function getApproved(uint256 tokenId) public view returns (address operator);
1272 
1273     function setApprovalForAll(address operator, bool _approved) public;
1274     function isApprovedForAll(address owner, address operator) public view returns (bool);
1275 
1276 
1277     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1278 }
1279 
1280 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Enumerable.sol
1281 
1282 pragma solidity ^0.5.0;
1283 
1284 
1285 
1286 /**
1287  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1288  * @dev See https://eips.ethereum.org/EIPS/eip-721
1289  */
1290 contract IERC721Enumerable is Initializable, IERC721 {
1291     function totalSupply() public view returns (uint256);
1292     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
1293 
1294     function tokenByIndex(uint256 index) public view returns (uint256);
1295 }
1296 
1297 // File: contracts/interfaces/IUnlock.sol
1298 
1299 pragma solidity 0.5.17;
1300 
1301 
1302 /**
1303  * @title The Unlock Interface
1304  * @author Nick Furfaro (unlock-protocol.com)
1305 **/
1306 
1307 interface IUnlock
1308 {
1309   // Use initialize instead of a constructor to support proxies(for upgradeability via zos).
1310   function initialize(address _unlockOwner) external;
1311 
1312   /**
1313   * @dev Create lock
1314   * This deploys a lock for a creator. It also keeps track of the deployed lock.
1315   * @param _tokenAddress set to the ERC20 token address, or 0 for ETH.
1316   * @param _salt an identifier for the Lock, which is unique for the user.
1317   * This may be implemented as a sequence ID or with RNG. It's used with `create2`
1318   * to know the lock's address before the transaction is mined.
1319   */
1320   function createLock(
1321     uint _expirationDuration,
1322     address _tokenAddress,
1323     uint _keyPrice,
1324     uint _maxNumberOfKeys,
1325     string calldata _lockName,
1326     bytes12 _salt
1327   ) external;
1328 
1329     /**
1330    * This function keeps track of the added GDP, as well as grants of discount tokens
1331    * to the referrer, if applicable.
1332    * The number of discount tokens granted is based on the value of the referal,
1333    * the current growth rate and the lock's discount token distribution rate
1334    * This function is invoked by a previously deployed lock only.
1335    */
1336   function recordKeyPurchase(
1337     uint _value,
1338     address _referrer // solhint-disable-line no-unused-vars
1339   )
1340     external;
1341 
1342     /**
1343    * This function will keep track of consumed discounts by a given user.
1344    * It will also grant discount tokens to the creator who is granting the discount based on the
1345    * amount of discount and compensation rate.
1346    * This function is invoked by a previously deployed lock only.
1347    */
1348   function recordConsumedDiscount(
1349     uint _discount,
1350     uint _tokens // solhint-disable-line no-unused-vars
1351   )
1352     external;
1353 
1354     /**
1355    * This function returns the discount available for a user, when purchasing a
1356    * a key from a lock.
1357    * This does not modify the state. It returns both the discount and the number of tokens
1358    * consumed to grant that discount.
1359    */
1360   function computeAvailableDiscountFor(
1361     address _purchaser, // solhint-disable-line no-unused-vars
1362     uint _keyPrice // solhint-disable-line no-unused-vars
1363   )
1364     external
1365     view
1366     returns(uint discount, uint tokens);
1367 
1368   // Function to read the globalTokenURI field.
1369   function globalBaseTokenURI()
1370     external
1371     view
1372     returns(string memory);
1373 
1374   /**
1375    * @dev Redundant with globalBaseTokenURI() for backwards compatibility with v3 & v4 locks.
1376    */
1377   function getGlobalBaseTokenURI()
1378     external
1379     view
1380     returns (string memory);
1381 
1382   // Function to read the globalTokenSymbol field.
1383   function globalTokenSymbol()
1384     external
1385     view
1386     returns(string memory);
1387 
1388   /**
1389    * @dev Redundant with globalTokenSymbol() for backwards compatibility with v3 & v4 locks.
1390    */
1391   function getGlobalTokenSymbol()
1392     external
1393     view
1394     returns (string memory);
1395 
1396   /** Function for the owner to update configuration variables.
1397    *  Should throw if called by other than owner.
1398    */
1399   function configUnlock(
1400     string calldata _symbol,
1401     string calldata _URI
1402   )
1403     external;
1404 
1405   /**
1406    * @notice Upgrade the PublicLock template used for future calls to `createLock`.
1407    * @dev This will initialize the template and revokeOwnership.
1408    */
1409   function setLockTemplate(
1410     address payable _publicLockAddress
1411   ) external;
1412 
1413   // Allows the owner to change the value tracking variables as needed.
1414   function resetTrackedValue(
1415     uint _grossNetworkProduct,
1416     uint _totalDiscountGranted
1417   ) external;
1418 
1419   function grossNetworkProduct() external view returns(uint);
1420 
1421   function totalDiscountGranted() external view returns(uint);
1422 
1423   function locks(address) external view returns(bool deployed, uint totalSales, uint yieldedDiscountTokens);
1424 
1425   // The address of the public lock template, used when `createLock` is called
1426   function publicLockAddress() external view returns(address);
1427 
1428   // Map token address to exchange contract address if the token is supported
1429   // Used for GDP calculations
1430   function uniswapExchanges(address) external view returns(address);
1431 
1432   // The version number of the current Unlock implementation on this network
1433   function unlockVersion() external pure returns(uint16);
1434 
1435   // allows the owner to set the exchange address to use for value conversions
1436   // setting the _exchangeAddress to address(0) removes support for the token
1437   function setExchange(
1438     address _tokenAddress,
1439     address _exchangeAddress
1440   ) external;
1441 
1442   /**
1443    * @dev Returns true if the caller is the current owner.
1444    */
1445   function isOwner() external view returns(bool);
1446 
1447   /**
1448    * @dev Returns the address of the current owner.
1449    */
1450   function owner() external view returns(address);
1451 
1452   /**
1453    * @dev Leaves the contract without owner. It will not be possible to call
1454    * `onlyOwner` functions anymore. Can only be called by the current owner.
1455    *
1456    * NOTE: Renouncing ownership will leave the contract without an owner,
1457    * thereby removing any functionality that is only available to the owner.
1458    */
1459   function renounceOwnership() external;
1460 
1461   /**
1462    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1463    * Can only be called by the current owner.
1464    */
1465   function transferOwnership(address newOwner) external;
1466 }
1467 
1468 // File: contracts/interfaces/hooks/ILockKeyCancelHook.sol
1469 
1470 pragma solidity 0.5.17;
1471 
1472 
1473 /**
1474  * @notice Functions to be implemented by a keyCancelHook.
1475  * @dev Lock hooks are configured by calling `setEventHooks` on the lock.
1476  */
1477 interface ILockKeyCancelHook
1478 {
1479   /**
1480    * @notice If the lock owner has registered an implementer
1481    * then this hook is called with every key cancel.
1482    * @param operator the msg.sender issuing the cancel
1483    * @param to the account which had the key canceled
1484    * @param refund the amount sent to the `to` account (ETH or a ERC-20 token)
1485    */
1486   function onKeyCancel(
1487     address operator,
1488     address to,
1489     uint256 refund
1490   ) external;
1491 }
1492 
1493 // File: contracts/interfaces/hooks/ILockKeyPurchaseHook.sol
1494 
1495 pragma solidity 0.5.17;
1496 
1497 
1498 /**
1499  * @notice Functions to be implemented by a keyPurchaseHook.
1500  * @dev Lock hooks are configured by calling `setEventHooks` on the lock.
1501  */
1502 interface ILockKeyPurchaseHook
1503 {
1504   /**
1505    * @notice Used to determine the purchase price before issueing a transaction.
1506    * This allows the hook to offer a discount on purchases.
1507    * This may revert to prevent a purchase.
1508    * @param from the msg.sender making the purchase
1509    * @param recipient the account which will be granted a key
1510    * @param referrer the account which referred this key sale
1511    * @param data arbitrary data populated by the front-end which initiated the sale
1512    * @return the minimum value/price required to purchase a key with these settings
1513    * @dev the lock's address is the `msg.sender` when this function is called via
1514    * the lock's `purchasePriceFor` function
1515    */
1516   function keyPurchasePrice(
1517     address from,
1518     address recipient,
1519     address referrer,
1520     bytes calldata data
1521   ) external view
1522     returns (uint minKeyPrice);
1523 
1524   /**
1525    * @notice If the lock owner has registered an implementer then this hook
1526    * is called with every key sold.
1527    * @param from the msg.sender making the purchase
1528    * @param recipient the account which will be granted a key
1529    * @param referrer the account which referred this key sale
1530    * @param data arbitrary data populated by the front-end which initiated the sale
1531    * @param minKeyPrice the price including any discount granted from calling this
1532    * hook's `keyPurchasePrice` function
1533    * @param pricePaid the value/pricePaid included with the purchase transaction
1534    * @dev the lock's address is the `msg.sender` when this function is called
1535    */
1536   function onKeyPurchase(
1537     address from,
1538     address recipient,
1539     address referrer,
1540     bytes calldata data,
1541     uint minKeyPrice,
1542     uint pricePaid
1543   ) external;
1544 }
1545 
1546 // File: contracts/mixins/MixinLockCore.sol
1547 
1548 pragma solidity 0.5.17;
1549 
1550 
1551 
1552 
1553 
1554 
1555 
1556 
1557 
1558 
1559 /**
1560  * @title Mixin for core lock data and functions.
1561  * @author HardlyDifficult
1562  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1563  * separates logically groupings of code to ease readability.
1564  */
1565 contract MixinLockCore is
1566   IERC721Enumerable,
1567   MixinLockManagerRole,
1568   MixinFunds,
1569   MixinDisable
1570 {
1571   using Address for address;
1572 
1573   event Withdrawal(
1574     address indexed sender,
1575     address indexed tokenAddress,
1576     address indexed beneficiary,
1577     uint amount
1578   );
1579 
1580   event PricingChanged(
1581     uint oldKeyPrice,
1582     uint keyPrice,
1583     address oldTokenAddress,
1584     address tokenAddress
1585   );
1586 
1587   // Unlock Protocol address
1588   // TODO: should we make that private/internal?
1589   IUnlock public unlockProtocol;
1590 
1591   // Duration in seconds for which the keys are valid, after creation
1592   // should we take a smaller type use less gas?
1593   // TODO: add support for a timestamp instead of duration
1594   uint public expirationDuration;
1595 
1596   // price in wei of the next key
1597   // TODO: allow support for a keyPriceCalculator which could set prices dynamically
1598   uint public keyPrice;
1599 
1600   // Max number of keys sold if the keyReleaseMechanism is public
1601   uint public maxNumberOfKeys;
1602 
1603   // A count of how many new key purchases there have been
1604   uint internal _totalSupply;
1605 
1606   // The account which will receive funds on withdrawal
1607   address public beneficiary;
1608 
1609   // The denominator component for values specified in basis points.
1610   uint internal constant BASIS_POINTS_DEN = 10000;
1611 
1612   ILockKeyPurchaseHook public onKeyPurchaseHook;
1613   ILockKeyCancelHook public onKeyCancelHook;
1614 
1615   // Ensure that the Lock has not sold all of its keys.
1616   modifier notSoldOut() {
1617     require(maxNumberOfKeys > _totalSupply, 'LOCK_SOLD_OUT');
1618     _;
1619   }
1620 
1621   modifier onlyLockManagerOrBeneficiary()
1622   {
1623     require(
1624       isLockManager(msg.sender) || msg.sender == beneficiary,
1625       'ONLY_LOCK_MANAGER_OR_BENEFICIARY'
1626     );
1627     _;
1628   }
1629 
1630   function _initializeMixinLockCore(
1631     address _beneficiary,
1632     uint _expirationDuration,
1633     uint _keyPrice,
1634     uint _maxNumberOfKeys
1635   ) internal
1636   {
1637     require(_expirationDuration <= 100 * 365 * 24 * 60 * 60, 'MAX_EXPIRATION_100_YEARS');
1638     unlockProtocol = IUnlock(msg.sender); // Make sure we link back to Unlock's smart contract.
1639     beneficiary = _beneficiary;
1640     expirationDuration = _expirationDuration;
1641     keyPrice = _keyPrice;
1642     maxNumberOfKeys = _maxNumberOfKeys;
1643   }
1644 
1645   // The version number of the current implementation on this network
1646   function publicLockVersion(
1647   ) public pure
1648     returns (uint)
1649   {
1650     return 7;
1651   }
1652 
1653   /**
1654    * @dev Called by owner to withdraw all funds from the lock and send them to the `beneficiary`.
1655    * @param _tokenAddress specifies the token address to withdraw or 0 for ETH. This is usually
1656    * the same as `tokenAddress` in MixinFunds.
1657    * @param _amount specifies the max amount to withdraw, which may be reduced when
1658    * considering the available balance. Set to 0 or MAX_UINT to withdraw everything.
1659    *
1660    * TODO: consider allowing anybody to trigger this as long as it goes to owner anyway?
1661    *  -- however be wary of draining funds as it breaks the `cancelAndRefund` and `expireAndRefundFor`
1662    * use cases.
1663    */
1664   function withdraw(
1665     address _tokenAddress,
1666     uint _amount
1667   ) external
1668     onlyLockManagerOrBeneficiary
1669   {
1670     uint balance = getBalance(_tokenAddress, address(this));
1671     uint amount;
1672     if(_amount == 0 || _amount > balance)
1673     {
1674       require(balance > 0, 'NOT_ENOUGH_FUNDS');
1675       amount = balance;
1676     }
1677     else
1678     {
1679       amount = _amount;
1680     }
1681 
1682     emit Withdrawal(msg.sender, _tokenAddress, beneficiary, amount);
1683     // Security: re-entrancy not a risk as this is the last line of an external function
1684     _transfer(_tokenAddress, beneficiary, amount);
1685   }
1686 
1687   /**
1688    * A function which lets the owner of the lock change the pricing for future purchases.
1689    * This consists of 2 parts: The token address and the price in the given token.
1690    * In order to set the token to ETH, use 0 for the token Address.
1691    */
1692   function updateKeyPricing(
1693     uint _keyPrice,
1694     address _tokenAddress
1695   )
1696     external
1697     onlyLockManager
1698     onlyIfAlive
1699   {
1700     uint oldKeyPrice = keyPrice;
1701     address oldTokenAddress = tokenAddress;
1702     require(
1703       _tokenAddress == address(0) || IERC20(_tokenAddress).totalSupply() > 0,
1704       'INVALID_TOKEN'
1705     );
1706     keyPrice = _keyPrice;
1707     tokenAddress = _tokenAddress;
1708     emit PricingChanged(oldKeyPrice, keyPrice, oldTokenAddress, tokenAddress);
1709   }
1710 
1711   /**
1712    * A function which lets the owner of the lock update the beneficiary account,
1713    * which receives funds on withdrawal.
1714    */
1715   function updateBeneficiary(
1716     address _beneficiary
1717   ) external
1718   {
1719     require(msg.sender == beneficiary || isLockManager(msg.sender), 'ONLY_BENEFICIARY_OR_LOCKMANAGER');
1720     require(_beneficiary != address(0), 'INVALID_ADDRESS');
1721     beneficiary = _beneficiary;
1722   }
1723 
1724   /**
1725    * @notice Allows a lock manager to add or remove an event hook
1726    */
1727   function setEventHooks(
1728     address _onKeyPurchaseHook,
1729     address _onKeyCancelHook
1730   ) external
1731     onlyLockManager()
1732   {
1733     require(_onKeyPurchaseHook == address(0) || _onKeyPurchaseHook.isContract(), 'INVALID_ON_KEY_SOLD_HOOK');
1734     require(_onKeyCancelHook == address(0) || _onKeyCancelHook.isContract(), 'INVALID_ON_KEY_CANCEL_HOOK');
1735     onKeyPurchaseHook = ILockKeyPurchaseHook(_onKeyPurchaseHook);
1736     onKeyCancelHook = ILockKeyCancelHook(_onKeyCancelHook);
1737   }
1738 
1739   function totalSupply()
1740     public
1741     view returns(uint256)
1742   {
1743     return _totalSupply;
1744   }
1745 }
1746 
1747 // File: contracts/mixins/MixinKeys.sol
1748 
1749 pragma solidity 0.5.17;
1750 
1751 
1752 
1753 
1754 /**
1755  * @title Mixin for managing `Key` data, as well as the * Approval related functions needed to meet the ERC721
1756  * standard.
1757  * @author HardlyDifficult
1758  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1759  * separates logically groupings of code to ease readability.
1760  */
1761 contract MixinKeys is
1762   MixinLockCore
1763 {
1764   using SafeMath for uint;
1765 
1766   // The struct for a key
1767   struct Key {
1768     uint tokenId;
1769     uint expirationTimestamp;
1770   }
1771 
1772   // Emitted when the Lock owner expires a user's Key
1773   event ExpireKey(uint indexed tokenId);
1774 
1775   // Emitted when the expiration of a key is modified
1776   event ExpirationChanged(
1777     uint indexed _tokenId,
1778     uint _amount,
1779     bool _timeAdded
1780   );
1781 
1782   event KeyManagerChanged(uint indexed _tokenId, address indexed _newManager);
1783 
1784 
1785   // Keys
1786   // Each owner can have at most exactly one key
1787   // TODO: could we use public here? (this could be confusing though because it getter will
1788   // return 0 values when missing a key)
1789   mapping (address => Key) internal keyByOwner;
1790 
1791   // Each tokenId can have at most exactly one owner at a time.
1792   // Returns 0 if the token does not exist
1793   // TODO: once we decouple tokenId from owner address (incl in js), then we can consider
1794   // merging this with totalSupply into an array instead.
1795   mapping (uint => address) internal _ownerOf;
1796 
1797   // Addresses of owners are also stored in an array.
1798   // Addresses are never removed by design to avoid abuses around referals
1799   address[] public owners;
1800 
1801   // A given key has both an owner and a manager.
1802   // If keyManager == address(0) then the key owner is also the manager
1803   // Each key can have at most 1 keyManager.
1804   mapping (uint => address) public keyManagerOf;
1805 
1806     // Keeping track of approved transfers
1807   // This is a mapping of addresses which have approved
1808   // the transfer of a key to another address where their key can be transferred
1809   // Note: the approver may actually NOT have a key... and there can only
1810   // be a single approved address
1811   mapping (uint => address) private approved;
1812 
1813     // Keeping track of approved operators for a given Key manager.
1814   // This approves a given operator for all keys managed by the calling "keyManager"
1815   // The caller may not currently be the keyManager for ANY keys.
1816   // These approvals are never reset/revoked automatically, unlike "approved",
1817   // which is reset on transfer.
1818   mapping (address => mapping (address => bool)) private managerToOperatorApproved;
1819 
1820     // Ensure that the caller is the keyManager of the key
1821   // or that the caller has been approved
1822   // for ownership of that key
1823   modifier onlyKeyManagerOrApproved(
1824     uint _tokenId
1825   )
1826   {
1827     require(
1828       _isKeyManager(_tokenId, msg.sender) ||
1829       _isApproved(_tokenId, msg.sender) ||
1830       isApprovedForAll(_ownerOf[_tokenId], msg.sender),
1831       'ONLY_KEY_MANAGER_OR_APPROVED'
1832     );
1833     _;
1834   }
1835 
1836   // Ensures that an owner owns or has owned a key in the past
1837   modifier ownsOrHasOwnedKey(
1838     address _keyOwner
1839   ) {
1840     require(
1841       keyByOwner[_keyOwner].expirationTimestamp > 0, 'HAS_NEVER_OWNED_KEY'
1842     );
1843     _;
1844   }
1845 
1846   // Ensures that an owner has a valid key
1847   modifier hasValidKey(
1848     address _user
1849   ) {
1850     require(
1851       getHasValidKey(_user), 'KEY_NOT_VALID'
1852     );
1853     _;
1854   }
1855 
1856   // Ensures that a key has an owner
1857   modifier isKey(
1858     uint _tokenId
1859   ) {
1860     require(
1861       _ownerOf[_tokenId] != address(0), 'NO_SUCH_KEY'
1862     );
1863     _;
1864   }
1865 
1866   // Ensure that the caller owns the key
1867   modifier onlyKeyOwner(
1868     uint _tokenId
1869   ) {
1870     require(
1871       isKeyOwner(_tokenId, msg.sender), 'ONLY_KEY_OWNER'
1872     );
1873     _;
1874   }
1875 
1876   /**
1877    * In the specific case of a Lock, each owner can own only at most 1 key.
1878    * @return The number of NFTs owned by `_keyOwner`, either 0 or 1.
1879   */
1880   function balanceOf(
1881     address _keyOwner
1882   )
1883     public
1884     view
1885     returns (uint)
1886   {
1887     require(_keyOwner != address(0), 'INVALID_ADDRESS');
1888     return getHasValidKey(_keyOwner) ? 1 : 0;
1889   }
1890 
1891   /**
1892    * Checks if the user has a non-expired key.
1893    */
1894   function getHasValidKey(
1895     address _keyOwner
1896   )
1897     public
1898     view
1899     returns (bool)
1900   {
1901     return keyByOwner[_keyOwner].expirationTimestamp > block.timestamp;
1902   }
1903 
1904   /**
1905    * @notice Find the tokenId for a given user
1906    * @return The tokenId of the NFT, else returns 0
1907   */
1908   function getTokenIdFor(
1909     address _account
1910   ) public view
1911     returns (uint)
1912   {
1913     return keyByOwner[_account].tokenId;
1914   }
1915 
1916  /**
1917   * A function which returns a subset of the keys for this Lock as an array
1918   * @param _page the page of key owners requested when faceted by page size
1919   * @param _pageSize the number of Key Owners requested per page
1920   */
1921   function getOwnersByPage(uint _page, uint _pageSize)
1922     public
1923     view
1924     returns (address[] memory)
1925   {
1926     require(owners.length > 0, 'NO_OUTSTANDING_KEYS');
1927     uint pageSize = _pageSize;
1928     uint _startIndex = _page * pageSize;
1929     uint endOfPageIndex;
1930 
1931     if (_startIndex + pageSize > owners.length) {
1932       endOfPageIndex = owners.length;
1933       pageSize = owners.length - _startIndex;
1934     } else {
1935       endOfPageIndex = (_startIndex + pageSize);
1936     }
1937 
1938     // new temp in-memory array to hold pageSize number of requested owners:
1939     address[] memory ownersByPage = new address[](pageSize);
1940     uint pageIndex = 0;
1941 
1942     // Build the requested set of owners into a new temporary array:
1943     for (uint i = _startIndex; i < endOfPageIndex; i++) {
1944       ownersByPage[pageIndex] = owners[i];
1945       pageIndex++;
1946     }
1947 
1948     return ownersByPage;
1949   }
1950 
1951   /**
1952    * Checks if the given address owns the given tokenId.
1953    */
1954   function isKeyOwner(
1955     uint _tokenId,
1956     address _keyOwner
1957   ) public view
1958     returns (bool)
1959   {
1960     return _ownerOf[_tokenId] == _keyOwner;
1961   }
1962 
1963   /**
1964   * @dev Returns the key's ExpirationTimestamp field for a given owner.
1965   * @param _keyOwner address of the user for whom we search the key
1966   * @dev Returns 0 if the owner has never owned a key for this lock
1967   */
1968   function keyExpirationTimestampFor(
1969     address _keyOwner
1970   ) public view
1971     returns (uint)
1972   {
1973     return keyByOwner[_keyOwner].expirationTimestamp;
1974   }
1975 
1976   /**
1977    * Public function which returns the total number of unique owners (both expired
1978    * and valid).  This may be larger than totalSupply.
1979    */
1980   function numberOfOwners()
1981     public
1982     view
1983     returns (uint)
1984   {
1985     return owners.length;
1986   }
1987   // Returns the owner of a given tokenId
1988   function ownerOf(
1989     uint _tokenId
1990   ) public view
1991     isKey(_tokenId)
1992     returns(address)
1993   {
1994     return _ownerOf[_tokenId];
1995   }
1996 
1997   /**
1998   * @notice Public function for updating transfer and cancel rights for a given key
1999   * @param _tokenId The id of the key to assign rights for
2000   * @param _keyManager The address with the manager's rights for the given key.
2001   * Setting _keyManager to address(0) means the keyOwner is also the keyManager
2002    */
2003   function setKeyManagerOf(
2004     uint _tokenId,
2005     address _keyManager
2006   ) public
2007     isKey(_tokenId)
2008   {
2009     require(
2010       _isKeyManager(_tokenId, msg.sender) ||
2011       isLockManager(msg.sender),
2012       'UNAUTHORIZED_KEY_MANAGER_UPDATE'
2013     );
2014     _setKeyManagerOf(_tokenId, _keyManager);
2015   }
2016 
2017   function _setKeyManagerOf(
2018     uint _tokenId,
2019     address _keyManager
2020   ) internal
2021   {
2022     if(keyManagerOf[_tokenId] != _keyManager) {
2023       keyManagerOf[_tokenId] = _keyManager;
2024       _clearApproval(_tokenId);
2025       emit KeyManagerChanged(_tokenId, address(0));
2026     }
2027   }
2028 
2029     /**
2030    * This approves _approved to get ownership of _tokenId.
2031    * Note: that since this is used for both purchase and transfer approvals
2032    * the approved token may not exist.
2033    */
2034   function approve(
2035     address _approved,
2036     uint _tokenId
2037   )
2038     public
2039     onlyIfAlive
2040     onlyKeyManagerOrApproved(_tokenId)
2041   {
2042     require(msg.sender != _approved, 'APPROVE_SELF');
2043 
2044     approved[_tokenId] = _approved;
2045     emit Approval(_ownerOf[_tokenId], _approved, _tokenId);
2046   }
2047 
2048     /**
2049    * @notice Get the approved address for a single NFT
2050    * @dev Throws if `_tokenId` is not a valid NFT.
2051    * @param _tokenId The NFT to find the approved address for
2052    * @return The approved address for this NFT, or the zero address if there is none
2053    */
2054   function getApproved(
2055     uint _tokenId
2056   ) public view
2057     isKey(_tokenId)
2058     returns (address)
2059   {
2060     address approvedRecipient = approved[_tokenId];
2061     return approvedRecipient;
2062   }
2063 
2064     /**
2065    * @dev Tells whether an operator is approved by a given keyManager
2066    * @param _owner owner address which you want to query the approval of
2067    * @param _operator operator address which you want to query the approval of
2068    * @return bool whether the given operator is approved by the given owner
2069    */
2070   function isApprovedForAll(
2071     address _owner,
2072     address _operator
2073   ) public view
2074     returns (bool)
2075   {
2076     uint tokenId = keyByOwner[_owner].tokenId;
2077     address keyManager = keyManagerOf[tokenId];
2078     if(keyManager == address(0)) {
2079       return managerToOperatorApproved[_owner][_operator];
2080     } else {
2081       return managerToOperatorApproved[keyManager][_operator];
2082     }
2083   }
2084 
2085   /**
2086   * Returns true if _keyManager is the manager of the key
2087   * identified by _tokenId
2088    */
2089   function _isKeyManager(
2090     uint _tokenId,
2091     address _keyManager
2092   ) internal view
2093     returns (bool)
2094   {
2095     if(keyManagerOf[_tokenId] == _keyManager ||
2096       (keyManagerOf[_tokenId] == address(0) && isKeyOwner(_tokenId, _keyManager))) {
2097       return true;
2098     } else {
2099       return false;
2100     }
2101   }
2102 
2103   /**
2104    * Assigns the key a new tokenId (from totalSupply) if it does not already have
2105    * one assigned.
2106    */
2107   function _assignNewTokenId(
2108     Key storage _key
2109   ) internal
2110   {
2111     if (_key.tokenId == 0) {
2112       // This is a brand new owner
2113       // We increment the tokenId counter
2114       _totalSupply++;
2115       // we assign the incremented `_totalSupply` as the tokenId for the new key
2116       _key.tokenId = _totalSupply;
2117     }
2118   }
2119 
2120   /**
2121    * Records the owner of a given tokenId
2122    */
2123   function _recordOwner(
2124     address _keyOwner,
2125     uint _tokenId
2126   ) internal
2127   {
2128     if (_ownerOf[_tokenId] != _keyOwner) {
2129       // TODO: this may include duplicate entries
2130       owners.push(_keyOwner);
2131       // We register the owner of the tokenID
2132       _ownerOf[_tokenId] = _keyOwner;
2133     }
2134   }
2135 
2136   /**
2137   * @notice Modify the expirationTimestamp of a key
2138   * by a given amount.
2139   * @param _tokenId The ID of the key to modify.
2140   * @param _deltaT The amount of time in seconds by which
2141   * to modify the keys expirationTimestamp
2142   * @param _addTime Choose whether to increase or decrease
2143   * expirationTimestamp (false == decrease, true == increase)
2144   * @dev Throws if owner does not have a valid key.
2145   */
2146   function _timeMachine(
2147     uint _tokenId,
2148     uint256 _deltaT,
2149     bool _addTime
2150   ) internal
2151   {
2152     address tokenOwner = _ownerOf[_tokenId];
2153     require(tokenOwner != address(0), 'NON_EXISTENT_KEY');
2154     Key storage key = keyByOwner[tokenOwner];
2155     uint formerTimestamp = key.expirationTimestamp;
2156     bool validKey = getHasValidKey(tokenOwner);
2157     if(_addTime) {
2158       if(validKey) {
2159         key.expirationTimestamp = formerTimestamp.add(_deltaT);
2160       } else {
2161         key.expirationTimestamp = block.timestamp.add(_deltaT);
2162       }
2163     } else {
2164       key.expirationTimestamp = formerTimestamp.sub(_deltaT);
2165     }
2166     emit ExpirationChanged(_tokenId, _deltaT, _addTime);
2167   }
2168 
2169     /**
2170    * @dev Sets or unsets the approval of a given operator
2171    * An operator is allowed to transfer all tokens of the sender on their behalf
2172    * @param _to operator address to set the approval
2173    * @param _approved representing the status of the approval to be set
2174    */
2175   function setApprovalForAll(
2176     address _to,
2177     bool _approved
2178   ) public
2179     onlyIfAlive
2180   {
2181     require(_to != msg.sender, 'APPROVE_SELF');
2182     managerToOperatorApproved[msg.sender][_to] = _approved;
2183     emit ApprovalForAll(msg.sender, _to, _approved);
2184   }
2185 
2186     /**
2187    * @dev Checks if the given user is approved to transfer the tokenId.
2188    */
2189   function _isApproved(
2190     uint _tokenId,
2191     address _user
2192   ) internal view
2193     returns (bool)
2194   {
2195     return approved[_tokenId] == _user;
2196   }
2197 
2198     /**
2199    * @dev Function to clear current approval of a given token ID
2200    * @param _tokenId uint256 ID of the token to be transferred
2201    */
2202   function _clearApproval(
2203     uint256 _tokenId
2204   ) internal
2205   {
2206     if (approved[_tokenId] != address(0)) {
2207       approved[_tokenId] = address(0);
2208     }
2209   }
2210 }
2211 
2212 // File: contracts/mixins/MixinERC721Enumerable.sol
2213 
2214 pragma solidity 0.5.17;
2215 
2216 
2217 
2218 
2219 
2220 
2221 /**
2222  * @title Implements the ERC-721 Enumerable extension.
2223  */
2224 contract MixinERC721Enumerable is
2225   IERC721Enumerable,
2226   ERC165,
2227   MixinLockCore, // Implements totalSupply
2228   MixinKeys
2229 {
2230   function _initializeMixinERC721Enumerable() internal
2231   {
2232     /**
2233      * register the supported interface to conform to ERC721Enumerable via ERC165
2234      * 0x780e9d63 ===
2235      *     bytes4(keccak256('totalSupply()')) ^
2236      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
2237      *     bytes4(keccak256('tokenByIndex(uint256)'))
2238      */
2239     _registerInterface(0x780e9d63);
2240   }
2241 
2242   /// @notice Enumerate valid NFTs
2243   /// @dev Throws if `_index` >= `totalSupply()`.
2244   /// @param _index A counter less than `totalSupply()`
2245   /// @return The token identifier for the `_index`th NFT,
2246   ///  (sort order not specified)
2247   function tokenByIndex(
2248     uint256 _index
2249   ) public view
2250     returns (uint256)
2251   {
2252     require(_index < _totalSupply, 'OUT_OF_RANGE');
2253     return _index;
2254   }
2255 
2256   /// @notice Enumerate NFTs assigned to an owner
2257   /// @dev Throws if `_index` >= `balanceOf(_keyOwner)` or if
2258   ///  `_keyOwner` is the zero address, representing invalid NFTs.
2259   /// @param _keyOwner An address where we are interested in NFTs owned by them
2260   /// @param _index A counter less than `balanceOf(_keyOwner)`
2261   /// @return The token identifier for the `_index`th NFT assigned to `_keyOwner`,
2262   ///   (sort order not specified)
2263   function tokenOfOwnerByIndex(
2264     address _keyOwner,
2265     uint256 _index
2266   ) public view
2267     returns (uint256)
2268   {
2269     require(_index == 0, 'ONLY_ONE_KEY_PER_OWNER');
2270     return getTokenIdFor(_keyOwner);
2271   }
2272 }
2273 
2274 // File: contracts/mixins/MixinKeyGranterRole.sol
2275 
2276 pragma solidity 0.5.17;
2277 
2278 // This contract mostly follows the pattern established by openzeppelin in
2279 // openzeppelin/contracts-ethereum-package/contracts/access/roles
2280 
2281 
2282 
2283 
2284 contract MixinKeyGranterRole is MixinLockManagerRole {
2285   using Roles for Roles.Role;
2286 
2287   event KeyGranterAdded(address indexed account);
2288   event KeyGranterRemoved(address indexed account);
2289 
2290   Roles.Role private keyGranters;
2291 
2292   function _initializeMixinKeyGranterRole(address sender) internal {
2293     if (!isKeyGranter(sender)) {
2294       keyGranters.add(sender);
2295     }
2296   }
2297 
2298   modifier onlyKeyGranterOrManager() {
2299     require(isKeyGranter(msg.sender) || isLockManager(msg.sender), 'MixinKeyGranter: caller does not have the KeyGranter or LockManager role');
2300     _;
2301   }
2302 
2303   function isKeyGranter(address account) public view returns (bool) {
2304     return keyGranters.has(account);
2305   }
2306 
2307   function addKeyGranter(address account) public onlyLockManager {
2308     keyGranters.add(account);
2309     emit KeyGranterAdded(account);
2310   }
2311 
2312   function revokeKeyGranter(address _granter) public onlyLockManager {
2313     keyGranters.remove(_granter);
2314     emit KeyGranterRemoved(_granter);
2315   }
2316 }
2317 
2318 // File: contracts/mixins/MixinGrantKeys.sol
2319 
2320 pragma solidity 0.5.17;
2321 
2322 
2323 
2324 
2325 /**
2326  * @title Mixin allowing the Lock owner to grant / gift keys to users.
2327  * @author HardlyDifficult
2328  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
2329  * separates logically groupings of code to ease readability.
2330  */
2331 contract MixinGrantKeys is
2332   MixinKeyGranterRole,
2333   MixinKeys
2334 {
2335   /**
2336    * Allows the Lock owner to give a collection of users a key with no charge.
2337    * Each key may be assigned a different expiration date.
2338    */
2339   function grantKeys(
2340     address[] calldata _recipients,
2341     uint[] calldata _expirationTimestamps,
2342     address[] calldata _keyManagers
2343   ) external
2344     onlyKeyGranterOrManager
2345   {
2346     for(uint i = 0; i < _recipients.length; i++) {
2347       address recipient = _recipients[i];
2348       uint expirationTimestamp = _expirationTimestamps[i];
2349       address keyManager = _keyManagers[i];
2350 
2351       require(recipient != address(0), 'INVALID_ADDRESS');
2352 
2353       Key storage toKey = keyByOwner[recipient];
2354       require(expirationTimestamp > toKey.expirationTimestamp, 'ALREADY_OWNS_KEY');
2355 
2356       uint idTo = toKey.tokenId;
2357 
2358       if(idTo == 0) {
2359         _assignNewTokenId(toKey);
2360         idTo = toKey.tokenId;
2361         _recordOwner(recipient, idTo);
2362       }
2363       // Set the key Manager
2364       _setKeyManagerOf(idTo, keyManager);
2365       emit KeyManagerChanged(idTo, keyManager);
2366 
2367       toKey.expirationTimestamp = expirationTimestamp;
2368       // trigger event
2369       emit Transfer(
2370         address(0), // This is a creation.
2371         recipient,
2372         idTo
2373       );
2374     }
2375   }
2376 }
2377 
2378 // File: contracts/UnlockUtils.sol
2379 
2380 pragma solidity 0.5.17;
2381 
2382 // This contract provides some utility methods for use with the unlock protocol smart contracts.
2383 // Borrowed from:
2384 // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol#L943
2385 
2386 library UnlockUtils {
2387 
2388   function strConcat(
2389     string memory _a,
2390     string memory _b,
2391     string memory _c,
2392     string memory _d
2393   ) internal pure
2394     returns (string memory _concatenatedString)
2395   {
2396     return string(abi.encodePacked(_a, _b, _c, _d));
2397   }
2398 
2399   function uint2Str(
2400     uint _i
2401   ) internal pure
2402     returns (string memory _uintAsString)
2403   {
2404     // make a copy of the param to avoid security/no-assign-params error
2405     uint c = _i;
2406     if (_i == 0) {
2407       return '0';
2408     }
2409     uint j = _i;
2410     uint len;
2411     while (j != 0) {
2412       len++;
2413       j /= 10;
2414     }
2415     bytes memory bstr = new bytes(len);
2416     uint k = len - 1;
2417     while (c != 0) {
2418       bstr[k--] = byte(uint8(48 + c % 10));
2419       c /= 10;
2420     }
2421     return string(bstr);
2422   }
2423 
2424   function address2Str(
2425     address _addr
2426   ) internal pure
2427     returns(string memory)
2428   {
2429     bytes32 value = bytes32(uint256(_addr));
2430     bytes memory alphabet = '0123456789abcdef';
2431     bytes memory str = new bytes(42);
2432     str[0] = '0';
2433     str[1] = 'x';
2434     for (uint i = 0; i < 20; i++) {
2435       str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
2436       str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
2437     }
2438     return string(str);
2439   }
2440 }
2441 
2442 // File: contracts/mixins/MixinLockMetadata.sol
2443 
2444 pragma solidity 0.5.17;
2445 
2446 
2447 
2448 
2449 
2450 
2451 
2452 /**
2453  * @title Mixin for metadata about the Lock.
2454  * @author HardlyDifficult
2455  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
2456  * separates logically groupings of code to ease readability.
2457  */
2458 contract MixinLockMetadata is
2459   IERC721Enumerable,
2460   ERC165,
2461   MixinLockManagerRole,
2462   MixinLockCore,
2463   MixinKeys
2464 {
2465   using UnlockUtils for uint;
2466   using UnlockUtils for address;
2467   using UnlockUtils for string;
2468 
2469   /// A descriptive name for a collection of NFTs in this contract.Defaults to "Unlock-Protocol" but is settable by lock owner
2470   string public name;
2471 
2472   /// An abbreviated name for NFTs in this contract. Defaults to "KEY" but is settable by lock owner
2473   string private lockSymbol;
2474 
2475   // the base Token URI for this Lock. If not set by lock owner, the global URI stored in Unlock is used.
2476   string private baseTokenURI;
2477 
2478   event NewLockSymbol(
2479     string symbol
2480   );
2481 
2482   function _initializeMixinLockMetadata(
2483     string memory _lockName
2484   ) internal
2485   {
2486     ERC165.initialize();
2487     name = _lockName;
2488     // registering the optional erc721 metadata interface with ERC165.sol using
2489     // the ID specified in the standard: https://eips.ethereum.org/EIPS/eip-721
2490     _registerInterface(0x5b5e139f);
2491   }
2492 
2493   /**
2494    * Allows the Lock owner to assign a descriptive name for this Lock.
2495    */
2496   function updateLockName(
2497     string calldata _lockName
2498   ) external
2499     onlyLockManager
2500   {
2501     name = _lockName;
2502   }
2503 
2504   /**
2505    * Allows the Lock owner to assign a Symbol for this Lock.
2506    */
2507   function updateLockSymbol(
2508     string calldata _lockSymbol
2509   ) external
2510     onlyLockManager
2511   {
2512     lockSymbol = _lockSymbol;
2513     emit NewLockSymbol(_lockSymbol);
2514   }
2515 
2516   /**
2517     * @dev Gets the token symbol
2518     * @return string representing the token name
2519     */
2520   function symbol()
2521     external view
2522     returns(string memory)
2523   {
2524     if(bytes(lockSymbol).length == 0) {
2525       return unlockProtocol.globalTokenSymbol();
2526     } else {
2527       return lockSymbol;
2528     }
2529   }
2530 
2531   /**
2532    * Allows the Lock owner to update the baseTokenURI for this Lock.
2533    */
2534   function setBaseTokenURI(
2535     string calldata _baseTokenURI
2536   ) external
2537     onlyLockManager
2538   {
2539     baseTokenURI = _baseTokenURI;
2540   }
2541 
2542   /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
2543    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
2544    *  3986. The URI may point to a JSON file that conforms to the "ERC721
2545    *  Metadata JSON Schema".
2546    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
2547    */
2548   function tokenURI(
2549     uint256 _tokenId
2550   ) external
2551     view
2552     isKey(_tokenId)
2553     returns(string memory)
2554   {
2555     string memory URI;
2556     if(bytes(baseTokenURI).length == 0) {
2557       URI = unlockProtocol.globalBaseTokenURI();
2558     } else {
2559       URI = baseTokenURI;
2560     }
2561 
2562     return URI.strConcat(
2563       address(this).address2Str(),
2564       '/',
2565       _tokenId.uint2Str()
2566     );
2567   }
2568 }
2569 
2570 // File: contracts/mixins/MixinPurchase.sol
2571 
2572 pragma solidity 0.5.17;
2573 
2574 
2575 
2576 
2577 
2578 
2579 
2580 /**
2581  * @title Mixin for the purchase-related functions.
2582  * @author HardlyDifficult
2583  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
2584  * separates logically groupings of code to ease readability.
2585  */
2586 contract MixinPurchase is
2587   MixinFunds,
2588   MixinDisable,
2589   MixinLockCore,
2590   MixinKeys
2591 {
2592   using SafeMath for uint;
2593 
2594   event RenewKeyPurchase(address indexed owner, uint newExpiration);
2595 
2596   /**
2597   * @dev Purchase function
2598   * @param _value the number of tokens to pay for this purchase >= the current keyPrice - any applicable discount
2599   * (_value is ignored when using ETH)
2600   * @param _recipient address of the recipient of the purchased key
2601   * @param _referrer address of the user making the referral
2602   * @param _data arbitrary data populated by the front-end which initiated the sale
2603   * @dev Setting _value to keyPrice exactly doubles as a security feature. That way if the lock owner increases the
2604   * price while my transaction is pending I can't be charged more than I expected (only applicable to ERC-20 when more
2605   * than keyPrice is approved for spending).
2606   */
2607   function purchase(
2608     uint256 _value,
2609     address _recipient,
2610     address _referrer,
2611     bytes calldata _data
2612   ) external payable
2613     onlyIfAlive
2614     notSoldOut
2615   {
2616     require(_recipient != address(0), 'INVALID_ADDRESS');
2617 
2618     // Assign the key
2619     Key storage toKey = keyByOwner[_recipient];
2620     uint idTo = toKey.tokenId;
2621     uint newTimeStamp;
2622 
2623     if (idTo == 0) {
2624       // Assign a new tokenId (if a new owner or previously transferred)
2625       _assignNewTokenId(toKey);
2626       // refresh the cached value
2627       idTo = toKey.tokenId;
2628       _recordOwner(_recipient, idTo);
2629       newTimeStamp = block.timestamp + expirationDuration;
2630       toKey.expirationTimestamp = newTimeStamp;
2631 
2632       // trigger event
2633       emit Transfer(
2634         address(0), // This is a creation.
2635         _recipient,
2636         idTo
2637       );
2638     } else if (toKey.expirationTimestamp > block.timestamp) {
2639       // This is an existing owner trying to extend their key
2640       newTimeStamp = toKey.expirationTimestamp.add(expirationDuration);
2641       toKey.expirationTimestamp = newTimeStamp;
2642       emit RenewKeyPurchase(_recipient, newTimeStamp);
2643     } else {
2644       // This is an existing owner trying to renew their expired key
2645       // SafeAdd is not required here since expirationDuration is capped to a tiny value
2646       // (relative to the size of a uint)
2647       newTimeStamp = block.timestamp + expirationDuration;
2648       toKey.expirationTimestamp = newTimeStamp;
2649 
2650       // reset the key Manager to 0x00
2651       _setKeyManagerOf(idTo, address(0));
2652 
2653       emit RenewKeyPurchase(_recipient, newTimeStamp);
2654     }
2655 
2656     (uint inMemoryKeyPrice, uint discount, uint tokens) = _purchasePriceFor(_recipient, _referrer, _data);
2657     if (discount > 0)
2658     {
2659       unlockProtocol.recordConsumedDiscount(discount, tokens);
2660     }
2661 
2662     // Record price without any tips
2663     unlockProtocol.recordKeyPurchase(inMemoryKeyPrice, getHasValidKey(_referrer) ? _referrer : address(0));
2664 
2665     // We explicitly allow for greater amounts of ETH or tokens to allow 'donations'
2666     uint pricePaid;
2667     if(tokenAddress != address(0))
2668     {
2669       pricePaid = _value;
2670       IERC20 token = IERC20(tokenAddress);
2671       token.safeTransferFrom(msg.sender, address(this), _value);
2672     }
2673     else
2674     {
2675       pricePaid = msg.value;
2676     }
2677     require(pricePaid >= inMemoryKeyPrice, 'INSUFFICIENT_VALUE');
2678 
2679     if(address(onKeyPurchaseHook) != address(0))
2680     {
2681       onKeyPurchaseHook.onKeyPurchase(msg.sender, _recipient, _referrer, _data, inMemoryKeyPrice, pricePaid);
2682     }
2683   }
2684 
2685   /**
2686    * @notice returns the minimum price paid for a purchase with these params.
2687    * @dev minKeyPrice considers any discount from Unlock or the OnKeyPurchase hook
2688    */
2689   function purchasePriceFor(
2690     address _recipient,
2691     address _referrer,
2692     bytes calldata _data
2693   ) external view
2694     returns (uint minKeyPrice)
2695   {
2696     (minKeyPrice, , ) = _purchasePriceFor(_recipient, _referrer, _data);
2697   }
2698 
2699   /**
2700    * @notice returns the minimum price paid for a purchase with these params.
2701    * @dev minKeyPrice considers any discount from Unlock or the OnKeyPurchase hook
2702    * unlockDiscount and unlockTokens are the values returned from `computeAvailableDiscountFor`
2703    */
2704   function _purchasePriceFor(
2705     address _recipient,
2706     address _referrer,
2707     bytes memory _data
2708   ) internal view
2709     returns (uint minKeyPrice, uint unlockDiscount, uint unlockTokens)
2710   {
2711     if(address(onKeyPurchaseHook) != address(0))
2712     {
2713       minKeyPrice = onKeyPurchaseHook.keyPurchasePrice(msg.sender, _recipient, _referrer, _data);
2714     }
2715     else
2716     {
2717       minKeyPrice = keyPrice;
2718     }
2719 
2720     if(minKeyPrice > 0)
2721     {
2722       (unlockDiscount, unlockTokens) = unlockProtocol.computeAvailableDiscountFor(_recipient, minKeyPrice);
2723       require(unlockDiscount <= minKeyPrice, 'INVALID_DISCOUNT_FROM_UNLOCK');
2724       minKeyPrice -= unlockDiscount;
2725     }
2726   }
2727 }
2728 
2729 // File: @openzeppelin/contracts-ethereum-package/contracts/cryptography/ECDSA.sol
2730 
2731 pragma solidity ^0.5.0;
2732 
2733 /**
2734  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2735  *
2736  * These functions can be used to verify that a message was signed by the holder
2737  * of the private keys of a given address.
2738  */
2739 library ECDSA {
2740     /**
2741      * @dev Returns the address that signed a hashed message (`hash`) with
2742      * `signature`. This address can then be used for verification purposes.
2743      *
2744      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2745      * this function rejects them by requiring the `s` value to be in the lower
2746      * half order, and the `v` value to be either 27 or 28.
2747      *
2748      * NOTE: This call _does not revert_ if the signature is invalid, or
2749      * if the signer is otherwise unable to be retrieved. In those scenarios,
2750      * the zero address is returned.
2751      *
2752      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2753      * verification to be secure: it is possible to craft signatures that
2754      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2755      * this is by receiving a hash of the original message (which may otherwise
2756      * be too long), and then calling {toEthSignedMessageHash} on it.
2757      */
2758     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2759         // Check the signature length
2760         if (signature.length != 65) {
2761             return (address(0));
2762         }
2763 
2764         // Divide the signature in r, s and v variables
2765         bytes32 r;
2766         bytes32 s;
2767         uint8 v;
2768 
2769         // ecrecover takes the signature parameters, and the only way to get them
2770         // currently is to use assembly.
2771         // solhint-disable-next-line no-inline-assembly
2772         assembly {
2773             r := mload(add(signature, 0x20))
2774             s := mload(add(signature, 0x40))
2775             v := byte(0, mload(add(signature, 0x60)))
2776         }
2777 
2778         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2779         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2780         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
2781         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2782         //
2783         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2784         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2785         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2786         // these malleable signatures as well.
2787         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2788             return address(0);
2789         }
2790 
2791         if (v != 27 && v != 28) {
2792             return address(0);
2793         }
2794 
2795         // If the signature is valid (and not malleable), return the signer address
2796         return ecrecover(hash, v, r, s);
2797     }
2798 
2799     /**
2800      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2801      * replicates the behavior of the
2802      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
2803      * JSON-RPC method.
2804      *
2805      * See {recover}.
2806      */
2807     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2808         // 32 is the length in bytes of hash,
2809         // enforced by the type signature above
2810         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2811     }
2812 }
2813 
2814 // File: contracts/mixins/MixinSignatures.sol
2815 
2816 pragma solidity 0.5.17;
2817 
2818 
2819 
2820 contract MixinSignatures
2821 {
2822   /// @notice emits anytime the nonce used for off-chain approvals changes.
2823   event NonceChanged(
2824     address indexed keyManager,
2825     uint nextAvailableNonce
2826   );
2827 
2828   // Stores a nonce per user to use for signed messages
2829   mapping(address => uint) public keyManagerToNonce;
2830 
2831   /// @notice Validates an off-chain approval signature.
2832   /// @dev If valid the nonce is consumed, else revert.
2833   modifier consumeOffchainApproval(
2834     bytes32 _hash,
2835     address _keyManager,
2836     uint8 _v,
2837     bytes32 _r,
2838     bytes32 _s
2839   )
2840   {
2841     require(
2842       ecrecover(
2843         ECDSA.toEthSignedMessageHash(_hash),
2844         _v,
2845         _r,
2846         _s
2847       ) == _keyManager, 'INVALID_SIGNATURE'
2848     );
2849     keyManagerToNonce[_keyManager]++;
2850     emit NonceChanged(_keyManager, keyManagerToNonce[_keyManager]);
2851     _;
2852   }
2853 
2854   /**
2855    * @notice Sets the minimum nonce for a valid off-chain approval message from the
2856    * senders account.
2857    * @dev This can be used to invalidate a previously signed message.
2858    */
2859   function invalidateOffchainApproval(
2860     uint _nextAvailableNonce
2861   ) external
2862   {
2863     require(_nextAvailableNonce > keyManagerToNonce[msg.sender], 'NONCE_ALREADY_USED');
2864     keyManagerToNonce[msg.sender] = _nextAvailableNonce;
2865     emit NonceChanged(msg.sender, _nextAvailableNonce);
2866   }
2867 }
2868 
2869 // File: contracts/mixins/MixinRefunds.sol
2870 
2871 pragma solidity 0.5.17;
2872 
2873 
2874 
2875 
2876 
2877 
2878 
2879 
2880 contract MixinRefunds is
2881   MixinLockManagerRole,
2882   MixinSignatures,
2883   MixinFunds,
2884   MixinLockCore,
2885   MixinKeys
2886 {
2887   using SafeMath for uint;
2888 
2889   // CancelAndRefund will return funds based on time remaining minus this penalty.
2890   // This is calculated as `proRatedRefund * refundPenaltyBasisPoints / BASIS_POINTS_DEN`.
2891   uint public refundPenaltyBasisPoints;
2892 
2893   uint public freeTrialLength;
2894 
2895   /// @notice The typehash per the EIP-712 standard
2896   /// @dev This can be computed in JS instead of read from the contract
2897   bytes32 private constant CANCEL_TYPEHASH = keccak256('cancelAndRefundFor(address _keyOwner)');
2898 
2899   event CancelKey(
2900     uint indexed tokenId,
2901     address indexed owner,
2902     address indexed sendTo,
2903     uint refund
2904   );
2905 
2906   event RefundPenaltyChanged(
2907     uint freeTrialLength,
2908     uint refundPenaltyBasisPoints
2909   );
2910 
2911   function _initializeMixinRefunds() internal
2912   {
2913     // default to 10%
2914     refundPenaltyBasisPoints = 1000;
2915   }
2916 
2917   /**
2918    * @dev Invoked by the lock owner to destroy the user's ket and perform a refund and cancellation
2919    * of the key
2920    */
2921   function expireAndRefundFor(
2922     address _keyOwner,
2923     uint amount
2924   ) external
2925     onlyLockManager
2926     hasValidKey(_keyOwner)
2927   {
2928     _cancelAndRefund(_keyOwner, amount);
2929   }
2930 
2931   /**
2932    * @dev Destroys the key and sends a refund based on the amount of time remaining.
2933    * @param _tokenId The id of the key to cancel.
2934    */
2935   function cancelAndRefund(uint _tokenId)
2936     external
2937     onlyKeyManagerOrApproved(_tokenId)
2938   {
2939     address keyOwner = ownerOf(_tokenId);
2940     uint refund = _getCancelAndRefundValue(keyOwner);
2941 
2942     _cancelAndRefund(keyOwner, refund);
2943   }
2944 
2945   /**
2946    * @dev Cancels a key managed by a different user and sends the funds to the msg.sender.
2947    * @param _keyManager the key managed by this user will be canceled
2948    * @param _v _r _s getCancelAndRefundApprovalHash signed by the _keyOwner
2949    * @param _tokenId The key to cancel
2950    */
2951   function cancelAndRefundFor(
2952     address _keyManager,
2953     uint8 _v,
2954     bytes32 _r,
2955     bytes32 _s,
2956     uint _tokenId
2957   ) external
2958     consumeOffchainApproval(
2959       getCancelAndRefundApprovalHash(_keyManager, msg.sender),
2960       _keyManager,
2961       _v,
2962       _r,
2963       _s
2964     )
2965   {
2966     address keyOwner = ownerOf(_tokenId);
2967     uint refund = _getCancelAndRefundValue(keyOwner);
2968     _cancelAndRefund(keyOwner, refund);
2969   }
2970 
2971   /**
2972    * Allow the owner to change the refund penalty.
2973    */
2974   function updateRefundPenalty(
2975     uint _freeTrialLength,
2976     uint _refundPenaltyBasisPoints
2977   ) external
2978     onlyLockManager
2979   {
2980     emit RefundPenaltyChanged(
2981       _freeTrialLength,
2982       _refundPenaltyBasisPoints
2983     );
2984 
2985     freeTrialLength = _freeTrialLength;
2986     refundPenaltyBasisPoints = _refundPenaltyBasisPoints;
2987   }
2988 
2989   /**
2990    * @dev Determines how much of a refund a key owner would receive if they issued
2991    * a cancelAndRefund block.timestamp.
2992    * Note that due to the time required to mine a tx, the actual refund amount will be lower
2993    * than what the user reads from this call.
2994    */
2995   function getCancelAndRefundValueFor(
2996     address _keyOwner
2997   )
2998     external view
2999     returns (uint refund)
3000   {
3001     return _getCancelAndRefundValue(_keyOwner);
3002   }
3003 
3004   /**
3005    * @notice returns the hash to sign in order to allow another user to cancel on your behalf.
3006    * @dev this can be computed in JS instead of read from the contract.
3007    * @param _keyManager The key manager's address (also the message signer)
3008    * @param _txSender The address cancelling cancel on behalf of the keyOwner
3009    * @return approvalHash The hash to sign
3010    */
3011   function getCancelAndRefundApprovalHash(
3012     address _keyManager,
3013     address _txSender
3014   ) public view
3015     returns (bytes32 approvalHash)
3016   {
3017     return keccak256(
3018       abi.encodePacked(
3019         // Approval is specific to this Lock
3020         address(this),
3021         // The specific function the signer is approving
3022         CANCEL_TYPEHASH,
3023         // Approval enables only one cancel call
3024         keyManagerToNonce[_keyManager],
3025         // Approval allows only one account to broadcast the tx
3026         _txSender
3027       )
3028     );
3029   }
3030 
3031   /**
3032    * @dev cancels the key for the given keyOwner and sends the refund to the msg.sender.
3033    */
3034   function _cancelAndRefund(
3035     address _keyOwner,
3036     uint refund
3037   ) internal
3038   {
3039     Key storage key = keyByOwner[_keyOwner];
3040 
3041     emit CancelKey(key.tokenId, _keyOwner, msg.sender, refund);
3042     // expirationTimestamp is a proxy for hasKey, setting this to `block.timestamp` instead
3043     // of 0 so that we can still differentiate hasKey from hasValidKey.
3044     key.expirationTimestamp = block.timestamp;
3045 
3046     if (refund > 0) {
3047       // Security: doing this last to avoid re-entrancy concerns
3048       _transfer(tokenAddress, _keyOwner, refund);
3049     }
3050 
3051     // inform the hook if there is one registered
3052     if(address(onKeyCancelHook) != address(0))
3053     {
3054       onKeyCancelHook.onKeyCancel(msg.sender, _keyOwner, refund);
3055     }
3056   }
3057 
3058   /**
3059    * @dev Determines how much of a refund a key owner would receive if they issued
3060    * a cancelAndRefund now.
3061    * @param _keyOwner The owner of the key check the refund value for.
3062    */
3063   function _getCancelAndRefundValue(
3064     address _keyOwner
3065   )
3066     private view
3067     hasValidKey(_keyOwner)
3068     returns (uint refund)
3069   {
3070     Key storage key = keyByOwner[_keyOwner];
3071     // Math: safeSub is not required since `hasValidKey` confirms timeRemaining is positive
3072     uint timeRemaining = key.expirationTimestamp - block.timestamp;
3073     if(timeRemaining + freeTrialLength >= expirationDuration) {
3074       refund = keyPrice;
3075     } else {
3076       // Math: using safeMul in case keyPrice or timeRemaining is very large
3077       refund = keyPrice.mul(timeRemaining) / expirationDuration;
3078     }
3079 
3080     // Apply the penalty if this is not a free trial
3081     if(freeTrialLength == 0 || timeRemaining + freeTrialLength < expirationDuration)
3082     {
3083       uint penalty = keyPrice.mul(refundPenaltyBasisPoints) / BASIS_POINTS_DEN;
3084       if (refund > penalty) {
3085         // Math: safeSub is not required since the if confirms this won't underflow
3086         refund -= penalty;
3087       } else {
3088         refund = 0;
3089       }
3090     }
3091   }
3092 }
3093 
3094 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Receiver.sol
3095 
3096 pragma solidity ^0.5.0;
3097 
3098 /**
3099  * @title ERC721 token receiver interface
3100  * @dev Interface for any contract that wants to support safeTransfers
3101  * from ERC721 asset contracts.
3102  */
3103 contract IERC721Receiver {
3104     /**
3105      * @notice Handle the receipt of an NFT
3106      * @dev The ERC721 smart contract calls this function on the recipient
3107      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
3108      * otherwise the caller will revert the transaction. The selector to be
3109      * returned can be obtained as `this.onERC721Received.selector`. This
3110      * function MAY throw to revert and reject the transfer.
3111      * Note: the ERC721 contract address is always the message sender.
3112      * @param operator The address which called `safeTransferFrom` function
3113      * @param from The address which previously owned the token
3114      * @param tokenId The NFT identifier which is being transferred
3115      * @param data Additional data with no specified format
3116      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
3117      */
3118     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
3119     public returns (bytes4);
3120 }
3121 
3122 // File: contracts/mixins/MixinTransfer.sol
3123 
3124 pragma solidity 0.5.17;
3125 
3126 
3127 
3128 
3129 
3130 
3131 
3132 
3133 
3134 /**
3135  * @title Mixin for the transfer-related functions needed to meet the ERC721
3136  * standard.
3137  * @author Nick Furfaro
3138  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
3139  * separates logically groupings of code to ease readability.
3140  */
3141 
3142 contract MixinTransfer is
3143   MixinLockManagerRole,
3144   MixinFunds,
3145   MixinLockCore,
3146   MixinKeys
3147 {
3148   using SafeMath for uint;
3149   using Address for address;
3150 
3151   event TransferFeeChanged(
3152     uint transferFeeBasisPoints
3153   );
3154 
3155   // 0x150b7a02 == bytes4(keccak256('onERC721Received(address,address,uint256,bytes)'))
3156   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
3157 
3158   // The fee relative to keyPrice to charge when transfering a Key to another account
3159   // (potentially on a 0x marketplace).
3160   // This is calculated as `keyPrice * transferFeeBasisPoints / BASIS_POINTS_DEN`.
3161   uint public transferFeeBasisPoints;
3162 
3163   /**
3164   * @notice Allows the key owner to safely share their key (parent key) by
3165   * transferring a portion of the remaining time to a new key (child key).
3166   * @param _to The recipient of the shared key
3167   * @param _tokenId the key to share
3168   * @param _timeShared The amount of time shared
3169   */
3170   function shareKey(
3171     address _to,
3172     uint _tokenId,
3173     uint _timeShared
3174   ) public
3175     onlyIfAlive
3176     onlyKeyManagerOrApproved(_tokenId)
3177   {
3178     require(transferFeeBasisPoints < BASIS_POINTS_DEN, 'KEY_TRANSFERS_DISABLED');
3179     require(_to != address(0), 'INVALID_ADDRESS');
3180     address keyOwner = _ownerOf[_tokenId];
3181     require(getHasValidKey(keyOwner), 'KEY_NOT_VALID');
3182     Key storage fromKey = keyByOwner[keyOwner];
3183     Key storage toKey = keyByOwner[_to];
3184     uint idTo = toKey.tokenId;
3185     uint time;
3186     // get the remaining time for the origin key
3187     uint timeRemaining = fromKey.expirationTimestamp - block.timestamp;
3188     // get the transfer fee based on amount of time wanted share
3189     uint fee = getTransferFee(keyOwner, _timeShared);
3190     uint timePlusFee = _timeShared.add(fee);
3191 
3192     // ensure that we don't try to share too much
3193     if(timePlusFee < timeRemaining) {
3194       // now we can safely set the time
3195       time = _timeShared;
3196       // deduct time from parent key, including transfer fee
3197       _timeMachine(_tokenId, timePlusFee, false);
3198     } else {
3199       // we have to recalculate the fee here
3200       fee = getTransferFee(keyOwner, timeRemaining);
3201       time = timeRemaining - fee;
3202       fromKey.expirationTimestamp = block.timestamp; // Effectively expiring the key
3203       emit ExpireKey(_tokenId);
3204     }
3205 
3206     if (idTo == 0) {
3207       _assignNewTokenId(toKey);
3208       idTo = toKey.tokenId;
3209       _recordOwner(_to, idTo);
3210       emit Transfer(
3211         address(0), // This is a creation or time-sharing
3212         _to,
3213         idTo
3214       );
3215     } else if (toKey.expirationTimestamp <= block.timestamp) {
3216       // reset the key Manager for expired keys
3217       _setKeyManagerOf(idTo, address(0));
3218     }
3219 
3220     // add time to new key
3221     _timeMachine(idTo, time, true);
3222     // trigger event
3223     emit Transfer(
3224       keyOwner,
3225       _to,
3226       idTo
3227     );
3228 
3229     require(_checkOnERC721Received(keyOwner, _to, _tokenId, ''), 'NON_COMPLIANT_ERC721_RECEIVER');
3230   }
3231 
3232   function transferFrom(
3233     address _from,
3234     address _recipient,
3235     uint _tokenId
3236   )
3237     public
3238     onlyIfAlive
3239     hasValidKey(_from)
3240     onlyKeyManagerOrApproved(_tokenId)
3241   {
3242     require(isKeyOwner(_tokenId, _from), 'TRANSFER_FROM: NOT_KEY_OWNER');
3243     require(transferFeeBasisPoints < BASIS_POINTS_DEN, 'KEY_TRANSFERS_DISABLED');
3244     require(_recipient != address(0), 'INVALID_ADDRESS');
3245     uint fee = getTransferFee(_from, 0);
3246 
3247     Key storage fromKey = keyByOwner[_from];
3248     Key storage toKey = keyByOwner[_recipient];
3249 
3250     uint previousExpiration = toKey.expirationTimestamp;
3251     // subtract the fee from the senders key before the transfer
3252     _timeMachine(_tokenId, fee, false);
3253 
3254     if (toKey.tokenId == 0) {
3255       toKey.tokenId = _tokenId;
3256       _recordOwner(_recipient, _tokenId);
3257       // Clear any previous approvals
3258       _clearApproval(_tokenId);
3259     }
3260 
3261     if (previousExpiration <= block.timestamp) {
3262       // The recipient did not have a key, or had a key but it expired. The new expiration is the sender's key expiration
3263       // An expired key is no longer a valid key, so the new tokenID is the sender's tokenID
3264       toKey.expirationTimestamp = fromKey.expirationTimestamp;
3265       toKey.tokenId = _tokenId;
3266 
3267       // Reset the key Manager to the key owner
3268       _setKeyManagerOf(_tokenId, address(0));
3269 
3270       _recordOwner(_recipient, _tokenId);
3271     } else {
3272       // The recipient has a non expired key. We just add them the corresponding remaining time
3273       // SafeSub is not required since the if confirms `previousExpiration - block.timestamp` cannot underflow
3274       toKey.expirationTimestamp = fromKey
3275         .expirationTimestamp.add(previousExpiration - block.timestamp);
3276     }
3277 
3278     // Effectively expiring the key for the previous owner
3279     fromKey.expirationTimestamp = block.timestamp;
3280 
3281     // Set the tokenID to 0 for the previous owner to avoid duplicates
3282     fromKey.tokenId = 0;
3283 
3284     // trigger event
3285     emit Transfer(
3286       _from,
3287       _recipient,
3288       _tokenId
3289     );
3290   }
3291 
3292   /**
3293   * @notice Transfers the ownership of an NFT from one address to another address
3294   * @dev This works identically to the other function with an extra data parameter,
3295   *  except this function just sets data to ''
3296   * @param _from The current owner of the NFT
3297   * @param _to The new owner
3298   * @param _tokenId The NFT to transfer
3299   */
3300   function safeTransferFrom(
3301     address _from,
3302     address _to,
3303     uint _tokenId
3304   )
3305     public
3306   {
3307     safeTransferFrom(_from, _to, _tokenId, '');
3308   }
3309 
3310   /**
3311   * @notice Transfers the ownership of an NFT from one address to another address.
3312   * When transfer is complete, this functions
3313   *  checks if `_to` is a smart contract (code size > 0). If so, it calls
3314   *  `onERC721Received` on `_to` and throws if the return value is not
3315   *  `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
3316   * @param _from The current owner of the NFT
3317   * @param _to The new owner
3318   * @param _tokenId The NFT to transfer
3319   * @param _data Additional data with no specified format, sent in call to `_to`
3320   */
3321   function safeTransferFrom(
3322     address _from,
3323     address _to,
3324     uint _tokenId,
3325     bytes memory _data
3326   )
3327     public
3328   {
3329     transferFrom(_from, _to, _tokenId);
3330     require(_checkOnERC721Received(_from, _to, _tokenId, _data), 'NON_COMPLIANT_ERC721_RECEIVER');
3331 
3332   }
3333 
3334   /**
3335    * Allow the Lock owner to change the transfer fee.
3336    */
3337   function updateTransferFee(
3338     uint _transferFeeBasisPoints
3339   )
3340     external
3341     onlyLockManager
3342   {
3343     emit TransferFeeChanged(
3344       _transferFeeBasisPoints
3345     );
3346     transferFeeBasisPoints = _transferFeeBasisPoints;
3347   }
3348 
3349   /**
3350    * Determines how much of a fee a key owner would need to pay in order to
3351    * transfer the key to another account.  This is pro-rated so the fee goes down
3352    * overtime.
3353    * @param _keyOwner The owner of the key check the transfer fee for.
3354    */
3355   function getTransferFee(
3356     address _keyOwner,
3357     uint _time
3358   )
3359     public view
3360     hasValidKey(_keyOwner)
3361     returns (uint)
3362   {
3363     Key storage key = keyByOwner[_keyOwner];
3364     uint timeToTransfer;
3365     uint fee;
3366     // Math: safeSub is not required since `hasValidKey` confirms timeToTransfer is positive
3367     // this is for standard key transfers
3368     if(_time == 0) {
3369       timeToTransfer = key.expirationTimestamp - block.timestamp;
3370     } else {
3371       timeToTransfer = _time;
3372     }
3373     fee = timeToTransfer.mul(transferFeeBasisPoints) / BASIS_POINTS_DEN;
3374     return fee;
3375   }
3376 
3377   /**
3378    * @dev Internal function to invoke `onERC721Received` on a target address
3379    * The call is not executed if the target address is not a contract
3380    * @param from address representing the previous owner of the given token ID
3381    * @param to target address that will receive the tokens
3382    * @param tokenId uint256 ID of the token to be transferred
3383    * @param _data bytes optional data to send along with the call
3384    * @return whether the call correctly returned the expected magic value
3385    */
3386   function _checkOnERC721Received(
3387     address from,
3388     address to,
3389     uint256 tokenId,
3390     bytes memory _data
3391   )
3392     internal
3393     returns (bool)
3394   {
3395     if (!to.isContract()) {
3396       return true;
3397     }
3398     bytes4 retval = IERC721Receiver(to).onERC721Received(
3399       msg.sender, from, tokenId, _data);
3400     return (retval == _ERC721_RECEIVED);
3401   }
3402 
3403 }
3404 
3405 // File: contracts/PublicLock.sol
3406 
3407 pragma solidity 0.5.17;
3408 
3409 
3410 
3411 
3412 
3413 
3414 
3415 
3416 
3417 
3418 
3419 
3420 
3421 
3422 
3423 
3424 
3425 
3426 /**
3427  * @title The Lock contract
3428  * @author Julien Genestoux (unlock-protocol.com)
3429  * @dev ERC165 allows our contract to be queried to determine whether it implements a given interface.
3430  * Every ERC-721 compliant contract must implement the ERC165 interface.
3431  * https://eips.ethereum.org/EIPS/eip-721
3432  */
3433 contract PublicLock is
3434   IPublicLock,
3435   Initializable,
3436   ERC165,
3437   MixinLockManagerRole,
3438   MixinKeyGranterRole,
3439   MixinSignatures,
3440   MixinFunds,
3441   MixinDisable,
3442   MixinLockCore,
3443   MixinKeys,
3444   MixinLockMetadata,
3445   MixinERC721Enumerable,
3446   MixinGrantKeys,
3447   MixinPurchase,
3448   MixinTransfer,
3449   MixinRefunds
3450 {
3451   function initialize(
3452     address _lockCreator,
3453     uint _expirationDuration,
3454     address _tokenAddress,
3455     uint _keyPrice,
3456     uint _maxNumberOfKeys,
3457     string memory _lockName
3458   ) public
3459     initializer()
3460   {
3461     MixinFunds._initializeMixinFunds(_tokenAddress);
3462     MixinDisable._initializeMixinDisable();
3463     MixinLockCore._initializeMixinLockCore(_lockCreator, _expirationDuration, _keyPrice, _maxNumberOfKeys);
3464     MixinLockMetadata._initializeMixinLockMetadata(_lockName);
3465     MixinERC721Enumerable._initializeMixinERC721Enumerable();
3466     MixinRefunds._initializeMixinRefunds();
3467     MixinLockManagerRole._initializeMixinLockManagerRole(_lockCreator);
3468     MixinKeyGranterRole._initializeMixinKeyGranterRole(_lockCreator);
3469     // registering the interface for erc721 with ERC165.sol using
3470     // the ID specified in the standard: https://eips.ethereum.org/EIPS/eip-721
3471     _registerInterface(0x80ac58cd);
3472   }
3473 
3474   /**
3475    * @notice Allow the contract to accept tips in ETH sent directly to the contract.
3476    * @dev This is okay to use even if the lock is priced in ERC-20 tokens
3477    */
3478   function() external payable {}
3479 }