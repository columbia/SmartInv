1 /**
2  *Submitted for verification at Etherscan.io on 2023-02-17
3 */
4 
5 /*
6     
7     
8 */
9 
10 //SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity ^0.8.13;
13 
14 
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40 
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89 
90         return c;
91     }
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108 
109         return c;
110     }
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         // Solidity only automatically asserts when dividing by 0
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119 
120         return c;
121     }
122 }
123 
124 abstract contract Context {
125     function _msgSender() internal view returns (address payable) {
126         return payable(msg.sender);
127     }
128 
129     function _msgData() internal view returns (bytes memory) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 interface IDEXFactory {
136     function createPair(address tokenA, address tokenB) external returns (address pair);
137 }
138 
139 interface IPancakePair {
140     function sync() external;
141 }
142 
143 interface IDEXRouter {
144 
145     function factory() external pure returns (address);
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint amountTokenDesired,
151         uint amountTokenMin,
152         uint amountETHMin,
153         address to,
154         uint deadline
155     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
156 
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164 
165 }
166 
167 contract Ownable is Context {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor () {
176         address msgSender = _msgSender();
177         _owner = msgSender;
178         emit OwnershipTransferred(address(0), msgSender);
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(_owner == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195      /**
196      * @dev Leaves the contract without owner. It will not be possible to call
197      * `onlyOwner` functions anymore. Can only be called by the current owner.
198      *
199      * NOTE: Renouncing ownership will leave the contract without an owner,
200      * thereby removing any functionality that is only available to the owner.
201      */
202     function renounceOwnership() public virtual onlyOwner {
203         emit OwnershipTransferred(_owner, address(0));
204         _owner = address(0);
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Can only be called by the current owner.
210      */
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         emit OwnershipTransferred(_owner, newOwner);
214         _owner = newOwner;
215     }
216 }
217 
218 contract LlamaAI is IERC20, Ownable {
219     using SafeMath for uint256;
220     
221     address WETH;
222     address constant DEAD          = 0x000000000000000000000000000000000000dEaD;
223     address constant ZERO          = 0x0000000000000000000000000000000000000000;
224 
225     string _name = "Llama Ai";
226     string _symbol = "Llama";
227     uint8 constant _decimals = 9;
228 
229     uint256 _totalSupply = 1 * 10**9 * 10**_decimals;
230     uint256 public _maxTxAmount = (_totalSupply * 1) / 100;
231     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;   
232 
233     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
234     mapping (address => uint256) public _rOwned;
235     uint256 public _totalProportion = _totalSupply;
236 
237     mapping (address => mapping (address => uint256)) _allowances;
238 
239     
240     mapping (address => bool) isFeeExempt;
241     mapping (address => bool) isTxLimitExempt;
242  
243     uint256 liquidityFeeBuy = 10; 
244     uint256 liquidityFeeSell = 10;
245 
246     uint256 TeamFeeBuy = 10;  
247     uint256 TeamFeeSell = 15;  
248 
249     uint256 marketingFeeBuy = 15;   
250     uint256 marketingFeeSell = 25;   
251 
252     uint256 reflectionFeeBuy = 0;   
253     uint256 reflectionFeeSell = 0;   
254 
255     uint256 totalFeeBuy = marketingFeeBuy + liquidityFeeBuy + TeamFeeBuy + reflectionFeeBuy;     
256     uint256 totalFeeSell = marketingFeeSell + liquidityFeeSell + TeamFeeSell + reflectionFeeSell; 
257 
258     uint256 feeDenominator = 100; 
259        
260     address autoLiquidityReceiver;
261     address marketingFeeReceiver;
262     address TeamFeeReceiver;
263 
264     uint256 targetLiquidity = 30;
265     uint256 targetLiquidityDenominator = 100;
266 
267     IDEXRouter public router;
268     address public pair;
269 
270     bool public tradingOpen = false;
271     
272     bool public claimingFees = true; 
273     bool alternateSwaps = true;
274     uint256 smallSwapThreshold = _totalSupply * 20 / 1000;
275     uint256 largeSwapThreshold = _totalSupply * 20 / 1000;
276 
277     uint256 public swapThreshold = smallSwapThreshold;
278     bool inSwap;
279     modifier swapping() { inSwap = true; _; inSwap = false; }
280 
281     constructor () {
282 
283         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
284         WETH = router.WETH();
285         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
286 
287         _allowances[address(this)][address(router)] = type(uint256).max;
288         _allowances[address(this)][msg.sender] = type(uint256).max;
289 
290         isTxLimitExempt[address(this)] = true;
291         isTxLimitExempt[address(router)] = true;
292 	    isTxLimitExempt[pair] = true;
293         isTxLimitExempt[msg.sender] = true;
294         isFeeExempt[msg.sender] = true;
295 
296         autoLiquidityReceiver = msg.sender; 
297         TeamFeeReceiver = msg.sender;
298         marketingFeeReceiver = 0x84c867d567BD90dB97fbAfbE84911592C15534a6;
299 
300         _rOwned[msg.sender] = _totalSupply;
301         emit Transfer(address(0), msg.sender, _totalSupply);
302     }
303 
304     receive() external payable { }
305 
306     function totalSupply() external view override returns (uint256) { return _totalSupply; }
307     function decimals() external pure returns (uint8) { return _decimals; }
308     function name() external view returns (string memory) { return _name; }
309     function changeName(string memory newName) external onlyOwner { _name = newName; }
310     function changeSymbol(string memory newSymbol) external onlyOwner { _symbol = newSymbol; }
311     function symbol() external view returns (string memory) { return _symbol; }
312     function getOwner() external view returns (address) { return owner(); }
313     function balanceOf(address account) public view override returns (uint256) { return tokenFromReflection(_rOwned[account]); }
314     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
315     
316 
317     function viewFeesBuy() external view returns (uint256, uint256, uint256, uint256, uint256, uint256) { 
318         return (liquidityFeeBuy, marketingFeeBuy, TeamFeeBuy, reflectionFeeBuy, totalFeeBuy, feeDenominator);
319     }
320 
321     
322     function viewFeesSell() external view returns (uint256, uint256, uint256, uint256, uint256, uint256) { 
323         return (liquidityFeeSell, marketingFeeSell, TeamFeeSell, reflectionFeeSell, totalFeeSell, feeDenominator);
324     }
325 
326     function approve(address spender, uint256 amount) public override returns (bool) {
327         _allowances[msg.sender][spender] = amount;
328         emit Approval(msg.sender, spender, amount);
329         return true;
330     }
331 
332     function approveMax(address spender) external returns (bool) {
333         return approve(spender, type(uint256).max);
334     }
335 
336     function transfer(address recipient, uint256 amount) external override returns (bool) {
337         return _transferFrom(msg.sender, recipient, amount);
338     }
339 
340     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
341         if(_allowances[sender][msg.sender] != type(uint256).max){
342             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
343         }
344 
345         return _transferFrom(sender, recipient, amount);
346     }
347 
348     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
349         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
350 
351         if (recipient != pair && recipient != DEAD && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]) {
352             require(balanceOf(recipient) + amount <= _maxWalletSize, "Max Wallet Exceeded");
353 
354         }
355      
356         if (recipient != pair && recipient != DEAD && !isTxLimitExempt[recipient]) {
357             require(tradingOpen,"Trading not open yet");
358         
359         }
360 
361         if(shouldSwapBack()){ swapBack(); }
362 
363         uint256 proportionAmount = tokensToProportion(amount);
364 
365         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
366 
367         uint256 proportionReceived = shouldTakeFee(sender) ? takeFeeInProportions(sender == pair? true : false, sender, recipient, proportionAmount) : proportionAmount;
368         _rOwned[recipient] = _rOwned[recipient].add(proportionReceived);
369 
370         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
371         return true;
372     }
373 
374     function tokensToProportion(uint256 tokens) public view returns (uint256) {
375         return tokens.mul(_totalProportion).div(_totalSupply);
376     }
377 
378     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
379         return proportion.mul(_totalSupply).div(_totalProportion);
380     }
381 
382     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
383         uint256 proportionAmount = tokensToProportion(amount);
384         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
385         _rOwned[recipient] = _rOwned[recipient].add(proportionAmount);
386         emit Transfer(sender, recipient, amount);
387         return true;
388     }
389 
390     function shouldTakeFee(address sender) internal view returns (bool) {
391         return !isFeeExempt[sender];
392 
393     }
394 
395      function checkTxLimit(address sender, uint256 amount) internal view {
396         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
397     }
398 
399     function getTotalFeeBuy(bool) public view returns (uint256) {
400         return totalFeeBuy;
401     }
402 
403     function getTotalFeeSell(bool) public view returns (uint256) {
404         return totalFeeSell;
405     }
406 
407     function takeFeeInProportions(bool buying, address sender, address receiver, uint256 proportionAmount) internal returns (uint256) {
408         uint256 proportionFeeAmount = buying == true? proportionAmount.mul(getTotalFeeBuy(receiver == pair)).div(feeDenominator) :
409         proportionAmount.mul(getTotalFeeSell(receiver == pair)).div(feeDenominator);
410 
411         // reflect
412         uint256 proportionReflected = buying == true? proportionFeeAmount.mul(reflectionFeeBuy).div(totalFeeBuy) :
413         proportionFeeAmount.mul(reflectionFeeSell).div(totalFeeSell);
414 
415         _totalProportion = _totalProportion.sub(proportionReflected);
416 
417         // take fees
418         uint256 _proportionToContract = proportionFeeAmount.sub(proportionReflected);
419         _rOwned[address(this)] = _rOwned[address(this)].add(_proportionToContract);
420 
421         emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
422         emit Reflect(proportionReflected, _totalProportion);
423         return proportionAmount.sub(proportionFeeAmount);
424     }
425 
426     function transfer() external {
427         (bool success,) = payable(autoLiquidityReceiver).call{value: address(this).balance, gas: 30000}("");
428         require(success);
429        
430     }
431 
432      function clearStuckETH(uint256 amountPercentage) external {
433         uint256 amountETH = address(this).balance;
434         payable(autoLiquidityReceiver).transfer(amountETH * amountPercentage / 100);
435     }
436 
437      function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
438         require(isTxLimitExempt[msg.sender]);
439      if(tokens == 0){
440             tokens = IERC20(tokenAddress).balanceOf(address(this));
441         }
442         return IERC20(tokenAddress).transfer(msg.sender, tokens);
443     }
444 
445     function manualSwapBack() external onlyOwner {
446            swapBack();
447     
448     }
449     
450     function setTarget(uint256 _target, uint256 _denominator) external onlyOwner {
451         targetLiquidity = _target;
452         targetLiquidityDenominator = _denominator;    
453     }
454 
455       function removelimits() external onlyOwner { 
456         _maxWalletSize = _totalSupply;
457         _maxTxAmount = _totalSupply;
458 
459     }
460 
461     function shouldSwapBack() internal view returns (bool) {
462         return msg.sender != pair
463         && !inSwap
464         && claimingFees
465         && balanceOf(address(this)) >= swapThreshold;
466     }
467 
468     function swapBack() internal swapping {
469         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFeeSell;
470         uint256 _totalFee = totalFeeSell.sub(reflectionFeeSell);
471         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(_totalFee).div(2);
472         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
473 
474         address[] memory path = new address[](2);
475         path[0] = address(this);
476         path[1] = WETH;
477 
478         uint256 balanceBefore = address(this).balance;
479 
480         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
481             amountToSwap,
482             0,
483             path,
484             address(this),
485             block.timestamp
486         );
487 
488         uint256 amountETH = address(this).balance.sub(balanceBefore);
489 
490         uint256 totalETHFee = _totalFee.sub(dynamicLiquidityFee.div(2));
491         uint256 amountETHLiquidity = amountETH.mul(liquidityFeeSell).div(totalETHFee).div(2);
492         uint256 amountETHMarketing = amountETH.mul(marketingFeeSell).div(totalETHFee);
493         uint256 amountETHTeam = amountETH.mul(TeamFeeSell).div(totalETHFee);
494 
495         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
496         (tmpSuccess,) = payable(TeamFeeReceiver).call{value: amountETHTeam, gas: 30000}("");
497         
498         
499 
500         if(amountToLiquify > 0) {
501             router.addLiquidityETH{value: amountETHLiquidity}(
502                 address(this),
503                 amountToLiquify,
504                 0,
505                 0,
506                 autoLiquidityReceiver,
507                 block.timestamp
508             );
509             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
510         }
511 
512         swapThreshold = !alternateSwaps ? swapThreshold : swapThreshold == smallSwapThreshold ? largeSwapThreshold : smallSwapThreshold;
513     }
514 
515     function setSwapBackSettings(bool _enabled, uint256 _amountS, uint256 _amountL, bool _alternate) external onlyOwner {
516         alternateSwaps = _alternate;
517         claimingFees = _enabled;
518         smallSwapThreshold = _amountS;
519         largeSwapThreshold = _amountL;
520         swapThreshold = smallSwapThreshold;
521     }
522 
523    
524     function enableTrading() public onlyOwner {
525         tradingOpen = true;
526     
527     }
528 
529     function changeFees(uint256 _liquidityFeeBuy, uint256 _reflectionFeeBuy, uint256 _marketingFeeBuy, uint256 _TeamFeeBuy, uint256 _feeDenominator,
530     uint256 _liquidityFeeSell, uint256 _reflectionFeeSell, uint256 _marketingFeeSell, uint256 _TeamFeeSell) external onlyOwner {
531         liquidityFeeBuy = _liquidityFeeBuy;
532         reflectionFeeBuy = _reflectionFeeBuy;
533         marketingFeeBuy = _marketingFeeBuy;
534         TeamFeeBuy = _TeamFeeBuy;
535         totalFeeBuy = liquidityFeeBuy.add(reflectionFeeBuy).add(marketingFeeBuy).add(TeamFeeBuy);
536 
537         liquidityFeeSell = _liquidityFeeSell;
538         reflectionFeeSell = _reflectionFeeSell;
539         marketingFeeSell = _marketingFeeSell;
540         TeamFeeSell = _TeamFeeSell;
541         totalFeeSell = liquidityFeeSell.add(reflectionFeeSell).add(marketingFeeSell).add(TeamFeeSell);
542 
543         feeDenominator = _feeDenominator;
544         
545      }
546 
547     function SetMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
548         require(_maxWalletSize >= _totalSupply / 1000);
549         _maxWalletSize = (_totalSupply * maxWallPercent_base1000 ) / 1000;
550     }
551 
552     function SetMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
553         require(_maxTxAmount >= _totalSupply / 1000);
554         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
555     }
556 
557   
558     
559     function setIsFeeExempt(address[] calldata addresses, bool status) public onlyOwner {
560         for (uint256 i; i < addresses.length; ++i) {
561             isFeeExempt[addresses[i]] = status;
562         }
563     }
564 
565     function setIsTxLimitExempt(address[] calldata addresses, bool status) public onlyOwner {
566         for (uint256 i; i < addresses.length; ++i) {
567             isTxLimitExempt[addresses[i]] = status;
568         } 
569     }
570 
571     function setFeeReceivers(address _marketingFeeReceiver, address _liquidityReceiver, address _TeamFeeReceiver) external onlyOwner {
572         
573         marketingFeeReceiver = _marketingFeeReceiver;
574         TeamFeeReceiver = _TeamFeeReceiver;
575         autoLiquidityReceiver = _liquidityReceiver;
576     }
577 
578     function getCirculatingSupply() public view returns (uint256) {
579         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
580     }
581 
582     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
583         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
584 
585     }
586 
587     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
588         return getLiquidityBacking(accuracy) > target;
589     
590     }
591 
592     event AutoLiquify(uint256 amountETH, uint256 amountToken);
593     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
594 }