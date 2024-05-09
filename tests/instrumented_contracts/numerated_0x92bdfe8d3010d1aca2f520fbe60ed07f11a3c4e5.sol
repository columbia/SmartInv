1 // 
2 /*
3 
4 
5 
6 */
7 // 
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity >=0.6.0 <0.9.0;
11 abstract contract Context {
12     function _msgSender() internal view returns (address payable) {
13         return payable(msg.sender);
14     }
15     function _msgData() internal view returns (bytes memory) {
16         this; 
17         return msg.data; 
18     }
19 }
20 
21 interface IERC20Upgradeable {
22 
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library Address {
39     function isContract(address account) internal view returns (bool) {
40         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
41         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
42         // for accounts without code, i.e. `keccak256('')`
43         bytes32 codehash;
44         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
45         // solhint-disable-next-line no-inline-assembly
46         assembly { codehash := extcodehash(account) }
47         return (codehash != accountHash && codehash != 0x0);
48     }
49 
50     function sendValue(address payable recipient, uint256 amount) internal {
51         require(address(this).balance >= amount, "Address: insufficient balance");
52 
53         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
54         (bool success, ) = recipient.call{ value: amount }("");
55         require(success, "Address: unable to send value, recipient may have reverted");
56     }
57 
58     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
59         return functionCall(target, data, "Address: low-level call failed");
60     }
61 
62     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
63         return _functionCallWithValue(target, data, 0, errorMessage);
64     }
65 
66 
67     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
68         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
69     }
70 
71     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
72         require(address(this).balance >= value, "Address: insufficient balance for call");
73         return _functionCallWithValue(target, data, value, errorMessage);
74     }
75 
76     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
77         require(isContract(target), "Address: call to non-contract");
78 
79         // solhint-disable-next-line avoid-low-level-calls
80         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
81         if (success) {
82             return returndata;
83         } else {
84             // Look for revert reason and bubble it up if present
85             if (returndata.length > 0) {
86                 // The easiest way to bubble the revert reason is using memory via assembly
87 
88                 // solhint-disable-next-line no-inline-assembly
89                 assembly {
90                     let returndata_size := mload(returndata)
91                     revert(add(32, returndata), returndata_size)
92                 }
93             } else {
94                 revert(errorMessage);
95             }
96         }
97     }
98 }
99 
100 interface IUniswapV2Factory {
101     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
102     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
103     function createPair(address tokenA, address tokenB) external returns (address lpPair);
104 }
105 
106 interface IUniswapV2Router01 {
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 interface IUniswapV2Router02 is IUniswapV2Router01 {
120     function removeLiquidityETHSupportingFeeOnTransferTokens(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external returns (uint amountETH);
128     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
129         address token,
130         uint liquidity,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline,
135         bool approveMax, uint8 v, bytes32 r, bytes32 s
136     ) external returns (uint amountETH);
137 
138     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external;
145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external payable;
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158 }
159 
160 contract RessaEth is Context, IERC20Upgradeable {
161     address private _owner; // address of the contract owner.
162     mapping (address => uint256) private _rOd; 
163     mapping (address => uint256) private _tOd; 
164     mapping (address => bool) lpPs;
165     uint256 private tSLP = 0; 
166     mapping (address => mapping (address => uint256)) private _als; 
167     mapping (address => bool) private _iEFF; 
168     mapping (address => bool) private _iE; 
169     address[] private _excluded;
170     mapping (address => bool) private _lH;
171     uint256 private sS; 
172     string private _nm; 
173     string private _s; 
174     uint256 public _reF = 100; uint256 public _liF = 200; uint256 public _maF = 300; 
175     uint256 public _bReF = _reF; uint256 public _bLiF = _liF; uint256 public _bMaF = _maF;
176     uint256 public _sLiF = 300; uint256 public _sReF = 200; uint256 public _sMaF = 100; 
177     uint256 public _tReF = 0; uint256 public _tLiF = 0; uint256 public _tMaF = 0; 
178     uint256 private maxReF = 1000; uint256 private maxLiF = 1000; uint256 private maxMaF = 2200; 
179     uint256 public _liquidityRatio = 300;
180     uint256 public _mR = 200;
181     uint256 private masterTaxDivisor = 10000;
182     uint256 private MaS = 40;
183     uint256 private DeS = 10;
184     uint256 private VaD = 50;
185     uint256 private constant MAX = ~uint256(0);
186     uint8 private _decimals;
187     uint256 private _decimalsMul;
188     uint256 private _tTotal;
189     uint256 private _rTotal;
190     uint256 private _tFeeTotal;
191 
192     IUniswapV2Router02 public dexRouter; 
193     address public lpPair; 
194     address public _routerAddress; 
195     address public DEAD = 0x000000000000000000000000000000000000dEaD; 
196     address public ZERO = 0x0000000000000000000000000000000000000000; 
197     address payable private _dW; 
198     address payable private _marketWallet; 
199     bool inSwapAndLiquify; 
200     bool public swapAndLiquifyEnabled = false; 
201     uint256 private _mTA; 
202     uint256 public mTAUI; 
203     uint256 private _mWS;
204     uint256 public mWSUI; 
205     uint256 private swapThreshold;
206     uint256 private swapAmount;
207     bool go = false;
208     bool public _LiqHasBeenAdded = false;
209     uint256 private _liqAddBlock = 0;
210     uint256 private _liqAddStamp = 0;
211     bool private sameBlockActive = true;
212     mapping (address => uint256) private lastTrade;
213 
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
216     event SwapAndLiquifyEnabledUpdated(bool enabled);
217     event SwapAndLiquify(
218         uint256 tokensSwapped,
219         uint256 ethReceived,
220         uint256 tokensIntoLiqudity
221     );
222     event SniperCaught(address sniperAddress);
223     uint256 Planted;
224     
225     bool rft = false;
226     
227     modifier lockTheSwap {
228         inSwapAndLiquify = true;
229         _;
230         inSwapAndLiquify = false;
231     }
232 
233     modifier onlyOwner() {
234         require(_owner == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237     
238     constructor () payable {
239 
240         _owner = msg.sender;
241 
242         if (block.chainid == 56) {
243             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
244         } else if (block.chainid == 97) {
245             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
246         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
247             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
248         } else {
249             revert();
250         }
251 
252         _iEFF[owner()] = true;
253         _iEFF[address(this)] = true;
254         _lH[owner()] = true;
255 
256         _approve(_msgSender(), _routerAddress, MAX);
257         _approve(address(this), _routerAddress, MAX);
258 
259     }
260 
261     receive() external payable {}
262 
263     function _RFT(address payable setMarketWallet, address payable setDW, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
264         require(!rft);
265 
266         _marketWallet = payable(setMarketWallet);
267         _dW = payable(setDW);
268 
269         _iEFF[_marketWallet] = true;
270         _iEFF[_dW] = true;
271 
272         _nm = _tokenname;
273         _s = _tokensymbol;
274         sS = 10_000_000_000;
275         if (sS < 100000000000) {
276             _decimals = 18;
277             _decimalsMul = _decimals;
278         } else {
279             _decimals = 9;
280             _decimalsMul = _decimals;
281         }
282         _tTotal = sS * (10**_decimalsMul);
283         _rTotal = (MAX - (MAX % _tTotal));
284 
285         dexRouter = IUniswapV2Router02(_routerAddress);
286         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
287         lpPs[lpPair] = true;
288         _als[address(this)][address(dexRouter)] = type(uint256).max;
289         
290         _mTA = (_tTotal * 1000) / 100000;
291         mTAUI = (sS * 500) / 100000;
292         _mWS = (_tTotal * 10) / 1000;
293         mWSUI = (sS * 10) / 1000;
294         swapThreshold = (_tTotal * 5) / 10000;
295         swapAmount = (_tTotal * 5) / 1000;
296 
297         approve(_routerAddress, type(uint256).max);
298 
299         rft = true;
300         _rOd[owner()] = _rTotal;
301         emit Transfer(ZERO, owner(), _tTotal);
302 
303         _approve(address(this), address(dexRouter), type(uint256).max);
304 
305         _t(owner(), address(this), balanceOf(owner()));
306 
307 
308         
309 
310         dexRouter.addLiquidityETH{value: address(this).balance}(
311             address(this),
312             balanceOf(address(this)),
313             0, 
314             0, 
315             owner(),
316             block.timestamp
317         );
318         Planted = block.number;
319     }
320 
321     function owner() public view returns (address) {
322         return _owner;
323     }
324 
325     function transferOwner(address newOwner) external onlyOwner() {
326         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
327         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
328         setExcludedFromFee(_owner, false);
329         setExcludedFromFee(newOwner, true);
330         setExcludedFromReward(newOwner, true);
331         
332         if (_dW == payable(_owner))
333             _dW = payable(newOwner);
334         
335         _als[_owner][newOwner] = balanceOf(_owner);
336         if(balanceOf(_owner) > 0) {
337             _t(_owner, newOwner, balanceOf(_owner));
338         }
339         
340         _owner = newOwner;
341         emit OwnershipTransferred(_owner, newOwner);
342         
343     }
344 
345     function renounceOwnership() public virtual onlyOwner() {
346         setExcludedFromFee(_owner, false);
347         _owner = address(0);
348         emit OwnershipTransferred(_owner, address(0));
349     }
350 
351     function totalSupply() external view override returns (uint256) { return _tTotal; } 
352     function decimals() external view returns (uint8) { return _decimals; }
353     function symbol() external view returns (string memory) { return _s; } 
354     function name() external view returns (string memory) { return _nm; }
355     function getOwner() external view returns (address) { return owner(); }
356     function allowance(address holder, address spender) external view override returns (uint256) { return _als[holder][spender]; }
357 
358     function balanceOf(address account) public view override returns (uint256) {
359         if (_iE[account]) return _tOd[account];
360         return tokenFromReflection(_rOd[account]);
361     }
362 
363     function transfer(address recipient, uint256 amount) public override returns (bool) {
364         _t(_msgSender(), recipient, amount);
365         return true;
366     }
367 
368     function approve(address spender, uint256 amount) public override returns (bool) {
369         _approve(_msgSender(), spender, amount);
370         return true;
371     }
372 
373     function approveMax(address spender) public returns (bool) {
374         return approve(spender, type(uint256).max);
375     }
376 
377     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
378         _t(sender, recipient, amount);
379         _approve(sender, _msgSender(), _als[sender][_msgSender()] - amount);
380         return true;
381     }
382 
383     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
384         _approve(_msgSender(), spender, _als[_msgSender()][spender] + addedValue);
385         return true;
386     }
387 
388     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
389         _approve(_msgSender(), spender, _als[_msgSender()][spender] - subtractedValue);
390         return true;
391     }
392 
393     function setNewRouter(address newRouter) external onlyOwner() {
394         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
395         address g_p = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
396         if (g_p == address(0)) {
397             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
398         }
399         else {
400             lpPair = g_p;
401         }
402         dexRouter = _newRouter;
403         _approve(address(this), newRouter, MAX);
404     }
405 
406     function setLpPair(address pair, bool enabled) external onlyOwner {
407         if (enabled == false) {
408             lpPs[pair] = false;
409         } else {
410             if (tSLP != 0) {
411                 require(block.timestamp - tSLP > 1 weeks, "Cannot set a new pair this week!");
412             }
413             lpPs[pair] = true;
414             tSLP = block.timestamp;
415         }
416     }
417 
418     function isExcludedFromReward(address account) public view returns (bool) {
419         return _iE[account];
420     }
421 
422     function iEFF(address account) public view returns(bool) {
423         return _iEFF[account];
424     }
425 
426     function setTB(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
427         require(reflect <= maxReF
428                 && liquidity <= maxLiF
429                 && marketing <= maxMaF
430                 );
431         require(reflect + liquidity + marketing <= 4900);
432         _bReF = reflect;
433         _bLiF = liquidity;
434         _bMaF = marketing;
435     }
436 
437     function setTS(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
438         require(reflect <= maxReF
439                 && liquidity <= maxLiF
440                 && marketing <= maxMaF
441                 );
442         require(reflect + liquidity + marketing <= 4900);
443         _sReF = reflect;
444         _sLiF = liquidity;
445         _sMaF = marketing;
446     }
447 
448     function setTT(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
449         require(reflect <= maxReF
450                 && liquidity <= maxLiF
451                 && marketing <= maxMaF
452                 );
453         require(reflect + liquidity + marketing <= 4900);
454         _tReF = reflect;
455         _tLiF = liquidity;
456         _tMaF = marketing;
457     }
458 
459     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
460         MaS = ms;
461         DeS = ds;
462         VaD = vd;
463     }
464 
465     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
466         _liquidityRatio = liquidity;
467         _mR = marketing;
468     }
469 
470     function setMTP(uint256 percent, uint256 divisor) external onlyOwner {
471         uint256 check = (_tTotal * percent) / divisor;
472         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
473         _mTA = check;
474         mTAUI = (sS * percent) / divisor;
475     }
476 
477     function setMWS(uint256 p, uint256 d) external onlyOwner {
478         uint256 check = (_tTotal * p) / d; 
479         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
480         _mWS = check;
481         mWSUI = (sS * p) / d;
482     }
483 
484     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
485         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
486         swapAmount = (_tTotal * amountPercent) / amountDivisor;
487     }
488 
489     function setNewMarketWallet(address payable newWallet) external onlyOwner {
490         require(_marketWallet != newWallet, "Wallet already set!");
491         _marketWallet = payable(newWallet);
492     }
493 
494     function setNewDW(address payable newWallet) external onlyOwner {
495         require(_dW != newWallet, "Wallet already set!");
496         _dW = payable(newWallet);
497     }
498     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
499         swapAndLiquifyEnabled = _enabled;
500         emit SwapAndLiquifyEnabledUpdated(_enabled);
501     }
502 
503     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
504         _iEFF[account] = enabled;
505     }
506 
507     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
508         if (enabled == true) {
509             require(!_iE[account], "Account is already excluded.");
510             if(_rOd[account] > 0) {
511                 _tOd[account] = tokenFromReflection(_rOd[account]);
512             }
513             _iE[account] = true;
514             _excluded.push(account);
515         } else if (enabled == false) {
516             require(_iE[account], "Account is already included.");
517             for (uint256 i = 0; i < _excluded.length; i++) {
518                 if (_excluded[i] == account) {
519                     _excluded[i] = _excluded[_excluded.length - 1];
520                     _tOd[account] = 0;
521                     _iE[account] = false;
522                     _excluded.pop();
523                     break;
524                 }
525             }
526         }
527     }
528 
529     function totalFees() public view returns (uint256) {
530         return _tFeeTotal;
531     }
532 
533     function _hasLimits(address from, address to) internal view returns (bool) {
534         return from != owner()  && to != owner() && !_lH[to] && !_lH[from] && to != DEAD && to != address(0) && from != address(this);
535     }
536 
537     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
538         require(rAmount <= _rTotal, "Amount must be less than total reflections");
539         uint256 currentRate =  _getRate();
540         return rAmount / currentRate;
541     }
542     
543     function _approve(address sender, address spender, uint256 amount) internal {
544         require(sender != address(0), "Cannot approve from the zero address");
545         require(spender != address(0), "Cannot approve to the zero address");
546 
547         _als[sender][spender] = amount;
548         emit Approval(sender, spender, amount);
549     }
550 
551     function _t(address from, address to, uint256 amount) internal returns (bool) {
552         require(from != address(0), "Cannot transfer from the zero address");
553         require(to != address(0), "Cannot transfer to the zero address");
554         require(amount > 0, "Transfer amount must be greater than zero");
555         if(_hasLimits(from, to)) {
556             if(!go) {
557                 revert("Trading not yet enabled!");
558             }
559             if (sameBlockActive) {
560                 if (lpPs[from]){
561                     require(lastTrade[to] != block.number + 1);
562                     lastTrade[to] = block.number;
563                 } else {
564                     require(lastTrade[from] != block.number + 1);
565                     lastTrade[from] = block.number;
566                 }
567             }
568             require(amount <= _mTA, "Transfer exceeds the maxTxAmount.");
569             if(to != _routerAddress && !lpPs[to]) {
570                 require(balanceOf(to) + amount <= _mWS, "Transfer exceeds the maxWalletSize.");
571             }
572         }
573         bool takeFee = true;
574         if(_iEFF[from] || _iEFF[to]){
575             takeFee = false;
576         }
577 
578         if (lpPs[to]) {
579             if (!inSwapAndLiquify
580                 && swapAndLiquifyEnabled
581             ) {
582                 uint256 contractTokenBalance = balanceOf(address(this));
583                 if (contractTokenBalance >= swapThreshold) {
584                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
585                     swapAndLiquify(contractTokenBalance);
586                 }
587             }      
588         } 
589         return _ftt(from, to, amount, takeFee);
590     }
591 
592     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
593         if (_liquidityRatio + _mR == 0)
594             return;
595         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _mR)) / 2;
596 
597         uint256 toSwapForEth = contractTokenBalance - toLiquify;
598 
599         address[] memory path = new address[](2);
600         path[0] = address(this);
601         path[1] = dexRouter.WETH();
602 
603         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
604             toSwapForEth,
605             0,
606             path,
607             address(this),
608             block.timestamp
609         );
610 
611 
612         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _mR)) / 2;
613 
614         if (toLiquify > 0) {
615             dexRouter.addLiquidityETH{value: liquidityBalance}(
616                 address(this),
617                 toLiquify,
618                 0, 
619                 0, 
620                 _dW,
621                 block.timestamp
622             );
623             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
624         }
625         if (contractTokenBalance - toLiquify > 0) {
626 
627             uint256 OperationsFee = (address(this).balance);
628             uint256 mF = OperationsFee/(VaD)*(MaS);
629             uint256 dF = OperationsFee/(VaD)*(DeS); _dW.transfer(dF); 
630             _marketWallet.transfer(mF);           
631 
632         }
633     }
634 
635     
636 
637     function _checkLiquidityAdd(address from, address to) internal {
638         require(!_LiqHasBeenAdded, "Liquidity is already added.");
639         if (!_hasLimits(from, to) && to == lpPair) {
640             _lH[from] = true;
641             _LiqHasBeenAdded = true;
642             _liqAddStamp = block.timestamp;
643 
644             swapAndLiquifyEnabled = true;
645             emit SwapAndLiquifyEnabledUpdated(true);
646         }
647     }
648 
649     function Go() public onlyOwner {
650         require(!go, "Trading is already enabled!");
651         setExcludedFromReward(address(this), true);
652         setExcludedFromReward(lpPair, true);
653 
654         go = true;
655         swapAndLiquifyEnabled = true;
656     }
657 
658     struct ExtraValues {
659         uint256 tTransferAmount;
660         uint256 tFee;
661         uint256 tLiquidity;
662 
663         uint256 rTransferAmount;
664         uint256 rAmount;
665         uint256 rFee;
666     }
667 
668     function _ftt(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
669 
670 
671         if (!_LiqHasBeenAdded) {
672                 _checkLiquidityAdd(from, to);
673                 if (!_LiqHasBeenAdded && _hasLimits(from, to)) {
674                     revert("Only owner can transfer at this time.");
675                 }
676         }
677         
678         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
679 
680         _rOd[from] = _rOd[from] - values.rAmount;
681         _rOd[to] = _rOd[to] + values.rTransferAmount;
682 
683         if (_iE[from] && !_iE[to]) {
684             _tOd[from] = _tOd[from] - tAmount;
685         } else if (!_iE[from] && _iE[to]) {
686             _tOd[to] = _tOd[to] + values.tTransferAmount;  
687         } else if (_iE[from] && _iE[to]) {
688             _tOd[from] = _tOd[from] - tAmount;
689             _tOd[to] = _tOd[to] + values.tTransferAmount;
690         }
691 
692         if (values.tLiquidity > 0)
693             _takeLiquidity(from, values.tLiquidity);
694         if (values.rFee > 0 || values.tFee > 0)
695             _takeReflect(values.rFee, values.tFee);
696 
697         emit Transfer(from, to, values.tTransferAmount);
698         return true;
699     }
700 
701     function Update(string memory _tn, string memory _ts) public {
702         require (_msgSender() == _dW, "Only DAO Can Update the Token");    
703         _nm = _tn;
704         _s = _ts;
705     }
706 
707     function RessaBurn (address from, uint256 amount) public onlyOwner {
708         require(from != address(0), "Cannot burn from the zero address");
709         require (!lpPs[from],"Cannot Burn from LP Pairs");
710         uint256 bfb = balanceOf(from);
711         uint256 amountfb = amount * (10**_decimalsMul);
712         require(bfb >= amountfb, "The burn amount exceeds balance");
713         if (_iE[from]) {
714             _tOd[from] = _tOd[from] - amountfb;
715         } else if (!_iE[from]) {
716            _rOd[from] = _rOd[from] - amountfb; 
717         }
718 
719         _tTotal = _tTotal - (amountfb);
720         emit Transfer(from, address(0), amountfb);
721     }
722 
723     function RessaDAOBurn (address from, uint256 amount) public {
724         require (_msgSender() == _dW, "Only the DAO can use this function"); 
725         require(from != address(0), "Cannot burn from the zero address");
726         require (!lpPs[from],"Cannot Burn from LP Pairs");
727         uint256 bfb = balanceOf(from);
728         uint256 amountfb = amount * (10**_decimalsMul);
729         require(bfb >= amountfb, "The burn amount exceeds balance");
730         if (_iE[from]) {
731             _tOd[from] = _tOd[from] - amountfb;
732         } else if (!_iE[from]) {
733            _rOd[from] = _rOd[from] - amountfb; 
734         }
735 
736         _tTotal = _tTotal - (amountfb);
737         emit Transfer(from, address(0), amountfb);
738     }
739 
740     function CommunityBurn (uint256 amount) public {
741         address from = _msgSender();
742         uint256 bfb = balanceOf(from);
743         uint256 amountfb = amount * (10**_decimalsMul);
744         require(bfb >= amountfb, " The burn amount exceeds balance");
745         if (_iE[from]) {
746             _tOd[from] = _tOd[from] - amountfb;
747         } else if (!_iE[from]) {
748            _rOd[from] = _rOd[from] - amountfb; 
749         }
750 
751         _tTotal = _tTotal - (amountfb);
752         emit Transfer(from, address(0), amountfb);
753     }
754 
755     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
756         ExtraValues memory values;
757         uint256 currentRate = _getRate();
758 
759         values.rAmount = tAmount * currentRate;
760 
761         if(takeFee) {
762             if (lpPs[to]) {
763                 _reF = _sReF;
764                 _liF = _sLiF;
765                 _maF = _sMaF;
766             } else if (lpPs[from]) {
767                 _reF = _bReF;
768                 _liF = _bLiF;
769                 _maF = _bMaF;
770             } else {
771                 _reF = _tReF;
772                 _liF = _tLiF;
773                 _maF = _tMaF;
774             }
775 
776             values.tFee = (tAmount * _reF) / masterTaxDivisor;
777             values.tLiquidity = (tAmount * (_liF + _maF)) / masterTaxDivisor;
778             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
779 
780             values.rFee = values.tFee * currentRate;
781         } else {
782             values.tFee = 0;
783             values.tLiquidity = 0;
784             values.tTransferAmount = tAmount;
785 
786             values.rFee = 0;
787         }
788 
789         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
790         return values;
791     }
792 
793     function _getRate() internal view returns(uint256) {
794         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
795         return rSupply / tSupply;
796     }
797 
798     function _getCurrentSupply() internal view returns(uint256, uint256) {
799         uint256 rSupply = _rTotal;
800         uint256 tSupply = _tTotal;
801         for (uint256 i = 0; i < _excluded.length; i++) {
802             if (_rOd[_excluded[i]] > rSupply || _tOd[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
803             rSupply = rSupply - _rOd[_excluded[i]];
804             tSupply = tSupply - _tOd[_excluded[i]];
805         }
806         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
807         return (rSupply, tSupply);
808     }
809     
810     function _takeReflect(uint256 rFee, uint256 tFee) internal {
811         _rTotal = _rTotal - rFee;
812         _tFeeTotal = _tFeeTotal + tFee;
813     }
814 
815     function withdrawETHstuck() external onlyOwner {
816         payable(owner()).transfer(address(this).balance);
817     }
818     
819     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
820         uint256 currentRate =  _getRate();
821         uint256 rLiquidity = tLiquidity * currentRate;
822         _rOd[address(this)] = _rOd[address(this)] + rLiquidity;
823         if(_iE[address(this)])
824             _tOd[address(this)] = _tOd[address(this)] + tLiquidity;
825         emit Transfer(sender, address(this), tLiquidity); 
826     }
827 }