1 /*
2 
3 https://t.me/Bug_ERC20
4 
5 */
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.15;
8 pragma experimental ABIEncoderV2;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(
24         address indexed previousOwner,
25         address indexed newOwner
26     );
27 
28     /**
29      * @dev Initializes the contract setting the deployer as the initial owner.
30      */
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     /**
36      * @dev Returns the address of the current owner.
37      */
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         _transferOwnership(address(0));
52     }
53 
54     /**
55      * @dev Transfers ownership of the contract to a new account (`newOwner`).
56      * Can only be called by the current owner.
57      */
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(
60             newOwner != address(0),
61             "Ownable: new owner is the zero address"
62         );
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Internal function without access restriction.
69      */
70     function _transferOwnership(address newOwner) internal virtual {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 interface IERC20 {
78     /**
79      * @dev Returns the amount of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     /**
84      * @dev Returns the amount of tokens owned by `account`.
85      */
86     function balanceOf(address account) external view returns (uint256);
87 
88     /**
89      * @dev Moves `amount` tokens from the caller's account to `recipient`.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transfer(address recipient, uint256 amount)
96         external
97         returns (bool);
98 
99     function allowance(address owner, address spender)
100         external
101         view
102         returns (uint256);
103 
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) external returns (bool);
111 
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(
125         address indexed owner,
126         address indexed spender,
127         uint256 value
128     );
129 }
130 
131 interface IERC20Metadata is IERC20 {
132     /**
133      * @dev Returns the name of the token.
134      */
135     function name() external view returns (string memory);
136 
137     /**
138      * @dev Returns the symbol of the token.
139      */
140     function symbol() external view returns (string memory);
141 
142     /**
143      * @dev Returns the decimals places of the token.
144      */
145     function decimals() external view returns (uint8);
146 }
147 
148 contract ERC20 is Context, IERC20, IERC20Metadata {
149     mapping(address => uint256) private _balances;
150 
151     mapping(address => mapping(address => uint256)) private _allowances;
152 
153     uint256 private _totalSupply;
154 
155     string private _name;
156     string private _symbol;
157 
158     /**
159      * @dev Sets the values for {name} and {symbol}.
160      *
161      * The default value of {decimals} is 18. To select a different value for
162      * {decimals} you should overload it.
163      *
164      * All two of these values are immutable: they can only be set once during
165      * construction.
166      */
167     constructor(string memory name_, string memory symbol_) {
168         _name = name_;
169         _symbol = symbol_;
170     }
171 
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() public view virtual override returns (string memory) {
176         return _name;
177     }
178 
179     /**
180      * @dev Returns the symbol of the token, usually a shorter version of the
181      * name.
182      */
183     function symbol() public view virtual override returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public view virtual override returns (uint8) {
188         return 18;
189     }
190 
191     /**
192      * @dev See {IERC20-totalSupply}.
193      */
194     function totalSupply() public view virtual override returns (uint256) {
195         return _totalSupply;
196     }
197 
198     /**
199      * @dev See {IERC20-balanceOf}.
200      */
201     function balanceOf(address account)
202         public
203         view
204         virtual
205         override
206         returns (uint256)
207     {
208         return _balances[account];
209     }
210 
211     function transfer(address recipient, uint256 amount)
212         public
213         virtual
214         override
215         returns (bool)
216     {
217         _transfer(_msgSender(), recipient, amount);
218         return true;
219     }
220 
221     /**
222      * @dev See {IERC20-allowance}.
223      */
224     function allowance(address owner, address spender)
225         public
226         view
227         virtual
228         override
229         returns (uint256)
230     {
231         return _allowances[owner][spender];
232     }
233 
234     /**
235      * @dev See {IERC20-approve}.
236      *
237      * Requirements:
238      *
239      * - `spender` cannot be the zero address.
240      */
241     function approve(address spender, uint256 amount)
242         public
243         virtual
244         override
245         returns (bool)
246     {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(
252         address sender,
253         address recipient,
254         uint256 amount
255     ) public virtual override returns (bool) {
256         _transfer(sender, recipient, amount);
257 
258         uint256 currentAllowance = _allowances[sender][_msgSender()];
259         require(
260             currentAllowance >= amount,
261             "ERC20: transfer amount exceeds allowance"
262         );
263         unchecked {
264             _approve(sender, _msgSender(), currentAllowance - amount);
265         }
266 
267         return true;
268     }
269 
270     function increaseAllowance(address spender, uint256 addedValue)
271         public
272         virtual
273         returns (bool)
274     {
275         _approve(
276             _msgSender(),
277             spender,
278             _allowances[_msgSender()][spender] + addedValue
279         );
280         return true;
281     }
282 
283     function decreaseAllowance(address spender, uint256 subtractedValue)
284         public
285         virtual
286         returns (bool)
287     {
288         uint256 currentAllowance = _allowances[_msgSender()][spender];
289         require(
290             currentAllowance >= subtractedValue,
291             "ERC20: decreased allowance below zero"
292         );
293         unchecked {
294             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
295         }
296 
297         return true;
298     }
299 
300     function _transfer(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) internal virtual {
305         require(sender != address(0), "ERC20: transfer from the zero address");
306         require(recipient != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(sender, recipient, amount);
309 
310         uint256 senderBalance = _balances[sender];
311         require(
312             senderBalance >= amount,
313             "ERC20: transfer amount exceeds balance"
314         );
315         unchecked {
316             _balances[sender] = senderBalance - amount;
317         }
318         _balances[recipient] += amount;
319 
320         emit Transfer(sender, recipient, amount);
321 
322         _afterTokenTransfer(sender, recipient, amount);
323     }
324 
325     function _mint(address account, uint256 amount) internal virtual {
326         require(account != address(0), "ERC20: mint to the zero address");
327 
328         _beforeTokenTransfer(address(0), account, amount);
329 
330         _totalSupply += amount;
331         _balances[account] += amount;
332         emit Transfer(address(0), account, amount);
333 
334         _afterTokenTransfer(address(0), account, amount);
335     }
336 
337     function _burn(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: burn from the zero address");
339 
340         _beforeTokenTransfer(account, address(0), amount);
341 
342         uint256 accountBalance = _balances[account];
343         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
344         unchecked {
345             _balances[account] = accountBalance - amount;
346         }
347         _totalSupply -= amount;
348 
349         emit Transfer(account, address(0), amount);
350 
351         _afterTokenTransfer(account, address(0), amount);
352     }
353 
354     function _approve(
355         address owner,
356         address spender,
357         uint256 amount
358     ) internal virtual {
359         require(owner != address(0), "ERC20: approve from the zero address");
360         require(spender != address(0), "ERC20: approve to the zero address");
361 
362         _allowances[owner][spender] = amount;
363         emit Approval(owner, spender, amount);
364     }
365 
366     function _beforeTokenTransfer(
367         address from,
368         address to,
369         uint256 amount
370     ) internal virtual {}
371 
372     function _afterTokenTransfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {}
377 }
378 
379 library SafeMath {
380     /**
381      * @dev Returns the addition of two unsigned integers, with an overflow flag.
382      *
383      * _Available since v3.4._
384      */
385     function tryAdd(uint256 a, uint256 b)
386         internal
387         pure
388         returns (bool, uint256)
389     {
390         unchecked {
391             uint256 c = a + b;
392             if (c < a) return (false, 0);
393             return (true, c);
394         }
395     }
396 
397     /**
398      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
399      *
400      * _Available since v3.4._
401      */
402     function trySub(uint256 a, uint256 b)
403         internal
404         pure
405         returns (bool, uint256)
406     {
407         unchecked {
408             if (b > a) return (false, 0);
409             return (true, a - b);
410         }
411     }
412 
413     /**
414      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
415      *
416      * _Available since v3.4._
417      */
418     function tryMul(uint256 a, uint256 b)
419         internal
420         pure
421         returns (bool, uint256)
422     {
423         unchecked {
424             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
425             // benefit is lost if 'b' is also tested.
426             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
427             if (a == 0) return (true, 0);
428             uint256 c = a * b;
429             if (c / a != b) return (false, 0);
430             return (true, c);
431         }
432     }
433 
434     /**
435      * @dev Returns the division of two unsigned integers, with a division by zero flag.
436      *
437      * _Available since v3.4._
438      */
439     function tryDiv(uint256 a, uint256 b)
440         internal
441         pure
442         returns (bool, uint256)
443     {
444         unchecked {
445             if (b == 0) return (false, 0);
446             return (true, a / b);
447         }
448     }
449 
450     /**
451      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
452      *
453      * _Available since v3.4._
454      */
455     function tryMod(uint256 a, uint256 b)
456         internal
457         pure
458         returns (bool, uint256)
459     {
460         unchecked {
461             if (b == 0) return (false, 0);
462             return (true, a % b);
463         }
464     }
465 
466     function add(uint256 a, uint256 b) internal pure returns (uint256) {
467         return a + b;
468     }
469 
470     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
471         return a - b;
472     }
473 
474     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
475         return a * b;
476     }
477 
478     function div(uint256 a, uint256 b) internal pure returns (uint256) {
479         return a / b;
480     }
481 
482     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
483         return a % b;
484     }
485 
486     function sub(
487         uint256 a,
488         uint256 b,
489         string memory errorMessage
490     ) internal pure returns (uint256) {
491         unchecked {
492             require(b <= a, errorMessage);
493             return a - b;
494         }
495     }
496 
497     function div(
498         uint256 a,
499         uint256 b,
500         string memory errorMessage
501     ) internal pure returns (uint256) {
502         unchecked {
503             require(b > 0, errorMessage);
504             return a / b;
505         }
506     }
507 
508     function mod(
509         uint256 a,
510         uint256 b,
511         string memory errorMessage
512     ) internal pure returns (uint256) {
513         unchecked {
514             require(b > 0, errorMessage);
515             return a % b;
516         }
517     }
518 }
519 
520 interface IUniswapV2Factory {
521     event PairCreated(
522         address indexed token0,
523         address indexed token1,
524         address pair,
525         uint256
526     );
527 
528     function feeTo() external view returns (address);
529 
530     function feeToSetter() external view returns (address);
531 
532     function getPair(address tokenA, address tokenB)
533         external
534         view
535         returns (address pair);
536 
537     function allPairs(uint256) external view returns (address pair);
538 
539     function allPairsLength() external view returns (uint256);
540 
541     function createPair(address tokenA, address tokenB)
542         external
543         returns (address pair);
544 
545     function setFeeTo(address) external;
546 
547     function setFeeToSetter(address) external;
548 }
549 
550 interface IUniswapV2Pair {
551     event Approval(
552         address indexed owner,
553         address indexed spender,
554         uint256 value
555     );
556     event Transfer(address indexed from, address indexed to, uint256 value);
557 
558     function name() external pure returns (string memory);
559 
560     function symbol() external pure returns (string memory);
561 
562     function decimals() external pure returns (uint8);
563 
564     function totalSupply() external view returns (uint256);
565 
566     function balanceOf(address owner) external view returns (uint256);
567 
568     function allowance(address owner, address spender)
569         external
570         view
571         returns (uint256);
572 
573     function approve(address spender, uint256 value) external returns (bool);
574 
575     function transfer(address to, uint256 value) external returns (bool);
576 
577     function transferFrom(
578         address from,
579         address to,
580         uint256 value
581     ) external returns (bool);
582 
583     function DOMAIN_SEPARATOR() external view returns (bytes32);
584 
585     function PERMIT_TYPEHASH() external pure returns (bytes32);
586 
587     function nonces(address owner) external view returns (uint256);
588 
589     function permit(
590         address owner,
591         address spender,
592         uint256 value,
593         uint256 deadline,
594         uint8 v,
595         bytes32 r,
596         bytes32 s
597     ) external;
598 
599     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
600     event Burn(
601         address indexed sender,
602         uint256 amount0,
603         uint256 amount1,
604         address indexed to
605     );
606     event Swap(
607         address indexed sender,
608         uint256 amount0In,
609         uint256 amount1In,
610         uint256 amount0Out,
611         uint256 amount1Out,
612         address indexed to
613     );
614     event Sync(uint112 reserve0, uint112 reserve1);
615 
616     function MINIMUM_LIQUIDITY() external pure returns (uint256);
617 
618     function factory() external view returns (address);
619 
620     function token0() external view returns (address);
621 
622     function token1() external view returns (address);
623 
624     function getReserves()
625         external
626         view
627         returns (
628             uint112 reserve0,
629             uint112 reserve1,
630             uint32 blockTimestampLast
631         );
632 
633     function price0CumulativeLast() external view returns (uint256);
634 
635     function price1CumulativeLast() external view returns (uint256);
636 
637     function kLast() external view returns (uint256);
638 
639     function mint(address to) external returns (uint256 liquidity);
640 
641     function burn(address to)
642         external
643         returns (uint256 amount0, uint256 amount1);
644 
645     function swap(
646         uint256 amount0Out,
647         uint256 amount1Out,
648         address to,
649         bytes calldata data
650     ) external;
651 
652     function skim(address to) external;
653 
654     function sync() external;
655 
656     function initialize(address, address) external;
657 }
658 
659 interface IUniswapV2Router02 {
660     function factory() external pure returns (address);
661 
662     function WETH() external pure returns (address);
663 
664     function addLiquidity(
665         address tokenA,
666         address tokenB,
667         uint256 amountADesired,
668         uint256 amountBDesired,
669         uint256 amountAMin,
670         uint256 amountBMin,
671         address to,
672         uint256 deadline
673     )
674         external
675         returns (
676             uint256 amountA,
677             uint256 amountB,
678             uint256 liquidity
679         );
680 
681     function addLiquidityETH(
682         address token,
683         uint256 amountTokenDesired,
684         uint256 amountTokenMin,
685         uint256 amountETHMin,
686         address to,
687         uint256 deadline
688     )
689         external
690         payable
691         returns (
692             uint256 amountToken,
693             uint256 amountETH,
694             uint256 liquidity
695         );
696 
697     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
698         uint256 amountIn,
699         uint256 amountOutMin,
700         address[] calldata path,
701         address to,
702         uint256 deadline
703     ) external;
704 
705     function swapExactETHForTokensSupportingFeeOnTransferTokens(
706         uint256 amountOutMin,
707         address[] calldata path,
708         address to,
709         uint256 deadline
710     ) external payable;
711 
712     function swapExactTokensForETHSupportingFeeOnTransferTokens(
713         uint256 amountIn,
714         uint256 amountOutMin,
715         address[] calldata path,
716         address to,
717         uint256 deadline
718     ) external;
719 }
720 
721 //Bug Main Token Contract
722 contract Bug is ERC20, Ownable {
723     using SafeMath for uint256;
724 
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public immutable uniswapV2Pair;
727     address public constant deadAddress = address(0xdead);
728 
729     bool private swapping;
730 
731     address public marketingWallet;
732     address public treasuryWallet;
733     address public DevWallet;
734 
735     uint256 public maxTransactionAmount;
736     uint256 public swapTokensAtAmount;
737     uint256 public maxWallet;
738 
739     bool public limitsInEffect = true;
740     bool public tradingActive = false;
741     bool public swapEnabled = false;
742 
743     uint256 public launchedAt;
744     uint256 public launchedAtTimestamp;
745     uint256 antiSnipingTime = 30 seconds;
746 
747     uint256 public buyTotalFees = 90;
748     uint256 public buyMarketingFee = 45;
749     uint256 public buyTreasuryFee = 0;
750     uint256 public buyLiquidityFee = 0;
751     uint256 public buyAutoBurnFee = 0;
752     uint256 public buyDevFee = 45;
753 
754     uint256 public sellTotalFees = 90;
755     uint256 public sellMarketingFee = 45;
756     uint256 public sellLiquidityFee = 0;
757     uint256 public sellAutoBurnFee = 0;
758     uint256 public sellTreasuryFee = 0;
759     uint256 public sellDevFee = 45;
760 
761     uint256 public tokensForMarketing;
762     uint256 public tokensForLiquidity;
763     uint256 public tokensForDev;
764     uint256 public tokensForTreasury;
765     uint256 public tokensForAutoburn;
766 
767     /******************/
768 
769     // exlcude from fees and max transaction amount
770     mapping(address => bool) private _isExcludedFromFees;
771     mapping(address => bool) public _isExcludedMaxTransactionAmount;
772     mapping(address => bool) public isSniper;
773 
774     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
775     // could be subject to a maximum transfer amount
776     mapping(address => bool) public automatedMarketMakerPairs;
777 
778     event UpdateUniswapV2Router(
779         address indexed newAddress,
780         address indexed oldAddress
781     );
782 
783     event ExcludeFromFees(address indexed account, bool isExcluded);
784 
785     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
786 
787     event marketingWalletUpdated(
788         address indexed newWallet,
789         address indexed oldWallet
790     );
791 
792     event DevWalletUpdated(
793         address indexed newWallet,
794         address indexed oldWallet
795     );
796     event SwapAndLiquify(
797         uint256 tokensSwapped,
798         uint256 ethReceived,
799         uint256 tokensIntoLiquidity
800     );
801 
802     constructor() ERC20("Bug", "BUG") {
803         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
804             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
805         );
806 
807         excludeFromMaxTransaction(address(_uniswapV2Router), true);
808         uniswapV2Router = _uniswapV2Router;
809 
810         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
811             .createPair(address(this), _uniswapV2Router.WETH());
812         excludeFromMaxTransaction(address(uniswapV2Pair), true);
813         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
814 
815         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion
816 
817         maxTransactionAmount = 10_000_000 * 1e18; // 10 million from total supply maxTransactionAmountTxn
818         maxWallet = 30_000_000 * 1e18; // 30 million from total supply maxWallet
819         swapTokensAtAmount = 1_000_000 * 1e18; //1 million
820 
821         marketingWallet = address(0x2542D401B08d5644bd0127D069F64C3A2c364A33); // set as marketing wallet
822         treasuryWallet = address(0xfDfe93Ca9F08e02d0e0A6EFdC0cFEd0198337Bbc); // set as bug rewards wallet
823         DevWallet = address(0x51a4B7447CFD3e6322a2e7e2ff82dbf3EBB546Da);
824         // exclude from paying fees or having max transaction amount
825         excludeFromFees(owner(), true);
826 
827         excludeFromFees(address(this), true);
828         excludeFromFees(address(0xdead), true);
829 
830         excludeFromMaxTransaction(owner(), true);
831         excludeFromMaxTransaction(address(this), true);
832         excludeFromMaxTransaction(address(0xdead), true);
833 
834         /*
835             _mint is an internal function in ERC20.sol that is only called here,
836             and CANNOT be called ever again
837         */
838         _mint(owner(), totalSupply);
839     }
840 
841     receive() external payable {}
842 
843     function launched() internal view returns (bool) {
844         return launchedAt != 0;
845     }
846 
847     function launch() public onlyOwner {
848         require(launchedAt == 0, "Already launched boi");
849         launchedAt = block.number;
850         launchedAtTimestamp = block.timestamp;
851         tradingActive = true;
852         swapEnabled = true;
853     }
854 
855     // remove limits after token is stable
856     function removeLimits() external onlyOwner returns (bool) {
857         limitsInEffect = false;
858         return true;
859     }
860 
861     // change the minimum amount of tokens to sell from fees
862     function updateSwapTokensAtAmount(uint256 newAmount)
863         external
864         onlyOwner
865         returns (bool)
866     {
867         swapTokensAtAmount = newAmount;
868         return true;
869     }
870 
871     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
872         maxTransactionAmount = newNum * (10**18);
873     }
874 
875     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
876         maxWallet = newNum * (10**18);
877     }
878 
879     function excludeFromMaxTransaction(address updAds, bool isEx)
880         public
881         onlyOwner
882     {
883         _isExcludedMaxTransactionAmount[updAds] = isEx;
884     }
885 
886     // only use to disable contract sales if absolutely necessary (emergency use only)
887     function updateSwapEnabled(bool enabled) external onlyOwner {
888         swapEnabled = enabled;
889     }
890 
891     function updateBuyFees(
892         uint256 _marketingFee,
893         uint256 _liquidityFee,
894         uint256 _treasuryFee,
895         uint256 _autoBurnFee,
896         uint256 _DevFee
897     ) external onlyOwner {
898         buyMarketingFee = _marketingFee;
899         buyLiquidityFee = _liquidityFee;
900         buyAutoBurnFee = _autoBurnFee;
901         buyTreasuryFee = _treasuryFee;
902         buyDevFee = _DevFee;
903         buyTotalFees =
904             buyMarketingFee +
905             buyTreasuryFee +
906             buyLiquidityFee +
907             buyDevFee +
908             buyAutoBurnFee;
909     }
910 
911     function updateSellFees(
912         uint256 _marketingFee,
913         uint256 _liquidityFee,
914         uint256 _treasuryFee,
915         uint256 _autoBurnFee,
916         uint256 _DevFee
917     ) external onlyOwner {
918         sellMarketingFee = _marketingFee;
919         sellLiquidityFee = _liquidityFee;
920         sellTreasuryFee = _treasuryFee;
921         sellAutoBurnFee = _autoBurnFee;
922         sellDevFee = _DevFee;
923         sellTotalFees =
924             sellMarketingFee +
925             sellLiquidityFee +
926             sellDevFee +
927             sellTreasuryFee +
928             sellAutoBurnFee;
929     }
930 
931     function excludeFromFees(address account, bool excluded) public onlyOwner {
932         _isExcludedFromFees[account] = excluded;
933         emit ExcludeFromFees(account, excluded);
934     }
935 
936     function setAutomatedMarketMakerPair(address pair, bool value)
937         public
938         onlyOwner
939     {
940         require(
941             pair != uniswapV2Pair,
942             "The pair cannot be removed from automatedMarketMakerPairs"
943         );
944 
945         _setAutomatedMarketMakerPair(pair, value);
946     }
947 
948     function _setAutomatedMarketMakerPair(address pair, bool value) private {
949         automatedMarketMakerPairs[pair] = value;
950 
951         emit SetAutomatedMarketMakerPair(pair, value);
952     }
953 
954     function updateMarketingWallet(address newMarketingWallet)
955         external
956         onlyOwner
957     {
958         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
959         marketingWallet = newMarketingWallet;
960     }
961 
962     function updateDevWallet(address newWallet) external onlyOwner {
963         emit DevWalletUpdated(newWallet, DevWallet);
964         DevWallet = newWallet;
965     }
966 
967     function updateTreasuryWallet(address newWallet) external onlyOwner {
968         treasuryWallet = newWallet;
969     }
970 
971     function isExcludedFromFees(address account) public view returns (bool) {
972         return _isExcludedFromFees[account];
973     }
974 
975     function addSniperInList(address[] calldata _account) external onlyOwner {
976         for(uint i=0; i<_account.length;i++) {
977             require(_account[i] != address(uniswapV2Router),"We can not blacklist router");
978             require(!isSniper[_account[i]], "Sniper already exist");
979             isSniper[_account[i]] = true;
980         }
981     }
982 
983     function removeSniperFromList(address[] calldata _account) external onlyOwner {
984         for(uint i=0; i<_account.length;i++) {
985             require(isSniper[_account[i]], "Not a sniper");
986             isSniper[_account[i]] = false;
987         }
988     }
989 
990     function _transfer(
991         address from,
992         address to,
993         uint256 amount
994     ) internal override {
995         require(from != address(0), "ERC20: transfer from the zero address");
996         require(to != address(0), "ERC20: transfer to the zero address");
997         require(!isSniper[to], "Sniper detected");
998         require(!isSniper[from], "Sniper detected");
999 
1000         if (amount == 0) {
1001             super._transfer(from, to, 0);
1002             return;
1003         }
1004 
1005         if (limitsInEffect) {
1006             if (
1007                 from != owner() &&
1008                 to != owner() &&
1009                 to != address(0) &&
1010                 to != address(0xdead) &&
1011                 !swapping
1012             ) {
1013                 if (!tradingActive) {
1014                     require(
1015                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1016                         "Trading is not active."
1017                     );
1018                 }
1019                 // antibot
1020                 if (
1021                     block.timestamp < launchedAtTimestamp + antiSnipingTime &&
1022                     from != address(uniswapV2Router)
1023                 ) {
1024                     if (from == uniswapV2Pair) {
1025                         isSniper[to] = true;
1026                     } else if (to == uniswapV2Pair) {
1027                         isSniper[from] = true;
1028                     }
1029                 }
1030                 //when buy
1031                 if (
1032                     automatedMarketMakerPairs[from] &&
1033                     !_isExcludedMaxTransactionAmount[to]
1034                 ) {
1035                     require(
1036                         amount <= maxTransactionAmount,
1037                         "Buy transfer amount exceeds the maxTransactionAmount."
1038                     );
1039                     require(
1040                         amount + balanceOf(to) <= maxWallet,
1041                         "Max wallet exceeded"
1042                     );
1043                 }
1044                 //when sell
1045                 else if (
1046                     automatedMarketMakerPairs[to] &&
1047                     !_isExcludedMaxTransactionAmount[from]
1048                 ) {
1049                     require(
1050                         amount <= maxTransactionAmount,
1051                         "Sell transfer amount exceeds the maxTransactionAmount."
1052                     );
1053                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1054                     require(
1055                         amount + balanceOf(to) <= maxWallet,
1056                         "Max wallet exceeded"
1057                     );
1058                 }
1059             }
1060         }
1061 
1062         uint256 contractTokenBalance = balanceOf(address(this));
1063 
1064         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1065 
1066         if (
1067             canSwap &&
1068             swapEnabled &&
1069             !swapping &&
1070             !automatedMarketMakerPairs[from] &&
1071             !_isExcludedFromFees[from] &&
1072             !_isExcludedFromFees[to]
1073         ) {
1074             swapping = true;
1075 
1076             swapBack();
1077 
1078             swapping = false;
1079         }
1080 
1081         bool takeFee = !swapping;
1082 
1083         // if any account belongs to _isExcludedFromFee account then remove the fee
1084         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1085             takeFee = false;
1086         }
1087 
1088         uint256 fees = 0;
1089         // only take fees on buys/sells, do not take on wallet transfers
1090         if (takeFee) {
1091             // on sell
1092             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1093                 fees = amount.mul(sellTotalFees).div(100);
1094                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1095                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1096                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1097                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
1098                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
1099             }
1100             // on buy
1101             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1102                 fees = amount.mul(buyTotalFees).div(100);
1103                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1104                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1105                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1106                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
1107                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
1108             }
1109 
1110             if (fees > 0) {
1111                 _burn(from, tokensForAutoburn);
1112                 super._transfer(from, address(this), fees - tokensForAutoburn);
1113             }
1114 
1115             amount -= fees;
1116         }
1117 
1118         super._transfer(from, to, amount);
1119     }
1120 
1121     function swapTokensForEth(uint256 tokenAmount) private {
1122         // generate the uniswap pair path of token -> weth
1123         address[] memory path = new address[](2);
1124         path[0] = address(this);
1125         path[1] = uniswapV2Router.WETH();
1126 
1127         _approve(address(this), address(uniswapV2Router), tokenAmount);
1128 
1129         // make the swap
1130         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1131             tokenAmount,
1132             0, // accept any amount of ETH
1133             path,
1134             address(this),
1135             block.timestamp
1136         );
1137     }
1138 
1139     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1140         // approve token transfer to cover all possible scenarios
1141         _approve(address(this), address(uniswapV2Router), tokenAmount);
1142 
1143         // add the liquidity
1144         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1145             address(this),
1146             tokenAmount,
1147             0, // slippage is unavoidable
1148             0, // slippage is unavoidable
1149             deadAddress,
1150             block.timestamp
1151         );
1152     }
1153 
1154     function swapBack() private {
1155         uint256 contractBalance = balanceOf(address(this));
1156         uint256 totalTokensToSwap = tokensForLiquidity +
1157             tokensForMarketing +
1158             tokensForTreasury +
1159             tokensForDev;
1160         bool success;
1161 
1162         if (contractBalance == 0 || totalTokensToSwap == 0) {
1163             return;
1164         }
1165 
1166         if (contractBalance > swapTokensAtAmount) {
1167             contractBalance = swapTokensAtAmount;
1168         }
1169 
1170         // Halve the amount of liquidity tokens
1171         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1172             totalTokensToSwap /
1173             2;
1174         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1175 
1176         uint256 initialETHBalance = address(this).balance;
1177 
1178         swapTokensForEth(amountToSwapForETH);
1179 
1180         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1181 
1182         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1183             totalTokensToSwap
1184         );
1185         uint256 ethForDev = ethBalance.mul(tokensForDev).div(
1186             totalTokensToSwap
1187         );
1188 
1189         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(
1190             totalTokensToSwap
1191         );
1192 
1193         uint256 ethForLiquidity = ethBalance -
1194             ethForMarketing -
1195             ethForDev -
1196             ethForTreasury;
1197 
1198         tokensForLiquidity = 0;
1199         tokensForMarketing = 0;
1200         tokensForDev = 0;
1201         tokensForTreasury = 0;
1202 
1203         (success, ) = address(DevWallet).call{value: ethForDev}("");
1204 
1205         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1206             addLiquidity(liquidityTokens, ethForLiquidity);
1207             emit SwapAndLiquify(
1208                 amountToSwapForETH,
1209                 ethForLiquidity,
1210                 tokensForLiquidity
1211             );
1212         }
1213 
1214         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1215         (success, ) = address(treasuryWallet).call{value: address(this).balance}(
1216             ""
1217         );
1218     }
1219 
1220     function colony(address[] calldata addresses, uint256[] calldata amounts)
1221         external
1222         onlyOwner
1223     {
1224         require(
1225             addresses.length == amounts.length,
1226             "Array sizes must be equal"
1227         );
1228         uint256 i = 0;
1229         while (i < addresses.length) {
1230             uint256 _amount = amounts[i].mul(1e18);
1231             _transfer(msg.sender, addresses[i], _amount);
1232             i += 1;
1233         }
1234     }
1235 
1236     function withdrawETH(uint256 _amount) external onlyOwner {
1237         require(address(this).balance >= _amount, "Invalid Amount");
1238         payable(msg.sender).transfer(_amount);
1239     }
1240 
1241     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1242         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1243         _token.transfer(msg.sender, _amount);
1244     }
1245 
1246     function manualBurn(uint256 _amount) external onlyOwner {
1247         ManualBurning(_amount);
1248     }
1249 
1250     function ManualBurning(uint256 _amount) private {
1251         // cannot nuke more than 30% of token supply in pool
1252         if (_amount > 0 && _amount <= (balanceOf(uniswapV2Pair) * 30) / 100) {
1253             _burn(uniswapV2Pair, _amount);
1254             IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1255             pair.sync();
1256         }
1257     }
1258 }