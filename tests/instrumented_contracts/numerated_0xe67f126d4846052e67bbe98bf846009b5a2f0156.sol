1 // SPDX-License-Identifier: MIT
2 
3 // This isn't just gaming - it's real-time toad race and PvP betting rolled into one thrilling experience. 
4 // Website: https://toadrace.gg 
5 // Telegram: https://t.me/toads_gg
6 // Twitter: https://twitter.com/RaceToad
7 
8 
9 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23     address private creator;
24     event OwnershipTransferred(
25         address indexed previousOwner,
26         address indexed newOwner
27     );
28 
29     /**
30      * @dev Initializes the contract setting the deployer as the initial owner.
31      */
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * NOTE: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public virtual onlyOwner {
59         _transferOwnership(address(0));
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Can only be called by the current owner.
65      */
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(
68             newOwner != address(0),
69             "Ownable: new owner is the zero address"
70         );
71         _transferOwnership(newOwner);
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Internal function without access restriction.
77      */
78     function _transferOwnership(address newOwner) internal virtual {
79         address oldOwner = _owner;
80         _owner = newOwner;
81         emit OwnershipTransferred(oldOwner, newOwner);
82     }
83 }
84 
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(
104         address recipient,
105         uint256 amount
106     ) external returns (bool);
107 
108     function allowance(
109         address owner,
110         address spender
111     ) external view returns (uint256);
112 
113     function approve(address spender, uint256 amount) external returns (bool);
114 
115     function transferFrom(
116         address sender,
117         address recipient,
118         uint256 amount
119     ) external returns (bool);
120 
121     /**
122      * @dev Emitted when `value` tokens are moved from one account (`from`) to
123      * another (`to`).
124      *
125      * Note that `value` may be zero.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     /**
130      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
131      * a call to {approve}. `value` is the new allowance.
132      */
133     event Approval(
134         address indexed owner,
135         address indexed spender,
136         uint256 value
137     );
138 }
139 
140 interface IERC20Metadata is IERC20 {
141     /**
142      * @dev Returns the name of the token.
143      */
144     function name() external view returns (string memory);
145 
146     /**
147      * @dev Returns the symbol of the token.
148      */
149     function symbol() external view returns (string memory);
150 
151     /**
152      * @dev Returns the decimals places of the token.
153      */
154     function decimals() external view returns (uint8);
155 }
156 
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159     mapping(address => mapping(address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162     string private _name;
163     string private _symbol;
164 
165     constructor(string memory name_, string memory symbol_) {
166         _name = name_;
167         _symbol = symbol_;
168     }
169 
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() public view virtual override returns (string memory) {
174         return _name;
175     }
176 
177     /**
178      * @dev Returns the symbol of the token, usually a shorter version of the
179      * name.
180      */
181     function symbol() public view virtual override returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public view virtual override returns (uint8) {
186         return 18;
187     }
188 
189     /**
190      * @dev See {IERC20-totalSupply}.
191      */
192     function totalSupply() public view virtual override returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197      * @dev See {IERC20-balanceOf}.
198      */
199     function balanceOf(
200         address account
201     ) public view virtual override returns (uint256) {
202         return _balances[account];
203     }
204 
205     /**
206      * @dev See {IERC20-transfer}.
207      *
208      * Requirements:
209      *
210      * - `recipient` cannot be the zero address.
211      * - the caller must have a balance of at least `amount`.
212      */
213     function transfer(
214         address recipient,
215         uint256 amount
216     ) public virtual override returns (bool) {
217         _transfer(_msgSender(), recipient, amount);
218         return true;
219     }
220 
221     /**
222      * @dev See {IERC20-allowance}.
223      */
224     function allowance(
225         address owner,
226         address spender
227     ) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     /**
232      * @dev See {IERC20-approve}.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      */
238     function approve(
239         address spender,
240         uint256 amount
241     ) public virtual override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(
247         address sender,
248         address recipient,
249         uint256 amount
250     ) public virtual override returns (bool) {
251         _transfer(sender, recipient, amount);
252 
253         uint256 currentAllowance = _allowances[sender][_msgSender()];
254         require(
255             currentAllowance >= amount,
256             "ERC20: transfer amount exceeds allowance"
257         );
258         unchecked {
259             _approve(sender, _msgSender(), currentAllowance - amount);
260         }
261 
262         return true;
263     }
264 
265     function increaseAllowance(
266         address spender,
267         uint256 addedValue
268     ) public virtual returns (bool) {
269         _approve(
270             _msgSender(),
271             spender,
272             _allowances[_msgSender()][spender] + addedValue
273         );
274         return true;
275     }
276 
277     function decreaseAllowance(
278         address spender,
279         uint256 subtractedValue
280     ) public virtual returns (bool) {
281         uint256 currentAllowance = _allowances[_msgSender()][spender];
282         require(
283             currentAllowance >= subtractedValue,
284             "ERC20: decreased allowance below zero"
285         );
286         unchecked {
287             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
288         }
289 
290         return true;
291     }
292 
293     function _transfer(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) internal virtual {
298         require(sender != address(0), "ERC20: transfer from the zero address");
299         require(recipient != address(0), "ERC20: transfer to the zero address");
300 
301         _beforeTokenTransfer(sender, recipient, amount);
302 
303         uint256 senderBalance = _balances[sender];
304         require(
305             senderBalance >= amount,
306             "ERC20: transfer amount exceeds balance"
307         );
308         unchecked {
309             _balances[sender] = senderBalance - amount;
310         }
311         _balances[recipient] += amount;
312 
313         emit Transfer(sender, recipient, amount);
314 
315         _afterTokenTransfer(sender, recipient, amount);
316     }
317 
318     function _mint(address account, uint256 amount) internal virtual {
319         require(account != address(0), "ERC20: mint to the zero address");
320 
321         _beforeTokenTransfer(address(0), account, amount);
322 
323         _totalSupply += amount;
324         _balances[account] += amount;
325         emit Transfer(address(0), account, amount);
326 
327         _afterTokenTransfer(address(0), account, amount);
328     }
329 
330     function _burn(address account, uint256 amount) internal virtual {
331         require(account != address(0), "ERC20: burn from the zero address");
332 
333         _beforeTokenTransfer(account, address(0), amount);
334 
335         uint256 accountBalance = _balances[account];
336         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
337         unchecked {
338             _balances[account] = accountBalance - amount;
339         }
340         _totalSupply -= amount;
341 
342         emit Transfer(account, address(0), amount);
343 
344         _afterTokenTransfer(account, address(0), amount);
345     }
346 
347     function _approve(
348         address owner,
349         address spender,
350         uint256 amount
351     ) internal virtual {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354 
355         _allowances[owner][spender] = amount;
356         emit Approval(owner, spender, amount);
357     }
358 
359     function _beforeTokenTransfer(
360         address from,
361         address to,
362         uint256 amount
363     ) internal virtual {}
364 
365     function _afterTokenTransfer(
366         address from,
367         address to,
368         uint256 amount
369     ) internal virtual {}
370 }
371 
372 library SafeMath {
373     function tryAdd(
374         uint256 a,
375         uint256 b
376     ) internal pure returns (bool, uint256) {
377         unchecked {
378             uint256 c = a + b;
379             if (c < a) return (false, 0);
380             return (true, c);
381         }
382     }
383 
384     function trySub(
385         uint256 a,
386         uint256 b
387     ) internal pure returns (bool, uint256) {
388         unchecked {
389             if (b > a) return (false, 0);
390             return (true, a - b);
391         }
392     }
393 
394     function tryMul(
395         uint256 a,
396         uint256 b
397     ) internal pure returns (bool, uint256) {
398         unchecked {
399             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
400             // benefit is lost if 'b' is also tested.
401             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
402             if (a == 0) return (true, 0);
403             uint256 c = a * b;
404             if (c / a != b) return (false, 0);
405             return (true, c);
406         }
407     }
408 
409     function tryDiv(
410         uint256 a,
411         uint256 b
412     ) internal pure returns (bool, uint256) {
413         unchecked {
414             if (b == 0) return (false, 0);
415             return (true, a / b);
416         }
417     }
418 
419     function tryMod(
420         uint256 a,
421         uint256 b
422     ) internal pure returns (bool, uint256) {
423         unchecked {
424             if (b == 0) return (false, 0);
425             return (true, a % b);
426         }
427     }
428 
429     function add(uint256 a, uint256 b) internal pure returns (uint256) {
430         return a + b;
431     }
432 
433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434         return a - b;
435     }
436 
437     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
438         return a * b;
439     }
440 
441     function div(uint256 a, uint256 b) internal pure returns (uint256) {
442         return a / b;
443     }
444 
445     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
446         return a % b;
447     }
448 
449     function sub(
450         uint256 a,
451         uint256 b,
452         string memory errorMessage
453     ) internal pure returns (uint256) {
454         unchecked {
455             require(b <= a, errorMessage);
456             return a - b;
457         }
458     }
459 
460     function div(
461         uint256 a,
462         uint256 b,
463         string memory errorMessage
464     ) internal pure returns (uint256) {
465         unchecked {
466             require(b > 0, errorMessage);
467             return a / b;
468         }
469     }
470 
471     function mod(
472         uint256 a,
473         uint256 b,
474         string memory errorMessage
475     ) internal pure returns (uint256) {
476         unchecked {
477             require(b > 0, errorMessage);
478             return a % b;
479         }
480     }
481 }
482 
483 ////// src/IUniswapV2Factory.sol
484 /* pragma solidity 0.8.10; */
485 /* pragma experimental ABIEncoderV2; */
486 
487 interface IUniswapV2Factory {
488     event PairCreated(
489         address indexed token0,
490         address indexed token1,
491         address pair,
492         uint256
493     );
494 
495     function feeTo() external view returns (address);
496 
497     function feeToSetter() external view returns (address);
498 
499     function getPair(
500         address tokenA,
501         address tokenB
502     ) external view returns (address pair);
503 
504     function allPairs(uint256) external view returns (address pair);
505 
506     function allPairsLength() external view returns (uint256);
507 
508     function createPair(
509         address tokenA,
510         address tokenB
511     ) external returns (address pair);
512 
513     function setFeeTo(address) external;
514 
515     function setFeeToSetter(address) external;
516 }
517 
518 ////// src/IUniswapV2Pair.sol
519 /* pragma solidity 0.8.10; */
520 /* pragma experimental ABIEncoderV2; */
521 
522 interface IUniswapV2Pair {
523     event Approval(
524         address indexed owner,
525         address indexed spender,
526         uint256 value
527     );
528     event Transfer(address indexed from, address indexed to, uint256 value);
529 
530     function name() external pure returns (string memory);
531 
532     function symbol() external pure returns (string memory);
533 
534     function decimals() external pure returns (uint8);
535 
536     function totalSupply() external view returns (uint256);
537 
538     function balanceOf(address owner) external view returns (uint256);
539 
540     function allowance(
541         address owner,
542         address spender
543     ) external view returns (uint256);
544 
545     function approve(address spender, uint256 value) external returns (bool);
546 
547     function transfer(address to, uint256 value) external returns (bool);
548 
549     function transferFrom(
550         address from,
551         address to,
552         uint256 value
553     ) external returns (bool);
554 
555     function DOMAIN_SEPARATOR() external view returns (bytes32);
556 
557     function PERMIT_TYPEHASH() external pure returns (bytes32);
558 
559     function nonces(address owner) external view returns (uint256);
560 
561     function permit(
562         address owner,
563         address spender,
564         uint256 value,
565         uint256 deadline,
566         uint8 v,
567         bytes32 r,
568         bytes32 s
569     ) external;
570 
571     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
572     event Burn(
573         address indexed sender,
574         uint256 amount0,
575         uint256 amount1,
576         address indexed to
577     );
578     event Swap(
579         address indexed sender,
580         uint256 amount0In,
581         uint256 amount1In,
582         uint256 amount0Out,
583         uint256 amount1Out,
584         address indexed to
585     );
586     event Sync(uint112 reserve0, uint112 reserve1);
587 
588     function MINIMUM_LIQUIDITY() external pure returns (uint256);
589 
590     function factory() external view returns (address);
591 
592     function token0() external view returns (address);
593 
594     function token1() external view returns (address);
595 
596     function getReserves()
597         external
598         view
599         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
600 
601     function price0CumulativeLast() external view returns (uint256);
602 
603     function price1CumulativeLast() external view returns (uint256);
604 
605     function kLast() external view returns (uint256);
606 
607     function mint(address to) external returns (uint256 liquidity);
608 
609     function burn(
610         address to
611     ) external returns (uint256 amount0, uint256 amount1);
612 
613     function swap(
614         uint256 amount0Out,
615         uint256 amount1Out,
616         address to,
617         bytes calldata data
618     ) external;
619 
620     function skim(address to) external;
621 
622     function sync() external;
623 
624     function initialize(address, address) external;
625 }
626 
627 interface IUniswapV2Router02 {
628     function factory() external pure returns (address);
629 
630     function WETH() external pure returns (address);
631 
632     function addLiquidity(
633         address tokenA,
634         address tokenB,
635         uint256 amountADesired,
636         uint256 amountBDesired,
637         uint256 amountAMin,
638         uint256 amountBMin,
639         address to,
640         uint256 deadline
641     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
642 
643     function addLiquidityETH(
644         address token,
645         uint256 amountTokenDesired,
646         uint256 amountTokenMin,
647         uint256 amountETHMin,
648         address to,
649         uint256 deadline
650     )
651         external
652         payable
653         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
654 
655     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
656         uint256 amountIn,
657         uint256 amountOutMin,
658         address[] calldata path,
659         address to,
660         uint256 deadline
661     ) external;
662 
663     function swapExactETHForTokensSupportingFeeOnTransferTokens(
664         uint256 amountOutMin,
665         address[] calldata path,
666         address to,
667         uint256 deadline
668     ) external payable;
669 
670     function swapExactTokensForETHSupportingFeeOnTransferTokens(
671         uint256 amountIn,
672         uint256 amountOutMin,
673         address[] calldata path,
674         address to,
675         uint256 deadline
676     ) external;
677 }
678 
679 contract TOADS is ERC20, Ownable {
680     event SwapBackSuccess(
681         uint256 tokenAmount,
682         uint256 ethAmountReceived,
683         bool success
684     );
685     bool private swapping;
686     address public marketingWallet =
687         address(0x9B225F844875823595076cCd2a38E43096a46086);
688 
689     address public devWallet =
690         address(0x5fC4684279ee2B5E7aBfbC0acf82B25d611Cf6e1);
691 
692     uint256 _totalSupply = 10000000 * 1e18;
693     uint256 public maxTransactionAmount = (_totalSupply * 10) / 1000; // 1% from total supply maxTransactionAmountTxn;
694     uint256 public swapTokensAtAmount = (_totalSupply * 10) / 10000; // 0.1% swap tokens at this amount. (10_000_000 * 10) / 10000 = 0.1%(10000 tokens) of the total supply
695     uint256 public maxWallet = (_totalSupply * 10) / 1000; // 1% from total supply maxWallet
696 
697     bool public limitsInEffect = true;
698     bool public tradingActive = false;
699     bool public swapEnabled = false;
700 
701     uint256 public buyFees = 5;
702     uint256 public sellFees = 5;
703 
704     uint256 public marketingAmount = 70; //
705     uint256 public devAmount = 30; //
706 
707     using SafeMath for uint256;
708 
709     IUniswapV2Router02 public uniswapV2Router;
710     address public uniswapV2Pair;
711     address public constant deadAddress = address(0xdead);
712 
713     // exlcude from fees and max transaction amount
714     mapping(address => bool) private _isExcludedFromFees;
715     mapping(address => bool) public _isExcludedMaxTransactionAmount;
716     mapping(address => bool) public automatedMarketMakerPairs;
717 
718     constructor() ERC20("Toad Race", "TOADS") {
719         // exclude from paying fees or having max transaction amount
720         excludeFromFees(owner(), true);
721         excludeFromFees(marketingWallet, true);
722         excludeFromFees(devWallet, true);
723         excludeFromFees(address(this), true);
724         excludeFromFees(address(0xdead), true);
725         excludeFromMaxTransaction(owner(), true);
726         excludeFromMaxTransaction(marketingWallet, true);
727         excludeFromMaxTransaction(devWallet, true);
728         excludeFromMaxTransaction(address(this), true);
729         excludeFromMaxTransaction(address(0xdead), true);
730         _mint(address(this), _totalSupply);
731     }
732 
733     receive() external payable {}
734 
735     // once enabled, can never be turned off
736     function enableTrading() external onlyOwner {
737         tradingActive = true;
738         swapEnabled = true;
739     }
740 
741     // remove limits after token is stable (sets sell fees to 5%)
742     function removeLimits() external onlyOwner returns (bool) {
743         limitsInEffect = false;
744         sellFees = 5;
745         buyFees = 5;
746         return true;
747     }
748 
749     function excludeFromMaxTransaction(
750         address addressToExclude,
751         bool isExcluded
752     ) public onlyOwner {
753         _isExcludedMaxTransactionAmount[addressToExclude] = isExcluded;
754     }
755 
756     // only use to disable contract sales if absolutely necessary (emergency use only)
757     function updateSwapEnabled(bool enabled) external onlyOwner {
758         swapEnabled = enabled;
759     }
760 
761     function excludeFromFees(address account, bool excluded) public onlyOwner {
762         _isExcludedFromFees[account] = excluded;
763     }
764 
765     function setAutomatedMarketMakerPair(
766         address pair,
767         bool value
768     ) public onlyOwner {
769         require(
770             pair != uniswapV2Pair,
771             "The pair cannot be removed from automatedMarketMakerPairs"
772         );
773         _setAutomatedMarketMakerPair(pair, value);
774     }
775 
776     function addLiquidity() external payable onlyOwner {
777         // approve token transfer to cover all possible scenarios
778         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
779             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
780         );
781 
782         uniswapV2Router = _uniswapV2Router;
783         excludeFromMaxTransaction(address(_uniswapV2Router), true);
784         _approve(address(this), address(uniswapV2Router), totalSupply());
785         // add the liquidity
786         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
787             .createPair(address(this), _uniswapV2Router.WETH());
788         excludeFromMaxTransaction(address(uniswapV2Pair), true);
789         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
790 
791         uniswapV2Router.addLiquidityETH{value: msg.value}(
792             address(this), //token address
793             totalSupply(), // liquidity amount
794             0, // slippage is unavoidable
795             0, // slippage is unavoidable
796             owner(), // LP tokens are sent to the owner
797             block.timestamp
798         );
799     }
800 
801     function _setAutomatedMarketMakerPair(address pair, bool value) private {
802         automatedMarketMakerPairs[pair] = value;
803     }
804 
805     function updateFeeWallet(
806         address marketingWallet_,
807         address devWallet_
808     ) public onlyOwner {
809         devWallet = devWallet_;
810         marketingWallet = marketingWallet_;
811     }
812 
813     function isExcludedFromFees(address account) public view returns (bool) {
814         return _isExcludedFromFees[account];
815     }
816 
817     function _transfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal override {
822         require(from != address(0), "ERC20: transfer from the zero address");
823         require(to != address(0), "ERC20: transfer to the zero address");
824         require(amount > 0, "Transfer amount must be greater than zero");
825         if (limitsInEffect) {
826             if (
827                 from != owner() &&
828                 to != owner() &&
829                 to != address(0) &&
830                 to != address(0xdead) &&
831                 !swapping
832             ) {
833                 if (!tradingActive) {
834                     require(
835                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
836                         "Trading is not enabled yet."
837                     );
838                 }
839 
840                 //when buy
841                 if (
842                     automatedMarketMakerPairs[from] &&
843                     !_isExcludedMaxTransactionAmount[to]
844                 ) {
845                     require(
846                         amount <= maxTransactionAmount,
847                         "Buy transfer amount exceeds the maxTransactionAmount."
848                     );
849                     require(
850                         amount + balanceOf(to) <= maxWallet,
851                         "Max wallet exceeded"
852                     );
853                 }
854                 //when sell
855                 else if (
856                     automatedMarketMakerPairs[to] &&
857                     !_isExcludedMaxTransactionAmount[from]
858                 ) {
859                     require(
860                         amount <= maxTransactionAmount,
861                         "Sell transfer amount exceeds the maxTransactionAmount."
862                     );
863                 } else if (!_isExcludedMaxTransactionAmount[to]) {
864                     require(
865                         amount + balanceOf(to) <= maxWallet,
866                         "Max wallet exceeded"
867                     );
868                 }
869             }
870         }
871 
872         if (
873             swapEnabled && //if this is true
874             !swapping && //if this is false
875             !automatedMarketMakerPairs[from] && //if this is false
876             !_isExcludedFromFees[from] && //if this is false
877             !_isExcludedFromFees[to] //if this is false
878         ) {
879             swapping = true;
880             swapBack();
881             swapping = false;
882         }
883 
884         bool takeFee = !swapping;
885 
886         // if any account belongs to _isExcludedFromFee account then remove the fee
887         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
888             takeFee = false;
889         }
890 
891         uint256 fees = 0;
892         // only take fees on buys/sells, do not take on wallet transfers
893         if (takeFee) {
894             // on sell
895             if (automatedMarketMakerPairs[to] && sellFees > 0) {
896                 fees = amount.mul(sellFees).div(100);
897             }
898             // on buy
899             else if (automatedMarketMakerPairs[from] && buyFees > 0) {
900                 fees = amount.mul(buyFees).div(100);
901             }
902 
903             if (fees > 0) {
904                 super._transfer(from, address(this), fees);
905             }
906             amount -= fees;
907         }
908         super._transfer(from, to, amount);
909     }
910 
911     function swapTokensForEth(uint256 tokenAmount) private {
912         // generate the uniswap pair path of token -> weth
913         address[] memory path = new address[](2);
914         path[0] = address(this);
915         path[1] = uniswapV2Router.WETH();
916         _approve(address(this), address(uniswapV2Router), tokenAmount);
917         // make the swap
918         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
919             tokenAmount,
920             0, // accept any amount of ETH
921             path,
922             address(this),
923             block.timestamp
924         );
925     }
926 
927     function swapBack() private {
928         uint256 contractBalance = balanceOf(address(this));
929         bool success;
930         if (contractBalance == 0) {
931             return;
932         }
933         if (contractBalance >= swapTokensAtAmount) {
934             uint256 amountToSwapForETH = swapTokensAtAmount;
935             swapTokensForEth(amountToSwapForETH);
936             uint256 amountEthToSend = address(this).balance;
937             uint256 amountToMarketing = amountEthToSend
938                 .mul(marketingAmount)
939                 .div(100);
940             uint256 amountToDev = amountEthToSend.sub(amountToMarketing);
941             (success, ) = address(marketingWallet).call{
942                 value: amountToMarketing
943             }("");
944             (success, ) = address(devWallet).call{value: amountToDev}("");
945             emit SwapBackSuccess(amountToSwapForETH, amountEthToSend, success);
946         }
947     }
948 }