1 /*
2 
3 */
4 pragma solidity ^0.8.17;
5 //SPDX-License-Identifier: Unlicensed
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; 
14         return msg.data;
15     }
16 }
17 
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21 
22     function name() external pure returns (string memory);
23 
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint);
27     function balanceOf(address owner) external view returns (uint);
28     function allowance(address owner, address spender) external view returns (uint);
29 
30     function approve(address spender, uint value) external returns (bool);
31     function transfer(address to, uint value) external returns (bool);
32     function transferFrom(address from, address to, uint value) external returns (bool);
33 
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37 
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39 
40     event Mint(address indexed sender, uint amount0, uint amount1);
41     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
42     event Swap(
43         address indexed sender,
44         uint amount0In,
45         uint amount1In,
46         uint amount0Out,
47         uint amount1Out,
48         address indexed to
49     );
50     event Sync(uint112 reserve0, uint112 reserve1);
51 
52     function MINIMUM_LIQUIDITY() external pure returns (uint);
53 
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60 
61     function kLast() external view returns (uint);
62 
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68 
69     function initialize(address, address) external;
70 }
71 
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74 
75     function feeTo() external view returns (address);
76     function feeToSetter() external view returns (address);
77 
78     function getPair(address tokenA, address tokenB) external view returns (address pair);
79     function allPairs(uint) external view returns (address pair);
80     function allPairsLength() external view returns (uint);
81 
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83 
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87 interface IERC20 {
88     
89     function totalSupply() external view returns (uint256);
90 
91     
92     function balanceOf(address account) external view returns (uint256);
93 
94     
95     function transfer(address recipient, uint256 amount) external returns (bool);
96 
97     
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     
101       function approve(address spender, uint256 amount) external returns (bool);
102 
103   
104     function transferFrom(
105         address sender,
106         address recipient,
107         uint256 amount
108 
109     ) external returns (bool);
110 
111     
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 
117 }
118 
119 interface IERC20Metadata is IERC20 {
120     
121      function name() external view returns (string memory);
122 
123     
124     function symbol() external view returns (string memory);
125 
126    
127     function decimals() external view returns (uint8);
128 }
129 
130 
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     using SafeMath for uint256;
133 
134     mapping(address => uint256) private _balances;
135 
136     mapping(address => mapping(address => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142 
143     
144     constructor(string memory name_, string memory symbol_) {
145         _name = name_;
146         _symbol = symbol_;
147     }
148 
149     
150     function name() public view virtual override returns (string memory) {
151         return _name;
152     }
153 
154     
155     function symbol() public view virtual override returns (string memory) {
156         return _symbol;
157 
158     }
159     
160     function decimals() public view virtual override returns (uint8) {
161         return 9;
162     }
163 
164 
165     
166     function totalSupply() public view virtual override returns (uint256) {
167         return _totalSupply;
168     }
169 
170    
171     function balanceOf(address account) public view virtual override returns (uint256) {
172         return _balances[account];
173     }
174 
175     
176     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     
182     function allowance(address owner, address spender) public view virtual override returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     
187     function approve(address spender, uint256 amount) public virtual override returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     function transferFrom(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) public virtual override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201    
202     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
204         return true;
205 
206     }
207 
208     
209     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
210         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
211         return true;
212 
213     }
214 
215     
216     function _transfer(
217         address sender,
218         address recipient,
219         uint256 amount
220         ) internal virtual {
221         require(sender != address(0), "ERC20: transfer from the zero address");
222         require(recipient != address(0), "ERC20: transfer to the zero address");
223 
224         _beforeTokenTransfer(sender, recipient, amount);
225 
226         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
227         _balances[recipient] = _balances[recipient].add(amount);
228         emit Transfer(sender, recipient, amount);
229     }
230 
231 
232    
233     function _mint(address account, uint256 amount) internal virtual {
234         require(account != address(0), "ERC20: mint to the zero address");
235 
236         _beforeTokenTransfer(address(0), account, amount);
237 
238         _totalSupply = _totalSupply.add(amount);
239         _balances[account] = _balances[account].add(amount);
240         emit Transfer(address(0), account, amount);
241     }
242 
243     
244     function _burn(address account, uint256 amount) internal virtual {
245         require(account != address(0), "ERC20: burn from the zero address");
246  _beforeTokenTransfer(account, address(0), amount);
247 
248         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
249         _totalSupply = _totalSupply.sub(amount);
250         emit Transfer(account, address(0), amount);
251     }
252 
253 
254     
255     function _approve(
256         address owner,
257         address spender,
258         uint256 amount
259     ) internal virtual {
260         require(owner != address(0), "ERC20: approve from the zero address");
261         require(spender != address(0), "ERC20: approve to the zero address");
262 
263 
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     
269     function _beforeTokenTransfer(
270         address from,
271         address to,
272         uint256 amount
273     ) internal virtual {}
274 
275 }
276 
277 library SafeMath {
278     
279     function add(uint256 a, uint256 b) internal pure returns (uint256) {
280         uint256 c = a + b;
281         require(c >= a, "SafeMath: addition overflow");
282 
283         return c;
284     }
285 
286     
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return sub(a, b, "SafeMath: subtraction overflow");
289     }
290 
291 
292     
293     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b <= a, errorMessage);
295         uint256 c = a - b;
296 
297         return c;
298     }
299 
300    
301     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
302         
303         if (a == 0) {
304             return 0;
305         }
306          uint256 c = a * b;
307         require(c / a == b, "SafeMath: multiplication overflow");
308 
309         return c;
310     }
311 
312     
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return div(a, b, "SafeMath: division by zero");
315     }
316 
317     
318     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b > 0, errorMessage);
320         uint256 c = a / b;
321        
322         return c;
323     }
324 
325 
326     
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return mod(a, b, "SafeMath: modulo by zero");
329     }
330      
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b != 0, errorMessage);
333 
334         return a % b;
335     }
336 }
337 
338 contract Ownable is Context {
339     address private _owner;
340 
341     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
342     
343     
344     constructor () {
345         address msgSender = _msgSender();
346         _owner = msgSender;
347         emit OwnershipTransferred(address(0), msgSender);
348     }
349 
350     
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     
356     
357     modifier onlyOwner() {
358         require(_owner == _msgSender(), "Ownable: caller is not the owner");
359         _;
360     }
361 
362     
363     function renounceOwnership() public virtual onlyOwner {
364         emit OwnershipTransferred(_owner, address(0));
365         _owner = address(0);
366     }
367    
368 
369     function transferOwnership(address newOwner) public virtual onlyOwner {
370         require(newOwner != address(0), "Ownable: new owner is the zero address");
371         emit OwnershipTransferred(_owner, newOwner);
372 
373         _owner = newOwner;
374     }
375 }
376 
377 
378 
379 library SafeMathInt {
380     int256 private constant MIN_INT256 = int256(1) << 255;
381     int256 private constant MAX_INT256 = ~(int256(1) << 255);
382 
383    
384     function mul(int256 a, int256 b) internal pure returns (int256) {
385         int256 c = a * b;
386 
387         
388         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
389         require((b == 0) || (c / b == a));
390         return c;
391     }
392 
393     
394     function div(int256 a, int256 b) internal pure returns (int256) {
395         
396         require(b != -1 || a != MIN_INT256);
397 
398 
399         return a / b;
400     }
401 
402     
403     function sub(int256 a, int256 b) internal pure returns (int256) {
404         int256 c = a - b;
405         require((b >= 0 && c <= a) || (b < 0 && c > a));
406         return c;
407     }
408 
409     
410     function add(int256 a, int256 b) internal pure returns (int256) {
411         int256 c = a + b;
412         require((b >= 0 && c >= a) || (b < 0 && c < a));
413         return c;
414     }
415    
416     function abs(int256 a) internal pure returns (int256) {
417         require(a != MIN_INT256);
418 
419         return a < 0 ? -a : a;
420     }
421 
422 
423     function toUint256Safe(int256 a) internal pure returns (uint256) {
424         require(a >= 0);
425         return uint256(a);
426     }
427 }
428 
429 library SafeMathUint {
430   function toInt256Safe(uint256 a) internal pure returns (int256) {
431     int256 b = int256(a);
432     require(b >= 0);
433     return b;
434   }
435 }
436 
437 
438 interface IUniswapV2Router01 {
439     function factory() external pure returns (address);
440     function WETH() external pure returns (address);
441 
442     function addLiquidity(
443         address tokenA,
444         address tokenB,
445         uint amountADesired,
446         uint amountBDesired,
447         uint amountAMin,
448 
449         uint amountBMin,
450         address to,
451         uint deadline
452     ) external returns (uint amountA, uint amountB, uint liquidity);
453     function addLiquidityETH(
454         address token,
455         uint amountTokenDesired,
456         uint amountTokenMin,
457         uint amountETHMin,
458         address to,
459         uint deadline
460     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
461     function removeLiquidity(
462         address tokenA,
463         address tokenB,
464         uint liquidity,
465         uint amountAMin,
466         uint amountBMin,
467         address to,
468         uint deadline
469     ) external returns (uint amountA, uint amountB);
470      function removeLiquidityETH(
471         address token,
472         uint liquidity,
473         uint amountTokenMin,
474         uint amountETHMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountToken, uint amountETH);
478     function removeLiquidityWithPermit(
479         address tokenA,
480         address tokenB,
481         uint liquidity,
482         uint amountAMin,
483         uint amountBMin,
484         address to,
485         uint deadline,
486         bool approveMax, uint8 v, bytes32 r, bytes32 s
487     ) external returns (uint amountA, uint amountB);
488     function removeLiquidityETHWithPermit(
489         address token,
490         uint liquidity,
491         uint amountTokenMin,
492         uint amountETHMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external returns (uint amountToken, uint amountETH);
497     function swapExactTokensForTokens(
498         uint amountIn,
499         uint amountOutMin,
500         address[] calldata path,
501         address to,
502 
503         uint deadline
504     ) external returns (uint[] memory amounts);
505     function swapTokensForExactTokens(
506         uint amountOut,
507         uint amountInMax,
508         address[] calldata path,
509 
510         address to,
511         uint deadline
512     ) external returns (uint[] memory amounts);
513     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
514         external
515         payable
516         returns (uint[] memory amounts);
517     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
518         external
519         returns (uint[] memory amounts);
520     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
521         external
522         returns (uint[] memory amounts);
523          function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
524         external
525         payable
526         returns (uint[] memory amounts);
527 
528     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
529     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
530     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
531     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
532     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
533 }
534 
535 interface IUniswapV2Router02 is IUniswapV2Router01 {
536     function removeLiquidityETHSupportingFeeOnTransferTokens(
537         address token,
538         uint liquidity,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline
543     ) external returns (uint amountETH);
544     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
545         address token,
546         uint liquidity,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline,
551         bool approveMax, uint8 v, bytes32 r, bytes32 s
552     ) external returns (uint amountETH);
553 
554     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external;
561     function swapExactETHForTokensSupportingFeeOnTransferTokens(
562         uint amountOutMin,
563         address[] calldata path,
564         address to,
565         uint deadline
566     ) external payable;
567     function swapExactTokensForETHSupportingFeeOnTransferTokens(
568         uint amountIn,
569 
570         uint amountOutMin,
571         address[] calldata path,
572         address to,
573 
574         uint deadline
575     ) external;
576 }
577 contract grdn is ERC20, Ownable {
578     using SafeMath for uint256;
579 
580     IUniswapV2Router02 public immutable uniswapV2Router;
581     address public immutable uniswapV2Pair;
582     address public constant deadAddress = address(0xdead);
583 
584     bool private swapping;
585 
586     address public deployerAddress;
587     address public marketingWallet;
588     
589     uint256 public maxTransactionAmount;
590     uint256 public swapTokensAtAmount;
591     uint256 public maxWallet;
592 
593     bool public swapEnabled = true;
594 
595     uint256 public buyTotalFees;
596     uint256 public buyMarketingFee;
597     uint256 public buyLiquidityFee;
598     uint256 public buyBurnFee;
599     
600     uint256 public sellTotalFees;
601     uint256 public sellMarketingFee;
602     uint256 public sellLiquidityFee;
603     uint256 public sellBurnFee;
604     
605     uint256 public tokensForMarketing;
606     uint256 public tokensForLiquidity;
607     uint256 public tokensForBurn;
608     
609     /******************/
610 
611    
612     mapping (address => bool) private _isExcludedFromFees;
613     mapping (address => bool) public _isExcludedMaxTransactionAmount;
614 
615   
616     mapping (address => bool) public automatedMarketMakerPairs;
617 
618     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
619 
620     event ExcludeFromFees(address indexed account, bool isExcluded);
621 
622 
623     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
624 
625     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
626     event SwapAndLiquify(
627         uint256 tokensSwapped,
628         uint256 ethReceived,
629         uint256 tokensIntoLiquidity
630     );
631 
632     event BuyBackTriggered(uint256 amount);
633 
634     constructor() ERC20("GARDEN", "GRDN") {
635 
636         address newOwner = address(owner());
637         
638         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
639         
640         excludeFromMaxTransaction(address(_uniswapV2Router), true);
641         uniswapV2Router = _uniswapV2Router;
642         
643         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
644         excludeFromMaxTransaction(address(uniswapV2Pair), true);
645         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
646         
647         uint256 _buyMarketingFee = 25;
648         uint256 _buyLiquidityFee = 0;
649         uint256  _buyBurnFee = 0;
650 
651     
652         uint256 _sellMarketingFee = 25;
653         uint256 _sellLiquidityFee = 0;
654         uint256 _sellBurnFee = 0;
655         
656         uint256 totalSupply = 888888888 * 1e9;
657         
658         maxTransactionAmount = totalSupply * 3 / 1000; // 0.3% maxTransactionAmountTxn
659         swapTokensAtAmount = totalSupply * 9 / 10000; // 0.09% swap wallet
660         maxWallet = totalSupply * 6 / 1000; // 0.6% max wallet
661 
662         buyMarketingFee = _buyMarketingFee;
663         buyLiquidityFee = _buyLiquidityFee;
664         buyBurnFee = _buyBurnFee;
665         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
666         
667         sellMarketingFee = _sellMarketingFee;
668         sellLiquidityFee = _sellLiquidityFee;
669         sellBurnFee = _sellBurnFee;
670         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
671         
672         deployerAddress = address(0x327A4C3B26937b12d3740Aa872b8C7a2A8c68C23); 
673     	marketingWallet = address(0x327A4C3B26937b12d3740Aa872b8C7a2A8c68C23); 
674         
675         excludeFromFees(newOwner, true); // Owner address
676         excludeFromFees(address(this), true); // CA
677         excludeFromFees(address(0xdead), true); // Burn address
678         excludeFromFees(marketingWallet, true); // Marketing wallet
679         excludeFromFees(deployerAddress, true); // Deployer Address
680         
681         excludeFromMaxTransaction(newOwner, true); // Owner address
682         excludeFromMaxTransaction(address(this), true); // CA
683         excludeFromMaxTransaction(address(0xdead), true); // Burn address
684         excludeFromMaxTransaction(marketingWallet, true); // Marketing wallet
685         excludeFromMaxTransaction(deployerAddress, true); // Deployer Address
686 
687         
688         /*
689             _mint is an internal function in ERC20.sol that is only called here,
690             and CANNOT be called ever again
691         */
692         _mint(newOwner, totalSupply);
693 
694         transferOwnership(newOwner);
695     }
696 
697     receive() external payable {
698 
699   	}
700 
701      
702     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
703   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
704   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
705   	    swapTokensAtAmount = newAmount;
706   	    return true;
707   	}
708     
709     function updateMaxAmount(uint256 newNum) external onlyOwner {
710         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.5%");
711         maxTransactionAmount = newNum * (10**18);
712     }
713     
714     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
715         _isExcludedMaxTransactionAmount[updAds] = isEx;
716     }
717     
718     
719     function updateSwapEnabled(bool enabled) external onlyOwner(){
720 
721         swapEnabled = enabled;
722     }
723 
724     
725     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
726         buyMarketingFee = _marketingFee;
727         buyLiquidityFee = _liquidityFee;
728         buyBurnFee = _burnFee;
729         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
730         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
731     }
732      function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
733         sellMarketingFee = _marketingFee;
734         sellLiquidityFee = _liquidityFee;
735         sellBurnFee = _burnFee;
736         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
737         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
738     
739     }
740 
741      function removeLimits() external onlyOwner {
742             maxTransactionAmount = totalSupply();
743             maxWallet = totalSupply();
744         }
745 
746     function excludeFromFees(address account, bool excluded) public onlyOwner {
747         _isExcludedFromFees[account] = excluded;
748         emit ExcludeFromFees(account, excluded);
749     }
750 
751     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
752         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
753 
754         _setAutomatedMarketMakerPair(pair, value);
755     }
756 
757     function _setAutomatedMarketMakerPair(address pair, bool value) private {
758         automatedMarketMakerPairs[pair] = value;
759 
760         emit SetAutomatedMarketMakerPair(pair, value);
761     }
762 
763     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
764         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
765         marketingWallet = newMarketingWallet;
766     }
767 
768     function isExcludedFromFees(address account) public view returns(bool) {
769         return _isExcludedFromFees[account];
770 
771     }
772 
773     function _transfer(
774         address from,
775         address to,
776         uint256 amount
777     ) internal override {
778         require(from != address(0), "ERC20: transfer from the zero address");
779         require(to != address(0), "ERC20: transfer to the zero address");
780         
781          if(amount == 0) {
782             super._transfer(from, to, 0);
783             return;
784         }
785         
786 
787             if (
788                 from != owner() &&
789                 to != owner() &&
790                 to != address(0) &&
791                 to != address(0xdead) &&
792                 !swapping
793             ){
794                  
795                 //when buy
796                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
797                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
798                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
799 
800                 }
801                 
802                 //when sell
803                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
804                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
805                 }
806                 else if (!_isExcludedMaxTransactionAmount[to]){
807                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
808                 }
809 
810             }
811         
812         
813         
814         
815 		uint256 contractTokenBalance = balanceOf(address(this));
816         
817         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
818 
819         if( 
820             canSwap &&
821             swapEnabled &&
822             !swapping &&
823             !automatedMarketMakerPairs[from] &&
824             !_isExcludedFromFees[from] &&
825             !_isExcludedFromFees[to]
826         ) {
827             swapping = true;
828             
829             swapBack();
830 
831             swapping = false;
832         }
833         
834         bool takeFee = !swapping;
835 
836         
837         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
838 
839             takeFee = false;
840         }
841         
842         uint256 fees = 0;
843         // only take fees on buys/sells, do not take on wallet transfers
844         if(takeFee){
845             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
846                 fees = amount.mul(sellTotalFees).div(100);
847                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
848                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
849                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
850             }
851               // on buy
852             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
853         	    fees = amount.mul(buyTotalFees).div(100);
854         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
855                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
856                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
857             }
858             
859             if(fees > 0){    
860 
861                 super._transfer(from, address(this), (fees - tokensForBurn));
862             }
863 
864             if(tokensForBurn > 0){
865                 super._transfer(from, deadAddress, tokensForBurn);
866                 tokensForBurn = 0;
867             }
868         	
869         	amount -= fees;
870         }
871 
872         super._transfer(from, to, amount);
873     }
874 
875     function swapTokensForEth(uint256 tokenAmount) private {
876 
877         // generate the uniswap pair path of token -> weth
878         address[] memory path = new address[](2);
879         path[0] = address(this);
880         path[1] = uniswapV2Router.WETH();
881 
882         _approve(address(this), address(uniswapV2Router), tokenAmount);
883 
884         // make the swap
885         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
886             tokenAmount,
887             0, 
888             path,
889             address(this),
890             block.timestamp
891         );
892         
893     }
894     
895     
896     
897     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
898         
899 
900         _approve(address(this), address(uniswapV2Router), tokenAmount);
901 
902         
903         uniswapV2Router.addLiquidityETH{value: ethAmount}(
904             address(this),
905             tokenAmount,
906             0, 
907             0, 
908             deadAddress,
909             block.timestamp
910         );
911 
912     }
913 
914     function swapBack() private {
915         uint256 contractBalance = balanceOf(address(this));
916         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
917         
918         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
919         
920         
921         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
922         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
923         
924         uint256 initialETHBalance = address(this).balance;
925 
926         swapTokensForEth(amountToSwapForETH); 
927         
928         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
929         
930         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
931         
932         
933         uint256 ethForLiquidity = ethBalance - ethForMarketing;
934         tokensForLiquidity = 0;
935         tokensForMarketing = 0;
936         
937         (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
938         if(liquidityTokens > 0 && ethForLiquidity > 0){
939 
940             addLiquidity(liquidityTokens, ethForLiquidity);
941             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
942         }
943         
944         
945         (success,) = address(marketingWallet).call{value: address(this).balance}("");
946     }
947     
948 }