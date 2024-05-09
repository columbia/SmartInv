1 /*
2 
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.11;
8 
9 
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * C U ON THE MOON
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
31         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
32         // for accounts without code, i.e. `keccak256('')`
33         bytes32 codehash;
34         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
35         // solhint-disable-next-line no-inline-assembly
36         assembly { codehash := extcodehash(account) }
37         return (codehash != accountHash && codehash != 0x0);
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
60         (bool success, ) = recipient.call{ value: amount }("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain`call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83       return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
93         return _functionCallWithValue(target, data, 0, errorMessage);
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
98      * but also transferring `value` wei to `target`.
99      *
100      * Requirements:
101      *
102      * - the calling contract must have an ETH balance of at least `value`.
103      * - the called Solidity function must be `payable`.
104      *
105      * _Available since v3.1._
106      */
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
113      * with `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         return _functionCallWithValue(target, data, value, errorMessage);
120     }
121 
122     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
123         require(isContract(target), "Address: call to non-contract");
124 
125         // solhint-disable-next-line avoid-low-level-calls
126         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
127         if (success) {
128             return returndata;
129         } else {
130             // Look for revert reason and bubble it up if present
131             if (returndata.length > 0) {
132                 // The easiest way to bubble the revert reason is using memory via assembly
133 
134                 // solhint-disable-next-line no-inline-assembly
135                 assembly {
136                     let returndata_size := mload(returndata)
137                     revert(add(32, returndata), returndata_size)
138                 }
139             } else {
140                 revert(errorMessage);
141             }
142         }
143     }
144 }
145 
146 abstract contract Context {
147     function _msgSender() internal view returns (address payable) {
148         return payable(msg.sender);
149     }
150 
151     function _msgData() internal view returns (bytes memory) {
152         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
153         return msg.data;
154     }
155 }
156 
157 interface IERC20 {
158 
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `recipient`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transfer(address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through {transferFrom}. This is
178      * zero by default.
179      *
180      * This value changes when {approve} or {transferFrom} are called.
181      */
182     function allowance(address owner, address spender) external view returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * IMPORTANT: Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     /**
220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221      * a call to {approve}. `value` is the new allowance.
222      */
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * By default, the owner account will be the one that deploys the contract. This
232  * can later be changed with {transferOwnership}.
233  *
234  * This module is used through inheritance. It will make available the modifier
235  * `onlyOwner`, which can be applied to your functions to restrict their use to
236  * the owner.
237  */
238 contract Ownable is Context {
239     address private _owner;
240 
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor () {
247         address msgSender = _msgSender();
248         _owner = msgSender;
249         emit OwnershipTransferred(address(0), msgSender);
250     }
251 
252     /**
253      * @dev Returns the address of the current owner.
254      */
255     function owner() public view returns (address) {
256         return _owner;
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         require(_owner == _msgSender(), "Ownable: caller is not the owner");
264         _;
265     }
266      /**
267      * @dev Leaves the contract without owner. It will not be possible to call
268      * `onlyOwner` functions anymore. Can only be called by the current owner.
269      *
270      * NOTE: Renouncing ownership will leave the contract without an owner,
271      * thereby removing any functionality that is only available to the owner.
272      */
273     function renounceOwnership() public virtual onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Can only be called by the current owner.
281      */
282     function transferOwnership(address newOwner) public virtual onlyOwner {
283         require(newOwner != address(0), "Ownable: new owner is the zero address");
284         emit OwnershipTransferred(_owner, newOwner);
285         _owner = newOwner;
286     }
287 }
288 
289 interface IDEXFactory {
290     function createPair(address tokenA, address tokenB) external returns (address pair);
291 }
292 
293 interface IDEXRouter {
294     function factory() external pure returns (address);
295     function WETH() external pure returns (address);
296 
297     function addLiquidity(
298         address tokenA,
299         address tokenB,
300         uint amountADesired,
301         uint amountBDesired,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline
306     ) external returns (uint amountA, uint amountB, uint liquidity);
307 
308     function addLiquidityETH(
309         address token,
310         uint amountTokenDesired,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline
315     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
316 
317     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
318         uint amountIn,
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external;
324 
325     function swapExactETHForTokensSupportingFeeOnTransferTokens(
326         uint amountOutMin,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external payable;
331 
332     function swapExactTokensForETHSupportingFeeOnTransferTokens(
333         uint amountIn,
334         uint amountOutMin,
335         address[] calldata path,
336         address to,
337         uint deadline
338     ) external;
339 }
340 
341 interface IDividendDistributor {
342     function initialize() external;
343     function setPrimaryDistributor(address distributor) external;
344     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
345     function setShare(address shareholder, uint256 amount) external;
346     function deposit() external payable;
347     function claimDividend(address shareholder) external;
348     function getUnpaidEarnings(address shareholder) external view returns (uint256);
349     function getPaidDividends(address shareholder) external view returns (uint256);
350     function getTotalPaid() external view returns (uint256);
351     function getClaimTime(address shareholder) external view returns (uint256);
352     function getLostRewards(address shareholder) external view returns (uint256);
353     function countShareholders() external view returns (uint256);
354 }
355 
356 contract DividendDistributor is IDividendDistributor {
357 
358     address _token;
359 
360     struct Share {
361         uint256 amount;
362         uint256 totalExcluded;
363         uint256 totalRealised;
364         uint256 totalLost;
365     }
366 
367     address[] shareholders;
368     mapping (address => uint256) shareholderIndexes;
369     mapping (address => uint256) public shareholderClaims;
370 
371     mapping (address => Share) public shares;
372 
373     uint256 public totalShares;
374     uint256 public totalDividends;
375     uint256 public totalDistributed;
376     uint256 public totalSacrificed;
377     uint256 public dividendsPerShare;
378     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
379 
380     uint256 public minPeriod = 24 hours;
381     uint256 public minDistribution = 1 * (10 ** 15);
382     
383     DividendDistributor primaryDistributor;
384     bool isBonusPool = false;
385 
386     bool initialized;
387     modifier initialization() {
388         require(!initialized);
389         _;
390         initialized = true;
391     }
392 
393     modifier onlyToken() {
394         require(msg.sender == _token); _;
395     }
396 
397     constructor () {
398     }
399     
400     function initialize() external override initialization {
401         _token = msg.sender;
402     }
403     
404     function setPrimaryDistributor(address distributor) external override onlyToken {
405         require(!isBonusPool);
406         primaryDistributor = DividendDistributor(distributor);
407         isBonusPool = true;
408         minPeriod = 7 days;
409     }
410     
411     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {
412         minPeriod = _minPeriod;
413         minDistribution = _minDistribution;
414     }
415 
416     function setShare(address shareholder, uint256 amount) external override onlyToken {
417         if(amount > 0 && shares[shareholder].amount == 0){
418             addShareholder(shareholder);
419             shares[shareholder].totalExcluded = getCumulativeDividends(amount);
420             shareholderClaims[shareholder] = block.timestamp;
421         }else if(amount == 0 && shares[shareholder].amount > 0){
422             removeShareholder(shareholder);
423         }
424         
425         bool sharesIncreased = shares[shareholder].amount < amount;
426         uint256 unpaid = getUnpaidEarnings(shareholder);
427         
428         if(sharesIncreased){
429             if (shouldDistribute(shareholder, unpaid))
430                 distributeDividend(shareholder, unpaid);
431             
432             shares[shareholder].totalExcluded += getCumulativeDividends(amount - shares[shareholder].amount);
433         }
434         
435         totalShares = (totalShares - shares[shareholder].amount) + amount;
436         shares[shareholder].amount = amount;
437         
438         if (!sharesIncreased) {
439             if (address(this).balance < unpaid) unpaid = address(this).balance;
440             totalSacrificed = totalSacrificed + unpaid;
441             shares[shareholder].totalLost += unpaid;
442             payable(_token).transfer(unpaid);
443             shares[shareholder].totalExcluded = getCumulativeDividends(amount);
444         }
445     }
446 
447     function deposit() external payable override {
448         uint256 amount = msg.value;
449 
450         totalDividends = totalDividends + amount;
451         dividendsPerShare += ((dividendsPerShareAccuracyFactor * amount) / totalShares);
452     }
453 
454     function shouldDistribute(address shareholder, uint256 unpaidEarnings) internal view returns (bool) {
455 	   if(!isBonusPool)
456             return shareholderClaims[shareholder] + minPeriod < block.timestamp && unpaidEarnings > minDistribution;
457         else {
458     	    return shareholderClaims[shareholder] < 1646308800 + (((block.timestamp - 1646308800) / 604800) * 604800);
459         }
460             
461     }
462     
463     function getClaimTime(address shareholder) external override view onlyToken returns (uint256) {
464         if (shareholderClaims[shareholder] + minPeriod <= block.timestamp || isBonusPool)
465             return 0;
466         else
467             return (shareholderClaims[shareholder] + minPeriod) - block.timestamp;
468     }
469 
470     function distributeDividend(address shareholder, uint256 unpaidEarnings) internal {
471         if(shares[shareholder].amount == 0){ return; }
472 
473         if(unpaidEarnings > 0){
474             totalDistributed = totalDistributed + unpaidEarnings;
475             shareholderClaims[shareholder] = block.timestamp;
476             shares[shareholder].totalRealised = shares[shareholder].totalRealised + unpaidEarnings;
477             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
478             payable(shareholder).transfer(unpaidEarnings);
479         }
480     }
481 
482     function claimDividend(address shareholder) external override onlyToken {
483         require(shouldDistribute(shareholder, getUnpaidEarnings(shareholder)), "Dividends not available yet");
484         distributeDividend(shareholder, getUnpaidEarnings(shareholder));
485     }
486 
487     function getUnpaidEarnings(address shareholder) public view override onlyToken returns (uint256) {
488         if(shares[shareholder].amount == 0){ return 0; }
489 
490         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
491         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
492 
493         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
494 
495         return shareholderTotalDividends - shareholderTotalExcluded;
496     }
497     
498     function getPaidDividends(address shareholder) external view override onlyToken returns (uint256) {
499         return shares[shareholder].totalRealised;
500     }
501     
502     function getTotalPaid() external view override onlyToken returns (uint256) {
503         return totalDistributed;
504     }
505     
506     function countShareholders() external view override onlyToken returns (uint256) {
507         return shareholders.length;
508     }
509     
510     function getLostRewards(address shareholder) external view override onlyToken returns (uint256) {
511         return shares[shareholder].totalLost;
512     }
513 
514     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
515         if(share == 0){ return 0; }
516         return (share * dividendsPerShare) / dividendsPerShareAccuracyFactor;
517     }
518 
519     function addShareholder(address shareholder) internal {
520         shareholderIndexes[shareholder] = shareholders.length;
521         shareholders.push(shareholder);
522     }
523 
524     function removeShareholder(address shareholder) internal {
525         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
526         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
527         shareholders.pop();
528     }
529 }
530 
531 interface IProtect {
532   function setTokenOwner(address main, address owner, address pair) external;
533 
534   function onPreTransferCheck(
535     address from,
536     address to,
537     uint256 amount
538   ) external returns (bool checked);
539 }
540 
541 contract Mjolnir is IERC20, Ownable {
542     using Address for address;
543     
544     address WBNB;
545     address DEAD = 0x000000000000000000000000000000000000dEaD;
546     address ZERO = 0x0000000000000000000000000000000000000000;
547     IERC20[] discountTokens;
548     uint256[] discountTokenMaxWallet;
549 
550     string constant _name = "Mjolnir";
551     string constant _symbol = "MJOLNIR";
552     uint8 constant _decimals = 9;
553 
554     uint256 _totalSupply = 1_000_000_000_000 * (10 ** _decimals);
555     uint256 public _maxTxAmount = (_totalSupply * 1) / 100;
556     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;
557 
558     mapping (address => uint256) _balances;
559     mapping (address => mapping (address => uint256)) _allowances;
560 
561     mapping (address => bool) public isFeeExempt;
562     mapping (address => bool) public isTxLimitExempt;
563     mapping (address => bool) public isDividendExempt;
564     mapping (address => uint256) lastSell;
565 
566     uint256 devFee = 400;
567     uint256 buybackFee = 100;
568     uint256 reflectionFee = 200;
569     uint256 bonusPercent = 10;
570     uint256 marketingFee = 500;
571     uint256 totalFee = 1200;
572     uint256 feeDenominator = 10000;
573     uint256 public _sellMultiplierNumerator = 100;
574     uint256 public _sellMultiplierDenominator = 100;
575     uint256 public _dumpProtectionNumerator = 0;
576     uint256 public _dumpProtectionDenominator = 100 * _maxTxAmount;
577     uint256 public _dumpProtectionThreshold = 1;
578     uint256 public _dumpProtectionTimer = 0;
579     uint256 public _discountNumerator = 0;
580     uint256 public _discountDenominator = 100;
581     bool public rewardsActive = true;
582 
583     address payable devFeeReceiver;
584     address payable marketingFeeReceiver;
585 
586     uint256 targetLiquidity = 25;
587     uint256 targetLiquidityDenominator = 100;
588 
589     IDEXRouter public router;
590     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
591 
592 
593     address public pair;
594 
595     uint256 public launchedAt;
596     uint256 public launchedTime;
597 
598     uint256 buybackMultiplierTriggeredAt;
599     uint256 buybackMultiplierLength = 30 minutes;
600 
601     bool public autoBuybackEnabled = false;
602     bool public autoBonusDeposit = false;
603     uint256 autoBuybackCap;
604     uint256 autoBuybackAccumulator;
605     uint256 autoBuybackAmount;
606     uint256 autoBuybackBlockPeriod;
607     uint256 autoBuybackBlockLast;
608 
609     DividendDistributor public distributor;
610     DividendDistributor public bonusDistributor;
611 
612     IProtect public antisnipe;
613     bool public protectionEnabled = true;
614     bool public protectionDisabled = false;
615 
616     bool public swapEnabled = true;
617     uint256 public swapThreshold = _totalSupply / 2000;
618     bool inSwap;
619     modifier swapping() { inSwap = true; _; inSwap = false; }
620 
621     constructor (address _marketing, address _dev) {
622         router = IDEXRouter(routerAddress);
623         WBNB = router.WETH();
624         pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
625         _allowances[msg.sender][routerAddress] = type(uint256).max;
626         _allowances[address(this)][routerAddress] = type(uint256).max;
627 
628         isFeeExempt[msg.sender] = true;
629         isTxLimitExempt[address(this)] = true;
630         isTxLimitExempt[msg.sender] = true;
631         isTxLimitExempt[routerAddress] = true;
632         isDividendExempt[pair] = true;
633         isDividendExempt[msg.sender] = true;
634         isDividendExempt[address(this)] = true;
635         isDividendExempt[DEAD] = true;
636         isDividendExempt[ZERO] = true;
637         devFeeReceiver = payable(_dev);
638         marketingFeeReceiver = payable(_marketing);
639 
640         _balances[msg.sender] = _totalSupply;
641         emit Transfer(address(0), msg.sender, _totalSupply);
642     }
643 
644     receive() external payable { }
645 
646     function totalSupply() external view override returns (uint256) { return _totalSupply; }
647     function decimals() external pure returns (uint8) { return _decimals; }
648     function symbol() external pure returns (string memory) { return _symbol; }
649     function name() external pure returns (string memory) { return _name; }
650     function getOwner() external view returns (address) { return owner(); }
651     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
652     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
653     
654     function airdrop(address[] memory addresses, uint256[] memory amounts) external onlyOwner {
655         require(addresses.length > 0 && amounts.length > 0 && addresses.length == amounts.length);
656         address from = msg.sender;
657         for (uint i = 0; i < addresses.length; i++) {
658             if(balanceOf(addresses[i]) == 0) {
659                 isDividendExempt[addresses[i]] = true;
660                 _transferFrom(from, addresses[i], amounts[i] * (10 ** _decimals));
661             }
662         }
663     }
664 
665     function approve(address spender, uint256 amount) public override returns (bool) {
666         _allowances[msg.sender][spender] = amount;
667         emit Approval(msg.sender, spender, amount);
668         return true;
669     }
670 
671     function approveMax(address spender) external returns (bool) {
672         return approve(spender, type(uint256).max);
673     }
674 
675     function transfer(address recipient, uint256 amount) external override returns (bool) {
676         return _transferFrom(msg.sender, recipient, amount);
677     }
678 
679     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
680         if(_allowances[sender][msg.sender] != type(uint256).max){
681             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
682         }
683 
684         return _transferFrom(sender, recipient, amount);
685     }
686 
687     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
688         require(amount > 0, "Zero amount transferred");
689         require(_balances[sender] >= amount, "Insufficient balance");
690         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
691 
692         checkTxLimit(sender, amount);
693         
694         if (recipient != pair && recipient != DEAD) {
695             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
696         }
697 
698         if(!launched() && recipient == pair){ require(sender == owner(), "Contract not launched yet."); launch(); }
699 
700         _balances[sender] = _balances[sender] - amount;
701 
702         uint256 amountReceived = !isFeeExempt[sender] ? takeFee(sender, recipient, amount) : amount;
703         
704         if(!isFeeExempt[recipient]) {
705             if(shouldSwapBack(recipient)){ swapBack(amount); }
706             if(shouldAutoBuyback(recipient)){ triggerAutoBuyback(); }
707         } 
708         
709         _balances[recipient] = _balances[recipient] + amountReceived;
710 
711         if(!isDividendExempt[sender]){ 
712             try distributor.setShare(sender, _balances[sender]) {} catch {} 
713             try bonusDistributor.setShare(sender, _balances[sender]) {} catch {}
714         }
715         if(!isDividendExempt[recipient]){ 
716             try distributor.setShare(recipient, _balances[recipient]) {} catch {} 
717             try bonusDistributor.setShare(recipient, _balances[recipient]) {} catch {}
718         }
719 
720         if(launched() && protectionEnabled)
721             antisnipe.onPreTransferCheck(sender, recipient, amount);
722 
723         emit Transfer(sender, recipient, amountReceived);
724         
725         return true;
726     }
727 
728     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
729         _balances[sender] = _balances[sender] - amount;
730         _balances[recipient] = _balances[recipient] + amount;
731         emit Transfer(sender, recipient, amount);
732         return true;
733     }
734     
735     function checkWalletLimit(address recipient, uint256 amount) internal view {
736         uint256 walletLimit = _maxWalletSize;
737         if (_discountNumerator > 0) {
738             uint256 discount = getDiscountRate(recipient);
739             if (discount > 0)
740                 walletLimit = walletLimit + (walletLimit * discount) / totalFee;
741         }
742         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
743     }
744 
745     function checkTxLimit(address sender, uint256 amount) internal view {
746         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
747     }
748     
749     function setup() external onlyOwner {
750         require(!launched());
751         distributor = new DividendDistributor();
752         distributor.initialize();
753         bonusDistributor = new DividendDistributor();
754         bonusDistributor.initialize();
755         bonusDistributor.setPrimaryDistributor(address(distributor));
756     }
757 
758     function setProtectionEnabled(bool _protect) external onlyOwner {
759         if (_protect)
760             require(!protectionDisabled);
761         protectionEnabled = _protect;
762     }
763     
764     function setProtection(address _protection, bool _call) external onlyOwner {
765         if (_protection != address(antisnipe)){
766             require(!protectionDisabled);
767             antisnipe = IProtect(_protection);
768         }
769         if (_call)
770             antisnipe.setTokenOwner(msg.sender, address(this), pair);
771     }
772     
773     function disableProtection() external onlyOwner {
774         protectionDisabled = true;
775     }
776     
777     function setDistributors(address _distributor, address _bonusDistributor) external onlyOwner {
778         distributor = DividendDistributor(_distributor);
779         distributor.initialize();
780         bonusDistributor = DividendDistributor(_bonusDistributor);
781         bonusDistributor.initialize();
782         bonusDistributor.setPrimaryDistributor(_distributor);
783     }
784     
785     function setDiscountToken(address _discountToken, uint256 _discountMaxWallet) external onlyOwner {
786         require(_discountToken.isContract());
787         discountTokens.push(IERC20(_discountToken));
788         discountTokenMaxWallet.push(_discountMaxWallet);
789     }
790     
791     function removeDiscountToken() external onlyOwner {
792         discountTokens.pop();
793         discountTokenMaxWallet.pop();
794     }
795     
796     function getDiscountRate(address account) internal view returns (uint256) {
797         uint256 balance = discountTokens[0].balanceOf(account);
798         uint256 discount;
799         for (uint i = 0; i < discountTokens.length; i++) {
800             balance = discountTokens[i].balanceOf(account);
801             if (balance > discountTokenMaxWallet[i]) balance = discountTokenMaxWallet[i];
802             if (balance > 0) discount = discount + (totalFee * balance * _discountNumerator) / (_discountDenominator * discountTokenMaxWallet[i]);
803         }
804         return discount;
805     }
806 
807     function getTotalFee(bool selling, address sender, address recipient, uint256 amount) public view returns (uint256) {
808         if(launchedAt + 2 > block.number){ return feeDenominator - 1; }
809         if(selling){
810             if (amount <= swapThreshold * _dumpProtectionThreshold && lastSell[sender] + _dumpProtectionTimer < block.number)
811                 return (totalFee * _sellMultiplierNumerator) / _sellMultiplierDenominator;
812             else
813                 return (totalFee * _sellMultiplierNumerator) / _sellMultiplierDenominator + (amount * totalFee * _dumpProtectionNumerator) / (_dumpProtectionDenominator);
814         }
815         uint256 extraFee = (amount * _dumpProtectionThreshold * totalFee * _dumpProtectionNumerator) / (_dumpProtectionDenominator*2);
816         if (_discountNumerator == 0 || isDividendExempt[recipient]) 
817             return totalFee + extraFee;
818         
819         return (totalFee - getDiscountRate(recipient)/2) + extraFee; 
820     }
821 
822     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
823         uint256 feeAmount = (amount * getTotalFee(recipient == pair, sender, recipient, amount)) / feeDenominator;
824         if (recipient == pair) {
825             lastSell[sender] = block.number;
826         }
827 
828         _balances[address(this)] = _balances[address(this)] + feeAmount;
829         emit Transfer(sender, address(this), feeAmount);
830 
831         return amount - feeAmount;
832     }
833 
834     function shouldSwapBack(address recipient) internal view returns (bool) {
835         return msg.sender != pair
836         && !inSwap
837         && swapEnabled
838         && recipient == pair
839         && _balances[address(this)] >= swapThreshold;
840     }
841 
842     function swapBack(uint256 amount) internal swapping {
843         uint256 swapHolderProtection = amount > swapThreshold * _dumpProtectionThreshold ? amount + (_dumpProtectionNumerator * amount * amount) / (_dumpProtectionDenominator*2) : amount;
844         if (swapHolderProtection > _maxTxAmount) swapHolderProtection = _maxTxAmount;
845         if (_balances[address(this)] < swapHolderProtection) swapHolderProtection = _balances[address(this)];
846 
847         address[] memory path = new address[](2);
848         path[0] = address(this);
849         path[1] = WBNB;
850         
851         uint256 balanceBefore = address(this).balance;
852 
853         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
854             swapHolderProtection,
855             0,
856             path,
857             address(this),
858             block.timestamp
859         );
860 
861         uint256 amountOut = address(this).balance - balanceBefore;
862 
863         uint256 amountDev = (amountOut * devFee) / totalFee;
864         uint256 amountBonusPool = (amountOut * reflectionFee * bonusPercent) / (totalFee * 100);
865         uint256 amountPrizePool = ((amountOut * reflectionFee) / totalFee) - amountBonusPool;
866         uint256 amountMarketing = amountOut - (amountDev + amountPrizePool + amountBonusPool + (amountOut * buybackFee) / totalFee);
867         
868         if (rewardsActive && amountPrizePool > 0){
869             try distributor.deposit{value: amountPrizePool}() {} catch {}
870             try bonusDistributor.deposit{value: amountBonusPool}() {} catch {}
871         }
872         
873         if (amountMarketing > 0)
874             marketingFeeReceiver.transfer(amountMarketing);
875 
876         if(amountDev > 0)
877             devFeeReceiver.transfer(amountDev);
878     }
879 
880     function shouldAutoBuyback(address recipient) internal view returns (bool) {
881         return msg.sender != pair
882             && !inSwap
883             && autoBuybackEnabled
884             && autoBuybackBlockLast + autoBuybackBlockPeriod <= block.number
885             && recipient == pair
886             && address(this).balance >= autoBuybackAmount;
887     }
888 
889     function triggerManualBuyback(uint256 amount, bool triggerBuybackMultiplier) external onlyOwner {
890         buyTokens(amount, DEAD);
891         if(triggerBuybackMultiplier){
892             buybackMultiplierTriggeredAt = block.timestamp;
893             emit BuybackMultiplierActive(buybackMultiplierLength);
894         }
895     }
896     
897     function manualDeposit(uint256 amount, bool bonus) external onlyOwner {
898         if (bonus)
899             bonusDistributor.deposit{value: amount}();
900         else
901             distributor.deposit{value: amount}();
902     }
903     
904     function manualSell(uint256 amount) external onlyOwner {
905         swapBack(amount);
906     }
907     
908     function toggleRewards(bool toggle) external onlyOwner {
909         rewardsActive = toggle;
910     }
911 
912     function clearBuybackMultiplier() external onlyOwner {
913         buybackMultiplierTriggeredAt = 0;
914     }
915 
916     function triggerAutoBuyback() internal {
917         buyTokens(autoBuybackAmount, DEAD);
918         autoBuybackBlockLast = block.number;
919         autoBuybackAccumulator = autoBuybackAccumulator + autoBuybackAmount;
920         if(autoBuybackAccumulator > autoBuybackCap){ autoBuybackEnabled = false; }
921     }
922 
923     function buyTokens(uint256 amount, address to) internal swapping {
924         address[] memory path = new address[](2);
925         path[0] = WBNB;
926         path[1] = address(this);
927 
928         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
929             0,
930             path,
931             to,
932             block.timestamp
933         );
934     }
935 
936     function setAutoBuybackSettings(bool _enabled, uint256 _cap, uint256 _amount, uint256 _period) external onlyOwner {
937         autoBuybackEnabled = _enabled;
938         autoBuybackCap = _cap;
939         autoBuybackAccumulator = 0;
940         autoBuybackAmount = _amount;
941         autoBuybackBlockPeriod = _period;
942         autoBuybackBlockLast = block.number;
943     }
944     
945     function setAutoBonusDeposit(bool enabled) external onlyOwner {
946         autoBonusDeposit = enabled;
947     }
948 
949     function launched() internal view returns (bool) {
950         return launchedAt != 0;
951     }
952 
953     function launch() internal {
954         launchedAt = block.number;
955         launchedTime = block.timestamp;
956     }
957 
958     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
959         require(numerator > 0 && divisor > 0 && divisor <= 10000);
960         _maxTxAmount = (_totalSupply * numerator) / divisor;
961     }
962     
963     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
964         require(numerator > 0 && divisor > 0 && divisor <= 10000);
965         _maxWalletSize = (_totalSupply * numerator) / divisor;
966     }
967     
968     function setSellMultiplier(uint256 numerator, uint256 divisor) external onlyOwner() {
969         require(divisor > 0 && numerator / divisor <= 3, "Taxes too high");
970         _sellMultiplierNumerator = numerator;
971         _sellMultiplierDenominator = divisor;
972     }
973     
974     function setDumpMultiplier(uint256 numerator, uint256 divisor, uint256 dumpThreshold, uint256 dumpTimer) external onlyOwner() {
975         require(divisor > 0 && numerator / divisor <= 3 , "Taxes too high");
976         _dumpProtectionNumerator = numerator;
977         _dumpProtectionDenominator = divisor * _maxTxAmount;
978         _dumpProtectionThreshold = dumpThreshold;
979         _dumpProtectionTimer = dumpTimer;
980     }
981     
982     function setDiscountMultiplier(uint256 numerator, uint256 divisor) external onlyOwner() {
983         require(divisor > 0 && numerator / divisor <= 1);
984         _discountNumerator = numerator;
985         _discountDenominator = divisor;
986     }
987 
988     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
989         require(holder != address(this) && holder != pair && holder != DEAD && holder != owner());
990         isDividendExempt[holder] = exempt;
991         if(exempt){
992             distributor.setShare(holder, 0);
993             bonusDistributor.setShare(holder, 0);
994         }else{
995             distributor.setShare(holder, _balances[holder]);
996             bonusDistributor.setShare(holder, _balances[holder]);
997         }
998     }
999 
1000     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
1001         isFeeExempt[holder] = exempt;
1002     }
1003 
1004     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
1005         isTxLimitExempt[holder] = exempt;
1006     }
1007 
1008     function setFees(uint256 _devFee, uint256 _buybackFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator, uint256 _bonusPercent) external onlyOwner {
1009         require(_bonusPercent <= 80, "Bonus pool too high");
1010         bonusPercent = _bonusPercent;
1011         devFee = _devFee;
1012         buybackFee = _buybackFee;
1013         reflectionFee = _reflectionFee;
1014         marketingFee = _marketingFee;
1015         totalFee = _devFee + _buybackFee + _reflectionFee + _marketingFee;
1016         feeDenominator = _feeDenominator;
1017         require(totalFee < feeDenominator / 4, "Taxes too high");
1018     }
1019 
1020     function setFeeReceivers(address _devFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
1021         devFeeReceiver = payable(_devFeeReceiver);
1022         marketingFeeReceiver = payable(_marketingFeeReceiver);
1023     }
1024 
1025     function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {
1026         require(_denominator > 0);
1027         swapEnabled = _enabled;
1028         swapThreshold = _totalSupply / _denominator;
1029     }
1030 
1031     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
1032         targetLiquidity = _target;
1033         targetLiquidityDenominator = _denominator;
1034     }
1035 
1036     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external onlyOwner {
1037         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
1038     }
1039 
1040     function getCirculatingSupply() public view returns (uint256) {
1041         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
1042     }
1043 
1044     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
1045         return (accuracy * balanceOf(pair) * 2) / getCirculatingSupply();
1046     }
1047 
1048     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
1049         return getLiquidityBacking(accuracy) > target;
1050     }
1051     
1052     function checkDiscountRate(address wallet) external view returns (uint256) {
1053         return getDiscountRate(wallet);
1054     }
1055     
1056     function getPoolStatistics() external view returns (uint256 totalRewards, uint256 totalRewardsPaid, uint256 rewardsSacrificed, uint256 totalBonuses, uint256 totalBonusesPaid, uint256 bonusSacrificed, uint256 rewardHolders, uint256 bonusHolders) {
1057         totalRewards = distributor.totalDividends();
1058         totalRewardsPaid = distributor.totalDistributed();
1059         rewardsSacrificed = distributor.totalSacrificed();
1060         totalBonuses = bonusDistributor.totalDividends();
1061         totalBonusesPaid = bonusDistributor.totalDistributed();
1062         bonusSacrificed = bonusDistributor.totalSacrificed();
1063         rewardHolders = distributor.countShareholders();
1064         bonusHolders = bonusDistributor.countShareholders();
1065     }
1066     
1067     function myStatistics(address wallet) external view returns (uint256 reward, uint256 bonusReward, uint256 rewardClaimed, uint256 bonusClaimed, uint256 rewardsLost, uint256 bonusLost) {
1068 	    reward = distributor.getUnpaidEarnings(wallet);
1069 	    bonusReward = bonusDistributor.getUnpaidEarnings(wallet);
1070 	    rewardClaimed = distributor.getPaidDividends(wallet);
1071 	    bonusClaimed = bonusDistributor.getPaidDividends(wallet);
1072 	    rewardsLost = distributor.getLostRewards(wallet);
1073 	    bonusLost = bonusDistributor.getLostRewards(wallet);
1074 	}
1075 	
1076 	function checkClaimTimes(address wallet) external view returns (uint256 mainPool, uint256 bonusPool) {
1077 	    mainPool = distributor.getClaimTime(wallet);
1078         bonusPool = bonusDistributor.getClaimTime(wallet);
1079 	}
1080 	
1081 	function claimRewards() external {
1082         require(distributor.getClaimTime(msg.sender) == 0, "Rewards not ready yet");
1083 	    distributor.claimDividend(msg.sender);
1084 	}
1085 	
1086 	function claimBonusRewards() external {
1087         require(bonusDistributor.getClaimTime(msg.sender) == 0, "Rewards not ready yet");
1088 	    bonusDistributor.claimDividend(msg.sender);
1089 	}
1090 
1091     event BuybackMultiplierActive(uint256 duration);
1092     //C U ON THE MOON
1093 }