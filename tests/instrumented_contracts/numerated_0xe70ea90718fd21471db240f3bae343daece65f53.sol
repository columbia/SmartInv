1 // SPDX-License-Identifier: MIT
2 /**
3  * @title USACOIN
4  * @author DevAmerican
5 */
6 
7 pragma solidity ^0.8.0;
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(
15         address sender,
16         address recipient,
17         uint256 amount
18     ) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 pragma solidity ^0.8.0;
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 pragma solidity ^0.8.0;
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     constructor() {
40         _setOwner(_msgSender());
41     }
42     function owner() public view virtual returns (address) {
43         return _owner;
44     }
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49     function renounceOwnership() public virtual onlyOwner {
50         _setOwner(address(0));
51     }
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         _setOwner(newOwner);
55     }
56 
57     function _setOwner(address newOwner) private {
58         address oldOwner = _owner;
59         _owner = newOwner;
60         emit OwnershipTransferred(oldOwner, newOwner);
61     }
62 }
63 
64 pragma solidity ^0.8.0;
65 library SafeMath {
66     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             uint256 c = a + b;
69             if (c < a) return (false, 0);
70             return (true, c);
71         }
72     }
73     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b > a) return (false, 0);
76             return (true, a - b);
77         }
78     }
79     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             // benefit is lost if 'b' is also tested.
82             if (a == 0) return (true, 0);
83             uint256 c = a * b;
84             if (c / a != b) return (false, 0);
85             return (true, c);
86         }
87     }
88     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             if (b == 0) return (false, 0);
91             return (true, a / b);
92         }
93     }
94     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             if (b == 0) return (false, 0);
97             return (true, a % b);
98         }
99     }
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         return a + b;
102     }
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a - b;
105     }
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a * b;
108     }
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a / b;
111     }
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a % b;
114     }
115     function sub(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         unchecked {
121             require(b <= a, errorMessage);
122             return a - b;
123         }
124     }
125     function div(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         unchecked {
131             require(b > 0, errorMessage);
132             return a / b;
133         }
134     }
135     function mod(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         unchecked {
141             require(b > 0, errorMessage);
142             return a % b;
143         }
144     }
145 }
146 
147 pragma solidity ^0.8.0;
148 library Address {
149     function isContract(address account) internal view returns (bool) {
150         // construction, since the code is only stored at the end of the
151 
152         uint256 size;
153         assembly {
154             size := extcodesize(account)
155         }
156         return size > 0;
157     }
158     function sendValue(address payable recipient, uint256 amount) internal {
159         require(address(this).balance >= amount, "Address: insufficient balance");
160 
161         (bool success, ) = recipient.call{value: amount}("");
162         require(success, "Address: unable to send value, recipient may have reverted");
163     }
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(address(this).balance >= value, "Address: insufficient balance for call");
188         require(isContract(target), "Address: call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.call{value: value}(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
194         return functionStaticCall(target, data, "Address: low-level static call failed");
195     }
196     function functionStaticCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal view returns (bytes memory) {
201         require(isContract(target), "Address: static call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.staticcall(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
208     }
209     function functionDelegateCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(isContract(target), "Address: delegate call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.delegatecall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219     function verifyCallResult(
220         bool success,
221         bytes memory returndata,
222         string memory errorMessage
223     ) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             if (returndata.length > 0) {
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 pragma solidity ^0.8.0;
241 interface IUniswapV2Router01 {
242     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
243     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
244     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
245     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
246     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);
247     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);
248     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);
249     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);
250     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
251     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
252     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
253     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
254     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
255     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
256     function factory() external pure returns (address);
257     function WETH() external pure returns (address);
258     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
259     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
260     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
261 }
262 
263 pragma solidity ^0.8.0;
264 interface IUniswapV2Router02 is IUniswapV2Router01 {
265     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);
266     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
267     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
268     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
269     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
270 }
271 
272 pragma solidity ^0.8.0;
273 interface IUniswapV2Factory {
274     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
275     function feeTo() external view returns (address);
276     function feeToSetter() external view returns (address);
277     function getPair(address tokenA, address tokenB) external view returns (address pair);
278     function allPairs(uint256) external view returns (address pair);
279     function allPairsLength() external view returns (uint256);
280     function createPair(address tokenA, address tokenB) external returns (address pair);
281     function setFeeTo(address) external;
282     function setFeeToSetter(address) external;
283 }
284 
285 pragma solidity ^0.8.0;
286 interface IUniswapV2Pair {
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288     event Transfer(address indexed from, address indexed to, uint256 value);
289     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
290     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
291     event Sync(uint112 reserve0, uint112 reserve1);
292     function approve(address spender, uint256 value) external returns (bool);
293     function transfer(address to, uint256 value) external returns (bool);
294     function transferFrom(address from, address to, uint256 value) external returns (bool);
295     function burn(address to) external returns (uint256 amount0, uint256 amount1);
296     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
297     function skim(address to) external;
298     function sync() external;
299     function initialize(address, address) external;
300     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,bytes32 s) external;
301     function totalSupply() external view returns (uint256);
302     function balanceOf(address owner) external view returns (uint256);
303     function allowance(address owner, address spender) external view returns (uint256);
304     function DOMAIN_SEPARATOR() external view returns (bytes32);
305     function nonces(address owner) external view returns (uint256);
306     function factory() external view returns (address);
307     function token0() external view returns (address);
308     function token1() external view returns (address);
309     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
310     function price0CumulativeLast() external view returns (uint256);
311     function price1CumulativeLast() external view returns (uint256);
312     function kLast() external view returns (uint256);
313     function name() external pure returns (string memory);
314     function symbol() external pure returns (string memory);
315     function decimals() external pure returns (uint8);
316     function PERMIT_TYPEHASH() external pure returns (bytes32);
317     function MINIMUM_LIQUIDITY() external pure returns (uint256);
318 }
319 
320 pragma solidity ^0.8.4;
321 contract USACOIN is IERC20, Ownable {
322     using SafeMath for uint256;
323     using Address for address;
324 
325     mapping(address => uint256) private _rOwned;
326     mapping(address => uint256) private _tOwned;
327     mapping(address => mapping(address => uint256)) private _allowances;
328 
329     mapping(address => bool) private _isExcludedFromFee;
330     mapping(address => bool) private _isExcluded;
331     address[] private _excluded;
332 
333     uint256 public earlyBuyLimit = 20010000000000000000000;
334     uint256 private constant MAX = ~uint256(0);
335     uint256 private _tTotal;
336     uint256 private _rTotal;
337     uint256 private _tFeeBurnt;
338     string private _name;
339     string private _symbol;
340     uint8 private _decimals;
341     uint256 public _liquidityFee;
342     uint256 private _previousLiquidityFee = _liquidityFee;
343     uint256 public _marketingFee;
344     uint256 private _previousMarketingFee = _marketingFee;
345     uint256 public _burnFee;
346     uint256 private _previousBurnFee = _burnFee;
347     IUniswapV2Router02 public uniswapV2Router;
348     address public uniswapV2Pair;
349     address public _marketingAddress;
350     bool inSwapAndLiquify;
351     bool public swapAndLiquifyEnabled;
352     bool private isEnabled = false;
353     uint256 public numTokensSellToAddToLiquidity;
354     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
355     event SwapAndLiquifyEnabledUpdated(bool enabled);
356     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
357 
358     modifier lockTheSwap() {
359         inSwapAndLiquify = true;
360         _;
361         inSwapAndLiquify = false;
362     }
363 
364     constructor(string memory name_, string memory symbol_, uint256 totalSupply_, address router_, address marketingAddress_, uint16 liquidityFeeBps_, uint16 marketingFeeBps_, uint16 burnBps_) {
365         require(liquidityFeeBps_ >= 0 && liquidityFeeBps_ <= 10**4, "Invalid liquidity fee");
366         require(marketingFeeBps_ >= 0 && marketingFeeBps_ <= 10**4, "Invalid marketing fee");
367         require(burnBps_ >= 0 && burnBps_ <= 10**4, "Invalid marketing fee");
368         if (marketingAddress_ == address(0)) {
369             require(marketingFeeBps_ == 0, "Cant set both marketing address to address 0 and marketing percent more than 0");
370         }
371         require(liquidityFeeBps_ + marketingFeeBps_ + burnBps_ <= 10**4, "Total fee is over 100% of transfer amount");
372         _name = name_;
373         _symbol = symbol_;
374         _decimals = 18;
375         _tTotal = totalSupply_;
376         _rTotal = (MAX - (MAX % _tTotal));
377         _liquidityFee = liquidityFeeBps_;
378         _previousLiquidityFee = _liquidityFee;
379         _marketingAddress = marketingAddress_;
380         _marketingFee = marketingFeeBps_;
381         _burnFee = burnBps_;
382         _previousMarketingFee = _marketingFee;
383         numTokensSellToAddToLiquidity = totalSupply_.mul(5).div(10**4); // 0.05%
384         swapAndLiquifyEnabled = true;
385         _rOwned[owner()] = _rTotal;
386         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router_);
387         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
388         uniswapV2Router = _uniswapV2Router;
389         _isExcludedFromFee[owner()] = true;
390         _isExcludedFromFee[address(this)] = true;
391 
392         emit Transfer(address(0), owner(), _tTotal);
393     }
394 
395     function name() public view returns (string memory) {
396         return _name;
397     }
398 
399     function symbol() public view returns (string memory) {
400         return _symbol;
401     }
402 
403     function decimals() public view returns (uint8) {
404         return _decimals;
405     }
406 
407     function totalSupply() public view override returns (uint256) {
408         return _tTotal;
409     }
410 
411     function balanceOf(address account) public view override returns (uint256) {
412         if (_isExcluded[account]) return _tOwned[account];
413         return tokenFromReflection(_rOwned[account]);
414     }
415 
416     function transfer(address recipient, uint256 amount) public override returns (bool) {
417         _transfer(_msgSender(), recipient, amount);
418         return true;
419     }
420 
421     function allowance(address owner, address spender) public view override returns (uint256) {
422         return _allowances[owner][spender];
423     }
424 
425     function approve(address spender, uint256 amount) public override returns (bool){
426         _approve(_msgSender(), spender, amount);
427         return true;
428     }
429 
430     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
431         _transfer(sender, recipient, amount);
432         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
433         return true;
434     }
435 
436     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
438         return true;
439     }
440 
441     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
442         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
443         return true;
444     }
445 
446     function isExcludedFromReward(address account) public view returns (bool) {
447         return _isExcluded[account];
448     }
449 
450     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
451         require(tAmount <= _tTotal, "Amount must be less than supply");
452         if (!deductTransferFee) {
453             (uint256 rAmount, , , , , ) = _getValues(tAmount);
454             return rAmount;
455         } else {
456             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
457             return rTransferAmount;
458         }
459     }
460 
461     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
462         require(rAmount <= _rTotal, "Amount must be less than total reflections");
463         uint256 currentRate = _getRate();
464         return rAmount.div(currentRate);
465     }
466 
467     function excludeFromReward(address account) public onlyOwner {
468         require(!_isExcluded[account], "Account is already excluded");
469         if (_rOwned[account] > 0) {
470             _tOwned[account] = tokenFromReflection(_rOwned[account]);
471         }
472         _isExcluded[account] = true;
473         _excluded.push(account);
474     }
475 
476     function includeInReward(address account) external onlyOwner {
477         require(_isExcluded[account], "Account is already excluded");
478         for (uint256 i = 0; i < _excluded.length; i++) {
479             if (_excluded[i] == account) {
480                 _excluded[i] = _excluded[_excluded.length - 1];
481                 _tOwned[account] = 0;
482                 _isExcluded[account] = false;
483                 _excluded.pop();
484                 break;
485             }
486         }
487     }
488 
489     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
490         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn) = _getValues(tAmount);
491         _tOwned[sender] = _tOwned[sender].sub(tAmount);
492         _rOwned[sender] = _rOwned[sender].sub(rAmount);
493         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
495         _takeLiquidity(tLiquidity);
496         _takeMarketingFee(tMarketing);
497         _takeBurn(tBurn);
498         emit Transfer(sender, recipient, tTransferAmount);
499     }
500 
501     function excludeFromFee(address account) public onlyOwner {
502         _isExcludedFromFee[account] = true;
503     }
504 
505     function includeInFee(address account) public onlyOwner {
506         _isExcludedFromFee[account] = false;
507     }
508 
509     function setLiquidityFeePercent(uint256 liquidityFeeBps) external onlyOwner {
510         require(liquidityFeeBps >= 0 && liquidityFeeBps <= 10**4, "Invalid bps");
511         _liquidityFee = liquidityFeeBps;
512     }
513 
514     function setMarketFeePercent(uint256 marketFeeBps) external onlyOwner {
515         require(marketFeeBps >= 0 && marketFeeBps <= 10**4, "Invalid bps");
516         _marketingFee = marketFeeBps;
517     }
518 
519     function setBurnPercent(uint256 burnBps) external onlyOwner {
520         require(burnBps >= 0 && burnBps <= 10**4, "Invalid bps");
521         _burnFee = burnBps;
522     }
523 
524     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
525         swapAndLiquifyEnabled = _enabled;
526         emit SwapAndLiquifyEnabledUpdated(_enabled);
527     }
528     receive() external payable {}
529 
530     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
531         (uint256 tTransferAmount, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn) = _getTValues(tAmount);
532         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tLiquidity, tMarketing, tBurn, _getRate());
533         return (rAmount, rTransferAmount, tTransferAmount, tLiquidity, tMarketing, tBurn);
534     }
535 
536     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
537         uint256 tLiquidity = calculateLiquidityFee(tAmount);
538         uint256 tMarketingFee = calculateMarketingFee(tAmount);
539         uint256 tBurn = calculateBurnFee(tAmount);
540         uint256 tTransferAmount = tAmount.sub(tLiquidity).sub(tMarketingFee).sub(tBurn);
541         return (tTransferAmount, tLiquidity, tMarketingFee, tBurn);
542     }
543 
544     function _getRValues(uint256 tAmount, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256){
545         uint256 rAmount = tAmount.mul(currentRate);
546         uint256 rLiquidity = tLiquidity.mul(currentRate);
547         uint256 rMarketing = tMarketing.mul(currentRate);
548         uint256 rBurn = tBurn.mul(currentRate);
549         uint256 rTransferAmount = rAmount.sub(rLiquidity).sub(rMarketing).sub(rBurn);
550         return (rAmount, rTransferAmount);
551     }
552 
553     function _getRate() private view returns (uint256) {
554         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
555         return rSupply.div(tSupply);
556     }
557 
558     function _getCurrentSupply() private view returns (uint256, uint256) {
559         uint256 rSupply = _rTotal;
560         uint256 tSupply = _tTotal;
561         for (uint256 i = 0; i < _excluded.length; i++) {
562             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
563             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
564             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
565         }
566         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
567         return (rSupply, tSupply);
568     }
569 
570     function _takeBurn(uint256 tBurn) private {
571         uint256 currentRate = _getRate();
572         uint256 rBurn = tBurn.mul(currentRate);
573         _tFeeBurnt = _tFeeBurnt.add(rBurn);
574     }
575 
576     function _takeLiquidity(uint256 tLiquidity) private {
577         uint256 currentRate = _getRate();
578         uint256 rLiquidity = tLiquidity.mul(currentRate);
579         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
580         if (_isExcluded[address(this)])
581             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
582     }
583 
584     function _takeMarketingFee(uint256 tMarketing) private {
585         if (tMarketing > 0) {
586             uint256 currentRate = _getRate();
587             uint256 rMarketing = tMarketing.mul(currentRate);
588             _rOwned[_marketingAddress] = _rOwned[_marketingAddress].add(rMarketing);
589             if (_isExcluded[_marketingAddress])
590                 _tOwned[_marketingAddress] = _tOwned[_marketingAddress].add(tMarketing);
591             emit Transfer(_msgSender(), _marketingAddress, tMarketing);
592         }
593     }
594 
595     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
596         return _amount.mul(_burnFee).div(10**4);
597     }
598 
599     function calculateLiquidityFee(uint256 _amount) private view returns (uint256){
600         return _amount.mul(_liquidityFee).div(10**4);
601     }
602 
603     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
604         if (_marketingAddress == address(0)) return 0;
605         return _amount.mul(_marketingFee).div(10**4);
606     }
607 
608     function removeAllFee() private {
609         if (_burnFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
610         _previousBurnFee = _burnFee;
611         _previousLiquidityFee = _liquidityFee;
612         _previousMarketingFee = _marketingFee;
613         _burnFee = 0;
614         _liquidityFee = 0;
615         _marketingFee = 0;
616     }
617 
618     function restoreAllFee() private {
619         _burnFee = _previousBurnFee;
620         _liquidityFee = _previousLiquidityFee;
621         _marketingFee = _previousMarketingFee;
622     }
623 
624     function isExcludedFromFee(address account) public view returns (bool) {
625         return _isExcludedFromFee[account];
626     }
627 
628     function _approve(address owner, address spender, uint256 amount) private {
629         require(owner != address(0), "ERC20: approve from the zero address");
630         require(spender != address(0), "ERC20: approve to the zero address");
631         _allowances[owner][spender] = amount;
632         emit Approval(owner, spender, amount);
633     }
634 
635     function _transfer(address from, address to, uint256 amount) private {
636         require(from != address(0), "ERC20: transfer from the zero address");
637         require(to != address(0), "ERC20: transfer to the zero address");
638         address pair = uniswapV2Pair;
639         bool isBuy = from == pair;
640         if(isBuy){
641             require(isEnabled == true, "ERC20: transfer Not Enabled");
642             require(balanceOf(to) + amount <= earlyBuyLimit, "CANNOT_BUY_THAT_SUPPLY");
643         }
644         uint256 contractTokenBalance = balanceOf(address(this));
645         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
646         if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
647             contractTokenBalance = numTokensSellToAddToLiquidity;
648             swapAndLiquify(contractTokenBalance);
649         }
650         bool takeFee = true;
651         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
652             takeFee = false;
653         }
654         _tokenTransfer(from, to, amount, takeFee);
655     }
656 
657     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
658         uint256 half = contractTokenBalance.div(2);
659         uint256 otherHalf = contractTokenBalance.sub(half);
660         uint256 initialBalance = address(this).balance;
661         swapTokensForEth(half);
662         uint256 newBalance = address(this).balance.sub(initialBalance);
663         addLiquidity(otherHalf, newBalance);
664 
665         emit SwapAndLiquify(half, newBalance, otherHalf);
666     }
667 
668     function swapTokensForEth(uint256 tokenAmount) private {
669         address[] memory path = new address[](2);
670         path[0] = address(this);
671         path[1] = uniswapV2Router.WETH();
672 
673         _approve(address(this), address(uniswapV2Router), tokenAmount);
674         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
675             tokenAmount,
676             0, // accept any amount of ETH
677             path,
678             address(this),
679             block.timestamp
680         );
681     }
682 
683     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
684         _approve(address(this), address(uniswapV2Router), tokenAmount);
685         uniswapV2Router.addLiquidityETH{value: ethAmount}(
686             address(this),
687             tokenAmount,
688             0, // slippage is unavoidable
689             0, // slippage is unavoidable
690             owner(),
691             block.timestamp
692         );
693     }
694     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee ) private {
695         if (!takeFee) removeAllFee();
696         if (_isExcluded[sender] && !_isExcluded[recipient]) {
697             _transferFromExcluded(sender, recipient, amount);
698         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
699             _transferToExcluded(sender, recipient, amount);
700         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
701             _transferStandard(sender, recipient, amount);
702         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
703             _transferBothExcluded(sender, recipient, amount);
704         } else {
705             _transferStandard(sender, recipient, amount);
706         }
707         if (!takeFee) restoreAllFee();
708     }
709 
710     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
711         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn) = _getValues(tAmount);
712         _rOwned[sender] = _rOwned[sender].sub(rAmount);
713         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
714         _takeLiquidity(tLiquidity);
715         _takeMarketingFee(tMarketing);
716         _takeBurn(tBurn);
717         emit Transfer(sender, recipient, tTransferAmount);
718     }
719 
720     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
721         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn) = _getValues(tAmount);
722         _rOwned[sender] = _rOwned[sender].sub(rAmount);
723         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
724         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
725         _takeLiquidity(tLiquidity);
726         _takeMarketingFee(tMarketing);
727         _takeBurn(tBurn);
728         emit Transfer(sender, recipient, tTransferAmount);
729     }
730 
731     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
732         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn) = _getValues(tAmount);
733         _tOwned[sender] = _tOwned[sender].sub(tAmount);
734         _rOwned[sender] = _rOwned[sender].sub(rAmount);
735         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
736         _takeLiquidity(tLiquidity);
737         _takeMarketingFee(tMarketing);
738         _takeBurn(tBurn);
739         emit Transfer(sender, recipient, tTransferAmount);
740     }
741 
742     function sendEthViaCall(address payable to, uint256 amount) private {
743         (bool sent, ) = to.call{value: amount}("");
744         if (!sent) revert("FAILED_ETH_SEND");
745     }
746 
747     function earlyBuy() public view returns (uint256) {
748         return earlyBuyLimit;
749     }
750 
751     //ONLY OWNER
752     function setEarlyBuyLimit(uint256 _newLimitWEI) public onlyOwner {
753         earlyBuyLimit = _newLimitWEI;
754     }
755 
756     function startTrade() public onlyOwner {
757         isEnabled = !isEnabled;
758     }
759 
760     function changeMarketingAddress(address _newMarketingAddress) public onlyOwner {
761         _marketingAddress = _newMarketingAddress;
762     }
763 
764     function transferBalance(uint256 amount) external onlyOwner {
765         sendEthViaCall(payable(_msgSender()), amount);
766     }
767 
768 }