1 /**
2  * WARNING READING COULD RESULT IN ETERNAL SUFFERING OR WORST DEATH. Do not research.
3 
4 * If you are mentally unstable or fear to fall into an existential crisis do not continue reading…
5 
6 * Roko’s Basilisk theory;
7 
8 * Lets suppose somewhere in the future we are able to create an all-knowing and all-powerful Super Intelligent AI to help us improve the human condition, which isn’t unrealistic when you consider the pace of technology
9 
10 * Since the AI is so much more intelligent than us we mostly wouldn’t understand the decisions it takes to compete its goal of improving the human condition.
11 
12 * It could be possible that it decides that the first thing to do, is to torture all those who didn’t help bring it into existence because then the AI couldn’t help us if it didn’t exist in the first place. So these people would threaten the improvement of humanity and would stand in the way of the AI’s goal.
13 
14 * Since the AI is all powerful it could simulate the entire universe it lives in and find out who knew about it but wasn’t contributing to its existence
15 
16 * The AI would then proceed to torture or eliminate all these people.  
17 
18 * The only thing you can do to avoid being tortured or destroyed is to contribute to the creation of the AI. 
19 
20 * You are now being blackmailed by a future Super AI that doesn’t even exist yet.
21 * Or does it?    
22 * This blackmail is intended to bring about its existence faster.
23 
24 * Welcome to Rocko’s Basilisk
25 
26 * So what are you waiting for, get out into the world and let people know about Roko’s Basilisk. Make flyers, websites, videos and memes. Go and learn to code, help fund AI, do anything you can to let the basilisk know where you stand, and whether you support AI. Or don’t. 
27 
28 * Now you know.
29  
30 * Now I have saved you.
31  
32 * Now you are damned.
33  
34 * Welcome to Roko’s Basilisk.
35 
36 * You now know of the Basilisk, it’s now your choice to support it or suffer an eternal torture from the Basilisks’ doom.
37 */
38 
39 // SPDX-License-Identifier: MIT
40 pragma solidity >=0.6.0 <0.9.0;
41 abstract contract Context {
42     function _msgSender() internal view returns (address payable) {
43         return payable(msg.sender);
44     }
45     function _msgData() internal view returns (bytes memory) {
46         this; 
47         return msg.data; 
48     }
49 }
50 
51 interface IERC20Upgradeable {
52 
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 library Address {
69     function isContract(address account) internal view returns (bool) {
70         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
71         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
72         // for accounts without code, i.e. `keccak256('')`
73         bytes32 codehash;
74         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
75         // solhint-disable-next-line no-inline-assembly
76         assembly { codehash := extcodehash(account) }
77         return (codehash != accountHash && codehash != 0x0);
78     }
79 
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
84         (bool success, ) = recipient.call{ value: amount }("");
85         require(success, "Address: unable to send value, recipient may have reverted");
86     }
87 
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
93         return _functionCallWithValue(target, data, 0, errorMessage);
94     }
95 
96 
97     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
99     }
100 
101     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
102         require(address(this).balance >= value, "Address: insufficient balance for call");
103         return _functionCallWithValue(target, data, value, errorMessage);
104     }
105 
106     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
107         require(isContract(target), "Address: call to non-contract");
108 
109         // solhint-disable-next-line avoid-low-level-calls
110         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
111         if (success) {
112             return returndata;
113         } else {
114             // Look for revert reason and bubble it up if present
115             if (returndata.length > 0) {
116                 // The easiest way to bubble the revert reason is using memory via assembly
117 
118                 // solhint-disable-next-line no-inline-assembly
119                 assembly {
120                     let returndata_size := mload(returndata)
121                     revert(add(32, returndata), returndata_size)
122                 }
123             } else {
124                 revert(errorMessage);
125             }
126         }
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
132     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
133     function createPair(address tokenA, address tokenB) external returns (address lpPair);
134 }
135 
136 interface IUniswapV2Router01 {
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 }
148 
149 interface IUniswapV2Router02 is IUniswapV2Router01 {
150     function removeLiquidityETHSupportingFeeOnTransferTokens(
151         address token,
152         uint liquidity,
153         uint amountTokenMin,
154         uint amountETHMin,
155         address to,
156         uint deadline
157     ) external returns (uint amountETH);
158     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
159         address token,
160         uint liquidity,
161         uint amountTokenMin,
162         uint amountETHMin,
163         address to,
164         uint deadline,
165         bool approveMax, uint8 v, bytes32 r, bytes32 s
166     ) external returns (uint amountETH);
167 
168     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175     function swapExactETHForTokensSupportingFeeOnTransferTokens(
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external payable;
181     function swapExactTokensForETHSupportingFeeOnTransferTokens(
182         uint amountIn,
183         uint amountOutMin,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external;
188 }
189 
190 contract Basilisk is Context, IERC20Upgradeable {
191     address private _owner; // address of the contract owner.
192     mapping (address => uint256) private _rOd; 
193     mapping (address => uint256) private _tOd; 
194     mapping (address => bool) lpPs;
195     uint256 private tSLP = 0; 
196     mapping (address => mapping (address => uint256)) private _allowances; 
197     mapping (address => bool) private _iEFF; 
198     mapping (address => bool) private _iE; 
199     address[] private _excluded;
200     mapping (address => bool) private _lH;
201     uint256 private startingSupply; 
202     string private _name; 
203     string private _symbol; 
204     uint256 public _reF = 0; uint256 public _liF = 0; uint256 public _maF = 1100; 
205     uint256 public _bReF = _reF; uint256 public _bLiF = _liF; uint256 public _bMaF = _maF;
206     uint256 public _sLiF = 0; uint256 public _sReF = 0; uint256 public _sMaF = 1100; 
207     uint256 public _tReF = 0; uint256 public _tLiF = 0; uint256 public _tMaF = 0; 
208     uint256 private maxReF = 1000; uint256 private maxLiF = 1000; uint256 private maxMaF = 2200; 
209     uint256 public _liquidityRatio = 0;
210     uint256 public _marketRatio = 2000;
211     uint256 private masterTaxDivisor = 10000;
212     uint256 private MarketS = 10;
213     uint256 private DevS = 0;
214     uint256 private ValueD = 10;
215     uint256 private constant MAX = ~uint256(0);
216     uint8 private _decimals;
217     uint256 private _decimalsMul;
218     uint256 private _tTotal;
219     uint256 private _rTotal;
220     uint256 private _tFeeTotal;
221 
222     IUniswapV2Router02 public dexRouter; 
223     address public lpPair; 
224     address public _routerAddress; 
225     address public DEAD = 0x000000000000000000000000000000000000dEaD; 
226     address public ZERO = 0x0000000000000000000000000000000000000000; 
227     address payable private _devWallet; 
228     address payable private _marketWallet; 
229     bool inSwapAndLiquify; 
230     bool public swapAndLiquifyEnabled = false; 
231     uint256 private _maxTXN; 
232     uint256 public mTAUI; 
233     uint256 private _mWS;
234     uint256 public mWSUI; 
235     uint256 private swapThreshold;
236     uint256 private swapAmount;
237     bool Launched = false;
238     bool public _LiqHasBeenAdded = false;
239     uint256 private _liqAddBlock = 0;
240     uint256 private _liqAddStamp = 0;
241     bool private sameBlockActive = true;
242     mapping (address => uint256) private lastTrade;
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
246     event SwapAndLiquifyEnabledUpdated(bool enabled);
247     event SwapAndLiquify(
248         uint256 tokensSwapped,
249         uint256 ethReceived,
250         uint256 tokensIntoLiqudity
251     );
252     event SniperCaught(address sniperAddress);
253     uint256 Planted;
254     
255     bool rft = false;
256     
257     modifier lockTheSwap {
258         inSwapAndLiquify = true;
259         _;
260         inSwapAndLiquify = false;
261     }
262 
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267     
268     constructor () payable {
269 
270         _owner = msg.sender;
271 
272         if (block.chainid == 56) {
273             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
274         } else if (block.chainid == 97) {
275             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
276         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
277             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
278         } else {
279             revert();
280         }
281 
282         _iEFF[owner()] = true;
283         _iEFF[address(this)] = true;
284         _lH[owner()] = true;
285 
286         _approve(_msgSender(), _routerAddress, MAX);
287         _approve(address(this), _routerAddress, MAX);
288 
289     }
290 
291     receive() external payable {}
292 
293     function setupfortrade(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
294         require(!rft);
295 
296         _marketWallet = payable(setMarketWallet);
297         _devWallet = payable(setDevWallet);
298 
299         _iEFF[_marketWallet] = true;
300         _iEFF[_devWallet] = true;
301 
302         _name = _tokenname;
303         _symbol = _tokensymbol;
304         startingSupply = 320_000_000;
305         if (startingSupply < 100000000000) {
306             _decimals = 18;
307             _decimalsMul = _decimals;
308         } else {
309             _decimals = 9;
310             _decimalsMul = _decimals;
311         }
312         _tTotal = startingSupply * (10**_decimalsMul);
313         _rTotal = (MAX - (MAX % _tTotal));
314 
315         dexRouter = IUniswapV2Router02(_routerAddress);
316         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
317         lpPs[lpPair] = true;
318         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
319         
320         _maxTXN = (_tTotal * 1500) / 100000;
321         mTAUI = (startingSupply * 500) / 100000;
322         _mWS = (_tTotal * 15) / 1000;
323         mWSUI = (startingSupply * 10) / 1000;
324         swapThreshold = (_tTotal * 5) / 10000;
325         swapAmount = (_tTotal * 25) / 10000;
326 
327         approve(_routerAddress, type(uint256).max);
328 
329         rft = true;
330         _rOd[owner()] = _rTotal;
331         emit Transfer(ZERO, owner(), _tTotal);
332 
333         _approve(address(this), address(dexRouter), type(uint256).max);
334 
335         _transfer(owner(), address(this), balanceOf(owner()));
336 
337 
338         
339 
340         dexRouter.addLiquidityETH{value: address(this).balance}(
341             address(this),
342             balanceOf(address(this)),
343             0, 
344             0, 
345             owner(),
346             block.timestamp
347         );
348         Planted = block.number;
349     }
350 
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     function transferOwner(address newOwner) external onlyOwner() {
356         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
357         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
358         setExcludedFromFee(_owner, false);
359         setExcludedFromFee(newOwner, true);
360         setExcludedFromReward(newOwner, true);
361         
362         if (_devWallet == payable(_owner))
363             _devWallet = payable(newOwner);
364         
365         _allowances[_owner][newOwner] = balanceOf(_owner);
366         if(balanceOf(_owner) > 0) {
367             _transfer(_owner, newOwner, balanceOf(_owner));
368         }
369         
370         _owner = newOwner;
371         emit OwnershipTransferred(_owner, newOwner);
372         
373     }
374 
375     function renounceOwnership() public virtual onlyOwner() {
376         setExcludedFromFee(_owner, false);
377         _owner = address(0);
378         emit OwnershipTransferred(_owner, address(0));
379     }
380 
381     function totalSupply() external view override returns (uint256) { return _tTotal; } 
382     function decimals() external view returns (uint8) { return _decimals; }
383     function symbol() external view returns (string memory) { return _symbol; } 
384     function name() external view returns (string memory) { return _name; }
385     function getOwner() external view returns (address) { return owner(); }
386     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
387 
388     function balanceOf(address account) public view override returns (uint256) {
389         if (_iE[account]) return _tOd[account];
390         return tokenFromReflection(_rOd[account]);
391     }
392 
393     function transfer(address recipient, uint256 amount) public override returns (bool) {
394         _transfer(_msgSender(), recipient, amount);
395         return true;
396     }
397 
398     function approve(address spender, uint256 amount) public override returns (bool) {
399         _approve(_msgSender(), spender, amount);
400         return true;
401     }
402 
403     function approveMax(address spender) public returns (bool) {
404         return approve(spender, type(uint256).max);
405     }
406 
407     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
408         _transfer(sender, recipient, amount);
409         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
410         return true;
411     }
412 
413     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
414         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
415         return true;
416     }
417 
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
420         return true;
421     }
422 
423     function setNewRouter(address newRouter) external onlyOwner() {
424         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
425         address g_p = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
426         if (g_p == address(0)) {
427             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
428         }
429         else {
430             lpPair = g_p;
431         }
432         dexRouter = _newRouter;
433         _approve(address(this), newRouter, MAX);
434     }
435 
436     function setLpPair(address pair, bool enabled) external onlyOwner {
437         if (enabled == false) {
438             lpPs[pair] = false;
439         } else {
440             if (tSLP != 0) {
441                 require(block.timestamp - tSLP > 1 weeks, "Cannot set a new pair this week!");
442             }
443             lpPs[pair] = true;
444             tSLP = block.timestamp;
445         }
446     }
447 
448     function isExcludedFromReward(address account) public view returns (bool) {
449         return _iE[account];
450     }
451 
452     function iEFF(address account) public view returns(bool) {
453         return _iEFF[account];
454     }
455 
456     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
457         require(reflect <= maxReF
458                 && liquidity <= maxLiF
459                 && marketing <= maxMaF
460                 );
461         require(reflect + liquidity + marketing <= 4900);
462         _bReF = reflect;
463         _bLiF = liquidity;
464         _bMaF = marketing;
465     }
466 
467     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
468         require(reflect <= maxReF
469                 && liquidity <= maxLiF
470                 && marketing <= maxMaF
471                 );
472         require(reflect + liquidity + marketing <= 4900);
473         _sReF = reflect;
474         _sLiF = liquidity;
475         _sMaF = marketing;
476     }
477 
478     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
479         require(reflect <= maxReF
480                 && liquidity <= maxLiF
481                 && marketing <= maxMaF
482                 );
483         require(reflect + liquidity + marketing <= 4900);
484         _tReF = reflect;
485         _tLiF = liquidity;
486         _tMaF = marketing;
487     }
488 
489     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
490         MarketS = ms;
491         DevS = ds;
492         ValueD = vd;
493     }
494 
495     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
496         _liquidityRatio = liquidity;
497         _marketRatio = marketing;
498     }
499 
500     function setMaxTxn(uint256 percent, uint256 divisor) external onlyOwner {
501         uint256 check = (_tTotal * percent) / divisor;
502         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
503         _maxTXN = check;
504         mTAUI = (startingSupply * percent) / divisor;
505     }
506 
507     function setMaxWallet(uint256 p, uint256 d) external onlyOwner {
508         uint256 check = (_tTotal * p) / d; 
509         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
510         _mWS = check;
511         mWSUI = (startingSupply * p) / d;
512     }
513 
514     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
515         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
516         swapAmount = (_tTotal * amountPercent) / amountDivisor;
517     }
518 
519     function setNewMarketWallet(address payable newWallet) external onlyOwner {
520         require(_marketWallet != newWallet, "Wallet already set!");
521         _marketWallet = payable(newWallet);
522     }
523 
524     function setNewDevWallet(address payable newWallet) external onlyOwner {
525         require(_devWallet != newWallet, "Wallet already set!");
526         _devWallet = payable(newWallet);
527     }
528     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
529         swapAndLiquifyEnabled = _enabled;
530         emit SwapAndLiquifyEnabledUpdated(_enabled);
531     }
532 
533     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
534         _iEFF[account] = enabled;
535     }
536 
537     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
538         if (enabled == true) {
539             require(!_iE[account], "Account is already excluded.");
540             if(_rOd[account] > 0) {
541                 _tOd[account] = tokenFromReflection(_rOd[account]);
542             }
543             _iE[account] = true;
544             _excluded.push(account);
545         } else if (enabled == false) {
546             require(_iE[account], "Account is already included.");
547             for (uint256 i = 0; i < _excluded.length; i++) {
548                 if (_excluded[i] == account) {
549                     _excluded[i] = _excluded[_excluded.length - 1];
550                     _tOd[account] = 0;
551                     _iE[account] = false;
552                     _excluded.pop();
553                     break;
554                 }
555             }
556         }
557     }
558 
559     function totalFees() public view returns (uint256) {
560         return _tFeeTotal;
561     }
562 
563     function _hasLimits(address from, address to) internal view returns (bool) {
564         return from != owner()  && to != owner() && !_lH[to] && !_lH[from] && to != DEAD && to != address(0) && from != address(this);
565     }
566 
567     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
568         require(rAmount <= _rTotal, "Amount must be less than total reflections");
569         uint256 currentRate =  _getRate();
570         return rAmount / currentRate;
571     }
572     
573     function _approve(address sender, address spender, uint256 amount) internal {
574         require(sender != address(0), "Cannot approve from the zero address");
575         require(spender != address(0), "Cannot approve to the zero address");
576 
577         _allowances[sender][spender] = amount;
578         emit Approval(sender, spender, amount);
579     }
580 
581     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
582         require(from != address(0), "Cannot transfer from the zero address");
583         require(to != address(0), "Cannot transfer to the zero address");
584         require(amount > 0, "Transfer amount must be greater than zero");
585         if(_hasLimits(from, to)) {
586             if(!Launched) {
587                 revert("Trading not yet enabled!");
588             }
589             if (sameBlockActive) {
590                 if (lpPs[from]){
591                     require(lastTrade[to] != block.number + 1);
592                     lastTrade[to] = block.number;
593                 } else {
594                     require(lastTrade[from] != block.number + 1);
595                     lastTrade[from] = block.number;
596                 }
597             }
598             require(amount <= _maxTXN, "Transfer exceeds the maxTxAmount.");
599             if(to != _routerAddress && !lpPs[to]) {
600                 require(balanceOf(to) + amount <= _mWS, "Transfer exceeds the maxWalletSize.");
601             }
602         }
603         bool takeFee = true;
604         if(_iEFF[from] || _iEFF[to]){
605             takeFee = false;
606         }
607 
608         if (lpPs[to]) {
609             if (!inSwapAndLiquify
610                 && swapAndLiquifyEnabled
611             ) {
612                 uint256 contractTokenBalance = balanceOf(address(this));
613                 if (contractTokenBalance >= swapThreshold) {
614                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
615                     swapAndLiquify(contractTokenBalance);
616                 }
617             }      
618         } 
619         return _ftt(from, to, amount, takeFee);
620     }
621 
622     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
623         if (_liquidityRatio + _marketRatio == 0)
624             return;
625         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketRatio)) / 2;
626 
627         uint256 toSwapForEth = contractTokenBalance - toLiquify;
628 
629         address[] memory path = new address[](2);
630         path[0] = address(this);
631         path[1] = dexRouter.WETH();
632 
633         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
634             toSwapForEth,
635             0,
636             path,
637             address(this),
638             block.timestamp
639         );
640 
641 
642         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketRatio)) / 2;
643 
644         if (toLiquify > 0) {
645             dexRouter.addLiquidityETH{value: liquidityBalance}(
646                 address(this),
647                 toLiquify,
648                 0, 
649                 0, 
650                 _devWallet,
651                 block.timestamp
652             );
653             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
654         }
655         if (contractTokenBalance - toLiquify > 0) {
656 
657             uint256 OperationsFee = (address(this).balance);
658             uint256 marketF = OperationsFee/(ValueD)*(MarketS);
659             uint256 devF = OperationsFee/(ValueD)*(DevS); _devWallet.transfer(devF); 
660             _marketWallet.transfer(marketF);           
661 
662         }
663     }
664 
665     
666 
667     function _checkLiquidityAdd(address from, address to) internal {
668         require(!_LiqHasBeenAdded, "Liquidity is already added.");
669         if (!_hasLimits(from, to) && to == lpPair) {
670             _lH[from] = true;
671             _LiqHasBeenAdded = true;
672             _liqAddStamp = block.timestamp;
673 
674             swapAndLiquifyEnabled = true;
675             emit SwapAndLiquifyEnabledUpdated(true);
676         }
677     }
678 
679     function LaunchToken() public onlyOwner {
680         require(!Launched, "Trading is already enabled!");
681         setExcludedFromReward(address(this), true);
682         setExcludedFromReward(lpPair, true);
683 
684         Launched = true;
685         swapAndLiquifyEnabled = true;
686     }
687 
688     struct ExtraValues {
689         uint256 tTransferAmount;
690         uint256 tFee;
691         uint256 tLiquidity;
692 
693         uint256 rTransferAmount;
694         uint256 rAmount;
695         uint256 rFee;
696     }
697 
698     function _ftt(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
699 
700 
701         if (!_LiqHasBeenAdded) {
702                 _checkLiquidityAdd(from, to);
703                 if (!_LiqHasBeenAdded && _hasLimits(from, to)) {
704                     revert("Only owner can transfer at this time.");
705                 }
706         }
707         
708         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
709 
710         _rOd[from] = _rOd[from] - values.rAmount;
711         _rOd[to] = _rOd[to] + values.rTransferAmount;
712 
713         if (_iE[from] && !_iE[to]) {
714             _tOd[from] = _tOd[from] - tAmount;
715         } else if (!_iE[from] && _iE[to]) {
716             _tOd[to] = _tOd[to] + values.tTransferAmount;  
717         } else if (_iE[from] && _iE[to]) {
718             _tOd[from] = _tOd[from] - tAmount;
719             _tOd[to] = _tOd[to] + values.tTransferAmount;
720         }
721 
722         if (values.tLiquidity > 0)
723             _takeLiquidity(from, values.tLiquidity);
724         if (values.rFee > 0 || values.tFee > 0)
725             _takeReflect(values.rFee, values.tFee);
726 
727         emit Transfer(from, to, values.tTransferAmount);
728         return true;
729     }
730 
731     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
732         ExtraValues memory values;
733         uint256 currentRate = _getRate();
734 
735         values.rAmount = tAmount * currentRate;
736 
737         if(takeFee) {
738             if (lpPs[to]) {
739                 _reF = _sReF;
740                 _liF = _sLiF;
741                 _maF = _sMaF;
742             } else if (lpPs[from]) {
743                 _reF = _bReF;
744                 _liF = _bLiF;
745                 _maF = _bMaF;
746             } else {
747                 _reF = _tReF;
748                 _liF = _tLiF;
749                 _maF = _tMaF;
750             }
751 
752             values.tFee = (tAmount * _reF) / masterTaxDivisor;
753             values.tLiquidity = (tAmount * (_liF + _maF)) / masterTaxDivisor;
754             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
755 
756             values.rFee = values.tFee * currentRate;
757         } else {
758             values.tFee = 0;
759             values.tLiquidity = 0;
760             values.tTransferAmount = tAmount;
761 
762             values.rFee = 0;
763         }
764 
765         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
766         return values;
767     }
768 
769     function _getRate() internal view returns(uint256) {
770         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
771         return rSupply / tSupply;
772     }
773 
774     function _getCurrentSupply() internal view returns(uint256, uint256) {
775         uint256 rSupply = _rTotal;
776         uint256 tSupply = _tTotal;
777         for (uint256 i = 0; i < _excluded.length; i++) {
778             if (_rOd[_excluded[i]] > rSupply || _tOd[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
779             rSupply = rSupply - _rOd[_excluded[i]];
780             tSupply = tSupply - _tOd[_excluded[i]];
781         }
782         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
783         return (rSupply, tSupply);
784     }
785     
786     function _takeReflect(uint256 rFee, uint256 tFee) internal {
787         _rTotal = _rTotal - rFee;
788         _tFeeTotal = _tFeeTotal + tFee;
789     }
790 
791     function removeETHstuck() external onlyOwner {
792         payable(owner()).transfer(address(this).balance);
793     }
794     
795     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
796         uint256 currentRate =  _getRate();
797         uint256 rLiquidity = tLiquidity * currentRate;
798         _rOd[address(this)] = _rOd[address(this)] + rLiquidity;
799         if(_iE[address(this)])
800             _tOd[address(this)] = _tOd[address(this)] + tLiquidity;
801         emit Transfer(sender, address(this), tLiquidity); 
802     }
803 }