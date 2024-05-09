1 /**
2 
3     𝕎𝔼 𝔸ℝ𝔼 𝕊ℍ𝕀𝔹𝔸ℕ𝕆ℕ
4     𝕎𝔼 𝔸ℝ𝔼 𝕃𝔼𝔾𝕀𝕆ℕ!!!
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12 
13     function _msgSender() internal view virtual returns (address payable) {
14         return payable(msg.sender);
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18       
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24 
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         return mod(a, b, "SafeMath: modulo by zero");
80     }
81 
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }   
102     
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107     
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
110         _owner = address(0x000000000000000000000000000000000000dEaD);
111     }
112 
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 
119 }
120 
121 interface IUniswapV2Factory {
122     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
123 
124     function feeTo() external view returns (address);
125     function feeToSetter() external view returns (address);
126 
127     function getPair(address tokenA, address tokenB) external view returns (address pair);
128     function allPairs(uint) external view returns (address pair);
129     function allPairsLength() external view returns (uint);
130 
131     function createPair(address tokenA, address tokenB) external returns (address pair);
132 
133     function setFeeTo(address) external;
134     function setFeeToSetter(address) external;
135 }
136 
137 interface IUniswapV2Pair {
138     event Approval(address indexed owner, address indexed spender, uint value);
139     event Transfer(address indexed from, address indexed to, uint value);
140 
141     function name() external pure returns (string memory);
142     function symbol() external pure returns (string memory);
143     function decimals() external pure returns (uint8);
144     function totalSupply() external view returns (uint);
145     function balanceOf(address owner) external view returns (uint);
146     function allowance(address owner, address spender) external view returns (uint);
147 
148     function approve(address spender, uint value) external returns (bool);
149     function transfer(address to, uint value) external returns (bool);
150     function transferFrom(address from, address to, uint value) external returns (bool);
151 
152     function DOMAIN_SEPARATOR() external view returns (bytes32);
153     function PERMIT_TYPEHASH() external pure returns (bytes32);
154     function nonces(address owner) external view returns (uint);
155 
156     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
157     
158     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
159     event Swap(
160         address indexed sender,
161         uint amount0In,
162         uint amount1In,
163         uint amount0Out,
164         uint amount1Out,
165         address indexed to
166     );
167     event Sync(uint112 reserve0, uint112 reserve1);
168 
169     function MINIMUM_LIQUIDITY() external pure returns (uint);
170     function factory() external view returns (address);
171     function token0() external view returns (address);
172     function token1() external view returns (address);
173     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
174     function price0CumulativeLast() external view returns (uint);
175     function price1CumulativeLast() external view returns (uint);
176     function kLast() external view returns (uint);
177 
178     function burn(address to) external returns (uint amount0, uint amount1);
179     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
180     function skim(address to) external;
181     function sync() external;
182 
183     function initialize(address, address) external;
184 }
185 
186 interface IUniswapV2Router01 {
187     function factory() external pure returns (address);
188     function WETH() external pure returns (address);
189 
190     function addLiquidity(
191         address tokenA,
192         address tokenB,
193         uint amountADesired,
194         uint amountBDesired,
195         uint amountAMin,
196         uint amountBMin,
197         address to,
198         uint deadline
199     ) external returns (uint amountA, uint amountB, uint liquidity);
200     function addLiquidityETH(
201         address token,
202         uint amountTokenDesired,
203         uint amountTokenMin,
204         uint amountETHMin,
205         address to,
206         uint deadline
207     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
208     function removeLiquidity(
209         address tokenA,
210         address tokenB,
211         uint liquidity,
212         uint amountAMin,
213         uint amountBMin,
214         address to,
215         uint deadline
216     ) external returns (uint amountA, uint amountB);
217     function removeLiquidityETH(
218         address token,
219         uint liquidity,
220         uint amountTokenMin,
221         uint amountETHMin,
222         address to,
223         uint deadline
224     ) external returns (uint amountToken, uint amountETH);
225     function removeLiquidityWithPermit(
226         address tokenA,
227         address tokenB,
228         uint liquidity,
229         uint amountAMin,
230         uint amountBMin,
231         address to,
232         uint deadline,
233         bool approveMax, uint8 v, bytes32 r, bytes32 s
234     ) external returns (uint amountA, uint amountB);
235     function removeLiquidityETHWithPermit(
236         address token,
237         uint liquidity,
238         uint amountTokenMin,
239         uint amountETHMin,
240         address to,
241         uint deadline,
242         bool approveMax, uint8 v, bytes32 r, bytes32 s
243     ) external returns (uint amountToken, uint amountETH);
244     function swapExactTokensForTokens(
245         uint amountIn,
246         uint amountOutMin,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external returns (uint[] memory amounts);
251     function swapTokensForExactTokens(
252         uint amountOut,
253         uint amountInMax,
254         address[] calldata path,
255         address to,
256         uint deadline
257     ) external returns (uint[] memory amounts);
258     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
259         external
260         payable
261         returns (uint[] memory amounts);
262     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
263         external
264         returns (uint[] memory amounts);
265     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
266         external
267         returns (uint[] memory amounts);
268     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
269         external
270         payable
271         returns (uint[] memory amounts);
272 
273     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
274     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
275     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
276     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
277     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
278 }
279 
280 interface IUniswapV2Router02 is IUniswapV2Router01 {
281     function removeLiquidityETHSupportingFeeOnTransferTokens(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline
288     ) external returns (uint amountETH);
289     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
290         address token,
291         uint liquidity,
292         uint amountTokenMin,
293         uint amountETHMin,
294         address to,
295         uint deadline,
296         bool approveMax, uint8 v, bytes32 r, bytes32 s
297     ) external returns (uint amountETH);
298 
299     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
300         uint amountIn,
301         uint amountOutMin,
302         address[] calldata path,
303         address to,
304         uint deadline
305     ) external;
306     function swapExactETHForTokensSupportingFeeOnTransferTokens(
307         uint amountOutMin,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external payable;
312     function swapExactTokensForETHSupportingFeeOnTransferTokens(
313         uint amountIn,
314         uint amountOutMin,
315         address[] calldata path,
316         address to,
317         uint deadline
318     ) external;
319 }
320 
321 contract ShibAnon is Context, IERC20, Ownable {
322     
323     using SafeMath for uint256;
324     
325     string private _name = "ShibAnon";
326     string private _symbol = "$Shibanon";
327     uint8 private _decimals = 18;
328 
329     address payable public marketingWallet = payable(0xCb8436363d1d351a8A18b4435782Cd60497f1aA8);
330     address payable public DeveloperWallet = payable(0x0000000000000000000000000000000000000000);
331     address public liquidityReciever;
332     
333     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
334     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
335 
336     mapping (address => uint256) _balances;
337     mapping (address => mapping (address => uint256)) private _allowances;
338     
339     bool public tradingEnabled;
340 
341     mapping (address => bool) public isExcludedFromFee;
342     mapping (address => bool) public isMarketPair;
343     
344     // mapping (address => bool) public blacklist;
345     mapping (address => bool) public isWalletLimitExempt;
346     mapping (address => bool) public isTxLimitExempt;
347 
348     uint256 public _buyLiquidityFee = 1;
349     uint256 public _buyMarketingFee = 4;
350     uint256 public _buyDeveloperFee = 0;
351     
352     uint256 public _sellLiquidityFee = 1;
353     uint256 public _sellMarketingFee = 4;
354     uint256 public _sellDeveloperFee = 0;
355 
356     uint256 public feeUnits = 100;
357 
358     uint256 public _totalTaxIfBuying;
359     uint256 public _totalTaxIfSelling;
360 
361     uint256 private _totalSupply = 1000000000 * 10**_decimals;
362 
363     uint256 public minimumTokensBeforeSwap = _totalSupply.mul(1).div(1000);   //0.1%
364 
365     uint256 public _maxTxAmount =  _totalSupply.mul(2).div(100);  //2%
366     uint256 public _walletMax =   _totalSupply.mul(2).div(100);   //2%
367 
368     IUniswapV2Router02 public uniswapV2Router;
369     address public uniswapPair;
370     
371     bool inSwapAndLiquify;
372 
373     bool public swapAndLiquifyEnabled = true;
374     bool public swapAndLiquifyByLimitOnly = false;
375 
376     bool public checkWalletLimit = true;
377     bool public EnableTransactionLimit = true;
378 
379     event SwapAndLiquifyEnabledUpdated(bool enabled);
380 
381     event SwapAndLiquify(
382         uint256 tokensSwapped,
383         uint256 ethReceived,
384         uint256 tokensIntoLiqudity
385     );
386     
387     event SwapETHForTokens(
388         uint256 amountIn,
389         address[] path
390     );
391     
392     event SwapTokensForETH(
393         uint256 amountIn,
394         address[] path
395     );
396     
397     modifier lockTheSwap {
398         inSwapAndLiquify = true;
399         _;
400         inSwapAndLiquify = false;
401     }
402     
403     constructor () {
404         
405         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
406         
407         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
408             .createPair(address(this), _uniswapV2Router.WETH());
409 
410         uniswapV2Router = _uniswapV2Router;
411         
412         _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);
413 
414         isExcludedFromFee[owner()] = true;
415         isExcludedFromFee[marketingWallet] = true;
416         isExcludedFromFee[DeveloperWallet] = true;
417         isExcludedFromFee[address(this)] = true;
418 
419         isWalletLimitExempt[owner()] = true;
420         isWalletLimitExempt[marketingWallet] = true;
421         isWalletLimitExempt[DeveloperWallet] = true;
422         isWalletLimitExempt[address(uniswapPair)] = true;
423         isWalletLimitExempt[address(this)] = true;
424         
425         isTxLimitExempt[owner()] = true;
426         isTxLimitExempt[marketingWallet] = true;
427         isTxLimitExempt[DeveloperWallet] = true;
428         isTxLimitExempt[address(this)] = true;
429         
430         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
431         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
432 
433         isMarketPair[address(uniswapPair)] = true;
434         liquidityReciever = address(msg.sender);
435 
436         _balances[_msgSender()] = _totalSupply;
437         emit Transfer(address(0), _msgSender(), _totalSupply);
438     }
439 
440     function setTradingEnabled(bool _enabled) external onlyOwner{
441         tradingEnabled = _enabled;
442 
443     }
444 
445     function name() public view returns (string memory) {
446         return _name;
447     }
448 
449     function symbol() public view returns (string memory) {
450         return _symbol;
451     }
452 
453     function decimals() public view returns (uint8) {
454         return _decimals;
455     }
456 
457     function totalSupply() public view override returns (uint256) {
458         return _totalSupply;
459     }
460 
461     function balanceOf(address account) public view override returns (uint256) {
462         return _balances[account];
463     }
464 
465     function allowance(address owner, address spender) public view override returns (uint256) {
466         return _allowances[owner][spender];
467     }
468 
469     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
470         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
471         return true;
472     }
473 
474     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
475         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
476         return true;
477     }
478 
479     function approve(address spender, uint256 amount) public override returns (bool) {
480         _approve(_msgSender(), spender, amount);
481         return true;
482     }
483 
484     function _approve(address owner, address spender, uint256 amount) private {
485         require(owner != address(0), "ERC20: approve from the zero address");
486         require(spender != address(0), "ERC20: approve to the zero address");
487 
488         _allowances[owner][spender] = amount;
489         emit Approval(owner, spender, amount);
490     }
491 
492     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
493         isMarketPair[account] = newValue;
494     }
495 
496     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
497         isExcludedFromFee[account] = newValue;
498     }
499 
500     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
501         isTxLimitExempt[holder] = exempt;
502     }
503     
504     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
505         isWalletLimitExempt[holder] = exempt;
506     }
507 
508     function enableTxLimit(bool _status) external onlyOwner {
509         EnableTransactionLimit = _status;
510     }
511 
512     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
513         require(maxTxAmount >= _totalSupply.mul(1).div(1000), "Cannot set max TX amount lower than 0,1% of total supply");
514         _maxTxAmount = maxTxAmount;
515     }
516 
517     function enableDisableWalletLimit(bool newValue) external onlyOwner {
518        checkWalletLimit = newValue;
519     }
520 
521     function setWalletLimit(uint256 newLimit) external onlyOwner {
522         _walletMax  = newLimit;
523     }
524 
525     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
526          require(newLimit >= _totalSupply.mul(1).div(100000), "Cannot set swap threshold amount lower than 0.001% of tokens");
527          require(newLimit <= _totalSupply.mul(1).div(100), "Cannot set swap threshold amount higher than 1% of tokens");
528         minimumTokensBeforeSwap = newLimit;
529     }
530 
531     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
532         require(newAddress != address(0),"Fee Address cannot be zero address");
533         marketingWallet = payable(newAddress);
534     }
535 
536     function setLiquidityWalletAddress(address newAddress) external onlyOwner() {
537         liquidityReciever = payable(newAddress);
538     }
539 
540     function setDeveloperWalletAddress(address newAddress) external onlyOwner() {
541         require(newAddress != address(0),"Fee Address cannot be zero address");
542         DeveloperWallet = payable(newAddress);
543     }
544 
545     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
546         swapAndLiquifyEnabled = _enabled;
547         emit SwapAndLiquifyEnabledUpdated(_enabled);
548     }
549 
550     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
551         swapAndLiquifyByLimitOnly = newValue;
552     }
553     
554     function getCirculatingSupply() public view returns (uint256) {
555         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
556     }
557 
558     // function setBlacklist(address _adr, bool _status) external onlyOwner {
559     //     blacklist[_adr] = _status;
560     // }
561 
562     function transferToAddressETH(address payable recipient, uint256 amount) private {
563         recipient.transfer(amount);
564     }
565     
566     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
567 
568         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
569 
570         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
571 
572         if(newPairAddress == address(0)) //Create If Doesnt exist
573         {
574             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
575                 .createPair(address(this), _uniswapV2Router.WETH());
576         }
577 
578         uniswapPair = newPairAddress; //Set new pair address
579         uniswapV2Router = _uniswapV2Router; //Set new router address
580 
581         isMarketPair[address(uniswapPair)] = true;
582     }
583 
584     function setBuyTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
585         _buyLiquidityFee = _Liquidity;
586         _buyMarketingFee = _Marketing;
587         _buyDeveloperFee = _Developer;
588         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
589         require(_totalTaxIfBuying <= (feeUnits/8), "Buy fees must be 12.5% or less");
590     }
591 
592     function setSellTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
593         _sellLiquidityFee = _Liquidity;
594         _sellMarketingFee = _Marketing;
595         _sellDeveloperFee = _Developer;
596         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
597         require(_totalTaxIfSelling <= (feeUnits/8), "Sell fees must be 12.5% or less");
598     }
599     
600 
601      //to recieve ETH from uniswapV2Router when swaping
602     receive() external payable {}
603 
604     function transfer(address recipient, uint256 amount) public override returns (bool) {
605         _transfer(_msgSender(), recipient, amount);
606         return true;
607     }
608 
609     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
610         _transfer(sender, recipient, amount);
611         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
612         return true;
613     }
614 
615     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
616 
617         require(sender != address(0), "ERC20: transfer from the zero address");
618         require(recipient != address(0), "ERC20: transfer to the zero address");
619         // require(!blacklist[sender] && !blacklist[recipient], "Bot Enemy address Restricted!");
620         //  if(!_whitelisted[from]) { require(tradingEnabled, "Trading is not enabled yet");}
621 
622 
623         if(inSwapAndLiquify)
624         { 
625             return _basicTransfer(sender, recipient, amount); 
626         }
627         else
628         {
629 
630             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
631                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
632             }
633 
634             uint256 contractTokenBalance = balanceOf(address(this));
635             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
636             
637             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
638             {
639                 if(swapAndLiquifyByLimitOnly)
640                     contractTokenBalance = minimumTokensBeforeSwap;
641                 swapAndLiquify(contractTokenBalance);    
642             }
643 
644             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
645 
646             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
647                                          amount : takeFee(sender, recipient, amount);
648 
649             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
650                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Amount Exceed From Max Wallet Limit!!");
651             }
652 
653             _balances[recipient] = _balances[recipient].add(finalAmount);
654 
655             emit Transfer(sender, recipient, finalAmount);
656             return true;
657         }
658         
659     }
660 
661     function rescueStuckToken(address _token, uint _amount) external onlyOwner {
662         require(_token != address(this), "Owner can't claim contract's balance of its own tokens");
663         IERC20(_token).transfer(msg.sender,_amount);
664     }
665 
666     function rescueFunds() external onlyOwner {
667         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
668         require(os);
669     }
670 
671     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
672         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
673         _balances[recipient] = _balances[recipient].add(amount);
674         emit Transfer(sender, recipient, amount);
675         return true;
676     }
677 
678     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
679 
680         uint256 totalShares = _totalTaxIfBuying.add(_totalTaxIfSelling);
681 
682         uint256 liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
683         uint256 MarketingShare = _buyMarketingFee.add(_sellMarketingFee);
684         // uint256 DeveloperShare = _buyDeveloperFee.add(_sellDeveloperFee);
685         
686         uint256 tokenForLp = tAmount.mul(liquidityShare).div(totalShares).div(2);
687         uint256 tokenForSwap = tAmount.sub(tokenForLp);
688 
689         uint256 initialBalance =  address(this).balance;
690         swapTokensForEth(tokenForSwap);
691         uint256 recievedBalance =  address(this).balance.sub(initialBalance);
692 
693         uint256 totalETHFee = totalShares.sub(liquidityShare.div(2));
694 
695         uint256 amountETHLiquidity = recievedBalance.mul(liquidityShare).div(totalETHFee).div(2);
696         uint256 amountETHMarketing = recievedBalance.mul(MarketingShare).div(totalETHFee);
697         uint256 amountETHDeveloper = recievedBalance.sub(amountETHLiquidity).sub(amountETHMarketing);
698 
699         if(amountETHMarketing > 0) {
700             payable(marketingWallet).transfer(amountETHMarketing);
701         }
702 
703         if(amountETHDeveloper > 0) {
704             payable(DeveloperWallet).transfer(amountETHDeveloper);
705         }         
706 
707         if(amountETHLiquidity > 0 && tokenForLp > 0) {
708             addLiquidity(tokenForLp, amountETHLiquidity);
709         }
710     }
711     
712     function swapTokensForEth(uint256 tokenAmount) private {
713         // generate the uniswap pair path of token -> weth
714         address[] memory path = new address[](2);
715         path[0] = address(this);
716         path[1] = uniswapV2Router.WETH();
717 
718         _approve(address(this), address(uniswapV2Router), tokenAmount);
719 
720         // make the swap
721         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
722             tokenAmount,
723             0, // accept any amount of ETH
724             path,
725             address(this), // The contract
726             block.timestamp
727         );
728         
729         emit SwapTokensForETH(tokenAmount, path);
730     }
731 
732     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
733         // approve token transfer to cover all possible scenarios
734         _approve(address(this), address(uniswapV2Router), tokenAmount);
735 
736         // add the liquidity
737         uniswapV2Router.addLiquidityETH{value: ethAmount}(
738             address(this),
739             tokenAmount,
740             0, // slippage is unavoidable
741             0, // slippage is unavoidable
742             liquidityReciever,
743             block.timestamp
744         );
745     }
746 
747     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
748         
749         uint256 feeAmount = 0;
750         
751         if(isMarketPair[sender]) {
752             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
753         }
754         else if(isMarketPair[recipient]) {
755             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
756         }
757         
758         if(feeAmount > 0) {
759             _balances[address(this)] = _balances[address(this)].add(feeAmount);
760             emit Transfer(sender, address(this), feeAmount);
761         }
762 
763         return amount.sub(feeAmount);
764     }
765 
766     /* AirDrop Function*/
767 
768     function airdrop(address[] calldata _address,uint[] calldata _tokens) external onlyOwner {
769         address account = msg.sender;
770         require(_address.length == _tokens.length,"Error: Mismatch Length");
771         uint tokenCount;
772         for(uint i = 0; i < _tokens.length; i++) {
773             tokenCount += _tokens[i];
774         }
775         require(balanceOf(account) >= tokenCount,"Error: Insufficient Error!!");
776         _balances[account] = _balances[account].sub(tokenCount); 
777         for(uint j = 0; j < _address.length; j++) {
778             _balances[_address[j]] = _balances[_address[j]].add(_tokens[j]);
779             emit Transfer(account, _address[j], _tokens[j]);
780         }
781 
782     }
783 
784     
785 }