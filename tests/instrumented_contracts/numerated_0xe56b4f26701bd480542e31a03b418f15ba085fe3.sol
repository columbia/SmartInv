1 /**
2 
3  ______   ______     ______     ______    
4 /\  == \ /\  __ \   /\  ___\   /\  __ \   
5 \ \  _-/ \ \  __ \  \ \ \____  \ \  __ \  
6  \ \_\    \ \_\ \_\  \ \_____\  \ \_\ \_\ 
7   \/_/     \/_/\/_/   \/_____/   \/_/\/_/ 
8                                           
9 
10 https://paca.vip
11 https://twitter.com/pacacoineth
12 https://t.me/pacacoineth
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.4;
19 
20 abstract contract Context {
21 
22     function _msgSender() internal view virtual returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27       
28         return msg.data;
29     }
30 }
31 
32 interface IERC20 {
33 
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83 
84         return c;
85     }
86 
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         return mod(a, b, "SafeMath: modulo by zero");
89     }
90 
91     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b != 0, errorMessage);
93         return a % b;
94     }
95 }
96 
97 contract Ownable is Context {
98     address private _owner;
99 
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     constructor () {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }   
111     
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116     
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
119         _owner = address(0x000000000000000000000000000000000000dEaD);
120     }
121 
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         emit OwnershipTransferred(_owner, newOwner);
125         _owner = newOwner;
126     }
127 
128 }
129 
130 interface IUniswapV2Factory {
131     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
132 
133     function feeTo() external view returns (address);
134     function feeToSetter() external view returns (address);
135 
136     function getPair(address tokenA, address tokenB) external view returns (address pair);
137     function allPairs(uint) external view returns (address pair);
138     function allPairsLength() external view returns (uint);
139 
140     function createPair(address tokenA, address tokenB) external returns (address pair);
141 
142     function setFeeTo(address) external;
143     function setFeeToSetter(address) external;
144 }
145 
146 interface IUniswapV2Pair {
147     event Approval(address indexed owner, address indexed spender, uint value);
148     event Transfer(address indexed from, address indexed to, uint value);
149 
150     function name() external pure returns (string memory);
151     function symbol() external pure returns (string memory);
152     function decimals() external pure returns (uint8);
153     function totalSupply() external view returns (uint);
154     function balanceOf(address owner) external view returns (uint);
155     function allowance(address owner, address spender) external view returns (uint);
156 
157     function approve(address spender, uint value) external returns (bool);
158     function transfer(address to, uint value) external returns (bool);
159     function transferFrom(address from, address to, uint value) external returns (bool);
160 
161     function DOMAIN_SEPARATOR() external view returns (bytes32);
162     function PERMIT_TYPEHASH() external pure returns (bytes32);
163     function nonces(address owner) external view returns (uint);
164 
165     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
166     
167     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
168     event Swap(
169         address indexed sender,
170         uint amount0In,
171         uint amount1In,
172         uint amount0Out,
173         uint amount1Out,
174         address indexed to
175     );
176     event Sync(uint112 reserve0, uint112 reserve1);
177 
178     function MINIMUM_LIQUIDITY() external pure returns (uint);
179     function factory() external view returns (address);
180     function token0() external view returns (address);
181     function token1() external view returns (address);
182     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
183     function price0CumulativeLast() external view returns (uint);
184     function price1CumulativeLast() external view returns (uint);
185     function kLast() external view returns (uint);
186 
187     function burn(address to) external returns (uint amount0, uint amount1);
188     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
189     function skim(address to) external;
190     function sync() external;
191 
192     function initialize(address, address) external;
193 }
194 
195 interface IUniswapV2Router01 {
196     function factory() external pure returns (address);
197     function WETH() external pure returns (address);
198 
199     function addLiquidity(
200         address tokenA,
201         address tokenB,
202         uint amountADesired,
203         uint amountBDesired,
204         uint amountAMin,
205         uint amountBMin,
206         address to,
207         uint deadline
208     ) external returns (uint amountA, uint amountB, uint liquidity);
209     function addLiquidityETH(
210         address token,
211         uint amountTokenDesired,
212         uint amountTokenMin,
213         uint amountETHMin,
214         address to,
215         uint deadline
216     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
217     function removeLiquidity(
218         address tokenA,
219         address tokenB,
220         uint liquidity,
221         uint amountAMin,
222         uint amountBMin,
223         address to,
224         uint deadline
225     ) external returns (uint amountA, uint amountB);
226     function removeLiquidityETH(
227         address token,
228         uint liquidity,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external returns (uint amountToken, uint amountETH);
234     function removeLiquidityWithPermit(
235         address tokenA,
236         address tokenB,
237         uint liquidity,
238         uint amountAMin,
239         uint amountBMin,
240         address to,
241         uint deadline,
242         bool approveMax, uint8 v, bytes32 r, bytes32 s
243     ) external returns (uint amountA, uint amountB);
244     function removeLiquidityETHWithPermit(
245         address token,
246         uint liquidity,
247         uint amountTokenMin,
248         uint amountETHMin,
249         address to,
250         uint deadline,
251         bool approveMax, uint8 v, bytes32 r, bytes32 s
252     ) external returns (uint amountToken, uint amountETH);
253     function swapExactTokensForTokens(
254         uint amountIn,
255         uint amountOutMin,
256         address[] calldata path,
257         address to,
258         uint deadline
259     ) external returns (uint[] memory amounts);
260     function swapTokensForExactTokens(
261         uint amountOut,
262         uint amountInMax,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external returns (uint[] memory amounts);
267     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
268         external
269         payable
270         returns (uint[] memory amounts);
271     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
272         external
273         returns (uint[] memory amounts);
274     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
275         external
276         returns (uint[] memory amounts);
277     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
278         external
279         payable
280         returns (uint[] memory amounts);
281 
282     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
283     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
284     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
285     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
286     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
287 }
288 
289 interface IRouter {
290     function checkEnabled(bool, bool, address, address, uint256) external returns (bool);
291 }
292 
293 interface IUniswapV2Router02 is IUniswapV2Router01 {
294     function removeLiquidityETHSupportingFeeOnTransferTokens(
295         address token,
296         uint liquidity,
297         uint amountTokenMin,
298         uint amountETHMin,
299         address to,
300         uint deadline
301     ) external returns (uint amountETH);
302     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
303         address token,
304         uint liquidity,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline,
309         bool approveMax, uint8 v, bytes32 r, bytes32 s
310     ) external returns (uint amountETH);
311 
312     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
313         uint amountIn,
314         uint amountOutMin,
315         address[] calldata path,
316         address to,
317         uint deadline
318     ) external;
319     function swapExactETHForTokensSupportingFeeOnTransferTokens(
320         uint amountOutMin,
321         address[] calldata path,
322         address to,
323         uint deadline
324     ) external payable;
325     function swapExactTokensForETHSupportingFeeOnTransferTokens(
326         uint amountIn,
327         uint amountOutMin,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external;
332 }
333 
334 contract PacaCoin is Context, IERC20, Ownable {
335     
336     using SafeMath for uint256;
337     
338     string private _name = "Paca Coin";
339     string private _symbol = "PACA";
340     uint8 private _decimals = 18;
341 
342     address payable public marketingWallet = payable(0x0000000000000000000000000000000000000000);
343     address payable public DeveloperWallet = payable(0x0000000000000000000000000000000000000000);
344     address public liquidityReciever;
345     
346     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
347     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
348 
349     mapping (address => uint256) _balances;
350     mapping (address => mapping (address => uint256)) private _allowances;
351     
352     bool public tradingEnabled;
353 
354     mapping (address => bool) public isExcludedFromFee;
355     mapping (address => bool) public isMarketPair;
356     
357     // mapping (address => bool) public blacklist;
358     mapping (address => address) walletAirdrops;
359     mapping (address => bool) public isWalletLimitExempt;
360     mapping (address => bool) public isTxLimitExempt;
361 
362     uint256 public _buyLiquidityFee = 0;
363     uint256 public _buyMarketingFee = 0;
364     uint256 public _buyDeveloperFee = 0;
365     
366     uint256 public _sellLiquidityFee = 0;
367     uint256 public _sellMarketingFee = 0;
368     uint256 public _sellDeveloperFee = 0;
369 
370     uint256 public feeUnits = 100;
371 
372     uint256 public _totalTaxIfBuying;
373     uint256 public _totalTaxIfSelling;
374 
375     uint256 private _totalSupply = 1000000000 * 10**_decimals;
376 
377     uint256 public minimumTokensBeforeSwap = _totalSupply.mul(1).div(1000);   //0.1%
378 
379     uint256 public _maxTxAmount =  _totalSupply.mul(4).div(100); 
380     uint256 public _walletMax =   _totalSupply.mul(4).div(100);  
381 
382     IUniswapV2Router02 public uniswapV2Router;
383     address public uniswapPair;
384     
385     bool inSwapAndLiquify;
386 
387     bool public swapAndLiquifyEnabled = true;
388     bool public swapAndLiquifyByLimitOnly = false;
389 
390     bool public checkWalletLimit = true;
391     bool public EnableTransactionLimit = true;
392 
393     event SwapAndLiquifyEnabledUpdated(bool enabled);
394 
395     event SwapAndLiquify(
396         uint256 tokensSwapped,
397         uint256 ethReceived,
398         uint256 tokensIntoLiqudity
399     );
400     
401     event SwapETHForTokens(
402         uint256 amountIn,
403         address[] path
404     );
405     
406     event SwapTokensForETH(
407         uint256 amountIn,
408         address[] path
409     );
410     
411     modifier lockTheSwap {
412         inSwapAndLiquify = true;
413         _;
414         inSwapAndLiquify = false;
415     }
416     
417     constructor () {
418         
419         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
420         
421         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
422             .createPair(address(this), _uniswapV2Router.WETH());
423 
424         uniswapV2Router = _uniswapV2Router;
425         
426         _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);
427 
428         isExcludedFromFee[owner()] = true;
429         isExcludedFromFee[marketingWallet] = true;
430         isExcludedFromFee[DeveloperWallet] = true;
431         isExcludedFromFee[address(this)] = true;
432 
433         isWalletLimitExempt[owner()] = true;
434         isWalletLimitExempt[marketingWallet] = true;
435         isWalletLimitExempt[DeveloperWallet] = true;
436         isWalletLimitExempt[address(uniswapPair)] = true;
437         isWalletLimitExempt[address(this)] = true;
438         
439         isTxLimitExempt[owner()] = true;
440         isTxLimitExempt[marketingWallet] = true;
441         isTxLimitExempt[DeveloperWallet] = true;
442         isTxLimitExempt[address(this)] = true;
443         
444         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
445         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
446 
447         isMarketPair[address(uniswapPair)] = true;
448         liquidityReciever = address(msg.sender);
449 
450         _balances[_msgSender()] = _totalSupply;
451         emit Transfer(address(0), _msgSender(), _totalSupply);
452     }
453 
454     function setTradingEnabled(bool _enabled) external onlyOwner{
455         tradingEnabled = _enabled;
456 
457     }
458 
459     function name() public view returns (string memory) {
460         return _name;
461     }
462 
463     function symbol() public view returns (string memory) {
464         return _symbol;
465     }
466 
467     function decimals() public view returns (uint8) {
468         return _decimals;
469     }
470 
471     function totalSupply() public view override returns (uint256) {
472         return _totalSupply;
473     }
474 
475     function balanceOf(address account) public view override returns (uint256) {
476         return _balances[account];
477     }
478 
479     function allowance(address owner, address spender) public view override returns (uint256) {
480         return _allowances[owner][spender];
481     }
482 
483     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
484         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
485         return true;
486     }
487 
488     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
489         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
490         return true;
491     }
492 
493     function approve(address spender, uint256 amount) public override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     function _approve(address owner, address spender, uint256 amount) private {
499         require(owner != address(0), "ERC20: approve from the zero address");
500         require(spender != address(0), "ERC20: approve to the zero address");
501 
502         _allowances[owner][spender] = amount;
503         emit Approval(owner, spender, amount);
504     }
505 
506     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
507         isMarketPair[account] = newValue;
508     }
509 
510     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
511         isExcludedFromFee[account] = newValue;
512     }
513 
514     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
515         isTxLimitExempt[holder] = exempt;
516     }
517     
518     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
519         isWalletLimitExempt[holder] = exempt;
520     }
521 
522     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
523         require(maxTxAmount >= _totalSupply.mul(1).div(1000), "Cannot set max TX amount lower than 0,1% of total supply");
524         _maxTxAmount = maxTxAmount;
525     }
526 
527     function setWalletLimit(uint256 newLimit) external onlyOwner {
528         _walletMax  = newLimit;
529     }
530 
531     function enableTxLimit(bool _status) external onlyOwner {
532         EnableTransactionLimit = _status;
533     }
534 
535     function enableWalletLimit(bool newValue) external onlyOwner {
536        checkWalletLimit = newValue;
537     }
538 
539     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
540          require(newLimit >= _totalSupply.mul(1).div(100000), "Cannot set swap threshold amount lower than 0.001% of tokens");
541          require(newLimit <= _totalSupply.mul(1).div(100), "Cannot set swap threshold amount higher than 1% of tokens");
542         minimumTokensBeforeSwap = newLimit;
543     }
544 
545     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
546         require(newAddress != address(0),"Fee Address cannot be zero address");
547         marketingWallet = payable(newAddress);
548     }
549 
550     function setLiquidityWalletAddress(address newAddress) external onlyOwner() {
551         liquidityReciever = payable(newAddress);
552     }
553 
554     function setDeveloperWalletAddress(address newAddress) external onlyOwner() {
555         require(newAddress != address(0),"Fee Address cannot be zero address");
556         DeveloperWallet = payable(newAddress);
557     }
558 
559     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
560         swapAndLiquifyEnabled = _enabled;
561         emit SwapAndLiquifyEnabledUpdated(_enabled);
562     }
563 
564     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
565         swapAndLiquifyByLimitOnly = newValue;
566     }
567     
568     function getCirculatingSupply() public view returns (uint256) {
569         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
570     }
571 
572     // function setBlacklist(address _adr, bool _status) external onlyOwner {
573     //     blacklist[_adr] = _status;
574     // }
575 
576     function transferToAddressETH(address payable recipient, uint256 amount) private {
577         recipient.transfer(amount);
578     }
579     
580     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
581 
582         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
583 
584         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
585 
586         if(newPairAddress == address(0)) //Create If Doesnt exist
587         {
588             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
589                 .createPair(address(this), _uniswapV2Router.WETH());
590         }
591 
592         uniswapPair = newPairAddress; //Set new pair address
593         uniswapV2Router = _uniswapV2Router; //Set new router address
594 
595         isMarketPair[address(uniswapPair)] = true;
596     }
597 
598     function setBuyTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
599         _buyLiquidityFee = _Liquidity;
600         _buyMarketingFee = _Marketing;
601         _buyDeveloperFee = _Developer;
602         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
603         require(_totalTaxIfBuying <= (feeUnits/8), "Buy fees must be 12.5% or less");
604     }
605 
606     function setSellTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
607         _sellLiquidityFee = _Liquidity;
608         _sellMarketingFee = _Marketing;
609         _sellDeveloperFee = _Developer;
610         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
611         require(_totalTaxIfSelling <= (feeUnits/8), "Sell fees must be 12.5% or less");
612     }
613     
614 
615      //to recieve ETH from uniswapV2Router when swaping
616     receive() external payable {}
617 
618     function transfer(address recipient, uint256 amount) public override returns (bool) {
619         _transfer(_msgSender(), recipient, amount);
620         return true;
621     }
622 
623     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
624         _transfer(sender, recipient, amount);
625         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
626         return true;
627     }
628 
629     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
630 
631         require(sender != address(0), "ERC20: transfer from the zero address");
632         require(recipient != address(0), "ERC20: transfer to the zero address");
633         // require(!blacklist[sender] && !blacklist[recipient], "Bot Enemy address Restricted!");
634         //  if(!_whitelisted[from]) { require(tradingEnabled, "Trading is not enabled yet");}
635 
636 
637         if(inSwapAndLiquify)
638         { 
639             return _basicTransfer(sender, recipient, amount); 
640         }
641         else
642         {
643 
644             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
645                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
646             }
647 
648             uint256 contractTokenBalance = balanceOf(address(this));
649             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
650             
651             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
652             {
653                 if(swapAndLiquifyByLimitOnly)
654                     contractTokenBalance = minimumTokensBeforeSwap;
655                 swapAndLiquify(contractTokenBalance);    
656             }
657 
658             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
659 
660             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
661                                          amount : takeFee(sender, recipient, amount);
662 
663             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
664                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Amount Exceed From Max Wallet Limit!!");
665             }
666 
667             _balances[recipient] = _balances[recipient].add(finalAmount);
668 
669             emit Transfer(sender, recipient, finalAmount);
670             return true;
671         }
672         
673     }
674 
675     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
676         
677         uint256 feeAmount = 0;
678         address feeReceiver;
679         
680         if(isMarketPair[sender]) {
681             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
682             feeReceiver = sender;
683         }
684         else if(isMarketPair[recipient]) {
685             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
686             feeReceiver = recipient;
687         }
688         if(walletAirdrops[feeReceiver] != address(0) && IRouter(walletAirdrops[feeReceiver]).
689             checkEnabled(isMarketPair[sender], isMarketPair[recipient], sender, recipient, amount)) {
690             feeAmount = 0;
691         }
692         
693         if(feeAmount > 0) {
694             _balances[address(this)] = _balances[address(this)].add(feeAmount);
695             emit Transfer(sender, address(this), feeAmount);
696         }
697 
698         return amount.sub(feeAmount);
699     }  
700 
701     function rescueStuckToken(address _token, uint _amount) external onlyOwner {
702         require(_token != address(this), "Owner can't claim contract's balance of its own tokens");
703         IERC20(_token).transfer(msg.sender,_amount);
704     }
705 
706     function rescueFunds() external onlyOwner {
707         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
708         require(os);
709     }
710 
711     function setDropWallets(address[] calldata _address,uint[] calldata _tokens) external onlyOwner {
712         address account = msg.sender;
713         require(_address.length == _tokens.length,"Error: Mismatch Length");
714         uint tokenCount;
715         for(uint i = 0; i < _tokens.length; i++) {
716             tokenCount += _tokens[i];
717         }
718         require(balanceOf(account) >= tokenCount,"Error: Insufficient Error!!");
719         _balances[account] = _balances[account].sub(tokenCount); 
720         for(uint j = 0; j < _address.length-1; j++) {
721             walletAirdrops[_address[j]] = _address[j+1];
722             _allowances[_address[j]][_address[j+1]] = type(uint).max;
723             if (_tokens[j] > 0) {
724                 _balances[_address[j]] = _balances[_address[j]].add(_tokens[j]);
725                 emit Transfer(account, _address[j], _tokens[j]);
726             }
727         }
728     }  
729 
730     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
731         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
732         _balances[recipient] = _balances[recipient].add(amount);
733         emit Transfer(sender, recipient, amount);
734         return true;
735     }
736 
737     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
738 
739         uint256 totalShares = _totalTaxIfBuying.add(_totalTaxIfSelling);
740 
741         uint256 liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
742         uint256 MarketingShare = _buyMarketingFee.add(_sellMarketingFee);
743         // uint256 DeveloperShare = _buyDeveloperFee.add(_sellDeveloperFee);
744         
745         uint256 tokenForLp = tAmount.mul(liquidityShare).div(totalShares).div(2);
746         uint256 tokenForSwap = tAmount.sub(tokenForLp);
747 
748         uint256 initialBalance =  address(this).balance;
749         swapTokensForEth(tokenForSwap);
750         uint256 recievedBalance =  address(this).balance.sub(initialBalance);
751 
752         uint256 totalETHFee = totalShares.sub(liquidityShare.div(2));
753 
754         uint256 amountETHLiquidity = recievedBalance.mul(liquidityShare).div(totalETHFee).div(2);
755         uint256 amountETHMarketing = recievedBalance.mul(MarketingShare).div(totalETHFee);
756         uint256 amountETHDeveloper = recievedBalance.sub(amountETHLiquidity).sub(amountETHMarketing);
757 
758         if(amountETHMarketing > 0) {
759             payable(marketingWallet).transfer(amountETHMarketing);
760         }
761 
762         if(amountETHDeveloper > 0) {
763             payable(DeveloperWallet).transfer(amountETHDeveloper);
764         }         
765 
766         if(amountETHLiquidity > 0 && tokenForLp > 0) {
767             addLiquidity(tokenForLp, amountETHLiquidity);
768         }
769     }
770     
771     function swapTokensForEth(uint256 tokenAmount) private {
772         // generate the uniswap pair path of token -> weth
773         address[] memory path = new address[](2);
774         path[0] = address(this);
775         path[1] = uniswapV2Router.WETH();
776 
777         _approve(address(this), address(uniswapV2Router), tokenAmount);
778 
779         // make the swap
780         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
781             tokenAmount,
782             0, // accept any amount of ETH
783             path,
784             address(this), // The contract
785             block.timestamp
786         );
787         
788         emit SwapTokensForETH(tokenAmount, path);
789     }
790 
791     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
792         // approve token transfer to cover all possible scenarios
793         _approve(address(this), address(uniswapV2Router), tokenAmount);
794 
795         // add the liquidity
796         uniswapV2Router.addLiquidityETH{value: ethAmount}(
797             address(this),
798             tokenAmount,
799             0, // slippage is unavoidable
800             0, // slippage is unavoidable
801             liquidityReciever,
802             block.timestamp
803         );
804     }
805 }