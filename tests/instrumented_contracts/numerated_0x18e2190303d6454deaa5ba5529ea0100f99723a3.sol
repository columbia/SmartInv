1 /*
2 __/\\\\\\\\\\\\\\\____/\\\\\\\\\______/\\\\\\\\\\\__/\\\\\\\\\\\\\_________/\\\\\_______/\\\\\\\\\\\\\\\_        
3  _\///////\\\/////___/\\\///////\\\___\/////\\\///__\/\\\/////////\\\_____/\\\///\\\____\///////\\\/////__       
4   _______\/\\\_______\/\\\_____\/\\\_______\/\\\_____\/\\\_______\/\\\___/\\\/__\///\\\________\/\\\_______      
5    _______\/\\\_______\/\\\\\\\\\\\/________\/\\\_____\/\\\\\\\\\\\\\\___/\\\______\//\\\_______\/\\\_______     
6     _______\/\\\_______\/\\\//////\\\________\/\\\_____\/\\\/////////\\\_\/\\\_______\/\\\_______\/\\\_______    
7      _______\/\\\_______\/\\\____\//\\\_______\/\\\_____\/\\\_______\/\\\_\//\\\______/\\\________\/\\\_______   
8       _______\/\\\_______\/\\\_____\//\\\______\/\\\_____\/\\\_______\/\\\__\///\\\__/\\\__________\/\\\_______  
9        _______\/\\\_______\/\\\______\//\\\__/\\\\\\\\\\\_\/\\\\\\\\\\\\\/_____\///\\\\\/___________\/\\\_______ 
10         _______\///________\///________\///__\///////////__\/////////////_________\/////_____________\///________
11 */// SPDX-License-Identifier: MIT
12 // File: @openzeppelin/contracts/utils/Context.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 // File: @openzeppelin/contracts/access/Ownable.sol
40 
41 
42 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         _checkOwner();
76         _;
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if the sender is not the owner.
88      */
89     function _checkOwner() internal view virtual {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91     }
92 
93     /**
94      * @dev Leaves the contract without owner. It will not be possible to call
95      * `onlyOwner` functions. Can only be called by the current owner.
96      *
97      * NOTE: Renouncing ownership will leave the contract without an owner,
98      * thereby disabling any functionality that is only available to the owner.
99      */
100     function renounceOwnership() public virtual onlyOwner {
101         _transferOwnership(address(0));
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         _transferOwnership(newOwner);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Internal function without access restriction.
116      */
117     function _transferOwnership(address newOwner) internal virtual {
118         address oldOwner = _owner;
119         _owner = newOwner;
120         emit OwnershipTransferred(oldOwner, newOwner);
121     }
122 }
123 
124 // File: conrcat.sol
125 
126 
127 pragma solidity ^0.8.10;
128 pragma experimental ABIEncoderV2;
129 
130 
131 interface IERC20 {
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
143      * @dev Moves `amount` tokens from the caller's account to `recipient`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(
150         address recipient,
151         uint256 amount
152     ) external returns (bool);
153 
154     function allowance(
155         address owner,
156         address spender
157     ) external view returns (uint256);
158 
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(
180         address indexed owner,
181         address indexed spender,
182         uint256 value
183     );
184 }
185 
186 interface IERC20Metadata is IERC20 {
187     /**
188      * @dev Returns the name of the token.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the symbol of the token.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the decimals places of the token.
199      */
200     function decimals() external view returns (uint8);
201 }
202 
203 contract ERC20 is Context, IERC20, IERC20Metadata {
204     mapping(address => uint256) private _balances;
205 
206     mapping(address => mapping(address => uint256)) private _allowances;
207 
208     uint256 private _totalSupply;
209 
210     string private _name;
211     string private _symbol;
212 
213     /**
214      * @dev Sets the values for {name} and {symbol}.
215      *
216      * The default value of {decimals} is 18. To select a different value for
217      * {decimals} you should overload it.
218      *
219      * All two of these values are immutable: they can only be set once during
220      * construction.
221      */
222     constructor(string memory name_, string memory symbol_) {
223         _name = name_;
224         _symbol = symbol_;
225     }
226 
227     /**
228      * @dev Returns the name of the token.
229      */
230     function name() public view virtual override returns (string memory) {
231         return _name;
232     }
233 
234     /**
235      * @dev Returns the symbol of the token, usually a shorter version of the
236      * name.
237      */
238     function symbol() public view virtual override returns (string memory) {
239         return _symbol;
240     }
241 
242     function decimals() public view virtual override returns (uint8) {
243         return 18;
244     }
245 
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(
257         address account
258     ) public view virtual override returns (uint256) {
259         return _balances[account];
260     }
261 
262     function transfer(
263         address recipient,
264         uint256 amount
265     ) public virtual override returns (bool) {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(
274         address owner,
275         address spender
276     ) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(
288         address spender,
289         uint256 amount
290     ) public virtual override returns (bool) {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         _transfer(sender, recipient, amount);
301 
302         uint256 currentAllowance = _allowances[sender][_msgSender()];
303         require(
304             currentAllowance >= amount,
305             "ERC20: transfer amount exceeds allowance"
306         );
307         unchecked {
308             _approve(sender, _msgSender(), currentAllowance - amount);
309         }
310 
311         return true;
312     }
313 
314     function increaseAllowance(
315         address spender,
316         uint256 addedValue
317     ) public virtual returns (bool) {
318         _approve(
319             _msgSender(),
320             spender,
321             _allowances[_msgSender()][spender] + addedValue
322         );
323         return true;
324     }
325 
326     function decreaseAllowance(
327         address spender,
328         uint256 subtractedValue
329     ) public virtual returns (bool) {
330         uint256 currentAllowance = _allowances[_msgSender()][spender];
331         require(
332             currentAllowance >= subtractedValue,
333             "ERC20: decreased allowance below zero"
334         );
335         unchecked {
336             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
337         }
338 
339         return true;
340     }
341 
342     function _transfer(
343         address sender,
344         address recipient,
345         uint256 amount
346     ) internal virtual {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(sender, recipient, amount);
351 
352         uint256 senderBalance = _balances[sender];
353         require(
354             senderBalance >= amount,
355             "ERC20: transfer amount exceeds balance"
356         );
357         unchecked {
358             _balances[sender] = senderBalance - amount;
359         }
360         _balances[recipient] += amount;
361 
362         emit Transfer(sender, recipient, amount);
363 
364         _afterTokenTransfer(sender, recipient, amount);
365     }
366 
367     function _mint(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: mint to the zero address");
369 
370         _beforeTokenTransfer(address(0), account, amount);
371 
372         _totalSupply += amount;
373         _balances[account] += amount;
374         emit Transfer(address(0), account, amount);
375 
376         _afterTokenTransfer(address(0), account, amount);
377     }
378 
379     function _burn(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _beforeTokenTransfer(account, address(0), amount);
383 
384         uint256 accountBalance = _balances[account];
385         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
386         unchecked {
387             _balances[account] = accountBalance - amount;
388         }
389         _totalSupply -= amount;
390 
391         emit Transfer(account, address(0), amount);
392 
393         _afterTokenTransfer(account, address(0), amount);
394     }
395 
396     function _approve(
397         address owner,
398         address spender,
399         uint256 amount
400     ) internal virtual {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = amount;
405         emit Approval(owner, spender, amount);
406     }
407 
408     function _beforeTokenTransfer(
409         address from,
410         address to,
411         uint256 amount
412     ) internal virtual {}
413 
414     function _afterTokenTransfer(
415         address from,
416         address to,
417         uint256 amount
418     ) internal virtual {}
419 }
420 
421 interface IUniswapV2Factory {
422     event PairCreated(
423         address indexed token0,
424         address indexed token1,
425         address pair,
426         uint256
427     );
428 
429     function feeTo() external view returns (address);
430 
431     function feeToSetter() external view returns (address);
432 
433     function getPair(
434         address tokenA,
435         address tokenB
436     ) external view returns (address pair);
437 
438     function allPairs(uint256) external view returns (address pair);
439 
440     function allPairsLength() external view returns (uint256);
441 
442     function createPair(
443         address tokenA,
444         address tokenB
445     ) external returns (address pair);
446 
447     function setFeeTo(address) external;
448 
449     function setFeeToSetter(address) external;
450 }
451 
452 interface IUniswapV2Pair {
453     event Approval(
454         address indexed owner,
455         address indexed spender,
456         uint256 value
457     );
458     event Transfer(address indexed from, address indexed to, uint256 value);
459 
460     function name() external pure returns (string memory);
461 
462     function symbol() external pure returns (string memory);
463 
464     function decimals() external pure returns (uint8);
465 
466     function totalSupply() external view returns (uint256);
467 
468     function balanceOf(address owner) external view returns (uint256);
469 
470     function allowance(
471         address owner,
472         address spender
473     ) external view returns (uint256);
474 
475     function approve(address spender, uint256 value) external returns (bool);
476 
477     function transfer(address to, uint256 value) external returns (bool);
478 
479     function transferFrom(
480         address from,
481         address to,
482         uint256 value
483     ) external returns (bool);
484 
485     function DOMAIN_SEPARATOR() external view returns (bytes32);
486 
487     function PERMIT_TYPEHASH() external pure returns (bytes32);
488 
489     function nonces(address owner) external view returns (uint256);
490 
491     function permit(
492         address owner,
493         address spender,
494         uint256 value,
495         uint256 deadline,
496         uint8 v,
497         bytes32 r,
498         bytes32 s
499     ) external;
500 
501     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
502     event Burn(
503         address indexed sender,
504         uint256 amount0,
505         uint256 amount1,
506         address indexed to
507     );
508     event Swap(
509         address indexed sender,
510         uint256 amount0In,
511         uint256 amount1In,
512         uint256 amount0Out,
513         uint256 amount1Out,
514         address indexed to
515     );
516     event Sync(uint112 reserve0, uint112 reserve1);
517 
518     function MINIMUM_LIQUIDITY() external pure returns (uint256);
519 
520     function factory() external view returns (address);
521 
522     function token0() external view returns (address);
523 
524     function token1() external view returns (address);
525 
526     function getReserves()
527         external
528         view
529         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
530 
531     function price0CumulativeLast() external view returns (uint256);
532 
533     function price1CumulativeLast() external view returns (uint256);
534 
535     function kLast() external view returns (uint256);
536 
537     function mint(address to) external returns (uint256 liquidity);
538 
539     function burn(
540         address to
541     ) external returns (uint256 amount0, uint256 amount1);
542 
543     function swap(
544         uint256 amount0Out,
545         uint256 amount1Out,
546         address to,
547         bytes calldata data
548     ) external;
549 
550     function skim(address to) external;
551 
552     function sync() external;
553 
554     function initialize(address, address) external;
555 }
556 
557 interface IUniswapV2Router02 {
558     function factory() external pure returns (address);
559 
560     function WETH() external pure returns (address);
561 
562     function addLiquidity(
563         address tokenA,
564         address tokenB,
565         uint256 amountADesired,
566         uint256 amountBDesired,
567         uint256 amountAMin,
568         uint256 amountBMin,
569         address to,
570         uint256 deadline
571     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
572 
573     function addLiquidityETH(
574         address token,
575         uint256 amountTokenDesired,
576         uint256 amountTokenMin,
577         uint256 amountETHMin,
578         address to,
579         uint256 deadline
580     )
581         external
582         payable
583         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
584 
585     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
586         uint256 amountIn,
587         uint256 amountOutMin,
588         address[] calldata path,
589         address to,
590         uint256 deadline
591     ) external;
592 
593     function swapExactETHForTokensSupportingFeeOnTransferTokens(
594         uint256 amountOutMin,
595         address[] calldata path,
596         address to,
597         uint256 deadline
598     ) external payable;
599 
600     function swapExactTokensForETHSupportingFeeOnTransferTokens(
601         uint256 amountIn,
602         uint256 amountOutMin,
603         address[] calldata path,
604         address to,
605         uint256 deadline
606     ) external;
607 }
608 
609 //Tribot:  Main Token Contract
610 contract Tribot is ERC20, Ownable {
611     IUniswapV2Router02 public immutable uniswapV2Router;
612     address public immutable uniswapV2Pair;
613     address public deadAddress = address(0xdead);
614 
615     address public botWallet;
616     address public rewardWallet;
617     address public liquidityWallet;
618 
619     uint256 public maxWallet;
620 
621     bool public limitsInEffect = true;
622     bool public tradingActive = false;
623 
624     uint256 public launchedAt;
625     uint256 public launchedAtTimestamp; 
626     uint256 public buyTotalFees = 5;
627     uint256 public buyBotFee = 1;
628     uint256 public buyBurnFee = 1;
629     uint256 public buyLiquidityFee = 1;
630     uint256 public buyRewardFee = 2;
631 
632     uint256 public sellTotalFees = 5;
633     uint256 public sellBotFee = 1;
634     uint256 public sellBurnFee = 1;
635     uint256 public sellLiquidityFee = 1;
636     uint256 public sellRewardFee = 2;
637 
638     uint256 botPercent = 20;
639     uint256 burnPercent= 20;
640     uint256 liquidityPercent = 20;
641     uint256 rewardPercent=40;
642 
643     /******************/
644 
645     // exlcude from fees and max transaction amount
646     mapping(address => bool) private _isExcludedFromFees;
647     mapping(address => bool) public _isExcludedFromMaxWallet;
648 
649     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
650     // could be subject to a maximum transfer amount
651     mapping(address => bool) public automatedMarketMakerPairs;
652 
653     event UpdateUniswapV2Router(
654         address indexed newAddress,
655         address indexed oldAddress
656     );
657 
658     event ExcludeFromFees(address indexed account, bool isExcluded);
659 
660     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
661 
662     event botWalletUpdated(
663         address indexed newWallet,
664         address indexed oldWallet
665     );
666 
667     event RewardWalletUpdated(
668         address indexed newWallet,
669         address indexed oldWallet
670     );
671     event BurnWalletUpdated(
672         address indexed newWallet,
673         address indexed oldWallet
674     );
675     event LiquidityWalletUpdated(
676         address indexed newWallet,
677         address indexed oldWallet
678     );
679 
680     constructor() ERC20("TRIBOT", "TRIBOT") {
681         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
682             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
683         );
684 
685         excludedFromMaxWallet(address(_uniswapV2Router), true);
686         uniswapV2Router = _uniswapV2Router;
687 
688         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
689             .createPair(address(this), _uniswapV2Router.WETH());
690         excludedFromMaxWallet(address(uniswapV2Pair), true);
691         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
692 
693         uint256 totalSupply = 100_000_000 * 1e18; // 100 Million
694 
695         maxWallet = (totalSupply * (2)) / 100; // 2% from total supply maxWallet
696 
697         botWallet = address(0x2b077E82508915F46b0Bc33E3EbaB02DeF1B4798);
698         rewardWallet = address(0x956a7eFD059e3CeD14117E53802d96Bb919a0563);
699         liquidityWallet = address(0xc14D74Bd8Cf130AF332870cDDc936609d938fcf0);
700 
701         // exclude from paying fees or having max transaction amount
702         excludeFromFees(owner(), true);
703 
704         excludeFromFees(address(this), true);
705         excludeFromFees(address(0xdead), true);
706         excludeFromFees(address(0xF78B1f0Fd13d723897cb5732E1797Ed0B48aF152), true);
707 
708 
709         excludedFromMaxWallet(owner(), true);
710         excludedFromMaxWallet(address(this), true);
711         excludedFromMaxWallet(address(0xdead), true);
712         excludedFromMaxWallet(address(0xF78B1f0Fd13d723897cb5732E1797Ed0B48aF152), true);
713         
714 
715         /*
716             _mint is an internal function in ERC20.sol that is only called here,
717             and CANNOT be called ever again
718         */
719         _mint(address(0xF78B1f0Fd13d723897cb5732E1797Ed0B48aF152), totalSupply);
720     }
721 
722     receive() external payable {}
723 
724     function launched() internal view returns (bool) {
725         return launchedAt != 0;
726     }
727 
728     function launch() public onlyOwner {
729         require(launchedAt == 0, "Already launched boi");
730         launchedAt = block.number;
731         launchedAtTimestamp = block.timestamp;
732         tradingActive = true;
733     }
734 
735     // remove limits after token is stable
736     function removeLimits() external onlyOwner returns (bool) {
737         limitsInEffect = false;
738         return true;
739     }
740 
741     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
742         maxWallet = newNum * (10 ** 18);
743     }
744 
745     function excludedFromMaxWallet(address updAds, bool isEx) public onlyOwner {
746         _isExcludedFromMaxWallet[updAds] = isEx;
747     }
748 
749     function updateBuyFees(
750         uint256 _BotFee,
751         uint256 _rewardFee,
752         uint256 _burnFee,
753         uint256 _liquidityFee
754     ) external onlyOwner {
755         buyBotFee = _BotFee;
756         buyRewardFee = _rewardFee;
757         buyBurnFee = _burnFee;
758         buyLiquidityFee = _liquidityFee;
759         buyTotalFees = buyBotFee + buyRewardFee + buyBurnFee + buyLiquidityFee;
760     }
761 
762     function updateSellFees(
763         uint256 _BotFee,
764         uint256 _rewardFee,
765         uint256 _burnFee,
766         uint256 _liquidityFee
767     ) external onlyOwner {
768         sellBotFee = _BotFee;
769         sellRewardFee = _rewardFee;
770         sellBurnFee = _burnFee;
771         sellLiquidityFee = _liquidityFee;
772         sellTotalFees =
773             sellBotFee +
774             sellRewardFee +
775             sellBurnFee +
776             sellLiquidityFee;
777     }
778 
779     function UpdatePercentages(
780         uint256 _Bot,
781         uint256 _reward,
782         uint256 _burn,
783         uint256 _liquidity
784     ) external onlyOwner {
785         botPercent = _Bot;
786         rewardPercent = _reward;
787         burnPercent = _burn;
788         liquidityPercent = _liquidity;
789     }
790 
791     function excludeFromFees(address account, bool excluded) public onlyOwner {
792         _isExcludedFromFees[account] = excluded;
793         emit ExcludeFromFees(account, excluded);
794     }
795 
796     function setAutomatedMarketMakerPair(
797         address pair,
798         bool value
799     ) public onlyOwner {
800         require(
801             pair != uniswapV2Pair,
802             "The pair cannot be removed from automatedMarketMakerPairs"
803         );
804 
805         _setAutomatedMarketMakerPair(pair, value);
806     }
807 
808     function _setAutomatedMarketMakerPair(address pair, bool value) private {
809         automatedMarketMakerPairs[pair] = value;
810 
811         emit SetAutomatedMarketMakerPair(pair, value);
812     }
813 
814     function updateLiquidityWallet(address newWallet) external onlyOwner {
815         emit LiquidityWalletUpdated(newWallet, liquidityWallet);
816         liquidityWallet = newWallet;
817     }
818 
819     function UpdateBurnWallet(address newWallet) external onlyOwner {
820         emit BurnWalletUpdated(newWallet, deadAddress);
821         deadAddress = newWallet;
822     }
823 
824     function updatebotWallet(address newbotWallet) external onlyOwner {
825         emit botWalletUpdated(newbotWallet, botWallet);
826         botWallet = newbotWallet;
827     }
828 
829     function UpdateRewardWallet(address newWallet) external onlyOwner {
830         emit RewardWalletUpdated(newWallet, rewardWallet);
831         rewardWallet = newWallet;
832     }
833 
834     function isExcludedFromFees(address account) public view returns (bool) {
835         return _isExcludedFromFees[account];
836     }
837 
838     function _transfer(
839         address from,
840         address to,
841         uint256 amount
842     ) internal override {
843         require(from != address(0), "ERC20: transfer from the zero address");
844         require(to != address(0), "ERC20: transfer to the zero address");
845 
846         if (amount == 0) {
847             super._transfer(from, to, 0);
848             return;
849         }
850 
851         if (limitsInEffect) {
852             if (
853                 from != owner() &&
854                 to != owner() &&
855                 to != address(0) &&
856                 to != address(0xdead)
857             ) {
858                 if (!tradingActive) {
859                     require(
860                         !automatedMarketMakerPairs[from] &&
861                             !automatedMarketMakerPairs[to],
862                         "Trading is not active."
863                     );
864                 }
865                 //when buy
866                 if (
867                     automatedMarketMakerPairs[from] &&
868                     !_isExcludedFromMaxWallet[to]
869                 ) {
870                     require(
871                         amount + balanceOf(to) <= maxWallet,
872                         "Max wallet exceeded"
873                     );
874                 }
875             }
876         }
877 
878         bool takeFee = true;
879 
880         // if any account belongs to _isExcludedFromFee account then remove the fee
881         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
882             takeFee = false;
883         }
884 
885         uint256 fees = 0;
886         // only take fees on buys/sells, do not take on wallet transfers
887         if (takeFee) {
888             // on sell
889             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
890                 fees = (amount * sellTotalFees) / 100;
891             }
892             // on buy
893             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
894                 fees = (amount * buyTotalFees) / 100;
895             }
896 
897             if (fees > 0) {
898                 super._transfer(from, botWallet, (fees * botPercent) / 100);
899                 super._transfer(
900                     from,
901                     rewardWallet,
902                     (fees * rewardPercent) / 100
903                 );
904                 super._transfer(
905                     from,
906                     liquidityWallet,
907                     (fees * liquidityPercent) / 100
908                 );
909                 _burn(from, (fees * burnPercent) / 100);
910             }
911 
912             amount -= fees;
913         }
914 
915         super._transfer(from, to, amount);
916     }
917 
918     function withdrawETH(uint256 _amount) external onlyOwner {
919         require(address(this).balance >= _amount, "Invalid Amount");
920         payable(msg.sender).transfer(_amount);
921     }
922 
923     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
924         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
925         _token.transfer(msg.sender, _amount);
926     }
927 
928     function burnTokens(uint256 _amount) external onlyOwner {
929         _burn(msg.sender, _amount);
930     }
931     function Distribution(
932         address[] calldata addresses,
933         uint256[] calldata amounts
934     ) external onlyOwner {
935         require(
936             addresses.length == amounts.length,
937             "Array sizes must be equal"
938         );
939         uint256 i = 0;
940         while (i < addresses.length) {
941             uint256 _amount = amounts[i]*(1e16);
942             _transfer(msg.sender, addresses[i], _amount);
943             i += 1;
944         }
945     }
946     
947 }