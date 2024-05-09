1 pragma solidity ^0.7.0;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 // File: browser/IUnipumpDrain.sol
78 
79 
80 
81 
82 interface IUnipumpDrain
83 {
84     function drain(address token) external;
85 }
86 
87 // File: browser/openzeppelin/Context.sol
88 
89 
90 
91 
92 
93 abstract contract UnipumpErc20Helper
94 {
95     function transferMax(address token, address from, address to) 
96         internal
97         returns (uint256 amountTransferred)
98     {
99         uint256 balance = IERC20(token).balanceOf(from);
100         if (balance == 0) { return 0; }
101         uint256 allowed = IERC20(token).allowance(from, to);
102         amountTransferred = allowed > balance ? balance : allowed;
103         if (amountTransferred == 0) { return 0; }
104         require (IERC20(token).transferFrom(from, to, amountTransferred), "Transfer failed");
105     }
106 }
107 // File: browser/IUnipumpContest.sol
108 
109 
110 
111 
112 interface IUnipumpContest
113 {
114 }
115 // File: browser/IUnipump.sol
116 
117 
118 
119 
120 
121 
122 
123 
124 
125 interface IUnipump is IERC20 {
126     event Sale(bool indexed _saleActive);
127     event LiquidityCrisis();
128 
129     function WETH() external view returns (address);
130     
131     function groupManager() external view returns (IUnipumpGroupManager);
132     function escrow() external view returns (IUnipumpEscrow);
133     function staking() external view returns (IUnipumpStaking);
134     function contest() external view returns (IUnipumpContest);
135 
136     function init(
137         IUnipumpEscrow _escrow,
138         IUnipumpStaking _staking) external;
139     function startUnipumpSale(uint256 _tokensPerEth, uint256 _maxSoldEth) external;
140     function start(
141         IUnipumpGroupManager _groupManager,
142         IUnipumpContest _contest) external;
143 
144     function isSaleActive() external view returns (bool);
145     function tokensPerEth() external view returns (uint256);
146     function maxSoldEth() external view returns (uint256);
147     function soldEth() external view returns (uint256);
148     
149     function buy() external payable;
150     
151     function minSecondsUntilLiquidityCrisis() external view returns (uint256);
152     function createLiquidityCrisis() external payable;
153 }
154 // File: browser/UnipumpDrain.sol
155 
156 
157 
158 
159 
160 
161 
162 abstract contract UnipumpDrain is IUnipumpDrain
163 {
164     address payable immutable drainTarget;
165 
166     constructor()
167     {
168         drainTarget = msg.sender;
169     }
170 
171     function drain(address token)
172         public
173         override
174     {
175         uint256 amount;
176         if (token == address(0))
177         {
178             require (address(this).balance > 0, "Nothing to send");
179             amount = _drainAmount(token, address(this).balance);
180             require (amount > 0, "Nothing allowed to send");
181             (bool success,) = drainTarget.call{ value: amount }("");
182             require (success, "Transfer failed");
183             return;
184         }
185         amount = IERC20(token).balanceOf(address(this));
186         require (amount > 0, "Nothing to send");
187         amount = _drainAmount(token, amount);
188         require (amount > 0, "Nothing allowed to send");
189         require (IERC20(token).transfer(drainTarget, amount), "Transfer failed");
190     }
191 
192     function _drainAmount(address token, uint256 available) internal virtual returns (uint256 amount);
193 }
194 // File: browser/IUnipumpStaking.sol
195 
196 
197 
198 
199 interface IUnipumpStaking
200 {
201     event Stake(address indexed _staker, uint256 _amount, uint256 _epochCount);
202     event Reward(address indexed _staker, uint256 _reward);
203     event RewardPotIncrease(uint256 _amount);
204 
205     function stakingRewardPot() external view returns (uint256);
206     function currentEpoch() external view returns (uint256);
207     function nextEpochTimestamp() external view returns (uint256);
208     function isActivated() external view returns (bool);
209     function secondsUntilCanActivate() external view returns (uint256);
210     function totalStaked() external view returns (uint256);
211     
212     function increaseRewardsPot() external;
213     function activate() external;
214     function claimRewardsAt(uint256 index) external;
215     function claimRewards() external;
216     function updateEpoch() external returns (bool);
217     function stakeForProfit(uint256 epochCount) external;
218 }
219 // File: browser/IUnipumpEscrow.sol
220 
221 
222 
223 
224 
225 interface IUnipumpEscrow is IUnipumpDrain
226 {
227     function start() external;
228     function available() external view returns (uint256);
229 }
230 // File: browser/IUnipumpTradingGroup.sol
231 
232 
233 
234 
235 
236 
237 interface IUnipumpTradingGroup
238 {
239     function leader() external view returns (address);
240     function close() external;
241     function closeWithNonzeroTokenBalances() external;
242     function anyNonzeroTokenBalances() external view returns (bool);
243     function tokenList() external view returns (IUnipumpTokenList);
244     function maxSecondsRemaining() external view returns (uint256);
245     function group() external view returns (IUnipumpGroup);
246     function externalBalanceChanges(address token) external view returns (bool);
247 
248     function startTime() external view returns (uint256);
249     function endTime() external view returns (uint256);
250     function maxEndTime() external view returns (uint256);
251 
252     function startingWethBalance() external view returns (uint256);
253     function finalWethBalance() external view returns (uint256);
254     function leaderWethProfitPayout() external view returns (uint256);
255 
256     function swapExactTokensForTokens(
257         uint256 amountIn,
258         uint256 amountOutMin,
259         address[] calldata path,
260         uint256 deadline
261     ) 
262         external 
263         returns (uint256[] memory amounts);
264 
265     function swapTokensForExactTokens(
266         uint256 amountOut,
267         uint256 amountInMax,
268         address[] calldata path,
269         uint256 deadline
270     ) 
271         external 
272         returns (uint256[] memory amounts);
273         
274     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
275         uint256 amountIn,
276         uint256 amountOutMin,
277         address[] calldata path,
278         uint256 deadline
279     ) 
280         external;
281 
282     function withdraw(address token) external;
283 }
284 // File: browser/IUnipumpTokenList.sol
285 
286 
287 
288 
289 interface IUnipumpTokenList
290 {
291     function parentList() external view returns (IUnipumpTokenList);
292     function isLocked() external view returns (bool);
293     function tokens(uint256 index) external view returns (address);
294     function exists(address token) external view returns (bool);
295     function tokenCount() external view returns (uint256);
296 
297     function lock() external;
298     function add(address token) external;
299     function addMany(address[] calldata _tokens) external;
300     function remove(address token) external;    
301 }
302 // File: browser/IUnipumpGroup.sol
303 
304 
305 
306 
307 
308 
309 interface IUnipumpGroup 
310 {
311     function contribute() external payable;
312     function abort() external;
313     function startPumping() external;
314     function isActive() external view returns (bool);
315     function withdraw() external;
316     function leader() external view returns (address);
317     function tokenList() external view returns (IUnipumpTokenList);
318     function leaderUppCollateral() external view returns (uint256);
319     function requiredMemberUppFee() external view returns (uint256);
320     function minEthToJoin() external view returns (uint256);
321     function minEthToStart() external view returns (uint256);
322     function maxEthAcceptable() external view returns (uint256);
323     function maxRunTimeSeconds() external view returns (uint256);
324     function leaderProfitShareOutOf10000() external view returns (uint256);
325     function memberCount() external view returns (uint256);
326     function members(uint256 at) external view returns (address);
327     function contributions(address member) external view returns (uint256);
328     function totalContributions() external view returns (uint256);
329     function aborted() external view returns (bool);
330     function tradingGroup() external view returns (IUnipumpTradingGroup);
331 }
332 // File: browser/IUnipumpGroupFactory.sol
333 
334 
335 
336 
337 
338 
339 interface IUnipumpGroupFactory 
340 {
341     function createGroup(
342         address leader,
343         IUnipumpTokenList unipumpTokenList,
344         uint256 uppCollateral,
345         uint256 requiredMemberUppFee,
346         uint256 minEthToJoin,
347         uint256 minEthToStart,
348         uint256 startTimeout,
349         uint256 maxEthAcceptable,
350         uint256 maxRunTimeSeconds,
351         uint256 leaderProfitShareOutOf10000
352     ) 
353         external
354         returns (IUnipumpGroup unipumpGroup);
355 }
356 // File: browser/IUnipumpGroupManager.sol
357 
358 
359 
360 
361 
362 
363 
364 interface IUnipumpGroupManager
365 {
366     function groupLeaders(uint256 at) external view returns (address);
367     function groupLeaderCount() external view returns (uint256);
368     function groups(uint256 at) external view returns (IUnipumpGroup);
369     function groupCount() external view returns (uint256);
370     function groupCountByLeader(address leader) external view returns (uint256);
371     function groupsByLeader(address leader, uint256 at) external view returns (IUnipumpGroup);
372 
373     function createGroup(
374         IUnipumpTokenList tokenList,
375         uint256 uppCollateral,
376         uint256 requiredMemberUppFee,
377         uint256 minEthToJoin,
378         uint256 minEthToStart,
379         uint256 startTimeout,
380         uint256 maxEthAcceptable,
381         uint256 maxRunTimeSeconds,
382         uint256 leaderProfitShareOutOf10000
383     ) 
384         external
385         returns (IUnipumpGroup group);
386 }
387 // File: browser/uniswap/IWETH.sol
388 
389 pragma solidity >=0.5.0;
390 
391 
392 interface IWETH {
393     function deposit() external payable;
394     function transfer(address to, uint value) external returns (bool);
395     function withdraw(uint) external;
396 }
397 
398 // File: browser/uniswap/IUniswapV2Router01.sol
399 
400 pragma solidity >=0.6.2;
401 
402 
403 interface IUniswapV2Router01 {
404     function factory() external pure returns (address);
405     function WETH() external pure returns (address);
406 
407     function addLiquidity(
408         address tokenA,
409         address tokenB,
410         uint amountADesired,
411         uint amountBDesired,
412         uint amountAMin,
413         uint amountBMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountA, uint amountB, uint liquidity);
417     function addLiquidityETH(
418         address token,
419         uint amountTokenDesired,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline
424     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
425     function removeLiquidity(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline
433     ) external returns (uint amountA, uint amountB);
434     function removeLiquidityETH(
435         address token,
436         uint liquidity,
437         uint amountTokenMin,
438         uint amountETHMin,
439         address to,
440         uint deadline
441     ) external returns (uint amountToken, uint amountETH);
442     function removeLiquidityWithPermit(
443         address tokenA,
444         address tokenB,
445         uint liquidity,
446         uint amountAMin,
447         uint amountBMin,
448         address to,
449         uint deadline,
450         bool approveMax, uint8 v, bytes32 r, bytes32 s
451     ) external returns (uint amountA, uint amountB);
452     function removeLiquidityETHWithPermit(
453         address token,
454         uint liquidity,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline,
459         bool approveMax, uint8 v, bytes32 r, bytes32 s
460     ) external returns (uint amountToken, uint amountETH);
461     function swapExactTokensForTokens(
462         uint amountIn,
463         uint amountOutMin,
464         address[] calldata path,
465         address to,
466         uint deadline
467     ) external returns (uint[] memory amounts);
468     function swapTokensForExactTokens(
469         uint amountOut,
470         uint amountInMax,
471         address[] calldata path,
472         address to,
473         uint deadline
474     ) external returns (uint[] memory amounts);
475     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
476         external
477         payable
478         returns (uint[] memory amounts);
479     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
480         external
481         returns (uint[] memory amounts);
482     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
483         external
484         returns (uint[] memory amounts);
485     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
486         external
487         payable
488         returns (uint[] memory amounts);
489 
490     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
491     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
492     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
493     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
494     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
495 }
496 
497 // File: browser/uniswap/IUniswapV2Router02.sol
498 
499 pragma solidity >=0.6.2;
500 
501 
502 
503 interface IUniswapV2Router02 is IUniswapV2Router01 {
504     function removeLiquidityETHSupportingFeeOnTransferTokens(
505         address token,
506         uint liquidity,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline
511     ) external returns (uint amountETH);
512     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
513         address token,
514         uint liquidity,
515         uint amountTokenMin,
516         uint amountETHMin,
517         address to,
518         uint deadline,
519         bool approveMax, uint8 v, bytes32 r, bytes32 s
520     ) external returns (uint amountETH);
521 
522     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external;
529     function swapExactETHForTokensSupportingFeeOnTransferTokens(
530         uint amountOutMin,
531         address[] calldata path,
532         address to,
533         uint deadline
534     ) external payable;
535     function swapExactTokensForETHSupportingFeeOnTransferTokens(
536         uint amountIn,
537         uint amountOutMin,
538         address[] calldata path,
539         address to,
540         uint deadline
541     ) external;
542 }
543 
544 // File: browser/uniswap/IUniswapV2Pair.sol
545 
546 pragma solidity >=0.5.0;
547 
548 
549 interface IUniswapV2Pair {
550     event Approval(address indexed owner, address indexed spender, uint value);
551     event Transfer(address indexed from, address indexed to, uint value);
552 
553     function name() external pure returns (string memory);
554     function symbol() external pure returns (string memory);
555     function decimals() external pure returns (uint8);
556     function totalSupply() external view returns (uint);
557     function balanceOf(address owner) external view returns (uint);
558     function allowance(address owner, address spender) external view returns (uint);
559 
560     function approve(address spender, uint value) external returns (bool);
561     function transfer(address to, uint value) external returns (bool);
562     function transferFrom(address from, address to, uint value) external returns (bool);
563 
564     function DOMAIN_SEPARATOR() external view returns (bytes32);
565     function PERMIT_TYPEHASH() external pure returns (bytes32);
566     function nonces(address owner) external view returns (uint);
567 
568     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
569 
570     event Mint(address indexed sender, uint amount0, uint amount1);
571     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
572     event Swap(
573         address indexed sender,
574         uint amount0In,
575         uint amount1In,
576         uint amount0Out,
577         uint amount1Out,
578         address indexed to
579     );
580     event Sync(uint112 reserve0, uint112 reserve1);
581 
582     function MINIMUM_LIQUIDITY() external pure returns (uint);
583     function factory() external view returns (address);
584     function token0() external view returns (address);
585     function token1() external view returns (address);
586     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
587     function price0CumulativeLast() external view returns (uint);
588     function price1CumulativeLast() external view returns (uint);
589     function kLast() external view returns (uint);
590 
591     function mint(address to) external returns (uint liquidity);
592     function burn(address to) external returns (uint amount0, uint amount1);
593     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
594     function skim(address to) external;
595     function sync() external;
596 
597     function initialize(address, address) external;
598 }
599 
600 // File: browser/uniswap/IUniswapV2Factory.sol
601 
602 pragma solidity >=0.5.0;
603 
604 
605 interface IUniswapV2Factory {
606     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
607 
608     function feeTo() external view returns (address);
609     function feeToSetter() external view returns (address);
610 
611     function getPair(address tokenA, address tokenB) external view returns (address pair);
612     function allPairs(uint) external view returns (address pair);
613     function allPairsLength() external view returns (uint);
614 
615     function createPair(address tokenA, address tokenB) external returns (address pair);
616 
617     function setFeeTo(address) external;
618     function setFeeToSetter(address) external;
619 }
620 
621 // File: browser/openzeppelin/Address.sol
622 
623 
624 
625 
626 
627 /**
628  * @dev Collection of functions related to the address type
629  */
630 library Address {
631     /**
632      * @dev Returns true if `account` is a contract.
633      *
634      * [IMPORTANT]
635      * ====
636      * It is unsafe to assume that an address for which this function returns
637      * false is an externally-owned account (EOA) and not a contract.
638      *
639      * Among others, `isContract` will return false for the following
640      * types of addresses:
641      *
642      *  - an externally-owned account
643      *  - a contract in construction
644      *  - an address where a contract will be created
645      *  - an address where a contract lived, but was destroyed
646      * ====
647      */
648     function isContract(address account) internal view returns (bool) {
649         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
650         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
651         // for accounts without code, i.e. `keccak256('')`
652         bytes32 codehash;
653         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
654         // solhint-disable-next-line no-inline-assembly
655         assembly { codehash := extcodehash(account) }
656         return (codehash != accountHash && codehash != 0x0);
657     }
658 
659     /**
660      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
661      * `recipient`, forwarding all available gas and reverting on errors.
662      *
663      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
664      * of certain opcodes, possibly making contracts go over the 2300 gas limit
665      * imposed by `transfer`, making them unable to receive funds via
666      * `transfer`. {sendValue} removes this limitation.
667      *
668      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
669      *
670      * IMPORTANT: because control is transferred to `recipient`, care must be
671      * taken to not create reentrancy vulnerabilities. Consider using
672      * {ReentrancyGuard} or the
673      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
674      */
675     function sendValue(address payable recipient, uint256 amount) internal {
676         require(address(this).balance >= amount, "Address: insufficient balance");
677 
678         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
679         (bool success, ) = recipient.call{ value: amount }("");
680         require(success, "Address: unable to send value, recipient may have reverted");
681     }
682 
683     /**
684      * @dev Performs a Solidity function call using a low level `call`. A
685      * plain`call` is an unsafe replacement for a function call: use this
686      * function instead.
687      *
688      * If `target` reverts with a revert reason, it is bubbled up by this
689      * function (like regular Solidity function calls).
690      *
691      * Returns the raw returned data. To convert to the expected return value,
692      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
693      *
694      * Requirements:
695      *
696      * - `target` must be a contract.
697      * - calling `target` with `data` must not revert.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
702       return functionCall(target, data, "Address: low-level call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
707      * `errorMessage` as a fallback revert reason when `target` reverts.
708      *
709      * _Available since v3.1._
710      */
711     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
712         return _functionCallWithValue(target, data, 0, errorMessage);
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
717      * but also transferring `value` wei to `target`.
718      *
719      * Requirements:
720      *
721      * - the calling contract must have an ETH balance of at least `value`.
722      * - the called Solidity function must be `payable`.
723      *
724      * _Available since v3.1._
725      */
726     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
727         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
732      * with `errorMessage` as a fallback revert reason when `target` reverts.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
737         require(address(this).balance >= value, "Address: insufficient balance for call");
738         return _functionCallWithValue(target, data, value, errorMessage);
739     }
740 
741     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
742         require(isContract(target), "Address: call to non-contract");
743 
744         // solhint-disable-next-line avoid-low-level-calls
745         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
746         if (success) {
747             return returndata;
748         } else {
749             // Look for revert reason and bubble it up if present
750             if (returndata.length > 0) {
751                 // The easiest way to bubble the revert reason is using memory via assembly
752 
753                 // solhint-disable-next-line no-inline-assembly
754                 assembly {
755                     let returndata_size := mload(returndata)
756                     revert(add(32, returndata), returndata_size)
757                 }
758             } else {
759                 revert(errorMessage);
760             }
761         }
762     }
763 }
764 
765 // File: browser/openzeppelin/SafeMath.sol
766 
767 
768 
769 
770 
771 /**
772  * @dev Wrappers over Solidity's arithmetic operations with added overflow
773  * checks.
774  *
775  * Arithmetic operations in Solidity wrap on overflow. This can easily result
776  * in bugs, because programmers usually assume that an overflow raises an
777  * error, which is the standard behavior in high level programming languages.
778  * `SafeMath` restores this intuition by reverting the transaction when an
779  * operation overflows.
780  *
781  * Using this library instead of the unchecked operations eliminates an entire
782  * class of bugs, so it's recommended to use it always.
783  */
784 library SafeMath {
785     /**
786      * @dev Returns the addition of two unsigned integers, reverting on
787      * overflow.
788      *
789      * Counterpart to Solidity's `+` operator.
790      *
791      * Requirements:
792      *
793      * - Addition cannot overflow.
794      */
795     function add(uint256 a, uint256 b) internal pure returns (uint256) {
796         uint256 c = a + b;
797         require(c >= a, "SafeMath: addition overflow");
798 
799         return c;
800     }
801 
802     /**
803      * @dev Returns the subtraction of two unsigned integers, reverting on
804      * overflow (when the result is negative).
805      *
806      * Counterpart to Solidity's `-` operator.
807      *
808      * Requirements:
809      *
810      * - Subtraction cannot overflow.
811      */
812     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
813         return sub(a, b, "SafeMath: subtraction overflow");
814     }
815 
816     /**
817      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
818      * overflow (when the result is negative).
819      *
820      * Counterpart to Solidity's `-` operator.
821      *
822      * Requirements:
823      *
824      * - Subtraction cannot overflow.
825      */
826     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
827         require(b <= a, errorMessage);
828         uint256 c = a - b;
829 
830         return c;
831     }
832 
833     /**
834      * @dev Returns the multiplication of two unsigned integers, reverting on
835      * overflow.
836      *
837      * Counterpart to Solidity's `*` operator.
838      *
839      * Requirements:
840      *
841      * - Multiplication cannot overflow.
842      */
843     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
844         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
845         // benefit is lost if 'b' is also tested.
846         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
847         if (a == 0) {
848             return 0;
849         }
850 
851         uint256 c = a * b;
852         require(c / a == b, "SafeMath: multiplication overflow");
853 
854         return c;
855     }
856 
857     /**
858      * @dev Returns the integer division of two unsigned integers. Reverts on
859      * division by zero. The result is rounded towards zero.
860      *
861      * Counterpart to Solidity's `/` operator. Note: this function uses a
862      * `revert` opcode (which leaves remaining gas untouched) while Solidity
863      * uses an invalid opcode to revert (consuming all remaining gas).
864      *
865      * Requirements:
866      *
867      * - The divisor cannot be zero.
868      */
869     function div(uint256 a, uint256 b) internal pure returns (uint256) {
870         return div(a, b, "SafeMath: division by zero");
871     }
872 
873     /**
874      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
875      * division by zero. The result is rounded towards zero.
876      *
877      * Counterpart to Solidity's `/` operator. Note: this function uses a
878      * `revert` opcode (which leaves remaining gas untouched) while Solidity
879      * uses an invalid opcode to revert (consuming all remaining gas).
880      *
881      * Requirements:
882      *
883      * - The divisor cannot be zero.
884      */
885     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
886         require(b > 0, errorMessage);
887         uint256 c = a / b;
888         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
889 
890         return c;
891     }
892 
893     /**
894      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
895      * Reverts when dividing by zero.
896      *
897      * Counterpart to Solidity's `%` operator. This function uses a `revert`
898      * opcode (which leaves remaining gas untouched) while Solidity uses an
899      * invalid opcode to revert (consuming all remaining gas).
900      *
901      * Requirements:
902      *
903      * - The divisor cannot be zero.
904      */
905     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
906         return mod(a, b, "SafeMath: modulo by zero");
907     }
908 
909     /**
910      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
911      * Reverts with custom message when dividing by zero.
912      *
913      * Counterpart to Solidity's `%` operator. This function uses a `revert`
914      * opcode (which leaves remaining gas untouched) while Solidity uses an
915      * invalid opcode to revert (consuming all remaining gas).
916      *
917      * Requirements:
918      *
919      * - The divisor cannot be zero.
920      */
921     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
922         require(b != 0, errorMessage);
923         return a % b;
924     }
925 }
926 
927 // File: browser/openzeppelin/IERC20.sol
928 
929 
930 
931 
932 
933 
934 
935 /*
936  * @dev Provides information about the current execution context, including the
937  * sender of the transaction and its data. While these are generally available
938  * via msg.sender and msg.data, they should not be accessed in such a direct
939  * manner, since when dealing with GSN meta-transactions the account sending and
940  * paying for execution may not be the actual sender (as far as an application
941  * is concerned).
942  *
943  * This contract is only required for intermediate, library-like contracts.
944  */
945 abstract contract Context {
946     function _msgSender() internal view virtual returns (address payable) {
947         return msg.sender;
948     }
949 
950     function _msgData() internal view virtual returns (bytes memory) {
951         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
952         return msg.data;
953     }
954 }
955 
956 // File: browser/openzeppelin/ERC20.sol
957 
958 
959 
960 
961 
962 
963 
964 
965 
966 /**
967  * @dev Implementation of the {IERC20} interface.
968  *
969  * This implementation is agnostic to the way tokens are created. This means
970  * that a supply mechanism has to be added in a derived contract using {_mint}.
971  * For a generic mechanism see {ERC20PresetMinterPauser}.
972  *
973  * TIP: For a detailed writeup see our guide
974  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
975  * to implement supply mechanisms].
976  *
977  * We have followed general OpenZeppelin guidelines: functions revert instead
978  * of returning `false` on failure. This behavior is nonetheless conventional
979  * and does not conflict with the expectations of ERC20 applications.
980  *
981  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
982  * This allows applications to reconstruct the allowance for all accounts just
983  * by listening to said events. Other implementations of the EIP may not emit
984  * these events, as it isn't required by the specification.
985  *
986  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
987  * functions have been added to mitigate the well-known issues around setting
988  * allowances. See {IERC20-approve}.
989  */
990 contract ERC20 is Context, IERC20 {
991     using SafeMath for uint256;
992     using Address for address;
993 
994     mapping (address => uint256) private _balances;
995 
996     mapping (address => mapping (address => uint256)) private _allowances;
997 
998     uint256 private _totalSupply;
999 
1000     string private _name;
1001     string private _symbol;
1002     uint8 private _decimals;
1003 
1004     /**
1005      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1006      * a default value of 18.
1007      *
1008      * To select a different value for {decimals}, use {_setupDecimals}.
1009      *
1010      * All three of these values are immutable: they can only be set once during
1011      * construction.
1012      */
1013     constructor (string memory name, string memory symbol) {
1014         _name = name;
1015         _symbol = symbol;
1016         _decimals = 18;
1017     }
1018 
1019     /**
1020      * @dev Returns the name of the token.
1021      */
1022     function name() public view returns (string memory) {
1023         return _name;
1024     }
1025 
1026     /**
1027      * @dev Returns the symbol of the token, usually a shorter version of the
1028      * name.
1029      */
1030     function symbol() public view returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     /**
1035      * @dev Returns the number of decimals used to get its user representation.
1036      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1037      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1038      *
1039      * Tokens usually opt for a value of 18, imitating the relationship between
1040      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1041      * called.
1042      *
1043      * NOTE: This information is only used for _display_ purposes: it in
1044      * no way affects any of the arithmetic of the contract, including
1045      * {IERC20-balanceOf} and {IERC20-transfer}.
1046      */
1047     function decimals() public view returns (uint8) {
1048         return _decimals;
1049     }
1050 
1051     /**
1052      * @dev See {IERC20-totalSupply}.
1053      */
1054     function totalSupply() public view override returns (uint256) {
1055         return _totalSupply;
1056     }
1057 
1058     /**
1059      * @dev See {IERC20-balanceOf}.
1060      */
1061     function balanceOf(address account) public view override returns (uint256) {
1062         return _balances[account];
1063     }
1064 
1065     /**
1066      * @dev See {IERC20-transfer}.
1067      *
1068      * Requirements:
1069      *
1070      * - `recipient` cannot be the zero address.
1071      * - the caller must have a balance of at least `amount`.
1072      */
1073     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1074         _transfer(_msgSender(), recipient, amount);
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev See {IERC20-allowance}.
1080      */
1081     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1082         return _allowances[owner][spender];
1083     }
1084 
1085     /**
1086      * @dev See {IERC20-approve}.
1087      *
1088      * Requirements:
1089      *
1090      * - `spender` cannot be the zero address.
1091      */
1092     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1093         _approve(_msgSender(), spender, amount);
1094         return true;
1095     }
1096 
1097     /**
1098      * @dev See {IERC20-transferFrom}.
1099      *
1100      * Emits an {Approval} event indicating the updated allowance. This is not
1101      * required by the EIP. See the note at the beginning of {ERC20};
1102      *
1103      * Requirements:
1104      * - `sender` and `recipient` cannot be the zero address.
1105      * - `sender` must have a balance of at least `amount`.
1106      * - the caller must have allowance for ``sender``'s tokens of at least
1107      * `amount`.
1108      */
1109     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1110         _transfer(sender, recipient, amount);
1111         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1112         return true;
1113     }
1114 
1115     /**
1116      * @dev Atomically increases the allowance granted to `spender` by the caller.
1117      *
1118      * This is an alternative to {approve} that can be used as a mitigation for
1119      * problems described in {IERC20-approve}.
1120      *
1121      * Emits an {Approval} event indicating the updated allowance.
1122      *
1123      * Requirements:
1124      *
1125      * - `spender` cannot be the zero address.
1126      */
1127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1128         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1129         return true;
1130     }
1131 
1132     /**
1133      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1134      *
1135      * This is an alternative to {approve} that can be used as a mitigation for
1136      * problems described in {IERC20-approve}.
1137      *
1138      * Emits an {Approval} event indicating the updated allowance.
1139      *
1140      * Requirements:
1141      *
1142      * - `spender` cannot be the zero address.
1143      * - `spender` must have allowance for the caller of at least
1144      * `subtractedValue`.
1145      */
1146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1148         return true;
1149     }
1150 
1151     /**
1152      * @dev Moves tokens `amount` from `sender` to `recipient`.
1153      *
1154      * This is internal function is equivalent to {transfer}, and can be used to
1155      * e.g. implement automatic token fees, slashing mechanisms, etc.
1156      *
1157      * Emits a {Transfer} event.
1158      *
1159      * Requirements:
1160      *
1161      * - `sender` cannot be the zero address.
1162      * - `recipient` cannot be the zero address.
1163      * - `sender` must have a balance of at least `amount`.
1164      */
1165     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1166         require(sender != address(0), "ERC20: transfer from the zero address");
1167         require(recipient != address(0), "ERC20: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(sender, recipient, amount);
1170 
1171         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1172         _balances[recipient] = _balances[recipient].add(amount);
1173         emit Transfer(sender, recipient, amount);
1174     }
1175 
1176     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1177      * the total supply.
1178      *
1179      * Emits a {Transfer} event with `from` set to the zero address.
1180      *
1181      * Requirements
1182      *
1183      * - `to` cannot be the zero address.
1184      */
1185     function _mint(address account, uint256 amount) internal virtual {
1186         require(account != address(0), "ERC20: mint to the zero address");
1187 
1188         _beforeTokenTransfer(address(0), account, amount);
1189 
1190         _totalSupply = _totalSupply.add(amount);
1191         _balances[account] = _balances[account].add(amount);
1192         emit Transfer(address(0), account, amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, reducing the
1197      * total supply.
1198      *
1199      * Emits a {Transfer} event with `to` set to the zero address.
1200      *
1201      * Requirements
1202      *
1203      * - `account` cannot be the zero address.
1204      * - `account` must have at least `amount` tokens.
1205      */
1206     function _burn(address account, uint256 amount) internal virtual {
1207         require(account != address(0), "ERC20: burn from the zero address");
1208 
1209         _beforeTokenTransfer(account, address(0), amount);
1210 
1211         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1212         _totalSupply = _totalSupply.sub(amount);
1213         emit Transfer(account, address(0), amount);
1214     }
1215 
1216     /**
1217      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1218      *
1219      * This is internal function is equivalent to `approve`, and can be used to
1220      * e.g. set automatic allowances for certain subsystems, etc.
1221      *
1222      * Emits an {Approval} event.
1223      *
1224      * Requirements:
1225      *
1226      * - `owner` cannot be the zero address.
1227      * - `spender` cannot be the zero address.
1228      */
1229     function _approve(address owner, address spender, uint256 amount) internal virtual {
1230         require(owner != address(0), "ERC20: approve from the zero address");
1231         require(spender != address(0), "ERC20: approve to the zero address");
1232 
1233         _allowances[owner][spender] = amount;
1234         emit Approval(owner, spender, amount);
1235     }
1236 
1237     /**
1238      * @dev Sets {decimals} to a value other than the default one of 18.
1239      *
1240      * WARNING: This function should only be called from the constructor. Most
1241      * applications that interact with token contracts will not expect
1242      * {decimals} to ever change, and may work incorrectly if it does.
1243      */
1244     function _setupDecimals(uint8 decimals_) internal {
1245         _decimals = decimals_;
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before any transfer of tokens. This includes
1250      * minting and burning.
1251      *
1252      * Calling conditions:
1253      *
1254      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1255      * will be to transferred to `to`.
1256      * - when `from` is zero, `amount` tokens will be minted for `to`.
1257      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1258      * - `from` and `to` are never both zero.
1259      *
1260      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1261      */
1262     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1263 }
1264 
1265 // File: browser/Unipump.sol
1266 
1267 
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 contract Unipump is ERC20, UnipumpDrain, IUnipump, UnipumpErc20Helper
1284 {
1285     address payable immutable owner;
1286     IUniswapV2Factory immutable uniswapV2Factory;
1287     IUniswapV2Router02 immutable uniswapV2Router;
1288     address immutable public override WETH;
1289     
1290     IUniswapV2Pair public uniswapEthUppPair;
1291 
1292     IUnipumpGroupManager public override groupManager;
1293     IUnipumpEscrow public override escrow;
1294     IUnipumpStaking public override staking;
1295     IUnipumpContest public override contest;
1296 
1297     uint256 public override tokensPerEth;
1298     uint256 public override maxSoldEth;
1299     uint256 public override soldEth;
1300 
1301     uint256 initialLiquidityTokens;
1302     uint256 minLiquidityCrisisTime;
1303     
1304     constructor(
1305         IUniswapV2Factory _uniswapV2Factory,          // 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
1306         IUniswapV2Router02 _uniswapV2Router            // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1307     ) 
1308         ERC20("Unipump", "UPP") 
1309     {
1310         require (address(_uniswapV2Factory) != address(0));
1311         require (address(_uniswapV2Router) != address(0));
1312         owner = msg.sender;
1313 
1314         uniswapV2Factory = _uniswapV2Factory;
1315         uniswapV2Router = _uniswapV2Router;
1316 
1317         address weth = _uniswapV2Router.WETH();
1318         WETH = weth;
1319     }
1320 
1321     modifier ownerOnly() { require(msg.sender == owner, "Owner only"); _; }
1322 
1323     function init(
1324         IUnipumpEscrow _escrow,
1325         IUnipumpStaking _staking
1326     )
1327         public 
1328         override
1329         ownerOnly()
1330     {
1331         require (address(_escrow) != address(0));
1332         require (address(_staking) != address(0));
1333         if (address(uniswapEthUppPair) == address(0)) {
1334             uniswapEthUppPair = IUniswapV2Pair(uniswapV2Factory.createPair(WETH, address(this)));
1335         }
1336         else {
1337             require (address(this).balance == 0 && IERC20(WETH).balanceOf(address(this)) == 0, "Already initialized");
1338         }
1339         escrow = _escrow;
1340         staking = _staking;
1341     }
1342 
1343     function startUnipumpSale(uint256 _tokensPerEth, uint256 _maxSoldEth)
1344         public
1345         override
1346         ownerOnly()
1347     {
1348         require (address(groupManager) == address(0), "Operations have already begun");
1349         require (tokensPerEth == 0 || _tokensPerEth <= tokensPerEth, "The price can only be pumped higher");
1350         require (_tokensPerEth > 0 || _maxSoldEth == 0);
1351         soldEth = 0;
1352         maxSoldEth = _maxSoldEth;
1353         if (_tokensPerEth > 0) { tokensPerEth = _tokensPerEth; }
1354         emit Sale(true);
1355     }
1356 
1357     function isSaleActive()
1358         public
1359         override
1360         view
1361         returns (bool)
1362     {
1363         return tokensPerEth > 0 && soldEth < maxSoldEth;
1364     }
1365     
1366     function start(
1367         IUnipumpGroupManager _groupManager,
1368         IUnipumpContest _contest)
1369         public
1370         override
1371         ownerOnly()
1372     {
1373         require (address(_groupManager) != address(0));
1374         require (address(groupManager) == address(0), "Operations cannot be stopped after having been started");
1375         require (address(_contest) != address(0));
1376                 
1377         maxSoldEth = 0;
1378         groupManager = _groupManager;
1379         contest = _contest;
1380                 
1381         uint256 sold = totalSupply(); // 'sold' represents 40% of the total supply
1382         require (sold > 0);
1383 
1384         uint256 wethBalance = IERC20(WETH).balanceOf(address(this));
1385 
1386         uint256 totalLiquidityEth = address(this).balance / 2 + wethBalance / 2;
1387         uint256 totalLiquidityUpp = totalLiquidityEth * tokensPerEth * 9 / 10; // pump price by 10% when uniswap is funded
1388 
1389         _mint(address(escrow), sold / 2); // 20% for marketing, team
1390         _mint(address(contest), sold / 4); // 10% for public pump contests
1391         _mint(address(this), totalLiquidityUpp + sold / 4); // liquidity (~20%) for uniswap + 10%
1392         _approve(address(this), address(staking), sold / 4); // 10%
1393         _approve(address(this), address(uniswapV2Router), totalLiquidityUpp);
1394 
1395         staking.increaseRewardsPot();
1396         escrow.start();
1397 
1398         if (wethBalance < totalLiquidityEth) {
1399             IWETH(WETH).deposit{ value: totalLiquidityEth - wethBalance }();
1400         }
1401 
1402         IERC20(WETH).approve(address(uniswapV2Router), totalLiquidityEth);
1403 
1404         (,,initialLiquidityTokens) = uniswapV2Router.addLiquidity(
1405             address(this),
1406             WETH,
1407             totalLiquidityUpp,
1408             totalLiquidityEth,
1409             totalLiquidityUpp,
1410             totalLiquidityEth,
1411             address(this),
1412             block.timestamp);
1413 
1414         minLiquidityCrisisTime = block.timestamp + 60 * 60 * 24 * 30; // Creating a liquidity crisis isn't available for the first month
1415 
1416         emit Sale(false);
1417     }
1418 
1419     receive() 
1420         external
1421         payable
1422     {
1423         uint256 tokens = tokensPerEth * msg.value;
1424         uint256 sold = soldEth;
1425         require (address(groupManager) == address(0) && tokens > 0 && sold < maxSoldEth, "Tokens are not for sale or you did not send any ETH/WETH");
1426         _mint(msg.sender, tokens);
1427         soldEth = sold + msg.value;
1428     }
1429 
1430     function buy()
1431         public
1432         payable
1433         override
1434     {       
1435         uint256 wethAmount = transferMax(WETH, msg.sender, address(this));
1436         uint256 totalAmount = wethAmount + msg.value;
1437         uint256 tokens = tokensPerEth * totalAmount;
1438         uint256 sold = soldEth;
1439         require (address(groupManager) == address(0) && tokens > 0 && sold < maxSoldEth, "Tokens are not for sale or you did not send any ETH/WETH");
1440         _mint(msg.sender, tokens);
1441         soldEth = sold + totalAmount;
1442     }
1443 
1444     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override { 
1445         require (from == address(0) || address(groupManager) != address(0), "The contract has not yet become operational");
1446         super._beforeTokenTransfer(from, to, amount);
1447     }
1448 
1449     function minSecondsUntilLiquidityCrisis()
1450         public
1451         view
1452         override
1453         returns (uint256)
1454     {
1455         uint256 min = minLiquidityCrisisTime;
1456         if (min <= block.timestamp) { return 0; }
1457         return min - block.timestamp;
1458     }
1459 
1460     // Reduce some liquidity - use to enhance pump effectiveness during bull run!
1461     function createLiquidityCrisis()
1462         external
1463         payable
1464         override
1465     {
1466         require (block.timestamp >= minLiquidityCrisisTime, "It's too early to create a liquidity crisis");
1467         require (msg.sender == owner || msg.value >= 100 ether, "This can only be called by paying 100 ETH");
1468 
1469         minLiquidityCrisisTime = block.timestamp + 60 * 60 * 24 * 90; // No more for 3 months;
1470 
1471         uint256 liquidity = initialLiquidityTokens / 4;
1472         uint256 balance = uniswapEthUppPair.balanceOf(address(this));
1473         if (liquidity > balance) { liquidity = balance; }
1474         if (liquidity == 0) { return; }
1475 
1476         uniswapEthUppPair.approve(address(uniswapV2Router), liquidity);
1477         (uint256 amountToken,) = uniswapV2Router.removeLiquidityETH(
1478             address(this),
1479             liquidity,
1480             0,
1481             0,
1482             owner,
1483             block.timestamp);
1484 
1485         _transfer(owner, address(this), amountToken);
1486         _approve(address(this), address(staking), amountToken);
1487         staking.increaseRewardsPot();
1488 
1489         emit LiquidityCrisis();
1490     }
1491 
1492     function _drainAmount(
1493         address token, 
1494         uint256 available
1495     ) 
1496         internal 
1497         override
1498         view
1499         returns (uint256 amount)
1500     {
1501         amount = available;
1502         
1503         if (address(groupManager) == address(0) || // Don't allow any drainage until the contract is operational and liquidity funding has been provided
1504             token == address(uniswapEthUppPair)) // Don't allow drainage of liquidity
1505         {            
1506             amount = 0;
1507         }
1508     }
1509 }
1510 
1511 // File: browser/UnipumpDefaults.sol
1512 
1513 
1514 
1515 
1516 
1517 
1518 
1519 contract UnipumpDefaults is Unipump 
1520 {
1521     constructor() 
1522         Unipump(
1523             IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f), // uniswap v2 factory on ethereum mainnet
1524             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D) // uniswap v2 router on ethereum mainnet
1525         ) 
1526     { }
1527 }