1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.12;
4 
5 interface IBEP20 {
6     function totalSupply() external view returns (uint);
7     function balanceOf(address account) external view returns (uint);
8     function transfer(address recipient, uint amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint);
10     function approve(address spender, uint amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint) {
17         uint c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22     function sub(uint a, uint b) internal pure returns (uint) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
26         require(b <= a, errorMessage);
27         uint c = a - b;
28 
29         return c;
30     }
31     function mul(uint a, uint b) internal pure returns (uint) {
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38 
39         return c;
40     }
41     function div(uint a, uint b) internal pure returns (uint) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
45         // Solidity only automatically asserts when dividing by 0
46         require(b > 0, errorMessage);
47         uint c = a / b;
48 
49         return c;
50     }
51 }
52 
53 contract Context {
54     constructor () { }
55     // solhint-disable-previous-line no-empty-blocks
56 
57     function _msgSender() internal view returns (address) {
58         return msg.sender;
59     }
60 }
61 
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor () {
71        
72         _owner = msg.sender ;
73         emit OwnershipTransferred(address(0), _owner);
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(_owner == _msgSender() , "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         emit OwnershipTransferred(_owner, newOwner);
110         _owner = newOwner;
111     }
112 }
113 
114 
115 contract BEP20Detailed {
116     string private _name;
117     string private _symbol;
118     uint8 private _decimals;
119 
120     constructor (string memory tname, string memory tsymbol, uint8 tdecimals) {
121         _name = tname;
122         _symbol = tsymbol;
123         _decimals = tdecimals;
124         
125     }
126     function name() public view returns (string memory) {
127         return _name;
128     }
129     function symbol() public view returns (string memory) {
130         return _symbol;
131     }
132     function decimals() public view returns (uint8) {
133         return _decimals;
134     }
135 }
136 
137 
138 
139 library Address {
140     function isContract(address account) internal view returns (bool) {
141         bytes32 codehash;
142         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
143         // solhint-disable-next-line no-inline-assembly
144         assembly { codehash := extcodehash(account) }
145         return (codehash != 0x0 && codehash != accountHash);
146     }
147 }
148 
149 library SafeBEP20 {
150     using SafeMath for uint;
151     using Address for address;
152 
153     function safeTransfer(IBEP20 token, address to, uint value) internal {
154         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
155     }
156 
157     function safeTransferFrom(IBEP20 token, address from, address to, uint value) internal {
158         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
159     }
160 
161     function safeApprove(IBEP20 token, address spender, uint value) internal {
162         require((value == 0) || (token.allowance(address(this), spender) == 0),
163             "SafeBEP20: approve from non-zero to non-zero allowance"
164         );
165         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
166     }
167     function callOptionalReturn(IBEP20 token, bytes memory data) private {
168         require(address(token).isContract(), "SafeBEP20: call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = address(token).call(data);
172         require(success, "SafeBEP20: low-level call failed");
173 
174         if (returndata.length > 0) { // Return data is optional
175             // solhint-disable-next-line max-line-length
176             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
177         }
178     }
179 }
180 
181 interface IUniswapV2Factory {
182     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
183 
184     function feeTo() external view returns (address);
185     function feeToSetter() external view returns (address);
186 
187     function getPair(address tokenA, address tokenB) external view returns (address pair);
188     function allPairs(uint) external view returns (address pair);
189     function allPairsLength() external view returns (uint);
190 
191     function createPair(address tokenA, address tokenB) external returns (address pair);
192 
193     function setFeeTo(address) external;
194     function setFeeToSetter(address) external;
195 }
196 
197 
198 interface IUniswapV2Pair {
199     event Approval(address indexed owner, address indexed spender, uint value);
200     event Transfer(address indexed from, address indexed to, uint value);
201 
202     function name() external pure returns (string memory);
203     function symbol() external pure returns (string memory);
204     function decimals() external pure returns (uint8);
205     function totalSupply() external view returns (uint);
206     function balanceOf(address owner) external view returns (uint);
207     function allowance(address owner, address spender) external view returns (uint);
208 
209     function approve(address spender, uint value) external returns (bool);
210     function transfer(address to, uint value) external returns (bool);
211     function transferFrom(address from, address to, uint value) external returns (bool);
212 
213     function DOMAIN_SEPARATOR() external view returns (bytes32);
214     function PERMIT_TYPEHASH() external pure returns (bytes32);
215     function nonces(address owner) external view returns (uint);
216 
217     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
218 
219     event Mint(address indexed sender, uint amount0, uint amount1);
220     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
221     event Swap(
222         address indexed sender,
223         uint amount0In,
224         uint amount1In,
225         uint amount0Out,
226         uint amount1Out,
227         address indexed to
228     );
229     event Sync(uint112 reserve0, uint112 reserve1);
230 
231     function MINIMUM_LIQUIDITY() external pure returns (uint);
232     function factory() external view returns (address);
233     function token0() external view returns (address);
234     function token1() external view returns (address);
235     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
236     function price0CumulativeLast() external view returns (uint);
237     function price1CumulativeLast() external view returns (uint);
238     function kLast() external view returns (uint);
239 
240     function mint(address to) external returns (uint liquidity);
241     function burn(address to) external returns (uint amount0, uint amount1);
242     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
243     function skim(address to) external;
244     function sync() external;
245 
246     function initialize(address, address) external;
247 }
248 
249 
250 
251 interface IUniswapV2Router01 {
252     function factory() external pure returns (address);
253     function WETH() external pure returns (address);
254 
255     function addLiquidity(
256         address tokenA,
257         address tokenB,
258         uint amountADesired,
259         uint amountBDesired,
260         uint amountAMin,
261         uint amountBMin,
262         address to,
263         uint deadline
264     ) external returns (uint amountA, uint amountB, uint liquidity);
265     function addLiquidityETH(
266         address token,
267         uint amountTokenDesired,
268         uint amountTokenMin,
269         uint amountETHMin,
270         address to,
271         uint deadline
272     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
273     function removeLiquidity(
274         address tokenA,
275         address tokenB,
276         uint liquidity,
277         uint amountAMin,
278         uint amountBMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountA, uint amountB);
282     function removeLiquidityETH(
283         address token,
284         uint liquidity,
285         uint amountTokenMin,
286         uint amountETHMin,
287         address to,
288         uint deadline
289     ) external returns (uint amountToken, uint amountETH);
290     function removeLiquidityWithPermit(
291         address tokenA,
292         address tokenB,
293         uint liquidity,
294         uint amountAMin,
295         uint amountBMin,
296         address to,
297         uint deadline,
298         bool approveMax, uint8 v, bytes32 r, bytes32 s
299     ) external returns (uint amountA, uint amountB);
300     function removeLiquidityETHWithPermit(
301         address token,
302         uint liquidity,
303         uint amountTokenMin,
304         uint amountETHMin,
305         address to,
306         uint deadline,
307         bool approveMax, uint8 v, bytes32 r, bytes32 s
308     ) external returns (uint amountToken, uint amountETH);
309     function swapExactTokensForTokens(
310         uint amountIn,
311         uint amountOutMin,
312         address[] calldata path,
313         address to,
314         uint deadline
315     ) external returns (uint[] memory amounts);
316     function swapTokensForExactTokens(
317         uint amountOut,
318         uint amountInMax,
319         address[] calldata path,
320         address to,
321         uint deadline
322     ) external returns (uint[] memory amounts);
323     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
324         external
325         payable
326         returns (uint[] memory amounts);
327     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
328         external
329         returns (uint[] memory amounts);
330     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
331         external
332         returns (uint[] memory amounts);
333     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
334         external
335         payable
336         returns (uint[] memory amounts);
337 
338     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
339     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
340     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
341     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
342     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
343 }
344 
345 interface IUniswapV2Router02 is IUniswapV2Router01 {
346     function removeLiquidityETHSupportingFeeOnTransferTokens(
347         address token,
348         uint liquidity,
349         uint amountTokenMin,
350         uint amountETHMin,
351         address to,
352         uint deadline
353     ) external returns (uint amountETH);
354     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
355         address token,
356         uint liquidity,
357         uint amountTokenMin,
358         uint amountETHMin,
359         address to,
360         uint deadline,
361         bool approveMax, uint8 v, bytes32 r, bytes32 s
362     ) external returns (uint amountETH);
363 
364     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
365         uint amountIn,
366         uint amountOutMin,
367         address[] calldata path,
368         address to,
369         uint deadline
370     ) external;
371     function swapExactETHForTokensSupportingFeeOnTransferTokens(
372         uint amountOutMin,
373         address[] calldata path,
374         address to,
375         uint deadline
376     ) external payable;
377     function swapExactTokensForETHSupportingFeeOnTransferTokens(
378         uint amountIn,
379         uint amountOutMin,
380         address[] calldata path,
381         address to,
382         uint deadline
383     ) external;
384 }
385 
386 interface IPinkAntiBot {
387   function setTokenOwner(address owner) external;
388   function onPreTransferCheck(
389     address from,
390     address to,
391     uint256 amount
392   ) external;
393 }
394 
395 
396 
397 contract ShiBurn is Context, Ownable, IBEP20, BEP20Detailed {
398   using SafeBEP20 for IBEP20;
399   using Address for address;
400   using SafeMath for uint256;
401   
402     IUniswapV2Router02 public immutable uniswapV2Router;
403     address public immutable uniswapV2Pair;
404     
405     mapping (address => uint) internal _balances;
406     mapping (address => mapping (address => uint)) internal _allowances;
407     mapping (address => bool) private _isExcludedFromFee;
408     mapping (address => bool) private _isExcludedFromMaxWallet;
409     mapping (address => bool) private AMMs;
410     mapping (address => bool) isTimelockExempt;
411   
412    
413     uint256 internal _totalSupply;
414 
415     uint256 public marketingFee = 5;
416     uint256 public buybackFee = 10;
417 
418     address payable public marketingaddress = payable(0x95B9aC1C01a331e9B473AadDe510442d63aC5D3B);
419     address payable public buybackAddress = payable(0x4bcfCa6142d4A26F2CC727Ca35924786985812EB);
420     
421     bool inSwapAndLiquify;
422     bool public swapAndLiquifyEnabled = true;
423     bool public isTradingEnabled;
424 
425   // Cooldown & timer functionality
426     bool public buyCooldownEnabled = true;
427     uint8 public cooldownTimerInterval = 60;
428     mapping (address => uint) private cooldownTimer;
429 
430     
431    
432     uint256 public numTokensSellToAddToLiquidity = 100 * 10**18;
433     uint256 public maxWalletAmount = 1000 * 10**18;
434     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
435     event SwapAndLiquifyEnabledUpdated(bool enabled);
436     event SwapAndLiquify(
437         uint256 tokensSwapped,
438         uint256 ethReceived
439     );
440 
441     
442     
443     modifier lockTheSwap {
444         inSwapAndLiquify = true;
445         _;
446         inSwapAndLiquify = false;
447     }
448   
449     address public _owner;
450   
451     constructor () BEP20Detailed("ShiBurn", "ShiBurn", 18) {
452       _owner = msg.sender ;
453     _totalSupply = 100000 * (10**18);
454     
455 	_balances[_owner] = _totalSupply;
456 	//uniswapv3 router = 0xE592427A0AEce92De3Edee1F18E0157C05861564
457 	 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
458          // Create a uniswap pair for this new token
459         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
460             .createPair(address(this), _uniswapV2Router.WETH());
461 
462         // set the rest of the contract variables
463         uniswapV2Router = _uniswapV2Router;
464 
465 
466           //exclude owner and this contract from fee
467         _isExcludedFromFee[owner()] = true;
468         _isExcludedFromFee[address(this)] = true;
469         _isExcludedFromFee[marketingaddress] = true;
470         _isExcludedFromFee[buybackAddress] = true;
471 
472         _isExcludedFromMaxWallet[owner()] = true;
473         _isExcludedFromMaxWallet[address(this)] = true;
474         _isExcludedFromMaxWallet[marketingaddress] = true;
475         _isExcludedFromMaxWallet[buybackAddress] = true;
476         _isExcludedFromMaxWallet[uniswapV2Pair] = true;
477 
478         
479         // No timelock for these people
480         isTimelockExempt[msg.sender] = true;
481         isTimelockExempt[marketingaddress] = true;
482         isTimelockExempt[buybackAddress] = true;
483         isTimelockExempt[address(this)] = true;
484         isTimelockExempt[uniswapV2Pair] = true;
485     
486         AMMs[uniswapV2Pair] = true;
487 
488 
489      emit Transfer(address(0), _msgSender(), _totalSupply);
490   }
491   
492     function totalSupply() public view override returns (uint) {
493         return _totalSupply;
494     }
495     function balanceOf(address account) public view override returns (uint) {
496         return _balances[account];
497     }
498     function transfer(address recipient, uint amount) public override  returns (bool) {
499         _transfer(_msgSender(), recipient, amount);
500         return true;
501     }
502     function allowance(address towner, address spender) public view override returns (uint) {
503         return _allowances[towner][spender];
504     }
505     function approve(address spender, uint amount) public override returns (bool) {
506         _approve(_msgSender(), spender, amount);
507         return true;
508     }
509     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
510         _transfer(sender, recipient, amount);
511         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
512         return true;
513     }
514     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
516         return true;
517     }
518     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
520         return true;
521     }
522 
523     function setMarketingFeePercent(uint256 updatedMarketingFee) external onlyOwner() {
524         marketingFee = updatedMarketingFee;
525     }
526 
527     
528     function setBuybackFeePercent(uint256 updatedBuybackFee) external onlyOwner() {
529         buybackFee = updatedBuybackFee;
530     }
531 
532     function setMarketingAddress(address payable wallet) external onlyOwner
533     {
534         marketingaddress = wallet;
535     }
536 
537     function setBuybackAddress(address payable wallet) external onlyOwner
538     {
539         buybackAddress = wallet;
540     }
541 
542     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
543         swapAndLiquifyEnabled = _enabled;
544         emit SwapAndLiquifyEnabledUpdated(_enabled);
545     }
546 
547     function changeNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity) external onlyOwner
548     {
549         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
550     }
551     function excludeFromFee(address account) public onlyOwner {
552         _isExcludedFromFee[account] = true;
553     }
554     
555     function includeInFee(address account) public onlyOwner {
556         _isExcludedFromFee[account] = false;
557     }
558 
559     function excludeFromMaxWalletLimit(address account) external onlyOwner
560     {
561         _isExcludedFromMaxWallet[account] = true;
562 
563     }
564 
565     function includeInMaxWalletLimit(address account) external onlyOwner
566     {
567         _isExcludedFromMaxWallet[account] = false;
568     }
569 
570     function excludeFromAMMs(address account) public onlyOwner
571     {
572         AMMs[account] = false;
573         
574     }
575 
576     function includeInAMMs(address account) public onlyOwner
577     {
578         AMMs[account] = true;
579         _isExcludedFromMaxWallet[account] = true;
580         isTimelockExempt[account] = true;
581     }
582 
583     
584     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner {
585         isTimelockExempt[holder] = exempt;
586     }
587 
588     function enableTrading() external onlyOwner
589     {
590         isTradingEnabled = true;
591     }
592 
593     function disableTrading() external onlyOwner
594     {
595         isTradingEnabled = false;
596     }
597 
598     function changeMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner
599     {
600         maxWalletAmount = _maxWalletAmount;
601     }
602    
603      //to recieve ETH from uniswapV2Router when swaping
604     receive() external payable {}
605     function _transfer(address sender, address recipient, uint amount) internal{
606 
607         require(sender != address(0), "BEP20: transfer from the zero address");
608         require(recipient != address(0), "BEP20: transfer to the zero address");
609         if(sender != owner())
610         {require(isTradingEnabled, " Trading is not enabled yet");}
611 
612           // cooldown timer, so a bot doesnt do quick trades! 1min gap between 2 trades.
613         if (sender == uniswapV2Pair &&
614             buyCooldownEnabled &&
615             !isTimelockExempt[recipient]) {
616             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
617             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
618         }
619 
620         if(!_isExcludedFromMaxWallet[recipient])
621         {
622             require(_balances[recipient].add(amount) <= maxWalletAmount, "Account balance is exceeding the max wallet limit");
623 
624         }
625 
626          uint256 taxAmount = (amount.mul(marketingFee+buybackFee)).div(100);
627 
628         // is the token balance of this contract address over the min number of
629         // tokens that we need to initiate a swap + liquidity lock?
630         // also, don't get caught in a circular liquidity event.
631         // also, don't swap & liquify if sender is uniswap pair.
632         uint256 contractTokenBalance = balanceOf(address(this));
633         
634 
635         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
636         if (
637             overMinTokenBalance &&
638             !inSwapAndLiquify &&
639             !AMMs[sender] &&
640             swapAndLiquifyEnabled
641         ) {
642             contractTokenBalance = numTokensSellToAddToLiquidity;
643             
644             swapAndLiquify(contractTokenBalance);
645         }
646         
647          //indicates if fee should be deducted from transfer
648         bool takeFee = true;
649         
650         //if any account belongs to _isExcludedFromFee account then remove the fee
651         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
652             takeFee = false;
653         }
654        
655         if(!AMMs[recipient] && !AMMs[sender])
656         {takeFee = false;}
657        
658         if(takeFee)
659         {
660             uint256 TotalSent = amount.sub(taxAmount);
661             _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
662             _balances[recipient] = _balances[recipient].add(TotalSent);
663             _balances[address(this)] = _balances[address(this)].add(taxAmount);
664             emit Transfer(sender, recipient, TotalSent);
665             emit Transfer(sender, address(this), taxAmount);
666         }
667         else
668         {
669             _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
670             _balances[recipient] = _balances[recipient].add(amount);
671             emit Transfer(sender, recipient, amount);
672         }
673        
674     }
675 
676       // enable cooldown between trades
677     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
678         require(_interval <= 3600, "Limit reached");
679         buyCooldownEnabled = _status;
680         cooldownTimerInterval = _interval;
681     }
682 
683     function totalFee() internal view returns(uint256)
684     {
685         return marketingFee.add(buybackFee);
686     }
687 
688      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
689        
690         uint256 initialBalance = address(this).balance;
691 
692         // swap tokens for ETH
693         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
694 
695         // how much ETH did we just swap into?
696         uint256 newBalance = address(this).balance.sub(initialBalance);
697 
698         uint256 marketingShare = newBalance.mul(marketingFee).div(totalFee());
699         uint256 buybackShare = newBalance.sub(marketingShare);
700 
701         payable(marketingaddress).transfer(marketingShare);
702         payable(buybackAddress).transfer(buybackShare);
703         
704         emit SwapAndLiquify(contractTokenBalance, newBalance);
705     }
706 
707     function swapTokensForEth(uint256 tokenAmount) private {
708         // generate the uniswap pair path of token -> weth
709         address[] memory path = new address[](2);
710         path[0] = address(this);
711         path[1] = uniswapV2Router.WETH();
712 
713         _approve(address(this), address(uniswapV2Router), tokenAmount);
714 
715         // make the swap
716         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
717             tokenAmount,
718             0, // accept any amount of ETH
719             path,
720             address(this),
721             block.timestamp
722         );
723     }
724 
725     function _approve(address towner, address spender, uint amount) internal {
726         require(towner != address(0), "BEP20: approve from the zero address");
727         require(spender != address(0), "BEP20: approve to the zero address");
728 
729         _allowances[towner][spender] = amount;
730         emit Approval(towner, spender, amount);
731     }
732 
733     function withdrawStuckBNB() external onlyOwner{
734         require (address(this).balance > 0, "Can't withdraw negative or zero");
735         payable(owner()).transfer(address(this).balance);
736     }
737 
738     function removeStuckToken(address _address) external onlyOwner {
739         require(_address != address(this), "Can't withdraw tokens destined for liquidity");
740         require(IBEP20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");
741 
742         IBEP20(_address).transfer(owner(), IBEP20(_address).balanceOf(address(this)));
743     }
744   
745 }