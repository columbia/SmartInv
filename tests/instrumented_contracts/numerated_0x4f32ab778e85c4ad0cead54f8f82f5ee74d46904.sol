1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
116  * the optional functions; to access them see {ERC20Detailed}.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: @openzeppelin/contracts/math/SafeMath.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      *
245      * _Available since v2.4.0._
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      *
303      * _Available since v2.4.0._
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         // Solidity only automatically asserts when dividing by 0
307         require(b > 0, errorMessage);
308         uint256 c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      * - The divisor cannot be zero.
339      *
340      * _Available since v2.4.0._
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 // File: contracts/I_Token.sol
349 
350 pragma solidity 0.5.0;
351 
352 /**
353  * @title   Interface Token
354  * @notice  Allows the Curve contract to interact with the token contract
355  *          without importing the entire smart contract. For documentation
356  *          please see the token contract:
357  *          https://gitlab.com/linumlabs/swarm-token
358  * @dev     This is not a full interface of the token, but instead a partial
359  *          interface covering only the functions that are needed by the curve.
360  */
361 interface I_Token {
362     // -------------------------------------------------------------------------
363     // IERC20 functions
364     // -------------------------------------------------------------------------
365 
366     function totalSupply() external view returns (uint256);
367 
368     function balanceOf(address account) external view returns (uint256);
369 
370     function transfer(address recipient, uint256 amount)
371         external
372         returns (bool);
373 
374     function allowance(address owner, address spender)
375         external
376         view
377         returns (uint256);
378 
379     function approve(address spender, uint256 amount) external returns (bool);
380 
381     function transferFrom(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) external returns (bool);
386 
387     // -------------------------------------------------------------------------
388     // ERC20 functions
389     // -------------------------------------------------------------------------
390 
391     function increaseAllowance(address spender, uint256 addedValue)
392         external
393         returns (bool);
394 
395     function decreaseAllowance(address spender, uint256 subtractedValue)
396         external
397         returns (bool);
398 
399     // -------------------------------------------------------------------------
400     // ERC20 Detailed
401     // -------------------------------------------------------------------------
402 
403     function name() external view returns (string memory);
404 
405     function symbol() external view returns (string memory);
406 
407     function decimals() external view returns (uint8);
408 
409     // -------------------------------------------------------------------------
410     // Burnable functions
411     // -------------------------------------------------------------------------
412 
413     function burn(uint256 amount) external;
414 
415     function burnFrom(address account, uint256 amount) external;
416 
417     // -------------------------------------------------------------------------
418     // Mintable functions
419     // -------------------------------------------------------------------------
420 
421     function isMinter(address account) external view returns (bool);
422 
423     function addMinter(address account) external;
424 
425     function renounceMinter() external;
426 
427     function mint(address account, uint256 amount) external returns (bool);
428 
429     // -------------------------------------------------------------------------
430     // Capped functions
431     // -------------------------------------------------------------------------
432 
433     function cap() external view returns (uint256);
434 }
435 
436 // File: contracts/I_Curve.sol
437 
438 pragma solidity 0.5.0;
439 
440 /**
441  * @title   Interface Curve
442  * @notice  This contract acts as an interface to the curve contract. For
443  *          documentation please see the curve smart contract.
444  */
445 interface I_Curve {
446     
447     // -------------------------------------------------------------------------
448     // View functions
449     // -------------------------------------------------------------------------
450 
451     /**
452      * @notice This function is only callable after the curve contract has been
453      *         initialized.
454      * @param  _amount The amount of tokens a user wants to buy
455      * @return uint256 The cost to buy the _amount of tokens in the collateral
456      *         currency (see collateral token).
457      */
458     function buyPrice(uint256 _amount)
459         external
460         view
461         returns (uint256 collateralRequired);
462 
463     /**
464      * @notice This function is only callable after the curve contract has been
465      *         initialized.
466      * @param  _amount The amount of tokens a user wants to sell
467      * @return collateralReward The reward for selling the _amount of tokens in the
468      *         collateral currency (see collateral token).
469      */
470     function sellReward(uint256 _amount)
471         external
472         view
473         returns (uint256 collateralReward);
474 
475     /**
476       * @return If the curve is both active and initialised.
477       */
478     function isCurveActive() external view returns (bool);
479 
480     /**
481       * @return The address of the collateral token (DAI)
482       */
483     function collateralToken() external view returns (address);
484 
485     /**
486       * @return The address of the bonded token (BZZ).
487       */
488     function bondedToken() external view returns (address);
489 
490     /**
491       * @return The required collateral amount (DAI) to initialise the curve.
492       */
493     function requiredCollateral(uint256 _initialSupply)
494         external
495         view
496         returns (uint256);
497 
498     // -------------------------------------------------------------------------
499     // State modifying functions
500     // -------------------------------------------------------------------------
501 
502     /**
503      * @notice This function initializes the curve contract, and ensure the
504      *         curve has the required permissions on the token contract needed
505      *         to function.
506      */
507     function init() external;
508 
509     /**
510       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
511       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
512       *         willing to spend in order to buy the _amount of tokens.
513       * @return The status of the mint. Note that should the total cost of the
514       *         purchase exceed the _maxCollateralSpend the transaction will revert.
515       */
516     function mint(uint256 _amount, uint256 _maxCollateralSpend)
517         external
518         returns (bool success);
519 
520     /**
521       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
522       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
523       *         willing to spend in order to buy the _amount of tokens.
524       * @param  _to The address to send the tokens to.
525       * @return The status of the mint. Note that should the total cost of the
526       *         purchase exceed the _maxCollateralSpend the transaction will revert.
527       */
528     function mintTo(
529         uint256 _amount, 
530         uint256 _maxCollateralSpend, 
531         address _to
532     )
533         external
534         returns (bool success);
535 
536     /**
537       * @param  _amount The amount of tokens (BZZ) the user wants to sell.
538       * @param  _minCollateralReward The min amount of collateral (DAI) the user is
539       *         willing to receive for their tokens.
540       * @return The status of the burn. Note that should the total reward of the
541       *         burn be below the _minCollateralReward the transaction will revert.
542       */
543     function redeem(uint256 _amount, uint256 _minCollateralReward)
544         external
545         returns (bool success);
546 
547     /**
548       * @notice Shuts down the curve, disabling buying, selling and both price
549       *         functions. Can only be called by the owner. Will renounce the
550       *         minter role on the bonded token.
551       */
552     function shutDown() external;
553 }
554 
555 // File: contracts/Curve.sol
556 
557 pragma solidity 0.5.0;
558 
559 
560 
561 
562 
563 
564 contract Curve is Ownable, I_Curve {
565     using SafeMath for uint256;
566     // The instance of the token this curve controls (has mint rights to)
567     I_Token internal bzz_;
568     // The instance of the collateral token that is used to buy and sell tokens
569     IERC20 internal dai_;
570     // Stores if the curve has been initialised
571     bool internal init_;
572     // The active state of the curve (false after emergency shutdown)
573     bool internal active_;
574     // Mutex guard for state modifying functions
575     uint256 private status_;
576     // States for the guard 
577     uint256 private constant _NOT_ENTERED = 1;
578     uint256 private constant _ENTERED = 2;
579 
580     // -------------------------------------------------------------------------
581     // Events
582     // -------------------------------------------------------------------------
583 
584     // Emitted when tokens are minted
585     event mintTokens(
586         address indexed buyer,      // The address of the buyer
587         uint256 amount,             // The amount of bonded tokens to mint
588         uint256 pricePaid,          // The price in collateral tokens 
589         uint256 maxSpend            // The max amount of collateral to spend
590     );
591     // Emitted when tokens are minted
592     event mintTokensTo(
593         address indexed buyer,      // The address of the buyer
594         address indexed receiver,   // The address of the receiver of the tokens
595         uint256 amount,             // The amount of bonded tokens to mint
596         uint256 pricePaid,          // The price in collateral tokens 
597         uint256 maxSpend            // The max amount of collateral to spend
598     );
599     // Emitted when tokens are burnt
600     event burnTokens(
601         address indexed seller,     // The address of the seller
602         uint256 amount,             // The amount of bonded tokens to sell
603         uint256 rewardReceived,     // The collateral tokens received
604         uint256 minReward           // The min collateral reward for tokens
605     );
606     // Emitted when the curve is permanently shut down
607     event shutDownOccurred(address indexed owner);
608 
609     // -------------------------------------------------------------------------
610     // Modifiers
611     // -------------------------------------------------------------------------
612 
613     /**
614       * @notice Requires the curve to be initialised and active.
615       */
616     modifier isActive() {
617         require(active_ && init_, "Curve inactive");
618         _;
619     }
620 
621     /**
622       * @notice Protects against re-entrancy attacks
623       */
624     modifier mutex() {
625         require(status_ != _ENTERED, "ReentrancyGuard: reentrant call");
626         // Any calls to nonReentrant after this point will fail
627         status_ = _ENTERED;
628         // Function executes
629         _;
630         // Status set to not entered
631         status_ = _NOT_ENTERED;
632     }
633 
634     // -------------------------------------------------------------------------
635     // Constructor
636     // -------------------------------------------------------------------------
637 
638     constructor(address _bondedToken, address _collateralToken) public Ownable() {
639         bzz_ = I_Token(_bondedToken);
640         dai_ = IERC20(_collateralToken);
641         status_ = _NOT_ENTERED;
642     }
643 
644     // -------------------------------------------------------------------------
645     // View functions
646     // -------------------------------------------------------------------------
647 
648     /**
649      * @notice This function is only callable after the curve contract has been
650      *         initialized.
651      * @param  _amount The amount of tokens a user wants to buy
652      * @return uint256 The cost to buy the _amount of tokens in the collateral
653      *         currency (see collateral token).
654      */
655     function buyPrice(uint256 _amount)
656         public
657         view
658         isActive()
659         returns (uint256 collateralRequired)
660     {
661         collateralRequired = _mint(_amount, bzz_.totalSupply());
662         return collateralRequired;
663     }
664 
665     /**
666      * @notice This function is only callable after the curve contract has been
667      *         initialized.
668      * @param  _amount The amount of tokens a user wants to sell
669      * @return collateralReward The reward for selling the _amount of tokens in the
670      *         collateral currency (see collateral token).
671      */
672     function sellReward(uint256 _amount)
673         public
674         view
675         isActive()
676         returns (uint256 collateralReward)
677     {
678         (collateralReward, ) = _withdraw(_amount, bzz_.totalSupply());
679         return collateralReward;
680     }
681 
682     /**
683       * @return If the curve is both active and initialised.
684       */
685     function isCurveActive() public view returns (bool) {
686         if (active_ && init_) {
687             return true;
688         }
689         return false;
690     }
691 
692     /**
693       * @param  _initialSupply The expected initial supply the bonded token
694       *         will have.
695       * @return The required collateral amount (DAI) to initialise the curve.
696       */
697     function requiredCollateral(uint256 _initialSupply)
698         public
699         view
700         returns (uint256)
701     {
702         return _initializeCurve(_initialSupply);
703     }
704 
705     /**
706       * @return The address of the bonded token (BZZ).
707       */
708     function bondedToken() external view returns (address) {
709         return address(bzz_);
710     }
711 
712     /**
713       * @return The address of the collateral token (DAI)
714       */
715     function collateralToken() external view returns (address) {
716         return address(dai_);
717     }
718 
719     // -------------------------------------------------------------------------
720     // State modifying functions
721     // -------------------------------------------------------------------------
722 
723     /**
724      * @notice This function initializes the curve contract, and ensure the
725      *         curve has the required permissions on the token contract needed
726      *         to function.
727      */
728     function init() external {
729         // Checks the curve has not already been initialized
730         require(!init_, "Curve is init");
731         // Checks the curve has the correct permissions on the given token
732         require(bzz_.isMinter(address(this)), "Curve is not minter");
733         // Gets the total supply of the token
734         uint256 initialSupply = bzz_.totalSupply();
735         // The curve requires that the initial supply is at least the expected
736         // open market supply
737         require(
738             initialSupply >= _MARKET_OPENING_SUPPLY,
739             "Curve equation requires pre-mint"
740         );
741         // Gets the price for the current supply
742         uint256 price = _initializeCurve(initialSupply);
743         // Requires the transfer for the collateral needed to back fill for the
744         // minted supply
745         require(
746             dai_.transferFrom(msg.sender, address(this), price),
747             "Failed to collateralized the curve"
748         );
749         // Sets the Curve to being active and initialised
750         active_ = true;
751         init_ = true;
752     }
753 
754     /**
755       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
756       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
757       *         willing to spend in order to buy the _amount of tokens.
758       * @return The status of the mint. Note that should the total cost of the
759       *         purchase exceed the _maxCollateralSpend the transaction will revert.
760       */
761     function mint(
762         uint256 _amount, 
763         uint256 _maxCollateralSpend
764     )
765         external
766         isActive()
767         mutex()
768         returns (bool success)
769     {
770         // Gets the price for the amount of tokens
771         uint256 price = _commonMint(_amount, _maxCollateralSpend, msg.sender);
772         // Emitting event with all important info
773         emit mintTokens(
774             msg.sender, 
775             _amount, 
776             price, 
777             _maxCollateralSpend
778         );
779         // Returning that the mint executed successfully
780         return true;
781     }
782 
783     /**
784       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
785       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
786       *         willing to spend in order to buy the _amount of tokens.
787       * @param  _to The address to send the tokens to.
788       * @return The status of the mint. Note that should the total cost of the
789       *         purchase exceed the _maxCollateralSpend the transaction will revert.
790       */
791     function mintTo(
792         uint256 _amount, 
793         uint256 _maxCollateralSpend, 
794         address _to
795     )
796         external
797         isActive()
798         mutex()
799         returns (bool success)
800     {
801         // Gets the price for the amount of tokens
802         uint256 price =  _commonMint(_amount, _maxCollateralSpend, _to);
803         // Emitting event with all important info
804         emit mintTokensTo(
805             msg.sender,
806             _to, 
807             _amount, 
808             price, 
809             _maxCollateralSpend
810         );
811         // Returning that the mint executed successfully
812         return true;
813     }
814 
815     /**
816       * @param  _amount The amount of tokens (BZZ) the user wants to sell.
817       * @param  _minCollateralReward The min amount of collateral (DAI) the user is
818       *         willing to receive for their tokens.
819       * @return The status of the burn. Note that should the total reward of the
820       *         burn be below the _minCollateralReward the transaction will revert.
821       */
822     function redeem(uint256 _amount, uint256 _minCollateralReward)
823         external
824         isActive()
825         mutex()
826         returns (bool success)
827     {
828         // Gets the reward for the amount of tokens
829         uint256 reward = sellReward(_amount);
830         // Checks the reward has not slipped below the min amount the user
831         // wishes to receive.
832         require(reward >= _minCollateralReward, "Reward under min sell");
833         // Burns the number of tokens (fails - no bool return)
834         bzz_.burnFrom(msg.sender, _amount);
835         // Transfers the reward from the curve to the collateral token
836         require(
837             dai_.transfer(msg.sender, reward),
838             "Transferring collateral failed"
839         );
840         // Emitting event with all important info
841         emit burnTokens(
842             msg.sender, 
843             _amount, 
844             reward, 
845             _minCollateralReward
846         );
847         // Returning that the burn executed successfully
848         return true;
849     }
850 
851     /**
852       * @notice Shuts down the curve, disabling buying, selling and both price
853       *         functions. Can only be called by the owner. Will renounce the
854       *         minter role on the bonded token.
855       */
856     function shutDown() external onlyOwner() {
857         // Removes the curve as a minter on the token
858         bzz_.renounceMinter();
859         // Irreversibly shuts down the curve
860         active_ = false;
861         // Emitting address of owner who shut down curve permanently
862         emit shutDownOccurred(msg.sender);
863     }
864 
865     // -------------------------------------------------------------------------
866     // Internal functions
867     // -------------------------------------------------------------------------
868 
869     /**
870       * @param  _amount The amount of tokens (BZZ) the user wants to buy.
871       * @param  _maxCollateralSpend The max amount of collateral (DAI) the user is
872       *         willing to spend in order to buy the _amount of tokens.
873       * @param  _to The address to send the tokens to.
874       * @return uint256 The price the user has paid for buying the _amount of 
875       *         BUZZ tokens. 
876       */
877     function _commonMint(
878         uint256 _amount,
879         uint256 _maxCollateralSpend,
880         address _to
881     )
882         internal
883         returns(uint256)
884     {
885         // Gets the price for the amount of tokens
886         uint256 price = buyPrice(_amount);
887         // Checks the price has not risen above the max amount the user wishes
888         // to spend.
889         require(price <= _maxCollateralSpend, "Price exceeds max spend");
890         // Transfers the price of tokens in the collateral token to the curve
891         require(
892             dai_.transferFrom(msg.sender, address(this), price),
893             "Transferring collateral failed"
894         );
895         // Mints the user their tokens
896         require(bzz_.mint(_to, _amount), "Minting tokens failed");
897         // Returns the price the user will pay for buy
898         return price;
899     }
900 
901     // -------------------------------------------------------------------------
902     // Curve mathematical functions
903 
904     uint256 internal constant _BZZ_SCALE = 1e16;
905     uint256 internal constant _N = 5;
906     uint256 internal constant _MARKET_OPENING_SUPPLY = 62500000 * _BZZ_SCALE;
907     // Equation for curve: 
908 
909     /**
910      * @param   x The supply to calculate at.
911      * @return  x^32/_MARKET_OPENING_SUPPLY^5
912      * @dev     Calculates the 32 power of `x` (`x` squared 5 times) times a 
913      *          constant. Each time it squares the function it divides by the 
914      *          `_MARKET_OPENING_SUPPLY` so when `x` = `_MARKET_OPENING_SUPPLY` 
915      *          it doesn't change `x`. 
916      *
917      *          `c*x^32` | `c` is chosen in such a way that 
918      *          `_MARKET_OPENING_SUPPLY` is the fixed point of the helper 
919      *          function.
920      *
921      *          The division by `_MARKET_OPENING_SUPPLY` also helps avoid an 
922      *          overflow.
923      *
924      *          The `_helper` function is separate to the `_primitiveFunction` 
925      *          as we modify `x`. 
926      */
927     function _helper(uint256 x) internal view returns (uint256) {
928         for (uint256 index = 1; index <= _N; index++) {
929             x = (x.mul(x)).div(_MARKET_OPENING_SUPPLY);
930         }
931         return x;
932     }
933 
934     /**
935      * @param   s The supply point being calculated for. 
936      * @return  The amount of DAI required for the requested amount of BZZ (s). 
937      * @dev     `s` is being added because it is the linear term in the 
938      *          polynomial (this ensures no free BUZZ tokens).
939      *
940      *          primitive function equation: s + c*s^32.
941      * 
942      *          See the helper function for the definition of `c`.
943      *
944      *          Converts from something measured in BZZ (1e16) to dai atomic 
945      *          units 1e18.
946      */
947     function _primitiveFunction(uint256 s) internal view returns (uint256) {
948         return s.add(_helper(s));
949     }
950 
951     /**
952      * @param  _supply The number of tokens that exist.
953      * @return uint256 The price for the next token up the curve.
954      */
955     function _spotPrice(uint256 _supply) internal view returns (uint256) {
956         return (_primitiveFunction(_supply.add(1)).sub(_primitiveFunction(_supply)));
957     }
958 
959     /**
960      * @param  _amount The amount of tokens to be minted
961      * @param  _currentSupply The current supply of tokens
962      * @return uint256 The cost for the tokens
963      * @return uint256 The price being paid per token
964      */
965     function _mint(uint256 _amount, uint256 _currentSupply)
966         internal
967         view
968         returns (uint256)
969     {
970         uint256 deltaR = _primitiveFunction(_currentSupply.add(_amount)).sub(
971             _primitiveFunction(_currentSupply));
972         return deltaR;
973     }
974 
975     /**
976      * @param  _amount The amount of tokens to be sold
977      * @param  _currentSupply The current supply of tokens
978      * @return uint256 The reward for the tokens
979      * @return uint256 The price being received per token
980      */
981     function _withdraw(uint256 _amount, uint256 _currentSupply)
982         internal
983         view
984         returns (uint256, uint256)
985     {
986         assert(_currentSupply - _amount > 0);
987         uint256 deltaR = _primitiveFunction(_currentSupply).sub(
988             _primitiveFunction(_currentSupply.sub(_amount)));
989         uint256 realized_price = deltaR.div(_amount);
990         return (deltaR, realized_price);
991     }
992 
993     /**
994      * @param  _initial_supply The supply the curve is going to start with.
995      * @return initial_reserve How much collateral is needed to collateralized
996      *         the bonding curve.
997      * @return price The price being paid per token (averaged).
998      */
999     function _initializeCurve(uint256 _initial_supply)
1000         internal
1001         view
1002         returns (uint256 price)
1003     {
1004         price = _mint(_initial_supply, 0);
1005         return price;
1006     }
1007 }