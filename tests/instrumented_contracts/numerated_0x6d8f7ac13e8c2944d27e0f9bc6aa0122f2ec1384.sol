1 // SPDX-License-Identifier: MIT
2 /**
3 * https://supermarket.gg 
4 * 
5 **/
6 pragma solidity >=0.8.7;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20     address private creator;
21     event OwnershipTransferred(
22         address indexed previousOwner,
23         address indexed newOwner
24     );
25 
26     /**
27      * @dev Initializes the contract setting the deployer as the initial owner.
28      */
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     /**
34      * @dev Returns the address of the current owner.
35      */
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(
65             newOwner != address(0),
66             "Ownable: new owner is the zero address"
67         );
68         _transferOwnership(newOwner);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Internal function without access restriction.
74      */
75     function _transferOwnership(address newOwner) internal virtual {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87 
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92 
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     function allowance(
106         address owner,
107         address spender
108     ) external view returns (uint256);
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
156     mapping(address => mapping(address => uint256)) private _allowances;
157 
158     uint256 private _totalSupply;
159     string private _name;
160     string private _symbol;
161 
162     constructor(string memory name_, string memory symbol_) {
163         _name = name_;
164         _symbol = symbol_;
165     }
166 
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() public view virtual override returns (string memory) {
171         return _name;
172     }
173 
174     /**
175      * @dev Returns the symbol of the token, usually a shorter version of the
176      * name.
177      */
178     function symbol() public view virtual override returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public view virtual override returns (uint8) {
183         return 18;
184     }
185 
186     /**
187      * @dev See {IERC20-totalSupply}.
188      */
189     function totalSupply() public view virtual override returns (uint256) {
190         return _totalSupply;
191     }
192 
193     /**
194      * @dev See {IERC20-balanceOf}.
195      */
196     function balanceOf(
197         address account
198     ) public view virtual override returns (uint256) {
199         return _balances[account];
200     }
201 
202     /**
203      * @dev See {IERC20-transfer}.
204      *
205      * Requirements:
206      *
207      * - `recipient` cannot be the zero address.
208      * - the caller must have a balance of at least `amount`.
209      */
210     function transfer(
211         address recipient,
212         uint256 amount
213     ) public virtual override returns (bool) {
214         _transfer(_msgSender(), recipient, amount);
215         return true;
216     }
217 
218     /**
219      * @dev See {IERC20-allowance}.
220      */
221     function allowance(
222         address owner,
223         address spender
224     ) public view virtual override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     /**
229      * @dev See {IERC20-approve}.
230      *
231      * Requirements:
232      *
233      * - `spender` cannot be the zero address.
234      */
235     function approve(
236         address spender,
237         uint256 amount
238     ) public virtual override returns (bool) {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242 
243     function transferFrom(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) public virtual override returns (bool) {
248         _transfer(sender, recipient, amount);
249 
250         uint256 currentAllowance = _allowances[sender][_msgSender()];
251         require(
252             currentAllowance >= amount,
253             "ERC20: transfer amount exceeds allowance"
254         );
255         unchecked {
256             _approve(sender, _msgSender(), currentAllowance - amount);
257         }
258 
259         return true;
260     }
261 
262     function increaseAllowance(
263         address spender,
264         uint256 addedValue
265     ) public virtual returns (bool) {
266         _approve(
267             _msgSender(),
268             spender,
269             _allowances[_msgSender()][spender] + addedValue
270         );
271         return true;
272     }
273 
274     function decreaseAllowance(
275         address spender,
276         uint256 subtractedValue
277     ) public virtual returns (bool) {
278         uint256 currentAllowance = _allowances[_msgSender()][spender];
279         require(
280             currentAllowance >= subtractedValue,
281             "ERC20: decreased allowance below zero"
282         );
283         unchecked {
284             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
285         }
286 
287         return true;
288     }
289 
290     function _transfer(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) internal virtual {
295         require(sender != address(0), "ERC20: transfer from the zero address");
296         require(recipient != address(0), "ERC20: transfer to the zero address");
297 
298         _beforeTokenTransfer(sender, recipient, amount);
299 
300         uint256 senderBalance = _balances[sender];
301         require(
302             senderBalance >= amount,
303             "ERC20: transfer amount exceeds balance"
304         );
305         unchecked {
306             _balances[sender] = senderBalance - amount;
307         }
308         _balances[recipient] += amount;
309 
310         emit Transfer(sender, recipient, amount);
311 
312         _afterTokenTransfer(sender, recipient, amount);
313     }
314 
315     function _mint(address account, uint256 amount) internal virtual {
316         require(account != address(0), "ERC20: mint to the zero address");
317 
318         _beforeTokenTransfer(address(0), account, amount);
319 
320         _totalSupply += amount;
321         _balances[account] += amount;
322         emit Transfer(address(0), account, amount);
323 
324         _afterTokenTransfer(address(0), account, amount);
325     }
326 
327     function _burn(address account, uint256 amount) internal virtual {
328         require(account != address(0), "ERC20: burn from the zero address");
329 
330         _beforeTokenTransfer(account, address(0), amount);
331 
332         uint256 accountBalance = _balances[account];
333         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
334         unchecked {
335             _balances[account] = accountBalance - amount;
336         }
337         _totalSupply -= amount;
338 
339         emit Transfer(account, address(0), amount);
340 
341         _afterTokenTransfer(account, address(0), amount);
342     }
343 
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) internal virtual {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351 
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 
356     function _beforeTokenTransfer(
357         address from,
358         address to,
359         uint256 amount
360     ) internal virtual {}
361 
362     function _afterTokenTransfer(
363         address from,
364         address to,
365         uint256 amount
366     ) internal virtual {}
367 }
368 
369 library SafeMath {
370     function tryAdd(
371         uint256 a,
372         uint256 b
373     ) internal pure returns (bool, uint256) {
374         unchecked {
375             uint256 c = a + b;
376             if (c < a) return (false, 0);
377             return (true, c);
378         }
379     }
380 
381     function trySub(
382         uint256 a,
383         uint256 b
384     ) internal pure returns (bool, uint256) {
385         unchecked {
386             if (b > a) return (false, 0);
387             return (true, a - b);
388         }
389     }
390 
391     function tryMul(
392         uint256 a,
393         uint256 b
394     ) internal pure returns (bool, uint256) {
395         unchecked {
396             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
397             // benefit is lost if 'b' is also tested.
398             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
399             if (a == 0) return (true, 0);
400             uint256 c = a * b;
401             if (c / a != b) return (false, 0);
402             return (true, c);
403         }
404     }
405 
406     function tryDiv(
407         uint256 a,
408         uint256 b
409     ) internal pure returns (bool, uint256) {
410         unchecked {
411             if (b == 0) return (false, 0);
412             return (true, a / b);
413         }
414     }
415 
416     function tryMod(
417         uint256 a,
418         uint256 b
419     ) internal pure returns (bool, uint256) {
420         unchecked {
421             if (b == 0) return (false, 0);
422             return (true, a % b);
423         }
424     }
425 
426     function add(uint256 a, uint256 b) internal pure returns (uint256) {
427         return a + b;
428     }
429 
430     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
431         return a - b;
432     }
433 
434     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435         return a * b;
436     }
437 
438     function div(uint256 a, uint256 b) internal pure returns (uint256) {
439         return a / b;
440     }
441 
442     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
443         return a % b;
444     }
445 
446     function sub(
447         uint256 a,
448         uint256 b,
449         string memory errorMessage
450     ) internal pure returns (uint256) {
451         unchecked {
452             require(b <= a, errorMessage);
453             return a - b;
454         }
455     }
456 
457     function div(
458         uint256 a,
459         uint256 b,
460         string memory errorMessage
461     ) internal pure returns (uint256) {
462         unchecked {
463             require(b > 0, errorMessage);
464             return a / b;
465         }
466     }
467 
468     function mod(
469         uint256 a,
470         uint256 b,
471         string memory errorMessage
472     ) internal pure returns (uint256) {
473         unchecked {
474             require(b > 0, errorMessage);
475             return a % b;
476         }
477     }
478 }
479 
480 ////// src/IUniswapV2Factory.sol
481 /* pragma solidity 0.8.10; */
482 /* pragma experimental ABIEncoderV2; */
483 
484 interface IUniswapV2Factory {
485     event PairCreated(
486         address indexed token0,
487         address indexed token1,
488         address pair,
489         uint256
490     );
491 
492     function feeTo() external view returns (address);
493 
494     function feeToSetter() external view returns (address);
495 
496     function getPair(
497         address tokenA,
498         address tokenB
499     ) external view returns (address pair);
500 
501     function allPairs(uint256) external view returns (address pair);
502 
503     function allPairsLength() external view returns (uint256);
504 
505     function createPair(
506         address tokenA,
507         address tokenB
508     ) external returns (address pair);
509 
510     function setFeeTo(address) external;
511 
512     function setFeeToSetter(address) external;
513 }
514 
515 ////// src/IUniswapV2Pair.sol
516 /* pragma solidity 0.8.10; */
517 /* pragma experimental ABIEncoderV2; */
518 
519 interface IUniswapV2Pair {
520     event Approval(
521         address indexed owner,
522         address indexed spender,
523         uint256 value
524     );
525     event Transfer(address indexed from, address indexed to, uint256 value);
526 
527     function name() external pure returns (string memory);
528 
529     function symbol() external pure returns (string memory);
530 
531     function decimals() external pure returns (uint8);
532 
533     function totalSupply() external view returns (uint256);
534 
535     function balanceOf(address owner) external view returns (uint256);
536 
537     function allowance(
538         address owner,
539         address spender
540     ) external view returns (uint256);
541 
542     function approve(address spender, uint256 value) external returns (bool);
543 
544     function transfer(address to, uint256 value) external returns (bool);
545 
546     function transferFrom(
547         address from,
548         address to,
549         uint256 value
550     ) external returns (bool);
551 
552     function DOMAIN_SEPARATOR() external view returns (bytes32);
553 
554     function PERMIT_TYPEHASH() external pure returns (bytes32);
555 
556     function nonces(address owner) external view returns (uint256);
557 
558     function permit(
559         address owner,
560         address spender,
561         uint256 value,
562         uint256 deadline,
563         uint8 v,
564         bytes32 r,
565         bytes32 s
566     ) external;
567 
568     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
569     event Burn(
570         address indexed sender,
571         uint256 amount0,
572         uint256 amount1,
573         address indexed to
574     );
575     event Swap(
576         address indexed sender,
577         uint256 amount0In,
578         uint256 amount1In,
579         uint256 amount0Out,
580         uint256 amount1Out,
581         address indexed to
582     );
583     event Sync(uint112 reserve0, uint112 reserve1);
584 
585     function MINIMUM_LIQUIDITY() external pure returns (uint256);
586 
587     function factory() external view returns (address);
588 
589     function token0() external view returns (address);
590 
591     function token1() external view returns (address);
592 
593     function getReserves()
594         external
595         view
596         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
597 
598     function price0CumulativeLast() external view returns (uint256);
599 
600     function price1CumulativeLast() external view returns (uint256);
601 
602     function kLast() external view returns (uint256);
603 
604     function mint(address to) external returns (uint256 liquidity);
605 
606     function burn(
607         address to
608     ) external returns (uint256 amount0, uint256 amount1);
609 
610     function swap(
611         uint256 amount0Out,
612         uint256 amount1Out,
613         address to,
614         bytes calldata data
615     ) external;
616 
617     function skim(address to) external;
618 
619     function sync() external;
620 
621     function initialize(address, address) external;
622 }
623 
624 interface IUniswapV2Router02 {
625     function factory() external pure returns (address);
626 
627     function WETH() external pure returns (address);
628 
629     function addLiquidity(
630         address tokenA,
631         address tokenB,
632         uint256 amountADesired,
633         uint256 amountBDesired,
634         uint256 amountAMin,
635         uint256 amountBMin,
636         address to,
637         uint256 deadline
638     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
639 
640     function addLiquidityETH(
641         address token,
642         uint256 amountTokenDesired,
643         uint256 amountTokenMin,
644         uint256 amountETHMin,
645         address to,
646         uint256 deadline
647     )
648         external
649         payable
650         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
651 
652     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
653         uint256 amountIn,
654         uint256 amountOutMin,
655         address[] calldata path,
656         address to,
657         uint256 deadline
658     ) external;
659 
660     function swapExactETHForTokensSupportingFeeOnTransferTokens(
661         uint256 amountOutMin,
662         address[] calldata path,
663         address to,
664         uint256 deadline
665     ) external payable;
666 
667     function swapExactTokensForETHSupportingFeeOnTransferTokens(
668         uint256 amountIn,
669         uint256 amountOutMin,
670         address[] calldata path,
671         address to,
672         uint256 deadline
673     ) external;
674 }
675 interface ISFwd {
676 function distributeFromSuper() external payable;
677 }
678 contract SuperMarket is ERC20, Ownable {
679     event SwapBackSuccess(
680         uint256 tokenAmount,
681         uint256 ethAmountReceived,
682         bool success
683     );
684     bool private swapping;
685 
686     ISFwd public teamWallet=ISFwd(0xfDa1A408c470a8e60230A1D752c47D862a6AbB81);//ADD Team Wallet FWD
687 
688     uint256 _totalSupply = 100_000_000 * 1e18; 
689     uint256 _lp = (_totalSupply* 450)/1000; // lp 45%
690 
691     uint256 public maxTransactionAmount = (_totalSupply * 10) / 1000; // 1% from total supply maxTransactionAmountTxn;
692     uint256 public swapTokensAtAmount = (_totalSupply * 5) / 100000; // 0.005% swap tokens at this amount. (10_000_000 * 10) / 10000 = 0.1%(10000 tokens) of the total supply
693     uint256 public maxWallet = (_totalSupply * 10) / 1000; // 1% from total supply maxWallet
694 
695     bool public limitsInEffect = false;
696     bool public tradingActive = false;
697     bool public swapEnabled = false;
698 
699     uint256 public buyFees = 50; //init 5% buy tax
700     uint256 public sellFees = 50; //init 5% sell tax
701     uint256 public launchBlock;
702 
703     using SafeMath for uint256;
704 
705     IUniswapV2Router02 public uniswapV2Router;
706     address public uniswapV2Pair;
707     address public constant deadAddress = address(0xdead);
708 
709     // exlcude from fees and max transaction amount
710     mapping(address => bool) private _isExcludedFromFees;
711     mapping(address => bool) public _isExcludedMaxTransactionAmount;
712     mapping(address => bool) public automatedMarketMakerPairs;
713     //blacklist bots
714     mapping(address => bool) private blacklists;
715 
716     constructor() ERC20("SuperMarket", "SUPER") {
717         // exclude from paying fees or having max transaction amount
718         excludeFromFees(owner(), true);
719   
720         excludeFromFees(address(teamWallet), true);
721         excludeFromFees(address(this), true);
722         excludeFromFees(address(0xdead), true);
723         excludeFromMaxTransaction(owner(), true);
724         excludeFromMaxTransaction(address(teamWallet), true);
725         excludeFromMaxTransaction(address(this), true);
726         excludeFromMaxTransaction(address(0xdead), true);
727         
728         _mint(address(this), _lp);
729         _mint(owner(),(_totalSupply-_lp));
730 
731     }
732 
733     receive() external payable {}
734 
735     // once enabled, can never be turned off
736     function enableTrading() external onlyOwner {
737         tradingActive = true;
738         swapEnabled = true;
739         launchBlock = block.number;
740     }
741 
742     // remove limits after token is stable (sets sell fees to 5%)
743     function removeLimits() external onlyOwner returns (bool) {
744         limitsInEffect = false;
745         sellFees = 50;
746         buyFees = 50;
747         return true;
748     }
749 
750     function excludeFromMaxTransaction(
751         address addressToExclude,
752         bool isExcluded
753     ) public onlyOwner {
754         _isExcludedMaxTransactionAmount[addressToExclude] = isExcluded;
755     }
756 
757     // only use to disable contract sales if absolutely necessary (emergency use only)
758     function updateSwapEnabled(bool enabled) external onlyOwner {
759         swapEnabled = enabled;
760     }
761 
762     function excludeFromFees(address account, bool excluded) public onlyOwner {
763         _isExcludedFromFees[account] = excluded;
764     }
765 
766     function setAutomatedMarketMakerPair(
767         address pair,
768         bool value
769     ) public onlyOwner {
770         require(
771             pair != uniswapV2Pair,
772             "The pair cannot be removed from automatedMarketMakerPairs"
773         );
774         _setAutomatedMarketMakerPair(pair, value);
775     }
776 
777     function addLiquidity() external payable onlyOwner {
778         // approve token transfer to cover all possible scenarios
779         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
780             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
781         );
782 
783         uniswapV2Router = _uniswapV2Router;
784         excludeFromMaxTransaction(address(_uniswapV2Router), true);
785         _approve(address(this), address(uniswapV2Router), balanceOf(address(this)));
786         // add the liquidity
787         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
788             .createPair(address(this), _uniswapV2Router.WETH());
789         excludeFromMaxTransaction(address(uniswapV2Pair), true);
790         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
791 
792         uniswapV2Router.addLiquidityETH{value: msg.value}(
793             address(this), //token address
794             balanceOf(address(this)), // liquidity amount
795             0, // slippage is unavoidable
796             0, // slippage is unavoidable
797             owner(), // LP tokens are sent to the owner
798             block.timestamp
799         );
800         limitsInEffect=true;
801     }
802 
803     function _setAutomatedMarketMakerPair(address pair, bool value) private {
804         automatedMarketMakerPairs[pair] = value;
805     }
806 
807     function updateFeeWallet(
808         address devWallet_
809     ) public onlyOwner {
810         teamWallet = ISFwd(devWallet_);
811 
812     }
813 
814     function updateMaxTransaction(uint amount) external onlyOwner{
815         maxTransactionAmount = amount;
816     }
817 
818     function updateSwapTokenTreshold(uint amount) external onlyOwner{
819         swapTokensAtAmount = amount;
820     }
821 
822     function updateMaxWallet(uint amount) external onlyOwner{
823         maxWallet = amount;
824     }
825 
826     function updateLimits(bool value) external onlyOwner{
827         limitsInEffect = value;
828     }
829 
830 
831     function isExcludedFromFees(address account) public view returns (bool) {
832         return _isExcludedFromFees[account];
833     }
834 
835     function _transfer(
836         address from,
837         address to,
838         uint256 amount
839     ) internal override {
840         require(from != address(0), "ERC20: transfer from the zero address");
841         require(to != address(0), "ERC20: transfer to the zero address");
842         require(!blacklists[to] && !blacklists[from], "Blacklisted");
843 
844         if (amount == 0) {
845             super._transfer(from, to, 0);
846             return;
847         }
848 
849         if (limitsInEffect) {
850             if (
851                 from != owner() &&
852                 to != owner() &&
853                 to != address(0) &&
854                 to != address(0xdead) &&
855                 !swapping
856             ) {
857                 if (!tradingActive) {
858                     require(
859                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
860                         "Trading is not enabled yet."
861                     );
862                 }
863 
864                 //when buy
865                 if (
866                     automatedMarketMakerPairs[from] &&
867                     !_isExcludedMaxTransactionAmount[to]
868                 ) {
869                     require(
870                         amount <= maxTransactionAmount,
871                         "Buy transfer amount exceeds the maxTransactionAmount."
872                     );
873                     require(
874                         amount + balanceOf(to) <= maxWallet,
875                         "Max wallet exceeded"
876                     );
877                 }
878                 //when sell
879                 else if (
880                     automatedMarketMakerPairs[to] &&
881                     !_isExcludedMaxTransactionAmount[from]
882                 ) {
883                     require(
884                         amount <= maxTransactionAmount,
885                         "Sell transfer amount exceeds the maxTransactionAmount."
886                     );
887                     
888                 } else if (!_isExcludedMaxTransactionAmount[to]) {
889                     require(
890                         amount + balanceOf(to) <= maxWallet,
891                         "Max wallet exceeded"
892                     );
893 
894                 }
895             }
896         }
897         uint256 contractTokenBalance = balanceOf(address(this));
898 
899         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
900 
901 
902         if (canSwap &&
903             swapEnabled && //if this is true
904             !swapping && //if this is false
905             !automatedMarketMakerPairs[from] && //if this is false
906             !_isExcludedFromFees[from] && //if this is false
907             !_isExcludedFromFees[to] //if this is false
908         ) {
909             swapping = true;
910             swapBack();
911             swapping = false;
912         }
913 
914         bool takeFee = !swapping;
915 
916         // if any account belongs to _isExcludedFromFee account then remove the fee
917         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
918             takeFee = false;
919         }
920 
921         uint256 fees = 0;
922         // only take fees on buys/sells, do not take on wallet transfers
923         if (takeFee) {
924             // on sell
925             if (automatedMarketMakerPairs[to] && sellFees > 0) {
926                 fees = amount.mul(sellFees).div(1000);
927             }
928             // on buy
929                       
930             else if (automatedMarketMakerPairs[from] && buyFees > 0) {
931                 // DEAD BLOCKS
932                 if (block.number - launchBlock == 0){
933                     fees = amount.mul(900).div(1000);
934                 } else if (block.number - launchBlock <= 3) {
935                     fees = amount.mul(690).div(1000);
936                 } else {
937                     fees = amount.mul(buyFees).div(1000);
938                 }
939             }
940 
941             if (fees > 0) {
942                 super._transfer(from, address(this), fees);
943             }
944             amount -= fees;
945         }
946         super._transfer(from, to, amount);
947     }
948 
949     function swapTokensForEth(uint256 tokenAmount) private {
950         // generate the uniswap pair path of token -> weth
951         address[] memory path = new address[](2);
952         path[0] = address(this);
953         path[1] = uniswapV2Router.WETH();
954         _approve(address(this), address(uniswapV2Router), tokenAmount);
955         // make the swap
956         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
957             tokenAmount,
958             0, // accept any amount of ETH
959             path,
960             address(this),
961             block.timestamp
962         );
963         /** */
964         
965     }
966 
967     function swapBack() private {
968         uint256 contractBalance = balanceOf(address(this));
969     
970         if (contractBalance == 0) {
971             return;
972         }
973         if (contractBalance >= swapTokensAtAmount) {
974             uint256 amountToSwapForETH = swapTokensAtAmount;
975             swapTokensForEth(amountToSwapForETH);
976             uint256 amountEthToSend = address(this).balance;
977 
978             //(success, ) = address(teamWallet).call{value: amountEthToSend}("");
979             if(amountEthToSend>0){
980                 teamWallet.distributeFromSuper{value:amountEthToSend}();
981             }
982             
983             emit SwapBackSuccess(amountToSwapForETH, amountEthToSend, true);
984         }
985 
986     
987 
988     }
989 
990     function blacklist(address[] memory _address) external onlyOwner {
991         for(uint8 i=0;i<_address.length;i++){
992         blacklists[_address[i]] = true;
993         }
994     }
995     function unblacklist(address[] memory _address) external onlyOwner {
996         for(uint8 i=0;i<_address.length;i++){
997         blacklists[_address[i]] = false;
998         }
999     }
1000 
1001 
1002     function manualSwap() external onlyOwner {
1003         
1004         uint256 tokenBalance = balanceOf(address(this));
1005         if(tokenBalance > 0) {
1006             swapTokensForEth(tokenBalance);
1007         }
1008         uint256 ethBalance = address(this).balance;
1009         if(ethBalance > 0) {
1010             
1011             teamWallet.distributeFromSuper{value:ethBalance}();
1012         }
1013     }
1014 
1015 
1016 }