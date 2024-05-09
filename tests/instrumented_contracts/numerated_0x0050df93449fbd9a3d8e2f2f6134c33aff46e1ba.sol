1 /**
2 
3 Website:  https://shibion.com/
4 Telegram: https://t.me/Shibion_Official
5 Twitter:  https://twitter.com/shibiontoken
6 Medium:   https://medium.com/@shibiontoken/shibion-7f2f44f6f1f0
7 
8 **/
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
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
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     function renounceOwnership() public virtual onlyOwner {
43         _transferOwnership(address(0));
44     }
45 
46     function transferOwnership(address newOwner) public virtual onlyOwner {
47         require(newOwner != address(0), "Ownable: new owner is the zero address");
48         _transferOwnership(newOwner);
49     }
50 
51     function _transferOwnership(address newOwner) internal virtual {
52         address oldOwner = _owner;
53         _owner = newOwner;
54         emit OwnershipTransferred(oldOwner, newOwner);
55     }
56 }
57 
58 interface IERC20 {
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address account) external view returns (uint256);
63 
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 interface IERC20Metadata is IERC20 {
82 
83     function name() external view returns (string memory);
84 
85     function symbol() external view returns (string memory);
86 
87     function decimals() external view returns (uint8);
88 }
89 
90 contract ERC20 is Context, IERC20, IERC20Metadata {
91     mapping(address => uint256) private _balances;
92 
93     mapping(address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99 
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view virtual override returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     function balanceOf(address account) public view virtual override returns (uint256) {
122         return _balances[account];
123     }
124 
125     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
126         _transfer(_msgSender(), recipient, amount);
127         return true;
128     }
129 
130     function allowance(address owner, address spender) public view virtual override returns (uint256) {
131         return _allowances[owner][spender];
132     }
133 
134     function approve(address spender, uint256 amount) public virtual override returns (bool) {
135         _approve(_msgSender(), spender, amount);
136         return true;
137     }
138 
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) public virtual override returns (bool) {
144         _transfer(sender, recipient, amount);
145 
146         uint256 currentAllowance = _allowances[sender][_msgSender()];
147         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
148         unchecked {
149             _approve(sender, _msgSender(), currentAllowance - amount);
150         }
151 
152         return true;
153     }
154 
155     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
156         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
157         return true;
158     }
159 
160     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
161         uint256 currentAllowance = _allowances[_msgSender()][spender];
162         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
163         unchecked {
164             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
165         }
166 
167         return true;
168     }
169 
170     function _transfer(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) internal virtual {
175         require(sender != address(0), "ERC20: transfer from the zero address");
176         require(recipient != address(0), "ERC20: transfer to the zero address");
177 
178         _beforeTokenTransfer(sender, recipient, amount);
179 
180         uint256 senderBalance = _balances[sender];
181         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
182         unchecked {
183             _balances[sender] = senderBalance - amount;
184         }
185         _balances[recipient] += amount;
186 
187         emit Transfer(sender, recipient, amount);
188 
189         _afterTokenTransfer(sender, recipient, amount);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194 
195         _beforeTokenTransfer(address(0), account, amount);
196 
197         _totalSupply += amount;
198         _balances[account] += amount;
199         emit Transfer(address(0), account, amount);
200 
201         _afterTokenTransfer(address(0), account, amount);
202     }
203 
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207         _beforeTokenTransfer(account, address(0), amount);
208 
209         uint256 accountBalance = _balances[account];
210         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
211         unchecked {
212             _balances[account] = accountBalance - amount;
213         }
214         _totalSupply -= amount;
215 
216         emit Transfer(account, address(0), amount);
217 
218         _afterTokenTransfer(account, address(0), amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _beforeTokenTransfer(
234         address from,
235         address to,
236         uint256 amount
237     ) internal virtual {}
238 
239     function _afterTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 }
245 
246 library SafeMath {
247 
248     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             uint256 c = a + b;
251             if (c < a) return (false, 0);
252             return (true, c);
253         }
254     }
255 
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262 
263     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             if (a == 0) return (true, 0);
266             uint256 c = a * b;
267             if (c / a != b) return (false, 0);
268             return (true, c);
269         }
270     }
271 
272     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b == 0) return (false, 0);
275             return (true, a / b);
276         }
277     }
278 
279     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (b == 0) return (false, 0);
282             return (true, a % b);
283         }
284     }
285 
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a + b;
288     }
289 
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a - b;
292     }
293 
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a * b;
296     }
297 
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a / b;
300     }
301 
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a % b;
304     }
305 
306     function sub(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b <= a, errorMessage);
313             return a - b;
314         }
315     }
316 
317     function div(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         unchecked {
323             require(b > 0, errorMessage);
324             return a / b;
325         }
326     }
327 
328     function mod(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b > 0, errorMessage);
335             return a % b;
336         }
337     }
338 }
339 
340 interface IUniswapV2Factory {
341     event PairCreated(
342         address indexed token0,
343         address indexed token1,
344         address pair,
345         uint256
346     );
347 
348     function feeTo() external view returns (address);
349 
350     function feeToSetter() external view returns (address);
351 
352     function getPair(address tokenA, address tokenB)
353         external
354         view
355         returns (address pair);
356 
357     function allPairs(uint256) external view returns (address pair);
358 
359     function allPairsLength() external view returns (uint256);
360 
361     function createPair(address tokenA, address tokenB)
362         external
363         returns (address pair);
364 
365     function setFeeTo(address) external;
366 
367     function setFeeToSetter(address) external;
368 }
369 
370 interface IUniswapV2Pair {
371     event Approval(
372         address indexed owner,
373         address indexed spender,
374         uint256 value
375     );
376     event Transfer(address indexed from, address indexed to, uint256 value);
377 
378     function name() external pure returns (string memory);
379 
380     function symbol() external pure returns (string memory);
381 
382     function decimals() external pure returns (uint8);
383 
384     function totalSupply() external view returns (uint256);
385 
386     function balanceOf(address owner) external view returns (uint256);
387 
388     function allowance(address owner, address spender)
389         external
390         view
391         returns (uint256);
392 
393     function approve(address spender, uint256 value) external returns (bool);
394 
395     function transfer(address to, uint256 value) external returns (bool);
396 
397     function transferFrom(
398         address from,
399         address to,
400         uint256 value
401     ) external returns (bool);
402 
403     function DOMAIN_SEPARATOR() external view returns (bytes32);
404 
405     function PERMIT_TYPEHASH() external pure returns (bytes32);
406 
407     function nonces(address owner) external view returns (uint256);
408 
409     function permit(
410         address owner,
411         address spender,
412         uint256 value,
413         uint256 deadline,
414         uint8 v,
415         bytes32 r,
416         bytes32 s
417     ) external;
418 
419     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
420     event Burn(
421         address indexed sender,
422         uint256 amount0,
423         uint256 amount1,
424         address indexed to
425     );
426     event Swap(
427         address indexed sender,
428         uint256 amount0In,
429         uint256 amount1In,
430         uint256 amount0Out,
431         uint256 amount1Out,
432         address indexed to
433     );
434     event Sync(uint112 reserve0, uint112 reserve1);
435 
436     function MINIMUM_LIQUIDITY() external pure returns (uint256);
437 
438     function factory() external view returns (address);
439 
440     function token0() external view returns (address);
441 
442     function token1() external view returns (address);
443 
444     function getReserves()
445         external
446         view
447         returns (
448             uint112 reserve0,
449             uint112 reserve1,
450             uint32 blockTimestampLast
451         );
452 
453     function price0CumulativeLast() external view returns (uint256);
454 
455     function price1CumulativeLast() external view returns (uint256);
456 
457     function kLast() external view returns (uint256);
458 
459     function mint(address to) external returns (uint256 liquidity);
460 
461     function burn(address to)
462         external
463         returns (uint256 amount0, uint256 amount1);
464 
465     function swap(
466         uint256 amount0Out,
467         uint256 amount1Out,
468         address to,
469         bytes calldata data
470     ) external;
471 
472     function skim(address to) external;
473 
474     function sync() external;
475 
476     function initialize(address, address) external;
477 }
478 
479 interface IUniswapV2Router02 {
480     function factory() external pure returns (address);
481 
482     function WETH() external pure returns (address);
483 
484     function addLiquidity(
485         address tokenA,
486         address tokenB,
487         uint256 amountADesired,
488         uint256 amountBDesired,
489         uint256 amountAMin,
490         uint256 amountBMin,
491         address to,
492         uint256 deadline
493     )
494         external
495         returns (
496             uint256 amountA,
497             uint256 amountB,
498             uint256 liquidity
499         );
500 
501     function addLiquidityETH(
502         address token,
503         uint256 amountTokenDesired,
504         uint256 amountTokenMin,
505         uint256 amountETHMin,
506         address to,
507         uint256 deadline
508     )
509         external
510         payable
511         returns (
512             uint256 amountToken,
513             uint256 amountETH,
514             uint256 liquidity
515         );
516 
517     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
518         uint256 amountIn,
519         uint256 amountOutMin,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external;
524 
525     function swapExactETHForTokensSupportingFeeOnTransferTokens(
526         uint256 amountOutMin,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external payable;
531 
532     function swapExactTokensForETHSupportingFeeOnTransferTokens(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external;
539 }
540 
541 contract Shibion is ERC20, Ownable {
542     using SafeMath for uint256;
543 
544     IUniswapV2Router02 public immutable uniswapV2Router;
545     address public immutable uniswapV2Pair;
546     address public constant deadAddress = address(0xdead);
547     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
548 
549     bool private swapping;
550 
551     address public mktngWallet;
552     address public devWallet;
553     address public liqWallet;
554     address public opsWallet;
555 
556     uint256 public maxTransactionAmount;
557     uint256 public swapTokensAtAmount;
558     uint256 public maxWallet;
559 
560     bool public limitsInEffect = true;
561     bool public tradingActive = false;
562     bool public swapEnabled = false;
563 
564     // Anti-bot and anti-whale mappings and variables
565     mapping(address => uint256) private _holderLastTransferTimestamp;
566     bool public transferDelayEnabled = true;
567     uint256 private launchBlock;
568     uint256 private deadBlocks;
569     mapping(address => bool) public blocked;
570 
571     uint256 public buyTotalFees;
572     uint256 public buyMktngFee;
573     uint256 public buyLiquidityFee;
574     uint256 public buyDevFee;
575     uint256 public buyOpsFee;
576 
577     uint256 public sellTotalFees;
578     uint256 public sellMktngFee;
579     uint256 public sellLiquidityFee;
580     uint256 public sellDevFee;
581     uint256 public sellOpsFee;
582 
583     uint256 public tokensForMarketing;
584     uint256 public tokensForLiquidity;
585     uint256 public tokensForDev;
586     uint256 public tokensForOps;
587 
588     mapping(address => bool) private _isExcludedFromFees;
589     mapping(address => bool) public _isExcludedMaxTransactionAmount;
590 
591     mapping(address => bool) public automatedMarketMakerPairs;
592 
593     event UpdateUniswapV2Router(
594         address indexed newAddress,
595         address indexed oldAddress
596     );
597 
598     event ExcludeFromFees(address indexed account, bool isExcluded);
599 
600     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
601 
602     event mktngWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607     event devWalletUpdated(
608         address indexed newWallet,
609         address indexed oldWallet
610     );
611 
612     event liqWalletUpdated(
613         address indexed newWallet,
614         address indexed oldWallet
615     );
616 
617     event opsWalletUpdated(
618         address indexed newWallet,
619         address indexed oldWallet
620     );
621 
622     event SwapAndLiquify(
623         uint256 tokensSwapped,
624         uint256 ethReceived,
625         uint256 tokensIntoLiquidity
626     );
627 
628     constructor() ERC20("Shibion", "Shibion") {
629         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
630 
631         excludeFromMaxTransaction(address(_uniswapV2Router), true);
632         uniswapV2Router = _uniswapV2Router;
633 
634         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
635             .createPair(address(this), _uniswapV2Router.WETH());
636         excludeFromMaxTransaction(address(uniswapV2Pair), true);
637         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
638 
639         // launch buy fees
640         uint256 _buyMktngFee = 1;
641         uint256 _buyLiquidityFee = 1;
642         uint256 _buyDevFee = 4;
643         uint256 _buyOpsFee = 4;
644         
645         // launch sell fees
646         uint256 _sellMktngFee = 0;
647         uint256 _sellLiquidityFee = 0;
648         uint256 _sellDevFee = 30;
649         uint256 _sellOpsFee = 30;
650 
651         uint256 totalSupply = 100_000_000 * 1e18;
652 
653         maxTransactionAmount = 3_000_000 * 1e18; // 3% max txn at launch
654         maxWallet = 3_000_000 * 1e18; // 3% max wallet at launch
655         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
656 
657         buyMktngFee = _buyMktngFee;
658         buyLiquidityFee = _buyLiquidityFee;
659         buyDevFee = _buyDevFee;
660         buyOpsFee = _buyOpsFee;
661         buyTotalFees = buyMktngFee + buyLiquidityFee + buyDevFee + buyOpsFee;
662 
663         sellMktngFee = _sellMktngFee;
664         sellLiquidityFee = _sellLiquidityFee;
665         sellDevFee = _sellDevFee;
666         sellOpsFee = _sellOpsFee;
667         sellTotalFees = sellMktngFee + sellLiquidityFee + sellDevFee + sellOpsFee;
668 
669         mktngWallet = address(0x03bD9Fd244b2Da29E9D20095295FEF40b521613F); 
670         devWallet = address(0xA36cEf0afE9BD36Fbc6cc04f1fa15044ca8E843A); 
671         liqWallet = address(0x90d407181b28B33d43cc1Ce389095b24fEE1D0E6); 
672         opsWallet = address(0xe6827B0B75d963328Db1FB3E46Bef2B7efF980a3);
673 
674         // exclude from paying fees or having max transaction amount
675         excludeFromFees(owner(), true);
676         excludeFromFees(address(this), true);
677         excludeFromFees(address(0xdead), true);
678 
679         excludeFromMaxTransaction(owner(), true);
680         excludeFromMaxTransaction(address(this), true);
681         excludeFromMaxTransaction(address(0xdead), true);
682 
683         _mint(msg.sender, totalSupply);
684     }
685 
686     receive() external payable {}
687 
688     function enableTrading(uint256 _deadBlocks) external onlyOwner {
689         require(!tradingActive, "Token launched");
690         tradingActive = true;
691         launchBlock = block.number;
692         swapEnabled = true;
693         deadBlocks = _deadBlocks;
694     }
695 
696     // remove limits after token is stable
697     function removeLimits() external onlyOwner returns (bool) {
698         limitsInEffect = false;
699         return true;
700     }
701 
702     // disable Transfer delay - cannot be reenabled
703     function disableTransferDelay() external onlyOwner returns (bool) {
704         transferDelayEnabled = false;
705         return true;
706     }
707 
708     // change the minimum amount of tokens to sell from fees
709     function updateSwapTokensAtAmount(uint256 newAmount)
710         external
711         onlyOwner
712         returns (bool)
713     {
714         require(
715             newAmount >= (totalSupply() * 1) / 100000,
716             "Swap amount cannot be lower than 0.001% total supply."
717         );
718         require(
719             newAmount <= (totalSupply() * 5) / 1000,
720             "Swap amount cannot be higher than 0.5% total supply."
721         );
722         swapTokensAtAmount = newAmount;
723         return true;
724     }
725 
726     function updateMaxTransaction(uint256 newNum) external onlyOwner {
727         require(
728             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
729             "Cannot set maxTransactionAmount lower than 0.1%"
730         );
731         maxTransactionAmount = newNum * (10**18);
732     }
733 
734     function updateMaxWallet(uint256 newNum) external onlyOwner {
735         require(
736             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
737             "Cannot set maxWallet lower than 0.5%"
738         );
739         maxWallet = newNum * (10**18);
740     }
741 
742     function excludeFromMaxTransaction(address updAds, bool isEx)
743         public
744         onlyOwner
745     {
746         _isExcludedMaxTransactionAmount[updAds] = isEx;
747     }
748 
749     // only use to disable contract sales if absolutely necessary (emergency use only)
750     function updateSwapEnabled(bool enabled) external onlyOwner {
751         swapEnabled = enabled;
752     }
753 
754     function updateBuyFees(
755         uint256 _marketingFee,
756         uint256 _liquidityFee,
757         uint256 _devFee,
758         uint256 _opsFee
759     ) external onlyOwner {
760         buyMktngFee = _marketingFee;
761         buyLiquidityFee = _liquidityFee;
762         buyDevFee = _devFee;
763         buyOpsFee = _opsFee;
764         buyTotalFees = buyMktngFee + buyLiquidityFee + buyDevFee + buyOpsFee;
765         require(buyTotalFees <= 99);
766     }
767 
768     function updateSellFees(
769         uint256 _marketingFee,
770         uint256 _liquidityFee,
771         uint256 _devFee,
772         uint256 _opsFee
773     ) external onlyOwner {
774         sellMktngFee = _marketingFee;
775         sellLiquidityFee = _liquidityFee;
776         sellDevFee = _devFee;
777         sellOpsFee = _opsFee;
778         sellTotalFees = sellMktngFee + sellLiquidityFee + sellDevFee + sellOpsFee;
779         require(sellTotalFees <= 99); 
780     }
781 
782     function excludeFromFees(address account, bool excluded) public onlyOwner {
783         _isExcludedFromFees[account] = excluded;
784         emit ExcludeFromFees(account, excluded);
785     }
786 
787     function setAutomatedMarketMakerPair(address pair, bool value)
788         public
789         onlyOwner
790     {
791         require(
792             pair != uniswapV2Pair,
793             "The pair cannot be removed from automatedMarketMakerPairs"
794         );
795 
796         _setAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function _setAutomatedMarketMakerPair(address pair, bool value) private {
800         automatedMarketMakerPairs[pair] = value;
801 
802         emit SetAutomatedMarketMakerPair(pair, value);
803     }
804 
805     function updatemktngWallet(address newmktngWallet) external onlyOwner {
806         emit mktngWalletUpdated(newmktngWallet, mktngWallet);
807         mktngWallet = newmktngWallet;
808     }
809 
810     function updateDevWallet(address newWallet) external onlyOwner {
811         emit devWalletUpdated(newWallet, devWallet);
812         devWallet = newWallet;
813     }
814 
815     function updateopsWallet(address newWallet) external onlyOwner{
816         emit opsWalletUpdated(newWallet, opsWallet);
817         opsWallet = newWallet;
818     }
819 
820     function updateLiqWallet(address newLiqWallet) external onlyOwner {
821         emit liqWalletUpdated(newLiqWallet, liqWallet);
822         liqWallet = newLiqWallet;
823     }
824 
825     function isExcludedFromFees(address account) public view returns (bool) {
826         return _isExcludedFromFees[account];
827     }
828 
829     event BoughtEarly(address indexed sniper);
830 
831     function _transfer(
832         address from,
833         address to,
834         uint256 amount
835     ) internal override {
836         require(from != address(0), "ERC20: transfer from the zero address");
837         require(to != address(0), "ERC20: transfer to the zero address");
838         require(!blocked[from], "Sniper blocked");
839 
840         if (amount == 0) {
841             super._transfer(from, to, 0);
842             return;
843         }
844 
845         if (limitsInEffect) {
846             if (
847                 from != owner() &&
848                 to != owner() &&
849                 to != address(0) &&
850                 to != address(0xdead) &&
851                 !swapping
852             ) {
853                 if (!tradingActive) {
854                     require(
855                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
856                         "Trading is not active."
857                     );
858                 }
859 
860                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
861                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
862                     blocked[to] = true;
863                     emit BoughtEarly(to);
864                 }
865 
866                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
867                 if (transferDelayEnabled) {
868                     if (
869                         to != owner() &&
870                         to != address(uniswapV2Router) &&
871                         to != address(uniswapV2Pair)
872                     ) {
873                         require(
874                             _holderLastTransferTimestamp[tx.origin] <
875                                 block.number,
876                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
877                         );
878                         _holderLastTransferTimestamp[tx.origin] = block.number;
879                     }
880                 }
881 
882                 //when buy
883                 if (
884                     automatedMarketMakerPairs[from] &&
885                     !_isExcludedMaxTransactionAmount[to]
886                 ) {
887                     require(
888                         amount <= maxTransactionAmount,
889                         "Buy transfer amount exceeds the maxTransactionAmount."
890                     );
891                     require(
892                         amount + balanceOf(to) <= maxWallet,
893                         "Max wallet exceeded"
894                     );
895                 }
896                 //when sell
897                 else if (
898                     automatedMarketMakerPairs[to] &&
899                     !_isExcludedMaxTransactionAmount[from]
900                 ) {
901                     require(
902                         amount <= maxTransactionAmount,
903                         "Sell transfer amount exceeds the maxTransactionAmount."
904                     );
905                 } else if (!_isExcludedMaxTransactionAmount[to]) {
906                     require(
907                         amount + balanceOf(to) <= maxWallet,
908                         "Max wallet exceeded"
909                     );
910                 }
911             }
912         }
913 
914         uint256 contractTokenBalance = balanceOf(address(this));
915 
916         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
917 
918         if (
919             canSwap &&
920             swapEnabled &&
921             !swapping &&
922             !automatedMarketMakerPairs[from] &&
923             !_isExcludedFromFees[from] &&
924             !_isExcludedFromFees[to]
925         ) {
926             swapping = true;
927 
928             swapBack();
929 
930             swapping = false;
931         }
932 
933         bool takeFee = !swapping;
934 
935         // if any account belongs to _isExcludedFromFee account then remove the fee
936         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
937             takeFee = false;
938         }
939 
940         uint256 fees = 0;
941         // only take fees on buys/sells, do not take on wallet transfers
942         if (takeFee) {
943             // on sell
944             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
945                 fees = amount.mul(sellTotalFees).div(100);
946                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
947                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
948                 tokensForMarketing += (fees * sellMktngFee) / sellTotalFees;
949                 tokensForOps += (fees * sellOpsFee) / sellTotalFees;
950             }
951             // on buy
952             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
953                 fees = amount.mul(buyTotalFees).div(100);
954                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
955                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
956                 tokensForMarketing += (fees * buyMktngFee) / buyTotalFees;
957                 tokensForOps += (fees * buyOpsFee) / buyTotalFees;
958             }
959 
960             if (fees > 0) {
961                 super._transfer(from, address(this), fees);
962             }
963 
964             amount -= fees;
965         }
966 
967         super._transfer(from, to, amount);
968     }
969 
970     function swapTokensForEth(uint256 tokenAmount) private {
971         // generate the uniswap pair path of token -> weth
972         address[] memory path = new address[](2);
973         path[0] = address(this);
974         path[1] = uniswapV2Router.WETH();
975 
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         // make the swap
979         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
980             tokenAmount,
981             0, // accept any amount of ETH
982             path,
983             address(this),
984             block.timestamp
985         );
986     }
987 
988     function rekSnipers(address[] calldata blockees, bool shouldBlock) external onlyOwner {
989         for(uint256 i = 0;i<blockees.length;i++){
990             address blockee = blockees[i];
991             if(blockee != address(this) && 
992                blockee != routerCA && 
993                blockee != address(uniswapV2Pair))
994                 blocked[blockee] = shouldBlock;
995         }
996     }
997 
998     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
999         // approve token transfer to cover all possible scenarios
1000         _approve(address(this), address(uniswapV2Router), tokenAmount);
1001 
1002         // add the liquidity
1003         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1004             address(this),
1005             tokenAmount,
1006             0, // slippage is unavoidable
1007             0, // slippage is unavoidable
1008             liqWallet,
1009             block.timestamp
1010         );
1011     }
1012 
1013     function swapBack() private {
1014         uint256 contractBalance = balanceOf(address(this));
1015         uint256 totalTokensToSwap = tokensForLiquidity +
1016             tokensForMarketing +
1017             tokensForDev +
1018             tokensForOps;
1019         bool success;
1020 
1021         if (contractBalance == 0 || totalTokensToSwap == 0) {
1022             return;
1023         }
1024 
1025         if (contractBalance > swapTokensAtAmount * 20) {
1026             contractBalance = swapTokensAtAmount * 20;
1027         }
1028 
1029         // Halve the amount of liquidity tokens
1030         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1031         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1032 
1033         uint256 initialETHBalance = address(this).balance;
1034 
1035         swapTokensForEth(amountToSwapForETH);
1036 
1037         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1038 
1039         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1040         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1041         uint256 ethForOps = ethBalance.mul(tokensForOps).div(totalTokensToSwap);
1042 
1043         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForOps;
1044 
1045         tokensForLiquidity = 0;
1046         tokensForMarketing = 0;
1047         tokensForDev = 0;
1048         tokensForOps = 0;
1049 
1050         (success, ) = address(devWallet).call{value: ethForDev}("");
1051 
1052         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1053             addLiquidity(liquidityTokens, ethForLiquidity);
1054             emit SwapAndLiquify(
1055                 amountToSwapForETH,
1056                 ethForLiquidity,
1057                 tokensForLiquidity
1058             );
1059         }
1060         (success, ) = address(opsWallet).call{value: ethForOps}("");
1061         (success, ) = address(mktngWallet).call{value: address(this).balance}("");
1062     }
1063 }