1 /*
2 
3  Buy tax:
4      Tax is the same no matter the time:
5          9% to the house wallet
6  Sell tax:
7      If selling within 3 days:
8          9% sent to the house wallet
9          9% sent to the burn wallet
10      If selling within 3-6 days:
11          9% sent to the house wallet
12          6% sent to the burn wallet
13      If selling within 6-9 days:
14          9% sent to the house wallet
15          3% sent the burn wallet
16      If selling after 9 days:
17          9% sent to the house wallet
18 
19 
20 
21 I acquired and modified code written by Author: @HizzleDev 
22 
23 
24 */
25 
26 // SPDX-License-Identifier: Unlicensed
27 pragma solidity ^0.8.9;
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return payable(msg.sender);
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 contract Ownable is Context {
121     address private _owner;
122     address private _previousOwner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor () {
130         address msgSender = _msgSender();
131         _owner = msgSender;
132         emit OwnershipTransferred(address(0), msgSender);
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(_owner == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151     * @dev Leaves the contract without owner. It will not be possible to call
152     * `onlyOwner` functions anymore. Can only be called by the current owner.
153     *
154     * NOTE: Renouncing ownership will leave the contract without an owner,
155     * thereby removing any functionality that is only available to the owner.
156     */
157     function renounceOwnership() public virtual onlyOwner {
158         emit OwnershipTransferred(_owner, address(0));
159         _owner = address(0);
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 }
172 
173 interface IUniswapV2Factory {
174     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
175 
176     function feeTo() external view returns (address);
177     function feeToSetter() external view returns (address);
178 
179     function getPair(address tokenA, address tokenB) external view returns (address pair);
180     function allPairs(uint) external view returns (address pair);
181     function allPairsLength() external view returns (uint);
182 
183     function createPair(address tokenA, address tokenB) external returns (address pair);
184 
185     function setFeeTo(address) external;
186     function setFeeToSetter(address) external;
187 }
188 
189 interface IUniswapV2Pair {
190     event Approval(address indexed owner, address indexed spender, uint value);
191     event Transfer(address indexed from, address indexed to, uint value);
192 
193     function name() external pure returns (string memory);
194     function symbol() external pure returns (string memory);
195     function decimals() external pure returns (uint8);
196     function totalSupply() external view returns (uint);
197     function balanceOf(address owner) external view returns (uint);
198     function allowance(address owner, address spender) external view returns (uint);
199 
200     function approve(address spender, uint value) external returns (bool);
201     function transfer(address to, uint value) external returns (bool);
202     function transferFrom(address from, address to, uint value) external returns (bool);
203 
204     function DOMAIN_SEPARATOR() external view returns (bytes32);
205     function PERMIT_TYPEHASH() external pure returns (bytes32);
206     function nonces(address owner) external view returns (uint);
207 
208     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
209 
210     event Mint(address indexed sender, uint amount0, uint amount1);
211     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
212     event Swap(
213         address indexed sender,
214         uint amount0In,
215         uint amount1In,
216         uint amount0Out,
217         uint amount1Out,
218         address indexed to
219     );
220     event Sync(uint112 reserve0, uint112 reserve1);
221 
222     function MINIMUM_LIQUIDITY() external pure returns (uint);
223     function factory() external view returns (address);
224     function token0() external view returns (address);
225     function token1() external view returns (address);
226     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
227     function price0CumulativeLast() external view returns (uint);
228     function price1CumulativeLast() external view returns (uint);
229     function kLast() external view returns (uint);
230 
231     function mint(address to) external returns (uint liquidity);
232     function burn(address to) external returns (uint amount0, uint amount1);
233     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
234     function skim(address to) external;
235     function sync() external;
236 
237     function initialize(address, address) external;
238 }
239 
240 interface IUniswapV2Router01 {
241     function factory() external pure returns (address);
242     function WETH() external pure returns (address);
243 
244     function addLiquidity(
245         address tokenA,
246         address tokenB,
247         uint amountADesired,
248         uint amountBDesired,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline
253     ) external returns (uint amountA, uint amountB, uint liquidity);
254     function addLiquidityETH(
255         address token,
256         uint amountTokenDesired,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
262     function removeLiquidity(
263         address tokenA,
264         address tokenB,
265         uint liquidity,
266         uint amountAMin,
267         uint amountBMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountA, uint amountB);
271     function removeLiquidityETH(
272         address token,
273         uint liquidity,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline
278     ) external returns (uint amountToken, uint amountETH);
279     function removeLiquidityWithPermit(
280         address tokenA,
281         address tokenB,
282         uint liquidity,
283         uint amountAMin,
284         uint amountBMin,
285         address to,
286         uint deadline,
287         bool approveMax, uint8 v, bytes32 r, bytes32 s
288     ) external returns (uint amountA, uint amountB);
289     function removeLiquidityETHWithPermit(
290         address token,
291         uint liquidity,
292         uint amountTokenMin,
293         uint amountETHMin,
294         address to,
295         uint deadline,
296         bool approveMax, uint8 v, bytes32 r, bytes32 s
297     ) external returns (uint amountToken, uint amountETH);
298     function swapExactTokensForTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external returns (uint[] memory amounts);
305     function swapTokensForExactTokens(
306         uint amountOut,
307         uint amountInMax,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external returns (uint[] memory amounts);
312     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
313     external
314     payable
315     returns (uint[] memory amounts);
316     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
317     external
318     returns (uint[] memory amounts);
319     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
320     external
321     returns (uint[] memory amounts);
322     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
323     external
324     payable
325     returns (uint[] memory amounts);
326 
327     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
328     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
329     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
330     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
331     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
332 }
333 
334 interface IUniswapV2Router02 is IUniswapV2Router01 {
335     function removeLiquidityETHSupportingFeeOnTransferTokens(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external returns (uint amountETH);
343     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
344         address token,
345         uint liquidity,
346         uint amountTokenMin,
347         uint amountETHMin,
348         address to,
349         uint deadline,
350         bool approveMax, uint8 v, bytes32 r, bytes32 s
351     ) external returns (uint amountETH);
352 
353     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
354         uint amountIn,
355         uint amountOutMin,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external;
360     function swapExactETHForTokensSupportingFeeOnTransferTokens(
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external payable;
366     function swapExactTokensForETHSupportingFeeOnTransferTokens(
367         uint amountIn,
368         uint amountOutMin,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external;
373 }
374 
375 
376 
377 contract MorpheusInu is Context, IERC20, Ownable {
378     struct TimedTransactions {
379         uint[] txBlockTimes;
380         mapping (uint => uint256) timedTxAmount;
381         uint256 totalBalance;
382     }
383     
384     mapping(address => bool) _blacklist;
385     
386     event BlacklistUpdated(address indexed user, bool value);
387 
388     // Track the transaction history of the user
389     mapping (address => TimedTransactions) private _timedTransactionsMap;
390 
391     mapping (address => mapping (address => uint256)) private _allowances;
392 
393     mapping (address => bool) private _isExcludedFromFees;
394     mapping (address => bool) private _onlyDiamondHandTxs;
395 
396     uint256 constant DEFAULT_HOUSE_FEE = 9;
397     uint256 private _currentHouseFee = 9;
398 
399     uint256 constant DEFAULT_PAPER_HAND_FEE = 9;
400     uint256 private _currentPaperHandFee = 9;
401     uint256 private _paperHandTime = 3 days;
402 
403     uint256 constant DEFAULT_GATE1_FEE = 6;
404     uint256 private _currentGate1Fee = 6;
405     uint256 private _gate1Time = 3 days;
406 
407     uint256 constant DEFAULT_GATE2_FEE = 3;
408     uint256 private _currentGate2Fee = 3;
409     uint256 private _gate2Time = 3 days;
410 
411     string private _name = "MorpheusInu";
412     string private _symbol = "MORPHI";
413     uint8 private _decimals = 9;
414 	
415 	uint256 public allowTradeAt;
416 
417     IUniswapV2Router02 public uniswapV2Router;
418     address public uniswapV2Pair;
419 
420     // This unix time is used to aggregate all transaction block times. It is over 21 days and therefore will
421     // trigger the lowest tax rate possible
422     uint256 constant OVER_21_DAYS_BLOCK_TIME = 1577836800;
423 
424     // Prevent reentrancy by only allowing one swap at a time
425     bool swapInProgress;
426 
427     modifier lockTheSwap {
428         swapInProgress = true;
429         _;
430         swapInProgress = false;
431     }
432 
433     bool private _swapEnabled = true;
434     bool private _burnEnabled = true;
435 
436     uint256 private _totalTokens = 1000 * 10**6 * 10**9;
437     uint256 private _minTokensBeforeSwap = 1000 * 10**3 * 10**9;
438 
439     address payable private _houseContract = payable(0x652E93f3dB80832416661e98b65ccFBD57DB6510);
440     address private _deadAddress = 0x000000000000000000000000000000000000dEaD;
441 
442     constructor() {
443         // UniSwap V2 address
444         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
445 
446         // Create a uniswap pair for this new token
447         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
448         .createPair(address(this), _uniswapV2Router.WETH());
449 
450         uniswapV2Router = _uniswapV2Router;
451 
452         // Add initial balances
453         _timedTransactionsMap[owner()].totalBalance = _totalTokens;
454         _timedTransactionsMap[owner()].txBlockTimes.push(OVER_21_DAYS_BLOCK_TIME);
455         _timedTransactionsMap[owner()].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = _totalTokens;
456 
457         // Track balance in the dead wallet
458         _timedTransactionsMap[_deadAddress].totalBalance = 0;
459         _timedTransactionsMap[_deadAddress].txBlockTimes.push(OVER_21_DAYS_BLOCK_TIME);
460         _timedTransactionsMap[_deadAddress].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = 0;
461 
462         // Exclude contract and owner from fees to prevent contract functions from having a tax
463         _isExcludedFromFees[owner()] = true;
464         _isExcludedFromFees[address(this)] = true;
465         _isExcludedFromFees[_houseContract] = true;
466 
467         emit Transfer(address(0), _msgSender(), _totalTokens);
468     }
469 
470     function name() public view returns (string memory) {
471         return _name;
472     }
473 
474     function symbol() public view returns (string memory) {
475         return _symbol;
476     }
477 
478     function decimals() public view returns (uint8) {
479         return _decimals;
480     }
481 
482     function totalSupply() public view override returns (uint256) {
483         return _totalTokens;
484     }
485 
486     function balanceOf(address account) public view override returns (uint256) {
487         return _timedTransactionsMap[account].totalBalance;
488     }
489 
490     function balanceLessThan7Days(address account) external view returns (uint256) {
491         uint256 totalTokens = 0;
492 
493         for (uint i = 0; i < _timedTransactionsMap[account].txBlockTimes.length; i++) {
494             uint txTime = _timedTransactionsMap[account].txBlockTimes[i];
495             uint256 tokensAtTime = _timedTransactionsMap[account].timedTxAmount[txTime];
496 
497             // Only add up balance in the last 7 days
498             if (txTime > block.timestamp - _paperHandTime) {
499                 totalTokens = totalTokens + tokensAtTime;
500             }
501         }
502 
503         return totalTokens;
504     }
505     
506      function blacklistUpdate(address user, bool value) public virtual onlyOwner {
507         // require(_owner == _msgSender(), "Only owner is allowed to modify blacklist.");
508         _blacklist[user] = value;
509         emit BlacklistUpdated(user, value);
510     }
511     
512     function isBlackListed(address user) public view returns (bool) {
513         return _blacklist[user];
514     }
515 
516     function balanceBetween7And14Days(address account) external view returns (uint256) {
517         uint256 totalTokens = 0;
518 
519         for (uint i = 0; i < _timedTransactionsMap[account].txBlockTimes.length; i++) {
520             uint txTime = _timedTransactionsMap[account].txBlockTimes[i];
521             uint256 tokensAtTime = _timedTransactionsMap[account].timedTxAmount[txTime];
522 
523             // Only add up balance in the last 7-14 days
524             if (txTime < block.timestamp - _paperHandTime && txTime > block.timestamp - _gate1Time) {
525                 totalTokens = totalTokens + tokensAtTime;
526             }
527         }
528 
529         return totalTokens;
530     }
531 
532     function balanceBetween14And21Days(address account) external view returns (uint256) {
533         uint256 totalTokens = 0;
534 
535         for (uint i = 0; i < _timedTransactionsMap[account].txBlockTimes.length; i++) {
536             uint txTime = _timedTransactionsMap[account].txBlockTimes[i];
537             uint256 tokensAtTime = _timedTransactionsMap[account].timedTxAmount[txTime];
538 
539             // Only add up balance in the last 14-21 days
540             if (txTime < block.timestamp - _gate1Time && txTime > block.timestamp - _gate2Time) {
541                 totalTokens = totalTokens + tokensAtTime;
542             }
543         }
544 
545         return totalTokens;
546     }
547 
548     function balanceOver21Days(address account) public view returns (uint256) {
549         uint256 totalTokens = 0;
550 
551         for (uint i = 0; i < _timedTransactionsMap[account].txBlockTimes.length; i++) {
552             uint txTime = _timedTransactionsMap[account].txBlockTimes[i];
553             uint256 tokensAtTime = _timedTransactionsMap[account].timedTxAmount[txTime];
554 
555             // Only add up balance over the last 21 days
556             if (txTime < block.timestamp - _gate2Time) {
557                 totalTokens = totalTokens + tokensAtTime;
558             }
559         }
560 
561         return totalTokens;
562     }
563 
564     function transfer(address recipient, uint256 amount) public override returns (bool) {
565     require (!isBlackListed(_msgSender()), "blacklisted sorry");
566         _transfer(_msgSender(), recipient, amount);
567         return true;
568     }
569 
570     function allowance(address owner, address spender) public view override returns (uint256) {
571         return _allowances[owner][spender];
572     }
573 
574     function approve(address spender, uint256 amount) public override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
580         _transfer(sender, recipient, amount);
581         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
582         return true;
583     }
584 
585     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
587         return true;
588     }
589 
590     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
592         return true;
593     }
594 
595     function _approve(address owner, address spender, uint256 amount) private {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 	
603 	function enableFairLaunch() external onlyOwner() {
604     require(msg.sender != address(0), "ERC20: approve from the zero address");
605     allowTradeAt = block.timestamp;
606     }
607 
608     function _transfer(
609         address from,
610         address to,
611         uint256 amount
612     ) private {
613         require(from != address(0), "ERC20: transfer from the zero address");
614         require(to != address(0), "ERC20: transfer to the zero address");
615         require(amount > 0, "Transfer amount must be greater than zero");
616 		if ((block.timestamp < allowTradeAt + 30 minutes && amount >= 4 * 10**6 * 10**9) && (from != owner()) ) {
617 
618         revert("You cannot transfer more than 1% now");  }
619 
620         // Selective competitions are based on "diamond hand only" and transfers will only be allowed
621         // when the tokens are in the "diamond hand" group
622         bool isOnlyDiamondHandTx = _onlyDiamondHandTxs[from] || _onlyDiamondHandTxs[to];
623         if (isOnlyDiamondHandTx) {
624             require(balanceOver21Days(from) >= amount, "Insufficient diamond hand token balance");
625         }
626 
627         // Reduce balance of sending including calculating and removing all taxes
628         uint256 transferAmount = _reduceSenderBalance(from, to, amount);
629 
630         // Increase balance of the recipient address
631         _increaseRecipientBalance(to, transferAmount, isOnlyDiamondHandTx);
632 
633         emit Transfer(from, to, transferAmount);
634     }
635 
636     function _reduceSenderBalance(address sender, address recipient, uint256 initialTransferAmount) private returns (uint256) {
637         require(sender != address(0), "ERC20: transfer from the zero address");
638         require(recipient != address(0), "ERC20: transfer to the zero address");
639         require(initialTransferAmount > 0, "Transfer amount must be greater than zero");
640 
641         // Keep track of the tokens that haven't had a tax calculated against them
642         uint256 remainingTokens = initialTransferAmount;
643 
644         // Keep track of the amount of tokens that are to be burned
645         uint256 taxedBurnTokens = 0;
646 
647         // Keep track of the index for which tokens still exist in the bucket
648         uint lastIndexToDelete = 0;
649 
650         // Loop over the blockTimes
651         for (uint i = 0; i < _timedTransactionsMap[sender].txBlockTimes.length; i++) {
652             uint txTime = _timedTransactionsMap[sender].txBlockTimes[i];
653             uint256 tokensAtTime = _timedTransactionsMap[sender].timedTxAmount[txTime];
654 
655             // If there are more tokens purchased at the current time than those that are remaining to
656             // fulfill the tokens at this transaction then only use the remainingTokens
657             if (tokensAtTime > remainingTokens) {
658                 tokensAtTime = remainingTokens;
659             } else {
660                 // There are more elements to iterate through
661                 lastIndexToDelete = i + 1;
662             }
663 
664             // Depending on when the tokens were bought, tax the correct amount. This is proportional
665             // to when the user bought each set of tokens.
666             if (txTime > block.timestamp - _paperHandTime) {
667                 taxedBurnTokens = taxedBurnTokens + ((tokensAtTime * _currentPaperHandFee) / 100);
668             } else if (txTime > block.timestamp - _gate1Time) {
669                 taxedBurnTokens = taxedBurnTokens + ((tokensAtTime * _currentGate1Fee) / 100);
670             } else if (txTime > block.timestamp - _gate2Time) {
671                 taxedBurnTokens = taxedBurnTokens + ((tokensAtTime * _currentGate2Fee) / 100);
672             }
673 
674             // Decrease the tokens in the map
675             _timedTransactionsMap[sender].timedTxAmount[txTime] = _timedTransactionsMap[sender].timedTxAmount[txTime] - tokensAtTime;
676 
677             remainingTokens = remainingTokens - tokensAtTime;
678 
679             // If there are no more tokens to sell then exit the loop
680             if (remainingTokens == 0) {
681                 break;
682             }
683         }
684 
685         _sliceBlockTimeArray(sender, lastIndexToDelete);
686 
687         // Update the senders balance
688         _timedTransactionsMap[sender].totalBalance = _timedTransactionsMap[sender].totalBalance - initialTransferAmount;
689 
690         // Only burn tokens if the burn is enabled, the sender address is not excluded and it is performed on a sell
691         if (!_burnEnabled || _isExcludedFromFees[sender] || _isExcludedFromFees[recipient] || recipient != uniswapV2Pair) {
692             taxedBurnTokens = 0;
693         }
694 
695         if (taxedBurnTokens > 0) {
696             _timedTransactionsMap[_deadAddress].totalBalance = _timedTransactionsMap[_deadAddress].totalBalance + taxedBurnTokens;
697             _timedTransactionsMap[_deadAddress].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = _timedTransactionsMap[_deadAddress].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] + taxedBurnTokens;
698         }
699 
700         uint256 taxedHouseTokens = _calculateHouseFee(initialTransferAmount);
701 
702         // Always collect house tokens unless address is excluded
703         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
704             taxedHouseTokens = 0;
705         }
706 
707         // Add taxed tokens to the contract total
708         _increaseTaxBalance(taxedHouseTokens);
709 
710         uint256 contractTokenBalance = balanceOf(address(this));
711 
712         // Only swap tokens when threshold has been met, a swap isn't already in progress,
713         // the swap is enabled and never on a buy
714         if (
715             contractTokenBalance >= _minTokensBeforeSwap &&
716             !swapInProgress &&
717             _swapEnabled &&
718             sender != uniswapV2Pair
719         ) {
720             // Always swap a set amount of tokens to prevent large dumps
721             _swapTokensForHouse(_minTokensBeforeSwap);
722         }
723 
724         // The amount to be transferred is the initial amount minus the taxed and burned tokens
725         return initialTransferAmount - taxedHouseTokens - taxedBurnTokens;
726     }
727 
728     function _increaseTaxBalance(uint256 amount) private {
729         _timedTransactionsMap[address(this)].totalBalance = _timedTransactionsMap[address(this)].totalBalance + amount;
730         _timedTransactionsMap[address(this)].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = _timedTransactionsMap[address(this)].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] + amount;
731     }
732 
733     function _increaseRecipientBalance(address recipient, uint256 transferAmount, bool isDiamondHandOnlyTx) private {
734         _aggregateOldTransactions(recipient);
735 
736         _timedTransactionsMap[recipient].totalBalance = _timedTransactionsMap[recipient].totalBalance + transferAmount;
737 
738         uint256 totalTxs = _timedTransactionsMap[recipient].txBlockTimes.length;
739 
740         if (isDiamondHandOnlyTx) {
741             // If it's the first transaction then just add the oldest time to the map and array
742             if (totalTxs < 1) {
743                 _timedTransactionsMap[recipient].txBlockTimes.push(OVER_21_DAYS_BLOCK_TIME);
744                 _timedTransactionsMap[recipient].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = transferAmount;
745                 return;
746             }
747 
748             // If the first position in the array is already the oldest block time then just increase the value in the map
749             if (_timedTransactionsMap[recipient].txBlockTimes[0] == OVER_21_DAYS_BLOCK_TIME) {
750                 _timedTransactionsMap[recipient].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = _timedTransactionsMap[recipient].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] + transferAmount;
751                 return;
752             }
753 
754             // Shift the array with the oldest block time in the 0 position and add the value in the map
755             _timedTransactionsMap[recipient].txBlockTimes.push(_timedTransactionsMap[recipient].txBlockTimes[totalTxs - 1]);
756             for (uint i = totalTxs - 1; i > 0; i--) {
757                 _timedTransactionsMap[recipient].txBlockTimes[i] = _timedTransactionsMap[recipient].txBlockTimes[i - 1];
758             }
759             _timedTransactionsMap[recipient].txBlockTimes[0] = OVER_21_DAYS_BLOCK_TIME;
760             _timedTransactionsMap[recipient].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = transferAmount;
761             return;
762         }
763 
764         if (totalTxs < 1) {
765             _timedTransactionsMap[recipient].txBlockTimes.push(block.timestamp);
766             _timedTransactionsMap[recipient].timedTxAmount[block.timestamp] = transferAmount;
767             return;
768         }
769 
770         uint256 lastTxTime = _timedTransactionsMap[recipient].txBlockTimes[totalTxs - 1];
771 
772         // If transaction was within the past 12 hours then keep as part of the same bucket for efficiency
773         if (lastTxTime > block.timestamp - 12 hours) {
774             _timedTransactionsMap[recipient].timedTxAmount[lastTxTime] = _timedTransactionsMap[recipient].timedTxAmount[lastTxTime] + transferAmount;
775             return;
776         }
777 
778         _timedTransactionsMap[recipient].txBlockTimes.push(block.timestamp);
779         _timedTransactionsMap[recipient].timedTxAmount[block.timestamp] = transferAmount;
780     }
781 
782     function _calculateHouseFee(uint256 initialAmount) private view returns (uint256) {
783         return (initialAmount * _currentHouseFee) / 100;
784     }
785 
786     function _swapTokensForHouse(uint256 tokensToSwap) private lockTheSwap {
787         uint256 initialBalance = address(this).balance;
788 
789         // Swap to BNB and send to house wallet
790         _swapTokensForEth(tokensToSwap);
791 
792         // Total BNB that has been swapped
793         uint256 bnbSwapped = address(this).balance - initialBalance;
794 
795         // Transfer the BNB to the house contract
796         (bool success, ) = _houseContract.call{value:bnbSwapped}("");
797         require(success, "Unable to send to house contract");
798     }
799 
800     //to receive ETH from uniswapV2Router when swapping
801     receive() external payable {}
802 
803     function _swapTokensForEth(uint256 tokenAmount) private {
804         // generate the uniswap pair path of token -> weth
805         address[] memory path = new address[](2);
806         path[0] = address(this);
807         path[1] = uniswapV2Router.WETH();
808 
809         _approve(address(this), address(uniswapV2Router), tokenAmount);
810 
811         // make the swap
812         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
813             tokenAmount,
814             0, // accept any amount of ETH
815             path,
816             address(this),
817             block.timestamp
818         );
819     }
820 
821     function setBurnEnabled(bool enabled) external onlyOwner {
822         _burnEnabled = enabled;
823     }
824 
825     function setSwapEnabled(bool enabled) external onlyOwner {
826         _swapEnabled = enabled;
827     }
828 
829     function removeHouseFee() external onlyOwner {
830         _currentHouseFee = 0;
831     }
832 
833     function reinstateHouseFee() external onlyOwner {
834         _currentHouseFee = DEFAULT_HOUSE_FEE;
835     }
836 
837     function removeBurnFees() external onlyOwner {
838         _currentPaperHandFee = 0;
839         _currentGate1Fee = 0;
840         _currentGate2Fee = 0;
841     }
842 
843     function reinstateBurnFees() external onlyOwner {
844         _currentPaperHandFee = DEFAULT_PAPER_HAND_FEE;
845         _currentGate1Fee = DEFAULT_GATE1_FEE;
846         _currentGate2Fee = DEFAULT_GATE2_FEE;
847     }
848 
849     function removeAllFees() external onlyOwner {
850         _currentHouseFee = 0;
851         _currentPaperHandFee = 0;
852         _currentGate1Fee = 0;
853         _currentGate2Fee = 0;
854     }
855 
856     function reinstateAllFees() external onlyOwner {
857         _currentHouseFee = DEFAULT_HOUSE_FEE;
858         _currentPaperHandFee = DEFAULT_PAPER_HAND_FEE;
859         _currentGate1Fee = DEFAULT_GATE1_FEE;
860         _currentGate2Fee = DEFAULT_GATE2_FEE;
861     }
862 
863     // Update minimum tokens accumulated on the contract before a swap is performed
864     function updateMinTokensBeforeSwap(uint256 newAmount) external onlyOwner {
865         uint256 circulatingTokens = _totalTokens - balanceOf(_deadAddress);
866 
867         uint256 maxTokensBeforeSwap = circulatingTokens / 110;
868         uint256 newMinTokensBeforeSwap = newAmount * 10**9;
869 
870         require(newMinTokensBeforeSwap < maxTokensBeforeSwap, "Amount must be less than 1 percent of the circulating supply");
871         _minTokensBeforeSwap = newMinTokensBeforeSwap;
872     }
873 
874     function excludeFromFee(address account) public onlyOwner {
875         _isExcludedFromFees[account] = true;
876     }
877 
878     function includeInFee(address account) public onlyOwner {
879         _isExcludedFromFees[account] = false;
880     }
881 
882     function addToOnlyDiamondHandTxs(address account) public onlyOwner {
883         _onlyDiamondHandTxs[account] = true;
884     }
885 
886     function removeFromOnlyDiamondHandTxs(address account) public onlyOwner {
887         _onlyDiamondHandTxs[account] = false;
888     }
889 
890     // If there is a PCS upgrade then add the ability to change the router and pairs to the new version
891     function changeRouterVersion(address _router) public onlyOwner returns (address) {
892         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
893 
894         address newPair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
895         if(newPair == address(0)){
896             // Pair doesn't exist
897             newPair = IUniswapV2Factory(_uniswapV2Router.factory())
898             .createPair(address(this), _uniswapV2Router.WETH());
899         }
900         // Set the new pair
901         uniswapV2Pair = newPair;
902 
903         // Set the router of the contract variables
904         uniswapV2Router = _uniswapV2Router;
905 
906         return newPair;
907     }
908 
909     // Check all transactions and group transactions older than 21 days into their own bucket
910     function _aggregateOldTransactions(address sender) private {
911         uint256 totalBlockTimes = _timedTransactionsMap[sender].txBlockTimes.length;
912 
913         if (totalBlockTimes < 1) {
914             return;
915         }
916 
917         uint256 oldestBlockTime = block.timestamp - _gate2Time;
918 
919         // If the first transaction is not yet 21 days old then do not aggregate
920         if (_timedTransactionsMap[sender].txBlockTimes[0] > oldestBlockTime) {
921             return;
922         }
923 
924         uint lastAggregateIndex = 0;
925         uint256 totalTokens = 0;
926         for (uint i = 0; i < totalBlockTimes; i++) {
927             uint256 txBlockTime = _timedTransactionsMap[sender].txBlockTimes[i];
928 
929             if (txBlockTime > oldestBlockTime) {
930                 break;
931             }
932 
933             totalTokens = totalTokens + _timedTransactionsMap[sender].timedTxAmount[txBlockTime];
934             lastAggregateIndex = i;
935         }
936 
937         _sliceBlockTimeArray(sender, lastAggregateIndex);
938 
939         _timedTransactionsMap[sender].txBlockTimes[0] = OVER_21_DAYS_BLOCK_TIME;
940         _timedTransactionsMap[sender].timedTxAmount[OVER_21_DAYS_BLOCK_TIME] = totalTokens;
941     }
942 
943     // _sliceBlockTimeArray removes elements before the provided index from the transaction block
944     // time array for the given account. This is in order to keep an ordered list of transaction block
945     // times.
946     function _sliceBlockTimeArray(address account, uint indexFrom) private {
947         uint oldArrayLength = _timedTransactionsMap[account].txBlockTimes.length;
948 
949         if (indexFrom <= 0) return;
950 
951         if (indexFrom >= oldArrayLength) {
952             while (_timedTransactionsMap[account].txBlockTimes.length != 0) {
953                 _timedTransactionsMap[account].txBlockTimes.pop();
954             }
955             return;
956         }
957 
958         uint newArrayLength = oldArrayLength - indexFrom;
959 
960         uint counter = 0;
961         for (uint i = indexFrom; i < oldArrayLength; i++) {
962             _timedTransactionsMap[account].txBlockTimes[counter] = _timedTransactionsMap[account].txBlockTimes[i];
963             counter++;
964         }
965 
966         while (newArrayLength != _timedTransactionsMap[account].txBlockTimes.length) {
967             _timedTransactionsMap[account].txBlockTimes.pop();
968         }
969     }
970 }