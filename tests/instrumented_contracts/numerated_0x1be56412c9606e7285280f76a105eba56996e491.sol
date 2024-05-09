1 /*
2 ZINJA
3 Sacrifice, because we must prevail
4 
5 Website: https://zinja.info
6 Telegram: https://t.me/ZINJA_ETH
7 Twitter: https://twitter.com/Zinja_ETH
8 
9 */
10 
11 // SPDX-License-Identifier: None
12 
13 pragma solidity 0.8.12;
14 
15 
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * C U ON THE MOON
22      * ====
23      * It is unsafe to assume that an address for which this function returns
24      * false is an externally-owned account (EOA) and not a contract.
25      *
26      * Among others, `isContract` will return false for the following
27      * types of addresses:
28      *
29      *  - an externally-owned account
30      *  - a contract in construction
31      *  - an address where a contract will be created
32      *  - an address where a contract lived, but was destroyed
33      * ====
34      */
35     function isContract(address account) internal view returns (bool) {
36         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
37         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
38         // for accounts without code, i.e. `keccak256('')`
39         bytes32 codehash;
40         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
41         // solhint-disable-next-line no-inline-assembly
42         assembly { codehash := extcodehash(account) }
43         return (codehash != accountHash && codehash != 0x0);
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
66         (bool success, ) = recipient.call{ value: amount }("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain`call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89       return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
99         return _functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
119      * with `errorMessage` as a fallback revert reason when `target` reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
124         require(address(this).balance >= value, "Address: insufficient balance for call");
125         return _functionCallWithValue(target, data, value, errorMessage);
126     }
127 
128     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
129         require(isContract(target), "Address: call to non-contract");
130 
131         // solhint-disable-next-line avoid-low-level-calls
132         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
133         if (success) {
134             return returndata;
135         } else {
136             // Look for revert reason and bubble it up if present
137             if (returndata.length > 0) {
138                 // The easiest way to bubble the revert reason is using memory via assembly
139 
140                 // solhint-disable-next-line no-inline-assembly
141                 assembly {
142                     let returndata_size := mload(returndata)
143                     revert(add(32, returndata), returndata_size)
144                 }
145             } else {
146                 revert(errorMessage);
147             }
148         }
149     }
150 }
151 
152 abstract contract Context {
153     function _msgSender() internal view returns (address payable) {
154         return payable(msg.sender);
155     }
156 
157     function _msgData() internal view returns (bytes memory) {
158         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
159         return msg.data;
160     }
161 }
162 
163 interface IERC20 {
164     function totalSupply() external view returns (uint256);
165 
166     /**
167      * @dev Returns the amount of tokens owned by `account`.
168      */
169     function balanceOf(address account) external view returns (uint256);
170 
171     /**
172      * @dev Moves `amount` tokens from the caller's account to `recipient`.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transfer(address recipient, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Returns the remaining number of tokens that `spender` will be
182      * allowed to spend on behalf of `owner` through {transferFrom}. This is
183      * zero by default.
184      *
185      * This value changes when {approve} or {transferFrom} are called.
186      */
187     function allowance(address owner, address spender) external view returns (uint256);
188 
189     /**
190      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * IMPORTANT: Beware that changing an allowance with this method brings the risk
195      * that someone may use both the old and the new allowance by unfortunate
196      * transaction ordering. One possible solution to mitigate this race
197      * condition is to first reduce the spender's allowance to 0 and set the
198      * desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      *
201      * Emits an {Approval} event.
202      */
203     function approve(address spender, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Moves `amount` tokens from `sender` to `recipient` using the
207      * allowance mechanism. `amount` is then deducted from the caller's
208      * allowance.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Emitted when `value` tokens are moved from one account (`from`) to
218      * another (`to`).
219      *
220      * Note that `value` may be zero.
221      */
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 
224     /**
225      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
226      * a call to {approve}. `value` is the new allowance.
227      */
228     event Approval(address indexed owner, address indexed spender, uint256 value);
229 }
230 
231 interface IDEXPair {
232     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
233 }
234 
235 interface IDEXFactory {
236     function createPair(address tokenA, address tokenB) external returns (address pair);
237 }
238 
239 interface IDEXRouter {
240     function factory() external pure returns (address);
241     function WETH() external pure returns (address);
242 
243     function addLiquidity(
244         address tokenA,
245         address tokenB,
246         uint amountADesired,
247         uint amountBDesired,
248         uint amountAMin,
249         uint amountBMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountA, uint amountB, uint liquidity);
253 
254     function addLiquidityETH(
255         address token,
256         uint amountTokenDesired,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
262 
263     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270 
271     function swapExactETHForTokensSupportingFeeOnTransferTokens(
272         uint amountOutMin,
273         address[] calldata path,
274         address to,
275         uint deadline
276     ) external payable;
277 
278     function swapExactTokensForETHSupportingFeeOnTransferTokens(
279         uint amountIn,
280         uint amountOutMin,
281         address[] calldata path,
282         address to,
283         uint deadline
284     ) external;
285 }
286 
287 /**
288  * @dev Contract module which provides a basic access control mechanism, where
289  * there is an account (an owner) that can be granted exclusive access to
290  * specific functions.
291  *
292  * By default, the owner account will be the one that deploys the contract. This
293  * can later be changed with {transferOwnership}.
294  *
295  * This module is used through inheritance. It will make available the modifier
296  * `onlyOwner`, which can be applied to your functions to restrict their use to
297  * the owner.
298  */
299 contract Ownable is Context {
300     address private _owner;
301 
302     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
303 
304     /**
305      * @dev Initializes the contract setting the deployer as the initial owner.
306      */
307     constructor () {
308         address msgSender = _msgSender();
309         _owner = msgSender;
310         emit OwnershipTransferred(0x0000000000000000000000000000000000000000, msgSender);
311     }
312 
313     /**
314      * @dev Returns the address of the current owner.
315      */
316     function owner() public view returns (address) {
317         return _owner;
318     }
319 
320     /**
321      * @dev Throws if called by any account other than the owner.
322      */
323     modifier onlyOwner() {
324         require(_owner == _msgSender(), "Ownable: caller is not the owner");
325         _;
326     }
327      /**
328      * @dev Leaves the contract without owner. It will not be possible to call
329      * `onlyOwner` functions anymore. Can only be called by the current owner.
330      *
331      * NOTE: Renouncing ownership will leave the contract without an owner,
332      * thereby removing any functionality that is only available to the owner.
333      */
334     function renounceOwnership() public virtual onlyOwner {
335         emit OwnershipTransferred(_owner, 0x0000000000000000000000000000000000000000);
336         _owner = 0x0000000000000000000000000000000000000000;
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Can only be called by the current owner.
342      */
343     function transferOwnership(address newOwner) public virtual onlyOwner {
344         require(newOwner != 0x0000000000000000000000000000000000000000, "Ownable: new owner is the zero address");
345         emit OwnershipTransferred(_owner, newOwner);
346         _owner = newOwner;
347     }
348 }
349 
350 interface IAntiSnipe {
351   function setTokenOwner(address owner, address pair) external;
352 
353   function onPreTransferCheck(
354     address from,
355     address to,
356     uint256 amount
357   ) external returns (bool checked);
358 }
359 
360 contract Zinja is IERC20, Ownable {
361     using Address for address;
362     
363     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
364 
365     string constant _name = "ZINJA";
366     string constant _symbol = "Z";
367     uint8 constant _decimals = 9;
368 
369     uint256 constant _totalSupply = 100_000_000 * (10 ** _decimals);
370 
371     //For ease to the end-user these checks do not adjust for burnt tokens and should be set accordingly.
372     uint256 public _maxTxAmount = (_totalSupply * 1) / 1000; //0.1%
373     uint256 public _maxWalletSize = (_totalSupply * 1) / 500; //0.2%
374 
375     mapping (address => uint256) _balances;
376     mapping (address => mapping (address => uint256)) _allowances;
377     mapping (address => uint256) lastBuy;
378     mapping (address => uint256) lastSell;
379     mapping (address => uint256) lastSellAmount;
380 
381     mapping (address => bool) isFeeExempt;
382     mapping (address => bool) isTxLimitExempt;
383 
384     uint256 liquidityFee = 20;
385     uint256 marketingFee = 30;
386     uint256 devFee = 30;
387     uint256 totalFee = 80;
388     uint256 sellBias = 0;
389 
390     //Higher tax for a period of time from the first purchase on an address
391     uint256 sellPercent = 250;
392     uint256 sellPeriod = 24 hours;
393 
394     uint256 antiDumpTax = 0;
395     uint256 antiDumpPeriod = 30 minutes;
396     uint256 antiDumpThreshold = 21;
397     bool antiDumpReserve0 = true;
398     uint256 feeDenominator = 1000;
399 
400     address public immutable liquidityReceiver;
401     address payable public immutable marketingReceiver;
402     address payable public immutable devReceiver;
403 
404     uint256 targetLiquidity = 40;
405     uint256 targetLiquidityDenominator = 100;
406 
407     IDEXRouter public immutable router;
408     
409     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
410 
411     mapping (address => bool) liquidityPools;
412     mapping (address => bool) liquidityProviders;
413 
414     address public immutable pair;
415 
416     uint256 public launchedAt;
417     uint256 public launchedTime;
418  
419     IAntiSnipe public antisnipe;
420     bool public protectionEnabled = true;
421     bool public protectionDisabled = false;
422 
423     bool public swapEnabled = true;
424     uint256 public swapThreshold = _totalSupply / 400; //0.25%
425     uint256 public swapMinimum = _totalSupply / 10000; //0.01%
426     bool inSwap;
427     modifier swapping() { inSwap = true; _; inSwap = false; }
428 
429     constructor (address _lp, address _marketing, address _dev) {
430         //Suggest setting liquidity receiver to DEAD to lock funds in the project and avoid centralization
431         liquidityReceiver = _lp;
432         marketingReceiver = payable(_marketing);
433         devReceiver = payable(_dev);
434 
435         router = IDEXRouter(routerAddress);
436         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
437         liquidityPools[pair] = true;
438         _allowances[owner()][routerAddress] = type(uint256).max;
439         _allowances[address(this)][routerAddress] = type(uint256).max;
440         
441         isFeeExempt[owner()] = true;
442         liquidityProviders[owner()] = true;
443 
444         isTxLimitExempt[address(this)] = true;
445         isTxLimitExempt[owner()] = true;
446         isTxLimitExempt[routerAddress] = true;
447 
448         _balances[owner()] = _totalSupply;
449         emit Transfer(0x0000000000000000000000000000000000000000, owner(), _totalSupply);
450     }
451 
452     receive() external payable { }
453 
454     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
455     function decimals() external pure returns (uint8) { return _decimals; }
456     function symbol() external pure returns (string memory) { return _symbol; }
457     function name() external pure returns (string memory) { return _name; }
458     function getOwner() external view returns (address) { return owner(); }
459     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
460     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
461 
462     function approve(address spender, uint256 amount) public override returns (bool) {
463         _allowances[msg.sender][spender] = amount;
464         emit Approval(msg.sender, spender, amount);
465         return true;
466     }
467 
468     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
469         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
470         return true;
471     }
472 
473     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
474         uint256 currentAllowance = _allowances[msg.sender][spender];
475         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
476         unchecked {
477             _approve(msg.sender, spender, currentAllowance - subtractedValue);
478         }
479 
480         return true;
481     }
482 
483     function _approve(address owner, address spender, uint256 amount) internal virtual {
484         require(owner != 0x0000000000000000000000000000000000000000, "ERC20: approve from the zero address");
485         require(spender != 0x0000000000000000000000000000000000000000, "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     function approveMax(address spender) external returns (bool) {
492         return approve(spender, type(uint256).max);
493     }
494 
495     function transfer(address recipient, uint256 amount) external override returns (bool) {
496         return _transferFrom(msg.sender, recipient, amount);
497     }
498 
499     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
500         if(_allowances[sender][msg.sender] != type(uint256).max){
501             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
502         }
503 
504         return _transferFrom(sender, recipient, amount);
505     }
506 
507     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
508         require(_balances[sender] >= amount, "Insufficient balance");
509         require(amount > 0, "Zero amount transferred");
510 
511         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
512 
513         checkTxLimit(sender, amount);
514         
515         if (!liquidityPools[recipient] && recipient != DEAD) {
516             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
517         }
518 
519         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient], "Contract not launched yet."); }
520 
521         _balances[sender] -= amount;
522 
523         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
524         
525         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
526         
527         _balances[recipient] += amountReceived;
528             
529         if(launched() && protectionEnabled)
530             antisnipe.onPreTransferCheck(sender, recipient, amount);
531 
532         emit Transfer(sender, recipient, amountReceived);
533         return true;
534     }
535 
536     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
537         _balances[sender] -= amount;
538         _balances[recipient] += amount;
539         emit Transfer(sender, recipient, amount);
540         return true;
541     }
542     
543     function checkWalletLimit(address recipient, uint256 amount) internal view {
544         uint256 walletLimit = _maxWalletSize;
545         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
546     }
547 
548     function checkTxLimit(address sender, uint256 amount) internal view {
549         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
550     }
551 
552     function shouldTakeFee(address sender) internal view returns (bool) {
553         return !isFeeExempt[sender];
554     }
555 
556     function getTotalFee(bool selling, bool inHighPeriod) public view returns (uint256) {
557         if(launchedAt == block.number){ return feeDenominator - 1; }
558         if (selling) return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee + sellBias;
559         return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee - sellBias;
560     }
561 
562     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
563         uint256 feeAmount = 0;
564         bool highSellPeriod = !liquidityPools[sender] && lastBuy[sender] + sellPeriod > block.timestamp;
565         if(liquidityPools[recipient] && antiDumpTax > 0) {
566             (uint112 reserve0, uint112 reserve1,) = IDEXPair(pair).getReserves();
567             uint256 impactEstimate = amount * 1000 / ((antiDumpReserve0 ? reserve0 : reserve1) + amount);
568             
569             if (block.timestamp > lastSell[sender] + antiDumpPeriod) {
570                 lastSell[sender] = block.timestamp;
571                 lastSellAmount[sender] = 0;
572             }
573             
574             lastSellAmount[sender] += impactEstimate;
575             
576             if (lastSellAmount[sender] >= antiDumpThreshold) {
577                 feeAmount = ((amount * totalFee * antiDumpTax) / 100) / feeDenominator;
578             }
579         }
580 
581         if (feeAmount == 0)
582             feeAmount = (amount * getTotalFee(liquidityPools[recipient], highSellPeriod)) / feeDenominator;
583         
584         if (liquidityPools[sender] && lastBuy[recipient] == 0)
585             lastBuy[recipient] = block.timestamp;
586 
587         _balances[address(this)] += feeAmount;
588         emit Transfer(sender, address(this), feeAmount);
589 
590         return amount - feeAmount;
591     }
592 
593     function shouldSwapBack(address recipient) internal view returns (bool) {
594         return !liquidityPools[msg.sender]
595         && !isFeeExempt[msg.sender]
596         && !inSwap
597         && swapEnabled
598         && liquidityPools[recipient]
599         && _balances[address(this)] >= swapMinimum &&
600         totalFee > 0;
601     }
602 
603     function swapBack(uint256 amount) internal swapping {
604         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
605         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
606         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
607         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / totalFee) / 2;
608         amountToSwap -= amountToLiquify;
609 
610         address[] memory path = new address[](2);
611         path[0] = address(this);
612         path[1] = router.WETH();
613         
614         //Guaranteed swap desired to prevent trade blockages
615         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
616             amountToSwap,
617             0,
618             path,
619             address(this),
620             block.timestamp
621         );
622 
623         uint256 contractBalance = address(this).balance;
624         uint256 totalETHFee = totalFee - dynamicLiquidityFee / 2;
625 
626         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
627         uint256 amountMarketing = (contractBalance * marketingFee) / totalETHFee;
628         uint256 amountDev = contractBalance - (amountLiquidity + amountMarketing);
629 
630         if(amountToLiquify > 0) {
631             //Guaranteed swap desired to prevent trade blockages, return values ignored
632             router.addLiquidityETH{value: amountLiquidity}(
633                 address(this),
634                 amountToLiquify,
635                 0,
636                 0,
637                 liquidityReceiver,
638                 block.timestamp
639             );
640             emit AutoLiquify(amountLiquidity, amountToLiquify);
641         }
642         
643         if (amountMarketing > 0)
644             marketingReceiver.transfer(amountMarketing);
645             
646         if (amountDev > 0)
647             devReceiver.transfer(amountDev);
648 
649     }
650 
651     function launched() internal view returns (bool) {
652         return launchedAt != 0;
653     }
654 
655     function getCirculatingSupply() public view returns (uint256) {
656         return _totalSupply - (balanceOf(DEAD) + balanceOf(0x0000000000000000000000000000000000000000));
657     }
658 
659     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
660         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
661     }
662 
663     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
664         return getLiquidityBacking(accuracy) > target;
665     }
666 
667     function transferOwnership(address newOwner) public virtual override onlyOwner {
668         isFeeExempt[owner()] = false;
669         isTxLimitExempt[owner()] = false;
670         liquidityProviders[owner()] = false;
671         _allowances[owner()][routerAddress] = 0;
672         super.transferOwnership(newOwner);
673         isFeeExempt[newOwner] = true;
674         isTxLimitExempt[newOwner] = true;
675         liquidityProviders[newOwner] = true;
676         _allowances[newOwner][routerAddress] = type(uint256).max;
677     }
678 
679     function renounceOwnership() public virtual override onlyOwner {
680         isFeeExempt[owner()] = false;
681         isTxLimitExempt[owner()] = false;
682         liquidityProviders[owner()] = false;
683         _allowances[owner()][routerAddress] = 0;
684         super.renounceOwnership();
685     }
686 
687     function setProtectionEnabled(bool _protect) external onlyOwner {
688         if (_protect)
689             require(!protectionDisabled, "Protection disabled");
690         protectionEnabled = _protect;
691         emit ProtectionToggle(_protect);
692     }
693     
694     function setProtection(address _protection, bool _call) external onlyOwner {
695         if (_protection != address(antisnipe)){
696             require(!protectionDisabled, "Protection disabled");
697             antisnipe = IAntiSnipe(_protection);
698         }
699         if (_call)
700             antisnipe.setTokenOwner(address(this), pair);
701         
702         emit ProtectionSet(_protection);
703     }
704     
705     function disableProtection() external onlyOwner {
706         protectionDisabled = true;
707         emit ProtectionDisabled();
708     }
709     
710     function setLiquidityProvider(address _provider) external onlyOwner {
711         require(_provider != pair && _provider != routerAddress, "Can't alter trading contracts in this manner.");
712         isFeeExempt[_provider] = true;
713         liquidityProviders[_provider] = true;
714         isTxLimitExempt[_provider] = true;
715         emit LiquidityProviderSet(_provider);
716     }
717 
718     function setSellPeriod(uint256 _sellPercentIncrease, uint256 _period) external onlyOwner {
719         require((totalFee * _sellPercentIncrease) / 100 <= 400, "Sell tax too high");
720         require(_sellPercentIncrease >= 100, "Can't make sells cheaper with this");
721         require(antiDumpTax == 0 || _sellPercentIncrease <= antiDumpTax, "High period tax clashes with anti-dump tax");
722         require(_period <= 7 days, "Sell period too long");
723         sellPercent = _sellPercentIncrease;
724         sellPeriod = _period;
725         emit SellPeriodSet(_sellPercentIncrease, _period);
726     }
727 
728     function setAntiDumpTax(uint256 _tax, uint256 _period, uint256 _threshold, bool _reserve0) external onlyOwner {
729         require(_threshold >= 10 && _tax <= 400 && (_tax == 0 || _tax >= sellPercent) && _period <= 1 hours, "Parameters out of bounds");
730         antiDumpTax = _tax;
731         antiDumpPeriod = _period;
732         antiDumpThreshold = _threshold;
733         antiDumpReserve0 = _reserve0;
734         emit AntiDumpTaxSet(_tax, _period, _threshold);
735     }
736 
737     function launch() external onlyOwner {
738         require (launchedAt == 0);
739         launchedAt = block.number;
740         launchedTime = block.timestamp;
741         emit TradingLaunched();
742     }
743 
744     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
745         require(numerator > 0 && divisor > 0 && (numerator * 1000) / divisor >= 5, "Transaction limits too low");
746         _maxTxAmount = (_totalSupply * numerator) / divisor;
747         emit TransactionLimitSet(_maxTxAmount);
748     }
749     
750     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
751         require(divisor > 0 && divisor <= 10000, "Divisor must be greater than zero");
752         _maxWalletSize = (_totalSupply * numerator) / divisor;
753         emit MaxWalletSet(_maxWalletSize);
754     }
755 
756     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
757         require(holder != 0x0000000000000000000000000000000000000000, "Invalid address");
758         isFeeExempt[holder] = exempt;
759         emit FeeExemptSet(holder, exempt);
760     }
761 
762     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
763         require(holder != 0x0000000000000000000000000000000000000000, "Invalid address");
764         isTxLimitExempt[holder] = exempt;
765         emit TrasactionLimitExemptSet(holder, exempt);
766     }
767 
768     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
769         require((_liquidityFee / 2) * 2 == _liquidityFee, "Liquidity fee must be an even number due to rounding");
770         liquidityFee = _liquidityFee;
771         marketingFee = _marketingFee;
772         devFee = _devFee;
773         sellBias = _sellBias;
774         totalFee = _liquidityFee + _marketingFee + _devFee;
775         feeDenominator = _feeDenominator;
776         require(totalFee <= feeDenominator / 4, "Fees too high");
777         require(sellBias <= totalFee, "Incorrect sell bias");
778         emit FeesSet(totalFee, feeDenominator, sellBias);
779     }
780 
781     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
782         require(_denominator > 0 && _denominatorMin > 0, "Denominators must be greater than 0");
783         swapEnabled = _enabled;
784         swapMinimum = _totalSupply / _denominatorMin;
785         swapThreshold = _totalSupply / _denominator;
786         emit SwapSettingsSet(swapMinimum, swapThreshold, swapEnabled);
787     }
788 
789     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
790         targetLiquidity = _target;
791         targetLiquidityDenominator = _denominator;
792         emit TargetLiquiditySet(_target * 100 / _denominator);
793     }
794 
795     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
796         require(_pool != 0x0000000000000000000000000000000000000000, "Invalid address");
797         liquidityPools[_pool] = _enabled;
798         emit LiquidityPoolSet(_pool, _enabled);
799     }
800 
801 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
802     {
803         require(_addresses.length == _amount.length, "Array lengths don't match");
804         bool previousSwap = swapEnabled;
805         swapEnabled = false;
806         //This function may run out of gas intentionally to prevent partial airdrops
807         for (uint256 i = 0; i < _addresses.length; i++) {
808             require(!liquidityPools[_addresses[i]] && _addresses[i] != 0x0000000000000000000000000000000000000000, "Can't airdrop the liquidity pool or address 0");
809             _transferFrom(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
810             lastBuy[_addresses[i]] = block.timestamp;
811         }
812         swapEnabled = previousSwap;
813         emit AirdropSent(msg.sender);
814     }
815 
816     event AutoLiquify(uint256 amount, uint256 amountToken);
817     event ProtectionSet(address indexed protection);
818     event ProtectionDisabled();
819     event LiquidityProviderSet(address indexed provider);
820     event SellPeriodSet(uint256 percent, uint256 period);
821     event TradingLaunched();
822     event TransactionLimitSet(uint256 limit);
823     event MaxWalletSet(uint256 limit);
824     event FeeExemptSet(address indexed wallet, bool isExempt);
825     event TrasactionLimitExemptSet(address indexed wallet, bool isExempt);
826     event FeesSet(uint256 totalFees, uint256 denominator, uint256 sellBias);
827     event SwapSettingsSet(uint256 minimum, uint256 maximum, bool enabled);
828     event LiquidityPoolSet(address indexed pool, bool enabled);
829     event AirdropSent(address indexed from);
830     event AntiDumpTaxSet(uint256 rate, uint256 period, uint256 threshold);
831     event TargetLiquiditySet(uint256 percent);
832     event ProtectionToggle(bool isEnabled);
833 }