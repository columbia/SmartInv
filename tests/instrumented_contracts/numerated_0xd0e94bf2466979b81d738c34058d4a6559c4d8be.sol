1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 pragma experimental ABIEncoderV2;
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
15 contract Ownable is Context {
16     address private _owner;
17 
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
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49     /**
50      * @dev Transfers ownership of the contract to a new account (`newOwner`).
51      * Can only be called by the current owner.
52      */
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(
55             newOwner != address(0),
56             "Ownable: new owner is the zero address"
57         );
58         _transferOwnership(newOwner);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Internal function without access restriction.
64      */
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 interface IERC20 {
73     /**
74      * @dev Returns the amount of tokens in existence.
75      */
76     function totalSupply() external view returns (uint256);
77 
78     /**
79      * @dev Returns the amount of tokens owned by `account`.
80      */
81     function balanceOf(address account) external view returns (uint256);
82 
83     /**
84      * @dev Moves `amount` tokens from the caller's account to `recipient`.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transfer(
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94 
95     function allowance(
96         address owner,
97         address spender
98     ) external view returns (uint256);
99 
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     function transferFrom(
103         address sender,
104         address recipient,
105         uint256 amount
106     ) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(
121         address indexed owner,
122         address indexed spender,
123         uint256 value
124     );
125 }
126 
127 interface IERC20Metadata is IERC20 {
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() external view returns (string memory);
132 
133     /**
134      * @dev Returns the symbol of the token.
135      */
136     function symbol() external view returns (string memory);
137 
138     /**
139      * @dev Returns the decimals places of the token.
140      */
141     function decimals() external view returns (uint8);
142 }
143 
144 contract ERC20 is Context, IERC20, IERC20Metadata {
145     mapping(address => uint256) private _balances;
146 
147     mapping(address => mapping(address => uint256)) private _allowances;
148 
149     uint256 private _totalSupply;
150 
151     string private _name;
152     string private _symbol;
153 
154     /**
155      * @dev Sets the values for {name} and {symbol}.
156      *
157      * The default value of {decimals} is 18. To select a different value for
158      * {decimals} you should overload it.
159      *
160      * All two of these values are immutable: they can only be set once during
161      * construction.
162      */
163     constructor(string memory name_, string memory symbol_) {
164         _name = name_;
165         _symbol = symbol_;
166     }
167 
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() public view virtual override returns (string memory) {
172         return _name;
173     }
174 
175     /**
176      * @dev Returns the symbol of the token, usually a shorter version of the
177      * name.
178      */
179     function symbol() public view virtual override returns (string memory) {
180         return _symbol;
181     }
182 
183     function decimals() public view virtual override returns (uint8) {
184         return 18;
185     }
186 
187     /**
188      * @dev See {IERC20-totalSupply}.
189      */
190     function totalSupply() public view virtual override returns (uint256) {
191         return _totalSupply;
192     }
193 
194     /**
195      * @dev See {IERC20-balanceOf}.
196      */
197     function balanceOf(
198         address account
199     ) public view virtual override returns (uint256) {
200         return _balances[account];
201     }
202 
203     function transfer(
204         address recipient,
205         uint256 amount
206     ) public virtual override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     /**
212      * @dev See {IERC20-allowance}.
213      */
214     function allowance(
215         address owner,
216         address spender
217     ) public view virtual override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     /**
222      * @dev See {IERC20-approve}.
223      *
224      * Requirements:
225      *
226      * - `spender` cannot be the zero address.
227      */
228     function approve(
229         address spender,
230         uint256 amount
231     ) public virtual override returns (bool) {
232         _approve(_msgSender(), spender, amount);
233         return true;
234     }
235 
236     function transferFrom(
237         address sender,
238         address recipient,
239         uint256 amount
240     ) public virtual override returns (bool) {
241         _transfer(sender, recipient, amount);
242 
243         uint256 currentAllowance = _allowances[sender][_msgSender()];
244         require(
245             currentAllowance >= amount,
246             "ERC20: transfer amount exceeds allowance"
247         );
248         unchecked {
249             _approve(sender, _msgSender(), currentAllowance - amount);
250         }
251 
252         return true;
253     }
254 
255     function increaseAllowance(
256         address spender,
257         uint256 addedValue
258     ) public virtual returns (bool) {
259         _approve(
260             _msgSender(),
261             spender,
262             _allowances[_msgSender()][spender] + addedValue
263         );
264         return true;
265     }
266 
267     function decreaseAllowance(
268         address spender,
269         uint256 subtractedValue
270     ) public virtual returns (bool) {
271         uint256 currentAllowance = _allowances[_msgSender()][spender];
272         require(
273             currentAllowance >= subtractedValue,
274             "ERC20: decreased allowance below zero"
275         );
276         unchecked {
277             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
278         }
279 
280         return true;
281     }
282 
283     function _transfer(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) internal virtual {
288         require(sender != address(0), "ERC20: transfer from the zero address");
289         require(recipient != address(0), "ERC20: transfer to the zero address");
290 
291         _beforeTokenTransfer(sender, recipient, amount);
292 
293         uint256 senderBalance = _balances[sender];
294         require(
295             senderBalance >= amount,
296             "ERC20: transfer amount exceeds balance"
297         );
298         unchecked {
299             _balances[sender] = senderBalance - amount;
300         }
301         _balances[recipient] += amount;
302 
303         emit Transfer(sender, recipient, amount);
304 
305         _afterTokenTransfer(sender, recipient, amount);
306     }
307 
308     function _mint(address account, uint256 amount) internal virtual {
309         require(account != address(0), "ERC20: mint to the zero address");
310 
311         _beforeTokenTransfer(address(0), account, amount);
312 
313         _totalSupply += amount;
314         _balances[account] += amount;
315         emit Transfer(address(0), account, amount);
316 
317         _afterTokenTransfer(address(0), account, amount);
318     }
319 
320     function _burn(address account, uint256 amount) internal virtual {
321         require(account != address(0), "ERC20: burn from the zero address");
322 
323         _beforeTokenTransfer(account, address(0), amount);
324 
325         uint256 accountBalance = _balances[account];
326         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
327         unchecked {
328             _balances[account] = accountBalance - amount;
329         }
330         _totalSupply -= amount;
331 
332         emit Transfer(account, address(0), amount);
333 
334         _afterTokenTransfer(account, address(0), amount);
335     }
336 
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) internal virtual {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344 
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348 
349     function _beforeTokenTransfer(
350         address from,
351         address to,
352         uint256 amount
353     ) internal virtual {}
354 
355     function _afterTokenTransfer(
356         address from,
357         address to,
358         uint256 amount
359     ) internal virtual {}
360 }
361 
362 library SafeMath {
363     /**
364      * @dev Returns the addition of two unsigned integers, with an overflow flag.
365      *
366      * _Available since v3.4._
367      */
368     function tryAdd(
369         uint256 a,
370         uint256 b
371     ) internal pure returns (bool, uint256) {
372         unchecked {
373             uint256 c = a + b;
374             if (c < a) return (false, 0);
375             return (true, c);
376         }
377     }
378 
379     /**
380      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
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
394     /**
395      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
396      *
397      * _Available since v3.4._
398      */
399     function tryMul(
400         uint256 a,
401         uint256 b
402     ) internal pure returns (bool, uint256) {
403         unchecked {
404             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
405             // benefit is lost if 'b' is also tested.
406             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
407             if (a == 0) return (true, 0);
408             uint256 c = a * b;
409             if (c / a != b) return (false, 0);
410             return (true, c);
411         }
412     }
413 
414     /**
415      * @dev Returns the division of two unsigned integers, with a division by zero flag.
416      *
417      * _Available since v3.4._
418      */
419     function tryDiv(
420         uint256 a,
421         uint256 b
422     ) internal pure returns (bool, uint256) {
423         unchecked {
424             if (b == 0) return (false, 0);
425             return (true, a / b);
426         }
427     }
428 
429     /**
430      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryMod(
435         uint256 a,
436         uint256 b
437     ) internal pure returns (bool, uint256) {
438         unchecked {
439             if (b == 0) return (false, 0);
440             return (true, a % b);
441         }
442     }
443 
444     function add(uint256 a, uint256 b) internal pure returns (uint256) {
445         return a + b;
446     }
447 
448     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
449         return a - b;
450     }
451 
452     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
453         return a * b;
454     }
455 
456     function div(uint256 a, uint256 b) internal pure returns (uint256) {
457         return a / b;
458     }
459 
460     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
461         return a % b;
462     }
463 
464     function sub(
465         uint256 a,
466         uint256 b,
467         string memory errorMessage
468     ) internal pure returns (uint256) {
469         unchecked {
470             require(b <= a, errorMessage);
471             return a - b;
472         }
473     }
474 
475     function div(
476         uint256 a,
477         uint256 b,
478         string memory errorMessage
479     ) internal pure returns (uint256) {
480         unchecked {
481             require(b > 0, errorMessage);
482             return a / b;
483         }
484     }
485 
486     function mod(
487         uint256 a,
488         uint256 b,
489         string memory errorMessage
490     ) internal pure returns (uint256) {
491         unchecked {
492             require(b > 0, errorMessage);
493             return a % b;
494         }
495     }
496 }
497 
498 interface IUniswapV2Factory {
499     event PairCreated(
500         address indexed token0,
501         address indexed token1,
502         address pair,
503         uint256
504     );
505 
506     function feeTo() external view returns (address);
507 
508     function feeToSetter() external view returns (address);
509 
510     function getPair(
511         address tokenA,
512         address tokenB
513     ) external view returns (address pair);
514 
515     function allPairs(uint256) external view returns (address pair);
516 
517     function allPairsLength() external view returns (uint256);
518 
519     function createPair(
520         address tokenA,
521         address tokenB
522     ) external returns (address pair);
523 
524     function setFeeTo(address) external;
525 
526     function setFeeToSetter(address) external;
527 }
528 
529 interface IUniswapV2Pair {
530     event Approval(
531         address indexed owner,
532         address indexed spender,
533         uint256 value
534     );
535     event Transfer(address indexed from, address indexed to, uint256 value);
536 
537     function name() external pure returns (string memory);
538 
539     function symbol() external pure returns (string memory);
540 
541     function decimals() external pure returns (uint8);
542 
543     function totalSupply() external view returns (uint256);
544 
545     function balanceOf(address owner) external view returns (uint256);
546 
547     function allowance(
548         address owner,
549         address spender
550     ) external view returns (uint256);
551 
552     function approve(address spender, uint256 value) external returns (bool);
553 
554     function transfer(address to, uint256 value) external returns (bool);
555 
556     function transferFrom(
557         address from,
558         address to,
559         uint256 value
560     ) external returns (bool);
561 
562     function DOMAIN_SEPARATOR() external view returns (bytes32);
563 
564     function PERMIT_TYPEHASH() external pure returns (bytes32);
565 
566     function nonces(address owner) external view returns (uint256);
567 
568     function permit(
569         address owner,
570         address spender,
571         uint256 value,
572         uint256 deadline,
573         uint8 v,
574         bytes32 r,
575         bytes32 s
576     ) external;
577 
578     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
579     event Burn(
580         address indexed sender,
581         uint256 amount0,
582         uint256 amount1,
583         address indexed to
584     );
585     event Swap(
586         address indexed sender,
587         uint256 amount0In,
588         uint256 amount1In,
589         uint256 amount0Out,
590         uint256 amount1Out,
591         address indexed to
592     );
593     event Sync(uint112 reserve0, uint112 reserve1);
594 
595     function MINIMUM_LIQUIDITY() external pure returns (uint256);
596 
597     function factory() external view returns (address);
598 
599     function token0() external view returns (address);
600 
601     function token1() external view returns (address);
602 
603     function getReserves()
604         external
605         view
606         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
607 
608     function price0CumulativeLast() external view returns (uint256);
609 
610     function price1CumulativeLast() external view returns (uint256);
611 
612     function kLast() external view returns (uint256);
613 
614     function mint(address to) external returns (uint256 liquidity);
615 
616     function burn(
617         address to
618     ) external returns (uint256 amount0, uint256 amount1);
619 
620     function swap(
621         uint256 amount0Out,
622         uint256 amount1Out,
623         address to,
624         bytes calldata data
625     ) external;
626 
627     function skim(address to) external;
628 
629     function sync() external;
630 
631     function initialize(address, address) external;
632 }
633 
634 interface IUniswapV2Router02 {
635     function factory() external pure returns (address);
636 
637     function WETH() external pure returns (address);
638 
639     function addLiquidity(
640         address tokenA,
641         address tokenB,
642         uint256 amountADesired,
643         uint256 amountBDesired,
644         uint256 amountAMin,
645         uint256 amountBMin,
646         address to,
647         uint256 deadline
648     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
649 
650     function addLiquidityETH(
651         address token,
652         uint256 amountTokenDesired,
653         uint256 amountTokenMin,
654         uint256 amountETHMin,
655         address to,
656         uint256 deadline
657     )
658         external
659         payable
660         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
661 
662     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
663         uint256 amountIn,
664         uint256 amountOutMin,
665         address[] calldata path,
666         address to,
667         uint256 deadline
668     ) external;
669 
670     function swapExactETHForTokensSupportingFeeOnTransferTokens(
671         uint256 amountOutMin,
672         address[] calldata path,
673         address to,
674         uint256 deadline
675     ) external payable;
676 
677     function swapExactTokensForETHSupportingFeeOnTransferTokens(
678         uint256 amountIn,
679         uint256 amountOutMin,
680         address[] calldata path,
681         address to,
682         uint256 deadline
683     ) external;
684 }
685 
686 contract AARDVARK is ERC20, Ownable {
687     using SafeMath for uint256;
688 
689     IUniswapV2Router02 public immutable uniswapV2Router;
690     address public immutable uniswapV2Pair;
691     address public constant deadAddress = address(0xdead);
692 
693     bool private swapping;
694 
695     address public marketingWallet;
696     address public devWallet;
697 
698     uint256 public maxTransactionAmount;
699     uint256 public swapTokensAtAmount;
700     uint256 public maxWallet;
701 
702     bool public limitsInEffect = true;
703     bool public tradingActive = false;
704     bool public swapEnabled = false;
705 
706     uint256 public launchedAt;
707     uint256 public launchedAtTimestamp;
708 
709     uint256 public buyTotalFees = 90;
710     uint256 public buyMarketingFee = 90;
711     uint256 public buyDevFee = 0;
712 
713     uint256 public sellTotalFees = 90;
714     uint256 public sellMarketingFee = 90;
715     uint256 public sellDevFee = 0;
716 
717     uint256 public tokensForMarketing;
718     uint256 public tokensForDev;
719 
720     /******************/
721 
722     // exlcude from fees and max transaction amount
723     mapping(address => bool) private _isExcludedFromFees;
724     mapping(address => bool) public _isExcludedMaxTransactionAmount;
725     mapping(address => bool) public isSniper;
726 
727     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
728     // could be subject to a maximum transfer amount
729     mapping(address => bool) public automatedMarketMakerPairs;
730 
731     event UpdateUniswapV2Router(
732         address indexed newAddress,
733         address indexed oldAddress
734     );
735 
736     event ExcludeFromFees(address indexed account, bool isExcluded);
737 
738     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
739 
740     event marketingWalletUpdated(
741         address indexed newWallet,
742         address indexed oldWallet
743     );
744 
745     event devWalletUpdated(
746         address indexed newWallet,
747         address indexed oldWallet
748     );
749     event SwapAndLiquify(
750         uint256 tokensSwapped,
751         uint256 ethReceived,
752         uint256 tokensIntoLiquidity
753     );
754 
755     constructor() ERC20("Aardvark", "ARDVRK") {
756         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
757             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
758         );
759 
760         excludeFromMaxTransaction(address(_uniswapV2Router), true);
761         uniswapV2Router = _uniswapV2Router;
762 
763         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
764             .createPair(address(this), _uniswapV2Router.WETH());
765         excludeFromMaxTransaction(address(uniswapV2Pair), true);
766         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
767 
768         uint256 totalSupply = 1_212_091_913 * 1e18;
769 
770         maxTransactionAmount = totalSupply / 100; // 1% from total supply maxTransactionAmountTxn
771         maxWallet = totalSupply.mul(2) / 100; // 2% from total supply maxWallet
772         swapTokensAtAmount = totalSupply / 1000;
773 
774         marketingWallet = address(msg.sender); // set as marketing wallet
775         devWallet = address(msg.sender); // set as Dev wallet
776 
777         // exclude from paying fees or having max transaction amount
778         excludeFromFees(owner(), true);
779         excludeFromFees(address(this), true);
780         excludeFromFees(address(0xdead), true);
781 
782         excludeFromMaxTransaction(owner(), true);
783         excludeFromMaxTransaction(address(this), true);
784         excludeFromMaxTransaction(address(0xdead), true);
785         /*
786             _mint is an internal function in ERC20.sol that is only called here,
787             and CANNOT be called ever again
788         */
789         _mint(owner(), totalSupply);
790     }
791 
792     receive() external payable {}
793 
794     function launched() internal view returns (bool) {
795         return launchedAt != 0;
796     }
797 
798     function launch() public onlyOwner {
799         require(launchedAt == 0, "Already launched boi");
800         launchedAt = block.number;
801         launchedAtTimestamp = block.timestamp;
802         tradingActive = true;
803         swapEnabled = true;
804     }
805 
806     // remove limits after token is stable
807     function removeLimits() external onlyOwner returns (bool) {
808         limitsInEffect = false;
809         return true;
810     }
811 
812     // change the minimum amount of tokens to sell from fees
813     function updateSwapTokensAtAmount(
814         uint256 newAmount
815     ) external onlyOwner returns (bool) {
816         swapTokensAtAmount = newAmount * (10 ** 18);
817         return true;
818     }
819 
820     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
821         maxTransactionAmount = newNum * (10 ** 18);
822     }
823 
824     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
825         maxWallet = newNum * (10 ** 18);
826     }
827 
828     function excludeFromMaxTransaction(
829         address updAds,
830         bool isEx
831     ) public onlyOwner {
832         _isExcludedMaxTransactionAmount[updAds] = isEx;
833     }
834 
835     // only use to disable contract sales if absolutely necessary (emergency use only)
836     function updateSwapEnabled(bool enabled) external onlyOwner {
837         swapEnabled = enabled;
838     }
839 
840     function updateBuyFees(
841         uint256 _marketingFee,
842         uint256 _devFee
843     ) external onlyOwner {
844         buyMarketingFee = _marketingFee;
845         buyDevFee = _devFee;
846         buyTotalFees = buyMarketingFee + buyDevFee;
847     }
848 
849     function updateSellFees(
850         uint256 _marketingFee,
851         uint256 _devFee
852     ) external onlyOwner {
853         sellMarketingFee = _marketingFee;
854         sellDevFee = _devFee;
855         sellTotalFees = sellMarketingFee + sellDevFee;
856     }
857 
858     function excludeFromFees(address account, bool excluded) public onlyOwner {
859         _isExcludedFromFees[account] = excluded;
860         emit ExcludeFromFees(account, excluded);
861     }
862 
863     function setAutomatedMarketMakerPair(
864         address pair,
865         bool value
866     ) public onlyOwner {
867         require(
868             pair != uniswapV2Pair,
869             "The pair cannot be removed from automatedMarketMakerPairs"
870         );
871 
872         _setAutomatedMarketMakerPair(pair, value);
873     }
874 
875     function _setAutomatedMarketMakerPair(address pair, bool value) private {
876         automatedMarketMakerPairs[pair] = value;
877 
878         emit SetAutomatedMarketMakerPair(pair, value);
879     }
880 
881     function updateMarketingWallet(
882         address newMarketingWallet
883     ) external onlyOwner {
884         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
885         marketingWallet = newMarketingWallet;
886     }
887 
888     function updateDevWallet(address newWallet) external onlyOwner {
889         emit devWalletUpdated(newWallet, devWallet);
890         devWallet = newWallet;
891     }
892 
893     function isExcludedFromFees(address account) public view returns (bool) {
894         return _isExcludedFromFees[account];
895     }
896 
897     function addSniperInList(address _account) external onlyOwner {
898         require(
899             _account != address(uniswapV2Router),
900             "We can not blacklist router"
901         );
902         require(!isSniper[_account], "Sniper already exist");
903         isSniper[_account] = true;
904     }
905 
906     function removeSniperFromList(address _account) external onlyOwner {
907         require(isSniper[_account], "Not a sniper");
908         isSniper[_account] = false;
909     }
910 
911     function _transfer(
912         address from,
913         address to,
914         uint256 amount
915     ) internal override {
916         require(from != address(0), "ERC20: transfer from the zero address");
917         require(to != address(0), "ERC20: transfer to the zero address");
918         require(!isSniper[to], "Sniper detected");
919         require(!isSniper[from], "Sniper detected");
920 
921         if (amount == 0) {
922             super._transfer(from, to, 0);
923             return;
924         }
925 
926         if (limitsInEffect) {
927             if (
928                 from != owner() &&
929                 to != owner() &&
930                 to != address(0) &&
931                 to != address(0xdead) &&
932                 !swapping
933             ) {
934                 if (!tradingActive) {
935                     require(
936                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
937                         "Trading is not active."
938                     );
939                 }
940                 //when buy
941                 if (
942                     automatedMarketMakerPairs[from] &&
943                     !_isExcludedMaxTransactionAmount[to]
944                 ) {
945                     require(
946                         amount <= maxTransactionAmount,
947                         "Buy transfer amount exceeds the maxTransactionAmount."
948                     );
949                     require(
950                         amount + balanceOf(to) <= maxWallet,
951                         "Max wallet exceeded"
952                     );
953                 }
954                 //when sell
955                 else if (
956                     automatedMarketMakerPairs[to] &&
957                     !_isExcludedMaxTransactionAmount[from]
958                 ) {
959                     require(
960                         amount <= maxTransactionAmount,
961                         "Sell transfer amount exceeds the maxTransactionAmount."
962                     );
963                 } else if (!_isExcludedMaxTransactionAmount[to]) {
964                     require(
965                         amount + balanceOf(to) <= maxWallet,
966                         "Max wallet exceeded"
967                     );
968                 }
969             }
970         }
971 
972         uint256 contractTokenBalance = balanceOf(address(this));
973 
974         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
975 
976         if (
977             canSwap &&
978             swapEnabled &&
979             !swapping &&
980             !automatedMarketMakerPairs[from] &&
981             !_isExcludedFromFees[from] &&
982             !_isExcludedFromFees[to]
983         ) {
984             swapping = true;
985 
986             swapBack();
987 
988             swapping = false;
989         }
990 
991         bool takeFee = !swapping;
992 
993         // if any account belongs to _isExcludedFromFee account then remove the fee
994         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
995             takeFee = false;
996         }
997 
998         uint256 fees = 0;
999         // only take fees on buys/sells, do not take on wallet transfers
1000         if (takeFee) {
1001             // on sell
1002             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1003                 fees = amount.mul(sellTotalFees).div(100);
1004                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1005                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1006             }
1007             // on buy
1008             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1009                 fees = amount.mul(buyTotalFees).div(100);
1010                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1011                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1012             }
1013 
1014             if (fees > 0) {
1015                 super._transfer(from, address(this), fees);
1016             }
1017 
1018             amount -= fees;
1019         }
1020 
1021         super._transfer(from, to, amount);
1022     }
1023 
1024     function swapTokensForEth(uint256 tokenAmount) private {
1025         // generate the uniswap pair path of token -> weth
1026         address[] memory path = new address[](2);
1027         path[0] = address(this);
1028         path[1] = uniswapV2Router.WETH();
1029 
1030         _approve(address(this), address(uniswapV2Router), tokenAmount);
1031 
1032         // make the swap
1033         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1034             tokenAmount,
1035             0, // accept any amount of ETH
1036             path,
1037             address(this),
1038             block.timestamp
1039         );
1040     }
1041 
1042     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1043         // approve token transfer to cover all possible scenarios
1044         _approve(address(this), address(uniswapV2Router), tokenAmount);
1045 
1046         // add the liquidity
1047         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1048             address(this),
1049             tokenAmount,
1050             0, // slippage is unavoidable
1051             0, // slippage is unavoidable
1052             deadAddress,
1053             block.timestamp
1054         );
1055     }
1056 
1057     function swapBack() private {
1058         uint256 contractBalance = balanceOf(address(this));
1059         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
1060         bool success;
1061 
1062         if (contractBalance == 0 || totalTokensToSwap == 0) {
1063             return;
1064         }
1065 
1066         if (contractBalance > swapTokensAtAmount) {
1067             contractBalance = swapTokensAtAmount;
1068         }
1069 
1070         uint256 amountToSwapForETH = contractBalance;
1071 
1072         swapTokensForEth(amountToSwapForETH);
1073 
1074         uint256 ethBalance = address(this).balance;
1075 
1076         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1077             totalTokensToSwap
1078         );
1079 
1080         tokensForMarketing = 0;
1081         tokensForDev = 0;
1082 
1083         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1084         (success, ) = address(devWallet).call{value: address(this).balance}("");
1085     }
1086 
1087     // TO transfer tokens to multi users through single transaction
1088     function airdrop(
1089         address[] calldata addresses,
1090         uint256[] calldata amounts
1091     ) external onlyOwner {
1092         require(
1093             addresses.length == amounts.length,
1094             "Array sizes must be equal"
1095         );
1096         uint256 i = 0;
1097         while (i < addresses.length) {
1098             uint256 _amount = amounts[i].mul(1e18);
1099             _transfer(msg.sender, addresses[i], _amount);
1100             i += 1;
1101         }
1102     }
1103 
1104     // to withdarw ETH from contract
1105     function withdrawETH(uint256 _amount) external onlyOwner {
1106         require(address(this).balance >= _amount, "Invalid Amount");
1107         payable(msg.sender).transfer(_amount);
1108     }
1109 
1110     // to withdraw ERC20 tokens from contract
1111     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1112         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1113         _token.transfer(msg.sender, _amount);
1114     }
1115 }