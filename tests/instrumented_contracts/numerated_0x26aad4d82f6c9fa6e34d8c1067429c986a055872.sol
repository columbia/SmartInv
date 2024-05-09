1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 /**
4 
5 Author: CoFiX Core, https://cofix.io
6 Commit hash: v0.9.5-1-g7141c43
7 Repository: https://github.com/Computable-Finance/CoFiX
8 Issues: https://github.com/Computable-Finance/CoFiX/issues
9 
10 */
11 
12 pragma solidity 0.6.12;
13 
14 
15 // 
16 interface ICoFiXFactory {
17     // All pairs: {ETH <-> ERC20 Token}
18     event PairCreated(address indexed token, address pair, uint256);
19     event NewGovernance(address _new);
20     event NewController(address _new);
21     event NewFeeReceiver(address _new);
22     event NewFeeVaultForLP(address token, address feeVault);
23     event NewVaultForLP(address _new);
24     event NewVaultForTrader(address _new);
25     event NewVaultForCNode(address _new);
26 
27     /// @dev Create a new token pair for trading
28     /// @param  token the address of token to trade
29     /// @return pair the address of new token pair
30     function createPair(
31         address token
32         )
33         external
34         returns (address pair);
35 
36     function getPair(address token) external view returns (address pair);
37     function allPairs(uint256) external view returns (address pair);
38     function allPairsLength() external view returns (uint256);
39 
40     function getTradeMiningStatus(address token) external view returns (bool status);
41     function setTradeMiningStatus(address token, bool status) external;
42     function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
43     function setFeeVaultForLP(address token, address feeVault) external;
44 
45     function setGovernance(address _new) external;
46     function setController(address _new) external;
47     function setFeeReceiver(address _new) external;
48     function setVaultForLP(address _new) external;
49     function setVaultForTrader(address _new) external;
50     function setVaultForCNode(address _new) external;
51     function getController() external view returns (address controller);
52     function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
53     function getVaultForLP() external view returns (address vaultForLP);
54     function getVaultForTrader() external view returns (address vaultForTrader);
55     function getVaultForCNode() external view returns (address vaultForCNode);
56 }
57 
58 // 
59 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
60 library TransferHelper {
61     function safeApprove(address token, address to, uint value) internal {
62         // bytes4(keccak256(bytes('approve(address,uint256)')));
63         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
64         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
65     }
66 
67     function safeTransfer(address token, address to, uint value) internal {
68         // bytes4(keccak256(bytes('transfer(address,uint256)')));
69         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
70         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
71     }
72 
73     function safeTransferFrom(address token, address from, address to, uint value) internal {
74         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
75         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
76         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
77     }
78 
79     function safeTransferETH(address to, uint value) internal {
80         (bool success,) = to.call{value:value}(new bytes(0));
81         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
82     }
83 }
84 
85 // 
86 interface ICoFiXRouter {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89 
90     // All pairs: {ETH <-> ERC20 Token}
91 
92     /// @dev Maker add liquidity to pool, get pool token (mint XToken to maker) (notice: msg.value = amountETH + oracle fee)
93     /// @param  token The address of ERC20 Token
94     /// @param  amountETH The amount of ETH added to pool
95     /// @param  amountToken The amount of Token added to pool
96     /// @param  liquidityMin The minimum liquidity maker wanted
97     /// @param  to The target address receiving the liquidity pool (XToken)
98     /// @param  deadline The dealine of this request
99     /// @return liquidity The real liquidity or XToken minted from pool
100     function addLiquidity(
101         address token,
102         uint amountETH,
103         uint amountToken,
104         uint liquidityMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint liquidity);
108 
109     /// @dev Maker add liquidity to pool, get pool token (mint XToken) and stake automatically (notice: msg.value = amountETH + oracle fee)
110     /// @param  token The address of ERC20 Token
111     /// @param  amountETH The amount of ETH added to pool
112     /// @param  amountToken The amount of Token added to pool
113     /// @param  liquidityMin The minimum liquidity maker wanted
114     /// @param  to The target address receiving the liquidity pool (XToken)
115     /// @param  deadline The dealine of this request
116     /// @return liquidity The real liquidity or XToken minted from pool
117     function addLiquidityAndStake(
118         address token,
119         uint amountETH,
120         uint amountToken,
121         uint liquidityMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint liquidity);
125 
126     /// @dev Maker remove liquidity from pool to get ERC20 Token back (maker burn XToken) (notice: msg.value = oracle fee)
127     /// @param  token The address of ERC20 Token
128     /// @param  liquidity The amount of liquidity (XToken) sent to pool, or the liquidity to remove
129     /// @param  amountTokenMin The minimum amount of Token wanted to get from pool
130     /// @param  to The target address receiving the Token
131     /// @param  deadline The dealine of this request
132     /// @return amountToken The real amount of Token transferred from the pool
133     function removeLiquidityGetToken(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken);
140 
141     /// @dev Maker remove liquidity from pool to get ETH back (maker burn XToken) (notice: msg.value = oracle fee)
142     /// @param  token The address of ERC20 Token
143     /// @param  liquidity The amount of liquidity (XToken) sent to pool, or the liquidity to remove
144     /// @param  amountETHMin The minimum amount of ETH wanted to get from pool
145     /// @param  to The target address receiving the ETH
146     /// @param  deadline The dealine of this request
147     /// @return amountETH The real amount of ETH transferred from the pool
148     function removeLiquidityGetETH(
149         address token,
150         uint liquidity,
151         uint amountETHMin,
152         address to,
153         uint deadline
154     ) external payable returns (uint amountETH);
155 
156     /// @dev Trader swap exact amount of ETH for ERC20 Tokens (notice: msg.value = amountIn + oracle fee)
157     /// @param  token The address of ERC20 Token
158     /// @param  amountIn The exact amount of ETH a trader want to swap into pool
159     /// @param  amountOutMin The minimum amount of Token a trader want to swap out of pool
160     /// @param  to The target address receiving the Token
161     /// @param  rewardTo The target address receiving the CoFi Token as rewards
162     /// @param  deadline The dealine of this request
163     /// @return _amountIn The real amount of ETH transferred into pool
164     /// @return _amountOut The real amount of Token transferred out of pool
165     function swapExactETHForTokens(
166         address token,
167         uint amountIn,
168         uint amountOutMin,
169         address to,
170         address rewardTo,
171         uint deadline
172     ) external payable returns (uint _amountIn, uint _amountOut);
173 
174     /// @dev Trader swap exact amount of ERC20 Tokens for ETH (notice: msg.value = oracle fee)
175     /// @param  token The address of ERC20 Token
176     /// @param  amountIn The exact amount of Token a trader want to swap into pool
177     /// @param  amountOutMin The mininum amount of ETH a trader want to swap out of pool
178     /// @param  to The target address receiving the ETH
179     /// @param  rewardTo The target address receiving the CoFi Token as rewards
180     /// @param  deadline The dealine of this request
181     /// @return _amountIn The real amount of Token transferred into pool
182     /// @return _amountOut The real amount of ETH transferred out of pool
183     function swapExactTokensForETH(
184         address token,
185         uint amountIn,
186         uint amountOutMin,
187         address to,
188         address rewardTo,
189         uint deadline
190     ) external payable returns (uint _amountIn, uint _amountOut);
191 
192     /// @dev Trader swap exact amount of ERC20 Tokens for other ERC20 Tokens (notice: msg.value = oracle fee)
193     /// @param  tokenIn The address of ERC20 Token a trader want to swap into pool
194     /// @param  tokenOut The address of ERC20 Token a trader want to swap out of pool
195     /// @param  amountIn The exact amount of Token a trader want to swap into pool
196     /// @param  amountOutMin The mininum amount of ETH a trader want to swap out of pool
197     /// @param  to The target address receiving the Token
198     /// @param  rewardTo The target address receiving the CoFi Token as rewards
199     /// @param  deadline The dealine of this request
200     /// @return _amountIn The real amount of Token transferred into pool
201     /// @return _amountOut The real amount of Token transferred out of pool
202     function swapExactTokensForTokens(
203         address tokenIn,
204         address tokenOut,
205         uint amountIn,
206         uint amountOutMin,
207         address to,
208         address rewardTo,
209         uint deadline
210     ) external payable returns (uint _amountIn, uint _amountOut);
211 
212     /// @dev Trader swap ETH for exact amount of ERC20 Tokens (notice: msg.value = amountInMax + oracle fee)
213     /// @param  token The address of ERC20 Token
214     /// @param  amountInMax The max amount of ETH a trader want to swap into pool
215     /// @param  amountOutExact The exact amount of Token a trader want to swap out of pool
216     /// @param  to The target address receiving the Token
217     /// @param  rewardTo The target address receiving the CoFi Token as rewards
218     /// @param  deadline The dealine of this request
219     /// @return _amountIn The real amount of ETH transferred into pool
220     /// @return _amountOut The real amount of Token transferred out of pool
221     function swapETHForExactTokens(
222         address token,
223         uint amountInMax,
224         uint amountOutExact,
225         address to,
226         address rewardTo,
227         uint deadline
228     ) external payable returns (uint _amountIn, uint _amountOut);
229 
230     /// @dev Trader swap ERC20 Tokens for exact amount of ETH (notice: msg.value = oracle fee)
231     /// @param  token The address of ERC20 Token
232     /// @param  amountInMax The max amount of Token a trader want to swap into pool
233     /// @param  amountOutExact The exact amount of ETH a trader want to swap out of pool
234     /// @param  to The target address receiving the ETH
235     /// @param  rewardTo The target address receiving the CoFi Token as rewards
236     /// @param  deadline The dealine of this request
237     /// @return _amountIn The real amount of Token transferred into pool
238     /// @return _amountOut The real amount of ETH transferred out of pool
239     function swapTokensForExactETH(
240         address token,
241         uint amountInMax,
242         uint amountOutExact,
243         address to,
244         address rewardTo,
245         uint deadline
246     ) external payable returns (uint _amountIn, uint _amountOut);
247 }
248 
249 // 
250 /**
251  * @dev Wrappers over Solidity's arithmetic operations with added overflow
252  * checks.
253  *
254  * Arithmetic operations in Solidity wrap on overflow. This can easily result
255  * in bugs, because programmers usually assume that an overflow raises an
256  * error, which is the standard behavior in high level programming languages.
257  * `SafeMath` restores this intuition by reverting the transaction when an
258  * operation overflows.
259  *
260  * Using this library instead of the unchecked operations eliminates an entire
261  * class of bugs, so it's recommended to use it always.
262  */
263 library SafeMath {
264     /**
265      * @dev Returns the addition of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `+` operator.
269      *
270      * Requirements:
271      *
272      * - Addition cannot overflow.
273      */
274     function add(uint256 a, uint256 b) internal pure returns (uint256) {
275         uint256 c = a + b;
276         require(c >= a, "SafeMath: addition overflow");
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the subtraction of two unsigned integers, reverting on
283      * overflow (when the result is negative).
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      *
289      * - Subtraction cannot overflow.
290      */
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         return sub(a, b, "SafeMath: subtraction overflow");
293     }
294 
295     /**
296      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
297      * overflow (when the result is negative).
298      *
299      * Counterpart to Solidity's `-` operator.
300      *
301      * Requirements:
302      *
303      * - Subtraction cannot overflow.
304      */
305     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b <= a, errorMessage);
307         uint256 c = a - b;
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the multiplication of two unsigned integers, reverting on
314      * overflow.
315      *
316      * Counterpart to Solidity's `*` operator.
317      *
318      * Requirements:
319      *
320      * - Multiplication cannot overflow.
321      */
322     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
323         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
324         // benefit is lost if 'b' is also tested.
325         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
326         if (a == 0) {
327             return 0;
328         }
329 
330         uint256 c = a * b;
331         require(c / a == b, "SafeMath: multiplication overflow");
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the integer division of two unsigned integers. Reverts on
338      * division by zero. The result is rounded towards zero.
339      *
340      * Counterpart to Solidity's `/` operator. Note: this function uses a
341      * `revert` opcode (which leaves remaining gas untouched) while Solidity
342      * uses an invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function div(uint256 a, uint256 b) internal pure returns (uint256) {
349         return div(a, b, "SafeMath: division by zero");
350     }
351 
352     /**
353      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
354      * division by zero. The result is rounded towards zero.
355      *
356      * Counterpart to Solidity's `/` operator. Note: this function uses a
357      * `revert` opcode (which leaves remaining gas untouched) while Solidity
358      * uses an invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      *
362      * - The divisor cannot be zero.
363      */
364     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
365         require(b > 0, errorMessage);
366         uint256 c = a / b;
367         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
368 
369         return c;
370     }
371 
372     /**
373      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
374      * Reverts when dividing by zero.
375      *
376      * Counterpart to Solidity's `%` operator. This function uses a `revert`
377      * opcode (which leaves remaining gas untouched) while Solidity uses an
378      * invalid opcode to revert (consuming all remaining gas).
379      *
380      * Requirements:
381      *
382      * - The divisor cannot be zero.
383      */
384     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
385         return mod(a, b, "SafeMath: modulo by zero");
386     }
387 
388     /**
389      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
390      * Reverts with custom message when dividing by zero.
391      *
392      * Counterpart to Solidity's `%` operator. This function uses a `revert`
393      * opcode (which leaves remaining gas untouched) while Solidity uses an
394      * invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
401         require(b != 0, errorMessage);
402         return a % b;
403     }
404 }
405 
406 // 
407 /**
408  * @dev Interface of the ERC20 standard as defined in the EIP.
409  */
410 interface IERC20 {
411     /**
412      * @dev Returns the amount of tokens in existence.
413      */
414     function totalSupply() external view returns (uint256);
415 
416     /**
417      * @dev Returns the amount of tokens owned by `account`.
418      */
419     function balanceOf(address account) external view returns (uint256);
420 
421     /**
422      * @dev Moves `amount` tokens from the caller's account to `recipient`.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * Emits a {Transfer} event.
427      */
428     function transfer(address recipient, uint256 amount) external returns (bool);
429 
430     /**
431      * @dev Returns the remaining number of tokens that `spender` will be
432      * allowed to spend on behalf of `owner` through {transferFrom}. This is
433      * zero by default.
434      *
435      * This value changes when {approve} or {transferFrom} are called.
436      */
437     function allowance(address owner, address spender) external view returns (uint256);
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
441      *
442      * Returns a boolean value indicating whether the operation succeeded.
443      *
444      * IMPORTANT: Beware that changing an allowance with this method brings the risk
445      * that someone may use both the old and the new allowance by unfortunate
446      * transaction ordering. One possible solution to mitigate this race
447      * condition is to first reduce the spender's allowance to 0 and set the
448      * desired value afterwards:
449      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address spender, uint256 amount) external returns (bool);
454 
455     /**
456      * @dev Moves `amount` tokens from `sender` to `recipient` using the
457      * allowance mechanism. `amount` is then deducted from the caller's
458      * allowance.
459      *
460      * Returns a boolean value indicating whether the operation succeeded.
461      *
462      * Emits a {Transfer} event.
463      */
464     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
465 
466     /**
467      * @dev Emitted when `value` tokens are moved from one account (`from`) to
468      * another (`to`).
469      *
470      * Note that `value` may be zero.
471      */
472     event Transfer(address indexed from, address indexed to, uint256 value);
473 
474     /**
475      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
476      * a call to {approve}. `value` is the new allowance.
477      */
478     event Approval(address indexed owner, address indexed spender, uint256 value);
479 }
480 
481 // 
482 interface IWETH {
483     function deposit() external payable;
484     function transfer(address to, uint value) external returns (bool);
485     function withdraw(uint) external;
486     function balanceOf(address account) external view returns (uint);
487 }
488 
489 // 
490 interface ICoFiXERC20 {
491     event Approval(address indexed owner, address indexed spender, uint value);
492     event Transfer(address indexed from, address indexed to, uint value);
493 
494     // function name() external pure returns (string memory);
495     // function symbol() external pure returns (string memory);
496     function decimals() external pure returns (uint8);
497     function totalSupply() external view returns (uint);
498     function balanceOf(address owner) external view returns (uint);
499     function allowance(address owner, address spender) external view returns (uint);
500 
501     function approve(address spender, uint value) external returns (bool);
502     function transfer(address to, uint value) external returns (bool);
503     function transferFrom(address from, address to, uint value) external returns (bool);
504 
505     function DOMAIN_SEPARATOR() external view returns (bytes32);
506     function PERMIT_TYPEHASH() external pure returns (bytes32);
507     function nonces(address owner) external view returns (uint);
508 
509     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
510 }
511 
512 // 
513 interface ICoFiXPair is ICoFiXERC20 {
514 
515     struct OraclePrice {
516         uint256 ethAmount;
517         uint256 erc20Amount;
518         uint256 blockNum;
519         uint256 K;
520         uint256 theta;
521     }
522 
523     // All pairs: {ETH <-> ERC20 Token}
524     event Mint(address indexed sender, uint amount0, uint amount1);
525     event Burn(address indexed sender, address outToken, uint outAmount, address indexed to);
526     event Swap(
527         address indexed sender,
528         uint amountIn,
529         uint amountOut,
530         address outToken,
531         address indexed to
532     );
533     event Sync(uint112 reserve0, uint112 reserve1);
534 
535     function MINIMUM_LIQUIDITY() external pure returns (uint);
536     function factory() external view returns (address);
537     function token0() external view returns (address);
538     function token1() external view returns (address);
539     function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
540 
541     function mint(address to) external payable returns (uint liquidity, uint oracleFeeChange);
542     function burn(address outToken, address to) external payable returns (uint amountOut, uint oracleFeeChange);
543     function swapWithExact(address outToken, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
544     function swapForExact(address outToken, uint amountOutExact, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
545     function skim(address to) external;
546     function sync() external;
547 
548     function initialize(address, address, string memory, string memory) external;
549 
550     /// @dev get Net Asset Value Per Share
551     /// @param  ethAmount ETH side of Oracle price {ETH <-> ERC20 Token}
552     /// @param  erc20Amount Token side of Oracle price {ETH <-> ERC20 Token}
553     /// @return navps The Net Asset Value Per Share (liquidity) represents
554     function getNAVPerShare(uint256 ethAmount, uint256 erc20Amount) external view returns (uint256 navps);
555 }
556 
557 // 
558 interface ICoFiXVaultForLP {
559 
560     enum POOL_STATE {INVALID, ENABLED, DISABLED}
561 
562     event NewPoolAdded(address pool, uint256 index);
563     event PoolEnabled(address pool);
564     event PoolDisabled(address pool);
565 
566     function setGovernance(address _new) external;
567     function setInitCoFiRate(uint256 _new) external;
568     function setDecayPeriod(uint256 _new) external;
569     function setDecayRate(uint256 _new) external;
570 
571     function addPool(address pool) external;
572     function enablePool(address pool) external;
573     function disablePool(address pool) external;
574     function setPoolWeight(address pool, uint256 weight) external;
575     function batchSetPoolWeight(address[] memory pools, uint256[] memory weights) external;
576     function distributeReward(address to, uint256 amount) external;
577 
578     function getPendingRewardOfLP(address pair) external view returns (uint256);
579     function currentPeriod() external view returns (uint256);
580     function currentCoFiRate() external view returns (uint256);
581     function currentPoolRate(address pool) external view returns (uint256 poolRate);
582     function currentPoolRateByPair(address pair) external view returns (uint256 poolRate);
583 
584     /// @dev Get the award staking pool address of pair (XToken)
585     /// @param  pair The address of XToken(pair) contract
586     /// @return pool The pool address
587     function stakingPoolForPair(address pair) external view returns (address pool);
588 
589     function getPoolInfo(address pool) external view returns (POOL_STATE state, uint256 weight);
590     function getPoolInfoByPair(address pair) external view returns (POOL_STATE state, uint256 weight);
591 
592     function getEnabledPoolCnt() external view returns (uint256);
593 
594     function getCoFiStakingPool() external view returns (address pool);
595 
596 }
597 
598 // 
599 interface ICoFiXStakingRewards {
600     // Views
601 
602     /// @dev The rewards vault contract address set in factory contract
603     /// @return Returns the vault address
604     function rewardsVault() external view returns (address);
605 
606     /// @dev The lastBlock reward applicable
607     /// @return Returns the latest block.number on-chain
608     function lastBlockRewardApplicable() external view returns (uint256);
609 
610     /// @dev Reward amount represents by per staking token
611     function rewardPerToken() external view returns (uint256);
612 
613     /// @dev How many reward tokens a user has earned but not claimed at present
614     /// @param  account The target account
615     /// @return The amount of reward tokens a user earned
616     function earned(address account) external view returns (uint256);
617 
618     /// @dev How many reward tokens accrued recently
619     /// @return The amount of reward tokens accrued recently
620     function accrued() external view returns (uint256);
621 
622     /// @dev Get the latest reward rate of this mining pool (tokens amount per block)
623     /// @return The latest reward rate
624     function rewardRate() external view returns (uint256);
625 
626     /// @dev How many stakingToken (XToken) deposited into to this reward pool (mining pool)
627     /// @return The total amount of XTokens deposited in this mining pool
628     function totalSupply() external view returns (uint256);
629 
630     /// @dev How many stakingToken (XToken) deposited by the target account
631     /// @param  account The target account
632     /// @return The total amount of XToken deposited in this mining pool
633     function balanceOf(address account) external view returns (uint256);
634 
635     /// @dev Get the address of token for staking in this mining pool
636     /// @return The staking token address
637     function stakingToken() external view returns (address);
638 
639     /// @dev Get the address of token for rewards in this mining pool
640     /// @return The rewards token address
641     function rewardsToken() external view returns (address);
642 
643     // Mutative
644 
645     /// @dev Stake/Deposit into the reward pool (mining pool)
646     /// @param  amount The target amount
647     function stake(uint256 amount) external;
648 
649     /// @dev Stake/Deposit into the reward pool (mining pool) for other account
650     /// @param  other The target account
651     /// @param  amount The target amount
652     function stakeForOther(address other, uint256 amount) external;
653 
654     /// @dev Withdraw from the reward pool (mining pool), get the original tokens back
655     /// @param  amount The target amount
656     function withdraw(uint256 amount) external;
657 
658     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
659     function emergencyWithdraw() external;
660 
661     /// @dev Claim the reward the user earned
662     function getReward() external;
663 
664     function getRewardAndStake() external;
665 
666     /// @dev User exit the reward pool, it's actually withdraw and getReward
667     function exit() external;
668 
669     /// @dev Add reward to the mining pool
670     function addReward(uint256 amount) external;
671 
672     // Events
673     event RewardAdded(address sender, uint256 reward);
674     event Staked(address indexed user, uint256 amount);
675     event StakedForOther(address indexed user, address indexed other, uint256 amount);
676     event Withdrawn(address indexed user, uint256 amount);
677     event EmergencyWithdraw(address indexed user, uint256 amount);
678     event RewardPaid(address indexed user, uint256 reward);
679 }
680 
681 // 
682 interface ICoFiXVaultForTrader {
683 
684     event RouterAllowed(address router);
685     event RouterDisallowed(address router);
686 
687     event ClearPendingRewardOfCNode(uint256 pendingAmount);
688     event ClearPendingRewardOfLP(uint256 pendingAmount);
689 
690     function setGovernance(address gov) external;
691 
692     function setExpectedYieldRatio(uint256 r) external;
693     function setLRatio(uint256 lRatio) external;
694     function setTheta(uint256 theta) external;
695 
696     function allowRouter(address router) external;
697 
698     function disallowRouter(address router) external;
699 
700     function calcCoFiRate(uint256 bt_phi, uint256 xt, uint256 np) external view returns (uint256 at);
701 
702     function currentCoFiRate(address pair, uint256 np) external view returns (uint256);
703 
704     function currentThreshold(address pair, uint256 np, uint256 cofiRate) external view returns (uint256);
705 
706     function stdMiningRateAndAmount(address pair, uint256 np, uint256 thetaFee) external view returns (uint256 cofiRate, uint256 stdAmount);
707 
708     function calcDensity(uint256 _stdAmount) external view returns (uint256);
709 
710     function calcLambda(uint256 x, uint256 y) external pure returns (uint256);
711 
712     function actualMiningAmountAndDensity(address pair, uint256 thetaFee, uint256 x, uint256 y, uint256 np) external view returns (uint256 amount, uint256 density, uint256 cofiRate);
713 
714     function distributeReward(address pair, uint256 thetaFee, uint256 x, uint256 y, uint256 np, address rewardTo) external;
715 
716     function clearPendingRewardOfCNode() external;
717 
718     function clearPendingRewardOfLP(address pair) external;
719 
720     function getPendingRewardOfCNode() external view returns (uint256);
721 
722     function getPendingRewardOfLP(address pair) external view returns (uint256);
723 
724     function getCoFiRateCache(address pair) external view returns (uint256 cofiRate, uint256 updatedBlock);
725 }
726 
727 // 
728 // Router contract to interact with each CoFiXPair, no owner or governance
729 contract CoFiXRouter is ICoFiXRouter {
730     using SafeMath for uint;
731 
732     address public immutable override factory;
733     address public immutable override WETH;
734 
735     modifier ensure(uint deadline) {
736         require(deadline >= block.timestamp, 'CRouter: EXPIRED');
737         _;
738     }
739 
740     constructor(address _factory, address _WETH) public {
741         factory = _factory;
742         WETH = _WETH;
743     }
744 
745     receive() external payable {}
746 
747     // calculates the CREATE2 address for a pair without making any external calls
748     function pairFor(address _factory, address token) internal view returns (address pair) {
749         // pair = address(uint(keccak256(abi.encodePacked(
750         //         hex'ff',
751         //         _factory,
752         //         keccak256(abi.encodePacked(token)),
753         //         hex'fb0c5470b7fbfce7f512b5035b5c35707fd5c7bd43c8d81959891b0296030118' // init code hash
754         //     )))); // calc the real init code hash, not suitable for us now, could use this in the future
755         return ICoFiXFactory(_factory).getPair(token);
756     }
757 
758     // msg.value = amountETH + oracle fee
759     function addLiquidity(
760         address token,
761         uint amountETH,
762         uint amountToken,
763         uint liquidityMin,
764         address to,
765         uint deadline
766     ) external override payable ensure(deadline) returns (uint liquidity)
767     {
768         // create the pair if it doesn't exist yet
769         if (ICoFiXFactory(factory).getPair(token) == address(0)) {
770             ICoFiXFactory(factory).createPair(token);
771         }
772         require(msg.value > amountETH, "CRouter: insufficient msg.value");
773         uint256 _oracleFee = msg.value.sub(amountETH);
774         address pair = pairFor(factory, token);
775         if (amountToken > 0 ) { // support for tokens which do not allow to transfer zero values
776             TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
777         }
778         if (amountETH > 0) {
779             IWETH(WETH).deposit{value: amountETH}();
780             assert(IWETH(WETH).transfer(pair, amountETH));
781         }
782         uint256 oracleFeeChange;
783         (liquidity, oracleFeeChange) = ICoFiXPair(pair).mint{value: _oracleFee}(to);
784         require(liquidity >= liquidityMin, "CRouter: less liquidity than expected");
785         // refund oracle fee to msg.sender, if any
786         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
787     }
788 
789     // msg.value = amountETH + oracle fee
790     function addLiquidityAndStake(
791         address token,
792         uint amountETH,
793         uint amountToken,
794         uint liquidityMin,
795         address to,
796         uint deadline
797     ) external override payable ensure(deadline) returns (uint liquidity)
798     {
799         // must create a pair before using this function
800         require(msg.value > amountETH, "CRouter: insufficient msg.value");
801         uint256 _oracleFee = msg.value.sub(amountETH);
802         address pair = pairFor(factory, token);
803         require(pair != address(0), "CRouter: invalid pair");
804         if (amountToken > 0 ) { // support for tokens which do not allow to transfer zero values
805             TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
806         }
807         if (amountETH > 0) {
808             IWETH(WETH).deposit{value: amountETH}();
809             assert(IWETH(WETH).transfer(pair, amountETH));
810         }
811         uint256 oracleFeeChange;
812         (liquidity, oracleFeeChange) = ICoFiXPair(pair).mint{value: _oracleFee}(address(this));
813         require(liquidity >= liquidityMin, "CRouter: less liquidity than expected");
814 
815         // find the staking rewards pool contract for the liquidity token (pair)
816         address pool = ICoFiXVaultForLP(ICoFiXFactory(factory).getVaultForLP()).stakingPoolForPair(pair);
817         require(pool != address(0), "CRouter: invalid staking pool");
818         // approve to staking pool
819         ICoFiXPair(pair).approve(pool, liquidity);
820         ICoFiXStakingRewards(pool).stakeForOther(to, liquidity);
821         ICoFiXPair(pair).approve(pool, 0); // ensure
822         // refund oracle fee to msg.sender, if any
823         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
824     }
825 
826     // msg.value = oracle fee
827     function removeLiquidityGetToken(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         address to,
832         uint deadline
833     ) external override payable ensure(deadline) returns (uint amountToken)
834     {
835         require(msg.value > 0, "CRouter: insufficient msg.value");
836         address pair = pairFor(factory, token);
837         ICoFiXPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
838         uint oracleFeeChange; 
839         (amountToken, oracleFeeChange) = ICoFiXPair(pair).burn{value: msg.value}(token, to);
840         require(amountToken >= amountTokenMin, "CRouter: got less than expected");
841         // refund oracle fee to msg.sender, if any
842         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
843     }
844 
845     // msg.value = oracle fee
846     function removeLiquidityGetETH(
847         address token,
848         uint liquidity,
849         uint amountETHMin,
850         address to,
851         uint deadline
852     ) external override payable ensure(deadline) returns (uint amountETH)
853     {
854         require(msg.value > 0, "CRouter: insufficient msg.value");
855         address pair = pairFor(factory, token);
856         ICoFiXPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
857         uint oracleFeeChange; 
858         (amountETH, oracleFeeChange) = ICoFiXPair(pair).burn{value: msg.value}(WETH, address(this));
859         require(amountETH >= amountETHMin, "CRouter: got less than expected");
860         IWETH(WETH).withdraw(amountETH);
861         TransferHelper.safeTransferETH(to, amountETH);
862         // refund oracle fee to msg.sender, if any
863         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
864     }
865 
866     // msg.value = amountIn + oracle fee
867     function swapExactETHForTokens(
868         address token,
869         uint amountIn,
870         uint amountOutMin,
871         address to,
872         address rewardTo,
873         uint deadline
874     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut)
875     {
876         require(msg.value > amountIn, "CRouter: insufficient msg.value");
877         IWETH(WETH).deposit{value: amountIn}();
878         address pair = pairFor(factory, token);
879         assert(IWETH(WETH).transfer(pair, amountIn));
880         uint oracleFeeChange; 
881         uint256[4] memory tradeInfo;
882         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXPair(pair).swapWithExact{
883             value: msg.value.sub(amountIn)}(token, to);
884         require(_amountOut >= amountOutMin, "CRouter: got less than expected");
885 
886         // distribute trading rewards - CoFi!
887         address vaultForTrader = ICoFiXFactory(factory).getVaultForTrader();
888         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
889             ICoFiXVaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[0], tradeInfo[1], tradeInfo[2], tradeInfo[3], rewardTo);
890         }
891 
892         // refund oracle fee to msg.sender, if any
893         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
894     }
895 
896     // msg.value = oracle fee
897     function swapExactTokensForTokens(
898         address tokenIn,
899         address tokenOut,
900         uint amountIn,
901         uint amountOutMin,
902         address to,
903         address rewardTo,
904         uint deadline
905     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut) {
906 
907         require(msg.value > 0, "CRouter: insufficient msg.value");
908         address[2] memory pairs; // [pairIn, pairOut]
909 
910         // swapExactTokensForETH
911         pairs[0] = pairFor(factory, tokenIn);
912         TransferHelper.safeTransferFrom(tokenIn, msg.sender, pairs[0], amountIn);
913         uint oracleFeeChange;
914         uint256[4] memory tradeInfo;
915         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXPair(pairs[0]).swapWithExact{value: msg.value}(WETH, address(this));
916 
917         // distribute trading rewards - CoFi!
918         address vaultForTrader = ICoFiXFactory(factory).getVaultForTrader();
919         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
920             ICoFiXVaultForTrader(vaultForTrader).distributeReward(pairs[0], tradeInfo[0], tradeInfo[1], tradeInfo[2], tradeInfo[3], rewardTo);
921         }
922 
923         // swapExactETHForTokens
924         pairs[1] = pairFor(factory, tokenOut);
925         assert(IWETH(WETH).transfer(pairs[1], _amountOut)); // swap with all amountOut in last swap
926         (, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXPair(pairs[1]).swapWithExact{value: oracleFeeChange}(tokenOut, to);
927         require(_amountOut >= amountOutMin, "CRouter: got less than expected");
928 
929         // distribute trading rewards - CoFi!
930         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
931             ICoFiXVaultForTrader(vaultForTrader).distributeReward(pairs[1], tradeInfo[0], tradeInfo[1], tradeInfo[2], tradeInfo[3], rewardTo);
932         }
933 
934         // refund oracle fee to msg.sender, if any
935         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
936     }
937 
938     // msg.value = oracle fee
939     function swapExactTokensForETH(
940         address token,
941         uint amountIn,
942         uint amountOutMin,
943         address to,
944         address rewardTo,
945         uint deadline
946     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut)
947     {
948         require(msg.value > 0, "CRouter: insufficient msg.value");
949         address pair = pairFor(factory, token);
950         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountIn);
951         uint oracleFeeChange; 
952         uint256[4] memory tradeInfo;
953         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXPair(pair).swapWithExact{value: msg.value}(WETH, address(this));
954         require(_amountOut >= amountOutMin, "CRouter: got less than expected");
955         IWETH(WETH).withdraw(_amountOut);
956         TransferHelper.safeTransferETH(to, _amountOut);
957 
958         // distribute trading rewards - CoFi!
959         address vaultForTrader = ICoFiXFactory(factory).getVaultForTrader();
960         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
961             ICoFiXVaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[0], tradeInfo[1], tradeInfo[2], tradeInfo[3], rewardTo);
962         }
963 
964         // refund oracle fee to msg.sender, if any
965         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
966     }
967 
968     // msg.value = amountInMax + oracle fee
969     function swapETHForExactTokens(
970         address token,
971         uint amountInMax,
972         uint amountOutExact,
973         address to,
974         address rewardTo,
975         uint deadline
976     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut)
977     {
978         require(msg.value > amountInMax, "CRouter: insufficient msg.value");
979         IWETH(WETH).deposit{value: amountInMax}();
980         address pair = pairFor(factory, token);
981         assert(IWETH(WETH).transfer(pair, amountInMax));
982         uint oracleFeeChange;
983         uint256[4] memory tradeInfo;
984         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXPair(pair).swapForExact{
985             value: msg.value.sub(amountInMax) }(token, amountOutExact, to);
986         // assert amountOutExact equals with _amountOut
987         require(_amountIn <= amountInMax, "CRouter: spend more than expected");
988 
989         // distribute trading rewards - CoFi!
990         address vaultForTrader = ICoFiXFactory(factory).getVaultForTrader();
991         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
992             ICoFiXVaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[0], tradeInfo[1], tradeInfo[2], tradeInfo[3], rewardTo);
993         }
994 
995         // refund oracle fee to msg.sender, if any
996         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
997     }
998 
999     // msg.value = oracle fee
1000     function swapTokensForExactETH(
1001         address token,
1002         uint amountInMax,
1003         uint amountOutExact,
1004         address to,
1005         address rewardTo,
1006         uint deadline
1007     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut)
1008     {
1009         require(msg.value > 0, "CRouter: insufficient msg.value");
1010         address pair = pairFor(factory, token);
1011         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountInMax);
1012         uint oracleFeeChange; 
1013         uint256[4] memory tradeInfo;
1014         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXPair(pair).swapForExact{
1015             value: msg.value}(WETH, amountOutExact, address(this));
1016         // assert amountOutExact equals with _amountOut
1017         require(_amountIn <= amountInMax, "CRouter: got less than expected");
1018         IWETH(WETH).withdraw(_amountOut);
1019 
1020         // distribute trading rewards - CoFi!
1021         address vaultForTrader = ICoFiXFactory(factory).getVaultForTrader();
1022         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
1023             ICoFiXVaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[0], tradeInfo[1], tradeInfo[2], tradeInfo[3], rewardTo);
1024         }
1025 
1026         TransferHelper.safeTransferETH(to, amountOutExact);
1027         // refund oracle fee to msg.sender, if any
1028         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
1029     }
1030 }