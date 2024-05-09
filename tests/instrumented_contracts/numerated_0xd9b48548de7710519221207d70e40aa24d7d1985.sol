1 /**
2 
3 (❁´ ▽ `❁)*✲ﾟ*
4 t.me/CandyBootyToken
5 (❁´ ▽ `❁)*✲ﾟ*
6 
7 */
8 
9 pragma solidity ^0.6.12;
10 // SPDX-License-Identifier: Unlicensed
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b > 0, errorMessage);
51         uint256 c = a / b;
52         return c;
53     }
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         return mod(a, b, "SafeMath: modulo by zero");
56     }
57     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b != 0, errorMessage);
59         return a % b;
60     }
61 }
62 
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address payable) {
65         return msg.sender;
66     }
67     function _msgData() internal view virtual returns (bytes memory) {
68         this;
69         return msg.data;
70     }
71 }
72 
73 library Address {
74 
75     function isContract(address account) internal view returns (bool) {
76         bytes32 codehash;
77         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
78         assembly { codehash := extcodehash(account) }
79         return (codehash != accountHash && codehash != 0x0);
80     }
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
93         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
94     }
95     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
96         require(address(this).balance >= value, "Address: insufficient balance for call");
97         return _functionCallWithValue(target, data, value, errorMessage);
98     }
99     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
100         require(isContract(target), "Address: call to non-contract");
101         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
102         if (success) {
103             return returndata;
104         } else {
105             if (returndata.length > 0) {
106                 assembly {
107                     let returndata_size := mload(returndata)
108                     revert(add(32, returndata), returndata_size)
109                 }
110             } else {
111                 revert(errorMessage);
112             }
113         }
114     }
115 }
116 
117 contract Ownable is Context {
118     address private _owner;
119     address private _previousOwner;
120     uint256 private _lockTime;
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122     constructor () internal {
123         address msgSender = _msgSender();
124         _owner = msgSender;
125         emit OwnershipTransferred(address(0), msgSender);
126     }
127     function owner() public view returns (address) {
128         return _owner;
129     }
130     modifier onlyOwner() {
131         require(_owner == _msgSender(), "Ownable: caller is not the owner");
132         _;
133     }
134     function renounceOwnership() public virtual onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138     function geUnlockTime() public view returns (uint256) {
139         return _lockTime;
140     }
141     function lock(uint256 time) public virtual onlyOwner {
142         _previousOwner = _owner;
143         _owner = address(0);
144         _lockTime = now + time;
145         emit OwnershipTransferred(_owner, address(0));
146     }
147     function unlock() public virtual {
148         require(_previousOwner == msg.sender, "You don't have permission to unlock");
149         require(now > _lockTime , "Contract is locked until 7 days");
150         emit OwnershipTransferred(_owner, _previousOwner);
151         _owner = _previousOwner;
152     }
153 }
154 
155 interface IUniswapV2Factory {
156     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
157     function feeTo() external view returns (address);
158     function feeToSetter() external view returns (address);
159     function getPair(address tokenA, address tokenB) external view returns (address pair);
160     function allPairs(uint) external view returns (address pair);
161     function allPairsLength() external view returns (uint);
162     function createPair(address tokenA, address tokenB) external returns (address pair);
163     function setFeeTo(address) external;
164     function setFeeToSetter(address) external;
165 }
166 
167 interface IUniswapV2Pair {
168     event Approval(address indexed owner, address indexed spender, uint value);
169     event Transfer(address indexed from, address indexed to, uint value);
170 
171     function name() external pure returns (string memory);
172     function symbol() external pure returns (string memory);
173     function decimals() external pure returns (uint8);
174     function totalSupply() external view returns (uint);
175     function balanceOf(address owner) external view returns (uint);
176     function allowance(address owner, address spender) external view returns (uint);
177 
178     function approve(address spender, uint value) external returns (bool);
179     function transfer(address to, uint value) external returns (bool);
180     function transferFrom(address from, address to, uint value) external returns (bool);
181 
182     function DOMAIN_SEPARATOR() external view returns (bytes32);
183     function PERMIT_TYPEHASH() external pure returns (bytes32);
184     function nonces(address owner) external view returns (uint);
185 
186     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
187 
188     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
189     event Swap(
190         address indexed sender,
191         uint amount0In,
192         uint amount1In,
193         uint amount0Out,
194         uint amount1Out,
195         address indexed to
196     );
197     event Sync(uint112 reserve0, uint112 reserve1);
198 
199     function MINIMUM_LIQUIDITY() external pure returns (uint);
200     function factory() external view returns (address);
201     function token0() external view returns (address);
202     function token1() external view returns (address);
203     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
204     function price0CumulativeLast() external view returns (uint);
205     function price1CumulativeLast() external view returns (uint);
206     function kLast() external view returns (uint);
207 
208     function mint(address to) external returns (uint liquidity);
209     function burn(address to) external returns (uint amount0, uint amount1);
210     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
211     function skim(address to) external;
212     function sync() external;
213 
214     function initialize(address, address) external;
215 }
216 
217 interface IUniswapV2Router01 {
218     function factory() external pure returns (address);
219     function WETH() external pure returns (address);
220 
221     function addLiquidity(
222         address tokenA,
223         address tokenB,
224         uint amountADesired,
225         uint amountBDesired,
226         uint amountAMin,
227         uint amountBMin,
228         address to,
229         uint deadline
230     ) external returns (uint amountA, uint amountB, uint liquidity);
231     function addLiquidityETH(
232         address token,
233         uint amountTokenDesired,
234         uint amountTokenMin,
235         uint amountETHMin,
236         address to,
237         uint deadline
238     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
239     function removeLiquidity(
240         address tokenA,
241         address tokenB,
242         uint liquidity,
243         uint amountAMin,
244         uint amountBMin,
245         address to,
246         uint deadline
247     ) external returns (uint amountA, uint amountB);
248     function removeLiquidityETH(
249         address token,
250         uint liquidity,
251         uint amountTokenMin,
252         uint amountETHMin,
253         address to,
254         uint deadline
255     ) external returns (uint amountToken, uint amountETH);
256     function removeLiquidityWithPermit(
257         address tokenA,
258         address tokenB,
259         uint liquidity,
260         uint amountAMin,
261         uint amountBMin,
262         address to,
263         uint deadline,
264         bool approveMax, uint8 v, bytes32 r, bytes32 s
265     ) external returns (uint amountA, uint amountB);
266     function removeLiquidityETHWithPermit(
267         address token,
268         uint liquidity,
269         uint amountTokenMin,
270         uint amountETHMin,
271         address to,
272         uint deadline,
273         bool approveMax, uint8 v, bytes32 r, bytes32 s
274     ) external returns (uint amountToken, uint amountETH);
275     function swapExactTokensForTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external returns (uint[] memory amounts);
282     function swapTokensForExactTokens(
283         uint amountOut,
284         uint amountInMax,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external returns (uint[] memory amounts);
289     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
290     external
291     payable
292     returns (uint[] memory amounts);
293     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
294     external
295     returns (uint[] memory amounts);
296     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
297     external
298     returns (uint[] memory amounts);
299     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
300     external
301     payable
302     returns (uint[] memory amounts);
303 
304     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
305     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
306     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
307     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
308     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
309 }
310 
311 interface IUniswapV2Router02 is IUniswapV2Router01 {
312     function removeLiquidityETHSupportingFeeOnTransferTokens(
313         address token,
314         uint liquidity,
315         uint amountTokenMin,
316         uint amountETHMin,
317         address to,
318         uint deadline
319     ) external returns (uint amountETH);
320     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
321         address token,
322         uint liquidity,
323         uint amountTokenMin,
324         uint amountETHMin,
325         address to,
326         uint deadline,
327         bool approveMax, uint8 v, bytes32 r, bytes32 s
328     ) external returns (uint amountETH);
329 
330     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
331         uint amountIn,
332         uint amountOutMin,
333         address[] calldata path,
334         address to,
335         uint deadline
336     ) external;
337     function swapExactETHForTokensSupportingFeeOnTransferTokens(
338         uint amountOutMin,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external payable;
343     function swapExactTokensForETHSupportingFeeOnTransferTokens(
344         uint amountIn,
345         uint amountOutMin,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external;
350 }
351 
352 
353 contract CANDYBOOTY is Context, IERC20, Ownable {
354     using SafeMath for uint256;
355     using Address for address;
356 
357     mapping (address => uint256) private _rOwned;
358     mapping (address => uint256) private _tOwned;
359     mapping (address => mapping (address => uint256)) private _allowances;
360 
361     mapping (address => bool) private _isExcludedFromFee;
362 
363     mapping (address => bool) private _isExcluded;
364     address[] private _excluded;
365 
366     uint256 private constant MAX = ~uint256(0);
367     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
368     uint256 private _rTotal = (MAX - (MAX % _tTotal));
369     uint256 private _tFeeTotal;
370 
371     string private _name = "CANDYBOOTY";
372     string private _symbol = "\xF0\x9F\x8D\xAD BOOTY";
373     uint8 private _decimals = 9;
374 
375     uint256 public _taxFee = 8;
376     uint256 private _previousTaxFee = _taxFee;
377 
378     uint256 public _liquidityFee = 4;
379     uint256 private _previousLiquidityFee = _liquidityFee;
380 
381     uint256 public _burnFee = 0;
382     uint256 private _previousBurnFee = _burnFee;
383 
384 
385     IUniswapV2Router02 public immutable uniswapV2Router;
386     address public immutable uniswapV2Pair;
387 
388     bool inSwapAndLiquify;
389     bool public swapAndLiquifyEnabled = true;
390 
391     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
392     uint256 private numTokensSellToAddToLiquidity = 5000000 * 10**6 * 10**9;
393 
394     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
395     event SwapAndLiquifyEnabledUpdated(bool enabled);
396     event SwapAndLiquify(
397         uint256 tokensSwapped,
398         uint256 ethReceived,
399         uint256 tokensIntoLiqudity
400     );
401 
402     modifier lockTheSwap {
403         inSwapAndLiquify = true;
404         _;
405         inSwapAndLiquify = false;
406     }
407 
408     constructor () public {
409         _rOwned[_msgSender()] = _rTotal;
410         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
411         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
412         .createPair(address(this), _uniswapV2Router.WETH());
413         uniswapV2Router = _uniswapV2Router;
414         _isExcludedFromFee[owner()] = true;
415         _isExcludedFromFee[address(this)] = true;
416         emit Transfer(address(0), _msgSender(), _tTotal);
417     }
418 
419     function name() public view returns (string memory) {
420         return _name;
421     }
422 
423     function symbol() public view returns (string memory) {
424         return _symbol;
425     }
426 
427     function decimals() public view returns (uint8) {
428         return _decimals;
429     }
430 
431     function totalSupply() public view override returns (uint256) {
432         return _tTotal;
433     }
434 
435     function balanceOf(address account) public view override returns (uint256) {
436         if (_isExcluded[account]) return _tOwned[account];
437         return tokenFromReflection(_rOwned[account]);
438     }
439 
440     function transfer(address recipient, uint256 amount) public override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     function allowance(address owner, address spender) public view override returns (uint256) {
446         return _allowances[owner][spender];
447     }
448 
449     function approve(address spender, uint256 amount) public override returns (bool) {
450         _approve(_msgSender(), spender, amount);
451         return true;
452     }
453 
454     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
455         _transfer(sender, recipient, amount);
456         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
457         return true;
458     }
459 
460     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
462         return true;
463     }
464 
465     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
466         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
467         return true;
468     }
469 
470     function isExcludedFromReward(address account) public view returns (bool) {
471         return _isExcluded[account];
472     }
473 
474     function totalFees() public view returns (uint256) {
475         return _tFeeTotal;
476     }
477 
478     function deliver(uint256 tAmount) public {
479         address sender = _msgSender();
480         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
481         Values memory values = _getValues(tAmount);
482         uint256 rAmount = values.rAmount;
483         _rOwned[sender] = _rOwned[sender].sub(rAmount);
484         _rTotal = _rTotal.sub(rAmount);
485         _tFeeTotal = _tFeeTotal.add(tAmount);
486     }
487 
488     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
489         require(tAmount <= _tTotal, "Amount must be less than supply");
490         if (!deductTransferFee) {
491             Values memory values = _getValues(tAmount);
492             return values.rAmount;
493         } else {
494             Values memory values = _getValues(tAmount);
495             return values.rTransferAmount;
496         }
497     }
498 
499     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
500         require(rAmount <= _rTotal, "Amount must be less than total reflections");
501         uint256 currentRate =  _getRate();
502         return rAmount.div(currentRate);
503     }
504 
505     function excludeFromReward(address account) public onlyOwner() {
506         require(!_isExcluded[account], "Account is already excluded");
507         if(_rOwned[account] > 0) {
508             _tOwned[account] = tokenFromReflection(_rOwned[account]);
509         }
510         _isExcluded[account] = true;
511         _excluded.push(account);
512     }
513 
514     function includeInReward(address account) external onlyOwner() {
515         require(_isExcluded[account], "Account is already excluded");
516         for (uint256 i = 0; i < _excluded.length; i++) {
517             if (_excluded[i] == account) {
518                 _excluded[i] = _excluded[_excluded.length - 1];
519                 _tOwned[account] = 0;
520                 _isExcluded[account] = false;
521                 _excluded.pop();
522                 break;
523             }
524         }
525     }
526     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
527         Values memory values = _getValues(tAmount);
528         uint256 rAmount = values.rAmount;
529         uint256 rTransferAmount = values.rTransferAmount;
530         uint256 rFee = values.rFee;
531         uint256 tTransferAmount = values.tTransferAmount;
532         uint256 tFee = values.tFee;
533         uint256 tLiquidity = values.tLiquidity;
534         _tOwned[sender] = _tOwned[sender].sub(tAmount);
535         _rOwned[sender] = _rOwned[sender].sub(rAmount);
536         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
537         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
538         _takeLiquidity(tLiquidity);
539         _reflectFee(rFee, tFee);
540         emit Transfer(sender, recipient, tTransferAmount);
541     }
542 
543     function excludeFromFee(address account) public onlyOwner {
544         _isExcludedFromFee[account] = true;
545     }
546 
547     function includeInFee(address account) public onlyOwner {
548         _isExcludedFromFee[account] = false;
549     }
550 
551     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
552         _taxFee = taxFee;
553     }
554 
555     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
556         _burnFee = burnFee;
557     }
558 
559     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
560         _liquidityFee = liquidityFee;
561     }
562 
563     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
564         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
565             10**2
566         );
567     }
568 
569     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
570         swapAndLiquifyEnabled = _enabled;
571         emit SwapAndLiquifyEnabledUpdated(_enabled);
572     }
573 
574     //to recieve ETH from uniswapV2Router when swaping
575     receive() external payable {}
576 
577     function _reflectFee(uint256 rFee, uint256 tFee) private {
578         _rTotal = _rTotal.sub(rFee);
579         _tFeeTotal = _tFeeTotal.add(tFee);
580     }
581 
582     struct Values{
583         uint256 rAmount;
584         uint256 rTransferAmount;
585         uint256  rFee;
586         uint256 rBurnFee;
587         uint256 tTransferAmount;
588         uint256 tFee;
589         uint256 tLiquidity;
590         uint256 tBurnFee;
591     }
592 
593     struct rValuesParams {
594         uint256 tAmount;
595         uint256 tFee;
596         uint256 tLiquidity;
597         uint256 tBurnFee;
598         uint256 currentRate;
599     }
600 
601     function _getValues(uint256 tAmount) private view returns (Values memory) {
602         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurnFee) = _getTValues(tAmount);
603 
604         rValuesParams memory r_values_params = rValuesParams(tAmount, tFee, tLiquidity, tBurnFee, _getRate());
605 
606         (
607         uint256 rAmount,
608         uint256 rTransferAmount,
609         uint256 rFee,
610         uint256 rBurnFee
611         ) = _getRValues(r_values_params);
612 
613         Values memory values = Values(rAmount, rTransferAmount, rFee, rBurnFee, tTransferAmount, tFee, tLiquidity, tBurnFee);
614 
615         return (values);
616     }
617 
618     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
619         uint256 tFee = calculateTaxFee(tAmount);
620         uint256 tBurnFee = calculateBurnFee(tAmount);
621         uint256 tLiquidity = calculateLiquidityFee(tAmount);
622         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurnFee);
623         return (tTransferAmount, tFee, tLiquidity, tBurnFee);
624     }
625 
626     function _getRValues(rValuesParams memory r_values_params) private pure returns (uint256, uint256, uint256, uint256) {
627         uint256 tAmount = r_values_params.tAmount;
628         uint256 tFee = r_values_params.tFee;
629         uint256 tLiquidity = r_values_params.tLiquidity;
630         uint256 tBurnFee = r_values_params.tBurnFee;
631         uint256 currentRate = r_values_params.currentRate;
632 
633         uint256 rAmount = tAmount.mul(currentRate);
634         uint256 rFee = tFee.mul(currentRate);
635         uint256 rBurnFee = tBurnFee.mul(currentRate);
636         uint256 rLiquidity = tLiquidity.mul(currentRate);
637         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurnFee);
638         return (rAmount, rTransferAmount, rFee, rBurnFee);
639     }
640 
641     function _getRate() private view returns(uint256) {
642         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
643         return rSupply.div(tSupply);
644     }
645 
646     function _getCurrentSupply() private view returns(uint256, uint256) {
647         uint256 rSupply = _rTotal;
648         uint256 tSupply = _tTotal;
649         for (uint256 i = 0; i < _excluded.length; i++) {
650             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
651             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
652             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
653         }
654         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
655         return (rSupply, tSupply);
656     }
657 
658     function _takeLiquidity(uint256 tLiquidity) private {
659         uint256 currentRate =  _getRate();
660         uint256 rLiquidity = tLiquidity.mul(currentRate);
661         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
662         if(_isExcluded[address(this)])
663             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
664     }
665 
666     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
667         return _amount.mul(_taxFee).div(
668             10**2
669         );
670     }
671 
672     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
673         return _amount.mul(_liquidityFee).div(
674             10**2
675         );
676     }
677 
678     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
679         return _amount.mul(_burnFee).div(
680             10**2
681         );
682     }
683 
684 
685     function removeAllFee() private {
686         if(_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0) return;
687 
688         _previousTaxFee = _taxFee;
689         _previousLiquidityFee = _liquidityFee;
690         _previousBurnFee = _burnFee;
691 
692         _taxFee = 0;
693         _liquidityFee = 0;
694         _burnFee = 0;
695     }
696 
697     function restoreAllFee() private {
698         _taxFee = _previousTaxFee;
699         _liquidityFee = _previousLiquidityFee;
700         _burnFee = _previousBurnFee;
701     }
702 
703     function isExcludedFromFee(address account) public view returns(bool) {
704         return _isExcludedFromFee[account];
705     }
706 
707     function _approve(address owner, address spender, uint256 amount) private {
708         require(owner != address(0), "ERC20: approve from the zero address");
709         require(spender != address(0), "ERC20: approve to the zero address");
710 
711         _allowances[owner][spender] = amount;
712         emit Approval(owner, spender, amount);
713     }
714 
715     function _transfer(
716         address from,
717         address to,
718         uint256 amount
719     ) private {
720         require(from != address(0), "ERC20: transfer from the zero address");
721         require(to != address(0), "ERC20: transfer to the zero address");
722         require(amount > 0, "Transfer amount must be greater than zero");
723         if(from != owner() && to != owner())
724             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
725         uint256 contractTokenBalance = balanceOf(address(this));
726 
727         if(contractTokenBalance >= _maxTxAmount)
728         {
729             contractTokenBalance = _maxTxAmount;
730         }
731 
732         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
733         if (
734             overMinTokenBalance &&
735             !inSwapAndLiquify &&
736             from != uniswapV2Pair &&
737             swapAndLiquifyEnabled
738         ) {
739             contractTokenBalance = numTokensSellToAddToLiquidity;
740             swapAndLiquify(contractTokenBalance);
741         }
742         bool takeFee = true;
743         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
744             takeFee = false;
745         }
746         _tokenTransfer(from,to,amount,takeFee);
747     }
748 
749     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
750         uint256 half = contractTokenBalance.div(2);
751         uint256 otherHalf = contractTokenBalance.sub(half);
752         uint256 initialBalance = address(this).balance;
753         swapTokensForEth(half);
754         uint256 newBalance = address(this).balance.sub(initialBalance);
755         addLiquidity(otherHalf, newBalance);
756         emit SwapAndLiquify(half, newBalance, otherHalf);
757     }
758 
759     function swapTokensForEth(uint256 tokenAmount) private {
760         address[] memory path = new address[](2);
761         path[0] = address(this);
762         path[1] = uniswapV2Router.WETH();
763         _approve(address(this), address(uniswapV2Router), tokenAmount);
764         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
765             tokenAmount,
766             0, 
767             path,
768             address(this),
769             block.timestamp
770         );
771     }
772 
773     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
774         _approve(address(this), address(uniswapV2Router), tokenAmount);
775         uniswapV2Router.addLiquidityETH{value: ethAmount}(
776             address(this),
777             tokenAmount,
778             0,
779             0,
780             owner(),
781             block.timestamp
782         );
783     }
784 
785     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
786         if(!takeFee)
787             removeAllFee();
788 
789         if (_isExcluded[sender] && !_isExcluded[recipient]) {
790             _transferFromExcluded(sender, recipient, amount);
791         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
792             _transferToExcluded(sender, recipient, amount);
793         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
794             _transferStandard(sender, recipient, amount);
795         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
796             _transferBothExcluded(sender, recipient, amount);
797         } else {
798             _transferStandard(sender, recipient, amount);
799         }
800 
801         if(!takeFee)
802             restoreAllFee();
803     }
804 
805     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
806         Values memory values = _getValues(tAmount);
807         uint256 rAmount = values.rAmount;
808         uint256 rTransferAmount = values.rTransferAmount;
809         uint256 rFee = values.rFee;
810         uint256 tTransferAmount = values.tTransferAmount;
811         uint256 tFee = values.tFee;
812         uint256 tLiquidity = values.tLiquidity;
813         uint256 tBurnFee = values.tBurnFee;
814         uint256 rBurnFee = values.rBurnFee;
815 
816         _tTotal = _tTotal.sub(tBurnFee);
817         _rTotal = _rTotal.sub(rBurnFee);
818 
819         _rOwned[sender] = _rOwned[sender].sub(rAmount);
820         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
821 
822         _takeLiquidity(tLiquidity);
823         _reflectFee(rFee, tFee);
824 
825         emit Transfer(sender, recipient, tTransferAmount);
826     }
827 
828     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
829         Values memory values = _getValues(tAmount);
830         uint256 rAmount = values.rAmount;
831         uint256 rTransferAmount = values.rTransferAmount;
832         uint256 rFee = values.rFee;
833         uint256 tTransferAmount = values.tTransferAmount;
834         uint256 tFee = values.tFee;
835         uint256 tLiquidity = values.tLiquidity;
836 
837         _rOwned[sender] = _rOwned[sender].sub(rAmount);
838         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
839         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
840         _takeLiquidity(tLiquidity);
841         _reflectFee(rFee, tFee);
842         emit Transfer(sender, recipient, tTransferAmount);
843     }
844 
845     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
846         Values memory values = _getValues(tAmount);
847         uint256 rAmount = values.rAmount;
848         uint256 rTransferAmount = values.rTransferAmount;
849         uint256 rFee = values.rFee;
850         uint256 tTransferAmount = values.tTransferAmount;
851         uint256 tFee = values.tFee;
852         uint256 tLiquidity = values.tLiquidity;
853 
854         _tOwned[sender] = _tOwned[sender].sub(tAmount);
855         _rOwned[sender] = _rOwned[sender].sub(rAmount);
856         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
857         _takeLiquidity(tLiquidity);
858         _reflectFee(rFee, tFee);
859         emit Transfer(sender, recipient, tTransferAmount);
860     }
861 
862 }