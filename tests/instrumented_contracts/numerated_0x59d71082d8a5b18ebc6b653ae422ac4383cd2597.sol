1 pragma solidity ^0.6.12;
2 interface IERC20 {
3 
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28 
29         return c;
30     }
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address payable) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes memory) {
65         this;
66         return msg.data;
67     }
68 }
69 
70 library Address {
71     function isContract(address account) internal view returns (bool) {
72         bytes32 codehash;
73         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
74         assembly { codehash := extcodehash(account) }
75         return (codehash != accountHash && codehash != 0x0);
76     }
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79         (bool success, ) = recipient.call{ value: amount }("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
86         return _functionCallWithValue(target, data, 0, errorMessage);
87     }
88     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
90     }
91     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
92         require(address(this).balance >= value, "Address: insufficient balance for call");
93         return _functionCallWithValue(target, data, value, errorMessage);
94     }
95     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
96         require(isContract(target), "Address: call to non-contract");
97         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
98         if (success) {
99             return returndata;
100         } else {
101             if (returndata.length > 0) {
102                 assembly {
103                     let returndata_size := mload(returndata)
104                     revert(add(32, returndata), returndata_size)
105                 }
106             } else {
107                 revert(errorMessage);
108             }
109         }
110     }
111 }
112 
113 contract Ownable is Context {
114     address private _owner;
115     address private _previousOwner;
116     uint256 private _lockTime;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119     constructor () internal {
120         address msgSender = _msgSender();
121         _owner = msgSender;
122         emit OwnershipTransferred(address(0), msgSender);
123     }
124     function owner() public view returns (address) {
125         return _owner;
126     }
127     modifier onlyOwner() {
128         require(_owner == _msgSender(), "Ownable: caller is not the owner");
129         _;
130     }
131     function renounceOwnership() public virtual onlyOwner {
132         emit OwnershipTransferred(_owner, address(0));
133         _owner = address(0);
134     }
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140     function geUnlockTime() public view returns (uint256) {
141         return _lockTime;
142     }
143     function lock(uint256 time) public virtual onlyOwner {
144         _previousOwner = _owner;
145         _owner = address(0);
146         _lockTime = now + time;
147         emit OwnershipTransferred(_owner, address(0));
148     }
149     function unlock() public virtual {
150         require(_previousOwner == msg.sender, "You don't have permission to unlock");
151         require(now > _lockTime , "Contract is locked until 7 days");
152         emit OwnershipTransferred(_owner, _previousOwner);
153         _owner = _previousOwner;
154     }
155 }
156 
157 interface IUniswapV2Factory {
158     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
159 
160     function feeTo() external view returns (address);
161     function feeToSetter() external view returns (address);
162 
163     function getPair(address tokenA, address tokenB) external view returns (address pair);
164     function allPairs(uint) external view returns (address pair);
165     function allPairsLength() external view returns (uint);
166 
167     function createPair(address tokenA, address tokenB) external returns (address pair);
168 
169     function setFeeTo(address) external;
170     function setFeeToSetter(address) external;
171 }
172 
173 interface IUniswapV2Pair {
174     event Approval(address indexed owner, address indexed spender, uint value);
175     event Transfer(address indexed from, address indexed to, uint value);
176 
177     function name() external pure returns (string memory);
178     function symbol() external pure returns (string memory);
179     function decimals() external pure returns (uint8);
180     function totalSupply() external view returns (uint);
181     function balanceOf(address owner) external view returns (uint);
182     function allowance(address owner, address spender) external view returns (uint);
183 
184     function approve(address spender, uint value) external returns (bool);
185     function transfer(address to, uint value) external returns (bool);
186     function transferFrom(address from, address to, uint value) external returns (bool);
187 
188     function DOMAIN_SEPARATOR() external view returns (bytes32);
189     function PERMIT_TYPEHASH() external pure returns (bytes32);
190     function nonces(address owner) external view returns (uint);
191 
192     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
193 
194     event Mint(address indexed sender, uint amount0, uint amount1);
195     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
196     event Swap(
197         address indexed sender,
198         uint amount0In,
199         uint amount1In,
200         uint amount0Out,
201         uint amount1Out,
202         address indexed to
203     );
204     event Sync(uint112 reserve0, uint112 reserve1);
205 
206     function MINIMUM_LIQUIDITY() external pure returns (uint);
207     function factory() external view returns (address);
208     function token0() external view returns (address);
209     function token1() external view returns (address);
210     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
211     function price0CumulativeLast() external view returns (uint);
212     function price1CumulativeLast() external view returns (uint);
213     function kLast() external view returns (uint);
214 
215     function mint(address to) external returns (uint liquidity);
216     function burn(address to) external returns (uint amount0, uint amount1);
217     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
218     function skim(address to) external;
219     function sync() external;
220 
221     function initialize(address, address) external;
222 }
223 
224 interface IUniswapV2Router01 {
225     function factory() external pure returns (address);
226     function WETH() external pure returns (address);
227 
228     function addLiquidity(
229         address tokenA,
230         address tokenB,
231         uint amountADesired,
232         uint amountBDesired,
233         uint amountAMin,
234         uint amountBMin,
235         address to,
236         uint deadline
237     ) external returns (uint amountA, uint amountB, uint liquidity);
238     function addLiquidityETH(
239         address token,
240         uint amountTokenDesired,
241         uint amountTokenMin,
242         uint amountETHMin,
243         address to,
244         uint deadline
245     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
246     function removeLiquidity(
247         address tokenA,
248         address tokenB,
249         uint liquidity,
250         uint amountAMin,
251         uint amountBMin,
252         address to,
253         uint deadline
254     ) external returns (uint amountA, uint amountB);
255     function removeLiquidityETH(
256         address token,
257         uint liquidity,
258         uint amountTokenMin,
259         uint amountETHMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountToken, uint amountETH);
263     function removeLiquidityWithPermit(
264         address tokenA,
265         address tokenB,
266         uint liquidity,
267         uint amountAMin,
268         uint amountBMin,
269         address to,
270         uint deadline,
271         bool approveMax, uint8 v, bytes32 r, bytes32 s
272     ) external returns (uint amountA, uint amountB);
273     function removeLiquidityETHWithPermit(
274         address token,
275         uint liquidity,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline,
280         bool approveMax, uint8 v, bytes32 r, bytes32 s
281     ) external returns (uint amountToken, uint amountETH);
282     function swapExactTokensForTokens(
283         uint amountIn,
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external returns (uint[] memory amounts);
289     function swapTokensForExactTokens(
290         uint amountOut,
291         uint amountInMax,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external returns (uint[] memory amounts);
296     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
297     external
298     payable
299     returns (uint[] memory amounts);
300     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
301     external
302     returns (uint[] memory amounts);
303     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
304     external
305     returns (uint[] memory amounts);
306     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
307     external
308     payable
309     returns (uint[] memory amounts);
310 
311     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
312     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
313     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
314     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
315     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
316 }
317 
318 interface IUniswapV2Router02 is IUniswapV2Router01 {
319     function removeLiquidityETHSupportingFeeOnTransferTokens(
320         address token,
321         uint liquidity,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline
326     ) external returns (uint amountETH);
327     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns (uint amountETH);
336 
337     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
338         uint amountIn,
339         uint amountOutMin,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external;
344     function swapExactETHForTokensSupportingFeeOnTransferTokens(
345         uint amountOutMin,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external payable;
350     function swapExactTokensForETHSupportingFeeOnTransferTokens(
351         uint amountIn,
352         uint amountOutMin,
353         address[] calldata path,
354         address to,
355         uint deadline
356     ) external;
357 }
358 
359 contract ECT is Context, IERC20, Ownable {
360     using SafeMath for uint256;
361     using Address for address;
362 
363     mapping (address => uint256) private _rOwned;
364     mapping (address => uint256) private _tOwned;
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     mapping (address => bool) private _isExcludedFromFee;
368 
369     mapping (address => bool) private _isExcluded;
370     address[] private _excluded;
371 
372     uint256 private constant MAX = ~uint256(0);
373     uint256 private _tTotal = 100000 * 10**6 * 10**9;
374     uint256 private _rTotal = (MAX - (MAX % _tTotal));
375     uint256 private _tFeeTotal;
376 
377     string private _name = "Ethereum Chain Token";
378     string private _symbol = "ECT";
379     uint8 private _decimals = 9;
380 
381     uint256 public _taxFee = 5;
382     uint256 private _previousTaxFee = _taxFee;
383 
384     uint256 public _liquidityFee = 5;
385     uint256 private _previousLiquidityFee = _liquidityFee;
386 
387     IUniswapV2Router02 public immutable uniswapV2Router;
388     address public immutable uniswapV2Pair;
389 
390     bool inSwapAndLiquify;
391     bool public swapAndLiquifyEnabled = true;
392     bool public tradingEnabled = true;
393 
394     uint256 public _maxTxAmount = 100000 * 10**6 * 10**9;
395     uint256 private numTokensSellToAddToLiquidity = 500 * 10**6 * 10**9;
396 
397     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
398     event SwapAndLiquifyEnabledUpdated(bool enabled);
399     event SwapAndLiquify(
400         uint256 tokensSwapped,
401         uint256 ethReceived,
402         uint256 tokensIntoLiqudity
403     );
404 
405     modifier lockTheSwap {
406         inSwapAndLiquify = true;
407         _;
408         inSwapAndLiquify = false;
409     }
410 
411     constructor () public {
412         _rOwned[0x1E1235d30e6CD6F59286c13b468f3A3799fcA3De] = _rTotal;
413 
414         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
415         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
416         .createPair(address(this), _uniswapV2Router.WETH());
417         uniswapV2Router = _uniswapV2Router;
418         _isExcludedFromFee[owner()] = true;
419         _isExcludedFromFee[address(this)] = true;
420         _isExcludedFromFee[0x1E1235d30e6CD6F59286c13b468f3A3799fcA3De] = true;
421 
422         emit Transfer(address(0), 0x1E1235d30e6CD6F59286c13b468f3A3799fcA3De, _tTotal);
423     }
424 
425     function name() public view returns (string memory) {
426         return _name;
427     }
428 
429     function symbol() public view returns (string memory) {
430         return _symbol;
431     }
432 
433     function decimals() public view returns (uint8) {
434         return _decimals;
435     }
436 
437     function totalSupply() public view override returns (uint256) {
438         return _tTotal;
439     }
440 
441     function balanceOf(address account) public view override returns (uint256) {
442         if (_isExcluded[account]) return _tOwned[account];
443         return tokenFromReflection(_rOwned[account]);
444     }
445 
446     function transfer(address recipient, uint256 amount) public override returns (bool) {
447         _transfer(_msgSender(), recipient, amount);
448         return true;
449     }
450 
451     function allowance(address owner, address spender) public view override returns (uint256) {
452         return _allowances[owner][spender];
453     }
454 
455     function approve(address spender, uint256 amount) public override returns (bool) {
456         _approve(_msgSender(), spender, amount);
457         return true;
458     }
459 
460     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
461         _transfer(sender, recipient, amount);
462         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
463         return true;
464     }
465 
466     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
467         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
468         return true;
469     }
470 
471     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
472         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
473         return true;
474     }
475 
476     function isExcludedFromReward(address account) public view returns (bool) {
477         return _isExcluded[account];
478     }
479 
480     function totalFees() public view returns (uint256) {
481         return _tFeeTotal;
482     }
483 
484     function deliver(uint256 tAmount) public {
485         address sender = _msgSender();
486         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
487         (uint256 rAmount,,,,,) = _getValues(tAmount);
488         _rOwned[sender] = _rOwned[sender].sub(rAmount);
489         _rTotal = _rTotal.sub(rAmount);
490         _tFeeTotal = _tFeeTotal.add(tAmount);
491     }
492 
493     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
494         require(tAmount <= _tTotal, "Amount must be less than supply");
495         if (!deductTransferFee) {
496             (uint256 rAmount,,,,,) = _getValues(tAmount);
497             return rAmount;
498         } else {
499             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
500             return rTransferAmount;
501         }
502     }
503 
504     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
505         require(rAmount <= _rTotal, "Amount must be less than total reflections");
506         uint256 currentRate =  _getRate();
507         return rAmount.div(currentRate);
508     }
509 
510     function excludeFromReward(address account) public onlyOwner() {
511         require(!_isExcluded[account], "Account is already excluded");
512         if(_rOwned[account] > 0) {
513             _tOwned[account] = tokenFromReflection(_rOwned[account]);
514         }
515         _isExcluded[account] = true;
516         _excluded.push(account);
517     }
518 
519     function includeInReward(address account) external onlyOwner() {
520         require(_isExcluded[account], "Account is already excluded");
521         for (uint256 i = 0; i < _excluded.length; i++) {
522             if (_excluded[i] == account) {
523                 _excluded[i] = _excluded[_excluded.length - 1];
524                 _tOwned[account] = 0;
525                 _isExcluded[account] = false;
526                 _excluded.pop();
527                 break;
528             }
529         }
530     }
531     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
532         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
533         _tOwned[sender] = _tOwned[sender].sub(tAmount);
534         _rOwned[sender] = _rOwned[sender].sub(rAmount);
535         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
536         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
537         _takeLiquidity(tLiquidity);
538         _reflectFee(rFee, tFee);
539         emit Transfer(sender, recipient, tTransferAmount);
540     }
541 
542     function excludeFromFee(address account) public onlyOwner {
543         _isExcludedFromFee[account] = true;
544     }
545 
546     function includeInFee(address account) public onlyOwner {
547         _isExcludedFromFee[account] = false;
548     }
549 
550     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
551         _taxFee = taxFee;
552     }
553 
554     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
555         _liquidityFee = liquidityFee;
556     }
557 
558     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
559         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
560             10**2
561         );
562     }
563 
564     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
565         swapAndLiquifyEnabled = _enabled;
566         emit SwapAndLiquifyEnabledUpdated(_enabled);
567     }
568 
569     function enableTrading() external onlyOwner() {
570         tradingEnabled = true;
571     }
572 
573     receive() external payable {}
574 
575     function _reflectFee(uint256 rFee, uint256 tFee) private {
576         _rTotal = _rTotal.sub(rFee);
577         _tFeeTotal = _tFeeTotal.add(tFee);
578     }
579 
580     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
581         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
582         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
583         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
584     }
585 
586     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
587         uint256 tFee = calculateTaxFee(tAmount);
588         uint256 tLiquidity = calculateLiquidityFee(tAmount);
589         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
590         return (tTransferAmount, tFee, tLiquidity);
591     }
592 
593     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
594         uint256 rAmount = tAmount.mul(currentRate);
595         uint256 rFee = tFee.mul(currentRate);
596         uint256 rLiquidity = tLiquidity.mul(currentRate);
597         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
598         return (rAmount, rTransferAmount, rFee);
599     }
600 
601     function _getRate() private view returns(uint256) {
602         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
603         return rSupply.div(tSupply);
604     }
605 
606     function _getCurrentSupply() private view returns(uint256, uint256) {
607         uint256 rSupply = _rTotal;
608         uint256 tSupply = _tTotal;
609         for (uint256 i = 0; i < _excluded.length; i++) {
610             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
611             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
612             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
613         }
614         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
615         return (rSupply, tSupply);
616     }
617 
618     function _takeLiquidity(uint256 tLiquidity) private {
619         uint256 currentRate =  _getRate();
620         uint256 rLiquidity = tLiquidity.mul(currentRate);
621         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
622         if(_isExcluded[address(this)])
623             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
624     }
625 
626     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
627         return _amount.mul(_taxFee).div(
628             10**2
629         );
630     }
631 
632     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
633         return _amount.mul(_liquidityFee).div(
634             10**2
635         );
636     }
637 
638     function removeAllFee() private {
639         if(_taxFee == 0 && _liquidityFee == 0) return;
640 
641         _previousTaxFee = _taxFee;
642         _previousLiquidityFee = _liquidityFee;
643 
644         _taxFee = 0;
645         _liquidityFee = 0;
646     }
647 
648     function restoreAllFee() private {
649         _taxFee = _previousTaxFee;
650         _liquidityFee = _previousLiquidityFee;
651     }
652 
653     function isExcludedFromFee(address account) public view returns(bool) {
654         return _isExcludedFromFee[account];
655     }
656 
657     function _approve(address owner, address spender, uint256 amount) private {
658         require(owner != address(0), "ERC20: approve from the zero address");
659         require(spender != address(0), "ERC20: approve to the zero address");
660 
661         _allowances[owner][spender] = amount;
662         emit Approval(owner, spender, amount);
663     }
664 
665     function _transfer(
666         address from,
667         address to,
668         uint256 amount
669     ) private {
670         require(from != address(0), "ERC20: transfer from the zero address");
671         require(to != address(0), "ERC20: transfer to the zero address");
672         require(amount > 0, "Transfer amount must be greater than zero");
673 
674         if(from != owner() && to != owner())
675             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
676 
677         if (from != owner() && !tradingEnabled) {
678             require(tradingEnabled, "Trading is not enabled yet");
679         }
680         uint256 contractTokenBalance = balanceOf(address(this));
681 
682         if(contractTokenBalance >= _maxTxAmount)
683         {
684             contractTokenBalance = _maxTxAmount;
685         }
686         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
687         if (
688             overMinTokenBalance &&
689             !inSwapAndLiquify &&
690             from != uniswapV2Pair &&
691             swapAndLiquifyEnabled
692         ) {
693             contractTokenBalance = numTokensSellToAddToLiquidity;
694             swapAndLiquify(contractTokenBalance);
695         }
696         bool takeFee = true;
697         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
698             takeFee = false;
699         }
700         _tokenTransfer(from,to,amount,takeFee);
701     }
702 
703     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
704         uint256 half = contractTokenBalance.div(2);
705         uint256 otherHalf = contractTokenBalance.sub(half);
706         uint256 initialBalance = address(this).balance;
707 
708         swapTokensForEth(half);
709         uint256 newBalance = address(this).balance.sub(initialBalance);
710         addLiquidity(otherHalf, newBalance);
711 
712         emit SwapAndLiquify(half, newBalance, otherHalf);
713     }
714 
715     function swapTokensForEth(uint256 tokenAmount) private {
716         address[] memory path = new address[](2);
717         path[0] = address(this);
718         path[1] = uniswapV2Router.WETH();
719 
720         _approve(address(this), address(uniswapV2Router), tokenAmount);
721 
722         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
723             tokenAmount,
724             0,
725             path,
726             address(this),
727             block.timestamp
728         );
729     }
730 
731     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
732         _approve(address(this), address(uniswapV2Router), tokenAmount);
733         uniswapV2Router.addLiquidityETH{value: ethAmount}(
734             address(this),
735             tokenAmount,
736             0,
737             0, 
738             owner(),
739             block.timestamp
740         );
741     }
742     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
743         if(!takeFee)
744             removeAllFee();
745 
746         if (_isExcluded[sender] && !_isExcluded[recipient]) {
747             _transferFromExcluded(sender, recipient, amount);
748         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
749             _transferToExcluded(sender, recipient, amount);
750         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
751             _transferStandard(sender, recipient, amount);
752         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
753             _transferBothExcluded(sender, recipient, amount);
754         } else {
755             _transferStandard(sender, recipient, amount);
756         }
757 
758         if(!takeFee)
759             restoreAllFee();
760     }
761 
762     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
763         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
764         _rOwned[sender] = _rOwned[sender].sub(rAmount);
765         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
766         _takeLiquidity(tLiquidity);
767         _reflectFee(rFee, tFee);
768         emit Transfer(sender, recipient, tTransferAmount);
769     }
770 
771     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
772         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
773         _rOwned[sender] = _rOwned[sender].sub(rAmount);
774         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
775         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
776         _takeLiquidity(tLiquidity);
777         _reflectFee(rFee, tFee);
778         emit Transfer(sender, recipient, tTransferAmount);
779     }
780 
781     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
782         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
783         _tOwned[sender] = _tOwned[sender].sub(tAmount);
784         _rOwned[sender] = _rOwned[sender].sub(rAmount);
785         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
786         _takeLiquidity(tLiquidity);
787         _reflectFee(rFee, tFee);
788         emit Transfer(sender, recipient, tTransferAmount);
789     }
790 
791 
792 
793 
794 }