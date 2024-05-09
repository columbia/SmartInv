1 // File: contracts/interface/ICoFiXV2VaultForTrader.sol
2 
3 // SPDX-License-Identifier: GPL-3.0-or-later
4 
5 pragma solidity 0.6.12;
6 
7 interface ICoFiXV2VaultForTrader {
8 
9     event RouterAllowed(address router);
10     event RouterDisallowed(address router);
11 
12     event ClearPendingRewardOfCNode(uint256 pendingAmount);
13     event ClearPendingRewardOfLP(uint256 pendingAmount);
14 
15     function setGovernance(address gov) external;
16 
17     function setCofiRate(uint256 cofiRate) external;
18 
19     function allowRouter(address router) external;
20 
21     function disallowRouter(address router) external;
22 
23     function calcMiningRate(address pair, uint256 neededETHAmount) external view returns (uint256);
24 
25     function calcNeededETHAmountForAdjustment(address pair, uint256 reserve0, uint256 reserve1, uint256 ethAmount, uint256 erc20Amount) external view returns (uint256);
26 
27     function actualMiningAmount(address pair, uint256 reserve0, uint256 reserve1, uint256 ethAmount, uint256 erc20Amount) external view returns (uint256 amount, uint256 totalAccruedAmount, uint256 neededETHAmount);
28 
29     function distributeReward(address pair, uint256 ethAmount, uint256 erc20Amount, address rewardTo) external;
30 
31     function clearPendingRewardOfCNode() external;
32 
33     function clearPendingRewardOfLP(address pair) external;
34 
35     function getPendingRewardOfCNode() external view returns (uint256);
36 
37     function getPendingRewardOfLP(address pair) external view returns (uint256);
38 
39 }
40 
41 // File: contracts/interface/ICoFiXStakingRewards.sol
42 
43 pragma solidity 0.6.12;
44 
45 
46 interface ICoFiXStakingRewards {
47     // Views
48 
49     /// @dev The rewards vault contract address set in factory contract
50     /// @return Returns the vault address
51     function rewardsVault() external view returns (address);
52 
53     /// @dev The lastBlock reward applicable
54     /// @return Returns the latest block.number on-chain
55     function lastBlockRewardApplicable() external view returns (uint256);
56 
57     /// @dev Reward amount represents by per staking token
58     function rewardPerToken() external view returns (uint256);
59 
60     /// @dev How many reward tokens a user has earned but not claimed at present
61     /// @param  account The target account
62     /// @return The amount of reward tokens a user earned
63     function earned(address account) external view returns (uint256);
64 
65     /// @dev How many reward tokens accrued recently
66     /// @return The amount of reward tokens accrued recently
67     function accrued() external view returns (uint256);
68 
69     /// @dev Get the latest reward rate of this mining pool (tokens amount per block)
70     /// @return The latest reward rate
71     function rewardRate() external view returns (uint256);
72 
73     /// @dev How many stakingToken (XToken) deposited into to this reward pool (mining pool)
74     /// @return The total amount of XTokens deposited in this mining pool
75     function totalSupply() external view returns (uint256);
76 
77     /// @dev How many stakingToken (XToken) deposited by the target account
78     /// @param  account The target account
79     /// @return The total amount of XToken deposited in this mining pool
80     function balanceOf(address account) external view returns (uint256);
81 
82     /// @dev Get the address of token for staking in this mining pool
83     /// @return The staking token address
84     function stakingToken() external view returns (address);
85 
86     /// @dev Get the address of token for rewards in this mining pool
87     /// @return The rewards token address
88     function rewardsToken() external view returns (address);
89 
90     // Mutative
91 
92     /// @dev Stake/Deposit into the reward pool (mining pool)
93     /// @param  amount The target amount
94     function stake(uint256 amount) external;
95 
96     /// @dev Stake/Deposit into the reward pool (mining pool) for other account
97     /// @param  other The target account
98     /// @param  amount The target amount
99     function stakeForOther(address other, uint256 amount) external;
100 
101     /// @dev Withdraw from the reward pool (mining pool), get the original tokens back
102     /// @param  amount The target amount
103     function withdraw(uint256 amount) external;
104 
105     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
106     function emergencyWithdraw() external;
107 
108     /// @dev Claim the reward the user earned
109     function getReward() external;
110 
111     function getRewardAndStake() external;
112 
113     /// @dev User exit the reward pool, it's actually withdraw and getReward
114     function exit() external;
115 
116     /// @dev Add reward to the mining pool
117     function addReward(uint256 amount) external;
118 
119     // Events
120     event RewardAdded(address sender, uint256 reward);
121     event Staked(address indexed user, uint256 amount);
122     event StakedForOther(address indexed user, address indexed other, uint256 amount);
123     event Withdrawn(address indexed user, uint256 amount);
124     event EmergencyWithdraw(address indexed user, uint256 amount);
125     event RewardPaid(address indexed user, uint256 reward);
126 }
127 // File: contracts/interface/ICoFiXVaultForLP.sol
128 
129 pragma solidity 0.6.12;
130 
131 interface ICoFiXVaultForLP {
132 
133     enum POOL_STATE {INVALID, ENABLED, DISABLED}
134 
135     event NewPoolAdded(address pool, uint256 index);
136     event PoolEnabled(address pool);
137     event PoolDisabled(address pool);
138 
139     function setGovernance(address _new) external;
140     function setInitCoFiRate(uint256 _new) external;
141     function setDecayPeriod(uint256 _new) external;
142     function setDecayRate(uint256 _new) external;
143 
144     function addPool(address pool) external;
145     function enablePool(address pool) external;
146     function disablePool(address pool) external;
147     function setPoolWeight(address pool, uint256 weight) external;
148     function batchSetPoolWeight(address[] memory pools, uint256[] memory weights) external;
149     function distributeReward(address to, uint256 amount) external;
150 
151     function getPendingRewardOfLP(address pair) external view returns (uint256);
152     function currentPeriod() external view returns (uint256);
153     function currentCoFiRate() external view returns (uint256);
154     function currentPoolRate(address pool) external view returns (uint256 poolRate);
155     function currentPoolRateByPair(address pair) external view returns (uint256 poolRate);
156 
157     /// @dev Get the award staking pool address of pair (XToken)
158     /// @param  pair The address of XToken(pair) contract
159     /// @return pool The pool address
160     function stakingPoolForPair(address pair) external view returns (address pool);
161 
162     function getPoolInfo(address pool) external view returns (POOL_STATE state, uint256 weight);
163     function getPoolInfoByPair(address pair) external view returns (POOL_STATE state, uint256 weight);
164 
165     function getEnabledPoolCnt() external view returns (uint256);
166 
167     function getCoFiStakingPool() external view returns (address pool);
168 
169 }
170 // File: contracts/interface/ICoFiXERC20.sol
171 
172 pragma solidity 0.6.12;
173 
174 interface ICoFiXERC20 {
175     event Approval(address indexed owner, address indexed spender, uint value);
176     event Transfer(address indexed from, address indexed to, uint value);
177 
178     // function name() external pure returns (string memory);
179     // function symbol() external pure returns (string memory);
180     function decimals() external pure returns (uint8);
181     function totalSupply() external view returns (uint);
182     function balanceOf(address owner) external view returns (uint);
183     function allowance(address owner, address spender) external view returns (uint);
184 
185     function approve(address spender, uint value) external returns (bool);
186     function transfer(address to, uint value) external returns (bool);
187     function transferFrom(address from, address to, uint value) external returns (bool);
188 
189     function DOMAIN_SEPARATOR() external view returns (bytes32);
190     function PERMIT_TYPEHASH() external pure returns (bytes32);
191     function nonces(address owner) external view returns (uint);
192 
193     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
194 }
195 
196 // File: contracts/interface/ICoFiXV2Pair.sol
197 
198 pragma solidity 0.6.12;
199 
200 
201 interface ICoFiXV2Pair is ICoFiXERC20 {
202 
203     struct OraclePrice {
204         uint256 ethAmount;
205         uint256 erc20Amount;
206         uint256 blockNum;
207         uint256 K;
208         uint256 theta;
209     }
210 
211     // All pairs: {ETH <-> ERC20 Token}
212     event Mint(address indexed sender, uint amount0, uint amount1);
213     event Burn(address indexed sender, address outToken, uint outAmount, address indexed to);
214     event Swap(
215         address indexed sender,
216         uint amountIn,
217         uint amountOut,
218         address outToken,
219         address indexed to
220     );
221     event Sync(uint112 reserve0, uint112 reserve1);
222 
223     function MINIMUM_LIQUIDITY() external pure returns (uint);
224     function factory() external view returns (address);
225     function token0() external view returns (address);
226     function token1() external view returns (address);
227     function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
228 
229     function mint(address to, uint amountETH, uint amountToken) external payable returns (uint liquidity, uint oracleFeeChange);
230     function burn(address tokenTo, address ethTo) external payable returns (uint amountTokenOut, uint amountETHOut, uint oracleFeeChange);
231     function swapWithExact(address outToken, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[5] memory tradeInfo);
232     // function swapForExact(address outToken, uint amountOutExact, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
233     function skim(address to) external;
234     function sync() external;
235 
236     function initialize(address, address, string memory, string memory, uint256, uint256) external;
237 
238     /// @dev get Net Asset Value Per Share
239     /// @param  ethAmount ETH side of Oracle price {ETH <-> ERC20 Token}
240     /// @param  erc20Amount Token side of Oracle price {ETH <-> ERC20 Token}
241     /// @return navps The Net Asset Value Per Share (liquidity) represents
242     function getNAVPerShare(uint256 ethAmount, uint256 erc20Amount) external view returns (uint256 navps);
243 
244     /// @dev get initial asset ratio
245     /// @return _initToken0Amount Token0(ETH) side of initial asset ratio {ETH <-> ERC20 Token}
246     /// @return _initToken1Amount Token1(ERC20) side of initial asset ratio {ETH <-> ERC20 Token}
247     function getInitialAssetRatio() external view returns (uint256 _initToken0Amount, uint256 _initToken1Amount);
248 }
249 
250 // File: contracts/interface/IWETH.sol
251 
252 pragma solidity 0.6.12;
253 
254 interface IWETH {
255     function deposit() external payable;
256     function transfer(address to, uint value) external returns (bool);
257     function withdraw(uint) external;
258     function balanceOf(address account) external view returns (uint);
259 }
260 
261 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
262 
263 pragma solidity >=0.6.0 <0.8.0;
264 
265 /**
266  * @dev Interface of the ERC20 standard as defined in the EIP.
267  */
268 interface IERC20 {
269     /**
270      * @dev Returns the amount of tokens in existence.
271      */
272     function totalSupply() external view returns (uint256);
273 
274     /**
275      * @dev Returns the amount of tokens owned by `account`.
276      */
277     function balanceOf(address account) external view returns (uint256);
278 
279     /**
280      * @dev Moves `amount` tokens from the caller's account to `recipient`.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transfer(address recipient, uint256 amount) external returns (bool);
287 
288     /**
289      * @dev Returns the remaining number of tokens that `spender` will be
290      * allowed to spend on behalf of `owner` through {transferFrom}. This is
291      * zero by default.
292      *
293      * This value changes when {approve} or {transferFrom} are called.
294      */
295     function allowance(address owner, address spender) external view returns (uint256);
296 
297     /**
298      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * IMPORTANT: Beware that changing an allowance with this method brings the risk
303      * that someone may use both the old and the new allowance by unfortunate
304      * transaction ordering. One possible solution to mitigate this race
305      * condition is to first reduce the spender's allowance to 0 and set the
306      * desired value afterwards:
307      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308      *
309      * Emits an {Approval} event.
310      */
311     function approve(address spender, uint256 amount) external returns (bool);
312 
313     /**
314      * @dev Moves `amount` tokens from `sender` to `recipient` using the
315      * allowance mechanism. `amount` is then deducted from the caller's
316      * allowance.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Emitted when `value` tokens are moved from one account (`from`) to
326      * another (`to`).
327      *
328      * Note that `value` may be zero.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 value);
331 
332     /**
333      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
334      * a call to {approve}. `value` is the new allowance.
335      */
336     event Approval(address indexed owner, address indexed spender, uint256 value);
337 }
338 
339 // File: contracts/interface/ICoFiXV2Router.sol
340 
341 pragma solidity 0.6.12;
342 
343 interface ICoFiXV2Router {
344     function factory() external pure returns (address);
345     function WETH() external pure returns (address);
346 
347     enum DEX_TYPE { COFIX, UNISWAP }
348 
349     // All pairs: {ETH <-> ERC20 Token}
350 
351     /// @dev Maker add liquidity to pool, get pool token (mint XToken to maker) (notice: msg.value = amountETH + oracle fee)
352     /// @param  token The address of ERC20 Token
353     /// @param  amountETH The amount of ETH added to pool
354     /// @param  amountToken The amount of Token added to pool
355     /// @param  liquidityMin The minimum liquidity maker wanted
356     /// @param  to The target address receiving the liquidity pool (XToken)
357     /// @param  deadline The dealine of this request
358     /// @return liquidity The real liquidity or XToken minted from pool
359     function addLiquidity(
360         address token,
361         uint amountETH,
362         uint amountToken,
363         uint liquidityMin,
364         address to,
365         uint deadline
366     ) external payable returns (uint liquidity);
367 
368     /// @dev Maker add liquidity to pool, get pool token (mint XToken) and stake automatically (notice: msg.value = amountETH + oracle fee)
369     /// @param  token The address of ERC20 Token
370     /// @param  amountETH The amount of ETH added to pool
371     /// @param  amountToken The amount of Token added to pool
372     /// @param  liquidityMin The minimum liquidity maker wanted
373     /// @param  to The target address receiving the liquidity pool (XToken)
374     /// @param  deadline The dealine of this request
375     /// @return liquidity The real liquidity or XToken minted from pool
376     function addLiquidityAndStake(
377         address token,
378         uint amountETH,
379         uint amountToken,
380         uint liquidityMin,
381         address to,
382         uint deadline
383     ) external payable returns (uint liquidity);
384 
385     /// @dev Maker remove liquidity from pool to get ERC20 Token and ETH back (maker burn XToken) (notice: msg.value = oracle fee)
386     /// @param  token The address of ERC20 Token
387     /// @param  liquidity The amount of liquidity (XToken) sent to pool, or the liquidity to remove
388     /// @param  amountETHMin The minimum amount of ETH wanted to get from pool
389     /// @param  to The target address receiving the Token
390     /// @param  deadline The dealine of this request
391     /// @return amountToken The real amount of Token transferred from the pool
392     /// @return amountETH The real amount of ETH transferred from the pool
393     function removeLiquidityGetTokenAndETH(
394         address token,
395         uint liquidity,
396         uint amountETHMin,
397         address to,
398         uint deadline
399     ) external payable returns (uint amountToken, uint amountETH);
400 
401     /// @dev Trader swap exact amount of ETH for ERC20 Tokens (notice: msg.value = amountIn + oracle fee)
402     /// @param  token The address of ERC20 Token
403     /// @param  amountIn The exact amount of ETH a trader want to swap into pool
404     /// @param  amountOutMin The minimum amount of Token a trader want to swap out of pool
405     /// @param  to The target address receiving the Token
406     /// @param  rewardTo The target address receiving the CoFi Token as rewards
407     /// @param  deadline The dealine of this request
408     /// @return _amountIn The real amount of ETH transferred into pool
409     /// @return _amountOut The real amount of Token transferred out of pool
410     function swapExactETHForTokens(
411         address token,
412         uint amountIn,
413         uint amountOutMin,
414         address to,
415         address rewardTo,
416         uint deadline
417     ) external payable returns (uint _amountIn, uint _amountOut);
418 
419     /// @dev Trader swap exact amount of ERC20 Tokens for ETH (notice: msg.value = oracle fee)
420     /// @param  token The address of ERC20 Token
421     /// @param  amountIn The exact amount of Token a trader want to swap into pool
422     /// @param  amountOutMin The mininum amount of ETH a trader want to swap out of pool
423     /// @param  to The target address receiving the ETH
424     /// @param  rewardTo The target address receiving the CoFi Token as rewards
425     /// @param  deadline The dealine of this request
426     /// @return _amountIn The real amount of Token transferred into pool
427     /// @return _amountOut The real amount of ETH transferred out of pool
428     function swapExactTokensForETH(
429         address token,
430         uint amountIn,
431         uint amountOutMin,
432         address to,
433         address rewardTo,
434         uint deadline
435     ) external payable returns (uint _amountIn, uint _amountOut);
436 
437     /// @dev Trader swap exact amount of ERC20 Tokens for other ERC20 Tokens (notice: msg.value = oracle fee)
438     /// @param  tokenIn The address of ERC20 Token a trader want to swap into pool
439     /// @param  tokenOut The address of ERC20 Token a trader want to swap out of pool
440     /// @param  amountIn The exact amount of Token a trader want to swap into pool
441     /// @param  amountOutMin The mininum amount of ETH a trader want to swap out of pool
442     /// @param  to The target address receiving the Token
443     /// @param  rewardTo The target address receiving the CoFi Token as rewards
444     /// @param  deadline The dealine of this request
445     /// @return _amountIn The real amount of Token transferred into pool
446     /// @return _amountOut The real amount of Token transferred out of pool
447     function swapExactTokensForTokens(
448         address tokenIn,
449         address tokenOut,
450         uint amountIn,
451         uint amountOutMin,
452         address to,
453         address rewardTo,
454         uint deadline
455     ) external payable returns (uint _amountIn, uint _amountOut);
456 
457     /// @dev Swaps an exact amount of input tokens for as many output tokens as possible, along the route determined by the path. The first element of path is the input token, the last is the output token, and any intermediate elements represent intermediate pairs to trade through (if, for example, a direct pair does not exist). `msg.sender` should have already given the router an allowance of at least amountIn on the input token. The swap execution can be done via cofix or uniswap. That's why it's called hybrid.
458     /// @param amountIn The amount of input tokens to send.
459     /// @param amountOutMin The minimum amount of output tokens that must be received for the transaction not to revert.
460     /// @param path An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.
461     /// @param dexes An array of dex type values, specifying the exchanges to be used, e.g. CoFiX, Uniswap.
462     /// @param to Recipient of the output tokens.
463     /// @param  rewardTo The target address receiving the CoFi Token as rewards.
464     /// @param deadline Unix timestamp after which the transaction will revert.
465     /// @return amounts The input token amount and all subsequent output token amounts.
466     function hybridSwapExactTokensForTokens(
467         uint amountIn,
468         uint amountOutMin,
469         address[] calldata path,
470         DEX_TYPE[] calldata dexes,
471         address to,
472         address rewardTo,
473         uint deadline
474     ) external payable returns (uint[] memory amounts);
475 
476     /// @dev Swaps an exact amount of ETH for as many output tokens as possible, along the route determined by the path. The first element of path must be WETH, the last is the output token, and any intermediate elements represent intermediate pairs to trade through (if, for example, a direct pair does not exist).
477     /// @param amountIn The amount of input tokens to send.
478     /// @param amountOutMin The minimum amount of output tokens that must be received for the transaction not to revert.
479     /// @param path An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.
480     /// @param dexes An array of dex type values, specifying the exchanges to be used, e.g. CoFiX, Uniswap.
481     /// @param to Recipient of the output tokens.
482     /// @param  rewardTo The target address receiving the CoFi Token as rewards.
483     /// @param deadline Unix timestamp after which the transaction will revert.
484     /// @return amounts The input token amount and all subsequent output token amounts.
485     function hybridSwapExactETHForTokens(
486         uint amountIn,
487         uint amountOutMin,
488         address[] calldata path,
489         DEX_TYPE[] calldata dexes,
490         address to,
491         address rewardTo,
492         uint deadline
493     ) external payable returns (uint[] memory amounts);
494 
495     /// @dev Swaps an exact amount of tokens for as much ETH as possible, along the route determined by the path. The first element of path is the input token, the last must be WETH, and any intermediate elements represent intermediate pairs to trade through (if, for example, a direct pair does not exist). If the to address is a smart contract, it must have the ability to receive ETH.
496     /// @param amountIn The amount of input tokens to send.
497     /// @param amountOutMin The minimum amount of output tokens that must be received for the transaction not to revert.
498     /// @param path An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.
499     /// @param dexes An array of dex type values, specifying the exchanges to be used, e.g. CoFiX, Uniswap.
500     /// @param to Recipient of the output tokens.
501     /// @param  rewardTo The target address receiving the CoFi Token as rewards.
502     /// @param deadline Unix timestamp after which the transaction will revert.
503     /// @return amounts The input token amount and all subsequent output token amounts.
504     function hybridSwapExactTokensForETH(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         DEX_TYPE[] calldata dexes,
509         address to,
510         address rewardTo,
511         uint deadline
512     ) external payable returns (uint[] memory amounts);
513 
514 }
515 
516 // File: @openzeppelin/contracts/math/SafeMath.sol
517 
518 pragma solidity >=0.6.0 <0.8.0;
519 
520 /**
521  * @dev Wrappers over Solidity's arithmetic operations with added overflow
522  * checks.
523  *
524  * Arithmetic operations in Solidity wrap on overflow. This can easily result
525  * in bugs, because programmers usually assume that an overflow raises an
526  * error, which is the standard behavior in high level programming languages.
527  * `SafeMath` restores this intuition by reverting the transaction when an
528  * operation overflows.
529  *
530  * Using this library instead of the unchecked operations eliminates an entire
531  * class of bugs, so it's recommended to use it always.
532  */
533 library SafeMath {
534     /**
535      * @dev Returns the addition of two unsigned integers, with an overflow flag.
536      *
537      * _Available since v3.4._
538      */
539     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
540         uint256 c = a + b;
541         if (c < a) return (false, 0);
542         return (true, c);
543     }
544 
545     /**
546      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
547      *
548      * _Available since v3.4._
549      */
550     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
551         if (b > a) return (false, 0);
552         return (true, a - b);
553     }
554 
555     /**
556      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
557      *
558      * _Available since v3.4._
559      */
560     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
561         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
562         // benefit is lost if 'b' is also tested.
563         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
564         if (a == 0) return (true, 0);
565         uint256 c = a * b;
566         if (c / a != b) return (false, 0);
567         return (true, c);
568     }
569 
570     /**
571      * @dev Returns the division of two unsigned integers, with a division by zero flag.
572      *
573      * _Available since v3.4._
574      */
575     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
576         if (b == 0) return (false, 0);
577         return (true, a / b);
578     }
579 
580     /**
581      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
582      *
583      * _Available since v3.4._
584      */
585     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
586         if (b == 0) return (false, 0);
587         return (true, a % b);
588     }
589 
590     /**
591      * @dev Returns the addition of two unsigned integers, reverting on
592      * overflow.
593      *
594      * Counterpart to Solidity's `+` operator.
595      *
596      * Requirements:
597      *
598      * - Addition cannot overflow.
599      */
600     function add(uint256 a, uint256 b) internal pure returns (uint256) {
601         uint256 c = a + b;
602         require(c >= a, "SafeMath: addition overflow");
603         return c;
604     }
605 
606     /**
607      * @dev Returns the subtraction of two unsigned integers, reverting on
608      * overflow (when the result is negative).
609      *
610      * Counterpart to Solidity's `-` operator.
611      *
612      * Requirements:
613      *
614      * - Subtraction cannot overflow.
615      */
616     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
617         require(b <= a, "SafeMath: subtraction overflow");
618         return a - b;
619     }
620 
621     /**
622      * @dev Returns the multiplication of two unsigned integers, reverting on
623      * overflow.
624      *
625      * Counterpart to Solidity's `*` operator.
626      *
627      * Requirements:
628      *
629      * - Multiplication cannot overflow.
630      */
631     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
632         if (a == 0) return 0;
633         uint256 c = a * b;
634         require(c / a == b, "SafeMath: multiplication overflow");
635         return c;
636     }
637 
638     /**
639      * @dev Returns the integer division of two unsigned integers, reverting on
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
650     function div(uint256 a, uint256 b) internal pure returns (uint256) {
651         require(b > 0, "SafeMath: division by zero");
652         return a / b;
653     }
654 
655     /**
656      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
657      * reverting when dividing by zero.
658      *
659      * Counterpart to Solidity's `%` operator. This function uses a `revert`
660      * opcode (which leaves remaining gas untouched) while Solidity uses an
661      * invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
668         require(b > 0, "SafeMath: modulo by zero");
669         return a % b;
670     }
671 
672     /**
673      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
674      * overflow (when the result is negative).
675      *
676      * CAUTION: This function is deprecated because it requires allocating memory for the error
677      * message unnecessarily. For custom revert reasons use {trySub}.
678      *
679      * Counterpart to Solidity's `-` operator.
680      *
681      * Requirements:
682      *
683      * - Subtraction cannot overflow.
684      */
685     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
686         require(b <= a, errorMessage);
687         return a - b;
688     }
689 
690     /**
691      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
692      * division by zero. The result is rounded towards zero.
693      *
694      * CAUTION: This function is deprecated because it requires allocating memory for the error
695      * message unnecessarily. For custom revert reasons use {tryDiv}.
696      *
697      * Counterpart to Solidity's `/` operator. Note: this function uses a
698      * `revert` opcode (which leaves remaining gas untouched) while Solidity
699      * uses an invalid opcode to revert (consuming all remaining gas).
700      *
701      * Requirements:
702      *
703      * - The divisor cannot be zero.
704      */
705     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
706         require(b > 0, errorMessage);
707         return a / b;
708     }
709 
710     /**
711      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
712      * reverting with custom message when dividing by zero.
713      *
714      * CAUTION: This function is deprecated because it requires allocating memory for the error
715      * message unnecessarily. For custom revert reasons use {tryMod}.
716      *
717      * Counterpart to Solidity's `%` operator. This function uses a `revert`
718      * opcode (which leaves remaining gas untouched) while Solidity uses an
719      * invalid opcode to revert (consuming all remaining gas).
720      *
721      * Requirements:
722      *
723      * - The divisor cannot be zero.
724      */
725     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
726         require(b > 0, errorMessage);
727         return a % b;
728     }
729 }
730 
731 // File: contracts/lib/UniswapV2Library.sol
732 
733 pragma solidity 0.6.12;
734 
735 
736 interface IUniswapV2Pair {
737     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
738     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
739 }
740 
741 library UniswapV2Library {
742     using SafeMath for uint;
743 
744     // returns sorted token addresses, used to handle return values from pairs sorted in this order
745     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
746         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
747         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
748         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
749     }
750 
751     // calculates the CREATE2 address for a pair without making any external calls
752     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
753         (address token0, address token1) = sortTokens(tokenA, tokenB);
754         pair = address(uint(keccak256(abi.encodePacked(
755                 hex'ff',
756                 factory,
757                 keccak256(abi.encodePacked(token0, token1)),
758                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
759             ))));
760     }
761 
762     // fetches and sorts the reserves for a pair
763     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
764         (address token0,) = sortTokens(tokenA, tokenB);
765         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
766         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
767     }
768 
769     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
770     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
771         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
772         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
773         amountB = amountA.mul(reserveB) / reserveA;
774     }
775 
776     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
777     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
778         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
779         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
780         uint amountInWithFee = amountIn.mul(997);
781         uint numerator = amountInWithFee.mul(reserveOut);
782         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
783         amountOut = numerator / denominator;
784     }
785 
786     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
787     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
788         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
789         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
790         uint numerator = reserveIn.mul(amountOut).mul(1000);
791         uint denominator = reserveOut.sub(amountOut).mul(997);
792         amountIn = (numerator / denominator).add(1);
793     }
794 
795     // performs chained getAmountOut calculations on any number of pairs
796     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
797         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
798         amounts = new uint[](path.length);
799         amounts[0] = amountIn;
800         for (uint i; i < path.length - 1; i++) {
801             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
802             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
803         }
804     }
805 
806     // performs chained getAmountIn calculations on any number of pairs
807     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
808         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
809         amounts = new uint[](path.length);
810         amounts[amounts.length - 1] = amountOut;
811         for (uint i = path.length - 1; i > 0; i--) {
812             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
813             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
814         }
815     }
816 }
817 
818 // File: contracts/lib/TransferHelper.sol
819 
820 pragma solidity 0.6.12;
821 
822 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
823 library TransferHelper {
824     function safeApprove(address token, address to, uint value) internal {
825         // bytes4(keccak256(bytes('approve(address,uint256)')));
826         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
827         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
828     }
829 
830     function safeTransfer(address token, address to, uint value) internal {
831         // bytes4(keccak256(bytes('transfer(address,uint256)')));
832         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
833         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
834     }
835 
836     function safeTransferFrom(address token, address from, address to, uint value) internal {
837         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
838         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
839         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
840     }
841 
842     function safeTransferETH(address to, uint value) internal {
843         (bool success,) = to.call{value:value}(new bytes(0));
844         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
845     }
846 }
847 
848 // File: contracts/interface/ICoFiXV2Factory.sol
849 
850 pragma solidity 0.6.12;
851 
852 interface ICoFiXV2Factory {
853     // All pairs: {ETH <-> ERC20 Token}
854     event PairCreated(address indexed token, address pair, uint256);
855     event NewGovernance(address _new);
856     event NewController(address _new);
857     event NewFeeReceiver(address _new);
858     event NewFeeVaultForLP(address token, address feeVault);
859     event NewVaultForLP(address _new);
860     event NewVaultForTrader(address _new);
861     event NewVaultForCNode(address _new);
862     event NewDAO(address _new);
863 
864     /// @dev Create a new token pair for trading
865     /// @param  token the address of token to trade
866     /// @param  initToken0Amount the initial asset ratio (initToken0Amount:initToken1Amount)
867     /// @param  initToken1Amount the initial asset ratio (initToken0Amount:initToken1Amount)
868     /// @return pair the address of new token pair
869     function createPair(
870         address token,
871 	    uint256 initToken0Amount,
872         uint256 initToken1Amount
873         )
874         external
875         returns (address pair);
876 
877     function getPair(address token) external view returns (address pair);
878     function allPairs(uint256) external view returns (address pair);
879     function allPairsLength() external view returns (uint256);
880 
881     function getTradeMiningStatus(address token) external view returns (bool status);
882     function setTradeMiningStatus(address token, bool status) external;
883     function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
884     function setFeeVaultForLP(address token, address feeVault) external;
885 
886     function setGovernance(address _new) external;
887     function setController(address _new) external;
888     function setFeeReceiver(address _new) external;
889     function setVaultForLP(address _new) external;
890     function setVaultForTrader(address _new) external;
891     function setVaultForCNode(address _new) external;
892     function setDAO(address _new) external;
893     function getController() external view returns (address controller);
894     function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
895     function getVaultForLP() external view returns (address vaultForLP);
896     function getVaultForTrader() external view returns (address vaultForTrader);
897     function getVaultForCNode() external view returns (address vaultForCNode);
898     function getDAO() external view returns (address dao);
899 }
900 
901 // File: contracts/CoFiXV2Router.sol
902 
903 pragma solidity 0.6.12;
904 
905 // Router contract to interact with each CoFiXPair, no owner or governance
906 contract CoFiXV2Router is ICoFiXV2Router {
907     using SafeMath for uint;
908 
909     address public immutable override factory;
910     address public immutable uniFactory;
911     address public immutable override WETH;
912 
913     uint256 internal constant NEST_ORACLE_FEE = 0.01 ether;
914 
915     modifier ensure(uint deadline) {
916         require(deadline >= block.timestamp, 'CRouter: EXPIRED');
917         _;
918     }
919 
920     constructor(address _factory, address _uniFactory, address _WETH) public {
921         factory = _factory;
922         uniFactory = _uniFactory;
923         WETH = _WETH;
924     }
925 
926     receive() external payable {}
927 
928     // calculates the CREATE2 address for a pair without making any external calls
929     function pairFor(address _factory, address token) internal view returns (address pair) {
930         // pair = address(uint(keccak256(abi.encodePacked(
931         //         hex'ff',
932         //         _factory,
933         //         keccak256(abi.encodePacked(token)),
934         //         hex'fb0c5470b7fbfce7f512b5035b5c35707fd5c7bd43c8d81959891b0296030118' // init code hash
935         //     )))); // calc the real init code hash, not suitable for us now, could use this in the future
936         return ICoFiXV2Factory(_factory).getPair(token);
937     }
938 
939     // msg.value = amountETH + oracle fee
940     function addLiquidity(
941         address token,
942         uint amountETH,
943         uint amountToken,
944         uint liquidityMin,
945         address to,
946         uint deadline
947     ) external override payable ensure(deadline) returns (uint liquidity)
948     {
949         require(msg.value > amountETH, "CRouter: insufficient msg.value");
950         uint256 _oracleFee = msg.value.sub(amountETH);
951         address pair = pairFor(factory, token);
952         if (amountToken > 0 ) { // support for tokens which do not allow to transfer zero values
953             TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
954         }
955         if (amountETH > 0) {
956             IWETH(WETH).deposit{value: amountETH}();
957             assert(IWETH(WETH).transfer(pair, amountETH));
958         }
959         uint256 oracleFeeChange;
960         (liquidity, oracleFeeChange) = ICoFiXV2Pair(pair).mint{value: _oracleFee}(to, amountETH, amountToken);
961         require(liquidity >= liquidityMin, "CRouter: less liquidity than expected");
962         // refund oracle fee to msg.sender, if any
963         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
964     }
965 
966     // msg.value = amountETH + oracle fee
967     function addLiquidityAndStake(
968         address token,
969         uint amountETH,
970         uint amountToken,
971         uint liquidityMin,
972         address to,
973         uint deadline
974     ) external override payable ensure(deadline) returns (uint liquidity)
975     {
976         // must create a pair before using this function
977         require(msg.value > amountETH, "CRouter: insufficient msg.value");
978         uint256 _oracleFee = msg.value.sub(amountETH);
979         address pair = pairFor(factory, token);
980         require(pair != address(0), "CRouter: invalid pair");
981         if (amountToken > 0 ) { // support for tokens which do not allow to transfer zero values
982             TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
983         }
984         if (amountETH > 0) {
985             IWETH(WETH).deposit{value: amountETH}();
986             assert(IWETH(WETH).transfer(pair, amountETH));
987         }
988         uint256 oracleFeeChange;
989         (liquidity, oracleFeeChange) = ICoFiXV2Pair(pair).mint{value: _oracleFee}(address(this), amountETH, amountToken);
990         require(liquidity >= liquidityMin, "CRouter: less liquidity than expected");
991 
992         // find the staking rewards pool contract for the liquidity token (pair)
993         address pool = ICoFiXVaultForLP(ICoFiXV2Factory(factory).getVaultForLP()).stakingPoolForPair(pair);
994         require(pool != address(0), "CRouter: invalid staking pool");
995         // approve to staking pool
996         ICoFiXV2Pair(pair).approve(pool, liquidity);
997         ICoFiXStakingRewards(pool).stakeForOther(to, liquidity);
998         ICoFiXV2Pair(pair).approve(pool, 0); // ensure
999         // refund oracle fee to msg.sender, if any
1000         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
1001     }
1002 
1003     // msg.value = oracle fee
1004     function removeLiquidityGetTokenAndETH(
1005         address token,
1006         uint liquidity,
1007         uint amountETHMin,
1008         address to,
1009         uint deadline
1010     ) external override payable ensure(deadline) returns (uint amountToken, uint amountETH) 
1011     {
1012         require(msg.value > 0, "CRouter: insufficient msg.value");
1013         
1014         address pair = pairFor(factory, token);
1015         ICoFiXV2Pair(pair).transferFrom(msg.sender, pair, liquidity);
1016 
1017         uint oracleFeeChange; 
1018         (amountToken, amountETH, oracleFeeChange) = ICoFiXV2Pair(pair).burn{value: msg.value}(to, address(this));
1019 
1020         require(amountETH >= amountETHMin, "CRouter: got less than expected");
1021 
1022         IWETH(WETH).withdraw(amountETH);
1023         TransferHelper.safeTransferETH(to, amountETH);
1024 
1025         // refund oracle fee to msg.sender, if any
1026         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
1027     }
1028 
1029     // msg.value = amountIn + oracle fee
1030     function swapExactETHForTokens(
1031         address token,
1032         uint amountIn,
1033         uint amountOutMin,
1034         address to,
1035         address rewardTo,
1036         uint deadline
1037     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut)
1038     {
1039         require(msg.value > amountIn, "CRouter: insufficient msg.value");
1040         IWETH(WETH).deposit{value: amountIn}();
1041         address pair = pairFor(factory, token);
1042         assert(IWETH(WETH).transfer(pair, amountIn));
1043         uint oracleFeeChange; 
1044         uint256[5] memory tradeInfo;
1045         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXV2Pair(pair).swapWithExact{
1046             value: msg.value.sub(amountIn)}(token, to);
1047         require(_amountOut >= amountOutMin, "CRouter: got less than expected");
1048 
1049         // distribute trading rewards - CoFi!
1050         address vaultForTrader = ICoFiXV2Factory(factory).getVaultForTrader();
1051         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
1052             ICoFiXV2VaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[1], tradeInfo[2], rewardTo);
1053         }
1054 
1055         // refund oracle fee to msg.sender, if any
1056         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
1057     }
1058 
1059     // msg.value = oracle fee
1060     function swapExactTokensForTokens(
1061         address tokenIn,
1062         address tokenOut,
1063         uint amountIn,
1064         uint amountOutMin,
1065         address to,
1066         address rewardTo,
1067         uint deadline
1068     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut) {
1069 
1070         require(msg.value > 0, "CRouter: insufficient msg.value");
1071         address[2] memory pairs; // [pairIn, pairOut]
1072 
1073         // swapExactTokensForETH
1074         pairs[0] = pairFor(factory, tokenIn);
1075         TransferHelper.safeTransferFrom(tokenIn, msg.sender, pairs[0], amountIn);
1076         uint oracleFeeChange;
1077         uint256[5] memory tradeInfo;
1078         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXV2Pair(pairs[0]).swapWithExact{value: msg.value}(WETH, address(this));
1079 
1080         // distribute trading rewards - CoFi!
1081         address vaultForTrader = ICoFiXV2Factory(factory).getVaultForTrader();
1082         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
1083             ICoFiXV2VaultForTrader(vaultForTrader).distributeReward(pairs[0], tradeInfo[1], tradeInfo[2], rewardTo);
1084         }
1085 
1086         // swapExactETHForTokens
1087         pairs[1] = pairFor(factory, tokenOut);
1088         assert(IWETH(WETH).transfer(pairs[1], _amountOut)); // swap with all amountOut in last swap
1089         (, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXV2Pair(pairs[1]).swapWithExact{value: oracleFeeChange}(tokenOut, to);
1090         require(_amountOut >= amountOutMin, "CRouter: got less than expected");
1091 
1092         // distribute trading rewards - CoFi!
1093         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
1094             ICoFiXV2VaultForTrader(vaultForTrader).distributeReward(pairs[1], tradeInfo[1], tradeInfo[2], rewardTo);
1095         }
1096 
1097         // refund oracle fee to msg.sender, if any
1098         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
1099     }
1100 
1101     // msg.value = oracle fee
1102     function swapExactTokensForETH(
1103         address token,
1104         uint amountIn,
1105         uint amountOutMin,
1106         address to,
1107         address rewardTo,
1108         uint deadline
1109     ) external override payable ensure(deadline) returns (uint _amountIn, uint _amountOut)
1110     {
1111         require(msg.value > 0, "CRouter: insufficient msg.value");
1112         address pair = pairFor(factory, token);
1113         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountIn);
1114         uint oracleFeeChange; 
1115         uint256[5] memory tradeInfo;
1116         (_amountIn, _amountOut, oracleFeeChange, tradeInfo) = ICoFiXV2Pair(pair).swapWithExact{value: msg.value}(WETH, address(this));
1117         require(_amountOut >= amountOutMin, "CRouter: got less than expected");
1118         IWETH(WETH).withdraw(_amountOut);
1119         TransferHelper.safeTransferETH(to, _amountOut);
1120 
1121         // distribute trading rewards - CoFi!
1122         address vaultForTrader = ICoFiXV2Factory(factory).getVaultForTrader();
1123         if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
1124             ICoFiXV2VaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[1], tradeInfo[2], rewardTo);
1125         }
1126 
1127         // refund oracle fee to msg.sender, if any
1128         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
1129     }
1130 
1131     function hybridSwapExactTokensForTokens(
1132         uint amountIn,
1133         uint amountOutMin,
1134         address[] calldata path,
1135         DEX_TYPE[] calldata dexes,
1136         address to,
1137         address rewardTo,
1138         uint deadline
1139     ) external override payable ensure(deadline) returns (uint[] memory amounts) {
1140         // fast check
1141         require(path.length >= 2, "CRouter: invalid path");
1142         require(dexes.length == path.length - 1, "CRouter: invalid dexes");
1143         _checkOracleFee(dexes, msg.value);
1144 
1145         // send amountIn to the first pair
1146         TransferHelper.safeTransferFrom(
1147             path[0], msg.sender,  getPairForDEX(path[0], path[1], dexes[0]), amountIn
1148         );
1149 
1150         // exec hybridSwap
1151         amounts = new uint[](path.length);
1152         amounts[0] = amountIn;
1153         _hybridSwap(path, dexes, amounts, to, rewardTo);
1154 
1155         // check amountOutMin in the last
1156         require(amounts[amounts.length - 1] >= amountOutMin, "CRouter: insufficient output amount ");
1157     }
1158 
1159     function hybridSwapExactETHForTokens(
1160         uint amountIn,
1161         uint amountOutMin,
1162         address[] calldata path,
1163         DEX_TYPE[] calldata dexes,
1164         address to,
1165         address rewardTo,
1166         uint deadline
1167     ) external override payable ensure(deadline) returns (uint[] memory amounts) {
1168         // fast check
1169         require(path.length >= 2 && path[0] == WETH, "CRouter: invalid path");
1170         require(dexes.length == path.length - 1, "CRouter: invalid dexes");
1171         _checkOracleFee(dexes, msg.value.sub(amountIn)); // would revert if msg.value is less than amountIn
1172 
1173         // convert ETH and send amountIn to the first pair
1174         IWETH(WETH).deposit{value: amountIn}();
1175         assert(IWETH(WETH).transfer(getPairForDEX(path[0], path[1], dexes[0]), amountIn));
1176 
1177         // exec hybridSwap
1178         amounts = new uint[](path.length);
1179         amounts[0] = amountIn;
1180         _hybridSwap(path, dexes, amounts, to, rewardTo);
1181 
1182         // check amountOutMin in the last
1183         require(amounts[amounts.length - 1] >= amountOutMin, "CRouter: insufficient output amount ");
1184     }
1185 
1186     function hybridSwapExactTokensForETH(
1187         uint amountIn,
1188         uint amountOutMin,
1189         address[] calldata path,
1190         DEX_TYPE[] calldata dexes,
1191         address to,
1192         address rewardTo,
1193         uint deadline
1194     ) external override payable ensure(deadline) returns (uint[] memory amounts) {
1195         // fast check
1196         require(path.length >= 2 && path[path.length - 1] == WETH, "CRouter: invalid path");
1197         require(dexes.length == path.length - 1, "CRouter: invalid dexes");
1198         _checkOracleFee(dexes, msg.value);
1199 
1200         // send amountIn to the first pair
1201         TransferHelper.safeTransferFrom(
1202             path[0], msg.sender, getPairForDEX(path[0], path[1], dexes[0]), amountIn
1203         );
1204 
1205         // exec hybridSwap
1206         amounts = new uint[](path.length);
1207         amounts[0] = amountIn;
1208         _hybridSwap(path, dexes, amounts, address(this), rewardTo);
1209 
1210         // check amountOutMin in the last
1211         require(amounts[amounts.length - 1] >= amountOutMin, "CRouter: insufficient output amount ");
1212 
1213         // convert WETH
1214         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1215         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1216     }
1217 
1218 
1219     function _checkOracleFee(DEX_TYPE[] memory dexes, uint256 oracleFee) internal pure {
1220         uint cofixCnt;
1221         for (uint i; i < dexes.length; i++) {
1222             if (dexes[i] == DEX_TYPE.COFIX) {
1223                 cofixCnt++;
1224             }
1225         }
1226         // strict check here
1227         // to simplify the verify logic for oracle fee and prevent user from locking oracle fee by mistake
1228         // if NEST_ORACLE_FEE value changed, this router would not work as expected
1229         // TODO: refund the oracle fee?
1230         require(oracleFee == NEST_ORACLE_FEE.mul(cofixCnt), "CRouter: wrong oracle fee");
1231     }
1232 
1233     function _hybridSwap(address[] memory path, DEX_TYPE[] memory dexes, uint[] memory amounts, address _to, address rewardTo) internal {
1234         for (uint i; i < path.length - 1; i++) {
1235             if (dexes[i] == DEX_TYPE.COFIX) {
1236                 _swapOnCoFiX(i, path, dexes, amounts, _to, rewardTo);
1237             } else if (dexes[i] == DEX_TYPE.UNISWAP) {
1238                 _swapOnUniswap(i, path, dexes, amounts, _to);
1239             } else {
1240                 revert("CRouter: unknown dex");
1241             }
1242         }
1243     }
1244 
1245     function _swapOnUniswap(uint i, address[] memory path, DEX_TYPE[] memory dexes, uint[] memory amounts, address _to) internal {
1246         address pair = getPairForDEX(path[i], path[i + 1], DEX_TYPE.UNISWAP);
1247 
1248         (address token0,) = UniswapV2Library.sortTokens(path[i], path[i + 1]);
1249         {
1250             (uint reserveIn, uint reserveOut) = UniswapV2Library.getReserves(uniFactory, path[i], path[i + 1]);
1251             amounts[i + 1] = UniswapV2Library.getAmountOut(amounts[i], reserveIn, reserveOut);
1252         }
1253         uint amountOut = amounts[i + 1];
1254         (uint amount0Out, uint amount1Out) = path[i] == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
1255 
1256         address to;
1257         {
1258             if (i < path.length - 2) {
1259                 to = getPairForDEX(path[i + 1], path[i + 2], dexes[i + 1]);
1260             } else {
1261                 to = _to;
1262             }
1263         }
1264 
1265         IUniswapV2Pair(pair).swap(
1266             amount0Out, amount1Out, to, new bytes(0)
1267         );
1268     }
1269     
1270     function _swapOnCoFiX(uint i, address[] memory path, DEX_TYPE[] memory dexes, uint[] memory amounts, address _to, address rewardTo) internal {
1271             address pair = getPairForDEX(path[i], path[i + 1], DEX_TYPE.COFIX);
1272             address to;
1273             if (i < path.length - 2) {
1274                 to = getPairForDEX(path[i + 1], path[i + 2], dexes[i + 1]);
1275             } else {
1276                 to = _to;
1277             }
1278             // TODO: dynamic oracle fee
1279             {
1280                 uint256[5] memory tradeInfo;
1281                 (,amounts[i+1],,tradeInfo) = ICoFiXV2Pair(pair).swapWithExact{value: NEST_ORACLE_FEE}(path[i + 1], to);
1282 
1283                 // distribute trading rewards - CoFi!
1284                 address vaultForTrader = ICoFiXV2Factory(factory).getVaultForTrader();
1285                 if (tradeInfo[0] > 0 && rewardTo != address(0) && vaultForTrader != address(0)) {
1286                     ICoFiXV2VaultForTrader(vaultForTrader).distributeReward(pair, tradeInfo[1], tradeInfo[2], rewardTo);
1287                 }
1288             }
1289     } 
1290 
1291     function isCoFiXNativeSupported(address input, address output) public view returns (bool supported, address pair) {
1292         // NO WETH included
1293         if (input != WETH && output != WETH)
1294             return (false, pair);
1295         if (input != WETH) {
1296             pair = pairFor(factory, input);
1297         } else if (output != WETH) {
1298             pair = pairFor(factory, output);
1299         }
1300         // if tokenIn & tokenOut are both WETH, then the pair is zero
1301         if (pair != address(0)) // TODO: add check for reserves
1302             supported = true;
1303         return (supported, pair);
1304     }
1305 
1306     function getPairForDEX(address input, address output, DEX_TYPE dex) public view returns (address pair) {
1307         if (dex == DEX_TYPE.COFIX) {
1308             bool supported;
1309             (supported, pair) = isCoFiXNativeSupported(input, output);
1310             if (!supported) {
1311                 revert("CRouter: not available on CoFiX");
1312             }
1313         } else if (dex == DEX_TYPE.UNISWAP) {
1314             pair = UniswapV2Library.pairFor(uniFactory, input, output);
1315         } else {
1316             revert("CRouter: unknown dex");
1317         }
1318     }
1319 
1320     // TODO: not used currently
1321     function hybridPair(address input, address output) public view returns (bool useCoFiX, address pair) {
1322         (useCoFiX, pair) = isCoFiXNativeSupported(input, output);
1323         if (useCoFiX) {
1324             return (useCoFiX, pair);
1325         }
1326         return (false, UniswapV2Library.pairFor(uniFactory, input, output));
1327     }
1328 }