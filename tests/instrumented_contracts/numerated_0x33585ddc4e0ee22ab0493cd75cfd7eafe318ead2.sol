1 /**
2 
3 $PHATT
4 
5 The liquidity pool locked forever. No Taxes, No Bullshit. It’s that simple.
6 
7 https://phattcoin.vip/
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity >=0.8.19;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(
28         address indexed previousOwner,
29         address indexed newOwner
30     );
31 
32     /**
33      * @dev Initializes the contract setting the deployer as the initial owner.
34      */
35     constructor() {
36         address msgSender = _msgSender();
37         _owner = msgSender;
38         emit OwnershipTransferred(address(0), msgSender);
39     }
40 
41     /**
42      * @dev Returns the address of the current owner.
43      */
44     function owner() public view returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(_owner == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     /**
57      * @dev Leaves the contract without owner. It will not be possible to call
58      * `onlyOwner` functions anymore. Can only be called by the current owner.
59      *
60      * NOTE: Renouncing ownership will leave the contract without an owner,
61      * thereby removing any functionality that is only available to the owner.
62      */
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Can only be called by the current owner.
71      */
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(
74             newOwner != address(0),
75             "Ownable: new owner is the zero address"
76         );
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 }
81 
82 interface IERC20 {
83     function totalSupply() external view returns (uint256);
84 
85     function balanceOf(address account) external view returns (uint256);
86 
87     function transfer(
88         address recipient,
89         uint256 amount
90     ) external returns (bool);
91 
92     function allowance(
93         address owner,
94         address spender
95     ) external view returns (uint256);
96 
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     event Approval(
108         address indexed owner,
109         address indexed spender,
110         uint256 value
111     );
112 }
113 
114 interface IERC20Metadata is IERC20 {
115     function name() external view returns (string memory);
116 
117     function symbol() external view returns (string memory);
118 
119     function decimals() external view returns (uint8);
120 }
121 
122 interface IERC20Errors {
123 
124     error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
125     error ERC20InvalidSender(address sender);
126     error ERC20InvalidReceiver(address receiver);
127     error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
128     error ERC20InvalidApprover(address approver);
129     error ERC20InvalidSpender(address spender);
130 
131 }
132 
133 abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
134     mapping(address account => uint256) private _balances;
135 
136     mapping(address account => mapping(address spender => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142 
143     error ERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);
144 
145     constructor(string memory name_, string memory symbol_) {
146         _name = name_;
147         _symbol = symbol_;
148     }
149 
150     function name() public view virtual returns (string memory) {
151         return _name;
152     }
153 
154     function symbol() public view virtual returns (string memory) {
155         return _symbol;
156     }
157 
158     function decimals() public view virtual returns (uint8) {
159         return 18;
160     }
161 
162     function totalSupply() public view virtual returns (uint256) {
163         return _totalSupply;
164     }
165 
166     function balanceOf(address account) public view virtual returns (uint256) {
167         return _balances[account];
168     }
169 
170     function transfer(address to, uint256 value) public virtual returns (bool) {
171         address owner = _msgSender();
172         _transfer(owner, to, value);
173         return true;
174     }
175 
176     function allowance(address owner, address spender) public view virtual returns (uint256) {
177         return _allowances[owner][spender];
178     }
179 
180     function approve(address spender, uint256 value) public virtual returns (bool) {
181         address owner = _msgSender();
182         _approve(owner, spender, value);
183         return true;
184     }
185 
186     function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
187         address spender = _msgSender();
188         _spendAllowance(from, spender, value);
189         _transfer(from, to, value);
190         return true;
191     }
192 
193     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
194         address owner = _msgSender();
195         _approve(owner, spender, allowance(owner, spender) + addedValue);
196         return true;
197     }
198 
199     function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
200         address owner = _msgSender();
201         uint256 currentAllowance = allowance(owner, spender);
202         if (currentAllowance < requestedDecrease) {
203             revert ERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
204         }
205         unchecked {
206             _approve(owner, spender, currentAllowance - requestedDecrease);
207         }
208 
209         return true;
210     }
211 
212     function _transfer(address from, address to, uint256 value) internal {
213         if (from == address(0)) {
214             revert ERC20InvalidSender(address(0));
215         }
216         if (to == address(0)) {
217             revert ERC20InvalidReceiver(address(0));
218         }
219         _update(from, to, value);
220     }
221 
222     function _update(address from, address to, uint256 value) internal virtual {
223         if (from == address(0)) {
224             // Overflow check required: The rest of the code assumes that totalSupply never overflows
225             _totalSupply += value;
226         } else {
227             uint256 fromBalance = _balances[from];
228             if (fromBalance < value) {
229                 revert ERC20InsufficientBalance(from, fromBalance, value);
230             }
231             unchecked {
232                 // Overflow not possible: value <= fromBalance <= totalSupply.
233                 _balances[from] = fromBalance - value;
234             }
235         }
236 
237         if (to == address(0)) {
238             unchecked {
239                 // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
240                 _totalSupply -= value;
241             }
242         } else {
243             unchecked {
244                 // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
245                 _balances[to] += value;
246             }
247         }
248 
249         emit Transfer(from, to, value);
250     }
251 
252     function _mint(address account, uint256 value) internal {
253         if (account == address(0)) {
254             revert ERC20InvalidReceiver(address(0));
255         }
256         _update(address(0), account, value);
257     }
258 
259     function _burn(address account, uint256 value) internal {
260         if (account == address(0)) {
261             revert ERC20InvalidSender(address(0));
262         }
263         _update(account, address(0), value);
264     }
265 
266     function _approve(address owner, address spender, uint256 value) internal {
267         _approve(owner, spender, value, true);
268     }
269 
270     function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
271         if (owner == address(0)) {
272             revert ERC20InvalidApprover(address(0));
273         }
274         if (spender == address(0)) {
275             revert ERC20InvalidSpender(address(0));
276         }
277         _allowances[owner][spender] = value;
278         if (emitEvent) {
279             emit Approval(owner, spender, value);
280         }
281     }
282 
283     function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
284         uint256 currentAllowance = allowance(owner, spender);
285         if (currentAllowance != type(uint256).max) {
286             if (currentAllowance < value) {
287                 revert ERC20InsufficientAllowance(spender, currentAllowance, value);
288             }
289             unchecked {
290                 _approve(owner, spender, currentAllowance - value, false);
291             }
292         }
293     }
294 }
295 
296 library SafeMath {
297     function tryAdd(
298         uint256 a,
299         uint256 b
300     ) internal pure returns (bool, uint256) {
301         unchecked {
302             uint256 c = a + b;
303             if (c < a) return (false, 0);
304             return (true, c);
305         }
306     }
307 
308     function trySub(
309         uint256 a,
310         uint256 b
311     ) internal pure returns (bool, uint256) {
312         unchecked {
313             if (b > a) return (false, 0);
314             return (true, a - b);
315         }
316     }
317 
318     function tryMul(
319         uint256 a,
320         uint256 b
321     ) internal pure returns (bool, uint256) {
322         unchecked {
323             if (a == 0) return (true, 0);
324             uint256 c = a * b;
325             if (c / a != b) return (false, 0);
326             return (true, c);
327         }
328     }
329 
330     function tryDiv(
331         uint256 a,
332         uint256 b
333     ) internal pure returns (bool, uint256) {
334         unchecked {
335             if (b == 0) return (false, 0);
336             return (true, a / b);
337         }
338     }
339 
340     function tryMod(
341         uint256 a,
342         uint256 b
343     ) internal pure returns (bool, uint256) {
344         unchecked {
345             if (b == 0) return (false, 0);
346             return (true, a % b);
347         }
348     }
349 
350     function add(uint256 a, uint256 b) internal pure returns (uint256) {
351         return a + b;
352     }
353 
354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
355         return a - b;
356     }
357 
358     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a * b;
360     }
361 
362     function div(uint256 a, uint256 b) internal pure returns (uint256) {
363         return a / b;
364     }
365 
366     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a % b;
368     }
369 
370     function sub(
371         uint256 a,
372         uint256 b,
373         string memory errorMessage
374     ) internal pure returns (uint256) {
375         unchecked {
376             require(b <= a, errorMessage);
377             return a - b;
378         }
379     }
380 
381     function div(
382         uint256 a,
383         uint256 b,
384         string memory errorMessage
385     ) internal pure returns (uint256) {
386         unchecked {
387             require(b > 0, errorMessage);
388             return a / b;
389         }
390     }
391 
392     function mod(
393         uint256 a,
394         uint256 b,
395         string memory errorMessage
396     ) internal pure returns (uint256) {
397         unchecked {
398             require(b > 0, errorMessage);
399             return a % b;
400         }
401     }
402 }
403 
404 interface IDexFactory {
405     event PairCreated(
406         address indexed token0,
407         address indexed token1,
408         address pair,
409         uint256
410     );
411 
412     function feeTo() external view returns (address);
413 
414     function feeToSetter() external view returns (address);
415 
416     function getPair(
417         address tokenA,
418         address tokenB
419     ) external view returns (address pair);
420 
421     function allPairs(uint256) external view returns (address pair);
422 
423     function allPairsLength() external view returns (uint256);
424 
425     function createPair(
426         address tokenA,
427         address tokenB
428     ) external returns (address pair);
429 
430     function setFeeTo(address) external;
431 
432     function setFeeToSetter(address) external;
433 }
434 
435 interface IUniswapV2Pair {
436     event Approval(
437         address indexed owner,
438         address indexed spender,
439         uint256 value
440     );
441     event Transfer(address indexed from, address indexed to, uint256 value);
442 
443     function name() external pure returns (string memory);
444 
445     function symbol() external pure returns (string memory);
446 
447     function decimals() external pure returns (uint8);
448 
449     function totalSupply() external view returns (uint256);
450 
451     function balanceOf(address owner) external view returns (uint256);
452 
453     function allowance(
454         address owner,
455         address spender
456     ) external view returns (uint256);
457 
458     function approve(address spender, uint256 value) external returns (bool);
459 
460     function transfer(address to, uint256 value) external returns (bool);
461 
462     function transferFrom(
463         address from,
464         address to,
465         uint256 value
466     ) external returns (bool);
467 
468     function DOMAIN_SEPARATOR() external view returns (bytes32);
469 
470     function PERMIT_TYPEHASH() external pure returns (bytes32);
471 
472     function nonces(address owner) external view returns (uint256);
473 
474     function permit(
475         address owner,
476         address spender,
477         uint256 value,
478         uint256 deadline,
479         uint8 v,
480         bytes32 r,
481         bytes32 s
482     ) external;
483 
484     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
485     event Burn(
486         address indexed sender,
487         uint256 amount0,
488         uint256 amount1,
489         address indexed to
490     );
491     event Swap(
492         address indexed sender,
493         uint256 amount0In,
494         uint256 amount1In,
495         uint256 amount0Out,
496         uint256 amount1Out,
497         address indexed to
498     );
499     event Sync(uint112 reserve0, uint112 reserve1);
500 
501     function MINIMUM_LIQUIDITY() external pure returns (uint256);
502 
503     function factory() external view returns (address);
504 
505     function token0() external view returns (address);
506 
507     function token1() external view returns (address);
508 
509     function getReserves()
510         external
511         view
512         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
513 
514     function price0CumulativeLast() external view returns (uint256);
515 
516     function price1CumulativeLast() external view returns (uint256);
517 
518     function kLast() external view returns (uint256);
519 
520     function mint(address to) external returns (uint256 liquidity);
521 
522     function burn(
523         address to
524     ) external returns (uint256 amount0, uint256 amount1);
525 
526     function swap(
527         uint256 amount0Out,
528         uint256 amount1Out,
529         address to,
530         bytes calldata data
531     ) external;
532 
533     function skim(address to) external;
534 
535     function sync() external;
536 
537     function initialize(address, address) external;
538 }
539 
540 interface IDexRouter02 {
541     function factory() external pure returns (address);
542 
543     function WETH() external pure returns (address);
544 
545     function addLiquidity(
546         address tokenA,
547         address tokenB,
548         uint256 amountADesired,
549         uint256 amountBDesired,
550         uint256 amountAMin,
551         uint256 amountBMin,
552         address to,
553         uint256 deadline
554     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
555 
556     function addLiquidityETH(
557         address token,
558         uint256 amountTokenDesired,
559         uint256 amountTokenMin,
560         uint256 amountETHMin,
561         address to,
562         uint256 deadline
563     )
564         external
565         payable
566         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
567 
568     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
569         uint256 amountIn,
570         uint256 amountOutMin,
571         address[] calldata path,
572         address to,
573         uint256 deadline
574     ) external;
575 
576     function swapExactETHForTokensSupportingFeeOnTransferTokens(
577         uint256 amountOutMin,
578         address[] calldata path,
579         address to,
580         uint256 deadline
581     ) external payable;
582 
583     function swapExactTokensForETHSupportingFeeOnTransferTokens(
584         uint256 amountIn,
585         uint256 amountOutMin,
586         address[] calldata path,
587         address to,
588         uint256 deadline
589     ) external;
590 }
591 
592 contract PHATT is ERC20, Ownable {
593     using SafeMath for uint256;
594 
595     IDexRouter02 private immutable dexRouter;
596     address public immutable dexPair;
597 
598     bool private duringContractSell;
599 
600     address public marketingWallet;
601 
602     uint256 private minSwapbackLimit;
603     uint256 private maxSwapbackLimit;
604 
605     uint256 public txLimit;
606     uint256 public walletLimit;
607 
608     uint256 public buyFee;
609     uint256 public sellFee;
610 
611     bool public tradingLimited = true;
612 
613     mapping(address => bool) private wlFees;
614     mapping(address => bool) private wlTxLimit;
615 
616     mapping(address => bool) public dexPairs;
617 
618     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
619 
620     event TaxesSwaped(uint256 tokensSwapped, uint256 ethReceived);
621 
622     constructor() ERC20("PHATT", "PHATT") {
623         IDexRouter02 _dexRouter = IDexRouter02(
624             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
625         );
626 
627         dexRouter = _dexRouter;
628 
629         dexPair = IDexFactory(_dexRouter.factory()).createPair(
630             address(this),
631             _dexRouter.WETH()
632         );
633         _setDexPair(address(dexPair), true);
634 
635         uint256 totalSupply = 10_000_000_000 * 1e18;
636 
637         txLimit = (totalSupply) / 100;
638         walletLimit = (totalSupply) / 100;
639 
640         buyFee = 14;
641         sellFee = 49;
642 
643         minSwapbackLimit = (totalSupply * 5) / 10000;
644         maxSwapbackLimit = (totalSupply * 1) / 100;
645 
646         marketingWallet = 0x5C9e7FB9c64E2306f477D52dD480a65F728A70CC;
647 
648         wlFees[msg.sender] = true;
649         wlFees[marketingWallet] = true;
650         wlFees[address(this)] = true;
651         wlFees[address(0xdead)] = true;
652 
653         wlTxLimit[owner()] = true;
654         wlTxLimit[address(this)] = true;
655         wlTxLimit[address(0xdead)] = true;
656         wlTxLimit[marketingWallet] = true;
657 
658         _mint(msg.sender, totalSupply);
659     }
660 
661     receive() external payable {}
662 
663     function EndLaunch() external onlyOwner returns (bool) {
664         buyFee = 0;
665         sellFee = 0;
666 
667         tradingLimited = false;
668         return true;
669     }
670 
671     function _setDexPair(address pair, bool value) private {
672         dexPairs[pair] = value;
673 
674         emit SetAutomatedMarketMakerPair(pair, value);
675     }
676 
677     function swapContractBalanceForFees() private {
678         uint256 tokenBalance = balanceOf(address(this));
679         bool success;
680 
681         if (tokenBalance == 0) {
682             return;
683         }
684 
685         if (tokenBalance > maxSwapbackLimit) {
686             tokenBalance = maxSwapbackLimit;
687         }
688 
689         address[] memory path = new address[](2);
690         path[0] = address(this);
691         path[1] = dexRouter.WETH();
692 
693         _approve(address(this), address(dexRouter), tokenBalance);
694 
695         // make the swap
696         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
697             tokenBalance,
698             0, // accept any amount of ETH
699             path,
700             address(this),
701             block.timestamp
702         );
703 
704         emit TaxesSwaped(tokenBalance, address(this).balance);
705 
706         (success, ) = address(marketingWallet).call{
707             value: address(this).balance
708         }("");
709     }
710 
711     function _update(
712         address from,
713         address to,
714         uint256 amount
715     ) internal override {
716 
717         if (amount == 0) {
718             super._update(from, to, 0);
719             return;
720         }
721 
722         if (tradingLimited) {
723             if (
724                 from != owner() &&
725                 to != owner() &&
726                 to != address(0) &&
727                 to != address(0xdead) &&
728                 !duringContractSell
729             ) {
730                 //when buy
731                 if (dexPairs[from] && !wlTxLimit[to]) {
732                     require(
733                         amount <= txLimit,
734                         "Buy transfer amount exceeds the txLimit."
735                     );
736                     require(
737                         amount + balanceOf(to) <= walletLimit,
738                         "Max wallet exceeded"
739                     );
740                 }
741                 //when sell
742                 else if (dexPairs[to] && !wlTxLimit[from]) {
743                     require(
744                         amount <= txLimit,
745                         "Sell transfer amount exceeds the txLimit."
746                     );
747                 } else if (!wlTxLimit[to]) {
748                     require(
749                         amount + balanceOf(to) <= walletLimit,
750                         "Max wallet exceeded"
751                     );
752                 }
753             }
754         }
755 
756         uint256 contractTokenBalance = balanceOf(address(this));
757 
758         bool canSwap = contractTokenBalance >= minSwapbackLimit;
759 
760         if (
761             canSwap &&
762             !duringContractSell &&
763             !dexPairs[from] &&
764             !wlFees[from] &&
765             !wlFees[to]
766         ) {
767             duringContractSell = true;
768 
769             swapContractBalanceForFees();
770 
771             duringContractSell = false;
772         }
773 
774         bool takeFee = !duringContractSell;
775 
776         // if any account belongs to _isExcludedFromFee account then remove the fee
777         if (wlFees[from] || wlFees[to]) {
778             takeFee = false;
779         }
780 
781         uint256 fees = 0;
782         // only take fees on buys/sells, do not take on wallet transfers
783         if (takeFee) {
784             // on sell
785             if (dexPairs[to] && sellFee > 0) {
786                 fees = amount.mul(sellFee).div(100);
787             }
788             // on buy
789             else if (dexPairs[from] && buyFee > 0) {
790                 fees = amount.mul(buyFee).div(100);
791             }
792 
793             if (fees > 0) {
794                 super._update(from, address(this), fees);
795             }
796 
797             amount -= fees;
798         }
799 
800         super._update(from, to, amount);
801     }
802 }