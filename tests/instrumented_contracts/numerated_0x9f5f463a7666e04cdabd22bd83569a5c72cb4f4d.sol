1 /*
2 
3 Ur mums fav memecoin Smol Su - $SU 
4 
5 
6 https://t.me/SmolSuPortal
7 https://twitter.com/SmolSuEth
8 http://www.smol-su.com/
9 
10 */
11 
12 
13 pragma solidity ^0.8.17;
14 //SPDX-License-Identifier: Unlicensed
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; 
23         return msg.data;
24     }
25 }
26 
27 interface IUniswapV2Pair {
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30 
31     function name() external pure returns (string memory);
32 
33     function symbol() external pure returns (string memory);
34     function decimals() external pure returns (uint8);
35     function totalSupply() external view returns (uint);
36     function balanceOf(address owner) external view returns (uint);
37     function allowance(address owner, address spender) external view returns (uint);
38 
39     function approve(address spender, uint value) external returns (bool);
40     function transfer(address to, uint value) external returns (bool);
41     function transferFrom(address from, address to, uint value) external returns (bool);
42 
43     function DOMAIN_SEPARATOR() external view returns (bytes32);
44     function PERMIT_TYPEHASH() external pure returns (bytes32);
45     function nonces(address owner) external view returns (uint);
46 
47     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48 
49     event Mint(address indexed sender, uint amount0, uint amount1);
50     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
51     event Swap(
52         address indexed sender,
53         uint amount0In,
54         uint amount1In,
55         uint amount0Out,
56         uint amount1Out,
57         address indexed to
58     );
59     event Sync(uint112 reserve0, uint112 reserve1);
60 
61     function MINIMUM_LIQUIDITY() external pure returns (uint);
62 
63     function factory() external view returns (address);
64     function token0() external view returns (address);
65     function token1() external view returns (address);
66     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
67     function price0CumulativeLast() external view returns (uint);
68     function price1CumulativeLast() external view returns (uint);
69 
70     function kLast() external view returns (uint);
71 
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77 
78     function initialize(address, address) external;
79 }
80 
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83 
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86 
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90 
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96 interface IERC20 {
97     
98     function totalSupply() external view returns (uint256);
99 
100     
101     function balanceOf(address account) external view returns (uint256);
102 
103     
104     function transfer(address recipient, uint256 amount) external returns (bool);
105 
106     
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     
110       function approve(address spender, uint256 amount) external returns (bool);
111 
112   
113     function transferFrom(
114         address sender,
115         address recipient,
116         uint256 amount
117 
118     ) external returns (bool);
119 
120     
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 
126 }
127 
128 interface IERC20Metadata is IERC20 {
129     
130      function name() external view returns (string memory);
131 
132     
133     function symbol() external view returns (string memory);
134 
135    
136     function decimals() external view returns (uint8);
137 }
138 
139 
140 contract ERC20 is Context, IERC20, IERC20Metadata {
141     using SafeMath for uint256;
142 
143     mapping(address => uint256) private _balances;
144 
145     mapping(address => mapping(address => uint256)) private _allowances;
146 
147     uint256 private _totalSupply;
148 
149     string private _name;
150     string private _symbol;
151 
152     
153     constructor(string memory name_, string memory symbol_) {
154         _name = name_;
155         _symbol = symbol_;
156     }
157 
158     
159     function name() public view virtual override returns (string memory) {
160         return _name;
161     }
162 
163     
164     function symbol() public view virtual override returns (string memory) {
165         return _symbol;
166 
167     }
168     
169     function decimals() public view virtual override returns (uint8) {
170         return 9;
171     }
172 
173 
174     
175     function totalSupply() public view virtual override returns (uint256) {
176         return _totalSupply;
177     }
178 
179    
180     function balanceOf(address account) public view virtual override returns (uint256) {
181         return _balances[account];
182     }
183 
184     
185     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     
191     function allowance(address owner, address spender) public view virtual override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     
196     function approve(address spender, uint256 amount) public virtual override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) public virtual override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210    
211     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
212         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
213         return true;
214 
215     }
216 
217     
218     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
219         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
220         return true;
221 
222     }
223 
224     
225     function _transfer(
226         address sender,
227         address recipient,
228         uint256 amount
229         ) internal virtual {
230         require(sender != address(0), "ERC20: transfer from the zero address");
231         require(recipient != address(0), "ERC20: transfer to the zero address");
232 
233         _beforeTokenTransfer(sender, recipient, amount);
234 
235         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
236         _balances[recipient] = _balances[recipient].add(amount);
237         emit Transfer(sender, recipient, amount);
238     }
239 
240 
241    
242     function _mint(address account, uint256 amount) internal virtual {
243         require(account != address(0), "ERC20: mint to the zero address");
244 
245         _beforeTokenTransfer(address(0), account, amount);
246 
247         _totalSupply = _totalSupply.add(amount);
248         _balances[account] = _balances[account].add(amount);
249         emit Transfer(address(0), account, amount);
250     }
251 
252     
253     function _burn(address account, uint256 amount) internal virtual {
254         require(account != address(0), "ERC20: burn from the zero address");
255  _beforeTokenTransfer(account, address(0), amount);
256 
257         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
258         _totalSupply = _totalSupply.sub(amount);
259         emit Transfer(account, address(0), amount);
260     }
261 
262 
263     
264     function _approve(
265         address owner,
266         address spender,
267         uint256 amount
268     ) internal virtual {
269         require(owner != address(0), "ERC20: approve from the zero address");
270         require(spender != address(0), "ERC20: approve to the zero address");
271 
272 
273         _allowances[owner][spender] = amount;
274         emit Approval(owner, spender, amount);
275     }
276 
277     
278     function _beforeTokenTransfer(
279         address from,
280         address to,
281         uint256 amount
282     ) internal virtual {}
283 
284 }
285 
286 library SafeMath {
287     
288     function add(uint256 a, uint256 b) internal pure returns (uint256) {
289         uint256 c = a + b;
290         require(c >= a, "SafeMath: addition overflow");
291 
292         return c;
293     }
294 
295     
296     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297         return sub(a, b, "SafeMath: subtraction overflow");
298     }
299 
300 
301     
302     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         require(b <= a, errorMessage);
304         uint256 c = a - b;
305 
306         return c;
307     }
308 
309    
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         
312         if (a == 0) {
313             return 0;
314         }
315          uint256 c = a * b;
316         require(c / a == b, "SafeMath: multiplication overflow");
317 
318         return c;
319     }
320 
321     
322     function div(uint256 a, uint256 b) internal pure returns (uint256) {
323         return div(a, b, "SafeMath: division by zero");
324     }
325 
326     
327     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b > 0, errorMessage);
329         uint256 c = a / b;
330        
331         return c;
332     }
333 
334 
335     
336     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
337         return mod(a, b, "SafeMath: modulo by zero");
338     }
339      
340     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b != 0, errorMessage);
342 
343         return a % b;
344     }
345 }
346 
347 contract Ownable is Context {
348     address private _owner;
349 
350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
351     
352     
353     constructor () {
354         address msgSender = _msgSender();
355         _owner = msgSender;
356         emit OwnershipTransferred(address(0), msgSender);
357     }
358 
359     
360     function owner() public view returns (address) {
361         return _owner;
362     }
363 
364     
365     
366     modifier onlyOwner() {
367         require(_owner == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     
372     function renounceOwnership() public virtual onlyOwner {
373         emit OwnershipTransferred(_owner, address(0));
374         _owner = address(0);
375     }
376    
377 
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(newOwner != address(0), "Ownable: new owner is the zero address");
380         emit OwnershipTransferred(_owner, newOwner);
381 
382         _owner = newOwner;
383     }
384 }
385 
386 
387 
388 library SafeMathInt {
389     int256 private constant MIN_INT256 = int256(1) << 255;
390     int256 private constant MAX_INT256 = ~(int256(1) << 255);
391 
392    
393     function mul(int256 a, int256 b) internal pure returns (int256) {
394         int256 c = a * b;
395 
396         
397         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
398         require((b == 0) || (c / b == a));
399         return c;
400     }
401 
402     
403     function div(int256 a, int256 b) internal pure returns (int256) {
404         
405         require(b != -1 || a != MIN_INT256);
406 
407 
408         return a / b;
409     }
410 
411     
412     function sub(int256 a, int256 b) internal pure returns (int256) {
413         int256 c = a - b;
414         require((b >= 0 && c <= a) || (b < 0 && c > a));
415         return c;
416     }
417 
418     
419     function add(int256 a, int256 b) internal pure returns (int256) {
420         int256 c = a + b;
421         require((b >= 0 && c >= a) || (b < 0 && c < a));
422         return c;
423     }
424    
425     function abs(int256 a) internal pure returns (int256) {
426         require(a != MIN_INT256);
427 
428         return a < 0 ? -a : a;
429     }
430 
431 
432     function toUint256Safe(int256 a) internal pure returns (uint256) {
433         require(a >= 0);
434         return uint256(a);
435     }
436 }
437 
438 library SafeMathUint {
439   function toInt256Safe(uint256 a) internal pure returns (int256) {
440     int256 b = int256(a);
441     require(b >= 0);
442     return b;
443   }
444 }
445 
446 
447 interface IUniswapV2Router01 {
448     function factory() external pure returns (address);
449     function WETH() external pure returns (address);
450 
451     function addLiquidity(
452         address tokenA,
453         address tokenB,
454         uint amountADesired,
455         uint amountBDesired,
456         uint amountAMin,
457 
458         uint amountBMin,
459         address to,
460         uint deadline
461     ) external returns (uint amountA, uint amountB, uint liquidity);
462     function addLiquidityETH(
463         address token,
464         uint amountTokenDesired,
465         uint amountTokenMin,
466         uint amountETHMin,
467         address to,
468         uint deadline
469     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
470     function removeLiquidity(
471         address tokenA,
472         address tokenB,
473         uint liquidity,
474         uint amountAMin,
475         uint amountBMin,
476         address to,
477         uint deadline
478     ) external returns (uint amountA, uint amountB);
479      function removeLiquidityETH(
480         address token,
481         uint liquidity,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external returns (uint amountToken, uint amountETH);
487     function removeLiquidityWithPermit(
488         address tokenA,
489         address tokenB,
490         uint liquidity,
491         uint amountAMin,
492         uint amountBMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external returns (uint amountA, uint amountB);
497     function removeLiquidityETHWithPermit(
498         address token,
499         uint liquidity,
500         uint amountTokenMin,
501         uint amountETHMin,
502         address to,
503         uint deadline,
504         bool approveMax, uint8 v, bytes32 r, bytes32 s
505     ) external returns (uint amountToken, uint amountETH);
506     function swapExactTokensForTokens(
507         uint amountIn,
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511 
512         uint deadline
513     ) external returns (uint[] memory amounts);
514     function swapTokensForExactTokens(
515         uint amountOut,
516         uint amountInMax,
517         address[] calldata path,
518 
519         address to,
520         uint deadline
521     ) external returns (uint[] memory amounts);
522     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
523         external
524         payable
525         returns (uint[] memory amounts);
526     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
527         external
528         returns (uint[] memory amounts);
529     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
530         external
531         returns (uint[] memory amounts);
532          function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
533         external
534         payable
535         returns (uint[] memory amounts);
536 
537     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
538     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
539     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
540     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
541     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
542 }
543 
544 interface IUniswapV2Router02 is IUniswapV2Router01 {
545     function removeLiquidityETHSupportingFeeOnTransferTokens(
546         address token,
547         uint liquidity,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline
552     ) external returns (uint amountETH);
553     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
554         address token,
555         uint liquidity,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline,
560         bool approveMax, uint8 v, bytes32 r, bytes32 s
561     ) external returns (uint amountETH);
562 
563     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
564         uint amountIn,
565         uint amountOutMin,
566         address[] calldata path,
567         address to,
568         uint deadline
569     ) external;
570     function swapExactETHForTokensSupportingFeeOnTransferTokens(
571         uint amountOutMin,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external payable;
576     function swapExactTokensForETHSupportingFeeOnTransferTokens(
577         uint amountIn,
578 
579         uint amountOutMin,
580         address[] calldata path,
581         address to,
582 
583         uint deadline
584     ) external;
585 }
586 contract SmolSu is ERC20, Ownable {
587     using SafeMath for uint256;
588 
589     IUniswapV2Router02 public immutable uniswapV2Router;
590     address public immutable uniswapV2Pair;
591     address public constant deadAddress = address(0xdead);
592 
593     bool private swapping;
594 
595     address public deployerAddress;
596     address public marketingWallet;
597     address public lpLocker;
598     
599     uint256 public maxTransactionAmount;
600     uint256 public swapTokensAtAmount;
601     uint256 public maxWallet;
602 
603     bool public swapEnabled = true;
604 
605     uint256 public buyTotalFees;
606     uint256 public buyMarketingFee;
607     uint256 public buyLiquidityFee;
608     uint256 public buyBurnFee;
609     
610     uint256 public sellTotalFees;
611     uint256 public sellMarketingFee;
612     uint256 public sellLiquidityFee;
613     uint256 public sellBurnFee;
614     
615     uint256 public tokensForMarketing;
616     uint256 public tokensForLiquidity;
617     uint256 public tokensForBurn;
618     
619     /******************/
620 
621    
622     mapping (address => bool) private _isExcludedFromFees;
623     mapping (address => bool) public _isExcludedMaxTransactionAmount;
624 
625   
626     mapping (address => bool) public automatedMarketMakerPairs;
627 
628     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
629 
630     event ExcludeFromFees(address indexed account, bool isExcluded);
631 
632 
633     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
634 
635     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
636     event SwapAndLiquify(
637         uint256 tokensSwapped,
638         uint256 ethReceived,
639         uint256 tokensIntoLiquidity
640     );
641 
642     event BuyBackTriggered(uint256 amount);
643 
644     constructor() ERC20("Smol Su", "SU") {
645 
646         address newOwner = address(owner());
647         
648         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
649         
650         excludeFromMaxTransaction(address(_uniswapV2Router), true);
651         uniswapV2Router = _uniswapV2Router;
652         
653         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
654         excludeFromMaxTransaction(address(uniswapV2Pair), true);
655         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
656         
657         uint256 _buyMarketingFee = 15;
658         uint256 _buyLiquidityFee = 0;
659         uint256  _buyBurnFee = 0;
660 
661     
662         uint256 _sellMarketingFee = 25;
663         uint256 _sellLiquidityFee = 0;
664         uint256 _sellBurnFee = 0;
665         
666         uint256 totalSupply = 1 * 1e6 * 1e9;
667         
668         maxTransactionAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
669         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
670         maxWallet = totalSupply * 2 / 100; // 2% max wallet
671 
672         buyMarketingFee = _buyMarketingFee;
673         buyLiquidityFee = _buyLiquidityFee;
674         buyBurnFee = _buyBurnFee;
675         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
676         
677         sellMarketingFee = _sellMarketingFee;
678         sellLiquidityFee = _sellLiquidityFee;
679         sellBurnFee = _sellBurnFee;
680         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
681         
682         deployerAddress = address(0x2f4086a6101a70a672d08C2B945F1916C0B96204); 
683     	marketingWallet = address(0xfe0EF84FB9da82Fc4Ec3bd5a4909ae1e8d2C670c); 
684         lpLocker = address(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE); 
685 
686         
687         excludeFromFees(newOwner, true); // Owner address
688         excludeFromFees(address(this), true); // CA
689         excludeFromFees(address(0xdead), true); // Burn address
690         excludeFromFees(marketingWallet, true); // Marketing wallet
691         excludeFromFees(lpLocker, true); // LP Locker
692         excludeFromFees(deployerAddress, true); // Deployer Address
693         
694         excludeFromMaxTransaction(newOwner, true); // Owner address
695         excludeFromMaxTransaction(address(this), true); // CA
696         excludeFromMaxTransaction(address(0xdead), true); // Burn address
697         excludeFromMaxTransaction(marketingWallet, true); // Marketing wallet
698         excludeFromMaxTransaction(lpLocker, true); // LP Locker
699         excludeFromMaxTransaction(deployerAddress, true); // Deployer Address
700 
701         
702         /*
703             _mint is an internal function in ERC20.sol that is only called here,
704             and CANNOT be called ever again
705         */
706         _mint(newOwner, totalSupply);
707 
708         transferOwnership(newOwner);
709     }
710 
711     receive() external payable {
712 
713   	}
714 
715      
716     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
717   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
718   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
719   	    swapTokensAtAmount = newAmount;
720   	    return true;
721   	}
722     
723     function updateMaxAmount(uint256 newNum) external onlyOwner {
724         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.5%");
725         maxTransactionAmount = newNum * (10**18);
726     }
727     
728     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
729         _isExcludedMaxTransactionAmount[updAds] = isEx;
730     }
731     
732     
733     function updateSwapEnabled(bool enabled) external onlyOwner(){
734 
735         swapEnabled = enabled;
736     }
737 
738     
739     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
740         buyMarketingFee = _marketingFee;
741         buyLiquidityFee = _liquidityFee;
742         buyBurnFee = _burnFee;
743         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
744         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
745     }
746      function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
747         sellMarketingFee = _marketingFee;
748         sellLiquidityFee = _liquidityFee;
749         sellBurnFee = _burnFee;
750         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
751         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
752     
753     }
754 
755      function removeLimits() external onlyOwner {
756             maxTransactionAmount = totalSupply();
757             maxWallet = totalSupply();
758         }
759 
760     function excludeFromFees(address account, bool excluded) public onlyOwner {
761         _isExcludedFromFees[account] = excluded;
762         emit ExcludeFromFees(account, excluded);
763     }
764 
765     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
766         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
767 
768         _setAutomatedMarketMakerPair(pair, value);
769     }
770 
771     function _setAutomatedMarketMakerPair(address pair, bool value) private {
772         automatedMarketMakerPairs[pair] = value;
773 
774         emit SetAutomatedMarketMakerPair(pair, value);
775     }
776 
777     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
778         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
779         marketingWallet = newMarketingWallet;
780     }
781 
782     function isExcludedFromFees(address account) public view returns(bool) {
783         return _isExcludedFromFees[account];
784 
785     }
786 
787     function _transfer(
788         address from,
789         address to,
790         uint256 amount
791     ) internal override {
792         require(from != address(0), "ERC20: transfer from the zero address");
793         require(to != address(0), "ERC20: transfer to the zero address");
794         
795          if(amount == 0) {
796             super._transfer(from, to, 0);
797             return;
798         }
799         
800 
801             if (
802                 from != owner() &&
803                 to != owner() &&
804                 to != address(0) &&
805                 to != address(0xdead) &&
806                 !swapping
807             ){
808                  
809                 //when buy
810                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
811                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
812                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
813 
814                 }
815                 
816                 //when sell
817                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
818                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
819                 }
820                 else if (!_isExcludedMaxTransactionAmount[to]){
821                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
822                 }
823 
824             }
825         
826         
827         
828         
829 		uint256 contractTokenBalance = balanceOf(address(this));
830         
831         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
832 
833         if( 
834             canSwap &&
835             swapEnabled &&
836             !swapping &&
837             !automatedMarketMakerPairs[from] &&
838             !_isExcludedFromFees[from] &&
839             !_isExcludedFromFees[to]
840         ) {
841             swapping = true;
842             
843             swapBack();
844 
845             swapping = false;
846         }
847         
848         bool takeFee = !swapping;
849 
850         
851         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
852 
853             takeFee = false;
854         }
855         
856         uint256 fees = 0;
857         // only take fees on buys/sells, do not take on wallet transfers
858         if(takeFee){
859             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
860                 fees = amount.mul(sellTotalFees).div(100);
861                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
862                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
863                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
864             }
865               // on buy
866             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
867         	    fees = amount.mul(buyTotalFees).div(100);
868         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
869                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
870                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
871             }
872             
873             if(fees > 0){    
874 
875                 super._transfer(from, address(this), (fees - tokensForBurn));
876             }
877 
878             if(tokensForBurn > 0){
879                 super._transfer(from, deadAddress, tokensForBurn);
880                 tokensForBurn = 0;
881             }
882         	
883         	amount -= fees;
884         }
885 
886         super._transfer(from, to, amount);
887     }
888 
889     function swapTokensForEth(uint256 tokenAmount) private {
890 
891         // generate the uniswap pair path of token -> weth
892         address[] memory path = new address[](2);
893         path[0] = address(this);
894         path[1] = uniswapV2Router.WETH();
895 
896         _approve(address(this), address(uniswapV2Router), tokenAmount);
897 
898         // make the swap
899         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
900             tokenAmount,
901             0, 
902             path,
903             address(this),
904             block.timestamp
905         );
906         
907     }
908     
909     
910     
911     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
912         
913 
914         _approve(address(this), address(uniswapV2Router), tokenAmount);
915 
916         
917         uniswapV2Router.addLiquidityETH{value: ethAmount}(
918             address(this),
919             tokenAmount,
920             0, 
921             0, 
922             deadAddress,
923             block.timestamp
924         );
925 
926     }
927 
928     function swapBack() private {
929         uint256 contractBalance = balanceOf(address(this));
930         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
931         
932         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
933         
934         
935         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
936         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
937         
938         uint256 initialETHBalance = address(this).balance;
939 
940         swapTokensForEth(amountToSwapForETH); 
941         
942         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
943         
944         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
945         
946         
947         uint256 ethForLiquidity = ethBalance - ethForMarketing;
948         tokensForLiquidity = 0;
949         tokensForMarketing = 0;
950         
951         (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
952         if(liquidityTokens > 0 && ethForLiquidity > 0){
953 
954             addLiquidity(liquidityTokens, ethForLiquidity);
955             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
956         }
957         
958         
959         (success,) = address(marketingWallet).call{value: address(this).balance}("");
960     }
961     
962 }