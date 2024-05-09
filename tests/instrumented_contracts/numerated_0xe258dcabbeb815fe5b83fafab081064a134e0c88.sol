1 pragma solidity ^0.8.1;
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
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49 
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60 
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         return mod(a, b, "SafeMath: modulo by zero");
66     }
67 
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this;
81         return msg.data;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         bytes32 codehash;
89         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
90         assembly { codehash := extcodehash(account) }
91         return (codehash != accountHash && codehash != 0x0);
92     }
93 
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103         return functionCall(target, data, "Address: low-level call failed");
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
126             if (returndata.length > 0) {
127 
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141     address private _previousOwner;
142     uint256 private _lockTime;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     constructor () {
147         address msgSender = _msgSender();
148         _owner = msgSender;
149         emit OwnershipTransferred(address(0), msgSender);
150     }
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }
155 
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     function renounceOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 
172     function geUnlockTime() public view returns (uint256) {
173         return _lockTime;
174     }
175 
176     function lock(uint256 time) public virtual onlyOwner {
177         _previousOwner = _owner;
178         _owner = address(0);
179         _lockTime = block.timestamp + time;
180         emit OwnershipTransferred(_owner, address(0));
181     }
182     
183     function unlock() public virtual {
184         require(_previousOwner == msg.sender, "You don't have permission to unlock");
185         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
186         emit OwnershipTransferred(_owner, _previousOwner);
187         _owner = _previousOwner;
188     }
189 }
190 
191 // pragma solidity >=0.5.0;
192 
193 interface IUniswapV2Factory {
194     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
195 
196     function feeTo() external view returns (address);
197     function feeToSetter() external view returns (address);
198 
199     function getPair(address tokenA, address tokenB) external view returns (address pair);
200     function allPairs(uint) external view returns (address pair);
201     function allPairsLength() external view returns (uint);
202 
203     function createPair(address tokenA, address tokenB) external returns (address pair);
204 
205     function setFeeTo(address) external;
206     function setFeeToSetter(address) external;
207 }
208 
209 
210 // pragma solidity >=0.5.0;
211 
212 interface IUniswapV2Pair {
213     event Approval(address indexed owner, address indexed spender, uint value);
214     event Transfer(address indexed from, address indexed to, uint value);
215 
216     function name() external pure returns (string memory);
217     function symbol() external pure returns (string memory);
218     function decimals() external pure returns (uint8);
219     function totalSupply() external view returns (uint);
220     function balanceOf(address owner) external view returns (uint);
221     function allowance(address owner, address spender) external view returns (uint);
222 
223     function approve(address spender, uint value) external returns (bool);
224     function transfer(address to, uint value) external returns (bool);
225     function transferFrom(address from, address to, uint value) external returns (bool);
226 
227     function DOMAIN_SEPARATOR() external view returns (bytes32);
228     function PERMIT_TYPEHASH() external pure returns (bytes32);
229     function nonces(address owner) external view returns (uint);
230 
231     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
232 
233     event Mint(address indexed sender, uint amount0, uint amount1);
234     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
235     event Swap(
236         address indexed sender,
237         uint amount0In,
238         uint amount1In,
239         uint amount0Out,
240         uint amount1Out,
241         address indexed to
242     );
243     event Sync(uint112 reserve0, uint112 reserve1);
244 
245     function MINIMUM_LIQUIDITY() external pure returns (uint);
246     function factory() external view returns (address);
247     function token0() external view returns (address);
248     function token1() external view returns (address);
249     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
250     function price0CumulativeLast() external view returns (uint);
251     function price1CumulativeLast() external view returns (uint);
252     function kLast() external view returns (uint);
253 
254     function mint(address to) external returns (uint liquidity);
255     function burn(address to) external returns (uint amount0, uint amount1);
256     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
257     function skim(address to) external;
258     function sync() external;
259 
260     function initialize(address, address) external;
261 }
262 
263 // pragma solidity >=0.6.2;
264 
265 interface IUniswapV2Router01 {
266     function factory() external pure returns (address);
267     function WETH() external pure returns (address);
268 
269     function addLiquidity(
270         address tokenA,
271         address tokenB,
272         uint amountADesired,
273         uint amountBDesired,
274         uint amountAMin,
275         uint amountBMin,
276         address to,
277         uint deadline
278     ) external returns (uint amountA, uint amountB, uint liquidity);
279     function addLiquidityETH(
280         address token,
281         uint amountTokenDesired,
282         uint amountTokenMin,
283         uint amountETHMin,
284         address to,
285         uint deadline
286     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
287     function removeLiquidity(
288         address tokenA,
289         address tokenB,
290         uint liquidity,
291         uint amountAMin,
292         uint amountBMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountA, uint amountB);
296     function removeLiquidityETH(
297         address token,
298         uint liquidity,
299         uint amountTokenMin,
300         uint amountETHMin,
301         address to,
302         uint deadline
303     ) external returns (uint amountToken, uint amountETH);
304     function removeLiquidityWithPermit(
305         address tokenA,
306         address tokenB,
307         uint liquidity,
308         uint amountAMin,
309         uint amountBMin,
310         address to,
311         uint deadline,
312         bool approveMax, uint8 v, bytes32 r, bytes32 s
313     ) external returns (uint amountA, uint amountB);
314     function removeLiquidityETHWithPermit(
315         address token,
316         uint liquidity,
317         uint amountTokenMin,
318         uint amountETHMin,
319         address to,
320         uint deadline,
321         bool approveMax, uint8 v, bytes32 r, bytes32 s
322     ) external returns (uint amountToken, uint amountETH);
323     function swapExactTokensForTokens(
324         uint amountIn,
325         uint amountOutMin,
326         address[] calldata path,
327         address to,
328         uint deadline
329     ) external returns (uint[] memory amounts);
330     function swapTokensForExactTokens(
331         uint amountOut,
332         uint amountInMax,
333         address[] calldata path,
334         address to,
335         uint deadline
336     ) external returns (uint[] memory amounts);
337     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
338     external
339     payable
340     returns (uint[] memory amounts);
341     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
342     external
343     returns (uint[] memory amounts);
344     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
345     external
346     returns (uint[] memory amounts);
347     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
348     external
349     payable
350     returns (uint[] memory amounts);
351 
352     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
353     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
354     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
355     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
356     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
357 }
358 
359 
360 
361 // pragma solidity >=0.6.2;
362 
363 interface IUniswapV2Router02 is IUniswapV2Router01 {
364     function removeLiquidityETHSupportingFeeOnTransferTokens(
365         address token,
366         uint liquidity,
367         uint amountTokenMin,
368         uint amountETHMin,
369         address to,
370         uint deadline
371     ) external returns (uint amountETH);
372     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
373         address token,
374         uint liquidity,
375         uint amountTokenMin,
376         uint amountETHMin,
377         address to,
378         uint deadline,
379         bool approveMax, uint8 v, bytes32 r, bytes32 s
380     ) external returns (uint amountETH);
381 
382     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
383         uint amountIn,
384         uint amountOutMin,
385         address[] calldata path,
386         address to,
387         uint deadline
388     ) external;
389     function swapExactETHForTokensSupportingFeeOnTransferTokens(
390         uint amountOutMin,
391         address[] calldata path,
392         address to,
393         uint deadline
394     ) external payable;
395     function swapExactTokensForETHSupportingFeeOnTransferTokens(
396         uint amountIn,
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external;
402 }
403 
404 contract KAMIKAZEROCKET is Context, IERC20, Ownable {
405     using SafeMath for uint256;
406     using Address for address;
407     address deadAddress = 0x000000000000000000000000000000000000dEaD;
408 
409     string private _name = "KamiKazeRocket";
410     string private _symbol = "KamiKaze";
411     uint8 private _decimals = 9;    
412     uint256 private initialsupply = 1_000_000_000;
413     uint256 private _tTotal = initialsupply * 10 ** _decimals;
414     address payable private _marketingWallet;
415     
416     mapping (address => uint256) private _rOwned;
417     mapping (address => uint256) private _tOwned;
418     mapping(address => uint256) private buycooldown;
419     mapping(address => uint256) private sellcooldown;
420     mapping (address => mapping (address => uint256)) private _allowances;
421     mapping (address => bool) private _isExcludedFromFee;
422     mapping (address => bool) private _isExcluded;
423     mapping (address => bool) private _isBlacklisted;
424     address[] private _excluded;
425 
426     bool private cooldownEnabled = true;
427     uint256 public cooldown = 30 seconds;
428     uint256 public cooldownLimit = 60 seconds;
429     
430     uint256 private constant MAX = ~uint256(0);
431     uint256 private _rTotal = (MAX - (MAX % _tTotal));
432     uint256 private _tFeeTotal;
433     uint256 public _taxFee = 0;
434     uint256 private _previousTaxFee = _taxFee;
435     uint256 public _liquidityFee = 2;
436     uint256 private _previousLiquidityFee = _liquidityFee;
437     uint256 public _marketingFee = 9;
438     uint256 private _previousMarketingFee = _marketingFee;
439     uint256 public _buyTaxFee = 0;
440     uint256 private _previousBuyTaxFee = _buyTaxFee;    
441     uint256 public _buyLiquidityFee = 2;
442     uint256 private _previousBuyLiquidityFee = _buyLiquidityFee;
443     uint256 public _buyMarketingFee = 9;
444     uint256 private _previousBuyMarketingFee = _buyMarketingFee;
445 
446     uint256 private maxBuyPercent = 1;
447     uint256 private maxBuyDivisor = 100;
448     uint256 public _maxBuyAmount = (_tTotal * maxBuyPercent) / maxBuyDivisor;
449    
450     IUniswapV2Router02 public immutable uniswapV2Router;
451     address public immutable uniswapV2Pair;
452     bool inSwapAndLiquify;
453     bool private swapAndLiquifyEnabled = true;
454     
455     uint256 private numTokensSellToAddToLiquidity = _tTotal.mul(1).div(100);
456     
457     event ToMarketing(uint256 ETHSent);
458     event SwapAndLiquifyEnabledUpdated(bool enabled);
459     event SwapAndLiquify(
460         uint256 tokensSwapped,
461         uint256 ethReceived,
462         uint256 tokensIntoLiqudity
463     );
464     
465     modifier lockTheSwap {
466         inSwapAndLiquify = true;
467         _;
468         inSwapAndLiquify = false;
469     }
470 
471     constructor (address marketingWallet) {
472         _rOwned[_msgSender()] = _rTotal;
473          _marketingWallet = payable(marketingWallet);
474         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
475         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
476         .createPair(address(this), _uniswapV2Router.WETH());
477         uniswapV2Router = _uniswapV2Router;
478         _isExcludedFromFee[owner()] = true;
479         _isExcludedFromFee[address(this)] = true;
480         _isExcludedFromFee[_marketingWallet] = true;
481         emit Transfer(address(0), _msgSender(), _tTotal);
482     }
483 
484     function name() public view returns (string memory) {return _name;}
485     function symbol() public view returns (string memory) {return _symbol;}
486     function decimals() public view returns (uint8) {return _decimals;}
487     function totalSupply() public view override returns (uint256) {return _tTotal;}
488     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
489     function balanceOf(address account) public view override returns (uint256) {
490         if (_isExcluded[account]) return _tOwned[account];
491         return tokenFromReflection(_rOwned[account]);
492     }
493     function approve(address spender, uint256 amount) public override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     function setNumTokensSellToAddToLiquidity(uint256 percent, uint256 divisor) external onlyOwner() {
499         uint256 swapAmount = _tTotal.mul(percent).div(divisor);
500         numTokensSellToAddToLiquidity = swapAmount;
501     }
502         
503     function setSellFee(uint256 liquidityFee, uint256 marketingFee) external onlyOwner() {
504         _liquidityFee = liquidityFee;
505         _marketingFee = marketingFee;
506     }    
507     
508     function setBuyFee(uint256 marketingFee, uint256 liquidityFee) external onlyOwner() {
509         _buyMarketingFee = marketingFee;
510         _buyLiquidityFee = liquidityFee;
511     }    
512     
513     function setCooldown(uint256 amount) external onlyOwner() {
514         require(amount <= cooldownLimit);
515         cooldown = amount;
516     }
517     
518     function setMaxBuyPercent(uint256 percent, uint divisor) external onlyOwner {
519         require(percent >= 1 && divisor <= 1000); // cannot set lower than .1%
520         uint256 new_tx = _tTotal.mul(percent).div(divisor);
521         _maxBuyAmount = new_tx;
522     }
523 
524     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
526         return true;
527     }
528 
529     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
531         return true;
532     }
533     
534     function setBlacklistStatus(address account, bool Blacklisted) external onlyOwner {
535     		if (Blacklisted = true) {
536                 _isBlacklisted[account] = true; 
537     		} else if(Blacklisted = false) {
538                 _isBlacklisted[account] = false;
539                 }
540     }
541     
542     function deliver(uint256 tAmount) public {
543         address sender = _msgSender();
544         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
545         (uint256 rAmount,,,,,,) = _getValues(tAmount);
546         _rOwned[sender] = _rOwned[sender].sub(rAmount);
547         _rTotal = _rTotal.sub(rAmount);
548         _tFeeTotal = _tFeeTotal.add(tAmount);
549     }
550 
551     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
552         require(tAmount <= _tTotal, "Amount must be less than supply");
553         if (!deductTransferFee) {
554             (uint256 rAmount,,,,,,) = _getValues(tAmount);
555             return rAmount;
556         } else {
557             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
558             return rTransferAmount;
559         }
560     }
561 
562     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
563         require(rAmount <= _rTotal, "Amount must be less than total reflections");
564         uint256 currentRate =  _getRate();
565         return rAmount.div(currentRate);
566     }
567 
568     function isExcludedFromReward(address account) public view returns (bool) {
569         return _isExcluded[account];
570     }
571 
572     function excludeFromReward(address account) public onlyOwner() {
573         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
574         require(!_isExcluded[account], "Account is already excluded");
575         if(_rOwned[account] > 0) {
576             _tOwned[account] = tokenFromReflection(_rOwned[account]);
577         }
578         _isExcluded[account] = true;
579         _excluded.push(account);
580     }
581 
582     function includeInReward(address account) external onlyOwner() {
583         require(_isExcluded[account], "Account is already excluded");
584         for (uint256 i = 0; i < _excluded.length; i++) {
585             if (_excluded[i] == account) {
586                 _excluded[i] = _excluded[_excluded.length - 1];
587                 _tOwned[account] = 0;
588                 _isExcluded[account] = false;
589                 _excluded.pop();
590                 break;
591             }
592         }
593     }
594 
595     function excludeFromFee(address account) public onlyOwner {
596         _isExcludedFromFee[account] = true;
597     }
598 
599     function includeInFee(address account) public onlyOwner {
600         _isExcludedFromFee[account] = false;
601     }
602     
603     function isExcludedFromFee(address account) public view returns(bool) {
604         return _isExcludedFromFee[account];
605     }
606     
607     function isBlacklisted(address account) public view returns(bool) {
608         return _isBlacklisted[account];
609     }
610 
611     function totalFees() public view returns (uint256) {
612         return _tFeeTotal;
613     }
614 
615     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
616         swapAndLiquifyEnabled = _enabled;
617         emit SwapAndLiquifyEnabledUpdated(_enabled);
618     }
619 
620     //to receive ETH from uniswapV2Router when swapping
621     receive() external payable {}
622 
623     function _reflectFee(uint256 rFee, uint256 tFee) private {
624         _rTotal = _rTotal.sub(rFee);
625         _tFeeTotal = _tFeeTotal.add(tFee);
626     }
627 
628     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
629         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing, uint256 tLiquidity) = _getTValues(tAmount);
630         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, tLiquidity, _getRate());
631         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing, tLiquidity);
632     }
633 
634     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
635         uint256 tFee = tAmount.mul(_taxFee).div(100);
636         uint256 tMarketing = tAmount.mul(_marketingFee).div(100);
637         uint256 tLiquidity = tAmount.mul(_liquidityFee).div(100);
638         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing).sub(tLiquidity);
639         return (tTransferAmount, tFee, tMarketing, tLiquidity);
640     }
641 
642     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
643         uint256 rAmount = tAmount.mul(currentRate);
644         uint256 rFee = tFee.mul(currentRate);
645         uint256 rMarketing = tMarketing.mul(currentRate);
646         uint256 rLiquidity = tLiquidity.mul(currentRate);
647         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing);
648         return (rAmount, rTransferAmount, rFee);
649     }
650 
651     function _getValuesBuy(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
652         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValuesBuy(tAmount);
653         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValuesBuy(tAmount, tFee, tLiquidity, tMarketing, _getRate());
654         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
655     }
656 
657     function _getTValuesBuy(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
658         uint256 tFee = tAmount.mul(_buyTaxFee).div(100);
659         uint256 tLiquidity = tAmount.mul(_buyLiquidityFee).div(100);
660         uint256 tMarketing = tAmount.mul(_buyMarketingFee).div(100);
661         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tMarketing);
662         return (tTransferAmount, tFee, tMarketing, tLiquidity);
663     }
664 
665     function _getRValuesBuy(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
666         uint256 rAmount = tAmount.mul(currentRate);
667         uint256 rFee = tFee.mul(currentRate);
668         uint256 rLiquidity = tLiquidity.mul(currentRate);
669         uint256 rMarketing = tMarketing.mul(currentRate);
670         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing);
671         return (rAmount, rTransferAmount, rFee);
672     }
673 
674     function _getRate() private view returns(uint256) {
675         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
676         return rSupply.div(tSupply);
677     }
678 
679     function _getCurrentSupply() private view returns(uint256, uint256) {
680         uint256 rSupply = _rTotal;
681         uint256 tSupply = _tTotal;
682         for (uint256 i = 0; i < _excluded.length; i++) {
683             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
684             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
685             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
686         }
687         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
688         return (rSupply, tSupply);
689     }
690 
691     function _takeLiquidity(uint256 tLiquidity) private {
692         uint256 currentRate =  _getRate();
693         uint256 rLiquidity = tLiquidity.mul(currentRate);
694         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
695         if(_isExcluded[address(this)])
696             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
697     }    
698     
699     function _takeMarketing(uint256 tMarketing) private {
700         uint256 currentRate =  _getRate();
701         uint256 rMarketing = tMarketing.mul(currentRate);
702         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
703         if(_isExcluded[address(this)])
704             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
705     }
706 
707     function removeAllFee() private {
708         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0 && _buyMarketingFee == 0 && _buyTaxFee == 0 && _buyLiquidityFee == 0) return;
709         _previousTaxFee = _taxFee;
710         _previousMarketingFee = _marketingFee;
711         _previousLiquidityFee = _liquidityFee;
712         _previousBuyTaxFee = _buyTaxFee;
713         _previousBuyMarketingFee = _buyMarketingFee;
714         _previousBuyLiquidityFee = _buyLiquidityFee;
715         _buyTaxFee = 0;
716         _buyMarketingFee = 0;
717         _buyLiquidityFee = 0;
718         _taxFee = 0;
719         _marketingFee = 0;
720         _liquidityFee = 0;
721     }
722 
723     function restoreAllFee() private {
724         _taxFee = _previousTaxFee;
725         _marketingFee = _previousMarketingFee;
726         _liquidityFee = _previousLiquidityFee;
727         _buyLiquidityFee = _previousBuyLiquidityFee;
728         _buyMarketingFee = _previousBuyMarketingFee;
729         _buyTaxFee = _previousBuyTaxFee;
730     }
731 
732     function _approve(address owner, address spender, uint256 amount) private {
733         require(owner != address(0), "ERC20: approve from the zero address");
734         require(spender != address(0), "ERC20: approve to the zero address");
735 
736         _allowances[owner][spender] = amount;
737         emit Approval(owner, spender, amount);
738     }
739 
740     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
741         uint256 marketingTokenBalance = contractTokenBalance.mul(85).div(100);
742         uint256 liquidityTokenBalance = contractTokenBalance.sub(marketingTokenBalance);
743         uint256 tokenBalanceToLiquifyAsETH = liquidityTokenBalance.div(2);
744         uint256 tokenBalanceToLiquify = liquidityTokenBalance.sub(tokenBalanceToLiquifyAsETH);
745         uint256 initialBalance = address(this).balance;
746         uint256 tokensToSwapToETH = tokenBalanceToLiquifyAsETH.add(marketingTokenBalance);
747         swapTokensForEth(tokensToSwapToETH);
748         uint256 ETHSwapped = address(this).balance.sub(initialBalance);
749         uint256 ETHToLiquify = ETHSwapped.mul(10).div(100);
750         addLiquidity(tokenBalanceToLiquify, ETHToLiquify);
751         emit SwapAndLiquify(tokenBalanceToLiquifyAsETH, ETHToLiquify, tokenBalanceToLiquify);
752         uint256 marketingETH = ETHSwapped.sub(ETHToLiquify);
753         _marketingWallet.transfer(marketingETH);
754         emit ToMarketing(marketingETH);
755     }
756 
757     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
758         require(amountPercentage <= 100);
759         uint256 amountETH = address(this).balance;
760         payable(_marketingWallet).transfer(amountETH.mul(amountPercentage).div(100));
761     }
762 
763     function clearStuckToken(address to) external onlyOwner {
764         uint256 _balance = balanceOf(address(this));
765         _transfer(address(this), to, _balance);
766     }
767 
768     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent){
769         require(_token != address(0));
770         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
771         _sent = IERC20(_token).transfer(_to, _contractBalance);
772     }
773 
774     function swapTokensForEth(uint256 tokenAmount) private {
775         // generate the uniswap pair path of token -> weth
776         address[] memory path = new address[](2);
777         path[0] = address(this);
778         path[1] = uniswapV2Router.WETH();
779 
780         _approve(address(this), address(uniswapV2Router), tokenAmount);
781 
782         // make the swap
783         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
784             tokenAmount,
785             0, // accept any amount of ETH
786             path,
787             address(this),
788             block.timestamp
789         );
790     }
791 
792     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
793         // approve token transfer to cover all possible scenarios
794         _approve(address(this), address(uniswapV2Router), tokenAmount);
795 
796         // add the liquidity
797         uniswapV2Router.addLiquidityETH{value: ethAmount}(
798             address(this),
799             tokenAmount,
800             0, // slippage is unavoidable
801             0, // slippage is unavoidable
802             owner(),
803             block.timestamp
804         );
805     }
806     
807     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
810         return true;
811     }
812 
813     function _transfer(
814         address from,
815         address to,
816         uint256 amount
817     ) private {
818         require(from != address(0), "ERC20: transfer from the zero address");
819         require(to != address(0), "ERC20: transfer to the zero address");
820         require(amount > 0, "Transfer amount must be greater than zero");
821         require(_isBlacklisted[from] == false, "Hehe");
822         require(_isBlacklisted[to] == false, "Hehe");
823         if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
824                 require(amount <= _maxBuyAmount);
825                 require(buycooldown[to] < block.timestamp);
826                 buycooldown[to] = block.timestamp.add(cooldown);        
827             } else if(from != uniswapV2Pair && cooldownEnabled && !_isExcludedFromFee[to]) {
828             require(sellcooldown[from] <= block.timestamp);
829             sellcooldown[from] = block.timestamp.add(cooldown);
830         }
831             
832         uint256 contractTokenBalance = balanceOf(address(this));
833 
834         if(contractTokenBalance >= numTokensSellToAddToLiquidity)
835         {
836             contractTokenBalance = numTokensSellToAddToLiquidity;
837         }
838 
839         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
840         if (
841             overMinTokenBalance &&
842             !inSwapAndLiquify &&
843             from != uniswapV2Pair &&
844             swapAndLiquifyEnabled            
845         ) {
846             contractTokenBalance = numTokensSellToAddToLiquidity;
847             swapAndLiquify(contractTokenBalance);
848         }
849 
850         //indicates if fee should be deducted from transfer
851         bool takeFee = true;
852 
853         //if any account belongs to _isExcludedFromFee account then remove the fee
854         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
855             takeFee = false;
856         }
857 
858         //transfer amount, it will take tax, marketing, liquidity fee
859         _tokenTransfer(from,to,amount,takeFee);
860     }
861 
862     function transfer(address recipient, uint256 amount) public override returns (bool) {
863         _transfer(_msgSender(), recipient, amount);
864         return true;
865     }
866 
867     //this method is responsible for taking all fee, if takeFee is true
868     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
869         if(!takeFee)
870             removeAllFee();
871 
872         if (sender == uniswapV2Pair && recipient != address(uniswapV2Router)) {
873             _transferStandardBuy(sender, recipient, amount);
874         } else if (_isExcluded[sender] && !_isExcluded[recipient]) {
875             _transferFromExcluded(sender, recipient, amount);
876         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
877             _transferToExcluded(sender, recipient, amount);
878         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
879             _transferStandard(sender, recipient, amount);
880         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
881             _transferBothExcluded(sender, recipient, amount);
882         } else {
883             _transferStandard(sender, recipient, amount);
884         }
885 
886         if(!takeFee)
887             restoreAllFee();
888     }
889 
890     function _transferStandardBuy(address sender, address recipient, uint256 tAmount) private {
891         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing, uint256 tLiquidity) = _getValuesBuy(tAmount);
892         _rOwned[sender] = _rOwned[sender].sub(rAmount);
893         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
894         _takeLiquidity(tLiquidity);
895         _takeMarketing(tMarketing);
896         _reflectFee(rFee, tFee);
897         emit Transfer(sender, recipient, tTransferAmount); 
898     }
899 
900     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
901         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
902         _rOwned[sender] = _rOwned[sender].sub(rAmount);
903         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
904         _takeLiquidity(tLiquidity);        
905         _takeMarketing(tMarketing);
906         _reflectFee(rFee, tFee);
907         emit Transfer(sender, recipient, tTransferAmount);
908     }
909 
910     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
911         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
912         _rOwned[sender] = _rOwned[sender].sub(rAmount);
913         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
914         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
915         _takeLiquidity(tLiquidity);        
916         _takeMarketing(tMarketing);
917         _reflectFee(rFee, tFee);
918         emit Transfer(sender, recipient, tTransferAmount);
919     }
920 
921     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
922         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
923         _tOwned[sender] = _tOwned[sender].sub(tAmount);
924         _rOwned[sender] = _rOwned[sender].sub(rAmount);
925         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
926         _takeLiquidity(tLiquidity);       
927         _takeMarketing(tMarketing);
928         _reflectFee(rFee, tFee);
929         emit Transfer(sender, recipient, tTransferAmount);
930     }
931     
932     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
933         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
934         _tOwned[sender] = _tOwned[sender].sub(tAmount);
935         _rOwned[sender] = _rOwned[sender].sub(rAmount);
936         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
937         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
938         _takeLiquidity(tLiquidity);        
939         _takeMarketing(tMarketing);
940         _reflectFee(rFee, tFee);
941         emit Transfer(sender, recipient, tTransferAmount);
942     }
943 
944     function cooldownStatus() public view returns (bool) {
945         return cooldownEnabled;
946     }
947     
948     function setCooldownEnabled(bool onoff) external onlyOwner() {
949         cooldownEnabled = onoff;
950     }
951 }