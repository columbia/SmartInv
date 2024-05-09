1 /*
2 
3 πρώτη ένδειξη κρυμμένη στον ιστότοπο
4 https://t.me/AntikytheraPortal
5 https://link.medium.com/wltksh07hwb
6 
7 */
8 
9 
10 pragma solidity 0.8.17;
11 //SPDX-License-Identifier: Unlicensed
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; 
20         return msg.data;
21     }
22 }
23 
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27 
28     function name() external pure returns (string memory);
29 
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39 
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43 
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57 
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59 
60     function factory() external view returns (address);
61     function token0() external view returns (address);
62     function token1() external view returns (address);
63     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64     function price0CumulativeLast() external view returns (uint);
65     function price1CumulativeLast() external view returns (uint);
66 
67     function kLast() external view returns (uint);
68 
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74 
75     function initialize(address, address) external;
76 }
77 
78 interface IUniswapV2Factory {
79     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
80 
81     function feeTo() external view returns (address);
82     function feeToSetter() external view returns (address);
83 
84     function getPair(address tokenA, address tokenB) external view returns (address pair);
85     function allPairs(uint) external view returns (address pair);
86     function allPairsLength() external view returns (uint);
87 
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 
90     function setFeeTo(address) external;
91     function setFeeToSetter(address) external;
92 }
93 interface IERC20 {
94     
95     function totalSupply() external view returns (uint256);
96 
97     
98     function balanceOf(address account) external view returns (uint256);
99 
100     
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     
104     function allowance(address owner, address spender) external view returns (uint256);
105 
106     
107       function approve(address spender, uint256 amount) external returns (bool);
108 
109   
110     function transferFrom(
111         address sender,
112         address recipient,
113         uint256 amount
114 
115     ) external returns (bool);
116 
117     
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 
123 }
124 
125 interface IERC20Metadata is IERC20 {
126     
127      function name() external view returns (string memory);
128 
129     
130     function symbol() external view returns (string memory);
131 
132    
133     function decimals() external view returns (uint8);
134 }
135 
136 
137 contract ERC20 is Context, IERC20, IERC20Metadata {
138     using SafeMath for uint256;
139 
140     mapping(address => uint256) private _balances;
141 
142     mapping(address => mapping(address => uint256)) private _allowances;
143 
144     uint256 private _totalSupply;
145 
146     string private _name;
147     string private _symbol;
148 
149     
150     constructor(string memory name_, string memory symbol_) {
151         _name = name_;
152         _symbol = symbol_;
153     }
154 
155     
156     function name() public view virtual override returns (string memory) {
157         return _name;
158     }
159 
160     
161     function symbol() public view virtual override returns (string memory) {
162         return _symbol;
163 
164     }
165     
166     function decimals() public view virtual override returns (uint8) {
167         return 9;
168     }
169 
170 
171     
172     function totalSupply() public view virtual override returns (uint256) {
173         return _totalSupply;
174     }
175 
176    
177     function balanceOf(address account) public view virtual override returns (uint256) {
178         return _balances[account];
179     }
180 
181     
182     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     
188     function allowance(address owner, address spender) public view virtual override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     
193     function approve(address spender, uint256 amount) public virtual override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) public virtual override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207    
208     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
209         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
210         return true;
211 
212     }
213 
214     
215     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
216         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
217         return true;
218 
219     }
220 
221     
222     function _transfer(
223         address sender,
224         address recipient,
225         uint256 amount
226         ) internal virtual {
227         require(sender != address(0), "ERC20: transfer from the zero address");
228         require(recipient != address(0), "ERC20: transfer to the zero address");
229 
230         _beforeTokenTransfer(sender, recipient, amount);
231 
232         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
233         _balances[recipient] = _balances[recipient].add(amount);
234         emit Transfer(sender, recipient, amount);
235     }
236 
237 
238    
239     function _mint(address account, uint256 amount) internal virtual {
240         require(account != address(0), "ERC20: mint to the zero address");
241 
242         _beforeTokenTransfer(address(0), account, amount);
243 
244         _totalSupply = _totalSupply.add(amount);
245         _balances[account] = _balances[account].add(amount);
246         emit Transfer(address(0), account, amount);
247     }
248 
249     
250     function _burn(address account, uint256 amount) internal virtual {
251         require(account != address(0), "ERC20: burn from the zero address");
252  _beforeTokenTransfer(account, address(0), amount);
253 
254         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
255         _totalSupply = _totalSupply.sub(amount);
256         emit Transfer(account, address(0), amount);
257     }
258 
259 
260     
261     function _approve(
262         address owner,
263         address spender,
264         uint256 amount
265     ) internal virtual {
266         require(owner != address(0), "ERC20: approve from the zero address");
267         require(spender != address(0), "ERC20: approve to the zero address");
268 
269 
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     
275     function _beforeTokenTransfer(
276         address from,
277         address to,
278         uint256 amount
279     ) internal virtual {}
280 
281 }
282 
283 library SafeMath {
284     
285     function add(uint256 a, uint256 b) internal pure returns (uint256) {
286         uint256 c = a + b;
287         require(c >= a, "SafeMath: addition overflow");
288 
289         return c;
290     }
291 
292     
293     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
294         return sub(a, b, "SafeMath: subtraction overflow");
295     }
296 
297 
298     
299     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b <= a, errorMessage);
301         uint256 c = a - b;
302 
303         return c;
304     }
305 
306    
307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
308         
309         if (a == 0) {
310             return 0;
311         }
312          uint256 c = a * b;
313         require(c / a == b, "SafeMath: multiplication overflow");
314 
315         return c;
316     }
317 
318     
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return div(a, b, "SafeMath: division by zero");
321     }
322 
323     
324     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b > 0, errorMessage);
326         uint256 c = a / b;
327        
328         return c;
329     }
330 
331 
332     
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         return mod(a, b, "SafeMath: modulo by zero");
335     }
336      
337     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b != 0, errorMessage);
339 
340         return a % b;
341     }
342 }
343 
344 contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348     
349     
350     constructor () {
351         address msgSender = _msgSender();
352         _owner = msgSender;
353         emit OwnershipTransferred(address(0), msgSender);
354     }
355 
356     
357     function owner() public view returns (address) {
358         return _owner;
359     }
360 
361     
362     
363     modifier onlyOwner() {
364         require(_owner == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     
369     function renounceOwnership() public virtual onlyOwner {
370         emit OwnershipTransferred(_owner, address(0));
371         _owner = address(0);
372     }
373    
374 
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         emit OwnershipTransferred(_owner, newOwner);
378 
379         _owner = newOwner;
380     }
381 }
382 
383 
384 
385 library SafeMathInt {
386     int256 private constant MIN_INT256 = int256(1) << 255;
387     int256 private constant MAX_INT256 = ~(int256(1) << 255);
388 
389    
390     function mul(int256 a, int256 b) internal pure returns (int256) {
391         int256 c = a * b;
392 
393         
394         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
395         require((b == 0) || (c / b == a));
396         return c;
397     }
398 
399     
400     function div(int256 a, int256 b) internal pure returns (int256) {
401         
402         require(b != -1 || a != MIN_INT256);
403 
404 
405         return a / b;
406     }
407 
408     
409     function sub(int256 a, int256 b) internal pure returns (int256) {
410         int256 c = a - b;
411         require((b >= 0 && c <= a) || (b < 0 && c > a));
412         return c;
413     }
414 
415     
416     function add(int256 a, int256 b) internal pure returns (int256) {
417         int256 c = a + b;
418         require((b >= 0 && c >= a) || (b < 0 && c < a));
419         return c;
420     }
421    
422     function abs(int256 a) internal pure returns (int256) {
423         require(a != MIN_INT256);
424 
425         return a < 0 ? -a : a;
426     }
427 
428 
429     function toUint256Safe(int256 a) internal pure returns (uint256) {
430         require(a >= 0);
431         return uint256(a);
432     }
433 }
434 
435 library SafeMathUint {
436   function toInt256Safe(uint256 a) internal pure returns (int256) {
437     int256 b = int256(a);
438     require(b >= 0);
439     return b;
440   }
441 }
442 
443 
444 interface IUniswapV2Router01 {
445     function factory() external pure returns (address);
446     function WETH() external pure returns (address);
447 
448     function addLiquidity(
449         address tokenA,
450         address tokenB,
451         uint amountADesired,
452         uint amountBDesired,
453         uint amountAMin,
454 
455         uint amountBMin,
456         address to,
457         uint deadline
458     ) external returns (uint amountA, uint amountB, uint liquidity);
459     function addLiquidityETH(
460         address token,
461         uint amountTokenDesired,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline
466     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
467     function removeLiquidity(
468         address tokenA,
469         address tokenB,
470         uint liquidity,
471         uint amountAMin,
472         uint amountBMin,
473         address to,
474         uint deadline
475     ) external returns (uint amountA, uint amountB);
476      function removeLiquidityETH(
477         address token,
478         uint liquidity,
479         uint amountTokenMin,
480         uint amountETHMin,
481         address to,
482         uint deadline
483     ) external returns (uint amountToken, uint amountETH);
484     function removeLiquidityWithPermit(
485         address tokenA,
486         address tokenB,
487         uint liquidity,
488         uint amountAMin,
489         uint amountBMin,
490         address to,
491         uint deadline,
492         bool approveMax, uint8 v, bytes32 r, bytes32 s
493     ) external returns (uint amountA, uint amountB);
494     function removeLiquidityETHWithPermit(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline,
501         bool approveMax, uint8 v, bytes32 r, bytes32 s
502     ) external returns (uint amountToken, uint amountETH);
503     function swapExactTokensForTokens(
504         uint amountIn,
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508 
509         uint deadline
510     ) external returns (uint[] memory amounts);
511     function swapTokensForExactTokens(
512         uint amountOut,
513         uint amountInMax,
514         address[] calldata path,
515 
516         address to,
517         uint deadline
518     ) external returns (uint[] memory amounts);
519     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
520         external
521         payable
522         returns (uint[] memory amounts);
523     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
524         external
525         returns (uint[] memory amounts);
526     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
527         external
528         returns (uint[] memory amounts);
529          function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
530         external
531         payable
532         returns (uint[] memory amounts);
533 
534     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
535     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
536     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
537     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
538     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
539 }
540 
541 interface IUniswapV2Router02 is IUniswapV2Router01 {
542     function removeLiquidityETHSupportingFeeOnTransferTokens(
543         address token,
544         uint liquidity,
545         uint amountTokenMin,
546         uint amountETHMin,
547         address to,
548         uint deadline
549     ) external returns (uint amountETH);
550     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
551         address token,
552         uint liquidity,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline,
557         bool approveMax, uint8 v, bytes32 r, bytes32 s
558     ) external returns (uint amountETH);
559 
560     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
561         uint amountIn,
562         uint amountOutMin,
563         address[] calldata path,
564         address to,
565         uint deadline
566     ) external;
567     function swapExactETHForTokensSupportingFeeOnTransferTokens(
568         uint amountOutMin,
569         address[] calldata path,
570         address to,
571         uint deadline
572     ) external payable;
573     function swapExactTokensForETHSupportingFeeOnTransferTokens(
574         uint amountIn,
575 
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579 
580         uint deadline
581     ) external;
582 }
583 contract Antikythera is ERC20, Ownable {
584     using SafeMath for uint256;
585 
586     IUniswapV2Router02 public immutable uniswapV2Router;
587     address public immutable uniswapV2Pair;
588     address public constant deadAddress = address(0xdead);
589 
590     bool private swapping;
591 
592     address public deployerAddress;
593     address public marketingWallet;
594     address public lpLocker;
595     
596     uint256 public maxTransactionAmount;
597     uint256 public swapTokensAtAmount;
598     uint256 public maxWallet;
599 
600     bool public swapEnabled = true;
601 
602     uint256 public buyTotalFees;
603     uint256 public buyMarketingFee;
604     uint256 public buyLiquidityFee;
605     uint256 public buyBurnFee;
606     
607     uint256 public sellTotalFees;
608     uint256 public sellMarketingFee;
609     uint256 public sellLiquidityFee;
610     uint256 public sellBurnFee;
611     
612     uint256 public tokensForMarketing;
613     uint256 public tokensForLiquidity;
614     uint256 public tokensForBurn;
615     
616     /******************/
617 
618    
619     mapping (address => bool) private _isExcludedFromFees;
620     mapping (address => bool) public _isExcludedMaxTransactionAmount;
621 
622   
623     mapping (address => bool) public automatedMarketMakerPairs;
624 
625     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
626 
627     event ExcludeFromFees(address indexed account, bool isExcluded);
628 
629 
630     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
631 
632     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
633     event SwapAndLiquify(
634         uint256 tokensSwapped,
635         uint256 ethReceived,
636         uint256 tokensIntoLiquidity
637     );
638 
639     event BuyBackTriggered(uint256 amount);
640 
641     constructor() ERC20("Antikythera", "Antik") {
642 
643         address newOwner = address(owner());
644         
645         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
646         
647         excludeFromMaxTransaction(address(_uniswapV2Router), true);
648         uniswapV2Router = _uniswapV2Router;
649         
650         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
651         excludeFromMaxTransaction(address(uniswapV2Pair), true);
652         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
653         
654         uint256 _buyMarketingFee = 5;
655         uint256 _buyLiquidityFee = 0;
656 
657         uint256  _buyBurnFee = 0;
658 
659     
660         uint256 _sellMarketingFee = 5;
661         uint256 _sellLiquidityFee = 0;
662         uint256 _sellBurnFee = 2;
663         
664         uint256 totalSupply = 1 * 1e9 * 1e9;
665         
666         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
667         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
668         maxWallet = totalSupply * 2 / 100; // 2% max wallet
669 
670         buyMarketingFee = _buyMarketingFee;
671         buyLiquidityFee = _buyLiquidityFee;
672         buyBurnFee = _buyBurnFee;
673         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
674         
675         sellMarketingFee = _sellMarketingFee;
676         sellLiquidityFee = _sellLiquidityFee;
677         sellBurnFee = _sellBurnFee;
678         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
679         
680         deployerAddress = address(0x37445B96A557f9F13634cD3dF766378C587A31D6); 
681     	marketingWallet = address(0x47C370E32DCAa78943c0F48E4D5A0B7f115242C0); 
682         lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); 
683 
684         
685         excludeFromFees(newOwner, true); // Owner address
686         excludeFromFees(address(this), true); // CA
687         excludeFromFees(address(0xdead), true); // Burn address
688         excludeFromFees(marketingWallet, true); // Marketing wallet
689         excludeFromFees(lpLocker, true); // LP Locker
690         excludeFromFees(deployerAddress, true); // Deployer Address
691         
692         excludeFromMaxTransaction(newOwner, true); // Owner address
693         excludeFromMaxTransaction(address(this), true); // CA
694         excludeFromMaxTransaction(address(0xdead), true); // Burn address
695         excludeFromMaxTransaction(marketingWallet, true); // Marketing wallet
696         excludeFromMaxTransaction(lpLocker, true); // LP Locker
697         excludeFromMaxTransaction(deployerAddress, true); // Deployer Address
698 
699         
700         /*
701             _mint is an internal function in ERC20.sol that is only called here,
702             and CANNOT be called ever again
703         */
704         _mint(newOwner, totalSupply);
705 
706         transferOwnership(newOwner);
707     }
708 
709     receive() external payable {
710 
711   	}
712 
713      
714     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
715   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
716   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
717   	    swapTokensAtAmount = newAmount;
718   	    return true;
719   	}
720     
721     function updateMaxAmount(uint256 newNum) external onlyOwner {
722         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.5%");
723         maxTransactionAmount = newNum * (10**18);
724     }
725     
726     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
727         _isExcludedMaxTransactionAmount[updAds] = isEx;
728     }
729     
730     
731     function updateSwapEnabled(bool enabled) external onlyOwner(){
732 
733         swapEnabled = enabled;
734     }
735 
736     
737     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
738         buyMarketingFee = _marketingFee;
739         buyLiquidityFee = _liquidityFee;
740         buyBurnFee = _burnFee;
741         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
742         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
743     }
744      function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
745         sellMarketingFee = _marketingFee;
746         sellLiquidityFee = _liquidityFee;
747         sellBurnFee = _burnFee;
748         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
749         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
750     }
751 
752     function excludeFromFees(address account, bool excluded) public onlyOwner {
753         _isExcludedFromFees[account] = excluded;
754         emit ExcludeFromFees(account, excluded);
755     }
756 
757     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
758         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
759 
760         _setAutomatedMarketMakerPair(pair, value);
761     }
762 
763     function _setAutomatedMarketMakerPair(address pair, bool value) private {
764         automatedMarketMakerPairs[pair] = value;
765 
766         emit SetAutomatedMarketMakerPair(pair, value);
767     }
768 
769     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
770         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
771         marketingWallet = newMarketingWallet;
772     }
773 
774     function isExcludedFromFees(address account) public view returns(bool) {
775         return _isExcludedFromFees[account];
776 
777     }
778 
779     function _transfer(
780         address from,
781         address to,
782         uint256 amount
783     ) internal override {
784         require(from != address(0), "ERC20: transfer from the zero address");
785         require(to != address(0), "ERC20: transfer to the zero address");
786         
787          if(amount == 0) {
788             super._transfer(from, to, 0);
789             return;
790         }
791         
792 
793             if (
794                 from != owner() &&
795                 to != owner() &&
796                 to != address(0) &&
797                 to != address(0xdead) &&
798                 !swapping
799             ){
800                  
801                 //when buy
802                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
803                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
804                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
805 
806                 }
807                 
808                 //when sell
809                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
810                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
811                 }
812                 else if (!_isExcludedMaxTransactionAmount[to]){
813                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
814                 }
815 
816             }
817         
818         
819         
820         
821 		uint256 contractTokenBalance = balanceOf(address(this));
822         
823         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
824 
825         if( 
826             canSwap &&
827             swapEnabled &&
828             !swapping &&
829             !automatedMarketMakerPairs[from] &&
830             !_isExcludedFromFees[from] &&
831             !_isExcludedFromFees[to]
832         ) {
833             swapping = true;
834             
835             swapBack();
836 
837             swapping = false;
838         }
839         
840         bool takeFee = !swapping;
841 
842         
843         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
844 
845             takeFee = false;
846         }
847         
848         uint256 fees = 0;
849         // only take fees on buys/sells, do not take on wallet transfers
850         if(takeFee){
851             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
852                 fees = amount.mul(sellTotalFees).div(100);
853                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
854                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
855                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
856             }
857               // on buy
858             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
859         	    fees = amount.mul(buyTotalFees).div(100);
860         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
861                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
862                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
863             }
864             
865             if(fees > 0){    
866 
867                 super._transfer(from, address(this), (fees - tokensForBurn));
868             }
869 
870             if(tokensForBurn > 0){
871                 super._transfer(from, deadAddress, tokensForBurn);
872                 tokensForBurn = 0;
873             }
874         	
875         	amount -= fees;
876         }
877 
878         super._transfer(from, to, amount);
879     }
880 
881     function swapTokensForEth(uint256 tokenAmount) private {
882 
883         // generate the uniswap pair path of token -> weth
884         address[] memory path = new address[](2);
885         path[0] = address(this);
886         path[1] = uniswapV2Router.WETH();
887 
888         _approve(address(this), address(uniswapV2Router), tokenAmount);
889 
890         // make the swap
891         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
892             tokenAmount,
893             0, 
894             path,
895             address(this),
896             block.timestamp
897         );
898         
899     }
900     
901     
902     
903     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
904         
905 
906         _approve(address(this), address(uniswapV2Router), tokenAmount);
907 
908         
909         uniswapV2Router.addLiquidityETH{value: ethAmount}(
910             address(this),
911             tokenAmount,
912             0, 
913             0, 
914             deadAddress,
915             block.timestamp
916         );
917 
918     }
919 
920     function swapBack() private {
921         uint256 contractBalance = balanceOf(address(this));
922         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
923         
924         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
925         
926         
927         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
928         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
929         
930         uint256 initialETHBalance = address(this).balance;
931 
932         swapTokensForEth(amountToSwapForETH); 
933         
934         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
935         
936         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
937         
938         
939         uint256 ethForLiquidity = ethBalance - ethForMarketing;
940         tokensForLiquidity = 0;
941         tokensForMarketing = 0;
942         
943         (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
944         if(liquidityTokens > 0 && ethForLiquidity > 0){
945 
946             addLiquidity(liquidityTokens, ethForLiquidity);
947             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
948         }
949         
950         
951         (success,) = address(marketingWallet).call{value: address(this).balance}("");
952     }
953     
954 }