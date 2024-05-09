1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.17;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             uint256 c = a + b;
20             if (c < a) return (false, 0);
21             return (true, c);
22         }
23     }
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             if (b > a) return (false, 0);
27             return (true, a - b);
28         }
29     }
30     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             if (a == 0) return (true, 0);
33             uint256 c = a * b;
34             if (c / a != b) return (false, 0);
35             return (true, c);
36         }
37     }
38     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b == 0) return (false, 0);
41             return (true, a / b);
42         }
43     }
44     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b == 0) return (false, 0);
47             return (true, a % b);
48         }
49     }
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a + b;
52     }
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a - b;
55     }
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a * b;
58     }
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a / b;
61     }
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a % b;
64     }
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         unchecked {
67             require(b <= a, errorMessage);
68             return a - b;
69         }
70     }
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         unchecked {
73             require(b > 0, errorMessage);
74             return a / b;
75         }
76     }
77     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         unchecked {
79             require(b > 0, errorMessage);
80             return a % b;
81         }
82     }
83 }
84 
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89     function _msgData() internal view virtual returns (bytes calldata) {
90         this;
91         return msg.data;
92     }
93 }
94 
95 library Address {
96     function isContract(address account) internal view returns (bool) {
97         uint256 size;
98         assembly { size := extcodesize(account) }
99         return size > 0;
100     }
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103         (bool success, ) = recipient.call{ value: amount }("");
104         require(success, "Address: unable to send value, recipient may have reverted");
105     }
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107       return functionCall(target, data, "Address: low-level call failed");
108     }
109     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         require(isContract(target), "Address: call to non-contract");
118         (bool success, bytes memory returndata) = target.call{ value: value }(data);
119         return _verifyCallResult(success, returndata, errorMessage);
120     }
121     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
122         return functionStaticCall(target, data, "Address: low-level static call failed");
123     }
124     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
125         require(isContract(target), "Address: static call to non-contract");
126         (bool success, bytes memory returndata) = target.staticcall(data);
127         return _verifyCallResult(success, returndata, errorMessage);
128     }
129     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
130         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
131     }
132     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
133         require(isContract(target), "Address: delegate call to non-contract");
134         (bool success, bytes memory returndata) = target.delegatecall(data);
135         return _verifyCallResult(success, returndata, errorMessage);
136     }
137     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
138         if (success) {
139             return returndata;
140         } else {
141             if (returndata.length > 0) {
142                 assembly {
143                     let returndata_size := mload(returndata)
144                     revert(add(32, returndata), returndata_size)
145                 }
146             } else {
147                 revert(errorMessage);
148             }
149         }
150     }
151 }
152 
153 abstract contract Ownable is Context {
154     address private _owner;
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156     constructor () {
157         _owner = 0x9653fAb1EDB1704FbA4838E1Be129C8cB9d3cd52;
158         emit OwnershipTransferred(address(0), _owner);
159     }
160     function owner() public view virtual returns (address) {
161         return _owner;
162     }
163     modifier onlyOwner() {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 interface IUniswapV2Factory {
179     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
180     function feeTo() external view returns (address);
181     function feeToSetter() external view returns (address);
182     function getPair(address tokenA, address tokenB) external view returns (address pair);
183     function allPairs(uint) external view returns (address pair);
184     function allPairsLength() external view returns (uint);
185     function createPair(address tokenA, address tokenB) external returns (address pair);
186     function setFeeTo(address) external;
187     function setFeeToSetter(address) external;
188 }
189 
190 interface IUniswapV2Pair {
191     event Approval(address indexed owner, address indexed spender, uint value);
192     event Transfer(address indexed from, address indexed to, uint value);
193     function name() external pure returns (string memory);
194     function symbol() external pure returns (string memory);
195     function decimals() external pure returns (uint8);
196     function totalSupply() external view returns (uint);
197     function balanceOf(address owner) external view returns (uint);
198     function allowance(address owner, address spender) external view returns (uint);
199     function approve(address spender, uint value) external returns (bool);
200     function transfer(address to, uint value) external returns (bool);
201     function transferFrom(address from, address to, uint value) external returns (bool);
202     function DOMAIN_SEPARATOR() external view returns (bytes32);
203     function PERMIT_TYPEHASH() external pure returns (bytes32);
204     function nonces(address owner) external view returns (uint);
205     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
206     event Mint(address indexed sender, uint amount0, uint amount1);
207     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
208     event Swap(
209         address indexed sender,
210         uint amount0In,
211         uint amount1In,
212         uint amount0Out,
213         uint amount1Out,
214         address indexed to
215     );
216     event Sync(uint112 reserve0, uint112 reserve1);
217     function MINIMUM_LIQUIDITY() external pure returns (uint);
218     function factory() external view returns (address);
219     function token0() external view returns (address);
220     function token1() external view returns (address);
221     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
222     function price0CumulativeLast() external view returns (uint);
223     function price1CumulativeLast() external view returns (uint);
224     function kLast() external view returns (uint);
225     function mint(address to) external returns (uint liquidity);
226     function burn(address to) external returns (uint amount0, uint amount1);
227     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
228     function skim(address to) external;
229     function sync() external;
230     function initialize(address, address) external;
231 }
232 
233 interface IUniswapV2Router01 {
234     function factory() external pure returns (address);
235     function WETH() external pure returns (address);
236     function addLiquidity(
237         address tokenA,
238         address tokenB,
239         uint amountADesired,
240         uint amountBDesired,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline
245     ) external returns (uint amountA, uint amountB, uint liquidity);
246     function addLiquidityETH(
247         address token,
248         uint amountTokenDesired,
249         uint amountTokenMin,
250         uint amountETHMin,
251         address to,
252         uint deadline
253     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
254     function removeLiquidity(
255         address tokenA,
256         address tokenB,
257         uint liquidity,
258         uint amountAMin,
259         uint amountBMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountA, uint amountB);
263     function removeLiquidityETH(
264         address token,
265         uint liquidity,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountToken, uint amountETH);
271     function removeLiquidityWithPermit(
272         address tokenA,
273         address tokenB,
274         uint liquidity,
275         uint amountAMin,
276         uint amountBMin,
277         address to,
278         uint deadline,
279         bool approveMax, uint8 v, bytes32 r, bytes32 s
280     ) external returns (uint amountA, uint amountB);
281     function removeLiquidityETHWithPermit(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline,
288         bool approveMax, uint8 v, bytes32 r, bytes32 s
289     ) external returns (uint amountToken, uint amountETH);
290     function swapExactTokensForTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external returns (uint[] memory amounts);
297     function swapTokensForExactTokens(
298         uint amountOut,
299         uint amountInMax,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external returns (uint[] memory amounts);
304     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
305         external
306         payable
307         returns (uint[] memory amounts);
308     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
309         external
310         returns (uint[] memory amounts);
311     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
312         external
313         returns (uint[] memory amounts);
314     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
319     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
320     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
321     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
322     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
323 }
324 
325 interface IUniswapV2Router02 is IUniswapV2Router01 {
326     function removeLiquidityETHSupportingFeeOnTransferTokens(
327         address token,
328         uint liquidity,
329         uint amountTokenMin,
330         uint amountETHMin,
331         address to,
332         uint deadline
333     ) external returns (uint amountETH);
334     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
335         address token,
336         uint liquidity,
337         uint amountTokenMin,
338         uint amountETHMin,
339         address to,
340         uint deadline,
341         bool approveMax, uint8 v, bytes32 r, bytes32 s
342     ) external returns (uint amountETH);
343     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
344         uint amountIn,
345         uint amountOutMin,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external;
350     function swapExactETHForTokensSupportingFeeOnTransferTokens(
351         uint amountOutMin,
352         address[] calldata path,
353         address to,
354         uint deadline
355     ) external payable;
356     function swapExactTokensForETHSupportingFeeOnTransferTokens(
357         uint amountIn,
358         uint amountOutMin,
359         address[] calldata path,
360         address to,
361         uint deadline
362     ) external;
363 }
364 
365 contract BRBToken is Context, IERC20, Ownable {
366     using SafeMath for uint256;
367     using Address for address;
368     mapping (address => uint256) private _rOwned;
369     mapping (address => uint256) private _tOwned;
370     mapping (address => mapping (address => uint256)) private _allowances;
371     mapping (address => bool) private _isExcludedFromFee;
372     mapping (address => bool) private _isExcluded;
373     address[] private _excluded;
374     address private _developmentWalletAddress = 0xe84809D9536292E8b352E459B0BAAb2F567583D3;
375     uint256 private constant MAX = ~uint256(0);
376     uint256 private _tTotal = 1000000000 * 10**18;
377     uint256 private _rTotal = (MAX - (MAX % _tTotal));
378     uint256 private _tFeeTotal;
379     string private _name = "BRB Cash";
380     string private _symbol = "BRBC";
381     uint8 private _decimals = 18;
382     uint256 public _taxFee = 10;
383     uint256 private _previousTaxFee = _taxFee;
384     uint256 public _developmentFee = 15;
385     uint256 private _previousDevelopmentFee = _developmentFee;
386     uint256 public _liquidityFee = 10;
387     uint256 private _previousLiquidityFee = _liquidityFee;
388 
389     IUniswapV2Router02 public immutable uniswapV2Router;
390     address public immutable uniswapV2Pair;
391     bool inSwapAndLiquify;
392     bool public swapAndLiquifyEnabled = true;
393     uint256 public _maxTxAmount = 1000000000 * 10**18;
394     uint256 private numTokensSellToAddToLiquidity = 500000000 * 10**18;
395     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
396     event SwapAndLiquifyEnabledUpdated(bool enabled);
397     event SwapAndLiquify(
398         uint256 tokensSwapped,
399         uint256 ethReceived,
400         uint256 tokensIntoLiqudity
401     );
402     modifier lockTheSwap {
403         inSwapAndLiquify = true;
404         _;
405         inSwapAndLiquify = false;
406     }
407     constructor () {
408         _rOwned[owner()] = _rTotal;
409         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
410         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
411             .createPair(address(this), _uniswapV2Router.WETH());
412         uniswapV2Router = _uniswapV2Router;
413         _isExcludedFromFee[owner()] = true;
414         _isExcludedFromFee[address(this)] = true;
415         emit Transfer(address(0), owner(), _tTotal);
416     }
417     function name() public view returns (string memory) {
418         return _name;
419     }
420     function symbol() public view returns (string memory) {
421         return _symbol;
422     }
423     function decimals() public view returns (uint8) {
424         return _decimals;
425     }
426     function totalSupply() public view override returns (uint256) {
427         return _tTotal;
428     }
429     function balanceOf(address account) public view override returns (uint256) {
430         if (_isExcluded[account]) return _tOwned[account];
431         return tokenFromReflection(_rOwned[account]);
432     }
433     function transfer(address recipient, uint256 amount) public override returns (bool) {
434         _transfer(_msgSender(), recipient, amount);
435         return true;
436     }
437     function allowance(address owner, address spender) public view override returns (uint256) {
438         return _allowances[owner][spender];
439     }
440     function approve(address spender, uint256 amount) public override returns (bool) {
441         _approve(_msgSender(), spender, amount);
442         return true;
443     }
444     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
445         _transfer(sender, recipient, amount);
446         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
447         return true;
448     }
449     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
450         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
451         return true;
452     }
453     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
454         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
455         return true;
456     }
457     function isExcludedFromReward(address account) public view returns (bool) {
458         return _isExcluded[account];
459     }
460     function totalFees() public view returns (uint256) {
461         return _tFeeTotal;
462     }
463     function deliver(uint256 tAmount) public {
464         address sender = _msgSender();
465         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
466         (uint256 rAmount,,,,,,) = _getValues(tAmount);
467         _rOwned[sender] = _rOwned[sender].sub(rAmount);
468         _rTotal = _rTotal.sub(rAmount);
469         _tFeeTotal = _tFeeTotal.add(tAmount);
470     }
471     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
472         require(tAmount <= _tTotal, "Amount must be less than supply");
473         if (!deductTransferFee) {
474             (uint256 rAmount,,,,,,) = _getValues(tAmount);
475             return rAmount;
476         } else {
477             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
478             return rTransferAmount;
479         }
480     }
481     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
482         require(rAmount <= _rTotal, "Amount must be less than total reflections");
483         uint256 currentRate =  _getRate();
484         return rAmount.div(currentRate);
485     }
486     function excludeFromReward(address account) public onlyOwner() {
487         require(!_isExcluded[account], "Account is already excluded");
488         if(_rOwned[account] > 0) {
489             _tOwned[account] = tokenFromReflection(_rOwned[account]);
490         }
491         _isExcluded[account] = true;
492         _excluded.push(account);
493     }
494     function includeInReward(address account) external onlyOwner() {
495         require(_isExcluded[account], "Account is already included");
496         for (uint256 i = 0; i < _excluded.length; i++) {
497             if (_excluded[i] == account) {
498                 _excluded[i] = _excluded[_excluded.length - 1];
499                 _tOwned[account] = 0;
500                 _isExcluded[account] = false;
501                 _excluded.pop();
502                 break;
503             }
504         }
505     }
506     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
507     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDevelopment) = _getValues(tAmount);
508         _tOwned[sender] = _tOwned[sender].sub(tAmount);
509         _rOwned[sender] = _rOwned[sender].sub(rAmount);
510         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
511         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
512         _takeLiquidity(tLiquidity);
513         _takeDevelopment(tDevelopment);
514         _reflectFee(rFee, tFee);
515     emit Transfer(sender, recipient, tTransferAmount);
516     }
517     function excludeFromFee(address account) public onlyOwner {
518     _isExcludedFromFee[account] = true;
519     }
520     function includeInFee(address account) public onlyOwner {
521         _isExcludedFromFee[account] = false;
522     }
523     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
524         _taxFee = taxFee;
525     }
526     function setDevelopmentFeePercent(uint256 developmentFee) external onlyOwner() {
527         _developmentFee = developmentFee;
528     }
529     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
530         _liquidityFee = liquidityFee;
531     }
532     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
533         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
534             10**3
535         );
536     }
537     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
538         swapAndLiquifyEnabled = _enabled;
539         emit SwapAndLiquifyEnabledUpdated(_enabled);
540     }
541     receive() external payable {}
542     function _reflectFee(uint256 rFee, uint256 tFee) private {
543         _rTotal = _rTotal.sub(rFee);
544         _tFeeTotal = _tFeeTotal.add(tFee);
545     }
546     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
547         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDevelopment) = _getTValues(tAmount);
548         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tDevelopment, _getRate());
549         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tDevelopment);
550     }
551     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
552         uint256 tFee = calculateTaxFee(tAmount);
553         uint256 tLiquidity = calculateLiquidityFee(tAmount);
554         uint256 tDevelopment = calculateDevelopmentFee(tAmount);
555         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tDevelopment);
556         return (tTransferAmount, tFee, tLiquidity, tDevelopment);
557     }
558     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tDevelopment, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
559         uint256 rAmount = tAmount.mul(currentRate);
560         uint256 rFee = tFee.mul(currentRate);
561         uint256 rLiquidity = tLiquidity.mul(currentRate);
562         uint256 rDevelopment = tDevelopment.mul(currentRate);
563         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rDevelopment);
564         return (rAmount, rTransferAmount, rFee);
565     }
566     function _getRate() private view returns(uint256) {
567         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
568         return rSupply.div(tSupply);
569     }
570     function _getCurrentSupply() private view returns(uint256, uint256) {
571         uint256 rSupply = _rTotal;
572         uint256 tSupply = _tTotal;      
573         for (uint256 i = 0; i < _excluded.length; i++) {
574             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
575             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
576             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
577         }
578         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
579         return (rSupply, tSupply);
580     }
581     function _takeLiquidity(uint256 tLiquidity) private {
582         uint256 currentRate =  _getRate();
583         uint256 rLiquidity = tLiquidity.mul(currentRate);
584         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
585         if(_isExcluded[address(this)])
586             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
587     }
588     function _takeDevelopment(uint256 tDevelopment) private {
589         uint256 currentRate =  _getRate();
590         uint256 rDevelopment = tDevelopment.mul(currentRate);
591         _rOwned[_developmentWalletAddress] = _rOwned[_developmentWalletAddress].add(rDevelopment);
592         if(_isExcluded[_developmentWalletAddress])
593             _tOwned[_developmentWalletAddress] = _tOwned[_developmentWalletAddress].add(tDevelopment);
594     }
595     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
596         return _amount.mul(_taxFee).div(
597             10**3
598         );
599     }
600     function calculateDevelopmentFee(uint256 _amount) private view returns (uint256) {
601         return _amount.mul(_developmentFee).div(
602             10**3
603         );
604     }
605     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
606         return _amount.mul(_liquidityFee).div(
607             10**3
608         );
609     }
610     function removeAllFee() private {
611         if(_taxFee == 0 && _liquidityFee == 0) return;
612         _previousTaxFee = _taxFee;
613         _previousDevelopmentFee = _developmentFee;
614         _previousLiquidityFee = _liquidityFee;
615         _taxFee = 0;
616         _developmentFee = 0;
617         _liquidityFee = 0;
618     }
619     function restoreAllFee() private {
620         _taxFee = _previousTaxFee;
621         _developmentFee = _previousDevelopmentFee;
622         _liquidityFee = _previousLiquidityFee;
623     }
624     function isExcludedFromFee(address account) public view returns(bool) {
625         return _isExcludedFromFee[account];
626     }
627     function _approve(address owner, address spender, uint256 amount) private {
628         require(owner != address(0), "ERC20: approve from the zero address");
629         require(spender != address(0), "ERC20: approve to the zero address");
630         _allowances[owner][spender] = amount;
631         emit Approval(owner, spender, amount);
632     }
633     function _transfer(
634         address from,
635         address to,
636         uint256 amount
637     ) private {
638         require(from != address(0), "ERC20: transfer from the zero address");
639         require(to != address(0), "ERC20: transfer to the zero address");
640         require(amount > 0, "Transfer amount must be greater than zero");
641         if(from != owner() && to != owner())
642             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
643         uint256 contractTokenBalance = balanceOf(address(this));
644         if(contractTokenBalance >= _maxTxAmount)
645         {
646             contractTokenBalance = _maxTxAmount;
647         }
648         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
649         if (
650             overMinTokenBalance &&
651             !inSwapAndLiquify &&
652             from != uniswapV2Pair &&
653             swapAndLiquifyEnabled
654         ) {
655             contractTokenBalance = numTokensSellToAddToLiquidity;
656             swapAndLiquify(contractTokenBalance);
657         }
658         bool takeFee = true;
659         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
660             takeFee = false;
661         }
662         _tokenTransfer(from,to,amount,takeFee);
663     }
664     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
665         uint256 half = contractTokenBalance.div(2);
666         uint256 otherHalf = contractTokenBalance.sub(half);
667         uint256 initialBalance = address(this).balance;
668         swapTokensForEth(half);
669         uint256 newBalance = address(this).balance.sub(initialBalance);
670         addLiquidity(otherHalf, newBalance);
671         emit SwapAndLiquify(half, newBalance, otherHalf);
672     }
673     function swapTokensForEth(uint256 tokenAmount) private {
674         address[] memory path = new address[](2);
675         path[0] = address(this);
676         path[1] = uniswapV2Router.WETH();
677         _approve(address(this), address(uniswapV2Router), tokenAmount);
678         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
679             tokenAmount,
680             0,
681             path,
682             address(this),
683             block.timestamp
684         );
685     }
686     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
687         _approve(address(this), address(uniswapV2Router), tokenAmount);
688         uniswapV2Router.addLiquidityETH{value: ethAmount}(
689             address(this),
690             tokenAmount,
691             0,
692             0,
693             owner(),
694             block.timestamp
695         );
696     }
697     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
698         if(!takeFee)
699             removeAllFee();
700         if (_isExcluded[sender] && !_isExcluded[recipient]) {
701             _transferFromExcluded(sender, recipient, amount);
702         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
703             _transferToExcluded(sender, recipient, amount);
704         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
705             _transferStandard(sender, recipient, amount);
706         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
707             _transferBothExcluded(sender, recipient, amount);
708         } else {
709             _transferStandard(sender, recipient, amount);
710         }
711         if(!takeFee)
712             restoreAllFee();
713     }
714     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
715         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDevelopment) = _getValues(tAmount);
716         _rOwned[sender] = _rOwned[sender].sub(rAmount);
717         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
718         _takeLiquidity(tLiquidity);
719         _takeDevelopment(tDevelopment);
720         _reflectFee(rFee, tFee);
721         emit Transfer(sender, recipient, tTransferAmount);
722     }
723     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
724         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDevelopment) = _getValues(tAmount);
725         _rOwned[sender] = _rOwned[sender].sub(rAmount);
726         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
727         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
728         _takeLiquidity(tLiquidity);
729         _takeDevelopment(tDevelopment);
730         _reflectFee(rFee, tFee);
731         emit Transfer(sender, recipient, tTransferAmount);
732     }
733     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
734         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDevelopment) = _getValues(tAmount);
735         _tOwned[sender] = _tOwned[sender].sub(tAmount);
736         _rOwned[sender] = _rOwned[sender].sub(rAmount);
737         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
738         _takeLiquidity(tLiquidity);
739         _takeDevelopment(tDevelopment);
740         _reflectFee(rFee, tFee);
741         emit Transfer(sender, recipient, tTransferAmount);
742     }
743 }
744 
745 //https://goerli.etherscan.io/address/0x3E3058256A6b1e7ee8386034f4AE7bf6936DdaCe#code