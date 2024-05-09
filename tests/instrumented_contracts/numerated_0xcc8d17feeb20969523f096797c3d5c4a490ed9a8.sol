1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin\contracts\access\Ownable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin\contracts\math\SafeMath.sol
99 
100 // SPDX-License-Identifier: MIT
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: contracts\interfaces\WarpVaultSCI.sol
261 
262 pragma solidity ^0.6.0;
263 
264 ////////////////////////////////////////////////////////////////////////////////////////////
265 /// @title WarpVaultSCI
266 /// @author Christopher Dixon
267 ////////////////////////////////////////////////////////////////////////////////////////////
268 /**
269 The WarpVaultSCI contract an abstract contract the WarpControl contract uses to interface
270     with a WarpVaultSC contract.
271 **/
272 
273 abstract contract WarpVaultSCI {
274 
275       uint256 public totalReserves;
276     /**
277     @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
278     @param account The address whose balance should be calculated after updating borrowIndex
279     @return The calculated balance
280     **/
281     function borrowBalanceCurrent(address account)
282         public
283         virtual
284         returns (uint256);
285 
286     /**
287     @notice returns last calculated account's borrow balance using the prior borrowIndex
288     @param account The address whose balance should be calculated after updating borrowIndex
289     @return The calculated balance
290     **/
291     function borrowBalancePrior(address account)
292         public
293         view
294         virtual
295         returns (uint256);
296 
297     /**
298      @notice Accrue interest then return the up-to-date exchange rate
299      @return Calculated exchange rate scaled by 1e18
300      **/
301     function exchangeRateCurrent() public virtual returns (uint256);
302 
303     /**
304     @notice Sender borrows stablecoin assets from the protocol to their own address
305     @param _borrowAmount The amount of the underlying asset to borrow
306     @param _borrower The borrower
307     */
308     function _borrow(uint256 _borrowAmount, address _borrower) external virtual;
309 
310     /**
311     @notice repayLiquidatedLoan is a function used by the Warp Control contract to repay a loan on behalf of a liquidator
312     @param _borrower is the address of the borrower who took out the loan
313     @param _liquidator is the address of the account who is liquidating the loan
314     @param _amount is the amount of StableCoin being repayed
315     @dev this function uses the onlyWC modifier which means it can only be called by the Warp Control contract
316     **/
317     function _repayLiquidatedLoan(
318         address _borrower,
319         address _liquidator,
320         uint256 _amount
321     ) public virtual;
322 
323     function setNewInterestModel(address _newModel) public virtual;
324 
325 
326     function transferOwnership(address _newOwner) public virtual;
327 
328     function getSCDecimals() public view virtual returns(uint8);
329     function getSCAddress() public view virtual returns(address);
330 
331     function upgrade(address _warpControl) public virtual;
332     function updateTeam(address _warpTeam) public virtual;
333 
334 }
335 
336 // File: contracts\interfaces\WarpVaultLPI.sol
337 
338 pragma solidity ^0.6.0;
339 
340 ////////////////////////////////////////////////////////////////////////////////////////////
341 /// @title WarpVaultLPI
342 /// @author Christopher Dixon
343 ////////////////////////////////////////////////////////////////////////////////////////////
344 /**
345 The WarpVaultLPI contract an abstract contract the WarpControl contract uses to interface
346     with a WarpVaultLP contract.
347 **/
348 
349 abstract contract WarpVaultLPI {
350     /**
351     @notice getAssetAdd allows for easy retrieval of a WarpVaults LP token Adress
352     **/
353     function getAssetAdd() public view virtual returns (address);
354 
355     /**
356     @notice collateralOfAccount is a view function to retreive an accounts collateralized LP amount
357     @param _account is the address of the account being looked up
358     **/
359 
360     function collateralOfAccount(address _account)
361         public
362         view
363         virtual
364         returns (uint256);
365 
366     /**
367     @notice _liquidateAccount is a function to liquidate the LP tokens of the input account
368     @param _account is the address of the account being liquidated
369     @param _liquidator is the address of the account doing the liquidating who receives the liquidated LP's
370     @dev this function uses the onlyWC modifier meaning that only the Warp Control contract can call it
371     **/
372     function _liquidateAccount(address _account, address _liquidator)
373         public
374         virtual;
375 
376     function transferOwnership(address _newOwner) public virtual;
377 
378     function upgrade(address _warpControl) public virtual;
379 
380 }
381 
382 // File: contracts\interfaces\WarpVaultLPFactoryI.sol
383 
384 pragma solidity ^0.6.0;
385 
386 ////////////////////////////////////////////////////////////////////////////////////////////
387 /// @title WarpVaultLPFactoryI
388 /// @author Christopher Dixon
389 ////////////////////////////////////////////////////////////////////////////////////////////
390 /**
391 The WarpVaultLPFactory contract is designed to produce individual WarpVaultLP contracts
392 This contract uses the OpenZeppelin contract Library to inherit functions from
393   Ownable.sol
394 **/
395 
396 abstract contract WarpVaultLPFactoryI {
397     /**
398       @notice createWarpVaultLP allows the contract owner to create a new WarpVaultLP contract for a specific LP token
399       @param _lp is the address for the LP token this Warp Vault will manage
400       @param _lpName is the name of the LP token (ex:wETH-wBTC)
401       @param _lpName is the name of the LP token (ex:wETH-wBTC)
402       **/
403     function createWarpVaultLP(uint256 _timelock, address _lp, string memory _lpName)
404         public
405         virtual
406         returns (address);
407 
408     function transferOwnership(address _newOwner) public virtual;
409 
410 }
411 
412 // File: contracts\interfaces\WarpVaultSCFactoryI.sol
413 
414 pragma solidity ^0.6.0;
415 
416 ////////////////////////////////////////////////////////////////////////////////////////////
417 /// @title WarpVaultSCFactoryI
418 /// @author Christopher Dixon
419 ////////////////////////////////////////////////////////////////////////////////////////////
420 /**
421 The WarpVaultSCFactoryI contract is used by the Warp Control contract to interface with the WarpVaultSCFactory contract
422 This contract uses the OpenZeppelin contract Library to inherit functions from
423   Ownable.sol
424 **/
425 
426 abstract contract WarpVaultSCFactoryI {
427     /**
428   @notice createNewWarpVaultSC is used to create new WarpVaultSC contract instances
429   @param _InterestRate is the address of the InterestRateModel contract created for this Warp Vault
430   @param _StableCoin is the address of the stablecoin contract this WarpVault will manage
431   @param _warpTeam is the address of the Warp Team used for fees
432   @param _initialExchangeRate is the exchange rate mantissa used to determine the initial exchange rate of stablecoin to warp stablecoin
433   @param _timelock is a variable representing the number of seconds the timeWizard will prevent withdraws and borrows from a contracts(one week is 605800 seconds)
434     **/
435     function createNewWarpVaultSC(
436         address _InterestRate,
437         address _StableCoin,
438         address _warpTeam,
439         uint256 _initialExchangeRate,
440         uint256 _timelock,
441         uint256 _reserveFactorMantissa
442     ) public virtual returns (address);
443 
444     function transferOwnership(address _newOwner) public virtual;
445 
446 }
447 
448 // File: contracts\interfaces\UniswapLPOracleFactoryI.sol
449 
450 pragma solidity ^0.6.0;
451 
452 ////////////////////////////////////////////////////////////////////////////////////////////
453 /// @title UniswapLPOracleFactoryI
454 /// @author Christopher Dixon
455 ////////////////////////////////////////////////////////////////////////////////////////////
456 /**
457 The UniswapLPOracleFactoryI contract an abstract contract the Warp platform uses to interface
458     With the UniswapOracleFactory to retrieve token prices.
459 **/
460 
461 abstract contract UniswapLPOracleFactoryI {
462     /**
463 @notice createNewOracle allows the owner of this contract to deploy a new oracle contract when
464         a new asset is whitelisted
465 @dev this function is marked as virtual as it is an abstracted function
466 **/
467 
468     function createNewOracles(
469         address _tokenA,
470         address _tokenB,
471         address _lpToken
472     ) public virtual;
473 
474     function OneUSDC() public virtual view returns (uint256);
475 
476     /**
477 @notice getUnderlyingPrice allows for the price retrieval of a MoneyMarketInstances underlying asset
478 @param _MMI is the address of the MoneyMarketInstance whos asset price is being retrieved
479 @return returns the price of the asset
480 **/
481     function getUnderlyingPrice(address _MMI)
482         public
483         virtual
484         returns (uint256);
485 
486     function viewUnderlyingPrice(address _MMI)
487         public
488         view
489         virtual
490         returns (uint256);
491 
492     function getPriceOfToken(address _token, uint256 _amount) public virtual returns (uint256);
493     function viewPriceOfToken(address token, uint256 _amount) public view virtual returns (uint256);
494 
495     function transferOwnership(address _newOwner) public virtual;
496 
497       function _calculatePriceOfLP(uint256 supply, uint256 value0, uint256 value1, uint8 supplyDecimals)
498       public pure virtual returns (uint256);
499 }
500 
501 // File: contracts\compound\BaseJumpRateModelV2.sol
502 
503 pragma solidity ^0.6.0;
504 
505 
506 /**
507   * @title Logic for Compound's JumpRateModel Contract V2.
508   * @author Compound (modified by Dharma Labs, refactored by Arr00)
509   * @notice Version 2 modifies Version 1 by enabling updateable parameters.
510   */
511 contract BaseJumpRateModelV2 {
512     using SafeMath for uint;
513 
514     event NewInterestParams(uint baseRatePerBlock, uint multiplierPerBlock, uint jumpMultiplierPerBlock, uint kink);
515 
516     /**
517      * @notice The address of the owner, i.e. the Timelock contract, which can update parameters directly
518      */
519     address public owner;
520 
521     /**
522      * @notice The approximate number of blocks per year that is assumed by the interest rate model
523      */
524     uint public constant blocksPerYear = 2102400;
525 
526     /**
527      * @notice The multiplier of utilization rate that gives the slope of the interest rate
528      */
529     uint public multiplierPerBlock;
530 
531     /**
532      * @notice The base interest rate which is the y-intercept when utilization rate is 0
533      */
534     uint public baseRatePerBlock;
535 
536     /**
537      * @notice The multiplierPerBlock after hitting a specified utilization point
538      */
539     uint public jumpMultiplierPerBlock;
540 
541     /**
542      * @notice The utilization point at which the jump multiplier is applied
543      */
544     uint public kink;
545 
546     /**
547      * @notice Construct an interest rate model
548      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
549      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
550      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
551      * @param kink_ The utilization point at which the jump multiplier is applied
552      * @param owner_ The address of the owner, i.e. the Timelock contract (which has the ability to update parameters directly)
553      */
554     constructor(uint baseRatePerYear, uint multiplierPerYear, uint jumpMultiplierPerYear, uint kink_, address owner_) internal {
555         owner = owner_;
556 
557         updateJumpRateModelInternal(baseRatePerYear,  multiplierPerYear, jumpMultiplierPerYear, kink_);
558     }
559 
560     /**
561      * @notice Update the parameters of the interest rate model (only callable by owner, i.e. Timelock)
562      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
563      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
564      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
565      * @param kink_ The utilization point at which the jump multiplier is applied
566      */
567     function updateJumpRateModel(uint baseRatePerYear, uint multiplierPerYear, uint jumpMultiplierPerYear, uint kink_) external {
568         require(msg.sender == owner, "only the owner may call this function.");
569 
570         updateJumpRateModelInternal(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_);
571     }
572 
573     /**
574      * @notice Calculates the utilization rate of the market: `borrows / (cash + borrows - reserves)`
575      * @param cash The amount of cash in the market
576      * @param borrows The amount of borrows in the market
577      * @param reserves The amount of reserves in the market (currently unused)
578      * @return The utilization rate as a mantissa between [0, 1e18]
579      */
580     function utilizationRate(uint cash, uint borrows, uint reserves) public pure returns (uint) {
581         // Utilization rate is 0 when there are no borrows
582         if (borrows == 0) {
583             return 0;
584         }
585 
586         return borrows.mul(1e18).div(cash.add(borrows).sub(reserves));
587     }
588 
589     /**
590      * @notice Calculates the current borrow rate per block, with the error code expected by the market
591      * @param cash The amount of cash in the market
592      * @param borrows The amount of borrows in the market
593      * @param reserves The amount of reserves in the market
594      * @return The borrow rate percentage per block as a mantissa (scaled by 1e18)
595      */
596     function getBorrowRateInternal(uint cash, uint borrows, uint reserves) internal view returns (uint) {
597         uint util = utilizationRate(cash, borrows, reserves);
598 
599         if (util <= kink) {
600             return util.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
601         } else {
602             uint normalRate = kink.mul(multiplierPerBlock).div(1e18).add(baseRatePerBlock);
603             uint excessUtil = util.sub(kink);
604             return excessUtil.mul(jumpMultiplierPerBlock).div(1e18).add(normalRate);
605         }
606     }
607 
608     /**
609      * @notice Calculates the current supply rate per block
610      * @param cash The amount of cash in the market
611      * @param borrows The amount of borrows in the market
612      * @param reserves The amount of reserves in the market
613      * @param reserveFactorMantissa The current reserve factor for the market
614      * @return The supply rate percentage per block as a mantissa (scaled by 1e18)
615      */
616     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) public  view returns (uint) {
617         uint oneMinusReserveFactor = uint(1e18).sub(reserveFactorMantissa);
618         uint borrowRate = getBorrowRateInternal(cash, borrows, reserves);
619         uint rateToPool = borrowRate.mul(oneMinusReserveFactor).div(1e18);
620         return utilizationRate(cash, borrows, reserves).mul(rateToPool).div(1e18);
621     }
622 
623     /**
624      * @notice Internal function to update the parameters of the interest rate model
625      * @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
626      * @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
627      * @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
628      * @param kink_ The utilization point at which the jump multiplier is applied
629      */
630     function updateJumpRateModelInternal(uint baseRatePerYear, uint multiplierPerYear, uint jumpMultiplierPerYear, uint kink_) internal {
631         baseRatePerBlock = baseRatePerYear.div(blocksPerYear);
632         multiplierPerBlock = (multiplierPerYear.mul(1e18)).div(blocksPerYear.mul(kink_));
633         jumpMultiplierPerBlock = jumpMultiplierPerYear.div(blocksPerYear);
634         kink = kink_;
635 
636         emit NewInterestParams(baseRatePerBlock, multiplierPerBlock, jumpMultiplierPerBlock, kink);
637     }
638 
639 
640 }
641 
642 // File: contracts\compound\JumpRateModelV2.sol
643 
644 pragma solidity ^0.6.0;
645 
646 
647 
648 
649 /**
650   * @title Compound's JumpRateModel Contract V2 for V2 cTokens
651   * @author Arr00
652   * @notice Supports only for V2 cTokens
653   */
654 contract JumpRateModelV2 is  BaseJumpRateModelV2  {
655 
656 	/**
657      * @notice Calculates the current borrow rate per block
658      * @param cash The amount of cash in the market
659      * @param borrows The amount of borrows in the market
660      * @param reserves The amount of reserves in the market
661      * @return The borrow rate percentage per block as a mantissa (scaled by 1e18)
662      */
663     function getBorrowRate(uint cash, uint borrows, uint reserves) external  view returns (uint) {
664         return getBorrowRateInternal(cash, borrows, reserves);
665     }
666 
667     constructor(uint baseRatePerYear, uint multiplierPerYear, uint jumpMultiplierPerYear, uint kink_, address owner_)
668     	BaseJumpRateModelV2(baseRatePerYear,multiplierPerYear,jumpMultiplierPerYear,kink_,owner_) public {}
669 }
670 
671 // File: contracts\compound\CarefulMath.sol
672 
673 pragma solidity ^0.6.0;
674 
675 /**
676   * @title Careful Math
677   * @author Compound
678 
679 /blob/master/contracts/math/SafeMath.sol
680   */
681 contract CarefulMath {
682 
683     /**
684      * @dev Possible error codes that we can return
685      */
686     enum MathError {
687         NO_ERROR,
688         DIVISION_BY_ZERO,
689         INTEGER_OVERFLOW,
690         INTEGER_UNDERFLOW
691     }
692 
693     /**
694     * @dev Multiplies two numbers, returns an error on overflow.
695     */
696     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
697         if (a == 0) {
698             return (MathError.NO_ERROR, 0);
699         }
700 
701         uint c = a * b;
702 
703         if (c / a != b) {
704             return (MathError.INTEGER_OVERFLOW, 0);
705         } else {
706             return (MathError.NO_ERROR, c);
707         }
708     }
709 
710     /**
711     * @dev Integer division of two numbers, truncating the quotient.
712     */
713     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
714         if (b == 0) {
715             return (MathError.DIVISION_BY_ZERO, 0);
716         }
717 
718         return (MathError.NO_ERROR, a / b);
719     }
720 
721     /**
722     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
723     */
724     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
725         if (b <= a) {
726             return (MathError.NO_ERROR, a - b);
727         } else {
728             return (MathError.INTEGER_UNDERFLOW, 0);
729         }
730     }
731 
732     /**
733     * @dev Adds two numbers, returns an error on overflow.
734     */
735     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
736         uint c = a + b;
737 
738         if (c >= a) {
739             return (MathError.NO_ERROR, c);
740         } else {
741             return (MathError.INTEGER_OVERFLOW, 0);
742         }
743     }
744 
745     /**
746     * @dev add a and b and then subtract c
747     */
748     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
749         (MathError err0, uint sum) = addUInt(a, b);
750 
751         if (err0 != MathError.NO_ERROR) {
752             return (err0, 0);
753         }
754 
755         return subUInt(sum, c);
756     }
757 }
758 
759 // File: contracts\compound\Exponential.sol
760 
761 pragma solidity ^0.6.0;
762 
763 
764 /**
765  * @title Exponential module for storing fixed-precision decimals
766  * @author Compound
767  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
768  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
769  *         `Exp({mantissa: 5100000000000000000})`.
770  */
771 contract Exponential is CarefulMath {
772     uint constant expScale = 1e18;
773     uint constant doubleScale = 1e36;
774     uint constant halfExpScale = expScale/2;
775     uint constant mantissaOne = expScale;
776 
777     struct Exp {
778         uint mantissa;
779     }
780 
781     struct Double {
782         uint mantissa;
783     }
784 
785     /**
786      * @dev Creates an exponential from numerator and denominator values.
787      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
788      *            or if `denom` is zero.
789      */
790     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
791         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
792         if (err0 != MathError.NO_ERROR) {
793             return (err0, Exp({mantissa: 0}));
794         }
795 
796         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
797         if (err1 != MathError.NO_ERROR) {
798             return (err1, Exp({mantissa: 0}));
799         }
800 
801         return (MathError.NO_ERROR, Exp({mantissa: rational}));
802     }
803 
804     /**
805      * @dev Adds two exponentials, returning a new exponential.
806      */
807     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
808         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
809 
810         return (error, Exp({mantissa: result}));
811     }
812 
813     /**
814      * @dev Subtracts two exponentials, returning a new exponential.
815      */
816     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
817         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
818 
819         return (error, Exp({mantissa: result}));
820     }
821 
822     /**
823      * @dev Multiply an Exp by a scalar, returning a new Exp.
824      */
825     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
826         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
827         if (err0 != MathError.NO_ERROR) {
828             return (err0, Exp({mantissa: 0}));
829         }
830 
831         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
832     }
833 
834     /**
835      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
836      */
837     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
838         (MathError err, Exp memory product) = mulScalar(a, scalar);
839         if (err != MathError.NO_ERROR) {
840             return (err, 0);
841         }
842 
843         return (MathError.NO_ERROR, truncate(product));
844     }
845 
846     /**
847      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
848      */
849     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
850         (MathError err, Exp memory product) = mulScalar(a, scalar);
851         if (err != MathError.NO_ERROR) {
852             return (err, 0);
853         }
854 
855         return addUInt(truncate(product), addend);
856     }
857 
858     /**
859      * @dev Divide an Exp by a scalar, returning a new Exp.
860      */
861     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
862         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
863         if (err0 != MathError.NO_ERROR) {
864             return (err0, Exp({mantissa: 0}));
865         }
866 
867         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
868     }
869 
870     /**
871      * @dev Divide a scalar by an Exp, returning a new Exp.
872      */
873     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
874         /*
875           We are doing this as:
876           getExp(mulUInt(expScale, scalar), divisor.mantissa)
877 
878           How it works:
879           Exp = a / b;
880           Scalar = s;
881           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
882         */
883         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
884         if (err0 != MathError.NO_ERROR) {
885             return (err0, Exp({mantissa: 0}));
886         }
887         return getExp(numerator, divisor.mantissa);
888     }
889 
890     /**
891      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
892      */
893     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
894         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
895         if (err != MathError.NO_ERROR) {
896             return (err, 0);
897         }
898 
899         return (MathError.NO_ERROR, truncate(fraction));
900     }
901 
902     /**
903      * @dev Multiplies two exponentials, returning a new exponential.
904      */
905     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
906 
907         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
908         if (err0 != MathError.NO_ERROR) {
909             return (err0, Exp({mantissa: 0}));
910         }
911 
912         // We add half the scale before dividing so that we get rounding instead of truncation.
913         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
914         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
915         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
916         if (err1 != MathError.NO_ERROR) {
917             return (err1, Exp({mantissa: 0}));
918         }
919 
920         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
921         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
922         assert(err2 == MathError.NO_ERROR);
923 
924         return (MathError.NO_ERROR, Exp({mantissa: product}));
925     }
926 
927     /**
928      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
929      */
930     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
931         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
932     }
933 
934     /**
935      * @dev Multiplies three exponentials, returning a new exponential.
936      */
937     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
938         (MathError err, Exp memory ab) = mulExp(a, b);
939         if (err != MathError.NO_ERROR) {
940             return (err, ab);
941         }
942         return mulExp(ab, c);
943     }
944 
945     /**
946      * @dev Divides two exponentials, returning a new exponential.
947      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
948      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
949      */
950     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
951         return getExp(a.mantissa, b.mantissa);
952     }
953 
954     /**
955      * @dev Truncates the given exp to a whole number value.
956      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
957      */
958     function truncate(Exp memory exp) pure internal returns (uint) {
959         // Note: We are not using careful math here as we're performing a division that cannot fail
960         return exp.mantissa / expScale;
961     }
962 
963     /**
964      * @dev Checks if first Exp is less than second Exp.
965      */
966     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
967         return left.mantissa < right.mantissa;
968     }
969 
970     /**
971      * @dev Checks if left Exp <= right Exp.
972      */
973     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
974         return left.mantissa <= right.mantissa;
975     }
976 
977     /**
978      * @dev Checks if left Exp > right Exp.
979      */
980     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
981         return left.mantissa > right.mantissa;
982     }
983 
984     /**
985      * @dev returns true if Exp is exactly zero
986      */
987     function isZeroExp(Exp memory value) pure internal returns (bool) {
988         return value.mantissa == 0;
989     }
990 
991     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
992         require(n < 2**224, errorMessage);
993         return uint224(n);
994     }
995 
996     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
997         require(n < 2**32, errorMessage);
998         return uint32(n);
999     }
1000 
1001     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1002         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
1003     }
1004 
1005     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
1006         return Double({mantissa: add_(a.mantissa, b.mantissa)});
1007     }
1008 
1009     function add_(uint a, uint b) pure internal returns (uint) {
1010         return add_(a, b, "addition overflow");
1011     }
1012 
1013     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1014         uint c = a + b;
1015         require(c >= a, errorMessage);
1016         return c;
1017     }
1018 
1019     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1020         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
1021     }
1022 
1023     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
1024         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
1025     }
1026 
1027     function sub_(uint a, uint b) pure internal returns (uint) {
1028         return sub_(a, b, "subtraction underflow");
1029     }
1030 
1031     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1032         require(b <= a, errorMessage);
1033         return a - b;
1034     }
1035 
1036     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1037         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
1038     }
1039 
1040     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
1041         return Exp({mantissa: mul_(a.mantissa, b)});
1042     }
1043 
1044     function mul_(uint a, Exp memory b) pure internal returns (uint) {
1045         return mul_(a, b.mantissa) / expScale;
1046     }
1047 
1048     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
1049         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
1050     }
1051 
1052     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
1053         return Double({mantissa: mul_(a.mantissa, b)});
1054     }
1055 
1056     function mul_(uint a, Double memory b) pure internal returns (uint) {
1057         return mul_(a, b.mantissa) / doubleScale;
1058     }
1059 
1060     function mul_(uint a, uint b) pure internal returns (uint) {
1061         return mul_(a, b, "multiplication overflow");
1062     }
1063 
1064     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1065         if (a == 0 || b == 0) {
1066             return 0;
1067         }
1068         uint c = a * b;
1069         require(c / a == b, errorMessage);
1070         return c;
1071     }
1072 
1073     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1074         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
1075     }
1076 
1077     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
1078         return Exp({mantissa: div_(a.mantissa, b)});
1079     }
1080 
1081     function div_(uint a, Exp memory b) pure internal returns (uint) {
1082         return div_(mul_(a, expScale), b.mantissa);
1083     }
1084 
1085     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
1086         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
1087     }
1088 
1089     function div_(Double memory a, uint b) pure internal returns (Double memory) {
1090         return Double({mantissa: div_(a.mantissa, b)});
1091     }
1092 
1093     function div_(uint a, Double memory b) pure internal returns (uint) {
1094         return div_(mul_(a, doubleScale), b.mantissa);
1095     }
1096 
1097     function div_(uint a, uint b) pure internal returns (uint) {
1098         return div_(a, b, "divide by zero");
1099     }
1100 
1101     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1102         require(b > 0, errorMessage);
1103         return a / b;
1104     }
1105 
1106     function fraction(uint a, uint b) pure internal returns (Double memory) {
1107         return Double({mantissa: div_(mul_(a, doubleScale), b)});
1108     }
1109 }
1110 
1111 // File: contracts\WarpControl.sol
1112 
1113 pragma solidity ^0.6.0;
1114 
1115 
1116 
1117 
1118 
1119 
1120 
1121 
1122 
1123 
1124 ////////////////////////////////////////////////////////////////////////////////////////////
1125 /// @title WarpControl
1126 /// @author Christopher Dixon
1127 ////////////////////////////////////////////////////////////////////////////////////////////
1128 /**
1129 WarpControl is designed to coordinate Warp Vaults
1130 This contract uses the OpenZeppelin contract Library to inherit functions from
1131   Ownable.sol
1132 **/
1133 
1134 contract WarpControl is Ownable, Exponential {
1135     using SafeMath for uint256;
1136 
1137     UniswapLPOracleFactoryI public Oracle; //oracle factory contract interface
1138     WarpVaultLPFactoryI public WVLPF;
1139     WarpVaultSCFactoryI public WVSCF;
1140     address public warpTeam;
1141     address public newWarpControl;
1142     uint public graceSpace;
1143 
1144     address[] public lpVaults;
1145     address[] public scVaults;
1146     address[] public launchParticipants;
1147     address[] public groups;
1148 
1149     mapping(address => address) public instanceLPTracker; //maps LP token address to the assets WarpVault
1150     mapping(address => address) public instanceSCTracker;
1151     mapping(address => address) public getVaultByAsset;
1152     mapping(address => uint) public lockedLPValue;
1153     mapping(address => bool) public isVault;
1154     mapping(address => address[]) public refferalCodeTracker;
1155     mapping(address => string) public refferalCodeToGroupName;
1156     mapping(address => bool) public isParticipant;
1157     mapping(address => bool) public existingRefferalCode;
1158     mapping(address => bool) public isInGroup;
1159     mapping(address => address) public groupsYourIn;
1160 
1161     event NewLPVault(address _newVault);
1162     event NewSCVault(address _newVault, address _interestRateModel);
1163     event NewBorrow(address _borrower, address _StableCoin, uint _amountBorrowed);
1164     event NotCompliant(address _account, uint _time);
1165     event Liquidation(address _account, address liquidator);
1166     event complianceReset(address _account, uint _time);
1167     /**
1168       @dev Throws if called by any account other than a warp vault
1169      */
1170     modifier onlyVault() {
1171         require(isVault[msg.sender] == true);
1172         _;
1173     }
1174 
1175     /**
1176     @dev Throws if a function is called by anyone but the warp team
1177     **/
1178     modifier onlyWarpT() {
1179         require(msg.sender == warpTeam);
1180         _;
1181     }
1182 
1183     /**
1184     @notice the constructor function is fired during the contract deployment process. The constructor can only be fired once and
1185             is used to set up Oracle variables for the MoneyMarketFactory contract.
1186     @param _oracle is the address for the UniswapOracleFactorycontract
1187     @param _WVLPF is the address for the WarpVaultLPFactory used to produce LP Warp Vaults
1188     @param _WVSCF is the address for the WarpVaultSCFactory used to produce Stable Coin Warp Vaults
1189     @dev These factories are split into seperate contracts to avoid hitting the block gas limit
1190     **/
1191     constructor(
1192         address _oracle,
1193         address _WVLPF,
1194         address _WVSCF,
1195         address _warpTeam
1196     ) public {
1197         //instantiate the contracts
1198         Oracle = UniswapLPOracleFactoryI(_oracle);
1199         WVLPF = WarpVaultLPFactoryI(_WVLPF);
1200         WVSCF = WarpVaultSCFactoryI(_WVSCF);
1201         warpTeam = _warpTeam;
1202     }
1203 ///view functions for front end /////
1204 
1205   /**
1206   @notice viewNumLPVaults returns the number of lp vaults on the warp platform
1207   **/
1208     function viewNumLPVaults() external view returns(uint256) {
1209         return lpVaults.length;
1210     }
1211 
1212   /**
1213   @notice viewNumSCVaults returns the number of stablecoin vaults on the warp platform
1214   **/
1215     function viewNumSCVaults() external view returns(uint256) {
1216         return scVaults.length;
1217     }
1218 
1219   /**
1220   @notice viewLaunchParticipants returns an array of all launch participant addresses
1221   **/
1222     function viewLaunchParticipants() public view returns(address[] memory) {
1223       return launchParticipants;
1224     }
1225 
1226   /**
1227   @notice viewAllGroups returns an array of all group addresses
1228   **/
1229     function viewAllGroups() public view returns(address[] memory) {
1230       return groups;
1231     }
1232 
1233   /**
1234   @notice viewAllMembersOfAGroup returns an array of addresses containing the addresses of every member in a group
1235   @param _refferalCode is the address that acts as a referral code for a group
1236   **/
1237     function viewAllMembersOfAGroup(address _refferalCode) public view returns(address[] memory) {
1238       return refferalCodeTracker[_refferalCode];
1239     }
1240 
1241   /**
1242   @notice getGroupName returns the name of a group
1243   @param _refferalCode is the address that acts as a referral code for a group
1244   **/
1245     function getGroupName(address _refferalCode) public view returns(string memory) {
1246       return refferalCodeToGroupName[_refferalCode];
1247     }
1248 
1249   /**
1250   @notice getAccountsGroup returns the refferal code address of the team an account is on
1251   @param _account is the address whos team is being retrieved
1252   **/
1253     function getAccountsGroup(address _account) public view returns(address) {
1254       return groupsYourIn[_account];
1255     }
1256 
1257 
1258     /**
1259     @notice createNewLPVault allows the contract owner to create a new WarpVaultLP contract for a specific LP token
1260     @param _timelock is a variable representing the number of seconds the timeWizard will prevent withdraws and borrows from a contracts(one week is 605800 seconds)
1261     @param _lp is the address for the LP token this Warp Vault will manage
1262     @param _lpAsset1 is the address for the first asset in a pair that the LP token represents(ex: wETH in a wETH-wBTC uniswap pair)
1263     @param _lpAsset2 is the address for the second asset in a pair that the LP token represents(ex: wBTC in a wETH-wBTC uniswap pair)
1264     @param _lpName is the name of the LP token (ex:wETH-wBTC)
1265     **/
1266     function createNewLPVault(
1267         uint256 _timelock,
1268         address _lp,
1269         address _lpAsset1,
1270         address _lpAsset2,
1271         string memory _lpName
1272     ) public onlyOwner {
1273         //create new oracles for this LP
1274         Oracle.createNewOracles(_lpAsset1, _lpAsset2, _lp);
1275         //create new Warp LP Vault
1276         address _WarpVault = WVLPF.createWarpVaultLP(_timelock, _lp, _lpName);
1277         //track the warp vault lp instance by the address of the LP it represents
1278         instanceLPTracker[_lp] = _WarpVault;
1279         //add new LP Vault to the array of all LP vaults
1280         lpVaults.push(_WarpVault);
1281         //set Warp vault address as an approved vault
1282         isVault[_WarpVault] = true;
1283         //track vault to asset
1284         getVaultByAsset[_WarpVault] = _lp;
1285         emit NewLPVault(_WarpVault);
1286     }
1287 
1288     /**
1289     @notice createNewSCVault allows the contract owner to create a new WarpVaultLP contract for a specific LP token
1290     @param _timelock is a variable representing the number of seconds the timeWizard will prevent withdraws and borrows from a contracts(one week is 605800 seconds)
1291     @param _baseRatePerYear is the base rate per year(approx target base APR)
1292     @param _multiplierPerYear is the multiplier per year(rate of increase in interest w/ utilizastion)
1293     @param _jumpMultiplierPerYear is the Jump Multiplier Per Year(the multiplier per block after hitting a specific utilizastion point)
1294     @param _optimal is the this is the utilizastion point or "kink" at which the jump multiplier is applied
1295     @param _initialExchangeRate is the intitial exchange rate(the rate at which the initial exchange of asset/ART is set)
1296     @param _StableCoin is the address of the StableCoin this Warp Vault will manage
1297     **/
1298     function createNewSCVault(
1299         uint256 _timelock,
1300         uint256 _baseRatePerYear,
1301         uint256 _multiplierPerYear,
1302         uint256 _jumpMultiplierPerYear,
1303         uint256 _optimal,
1304         uint256 _initialExchangeRate,
1305         uint256 _reserveFactorMantissa,
1306         address _StableCoin
1307     ) public onlyOwner {
1308         //create the interest rate model for this stablecoin
1309         address IR = address(
1310             new JumpRateModelV2(
1311                 _baseRatePerYear,
1312                 _multiplierPerYear,
1313                 _jumpMultiplierPerYear,
1314                 _optimal,
1315                 address(this)
1316             )
1317         );
1318         //create the SC Warp vault
1319         address _WarpVault = WVSCF.createNewWarpVaultSC(
1320             IR,
1321             _StableCoin,
1322             warpTeam,
1323             _initialExchangeRate,
1324             _timelock,
1325             _reserveFactorMantissa
1326         );
1327         //track the warp vault sc instance by the address of the stablecoin it represents
1328         instanceSCTracker[_StableCoin] = _WarpVault;
1329         //add new SC Vault to the array of all SC vaults
1330         scVaults.push(_WarpVault);
1331         //set Warp vault address as an approved vault
1332         isVault[_WarpVault] = true;
1333         //track vault to asset
1334         getVaultByAsset[_WarpVault] = _StableCoin;
1335         emit NewSCVault(_WarpVault, IR);
1336     }
1337 
1338     /**
1339     @notice @createGroup is used to create a new group
1340     @param _groupName is the name of the group being created
1341     @dev the refferal code for this group is the address of the msg.sender
1342     **/
1343     function createGroup(string memory _groupName) public {
1344         require(isInGroup[msg.sender] == false, "Cant create a group once already in one");
1345 
1346         // Create group
1347         existingRefferalCode[msg.sender] = true;
1348         refferalCodeToGroupName[msg.sender] = _groupName;
1349         groups.push(msg.sender);
1350 
1351         // Join Group
1352         refferalCodeTracker[msg.sender].push(msg.sender);
1353         isInGroup[msg.sender] = true;
1354         groupsYourIn[msg.sender] = msg.sender;
1355 
1356         launchParticipants.push(msg.sender);
1357     }
1358 
1359     /**
1360     @notice addMemberToGroup is used to add an account to a group
1361     @param _refferalCode is the address used as a groups refferal code
1362     @dev the member being added is the msg.sender
1363     **/
1364     function addMemberToGroup(address _refferalCode) public {
1365         //Require a member is either not in a group OR has entered their groups refferal code
1366         require(isInGroup[msg.sender] == false, "Cant join more than one group");
1367         require(existingRefferalCode[_refferalCode] == true, "Group doesn't exist.");
1368 
1369         // Join Group
1370         refferalCodeTracker[_refferalCode].push(msg.sender);
1371         isInGroup[msg.sender] = true;
1372         groupsYourIn[msg.sender] = _refferalCode;
1373 
1374         launchParticipants.push(msg.sender);
1375     }
1376 
1377 
1378 
1379 
1380     /**
1381     @notice Figures out how much of a given LP token an account is allowed to withdraw
1382     @param account is the account being checked
1383     @param lpToken is the address of the lpToken the user wishes to withdraw
1384     @dev this function runs calculations to accrue interest for an up to date amount
1385      */
1386     function getMaxWithdrawAllowed(address account, address lpToken) public returns (uint256) {
1387         uint256 borrowedTotal = getTotalBorrowedValue(account);
1388         uint256 collateralValue = getTotalAvailableCollateralValue(account);
1389         uint256 requiredCollateral = calcCollateralRequired(borrowedTotal);
1390         uint256 leftoverCollateral = collateralValue.sub(requiredCollateral);
1391         uint256 lpValue = Oracle.getUnderlyingPrice(lpToken);
1392         return leftoverCollateral.mul(1e18).div(lpValue);
1393     }
1394 
1395     /**
1396     @notice Figures out how much of a given LP token an account is allowed to withdraw
1397     @param account is the account being checked
1398     @param lpToken is the address of the lpToken the user wishes to withdraw
1399     @dev this function does not run calculations to accrue interest and returns the previously calculated amount
1400      */
1401     function viewMaxWithdrawAllowed(address account, address lpToken) public view returns (uint256) {
1402         uint256 borrowedTotal = viewTotalBorrowedValue(account);
1403         uint256 collateralValue = viewTotalAvailableCollateralValue(account);
1404         uint256 requiredCollateral = calcCollateralRequired(borrowedTotal);
1405         uint256 leftoverCollateral = collateralValue.sub(requiredCollateral);
1406         uint256 lpValue = Oracle.viewUnderlyingPrice(lpToken);
1407         return leftoverCollateral.mul(1e18).div(lpValue);
1408     }
1409 
1410     /**
1411     @notice getTotalAvailableCollateralValue returns the total availible collaeral value for an account in USDC
1412     @param _account is the address whos collateral is being retreived
1413     @dev this function runs calculations to accrue interest for an up to date amount
1414     **/
1415     function getTotalAvailableCollateralValue(address _account)
1416         public
1417         returns (uint256)
1418     {
1419         //get the number of LP vaults the platform has
1420         uint256 numVaults = lpVaults.length;
1421         //initialize the totalCollateral variable to zero
1422         uint256 totalCollateral = 0;
1423         //loop through each lp wapr vault
1424         for (uint256 i = 0; i < numVaults; ++i) {
1425             //instantiate warp vault at that position
1426             WarpVaultLPI vault = WarpVaultLPI(lpVaults[i]);
1427             //retreive the address of its asset
1428             address asset = vault.getAssetAdd();
1429             //retrieve USD price of this asset
1430             uint256 assetPrice = Oracle.getUnderlyingPrice(asset);
1431 
1432             uint256 accountCollateral = vault.collateralOfAccount(_account);
1433             //emit DebugValues(accountCollateral, assetPrice);
1434 
1435             //multiply the amount of collateral by the asset price and return it
1436             uint256 accountAssetsValue = accountCollateral.mul(assetPrice);
1437             //add value to total collateral
1438             totalCollateral = totalCollateral.add(accountAssetsValue);
1439         }
1440         //return total USDC value of all collateral
1441         return totalCollateral.div(1e18);
1442     }
1443 
1444     /**
1445     @notice getTotalAvailableCollateralValue returns the total availible collaeral value for an account in USDC
1446     @param _account is the address whos collateral is being retreived
1447     @dev this function does not run calculations to accrue interest and returns the previously calculated amount
1448     **/
1449     function viewTotalAvailableCollateralValue(address _account)
1450         public
1451         view
1452         returns (uint256)
1453     {
1454         uint256 numVaults = lpVaults.length;
1455         uint256 totalCollateral = 0;
1456         //loop through each lp wapr vault
1457         for (uint256 i = 0; i < numVaults; ++i) {
1458             //instantiate warp vault at that position
1459             WarpVaultLPI vault = WarpVaultLPI(lpVaults[i]);
1460             //retreive the address of its asset
1461             address asset = vault.getAssetAdd();
1462             //retrieve USD price of this asset
1463             uint256 assetPrice = Oracle.viewUnderlyingPrice(asset);
1464 
1465             uint256 accountCollateral = vault.collateralOfAccount(_account);
1466 
1467             //multiply the amount of collateral by the asset price and return it
1468             uint256 accountAssetsValue = accountCollateral.mul(assetPrice);
1469             //add value to total collateral
1470             totalCollateral = totalCollateral.add(accountAssetsValue);
1471         }
1472         //return total USDC value of all collateral
1473         return totalCollateral.div(1e18);
1474     }
1475 
1476     /**
1477     @notice viewPriceOfCollateral returns the price of an lpToken
1478     @param lpToken is the address of the lp token
1479     @dev this function runs calculations to retrieve the current price
1480     **/
1481     function viewPriceOfCollateral(address lpToken) public view returns(uint256)
1482     {
1483         return Oracle.viewUnderlyingPrice(lpToken);
1484     }
1485 
1486     /**
1487     @notice getPriceOfCollateral returns the price of an lpToken
1488     @param lpToken is the address of the lp token
1489     @dev this function does not run calculations amd returns the previously calculated price
1490     **/
1491     function getPriceOfCollateral(address lpToken) public returns(uint256)
1492     {
1493         return Oracle.getUnderlyingPrice(lpToken);
1494     }
1495 
1496     /**
1497     @notice viewPriceOfToken retrieves the price of a stablecoin
1498     @param token is the address of the stablecoin
1499     @param amount is the amount of stablecoin
1500     @dev this function runs calculations to retrieve the current price
1501     **/
1502     function viewPriceOfToken(address token, uint256 amount) public view returns(uint256)
1503     {
1504         return Oracle.viewPriceOfToken(token, amount);
1505     }
1506 
1507     /**
1508     @notice viewPriceOfToken retrieves the price of a stablecoin
1509     @param token is the address of the stablecoin
1510     @param amount is the amount of stablecoin
1511     @dev this function does not run calculations amd returns the previously calculated price
1512     **/
1513     function getPriceOfToken(address token, uint256 amount) public returns(uint256)
1514     {
1515         return Oracle.getPriceOfToken(token, amount);
1516     }
1517 
1518     /**
1519     @notice viewTotalBorrowedValue returns the total borrowed value for an account in USDC
1520     @param _account is the account whos borrowed value we are calculating
1521     @dev this function returns previously calculated values
1522     **/
1523     function viewTotalBorrowedValue(address _account) public view returns (uint256) {
1524         uint256 numSCVaults = scVaults.length;
1525         //initialize the totalBorrowedValue variable to zero
1526         uint256 totalBorrowedValue = 0;
1527         //loop through all stable coin vaults
1528         for (uint256 i = 0; i < numSCVaults; ++i) {
1529             //instantiate each LP warp vault
1530             WarpVaultSCI WVSC = WarpVaultSCI(scVaults[i]);
1531             //retreive the amount user has borrowed from each stablecoin vault
1532             uint256 borrowBalanceInStable = WVSC.borrowBalancePrior(_account);
1533             if (borrowBalanceInStable == 0) {
1534                 continue;
1535             }
1536             uint256 usdcBorrowedAmount = viewPriceOfToken(WVSC.getSCAddress(), borrowBalanceInStable);
1537             totalBorrowedValue = totalBorrowedValue.add(
1538                 usdcBorrowedAmount
1539             );
1540         }
1541         //return total Borrowed Value
1542         return totalBorrowedValue;
1543     }
1544 
1545     /**
1546     @notice viewTotalBorrowedValue returns the total borrowed value for an account in USDC
1547     @param _account is the account whos borrowed value we are calculating
1548     @dev this function returns newly calculated values
1549     **/
1550     function getTotalBorrowedValue(address _account) public returns (uint256) {
1551         uint256 numSCVaults = scVaults.length;
1552         //initialize the totalBorrowedValue variable to zero
1553         uint256 totalBorrowedValue = 0;
1554         //loop through all stable coin vaults
1555         for (uint256 i = 0; i < numSCVaults; ++i) {
1556             //instantiate each LP warp vault
1557             WarpVaultSCI WVSC = WarpVaultSCI(scVaults[i]);
1558             //retreive the amount user has borrowed from each stablecoin vault
1559             uint borrowBalanceInStable = WVSC.borrowBalanceCurrent(_account);
1560             if (borrowBalanceInStable == 0) {
1561                 continue;
1562             }
1563             uint256 usdcBorrowedAmount = getPriceOfToken(WVSC.getSCAddress(), borrowBalanceInStable);
1564             totalBorrowedValue = totalBorrowedValue.add(
1565                 usdcBorrowedAmount
1566             );
1567         }
1568         //return total Borrowed Value
1569         return totalBorrowedValue;
1570     }
1571 
1572     /**
1573     @notice calcBorrowLimit is used to calculate the borrow limit for an account based on the input value of their collateral
1574     @param _collateralValue is the USDC value of the users collateral
1575     @dev this function divides the input value by 3 and then adds that value to itself so it can return 2/3rds of the availible collateral
1576         as the borrow limit. If a usser has $150 USDC value in collateral this function will return $100 USDC as their borrow limit.
1577     **/
1578     function calcBorrowLimit(uint256 _collateralValue)
1579         public
1580         pure
1581         returns (uint256)
1582     {
1583         //divide the collaterals value by 3 to get 1/3rd of its value
1584         uint256 thirdCollatVal = _collateralValue.div(3);
1585         //add this 1/3rd value to itself to get 2/3rds of the original value
1586         return thirdCollatVal.add(thirdCollatVal);
1587     }
1588 
1589     /**
1590     @notice calcCollateralRequired returns the amount of collateral needed for an input borrow value
1591     @param _borrowAmount is the input borrow amount
1592     **/
1593     function calcCollateralRequired(uint256 _borrowAmount) public pure returns (uint256) {
1594         return _borrowAmount.mul(3).div(2);
1595     }
1596 
1597     /**
1598     @notice getBorrowLimit returns the borrow limit for an account
1599     @param _account is the input account address
1600     @dev this calculation uses current values for calculations
1601     **/
1602     function getBorrowLimit(address _account) public returns (uint256) {
1603         uint256 availibleCollateralValue = getTotalAvailableCollateralValue(
1604             _account
1605         );
1606 
1607         return calcBorrowLimit(availibleCollateralValue);
1608     }
1609 
1610     /**
1611     @notice getBorrowLimit returns the borrow limit for an account
1612     @param _account is the input account address
1613     @dev this calculation uses previous values for calculations
1614     **/
1615     function viewBorrowLimit(address _account) public view returns (uint256) {
1616         uint256 availibleCollateralValue = viewTotalAvailableCollateralValue(
1617             _account
1618         );
1619         //return the users borrow limit
1620         return calcBorrowLimit(availibleCollateralValue);
1621     }
1622 
1623     /**
1624     @notice borrowSC is the function an end user will call when they wish to borrow a stablecoin from the warp platform
1625     @param _StableCoin is the address of the stablecoin the user wishes to borrow
1626     @param _amount is the amount of that stablecoin the user wants to borrow
1627     **/
1628     function borrowSC(address _StableCoin, uint256 _amount) public {
1629         uint256 borrowedTotalInUSDC = getTotalBorrowedValue(msg.sender);
1630         uint256 borrowLimitInUSDC = getBorrowLimit(msg.sender);
1631         uint256 borrowAmountAllowedInUSDC = borrowLimitInUSDC.sub(borrowedTotalInUSDC);
1632 
1633         uint256 borrowAmountInUSDC = getPriceOfToken(_StableCoin, _amount);
1634 
1635         //require the amount being borrowed is less than or equal to the amount they are aloud to borrow
1636         require(borrowAmountAllowedInUSDC >= borrowAmountInUSDC, "Borrowing more than allowed");
1637         //track USDC value of locked LP
1638         lockedLPValue[msg.sender] = lockedLPValue[msg.sender].add(_amount);
1639         //retreive stablecoin vault address being borrowed from and instantiate it
1640         WarpVaultSCI WV = WarpVaultSCI(instanceSCTracker[_StableCoin]);
1641         //call _borrow function on the stablecoin warp vault
1642         WV._borrow(_amount, msg.sender);
1643         emit NewBorrow(msg.sender, _StableCoin, _amount);
1644     }
1645 
1646 
1647 
1648     /**
1649     @notice liquidateAccount is used to liquidate a non-compliant loan after it has reached its 30 minute grace period
1650     @param _borrower is the address of the borrower whos loan is non-compliant
1651     **/
1652     function liquidateAccount(address _borrower) public {
1653          //require the liquidator is not also the borrower
1654         require(msg.sender != _borrower, "you cant liquidate yourself");
1655         //retreive the number of stablecoin vaults in the warp platform
1656         uint256 numSCVaults = scVaults.length;
1657         //retreive the number of LP vaults in the warp platform
1658         uint256 numLPVaults = lpVaults.length;
1659         // This is how much USDC worth of Stablecoin the user has borrowed
1660         uint256 borrowedAmount = 0;
1661         //initialize the stable coin balances array
1662         uint256[] memory scBalances = new uint256[](numSCVaults);
1663         // loop through and retreive the Borrowed Amount From All Vaults
1664         for (uint256 i = 0; i < numSCVaults; ++i) {
1665             //instantiate the vault at the current  position in the array
1666             WarpVaultSCI scVault = WarpVaultSCI(scVaults[i]);
1667             //retreive the borrowers borrow balance from this vault and add it to the scBalances array
1668             scBalances[i] = scVault.borrowBalanceCurrent(_borrower);
1669             uint256 borrowedAmountInUSDC = viewPriceOfToken(getVaultByAsset[address(scVault)], scBalances[i]);
1670 
1671             //add the borrowed amount to the total borrowed balance
1672             borrowedAmount = borrowedAmount.add(borrowedAmountInUSDC);
1673         }
1674         //retreve the USDC borrow limit for the borrower
1675         uint256 borrowLimit = getBorrowLimit(_borrower);
1676         //check if the borrow is less than the borrowed amount
1677         if (borrowLimit <= borrowedAmount) {
1678             // If it is Liquidate the account
1679             //loop through each SC vault so the  Liquidator can pay off Stable Coin loans
1680             for (uint256 i = 0; i < numSCVaults; ++i) {
1681                 //instantiate the Warp SC Vault at the current position
1682                 WarpVaultSCI scVault = WarpVaultSCI(scVaults[i]);
1683                 //call repayLiquidatedLoan function to repay the loan
1684                 scVault._repayLiquidatedLoan(
1685                     _borrower,
1686                     msg.sender,
1687                     scBalances[i]
1688                 );
1689             }
1690             //loop through each LP vault so the Liquidator gets the LP tokens the borrower had
1691             for (uint256 i = 0; i < numLPVaults; ++i) {
1692                 //instantiate the Warp LP Vault at the current position
1693                 WarpVaultLPI lpVault = WarpVaultLPI(lpVaults[i]);
1694                 //call liquidateAccount function on that LP vault
1695                 lpVault._liquidateAccount(_borrower, msg.sender);
1696             }
1697             emit Liquidation(_borrower, msg.sender);
1698         }
1699     }
1700 
1701     /**
1702     @notice updateInterestRateModel allows the warp team to update the interest rate model for a stablecoin
1703     @param _token is the address of the stablecoin whos vault is having its interest rate updated
1704     @param _baseRatePerYear is the base rate per year(approx target base APR)
1705     @param _multiplierPerYear is the multiplier per year(rate of increase in interest w/ utilizastion)
1706     @param _jumpMultiplierPerYear is the Jump Multiplier Per Year(the multiplier per block after hitting a specific utilizastion point)
1707     @param _optimal is the this is the utilizastion point or "kink" at which the jump multiplier is applied
1708     **/
1709     function updateInterestRateModel(
1710         address _token,
1711         uint256 _baseRatePerYear,
1712         uint256 _multiplierPerYear,
1713         uint256 _jumpMultiplierPerYear,
1714         uint256 _optimal
1715       ) public onlyWarpT {
1716       address IR = address(
1717           new JumpRateModelV2(
1718               _baseRatePerYear,
1719               _multiplierPerYear,
1720               _jumpMultiplierPerYear,
1721               _optimal,
1722               address(this)
1723           )
1724       );
1725       address vault = instanceSCTracker[_token];
1726       WarpVaultSCI WV = WarpVaultSCI(vault);
1727       WV.setNewInterestModel(IR);
1728     }
1729 
1730     /**
1731     @notice startUpgradeTimer starts a two day timer signaling that this contract will soon be updated to a new version
1732     @param _newWarpControl is the address of the new Warp control contract being upgraded to
1733     **/
1734     function startUpgradeTimer(address _newWarpControl) public onlyWarpT{
1735       newWarpControl = _newWarpControl;
1736       graceSpace = now.add(172800);
1737     }
1738 
1739     /**
1740     @notice upgradeWarp is used to upgrade the Warp platform to use a new version of the WarpControl contract
1741     **/
1742     function upgradeWarp() public onlyOwner {
1743       require(now >= graceSpace, "you cant ugrade yet, less than two days");
1744         uint256 numVaults = lpVaults.length;
1745         uint256 numSCVaults = scVaults.length;
1746       for (uint256 i = 0; i < numVaults; ++i) {
1747           WarpVaultLPI vault = WarpVaultLPI(lpVaults[i]);
1748           vault.upgrade(newWarpControl);
1749     }
1750 
1751       for (uint256 i = 0; i < numSCVaults; ++i) {
1752           WarpVaultSCI WVSC = WarpVaultSCI(scVaults[i]);
1753             WVSC.upgrade(newWarpControl);
1754         }
1755           WVLPF.transferOwnership(newWarpControl);
1756           WVSCF.transferOwnership(newWarpControl);
1757           Oracle.transferOwnership(newWarpControl);
1758   }
1759 
1760 /**
1761 @notice transferWarpTeam allows the wapr team address to be changed by the owner account
1762 @param _newWarp is the address of the new warp team
1763 **/
1764     function transferWarpTeam(address _newWarp) public onlyOwner {
1765         uint256 numSCVaults = scVaults.length;
1766         warpTeam = _newWarp;
1767         for (uint256 i = 0; i < numSCVaults; ++i) {
1768             WarpVaultSCI WVSC = WarpVaultSCI(scVaults[i]);
1769             WVSC.updateTeam(_newWarp);
1770         }
1771       
1772     }
1773 }