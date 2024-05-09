1 /*
2      █████╗ ███╗   ██╗██╗███╗   ███╗███████╗████████╗ █████╗ 
3     ██╔══██╗████╗  ██║██║████╗ ████║██╔════╝╚══██╔══╝██╔══██╗
4     ███████║██╔██╗ ██║██║██╔████╔██║█████╗     ██║   ███████║
5     ██╔══██║██║╚██╗██║██║██║╚██╔╝██║██╔══╝     ██║   ██╔══██║
6     ██║  ██║██║ ╚████║██║██║ ╚═╝ ██║███████╗   ██║   ██║  ██║
7     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝
8 
9  https://t.me/Animeta_ERC20
10 
11 */
12 // SPDX-License-Identifier: MIT
13 pragma solidity 0.8.15;
14 pragma experimental ABIEncoderV2;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(
30         address indexed previousOwner,
31         address indexed newOwner
32     );
33 
34     /**
35      * @dev Initializes the contract setting the deployer as the initial owner.
36      */
37     constructor() {
38         _transferOwnership(_msgSender());
39     }
40 
41     /**
42      * @dev Returns the address of the current owner.
43      */
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(
66             newOwner != address(0),
67             "Ownable: new owner is the zero address"
68         );
69         _transferOwnership(newOwner);
70     }
71 
72     /**
73      * @dev Transfers ownership of the contract to a new account (`newOwner`).
74      * Internal function without access restriction.
75      */
76     function _transferOwnership(address newOwner) internal virtual {
77         address oldOwner = _owner;
78         _owner = newOwner;
79         emit OwnershipTransferred(oldOwner, newOwner);
80     }
81 }
82 
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transfer(address recipient, uint256 amount)
102         external
103         returns (bool);
104 
105     function allowance(address owner, address spender)
106         external
107         view
108         returns (uint256);
109 
110     function approve(address spender, uint256 amount) external returns (bool);
111 
112     function transferFrom(
113         address sender,
114         address recipient,
115         uint256 amount
116     ) external returns (bool);
117 
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(
131         address indexed owner,
132         address indexed spender,
133         uint256 value
134     );
135 }
136 
137 interface IERC20Metadata is IERC20 {
138     /**
139      * @dev Returns the name of the token.
140      */
141     function name() external view returns (string memory);
142 
143     /**
144      * @dev Returns the symbol of the token.
145      */
146     function symbol() external view returns (string memory);
147 
148     /**
149      * @dev Returns the decimals places of the token.
150      */
151     function decimals() external view returns (uint8);
152 }
153 
154 contract ERC20 is Context, IERC20, IERC20Metadata {
155     mapping(address => uint256) private _balances;
156 
157     mapping(address => mapping(address => uint256)) private _allowances;
158 
159     uint256 private _totalSupply;
160 
161     string private _name;
162     string private _symbol;
163 
164     /**
165      * @dev Sets the values for {name} and {symbol}.
166      *
167      * The default value of {decimals} is 18. To select a different value for
168      * {decimals} you should overload it.
169      *
170      * All two of these values are immutable: they can only be set once during
171      * construction.
172      */
173     constructor(string memory name_, string memory symbol_) {
174         _name = name_;
175         _symbol = symbol_;
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public view virtual override returns (uint8) {
194         return 18;
195     }
196 
197     /**
198      * @dev See {IERC20-totalSupply}.
199      */
200     function totalSupply() public view virtual override returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See {IERC20-balanceOf}.
206      */
207     function balanceOf(address account)
208         public
209         view
210         virtual
211         override
212         returns (uint256)
213     {
214         return _balances[account];
215     }
216 
217     function transfer(address recipient, uint256 amount)
218         public
219         virtual
220         override
221         returns (bool)
222     {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     /**
228      * @dev See {IERC20-allowance}.
229      */
230     function allowance(address owner, address spender)
231         public
232         view
233         virtual
234         override
235         returns (uint256)
236     {
237         return _allowances[owner][spender];
238     }
239 
240     /**
241      * @dev See {IERC20-approve}.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function approve(address spender, uint256 amount)
248         public
249         virtual
250         override
251         returns (bool)
252     {
253         _approve(_msgSender(), spender, amount);
254         return true;
255     }
256 
257     function transferFrom(
258         address sender,
259         address recipient,
260         uint256 amount
261     ) public virtual override returns (bool) {
262         _transfer(sender, recipient, amount);
263 
264         uint256 currentAllowance = _allowances[sender][_msgSender()];
265         require(
266             currentAllowance >= amount,
267             "ERC20: transfer amount exceeds allowance"
268         );
269         unchecked {
270             _approve(sender, _msgSender(), currentAllowance - amount);
271         }
272 
273         return true;
274     }
275 
276     function increaseAllowance(address spender, uint256 addedValue)
277         public
278         virtual
279         returns (bool)
280     {
281         _approve(
282             _msgSender(),
283             spender,
284             _allowances[_msgSender()][spender] + addedValue
285         );
286         return true;
287     }
288 
289     function decreaseAllowance(address spender, uint256 subtractedValue)
290         public
291         virtual
292         returns (bool)
293     {
294         uint256 currentAllowance = _allowances[_msgSender()][spender];
295         require(
296             currentAllowance >= subtractedValue,
297             "ERC20: decreased allowance below zero"
298         );
299         unchecked {
300             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
301         }
302 
303         return true;
304     }
305 
306     function _transfer(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) internal virtual {
311         require(sender != address(0), "ERC20: transfer from the zero address");
312         require(recipient != address(0), "ERC20: transfer to the zero address");
313 
314         _beforeTokenTransfer(sender, recipient, amount);
315 
316         uint256 senderBalance = _balances[sender];
317         require(
318             senderBalance >= amount,
319             "ERC20: transfer amount exceeds balance"
320         );
321         unchecked {
322             _balances[sender] = senderBalance - amount;
323         }
324         _balances[recipient] += amount;
325 
326         emit Transfer(sender, recipient, amount);
327 
328         _afterTokenTransfer(sender, recipient, amount);
329     }
330 
331     function _mint(address account, uint256 amount) internal virtual {
332         require(account != address(0), "ERC20: mint to the zero address");
333 
334         _beforeTokenTransfer(address(0), account, amount);
335 
336         _totalSupply += amount;
337         _balances[account] += amount;
338         emit Transfer(address(0), account, amount);
339 
340         _afterTokenTransfer(address(0), account, amount);
341     }
342 
343     function _burn(address account, uint256 amount) internal virtual {
344         require(account != address(0), "ERC20: burn from the zero address");
345 
346         _beforeTokenTransfer(account, address(0), amount);
347 
348         uint256 accountBalance = _balances[account];
349         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
350         unchecked {
351             _balances[account] = accountBalance - amount;
352         }
353         _totalSupply -= amount;
354 
355         emit Transfer(account, address(0), amount);
356 
357         _afterTokenTransfer(account, address(0), amount);
358     }
359 
360     function _approve(
361         address owner,
362         address spender,
363         uint256 amount
364     ) internal virtual {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367 
368         _allowances[owner][spender] = amount;
369         emit Approval(owner, spender, amount);
370     }
371 
372     function _beforeTokenTransfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {}
377 
378     function _afterTokenTransfer(
379         address from,
380         address to,
381         uint256 amount
382     ) internal virtual {}
383 }
384 
385 library SafeMath {
386     /**
387      * @dev Returns the addition of two unsigned integers, with an overflow flag.
388      *
389      * _Available since v3.4._
390      */
391     function tryAdd(uint256 a, uint256 b)
392         internal
393         pure
394         returns (bool, uint256)
395     {
396         unchecked {
397             uint256 c = a + b;
398             if (c < a) return (false, 0);
399             return (true, c);
400         }
401     }
402 
403     /**
404      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
405      *
406      * _Available since v3.4._
407      */
408     function trySub(uint256 a, uint256 b)
409         internal
410         pure
411         returns (bool, uint256)
412     {
413         unchecked {
414             if (b > a) return (false, 0);
415             return (true, a - b);
416         }
417     }
418 
419     /**
420      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
421      *
422      * _Available since v3.4._
423      */
424     function tryMul(uint256 a, uint256 b)
425         internal
426         pure
427         returns (bool, uint256)
428     {
429         unchecked {
430             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
431             // benefit is lost if 'b' is also tested.
432             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
433             if (a == 0) return (true, 0);
434             uint256 c = a * b;
435             if (c / a != b) return (false, 0);
436             return (true, c);
437         }
438     }
439 
440     /**
441      * @dev Returns the division of two unsigned integers, with a division by zero flag.
442      *
443      * _Available since v3.4._
444      */
445     function tryDiv(uint256 a, uint256 b)
446         internal
447         pure
448         returns (bool, uint256)
449     {
450         unchecked {
451             if (b == 0) return (false, 0);
452             return (true, a / b);
453         }
454     }
455 
456     /**
457      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
458      *
459      * _Available since v3.4._
460      */
461     function tryMod(uint256 a, uint256 b)
462         internal
463         pure
464         returns (bool, uint256)
465     {
466         unchecked {
467             if (b == 0) return (false, 0);
468             return (true, a % b);
469         }
470     }
471 
472     function add(uint256 a, uint256 b) internal pure returns (uint256) {
473         return a + b;
474     }
475 
476     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
477         return a - b;
478     }
479 
480     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
481         return a * b;
482     }
483 
484     function div(uint256 a, uint256 b) internal pure returns (uint256) {
485         return a / b;
486     }
487 
488     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
489         return a % b;
490     }
491 
492     function sub(
493         uint256 a,
494         uint256 b,
495         string memory errorMessage
496     ) internal pure returns (uint256) {
497         unchecked {
498             require(b <= a, errorMessage);
499             return a - b;
500         }
501     }
502 
503     function div(
504         uint256 a,
505         uint256 b,
506         string memory errorMessage
507     ) internal pure returns (uint256) {
508         unchecked {
509             require(b > 0, errorMessage);
510             return a / b;
511         }
512     }
513 
514     function mod(
515         uint256 a,
516         uint256 b,
517         string memory errorMessage
518     ) internal pure returns (uint256) {
519         unchecked {
520             require(b > 0, errorMessage);
521             return a % b;
522         }
523     }
524 }
525 
526 interface IUniswapV2Factory {
527     event PairCreated(
528         address indexed token0,
529         address indexed token1,
530         address pair,
531         uint256
532     );
533 
534     function feeTo() external view returns (address);
535 
536     function feeToSetter() external view returns (address);
537 
538     function getPair(address tokenA, address tokenB)
539         external
540         view
541         returns (address pair);
542 
543     function allPairs(uint256) external view returns (address pair);
544 
545     function allPairsLength() external view returns (uint256);
546 
547     function createPair(address tokenA, address tokenB)
548         external
549         returns (address pair);
550 
551     function setFeeTo(address) external;
552 
553     function setFeeToSetter(address) external;
554 }
555 
556 interface IUniswapV2Pair {
557     event Approval(
558         address indexed owner,
559         address indexed spender,
560         uint256 value
561     );
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     function name() external pure returns (string memory);
565 
566     function symbol() external pure returns (string memory);
567 
568     function decimals() external pure returns (uint8);
569 
570     function totalSupply() external view returns (uint256);
571 
572     function balanceOf(address owner) external view returns (uint256);
573 
574     function allowance(address owner, address spender)
575         external
576         view
577         returns (uint256);
578 
579     function approve(address spender, uint256 value) external returns (bool);
580 
581     function transfer(address to, uint256 value) external returns (bool);
582 
583     function transferFrom(
584         address from,
585         address to,
586         uint256 value
587     ) external returns (bool);
588 
589     function DOMAIN_SEPARATOR() external view returns (bytes32);
590 
591     function PERMIT_TYPEHASH() external pure returns (bytes32);
592 
593     function nonces(address owner) external view returns (uint256);
594 
595     function permit(
596         address owner,
597         address spender,
598         uint256 value,
599         uint256 deadline,
600         uint8 v,
601         bytes32 r,
602         bytes32 s
603     ) external;
604 
605     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
606     event Burn(
607         address indexed sender,
608         uint256 amount0,
609         uint256 amount1,
610         address indexed to
611     );
612     event Swap(
613         address indexed sender,
614         uint256 amount0In,
615         uint256 amount1In,
616         uint256 amount0Out,
617         uint256 amount1Out,
618         address indexed to
619     );
620     event Sync(uint112 reserve0, uint112 reserve1);
621 
622     function MINIMUM_LIQUIDITY() external pure returns (uint256);
623 
624     function factory() external view returns (address);
625 
626     function token0() external view returns (address);
627 
628     function token1() external view returns (address);
629 
630     function getReserves()
631         external
632         view
633         returns (
634             uint112 reserve0,
635             uint112 reserve1,
636             uint32 blockTimestampLast
637         );
638 
639     function price0CumulativeLast() external view returns (uint256);
640 
641     function price1CumulativeLast() external view returns (uint256);
642 
643     function kLast() external view returns (uint256);
644 
645     function mint(address to) external returns (uint256 liquidity);
646 
647     function burn(address to)
648         external
649         returns (uint256 amount0, uint256 amount1);
650 
651     function swap(
652         uint256 amount0Out,
653         uint256 amount1Out,
654         address to,
655         bytes calldata data
656     ) external;
657 
658     function skim(address to) external;
659 
660     function sync() external;
661 
662     function initialize(address, address) external;
663 }
664 
665 interface IUniswapV2Router02 {
666     function factory() external pure returns (address);
667 
668     function WETH() external pure returns (address);
669 
670     function addLiquidity(
671         address tokenA,
672         address tokenB,
673         uint256 amountADesired,
674         uint256 amountBDesired,
675         uint256 amountAMin,
676         uint256 amountBMin,
677         address to,
678         uint256 deadline
679     )
680         external
681         returns (
682             uint256 amountA,
683             uint256 amountB,
684             uint256 liquidity
685         );
686 
687     function addLiquidityETH(
688         address token,
689         uint256 amountTokenDesired,
690         uint256 amountTokenMin,
691         uint256 amountETHMin,
692         address to,
693         uint256 deadline
694     )
695         external
696         payable
697         returns (
698             uint256 amountToken,
699             uint256 amountETH,
700             uint256 liquidity
701         );
702 
703     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
704         uint256 amountIn,
705         uint256 amountOutMin,
706         address[] calldata path,
707         address to,
708         uint256 deadline
709     ) external;
710 
711     function swapExactETHForTokensSupportingFeeOnTransferTokens(
712         uint256 amountOutMin,
713         address[] calldata path,
714         address to,
715         uint256 deadline
716     ) external payable;
717 
718     function swapExactTokensForETHSupportingFeeOnTransferTokens(
719         uint256 amountIn,
720         uint256 amountOutMin,
721         address[] calldata path,
722         address to,
723         uint256 deadline
724     ) external;
725 }
726 
727 //Animeta Main Token Contract
728 contract AniMeta is ERC20, Ownable {
729     using SafeMath for uint256;
730 
731     IUniswapV2Router02 public immutable uniswapV2Router;
732     address public immutable uniswapV2Pair;
733     address public constant deadAddress = address(0xdead);
734 
735     bool private swapping;
736 
737     address public marketingWallet;
738     address public treasuryWallet;
739     address public metaWallet;
740 
741     uint256 public maxTransactionAmount;
742     uint256 public swapTokensAtAmount;
743     uint256 public maxWallet;
744 
745     bool public limitsInEffect = true;
746     bool public tradingActive = false;
747     bool public swapEnabled = false;
748 
749     uint256 public launchedAt;
750     uint256 public launchedAtTimestamp;
751     uint256 antiSnipingTime = 60 seconds;
752 
753     uint256 public buyTotalFees = 90;
754     uint256 public buyMarketingFee = 45;
755     uint256 public buyTreasuryFee = 0;
756     uint256 public buyLiquidityFee = 0;
757     uint256 public buyAutoBurnFee = 0;
758     uint256 public buyMetaFee = 45;
759 
760     uint256 public sellTotalFees = 90;
761     uint256 public sellMarketingFee = 45;
762     uint256 public sellLiquidityFee = 0;
763     uint256 public sellAutoBurnFee = 0;
764     uint256 public sellTreasuryFee = 0;
765     uint256 public sellMetaFee = 45;
766 
767     uint256 public tokensForMarketing;
768     uint256 public tokensForLiquidity;
769     uint256 public tokensForMeta;
770     uint256 public tokensForTreasury;
771     uint256 public tokensForAutoburn;
772 
773     /******************/
774 
775     // exlcude from fees and max transaction amount
776     mapping(address => bool) private _isExcludedFromFees;
777     mapping(address => bool) public _isExcludedMaxTransactionAmount;
778     mapping(address => bool) public isSniper;
779 
780     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
781     // could be subject to a maximum transfer amount
782     mapping(address => bool) public automatedMarketMakerPairs;
783 
784     event UpdateUniswapV2Router(
785         address indexed newAddress,
786         address indexed oldAddress
787     );
788 
789     event ExcludeFromFees(address indexed account, bool isExcluded);
790 
791     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
792 
793     event marketingWalletUpdated(
794         address indexed newWallet,
795         address indexed oldWallet
796     );
797 
798     event metaWalletUpdated(
799         address indexed newWallet,
800         address indexed oldWallet
801     );
802     event SwapAndLiquify(
803         uint256 tokensSwapped,
804         uint256 ethReceived,
805         uint256 tokensIntoLiquidity
806     );
807 
808     constructor() ERC20("AniMeta", "ANIMETA") {
809         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
810             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
811         );
812 
813         excludeFromMaxTransaction(address(_uniswapV2Router), true);
814         uniswapV2Router = _uniswapV2Router;
815 
816         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
817             .createPair(address(this), _uniswapV2Router.WETH());
818         excludeFromMaxTransaction(address(uniswapV2Pair), true);
819         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
820 
821         uint256 totalSupply = 1_200_000_000 * 1e18; // 1.2 billion
822 
823         maxTransactionAmount = 12_000_000 * 1e18; // 12 million from total supply maxTransactionAmountTxn
824         maxWallet = 36_000_000 * 1e18; // 36 million from total supply maxWallet
825         swapTokensAtAmount = 2_000_000 * 1e18; //2 million
826 
827         marketingWallet = address(0x897A0fE345f169307a9Ec2327D478678167561BC); // set as marketing wallet
828         treasuryWallet = address(0xaa185dd93D2fDAe1164bE50fe2cFB435EE176F85); // set as dev wallet
829         metaWallet = address(0x44d1e233FAe6689185ad4f8a80b51835551b02aB);
830         // exclude from paying fees or having max transaction amount
831         excludeFromFees(owner(), true);
832 
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
901         uint256 _autoBurnFee,
902         uint256 _metaFee
903     ) external onlyOwner {
904         buyMarketingFee = _marketingFee;
905         buyLiquidityFee = _liquidityFee;
906         buyAutoBurnFee = _autoBurnFee;
907         buyTreasuryFee = _treasuryFee;
908         buyMetaFee = _metaFee;
909         buyTotalFees =
910             buyMarketingFee +
911             buyTreasuryFee +
912             buyLiquidityFee +
913             buyMetaFee +
914             buyAutoBurnFee;
915     }
916 
917     function updateSellFees(
918         uint256 _marketingFee,
919         uint256 _liquidityFee,
920         uint256 _treasuryFee,
921         uint256 _autoBurnFee,
922         uint256 _metaFee
923     ) external onlyOwner {
924         sellMarketingFee = _marketingFee;
925         sellLiquidityFee = _liquidityFee;
926         sellTreasuryFee = _treasuryFee;
927         sellAutoBurnFee = _autoBurnFee;
928         sellMetaFee = _metaFee;
929         sellTotalFees =
930             sellMarketingFee +
931             sellLiquidityFee +
932             sellMetaFee +
933             sellTreasuryFee +
934             sellAutoBurnFee;
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
968     function updateMetaWallet(address newWallet) external onlyOwner {
969         emit metaWalletUpdated(newWallet, metaWallet);
970         metaWallet = newWallet;
971     }
972 
973     function updateTreasuryWallet(address newWallet) external onlyOwner {
974         treasuryWallet = newWallet;
975     }
976 
977     function isExcludedFromFees(address account) public view returns (bool) {
978         return _isExcludedFromFees[account];
979     }
980 
981     function addSniperInList(address _account) external onlyOwner {
982         require(
983             _account != address(uniswapV2Router),
984             "We can not blacklist router"
985         );
986         require(!isSniper[_account], "Sniper already exist");
987         isSniper[_account] = true;
988     }
989 
990     function removeSniperFromList(address _account) external onlyOwner {
991         require(isSniper[_account], "Not a sniper");
992         isSniper[_account] = false;
993     }
994 
995     function _transfer(
996         address from,
997         address to,
998         uint256 amount
999     ) internal override {
1000         require(from != address(0), "ERC20: transfer from the zero address");
1001         require(to != address(0), "ERC20: transfer to the zero address");
1002         require(!isSniper[to], "Sniper detected");
1003         require(!isSniper[from], "Sniper detected");
1004 
1005         if (amount == 0) {
1006             super._transfer(from, to, 0);
1007             return;
1008         }
1009 
1010         if (limitsInEffect) {
1011             if (
1012                 from != owner() &&
1013                 to != owner() &&
1014                 to != address(0) &&
1015                 to != address(0xdead) &&
1016                 !swapping
1017             ) {
1018                 if (!tradingActive) {
1019                     require(
1020                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1021                         "Trading is not active."
1022                     );
1023                 }
1024                 // antibot
1025                 if (
1026                     block.timestamp < launchedAtTimestamp + antiSnipingTime &&
1027                     from != address(uniswapV2Router)
1028                 ) {
1029                     if (from == uniswapV2Pair) {
1030                         isSniper[to] = true;
1031                     } else if (to == uniswapV2Pair) {
1032                         isSniper[from] = true;
1033                     }
1034                 }
1035                 //when buy
1036                 if (
1037                     automatedMarketMakerPairs[from] &&
1038                     !_isExcludedMaxTransactionAmount[to]
1039                 ) {
1040                     require(
1041                         amount <= maxTransactionAmount,
1042                         "Buy transfer amount exceeds the maxTransactionAmount."
1043                     );
1044                     require(
1045                         amount + balanceOf(to) <= maxWallet,
1046                         "Max wallet exceeded"
1047                     );
1048                 }
1049                 //when sell
1050                 else if (
1051                     automatedMarketMakerPairs[to] &&
1052                     !_isExcludedMaxTransactionAmount[from]
1053                 ) {
1054                     require(
1055                         amount <= maxTransactionAmount,
1056                         "Sell transfer amount exceeds the maxTransactionAmount."
1057                     );
1058                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1059                     require(
1060                         amount + balanceOf(to) <= maxWallet,
1061                         "Max wallet exceeded"
1062                     );
1063                 }
1064             }
1065         }
1066 
1067         uint256 contractTokenBalance = balanceOf(address(this));
1068 
1069         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1070 
1071         if (
1072             canSwap &&
1073             swapEnabled &&
1074             !swapping &&
1075             !automatedMarketMakerPairs[from] &&
1076             !_isExcludedFromFees[from] &&
1077             !_isExcludedFromFees[to]
1078         ) {
1079             swapping = true;
1080 
1081             swapBack();
1082 
1083             swapping = false;
1084         }
1085 
1086         bool takeFee = !swapping;
1087 
1088         // if any account belongs to _isExcludedFromFee account then remove the fee
1089         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1090             takeFee = false;
1091         }
1092 
1093         uint256 fees = 0;
1094         // only take fees on buys/sells, do not take on wallet transfers
1095         if (takeFee) {
1096             // on sell
1097             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1098                 fees = amount.mul(sellTotalFees).div(100);
1099                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1100                 tokensForMeta += (fees * sellMetaFee) / sellTotalFees;
1101                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1102                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
1103                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
1104             }
1105             // on buy
1106             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1107                 fees = amount.mul(buyTotalFees).div(100);
1108                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1109                 tokensForMeta += (fees * buyMetaFee) / buyTotalFees;
1110                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1111                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
1112                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
1113             }
1114 
1115             if (fees > 0) {
1116                 _burn(from, tokensForAutoburn);
1117                 super._transfer(from, address(this), fees - tokensForAutoburn);
1118             }
1119 
1120             amount -= fees;
1121         }
1122 
1123         super._transfer(from, to, amount);
1124     }
1125 
1126     function swapTokensForEth(uint256 tokenAmount) private {
1127         // generate the uniswap pair path of token -> weth
1128         address[] memory path = new address[](2);
1129         path[0] = address(this);
1130         path[1] = uniswapV2Router.WETH();
1131 
1132         _approve(address(this), address(uniswapV2Router), tokenAmount);
1133 
1134         // make the swap
1135         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1136             tokenAmount,
1137             0, // accept any amount of ETH
1138             path,
1139             address(this),
1140             block.timestamp
1141         );
1142     }
1143 
1144     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1145         // approve token transfer to cover all possible scenarios
1146         _approve(address(this), address(uniswapV2Router), tokenAmount);
1147 
1148         // add the liquidity
1149         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1150             address(this),
1151             tokenAmount,
1152             0, // slippage is unavoidable
1153             0, // slippage is unavoidable
1154             deadAddress,
1155             block.timestamp
1156         );
1157     }
1158 
1159     function swapBack() private {
1160         uint256 contractBalance = balanceOf(address(this));
1161         uint256 totalTokensToSwap = tokensForLiquidity +
1162             tokensForMarketing +
1163             tokensForTreasury +
1164             tokensForMeta;
1165         bool success;
1166 
1167         if (contractBalance == 0 || totalTokensToSwap == 0) {
1168             return;
1169         }
1170 
1171         if (contractBalance > swapTokensAtAmount) {
1172             contractBalance = swapTokensAtAmount;
1173         }
1174 
1175         // Halve the amount of liquidity tokens
1176         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1177             totalTokensToSwap /
1178             2;
1179         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1180 
1181         uint256 initialETHBalance = address(this).balance;
1182 
1183         swapTokensForEth(amountToSwapForETH);
1184 
1185         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1186 
1187         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1188             totalTokensToSwap
1189         );
1190         uint256 ethForDev = ethBalance.mul(tokensForMeta).div(
1191             totalTokensToSwap
1192         );
1193 
1194         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(
1195             totalTokensToSwap
1196         );
1197 
1198         uint256 ethForLiquidity = ethBalance -
1199             ethForMarketing -
1200             ethForDev -
1201             ethForTreasury;
1202 
1203         tokensForLiquidity = 0;
1204         tokensForMarketing = 0;
1205         tokensForMeta = 0;
1206         tokensForTreasury = 0;
1207 
1208         (success, ) = address(treasuryWallet).call{value: ethForDev}("");
1209 
1210         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1211             addLiquidity(liquidityTokens, ethForLiquidity);
1212             emit SwapAndLiquify(
1213                 amountToSwapForETH,
1214                 ethForLiquidity,
1215                 tokensForLiquidity
1216             );
1217         }
1218 
1219         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1220         (success, ) = address(metaWallet).call{value: address(this).balance}(
1221             ""
1222         );
1223     }
1224 
1225     function airdrop(address[] calldata addresses, uint256[] calldata amounts)
1226         external
1227         onlyOwner
1228     {
1229         require(
1230             addresses.length == amounts.length,
1231             "Array sizes must be equal"
1232         );
1233         uint256 i = 0;
1234         while (i < addresses.length) {
1235             uint256 _amount = amounts[i].mul(1e18);
1236             _transfer(msg.sender, addresses[i], _amount);
1237             i += 1;
1238         }
1239     }
1240 
1241     function withdrawETH(uint256 _amount) external onlyOwner {
1242         require(address(this).balance >= _amount, "Invalid Amount");
1243         payable(msg.sender).transfer(_amount);
1244     }
1245 
1246     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1247         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1248         _token.transfer(msg.sender, _amount);
1249     }
1250 
1251     function manualBurn(uint256 _amount) external onlyOwner {
1252         ManualBurning(_amount);
1253     }
1254 
1255     function ManualBurning(uint256 _amount) private {
1256         // cannot nuke more than 30% of token supply in pool
1257         if (_amount > 0 && _amount <= (balanceOf(uniswapV2Pair) * 30) / 100) {
1258             _burn(uniswapV2Pair, _amount);
1259             IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1260             pair.sync();
1261         }
1262     }
1263 }