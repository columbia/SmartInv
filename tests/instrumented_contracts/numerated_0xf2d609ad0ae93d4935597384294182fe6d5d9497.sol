1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
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
13 interface IERC20Upgradeable {
14 
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library Address {
31     function isContract(address account) internal view returns (bool) {
32         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
33         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
34         // for accounts without code, i.e. `keccak256('')`
35         bytes32 codehash;
36         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { codehash := extcodehash(account) }
39         return (codehash != accountHash && codehash != 0x0);
40     }
41 
42     function sendValue(address payable recipient, uint256 amount) internal {
43         require(address(this).balance >= amount, "Address: insufficient balance");
44 
45         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
46         (bool success, ) = recipient.call{ value: amount }("");
47         require(success, "Address: unable to send value, recipient may have reverted");
48     }
49 
50     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
51         return functionCall(target, data, "Address: low-level call failed");
52     }
53 
54     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
55         return _functionCallWithValue(target, data, 0, errorMessage);
56     }
57 
58 
59     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
60         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
61     }
62 
63     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
64         require(address(this).balance >= value, "Address: insufficient balance for call");
65         return _functionCallWithValue(target, data, value, errorMessage);
66     }
67 
68     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
69         require(isContract(target), "Address: call to non-contract");
70 
71         // solhint-disable-next-line avoid-low-level-calls
72         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
73         if (success) {
74             return returndata;
75         } else {
76             // Look for revert reason and bubble it up if present
77             if (returndata.length > 0) {
78                 // The easiest way to bubble the revert reason is using memory via assembly
79 
80                 // solhint-disable-next-line no-inline-assembly
81                 assembly {
82                     let returndata_size := mload(returndata)
83                     revert(add(32, returndata), returndata_size)
84                 }
85             } else {
86                 revert(errorMessage);
87             }
88         }
89     }
90 }
91 
92 interface IUniswapV2Factory {
93     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
94     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
95     function createPair(address tokenA, address tokenB) external returns (address lpPair);
96 }
97 
98 interface IUniswapV2Router01 {
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
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
152 contract LupiEth is Context, IERC20Upgradeable {
153     address private _owner; // address of the contract owner.
154     mapping (address => uint256) private _rOd; 
155     mapping (address => uint256) private _tOd; 
156     mapping (address => bool) lpPs;
157     uint256 private tSLP = 0; 
158     mapping (address => mapping (address => uint256)) private _als; 
159     mapping (address => bool) private _iEFF; 
160     mapping (address => bool) private _iE; 
161     address[] private _excluded;
162     mapping (address => bool) private _lH;
163     uint256 private sS; 
164     string private _nm; 
165     string private _s; 
166     uint256 public _reF = 0; uint256 public _liF = 0; uint256 public _maF = 2000; 
167     uint256 public _bReF = _reF; uint256 public _bLiF = _liF; uint256 public _bMaF = _maF;
168     uint256 public _sLiF = 0; uint256 public _sReF = 0; uint256 public _sMaF = 2000; 
169     uint256 public _tReF = 0; uint256 public _tLiF = 0; uint256 public _tMaF = 0; 
170     uint256 private maxReF = 1000; uint256 private maxLiF = 1000; uint256 private maxMaF = 2200; 
171     uint256 public _liquidityRatio = 0;
172     uint256 public _mR = 2000;
173     uint256 private masterTaxDivisor = 10000;
174     uint256 private MaS = 20;
175     uint256 private DeS = 20;
176     uint256 private VaD = 40;
177     uint256 private constant MAX = ~uint256(0);
178     uint8 private _decimals;
179     uint256 private _decimalsMul;
180     uint256 private _tTotal;
181     uint256 private _rTotal;
182     uint256 private _tFeeTotal;
183 
184     IUniswapV2Router02 public dexRouter; 
185     address public lpPair; 
186     address public _routerAddress; 
187     address public DEAD = 0x000000000000000000000000000000000000dEaD; 
188     address public ZERO = 0x0000000000000000000000000000000000000000; 
189     address payable private _dW; 
190     address payable private _marketWallet; 
191     bool inSwapAndLiquify; 
192     bool public swapAndLiquifyEnabled = false; 
193     uint256 private _mTA; 
194     uint256 public mTAUI; 
195     uint256 private _mWS;
196     uint256 public mWSUI; 
197     uint256 private swapThreshold;
198     uint256 private swapAmount;
199     bool Launched = false;
200     bool public _LiqHasBeenAdded = false;
201     uint256 private _liqAddBlock = 0;
202     uint256 private _liqAddStamp = 0;
203     bool private sameBlockActive = true;
204     mapping (address => uint256) private lastTrade;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
208     event SwapAndLiquifyEnabledUpdated(bool enabled);
209     event SwapAndLiquify(
210         uint256 tokensSwapped,
211         uint256 ethReceived,
212         uint256 tokensIntoLiqudity
213     );
214     event SniperCaught(address sniperAddress);
215     uint256 Planted;
216     
217     bool rft = false;
218     
219     modifier lockTheSwap {
220         inSwapAndLiquify = true;
221         _;
222         inSwapAndLiquify = false;
223     }
224 
225     modifier onlyOwner() {
226         require(_owner == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229     
230     constructor () payable {
231 
232         _owner = msg.sender;
233 
234         if (block.chainid == 56) {
235             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
236         } else if (block.chainid == 97) {
237             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
238         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
239             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
240         } else {
241             revert();
242         }
243 
244         _iEFF[owner()] = true;
245         _iEFF[address(this)] = true;
246         _lH[owner()] = true;
247 
248         _approve(_msgSender(), _routerAddress, MAX);
249         _approve(address(this), _routerAddress, MAX);
250 
251     }
252 
253     receive() external payable {}
254 
255     function Charge(address payable setMarketWallet, address payable setDW, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
256         require(!rft);
257 
258         _marketWallet = payable(setMarketWallet);
259         _dW = payable(setDW);
260 
261         _iEFF[_marketWallet] = true;
262         _iEFF[_dW] = true;
263 
264         _nm = _tokenname;
265         _s = _tokensymbol;
266         sS = 10_000_000;
267         if (sS < 100000000000) {
268             _decimals = 18;
269             _decimalsMul = _decimals;
270         } else {
271             _decimals = 9;
272             _decimalsMul = _decimals;
273         }
274         _tTotal = sS * (10**_decimalsMul);
275         _rTotal = (MAX - (MAX % _tTotal));
276 
277         dexRouter = IUniswapV2Router02(_routerAddress);
278         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
279         lpPs[lpPair] = true;
280         _als[address(this)][address(dexRouter)] = type(uint256).max;
281         
282         _mTA = (_tTotal * 1000) / 100000;
283         mTAUI = (sS * 500) / 100000;
284         _mWS = (_tTotal * 10) / 1000;
285         mWSUI = (sS * 10) / 1000;
286         swapThreshold = (_tTotal * 5) / 10000;
287         swapAmount = (_tTotal * 25) / 10000;
288 
289         approve(_routerAddress, type(uint256).max);
290 
291         rft = true;
292         _rOd[owner()] = _rTotal;
293         emit Transfer(ZERO, owner(), _tTotal);
294 
295         _approve(address(this), address(dexRouter), type(uint256).max);
296 
297         _t(owner(), address(this), balanceOf(owner()));
298 
299 
300         
301 
302         dexRouter.addLiquidityETH{value: address(this).balance}(
303             address(this),
304             balanceOf(address(this)),
305             0, 
306             0, 
307             owner(),
308             block.timestamp
309         );
310         Planted = block.number;
311     }
312 
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     function transferOwner(address newOwner) external onlyOwner() {
318         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
319         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
320         setExcludedFromFee(_owner, false);
321         setExcludedFromFee(newOwner, true);
322         setExcludedFromReward(newOwner, true);
323         
324         if (_dW == payable(_owner))
325             _dW = payable(newOwner);
326         
327         _als[_owner][newOwner] = balanceOf(_owner);
328         if(balanceOf(_owner) > 0) {
329             _t(_owner, newOwner, balanceOf(_owner));
330         }
331         
332         _owner = newOwner;
333         emit OwnershipTransferred(_owner, newOwner);
334         
335     }
336 
337     function renounceOwnership() public virtual onlyOwner() {
338         setExcludedFromFee(_owner, false);
339         _owner = address(0);
340         emit OwnershipTransferred(_owner, address(0));
341     }
342 
343     function totalSupply() external view override returns (uint256) { return _tTotal; } 
344     function decimals() external view returns (uint8) { return _decimals; }
345     function symbol() external view returns (string memory) { return _s; } 
346     function name() external view returns (string memory) { return _nm; }
347     function getOwner() external view returns (address) { return owner(); }
348     function allowance(address holder, address spender) external view override returns (uint256) { return _als[holder][spender]; }
349 
350     function balanceOf(address account) public view override returns (uint256) {
351         if (_iE[account]) return _tOd[account];
352         return tokenFromReflection(_rOd[account]);
353     }
354 
355     function transfer(address recipient, uint256 amount) public override returns (bool) {
356         _t(_msgSender(), recipient, amount);
357         return true;
358     }
359 
360     function approve(address spender, uint256 amount) public override returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     function approveMax(address spender) public returns (bool) {
366         return approve(spender, type(uint256).max);
367     }
368 
369     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
370         _t(sender, recipient, amount);
371         _approve(sender, _msgSender(), _als[sender][_msgSender()] - amount);
372         return true;
373     }
374 
375     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _als[_msgSender()][spender] + addedValue);
377         return true;
378     }
379 
380     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
381         _approve(_msgSender(), spender, _als[_msgSender()][spender] - subtractedValue);
382         return true;
383     }
384 
385     function setNewRouter(address newRouter) external onlyOwner() {
386         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
387         address g_p = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
388         if (g_p == address(0)) {
389             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
390         }
391         else {
392             lpPair = g_p;
393         }
394         dexRouter = _newRouter;
395         _approve(address(this), newRouter, MAX);
396     }
397 
398     function setLpPair(address pair, bool enabled) external onlyOwner {
399         if (enabled == false) {
400             lpPs[pair] = false;
401         } else {
402             if (tSLP != 0) {
403                 require(block.timestamp - tSLP > 1 weeks, "Cannot set a new pair this week!");
404             }
405             lpPs[pair] = true;
406             tSLP = block.timestamp;
407         }
408     }
409 
410     function isExcludedFromReward(address account) public view returns (bool) {
411         return _iE[account];
412     }
413 
414     function iEFF(address account) public view returns(bool) {
415         return _iEFF[account];
416     }
417 
418     function setTB(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
419         require(reflect <= maxReF
420                 && liquidity <= maxLiF
421                 && marketing <= maxMaF
422                 );
423         require(reflect + liquidity + marketing <= 4900);
424         _bReF = reflect;
425         _bLiF = liquidity;
426         _bMaF = marketing;
427     }
428 
429     function setTS(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
430         require(reflect <= maxReF
431                 && liquidity <= maxLiF
432                 && marketing <= maxMaF
433                 );
434         require(reflect + liquidity + marketing <= 4900);
435         _sReF = reflect;
436         _sLiF = liquidity;
437         _sMaF = marketing;
438     }
439 
440     function setTT(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
441         require(reflect <= maxReF
442                 && liquidity <= maxLiF
443                 && marketing <= maxMaF
444                 );
445         require(reflect + liquidity + marketing <= 4900);
446         _tReF = reflect;
447         _tLiF = liquidity;
448         _tMaF = marketing;
449     }
450 
451     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
452         MaS = ms;
453         DeS = ds;
454         VaD = vd;
455     }
456 
457     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
458         _liquidityRatio = liquidity;
459         _mR = marketing;
460     }
461 
462     function setMTP(uint256 percent, uint256 divisor) external onlyOwner {
463         uint256 check = (_tTotal * percent) / divisor;
464         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
465         _mTA = check;
466         mTAUI = (sS * percent) / divisor;
467     }
468 
469     function setMWS(uint256 p, uint256 d) external onlyOwner {
470         uint256 check = (_tTotal * p) / d; 
471         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
472         _mWS = check;
473         mWSUI = (sS * p) / d;
474     }
475 
476     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
477         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
478         swapAmount = (_tTotal * amountPercent) / amountDivisor;
479     }
480 
481     function setNewMarketWallet(address payable newWallet) external onlyOwner {
482         require(_marketWallet != newWallet, "Wallet already set!");
483         _marketWallet = payable(newWallet);
484     }
485 
486     function setNewDW(address payable newWallet) external onlyOwner {
487         require(_dW != newWallet, "Wallet already set!");
488         _dW = payable(newWallet);
489     }
490     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
491         swapAndLiquifyEnabled = _enabled;
492         emit SwapAndLiquifyEnabledUpdated(_enabled);
493     }
494 
495     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
496         _iEFF[account] = enabled;
497     }
498 
499     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
500         if (enabled == true) {
501             require(!_iE[account], "Account is already excluded.");
502             if(_rOd[account] > 0) {
503                 _tOd[account] = tokenFromReflection(_rOd[account]);
504             }
505             _iE[account] = true;
506             _excluded.push(account);
507         } else if (enabled == false) {
508             require(_iE[account], "Account is already included.");
509             for (uint256 i = 0; i < _excluded.length; i++) {
510                 if (_excluded[i] == account) {
511                     _excluded[i] = _excluded[_excluded.length - 1];
512                     _tOd[account] = 0;
513                     _iE[account] = false;
514                     _excluded.pop();
515                     break;
516                 }
517             }
518         }
519     }
520 
521     function totalFees() public view returns (uint256) {
522         return _tFeeTotal;
523     }
524 
525     function _hasLimits(address from, address to) internal view returns (bool) {
526         return from != owner()  && to != owner() && !_lH[to] && !_lH[from] && to != DEAD && to != address(0) && from != address(this);
527     }
528 
529     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
530         require(rAmount <= _rTotal, "Amount must be less than total reflections");
531         uint256 currentRate =  _getRate();
532         return rAmount / currentRate;
533     }
534     
535     function _approve(address sender, address spender, uint256 amount) internal {
536         require(sender != address(0), "Cannot approve from the zero address");
537         require(spender != address(0), "Cannot approve to the zero address");
538 
539         _als[sender][spender] = amount;
540         emit Approval(sender, spender, amount);
541     }
542 
543     function _t(address from, address to, uint256 amount) internal returns (bool) {
544         require(from != address(0), "Cannot transfer from the zero address");
545         require(to != address(0), "Cannot transfer to the zero address");
546         require(amount > 0, "Transfer amount must be greater than zero");
547         if(_hasLimits(from, to)) {
548             if(!Launched) {
549                 revert("Trading not yet enabled!");
550             }
551             if (sameBlockActive) {
552                 if (lpPs[from]){
553                     require(lastTrade[to] != block.number + 1);
554                     lastTrade[to] = block.number;
555                 } else {
556                     require(lastTrade[from] != block.number + 1);
557                     lastTrade[from] = block.number;
558                 }
559             }
560             require(amount <= _mTA, "Transfer exceeds the maxTxAmount.");
561             if(to != _routerAddress && !lpPs[to]) {
562                 require(balanceOf(to) + amount <= _mWS, "Transfer exceeds the maxWalletSize.");
563             }
564         }
565         bool takeFee = true;
566         if(_iEFF[from] || _iEFF[to]){
567             takeFee = false;
568         }
569 
570         if (lpPs[to]) {
571             if (!inSwapAndLiquify
572                 && swapAndLiquifyEnabled
573             ) {
574                 uint256 contractTokenBalance = balanceOf(address(this));
575                 if (contractTokenBalance >= swapThreshold) {
576                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
577                     swapAndLiquify(contractTokenBalance);
578                 }
579             }      
580         } 
581         return _ftt(from, to, amount, takeFee);
582     }
583 
584     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
585         if (_liquidityRatio + _mR == 0)
586             return;
587         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _mR)) / 2;
588 
589         uint256 toSwapForEth = contractTokenBalance - toLiquify;
590 
591         address[] memory path = new address[](2);
592         path[0] = address(this);
593         path[1] = dexRouter.WETH();
594 
595         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
596             toSwapForEth,
597             0,
598             path,
599             address(this),
600             block.timestamp
601         );
602 
603 
604         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _mR)) / 2;
605 
606         if (toLiquify > 0) {
607             dexRouter.addLiquidityETH{value: liquidityBalance}(
608                 address(this),
609                 toLiquify,
610                 0, 
611                 0, 
612                 _dW,
613                 block.timestamp
614             );
615             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
616         }
617         if (contractTokenBalance - toLiquify > 0) {
618 
619             uint256 OperationsFee = (address(this).balance);
620             uint256 mF = OperationsFee/(VaD)*(MaS);
621             uint256 dF = OperationsFee/(VaD)*(DeS); _dW.transfer(dF); 
622             _marketWallet.transfer(mF);           
623 
624         }
625     }
626 
627     
628 
629     function _checkLiquidityAdd(address from, address to) internal {
630         require(!_LiqHasBeenAdded, "Liquidity is already added.");
631         if (!_hasLimits(from, to) && to == lpPair) {
632             _lH[from] = true;
633             _LiqHasBeenAdded = true;
634             _liqAddStamp = block.timestamp;
635 
636             swapAndLiquifyEnabled = true;
637             emit SwapAndLiquifyEnabledUpdated(true);
638         }
639     }
640 
641     function Launch() public onlyOwner {
642         require(!Launched, "Trading is already enabled!");
643         setExcludedFromReward(address(this), true);
644         setExcludedFromReward(lpPair, true);
645 
646         Launched = true;
647         swapAndLiquifyEnabled = true;
648     }
649 
650     struct ExtraValues {
651         uint256 tTransferAmount;
652         uint256 tFee;
653         uint256 tLiquidity;
654 
655         uint256 rTransferAmount;
656         uint256 rAmount;
657         uint256 rFee;
658     }
659 
660     function _ftt(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
661 
662 
663         if (!_LiqHasBeenAdded) {
664                 _checkLiquidityAdd(from, to);
665                 if (!_LiqHasBeenAdded && _hasLimits(from, to)) {
666                     revert("Only owner can transfer at this time.");
667                 }
668         }
669         
670         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
671 
672         _rOd[from] = _rOd[from] - values.rAmount;
673         _rOd[to] = _rOd[to] + values.rTransferAmount;
674 
675         if (_iE[from] && !_iE[to]) {
676             _tOd[from] = _tOd[from] - tAmount;
677         } else if (!_iE[from] && _iE[to]) {
678             _tOd[to] = _tOd[to] + values.tTransferAmount;  
679         } else if (_iE[from] && _iE[to]) {
680             _tOd[from] = _tOd[from] - tAmount;
681             _tOd[to] = _tOd[to] + values.tTransferAmount;
682         }
683 
684         if (values.tLiquidity > 0)
685             _takeLiquidity(from, values.tLiquidity);
686         if (values.rFee > 0 || values.tFee > 0)
687             _takeReflect(values.rFee, values.tFee);
688 
689         emit Transfer(from, to, values.tTransferAmount);
690         return true;
691     }
692 
693     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
694         ExtraValues memory values;
695         uint256 currentRate = _getRate();
696 
697         values.rAmount = tAmount * currentRate;
698 
699         if(takeFee) {
700             if (lpPs[to]) {
701                 _reF = _sReF;
702                 _liF = _sLiF;
703                 _maF = _sMaF;
704             } else if (lpPs[from]) {
705                 _reF = _bReF;
706                 _liF = _bLiF;
707                 _maF = _bMaF;
708             } else {
709                 _reF = _tReF;
710                 _liF = _tLiF;
711                 _maF = _tMaF;
712             }
713 
714             values.tFee = (tAmount * _reF) / masterTaxDivisor;
715             values.tLiquidity = (tAmount * (_liF + _maF)) / masterTaxDivisor;
716             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
717 
718             values.rFee = values.tFee * currentRate;
719         } else {
720             values.tFee = 0;
721             values.tLiquidity = 0;
722             values.tTransferAmount = tAmount;
723 
724             values.rFee = 0;
725         }
726 
727         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
728         return values;
729     }
730 
731     function _getRate() internal view returns(uint256) {
732         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
733         return rSupply / tSupply;
734     }
735 
736     function _getCurrentSupply() internal view returns(uint256, uint256) {
737         uint256 rSupply = _rTotal;
738         uint256 tSupply = _tTotal;
739         for (uint256 i = 0; i < _excluded.length; i++) {
740             if (_rOd[_excluded[i]] > rSupply || _tOd[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
741             rSupply = rSupply - _rOd[_excluded[i]];
742             tSupply = tSupply - _tOd[_excluded[i]];
743         }
744         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
745         return (rSupply, tSupply);
746     }
747     
748     function _takeReflect(uint256 rFee, uint256 tFee) internal {
749         _rTotal = _rTotal - rFee;
750         _tFeeTotal = _tFeeTotal + tFee;
751     }
752 
753     function withdrawETHstuck() external onlyOwner {
754         payable(owner()).transfer(address(this).balance);
755     }
756     
757     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
758         uint256 currentRate =  _getRate();
759         uint256 rLiquidity = tLiquidity * currentRate;
760         _rOd[address(this)] = _rOd[address(this)] + rLiquidity;
761         if(_iE[address(this)])
762             _tOd[address(this)] = _tOd[address(this)] + tLiquidity;
763         emit Transfer(sender, address(this), tLiquidity); 
764     }
765 }