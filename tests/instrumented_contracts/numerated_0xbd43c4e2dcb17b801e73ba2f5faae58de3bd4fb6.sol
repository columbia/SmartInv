1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-17
7 */
8 
9 // File: https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
10 
11 pragma solidity >=0.6.2;
12 
13 interface IUniswapV2Router01 {
14     function factory() external pure returns (address);
15     function WETH() external pure returns (address);
16 
17     function addLiquidity(
18         address tokenA,
19         address tokenB,
20         uint amountADesired,
21         uint amountBDesired,
22         uint amountAMin,
23         uint amountBMin,
24         address to,
25         uint deadline
26     ) external returns (uint amountA, uint amountB, uint liquidity);
27     function addLiquidityETH(
28         address token,
29         uint amountTokenDesired,
30         uint amountTokenMin,
31         uint amountETHMin,
32         address to,
33         uint deadline
34     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
35     function removeLiquidity(
36         address tokenA,
37         address tokenB,
38         uint liquidity,
39         uint amountAMin,
40         uint amountBMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountA, uint amountB);
44     function removeLiquidityETH(
45         address token,
46         uint liquidity,
47         uint amountTokenMin,
48         uint amountETHMin,
49         address to,
50         uint deadline
51     ) external returns (uint amountToken, uint amountETH);
52     function removeLiquidityWithPermit(
53         address tokenA,
54         address tokenB,
55         uint liquidity,
56         uint amountAMin,
57         uint amountBMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountA, uint amountB);
62     function removeLiquidityETHWithPermit(
63         address token,
64         uint liquidity,
65         uint amountTokenMin,
66         uint amountETHMin,
67         address to,
68         uint deadline,
69         bool approveMax, uint8 v, bytes32 r, bytes32 s
70     ) external returns (uint amountToken, uint amountETH);
71     function swapExactTokensForTokens(
72         uint amountIn,
73         uint amountOutMin,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external returns (uint[] memory amounts);
78     function swapTokensForExactTokens(
79         uint amountOut,
80         uint amountInMax,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external returns (uint[] memory amounts);
85     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
86         external
87         payable
88         returns (uint[] memory amounts);
89     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
90         external
91         returns (uint[] memory amounts);
92     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
93         external
94         returns (uint[] memory amounts);
95     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
96         external
97         payable
98         returns (uint[] memory amounts);
99 
100     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
101     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
102     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
103     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
104     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
105 }
106 
107 // File: https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol
108 
109 pragma solidity >=0.6.2;
110 
111 
112 interface IUniswapV2Router02 is IUniswapV2Router01 {
113     function removeLiquidityETHSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountETH);
121     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
122         address token,
123         uint liquidity,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline,
128         bool approveMax, uint8 v, bytes32 r, bytes32 s
129     ) external returns (uint amountETH);
130 
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138     function swapExactETHForTokensSupportingFeeOnTransferTokens(
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external payable;
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 // File: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol
154 
155 pragma solidity >=0.5.0;
156 
157 interface IUniswapV2Factory {
158     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
159 
160     function feeTo() external view returns (address);
161     function feeToSetter() external view returns (address);
162 
163     function getPair(address tokenA, address tokenB) external view returns (address pair);
164     function allPairs(uint) external view returns (address pair);
165     function allPairsLength() external view returns (uint);
166 
167     function createPair(address tokenA, address tokenB) external returns (address pair);
168 
169     function setFeeTo(address) external;
170     function setFeeToSetter(address) external;
171 }
172 
173 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC20 standard as defined in the EIP.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `to`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transfer(address to, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through {transferFrom}. This is
206      * zero by default.
207      *
208      * This value changes when {approve} or {transferFrom} are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * IMPORTANT: Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `from` to `to` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transferFrom(
238         address from,
239         address to,
240         uint256 amount
241     ) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Provides information about the current execution context, including the
267  * sender of the transaction and its data. While these are generally available
268  * via msg.sender and msg.data, they should not be accessed in such a direct
269  * manner, since when dealing with meta-transactions the account sending and
270  * paying for execution may not be the actual sender (as far as an application
271  * is concerned).
272  *
273  * This contract is only required for intermediate, library-like contracts.
274  */
275 abstract contract Context {
276     function _msgSender() internal view virtual returns (address) {
277         return msg.sender;
278     }
279 
280     function _msgData() internal view virtual returns (bytes calldata) {
281         return msg.data;
282     }
283 }
284 
285 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev Contract module which provides a basic access control mechanism, where
295  * there is an account (an owner) that can be granted exclusive access to
296  * specific functions.
297  *
298  * By default, the owner account will be the one that deploys the contract. This
299  * can later be changed with {transferOwnership}.
300  *
301  * This module is used through inheritance. It will make available the modifier
302  * `onlyOwner`, which can be applied to your functions to restrict their use to
303  * the owner.
304  */
305 abstract contract Ownable is Context {
306     address private _owner;
307 
308     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
309 
310     /**
311      * @dev Initializes the contract setting the deployer as the initial owner.
312      */
313     constructor() {
314         _transferOwnership(_msgSender());
315     }
316 
317     /**
318      * @dev Returns the address of the current owner.
319      */
320     function owner() public view virtual returns (address) {
321         return _owner;
322     }
323 
324     /**
325      * @dev Throws if called by any account other than the owner.
326      */
327     modifier onlyOwner() {
328         require(owner() == _msgSender(), "Ownable: caller is not the owner");
329         _;
330     }
331 
332     /**
333      * @dev Leaves the contract without owner. It will not be possible to call
334      * `onlyOwner` functions anymore. Can only be called by the current owner.
335      *
336      * NOTE: Renouncing ownership will leave the contract without an owner,
337      * thereby removing any functionality that is only available to the owner.
338      */
339     function renounceOwnership() public virtual onlyOwner {
340         _transferOwnership(address(0));
341     }
342 
343     /**
344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
345      * Can only be called by the current owner.
346      */
347     function transferOwnership(address newOwner) public virtual onlyOwner {
348         require(newOwner != address(0), "Ownable: new owner is the zero address");
349         _transferOwnership(newOwner);
350     }
351 
352     /**
353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
354      * Internal function without access restriction.
355      */
356     function _transferOwnership(address newOwner) internal virtual {
357         address oldOwner = _owner;
358         _owner = newOwner;
359         emit OwnershipTransferred(oldOwner, newOwner);
360     }
361 }
362 
363 // File: contracts/DividendTracker.sol
364 
365 
366 pragma solidity ^0.8.10;
367 
368 
369 
370 
371 
372 contract DividendTracker is Ownable, IERC20 {
373     address UNISWAPROUTER;
374 
375     string private _name = "NE_DividendTracker";
376     string private _symbol = "NE_DividendTracker";
377 
378     uint256 public lastProcessedIndex;
379 
380     uint256 private _totalSupply;
381     mapping(address => uint256) private _balances;
382 
383     uint256 private constant magnitude = 2**128;
384     uint256 public immutable minTokenBalanceForDividends;
385     uint256 private magnifiedDividendPerShare;
386     uint256 public totalDividendsDistributed;
387     uint256 public totalDividendsWithdrawn;
388 
389     address public tokenAddress;
390 
391     mapping(address => bool) public excludedFromDividends;
392     mapping(address => int256) private magnifiedDividendCorrections;
393     mapping(address => uint256) private withdrawnDividends;
394     mapping(address => uint256) private lastClaimTimes;
395 
396     event DividendsDistributed(address indexed from, uint256 weiAmount);
397     event DividendWithdrawn(address indexed to, uint256 weiAmount);
398     event ExcludeFromDividends(address indexed account, bool excluded);
399     event Claim(address indexed account, uint256 amount);
400     event Compound(address indexed account, uint256 amount, uint256 tokens);
401 
402     struct AccountInfo {
403         address account;
404         uint256 withdrawableDividends;
405         uint256 totalDividends;
406         uint256 lastClaimTime;
407     }
408 
409     constructor(address _tokenAddress, address _uniswapRouter) {
410         minTokenBalanceForDividends = 10000 * (10**18);
411         tokenAddress = _tokenAddress;
412         UNISWAPROUTER = _uniswapRouter;
413     }
414 
415     receive() external payable {
416         distributeDividends();
417     }
418 
419     function distributeDividends() public payable {
420         require(_totalSupply > 0);
421         if (msg.value > 0) {
422             magnifiedDividendPerShare =
423                 magnifiedDividendPerShare +
424                 ((msg.value * magnitude) / _totalSupply);
425             emit DividendsDistributed(msg.sender, msg.value);
426             totalDividendsDistributed += msg.value;
427         }
428     }
429 
430     function setBalance(address payable account, uint256 newBalance)
431         external
432         onlyOwner
433     {
434         if (excludedFromDividends[account]) {
435             return;
436         }
437         if (newBalance >= minTokenBalanceForDividends) {
438             _setBalance(account, newBalance);
439         } else {
440             _setBalance(account, 0);
441         }
442     }
443 
444     function excludeFromDividends(address account, bool excluded)
445         external
446         onlyOwner
447     {
448         require(
449             excludedFromDividends[account] != excluded,
450             "NE_DividendTracker: account already set to requested state"
451         );
452         excludedFromDividends[account] = excluded;
453         if (excluded) {
454             _setBalance(account, 0);
455         } else {
456             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
457             if (newBalance >= minTokenBalanceForDividends) {
458                 _setBalance(account, newBalance);
459             } else {
460                 _setBalance(account, 0);
461             }
462         }
463         emit ExcludeFromDividends(account, excluded);
464     }
465 
466     function isExcludedFromDividends(address account)
467         public
468         view
469         returns (bool)
470     {
471         return excludedFromDividends[account];
472     }
473 
474     function manualSendDividend(uint256 amount, address holder)
475         external
476         onlyOwner
477     {
478         uint256 contractETHBalance = address(this).balance;
479         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
480     }
481 
482     function _setBalance(address account, uint256 newBalance) internal {
483         uint256 currentBalance = _balances[account];
484         if (newBalance > currentBalance) {
485             uint256 addAmount = newBalance - currentBalance;
486             _mint(account, addAmount);
487         } else if (newBalance < currentBalance) {
488             uint256 subAmount = currentBalance - newBalance;
489             _burn(account, subAmount);
490         }
491     }
492 
493     function _mint(address account, uint256 amount) private {
494         require(
495             account != address(0),
496             "NE_DividendTracker: mint to the zero address"
497         );
498         _totalSupply += amount;
499         _balances[account] += amount;
500         emit Transfer(address(0), account, amount);
501         magnifiedDividendCorrections[account] =
502             magnifiedDividendCorrections[account] -
503             int256(magnifiedDividendPerShare * amount);
504     }
505 
506     function _burn(address account, uint256 amount) private {
507         require(
508             account != address(0),
509             "NE_DividendTracker: burn from the zero address"
510         );
511         uint256 accountBalance = _balances[account];
512         require(
513             accountBalance >= amount,
514             "NE_DividendTracker: burn amount exceeds balance"
515         );
516         _balances[account] = accountBalance - amount;
517         _totalSupply -= amount;
518         emit Transfer(account, address(0), amount);
519         magnifiedDividendCorrections[account] =
520             magnifiedDividendCorrections[account] +
521             int256(magnifiedDividendPerShare * amount);
522     }
523 
524     function processAccount(address payable account)
525         public
526         onlyOwner
527         returns (bool)
528     {
529         uint256 amount = _withdrawDividendOfUser(account);
530         if (amount > 0) {
531             lastClaimTimes[account] = block.timestamp;
532             emit Claim(account, amount);
533             return true;
534         }
535         return false;
536     }
537 
538     function _withdrawDividendOfUser(address payable account)
539         private
540         returns (uint256)
541     {
542         uint256 _withdrawableDividend = withdrawableDividendOf(account);
543         if (_withdrawableDividend > 0) {
544             withdrawnDividends[account] += _withdrawableDividend;
545             totalDividendsWithdrawn += _withdrawableDividend;
546             emit DividendWithdrawn(account, _withdrawableDividend);
547             (bool success, ) = account.call{
548                 value: _withdrawableDividend,
549                 gas: 3000
550             }("");
551             if (!success) {
552                 withdrawnDividends[account] -= _withdrawableDividend;
553                 totalDividendsWithdrawn -= _withdrawableDividend;
554                 return 0;
555             }
556             return _withdrawableDividend;
557         }
558         return 0;
559     }
560 
561     function compoundAccount(address payable account)
562         public
563         onlyOwner
564         returns (bool)
565     {
566         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
567         if (amount > 0) {
568             lastClaimTimes[account] = block.timestamp;
569             emit Compound(account, amount, tokens);
570             return true;
571         }
572         return false;
573     }
574 
575     function _compoundDividendOfUser(address payable account)
576         private
577         returns (uint256, uint256)
578     {
579         uint256 _withdrawableDividend = withdrawableDividendOf(account);
580         if (_withdrawableDividend > 0) {
581             withdrawnDividends[account] += _withdrawableDividend;
582             totalDividendsWithdrawn += _withdrawableDividend;
583             emit DividendWithdrawn(account, _withdrawableDividend);
584 
585             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
586                 UNISWAPROUTER
587             );
588 
589             address[] memory path = new address[](2);
590             path[0] = uniswapV2Router.WETH();
591             path[1] = address(tokenAddress);
592 
593             bool success;
594             uint256 tokens;
595 
596             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
597             try
598                 uniswapV2Router
599                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
600                     value: _withdrawableDividend
601                 }(0, path, address(account), block.timestamp)
602             {
603                 success = true;
604                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
605             } catch Error(
606                 string memory /*err*/
607             ) {
608                 success = false;
609             }
610 
611             if (!success) {
612                 withdrawnDividends[account] -= _withdrawableDividend;
613                 totalDividendsWithdrawn -= _withdrawableDividend;
614                 return (0, 0);
615             }
616 
617             return (_withdrawableDividend, tokens);
618         }
619         return (0, 0);
620     }
621 
622     function withdrawableDividendOf(address account)
623         public
624         view
625         returns (uint256)
626     {
627         return accumulativeDividendOf(account) - withdrawnDividends[account];
628     }
629 
630     function withdrawnDividendOf(address account)
631         public
632         view
633         returns (uint256)
634     {
635         return withdrawnDividends[account];
636     }
637 
638     function accumulativeDividendOf(address account)
639         public
640         view
641         returns (uint256)
642     {
643         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
644         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
645         return uint256(a + b) / magnitude;
646     }
647 
648     function getAccountInfo(address account)
649         public
650         view
651         returns (
652             address,
653             uint256,
654             uint256,
655             uint256,
656             uint256
657         )
658     {
659         AccountInfo memory info;
660         info.account = account;
661         info.withdrawableDividends = withdrawableDividendOf(account);
662         info.totalDividends = accumulativeDividendOf(account);
663         info.lastClaimTime = lastClaimTimes[account];
664         return (
665             info.account,
666             info.withdrawableDividends,
667             info.totalDividends,
668             info.lastClaimTime,
669             totalDividendsWithdrawn
670         );
671     }
672 
673     function getLastClaimTime(address account) public view returns (uint256) {
674         return lastClaimTimes[account];
675     }
676 
677     function name() public view returns (string memory) {
678         return _name;
679     }
680 
681     function symbol() public view returns (string memory) {
682         return _symbol;
683     }
684 
685     function decimals() public pure returns (uint8) {
686         return 18;
687     }
688 
689     function totalSupply() public view override returns (uint256) {
690         return _totalSupply;
691     }
692 
693     function balanceOf(address account) public view override returns (uint256) {
694         return _balances[account];
695     }
696 
697     function transfer(address, uint256) public pure override returns (bool) {
698         revert("NE_DividendTracker: method not implemented");
699     }
700 
701     function allowance(address, address)
702         public
703         pure
704         override
705         returns (uint256)
706     {
707         revert("NE_DividendTracker: method not implemented");
708     }
709 
710     function approve(address, uint256) public pure override returns (bool) {
711         revert("NE_DividendTracker: method not implemented");
712     }
713 
714     function transferFrom(
715         address,
716         address,
717         uint256
718     ) public pure override returns (bool) {
719         revert("NE_DividendTracker: method not implemented");
720     }
721 }
722 // File: contracts/NodeEmpire.sol
723 
724 
725 pragma solidity ^0.8.10;
726 
727 
728 
729 
730 
731 contract NodeEmpire is Ownable, IERC20 {
732     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
733     address DEAD = 0x000000000000000000000000000000000000dEaD;
734     address ZERO = 0x0000000000000000000000000000000000000000;
735 
736     string private _name = "Node Empire";
737     string private _symbol = "NE";
738 
739     uint256 public treasuryFeeBPS = 600;
740     uint256 public liquidityFeeBPS = 200;
741     uint256 public dividendFeeBPS = 300;
742     uint256 public marketingFeeBPS = 300;
743     uint256 public totalFeeBPS = 1400;
744 
745     uint256 public swapTokensAtAmount = 1000000 * (10**18);
746     uint256 public lastSwapTime;
747     bool swapAllToken = true;
748 
749     bool public swapEnabled = true;
750     bool public taxEnabled = true;
751     bool public compoundingEnabled = true;
752 
753     uint256 private _totalSupply;
754     bool private swapping;
755 
756     address marketingWallet;
757     address liquidityWallet;
758     address treasuryWallet;
759 
760     mapping(address => uint256) private _balances;
761     mapping(address => mapping(address => uint256)) private _allowances;
762     mapping(address => bool) private _isExcludedFromFees;
763     mapping(address => bool) public automatedMarketMakerPairs;
764     mapping(address => bool) private _whiteList;
765     mapping(address => bool) isBlacklisted;
766 
767     event SwapAndAddLiquidity(
768         uint256 tokensSwapped,
769         uint256 nativeReceived,
770         uint256 tokensIntoLiquidity
771     );
772     event SendDividends(uint256 tokensSwapped, uint256 amount);
773     event ExcludeFromFees(address indexed account, bool isExcluded);
774     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
775     event UpdateUniswapV2Router(
776         address indexed newAddress,
777         address indexed oldAddress
778     );
779     event SwapEnabled(bool enabled);
780     event TaxEnabled(bool enabled);
781     event CompoundingEnabled(bool enabled);
782     event BlacklistEnabled(bool enabled);
783 
784     DividendTracker public dividendTracker;
785     IUniswapV2Router02 public uniswapV2Router;
786 
787     address public uniswapV2Pair;
788 
789     uint256 public maxTxBPS = 100;
790     uint256 public maxWalletBPS = 200;
791 
792     bool isOpen = false;
793 
794     mapping(address => bool) private _isExcludedFromMaxTx;
795     mapping(address => bool) private _isExcludedFromMaxWallet;
796 
797     constructor(
798         address _marketingWallet,
799         address _liquidityWallet,
800         address _treasuryWallet
801     ) {
802         marketingWallet = _marketingWallet;
803         liquidityWallet = _liquidityWallet;
804         treasuryWallet = _treasuryWallet;
805 
806         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
807 
808         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
809 
810 
811         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
812             .createPair(address(this), _uniswapV2Router.WETH());
813 
814         uniswapV2Router = _uniswapV2Router;
815         uniswapV2Pair = _uniswapV2Pair;
816 
817         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
818 
819         dividendTracker.excludeFromDividends(address(dividendTracker), true);
820         dividendTracker.excludeFromDividends(address(this), true);
821         dividendTracker.excludeFromDividends(owner(), true);
822         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
823 
824         excludeFromFees(owner(), true);
825         excludeFromFees(address(this), true);
826         excludeFromFees(address(dividendTracker), true);
827 
828         excludeFromMaxTx(owner(), true);
829         excludeFromMaxTx(address(this), true);
830         excludeFromMaxTx(address(dividendTracker), true);
831 
832         excludeFromMaxWallet(owner(), true);
833         excludeFromMaxWallet(address(this), true);
834         excludeFromMaxWallet(address(dividendTracker), true);
835 
836         _mint(owner(), 110000000 * (10**18));
837     }
838 
839     receive() external payable {}
840 
841     function name() public view returns (string memory) {
842         return _name;
843     }
844 
845     function symbol() public view returns (string memory) {
846         return _symbol;
847     }
848 
849     function decimals() public pure returns (uint8) {
850         return 18;
851     }
852 
853     function totalSupply() public view virtual override returns (uint256) {
854         return _totalSupply;
855     }
856 
857     function balanceOf(address account)
858         public
859         view
860         virtual
861         override
862         returns (uint256)
863     {
864         return _balances[account];
865     }
866 
867     function allowance(address owner, address spender)
868         public
869         view
870         virtual
871         override
872         returns (uint256)
873     {
874         return _allowances[owner][spender];
875     }
876 
877     function approve(address spender, uint256 amount)
878         public
879         virtual
880         override
881         returns (bool)
882     {
883         _approve(_msgSender(), spender, amount);
884         return true;
885     }
886 
887     function increaseAllowance(address spender, uint256 addedValue)
888         public
889         returns (bool)
890     {
891         _approve(
892             _msgSender(),
893             spender,
894             _allowances[_msgSender()][spender] + addedValue
895         );
896         return true;
897     }
898 
899     function decreaseAllowance(address spender, uint256 subtractedValue)
900         public
901         returns (bool)
902     {
903         uint256 currentAllowance = _allowances[_msgSender()][spender];
904         require(
905             currentAllowance >= subtractedValue
906         );
907         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
908         return true;
909     }
910 
911     function transfer(address recipient, uint256 amount)
912         public
913         virtual
914         override
915         returns (bool)
916     {
917         _transfer(_msgSender(), recipient, amount);
918         return true;
919     }
920 
921     function transferFrom(
922         address sender,
923         address recipient,
924         uint256 amount
925     ) public virtual override returns (bool) {
926         _transfer(sender, recipient, amount);
927         uint256 currentAllowance = _allowances[sender][_msgSender()];
928         require(
929             currentAllowance >= amount,
930             "allowance exceeded"
931         );
932         _approve(sender, _msgSender(), currentAllowance - amount);
933         return true;
934     }
935 
936     function openTrading() external onlyOwner {
937         isOpen = true;
938     }
939 
940     function _transfer(
941         address sender,
942         address recipient,
943         uint256 amount
944     ) internal {
945         require(
946             isOpen ||
947                 sender == owner() ||
948                 recipient == owner() ||
949                 _whiteList[sender] ||
950                 _whiteList[recipient],
951             "Not Open"
952         );
953 
954         require(!isBlacklisted[sender], "sender blacklisted");
955         require(!isBlacklisted[recipient], "recipient blacklisted");
956 
957         require(sender != address(0));
958         require(recipient != address(0));
959 
960         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
961         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
962         require(
963             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
964             "TX Limit Exceeded"
965         );
966 
967         if (
968             sender != owner() &&
969             recipient != address(this) &&
970             recipient != address(DEAD) &&
971             recipient != uniswapV2Pair
972         ) {
973             uint256 currentBalance = balanceOf(recipient);
974             require(
975                 _isExcludedFromMaxWallet[recipient] ||
976                     (currentBalance + amount <= _maxWallet)
977             );
978         }
979 
980         uint256 senderBalance = _balances[sender];
981         require(
982             senderBalance >= amount
983         );
984 
985         uint256 contractTokenBalance = balanceOf(address(this));
986         uint256 contractNativeBalance = address(this).balance;
987 
988         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
989 
990         if (
991             swapEnabled && // True
992             canSwap && // true
993             !swapping && // swapping=false !false true
994             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
995             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
996             sender != owner() &&
997             recipient != owner()
998         ) {
999             swapping = true;
1000 
1001             if (!swapAllToken) {
1002                 contractTokenBalance = swapTokensAtAmount;
1003             }
1004             _executeSwap(contractTokenBalance, contractNativeBalance);
1005 
1006             lastSwapTime = block.timestamp;
1007             swapping = false;
1008         }
1009 
1010         bool takeFee;
1011 
1012         if (
1013             sender == address(uniswapV2Pair) ||
1014             recipient == address(uniswapV2Pair)
1015         ) {
1016             takeFee = true;
1017         }
1018 
1019         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1020             takeFee = false;
1021         }
1022 
1023         if (swapping || !taxEnabled) {
1024             takeFee = false;
1025         }
1026 
1027         if (takeFee) {
1028             uint256 fees = (amount * totalFeeBPS) / 10000;
1029             amount -= fees;
1030             _executeTransfer(sender, address(this), fees);
1031         }
1032 
1033         _executeTransfer(sender, recipient, amount);
1034 
1035         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1036         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1037     }
1038 
1039     function _executeTransfer(
1040         address sender,
1041         address recipient,
1042         uint256 amount
1043     ) private {
1044         require(sender != address(0));
1045         require(recipient != address(0));
1046         uint256 senderBalance = _balances[sender];
1047         require(
1048             senderBalance >= amount
1049         );
1050         _balances[sender] = senderBalance - amount;
1051         _balances[recipient] += amount;
1052         emit Transfer(sender, recipient, amount);
1053     }
1054 
1055     function _approve(
1056         address owner,
1057         address spender,
1058         uint256 amount
1059     ) private {
1060         require(owner != address(0));
1061         require(spender != address(0));
1062         _allowances[owner][spender] = amount;
1063         emit Approval(owner, spender, amount);
1064     }
1065 
1066     function _mint(address account, uint256 amount) private {
1067         require(account != address(0));
1068         _totalSupply += amount;
1069         _balances[account] += amount;
1070         emit Transfer(address(0), account, amount);
1071     }
1072 
1073     function _burn(address account, uint256 amount) private {
1074         require(account != address(0));
1075         uint256 accountBalance = _balances[account];
1076         require(accountBalance >= amount);
1077         _balances[account] = accountBalance - amount;
1078         _totalSupply -= amount;
1079         emit Transfer(account, address(0), amount);
1080     }
1081 
1082     function swapTokensForNative(uint256 tokens) private {
1083         address[] memory path = new address[](2);
1084         path[0] = address(this);
1085         path[1] = uniswapV2Router.WETH();
1086         _approve(address(this), address(uniswapV2Router), tokens);
1087         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1088             tokens,
1089             0, // accept any amount of native
1090             path,
1091             address(this),
1092             block.timestamp
1093         );
1094     }
1095 
1096     function addLiquidity(uint256 tokens, uint256 native) private {
1097         _approve(address(this), address(uniswapV2Router), tokens);
1098         uniswapV2Router.addLiquidityETH{value: native}(
1099             address(this),
1100             tokens,
1101             0, // slippage unavoidable
1102             0, // slippage unavoidable
1103             liquidityWallet,
1104             block.timestamp
1105         );
1106     }
1107 
1108    
1109 
1110     function _executeSwap(uint256 tokens, uint256 native) private {
1111         if (tokens <= 0) {
1112             return;
1113         }
1114 
1115         uint256 swapTokensMarketing;
1116         if (address(marketingWallet) != address(0)) {
1117             swapTokensMarketing = (tokens * marketingFeeBPS) / totalFeeBPS;
1118         }
1119 
1120         uint256 swapTokensTreasury;
1121         if(address(treasuryWallet) != address(0)){
1122             swapTokensTreasury = (tokens * treasuryFeeBPS) / totalFeeBPS;
1123         }
1124 
1125         uint256 swapTokensDividends;
1126         if (dividendTracker.totalSupply() > 0) {
1127             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1128         }
1129 
1130         uint256 tokensForLiquidity = tokens -
1131             swapTokensMarketing -
1132             swapTokensDividends -
1133             swapTokensTreasury;
1134         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1135         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1136         uint256 swapTokensTotal = swapTokensMarketing +
1137             swapTokensDividends +
1138             swapTokensLiquidity+
1139             swapTokensTreasury;
1140 
1141         uint256 initNativeBal = address(this).balance;
1142         swapTokensForNative(swapTokensTotal);
1143         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1144             native;
1145 
1146         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1147             swapTokensTotal;
1148         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1149             swapTokensTotal;
1150         uint256 nativeTreasury = (nativeSwapped * swapTokensTreasury) / swapTokensTotal;
1151         uint256 nativeLiquidity = nativeSwapped -
1152             nativeMarketing -
1153             nativeDividends - nativeTreasury;
1154 
1155         if (nativeMarketing > 0) {
1156             payable(marketingWallet).transfer(nativeMarketing);
1157         }
1158 
1159         if(nativeTreasury > 0){
1160             payable(treasuryWallet).transfer(nativeTreasury);
1161         }
1162 
1163         addLiquidity(addTokensLiquidity, nativeLiquidity);
1164         emit SwapAndAddLiquidity(
1165             swapTokensLiquidity,
1166             nativeLiquidity,
1167             addTokensLiquidity
1168         );
1169 
1170         if (nativeDividends > 0) {
1171             (bool success, ) = address(dividendTracker).call{
1172                 value: nativeDividends
1173             }("");
1174             if (success) {
1175                 emit SendDividends(swapTokensDividends, nativeDividends);
1176             }
1177         }
1178     }
1179 
1180     function excludeFromFees(address account, bool excluded) public onlyOwner {
1181         require(
1182             _isExcludedFromFees[account] != excluded
1183         );
1184         _isExcludedFromFees[account] = excluded;
1185         emit ExcludeFromFees(account, excluded);
1186     }
1187 
1188     function isExcludedFromFees(address account) public view returns (bool) {
1189         return _isExcludedFromFees[account];
1190     }
1191 
1192     function manualSendDividend(uint256 amount, address holder)
1193         external
1194         onlyOwner
1195     {
1196         dividendTracker.manualSendDividend(amount, holder);
1197     }
1198 
1199     function excludeFromDividends(address account, bool excluded)
1200         public
1201         onlyOwner
1202     {
1203         dividendTracker.excludeFromDividends(account, excluded);
1204     }
1205 
1206     function isExcludedFromDividends(address account)
1207         public
1208         view
1209         returns (bool)
1210     {
1211         return dividendTracker.isExcludedFromDividends(account);
1212     }
1213 
1214     function setWallet(
1215         address payable _marketingWallet,
1216         address payable _liquidityWallet
1217     ) external onlyOwner {
1218         marketingWallet = _marketingWallet;
1219         liquidityWallet = _liquidityWallet;
1220     }
1221 
1222     function setAutomatedMarketMakerPair(address pair, bool value)
1223         public
1224         onlyOwner
1225     {
1226         require(pair != uniswapV2Pair);
1227         _setAutomatedMarketMakerPair(pair, value);
1228     }
1229 
1230     function setFee(
1231         uint256 _treasuryFee,
1232         uint256 _liquidityFee,
1233         uint256 _dividendFee
1234     ) external onlyOwner {
1235         treasuryFeeBPS = _treasuryFee;
1236         liquidityFeeBPS = _liquidityFee;
1237         dividendFeeBPS = _dividendFee;
1238         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1239     }
1240 
1241     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1242         require(
1243             automatedMarketMakerPairs[pair] != value
1244         );
1245         automatedMarketMakerPairs[pair] = value;
1246         if (value) {
1247             dividendTracker.excludeFromDividends(pair, true);
1248         }
1249         emit SetAutomatedMarketMakerPair(pair, value);
1250     }
1251 
1252     function updateUniswapV2Router(address newAddress) public onlyOwner {
1253         require(
1254             newAddress != address(uniswapV2Router)
1255         );
1256         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1257         uniswapV2Router = IUniswapV2Router02(newAddress);
1258         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1259             .createPair(address(this), uniswapV2Router.WETH());
1260         uniswapV2Pair = _uniswapV2Pair;
1261     }
1262 
1263     function claim() public {
1264         dividendTracker.processAccount(payable(_msgSender()));
1265     }
1266 
1267     function compound() public {
1268         require(compoundingEnabled);
1269         dividendTracker.compoundAccount(payable(_msgSender()));
1270     }
1271 
1272     function withdrawableDividendOf(address account)
1273         public
1274         view
1275         returns (uint256)
1276     {
1277         return dividendTracker.withdrawableDividendOf(account);
1278     }
1279 
1280     function withdrawnDividendOf(address account)
1281         public
1282         view
1283         returns (uint256)
1284     {
1285         return dividendTracker.withdrawnDividendOf(account);
1286     }
1287 
1288     function accumulativeDividendOf(address account)
1289         public
1290         view
1291         returns (uint256)
1292     {
1293         return dividendTracker.accumulativeDividendOf(account);
1294     }
1295 
1296     function getAccountInfo(address account)
1297         public
1298         view
1299         returns (
1300             address,
1301             uint256,
1302             uint256,
1303             uint256,
1304             uint256
1305         )
1306     {
1307         return dividendTracker.getAccountInfo(account);
1308     }
1309 
1310     function getLastClaimTime(address account) public view returns (uint256) {
1311         return dividendTracker.getLastClaimTime(account);
1312     }
1313 
1314     function setSwapEnabled(bool _enabled) external onlyOwner {
1315         swapEnabled = _enabled;
1316         emit SwapEnabled(_enabled);
1317     }
1318 
1319     function setTaxEnabled(bool _enabled) external onlyOwner {
1320         taxEnabled = _enabled;
1321         emit TaxEnabled(_enabled);
1322     }
1323 
1324     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1325         compoundingEnabled = _enabled;
1326         emit CompoundingEnabled(_enabled);
1327     }
1328 
1329     function updateDividendSettings(
1330         bool _swapEnabled,
1331         uint256 _swapTokensAtAmount,
1332         bool _swapAllToken
1333     ) external onlyOwner {
1334         swapEnabled = _swapEnabled;
1335         swapTokensAtAmount = _swapTokensAtAmount;
1336         swapAllToken = _swapAllToken;
1337     }
1338 
1339     function setMaxTxBPS(uint256 bps) external onlyOwner {
1340         require(bps >= 75 && bps <= 10000);
1341         maxTxBPS = bps;
1342     }
1343 
1344     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1345         _isExcludedFromMaxTx[account] = excluded;
1346     }
1347 
1348     function isExcludedFromMaxTx(address account) public view returns (bool) {
1349         return _isExcludedFromMaxTx[account];
1350     }
1351 
1352     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1353         require(
1354             bps >= 175 && bps <= 10000
1355         );
1356         maxWalletBPS = bps;
1357     }
1358 
1359     function excludeFromMaxWallet(address account, bool excluded)
1360         public
1361         onlyOwner
1362     {
1363         _isExcludedFromMaxWallet[account] = excluded;
1364     }
1365 
1366     function isExcludedFromMaxWallet(address account)
1367         public
1368         view
1369         returns (bool)
1370     {
1371         return _isExcludedFromMaxWallet[account];
1372     }
1373 
1374     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1375         IERC20(_token).transfer(msg.sender, _amount);
1376     }
1377 
1378     function rescueETH(uint256 _amount) external onlyOwner {
1379         payable(msg.sender).transfer(_amount);
1380     }
1381 
1382     function blackList(address _user) public onlyOwner {
1383         require(!isBlacklisted[_user]);
1384         isBlacklisted[_user] = true;
1385         // events?
1386     }
1387 
1388     function removeFromBlacklist(address _user) public onlyOwner {
1389         require(isBlacklisted[_user]);
1390         isBlacklisted[_user] = false;
1391         //events?
1392     }
1393 
1394     // function blackListMany(address[] memory _users) public onlyOwner {
1395     //     for (uint8 i = 0; i < _users.length; i++) {
1396     //         isBlacklisted[_users[i]] = true;
1397     //     }
1398     // }
1399 
1400     // function unBlackListMany(address[] memory _users) public onlyOwner {
1401     //     for (uint8 i = 0; i < _users.length; i++) {
1402     //         isBlacklisted[_users[i]] = false;
1403     //     }
1404     // }
1405 }