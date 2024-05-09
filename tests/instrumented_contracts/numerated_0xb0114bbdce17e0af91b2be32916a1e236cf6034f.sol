1 // File: contracts/interfaces/IERC721.sol
2 
3 pragma solidity 0.5.9;
4 
5 /// @title ERC-721 Non-Fungible Token Standard
6 /// @dev See https://eips.ethereum.org/EIPS/eip-721
7 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
8 
9 interface IERC721 {
10 
11 
12   /// @dev This emits when ownership of any NFT changes by any mechanism.
13   ///  This event emits when NFTs are created (`from` == 0) and destroyed
14   ///  (`to` == 0). Exception: during contract creation, any number of NFTs
15   ///  may be created and assigned without emitting Transfer. At the time of
16   ///  any transfer, the approved address for that NFT (if any) is reset to none.
17   event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);
18 
19   /// @dev This emits when the approved address for an NFT is changed or
20   ///  reaffirmed. The zero address indicates there is no approved address.
21   ///  When a Transfer event emits, this also indicates that the approved
22   ///  address for that NFT (if any) is reset to none.
23   event Approval(address indexed _owner, address indexed _approved, uint indexed _tokenId);
24 
25   /// @dev This emits when an operator is enabled or disabled for an owner.
26   ///  The operator can manage all NFTs of the owner.
27   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
28 
29   /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
30   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
31   ///  THEY MAY BE PERMANENTLY LOST
32   /// @dev Throws unless `msg.sender` is the current owner, an authorized
33   ///  operator, or the approved address for this NFT. Throws if `_from` is
34   ///  not the current owner. Throws if `_to` is the zero address. Throws if
35   ///  `_tokenId` is not a valid NFT.
36   /// @param _from The current owner of the NFT
37   /// @param _to The new owner
38   /// @param _tokenId The NFT to transfer
39   function transferFrom(address _from, address _to, uint _tokenId) external payable;
40 
41   /// @notice Set or reaffirm the approved address for an NFT
42   /// @dev The zero address indicates there is no approved address.
43   /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
44   ///  operator of the current owner.
45   /// @param _approved The new approved NFT controller
46   /// @param _tokenId The NFT to approve
47   function approve(address _approved, uint _tokenId) external payable;
48 
49   /// @notice Transfers the ownership of an NFT from one address to another address
50   /// @dev Throws unless `msg.sender` is the current owner, an authorized
51   ///  operator, or the approved address for this NFT. Throws if `_from` is
52   ///  not the current owner. Throws if `_to` is the zero address. Throws if
53   ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
54   ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
55   ///  `onERC721Received` on `_to` and throws if the return value is not
56   ///  `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
57   /// @param _from The current owner of the NFT
58   /// @param _to The new owner
59   /// @param _tokenId The NFT to transfer
60   /// @param data Additional data with no specified format, sent in call to `_to`
61   function safeTransferFrom(address _from, address _to, uint _tokenId, bytes calldata data) external payable;
62 
63   /// @notice Transfers the ownership of an NFT from one address to another address
64   /// @dev This works identically to the other function with an extra data parameter,
65   ///  except this function just sets data to ''
66   /// @param _from The current owner of the NFT
67   /// @param _to The new owner
68   /// @param _tokenId The NFT to transfer
69   function safeTransferFrom(address _from, address _to, uint _tokenId) external payable;
70 
71   /// @notice Enable or disable approval for a third party ('operator') to manage
72   ///  all of `msg.sender`'s assets.
73   /// @dev Emits the ApprovalForAll event. The contract MUST allow
74   ///  multiple operators per owner.
75   /// @param _operator Address to add to the set of authorized operators.
76   /// @param _approved True if the operator is approved, false to revoke approval
77   function setApprovalForAll(address _operator, bool _approved) external;
78 
79   /// @notice Count all NFTs assigned to an owner
80   /// @dev NFTs assigned to the zero address are considered invalid, and this
81   ///  function throws for queries about the zero address.
82   /// @param _owner An address for whom to query the balance
83   /// @return The number of NFTs owned by `_owner`, possibly zero
84   function balanceOf(address _owner) external view returns (uint);
85 
86   /// @notice Find the owner of an NFT
87   /// @dev NFTs assigned to zero address are considered invalid, and queries
88   ///  about them do throw.
89   /// @param _tokenId The identifier for an NFT
90   /// @return The address of the owner of the NFT
91   function ownerOf(uint _tokenId) external view returns (address);
92 
93   /// @notice Get the approved address for a single NFT
94   /// @dev Throws if `_tokenId` is not a valid NFT
95   /// @param _tokenId The NFT to find the approved address for
96   /// @return The approved address for this NFT, or the zero address if there is none
97   function getApproved(uint _tokenId) external view returns (address);
98 
99   /// @notice Query if an address is an authorized operator for another address
100   /// @param _owner The address that owns the NFTs
101   /// @param _operator The address that acts on behalf of the owner
102   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
103   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
104 
105   /// @notice A descriptive name for a collection of NFTs in this contract
106   function name() external view returns (string memory _name);
107 }
108 
109 // File: zos-lib/contracts/Initializable.sol
110 
111 pragma solidity >=0.4.24 <0.6.0;
112 
113 
114 /**
115  * @title Initializable
116  *
117  * @dev Helper contract to support initializer functions. To use it, replace
118  * the constructor with a function that has the `initializer` modifier.
119  * WARNING: Unlike constructors, initializer functions must be manually
120  * invoked. This applies both to deploying an Initializable contract, as well
121  * as extending an Initializable contract via inheritance.
122  * WARNING: When used with inheritance, manual care must be taken to not invoke
123  * a parent initializer twice, or ensure that all initializers are idempotent,
124  * because this is not dealt with automatically as with constructors.
125  */
126 contract Initializable {
127 
128   /**
129    * @dev Indicates that the contract has been initialized.
130    */
131   bool private initialized;
132 
133   /**
134    * @dev Indicates that the contract is in the process of being initialized.
135    */
136   bool private initializing;
137 
138   /**
139    * @dev Modifier to use in the initializer function of a contract.
140    */
141   modifier initializer() {
142     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
143 
144     bool isTopLevelCall = !initializing;
145     if (isTopLevelCall) {
146       initializing = true;
147       initialized = true;
148     }
149 
150     _;
151 
152     if (isTopLevelCall) {
153       initializing = false;
154     }
155   }
156 
157   /// @dev Returns true if and only if the function is running in the constructor
158   function isConstructor() private view returns (bool) {
159     // extcodesize checks the size of the code stored in an address, and
160     // address returns the current address. Since the code is still not
161     // deployed when running a constructor, any checks on its code size will
162     // yield zero, making it an effective way to detect if a contract is
163     // under construction or not.
164     uint256 cs;
165     assembly { cs := extcodesize(address) }
166     return cs == 0;
167   }
168 
169   // Reserved storage space to allow for layout changes in the future.
170   uint256[50] private ______gap;
171 }
172 
173 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
174 
175 pragma solidity ^0.5.0;
176 
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable is Initializable {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190      * account.
191      */
192     function initialize(address sender) public initializer {
193         _owner = sender;
194         emit OwnershipTransferred(address(0), _owner);
195     }
196 
197     /**
198      * @return the address of the owner.
199      */
200     function owner() public view returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(isOwner());
209         _;
210     }
211 
212     /**
213      * @return true if `msg.sender` is the owner of the contract.
214      */
215     function isOwner() public view returns (bool) {
216         return msg.sender == _owner;
217     }
218 
219     /**
220      * @dev Allows the current owner to relinquish control of the contract.
221      * @notice Renouncing to ownership will leave the contract without an owner.
222      * It will not be possible to call the functions with the `onlyOwner`
223      * modifier anymore.
224      */
225     function renounceOwnership() public onlyOwner {
226         emit OwnershipTransferred(_owner, address(0));
227         _owner = address(0);
228     }
229 
230     /**
231      * @dev Allows the current owner to transfer control of the contract to a newOwner.
232      * @param newOwner The address to transfer ownership to.
233      */
234     function transferOwnership(address newOwner) public onlyOwner {
235         _transferOwnership(newOwner);
236     }
237 
238     /**
239      * @dev Transfers control of the contract to a newOwner.
240      * @param newOwner The address to transfer ownership to.
241      */
242     function _transferOwnership(address newOwner) internal {
243         require(newOwner != address(0));
244         emit OwnershipTransferred(_owner, newOwner);
245         _owner = newOwner;
246     }
247 
248     uint256[50] private ______gap;
249 }
250 
251 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
252 
253 pragma solidity ^0.5.0;
254 
255 /**
256  * @dev Interface of the ERC165 standard, as defined in the
257  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
258  *
259  * Implementers can declare support of contract interfaces, which can then be
260  * queried by others (`ERC165Checker`).
261  *
262  * For an implementation, see `ERC165`.
263  */
264 interface IERC165 {
265     /**
266      * @dev Returns true if this contract implements the interface defined by
267      * `interfaceId`. See the corresponding
268      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
269      * to learn more about how these ids are created.
270      *
271      * This function call must use less than 30 000 gas.
272      */
273     function supportsInterface(bytes4 interfaceId) external view returns (bool);
274 }
275 
276 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
277 
278 pragma solidity ^0.5.0;
279 
280 
281 /**
282  * @dev Implementation of the `IERC165` interface.
283  *
284  * Contracts may inherit from this and call `_registerInterface` to declare
285  * their support of an interface.
286  */
287 contract ERC165 is IERC165 {
288     /*
289      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
290      */
291     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
292 
293     /**
294      * @dev Mapping of interface ids to whether or not it's supported.
295      */
296     mapping(bytes4 => bool) private _supportedInterfaces;
297 
298     constructor () internal {
299         // Derived contracts need only register support for their own interfaces,
300         // we register support for ERC165 itself here
301         _registerInterface(_INTERFACE_ID_ERC165);
302     }
303 
304     /**
305      * @dev See `IERC165.supportsInterface`.
306      *
307      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
308      */
309     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
310         return _supportedInterfaces[interfaceId];
311     }
312 
313     /**
314      * @dev Registers the contract as an implementer of the interface defined by
315      * `interfaceId`. Support of the actual ERC165 interface is automatic and
316      * registering its interface id is not required.
317      *
318      * See `IERC165.supportsInterface`.
319      *
320      * Requirements:
321      *
322      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
323      */
324     function _registerInterface(bytes4 interfaceId) internal {
325         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
326         _supportedInterfaces[interfaceId] = true;
327     }
328 }
329 
330 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
331 
332 pragma solidity ^0.5.0;
333 
334 /**
335  * @title ERC721 token receiver interface
336  * @dev Interface for any contract that wants to support safeTransfers
337  * from ERC721 asset contracts.
338  */
339 contract IERC721Receiver {
340     /**
341      * @notice Handle the receipt of an NFT
342      * @dev The ERC721 smart contract calls this function on the recipient
343      * after a `safeTransfer`. This function MUST return the function selector,
344      * otherwise the caller will revert the transaction. The selector to be
345      * returned can be obtained as `this.onERC721Received.selector`. This
346      * function MAY throw to revert and reject the transfer.
347      * Note: the ERC721 contract address is always the message sender.
348      * @param operator The address which called `safeTransferFrom` function
349      * @param from The address which previously owned the token
350      * @param tokenId The NFT identifier which is being transferred
351      * @param data Additional data with no specified format
352      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
353      */
354     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
355     public returns (bytes4);
356 }
357 
358 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Holder.sol
359 
360 pragma solidity ^0.5.0;
361 
362 
363 contract ERC721Holder is IERC721Receiver {
364     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
365         return this.onERC721Received.selector;
366     }
367 }
368 
369 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
370 
371 pragma solidity ^0.5.0;
372 
373 /**
374  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
375  * the optional functions; to access them see `ERC20Detailed`.
376  */
377 interface IERC20 {
378     /**
379      * @dev Returns the amount of tokens in existence.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     /**
384      * @dev Returns the amount of tokens owned by `account`.
385      */
386     function balanceOf(address account) external view returns (uint256);
387 
388     /**
389      * @dev Moves `amount` tokens from the caller's account to `recipient`.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a `Transfer` event.
394      */
395     function transfer(address recipient, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Returns the remaining number of tokens that `spender` will be
399      * allowed to spend on behalf of `owner` through `transferFrom`. This is
400      * zero by default.
401      *
402      * This value changes when `approve` or `transferFrom` are called.
403      */
404     function allowance(address owner, address spender) external view returns (uint256);
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * > Beware that changing an allowance with this method brings the risk
412      * that someone may use both the old and the new allowance by unfortunate
413      * transaction ordering. One possible solution to mitigate this race
414      * condition is to first reduce the spender's allowance to 0 and set the
415      * desired value afterwards:
416      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
417      *
418      * Emits an `Approval` event.
419      */
420     function approve(address spender, uint256 amount) external returns (bool);
421 
422     /**
423      * @dev Moves `amount` tokens from `sender` to `recipient` using the
424      * allowance mechanism. `amount` is then deducted from the caller's
425      * allowance.
426      *
427      * Returns a boolean value indicating whether the operation succeeded.
428      *
429      * Emits a `Transfer` event.
430      */
431     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Emitted when `value` tokens are moved from one account (`from`) to
435      * another (`to`).
436      *
437      * Note that `value` may be zero.
438      */
439     event Transfer(address indexed from, address indexed to, uint256 value);
440 
441     /**
442      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
443      * a call to `approve`. `value` is the new allowance.
444      */
445     event Approval(address indexed owner, address indexed spender, uint256 value);
446 }
447 
448 // File: contracts/mixins/MixinFunds.sol
449 
450 pragma solidity 0.5.9;
451 
452 
453 
454 /**
455  * @title An implementation of the money related functions.
456  * @author HardlyDifficult (unlock-protocol.com)
457  */
458 contract MixinFunds
459 {
460   /**
461    * The token-type that this Lock is priced in.  If 0, then use ETH, else this is
462    * a ERC20 token address.
463    */
464   address public tokenAddress;
465 
466   constructor(
467     address _tokenAddress
468   ) public
469   {
470     require(
471       _tokenAddress == address(0) || IERC20(_tokenAddress).totalSupply() > 0,
472       'INVALID_TOKEN'
473     );
474     tokenAddress = _tokenAddress;
475   }
476 
477   /**
478    * Gets the current balance of the account provided.
479    */
480   function getBalance(
481     address _account
482   ) public view
483     returns (uint)
484   {
485     if(tokenAddress == address(0)) {
486       return _account.balance;
487     } else {
488       return IERC20(tokenAddress).balanceOf(_account);
489     }
490   }
491 
492   /**
493    * Ensures that the msg.sender has paid at least the price stated.
494    *
495    * With ETH, this means the function originally called was `payable` and the
496    * transaction included at least the amount requested.
497    *
498    * Security: be wary of re-entrancy when calling this function.
499    */
500   function _chargeAtLeast(
501     uint _price
502   ) internal
503   {
504     if(_price > 0) {
505       if(tokenAddress == address(0)) {
506         require(msg.value >= _price, 'NOT_ENOUGH_FUNDS');
507       } else {
508         IERC20 token = IERC20(tokenAddress);
509         uint balanceBefore = token.balanceOf(address(this));
510         token.transferFrom(msg.sender, address(this), _price);
511 
512         // There are known bugs in popular ERC20 implements which means we cannot
513         // trust the return value of `transferFrom`.  This require statement ensures
514         // that a transfer occurred.
515         require(token.balanceOf(address(this)) > balanceBefore, 'TRANSFER_FAILED');
516       }
517     }
518   }
519 
520   /**
521    * Transfers funds from the contract to the account provided.
522    *
523    * Security: be wary of re-entrancy when calling this function.
524    */
525   function _transfer(
526     address _to,
527     uint _amount
528   ) internal
529   {
530     if(_amount > 0) {
531       if(tokenAddress == address(0)) {
532         address(uint160(_to)).transfer(_amount);
533       } else {
534         IERC20 token = IERC20(tokenAddress);
535         uint balanceBefore = token.balanceOf(_to);
536         token.transfer(_to, _amount);
537 
538         // There are known bugs in popular ERC20 implements which means we cannot
539         // trust the return value of `transferFrom`.  This require statement ensures
540         // that a transfer occurred.
541         require(token.balanceOf(_to) > balanceBefore, 'TRANSFER_FAILED');
542       }
543     }
544   }
545 }
546 
547 // File: contracts/mixins/MixinDisableAndDestroy.sol
548 
549 pragma solidity 0.5.9;
550 
551 
552 
553 
554 /**
555  * @title Mixin allowing the Lock owner to disable a Lock (preventing new purchases)
556  * and then destroy it.
557  * @author HardlyDifficult
558  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
559  * separates logically groupings of code to ease readability.
560  */
561 contract MixinDisableAndDestroy is
562   IERC721,
563   Ownable,
564   MixinFunds
565 {
566   // Used to disable payable functions when deprecating an old lock
567   bool public isAlive;
568 
569   event Destroy(
570     uint balance,
571     address indexed owner
572   );
573 
574   event Disable();
575 
576   constructor(
577   ) internal
578   {
579     isAlive = true;
580   }
581 
582   // Only allow usage when contract is Alive
583   modifier onlyIfAlive() {
584     require(isAlive, 'LOCK_DEPRECATED');
585     _;
586   }
587 
588   /**
589   * @dev Used to disable lock before migrating keys and/or destroying contract
590    */
591   function disableLock()
592     external
593     onlyOwner
594     onlyIfAlive
595   {
596     emit Disable();
597     isAlive = false;
598   }
599 
600   /**
601   * @dev Used to clean up old lock contracts from the blockchain
602   * TODO: add a check to ensure all keys are INVALID!
603    */
604   function destroyLock()
605     external
606     onlyOwner
607   {
608     require(isAlive == false, 'DISABLE_FIRST');
609 
610     emit Destroy(address(this).balance, msg.sender);
611 
612     // this will send any ETH or ERC20 held by the lock to the owner
613     _transfer(msg.sender, getBalance(address(this)));
614     selfdestruct(msg.sender);
615 
616     // Note we don't clean up the `locks` data in Unlock.sol as it should not be necessary
617     // and leaves some data behind ('Unlock.LockBalances') which may be helpful.
618   }
619 
620 }
621 
622 // File: contracts/interfaces/IUnlock.sol
623 
624 pragma solidity 0.5.9;
625 
626 
627 /**
628  * @title The Unlock Interface
629  * @author Nick Furfaro (unlock-protocol.com)
630 **/
631 
632 interface IUnlock {
633 
634 
635   // Events
636   event NewLock(
637     address indexed lockOwner,
638     address indexed newLockAddress
639   );
640 
641   event NewTokenURI(
642     string tokenURI
643   );
644 
645   event NewGlobalTokenSymbol(
646     string tokenSymbol
647   );
648 
649   // Use initialize instead of a constructor to support proxies (for upgradeability via zos).
650   function initialize(address _owner) external;
651 
652   /**
653   * @dev Create lock
654   * This deploys a lock for a creator. It also keeps track of the deployed lock.
655   * @param _tokenAddress set to the ERC20 token address, or 0 for ETH.
656   */
657   function createLock(
658     uint _expirationDuration,
659     address _tokenAddress,
660     uint _keyPrice,
661     uint _maxNumberOfKeys,
662     string calldata _lockName
663   ) external;
664 
665     /**
666    * This function keeps track of the added GDP, as well as grants of discount tokens
667    * to the referrer, if applicable.
668    * The number of discount tokens granted is based on the value of the referal,
669    * the current growth rate and the lock's discount token distribution rate
670    * This function is invoked by a previously deployed lock only.
671    */
672   function recordKeyPurchase(
673     uint _value,
674     address _referrer // solhint-disable-line no-unused-vars
675   )
676     external;
677 
678     /**
679    * This function will keep track of consumed discounts by a given user.
680    * It will also grant discount tokens to the creator who is granting the discount based on the
681    * amount of discount and compensation rate.
682    * This function is invoked by a previously deployed lock only.
683    */
684   function recordConsumedDiscount(
685     uint _discount,
686     uint _tokens // solhint-disable-line no-unused-vars
687   )
688     external;
689 
690     /**
691    * This function returns the discount available for a user, when purchasing a
692    * a key from a lock.
693    * This does not modify the state. It returns both the discount and the number of tokens
694    * consumed to grant that discount.
695    */
696   function computeAvailableDiscountFor(
697     address _purchaser, // solhint-disable-line no-unused-vars
698     uint _keyPrice // solhint-disable-line no-unused-vars
699   )
700     external
701     view
702     returns (uint discount, uint tokens);
703 
704   // Function to read the globalTokenURI field.
705   function getGlobalBaseTokenURI()
706     external
707     view
708     returns (string memory);
709 
710   /** Function to set the globalTokenURI field.
711    *  Should throw if called by other than owner
712    */
713   function setGlobalBaseTokenURI(
714     string calldata _URI
715   )
716     external;
717 
718   // Function to read the globalTokenSymbol field.
719   function getGlobalTokenSymbol()
720     external
721     view
722     returns (string memory);
723 
724   /** Function to set the globalTokenSymbol field.
725    *  Should throw if called by other than owner.
726    */
727   function setGlobalTokenSymbol(
728     string calldata _symbol
729   )
730     external;
731 
732 }
733 
734 // File: contracts/mixins/MixinLockCore.sol
735 
736 pragma solidity 0.5.9;
737 
738 
739 
740 
741 
742 
743 /**
744  * @title Mixin for core lock data and functions.
745  * @author HardlyDifficult
746  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
747  * separates logically groupings of code to ease readability.
748  */
749 contract MixinLockCore is
750   Ownable,
751   MixinFunds,
752   MixinDisableAndDestroy
753 {
754   event PriceChanged(
755     uint oldKeyPrice,
756     uint keyPrice
757   );
758 
759   event Withdrawal(
760     address indexed sender,
761     address indexed beneficiary,
762     uint amount
763   );
764 
765   // Unlock Protocol address
766   // TODO: should we make that private/internal?
767   IUnlock public unlockProtocol;
768 
769   // Duration in seconds for which the keys are valid, after creation
770   // should we take a smaller type use less gas?
771   // TODO: add support for a timestamp instead of duration
772   uint public expirationDuration;
773 
774   // price in wei of the next key
775   // TODO: allow support for a keyPriceCalculator which could set prices dynamically
776   uint public keyPrice;
777 
778   // Max number of keys sold if the keyReleaseMechanism is public
779   uint public maxNumberOfKeys;
780 
781   // A count of how many new key purchases there have been
782   uint public numberOfKeysSold;
783 
784   // The account which will receive funds on withdrawal
785   address public beneficiary;
786 
787   // Ensure that the Lock has not sold all of its keys.
788   modifier notSoldOut() {
789     require(maxNumberOfKeys > numberOfKeysSold, 'LOCK_SOLD_OUT');
790     _;
791   }
792 
793   modifier onlyOwnerOrBeneficiary()
794   {
795     require(
796       msg.sender == owner() || msg.sender == beneficiary,
797       'ONLY_LOCK_OWNER_OR_BENEFICIARY'
798     );
799     _;
800   }
801 
802   constructor(
803     address _beneficiary,
804     uint _expirationDuration,
805     uint _keyPrice,
806     uint _maxNumberOfKeys
807   ) internal
808   {
809     require(_expirationDuration <= 100 * 365 * 24 * 60 * 60, 'MAX_EXPIRATION_100_YEARS');
810     unlockProtocol = IUnlock(msg.sender); // Make sure we link back to Unlock's smart contract.
811     beneficiary = _beneficiary;
812     expirationDuration = _expirationDuration;
813     keyPrice = _keyPrice;
814     maxNumberOfKeys = _maxNumberOfKeys;
815   }
816 
817   /**
818    * @dev Called by owner to withdraw all funds from the lock and send them to the `beneficiary`.
819    * @param _amount specifies the max amount to withdraw, which may be reduced when
820    * considering the available balance. Set to 0 or MAX_UINT to withdraw everything.
821    *
822    * TODO: consider allowing anybody to trigger this as long as it goes to owner anyway?
823    *  -- however be wary of draining funds as it breaks the `cancelAndRefund` use case.
824    */
825   function withdraw(
826     uint _amount
827   ) external
828     onlyOwnerOrBeneficiary
829   {
830     uint balance = getBalance(address(this));
831     uint amount;
832     if(_amount == 0 || _amount > balance)
833     {
834       require(balance > 0, 'NOT_ENOUGH_FUNDS');
835       amount = balance;
836     }
837     else
838     {
839       amount = _amount;
840     }
841 
842     emit Withdrawal(msg.sender, beneficiary, amount);
843     // Security: re-entrancy not a risk as this is the last line of an external function
844     _transfer(beneficiary, amount);
845   }
846 
847   /**
848    * A function which lets the owner of the lock to change the price for future purchases.
849    */
850   function updateKeyPrice(
851     uint _keyPrice
852   )
853     external
854     onlyOwner
855     onlyIfAlive
856   {
857     uint oldKeyPrice = keyPrice;
858     keyPrice = _keyPrice;
859     emit PriceChanged(oldKeyPrice, keyPrice);
860   }
861 
862   /**
863    * A function which lets the owner of the lock update the beneficiary account,
864    * which receives funds on withdrawal.
865    */
866   function updateBeneficiary(
867     address _beneficiary
868   ) external
869     onlyOwnerOrBeneficiary
870   {
871     require(_beneficiary != address(0), 'INVALID_ADDRESS');
872     beneficiary = _beneficiary;
873   }
874 
875   /**
876    * Public function which returns the total number of unique keys sold (both
877    * expired and valid)
878    */
879   function totalSupply()
880     public
881     view
882     returns (uint)
883   {
884     return numberOfKeysSold;
885   }
886 }
887 
888 // File: contracts/mixins/MixinKeys.sol
889 
890 pragma solidity 0.5.9;
891 
892 
893 
894 
895 /**
896  * @title Mixin for managing `Key` data.
897  * @author HardlyDifficult
898  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
899  * separates logically groupings of code to ease readability.
900  */
901 contract MixinKeys is
902   Ownable,
903   MixinLockCore
904 {
905   // The struct for a key
906   struct Key {
907     uint tokenId;
908     uint expirationTimestamp;
909   }
910 
911   // Called when the Lock owner expires a user's Key
912   event ExpireKey(uint tokenId);
913 
914   // Keys
915   // Each owner can have at most exactly one key
916   // TODO: could we use public here? (this could be confusing though because it getter will
917   // return 0 values when missing a key)
918   mapping (address => Key) private keyByOwner;
919 
920   // Each tokenId can have at most exactly one owner at a time.
921   // Returns 0 if the token does not exist
922   // TODO: once we decouple tokenId from owner address (incl in js), then we can consider
923   // merging this with numberOfKeysSold into an array instead.
924   mapping (uint => address) private ownerByTokenId;
925 
926   // Addresses of owners are also stored in an array.
927   // Addresses are never removed by design to avoid abuses around referals
928   address[] public owners;
929 
930   // Ensures that an owner owns or has owned a key in the past
931   modifier ownsOrHasOwnedKey(
932     address _owner
933   ) {
934     require(
935       keyByOwner[_owner].expirationTimestamp > 0, 'HAS_NEVER_OWNED_KEY'
936     );
937     _;
938   }
939 
940   // Ensures that an owner has a valid key
941   modifier hasValidKey(
942     address _owner
943   ) {
944     require(
945       getHasValidKey(_owner), 'KEY_NOT_VALID'
946     );
947     _;
948   }
949 
950   // Ensures that a key has an owner
951   modifier isKey(
952     uint _tokenId
953   ) {
954     require(
955       ownerByTokenId[_tokenId] != address(0), 'NO_SUCH_KEY'
956     );
957     _;
958   }
959 
960   // Ensure that the caller owns the key
961   modifier onlyKeyOwner(
962     uint _tokenId
963   ) {
964     require(
965       isKeyOwner(_tokenId, msg.sender), 'ONLY_KEY_OWNER'
966     );
967     _;
968   }
969 
970   /**
971    * A function which lets the owner of the lock expire a users' key.
972    */
973   function expireKeyFor(
974     address _owner
975   )
976     public
977     onlyOwner
978     hasValidKey(_owner)
979   {
980     Key storage key = keyByOwner[_owner];
981     key.expirationTimestamp = block.timestamp; // Effectively expiring the key
982     emit ExpireKey(key.tokenId);
983   }
984 
985   /**
986    * In the specific case of a Lock, each owner can own only at most 1 key.
987    * @return The number of NFTs owned by `_owner`, either 0 or 1.
988   */
989   function balanceOf(
990     address _owner
991   )
992     external
993     view
994     returns (uint)
995   {
996     require(_owner != address(0), 'INVALID_ADDRESS');
997     return getHasValidKey(_owner) ? 1 : 0;
998   }
999 
1000   /**
1001    * Checks if the user has a non-expired key.
1002    */
1003   function getHasValidKey(
1004     address _owner
1005   )
1006     public
1007     view
1008     returns (bool)
1009   {
1010     return keyByOwner[_owner].expirationTimestamp > block.timestamp;
1011   }
1012 
1013   /**
1014    * @notice Find the tokenId for a given user
1015    * @return The tokenId of the NFT, else revert
1016   */
1017   function getTokenIdFor(
1018     address _account
1019   )
1020     external
1021     view
1022     hasValidKey(_account)
1023     returns (uint)
1024   {
1025     return keyByOwner[_account].tokenId;
1026   }
1027 
1028  /**
1029   * A function which returns a subset of the keys for this Lock as an array
1030   * @param _page the page of key owners requested when faceted by page size
1031   * @param _pageSize the number of Key Owners requested per page
1032   */
1033   function getOwnersByPage(uint _page, uint _pageSize)
1034     public
1035     view
1036     returns (address[] memory)
1037   {
1038     require(owners.length > 0, 'NO_OUTSTANDING_KEYS');
1039     uint pageSize = _pageSize;
1040     uint _startIndex = _page * pageSize;
1041     uint endOfPageIndex;
1042 
1043     if (_startIndex + pageSize > owners.length) {
1044       endOfPageIndex = owners.length;
1045       pageSize = owners.length - _startIndex;
1046     } else {
1047       endOfPageIndex = (_startIndex + pageSize);
1048     }
1049 
1050     // new temp in-memory array to hold pageSize number of requested owners:
1051     address[] memory ownersByPage = new address[](pageSize);
1052     uint pageIndex = 0;
1053 
1054     // Build the requested set of owners into a new temporary array:
1055     for (uint i = _startIndex; i < endOfPageIndex; i++) {
1056       ownersByPage[pageIndex] = owners[i];
1057       pageIndex++;
1058     }
1059 
1060     return ownersByPage;
1061   }
1062 
1063   /**
1064    * Checks if the given address owns the given tokenId.
1065    */
1066   function isKeyOwner(
1067     uint _tokenId,
1068     address _owner
1069   ) public view
1070     returns (bool)
1071   {
1072     return ownerByTokenId[_tokenId] == _owner;
1073   }
1074 
1075   /**
1076   * @dev Returns the key's ExpirationTimestamp field for a given owner.
1077   * @param _owner address of the user for whom we search the key
1078   */
1079   function keyExpirationTimestampFor(
1080     address _owner
1081   )
1082     public view
1083     ownsOrHasOwnedKey(_owner)
1084     returns (uint timestamp)
1085   {
1086     return keyByOwner[_owner].expirationTimestamp;
1087   }
1088 
1089   /**
1090    * Public function which returns the total number of unique owners (both expired
1091    * and valid).  This may be larger than totalSupply.
1092    */
1093   function numberOfOwners()
1094     public
1095     view
1096     returns (uint)
1097   {
1098     return owners.length;
1099   }
1100 
1101   /**
1102    * @notice ERC721: Find the owner of an NFT
1103    * @return The address of the owner of the NFT, if applicable
1104   */
1105   function ownerOf(
1106     uint _tokenId
1107   )
1108     public view
1109     isKey(_tokenId)
1110     returns (address)
1111   {
1112     return ownerByTokenId[_tokenId];
1113   }
1114 
1115   /**
1116    * Assigns the key a new tokenId (from numberOfKeysSold) if it does not already have
1117    * one assigned.
1118    */
1119   function _assignNewTokenId(
1120     Key storage _key
1121   ) internal
1122   {
1123     if (_key.tokenId == 0) {
1124       // This is a brand new owner, else an owner of an expired key buying an extension.
1125       // We increment the tokenId counter
1126       numberOfKeysSold++;
1127       // we assign the incremented `numberOfKeysSold` as the tokenId for the new key
1128       _key.tokenId = numberOfKeysSold;
1129     }
1130   }
1131 
1132   /**
1133    * Records the owner of a given tokenId
1134    */
1135   function _recordOwner(
1136     address _owner,
1137     uint _tokenId
1138   ) internal
1139   {
1140     if (ownerByTokenId[_tokenId] != _owner) {
1141       // TODO: this may include duplicate entries
1142       owners.push(_owner);
1143       // We register the owner of the tokenID
1144       ownerByTokenId[_tokenId] = _owner;
1145     }
1146   }
1147 
1148   /**
1149    * Returns the Key struct for the given owner.
1150    */
1151   function _getKeyFor(
1152     address _owner
1153   ) internal view
1154     returns (Key storage)
1155   {
1156     return keyByOwner[_owner];
1157   }
1158 }
1159 
1160 // File: contracts/mixins/MixinApproval.sol
1161 
1162 pragma solidity 0.5.9;
1163 
1164 
1165 
1166 
1167 
1168 /**
1169  * @title Mixin for the Approval related functions needed to meet the ERC721
1170  * standard.
1171  * @author HardlyDifficult
1172  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1173  * separates logically groupings of code to ease readability.
1174  */
1175 contract MixinApproval is
1176   IERC721,
1177   MixinDisableAndDestroy,
1178   MixinKeys
1179 {
1180   // Keeping track of approved transfers
1181   // This is a mapping of addresses which have approved
1182   // the transfer of a key to another address where their key can be transfered
1183   // Note: the approver may actually NOT have a key... and there can only
1184   // be a single approved beneficiary
1185   // Note 2: for transfer, both addresses will be different
1186   // Note 3: for sales (new keys on restricted locks), both addresses will be the same
1187   mapping (uint => address) private approved;
1188 
1189   // Keeping track of approved operators for a Key owner.
1190   // Since an owner can have up to 1 Key, this is similiar to above
1191   // but the approval does not reset when a transfer occurs.
1192   mapping (address => mapping (address => bool)) private ownerToOperatorApproved;
1193 
1194   // Ensure that the caller has a key
1195   // or that the caller has been approved
1196   // for ownership of that key
1197   modifier onlyKeyOwnerOrApproved(
1198     uint _tokenId
1199   ) {
1200     require(
1201       isKeyOwner(_tokenId, msg.sender) ||
1202         _isApproved(_tokenId, msg.sender) ||
1203         isApprovedForAll(ownerOf(_tokenId), msg.sender),
1204       'ONLY_KEY_OWNER_OR_APPROVED');
1205     _;
1206   }
1207 
1208   /**
1209    * This approves _approved to get ownership of _tokenId.
1210    * Note: that since this is used for both purchase and transfer approvals
1211    * the approved token may not exist.
1212    */
1213   function approve(
1214     address _approved,
1215     uint _tokenId
1216   )
1217     external
1218     payable
1219     onlyIfAlive
1220     onlyKeyOwnerOrApproved(_tokenId)
1221   {
1222     require(msg.sender != _approved, 'APPROVE_SELF');
1223 
1224     approved[_tokenId] = _approved;
1225     emit Approval(ownerOf(_tokenId), _approved, _tokenId);
1226   }
1227 
1228   /**
1229    * @dev Sets or unsets the approval of a given operator
1230    * An operator is allowed to transfer all tokens of the sender on their behalf
1231    * @param _to operator address to set the approval
1232    * @param _approved representing the status of the approval to be set
1233    */
1234   function setApprovalForAll(
1235     address _to,
1236     bool _approved
1237   ) external
1238     onlyIfAlive
1239   {
1240     require(_to != msg.sender, 'APPROVE_SELF');
1241     ownerToOperatorApproved[msg.sender][_to] = _approved;
1242     emit ApprovalForAll(msg.sender, _to, _approved);
1243   }
1244 
1245   /**
1246    * external version
1247    * Will return the approved recipient for a key, if any.
1248    */
1249   function getApproved(
1250     uint _tokenId
1251   )
1252     external
1253     view
1254     returns (address)
1255   {
1256     return _getApproved(_tokenId);
1257   }
1258 
1259   /**
1260    * @dev Tells whether an operator is approved by a given owner
1261    * @param _owner owner address which you want to query the approval of
1262    * @param _operator operator address which you want to query the approval of
1263    * @return bool whether the given operator is approved by the given owner
1264    */
1265   function isApprovedForAll(
1266     address _owner,
1267     address _operator
1268   ) public view
1269     returns (bool)
1270   {
1271     return ownerToOperatorApproved[_owner][_operator];
1272   }
1273 
1274   /**
1275    * @dev Checks if the given user is approved to transfer the tokenId.
1276    */
1277   function _isApproved(
1278     uint _tokenId,
1279     address _user
1280   ) internal view
1281     returns (bool)
1282   {
1283     return approved[_tokenId] == _user;
1284   }
1285 
1286   /**
1287    * Will return the approved recipient for a key transfer or ownership.
1288    * Note: this does not check that a corresponding key
1289    * actually exists.
1290    */
1291   function _getApproved(
1292     uint _tokenId
1293   )
1294     internal
1295     view
1296     returns (address)
1297   {
1298     address approvedRecipient = approved[_tokenId];
1299     require(approvedRecipient != address(0), 'NONE_APPROVED');
1300     return approvedRecipient;
1301   }
1302 
1303   /**
1304    * @dev Function to clear current approval of a given token ID
1305    * @param _tokenId uint256 ID of the token to be transferred
1306    */
1307   function _clearApproval(
1308     uint256 _tokenId
1309   ) internal
1310   {
1311     if (approved[_tokenId] != address(0)) {
1312       approved[_tokenId] = address(0);
1313     }
1314   }
1315 }
1316 
1317 // File: contracts/mixins/MixinGrantKeys.sol
1318 
1319 pragma solidity 0.5.9;
1320 
1321 
1322 
1323 
1324 
1325 /**
1326  * @title Mixin allowing the Lock owner to grant / gift keys to users.
1327  * @author HardlyDifficult
1328  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1329  * separates logically groupings of code to ease readability.
1330  */
1331 contract MixinGrantKeys is
1332   IERC721,
1333   Ownable,
1334   MixinKeys
1335 {
1336   /**
1337    * Allows the Lock owner to give a user a key with no charge.
1338    */
1339   function grantKey(
1340     address _recipient,
1341     uint _expirationTimestamp
1342   ) external
1343     onlyOwner
1344   {
1345     _grantKey(_recipient, _expirationTimestamp);
1346   }
1347 
1348   /**
1349    * Allows the Lock owner to give a collection of users a key with no charge.
1350    * All keys granted have the same expiration date.
1351    */
1352   function grantKeys(
1353     address[] calldata _recipients,
1354     uint _expirationTimestamp
1355   ) external
1356     onlyOwner
1357   {
1358     for(uint i = 0; i < _recipients.length; i++) {
1359       _grantKey(_recipients[i], _expirationTimestamp);
1360     }
1361   }
1362 
1363   /**
1364    * Allows the Lock owner to give a collection of users a key with no charge.
1365    * Each key may be assigned a different expiration date.
1366    */
1367   function grantKeys(
1368     address[] calldata _recipients,
1369     uint[] calldata _expirationTimestamps
1370   ) external
1371     onlyOwner
1372   {
1373     for(uint i = 0; i < _recipients.length; i++) {
1374       _grantKey(_recipients[i], _expirationTimestamps[i]);
1375     }
1376   }
1377 
1378   /**
1379    * Give a key to the given user
1380    */
1381   function _grantKey(
1382     address _recipient,
1383     uint _expirationTimestamp
1384   ) private
1385   {
1386     require(_recipient != address(0), 'INVALID_ADDRESS');
1387 
1388     Key storage toKey = _getKeyFor(_recipient);
1389     require(_expirationTimestamp > toKey.expirationTimestamp, 'ALREADY_OWNS_KEY');
1390 
1391     _assignNewTokenId(toKey);
1392     _recordOwner(_recipient, toKey.tokenId);
1393     toKey.expirationTimestamp = _expirationTimestamp;
1394 
1395     // trigger event
1396     emit Transfer(
1397       address(0), // This is a creation.
1398       _recipient,
1399       toKey.tokenId
1400     );
1401   }
1402 }
1403 
1404 // File: contracts/UnlockUtils.sol
1405 
1406 pragma solidity 0.5.9;
1407 
1408 // This contract provides some utility methods for use with the unlock protocol smart contracts.
1409 // Borrowed from:
1410 // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol#L943
1411 
1412 contract UnlockUtils {
1413 
1414   function strConcat(
1415     string memory _a,
1416     string memory _b,
1417     string memory _c,
1418     string memory _d
1419   ) public
1420     pure
1421     returns (string memory _concatenatedString)
1422   {
1423     bytes memory _ba = bytes(_a);
1424     bytes memory _bb = bytes(_b);
1425     bytes memory _bc = bytes(_c);
1426     bytes memory _bd = bytes(_d);
1427     string memory abcd = new string(_ba.length + _bb.length + _bc.length + _bd.length);
1428     bytes memory babcd = bytes(abcd);
1429     uint k = 0;
1430     uint i = 0;
1431     for (i = 0; i < _ba.length; i++) {
1432       babcd[k++] = _ba[i];
1433     }
1434     for (i = 0; i < _bb.length; i++) {
1435       babcd[k++] = _bb[i];
1436     }
1437     for (i = 0; i < _bc.length; i++) {
1438       babcd[k++] = _bc[i];
1439     }
1440     for (i = 0; i < _bd.length; i++) {
1441       babcd[k++] = _bd[i];
1442     }
1443     return string(babcd);
1444   }
1445 
1446   function uint2Str(
1447     uint _i
1448   ) public
1449     pure
1450     returns (string memory _uintAsString)
1451   {
1452     // make a copy of the param to avoid security/no-assign-params error
1453     uint c = _i;
1454     if (_i == 0) {
1455       return '0';
1456     }
1457     uint j = _i;
1458     uint len;
1459     while (j != 0) {
1460       len++;
1461       j /= 10;
1462     }
1463     bytes memory bstr = new bytes(len);
1464     uint k = len - 1;
1465     while (c != 0) {
1466       bstr[k--] = byte(uint8(48 + c % 10));
1467       c /= 10;
1468     }
1469     return string(bstr);
1470   }
1471 
1472   function address2Str(
1473     address _addr
1474   ) public
1475     pure
1476     returns(string memory)
1477   {
1478     bytes32 value = bytes32(uint256(_addr));
1479     bytes memory alphabet = '0123456789abcdef';
1480     bytes memory str = new bytes(42);
1481     str[0] = '0';
1482     str[1] = 'x';
1483     for (uint i = 0; i < 20; i++) {
1484       str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
1485       str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
1486     }
1487     return string(str);
1488   }
1489 }
1490 
1491 // File: contracts/mixins/MixinLockMetadata.sol
1492 
1493 pragma solidity 0.5.9;
1494 
1495 
1496 
1497 
1498 
1499 
1500 
1501 /**
1502  * @title Mixin for metadata about the Lock.
1503  * @author HardlyDifficult
1504  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1505  * separates logically groupings of code to ease readability.
1506  */
1507 contract MixinLockMetadata is
1508   IERC721,
1509   ERC165,
1510   Ownable,
1511   MixinLockCore,
1512   UnlockUtils,
1513   MixinKeys
1514 {
1515   /// A descriptive name for a collection of NFTs in this contract.Defaults to "Unlock-Protocol" but is settable by lock owner
1516   string private lockName;
1517 
1518   /// An abbreviated name for NFTs in this contract. Defaults to "KEY" but is settable by lock owner
1519   string private lockSymbol;
1520 
1521   // the base Token URI for this Lock. If not set by lock owner, the global URI stored in Unlock is used.
1522   string private baseTokenURI;
1523 
1524   event NewLockSymbol(
1525     string symbol
1526   );
1527 
1528   constructor(
1529     string memory _lockName
1530   ) internal
1531   {
1532     lockName = _lockName;
1533     // registering the optional erc721 metadata interface with ERC165.sol using
1534     // the ID specified in the standard: https://eips.ethereum.org/EIPS/eip-721
1535     _registerInterface(0x5b5e139f);
1536   }
1537 
1538   /**
1539    * Allows the Lock owner to assign a descriptive name for this Lock.
1540    */
1541   function updateLockName(
1542     string calldata _lockName
1543   ) external
1544     onlyOwner
1545   {
1546     lockName = _lockName;
1547   }
1548 
1549   /**
1550     * @dev Gets the token name
1551     * @return string representing the token name
1552     */
1553   function name(
1554   ) external view
1555     returns (string memory)
1556   {
1557     return lockName;
1558   }
1559 
1560   /**
1561    * Allows the Lock owner to assign a Symbol for this Lock.
1562    */
1563   function updateLockSymbol(
1564     string calldata _lockSymbol
1565   ) external
1566     onlyOwner
1567   {
1568     lockSymbol = _lockSymbol;
1569     emit NewLockSymbol(_lockSymbol);
1570   }
1571 
1572   /**
1573     * @dev Gets the token symbol
1574     * @return string representing the token name
1575     */
1576   function symbol()
1577     external view
1578     returns(string memory)
1579   {
1580     if(bytes(lockSymbol).length == 0) {
1581       return unlockProtocol.getGlobalTokenSymbol();
1582     } else {
1583       return lockSymbol;
1584     }
1585   }
1586 
1587   /**
1588    * Allows the Lock owner to update the baseTokenURI for this Lock.
1589    */
1590   function setBaseTokenURI(
1591     string calldata _baseTokenURI
1592   ) external
1593     onlyOwner
1594   {
1595     baseTokenURI = _baseTokenURI;
1596   }
1597 
1598   /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1599    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
1600    *  3986. The URI may point to a JSON file that conforms to the "ERC721
1601    *  Metadata JSON Schema".
1602    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1603    */
1604   function tokenURI(
1605     uint256 _tokenId
1606   ) external
1607     view
1608     isKey(_tokenId)
1609     returns(string memory)
1610   {
1611     string memory URI;
1612     if(bytes(baseTokenURI).length == 0) {
1613       URI = unlockProtocol.getGlobalBaseTokenURI();
1614     } else {
1615       URI = baseTokenURI;
1616     }
1617 
1618     return UnlockUtils.strConcat(
1619       URI,
1620       UnlockUtils.address2Str(address(this)),
1621       '/',
1622       UnlockUtils.uint2Str(_tokenId)
1623     );
1624   }
1625 }
1626 
1627 // File: contracts/mixins/MixinNoFallback.sol
1628 
1629 pragma solidity 0.5.9;
1630 
1631 
1632 /**
1633  * @title Mixin for the fallback function implementation, which simply reverts.
1634  * @author HardlyDifficult
1635  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1636  * separates logically groupings of code to ease readability.
1637  */
1638 contract MixinNoFallback
1639 {
1640   /**
1641    * @dev the fallback function should not be used.  This explicitly reverts
1642    * to ensure it's never used.
1643    */
1644   function()
1645     external
1646   {
1647     revert('NO_FALLBACK');
1648   }
1649 }
1650 
1651 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1652 
1653 pragma solidity ^0.5.0;
1654 
1655 /**
1656  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1657  * checks.
1658  *
1659  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1660  * in bugs, because programmers usually assume that an overflow raises an
1661  * error, which is the standard behavior in high level programming languages.
1662  * `SafeMath` restores this intuition by reverting the transaction when an
1663  * operation overflows.
1664  *
1665  * Using this library instead of the unchecked operations eliminates an entire
1666  * class of bugs, so it's recommended to use it always.
1667  */
1668 library SafeMath {
1669     /**
1670      * @dev Returns the addition of two unsigned integers, reverting on
1671      * overflow.
1672      *
1673      * Counterpart to Solidity's `+` operator.
1674      *
1675      * Requirements:
1676      * - Addition cannot overflow.
1677      */
1678     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1679         uint256 c = a + b;
1680         require(c >= a, "SafeMath: addition overflow");
1681 
1682         return c;
1683     }
1684 
1685     /**
1686      * @dev Returns the subtraction of two unsigned integers, reverting on
1687      * overflow (when the result is negative).
1688      *
1689      * Counterpart to Solidity's `-` operator.
1690      *
1691      * Requirements:
1692      * - Subtraction cannot overflow.
1693      */
1694     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1695         require(b <= a, "SafeMath: subtraction overflow");
1696         uint256 c = a - b;
1697 
1698         return c;
1699     }
1700 
1701     /**
1702      * @dev Returns the multiplication of two unsigned integers, reverting on
1703      * overflow.
1704      *
1705      * Counterpart to Solidity's `*` operator.
1706      *
1707      * Requirements:
1708      * - Multiplication cannot overflow.
1709      */
1710     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1711         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1712         // benefit is lost if 'b' is also tested.
1713         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1714         if (a == 0) {
1715             return 0;
1716         }
1717 
1718         uint256 c = a * b;
1719         require(c / a == b, "SafeMath: multiplication overflow");
1720 
1721         return c;
1722     }
1723 
1724     /**
1725      * @dev Returns the integer division of two unsigned integers. Reverts on
1726      * division by zero. The result is rounded towards zero.
1727      *
1728      * Counterpart to Solidity's `/` operator. Note: this function uses a
1729      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1730      * uses an invalid opcode to revert (consuming all remaining gas).
1731      *
1732      * Requirements:
1733      * - The divisor cannot be zero.
1734      */
1735     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1736         // Solidity only automatically asserts when dividing by 0
1737         require(b > 0, "SafeMath: division by zero");
1738         uint256 c = a / b;
1739         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1740 
1741         return c;
1742     }
1743 
1744     /**
1745      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1746      * Reverts when dividing by zero.
1747      *
1748      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1749      * opcode (which leaves remaining gas untouched) while Solidity uses an
1750      * invalid opcode to revert (consuming all remaining gas).
1751      *
1752      * Requirements:
1753      * - The divisor cannot be zero.
1754      */
1755     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1756         require(b != 0, "SafeMath: modulo by zero");
1757         return a % b;
1758     }
1759 }
1760 
1761 // File: contracts/mixins/MixinPurchase.sol
1762 
1763 pragma solidity 0.5.9;
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 /**
1772  * @title Mixin for the purchase-related functions.
1773  * @author HardlyDifficult
1774  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
1775  * separates logically groupings of code to ease readability.
1776  */
1777 contract MixinPurchase is
1778   MixinFunds,
1779   MixinDisableAndDestroy,
1780   MixinLockCore,
1781   MixinKeys
1782 {
1783   using SafeMath for uint;
1784 
1785   /**
1786   * @dev Purchase function, public version, with no referrer.
1787   * @param _recipient address of the recipient of the purchased key
1788   */
1789   function purchaseFor(
1790     address _recipient
1791   )
1792     external
1793     payable
1794     onlyIfAlive
1795   {
1796     return _purchaseFor(_recipient, address(0));
1797   }
1798 
1799   /**
1800   * @dev Purchase function, public version, with referrer.
1801   * @param _recipient address of the recipient of the purchased key
1802   * @param _referrer address of the user making the referral
1803   */
1804   function purchaseForFrom(
1805     address _recipient,
1806     address _referrer
1807   )
1808     external
1809     payable
1810     onlyIfAlive
1811     hasValidKey(_referrer)
1812   {
1813     return _purchaseFor(_recipient, _referrer);
1814   }
1815 
1816   /**
1817   * @dev Purchase function: this lets a user purchase a key from the lock for another user
1818   * @param _recipient address of the recipient of the purchased key
1819   * This will fail if
1820   *  - the keyReleaseMechanism is private
1821   *  - the keyReleaseMechanism is Approved and the recipient has not been previously approved
1822   *  - the amount value is smaller than the price
1823   *  - the recipient already owns a key
1824   * TODO: next version of solidity will allow for message to be added to require.
1825   */
1826   function _purchaseFor(
1827     address _recipient,
1828     address _referrer
1829   )
1830     private
1831     notSoldOut()
1832   { // solhint-disable-line function-max-lines
1833     require(_recipient != address(0), 'INVALID_ADDRESS');
1834 
1835     // Let's get the actual price for the key from the Unlock smart contract
1836     uint discount;
1837     uint tokens;
1838     uint inMemoryKeyPrice = keyPrice;
1839     (discount, tokens) = unlockProtocol.computeAvailableDiscountFor(_recipient, inMemoryKeyPrice);
1840     uint netPrice = inMemoryKeyPrice;
1841     if (discount > inMemoryKeyPrice) {
1842       netPrice = 0;
1843     } else {
1844       // SafeSub not required as the if statement already confirmed `inMemoryKeyPrice - discount` cannot underflow
1845       netPrice = inMemoryKeyPrice - discount;
1846     }
1847 
1848     // Assign the key
1849     Key storage toKey = _getKeyFor(_recipient);
1850 
1851     if (toKey.tokenId == 0) {
1852       // Assign a new tokenId (if a new owner or previously transfered)
1853       _assignNewTokenId(toKey);
1854       _recordOwner(_recipient, toKey.tokenId);
1855     }
1856 
1857     if (toKey.expirationTimestamp >= block.timestamp) {
1858       // This is an existing owner trying to extend their key
1859       toKey.expirationTimestamp = toKey.expirationTimestamp.add(expirationDuration);
1860     } else {
1861       // SafeAdd is not required here since expirationDuration is capped to a tiny value
1862       // (relative to the size of a uint)
1863       toKey.expirationTimestamp = block.timestamp + expirationDuration;
1864     }
1865 
1866     if (discount > 0) {
1867       unlockProtocol.recordConsumedDiscount(discount, tokens);
1868     }
1869 
1870     unlockProtocol.recordKeyPurchase(netPrice, _referrer);
1871 
1872     // trigger event
1873     emit Transfer(
1874       address(0), // This is a creation.
1875       _recipient,
1876       numberOfKeysSold
1877     );
1878 
1879     // We explicitly allow for greater amounts of ETH to allow 'donations'
1880     // Security: last line to minimize risk of re-entrancy
1881     _chargeAtLeast(netPrice);
1882   }
1883 }
1884 
1885 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
1886 
1887 pragma solidity ^0.5.0;
1888 
1889 /**
1890  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1891  *
1892  * These functions can be used to verify that a message was signed by the holder
1893  * of the private keys of a given address.
1894  */
1895 library ECDSA {
1896     /**
1897      * @dev Returns the address that signed a hashed message (`hash`) with
1898      * `signature`. This address can then be used for verification purposes.
1899      *
1900      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1901      * this function rejects them by requiring the `s` value to be in the lower
1902      * half order, and the `v` value to be either 27 or 28.
1903      *
1904      * (.note) This call _does not revert_ if the signature is invalid, or
1905      * if the signer is otherwise unable to be retrieved. In those scenarios,
1906      * the zero address is returned.
1907      *
1908      * (.warning) `hash` _must_ be the result of a hash operation for the
1909      * verification to be secure: it is possible to craft signatures that
1910      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1911      * this is by receiving a hash of the original message (which may otherwise)
1912      * be too long), and then calling `toEthSignedMessageHash` on it.
1913      */
1914     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1915         // Check the signature length
1916         if (signature.length != 65) {
1917             return (address(0));
1918         }
1919 
1920         // Divide the signature in r, s and v variables
1921         bytes32 r;
1922         bytes32 s;
1923         uint8 v;
1924 
1925         // ecrecover takes the signature parameters, and the only way to get them
1926         // currently is to use assembly.
1927         // solhint-disable-next-line no-inline-assembly
1928         assembly {
1929             r := mload(add(signature, 0x20))
1930             s := mload(add(signature, 0x40))
1931             v := byte(0, mload(add(signature, 0x60)))
1932         }
1933 
1934         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1935         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1936         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1937         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1938         //
1939         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1940         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1941         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1942         // these malleable signatures as well.
1943         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1944             return address(0);
1945         }
1946 
1947         if (v != 27 && v != 28) {
1948             return address(0);
1949         }
1950 
1951         // If the signature is valid (and not malleable), return the signer address
1952         return ecrecover(hash, v, r, s);
1953     }
1954 
1955     /**
1956      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1957      * replicates the behavior of the
1958      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
1959      * JSON-RPC method.
1960      *
1961      * See `recover`.
1962      */
1963     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1964         // 32 is the length in bytes of hash,
1965         // enforced by the type signature above
1966         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1967     }
1968 }
1969 
1970 // File: contracts/mixins/MixinRefunds.sol
1971 
1972 pragma solidity 0.5.9;
1973 
1974 
1975 
1976 
1977 
1978 
1979 
1980 
1981 contract MixinRefunds is
1982   Ownable,
1983   MixinFunds,
1984   MixinLockCore,
1985   MixinKeys
1986 {
1987   using SafeMath for uint;
1988 
1989   // CancelAndRefund will return funds based on time remaining minus this penalty.
1990   // This is calculated as `proRatedRefund * refundPenaltyNumerator / refundPenaltyDenominator`.
1991   uint public refundPenaltyNumerator = 1;
1992   uint public refundPenaltyDenominator = 10;
1993 
1994   // Stores a nonce per user to use for signed messages
1995   mapping(address => uint) public keyOwnerToNonce;
1996 
1997   event CancelKey(
1998     uint indexed tokenId,
1999     address indexed owner,
2000     address indexed sendTo,
2001     uint refund
2002   );
2003 
2004   event RefundPenaltyChanged(
2005     uint oldRefundPenaltyNumerator,
2006     uint oldRefundPenaltyDenominator,
2007     uint refundPenaltyNumerator,
2008     uint refundPenaltyDenominator
2009   );
2010 
2011   /**
2012    * @dev Destroys the user's key and sends a refund based on the amount of time remaining.
2013    */
2014   function cancelAndRefund()
2015     external
2016   {
2017     _cancelAndRefund(msg.sender);
2018   }
2019 
2020   /**
2021    * @dev Cancels a key owned by a different user and sends the funds to the msg.sender.
2022    * @param _keyOwner this user's key will be canceled
2023    * @param _signature getCancelAndRefundApprovalHash signed by the _keyOwner
2024    */
2025   function cancelAndRefundFor(
2026     address _keyOwner,
2027     bytes calldata _signature
2028   ) external
2029   {
2030     require(
2031       ECDSA.recover(
2032         ECDSA.toEthSignedMessageHash(
2033           getCancelAndRefundApprovalHash(_keyOwner, msg.sender)
2034         ),
2035         _signature
2036       ) == _keyOwner, 'INVALID_SIGNATURE'
2037     );
2038 
2039     keyOwnerToNonce[_keyOwner]++;
2040     _cancelAndRefund(_keyOwner);
2041   }
2042 
2043   /**
2044    * @dev Increments the current nonce for the msg.sender.
2045    * This can be used to invalidate a previously signed message.
2046    */
2047   function incrementNonce(
2048   ) external
2049   {
2050     keyOwnerToNonce[msg.sender]++;
2051   }
2052 
2053   /**
2054    * Allow the owner to change the refund penalty.
2055    */
2056   function updateRefundPenalty(
2057     uint _refundPenaltyNumerator,
2058     uint _refundPenaltyDenominator
2059   )
2060     external
2061     onlyOwner
2062   {
2063     require(_refundPenaltyDenominator != 0, 'INVALID_RATE');
2064 
2065     emit RefundPenaltyChanged(
2066       refundPenaltyNumerator,
2067       refundPenaltyDenominator,
2068       _refundPenaltyNumerator,
2069       _refundPenaltyDenominator
2070     );
2071     refundPenaltyNumerator = _refundPenaltyNumerator;
2072     refundPenaltyDenominator = _refundPenaltyDenominator;
2073   }
2074 
2075   /**
2076    * @dev Determines how much of a refund a key owner would receive if they issued
2077    * a cancelAndRefund block.timestamp.
2078    * Note that due to the time required to mine a tx, the actual refund amount will be lower
2079    * than what the user reads from this call.
2080    */
2081   function getCancelAndRefundValueFor(
2082     address _owner
2083   )
2084     external view
2085     returns (uint refund)
2086   {
2087     return _getCancelAndRefundValue(_owner);
2088   }
2089 
2090   /**
2091    * @dev returns the hash to sign in order to allow another user to cancel on your behalf.
2092    */
2093   function getCancelAndRefundApprovalHash(
2094     address _keyOwner,
2095     address _txSender
2096   ) public view
2097     returns (bytes32 approvalHash)
2098   {
2099     return keccak256(
2100       abi.encodePacked(
2101         // Approval is specific to this Lock
2102         address(this),
2103         // Approval enables only one cancel call
2104         keyOwnerToNonce[_keyOwner],
2105         // Approval allows only one account to broadcast the tx
2106         _txSender
2107       )
2108     );
2109   }
2110 
2111   /**
2112    * @dev cancels the key for the given keyOwner and sends the refund to the msg.sender.
2113    */
2114   function _cancelAndRefund(
2115     address _keyOwner
2116   ) internal
2117   {
2118     Key storage key = _getKeyFor(_keyOwner);
2119 
2120     uint refund = _getCancelAndRefundValue(_keyOwner);
2121 
2122     emit CancelKey(key.tokenId, _keyOwner, msg.sender, refund);
2123     // expirationTimestamp is a proxy for hasKey, setting this to `block.timestamp` instead
2124     // of 0 so that we can still differentiate hasKey from hasValidKey.
2125     key.expirationTimestamp = block.timestamp;
2126 
2127     if (refund > 0) {
2128       // Security: doing this last to avoid re-entrancy concerns
2129       _transfer(msg.sender, refund);
2130     }
2131   }
2132 
2133   /**
2134    * @dev Determines how much of a refund a key owner would receive if they issued
2135    * a cancelAndRefund now.
2136    * @param _owner The owner of the key check the refund value for.
2137    */
2138   function _getCancelAndRefundValue(
2139     address _owner
2140   )
2141     private view
2142     hasValidKey(_owner)
2143     returns (uint refund)
2144   {
2145     Key storage key = _getKeyFor(_owner);
2146     // Math: safeSub is not required since `hasValidKey` confirms timeRemaining is positive
2147     uint timeRemaining = key.expirationTimestamp - block.timestamp;
2148     if(timeRemaining >= expirationDuration) {
2149       refund = keyPrice;
2150     } else {
2151       // Math: using safeMul in case keyPrice or timeRemaining is very large
2152       refund = keyPrice.mul(timeRemaining) / expirationDuration;
2153     }
2154     uint penalty = keyPrice.mul(refundPenaltyNumerator) / refundPenaltyDenominator;
2155     if (refund > penalty) {
2156       // Math: safeSub is not required since the if confirms this won't underflow
2157       refund -= penalty;
2158     } else {
2159       refund = 0;
2160     }
2161   }
2162 }
2163 
2164 // File: openzeppelin-solidity/contracts/utils/Address.sol
2165 
2166 pragma solidity ^0.5.0;
2167 
2168 /**
2169  * @dev Collection of functions related to the address type,
2170  */
2171 library Address {
2172     /**
2173      * @dev Returns true if `account` is a contract.
2174      *
2175      * This test is non-exhaustive, and there may be false-negatives: during the
2176      * execution of a contract's constructor, its address will be reported as
2177      * not containing a contract.
2178      *
2179      * > It is unsafe to assume that an address for which this function returns
2180      * false is an externally-owned account (EOA) and not a contract.
2181      */
2182     function isContract(address account) internal view returns (bool) {
2183         // This method relies in extcodesize, which returns 0 for contracts in
2184         // construction, since the code is only stored at the end of the
2185         // constructor execution.
2186 
2187         uint256 size;
2188         // solhint-disable-next-line no-inline-assembly
2189         assembly { size := extcodesize(account) }
2190         return size > 0;
2191     }
2192 }
2193 
2194 // File: contracts/mixins/MixinTransfer.sol
2195 
2196 pragma solidity 0.5.9;
2197 
2198 
2199 
2200 
2201 
2202 
2203 
2204 
2205 
2206 /**
2207  * @title Mixin for the transfer-related functions needed to meet the ERC721
2208  * standard.
2209  * @author Nick Furfaro
2210  * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
2211  * separates logically groupings of code to ease readability.
2212  */
2213 
2214 contract MixinTransfer is
2215   MixinFunds,
2216   MixinLockCore,
2217   MixinKeys,
2218   MixinApproval
2219 {
2220   using SafeMath for uint;
2221   using Address for address;
2222 
2223   event TransferFeeChanged(
2224     uint oldTransferFeeNumerator,
2225     uint oldTransferFeeDenominator,
2226     uint transferFeeNumerator,
2227     uint transferFeeDenominator
2228   );
2229 
2230   // 0x150b7a02 == bytes4(keccak256('onERC721Received(address,address,uint256,bytes)'))
2231   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
2232 
2233   // The fee relative to keyPrice to charge when transfering a Key to another account
2234   // (potentially on a 0x marketplace).
2235   // This is calculated as `keyPrice * transferFeeNumerator / transferFeeDenominator`.
2236   uint public transferFeeNumerator = 0;
2237   uint public transferFeeDenominator = 100;
2238 
2239   /**
2240    * This is payable because at some point we want to allow the LOCK to capture a fee on 2ndary
2241    * market transactions...
2242    */
2243   function transferFrom(
2244     address _from,
2245     address _recipient,
2246     uint _tokenId
2247   )
2248     public
2249     payable
2250     onlyIfAlive
2251     hasValidKey(_from)
2252     onlyKeyOwnerOrApproved(_tokenId)
2253   {
2254     require(_recipient != address(0), 'INVALID_ADDRESS');
2255     _chargeAtLeast(getTransferFee(_from));
2256 
2257     Key storage fromKey = _getKeyFor(_from);
2258     Key storage toKey = _getKeyFor(_recipient);
2259 
2260     uint previousExpiration = toKey.expirationTimestamp;
2261 
2262     if (toKey.tokenId == 0) {
2263       toKey.tokenId = fromKey.tokenId;
2264       _recordOwner(_recipient, toKey.tokenId);
2265     }
2266 
2267     if (previousExpiration <= block.timestamp) {
2268       // The recipient did not have a key, or had a key but it expired. The new expiration is the
2269       // sender's key expiration
2270       // an expired key is no longer a valid key, so the new tokenID is the sender's tokenID
2271       toKey.expirationTimestamp = fromKey.expirationTimestamp;
2272       toKey.tokenId = fromKey.tokenId;
2273       _recordOwner(_recipient, _tokenId);
2274     } else {
2275       // The recipient has a non expired key. We just add them the corresponding remaining time
2276       // SafeSub is not required since the if confirms `previousExpiration - block.timestamp` cannot underflow
2277       toKey.expirationTimestamp = fromKey
2278         .expirationTimestamp.add(previousExpiration - block.timestamp);
2279     }
2280 
2281     // Effectively expiring the key for the previous owner
2282     fromKey.expirationTimestamp = block.timestamp;
2283 
2284     // Set the tokenID to 0 for the previous owner to avoid duplicates
2285     fromKey.tokenId = 0;
2286 
2287     // Clear any previous approvals
2288     _clearApproval(_tokenId);
2289 
2290     // trigger event
2291     emit Transfer(
2292       _from,
2293       _recipient,
2294       _tokenId
2295     );
2296   }
2297 
2298   /**
2299   * @notice Transfers the ownership of an NFT from one address to another address
2300   * @dev This works identically to the other function with an extra data parameter,
2301   *  except this function just sets data to ''
2302   * @param _from The current owner of the NFT
2303   * @param _to The new owner
2304   * @param _tokenId The NFT to transfer
2305   */
2306   function safeTransferFrom(
2307     address _from,
2308     address _to,
2309     uint _tokenId
2310   )
2311     external
2312     payable
2313   {
2314     safeTransferFrom(_from, _to, _tokenId, '');
2315   }
2316 
2317   /**
2318   * @notice Transfers the ownership of an NFT from one address to another address.
2319   * When transfer is complete, this functions
2320   *  checks if `_to` is a smart contract (code size > 0). If so, it calls
2321   *  `onERC721Received` on `_to` and throws if the return value is not
2322   *  `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
2323   * @param _from The current owner of the NFT
2324   * @param _to The new owner
2325   * @param _tokenId The NFT to transfer
2326   * @param _data Additional data with no specified format, sent in call to `_to`
2327   */
2328   function safeTransferFrom(
2329     address _from,
2330     address _to,
2331     uint _tokenId,
2332     bytes memory _data
2333   )
2334     public
2335     payable
2336     onlyIfAlive
2337     onlyKeyOwnerOrApproved(_tokenId)
2338     hasValidKey(ownerOf(_tokenId))
2339   {
2340     transferFrom(_from, _to, _tokenId);
2341     require(_checkOnERC721Received(_from, _to, _tokenId, _data), 'NON_COMPLIANT_ERC721_RECEIVER');
2342 
2343   }
2344 
2345   /**
2346    * Allow the Lock owner to change the transfer fee.
2347    */
2348   function updateTransferFee(
2349     uint _transferFeeNumerator,
2350     uint _transferFeeDenominator
2351   )
2352     external
2353     onlyOwner
2354   {
2355     require(_transferFeeDenominator != 0, 'INVALID_RATE');
2356     emit TransferFeeChanged(
2357       transferFeeNumerator,
2358       transferFeeDenominator,
2359       _transferFeeNumerator,
2360       _transferFeeDenominator
2361     );
2362     transferFeeNumerator = _transferFeeNumerator;
2363     transferFeeDenominator = _transferFeeDenominator;
2364   }
2365 
2366   /**
2367    * Determines how much of a fee a key owner would need to pay in order to
2368    * transfer the key to another account.  This is pro-rated so the fee goes down
2369    * overtime.
2370    * @param _owner The owner of the key check the transfer fee for.
2371    */
2372   function getTransferFee(
2373     address _owner
2374   )
2375     public view
2376     hasValidKey(_owner)
2377     returns (uint)
2378   {
2379     Key storage key = _getKeyFor(_owner);
2380     // Math: safeSub is not required since `hasValidKey` confirms timeRemaining is positive
2381     uint timeRemaining = key.expirationTimestamp - block.timestamp;
2382     uint fee;
2383     if(timeRemaining >= expirationDuration) {
2384       // Max the potential impact of this fee for keys with long durations remaining
2385       fee = keyPrice;
2386     } else {
2387       // Math: using safeMul in case keyPrice or timeRemaining is very large
2388       fee = keyPrice.mul(timeRemaining) / expirationDuration;
2389     }
2390     return fee.mul(transferFeeNumerator) / transferFeeDenominator;
2391   }
2392 
2393   /**
2394    * @dev Internal function to invoke `onERC721Received` on a target address
2395    * The call is not executed if the target address is not a contract
2396    * @param from address representing the previous owner of the given token ID
2397    * @param to target address that will receive the tokens
2398    * @param tokenId uint256 ID of the token to be transferred
2399    * @param _data bytes optional data to send along with the call
2400    * @return whether the call correctly returned the expected magic value
2401    */
2402   function _checkOnERC721Received(
2403     address from,
2404     address to,
2405     uint256 tokenId,
2406     bytes memory _data
2407   )
2408     internal
2409     returns (bool)
2410   {
2411     if (!to.isContract()) {
2412       return true;
2413     }
2414     bytes4 retval = IERC721Receiver(to).onERC721Received(
2415       msg.sender, from, tokenId, _data);
2416     return (retval == _ERC721_RECEIVED);
2417   }
2418 
2419 }
2420 
2421 // File: contracts/PublicLock.sol
2422 
2423 pragma solidity 0.5.9;
2424 
2425 
2426 
2427 
2428 
2429 
2430 
2431 
2432 
2433 
2434 
2435 
2436 
2437 
2438 
2439 
2440 
2441 /**
2442  * @title The Lock contract
2443  * @author Julien Genestoux (unlock-protocol.com)
2444  * Eventually: implement ERC721.
2445  * @dev ERC165 allows our contract to be queried to determine whether it implements a given interface.
2446  * Every ERC-721 compliant contract must implement the ERC165 interface.
2447  * https://eips.ethereum.org/EIPS/eip-721
2448  */
2449 contract PublicLock is
2450   IERC721,
2451   MixinNoFallback,
2452   ERC165,
2453   Ownable,
2454   ERC721Holder,
2455   MixinFunds,
2456   MixinDisableAndDestroy,
2457   MixinLockCore,
2458   MixinKeys,
2459   MixinLockMetadata,
2460   MixinGrantKeys,
2461   MixinPurchase,
2462   MixinApproval,
2463   MixinTransfer,
2464   MixinRefunds
2465 {
2466   constructor(
2467     address _owner,
2468     uint _expirationDuration,
2469     address _tokenAddress,
2470     uint _keyPrice,
2471     uint _maxNumberOfKeys,
2472     string memory _lockName
2473   )
2474     public
2475     MixinFunds(_tokenAddress)
2476     MixinLockCore(_owner, _expirationDuration, _keyPrice, _maxNumberOfKeys)
2477     MixinLockMetadata(_lockName)
2478   {
2479     // registering the interface for erc721 with ERC165.sol using
2480     // the ID specified in the standard: https://eips.ethereum.org/EIPS/eip-721
2481     _registerInterface(0x80ac58cd);
2482     // We must manually initialize Ownable.sol
2483     Ownable.initialize(_owner);
2484   }
2485 
2486   // The version number of the current implementation on this network
2487   function publicLockVersion(
2488   ) external pure
2489     returns (uint16)
2490   {
2491     return 4;
2492   }
2493 }