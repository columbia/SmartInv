1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21  
22 library SafeMath {
23     
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43 
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61 
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         return mod(a, b, "SafeMath: modulo by zero");
67     }
68 
69     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b != 0, errorMessage);
71         return a % b;
72     }
73 }
74 
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address payable) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
82         return msg.data;
83     }
84 }
85 
86 library Address {
87 
88     function isContract(address account) internal view returns (bool) {
89         bytes32 codehash;
90         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
91         assembly { codehash := extcodehash(account) }
92         return (codehash != accountHash && codehash != 0x0);
93     }
94 
95     function sendValue(address payable recipient, uint256 amount) internal {
96         require(address(this).balance >= amount, "Address: insufficient balance");
97 
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103       return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
107         return _functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126 
127             if (returndata.length > 0) {
128 
129                 assembly {
130                     let returndata_size := mload(returndata)
131                     revert(add(32, returndata), returndata_size)
132                 }
133             } else {
134                 revert(errorMessage);
135             }
136         }
137     }
138 }
139 
140 contract Ownable is Context {
141     address private _owner;
142     address private _previousOwner;
143     uint256 private _lockTime;
144 
145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
146 
147     constructor () internal {
148         address msgSender = _msgSender();
149         _owner = msgSender;
150         emit OwnershipTransferred(address(0), msgSender);
151     }
152 
153     function owner() public view returns (address) {
154         return _owner;
155     }
156 
157     modifier onlyOwner() {
158         require(_owner == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 
173     function geUnlockTime() public view returns (uint256) {
174         return _lockTime;
175     }
176 
177     function lock(uint256 time) public virtual onlyOwner {
178         _previousOwner = _owner;
179         _owner = address(0);
180         _lockTime = now + time;
181         emit OwnershipTransferred(_owner, address(0));
182     }
183     
184     function unlock() public virtual {
185         require(_previousOwner == msg.sender, "You don't have permission to unlock");
186         require(now > _lockTime , "Contract is locked until 7 days");
187         emit OwnershipTransferred(_owner, _previousOwner);
188         _owner = _previousOwner;
189     }
190 }
191 
192 interface IUniswapV2Factory {
193     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
194 
195     function feeTo() external view returns (address);
196     function feeToSetter() external view returns (address);
197 
198     function getPair(address tokenA, address tokenB) external view returns (address pair);
199     function allPairs(uint) external view returns (address pair);
200     function allPairsLength() external view returns (uint);
201 
202     function createPair(address tokenA, address tokenB) external returns (address pair);
203 
204     function setFeeTo(address) external;
205     function setFeeToSetter(address) external;
206 }
207 
208 interface IUniswapV2Pair {
209     event Approval(address indexed owner, address indexed spender, uint value);
210     event Transfer(address indexed from, address indexed to, uint value);
211 
212     function name() external pure returns (string memory);
213     function symbol() external pure returns (string memory);
214     function decimals() external pure returns (uint8);
215     function totalSupply() external view returns (uint);
216     function balanceOf(address owner) external view returns (uint);
217     function allowance(address owner, address spender) external view returns (uint);
218 
219     function approve(address spender, uint value) external returns (bool);
220     function transfer(address to, uint value) external returns (bool);
221     function transferFrom(address from, address to, uint value) external returns (bool);
222 
223     function DOMAIN_SEPARATOR() external view returns (bytes32);
224     function PERMIT_TYPEHASH() external pure returns (bytes32);
225     function nonces(address owner) external view returns (uint);
226 
227     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
228 
229     event Mint(address indexed sender, uint amount0, uint amount1);
230     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
231     event Swap(
232         address indexed sender,
233         uint amount0In,
234         uint amount1In,
235         uint amount0Out,
236         uint amount1Out,
237         address indexed to
238     );
239     event Sync(uint112 reserve0, uint112 reserve1);
240 
241     function MINIMUM_LIQUIDITY() external pure returns (uint);
242     function factory() external view returns (address);
243     function token0() external view returns (address);
244     function token1() external view returns (address);
245     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
246     function price0CumulativeLast() external view returns (uint);
247     function price1CumulativeLast() external view returns (uint);
248     function kLast() external view returns (uint);
249 
250     function mint(address to) external returns (uint liquidity);
251     function burn(address to) external returns (uint amount0, uint amount1);
252     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
253     function skim(address to) external;
254     function sync() external;
255 
256     function initialize(address, address) external;
257 }
258 
259 interface IUniswapV2Router01 {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262 
263     function addLiquidity(
264         address tokenA,
265         address tokenB,
266         uint amountADesired,
267         uint amountBDesired,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB, uint liquidity);
273     function addLiquidityETH(
274         address token,
275         uint amountTokenDesired,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
281     function removeLiquidity(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline
289     ) external returns (uint amountA, uint amountB);
290     function removeLiquidityETH(
291         address token,
292         uint liquidity,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline
297     ) external returns (uint amountToken, uint amountETH);
298     function removeLiquidityWithPermit(
299         address tokenA,
300         address tokenB,
301         uint liquidity,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline,
306         bool approveMax, uint8 v, bytes32 r, bytes32 s
307     ) external returns (uint amountA, uint amountB);
308     function removeLiquidityETHWithPermit(
309         address token,
310         uint liquidity,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline,
315         bool approveMax, uint8 v, bytes32 r, bytes32 s
316     ) external returns (uint amountToken, uint amountETH);
317     function swapExactTokensForTokens(
318         uint amountIn,
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external returns (uint[] memory amounts);
324     function swapTokensForExactTokens(
325         uint amountOut,
326         uint amountInMax,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external returns (uint[] memory amounts);
331     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
332         external
333         payable
334         returns (uint[] memory amounts);
335     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
336         external
337         returns (uint[] memory amounts);
338     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
339         external
340         returns (uint[] memory amounts);
341     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
342         external
343         payable
344         returns (uint[] memory amounts);
345 
346     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
347     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
348     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
349     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
350     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
351 }
352 
353 interface IUniswapV2Router02 is IUniswapV2Router01 {
354     function removeLiquidityETHSupportingFeeOnTransferTokens(
355         address token,
356         uint liquidity,
357         uint amountTokenMin,
358         uint amountETHMin,
359         address to,
360         uint deadline
361     ) external returns (uint amountETH);
362     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
363         address token,
364         uint liquidity,
365         uint amountTokenMin,
366         uint amountETHMin,
367         address to,
368         uint deadline,
369         bool approveMax, uint8 v, bytes32 r, bytes32 s
370     ) external returns (uint amountETH);
371 
372     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external;
379     function swapExactETHForTokensSupportingFeeOnTransferTokens(
380         uint amountOutMin,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external payable;
385     function swapExactTokensForETHSupportingFeeOnTransferTokens(
386         uint amountIn,
387         uint amountOutMin,
388         address[] calldata path,
389         address to,
390         uint deadline
391     ) external;
392 }
393 
394 
395 contract Archangel is Context, IERC20, Ownable {
396     using SafeMath for uint256;
397     using Address for address;
398 
399     mapping (address => uint256) private _rOwned;
400     mapping (address => uint256) private _tOwned;
401     mapping (address => mapping (address => uint256)) private _allowances;
402 
403     mapping (address => bool) private _isExcludedFromFee;
404 
405     mapping (address => bool) private _isExcluded;
406     address[] private _excluded;
407    
408     uint256 private constant MAX = ~uint256(0);
409     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
410     uint256 private _rTotal = (MAX - (MAX % _tTotal));
411     uint256 private _tFeeTotal;
412 
413     string private _name = "Archangel";
414     string private _symbol = "Archa";
415     uint8 private _decimals = 9;
416     
417     uint256 public _taxFee = 2;
418     uint256 private _previousTaxFee = _taxFee;
419     
420     uint256 public _liquidityFee = 0;
421     uint256 private _previousLiquidityFee = _liquidityFee;
422     
423     uint256 public _marketingFee = 2;
424     uint256 private _previousMarketingFee = _marketingFee;
425     
426     uint256 public _burnFee = 2;
427     uint256 private _previousBurnFee = _burnFee;
428     
429     address public _marketingWallet;
430     address public _deadAddress;
431 
432     IUniswapV2Router02 public immutable uniswapV2Router;
433     address public immutable uniswapV2Pair;
434     
435     bool inSwapAndLiquify;
436     bool public swapAndLiquifyEnabled = true;
437     
438     uint256 public _maxTxAmount = 3000000000 * 10**6 * 10**9;
439     uint256 private numTokensSellToAddToLiquidity = 3000000000 * 10**6 * 10**9;
440     
441     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
442     event SwapAndLiquifyEnabledUpdated(bool enabled);
443     event SwapAndLiquify(
444         uint256 tokensSwapped,
445         uint256 ethReceived,
446         uint256 tokensIntoLiqudity
447     );
448     
449     modifier lockTheSwap {
450         inSwapAndLiquify = true;
451         _;
452         inSwapAndLiquify = false;
453     }
454     
455     constructor () public {
456         _rOwned[_msgSender()] = _rTotal;
457         
458         _marketingWallet = 0x7b8404be6480C44e25EE8c8446E408b1bfc92451;
459         
460         _deadAddress = 0x000000000000000000000000000000000000dEaD;
461         
462         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
463 
464         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
465             .createPair(address(this), _uniswapV2Router.WETH());
466 
467         uniswapV2Router = _uniswapV2Router;
468         
469         _isExcludedFromFee[owner()] = true;
470         _isExcludedFromFee[address(this)] = true;
471         
472         emit Transfer(address(0), _msgSender(), _tTotal);
473     }
474 
475     function name() public view returns (string memory) {
476         return _name;
477     }
478 
479     function symbol() public view returns (string memory) {
480         return _symbol;
481     }
482 
483     function decimals() public view returns (uint8) {
484         return _decimals;
485     }
486 
487     function totalSupply() public view override returns (uint256) {
488         return _tTotal;
489     }
490 
491     function balanceOf(address account) public view override returns (uint256) {
492         if (_isExcluded[account]) return _tOwned[account];
493         return tokenFromReflection(_rOwned[account]);
494     }
495 
496     function transfer(address recipient, uint256 amount) public override returns (bool) {
497         _transfer(_msgSender(), recipient, amount);
498         return true;
499     }
500 
501     function allowance(address owner, address spender) public view override returns (uint256) {
502         return _allowances[owner][spender];
503     }
504 
505     function approve(address spender, uint256 amount) public override returns (bool) {
506         _approve(_msgSender(), spender, amount);
507         return true;
508     }
509 
510     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
511         _transfer(sender, recipient, amount);
512         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
513         return true;
514     }
515 
516     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
518         return true;
519     }
520 
521     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
522         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
523         return true;
524     }
525 
526     function isExcludedFromReward(address account) public view returns (bool) {
527         return _isExcluded[account];
528     }
529 
530     function totalFees() public view returns (uint256) {
531         return _tFeeTotal;
532     }
533 
534     function deliver(uint256 tAmount) public {
535         address sender = _msgSender();
536         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
537         (uint256 rAmount,,,,,) = _getValues(tAmount);
538         _rOwned[sender] = _rOwned[sender].sub(rAmount);
539         _rTotal = _rTotal.sub(rAmount);
540         _tFeeTotal = _tFeeTotal.add(tAmount);
541     }
542 
543     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
544         require(tAmount <= _tTotal, "Amount must be less than supply");
545         if (!deductTransferFee) {
546             (uint256 rAmount,,,,,) = _getValues(tAmount);
547             return rAmount;
548         } else {
549             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
550             return rTransferAmount;
551         }
552     }
553 
554     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
555         require(rAmount <= _rTotal, "Amount must be less than total reflections");
556         uint256 currentRate =  _getRate();
557         return rAmount.div(currentRate);
558     }
559 
560     function excludeFromReward(address account) public onlyOwner() {
561         
562         require(!_isExcluded[account], "Account is already excluded");
563         if(_rOwned[account] > 0) {
564             _tOwned[account] = tokenFromReflection(_rOwned[account]);
565         }
566         _isExcluded[account] = true;
567         _excluded.push(account);
568     }
569 
570     function includeInReward(address account) external onlyOwner() {
571         require(_isExcluded[account], "Account is already excluded");
572         for (uint256 i = 0; i < _excluded.length; i++) {
573             if (_excluded[i] == account) {
574                 _excluded[i] = _excluded[_excluded.length - 1];
575                 _tOwned[account] = 0;
576                 _isExcluded[account] = false;
577                 _excluded.pop();
578                 break;
579             }
580         }
581     }
582         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
583         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
584         _tOwned[sender] = _tOwned[sender].sub(tAmount);
585         _rOwned[sender] = _rOwned[sender].sub(rAmount);
586         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
587         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
588         _takeLiquidity(tLiquidity);
589         _reflectFee(rFee, tFee);
590         emit Transfer(sender, recipient, tTransferAmount);
591     }
592     
593     function excludeFromFee(address account) public onlyOwner {
594         _isExcludedFromFee[account] = true;
595     }
596     
597     function includeInFee(address account) public onlyOwner {
598         _isExcludedFromFee[account] = false;
599     }
600     
601     function setFees (uint256 taxFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) external onlyOwner {
602         _taxFee = taxFee;
603         _liquidityFee = liquidityFee;
604         _marketingFee = marketingFee;
605         _burnFee = burnFee;
606     }
607    
608     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
609         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
610             10**2
611         );
612     }
613 
614     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
615         swapAndLiquifyEnabled = _enabled;
616         emit SwapAndLiquifyEnabledUpdated(_enabled);
617     }
618     
619     receive() external payable {}
620 
621     function _reflectFee(uint256 rFee, uint256 tFee) private {
622         _rTotal = _rTotal.sub(rFee);
623         _tFeeTotal = _tFeeTotal.add(tFee);
624     }
625 
626     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
627         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
628         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
629         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
630     }
631 
632     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
633         uint256 tFee = calculateTaxFee(tAmount);
634         uint256 tLiquidity = calculateLiquidityFee(tAmount);
635         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
636         return (tTransferAmount, tFee, tLiquidity);
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
647     function _getRate() private view returns(uint256) {
648         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
649         return rSupply.div(tSupply);
650     }
651 
652     function _getCurrentSupply() private view returns(uint256, uint256) {
653         uint256 rSupply = _rTotal;
654         uint256 tSupply = _tTotal;      
655         for (uint256 i = 0; i < _excluded.length; i++) {
656             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
657             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
658             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
659         }
660         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
661         return (rSupply, tSupply);
662     }
663     
664     function _takeLiquidity(uint256 tLiquidity) private {
665         uint256 currentRate =  _getRate();
666         uint256 rLiquidity = tLiquidity.mul(currentRate);
667         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
668         if(_isExcluded[address(this)])
669             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
670     }
671     
672     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
673         return _amount.mul(_taxFee).div(
674             10**2
675         );
676     }
677 
678     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
679         return _amount.mul(_liquidityFee).div(
680             10**2
681         );
682     }
683     
684     function removeAllFee() private {
685         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0 && _burnFee == 0) return;
686         
687         _previousTaxFee = _taxFee;
688         _previousLiquidityFee = _liquidityFee;
689         _previousMarketingFee =_marketingFee;
690         _previousBurnFee = _burnFee;
691         
692         _taxFee = 0;
693         _liquidityFee = 0;
694         _marketingFee = 0;
695         _burnFee = 0;
696     }
697     
698     function restoreAllFee() private {
699         _taxFee = _previousTaxFee;
700         _liquidityFee = _previousLiquidityFee;
701         _marketingFee = _previousMarketingFee;
702         _burnFee = _previousBurnFee;
703         
704     }
705     
706     function isExcludedFromFee(address account) public view returns(bool) {
707         return _isExcludedFromFee[account];
708     }
709 
710     function _approve(address owner, address spender, uint256 amount) private {
711         require(owner != address(0), "ERC20: approve from the zero address");
712         require(spender != address(0), "ERC20: approve to the zero address");
713 
714         _allowances[owner][spender] = amount;
715         emit Approval(owner, spender, amount);
716     }
717 
718     function _transfer(
719         address from,
720         address to,
721         uint256 amount
722     ) private {
723         require(from != address(0), "ERC20: transfer from the zero address");
724         require(to != address(0), "ERC20: transfer to the zero address");
725         require(amount > 0, "Transfer amount must be greater than zero");
726         if(from != owner() && to != owner())
727             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
728 
729         uint256 contractTokenBalance = balanceOf(address(this));
730         uint256 marketingFee = amount * _marketingFee / 100;
731         uint256 burnFee = amount * _burnFee / 100;
732         
733         if(contractTokenBalance >= _maxTxAmount)
734         {
735             contractTokenBalance = _maxTxAmount;
736         }
737         
738         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
739         if (
740             overMinTokenBalance &&
741             !inSwapAndLiquify &&
742             from != uniswapV2Pair &&
743             swapAndLiquifyEnabled
744         ) {
745             contractTokenBalance = numTokensSellToAddToLiquidity;
746 
747             swapAndLiquify(contractTokenBalance);
748         }
749         
750         bool takeFee = true;
751         
752         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
753             takeFee = false;
754         }
755         
756         _tokenTransfer(from, _marketingWallet, marketingFee, takeFee);
757         
758         _tokenTransfer(from, _deadAddress, burnFee, takeFee);
759         
760         _tokenTransfer(from,to,amount .sub(marketingFee) .sub(burnFee),takeFee);
761 
762     }
763 
764     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
765 
766         uint256 half = contractTokenBalance.div(2);
767         uint256 otherHalf = contractTokenBalance.sub(half);
768 
769         uint256 initialBalance = address(this).balance;
770 
771         swapTokensForEth(half);
772 
773         uint256 newBalance = address(this).balance.sub(initialBalance);
774 
775         addLiquidity(otherHalf, newBalance);
776         
777         emit SwapAndLiquify(half, newBalance, otherHalf);
778     }
779 
780     function swapTokensForEth(uint256 tokenAmount) private {
781 
782         address[] memory path = new address[](2);
783         path[0] = address(this);
784         path[1] = uniswapV2Router.WETH();
785 
786         _approve(address(this), address(uniswapV2Router), tokenAmount);
787 
788         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
789             tokenAmount,
790             0, 
791             path,
792             address(this),
793             block.timestamp
794         );
795     }
796 
797     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
798 
799         _approve(address(this), address(uniswapV2Router), tokenAmount);
800 
801         uniswapV2Router.addLiquidityETH{value: ethAmount}(
802             address(this),
803             tokenAmount,
804             0, 
805             0, 
806             owner(),
807             block.timestamp
808         );
809     }
810 
811     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
812         if(!takeFee)
813             removeAllFee();
814         
815         if (_isExcluded[sender] && !_isExcluded[recipient]) {
816             _transferFromExcluded(sender, recipient, amount);
817         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
818             _transferToExcluded(sender, recipient, amount);
819         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
820             _transferStandard(sender, recipient, amount);
821         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
822             _transferBothExcluded(sender, recipient, amount);
823         } else {
824             _transferStandard(sender, recipient, amount);
825         }
826         
827         if(!takeFee)
828             restoreAllFee();
829     }
830 
831     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
832         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
833         _rOwned[sender] = _rOwned[sender].sub(rAmount);
834         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
835         _takeLiquidity(tLiquidity);
836         _reflectFee(rFee, tFee);
837         emit Transfer(sender, recipient, tTransferAmount);
838     }
839 
840     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
841         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
842         _rOwned[sender] = _rOwned[sender].sub(rAmount);
843         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
844         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
845         _takeLiquidity(tLiquidity);
846         _reflectFee(rFee, tFee);
847         emit Transfer(sender, recipient, tTransferAmount);
848     }
849 
850     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
851         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
852         _tOwned[sender] = _tOwned[sender].sub(tAmount);
853         _rOwned[sender] = _rOwned[sender].sub(rAmount);
854         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
855         _takeLiquidity(tLiquidity);
856         _reflectFee(rFee, tFee);
857         emit Transfer(sender, recipient, tTransferAmount);
858     }
859 
860 }