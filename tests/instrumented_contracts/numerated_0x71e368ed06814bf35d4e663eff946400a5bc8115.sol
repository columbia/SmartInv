1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
4 
5 interface IERC20 {
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
115 contract ERC20Detailed {
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
149 library SafeERC20 {
150     using SafeMath for uint;
151     using Address for address;
152 
153     function safeTransfer(IERC20 token, address to, uint value) internal {
154         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
155     }
156 
157     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
158         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
159     }
160 
161     function safeApprove(IERC20 token, address spender, uint value) internal {
162         require((value == 0) || (token.allowance(address(this), spender) == 0),
163             "SafeERC20: approve from non-zero to non-zero allowance"
164         );
165         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
166     }
167     function callOptionalReturn(IERC20 token, bytes memory data) private {
168         require(address(token).isContract(), "SafeERC20: call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = address(token).call(data);
172         require(success, "SafeERC20: low-level call failed");
173 
174         if (returndata.length > 0) { // Return data is optional
175             // solhint-disable-next-line max-line-length
176             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
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
386 
387 
388 contract Degrain is Context, Ownable, IERC20, ERC20Detailed {
389   using SafeERC20 for IERC20;
390   using Address for address;
391   using SafeMath for uint256;
392   
393     IUniswapV2Router02 public immutable uniswapV2Router;
394     address public immutable uniswapV2Pair;
395     
396     mapping (address => uint) internal _balances;
397     mapping (address => mapping (address => uint)) internal _allowances;
398     mapping (address => bool) private _isExcludedFromFee;
399     
400     uint256 internal _totalSupply;
401 
402 
403     uint256 private marketingFee;
404     uint256 private burnFee;
405     uint256 private liquidityFee;
406     uint256 private totalFee;
407 
408     uint256 public BUYmarketingFee = 2;
409     uint256 public BUYburnFee = 1;
410     uint256 public BUYliquidityFee = 2;
411     uint256 public BUYtotalFee = BUYliquidityFee.add(BUYmarketingFee).add(BUYburnFee);
412 
413     uint256 public SELLmarketingFee = 2;
414     uint256 public SELLburnFee = 2;
415     uint256 public SELLliquidityFee = 6;
416     uint256 public SELLtotalFee = SELLliquidityFee.add(SELLmarketingFee).add(SELLburnFee);
417 
418     address payable public marketingaddress = payable(0x78282540167f21A17d80248721261DBd0dD5e8da);
419     
420     bool inSwapAndLiquify;
421     bool public swapAndLiquifyEnabled = true;
422    
423 
424     uint256 public numTokensSellToAddToLiquidity = 100000 * 10**18;
425     uint256 public maxTxAmount =   1000000000 * 10**18;
426    
427     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
428     event SwapAndLiquifyEnabledUpdated(bool enabled);
429      event SwapAndLiquify(
430         uint256 tokensSwapped,
431         uint256 ethReceived,
432         uint256 tokensIntoLiqudity
433     );
434 
435     bool private swapping;
436     
437     
438     modifier lockTheSwap {
439         inSwapAndLiquify = true;
440         _;
441         inSwapAndLiquify = false;
442     }
443   
444     address public _owner;
445   
446     constructor () ERC20Detailed("Degrain", "DGRN", 18) {
447       _owner = msg.sender ;
448     _totalSupply = 1000000000 * (10**18);
449     
450 	_balances[_owner] = _totalSupply;
451 	//uniswapv3 router = 0xE592427A0AEce92De3Edee1F18E0157C05861564
452 	 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
453          // Create a uniswap pair for this new token
454         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
455             .createPair(address(this), _uniswapV2Router.WETH());
456 
457         // set the rest of the contract variables
458         uniswapV2Router = _uniswapV2Router;
459 
460 
461           //exclude owner and this contract from fee
462         _isExcludedFromFee[owner()] = true;
463         _isExcludedFromFee[address(this)] = true;
464         _isExcludedFromFee[marketingaddress] = true;
465 
466      emit Transfer(address(0), _msgSender(), _totalSupply);
467   }
468   
469     function totalSupply() public view override returns (uint) {
470         return _totalSupply;
471     }
472     function balanceOf(address account) public view override returns (uint) {
473         return _balances[account];
474     }
475     function transfer(address recipient, uint amount) public override  returns (bool) {
476         _transfer(_msgSender(), recipient, amount);
477         return true;
478     }
479     function allowance(address towner, address spender) public view override returns (uint) {
480         return _allowances[towner][spender];
481     }
482     function approve(address spender, uint amount) public override returns (bool) {
483         _approve(_msgSender(), spender, amount);
484         return true;
485     }
486     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
487         _transfer(sender, recipient, amount);
488         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
489         return true;
490     }
491     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
493         return true;
494     }
495     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
497         return true;
498     }
499 
500     function setMarketingAddress(address payable wallet) external onlyOwner
501     {
502         marketingaddress = wallet;
503     }
504 
505 
506 
507     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
508         swapAndLiquifyEnabled = _enabled;
509         emit SwapAndLiquifyEnabledUpdated(_enabled);
510     }
511 
512     function changeNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity) external onlyOwner
513     {
514         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity;
515     }
516     function excludeFromFee(address account) public onlyOwner {
517         _isExcludedFromFee[account] = true;
518     }
519     
520     function includeInFee(address account) public onlyOwner {
521         _isExcludedFromFee[account] = false;
522     }
523 
524 
525         function changeMaxTxLimit(uint256 _number) external onlyOwner
526     {
527         maxTxAmount = _number;
528     }
529    
530      //to recieve ETH from uniswapV2Router when swaping
531     receive() external payable {}
532     function _transfer(address sender, address recipient, uint amount) internal{
533 
534         require(sender != address(0), "ERC20: transfer from the zero address");
535         require(recipient != address(0), "ERC20: transfer to the zero address");
536         if(sender != owner() && recipient != owner())
537         {
538             require(amount <= maxTxAmount, "Transaction size limit reached");
539         }
540 
541         // is the token balance of this contract address over the min number of
542         // tokens that we need to initiate a swap + liquidity lock?
543         // also, don't get caught in a circular liquidity event.
544         // also, don't swap & liquify if sender is uniswap pair.
545         uint256 contractTokenBalance = balanceOf(address(this));
546         
547 
548         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
549         if (
550             overMinTokenBalance &&
551             !swapping &&
552             sender != uniswapV2Pair &&
553             swapAndLiquifyEnabled
554         ) {
555             swapping = true;
556            
557             uint256 walletTokens = contractTokenBalance.mul(SELLmarketingFee).div(SELLtotalFee);
558             uint256 contractBalance = address(this).balance;
559             swapTokensForEth(walletTokens);
560             uint256 newBalance = address(this).balance.sub(contractBalance);
561             uint256 marketingShare = newBalance.mul(SELLmarketingFee).div((SELLmarketingFee));
562             //uint256 rewardShare = newBalance.sub(marketingShare);
563             payable(marketingaddress).transfer(marketingShare);
564 
565             uint256 swapTokens = contractTokenBalance.mul(SELLliquidityFee).div(SELLtotalFee);
566             swapAndLiquify(swapTokens);
567 
568             swapping = false;
569 
570         }
571         
572          //indicates if fee should be deducted from transfer
573         bool takeFee = !swapping;
574         
575         //if any account belongs to _isExcludedFromFee account then remove the fee
576         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
577             takeFee = false;
578         }
579 
580         if(sender != uniswapV2Pair && recipient != uniswapV2Pair)
581         {
582             takeFee = false;
583         }
584         if(takeFee){
585         if(sender == uniswapV2Pair)
586         {
587             marketingFee = BUYmarketingFee;
588             liquidityFee = BUYliquidityFee;
589             burnFee = BUYburnFee;
590             totalFee = BUYtotalFee;
591            
592         }
593         if(recipient == uniswapV2Pair)
594         {
595             marketingFee = SELLmarketingFee;
596             liquidityFee = SELLliquidityFee;
597             burnFee = SELLburnFee;
598             totalFee = SELLtotalFee;
599 
600         }
601         }
602        
603         if(takeFee)
604         {
605             uint256 taxAmount = amount.mul(totalFee).div(100);
606             uint256 burnAmount = taxAmount.mul(burnFee).div(totalFee);
607             uint256 TotalSent = amount.sub(taxAmount);
608             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
609             _balances[recipient] = _balances[recipient].add(TotalSent);
610             _balances[address(this)] = _balances[address(this)].add(taxAmount);
611             _balances[address(0)] = _balances[address(0)].add(burnAmount);
612             emit Transfer(sender, recipient, TotalSent);
613             emit Transfer(sender, address(this), taxAmount);
614             emit Transfer(sender, address(0), burnAmount);
615         }
616         else
617         {
618             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
619             _balances[recipient] = _balances[recipient].add(amount);
620             emit Transfer(sender, recipient, amount);
621         }
622 
623       
624     }
625 
626 
627     function setSellFee(uint256 _onSellEthBurndFee, uint256 _onSellliuidityFee, uint256 _onSellMarketingFee) public onlyOwner {
628 
629         SELLmarketingFee = _onSellMarketingFee;
630         SELLburnFee = _onSellEthBurndFee;
631         SELLliquidityFee = _onSellliuidityFee;
632         uint256  onSelltotalFees;
633         onSelltotalFees = SELLmarketingFee.add(SELLburnFee).add(SELLliquidityFee);
634         require(onSelltotalFees <= 15, "Sell Fee should be 15% or less");
635     }
636 
637     function setBuyFee(uint256 _onBuyBurndFee, uint256 _onBuyliuidityFee, uint256 _onBuyMarketingFee) public onlyOwner {
638 
639         BUYmarketingFee = _onBuyMarketingFee;
640         BUYburnFee = _onBuyBurndFee;
641         BUYliquidityFee = _onBuyliuidityFee;
642         uint256  onBuytotalFees;
643         onBuytotalFees = BUYmarketingFee.add(BUYburnFee).add(BUYliquidityFee);
644         require(onBuytotalFees <= 15, "Buy Fee should be 15% or less");
645     }
646 
647 
648      function swapAndLiquify(uint256 tokens) private lockTheSwap {
649        
650        // split the contract balance into halves
651         uint256 half = tokens.div(2);
652         uint256 otherHalf = tokens.sub(half);
653 
654         // capture the contract's current ETH balance.
655         // this is so that we can capture exactly the amount of ETH that the
656         // swap creates, and not make the liquidity event include any ETH that
657         // has been manually sent to the contract
658         uint256 initialBalance = address(this).balance;
659 
660         // swap tokens for ETH
661         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
662 
663         // how much ETH did we just swap into?
664         uint256 newBalance = address(this).balance.sub(initialBalance);
665 
666         // add liquidity to uniswap
667         addLiquidity(otherHalf, newBalance);
668 
669         emit SwapAndLiquify(half, newBalance, otherHalf);
670     }
671 
672       function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
673 
674         // approve token transfer to cover all possible scenarios
675         _approve(address(this), address(uniswapV2Router), tokenAmount);
676 
677         // add the liquidity
678         uniswapV2Router.addLiquidityETH{value: ethAmount}(
679             address(this),
680             tokenAmount,
681             0, // slippage is unavoidable
682             0, // slippage is unavoidable
683             owner(),
684             block.timestamp
685         );
686 
687     }
688 
689     function swapTokensForEth(uint256 tokenAmount) private {
690         // generate the uniswap pair path of token -> weth
691         address[] memory path = new address[](2);
692         path[0] = address(this);
693         path[1] = uniswapV2Router.WETH();
694 
695         _approve(address(this), address(uniswapV2Router), tokenAmount);
696 
697         // make the swap
698         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
699             tokenAmount,
700             0, // accept any amount of ETH
701             path,
702             address(this),
703             block.timestamp
704         );
705     }
706 
707     function _approve(address towner, address spender, uint amount) internal {
708         require(towner != address(0), "ERC20: approve from the zero address");
709         require(spender != address(0), "ERC20: approve to the zero address");
710 
711         _allowances[towner][spender] = amount;
712         emit Approval(towner, spender, amount);
713     }
714 
715     function withdrawStuckETh() external onlyOwner{
716         require (address(this).balance > 0, "Can't withdraw negative or zero");
717         payable(owner()).transfer(address(this).balance);
718     }
719 
720 
721 
722     function removeStuckToken(address _address) external onlyOwner {
723         require(_address != address(this), "Can't withdraw tokens destined for liquidity");
724         require(IERC20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");
725 
726         IERC20(_address).transfer(owner(), IERC20(_address).balanceOf(address(this)));
727     } 
728 
729 }