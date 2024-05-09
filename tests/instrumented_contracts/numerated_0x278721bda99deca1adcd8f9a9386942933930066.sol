1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17     address private creator;
18     event OwnershipTransferred(
19         address indexed previousOwner,
20         address indexed newOwner
21     );
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(
62             newOwner != address(0),
63             "Ownable: new owner is the zero address"
64         );
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Internal function without access restriction.
71      */
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 interface IERC20 {
80     /**
81      * @dev Returns the amount of tokens in existence.
82      */
83     function totalSupply() external view returns (uint256);
84 
85     /**
86      * @dev Returns the amount of tokens owned by `account`.
87      */
88     function balanceOf(address account) external view returns (uint256);
89 
90     /**
91      * @dev Moves `amount` tokens from the caller's account to `recipient`.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transfer(
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     function allowance(
103         address owner,
104         address spender
105     ) external view returns (uint256);
106 
107     function approve(address spender, uint256 amount) external returns (bool);
108 
109     function transferFrom(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) external returns (bool);
114 
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(
128         address indexed owner,
129         address indexed spender,
130         uint256 value
131     );
132 }
133 
134 interface IERC20Metadata is IERC20 {
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() external view returns (string memory);
139 
140     /**
141      * @dev Returns the symbol of the token.
142      */
143     function symbol() external view returns (string memory);
144 
145     /**
146      * @dev Returns the decimals places of the token.
147      */
148     function decimals() external view returns (uint8);
149 }
150 
151 contract ERC20 is Context, IERC20, IERC20Metadata {
152     mapping(address => uint256) private _balances;
153     mapping(address => mapping(address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156     string private _name;
157     string private _symbol;
158 
159     constructor(string memory name_, string memory symbol_) {
160         _name = name_;
161         _symbol = symbol_;
162     }
163 
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() public view virtual override returns (string memory) {
168         return _name;
169     }
170 
171     /**
172      * @dev Returns the symbol of the token, usually a shorter version of the
173      * name.
174      */
175     function symbol() public view virtual override returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public view virtual override returns (uint8) {
180         return 18;
181     }
182 
183     /**
184      * @dev See {IERC20-totalSupply}.
185      */
186     function totalSupply() public view virtual override returns (uint256) {
187         return _totalSupply;
188     }
189 
190     /**
191      * @dev See {IERC20-balanceOf}.
192      */
193     function balanceOf(
194         address account
195     ) public view virtual override returns (uint256) {
196         return _balances[account];
197     }
198 
199     /**
200      * @dev See {IERC20-transfer}.
201      *
202      * Requirements:
203      *
204      * - `recipient` cannot be the zero address.
205      * - the caller must have a balance of at least `amount`.
206      */
207     function transfer(
208         address recipient,
209         uint256 amount
210     ) public virtual override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-allowance}.
217      */
218     function allowance(
219         address owner,
220         address spender
221     ) public view virtual override returns (uint256) {
222         return _allowances[owner][spender];
223     }
224 
225     /**
226      * @dev See {IERC20-approve}.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      */
232     function approve(
233         address spender,
234         uint256 amount
235     ) public virtual override returns (bool) {
236         _approve(_msgSender(), spender, amount);
237         return true;
238     }
239 
240     function transferFrom(
241         address sender,
242         address recipient,
243         uint256 amount
244     ) public virtual override returns (bool) {
245         _transfer(sender, recipient, amount);
246 
247         uint256 currentAllowance = _allowances[sender][_msgSender()];
248         require(
249             currentAllowance >= amount,
250             "ERC20: transfer amount exceeds allowance"
251         );
252         unchecked {
253             _approve(sender, _msgSender(), currentAllowance - amount);
254         }
255 
256         return true;
257     }
258 
259     function increaseAllowance(
260         address spender,
261         uint256 addedValue
262     ) public virtual returns (bool) {
263         _approve(
264             _msgSender(),
265             spender,
266             _allowances[_msgSender()][spender] + addedValue
267         );
268         return true;
269     }
270 
271     function decreaseAllowance(
272         address spender,
273         uint256 subtractedValue
274     ) public virtual returns (bool) {
275         uint256 currentAllowance = _allowances[_msgSender()][spender];
276         require(
277             currentAllowance >= subtractedValue,
278             "ERC20: decreased allowance below zero"
279         );
280         unchecked {
281             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
282         }
283 
284         return true;
285     }
286 
287     function _transfer(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) internal virtual {
292         require(sender != address(0), "ERC20: transfer from the zero address");
293         require(recipient != address(0), "ERC20: transfer to the zero address");
294 
295         _beforeTokenTransfer(sender, recipient, amount);
296 
297         uint256 senderBalance = _balances[sender];
298         require(
299             senderBalance >= amount,
300             "ERC20: transfer amount exceeds balance"
301         );
302         unchecked {
303             _balances[sender] = senderBalance - amount;
304         }
305         _balances[recipient] += amount;
306 
307         emit Transfer(sender, recipient, amount);
308 
309         _afterTokenTransfer(sender, recipient, amount);
310     }
311 
312     function _mint(address account, uint256 amount) internal virtual {
313         require(account != address(0), "ERC20: mint to the zero address");
314 
315         _beforeTokenTransfer(address(0), account, amount);
316 
317         _totalSupply += amount;
318         _balances[account] += amount;
319         emit Transfer(address(0), account, amount);
320 
321         _afterTokenTransfer(address(0), account, amount);
322     }
323 
324     function _burn(address account, uint256 amount) internal virtual {
325         require(account != address(0), "ERC20: burn from the zero address");
326 
327         _beforeTokenTransfer(account, address(0), amount);
328 
329         uint256 accountBalance = _balances[account];
330         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
331         unchecked {
332             _balances[account] = accountBalance - amount;
333         }
334         _totalSupply -= amount;
335 
336         emit Transfer(account, address(0), amount);
337 
338         _afterTokenTransfer(account, address(0), amount);
339     }
340 
341     function _approve(
342         address owner,
343         address spender,
344         uint256 amount
345     ) internal virtual {
346         require(owner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348 
349         _allowances[owner][spender] = amount;
350         emit Approval(owner, spender, amount);
351     }
352 
353     function _beforeTokenTransfer(
354         address from,
355         address to,
356         uint256 amount
357     ) internal virtual {}
358 
359     function _afterTokenTransfer(
360         address from,
361         address to,
362         uint256 amount
363     ) internal virtual {}
364 }
365 
366 library SafeMath {
367     function tryAdd(
368         uint256 a,
369         uint256 b
370     ) internal pure returns (bool, uint256) {
371         unchecked {
372             uint256 c = a + b;
373             if (c < a) return (false, 0);
374             return (true, c);
375         }
376     }
377 
378     function trySub(
379         uint256 a,
380         uint256 b
381     ) internal pure returns (bool, uint256) {
382         unchecked {
383             if (b > a) return (false, 0);
384             return (true, a - b);
385         }
386     }
387 
388     function tryMul(
389         uint256 a,
390         uint256 b
391     ) internal pure returns (bool, uint256) {
392         unchecked {
393             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
394             // benefit is lost if 'b' is also tested.
395             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
396             if (a == 0) return (true, 0);
397             uint256 c = a * b;
398             if (c / a != b) return (false, 0);
399             return (true, c);
400         }
401     }
402 
403     function tryDiv(
404         uint256 a,
405         uint256 b
406     ) internal pure returns (bool, uint256) {
407         unchecked {
408             if (b == 0) return (false, 0);
409             return (true, a / b);
410         }
411     }
412 
413     function tryMod(
414         uint256 a,
415         uint256 b
416     ) internal pure returns (bool, uint256) {
417         unchecked {
418             if (b == 0) return (false, 0);
419             return (true, a % b);
420         }
421     }
422 
423     function add(uint256 a, uint256 b) internal pure returns (uint256) {
424         return a + b;
425     }
426 
427     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
428         return a - b;
429     }
430 
431     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
432         return a * b;
433     }
434 
435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
436         return a / b;
437     }
438 
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a % b;
441     }
442 
443     function sub(
444         uint256 a,
445         uint256 b,
446         string memory errorMessage
447     ) internal pure returns (uint256) {
448         unchecked {
449             require(b <= a, errorMessage);
450             return a - b;
451         }
452     }
453 
454     function div(
455         uint256 a,
456         uint256 b,
457         string memory errorMessage
458     ) internal pure returns (uint256) {
459         unchecked {
460             require(b > 0, errorMessage);
461             return a / b;
462         }
463     }
464 
465     function mod(
466         uint256 a,
467         uint256 b,
468         string memory errorMessage
469     ) internal pure returns (uint256) {
470         unchecked {
471             require(b > 0, errorMessage);
472             return a % b;
473         }
474     }
475 }
476 
477 ////// src/IUniswapV2Factory.sol
478 /* pragma solidity 0.8.10; */
479 /* pragma experimental ABIEncoderV2; */
480 
481 interface IUniswapV2Factory {
482     event PairCreated(
483         address indexed token0,
484         address indexed token1,
485         address pair,
486         uint256
487     );
488 
489     function feeTo() external view returns (address);
490 
491     function feeToSetter() external view returns (address);
492 
493     function getPair(
494         address tokenA,
495         address tokenB
496     ) external view returns (address pair);
497 
498     function allPairs(uint256) external view returns (address pair);
499 
500     function allPairsLength() external view returns (uint256);
501 
502     function createPair(
503         address tokenA,
504         address tokenB
505     ) external returns (address pair);
506 
507     function setFeeTo(address) external;
508 
509     function setFeeToSetter(address) external;
510 }
511 
512 ////// src/IUniswapV2Pair.sol
513 /* pragma solidity 0.8.10; */
514 /* pragma experimental ABIEncoderV2; */
515 
516 interface IUniswapV2Pair {
517     event Approval(
518         address indexed owner,
519         address indexed spender,
520         uint256 value
521     );
522     event Transfer(address indexed from, address indexed to, uint256 value);
523 
524     function name() external pure returns (string memory);
525 
526     function symbol() external pure returns (string memory);
527 
528     function decimals() external pure returns (uint8);
529 
530     function totalSupply() external view returns (uint256);
531 
532     function balanceOf(address owner) external view returns (uint256);
533 
534     function allowance(
535         address owner,
536         address spender
537     ) external view returns (uint256);
538 
539     function approve(address spender, uint256 value) external returns (bool);
540 
541     function transfer(address to, uint256 value) external returns (bool);
542 
543     function transferFrom(
544         address from,
545         address to,
546         uint256 value
547     ) external returns (bool);
548 
549     function DOMAIN_SEPARATOR() external view returns (bytes32);
550 
551     function PERMIT_TYPEHASH() external pure returns (bytes32);
552 
553     function nonces(address owner) external view returns (uint256);
554 
555     function permit(
556         address owner,
557         address spender,
558         uint256 value,
559         uint256 deadline,
560         uint8 v,
561         bytes32 r,
562         bytes32 s
563     ) external;
564 
565     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
566     event Burn(
567         address indexed sender,
568         uint256 amount0,
569         uint256 amount1,
570         address indexed to
571     );
572     event Swap(
573         address indexed sender,
574         uint256 amount0In,
575         uint256 amount1In,
576         uint256 amount0Out,
577         uint256 amount1Out,
578         address indexed to
579     );
580     event Sync(uint112 reserve0, uint112 reserve1);
581 
582     function MINIMUM_LIQUIDITY() external pure returns (uint256);
583 
584     function factory() external view returns (address);
585 
586     function token0() external view returns (address);
587 
588     function token1() external view returns (address);
589 
590     function getReserves()
591         external
592         view
593         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
594 
595     function price0CumulativeLast() external view returns (uint256);
596 
597     function price1CumulativeLast() external view returns (uint256);
598 
599     function kLast() external view returns (uint256);
600 
601     function mint(address to) external returns (uint256 liquidity);
602 
603     function burn(
604         address to
605     ) external returns (uint256 amount0, uint256 amount1);
606 
607     function swap(
608         uint256 amount0Out,
609         uint256 amount1Out,
610         address to,
611         bytes calldata data
612     ) external;
613 
614     function skim(address to) external;
615 
616     function sync() external;
617 
618     function initialize(address, address) external;
619 }
620 
621 interface IUniswapV2Router02 {
622     function factory() external pure returns (address);
623 
624     function WETH() external pure returns (address);
625 
626     function addLiquidity(
627         address tokenA,
628         address tokenB,
629         uint256 amountADesired,
630         uint256 amountBDesired,
631         uint256 amountAMin,
632         uint256 amountBMin,
633         address to,
634         uint256 deadline
635     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
636 
637     function addLiquidityETH(
638         address token,
639         uint256 amountTokenDesired,
640         uint256 amountTokenMin,
641         uint256 amountETHMin,
642         address to,
643         uint256 deadline
644     )
645         external
646         payable
647         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
648 
649     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
650         uint256 amountIn,
651         uint256 amountOutMin,
652         address[] calldata path,
653         address to,
654         uint256 deadline
655     ) external;
656 
657     function swapExactETHForTokensSupportingFeeOnTransferTokens(
658         uint256 amountOutMin,
659         address[] calldata path,
660         address to,
661         uint256 deadline
662     ) external payable;
663 
664     function swapExactTokensForETHSupportingFeeOnTransferTokens(
665         uint256 amountIn,
666         uint256 amountOutMin,
667         address[] calldata path,
668         address to,
669         uint256 deadline
670     ) external;
671 }
672 
673 contract Cockfights is ERC20, Ownable {
674     event SwapBackSuccess(
675         uint256 tokenAmount,
676         uint256 ethAmountReceived,
677         bool success
678     );
679     bool private swapping;
680     address public marketingWallet =
681         address(0xA5A3d581670D65D7f4bbf740c5DdE04cA7710F16);
682 
683     address public devWallet =
684         address(0xc1f60b4cF575a7c35d58eAC5ac225581A26FccA3);
685 
686     uint256 _totalSupply = 10_000_000 * 1e18;
687     uint256 public maxTransactionAmount = (_totalSupply * 10) / 1000; // 1% from total supply maxTransactionAmountTxn;
688     uint256 public swapTokensAtAmount = (_totalSupply * 10) / 10000; // 0.1% swap tokens at this amount. (10_000_000 * 10) / 10000 = 0.1%(10000 tokens) of the total supply
689     uint256 public maxWallet = (_totalSupply * 10) / 1000; // 1% from total supply maxWallet
690 
691     bool public limitsInEffect = true;
692     bool public tradingActive = false;
693     bool public swapEnabled = false;
694 
695     uint256 public buyFees = 30;
696     uint256 public sellFees = 30;
697 
698     uint256 public marketingAmount = 30; //
699     uint256 public devAmount = 70; //
700 
701     using SafeMath for uint256;
702 
703     IUniswapV2Router02 public uniswapV2Router;
704     address public uniswapV2Pair;
705     address public constant deadAddress = address(0xdead);
706 
707     // exlcude from fees and max transaction amount
708     mapping(address => bool) private _isExcludedFromFees;
709     mapping(address => bool) public _isExcludedMaxTransactionAmount;
710     mapping(address => bool) public automatedMarketMakerPairs;
711 
712     constructor() ERC20("COCKFIGHTS", "COCKS") {
713         // exclude from paying fees or having max transaction amount
714         excludeFromFees(owner(), true);
715         excludeFromFees(marketingWallet, true);
716         excludeFromFees(devWallet, true);
717         excludeFromFees(address(this), true);
718         excludeFromFees(address(0xdead), true);
719         excludeFromMaxTransaction(owner(), true);
720         excludeFromMaxTransaction(marketingWallet, true);
721         excludeFromMaxTransaction(devWallet, true);
722         excludeFromMaxTransaction(address(this), true);
723         excludeFromMaxTransaction(address(0xdead), true);
724         _mint(address(this), _totalSupply);
725     }
726 
727     receive() external payable {}
728 
729     // once enabled, can never be turned off
730     function enableTrading() external onlyOwner {
731         tradingActive = true;
732         swapEnabled = true;
733     }
734 
735     // remove limits after token is stable (sets sell fees to 3%)
736     function removeLimits() external onlyOwner returns (bool) {
737         limitsInEffect = false;
738         sellFees = 3;
739         buyFees = 3;
740         return true;
741     }
742 
743     function excludeFromMaxTransaction(
744         address addressToExclude,
745         bool isExcluded
746     ) public onlyOwner {
747         _isExcludedMaxTransactionAmount[addressToExclude] = isExcluded;
748     }
749 
750     // only use to disable contract sales if absolutely necessary (emergency use only)
751     function updateSwapEnabled(bool enabled) external onlyOwner {
752         swapEnabled = enabled;
753     }
754 
755     function excludeFromFees(address account, bool excluded) public onlyOwner {
756         _isExcludedFromFees[account] = excluded;
757     }
758 
759     function setAutomatedMarketMakerPair(
760         address pair,
761         bool value
762     ) public onlyOwner {
763         require(
764             pair != uniswapV2Pair,
765             "The pair cannot be removed from automatedMarketMakerPairs"
766         );
767         _setAutomatedMarketMakerPair(pair, value);
768     }
769 
770     function addLiquidity() external payable onlyOwner {
771         // approve token transfer to cover all possible scenarios
772         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
773             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
774         );
775 
776         uniswapV2Router = _uniswapV2Router;
777         excludeFromMaxTransaction(address(_uniswapV2Router), true);
778         _approve(address(this), address(uniswapV2Router), totalSupply());
779         // add the liquidity
780         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
781             .createPair(address(this), _uniswapV2Router.WETH());
782         excludeFromMaxTransaction(address(uniswapV2Pair), true);
783         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
784 
785         uniswapV2Router.addLiquidityETH{value: msg.value}(
786             address(this), //token address
787             totalSupply(), // liquidity amount
788             0, // slippage is unavoidable
789             0, // slippage is unavoidable
790             owner(), // LP tokens are sent to the owner
791             block.timestamp
792         );
793     }
794 
795     function _setAutomatedMarketMakerPair(address pair, bool value) private {
796         automatedMarketMakerPairs[pair] = value;
797     }
798 
799     function updateFeeWallet(
800         address marketingWallet_,
801         address devWallet_
802     ) public onlyOwner {
803         devWallet = devWallet_;
804         marketingWallet = marketingWallet_;
805     }
806 
807     function isExcludedFromFees(address account) public view returns (bool) {
808         return _isExcludedFromFees[account];
809     }
810 
811     function _transfer(
812         address from,
813         address to,
814         uint256 amount
815     ) internal override {
816         require(from != address(0), "ERC20: transfer from the zero address");
817         require(to != address(0), "ERC20: transfer to the zero address");
818         require(amount > 0, "Transfer amount must be greater than zero");
819         if (limitsInEffect) {
820             if (
821                 from != owner() &&
822                 to != owner() &&
823                 to != address(0) &&
824                 to != address(0xdead) &&
825                 !swapping
826             ) {
827                 if (!tradingActive) {
828                     require(
829                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
830                         "Trading is not enabled yet."
831                     );
832                 }
833 
834                 //when buy
835                 if (
836                     automatedMarketMakerPairs[from] &&
837                     !_isExcludedMaxTransactionAmount[to]
838                 ) {
839                     require(
840                         amount <= maxTransactionAmount,
841                         "Buy transfer amount exceeds the maxTransactionAmount."
842                     );
843                     require(
844                         amount + balanceOf(to) <= maxWallet,
845                         "Max wallet exceeded"
846                     );
847                 }
848                 //when sell
849                 else if (
850                     automatedMarketMakerPairs[to] &&
851                     !_isExcludedMaxTransactionAmount[from]
852                 ) {
853                     require(
854                         amount <= maxTransactionAmount,
855                         "Sell transfer amount exceeds the maxTransactionAmount."
856                     );
857                 } else if (!_isExcludedMaxTransactionAmount[to]) {
858                     require(
859                         amount + balanceOf(to) <= maxWallet,
860                         "Max wallet exceeded"
861                     );
862                 }
863             }
864         }
865 
866         if (
867             swapEnabled && //if this is true
868             !swapping && //if this is false
869             !automatedMarketMakerPairs[from] && //if this is false
870             !_isExcludedFromFees[from] && //if this is false
871             !_isExcludedFromFees[to] //if this is false
872         ) {
873             swapping = true;
874             swapBack();
875             swapping = false;
876         }
877 
878         bool takeFee = !swapping;
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
889             if (automatedMarketMakerPairs[to] && sellFees > 0) {
890                 fees = amount.mul(sellFees).div(100);
891             }
892             // on buy
893             else if (automatedMarketMakerPairs[from] && buyFees > 0) {
894                 fees = amount.mul(buyFees).div(100);
895             }
896 
897             if (fees > 0) {
898                 super._transfer(from, address(this), fees);
899             }
900             amount -= fees;
901         }
902         super._transfer(from, to, amount);
903     }
904 
905     function swapTokensForEth(uint256 tokenAmount) private {
906         // generate the uniswap pair path of token -> weth
907         address[] memory path = new address[](2);
908         path[0] = address(this);
909         path[1] = uniswapV2Router.WETH();
910         _approve(address(this), address(uniswapV2Router), tokenAmount);
911         // make the swap
912         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
913             tokenAmount,
914             0, // accept any amount of ETH
915             path,
916             address(this),
917             block.timestamp
918         );
919     }
920 
921     function swapBack() private {
922         uint256 contractBalance = balanceOf(address(this));
923         bool success;
924         if (contractBalance == 0) {
925             return;
926         }
927         if (contractBalance >= swapTokensAtAmount) {
928             uint256 amountToSwapForETH = swapTokensAtAmount;
929             swapTokensForEth(amountToSwapForETH);
930             uint256 amountEthToSend = address(this).balance;
931             uint256 amountToMarketing = amountEthToSend
932                 .mul(marketingAmount)
933                 .div(100);
934             uint256 amountToDev = amountEthToSend.sub(amountToMarketing);
935             (success, ) = address(marketingWallet).call{
936                 value: amountToMarketing
937             }("");
938             (success, ) = address(devWallet).call{value: amountToDev}("");
939             emit SwapBackSuccess(amountToSwapForETH, amountEthToSend, success);
940         }
941     }
942 }