1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         return mod(a, b, "SafeMath: modulo by zero");
48     }
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 }
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address payable) {
57         return msg.sender;
58     }
59     function _msgData() internal view virtual returns (bytes memory) {
60         this;
61         return msg.data;
62     }
63 }
64 
65 library Address {
66 
67     function isContract(address account) internal view returns (bool) {
68         bytes32 codehash;
69         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
70         assembly { codehash := extcodehash(account) }
71         return (codehash != accountHash && codehash != 0x0);
72     }
73     function sendValue(address payable recipient, uint256 amount) internal {
74         require(address(this).balance >= amount, "Address: insufficient balance");
75         (bool success, ) = recipient.call{ value: amount }("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79         return functionCall(target, data, "Address: low-level call failed");
80     }
81     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
82         return _functionCallWithValue(target, data, 0, errorMessage);
83     }
84     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
85         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
86     }
87     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
88         require(address(this).balance >= value, "Address: insufficient balance for call");
89         return _functionCallWithValue(target, data, value, errorMessage);
90     }
91     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
92         require(isContract(target), "Address: call to non-contract");
93         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
94         if (success) {
95             return returndata;
96         } else {
97             if (returndata.length > 0) {
98                 assembly {
99                     let returndata_size := mload(returndata)
100                     revert(add(32, returndata), returndata_size)
101                 }
102             } else {
103                 revert(errorMessage);
104             }
105         }
106     }
107 }
108 
109 contract Ownable is Context {
110     address private _owner;
111     address private _previousOwner;
112     uint256 private _lockTime;
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114     constructor () internal {
115         address msgSender = _msgSender();
116         _owner = msgSender;
117         emit OwnershipTransferred(address(0), msgSender);
118     }
119     function owner() public view returns (address) {
120         return _owner;
121     }
122     modifier onlyOwner() {
123         require(_owner == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126     function renounceOwnership() public virtual onlyOwner {
127         emit OwnershipTransferred(_owner, address(0));
128         _owner = address(0);
129     }
130     function geUnlockTime() public view returns (uint256) {
131         return _lockTime;
132     }
133     function lock(uint256 time) public virtual onlyOwner {
134         _previousOwner = _owner;
135         _owner = address(0);
136         _lockTime = now + time;
137         emit OwnershipTransferred(_owner, address(0));
138     }
139     function unlock() public virtual {
140         require(_previousOwner == msg.sender, "You don't have permission to unlock");
141         require(now > _lockTime , "Contract is locked until 7 days");
142         emit OwnershipTransferred(_owner, _previousOwner);
143         _owner = _previousOwner;
144     }
145 }
146 
147 interface IUniswapV2Factory {
148     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
149     function feeTo() external view returns (address);
150     function feeToSetter() external view returns (address);
151     function getPair(address tokenA, address tokenB) external view returns (address pair);
152     function allPairs(uint) external view returns (address pair);
153     function allPairsLength() external view returns (uint);
154     function createPair(address tokenA, address tokenB) external returns (address pair);
155     function setFeeTo(address) external;
156     function setFeeToSetter(address) external;
157 }
158 
159 interface IUniswapV2Pair {
160     event Approval(address indexed owner, address indexed spender, uint value);
161     event Transfer(address indexed from, address indexed to, uint value);
162 
163     function name() external pure returns (string memory);
164     function symbol() external pure returns (string memory);
165     function decimals() external pure returns (uint8);
166     function totalSupply() external view returns (uint);
167     function balanceOf(address owner) external view returns (uint);
168     function allowance(address owner, address spender) external view returns (uint);
169 
170     function approve(address spender, uint value) external returns (bool);
171     function transfer(address to, uint value) external returns (bool);
172     function transferFrom(address from, address to, uint value) external returns (bool);
173 
174     function DOMAIN_SEPARATOR() external view returns (bytes32);
175     function PERMIT_TYPEHASH() external pure returns (bytes32);
176     function nonces(address owner) external view returns (uint);
177 
178     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
179 
180     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
181     event Swap(
182         address indexed sender,
183         uint amount0In,
184         uint amount1In,
185         uint amount0Out,
186         uint amount1Out,
187         address indexed to
188     );
189     event Sync(uint112 reserve0, uint112 reserve1);
190 
191     function MINIMUM_LIQUIDITY() external pure returns (uint);
192     function factory() external view returns (address);
193     function token0() external view returns (address);
194     function token1() external view returns (address);
195     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
196     function price0CumulativeLast() external view returns (uint);
197     function price1CumulativeLast() external view returns (uint);
198     function kLast() external view returns (uint);
199 
200     function mint(address to) external returns (uint liquidity);
201     function burn(address to) external returns (uint amount0, uint amount1);
202     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
203     function skim(address to) external;
204     function sync() external;
205 
206     function initialize(address, address) external;
207 }
208 
209 interface IUniswapV2Router01 {
210     function factory() external pure returns (address);
211     function WETH() external pure returns (address);
212 
213     function addLiquidity(
214         address tokenA,
215         address tokenB,
216         uint amountADesired,
217         uint amountBDesired,
218         uint amountAMin,
219         uint amountBMin,
220         address to,
221         uint deadline
222     ) external returns (uint amountA, uint amountB, uint liquidity);
223     function addLiquidityETH(
224         address token,
225         uint amountTokenDesired,
226         uint amountTokenMin,
227         uint amountETHMin,
228         address to,
229         uint deadline
230     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
231     function removeLiquidity(
232         address tokenA,
233         address tokenB,
234         uint liquidity,
235         uint amountAMin,
236         uint amountBMin,
237         address to,
238         uint deadline
239     ) external returns (uint amountA, uint amountB);
240     function removeLiquidityETH(
241         address token,
242         uint liquidity,
243         uint amountTokenMin,
244         uint amountETHMin,
245         address to,
246         uint deadline
247     ) external returns (uint amountToken, uint amountETH);
248     function removeLiquidityWithPermit(
249         address tokenA,
250         address tokenB,
251         uint liquidity,
252         uint amountAMin,
253         uint amountBMin,
254         address to,
255         uint deadline,
256         bool approveMax, uint8 v, bytes32 r, bytes32 s
257     ) external returns (uint amountA, uint amountB);
258     function removeLiquidityETHWithPermit(
259         address token,
260         uint liquidity,
261         uint amountTokenMin,
262         uint amountETHMin,
263         address to,
264         uint deadline,
265         bool approveMax, uint8 v, bytes32 r, bytes32 s
266     ) external returns (uint amountToken, uint amountETH);
267     function swapExactTokensForTokens(
268         uint amountIn,
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external returns (uint[] memory amounts);
274     function swapTokensForExactTokens(
275         uint amountOut,
276         uint amountInMax,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external returns (uint[] memory amounts);
281     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
282     external
283     payable
284     returns (uint[] memory amounts);
285     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
286     external
287     returns (uint[] memory amounts);
288     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
289     external
290     returns (uint[] memory amounts);
291     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
292     external
293     payable
294     returns (uint[] memory amounts);
295 
296     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
297     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
298     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
299     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
300     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
301 }
302 
303 interface IUniswapV2Router02 is IUniswapV2Router01 {
304     function removeLiquidityETHSupportingFeeOnTransferTokens(
305         address token,
306         uint liquidity,
307         uint amountTokenMin,
308         uint amountETHMin,
309         address to,
310         uint deadline
311     ) external returns (uint amountETH);
312     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
313         address token,
314         uint liquidity,
315         uint amountTokenMin,
316         uint amountETHMin,
317         address to,
318         uint deadline,
319         bool approveMax, uint8 v, bytes32 r, bytes32 s
320     ) external returns (uint amountETH);
321 
322     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
323         uint amountIn,
324         uint amountOutMin,
325         address[] calldata path,
326         address to,
327         uint deadline
328     ) external;
329     function swapExactETHForTokensSupportingFeeOnTransferTokens(
330         uint amountOutMin,
331         address[] calldata path,
332         address to,
333         uint deadline
334     ) external payable;
335     function swapExactTokensForETHSupportingFeeOnTransferTokens(
336         uint amountIn,
337         uint amountOutMin,
338         address[] calldata path,
339         address to,
340         uint deadline
341     ) external;
342 }
343 
344 
345 contract BoomBaby is Context, IERC20, Ownable {
346     using SafeMath for uint256;
347     using Address for address;
348 
349     mapping (address => uint256) private _rOwned;
350     mapping (address => uint256) private _tOwned;
351     mapping (address => mapping (address => uint256)) private _allowances;
352 
353     mapping (address => bool) private _isExcludedFromFee;
354 
355     mapping (address => bool) private _isExcluded;
356     address[] private _excluded;
357 
358     uint256 private constant MAX = ~uint256(0);
359     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
360     uint256 private _rTotal = (MAX - (MAX % _tTotal));
361     uint256 private _tFeeTotal;
362 
363     string private _name = "BoomBaby.io";
364     string private _symbol = "BoomB";
365     uint8 private _decimals = 9;
366 
367     uint256 public _taxFee = 4;
368     uint256 private _previousTaxFee = _taxFee;
369 
370     uint256 public _liquidityFee = 4;
371     uint256 private _previousLiquidityFee = _liquidityFee;
372 
373     uint256 public _burnFee = 4;
374     uint256 private _previousBurnFee = _burnFee;
375 
376 
377     IUniswapV2Router02 public immutable uniswapV2Router;
378     address public immutable uniswapV2Pair;
379 
380     bool inSwapAndLiquify;
381     bool public swapAndLiquifyEnabled = true;
382 
383     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
384     uint256 private numTokensSellToAddToLiquidity = 5000000 * 10**6 * 10**9;
385 
386     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
387     event SwapAndLiquifyEnabledUpdated(bool enabled);
388     event SwapAndLiquify(
389         uint256 tokensSwapped,
390         uint256 ethReceived,
391         uint256 tokensIntoLiqudity
392     );
393 
394     modifier lockTheSwap {
395         inSwapAndLiquify = true;
396         _;
397         inSwapAndLiquify = false;
398     }
399 
400     constructor () public {
401         _rOwned[_msgSender()] = _rTotal;
402         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
403         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
404         .createPair(address(this), _uniswapV2Router.WETH());
405         uniswapV2Router = _uniswapV2Router;
406         _isExcludedFromFee[owner()] = true;
407         _isExcludedFromFee[address(this)] = true;
408         emit Transfer(address(0), _msgSender(), _tTotal);
409     }
410 
411     function name() public view returns (string memory) {
412         return _name;
413     }
414 
415     function symbol() public view returns (string memory) {
416         return _symbol;
417     }
418 
419     function decimals() public view returns (uint8) {
420         return _decimals;
421     }
422 
423     function totalSupply() public view override returns (uint256) {
424         return _tTotal;
425     }
426 
427     function balanceOf(address account) public view override returns (uint256) {
428         if (_isExcluded[account]) return _tOwned[account];
429         return tokenFromReflection(_rOwned[account]);
430     }
431 
432     function transfer(address recipient, uint256 amount) public override returns (bool) {
433         _transfer(_msgSender(), recipient, amount);
434         return true;
435     }
436 
437     function allowance(address owner, address spender) public view override returns (uint256) {
438         return _allowances[owner][spender];
439     }
440 
441     function approve(address spender, uint256 amount) public override returns (bool) {
442         _approve(_msgSender(), spender, amount);
443         return true;
444     }
445 
446     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
447         _transfer(sender, recipient, amount);
448         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
449         return true;
450     }
451 
452     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
454         return true;
455     }
456 
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
459         return true;
460     }
461 
462     function isExcludedFromReward(address account) public view returns (bool) {
463         return _isExcluded[account];
464     }
465 
466     function totalFees() public view returns (uint256) {
467         return _tFeeTotal;
468     }
469 
470     function deliver(uint256 tAmount) public {
471         address sender = _msgSender();
472         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
473         Values memory values = _getValues(tAmount);
474         uint256 rAmount = values.rAmount;
475         _rOwned[sender] = _rOwned[sender].sub(rAmount);
476         _rTotal = _rTotal.sub(rAmount);
477         _tFeeTotal = _tFeeTotal.add(tAmount);
478     }
479 
480     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
481         require(tAmount <= _tTotal, "Amount must be less than supply");
482         if (!deductTransferFee) {
483             Values memory values = _getValues(tAmount);
484             return values.rAmount;
485         } else {
486             Values memory values = _getValues(tAmount);
487             return values.rTransferAmount;
488         }
489     }
490 
491     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
492         require(rAmount <= _rTotal, "Amount must be less than total reflections");
493         uint256 currentRate =  _getRate();
494         return rAmount.div(currentRate);
495     }
496 
497     function excludeFromReward(address account) public onlyOwner() {
498         require(!_isExcluded[account], "Account is already excluded");
499         if(_rOwned[account] > 0) {
500             _tOwned[account] = tokenFromReflection(_rOwned[account]);
501         }
502         _isExcluded[account] = true;
503         _excluded.push(account);
504     }
505 
506     function includeInReward(address account) external onlyOwner() {
507         require(_isExcluded[account], "Account is already excluded");
508         for (uint256 i = 0; i < _excluded.length; i++) {
509             if (_excluded[i] == account) {
510                 _excluded[i] = _excluded[_excluded.length - 1];
511                 _tOwned[account] = 0;
512                 _isExcluded[account] = false;
513                 _excluded.pop();
514                 break;
515             }
516         }
517     }
518     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
519         Values memory values = _getValues(tAmount);
520         uint256 rAmount = values.rAmount;
521         uint256 rTransferAmount = values.rTransferAmount;
522         uint256 rFee = values.rFee;
523         uint256 tTransferAmount = values.tTransferAmount;
524         uint256 tFee = values.tFee;
525         uint256 tLiquidity = values.tLiquidity;
526         _tOwned[sender] = _tOwned[sender].sub(tAmount);
527         _rOwned[sender] = _rOwned[sender].sub(rAmount);
528         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
529         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
530         _takeLiquidity(tLiquidity);
531         _reflectFee(rFee, tFee);
532         emit Transfer(sender, recipient, tTransferAmount);
533     }
534 
535     function excludeFromFee(address account) public onlyOwner {
536         _isExcludedFromFee[account] = true;
537     }
538 
539     function includeInFee(address account) public onlyOwner {
540         _isExcludedFromFee[account] = false;
541     }
542 
543     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
544         _taxFee = taxFee;
545     }
546 
547     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
548         _burnFee = burnFee;
549     }
550 
551     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
552         _liquidityFee = liquidityFee;
553     }
554 
555     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
556         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
557             10**2
558         );
559     }
560 
561     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
562         swapAndLiquifyEnabled = _enabled;
563         emit SwapAndLiquifyEnabledUpdated(_enabled);
564     }
565 
566     //to recieve ETH from uniswapV2Router when swaping
567     receive() external payable {}
568 
569     function _reflectFee(uint256 rFee, uint256 tFee) private {
570         _rTotal = _rTotal.sub(rFee);
571         _tFeeTotal = _tFeeTotal.add(tFee);
572     }
573 
574     struct Values{
575         uint256 rAmount;
576         uint256 rTransferAmount;
577         uint256  rFee;
578         uint256 rBurnFee;
579         uint256 tTransferAmount;
580         uint256 tFee;
581         uint256 tLiquidity;
582         uint256 tBurnFee;
583     }
584 
585     struct rValuesParams {
586         uint256 tAmount;
587         uint256 tFee;
588         uint256 tLiquidity;
589         uint256 tBurnFee;
590         uint256 currentRate;
591     }
592 
593     function _getValues(uint256 tAmount) private view returns (Values memory) {
594         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurnFee) = _getTValues(tAmount);
595 
596         rValuesParams memory r_values_params = rValuesParams(tAmount, tFee, tLiquidity, tBurnFee, _getRate());
597 
598         (
599         uint256 rAmount,
600         uint256 rTransferAmount,
601         uint256 rFee,
602         uint256 rBurnFee
603         ) = _getRValues(r_values_params);
604 
605         Values memory values = Values(rAmount, rTransferAmount, rFee, rBurnFee, tTransferAmount, tFee, tLiquidity, tBurnFee);
606 
607         return (values);
608     }
609 
610     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
611         uint256 tFee = calculateTaxFee(tAmount);
612         uint256 tBurnFee = calculateBurnFee(tAmount);
613         uint256 tLiquidity = calculateLiquidityFee(tAmount);
614         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurnFee);
615         return (tTransferAmount, tFee, tLiquidity, tBurnFee);
616     }
617 
618     function _getRValues(rValuesParams memory r_values_params) private pure returns (uint256, uint256, uint256, uint256) {
619         uint256 tAmount = r_values_params.tAmount;
620         uint256 tFee = r_values_params.tFee;
621         uint256 tLiquidity = r_values_params.tLiquidity;
622         uint256 tBurnFee = r_values_params.tBurnFee;
623         uint256 currentRate = r_values_params.currentRate;
624 
625         uint256 rAmount = tAmount.mul(currentRate);
626         uint256 rFee = tFee.mul(currentRate);
627         uint256 rBurnFee = tBurnFee.mul(currentRate);
628         uint256 rLiquidity = tLiquidity.mul(currentRate);
629         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurnFee);
630         return (rAmount, rTransferAmount, rFee, rBurnFee);
631     }
632 
633     function _getRate() private view returns(uint256) {
634         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
635         return rSupply.div(tSupply);
636     }
637 
638     function _getCurrentSupply() private view returns(uint256, uint256) {
639         uint256 rSupply = _rTotal;
640         uint256 tSupply = _tTotal;
641         for (uint256 i = 0; i < _excluded.length; i++) {
642             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
643             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
644             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
645         }
646         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
647         return (rSupply, tSupply);
648     }
649 
650     function _takeLiquidity(uint256 tLiquidity) private {
651         uint256 currentRate =  _getRate();
652         uint256 rLiquidity = tLiquidity.mul(currentRate);
653         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
654         if(_isExcluded[address(this)])
655             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
656     }
657 
658     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
659         return _amount.mul(_taxFee).div(
660             10**2
661         );
662     }
663 
664     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
665         return _amount.mul(_liquidityFee).div(
666             10**2
667         );
668     }
669 
670     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
671         return _amount.mul(_burnFee).div(
672             10**2
673         );
674     }
675 
676 
677     function removeAllFee() private {
678         if(_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0) return;
679 
680         _previousTaxFee = _taxFee;
681         _previousLiquidityFee = _liquidityFee;
682         _previousBurnFee = _burnFee;
683 
684         _taxFee = 0;
685         _liquidityFee = 0;
686         _burnFee = 0;
687     }
688 
689     function restoreAllFee() private {
690         _taxFee = _previousTaxFee;
691         _liquidityFee = _previousLiquidityFee;
692         _burnFee = _previousBurnFee;
693     }
694 
695     function isExcludedFromFee(address account) public view returns(bool) {
696         return _isExcludedFromFee[account];
697     }
698 
699     function _approve(address owner, address spender, uint256 amount) private {
700         require(owner != address(0), "ERC20: approve from the zero address");
701         require(spender != address(0), "ERC20: approve to the zero address");
702 
703         _allowances[owner][spender] = amount;
704         emit Approval(owner, spender, amount);
705     }
706 
707     function _transfer(
708         address from,
709         address to,
710         uint256 amount
711     ) private {
712         require(from != address(0), "ERC20: transfer from the zero address");
713         require(to != address(0), "ERC20: transfer to the zero address");
714         require(amount > 0, "Transfer amount must be greater than zero");
715         if(from != owner() && to != owner())
716             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
717         uint256 contractTokenBalance = balanceOf(address(this));
718 
719         if(contractTokenBalance >= _maxTxAmount)
720         {
721             contractTokenBalance = _maxTxAmount;
722         }
723 
724         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
725         if (
726             overMinTokenBalance &&
727             !inSwapAndLiquify &&
728             from != uniswapV2Pair &&
729             swapAndLiquifyEnabled
730         ) {
731             contractTokenBalance = numTokensSellToAddToLiquidity;
732             swapAndLiquify(contractTokenBalance);
733         }
734         bool takeFee = true;
735         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
736             takeFee = false;
737         }
738         _tokenTransfer(from,to,amount,takeFee);
739     }
740 
741     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
742         uint256 half = contractTokenBalance.div(2);
743         uint256 otherHalf = contractTokenBalance.sub(half);
744         uint256 initialBalance = address(this).balance;
745         swapTokensForEth(half);
746         uint256 newBalance = address(this).balance.sub(initialBalance);
747         addLiquidity(otherHalf, newBalance);
748         emit SwapAndLiquify(half, newBalance, otherHalf);
749     }
750 
751     function swapTokensForEth(uint256 tokenAmount) private {
752         address[] memory path = new address[](2);
753         path[0] = address(this);
754         path[1] = uniswapV2Router.WETH();
755         _approve(address(this), address(uniswapV2Router), tokenAmount);
756         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
757             tokenAmount,
758             0, 
759             path,
760             address(this),
761             block.timestamp
762         );
763     }
764 
765     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
766         _approve(address(this), address(uniswapV2Router), tokenAmount);
767         uniswapV2Router.addLiquidityETH{value: ethAmount}(
768             address(this),
769             tokenAmount,
770             0,
771             0,
772             owner(),
773             block.timestamp
774         );
775     }
776 
777     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
778         if(!takeFee)
779             removeAllFee();
780 
781         if (_isExcluded[sender] && !_isExcluded[recipient]) {
782             _transferFromExcluded(sender, recipient, amount);
783         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
784             _transferToExcluded(sender, recipient, amount);
785         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
786             _transferStandard(sender, recipient, amount);
787         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
788             _transferBothExcluded(sender, recipient, amount);
789         } else {
790             _transferStandard(sender, recipient, amount);
791         }
792 
793         if(!takeFee)
794             restoreAllFee();
795     }
796 
797     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
798         Values memory values = _getValues(tAmount);
799         uint256 rAmount = values.rAmount;
800         uint256 rTransferAmount = values.rTransferAmount;
801         uint256 rFee = values.rFee;
802         uint256 tTransferAmount = values.tTransferAmount;
803         uint256 tFee = values.tFee;
804         uint256 tLiquidity = values.tLiquidity;
805         uint256 tBurnFee = values.tBurnFee;
806         uint256 rBurnFee = values.rBurnFee;
807 
808         _tTotal = _tTotal.sub(tBurnFee);
809         _rTotal = _rTotal.sub(rBurnFee);
810 
811         _rOwned[sender] = _rOwned[sender].sub(rAmount);
812         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
813 
814         _takeLiquidity(tLiquidity);
815         _reflectFee(rFee, tFee);
816 
817         emit Transfer(sender, recipient, tTransferAmount);
818     }
819 
820     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
821         Values memory values = _getValues(tAmount);
822         uint256 rAmount = values.rAmount;
823         uint256 rTransferAmount = values.rTransferAmount;
824         uint256 rFee = values.rFee;
825         uint256 tTransferAmount = values.tTransferAmount;
826         uint256 tFee = values.tFee;
827         uint256 tLiquidity = values.tLiquidity;
828 
829         _rOwned[sender] = _rOwned[sender].sub(rAmount);
830         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
831         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
832         _takeLiquidity(tLiquidity);
833         _reflectFee(rFee, tFee);
834         emit Transfer(sender, recipient, tTransferAmount);
835     }
836 
837     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
838         Values memory values = _getValues(tAmount);
839         uint256 rAmount = values.rAmount;
840         uint256 rTransferAmount = values.rTransferAmount;
841         uint256 rFee = values.rFee;
842         uint256 tTransferAmount = values.tTransferAmount;
843         uint256 tFee = values.tFee;
844         uint256 tLiquidity = values.tLiquidity;
845 
846         _tOwned[sender] = _tOwned[sender].sub(tAmount);
847         _rOwned[sender] = _rOwned[sender].sub(rAmount);
848         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
849         _takeLiquidity(tLiquidity);
850         _reflectFee(rFee, tFee);
851         emit Transfer(sender, recipient, tTransferAmount);
852     }
853 
854 }