1 /*
2 Shikage SHKG
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
231 interface IDEXFactory {
232     function createPair(address tokenA, address tokenB) external returns (address pair);
233 }
234 
235 interface IDEXRouter {
236     function factory() external pure returns (address);
237     function WETH() external pure returns (address);
238 
239     function addLiquidity(
240         address tokenA,
241         address tokenB,
242         uint amountADesired,
243         uint amountBDesired,
244         uint amountAMin,
245         uint amountBMin,
246         address to,
247         uint deadline
248     ) external returns (uint amountA, uint amountB, uint liquidity);
249 
250     function addLiquidityETH(
251         address token,
252         uint amountTokenDesired,
253         uint amountTokenMin,
254         uint amountETHMin,
255         address to,
256         uint deadline
257     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
258 
259     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
260         uint amountIn,
261         uint amountOutMin,
262         address[] calldata path,
263         address to,
264         uint deadline
265     ) external;
266 
267     function swapExactETHForTokensSupportingFeeOnTransferTokens(
268         uint amountOutMin,
269         address[] calldata path,
270         address to,
271         uint deadline
272     ) external payable;
273 
274     function swapExactTokensForETHSupportingFeeOnTransferTokens(
275         uint amountIn,
276         uint amountOutMin,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external;
281 }
282 
283 /**
284  * @dev Contract module which provides a basic access control mechanism, where
285  * there is an account (an owner) that can be granted exclusive access to
286  * specific functions.
287  *
288  * By default, the owner account will be the one that deploys the contract. This
289  * can later be changed with {transferOwnership}.
290  *
291  * This module is used through inheritance. It will make available the modifier
292  * `onlyOwner`, which can be applied to your functions to restrict their use to
293  * the owner.
294  */
295 contract Ownable is Context {
296     address private _owner;
297 
298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
299 
300     /**
301      * @dev Initializes the contract setting the deployer as the initial owner.
302      */
303     constructor () {
304         address msgSender = _msgSender();
305         _owner = msgSender;
306         emit OwnershipTransferred(address(0), msgSender);
307     }
308 
309     /**
310      * @dev Returns the address of the current owner.
311      */
312     function owner() public view returns (address) {
313         return _owner;
314     }
315 
316     /**
317      * @dev Throws if called by any account other than the owner.
318      */
319     modifier onlyOwner() {
320         require(_owner == _msgSender(), "Ownable: caller is not the owner");
321         _;
322     }
323      /**
324      * @dev Leaves the contract without owner. It will not be possible to call
325      * `onlyOwner` functions anymore. Can only be called by the current owner.
326      *
327      * NOTE: Renouncing ownership will leave the contract without an owner,
328      * thereby removing any functionality that is only available to the owner.
329      */
330     function renounceOwnership() public virtual onlyOwner {
331         emit OwnershipTransferred(_owner, address(0));
332         _owner = address(0);
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Can only be called by the current owner.
338      */
339     function transferOwnership(address newOwner) public virtual onlyOwner {
340         require(newOwner != address(0), "Ownable: new owner is the zero address");
341         emit OwnershipTransferred(_owner, newOwner);
342         _owner = newOwner;
343     }
344 }
345 
346 interface IAntiSnipe {
347   function setTokenOwner(address owner) external;
348 
349   function onPreTransferCheck(
350     address from,
351     address to,
352     uint256 amount
353   ) external returns (bool checked);
354 }
355 
356 contract Shikage is IERC20, Ownable {
357     using Address for address;
358     
359     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
360     address constant ZERO = 0x0000000000000000000000000000000000000000;
361 
362     string constant _name = "Shikage";
363     string constant _symbol = "SHKG";
364     uint8 constant _decimals = 9;
365 
366     uint256 constant _totalSupply = 1_000_000_000 * (10 ** _decimals);
367     uint256 public _maxTxAmount = (_totalSupply * 1) / 200;
368     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;
369 
370     mapping (address => uint256) _balances;
371     mapping (address => mapping (address => uint256)) _allowances;
372     mapping (address => uint256) lastBuy;
373 
374     mapping (address => bool) isFeeExempt;
375     mapping (address => bool) isTxLimitExempt;
376 
377     uint256 liquidityFee = 20;
378     uint256 marketingFee = 50;
379     uint256 devFee = 30;
380     uint256 totalFee = 100;
381     uint256 sellBias = 0;
382     uint256 sellPercent = 250;
383     uint256 sellPeriod = 72 hours;
384     uint256 feeDenominator = 1000;
385 
386     address public constant liquidityReceiver = 0x51FE1EDbC149556eF2867115E58616428aA2C19A;
387     address payable public constant marketingReceiver = payable(0x51FE1EDbC149556eF2867115E58616428aA2C19A);
388     address payable public constant devReceiver = payable(0x592Ab8ED942c7Eb84cB27616f1Dcb57669DFD901);
389 
390     uint256 targetLiquidity = 40;
391     uint256 targetLiquidityDenominator = 100;
392 
393     IDEXRouter public immutable router;
394     
395     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
396 
397     mapping (address => bool) liquidityPools;
398     mapping (address => bool) liquidityProviders;
399 
400     address public immutable pair;
401 
402     uint256 public launchedAt;
403     uint256 public launchedTime;
404     bool public pauseDisabled = false;
405     
406     IAntiSnipe public antisnipe;
407     bool public protectionEnabled = true;
408     bool public protectionDisabled = false;
409 
410     bool public swapEnabled = true;
411     uint256 public swapThreshold = _totalSupply / 400;
412     uint256 public swapMinimum = _totalSupply / 10000;
413     bool inSwap;
414     modifier swapping() { inSwap = true; _; inSwap = false; }
415 
416     constructor () {
417         router = IDEXRouter(routerAddress);
418         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
419         liquidityPools[pair] = true;
420         _allowances[owner()][routerAddress] = type(uint256).max;
421         _allowances[address(this)][routerAddress] = type(uint256).max;
422         
423         isFeeExempt[owner()] = true;
424         liquidityProviders[msg.sender] = true;
425 
426         isTxLimitExempt[address(this)] = true;
427         isTxLimitExempt[owner()] = true;
428         isTxLimitExempt[routerAddress] = true;
429 
430         _balances[owner()] = _totalSupply;
431         emit Transfer(address(0), owner(), _totalSupply);
432     }
433 
434     receive() external payable { }
435 
436     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
437     function decimals() external pure returns (uint8) { return _decimals; }
438     function symbol() external pure returns (string memory) { return _symbol; }
439     function name() external pure returns (string memory) { return _name; }
440     function getOwner() external view returns (address) { return owner(); }
441     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
442     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
443 
444     function approve(address spender, uint256 amount) public override returns (bool) {
445         _allowances[msg.sender][spender] = amount;
446         emit Approval(msg.sender, spender, amount);
447         return true;
448     }
449 
450     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
451         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
452         return true;
453     }
454 
455     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
456         uint256 currentAllowance = _allowances[msg.sender][spender];
457         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
458         unchecked {
459             _approve(msg.sender, spender, currentAllowance - subtractedValue);
460         }
461 
462         return true;
463     }
464 
465     function _approve(
466         address owner,
467         address spender,
468         uint256 amount
469     ) internal virtual {
470         require(owner != address(0), "ERC20: approve from the zero address");
471         require(spender != address(0), "ERC20: approve to the zero address");
472 
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     function approveMax(address spender) external returns (bool) {
478         return approve(spender, type(uint256).max);
479     }
480 
481     function setProtection(bool _protect) external onlyOwner {
482         if (_protect)
483             require(!protectionDisabled);
484         protectionEnabled = _protect;
485     }
486     
487     function setProtection(address _protection, bool _call) external onlyOwner {
488         if (_protection != address(antisnipe)){
489             require(!protectionDisabled);
490             antisnipe = IAntiSnipe(_protection);
491         }
492         if (_call)
493             antisnipe.setTokenOwner(msg.sender);
494     }
495     
496     function disableProtection() external onlyOwner {
497         protectionDisabled = true;
498     }
499 
500     function transfer(address recipient, uint256 amount) external override returns (bool) {
501         return _transferFrom(msg.sender, recipient, amount);
502     }
503 
504     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
505         if(_allowances[sender][msg.sender] != type(uint256).max){
506             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
507         }
508 
509         return _transferFrom(sender, recipient, amount);
510     }
511 
512     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
513         require(_balances[sender] >= amount, "Insufficient balance");
514         require(amount > 0, "Zero amount transferred");
515 
516         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
517 
518         checkTxLimit(sender, amount);
519         
520         if (!liquidityPools[recipient] && recipient != DEAD) {
521             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
522         }
523 
524         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient], "Contract not launched yet."); }
525 
526         _balances[sender] -= amount;
527 
528         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
529         
530         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
531         
532         _balances[recipient] += amountReceived;
533             
534         if(launched() && protectionEnabled)
535             antisnipe.onPreTransferCheck(sender, recipient, amount);
536 
537         emit Transfer(sender, recipient, amountReceived);
538         return true;
539     }
540 
541     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
542         _balances[sender] -= amount;
543         _balances[recipient] += amount;
544         emit Transfer(sender, recipient, amount);
545         return true;
546     }
547     
548     function checkWalletLimit(address recipient, uint256 amount) internal view {
549         uint256 walletLimit = _maxWalletSize;
550         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
551     }
552 
553     function checkTxLimit(address sender, uint256 amount) internal view {
554         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
555     }
556 
557     function shouldTakeFee(address sender) internal view returns (bool) {
558         return !isFeeExempt[sender];
559     }
560     
561     function setLiquidityProvider(address _provider) external onlyOwner {
562         isFeeExempt[_provider] = true;
563         liquidityProviders[_provider] = true;
564         isTxLimitExempt[_provider] = true;
565     }
566 
567     function getTotalFee(bool selling, bool inHighPeriod) public view returns (uint256) {
568         if(launchedAt + 1 > block.number){ return feeDenominator - 1; }
569         if (selling) return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee + sellBias;
570         return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee - sellBias;
571     }
572 
573     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
574         uint256 feeAmount = (amount * getTotalFee(liquidityPools[recipient], !liquidityPools[sender] && lastBuy[sender] + sellPeriod > block.timestamp)) / feeDenominator;
575         
576         if (liquidityPools[sender] && lastBuy[recipient] == 0)
577             lastBuy[recipient] = block.timestamp;
578 
579         _balances[address(this)] += feeAmount;
580         emit Transfer(sender, address(this), feeAmount);
581 
582         return amount - feeAmount;
583     }
584 
585     function shouldSwapBack(address recipient) internal view returns (bool) {
586         return !liquidityPools[msg.sender]
587         && !isFeeExempt[msg.sender]
588         && !inSwap
589         && swapEnabled
590         && liquidityPools[recipient]
591         && _balances[address(this)] >= swapMinimum &&
592         totalFee > 0;
593     }
594 
595     function swapBack(uint256 amount) internal swapping {
596         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
597         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
598         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
599         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / totalFee) / 2;
600         amountToSwap -= amountToLiquify;
601 
602         address[] memory path = new address[](2);
603         path[0] = address(this);
604         path[1] = router.WETH();
605         
606         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
607             amountToSwap,
608             0,
609             path,
610             address(this),
611             block.timestamp
612         );
613 
614         uint256 contractBalance = address(this).balance;
615         uint256 totalETHFee = totalFee - dynamicLiquidityFee / 2;
616 
617         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
618         uint256 amountMarketing = (contractBalance * marketingFee) / totalETHFee;
619         uint256 amountDev = contractBalance - (amountLiquidity + amountMarketing);
620 
621         if(amountToLiquify > 0) {
622             router.addLiquidityETH{value: amountLiquidity}(
623                 address(this),
624                 amountToLiquify,
625                 0,
626                 0,
627                 liquidityReceiver,
628                 block.timestamp
629             );
630             emit AutoLiquify(amountLiquidity, amountToLiquify);
631         }
632         
633         if (amountMarketing > 0)
634             marketingReceiver.transfer(amountMarketing);
635             
636         if (amountDev > 0)
637             devReceiver.transfer(amountDev);
638 
639     }
640 
641     function setSellPeriod(uint256 _sellPercentIncrease, uint256 _period) external onlyOwner {
642         require((totalFee * _sellPercentIncrease) / 100 <= 400, "Sell tax too high");
643         require(_period <= 7 days, "Sell period too long");
644         sellPercent = _sellPercentIncrease;
645         sellPeriod = _period;
646     }
647 
648     function launched() internal view returns (bool) {
649         return launchedAt != 0;
650     }
651 
652     function launch() external onlyOwner {
653         require (launchedAt == 0);
654         launchedAt = block.number;
655         launchedTime = block.timestamp;
656     }
657 
658     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
659         require(numerator > 0 && divisor > 0 && (numerator * 1000) / divisor >= 5);
660         _maxTxAmount = (_totalSupply * numerator) / divisor;
661     }
662     
663     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
664         require(divisor > 0 && divisor <= 10000);
665         _maxWalletSize = (_totalSupply * numerator) / divisor;
666     }
667 
668     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
669         isFeeExempt[holder] = exempt;
670     }
671 
672     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
673         isTxLimitExempt[holder] = exempt;
674     }
675 
676     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
677         liquidityFee = _liquidityFee;
678         marketingFee = _marketingFee;
679         devFee = _devFee;
680         sellBias = _sellBias;
681         totalFee = _liquidityFee + _marketingFee + _devFee;
682         feeDenominator = _feeDenominator;
683         require(totalFee <= feeDenominator / 4);
684         require(sellBias <= totalFee);
685     }
686 
687     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
688         require(_denominator > 0 && _denominatorMin > 0);
689         swapEnabled = _enabled;
690         swapMinimum = _totalSupply / _denominatorMin;
691         swapThreshold = _totalSupply / _denominator;
692     }
693 
694     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
695         targetLiquidity = _target;
696         targetLiquidityDenominator = _denominator;
697     }
698 
699     function getCirculatingSupply() public view returns (uint256) {
700         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
701     }
702 
703     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
704         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
705     }
706 
707     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
708         return getLiquidityBacking(accuracy) > target;
709     }
710 
711     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
712         liquidityPools[_pool] = _enabled;
713     }
714 
715 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
716     {
717         require(_addresses.length == _amount.length);
718         bool previousSwap = swapEnabled;
719         swapEnabled = false;
720         //This function may run out of gas intentionally to prevent partial airdrops
721         for (uint256 i = 0; i < _addresses.length; i++) {
722             require(!liquidityPools[_addresses[i]]);
723             _transferFrom(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
724         }
725         swapEnabled = previousSwap;
726     }
727 
728     event AutoLiquify(uint256 amount, uint256 amountToken);
729     //C U ON THE MOON
730 }