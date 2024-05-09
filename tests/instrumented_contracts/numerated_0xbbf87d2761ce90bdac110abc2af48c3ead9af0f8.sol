1 /**
2 https://t.me/Xburnportal
3 https://xburn.vip
4 https://twitter.com/xburn_eth
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     function renounceOwnership() public virtual onlyOwner {
41         _transferOwnership(address(0));
42     }
43 
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _transferOwnership(newOwner);
47     }
48 
49     function _transferOwnership(address newOwner) internal virtual {
50         address oldOwner = _owner;
51         _owner = newOwner;
52         emit OwnershipTransferred(oldOwner, newOwner);
53     }
54 }
55 
56 interface IERC20 {
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IERC20Metadata is IERC20 {
80 
81     function name() external view returns (string memory);
82 
83     function symbol() external view returns (string memory);
84 
85     function decimals() external view returns (uint8);
86 }
87 
88 contract ERC20 is Context, IERC20, IERC20Metadata {
89     mapping(address => uint256) private _balances;
90 
91     mapping(address => mapping(address => uint256)) private _allowances;
92 
93     uint256 private _totalSupply;
94 
95     string private _name;
96     string private _symbol;
97 
98     constructor(string memory name_, string memory symbol_) {
99         _name = name_;
100         _symbol = symbol_;
101     }
102 
103     function name() public view virtual override returns (string memory) {
104         return _name;
105     }
106 
107     function symbol() public view virtual override returns (string memory) {
108         return _symbol;
109     }
110 
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114 
115     function totalSupply() public view virtual override returns (uint256) {
116         return _totalSupply;
117     }
118 
119     function balanceOf(address account) public view virtual override returns (uint256) {
120         return _balances[account];
121     }
122 
123     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
124         _transfer(_msgSender(), recipient, amount);
125         return true;
126     }
127 
128     function allowance(address owner, address spender) public view virtual override returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     function approve(address spender, uint256 amount) public virtual override returns (bool) {
133         _approve(_msgSender(), spender, amount);
134         return true;
135     }
136 
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) public virtual override returns (bool) {
142         _transfer(sender, recipient, amount);
143 
144         uint256 currentAllowance = _allowances[sender][_msgSender()];
145         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
146         unchecked {
147             _approve(sender, _msgSender(), currentAllowance - amount);
148         }
149 
150         return true;
151     }
152 
153     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
155         return true;
156     }
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
159         uint256 currentAllowance = _allowances[_msgSender()][spender];
160         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
161         unchecked {
162             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
163         }
164 
165         return true;
166     }
167 
168     function _transfer(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) internal virtual {
173         require(sender != address(0), "ERC20: transfer from the zero address");
174         require(recipient != address(0), "ERC20: transfer to the zero address");
175 
176         _beforeTokenTransfer(sender, recipient, amount);
177 
178         uint256 senderBalance = _balances[sender];
179         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
180         unchecked {
181             _balances[sender] = senderBalance - amount;
182         }
183         _balances[recipient] += amount;
184 
185         emit Transfer(sender, recipient, amount);
186 
187         _afterTokenTransfer(sender, recipient, amount);
188     }
189 
190     function _mint(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: mint to the zero address");
192 
193         _beforeTokenTransfer(address(0), account, amount);
194 
195         _totalSupply += amount;
196         _balances[account] += amount;
197         emit Transfer(address(0), account, amount);
198 
199         _afterTokenTransfer(address(0), account, amount);
200     }
201 
202     function _burn(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: burn from the zero address");
204 
205         _beforeTokenTransfer(account, address(0), amount);
206 
207         uint256 accountBalance = _balances[account];
208         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
209         unchecked {
210             _balances[account] = accountBalance - amount;
211         }
212         _totalSupply -= amount;
213 
214         emit Transfer(account, address(0), amount);
215 
216         _afterTokenTransfer(account, address(0), amount);
217     }
218 
219     function _approve(
220         address owner,
221         address spender,
222         uint256 amount
223     ) internal virtual {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _beforeTokenTransfer(
232         address from,
233         address to,
234         uint256 amount
235     ) internal virtual {}
236 
237     function _afterTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 }
243 
244 library SafeMath {
245 
246     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             uint256 c = a + b;
249             if (c < a) return (false, 0);
250             return (true, c);
251         }
252     }
253 
254     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
255         unchecked {
256             if (b > a) return (false, 0);
257             return (true, a - b);
258         }
259     }
260 
261     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             if (a == 0) return (true, 0);
264             uint256 c = a * b;
265             if (c / a != b) return (false, 0);
266             return (true, c);
267         }
268     }
269 
270     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             if (b == 0) return (false, 0);
273             return (true, a / b);
274         }
275     }
276 
277     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         unchecked {
279             if (b == 0) return (false, 0);
280             return (true, a % b);
281         }
282     }
283 
284     function add(uint256 a, uint256 b) internal pure returns (uint256) {
285         return a + b;
286     }
287 
288     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289         return a - b;
290     }
291 
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a * b;
294     }
295 
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a / b;
298     }
299 
300     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a % b;
302     }
303 
304     function sub(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b <= a, errorMessage);
311             return a - b;
312         }
313     }
314 
315     function div(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b > 0, errorMessage);
322             return a / b;
323         }
324     }
325 
326     function mod(
327         uint256 a,
328         uint256 b,
329         string memory errorMessage
330     ) internal pure returns (uint256) {
331         unchecked {
332             require(b > 0, errorMessage);
333             return a % b;
334         }
335     }
336 }
337 
338 interface IUniswapV2Factory {
339     event PairCreated(
340         address indexed token0,
341         address indexed token1,
342         address pair,
343         uint256
344     );
345 
346     function feeTo() external view returns (address);
347 
348     function feeToSetter() external view returns (address);
349 
350     function getPair(address tokenA, address tokenB)
351         external
352         view
353         returns (address pair);
354 
355     function allPairs(uint256) external view returns (address pair);
356 
357     function allPairsLength() external view returns (uint256);
358 
359     function createPair(address tokenA, address tokenB)
360         external
361         returns (address pair);
362 
363     function setFeeTo(address) external;
364 
365     function setFeeToSetter(address) external;
366 }
367 
368 interface IUniswapV2Pair {
369     event Approval(
370         address indexed owner,
371         address indexed spender,
372         uint256 value
373     );
374     event Transfer(address indexed from, address indexed to, uint256 value);
375 
376     function name() external pure returns (string memory);
377 
378     function symbol() external pure returns (string memory);
379 
380     function decimals() external pure returns (uint8);
381 
382     function totalSupply() external view returns (uint256);
383 
384     function balanceOf(address owner) external view returns (uint256);
385 
386     function allowance(address owner, address spender)
387         external
388         view
389         returns (uint256);
390 
391     function approve(address spender, uint256 value) external returns (bool);
392 
393     function transfer(address to, uint256 value) external returns (bool);
394 
395     function transferFrom(
396         address from,
397         address to,
398         uint256 value
399     ) external returns (bool);
400 
401     function DOMAIN_SEPARATOR() external view returns (bytes32);
402 
403     function PERMIT_TYPEHASH() external pure returns (bytes32);
404 
405     function nonces(address owner) external view returns (uint256);
406 
407     function permit(
408         address owner,
409         address spender,
410         uint256 value,
411         uint256 deadline,
412         uint8 v,
413         bytes32 r,
414         bytes32 s
415     ) external;
416 
417     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
418     event Burn(
419         address indexed sender,
420         uint256 amount0,
421         uint256 amount1,
422         address indexed to
423     );
424     event Swap(
425         address indexed sender,
426         uint256 amount0In,
427         uint256 amount1In,
428         uint256 amount0Out,
429         uint256 amount1Out,
430         address indexed to
431     );
432     event Sync(uint112 reserve0, uint112 reserve1);
433 
434     function MINIMUM_LIQUIDITY() external pure returns (uint256);
435 
436     function factory() external view returns (address);
437 
438     function token0() external view returns (address);
439 
440     function token1() external view returns (address);
441 
442     function getReserves()
443         external
444         view
445         returns (
446             uint112 reserve0,
447             uint112 reserve1,
448             uint32 blockTimestampLast
449         );
450 
451     function price0CumulativeLast() external view returns (uint256);
452 
453     function price1CumulativeLast() external view returns (uint256);
454 
455     function kLast() external view returns (uint256);
456 
457     function mint(address to) external returns (uint256 liquidity);
458 
459     function burn(address to)
460         external
461         returns (uint256 amount0, uint256 amount1);
462 
463     function swap(
464         uint256 amount0Out,
465         uint256 amount1Out,
466         address to,
467         bytes calldata data
468     ) external;
469 
470     function skim(address to) external;
471 
472     function sync() external;
473 
474     function initialize(address, address) external;
475 }
476 
477 interface IUniswapV2Router02 {
478     function factory() external pure returns (address);
479 
480     function WETH() external pure returns (address);
481 
482     function addLiquidity(
483         address tokenA,
484         address tokenB,
485         uint256 amountADesired,
486         uint256 amountBDesired,
487         uint256 amountAMin,
488         uint256 amountBMin,
489         address to,
490         uint256 deadline
491     )
492         external
493         returns (
494             uint256 amountA,
495             uint256 amountB,
496             uint256 liquidity
497         );
498 
499     function addLiquidityETH(
500         address token,
501         uint256 amountTokenDesired,
502         uint256 amountTokenMin,
503         uint256 amountETHMin,
504         address to,
505         uint256 deadline
506     )
507         external
508         payable
509         returns (
510             uint256 amountToken,
511             uint256 amountETH,
512             uint256 liquidity
513         );
514 
515     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
516         uint256 amountIn,
517         uint256 amountOutMin,
518         address[] calldata path,
519         address to,
520         uint256 deadline
521     ) external;
522 
523     function swapExactETHForTokensSupportingFeeOnTransferTokens(
524         uint256 amountOutMin,
525         address[] calldata path,
526         address to,
527         uint256 deadline
528     ) external payable;
529 
530     function swapExactTokensForETHSupportingFeeOnTransferTokens(
531         uint256 amountIn,
532         uint256 amountOutMin,
533         address[] calldata path,
534         address to,
535         uint256 deadline
536     ) external;
537 }
538 
539 contract XBURN is ERC20, Ownable {
540     using SafeMath for uint256;
541 
542     IUniswapV2Router02 public immutable uniswapV2Router;
543     address public immutable uniswapV2Pair;
544     address public constant deadAddress = address(0xdead);
545     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
546 
547     bool private swapping;
548 
549     address public mktgWallet;
550     address public devWallet;
551     address public liqWallet;
552     address public operationsWallet;
553 
554     uint256 public maxTransactionAmount;
555     uint256 public swapTokensAtAmount;
556     uint256 public maxWallet;
557 
558     bool public limitsInEffect = true;
559     bool public tradingActive = false;
560     bool public swapEnabled = false;
561 
562     // Anti-bot and anti-whale mappings and variables
563     mapping(address => uint256) private _holderLastTransferTimestamp;
564     bool public transferDelayEnabled = true;
565     uint256 private launchBlock;
566     uint256 private deadBlocks;
567     mapping(address => bool) public blocked;
568 
569     uint256 public buyTotalFees;
570     uint256 public buyMktgFee;
571     uint256 public buyLiquidityFee;
572     uint256 public buyDevFee;
573     uint256 public buyOperationsFee;
574 
575     uint256 public sellTotalFees;
576     uint256 public sellMktgFee;
577     uint256 public sellLiquidityFee;
578     uint256 public sellDevFee;
579     uint256 public sellOperationsFee;
580 
581     uint256 public tokensForMktg;
582     uint256 public tokensForLiquidity;
583     uint256 public tokensForDev;
584     uint256 public tokensForOperations;
585 
586     mapping(address => bool) private _isExcludedFromFees;
587     mapping(address => bool) public _isExcludedMaxTransactionAmount;
588 
589     mapping(address => bool) public automatedMarketMakerPairs;
590 
591     event UpdateUniswapV2Router(
592         address indexed newAddress,
593         address indexed oldAddress
594     );
595 
596     event ExcludeFromFees(address indexed account, bool isExcluded);
597 
598     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
599 
600     event mktgWalletUpdated(
601         address indexed newWallet,
602         address indexed oldWallet
603     );
604 
605     event devWalletUpdated(
606         address indexed newWallet,
607         address indexed oldWallet
608     );
609 
610     event liqWalletUpdated(
611         address indexed newWallet,
612         address indexed oldWallet
613     );
614 
615     event operationsWalletUpdated(
616         address indexed newWallet,
617         address indexed oldWallet
618     );
619 
620     event SwapAndLiquify(
621         uint256 tokensSwapped,
622         uint256 ethReceived,
623         uint256 tokensIntoLiquidity
624     );
625 
626     constructor() ERC20("XBURN", "XBURN") {
627         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
628 
629         excludeFromMaxTransaction(address(_uniswapV2Router), true);
630         uniswapV2Router = _uniswapV2Router;
631 
632         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
633             .createPair(address(this), _uniswapV2Router.WETH());
634         excludeFromMaxTransaction(address(uniswapV2Pair), true);
635         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
636 
637         // launch buy fees
638         uint256 _buyMktgFee = 0;
639         uint256 _buyLiquidityFee = 0;
640         uint256 _buyDevFee = 0;
641         uint256 _buyOperationsFee = 0;
642         
643         // launch sell fees
644         uint256 _sellMktgFee = 0;
645         uint256 _sellLiquidityFee = 0;
646         uint256 _sellDevFee = 0;
647         uint256 _sellOperationsFee = 0;
648 
649         uint256 totalSupply = 1_000_000 * 1e18;
650 
651         maxTransactionAmount = 20_000 * 1e18; // 2% max txn
652         maxWallet = 20_000 * 1e18; // 2% max wallet
653         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
654 
655         buyMktgFee = _buyMktgFee;
656         buyLiquidityFee = _buyLiquidityFee;
657         buyDevFee = _buyDevFee;
658         buyOperationsFee = _buyOperationsFee;
659         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
660 
661         sellMktgFee = _sellMktgFee;
662         sellLiquidityFee = _sellLiquidityFee;
663         sellDevFee = _sellDevFee;
664         sellOperationsFee = _sellOperationsFee;
665         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
666 
667         mktgWallet = address(0xD177bA3e31b4Cc192B81e005A23ed4DCf78EDcF5); 
668         devWallet = address(0xD177bA3e31b4Cc192B81e005A23ed4DCf78EDcF5); 
669         liqWallet = address(0xD4fAFe70031E24732e59270c5c1A80e4Ba70d8F2); 
670         operationsWallet = address(0xD177bA3e31b4Cc192B81e005A23ed4DCf78EDcF5);
671 
672         // exclude from paying fees or having max transaction amount
673         excludeFromFees(owner(), true);
674         excludeFromFees(address(this), true);
675         excludeFromFees(address(0xdead), true);
676 
677         excludeFromMaxTransaction(owner(), true);
678         excludeFromMaxTransaction(address(this), true);
679         excludeFromMaxTransaction(address(0xdead), true);
680 
681         _mint(msg.sender, totalSupply);
682     }
683 
684     receive() external payable {}
685 
686     function enableTrading(uint256 _deadBlocks) external onlyOwner {
687         require(!tradingActive, "Token launched");
688         tradingActive = true;
689         launchBlock = block.number;
690         swapEnabled = true;
691         deadBlocks = _deadBlocks;
692     }
693 
694     // remove limits after token is stable
695     function removeLimits() external onlyOwner returns (bool) {
696         limitsInEffect = false;
697         return true;
698     }
699 
700     // disable Transfer delay - cannot be reenabled
701     function disableTransferDelay() external onlyOwner returns (bool) {
702         transferDelayEnabled = false;
703         return true;
704     }
705 
706     // change the minimum amount of tokens to sell from fees
707     function updateSwapTokensAtAmount(uint256 newAmount)
708         external
709         onlyOwner
710         returns (bool)
711     {
712         require(
713             newAmount >= (totalSupply() * 1) / 100000,
714             "Swap amount cannot be lower than 0.001% total supply."
715         );
716         require(
717             newAmount <= (totalSupply() * 5) / 1000,
718             "Swap amount cannot be higher than 0.5% total supply."
719         );
720         swapTokensAtAmount = newAmount;
721         return true;
722     }
723 
724     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
725         require(
726             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
727             "Cannot set maxTransactionAmount lower than 0.1%"
728         );
729         maxTransactionAmount = newNum * (10**18);
730     }
731 
732     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
733         require(
734             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
735             "Cannot set maxWallet lower than 0.5%"
736         );
737         maxWallet = newNum * (10**18);
738     }
739 
740     function excludeFromMaxTransaction(address updAds, bool isEx)
741         public
742         onlyOwner
743     {
744         _isExcludedMaxTransactionAmount[updAds] = isEx;
745     }
746 
747     // only use to disable contract sales if absolutely necessary (emergency use only)
748     function updateSwapEnabled(bool enabled) external onlyOwner {
749         swapEnabled = enabled;
750     }
751 
752     function updateBuyFees(
753         uint256 _mktgFee,
754         uint256 _liquidityFee,
755         uint256 _devFee,
756         uint256 _operationsFee
757     ) external onlyOwner {
758         buyMktgFee = _mktgFee;
759         buyLiquidityFee = _liquidityFee;
760         buyDevFee = _devFee;
761         buyOperationsFee = _operationsFee;
762         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
763         require(buyTotalFees <= 99);
764     }
765 
766     function updateSellFees(
767         uint256 _mktgFee,
768         uint256 _liquidityFee,
769         uint256 _devFee,
770         uint256 _operationsFee
771     ) external onlyOwner {
772         sellMktgFee = _mktgFee;
773         sellLiquidityFee = _liquidityFee;
774         sellDevFee = _devFee;
775         sellOperationsFee = _operationsFee;
776         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
777         require(sellTotalFees <= 99); 
778     }
779 
780     function excludeFromFees(address account, bool excluded) public onlyOwner {
781         _isExcludedFromFees[account] = excluded;
782         emit ExcludeFromFees(account, excluded);
783     }
784 
785     function setAutomatedMarketMakerPair(address pair, bool value)
786         public
787         onlyOwner
788     {
789         require(
790             pair != uniswapV2Pair,
791             "The pair cannot be removed from automatedMarketMakerPairs"
792         );
793 
794         _setAutomatedMarketMakerPair(pair, value);
795     }
796 
797     function _setAutomatedMarketMakerPair(address pair, bool value) private {
798         automatedMarketMakerPairs[pair] = value;
799 
800         emit SetAutomatedMarketMakerPair(pair, value);
801     }
802 
803     function updatemktgWallet(address newmktgWallet) external onlyOwner {
804         emit mktgWalletUpdated(newmktgWallet, mktgWallet);
805         mktgWallet = newmktgWallet;
806     }
807 
808     function updateDevWallet(address newWallet) external onlyOwner {
809         emit devWalletUpdated(newWallet, devWallet);
810         devWallet = newWallet;
811     }
812 
813     function updateoperationsWallet(address newWallet) external onlyOwner{
814         emit operationsWalletUpdated(newWallet, operationsWallet);
815         operationsWallet = newWallet;
816     }
817 
818     function updateLiqWallet(address newLiqWallet) external onlyOwner {
819         emit liqWalletUpdated(newLiqWallet, liqWallet);
820         liqWallet = newLiqWallet;
821     }
822 
823     function isExcludedFromFees(address account) public view returns (bool) {
824         return _isExcludedFromFees[account];
825     }
826 
827     event BoughtEarly(address indexed sniper);
828 
829     function _transfer(
830         address from,
831         address to,
832         uint256 amount
833     ) internal override {
834         require(from != address(0), "ERC20: transfer from the zero address");
835         require(to != address(0), "ERC20: transfer to the zero address");
836         require(!blocked[from], "Sniper blocked");
837 
838         if (amount == 0) {
839             super._transfer(from, to, 0);
840             return;
841         }
842 
843         if (limitsInEffect) {
844             if (
845                 from != owner() &&
846                 to != owner() &&
847                 to != address(0) &&
848                 to != address(0xdead) &&
849                 !swapping
850             ) {
851                 if (!tradingActive) {
852                     require(
853                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
854                         "Trading is not active."
855                     );
856                 }
857 
858                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
859                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
860                     blocked[to] = true;
861                     emit BoughtEarly(to);
862                 }
863 
864                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
865                 if (transferDelayEnabled) {
866                     if (
867                         to != owner() &&
868                         to != address(uniswapV2Router) &&
869                         to != address(uniswapV2Pair)
870                     ) {
871                         require(
872                             _holderLastTransferTimestamp[tx.origin] <
873                                 block.number,
874                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
875                         );
876                         _holderLastTransferTimestamp[tx.origin] = block.number;
877                     }
878                 }
879 
880                 //when buy
881                 if (
882                     automatedMarketMakerPairs[from] &&
883                     !_isExcludedMaxTransactionAmount[to]
884                 ) {
885                     require(
886                         amount <= maxTransactionAmount,
887                         "Buy transfer amount exceeds the maxTransactionAmount."
888                     );
889                     require(
890                         amount + balanceOf(to) <= maxWallet,
891                         "Max wallet exceeded"
892                     );
893                 }
894                 //when sell
895                 else if (
896                     automatedMarketMakerPairs[to] &&
897                     !_isExcludedMaxTransactionAmount[from]
898                 ) {
899                     require(
900                         amount <= maxTransactionAmount,
901                         "Sell transfer amount exceeds the maxTransactionAmount."
902                     );
903                 } else if (!_isExcludedMaxTransactionAmount[to]) {
904                     require(
905                         amount + balanceOf(to) <= maxWallet,
906                         "Max wallet exceeded"
907                     );
908                 }
909             }
910         }
911 
912         uint256 contractTokenBalance = balanceOf(address(this));
913 
914         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
915 
916         if (
917             canSwap &&
918             swapEnabled &&
919             !swapping &&
920             !automatedMarketMakerPairs[from] &&
921             !_isExcludedFromFees[from] &&
922             !_isExcludedFromFees[to]
923         ) {
924             swapping = true;
925 
926             swapBack();
927 
928             swapping = false;
929         }
930 
931         bool takeFee = !swapping;
932 
933         // if any account belongs to _isExcludedFromFee account then remove the fee
934         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
935             takeFee = false;
936         }
937 
938         uint256 fees = 0;
939         // only take fees on buys/sells, do not take on wallet transfers
940         if (takeFee) {
941             // on sell
942             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
943                 fees = amount.mul(sellTotalFees).div(100);
944                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
945                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
946                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
947                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
948             }
949             // on buy
950             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
951                 fees = amount.mul(buyTotalFees).div(100);
952                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
953                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
954                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
955                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
956             }
957 
958             if (fees > 0) {
959                 super._transfer(from, address(this), fees);
960             }
961 
962             amount -= fees;
963         }
964 
965         super._transfer(from, to, amount);
966     }
967 
968     function swapTokensForEth(uint256 tokenAmount) private {
969         // generate the uniswap pair path of token -> weth
970         address[] memory path = new address[](2);
971         path[0] = address(this);
972         path[1] = uniswapV2Router.WETH();
973 
974         _approve(address(this), address(uniswapV2Router), tokenAmount);
975 
976         // make the swap
977         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
978             tokenAmount,
979             0, // accept any amount of ETH
980             path,
981             address(this),
982             block.timestamp
983         );
984     }
985 
986     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
987         for(uint256 i = 0;i<blockees.length;i++){
988             address blockee = blockees[i];
989             if(blockee != address(this) && 
990                blockee != routerCA && 
991                blockee != address(uniswapV2Pair))
992                 blocked[blockee] = shouldBlock;
993         }
994     }
995 
996     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
997         // approve token transfer to cover all possible scenarios
998         _approve(address(this), address(uniswapV2Router), tokenAmount);
999 
1000         // add the liquidity
1001         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1002             address(this),
1003             tokenAmount,
1004             0, // slippage is unavoidable
1005             0, // slippage is unavoidable
1006             liqWallet,
1007             block.timestamp
1008         );
1009     }
1010 
1011     function swapBack() private {
1012         uint256 contractBalance = balanceOf(address(this));
1013         uint256 totalTokensToSwap = tokensForLiquidity +
1014             tokensForMktg +
1015             tokensForDev +
1016             tokensForOperations;
1017         bool success;
1018 
1019         if (contractBalance == 0 || totalTokensToSwap == 0) {
1020             return;
1021         }
1022 
1023         if (contractBalance > swapTokensAtAmount * 20) {
1024             contractBalance = swapTokensAtAmount * 20;
1025         }
1026 
1027         // Halve the amount of liquidity tokens
1028         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1029         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1030 
1031         uint256 initialETHBalance = address(this).balance;
1032 
1033         swapTokensForEth(amountToSwapForETH);
1034 
1035         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1036 
1037         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1038         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1039         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1040 
1041         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1042 
1043         tokensForLiquidity = 0;
1044         tokensForMktg = 0;
1045         tokensForDev = 0;
1046         tokensForOperations = 0;
1047 
1048         (success, ) = address(devWallet).call{value: ethForDev}("");
1049 
1050         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1051             addLiquidity(liquidityTokens, ethForLiquidity);
1052             emit SwapAndLiquify(
1053                 amountToSwapForETH,
1054                 ethForLiquidity,
1055                 tokensForLiquidity
1056             );
1057         }
1058         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1059         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1060     }
1061 }