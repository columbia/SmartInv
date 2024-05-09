1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     function owner() public view virtual returns (address) {
25         return _owner;
26     }
27 
28     modifier onlyOwner() {
29         require(owner() == _msgSender(), "Ownable: caller is not the owner");
30         _;
31     }
32 
33     function renounceOwnership() public virtual onlyOwner {
34         _transferOwnership(address(0));
35     }
36 
37     function transferOwnership(address newOwner) public virtual onlyOwner {
38         require(newOwner != address(0), "Ownable: new owner is the zero address");
39         _transferOwnership(newOwner);
40     }
41 
42     function _transferOwnership(address newOwner) internal virtual {
43         address oldOwner = _owner;
44         _owner = newOwner;
45         emit OwnershipTransferred(oldOwner, newOwner);
46     }
47 }
48 
49 interface IERC20 {
50 
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address account) external view returns (uint256);
54 
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 interface IERC20Metadata is IERC20 {
73 
74     function name() external view returns (string memory);
75 
76     function symbol() external view returns (string memory);
77 
78     function decimals() external view returns (uint8);
79 }
80 
81 contract ERC20 is Context, IERC20, IERC20Metadata {
82     mapping(address => uint256) private _balances;
83 
84     mapping(address => mapping(address => uint256)) private _allowances;
85 
86     uint256 private _totalSupply;
87 
88     string private _name;
89     string private _symbol;
90 
91     constructor(string memory name_, string memory symbol_) {
92         _name = name_;
93         _symbol = symbol_;
94     }
95 
96     function name() public view virtual override returns (string memory) {
97         return _name;
98     }
99 
100     function symbol() public view virtual override returns (string memory) {
101         return _symbol;
102     }
103 
104     function decimals() public view virtual override returns (uint8) {
105         return 18;
106     }
107 
108     function totalSupply() public view virtual override returns (uint256) {
109         return _totalSupply;
110     }
111 
112     function balanceOf(address account) public view virtual override returns (uint256) {
113         return _balances[account];
114     }
115 
116     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
117         _transfer(_msgSender(), recipient, amount);
118         return true;
119     }
120 
121     function allowance(address owner, address spender) public view virtual override returns (uint256) {
122         return _allowances[owner][spender];
123     }
124 
125     function approve(address spender, uint256 amount) public virtual override returns (bool) {
126         _approve(_msgSender(), spender, amount);
127         return true;
128     }
129 
130     function transferFrom(
131         address sender,
132         address recipient,
133         uint256 amount
134     ) public virtual override returns (bool) {
135         _transfer(sender, recipient, amount);
136 
137         uint256 currentAllowance = _allowances[sender][_msgSender()];
138         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
139         unchecked {
140             _approve(sender, _msgSender(), currentAllowance - amount);
141         }
142 
143         return true;
144     }
145 
146     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
148         return true;
149     }
150 
151     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
152         uint256 currentAllowance = _allowances[_msgSender()][spender];
153         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
154         unchecked {
155             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
156         }
157 
158         return true;
159     }
160 
161     function _transfer(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) internal virtual {
166         require(sender != address(0), "ERC20: transfer from the zero address");
167         require(recipient != address(0), "ERC20: transfer to the zero address");
168 
169         _beforeTokenTransfer(sender, recipient, amount);
170 
171         uint256 senderBalance = _balances[sender];
172         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
173         unchecked {
174             _balances[sender] = senderBalance - amount;
175         }
176         _balances[recipient] += amount;
177 
178         emit Transfer(sender, recipient, amount);
179 
180         _afterTokenTransfer(sender, recipient, amount);
181     }
182 
183     function _mint(address account, uint256 amount) internal virtual {
184         require(account != address(0), "ERC20: mint to the zero address");
185 
186         _beforeTokenTransfer(address(0), account, amount);
187 
188         _totalSupply += amount;
189         _balances[account] += amount;
190         emit Transfer(address(0), account, amount);
191 
192         _afterTokenTransfer(address(0), account, amount);
193     }
194 
195     function _burn(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: burn from the zero address");
197 
198         _beforeTokenTransfer(account, address(0), amount);
199 
200         uint256 accountBalance = _balances[account];
201         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
202         unchecked {
203             _balances[account] = accountBalance - amount;
204         }
205         _totalSupply -= amount;
206 
207         emit Transfer(account, address(0), amount);
208 
209         _afterTokenTransfer(account, address(0), amount);
210     }
211 
212     function _approve(
213         address owner,
214         address spender,
215         uint256 amount
216     ) internal virtual {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219 
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _beforeTokenTransfer(
225         address from,
226         address to,
227         uint256 amount
228     ) internal virtual {}
229 
230     function _afterTokenTransfer(
231         address from,
232         address to,
233         uint256 amount
234     ) internal virtual {}
235 }
236 
237 library SafeMath {
238 
239     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             uint256 c = a + b;
242             if (c < a) return (false, 0);
243             return (true, c);
244         }
245     }
246 
247     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             if (b > a) return (false, 0);
250             return (true, a - b);
251         }
252     }
253 
254     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
255         unchecked {
256             if (a == 0) return (true, 0);
257             uint256 c = a * b;
258             if (c / a != b) return (false, 0);
259             return (true, c);
260         }
261     }
262 
263     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             if (b == 0) return (false, 0);
266             return (true, a / b);
267         }
268     }
269 
270     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             if (b == 0) return (false, 0);
273             return (true, a % b);
274         }
275     }
276 
277     function add(uint256 a, uint256 b) internal pure returns (uint256) {
278         return a + b;
279     }
280 
281     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a - b;
283     }
284 
285     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a * b;
287     }
288 
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a / b;
291     }
292 
293     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a % b;
295     }
296 
297     function sub(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b <= a, errorMessage);
304             return a - b;
305         }
306     }
307 
308     function div(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b > 0, errorMessage);
315             return a / b;
316         }
317     }
318 
319     function mod(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b > 0, errorMessage);
326             return a % b;
327         }
328     }
329 }
330 
331 interface IUniswapV2Factory {
332     event PairCreated(
333         address indexed token0,
334         address indexed token1,
335         address pair,
336         uint256
337     );
338 
339     function feeTo() external view returns (address);
340 
341     function feeToSetter() external view returns (address);
342 
343     function getPair(address tokenA, address tokenB)
344         external
345         view
346         returns (address pair);
347 
348     function allPairs(uint256) external view returns (address pair);
349 
350     function allPairsLength() external view returns (uint256);
351 
352     function createPair(address tokenA, address tokenB)
353         external
354         returns (address pair);
355 
356     function setFeeTo(address) external;
357 
358     function setFeeToSetter(address) external;
359 }
360 
361 interface IUniswapV2Pair {
362     event Approval(
363         address indexed owner,
364         address indexed spender,
365         uint256 value
366     );
367     event Transfer(address indexed from, address indexed to, uint256 value);
368 
369     function name() external pure returns (string memory);
370 
371     function symbol() external pure returns (string memory);
372 
373     function decimals() external pure returns (uint8);
374 
375     function totalSupply() external view returns (uint256);
376 
377     function balanceOf(address owner) external view returns (uint256);
378 
379     function allowance(address owner, address spender)
380         external
381         view
382         returns (uint256);
383 
384     function approve(address spender, uint256 value) external returns (bool);
385 
386     function transfer(address to, uint256 value) external returns (bool);
387 
388     function transferFrom(
389         address from,
390         address to,
391         uint256 value
392     ) external returns (bool);
393 
394     function DOMAIN_SEPARATOR() external view returns (bytes32);
395 
396     function PERMIT_TYPEHASH() external pure returns (bytes32);
397 
398     function nonces(address owner) external view returns (uint256);
399 
400     function permit(
401         address owner,
402         address spender,
403         uint256 value,
404         uint256 deadline,
405         uint8 v,
406         bytes32 r,
407         bytes32 s
408     ) external;
409 
410     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
411     event Burn(
412         address indexed sender,
413         uint256 amount0,
414         uint256 amount1,
415         address indexed to
416     );
417     event Swap(
418         address indexed sender,
419         uint256 amount0In,
420         uint256 amount1In,
421         uint256 amount0Out,
422         uint256 amount1Out,
423         address indexed to
424     );
425     event Sync(uint112 reserve0, uint112 reserve1);
426 
427     function MINIMUM_LIQUIDITY() external pure returns (uint256);
428 
429     function factory() external view returns (address);
430 
431     function token0() external view returns (address);
432 
433     function token1() external view returns (address);
434 
435     function getReserves()
436         external
437         view
438         returns (
439             uint112 reserve0,
440             uint112 reserve1,
441             uint32 blockTimestampLast
442         );
443 
444     function price0CumulativeLast() external view returns (uint256);
445 
446     function price1CumulativeLast() external view returns (uint256);
447 
448     function kLast() external view returns (uint256);
449 
450     function mint(address to) external returns (uint256 liquidity);
451 
452     function burn(address to)
453         external
454         returns (uint256 amount0, uint256 amount1);
455 
456     function swap(
457         uint256 amount0Out,
458         uint256 amount1Out,
459         address to,
460         bytes calldata data
461     ) external;
462 
463     function skim(address to) external;
464 
465     function sync() external;
466 
467     function initialize(address, address) external;
468 }
469 
470 interface IUniswapV2Router02 {
471     function factory() external pure returns (address);
472 
473     function WETH() external pure returns (address);
474 
475     function addLiquidity(
476         address tokenA,
477         address tokenB,
478         uint256 amountADesired,
479         uint256 amountBDesired,
480         uint256 amountAMin,
481         uint256 amountBMin,
482         address to,
483         uint256 deadline
484     )
485         external
486         returns (
487             uint256 amountA,
488             uint256 amountB,
489             uint256 liquidity
490         );
491 
492     function addLiquidityETH(
493         address token,
494         uint256 amountTokenDesired,
495         uint256 amountTokenMin,
496         uint256 amountETHMin,
497         address to,
498         uint256 deadline
499     )
500         external
501         payable
502         returns (
503             uint256 amountToken,
504             uint256 amountETH,
505             uint256 liquidity
506         );
507 
508     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
509         uint256 amountIn,
510         uint256 amountOutMin,
511         address[] calldata path,
512         address to,
513         uint256 deadline
514     ) external;
515 
516     function swapExactETHForTokensSupportingFeeOnTransferTokens(
517         uint256 amountOutMin,
518         address[] calldata path,
519         address to,
520         uint256 deadline
521     ) external payable;
522 
523     function swapExactTokensForETHSupportingFeeOnTransferTokens(
524         uint256 amountIn,
525         uint256 amountOutMin,
526         address[] calldata path,
527         address to,
528         uint256 deadline
529     ) external;
530 }
531 
532 contract KINA is ERC20, Ownable {
533     using SafeMath for uint256;
534 
535     IUniswapV2Router02 public immutable uniswapV2Router;
536     address public immutable uniswapV2Pair;
537     address public constant deadAddress = address(0xdead);
538     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
539 
540     bool private swapping;
541 
542     address public mktgWallet;
543     address public devWallet;
544     address public liqWallet;
545     address public operationsWallet;
546 
547     uint256 public maxTransactionAmount;
548     uint256 public swapTokensAtAmount;
549     uint256 public maxWallet;
550 
551     bool public limitsInEffect = true;
552     bool public tradingActive = false;
553     bool public swapEnabled = false;
554 
555     // Anti-bot and anti-whale mappings and variables
556     mapping(address => uint256) private _holderLastTransferTimestamp;
557     bool public transferDelayEnabled = true;
558     uint256 private launchBlock;
559     uint256 private deadBlocks;
560     mapping(address => bool) public blocked;
561 
562     uint256 public buyTotalFees;
563     uint256 public buyMktgFee;
564     uint256 public buyLiquidityFee;
565     uint256 public buyDevFee;
566     uint256 public buyOperationsFee;
567 
568     uint256 public sellTotalFees;
569     uint256 public sellMktgFee;
570     uint256 public sellLiquidityFee;
571     uint256 public sellDevFee;
572     uint256 public sellOperationsFee;
573 
574     uint256 public tokensForMktg;
575     uint256 public tokensForLiquidity;
576     uint256 public tokensForDev;
577     uint256 public tokensForOperations;
578 
579     mapping(address => bool) private _isExcludedFromFees;
580     mapping(address => bool) public _isExcludedMaxTransactionAmount;
581 
582     mapping(address => bool) public automatedMarketMakerPairs;
583 
584     event UpdateUniswapV2Router(
585         address indexed newAddress,
586         address indexed oldAddress
587     );
588 
589     event ExcludeFromFees(address indexed account, bool isExcluded);
590 
591     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
592 
593     event mktgWalletUpdated(
594         address indexed newWallet,
595         address indexed oldWallet
596     );
597 
598     event devWalletUpdated(
599         address indexed newWallet,
600         address indexed oldWallet
601     );
602 
603     event liqWalletUpdated(
604         address indexed newWallet,
605         address indexed oldWallet
606     );
607 
608     event operationsWalletUpdated(
609         address indexed newWallet,
610         address indexed oldWallet
611     );
612 
613     event SwapAndLiquify(
614         uint256 tokensSwapped,
615         uint256 ethReceived,
616         uint256 tokensIntoLiquidity
617     );
618 
619     constructor() ERC20("Kina Inu", "KINA") {
620         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
621 
622         excludeFromMaxTransaction(address(_uniswapV2Router), true);
623         uniswapV2Router = _uniswapV2Router;
624 
625         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
626             .createPair(address(this), _uniswapV2Router.WETH());
627         excludeFromMaxTransaction(address(uniswapV2Pair), true);
628         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
629 
630         // launch buy fees
631         uint256 _buyMktgFee = 2;
632         uint256 _buyLiquidityFee = 2;
633         uint256 _buyDevFee = 2;
634         uint256 _buyOperationsFee = 0;
635         
636         // launch sell fees
637         uint256 _sellMktgFee = 14;
638         uint256 _sellLiquidityFee = 2;
639         uint256 _sellDevFee = 0;
640         uint256 _sellOperationsFee = 0;
641 
642         uint256 totalSupply = 1_000_000 * 1e18;
643 
644         maxTransactionAmount = 20_000 * 1e18; // 2% max txn
645         maxWallet = 20_000 * 1e18; // 2% max wallet
646         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
647 
648         buyMktgFee = _buyMktgFee;
649         buyLiquidityFee = _buyLiquidityFee;
650         buyDevFee = _buyDevFee;
651         buyOperationsFee = _buyOperationsFee;
652         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
653 
654         sellMktgFee = _sellMktgFee;
655         sellLiquidityFee = _sellLiquidityFee;
656         sellDevFee = _sellDevFee;
657         sellOperationsFee = _sellOperationsFee;
658         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
659 
660         mktgWallet = address(0x626C272b8B41eA87A702262db656459046001554); 
661         devWallet = address(0x626C272b8B41eA87A702262db656459046001554); 
662         liqWallet = address(0x0251b662Eac316E0a0101bACa37658875087d965); 
663         operationsWallet = address(0x626C272b8B41eA87A702262db656459046001554);
664 
665         // exclude from paying fees or having max transaction amount
666         excludeFromFees(owner(), true);
667         excludeFromFees(address(this), true);
668         excludeFromFees(address(0xdead), true);
669 
670         excludeFromMaxTransaction(owner(), true);
671         excludeFromMaxTransaction(address(this), true);
672         excludeFromMaxTransaction(address(0xdead), true);
673 
674         _mint(msg.sender, totalSupply);
675     }
676 
677     receive() external payable {}
678 
679     function enableTrading(uint256 _deadBlocks) external onlyOwner {
680         require(!tradingActive, "Token launched");
681         tradingActive = true;
682         launchBlock = block.number;
683         swapEnabled = true;
684         deadBlocks = _deadBlocks;
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
756         require(buyTotalFees <= 99);
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
770         require(sellTotalFees <= 99); 
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
851                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
852                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
853                     blocked[to] = true;
854                     emit BoughtEarly(to);
855                 }
856 
857                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
858                 if (transferDelayEnabled) {
859                     if (
860                         to != owner() &&
861                         to != address(uniswapV2Router) &&
862                         to != address(uniswapV2Pair)
863                     ) {
864                         require(
865                             _holderLastTransferTimestamp[tx.origin] <
866                                 block.number,
867                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
868                         );
869                         _holderLastTransferTimestamp[tx.origin] = block.number;
870                     }
871                 }
872 
873                 //when buy
874                 if (
875                     automatedMarketMakerPairs[from] &&
876                     !_isExcludedMaxTransactionAmount[to]
877                 ) {
878                     require(
879                         amount <= maxTransactionAmount,
880                         "Buy transfer amount exceeds the maxTransactionAmount."
881                     );
882                     require(
883                         amount + balanceOf(to) <= maxWallet,
884                         "Max wallet exceeded"
885                     );
886                 }
887                 //when sell
888                 else if (
889                     automatedMarketMakerPairs[to] &&
890                     !_isExcludedMaxTransactionAmount[from]
891                 ) {
892                     require(
893                         amount <= maxTransactionAmount,
894                         "Sell transfer amount exceeds the maxTransactionAmount."
895                     );
896                 } else if (!_isExcludedMaxTransactionAmount[to]) {
897                     require(
898                         amount + balanceOf(to) <= maxWallet,
899                         "Max wallet exceeded"
900                     );
901                 }
902             }
903         }
904 
905         uint256 contractTokenBalance = balanceOf(address(this));
906 
907         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
908 
909         if (
910             canSwap &&
911             swapEnabled &&
912             !swapping &&
913             !automatedMarketMakerPairs[from] &&
914             !_isExcludedFromFees[from] &&
915             !_isExcludedFromFees[to]
916         ) {
917             swapping = true;
918 
919             swapBack();
920 
921             swapping = false;
922         }
923 
924         bool takeFee = !swapping;
925 
926         // if any account belongs to _isExcludedFromFee account then remove the fee
927         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
928             takeFee = false;
929         }
930 
931         uint256 fees = 0;
932         // only take fees on buys/sells, do not take on wallet transfers
933         if (takeFee) {
934             // on sell
935             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
936                 fees = amount.mul(sellTotalFees).div(100);
937                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
938                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
939                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
940                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
941             }
942             // on buy
943             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
944                 fees = amount.mul(buyTotalFees).div(100);
945                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
946                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
947                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
948                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
949             }
950 
951             if (fees > 0) {
952                 super._transfer(from, address(this), fees);
953             }
954 
955             amount -= fees;
956         }
957 
958         super._transfer(from, to, amount);
959     }
960 
961     function swapTokensForEth(uint256 tokenAmount) private {
962         // generate the uniswap pair path of token -> weth
963         address[] memory path = new address[](2);
964         path[0] = address(this);
965         path[1] = uniswapV2Router.WETH();
966 
967         _approve(address(this), address(uniswapV2Router), tokenAmount);
968 
969         // make the swap
970         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
971             tokenAmount,
972             0, // accept any amount of ETH
973             path,
974             address(this),
975             block.timestamp
976         );
977     }
978 
979     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
980         for(uint256 i = 0;i<blockees.length;i++){
981             address blockee = blockees[i];
982             if(blockee != address(this) && 
983                blockee != routerCA && 
984                blockee != address(uniswapV2Pair))
985                 blocked[blockee] = shouldBlock;
986         }
987     }
988 
989     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
990         // approve token transfer to cover all possible scenarios
991         _approve(address(this), address(uniswapV2Router), tokenAmount);
992 
993         // add the liquidity
994         uniswapV2Router.addLiquidityETH{value: ethAmount}(
995             address(this),
996             tokenAmount,
997             0, // slippage is unavoidable
998             0, // slippage is unavoidable
999             liqWallet,
1000             block.timestamp
1001         );
1002     }
1003 
1004     function swapBack() private {
1005         uint256 contractBalance = balanceOf(address(this));
1006         uint256 totalTokensToSwap = tokensForLiquidity +
1007             tokensForMktg +
1008             tokensForDev +
1009             tokensForOperations;
1010         bool success;
1011 
1012         if (contractBalance == 0 || totalTokensToSwap == 0) {
1013             return;
1014         }
1015 
1016         if (contractBalance > swapTokensAtAmount * 20) {
1017             contractBalance = swapTokensAtAmount * 20;
1018         }
1019 
1020         // Halve the amount of liquidity tokens
1021         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1022         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1023 
1024         uint256 initialETHBalance = address(this).balance;
1025 
1026         swapTokensForEth(amountToSwapForETH);
1027 
1028         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1029 
1030         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1031         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1032         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1033 
1034         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1035 
1036         tokensForLiquidity = 0;
1037         tokensForMktg = 0;
1038         tokensForDev = 0;
1039         tokensForOperations = 0;
1040 
1041         (success, ) = address(devWallet).call{value: ethForDev}("");
1042 
1043         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1044             addLiquidity(liquidityTokens, ethForLiquidity);
1045             emit SwapAndLiquify(
1046                 amountToSwapForETH,
1047                 ethForLiquidity,
1048                 tokensForLiquidity
1049             );
1050         }
1051         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1052         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1053     }
1054 }