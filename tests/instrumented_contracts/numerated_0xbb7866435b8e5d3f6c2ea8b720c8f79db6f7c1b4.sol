1 // SPDX-License-Identifier:  AGPL-3.0-or-later // hevm: flattened sources of contracts/StakeLocker.sol
2 pragma solidity =0.6.11 >=0.6.0 <0.8.0 >=0.6.2 <0.8.0;
3 
4 ////// contracts/interfaces/IMapleGlobals.sol
5 /* pragma solidity 0.6.11; */
6 
7 interface IMapleGlobals {
8 
9     function pendingGovernor() external view returns (address);
10 
11     function governor() external view returns (address);
12 
13     function globalAdmin() external view returns (address);
14 
15     function mpl() external view returns (address);
16 
17     function mapleTreasury() external view returns (address);
18 
19     function isValidBalancerPool(address) external view returns (bool);
20 
21     function treasuryFee() external view returns (uint256);
22 
23     function investorFee() external view returns (uint256);
24 
25     function defaultGracePeriod() external view returns (uint256);
26 
27     function fundingPeriod() external view returns (uint256);
28 
29     function swapOutRequired() external view returns (uint256);
30 
31     function isValidLiquidityAsset(address) external view returns (bool);
32 
33     function isValidCollateralAsset(address) external view returns (bool);
34 
35     function isValidPoolDelegate(address) external view returns (bool);
36 
37     function validCalcs(address) external view returns (bool);
38 
39     function isValidCalc(address, uint8) external view returns (bool);
40 
41     function getLpCooldownParams() external view returns (uint256, uint256);
42 
43     function isValidLoanFactory(address) external view returns (bool);
44 
45     function isValidSubFactory(address, address, uint8) external view returns (bool);
46 
47     function isValidPoolFactory(address) external view returns (bool);
48     
49     function getLatestPrice(address) external view returns (uint256);
50     
51     function defaultUniswapPath(address, address) external view returns (address);
52 
53     function minLoanEquity() external view returns (uint256);
54     
55     function maxSwapSlippage() external view returns (uint256);
56 
57     function protocolPaused() external view returns (bool);
58 
59     function stakerCooldownPeriod() external view returns (uint256);
60 
61     function lpCooldownPeriod() external view returns (uint256);
62 
63     function stakerUnstakeWindow() external view returns (uint256);
64 
65     function lpWithdrawWindow() external view returns (uint256);
66 
67     function oracleFor(address) external view returns (address);
68 
69     function validSubFactories(address, address) external view returns (bool);
70 
71     function setStakerCooldownPeriod(uint256) external;
72 
73     function setLpCooldownPeriod(uint256) external;
74 
75     function setStakerUnstakeWindow(uint256) external;
76 
77     function setLpWithdrawWindow(uint256) external;
78 
79     function setMaxSwapSlippage(uint256) external;
80 
81     function setGlobalAdmin(address) external;
82 
83     function setValidBalancerPool(address, bool) external;
84 
85     function setProtocolPause(bool) external;
86 
87     function setValidPoolFactory(address, bool) external;
88 
89     function setValidLoanFactory(address, bool) external;
90 
91     function setValidSubFactory(address, address, bool) external;
92 
93     function setDefaultUniswapPath(address, address, address) external;
94 
95     function setPoolDelegateAllowlist(address, bool) external;
96 
97     function setCollateralAsset(address, bool) external;
98 
99     function setLiquidityAsset(address, bool) external;
100 
101     function setCalc(address, bool) external;
102 
103     function setInvestorFee(uint256) external;
104 
105     function setTreasuryFee(uint256) external;
106 
107     function setMapleTreasury(address) external;
108 
109     function setDefaultGracePeriod(uint256) external;
110 
111     function setMinLoanEquity(uint256) external;
112 
113     function setFundingPeriod(uint256) external;
114 
115     function setSwapOutRequired(uint256) external;
116 
117     function setPriceOracle(address, address) external;
118 
119     function setPendingGovernor(address) external;
120 
121     function acceptGovernor() external;
122 
123 }
124 
125 ////// contracts/token/interfaces/IBaseFDT.sol
126 /* pragma solidity 0.6.11; */
127 
128 interface IBaseFDT {
129 
130     /**
131         @dev    Returns the total amount of funds a given address is able to withdraw currently.
132         @param  owner Address of FDT holder.
133         @return A uint256 representing the available funds for a given account.
134     */
135     function withdrawableFundsOf(address owner) external view returns (uint256);
136 
137     /**
138         @dev Withdraws all available funds for a FDT holder.
139     */
140     function withdrawFunds() external;
141 
142     /**
143         @dev   This event emits when new funds are distributed.
144         @param by               The address of the sender that distributed funds.
145         @param fundsDistributed The amount of funds received for distribution.
146     */
147     event FundsDistributed(address indexed by, uint256 fundsDistributed);
148 
149     /**
150         @dev   This event emits when distributed funds are withdrawn by a token holder.
151         @param by             The address of the receiver of funds.
152         @param fundsWithdrawn The amount of funds that were withdrawn.
153         @param totalWithdrawn The total amount of funds that were withdrawn.
154     */
155     event FundsWithdrawn(address indexed by, uint256 fundsWithdrawn, uint256 totalWithdrawn);
156 
157 }
158 
159 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
160 /* pragma solidity >=0.6.0 <0.8.0; */
161 
162 /**
163  * @dev Interface of the ERC20 standard as defined in the EIP.
164  */
165 interface IERC20 {
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 value);
228 
229     /**
230      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
231      * a call to {approve}. `value` is the new allowance.
232      */
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 ////// contracts/token/interfaces/IBasicFDT.sol
237 /* pragma solidity 0.6.11; */
238 
239 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
240 
241 /* import "./IBaseFDT.sol"; */
242 
243 interface IBasicFDT is IBaseFDT, IERC20 {
244 
245     event PointsPerShareUpdated(uint256);
246 
247     event PointsCorrectionUpdated(address indexed, int256);
248 
249     function withdrawnFundsOf(address) external view returns (uint256);
250 
251     function accumulativeFundsOf(address) external view returns (uint256);
252 
253     function updateFundsReceived() external;
254 
255 }
256 
257 ////// contracts/token/interfaces/IExtendedFDT.sol
258 /* pragma solidity 0.6.11; */
259 
260 /* import "./IBasicFDT.sol"; */
261 
262 interface IExtendedFDT is IBasicFDT {
263 
264     event LossesPerShareUpdated(uint256);
265 
266     event LossesCorrectionUpdated(address indexed, int256);
267 
268     event LossesDistributed(address indexed, uint256);
269 
270     event LossesRecognized(address indexed, uint256, uint256);
271 
272     function lossesPerShare() external view returns (uint256);
273 
274     function recognizableLossesOf(address) external view returns (uint256);
275 
276     function recognizedLossesOf(address) external view returns (uint256);
277 
278     function accumulativeLossesOf(address) external view returns (uint256);
279 
280     function updateLossesReceived() external;
281 
282 }
283 
284 ////// contracts/token/interfaces/IPoolFDT.sol
285 /* pragma solidity 0.6.11; */
286 
287 /* import "./IExtendedFDT.sol"; */
288 
289 interface IPoolFDT is IExtendedFDT {
290 
291     function interestSum() external view returns (uint256);
292 
293     function poolLosses() external view returns (uint256);
294 
295     function interestBalance() external view returns (uint256);
296 
297     function lossesBalance() external view returns (uint256);
298 
299 }
300 
301 ////// contracts/interfaces/IPool.sol
302 /* pragma solidity 0.6.11; */
303 
304 /* import "../token/interfaces/IPoolFDT.sol"; */
305 
306 interface IPool is IPoolFDT {
307 
308     function poolDelegate() external view returns (address);
309 
310     function poolAdmins(address) external view returns (bool);
311 
312     function deposit(uint256) external;
313 
314     function increaseCustodyAllowance(address, uint256) external;
315 
316     function transferByCustodian(address, address, uint256) external;
317 
318     function poolState() external view returns (uint256);
319 
320     function deactivate() external;
321 
322     function finalize() external;
323 
324     function claim(address, address) external returns (uint256[7] memory);
325 
326     function setLockupPeriod(uint256) external;
327     
328     function setStakingFee(uint256) external;
329 
330     function setPoolAdmin(address, bool) external;
331 
332     function fundLoan(address, address, uint256) external;
333 
334     function withdraw(uint256) external;
335 
336     function superFactory() external view returns (address);
337 
338     function triggerDefault(address, address) external;
339 
340     function isPoolFinalized() external view returns (bool);
341 
342     function setOpenToPublic(bool) external;
343 
344     function setAllowList(address, bool) external;
345 
346     function allowedLiquidityProviders(address) external view returns (bool);
347 
348     function openToPublic() external view returns (bool);
349 
350     function intendToWithdraw() external;
351 
352     function DL_FACTORY() external view returns (uint8);
353 
354     function liquidityAsset() external view returns (address);
355 
356     function liquidityLocker() external view returns (address);
357 
358     function stakeAsset() external view returns (address);
359 
360     function stakeLocker() external view returns (address);
361 
362     function stakingFee() external view returns (uint256);
363 
364     function delegateFee() external view returns (uint256);
365 
366     function principalOut() external view returns (uint256);
367 
368     function liquidityCap() external view returns (uint256);
369 
370     function lockupPeriod() external view returns (uint256);
371 
372     function depositDate(address) external view returns (uint256);
373 
374     function debtLockers(address, address) external view returns (address);
375 
376     function withdrawCooldown(address) external view returns (uint256);
377 
378     function setLiquidityCap(uint256) external;
379 
380     function cancelWithdraw() external;
381 
382     function reclaimERC20(address) external;
383 
384     function BPTVal(address, address, address, address) external view returns (uint256);
385 
386     function isDepositAllowed(uint256) external view returns (bool);
387 
388     function getInitialStakeRequirements() external view returns (uint256, uint256, bool, uint256, uint256);
389 
390 }
391 
392 ////// contracts/interfaces/IPoolFactory.sol
393 /* pragma solidity 0.6.11; */
394 
395 interface IPoolFactory {
396 
397     function LL_FACTORY() external view returns (uint8);
398 
399     function SL_FACTORY() external view returns (uint8);
400 
401     function poolsCreated() external view returns (uint256);
402 
403     function globals() external view returns (address);
404 
405     function pools(uint256) external view returns (address);
406 
407     function isPool(address) external view returns (bool);
408 
409     function poolFactoryAdmins(address) external view returns (bool);
410 
411     function setGlobals(address) external;
412 
413     function createPool(address, address, address, address, uint256, uint256, uint256) external returns (address);
414 
415     function setPoolFactoryAdmin(address, bool) external;
416 
417     function pause() external;
418 
419     function unpause() external;
420 
421 }
422 
423 ////// contracts/math/SafeMathInt.sol
424 /* pragma solidity 0.6.11; */
425 
426 library SafeMathInt {
427     function toUint256Safe(int256 a) internal pure returns (uint256) {
428         require(a >= 0, "SMI:NEG");
429         return uint256(a);
430     }
431 }
432 
433 ////// contracts/math/SafeMathUint.sol
434 /* pragma solidity 0.6.11; */
435 
436 library SafeMathUint {
437     function toInt256Safe(uint256 a) internal pure returns (int256 b) {
438         b = int256(a);
439         require(b >= 0, "SMU:OOB");
440     }
441 }
442 
443 ////// lib/openzeppelin-contracts/contracts/math/SafeMath.sol
444 /* pragma solidity >=0.6.0 <0.8.0; */
445 
446 /**
447  * @dev Wrappers over Solidity's arithmetic operations with added overflow
448  * checks.
449  *
450  * Arithmetic operations in Solidity wrap on overflow. This can easily result
451  * in bugs, because programmers usually assume that an overflow raises an
452  * error, which is the standard behavior in high level programming languages.
453  * `SafeMath` restores this intuition by reverting the transaction when an
454  * operation overflows.
455  *
456  * Using this library instead of the unchecked operations eliminates an entire
457  * class of bugs, so it's recommended to use it always.
458  */
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      *
468      * - Addition cannot overflow.
469      */
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473 
474         return c;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's `-` operator.
482      *
483      * Requirements:
484      *
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         return sub(a, b, "SafeMath: subtraction overflow");
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         uint256 c = a - b;
504 
505         return c;
506     }
507 
508     /**
509      * @dev Returns the multiplication of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `*` operator.
513      *
514      * Requirements:
515      *
516      * - Multiplication cannot overflow.
517      */
518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
519         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520         // benefit is lost if 'b' is also tested.
521         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
522         if (a == 0) {
523             return 0;
524         }
525 
526         uint256 c = a * b;
527         require(c / a == b, "SafeMath: multiplication overflow");
528 
529         return c;
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         return div(a, b, "SafeMath: division by zero");
546     }
547 
548     /**
549      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
550      * division by zero. The result is rounded towards zero.
551      *
552      * Counterpart to Solidity's `/` operator. Note: this function uses a
553      * `revert` opcode (which leaves remaining gas untouched) while Solidity
554      * uses an invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
561         require(b > 0, errorMessage);
562         uint256 c = a / b;
563         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
581         return mod(a, b, "SafeMath: modulo by zero");
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * Reverts with custom message when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b != 0, errorMessage);
598         return a % b;
599     }
600 }
601 
602 ////// lib/openzeppelin-contracts/contracts/math/SignedSafeMath.sol
603 /* pragma solidity >=0.6.0 <0.8.0; */
604 
605 /**
606  * @title SignedSafeMath
607  * @dev Signed math operations with safety checks that revert on error.
608  */
609 library SignedSafeMath {
610     int256 constant private _INT256_MIN = -2**255;
611 
612     /**
613      * @dev Returns the multiplication of two signed integers, reverting on
614      * overflow.
615      *
616      * Counterpart to Solidity's `*` operator.
617      *
618      * Requirements:
619      *
620      * - Multiplication cannot overflow.
621      */
622     function mul(int256 a, int256 b) internal pure returns (int256) {
623         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
624         // benefit is lost if 'b' is also tested.
625         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
626         if (a == 0) {
627             return 0;
628         }
629 
630         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
631 
632         int256 c = a * b;
633         require(c / a == b, "SignedSafeMath: multiplication overflow");
634 
635         return c;
636     }
637 
638     /**
639      * @dev Returns the integer division of two signed integers. Reverts on
640      * division by zero. The result is rounded towards zero.
641      *
642      * Counterpart to Solidity's `/` operator. Note: this function uses a
643      * `revert` opcode (which leaves remaining gas untouched) while Solidity
644      * uses an invalid opcode to revert (consuming all remaining gas).
645      *
646      * Requirements:
647      *
648      * - The divisor cannot be zero.
649      */
650     function div(int256 a, int256 b) internal pure returns (int256) {
651         require(b != 0, "SignedSafeMath: division by zero");
652         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
653 
654         int256 c = a / b;
655 
656         return c;
657     }
658 
659     /**
660      * @dev Returns the subtraction of two signed integers, reverting on
661      * overflow.
662      *
663      * Counterpart to Solidity's `-` operator.
664      *
665      * Requirements:
666      *
667      * - Subtraction cannot overflow.
668      */
669     function sub(int256 a, int256 b) internal pure returns (int256) {
670         int256 c = a - b;
671         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
672 
673         return c;
674     }
675 
676     /**
677      * @dev Returns the addition of two signed integers, reverting on
678      * overflow.
679      *
680      * Counterpart to Solidity's `+` operator.
681      *
682      * Requirements:
683      *
684      * - Addition cannot overflow.
685      */
686     function add(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a + b;
688         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
689 
690         return c;
691     }
692 }
693 
694 ////// lib/openzeppelin-contracts/contracts/GSN/Context.sol
695 /* pragma solidity >=0.6.0 <0.8.0; */
696 
697 /*
698  * @dev Provides information about the current execution context, including the
699  * sender of the transaction and its data. While these are generally available
700  * via msg.sender and msg.data, they should not be accessed in such a direct
701  * manner, since when dealing with GSN meta-transactions the account sending and
702  * paying for execution may not be the actual sender (as far as an application
703  * is concerned).
704  *
705  * This contract is only required for intermediate, library-like contracts.
706  */
707 abstract contract Context {
708     function _msgSender() internal view virtual returns (address payable) {
709         return msg.sender;
710     }
711 
712     function _msgData() internal view virtual returns (bytes memory) {
713         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
714         return msg.data;
715     }
716 }
717 
718 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
719 /* pragma solidity >=0.6.0 <0.8.0; */
720 
721 /* import "../../GSN/Context.sol"; */
722 /* import "./IERC20.sol"; */
723 /* import "../../math/SafeMath.sol"; */
724 
725 /**
726  * @dev Implementation of the {IERC20} interface.
727  *
728  * This implementation is agnostic to the way tokens are created. This means
729  * that a supply mechanism has to be added in a derived contract using {_mint}.
730  * For a generic mechanism see {ERC20PresetMinterPauser}.
731  *
732  * TIP: For a detailed writeup see our guide
733  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
734  * to implement supply mechanisms].
735  *
736  * We have followed general OpenZeppelin guidelines: functions revert instead
737  * of returning `false` on failure. This behavior is nonetheless conventional
738  * and does not conflict with the expectations of ERC20 applications.
739  *
740  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
741  * This allows applications to reconstruct the allowance for all accounts just
742  * by listening to said events. Other implementations of the EIP may not emit
743  * these events, as it isn't required by the specification.
744  *
745  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
746  * functions have been added to mitigate the well-known issues around setting
747  * allowances. See {IERC20-approve}.
748  */
749 contract ERC20 is Context, IERC20 {
750     using SafeMath for uint256;
751 
752     mapping (address => uint256) private _balances;
753 
754     mapping (address => mapping (address => uint256)) private _allowances;
755 
756     uint256 private _totalSupply;
757 
758     string private _name;
759     string private _symbol;
760     uint8 private _decimals;
761 
762     /**
763      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
764      * a default value of 18.
765      *
766      * To select a different value for {decimals}, use {_setupDecimals}.
767      *
768      * All three of these values are immutable: they can only be set once during
769      * construction.
770      */
771     constructor (string memory name_, string memory symbol_) public {
772         _name = name_;
773         _symbol = symbol_;
774         _decimals = 18;
775     }
776 
777     /**
778      * @dev Returns the name of the token.
779      */
780     function name() public view returns (string memory) {
781         return _name;
782     }
783 
784     /**
785      * @dev Returns the symbol of the token, usually a shorter version of the
786      * name.
787      */
788     function symbol() public view returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev Returns the number of decimals used to get its user representation.
794      * For example, if `decimals` equals `2`, a balance of `505` tokens should
795      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
796      *
797      * Tokens usually opt for a value of 18, imitating the relationship between
798      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
799      * called.
800      *
801      * NOTE: This information is only used for _display_ purposes: it in
802      * no way affects any of the arithmetic of the contract, including
803      * {IERC20-balanceOf} and {IERC20-transfer}.
804      */
805     function decimals() public view returns (uint8) {
806         return _decimals;
807     }
808 
809     /**
810      * @dev See {IERC20-totalSupply}.
811      */
812     function totalSupply() public view override returns (uint256) {
813         return _totalSupply;
814     }
815 
816     /**
817      * @dev See {IERC20-balanceOf}.
818      */
819     function balanceOf(address account) public view override returns (uint256) {
820         return _balances[account];
821     }
822 
823     /**
824      * @dev See {IERC20-transfer}.
825      *
826      * Requirements:
827      *
828      * - `recipient` cannot be the zero address.
829      * - the caller must have a balance of at least `amount`.
830      */
831     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
832         _transfer(_msgSender(), recipient, amount);
833         return true;
834     }
835 
836     /**
837      * @dev See {IERC20-allowance}.
838      */
839     function allowance(address owner, address spender) public view virtual override returns (uint256) {
840         return _allowances[owner][spender];
841     }
842 
843     /**
844      * @dev See {IERC20-approve}.
845      *
846      * Requirements:
847      *
848      * - `spender` cannot be the zero address.
849      */
850     function approve(address spender, uint256 amount) public virtual override returns (bool) {
851         _approve(_msgSender(), spender, amount);
852         return true;
853     }
854 
855     /**
856      * @dev See {IERC20-transferFrom}.
857      *
858      * Emits an {Approval} event indicating the updated allowance. This is not
859      * required by the EIP. See the note at the beginning of {ERC20}.
860      *
861      * Requirements:
862      *
863      * - `sender` and `recipient` cannot be the zero address.
864      * - `sender` must have a balance of at least `amount`.
865      * - the caller must have allowance for ``sender``'s tokens of at least
866      * `amount`.
867      */
868     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
869         _transfer(sender, recipient, amount);
870         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
871         return true;
872     }
873 
874     /**
875      * @dev Atomically increases the allowance granted to `spender` by the caller.
876      *
877      * This is an alternative to {approve} that can be used as a mitigation for
878      * problems described in {IERC20-approve}.
879      *
880      * Emits an {Approval} event indicating the updated allowance.
881      *
882      * Requirements:
883      *
884      * - `spender` cannot be the zero address.
885      */
886     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
887         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
888         return true;
889     }
890 
891     /**
892      * @dev Atomically decreases the allowance granted to `spender` by the caller.
893      *
894      * This is an alternative to {approve} that can be used as a mitigation for
895      * problems described in {IERC20-approve}.
896      *
897      * Emits an {Approval} event indicating the updated allowance.
898      *
899      * Requirements:
900      *
901      * - `spender` cannot be the zero address.
902      * - `spender` must have allowance for the caller of at least
903      * `subtractedValue`.
904      */
905     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
906         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
907         return true;
908     }
909 
910     /**
911      * @dev Moves tokens `amount` from `sender` to `recipient`.
912      *
913      * This is internal function is equivalent to {transfer}, and can be used to
914      * e.g. implement automatic token fees, slashing mechanisms, etc.
915      *
916      * Emits a {Transfer} event.
917      *
918      * Requirements:
919      *
920      * - `sender` cannot be the zero address.
921      * - `recipient` cannot be the zero address.
922      * - `sender` must have a balance of at least `amount`.
923      */
924     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
925         require(sender != address(0), "ERC20: transfer from the zero address");
926         require(recipient != address(0), "ERC20: transfer to the zero address");
927 
928         _beforeTokenTransfer(sender, recipient, amount);
929 
930         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
931         _balances[recipient] = _balances[recipient].add(amount);
932         emit Transfer(sender, recipient, amount);
933     }
934 
935     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
936      * the total supply.
937      *
938      * Emits a {Transfer} event with `from` set to the zero address.
939      *
940      * Requirements:
941      *
942      * - `to` cannot be the zero address.
943      */
944     function _mint(address account, uint256 amount) internal virtual {
945         require(account != address(0), "ERC20: mint to the zero address");
946 
947         _beforeTokenTransfer(address(0), account, amount);
948 
949         _totalSupply = _totalSupply.add(amount);
950         _balances[account] = _balances[account].add(amount);
951         emit Transfer(address(0), account, amount);
952     }
953 
954     /**
955      * @dev Destroys `amount` tokens from `account`, reducing the
956      * total supply.
957      *
958      * Emits a {Transfer} event with `to` set to the zero address.
959      *
960      * Requirements:
961      *
962      * - `account` cannot be the zero address.
963      * - `account` must have at least `amount` tokens.
964      */
965     function _burn(address account, uint256 amount) internal virtual {
966         require(account != address(0), "ERC20: burn from the zero address");
967 
968         _beforeTokenTransfer(account, address(0), amount);
969 
970         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
971         _totalSupply = _totalSupply.sub(amount);
972         emit Transfer(account, address(0), amount);
973     }
974 
975     /**
976      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
977      *
978      * This internal function is equivalent to `approve`, and can be used to
979      * e.g. set automatic allowances for certain subsystems, etc.
980      *
981      * Emits an {Approval} event.
982      *
983      * Requirements:
984      *
985      * - `owner` cannot be the zero address.
986      * - `spender` cannot be the zero address.
987      */
988     function _approve(address owner, address spender, uint256 amount) internal virtual {
989         require(owner != address(0), "ERC20: approve from the zero address");
990         require(spender != address(0), "ERC20: approve to the zero address");
991 
992         _allowances[owner][spender] = amount;
993         emit Approval(owner, spender, amount);
994     }
995 
996     /**
997      * @dev Sets {decimals} to a value other than the default one of 18.
998      *
999      * WARNING: This function should only be called from the constructor. Most
1000      * applications that interact with token contracts will not expect
1001      * {decimals} to ever change, and may work incorrectly if it does.
1002      */
1003     function _setupDecimals(uint8 decimals_) internal {
1004         _decimals = decimals_;
1005     }
1006 
1007     /**
1008      * @dev Hook that is called before any transfer of tokens. This includes
1009      * minting and burning.
1010      *
1011      * Calling conditions:
1012      *
1013      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1014      * will be to transferred to `to`.
1015      * - when `from` is zero, `amount` tokens will be minted for `to`.
1016      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1017      * - `from` and `to` are never both zero.
1018      *
1019      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1020      */
1021     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1022 }
1023 
1024 ////// contracts/token/BasicFDT.sol
1025 /* pragma solidity 0.6.11; */
1026 
1027 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1028 /* import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol"; */
1029 /* import "lib/openzeppelin-contracts/contracts/math/SignedSafeMath.sol"; */
1030 /* import "./interfaces/IBaseFDT.sol"; */
1031 /* import "../math/SafeMathUint.sol"; */
1032 /* import "../math/SafeMathInt.sol"; */
1033 
1034 /// @title BasicFDT implements base level FDT functionality for accounting for revenues.
1035 abstract contract BasicFDT is IBaseFDT, ERC20 {
1036     using SafeMath       for uint256;
1037     using SafeMathUint   for uint256;
1038     using SignedSafeMath for  int256;
1039     using SafeMathInt    for  int256;
1040 
1041     uint256 internal constant pointsMultiplier = 2 ** 128;
1042     uint256 internal pointsPerShare;
1043 
1044     mapping(address => int256)  internal pointsCorrection;
1045     mapping(address => uint256) internal withdrawnFunds;
1046 
1047     event   PointsPerShareUpdated(uint256 pointsPerShare);
1048     event PointsCorrectionUpdated(address indexed account, int256 pointsCorrection);
1049 
1050     constructor(string memory name, string memory symbol) ERC20(name, symbol) public { }
1051 
1052     /**
1053         @dev Distributes funds to token holders.
1054         @dev It reverts if the total supply of tokens is 0.
1055         @dev It emits a `FundsDistributed` event if the amount of received funds is greater than 0.
1056         @dev It emits a `PointsPerShareUpdated` event if the amount of received funds is greater than 0.
1057              About undistributed funds:
1058                 In each distribution, there is a small amount of funds which do not get distributed,
1059                    which is `(value  pointsMultiplier) % totalSupply()`.
1060                 With a well-chosen `pointsMultiplier`, the amount funds that are not getting distributed
1061                    in a distribution can be less than 1 (base unit).
1062                 We can actually keep track of the undistributed funds in a distribution
1063                    and try to distribute it in the next distribution.
1064     */
1065     function _distributeFunds(uint256 value) internal {
1066         require(totalSupply() > 0, "FDT:ZERO_SUPPLY");
1067 
1068         if (value == 0) return;
1069 
1070         pointsPerShare = pointsPerShare.add(value.mul(pointsMultiplier) / totalSupply());
1071         emit FundsDistributed(msg.sender, value);
1072         emit PointsPerShareUpdated(pointsPerShare);
1073     }
1074 
1075     /**
1076         @dev    Prepares the withdrawal of funds.
1077         @dev    It emits a `FundsWithdrawn` event if the amount of withdrawn funds is greater than 0.
1078         @return withdrawableDividend The amount of dividend funds that can be withdrawn.
1079     */
1080     function _prepareWithdraw() internal returns (uint256 withdrawableDividend) {
1081         withdrawableDividend       = withdrawableFundsOf(msg.sender);
1082         uint256 _withdrawnFunds    = withdrawnFunds[msg.sender].add(withdrawableDividend);
1083         withdrawnFunds[msg.sender] = _withdrawnFunds;
1084 
1085         emit FundsWithdrawn(msg.sender, withdrawableDividend, _withdrawnFunds);
1086     }
1087 
1088     /**
1089         @dev    Returns the amount of funds that an account can withdraw.
1090         @param  _owner The address of a token holder.
1091         @return The amount funds that `_owner` can withdraw.
1092     */
1093     function withdrawableFundsOf(address _owner) public view override returns (uint256) {
1094         return accumulativeFundsOf(_owner).sub(withdrawnFunds[_owner]);
1095     }
1096 
1097     /**
1098         @dev    Returns the amount of funds that an account has withdrawn.
1099         @param  _owner The address of a token holder.
1100         @return The amount of funds that `_owner` has withdrawn.
1101     */
1102     function withdrawnFundsOf(address _owner) external view returns (uint256) {
1103         return withdrawnFunds[_owner];
1104     }
1105 
1106     /**
1107         @dev    Returns the amount of funds that an account has earned in total.
1108         @dev    accumulativeFundsOf(_owner) = withdrawableFundsOf(_owner) + withdrawnFundsOf(_owner)
1109                                          = (pointsPerShare * balanceOf(_owner) + pointsCorrection[_owner]) / pointsMultiplier
1110         @param  _owner The address of a token holder.
1111         @return The amount of funds that `_owner` has earned in total.
1112     */
1113     function accumulativeFundsOf(address _owner) public view returns (uint256) {
1114         return
1115             pointsPerShare
1116                 .mul(balanceOf(_owner))
1117                 .toInt256Safe()
1118                 .add(pointsCorrection[_owner])
1119                 .toUint256Safe() / pointsMultiplier;
1120     }
1121 
1122     /**
1123         @dev   Transfers tokens from one account to another. Updates pointsCorrection to keep funds unchanged.
1124         @dev   It emits two `PointsCorrectionUpdated` events, one for the sender and one for the receiver.
1125         @param from  The address to transfer from.
1126         @param to    The address to transfer to.
1127         @param value The amount to be transferred.
1128     */
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 value
1133     ) internal virtual override {
1134         super._transfer(from, to, value);
1135 
1136         int256 _magCorrection       = pointsPerShare.mul(value).toInt256Safe();
1137         int256 pointsCorrectionFrom = pointsCorrection[from].add(_magCorrection);
1138         pointsCorrection[from]      = pointsCorrectionFrom;
1139         int256 pointsCorrectionTo   = pointsCorrection[to].sub(_magCorrection);
1140         pointsCorrection[to]        = pointsCorrectionTo;
1141 
1142         emit PointsCorrectionUpdated(from, pointsCorrectionFrom);
1143         emit PointsCorrectionUpdated(to,   pointsCorrectionTo);
1144     }
1145 
1146     /**
1147         @dev   Mints tokens to an account. Updates pointsCorrection to keep funds unchanged.
1148         @param account The account that will receive the created tokens.
1149         @param value   The amount that will be created.
1150     */
1151     function _mint(address account, uint256 value) internal virtual override {
1152         super._mint(account, value);
1153 
1154         int256 _pointsCorrection = pointsCorrection[account].sub(
1155             (pointsPerShare.mul(value)).toInt256Safe()
1156         );
1157 
1158         pointsCorrection[account] = _pointsCorrection;
1159 
1160         emit PointsCorrectionUpdated(account, _pointsCorrection);
1161     }
1162 
1163     /**
1164         @dev   Burns an amount of the token of a given account. Updates pointsCorrection to keep funds unchanged.
1165         @dev   It emits a `PointsCorrectionUpdated` event.
1166         @param account The account whose tokens will be burnt.
1167         @param value   The amount that will be burnt.
1168     */
1169     function _burn(address account, uint256 value) internal virtual override {
1170         super._burn(account, value);
1171 
1172         int256 _pointsCorrection = pointsCorrection[account].add(
1173             (pointsPerShare.mul(value)).toInt256Safe()
1174         );
1175 
1176         pointsCorrection[account] = _pointsCorrection;
1177 
1178         emit PointsCorrectionUpdated(account, _pointsCorrection);
1179     }
1180 
1181     /**
1182         @dev Withdraws all available funds for a token holder.
1183     */
1184     function withdrawFunds() public virtual override {}
1185 
1186     /**
1187         @dev    Updates the current `fundsToken` balance and returns the difference of the new and previous `fundsToken` balance.
1188         @return A int256 representing the difference of the new and previous `fundsToken` balance.
1189     */
1190     function _updateFundsTokenBalance() internal virtual returns (int256) {}
1191 
1192     /**
1193         @dev Registers a payment of funds in tokens. May be called directly after a deposit is made.
1194         @dev Calls _updateFundsTokenBalance(), whereby the contract computes the delta of the new and previous
1195              `fundsToken` balance and increments the total received funds (cumulative), by delta, by calling _distributeFunds().
1196     */
1197     function updateFundsReceived() public virtual {
1198         int256 newFunds = _updateFundsTokenBalance();
1199 
1200         if (newFunds <= 0) return;
1201 
1202         _distributeFunds(newFunds.toUint256Safe());
1203     }
1204 }
1205 
1206 ////// contracts/token/ExtendedFDT.sol
1207 /* pragma solidity 0.6.11; */
1208 
1209 /* import "./BasicFDT.sol"; */
1210 
1211 /// @title ExtendedFDT implements FDT functionality for accounting for losses.
1212 abstract contract ExtendedFDT is BasicFDT {
1213     using SafeMath       for uint256;
1214     using SafeMathUint   for uint256;
1215     using SignedSafeMath for  int256;
1216     using SafeMathInt    for  int256;
1217 
1218     uint256 internal lossesPerShare;
1219 
1220     mapping(address => int256)  internal lossesCorrection;
1221     mapping(address => uint256) internal recognizedLosses;
1222 
1223     event   LossesPerShareUpdated(uint256 lossesPerShare);
1224     event LossesCorrectionUpdated(address indexed account, int256 lossesCorrection);
1225 
1226     /**
1227         @dev   This event emits when new losses are distributed.
1228         @param by                The address of the account that has distributed losses.
1229         @param lossesDistributed The amount of losses received for distribution.
1230     */
1231     event LossesDistributed(address indexed by, uint256 lossesDistributed);
1232 
1233     /**
1234         @dev   This event emits when distributed losses are recognized by a token holder.
1235         @param by                    The address of the receiver of losses.
1236         @param lossesRecognized      The amount of losses that were recognized.
1237         @param totalLossesRecognized The total amount of losses that are recognized.
1238     */
1239     event LossesRecognized(address indexed by, uint256 lossesRecognized, uint256 totalLossesRecognized);
1240 
1241     constructor(string memory name, string memory symbol) BasicFDT(name, symbol) public { }
1242 
1243     /**
1244         @dev Distributes losses to token holders.
1245         @dev It reverts if the total supply of tokens is 0.
1246         @dev It emits a `LossesDistributed` event if the amount of received losses is greater than 0.
1247         @dev It emits a `LossesPerShareUpdated` event if the amount of received losses is greater than 0.
1248              About undistributed losses:
1249                 In each distribution, there is a small amount of losses which do not get distributed,
1250                 which is `(value * pointsMultiplier) % totalSupply()`.
1251              With a well-chosen `pointsMultiplier`, the amount losses that are not getting distributed
1252                 in a distribution can be less than 1 (base unit).
1253              We can actually keep track of the undistributed losses in a distribution
1254                 and try to distribute it in the next distribution.
1255     */
1256     function _distributeLosses(uint256 value) internal {
1257         require(totalSupply() > 0, "FDT:ZERO_SUPPLY");
1258 
1259         if (value == 0) return;
1260 
1261         uint256 _lossesPerShare = lossesPerShare.add(value.mul(pointsMultiplier) / totalSupply());
1262         lossesPerShare          = _lossesPerShare;
1263 
1264         emit LossesDistributed(msg.sender, value);
1265         emit LossesPerShareUpdated(_lossesPerShare);
1266     }
1267 
1268     /**
1269         @dev    Prepares losses for a withdrawal.
1270         @dev    It emits a `LossesWithdrawn` event if the amount of withdrawn losses is greater than 0.
1271         @return recognizableDividend The amount of dividend losses that can be recognized.
1272     */
1273     function _prepareLossesWithdraw() internal returns (uint256 recognizableDividend) {
1274         recognizableDividend = recognizableLossesOf(msg.sender);
1275 
1276         uint256 _recognizedLosses    = recognizedLosses[msg.sender].add(recognizableDividend);
1277         recognizedLosses[msg.sender] = _recognizedLosses;
1278 
1279         emit LossesRecognized(msg.sender, recognizableDividend, _recognizedLosses);
1280     }
1281 
1282     /**
1283         @dev    Returns the amount of losses that an address can withdraw.
1284         @param  _owner The address of a token holder.
1285         @return The amount of losses that `_owner` can withdraw.
1286     */
1287     function recognizableLossesOf(address _owner) public view returns (uint256) {
1288         return accumulativeLossesOf(_owner).sub(recognizedLosses[_owner]);
1289     }
1290 
1291     /**
1292         @dev    Returns the amount of losses that an address has recognized.
1293         @param  _owner The address of a token holder
1294         @return The amount of losses that `_owner` has recognized
1295     */
1296     function recognizedLossesOf(address _owner) external view returns (uint256) {
1297         return recognizedLosses[_owner];
1298     }
1299 
1300     /**
1301         @dev    Returns the amount of losses that an address has earned in total.
1302         @dev    accumulativeLossesOf(_owner) = recognizableLossesOf(_owner) + recognizedLossesOf(_owner)
1303                 = (lossesPerShare * balanceOf(_owner) + lossesCorrection[_owner]) / pointsMultiplier
1304         @param  _owner The address of a token holder
1305         @return The amount of losses that `_owner` has earned in total
1306     */
1307     function accumulativeLossesOf(address _owner) public view returns (uint256) {
1308         return
1309             lossesPerShare
1310                 .mul(balanceOf(_owner))
1311                 .toInt256Safe()
1312                 .add(lossesCorrection[_owner])
1313                 .toUint256Safe() / pointsMultiplier;
1314     }
1315 
1316     /**
1317         @dev   Transfers tokens from one account to another. Updates pointsCorrection to keep funds unchanged.
1318         @dev         It emits two `LossesCorrectionUpdated` events, one for the sender and one for the receiver.
1319         @param from  The address to transfer from.
1320         @param to    The address to transfer to.
1321         @param value The amount to be transferred.
1322     */
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 value
1327     ) internal virtual override {
1328         super._transfer(from, to, value);
1329 
1330         int256 _lossesCorrection    = lossesPerShare.mul(value).toInt256Safe();
1331         int256 lossesCorrectionFrom = lossesCorrection[from].add(_lossesCorrection);
1332         lossesCorrection[from]      = lossesCorrectionFrom;
1333         int256 lossesCorrectionTo   = lossesCorrection[to].sub(_lossesCorrection);
1334         lossesCorrection[to]        = lossesCorrectionTo;
1335 
1336         emit LossesCorrectionUpdated(from, lossesCorrectionFrom);
1337         emit LossesCorrectionUpdated(to,   lossesCorrectionTo);
1338     }
1339 
1340     /**
1341         @dev   Mints tokens to an account. Updates lossesCorrection to keep losses unchanged.
1342         @dev   It emits a `LossesCorrectionUpdated` event.
1343         @param account The account that will receive the created tokens.
1344         @param value   The amount that will be created.
1345     */
1346     function _mint(address account, uint256 value) internal virtual override {
1347         super._mint(account, value);
1348 
1349         int256 _lossesCorrection = lossesCorrection[account].sub(
1350             (lossesPerShare.mul(value)).toInt256Safe()
1351         );
1352 
1353         lossesCorrection[account] = _lossesCorrection;
1354 
1355         emit LossesCorrectionUpdated(account, _lossesCorrection);
1356     }
1357 
1358     /**
1359         @dev   Burns an amount of the token of a given account. Updates lossesCorrection to keep losses unchanged.
1360         @dev   It emits a `LossesCorrectionUpdated` event.
1361         @param account The account from which tokens will be burnt.
1362         @param value   The amount that will be burnt.
1363     */
1364     function _burn(address account, uint256 value) internal virtual override {
1365         super._burn(account, value);
1366 
1367         int256 _lossesCorrection = lossesCorrection[account].add(
1368             (lossesPerShare.mul(value)).toInt256Safe()
1369         );
1370 
1371         lossesCorrection[account] = _lossesCorrection;
1372 
1373         emit LossesCorrectionUpdated(account, _lossesCorrection);
1374     }
1375 
1376     /**
1377         @dev Registers a loss. May be called directly after a shortfall after BPT burning occurs.
1378         @dev Calls _updateLossesTokenBalance(), whereby the contract computes the delta of the new and previous
1379              losses balance and increments the total losses (cumulative), by delta, by calling _distributeLosses().
1380     */
1381     function updateLossesReceived() public virtual {
1382         int256 newLosses = _updateLossesBalance();
1383 
1384         if (newLosses <= 0) return;
1385 
1386         _distributeLosses(newLosses.toUint256Safe());
1387     }
1388 
1389     /**
1390         @dev Recognizes all recognizable losses for an account using loss accounting.
1391     */
1392     function _recognizeLosses() internal virtual returns (uint256 losses) { }
1393 
1394     /**
1395         @dev    Updates the current losses balance and returns the difference of the new and previous losses balance.
1396         @return A int256 representing the difference of the new and previous losses balance.
1397     */
1398     function _updateLossesBalance() internal virtual returns (int256) { }
1399 }
1400 
1401 ////// contracts/token/StakeLockerFDT.sol
1402 /* pragma solidity 0.6.11; */
1403 
1404 /* import "./ExtendedFDT.sol"; */
1405 
1406 /// @title StakeLockerFDT inherits ExtendedFDT and accounts for gains/losses for Stakers.
1407 abstract contract StakeLockerFDT is ExtendedFDT {
1408     using SafeMath       for uint256;
1409     using SafeMathUint   for uint256;
1410     using SignedSafeMath for  int256;
1411     using SafeMathInt    for  int256;
1412 
1413     IERC20 public immutable fundsToken;
1414 
1415     uint256 public bptLosses;          // Sum of all unrecognized losses.
1416     uint256 public lossesBalance;      // The amount of losses present and accounted for in this contract.
1417     uint256 public fundsTokenBalance;  // The amount of `fundsToken` (Liquidity Asset) currently present and accounted for in this contract.
1418 
1419     constructor(string memory name, string memory symbol, address _fundsToken) ExtendedFDT(name, symbol) public {
1420         fundsToken = IERC20(_fundsToken);
1421     }
1422 
1423     /**
1424         @dev    Updates loss accounting for `msg.sender`, recognizing losses.
1425         @return losses Amount to be subtracted from a withdraw amount.
1426     */
1427     function _recognizeLosses() internal override returns (uint256 losses) {
1428         losses = _prepareLossesWithdraw();
1429 
1430         bptLosses = bptLosses.sub(losses);
1431 
1432         _updateLossesBalance();
1433     }
1434 
1435     /**
1436         @dev    Updates the current losses balance and returns the difference of the new and previous losses balance.
1437         @return A int256 representing the difference of the new and previous losses balance.
1438     */
1439     function _updateLossesBalance() internal override returns (int256) {
1440         uint256 _prevLossesTokenBalance = lossesBalance;
1441 
1442         lossesBalance = bptLosses;
1443 
1444         return int256(lossesBalance).sub(int256(_prevLossesTokenBalance));
1445     }
1446 
1447     /**
1448         @dev    Updates the current interest balance and returns the difference of the new and previous interest balance.
1449         @return A int256 representing the difference of the new and previous interest balance.
1450     */
1451     function _updateFundsTokenBalance() internal virtual override returns (int256) {
1452         uint256 _prevFundsTokenBalance = fundsTokenBalance;
1453 
1454         fundsTokenBalance = fundsToken.balanceOf(address(this));
1455 
1456         return int256(fundsTokenBalance).sub(int256(_prevFundsTokenBalance));
1457     }
1458 }
1459 
1460 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
1461 /* pragma solidity >=0.6.2 <0.8.0; */
1462 
1463 /**
1464  * @dev Collection of functions related to the address type
1465  */
1466 library Address {
1467     /**
1468      * @dev Returns true if `account` is a contract.
1469      *
1470      * [IMPORTANT]
1471      * ====
1472      * It is unsafe to assume that an address for which this function returns
1473      * false is an externally-owned account (EOA) and not a contract.
1474      *
1475      * Among others, `isContract` will return false for the following
1476      * types of addresses:
1477      *
1478      *  - an externally-owned account
1479      *  - a contract in construction
1480      *  - an address where a contract will be created
1481      *  - an address where a contract lived, but was destroyed
1482      * ====
1483      */
1484     function isContract(address account) internal view returns (bool) {
1485         // This method relies on extcodesize, which returns 0 for contracts in
1486         // construction, since the code is only stored at the end of the
1487         // constructor execution.
1488 
1489         uint256 size;
1490         // solhint-disable-next-line no-inline-assembly
1491         assembly { size := extcodesize(account) }
1492         return size > 0;
1493     }
1494 
1495     /**
1496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1497      * `recipient`, forwarding all available gas and reverting on errors.
1498      *
1499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1501      * imposed by `transfer`, making them unable to receive funds via
1502      * `transfer`. {sendValue} removes this limitation.
1503      *
1504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1505      *
1506      * IMPORTANT: because control is transferred to `recipient`, care must be
1507      * taken to not create reentrancy vulnerabilities. Consider using
1508      * {ReentrancyGuard} or the
1509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1510      */
1511     function sendValue(address payable recipient, uint256 amount) internal {
1512         require(address(this).balance >= amount, "Address: insufficient balance");
1513 
1514         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1515         (bool success, ) = recipient.call{ value: amount }("");
1516         require(success, "Address: unable to send value, recipient may have reverted");
1517     }
1518 
1519     /**
1520      * @dev Performs a Solidity function call using a low level `call`. A
1521      * plain`call` is an unsafe replacement for a function call: use this
1522      * function instead.
1523      *
1524      * If `target` reverts with a revert reason, it is bubbled up by this
1525      * function (like regular Solidity function calls).
1526      *
1527      * Returns the raw returned data. To convert to the expected return value,
1528      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1529      *
1530      * Requirements:
1531      *
1532      * - `target` must be a contract.
1533      * - calling `target` with `data` must not revert.
1534      *
1535      * _Available since v3.1._
1536      */
1537     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1538       return functionCall(target, data, "Address: low-level call failed");
1539     }
1540 
1541     /**
1542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1543      * `errorMessage` as a fallback revert reason when `target` reverts.
1544      *
1545      * _Available since v3.1._
1546      */
1547     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1548         return functionCallWithValue(target, data, 0, errorMessage);
1549     }
1550 
1551     /**
1552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1553      * but also transferring `value` wei to `target`.
1554      *
1555      * Requirements:
1556      *
1557      * - the calling contract must have an ETH balance of at least `value`.
1558      * - the called Solidity function must be `payable`.
1559      *
1560      * _Available since v3.1._
1561      */
1562     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1563         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1564     }
1565 
1566     /**
1567      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1568      * with `errorMessage` as a fallback revert reason when `target` reverts.
1569      *
1570      * _Available since v3.1._
1571      */
1572     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1573         require(address(this).balance >= value, "Address: insufficient balance for call");
1574         require(isContract(target), "Address: call to non-contract");
1575 
1576         // solhint-disable-next-line avoid-low-level-calls
1577         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1578         return _verifyCallResult(success, returndata, errorMessage);
1579     }
1580 
1581     /**
1582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1583      * but performing a static call.
1584      *
1585      * _Available since v3.3._
1586      */
1587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1588         return functionStaticCall(target, data, "Address: low-level static call failed");
1589     }
1590 
1591     /**
1592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1593      * but performing a static call.
1594      *
1595      * _Available since v3.3._
1596      */
1597     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1598         require(isContract(target), "Address: static call to non-contract");
1599 
1600         // solhint-disable-next-line avoid-low-level-calls
1601         (bool success, bytes memory returndata) = target.staticcall(data);
1602         return _verifyCallResult(success, returndata, errorMessage);
1603     }
1604 
1605     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1606         if (success) {
1607             return returndata;
1608         } else {
1609             // Look for revert reason and bubble it up if present
1610             if (returndata.length > 0) {
1611                 // The easiest way to bubble the revert reason is using memory via assembly
1612 
1613                 // solhint-disable-next-line no-inline-assembly
1614                 assembly {
1615                     let returndata_size := mload(returndata)
1616                     revert(add(32, returndata), returndata_size)
1617                 }
1618             } else {
1619                 revert(errorMessage);
1620             }
1621         }
1622     }
1623 }
1624 
1625 ////// lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol
1626 /* pragma solidity >=0.6.0 <0.8.0; */
1627 
1628 /* import "./IERC20.sol"; */
1629 /* import "../../math/SafeMath.sol"; */
1630 /* import "../../utils/Address.sol"; */
1631 
1632 /**
1633  * @title SafeERC20
1634  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1635  * contract returns false). Tokens that return no value (and instead revert or
1636  * throw on failure) are also supported, non-reverting calls are assumed to be
1637  * successful.
1638  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1639  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1640  */
1641 library SafeERC20 {
1642     using SafeMath for uint256;
1643     using Address for address;
1644 
1645     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1646         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1647     }
1648 
1649     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1650         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1651     }
1652 
1653     /**
1654      * @dev Deprecated. This function has issues similar to the ones found in
1655      * {IERC20-approve}, and its usage is discouraged.
1656      *
1657      * Whenever possible, use {safeIncreaseAllowance} and
1658      * {safeDecreaseAllowance} instead.
1659      */
1660     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1661         // safeApprove should only be called when setting an initial allowance,
1662         // or when resetting it to zero. To increase and decrease it, use
1663         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1664         // solhint-disable-next-line max-line-length
1665         require((value == 0) || (token.allowance(address(this), spender) == 0),
1666             "SafeERC20: approve from non-zero to non-zero allowance"
1667         );
1668         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1669     }
1670 
1671     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1672         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1673         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1674     }
1675 
1676     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1677         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1678         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1679     }
1680 
1681     /**
1682      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1683      * on the return value: the return value is optional (but if data is returned, it must not be false).
1684      * @param token The token targeted by the call.
1685      * @param data The call data (encoded using abi.encode or one of its variants).
1686      */
1687     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1688         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1689         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1690         // the target address contains contract code and also asserts for success in the low-level call.
1691 
1692         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1693         if (returndata.length > 0) { // Return data is optional
1694             // solhint-disable-next-line max-line-length
1695             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1696         }
1697     }
1698 }
1699 
1700 ////// lib/openzeppelin-contracts/contracts/utils/Pausable.sol
1701 /* pragma solidity >=0.6.0 <0.8.0; */
1702 
1703 /* import "../GSN/Context.sol"; */
1704 
1705 /**
1706  * @dev Contract module which allows children to implement an emergency stop
1707  * mechanism that can be triggered by an authorized account.
1708  *
1709  * This module is used through inheritance. It will make available the
1710  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1711  * the functions of your contract. Note that they will not be pausable by
1712  * simply including this module, only once the modifiers are put in place.
1713  */
1714 abstract contract Pausable is Context {
1715     /**
1716      * @dev Emitted when the pause is triggered by `account`.
1717      */
1718     event Paused(address account);
1719 
1720     /**
1721      * @dev Emitted when the pause is lifted by `account`.
1722      */
1723     event Unpaused(address account);
1724 
1725     bool private _paused;
1726 
1727     /**
1728      * @dev Initializes the contract in unpaused state.
1729      */
1730     constructor () internal {
1731         _paused = false;
1732     }
1733 
1734     /**
1735      * @dev Returns true if the contract is paused, and false otherwise.
1736      */
1737     function paused() public view returns (bool) {
1738         return _paused;
1739     }
1740 
1741     /**
1742      * @dev Modifier to make a function callable only when the contract is not paused.
1743      *
1744      * Requirements:
1745      *
1746      * - The contract must not be paused.
1747      */
1748     modifier whenNotPaused() {
1749         require(!_paused, "Pausable: paused");
1750         _;
1751     }
1752 
1753     /**
1754      * @dev Modifier to make a function callable only when the contract is paused.
1755      *
1756      * Requirements:
1757      *
1758      * - The contract must be paused.
1759      */
1760     modifier whenPaused() {
1761         require(_paused, "Pausable: not paused");
1762         _;
1763     }
1764 
1765     /**
1766      * @dev Triggers stopped state.
1767      *
1768      * Requirements:
1769      *
1770      * - The contract must not be paused.
1771      */
1772     function _pause() internal virtual whenNotPaused {
1773         _paused = true;
1774         emit Paused(_msgSender());
1775     }
1776 
1777     /**
1778      * @dev Returns to normal state.
1779      *
1780      * Requirements:
1781      *
1782      * - The contract must be paused.
1783      */
1784     function _unpause() internal virtual whenPaused {
1785         _paused = false;
1786         emit Unpaused(_msgSender());
1787     }
1788 }
1789 
1790 ////// contracts/StakeLocker.sol
1791 /* pragma solidity 0.6.11; */
1792 
1793 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol"; */
1794 /* import "lib/openzeppelin-contracts/contracts/utils/Pausable.sol"; */
1795 
1796 /* import "./interfaces/IMapleGlobals.sol"; */
1797 /* import "./interfaces/IPool.sol"; */
1798 /* import "./interfaces/IPoolFactory.sol"; */
1799 
1800 /* import "./token/StakeLockerFDT.sol"; */
1801 
1802 /// @title StakeLocker holds custody of stakeAsset tokens for a given Pool and earns revenue from interest.
1803 contract StakeLocker is StakeLockerFDT, Pausable {
1804 
1805     using SafeMathInt    for int256;
1806     using SignedSafeMath for int256;
1807     using SafeERC20      for IERC20;
1808 
1809     uint256 constant WAD = 10 ** 18;  // Scaling factor for synthetic float division.
1810 
1811     IERC20  public immutable stakeAsset;  // The asset deposited by Stakers into this contract, for liquidation during defaults.
1812 
1813     address public immutable liquidityAsset;  // The Liquidity Asset for the Pool as well as the dividend token for StakeLockerFDT interest.
1814     address public immutable pool;            // The parent Pool.
1815 
1816     uint256 public lockupPeriod;  // Number of seconds for which unstaking is not allowed.
1817 
1818     mapping(address => uint256)                     public stakeDate;              // Map of account addresses to effective stake date.
1819     mapping(address => uint256)                     public unstakeCooldown;        // The timestamp of when a Staker called `cooldown()`.
1820     mapping(address => bool)                        public allowed;                // Map of addresses to allowed status.
1821     mapping(address => mapping(address => uint256)) public custodyAllowance;       // Amount of StakeLockerFDTs that are "locked" at a certain address.
1822     mapping(address => uint256)                     public totalCustodyAllowance;  // Total amount of StakeLockerFDTs that are "locked" for a given account, cannot be greater than balance.
1823 
1824     bool public openToPublic;  // Boolean opening StakeLocker to public for staking BPTs
1825 
1826     event            StakeLockerOpened();
1827     event               BalanceUpdated(address indexed staker, address indexed token, uint256 balance);
1828     event             AllowListUpdated(address indexed staker, bool status);
1829     event             StakeDateUpdated(address indexed staker, uint256 stakeDate);
1830     event          LockupPeriodUpdated(uint256 lockupPeriod);
1831     event                     Cooldown(address indexed staker, uint256 cooldown);
1832     event                        Stake(address indexed staker, uint256 amount);
1833     event                      Unstake(address indexed staker, uint256 amount);
1834     event              CustodyTransfer(address indexed custodian, address indexed from, address indexed to, uint256 amount);
1835     event      CustodyAllowanceChanged(address indexed staker, address indexed custodian, uint256 oldAllowance, uint256 newAllowance);
1836     event TotalCustodyAllowanceUpdated(address indexed staker, uint256 newTotalAllowance);
1837 
1838     constructor(
1839         address _stakeAsset,
1840         address _liquidityAsset,
1841         address _pool
1842     ) StakeLockerFDT("Maple StakeLocker", "MPLSTAKE", _liquidityAsset) public {
1843         liquidityAsset = _liquidityAsset;
1844         stakeAsset     = IERC20(_stakeAsset);
1845         pool           = _pool;
1846         lockupPeriod   = 180 days;
1847     }
1848 
1849     /*****************/
1850     /*** Modifiers ***/
1851     /*****************/
1852 
1853     /**
1854         @dev Checks that an account can unstake given the following conditions:
1855                  1. The Account is not the Pool Delegate and the Pool is in Finalized state.
1856                  2. The Pool is in Initialized or Deactivated state.
1857     */
1858     modifier canUnstake(address from) {
1859         IPool _pool = IPool(pool);
1860 
1861         // The Pool cannot be finalized, but if it is, account cannot be the Pool Delegate.
1862         require(!_pool.isPoolFinalized() || from != _pool.poolDelegate(), "SL:STAKE_LOCKED");
1863         _;
1864     }
1865 
1866     /**
1867         @dev Checks that `msg.sender` is the Governor.
1868     */
1869     modifier isGovernor() {
1870         require(msg.sender == _globals().governor(), "SL:NOT_GOV");
1871         _;
1872     }
1873 
1874     /**
1875         @dev Checks that `msg.sender` is the Pool.
1876     */
1877     modifier isPool() {
1878         require(msg.sender == pool, "SL:NOT_P");
1879         _;
1880     }
1881 
1882     /**********************/
1883     /*** Pool Functions ***/
1884     /**********************/
1885 
1886     /**
1887         @dev   Updates Staker status on the allowlist. Only the Pool Delegate can call this function.
1888         @dev   It emits an `AllowListUpdated` event.
1889         @param staker The address of the Staker to set status for.
1890         @param status The status of the Staker on allowlist.
1891     */
1892     function setAllowlist(address staker, bool status) public {
1893         _whenProtocolNotPaused();
1894         _isValidPoolDelegate();
1895         allowed[staker] = status;
1896         emit AllowListUpdated(staker, status);
1897     }
1898 
1899     /**
1900         @dev Sets the StakeLocker as open to the public. Only the Pool Delegate can call this function.
1901         @dev It emits a `StakeLockerOpened` event.
1902     */
1903     function openStakeLockerToPublic() external {
1904         _whenProtocolNotPaused();
1905         _isValidPoolDelegate();
1906         openToPublic = true;
1907         emit StakeLockerOpened();
1908     }
1909 
1910     /**
1911         @dev   Sets the lockup period. Only the Pool Delegate can call this function.
1912         @dev   It emits a `LockupPeriodUpdated` event.
1913         @param newLockupPeriod New lockup period used to restrict unstaking.
1914     */
1915     function setLockupPeriod(uint256 newLockupPeriod) external {
1916         _whenProtocolNotPaused();
1917         _isValidPoolDelegate();
1918         require(newLockupPeriod <= lockupPeriod, "SL:INVALID_VALUE");
1919         lockupPeriod = newLockupPeriod;
1920         emit LockupPeriodUpdated(newLockupPeriod);
1921     }
1922 
1923     /**
1924         @dev   Transfers an amount of Stake Asset to a destination account. Only the Pool can call this function.
1925         @param dst Destination to transfer Stake Asset to.
1926         @param amt Amount of Stake Asset to transfer.
1927     */
1928     function pull(address dst, uint256 amt) isPool external {
1929         stakeAsset.safeTransfer(dst, amt);
1930     }
1931 
1932     /**
1933         @dev   Updates loss accounting for StakeLockerFDTs after BPTs have been burned. Only the Pool can call this function.
1934         @param bptsBurned Amount of BPTs that have been burned.
1935     */
1936     function updateLosses(uint256 bptsBurned) isPool external {
1937         bptLosses = bptLosses.add(bptsBurned);
1938         updateLossesReceived();
1939     }
1940 
1941     /************************/
1942     /*** Staker Functions ***/
1943     /************************/
1944 
1945     /**
1946         @dev   Handles a Staker's depositing of an amount of Stake Asset, minting them StakeLockerFDTs.
1947         @dev   It emits a `StakeDateUpdated` event.
1948         @dev   It emits a `Stake` event.
1949         @dev   It emits a `Cooldown` event.
1950         @dev   It emits a `BalanceUpdated` event.
1951         @param amt Amount of Stake Asset (BPTs) to deposit.
1952     */
1953     function stake(uint256 amt) whenNotPaused external {
1954         _whenProtocolNotPaused();
1955         _isAllowed(msg.sender);
1956 
1957         unstakeCooldown[msg.sender] = uint256(0);  // Reset account's unstake cooldown if Staker had previously intended to unstake.
1958 
1959         _updateStakeDate(msg.sender, amt);
1960 
1961         stakeAsset.safeTransferFrom(msg.sender, address(this), amt);
1962         _mint(msg.sender, amt);
1963 
1964         emit Stake(msg.sender, amt);
1965         emit Cooldown(msg.sender, uint256(0));
1966         emit BalanceUpdated(address(this), address(stakeAsset), stakeAsset.balanceOf(address(this)));
1967     }
1968 
1969     /**
1970         @dev   Updates information used to calculate unstake delay.
1971         @dev   It emits a `StakeDateUpdated` event.
1972         @param account The Staker that deposited BPTs.
1973         @param amt     Amount of BPTs the Staker has deposited.
1974     */
1975     function _updateStakeDate(address account, uint256 amt) internal {
1976         uint256 prevDate = stakeDate[account];
1977         uint256 balance = balanceOf(account);
1978 
1979         // stakeDate + (now - stakeDate) * (amt / (balance + amt))
1980         // NOTE: prevDate = 0 implies balance = 0, and equation reduces to now.
1981         uint256 newDate = (balance + amt) > 0
1982             ? prevDate.add(block.timestamp.sub(prevDate).mul(amt).div(balance + amt))
1983             : prevDate;
1984 
1985         stakeDate[account] = newDate;
1986         emit StakeDateUpdated(account, newDate);
1987     }
1988 
1989     /**
1990         @dev Activates the cooldown period to unstake. It can't be called if the account is not staking.
1991         @dev It emits a `Cooldown` event.
1992     **/
1993     function intendToUnstake() external {
1994         require(balanceOf(msg.sender) != uint256(0), "SL:ZERO_BALANCE");
1995         unstakeCooldown[msg.sender] = block.timestamp;
1996         emit Cooldown(msg.sender, block.timestamp);
1997     }
1998 
1999     /**
2000         @dev Cancels an initiated unstake by resetting the calling account's unstake cooldown.
2001         @dev It emits a `Cooldown` event.
2002     */
2003     function cancelUnstake() external {
2004         require(unstakeCooldown[msg.sender] != uint256(0), "SL:NOT_UNSTAKING");
2005         unstakeCooldown[msg.sender] = 0;
2006         emit Cooldown(msg.sender, uint256(0));
2007     }
2008 
2009     /**
2010         @dev   Handles a Staker's withdrawing of an amount of Stake Asset, minus any losses. It also claims interest and burns StakeLockerFDTs for the calling account.
2011         @dev   It emits an `Unstake` event.
2012         @dev   It emits a `BalanceUpdated` event.
2013         @param amt Amount of Stake Asset (BPTs) to withdraw.
2014     */
2015     function unstake(uint256 amt) external canUnstake(msg.sender) {
2016         _whenProtocolNotPaused();
2017 
2018         require(balanceOf(msg.sender).sub(amt) >= totalCustodyAllowance[msg.sender], "SL:INSUF_UNSTAKEABLE_BAL");  // Account can only unstake tokens that aren't custodied
2019         require(isUnstakeAllowed(msg.sender),                                        "SL:OUTSIDE_COOLDOWN");
2020         require(stakeDate[msg.sender].add(lockupPeriod) <= block.timestamp,          "SL:FUNDS_LOCKED");
2021 
2022         updateFundsReceived();   // Account for any funds transferred into contract since last call.
2023         _burn(msg.sender, amt);  // Burn the corresponding StakeLockerFDTs balance.
2024         withdrawFunds();         // Transfer the full entitled Liquidity Asset interest.
2025 
2026         stakeAsset.safeTransfer(msg.sender, amt.sub(_recognizeLosses()));  // Unstake amount minus losses.
2027 
2028         emit Unstake(msg.sender, amt);
2029         emit BalanceUpdated(address(this), address(stakeAsset), stakeAsset.balanceOf(address(this)));
2030     }
2031 
2032     /**
2033         @dev Withdraws all claimable interest earned from the StakeLocker for an account.
2034         @dev It emits a `BalanceUpdated` event if there are withdrawable funds.
2035     */
2036     function withdrawFunds() public override {
2037         _whenProtocolNotPaused();
2038 
2039         uint256 withdrawableFunds = _prepareWithdraw();
2040 
2041         if (withdrawableFunds == uint256(0)) return;
2042 
2043         fundsToken.safeTransfer(msg.sender, withdrawableFunds);
2044         emit BalanceUpdated(address(this), address(fundsToken), fundsToken.balanceOf(address(this)));
2045 
2046         _updateFundsTokenBalance();
2047     }
2048 
2049     /**
2050         @dev   Increases the custody allowance for a given Custodian corresponding to the account (`msg.sender`).
2051         @dev   It emits a `CustodyAllowanceChanged` event.
2052         @dev   It emits a `TotalCustodyAllowanceUpdated` event.
2053         @param custodian Address which will act as Custodian of a given amount for an account.
2054         @param amount    Number of additional FDTs to be custodied by the Custodian.
2055     */
2056     function increaseCustodyAllowance(address custodian, uint256 amount) external {
2057         uint256 oldAllowance      = custodyAllowance[msg.sender][custodian];
2058         uint256 newAllowance      = oldAllowance.add(amount);
2059         uint256 newTotalAllowance = totalCustodyAllowance[msg.sender].add(amount);
2060 
2061         require(custodian != address(0),                    "SL:INVALID_CUSTODIAN");
2062         require(amount    != uint256(0),                    "SL:INVALID_AMT");
2063         require(newTotalAllowance <= balanceOf(msg.sender), "SL:INSUF_BALANCE");
2064 
2065         custodyAllowance[msg.sender][custodian] = newAllowance;
2066         totalCustodyAllowance[msg.sender]       = newTotalAllowance;
2067         emit CustodyAllowanceChanged(msg.sender, custodian, oldAllowance, newAllowance);
2068         emit TotalCustodyAllowanceUpdated(msg.sender, newTotalAllowance);
2069     }
2070 
2071     /**
2072         @dev   Transfers custodied StakeLockerFDTs back to the account.
2073         @dev   `from` and `to` should always be equal in this implementation.
2074         @dev   This means that the Custodian can only decrease their own allowance and unlock funds for the original owner.
2075         @dev   It emits a `CustodyTransfer` event.
2076         @dev   It emits a `CustodyAllowanceChanged` event.
2077         @dev   It emits a `TotalCustodyAllowanceUpdated` event.
2078         @param from   Address which holds the StakeLockerFDTs.
2079         @param to     Address which will be the new owner of the amount of StakeLockerFDTs.
2080         @param amount Amount of StakeLockerFDTs transferred.
2081     */
2082     function transferByCustodian(address from, address to, uint256 amount) external {
2083         uint256 oldAllowance = custodyAllowance[from][msg.sender];
2084         uint256 newAllowance = oldAllowance.sub(amount);
2085 
2086         require(to == from,             "SL:INVALID_RECEIVER");
2087         require(amount != uint256(0),   "SL:INVALID_AMT");
2088 
2089         custodyAllowance[from][msg.sender] = newAllowance;
2090         uint256 newTotalAllowance          = totalCustodyAllowance[from].sub(amount);
2091         totalCustodyAllowance[from]        = newTotalAllowance;
2092         emit CustodyTransfer(msg.sender, from, to, amount);
2093         emit CustodyAllowanceChanged(from, msg.sender, oldAllowance, newAllowance);
2094         emit TotalCustodyAllowanceUpdated(msg.sender, newTotalAllowance);
2095     }
2096 
2097     /**
2098         @dev   Transfers StakeLockerFDTs.
2099         @param from Address sending   StakeLockerFDTs.
2100         @param to   Address receiving StakeLockerFDTs.
2101         @param wad  Amount of StakeLockerFDTs to transfer.
2102     */
2103     function _transfer(address from, address to, uint256 wad) internal override canUnstake(from) {
2104         _whenProtocolNotPaused();
2105         require(stakeDate[from].add(lockupPeriod) <= block.timestamp,    "SL:FUNDS_LOCKED");            // Restrict withdrawal during lockup period
2106         require(balanceOf(from).sub(wad) >= totalCustodyAllowance[from], "SL:INSUF_TRANSFERABLE_BAL");  // Account can only transfer tokens that aren't custodied
2107         require(isReceiveAllowed(unstakeCooldown[to]),                   "SL:RECIPIENT_NOT_ALLOWED");   // Recipient must not be currently unstaking
2108         require(recognizableLossesOf(from) == uint256(0),                "SL:RECOG_LOSSES");            // If a staker has unrecognized losses, they must recognize losses through unstake
2109         _updateStakeDate(to, wad);                                                                      // Update stake date of recipient
2110         super._transfer(from, to, wad);
2111     }
2112 
2113     /***********************/
2114     /*** Admin Functions ***/
2115     /***********************/
2116 
2117     /**
2118         @dev Triggers paused state. Halts functionality for certain functions. Only the Pool Delegate or a Pool Admin can call this function.
2119     */
2120     function pause() external {
2121         _isValidPoolDelegateOrPoolAdmin();
2122         super._pause();
2123     }
2124 
2125     /**
2126         @dev Triggers unpaused state. Restores functionality for certain functions. Only the Pool Delegate or a Pool Admin can call this function.
2127     */
2128     function unpause() external {
2129         _isValidPoolDelegateOrPoolAdmin();
2130         super._unpause();
2131     }
2132 
2133     /************************/
2134     /*** Helper Functions ***/
2135     /************************/
2136 
2137     /**
2138         @dev Returns if the unstake cooldown period has passed for `msg.sender` and if they are in the unstake window.
2139     */
2140     function isUnstakeAllowed(address from) public view returns (bool) {
2141         IMapleGlobals globals = _globals();
2142         return (block.timestamp - (unstakeCooldown[from] + globals.stakerCooldownPeriod())) <= globals.stakerUnstakeWindow();
2143     }
2144 
2145     /**
2146         @dev Returns if an account is allowed to receive a transfer.
2147              This is only possible if they have zero cooldown or they are past their unstake window.
2148     */
2149     function isReceiveAllowed(uint256 _unstakeCooldown) public view returns (bool) {
2150         IMapleGlobals globals = _globals();
2151         return block.timestamp > (_unstakeCooldown + globals.stakerCooldownPeriod() + globals.stakerUnstakeWindow());
2152     }
2153 
2154     /**
2155         @dev Checks that `msg.sender` is the Pool Delegate or a Pool Admin.
2156     */
2157     function _isValidPoolDelegateOrPoolAdmin() internal view {
2158         require(msg.sender == IPool(pool).poolDelegate() || IPool(pool).poolAdmins(msg.sender), "SL:NOT_DELEGATE_OR_ADMIN");
2159     }
2160 
2161     /**
2162         @dev Checks that `msg.sender` is the Pool Delegate.
2163     */
2164     function _isValidPoolDelegate() internal view {
2165         require(msg.sender == IPool(pool).poolDelegate(), "SL:NOT_DELEGATE");
2166     }
2167 
2168     /**
2169         @dev Checks that `msg.sender` is allowed to stake.
2170     */
2171     function _isAllowed(address account) internal view {
2172         require(
2173             openToPublic || allowed[account] || account == IPool(pool).poolDelegate(),
2174             "SL:NOT_ALLOWED"
2175         );
2176     }
2177 
2178     /**
2179         @dev Returns the MapleGlobals instance.
2180     */
2181     function _globals() internal view returns (IMapleGlobals) {
2182         return IMapleGlobals(IPoolFactory(IPool(pool).superFactory()).globals());
2183     }
2184 
2185     /**
2186         @dev Checks that the protocol is not in a paused state.
2187     */
2188     function _whenProtocolNotPaused() internal view {
2189         require(!_globals().protocolPaused(), "SL:PROTO_PAUSED");
2190     }
2191 
2192 }
