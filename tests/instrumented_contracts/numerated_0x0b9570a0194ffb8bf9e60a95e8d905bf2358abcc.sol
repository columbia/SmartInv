1 // SPDX-License-Identifier: MIT
2 
3 // $RAT.
4 // Telegram: https://t.me/RatRoulettePortal
5 // Twitter: https://twitter.com/RatRouletteGG
6 
7 
8 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
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
20 abstract contract Ownable is Context {
21     address private _owner;
22     address private creator;
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
50     /**
51      * @dev Leaves the contract without owner. It will not be possible to call
52      * `onlyOwner` functions anymore. Can only be called by the current owner.
53      *
54      * NOTE: Renouncing ownership will leave the contract without an owner,
55      * thereby removing any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(
67             newOwner != address(0),
68             "Ownable: new owner is the zero address"
69         );
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Internal function without access restriction.
76      */
77     function _transferOwnership(address newOwner) internal virtual {
78         address oldOwner = _owner;
79         _owner = newOwner;
80         emit OwnershipTransferred(oldOwner, newOwner);
81     }
82 }
83 
84 interface IERC20 {
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94 
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `recipient`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     function allowance(
108         address owner,
109         address spender
110     ) external view returns (uint256);
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
158     mapping(address => mapping(address => uint256)) private _allowances;
159 
160     uint256 private _totalSupply;
161     string private _name;
162     string private _symbol;
163 
164     constructor(string memory name_, string memory symbol_) {
165         _name = name_;
166         _symbol = symbol_;
167     }
168 
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() public view virtual override returns (string memory) {
173         return _name;
174     }
175 
176     /**
177      * @dev Returns the symbol of the token, usually a shorter version of the
178      * name.
179      */
180     function symbol() public view virtual override returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public view virtual override returns (uint8) {
185         return 18;
186     }
187 
188     /**
189      * @dev See {IERC20-totalSupply}.
190      */
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(
199         address account
200     ) public view virtual override returns (uint256) {
201         return _balances[account];
202     }
203 
204     /**
205      * @dev See {IERC20-transfer}.
206      *
207      * Requirements:
208      *
209      * - `recipient` cannot be the zero address.
210      * - the caller must have a balance of at least `amount`.
211      */
212     function transfer(
213         address recipient,
214         uint256 amount
215     ) public virtual override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     /**
221      * @dev See {IERC20-allowance}.
222      */
223     function allowance(
224         address owner,
225         address spender
226     ) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(
238         address spender,
239         uint256 amount
240     ) public virtual override returns (bool) {
241         _approve(_msgSender(), spender, amount);
242         return true;
243     }
244 
245     function transferFrom(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) public virtual override returns (bool) {
250         _transfer(sender, recipient, amount);
251 
252         uint256 currentAllowance = _allowances[sender][_msgSender()];
253         require(
254             currentAllowance >= amount,
255             "ERC20: transfer amount exceeds allowance"
256         );
257         unchecked {
258             _approve(sender, _msgSender(), currentAllowance - amount);
259         }
260 
261         return true;
262     }
263 
264     function increaseAllowance(
265         address spender,
266         uint256 addedValue
267     ) public virtual returns (bool) {
268         _approve(
269             _msgSender(),
270             spender,
271             _allowances[_msgSender()][spender] + addedValue
272         );
273         return true;
274     }
275 
276     function decreaseAllowance(
277         address spender,
278         uint256 subtractedValue
279     ) public virtual returns (bool) {
280         uint256 currentAllowance = _allowances[_msgSender()][spender];
281         require(
282             currentAllowance >= subtractedValue,
283             "ERC20: decreased allowance below zero"
284         );
285         unchecked {
286             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
287         }
288 
289         return true;
290     }
291 
292     function _transfer(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) internal virtual {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299 
300         _beforeTokenTransfer(sender, recipient, amount);
301 
302         uint256 senderBalance = _balances[sender];
303         require(
304             senderBalance >= amount,
305             "ERC20: transfer amount exceeds balance"
306         );
307         unchecked {
308             _balances[sender] = senderBalance - amount;
309         }
310         _balances[recipient] += amount;
311 
312         emit Transfer(sender, recipient, amount);
313 
314         _afterTokenTransfer(sender, recipient, amount);
315     }
316 
317     function _mint(address account, uint256 amount) internal virtual {
318         require(account != address(0), "ERC20: mint to the zero address");
319 
320         _beforeTokenTransfer(address(0), account, amount);
321 
322         _totalSupply += amount;
323         _balances[account] += amount;
324         emit Transfer(address(0), account, amount);
325 
326         _afterTokenTransfer(address(0), account, amount);
327     }
328 
329     function _burn(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: burn from the zero address");
331 
332         _beforeTokenTransfer(account, address(0), amount);
333 
334         uint256 accountBalance = _balances[account];
335         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
336         unchecked {
337             _balances[account] = accountBalance - amount;
338         }
339         _totalSupply -= amount;
340 
341         emit Transfer(account, address(0), amount);
342 
343         _afterTokenTransfer(account, address(0), amount);
344     }
345 
346     function _approve(
347         address owner,
348         address spender,
349         uint256 amount
350     ) internal virtual {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353 
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 
358     function _beforeTokenTransfer(
359         address from,
360         address to,
361         uint256 amount
362     ) internal virtual {}
363 
364     function _afterTokenTransfer(
365         address from,
366         address to,
367         uint256 amount
368     ) internal virtual {}
369 }
370 
371 library SafeMath {
372     function tryAdd(
373         uint256 a,
374         uint256 b
375     ) internal pure returns (bool, uint256) {
376         unchecked {
377             uint256 c = a + b;
378             if (c < a) return (false, 0);
379             return (true, c);
380         }
381     }
382 
383     function trySub(
384         uint256 a,
385         uint256 b
386     ) internal pure returns (bool, uint256) {
387         unchecked {
388             if (b > a) return (false, 0);
389             return (true, a - b);
390         }
391     }
392 
393     function tryMul(
394         uint256 a,
395         uint256 b
396     ) internal pure returns (bool, uint256) {
397         unchecked {
398             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
399             // benefit is lost if 'b' is also tested.
400             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
401             if (a == 0) return (true, 0);
402             uint256 c = a * b;
403             if (c / a != b) return (false, 0);
404             return (true, c);
405         }
406     }
407 
408     function tryDiv(
409         uint256 a,
410         uint256 b
411     ) internal pure returns (bool, uint256) {
412         unchecked {
413             if (b == 0) return (false, 0);
414             return (true, a / b);
415         }
416     }
417 
418     function tryMod(
419         uint256 a,
420         uint256 b
421     ) internal pure returns (bool, uint256) {
422         unchecked {
423             if (b == 0) return (false, 0);
424             return (true, a % b);
425         }
426     }
427 
428     function add(uint256 a, uint256 b) internal pure returns (uint256) {
429         return a + b;
430     }
431 
432     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
433         return a - b;
434     }
435 
436     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
437         return a * b;
438     }
439 
440     function div(uint256 a, uint256 b) internal pure returns (uint256) {
441         return a / b;
442     }
443 
444     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
445         return a % b;
446     }
447 
448     function sub(
449         uint256 a,
450         uint256 b,
451         string memory errorMessage
452     ) internal pure returns (uint256) {
453         unchecked {
454             require(b <= a, errorMessage);
455             return a - b;
456         }
457     }
458 
459     function div(
460         uint256 a,
461         uint256 b,
462         string memory errorMessage
463     ) internal pure returns (uint256) {
464         unchecked {
465             require(b > 0, errorMessage);
466             return a / b;
467         }
468     }
469 
470     function mod(
471         uint256 a,
472         uint256 b,
473         string memory errorMessage
474     ) internal pure returns (uint256) {
475         unchecked {
476             require(b > 0, errorMessage);
477             return a % b;
478         }
479     }
480 }
481 
482 ////// src/IUniswapV2Factory.sol
483 /* pragma solidity 0.8.10; */
484 /* pragma experimental ABIEncoderV2; */
485 
486 interface IUniswapV2Factory {
487     event PairCreated(
488         address indexed token0,
489         address indexed token1,
490         address pair,
491         uint256
492     );
493 
494     function feeTo() external view returns (address);
495 
496     function feeToSetter() external view returns (address);
497 
498     function getPair(
499         address tokenA,
500         address tokenB
501     ) external view returns (address pair);
502 
503     function allPairs(uint256) external view returns (address pair);
504 
505     function allPairsLength() external view returns (uint256);
506 
507     function createPair(
508         address tokenA,
509         address tokenB
510     ) external returns (address pair);
511 
512     function setFeeTo(address) external;
513 
514     function setFeeToSetter(address) external;
515 }
516 
517 ////// src/IUniswapV2Pair.sol
518 /* pragma solidity 0.8.10; */
519 /* pragma experimental ABIEncoderV2; */
520 
521 interface IUniswapV2Pair {
522     event Approval(
523         address indexed owner,
524         address indexed spender,
525         uint256 value
526     );
527     event Transfer(address indexed from, address indexed to, uint256 value);
528 
529     function name() external pure returns (string memory);
530 
531     function symbol() external pure returns (string memory);
532 
533     function decimals() external pure returns (uint8);
534 
535     function totalSupply() external view returns (uint256);
536 
537     function balanceOf(address owner) external view returns (uint256);
538 
539     function allowance(
540         address owner,
541         address spender
542     ) external view returns (uint256);
543 
544     function approve(address spender, uint256 value) external returns (bool);
545 
546     function transfer(address to, uint256 value) external returns (bool);
547 
548     function transferFrom(
549         address from,
550         address to,
551         uint256 value
552     ) external returns (bool);
553 
554     function DOMAIN_SEPARATOR() external view returns (bytes32);
555 
556     function PERMIT_TYPEHASH() external pure returns (bytes32);
557 
558     function nonces(address owner) external view returns (uint256);
559 
560     function permit(
561         address owner,
562         address spender,
563         uint256 value,
564         uint256 deadline,
565         uint8 v,
566         bytes32 r,
567         bytes32 s
568     ) external;
569 
570     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
571     event Burn(
572         address indexed sender,
573         uint256 amount0,
574         uint256 amount1,
575         address indexed to
576     );
577     event Swap(
578         address indexed sender,
579         uint256 amount0In,
580         uint256 amount1In,
581         uint256 amount0Out,
582         uint256 amount1Out,
583         address indexed to
584     );
585     event Sync(uint112 reserve0, uint112 reserve1);
586 
587     function MINIMUM_LIQUIDITY() external pure returns (uint256);
588 
589     function factory() external view returns (address);
590 
591     function token0() external view returns (address);
592 
593     function token1() external view returns (address);
594 
595     function getReserves()
596         external
597         view
598         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
599 
600     function price0CumulativeLast() external view returns (uint256);
601 
602     function price1CumulativeLast() external view returns (uint256);
603 
604     function kLast() external view returns (uint256);
605 
606     function mint(address to) external returns (uint256 liquidity);
607 
608     function burn(
609         address to
610     ) external returns (uint256 amount0, uint256 amount1);
611 
612     function swap(
613         uint256 amount0Out,
614         uint256 amount1Out,
615         address to,
616         bytes calldata data
617     ) external;
618 
619     function skim(address to) external;
620 
621     function sync() external;
622 
623     function initialize(address, address) external;
624 }
625 
626 interface IUniswapV2Router02 {
627     function factory() external pure returns (address);
628 
629     function WETH() external pure returns (address);
630 
631     function addLiquidity(
632         address tokenA,
633         address tokenB,
634         uint256 amountADesired,
635         uint256 amountBDesired,
636         uint256 amountAMin,
637         uint256 amountBMin,
638         address to,
639         uint256 deadline
640     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
641 
642     function addLiquidityETH(
643         address token,
644         uint256 amountTokenDesired,
645         uint256 amountTokenMin,
646         uint256 amountETHMin,
647         address to,
648         uint256 deadline
649     )
650         external
651         payable
652         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
653 
654     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
655         uint256 amountIn,
656         uint256 amountOutMin,
657         address[] calldata path,
658         address to,
659         uint256 deadline
660     ) external;
661 
662     function swapExactETHForTokensSupportingFeeOnTransferTokens(
663         uint256 amountOutMin,
664         address[] calldata path,
665         address to,
666         uint256 deadline
667     ) external payable;
668 
669     function swapExactTokensForETHSupportingFeeOnTransferTokens(
670         uint256 amountIn,
671         uint256 amountOutMin,
672         address[] calldata path,
673         address to,
674         uint256 deadline
675     ) external;
676 }
677 
678 contract Rats is ERC20, Ownable {
679     event SwapBackSuccess(
680         uint256 tokenAmount,
681         uint256 ethAmountReceived,
682         bool success
683     );
684     bool private swapping;
685     address public marketingWallet =
686         address(0x8434A6cb4E7367FE2571f0C5d870Ba286F16ebDe);
687 
688     address public devWallet =
689         address(0x8434A6cb4E7367FE2571f0C5d870Ba286F16ebDe);
690 
691     uint256 _totalSupply = 5_000_000 * 1e18;
692     uint256 public maxTransactionAmount = (_totalSupply * 30) / 1000; // 3% from total supply maxTransactionAmountTxn;
693     uint256 public swapTokensAtAmount = (_totalSupply * 10) / 10000; // 0.1% swap tokens at this amount. (10_000_000 * 10) / 10000 = 0.1%(10000 tokens) of the total supply
694     uint256 public maxWallet = (_totalSupply * 30) / 1000; // 3% from total supply maxWallet
695 
696     bool public limitsInEffect = true;
697     bool public tradingActive = false;
698     bool public swapEnabled = false;
699 
700     uint256 public buyFees = 15;
701     uint256 public sellFees = 15;
702 
703     uint256 public marketingAmount = 50; //
704     uint256 public devAmount = 50; //
705 
706     using SafeMath for uint256;
707 
708     IUniswapV2Router02 public uniswapV2Router;
709     address public uniswapV2Pair;
710     address public constant deadAddress = address(0xdead);
711 
712     // exlcude from fees and max transaction amount
713     mapping(address => bool) private _isExcludedFromFees;
714     mapping(address => bool) public _isExcludedMaxTransactionAmount;
715     mapping(address => bool) public automatedMarketMakerPairs;
716 
717     constructor() ERC20("Rats", "RAT") {
718         // exclude from paying fees or having max transaction amount
719         excludeFromFees(owner(), true);
720         excludeFromFees(marketingWallet, true);
721         excludeFromFees(devWallet, true);
722         excludeFromFees(address(this), true);
723         excludeFromFees(address(0xdead), true);
724         excludeFromMaxTransaction(owner(), true);
725         excludeFromMaxTransaction(marketingWallet, true);
726         excludeFromMaxTransaction(devWallet, true);
727         excludeFromMaxTransaction(address(this), true);
728         excludeFromMaxTransaction(address(0xdead), true);
729         _mint(address(this), _totalSupply);
730     }
731 
732     receive() external payable {}
733 
734     // once enabled, can never be turned off
735     function enableTrading() external onlyOwner {
736         tradingActive = true;
737         swapEnabled = true;
738     }
739 
740     // remove limits after token is stable (sets sell fees to 5%)
741     function removeLimits() external onlyOwner returns (bool) {
742         limitsInEffect = false;
743         sellFees = 3;
744         buyFees = 3;
745         return true;
746     }
747 
748     function excludeFromMaxTransaction(
749         address addressToExclude,
750         bool isExcluded
751     ) public onlyOwner {
752         _isExcludedMaxTransactionAmount[addressToExclude] = isExcluded;
753     }
754 
755     // only use to disable contract sales if absolutely necessary (emergency use only)
756     function updateSwapEnabled(bool enabled) external onlyOwner {
757         swapEnabled = enabled;
758     }
759 
760     function excludeFromFees(address account, bool excluded) public onlyOwner {
761         _isExcludedFromFees[account] = excluded;
762     }
763 
764     function setAutomatedMarketMakerPair(
765         address pair,
766         bool value
767     ) public onlyOwner {
768         require(
769             pair != uniswapV2Pair,
770             "The pair cannot be removed from automatedMarketMakerPairs"
771         );
772         _setAutomatedMarketMakerPair(pair, value);
773     }
774 
775     function addLiquidity() external payable onlyOwner {
776         // approve token transfer to cover all possible scenarios
777         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
778             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
779         );
780 
781         uniswapV2Router = _uniswapV2Router;
782         excludeFromMaxTransaction(address(_uniswapV2Router), true);
783         _approve(address(this), address(uniswapV2Router), totalSupply());
784         // add the liquidity
785         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
786             .createPair(address(this), _uniswapV2Router.WETH());
787         excludeFromMaxTransaction(address(uniswapV2Pair), true);
788         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
789 
790         uniswapV2Router.addLiquidityETH{value: msg.value}(
791             address(this), //token address
792             totalSupply(), // liquidity amount
793             0, // slippage is unavoidable
794             0, // slippage is unavoidable
795             owner(), // LP tokens are sent to the owner
796             block.timestamp
797         );
798     }
799 
800     function _setAutomatedMarketMakerPair(address pair, bool value) private {
801         automatedMarketMakerPairs[pair] = value;
802     }
803 
804     function updateFeeWallet(
805         address marketingWallet_,
806         address devWallet_
807     ) public onlyOwner {
808         devWallet = devWallet_;
809         marketingWallet = marketingWallet_;
810     }
811 
812     function isExcludedFromFees(address account) public view returns (bool) {
813         return _isExcludedFromFees[account];
814     }
815 
816     function _transfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal override {
821         require(from != address(0), "ERC20: transfer from the zero address");
822         require(to != address(0), "ERC20: transfer to the zero address");
823         require(amount > 0, "Transfer amount must be greater than zero");
824         if (limitsInEffect) {
825             if (
826                 from != owner() &&
827                 to != owner() &&
828                 to != address(0) &&
829                 to != address(0xdead) &&
830                 !swapping
831             ) {
832                 if (!tradingActive) {
833                     require(
834                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
835                         "Trading is not enabled yet."
836                     );
837                 }
838 
839                 //when buy
840                 if (
841                     automatedMarketMakerPairs[from] &&
842                     !_isExcludedMaxTransactionAmount[to]
843                 ) {
844                     require(
845                         amount <= maxTransactionAmount,
846                         "Buy transfer amount exceeds the maxTransactionAmount."
847                     );
848                     require(
849                         amount + balanceOf(to) <= maxWallet,
850                         "Max wallet exceeded"
851                     );
852                 }
853                 //when sell
854                 else if (
855                     automatedMarketMakerPairs[to] &&
856                     !_isExcludedMaxTransactionAmount[from]
857                 ) {
858                     require(
859                         amount <= maxTransactionAmount,
860                         "Sell transfer amount exceeds the maxTransactionAmount."
861                     );
862                 } else if (!_isExcludedMaxTransactionAmount[to]) {
863                     require(
864                         amount + balanceOf(to) <= maxWallet,
865                         "Max wallet exceeded"
866                     );
867                 }
868             }
869         }
870 
871         if (
872             swapEnabled && //if this is true
873             !swapping && //if this is false
874             !automatedMarketMakerPairs[from] && //if this is false
875             !_isExcludedFromFees[from] && //if this is false
876             !_isExcludedFromFees[to] //if this is false
877         ) {
878             swapping = true;
879             swapBack();
880             swapping = false;
881         }
882 
883         bool takeFee = !swapping;
884 
885         // if any account belongs to _isExcludedFromFee account then remove the fee
886         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
887             takeFee = false;
888         }
889 
890         uint256 fees = 0;
891         // only take fees on buys/sells, do not take on wallet transfers
892         if (takeFee) {
893             // on sell
894             if (automatedMarketMakerPairs[to] && sellFees > 0) {
895                 fees = amount.mul(sellFees).div(100);
896             }
897             // on buy
898             else if (automatedMarketMakerPairs[from] && buyFees > 0) {
899                 fees = amount.mul(buyFees).div(100);
900             }
901 
902             if (fees > 0) {
903                 super._transfer(from, address(this), fees);
904             }
905             amount -= fees;
906         }
907         super._transfer(from, to, amount);
908     }
909 
910     function swapTokensForEth(uint256 tokenAmount) private {
911         // generate the uniswap pair path of token -> weth
912         address[] memory path = new address[](2);
913         path[0] = address(this);
914         path[1] = uniswapV2Router.WETH();
915         _approve(address(this), address(uniswapV2Router), tokenAmount);
916         // make the swap
917         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
918             tokenAmount,
919             0, // accept any amount of ETH
920             path,
921             address(this),
922             block.timestamp
923         );
924     }
925 
926     function swapBack() private {
927         uint256 contractBalance = balanceOf(address(this));
928         bool success;
929         if (contractBalance == 0) {
930             return;
931         }
932         if (contractBalance >= swapTokensAtAmount) {
933             uint256 amountToSwapForETH = swapTokensAtAmount;
934             swapTokensForEth(amountToSwapForETH);
935             uint256 amountEthToSend = address(this).balance;
936             uint256 amountToMarketing = amountEthToSend
937                 .mul(marketingAmount)
938                 .div(100);
939             uint256 amountToDev = amountEthToSend.sub(amountToMarketing);
940             (success, ) = address(marketingWallet).call{
941                 value: amountToMarketing
942             }("");
943             (success, ) = address(devWallet).call{value: amountToDev}("");
944             emit SwapBackSuccess(amountToSwapForETH, amountEthToSend, success);
945         }
946     }
947 }