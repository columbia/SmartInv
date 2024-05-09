1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
4 
5 
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * [IMPORTANT]
11      * ====
12      * It is unsafe to assume that an address for which this function returns
13      * false is an externally-owned account (EOA) and not a contract.
14      *
15      * Among others, `isContract` will return false for the following
16      * types of addresses:
17      *
18      *  - an externally-owned account
19      *  - a contract in construction
20      *  - an address where a contract will be created
21      *  - an address where a contract lived, but was destroyed
22      * ====
23      */
24     function isContract(address account) internal view returns (bool) {
25         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
26         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
27         // for accounts without code, i.e. `keccak256('')`
28         bytes32 codehash;
29         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
30         // solhint-disable-next-line no-inline-assembly
31         assembly { codehash := extcodehash(account) }
32         return (codehash != accountHash && codehash != 0x0);
33     }
34 
35     /**
36      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
37      * `recipient`, forwarding all available gas and reverting on errors.
38      *
39      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
40      * of certain opcodes, possibly making contracts go over the 2300 gas limit
41      * imposed by `transfer`, making them unable to receive funds via
42      * `transfer`. {sendValue} removes this limitation.
43      *
44      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
45      *
46      * IMPORTANT: because control is transferred to `recipient`, care must be
47      * taken to not create reentrancy vulnerabilities. Consider using
48      * {ReentrancyGuard} or the
49      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
50      */
51     function sendValue(address payable recipient, uint256 amount) internal {
52         require(address(this).balance >= amount, "Address: insufficient balance");
53 
54         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
55         (bool success, ) = recipient.call{ value: amount }("");
56         require(success, "Address: unable to send value, recipient may have reverted");
57     }
58 
59     /**
60      * @dev Performs a Solidity function call using a low level `call`. A
61      * plain`call` is an unsafe replacement for a function call: use this
62      * function instead.
63      *
64      * If `target` reverts with a revert reason, it is bubbled up by this
65      * function (like regular Solidity function calls).
66      *
67      * Returns the raw returned data. To convert to the expected return value,
68      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
69      *
70      * Requirements:
71      *
72      * - `target` must be a contract.
73      * - calling `target` with `data` must not revert.
74      *
75      * _Available since v3.1._
76      */
77     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
78       return functionCall(target, data, "Address: low-level call failed");
79     }
80 
81     /**
82      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
83      * `errorMessage` as a fallback revert reason when `target` reverts.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
88         return _functionCallWithValue(target, data, 0, errorMessage);
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
93      * but also transferring `value` wei to `target`.
94      *
95      * Requirements:
96      *
97      * - the calling contract must have an ETH balance of at least `value`.
98      * - the called Solidity function must be `payable`.
99      *
100      * _Available since v3.1._
101      */
102     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
108      * with `errorMessage` as a fallback revert reason when `target` reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         return _functionCallWithValue(target, data, value, errorMessage);
115     }
116 
117     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
122         if (success) {
123             return returndata;
124         } else {
125             // Look for revert reason and bubble it up if present
126             if (returndata.length > 0) {
127                 // The easiest way to bubble the revert reason is using memory via assembly
128 
129                 // solhint-disable-next-line no-inline-assembly
130                 assembly {
131                     let returndata_size := mload(returndata)
132                     revert(add(32, returndata), returndata_size)
133                 }
134             } else {
135                 revert(errorMessage);
136             }
137         }
138     }
139 }
140 
141 abstract contract Context {
142     function _msgSender() internal view returns (address payable) {
143         return payable(msg.sender);
144     }
145 
146     function _msgData() internal view returns (bytes memory) {
147         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
148         return msg.data;
149     }
150 }
151 
152 interface IERC20 {
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * address(0) by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Emitted when `value` tokens are moved from one account (`from`) to
207      * another (`to`).
208      *
209      * Note that `value` may be address(0).
210      */
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     /**
214      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
215      * a call to {approve}. `value` is the new allowance.
216      */
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 interface IDEXPair {
221     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
222 }
223 
224 interface IDEXFactory {
225     function createPair(address tokenA, address tokenB) external returns (address pair);
226 }
227 
228 interface IDEXRouter {
229     function factory() external pure returns (address);
230     function WETH() external pure returns (address);
231 
232     function addLiquidity(
233         address tokenA,
234         address tokenB,
235         uint amountADesired,
236         uint amountBDesired,
237         uint amountAMin,
238         uint amountBMin,
239         address to,
240         uint deadline
241     ) external returns (uint amountA, uint amountB, uint liquidity);
242 
243     function addLiquidityETH(
244         address token,
245         uint amountTokenDesired,
246         uint amountTokenMin,
247         uint amountETHMin,
248         address to,
249         uint deadline
250     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
251 
252     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
253         uint amountIn,
254         uint amountOutMin,
255         address[] calldata path,
256         address to,
257         uint deadline
258     ) external;
259 
260     function swapExactETHForTokensSupportingFeeOnTransferTokens(
261         uint amountOutMin,
262         address[] calldata path,
263         address to,
264         uint deadline
265     ) external payable;
266 
267     function swapExactTokensForETHSupportingFeeOnTransferTokens(
268         uint amountIn,
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external;
274 }
275 
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * By default, the owner account will be the one that deploys the contract. This
282  * can later be changed with {transferOwnership}.
283  *
284  * This module is used through inheritance. It will make available the modifier
285  * `onlyOwner`, which can be applied to your functions to restrict their use to
286  * the owner.
287  */
288 contract Ownable is Context {
289     address public _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev Initializes the contract setting the deployer as the initial owner.
295      */
296     constructor () {
297         address msgSender = _msgSender();
298         _owner = msgSender;
299         emit OwnershipTransferred(address(0), msgSender);
300     }
301 
302     /**
303      * @dev Returns the address of the current owner.
304      */
305     function owner() public view returns (address) {
306         return _owner;
307     }
308 
309     /**
310      * @dev Throws if called by any account other than the owner.
311      */
312     modifier onlyOwner() {
313         require(_owner == _msgSender(), "Ownable: caller is not the owner");
314         _;
315     }
316      /**
317      * @dev Leaves the contract without owner. It will not be possible to call
318      * `onlyOwner` functions anymore. Can only be called by the current owner.
319      *
320      * NOTE: Renouncing ownership will leave the contract without an owner,
321      * thereby removing any functionality that is only available to the owner.
322      */
323     function renounceOwnership() public virtual onlyOwner {
324         emit OwnershipTransferred(_owner, address(0));
325         _owner = address(0);
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      * Can only be called by the current owner.
331      */
332     function transferOwnership(address newOwner) public virtual onlyOwner {
333         require(newOwner != address(0), "Ownable: new owner is the address(0) address");
334         emit OwnershipTransferred(_owner, newOwner);
335         _owner = newOwner;
336     }
337 }
338 
339 contract SHIB2 is IERC20, Ownable {
340     using Address for address;
341     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
342 
343     string constant _name = "SHIB2 ";
344     string constant _symbol = "SHIB2";
345     uint8 constant _decimals = 18;
346 
347     uint256 constant _totalSupply = 1_000_000_000 * (10 ** _decimals);
348 
349 
350     uint256 public _maxTxAmount = (_totalSupply * 1) / 800; //~0.125%
351     uint256 public _maxWalletSize = (_totalSupply * 1) / 400; //0.25%
352 
353     mapping (address => uint256) _balances;
354     mapping (address => mapping (address => uint256)) _allowances;
355     mapping (address => uint256) lastBuy;
356     mapping (address => uint256) lastSell;
357     mapping (address => uint256) lastSellAmount;
358 
359     mapping (address => bool) isFeeExempt;
360     mapping (address => bool) isTxLimitExempt;
361 
362     uint256 liquidityFee = 0;
363     uint256 giveawayFee = 10;
364     uint256 devmarketingFee = 20;
365     uint256 totalFee = 30;
366     uint256 sellBias = 30;
367 
368     //Higher tax for a period of time from the first purchase only, per address
369     uint256 sellPercent = 100;
370     uint256 sellPeriod = 24 hours;
371 
372     uint256 antiDumpTax = 100;
373     uint256 antiDumpPeriod = 30 minutes;
374     uint256 antiDumpThreshold = 21;
375     bool antiDumpReserve0 = false;
376     uint256 feeDenominator = 1000;
377 
378     address public immutable liquidityReceiver;
379     address payable public immutable giveawayReceiver;
380     address payable public immutable devmarketingReceiver;
381 
382     uint256 targetLiquidity = 40;
383     uint256 targetLiquidityDenominator = 100;
384 
385     IDEXRouter public immutable router;
386     
387     address constant routerAddress =0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
388     
389 
390 
391     mapping (address => bool) liquidityPools;
392     mapping (address => bool) liquidityProviders;
393 
394     address public immutable pair;
395 
396     uint256 public launchedAt;
397     uint256 public launchedTime;
398  
399     bool public swapEnabled = true;
400     uint256 public swapThreshold = _totalSupply / 400; //0.25%
401     uint256 public swapMinimum = _totalSupply / 10000; //0.01%
402     bool inSwap;
403     modifier swapping() { inSwap = true; _; inSwap = false; }
404 
405     constructor (address _lp, address _giveaway, address _devmarketing) {
406 
407         liquidityReceiver = _lp;
408         giveawayReceiver = payable(_giveaway);
409         devmarketingReceiver = payable(_devmarketing);
410 
411         router = IDEXRouter(routerAddress);
412         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
413         liquidityPools[pair] = true;
414         _allowances[owner()][routerAddress] = type(uint256).max;
415         _allowances[address(this)][routerAddress] = type(uint256).max;
416         
417         isFeeExempt[owner()] = true;
418         liquidityProviders[owner()] = true;
419 
420         isTxLimitExempt[address(this)] = true;
421         isTxLimitExempt[owner()] = true;
422         isTxLimitExempt[routerAddress] = true;
423 
424         _balances[owner()] = _totalSupply;
425         emit Transfer(address(0), owner(), _totalSupply);
426     }
427 
428     receive() external payable { }
429 
430     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
431     function decimals() external pure returns (uint8) { return _decimals; }
432     function symbol() external pure returns (string memory) { return _symbol; }
433     function name() external pure returns (string memory) { return _name; }
434     function getOwner() external view returns (address) { return owner(); }
435     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
436     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
437 
438     function approve(address spender, uint256 amount) public override returns (bool) {
439         _allowances[msg.sender][spender] = amount;
440         emit Approval(msg.sender, spender, amount);
441         return true;
442     }
443 
444     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
445         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
446         return true;
447     }
448 
449     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
450         uint256 currentAllowance = _allowances[msg.sender][spender];
451         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below address(0)");
452         unchecked {
453             _approve(msg.sender, spender, currentAllowance - subtractedValue);
454         }
455 
456         return true;
457     }
458 
459     function _approve(address owner, address spender, uint256 amount) internal virtual {
460         require(owner != address(0), "ERC20: approve from the address(0) address");
461         require(spender != address(0), "ERC20: approve to the address(0) address");
462 
463         _allowances[owner][spender] = amount;
464         emit Approval(owner, spender, amount);
465     }
466 
467     function approveMax(address spender) external returns (bool) {
468         return approve(spender, type(uint256).max);
469     }
470 
471     function transfer(address recipient, uint256 amount) external override returns (bool) {
472         return _transferFrom(msg.sender, recipient, amount);
473     }
474 
475     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
476         if(_allowances[sender][msg.sender] != type(uint256).max){
477             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
478         }
479 
480         return _transferFrom(sender, recipient, amount);
481     }
482 
483     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
484         require(_balances[sender] >= amount, "Insufficient balance");
485         require(amount > 0, "address(0) amount transferred");
486 
487         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
488 
489         checkTxLimit(sender, amount);
490         
491         if (!liquidityPools[recipient] && recipient != DEAD) {
492             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
493         }
494 
495         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient], "Contract not launched yet."); }
496 
497         _balances[sender] -= amount;
498 
499         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
500         
501         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
502         
503         _balances[recipient] += amountReceived;
504 
505         emit Transfer(sender, recipient, amountReceived);
506         return true;
507     }
508 
509     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
510         _balances[sender] -= amount;
511         _balances[recipient] += amount;
512         emit Transfer(sender, recipient, amount);
513         return true;
514     }
515     
516     function checkWalletLimit(address recipient, uint256 amount) internal view {
517         uint256 walletLimit = _maxWalletSize;
518         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
519     }
520 
521     function checkTxLimit(address sender, uint256 amount) internal view {
522         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
523     }
524 
525     function shouldTakeFee(address sender) internal view returns (bool) {
526         return !isFeeExempt[sender];
527     }
528 
529     function getTotalFee(bool selling, bool inHighPeriod) public view returns (uint256) {
530         if(launchedAt == block.number){ return feeDenominator - 1; }
531         if (selling) return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee + sellBias;
532         return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee - sellBias;
533     }
534 
535     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
536         uint256 feeAmount = 0;
537         bool highSellPeriod = !liquidityPools[sender] && lastBuy[sender] + sellPeriod > block.timestamp;
538         if(liquidityPools[recipient] && antiDumpTax > 0) {
539             (uint112 reserve0, uint112 reserve1,) = IDEXPair(pair).getReserves();
540             uint256 impactEstimate = amount * 1000 / ((antiDumpReserve0 ? reserve0 : reserve1) + amount);
541             
542             if (block.timestamp > lastSell[sender] + antiDumpPeriod) {
543                 lastSell[sender] = block.timestamp;
544                 lastSellAmount[sender] = 0;
545             }
546             
547             lastSellAmount[sender] += impactEstimate;
548             
549             if (lastSellAmount[sender] >= antiDumpThreshold) {
550                 feeAmount = ((amount * totalFee * antiDumpTax) / 100) / feeDenominator;
551             }
552         }
553 
554         if (feeAmount == 0)
555             feeAmount = (amount * getTotalFee(liquidityPools[recipient], highSellPeriod)) / feeDenominator;
556         
557         if (liquidityPools[sender] && lastBuy[recipient] == 0)
558             lastBuy[recipient] = block.timestamp;
559 
560         _balances[address(this)] += feeAmount;
561         emit Transfer(sender, address(this), feeAmount);
562 
563         return amount - feeAmount;
564     }
565 
566     function shouldSwapBack(address recipient) internal view returns (bool) {
567         return !liquidityPools[msg.sender]
568         && !isFeeExempt[msg.sender]
569         && !inSwap
570         && swapEnabled
571         && liquidityPools[recipient]
572         && _balances[address(this)] >= swapMinimum &&
573         totalFee > 0;
574     }
575 
576     function swapBack(uint256 amount) internal swapping {
577         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
578         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
579         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
580         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / totalFee) / 2;
581         amountToSwap -= amountToLiquify;
582 
583         address[] memory path = new address[](2);
584         path[0] = address(this);
585         path[1] = router.WETH();
586         
587         //Guaranteed swap desired to prevent trade blockages
588         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
589             amountToSwap,
590             0,
591             path,
592             address(this),
593             block.timestamp
594         );
595 
596         uint256 contractBalance = address(this).balance;
597         uint256 totalETHFee = totalFee - dynamicLiquidityFee / 2;
598 
599         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
600         uint256 amountGiveaway= (contractBalance * giveawayFee) / totalETHFee;
601         uint256 amountDevMarketing = contractBalance - (amountLiquidity + amountGiveaway);
602 
603         if(amountToLiquify > 0) {
604             //Guaranteed swap desired to prevent trade blockages, return values ignored
605             router.addLiquidityETH{value: amountLiquidity}(
606                 address(this),
607                 amountToLiquify,
608                 0,
609                 0,
610                 liquidityReceiver,
611                 block.timestamp
612             );
613             emit AutoLiquify(amountLiquidity, amountToLiquify);
614         }
615         
616         if (amountGiveaway > 0)
617             giveawayReceiver.transfer(amountGiveaway);
618             
619         if (amountDevMarketing > 0)
620             devmarketingReceiver.transfer(amountDevMarketing);
621 
622     }
623 
624     function launched() internal view returns (bool) {
625         return launchedAt != 0;
626     }
627 
628     function getCirculatingSupply() public view returns (uint256) {
629         return _totalSupply - (balanceOf(DEAD) + balanceOf(address(0)));
630     }
631 
632     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
633         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
634     }
635 
636     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
637         return getLiquidityBacking(accuracy) > target;
638     }
639 
640     function transferOwnership(address newOwner) public virtual override onlyOwner {
641         isFeeExempt[owner()] = false;
642         isTxLimitExempt[owner()] = false;
643         liquidityProviders[owner()] = false;
644         _allowances[owner()][routerAddress] = 0;
645         super.transferOwnership(newOwner);
646         isFeeExempt[newOwner] = true;
647         isTxLimitExempt[newOwner] = true;
648         liquidityProviders[newOwner] = true;
649         _allowances[newOwner][routerAddress] = type(uint256).max;
650     }
651 
652     function renounceOwnership() public virtual override onlyOwner {
653         isFeeExempt[owner()] = false;
654         isTxLimitExempt[owner()] = false;
655         liquidityProviders[owner()] = false;
656         _allowances[owner()][routerAddress] = 0;
657         super.renounceOwnership();
658     }
659     
660     function setLiquidityProvider(address _provider) external onlyOwner {
661         require(_provider != pair && _provider != routerAddress, "Can't alter trading contracts in this manner.");
662         isFeeExempt[_provider] = true;
663         liquidityProviders[_provider] = true;
664         isTxLimitExempt[_provider] = true;
665         emit LiquidityProviderSet(_provider);
666     }
667 
668     function setSellPeriod(uint256 _sellPercentIncrease, uint256 _period) external onlyOwner {
669         require((totalFee * _sellPercentIncrease) / 100 <= 400, "Sell tax too high");
670         require(_sellPercentIncrease >= 100, "Can't make sells cheaper with this");
671         require(antiDumpTax == 0 || _sellPercentIncrease <= antiDumpTax, "High period tax clashes with anti-dump tax");
672         require(_period <= 7 days, "Sell period too long");
673         sellPercent = _sellPercentIncrease;
674         sellPeriod = _period;
675         emit SellPeriodSet(_sellPercentIncrease, _period);
676     }
677 
678     function setAntiDumpTax(uint256 _tax, uint256 _period, uint256 _threshold, bool _reserve0) external onlyOwner {
679         require(_threshold >= 10 && _tax <= 400 && (_tax == 0 || _tax >= sellPercent) && _period <= 1 hours, "Parameters out of bounds");
680         antiDumpTax = _tax;
681         antiDumpPeriod = _period;
682         antiDumpThreshold = _threshold;
683         antiDumpReserve0 = _reserve0;
684         emit AntiDumpTaxSet(_tax, _period, _threshold);
685     }
686 
687     function launch() external onlyOwner {
688         require (launchedAt == 0);
689         launchedAt = block.number;
690         launchedTime = block.timestamp;
691         emit TradingLaunched();
692     }
693 
694     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
695         _maxTxAmount = (_totalSupply * numerator) / divisor;
696         emit TransactionLimitSet(_maxTxAmount);
697     }
698     
699     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
700         require(divisor > 0 && divisor <= 10000, "Divisor must be greater than 0");
701         _maxWalletSize = (_totalSupply * numerator) / divisor;
702         emit MaxWalletSet(_maxWalletSize);
703     }
704 
705     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
706         require(holder != address(0), "Invalid address");
707         isFeeExempt[holder] = exempt;
708         emit FeeExemptSet(holder, exempt);
709     }
710 
711     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
712         require(holder != address(0), "Invalid address");
713         isTxLimitExempt[holder] = exempt;
714         emit TrasactionLimitExemptSet(holder, exempt);
715     }
716 
717     function setFees(uint256 _liquidityFee, uint256 _giveawayFee, uint256 _devmarketingFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
718         require((_liquidityFee / 2) * 2 == _liquidityFee, "Liquidity fee must be an even number due to rounding");
719         liquidityFee = _liquidityFee;
720         giveawayFee = _giveawayFee;
721         devmarketingFee = _devmarketingFee;
722         sellBias = _sellBias;
723         totalFee = _liquidityFee + _giveawayFee + _devmarketingFee;
724         feeDenominator = _feeDenominator;
725         require(totalFee <= feeDenominator / 4, "Fees too high");
726         require(sellBias <= totalFee, "Incorrect sell bias");
727         emit FeesSet(totalFee, feeDenominator, sellBias);
728     }
729 
730     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
731         require(_denominator > 0 && _denominatorMin > 0, "Denominators must be greater than 0");
732         swapEnabled = _enabled;
733         swapMinimum = _totalSupply / _denominatorMin;
734         swapThreshold = _totalSupply / _denominator;
735         emit SwapSettingsSet(swapMinimum, swapThreshold, swapEnabled);
736     }
737 
738     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
739         targetLiquidity = _target;
740         targetLiquidityDenominator = _denominator;
741         emit TargetLiquiditySet(_target * 100 / _denominator);
742     }
743 
744     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
745         require(_pool != address(0), "Invalid address");
746         liquidityPools[_pool] = _enabled;
747         emit LiquidityPoolSet(_pool, _enabled);
748     }
749 
750     event AutoLiquify(uint256 amount, uint256 amountToken);
751     event LiquidityProviderSet(address indexed provider);
752     event SellPeriodSet(uint256 percent, uint256 period);
753     event TradingLaunched();
754     event TransactionLimitSet(uint256 limit);
755     event MaxWalletSet(uint256 limit);
756     event FeeExemptSet(address indexed wallet, bool isExempt);
757     event TrasactionLimitExemptSet(address indexed wallet, bool isExempt);
758     event FeesSet(uint256 totalFees, uint256 denominator, uint256 sellBias);
759     event SwapSettingsSet(uint256 minimum, uint256 maximum, bool enabled);
760     event LiquidityPoolSet(address indexed pool, bool enabled);
761     event AntiDumpTaxSet(uint256 rate, uint256 period, uint256 threshold);
762     event TargetLiquiditySet(uint256 percent);
763 }