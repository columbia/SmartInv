1 pragma solidity ^0.5.10;
2 
3 /// @title Interface for interacting with the MarbleCards Core contract created by the fine folks at Marble.Cards.
4 contract CardCore {
5     function approve(address _approved, uint256 _tokenId) external payable;
6     function ownerOf(uint256 _tokenId) public view returns (address owner);
7     function transferFrom(address _from, address _to, uint256 _tokenId) external;
8     function getApproved(uint256 _tokenId) external view returns (address);
9 }
10 
11 
12 
13 
14 
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
18  * the optional functions; to access them see `ERC20Detailed`.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a `Transfer` event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through `transferFrom`. This is
43      * zero by default.
44      *
45      * This value changes when `approve` or `transferFrom` are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * > Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an `Approval` event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a `Transfer` event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to `approve`. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b <= a, "SafeMath: subtraction overflow");
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Solidity only automatically asserts when dividing by 0
175         require(b > 0, "SafeMath: division by zero");
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b != 0, "SafeMath: modulo by zero");
195         return a % b;
196     }
197 }
198 
199 
200 /**
201  * @dev Implementation of the `IERC20` interface.
202  *
203  * This implementation is agnostic to the way tokens are created. This means
204  * that a supply mechanism has to be added in a derived contract using `_mint`.
205  * For a generic mechanism see `ERC20Mintable`.
206  *
207  * *For a detailed writeup see our guide [How to implement supply
208  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
209  *
210  * We have followed general OpenZeppelin guidelines: functions revert instead
211  * of returning `false` on failure. This behavior is nonetheless conventional
212  * and does not conflict with the expectations of ERC20 applications.
213  *
214  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See `IERC20.approve`.
222  */
223 contract ERC20 is IERC20 {
224     using SafeMath for uint256;
225 
226     mapping (address => uint256) private _balances;
227 
228     mapping (address => mapping (address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     /**
233      * @dev See `IERC20.totalSupply`.
234      */
235     function totalSupply() public view returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See `IERC20.balanceOf`.
241      */
242     function balanceOf(address account) public view returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See `IERC20.transfer`.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public returns (bool) {
255         _transfer(msg.sender, recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See `IERC20.allowance`.
261      */
262     function allowance(address owner, address spender) public view returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See `IERC20.approve`.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 value) public returns (bool) {
274         _approve(msg.sender, spender, value);
275         return true;
276     }
277 
278     /**
279      * @dev See `IERC20.transferFrom`.
280      *
281      * Emits an `Approval` event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of `ERC20`;
283      *
284      * Requirements:
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `value`.
287      * - the caller must have allowance for `sender`'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to `approve` that can be used as a mitigation for
300      * problems described in `IERC20.approve`.
301      *
302      * Emits an `Approval` event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to `approve` that can be used as a mitigation for
317      * problems described in `IERC20.approve`.
318      *
319      * Emits an `Approval` event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
328         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Moves tokens `amount` from `sender` to `recipient`.
334      *
335      * This is internal function is equivalent to `transfer`, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a `Transfer` event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(address sender, address recipient, uint256 amount) internal {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _balances[sender] = _balances[sender].sub(amount);
351         _balances[recipient] = _balances[recipient].add(amount);
352         emit Transfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a `Transfer` event with `from` set to the zero address.
359      *
360      * Requirements
361      *
362      * - `to` cannot be the zero address.
363      */
364     function _mint(address account, uint256 amount) internal {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _totalSupply = _totalSupply.add(amount);
368         _balances[account] = _balances[account].add(amount);
369         emit Transfer(address(0), account, amount);
370     }
371 
372      /**
373      * @dev Destoys `amount` tokens from `account`, reducing the
374      * total supply.
375      *
376      * Emits a `Transfer` event with `to` set to the zero address.
377      *
378      * Requirements
379      *
380      * - `account` cannot be the zero address.
381      * - `account` must have at least `amount` tokens.
382      */
383     function _burn(address account, uint256 value) internal {
384         require(account != address(0), "ERC20: burn from the zero address");
385 
386         _totalSupply = _totalSupply.sub(value);
387         _balances[account] = _balances[account].sub(value);
388         emit Transfer(account, address(0), value);
389     }
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
393      *
394      * This is internal function is equivalent to `approve`, and can be used to
395      * e.g. set automatic allowances for certain subsystems, etc.
396      *
397      * Emits an `Approval` event.
398      *
399      * Requirements:
400      *
401      * - `owner` cannot be the zero address.
402      * - `spender` cannot be the zero address.
403      */
404     function _approve(address owner, address spender, uint256 value) internal {
405         require(owner != address(0), "ERC20: approve from the zero address");
406         require(spender != address(0), "ERC20: approve to the zero address");
407 
408         _allowances[owner][spender] = value;
409         emit Approval(owner, spender, value);
410     }
411 
412     /**
413      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
414      * from the caller's allowance.
415      *
416      * See `_burn` and `_approve`.
417      */
418     function _burnFrom(address account, uint256 amount) internal {
419         _burn(account, amount);
420         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
421     }
422 }
423 
424 
425 
426 /**
427  * @dev Contract module which provides a basic access control mechanism, where
428  * there is an account (an owner) that can be granted exclusive access to
429  * specific functions.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be aplied to your functions to restrict their use to
433  * the owner.
434  */
435 contract Ownable {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor () internal {
444         _owner = msg.sender;
445         emit OwnershipTransferred(address(0), _owner);
446     }
447 
448     /**
449      * @dev Returns the address of the current owner.
450      */
451     function owner() public view returns (address) {
452         return _owner;
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         require(isOwner(), "Ownable: caller is not the owner");
460         _;
461     }
462 
463     /**
464      * @dev Returns true if the caller is the current owner.
465      */
466     function isOwner() public view returns (bool) {
467         return msg.sender == _owner;
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * > Note: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public onlyOwner {
478         emit OwnershipTransferred(_owner, address(0));
479         _owner = address(0);
480     }
481 
482     /**
483      * @dev Transfers ownership of the contract to a new account (`newOwner`).
484      * Can only be called by the current owner.
485      */
486     function transferOwnership(address newOwner) public onlyOwner {
487         _transferOwnership(newOwner);
488     }
489 
490     /**
491      * @dev Transfers ownership of the contract to a new account (`newOwner`).
492      */
493     function _transferOwnership(address newOwner) internal {
494         require(newOwner != address(0), "Ownable: new owner is the zero address");
495         emit OwnershipTransferred(_owner, newOwner);
496         _owner = newOwner;
497     }
498 }
499 
500 
501 
502 /**
503  * @title Helps contracts guard against reentrancy attacks.
504  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
505  * @dev If you mark a function `nonReentrant`, you should also
506  * mark it `external`.
507  */
508 contract ReentrancyGuard {
509     /// @dev counter to allow mutex lock with only one SSTORE operation
510     uint256 private _guardCounter;
511 
512     constructor() public {
513         // The counter starts at one to prevent changing it from zero to a non-zero
514         // value, which is a more expensive operation.
515         _guardCounter = 1;
516     }
517 
518     /**
519      * @dev Prevents a contract from calling itself, directly or indirectly.
520      * Calling a `nonReentrant` function from another `nonReentrant`
521      * function is not supported. It is possible to prevent this from happening
522      * by making the `nonReentrant` function external, and make it call a
523      * `private` function that does the actual work.
524      */
525     modifier nonReentrant() {
526         _guardCounter += 1;
527         uint256 localCounter = _guardCounter;
528         _;
529         require(localCounter == _guardCounter);
530     }
531 }
532 
533 
534 
535 /// @title Main contract for WrappedMarbleCards. Heavily inspired by the fine work of the WrappedKitties team
536 ///  (https://wrappedkitties.com/) This contract converts MarbleCards between the ERC721 standard and the
537 ///  ERC20 standard by locking marble.cards into the contract and minting 1:1 backed ERC20 tokens, that
538 ///  can then be redeemed for marble cards when desired.
539 /// @notice When wrapping a marble card you get a generic WMC token. Since the WMC token is generic, it has no
540 ///  no information about what marble card you submitted, so you will most likely not receive the same card
541 ///  back when redeeming the token unless you specify that card's ID. The token only entitles you to receive
542 ///  *a* marble card in return, not necessarily the *same* marblecard in return. A different user can submit
543 ///  their own WMC tokens to the contract and withdraw the card that you originally deposited. WMC tokens have
544 ///  no information about which card was originally deposited to mint WMC - this is due to the very nature of
545 ///  the ERC20 standard being fungible, and the ERC721 standard being nonfungible.
546 contract WrappedMarbleCard is ERC20, Ownable, ReentrancyGuard {
547 
548     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
549     using SafeMath for uint256;
550 
551     /* ****** */
552     /* EVENTS */
553     /* ****** */
554 
555     /// @dev This event is fired when a user deposits marblecards into the contract in exchange
556     ///  for an equal number of WMC ERC20 tokens.
557     /// @param cardId  The card id of the marble card that was deposited into the contract.
558     event DepositCardAndMintToken(
559         uint256 cardId
560     );
561 
562     /// @dev This event is fired when a user deposits WMC ERC20 tokens into the contract in exchange
563     ///  for an equal number of locked marblecards.
564     /// @param cardId  The marblecard id of the card that was withdrawn from the contract.
565     event BurnTokenAndWithdrawCard(
566         uint256 cardId
567     );
568 
569     /* ******* */
570     /* STORAGE */
571     /* ******* */
572 
573     /// @dev An Array containing all of the marblecards that are locked in the contract, backing
574     ///  WMC ERC20 tokens 1:1
575     /// @notice Some of the cards in this array were indeed deposited to the contract, but they
576     ///  are no longer held by the contract. This is because withdrawSpecificCard() allows a
577     ///  user to withdraw a card "out of order". Since it would be prohibitively expensive to
578     ///  shift the entire array once we've withdrawn a single element, we instead maintain this
579     ///  mapping to determine whether an element is still contained in the contract or not.
580     uint256[] private depositedCardsArray;
581 
582     /// @dev Mapping to track whether a card is in the contract and it's place in the index
583     mapping (uint256 => DepositedCard) private cardsInIndex;
584 
585     /// A data structure for tracking whether a card is in the contract and it's location in the array.
586     struct DepositedCard {
587         bool inContract;
588         uint256 cardIndex;
589     }
590 
591     /* ********* */
592     /* CONSTANTS */
593     /* ********* */
594 
595     /// @dev The metadata details about the "Wrapped MarbleCards" WMC ERC20 token.
596     uint8 constant public decimals = 18;
597     string constant public name = "Wrapped MarbleCards";
598     string constant public symbol = "WMC";
599     uint256 constant internal cardInWei = uint256(10)**decimals;
600 
601     /// @dev The address of official MarbleCards contract that stores the metadata about each card.
602     /// @notice The owner is not capable of changing the address of the MarbleCards Core contract
603     ///  once the contract has been deployed.
604     /// Ropsten Testnet
605     // address public cardCoreAddress = 0x5bb5Ce2EAa21375407F05FcA36b0b04F115efE7d;
606     /// Mainnet
607     address public cardCoreAddress = 0x1d963688FE2209A98dB35C67A041524822Cf04ff;
608     CardCore cardCore;
609 
610     /* ********* */
611     /* FUNCTIONS */
612     /* ********* */
613 
614 
615     /// @notice Allows a user to lock marblecards in the contract in exchange for an equal number
616     ///  of WMC ERC20 tokens.
617     /// @param _cardIds  The ids of the marblecards that will be locked into the contract.
618     /// @notice The user must first call approve() in the MarbleCards Core contract on each card
619     ///  that they wish to deposit before calling depositCardsAndMintTokens(). There is no danger
620     ///  of this contract overreaching its approval, since the MarbleCards Core contract's approve()
621     ///  function only approves this contract for a single marble card. Calling approve() allows this
622     ///  contract to transfer the specified card in the depositCardsAndMintTokens() function.
623     function depositCardsAndMintTokens(uint256[] calldata _cardIds) external nonReentrant {
624         require(_cardIds.length > 0, 'you must submit an array with at least one element');
625         for(uint i = 0; i < _cardIds.length; i++){
626             uint256 cardToDeposit = _cardIds[i];
627             require(msg.sender == cardCore.ownerOf(cardToDeposit), 'you do not own this card');
628             require(cardCore.getApproved(cardToDeposit) == address(this), 'you must approve() this contract to give it permission to withdraw this card before you can deposit a card');
629             cardCore.transferFrom(msg.sender, address(this), cardToDeposit);
630             _pushCard(cardToDeposit);
631             emit DepositCardAndMintToken(cardToDeposit);
632         }
633         _mint(msg.sender, (_cardIds.length).mul(cardInWei));
634     }
635 
636 
637     /// @notice Allows a user to burn WMC ERC20 tokens in exchange for an equal number of locked
638     ///  marblecards.
639     /// @param _cardIds  The IDs of the cards that the user wishes to withdraw. If the user submits 0
640     ///  as the ID for any card, the contract uses the last card in the array for that card.
641     /// @param _destinationAddresses  The addresses that the withdrawn cards will be sent to (this allows
642     ///  anyone to "airdrop" cards to addresses that they do not own in a single transaction).
643     function burnTokensAndWithdrawCards(uint256[] calldata _cardIds, address[] calldata _destinationAddresses) external nonReentrant {
644         require(_cardIds.length == _destinationAddresses.length, 'you did not provide a destination address for each of the cards you wish to withdraw');
645         require(_cardIds.length > 0, 'you must submit an array with at least one element');
646 
647         uint256 numTokensToBurn = _cardIds.length;
648         require(balanceOf(msg.sender) >= numTokensToBurn.mul(cardInWei), 'you do not own enough tokens to withdraw this many ERC721 cards');
649         _burn(msg.sender, numTokensToBurn.mul(cardInWei));
650 
651         for(uint i = 0; i < numTokensToBurn; i++){
652             uint256 cardToWithdraw = _cardIds[i];
653             if(cardToWithdraw == 0){
654                 cardToWithdraw = _popCard();
655             } else {
656                 require(isCardInDeck(cardToWithdraw), 'this card is not in the deck');
657                 require(address(this) == cardCore.ownerOf(cardToWithdraw), 'the contract does not own this card');
658                 _removeFromDeck(cardToWithdraw);
659             }
660             cardCore.transferFrom(address(this), _destinationAddresses[i], cardToWithdraw);
661             emit BurnTokenAndWithdrawCard(cardToWithdraw);
662         }
663     }
664 
665     /// @notice Adds a locked marblecard to the end of the array
666     /// @param _cardId  The id of the marblecard that will be locked into the contract.
667     function _pushCard(uint256 _cardId) internal {
668         // push() returns the new array length, sub 1 to get the index
669         uint256 index = depositedCardsArray.push(_cardId) - 1;
670         DepositedCard memory _card = DepositedCard(true, index);
671         cardsInIndex[_cardId] = _card;
672     }
673 
674     /// @notice Removes an unlocked marblecard from the end of the array
675     /// @return  The id of the marblecard that will be unlocked from the contract.
676     function _popCard() internal returns(uint256) {
677         require(depositedCardsArray.length > 0, 'there are no cards in the array');
678         uint256 cardId = depositedCardsArray[depositedCardsArray.length - 1];
679         _removeFromDeck(cardId);
680         return cardId;
681     }
682 
683     /// @notice The owner is not capable of changing the address of the MarbleCards Core
684     ///  contract once the contract has been deployed.
685     constructor() public {
686         cardCore = CardCore(cardCoreAddress);
687     }
688 
689     /// @dev We leave the fallback function payable in case the current State Rent proposals require
690     ///  us to send funds to this contract to keep it alive on mainnet.
691     function() external payable {}
692 
693     /// @dev If any eth is accidentally sent to this contract it can be withdrawn by the owner rather than letting
694     ///   it get locked up forever. Don't send ETH to the contract, but if you do, the developer will consider it a tip.
695     function extractAccidentalPayableEth() public onlyOwner returns (bool) {
696         require(address(this).balance > 0);
697         address(uint160(owner())).transfer(address(this).balance);
698         return true;
699     }
700 
701     /// @dev Gets the index of the card in the deck
702     function _getCardIndex(uint256 _cardId) internal view returns (uint256) {
703         require(isCardInDeck(_cardId));
704         return cardsInIndex[_cardId].cardIndex;
705     }
706 
707     /// @dev Will return true if the cardId is a card that is in the deck.
708     function isCardInDeck(uint256 _cardId) public view returns (bool) {
709         return cardsInIndex[_cardId].inContract;
710     }
711 
712     /// @dev Remove a card by switching the place in the array
713     function _removeFromDeck(uint256 _cardId) internal {
714         // Get the index of the card passed above
715         uint256 index = _getCardIndex(_cardId);
716         // Get the last element of the existing array
717         uint256 cardToMove = depositedCardsArray[depositedCardsArray.length - 1];
718         // Move the card at the end of the array to the location
719         //   of the card we want to void.
720         depositedCardsArray[index] = cardToMove;
721         // Move the card we are voiding to the end of the index
722         cardsInIndex[cardToMove].cardIndex = index;
723         // Trim the last card from the index
724         delete cardsInIndex[_cardId];
725         depositedCardsArray.length--;
726     }
727 
728 }