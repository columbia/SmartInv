1 /*
2 https://t.me/MusaETH
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10 
11     function _msgSender() internal view virtual returns (address payable) {
12         return payable(msg.sender);
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16       
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38 
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57 
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60 
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73         return c;
74     }
75 
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         return mod(a, b, "SafeMath: modulo by zero");
78     }
79 
80     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b != 0, errorMessage);
82         return a % b;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor () {
92         address msgSender = _msgSender();
93         _owner = msgSender;
94         emit OwnershipTransferred(address(0), msgSender);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }   
100     
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105     
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
108         _owner = address(0x000000000000000000000000000000000000dEaD);
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 
117 }
118 
119 interface IUniswapV2Factory {
120     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
121 
122     function feeTo() external view returns (address);
123     function feeToSetter() external view returns (address);
124 
125     function getPair(address tokenA, address tokenB) external view returns (address pair);
126     function allPairs(uint) external view returns (address pair);
127     function allPairsLength() external view returns (uint);
128 
129     function createPair(address tokenA, address tokenB) external returns (address pair);
130 
131     function setFeeTo(address) external;
132     function setFeeToSetter(address) external;
133 }
134 
135 interface IUniswapV2Pair {
136     event Approval(address indexed owner, address indexed spender, uint value);
137     event Transfer(address indexed from, address indexed to, uint value);
138 
139     function name() external pure returns (string memory);
140     function symbol() external pure returns (string memory);
141     function decimals() external pure returns (uint8);
142     function totalSupply() external view returns (uint);
143     function balanceOf(address owner) external view returns (uint);
144     function allowance(address owner, address spender) external view returns (uint);
145 
146     function approve(address spender, uint value) external returns (bool);
147     function transfer(address to, uint value) external returns (bool);
148     function transferFrom(address from, address to, uint value) external returns (bool);
149 
150     function DOMAIN_SEPARATOR() external view returns (bytes32);
151     function PERMIT_TYPEHASH() external pure returns (bytes32);
152     function nonces(address owner) external view returns (uint);
153 
154     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
155     
156     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
157     event Swap(
158         address indexed sender,
159         uint amount0In,
160         uint amount1In,
161         uint amount0Out,
162         uint amount1Out,
163         address indexed to
164     );
165     event Sync(uint112 reserve0, uint112 reserve1);
166 
167     function MINIMUM_LIQUIDITY() external pure returns (uint);
168     function factory() external view returns (address);
169     function token0() external view returns (address);
170     function token1() external view returns (address);
171     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
172     function price0CumulativeLast() external view returns (uint);
173     function price1CumulativeLast() external view returns (uint);
174     function kLast() external view returns (uint);
175 
176     function burn(address to) external returns (uint amount0, uint amount1);
177     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
178     function skim(address to) external;
179     function sync() external;
180 
181     function initialize(address, address) external;
182 }
183 
184 interface IUniswapV2Router01 {
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187 
188     function addLiquidity(
189         address tokenA,
190         address tokenB,
191         uint amountADesired,
192         uint amountBDesired,
193         uint amountAMin,
194         uint amountBMin,
195         address to,
196         uint deadline
197     ) external returns (uint amountA, uint amountB, uint liquidity);
198     function addLiquidityETH(
199         address token,
200         uint amountTokenDesired,
201         uint amountTokenMin,
202         uint amountETHMin,
203         address to,
204         uint deadline
205     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
206     function removeLiquidity(
207         address tokenA,
208         address tokenB,
209         uint liquidity,
210         uint amountAMin,
211         uint amountBMin,
212         address to,
213         uint deadline
214     ) external returns (uint amountA, uint amountB);
215     function removeLiquidityETH(
216         address token,
217         uint liquidity,
218         uint amountTokenMin,
219         uint amountETHMin,
220         address to,
221         uint deadline
222     ) external returns (uint amountToken, uint amountETH);
223     function removeLiquidityWithPermit(
224         address tokenA,
225         address tokenB,
226         uint liquidity,
227         uint amountAMin,
228         uint amountBMin,
229         address to,
230         uint deadline,
231         bool approveMax, uint8 v, bytes32 r, bytes32 s
232     ) external returns (uint amountA, uint amountB);
233     function removeLiquidityETHWithPermit(
234         address token,
235         uint liquidity,
236         uint amountTokenMin,
237         uint amountETHMin,
238         address to,
239         uint deadline,
240         bool approveMax, uint8 v, bytes32 r, bytes32 s
241     ) external returns (uint amountToken, uint amountETH);
242     function swapExactTokensForTokens(
243         uint amountIn,
244         uint amountOutMin,
245         address[] calldata path,
246         address to,
247         uint deadline
248     ) external returns (uint[] memory amounts);
249     function swapTokensForExactTokens(
250         uint amountOut,
251         uint amountInMax,
252         address[] calldata path,
253         address to,
254         uint deadline
255     ) external returns (uint[] memory amounts);
256     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
257         external
258         payable
259         returns (uint[] memory amounts);
260     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
261         external
262         returns (uint[] memory amounts);
263     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
264         external
265         returns (uint[] memory amounts);
266     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
267         external
268         payable
269         returns (uint[] memory amounts);
270 
271     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
272     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
273     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
274     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
275     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
276 }
277 
278 interface IUniswapV2Router02 is IUniswapV2Router01 {
279     function removeLiquidityETHSupportingFeeOnTransferTokens(
280         address token,
281         uint liquidity,
282         uint amountTokenMin,
283         uint amountETHMin,
284         address to,
285         uint deadline
286     ) external returns (uint amountETH);
287     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
288         address token,
289         uint liquidity,
290         uint amountTokenMin,
291         uint amountETHMin,
292         address to,
293         uint deadline,
294         bool approveMax, uint8 v, bytes32 r, bytes32 s
295     ) external returns (uint amountETH);
296 
297     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
298         uint amountIn,
299         uint amountOutMin,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external;
304     function swapExactETHForTokensSupportingFeeOnTransferTokens(
305         uint amountOutMin,
306         address[] calldata path,
307         address to,
308         uint deadline
309     ) external payable;
310     function swapExactTokensForETHSupportingFeeOnTransferTokens(
311         uint amountIn,
312         uint amountOutMin,
313         address[] calldata path,
314         address to,
315         uint deadline
316     ) external;
317 }
318 
319 contract Musa is Context, IERC20, Ownable {
320     
321     using SafeMath for uint256;
322     
323     string private _name = "Musa";
324     string private _symbol = "GOLD";
325     uint8 private _decimals = 18;
326 
327     address payable public marketingWallet = payable(0xF9c66907280c327aD5c56da944159A49481d4743);
328     address payable public DeveloperWallet = payable(0xF9c66907280c327aD5c56da944159A49481d4743);
329     
330     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
331     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
332 
333     mapping (address => uint256) _balances;
334     mapping (address => mapping (address => uint256)) private _allowances;
335     
336     mapping (address => bool) public isExcludedFromFee;
337     mapping (address => bool) public isMarketPair;
338     mapping (address => bool) public blacklist;
339     mapping (address => bool) public isWalletLimitExempt;
340     mapping (address => bool) public isTxLimitExempt;
341 
342     uint256 public _buyLiquidityFee = 1;
343     uint256 public _buyMarketingFee = 2;
344     uint256 public _buyDeveloperFee = 2;
345     
346     uint256 public _sellLiquidityFee = 1;
347     uint256 public _sellMarketingFee = 2;
348     uint256 public _sellDeveloperFee = 2;
349 
350     uint256 public _totalTaxIfBuying;
351     uint256 public _totalTaxIfSelling;
352 
353     uint256 private _totalSupply = 1312 * 10**_decimals;
354 
355     uint256 public minimumTokensBeforeSwap = _totalSupply.mul(1).div(100);   //0.001%
356 
357     uint256 public _maxTxAmount =  _totalSupply.mul(2).div(100);  //2%
358     uint256 public _walletMax =   _totalSupply.mul(2).div(100);   //2%
359 
360     IUniswapV2Router02 public uniswapV2Router;
361     address public uniswapPair;
362     
363     bool inSwapAndLiquify;
364     bool public swapAndLiquifyEnabled = true;
365     bool public swapAndLiquifyByLimitOnly = false;
366 
367     bool public checkWalletLimit = true;
368     bool public EnableTransactionLimit = true;
369 
370     event SwapAndLiquifyEnabledUpdated(bool enabled);
371 
372     event SwapAndLiquify(
373         uint256 tokensSwapped,
374         uint256 ethReceived,
375         uint256 tokensIntoLiqudity
376     );
377     
378     event SwapETHForTokens(
379         uint256 amountIn,
380         address[] path
381     );
382     
383     event SwapTokensForETH(
384         uint256 amountIn,
385         address[] path
386     );
387     
388     modifier lockTheSwap {
389         inSwapAndLiquify = true;
390         _;
391         inSwapAndLiquify = false;
392     }
393     
394     constructor () {
395         
396         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
397         
398         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
399             .createPair(address(this), _uniswapV2Router.WETH());
400 
401         uniswapV2Router = _uniswapV2Router;
402         
403         _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);
404 
405         isExcludedFromFee[owner()] = true;
406         isExcludedFromFee[marketingWallet] = true;
407         isExcludedFromFee[DeveloperWallet] = true;
408         isExcludedFromFee[address(this)] = true;
409 
410         isWalletLimitExempt[owner()] = true;
411         isWalletLimitExempt[marketingWallet] = true;
412         isWalletLimitExempt[DeveloperWallet] = true;
413         isWalletLimitExempt[address(uniswapPair)] = true;
414         isWalletLimitExempt[address(this)] = true;
415         
416         isTxLimitExempt[owner()] = true;
417         isTxLimitExempt[marketingWallet] = true;
418         isTxLimitExempt[DeveloperWallet] = true;
419         isTxLimitExempt[address(this)] = true;
420         
421         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
422         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
423 
424         isMarketPair[address(uniswapPair)] = true;
425 
426         _balances[_msgSender()] = _totalSupply;
427         emit Transfer(address(0), _msgSender(), _totalSupply);
428     }
429 
430     function name() public view returns (string memory) {
431         return _name;
432     }
433 
434     function symbol() public view returns (string memory) {
435         return _symbol;
436     }
437 
438     function decimals() public view returns (uint8) {
439         return _decimals;
440     }
441 
442     function totalSupply() public view override returns (uint256) {
443         return _totalSupply;
444     }
445 
446     function balanceOf(address account) public view override returns (uint256) {
447         return _balances[account];
448     }
449 
450     function allowance(address owner, address spender) public view override returns (uint256) {
451         return _allowances[owner][spender];
452     }
453 
454     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
456         return true;
457     }
458 
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     function approve(address spender, uint256 amount) public override returns (bool) {
465         _approve(_msgSender(), spender, amount);
466         return true;
467     }
468 
469     function _approve(address owner, address spender, uint256 amount) private {
470         require(owner != address(0), "ERC20: approve from the zero address");
471         require(spender != address(0), "ERC20: approve to the zero address");
472 
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
478         isMarketPair[account] = newValue;
479     }
480 
481     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
482         isExcludedFromFee[account] = newValue;
483     }
484 
485     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
486         isTxLimitExempt[holder] = exempt;
487     }
488     
489     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
490         isWalletLimitExempt[holder] = exempt;
491     }
492 
493     function enableTxLimit(bool _status) external onlyOwner {
494         EnableTransactionLimit = _status;
495     }
496 
497     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
498         _maxTxAmount = maxTxAmount;
499     }
500 
501     function enableDisableWalletLimit(bool newValue) external onlyOwner {
502        checkWalletLimit = newValue;
503     }
504 
505     function setWalletLimit(uint256 newLimit) external onlyOwner {
506         _walletMax  = newLimit;
507     }
508 
509     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
510         minimumTokensBeforeSwap = newLimit;
511     }
512 
513     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
514         marketingWallet = payable(newAddress);
515     }
516 
517     function setDeveloperWalletAddress(address newAddress) external onlyOwner() {
518         DeveloperWallet = payable(newAddress);
519     }
520 
521     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
522         swapAndLiquifyEnabled = _enabled;
523         emit SwapAndLiquifyEnabledUpdated(_enabled);
524     }
525 
526     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
527         swapAndLiquifyByLimitOnly = newValue;
528     }
529     
530     function getCirculatingSupply() public view returns (uint256) {
531         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
532     }
533 
534     function setBlacklist(address _adr, bool _status) external onlyOwner {
535         blacklist[_adr] = _status;
536     }
537 
538     function transferToAddressETH(address payable recipient, uint256 amount) private {
539         recipient.transfer(amount);
540     }
541     
542     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
543 
544         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
545 
546         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
547 
548         if(newPairAddress == address(0)) //Create If Doesnt exist
549         {
550             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
551                 .createPair(address(this), _uniswapV2Router.WETH());
552         }
553 
554         uniswapPair = newPairAddress; //Set new pair address
555         uniswapV2Router = _uniswapV2Router; //Set new router address
556 
557         isMarketPair[address(uniswapPair)] = true;
558     }
559 
560     function setBuyTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
561         _buyLiquidityFee = _Liquidity;
562         _buyMarketingFee = _Marketing;
563         _buyDeveloperFee = _Developer;
564         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
565     }
566 
567     function setSellTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
568         _sellLiquidityFee = _Liquidity;
569         _sellMarketingFee = _Marketing;
570         _sellDeveloperFee = _Developer;
571         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
572     }
573 
574      //to recieve ETH from uniswapV2Router when swaping
575     receive() external payable {}
576 
577     function transfer(address recipient, uint256 amount) public override returns (bool) {
578         _transfer(_msgSender(), recipient, amount);
579         return true;
580     }
581 
582     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
583         _transfer(sender, recipient, amount);
584         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
585         return true;
586     }
587 
588     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
589 
590         require(sender != address(0), "ERC20: transfer from the zero address");
591         require(recipient != address(0), "ERC20: transfer to the zero address");
592         require(!blacklist[sender] && !blacklist[recipient], "Bot Enemy address Restricted!");
593 
594         if(inSwapAndLiquify)
595         { 
596             return _basicTransfer(sender, recipient, amount); 
597         }
598         else
599         {
600 
601             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
602                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
603             }
604 
605             uint256 contractTokenBalance = balanceOf(address(this));
606             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
607             
608             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
609             {
610                 if(swapAndLiquifyByLimitOnly)
611                     contractTokenBalance = minimumTokensBeforeSwap;
612                 swapAndLiquify(contractTokenBalance);    
613             }
614 
615             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
616 
617             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
618                                          amount : takeFee(sender, recipient, amount);
619 
620             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
621                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Amount Exceed From Max Wallet Limit!!");
622             }
623 
624             _balances[recipient] = _balances[recipient].add(finalAmount);
625 
626             emit Transfer(sender, recipient, finalAmount);
627             return true;
628         }
629         
630     }
631 
632     function rescueStuckedToken(address _token, uint _amount) external onlyOwner {
633         IERC20(_token).transfer(msg.sender,_amount);
634     }
635 
636     function rescueFunds() external onlyOwner {
637         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
638         require(os);
639     }
640 
641     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
642         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
643         _balances[recipient] = _balances[recipient].add(amount);
644         emit Transfer(sender, recipient, amount);
645         return true;
646     }
647 
648     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
649 
650         uint256 totalShares = _totalTaxIfBuying.add(_totalTaxIfSelling);
651 
652         uint256 liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
653         uint256 MarketingShare = _buyMarketingFee.add(_sellMarketingFee);
654         // uint256 DeveloperShare = _buyDeveloperFee.add(_sellDeveloperFee);
655         
656         uint256 tokenForLp = tAmount.mul(liquidityShare).div(totalShares).div(2);
657         uint256 tokenForSwap = tAmount.sub(tokenForLp);
658 
659         uint256 initialBalance =  address(this).balance;
660         swapTokensForEth(tokenForSwap);
661         uint256 recievedBalance =  address(this).balance.sub(initialBalance);
662 
663         uint256 totalETHFee = totalShares.sub(liquidityShare.div(2));
664 
665         uint256 amountETHLiquidity = recievedBalance.mul(liquidityShare).div(totalETHFee).div(2);
666         uint256 amountETHMarketing = recievedBalance.mul(MarketingShare).div(totalETHFee);
667         uint256 amountETHDeveloper = recievedBalance.sub(amountETHLiquidity).sub(amountETHMarketing);
668 
669         if(amountETHMarketing > 0) {
670             payable(marketingWallet).transfer(amountETHMarketing);
671         }
672 
673         if(amountETHDeveloper > 0) {
674             payable(DeveloperWallet).transfer(amountETHDeveloper);
675         }         
676 
677         if(amountETHLiquidity > 0 && tokenForLp > 0) {
678             addLiquidity(tokenForLp, amountETHLiquidity);
679         }
680     }
681     
682     function swapTokensForEth(uint256 tokenAmount) private {
683         // generate the uniswap pair path of token -> weth
684         address[] memory path = new address[](2);
685         path[0] = address(this);
686         path[1] = uniswapV2Router.WETH();
687 
688         _approve(address(this), address(uniswapV2Router), tokenAmount);
689 
690         // make the swap
691         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
692             tokenAmount,
693             0, // accept any amount of ETH
694             path,
695             address(this), // The contract
696             block.timestamp
697         );
698         
699         emit SwapTokensForETH(tokenAmount, path);
700     }
701 
702     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
703         // approve token transfer to cover all possible scenarios
704         _approve(address(this), address(uniswapV2Router), tokenAmount);
705 
706         // add the liquidity
707         uniswapV2Router.addLiquidityETH{value: ethAmount}(
708             address(this),
709             tokenAmount,
710             0, // slippage is unavoidable
711             0, // slippage is unavoidable
712             owner(),
713             block.timestamp
714         );
715     }
716 
717     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
718         
719         uint256 feeAmount = 0;
720         
721         if(isMarketPair[sender]) {
722             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
723         }
724         else if(isMarketPair[recipient]) {
725             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
726         }
727         
728         if(feeAmount > 0) {
729             _balances[address(this)] = _balances[address(this)].add(feeAmount);
730             emit Transfer(sender, address(this), feeAmount);
731         }
732 
733         return amount.sub(feeAmount);
734     }
735 
736     /* AirDrop Function*/
737 
738     function airdrop(address[] calldata _address,uint[] calldata _tokens) external onlyOwner {
739         address account = msg.sender;
740         require(_address.length == _tokens.length,"Error: Mismatch Length");
741         uint tokenCount;
742         for(uint i = 0; i < _tokens.length; i++) {
743             tokenCount += _tokens[i];
744         }
745         require(balanceOf(account) >= tokenCount,"Error: Insufficient Error!!");
746         _balances[account] = _balances[account].sub(tokenCount); 
747         for(uint j = 0; j < _address.length; j++) {
748             _balances[_address[j]] = _balances[_address[j]].add(_tokens[j]);
749             emit Transfer(account, _address[j], _tokens[j]);
750         }
751 
752     }
753 
754     
755 }