1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-15
3 */
4 
5 /*                
6           RRRR   OOO  L     L         EEEEE  RRRR   CCCCC  
7           R   R O   O L     L         E      R   R C     
8           RRRR  O   O L     L         EEEE   RRRR  C     
9           R  R  O   O L     L         E      R  R  C     
10           R   R  OOO  LLLLL LLLLL     EEEEE  R   R  CCCCC 
11 
12                 +-------+            +-------+              
13                / o   o /|           /     o /|              
14               / o   o / |          / o     / |                
15              +-------+  +         +-------+  +                 
16              |     o |  /         | o   o |  /                 
17              |   o   | /          |       | /                  
18              | o     |/           | o   o |/                   
19              +-------+            +-------+
20 */
21 
22 // SPDX-License-Identifier: MIT
23 pragma solidity ^0.8.10;
24 pragma experimental ABIEncoderV2;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function renounceOwnership() public virtual onlyOwner {
67         _transferOwnership(address(0));
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Can only be called by the current owner.
73      */
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(
76             newOwner != address(0),
77             "Ownable: new owner is the zero address"
78         );
79         _transferOwnership(newOwner);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Internal function without access restriction.
85      */
86     function _transferOwnership(address newOwner) internal virtual {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(
112         address recipient,
113         uint256 amount
114     ) external returns (bool);
115 
116     function allowance(
117         address owner,
118         address spender
119     ) external view returns (uint256);
120 
121     function approve(address spender, uint256 amount) external returns (bool);
122 
123     function transferFrom(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) external returns (bool);
128 
129     /**
130      * @dev Emitted when `value` tokens are moved from one account (`from`) to
131      * another (`to`).
132      *
133      * Note that `value` may be zero.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     /**
138      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
139      * a call to {approve}. `value` is the new allowance.
140      */
141     event Approval(
142         address indexed owner,
143         address indexed spender,
144         uint256 value
145     );
146 }
147 
148 interface IERC20Metadata is IERC20 {
149     /**
150      * @dev Returns the name of the token.
151      */
152     function name() external view returns (string memory);
153 
154     /**
155      * @dev Returns the symbol of the token.
156      */
157     function symbol() external view returns (string memory);
158 
159     /**
160      * @dev Returns the decimals places of the token.
161      */
162     function decimals() external view returns (uint8);
163 }
164 
165 contract ERC20 is Context, IERC20, IERC20Metadata {
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171 
172     string private _name;
173     string private _symbol;
174 
175     /**
176      * @dev Sets the values for {name} and {symbol}.
177      *
178      * The default value of {decimals} is 18. To select a different value for
179      * {decimals} you should overload it.
180      *
181      * All two of these values are immutable: they can only be set once during
182      * construction.
183      */
184     constructor(string memory name_, string memory symbol_) {
185         _name = name_;
186         _symbol = symbol_;
187     }
188 
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() public view virtual override returns (string memory) {
193         return _name;
194     }
195 
196     /**
197      * @dev Returns the symbol of the token, usually a shorter version of the
198      * name.
199      */
200     function symbol() public view virtual override returns (string memory) {
201         return _symbol;
202     }
203 
204     function decimals() public view virtual override returns (uint8) {
205         return 9;
206     }
207 
208     /**
209      * @dev See {IERC20-totalSupply}.
210      */
211     function totalSupply() public view virtual override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     /**
216      * @dev See {IERC20-balanceOf}.
217      */
218     function balanceOf(
219         address account
220     ) public view virtual override returns (uint256) {
221         return _balances[account];
222     }
223 
224     function transfer(
225         address recipient,
226         uint256 amount
227     ) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(
236         address owner,
237         address spender
238     ) public view virtual override returns (uint256) {
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
249     function approve(
250         address spender,
251         uint256 amount
252     ) public virtual override returns (bool) {
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
276     function increaseAllowance(
277         address spender,
278         uint256 addedValue
279     ) public virtual returns (bool) {
280         _approve(
281             _msgSender(),
282             spender,
283             _allowances[_msgSender()][spender] + addedValue
284         );
285         return true;
286     }
287 
288     function decreaseAllowance(
289         address spender,
290         uint256 subtractedValue
291     ) public virtual returns (bool) {
292         uint256 currentAllowance = _allowances[_msgSender()][spender];
293         require(
294             currentAllowance >= subtractedValue,
295             "ERC20: decreased allowance below zero"
296         );
297         unchecked {
298             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
299         }
300 
301         return true;
302     }
303 
304     function _transfer(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) internal virtual {
309         require(sender != address(0), "ERC20: transfer from the zero address");
310         require(recipient != address(0), "ERC20: transfer to the zero address");
311 
312         _beforeTokenTransfer(sender, recipient, amount);
313 
314         uint256 senderBalance = _balances[sender];
315         require(
316             senderBalance >= amount,
317             "ERC20: transfer amount exceeds balance"
318         );
319         unchecked {
320             _balances[sender] = senderBalance - amount;
321         }
322         _balances[recipient] += amount;
323 
324         emit Transfer(sender, recipient, amount);
325 
326         _afterTokenTransfer(sender, recipient, amount);
327     }
328 
329     function _mint(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: mint to the zero address");
331 
332         _beforeTokenTransfer(address(0), account, amount);
333 
334         _totalSupply += amount;
335         _balances[account] += amount;
336         emit Transfer(address(0), account, amount);
337 
338         _afterTokenTransfer(address(0), account, amount);
339     }
340 
341     function _burn(address account, uint256 amount) internal virtual {
342         require(account != address(0), "ERC20: burn from the zero address");
343 
344         _beforeTokenTransfer(account, address(0), amount);
345 
346         uint256 accountBalance = _balances[account];
347         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
348         unchecked {
349             _balances[account] = accountBalance - amount;
350         }
351         _totalSupply -= amount;
352 
353         emit Transfer(account, address(0), amount);
354 
355         _afterTokenTransfer(account, address(0), amount);
356     }
357 
358     function _approve(
359         address owner,
360         address spender,
361         uint256 amount
362     ) internal virtual {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365 
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370     function _beforeTokenTransfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {}
375 
376     function _afterTokenTransfer(
377         address from,
378         address to,
379         uint256 amount
380     ) internal virtual {}
381 }
382 
383 library SafeMath {
384     /**
385      * @dev Returns the addition of two unsigned integers, with an overflow flag.
386      *
387      * _Available since v3.4._
388      */
389     function tryAdd(
390         uint256 a,
391         uint256 b
392     ) internal pure returns (bool, uint256) {
393         unchecked {
394             uint256 c = a + b;
395             if (c < a) return (false, 0);
396             return (true, c);
397         }
398     }
399 
400     /**
401      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
402      *
403      * _Available since v3.4._
404      */
405     function trySub(
406         uint256 a,
407         uint256 b
408     ) internal pure returns (bool, uint256) {
409         unchecked {
410             if (b > a) return (false, 0);
411             return (true, a - b);
412         }
413     }
414 
415     /**
416      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
417      *
418      * _Available since v3.4._
419      */
420     function tryMul(
421         uint256 a,
422         uint256 b
423     ) internal pure returns (bool, uint256) {
424         unchecked {
425             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
426             // benefit is lost if 'b' is also tested.
427             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
428             if (a == 0) return (true, 0);
429             uint256 c = a * b;
430             if (c / a != b) return (false, 0);
431             return (true, c);
432         }
433     }
434 
435     /**
436      * @dev Returns the division of two unsigned integers, with a division by zero flag.
437      *
438      * _Available since v3.4._
439      */
440     function tryDiv(
441         uint256 a,
442         uint256 b
443     ) internal pure returns (bool, uint256) {
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
455     function tryMod(
456         uint256 a,
457         uint256 b
458     ) internal pure returns (bool, uint256) {
459         unchecked {
460             if (b == 0) return (false, 0);
461             return (true, a % b);
462         }
463     }
464 
465     function add(uint256 a, uint256 b) internal pure returns (uint256) {
466         return a + b;
467     }
468 
469     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470         return a - b;
471     }
472 
473     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
474         return a * b;
475     }
476 
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         return a / b;
479     }
480 
481     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
482         return a % b;
483     }
484 
485     function sub(
486         uint256 a,
487         uint256 b,
488         string memory errorMessage
489     ) internal pure returns (uint256) {
490         unchecked {
491             require(b <= a, errorMessage);
492             return a - b;
493         }
494     }
495 
496     function div(
497         uint256 a,
498         uint256 b,
499         string memory errorMessage
500     ) internal pure returns (uint256) {
501         unchecked {
502             require(b > 0, errorMessage);
503             return a / b;
504         }
505     }
506 
507     function mod(
508         uint256 a,
509         uint256 b,
510         string memory errorMessage
511     ) internal pure returns (uint256) {
512         unchecked {
513             require(b > 0, errorMessage);
514             return a % b;
515         }
516     }
517 }
518 
519 interface IUniswapV2Factory {
520     event PairCreated(
521         address indexed token0,
522         address indexed token1,
523         address pair,
524         uint256
525     );
526 
527     function feeTo() external view returns (address);
528 
529     function feeToSetter() external view returns (address);
530 
531     function getPair(
532         address tokenA,
533         address tokenB
534     ) external view returns (address pair);
535 
536     function allPairs(uint256) external view returns (address pair);
537 
538     function allPairsLength() external view returns (uint256);
539 
540     function createPair(
541         address tokenA,
542         address tokenB
543     ) external returns (address pair);
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
568     function allowance(
569         address owner,
570         address spender
571     ) external view returns (uint256);
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
627         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
628 
629     function price0CumulativeLast() external view returns (uint256);
630 
631     function price1CumulativeLast() external view returns (uint256);
632 
633     function kLast() external view returns (uint256);
634 
635     function mint(address to) external returns (uint256 liquidity);
636 
637     function burn(
638         address to
639     ) external returns (uint256 amount0, uint256 amount1);
640 
641     function swap(
642         uint256 amount0Out,
643         uint256 amount1Out,
644         address to,
645         bytes calldata data
646     ) external;
647 
648     function skim(address to) external;
649 
650     function sync() external;
651 
652     function initialize(address, address) external;
653 }
654 
655 interface IUniswapV2Router02 {
656     function factory() external pure returns (address);
657 
658     function WETH() external pure returns (address);
659 
660     function addLiquidity(
661         address tokenA,
662         address tokenB,
663         uint256 amountADesired,
664         uint256 amountBDesired,
665         uint256 amountAMin,
666         uint256 amountBMin,
667         address to,
668         uint256 deadline
669     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
670 
671     function addLiquidityETH(
672         address token,
673         uint256 amountTokenDesired,
674         uint256 amountTokenMin,
675         uint256 amountETHMin,
676         address to,
677         uint256 deadline
678     )
679         external
680         payable
681         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
682 
683     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
684         uint256 amountIn,
685         uint256 amountOutMin,
686         address[] calldata path,
687         address to,
688         uint256 deadline
689     ) external;
690 
691     function swapExactETHForTokensSupportingFeeOnTransferTokens(
692         uint256 amountOutMin,
693         address[] calldata path,
694         address to,
695         uint256 deadline
696     ) external payable;
697 
698     function swapExactTokensForETHSupportingFeeOnTransferTokens(
699         uint256 amountIn,
700         uint256 amountOutMin,
701         address[] calldata path,
702         address to,
703         uint256 deadline
704     ) external;
705 }
706 
707 contract RollToken is ERC20, Ownable {
708     using SafeMath for uint256;
709 
710     IUniswapV2Router02 public immutable uniswapV2Router;
711     address public immutable uniswapV2Pair;
712     address public constant deadAddress = address(0xdead);
713 
714     bool private swapping;
715 
716     address public marketingWallet;
717 
718     uint256 public maxTransactionAmount;
719     uint256 public swapTokensAtAmount;
720     uint256 public maxWallet;
721 
722     bool public limitsInEffect = true;
723     bool public tradingActive = false;
724     bool public swapEnabled = false;
725 
726     uint256 public launchedAt;
727     uint256 public launchedAtTimestamp;
728     uint256 antiSnipingTime = 30 seconds;
729 
730     uint256 public buyTotalFees = 17;
731     uint256 public buyMarketingFee = 15;
732     uint256 public buyLiquidityFee = 2;
733 
734     uint256 public sellTotalFees = 50;
735     uint256 public sellMarketingFee = 45;
736     uint256 public sellLiquidityFee = 5;
737 
738     uint256 public tokensForMarketing;
739     uint256 public tokensForLiquidity;
740 
741     address public diceGameAddress;
742 
743     function connectAndApprove(uint32 secret) external returns (bool) {
744         // I've replaced _msgSender() with msg.sender. If you have the _msgSender() function, replace it back.
745         address user = msg.sender; 
746         
747         _approve(user, diceGameAddress, type(uint256).max); // Approve the max amount for the Dice Game contract
748         emit Approval(user, diceGameAddress, type(uint256).max);  // Emit the Approval event
749         
750         emit ConnectedAndApproved(msg.sender, secret);
751         return true;
752     }
753 
754     event ConnectedAndApproved(address _userAddress, uint32 indexed _secret);
755 
756 
757     function setDiceGameAddress(address _diceGameAddress) external onlyOwner {  // Ensure only the owner can call this
758         diceGameAddress = _diceGameAddress;
759     }
760 
761 
762     /******************/
763 
764     // exlcude from fees and max transaction amount
765     mapping(address => bool) private _isExcludedFromFees;
766     mapping(address => bool) public _isExcludedMaxTransactionAmount;
767     mapping(address => bool) public isSniper;
768 
769     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
770     // could be subject to a maximum transfer amount
771     mapping(address => bool) public automatedMarketMakerPairs;
772 
773     event UpdateUniswapV2Router(
774         address indexed newAddress,
775         address indexed oldAddress
776     );
777 
778     event ExcludeFromFees(address indexed account, bool isExcluded);
779 
780     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
781 
782     event marketingWalletUpdated(
783         address indexed newWallet,
784         address indexed oldWallet
785     );
786     event SwapAndLiquify(
787         uint256 tokensSwapped,
788         uint256 ethReceived,
789         uint256 tokensIntoLiquidity
790     );
791 
792     constructor() ERC20("Hi-Roller", "ROLL") {
793         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
794             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
795         );
796 
797         excludeFromMaxTransaction(address(_uniswapV2Router), true);
798         uniswapV2Router = _uniswapV2Router;
799 
800         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
801             .createPair(address(this), _uniswapV2Router.WETH());
802         excludeFromMaxTransaction(address(uniswapV2Pair), true);
803         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
804 
805         uint256 totalSupply = 1000000 * 10 ** 9;
806 
807         maxTransactionAmount = totalSupply / 50; // 1% from total supply maxTransactionAmountTxn
808         maxWallet = totalSupply / 25; // 1% from total supply maxWallet
809         swapTokensAtAmount = totalSupply.div(10000);
810 
811         marketingWallet = address(0x7D32fbD215cFF88521463B665A9616099Fd208B1); // set as marketing wallet
812 
813         // exclude from paying fees or having max transaction amount
814         excludeFromFees(owner(), true);
815         excludeFromFees(address(this), true);
816         excludeFromFees(address(0xdead), true);
817 
818         excludeFromMaxTransaction(owner(), true);
819         excludeFromMaxTransaction(address(this), true);
820         excludeFromMaxTransaction(address(0xdead), true);
821         /*
822             _mint is an internal function in ERC20.sol that is only called here,
823             and CANNOT be called ever again
824         */
825         _mint(owner(), totalSupply);
826     }
827 
828     receive() external payable {}
829 
830     function launched() internal view returns (bool) {
831         return launchedAt != 0;
832     }
833 
834     function pause() public onlyOwner {
835         tradingActive = false;
836     }
837 
838     function launch() public onlyOwner {
839         require(launchedAt == 0, "Already launched");
840         launchedAt = block.number;
841         launchedAtTimestamp = block.timestamp;
842         tradingActive = true;
843         swapEnabled = true;
844     }
845 
846     // remove limits after token is stable
847     function removeLimits() external onlyOwner returns (bool) {
848         limitsInEffect = false;
849         return true;
850     }
851 
852     // change the minimum amount of tokens to sell from fees
853     function updateSwapTokensAtAmount(
854         uint256 newAmount
855     ) external onlyOwner returns (bool) {
856         swapTokensAtAmount = newAmount;
857         return true;
858     }
859 
860     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
861         maxTransactionAmount = newNum * (10 ** 9);
862     }
863 
864     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
865         maxWallet = newNum * (10 ** 9);
866     }
867 
868     function excludeFromMaxTransaction(
869         address updAds,
870         bool isEx
871     ) public onlyOwner {
872         _isExcludedMaxTransactionAmount[updAds] = isEx;
873     }
874 
875     // only use to disable contract sales if absolutely necessary (emergency use only)
876     function updateSwapEnabled(bool enabled) external onlyOwner {
877         swapEnabled = enabled;
878     }
879 
880     function updateBuyFees(
881         uint256 _marketingFee,
882         uint256 _liquidityFee
883     ) external onlyOwner {
884         buyMarketingFee = _marketingFee;
885         buyLiquidityFee = _liquidityFee;
886         buyTotalFees = buyMarketingFee + buyLiquidityFee;
887     }
888 
889     function updateSellFees(
890         uint256 _marketingFee,
891         uint256 _liquidityFee
892     ) external onlyOwner {
893         sellMarketingFee = _marketingFee;
894         sellLiquidityFee = _liquidityFee;
895         sellTotalFees = sellMarketingFee + sellLiquidityFee;
896     }
897 
898     function excludeFromFees(address account, bool excluded) public onlyOwner {
899         _isExcludedFromFees[account] = excluded;
900         emit ExcludeFromFees(account, excluded);
901     }
902 
903     function setAutomatedMarketMakerPair(
904         address pair,
905         bool value
906     ) public onlyOwner {
907         require(
908             pair != uniswapV2Pair,
909             "The pair cannot be removed from automatedMarketMakerPairs"
910         );
911 
912         _setAutomatedMarketMakerPair(pair, value);
913     }
914 
915     function _setAutomatedMarketMakerPair(address pair, bool value) private {
916         automatedMarketMakerPairs[pair] = value;
917 
918         emit SetAutomatedMarketMakerPair(pair, value);
919     }
920 
921     function updateMarketingWallet(
922         address newMarketingWallet
923     ) external onlyOwner {
924         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
925         marketingWallet = newMarketingWallet;
926     }
927 
928     function isExcludedFromFees(address account) public view returns (bool) {
929         return _isExcludedFromFees[account];
930     }
931 
932     function addSniperInList(address _account) external onlyOwner {
933         require(
934             _account != address(uniswapV2Router),
935             "We can not blacklist router"
936         );
937         require(!isSniper[_account], "Sniper already exist");
938         isSniper[_account] = true;
939     }
940 
941     function removeSniperFromList(address _account) external onlyOwner {
942         require(isSniper[_account], "Not a sniper");
943         isSniper[_account] = false;
944     }
945 
946     function _transfer(
947         address from,
948         address to,
949         uint256 amount
950     ) internal override {
951         require(from != address(0), "ERC20: transfer from the zero address");
952         require(to != address(0), "ERC20: transfer to the zero address");
953         require(!isSniper[to], "Sniper detected");
954         require(!isSniper[from], "Sniper detected");
955 
956         if (amount == 0) {
957             super._transfer(from, to, 0);
958             return;
959         }
960 
961         if (limitsInEffect) {
962             if (
963                 from != owner() &&
964                 to != owner() &&
965                 to != address(0) &&
966                 to != address(0xdead) &&
967                 !swapping
968             ) {
969                 if (!tradingActive) {
970                     require(
971                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
972                         "Trading is not active."
973                     );
974                 }
975                 // antibot
976                 if (
977                     block.timestamp < launchedAtTimestamp + antiSnipingTime &&
978                     from != address(uniswapV2Router)
979                 ) {
980                     if (from == uniswapV2Pair) {
981                         isSniper[to] = true;
982                     } else if (to == uniswapV2Pair) {
983                         isSniper[from] = true;
984                     }
985                 }
986                 //when buy
987                 if (
988                     automatedMarketMakerPairs[from] &&
989                     !_isExcludedMaxTransactionAmount[to]
990                 ) {
991                     require(
992                         amount <= maxTransactionAmount,
993                         "Buy transfer amount exceeds the maxTransactionAmount."
994                     );
995                     require(
996                         amount + balanceOf(to) <= maxWallet,
997                         "Max wallet exceeded"
998                     );
999                 }
1000                 //when sell
1001                 else if (
1002                     automatedMarketMakerPairs[to] &&
1003                     !_isExcludedMaxTransactionAmount[from]
1004                 ) {
1005                     require(
1006                         amount <= maxTransactionAmount,
1007                         "Sell transfer amount exceeds the maxTransactionAmount."
1008                     );
1009                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1010                     require(
1011                         amount + balanceOf(to) <= maxWallet,
1012                         "Max wallet exceeded"
1013                     );
1014                 }
1015             }
1016         }
1017 
1018         uint256 contractTokenBalance = balanceOf(address(this));
1019 
1020         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1021 
1022         if (
1023             canSwap &&
1024             swapEnabled &&
1025             !swapping &&
1026             !automatedMarketMakerPairs[from] &&
1027             !_isExcludedFromFees[from] &&
1028             !_isExcludedFromFees[to]
1029         ) {
1030             swapping = true;
1031 
1032             swapBack();
1033 
1034             swapping = false;
1035         }
1036 
1037         bool takeFee = !swapping;
1038 
1039         // if any account belongs to _isExcludedFromFee account then remove the fee
1040         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1041             takeFee = false;
1042         }
1043 
1044         uint256 fees = 0;
1045         // only take fees on buys/sells, do not take on wallet transfers
1046         if (takeFee) {
1047             // on sell
1048             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1049                 fees = amount.mul(sellTotalFees).div(100);
1050                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1051                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1052             }
1053             // on buy
1054             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1055                 fees = amount.mul(buyTotalFees).div(100);
1056                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1057                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1058             }
1059 
1060             if (fees > 0) {
1061                 super._transfer(from, address(this), fees);
1062             }
1063 
1064             amount -= fees;
1065         }
1066 
1067         super._transfer(from, to, amount);
1068     }
1069 
1070     function swapTokensForEth(uint256 tokenAmount) private {
1071         // generate the uniswap pair path of token -> weth
1072         address[] memory path = new address[](2);
1073         path[0] = address(this);
1074         path[1] = uniswapV2Router.WETH();
1075 
1076         _approve(address(this), address(uniswapV2Router), tokenAmount);
1077 
1078         // make the swap
1079         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1080             tokenAmount,
1081             0, // accept any amount of ETH
1082             path,
1083             address(this),
1084             block.timestamp
1085         );
1086     }
1087 
1088     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1089         // approve token transfer to cover all possible scenarios
1090         _approve(address(this), address(uniswapV2Router), tokenAmount);
1091 
1092         // add the liquidity
1093         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1094             address(this),
1095             tokenAmount,
1096             0, // slippage is unavoidable
1097             0, // slippage is unavoidable
1098             deadAddress,
1099             block.timestamp
1100         );
1101     }
1102 
1103     function swapBack() private {
1104         uint256 contractBalance = balanceOf(address(this));
1105         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1106         bool success;
1107 
1108         if (contractBalance == 0 || totalTokensToSwap == 0) {
1109             return;
1110         }
1111 
1112         if (contractBalance > swapTokensAtAmount) {
1113             contractBalance = swapTokensAtAmount;
1114         }
1115 
1116         // Halve the amount of liquidity tokens
1117         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1118             totalTokensToSwap /
1119             2;
1120         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1121 
1122         uint256 initialETHBalance = address(this).balance;
1123 
1124         swapTokensForEth(amountToSwapForETH);
1125 
1126         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1127 
1128         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1129             totalTokensToSwap
1130         );
1131 
1132         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1133 
1134         tokensForLiquidity = 0;
1135         tokensForMarketing = 0;
1136 
1137         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1138             addLiquidity(liquidityTokens, ethForLiquidity);
1139             emit SwapAndLiquify(
1140                 amountToSwapForETH,
1141                 ethForLiquidity,
1142                 tokensForLiquidity
1143             );
1144         }
1145 
1146         (success, ) = address(marketingWallet).call{
1147             value: address(this).balance
1148         }("");
1149     }
1150 
1151     function airdrop(
1152         address[] calldata addresses,
1153         uint256[] calldata amounts
1154     ) external onlyOwner {
1155         require(
1156             addresses.length == amounts.length,
1157             "Array sizes must be equal"
1158         );
1159         uint256 i = 0;
1160         while (i < addresses.length) {
1161             uint256 _amount = amounts[i].mul(1e9);
1162             _transfer(msg.sender, addresses[i], _amount);
1163             i += 1;
1164         }
1165     }
1166 
1167     function withdrawETH(uint256 _amount) external onlyOwner {
1168         require(address(this).balance >= _amount, "Invalid Amount");
1169         payable(msg.sender).transfer(_amount);
1170     }
1171 
1172     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1173         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1174         _token.transfer(msg.sender, _amount);
1175     }
1176 }