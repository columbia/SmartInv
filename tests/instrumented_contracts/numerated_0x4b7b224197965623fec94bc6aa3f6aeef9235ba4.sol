1 /*
2          _          _            _             _            _            _       _             _       _                  _           _      _                  _           _      
3         /\ \       /\ \         /\ \          /\ \         /\ \         / /\    / /\         /\ \     /\_\               _\ \        /\ \   /\_\               /\ \        /\ \    
4        /  \ \     /  \ \       /  \ \         \_\ \       /  \ \       / / /   / / /        /  \ \   / / /         _    /\__ \       \_\ \ / / /         _    /  \ \      /  \ \   
5       / /\ \ \   / /\ \ \     / /\ \ \        /\__ \     / /\ \ \     / /_/   / / /        / /\ \ \  \ \ \__      /\_\ / /_ \_\      /\__ \\ \ \__      /\_\ / /\ \ \    / /\ \ \  
6      / / /\ \_\ / / /\ \ \   / / /\ \_\      / /_ \ \   / / /\ \_\   / /\ \__/ / /        / / /\ \ \  \ \___\    / / // / /\/_/     / /_ \ \\ \___\    / / // / /\ \_\  / / /\ \_\ 
7     / /_/_ \/_// / /  \ \_\ / / /_/ / /     / / /\ \ \ / /_/_ \/_/  / /\ \___\/ /        / / /  \ \_\  \__  /   / / // / /         / / /\ \ \\__  /   / / // / /_/ / / / /_/_ \/_/ 
8    / /____/\  / / /   / / // / /__\/ /     / / /  \/_// /____/\    / / /\/___/ /        / / /    \/_/  / / /   / / // / /         / / /  \/_// / /   / / // / /__\/ / / /____/\    
9   / /\____\/ / / /   / / // / /_____/     / / /      / /\____\/   / / /   / / /        / / /          / / /   / / // / / ____    / / /      / / /   / / // / /_____/ / /\____\/    
10  / / /      / / /___/ / // / /\ \ \      / / /      / / /______  / / /   / / /        / / /________  / / /___/ / // /_/_/ ___/\ / / /      / / /___/ / // / /\ \ \  / / /______    
11 / / /      / / /____\/ // / /  \ \ \    /_/ /      / / /_______\/ / /   / / /        / / /_________\/ / /____\/ //_______/\__\//_/ /      / / /____\/ // / /  \ \ \/ / /_______\   
12 \/_/       \/_________/ \/_/    \_\/    \_\/       \/__________/\/_/    \/_/         \/____________/\/_________/ \_______\/    \_\/       \/_________/ \/_/    \_\/\/__________/   
13                                                                                                                                                                                                                                                                                 
14 
15 
16 */
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.8.15;
19 pragma experimental ABIEncoderV2;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(
35         address indexed previousOwner,
36         address indexed newOwner
37     );
38 
39     /**
40      * @dev Initializes the contract setting the deployer as the initial owner.
41      */
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46     /**
47      * @dev Returns the address of the current owner.
48      */
49     function owner() public view virtual returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(owner() == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         _transferOwnership(address(0));
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Can only be called by the current owner.
68      */
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(
71             newOwner != address(0),
72             "Ownable: new owner is the zero address"
73         );
74         _transferOwnership(newOwner);
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Internal function without access restriction.
80      */
81     function _transferOwnership(address newOwner) internal virtual {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whbnber the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(
107         address recipient,
108         uint256 amount
109     ) external returns (bool);
110 
111     function allowance(
112         address owner,
113         address spender
114     ) external view returns (uint256);
115 
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     function transferFrom(
119         address sender,
120         address recipient,
121         uint256 amount
122     ) external returns (bool);
123 
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(
137         address indexed owner,
138         address indexed spender,
139         uint256 value
140     );
141 }
142 
143 interface IERC20Metadata is IERC20 {
144     /**
145      * @dev Returns the name of the token.
146      */
147     function name() external view returns (string memory);
148 
149     /**
150      * @dev Returns the symbol of the token.
151      */
152     function symbol() external view returns (string memory);
153 
154     /**
155      * @dev Returns the decimals places of the token.
156      */
157     function decimals() external view returns (uint8);
158 }
159 
160 contract ERC20 is Context, IERC20, IERC20Metadata {
161     mapping(address => uint256) private _balances;
162 
163     mapping(address => mapping(address => uint256)) private _allowances;
164 
165     uint256 private _totalSupply;
166 
167     string private _name;
168     string private _symbol;
169 
170     /**
171      * @dev Sets the values for {name} and {symbol}.
172      *
173      * The default value of {decimals} is 18. To select a different value for
174      * {decimals} you should overload it.
175      *
176      * All two of these values are immutable: they can only be set once during
177      * construction.
178      */
179     constructor(string memory name_, string memory symbol_) {
180         _name = name_;
181         _symbol = symbol_;
182     }
183 
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() public view virtual override returns (string memory) {
188         return _name;
189     }
190 
191     /**
192      * @dev Returns the symbol of the token, usually a shorter version of the
193      * name.
194      */
195     function symbol() public view virtual override returns (string memory) {
196         return _symbol;
197     }
198 
199     function decimals() public view virtual override returns (uint8) {
200         return 18;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view virtual override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(
214         address account
215     ) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     function transfer(
220         address recipient,
221         uint256 amount
222     ) public virtual override returns (bool) {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     /**
228      * @dev See {IERC20-allowance}.
229      */
230     function allowance(
231         address owner,
232         address spender
233     ) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(
245         address spender,
246         uint256 amount
247     ) public virtual override returns (bool) {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public virtual override returns (bool) {
257         _transfer(sender, recipient, amount);
258 
259         uint256 currentAllowance = _allowances[sender][_msgSender()];
260         require(
261             currentAllowance >= amount,
262             "ERC20: transfer amount exceeds allowance"
263         );
264         unchecked {
265             _approve(sender, _msgSender(), currentAllowance - amount);
266         }
267 
268         return true;
269     }
270 
271     function increaseAllowance(
272         address spender,
273         uint256 addedValue
274     ) public virtual returns (bool) {
275         _approve(
276             _msgSender(),
277             spender,
278             _allowances[_msgSender()][spender] + addedValue
279         );
280         return true;
281     }
282 
283     function decreaseAllowance(
284         address spender,
285         uint256 subtractedValue
286     ) public virtual returns (bool) {
287         uint256 currentAllowance = _allowances[_msgSender()][spender];
288         require(
289             currentAllowance >= subtractedValue,
290             "ERC20: decreased allowance below zero"
291         );
292         unchecked {
293             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
294         }
295 
296         return true;
297     }
298 
299     function _transfer(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) internal virtual {
304         require(sender != address(0), "ERC20: transfer from the zero address");
305         require(recipient != address(0), "ERC20: transfer to the zero address");
306 
307         _beforeTokenTransfer(sender, recipient, amount);
308 
309         uint256 senderBalance = _balances[sender];
310         require(
311             senderBalance >= amount,
312             "ERC20: transfer amount exceeds balance"
313         );
314         unchecked {
315             _balances[sender] = senderBalance - amount;
316         }
317         _balances[recipient] += amount;
318 
319         emit Transfer(sender, recipient, amount);
320 
321         _afterTokenTransfer(sender, recipient, amount);
322     }
323 
324     function _mint(address account, uint256 amount) internal virtual {
325         require(account != address(0), "ERC20: mint to the zero address");
326 
327         _beforeTokenTransfer(address(0), account, amount);
328 
329         _totalSupply += amount;
330         _balances[account] += amount;
331         emit Transfer(address(0), account, amount);
332 
333         _afterTokenTransfer(address(0), account, amount);
334     }
335 
336     function _burn(address account, uint256 amount) internal virtual {
337         require(account != address(0), "ERC20: burn from the zero address");
338 
339         _beforeTokenTransfer(account, address(0), amount);
340 
341         uint256 accountBalance = _balances[account];
342         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
343         unchecked {
344             _balances[account] = accountBalance - amount;
345         }
346         _totalSupply -= amount;
347 
348         emit Transfer(account, address(0), amount);
349 
350         _afterTokenTransfer(account, address(0), amount);
351     }
352 
353     function _approve(
354         address owner,
355         address spender,
356         uint256 amount
357     ) internal virtual {
358         require(owner != address(0), "ERC20: approve from the zero address");
359         require(spender != address(0), "ERC20: approve to the zero address");
360 
361         _allowances[owner][spender] = amount;
362         emit Approval(owner, spender, amount);
363     }
364 
365     function _beforeTokenTransfer(
366         address from,
367         address to,
368         uint256 amount
369     ) internal virtual {}
370 
371     function _afterTokenTransfer(
372         address from,
373         address to,
374         uint256 amount
375     ) internal virtual {}
376 }
377 
378 library SafeMath {
379     /**
380      * @dev Returns the addition of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryAdd(
385         uint256 a,
386         uint256 b
387     ) internal pure returns (bool, uint256) {
388         unchecked {
389             uint256 c = a + b;
390             if (c < a) return (false, 0);
391             return (true, c);
392         }
393     }
394 
395     /**
396      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
397      *
398      * _Available since v3.4._
399      */
400     function trySub(
401         uint256 a,
402         uint256 b
403     ) internal pure returns (bool, uint256) {
404         unchecked {
405             if (b > a) return (false, 0);
406             return (true, a - b);
407         }
408     }
409 
410     /**
411      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
412      *
413      * _Available since v3.4._
414      */
415     function tryMul(
416         uint256 a,
417         uint256 b
418     ) internal pure returns (bool, uint256) {
419         unchecked {
420             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
421             // benefit is lost if 'b' is also tested.
422             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
423             if (a == 0) return (true, 0);
424             uint256 c = a * b;
425             if (c / a != b) return (false, 0);
426             return (true, c);
427         }
428     }
429 
430     /**
431      * @dev Returns the division of two unsigned integers, with a division by zero flag.
432      *
433      * _Available since v3.4._
434      */
435     function tryDiv(
436         uint256 a,
437         uint256 b
438     ) internal pure returns (bool, uint256) {
439         unchecked {
440             if (b == 0) return (false, 0);
441             return (true, a / b);
442         }
443     }
444 
445     /**
446      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
447      *
448      * _Available since v3.4._
449      */
450     function tryMod(
451         uint256 a,
452         uint256 b
453     ) internal pure returns (bool, uint256) {
454         unchecked {
455             if (b == 0) return (false, 0);
456             return (true, a % b);
457         }
458     }
459 
460     function add(uint256 a, uint256 b) internal pure returns (uint256) {
461         return a + b;
462     }
463 
464     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
465         return a - b;
466     }
467 
468     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
469         return a * b;
470     }
471 
472     function div(uint256 a, uint256 b) internal pure returns (uint256) {
473         return a / b;
474     }
475 
476     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
477         return a % b;
478     }
479 
480     function sub(
481         uint256 a,
482         uint256 b,
483         string memory errorMessage
484     ) internal pure returns (uint256) {
485         unchecked {
486             require(b <= a, errorMessage);
487             return a - b;
488         }
489     }
490 
491     function div(
492         uint256 a,
493         uint256 b,
494         string memory errorMessage
495     ) internal pure returns (uint256) {
496         unchecked {
497             require(b > 0, errorMessage);
498             return a / b;
499         }
500     }
501 
502     function mod(
503         uint256 a,
504         uint256 b,
505         string memory errorMessage
506     ) internal pure returns (uint256) {
507         unchecked {
508             require(b > 0, errorMessage);
509             return a % b;
510         }
511     }
512 }
513 
514 interface IUniswapV2Factory {
515     event PairCreated(
516         address indexed token0,
517         address indexed token1,
518         address pair,
519         uint256
520     );
521 
522     function feeTo() external view returns (address);
523 
524     function feeToSetter() external view returns (address);
525 
526     function getPair(
527         address tokenA,
528         address tokenB
529     ) external view returns (address pair);
530 
531     function allPairs(uint256) external view returns (address pair);
532 
533     function allPairsLength() external view returns (uint256);
534 
535     function createPair(
536         address tokenA,
537         address tokenB
538     ) external returns (address pair);
539 
540     function setFeeTo(address) external;
541 
542     function setFeeToSetter(address) external;
543 }
544 
545 interface IUniswapV2Pair {
546     event Approval(
547         address indexed owner,
548         address indexed spender,
549         uint256 value
550     );
551     event Transfer(address indexed from, address indexed to, uint256 value);
552 
553     function name() external pure returns (string memory);
554 
555     function symbol() external pure returns (string memory);
556 
557     function decimals() external pure returns (uint8);
558 
559     function totalSupply() external view returns (uint256);
560 
561     function balanceOf(address owner) external view returns (uint256);
562 
563     function allowance(
564         address owner,
565         address spender
566     ) external view returns (uint256);
567 
568     function approve(address spender, uint256 value) external returns (bool);
569 
570     function transfer(address to, uint256 value) external returns (bool);
571 
572     function transferFrom(
573         address from,
574         address to,
575         uint256 value
576     ) external returns (bool);
577 
578     function DOMAIN_SEPARATOR() external view returns (bytes32);
579 
580     function PERMIT_TYPEHASH() external pure returns (bytes32);
581 
582     function nonces(address owner) external view returns (uint256);
583 
584     function permit(
585         address owner,
586         address spender,
587         uint256 value,
588         uint256 deadline,
589         uint8 v,
590         bytes32 r,
591         bytes32 s
592     ) external;
593 
594     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
595     event Burn(
596         address indexed sender,
597         uint256 amount0,
598         uint256 amount1,
599         address indexed to
600     );
601     event Swap(
602         address indexed sender,
603         uint256 amount0In,
604         uint256 amount1In,
605         uint256 amount0Out,
606         uint256 amount1Out,
607         address indexed to
608     );
609     event Sync(uint112 reserve0, uint112 reserve1);
610 
611     function MINIMUM_LIQUIDITY() external pure returns (uint256);
612 
613     function factory() external view returns (address);
614 
615     function token0() external view returns (address);
616 
617     function token1() external view returns (address);
618 
619     function getReserves()
620         external
621         view
622         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
623 
624     function price0CumulativeLast() external view returns (uint256);
625 
626     function price1CumulativeLast() external view returns (uint256);
627 
628     function kLast() external view returns (uint256);
629 
630     function mint(address to) external returns (uint256 liquidity);
631 
632     function burn(
633         address to
634     ) external returns (uint256 amount0, uint256 amount1);
635 
636     function swap(
637         uint256 amount0Out,
638         uint256 amount1Out,
639         address to,
640         bytes calldata data
641     ) external;
642 
643     function skim(address to) external;
644 
645     function sync() external;
646 
647     function initialize(address, address) external;
648 }
649 
650 interface IUniswapV2Router02 {
651     function factory() external pure returns (address);
652 
653     function WETH() external pure returns (address);
654 
655     function addLiquidity(
656         address tokenA,
657         address tokenB,
658         uint256 amountADesired,
659         uint256 amountBDesired,
660         uint256 amountAMin,
661         uint256 amountBMin,
662         address to,
663         uint256 deadline
664     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
665 
666     function addLiquidityETH(
667         address token,
668         uint256 amountTokenDesired,
669         uint256 amountTokenMin,
670         uint256 amountETHMin,
671         address to,
672         uint256 deadline
673     )
674         external
675         payable
676         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
677 
678     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
679         uint256 amountIn,
680         uint256 amountOutMin,
681         address[] calldata path,
682         address to,
683         uint256 deadline
684     ) external;
685 
686     function swapExactETHForTokensSupportingFeeOnTransferTokens(
687         uint256 amountOutMin,
688         address[] calldata path,
689         address to,
690         uint256 deadline
691     ) external payable;
692 
693     function swapExactTokensForETHSupportingFeeOnTransferTokens(
694         uint256 amountIn,
695         uint256 amountOutMin,
696         address[] calldata path,
697         address to,
698         uint256 deadline
699     ) external;
700 }
701 
702 contract ForTehCulture is ERC20, Ownable {
703     using SafeMath for uint256;
704 
705     IUniswapV2Router02 public immutable uniswapV2Router;
706     address public immutable uniswapV2Pair;
707     address public constant deadAddress = address(0xdead);
708 
709     bool private swapping;
710 
711     address public marketingWallet;
712 
713     uint256 public maxTransactionAmount;
714     uint256 public swapTokensAtAmount;
715     uint256 public maxWallet;
716 
717     bool public limitsInEffect = true;
718     bool public tradingActive = false;
719     bool public swapEnabled = false;
720 
721     uint256 public launchedAt;
722     uint256 public launchedAtTimestamp;
723 
724     uint256 public buyMarketingFee = 0;
725 
726     uint256 public sellMarketingFee = 0;
727 
728     uint256 public tokensForMarketing;
729 
730     /******************/
731 
732     // exlcude from fees and max transaction amount
733     mapping(address => bool) private _isExcludedFromFees;
734     mapping(address => bool) public _isExcludedMaxTransactionAmount;
735     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
736     // could be subject to a maximum transfer amount
737     mapping(address => bool) public automatedMarketMakerPairs;
738 
739     event UpdateUniswapV2Router(
740         address indexed newAddress,
741         address indexed oldAddress
742     );
743 
744     event ExcludeFromFees(address indexed account, bool isExcluded);
745 
746     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
747 
748     event marketingWalletUpdated(
749         address indexed newWallet,
750         address indexed oldWallet
751     );
752 
753     constructor() ERC20("For Teh Culture", "$FTC") {
754         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
755             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
756         );
757 
758         excludeFromMaxTransaction(address(_uniswapV2Router), true);
759         uniswapV2Router = _uniswapV2Router;
760 
761         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
762             .createPair(address(this), _uniswapV2Router.WETH());
763         excludeFromMaxTransaction(address(uniswapV2Pair), true);
764         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
765 
766         uint256 totalSupply = 1_000_000_000 * 1e18;
767 
768         maxTransactionAmount = totalSupply / 100; // 1% from total supply maxTransactionAmountTxn
769         maxWallet = totalSupply.mul(3) / 100; // 3% from total supply maxWallet
770         swapTokensAtAmount = 20_000 * 1e18;
771 
772         marketingWallet = owner(); // set as marketing wallet
773 
774         // exclude from paying fees or having max transaction amount
775         excludeFromFees(owner(), true);
776         excludeFromFees(address(this), true);
777         excludeFromFees(address(0xdead), true);
778         excludeFromMaxTransaction(owner(), true);
779         excludeFromMaxTransaction(address(this), true);
780         excludeFromMaxTransaction(address(0xdead), true);
781 
782         /*
783             _mint is an internal function in ERC20.sol that is only called here,
784             and CANNOT be called ever again
785         */
786         _mint(owner(), totalSupply);
787     }
788 
789     receive() external payable {}
790 
791     function launched() internal view returns (bool) {
792         return launchedAt != 0;
793     }
794 
795     function launch() public onlyOwner {
796         require(launchedAt == 0, "Already launched boi");
797         launchedAt = block.number;
798         launchedAtTimestamp = block.timestamp;
799         tradingActive = true;
800         swapEnabled = true;
801     }
802 
803     // remove limits after token is stable
804     function removeLimits() external onlyOwner returns (bool) {
805         limitsInEffect = false;
806         return true;
807     }
808 
809     // change the minimum amount of tokens to sell from fees
810     function updateSwapTokensAtAmount(
811         uint256 newAmount
812     ) external onlyOwner returns (bool) {
813         swapTokensAtAmount = newAmount * (10 ** 18);
814         return true;
815     }
816 
817     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
818         require(
819             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
820             "Cannot set max wallet amount lower than 0.5%"
821         );
822         require(
823             newNum <= ((totalSupply() * 5) / 100) / 1e18,
824             "Cannot set max wallet amount higher than 5%"
825         );
826         maxTransactionAmount = newNum * (10 ** 18);
827     }
828 
829     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
830         require(
831             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
832             "Cannot set max wallet amount lower than 0.5%"
833         );
834         require(
835             newNum <= ((totalSupply() * 5) / 100) / 1e18,
836             "Cannot set max wallet amount higher than 5%"
837         );
838         maxWallet = newNum * (10 ** 18);
839     }
840 
841     function excludeFromMaxTransaction(
842         address updAds,
843         bool isEx
844     ) public onlyOwner {
845         _isExcludedMaxTransactionAmount[updAds] = isEx;
846     }
847 
848     // only use to disable contract sales if absolutely necessary (emergency use only)
849     function updateSwapEnabled(bool enabled) external onlyOwner {
850         swapEnabled = enabled;
851     }
852 
853     function updateBuyFees(uint256 _marketingFeeOnBuy) external onlyOwner {
854         buyMarketingFee = _marketingFeeOnBuy;
855         require(buyMarketingFee <= 25, "fee must not be greater than 25%");
856     }
857 
858     function updateSellFees(uint256 _marketingFeeOnSell) external onlyOwner {
859         sellMarketingFee = _marketingFeeOnSell;
860         require(sellMarketingFee <= 25, "fee must not be greater than 25%");
861     }
862 
863     function excludeFromFees(address account, bool excluded) public onlyOwner {
864         _isExcludedFromFees[account] = excluded;
865         emit ExcludeFromFees(account, excluded);
866     }
867 
868     function setAutomatedMarketMakerPair(
869         address pair,
870         bool value
871     ) public onlyOwner {
872         require(
873             pair != uniswapV2Pair,
874             "The pair cannot be removed from automatedMarketMakerPairs"
875         );
876 
877         _setAutomatedMarketMakerPair(pair, value);
878     }
879 
880     function _setAutomatedMarketMakerPair(address pair, bool value) private {
881         automatedMarketMakerPairs[pair] = value;
882 
883         emit SetAutomatedMarketMakerPair(pair, value);
884     }
885 
886     function updateMarketingWallet(
887         address newMarketingWallet
888     ) external onlyOwner {
889         require(
890             marketingWallet != address(0),
891             "_marketWallet address cannot be 0"
892         );
893 
894         marketingWallet = newMarketingWallet;
895         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
896     }
897 
898     function isExcludedFromFees(address account) public view returns (bool) {
899         return _isExcludedFromFees[account];
900     }
901 
902     function _transfer(
903         address from,
904         address to,
905         uint256 amount
906     ) internal override {
907         require(from != address(0), "ERC20: transfer from the zero address");
908         require(to != address(0), "ERC20: transfer to the zero address");
909 
910         if (amount == 0) {
911             super._transfer(from, to, 0);
912             return;
913         }
914 
915         if (limitsInEffect) {
916             if (
917                 from != owner() &&
918                 to != owner() &&
919                 to != address(0) &&
920                 to != address(0xdead) &&
921                 !swapping
922             ) {
923                 if (!tradingActive) {
924                     require(
925                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
926                         "Trading is not active."
927                     );
928                 }
929                 //when buy
930                 if (
931                     automatedMarketMakerPairs[from] &&
932                     !_isExcludedMaxTransactionAmount[to]
933                 ) {
934                     require(
935                         amount <= maxTransactionAmount,
936                         "Buy transfer amount exceeds the maxTransactionAmount."
937                     );
938                     require(
939                         amount + balanceOf(to) <= maxWallet,
940                         "Max wallet exceeded"
941                     );
942                 }
943                 //when sell
944                 else if (
945                     automatedMarketMakerPairs[to] &&
946                     !_isExcludedMaxTransactionAmount[from]
947                 ) {
948                     require(
949                         amount <= maxTransactionAmount,
950                         "Sell transfer amount exceeds the maxTransactionAmount."
951                     );
952                 } else if (!_isExcludedMaxTransactionAmount[to]) {
953                     require(
954                         amount + balanceOf(to) <= maxWallet,
955                         "Max wallet exceeded"
956                     );
957                 }
958             }
959         }
960 
961         uint256 contractTokenBalance = balanceOf(address(this));
962 
963         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
964 
965         if (
966             canSwap &&
967             swapEnabled &&
968             !swapping &&
969             !automatedMarketMakerPairs[from] &&
970             !_isExcludedFromFees[from] &&
971             !_isExcludedFromFees[to]
972         ) {
973             swapping = true;
974 
975             swapBack();
976 
977             swapping = false;
978         }
979 
980         bool takeFee = !swapping;
981 
982         // if any account belongs to _isExcludedFromFee account then remove the fee
983         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
984             takeFee = false;
985         }
986 
987         uint256 fees = 0;
988         // only take fees on buys/sells, do not take on wallet transfers
989         if (takeFee) {
990             // on sell
991             if (automatedMarketMakerPairs[to] && sellMarketingFee > 0) {
992                 fees = amount.mul(sellMarketingFee).div(100);
993                 tokensForMarketing += fees;
994             }
995             // on buy
996             else if (automatedMarketMakerPairs[from] && buyMarketingFee > 0) {
997                 fees = amount.mul(buyMarketingFee).div(100);
998                 tokensForMarketing += fees;
999             }
1000 
1001             if (fees > 0) {
1002                 super._transfer(from, address(this), fees);
1003             }
1004 
1005             amount -= fees;
1006         }
1007 
1008         super._transfer(from, to, amount);
1009     }
1010 
1011     function swapTokensForEth(uint256 tokenAmount) private {
1012         // generate the uniswap pair path of token -> weth
1013         address[] memory path = new address[](2);
1014         path[0] = address(this);
1015         path[1] = uniswapV2Router.WETH();
1016 
1017         _approve(address(this), address(uniswapV2Router), tokenAmount);
1018 
1019         // make the swap
1020         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1021             tokenAmount,
1022             0, // accept any amount of ETH
1023             path,
1024             address(this),
1025             block.timestamp
1026         );
1027     }
1028 
1029     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1030         // approve token transfer to cover all possible scenarios
1031         _approve(address(this), address(uniswapV2Router), tokenAmount);
1032 
1033         // add the liquidity
1034         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1035             address(this),
1036             tokenAmount,
1037             0, // slippage is unavoidable
1038             0, // slippage is unavoidable
1039             deadAddress,
1040             block.timestamp
1041         );
1042     }
1043 
1044     // tax fee will be swapped and transfer to market wallet
1045     function swapBack() private {
1046         uint256 contractBalance = balanceOf(address(this));
1047         if (contractBalance > swapTokensAtAmount) {
1048             contractBalance = swapTokensAtAmount;
1049         }
1050         uint256 amountToSwapForETH = contractBalance;
1051 
1052         swapTokensForEth(amountToSwapForETH);
1053 
1054         uint256 ethBalance = address(this).balance;
1055 
1056         uint256 ethForMarketing = ethBalance;
1057 
1058         payable(marketingWallet).transfer(ethForMarketing);
1059         tokensForMarketing = 0;
1060     }
1061 
1062     // TO transfer tokens to multi users through single transaction
1063     function airdrop(
1064         address[] calldata addresses,
1065         uint256[] calldata amounts
1066     ) external onlyOwner {
1067         require(
1068             addresses.length == amounts.length,
1069             "Array sizes must be equal"
1070         );
1071         uint256 i = 0;
1072         while (i < addresses.length) {
1073             uint256 _amount = amounts[i].mul(1e18);
1074             _transfer(msg.sender, addresses[i], _amount);
1075             i += 1;
1076         }
1077     }
1078 
1079     // to withdarw ETH from contract
1080     function withdrawETH(uint256 _amount) external onlyOwner {
1081         require(address(this).balance >= _amount, "Invalid Amount");
1082         payable(msg.sender).transfer(_amount);
1083     }
1084 
1085     // to withdraw ERC20 tokens from contract
1086     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1087         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1088         _token.transfer(msg.sender, _amount);
1089     }
1090 }