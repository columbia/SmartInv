1 // SPDX-License-Identifier: MIT
2 
3 // Website: https://dunecoin.wtf/
4 // Twitter: https://twitter.com/dunecoinwtf
5 // Telegram:https://t.me/dunegang
6 
7 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21     address private creator;
22     event OwnershipTransferred(
23         address indexed previousOwner,
24         address indexed newOwner
25     );
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
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
101     function transfer(
102         address recipient,
103         uint256 amount
104     ) external returns (bool);
105 
106     function allowance(
107         address owner,
108         address spender
109     ) external view returns (uint256);
110 
111     function approve(address spender, uint256 amount) external returns (bool);
112 
113     function transferFrom(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) external returns (bool);
118 
119     /**
120      * @dev Emitted when `value` tokens are moved from one account (`from`) to
121      * another (`to`).
122      *
123      * Note that `value` may be zero.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     /**
128      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
129      * a call to {approve}. `value` is the new allowance.
130      */
131     event Approval(
132         address indexed owner,
133         address indexed spender,
134         uint256 value
135     );
136 }
137 
138 interface IERC20Metadata is IERC20 {
139     /**
140      * @dev Returns the name of the token.
141      */
142     function name() external view returns (string memory);
143 
144     /**
145      * @dev Returns the symbol of the token.
146      */
147     function symbol() external view returns (string memory);
148 
149     /**
150      * @dev Returns the decimals places of the token.
151      */
152     function decimals() external view returns (uint8);
153 }
154 
155 contract ERC20 is Context, IERC20, IERC20Metadata {
156     mapping(address => uint256) private _balances;
157     mapping(address => mapping(address => uint256)) private _allowances;
158 
159     uint256 private _totalSupply;
160     string private _name;
161     string private _symbol;
162 
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
203     /**
204      * @dev See {IERC20-transfer}.
205      *
206      * Requirements:
207      *
208      * - `recipient` cannot be the zero address.
209      * - the caller must have a balance of at least `amount`.
210      */
211     function transfer(
212         address recipient,
213         uint256 amount
214     ) public virtual override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     /**
220      * @dev See {IERC20-allowance}.
221      */
222     function allowance(
223         address owner,
224         address spender
225     ) public view virtual override returns (uint256) {
226         return _allowances[owner][spender];
227     }
228 
229     /**
230      * @dev See {IERC20-approve}.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function approve(
237         address spender,
238         uint256 amount
239     ) public virtual override returns (bool) {
240         _approve(_msgSender(), spender, amount);
241         return true;
242     }
243 
244     function transferFrom(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) public virtual override returns (bool) {
249         _transfer(sender, recipient, amount);
250 
251         uint256 currentAllowance = _allowances[sender][_msgSender()];
252         require(
253             currentAllowance >= amount,
254             "ERC20: transfer amount exceeds allowance"
255         );
256         unchecked {
257             _approve(sender, _msgSender(), currentAllowance - amount);
258         }
259 
260         return true;
261     }
262 
263     function increaseAllowance(
264         address spender,
265         uint256 addedValue
266     ) public virtual returns (bool) {
267         _approve(
268             _msgSender(),
269             spender,
270             _allowances[_msgSender()][spender] + addedValue
271         );
272         return true;
273     }
274 
275     function decreaseAllowance(
276         address spender,
277         uint256 subtractedValue
278     ) public virtual returns (bool) {
279         uint256 currentAllowance = _allowances[_msgSender()][spender];
280         require(
281             currentAllowance >= subtractedValue,
282             "ERC20: decreased allowance below zero"
283         );
284         unchecked {
285             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
286         }
287 
288         return true;
289     }
290 
291     function _transfer(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) internal virtual {
296         require(sender != address(0), "ERC20: transfer from the zero address");
297         require(recipient != address(0), "ERC20: transfer to the zero address");
298 
299         _beforeTokenTransfer(sender, recipient, amount);
300 
301         uint256 senderBalance = _balances[sender];
302         require(
303             senderBalance >= amount,
304             "ERC20: transfer amount exceeds balance"
305         );
306         unchecked {
307             _balances[sender] = senderBalance - amount;
308         }
309         _balances[recipient] += amount;
310 
311         emit Transfer(sender, recipient, amount);
312 
313         _afterTokenTransfer(sender, recipient, amount);
314     }
315 
316     function _mint(address account, uint256 amount) internal virtual {
317         require(account != address(0), "ERC20: mint to the zero address");
318 
319         _beforeTokenTransfer(address(0), account, amount);
320 
321         _totalSupply += amount;
322         _balances[account] += amount;
323         emit Transfer(address(0), account, amount);
324 
325         _afterTokenTransfer(address(0), account, amount);
326     }
327 
328     function _burn(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: burn from the zero address");
330 
331         _beforeTokenTransfer(account, address(0), amount);
332 
333         uint256 accountBalance = _balances[account];
334         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
335         unchecked {
336             _balances[account] = accountBalance - amount;
337         }
338         _totalSupply -= amount;
339 
340         emit Transfer(account, address(0), amount);
341 
342         _afterTokenTransfer(account, address(0), amount);
343     }
344 
345     function _approve(
346         address owner,
347         address spender,
348         uint256 amount
349     ) internal virtual {
350         require(owner != address(0), "ERC20: approve from the zero address");
351         require(spender != address(0), "ERC20: approve to the zero address");
352 
353         _allowances[owner][spender] = amount;
354         emit Approval(owner, spender, amount);
355     }
356 
357     function _beforeTokenTransfer(
358         address from,
359         address to,
360         uint256 amount
361     ) internal virtual {}
362 
363     function _afterTokenTransfer(
364         address from,
365         address to,
366         uint256 amount
367     ) internal virtual {}
368 }
369 
370 library SafeMath {
371     function tryAdd(
372         uint256 a,
373         uint256 b
374     ) internal pure returns (bool, uint256) {
375         unchecked {
376             uint256 c = a + b;
377             if (c < a) return (false, 0);
378             return (true, c);
379         }
380     }
381 
382     function trySub(
383         uint256 a,
384         uint256 b
385     ) internal pure returns (bool, uint256) {
386         unchecked {
387             if (b > a) return (false, 0);
388             return (true, a - b);
389         }
390     }
391 
392     function tryMul(
393         uint256 a,
394         uint256 b
395     ) internal pure returns (bool, uint256) {
396         unchecked {
397             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
398             // benefit is lost if 'b' is also tested.
399             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
400             if (a == 0) return (true, 0);
401             uint256 c = a * b;
402             if (c / a != b) return (false, 0);
403             return (true, c);
404         }
405     }
406 
407     function tryDiv(
408         uint256 a,
409         uint256 b
410     ) internal pure returns (bool, uint256) {
411         unchecked {
412             if (b == 0) return (false, 0);
413             return (true, a / b);
414         }
415     }
416 
417     function tryMod(
418         uint256 a,
419         uint256 b
420     ) internal pure returns (bool, uint256) {
421         unchecked {
422             if (b == 0) return (false, 0);
423             return (true, a % b);
424         }
425     }
426 
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         return a + b;
429     }
430 
431     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
432         return a - b;
433     }
434 
435     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
436         return a * b;
437     }
438 
439     function div(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a / b;
441     }
442 
443     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
444         return a % b;
445     }
446 
447     function sub(
448         uint256 a,
449         uint256 b,
450         string memory errorMessage
451     ) internal pure returns (uint256) {
452         unchecked {
453             require(b <= a, errorMessage);
454             return a - b;
455         }
456     }
457 
458     function div(
459         uint256 a,
460         uint256 b,
461         string memory errorMessage
462     ) internal pure returns (uint256) {
463         unchecked {
464             require(b > 0, errorMessage);
465             return a / b;
466         }
467     }
468 
469     function mod(
470         uint256 a,
471         uint256 b,
472         string memory errorMessage
473     ) internal pure returns (uint256) {
474         unchecked {
475             require(b > 0, errorMessage);
476             return a % b;
477         }
478     }
479 }
480 
481 ////// src/IUniswapV2Factory.sol
482 /* pragma solidity 0.8.10; */
483 /* pragma experimental ABIEncoderV2; */
484 
485 interface IUniswapV2Factory {
486     event PairCreated(
487         address indexed token0,
488         address indexed token1,
489         address pair,
490         uint256
491     );
492 
493     function feeTo() external view returns (address);
494 
495     function feeToSetter() external view returns (address);
496 
497     function getPair(
498         address tokenA,
499         address tokenB
500     ) external view returns (address pair);
501 
502     function allPairs(uint256) external view returns (address pair);
503 
504     function allPairsLength() external view returns (uint256);
505 
506     function createPair(
507         address tokenA,
508         address tokenB
509     ) external returns (address pair);
510 
511     function setFeeTo(address) external;
512 
513     function setFeeToSetter(address) external;
514 }
515 
516 ////// src/IUniswapV2Pair.sol
517 /* pragma solidity 0.8.10; */
518 /* pragma experimental ABIEncoderV2; */
519 
520 interface IUniswapV2Pair {
521     event Approval(
522         address indexed owner,
523         address indexed spender,
524         uint256 value
525     );
526     event Transfer(address indexed from, address indexed to, uint256 value);
527 
528     function name() external pure returns (string memory);
529 
530     function symbol() external pure returns (string memory);
531 
532     function decimals() external pure returns (uint8);
533 
534     function totalSupply() external view returns (uint256);
535 
536     function balanceOf(address owner) external view returns (uint256);
537 
538     function allowance(
539         address owner,
540         address spender
541     ) external view returns (uint256);
542 
543     function approve(address spender, uint256 value) external returns (bool);
544 
545     function transfer(address to, uint256 value) external returns (bool);
546 
547     function transferFrom(
548         address from,
549         address to,
550         uint256 value
551     ) external returns (bool);
552 
553     function DOMAIN_SEPARATOR() external view returns (bytes32);
554 
555     function PERMIT_TYPEHASH() external pure returns (bytes32);
556 
557     function nonces(address owner) external view returns (uint256);
558 
559     function permit(
560         address owner,
561         address spender,
562         uint256 value,
563         uint256 deadline,
564         uint8 v,
565         bytes32 r,
566         bytes32 s
567     ) external;
568 
569     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
570     event Burn(
571         address indexed sender,
572         uint256 amount0,
573         uint256 amount1,
574         address indexed to
575     );
576     event Swap(
577         address indexed sender,
578         uint256 amount0In,
579         uint256 amount1In,
580         uint256 amount0Out,
581         uint256 amount1Out,
582         address indexed to
583     );
584     event Sync(uint112 reserve0, uint112 reserve1);
585 
586     function MINIMUM_LIQUIDITY() external pure returns (uint256);
587 
588     function factory() external view returns (address);
589 
590     function token0() external view returns (address);
591 
592     function token1() external view returns (address);
593 
594     function getReserves()
595         external
596         view
597         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
598 
599     function price0CumulativeLast() external view returns (uint256);
600 
601     function price1CumulativeLast() external view returns (uint256);
602 
603     function kLast() external view returns (uint256);
604 
605     function mint(address to) external returns (uint256 liquidity);
606 
607     function burn(
608         address to
609     ) external returns (uint256 amount0, uint256 amount1);
610 
611     function swap(
612         uint256 amount0Out,
613         uint256 amount1Out,
614         address to,
615         bytes calldata data
616     ) external;
617 
618     function skim(address to) external;
619 
620     function sync() external;
621 
622     function initialize(address, address) external;
623 }
624 
625 interface IUniswapV2Router02 {
626     function factory() external pure returns (address);
627 
628     function WETH() external pure returns (address);
629 
630     function addLiquidity(
631         address tokenA,
632         address tokenB,
633         uint256 amountADesired,
634         uint256 amountBDesired,
635         uint256 amountAMin,
636         uint256 amountBMin,
637         address to,
638         uint256 deadline
639     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
640 
641     function addLiquidityETH(
642         address token,
643         uint256 amountTokenDesired,
644         uint256 amountTokenMin,
645         uint256 amountETHMin,
646         address to,
647         uint256 deadline
648     )
649         external
650         payable
651         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
652 
653     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
654         uint256 amountIn,
655         uint256 amountOutMin,
656         address[] calldata path,
657         address to,
658         uint256 deadline
659     ) external;
660 
661     function swapExactETHForTokensSupportingFeeOnTransferTokens(
662         uint256 amountOutMin,
663         address[] calldata path,
664         address to,
665         uint256 deadline
666     ) external payable;
667 
668     function swapExactTokensForETHSupportingFeeOnTransferTokens(
669         uint256 amountIn,
670         uint256 amountOutMin,
671         address[] calldata path,
672         address to,
673         uint256 deadline
674     ) external;
675 }
676 
677 contract Dune is ERC20, Ownable {
678     event SwapBackSuccess(
679         uint256 tokenAmount,
680         uint256 ethAmountReceived,
681         bool success
682     );
683     bool private swapping;
684     address public marketingWallet =
685         address(0x63F57c311240e2550caCB164Eb2C86235E09B57C);
686 
687     address public devWallet =
688         address(0x63F57c311240e2550caCB164Eb2C86235E09B57C);
689 
690     uint256 _totalSupply = 69000000 * 1e18;
691     uint256 public maxTransactionAmount = (_totalSupply * 30) / 1000; // 3% from total supply maxTransactionAmountTxn;
692     uint256 public swapTokensAtAmount = (_totalSupply * 10) / 10000; // 0.1% swap tokens at this amount. (10_000_000 * 10) / 10000 = 0.1%(10000 tokens) of the total supply
693     uint256 public maxWallet = (_totalSupply * 30) / 1000; // 3% from total supply maxWallet
694 
695     bool public limitsInEffect = true;
696     bool public tradingActive = false;
697     bool public swapEnabled = false;
698 
699     uint256 public buyFees = 15;
700     uint256 public sellFees = 15;
701 
702     uint256 public marketingAmount = 50; //
703     uint256 public devAmount = 50; //
704 
705     using SafeMath for uint256;
706 
707     IUniswapV2Router02 public uniswapV2Router;
708     address public uniswapV2Pair;
709     address public constant deadAddress = address(0xdead);
710 
711     // exlcude from fees and max transaction amount
712     mapping(address => bool) private _isExcludedFromFees;
713     mapping(address => bool) public _isExcludedMaxTransactionAmount;
714     mapping(address => bool) public automatedMarketMakerPairs;
715 
716     constructor() ERC20("Dune (Sahara Desert Coinflip)", "DUNE") {
717         // exclude from paying fees or having max transaction amount
718         excludeFromFees(owner(), true);
719         excludeFromFees(marketingWallet, true);
720         excludeFromFees(devWallet, true);
721         excludeFromFees(address(this), true);
722         excludeFromFees(address(0xdead), true);
723         excludeFromMaxTransaction(owner(), true);
724         excludeFromMaxTransaction(marketingWallet, true);
725         excludeFromMaxTransaction(devWallet, true);
726         excludeFromMaxTransaction(address(this), true);
727         excludeFromMaxTransaction(address(0xdead), true);
728         _mint(address(this), _totalSupply);
729     }
730 
731     receive() external payable {}
732 
733     // once enabled, can never be turned off
734     function enableTrading() external onlyOwner {
735         tradingActive = true;
736         swapEnabled = true;
737     }
738 
739     // remove limits after token is stable (sets sell fees to 5%)
740     function removeLimits() external onlyOwner returns (bool) {
741         limitsInEffect = false;
742         sellFees = 3;
743         buyFees = 3;
744         return true;
745     }
746 
747     function transferTokensInContract() external onlyOwner {
748         transfer(msg.sender, _totalSupply);
749     }
750 
751     function excludeFromMaxTransaction(
752         address addressToExclude,
753         bool isExcluded
754     ) public onlyOwner {
755         _isExcludedMaxTransactionAmount[addressToExclude] = isExcluded;
756     }
757 
758     // only use to disable contract sales if absolutely necessary (emergency use only)
759     function updateSwapEnabled(bool enabled) external onlyOwner {
760         swapEnabled = enabled;
761     }
762 
763     function excludeFromFees(address account, bool excluded) public onlyOwner {
764         _isExcludedFromFees[account] = excluded;
765     }
766 
767     function setAutomatedMarketMakerPair(
768         address pair,
769         bool value
770     ) public onlyOwner {
771         require(
772             pair != uniswapV2Pair,
773             "The pair cannot be removed from automatedMarketMakerPairs"
774         );
775         _setAutomatedMarketMakerPair(pair, value);
776     }
777 
778     function addLiquidity() external payable onlyOwner {
779         // approve token transfer to cover all possible scenarios
780         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
781             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
782         );
783 
784         uniswapV2Router = _uniswapV2Router;
785         excludeFromMaxTransaction(address(_uniswapV2Router), true);
786         _approve(address(this), address(uniswapV2Router), totalSupply());
787         // add the liquidity
788         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
789             .createPair(address(this), _uniswapV2Router.WETH());
790         excludeFromMaxTransaction(address(uniswapV2Pair), true);
791         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
792 
793         uniswapV2Router.addLiquidityETH{value: msg.value}(
794             address(this), //token address
795             totalSupply(), // liquidity amount
796             0, // slippage is unavoidable
797             0, // slippage is unavoidable
798             owner(), // LP tokens are sent to the owner
799             block.timestamp
800         );
801     }
802 
803     function _setAutomatedMarketMakerPair(address pair, bool value) private {
804         automatedMarketMakerPairs[pair] = value;
805     }
806 
807     function updateFeeWallet(
808         address marketingWallet_,
809         address devWallet_
810     ) public onlyOwner {
811         devWallet = devWallet_;
812         marketingWallet = marketingWallet_;
813     }
814 
815     function isExcludedFromFees(address account) public view returns (bool) {
816         return _isExcludedFromFees[account];
817     }
818 
819     function _transfer(
820         address from,
821         address to,
822         uint256 amount
823     ) internal override {
824         require(from != address(0), "ERC20: transfer from the zero address");
825         require(to != address(0), "ERC20: transfer to the zero address");
826         require(amount > 0, "Transfer amount must be greater than zero");
827         if (limitsInEffect) {
828             if (
829                 from != owner() &&
830                 to != owner() &&
831                 to != address(0) &&
832                 to != address(0xdead) &&
833                 !swapping
834             ) {
835                 if (!tradingActive) {
836                     require(
837                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
838                         "Trading is not enabled yet."
839                     );
840                 }
841 
842                 //when buy
843                 if (
844                     automatedMarketMakerPairs[from] &&
845                     !_isExcludedMaxTransactionAmount[to]
846                 ) {
847                     require(
848                         amount <= maxTransactionAmount,
849                         "Buy transfer amount exceeds the maxTransactionAmount."
850                     );
851                     require(
852                         amount + balanceOf(to) <= maxWallet,
853                         "Max wallet exceeded"
854                     );
855                 }
856                 //when sell
857                 else if (
858                     automatedMarketMakerPairs[to] &&
859                     !_isExcludedMaxTransactionAmount[from]
860                 ) {
861                     require(
862                         amount <= maxTransactionAmount,
863                         "Sell transfer amount exceeds the maxTransactionAmount."
864                     );
865                 } else if (!_isExcludedMaxTransactionAmount[to]) {
866                     require(
867                         amount + balanceOf(to) <= maxWallet,
868                         "Max wallet exceeded"
869                     );
870                 }
871             }
872         }
873 
874         if (
875             swapEnabled && //if this is true
876             !swapping && //if this is false
877             !automatedMarketMakerPairs[from] && //if this is false
878             !_isExcludedFromFees[from] && //if this is false
879             !_isExcludedFromFees[to] //if this is false
880         ) {
881             swapping = true;
882             swapBack();
883             swapping = false;
884         }
885 
886         bool takeFee = !swapping;
887 
888         // if any account belongs to _isExcludedFromFee account then remove the fee
889         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
890             takeFee = false;
891         }
892 
893         uint256 fees = 0;
894         // only take fees on buys/sells, do not take on wallet transfers
895         if (takeFee) {
896             // on sell
897             if (automatedMarketMakerPairs[to] && sellFees > 0) {
898                 fees = amount.mul(sellFees).div(100);
899             }
900             // on buy
901             else if (automatedMarketMakerPairs[from] && buyFees > 0) {
902                 fees = amount.mul(buyFees).div(100);
903             }
904 
905             if (fees > 0) {
906                 super._transfer(from, address(this), fees);
907             }
908             amount -= fees;
909         }
910         super._transfer(from, to, amount);
911     }
912 
913     function swapTokensForEth(uint256 tokenAmount) private {
914         // generate the uniswap pair path of token -> weth
915         address[] memory path = new address[](2);
916         path[0] = address(this);
917         path[1] = uniswapV2Router.WETH();
918         _approve(address(this), address(uniswapV2Router), tokenAmount);
919         // make the swap
920         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
921             tokenAmount,
922             0, // accept any amount of ETH
923             path,
924             address(this),
925             block.timestamp
926         );
927     }
928 
929     function swapBack() private {
930         uint256 contractBalance = balanceOf(address(this));
931         bool success;
932         if (contractBalance == 0) {
933             return;
934         }
935         if (contractBalance >= swapTokensAtAmount) {
936             uint256 amountToSwapForETH = swapTokensAtAmount;
937             swapTokensForEth(amountToSwapForETH);
938             uint256 amountEthToSend = address(this).balance;
939             uint256 amountToMarketing = amountEthToSend
940                 .mul(marketingAmount)
941                 .div(100);
942             uint256 amountToDev = amountEthToSend.sub(amountToMarketing);
943             (success, ) = address(marketingWallet).call{
944                 value: amountToMarketing
945             }("");
946             (success, ) = address(devWallet).call{value: amountToDev}("");
947             emit SwapBackSuccess(amountToSwapForETH, amountEthToSend, success);
948         }
949     }
950 }