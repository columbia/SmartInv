1 /*
2 I AM WATER
3 I AM IN SCARCE SUPPLY
4 WATER DOES NOT LIE
5 WATER DOES NOT DECEIVE
6 WATER NEEDS TO GROW
7 WATER WILL NOT MAKE YOU PAY ON YOUR ENTRY
8 WATER WILL MAKE YOU PAY ON EXIT 24 PERCENT FOR A DAY
9 WATER WILL BE YOUR FIRST 100000X
10 WATER HAS TOKENOMICS YET TO BE REVEALED
11 WATER SUGGESTS YOU FORM A COMMUNITY TELEGRAM CALLED GLOBAL H2O DAO
12 WATER WILL LAUNCH ITS WEBSITE AND DAO 72 HOURS AFTER THE COMMUNITY DECIDES ON ITS URL
13 WATER IS WATCHING YOU
14 YOU WATCH THE DEPLOYER MESSAGES
15 TOGETHER WE WILL MOVE WATER TO WHERE IT NEEDS TO GO WHICH IS EVERYWHERE
16 */
17 
18 
19 
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity ^0.8.4;
24 
25 abstract contract Context {
26 
27     function _msgSender() internal view virtual returns (address payable) {
28         return payable(msg.sender);
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32       
33         return msg.data;
34     }
35 }
36 
37 interface IERC20 {
38 
39     function totalSupply() external view returns (uint256);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 library SafeMath {
50 
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b > 0, errorMessage);
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
93         return mod(a, b, "SafeMath: modulo by zero");
94     }
95 
96     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b != 0, errorMessage);
98         return a % b;
99     }
100 }
101 
102 contract Ownable is Context {
103     address private _owner;
104     address private asdasd;
105     uint256 private _lockTime;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     constructor () {
110         address msgSender = _msgSender();
111         _owner = msgSender;
112         emit OwnershipTransferred(address(0), msgSender);
113     }
114 
115     function owner() public view returns (address) {
116         return _owner;
117     }   
118     
119     modifier onlyOwner() {
120         require(_owner == _msgSender(), "Ownable: caller is not the owner");
121         _;
122     }
123     
124     function waiveOwnership() public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
126         _owner = address(0x000000000000000000000000000000000000dEaD);
127     }
128 
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         emit OwnershipTransferred(_owner, newOwner);
132         _owner = newOwner;
133     }
134     
135     function getTime() public view returns (uint256) {
136         return block.timestamp;
137     }
138 
139 }
140 
141 interface IUniswapV2Factory {
142     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
143 
144     function feeTo() external view returns (address);
145     function feeToSetter() external view returns (address);
146 
147     function getPair(address tokenA, address tokenB) external view returns (address pair);
148     function allPairs(uint) external view returns (address pair);
149     function allPairsLength() external view returns (uint);
150 
151     function createPair(address tokenA, address tokenB) external returns (address pair);
152 
153     function setFeeTo(address) external;
154     function setFeeToSetter(address) external;
155 }
156 
157 interface IUniswapV2Pair {
158     event Approval(address indexed owner, address indexed spender, uint value);
159     event Transfer(address indexed from, address indexed to, uint value);
160 
161     function name() external pure returns (string memory);
162     function symbol() external pure returns (string memory);
163     function decimals() external pure returns (uint8);
164     function totalSupply() external view returns (uint);
165     function balanceOf(address owner) external view returns (uint);
166     function allowance(address owner, address spender) external view returns (uint);
167 
168     function approve(address spender, uint value) external returns (bool);
169     function transfer(address to, uint value) external returns (bool);
170     function transferFrom(address from, address to, uint value) external returns (bool);
171 
172     function DOMAIN_SEPARATOR() external view returns (bytes32);
173     function PERMIT_TYPEHASH() external pure returns (bytes32);
174     function nonces(address owner) external view returns (uint);
175 
176     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
177     
178     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
179     event Swap(
180         address indexed sender,
181         uint amount0In,
182         uint amount1In,
183         uint amount0Out,
184         uint amount1Out,
185         address indexed to
186     );
187     event Sync(uint112 reserve0, uint112 reserve1);
188 
189     function MINIMUM_LIQUIDITY() external pure returns (uint);
190     function factory() external view returns (address);
191     function token0() external view returns (address);
192     function token1() external view returns (address);
193     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
194     function price0CumulativeLast() external view returns (uint);
195     function price1CumulativeLast() external view returns (uint);
196     function kLast() external view returns (uint);
197 
198     function burn(address to) external returns (uint amount0, uint amount1);
199     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
200     function skim(address to) external;
201     function sync() external;
202 
203     function initialize(address, address) external;
204 }
205 
206 interface IUniswapV2Router01 {
207     function factory() external pure returns (address);
208     function WETH() external pure returns (address);
209 
210     function addLiquidity(
211         address tokenA,
212         address tokenB,
213         uint amountADesired,
214         uint amountBDesired,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     ) external returns (uint amountA, uint amountB, uint liquidity);
220     function addLiquidityETH(
221         address token,
222         uint amountTokenDesired,
223         uint amountTokenMin,
224         uint amountETHMin,
225         address to,
226         uint deadline
227     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
228     function removeLiquidity(
229         address tokenA,
230         address tokenB,
231         uint liquidity,
232         uint amountAMin,
233         uint amountBMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountA, uint amountB);
237     function removeLiquidityETH(
238         address token,
239         uint liquidity,
240         uint amountTokenMin,
241         uint amountETHMin,
242         address to,
243         uint deadline
244     ) external returns (uint amountToken, uint amountETH);
245     function removeLiquidityWithPermit(
246         address tokenA,
247         address tokenB,
248         uint liquidity,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline,
253         bool approveMax, uint8 v, bytes32 r, bytes32 s
254     ) external returns (uint amountA, uint amountB);
255     function removeLiquidityETHWithPermit(
256         address token,
257         uint liquidity,
258         uint amountTokenMin,
259         uint amountETHMin,
260         address to,
261         uint deadline,
262         bool approveMax, uint8 v, bytes32 r, bytes32 s
263     ) external returns (uint amountToken, uint amountETH);
264     function swapExactTokensForTokens(
265         uint amountIn,
266         uint amountOutMin,
267         address[] calldata path,
268         address to,
269         uint deadline
270     ) external returns (uint[] memory amounts);
271     function swapTokensForExactTokens(
272         uint amountOut,
273         uint amountInMax,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external returns (uint[] memory amounts);
278     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
279         external
280         payable
281         returns (uint[] memory amounts);
282     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
283         external
284         returns (uint[] memory amounts);
285     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
286         external
287         returns (uint[] memory amounts);
288     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
289         external
290         payable
291         returns (uint[] memory amounts);
292 
293     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
294     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
295     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
296     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
297     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
298 }
299 
300 interface IUniswapV2Router02 is IUniswapV2Router01 {
301     function removeLiquidityETHSupportingFeeOnTransferTokens(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountETH);
309     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline,
316         bool approveMax, uint8 v, bytes32 r, bytes32 s
317     ) external returns (uint amountETH);
318 
319     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
320         uint amountIn,
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external;
326     function swapExactETHForTokensSupportingFeeOnTransferTokens(
327         uint amountOutMin,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external payable;
332     function swapExactTokensForETHSupportingFeeOnTransferTokens(
333         uint amountIn,
334         uint amountOutMin,
335         address[] calldata path,
336         address to,
337         uint deadline
338     ) external;
339 }
340 
341 contract PANDA is Context, IERC20, Ownable {
342     
343     using SafeMath for uint256;
344     
345     string private _name = "WATER";
346     string private _symbol = "H20";
347     uint8 private _decimals = 18;
348 
349     address payable public marketingWalletAddress = payable(0x59F032737261062c75D660Bf92d4cd2A1d1851a4);
350     
351     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
352     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
353 
354     
355     mapping (address => uint256) _balances;
356     mapping (address => mapping (address => uint256)) private _allowances;
357     
358     mapping (address => bool) public isExcludedFromFee;
359     mapping (address => bool) public isWalletLimitExempt;
360     mapping (address => bool) public isTxLimitExempt;
361     mapping (address => bool) public isMarketPair;
362     mapping (address => bool) public blacklist;
363 
364     uint256 public _buyLiquidityFee = 0;
365     uint256 public _buyMarketingFee = 0;
366     
367     uint256 public _sellLiquidityFee = 12;
368     uint256 public _sellMarketingFee = 12;
369 
370     uint256 public _liquidityShare = 12;
371     uint256 public _marketingShare = 12;
372 
373     uint256 public _totalTaxIfBuying;
374     uint256 public _totalTaxIfSelling;
375     
376     uint256 public _totalDistributionShares;
377 
378     uint256 private _totalSupply =  1000000 * 10**_decimals;
379 
380     uint256 public _maxTxAmount =   _totalSupply.mul(1).div(1e3);  //0.1%
381     uint256 public _walletMax =     _totalSupply.mul(2).div(1e2);   //3
382 
383     uint256 private minimumTokensBeforeSwap = _totalSupply.mul(1).div(1e4);   //0.001%
384 
385     IUniswapV2Router02 public uniswapV2Router;
386     address public uniswapPair;
387     
388     bool inSwapAndLiquify;
389     bool public swapAndLiquifyEnabled = true;
390     bool public swapAndLiquifyByLimitOnly = false;
391 
392     bool public checkWalletLimit = true;
393     bool public EnableTransactionLimit = true;
394 
395     event SwapAndLiquifyEnabledUpdated(bool enabled);
396 
397     event SwapAndLiquify(
398         uint256 tokensSwapped,
399         uint256 ethReceived,
400         uint256 tokensIntoLiqudity
401     );
402     
403     event SwapETHForTokens(
404         uint256 amountIn,
405         address[] path
406     );
407     
408     event SwapTokensForETH(
409         uint256 amountIn,
410         address[] path
411     );
412     
413     modifier lockTheSwap {
414         inSwapAndLiquify = true;
415         _;
416         inSwapAndLiquify = false;
417     }
418     
419     constructor () {
420         
421         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
422         
423         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
424             .createPair(address(this), _uniswapV2Router.WETH());
425 
426         uniswapV2Router = _uniswapV2Router;
427         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
428 
429         isExcludedFromFee[owner()] = true;
430         isExcludedFromFee[address(this)] = true;
431         
432         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee);
433         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee);
434         _totalDistributionShares = _liquidityShare.add(_marketingShare);
435 
436         isWalletLimitExempt[owner()] = true;
437         isWalletLimitExempt[address(uniswapPair)] = true;
438         isWalletLimitExempt[address(this)] = true;
439         
440         isTxLimitExempt[owner()] = true;
441         isTxLimitExempt[address(this)] = true;
442 
443         isMarketPair[address(uniswapPair)] = true;
444 
445         _balances[_msgSender()] = _totalSupply;
446         emit Transfer(address(0), _msgSender(), _totalSupply);
447     }
448 
449     function name() public view returns (string memory) {
450         return _name;
451     }
452 
453     function symbol() public view returns (string memory) {
454         return _symbol;
455     }
456 
457     function decimals() public view returns (uint8) {
458         return _decimals;
459     }
460 
461     function totalSupply() public view override returns (uint256) {
462         return _totalSupply;
463     }
464 
465     function balanceOf(address account) public view override returns (uint256) {
466         return _balances[account];
467     }
468 
469     function allowance(address owner, address spender) public view override returns (uint256) {
470         return _allowances[owner][spender];
471     }
472 
473     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
474         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
475         return true;
476     }
477 
478     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
479         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
480         return true;
481     }
482 
483     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
484         return minimumTokensBeforeSwap;
485     }
486 
487     function approve(address spender, uint256 amount) public override returns (bool) {
488         _approve(_msgSender(), spender, amount);
489         return true;
490     }
491 
492     function _approve(address owner, address spender, uint256 amount) private {
493         require(owner != address(0), "ERC20: approve from the zero address");
494         require(spender != address(0), "ERC20: approve to the zero address");
495 
496         _allowances[owner][spender] = amount;
497         emit Approval(owner, spender, amount);
498     }
499 
500     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
501         isMarketPair[account] = newValue;
502     }
503 
504     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
505         isTxLimitExempt[holder] = exempt;
506     }
507     
508     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
509         isExcludedFromFee[account] = newValue;
510     }
511 
512     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
513         isWalletLimitExempt[holder] = exempt;
514     }
515 
516     function enableTxLimit(bool _status) external onlyOwner {
517         EnableTransactionLimit = _status;
518     }
519 
520     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
521         _maxTxAmount = maxTxAmount;
522     }
523 
524     function enableDisableWalletLimit(bool newValue) external onlyOwner {
525        checkWalletLimit = newValue;
526     }
527 
528     function setWalletLimit(uint256 newLimit) external onlyOwner {
529         _walletMax  = newLimit;
530     }
531 
532     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
533         minimumTokensBeforeSwap = newLimit;
534     }
535 
536     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
537         marketingWalletAddress = payable(newAddress);
538     }
539 
540     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
541         swapAndLiquifyEnabled = _enabled;
542         emit SwapAndLiquifyEnabledUpdated(_enabled);
543     }
544 
545     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
546         swapAndLiquifyByLimitOnly = newValue;
547     }
548     
549     function getCirculatingSupply() public view returns (uint256) {
550         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
551     }
552 
553     function setBlacklist(address _adr, bool _status) external onlyOwner {
554         require(isContract(_adr),"Enemy must be Contract Address!!");
555         blacklist[_adr] = _status;
556     }
557 
558     function transferToAddressETH(address payable recipient, uint256 amount) private {
559         recipient.transfer(amount);
560     }
561     
562     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
563 
564         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
565 
566         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
567 
568         if(newPairAddress == address(0)) //Create If Doesnt exist
569         {
570             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
571                 .createPair(address(this), _uniswapV2Router.WETH());
572         }
573 
574         uniswapPair = newPairAddress; //Set new pair address
575         uniswapV2Router = _uniswapV2Router; //Set new router address
576 
577         isWalletLimitExempt[address(uniswapPair)] = true;
578         isMarketPair[address(uniswapPair)] = true;
579     }
580 
581      //to recieve ETH from uniswapV2Router when swaping
582     receive() external payable {}
583 
584     function transfer(address recipient, uint256 amount) public override returns (bool) {
585         _transfer(_msgSender(), recipient, amount);
586         return true;
587     }
588 
589     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
590         _transfer(sender, recipient, amount);
591         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
592         return true;
593     }
594   
595 
596     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
597 
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600         require(!blacklist[sender] && !blacklist[recipient], "Bot Enemy address Restricted!.");
601 
602         if(inSwapAndLiquify)
603         { 
604             return _basicTransfer(sender, recipient, amount); 
605         }
606         else
607         {
608             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
609                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
610             }            
611 
612             uint256 contractTokenBalance = balanceOf(address(this));
613             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
614             
615             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
616             {
617                 if(swapAndLiquifyByLimitOnly)
618                     contractTokenBalance = minimumTokensBeforeSwap;
619                 swapAndLiquify(contractTokenBalance);    
620             }
621 
622             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
623 
624             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
625                                          amount : takeFee(sender, recipient, amount);
626 
627             if(checkWalletLimit && !isWalletLimitExempt[recipient])
628                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Amount Exceed From Max Wallet Limit!!");
629 
630             _balances[recipient] = _balances[recipient].add(finalAmount);
631 
632             emit Transfer(sender, recipient, finalAmount);
633             return true;
634         }
635     }
636 
637     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
638         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
639         _balances[recipient] = _balances[recipient].add(amount);
640         emit Transfer(sender, recipient, amount);
641         return true;
642     }
643 
644     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
645         
646         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
647 
648         uint256 tokensForSwap = tAmount.sub(tokensForLP);
649 
650         swapTokensForEth(tokensForSwap);
651 
652         uint256 amountReceived = address(this).balance;
653 
654         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
655         
656         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
657         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity);
658 
659         if(amountBNBMarketing > 0)
660             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
661 
662         if(amountBNBLiquidity > 0 && tokensForLP > 0)
663             addLiquidity(tokensForLP, amountBNBLiquidity);
664     }
665     
666     function swapTokensForEth(uint256 tokenAmount) private {
667         // generate the uniswap pair path of token -> weth
668         address[] memory path = new address[](2);
669         path[0] = address(this);
670         path[1] = uniswapV2Router.WETH();
671 
672         _approve(address(this), address(uniswapV2Router), tokenAmount);
673 
674         // make the swap
675         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
676             tokenAmount,
677             0, // accept any amount of ETH
678             path,
679             address(this), // The contract
680             block.timestamp
681         );
682         
683         emit SwapTokensForETH(tokenAmount, path);
684     }
685 
686     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
687         // approve token transfer to cover all possible scenarios
688         _approve(address(this), address(uniswapV2Router), tokenAmount);
689 
690         // add the liquidity
691         uniswapV2Router.addLiquidityETH{value: ethAmount}(
692             address(this),
693             tokenAmount,
694             0, // slippage is unavoidable
695             0, // slippage is unavoidable
696             owner(),
697             block.timestamp
698         );
699     }
700 
701     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
702         
703         uint256 feeAmount = 0;
704         
705         if(isMarketPair[sender]) {
706             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
707         }
708         else if(isMarketPair[recipient]) {
709             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
710         }
711         
712         if(feeAmount > 0) {
713             _balances[address(this)] = _balances[address(this)].add(feeAmount);
714             emit Transfer(sender, address(this), feeAmount);
715         }
716 
717         return amount.sub(feeAmount);
718     }
719 
720     function isContract(address account) internal view returns (bool) {
721         bytes32 codehash;
722         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
723       
724         assembly { codehash := extcodehash(account) }
725         return (codehash != accountHash && codehash != 0x0);
726     }
727     
728 }