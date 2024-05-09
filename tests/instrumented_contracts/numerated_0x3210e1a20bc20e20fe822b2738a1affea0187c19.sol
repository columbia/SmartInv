1 /**
2 
3 Website: https://humanvoiceai.com/
4 TG:      https://t.me/Human_Voice_AI_Portal
5 Twitter: https://twitter.com/HumanVoice_AI
6 
7 **/
8 // SPDX-License-Identifier: MIT
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
539 contract HumanVoiceAI is ERC20, Ownable {
540     using SafeMath for uint256;
541 
542     IUniswapV2Router02 public immutable uniswapV2Router;
543     address public immutable uniswapV2Pair;
544     address public constant deadAddress = address(0xdead);
545 
546     bool private swapping;
547 
548     address public mktgWallet;
549     address public devWallet;
550     address public liqWallet;
551     address public operationsWallet;
552 
553     uint256 public maxTransactionAmount;
554     uint256 public swapTokensAtAmount;
555     uint256 public maxWallet;
556 
557     bool public limitsInEffect = true;
558     bool public tradingActive = false;
559     bool public swapEnabled = false;
560 
561     // Anti-bot and anti-whale mappings and variables
562     mapping(address => uint256) private _holderLastTransferTimestamp;
563     bool public transferDelayEnabled = true;
564 
565     uint256 public buyTotalFees;
566     uint256 public buyMktgFee;
567     uint256 public buyLiquidityFee;
568     uint256 public buyDevFee;
569     uint256 public buyOperationsFee;
570 
571     uint256 public sellTotalFees;
572     uint256 public sellMktgFee;
573     uint256 public sellLiquidityFee;
574     uint256 public sellDevFee;
575     uint256 public sellOperationsFee;
576 
577     uint256 public tokensForMktg;
578     uint256 public tokensForLiquidity;
579     uint256 public tokensForDev;
580     uint256 public tokensForOperations;
581 
582     mapping(address => bool) private _isExcludedFromFees;
583     mapping(address => bool) public _isExcludedMaxTransactionAmount;
584 
585     mapping(address => bool) public automatedMarketMakerPairs;
586 
587     event UpdateUniswapV2Router(
588         address indexed newAddress,
589         address indexed oldAddress
590     );
591 
592     event ExcludeFromFees(address indexed account, bool isExcluded);
593 
594     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
595 
596     event mktgWalletUpdated(
597         address indexed newWallet,
598         address indexed oldWallet
599     );
600 
601     event devWalletUpdated(
602         address indexed newWallet,
603         address indexed oldWallet
604     );
605 
606     event liqWalletUpdated(
607         address indexed newWallet,
608         address indexed oldWallet
609     );
610 
611     event operationsWalletUpdated(
612         address indexed newWallet,
613         address indexed oldWallet
614     );
615 
616     event SwapAndLiquify(
617         uint256 tokensSwapped,
618         uint256 ethReceived,
619         uint256 tokensIntoLiquidity
620     );
621 
622     constructor() ERC20("Human Voice AI", "HVAI") {
623         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
624 
625         excludeFromMaxTransaction(address(_uniswapV2Router), true);
626         uniswapV2Router = _uniswapV2Router;
627 
628         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
629             .createPair(address(this), _uniswapV2Router.WETH());
630         excludeFromMaxTransaction(address(uniswapV2Pair), true);
631         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
632 
633         // launch buy fees
634         uint256 _buyMktgFee = 5;
635         uint256 _buyLiquidityFee = 0;
636         uint256 _buyDevFee = 5;
637         uint256 _buyOperationsFee = 0;
638         
639         // launch sell fees
640         uint256 _sellMktgFee = 5;
641         uint256 _sellLiquidityFee = 10;
642         uint256 _sellDevFee = 5;
643         uint256 _sellOperationsFee = 0;
644 
645         uint256 totalSupply = 1_000_000 * 1e18;
646 
647         maxTransactionAmount = 10_000 * 1e18; // 1% max txn
648         maxWallet = 10_000 * 1e18; // 1% max wallet
649         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
650 
651         buyMktgFee = _buyMktgFee;
652         buyLiquidityFee = _buyLiquidityFee;
653         buyDevFee = _buyDevFee;
654         buyOperationsFee = _buyOperationsFee;
655         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
656 
657         sellMktgFee = _sellMktgFee;
658         sellLiquidityFee = _sellLiquidityFee;
659         sellDevFee = _sellDevFee;
660         sellOperationsFee = _sellOperationsFee;
661         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
662 
663         mktgWallet = address(0xC9eA5B3CfF5798e31f1A3f9d20b3eC059f5fcB41); 
664         devWallet = address(0x29FbcD2bDc41BFf7b0c81C26d0dD9A5847688543); 
665         liqWallet = address(0x433927845A7b8E828b10aaac8DD0495b14fE15B4); 
666         operationsWallet = address(0x433927845A7b8E828b10aaac8DD0495b14fE15B4);
667 
668         // exclude from paying fees or having max transaction amount
669         excludeFromFees(owner(), true);
670         excludeFromFees(address(this), true);
671         excludeFromFees(address(0xdead), true);
672 
673         excludeFromMaxTransaction(owner(), true);
674         excludeFromMaxTransaction(address(this), true);
675         excludeFromMaxTransaction(address(0xdead), true);
676 
677         _mint(msg.sender, totalSupply);
678     }
679 
680     receive() external payable {}
681 
682     function enableTrading() external onlyOwner {
683         tradingActive = true;
684         swapEnabled = true;
685     }
686 
687     // remove limits after token is stable
688     function removeLimits() external onlyOwner returns (bool) {
689         limitsInEffect = false;
690         return true;
691     }
692 
693     // disable Transfer delay - cannot be reenabled
694     function disableTransferDelay() external onlyOwner returns (bool) {
695         transferDelayEnabled = false;
696         return true;
697     }
698 
699     // change the minimum amount of tokens to sell from fees
700     function updateSwapTokensAtAmount(uint256 newAmount)
701         external
702         onlyOwner
703         returns (bool)
704     {
705         require(
706             newAmount >= (totalSupply() * 1) / 100000,
707             "Swap amount cannot be lower than 0.001% total supply."
708         );
709         require(
710             newAmount <= (totalSupply() * 5) / 1000,
711             "Swap amount cannot be higher than 0.5% total supply."
712         );
713         swapTokensAtAmount = newAmount;
714         return true;
715     }
716 
717     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
718         require(
719             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
720             "Cannot set maxTransactionAmount lower than 0.1%"
721         );
722         maxTransactionAmount = newNum * (10**18);
723     }
724 
725     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
726         require(
727             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
728             "Cannot set maxWallet lower than 0.5%"
729         );
730         maxWallet = newNum * (10**18);
731     }
732 
733     function excludeFromMaxTransaction(address updAds, bool isEx)
734         public
735         onlyOwner
736     {
737         _isExcludedMaxTransactionAmount[updAds] = isEx;
738     }
739 
740     // only use to disable contract sales if absolutely necessary (emergency use only)
741     function updateSwapEnabled(bool enabled) external onlyOwner {
742         swapEnabled = enabled;
743     }
744 
745     function updateBuyFees(
746         uint256 _mktgFee,
747         uint256 _liquidityFee,
748         uint256 _devFee,
749         uint256 _operationsFee
750     ) external onlyOwner {
751         buyMktgFee = _mktgFee;
752         buyLiquidityFee = _liquidityFee;
753         buyDevFee = _devFee;
754         buyOperationsFee = _operationsFee;
755         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
756         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
757     }
758 
759     function updateSellFees(
760         uint256 _mktgFee,
761         uint256 _liquidityFee,
762         uint256 _devFee,
763         uint256 _operationsFee
764     ) external onlyOwner {
765         sellMktgFee = _mktgFee;
766         sellLiquidityFee = _liquidityFee;
767         sellDevFee = _devFee;
768         sellOperationsFee = _operationsFee;
769         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
770         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
771     }
772 
773     function excludeFromFees(address account, bool excluded) public onlyOwner {
774         _isExcludedFromFees[account] = excluded;
775         emit ExcludeFromFees(account, excluded);
776     }
777 
778     function setAutomatedMarketMakerPair(address pair, bool value)
779         public
780         onlyOwner
781     {
782         require(
783             pair != uniswapV2Pair,
784             "The pair cannot be removed from automatedMarketMakerPairs"
785         );
786 
787         _setAutomatedMarketMakerPair(pair, value);
788     }
789 
790     function _setAutomatedMarketMakerPair(address pair, bool value) private {
791         automatedMarketMakerPairs[pair] = value;
792 
793         emit SetAutomatedMarketMakerPair(pair, value);
794     }
795 
796     function updatemktgWallet(address newmktgWallet) external onlyOwner {
797         emit mktgWalletUpdated(newmktgWallet, mktgWallet);
798         mktgWallet = newmktgWallet;
799     }
800 
801     function updateDevWallet(address newWallet) external onlyOwner {
802         emit devWalletUpdated(newWallet, devWallet);
803         devWallet = newWallet;
804     }
805 
806     function updateoperationsWallet(address newWallet) external onlyOwner{
807         emit operationsWalletUpdated(newWallet, operationsWallet);
808         operationsWallet = newWallet;
809     }
810 
811     function updateLiqWallet(address newLiqWallet) external onlyOwner {
812         emit liqWalletUpdated(newLiqWallet, liqWallet);
813         liqWallet = newLiqWallet;
814     }
815 
816     function isExcludedFromFees(address account) public view returns (bool) {
817         return _isExcludedFromFees[account];
818     }
819 
820     event BoughtEarly(address indexed sniper);
821 
822     function _transfer(
823         address from,
824         address to,
825         uint256 amount
826     ) internal override {
827         require(from != address(0), "ERC20: transfer from the zero address");
828         require(to != address(0), "ERC20: transfer to the zero address");
829 
830         if (amount == 0) {
831             super._transfer(from, to, 0);
832             return;
833         }
834 
835         if (limitsInEffect) {
836             if (
837                 from != owner() &&
838                 to != owner() &&
839                 to != address(0) &&
840                 to != address(0xdead) &&
841                 !swapping
842             ) {
843                 if (!tradingActive) {
844                     require(
845                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
846                         "Trading is not active."
847                     );
848                 }
849 
850                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
851                 if (transferDelayEnabled) {
852                     if (
853                         to != owner() &&
854                         to != address(uniswapV2Router) &&
855                         to != address(uniswapV2Pair)
856                     ) {
857                         require(
858                             _holderLastTransferTimestamp[tx.origin] <
859                                 block.number,
860                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
861                         );
862                         _holderLastTransferTimestamp[tx.origin] = block.number;
863                     }
864                 }
865 
866                 //when buy
867                 if (
868                     automatedMarketMakerPairs[from] &&
869                     !_isExcludedMaxTransactionAmount[to]
870                 ) {
871                     require(
872                         amount <= maxTransactionAmount,
873                         "Buy transfer amount exceeds the maxTransactionAmount."
874                     );
875                     require(
876                         amount + balanceOf(to) <= maxWallet,
877                         "Max wallet exceeded"
878                     );
879                 }
880                 //when sell
881                 else if (
882                     automatedMarketMakerPairs[to] &&
883                     !_isExcludedMaxTransactionAmount[from]
884                 ) {
885                     require(
886                         amount <= maxTransactionAmount,
887                         "Sell transfer amount exceeds the maxTransactionAmount."
888                     );
889                 } else if (!_isExcludedMaxTransactionAmount[to]) {
890                     require(
891                         amount + balanceOf(to) <= maxWallet,
892                         "Max wallet exceeded"
893                     );
894                 }
895             }
896         }
897 
898         uint256 contractTokenBalance = balanceOf(address(this));
899 
900         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
901 
902         if (
903             canSwap &&
904             swapEnabled &&
905             !swapping &&
906             !automatedMarketMakerPairs[from] &&
907             !_isExcludedFromFees[from] &&
908             !_isExcludedFromFees[to]
909         ) {
910             swapping = true;
911 
912             swapBack();
913 
914             swapping = false;
915         }
916 
917         bool takeFee = !swapping;
918 
919         // if any account belongs to _isExcludedFromFee account then remove the fee
920         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
921             takeFee = false;
922         }
923 
924         uint256 fees = 0;
925         // only take fees on buys/sells, do not take on wallet transfers
926         if (takeFee) {
927             // on sell
928             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
929                 fees = amount.mul(sellTotalFees).div(100);
930                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
931                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
932                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
933                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
934             }
935             // on buy
936             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
937                 fees = amount.mul(buyTotalFees).div(100);
938                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
939                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
940                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
941                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
942             }
943 
944             if (fees > 0) {
945                 super._transfer(from, address(this), fees);
946             }
947 
948             amount -= fees;
949         }
950 
951         super._transfer(from, to, amount);
952     }
953 
954     function swapTokensForEth(uint256 tokenAmount) private {
955         // generate the uniswap pair path of token -> weth
956         address[] memory path = new address[](2);
957         path[0] = address(this);
958         path[1] = uniswapV2Router.WETH();
959 
960         _approve(address(this), address(uniswapV2Router), tokenAmount);
961 
962         // make the swap
963         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
964             tokenAmount,
965             0, // accept any amount of ETH
966             path,
967             address(this),
968             block.timestamp
969         );
970     }
971 
972     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
973         // approve token transfer to cover all possible scenarios
974         _approve(address(this), address(uniswapV2Router), tokenAmount);
975 
976         // add the liquidity
977         uniswapV2Router.addLiquidityETH{value: ethAmount}(
978             address(this),
979             tokenAmount,
980             0, // slippage is unavoidable
981             0, // slippage is unavoidable
982             liqWallet,
983             block.timestamp
984         );
985     }
986 
987     function swapBack() private {
988         uint256 contractBalance = balanceOf(address(this));
989         uint256 totalTokensToSwap = tokensForLiquidity +
990             tokensForMktg +
991             tokensForDev +
992             tokensForOperations;
993         bool success;
994 
995         if (contractBalance == 0 || totalTokensToSwap == 0) {
996             return;
997         }
998 
999         if (contractBalance > swapTokensAtAmount * 20) {
1000             contractBalance = swapTokensAtAmount * 20;
1001         }
1002 
1003         // Halve the amount of liquidity tokens
1004         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1005         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1006 
1007         uint256 initialETHBalance = address(this).balance;
1008 
1009         swapTokensForEth(amountToSwapForETH);
1010 
1011         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1012 
1013         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1014         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1015         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1016 
1017         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1018 
1019         tokensForLiquidity = 0;
1020         tokensForMktg = 0;
1021         tokensForDev = 0;
1022         tokensForOperations = 0;
1023 
1024         (success, ) = address(devWallet).call{value: ethForDev}("");
1025 
1026         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1027             addLiquidity(liquidityTokens, ethForLiquidity);
1028             emit SwapAndLiquify(
1029                 amountToSwapForETH,
1030                 ethForLiquidity,
1031                 tokensForLiquidity
1032             );
1033         }
1034         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1035         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1036     }
1037 }