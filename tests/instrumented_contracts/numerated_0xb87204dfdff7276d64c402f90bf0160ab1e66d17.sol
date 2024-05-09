1 /*
2     Sushi Inu 
3     Make every day Sushi day
4     5/5 tax
5 
6     https://sushierc.tech/
7     https://twitter.com/sushierc
8     https://t.me/sushierc
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
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
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _transferOwnership(newOwner);
51     }
52     function _transferOwnership(address newOwner) internal virtual {
53         address oldOwner = _owner;
54         _owner = newOwner;
55         emit OwnershipTransferred(oldOwner, newOwner);
56     }
57 }
58 
59 interface IERC20 {
60     function totalSupply() external view returns (uint256);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 interface IERC20Metadata is IERC20 {
75     /**
76      * @dev Returns the name of the token.
77      */
78     function name() external view returns (string memory);
79 
80     /**
81      * @dev Returns the symbol of the token.
82      */
83     function symbol() external view returns (string memory);
84 
85     /**
86      * @dev Returns the decimals places of the token.
87      */
88     function decimals() external view returns (uint8);
89 }
90 
91 contract ERC20 is Context, IERC20, IERC20Metadata {
92     mapping(address => uint256) private _balances;
93 
94     mapping(address => mapping(address => uint256)) private _allowances;
95 
96     uint256 private _totalSupply;
97 
98     string private _name;
99     string private _symbol;
100 
101     constructor(string memory name_, string memory symbol_) {
102         _name = name_;
103         _symbol = symbol_;
104     }
105 
106 
107     function name() public view virtual override returns (string memory) {
108         return _name;
109     }
110 
111     function symbol() public view virtual override returns (string memory) {
112         return _symbol;
113     }
114 
115     function decimals() public view virtual override returns (uint8) {
116         return 18;
117     }
118 
119     function totalSupply() public view virtual override returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address account) public view virtual override returns (uint256) {
124         return _balances[account];
125     }
126 
127     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
128         _transfer(_msgSender(), recipient, amount);
129         return true;
130     }
131 
132     function allowance(address owner, address spender) public view virtual override returns (uint256) {
133         return _allowances[owner][spender];
134     }
135 
136     function approve(address spender, uint256 amount) public virtual override returns (bool) {
137         _approve(_msgSender(), spender, amount);
138         return true;
139     }
140 
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) public virtual override returns (bool) {
146         _transfer(sender, recipient, amount);
147 
148         uint256 currentAllowance = _allowances[sender][_msgSender()];
149         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
150         unchecked {
151             _approve(sender, _msgSender(), currentAllowance - amount);
152         }
153 
154         return true;
155     }
156 
157     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
158         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
159         return true;
160     }
161 
162     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
163         uint256 currentAllowance = _allowances[_msgSender()][spender];
164         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
165         unchecked {
166             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
167         }
168 
169         return true;
170     }
171 
172     function _transfer(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) internal virtual {
177         require(sender != address(0), "ERC20: transfer from the zero address");
178         require(recipient != address(0), "ERC20: transfer to the zero address");
179 
180         _beforeTokenTransfer(sender, recipient, amount);
181 
182         uint256 senderBalance = _balances[sender];
183         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
184         unchecked {
185             _balances[sender] = senderBalance - amount;
186         }
187         _balances[recipient] += amount;
188 
189         emit Transfer(sender, recipient, amount);
190 
191         _afterTokenTransfer(sender, recipient, amount);
192     }
193 
194     function _mint(address account, uint256 amount) internal virtual {
195         require(account != address(0), "ERC20: mint to the zero address");
196 
197         _beforeTokenTransfer(address(0), account, amount);
198 
199         _totalSupply += amount;
200         _balances[account] += amount;
201         emit Transfer(address(0), account, amount);
202 
203         _afterTokenTransfer(address(0), account, amount);
204     }
205 
206     function _burn(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _beforeTokenTransfer(account, address(0), amount);
210 
211         uint256 accountBalance = _balances[account];
212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
213         unchecked {
214             _balances[account] = accountBalance - amount;
215         }
216         _totalSupply -= amount;
217 
218         emit Transfer(account, address(0), amount);
219 
220         _afterTokenTransfer(account, address(0), amount);
221     }
222 
223     function _approve(
224         address owner,
225         address spender,
226         uint256 amount
227     ) internal virtual {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230 
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     function _beforeTokenTransfer(
236         address from,
237         address to,
238         uint256 amount
239     ) internal virtual {}
240 
241     function _afterTokenTransfer(
242         address from,
243         address to,
244         uint256 amount
245     ) internal virtual {}
246 }
247 
248 library SafeMath {
249     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             uint256 c = a + b;
252             if (c < a) return (false, 0);
253             return (true, c);
254         }
255     }
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265             // benefit is lost if 'b' is also tested.
266             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267             if (a == 0) return (true, 0);
268             uint256 c = a * b;
269             if (c / a != b) return (false, 0);
270             return (true, c);
271         }
272     }
273 
274     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (b == 0) return (false, 0);
277             return (true, a / b);
278         }
279     }
280 
281     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (b == 0) return (false, 0);
284             return (true, a % b);
285         }
286     }
287 
288     function add(uint256 a, uint256 b) internal pure returns (uint256) {
289         return a + b;
290     }
291 
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a - b;
294     }
295 
296     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a * b;
298     }
299 
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a / b;
302     }
303 
304     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a % b;
306     }
307 
308     function sub(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b <= a, errorMessage);
315             return a - b;
316         }
317     }
318 
319     function div(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b > 0, errorMessage);
326             return a / b;
327         }
328     }
329 
330     function mod(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b > 0, errorMessage);
337             return a % b;
338         }
339     }
340 }
341 
342 interface IUniswapV2Factory {
343     event PairCreated(
344         address indexed token0,
345         address indexed token1,
346         address pair,
347         uint256
348     );
349 
350     function feeTo() external view returns (address);
351 
352     function feeToSetter() external view returns (address);
353 
354     function getPair(address tokenA, address tokenB)
355         external
356         view
357         returns (address pair);
358 
359     function allPairs(uint256) external view returns (address pair);
360 
361     function allPairsLength() external view returns (uint256);
362 
363     function createPair(address tokenA, address tokenB)
364         external
365         returns (address pair);
366 
367     function setFeeTo(address) external;
368 
369     function setFeeToSetter(address) external;
370 }
371 
372 interface IUniswapV2Pair {
373     event Approval(
374         address indexed owner,
375         address indexed spender,
376         uint256 value
377     );
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     function name() external pure returns (string memory);
381 
382     function symbol() external pure returns (string memory);
383 
384     function decimals() external pure returns (uint8);
385 
386     function totalSupply() external view returns (uint256);
387 
388     function balanceOf(address owner) external view returns (uint256);
389 
390     function allowance(address owner, address spender)
391         external
392         view
393         returns (uint256);
394 
395     function approve(address spender, uint256 value) external returns (bool);
396 
397     function transfer(address to, uint256 value) external returns (bool);
398 
399     function transferFrom(
400         address from,
401         address to,
402         uint256 value
403     ) external returns (bool);
404 
405 
406     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
407     event Burn(
408         address indexed sender,
409         uint256 amount0,
410         uint256 amount1,
411         address indexed to
412     );
413     event Swap(
414         address indexed sender,
415         uint256 amount0In,
416         uint256 amount1In,
417         uint256 amount0Out,
418         uint256 amount1Out,
419         address indexed to
420     );
421 
422     function factory() external view returns (address);
423 
424     function token0() external view returns (address);
425 
426     function token1() external view returns (address);
427 
428     function getReserves()
429         external
430         view
431         returns (
432             uint112 reserve0,
433             uint112 reserve1,
434             uint32 blockTimestampLast
435         );
436 
437     function mint(address to) external returns (uint256 liquidity);
438 
439     function burn(address to)
440         external
441         returns (uint256 amount0, uint256 amount1);
442 
443     function swap(
444         uint256 amount0Out,
445         uint256 amount1Out,
446         address to,
447         bytes calldata data
448     ) external;
449 
450     function skim(address to) external;
451 
452 }
453 
454 interface IUniswapV2Router02 {
455     function factory() external pure returns (address);
456 
457     function WETH() external pure returns (address);
458 
459     function addLiquidity(
460         address tokenA,
461         address tokenB,
462         uint256 amountADesired,
463         uint256 amountBDesired,
464         uint256 amountAMin,
465         uint256 amountBMin,
466         address to,
467         uint256 deadline
468     )
469         external
470         returns (
471             uint256 amountA,
472             uint256 amountB,
473             uint256 liquidity
474         );
475 
476     function addLiquidityETH(
477         address token,
478         uint256 amountTokenDesired,
479         uint256 amountTokenMin,
480         uint256 amountETHMin,
481         address to,
482         uint256 deadline
483     )
484         external
485         payable
486         returns (
487             uint256 amountToken,
488             uint256 amountETH,
489             uint256 liquidity
490         );
491 
492     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
493         uint256 amountIn,
494         uint256 amountOutMin,
495         address[] calldata path,
496         address to,
497         uint256 deadline
498     ) external;
499 
500     function swapExactETHForTokensSupportingFeeOnTransferTokens(
501         uint256 amountOutMin,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external payable;
506 
507     function swapExactTokensForETHSupportingFeeOnTransferTokens(
508         uint256 amountIn,
509         uint256 amountOutMin,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external;
514 }
515 
516 contract Sushi is ERC20, Ownable {
517     using SafeMath for uint256;
518 
519     IUniswapV2Router02 public immutable uniswapV2Router;
520     address public immutable uniswapV2Pair;
521     address public constant deadAddress = address(0xdead);
522 
523     bool private swapping;
524 
525     address public devWallet;
526 
527     uint256 public maxTransactionAmount;
528     uint256 public swapTokensAtAmount;
529     uint256 public maxWallet;
530 
531     bool public limitsInEffect = true;
532     bool public tradingActive = false;
533     bool public swapEnabled = false;
534 
535     uint256 public buyTotalFees;
536     uint256 public buyLiquidityFee;
537     uint256 public buyMarketingFee;
538 
539     uint256 public sellTotalFees;
540     uint256 public sellLiquidityFee;
541     uint256 public sellMarketingFee;
542 
543 	uint256 public tokensForLiquidity;
544     uint256 public tokensForMarketing;
545 
546     /******************/
547 
548     // exlcude from fees and max transaction amount
549     mapping(address => bool) private _isExcludedFromFees;
550     mapping(address => bool) public _isExcludedMaxTransactionAmount;
551 
552     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
553     // could be subject to a maximum transfer amount
554     mapping(address => bool) public automatedMarketMakerPairs;
555 
556     event UpdateUniswapV2Router(
557         address indexed newAddress,
558         address indexed oldAddress
559     );
560 
561     event ExcludeFromFees(address indexed account, bool isExcluded);
562 
563     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
564 
565     event SwapAndLiquify(
566         uint256 tokensSwapped,
567         uint256 ethReceived,
568         uint256 tokensIntoLiquidity
569     );
570 
571     constructor() ERC20("Sushi Inu", unicode"🍣") {
572         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
573             0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
574         );
575 
576         excludeFromMaxTransaction(address(_uniswapV2Router), true);
577         uniswapV2Router = _uniswapV2Router;
578 
579         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
580             .createPair(address(this), _uniswapV2Router.WETH());
581         excludeFromMaxTransaction(address(uniswapV2Pair), true);
582         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
583 
584         uint256 _buyLiquidityFee = 2;
585         uint256 _buyMarketingFee = 3;
586 
587         uint256 _sellLiquidityFee = 2;
588         uint256 _sellMarketingFee = 3;
589 
590         uint256 totalSupply = 1 * 1e9 * 1e18;
591 
592         maxTransactionAmount = 1 * 1e7 * 1e18; // 1% from total supply maxTransactionAmountTxn
593         maxWallet = 1 * 1e7 * 1e18; // 1% from total supply maxWallet
594         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
595 
596         buyLiquidityFee = _buyLiquidityFee;
597         buyMarketingFee = _buyMarketingFee;
598         buyTotalFees = buyLiquidityFee + buyMarketingFee;
599 
600         sellLiquidityFee = _sellLiquidityFee;
601         sellMarketingFee = _sellMarketingFee;
602         sellTotalFees = sellLiquidityFee + sellMarketingFee;
603 
604         devWallet = address(0xFF9B9d2d7c3cA928ABD58D089d3F0cD5C69ad530); 
605 
606         // exclude from paying fees or having max transaction amount
607         excludeFromFees(owner(), true);
608         excludeFromFees(address(this), true);
609         excludeFromFees(address(0xdead), true);
610 
611         excludeFromMaxTransaction(owner(), true);
612         excludeFromMaxTransaction(address(this), true);
613         excludeFromMaxTransaction(address(0xdead), true);
614 
615         /*
616             _mint is an internal function in ERC20.sol that is only called here,
617             and CANNOT be called ever again
618         */
619         _mint(msg.sender, totalSupply);
620     }
621 
622     receive() external payable {}
623 
624     // once enabled, can never be turned off
625     function enableTrading() external onlyOwner {
626         tradingActive = true;
627         swapEnabled = true;
628     }
629 
630     // remove limits after token is stable
631     function removeLimits() external onlyOwner returns (bool) {
632         limitsInEffect = false;
633         return true;
634     }
635 
636     // change the minimum amount of tokens to sell from fees
637     function updateSwapTokensAtAmount(uint256 newAmount)
638         external
639         onlyOwner
640         returns (bool)
641     {
642         require(
643             newAmount >= (totalSupply() * 1) / 100000,
644             "Swap amount cannot be lower than 0.001% total supply."
645         );
646         require(
647             newAmount <= (totalSupply() * 5) / 1000,
648             "Swap amount cannot be higher than 0.5% total supply."
649         );
650         swapTokensAtAmount = newAmount;
651         return true;
652     }
653 	
654     function excludeFromMaxTransaction(address updAds, bool isEx)
655         public
656         onlyOwner
657     {
658         _isExcludedMaxTransactionAmount[updAds] = isEx;
659     }
660 
661     // only use to disable contract sales if absolutely necessary (emergency use only)
662     function updateSwapEnabled(bool enabled) external onlyOwner {
663         swapEnabled = enabled;
664     }
665 
666     function excludeFromFees(address account, bool excluded) public onlyOwner {
667         _isExcludedFromFees[account] = excluded;
668         emit ExcludeFromFees(account, excluded);
669     }
670 
671     function setAutomatedMarketMakerPair(address pair, bool value)
672         public
673         onlyOwner
674     {
675         require(
676             pair != uniswapV2Pair,
677             "The pair cannot be removed from automatedMarketMakerPairs"
678         );
679 
680         _setAutomatedMarketMakerPair(pair, value);
681     }
682 
683     function _setAutomatedMarketMakerPair(address pair, bool value) private {
684         automatedMarketMakerPairs[pair] = value;
685 
686         emit SetAutomatedMarketMakerPair(pair, value);
687     }
688 
689     function isExcludedFromFees(address account) public view returns (bool) {
690         return _isExcludedFromFees[account];
691     }
692 
693     function _transfer(
694         address from,
695         address to,
696         uint256 amount
697     ) internal override {
698         require(from != address(0), "ERC20: transfer from the zero address");
699         require(to != address(0), "ERC20: transfer to the zero address");
700 
701         if (amount == 0) {
702             super._transfer(from, to, 0);
703             return;
704         }
705 
706         if (limitsInEffect) {
707             if (
708                 from != owner() &&
709                 to != owner() &&
710                 to != address(0) &&
711                 to != address(0xdead) &&
712                 !swapping
713             ) {
714                 if (!tradingActive) {
715                     require(
716                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
717                         "Trading is not active."
718                     );
719                 }
720 
721                 //when buy
722                 if (
723                     automatedMarketMakerPairs[from] &&
724                     !_isExcludedMaxTransactionAmount[to]
725                 ) {
726                     require(
727                         amount <= maxTransactionAmount,
728                         "Buy transfer amount exceeds the maxTransactionAmount."
729                     );
730                     require(
731                         amount + balanceOf(to) <= maxWallet,
732                         "Max wallet exceeded"
733                     );
734                 }
735                 //when sell
736                 else if (
737                     automatedMarketMakerPairs[to] &&
738                     !_isExcludedMaxTransactionAmount[from]
739                 ) {
740                     require(
741                         amount <= maxTransactionAmount,
742                         "Sell transfer amount exceeds the maxTransactionAmount."
743                     );
744                 } else if (!_isExcludedMaxTransactionAmount[to]) {
745                     require(
746                         amount + balanceOf(to) <= maxWallet,
747                         "Max wallet exceeded"
748                     );
749                 }
750             }
751         }
752 
753         uint256 contractTokenBalance = balanceOf(address(this));
754 
755         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
756 
757         if (
758             canSwap &&
759             swapEnabled &&
760             !swapping &&
761             !automatedMarketMakerPairs[from] &&
762             !_isExcludedFromFees[from] &&
763             !_isExcludedFromFees[to]
764         ) {
765             swapping = true;
766 
767             swapBack();
768 
769             swapping = false;
770         }
771 
772         bool takeFee = !swapping;
773 
774         // if any account belongs to _isExcludedFromFee account then remove the fee
775         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
776             takeFee = false;
777         }
778 
779         uint256 fees = 0;
780         // only take fees on buys/sells, do not take on wallet transfers
781         if (takeFee) {
782             // on sell
783             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
784                 fees = amount.mul(sellTotalFees).div(100);
785                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
786                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;                
787             }
788             // on buy
789             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
790                 fees = amount.mul(buyTotalFees).div(100);
791                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
792                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
793             }
794 
795             if (fees > 0) {
796                 super._transfer(from, address(this), fees);
797             }
798 
799             amount -= fees;
800         }
801 
802         super._transfer(from, to, amount);
803     }
804 
805     function swapTokensForEth(uint256 tokenAmount) private {
806         // generate the uniswap pair path of token -> weth
807         address[] memory path = new address[](2);
808         path[0] = address(this);
809         path[1] = uniswapV2Router.WETH();
810 
811         _approve(address(this), address(uniswapV2Router), tokenAmount);
812 
813         // make the swap
814         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
815             tokenAmount,
816             0, // accept any amount of ETH
817             path,
818             address(this),
819             block.timestamp
820         );
821     }
822 
823     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
824         // approve token transfer to cover all possible scenarios
825         _approve(address(this), address(uniswapV2Router), tokenAmount);
826 
827         // add the liquidity
828         uniswapV2Router.addLiquidityETH{value: ethAmount}(
829             address(this),
830             tokenAmount,
831             0, // slippage is unavoidable
832             0, // slippage is unavoidable
833             devWallet,
834             block.timestamp
835         );
836     }
837 
838     function swapBack() private {
839         uint256 contractBalance = balanceOf(address(this));
840         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
841         bool success;
842 
843         if (contractBalance == 0 || totalTokensToSwap == 0) {
844             return;
845         }
846 
847         if (contractBalance > swapTokensAtAmount * 20) {
848             contractBalance = swapTokensAtAmount * 20;
849         }
850 
851         // Halve the amount of liquidity tokens
852         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
853         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
854 
855         uint256 initialETHBalance = address(this).balance;
856 
857         swapTokensForEth(amountToSwapForETH);
858 
859         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
860 	
861         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
862 
863         uint256 ethForLiquidity = ethBalance - ethForMarketing;
864 
865         tokensForLiquidity = 0;
866         tokensForMarketing = 0;
867 
868         if (liquidityTokens > 0 && ethForLiquidity > 0) {
869             addLiquidity(liquidityTokens, ethForLiquidity);
870             emit SwapAndLiquify(
871                 amountToSwapForETH,
872                 ethForLiquidity,
873                 tokensForLiquidity
874             );
875         }
876 
877         (success, ) = address(devWallet).call{value: address(this).balance}("");
878     }
879 
880 }