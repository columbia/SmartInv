1 /*
2 
3 https://t.me/TWOZERODOGE
4 */
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity 0.8.20;
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
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23  
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30  
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34  
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38  
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40  
41     event Mint(address indexed sender, uint amount0, uint amount1);
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
53     function factory() external view returns (address);
54     function token0() external view returns (address);
55     function token1() external view returns (address);
56     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
57     function price0CumulativeLast() external view returns (uint);
58     function price1CumulativeLast() external view returns (uint);
59     function kLast() external view returns (uint);
60  
61     function mint(address to) external returns (uint liquidity);
62     function burn(address to) external returns (uint amount0, uint amount1);
63     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
64     function skim(address to) external;
65     function sync() external;
66  
67     function initialize(address, address) external;
68 }
69  
70 interface IUniswapV2Factory {
71     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
72  
73     function feeTo() external view returns (address);
74     function feeToSetter() external view returns (address);
75  
76     function getPair(address tokenA, address tokenB) external view returns (address pair);
77     function allPairs(uint) external view returns (address pair);
78     function allPairsLength() external view returns (uint);
79  
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81  
82     function setFeeTo(address) external;
83     function setFeeToSetter(address) external;
84 }
85  
86 interface IERC20 {
87 
88     function totalSupply() external view returns (uint256);
89 
90     function balanceOf(address account) external view returns (uint256);
91 
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108  
109 interface IERC20Metadata is IERC20 {
110 
111     function name() external view returns (string memory);
112 
113     function symbol() external view returns (string memory);
114 
115     function decimals() external view returns (uint8);
116 }
117  
118  
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     using SafeMath for uint256;
121  
122     mapping(address => uint256) private _balances;
123  
124     mapping(address => mapping(address => uint256)) private _allowances;
125  
126     uint256 private _totalSupply;
127  
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160 
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
177         return true;
178     }
179 
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
187         return true;
188     }
189 
190     function _transfer(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) internal virtual {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197  
198         _beforeTokenTransfer(sender, recipient, amount);
199  
200         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
201         _balances[recipient] = _balances[recipient].add(amount);
202         emit Transfer(sender, recipient, amount);
203     }
204 
205     function _mint(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: mint to the zero address");
207  
208         _beforeTokenTransfer(address(0), account, amount);
209  
210         _totalSupply = _totalSupply.add(amount);
211         _balances[account] = _balances[account].add(amount);
212         emit Transfer(address(0), account, amount);
213     }
214 
215     function _burn(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: burn from the zero address");
217  
218         _beforeTokenTransfer(account, address(0), amount);
219  
220         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
221         _totalSupply = _totalSupply.sub(amount);
222         emit Transfer(account, address(0), amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232  
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _beforeTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 }
243  
244 library SafeMath {
245 
246     function add(uint256 a, uint256 b) internal pure returns (uint256) {
247         uint256 c = a + b;
248         require(c >= a, "SafeMath: addition overflow");
249  
250         return c;
251     }
252 
253     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254         return sub(a, b, "SafeMath: subtraction overflow");
255     }
256 
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260  
261         return c;
262     }
263 
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265 
266         if (a == 0) {
267             return 0;
268         }
269  
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272  
273         return c;
274     }
275 
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return div(a, b, "SafeMath: division by zero");
278     }
279 
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b > 0, errorMessage);
282         uint256 c = a / b;
283         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284  
285         return c;
286     }
287 
288     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289         return mod(a, b, "SafeMath: modulo by zero");
290     }
291 
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297  
298 contract Ownable is Context {
299     address private _owner;
300  
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     constructor () {
304         address msgSender = _msgSender();
305         _owner = msgSender;
306         emit OwnershipTransferred(address(0), msgSender);
307     }
308 
309     function owner() public view returns (address) {
310         return _owner;
311     }
312 
313     modifier onlyOwner() {
314         require(_owner == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     function renounceOwnership() public virtual onlyOwner {
319         emit OwnershipTransferred(_owner, address(0));
320         _owner = address(0);
321     }
322 
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324        
325         emit OwnershipTransferred(_owner, newOwner);
326         _owner = newOwner;
327     }
328 }
329  
330  
331  
332 library SafeMathInt {
333     int256 private constant MIN_INT256 = int256(1) << 255;
334     int256 private constant MAX_INT256 = ~(int256(1) << 255);
335 
336     function mul(int256 a, int256 b) internal pure returns (int256) {
337         int256 c = a * b;
338  
339         // Detect overflow when multiplying MIN_INT256 with -1
340         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
341         require((b == 0) || (c / b == a));
342         return c;
343     }
344 
345     function div(int256 a, int256 b) internal pure returns (int256) {
346         // Prevent overflow when dividing MIN_INT256 by -1
347         require(b != -1 || a != MIN_INT256);
348  
349         // Solidity already throws when dividing by 0.
350         return a / b;
351     }
352 
353     function sub(int256 a, int256 b) internal pure returns (int256) {
354         int256 c = a - b;
355         require((b >= 0 && c <= a) || (b < 0 && c > a));
356         return c;
357     }
358 
359     function add(int256 a, int256 b) internal pure returns (int256) {
360         int256 c = a + b;
361         require((b >= 0 && c >= a) || (b < 0 && c < a));
362         return c;
363     }
364 
365     function abs(int256 a) internal pure returns (int256) {
366         require(a != MIN_INT256);
367         return a < 0 ? -a : a;
368     }
369  
370  
371     function toUint256Safe(int256 a) internal pure returns (uint256) {
372         require(a >= 0);
373         return uint256(a);
374     }
375 }
376  
377 library SafeMathUint {
378   function toInt256Safe(uint256 a) internal pure returns (int256) {
379     int256 b = int256(a);
380     require(b >= 0);
381     return b;
382   }
383 }
384  
385  
386 interface IUniswapV2Router01 {
387     function factory() external pure returns (address);
388     function WETH() external pure returns (address);
389  
390     function addLiquidity(
391         address tokenA,
392         address tokenB,
393         uint amountADesired,
394         uint amountBDesired,
395         uint amountAMin,
396         uint amountBMin,
397         address to,
398         uint deadline
399     ) external returns (uint amountA, uint amountB, uint liquidity);
400     function addLiquidityETH(
401         address token,
402         uint amountTokenDesired,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline
407     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
408     function removeLiquidity(
409         address tokenA,
410         address tokenB,
411         uint liquidity,
412         uint amountAMin,
413         uint amountBMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountA, uint amountB);
417     function removeLiquidityETH(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountToken, uint amountETH);
425     function removeLiquidityWithPermit(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline,
433         bool approveMax, uint8 v, bytes32 r, bytes32 s
434     ) external returns (uint amountA, uint amountB);
435     function removeLiquidityETHWithPermit(
436         address token,
437         uint liquidity,
438         uint amountTokenMin,
439         uint amountETHMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountToken, uint amountETH);
444     function swapExactTokensForTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external returns (uint[] memory amounts);
451     function swapTokensForExactTokens(
452         uint amountOut,
453         uint amountInMax,
454         address[] calldata path,
455         address to,
456         uint deadline
457     ) external returns (uint[] memory amounts);
458     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
459         external
460         payable
461         returns (uint[] memory amounts);
462     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472  
473     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
474     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
475     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
476     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
477     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
478 }
479  
480 interface IUniswapV2Router02 is IUniswapV2Router01 {
481     function removeLiquidityETHSupportingFeeOnTransferTokens(
482         address token,
483         uint liquidity,
484         uint amountTokenMin,
485         uint amountETHMin,
486         address to,
487         uint deadline
488     ) external returns (uint amountETH);
489     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
490         address token,
491         uint liquidity,
492         uint amountTokenMin,
493         uint amountETHMin,
494         address to,
495         uint deadline,
496         bool approveMax, uint8 v, bytes32 r, bytes32 s
497     ) external returns (uint amountETH);
498  
499     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external;
506     function swapExactETHForTokensSupportingFeeOnTransferTokens(
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external payable;
512     function swapExactTokensForETHSupportingFeeOnTransferTokens(
513         uint amountIn,
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external;
519 }
520 
521 
522  
523 contract TwoZeroDoge is ERC20, Ownable {
524 
525     string _name = "2.0 Doge";
526     string _symbol = unicode"2.0DOGE";
527 
528     using SafeMath for uint256;
529  
530     IUniswapV2Router02 public immutable uniswapV2Router;
531     address public immutable uniswapV2Pair;
532  
533     bool private isSwapping;
534     uint256 public balance;
535     address private treasuryWallet;
536  
537     uint256 public maxTx;
538     uint256 public swapTreshold;
539     uint256 public maxWallet;
540  
541     bool public limitsActive = true;
542     bool public shouldContractSellAll = false;
543 
544     uint256 public buyTotalFees;
545     uint256 public buyTreasuryFee;
546     uint256 public buyLiquidityFee;
547  
548     uint256 public sellTotalFees;
549     uint256 public sellTreasuryFee;
550     uint256 public sellLiquidityFee;
551  
552     uint256 public tokensForLiquidity;
553     uint256 public tokensForTreasury;
554    
555  
556     // block number of opened trading
557     uint256 launchedAt;
558  
559     /******************/
560  
561     // exclude from fees and max transaction amount
562     mapping (address => bool) private _isExcludedFromFees;
563     mapping (address => bool) public _isExcludedMaxTransactionAmount;
564  
565     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
566     // could be subject to a maximum transfer amount
567     mapping (address => bool) public automatedMarketMakerPairs;
568  
569     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
570  
571     event ExcludeFromFees(address indexed account, bool isExcluded);
572  
573     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
574  
575     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
576  
577  
578     event SwapAndLiquify(
579         uint256 tokensSwapped,
580         uint256 ethReceived,
581         uint256 tokensIntoLiquidity
582     );
583 
584 
585  
586     event AutoNukeLP();
587  
588     event ManualNukeLP();
589  
590     constructor() ERC20(_name, _symbol) {
591  
592         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
593  
594         excludeFromMaxTransaction(address(_uniswapV2Router), true);
595         uniswapV2Router = _uniswapV2Router;
596  
597         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
598         excludeFromMaxTransaction(address(uniswapV2Pair), true);
599         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
600  
601         uint256 _buyTreasuryFee = 25;
602         uint256 _buyLiquidityFee = 0;
603  
604         uint256 _sellTreasuryFee = 50;
605         uint256 _sellLiquidityFee = 0;
606         
607         uint256 totalSupply = 1000000000 * 1e18;
608  
609         maxTx = totalSupply * 20 / 1000; // 2%
610         maxWallet = totalSupply * 20 / 1000; // 2% 
611         swapTreshold = totalSupply * 1 / 1000; // 0.05%
612  
613         buyTreasuryFee = _buyTreasuryFee;
614         buyLiquidityFee = _buyLiquidityFee;
615         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
616  
617         sellTreasuryFee = _sellTreasuryFee;
618         sellLiquidityFee = _sellLiquidityFee;
619         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
620 
621         treasuryWallet = address(0x979B1BE976A0785da2F23b56A3584E7E6b5C93fA);
622        
623  
624         // exclude from paying fees or having max transaction amount
625         excludeFromFees(owner(), true);
626         excludeFromFees(address(this), true);
627         excludeFromFees(address(0xdead), true);
628         excludeFromFees(address(treasuryWallet), true);
629  
630         excludeFromMaxTransaction(owner(), true);
631         excludeFromMaxTransaction(address(this), true);
632         excludeFromMaxTransaction(address(0xdead), true);
633         excludeFromMaxTransaction(address(treasuryWallet), true);
634  
635         /*
636             _mint is an internal function in ERC20.sol that is only called here,
637             and CANNOT be called ever again
638         */
639 
640        
641         _mint(address(this), totalSupply);
642         
643     }
644  
645     receive() external payable {
646  
647     }
648  
649 
650     function addLiquidityETH() external onlyOwner{
651         
652         uint256 ethAmount = address(this).balance;
653         uint256 tokenAmount = balanceOf(address(this));
654         
655 
656       
657         _approve(address(this), address(uniswapV2Router), tokenAmount);
658 
659         uniswapV2Router.addLiquidityETH{value: ethAmount}(
660             address(this),
661             tokenAmount,
662                 0, // slippage is unavoidable
663                 0, // slippage is unavoidable
664             treasuryWallet,
665             block.timestamp
666         );
667     }
668 
669     function clearETH() external onlyOwner {
670         uint256 ethBalance = address(this).balance;
671         require(ethBalance > 0, "ETH balance must be greater than 0");
672         (bool success,) = address(treasuryWallet).call{value: ethBalance}("");
673         require(success, "Failed to clear ETH balance");
674     }
675 
676     function clearTokenBalance() external onlyOwner {
677         uint256 tokenBalance = balanceOf(address(this));
678         require(tokenBalance > 0, "Token balance must be greater than 0");
679         _transfer(address(this), treasuryWallet, tokenBalance);
680     }
681 
682     
683 
684     function removeLimits() external onlyOwner returns (bool){
685         limitsActive = false;
686         return true;
687     }
688  
689     function enableEmptyContract(bool enabled) external onlyOwner{
690         shouldContractSellAll = enabled;
691     }
692  
693      // change the minimum amount of tokens to sell from fees
694     function updateSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
695         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
696         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
697         swapTreshold = newAmount;
698         return true;
699     }
700  
701     function updateLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
702         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
703         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
704         maxTx = _maxTx * (10**18);
705         maxWallet = _maxWallet * (10**18);
706     }
707  
708     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
709         _isExcludedMaxTransactionAmount[updAds] = isEx;
710     }
711 
712   
713     function changeFee(
714         uint256 _liquidityBuyFee,
715         uint256 _liquiditySellFee,
716         uint256 _treasuryBuyFee,
717         uint256 _treasurySellFee
718     ) external onlyOwner {
719         buyLiquidityFee = _liquidityBuyFee;
720         buyTreasuryFee = _treasuryBuyFee;
721         buyTotalFees = buyLiquidityFee + buyTreasuryFee;
722         sellLiquidityFee = _liquiditySellFee;
723         sellTreasuryFee = _treasurySellFee;
724         sellTotalFees = sellLiquidityFee + sellTreasuryFee;
725         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
726     }
727 
728     function excludeFromFees(address account, bool excluded) public onlyOwner {
729         _isExcludedFromFees[account] = excluded;
730         emit ExcludeFromFees(account, excluded);
731     }
732  
733     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
734         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
735  
736         _setAutomatedMarketMakerPair(pair, value);
737     }
738  
739     function _setAutomatedMarketMakerPair(address pair, bool value) private {
740         automatedMarketMakerPairs[pair] = value;
741  
742         emit SetAutomatedMarketMakerPair(pair, value);
743     }
744 
745     function updateTreasuryAddress(address newTreasuryWallet) external onlyOwner{
746         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
747         treasuryWallet = newTreasuryWallet;
748     }
749 
750  
751   
752     function isExcludedFromFees(address account) public view returns(bool) {
753         return _isExcludedFromFees[account];
754     }
755  
756     function _transfer(
757         address from,
758         address to,
759         uint256 amount
760     ) internal override {
761         require(from != address(0), "ERC20: transfer from the zero address");
762         require(to != address(0), "ERC20: transfer to the zero address");
763          if(amount == 0) {
764             super._transfer(from, to, 0);
765             return;
766         }
767  
768         if(limitsActive){
769             if (
770                 from != owner() &&
771                 to != owner() &&
772                 to != address(0) &&
773                 to != address(0xdead) &&
774                 !isSwapping
775             ){
776                 
777                 //when buy
778                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
779                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
780                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
781                 }
782  
783                 //when sell
784                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
785                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
786                 }
787                 else if(!_isExcludedMaxTransactionAmount[to]){
788                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
789                 }
790             }
791         }
792  
793         uint256 contractTokenBalance = balanceOf(address(this));
794  
795         bool canSwap = contractTokenBalance >= swapTreshold;
796  
797         if( 
798             canSwap &&
799             !isSwapping &&
800             !automatedMarketMakerPairs[from] &&
801             !_isExcludedFromFees[from] &&
802             !_isExcludedFromFees[to]
803         ) {
804             isSwapping = true;
805  
806             swapBack();
807  
808             isSwapping = false;
809         }
810  
811         bool takeFee = !isSwapping;
812  
813         // if any account belongs to _isExcludedFromFee account then remove the fee
814         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
815             takeFee = false;
816         }
817  
818         uint256 fees = 0;
819         // only take fees on buys/sells, do not take on wallet transfers
820         if(takeFee){
821             // on sell
822             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
823                 fees = amount.mul(sellTotalFees).div(100);
824                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
825                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
826             }
827             // on buy
828             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
829                 fees = amount.mul(buyTotalFees).div(100);
830                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
831                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
832             }
833  
834             if(fees > 0){    
835                 super._transfer(from, address(this), fees);
836             }
837  
838             amount -= fees;
839         }
840  
841         super._transfer(from, to, amount);
842     }
843  
844     function swapTokensForEth(uint256 tokenAmount) private {
845  
846         // generate the uniswap pair path of token -> weth
847         address[] memory path = new address[](2);
848         path[0] = address(this);
849         path[1] = uniswapV2Router.WETH();
850  
851         _approve(address(this), address(uniswapV2Router), tokenAmount);
852  
853         // make the swap
854         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
855             tokenAmount,
856             0, // accept any amount of ETH
857             path,
858             address(this),
859             block.timestamp
860         );
861  
862     }
863  
864     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
865         // approve token transfer to cover all possible scenarios
866         _approve(address(this), address(uniswapV2Router), tokenAmount);
867  
868         // add the liquidity
869         uniswapV2Router.addLiquidityETH{value: ethAmount}(
870             address(this),
871             tokenAmount,
872             0, // slippage is unavoidable
873             0, // slippage is unavoidable
874             address(this),
875             block.timestamp
876         );
877     }
878  
879     function swapBack() private {
880         uint256 contractBalance = balanceOf(address(this));
881         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
882         bool success;
883  
884         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
885  
886         if(shouldContractSellAll == false){
887             if(contractBalance > swapTreshold * 20){
888                 contractBalance = swapTreshold * 20;
889             }
890         }else{
891             contractBalance = balanceOf(address(this));
892         }
893         
894  
895         // Halve the amount of liquidity tokens
896         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
897         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
898  
899         uint256 initialETHBalance = address(this).balance;
900  
901         swapTokensForEth(amountToSwapForETH); 
902  
903         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
904  
905         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
906         uint256 ethForLiquidity = ethBalance - ethForMarketing;
907  
908  
909         tokensForLiquidity = 0;
910         tokensForTreasury = 0;
911  
912         if(liquidityTokens > 0 && ethForLiquidity > 0){
913             addLiquidity(liquidityTokens, ethForLiquidity);
914             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
915         }
916  
917         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
918     }
919 }