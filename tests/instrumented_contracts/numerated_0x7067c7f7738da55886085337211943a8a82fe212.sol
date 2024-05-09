1 //SPDX-License-Identifier: Unlicensed
2 
3 /* 
4 
5 https://t.me/MishyCoinEth
6 https://twitter.com/MishyCoin
7 https://mishyeth.com/
8 
9 
10 
11 */
12 
13 pragma solidity 0.8.20;
14 
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41 
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 library SafeMath {
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90 
91         return c;
92     }
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 }
124 
125 abstract contract Context {
126     function _msgSender() internal view returns (address payable) {
127         return payable(msg.sender);
128     }
129 
130     function _msgData() internal view returns (bytes memory) {
131         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
132         return msg.data;
133     }
134 }
135 
136 interface IDEXFactory {
137     function createPair(address tokenA, address tokenB) external returns (address pair);
138 }
139 
140 interface IPancakePair {
141     function sync() external;
142 }
143 
144 interface IDEXRouter {
145 
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint amountTokenDesired,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline
156     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
157 
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165 
166 }
167 
168 contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     /**
174      * @dev Initializes the contract setting the deployer as the initial owner.
175      */
176     constructor () {
177         address msgSender = _msgSender();
178         _owner = msgSender;
179         emit OwnershipTransferred(address(0), msgSender);
180     }
181 
182     /**
183      * @dev Returns the address of the current owner.
184      */
185     function owner() public view returns (address) {
186         return _owner;
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196      /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public virtual onlyOwner {
204         emit OwnershipTransferred(_owner, address(0));
205         _owner = address(0);
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         emit OwnershipTransferred(_owner, newOwner);
215         _owner = newOwner;
216     }
217 }
218 
219 contract Mishy is IERC20, Ownable {
220     using SafeMath for uint256;
221     
222     address WETH;
223     address constant DEAD          = 0x000000000000000000000000000000000000dEaD;
224     address constant ZERO          = 0x0000000000000000000000000000000000000000;
225 
226     string _name = "Mishy";
227     string _symbol = "MISHY";
228     uint8 constant _decimals = 18;
229 
230     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
231     uint256 public _maxTxAmount = (_totalSupply * 1) / 100;
232     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;   
233 
234     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
235     mapping (address => uint256) public _rOwned;
236     uint256 public _totalProportion = _totalSupply;
237 
238     mapping (address => mapping (address => uint256)) _allowances;
239 
240     
241     mapping (address => bool) isFeeExempt;
242     mapping (address => bool) isTxLimitExempt;
243  
244     uint256 liquidityFeeBuy = 8; 
245     uint256 liquidityFeeSell = 10;
246 
247     uint256 TeamFeeBuy = 7;  
248     uint256 TeamFeeSell = 10;  
249 
250     uint256 marketingFeeBuy = 10;   
251     uint256 marketingFeeSell = 20;   
252 
253     uint256 reflectionFeeBuy = 0;   
254     uint256 reflectionFeeSell = 0;   
255 
256     uint256 totalFeeBuy = marketingFeeBuy + liquidityFeeBuy + TeamFeeBuy + reflectionFeeBuy;     
257     uint256 totalFeeSell = marketingFeeSell + liquidityFeeSell + TeamFeeSell + reflectionFeeSell; 
258 
259     uint256 feeDenominator = 100; 
260        
261     address autoLiquidityReceiver;
262     address marketingFeeReceiver;
263     address TeamFeeReceiver;
264 
265     uint256 targetLiquidity = 30;
266     uint256 targetLiquidityDenominator = 100;
267 
268     IDEXRouter public router;
269     address public pair;
270 
271     bool public tradingOpen = false;
272     
273     bool public claimingFees = true; 
274     bool alternateSwaps = true;
275     uint256 smallSwapThreshold = _totalSupply * 50 / 1000;
276     uint256 largeSwapThreshold = _totalSupply * 30 / 1000;
277 
278     uint256 public swapThreshold = smallSwapThreshold;
279     bool inSwap;
280     modifier swapping() { inSwap = true; _; inSwap = false; }
281 
282     constructor () {
283 
284         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
285         WETH = router.WETH();
286         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
287 
288         _allowances[address(this)][address(router)] = type(uint256).max;
289         _allowances[address(this)][msg.sender] = type(uint256).max;
290 
291         isTxLimitExempt[address(this)] = true;
292         isTxLimitExempt[address(router)] = true;
293 	    isTxLimitExempt[pair] = true;
294         isTxLimitExempt[msg.sender] = true;
295         isTxLimitExempt[marketingFeeReceiver] = true;
296         isFeeExempt[msg.sender] = true;
297 
298         autoLiquidityReceiver = msg.sender; 
299         TeamFeeReceiver = msg.sender;
300         marketingFeeReceiver = 0x9CEf1ab789B7Fc502b4818759Dd28E9f377DDa79;
301 
302         _rOwned[msg.sender] = _totalSupply;
303         emit Transfer(address(0), msg.sender, _totalSupply);
304     }
305 
306     receive() external payable { }
307 
308     function totalSupply() external view override returns (uint256) { return _totalSupply; }
309     function decimals() external pure returns (uint8) { return _decimals; }
310     function name() external view returns (string memory) { return _name; }
311     function symbol() external view returns (string memory) { return _symbol; }
312     function getOwner() external view returns (address) { return owner(); }
313     function balanceOf(address account) public view override returns (uint256) { return tokenFromReflection(_rOwned[account]); }
314     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
315     
316     
317 
318     function approve(address spender, uint256 amount) public override returns (bool) {
319         _allowances[msg.sender][spender] = amount;
320         emit Approval(msg.sender, spender, amount);
321         return true;
322     }
323 
324     function approveMax(address spender) external returns (bool) {
325         return approve(spender, type(uint256).max);
326     }
327 
328     function transfer(address recipient, uint256 amount) external override returns (bool) {
329         return _transferFrom(msg.sender, recipient, amount);
330     }
331 
332     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
333         if(_allowances[sender][msg.sender] != type(uint256).max){
334             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
335         }
336 
337         return _transferFrom(sender, recipient, amount);
338     }
339 
340     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
341         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
342 
343         if (recipient != pair && recipient != DEAD && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]) {
344             require(balanceOf(recipient) + amount <= _maxWalletSize, "Max Wallet Exceeded");
345 
346         }
347 
348         if(!isTxLimitExempt[sender]) {
349             require(amount <= _maxTxAmount, "Transaction Amount Exceeded");
350         }
351      
352         if (recipient != pair && recipient != DEAD && !isTxLimitExempt[recipient]) {
353             require(tradingOpen,"Trading not open yet");
354         
355         }
356 
357         if(shouldSwapBack()){ swapBack(); }
358 
359         uint256 proportionAmount = tokensToProportion(amount);
360 
361         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
362 
363         uint256 proportionReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFeeInProportions(sender == pair? true : false, sender, recipient, proportionAmount) : proportionAmount;
364         _rOwned[recipient] = _rOwned[recipient].add(proportionReceived);
365 
366         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
367         return true;
368     }
369 
370     function tokensToProportion(uint256 tokens) public view returns (uint256) {
371         return tokens.mul(_totalProportion).div(_totalSupply);
372     }
373 
374     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
375         return proportion.mul(_totalSupply).div(_totalProportion);
376     }
377 
378     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
379         uint256 proportionAmount = tokensToProportion(amount);
380         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
381         _rOwned[recipient] = _rOwned[recipient].add(proportionAmount);
382         emit Transfer(sender, recipient, amount);
383         return true;
384     }
385 
386     function shouldTakeFee(address sender) internal view returns (bool) {
387         return !isFeeExempt[sender];
388 
389     }
390 
391      function checkTxLimit(address sender, uint256 amount) internal view {
392         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
393     }
394 
395     function getTotalFeeBuy(bool) public view returns (uint256) {
396         return totalFeeBuy;
397     }
398 
399     function getTotalFeeSell(bool) public view returns (uint256) {
400         return totalFeeSell;
401     }
402 
403     function takeFeeInProportions(bool buying, address sender, address receiver, uint256 proportionAmount) internal returns (uint256) {
404         uint256 proportionFeeAmount = buying == true? proportionAmount.mul(getTotalFeeBuy(receiver == pair)).div(feeDenominator) :
405         proportionAmount.mul(getTotalFeeSell(receiver == pair)).div(feeDenominator);
406 
407         // reflect
408         uint256 proportionReflected = buying == true? proportionFeeAmount.mul(reflectionFeeBuy).div(totalFeeBuy) :
409         proportionFeeAmount.mul(reflectionFeeSell).div(totalFeeSell);
410 
411         _totalProportion = _totalProportion.sub(proportionReflected);
412 
413         // take fees
414         uint256 _proportionToContract = proportionFeeAmount.sub(proportionReflected);
415         _rOwned[address(this)] = _rOwned[address(this)].add(_proportionToContract);
416 
417         emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
418         emit Reflect(proportionReflected, _totalProportion);
419         return proportionAmount.sub(proportionFeeAmount);
420     }
421 
422     function manualSend() external {
423         (bool success,) = payable(autoLiquidityReceiver).call{value: address(this).balance, gas: 30000}("");
424         require(success);
425        
426     }
427 
428      function clearStuckETH(uint256 amountPercentage) external {
429         uint256 amountETH = address(this).balance;
430         payable(autoLiquidityReceiver).transfer(amountETH * amountPercentage / 100);
431     }
432 
433      function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
434         require(isTxLimitExempt[msg.sender]);
435      if(tokens == 0){
436             tokens = IERC20(tokenAddress).balanceOf(address(this));
437         }
438         return IERC20(tokenAddress).transfer(msg.sender, tokens);
439     }
440 
441       
442     function setTarget(uint256 _target, uint256 _denominator) external onlyOwner {
443         targetLiquidity = _target;
444         targetLiquidityDenominator = _denominator;    
445     }
446 
447       function removeLimits() external onlyOwner { 
448         _maxWalletSize = _totalSupply;
449         _maxTxAmount = _totalSupply;
450 
451     }
452 
453     function shouldSwapBack() internal view returns (bool) {
454         return msg.sender != pair
455         && !inSwap
456         && claimingFees
457         && balanceOf(address(this)) >= swapThreshold;
458     }
459 
460     function swapBack() internal swapping {
461         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFeeSell;
462         uint256 _totalFee = totalFeeSell.sub(reflectionFeeSell);
463         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(_totalFee).div(2);
464         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
465 
466         address[] memory path = new address[](2);
467         path[0] = address(this);
468         path[1] = WETH;
469 
470         uint256 balanceBefore = address(this).balance;
471 
472         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
473             amountToSwap,
474             0,
475             path,
476             address(this),
477             block.timestamp
478         );
479 
480         uint256 amountETH = address(this).balance.sub(balanceBefore);
481 
482         uint256 totalETHFee = _totalFee.sub(dynamicLiquidityFee.div(2));
483         uint256 amountETHLiquidity = amountETH.mul(liquidityFeeSell).div(totalETHFee).div(2);
484         uint256 amountETHMarketing = amountETH.mul(marketingFeeSell).div(totalETHFee);
485         uint256 amountETHTeam = amountETH.mul(TeamFeeSell).div(totalETHFee);
486 
487         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
488         (tmpSuccess,) = payable(TeamFeeReceiver).call{value: amountETHTeam, gas: 30000}("");
489         
490         
491 
492         if(amountToLiquify > 0) {
493             router.addLiquidityETH{value: amountETHLiquidity}(
494                 address(this),
495                 amountToLiquify,
496                 0,
497                 0,
498                 autoLiquidityReceiver,
499                 block.timestamp
500             );
501             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
502         }
503 
504         swapThreshold = !alternateSwaps ? swapThreshold : swapThreshold == smallSwapThreshold ? largeSwapThreshold : smallSwapThreshold;
505     }
506 
507     function setSwapBackSettings(bool _enabled, uint256 _amountS, uint256 _amountL, bool _alternate) external onlyOwner {
508         alternateSwaps = _alternate;
509         claimingFees = _enabled;
510         smallSwapThreshold = _amountS;
511         largeSwapThreshold = _amountL;
512         swapThreshold = smallSwapThreshold;
513     }
514 
515         
516      // Allow Trading
517     function setTradingOpen() public onlyOwner {
518         tradingOpen = true;
519     
520     }
521 
522     function setFees(uint256 _liquidityFeeBuy, uint256 _reflectionFeeBuy, uint256 _marketingFeeBuy, uint256 _TeamFeeBuy, uint256 _feeDenominator,
523     uint256 _liquidityFeeSell, uint256 _reflectionFeeSell, uint256 _marketingFeeSell, uint256 _TeamFeeSell) external onlyOwner {
524         liquidityFeeBuy = _liquidityFeeBuy;
525         reflectionFeeBuy = _reflectionFeeBuy;
526         marketingFeeBuy = _marketingFeeBuy;
527         TeamFeeBuy = _TeamFeeBuy;
528         totalFeeBuy = liquidityFeeBuy.add(reflectionFeeBuy).add(marketingFeeBuy).add(TeamFeeBuy);
529 
530         liquidityFeeSell = _liquidityFeeSell;
531         reflectionFeeSell = _reflectionFeeSell;
532         marketingFeeSell = _marketingFeeSell;
533         TeamFeeSell = _TeamFeeSell;
534         totalFeeSell = liquidityFeeSell.add(reflectionFeeSell).add(marketingFeeSell).add(TeamFeeSell);
535 
536         feeDenominator = _feeDenominator;
537         
538      }
539 
540     function setMaxWalletPercent(uint256 maxWallPercent) external onlyOwner() {
541         require(maxWallPercent >= 1);
542         _maxWalletSize = (_totalSupply * maxWallPercent ) / 1000;
543     }
544 
545     function setMaxTxPercent(uint256 maxTXPercentage) external onlyOwner() {
546         require(maxTXPercentage >= 1);
547         _maxTxAmount = (_totalSupply * maxTXPercentage ) / 1000;
548     }
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
563     function setFeeReceivers(address _marketingFeeReceiver, address _liquidityReceiver, address _TeamFeeReceiver) external onlyOwner {
564        
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