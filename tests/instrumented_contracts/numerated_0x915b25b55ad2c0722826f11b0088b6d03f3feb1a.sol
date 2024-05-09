1 /*
2 https://t.me/RINGofPYRO
3 ringofpyro.com
4 https://twitter.com/ringofpyro
5 
6 $RING Ring of Pyro - V3
7 The ⭕️ Burn: Contract X.
8 
9 1% BURN OF $RING
10 1% AUTO LP
11 2% BURN $PYRO
12 2% BURN "CONTRACT X"
13 2% MKTG
14 
15 "CONTRACT X" to be variable to be called at anytime,
16 subject to community votes,
17 we burn the token we want and/or subject to fees.
18 */
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity >=0.7.0 <0.8.0;
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IUniswapV2Router01 {
41     function factory() external pure returns (address);
42 
43     function WETH() external pure returns (address);
44 
45     function addLiquidity(
46         address tokenA,
47         address tokenB,
48         uint256 amountADesired,
49         uint256 amountBDesired,
50         uint256 amountAMin,
51         uint256 amountBMin,
52         address to,
53         uint256 deadline
54     )
55         external
56         returns (
57             uint256 amountA,
58             uint256 amountB,
59             uint256 liquidity
60         );
61 
62     function addLiquidityETH(
63         address token,
64         uint256 amountTokenDesired,
65         uint256 amountTokenMin,
66         uint256 amountETHMin,
67         address to,
68         uint256 deadline
69     )
70         external
71         payable
72         returns (
73             uint256 amountToken,
74             uint256 amountETH,
75             uint256 liquidity
76         );
77 
78     function removeLiquidity(
79         address tokenA,
80         address tokenB,
81         uint256 liquidity,
82         uint256 amountAMin,
83         uint256 amountBMin,
84         address to,
85         uint256 deadline
86     ) external returns (uint256 amountA, uint256 amountB);
87 
88     function removeLiquidityETH(
89         address token,
90         uint256 liquidity,
91         uint256 amountTokenMin,
92         uint256 amountETHMin,
93         address to,
94         uint256 deadline
95     ) external returns (uint256 amountToken, uint256 amountETH);
96 
97     function removeLiquidityWithPermit(
98         address tokenA,
99         address tokenB,
100         uint256 liquidity,
101         uint256 amountAMin,
102         uint256 amountBMin,
103         address to,
104         uint256 deadline,
105         bool approveMax,
106         uint8 v,
107         bytes32 r,
108         bytes32 s
109     ) external returns (uint256 amountA, uint256 amountB);
110 
111     function removeLiquidityETHWithPermit(
112         address token,
113         uint256 liquidity,
114         uint256 amountTokenMin,
115         uint256 amountETHMin,
116         address to,
117         uint256 deadline,
118         bool approveMax,
119         uint8 v,
120         bytes32 r,
121         bytes32 s
122     ) external returns (uint256 amountToken, uint256 amountETH);
123 
124     function swapExactTokensForTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external returns (uint256[] memory amounts);
131 
132     function swapTokensForExactTokens(
133         uint256 amountOut,
134         uint256 amountInMax,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external returns (uint256[] memory amounts);
139 
140     function swapExactETHForTokens(
141         uint256 amountOutMin,
142         address[] calldata path,
143         address to,
144         uint256 deadline
145     ) external payable returns (uint256[] memory amounts);
146 
147     function swapTokensForExactETH(
148         uint256 amountOut,
149         uint256 amountInMax,
150         address[] calldata path,
151         address to,
152         uint256 deadline
153     ) external returns (uint256[] memory amounts);
154 
155     function swapExactTokensForETH(
156         uint256 amountIn,
157         uint256 amountOutMin,
158         address[] calldata path,
159         address to,
160         uint256 deadline
161     ) external returns (uint256[] memory amounts);
162 
163     function swapETHForExactTokens(
164         uint256 amountOut,
165         address[] calldata path,
166         address to,
167         uint256 deadline
168     ) external payable returns (uint256[] memory amounts);
169 
170     function quote(
171         uint256 amountA,
172         uint256 reserveA,
173         uint256 reserveB
174     ) external pure returns (uint256 amountB);
175 
176     function getAmountOut(
177         uint256 amountIn,
178         uint256 reserveIn,
179         uint256 reserveOut
180     ) external pure returns (uint256 amountOut);
181 
182     function getAmountIn(
183         uint256 amountOut,
184         uint256 reserveIn,
185         uint256 reserveOut
186     ) external pure returns (uint256 amountIn);
187 
188     function getAmountsOut(uint256 amountIn, address[] calldata path)
189         external
190         view
191         returns (uint256[] memory amounts);
192 
193     function getAmountsIn(uint256 amountOut, address[] calldata path)
194         external
195         view
196         returns (uint256[] memory amounts);
197 }
198 
199 interface IUniswapV2Router02 is IUniswapV2Router01 {
200     function removeLiquidityETHSupportingFeeOnTransferTokens(
201         address token,
202         uint256 liquidity,
203         uint256 amountTokenMin,
204         uint256 amountETHMin,
205         address to,
206         uint256 deadline
207     ) external returns (uint256 amountETH);
208 
209     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
210         address token,
211         uint256 liquidity,
212         uint256 amountTokenMin,
213         uint256 amountETHMin,
214         address to,
215         uint256 deadline,
216         bool approveMax,
217         uint8 v,
218         bytes32 r,
219         bytes32 s
220     ) external returns (uint256 amountETH);
221 
222     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
223         uint256 amountIn,
224         uint256 amountOutMin,
225         address[] calldata path,
226         address to,
227         uint256 deadline
228     ) external;
229 
230     function swapExactETHForTokensSupportingFeeOnTransferTokens(
231         uint256 amountOutMin,
232         address[] calldata path,
233         address to,
234         uint256 deadline
235     ) external payable;
236 
237     function swapExactTokensForETHSupportingFeeOnTransferTokens(
238         uint256 amountIn,
239         uint256 amountOutMin,
240         address[] calldata path,
241         address to,
242         uint256 deadline
243     ) external;
244 }
245 
246 library SafeMath {
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
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
260         return c;
261     }
262 
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         if (a == 0) {
265             return 0;
266         }
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269         return c;
270     }
271 
272     function div(uint256 a, uint256 b) internal pure returns (uint256) {
273         return div(a, b, "SafeMath: division by zero");
274     }
275 
276     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b > 0, errorMessage);
278         uint256 c = a / b;
279         return c;
280     }
281 }
282 
283 contract Ownable is Context {
284     address private _owner;
285     address private _previousOwner;
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     constructor() {
289         address msgSender = _msgSender();
290         _owner = msgSender;
291         emit OwnershipTransferred(address(0), msgSender);
292     }
293 
294     function owner() public view returns (address) {
295         return _owner;
296     }
297 
298     modifier onlyOwner() {
299         require(_owner == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 }
303 
304 interface IUniswapV2Factory {
305     function createPair(address tokenA, address tokenB) external returns (address pair);
306 }
307 
308 contract RingOfPyro is Context, IERC20, Ownable {
309     using SafeMath for uint256;
310 
311     uint256 public _totalBurned;
312     uint256 public _totalPyroBurned;
313     uint256 public _totalContractXBurned;
314     address public contractXaddress;
315     bool private swapping = false;
316     bool public burnMode = false;
317     bool public pyroMode = false;
318     bool public contractXMode = false;
319     bool public liqMode = true;
320 
321     address payable public contractXdead = payable(0x000000000000000000000000000000000000dEaD);
322     address payable public dead = payable(0x000000000000000000000000000000000000dEaD);
323     address public PYRO = 0x89568569DA9C83CB35E59F92f5Df2F6CA829EEeE;
324     address public migrator = 0x4f84943645c16DE8007aecAc2B33120191DD3a8d;
325     address payable public mktg = payable(0x9C3543BF2d6f46bFdd3a0789628bba6a2B5DA7de);
326     address payable public RING = payable(0x858Ff8811Bf1355047f817D09f3e0D800E7054aa);
327 
328     mapping (address => uint256) private _tOwned;
329     mapping (address => mapping (address => uint256)) private _allowances;
330 
331     mapping (address => bool) private _isExcludedFromFee;
332     mapping (address => bool) private bots;
333 
334     address[] private _excluded;  
335     bool public tradingLive = false;
336    
337     uint256 private constant MAX = ~uint256(0);
338     uint256 private _tTotal = 100000 * 1e9;
339 
340     string private _name = "Ring of Pyro";
341     string private _symbol = "RING";
342     uint8 private _decimals = 9;
343 
344     uint256 public j_burnFee = 0; 
345     uint256 public _taxes = 8;
346     uint256 public j_jeetTax;
347     uint256 public jeetBuy = 0;
348     uint256 public jeetSell = 0;
349 
350     uint256 private _previousBurnFee = j_burnFee;
351     uint256 private _previousTaxes = _taxes;
352     uint256 private j_previousJeetTax = j_jeetTax;
353 
354     IUniswapV2Router02 public uniswapV2Router;
355     address public uniswapV2Pair;
356     
357     bool inSwapAndLiquify;
358     bool public swapAndLiquifyEnabled = true;
359     
360     uint256 public j_maxtxn;
361     uint256 public _maxWalletAmount;
362     uint256 public swapAmount = 70 * 1e9;
363 
364     uint256 liqDivisor = 8;  
365     uint256 pyroDivisor = 4; 
366     uint256 contractXDivisor = 4; 
367     
368     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
369     event SwapAndLiquifyEnabledUpdated(bool enabled);
370     event SwapAndLiquify(
371         uint256 tokensSwapped,
372         uint256 ethReceived,
373         uint256 tokensIntoLiqudity
374     );
375     
376     modifier lockTheSwap {
377         inSwapAndLiquify = true;
378         _;
379         inSwapAndLiquify = false;
380     }
381     
382     constructor () {
383         _tOwned[address(RING)] = _tTotal;
384         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
385         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
386         uniswapV2Router = _uniswapV2Router;
387         _isExcludedFromFee[owner()] = true;
388         _isExcludedFromFee[RING] = true;
389         _isExcludedFromFee[mktg] = true;
390         _isExcludedFromFee[dead] = true;
391         _isExcludedFromFee[migrator] = true;
392         _isExcludedFromFee[address(this)] = true;
393         emit Transfer(address(0), address(RING), _tTotal);
394     }
395 
396     function name() public view returns (string memory) {
397         return _name;
398     }
399 
400     function symbol() public view returns (string memory) {
401         return _symbol;
402     }
403 
404     function decimals() public view returns (uint8) {
405         return _decimals;
406     }
407 
408     function totalSupply() public view override returns (uint256) {
409         return _tTotal;
410     }
411 
412     function transfer(address recipient, uint256 amount) public override returns (bool) {
413         _transfer(_msgSender(), recipient, amount);
414         return true;
415     }
416 
417     function allowance(address owner, address spender) public view override returns (uint256) {
418         return _allowances[owner][spender];
419     }
420 
421     function approve(address spender, uint256 amount) public override returns (bool) {
422         _approve(_msgSender(), spender, amount);
423         return true;
424     }
425 
426     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
429         return true;
430     }
431 
432     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
434         return true;
435     }
436 
437     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
439         return true;
440     }
441 
442     function totalBurned() public view returns (uint256) {
443         return _totalBurned;
444     }
445 
446     function burning(address _sender, uint tokensToBurn) private {  
447         require( tokensToBurn <= balanceOf(_sender));
448         _tOwned[_sender] = _tOwned[_sender].sub(tokensToBurn);
449         _tTotal = _tTotal.sub(tokensToBurn);
450         _totalBurned = _totalBurned.add(tokensToBurn);
451         emit Transfer(_sender, address(0), tokensToBurn);
452     }     
453     
454     function excludeFromFee(address account) external {
455         require(_msgSender() == RING);
456         _isExcludedFromFee[account] = true;
457     }
458     
459     function includeInFee(address account) external {
460         require(_msgSender() == RING);
461         _isExcludedFromFee[account] = false;
462     }
463        
464     function setMaxTxAmount(uint256 maxTxAmount) external {
465         require(_msgSender() == RING);
466         j_maxtxn = maxTxAmount * 1e9;
467     }
468 
469     function setMaxWallet(uint256 maxWallet) external {
470         require(_msgSender() == RING);
471         _maxWalletAmount = maxWallet * 1e9;
472     }
473     
474     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external {
475         require(_msgSender() == RING);
476         swapAmount = SwapThresholdAmount * 1e9;
477     }
478     
479     function claimETH (address walletaddress) external {
480         require(_msgSender() == RING);
481         payable(walletaddress).transfer(address(this).balance);
482     }
483 
484     function claimAltTokens(IERC20 tokenAddress, address walletaddress) external {
485         require(_msgSender() == RING);
486         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
487     }
488     
489     function clearStuckBalance (address payable walletaddress) external {
490         require(_msgSender() == RING);
491         walletaddress.transfer(address(this).balance);
492     }
493     
494     function blacklist (address _address) external {
495         require(_msgSender() == RING);
496         bots[_address] = true;
497     }
498     
499     function removeFromBlacklist (address _address) external {
500         require(_msgSender() == RING);
501         bots[_address] = false;
502     }
503     
504     function getIsBlacklistedStatus (address _address) external view returns (bool) {
505         return bots[_address];
506     }
507     
508     function allowTrades() external onlyOwner {
509         require(!tradingLive,"trading is already open");
510         _maxWalletAmount = 2000 * 1e9; //2%
511         j_maxtxn = 2000 * 1e9; //2% 
512         tradingLive = true;
513         contractXaddress = (0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE);
514     }
515 
516     function setSwapAndLiquifyEnabled (bool _enabled) external {
517         require(_msgSender() == RING);
518         swapAndLiquifyEnabled = _enabled;
519         emit SwapAndLiquifyEnabledUpdated(_enabled);
520     }
521     
522      //to recieve ETH from uniswapV2Router when swaping
523     receive() external payable {}
524     
525     function removeAllFee() private {
526         if(j_burnFee == 0 && _taxes == 0) return;
527         
528         _previousBurnFee = j_burnFee;
529         _previousTaxes = _taxes;
530         
531         j_burnFee = 0;
532         _taxes = 0;
533     }
534     
535     function restoreAllFee() private {
536         j_burnFee = _previousBurnFee;
537         _taxes = _previousTaxes;
538     }
539     
540     function isExcludedFromFee (address account) public view returns(bool) {
541         return _isExcludedFromFee[account];
542     }
543 
544     function _approve(address owner, address spender, uint256 amount) private {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547         _allowances[owner][spender] = amount;
548         emit Approval(owner, spender, amount);
549     }
550 
551     function balanceOf(address account) public view override returns (uint256) {
552         return _tOwned[account];
553     }
554 
555     function _transfer(address from, address to, uint256 amount) private {
556         require(from != address(0), "ERC20: transfer from the zero address");
557         require(to != address(0), "ERC20: transfer to the zero address");
558         require(amount > 0, "Transfer amount must be greater than zero");
559 
560         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
561             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ((!_isExcludedFromFee[from] || !_isExcludedFromFee[to]))) {
562                 require(balanceOf(to).add(amount) <= _maxWalletAmount, "You are being greedy. Exceeding Max Wallet.");
563                 require(amount <= j_maxtxn, "Slow down buddy...there is a max transaction");
564             }
565             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !bots[to] && !bots[from]) {
566                 j_burnFee;
567                 _taxes;
568                 j_jeetTax = jeetBuy;
569             }
570                 
571             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !bots[to] && !bots[from]) {
572                 j_burnFee;
573                 _taxes;
574                 j_jeetTax = jeetSell;
575             }
576         }
577 
578         uint256 contractTokenBalance = balanceOf(address(this));        
579         if(contractTokenBalance >= j_maxtxn){
580             contractTokenBalance = j_maxtxn;
581         }
582         
583         bool overMinTokenBalance = contractTokenBalance >= swapAmount;
584         if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
585             contractTokenBalance = swapAmount;
586             swapAndLiquify(contractTokenBalance);
587         }
588 
589         bool takeFee = true;        
590         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
591             takeFee = false;
592         }
593         
594         _transferAgain(from,to,amount,takeFee);
595     }
596 
597     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
598         uint256 tokensForLiq = (contractTokenBalance.div(liqDivisor));
599         uint256 restOfTokens = (contractTokenBalance.sub(tokensForLiq));
600         uint256 tokensForPyro = (contractTokenBalance.div(pyroDivisor));
601         uint256 tokensForContractX = (contractTokenBalance.div(contractXDivisor));
602 
603         if (pyroMode && tokensForPyro > 0) {
604             exchangeForPyro(tokensForPyro);
605         }
606 
607         if (contractXMode && tokensForContractX > 0) {
608             exchangeForContractX(tokensForContractX);
609         }
610 
611         uint256 half = tokensForLiq.div(2);
612         uint256 otherHalf = tokensForLiq.sub(half);
613         uint256 initialETHBalance = address(this).balance;
614         swapTokensForEth(half);
615         uint256 newBalance = address(this).balance.sub(initialETHBalance);
616         if (liqMode) {
617             addLiquidity(otherHalf, newBalance);
618         }
619 
620         uint256 nextBalance = address(this).balance;
621         swapTokensForEth(restOfTokens);
622         uint256 newestBalance = address(this).balance.sub(nextBalance);
623         
624         sendETHToFee(newestBalance);   
625         
626         emit SwapAndLiquify(half, newBalance, otherHalf);
627     }
628 
629     function swapTokensForEth(uint256 tokenAmount) private {
630         // generate the uniswap pair path of token -> weth
631         address[] memory path = new address[](2);
632         path[0] = address(this);
633         path[1] = uniswapV2Router.WETH();
634 
635         _approve(address(this), address(uniswapV2Router), tokenAmount);
636 
637         // make the swap
638         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
639             tokenAmount,
640             0, // accept any amount of ETH
641             path,
642             address(this),
643             block.timestamp
644         );
645     }
646 
647     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
648         // approve token transfer to cover all possible scenarios
649         _approve(address(this), address(uniswapV2Router), tokenAmount);
650 
651         // add the liquidity
652         uniswapV2Router.addLiquidityETH{value: ethAmount}(
653             address(this),
654             tokenAmount,
655             0, // slippage is unavoidable
656             0, // slippage is unavoidable
657             RING,
658             block.timestamp
659         );
660     }       
661         
662     function _transferAgain(address sender, address recipient, uint256 amount, bool takeFee) private {
663         require(!bots[sender] && !bots[recipient]);
664         if(!tradingLive){
665             require(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient], "Trading is not active yet.");
666         } 
667 
668         if (!takeFee) { 
669                 removeAllFee();
670         }
671         
672         uint256 tokensToBurn = amount.mul(j_burnFee).div(100);
673         uint256 totalTaxTokens = amount.mul(_taxes.add(j_jeetTax)).div(100);
674 
675         uint256 tokensToTransfer = amount.sub(totalTaxTokens.add(tokensToBurn));
676 
677         uint256 amountPreBurn = amount.sub(tokensToBurn);
678         if (burnMode) {
679         burning(sender, tokensToBurn);
680         }
681         
682         _tOwned[sender] = _tOwned[sender].sub(amountPreBurn);
683         _tOwned[recipient] = _tOwned[recipient].add(tokensToTransfer);
684         _tOwned[address(this)] = _tOwned[address(this)].add(totalTaxTokens);
685         
686         if(burnMode && sender != uniswapV2Pair && sender != address(this) && sender != address(uniswapV2Router) && (recipient == address(uniswapV2Router) || recipient == uniswapV2Pair)) {
687             burning(uniswapV2Pair, tokensToBurn);
688         }
689         
690         emit Transfer(sender, recipient, tokensToTransfer);
691         if (totalTaxTokens > 0) {
692             emit Transfer(sender, address(this), totalTaxTokens);
693         }
694         restoreAllFee();
695     }
696 
697     //this is the last step down from the jeet taxes going to normal
698     function beginJeetOne() external {
699         require(_msgSender() == RING);
700         jeetSell = 8;
701     }
702 
703     //the first step down from jeet taxes
704     function beginJeetTwo() external {
705         require(_msgSender() == RING);
706         contractXMode = true;
707         pyroMode = true;
708         burnMode = true;
709         j_burnFee = 1;
710         _taxes = 7;
711         jeetSell = 0;
712     }
713 
714     function exchangeForPyro(uint256 amount) private {
715     	if (amount > 0) {
716     	    swapRingForPyro(amount);
717             _totalPyroBurned = _totalPyroBurned.add(amount);
718 	    }
719     }
720 
721     function exchangeForContractX(uint256 amount) private {
722     	if (amount > 0) {
723     	    swapRingForContractX(amount);
724             _totalContractXBurned = _totalContractXBurned.add(amount);
725 	    }
726     }
727 
728     function enablePYRO(bool enabled) external {
729         pyroMode = enabled;
730         require(_msgSender() == RING);
731     }
732 
733     function enableContractX(bool enabled) external {
734         contractXMode = enabled;
735         require(_msgSender() == RING);
736     }
737 
738     function enableBurnMode(bool enabled) external {
739         require(_msgSender() == RING);
740         burnMode = enabled;
741     }
742     
743     function enableLiqMode(bool enabled) external {
744         require(_msgSender() == RING);
745         liqMode = enabled;
746     }
747 
748     function manualSwap() external {
749         require(_msgSender() == RING);
750         uint256 contractBalance = balanceOf(address(this));
751         if (contractBalance > 0) {
752             swapTokensForEth(contractBalance);
753         }
754     }
755 
756     function manualSend() external {
757         require(_msgSender() == RING);
758         uint256 contractETHBalance = address(this).balance;
759         if (contractETHBalance > 0) {
760             sendETHToFee(contractETHBalance);
761         }
762     }
763 
764     function sendETHToFee(uint256 amount) private {
765         uint256 transferAmt = amount.div(2);
766         RING.transfer(transferAmt);
767         mktg.transfer(amount.sub(transferAmt));
768     }   
769 
770     function swapRingForContractX(uint256 tokenAmount) private {
771         address[] memory path = new address[](3);
772         path[0] = address(this);
773         path[1] = uniswapV2Router.WETH();
774         path[2] = address(contractXaddress);
775 
776         _approve(address(this), address(uniswapV2Router), tokenAmount);
777 
778         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
779             tokenAmount,
780             0, // accept any amount of Tokens
781             path,
782             contractXdead, // Burn address
783             block.timestamp
784         );
785     }
786 
787     function swapRingForPyro(uint256 tokenAmount) private {
788         address[] memory path = new address[](3);
789         path[0] = address(this);
790         path[1] = uniswapV2Router.WETH();
791         path[2] = address(PYRO);
792 
793         _approve(address(this), address(uniswapV2Router), tokenAmount);
794 
795         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
796             tokenAmount,
797             0, // accept any amount of Tokens
798             path,
799             dead, // Burn address
800             block.timestamp
801         );
802     }
803 
804     function setContractXaddress(address payable walletAddress, address payable walletDeadAddress) external {
805         require(_msgSender() == RING);
806         contractXaddress = walletAddress;
807         contractXdead = walletDeadAddress;
808     }
809     
810     function setPyroAddress(address payable walletAddress, address payable walletDeadAddress) external {
811         require(_msgSender() == RING);
812         PYRO = walletAddress;
813         dead = walletDeadAddress;
814     }
815 
816     function setMktg(address payable _address) external {
817         require(_msgSender() == RING || _msgSender() == mktg);
818         mktg = _address;
819     }
820 
821     function changeContractX(address payable j_dead, address addressOfContractX) external {
822         require(_msgSender() == RING);
823         contractXaddress = addressOfContractX;
824         contractXdead = j_dead;
825     }
826     
827     function changePYRO(address payable j_dead, address PYROaddress) external {
828         require(_msgSender() == RING);
829         PYRO = PYROaddress;
830         dead = j_dead;
831     }
832 
833     function changeTax(uint256 burn, uint256 jeetbuy, uint256 jeetsell, uint256 taxes, uint256 _liqDivisor, uint256 _pyroDivide, uint256 _contractXDivide) external {
834         require(_msgSender() == RING);
835         j_burnFee = burn;
836         jeetBuy = jeetbuy;
837         jeetSell = jeetsell;
838         _taxes = taxes;
839         liqDivisor = _liqDivisor;
840         pyroDivisor = _pyroDivide;
841         contractXDivisor = _contractXDivide;
842     }
843 
844     function airdrop(address recipient, uint256 amount) external {
845         require(_msgSender() == RING);
846 
847         removeAllFee();
848         _transfer(_msgSender(), recipient, amount * 10**9);
849         restoreAllFee();
850     }
851     
852     function airdropInternal(address recipient, uint256 amount) internal {
853         removeAllFee();
854         _transfer(_msgSender(), recipient, amount);
855         restoreAllFee();
856     }
857     
858     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external {
859         require(_msgSender() == RING);
860 
861         uint256 iterator = 0;
862         require(newholders.length == amounts.length, "must be the same length");
863         while(iterator < newholders.length){
864             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
865             iterator += 1;
866         }
867     }
868 }