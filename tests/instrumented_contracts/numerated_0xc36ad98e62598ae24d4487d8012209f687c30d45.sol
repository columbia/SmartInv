1 /*
2 Token Name : ASAP - Auto discord dex sniper BOT
3 SYMBOL : ASAP
4 The fastest discord DEX (uniswap, pancakeswap ) sniper bot , Be the first to buy the next 1000X tokens.
5 Buy/sell Tax 4/4: 
6 Treasury : 2% 
7 liquidity Pool : 1%
8 Holders reward (paid in ether) : 1%
9 website : https://asapbot.xyz/
10 twitter : https://twitter.com/MyAsapBot
11 Telegram :https://t.me/myasapbot
12 
13 Features
14 New Token listing
15 Manual Buy/Sell
16 Auto-Buying
17 Degen Vault
18 Hold & Earn
19 */
20 // SPDX-License-Identifier: MIT
21 pragma solidity 0.8.10;
22 
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender)
55         external
56         view
57         returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `from` to `to` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(
103         address indexed owner,
104         address indexed spender,
105         uint256 value
106     );
107 }
108 
109 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
110 
111 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
112 
113 /**
114  * @dev Provides information about the current execution context, including the
115  * sender of the transaction and its data. While these are generally available
116  * via msg.sender and msg.data, they should not be accessed in such a direct
117  * manner, since when dealing with meta-transactions the account sending and
118  * paying for execution may not be the actual sender (as far as an application
119  * is concerned).
120  *
121  * This contract is only required for intermediate, library-like contracts.
122  */
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes calldata) {
129         return msg.data;
130     }
131 }
132 
133 /**
134  * @dev Contract module which provides a basic access control mechanism, where
135  * there is an account (an owner) that can be granted exclusive access to
136  * specific functions.
137  *
138  * By default, the owner account will be the one that deploys the contract. This
139  * can later be changed with {transferOwnership}.
140  *
141  * This module is used through inheritance. It will make available the modifier
142  * `onlyOwner`, which can be applied to your functions to restrict their use to
143  * the owner.
144  */
145 abstract contract Ownable is Context {
146     address private _owner;
147 
148     event OwnershipTransferred(
149         address indexed previousOwner,
150         address indexed newOwner
151     );
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor() {
157         _transferOwnership(_msgSender());
158     }
159 
160     /**
161      * @dev Returns the address of the current owner.
162      */
163     function owner() public view virtual returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
172         _;
173     }
174 
175     /**
176      * @dev Leaves the contract without owner. It will not be possible to call
177      * `onlyOwner` functions anymore. Can only be called by the current owner.
178      *
179      * NOTE: Renouncing ownership will leave the contract without an owner,
180      * thereby removing any functionality that is only available to the owner.
181      */
182     function renounceOwnership() public virtual onlyOwner {
183         _transferOwnership(address(0));
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Can only be called by the current owner.
189      */
190     function transferOwnership(address newOwner) public virtual onlyOwner {
191         require(
192             newOwner != address(0),
193             "Ownable: new owner is the zero address"
194         );
195         _transferOwnership(newOwner);
196     }
197 
198     /**
199      * @dev Transfers ownership of the contract to a new account (`newOwner`).
200      * Internal function without access restriction.
201      */
202     function _transferOwnership(address newOwner) internal virtual {
203         address oldOwner = _owner;
204         _owner = newOwner;
205         emit OwnershipTransferred(oldOwner, newOwner);
206     }
207 }
208 
209 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
210 
211 /**
212  * @dev Contract module which allows children to implement an emergency stop
213  * mechanism that can be triggered by an authorized account.
214  *
215  * This module is used through inheritance. It will make available the
216  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
217  * the functions of your contract. Note that they will not be pausable by
218  * simply including this module, only once the modifiers are put in place.
219  */
220 abstract contract Pausable is Context {
221     /**
222      * @dev Emitted when the pause is triggered by `account`.
223      */
224     event Paused(address account);
225 
226     /**
227      * @dev Emitted when the pause is lifted by `account`.
228      */
229     event Unpaused(address account);
230 
231     bool private _paused;
232 
233     /**
234      * @dev Initializes the contract in unpaused state.
235      */
236     constructor() {
237         _paused = false;
238     }
239 
240     /**
241      * @dev Returns true if the contract is paused, and false otherwise.
242      */
243     function paused() public view virtual returns (bool) {
244         return _paused;
245     }
246 
247     /**
248      * @dev Modifier to make a function callable only when the contract is not paused.
249      *
250      * Requirements:
251      *
252      * - The contract must not be paused.
253      */
254     modifier whenNotPaused() {
255         require(!paused(), "Pausable: paused");
256         _;
257     }
258 
259     /**
260      * @dev Modifier to make a function callable only when the contract is paused.
261      *
262      * Requirements:
263      *
264      * - The contract must be paused.
265      */
266     modifier whenPaused() {
267         require(paused(), "Pausable: not paused");
268         _;
269     }
270 
271     /**
272      * @dev Triggers stopped state.
273      *
274      * Requirements:
275      *
276      * - The contract must not be paused.
277      */
278     function _pause() internal virtual whenNotPaused {
279         _paused = true;
280         emit Paused(_msgSender());
281     }
282 
283     /**
284      * @dev Returns to normal state.
285      *
286      * Requirements:
287      *
288      * - The contract must be paused.
289      */
290     function _unpause() internal virtual whenPaused {
291         _paused = false;
292         emit Unpaused(_msgSender());
293     }
294 }
295 
296 interface IUniswapV2Router01 {
297     function factory() external pure returns (address);
298 
299     function WETH() external pure returns (address);
300 
301     function addLiquidity(
302         address tokenA,
303         address tokenB,
304         uint256 amountADesired,
305         uint256 amountBDesired,
306         uint256 amountAMin,
307         uint256 amountBMin,
308         address to,
309         uint256 deadline
310     )
311         external
312         returns (
313             uint256 amountA,
314             uint256 amountB,
315             uint256 liquidity
316         );
317 
318     function addLiquidityETH(
319         address token,
320         uint256 amountTokenDesired,
321         uint256 amountTokenMin,
322         uint256 amountETHMin,
323         address to,
324         uint256 deadline
325     )
326         external
327         payable
328         returns (
329             uint256 amountToken,
330             uint256 amountETH,
331             uint256 liquidity
332         );
333 
334     function removeLiquidity(
335         address tokenA,
336         address tokenB,
337         uint256 liquidity,
338         uint256 amountAMin,
339         uint256 amountBMin,
340         address to,
341         uint256 deadline
342     ) external returns (uint256 amountA, uint256 amountB);
343 
344     function removeLiquidityETH(
345         address token,
346         uint256 liquidity,
347         uint256 amountTokenMin,
348         uint256 amountETHMin,
349         address to,
350         uint256 deadline
351     ) external returns (uint256 amountToken, uint256 amountETH);
352 
353     function removeLiquidityWithPermit(
354         address tokenA,
355         address tokenB,
356         uint256 liquidity,
357         uint256 amountAMin,
358         uint256 amountBMin,
359         address to,
360         uint256 deadline,
361         bool approveMax,
362         uint8 v,
363         bytes32 r,
364         bytes32 s
365     ) external returns (uint256 amountA, uint256 amountB);
366 
367     function removeLiquidityETHWithPermit(
368         address token,
369         uint256 liquidity,
370         uint256 amountTokenMin,
371         uint256 amountETHMin,
372         address to,
373         uint256 deadline,
374         bool approveMax,
375         uint8 v,
376         bytes32 r,
377         bytes32 s
378     ) external returns (uint256 amountToken, uint256 amountETH);
379 
380     function swapExactTokensForTokens(
381         uint256 amountIn,
382         uint256 amountOutMin,
383         address[] calldata path,
384         address to,
385         uint256 deadline
386     ) external returns (uint256[] memory amounts);
387 
388     function swapTokensForExactTokens(
389         uint256 amountOut,
390         uint256 amountInMax,
391         address[] calldata path,
392         address to,
393         uint256 deadline
394     ) external returns (uint256[] memory amounts);
395 
396     function swapExactETHForTokens(
397         uint256 amountOutMin,
398         address[] calldata path,
399         address to,
400         uint256 deadline
401     ) external payable returns (uint256[] memory amounts);
402 
403     function swapTokensForExactETH(
404         uint256 amountOut,
405         uint256 amountInMax,
406         address[] calldata path,
407         address to,
408         uint256 deadline
409     ) external returns (uint256[] memory amounts);
410 
411     function swapExactTokensForETH(
412         uint256 amountIn,
413         uint256 amountOutMin,
414         address[] calldata path,
415         address to,
416         uint256 deadline
417     ) external returns (uint256[] memory amounts);
418 
419     function swapETHForExactTokens(
420         uint256 amountOut,
421         address[] calldata path,
422         address to,
423         uint256 deadline
424     ) external payable returns (uint256[] memory amounts);
425 
426     function quote(
427         uint256 amountA,
428         uint256 reserveA,
429         uint256 reserveB
430     ) external pure returns (uint256 amountB);
431 
432     function getAmountOut(
433         uint256 amountIn,
434         uint256 reserveIn,
435         uint256 reserveOut
436     ) external pure returns (uint256 amountOut);
437 
438     function getAmountIn(
439         uint256 amountOut,
440         uint256 reserveIn,
441         uint256 reserveOut
442     ) external pure returns (uint256 amountIn);
443 
444     function getAmountsOut(uint256 amountIn, address[] calldata path)
445         external
446         view
447         returns (uint256[] memory amounts);
448 
449     function getAmountsIn(uint256 amountOut, address[] calldata path)
450         external
451         view
452         returns (uint256[] memory amounts);
453 }
454 
455 interface IUniswapV2Router02 is IUniswapV2Router01 {
456     function removeLiquidityETHSupportingFeeOnTransferTokens(
457         address token,
458         uint256 liquidity,
459         uint256 amountTokenMin,
460         uint256 amountETHMin,
461         address to,
462         uint256 deadline
463     ) external returns (uint256 amountETH);
464 
465     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
466         address token,
467         uint256 liquidity,
468         uint256 amountTokenMin,
469         uint256 amountETHMin,
470         address to,
471         uint256 deadline,
472         bool approveMax,
473         uint8 v,
474         bytes32 r,
475         bytes32 s
476     ) external returns (uint256 amountETH);
477 
478     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
479         uint256 amountIn,
480         uint256 amountOutMin,
481         address[] calldata path,
482         address to,
483         uint256 deadline
484     ) external;
485 
486     function swapExactETHForTokensSupportingFeeOnTransferTokens(
487         uint256 amountOutMin,
488         address[] calldata path,
489         address to,
490         uint256 deadline
491     ) external payable;
492 
493     function swapExactTokensForETHSupportingFeeOnTransferTokens(
494         uint256 amountIn,
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external;
500 }
501 
502 interface IUniswapV2Factory {
503     event PairCreated(
504         address indexed token0,
505         address indexed token1,
506         address pair,
507         uint256
508     );
509 
510     function feeTo() external view returns (address);
511 
512     function feeToSetter() external view returns (address);
513 
514     function getPair(address tokenA, address tokenB)
515         external
516         view
517         returns (address pair);
518 
519     function allPairs(uint256) external view returns (address pair);
520 
521     function allPairsLength() external view returns (uint256);
522 
523     function createPair(address tokenA, address tokenB)
524         external
525         returns (address pair);
526 
527     function setFeeTo(address) external;
528 
529     function setFeeToSetter(address) external;
530 }
531 
532 interface IUniswapV2Pair {
533     event Approval(
534         address indexed owner,
535         address indexed spender,
536         uint256 value
537     );
538     event Transfer(address indexed from, address indexed to, uint256 value);
539 
540     function name() external pure returns (string memory);
541 
542     function symbol() external pure returns (string memory);
543 
544     function decimals() external pure returns (uint8);
545 
546     function totalSupply() external view returns (uint256);
547 
548     function balanceOf(address owner) external view returns (uint256);
549 
550     function allowance(address owner, address spender)
551         external
552         view
553         returns (uint256);
554 
555     function approve(address spender, uint256 value) external returns (bool);
556 
557     function transfer(address to, uint256 value) external returns (bool);
558 
559     function transferFrom(
560         address from,
561         address to,
562         uint256 value
563     ) external returns (bool);
564 
565     function DOMAIN_SEPARATOR() external view returns (bytes32);
566 
567     function PERMIT_TYPEHASH() external pure returns (bytes32);
568 
569     function nonces(address owner) external view returns (uint256);
570 
571     function permit(
572         address owner,
573         address spender,
574         uint256 value,
575         uint256 deadline,
576         uint8 v,
577         bytes32 r,
578         bytes32 s
579     ) external;
580 
581     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
582     event Burn(
583         address indexed sender,
584         uint256 amount0,
585         uint256 amount1,
586         address indexed to
587     );
588     event Swap(
589         address indexed sender,
590         uint256 amount0In,
591         uint256 amount1In,
592         uint256 amount0Out,
593         uint256 amount1Out,
594         address indexed to
595     );
596     event Sync(uint112 reserve0, uint112 reserve1);
597 
598     function MINIMUM_LIQUIDITY() external pure returns (uint256);
599 
600     function factory() external view returns (address);
601 
602     function token0() external view returns (address);
603 
604     function token1() external view returns (address);
605 
606     function getReserves()
607         external
608         view
609         returns (
610             uint112 reserve0,
611             uint112 reserve1,
612             uint32 blockTimestampLast
613         );
614 
615     function price0CumulativeLast() external view returns (uint256);
616 
617     function price1CumulativeLast() external view returns (uint256);
618 
619     function kLast() external view returns (uint256);
620 
621     function mint(address to) external returns (uint256 liquidity);
622 
623     function burn(address to)
624         external
625         returns (uint256 amount0, uint256 amount1);
626 
627     function swap(
628         uint256 amount0Out,
629         uint256 amount1Out,
630         address to,
631         bytes calldata data
632     ) external;
633 
634     function skim(address to) external;
635 
636     function sync() external;
637 
638     function initialize(address, address) external;
639 }
640 
641 contract ASAP is Pausable, Ownable, IERC20 {
642     address constant UNISWAPROUTER =
643         address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
644     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
645     address constant ZERO = 0x0000000000000000000000000000000000000000;
646 
647     string private constant _name = "Asap Sniper Bot";
648     string private constant _symbol = "ASAP";
649 
650     uint256 public buyTreasuryFeeBPS = 200;
651     uint256 public buyLiquidityFeeBPS = 100;
652     uint256 public buyRewardFeeBPS = 100;
653     uint256 public buyTotalFeeBPS = 400;
654 
655     uint256 public sellTreasuryFeeBPS = 200;
656     uint256 public sellLiquidityFeeBPS = 100;
657     uint256 public sellRewardFeeBPS = 100;
658     uint256 public sellTotalFeeBPS = 400;
659 
660     uint256 public tokensForTreasury;
661     uint256 public tokensForLiquidity;
662     uint256 public tokensForRewards;
663 
664     uint256 public swapTokensAtAmount = 100000 * (10**18);
665     uint256 public lastSwapTime;
666     bool swapAllToken = true;
667 
668     bool public swapEnabled = true;
669     bool public taxEnabled = true;
670     bool public transferTaxEnabled = false;
671     bool public compoundingEnabled = true;
672 
673     uint256 private _totalSupply;
674     bool private swapping;
675     bool private isCompounding;
676 
677     address treasuryWallet;
678     address liquidityWallet;
679 
680     mapping(address => uint256) private _balances;
681     mapping(address => mapping(address => uint256)) private _allowances;
682     mapping(address => bool) private _isExcludedFromFees;
683     mapping(address => bool) public automatedMarketMakerPairs;
684     mapping(address => bool) private _whiteList;
685     mapping(address => bool) isBlacklisted;
686 
687     event SwapAndAddLiquidity(
688         uint256 tokensSwapped,
689         uint256 nativeReceived,
690         uint256 tokensIntoLiquidity
691     );
692     event SendRewards(uint256 tokensSwapped, uint256 amount);
693     event SendTreasury(uint256 tokensSwapped, uint256 amount);
694     event ExcludeFromFees(address indexed account, bool isExcluded);
695     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
696     event UpdateUniswapV2Router(
697         address indexed newAddress,
698         address indexed oldAddress
699     );
700     event SwapEnabled(bool enabled);
701     event TaxEnabled(bool enabled);
702     event TransferTaxEnabled(bool enabled);
703     event CompoundingEnabled(bool enabled);
704     event BlacklistEnabled(bool enabled);
705     event SellFeeUpdated(uint256 treasury, uint256 liquidity, uint256 reward);
706     event BuyFeeUpdated(uint256 treasury, uint256 liquidity, uint256 reward);
707     event WalletUpdated(address treasury, address liquidity);
708     event TradingEnabled();
709     event UniswapV2RouterUpdated();
710     event RewardSettingsUpdated(
711         bool swapEnabled,
712         uint256 swapTokensAtAmount,
713         bool swapAllToken
714     );
715     event AccountExcludedFromMaxTx(address account);
716     event AccountExcludedFromMaxWallet(address account);
717     event MaxWalletBPSUpdated(uint256 bps);
718     event TokenRescued(address token, uint256 amount);
719     event ETHRescued(uint256 amount);
720     event AccountBlacklisted(address account);
721     event AccountWhitelisted(address account);
722     event LogErrorString(string message);
723 
724     RewardTracker public immutable rewardTracker;
725     IUniswapV2Router02 public uniswapV2Router;
726 
727     address public uniswapV2Pair;
728 
729     uint256 public maxTxBPS = 50;
730     uint256 public maxWalletBPS = 250;
731 
732     bool isOpen = false;
733 
734     mapping(address => bool) private _isExcludedFromMaxTx;
735     mapping(address => bool) private _isExcludedFromMaxWallet;
736 
737     constructor() {
738         treasuryWallet = owner();
739         liquidityWallet = owner();
740 
741         rewardTracker = new RewardTracker(address(this), UNISWAPROUTER);
742 
743         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
744 
745         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
746             .createPair(address(this), _uniswapV2Router.WETH());
747 
748         uniswapV2Router = _uniswapV2Router;
749         uniswapV2Pair = _uniswapV2Pair;
750 
751         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
752 
753         rewardTracker.excludeFromRewards(address(rewardTracker), true);
754         rewardTracker.excludeFromRewards(address(this), true);
755         rewardTracker.excludeFromRewards(owner(), true);
756         rewardTracker.excludeFromRewards(address(_uniswapV2Router), true);
757 
758         excludeFromFees(owner(), true);
759         excludeFromFees(address(this), true);
760         excludeFromFees(address(rewardTracker), true);
761 
762         excludeFromMaxTx(owner(), true);
763         excludeFromMaxTx(address(this), true);
764         excludeFromMaxTx(address(rewardTracker), true);
765 
766         excludeFromMaxWallet(owner(), true);
767         excludeFromMaxWallet(address(this), true);
768         excludeFromMaxWallet(address(rewardTracker), true);
769 
770         _mint(owner(), 1000000000 * (10**18));
771     }
772 
773     receive() external payable {}
774 
775     function name() public pure returns (string memory) {
776         return _name;
777     }
778 
779     function symbol() public pure returns (string memory) {
780         return _symbol;
781     }
782 
783     function decimals() public pure returns (uint8) {
784         return 18;
785     }
786 
787     function totalSupply() public view virtual override returns (uint256) {
788         return _totalSupply;
789     }
790 
791     function balanceOf(address account)
792         public
793         view
794         virtual
795         override
796         returns (uint256)
797     {
798         return _balances[account];
799     }
800 
801     function allowance(address owner, address spender)
802         public
803         view
804         virtual
805         override
806         returns (uint256)
807     {
808         return _allowances[owner][spender];
809     }
810 
811     function approve(address spender, uint256 amount)
812         public
813         virtual
814         override
815         returns (bool)
816     {
817         _approve(_msgSender(), spender, amount);
818         return true;
819     }
820 
821     function increaseAllowance(address spender, uint256 addedValue)
822         public
823         returns (bool)
824     {
825         _approve(
826             _msgSender(),
827             spender,
828             _allowances[_msgSender()][spender] + addedValue
829         );
830         return true;
831     }
832 
833     function decreaseAllowance(address spender, uint256 subtractedValue)
834         public
835         returns (bool)
836     {
837         uint256 currentAllowance = _allowances[_msgSender()][spender];
838         require(
839             currentAllowance >= subtractedValue,
840             "ASAP: decreased allowance below zero"
841         );
842         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
843         return true;
844     }
845 
846     function transfer(address recipient, uint256 amount)
847         public
848         virtual
849         override
850         returns (bool)
851     {
852         _transfer(_msgSender(), recipient, amount);
853         return true;
854     }
855 
856     function transferFrom(
857         address sender,
858         address recipient,
859         uint256 amount
860     ) public virtual override returns (bool) {
861         _transfer(sender, recipient, amount);
862         uint256 currentAllowance = _allowances[sender][_msgSender()];
863         require(
864             currentAllowance >= amount,
865             "ASAP: transfer amount exceeds allowance"
866         );
867         _approve(sender, _msgSender(), currentAllowance - amount);
868         return true;
869     }
870 
871     function openTrading() external onlyOwner {
872         isOpen = true;
873         emit TradingEnabled();
874     }
875 
876     function pause() public onlyOwner {
877         _pause();
878     }
879 
880     function unpause() public onlyOwner {
881         _unpause();
882     }
883 
884     function _transfer(
885         address sender,
886         address recipient,
887         uint256 amount
888     ) internal {
889         require(
890             isOpen ||
891                 sender == owner() ||
892                 recipient == owner() ||
893                 _whiteList[sender] ||
894                 _whiteList[recipient],
895             "Not Open"
896         );
897 
898         require(!isBlacklisted[sender], "ASAP: Sender is blacklisted");
899         require(!isBlacklisted[recipient], "ASAP: Recipient is blacklisted");
900 
901         require(sender != address(0), "ASAP: transfer from the zero address");
902         require(recipient != address(0), "ASAP: transfer to the zero address");
903 
904         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
905         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
906         require(
907             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
908             "TX Limit Exceeded"
909         );
910 
911         if (
912             sender != owner() &&
913             recipient != address(this) &&
914             recipient != address(DEAD) &&
915             recipient != uniswapV2Pair
916         ) {
917             uint256 currentBalance = balanceOf(recipient);
918             require(
919                 _isExcludedFromMaxWallet[recipient] ||
920                     (currentBalance + amount <= _maxWallet),
921                 "Wallet hold too large amount of token"
922             );
923         }
924 
925         uint256 senderBalance = _balances[sender];
926         require(
927             senderBalance >= amount,
928             "ASAP: transfer amount exceeds balance"
929         );
930 
931         uint256 contractTokenBalance = balanceOf(address(this));
932         uint256 contractNativeBalance = address(this).balance;
933 
934         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
935 
936         if (
937             swapEnabled && // True
938             canSwap && // true
939             !swapping && // swapping=false !false true
940             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
941             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
942             sender != owner() &&
943             recipient != owner()
944         ) {
945             swapping = true;
946 
947             if (!swapAllToken) {
948                 contractTokenBalance = swapTokensAtAmount;
949             }
950             _executeSwap(contractTokenBalance, contractNativeBalance);
951 
952             lastSwapTime = block.timestamp;
953             swapping = false;
954         }
955 
956         bool takeFee;
957 
958         if (
959             sender == address(uniswapV2Pair) ||
960             recipient == address(uniswapV2Pair) ||
961             automatedMarketMakerPairs[recipient] ||
962             automatedMarketMakerPairs[sender] ||
963             transferTaxEnabled
964         ) {
965             takeFee = true;
966         }
967 
968         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
969             takeFee = false;
970         }
971 
972         if (swapping || isCompounding || !taxEnabled) {
973             takeFee = false;
974         }
975 
976         if (takeFee) {
977             uint256 fees;
978             // selling
979             if (automatedMarketMakerPairs[recipient] && sellTotalFeeBPS > 0) {
980                 fees = (amount * sellTotalFeeBPS) / 10000;
981                 tokensForTreasury +=
982                     (fees * sellTreasuryFeeBPS) /
983                     sellTotalFeeBPS;
984                 tokensForRewards += (fees * sellRewardFeeBPS) / sellTotalFeeBPS;
985                 tokensForLiquidity +=
986                     (fees * sellLiquidityFeeBPS) /
987                     sellTotalFeeBPS;
988             } else if (
989                 automatedMarketMakerPairs[sender] && buyTotalFeeBPS > 0
990             ) {
991                 // buying
992                 fees = (amount * buyTotalFeeBPS) / 10000;
993                 tokensForTreasury +=
994                     (fees * buyTreasuryFeeBPS) /
995                     buyTotalFeeBPS;
996                 tokensForRewards += (fees * buyRewardFeeBPS) / buyTotalFeeBPS;
997                 tokensForLiquidity +=
998                     (fees * buyLiquidityFeeBPS) /
999                     buyTotalFeeBPS;
1000             }
1001             amount -= fees;
1002             _executeTransfer(sender, address(this), fees);
1003         }
1004 
1005         _executeTransfer(sender, recipient, amount);
1006 
1007         rewardTracker.setBalance(payable(sender), balanceOf(sender));
1008         rewardTracker.setBalance(payable(recipient), balanceOf(recipient));
1009     }
1010 
1011     function _executeTransfer(
1012         address sender,
1013         address recipient,
1014         uint256 amount
1015     ) private {
1016         require(sender != address(0), "ASAP: transfer from the zero address");
1017         require(recipient != address(0), "ASAP: transfer to the zero address");
1018         uint256 senderBalance = _balances[sender];
1019         require(
1020             senderBalance >= amount,
1021             "ASAP: transfer amount exceeds balance"
1022         );
1023         _balances[sender] = senderBalance - amount;
1024         _balances[recipient] += amount;
1025         emit Transfer(sender, recipient, amount);
1026     }
1027 
1028     function _approve(
1029         address owner,
1030         address spender,
1031         uint256 amount
1032     ) private {
1033         require(owner != address(0), "ASAP: approve from the zero address");
1034         require(spender != address(0), "ASAP: approve to the zero address");
1035         _allowances[owner][spender] = amount;
1036         emit Approval(owner, spender, amount);
1037     }
1038 
1039     function _mint(address account, uint256 amount) private {
1040         require(account != address(0), "ASAP: mint to the zero address");
1041         _totalSupply += amount;
1042         _balances[account] += amount;
1043         emit Transfer(address(0), account, amount);
1044     }
1045 
1046     function _burn(address account, uint256 amount) private {
1047         require(account != address(0), "ASAP: burn from the zero address");
1048         uint256 accountBalance = _balances[account];
1049         require(accountBalance >= amount, "ASAP: burn amount exceeds balance");
1050         _balances[account] = accountBalance - amount;
1051         _totalSupply -= amount;
1052         emit Transfer(account, address(0), amount);
1053     }
1054 
1055     function swapTokensForNative(uint256 tokens) private {
1056         address[] memory path = new address[](2);
1057         path[0] = address(this);
1058         path[1] = uniswapV2Router.WETH();
1059         _approve(address(this), address(uniswapV2Router), tokens);
1060         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1061             tokens,
1062             0, // accept any amount of native
1063             path,
1064             address(this),
1065             block.timestamp
1066         );
1067     }
1068 
1069     function addLiquidity(uint256 tokens, uint256 native) private {
1070         _approve(address(this), address(uniswapV2Router), tokens);
1071         uniswapV2Router.addLiquidityETH{value: native}(
1072             address(this),
1073             tokens,
1074             0, // slippage unavoidable
1075             0, // slippage unavoidable
1076             liquidityWallet,
1077             block.timestamp
1078         );
1079     }
1080 
1081     function includeToWhiteList(address[] memory _users) private {
1082         for (uint8 i = 0; i < _users.length; i++) {
1083             _whiteList[_users[i]] = true;
1084         }
1085     }
1086 
1087     function _executeSwap(uint256 tokens, uint256 native) private {
1088         if (tokens <= 0) {
1089             return;
1090         }
1091 
1092         uint256 swapTokensTreasury;
1093         if (address(treasuryWallet) != address(0)) {
1094             swapTokensTreasury = tokensForTreasury;
1095         }
1096 
1097         uint256 swapTokensRewards;
1098         if (rewardTracker.totalSupply() > 0) {
1099             swapTokensRewards = tokensForRewards;
1100         }
1101 
1102         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1103         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1104         uint256 swapTokensTotal = swapTokensRewards +
1105             swapTokensTreasury +
1106             swapTokensLiquidity;
1107 
1108         uint256 initNativeBal = address(this).balance;
1109         swapTokensForNative(swapTokensTotal);
1110         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1111             native;
1112 
1113         tokensForTreasury = 0;
1114         tokensForRewards = 0;
1115         tokensForLiquidity = 0;
1116 
1117         uint256 nativeTreasury = (nativeSwapped * swapTokensTreasury) /
1118             swapTokensTotal;
1119         uint256 nativeRewards = (nativeSwapped * swapTokensRewards) /
1120             swapTokensTotal;
1121         uint256 nativeLiquidity = nativeSwapped -
1122             nativeTreasury -
1123             nativeRewards;
1124 
1125         if (nativeTreasury > 0) {
1126             (bool success, ) = payable(treasuryWallet).call{
1127                 value: nativeTreasury
1128             }("");
1129             if (success) {
1130                 emit SendTreasury(swapTokensTreasury, nativeTreasury);
1131             } else {
1132                 emit LogErrorString("Wallet failed to receive treasury tokens");
1133             }
1134         }
1135 
1136         addLiquidity(addTokensLiquidity, nativeLiquidity);
1137         emit SwapAndAddLiquidity(
1138             swapTokensLiquidity,
1139             nativeLiquidity,
1140             addTokensLiquidity
1141         );
1142 
1143         if (nativeRewards > 0) {
1144             (bool success, ) = address(rewardTracker).call{
1145                 value: nativeRewards
1146             }("");
1147             if (success) {
1148                 emit SendRewards(swapTokensRewards, nativeRewards);
1149             } else {
1150                 emit LogErrorString("Tracker failed to receive tokens");
1151             }
1152         }
1153     }
1154 
1155     function excludeFromFees(address account, bool excluded) public onlyOwner {
1156         require(
1157             _isExcludedFromFees[account] != excluded,
1158             "ASAP: account is already set to requested state"
1159         );
1160         _isExcludedFromFees[account] = excluded;
1161         emit ExcludeFromFees(account, excluded);
1162     }
1163 
1164     function isExcludedFromFees(address account) public view returns (bool) {
1165         return _isExcludedFromFees[account];
1166     }
1167 
1168     function manualSendReward(uint256 amount, address holder)
1169         external
1170         onlyOwner
1171     {
1172         rewardTracker.manualSendReward(amount, holder);
1173     }
1174 
1175     function excludeFromRewards(address account, bool excluded)
1176         public
1177         onlyOwner
1178     {
1179         rewardTracker.excludeFromRewards(account, excluded);
1180     }
1181 
1182     function isExcludedFromRewards(address account) public view returns (bool) {
1183         return rewardTracker.isExcludedFromRewards(account);
1184     }
1185 
1186     function setWallet(
1187         address payable _treasuryWallet,
1188         address payable _liquidityWallet
1189     ) external onlyOwner {
1190         require(
1191             _liquidityWallet != address(0),
1192             "_liquidityWallet can not be zero address!"
1193         );
1194         require(
1195             _treasuryWallet != address(0),
1196             "_treasuryWallet can not be zero address!"
1197         );
1198 
1199         treasuryWallet = _treasuryWallet;
1200         liquidityWallet = _liquidityWallet;
1201 
1202         emit WalletUpdated(treasuryWallet, liquidityWallet);
1203     }
1204 
1205     function setAutomatedMarketMakerPair(address pair, bool value)
1206         public
1207         onlyOwner
1208     {
1209         require(pair != uniswapV2Pair, "ASAP: DEX pair can not be removed");
1210         _setAutomatedMarketMakerPair(pair, value);
1211     }
1212 
1213     function setBuyFee(
1214         uint256 _treasuryFee,
1215         uint256 _liquidityFee,
1216         uint256 _rewardFee
1217     ) external onlyOwner {
1218         buyTreasuryFeeBPS = _treasuryFee;
1219         buyLiquidityFeeBPS = _liquidityFee;
1220         buyRewardFeeBPS = _rewardFee;
1221         buyTotalFeeBPS = _treasuryFee + _liquidityFee + _rewardFee;
1222         require(buyTotalFeeBPS <= 5000, "Total buy fee is too large");
1223         emit BuyFeeUpdated(_treasuryFee, _liquidityFee, _rewardFee);
1224     }
1225 
1226     function setSellFee(
1227         uint256 _treasuryFee,
1228         uint256 _liquidityFee,
1229         uint256 _rewardFee
1230     ) external onlyOwner {
1231         sellTreasuryFeeBPS = _treasuryFee;
1232         sellLiquidityFeeBPS = _liquidityFee;
1233         sellRewardFeeBPS = _rewardFee;
1234         sellTotalFeeBPS = _treasuryFee + _liquidityFee + _rewardFee;
1235         require(sellTotalFeeBPS <= 5000, "Total sell fee is too large");
1236         emit SellFeeUpdated(_treasuryFee, _liquidityFee, _rewardFee);
1237     }
1238 
1239     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1240         require(
1241             automatedMarketMakerPairs[pair] != value,
1242             "ASAP: automated market maker pair is already set to that value"
1243         );
1244         automatedMarketMakerPairs[pair] = value;
1245         if (value) {
1246             rewardTracker.excludeFromRewards(pair, true);
1247         }
1248         emit SetAutomatedMarketMakerPair(pair, value);
1249     }
1250 
1251     function updateUniswapV2Router(address newAddress) public onlyOwner {
1252         require(
1253             newAddress != address(0),
1254             "uniswapV2Router can not be zero address!"
1255         );
1256         require(
1257             newAddress != address(uniswapV2Router),
1258             "ASAP: the router is already set to the new address"
1259         );
1260 
1261         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1262         uniswapV2Router = IUniswapV2Router02(newAddress);
1263         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1264             .createPair(address(this), uniswapV2Router.WETH());
1265         uniswapV2Pair = _uniswapV2Pair;
1266 
1267         emit UniswapV2RouterUpdated();
1268     }
1269 
1270     function claim() public {
1271         rewardTracker.processAccount(payable(_msgSender()));
1272     }
1273 
1274     function compound() public {
1275         require(compoundingEnabled, "ASAP: compounding is not enabled");
1276         isCompounding = true;
1277         rewardTracker.compoundAccount(payable(_msgSender()));
1278         isCompounding = false;
1279     }
1280 
1281     function withdrawableRewardOf(address account)
1282         public
1283         view
1284         returns (uint256)
1285     {
1286         return rewardTracker.withdrawableRewardOf(account);
1287     }
1288 
1289     function withdrawnRewardOf(address account) public view returns (uint256) {
1290         return rewardTracker.withdrawnRewardOf(account);
1291     }
1292 
1293     function accumulativeRewardOf(address account)
1294         public
1295         view
1296         returns (uint256)
1297     {
1298         return rewardTracker.accumulativeRewardOf(account);
1299     }
1300 
1301     function getAccountInfo(address account)
1302         public
1303         view
1304         returns (
1305             address,
1306             uint256,
1307             uint256,
1308             uint256,
1309             uint256
1310         )
1311     {
1312         return rewardTracker.getAccountInfo(account);
1313     }
1314 
1315     function getLastClaimTime(address account) public view returns (uint256) {
1316         return rewardTracker.getLastClaimTime(account);
1317     }
1318 
1319     function setSwapEnabled(bool _enabled) external onlyOwner {
1320         swapEnabled = _enabled;
1321         emit SwapEnabled(_enabled);
1322     }
1323 
1324     function setTaxEnabled(bool _enabled) external onlyOwner {
1325         taxEnabled = _enabled;
1326         emit TaxEnabled(_enabled);
1327     }
1328 
1329     function setTransferTaxEnabled(bool _enabled) external onlyOwner {
1330         transferTaxEnabled = _enabled;
1331         emit TransferTaxEnabled(_enabled);
1332     }
1333 
1334     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1335         compoundingEnabled = _enabled;
1336         emit CompoundingEnabled(_enabled);
1337     }
1338 
1339     function updateRewardSettings(
1340         bool _swapEnabled,
1341         uint256 _swapTokensAtAmount,
1342         bool _swapAllToken
1343     ) external onlyOwner {
1344         swapEnabled = _swapEnabled;
1345         swapTokensAtAmount = _swapTokensAtAmount;
1346         swapAllToken = _swapAllToken;
1347 
1348         emit RewardSettingsUpdated(
1349             swapEnabled,
1350             swapTokensAtAmount,
1351             swapAllToken
1352         );
1353     }
1354 
1355     function setMaxTxBPS(uint256 bps) external onlyOwner {
1356         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1357         maxTxBPS = bps;
1358     }
1359 
1360     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1361         _isExcludedFromMaxTx[account] = excluded;
1362         emit AccountExcludedFromMaxTx(account);
1363     }
1364 
1365     function isExcludedFromMaxTx(address account) public view returns (bool) {
1366         return _isExcludedFromMaxTx[account];
1367     }
1368 
1369     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1370         require(
1371             bps >= 175 && bps <= 10000,
1372             "BPS must be between 175 and 10000"
1373         );
1374         maxWalletBPS = bps;
1375         emit MaxWalletBPSUpdated(bps);
1376     }
1377 
1378     function excludeFromMaxWallet(address account, bool excluded)
1379         public
1380         onlyOwner
1381     {
1382         _isExcludedFromMaxWallet[account] = excluded;
1383         emit AccountExcludedFromMaxWallet(account);
1384     }
1385 
1386     function isExcludedFromMaxWallet(address account)
1387         public
1388         view
1389         returns (bool)
1390     {
1391         return _isExcludedFromMaxWallet[account];
1392     }
1393 
1394     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1395         IERC20(_token).transfer(msg.sender, _amount);
1396 
1397         emit TokenRescued(_token, _amount);
1398     }
1399 
1400     function rescueETH(uint256 _amount) external onlyOwner {
1401         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1402         require(success, "ETH rescue failed.");
1403         emit ETHRescued(_amount);
1404     }
1405 
1406     function blackList(address _user) public onlyOwner {
1407         require(!isBlacklisted[_user], "user already blacklisted");
1408         isBlacklisted[_user] = true;
1409         emit AccountBlacklisted(_user);
1410     }
1411 
1412     function removeFromBlacklist(address _user) public onlyOwner {
1413         require(isBlacklisted[_user], "user already whitelisted");
1414         isBlacklisted[_user] = false;
1415         emit AccountWhitelisted(_user);
1416     }
1417 
1418     function blackListMany(address[] memory _users) public onlyOwner {
1419         for (uint8 i = 0; i < _users.length; i++) {
1420             blackList(_users[i]);
1421         }
1422     }
1423 
1424     function unBlackListMany(address[] memory _users) public onlyOwner {
1425         for (uint8 i = 0; i < _users.length; i++) {
1426             removeFromBlacklist(_users[i]);
1427         }
1428     }
1429 }
1430 
1431 contract RewardTracker is Ownable, IERC20 {
1432     address immutable UNISWAPROUTER;
1433 
1434     string private constant _name = "ASAP_RewardTracker";
1435     string private constant _symbol = "ASAP_RewardTracker";
1436 
1437     uint256 public lastProcessedIndex;
1438 
1439     uint256 private _totalSupply;
1440     mapping(address => uint256) private _balances;
1441 
1442     uint256 private constant magnitude = 2**128;
1443     uint256 public immutable minTokenBalanceForRewards;
1444     uint256 private magnifiedRewardPerShare;
1445     uint256 public totalRewardsDistributed;
1446     uint256 public totalRewardsWithdrawn;
1447 
1448     address public immutable tokenAddress;
1449 
1450     mapping(address => bool) public excludedFromRewards;
1451     mapping(address => int256) private magnifiedRewardCorrections;
1452     mapping(address => uint256) private withdrawnRewards;
1453     mapping(address => uint256) private lastClaimTimes;
1454 
1455     event RewardsDistributed(address indexed from, uint256 weiAmount);
1456     event RewardWithdrawn(address indexed to, uint256 weiAmount);
1457     event ExcludeFromRewards(address indexed account, bool excluded);
1458     event Claim(address indexed account, uint256 amount);
1459     event Compound(address indexed account, uint256 amount, uint256 tokens);
1460     event LogErrorString(string message);
1461 
1462     struct AccountInfo {
1463         address account;
1464         uint256 withdrawableRewards;
1465         uint256 totalRewards;
1466         uint256 lastClaimTime;
1467     }
1468 
1469     constructor(address _tokenAddress, address _uniswapRouter) {
1470         minTokenBalanceForRewards = 1 * (10**18);
1471         tokenAddress = _tokenAddress;
1472         UNISWAPROUTER = _uniswapRouter;
1473     }
1474 
1475     receive() external payable {
1476         distributeRewards();
1477     }
1478 
1479     function distributeRewards() public payable {
1480         require(_totalSupply > 0, "Total supply invalid");
1481         if (msg.value > 0) {
1482             magnifiedRewardPerShare =
1483                 magnifiedRewardPerShare +
1484                 ((msg.value * magnitude) / _totalSupply);
1485             emit RewardsDistributed(msg.sender, msg.value);
1486             totalRewardsDistributed += msg.value;
1487         }
1488     }
1489 
1490     function setBalance(address payable account, uint256 newBalance)
1491         external
1492         onlyOwner
1493     {
1494         if (excludedFromRewards[account]) {
1495             return;
1496         }
1497         if (newBalance >= minTokenBalanceForRewards) {
1498             _setBalance(account, newBalance);
1499         } else {
1500             _setBalance(account, 0);
1501         }
1502     }
1503 
1504     function excludeFromRewards(address account, bool excluded)
1505         external
1506         onlyOwner
1507     {
1508         require(
1509             excludedFromRewards[account] != excluded,
1510             "ASAP_RewardTracker: account already set to requested state"
1511         );
1512         excludedFromRewards[account] = excluded;
1513         if (excluded) {
1514             _setBalance(account, 0);
1515         } else {
1516             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
1517             if (newBalance >= minTokenBalanceForRewards) {
1518                 _setBalance(account, newBalance);
1519             } else {
1520                 _setBalance(account, 0);
1521             }
1522         }
1523         emit ExcludeFromRewards(account, excluded);
1524     }
1525 
1526     function isExcludedFromRewards(address account) public view returns (bool) {
1527         return excludedFromRewards[account];
1528     }
1529 
1530     function manualSendReward(uint256 amount, address holder)
1531         external
1532         onlyOwner
1533     {
1534         uint256 contractETHBalance = address(this).balance;
1535         (bool success, ) = payable(holder).call{
1536             value: amount > 0 ? amount : contractETHBalance
1537         }("");
1538         require(success, "Manual send failed.");
1539     }
1540 
1541     function _setBalance(address account, uint256 newBalance) internal {
1542         uint256 currentBalance = _balances[account];
1543         if (newBalance > currentBalance) {
1544             uint256 addAmount = newBalance - currentBalance;
1545             _mint(account, addAmount);
1546         } else if (newBalance < currentBalance) {
1547             uint256 subAmount = currentBalance - newBalance;
1548             _burn(account, subAmount);
1549         }
1550     }
1551 
1552     function _mint(address account, uint256 amount) private {
1553         require(
1554             account != address(0),
1555             "ASAP_RewardTracker: mint to the zero address"
1556         );
1557         _totalSupply += amount;
1558         _balances[account] += amount;
1559         emit Transfer(address(0), account, amount);
1560         magnifiedRewardCorrections[account] =
1561             magnifiedRewardCorrections[account] -
1562             int256(magnifiedRewardPerShare * amount);
1563     }
1564 
1565     function _burn(address account, uint256 amount) private {
1566         require(
1567             account != address(0),
1568             "ASAP_RewardTracker: burn from the zero address"
1569         );
1570         uint256 accountBalance = _balances[account];
1571         require(
1572             accountBalance >= amount,
1573             "ASAP_RewardTracker: burn amount exceeds balance"
1574         );
1575         _balances[account] = accountBalance - amount;
1576         _totalSupply -= amount;
1577         emit Transfer(account, address(0), amount);
1578         magnifiedRewardCorrections[account] =
1579             magnifiedRewardCorrections[account] +
1580             int256(magnifiedRewardPerShare * amount);
1581     }
1582 
1583     function processAccount(address payable account)
1584         public
1585         onlyOwner
1586         returns (bool)
1587     {
1588         uint256 amount = _withdrawRewardOfUser(account);
1589         if (amount > 0) {
1590             lastClaimTimes[account] = block.timestamp;
1591             emit Claim(account, amount);
1592             return true;
1593         }
1594         return false;
1595     }
1596 
1597     function _withdrawRewardOfUser(address payable account)
1598         private
1599         returns (uint256)
1600     {
1601         uint256 _withdrawableReward = withdrawableRewardOf(account);
1602         if (_withdrawableReward > 0) {
1603             withdrawnRewards[account] += _withdrawableReward;
1604             totalRewardsWithdrawn += _withdrawableReward;
1605             (bool success, ) = account.call{value: _withdrawableReward}("");
1606             if (!success) {
1607                 withdrawnRewards[account] -= _withdrawableReward;
1608                 totalRewardsWithdrawn -= _withdrawableReward;
1609                 emit LogErrorString("Withdraw failed");
1610                 return 0;
1611             }
1612             emit RewardWithdrawn(account, _withdrawableReward);
1613             return _withdrawableReward;
1614         }
1615         return 0;
1616     }
1617 
1618     function compoundAccount(address payable account)
1619         public
1620         onlyOwner
1621         returns (bool)
1622     {
1623         (uint256 amount, uint256 tokens) = _compoundRewardOfUser(account);
1624         if (amount > 0) {
1625             lastClaimTimes[account] = block.timestamp;
1626             emit Compound(account, amount, tokens);
1627             return true;
1628         }
1629         return false;
1630     }
1631 
1632     function _compoundRewardOfUser(address payable account)
1633         private
1634         returns (uint256, uint256)
1635     {
1636         uint256 _withdrawableReward = withdrawableRewardOf(account);
1637         if (_withdrawableReward > 0) {
1638             withdrawnRewards[account] += _withdrawableReward;
1639             totalRewardsWithdrawn += _withdrawableReward;
1640 
1641             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
1642                 UNISWAPROUTER
1643             );
1644 
1645             address[] memory path = new address[](2);
1646             path[0] = uniswapV2Router.WETH();
1647             path[1] = address(tokenAddress);
1648 
1649             bool success;
1650             uint256 tokens;
1651 
1652             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
1653             try
1654                 uniswapV2Router
1655                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
1656                     value: _withdrawableReward
1657                 }(0, path, address(account), block.timestamp)
1658             {
1659                 success = true;
1660                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
1661             } catch Error(
1662                 string memory /*err*/
1663             ) {
1664                 success = false;
1665             }
1666 
1667             if (!success) {
1668                 withdrawnRewards[account] -= _withdrawableReward;
1669                 totalRewardsWithdrawn -= _withdrawableReward;
1670                 emit LogErrorString("Withdraw failed");
1671                 return (0, 0);
1672             }
1673 
1674             emit RewardWithdrawn(account, _withdrawableReward);
1675             return (_withdrawableReward, tokens);
1676         }
1677         return (0, 0);
1678     }
1679 
1680     function withdrawableRewardOf(address account)
1681         public
1682         view
1683         returns (uint256)
1684     {
1685         return accumulativeRewardOf(account) - withdrawnRewards[account];
1686     }
1687 
1688     function withdrawnRewardOf(address account) public view returns (uint256) {
1689         return withdrawnRewards[account];
1690     }
1691 
1692     function accumulativeRewardOf(address account)
1693         public
1694         view
1695         returns (uint256)
1696     {
1697         int256 a = int256(magnifiedRewardPerShare * balanceOf(account));
1698         int256 b = magnifiedRewardCorrections[account]; // this is an explicit int256 (signed)
1699         return uint256(a + b) / magnitude;
1700     }
1701 
1702     function getAccountInfo(address account)
1703         public
1704         view
1705         returns (
1706             address,
1707             uint256,
1708             uint256,
1709             uint256,
1710             uint256
1711         )
1712     {
1713         AccountInfo memory info;
1714         info.account = account;
1715         info.withdrawableRewards = withdrawableRewardOf(account);
1716         info.totalRewards = accumulativeRewardOf(account);
1717         info.lastClaimTime = lastClaimTimes[account];
1718         return (
1719             info.account,
1720             info.withdrawableRewards,
1721             info.totalRewards,
1722             info.lastClaimTime,
1723             totalRewardsWithdrawn
1724         );
1725     }
1726 
1727     function getLastClaimTime(address account) public view returns (uint256) {
1728         return lastClaimTimes[account];
1729     }
1730 
1731     function name() public pure returns (string memory) {
1732         return _name;
1733     }
1734 
1735     function symbol() public pure returns (string memory) {
1736         return _symbol;
1737     }
1738 
1739     function decimals() public pure returns (uint8) {
1740         return 18;
1741     }
1742 
1743     function totalSupply() public view override returns (uint256) {
1744         return _totalSupply;
1745     }
1746 
1747     function balanceOf(address account) public view override returns (uint256) {
1748         return _balances[account];
1749     }
1750 
1751     function transfer(address, uint256) public pure override returns (bool) {
1752         revert("ASAP_RewardTracker: method not implemented");
1753     }
1754 
1755     function allowance(address, address)
1756         public
1757         pure
1758         override
1759         returns (uint256)
1760     {
1761         revert("ASAP_RewardTracker: method not implemented");
1762     }
1763 
1764     function approve(address, uint256) public pure override returns (bool) {
1765         revert("ASAP_RewardTracker: method not implemented");
1766     }
1767 
1768     function transferFrom(
1769         address,
1770         address,
1771         uint256
1772     ) public pure override returns (bool) {
1773         revert("ASAP_RewardTracker: method not implemented");
1774     }
1775 }