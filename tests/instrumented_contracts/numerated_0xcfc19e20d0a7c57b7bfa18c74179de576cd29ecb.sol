1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.17 <0.9.0;
3 abstract contract Context {
4     function _msgSender() internal view returns (address payable) {
5         return payable(msg.sender);
6     }
7     function _msgData() internal view returns (bytes memory) {
8         this; 
9         return msg.data; 
10     }
11 }
12 
13 interface IUniswapV2Factory {
14     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
15     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
16     function createPair(address tokenA, address tokenB) external returns (address lpPair);
17 }
18 
19 interface IUniswapV2Router01 {
20     function factory() external pure returns (address);
21     function WETH() external pure returns (address);
22     function addLiquidityETH(
23         address token,
24         uint amountTokenDesired,
25         uint amountTokenMin,
26         uint amountETHMin,
27         address to,
28         uint deadline
29     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
30 } 
31 
32 library Address {
33     function isContract(address account) internal view returns (bool) {
34         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
35         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
36         // for accounts without code, i.e. `keccak256('')`
37         bytes32 codehash;
38         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
39         // solhint-disable-next-line no-inline-assembly
40         assembly { codehash := extcodehash(account) }
41         return (codehash != accountHash && codehash != 0x0);
42     }
43 
44     function sendValue(address payable recipient, uint256 amount) internal {
45         require(address(this).balance >= amount, "Address: insufficient balance");
46 
47         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
48         (bool success, ) = recipient.call{ value: amount }("");
49         require(success, "Address: unable to send value, recipient may have reverted");
50     }
51 
52     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
53         return functionCall(target, data, "Address: low-level call failed");
54     }
55 
56     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
57         return _functionCallWithValue(target, data, 0, errorMessage);
58     }
59 
60 
61     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
62         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
63     }
64 
65     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
66         require(address(this).balance >= value, "Address: insufficient balance for call");
67         return _functionCallWithValue(target, data, value, errorMessage);
68     }
69 
70     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
71         require(isContract(target), "Address: call to non-contract");
72 
73         // solhint-disable-next-line avoid-low-level-calls
74         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
75         if (success) {
76             return returndata;
77         } else {
78             // Look for revert reason and bubble it up if present
79             if (returndata.length > 0) {
80                 // The easiest way to bubble the revert reason is using memory via assembly
81 
82                 // solhint-disable-next-line no-inline-assembly
83                 assembly {
84                     let returndata_size := mload(returndata)
85                     revert(add(32, returndata), returndata_size)
86                 }
87             } else {
88                 revert(errorMessage);
89             }
90         }
91     }
92 }
93 
94 interface IERC20Upgradeable {
95 
96     function totalSupply() external view returns (uint256);
97     function balanceOf(address account) external view returns (uint256);
98     function transfer(address recipient, uint256 amount) external returns (bool);
99     function allowance(address owner, address spender) external view returns (uint256);
100     function approve(address spender, uint256 amount) external returns (bool);
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 interface IUniswapV2Router02 is IUniswapV2Router01 {
112     function removeLiquidityETHSupportingFeeOnTransferTokens(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external returns (uint amountETH);
120     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountETH);
129 
130     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 contract Muni is Context, IERC20Upgradeable {
153     address private _owner; // address of the contract owner.
154     mapping (address => uint256) private _rOwned; 
155     mapping (address => uint256) private _tOwned; 
156     mapping (address => bool) lpPairs;
157     uint256 private LiquidityPairCount = 0; 
158     mapping (address => mapping (address => uint256)) private _allowed; 
159     mapping (address => bool) private _ExcludedFromFee; 
160     mapping (address => bool) private _iExcempt;
161     mapping(address => bool) private InJail;
162     address[] private _excluded;
163     mapping (address => bool) private _liqProv;
164     uint256 private startSupply; 
165     string private _name; 
166     string private _symbol; 
167     uint256 public _redistro = 0; 
168     uint256 public _liq = 0; 
169     uint256 public _market = 1000; 
170     uint256 public _buydistro = _redistro; 
171     uint256 public _buyliq = _liq; 
172     uint256 public _buyMarket = _market;
173     uint256 public _sellLiq = 0; 
174     uint256 public _selldistro = 0; 
175     uint256 public _sellMarket = 1000; 
176     uint256 public _transferRedistro = 0; 
177     uint256 public _transferLiq = 0; 
178     uint256 public _transferMarket = 0; 
179     uint256 private maxRedistro = 1000; 
180     uint256 private maxLiq = 1000; 
181     uint256 private maxMarket = 4000; 
182     uint256 public _liquidityRatio = 0;
183     uint256 public _marketRatio = 1000;
184     uint256 private masterTaxDivisor = 10000;
185     uint256 private MarketStake = 40;
186     uint256 private DevStake = 10;
187     uint256 private ValueDivisor = 50;
188     uint256 private constant MAX = ~uint256(0);
189     uint8 private _decimals;
190     uint256 private _decimalsMul;
191     uint256 private _tTotal;
192     uint256 private _rTotal;
193     uint256 private _tFeeTotal;
194 
195     IUniswapV2Router02 public dexRouter; 
196     address public lpPair; 
197     address public _routerAddress; 
198     address public DEAD = 0x000000000000000000000000000000000000dEaD; 
199     address public ZERO = 0x0000000000000000000000000000000000000000; 
200     address payable private _MuniDev; 
201     address payable private _marketWallet; 
202     bool inSwapAndLiquify; 
203     bool public swapAndLiquifyEnabled = false; 
204     uint256 private _maxTxn; 
205     uint256 public maxTxnUI; 
206     uint256 private _maxWallet;
207     uint256 public maxWalletUI; 
208     uint256 private swapThreshold;
209     uint256 private swapAmount;
210     bool KickedOff = false;
211     bool public _LiqHasBeenAdded = false;
212     uint256 private _liqAddBlock = 0;
213     uint256 private _liqAddStamp = 0;
214     bool private sameBlockActive = true;
215     mapping (address => uint256) private lastTrade;
216 
217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
218     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
219     event SwapAndLiquifyEnabledUpdated(bool enabled);
220     event SwapAndLiquify(
221         uint256 tokensSwapped,
222         uint256 ethReceived,
223         uint256 tokensIntoLiqudity
224     );
225     
226     bool readyLiq = false;
227     
228     modifier lockTheSwap {
229         inSwapAndLiquify = true;
230         _;
231         inSwapAndLiquify = false;
232     }
233 
234     modifier onlyOwner() {
235         require(_owner == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238     
239     constructor () payable {
240 
241         _owner = msg.sender;
242 
243         if (block.chainid == 56) {
244             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
245         } else if (block.chainid == 97) {
246             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
247         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
248             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
249         } else {
250             revert();
251         }
252 
253         _ExcludedFromFee[owner()] = true;
254         _ExcludedFromFee[address(this)] = true;
255         _liqProv[owner()] = true;
256 
257         _approve(_msgSender(), _routerAddress, MAX);
258         _approve(address(this), _routerAddress, MAX);
259 
260     }
261 
262     receive() external payable {}
263 
264     function _ReadyLiq(address payable setMarketWallet, address payable setDev, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
265         require(!readyLiq);
266 
267         _marketWallet = payable(setMarketWallet);
268         _MuniDev = payable(setDev);
269 
270         _ExcludedFromFee[_marketWallet] = true;
271         _ExcludedFromFee[_MuniDev] = true;
272 
273         _name = _tokenname;
274         _symbol = _tokensymbol;
275         startSupply = 1_000_000_000;
276         if (startSupply < 100000000000) {
277             _decimals = 18;
278             _decimalsMul = _decimals;
279         } else {
280             _decimals = 9;
281             _decimalsMul = _decimals;
282         }
283         _tTotal = startSupply * (10**_decimalsMul);
284         _rTotal = (MAX - (MAX % _tTotal));
285 
286         dexRouter = IUniswapV2Router02(_routerAddress);
287         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
288         lpPairs[lpPair] = true;
289         _allowed[address(this)][address(dexRouter)] = type(uint256).max;
290         
291         _maxTxn = (_tTotal * 1000) / 100000;
292         maxTxnUI = (startSupply * 500) / 100000;
293         _maxWallet = (_tTotal * 10) / 1000;
294         maxWalletUI = (startSupply * 10) / 1000;
295         swapThreshold = (_tTotal * 5) / 10000;
296         swapAmount = (_tTotal * 5) / 1000;
297 
298         approve(_routerAddress, type(uint256).max);
299 
300         readyLiq = true;
301         _rOwned[owner()] = _rTotal;
302         emit Transfer(ZERO, owner(), _tTotal);
303 
304         _approve(address(this), address(dexRouter), type(uint256).max);
305 
306     }
307 
308     function owner() public view returns (address) {
309         return _owner;
310     }
311 
312     function transferOwner(address newOwner) external onlyOwner() {
313         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
314         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
315         setExcludedFromTax(_owner, false);
316         setExcludedFromTax(newOwner, true);
317         setExcludedFromRedistro(newOwner, true);
318         
319         if (_MuniDev == payable(_owner))
320             _MuniDev = payable(newOwner);
321         
322         _allowed[_owner][newOwner] = balanceOf(_owner);
323         if(balanceOf(_owner) > 0) {
324             _transfer(_owner, newOwner, balanceOf(_owner));
325         }
326         
327         _owner = newOwner;
328         emit OwnershipTransferred(_owner, newOwner);
329         
330     }
331 
332     function renounceOwnership() public virtual onlyOwner() {
333         setExcludedFromTax(_owner, false);
334         _owner = address(0);
335         emit OwnershipTransferred(_owner, address(0));
336     }
337 
338     function totalSupply() external view override returns (uint256) { return _tTotal; } 
339     function decimals() external view returns (uint8) { return _decimals; }
340     function symbol() external view returns (string memory) { return _symbol; } 
341     function name() external view returns (string memory) { return _name; }
342     function getOwner() external view returns (address) { return owner(); }
343     function allowance(address holder, address spender) external view override returns (uint256) { return _allowed[holder][spender]; }
344 
345     function balanceOf(address account) public view override returns (uint256) {
346         if (_iExcempt[account]) return _tOwned[account];
347         return tokenFromReflection(_rOwned[account]);
348     }
349 
350     function transfer(address recipient, uint256 amount) public override returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     function approve(address spender, uint256 amount) public override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     function approveMax(address spender) public returns (bool) {
361         return approve(spender, type(uint256).max);
362     }
363 
364     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
365         _transfer(sender, recipient, amount);
366         _approve(sender, _msgSender(), _allowed[sender][_msgSender()] - amount);
367         return true;
368     }
369 
370     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowed[_msgSender()][spender] + addedValue);
372         return true;
373     }
374 
375     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowed[_msgSender()][spender] - subtractedValue);
377         return true;
378     }
379 
380     function setNextRouter(address newRouter) external onlyOwner() {
381         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
382         address g_p = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
383         if (g_p == address(0)) {
384             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
385         }
386         else {
387             lpPair = g_p;
388         }
389         dexRouter = _newRouter;
390         _approve(address(this), newRouter, MAX);
391     }
392 
393     function setLpPair(address pair, bool enabled) external onlyOwner {
394         if (enabled == false) {
395             lpPairs[pair] = false;
396         } else {
397             if (LiquidityPairCount != 0) {
398                 require(block.timestamp - LiquidityPairCount > 0, "Cannot set two pairs in one block!");
399             }
400             lpPairs[pair] = true;
401             LiquidityPairCount = block.timestamp;
402         }
403     }
404 
405     function isExcludedFromReward(address account) public view returns (bool) {
406         return _iExcempt[account];
407     }
408 
409     function ExcludedFromFee(address account) public view returns(bool) {
410         return _ExcludedFromFee[account];
411     }
412 
413     function setTaxIn(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
414         require(reflect <= maxRedistro
415                 && liquidity <= maxLiq
416                 && marketing <= maxMarket
417                 );
418         require(reflect + liquidity + marketing <= 4900);
419         _buydistro = reflect;
420         _buyliq = liquidity;
421         _buyMarket = marketing;
422     }
423 
424     function setTaxOut(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
425         require(reflect <= maxRedistro
426                 && liquidity <= maxLiq
427                 && marketing <= maxMarket
428                 );
429         require(reflect + liquidity + marketing <= 4900);
430         _selldistro = reflect;
431         _sellLiq = liquidity;
432         _sellMarket = marketing;
433     }
434 
435     function setTaxTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
436         require(reflect <= maxRedistro
437                 && liquidity <= maxLiq
438                 && marketing <= maxMarket
439                 );
440         require(reflect + liquidity + marketing <= 4900);
441         _transferRedistro = reflect;
442         _transferLiq = liquidity;
443         _transferMarket = marketing;
444     }
445 
446     function setStakeValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
447         MarketStake = ms;
448         DevStake = ds;
449         ValueDivisor = vd;
450     }
451 
452     function setTaxDivisionRatio(uint256 liquidity, uint256 marketing) external onlyOwner {
453         _liquidityRatio = liquidity;
454         _marketRatio = marketing;
455     }
456 
457     function setMaximumTransaction(uint256 percent, uint256 divisor) external onlyOwner {
458         uint256 check = (_tTotal * percent) / divisor;
459         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
460         _maxTxn = check;
461         maxTxnUI = (startSupply * percent) / divisor;
462     }
463 
464     function setMaximumWallet(uint256 percentage, uint256 divisor) external onlyOwner {
465         uint256 check = (_tTotal * percentage) / divisor; 
466         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
467         _maxWallet = check;
468         maxWalletUI = (startSupply * percentage) / divisor;
469     }
470 
471     function setRouterSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
472         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
473         swapAmount = (_tTotal * amountPercent) / amountDivisor;
474     }
475 
476     function setNextMarketing(address payable newWallet) external onlyOwner {
477         require(_marketWallet != newWallet, "Wallet already set!");
478         _marketWallet = payable(newWallet);
479     }
480 
481     function setNextDeveloper(address payable newWallet) external onlyOwner {
482         require(_MuniDev != newWallet, "Wallet already set!");
483         _MuniDev = payable(newWallet);
484     }
485     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
486         swapAndLiquifyEnabled = _enabled;
487         emit SwapAndLiquifyEnabledUpdated(_enabled);
488     }
489 
490     function setExcludedFromTax(address account, bool enabled) public onlyOwner {
491         _ExcludedFromFee[account] = enabled;
492     }
493 
494     function setExcludedFromRedistro(address account, bool enabled) public onlyOwner {
495         if (enabled == true) {
496             require(!_iExcempt[account], "Account is already excluded.");
497             if(_rOwned[account] > 0) {
498                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
499             }
500             _iExcempt[account] = true;
501             _excluded.push(account);
502         } else if (enabled == false) {
503             require(_iExcempt[account], "Account is already included.");
504             for (uint256 i = 0; i < _excluded.length; i++) {
505                 if (_excluded[i] == account) {
506                     _excluded[i] = _excluded[_excluded.length - 1];
507                     _tOwned[account] = 0;
508                     _iExcempt[account] = false;
509                     _excluded.pop();
510                     break;
511                 }
512             }
513         }
514     }
515 
516     function totalFees() public view returns (uint256) {
517         return _tFeeTotal;
518     }
519 
520     function _hasLimits(address from, address to) internal view returns (bool) {
521         return from != owner()  && to != owner() && !_liqProv[to] && !_liqProv[from] && to != DEAD && to != address(0) && from != address(this) && !_ExcludedFromFee[to] && !_ExcludedFromFee[from];
522     }
523 
524     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
525         require(rAmount <= _rTotal, "Amount must be less than total reflections - MUNI");
526         uint256 currentRate =  _getRate();
527         return rAmount / currentRate;
528     }
529     
530     function _approve(address sender, address spender, uint256 amount) internal {
531         require(sender != address(0), "Cannot approve from the zero address - MUNI");
532         require(spender != address(0), "Cannot approve to the zero address - MUNI");
533 
534         _allowed[sender][spender] = amount;
535         emit Approval(sender, spender, amount);
536     }
537 
538     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
539         require(from != address(0), "Cannot transfer from the zero address - MUNI");
540         require(to != address(0), "Cannot transfer to the zero address - MUNI");
541         require(amount > 0, "Transfer amount must be greater than zero - MUNI");
542         require(!InJail[from] && !InJail[to] && !InJail[msg.sender]);
543         if(_hasLimits(from, to)) {
544             if(!KickedOff) {
545                 revert("Trading not yet enabled! - MUNI");
546             }
547             if (sameBlockActive) {
548                 if (lpPairs[from]){
549                     require(lastTrade[to] != block.number + 1);
550                     lastTrade[to] = block.number;
551                 } else {
552                     require(lastTrade[from] != block.number + 1);
553                     lastTrade[from] = block.number;
554                 }
555             }
556             require(amount <= _maxTxn, "Transfer exceeds the maxTxAmount.- MUNI");
557             if(to != _routerAddress && !lpPairs[to]) {
558                 require(balanceOf(to) + amount <= _maxWallet, "Transfer exceeds the maxWalletSize.- MUNI");
559             }
560         }
561         bool takeFee = true;
562         if(_ExcludedFromFee[from] || _ExcludedFromFee[to]){
563             takeFee = false;
564         }
565 
566         if (lpPairs[to]) {
567             if (!inSwapAndLiquify
568                 && swapAndLiquifyEnabled
569             ) {
570                 uint256 contractTokenBalance = balanceOf(address(this));
571                 if (contractTokenBalance >= swapThreshold) {
572                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
573                     swapAndLiquify(contractTokenBalance);
574                 }
575             }      
576         } 
577         return _finalize(from, to, amount, takeFee);
578     }
579 
580     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
581         if (_liquidityRatio + _marketRatio == 0)
582             return;
583         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketRatio)) / 2;
584 
585         uint256 toSwapForEth = contractTokenBalance - toLiquify;
586 
587         address[] memory path = new address[](2);
588         path[0] = address(this);
589         path[1] = dexRouter.WETH();
590 
591         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
592             toSwapForEth,
593             0,
594             path,
595             address(this),
596             block.timestamp
597         );
598 
599 
600         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketRatio)) / 2;
601 
602         if (toLiquify > 0) {
603             dexRouter.addLiquidityETH{value: liquidityBalance}(
604                 address(this),
605                 toLiquify,
606                 0, 
607                 0, 
608                 _MuniDev,
609                 block.timestamp
610             );
611             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
612         }
613         if (contractTokenBalance - toLiquify > 0) {
614 
615             uint256 OperationsFee = (address(this).balance);
616             uint256 marketFund = OperationsFee/(ValueDivisor)*(MarketStake);
617             uint256 devFund = OperationsFee/(ValueDivisor)*(DevStake); _MuniDev.transfer(devFund); 
618             _marketWallet.transfer(marketFund);           
619 
620         }
621     }
622 
623     
624 
625     function _checkLiquidityAdd(address from, address to) internal {
626         require(!_LiqHasBeenAdded, "Liquidity is already added.");
627         if (!_hasLimits(from, to) && to == lpPair) {
628             _liqProv[from] = true;
629             _LiqHasBeenAdded = true;
630             _liqAddStamp = block.timestamp;
631 
632             swapAndLiquifyEnabled = true;
633             emit SwapAndLiquifyEnabledUpdated(true);
634         }
635     }
636 
637     function MuniStart() public onlyOwner {
638         require(!KickedOff, "Trading is already enabled!");
639         setExcludedFromRedistro(address(this), true);
640         setExcludedFromRedistro(lpPair, true);
641 
642         KickedOff = true;
643         swapAndLiquifyEnabled = true;
644     }
645 
646     struct ExtraValues {
647         uint256 tTransferAmount;
648         uint256 tFee;
649         uint256 tLiquidity;
650 
651         uint256 rTransferAmount;
652         uint256 rAmount;
653         uint256 rFee;
654     }
655 
656     function _finalize(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
657 
658 
659         if (!_LiqHasBeenAdded) {
660                 _checkLiquidityAdd(from, to);
661                 if (!_LiqHasBeenAdded && _hasLimits(from, to)) {
662                     revert("Only owner can transfer at this time.");
663                 }
664         }
665         
666         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
667 
668         _rOwned[from] = _rOwned[from] - values.rAmount;
669         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
670 
671         if (_iExcempt[from] && !_iExcempt[to]) {
672             _tOwned[from] = _tOwned[from] - tAmount;
673         } else if (!_iExcempt[from] && _iExcempt[to]) {
674             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
675         } else if (_iExcempt[from] && _iExcempt[to]) {
676             _tOwned[from] = _tOwned[from] - tAmount;
677             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
678         }
679 
680         if (values.tLiquidity > 0)
681             _takeLiquidity(from, values.tLiquidity);
682         if (values.rFee > 0 || values.tFee > 0)
683             _takeReflect(values.rFee, values.tFee);
684 
685         emit Transfer(from, to, values.tTransferAmount);
686         return true;
687     }
688 
689     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
690         ExtraValues memory values;
691         uint256 currentRate = _getRate();
692 
693         values.rAmount = tAmount * currentRate;
694 
695         if(takeFee) {
696             if (lpPairs[to]) {
697                 _redistro = _selldistro;
698                 _liq = _sellLiq;
699                 _market = _sellMarket;
700             } else if (lpPairs[from]) {
701                 _redistro = _buydistro;
702                 _liq = _buyliq;
703                 _market = _buyMarket;
704             } else {
705                 _redistro = _transferRedistro;
706                 _liq = _transferLiq;
707                 _market = _transferMarket;
708             }
709 
710             values.tFee = (tAmount * _redistro) / masterTaxDivisor;
711             values.tLiquidity = (tAmount * (_liq + _market)) / masterTaxDivisor;
712             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
713 
714             values.rFee = values.tFee * currentRate;
715         } else {
716             values.tFee = 0;
717             values.tLiquidity = 0;
718             values.tTransferAmount = tAmount;
719 
720             values.rFee = 0;
721         }
722 
723         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
724         return values;
725     }
726 
727     function _getRate() internal view returns(uint256) {
728         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
729         return rSupply / tSupply;
730     }
731 
732     function _getCurrentSupply() internal view returns(uint256, uint256) {
733         uint256 rSupply = _rTotal;
734         uint256 tSupply = _tTotal;
735         for (uint256 i = 0; i < _excluded.length; i++) {
736             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
737             rSupply = rSupply - _rOwned[_excluded[i]];
738             tSupply = tSupply - _tOwned[_excluded[i]];
739         }
740         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
741         return (rSupply, tSupply);
742     }
743     
744     function _takeReflect(uint256 rFee, uint256 tFee) internal {
745         _rTotal = _rTotal - rFee;
746         _tFeeTotal = _tFeeTotal + tFee;
747     }
748 
749     function RemoveEthStuckInMuniContract() external onlyOwner {
750         payable(owner()).transfer(address(this).balance);
751     }
752     
753     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
754         uint256 currentRate =  _getRate();
755         uint256 rLiquidity = tLiquidity * currentRate;
756         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
757         if(_iExcempt[address(this)])
758             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
759         emit Transfer(sender, address(this), tLiquidity); 
760     }
761 
762     function UnderInvestigation(address[] memory accounts, bool state) external onlyOwner{
763         for(uint256 i = 0; i < accounts.length; i++){
764             InJail[accounts[i]] = state;
765         }
766     }
767  
768     function Caught(address account, bool state) external onlyOwner{
769         InJail[account] = state;
770     }
771 
772     function SetLowerTaxes() external onlyOwner() {
773         _buydistro = 0;
774         _buyliq = 0;
775         _buyMarket = 1000;
776         _selldistro = 0;
777         _sellLiq = 0;
778         _sellMarket = 1000;
779         _transferRedistro = 0;
780         _transferLiq = 0;
781         _transferMarket = 0;
782     }
783 }