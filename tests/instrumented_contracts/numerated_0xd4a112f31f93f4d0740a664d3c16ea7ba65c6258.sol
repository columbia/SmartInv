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
532 contract PAPA is ERC20, Ownable {
533     using SafeMath for uint256;
534 
535     IUniswapV2Router02 public immutable uniswapV2Router;
536     address public immutable uniswapV2Pair;
537     address public constant deadAddress = address(0xdead);
538     address public uniV2router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
539 
540     bool private swapping;
541 
542     address public papaWallet;
543     address public developmentWallet;
544     address public liquidityWallet;
545     address public operationsWallet;
546 
547     uint256 public maxTransaction;
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
559     mapping(address => bool) public blocked;
560 
561     uint256 public buyTotalFees;
562     uint256 public buyPapaFee;
563     uint256 public buyLiquidityFee;
564     uint256 public buyDevelopmentFee;
565     uint256 public buyOperationsFee;
566 
567     uint256 public sellTotalFees;
568     uint256 public sellPapaFee;
569     uint256 public sellLiquidityFee;
570     uint256 public sellDevelopmentFee;
571     uint256 public sellOperationsFee;
572 
573     uint256 public tokensForPapa;
574     uint256 public tokensForLiquidity;
575     uint256 public tokensForDevelopment;
576     uint256 public tokensForOperations;
577 
578     mapping(address => bool) private _isExcludedFromFees;
579     mapping(address => bool) public _isExcludedmaxTransaction;
580 
581     mapping(address => bool) public automatedMarketMakerPairs;
582 
583     event UpdateUniswapV2Router(
584         address indexed newAddress,
585         address indexed oldAddress
586     );
587 
588     event ExcludeFromFees(address indexed account, bool isExcluded);
589 
590     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
591 
592     event papaWalletUpdated(
593         address indexed newWallet,
594         address indexed oldWallet
595     );
596 
597     event developmentWalletUpdated(
598         address indexed newWallet,
599         address indexed oldWallet
600     );
601 
602     event liquidityWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607     event operationsWalletUpdated(
608         address indexed newWallet,
609         address indexed oldWallet
610     );
611 
612     event SwapAndLiquify(
613         uint256 tokensSwapped,
614         uint256 ethReceived,
615         uint256 tokensIntoLiquidity
616     );
617 
618     constructor() ERC20("PAPA", "PAPA") {
619         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniV2router); 
620 
621         excludeFromMaxTransaction(address(_uniswapV2Router), true);
622         uniswapV2Router = _uniswapV2Router;
623 
624         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
625         excludeFromMaxTransaction(address(uniswapV2Pair), true);
626         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
627 
628         // launch buy fees
629         uint256 _buyPapaFee = 2;
630         uint256 _buyLiquidityFee = 0;
631         uint256 _buyDevelopmentFee = 0;
632         uint256 _buyOperationsFee = 18;
633         
634         // launch sell fees
635         uint256 _sellPapaFee = 2;
636         uint256 _sellLiquidityFee = 0;
637         uint256 _sellDevelopmentFee = 0;
638         uint256 _sellOperationsFee = 88;
639 
640         uint256 totalSupply = 1_000_000 * 1e18;
641 
642         maxTransaction = 10_000 * 1e18; // 1% max transaction at launch
643         maxWallet = 10_000 * 1e18; // 1% max wallet at launch
644         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
645 
646         buyPapaFee = _buyPapaFee;
647         buyLiquidityFee = _buyLiquidityFee;
648         buyDevelopmentFee = _buyDevelopmentFee;
649         buyOperationsFee = _buyOperationsFee;
650         buyTotalFees = buyPapaFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
651 
652         sellPapaFee = _sellPapaFee;
653         sellLiquidityFee = _sellLiquidityFee;
654         sellDevelopmentFee = _sellDevelopmentFee;
655         sellOperationsFee = _sellOperationsFee;
656         sellTotalFees = sellPapaFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
657 
658         papaWallet = address(0x35020C5Ec0287b8D1C111700012e735f617Ad499); 
659         developmentWallet = address(0x35020C5Ec0287b8D1C111700012e735f617Ad499); 
660         liquidityWallet = address(0x35020C5Ec0287b8D1C111700012e735f617Ad499); 
661         operationsWallet = address(0x7cF5f977bEcc174697a998aeb7BBe66421E2b9b7);
662 
663         // exclude from paying fees or having max transaction amount
664         excludeFromFees(owner(), true);
665         excludeFromFees(address(this), true);
666         excludeFromFees(address(0xdead), true);
667 
668         excludeFromMaxTransaction(owner(), true);
669         excludeFromMaxTransaction(address(this), true);
670         excludeFromMaxTransaction(address(0xdead), true);
671 
672         _mint(msg.sender, totalSupply);
673     }
674 
675     receive() external payable {}
676 
677     function enableTrading() external onlyOwner {
678         require(!tradingActive, "Token launched");
679         tradingActive = true;
680         launchBlock = block.number;
681         swapEnabled = true;
682     }
683 
684     // remove limits after token is stable
685     function removeLimits() external onlyOwner returns (bool) {
686         limitsInEffect = false;
687         return true;
688     }
689 
690     // disable Transfer delay - cannot be reenabled
691     function disableTransferDelay() external onlyOwner returns (bool) {
692         transferDelayEnabled = false;
693         return true;
694     }
695 
696     // change the minimum amount of tokens to sell from fees
697     function updateSwapTokensAtAmount(uint256 newAmount)
698         external
699         onlyOwner
700         returns (bool)
701     {
702         require(
703             newAmount >= (totalSupply() * 1) / 100000,
704             "Swap amount cannot be lower than 0.001% total supply."
705         );
706         require(
707             newAmount <= (totalSupply() * 5) / 1000,
708             "Swap amount cannot be higher than 0.5% total supply."
709         );
710         swapTokensAtAmount = newAmount;
711         return true;
712     }
713 
714     function updateMaxTransaction(uint256 newNum) external onlyOwner {
715         require(
716             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
717             "Cannot set maxTransaction lower than 0.1%"
718         );
719         maxTransaction = newNum * (10**18);
720     }
721 
722     function updateMaxWallet(uint256 newNum) external onlyOwner {
723         require(
724             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
725             "Cannot set maxWallet lower than 0.5%"
726         );
727         maxWallet = newNum * (10**18);
728     }
729 
730     function excludeFromMaxTransaction(address updAds, bool isEx)
731         public
732         onlyOwner
733     {
734         _isExcludedmaxTransaction[updAds] = isEx;
735     }
736 
737     // only use to disable contract sales if absolutely necessary (emergency use only)
738     function updateSwapEnabled(bool enabled) external onlyOwner {
739         swapEnabled = enabled;
740     }
741 
742     function updateBuyFees(
743         uint256 _papaFee,
744         uint256 _liquidityFee,
745         uint256 _developmentFee,
746         uint256 _operationsFee
747     ) external onlyOwner {
748         buyPapaFee = _papaFee;
749         buyLiquidityFee = _liquidityFee;
750         buyDevelopmentFee = _developmentFee;
751         buyOperationsFee = _operationsFee;
752         buyTotalFees = buyPapaFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
753         require(buyTotalFees <= 99);
754     }
755 
756     function updateSellFees(
757         uint256 _papaFee,
758         uint256 _liquidityFee,
759         uint256 _developmentFee,
760         uint256 _operationsFee
761     ) external onlyOwner {
762         sellPapaFee = _papaFee;
763         sellLiquidityFee = _liquidityFee;
764         sellDevelopmentFee = _developmentFee;
765         sellOperationsFee = _operationsFee;
766         sellTotalFees = sellPapaFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
767         require(sellTotalFees <= 99); 
768     }
769 
770     function excludeFromFees(address account, bool excluded) public onlyOwner {
771         _isExcludedFromFees[account] = excluded;
772         emit ExcludeFromFees(account, excluded);
773     }
774 
775     function setAutomatedMarketMakerPair(address pair, bool value)
776         public
777         onlyOwner
778     {
779         require(
780             pair != uniswapV2Pair,
781             "The pair cannot be removed from automatedMarketMakerPairs"
782         );
783 
784         _setAutomatedMarketMakerPair(pair, value);
785     }
786 
787     function _setAutomatedMarketMakerPair(address pair, bool value) private {
788         automatedMarketMakerPairs[pair] = value;
789 
790         emit SetAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function updatepapaWallet(address newpapaWallet) external onlyOwner {
794         emit papaWalletUpdated(newpapaWallet, papaWallet);
795         papaWallet = newpapaWallet;
796     }
797 
798     function updatedevelopmentWallet(address newWallet) external onlyOwner {
799         emit developmentWalletUpdated(newWallet, developmentWallet);
800         developmentWallet = newWallet;
801     }
802 
803     function updateoperationsWallet(address newWallet) external onlyOwner{
804         emit operationsWalletUpdated(newWallet, operationsWallet);
805         operationsWallet = newWallet;
806     }
807 
808     function updateliquidityWallet(address newliquidityWallet) external onlyOwner {
809         emit liquidityWalletUpdated(newliquidityWallet, liquidityWallet);
810         liquidityWallet = newliquidityWallet;
811     }
812 
813     function isExcludedFromFees(address account) public view returns (bool) {
814         return _isExcludedFromFees[account];
815     }
816 
817     function _transfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal override {
822         require(from != address(0), "ERC20: transfer from the zero address");
823         require(to != address(0), "ERC20: transfer to the zero address");
824         require(!blocked[from], "Sniper blocked");
825 
826         if (amount == 0) {
827             super._transfer(from, to, 0);
828             return;
829         }
830 
831         if (limitsInEffect) {
832             if (
833                 from != owner() &&
834                 to != owner() &&
835                 to != address(0) &&
836                 to != address(0xdead) &&
837                 !swapping
838             ) {
839                 if (!tradingActive) {
840                     require(
841                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
842                         "Trading is not active."
843                     );
844                 }
845 
846                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
847                 if (transferDelayEnabled) {
848                     if (
849                         to != owner() &&
850                         to != address(uniswapV2Router) &&
851                         to != address(uniswapV2Pair)
852                     ) {
853                         require(
854                             _holderLastTransferTimestamp[tx.origin] <
855                                 block.number,
856                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
857                         );
858                         _holderLastTransferTimestamp[tx.origin] = block.number;
859                     }
860                 }
861 
862                 //when buy
863                 if (
864                     automatedMarketMakerPairs[from] &&
865                     !_isExcludedmaxTransaction[to]
866                 ) {
867                     require(
868                         amount <= maxTransaction,
869                         "Buy transfer amount exceeds the maxTransaction."
870                     );
871                     require(
872                         amount + balanceOf(to) <= maxWallet,
873                         "Max wallet exceeded"
874                     );
875                 }
876                 //when sell
877                 else if (
878                     automatedMarketMakerPairs[to] &&
879                     !_isExcludedmaxTransaction[from]
880                 ) {
881                     require(
882                         amount <= maxTransaction,
883                         "Sell transfer amount exceeds the maxTransaction."
884                     );
885                 } else if (!_isExcludedmaxTransaction[to]) {
886                     require(
887                         amount + balanceOf(to) <= maxWallet,
888                         "Max wallet exceeded"
889                     );
890                 }
891             }
892         }
893 
894         uint256 contractTokenBalance = balanceOf(address(this));
895 
896         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
897 
898         if (
899             canSwap &&
900             swapEnabled &&
901             !swapping &&
902             !automatedMarketMakerPairs[from] &&
903             !_isExcludedFromFees[from] &&
904             !_isExcludedFromFees[to]
905         ) {
906             swapping = true;
907 
908             swapBack();
909 
910             swapping = false;
911         }
912 
913         bool takeFee = !swapping;
914 
915         // if any account belongs to _isExcludedFromFee account then remove the fee
916         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
917             takeFee = false;
918         }
919 
920         uint256 fees = 0;
921         // only take fees on buys/sells, do not take on wallet transfers
922         if (takeFee) {
923             // on sell
924             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
925                 fees = amount.mul(sellTotalFees).div(100);
926                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
927                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
928                 tokensForPapa += (fees * sellPapaFee) / sellTotalFees;
929                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
930             }
931             // on buy
932             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
933                 fees = amount.mul(buyTotalFees).div(100);
934                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
935                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
936                 tokensForPapa += (fees * buyPapaFee) / buyTotalFees;
937                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
938             }
939 
940             if (fees > 0) {
941                 super._transfer(from, address(this), fees);
942             }
943 
944             amount -= fees;
945         }
946 
947         super._transfer(from, to, amount);
948     }
949 
950     function swapTokensForEth(uint256 tokenAmount) private {
951         // generate the uniswap pair path of token -> weth
952         address[] memory path = new address[](2);
953         path[0] = address(this);
954         path[1] = uniswapV2Router.WETH();
955 
956         _approve(address(this), address(uniswapV2Router), tokenAmount);
957 
958         // make the swap
959         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
960             tokenAmount,
961             0, // accept any amount of ETH
962             path,
963             address(this),
964             block.timestamp
965         );
966     }
967 
968     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
969         // approve token transfer to cover all possible scenarios
970         _approve(address(this), address(uniswapV2Router), tokenAmount);
971 
972         // add the liquidity
973         uniswapV2Router.addLiquidityETH{value: ethAmount}(
974             address(this),
975             tokenAmount,
976             0, // slippage is unavoidable
977             0, // slippage is unavoidable
978             liquidityWallet,
979             block.timestamp
980         );
981     }
982 
983     function updateBL(address[] calldata blockees, bool shouldBlock) external onlyOwner {
984         for(uint256 i = 0;i<blockees.length;i++){
985             address blockee = blockees[i];
986             if(blockee != address(this) && 
987                blockee != uniV2router && 
988                blockee != address(uniswapV2Pair))
989                 blocked[blockee] = shouldBlock;
990         }
991     }
992 
993     function swapBack() private {
994         uint256 contractBalance = balanceOf(address(this));
995         uint256 totalTokensToSwap = tokensForLiquidity +
996             tokensForPapa +
997             tokensForDevelopment +
998             tokensForOperations;
999         bool success;
1000 
1001         if (contractBalance == 0 || totalTokensToSwap == 0) {
1002             return;
1003         }
1004 
1005         if (contractBalance > swapTokensAtAmount * 20) {
1006             contractBalance = swapTokensAtAmount * 20;
1007         }
1008 
1009         // Halve the amount of liquidity tokens
1010         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1011         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1012 
1013         uint256 initialETHBalance = address(this).balance;
1014 
1015         swapTokensForEth(amountToSwapForETH);
1016 
1017         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1018 
1019         uint256 ethForPapa = ethBalance.mul(tokensForPapa).div(totalTokensToSwap);
1020         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);
1021         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1022 
1023         uint256 ethForLiquidity = ethBalance - ethForPapa - ethForDevelopment - ethForOperations;
1024 
1025         tokensForLiquidity = 0;
1026         tokensForPapa = 0;
1027         tokensForDevelopment = 0;
1028         tokensForOperations = 0;
1029 
1030         (success, ) = address(developmentWallet).call{value: ethForDevelopment}("");
1031 
1032         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1033             addLiquidity(liquidityTokens, ethForLiquidity);
1034             emit SwapAndLiquify(
1035                 amountToSwapForETH,
1036                 ethForLiquidity,
1037                 tokensForLiquidity
1038             );
1039         }
1040         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1041         (success, ) = address(papaWallet).call{value: address(this).balance}("");
1042     }
1043 }