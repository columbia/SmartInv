1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.15;
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         _checkOwner();
62         _;
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if the sender is not the owner.
74      */
75     function _checkOwner() internal view virtual {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 
132     /**
133      * @dev Returns the amount of tokens in existence.
134      */
135     function totalSupply() external view returns (uint256);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `to`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(address to, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through {transferFrom}. This is
154      * zero by default.
155      *
156      * This value changes when {approve} or {transferFrom} are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * IMPORTANT: Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `from` to `to` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address from,
187         address to,
188         uint256 amount
189     ) external returns (bool);
190 }
191 
192 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 // CAUTION
197 // This version of SafeMath should only be used with Solidity 0.8 or later,
198 // because it relies on the compiler's built in overflow checks.
199 
200 /**
201  * @dev Wrappers over Solidity's arithmetic operations.
202  *
203  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
204  * now has built in overflow checking.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, with an overflow flag.
209      *
210      * _Available since v3.4._
211      */
212     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             uint256 c = a + b;
215             if (c < a) return (false, 0);
216             return (true, c);
217         }
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
222      *
223      * _Available since v3.4._
224      */
225     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
226         unchecked {
227             if (b > a) return (false, 0);
228             return (true, a - b);
229         }
230     }
231 
232     /**
233      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
234      *
235      * _Available since v3.4._
236      */
237     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
238         unchecked {
239             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
240             // benefit is lost if 'b' is also tested.
241             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
242             if (a == 0) return (true, 0);
243             uint256 c = a * b;
244             if (c / a != b) return (false, 0);
245             return (true, c);
246         }
247     }
248 
249     /**
250      * @dev Returns the division of two unsigned integers, with a division by zero flag.
251      *
252      * _Available since v3.4._
253      */
254     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
255         unchecked {
256             if (b == 0) return (false, 0);
257             return (true, a / b);
258         }
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
263      *
264      * _Available since v3.4._
265      */
266     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         unchecked {
268             if (b == 0) return (false, 0);
269             return (true, a % b);
270         }
271     }
272 
273     /**
274      * @dev Returns the addition of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `+` operator.
278      *
279      * Requirements:
280      *
281      * - Addition cannot overflow.
282      */
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a + b;
285     }
286 
287     /**
288      * @dev Returns the subtraction of two unsigned integers, reverting on
289      * overflow (when the result is negative).
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a - b;
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, reverting on
303      * overflow.
304      *
305      * Counterpart to Solidity's `*` operator.
306      *
307      * Requirements:
308      *
309      * - Multiplication cannot overflow.
310      */
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a * b;
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers, reverting on
317      * division by zero. The result is rounded towards zero.
318      *
319      * Counterpart to Solidity's `/` operator.
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function div(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a / b;
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * reverting when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
342         return a % b;
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
347      * overflow (when the result is negative).
348      *
349      * CAUTION: This function is deprecated because it requires allocating memory for the error
350      * message unnecessarily. For custom revert reasons use {trySub}.
351      *
352      * Counterpart to Solidity's `-` operator.
353      *
354      * Requirements:
355      *
356      * - Subtraction cannot overflow.
357      */
358     function sub(
359         uint256 a,
360         uint256 b,
361         string memory errorMessage
362     ) internal pure returns (uint256) {
363         unchecked {
364             require(b <= a, errorMessage);
365             return a - b;
366         }
367     }
368 
369     /**
370      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
371      * division by zero. The result is rounded towards zero.
372      *
373      * Counterpart to Solidity's `/` operator. Note: this function uses a
374      * `revert` opcode (which leaves remaining gas untouched) while Solidity
375      * uses an invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      *
379      * - The divisor cannot be zero.
380      */
381     function div(
382         uint256 a,
383         uint256 b,
384         string memory errorMessage
385     ) internal pure returns (uint256) {
386         unchecked {
387             require(b > 0, errorMessage);
388             return a / b;
389         }
390     }
391 
392     /**
393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
394      * reverting with custom message when dividing by zero.
395      *
396      * CAUTION: This function is deprecated because it requires allocating memory for the error
397      * message unnecessarily. For custom revert reasons use {tryMod}.
398      *
399      * Counterpart to Solidity's `%` operator. This function uses a `revert`
400      * opcode (which leaves remaining gas untouched) while Solidity uses an
401      * invalid opcode to revert (consuming all remaining gas).
402      *
403      * Requirements:
404      *
405      * - The divisor cannot be zero.
406      */
407     function mod(
408         uint256 a,
409         uint256 b,
410         string memory errorMessage
411     ) internal pure returns (uint256) {
412         unchecked {
413             require(b > 0, errorMessage);
414             return a % b;
415         }
416     }
417 }
418 
419 pragma solidity >=0.5.0;
420 
421 interface IUniswapV2Factory {
422     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
423 
424     function feeTo() external view returns (address);
425     function feeToSetter() external view returns (address);
426 
427     function getPair(address tokenA, address tokenB) external view returns (address pair);
428     function allPairs(uint) external view returns (address pair);
429     function allPairsLength() external view returns (uint);
430 
431     function createPair(address tokenA, address tokenB) external returns (address pair);
432 
433     function setFeeTo(address) external;
434     function setFeeToSetter(address) external;
435 }
436 
437 pragma solidity >=0.6.2;
438 
439 interface IUniswapV2Router01 {
440     function factory() external pure returns (address);
441     function WETH() external pure returns (address);
442 
443     function addLiquidity(
444         address tokenA,
445         address tokenB,
446         uint amountADesired,
447         uint amountBDesired,
448         uint amountAMin,
449         uint amountBMin,
450         address to,
451         uint deadline
452     ) external returns (uint amountA, uint amountB, uint liquidity);
453     function addLiquidityETH(
454         address token,
455         uint amountTokenDesired,
456         uint amountTokenMin,
457         uint amountETHMin,
458         address to,
459         uint deadline
460     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
461     function removeLiquidity(
462         address tokenA,
463         address tokenB,
464         uint liquidity,
465         uint amountAMin,
466         uint amountBMin,
467         address to,
468         uint deadline
469     ) external returns (uint amountA, uint amountB);
470     function removeLiquidityETH(
471         address token,
472         uint liquidity,
473         uint amountTokenMin,
474         uint amountETHMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountToken, uint amountETH);
478     function removeLiquidityWithPermit(
479         address tokenA,
480         address tokenB,
481         uint liquidity,
482         uint amountAMin,
483         uint amountBMin,
484         address to,
485         uint deadline,
486         bool approveMax, uint8 v, bytes32 r, bytes32 s
487     ) external returns (uint amountA, uint amountB);
488     function removeLiquidityETHWithPermit(
489         address token,
490         uint liquidity,
491         uint amountTokenMin,
492         uint amountETHMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external returns (uint amountToken, uint amountETH);
497     function swapExactTokensForTokens(
498         uint amountIn,
499         uint amountOutMin,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external returns (uint[] memory amounts);
504     function swapTokensForExactTokens(
505         uint amountOut,
506         uint amountInMax,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external returns (uint[] memory amounts);
511     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
512         external
513         payable
514         returns (uint[] memory amounts);
515     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
516         external
517         returns (uint[] memory amounts);
518     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
519         external
520         returns (uint[] memory amounts);
521     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
522         external
523         payable
524         returns (uint[] memory amounts);
525 
526     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
527     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
528     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
529     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
530     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
531 }
532 
533 pragma solidity >=0.6.2;
534 
535 interface IUniswapV2Router02 is IUniswapV2Router01 {
536     function removeLiquidityETHSupportingFeeOnTransferTokens(
537         address token,
538         uint liquidity,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline
543     ) external returns (uint amountETH);
544     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
545         address token,
546         uint liquidity,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline,
551         bool approveMax, uint8 v, bytes32 r, bytes32 s
552     ) external returns (uint amountETH);
553 
554     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external;
561     function swapExactETHForTokensSupportingFeeOnTransferTokens(
562         uint amountOutMin,
563         address[] calldata path,
564         address to,
565         uint deadline
566     ) external payable;
567     function swapExactTokensForETHSupportingFeeOnTransferTokens(
568         uint amountIn,
569         uint amountOutMin,
570         address[] calldata path,
571         address to,
572         uint deadline
573     ) external;
574 }
575 
576 pragma solidity ^0.8.15;
577 
578 interface IParrotRewards {
579     function claimReward() external;
580     function depositRewards() external payable;
581     function getLockedShares(address wallet) external view returns (uint256);
582     function lock(uint256 amount) external;
583     function unlock(uint256 amount) external;
584 }
585 
586 pragma solidity ^0.8.15;
587 
588 contract ParrotRewards is IParrotRewards, Ownable {
589     address public shareholderToken;
590 
591     uint256 private constant ONE_DAY = 60 * 60 * 24;
592     uint256 public timeLock = 30 days;
593     uint256 public totalLockedUsers;
594     uint256 public totalSharesDeposited;
595     uint256 public totalRewards;
596     uint256 public totalDistributed;
597     uint256 public rewardsPerShare;
598     uint256 private constant ACC_FACTOR = 10**36;
599 
600     int256 private constant OFFSET19700101 = 2440588;
601 
602     uint8 public minDayOfMonthCanLock = 1;
603     uint8 public maxDayOfMonthCanLock = 5;
604 
605     struct Reward {
606         uint256 totalExcluded;
607         uint256 totalRealised;
608         uint256 lastClaim;
609     }
610 
611     struct Share {
612         uint256 amount;
613         uint256 lockedTime;
614     }
615 
616     // amount of shares a user has
617     mapping(address => Share) public shares;
618     // reward information per user
619     mapping(address => Reward) public rewards;
620 
621     event ClaimReward(address wallet);
622     event DistributeReward(address indexed wallet, address payable receiver);
623     event DepositRewards(address indexed wallet, uint256 amountETH);
624 
625     constructor(address _shareholderToken) {
626         shareholderToken = _shareholderToken;
627     }
628 
629     function lock(uint256 _amount) external {
630         uint256 _currentDayOfMonth = _dayOfMonth(block.timestamp);
631         require(
632             _currentDayOfMonth >= minDayOfMonthCanLock &&
633             _currentDayOfMonth <= maxDayOfMonthCanLock,
634             "outside of allowed lock window"
635         );
636         address shareholder = msg.sender;
637         IERC20 tokenContract = IERC20(shareholderToken);
638         _amount = _amount == 0 ? tokenContract.balanceOf(shareholder) : _amount;
639         tokenContract.transferFrom(shareholder, address(this), _amount);
640         _addShares(shareholder, _amount);
641     }
642 
643     function unlock(uint256 _amount) external {
644         address shareholder = msg.sender;
645         require(
646             block.timestamp >= shares[shareholder].lockedTime + timeLock,
647             "must wait the time lock before unstaking"
648         );
649         _amount = _amount == 0 ? shares[shareholder].amount : _amount;
650         require(_amount > 0, "need tokens to unlock");
651         require(
652             _amount <= shares[shareholder].amount,
653             "cannot unlock more than you have locked"
654         );
655         IERC20(shareholderToken).transfer(shareholder, _amount);
656         _removeShares(shareholder, _amount);
657     }
658 
659     function _addShares(address shareholder, uint256 amount) internal {
660         _distributeReward(shareholder);
661 
662         uint256 sharesBefore = shares[shareholder].amount;
663         totalSharesDeposited += amount;
664         shares[shareholder].amount += amount;
665         shares[shareholder].lockedTime = block.timestamp;
666         if (sharesBefore == 0 && shares[shareholder].amount > 0) {
667             totalLockedUsers++;
668         }
669         rewards[shareholder].totalExcluded = getCumulativeRewards(
670             shares[shareholder].amount
671         );
672     }
673 
674     function _removeShares(address shareholder, uint256 amount) internal {
675         amount = amount == 0 ? shares[shareholder].amount : amount;
676         require(
677             shares[shareholder].amount > 0 && amount <= shares[shareholder].amount,
678             "you can only unlock if you have some lockd"
679         );
680         _distributeReward(shareholder);
681 
682         totalSharesDeposited -= amount;
683         shares[shareholder].amount -= amount;
684         if (shares[shareholder].amount == 0) {
685             totalLockedUsers--;
686         }
687         rewards[shareholder].totalExcluded = getCumulativeRewards(
688             shares[shareholder].amount
689         );
690   }
691 
692     function depositRewards() public payable override {
693         _depositRewards(msg.value);
694     }
695 
696     function _depositRewards(uint256 _amount) internal {
697         require(_amount > 0, "must provide ETH to deposit");
698         require(totalSharesDeposited > 0, "must be shares deposited");
699 
700         totalRewards += _amount;
701         rewardsPerShare += (ACC_FACTOR * _amount) / totalSharesDeposited;
702         emit DepositRewards(msg.sender, _amount);
703     }
704 
705     function _distributeReward(address shareholder) internal {
706         if (shares[shareholder].amount == 0) {
707             return;
708         }
709 
710         uint256 amount = getUnpaid(shareholder);
711 
712         rewards[shareholder].totalRealised += amount;
713         rewards[shareholder].totalExcluded = getCumulativeRewards(
714             shares[shareholder].amount
715         );
716         rewards[shareholder].lastClaim = block.timestamp;
717 
718         if (amount > 0) {
719             bool success;
720             address payable receiver = payable(shareholder);
721             totalDistributed += amount;
722             uint256 balanceBefore = address(this).balance;
723             (success,) = receiver.call{ value: amount }('');
724             require(address(this).balance >= balanceBefore - amount);
725             emit DistributeReward(shareholder, receiver);
726         }
727     }
728 
729     function _dayOfMonth(uint256 _timestamp) internal pure returns (uint256) {
730         (, , uint256 day) = _daysToDate(_timestamp / ONE_DAY);
731         return day;
732     }
733 
734     // date conversion algorithm from http://aa.usno.navy.mil/faq/docs/JD_Formula.php
735     function _daysToDate(uint256 _days) internal pure returns (uint256, uint256, uint256) {
736         int256 __days = int256(_days);
737 
738         int256 L = __days + 68569 + OFFSET19700101;
739         int256 N = (4 * L) / 146097;
740         L = L - (146097 * N + 3) / 4;
741         int256 _year = (4000 * (L + 1)) / 1461001;
742         L = L - (1461 * _year) / 4 + 31;
743         int256 _month = (80 * L) / 2447;
744         int256 _day = L - (2447 * _month) / 80;
745         L = _month / 11;
746         _month = _month + 2 - 12 * L;
747         _year = 100 * (N - 49) + _year + L;
748 
749         return (uint256(_year), uint256(_month), uint256(_day));
750     }
751 
752     function claimReward() external override {
753         _distributeReward(msg.sender);
754         emit ClaimReward(msg.sender);
755     }
756 
757     // returns the unpaid rewards
758     function getUnpaid(address shareholder) public view returns (uint256) {
759         if (shares[shareholder].amount == 0) {
760             return 0;
761         }
762 
763         uint256 earnedRewards = getCumulativeRewards(shares[shareholder].amount);
764         uint256 rewardsExcluded = rewards[shareholder].totalExcluded;
765         if (earnedRewards <= rewardsExcluded) {
766             return 0;
767         }
768 
769         return earnedRewards - rewardsExcluded;
770     }
771 
772     function getCumulativeRewards(uint256 share) internal view returns (uint256) {
773         return (share * rewardsPerShare) / ACC_FACTOR;
774     }
775 
776     function getLockedShares(address user) external view override returns (uint256) {
777         return shares[user].amount;
778     }
779 
780     function setMinDayOfMonthCanLock(uint8 _day) external onlyOwner {
781         require(_day <= maxDayOfMonthCanLock, "can set min day above max day");
782         minDayOfMonthCanLock = _day;
783     }
784 
785     function setMaxDayOfMonthCanLock(uint8 _day) external onlyOwner {
786         require(_day >= minDayOfMonthCanLock, "can set max day below min day");
787         maxDayOfMonthCanLock = _day;
788     }
789 
790     function setTimeLock(uint256 numSec) external onlyOwner {
791         require(numSec <= 365 days, "must be less than a year");
792         timeLock = numSec;
793     }
794 
795     function withdrawStuckETH() external onlyOwner {
796         bool success;
797         (success,) = address(msg.sender).call{value: address(this).balance}("");
798     }
799 
800     receive() external payable {
801         _depositRewards(msg.value);
802     }
803 }
804 
805 pragma solidity ^0.8.15;
806 
807 interface IUSDCReceiver {
808     function initialize(address) external;
809     function withdraw() external;
810     function withdrawUnsupportedAsset(address, uint256) external;
811 }
812 
813 pragma solidity ^0.8.15;
814 
815 contract USDCReceiver is IUSDCReceiver, Ownable {
816 
817     address public usdc;
818     address public token;
819 
820     constructor() Ownable() {
821         token = msg.sender;
822     }
823 
824     function initialize(address _usdc) public onlyOwner {
825         require(usdc == address(0x0), "Already initialized");
826         usdc = _usdc;
827     }
828 
829     function withdraw() public {
830         require(msg.sender == token, "Caller is not token");
831         IERC20(usdc).transfer(token, IERC20(usdc).balanceOf(address(this)));
832     }
833 
834     function withdrawUnsupportedAsset(address _token, uint256 _amount) public onlyOwner {
835         if(_token == address(0x0))
836             payable(owner()).transfer(_amount);
837         else
838             IERC20(_token).transfer(owner(), _amount);
839     }
840 }
841 
842 contract Parrot is Context, IERC20, Ownable {
843     using SafeMath for uint256;
844 
845     IUniswapV2Router02 private _uniswapV2Router;
846 
847     ParrotRewards private _rewards;
848     USDCReceiver private _receiver;
849 
850     mapping (address => uint) private _cooldown;
851 
852     mapping (address => uint256) private _rOwned;
853 
854     mapping (address => mapping (address => uint256)) private _allowances;
855 
856     mapping (address => bool) private _isExcludedFromFees;
857     mapping (address => bool) private _isExcludedMaxTransactionAmount;
858     mapping (address => bool) private _isBlacklisted;
859 
860     bool public tradingOpen;
861     bool private swapping;
862     bool private swapEnabled = false;
863     bool public cooldownEnabled = false;
864     bool public feesEnabled = true;
865 
866     string private constant _name = "Parrot";
867     string private constant _symbol = "PRT";
868 
869     uint8 private constant _decimals = 18;
870 
871     uint256 private constant _tTotal = 1e9 * (10**_decimals);
872     uint256 public maxBuyAmount = _tTotal;
873     uint256 public maxSellAmount = _tTotal;
874     uint256 public maxWalletAmount = _tTotal;
875     uint256 public tradingActiveBlock = 0;
876     uint256 private _blocksToBlacklist = 0;
877     uint256 private _cooldownBlocks = 1;
878     uint256 public constant FEE_DIVISOR = 1000;
879     uint256 public buyLiquidityFee = 10;
880     uint256 private _previousBuyLiquidityFee = buyLiquidityFee;
881     uint256 public buyTreasuryFee = 70;
882     uint256 private _previousBuyTreasuryFee = buyTreasuryFee;
883     uint256 public buyDevelopmentFee = 20;
884     uint256 private _previousBuyDevelopmentFee = buyDevelopmentFee;
885     uint256 public sellLiquidityFee = 10;
886     uint256 private _previousSellLiquidityFee = sellLiquidityFee;
887     uint256 public sellTreasuryFee = 70;
888     uint256 private _previousSellTreasuryFee = sellTreasuryFee;
889     uint256 public sellDevelopmentFee = 20;
890     uint256 private _previousSellDevelopmentFee = sellDevelopmentFee;
891     uint256 private _tokensForLiquidity;
892     uint256 private _tokensForTreasury;
893     uint256 private _tokensForDevelopment;
894     uint256 private _swapTokensAtAmount = 0;
895 
896     address payable public liquidityWallet;
897     address payable public treasuryWallet;
898     address payable public developmentWallet;
899     address private _uniswapV2Pair;
900     address private DEAD = 0x000000000000000000000000000000000000dEaD;
901     address private ZERO = 0x0000000000000000000000000000000000000000;
902     address private USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
903     
904     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
905     
906     constructor (address liquidityWalletAddy, address treasuryWalletAddy, address developmentWalletAddy) {
907         liquidityWallet = payable(liquidityWalletAddy);
908         treasuryWallet = payable(treasuryWalletAddy);
909         developmentWallet = payable(developmentWalletAddy);
910 
911         _rewards = new ParrotRewards(address(this));
912         _rewards.transferOwnership(msg.sender);
913 
914         _receiver = new USDCReceiver();
915         _receiver.initialize(USDC);
916         _receiver.transferOwnership(msg.sender);
917 
918         _rOwned[_msgSender()] = _tTotal;
919 
920         _isExcludedFromFees[owner()] = true;
921         _isExcludedFromFees[address(this)] = true;
922         _isExcludedFromFees[address(_receiver)] = true;
923         _isExcludedFromFees[DEAD] = true;
924         _isExcludedFromFees[liquidityWallet] = true;
925         _isExcludedFromFees[treasuryWallet] = true;
926         _isExcludedFromFees[developmentWallet] = true;
927 
928         _isExcludedMaxTransactionAmount[owner()] = true;
929         _isExcludedMaxTransactionAmount[address(this)] = true;
930         _isExcludedMaxTransactionAmount[address(_receiver)] = true;
931         _isExcludedMaxTransactionAmount[DEAD] = true;
932         _isExcludedMaxTransactionAmount[liquidityWallet] = true;
933         _isExcludedMaxTransactionAmount[treasuryWallet] = true;
934         _isExcludedMaxTransactionAmount[developmentWallet] = true;
935 
936         _rewards = new ParrotRewards(address(this));
937         _rewards.transferOwnership(msg.sender);
938 
939         _receiver = new USDCReceiver();
940         _receiver.initialize(USDC);
941         _receiver.transferOwnership(msg.sender);
942 
943         emit Transfer(ZERO, _msgSender(), _tTotal);
944     }
945 
946     function name() public pure returns (string memory) {
947         return _name;
948     }
949 
950     function symbol() public pure returns (string memory) {
951         return _symbol;
952     }
953 
954     function decimals() public pure returns (uint8) {
955         return _decimals;
956     }
957 
958     function totalSupply() public pure override returns (uint256) {
959         return _tTotal;
960     }
961 
962     function balanceOf(address account) public view override returns (uint256) {
963         return _rOwned[account];
964     }
965 
966     function transfer(address recipient, uint256 amount) public override returns (bool) {
967         _transfer(_msgSender(), recipient, amount);
968         return true;
969     }
970 
971     function allowance(address owner, address spender) public view override returns (uint256) {
972         return _allowances[owner][spender];
973     }
974 
975     function approve(address spender, uint256 amount) public override returns (bool) {
976         _approve(_msgSender(), spender, amount);
977         return true;
978     }
979 
980     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
981         _transfer(sender, recipient, amount);
982         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
983         return true;
984     }
985 
986     function setCooldownEnabled(bool onoff) external onlyOwner {
987         cooldownEnabled = onoff;
988     }
989 
990     function setSwapEnabled(bool onoff) external onlyOwner {
991         swapEnabled = onoff;
992     }
993 
994     function setFeesEnabled(bool onoff) external onlyOwner {
995         feesEnabled = onoff;
996     }
997 
998     function _approve(address owner, address spender, uint256 amount) private {
999         require(owner != ZERO, "ERC20: approve from the zero address");
1000         require(spender != ZERO, "ERC20: approve to the zero address");
1001         _allowances[owner][spender] = amount;
1002         emit Approval(owner, spender, amount);
1003     }
1004 
1005     function _transfer(address from, address to, uint256 amount) private {
1006         require(from != ZERO, "ERC20: transfer from the zero address");
1007         require(to != ZERO, "ERC20: transfer to the zero address");
1008         require(amount > 0, "Transfer amount must be greater than zero");
1009         bool takeFee = true;
1010         bool shouldSwap = false;
1011         if (from != owner() && to != owner() && to != ZERO && to != DEAD && !swapping) {
1012             require(!_isBlacklisted[from] && !_isBlacklisted[to]);
1013 
1014             if(!tradingOpen) {
1015                 require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not allowed yet.");
1016             }
1017 
1018             if (cooldownEnabled) {
1019                 if (to != address(_uniswapV2Router) && to != address(_uniswapV2Pair)){
1020                     require(_cooldown[tx.origin] < block.number - _cooldownBlocks && _cooldown[to] < block.number - _cooldownBlocks, "Transfer delay enabled. Try again later.");
1021                     _cooldown[tx.origin] = block.number;
1022                     _cooldown[to] = block.number;
1023                 }
1024             }
1025 
1026             if (from == _uniswapV2Pair && to != address(_uniswapV2Router) && !_isExcludedMaxTransactionAmount[to]) {
1027                 require(amount <= maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
1028                 require(balanceOf(to) + amount <= maxWalletAmount, "Exceeds maximum wallet token amount.");
1029             }
1030             
1031             if (to == _uniswapV2Pair && from != address(_uniswapV2Router) && !_isExcludedMaxTransactionAmount[from]) {
1032                 require(amount <= maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
1033                 shouldSwap = true;
1034             }
1035         }
1036 
1037         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || !feesEnabled) {
1038             takeFee = false;
1039         }
1040 
1041         uint256 contractTokenBalance = balanceOf(address(this));
1042         bool canSwap = (contractTokenBalance > _swapTokensAtAmount) && shouldSwap;
1043 
1044         if (canSwap && swapEnabled && !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1045             swapping = true;
1046             swapBack();
1047             swapping = false;
1048         }
1049 
1050         _tokenTransfer(from, to, amount, takeFee, shouldSwap);
1051     }
1052 
1053     function swapBack() private {
1054         uint256 contractBalance = balanceOf(address(this));
1055         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForTreasury + _tokensForDevelopment;
1056         
1057         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1058 
1059         if(contractBalance > _swapTokensAtAmount * 5) {
1060             contractBalance = _swapTokensAtAmount * 5;
1061         }
1062         
1063         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
1064         uint256 amountToSwapForUSDC = contractBalance.sub(liquidityTokens);
1065         
1066         uint256 initialUSDCBalance = IERC20(USDC).balanceOf(address(this));
1067 
1068         swapTokensForTokens(amountToSwapForUSDC);
1069         _receiver.withdraw();
1070         
1071         uint256 usdcBalance = IERC20(USDC).balanceOf(address(this)).sub(initialUSDCBalance);
1072         uint256 usdcForTreasury = usdcBalance.mul(_tokensForTreasury).div(totalTokensToSwap);
1073         uint256 usdcForDevelopment = usdcBalance.mul(_tokensForDevelopment).div(totalTokensToSwap);
1074         uint256 usdcForLiquidity = usdcBalance - usdcForTreasury - usdcForDevelopment;
1075         
1076         _tokensForLiquidity = 0;
1077         _tokensForTreasury = 0;
1078         _tokensForDevelopment = 0;
1079         
1080         if(liquidityTokens > 0 && usdcForLiquidity > 0){
1081             addLiquidity(liquidityTokens, usdcForLiquidity);
1082             emit SwapAndLiquify(amountToSwapForUSDC, usdcForLiquidity, _tokensForLiquidity);
1083         }
1084         
1085         IERC20(USDC).transfer(developmentWallet, usdcForDevelopment);
1086         IERC20(USDC).transfer(treasuryWallet, IERC20(USDC).balanceOf(address(this)));
1087     }
1088 
1089     function swapTokensForTokens(uint256 tokenAmount) private {
1090         address[] memory path = new address[](2);
1091         path[0] = address(this);
1092         path[1] = USDC;
1093         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1094         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1095             tokenAmount,
1096             0,
1097             path,
1098             address(_receiver),
1099             block.timestamp
1100         );
1101     }
1102 
1103     function addLiquidity(uint256 tokenAmount, uint256 usdcAmount) private {
1104         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1105         IERC20(USDC).approve(address(_uniswapV2Router), usdcAmount);
1106         _uniswapV2Router.addLiquidity(
1107             address(this),
1108             USDC,
1109             tokenAmount,
1110             usdcAmount,
1111             0,
1112             0,
1113             liquidityWallet,
1114             block.timestamp
1115         );
1116     }
1117         
1118     function sendUSDCToFee(uint256 amount) private {
1119         IERC20(USDC).transfer(treasuryWallet, amount.div(2));
1120         IERC20(USDC).transfer(developmentWallet, amount.div(2));
1121     }
1122 
1123     function rewardsContract() external view returns (address) {
1124         return address(_rewards);
1125     }
1126 
1127     function usdcReceiverContract() external view returns (address) {
1128         return address(_receiver);
1129     }
1130 
1131     function isBlacklisted(address wallet) external view returns (bool) {
1132         return _isBlacklisted[wallet];
1133     }
1134     
1135     function launch() external onlyOwner {
1136         require(!tradingOpen, "Trading is already open");
1137         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1138         _uniswapV2Router = uniswapV2Router;
1139         _approve(address(this), address(_uniswapV2Router), _tTotal);
1140         IERC20(USDC).approve(address(_uniswapV2Router), IERC20(USDC).balanceOf(address(this)));
1141         _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), USDC);
1142         _uniswapV2Router.addLiquidity(address(this), USDC, balanceOf(address(this)), IERC20(USDC).balanceOf(address(this)), 0, 0, owner(), block.timestamp);
1143         swapEnabled = true;
1144         _swapTokensAtAmount = 5e5 * (10**_decimals);
1145         tradingOpen = true;
1146         tradingActiveBlock = block.number;
1147         IERC20(_uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
1148     }
1149 
1150     function setMaxBuyAmount(uint256 maxBuy) external onlyOwner {
1151         require(maxBuy >= 1e5 * (10**_decimals), "Max buy amount cannot be lower than 0.01% total supply.");
1152         maxBuyAmount = maxBuy;
1153     }
1154 
1155     function setMaxSellAmount(uint256 maxSell) external onlyOwner {
1156         require(maxSell >= 1e5 * (10**_decimals), "Max sell amount cannot be lower than 0.01% total supply.");
1157         maxSellAmount = maxSell;
1158     }
1159     
1160     function setMaxWalletAmount(uint256 maxToken) external onlyOwner {
1161         require(maxToken >= 1e6 * (10**_decimals), "Max wallet amount cannot be lower than 0.1% total supply.");
1162         maxWalletAmount = maxToken;
1163     }
1164     
1165     function setSwapTokensAtAmount(uint256 swapAmount) external onlyOwner {
1166         require(swapAmount >= 1e4 * (10**_decimals), "Swap amount cannot be lower than 0.001% total supply.");
1167         require(swapAmount <= 5e6 * (10**_decimals), "Swap amount cannot be higher than 0.5% total supply.");
1168         _swapTokensAtAmount = swapAmount;
1169     }
1170 
1171     function setLiquidityWallet(address liquidityWalletAddy) external onlyOwner {
1172         require(liquidityWalletAddy != ZERO, "liquidityWallet address cannot be 0");
1173         _isExcludedFromFees[liquidityWallet] = false;
1174         _isExcludedMaxTransactionAmount[liquidityWallet] = false;
1175         liquidityWallet = payable(liquidityWalletAddy);
1176         _isExcludedFromFees[liquidityWallet] = true;
1177         _isExcludedMaxTransactionAmount[liquidityWallet] = true;
1178     }
1179 
1180     function setTreasuryWallet(address treasuryWalletAddy) external onlyOwner {
1181         require(treasuryWalletAddy != ZERO, "treasuryWallet address cannot be 0");
1182         _isExcludedFromFees[treasuryWallet] = false;
1183         _isExcludedMaxTransactionAmount[treasuryWallet] = false;
1184         treasuryWallet = payable(treasuryWalletAddy);
1185         _isExcludedFromFees[treasuryWallet] = true;
1186         _isExcludedMaxTransactionAmount[treasuryWallet] = true;
1187     }
1188 
1189     function setDevelopmentWallet(address developmentWalletAddy) external onlyOwner {
1190         require(developmentWalletAddy != ZERO, "developmentWallet address cannot be 0");
1191         _isExcludedFromFees[developmentWallet] = false;
1192         _isExcludedMaxTransactionAmount[developmentWallet] = false;
1193         developmentWallet = payable(developmentWalletAddy);
1194         _isExcludedFromFees[developmentWallet] = true;
1195         _isExcludedMaxTransactionAmount[developmentWallet] = true;
1196     }
1197 
1198     function setExcludedFromFees(address[] memory accounts, bool isEx) external onlyOwner {
1199         for (uint i = 0; i < accounts.length; i++) {
1200             _isExcludedFromFees[accounts[i]] = isEx;
1201         }
1202     }
1203     
1204     function setExcludeFromMaxTransaction(address[] memory accounts, bool isEx) external onlyOwner {
1205         for (uint i = 0; i < accounts.length; i++) {
1206             _isExcludedMaxTransactionAmount[accounts[i]] = isEx;
1207         }
1208     }
1209     
1210     function setBlacklisted(address[] memory accounts, bool exempt) external onlyOwner {
1211         for (uint i = 0; i < accounts.length; i++) {
1212             _isBlacklisted[accounts[i]] = exempt;
1213         }
1214     }
1215 
1216     function setBuyFee(uint256 newBuyLiquidityFee, uint256 newBuyTreasuryFee, uint256 newBuyDevelopmentFee) external onlyOwner {
1217         require(newBuyLiquidityFee + newBuyTreasuryFee + newBuyDevelopmentFee <= 200, "Must keep buy taxes below 20%");
1218         buyLiquidityFee = newBuyLiquidityFee;
1219         buyTreasuryFee = newBuyTreasuryFee;
1220         buyDevelopmentFee = newBuyDevelopmentFee;
1221     }
1222 
1223     function setSellFee(uint256 newSellLiquidityFee, uint256 newSellTreasuryFee, uint256 newSellDevelopmentFee) external onlyOwner {
1224         require(newSellLiquidityFee + newSellTreasuryFee + newSellDevelopmentFee <= 200, "Must keep sell taxes below 20%");
1225         sellLiquidityFee = newSellLiquidityFee;
1226         sellTreasuryFee = newSellTreasuryFee;
1227         sellDevelopmentFee = newSellDevelopmentFee;
1228     }
1229 
1230     function setBlocksToBlacklist(uint256 blocks) external onlyOwner {
1231         require(blocks < 10, "Must keep blacklist blocks below 10");
1232         _blocksToBlacklist = blocks;
1233     }
1234 
1235     function setCooldownBlocks(uint256 blocks) external onlyOwner {
1236         require(blocks < 10, "Must keep cooldown blocks below 10");
1237         _cooldownBlocks = blocks;
1238     }
1239 
1240     function removeAllFee() private {
1241         if(buyLiquidityFee == 0 && buyTreasuryFee == 0 && buyDevelopmentFee == 0 && sellLiquidityFee == 0 && sellTreasuryFee == 0 && sellDevelopmentFee == 0) return;
1242         
1243         _previousBuyLiquidityFee = buyLiquidityFee;
1244         _previousBuyTreasuryFee = buyTreasuryFee;
1245         _previousBuyDevelopmentFee = buyDevelopmentFee;
1246         _previousSellLiquidityFee = sellLiquidityFee;
1247         _previousSellTreasuryFee = sellTreasuryFee;
1248         _previousSellDevelopmentFee = sellDevelopmentFee;
1249         
1250         buyLiquidityFee = 0;
1251         buyTreasuryFee = 0;
1252         buyDevelopmentFee = 0;
1253         sellLiquidityFee = 0;
1254         sellTreasuryFee = 0;
1255         sellDevelopmentFee = 0;
1256     }
1257     
1258     function restoreAllFee() private {
1259         buyLiquidityFee = _previousBuyLiquidityFee;
1260         buyTreasuryFee = _previousBuyTreasuryFee;
1261         buyDevelopmentFee = _previousBuyDevelopmentFee;
1262         sellLiquidityFee = _previousSellLiquidityFee;
1263         sellTreasuryFee = _previousSellTreasuryFee;
1264         sellDevelopmentFee = _previousSellDevelopmentFee;
1265     }
1266         
1267     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool isSell) private {
1268         if(!takeFee) {
1269             removeAllFee();
1270         } else {
1271             amount = _takeFees(sender, amount, isSell);
1272         }
1273 
1274         _transferStandard(sender, recipient, amount);
1275         
1276         if(!takeFee) {
1277             restoreAllFee();
1278         }
1279     }
1280 
1281     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1282         _rOwned[sender] = _rOwned[sender].sub(tAmount);
1283         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
1284         emit Transfer(sender, recipient, tAmount);
1285     }
1286 
1287     function _takeFees(address sender, uint256 amount, bool isSell) private returns (uint256) {
1288         uint256 _totalFees;
1289         uint256 liqFee;
1290         uint256 trsryFee;
1291         uint256 devFee;
1292         if(tradingActiveBlock + _blocksToBlacklist >= block.number){
1293             _totalFees = 999;
1294             liqFee = 333;
1295             trsryFee = 333;
1296             devFee = 333;
1297         } else {
1298             _totalFees = _getTotalFees(isSell);
1299             if (isSell) {
1300                 liqFee = sellLiquidityFee;
1301                 trsryFee = sellTreasuryFee;
1302                 devFee = sellDevelopmentFee;
1303             } else {
1304                 liqFee = buyLiquidityFee;
1305                 trsryFee = buyTreasuryFee;
1306                 devFee = buyDevelopmentFee;
1307             }
1308         }
1309 
1310         uint256 fees = amount.mul(_totalFees).div(FEE_DIVISOR);
1311         _tokensForLiquidity += fees * liqFee / _totalFees;
1312         _tokensForTreasury += fees * trsryFee / _totalFees;
1313         _tokensForDevelopment += fees * devFee / _totalFees;
1314             
1315         if(fees > 0) {
1316             _transferStandard(sender, address(this), fees);
1317         }
1318             
1319         return amount -= fees;
1320     }
1321 
1322     function _getTotalFees(bool isSell) private view returns(uint256) {
1323         if (isSell) {
1324             return sellLiquidityFee + sellTreasuryFee + sellDevelopmentFee;
1325         }
1326         return buyLiquidityFee + buyTreasuryFee + buyDevelopmentFee;
1327     }
1328 
1329     receive() external payable {}
1330     fallback() external payable {}
1331     
1332     function unclog() external onlyOwner {
1333         uint256 contractBalance = balanceOf(address(this));
1334         swapTokensForTokens(contractBalance);
1335     }
1336     
1337     function distributeFees() external onlyOwner {
1338         _receiver.withdraw();
1339         uint256 contractUSDCBalance = IERC20(USDC).balanceOf(address(this));
1340         sendUSDCToFee(contractUSDCBalance);
1341     }
1342 
1343     function withdrawStuckETH() external onlyOwner {
1344         bool success;
1345         (success,) = address(msg.sender).call{value: address(this).balance}("");
1346     }
1347 
1348     function withdrawStuckTokens(address tkn) external onlyOwner {
1349         require(tkn != address(this), "Cannot withdraw this token");
1350         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1351         uint amount = IERC20(tkn).balanceOf(address(this));
1352         IERC20(tkn).transfer(msg.sender, amount);
1353     }
1354 
1355 }