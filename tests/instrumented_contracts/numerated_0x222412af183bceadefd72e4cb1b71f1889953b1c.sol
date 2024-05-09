1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 pragma solidity ^0.5.5;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following 
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Converts an `address` into `address payable`. Note that this is
39      * simply a type cast: the actual underlying value is not changed.
40      *
41      * _Available since v2.4.0._
42      */
43     function toPayable(address account) internal pure returns (address payable) {
44         return address(uint160(account));
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      *
63      * _Available since v2.4.0._
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         // solhint-disable-next-line avoid-call-value
69         (bool success, ) = recipient.call.value(amount)("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 }
73 
74 // File: @openzeppelin/contracts/math/SafeMath.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      *
130      * _Available since v2.4.0._
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
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
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         // Solidity only automatically asserts when dividing by 0
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      *
225      * _Available since v2.4.0._
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
234 
235 pragma solidity ^0.5.0;
236 
237 /**
238  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
239  * the optional functions; to access them see {ERC20Detailed}.
240  */
241 interface IERC20 {
242     /**
243      * @dev Returns the amount of tokens in existence.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns the amount of tokens owned by `account`.
249      */
250     function balanceOf(address account) external view returns (uint256);
251 
252     /**
253      * @dev Moves `amount` tokens from the caller's account to `recipient`.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transfer(address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Returns the remaining number of tokens that `spender` will be
263      * allowed to spend on behalf of `owner` through {transferFrom}. This is
264      * zero by default.
265      *
266      * This value changes when {approve} or {transferFrom} are called.
267      */
268     function allowance(address owner, address spender) external view returns (uint256);
269 
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * IMPORTANT: Beware that changing an allowance with this method brings the risk
276      * that someone may use both the old and the new allowance by unfortunate
277      * transaction ordering. One possible solution to mitigate this race
278      * condition is to first reduce the spender's allowance to 0 and set the
279      * desired value afterwards:
280      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address spender, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Moves `amount` tokens from `sender` to `recipient` using the
288      * allowance mechanism. `amount` is then deducted from the caller's
289      * allowance.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Emitted when `value` tokens are moved from one account (`from`) to
299      * another (`to`).
300      *
301      * Note that `value` may be zero.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 value);
304 
305     /**
306      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
307      * a call to {approve}. `value` is the new allowance.
308      */
309     event Approval(address indexed owner, address indexed spender, uint256 value);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
313 
314 pragma solidity ^0.5.0;
315 
316 
317 
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure (when the token
322  * contract returns false). Tokens that return no value (and instead revert or
323  * throw on failure) are also supported, non-reverting calls are assumed to be
324  * successful.
325  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
326  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
327  */
328 library SafeERC20 {
329     using SafeMath for uint256;
330     using Address for address;
331 
332     function safeTransfer(IERC20 token, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     function safeApprove(IERC20 token, address spender, uint256 value) internal {
341         // safeApprove should only be called when setting an initial allowance,
342         // or when resetting it to zero. To increase and decrease it, use
343         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
344         // solhint-disable-next-line max-line-length
345         require((value == 0) || (token.allowance(address(this), spender) == 0),
346             "SafeERC20: approve from non-zero to non-zero allowance"
347         );
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
349     }
350 
351     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).add(value);
353         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
357         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
358         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     /**
362      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
363      * on the return value: the return value is optional (but if data is returned, it must not be false).
364      * @param token The token targeted by the call.
365      * @param data The call data (encoded using abi.encode or one of its variants).
366      */
367     function callOptionalReturn(IERC20 token, bytes memory data) private {
368         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
369         // we're implementing it ourselves.
370 
371         // A Solidity high level call has three parts:
372         //  1. The target address is checked to verify it contains contract code
373         //  2. The call itself is made, and success asserted
374         //  3. The return value is decoded, which in turn checks the size of the returned data.
375         // solhint-disable-next-line max-line-length
376         require(address(token).isContract(), "SafeERC20: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = address(token).call(data);
380         require(success, "SafeERC20: low-level call failed");
381 
382         if (returndata.length > 0) { // Return data is optional
383             // solhint-disable-next-line max-line-length
384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
385         }
386     }
387 }
388 
389 // File: contracts/hardworkInterface/IController.sol
390 
391 pragma solidity 0.5.16;
392 
393 interface IController {
394     // [Grey list]
395     // An EOA can safely interact with the system no matter what.
396     // If you're using Metamask, you're using an EOA.
397     // Only smart contracts may be affected by this grey list.
398     //
399     // This contract will not be able to ban any EOA from the system
400     // even if an EOA is being added to the greyList, he/she will still be able
401     // to interact with the whole system as if nothing happened.
402     // Only smart contracts will be affected by being added to the greyList.
403     // This grey list is only used in Vault.sol, see the code there for reference
404     function greyList(address _target) external returns(bool);
405 
406     function addVaultAndStrategy(address _vault, address _strategy) external;
407     function doHardWork(address _vault) external;
408     function hasVault(address _vault) external returns(bool);
409 
410     function salvage(address _token, uint256 amount) external;
411     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
412 
413     function notifyFee(address _underlying, uint256 fee) external;
414     function profitSharingNumerator() external view returns (uint256);
415     function profitSharingDenominator() external view returns (uint256);
416 }
417 
418 // File: contracts/hardworkInterface/IStrategy.sol
419 
420 pragma solidity 0.5.16;
421 
422 
423 interface IStrategy {
424     
425     function unsalvagableTokens(address tokens) external view returns (bool);
426     
427     function governance() external view returns (address);
428     function controller() external view returns (address);
429     function underlying() external view returns (address);
430     function vault() external view returns (address);
431 
432     function withdrawAllToVault() external;
433     function withdrawToVault(uint256 amount) external;
434 
435     function investedUnderlyingBalance() external view returns (uint256); // itsNotMuch()
436 
437     // should only be called by controller
438     function salvage(address recipient, address token, uint256 amount) external;
439 
440     function doHardWork() external;
441     function depositArbCheck() external view returns(bool);
442 }
443 
444 // File: contracts/hardworkInterface/IVault.sol
445 
446 pragma solidity 0.5.16;
447 
448 
449 interface IVault {
450     // the IERC20 part is the share
451 
452     function underlyingBalanceInVault() external view returns (uint256);
453     function underlyingBalanceWithInvestment() external view returns (uint256);
454 
455     function governance() external view returns (address);
456     function controller() external view returns (address);
457     function underlying() external view returns (address);
458     function strategy() external view returns (address);
459 
460     function setStrategy(address _strategy) external;
461     function setVaultFractionToInvest(uint256 numerator, uint256 denominator) external;
462 
463     function deposit(uint256 amountWei) external;
464     function depositFor(uint256 amountWei, address holder) external;
465 
466     function withdrawAll() external;
467     function withdraw(uint256 numberOfShares) external;
468     function getPricePerFullShare() external view returns (uint256);
469 
470     function underlyingBalanceWithInvestmentForHolder(address holder) view external returns (uint256);
471 
472     // hard work should be callable only by the controller (by the hard worker) or by governance
473     function doHardWork() external;
474     function rebalance() external;
475 }
476 
477 // File: contracts/Storage.sol
478 
479 pragma solidity 0.5.16;
480 
481 contract Storage {
482 
483   address public governance;
484   address public controller;
485 
486   constructor() public {
487     governance = msg.sender;
488   }
489 
490   modifier onlyGovernance() {
491     require(isGovernance(msg.sender), "Not governance");
492     _;
493   }
494 
495   function setGovernance(address _governance) public onlyGovernance {
496     require(_governance != address(0), "new governance shouldn't be empty");
497     governance = _governance;
498   }
499 
500   function setController(address _controller) public onlyGovernance {
501     require(_controller != address(0), "new controller shouldn't be empty");
502     controller = _controller;
503   }
504 
505   function isGovernance(address account) public view returns (bool) {
506     return account == governance;
507   }
508 
509   function isController(address account) public view returns (bool) {
510     return account == controller;
511   }
512 }
513 
514 // File: contracts/Governable.sol
515 
516 pragma solidity 0.5.16;
517 
518 
519 contract Governable {
520 
521   Storage public store;
522 
523   constructor(address _store) public {
524     require(_store != address(0), "new storage shouldn't be empty");
525     store = Storage(_store);
526   }
527 
528   modifier onlyGovernance() {
529     require(store.isGovernance(msg.sender), "Not governance");
530     _;
531   }
532 
533   function setStorage(address _store) public onlyGovernance {
534     require(_store != address(0), "new storage shouldn't be empty");
535     store = Storage(_store);
536   }
537 
538   function governance() public view returns (address) {
539     return store.governance();
540   }
541 }
542 
543 // File: contracts/hardworkInterface/IRewardPool.sol
544 
545 pragma solidity 0.5.16;
546 
547 
548 // Unifying the interface with the Synthetix Reward Pool 
549 interface IRewardPool {
550   function rewardToken() external view returns (address);
551   function lpToken() external view returns (address);
552   function duration() external view returns (uint256);
553 
554   function periodFinish() external view returns (uint256);
555   function rewardRate() external view returns (uint256);
556   function rewardPerTokenStored() external view returns (uint256);
557 
558   function stake(uint256 amountWei) external;
559 
560   // `balanceOf` would give the amount staked. 
561   // As this is 1 to 1, this is also the holder's share
562   function balanceOf(address holder) external view returns (uint256);
563   // total shares & total lpTokens staked
564   function totalSupply() external view returns(uint256);
565 
566   function withdraw(uint256 amountWei) external;
567   function exit() external;
568 
569   // get claimed rewards
570   function earned(address holder) external view returns (uint256);
571 
572   // claim rewards
573   function getReward() external;
574 
575   // notify
576   function notifyRewardAmount(uint256 _amount) external;
577 }
578 
579 // File: contracts/uniswap/interfaces/IUniswapV2Router01.sol
580 
581 pragma solidity >=0.5.0;
582 
583 interface IUniswapV2Router01 {
584     function factory() external pure returns (address);
585     function WETH() external pure returns (address);
586 
587     function addLiquidity(
588         address tokenA,
589         address tokenB,
590         uint amountADesired,
591         uint amountBDesired,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountA, uint amountB, uint liquidity);
597     function addLiquidityETH(
598         address token,
599         uint amountTokenDesired,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline
604     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
605     function removeLiquidity(
606         address tokenA,
607         address tokenB,
608         uint liquidity,
609         uint amountAMin,
610         uint amountBMin,
611         address to,
612         uint deadline
613     ) external returns (uint amountA, uint amountB);
614     function removeLiquidityETH(
615         address token,
616         uint liquidity,
617         uint amountTokenMin,
618         uint amountETHMin,
619         address to,
620         uint deadline
621     ) external returns (uint amountToken, uint amountETH);
622     function removeLiquidityWithPermit(
623         address tokenA,
624         address tokenB,
625         uint liquidity,
626         uint amountAMin,
627         uint amountBMin,
628         address to,
629         uint deadline,
630         bool approveMax, uint8 v, bytes32 r, bytes32 s
631     ) external returns (uint amountA, uint amountB);
632     function removeLiquidityETHWithPermit(
633         address token,
634         uint liquidity,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline,
639         bool approveMax, uint8 v, bytes32 r, bytes32 s
640     ) external returns (uint amountToken, uint amountETH);
641     function swapExactTokensForTokens(
642         uint amountIn,
643         uint amountOutMin,
644         address[] calldata path,
645         address to,
646         uint deadline
647     ) external returns (uint[] memory amounts);
648     function swapTokensForExactTokens(
649         uint amountOut,
650         uint amountInMax,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external returns (uint[] memory amounts);
655     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
656         external
657         payable
658         returns (uint[] memory amounts);
659     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
660         external
661         returns (uint[] memory amounts);
662     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
663         external
664         returns (uint[] memory amounts);
665     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
666         external
667         payable
668         returns (uint[] memory amounts);
669 
670     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
671     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
672     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
673     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
674     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
675 }
676 
677 // File: contracts/uniswap/interfaces/IUniswapV2Router02.sol
678 
679 pragma solidity >=0.5.0;
680 
681 
682 interface IUniswapV2Router02 {
683     function factory() external pure returns (address);
684     function WETH() external pure returns (address);
685 
686     function addLiquidity(
687         address tokenA,
688         address tokenB,
689         uint amountADesired,
690         uint amountBDesired,
691         uint amountAMin,
692         uint amountBMin,
693         address to,
694         uint deadline
695     ) external returns (uint amountA, uint amountB, uint liquidity);
696     function addLiquidityETH(
697         address token,
698         uint amountTokenDesired,
699         uint amountTokenMin,
700         uint amountETHMin,
701         address to,
702         uint deadline
703     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
704     function removeLiquidity(
705         address tokenA,
706         address tokenB,
707         uint liquidity,
708         uint amountAMin,
709         uint amountBMin,
710         address to,
711         uint deadline
712     ) external returns (uint amountA, uint amountB);
713     function removeLiquidityETH(
714         address token,
715         uint liquidity,
716         uint amountTokenMin,
717         uint amountETHMin,
718         address to,
719         uint deadline
720     ) external returns (uint amountToken, uint amountETH);
721     function removeLiquidityWithPermit(
722         address tokenA,
723         address tokenB,
724         uint liquidity,
725         uint amountAMin,
726         uint amountBMin,
727         address to,
728         uint deadline,
729         bool approveMax, uint8 v, bytes32 r, bytes32 s
730     ) external returns (uint amountA, uint amountB);
731     function removeLiquidityETHWithPermit(
732         address token,
733         uint liquidity,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline,
738         bool approveMax, uint8 v, bytes32 r, bytes32 s
739     ) external returns (uint amountToken, uint amountETH);
740     function swapExactTokensForTokens(
741         uint amountIn,
742         uint amountOutMin,
743         address[] calldata path,
744         address to,
745         uint deadline
746     ) external returns (uint[] memory amounts);
747     function swapTokensForExactTokens(
748         uint amountOut,
749         uint amountInMax,
750         address[] calldata path,
751         address to,
752         uint deadline
753     ) external returns (uint[] memory amounts);
754     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
755         external
756         payable
757         returns (uint[] memory amounts);
758     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
759         external
760         returns (uint[] memory amounts);
761     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
762         external
763         returns (uint[] memory amounts);
764     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
765         external
766         payable
767         returns (uint[] memory amounts);
768 
769     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
770     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
771     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
772     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
773     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
774 
775     function removeLiquidityETHSupportingFeeOnTransferTokens(
776         address token,
777         uint liquidity,
778         uint amountTokenMin,
779         uint amountETHMin,
780         address to,
781         uint deadline
782     ) external returns (uint amountETH);
783     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
784         address token,
785         uint liquidity,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline,
790         bool approveMax, uint8 v, bytes32 r, bytes32 s
791     ) external returns (uint amountETH);
792 
793     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
794         uint amountIn,
795         uint amountOutMin,
796         address[] calldata path,
797         address to,
798         uint deadline
799     ) external;
800     function swapExactETHForTokensSupportingFeeOnTransferTokens(
801         uint amountOutMin,
802         address[] calldata path,
803         address to,
804         uint deadline
805     ) external payable;
806     function swapExactTokensForETHSupportingFeeOnTransferTokens(
807         uint amountIn,
808         uint amountOutMin,
809         address[] calldata path,
810         address to,
811         uint deadline
812     ) external;
813 }
814 
815 // File: contracts/FeeRewardForwarder.sol
816 
817 pragma solidity 0.5.16;
818 
819 
820 
821 
822 
823 
824 contract FeeRewardForwarder is Governable {
825   using SafeERC20 for IERC20;
826 
827   address constant public ycrv = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
828   address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
829   address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
830   address constant public yfi = address(0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e);
831   address constant public link = address(0x514910771AF9Ca656af840dff83E8264EcF986CA);
832 
833   mapping (address => mapping (address => address[])) public uniswapRoutes;
834 
835   // the targeted reward token to convert everything to
836   address public targetToken;
837   address public profitSharingPool;
838 
839   address public uniswapRouterV2;
840 
841   event TokenPoolSet(address token, address pool);
842 
843   constructor(address _storage, address _uniswapRouterV2) public Governable(_storage) {
844     require(_uniswapRouterV2 != address(0), "uniswapRouterV2 not defined");
845     uniswapRouterV2 = _uniswapRouterV2;
846     // these are for mainnet, but they won't impact Ropsten
847     uniswapRoutes[ycrv][dai] = [ycrv, weth, dai];
848     uniswapRoutes[link][dai] = [link, weth, dai];
849     uniswapRoutes[weth][dai] = [weth, dai];
850     uniswapRoutes[yfi][dai] = [yfi, weth, dai];
851   }
852 
853   /*
854   *   Set the pool that will receive the reward token
855   *   based on the address of the reward Token
856   */
857   function setTokenPool(address _pool) public onlyGovernance {
858     targetToken = IRewardPool(_pool).rewardToken();
859     profitSharingPool = _pool;
860     emit TokenPoolSet(targetToken, _pool);
861   }
862 
863   /**
864   * Sets the path for swapping tokens to the to address
865   * The to address is not validated to match the targetToken,
866   * so that we could first update the paths, and then,
867   * set the new target
868   */
869   function setConversionPath(address from, address to, address[] memory _uniswapRoute)
870   public onlyGovernance {
871     require(from == _uniswapRoute[0],
872       "The first token of the Uniswap route must be the from token");
873     require(to == _uniswapRoute[_uniswapRoute.length - 1],
874       "The last token of the Uniswap route must be the to token");
875     uniswapRoutes[from][to] = _uniswapRoute;
876   }
877 
878   // Transfers the funds from the msg.sender to the pool
879   // under normal circumstances, msg.sender is the strategy
880   function poolNotifyFixedTarget(address _token, uint256 _amount) external {
881     if (targetToken == address(0)) {
882       return; // a No-op if target pool is not set yet
883     }
884     if (_token == targetToken) {
885       // this is already the right token
886       IERC20(_token).safeTransferFrom(msg.sender, profitSharingPool, _amount);
887       IRewardPool(profitSharingPool).notifyRewardAmount(_amount);
888     } else {
889       // we need to convert
890       if (uniswapRoutes[_token][targetToken].length > 1) {
891         IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
892         uint256 balanceToSwap = IERC20(_token).balanceOf(address(this));
893 
894         IERC20(_token).safeApprove(uniswapRouterV2, 0);
895         IERC20(_token).safeApprove(uniswapRouterV2, balanceToSwap);
896 
897         IUniswapV2Router02(uniswapRouterV2).swapExactTokensForTokens(
898           balanceToSwap,
899           1, // we will accept any amount
900           uniswapRoutes[_token][targetToken],
901           address(this),
902           block.timestamp
903         );
904         // now we can send this token forward
905         uint256 convertedRewardAmount = IERC20(targetToken).balanceOf(address(this));
906         IERC20(targetToken).safeTransfer(profitSharingPool, convertedRewardAmount);
907         IRewardPool(profitSharingPool).notifyRewardAmount(convertedRewardAmount);
908       }
909       // else the route does not exist for this token
910       // do not take any fees - leave them in the controller
911     }
912   }
913 }
914 
915 // File: contracts/Controllable.sol
916 
917 pragma solidity 0.5.16;
918 
919 
920 contract Controllable is Governable {
921 
922   constructor(address _storage) Governable(_storage) public {
923   }
924 
925   modifier onlyController() {
926     require(store.isController(msg.sender), "Not a controller");
927     _;
928   }
929 
930   modifier onlyControllerOrGovernance(){
931     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
932       "The caller must be controller or governance");
933     _;
934   }
935 
936   function controller() public view returns (address) {
937     return store.controller();
938   }
939 }
940 
941 // File: contracts/HardRewards.sol
942 
943 pragma solidity 0.5.16;
944 
945 
946 
947 
948 
949 contract HardRewards is Controllable {
950 
951   using SafeMath for uint256;
952   using SafeERC20 for IERC20;
953 
954   event Rewarded(address indexed recipient, address indexed vault, uint256 amount);
955 
956   // token used for rewards
957   IERC20 public token;
958 
959   // how many tokens per each block
960   uint256 public blockReward;
961 
962   // vault to the last rewarded block
963   mapping(address => uint256) public lastReward;
964 
965   constructor(address _storage, address _token)
966   Controllable(_storage) public {
967     token = IERC20(_token);
968   }
969 
970   /**
971   * Called from the controller after hard work has been done. Defensively avoid
972   * reverting the transaction in this function.
973   */
974   function rewardMe(address recipient, address vault) external onlyController {
975     if (address(token) == address(0) || blockReward == 0) {
976       // no rewards now
977       emit Rewarded(recipient, vault, 0);
978       return;
979     }
980 
981     if (lastReward[vault] == 0) {
982       // vault does not exist
983       emit Rewarded(recipient, vault, 0);
984       return;
985     }
986 
987     uint256 span = block.number.sub(lastReward[vault]);
988     uint256 reward = blockReward.mul(span);
989 
990     if (reward > 0) {
991       uint256 balance = token.balanceOf(address(this));
992       uint256 realReward = balance >= reward ? reward : balance;
993       if (realReward > 0) {
994         token.safeTransfer(recipient, realReward);
995       }
996       emit Rewarded(recipient, vault, realReward);
997     } else {
998       emit Rewarded(recipient, vault, 0);
999     }
1000     lastReward[vault] = block.number;
1001   }
1002 
1003   function addVault(address _vault) external onlyGovernance {
1004     lastReward[_vault] = block.number;
1005   }
1006 
1007   function removeVault(address _vault) external onlyGovernance {
1008     delete (lastReward[_vault]);
1009   }
1010 
1011   /**
1012   * Transfers tokens for the new rewards cycle. Allows for changing the rewards setting
1013   * at the same time.
1014   */
1015   function load(address _token, uint256 _rate, uint256 _amount) external onlyGovernance {
1016     token = IERC20(_token);
1017     blockReward = _rate;
1018     if (address(token) != address(0) && _amount > 0) {
1019       token.safeTransferFrom(msg.sender, address(this), _amount);
1020     }
1021   }
1022 }
1023 
1024 // File: contracts/Controller.sol
1025 
1026 pragma solidity 0.5.16;
1027 
1028 
1029 
1030 
1031 
1032 
1033 
1034 
1035 
1036 
1037 
1038 contract Controller is IController, Governable {
1039 
1040     using SafeERC20 for IERC20;
1041     using Address for address;
1042     using SafeMath for uint256;
1043 
1044     // external parties
1045     address public feeRewardForwarder;
1046 
1047     // [Grey list]
1048     // An EOA can safely interact with the system no matter what.
1049     // If you're using Metamask, you're using an EOA.
1050     // Only smart contracts may be affected by this grey list.
1051     //
1052     // This contract will not be able to ban any EOA from the system
1053     // even if an EOA is being added to the greyList, he/she will still be able
1054     // to interact with the whole system as if nothing happened.
1055     // Only smart contracts will be affected by being added to the greyList.
1056     mapping (address => bool) public greyList;
1057 
1058     // All vaults that we have
1059     mapping (address => bool) public vaults;
1060 
1061     // Rewards for hard work. Nullable.
1062     HardRewards public hardRewards;
1063 
1064     uint256 public constant profitSharingNumerator = 5;
1065     uint256 public constant profitSharingDenominator = 100;
1066 
1067     event SharePriceChangeLog(
1068       address indexed vault,
1069       address indexed strategy,
1070       uint256 oldSharePrice,
1071       uint256 newSharePrice,
1072       uint256 timestamp
1073     );
1074 
1075     modifier validVault(address _vault){
1076         require(vaults[_vault], "vault does not exist");
1077         _;
1078     }
1079 
1080     mapping (address => bool) public hardWorkers;
1081 
1082     modifier onlyHardWorkerOrGovernance() {
1083         require(hardWorkers[msg.sender] || (msg.sender == governance()),
1084         "only hard worker can call this");
1085         _;
1086     }
1087 
1088     constructor(address _storage, address _feeRewardForwarder)
1089     Governable(_storage) public {
1090         require(_feeRewardForwarder != address(0), "feeRewardForwarder should not be empty");
1091         feeRewardForwarder = _feeRewardForwarder;
1092     }
1093 
1094     function addHardWorker(address _worker) public onlyGovernance {
1095       require(_worker != address(0), "_worker must be defined");
1096       hardWorkers[_worker] = true;
1097     }
1098 
1099     function removeHardWorker(address _worker) public onlyGovernance {
1100       require(_worker != address(0), "_worker must be defined");
1101       hardWorkers[_worker] = false;
1102     }
1103 
1104     function hasVault(address _vault) external returns (bool) {
1105       return vaults[_vault];
1106     }
1107 
1108     // Only smart contracts will be affected by the greyList.
1109     function addToGreyList(address _target) public onlyGovernance {
1110         greyList[_target] = true;
1111     }
1112 
1113     function removeFromGreyList(address _target) public onlyGovernance {
1114         greyList[_target] = false;
1115     }
1116 
1117     function setFeeRewardForwarder(address _feeRewardForwarder) public onlyGovernance {
1118       require(_feeRewardForwarder != address(0), "new reward forwarder should not be empty");
1119       feeRewardForwarder = _feeRewardForwarder;
1120     }
1121 
1122     function addVaultAndStrategy(address _vault, address _strategy) external onlyGovernance {
1123         require(_vault != address(0), "new vault shouldn't be empty");
1124         require(!vaults[_vault], "vault already exists");
1125         require(_strategy != address(0), "new strategy shouldn't be empty");
1126 
1127         vaults[_vault] = true;
1128         // adding happens while setting
1129         IVault(_vault).setStrategy(_strategy);
1130     }
1131 
1132     function doHardWork(address _vault) external onlyHardWorkerOrGovernance validVault(_vault) {
1133         uint256 oldSharePrice = IVault(_vault).getPricePerFullShare();
1134         IVault(_vault).doHardWork();
1135         if (address(hardRewards) != address(0)) {
1136             // rewards are an option now
1137             hardRewards.rewardMe(msg.sender, _vault);
1138         }
1139         emit SharePriceChangeLog(
1140           _vault,
1141           IVault(_vault).strategy(),
1142           oldSharePrice,
1143           IVault(_vault).getPricePerFullShare(),
1144           block.timestamp
1145         );
1146     }
1147 
1148     function rebalance(address _vault) external onlyHardWorkerOrGovernance validVault(_vault) {
1149         IVault(_vault).rebalance();
1150     }
1151 
1152     function setHardRewards(address _hardRewards) external onlyGovernance {
1153         hardRewards = HardRewards(_hardRewards);
1154     }
1155 
1156     // transfers token in the controller contract to the governance
1157     function salvage(address _token, uint256 _amount) external onlyGovernance {
1158         IERC20(_token).safeTransfer(governance(), _amount);
1159     }
1160 
1161     function salvageStrategy(address _strategy, address _token, uint256 _amount) external onlyGovernance {
1162         // the strategy is responsible for maintaining the list of
1163         // salvagable tokens, to make sure that governance cannot come
1164         // in and take away the coins
1165         IStrategy(_strategy).salvage(governance(), _token, _amount);
1166     }
1167 
1168     function notifyFee(address underlying, uint256 fee) external {
1169       if (fee > 0) {
1170         IERC20(underlying).safeTransferFrom(msg.sender, address(this), fee);
1171         IERC20(underlying).safeApprove(feeRewardForwarder, 0);
1172         IERC20(underlying).safeApprove(feeRewardForwarder, fee);
1173         FeeRewardForwarder(feeRewardForwarder).poolNotifyFixedTarget(underlying, fee);
1174       }
1175     }
1176 }