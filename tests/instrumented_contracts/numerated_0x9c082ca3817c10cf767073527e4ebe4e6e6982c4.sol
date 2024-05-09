1 /**
2 Telegram: https://t.me/ShibaAIportal
3 Website:  https://www.shibariumai.com/
4 **/
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
8 pragma experimental ABIEncoderV2;
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
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     modifier onlyOwner() {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35         _;
36     }
37 
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 interface IERC20 {
55 
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address account) external view returns (uint256);
59 
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 interface IERC20Metadata is IERC20 {
78 
79     function name() external view returns (string memory);
80 
81     function symbol() external view returns (string memory);
82 
83     function decimals() external view returns (uint8);
84 }
85 
86 contract ERC20 is Context, IERC20, IERC20Metadata {
87     mapping(address => uint256) private _balances;
88 
89     mapping(address => mapping(address => uint256)) private _allowances;
90 
91     uint256 private _totalSupply;
92 
93     string private _name;
94     string private _symbol;
95 
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101     function name() public view virtual override returns (string memory) {
102         return _name;
103     }
104 
105     function symbol() public view virtual override returns (string memory) {
106         return _symbol;
107     }
108 
109     function decimals() public view virtual override returns (uint8) {
110         return 18;
111     }
112 
113     function totalSupply() public view virtual override returns (uint256) {
114         return _totalSupply;
115     }
116 
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120 
121     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
122         _transfer(_msgSender(), recipient, amount);
123         return true;
124     }
125 
126     function allowance(address owner, address spender) public view virtual override returns (uint256) {
127         return _allowances[owner][spender];
128     }
129 
130     function approve(address spender, uint256 amount) public virtual override returns (bool) {
131         _approve(_msgSender(), spender, amount);
132         return true;
133     }
134 
135     function transferFrom(
136         address sender,
137         address recipient,
138         uint256 amount
139     ) public virtual override returns (bool) {
140         _transfer(sender, recipient, amount);
141 
142         uint256 currentAllowance = _allowances[sender][_msgSender()];
143         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
144         unchecked {
145             _approve(sender, _msgSender(), currentAllowance - amount);
146         }
147 
148         return true;
149     }
150 
151     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
152         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
153         return true;
154     }
155 
156     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
157         uint256 currentAllowance = _allowances[_msgSender()][spender];
158         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
159         unchecked {
160             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
161         }
162 
163         return true;
164     }
165 
166     function _transfer(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) internal virtual {
171         require(sender != address(0), "ERC20: transfer from the zero address");
172         require(recipient != address(0), "ERC20: transfer to the zero address");
173 
174         _beforeTokenTransfer(sender, recipient, amount);
175 
176         uint256 senderBalance = _balances[sender];
177         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
178         unchecked {
179             _balances[sender] = senderBalance - amount;
180         }
181         _balances[recipient] += amount;
182 
183         emit Transfer(sender, recipient, amount);
184 
185         _afterTokenTransfer(sender, recipient, amount);
186     }
187 
188     function _mint(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: mint to the zero address");
190 
191         _beforeTokenTransfer(address(0), account, amount);
192 
193         _totalSupply += amount;
194         _balances[account] += amount;
195         emit Transfer(address(0), account, amount);
196 
197         _afterTokenTransfer(address(0), account, amount);
198     }
199 
200     function _burn(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: burn from the zero address");
202 
203         _beforeTokenTransfer(account, address(0), amount);
204 
205         uint256 accountBalance = _balances[account];
206         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
207         unchecked {
208             _balances[account] = accountBalance - amount;
209         }
210         _totalSupply -= amount;
211 
212         emit Transfer(account, address(0), amount);
213 
214         _afterTokenTransfer(account, address(0), amount);
215     }
216 
217     function _approve(
218         address owner,
219         address spender,
220         uint256 amount
221     ) internal virtual {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224 
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _beforeTokenTransfer(
230         address from,
231         address to,
232         uint256 amount
233     ) internal virtual {}
234 
235     function _afterTokenTransfer(
236         address from,
237         address to,
238         uint256 amount
239     ) internal virtual {}
240 }
241 
242 library SafeMath {
243 
244     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             uint256 c = a + b;
247             if (c < a) return (false, 0);
248             return (true, c);
249         }
250     }
251 
252     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b > a) return (false, 0);
255             return (true, a - b);
256         }
257     }
258 
259     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (a == 0) return (true, 0);
262             uint256 c = a * b;
263             if (c / a != b) return (false, 0);
264             return (true, c);
265         }
266     }
267 
268     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b == 0) return (false, 0);
271             return (true, a / b);
272         }
273     }
274 
275     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (b == 0) return (false, 0);
278             return (true, a % b);
279         }
280     }
281 
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a + b;
284     }
285 
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a - b;
288     }
289 
290     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a * b;
292     }
293 
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a / b;
296     }
297 
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a % b;
300     }
301 
302     function sub(
303         uint256 a,
304         uint256 b,
305         string memory errorMessage
306     ) internal pure returns (uint256) {
307         unchecked {
308             require(b <= a, errorMessage);
309             return a - b;
310         }
311     }
312 
313     function div(
314         uint256 a,
315         uint256 b,
316         string memory errorMessage
317     ) internal pure returns (uint256) {
318         unchecked {
319             require(b > 0, errorMessage);
320             return a / b;
321         }
322     }
323 
324     function mod(
325         uint256 a,
326         uint256 b,
327         string memory errorMessage
328     ) internal pure returns (uint256) {
329         unchecked {
330             require(b > 0, errorMessage);
331             return a % b;
332         }
333     }
334 }
335 
336 interface IUniswapV2Factory {
337     event PairCreated(
338         address indexed token0,
339         address indexed token1,
340         address pair,
341         uint256
342     );
343 
344     function feeTo() external view returns (address);
345 
346     function feeToSetter() external view returns (address);
347 
348     function getPair(address tokenA, address tokenB)
349         external
350         view
351         returns (address pair);
352 
353     function allPairs(uint256) external view returns (address pair);
354 
355     function allPairsLength() external view returns (uint256);
356 
357     function createPair(address tokenA, address tokenB)
358         external
359         returns (address pair);
360 
361     function setFeeTo(address) external;
362 
363     function setFeeToSetter(address) external;
364 }
365 
366 interface IUniswapV2Pair {
367     event Approval(
368         address indexed owner,
369         address indexed spender,
370         uint256 value
371     );
372     event Transfer(address indexed from, address indexed to, uint256 value);
373 
374     function name() external pure returns (string memory);
375 
376     function symbol() external pure returns (string memory);
377 
378     function decimals() external pure returns (uint8);
379 
380     function totalSupply() external view returns (uint256);
381 
382     function balanceOf(address owner) external view returns (uint256);
383 
384     function allowance(address owner, address spender)
385         external
386         view
387         returns (uint256);
388 
389     function approve(address spender, uint256 value) external returns (bool);
390 
391     function transfer(address to, uint256 value) external returns (bool);
392 
393     function transferFrom(
394         address from,
395         address to,
396         uint256 value
397     ) external returns (bool);
398 
399     function DOMAIN_SEPARATOR() external view returns (bytes32);
400 
401     function PERMIT_TYPEHASH() external pure returns (bytes32);
402 
403     function nonces(address owner) external view returns (uint256);
404 
405     function permit(
406         address owner,
407         address spender,
408         uint256 value,
409         uint256 deadline,
410         uint8 v,
411         bytes32 r,
412         bytes32 s
413     ) external;
414 
415     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
416     event Burn(
417         address indexed sender,
418         uint256 amount0,
419         uint256 amount1,
420         address indexed to
421     );
422     event Swap(
423         address indexed sender,
424         uint256 amount0In,
425         uint256 amount1In,
426         uint256 amount0Out,
427         uint256 amount1Out,
428         address indexed to
429     );
430     event Sync(uint112 reserve0, uint112 reserve1);
431 
432     function MINIMUM_LIQUIDITY() external pure returns (uint256);
433 
434     function factory() external view returns (address);
435 
436     function token0() external view returns (address);
437 
438     function token1() external view returns (address);
439 
440     function getReserves()
441         external
442         view
443         returns (
444             uint112 reserve0,
445             uint112 reserve1,
446             uint32 blockTimestampLast
447         );
448 
449     function price0CumulativeLast() external view returns (uint256);
450 
451     function price1CumulativeLast() external view returns (uint256);
452 
453     function kLast() external view returns (uint256);
454 
455     function mint(address to) external returns (uint256 liquidity);
456 
457     function burn(address to)
458         external
459         returns (uint256 amount0, uint256 amount1);
460 
461     function swap(
462         uint256 amount0Out,
463         uint256 amount1Out,
464         address to,
465         bytes calldata data
466     ) external;
467 
468     function skim(address to) external;
469 
470     function sync() external;
471 
472     function initialize(address, address) external;
473 }
474 
475 interface IUniswapV2Router02 {
476     function factory() external pure returns (address);
477 
478     function WETH() external pure returns (address);
479 
480     function addLiquidity(
481         address tokenA,
482         address tokenB,
483         uint256 amountADesired,
484         uint256 amountBDesired,
485         uint256 amountAMin,
486         uint256 amountBMin,
487         address to,
488         uint256 deadline
489     )
490         external
491         returns (
492             uint256 amountA,
493             uint256 amountB,
494             uint256 liquidity
495         );
496 
497     function addLiquidityETH(
498         address token,
499         uint256 amountTokenDesired,
500         uint256 amountTokenMin,
501         uint256 amountETHMin,
502         address to,
503         uint256 deadline
504     )
505         external
506         payable
507         returns (
508             uint256 amountToken,
509             uint256 amountETH,
510             uint256 liquidity
511         );
512 
513     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
514         uint256 amountIn,
515         uint256 amountOutMin,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external;
520 
521     function swapExactETHForTokensSupportingFeeOnTransferTokens(
522         uint256 amountOutMin,
523         address[] calldata path,
524         address to,
525         uint256 deadline
526     ) external payable;
527 
528     function swapExactTokensForETHSupportingFeeOnTransferTokens(
529         uint256 amountIn,
530         uint256 amountOutMin,
531         address[] calldata path,
532         address to,
533         uint256 deadline
534     ) external;
535 }
536 
537 contract ShibariumAI is ERC20, Ownable {
538     using SafeMath for uint256;
539 
540     IUniswapV2Router02 public immutable uniswapV2Router;
541     address public immutable uniswapV2Pair;
542     address public constant deadAddress = address(0xdead);
543     address public uniV2router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
544 
545     bool private swapping;
546 
547     address public treasuryWallet;
548     address public developmentWallet;
549     address public liquidityWallet;
550     address public operationsWallet;
551 
552     uint256 public maxTransaction;
553     uint256 public swapTokensAtAmount;
554     uint256 public maxWallet;
555 
556     bool public limitsInEffect = true;
557     bool public tradingActive = false;
558     bool public swapEnabled = false;
559 
560     // Anti-bot and anti-whale mappings and variables
561     mapping(address => uint256) private _holderLastTransferTimestamp;
562     bool public transferDelayEnabled = true;
563     uint256 private launchBlock;
564     mapping(address => bool) public blocked;
565 
566     uint256 public buyTotalFees;
567     uint256 public buyTreasuryFee;
568     uint256 public buyLiquidityFee;
569     uint256 public buyDevelopmentFee;
570     uint256 public buyOperationsFee;
571 
572     uint256 public sellTotalFees;
573     uint256 public sellTreasuryFee;
574     uint256 public sellLiquidityFee;
575     uint256 public sellDevelopmentFee;
576     uint256 public sellOperationsFee;
577 
578     uint256 public tokensForTreasury;
579     uint256 public tokensForLiquidity;
580     uint256 public tokensForDevelopment;
581     uint256 public tokensForOperations;
582 
583     mapping(address => bool) private _isExcludedFromFees;
584     mapping(address => bool) public _isExcludedmaxTransaction;
585 
586     mapping(address => bool) public automatedMarketMakerPairs;
587 
588     event UpdateUniswapV2Router(
589         address indexed newAddress,
590         address indexed oldAddress
591     );
592 
593     event ExcludeFromFees(address indexed account, bool isExcluded);
594 
595     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
596 
597     event treasuryWalletUpdated(
598         address indexed newWallet,
599         address indexed oldWallet
600     );
601 
602     event developmentWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607     event liquidityWalletUpdated(
608         address indexed newWallet,
609         address indexed oldWallet
610     );
611 
612     event operationsWalletUpdated(
613         address indexed newWallet,
614         address indexed oldWallet
615     );
616 
617     event SwapAndLiquify(
618         uint256 tokensSwapped,
619         uint256 ethReceived,
620         uint256 tokensIntoLiquidity
621     );
622 
623     constructor() ERC20("Shibarium AI", "shiAI") {
624         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniV2router); 
625 
626         excludeFromMaxTransaction(address(_uniswapV2Router), true);
627         uniswapV2Router = _uniswapV2Router;
628 
629         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
630         excludeFromMaxTransaction(address(uniswapV2Pair), true);
631         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
632 
633         // launch buy fees
634         uint256 _buyTreasuryFee = 2;
635         uint256 _buyLiquidityFee = 0;
636         uint256 _buyDevelopmentFee = 4;
637         uint256 _buyOperationsFee = 4;
638         
639         // launch sell fees
640         uint256 _sellTreasuryFee = 8;
641         uint256 _sellLiquidityFee = 0;
642         uint256 _sellDevelopmentFee = 15;
643         uint256 _sellOperationsFee = 15;
644 
645         uint256 totalSupply = 1_000_000 * 1e18;
646 
647         maxTransaction = 10_000 * 1e18; // 1% max transaction at launch
648         maxWallet = 20_000 * 1e18; // 2% max wallet at launch
649         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
650 
651         buyTreasuryFee = _buyTreasuryFee;
652         buyLiquidityFee = _buyLiquidityFee;
653         buyDevelopmentFee = _buyDevelopmentFee;
654         buyOperationsFee = _buyOperationsFee;
655         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
656 
657         sellTreasuryFee = _sellTreasuryFee;
658         sellLiquidityFee = _sellLiquidityFee;
659         sellDevelopmentFee = _sellDevelopmentFee;
660         sellOperationsFee = _sellOperationsFee;
661         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
662 
663         treasuryWallet = address(0x26Ec69d8883f4D0A381cDB2bEb45A151cd87f86D); 
664         developmentWallet = address(0xF5dfc7C11BB89199fA820CF8Ec7640F591C786cA); 
665         liquidityWallet = address(0x0AF222550f1fA4Fe9eCAdbC7A5158e59fF27024f); 
666         operationsWallet = address(0x412DA31CAE11bb9677797494af6E93F81112e87a);
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
683         require(!tradingActive, "Token launched");
684         tradingActive = true;
685         launchBlock = block.number;
686         swapEnabled = true;
687     }
688 
689     // remove limits after token is stable
690     function removeLimits() external onlyOwner returns (bool) {
691         limitsInEffect = false;
692         return true;
693     }
694 
695     // disable Transfer delay - cannot be reenabled
696     function disableTransferDelay() external onlyOwner returns (bool) {
697         transferDelayEnabled = false;
698         return true;
699     }
700 
701     // change the minimum amount of tokens to sell from fees
702     function updateSwapTokensAtAmount(uint256 newAmount)
703         external
704         onlyOwner
705         returns (bool)
706     {
707         require(
708             newAmount >= (totalSupply() * 1) / 100000,
709             "Swap amount cannot be lower than 0.001% total supply."
710         );
711         require(
712             newAmount <= (totalSupply() * 5) / 1000,
713             "Swap amount cannot be higher than 0.5% total supply."
714         );
715         swapTokensAtAmount = newAmount;
716         return true;
717     }
718 
719     function updateMaxTransaction(uint256 newNum) external onlyOwner {
720         require(
721             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
722             "Cannot set maxTransaction lower than 0.1%"
723         );
724         maxTransaction = newNum * (10**18);
725     }
726 
727     function updateMaxWallet(uint256 newNum) external onlyOwner {
728         require(
729             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
730             "Cannot set maxWallet lower than 0.5%"
731         );
732         maxWallet = newNum * (10**18);
733     }
734 
735     function excludeFromMaxTransaction(address updAds, bool isEx)
736         public
737         onlyOwner
738     {
739         _isExcludedmaxTransaction[updAds] = isEx;
740     }
741 
742     // only use to disable contract sales if absolutely necessary (emergency use only)
743     function updateSwapEnabled(bool enabled) external onlyOwner {
744         swapEnabled = enabled;
745     }
746 
747     function updateBuyFees(
748         uint256 _treasuryFee,
749         uint256 _liquidityFee,
750         uint256 _developmentFee,
751         uint256 _operationsFee
752     ) external onlyOwner {
753         buyTreasuryFee = _treasuryFee;
754         buyLiquidityFee = _liquidityFee;
755         buyDevelopmentFee = _developmentFee;
756         buyOperationsFee = _operationsFee;
757         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
758         require(buyTotalFees <= 99);
759     }
760 
761     function updateSellFees(
762         uint256 _treasuryFee,
763         uint256 _liquidityFee,
764         uint256 _developmentFee,
765         uint256 _operationsFee
766     ) external onlyOwner {
767         sellTreasuryFee = _treasuryFee;
768         sellLiquidityFee = _liquidityFee;
769         sellDevelopmentFee = _developmentFee;
770         sellOperationsFee = _operationsFee;
771         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
772         require(sellTotalFees <= 99); 
773     }
774 
775     function excludeFromFees(address account, bool excluded) public onlyOwner {
776         _isExcludedFromFees[account] = excluded;
777         emit ExcludeFromFees(account, excluded);
778     }
779 
780     function setAutomatedMarketMakerPair(address pair, bool value)
781         public
782         onlyOwner
783     {
784         require(
785             pair != uniswapV2Pair,
786             "The pair cannot be removed from automatedMarketMakerPairs"
787         );
788 
789         _setAutomatedMarketMakerPair(pair, value);
790     }
791 
792     function _setAutomatedMarketMakerPair(address pair, bool value) private {
793         automatedMarketMakerPairs[pair] = value;
794 
795         emit SetAutomatedMarketMakerPair(pair, value);
796     }
797 
798     function updatetreasuryWallet(address newtreasuryWallet) external onlyOwner {
799         emit treasuryWalletUpdated(newtreasuryWallet, treasuryWallet);
800         treasuryWallet = newtreasuryWallet;
801     }
802 
803     function updatedevelopmentWallet(address newWallet) external onlyOwner {
804         emit developmentWalletUpdated(newWallet, developmentWallet);
805         developmentWallet = newWallet;
806     }
807 
808     function updateoperationsWallet(address newWallet) external onlyOwner{
809         emit operationsWalletUpdated(newWallet, operationsWallet);
810         operationsWallet = newWallet;
811     }
812 
813     function updateliquidityWallet(address newliquidityWallet) external onlyOwner {
814         emit liquidityWalletUpdated(newliquidityWallet, liquidityWallet);
815         liquidityWallet = newliquidityWallet;
816     }
817 
818     function isExcludedFromFees(address account) public view returns (bool) {
819         return _isExcludedFromFees[account];
820     }
821 
822     function _transfer(
823         address from,
824         address to,
825         uint256 amount
826     ) internal override {
827         require(from != address(0), "ERC20: transfer from the zero address");
828         require(to != address(0), "ERC20: transfer to the zero address");
829         require(!blocked[from], "Sniper blocked");
830 
831         if (amount == 0) {
832             super._transfer(from, to, 0);
833             return;
834         }
835 
836         if (limitsInEffect) {
837             if (
838                 from != owner() &&
839                 to != owner() &&
840                 to != address(0) &&
841                 to != address(0xdead) &&
842                 !swapping
843             ) {
844                 if (!tradingActive) {
845                     require(
846                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
847                         "Trading is not active."
848                     );
849                 }
850 
851                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
852                 if (transferDelayEnabled) {
853                     if (
854                         to != owner() &&
855                         to != address(uniswapV2Router) &&
856                         to != address(uniswapV2Pair)
857                     ) {
858                         require(
859                             _holderLastTransferTimestamp[tx.origin] <
860                                 block.number,
861                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
862                         );
863                         _holderLastTransferTimestamp[tx.origin] = block.number;
864                     }
865                 }
866 
867                 //when buy
868                 if (
869                     automatedMarketMakerPairs[from] &&
870                     !_isExcludedmaxTransaction[to]
871                 ) {
872                     require(
873                         amount <= maxTransaction,
874                         "Buy transfer amount exceeds the maxTransaction."
875                     );
876                     require(
877                         amount + balanceOf(to) <= maxWallet,
878                         "Max wallet exceeded"
879                     );
880                 }
881                 //when sell
882                 else if (
883                     automatedMarketMakerPairs[to] &&
884                     !_isExcludedmaxTransaction[from]
885                 ) {
886                     require(
887                         amount <= maxTransaction,
888                         "Sell transfer amount exceeds the maxTransaction."
889                     );
890                 } else if (!_isExcludedmaxTransaction[to]) {
891                     require(
892                         amount + balanceOf(to) <= maxWallet,
893                         "Max wallet exceeded"
894                     );
895                 }
896             }
897         }
898 
899         uint256 contractTokenBalance = balanceOf(address(this));
900 
901         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
902 
903         if (
904             canSwap &&
905             swapEnabled &&
906             !swapping &&
907             !automatedMarketMakerPairs[from] &&
908             !_isExcludedFromFees[from] &&
909             !_isExcludedFromFees[to]
910         ) {
911             swapping = true;
912 
913             swapBack();
914 
915             swapping = false;
916         }
917 
918         bool takeFee = !swapping;
919 
920         // if any account belongs to _isExcludedFromFee account then remove the fee
921         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
922             takeFee = false;
923         }
924 
925         uint256 fees = 0;
926         // only take fees on buys/sells, do not take on wallet transfers
927         if (takeFee) {
928             // on sell
929             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
930                 fees = amount.mul(sellTotalFees).div(100);
931                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
932                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
933                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
934                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
935             }
936             // on buy
937             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
938                 fees = amount.mul(buyTotalFees).div(100);
939                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
940                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
941                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
942                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
943             }
944 
945             if (fees > 0) {
946                 super._transfer(from, address(this), fees);
947             }
948 
949             amount -= fees;
950         }
951 
952         super._transfer(from, to, amount);
953     }
954 
955     function swapTokensForEth(uint256 tokenAmount) private {
956         // generate the uniswap pair path of token -> weth
957         address[] memory path = new address[](2);
958         path[0] = address(this);
959         path[1] = uniswapV2Router.WETH();
960 
961         _approve(address(this), address(uniswapV2Router), tokenAmount);
962 
963         // make the swap
964         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
965             tokenAmount,
966             0, // accept any amount of ETH
967             path,
968             address(this),
969             block.timestamp
970         );
971     }
972 
973     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
974         // approve token transfer to cover all possible scenarios
975         _approve(address(this), address(uniswapV2Router), tokenAmount);
976 
977         // add the liquidity
978         uniswapV2Router.addLiquidityETH{value: ethAmount}(
979             address(this),
980             tokenAmount,
981             0, // slippage is unavoidable
982             0, // slippage is unavoidable
983             liquidityWallet,
984             block.timestamp
985         );
986     }
987 
988     function updateBL(address[] calldata blockees, bool shouldBlock) external onlyOwner {
989         for(uint256 i = 0;i<blockees.length;i++){
990             address blockee = blockees[i];
991             if(blockee != address(this) && 
992                blockee != uniV2router && 
993                blockee != address(uniswapV2Pair))
994                 blocked[blockee] = shouldBlock;
995         }
996     }
997 
998     function swapBack() private {
999         uint256 contractBalance = balanceOf(address(this));
1000         uint256 totalTokensToSwap = tokensForLiquidity +
1001             tokensForTreasury +
1002             tokensForDevelopment +
1003             tokensForOperations;
1004         bool success;
1005 
1006         if (contractBalance == 0 || totalTokensToSwap == 0) {
1007             return;
1008         }
1009 
1010         if (contractBalance > swapTokensAtAmount * 20) {
1011             contractBalance = swapTokensAtAmount * 20;
1012         }
1013 
1014         // Halve the amount of liquidity tokens
1015         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1016         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1017 
1018         uint256 initialETHBalance = address(this).balance;
1019 
1020         swapTokensForEth(amountToSwapForETH);
1021 
1022         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1023 
1024         uint256 ethForMark = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
1025         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);
1026         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1027 
1028         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDevelopment - ethForOperations;
1029 
1030         tokensForLiquidity = 0;
1031         tokensForTreasury = 0;
1032         tokensForDevelopment = 0;
1033         tokensForOperations = 0;
1034 
1035         (success, ) = address(developmentWallet).call{value: ethForDevelopment}("");
1036 
1037         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1038             addLiquidity(liquidityTokens, ethForLiquidity);
1039             emit SwapAndLiquify(
1040                 amountToSwapForETH,
1041                 ethForLiquidity,
1042                 tokensForLiquidity
1043             );
1044         }
1045         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1046         (success, ) = address(treasuryWallet).call{value: address(this).balance}("");
1047     }
1048 }