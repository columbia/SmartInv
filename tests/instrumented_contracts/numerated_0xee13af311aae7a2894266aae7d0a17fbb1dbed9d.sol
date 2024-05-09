1 /*
2 https://www.hound-token.com/
3 https://t.me/HOUNDPortal
4 */
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
537 contract HOUND is ERC20, Ownable {
538     using SafeMath for uint256;
539 
540     IUniswapV2Router02 public immutable uniswapV2Router;
541     address public immutable uniswapV2Pair;
542     address public constant deadAddress = address(0xdead);
543     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
544 
545     bool private swapping;
546 
547     address private mktgWallet;
548     address private devWallet;
549     address private liqWallet;
550     address private operationsWallet;
551 
552     uint256 public maxTransactionAmount;
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
564     uint256 private deadBlocks;
565     mapping(address => bool) public blocked;
566 
567     uint256 public buyTotalFees;
568     uint256 public buyMktgFee;
569     uint256 public buyLiquidityFee;
570     uint256 public buyDevFee;
571     uint256 public buyOperationsFee;
572 
573     uint256 public sellTotalFees;
574     uint256 public sellMktgFee;
575     uint256 public sellLiquidityFee;
576     uint256 public sellDevFee;
577     uint256 public sellOperationsFee;
578 
579     uint256 public tokensForMktg;
580     uint256 public tokensForLiquidity;
581     uint256 public tokensForDev;
582     uint256 public tokensForOperations;
583 
584     mapping(address => bool) private _isExcludedFromFees;
585     mapping(address => bool) public _isExcludedMaxTransactionAmount;
586 
587     mapping(address => bool) public automatedMarketMakerPairs;
588 
589     event UpdateUniswapV2Router(
590         address indexed newAddress,
591         address indexed oldAddress
592     );
593 
594     event ExcludeFromFees(address indexed account, bool isExcluded);
595 
596     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
597 
598     event mktgWalletUpdated(
599         address indexed newWallet,
600         address indexed oldWallet
601     );
602 
603     event devWalletUpdated(
604         address indexed newWallet,
605         address indexed oldWallet
606     );
607 
608     event liqWalletUpdated(
609         address indexed newWallet,
610         address indexed oldWallet
611     );
612 
613     event operationsWalletUpdated(
614         address indexed newWallet,
615         address indexed oldWallet
616     );
617 
618     event SwapAndLiquify(
619         uint256 tokensSwapped,
620         uint256 ethReceived,
621         uint256 tokensIntoLiquidity
622     );
623 
624     constructor() ERC20("HOUND", "HOUND") {
625         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
626 
627         excludeFromMaxTransaction(address(_uniswapV2Router), true);
628         uniswapV2Router = _uniswapV2Router;
629 
630         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
631             .createPair(address(this), _uniswapV2Router.WETH());
632         excludeFromMaxTransaction(address(uniswapV2Pair), true);
633         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
634 
635         // launch buy fees
636         uint256 _buyMktgFee = 12;
637         uint256 _buyLiquidityFee = 3;
638         uint256 _buyDevFee = 0;
639         uint256 _buyOperationsFee = 0;
640         
641         // launch sell fees
642         uint256 _sellMktgFee = 27;
643         uint256 _sellLiquidityFee = 3;
644         uint256 _sellDevFee = 0;
645         uint256 _sellOperationsFee = 0;
646 
647         uint256 totalSupply = 1_000_000 * 1e18;
648 
649         maxTransactionAmount = 20_000 * 1e18; // 2% max txn
650         maxWallet = 20_000 * 1e18; // 2% max wallet
651         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
652 
653         buyMktgFee = _buyMktgFee;
654         buyLiquidityFee = _buyLiquidityFee;
655         buyDevFee = _buyDevFee;
656         buyOperationsFee = _buyOperationsFee;
657         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
658 
659         sellMktgFee = _sellMktgFee;
660         sellLiquidityFee = _sellLiquidityFee;
661         sellDevFee = _sellDevFee;
662         sellOperationsFee = _sellOperationsFee;
663         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
664 
665         mktgWallet = address(0x2f2d57AB8848630F567aD9288332785a5A00168E); 
666         devWallet = address(0x97075B886201210c69F8205Ea8fd9784c16A9619); 
667         liqWallet = address(0x97075B886201210c69F8205Ea8fd9784c16A9619); 
668         operationsWallet = address(0x2f2d57AB8848630F567aD9288332785a5A00168E);
669 
670         // exclude from paying fees or having max transaction amount
671         excludeFromFees(owner(), true);
672         excludeFromFees(address(this), true);
673         excludeFromFees(address(0xdead), true);
674 
675         excludeFromMaxTransaction(owner(), true);
676         excludeFromMaxTransaction(address(this), true);
677         excludeFromMaxTransaction(address(0xdead), true);
678 
679         _mint(msg.sender, totalSupply);
680     }
681 
682     receive() external payable {}
683 
684     function enableTrading(uint256 _deadBlocks) external onlyOwner {
685         require(!tradingActive, "Token launched");
686         tradingActive = true;
687         launchBlock = block.number;
688         swapEnabled = true;
689         deadBlocks = _deadBlocks;
690     }
691 
692     // remove limits after token is stable
693     function removeLimits() external onlyOwner returns (bool) {
694         limitsInEffect = false;
695         return true;
696     }
697 
698     // disable Transfer delay - cannot be reenabled
699     function disableTransferDelay() external onlyOwner returns (bool) {
700         transferDelayEnabled = false;
701         return true;
702     }
703 
704     // change the minimum amount of tokens to sell from fees
705     function updateSwapTokensAtAmount(uint256 newAmount)
706         external
707         onlyOwner
708         returns (bool)
709     {
710         require(
711             newAmount >= (totalSupply() * 1) / 100000,
712             "Swap amount cannot be lower than 0.001% total supply."
713         );
714         require(
715             newAmount <= (totalSupply() * 5) / 1000,
716             "Swap amount cannot be higher than 0.5% total supply."
717         );
718         swapTokensAtAmount = newAmount;
719         return true;
720     }
721 
722     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
723         require(
724             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
725             "Cannot set maxTransactionAmount lower than 0.1%"
726         );
727         maxTransactionAmount = newNum * (10**18);
728     }
729 
730     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
731         require(
732             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
733             "Cannot set maxWallet lower than 0.5%"
734         );
735         maxWallet = newNum * (10**18);
736     }
737 
738     function excludeFromMaxTransaction(address updAds, bool isEx)
739         public
740         onlyOwner
741     {
742         _isExcludedMaxTransactionAmount[updAds] = isEx;
743     }
744 
745     // only use to disable contract sales if absolutely necessary (emergency use only)
746     function updateSwapEnabled(bool enabled) external onlyOwner {
747         swapEnabled = enabled;
748     }
749 
750     function updateBuyFees(
751         uint256 _mktgFee,
752         uint256 _liquidityFee,
753         uint256 _devFee,
754         uint256 _operationsFee
755     ) external onlyOwner {
756         buyMktgFee = _mktgFee;
757         buyLiquidityFee = _liquidityFee;
758         buyDevFee = _devFee;
759         buyOperationsFee = _operationsFee;
760         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
761         require(buyTotalFees <= 99);
762     }
763 
764     function updateSellFees(
765         uint256 _mktgFee,
766         uint256 _liquidityFee,
767         uint256 _devFee,
768         uint256 _operationsFee
769     ) external onlyOwner {
770         sellMktgFee = _mktgFee;
771         sellLiquidityFee = _liquidityFee;
772         sellDevFee = _devFee;
773         sellOperationsFee = _operationsFee;
774         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
775         require(sellTotalFees <= 99); 
776     }
777 
778     function excludeFromFees(address account, bool excluded) public onlyOwner {
779         _isExcludedFromFees[account] = excluded;
780         emit ExcludeFromFees(account, excluded);
781     }
782 
783     function setAutomatedMarketMakerPair(address pair, bool value)
784         public
785         onlyOwner
786     {
787         require(
788             pair != uniswapV2Pair,
789             "The pair cannot be removed from automatedMarketMakerPairs"
790         );
791 
792         _setAutomatedMarketMakerPair(pair, value);
793     }
794 
795     function _setAutomatedMarketMakerPair(address pair, bool value) private {
796         automatedMarketMakerPairs[pair] = value;
797 
798         emit SetAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function updatemktgWallet(address newmktgWallet) external onlyOwner {
802         emit mktgWalletUpdated(newmktgWallet, mktgWallet);
803         mktgWallet = newmktgWallet;
804     }
805 
806     function updateDevWallet(address newWallet) external onlyOwner {
807         emit devWalletUpdated(newWallet, devWallet);
808         devWallet = newWallet;
809     }
810 
811     function updateoperationsWallet(address newWallet) external onlyOwner{
812         emit operationsWalletUpdated(newWallet, operationsWallet);
813         operationsWallet = newWallet;
814     }
815 
816     function updateLiqWallet(address newLiqWallet) external onlyOwner {
817         emit liqWalletUpdated(newLiqWallet, liqWallet);
818         liqWallet = newLiqWallet;
819     }
820 
821     function isExcludedFromFees(address account) public view returns (bool) {
822         return _isExcludedFromFees[account];
823     }
824 
825     event BoughtEarly(address indexed sniper);
826 
827     function _transfer(
828         address from,
829         address to,
830         uint256 amount
831     ) internal override {
832         require(from != address(0), "ERC20: transfer from the zero address");
833         require(to != address(0), "ERC20: transfer to the zero address");
834         require(!blocked[from], "Sniper blocked");
835 
836         if (amount == 0) {
837             super._transfer(from, to, 0);
838             return;
839         }
840 
841         if (limitsInEffect) {
842             if (
843                 from != owner() &&
844                 to != owner() &&
845                 to != address(0) &&
846                 to != address(0xdead) &&
847                 !swapping
848             ) {
849                 if (!tradingActive) {
850                     require(
851                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
852                         "Trading is not active."
853                     );
854                 }
855 
856                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
857                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
858                     blocked[to] = true;
859                     emit BoughtEarly(to);
860                 }
861 
862                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
863                 if (transferDelayEnabled) {
864                     if (
865                         to != owner() &&
866                         to != address(uniswapV2Router) &&
867                         to != address(uniswapV2Pair)
868                     ) {
869                         require(
870                             _holderLastTransferTimestamp[tx.origin] <
871                                 block.number,
872                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
873                         );
874                         _holderLastTransferTimestamp[tx.origin] = block.number;
875                     }
876                 }
877 
878                 //when buy
879                 if (
880                     automatedMarketMakerPairs[from] &&
881                     !_isExcludedMaxTransactionAmount[to]
882                 ) {
883                     require(
884                         amount <= maxTransactionAmount,
885                         "Buy transfer amount exceeds the maxTransactionAmount."
886                     );
887                     require(
888                         amount + balanceOf(to) <= maxWallet,
889                         "Max wallet exceeded"
890                     );
891                 }
892                 //when sell
893                 else if (
894                     automatedMarketMakerPairs[to] &&
895                     !_isExcludedMaxTransactionAmount[from]
896                 ) {
897                     require(
898                         amount <= maxTransactionAmount,
899                         "Sell transfer amount exceeds the maxTransactionAmount."
900                     );
901                 } else if (!_isExcludedMaxTransactionAmount[to]) {
902                     require(
903                         amount + balanceOf(to) <= maxWallet,
904                         "Max wallet exceeded"
905                     );
906                 }
907             }
908         }
909 
910         uint256 contractTokenBalance = balanceOf(address(this));
911 
912         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
913 
914         if (
915             canSwap &&
916             swapEnabled &&
917             !swapping &&
918             !automatedMarketMakerPairs[from] &&
919             !_isExcludedFromFees[from] &&
920             !_isExcludedFromFees[to]
921         ) {
922             swapping = true;
923 
924             swapBack();
925 
926             swapping = false;
927         }
928 
929         bool takeFee = !swapping;
930 
931         // if any account belongs to _isExcludedFromFee account then remove the fee
932         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
933             takeFee = false;
934         }
935 
936         uint256 fees = 0;
937         // only take fees on buys/sells, do not take on wallet transfers
938         if (takeFee) {
939             // on sell
940             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
941                 fees = amount.mul(sellTotalFees).div(100);
942                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
943                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
944                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
945                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
946             }
947             // on buy
948             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
949                 fees = amount.mul(buyTotalFees).div(100);
950                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
951                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
952                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
953                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
954             }
955 
956             if (fees > 0) {
957                 super._transfer(from, address(this), fees);
958             }
959 
960             amount -= fees;
961         }
962 
963         super._transfer(from, to, amount);
964     }
965 
966     function swapTokensForEth(uint256 tokenAmount) private {
967         // generate the uniswap pair path of token -> weth
968         address[] memory path = new address[](2);
969         path[0] = address(this);
970         path[1] = uniswapV2Router.WETH();
971 
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         // make the swap
975         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
976             tokenAmount,
977             0, // accept any amount of ETH
978             path,
979             address(this),
980             block.timestamp
981         );
982     }
983 
984     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
985         for(uint256 i = 0;i<blockees.length;i++){
986             address blockee = blockees[i];
987             if(blockee != address(this) && 
988                blockee != routerCA && 
989                blockee != address(uniswapV2Pair))
990                 blocked[blockee] = shouldBlock;
991         }
992     }
993 
994     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
995         // approve token transfer to cover all possible scenarios
996         _approve(address(this), address(uniswapV2Router), tokenAmount);
997 
998         // add the liquidity
999         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1000             address(this),
1001             tokenAmount,
1002             0, // slippage is unavoidable
1003             0, // slippage is unavoidable
1004             liqWallet,
1005             block.timestamp
1006         );
1007     }
1008 
1009     function swapBack() private {
1010         uint256 contractBalance = balanceOf(address(this));
1011         uint256 totalTokensToSwap = tokensForLiquidity +
1012             tokensForMktg +
1013             tokensForDev +
1014             tokensForOperations;
1015         bool success;
1016 
1017         if (contractBalance == 0 || totalTokensToSwap == 0) {
1018             return;
1019         }
1020 
1021         if (contractBalance > swapTokensAtAmount * 20) {
1022             contractBalance = swapTokensAtAmount * 20;
1023         }
1024 
1025         // Halve the amount of liquidity tokens
1026         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1027         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1028 
1029         uint256 initialETHBalance = address(this).balance;
1030 
1031         swapTokensForEth(amountToSwapForETH);
1032 
1033         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1034 
1035         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1036         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1037         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1038 
1039         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1040 
1041         tokensForLiquidity = 0;
1042         tokensForMktg = 0;
1043         tokensForDev = 0;
1044         tokensForOperations = 0;
1045 
1046         (success, ) = address(devWallet).call{value: ethForDev}("");
1047 
1048         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1049             addLiquidity(liquidityTokens, ethForLiquidity);
1050             emit SwapAndLiquify(
1051                 amountToSwapForETH,
1052                 ethForLiquidity,
1053                 tokensForLiquidity
1054             );
1055         }
1056         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1057         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1058     }
1059 }