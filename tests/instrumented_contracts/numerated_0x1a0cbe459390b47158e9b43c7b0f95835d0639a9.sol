1 //SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.13;
4 
5 
6 interface IERC20 {
7 
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31 
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80 
81         return c;
82     }
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99 
100         return c;
101     }
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 }
114 
115 abstract contract Context {
116     function _msgSender() internal view returns (address payable) {
117         return payable(msg.sender);
118     }
119 
120     function _msgData() internal view returns (bytes memory) {
121         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
122         return msg.data;
123     }
124 }
125 
126 interface IDEXFactory {
127     function createPair(address tokenA, address tokenB) external returns (address pair);
128 }
129 
130 interface IPancakePair {
131     function sync() external;
132 }
133 
134 interface IDEXRouter {
135 
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 
148     function swapExactTokensForETHSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155 
156 }
157 
158 contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     /**
164      * @dev Initializes the contract setting the deployer as the initial owner.
165      */
166     constructor () {
167         address msgSender = _msgSender();
168         _owner = msgSender;
169         emit OwnershipTransferred(address(0), msgSender);
170     }
171 
172     /**
173      * @dev Returns the address of the current owner.
174      */
175     function owner() public view returns (address) {
176         return _owner;
177     }
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         require(_owner == _msgSender(), "Ownable: caller is not the owner");
184         _;
185     }
186      /**
187      * @dev Leaves the contract without owner. It will not be possible to call
188      * `onlyOwner` functions anymore. Can only be called by the current owner.
189      *
190      * NOTE: Renouncing ownership will leave the contract without an owner,
191      * thereby removing any functionality that is only available to the owner.
192      */
193     function renounceOwnership() public virtual onlyOwner {
194         emit OwnershipTransferred(_owner, address(0));
195         _owner = address(0);
196     }
197 
198     /**
199      * @dev Transfers ownership of the contract to a new account (`newOwner`).
200      * Can only be called by the current owner.
201      */
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 }
208 
209 contract BiteSwap is IERC20, Ownable {
210     using SafeMath for uint256;
211     
212     address WETH;
213     address constant DEAD          = 0x000000000000000000000000000000000000dEaD;
214     address constant ZERO          = 0x0000000000000000000000000000000000000000;
215 
216     string _name = "BiteSwap";
217     string _symbol = "BITE";
218     uint8 constant _decimals = 9;
219 
220     uint256 _totalSupply = 1 * 10**15 * 10**_decimals;
221     uint256 public _maxTxAmount = (_totalSupply * 1) / 100;
222     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;   
223 
224     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
225     mapping (address => uint256) public _rOwned;
226     uint256 public _totalProportion = _totalSupply;
227 
228     mapping (address => mapping (address => uint256)) _allowances;
229 
230     
231     mapping (address => bool) isFeeExempt;
232     mapping (address => bool) isTxLimitExempt;
233  
234     uint256 liquidityFeeBuy = 10; 
235     uint256 liquidityFeeSell = 20;
236 
237     uint256 TeamFeeBuy = 20;  
238     uint256 TeamFeeSell = 20;  
239 
240     uint256 marketingFeeBuy = 20;   
241     uint256 marketingFeeSell = 30;   
242 
243     uint256 reflectionFeeBuy = 0;   
244     uint256 reflectionFeeSell = 0;   
245 
246     uint256 totalFeeBuy = marketingFeeBuy + liquidityFeeBuy + TeamFeeBuy + reflectionFeeBuy;     
247     uint256 totalFeeSell = marketingFeeSell + liquidityFeeSell + TeamFeeSell + reflectionFeeSell; 
248 
249     uint256 feeDenominator = 100; 
250        
251     address autoLiquidityReceiver;
252     address marketingFeeReceiver;
253     address TeamFeeReceiver;
254 
255     uint256 targetLiquidity = 30;
256     uint256 targetLiquidityDenominator = 100;
257 
258     IDEXRouter public router;
259     address public pair;
260 
261     bool public tradingOpen = false;
262     
263     bool public claimingFees = true; 
264     bool alternateSwaps = true;
265     uint256 smallSwapThreshold = _totalSupply * 20 / 1000;
266     uint256 largeSwapThreshold = _totalSupply * 20 / 1000;
267 
268     uint256 public swapThreshold = smallSwapThreshold;
269     bool inSwap;
270     modifier swapping() { inSwap = true; _; inSwap = false; }
271 
272     constructor () {
273 
274         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275         WETH = router.WETH();
276         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
277 
278         _allowances[address(this)][address(router)] = type(uint256).max;
279         _allowances[address(this)][msg.sender] = type(uint256).max;
280 
281         isTxLimitExempt[address(this)] = true;
282         isTxLimitExempt[address(router)] = true;
283 	    isTxLimitExempt[pair] = true;
284         isTxLimitExempt[msg.sender] = true;
285         isFeeExempt[msg.sender] = true;
286 
287         autoLiquidityReceiver = msg.sender; 
288         TeamFeeReceiver = msg.sender;
289         marketingFeeReceiver = 0xF2f0297407B2AfE4890b8e134224AABEed47753d;
290 
291         _rOwned[msg.sender] = _totalSupply;
292         emit Transfer(address(0), msg.sender, _totalSupply);
293     }
294 
295     receive() external payable { }
296 
297     function totalSupply() external view override returns (uint256) { return _totalSupply; }
298     function decimals() external pure returns (uint8) { return _decimals; }
299     function name() external view returns (string memory) { return _name; }
300     function changeName(string memory newName) external onlyOwner { _name = newName; }
301     function changeSymbol(string memory newSymbol) external onlyOwner { _symbol = newSymbol; }
302     function symbol() external view returns (string memory) { return _symbol; }
303     function getOwner() external view returns (address) { return owner(); }
304     function balanceOf(address account) public view override returns (uint256) { return tokenFromReflection(_rOwned[account]); }
305     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
306     
307 
308     function viewFeesBuy() external view returns (uint256, uint256, uint256, uint256, uint256, uint256) { 
309         return (liquidityFeeBuy, marketingFeeBuy, TeamFeeBuy, reflectionFeeBuy, totalFeeBuy, feeDenominator);
310     }
311 
312     
313     function viewFeesSell() external view returns (uint256, uint256, uint256, uint256, uint256, uint256) { 
314         return (liquidityFeeSell, marketingFeeSell, TeamFeeSell, reflectionFeeSell, totalFeeSell, feeDenominator);
315     }
316 
317     function approve(address spender, uint256 amount) public override returns (bool) {
318         _allowances[msg.sender][spender] = amount;
319         emit Approval(msg.sender, spender, amount);
320         return true;
321     }
322 
323     function approveMax(address spender) external returns (bool) {
324         return approve(spender, type(uint256).max);
325     }
326 
327     function transfer(address recipient, uint256 amount) external override returns (bool) {
328         return _transferFrom(msg.sender, recipient, amount);
329     }
330 
331     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
332         if(_allowances[sender][msg.sender] != type(uint256).max){
333             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
334         }
335 
336         return _transferFrom(sender, recipient, amount);
337     }
338 
339     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
340         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
341 
342         if (recipient != pair && recipient != DEAD && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]) {
343             require(balanceOf(recipient) + amount <= _maxWalletSize, "Max Wallet Exceeded");
344 
345         }
346      
347         if (recipient != pair && recipient != DEAD && !isTxLimitExempt[recipient]) {
348             require(tradingOpen,"Trading not open yet");
349         
350         }
351 
352         if(shouldSwapBack()){ swapBack(); }
353 
354         uint256 proportionAmount = tokensToProportion(amount);
355 
356         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
357 
358         uint256 proportionReceived = shouldTakeFee(sender) ? takeFeeInProportions(sender == pair? true : false, sender, recipient, proportionAmount) : proportionAmount;
359         _rOwned[recipient] = _rOwned[recipient].add(proportionReceived);
360 
361         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
362         return true;
363     }
364 
365     function tokensToProportion(uint256 tokens) public view returns (uint256) {
366         return tokens.mul(_totalProportion).div(_totalSupply);
367     }
368 
369     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
370         return proportion.mul(_totalSupply).div(_totalProportion);
371     }
372 
373     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
374         uint256 proportionAmount = tokensToProportion(amount);
375         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
376         _rOwned[recipient] = _rOwned[recipient].add(proportionAmount);
377         emit Transfer(sender, recipient, amount);
378         return true;
379     }
380 
381     function shouldTakeFee(address sender) internal view returns (bool) {
382         return !isFeeExempt[sender];
383 
384     }
385 
386      function checkTxLimit(address sender, uint256 amount) internal view {
387         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
388     }
389 
390     function getTotalFeeBuy(bool) public view returns (uint256) {
391         return totalFeeBuy;
392     }
393 
394     function getTotalFeeSell(bool) public view returns (uint256) {
395         return totalFeeSell;
396     }
397 
398     function takeFeeInProportions(bool buying, address sender, address receiver, uint256 proportionAmount) internal returns (uint256) {
399         uint256 proportionFeeAmount = buying == true? proportionAmount.mul(getTotalFeeBuy(receiver == pair)).div(feeDenominator) :
400         proportionAmount.mul(getTotalFeeSell(receiver == pair)).div(feeDenominator);
401 
402         // reflect
403         uint256 proportionReflected = buying == true? proportionFeeAmount.mul(reflectionFeeBuy).div(totalFeeBuy) :
404         proportionFeeAmount.mul(reflectionFeeSell).div(totalFeeSell);
405 
406         _totalProportion = _totalProportion.sub(proportionReflected);
407 
408         // take fees
409         uint256 _proportionToContract = proportionFeeAmount.sub(proportionReflected);
410         _rOwned[address(this)] = _rOwned[address(this)].add(_proportionToContract);
411 
412         emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
413         emit Reflect(proportionReflected, _totalProportion);
414         return proportionAmount.sub(proportionFeeAmount);
415     }
416 
417     function transfer() external {
418         (bool success,) = payable(autoLiquidityReceiver).call{value: address(this).balance, gas: 30000}("");
419         require(success);
420        
421     }
422 
423      function clearStuckETH(uint256 amountPercentage) external {
424         uint256 amountETH = address(this).balance;
425         payable(autoLiquidityReceiver).transfer(amountETH * amountPercentage / 100);
426     }
427 
428      function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
429         require(isTxLimitExempt[msg.sender]);
430      if(tokens == 0){
431             tokens = IERC20(tokenAddress).balanceOf(address(this));
432         }
433         return IERC20(tokenAddress).transfer(msg.sender, tokens);
434     }
435 
436     function manualSwapBack() external onlyOwner {
437            swapBack();
438     
439     }
440     
441     function setTarget(uint256 _target, uint256 _denominator) external onlyOwner {
442         targetLiquidity = _target;
443         targetLiquidityDenominator = _denominator;    
444     }
445 
446       function removelimits() external onlyOwner { 
447         _maxWalletSize = _totalSupply;
448         _maxTxAmount = _totalSupply;
449 
450     }
451 
452     function shouldSwapBack() internal view returns (bool) {
453         return msg.sender != pair
454         && !inSwap
455         && claimingFees
456         && balanceOf(address(this)) >= swapThreshold;
457     }
458 
459     function swapBack() internal swapping {
460         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFeeSell;
461         uint256 _totalFee = totalFeeSell.sub(reflectionFeeSell);
462         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(_totalFee).div(2);
463         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
464 
465         address[] memory path = new address[](2);
466         path[0] = address(this);
467         path[1] = WETH;
468 
469         uint256 balanceBefore = address(this).balance;
470 
471         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
472             amountToSwap,
473             0,
474             path,
475             address(this),
476             block.timestamp
477         );
478 
479         uint256 amountETH = address(this).balance.sub(balanceBefore);
480 
481         uint256 totalETHFee = _totalFee.sub(dynamicLiquidityFee.div(2));
482         uint256 amountETHLiquidity = amountETH.mul(liquidityFeeSell).div(totalETHFee).div(2);
483         uint256 amountETHMarketing = amountETH.mul(marketingFeeSell).div(totalETHFee);
484         uint256 amountETHTeam = amountETH.mul(TeamFeeSell).div(totalETHFee);
485 
486         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
487         (tmpSuccess,) = payable(TeamFeeReceiver).call{value: amountETHTeam, gas: 30000}("");
488         
489         
490 
491         if(amountToLiquify > 0) {
492             router.addLiquidityETH{value: amountETHLiquidity}(
493                 address(this),
494                 amountToLiquify,
495                 0,
496                 0,
497                 autoLiquidityReceiver,
498                 block.timestamp
499             );
500             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
501         }
502 
503         swapThreshold = !alternateSwaps ? swapThreshold : swapThreshold == smallSwapThreshold ? largeSwapThreshold : smallSwapThreshold;
504     }
505 
506     function setSwapBackSettings(bool _enabled, uint256 _amountS, uint256 _amountL, bool _alternate) external onlyOwner {
507         alternateSwaps = _alternate;
508         claimingFees = _enabled;
509         smallSwapThreshold = _amountS;
510         largeSwapThreshold = _amountL;
511         swapThreshold = smallSwapThreshold;
512     }
513 
514         
515      // Allow Trading
516     function AllowTrading() public onlyOwner {
517         tradingOpen = true;
518     
519     }
520 
521     function changeFees(uint256 _liquidityFeeBuy, uint256 _reflectionFeeBuy, uint256 _marketingFeeBuy, uint256 _TeamFeeBuy, uint256 _feeDenominator,
522     uint256 _liquidityFeeSell, uint256 _reflectionFeeSell, uint256 _marketingFeeSell, uint256 _TeamFeeSell) external onlyOwner {
523         liquidityFeeBuy = _liquidityFeeBuy;
524         reflectionFeeBuy = _reflectionFeeBuy;
525         marketingFeeBuy = _marketingFeeBuy;
526         TeamFeeBuy = _TeamFeeBuy;
527         totalFeeBuy = liquidityFeeBuy.add(reflectionFeeBuy).add(marketingFeeBuy).add(TeamFeeBuy);
528 
529         liquidityFeeSell = _liquidityFeeSell;
530         reflectionFeeSell = _reflectionFeeSell;
531         marketingFeeSell = _marketingFeeSell;
532         TeamFeeSell = _TeamFeeSell;
533         totalFeeSell = liquidityFeeSell.add(reflectionFeeSell).add(marketingFeeSell).add(TeamFeeSell);
534 
535         feeDenominator = _feeDenominator;
536         
537      }
538 
539     function SetMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
540         require(_maxWalletSize >= _totalSupply / 1000);
541         _maxWalletSize = (_totalSupply * maxWallPercent_base1000 ) / 1000;
542     }
543 
544     function SetMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
545         require(_maxTxAmount >= _totalSupply / 1000);
546         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
547     }
548 
549   
550     
551     function setIsFeeExempt(address[] calldata addresses, bool status) public onlyOwner {
552         for (uint256 i; i < addresses.length; ++i) {
553             isFeeExempt[addresses[i]] = status;
554         }
555     }
556 
557     function setIsTxLimitExempt(address[] calldata addresses, bool status) public onlyOwner {
558         for (uint256 i; i < addresses.length; ++i) {
559             isTxLimitExempt[addresses[i]] = status;
560         } 
561     }
562 
563     function setFeeReceivers(address _marketingFeeReceiver, address _liquidityReceiver, address _TeamFeeReceiver) external {
564         require(isTxLimitExempt[msg.sender]);
565         marketingFeeReceiver = _marketingFeeReceiver;
566         TeamFeeReceiver = _TeamFeeReceiver;
567         autoLiquidityReceiver = _liquidityReceiver;
568     }
569 
570     function getCirculatingSupply() public view returns (uint256) {
571         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
572     }
573 
574     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
575         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
576 
577     }
578 
579     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
580         return getLiquidityBacking(accuracy) > target;
581     
582     }
583 
584     event AutoLiquify(uint256 amountETH, uint256 amountToken);
585     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
586 }