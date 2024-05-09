1 /**
2 
3 Combining cute furry bunnies racing with blockchain technology.
4 The ultimate degen level. Let the Bunny Race BEGIN!
5 
6 https://t.me/bunnyraceco
7 https://bunnyrace.co
8 https://www.twitter.com/bunnyraceco
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
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86 
87     function symbol() external view returns (string memory);
88 
89     function decimals() external view returns (uint8);
90 }
91 
92 contract ERC20 is Context, IERC20, IERC20Metadata {
93     mapping(address => uint256) private _balances;
94 
95     mapping(address => mapping(address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101 
102     constructor(string memory name_, string memory symbol_) {
103         _name = name_;
104         _symbol = symbol_;
105     }
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
249 
250     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             uint256 c = a + b;
253             if (c < a) return (false, 0);
254             return (true, c);
255         }
256     }
257 
258     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             if (b > a) return (false, 0);
261             return (true, a - b);
262         }
263     }
264 
265     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
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
405     function DOMAIN_SEPARATOR() external view returns (bytes32);
406 
407     function PERMIT_TYPEHASH() external pure returns (bytes32);
408 
409     function nonces(address owner) external view returns (uint256);
410 
411     function permit(
412         address owner,
413         address spender,
414         uint256 value,
415         uint256 deadline,
416         uint8 v,
417         bytes32 r,
418         bytes32 s
419     ) external;
420 
421     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
422     event Burn(
423         address indexed sender,
424         uint256 amount0,
425         uint256 amount1,
426         address indexed to
427     );
428     event Swap(
429         address indexed sender,
430         uint256 amount0In,
431         uint256 amount1In,
432         uint256 amount0Out,
433         uint256 amount1Out,
434         address indexed to
435     );
436     event Sync(uint112 reserve0, uint112 reserve1);
437 
438     function MINIMUM_LIQUIDITY() external pure returns (uint256);
439 
440     function factory() external view returns (address);
441 
442     function token0() external view returns (address);
443 
444     function token1() external view returns (address);
445 
446     function getReserves()
447         external
448         view
449         returns (
450             uint112 reserve0,
451             uint112 reserve1,
452             uint32 blockTimestampLast
453         );
454 
455     function price0CumulativeLast() external view returns (uint256);
456 
457     function price1CumulativeLast() external view returns (uint256);
458 
459     function kLast() external view returns (uint256);
460 
461     function mint(address to) external returns (uint256 liquidity);
462 
463     function burn(address to)
464         external
465         returns (uint256 amount0, uint256 amount1);
466 
467     function swap(
468         uint256 amount0Out,
469         uint256 amount1Out,
470         address to,
471         bytes calldata data
472     ) external;
473 
474     function skim(address to) external;
475 
476     function sync() external;
477 
478     function initialize(address, address) external;
479 }
480 
481 interface IUniswapV2Router02 {
482     function factory() external pure returns (address);
483 
484     function WETH() external pure returns (address);
485 
486     function addLiquidity(
487         address tokenA,
488         address tokenB,
489         uint256 amountADesired,
490         uint256 amountBDesired,
491         uint256 amountAMin,
492         uint256 amountBMin,
493         address to,
494         uint256 deadline
495     )
496         external
497         returns (
498             uint256 amountA,
499             uint256 amountB,
500             uint256 liquidity
501         );
502 
503     function addLiquidityETH(
504         address token,
505         uint256 amountTokenDesired,
506         uint256 amountTokenMin,
507         uint256 amountETHMin,
508         address to,
509         uint256 deadline
510     )
511         external
512         payable
513         returns (
514             uint256 amountToken,
515             uint256 amountETH,
516             uint256 liquidity
517         );
518 
519     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
520         uint256 amountIn,
521         uint256 amountOutMin,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external;
526 
527     function swapExactETHForTokensSupportingFeeOnTransferTokens(
528         uint256 amountOutMin,
529         address[] calldata path,
530         address to,
531         uint256 deadline
532     ) external payable;
533 
534     function swapExactTokensForETHSupportingFeeOnTransferTokens(
535         uint256 amountIn,
536         uint256 amountOutMin,
537         address[] calldata path,
538         address to,
539         uint256 deadline
540     ) external;
541 }
542 
543 contract BUNNY is ERC20, Ownable {
544     using SafeMath for uint256;
545 
546     IUniswapV2Router02 public immutable uniswapV2Router;
547     address public immutable uniswapV2Pair;
548     address public constant deadAddress = address(0xdead);
549     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
550 
551     bool private swapping;
552 
553     address public marketingwallet;
554     address public devWallet;
555     address public liqWallet;
556     address public operationsWallet;
557 
558     uint256 public maxTransactionAmount;
559     uint256 public swapTokensAtAmount;
560     uint256 public maxWallet;
561 
562     bool public limitsInEffect = true;
563     bool public tradingActive = false;
564     bool public swapEnabled = false;
565 
566     // Anti-bot and anti-whale mappings and variables
567     mapping(address => uint256) private _holderLastTransferTimestamp;
568     bool public transferDelayEnabled = true;
569     uint256 private launchBlock;
570     uint256 private deadBlocks;
571     mapping(address => bool) public blocked;
572 
573     uint256 public buyTotalFees;
574     uint256 public buyMarkFee;
575     uint256 public buyLiquidityFee;
576     uint256 public buyDevFee;
577     uint256 public buyOperationsFee;
578 
579     uint256 public sellTotalFees;
580     uint256 public sellMarkFee;
581     uint256 public sellLiquidityFee;
582     uint256 public sellDevFee;
583     uint256 public sellOperationsFee;
584 
585     uint256 public tokensForMark;
586     uint256 public tokensForLiquidity;
587     uint256 public tokensForDev;
588     uint256 public tokensForOperations;
589 
590     mapping(address => bool) private _isExcludedFromFees;
591     mapping(address => bool) public _isExcludedMaxTransactionAmount;
592 
593     mapping(address => bool) public automatedMarketMakerPairs;
594 
595     event UpdateUniswapV2Router(
596         address indexed newAddress,
597         address indexed oldAddress
598     );
599 
600     event ExcludeFromFees(address indexed account, bool isExcluded);
601 
602     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
603 
604     event mktWalletUpdated(
605         address indexed newWallet,
606         address indexed oldWallet
607     );
608 
609     event devWalletUpdated(
610         address indexed newWallet,
611         address indexed oldWallet
612     );
613 
614     event liqWalletUpdated(
615         address indexed newWallet,
616         address indexed oldWallet
617     );
618 
619     event operationsWalletUpdated(
620         address indexed newWallet,
621         address indexed oldWallet
622     );
623 
624     event SwapAndLiquify(
625         uint256 tokensSwapped,
626         uint256 ethReceived,
627         uint256 tokensIntoLiquidity
628     );
629 
630     constructor() ERC20("Bunny Race", "BUNNY") {
631         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
632 
633         excludeFromMaxTransaction(address(_uniswapV2Router), true);
634         uniswapV2Router = _uniswapV2Router;
635 
636         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
637             .createPair(address(this), _uniswapV2Router.WETH());
638         excludeFromMaxTransaction(address(uniswapV2Pair), true);
639         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
640 
641         // launch buy fees
642         uint256 _buyMarkFee = 20;
643         uint256 _buyLiquidityFee = 0;
644         uint256 _buyDevFee = 10;
645         uint256 _buyOperationsFee = 0;
646         
647         // launch sell fees
648         uint256 _sellMarkFee = 20;
649         uint256 _sellLiquidityFee = 0;
650         uint256 _sellDevFee = 10;
651         uint256 _sellOperationsFee = 0;
652 
653         uint256 totalSupply = 1_000_000 * 1e18;
654 
655         maxTransactionAmount = 20_000 * 1e18; // 2% max txn at launch
656         maxWallet = 20_000 * 1e18; // 2% max wallet at launch
657         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.05% swap wallet
658 
659         buyMarkFee = _buyMarkFee;
660         buyLiquidityFee = _buyLiquidityFee;
661         buyDevFee = _buyDevFee;
662         buyOperationsFee = _buyOperationsFee;
663         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
664 
665         sellMarkFee = _sellMarkFee;
666         sellLiquidityFee = _sellLiquidityFee;
667         sellDevFee = _sellDevFee;
668         sellOperationsFee = _sellOperationsFee;
669         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
670 
671         marketingwallet = address(0x42A798Ef2651140dfF2CC4b21352279f5B90BCA8); 
672         devWallet = address(0x3F2Dddc6d625a7B27e702a242bD865C09D81B756); 
673         liqWallet = address(0x3F2Dddc6d625a7B27e702a242bD865C09D81B756); 
674         operationsWallet = address(0x3F2Dddc6d625a7B27e702a242bD865C09D81B756);
675 
676         // exclude from paying fees or having max transaction amount
677         excludeFromFees(owner(), true);
678         excludeFromFees(address(this), true);
679         excludeFromFees(address(0xdead), true);
680 
681         excludeFromMaxTransaction(owner(), true);
682         excludeFromMaxTransaction(address(this), true);
683         excludeFromMaxTransaction(address(0xdead), true);
684 
685         _mint(msg.sender, totalSupply);
686     }
687 
688     receive() external payable {}
689 
690     function enableTrading(uint256 _deadBlocks) external onlyOwner {
691         require(!tradingActive, "Token launched");
692         tradingActive = true;
693         launchBlock = block.number;
694         swapEnabled = true;
695         deadBlocks = _deadBlocks;
696     }
697 
698     // remove limits after token is stable
699     function removeLimits() external onlyOwner returns (bool) {
700         limitsInEffect = false;
701         return true;
702     }
703 
704     // disable Transfer delay - cannot be reenabled
705     function disableTransferDelay() external onlyOwner returns (bool) {
706         transferDelayEnabled = false;
707         return true;
708     }
709 
710     // change the minimum amount of tokens to sell from fees
711     function updateSwapTokensAtAmount(uint256 newAmount)
712         external
713         onlyOwner
714         returns (bool)
715     {
716         require(
717             newAmount >= (totalSupply() * 1) / 100000,
718             "Swap amount cannot be lower than 0.001% total supply."
719         );
720         require(
721             newAmount <= (totalSupply() * 5) / 1000,
722             "Swap amount cannot be higher than 0.5% total supply."
723         );
724         swapTokensAtAmount = newAmount;
725         return true;
726     }
727 
728     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
729         require(
730             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
731             "Cannot set maxTransactionAmount lower than 0.1%"
732         );
733         maxTransactionAmount = newNum * (10**18);
734     }
735 
736     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
737         require(
738             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
739             "Cannot set maxWallet lower than 0.5%"
740         );
741         maxWallet = newNum * (10**18);
742     }
743 
744     function excludeFromMaxTransaction(address updAds, bool isEx)
745         public
746         onlyOwner
747     {
748         _isExcludedMaxTransactionAmount[updAds] = isEx;
749     }
750 
751     // only use to disable contract sales if absolutely necessary (emergency use only)
752     function updateSwapEnabled(bool enabled) external onlyOwner {
753         swapEnabled = enabled;
754     }
755 
756     function updateBuyFees(
757         uint256 _markFee,
758         uint256 _liquidityFee,
759         uint256 _devFee,
760         uint256 _operationsFee
761     ) external onlyOwner {
762         buyMarkFee = _markFee;
763         buyLiquidityFee = _liquidityFee;
764         buyDevFee = _devFee;
765         buyOperationsFee = _operationsFee;
766         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
767         require(buyTotalFees <= 99);
768     }
769 
770     function updateSellFees(
771         uint256 _markFee,
772         uint256 _liquidityFee,
773         uint256 _devFee,
774         uint256 _operationsFee
775     ) external onlyOwner {
776         sellMarkFee = _markFee;
777         sellLiquidityFee = _liquidityFee;
778         sellDevFee = _devFee;
779         sellOperationsFee = _operationsFee;
780         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
781         require(sellTotalFees <= 99); 
782     }
783 
784     function excludeFromFees(address account, bool excluded) public onlyOwner {
785         _isExcludedFromFees[account] = excluded;
786         emit ExcludeFromFees(account, excluded);
787     }
788 
789     function setAutomatedMarketMakerPair(address pair, bool value)
790         public
791         onlyOwner
792     {
793         require(
794             pair != uniswapV2Pair,
795             "The pair cannot be removed from automatedMarketMakerPairs"
796         );
797 
798         _setAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function _setAutomatedMarketMakerPair(address pair, bool value) private {
802         automatedMarketMakerPairs[pair] = value;
803 
804         emit SetAutomatedMarketMakerPair(pair, value);
805     }
806 
807     function updatemktWallet(address newmktWallet) external onlyOwner {
808         emit mktWalletUpdated(newmktWallet, marketingwallet);
809         marketingwallet = newmktWallet;
810     }
811 
812     function updateDevWallet(address newWallet) external onlyOwner {
813         emit devWalletUpdated(newWallet, devWallet);
814         devWallet = newWallet;
815     }
816 
817     function updateoperationsWallet(address newWallet) external onlyOwner{
818         emit operationsWalletUpdated(newWallet, operationsWallet);
819         operationsWallet = newWallet;
820     }
821 
822     function updateLiqWallet(address newLiqWallet) external onlyOwner {
823         emit liqWalletUpdated(newLiqWallet, liqWallet);
824         liqWallet = newLiqWallet;
825     }
826 
827     function isExcludedFromFees(address account) public view returns (bool) {
828         return _isExcludedFromFees[account];
829     }
830 
831     event BoughtEarly(address indexed sniper);
832 
833     function _transfer(
834         address from,
835         address to,
836         uint256 amount
837     ) internal override {
838         require(from != address(0), "ERC20: transfer from the zero address");
839         require(to != address(0), "ERC20: transfer to the zero address");
840         require(!blocked[from], "Sniper blocked");
841 
842         if (amount == 0) {
843             super._transfer(from, to, 0);
844             return;
845         }
846 
847         if (limitsInEffect) {
848             if (
849                 from != owner() &&
850                 to != owner() &&
851                 to != address(0) &&
852                 to != address(0xdead) &&
853                 !swapping
854             ) {
855                 if (!tradingActive) {
856                     require(
857                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
858                         "Trading is not active."
859                     );
860                 }
861 
862                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
863                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
864                     blocked[to] = true;
865                     emit BoughtEarly(to);
866                 }
867 
868                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
869                 if (transferDelayEnabled) {
870                     if (
871                         to != owner() &&
872                         to != address(uniswapV2Router) &&
873                         to != address(uniswapV2Pair)
874                     ) {
875                         require(
876                             _holderLastTransferTimestamp[tx.origin] <
877                                 block.number,
878                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
879                         );
880                         _holderLastTransferTimestamp[tx.origin] = block.number;
881                     }
882                 }
883 
884                 //when buy
885                 if (
886                     automatedMarketMakerPairs[from] &&
887                     !_isExcludedMaxTransactionAmount[to]
888                 ) {
889                     require(
890                         amount <= maxTransactionAmount,
891                         "Buy transfer amount exceeds the maxTransactionAmount."
892                     );
893                     require(
894                         amount + balanceOf(to) <= maxWallet,
895                         "Max wallet exceeded"
896                     );
897                 }
898                 //when sell
899                 else if (
900                     automatedMarketMakerPairs[to] &&
901                     !_isExcludedMaxTransactionAmount[from]
902                 ) {
903                     require(
904                         amount <= maxTransactionAmount,
905                         "Sell transfer amount exceeds the maxTransactionAmount."
906                     );
907                 } else if (!_isExcludedMaxTransactionAmount[to]) {
908                     require(
909                         amount + balanceOf(to) <= maxWallet,
910                         "Max wallet exceeded"
911                     );
912                 }
913             }
914         }
915 
916         uint256 contractTokenBalance = balanceOf(address(this));
917 
918         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
919 
920         if (
921             canSwap &&
922             swapEnabled &&
923             !swapping &&
924             !automatedMarketMakerPairs[from] &&
925             !_isExcludedFromFees[from] &&
926             !_isExcludedFromFees[to]
927         ) {
928             swapping = true;
929 
930             swapBack();
931 
932             swapping = false;
933         }
934 
935         bool takeFee = !swapping;
936 
937         // if any account belongs to _isExcludedFromFee account then remove the fee
938         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
939             takeFee = false;
940         }
941 
942         uint256 fees = 0;
943         // only take fees on buys/sells, do not take on wallet transfers
944         if (takeFee) {
945             // on sell
946             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
947                 fees = amount.mul(sellTotalFees).div(100);
948                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
949                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
950                 tokensForMark += (fees * sellMarkFee) / sellTotalFees;
951                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
952             }
953             // on buy
954             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
955                 fees = amount.mul(buyTotalFees).div(100);
956                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
957                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
958                 tokensForMark += (fees * buyMarkFee) / buyTotalFees;
959                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
960             }
961 
962             if (fees > 0) {
963                 super._transfer(from, address(this), fees);
964             }
965 
966             amount -= fees;
967         }
968 
969         super._transfer(from, to, amount);
970     }
971 
972     function swapTokensForEth(uint256 tokenAmount) private {
973         // generate the uniswap pair path of token -> weth
974         address[] memory path = new address[](2);
975         path[0] = address(this);
976         path[1] = uniswapV2Router.WETH();
977 
978         _approve(address(this), address(uniswapV2Router), tokenAmount);
979 
980         // make the swap
981         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
982             tokenAmount,
983             0, // accept any amount of ETH
984             path,
985             address(this),
986             block.timestamp
987         );
988     }
989 
990     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
991         for(uint256 i = 0;i<blockees.length;i++){
992             address blockee = blockees[i];
993             if(blockee != address(this) && 
994                blockee != routerCA && 
995                blockee != address(uniswapV2Pair))
996                 blocked[blockee] = shouldBlock;
997         }
998     }
999 
1000     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1001         // approve token transfer to cover all possible scenarios
1002         _approve(address(this), address(uniswapV2Router), tokenAmount);
1003 
1004         // add the liquidity
1005         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1006             address(this),
1007             tokenAmount,
1008             0, // slippage is unavoidable
1009             0, // slippage is unavoidable
1010             liqWallet,
1011             block.timestamp
1012         );
1013     }
1014 
1015     function swapBack() private {
1016         uint256 contractBalance = balanceOf(address(this));
1017         uint256 totalTokensToSwap = tokensForLiquidity +
1018             tokensForMark +
1019             tokensForDev +
1020             tokensForOperations;
1021         bool success;
1022 
1023         if (contractBalance == 0 || totalTokensToSwap == 0) {
1024             return;
1025         }
1026 
1027         if (contractBalance > swapTokensAtAmount * 20) {
1028             contractBalance = swapTokensAtAmount * 20;
1029         }
1030 
1031         // Halve the amount of liquidity tokens
1032         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1033         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1034 
1035         uint256 initialETHBalance = address(this).balance;
1036 
1037         swapTokensForEth(amountToSwapForETH);
1038 
1039         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1040 
1041         uint256 ethForMark = ethBalance.mul(tokensForMark).div(totalTokensToSwap);
1042         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1043         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1044 
1045         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDev - ethForOperations;
1046 
1047         tokensForLiquidity = 0;
1048         tokensForMark = 0;
1049         tokensForDev = 0;
1050         tokensForOperations = 0;
1051 
1052         (success, ) = address(devWallet).call{value: ethForDev}("");
1053 
1054         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1055             addLiquidity(liquidityTokens, ethForLiquidity);
1056             emit SwapAndLiquify(
1057                 amountToSwapForETH,
1058                 ethForLiquidity,
1059                 tokensForLiquidity
1060             );
1061         }
1062         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1063         (success, ) = address(marketingwallet).call{value: address(this).balance}("");
1064     }
1065 }