1 /*
2 Shikage SHKG v2
3 
4 Telegram: https://t.me/shikageofficial
5 Website: https://shikage.space/
6 Facebook: https://www.facebook.com/Shikage.ETH/
7 Instagram: https://www.instagram.com/shikage_token/
8 Twitter: https://twitter.com/ShikageEth
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity 0.8.11;
14 
15 
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * C U ON THE MOON
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
310         emit OwnershipTransferred(address(0), msgSender);
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
335         emit OwnershipTransferred(_owner, address(0));
336         _owner = address(0);
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Can only be called by the current owner.
342      */
343     function transferOwnership(address newOwner) public virtual onlyOwner {
344         require(newOwner != address(0), "Ownable: new owner is the zero address");
345         emit OwnershipTransferred(_owner, newOwner);
346         _owner = newOwner;
347     }
348 }
349 
350 interface IAntiSnipe {
351   function setTokenOwner(address owner) external;
352 
353   function onPreTransferCheck(
354     address from,
355     address to,
356     uint256 amount
357   ) external returns (bool checked);
358 }
359 
360 contract Shikage is IERC20, Ownable {
361     using Address for address;
362     
363     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
364     address constant ZERO = 0x0000000000000000000000000000000000000000;
365 
366     string constant _name = "Shikage";
367     string constant _symbol = "SHKG";
368     uint8 constant _decimals = 9;
369 
370     uint256 constant _totalSupply = 1_000_000_000 * (10 ** _decimals);
371     uint256 public _maxTxAmount = (_totalSupply * 1) / 200;
372     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;
373 
374     mapping (address => uint256) _balances;
375     mapping (address => mapping (address => uint256)) _allowances;
376     mapping (address => uint256) lastBuy;
377     mapping (address => uint256) lastSell;
378     mapping (address => uint256) lastSellAmount;
379 
380     mapping (address => bool) isFeeExempt;
381     mapping (address => bool) isTxLimitExempt;
382 
383     uint256 liquidityFee = 20;
384     uint256 marketingFee = 50;
385     uint256 devFee = 30;
386     uint256 totalFee = 100;
387     uint256 sellBias = 0;
388     uint256 sellPercent = 250;
389     uint256 sellPeriod = 72 hours;
390     uint256 antiDumpTax = 400;
391     uint256 antiDumpPeriod = 30 minutes;
392     uint256 antiDumpThreshold = 21;
393     bool antiDumpReserve0 = true;
394     uint256 feeDenominator = 1000;
395 
396     address public constant liquidityReceiver = 0x51FE1EDbC149556eF2867115E58616428aA2C19A;
397     address payable public constant marketingReceiver = payable(0x51FE1EDbC149556eF2867115E58616428aA2C19A);
398     address payable public constant devReceiver = payable(0x592Ab8ED942c7Eb84cB27616f1Dcb57669DFD901);
399 
400     uint256 targetLiquidity = 40;
401     uint256 targetLiquidityDenominator = 100;
402 
403     IDEXRouter public immutable router;
404     
405     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
406 
407     mapping (address => bool) liquidityPools;
408     mapping (address => bool) liquidityProviders;
409 
410     address public immutable pair;
411 
412     uint256 public launchedAt;
413     uint256 public launchedTime;
414     bool public pauseDisabled = false;
415     
416     IAntiSnipe public antisnipe;
417     bool public protectionEnabled = true;
418     bool public protectionDisabled = false;
419 
420     bool public swapEnabled = true;
421     uint256 public swapThreshold = _totalSupply / 400;
422     uint256 public swapMinimum = _totalSupply / 10000;
423     bool inSwap;
424     modifier swapping() { inSwap = true; _; inSwap = false; }
425 
426     constructor () {
427         router = IDEXRouter(routerAddress);
428         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
429         liquidityPools[pair] = true;
430         _allowances[owner()][routerAddress] = type(uint256).max;
431         _allowances[address(this)][routerAddress] = type(uint256).max;
432         
433         isFeeExempt[owner()] = true;
434         liquidityProviders[msg.sender] = true;
435 
436         isTxLimitExempt[address(this)] = true;
437         isTxLimitExempt[owner()] = true;
438         isTxLimitExempt[routerAddress] = true;
439 
440         _balances[owner()] = _totalSupply;
441         emit Transfer(address(0), owner(), _totalSupply);
442     }
443 
444     receive() external payable { }
445 
446     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
447     function decimals() external pure returns (uint8) { return _decimals; }
448     function symbol() external pure returns (string memory) { return _symbol; }
449     function name() external pure returns (string memory) { return _name; }
450     function getOwner() external view returns (address) { return owner(); }
451     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
452     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
453 
454     function approve(address spender, uint256 amount) public override returns (bool) {
455         _allowances[msg.sender][spender] = amount;
456         emit Approval(msg.sender, spender, amount);
457         return true;
458     }
459 
460     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
461         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
462         return true;
463     }
464 
465     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
466         uint256 currentAllowance = _allowances[msg.sender][spender];
467         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
468         unchecked {
469             _approve(msg.sender, spender, currentAllowance - subtractedValue);
470         }
471 
472         return true;
473     }
474 
475     function _approve(
476         address owner,
477         address spender,
478         uint256 amount
479     ) internal virtual {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     function approveMax(address spender) external returns (bool) {
488         return approve(spender, type(uint256).max);
489     }
490 
491     function setProtection(bool _protect) external onlyOwner {
492         if (_protect)
493             require(!protectionDisabled);
494         protectionEnabled = _protect;
495     }
496     
497     function setProtection(address _protection, bool _call) external onlyOwner {
498         if (_protection != address(antisnipe)){
499             require(!protectionDisabled);
500             antisnipe = IAntiSnipe(_protection);
501         }
502         if (_call)
503             antisnipe.setTokenOwner(msg.sender);
504     }
505     
506     function disableProtection() external onlyOwner {
507         protectionDisabled = true;
508     }
509 
510     function transfer(address recipient, uint256 amount) external override returns (bool) {
511         return _transferFrom(msg.sender, recipient, amount);
512     }
513 
514     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
515         if(_allowances[sender][msg.sender] != type(uint256).max){
516             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
517         }
518 
519         return _transferFrom(sender, recipient, amount);
520     }
521 
522     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
523         require(_balances[sender] >= amount, "Insufficient balance");
524         require(amount > 0, "Zero amount transferred");
525 
526         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
527 
528         checkTxLimit(sender, amount);
529         
530         if (!liquidityPools[recipient] && recipient != DEAD) {
531             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
532         }
533 
534         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient], "Contract not launched yet."); }
535 
536         _balances[sender] -= amount;
537 
538         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
539         
540         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
541         
542         _balances[recipient] += amountReceived;
543             
544         if(launched() && protectionEnabled)
545             antisnipe.onPreTransferCheck(sender, recipient, amount);
546 
547         emit Transfer(sender, recipient, amountReceived);
548         return true;
549     }
550 
551     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
552         _balances[sender] -= amount;
553         _balances[recipient] += amount;
554         emit Transfer(sender, recipient, amount);
555         return true;
556     }
557     
558     function checkWalletLimit(address recipient, uint256 amount) internal view {
559         uint256 walletLimit = _maxWalletSize;
560         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
561     }
562 
563     function checkTxLimit(address sender, uint256 amount) internal view {
564         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
565     }
566 
567     function shouldTakeFee(address sender) internal view returns (bool) {
568         return !isFeeExempt[sender];
569     }
570     
571     function setLiquidityProvider(address _provider) external onlyOwner {
572         isFeeExempt[_provider] = true;
573         liquidityProviders[_provider] = true;
574         isTxLimitExempt[_provider] = true;
575     }
576 
577     function getTotalFee(bool selling, bool inHighPeriod) public view returns (uint256) {
578         if(launchedAt == block.number){ return feeDenominator - 1; }
579         if (selling) return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee + sellBias;
580         return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee - sellBias;
581     }
582 
583     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
584         uint256 feeAmount = 0;
585         if(liquidityPools[recipient] && antiDumpTax > 0) {
586             (uint112 reserve0, uint112 reserve1,) = IDEXPair(pair).getReserves();
587             uint256 impactEstimate = amount * 1000 / ((antiDumpReserve0 ? reserve0 : reserve1) + amount);
588             
589             if (block.timestamp > lastSell[sender] + antiDumpPeriod) {
590                 lastSell[sender] = block.timestamp;
591                 lastSellAmount[sender] = 0;
592             }
593             
594             lastSellAmount[sender] += impactEstimate;
595             
596             if (lastSellAmount[sender] >= antiDumpThreshold) {
597                 feeAmount = (totalFee * antiDumpTax) / 100;
598             }
599         }
600 
601         if (feeAmount == 0)
602             feeAmount = (amount * getTotalFee(liquidityPools[recipient], !liquidityPools[sender] && lastBuy[sender] + sellPeriod > block.timestamp)) / feeDenominator;
603         
604         if (liquidityPools[sender] && lastBuy[recipient] == 0)
605             lastBuy[recipient] = block.timestamp;
606 
607         _balances[address(this)] += feeAmount;
608         emit Transfer(sender, address(this), feeAmount);
609 
610         return amount - feeAmount;
611     }
612 
613     function shouldSwapBack(address recipient) internal view returns (bool) {
614         return !liquidityPools[msg.sender]
615         && !isFeeExempt[msg.sender]
616         && !inSwap
617         && swapEnabled
618         && liquidityPools[recipient]
619         && _balances[address(this)] >= swapMinimum &&
620         totalFee > 0;
621     }
622 
623     function swapBack(uint256 amount) internal swapping {
624         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
625         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
626         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
627         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / totalFee) / 2;
628         amountToSwap -= amountToLiquify;
629 
630         address[] memory path = new address[](2);
631         path[0] = address(this);
632         path[1] = router.WETH();
633         
634         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
635             amountToSwap,
636             0,
637             path,
638             address(this),
639             block.timestamp
640         );
641 
642         uint256 contractBalance = address(this).balance;
643         uint256 totalETHFee = totalFee - dynamicLiquidityFee / 2;
644 
645         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
646         uint256 amountMarketing = (contractBalance * marketingFee) / totalETHFee;
647         uint256 amountDev = contractBalance - (amountLiquidity + amountMarketing);
648 
649         if(amountToLiquify > 0) {
650             router.addLiquidityETH{value: amountLiquidity}(
651                 address(this),
652                 amountToLiquify,
653                 0,
654                 0,
655                 liquidityReceiver,
656                 block.timestamp
657             );
658             emit AutoLiquify(amountLiquidity, amountToLiquify);
659         }
660         
661         if (amountMarketing > 0)
662             marketingReceiver.transfer(amountMarketing);
663             
664         if (amountDev > 0)
665             devReceiver.transfer(amountDev);
666 
667     }
668 
669     function setSellPeriod(uint256 _sellPercentIncrease, uint256 _period) external onlyOwner {
670         require((totalFee * _sellPercentIncrease) / 100 <= 400, "Sell tax too high");
671         require(_sellPercentIncrease >= 100, "Can't make sells cheaper with this");
672         require(_period <= 7 days, "Sell period too long");
673         sellPercent = _sellPercentIncrease;
674         sellPeriod = _period;
675     }
676 
677     function setAntiDumpTax(uint256 _tax, uint256 _period, uint256 _threshold, bool _reserve0) external onlyOwner {
678         require(_threshold >= 10 && _tax <= 400 && (_tax == 0 || _tax >= sellPercent) && _period <= 1 hours, "Parameters out of bounds");
679         antiDumpTax = _tax;
680         antiDumpPeriod = _period;
681         antiDumpThreshold = _threshold;
682         antiDumpReserve0 = _reserve0;
683     }
684 
685     function launched() internal view returns (bool) {
686         return launchedAt != 0;
687     }
688 
689     function launch() external onlyOwner {
690         require (launchedAt == 0);
691         launchedAt = block.number;
692         launchedTime = block.timestamp;
693     }
694 
695     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
696         require(numerator > 0 && divisor > 0 && (numerator * 1000) / divisor >= 5);
697         _maxTxAmount = (_totalSupply * numerator) / divisor;
698     }
699     
700     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
701         require(divisor > 0 && divisor <= 10000);
702         _maxWalletSize = (_totalSupply * numerator) / divisor;
703     }
704 
705     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
706         isFeeExempt[holder] = exempt;
707     }
708 
709     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
710         isTxLimitExempt[holder] = exempt;
711     }
712 
713     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
714         liquidityFee = _liquidityFee;
715         marketingFee = _marketingFee;
716         devFee = _devFee;
717         sellBias = _sellBias;
718         totalFee = _liquidityFee + _marketingFee + _devFee;
719         feeDenominator = _feeDenominator;
720         require(totalFee <= feeDenominator / 4);
721         require(sellBias <= totalFee);
722     }
723 
724     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
725         require(_denominator > 0 && _denominatorMin > 0);
726         swapEnabled = _enabled;
727         swapMinimum = _totalSupply / _denominatorMin;
728         swapThreshold = _totalSupply / _denominator;
729     }
730 
731     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
732         targetLiquidity = _target;
733         targetLiquidityDenominator = _denominator;
734     }
735 
736     function getCirculatingSupply() public view returns (uint256) {
737         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
738     }
739 
740     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
741         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
742     }
743 
744     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
745         return getLiquidityBacking(accuracy) > target;
746     }
747 
748     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
749         liquidityPools[_pool] = _enabled;
750     }
751 
752 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
753     {
754         require(_addresses.length == _amount.length);
755         bool previousSwap = swapEnabled;
756         swapEnabled = false;
757         //This function may run out of gas intentionally to prevent partial airdrops
758         for (uint256 i = 0; i < _addresses.length; i++) {
759             require(!liquidityPools[_addresses[i]]);
760             _transferFrom(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
761         }
762         swapEnabled = previousSwap;
763     }
764 
765     event AutoLiquify(uint256 amount, uint256 amountToken);
766     //C U ON THE MOON
767 }