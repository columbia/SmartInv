1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     
26 
27 }
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
73         return mod(a, b, "SafeMath: modulo by zero");
74     }
75 
76     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b != 0, errorMessage);
78         return a % b;
79     }
80 }
81 
82 library Address {
83 
84     function isContract(address account) internal view returns (bool) {
85         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
86         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
87         // for accounts without code, i.e. `keccak256('')`
88         bytes32 codehash;
89         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
90         // solhint-disable-next-line no-inline-assembly
91         assembly { codehash := extcodehash(account) }
92         return (codehash != accountHash && codehash != 0x0);
93     }
94 
95     function sendValue(address payable recipient, uint256 amount) internal {
96         require(address(this).balance >= amount, "Address: insufficient balance");
97 
98         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
99         (bool success, ) = recipient.call{ value: amount }("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103 
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105       return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
109         return _functionCallWithValue(target, data, 0, errorMessage);
110     }
111 
112     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         return _functionCallWithValue(target, data, value, errorMessage);
119     }
120 
121     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
122         require(isContract(target), "Address: call to non-contract");
123 
124         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
125         if (success) {
126             return returndata;
127         } else {
128             
129             if (returndata.length > 0) {
130                 assembly {
131                     let returndata_size := mload(returndata)
132                     revert(add(32, returndata), returndata_size)
133                 }
134             } else {
135                 revert(errorMessage);
136             }
137         }
138     }
139 }
140 
141 contract Ownable is Context {
142     address private _owner;
143     address private _previousOwner;
144     uint256 private _lockTime;
145 
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     constructor () {
149         address msgSender = _msgSender();
150         _owner = msgSender;
151         emit OwnershipTransferred(address(0), msgSender);
152     }
153 
154     function owner() public view returns (address) {
155         return _owner;
156     }   
157     
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162     
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 }
174 
175 interface IUniswapV2Factory {
176     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
177 
178     function feeTo() external view returns (address);
179     function feeToSetter() external view returns (address);
180 
181     function getPair(address tokenA, address tokenB) external view returns (address pair);
182     function allPairs(uint) external view returns (address pair);
183     function allPairsLength() external view returns (uint);
184 
185     function createPair(address tokenA, address tokenB) external returns (address pair);
186 
187     function setFeeTo(address) external;
188     function setFeeToSetter(address) external;
189 }
190 
191 interface IUniswapV2Pair {
192     event Approval(address indexed owner, address indexed spender, uint value);
193     event Transfer(address indexed from, address indexed to, uint value);
194 
195     function name() external pure returns (string memory);
196     function symbol() external pure returns (string memory);
197     function decimals() external pure returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201 
202     function approve(address spender, uint value) external returns (bool);
203     function transfer(address to, uint value) external returns (bool);
204     function transferFrom(address from, address to, uint value) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207     function PERMIT_TYPEHASH() external pure returns (bytes32);
208     function nonces(address owner) external view returns (uint);
209 
210     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
211     
212     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
213     event Swap(
214         address indexed sender,
215         uint amount0In,
216         uint amount1In,
217         uint amount0Out,
218         uint amount1Out,
219         address indexed to
220     );
221     event Sync(uint112 reserve0, uint112 reserve1);
222 
223     function MINIMUM_LIQUIDITY() external pure returns (uint);
224     function factory() external view returns (address);
225     function token0() external view returns (address);
226     function token1() external view returns (address);
227     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
228     function price0CumulativeLast() external view returns (uint);
229     function price1CumulativeLast() external view returns (uint);
230     function kLast() external view returns (uint);
231 
232     function burn(address to) external returns (uint amount0, uint amount1);
233     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
234     function skim(address to) external;
235     function sync() external;
236 
237     function initialize(address, address) external;
238 }
239 
240 interface IUniswapV2Router01 {
241     function factory() external pure returns (address);
242     function WETH() external pure returns (address);
243 
244     function addLiquidity(
245         address tokenA,
246         address tokenB,
247         uint amountADesired,
248         uint amountBDesired,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline
253     ) external returns (uint amountA, uint amountB, uint liquidity);
254     function addLiquidityETH(
255         address token,
256         uint amountTokenDesired,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
262     function removeLiquidity(
263         address tokenA,
264         address tokenB,
265         uint liquidity,
266         uint amountAMin,
267         uint amountBMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountA, uint amountB);
271     function removeLiquidityETH(
272         address token,
273         uint liquidity,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline
278     ) external returns (uint amountToken, uint amountETH);
279     function removeLiquidityWithPermit(
280         address tokenA,
281         address tokenB,
282         uint liquidity,
283         uint amountAMin,
284         uint amountBMin,
285         address to,
286         uint deadline,
287         bool approveMax, uint8 v, bytes32 r, bytes32 s
288     ) external returns (uint amountA, uint amountB);
289     function removeLiquidityETHWithPermit(
290         address token,
291         uint liquidity,
292         uint amountTokenMin,
293         uint amountETHMin,
294         address to,
295         uint deadline,
296         bool approveMax, uint8 v, bytes32 r, bytes32 s
297     ) external returns (uint amountToken, uint amountETH);
298     function swapExactTokensForTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external returns (uint[] memory amounts);
305     function swapTokensForExactTokens(
306         uint amountOut,
307         uint amountInMax,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external returns (uint[] memory amounts);
312     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
313         external
314         payable
315         returns (uint[] memory amounts);
316     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
317         external
318         returns (uint[] memory amounts);
319     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
320         external
321         returns (uint[] memory amounts);
322     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
323         external
324         payable
325         returns (uint[] memory amounts);
326 
327     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
328     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
329     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
330     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
331     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
332 }
333 
334 interface IUniswapV2Router02 is IUniswapV2Router01 {
335     function removeLiquidityETHSupportingFeeOnTransferTokens(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external returns (uint amountETH);
343     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
344         address token,
345         uint liquidity,
346         uint amountTokenMin,
347         uint amountETHMin,
348         address to,
349         uint deadline,
350         bool approveMax, uint8 v, bytes32 r, bytes32 s
351     ) external returns (uint amountETH);
352 
353     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
354         uint amountIn,
355         uint amountOutMin,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external;
360     function swapExactETHForTokensSupportingFeeOnTransferTokens(
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external payable;
366     function swapExactTokensForETHSupportingFeeOnTransferTokens(
367         uint amountIn,
368         uint amountOutMin,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external;
373 }
374 
375 contract FanVerse is Context, IERC20, Ownable {
376     using SafeMath for uint256;
377     using Address for address;
378 
379     uint8 private _decimals = 9;
380     uint256 public deadBlocks = 2;
381     uint256 public launchedAt = 0;
382     
383     uint256 private constant MAX = ~uint256(0);
384     uint256 private _tTotal = 1000000000 * 10**_decimals;
385     uint256 private _rTotal = (MAX - (MAX % _tTotal));
386     uint256 private _tFeeTotal;
387     uint256 public _maxWalletToken = _tTotal.div(1000).mul(10); //2% for first few mins
388 
389     uint256 public _buyLiquidityFee = 50;    
390     uint256 public _buymarketdevFee = 40;   
391     uint256 public _buyReflectionFee = 10;
392 
393     uint256 public _sellLiquidityFee = 50; 
394     uint256 public _sellmarketdevFee = 40;  
395     uint256 public _sellReflectionFee = 10;
396       
397     uint256 private liquidityFee = _buyLiquidityFee;
398     uint256 private marketdevFee = _buymarketdevFee;
399     uint256 private reflectionFee=_buyReflectionFee;
400 
401     uint256 private totalFee = liquidityFee.add(marketdevFee);
402     uint256 private currenttotalFee = totalFee;
403     
404     uint256 public swapThreshold = _tTotal.div(10000).mul(20); //0.2% 
405 
406     bool inSwap;
407     bool public tradingOpen = false;
408     bool public zeroBuyTaxmode = false;
409     bool private antiBotmode = true;
410 
411     string private _name = "FanVerse";
412     string private _symbol = "FANV";
413    
414     IUniswapV2Router02 public uniswapV2Router;
415     address public uniswapV2Pair;
416     address payable private marketdevWallet = payable (0x3024C3B3A55EA5a430dDeD45D7caf1f94444f608); // marketdev Wallet
417     address DEAD = 0x000000000000000000000000000000000000dEaD;
418     mapping (address => uint256) private _rOwned;
419     mapping (address => uint256) private _tOwned;
420     mapping (address => mapping (address => uint256)) private _allowances;
421     mapping (address => bool) private _isSniper;
422     mapping (address => bool) private _isExcludedFromFee;
423     mapping (address => bool) private _isMaxWalletExempt;
424     mapping (address => bool) private _isExcluded;
425     mapping (address => bool) private _isTrusted;
426     address[] private _excluded;
427 
428     event SwapETHForTokens(
429         uint256 amountIn,
430         address[] path
431     );
432     
433     event SwapTokensForETH(
434         uint256 amountIn,
435         address[] path
436     );
437     
438     modifier lockTheSwap {
439         inSwap = true;
440         _;
441         inSwap = false;
442     }
443 
444     constructor () {
445 
446         _rOwned[_msgSender()] = _rTotal;
447         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
448         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
449         .createPair(address(this), _uniswapV2Router.WETH());
450 
451         uniswapV2Router = _uniswapV2Router;
452 
453         _isExcludedFromFee[owner()] = true;
454         _isExcludedFromFee[address(this)] = true;
455         _isMaxWalletExempt[owner()] = true;
456         _isMaxWalletExempt[address(this)] = true;
457         _isMaxWalletExempt[uniswapV2Pair] = true;
458         _isMaxWalletExempt[DEAD] = true;
459         _isTrusted[owner()] = true;
460         _isTrusted[uniswapV2Pair] = true;
461 
462         emit Transfer(address(0), _msgSender(), _tTotal);
463     }
464 
465     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
466         _transfer(sender, recipient, amount);
467         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
468         return true;
469     }
470 
471     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
472         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
473         return true;
474     }
475 
476     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
477         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
478         return true;
479     }
480     
481     function approve(address spender, uint256 amount) public override returns (bool) {
482         _approve(_msgSender(), spender, amount);
483         return true;
484     }
485     
486     function deliver(uint256 tAmount) public {
487         address sender = _msgSender();
488         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
489         (uint256 rAmount,,,,,) = _getValues(tAmount);
490         _rOwned[sender] = _rOwned[sender].sub(rAmount);
491         _rTotal = _rTotal.sub(rAmount);
492         _tFeeTotal = _tFeeTotal.add(tAmount);
493     }
494 
495     function _approve(address owner, address spender, uint256 amount) private {
496         require(owner != address(0), "ERC20: approve from the zero address");
497         require(spender != address(0), "ERC20: approve to the zero address");
498 
499         _allowances[owner][spender] = amount;
500         emit Approval(owner, spender, amount);
501     }
502 
503     function transferToAddressETH(address payable recipient, uint256 amount) private {
504         recipient.transfer(amount);
505     }
506 
507     function _transfer(
508         address from,
509         address to,
510         uint256 amount
511     ) private {
512         require(from != address(0), "ERC20: transfer from the zero address");
513         require(to != address(0), "ERC20: transfer to the zero address");
514         require(amount > 0, "Transfer amount must be greater than zero");
515         require(!_isSniper[to], "Sorry Boss");
516         require(!_isSniper[from], "Sorry Boss");
517         if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
518         
519         bool takeFee = false;
520         //take fee on swaps
521         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
522             takeFee = true;
523         }
524 
525         if(launchedAt>0 && (!_isMaxWalletExempt[to] && from!= owner()) && ((launchedAt + deadBlocks) > block.number)){
526                 require(amount+ balanceOf(to)<=_maxWalletToken,
527                     "Total Holding is currently limited");
528         } 
529 
530         currenttotalFee=totalFee;
531         reflectionFee=_buyReflectionFee;
532 
533         if(tradingOpen && to == uniswapV2Pair) { //sell
534             currenttotalFee= _sellLiquidityFee.add(_sellmarketdevFee);
535             reflectionFee=_sellReflectionFee;
536         }
537         
538         //antibot
539         if(launchedAt>0 && (launchedAt + deadBlocks) > block.number){
540                 _isSniper[to]=true;
541         }
542         
543         //only bot 
544         if(launchedAt>0 && from!= owner() && block.number <= (launchedAt + deadBlocks)  && antiBotmode){
545                 currenttotalFee=950;    //95%
546         }
547 
548         //buys
549         if(zeroBuyTaxmode){
550              if(tradingOpen && from == uniswapV2Pair) { 
551                     currenttotalFee=0;
552              }
553         }
554 
555         //sell
556         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
557       
558             uint256 contractTokenBalance = balanceOf(address(this));
559             
560             if(contractTokenBalance>=swapThreshold){
561                     contractTokenBalance = swapThreshold;
562                     swapTokens(contractTokenBalance);
563             }
564           
565         }
566         _tokenTransfer(from,to,amount,takeFee);
567     }
568 
569     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
570 
571         uint256 _previousReflectionFee=reflectionFee;
572         uint256 _previousTotalFee=currenttotalFee;
573         if(!takeFee){
574             reflectionFee = 0;
575             currenttotalFee=0;
576         }
577         
578         if (_isExcluded[sender] && !_isExcluded[recipient]) {
579             _transferFromExcluded(sender, recipient, amount);
580         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
581             _transferToExcluded(sender, recipient, amount);
582         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
583             _transferBothExcluded(sender, recipient, amount);
584         } else {
585             _transferStandard(sender, recipient, amount);
586         }
587         
588         if(!takeFee){
589             reflectionFee = _previousReflectionFee;
590             currenttotalFee=_previousTotalFee;
591         }
592     }
593 
594     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
595         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
596         _rOwned[sender] = _rOwned[sender].sub(rAmount);
597         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
598         _takeLiquidity(tLiquidity);
599         _reflectFee(rFee, tFee);
600         emit Transfer(sender, recipient, tTransferAmount);
601     }
602 
603     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
604         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
607         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
608         _takeLiquidity(tLiquidity);
609         _reflectFee(rFee, tFee);
610         emit Transfer(sender, recipient, tTransferAmount);
611     }
612 
613     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
614         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
615         _tOwned[sender] = _tOwned[sender].sub(tAmount);
616         _rOwned[sender] = _rOwned[sender].sub(rAmount);
617         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
618         _takeLiquidity(tLiquidity);
619         _reflectFee(rFee, tFee);
620         emit Transfer(sender, recipient, tTransferAmount);
621     }
622 
623     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
624         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
625         _tOwned[sender] = _tOwned[sender].sub(tAmount);
626         _rOwned[sender] = _rOwned[sender].sub(rAmount);
627         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
628         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
629         _takeLiquidity(tLiquidity);
630         _reflectFee(rFee, tFee);
631         emit Transfer(sender, recipient, tTransferAmount);
632     }
633 
634     function _reflectFee(uint256 rFee, uint256 tFee) private {
635         _rTotal = _rTotal.sub(rFee);
636         _tFeeTotal = _tFeeTotal.add(tFee);
637     }
638 
639     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
640         uint256 rAmount = tAmount.mul(currentRate);
641         uint256 rFee = tFee.mul(currentRate);
642         uint256 rLiquidity = tLiquidity.mul(currentRate);
643         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
644         return (rAmount, rTransferAmount, rFee);
645     }
646     
647     function _takeLiquidity(uint256 tLiquidity) private {
648         uint256 currentRate =  _getRate();
649         uint256 rLiquidity = tLiquidity.mul(currentRate);
650         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
651         if(_isExcluded[address(this)])
652             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
653     }
654 
655     //Swap and send 
656     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
657         
658         uint256 amountToLiquify = contractTokenBalance
659             .mul(liquidityFee)
660             .div(totalFee)
661             .div(2);
662 
663         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
664         
665         swapTokensForEth(amountToSwap);
666 
667         uint256 amountETH = address(this).balance;
668 
669         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
670 
671         uint256 amountETHLiquidity = amountETH
672             .mul(liquidityFee)
673             .div(totalETHFee)
674             .div(2);
675         
676         uint256 amountETHmarketdev = amountETH.mul(marketdevFee).div(totalETHFee);
677         //Send to marketdev wallet
678         uint256 contractETHBalance = address(this).balance;
679         if(contractETHBalance > 0) {
680             sendETHToFee(amountETHmarketdev,marketdevWallet);
681         }
682         if (amountToLiquify > 0) {
683                 addLiquidity(amountToLiquify,amountETHLiquidity);
684         }
685     }
686     
687     function sendETHToFee(uint256 amount,address payable wallet) private {
688         wallet.transfer(amount);
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
707         
708         emit SwapTokensForETH(tokenAmount, path);
709     }
710 
711     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
712         // approve token transfer to cover all possible scenarios
713         _approve(address(this), address(uniswapV2Router), tokenAmount);
714 
715         // add the liquidity
716         uniswapV2Router.addLiquidityETH{value: ethAmount}(
717             address(this),
718             tokenAmount,
719             0, // slippage is unavoidable
720             0, // slippage is unavoidable
721             owner(),
722             block.timestamp
723         );
724     }
725 
726     //-------------------Private View-------------------
727     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
728         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
729         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
730         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
731     }
732 
733     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
734         uint256 tFee = calculateTaxFee(tAmount);
735         uint256 tLiquidity = calculateLiquidityFee(tAmount);
736         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
737         return (tTransferAmount, tFee, tLiquidity);
738     }
739 
740     function _getRate() private view returns(uint256) {
741         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
742         return rSupply.div(tSupply);
743     }
744 
745     function _getCurrentSupply() private view returns(uint256, uint256) {
746         uint256 rSupply = _rTotal;
747         uint256 tSupply = _tTotal;      
748         for (uint256 i = 0; i < _excluded.length; i++) {
749             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
750             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
751             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
752         }
753         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
754         return (rSupply, tSupply);
755     }
756     
757     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
758         return _amount.mul(reflectionFee).div(
759             10**3
760         );
761     }
762     
763     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
764         return _amount.mul(currenttotalFee).div(
765             10**3
766         );
767     }
768 
769     //-------------------Public View-------------------
770     function name() public view returns (string memory) {
771         return _name;
772     }
773 
774     function symbol() public view returns (string memory) {
775         return _symbol;
776     }
777 
778     function decimals() public view returns (uint8) {
779         return _decimals;
780     }
781 
782     function totalSupply() public view override returns (uint256) {
783         return _tTotal;
784     }
785 
786     function balanceOf(address account) public view override returns (uint256) {
787         if (_isExcluded[account]) 
788         return _tOwned[account];
789         return tokenFromReflection(_rOwned[account]);
790     }
791 
792     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
793         require(rAmount <= _rTotal, "Amount must be less than total reflections");
794         uint256 currentRate =  _getRate();
795         return rAmount.div(currentRate);
796     }
797 
798     function transfer(address recipient, uint256 amount) public override returns (bool) {
799         _transfer(_msgSender(), recipient, amount);
800         return true;
801     }
802 
803     function allowance(address owner, address spender) public view override returns (uint256) {
804         return _allowances[owner][spender];
805     }
806 
807     function isSniper(address account) public view returns (bool) {
808         return _isSniper[account];
809     }
810 
811     function isExcludedFromReward(address account) public view returns (bool) {
812         return _isExcluded[account];
813     }
814 
815     function totalFees() public view returns (uint256) {
816         return _tFeeTotal;
817     }
818 
819     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
820         require(tAmount <= _tTotal, "Amount must be less than supply");
821         if (!deductTransferFee) {
822             (uint256 rAmount,,,,,) = _getValues(tAmount);
823             return rAmount;
824         } else {
825             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
826             return rTransferAmount;
827         }
828     }
829 
830     //-------------------only Owner-------------------
831     function excludeFromReward(address account) public onlyOwner() {
832         if(_rOwned[account] > 0) {
833             _tOwned[account] = tokenFromReflection(_rOwned[account]);
834         }
835         _isExcluded[account] = true;
836         _excluded.push(account);
837     }
838 
839     function includeInReward(address account) external onlyOwner() {
840         require(_isExcluded[account], "Account is already excluded");
841         for (uint256 i = 0; i < _excluded.length; i++) {
842             if (_excluded[i] == account) {
843                 _excluded[i] = _excluded[_excluded.length - 1];
844                 _tOwned[account] = 0;
845                 _isExcluded[account] = false;
846                 _excluded.pop();
847                 break;
848             }
849         }
850     }
851 
852     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
853         tradingOpen = _status;
854         excludeFromReward(address(this));
855         excludeFromReward(uniswapV2Pair);
856         if(tradingOpen && launchedAt == 0){
857             launchedAt = block.number;
858             deadBlocks = _deadBlocks;
859         }
860     }
861     
862     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
863        zeroBuyTaxmode=_status;
864     }
865 
866     function setAntiBotmode(bool _status) external onlyOwner() {
867        antiBotmode=_status;
868     }
869     
870     function setNewRouter(address newRouter) external onlyOwner() {
871         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
872         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
873         if (get_pair == address(0)) {
874             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
875         }
876         else {
877             uniswapV2Pair = get_pair;
878         }
879         uniswapV2Router = _newRouter;
880     }
881     
882     function excludeMultiple(address account) public onlyOwner {
883         _isExcludedFromFee[account] = true;
884     }
885 
886     function excludeFromFee(address[] calldata addresses) public onlyOwner {
887         for (uint256 i; i < addresses.length; ++i) {
888             _isExcludedFromFee[addresses[i]] = true;
889         }
890     }
891     
892     function includeInFee(address account) public onlyOwner {
893         _isExcludedFromFee[account] = false;
894     }
895     
896     function setWallet(address _marketdevWallet) external onlyOwner() {
897         marketdevWallet = payable(_marketdevWallet);
898     }
899     
900     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
901         for (uint256 i; i < addresses.length; ++i) {
902                 _isSniper[addresses[i]] = status; 
903         }
904     }
905     
906     function manage_trusted(address[] calldata addresses) public onlyOwner {
907         for (uint256 i; i < addresses.length; ++i) {
908             _isTrusted[addresses[i]]=true;
909         }
910     }
911    
912     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
913         receipient.transfer(address(this).balance);
914     }
915 
916     function withdrawStuck(IERC20 token, address to) public onlyOwner {
917         uint256 balance = token.balanceOf(address(this));
918         token.transfer(to, balance);
919     }
920 
921     function setMaxWallet_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
922         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
923     }
924 
925     function setMaxWalletExempt(address _addr) external onlyOwner {
926         _isMaxWalletExempt[_addr] = true;
927     }
928 
929     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
930         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
931     }
932 
933     function multiTransfer( address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
934 
935         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
936         require(addresses.length == tokens.length,"Mismatch between Address and token count");
937 
938         uint256 SCCC = 0;
939 
940         for(uint i=0; i < addresses.length; i++){
941             SCCC = SCCC + (tokens[i] * 10**_decimals);
942         }
943 
944         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
945 
946         for(uint i=0; i < addresses.length; i++){
947             _transfer(msg.sender,addresses[i],(tokens[i] * 10**_decimals));
948         
949         }
950     }
951 
952     function multiTransfer_fixed( address[] calldata addresses, uint256 tokens) external onlyOwner {
953 
954         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
955 
956         uint256 SCCC = tokens* 10**_decimals * addresses.length;
957 
958         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
959 
960         for(uint i=0; i < addresses.length; i++){
961             _transfer(msg.sender,addresses[i],(tokens* 10**_decimals));
962 
963         }
964     }
965 
966     function setTaxBuy(uint256 _bReflectionFee, uint256 _bLiquidityFee, uint256 _bMarketdevFee) external onlyOwner {
967        
968         _buyLiquidityFee = _bLiquidityFee;
969         _buymarketdevFee = _bMarketdevFee;
970         _buyReflectionFee= _bReflectionFee;
971 
972         reflectionFee= _bReflectionFee;
973         liquidityFee = _bLiquidityFee;
974         marketdevFee = _bMarketdevFee;
975         totalFee = liquidityFee.add(marketdevFee);
976     }
977 
978     function setTaxSell(uint256 _sReflectionFee,uint256 _sLiquidityFee, uint256 _sMarketdevFee) external onlyOwner {
979         _sellLiquidityFee = _sLiquidityFee;
980         _sellmarketdevFee = _sMarketdevFee;
981         _sellReflectionFee= _sReflectionFee;
982     }
983      //to recieve ETH uniswapV2Router
984     receive() external payable {}
985 }