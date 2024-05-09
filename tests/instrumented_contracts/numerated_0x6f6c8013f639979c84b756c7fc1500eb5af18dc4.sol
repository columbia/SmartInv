1 // SPDX-License-Identifier:  AGPL-3.0-or-later // hevm: flattened sources of contracts/Pool.sol
2 pragma solidity =0.6.11 >=0.6.0 <0.8.0 >=0.6.2 <0.8.0;
3 
4 ////// contracts/interfaces/IBPool.sol
5 /* pragma solidity 0.6.11; */
6 
7 interface IBPool {
8 
9     function transfer(address, uint256) external returns (bool);
10 
11     function INIT_POOL_SUPPLY() external view returns (uint256);
12 
13     function MAX_OUT_RATIO() external view returns (uint256);
14 
15     function bind(address, uint256, uint256) external;
16 
17     function balanceOf(address) external view returns (uint256);
18 
19     function finalize() external;
20 
21     function gulp(address) external;
22 
23     function isFinalized() external view returns (bool);
24 
25     function isBound(address) external view returns (bool);
26 
27     function getNumTokens() external view returns (uint256);
28 
29     function getBalance(address) external view returns (uint256);
30 
31     function getNormalizedWeight(address) external view returns (uint256);
32 
33     function getDenormalizedWeight(address) external view returns (uint256);
34 
35     function getTotalDenormalizedWeight() external view returns (uint256);
36 
37     function getSwapFee() external view returns (uint256);
38 
39     function totalSupply() external view returns (uint256);
40 
41     function getFinalTokens() external view returns (address[] memory);
42 
43     function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external;
44 
45     function calcSingleOutGivenPoolIn(
46         uint256 tokenBalanceOut,
47         uint256 tokenWeightOut,
48         uint256 poolSupply,
49         uint256 totalWeight,
50         uint256 poolAmountIn,
51         uint256 swapFee
52     ) external pure returns (uint256);
53 
54     function calcPoolInGivenSingleOut(
55         uint256 tokenBalanceOut,
56         uint256 tokenWeightOut,
57         uint256 poolSupply,
58         uint256 totalWeight,
59         uint256 tokenAmountOut,
60         uint256 swapFee
61     ) external pure returns (uint256);
62 
63     function exitswapExternAmountOut(
64         address tokenOut,
65         uint256 tokenAmountOut,
66         uint256 maxPoolAmountIn
67     ) external returns (uint256 poolAmountIn);
68 
69 }
70 
71 ////// contracts/interfaces/IDebtLocker.sol
72 /* pragma solidity 0.6.11; */
73 
74 interface IDebtLocker {
75 
76     function loan() external view returns (address);
77 
78     function liquidityAsset() external view returns (address);
79 
80     function pool() external view returns (address);
81 
82     function lastPrincipalPaid() external view returns (uint256);
83 
84     function lastInterestPaid() external view returns (uint256);
85 
86     function lastFeePaid() external view returns (uint256);
87 
88     function lastExcessReturned() external view returns (uint256);
89 
90     function lastDefaultSuffered() external view returns (uint256);
91 
92     function lastAmountRecovered() external view returns (uint256);
93 
94     function claim() external returns (uint256[7] memory);
95     
96     function triggerDefault() external;
97 
98 }
99 
100 ////// contracts/interfaces/ILiquidityLocker.sol
101 /* pragma solidity 0.6.11; */
102 
103 interface ILiquidityLocker {
104 
105     function pool() external view returns (address);
106 
107     function liquidityAsset() external view returns (address);
108 
109     function transfer(address, uint256) external;
110 
111     function fundLoan(address, address, uint256) external;
112 
113 }
114 
115 ////// contracts/interfaces/ILiquidityLockerFactory.sol
116 /* pragma solidity 0.6.11; */
117 
118 interface ILiquidityLockerFactory {
119 
120     function owner(address) external view returns (address);
121     
122     function isLocker(address) external view returns (bool);
123 
124     function factoryType() external view returns (uint8);
125 
126     function newLocker(address) external returns (address);
127 
128 }
129 
130 ////// contracts/token/interfaces/IBaseFDT.sol
131 /* pragma solidity 0.6.11; */
132 
133 interface IBaseFDT {
134 
135     /**
136         @dev    Returns the total amount of funds a given address is able to withdraw currently.
137         @param  owner Address of FDT holder.
138         @return A uint256 representing the available funds for a given account.
139     */
140     function withdrawableFundsOf(address owner) external view returns (uint256);
141 
142     /**
143         @dev Withdraws all available funds for a FDT holder.
144     */
145     function withdrawFunds() external;
146 
147     /**
148         @dev   This event emits when new funds are distributed.
149         @param by               The address of the sender that distributed funds.
150         @param fundsDistributed The amount of funds received for distribution.
151     */
152     event FundsDistributed(address indexed by, uint256 fundsDistributed);
153 
154     /**
155         @dev   This event emits when distributed funds are withdrawn by a token holder.
156         @param by             The address of the receiver of funds.
157         @param fundsWithdrawn The amount of funds that were withdrawn.
158         @param totalWithdrawn The total amount of funds that were withdrawn.
159     */
160     event FundsWithdrawn(address indexed by, uint256 fundsWithdrawn, uint256 totalWithdrawn);
161 
162 }
163 
164 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
165 /* pragma solidity >=0.6.0 <0.8.0; */
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 ////// contracts/token/interfaces/IBasicFDT.sol
242 /* pragma solidity 0.6.11; */
243 
244 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
245 
246 /* import "./IBaseFDT.sol"; */
247 
248 interface IBasicFDT is IBaseFDT, IERC20 {
249 
250     event PointsPerShareUpdated(uint256);
251 
252     event PointsCorrectionUpdated(address indexed, int256);
253 
254     function withdrawnFundsOf(address) external view returns (uint256);
255 
256     function accumulativeFundsOf(address) external view returns (uint256);
257 
258     function updateFundsReceived() external;
259 
260 }
261 
262 ////// contracts/token/interfaces/ILoanFDT.sol
263 /* pragma solidity 0.6.11; */
264 
265 /* import "./IBasicFDT.sol"; */
266 
267 interface ILoanFDT is IBasicFDT {
268 
269     function fundsToken() external view returns (address);
270 
271     function fundsTokenBalance() external view returns (uint256);
272 
273 }
274 
275 ////// contracts/interfaces/ILoan.sol
276 /* pragma solidity 0.6.11; */
277 
278 /* import "../token/interfaces/ILoanFDT.sol"; */
279 
280 interface ILoan is ILoanFDT {
281     
282     // State Variables
283     function liquidityAsset() external view returns (address);
284     
285     function collateralAsset() external view returns (address);
286     
287     function fundingLocker() external view returns (address);
288     
289     function flFactory() external view returns (address);
290     
291     function collateralLocker() external view returns (address);
292     
293     function clFactory() external view returns (address);
294     
295     function borrower() external view returns (address);
296     
297     function repaymentCalc() external view returns (address);
298     
299     function lateFeeCalc() external view returns (address);
300     
301     function premiumCalc() external view returns (address);
302     
303     function loanState() external view returns (uint256);
304     
305     function collateralRequiredForDrawdown(uint256) external view returns (uint256);
306     
307 
308     // Loan Specifications
309     function apr() external view returns (uint256);
310     
311     function paymentsRemaining() external view returns (uint256);
312     
313     function paymentIntervalSeconds() external view returns (uint256);
314     
315     function requestAmount() external view returns (uint256);
316     
317     function collateralRatio() external view returns (uint256);
318     
319     function fundingPeriod() external view returns (uint256);
320 
321     function defaultGracePeriod() external view returns (uint256);
322     
323     function createdAt() external view returns (uint256);
324     
325     function principalOwed() external view returns (uint256);
326     
327     function principalPaid() external view returns (uint256);
328     
329     function interestPaid() external view returns (uint256);
330     
331     function feePaid() external view returns (uint256);
332     
333     function excessReturned() external view returns (uint256);
334     
335     function getNextPayment() external view returns (uint256, uint256, uint256, uint256);
336     
337     function superFactory() external view returns (address);
338     
339     function termDays() external view returns (uint256);
340     
341     function nextPaymentDue() external view returns (uint256);
342 
343     function getFullPayment() external view returns (uint256, uint256, uint256);
344     
345 
346     // Liquidations
347     function amountLiquidated() external view returns (uint256);
348 
349     function defaultSuffered() external view returns (uint256);
350     
351     function amountRecovered() external view returns (uint256);
352     
353     function getExpectedAmountRecovered() external view returns (uint256);
354 
355     function liquidationExcess() external view returns (uint256);
356     
357 
358     // Functions
359     function fundLoan(address, uint256) external;
360     
361     function makePayment() external;
362     
363     function drawdown(uint256) external;
364     
365     function makeFullPayment() external;
366     
367     function triggerDefault() external;
368     
369     function unwind() external;
370     
371 
372     // Security 
373     function pause() external;
374 
375     function unpause() external;
376 
377     function loanAdmins(address) external view returns (address);
378 
379     function setLoanAdmin(address, bool) external;
380 
381 
382     // Misc
383     function reclaimERC20(address) external;
384 
385 }
386 
387 ////// contracts/interfaces/ILoanFactory.sol
388 /* pragma solidity 0.6.11; */
389 
390 interface ILoanFactory {
391 
392     function CL_FACTORY() external view returns (uint8);
393 
394     function FL_FACTORY() external view returns (uint8);
395 
396     function INTEREST_CALC_TYPE() external view returns (uint8);
397 
398     function LATEFEE_CALC_TYPE() external view returns (uint8);
399 
400     function PREMIUM_CALC_TYPE() external view returns (uint8);
401 
402     function globals() external view returns (address);
403 
404     function loansCreated() external view returns (uint256);
405 
406     function loans(uint256) external view returns (address);
407 
408     function isLoan(address) external view returns (bool);
409 
410     function loanFactoryAdmins(address) external view returns (bool);
411 
412     function setGlobals(address) external;
413     
414     function createLoan(address, address, address, address, uint256[5] memory, address[3] memory) external returns (address);
415 
416     function setLoanFactoryAdmin(address, bool) external;
417 
418     function pause() external;
419 
420     function unpause() external;
421 
422 }
423 
424 ////// contracts/interfaces/IMapleGlobals.sol
425 /* pragma solidity 0.6.11; */
426 
427 interface IMapleGlobals {
428 
429     function pendingGovernor() external view returns (address);
430 
431     function governor() external view returns (address);
432 
433     function globalAdmin() external view returns (address);
434 
435     function mpl() external view returns (address);
436 
437     function mapleTreasury() external view returns (address);
438 
439     function isValidBalancerPool(address) external view returns (bool);
440 
441     function treasuryFee() external view returns (uint256);
442 
443     function investorFee() external view returns (uint256);
444 
445     function defaultGracePeriod() external view returns (uint256);
446 
447     function fundingPeriod() external view returns (uint256);
448 
449     function swapOutRequired() external view returns (uint256);
450 
451     function isValidLiquidityAsset(address) external view returns (bool);
452 
453     function isValidCollateralAsset(address) external view returns (bool);
454 
455     function isValidPoolDelegate(address) external view returns (bool);
456 
457     function validCalcs(address) external view returns (bool);
458 
459     function isValidCalc(address, uint8) external view returns (bool);
460 
461     function getLpCooldownParams() external view returns (uint256, uint256);
462 
463     function isValidLoanFactory(address) external view returns (bool);
464 
465     function isValidSubFactory(address, address, uint8) external view returns (bool);
466 
467     function isValidPoolFactory(address) external view returns (bool);
468     
469     function getLatestPrice(address) external view returns (uint256);
470     
471     function defaultUniswapPath(address, address) external view returns (address);
472 
473     function minLoanEquity() external view returns (uint256);
474     
475     function maxSwapSlippage() external view returns (uint256);
476 
477     function protocolPaused() external view returns (bool);
478 
479     function stakerCooldownPeriod() external view returns (uint256);
480 
481     function lpCooldownPeriod() external view returns (uint256);
482 
483     function stakerUnstakeWindow() external view returns (uint256);
484 
485     function lpWithdrawWindow() external view returns (uint256);
486 
487     function oracleFor(address) external view returns (address);
488 
489     function validSubFactories(address, address) external view returns (bool);
490 
491     function setStakerCooldownPeriod(uint256) external;
492 
493     function setLpCooldownPeriod(uint256) external;
494 
495     function setStakerUnstakeWindow(uint256) external;
496 
497     function setLpWithdrawWindow(uint256) external;
498 
499     function setMaxSwapSlippage(uint256) external;
500 
501     function setGlobalAdmin(address) external;
502 
503     function setValidBalancerPool(address, bool) external;
504 
505     function setProtocolPause(bool) external;
506 
507     function setValidPoolFactory(address, bool) external;
508 
509     function setValidLoanFactory(address, bool) external;
510 
511     function setValidSubFactory(address, address, bool) external;
512 
513     function setDefaultUniswapPath(address, address, address) external;
514 
515     function setPoolDelegateAllowlist(address, bool) external;
516 
517     function setCollateralAsset(address, bool) external;
518 
519     function setLiquidityAsset(address, bool) external;
520 
521     function setCalc(address, bool) external;
522 
523     function setInvestorFee(uint256) external;
524 
525     function setTreasuryFee(uint256) external;
526 
527     function setMapleTreasury(address) external;
528 
529     function setDefaultGracePeriod(uint256) external;
530 
531     function setMinLoanEquity(uint256) external;
532 
533     function setFundingPeriod(uint256) external;
534 
535     function setSwapOutRequired(uint256) external;
536 
537     function setPriceOracle(address, address) external;
538 
539     function setPendingGovernor(address) external;
540 
541     function acceptGovernor() external;
542 
543 }
544 
545 ////// contracts/interfaces/IPoolFactory.sol
546 /* pragma solidity 0.6.11; */
547 
548 interface IPoolFactory {
549 
550     function LL_FACTORY() external view returns (uint8);
551 
552     function SL_FACTORY() external view returns (uint8);
553 
554     function poolsCreated() external view returns (uint256);
555 
556     function globals() external view returns (address);
557 
558     function pools(uint256) external view returns (address);
559 
560     function isPool(address) external view returns (bool);
561 
562     function poolFactoryAdmins(address) external view returns (bool);
563 
564     function setGlobals(address) external;
565 
566     function createPool(address, address, address, address, uint256, uint256, uint256) external returns (address);
567 
568     function setPoolFactoryAdmin(address, bool) external;
569 
570     function pause() external;
571 
572     function unpause() external;
573 
574 }
575 
576 ////// contracts/token/interfaces/IExtendedFDT.sol
577 /* pragma solidity 0.6.11; */
578 
579 /* import "./IBasicFDT.sol"; */
580 
581 interface IExtendedFDT is IBasicFDT {
582 
583     event LossesPerShareUpdated(uint256);
584 
585     event LossesCorrectionUpdated(address indexed, int256);
586 
587     event LossesDistributed(address indexed, uint256);
588 
589     event LossesRecognized(address indexed, uint256, uint256);
590 
591     function lossesPerShare() external view returns (uint256);
592 
593     function recognizableLossesOf(address) external view returns (uint256);
594 
595     function recognizedLossesOf(address) external view returns (uint256);
596 
597     function accumulativeLossesOf(address) external view returns (uint256);
598 
599     function updateLossesReceived() external;
600 
601 }
602 
603 ////// contracts/token/interfaces/IStakeLockerFDT.sol
604 /* pragma solidity 0.6.11; */
605 
606 /* import "./IExtendedFDT.sol"; */
607 
608 interface IStakeLockerFDT is IExtendedFDT {
609 
610     function fundsToken() external view returns (address);
611 
612     function fundsTokenBalance() external view returns (uint256);
613 
614     function bptLosses() external view returns (uint256);
615 
616     function lossesBalance() external view returns (uint256);
617 
618 }
619 
620 ////// contracts/interfaces/IStakeLocker.sol
621 /* pragma solidity 0.6.11; */
622 
623 /* import "../token/interfaces/IStakeLockerFDT.sol"; */
624 
625 interface IStakeLocker is IStakeLockerFDT {
626 
627     function stakeDate(address) external returns (uint256);
628 
629     function stake(uint256) external;
630 
631     function unstake(uint256) external;
632 
633     function pull(address, uint256) external;
634 
635     function setAllowlist(address, bool) external;
636 
637     function openStakeLockerToPublic() external;
638 
639     function openToPublic() external view returns (bool);
640 
641     function allowed(address) external view returns (bool);
642 
643     function updateLosses(uint256) external;
644 
645     function intendToUnstake() external;
646 
647     function unstakeCooldown(address) external view returns (uint256);
648 
649     function lockupPeriod() external view returns (uint256);
650 
651     function stakeAsset() external view returns (address);
652 
653     function liquidityAsset() external view returns (address);
654 
655     function pool() external view returns (address);
656 
657     function setLockupPeriod(uint256) external;
658 
659     function cancelUnstake() external;
660 
661     function increaseCustodyAllowance(address, uint256) external;
662 
663     function transferByCustodian(address, address, uint256) external;
664 
665     function pause() external;
666 
667     function unpause() external;
668 
669     function isUnstakeAllowed(address) external view returns (bool);
670 
671     function isReceiveAllowed(uint256) external view returns (bool);
672 
673 }
674 
675 ////// contracts/interfaces/IStakeLockerFactory.sol
676 /* pragma solidity 0.6.11; */
677 
678 interface IStakeLockerFactory {
679 
680     function owner(address) external returns (address);
681 
682     function isLocker(address) external returns (bool);
683 
684     function factoryType() external returns (uint8);
685 
686     function newLocker(address, address) external returns (address);
687 
688 }
689 
690 ////// contracts/interfaces/IDebtLockerFactory.sol
691 /* pragma solidity 0.6.11; */
692 
693 interface IDebtLockerFactory {
694 
695     function owner(address) external view returns (address);
696 
697     function isLocker(address) external view returns (bool);
698 
699     function factoryType() external view returns (uint8);
700 
701     function newLocker(address) external returns (address);
702 
703 }
704 
705 ////// contracts/interfaces/IERC20Details.sol
706 /* pragma solidity 0.6.11; */
707 
708 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
709 
710 interface IERC20Details is IERC20 {
711 
712     function name() external view returns (string memory);
713 
714     function symbol() external view returns (string memory);
715 
716     function decimals() external view returns (uint256);
717 
718 }
719 
720 ////// lib/openzeppelin-contracts/contracts/math/SafeMath.sol
721 /* pragma solidity >=0.6.0 <0.8.0; */
722 
723 /**
724  * @dev Wrappers over Solidity's arithmetic operations with added overflow
725  * checks.
726  *
727  * Arithmetic operations in Solidity wrap on overflow. This can easily result
728  * in bugs, because programmers usually assume that an overflow raises an
729  * error, which is the standard behavior in high level programming languages.
730  * `SafeMath` restores this intuition by reverting the transaction when an
731  * operation overflows.
732  *
733  * Using this library instead of the unchecked operations eliminates an entire
734  * class of bugs, so it's recommended to use it always.
735  */
736 library SafeMath {
737     /**
738      * @dev Returns the addition of two unsigned integers, reverting on
739      * overflow.
740      *
741      * Counterpart to Solidity's `+` operator.
742      *
743      * Requirements:
744      *
745      * - Addition cannot overflow.
746      */
747     function add(uint256 a, uint256 b) internal pure returns (uint256) {
748         uint256 c = a + b;
749         require(c >= a, "SafeMath: addition overflow");
750 
751         return c;
752     }
753 
754     /**
755      * @dev Returns the subtraction of two unsigned integers, reverting on
756      * overflow (when the result is negative).
757      *
758      * Counterpart to Solidity's `-` operator.
759      *
760      * Requirements:
761      *
762      * - Subtraction cannot overflow.
763      */
764     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
765         return sub(a, b, "SafeMath: subtraction overflow");
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
770      * overflow (when the result is negative).
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
779         require(b <= a, errorMessage);
780         uint256 c = a - b;
781 
782         return c;
783     }
784 
785     /**
786      * @dev Returns the multiplication of two unsigned integers, reverting on
787      * overflow.
788      *
789      * Counterpart to Solidity's `*` operator.
790      *
791      * Requirements:
792      *
793      * - Multiplication cannot overflow.
794      */
795     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
796         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
797         // benefit is lost if 'b' is also tested.
798         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
799         if (a == 0) {
800             return 0;
801         }
802 
803         uint256 c = a * b;
804         require(c / a == b, "SafeMath: multiplication overflow");
805 
806         return c;
807     }
808 
809     /**
810      * @dev Returns the integer division of two unsigned integers. Reverts on
811      * division by zero. The result is rounded towards zero.
812      *
813      * Counterpart to Solidity's `/` operator. Note: this function uses a
814      * `revert` opcode (which leaves remaining gas untouched) while Solidity
815      * uses an invalid opcode to revert (consuming all remaining gas).
816      *
817      * Requirements:
818      *
819      * - The divisor cannot be zero.
820      */
821     function div(uint256 a, uint256 b) internal pure returns (uint256) {
822         return div(a, b, "SafeMath: division by zero");
823     }
824 
825     /**
826      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
827      * division by zero. The result is rounded towards zero.
828      *
829      * Counterpart to Solidity's `/` operator. Note: this function uses a
830      * `revert` opcode (which leaves remaining gas untouched) while Solidity
831      * uses an invalid opcode to revert (consuming all remaining gas).
832      *
833      * Requirements:
834      *
835      * - The divisor cannot be zero.
836      */
837     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
838         require(b > 0, errorMessage);
839         uint256 c = a / b;
840         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
841 
842         return c;
843     }
844 
845     /**
846      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
847      * Reverts when dividing by zero.
848      *
849      * Counterpart to Solidity's `%` operator. This function uses a `revert`
850      * opcode (which leaves remaining gas untouched) while Solidity uses an
851      * invalid opcode to revert (consuming all remaining gas).
852      *
853      * Requirements:
854      *
855      * - The divisor cannot be zero.
856      */
857     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
858         return mod(a, b, "SafeMath: modulo by zero");
859     }
860 
861     /**
862      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
863      * Reverts with custom message when dividing by zero.
864      *
865      * Counterpart to Solidity's `%` operator. This function uses a `revert`
866      * opcode (which leaves remaining gas untouched) while Solidity uses an
867      * invalid opcode to revert (consuming all remaining gas).
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
874         require(b != 0, errorMessage);
875         return a % b;
876     }
877 }
878 
879 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
880 /* pragma solidity >=0.6.2 <0.8.0; */
881 
882 /**
883  * @dev Collection of functions related to the address type
884  */
885 library Address {
886     /**
887      * @dev Returns true if `account` is a contract.
888      *
889      * [IMPORTANT]
890      * ====
891      * It is unsafe to assume that an address for which this function returns
892      * false is an externally-owned account (EOA) and not a contract.
893      *
894      * Among others, `isContract` will return false for the following
895      * types of addresses:
896      *
897      *  - an externally-owned account
898      *  - a contract in construction
899      *  - an address where a contract will be created
900      *  - an address where a contract lived, but was destroyed
901      * ====
902      */
903     function isContract(address account) internal view returns (bool) {
904         // This method relies on extcodesize, which returns 0 for contracts in
905         // construction, since the code is only stored at the end of the
906         // constructor execution.
907 
908         uint256 size;
909         // solhint-disable-next-line no-inline-assembly
910         assembly { size := extcodesize(account) }
911         return size > 0;
912     }
913 
914     /**
915      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
916      * `recipient`, forwarding all available gas and reverting on errors.
917      *
918      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
919      * of certain opcodes, possibly making contracts go over the 2300 gas limit
920      * imposed by `transfer`, making them unable to receive funds via
921      * `transfer`. {sendValue} removes this limitation.
922      *
923      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
924      *
925      * IMPORTANT: because control is transferred to `recipient`, care must be
926      * taken to not create reentrancy vulnerabilities. Consider using
927      * {ReentrancyGuard} or the
928      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
929      */
930     function sendValue(address payable recipient, uint256 amount) internal {
931         require(address(this).balance >= amount, "Address: insufficient balance");
932 
933         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
934         (bool success, ) = recipient.call{ value: amount }("");
935         require(success, "Address: unable to send value, recipient may have reverted");
936     }
937 
938     /**
939      * @dev Performs a Solidity function call using a low level `call`. A
940      * plain`call` is an unsafe replacement for a function call: use this
941      * function instead.
942      *
943      * If `target` reverts with a revert reason, it is bubbled up by this
944      * function (like regular Solidity function calls).
945      *
946      * Returns the raw returned data. To convert to the expected return value,
947      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
948      *
949      * Requirements:
950      *
951      * - `target` must be a contract.
952      * - calling `target` with `data` must not revert.
953      *
954      * _Available since v3.1._
955      */
956     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
957       return functionCall(target, data, "Address: low-level call failed");
958     }
959 
960     /**
961      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
962      * `errorMessage` as a fallback revert reason when `target` reverts.
963      *
964      * _Available since v3.1._
965      */
966     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
967         return functionCallWithValue(target, data, 0, errorMessage);
968     }
969 
970     /**
971      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
972      * but also transferring `value` wei to `target`.
973      *
974      * Requirements:
975      *
976      * - the calling contract must have an ETH balance of at least `value`.
977      * - the called Solidity function must be `payable`.
978      *
979      * _Available since v3.1._
980      */
981     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
982         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
983     }
984 
985     /**
986      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
987      * with `errorMessage` as a fallback revert reason when `target` reverts.
988      *
989      * _Available since v3.1._
990      */
991     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
992         require(address(this).balance >= value, "Address: insufficient balance for call");
993         require(isContract(target), "Address: call to non-contract");
994 
995         // solhint-disable-next-line avoid-low-level-calls
996         (bool success, bytes memory returndata) = target.call{ value: value }(data);
997         return _verifyCallResult(success, returndata, errorMessage);
998     }
999 
1000     /**
1001      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1002      * but performing a static call.
1003      *
1004      * _Available since v3.3._
1005      */
1006     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1007         return functionStaticCall(target, data, "Address: low-level static call failed");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1012      * but performing a static call.
1013      *
1014      * _Available since v3.3._
1015      */
1016     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1017         require(isContract(target), "Address: static call to non-contract");
1018 
1019         // solhint-disable-next-line avoid-low-level-calls
1020         (bool success, bytes memory returndata) = target.staticcall(data);
1021         return _verifyCallResult(success, returndata, errorMessage);
1022     }
1023 
1024     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1025         if (success) {
1026             return returndata;
1027         } else {
1028             // Look for revert reason and bubble it up if present
1029             if (returndata.length > 0) {
1030                 // The easiest way to bubble the revert reason is using memory via assembly
1031 
1032                 // solhint-disable-next-line no-inline-assembly
1033                 assembly {
1034                     let returndata_size := mload(returndata)
1035                     revert(add(32, returndata), returndata_size)
1036                 }
1037             } else {
1038                 revert(errorMessage);
1039             }
1040         }
1041     }
1042 }
1043 
1044 ////// lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol
1045 /* pragma solidity >=0.6.0 <0.8.0; */
1046 
1047 /* import "./IERC20.sol"; */
1048 /* import "../../math/SafeMath.sol"; */
1049 /* import "../../utils/Address.sol"; */
1050 
1051 /**
1052  * @title SafeERC20
1053  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1054  * contract returns false). Tokens that return no value (and instead revert or
1055  * throw on failure) are also supported, non-reverting calls are assumed to be
1056  * successful.
1057  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1058  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1059  */
1060 library SafeERC20 {
1061     using SafeMath for uint256;
1062     using Address for address;
1063 
1064     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1065         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1066     }
1067 
1068     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1069         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1070     }
1071 
1072     /**
1073      * @dev Deprecated. This function has issues similar to the ones found in
1074      * {IERC20-approve}, and its usage is discouraged.
1075      *
1076      * Whenever possible, use {safeIncreaseAllowance} and
1077      * {safeDecreaseAllowance} instead.
1078      */
1079     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1080         // safeApprove should only be called when setting an initial allowance,
1081         // or when resetting it to zero. To increase and decrease it, use
1082         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1083         // solhint-disable-next-line max-line-length
1084         require((value == 0) || (token.allowance(address(this), spender) == 0),
1085             "SafeERC20: approve from non-zero to non-zero allowance"
1086         );
1087         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1088     }
1089 
1090     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1091         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1092         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1093     }
1094 
1095     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1096         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1097         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1098     }
1099 
1100     /**
1101      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1102      * on the return value: the return value is optional (but if data is returned, it must not be false).
1103      * @param token The token targeted by the call.
1104      * @param data The call data (encoded using abi.encode or one of its variants).
1105      */
1106     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1107         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1108         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1109         // the target address contains contract code and also asserts for success in the low-level call.
1110 
1111         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1112         if (returndata.length > 0) { // Return data is optional
1113             // solhint-disable-next-line max-line-length
1114             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1115         }
1116     }
1117 }
1118 
1119 ////// contracts/library/PoolLib.sol
1120 /* pragma solidity 0.6.11; */
1121 
1122 /* import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol"; */
1123 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol"; */
1124 /* import "../interfaces/ILoan.sol"; */
1125 /* import "../interfaces/IBPool.sol"; */
1126 /* import "../interfaces/IMapleGlobals.sol"; */
1127 /* import "../interfaces/ILiquidityLocker.sol"; */
1128 /* import "../interfaces/IERC20Details.sol"; */
1129 /* import "../interfaces/ILoanFactory.sol"; */
1130 /* import "../interfaces/IStakeLocker.sol"; */
1131 /* import "../interfaces/IDebtLockerFactory.sol"; */
1132 
1133 /// @title PoolLib is a library of utility functions used by Pool.
1134 library PoolLib {
1135 
1136     using SafeMath for uint256;
1137     using SafeERC20 for IERC20;
1138 
1139     uint256 public constant MAX_UINT256 = uint256(-1);
1140     uint256 public constant WAD         = 10 ** 18;
1141     uint8   public constant DL_FACTORY  = 1;         // Factory type of DebtLockerFactory
1142 
1143     event         LoanFunded(address indexed loan, address debtLocker, uint256 amountFunded);
1144     event DepositDateUpdated(address indexed liquidityProvider, uint256 depositDate);
1145 
1146     /***************************************/
1147     /*** Pool Delegate Utility Functions ***/
1148     /***************************************/
1149 
1150     /** 
1151         @dev   Conducts sanity checks for Pools in the constructor.
1152         @param globals        Instance of a MapleGlobals.
1153         @param liquidityAsset Asset used by Pool for liquidity to fund loans.
1154         @param stakeAsset     Asset escrowed in StakeLocker.
1155         @param stakingFee     Fee that the Stakers earn on interest, in basis points.
1156         @param delegateFee    Fee that the Pool Delegate earns on interest, in basis points.
1157     */
1158     function poolSanityChecks(
1159         IMapleGlobals globals, 
1160         address liquidityAsset, 
1161         address stakeAsset, 
1162         uint256 stakingFee, 
1163         uint256 delegateFee
1164     ) external view {
1165         IBPool bPool = IBPool(stakeAsset);
1166 
1167         require(globals.isValidLiquidityAsset(liquidityAsset), "P:INVALID_LIQ_ASSET");
1168         require(stakingFee.add(delegateFee) <= 10_000,         "P:INVALID_FEES");
1169         require(
1170             globals.isValidBalancerPool(address(stakeAsset)) &&
1171             bPool.isBound(globals.mpl())                     && 
1172             bPool.isBound(liquidityAsset)                    &&
1173             bPool.isFinalized(), 
1174             "P:INVALID_BALANCER_POOL"
1175         );
1176     }
1177 
1178     /**
1179         @dev   Funds a Loan for an amount, utilizing the supplied DebtLockerFactory for DebtLockers.
1180         @dev   It emits a `LoanFunded` event.
1181         @param debtLockers     Mapping contains the DebtLocker contract address corresponding to the DebtLockerFactory and Loan.
1182         @param superFactory    Address of the PoolFactory.
1183         @param liquidityLocker Address of the LiquidityLocker contract attached with this Pool.
1184         @param loan            Address of the Loan to fund.
1185         @param dlFactory       The DebtLockerFactory to utilize.
1186         @param amt             Amount to fund the Loan.
1187     */
1188     function fundLoan(
1189         mapping(address => mapping(address => address)) storage debtLockers,
1190         address superFactory,
1191         address liquidityLocker,
1192         address loan,
1193         address dlFactory,
1194         uint256 amt
1195     ) external {
1196         IMapleGlobals globals = IMapleGlobals(ILoanFactory(superFactory).globals());
1197         address loanFactory   = ILoan(loan).superFactory();
1198 
1199         // Auth checks.
1200         require(globals.isValidLoanFactory(loanFactory),                        "P:INVALID_LF");
1201         require(ILoanFactory(loanFactory).isLoan(loan),                         "P:INVALID_L");
1202         require(globals.isValidSubFactory(superFactory, dlFactory, DL_FACTORY), "P:INVALID_DLF");
1203 
1204         address debtLocker = debtLockers[loan][dlFactory];
1205 
1206         // Instantiate DebtLocker if it doesn't exist withing this factory
1207         if (debtLocker == address(0)) {
1208             debtLocker = IDebtLockerFactory(dlFactory).newLocker(loan);
1209             debtLockers[loan][dlFactory] = debtLocker;
1210         }
1211     
1212         // Fund the Loan.
1213         ILiquidityLocker(liquidityLocker).fundLoan(loan, debtLocker, amt);
1214         
1215         emit LoanFunded(loan, debtLocker, amt);
1216     }
1217 
1218     /**
1219         @dev    Helper function used by Pool `claim` function, for when if a default has occurred.
1220         @param  liquidityAsset                  IERC20 of Liquidity Asset.
1221         @param  stakeLocker                     Address of StakeLocker.
1222         @param  stakeAsset                      Address of BPTs.
1223         @param  defaultSuffered                 Amount of shortfall in defaulted Loan after liquidation.
1224         @return bptsBurned                      Amount of BPTs burned to cover shortfall.
1225         @return postBurnBptBal                  Amount of BPTs returned to StakeLocker after burn.
1226         @return liquidityAssetRecoveredFromBurn Amount of Liquidity Asset recovered from burn.
1227     */
1228     function handleDefault(
1229         IERC20  liquidityAsset,
1230         address stakeLocker,
1231         address stakeAsset,
1232         uint256 defaultSuffered
1233     ) 
1234         external
1235         returns (
1236             uint256 bptsBurned,
1237             uint256 postBurnBptBal,
1238             uint256 liquidityAssetRecoveredFromBurn
1239         ) 
1240     {
1241 
1242         IBPool bPool = IBPool(stakeAsset);  // stakeAsset = Balancer Pool Tokens
1243 
1244         // Check amount of Liquidity Asset coverage that exists in the StakeLocker.
1245         uint256 availableSwapOut = getSwapOutValueLocker(stakeAsset, address(liquidityAsset), stakeLocker);
1246 
1247         // Pull BPTs from StakeLocker.
1248         IStakeLocker(stakeLocker).pull(address(this), bPool.balanceOf(stakeLocker));
1249 
1250         // To maintain accounting, account for direct transfers into Pool.
1251         uint256 preBurnLiquidityAssetBal = liquidityAsset.balanceOf(address(this));
1252         uint256 preBurnBptBal            = bPool.balanceOf(address(this));
1253 
1254         // Burn enough BPTs for Liquidity Asset to cover default suffered.
1255         bPool.exitswapExternAmountOut(
1256             address(liquidityAsset), 
1257             availableSwapOut >= defaultSuffered ? defaultSuffered : availableSwapOut,  // Burn BPTs up to defaultSuffered amount
1258             preBurnBptBal
1259         );
1260 
1261         // Return remaining BPTs to StakeLocker.
1262         postBurnBptBal = bPool.balanceOf(address(this));
1263         bptsBurned     = preBurnBptBal.sub(postBurnBptBal);
1264         bPool.transfer(stakeLocker, postBurnBptBal);
1265         liquidityAssetRecoveredFromBurn = liquidityAsset.balanceOf(address(this)).sub(preBurnLiquidityAssetBal);
1266         IStakeLocker(stakeLocker).updateLosses(bptsBurned);  // Update StakeLockerFDT loss accounting for BPTs
1267     }
1268 
1269     /**
1270         @dev    Calculates portions of claim from DebtLocker to be used by Pool `claim` function.
1271         @param  claimInfo           [0] = Total Claimed
1272                                     [1] = Interest Claimed
1273                                     [2] = Principal Claimed
1274                                     [3] = Fee Claimed
1275                                     [4] = Excess Returned Claimed
1276                                     [5] = Amount Recovered (from Liquidation)
1277                                     [6] = Default Suffered
1278         @param  delegateFee         Portion of interest (basis points) that goes to the Pool Delegate.
1279         @param  stakingFee          Portion of interest (basis points) that goes to the StakeLocker.
1280         @return poolDelegatePortion Total funds to send to the Pool Delegate.
1281         @return stakeLockerPortion  Total funds to send to the StakeLocker.
1282         @return principalClaim      Total principal claim.
1283         @return interestClaim       Total interest claim.
1284     */
1285     function calculateClaimAndPortions(
1286         uint256[7] calldata claimInfo,
1287         uint256 delegateFee,
1288         uint256 stakingFee
1289     ) 
1290         external
1291         pure
1292         returns (
1293             uint256 poolDelegatePortion,
1294             uint256 stakeLockerPortion,
1295             uint256 principalClaim,
1296             uint256 interestClaim
1297         ) 
1298     { 
1299         poolDelegatePortion = claimInfo[1].mul(delegateFee).div(10_000).add(claimInfo[3]);  // Pool Delegate portion of interest plus fee.
1300         stakeLockerPortion  = claimInfo[1].mul(stakingFee).div(10_000);                     // StakeLocker portion of interest.
1301 
1302         principalClaim = claimInfo[2].add(claimInfo[4]).add(claimInfo[5]);                                     // principal + excess + amountRecovered
1303         interestClaim  = claimInfo[1].sub(claimInfo[1].mul(delegateFee).div(10_000)).sub(stakeLockerPortion);  // leftover interest
1304     }
1305 
1306     /**
1307         @dev   Checks that the deactivation is allowed.
1308         @param globals        Instance of a MapleGlobals.
1309         @param principalOut   Amount of funds that are already funded to Loans.
1310         @param liquidityAsset Liquidity Asset of the Pool.
1311     */
1312     function validateDeactivation(IMapleGlobals globals, uint256 principalOut, address liquidityAsset) external view {
1313         require(principalOut <= _convertFromUsd(globals, liquidityAsset, 100), "P:PRINCIPAL_OUTSTANDING");
1314     }
1315 
1316     /********************************************/
1317     /*** Liquidity Provider Utility Functions ***/
1318     /********************************************/
1319 
1320     /**
1321         @dev   Updates the effective deposit date based on how much new capital has been added.
1322                If more capital is added, the deposit date moves closer to the current timestamp.
1323         @dev   It emits a `DepositDateUpdated` event.
1324         @param amt     Total deposit amount.
1325         @param account Address of account depositing.
1326     */
1327     function updateDepositDate(mapping(address => uint256) storage depositDate, uint256 balance, uint256 amt, address account) internal {
1328         uint256 prevDate = depositDate[account];
1329 
1330         // prevDate + (now - prevDate) * (amt / (balance + amt))
1331         // NOTE: prevDate = 0 implies balance = 0, and equation reduces to now
1332         uint256 newDate = (balance + amt) > 0
1333             ? prevDate.add(block.timestamp.sub(prevDate).mul(amt).div(balance + amt))
1334             : prevDate;
1335 
1336         depositDate[account] = newDate;
1337         emit DepositDateUpdated(account, newDate);
1338     }
1339 
1340     /**
1341         @dev Performs all necessary checks for a `transferByCustodian` call.
1342         @dev From and to must always be equal.
1343     */
1344     function transferByCustodianChecks(address from, address to, uint256 amount) external pure {
1345         require(to == from,                 "P:INVALID_RECEIVER");
1346         require(amount != uint256(0),       "P:INVALID_AMT");
1347     }
1348 
1349     /**
1350         @dev Performs all necessary checks for an `increaseCustodyAllowance` call.
1351     */
1352     function increaseCustodyAllowanceChecks(address custodian, uint256 amount, uint256 newTotalAllowance, uint256 fdtBal) external pure {
1353         require(custodian != address(0),     "P:INVALID_CUSTODIAN");
1354         require(amount    != uint256(0),     "P:INVALID_AMT");
1355         require(newTotalAllowance <= fdtBal, "P:INSUF_BALANCE");
1356     }
1357 
1358     /**********************************/
1359     /*** Governor Utility Functions ***/
1360     /**********************************/
1361 
1362     /**
1363         @dev   Transfers any locked funds to the Governor. Only the Governor can call this function.
1364         @param token          Address of the token to be reclaimed.
1365         @param liquidityAsset Address of Liquidity Asset that is supported by the Pool.
1366         @param globals        Instance of a MapleGlobals.
1367     */
1368     function reclaimERC20(address token, address liquidityAsset, IMapleGlobals globals) external {
1369         require(msg.sender == globals.governor(), "P:NOT_GOV");
1370         require(token != liquidityAsset && token != address(0), "P:INVALID_TOKEN");
1371         IERC20(token).safeTransfer(msg.sender, IERC20(token).balanceOf(address(this)));
1372     }
1373 
1374     /************************/
1375     /*** Getter Functions ***/
1376     /************************/
1377 
1378     /**
1379         @dev Official Balancer pool bdiv() function. Does synthetic float with 10^-18 precision.
1380     */
1381     function _bdiv(uint256 a, uint256 b) internal pure returns (uint256) {
1382         require(b != 0, "P:DIV_ZERO");
1383         uint256 c0 = a * WAD;
1384         require(a == 0 || c0 / a == WAD, "P:DIV_INTERNAL");  // bmul overflow
1385         uint256 c1 = c0 + (b / 2);
1386         require(c1 >= c0, "P:DIV_INTERNAL");  //  badd require
1387         return c1 / b;
1388     }
1389 
1390     /**
1391         @dev    Calculates the value of BPT in units of Liquidity Asset.
1392         @dev    Vulnerable to flash-loan attacks where the attacker can artificially inflate the BPT price by swapping a large amount
1393                 of Liquidity Asset into the Pool and swapping back after this function is called.
1394         @param  _bPool         Address of Balancer pool.
1395         @param  liquidityAsset Asset used by Pool for liquidity to fund Loans.
1396         @param  staker         Address that deposited BPTs to StakeLocker.
1397         @param  stakeLocker    Escrows BPTs deposited by Staker.
1398         @return USDC value of Staker BPTs.
1399     */
1400     function BPTVal(
1401         address _bPool,
1402         address liquidityAsset,
1403         address staker,
1404         address stakeLocker
1405     ) external view returns (uint256) {
1406         IBPool bPool = IBPool(_bPool);
1407 
1408         // StakeLockerFDTs are minted 1:1 (in wei) in the StakeLocker when staking BPTs, thus representing stake amount.
1409         // These are burned when withdrawing staked BPTs, thus representing the current stake amount.
1410         uint256 amountStakedBPT       = IERC20(stakeLocker).balanceOf(staker);
1411         uint256 totalSupplyBPT        = IERC20(_bPool).totalSupply();
1412         uint256 liquidityAssetBalance = bPool.getBalance(liquidityAsset);
1413         uint256 liquidityAssetWeight  = bPool.getNormalizedWeight(liquidityAsset);
1414 
1415         // liquidityAsset value = (amountStaked/totalSupply) * (liquidityAssetBalance/liquidityAssetWeight)
1416         return _bdiv(amountStakedBPT, totalSupplyBPT).mul(_bdiv(liquidityAssetBalance, liquidityAssetWeight)).div(WAD);
1417     }
1418 
1419     /** 
1420         @dev    Calculates Liquidity Asset swap out value of staker BPT balance escrowed in StakeLocker.
1421         @param  _bPool         Balancer pool that issues the BPTs.
1422         @param  liquidityAsset Swap out asset (e.g. USDC) to receive when burning BPTs.
1423         @param  staker         Address that deposited BPTs to StakeLocker.
1424         @param  stakeLocker    Escrows BPTs deposited by Staker.
1425         @return liquidityAsset Swap out value of staker BPTs.
1426     */
1427     function getSwapOutValue(
1428         address _bPool,
1429         address liquidityAsset,
1430         address staker,
1431         address stakeLocker
1432     ) public view returns (uint256) {
1433         return _getSwapOutValue(_bPool, liquidityAsset, IERC20(stakeLocker).balanceOf(staker));
1434     }
1435 
1436     /** 
1437         @dev    Calculates Liquidity Asset swap out value of entire BPT balance escrowed in StakeLocker.
1438         @param  _bPool         Balancer pool that issues the BPTs.
1439         @param  liquidityAsset Swap out asset (e.g. USDC) to receive when burning BPTs.
1440         @param  stakeLocker    Escrows BPTs deposited by Staker.
1441         @return liquidityAsset Swap out value of StakeLocker BPTs.
1442     */
1443     function getSwapOutValueLocker(
1444         address _bPool,
1445         address liquidityAsset,
1446         address stakeLocker
1447     ) public view returns (uint256) {
1448         return _getSwapOutValue(_bPool, liquidityAsset, IBPool(_bPool).balanceOf(stakeLocker));
1449     }
1450 
1451     function _getSwapOutValue(
1452         address _bPool,
1453         address liquidityAsset,
1454         uint256 poolAmountIn
1455     ) internal view returns (uint256) {
1456         // Fetch Balancer pool token information
1457         IBPool bPool            = IBPool(_bPool);
1458         uint256 tokenBalanceOut = bPool.getBalance(liquidityAsset);
1459         uint256 tokenWeightOut  = bPool.getDenormalizedWeight(liquidityAsset);
1460         uint256 poolSupply      = bPool.totalSupply();
1461         uint256 totalWeight     = bPool.getTotalDenormalizedWeight();
1462         uint256 swapFee         = bPool.getSwapFee();
1463 
1464         // Returns the amount of liquidityAsset that can be recovered from BPT burning
1465         uint256 tokenAmountOut = bPool.calcSingleOutGivenPoolIn(
1466             tokenBalanceOut,
1467             tokenWeightOut,
1468             poolSupply,
1469             totalWeight,
1470             poolAmountIn,
1471             swapFee
1472         );
1473 
1474         // Max amount that can be swapped based on amount of liquidityAsset in the Balancer Pool
1475         uint256 maxSwapOut = tokenBalanceOut.mul(bPool.MAX_OUT_RATIO()).div(WAD);  
1476 
1477         return tokenAmountOut <= maxSwapOut ? tokenAmountOut : maxSwapOut;
1478     }
1479 
1480     /**
1481         @dev    Calculates BPTs required if burning BPTs for liquidityAsset, given supplied tokenAmountOutRequired.
1482         @dev    Vulnerable to flash-loan attacks where the attacker can artificially inflate the BPT price by swapping a large amount
1483                 of liquidityAsset into the pool and swapping back after this function is called.
1484         @param  _bPool                       Balancer pool that issues the BPTs.
1485         @param  liquidityAsset               Swap out asset (e.g. USDC) to receive when burning BPTs.
1486         @param  staker                       Address that deposited BPTs to stakeLocker.
1487         @param  stakeLocker                  Escrows BPTs deposited by staker.
1488         @param  liquidityAssetAmountRequired Amount of liquidityAsset required to recover.
1489         @return poolAmountInRequired         poolAmountIn required.
1490         @return stakerBalance                poolAmountIn currently staked.
1491     */
1492     function getPoolSharesRequired(
1493         address _bPool,
1494         address liquidityAsset,
1495         address staker,
1496         address stakeLocker,
1497         uint256 liquidityAssetAmountRequired
1498     ) public view returns (uint256 poolAmountInRequired, uint256 stakerBalance) {
1499         // Fetch Balancer pool token information.
1500         IBPool bPool = IBPool(_bPool);
1501 
1502         uint256 tokenBalanceOut = bPool.getBalance(liquidityAsset);
1503         uint256 tokenWeightOut  = bPool.getDenormalizedWeight(liquidityAsset);
1504         uint256 poolSupply      = bPool.totalSupply();
1505         uint256 totalWeight     = bPool.getTotalDenormalizedWeight();
1506         uint256 swapFee         = bPool.getSwapFee();
1507 
1508         // Fetch amount of BPTs required to burn to receive Liquidity Asset amount required.
1509         poolAmountInRequired = bPool.calcPoolInGivenSingleOut(
1510             tokenBalanceOut,
1511             tokenWeightOut,
1512             poolSupply,
1513             totalWeight,
1514             liquidityAssetAmountRequired,
1515             swapFee
1516         );
1517 
1518         // Fetch amount staked in StakeLocker by Staker.
1519         stakerBalance = IERC20(stakeLocker).balanceOf(staker);
1520     }
1521 
1522     /**
1523         @dev    Returns information on the stake requirements.
1524         @param  globals                    Instance of a MapleGlobals.
1525         @param  balancerPool               Address of Balancer pool.
1526         @param  liquidityAsset             Address of Liquidity Asset, to be returned from swap out.
1527         @param  poolDelegate               Address of Pool Delegate.
1528         @param  stakeLocker                Address of StakeLocker.
1529         @return swapOutAmountRequired      Min amount of Liquidity Asset coverage from staking required (in Liquidity Asset units).
1530         @return currentPoolDelegateCover   Present amount of Liquidity Asset coverage from Pool Delegate stake (in Liquidity Asset units).
1531         @return enoughStakeForFinalization If enough stake is present from Pool Delegate for Pool finalization.
1532         @return poolAmountInRequired       BPTs required for minimum Liquidity Asset coverage.
1533         @return poolAmountPresent          Current staked BPTs.
1534     */
1535     function getInitialStakeRequirements(IMapleGlobals globals, address balancerPool, address liquidityAsset, address poolDelegate, address stakeLocker) external view returns (
1536         uint256 swapOutAmountRequired,
1537         uint256 currentPoolDelegateCover,
1538         bool    enoughStakeForFinalization,
1539         uint256 poolAmountInRequired,
1540         uint256 poolAmountPresent
1541     ) {
1542         swapOutAmountRequired = _convertFromUsd(globals, liquidityAsset, globals.swapOutRequired());
1543         (
1544             poolAmountInRequired,
1545             poolAmountPresent
1546         ) = getPoolSharesRequired(balancerPool, liquidityAsset, poolDelegate, stakeLocker, swapOutAmountRequired);
1547 
1548         currentPoolDelegateCover   = getSwapOutValue(balancerPool, liquidityAsset, poolDelegate, stakeLocker);
1549         enoughStakeForFinalization = poolAmountPresent >= poolAmountInRequired;
1550     }
1551 
1552     /************************/
1553     /*** Helper Functions ***/
1554     /************************/
1555 
1556     /**
1557         @dev   Converts from WAD precision to Liquidity Asset precision.
1558         @param amt                    Amount to convert.
1559         @param liquidityAssetDecimals Liquidity Asset decimal.
1560     */
1561     function fromWad(uint256 amt, uint256 liquidityAssetDecimals) external pure returns (uint256) {
1562         return amt.mul(10 ** liquidityAssetDecimals).div(WAD);
1563     }
1564 
1565     /** 
1566         @dev    Returns Liquidity Asset in Liquidity Asset units when given integer USD (E.g., $100 = 100).
1567         @param  globals        Instance of a MapleGlobals.
1568         @param  liquidityAsset Liquidity Asset of the pool.
1569         @param  usdAmount      USD amount to convert, in integer units (e.g., $100 = 100).
1570         @return usdAmount worth of Liquidity Asset, in Liquidity Asset units.
1571     */
1572     function _convertFromUsd(IMapleGlobals globals, address liquidityAsset, uint256 usdAmount) internal view returns (uint256) {
1573         return usdAmount
1574             .mul(10 ** 8)                                         // Cancel out 10 ** 8 decimals from oracle.
1575             .mul(10 ** IERC20Details(liquidityAsset).decimals())  // Convert to Liquidity Asset precision.
1576             .div(globals.getLatestPrice(liquidityAsset));         // Convert to Liquidity Asset value.
1577     }
1578 }
1579 
1580 ////// contracts/math/SafeMathInt.sol
1581 /* pragma solidity 0.6.11; */
1582 
1583 library SafeMathInt {
1584     function toUint256Safe(int256 a) internal pure returns (uint256) {
1585         require(a >= 0, "SMI:NEG");
1586         return uint256(a);
1587     }
1588 }
1589 
1590 ////// contracts/math/SafeMathUint.sol
1591 /* pragma solidity 0.6.11; */
1592 
1593 library SafeMathUint {
1594     function toInt256Safe(uint256 a) internal pure returns (int256 b) {
1595         b = int256(a);
1596         require(b >= 0, "SMU:OOB");
1597     }
1598 }
1599 
1600 ////// lib/openzeppelin-contracts/contracts/math/SignedSafeMath.sol
1601 /* pragma solidity >=0.6.0 <0.8.0; */
1602 
1603 /**
1604  * @title SignedSafeMath
1605  * @dev Signed math operations with safety checks that revert on error.
1606  */
1607 library SignedSafeMath {
1608     int256 constant private _INT256_MIN = -2**255;
1609 
1610     /**
1611      * @dev Returns the multiplication of two signed integers, reverting on
1612      * overflow.
1613      *
1614      * Counterpart to Solidity's `*` operator.
1615      *
1616      * Requirements:
1617      *
1618      * - Multiplication cannot overflow.
1619      */
1620     function mul(int256 a, int256 b) internal pure returns (int256) {
1621         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1622         // benefit is lost if 'b' is also tested.
1623         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1624         if (a == 0) {
1625             return 0;
1626         }
1627 
1628         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
1629 
1630         int256 c = a * b;
1631         require(c / a == b, "SignedSafeMath: multiplication overflow");
1632 
1633         return c;
1634     }
1635 
1636     /**
1637      * @dev Returns the integer division of two signed integers. Reverts on
1638      * division by zero. The result is rounded towards zero.
1639      *
1640      * Counterpart to Solidity's `/` operator. Note: this function uses a
1641      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1642      * uses an invalid opcode to revert (consuming all remaining gas).
1643      *
1644      * Requirements:
1645      *
1646      * - The divisor cannot be zero.
1647      */
1648     function div(int256 a, int256 b) internal pure returns (int256) {
1649         require(b != 0, "SignedSafeMath: division by zero");
1650         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
1651 
1652         int256 c = a / b;
1653 
1654         return c;
1655     }
1656 
1657     /**
1658      * @dev Returns the subtraction of two signed integers, reverting on
1659      * overflow.
1660      *
1661      * Counterpart to Solidity's `-` operator.
1662      *
1663      * Requirements:
1664      *
1665      * - Subtraction cannot overflow.
1666      */
1667     function sub(int256 a, int256 b) internal pure returns (int256) {
1668         int256 c = a - b;
1669         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1670 
1671         return c;
1672     }
1673 
1674     /**
1675      * @dev Returns the addition of two signed integers, reverting on
1676      * overflow.
1677      *
1678      * Counterpart to Solidity's `+` operator.
1679      *
1680      * Requirements:
1681      *
1682      * - Addition cannot overflow.
1683      */
1684     function add(int256 a, int256 b) internal pure returns (int256) {
1685         int256 c = a + b;
1686         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1687 
1688         return c;
1689     }
1690 }
1691 
1692 ////// lib/openzeppelin-contracts/contracts/GSN/Context.sol
1693 /* pragma solidity >=0.6.0 <0.8.0; */
1694 
1695 /*
1696  * @dev Provides information about the current execution context, including the
1697  * sender of the transaction and its data. While these are generally available
1698  * via msg.sender and msg.data, they should not be accessed in such a direct
1699  * manner, since when dealing with GSN meta-transactions the account sending and
1700  * paying for execution may not be the actual sender (as far as an application
1701  * is concerned).
1702  *
1703  * This contract is only required for intermediate, library-like contracts.
1704  */
1705 abstract contract Context {
1706     function _msgSender() internal view virtual returns (address payable) {
1707         return msg.sender;
1708     }
1709 
1710     function _msgData() internal view virtual returns (bytes memory) {
1711         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1712         return msg.data;
1713     }
1714 }
1715 
1716 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
1717 /* pragma solidity >=0.6.0 <0.8.0; */
1718 
1719 /* import "../../GSN/Context.sol"; */
1720 /* import "./IERC20.sol"; */
1721 /* import "../../math/SafeMath.sol"; */
1722 
1723 /**
1724  * @dev Implementation of the {IERC20} interface.
1725  *
1726  * This implementation is agnostic to the way tokens are created. This means
1727  * that a supply mechanism has to be added in a derived contract using {_mint}.
1728  * For a generic mechanism see {ERC20PresetMinterPauser}.
1729  *
1730  * TIP: For a detailed writeup see our guide
1731  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1732  * to implement supply mechanisms].
1733  *
1734  * We have followed general OpenZeppelin guidelines: functions revert instead
1735  * of returning `false` on failure. This behavior is nonetheless conventional
1736  * and does not conflict with the expectations of ERC20 applications.
1737  *
1738  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1739  * This allows applications to reconstruct the allowance for all accounts just
1740  * by listening to said events. Other implementations of the EIP may not emit
1741  * these events, as it isn't required by the specification.
1742  *
1743  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1744  * functions have been added to mitigate the well-known issues around setting
1745  * allowances. See {IERC20-approve}.
1746  */
1747 contract ERC20 is Context, IERC20 {
1748     using SafeMath for uint256;
1749 
1750     mapping (address => uint256) private _balances;
1751 
1752     mapping (address => mapping (address => uint256)) private _allowances;
1753 
1754     uint256 private _totalSupply;
1755 
1756     string private _name;
1757     string private _symbol;
1758     uint8 private _decimals;
1759 
1760     /**
1761      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1762      * a default value of 18.
1763      *
1764      * To select a different value for {decimals}, use {_setupDecimals}.
1765      *
1766      * All three of these values are immutable: they can only be set once during
1767      * construction.
1768      */
1769     constructor (string memory name_, string memory symbol_) public {
1770         _name = name_;
1771         _symbol = symbol_;
1772         _decimals = 18;
1773     }
1774 
1775     /**
1776      * @dev Returns the name of the token.
1777      */
1778     function name() public view returns (string memory) {
1779         return _name;
1780     }
1781 
1782     /**
1783      * @dev Returns the symbol of the token, usually a shorter version of the
1784      * name.
1785      */
1786     function symbol() public view returns (string memory) {
1787         return _symbol;
1788     }
1789 
1790     /**
1791      * @dev Returns the number of decimals used to get its user representation.
1792      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1793      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1794      *
1795      * Tokens usually opt for a value of 18, imitating the relationship between
1796      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1797      * called.
1798      *
1799      * NOTE: This information is only used for _display_ purposes: it in
1800      * no way affects any of the arithmetic of the contract, including
1801      * {IERC20-balanceOf} and {IERC20-transfer}.
1802      */
1803     function decimals() public view returns (uint8) {
1804         return _decimals;
1805     }
1806 
1807     /**
1808      * @dev See {IERC20-totalSupply}.
1809      */
1810     function totalSupply() public view override returns (uint256) {
1811         return _totalSupply;
1812     }
1813 
1814     /**
1815      * @dev See {IERC20-balanceOf}.
1816      */
1817     function balanceOf(address account) public view override returns (uint256) {
1818         return _balances[account];
1819     }
1820 
1821     /**
1822      * @dev See {IERC20-transfer}.
1823      *
1824      * Requirements:
1825      *
1826      * - `recipient` cannot be the zero address.
1827      * - the caller must have a balance of at least `amount`.
1828      */
1829     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1830         _transfer(_msgSender(), recipient, amount);
1831         return true;
1832     }
1833 
1834     /**
1835      * @dev See {IERC20-allowance}.
1836      */
1837     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1838         return _allowances[owner][spender];
1839     }
1840 
1841     /**
1842      * @dev See {IERC20-approve}.
1843      *
1844      * Requirements:
1845      *
1846      * - `spender` cannot be the zero address.
1847      */
1848     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1849         _approve(_msgSender(), spender, amount);
1850         return true;
1851     }
1852 
1853     /**
1854      * @dev See {IERC20-transferFrom}.
1855      *
1856      * Emits an {Approval} event indicating the updated allowance. This is not
1857      * required by the EIP. See the note at the beginning of {ERC20}.
1858      *
1859      * Requirements:
1860      *
1861      * - `sender` and `recipient` cannot be the zero address.
1862      * - `sender` must have a balance of at least `amount`.
1863      * - the caller must have allowance for ``sender``'s tokens of at least
1864      * `amount`.
1865      */
1866     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1867         _transfer(sender, recipient, amount);
1868         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1869         return true;
1870     }
1871 
1872     /**
1873      * @dev Atomically increases the allowance granted to `spender` by the caller.
1874      *
1875      * This is an alternative to {approve} that can be used as a mitigation for
1876      * problems described in {IERC20-approve}.
1877      *
1878      * Emits an {Approval} event indicating the updated allowance.
1879      *
1880      * Requirements:
1881      *
1882      * - `spender` cannot be the zero address.
1883      */
1884     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1885         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1886         return true;
1887     }
1888 
1889     /**
1890      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1891      *
1892      * This is an alternative to {approve} that can be used as a mitigation for
1893      * problems described in {IERC20-approve}.
1894      *
1895      * Emits an {Approval} event indicating the updated allowance.
1896      *
1897      * Requirements:
1898      *
1899      * - `spender` cannot be the zero address.
1900      * - `spender` must have allowance for the caller of at least
1901      * `subtractedValue`.
1902      */
1903     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1904         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1905         return true;
1906     }
1907 
1908     /**
1909      * @dev Moves tokens `amount` from `sender` to `recipient`.
1910      *
1911      * This is internal function is equivalent to {transfer}, and can be used to
1912      * e.g. implement automatic token fees, slashing mechanisms, etc.
1913      *
1914      * Emits a {Transfer} event.
1915      *
1916      * Requirements:
1917      *
1918      * - `sender` cannot be the zero address.
1919      * - `recipient` cannot be the zero address.
1920      * - `sender` must have a balance of at least `amount`.
1921      */
1922     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1923         require(sender != address(0), "ERC20: transfer from the zero address");
1924         require(recipient != address(0), "ERC20: transfer to the zero address");
1925 
1926         _beforeTokenTransfer(sender, recipient, amount);
1927 
1928         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1929         _balances[recipient] = _balances[recipient].add(amount);
1930         emit Transfer(sender, recipient, amount);
1931     }
1932 
1933     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1934      * the total supply.
1935      *
1936      * Emits a {Transfer} event with `from` set to the zero address.
1937      *
1938      * Requirements:
1939      *
1940      * - `to` cannot be the zero address.
1941      */
1942     function _mint(address account, uint256 amount) internal virtual {
1943         require(account != address(0), "ERC20: mint to the zero address");
1944 
1945         _beforeTokenTransfer(address(0), account, amount);
1946 
1947         _totalSupply = _totalSupply.add(amount);
1948         _balances[account] = _balances[account].add(amount);
1949         emit Transfer(address(0), account, amount);
1950     }
1951 
1952     /**
1953      * @dev Destroys `amount` tokens from `account`, reducing the
1954      * total supply.
1955      *
1956      * Emits a {Transfer} event with `to` set to the zero address.
1957      *
1958      * Requirements:
1959      *
1960      * - `account` cannot be the zero address.
1961      * - `account` must have at least `amount` tokens.
1962      */
1963     function _burn(address account, uint256 amount) internal virtual {
1964         require(account != address(0), "ERC20: burn from the zero address");
1965 
1966         _beforeTokenTransfer(account, address(0), amount);
1967 
1968         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1969         _totalSupply = _totalSupply.sub(amount);
1970         emit Transfer(account, address(0), amount);
1971     }
1972 
1973     /**
1974      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1975      *
1976      * This internal function is equivalent to `approve`, and can be used to
1977      * e.g. set automatic allowances for certain subsystems, etc.
1978      *
1979      * Emits an {Approval} event.
1980      *
1981      * Requirements:
1982      *
1983      * - `owner` cannot be the zero address.
1984      * - `spender` cannot be the zero address.
1985      */
1986     function _approve(address owner, address spender, uint256 amount) internal virtual {
1987         require(owner != address(0), "ERC20: approve from the zero address");
1988         require(spender != address(0), "ERC20: approve to the zero address");
1989 
1990         _allowances[owner][spender] = amount;
1991         emit Approval(owner, spender, amount);
1992     }
1993 
1994     /**
1995      * @dev Sets {decimals} to a value other than the default one of 18.
1996      *
1997      * WARNING: This function should only be called from the constructor. Most
1998      * applications that interact with token contracts will not expect
1999      * {decimals} to ever change, and may work incorrectly if it does.
2000      */
2001     function _setupDecimals(uint8 decimals_) internal {
2002         _decimals = decimals_;
2003     }
2004 
2005     /**
2006      * @dev Hook that is called before any transfer of tokens. This includes
2007      * minting and burning.
2008      *
2009      * Calling conditions:
2010      *
2011      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2012      * will be to transferred to `to`.
2013      * - when `from` is zero, `amount` tokens will be minted for `to`.
2014      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2015      * - `from` and `to` are never both zero.
2016      *
2017      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2018      */
2019     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2020 }
2021 
2022 ////// contracts/token/BasicFDT.sol
2023 /* pragma solidity 0.6.11; */
2024 
2025 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
2026 /* import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol"; */
2027 /* import "lib/openzeppelin-contracts/contracts/math/SignedSafeMath.sol"; */
2028 /* import "./interfaces/IBaseFDT.sol"; */
2029 /* import "../math/SafeMathUint.sol"; */
2030 /* import "../math/SafeMathInt.sol"; */
2031 
2032 /// @title BasicFDT implements base level FDT functionality for accounting for revenues.
2033 abstract contract BasicFDT is IBaseFDT, ERC20 {
2034     using SafeMath       for uint256;
2035     using SafeMathUint   for uint256;
2036     using SignedSafeMath for  int256;
2037     using SafeMathInt    for  int256;
2038 
2039     uint256 internal constant pointsMultiplier = 2 ** 128;
2040     uint256 internal pointsPerShare;
2041 
2042     mapping(address => int256)  internal pointsCorrection;
2043     mapping(address => uint256) internal withdrawnFunds;
2044 
2045     event   PointsPerShareUpdated(uint256 pointsPerShare);
2046     event PointsCorrectionUpdated(address indexed account, int256 pointsCorrection);
2047 
2048     constructor(string memory name, string memory symbol) ERC20(name, symbol) public { }
2049 
2050     /**
2051         @dev Distributes funds to token holders.
2052         @dev It reverts if the total supply of tokens is 0.
2053         @dev It emits a `FundsDistributed` event if the amount of received funds is greater than 0.
2054         @dev It emits a `PointsPerShareUpdated` event if the amount of received funds is greater than 0.
2055              About undistributed funds:
2056                 In each distribution, there is a small amount of funds which do not get distributed,
2057                    which is `(value  pointsMultiplier) % totalSupply()`.
2058                 With a well-chosen `pointsMultiplier`, the amount funds that are not getting distributed
2059                    in a distribution can be less than 1 (base unit).
2060                 We can actually keep track of the undistributed funds in a distribution
2061                    and try to distribute it in the next distribution.
2062     */
2063     function _distributeFunds(uint256 value) internal {
2064         require(totalSupply() > 0, "FDT:ZERO_SUPPLY");
2065 
2066         if (value == 0) return;
2067 
2068         pointsPerShare = pointsPerShare.add(value.mul(pointsMultiplier) / totalSupply());
2069         emit FundsDistributed(msg.sender, value);
2070         emit PointsPerShareUpdated(pointsPerShare);
2071     }
2072 
2073     /**
2074         @dev    Prepares the withdrawal of funds.
2075         @dev    It emits a `FundsWithdrawn` event if the amount of withdrawn funds is greater than 0.
2076         @return withdrawableDividend The amount of dividend funds that can be withdrawn.
2077     */
2078     function _prepareWithdraw() internal returns (uint256 withdrawableDividend) {
2079         withdrawableDividend       = withdrawableFundsOf(msg.sender);
2080         uint256 _withdrawnFunds    = withdrawnFunds[msg.sender].add(withdrawableDividend);
2081         withdrawnFunds[msg.sender] = _withdrawnFunds;
2082 
2083         emit FundsWithdrawn(msg.sender, withdrawableDividend, _withdrawnFunds);
2084     }
2085 
2086     /**
2087         @dev    Returns the amount of funds that an account can withdraw.
2088         @param  _owner The address of a token holder.
2089         @return The amount funds that `_owner` can withdraw.
2090     */
2091     function withdrawableFundsOf(address _owner) public view override returns (uint256) {
2092         return accumulativeFundsOf(_owner).sub(withdrawnFunds[_owner]);
2093     }
2094 
2095     /**
2096         @dev    Returns the amount of funds that an account has withdrawn.
2097         @param  _owner The address of a token holder.
2098         @return The amount of funds that `_owner` has withdrawn.
2099     */
2100     function withdrawnFundsOf(address _owner) external view returns (uint256) {
2101         return withdrawnFunds[_owner];
2102     }
2103 
2104     /**
2105         @dev    Returns the amount of funds that an account has earned in total.
2106         @dev    accumulativeFundsOf(_owner) = withdrawableFundsOf(_owner) + withdrawnFundsOf(_owner)
2107                                          = (pointsPerShare * balanceOf(_owner) + pointsCorrection[_owner]) / pointsMultiplier
2108         @param  _owner The address of a token holder.
2109         @return The amount of funds that `_owner` has earned in total.
2110     */
2111     function accumulativeFundsOf(address _owner) public view returns (uint256) {
2112         return
2113             pointsPerShare
2114                 .mul(balanceOf(_owner))
2115                 .toInt256Safe()
2116                 .add(pointsCorrection[_owner])
2117                 .toUint256Safe() / pointsMultiplier;
2118     }
2119 
2120     /**
2121         @dev   Transfers tokens from one account to another. Updates pointsCorrection to keep funds unchanged.
2122         @dev   It emits two `PointsCorrectionUpdated` events, one for the sender and one for the receiver.
2123         @param from  The address to transfer from.
2124         @param to    The address to transfer to.
2125         @param value The amount to be transferred.
2126     */
2127     function _transfer(
2128         address from,
2129         address to,
2130         uint256 value
2131     ) internal virtual override {
2132         super._transfer(from, to, value);
2133 
2134         int256 _magCorrection       = pointsPerShare.mul(value).toInt256Safe();
2135         int256 pointsCorrectionFrom = pointsCorrection[from].add(_magCorrection);
2136         pointsCorrection[from]      = pointsCorrectionFrom;
2137         int256 pointsCorrectionTo   = pointsCorrection[to].sub(_magCorrection);
2138         pointsCorrection[to]        = pointsCorrectionTo;
2139 
2140         emit PointsCorrectionUpdated(from, pointsCorrectionFrom);
2141         emit PointsCorrectionUpdated(to,   pointsCorrectionTo);
2142     }
2143 
2144     /**
2145         @dev   Mints tokens to an account. Updates pointsCorrection to keep funds unchanged.
2146         @param account The account that will receive the created tokens.
2147         @param value   The amount that will be created.
2148     */
2149     function _mint(address account, uint256 value) internal virtual override {
2150         super._mint(account, value);
2151 
2152         int256 _pointsCorrection = pointsCorrection[account].sub(
2153             (pointsPerShare.mul(value)).toInt256Safe()
2154         );
2155 
2156         pointsCorrection[account] = _pointsCorrection;
2157 
2158         emit PointsCorrectionUpdated(account, _pointsCorrection);
2159     }
2160 
2161     /**
2162         @dev   Burns an amount of the token of a given account. Updates pointsCorrection to keep funds unchanged.
2163         @dev   It emits a `PointsCorrectionUpdated` event.
2164         @param account The account whose tokens will be burnt.
2165         @param value   The amount that will be burnt.
2166     */
2167     function _burn(address account, uint256 value) internal virtual override {
2168         super._burn(account, value);
2169 
2170         int256 _pointsCorrection = pointsCorrection[account].add(
2171             (pointsPerShare.mul(value)).toInt256Safe()
2172         );
2173 
2174         pointsCorrection[account] = _pointsCorrection;
2175 
2176         emit PointsCorrectionUpdated(account, _pointsCorrection);
2177     }
2178 
2179     /**
2180         @dev Withdraws all available funds for a token holder.
2181     */
2182     function withdrawFunds() public virtual override {}
2183 
2184     /**
2185         @dev    Updates the current `fundsToken` balance and returns the difference of the new and previous `fundsToken` balance.
2186         @return A int256 representing the difference of the new and previous `fundsToken` balance.
2187     */
2188     function _updateFundsTokenBalance() internal virtual returns (int256) {}
2189 
2190     /**
2191         @dev Registers a payment of funds in tokens. May be called directly after a deposit is made.
2192         @dev Calls _updateFundsTokenBalance(), whereby the contract computes the delta of the new and previous
2193              `fundsToken` balance and increments the total received funds (cumulative), by delta, by calling _distributeFunds().
2194     */
2195     function updateFundsReceived() public virtual {
2196         int256 newFunds = _updateFundsTokenBalance();
2197 
2198         if (newFunds <= 0) return;
2199 
2200         _distributeFunds(newFunds.toUint256Safe());
2201     }
2202 }
2203 
2204 ////// contracts/token/ExtendedFDT.sol
2205 /* pragma solidity 0.6.11; */
2206 
2207 /* import "./BasicFDT.sol"; */
2208 
2209 /// @title ExtendedFDT implements FDT functionality for accounting for losses.
2210 abstract contract ExtendedFDT is BasicFDT {
2211     using SafeMath       for uint256;
2212     using SafeMathUint   for uint256;
2213     using SignedSafeMath for  int256;
2214     using SafeMathInt    for  int256;
2215 
2216     uint256 internal lossesPerShare;
2217 
2218     mapping(address => int256)  internal lossesCorrection;
2219     mapping(address => uint256) internal recognizedLosses;
2220 
2221     event   LossesPerShareUpdated(uint256 lossesPerShare);
2222     event LossesCorrectionUpdated(address indexed account, int256 lossesCorrection);
2223 
2224     /**
2225         @dev   This event emits when new losses are distributed.
2226         @param by                The address of the account that has distributed losses.
2227         @param lossesDistributed The amount of losses received for distribution.
2228     */
2229     event LossesDistributed(address indexed by, uint256 lossesDistributed);
2230 
2231     /**
2232         @dev   This event emits when distributed losses are recognized by a token holder.
2233         @param by                    The address of the receiver of losses.
2234         @param lossesRecognized      The amount of losses that were recognized.
2235         @param totalLossesRecognized The total amount of losses that are recognized.
2236     */
2237     event LossesRecognized(address indexed by, uint256 lossesRecognized, uint256 totalLossesRecognized);
2238 
2239     constructor(string memory name, string memory symbol) BasicFDT(name, symbol) public { }
2240 
2241     /**
2242         @dev Distributes losses to token holders.
2243         @dev It reverts if the total supply of tokens is 0.
2244         @dev It emits a `LossesDistributed` event if the amount of received losses is greater than 0.
2245         @dev It emits a `LossesPerShareUpdated` event if the amount of received losses is greater than 0.
2246              About undistributed losses:
2247                 In each distribution, there is a small amount of losses which do not get distributed,
2248                 which is `(value * pointsMultiplier) % totalSupply()`.
2249              With a well-chosen `pointsMultiplier`, the amount losses that are not getting distributed
2250                 in a distribution can be less than 1 (base unit).
2251              We can actually keep track of the undistributed losses in a distribution
2252                 and try to distribute it in the next distribution.
2253     */
2254     function _distributeLosses(uint256 value) internal {
2255         require(totalSupply() > 0, "FDT:ZERO_SUPPLY");
2256 
2257         if (value == 0) return;
2258 
2259         uint256 _lossesPerShare = lossesPerShare.add(value.mul(pointsMultiplier) / totalSupply());
2260         lossesPerShare          = _lossesPerShare;
2261 
2262         emit LossesDistributed(msg.sender, value);
2263         emit LossesPerShareUpdated(_lossesPerShare);
2264     }
2265 
2266     /**
2267         @dev    Prepares losses for a withdrawal.
2268         @dev    It emits a `LossesWithdrawn` event if the amount of withdrawn losses is greater than 0.
2269         @return recognizableDividend The amount of dividend losses that can be recognized.
2270     */
2271     function _prepareLossesWithdraw() internal returns (uint256 recognizableDividend) {
2272         recognizableDividend = recognizableLossesOf(msg.sender);
2273 
2274         uint256 _recognizedLosses    = recognizedLosses[msg.sender].add(recognizableDividend);
2275         recognizedLosses[msg.sender] = _recognizedLosses;
2276 
2277         emit LossesRecognized(msg.sender, recognizableDividend, _recognizedLosses);
2278     }
2279 
2280     /**
2281         @dev    Returns the amount of losses that an address can withdraw.
2282         @param  _owner The address of a token holder.
2283         @return The amount of losses that `_owner` can withdraw.
2284     */
2285     function recognizableLossesOf(address _owner) public view returns (uint256) {
2286         return accumulativeLossesOf(_owner).sub(recognizedLosses[_owner]);
2287     }
2288 
2289     /**
2290         @dev    Returns the amount of losses that an address has recognized.
2291         @param  _owner The address of a token holder
2292         @return The amount of losses that `_owner` has recognized
2293     */
2294     function recognizedLossesOf(address _owner) external view returns (uint256) {
2295         return recognizedLosses[_owner];
2296     }
2297 
2298     /**
2299         @dev    Returns the amount of losses that an address has earned in total.
2300         @dev    accumulativeLossesOf(_owner) = recognizableLossesOf(_owner) + recognizedLossesOf(_owner)
2301                 = (lossesPerShare * balanceOf(_owner) + lossesCorrection[_owner]) / pointsMultiplier
2302         @param  _owner The address of a token holder
2303         @return The amount of losses that `_owner` has earned in total
2304     */
2305     function accumulativeLossesOf(address _owner) public view returns (uint256) {
2306         return
2307             lossesPerShare
2308                 .mul(balanceOf(_owner))
2309                 .toInt256Safe()
2310                 .add(lossesCorrection[_owner])
2311                 .toUint256Safe() / pointsMultiplier;
2312     }
2313 
2314     /**
2315         @dev   Transfers tokens from one account to another. Updates pointsCorrection to keep funds unchanged.
2316         @dev         It emits two `LossesCorrectionUpdated` events, one for the sender and one for the receiver.
2317         @param from  The address to transfer from.
2318         @param to    The address to transfer to.
2319         @param value The amount to be transferred.
2320     */
2321     function _transfer(
2322         address from,
2323         address to,
2324         uint256 value
2325     ) internal virtual override {
2326         super._transfer(from, to, value);
2327 
2328         int256 _lossesCorrection    = lossesPerShare.mul(value).toInt256Safe();
2329         int256 lossesCorrectionFrom = lossesCorrection[from].add(_lossesCorrection);
2330         lossesCorrection[from]      = lossesCorrectionFrom;
2331         int256 lossesCorrectionTo   = lossesCorrection[to].sub(_lossesCorrection);
2332         lossesCorrection[to]        = lossesCorrectionTo;
2333 
2334         emit LossesCorrectionUpdated(from, lossesCorrectionFrom);
2335         emit LossesCorrectionUpdated(to,   lossesCorrectionTo);
2336     }
2337 
2338     /**
2339         @dev   Mints tokens to an account. Updates lossesCorrection to keep losses unchanged.
2340         @dev   It emits a `LossesCorrectionUpdated` event.
2341         @param account The account that will receive the created tokens.
2342         @param value   The amount that will be created.
2343     */
2344     function _mint(address account, uint256 value) internal virtual override {
2345         super._mint(account, value);
2346 
2347         int256 _lossesCorrection = lossesCorrection[account].sub(
2348             (lossesPerShare.mul(value)).toInt256Safe()
2349         );
2350 
2351         lossesCorrection[account] = _lossesCorrection;
2352 
2353         emit LossesCorrectionUpdated(account, _lossesCorrection);
2354     }
2355 
2356     /**
2357         @dev   Burns an amount of the token of a given account. Updates lossesCorrection to keep losses unchanged.
2358         @dev   It emits a `LossesCorrectionUpdated` event.
2359         @param account The account from which tokens will be burnt.
2360         @param value   The amount that will be burnt.
2361     */
2362     function _burn(address account, uint256 value) internal virtual override {
2363         super._burn(account, value);
2364 
2365         int256 _lossesCorrection = lossesCorrection[account].add(
2366             (lossesPerShare.mul(value)).toInt256Safe()
2367         );
2368 
2369         lossesCorrection[account] = _lossesCorrection;
2370 
2371         emit LossesCorrectionUpdated(account, _lossesCorrection);
2372     }
2373 
2374     /**
2375         @dev Registers a loss. May be called directly after a shortfall after BPT burning occurs.
2376         @dev Calls _updateLossesTokenBalance(), whereby the contract computes the delta of the new and previous
2377              losses balance and increments the total losses (cumulative), by delta, by calling _distributeLosses().
2378     */
2379     function updateLossesReceived() public virtual {
2380         int256 newLosses = _updateLossesBalance();
2381 
2382         if (newLosses <= 0) return;
2383 
2384         _distributeLosses(newLosses.toUint256Safe());
2385     }
2386 
2387     /**
2388         @dev Recognizes all recognizable losses for an account using loss accounting.
2389     */
2390     function _recognizeLosses() internal virtual returns (uint256 losses) { }
2391 
2392     /**
2393         @dev    Updates the current losses balance and returns the difference of the new and previous losses balance.
2394         @return A int256 representing the difference of the new and previous losses balance.
2395     */
2396     function _updateLossesBalance() internal virtual returns (int256) { }
2397 }
2398 
2399 ////// contracts/token/PoolFDT.sol
2400 /* pragma solidity 0.6.11; */
2401 
2402 /* import "./ExtendedFDT.sol"; */
2403 
2404 /// @title PoolFDT inherits ExtendedFDT and accounts for gains/losses for Liquidity Providers.
2405 abstract contract PoolFDT is ExtendedFDT {
2406     using SafeMath       for uint256;
2407     using SafeMathUint   for uint256;
2408     using SignedSafeMath for  int256;
2409     using SafeMathInt    for  int256;
2410 
2411     uint256 public interestSum;  // Sum of all withdrawable interest.
2412     uint256 public poolLosses;   // Sum of all unrecognized losses.
2413 
2414     uint256 public interestBalance;  // The amount of earned interest present and accounted for in this contract.
2415     uint256 public lossesBalance;    // The amount of losses present and accounted for in this contract.
2416 
2417     constructor(string memory name, string memory symbol) ExtendedFDT(name, symbol) public { }
2418 
2419     /**
2420         @dev Realizes losses incurred to LPs.
2421     */
2422     function _recognizeLosses() internal override returns (uint256 losses) {
2423         losses = _prepareLossesWithdraw();
2424 
2425         poolLosses = poolLosses.sub(losses);
2426 
2427         _updateLossesBalance();
2428     }
2429 
2430     /**
2431         @dev    Updates the current losses balance and returns the difference of the new and previous losses balance.
2432         @return A int256 representing the difference of the new and previous losses balance.
2433     */
2434     function _updateLossesBalance() internal override returns (int256) {
2435         uint256 _prevLossesTokenBalance = lossesBalance;
2436 
2437         lossesBalance = poolLosses;
2438 
2439         return int256(lossesBalance).sub(int256(_prevLossesTokenBalance));
2440     }
2441 
2442     /**
2443         @dev    Updates the current interest balance and returns the difference of the new and previous interest balance.
2444         @return A int256 representing the difference of the new and previous interest balance.
2445     */
2446     function _updateFundsTokenBalance() internal override returns (int256) {
2447         uint256 _prevFundsTokenBalance = interestBalance;
2448 
2449         interestBalance = interestSum;
2450 
2451         return int256(interestBalance).sub(int256(_prevFundsTokenBalance));
2452     }
2453 }
2454 
2455 ////// contracts/Pool.sol
2456 /* pragma solidity 0.6.11; */
2457 
2458 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol"; */
2459 
2460 /* import "./interfaces/IBPool.sol"; */
2461 /* import "./interfaces/IDebtLocker.sol"; */
2462 /* import "./interfaces/IMapleGlobals.sol"; */
2463 /* import "./interfaces/ILiquidityLocker.sol"; */
2464 /* import "./interfaces/ILiquidityLockerFactory.sol"; */
2465 /* import "./interfaces/ILoan.sol"; */
2466 /* import "./interfaces/ILoanFactory.sol"; */
2467 /* import "./interfaces/IPoolFactory.sol"; */
2468 /* import "./interfaces/IStakeLocker.sol"; */
2469 /* import "./interfaces/IStakeLockerFactory.sol"; */
2470 
2471 /* import "./library/PoolLib.sol"; */
2472 
2473 /* import "./token/PoolFDT.sol"; */
2474 
2475 /// @title Pool maintains all accounting and functionality related to Pools.
2476 contract Pool is PoolFDT {
2477 
2478     using SafeMath  for uint256;
2479     using SafeERC20 for IERC20;
2480 
2481     uint256 constant WAD = 10 ** 18;
2482 
2483     uint8 public constant DL_FACTORY = 1;  // Factory type of `DebtLockerFactory`.
2484 
2485     IERC20  public immutable liquidityAsset;  // The asset deposited by Lenders into the LiquidityLocker, for funding Loans.
2486 
2487     address public immutable poolDelegate;     // The Pool Delegate address, maintains full authority over the Pool.
2488     address public immutable liquidityLocker;  // The LiquidityLocker owned by this contract
2489     address public immutable stakeAsset;       // The address of the asset deposited by Stakers into the StakeLocker (BPTs), for liquidation during default events.
2490     address public immutable stakeLocker;      // The address of the StakeLocker, escrowing `stakeAsset`.
2491     address public immutable superFactory;     // The factory that deployed this Loan.
2492 
2493     uint256 private immutable liquidityAssetDecimals;  // The precision for the Liquidity Asset (i.e. `decimals()`).
2494 
2495     uint256 public           stakingFee;   // The fee Stakers earn            (in basis points).
2496     uint256 public immutable delegateFee;  // The fee the Pool Delegate earns (in basis points).
2497 
2498     uint256 public principalOut;  // The sum of all outstanding principal on Loans.
2499     uint256 public liquidityCap;  // The amount of liquidity tokens accepted by the Pool.
2500     uint256 public lockupPeriod;  // The period of time from an account's deposit date during which they cannot withdraw any funds.
2501 
2502     bool public openToPublic;  // Boolean opening Pool to public for LP deposits
2503 
2504     enum State { Initialized, Finalized, Deactivated }
2505     State public poolState;
2506 
2507     mapping(address => uint256)                     public depositDate;                // Used for withdraw penalty calculation.
2508     mapping(address => mapping(address => address)) public debtLockers;                // Address of the DebtLocker corresponding to `[Loan][DebtLockerFactory]`.
2509     mapping(address => bool)                        public poolAdmins;                 // The Pool Admin addresses that have permission to do certain operations in case of disaster management.
2510     mapping(address => bool)                        public allowedLiquidityProviders;  // Mapping that contains the list of addresses that have early access to the pool.
2511     mapping(address => uint256)                     public withdrawCooldown;           // The timestamp of when individual LPs have notified of their intent to withdraw.
2512     mapping(address => mapping(address => uint256)) public custodyAllowance;           // The amount of PoolFDTs that are "locked" at a certain address.
2513     mapping(address => uint256)                     public totalCustodyAllowance;      // The total amount of PoolFDTs that are "locked" for a given account. Cannot be greater than an account's balance.
2514 
2515     event                   LoanFunded(address indexed loan, address debtLocker, uint256 amountFunded);
2516     event                        Claim(address indexed loan, uint256 interest, uint256 principal, uint256 fee, uint256 stakeLockerPortion, uint256 poolDelegatePortion);
2517     event               BalanceUpdated(address indexed liquidityProvider, address indexed token, uint256 balance);
2518     event              CustodyTransfer(address indexed custodian, address indexed from, address indexed to, uint256 amount);
2519     event      CustodyAllowanceChanged(address indexed liquidityProvider, address indexed custodian, uint256 oldAllowance, uint256 newAllowance);
2520     event              LPStatusChanged(address indexed liquidityProvider, bool status);
2521     event              LiquidityCapSet(uint256 newLiquidityCap);
2522     event              LockupPeriodSet(uint256 newLockupPeriod);
2523     event                StakingFeeSet(uint256 newStakingFee);
2524     event             PoolStateChanged(State state);
2525     event                     Cooldown(address indexed liquidityProvider, uint256 cooldown);
2526     event           PoolOpenedToPublic(bool isOpen);
2527     event                 PoolAdminSet(address indexed poolAdmin, bool allowed);
2528     event           DepositDateUpdated(address indexed liquidityProvider, uint256 depositDate);
2529     event TotalCustodyAllowanceUpdated(address indexed liquidityProvider, uint256 newTotalAllowance);
2530     
2531     event DefaultSuffered(
2532         address indexed loan,
2533         uint256 defaultSuffered,
2534         uint256 bptsBurned,
2535         uint256 bptsReturned,
2536         uint256 liquidityAssetRecoveredFromBurn
2537     );
2538 
2539     /**
2540         Universal accounting law:
2541                                        fdtTotalSupply = liquidityLockerBal + principalOut - interestSum + poolLosses
2542             fdtTotalSupply + interestSum - poolLosses = liquidityLockerBal + principalOut
2543     */
2544 
2545     /**
2546         @dev   Constructor for a Pool.
2547         @dev   It emits a `PoolStateChanged` event.
2548         @param _poolDelegate   Address that has manager privileges of the Pool.
2549         @param _liquidityAsset Asset used to fund the Pool, It gets escrowed in LiquidityLocker.
2550         @param _stakeAsset     Asset escrowed in StakeLocker.
2551         @param _slFactory      Factory used to instantiate the StakeLocker.
2552         @param _llFactory      Factory used to instantiate the LiquidityLocker.
2553         @param _stakingFee     Fee that Stakers earn on interest, in basis points.
2554         @param _delegateFee    Fee that the Pool Delegate earns on interest, in basis points.
2555         @param _liquidityCap   Max amount of Liquidity Asset accepted by the Pool.
2556         @param name            Name of Pool token.
2557         @param symbol          Symbol of Pool token.
2558     */
2559     constructor(
2560         address _poolDelegate,
2561         address _liquidityAsset,
2562         address _stakeAsset,
2563         address _slFactory,
2564         address _llFactory,
2565         uint256 _stakingFee,
2566         uint256 _delegateFee,
2567         uint256 _liquidityCap,
2568         string memory name,
2569         string memory symbol
2570     ) PoolFDT(name, symbol) public {
2571 
2572         // Conduct sanity checks on Pool parameters.
2573         PoolLib.poolSanityChecks(_globals(msg.sender), _liquidityAsset, _stakeAsset, _stakingFee, _delegateFee);
2574 
2575         // Assign variables relating to the Liquidity Asset.
2576         liquidityAsset         = IERC20(_liquidityAsset);
2577         liquidityAssetDecimals = ERC20(_liquidityAsset).decimals();
2578 
2579         // Assign state variables.
2580         stakeAsset   = _stakeAsset;
2581         poolDelegate = _poolDelegate;
2582         stakingFee   = _stakingFee;
2583         delegateFee  = _delegateFee;
2584         superFactory = msg.sender;
2585         liquidityCap = _liquidityCap;
2586 
2587         // Instantiate the LiquidityLocker and the StakeLocker.
2588         stakeLocker     = address(IStakeLockerFactory(_slFactory).newLocker(_stakeAsset, _liquidityAsset));
2589         liquidityLocker = address(ILiquidityLockerFactory(_llFactory).newLocker(_liquidityAsset));
2590 
2591         lockupPeriod = 180 days;
2592 
2593         emit PoolStateChanged(State.Initialized);
2594     }
2595 
2596     /*******************************/
2597     /*** Pool Delegate Functions ***/
2598     /*******************************/
2599 
2600     /**
2601         @dev Finalizes the Pool, enabling deposits. Checks the amount the Pool Delegate deposited to the StakeLocker.
2602              Only the Pool Delegate can call this function.
2603         @dev It emits a `PoolStateChanged` event.
2604     */
2605     function finalize() external {
2606         _isValidDelegateAndProtocolNotPaused();
2607         _isValidState(State.Initialized);
2608         (,, bool stakeSufficient,,) = getInitialStakeRequirements();
2609         require(stakeSufficient, "P:INSUF_STAKE");
2610         poolState = State.Finalized;
2611         emit PoolStateChanged(poolState);
2612     }
2613 
2614     /**
2615         @dev   Funds a Loan for an amount, utilizing the supplied DebtLockerFactory for DebtLockers.
2616                Only the Pool Delegate can call this function.
2617         @dev   It emits a `LoanFunded` event.
2618         @dev   It emits a `BalanceUpdated` event.
2619         @param loan      Address of the Loan to fund.
2620         @param dlFactory Address of the DebtLockerFactory to utilize.
2621         @param amt       Amount to fund the Loan.
2622     */
2623     function fundLoan(address loan, address dlFactory, uint256 amt) external {
2624         _isValidDelegateAndProtocolNotPaused();
2625         _isValidState(State.Finalized);
2626         principalOut = principalOut.add(amt);
2627         PoolLib.fundLoan(debtLockers, superFactory, liquidityLocker, loan, dlFactory, amt);
2628         _emitBalanceUpdatedEvent();
2629     }
2630 
2631     /**
2632         @dev   Liquidates a Loan. The Pool Delegate could liquidate the Loan only when the Loan completes its grace period.
2633                The Pool Delegate can claim its proportion of recovered funds from the liquidation using the `claim()` function.
2634                Only the Pool Delegate can call this function.
2635         @param loan      Address of the Loan to liquidate.
2636         @param dlFactory Address of the DebtLockerFactory that is used to pull corresponding DebtLocker.
2637     */
2638     function triggerDefault(address loan, address dlFactory) external {
2639         _isValidDelegateAndProtocolNotPaused();
2640         IDebtLocker(debtLockers[loan][dlFactory]).triggerDefault();
2641     }
2642 
2643     /**
2644         @dev    Claims available funds for the Loan through a specified DebtLockerFactory. Only the Pool Delegate or a Pool Admin can call this function.
2645         @dev    It emits two `BalanceUpdated` events.
2646         @dev    It emits a `Claim` event.
2647         @param  loan      Address of the loan to claim from.
2648         @param  dlFactory Address of the DebtLockerFactory.
2649         @return claimInfo The claim details.
2650                     claimInfo [0] = Total amount claimed
2651                     claimInfo [1] = Interest  portion claimed
2652                     claimInfo [2] = Principal portion claimed
2653                     claimInfo [3] = Fee       portion claimed
2654                     claimInfo [4] = Excess    portion claimed
2655                     claimInfo [5] = Recovered portion claimed (from liquidations)
2656                     claimInfo [6] = Default suffered
2657     */
2658     function claim(address loan, address dlFactory) external returns (uint256[7] memory claimInfo) {
2659         _whenProtocolNotPaused();
2660         _isValidDelegateOrPoolAdmin();
2661         claimInfo = IDebtLocker(debtLockers[loan][dlFactory]).claim();
2662 
2663         (uint256 poolDelegatePortion, uint256 stakeLockerPortion, uint256 principalClaim, uint256 interestClaim) = PoolLib.calculateClaimAndPortions(claimInfo, delegateFee, stakingFee);
2664 
2665         // Subtract outstanding principal by the principal claimed plus excess returned.
2666         // Considers possible `principalClaim` overflow if Liquidity Asset is transferred directly into the Loan.
2667         if (principalClaim <= principalOut) {
2668             principalOut = principalOut - principalClaim;
2669         } else {
2670             interestClaim  = interestClaim.add(principalClaim - principalOut);  // Distribute `principalClaim` overflow as interest to LPs.
2671             principalClaim = principalOut;                                      // Set `principalClaim` to `principalOut` so correct amount gets transferred.
2672             principalOut   = 0;                                                 // Set `principalOut` to zero to avoid subtraction overflow.
2673         }
2674 
2675         // Accounts for rounding error in StakeLocker / Pool Delegate / LiquidityLocker interest split.
2676         interestSum = interestSum.add(interestClaim);
2677 
2678         _transferLiquidityAsset(poolDelegate, poolDelegatePortion);  // Transfer the fee and portion of interest to the Pool Delegate.
2679         _transferLiquidityAsset(stakeLocker,  stakeLockerPortion);   // Transfer the portion of interest to the StakeLocker.
2680 
2681         // Transfer remaining claim (remaining interest + principal + excess + recovered) to the LiquidityLocker.
2682         // Dust will accrue in the Pool, but this ensures that state variables are in sync with the LiquidityLocker balance updates.
2683         // Not using `balanceOf` in case of external address transferring the Liquidity Asset directly into Pool.
2684         // Ensures that internal accounting is exactly reflective of balance change.
2685         _transferLiquidityAsset(liquidityLocker, principalClaim.add(interestClaim));
2686 
2687         // Handle default if defaultSuffered > 0.
2688         if (claimInfo[6] > 0) _handleDefault(loan, claimInfo[6]);
2689 
2690         // Update funds received for StakeLockerFDTs.
2691         IStakeLocker(stakeLocker).updateFundsReceived();
2692 
2693         // Update funds received for PoolFDTs.
2694         updateFundsReceived();
2695 
2696         _emitBalanceUpdatedEvent();
2697         emit BalanceUpdated(stakeLocker, address(liquidityAsset), liquidityAsset.balanceOf(stakeLocker));
2698 
2699         emit Claim(loan, interestClaim, principalClaim, claimInfo[3], stakeLockerPortion, poolDelegatePortion);
2700     }
2701 
2702     /**
2703         @dev   Handles if a claim has been made and there is a non-zero defaultSuffered amount.
2704         @dev   It emits a `DefaultSuffered` event.
2705         @param loan            Address of a Loan that has defaulted.
2706         @param defaultSuffered Losses suffered from default after liquidation.
2707     */
2708     function _handleDefault(address loan, uint256 defaultSuffered) internal {
2709 
2710         (uint256 bptsBurned, uint256 postBurnBptBal, uint256 liquidityAssetRecoveredFromBurn) = PoolLib.handleDefault(liquidityAsset, stakeLocker, stakeAsset, defaultSuffered);
2711 
2712         // If BPT burn is not enough to cover full default amount, pass on losses to LPs with PoolFDT loss accounting.
2713         if (defaultSuffered > liquidityAssetRecoveredFromBurn) {
2714             poolLosses = poolLosses.add(defaultSuffered - liquidityAssetRecoveredFromBurn);
2715             updateLossesReceived();
2716         }
2717 
2718         // Transfer Liquidity Asset from burn to LiquidityLocker.
2719         liquidityAsset.safeTransfer(liquidityLocker, liquidityAssetRecoveredFromBurn);
2720 
2721         principalOut = principalOut.sub(defaultSuffered);  // Subtract rest of the Loan's principal from `principalOut`.
2722 
2723         emit DefaultSuffered(
2724             loan,                            // The Loan that suffered the default.
2725             defaultSuffered,                 // Total default suffered from the Loan by the Pool after liquidation.
2726             bptsBurned,                      // Amount of BPTs burned from StakeLocker.
2727             postBurnBptBal,                  // Remaining BPTs in StakeLocker post-burn.
2728             liquidityAssetRecoveredFromBurn  // Amount of Liquidity Asset recovered from burning BPTs.
2729         );
2730     }
2731 
2732     /**
2733         @dev Triggers deactivation, permanently shutting down the Pool. Must have less than 100 USD worth of Liquidity Asset `principalOut`.
2734              Only the Pool Delegate can call this function.
2735         @dev It emits a `PoolStateChanged` event.
2736     */
2737     function deactivate() external {
2738         _isValidDelegateAndProtocolNotPaused();
2739         _isValidState(State.Finalized);
2740         PoolLib.validateDeactivation(_globals(superFactory), principalOut, address(liquidityAsset));
2741         poolState = State.Deactivated;
2742         emit PoolStateChanged(poolState);
2743     }
2744 
2745     /**************************************/
2746     /*** Pool Delegate Setter Functions ***/
2747     /**************************************/
2748 
2749     /**
2750         @dev   Sets the liquidity cap. Only the Pool Delegate or a Pool Admin can call this function.
2751         @dev   It emits a `LiquidityCapSet` event.
2752         @param newLiquidityCap New liquidity cap value.
2753     */
2754     function setLiquidityCap(uint256 newLiquidityCap) external {
2755         _whenProtocolNotPaused();
2756         _isValidDelegateOrPoolAdmin();
2757         liquidityCap = newLiquidityCap;
2758         emit LiquidityCapSet(newLiquidityCap);
2759     }
2760 
2761     /**
2762         @dev   Sets the lockup period. Only the Pool Delegate can call this function.
2763         @dev   It emits a `LockupPeriodSet` event.
2764         @param newLockupPeriod New lockup period used to restrict the withdrawals.
2765     */
2766     function setLockupPeriod(uint256 newLockupPeriod) external {
2767         _isValidDelegateAndProtocolNotPaused();
2768         require(newLockupPeriod <= lockupPeriod, "P:BAD_VALUE");
2769         lockupPeriod = newLockupPeriod;
2770         emit LockupPeriodSet(newLockupPeriod);
2771     }
2772 
2773     /**
2774         @dev   Sets the staking fee. Only the Pool Delegate can call this function.
2775         @dev   It emits a `StakingFeeSet` event.
2776         @param newStakingFee New staking fee.
2777     */
2778     function setStakingFee(uint256 newStakingFee) external {
2779         _isValidDelegateAndProtocolNotPaused();
2780         require(newStakingFee.add(delegateFee) <= 10_000, "P:BAD_FEE");
2781         stakingFee = newStakingFee;
2782         emit StakingFeeSet(newStakingFee);
2783     }
2784 
2785     /**
2786         @dev   Sets the account status in the Pool's allowlist. Only the Pool Delegate can call this function.
2787         @dev   It emits an `LPStatusChanged` event.
2788         @param account The address to set status for.
2789         @param status  The status of an account in the allowlist.
2790     */
2791     function setAllowList(address account, bool status) external {
2792         _isValidDelegateAndProtocolNotPaused();
2793         allowedLiquidityProviders[account] = status;
2794         emit LPStatusChanged(account, status);
2795     }
2796 
2797     /**
2798         @dev   Sets a Pool Admin. Only the Pool Delegate can call this function.
2799         @dev   It emits a `PoolAdminSet` event.
2800         @param poolAdmin An address being allowed or disallowed as a Pool Admin.
2801         @param allowed Status of a Pool Admin.
2802     */
2803     function setPoolAdmin(address poolAdmin, bool allowed) external {
2804         _isValidDelegateAndProtocolNotPaused();
2805         poolAdmins[poolAdmin] = allowed;
2806         emit PoolAdminSet(poolAdmin, allowed);
2807     }
2808 
2809     /**
2810         @dev   Sets whether the Pool is open to the public. Only the Pool Delegate can call this function.
2811         @dev   It emits a `PoolOpenedToPublic` event.
2812         @param open Public pool access status.
2813     */
2814     function setOpenToPublic(bool open) external {
2815         _isValidDelegateAndProtocolNotPaused();
2816         openToPublic = open;
2817         emit PoolOpenedToPublic(open);
2818     }
2819 
2820     /************************************/
2821     /*** Liquidity Provider Functions ***/
2822     /************************************/
2823 
2824     /**
2825         @dev   Handles Liquidity Providers depositing of Liquidity Asset into the LiquidityLocker, minting PoolFDTs.
2826         @dev   It emits a `DepositDateUpdated` event.
2827         @dev   It emits a `BalanceUpdated` event.
2828         @dev   It emits a `Cooldown` event.
2829         @param amt Amount of Liquidity Asset to deposit.
2830     */
2831     function deposit(uint256 amt) external {
2832         _whenProtocolNotPaused();
2833         _isValidState(State.Finalized);
2834         require(isDepositAllowed(amt), "P:DEP_NOT_ALLOWED");
2835 
2836         withdrawCooldown[msg.sender] = uint256(0);  // Reset the LP's withdraw cooldown if they had previously intended to withdraw.
2837 
2838         uint256 wad = _toWad(amt);
2839         PoolLib.updateDepositDate(depositDate, balanceOf(msg.sender), wad, msg.sender);
2840 
2841         liquidityAsset.safeTransferFrom(msg.sender, liquidityLocker, amt);
2842         _mint(msg.sender, wad);
2843 
2844         _emitBalanceUpdatedEvent();
2845         emit Cooldown(msg.sender, uint256(0));
2846     }
2847 
2848     /**
2849         @dev Activates the cooldown period to withdraw. It can't be called if the account is not providing liquidity.
2850         @dev It emits a `Cooldown` event.
2851     **/
2852     function intendToWithdraw() external {
2853         require(balanceOf(msg.sender) != uint256(0), "P:ZERO_BAL");
2854         withdrawCooldown[msg.sender] = block.timestamp;
2855         emit Cooldown(msg.sender, block.timestamp);
2856     }
2857 
2858     /**
2859         @dev Cancels an initiated withdrawal by resetting the account's withdraw cooldown.
2860         @dev It emits a `Cooldown` event.
2861     **/
2862     function cancelWithdraw() external {
2863         require(withdrawCooldown[msg.sender] != uint256(0), "P:NOT_WITHDRAWING");
2864         withdrawCooldown[msg.sender] = uint256(0);
2865         emit Cooldown(msg.sender, uint256(0));
2866     }
2867 
2868     /**
2869         @dev   Checks that the account can withdraw an amount.
2870         @param account The address of the account.
2871         @param wad     The amount to withdraw.
2872     */
2873     function _canWithdraw(address account, uint256 wad) internal view {
2874         require(depositDate[account].add(lockupPeriod) <= block.timestamp,     "P:FUNDS_LOCKED");     // Restrict withdrawal during lockup period
2875         require(balanceOf(account).sub(wad) >= totalCustodyAllowance[account], "P:INSUF_TRANS_BAL");  // Account can only withdraw tokens that aren't custodied
2876     }
2877 
2878     /**
2879         @dev   Handles Liquidity Providers withdrawing of Liquidity Asset from the LiquidityLocker, burning PoolFDTs.
2880         @dev   It emits two `BalanceUpdated` event.
2881         @param amt Amount of Liquidity Asset to withdraw.
2882     */
2883     function withdraw(uint256 amt) external {
2884         _whenProtocolNotPaused();
2885         uint256 wad = _toWad(amt);
2886         (uint256 lpCooldownPeriod, uint256 lpWithdrawWindow) = _globals(superFactory).getLpCooldownParams();
2887 
2888         _canWithdraw(msg.sender, wad);
2889         require((block.timestamp - (withdrawCooldown[msg.sender] + lpCooldownPeriod)) <= lpWithdrawWindow, "P:WITHDRAW_NOT_ALLOWED");
2890 
2891         _burn(msg.sender, wad);  // Burn the corresponding PoolFDTs balance.
2892         withdrawFunds();         // Transfer full entitled interest, decrement `interestSum`.
2893 
2894         // Transfer amount that is due after realized losses are accounted for.
2895         // Recognized losses are absorbed by the LP.
2896         _transferLiquidityLockerFunds(msg.sender, amt.sub(_recognizeLosses()));
2897 
2898         _emitBalanceUpdatedEvent();
2899     }
2900 
2901     /**
2902         @dev   Transfers PoolFDTs.
2903         @param from Address sending   PoolFDTs.
2904         @param to   Address receiving PoolFDTs.
2905         @param wad  Amount of PoolFDTs to transfer.
2906     */
2907     function _transfer(address from, address to, uint256 wad) internal override {
2908         _whenProtocolNotPaused();
2909 
2910         (uint256 lpCooldownPeriod, uint256 lpWithdrawWindow) = _globals(superFactory).getLpCooldownParams();
2911 
2912         _canWithdraw(from, wad);
2913         require(block.timestamp > (withdrawCooldown[to] + lpCooldownPeriod + lpWithdrawWindow), "P:TO_NOT_ALLOWED");  // Recipient must not be currently withdrawing.
2914         require(recognizableLossesOf(from) == uint256(0),                                       "P:RECOG_LOSSES");    // If an LP has unrecognized losses, they must recognize losses using `withdraw`.
2915 
2916         PoolLib.updateDepositDate(depositDate, balanceOf(to), wad, to);
2917         super._transfer(from, to, wad);
2918     }
2919 
2920     /**
2921         @dev Withdraws all claimable interest from the LiquidityLocker for an account using `interestSum` accounting.
2922         @dev It emits a `BalanceUpdated` event.
2923     */
2924     function withdrawFunds() public override {
2925         _whenProtocolNotPaused();
2926         uint256 withdrawableFunds = _prepareWithdraw();
2927 
2928         if (withdrawableFunds == uint256(0)) return;
2929 
2930         _transferLiquidityLockerFunds(msg.sender, withdrawableFunds);
2931         _emitBalanceUpdatedEvent();
2932 
2933         interestSum = interestSum.sub(withdrawableFunds);
2934 
2935         _updateFundsTokenBalance();
2936     }
2937 
2938     /**
2939         @dev   Increases the custody allowance for a given Custodian corresponding to the calling account (`msg.sender`).
2940         @dev   It emits a `CustodyAllowanceChanged` event.
2941         @dev   It emits a `TotalCustodyAllowanceUpdated` event.
2942         @param custodian Address which will act as Custodian of a given amount for an account.
2943         @param amount    Number of additional FDTs to be custodied by the Custodian.
2944     */
2945     function increaseCustodyAllowance(address custodian, uint256 amount) external {
2946         uint256 oldAllowance      = custodyAllowance[msg.sender][custodian];
2947         uint256 newAllowance      = oldAllowance.add(amount);
2948         uint256 newTotalAllowance = totalCustodyAllowance[msg.sender].add(amount);
2949 
2950         PoolLib.increaseCustodyAllowanceChecks(custodian, amount, newTotalAllowance, balanceOf(msg.sender));
2951 
2952         custodyAllowance[msg.sender][custodian] = newAllowance;
2953         totalCustodyAllowance[msg.sender]       = newTotalAllowance;
2954         emit CustodyAllowanceChanged(msg.sender, custodian, oldAllowance, newAllowance);
2955         emit TotalCustodyAllowanceUpdated(msg.sender, newTotalAllowance);
2956     }
2957 
2958     /**
2959         @dev   Transfers custodied PoolFDTs back to the account.
2960         @dev   `from` and `to` should always be equal in this implementation.
2961         @dev   This means that the Custodian can only decrease their own allowance and unlock funds for the original owner.
2962         @dev   It emits a `CustodyTransfer` event.
2963         @dev   It emits a `CustodyAllowanceChanged` event.
2964         @dev   It emits a `TotalCustodyAllowanceUpdated` event.
2965         @param from   Address which holds the PoolFDTs.
2966         @param to     Address which will be the new owner of the amount of PoolFDTs.
2967         @param amount Amount of PoolFDTs transferred.
2968     */
2969     function transferByCustodian(address from, address to, uint256 amount) external {
2970         uint256 oldAllowance = custodyAllowance[from][msg.sender];
2971         uint256 newAllowance = oldAllowance.sub(amount);
2972 
2973         PoolLib.transferByCustodianChecks(from, to, amount);
2974 
2975         custodyAllowance[from][msg.sender] = newAllowance;
2976         uint256 newTotalAllowance          = totalCustodyAllowance[from].sub(amount);
2977         totalCustodyAllowance[from]        = newTotalAllowance;
2978         emit CustodyTransfer(msg.sender, from, to, amount);
2979         emit CustodyAllowanceChanged(from, msg.sender, oldAllowance, newAllowance);
2980         emit TotalCustodyAllowanceUpdated(msg.sender, newTotalAllowance);
2981     }
2982 
2983     /**************************/
2984     /*** Governor Functions ***/
2985     /**************************/
2986 
2987     /**
2988         @dev   Transfers any locked funds to the Governor. Only the Governor can call this function.
2989         @param token Address of the token to be reclaimed.
2990     */
2991     function reclaimERC20(address token) external {
2992         PoolLib.reclaimERC20(token, address(liquidityAsset), _globals(superFactory));
2993     }
2994 
2995     /*************************/
2996     /*** Getter Functions ***/
2997     /*************************/
2998 
2999     /**
3000         @dev    Calculates the value of BPT in units of Liquidity Asset.
3001         @param  _bPool          Address of Balancer pool.
3002         @param  _liquidityAsset Asset used by Pool for liquidity to fund Loans.
3003         @param  _staker         Address that deposited BPTs to StakeLocker.
3004         @param  _stakeLocker    Escrows BPTs deposited by Staker.
3005         @return USDC value of staker BPTs.
3006     */
3007     function BPTVal(
3008         address _bPool,
3009         address _liquidityAsset,
3010         address _staker,
3011         address _stakeLocker
3012     ) external view returns (uint256) {
3013         return PoolLib.BPTVal(_bPool, _liquidityAsset, _staker, _stakeLocker);
3014     }
3015 
3016     /**
3017         @dev   Checks that the given deposit amount is acceptable based on current liquidityCap.
3018         @param depositAmt Amount of tokens (i.e liquidityAsset type) the account is trying to deposit.
3019     */
3020     function isDepositAllowed(uint256 depositAmt) public view returns (bool) {
3021         return (openToPublic || allowedLiquidityProviders[msg.sender]) &&
3022                _balanceOfLiquidityLocker().add(principalOut).add(depositAmt) <= liquidityCap;
3023     }
3024 
3025     /**
3026         @dev    Returns information on the stake requirements.
3027         @return [0] = Min amount of Liquidity Asset coverage from staking required.
3028                 [1] = Present amount of Liquidity Asset coverage from the Pool Delegate stake.
3029                 [2] = If enough stake is present from the Pool Delegate for finalization.
3030                 [3] = Staked BPTs required for minimum Liquidity Asset coverage.
3031                 [4] = Current staked BPTs.
3032     */
3033     function getInitialStakeRequirements() public view returns (uint256, uint256, bool, uint256, uint256) {
3034         return PoolLib.getInitialStakeRequirements(_globals(superFactory), stakeAsset, address(liquidityAsset), poolDelegate, stakeLocker);
3035     }
3036 
3037     /**
3038         @dev    Calculates BPTs required if burning BPTs for the Liquidity Asset, given supplied `tokenAmountOutRequired`.
3039         @param  _bPool                        The Balancer pool that issues the BPTs.
3040         @param  _liquidityAsset               Swap out asset (e.g. USDC) to receive when burning BPTs.
3041         @param  _staker                       Address that deposited BPTs to StakeLocker.
3042         @param  _stakeLocker                  Escrows BPTs deposited by Staker.
3043         @param  _liquidityAssetAmountRequired Amount of Liquidity Asset required to recover.
3044         @return [0] = poolAmountIn required.
3045                 [1] = poolAmountIn currently staked.
3046     */
3047     function getPoolSharesRequired(
3048         address _bPool,
3049         address _liquidityAsset,
3050         address _staker,
3051         address _stakeLocker,
3052         uint256 _liquidityAssetAmountRequired
3053     ) external view returns (uint256, uint256) {
3054         return PoolLib.getPoolSharesRequired(_bPool, _liquidityAsset, _staker, _stakeLocker, _liquidityAssetAmountRequired);
3055     }
3056 
3057     /**
3058       @dev    Checks that the Pool state is `Finalized`.
3059       @return bool Boolean value indicating if Pool is in a Finalized state.
3060     */
3061     function isPoolFinalized() external view returns (bool) {
3062         return poolState == State.Finalized;
3063     }
3064 
3065     /************************/
3066     /*** Helper Functions ***/
3067     /************************/
3068 
3069     /**
3070         @dev   Converts to WAD precision.
3071         @param amt Amount to convert.
3072     */
3073     function _toWad(uint256 amt) internal view returns (uint256) {
3074         return amt.mul(WAD).div(10 ** liquidityAssetDecimals);
3075     }
3076 
3077     /**
3078         @dev    Returns the balance of this Pool's LiquidityLocker.
3079         @return Balance of LiquidityLocker.
3080     */
3081     function _balanceOfLiquidityLocker() internal view returns (uint256) {
3082         return liquidityAsset.balanceOf(liquidityLocker);
3083     }
3084 
3085     /**
3086         @dev   Checks that the current state of Pool matches the provided state.
3087         @param _state Enum of desired Pool state.
3088     */
3089     function _isValidState(State _state) internal view {
3090         require(poolState == _state, "P:BAD_STATE");
3091     }
3092 
3093     /**
3094         @dev Checks that `msg.sender` is the Pool Delegate.
3095     */
3096     function _isValidDelegate() internal view {
3097         require(msg.sender == poolDelegate, "P:NOT_DEL");
3098     }
3099 
3100     /**
3101         @dev Returns the MapleGlobals instance.
3102     */
3103     function _globals(address poolFactory) internal view returns (IMapleGlobals) {
3104         return IMapleGlobals(IPoolFactory(poolFactory).globals());
3105     }
3106 
3107     /**
3108         @dev Emits a `BalanceUpdated` event for LiquidityLocker.
3109         @dev It emits a `BalanceUpdated` event.
3110     */
3111     function _emitBalanceUpdatedEvent() internal {
3112         emit BalanceUpdated(liquidityLocker, address(liquidityAsset), _balanceOfLiquidityLocker());
3113     }
3114 
3115     /**
3116         @dev   Transfers Liquidity Asset to given `to` address, from self (i.e. `address(this)`).
3117         @param to    Address to transfer liquidityAsset.
3118         @param value Amount of liquidity asset that gets transferred.
3119     */
3120     function _transferLiquidityAsset(address to, uint256 value) internal {
3121         liquidityAsset.safeTransfer(to, value);
3122     }
3123 
3124     /**
3125         @dev Checks that `msg.sender` is the Pool Delegate or a Pool Admin.
3126     */
3127     function _isValidDelegateOrPoolAdmin() internal view {
3128         require(msg.sender == poolDelegate || poolAdmins[msg.sender], "P:NOT_DEL_OR_ADMIN");
3129     }
3130 
3131     /**
3132         @dev Checks that the protocol is not in a paused state.
3133     */
3134     function _whenProtocolNotPaused() internal view {
3135         require(!_globals(superFactory).protocolPaused(), "P:PROTO_PAUSED");
3136     }
3137 
3138     /**
3139         @dev Checks that `msg.sender` is the Pool Delegate and that the protocol is not in a paused state.
3140     */
3141     function _isValidDelegateAndProtocolNotPaused() internal view {
3142         _isValidDelegate();
3143         _whenProtocolNotPaused();
3144     }
3145 
3146     function _transferLiquidityLockerFunds(address to, uint256 value) internal {
3147         ILiquidityLocker(liquidityLocker).transfer(to, value);
3148     }
3149 
3150 }
