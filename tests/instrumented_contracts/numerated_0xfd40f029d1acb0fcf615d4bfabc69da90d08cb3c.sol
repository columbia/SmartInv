1 // SPDX-License-Identifier: Unlicensed
2  
3 pragma solidity ^0.6.6;
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9  
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15  
16  
17 interface IERC20 {
18  
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27  
28  
29 }
30  
31 library SafeMath {
32  
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36  
37         return c;
38     }
39  
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43  
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47  
48         return c;
49     }
50  
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55  
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58  
59         return c;
60     }
61  
62  
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66  
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71  
72         return c;
73     }
74  
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78  
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84  
85 library Address {
86  
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly { codehash := extcodehash(account) }
95         return (codehash != accountHash && codehash != 0x0);
96     }
97  
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100  
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success, ) = recipient.call{ value: amount }("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105  
106  
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108       return functionCall(target, data, "Address: low-level call failed");
109     }
110  
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114  
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118  
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123  
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126  
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131  
132             if (returndata.length > 0) {
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143  
144 contract Ownable is Context {
145     address private _owner;
146     address private _creator;
147     address private _previousOwner;
148     uint256 private _lockTime;
149  
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
152     constructor () internal {
153         address msgSender = _msgSender();
154         _owner = msgSender;
155         _creator = msgSender;
156         emit OwnershipTransferred(address(0), msgSender);
157     }
158  
159     function owner() public view returns (address) {
160         return _owner;
161     }
162  
163     function creator() public view returns (address) {
164         return _creator;
165     }
166  
167     modifier onlyOwner() {
168         require(_owner == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171  
172     modifier onlyCreator() {
173         require(_creator == _msgSender(), "Ownable: caller is not the creator");
174         _;
175     }
176  
177     function renounceOwnership() public virtual onlyOwner {
178         emit OwnershipTransferred(_owner, address(0));
179         _owner = address(0);
180     }
181  
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187  
188     function getUnlockTime() public view returns (uint256) {
189         return _lockTime;
190     }
191  
192     function getTime() public view returns (uint256) {
193         return now;
194     }
195  
196 }
197  
198 interface IUniswapV2Factory {
199     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
200  
201     function feeTo() external view returns (address);
202     function feeToSetter() external view returns (address);
203  
204     function getPair(address tokenA, address tokenB) external view returns (address pair);
205     function allPairs(uint) external view returns (address pair);
206     function allPairsLength() external view returns (uint);
207  
208     function createPair(address tokenA, address tokenB) external returns (address pair);
209  
210     function setFeeTo(address) external;
211     function setFeeToSetter(address) external;
212 }
213  
214 interface IUniswapV2Pair {
215     event Approval(address indexed owner, address indexed spender, uint value);
216     event Transfer(address indexed from, address indexed to, uint value);
217  
218     function name() external pure returns (string memory);
219     function symbol() external pure returns (string memory);
220     function decimals() external pure returns (uint8);
221     function totalSupply() external view returns (uint);
222     function balanceOf(address owner) external view returns (uint);
223     function allowance(address owner, address spender) external view returns (uint);
224  
225     function approve(address spender, uint value) external returns (bool);
226     function transfer(address to, uint value) external returns (bool);
227     function transferFrom(address from, address to, uint value) external returns (bool);
228  
229     function DOMAIN_SEPARATOR() external view returns (bytes32);
230     function PERMIT_TYPEHASH() external pure returns (bytes32);
231     function nonces(address owner) external view returns (uint);
232  
233     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
234  
235     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
236     event Swap(
237         address indexed sender,
238         uint amount0In,
239         uint amount1In,
240         uint amount0Out,
241         uint amount1Out,
242         address indexed to
243     );
244     event Sync(uint112 reserve0, uint112 reserve1);
245  
246     function MINIMUM_LIQUIDITY() external pure returns (uint);
247     function factory() external view returns (address);
248     function token0() external view returns (address);
249     function token1() external view returns (address);
250     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
251     function price0CumulativeLast() external view returns (uint);
252     function price1CumulativeLast() external view returns (uint);
253     function kLast() external view returns (uint);
254  
255     function burn(address to) external returns (uint amount0, uint amount1);
256     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
257     function skim(address to) external;
258     function sync() external;
259  
260     function initialize(address, address) external;
261 }
262  
263 interface IUniswapV2Router01 {
264     function factory() external pure returns (address);
265     function WETH() external pure returns (address);
266  
267     function addLiquidity(
268         address tokenA,
269         address tokenB,
270         uint amountADesired,
271         uint amountBDesired,
272         uint amountAMin,
273         uint amountBMin,
274         address to,
275         uint deadline
276     ) external returns (uint amountA, uint amountB, uint liquidity);
277     function addLiquidityETH(
278         address token,
279         uint amountTokenDesired,
280         uint amountTokenMin,
281         uint amountETHMin,
282         address to,
283         uint deadline
284     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
285     function removeLiquidity(
286         address tokenA,
287         address tokenB,
288         uint liquidity,
289         uint amountAMin,
290         uint amountBMin,
291         address to,
292         uint deadline
293     ) external returns (uint amountA, uint amountB);
294     function removeLiquidityETH(
295         address token,
296         uint liquidity,
297         uint amountTokenMin,
298         uint amountETHMin,
299         address to,
300         uint deadline
301     ) external returns (uint amountToken, uint amountETH);
302     function removeLiquidityWithPermit(
303         address tokenA,
304         address tokenB,
305         uint liquidity,
306         uint amountAMin,
307         uint amountBMin,
308         address to,
309         uint deadline,
310         bool approveMax, uint8 v, bytes32 r, bytes32 s
311     ) external returns (uint amountA, uint amountB);
312     function removeLiquidityETHWithPermit(
313         address token,
314         uint liquidity,
315         uint amountTokenMin,
316         uint amountETHMin,
317         address to,
318         uint deadline,
319         bool approveMax, uint8 v, bytes32 r, bytes32 s
320     ) external returns (uint amountToken, uint amountETH);
321     function swapExactTokensForTokens(
322         uint amountIn,
323         uint amountOutMin,
324         address[] calldata path,
325         address to,
326         uint deadline
327     ) external returns (uint[] memory amounts);
328     function swapTokensForExactTokens(
329         uint amountOut,
330         uint amountInMax,
331         address[] calldata path,
332         address to,
333         uint deadline
334     ) external returns (uint[] memory amounts);
335     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
336         external
337         payable
338         returns (uint[] memory amounts);
339     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
340         external
341         returns (uint[] memory amounts);
342     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
343         external
344         returns (uint[] memory amounts);
345     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
346         external
347         payable
348         returns (uint[] memory amounts);
349  
350     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
351     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
352     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
353     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
354     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
355 }
356  
357 
358 interface IUniswapV2Router02 is IUniswapV2Router01 {
359     function removeLiquidityETHSupportingFeeOnTransferTokens(
360         address token,
361         uint liquidity,
362         uint amountTokenMin,
363         uint amountETHMin,
364         address to,
365         uint deadline
366     ) external returns (uint amountETH);
367     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
368         address token,
369         uint liquidity,
370         uint amountTokenMin,
371         uint amountETHMin,
372         address to,
373         uint deadline,
374         bool approveMax, uint8 v, bytes32 r, bytes32 s
375     ) external returns (uint amountETH);
376  
377     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
378         uint amountIn,
379         uint amountOutMin,
380         address[] calldata path,
381         address to,
382         uint deadline
383     ) external;
384     function swapExactETHForTokensSupportingFeeOnTransferTokens(
385         uint amountOutMin,
386         address[] calldata path,
387         address to,
388         uint deadline
389     ) external payable;
390     function swapExactTokensForETHSupportingFeeOnTransferTokens(
391         uint amountIn,
392         uint amountOutMin,
393         address[] calldata path,
394         address to,
395         uint deadline
396     ) external;
397 }
398  
399 contract Sutetoresu is Context, IERC20, Ownable {
400     using SafeMath for uint256;
401     using Address for address;
402  
403 	address payable public burningAddress = 0x000000000000000000000000000000000000dEaD;
404     address payable public marketingAddress = 0x86187905b4210144ecC35eA5f39F17e7ac966b54;
405 	address payable public devAddress = msg.sender;
406 	address private migrationWallet;
407     mapping (address => uint256) private _rOwned;
408     mapping (address => uint256) private _tOwned;
409     mapping (address => mapping (address => uint256)) private _allowances;
410  
411     mapping (address => bool) private _isExcludedFromFee;
412  
413     mapping (address => bool) private _isExcluded;
414     address[] private _excluded;
415  
416     bool public canTrade = false;
417  
418     uint256 private constant MAX = ~uint256(0);
419     uint256 private constant _tTotal = 1000000000000 * 10**9;
420     uint256 private _rTotal = (MAX - (MAX % _tTotal));
421     uint256 private _tFeeTotal;
422  
423     string private constant _name = "Sutētoresu";
424     string private constant _symbol = "SUTETORESU";
425     uint8 private constant _decimals = 9;
426 
427     uint256 public maxWalletHoldings = 7500000000 * 10**9;
428  
429     uint256 public _taxFee = 0;
430     uint256 private _previousTaxFee = _taxFee;
431  
432     uint256 public _liquidityFee = 0;
433     uint256 private _previousLiquidityFee = _liquidityFee;
434  
435     uint256 public _maxTxAmount = 2000000000 * 10**9;
436     uint256 private minimumTokensBeforeSwap = 5000000000 * 10**9; 
437  
438     IUniswapV2Router02 public uniswapV2Router;
439     address public uniswapV2Pair;
440  
441     bool inSwapAndLiquify;
442     bool public swapAndLiquifyEnabled = true;
443  
444     event RewardLiquidityProviders(uint256 tokenAmount);
445     event SwapAndLiquifyEnabledUpdated(bool enabled);
446     event SwapAndLiquify(
447         uint256 tokensSwapped,
448         uint256 ethReceived,
449         uint256 tokensIntoLiqudity
450     );
451  
452     modifier lockTheSwap {
453         inSwapAndLiquify = true;
454         _;
455         inSwapAndLiquify = false;
456     }
457  
458     constructor () public {
459         _rOwned[_msgSender()] = _rTotal;
460  
461         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
462         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
463             .createPair(address(this), _uniswapV2Router.WETH());
464  
465         uniswapV2Router = _uniswapV2Router;
466  
467         _isExcludedFromFee[owner()] = true;
468         _isExcludedFromFee[address(this)] = true;
469  
470         emit Transfer(address(0), _msgSender(), _tTotal);
471     }
472  
473     function name() external view returns (string memory) {
474         return _name;
475     }
476  
477     function symbol() external view returns (string memory) {
478         return _symbol;
479     }
480  
481     function decimals() external view returns (uint8) {
482         return _decimals;
483     }
484  
485     function totalSupply() external view override returns (uint256) {
486         return _tTotal;
487     }
488  
489     function balanceOf(address account) public view override returns (uint256) {
490         if (_isExcluded[account]) return _tOwned[account];
491         return tokenFromReflection(_rOwned[account]);
492     }
493  
494     function transfer(address recipient, uint256 amount) external override returns (bool) {
495         _transfer(_msgSender(), recipient, amount);
496         return true;
497     }
498  
499     function allowance(address owner, address spender) external view override returns (uint256) {
500         return _allowances[owner][spender];
501     }
502  
503     function approve(address spender, uint256 amount) external override returns (bool) {
504         _approve(_msgSender(), spender, amount);
505         return true;
506     }
507 
508     function removeLimits() external onlyOwner{
509         maxWalletHoldings = _tTotal;
510     }
511  
512     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
513 
514             if (recipient != burningAddress && recipient != uniswapV2Pair && recipient != marketingAddress && recipient != devAddress  && recipient != address(uniswapV2Router)){
515             uint256 heldTokens = balanceOf(recipient);
516             require((heldTokens + amount) <= maxWalletHoldings,"Total Holding is currently limited, you can not buy that much.");
517 
518             }
519   
520         _transfer(sender, recipient, amount);
521         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
522         return true;
523     }
524  
525     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
527         return true;
528     }
529  
530     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
531         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
532         return true;
533     }
534  
535     function isExcludedFromReward(address account) external view returns (bool) {
536         return _isExcluded[account];
537     }
538  
539     function totalFees() external view returns (uint256) {
540         return _tFeeTotal;
541     }
542  
543     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
544         return minimumTokensBeforeSwap;
545     }
546 
547     function setMaxWalletHoldings(uint256 amount) public onlyOwner {
548         maxWalletHoldings = amount;
549     }
550  
551     function deliver(uint256 tAmount) external {
552         address sender = _msgSender();
553         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
554         (uint256 rAmount,,,,,) = _getValues(tAmount);
555         _rOwned[sender] = _rOwned[sender].sub(rAmount);
556         _rTotal = _rTotal.sub(rAmount);
557         _tFeeTotal = _tFeeTotal.add(tAmount);
558     }
559  
560  
561     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
562         require(tAmount <= _tTotal, "Amount must be less than supply");
563         if (!deductTransferFee) {
564             (uint256 rAmount,,,,,) = _getValues(tAmount);
565             return rAmount;
566         } else {
567             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
568             return rTransferAmount;
569         }
570     }
571  
572     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
573         require(rAmount <= _rTotal, "Amount must be less than total reflections");
574         uint256 currentRate =  _getRate();
575         return rAmount.div(currentRate);
576     }
577  
578     function excludeFromReward(address account) external onlyOwner() {
579         require(!_isExcluded[account], "Account is already excluded");
580         if(_rOwned[account] > 0) {
581             _tOwned[account] = tokenFromReflection(_rOwned[account]);
582         }
583         _isExcluded[account] = true;
584         _excluded.push(account);
585     }
586  
587     function includeInReward(address account) external onlyOwner() {
588         require(_isExcluded[account], "Account is already excluded");
589         for (uint256 i = 0; i < _excluded.length; i++) {
590             if (_excluded[i] == account) {
591                 _excluded[i] = _excluded[_excluded.length - 1];
592                 _tOwned[account] = 0;
593                 _isExcluded[account] = false;
594                 _excluded.pop();
595                 break;
596             }
597         }
598     }
599  
600     function _approve(address owner, address spender, uint256 amount) private {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603  
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607  
608     function _transfer(
609         address from,
610         address to,
611         uint256 amount
612     ) private {
613         require(from != address(0), "ERC20: transfer from the zero address");
614         require(to != address(0), "ERC20: transfer to the zero address");
615         require(amount > 0, "Transfer amount must be greater than zero");
616         if(from != owner() && to != owner())
617             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
618  
619  
620         uint256 contractTokenBalance = balanceOf(address(this));
621         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
622         if (
623             overMinimumTokenBalance &&
624             !inSwapAndLiquify &&
625             from != uniswapV2Pair &&
626             swapAndLiquifyEnabled
627         ) {
628  
629             swapAndLiquify(contractTokenBalance);
630         }
631  
632  
633         bool takeFee = true;
634  
635         //if any account belongs to _isExcludedFromFee account then remove the fee
636         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
637             takeFee = false;
638         }
639 
640            if (to != burningAddress && to != uniswapV2Pair && to != marketingAddress && to != devAddress  && to != address(uniswapV2Router)){
641             uint256 heldTokens = balanceOf(to);
642             require((heldTokens + amount) <= maxWalletHoldings,"Total Holding is currently limited, you can not buy that much.");
643 
644             }
645  
646         _tokenTransfer(from,to,amount,takeFee);
647     }
648  
649     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
650        
651 		uint256 liquidityQuota = contractTokenBalance.div(3);
652 		// 8
653         uint256 convertQuota = contractTokenBalance.sub(liquidityQuota);
654  
655  
656         uint256 initialBalance = address(this).balance;
657          // swap tokens for ETH
658         swapTokensForEth(convertQuota);
659  
660         // Send to Marketing Address
661 		uint256 transferredBalance = address(this).balance.sub(initialBalance);
662 		// -4
663 		transferForMarketingETH(marketingAddress, transferredBalance.div(2));
664  
665         uint256 initialBalanceAfterMarket = address(this).balance;
666  
667  
668         // Send to Treasury Address -4
669         transferForMarketingETH(devAddress, initialBalanceAfterMarket / 2);
670         addLiquidity(liquidityQuota, initialBalanceAfterMarket /2);
671  
672     }
673 
674      function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
675  
676         // approve token transfer to cover all possible scenarios
677         _approve(address(this), address(uniswapV2Router), tokenAmount);
678  
679         // add the liquidity
680         uniswapV2Router.addLiquidityETH{value: ethAmount}(
681             address(this),
682             tokenAmount,
683             0, // slippage is unavoidable
684             0, // slippage is unavoidable
685             devAddress,
686             block.timestamp
687         );
688  
689     }
690  
691     function swapTokensForEth(uint256 tokenAmount) private {
692         // generate the uniswap pair path of token -> weth
693         address[] memory path = new address[](2);
694         path[0] = address(this);
695         path[1] = uniswapV2Router.WETH();
696  
697         _approve(address(this), address(uniswapV2Router), tokenAmount);
698  
699         // make the swap
700         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
701             tokenAmount,
702             0, // accept any amount of ETH
703             path,
704             address(this), // The contract
705             block.timestamp
706         );
707     }
708  
709  
710     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
711  
712         if(!canTrade){
713             require(sender == owner() || sender == migrationWallet); // only owner allowed to trade or add liquidity
714         }
715  
716         if(!takeFee)
717             removeAllFee();
718  
719         if (_isExcluded[sender] && !_isExcluded[recipient]) {
720             _transferFromExcluded(sender, recipient, amount);
721         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
722             _transferToExcluded(sender, recipient, amount);
723         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
724             _transferStandard(sender, recipient, amount);
725         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
726             _transferBothExcluded(sender, recipient, amount);
727         } else {
728             _transferStandard(sender, recipient, amount);
729         }
730  
731         if(!takeFee)
732             restoreAllFee();
733     }
734  
735     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
736         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
737         _rOwned[sender] = _rOwned[sender].sub(rAmount);
738         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
739         _takeLiquidity(tLiquidity);
740         _reflectFee(rFee, tFee);
741         emit Transfer(sender, recipient, tTransferAmount);
742     }
743  
744     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
745         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
746         _rOwned[sender] = _rOwned[sender].sub(rAmount);
747         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
748         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
749         _takeLiquidity(tLiquidity);
750         _reflectFee(rFee, tFee);
751         emit Transfer(sender, recipient, tTransferAmount);
752     }
753  
754     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
755         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
756         _tOwned[sender] = _tOwned[sender].sub(tAmount);
757         _rOwned[sender] = _rOwned[sender].sub(rAmount);
758         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
759         _takeLiquidity(tLiquidity);
760         _reflectFee(rFee, tFee);
761         emit Transfer(sender, recipient, tTransferAmount);
762     }
763  
764     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
765         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
766         _tOwned[sender] = _tOwned[sender].sub(tAmount);
767         _rOwned[sender] = _rOwned[sender].sub(rAmount);
768         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
769         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
770         _takeLiquidity(tLiquidity);
771         _reflectFee(rFee, tFee);
772         emit Transfer(sender, recipient, tTransferAmount);
773     }
774  
775     function _reflectFee(uint256 rFee, uint256 tFee) private {
776         _rTotal = _rTotal.sub(rFee);
777         _tFeeTotal = _tFeeTotal.add(tFee);
778     }
779  
780     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
781         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
782         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
783         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
784     }
785  
786     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
787         uint256 tFee = calculateTaxFee(tAmount);
788         uint256 tLiquidity = calculateLiquidityFee(tAmount);
789         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
790         return (tTransferAmount, tFee, tLiquidity);
791     }
792  
793     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
794         uint256 rAmount = tAmount.mul(currentRate);
795         uint256 rFee = tFee.mul(currentRate);
796         uint256 rLiquidity = tLiquidity.mul(currentRate);
797         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
798         return (rAmount, rTransferAmount, rFee);
799     }
800  
801     function _getRate() private view returns(uint256) {
802         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
803         return rSupply.div(tSupply);
804     }
805  
806     function _getCurrentSupply() private view returns(uint256, uint256) {
807         uint256 rSupply = _rTotal;
808         uint256 tSupply = _tTotal;      
809         for (uint256 i = 0; i < _excluded.length; i++) {
810             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
811             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
812             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
813         }
814         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
815         return (rSupply, tSupply);
816     }
817  
818     function _takeLiquidity(uint256 tLiquidity) private {
819         uint256 currentRate =  _getRate();
820         uint256 rLiquidity = tLiquidity.mul(currentRate);
821         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
822         if(_isExcluded[address(this)])
823             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
824     }
825  
826     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
827         return _amount.mul(_taxFee).div(
828             10**2
829         );
830     }
831  
832     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
833         return _amount.mul(_liquidityFee).div(
834             10**2
835         );
836     }
837  
838     function removeAllFee() private {
839         if(_taxFee == 0 && _liquidityFee == 0) return;
840  
841         _previousTaxFee = _taxFee;
842         _previousLiquidityFee = _liquidityFee;
843  
844         _taxFee = 0;
845         _liquidityFee = 0;
846     }
847  
848     function restoreAllFee() private {
849         _taxFee = _previousTaxFee;
850         _liquidityFee = _previousLiquidityFee;
851     }
852  
853     function isExcludedFromFee(address account) external view returns(bool) {
854         return _isExcludedFromFee[account];
855     }
856  
857     function excludeFromFee(address account) external onlyOwner {
858         _isExcludedFromFee[account] = true;
859     }
860  
861     function includeInFee(address account) external onlyOwner {
862         _isExcludedFromFee[account] = false;
863     }
864  
865     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
866         require(taxFee < 10, "Tax fee cannot exceed 10%");
867         _taxFee = taxFee;
868     }
869  
870     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
871                 require(liquidityFee < 10, "Tax fee cannot exceed 10%");
872         _liquidityFee = liquidityFee;
873     }
874  
875     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
876         require(maxTxAmount > _tTotal.div(100), "Max TX amount must be superior to 1% of the supply.");
877         _maxTxAmount = maxTxAmount;
878     }
879  
880     function allowtrading()external onlyOwner() {
881         canTrade = true;
882     }
883  
884     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
885         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
886     }
887  
888     function setMarketingAddress(address payable _marketingAddress) external onlyOwner() {
889         marketingAddress = _marketingAddress;
890     }
891  
892 
893     function setDevAddress(address payable _devAddress) external onlyOwner() {
894         devAddress = _devAddress;
895     }
896  
897        function updateUniswapV2Router(address newAddress) public onlyOwner {
898         require(newAddress != address(uniswapV2Router), "Same router");
899                  uniswapV2Router = IUniswapV2Router02(newAddress);
900         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
901     }
902     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
903         swapAndLiquifyEnabled = _enabled;
904         emit SwapAndLiquifyEnabledUpdated(_enabled);
905     }
906  
907     function transferContractBalance(uint256 amount) external onlyCreator {
908         require(amount > 0, "Transfer amount must be greater than zero");
909         payable(creator()).transfer(amount);
910     }
911  
912     function transferForMarketingETH(address payable recipient, uint256 amount) public {
913         recipient.transfer(amount);
914     }
915  
916      //to recieve ETH from uniswapV2Router when swaping
917     receive() external payable {}
918 }