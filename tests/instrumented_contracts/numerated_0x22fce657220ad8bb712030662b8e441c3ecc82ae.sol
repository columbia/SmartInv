1 /*
2 
3 */
4 // SPDX-License-Identifier: Unlicensed
5 
6 pragma solidity ^0.8.9;
7 
8 
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * C U ON THE MOON
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { codehash := extcodehash(account) }
36         return (codehash != accountHash && codehash != 0x0);
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         return _functionCallWithValue(target, data, value, errorMessage);
119     }
120 
121     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
122         require(isContract(target), "Address: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
126         if (success) {
127             return returndata;
128         } else {
129             // Look for revert reason and bubble it up if present
130             if (returndata.length > 0) {
131                 // The easiest way to bubble the revert reason is using memory via assembly
132 
133                 // solhint-disable-next-line no-inline-assembly
134                 assembly {
135                     let returndata_size := mload(returndata)
136                     revert(add(32, returndata), returndata_size)
137                 }
138             } else {
139                 revert(errorMessage);
140             }
141         }
142     }
143 }
144 
145 abstract contract Context {
146     function _msgSender() internal view returns (address payable) {
147         return payable(msg.sender);
148     }
149 
150     function _msgData() internal view returns (bytes memory) {
151         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
152         return msg.data;
153     }
154 }
155 
156 interface IERC20 {
157     function totalSupply() external view returns (uint256);
158 
159     /**
160      * @dev Returns the amount of tokens owned by `account`.
161      */
162     function balanceOf(address account) external view returns (uint256);
163 
164     /**
165      * @dev Moves `amount` tokens from the caller's account to `recipient`.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transfer(address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Returns the remaining number of tokens that `spender` will be
175      * allowed to spend on behalf of `owner` through {transferFrom}. This is
176      * zero by default.
177      *
178      * This value changes when {approve} or {transferFrom} are called.
179      */
180     function allowance(address owner, address spender) external view returns (uint256);
181 
182     /**
183      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * IMPORTANT: Beware that changing an allowance with this method brings the risk
188      * that someone may use both the old and the new allowance by unfortunate
189      * transaction ordering. One possible solution to mitigate this race
190      * condition is to first reduce the spender's allowance to 0 and set the
191      * desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Moves `amount` tokens from `sender` to `recipient` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Emitted when `value` tokens are moved from one account (`from`) to
211      * another (`to`).
212      *
213      * Note that `value` may be zero.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 value);
216 
217     /**
218      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
219      * a call to {approve}. `value` is the new allowance.
220      */
221     event Approval(address indexed owner, address indexed spender, uint256 value);
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
276 interface IDexPair {
277     event Approval(address indexed owner, address indexed spender, uint value);
278     event Transfer(address indexed from, address indexed to, uint value);
279 
280     function name() external pure returns (string memory);
281     function symbol() external pure returns (string memory);
282     function decimals() external pure returns (uint8);
283     function totalSupply() external view returns (uint);
284     function balanceOf(address owner) external view returns (uint);
285     function allowance(address owner, address spender) external view returns (uint);
286 
287     function approve(address spender, uint value) external returns (bool);
288     function transfer(address to, uint value) external returns (bool);
289     function transferFrom(address from, address to, uint value) external returns (bool);
290 
291     function DOMAIN_SEPARATOR() external view returns (bytes32);
292     function PERMIT_TYPEHASH() external pure returns (bytes32);
293     function nonces(address owner) external view returns (uint);
294 
295     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
296 
297     event Mint(address indexed sender, uint amount0, uint amount1);
298     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
299     event Swap(
300         address indexed sender,
301         uint amount0In,
302         uint amount1In,
303         uint amount0Out,
304         uint amount1Out,
305         address indexed to
306     );
307     event Sync(uint112 reserve0, uint112 reserve1);
308 
309     function MINIMUM_LIQUIDITY() external pure returns (uint);
310     function factory() external view returns (address);
311     function token0() external view returns (address);
312     function token1() external view returns (address);
313     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
314     function price0CumulativeLast() external view returns (uint);
315     function price1CumulativeLast() external view returns (uint);
316     function kLast() external view returns (uint);
317 
318     function mint(address to) external returns (uint liquidity);
319     function burn(address to) external returns (uint amount0, uint amount1);
320     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
321     function skim(address to) external;
322     function sync() external;
323 
324     function initialize(address, address) external;
325 }
326 
327 /**
328  * @dev Contract module which provides a basic access control mechanism, where
329  * there is an account (an owner) that can be granted exclusive access to
330  * specific functions.
331  *
332  * By default, the owner account will be the one that deploys the contract. This
333  * can later be changed with {transferOwnership}.
334  *
335  * This module is used through inheritance. It will make available the modifier
336  * `onlyOwner`, which can be applied to your functions to restrict their use to
337  * the owner.
338  */
339 contract Ownable is Context {
340     address private _owner;
341 
342     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
343 
344     /**
345      * @dev Initializes the contract setting the deployer as the initial owner.
346      */
347     constructor () {
348         address msgSender = _msgSender();
349         _owner = msgSender;
350         emit OwnershipTransferred(address(0), msgSender);
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         require(_owner == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367      /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         emit OwnershipTransferred(_owner, address(0));
376         _owner = address(0);
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Can only be called by the current owner.
382      */
383     function transferOwnership(address newOwner) public virtual onlyOwner {
384         require(newOwner != address(0), "Ownable: new owner is the zero address");
385         emit OwnershipTransferred(_owner, newOwner);
386         _owner = newOwner;
387     }
388 }
389 
390 interface IAntiSnipe {
391   function setTokenOwner(address owner) external;
392 
393   function onPreTransferCheck(
394     address from,
395     address to,
396     uint256 amount
397   ) external returns (bool checked);
398 }
399 
400 contract MetaNami is IERC20, Ownable {
401     using Address for address;
402     
403     address DEAD = 0x000000000000000000000000000000000000dEaD;
404     address ZERO = 0x0000000000000000000000000000000000000000;
405 
406     string constant _name = "Meta Nami";
407     string constant _symbol = "NAMI";
408     uint8 constant _decimals = 9;
409 
410     uint256 _totalSupply = 100_000_000 * (10 ** _decimals);
411     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 400;
412     uint256 _maxSellTxAmount = (_totalSupply * 1) / 400;
413     uint256 _maxWalletSize = (_totalSupply * 1) / 100;
414 
415     mapping (address => uint256) _balances;
416     mapping (address => uint256) firstBuy;
417     mapping (address => mapping (address => uint256)) _allowances;
418 
419     mapping (address => bool) isFeeExempt;
420     mapping (address => bool) isTxLimitExempt;
421     mapping (address => bool) liquidityCreator;
422 
423     uint256 devFee = 200;
424     uint256 marketingFee = 600;
425     uint256 poolFee = 300;
426     uint256 totalFees = marketingFee + devFee;
427     uint256 sellBias = 0;
428     uint256 highFeePeriod = 24 hours;
429     uint256 highFeeMult = 250;
430     uint256 feeDenominator = 10000;
431 
432     address public liquidityFeeReceiver;
433     address payable public marketingFeeReceiver = payable(0x007a79d2bAe62770942C866E419D32001fd4Dd06);
434     address payable public devReceiver1;
435     address payable public devReceiver2;
436     address public poolReceiver;
437 
438     IDEXRouter public router;
439     //address routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
440     //address routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
441     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
442     mapping (address => bool) liquidityPools;
443     
444     IAntiSnipe public antisnipe;
445     bool public protectionEnabled = true;
446     bool public protectionDisabled = false;
447 
448     address public pair;
449     uint256 public manualBurnFrequency = 30 minutes;
450     uint256 public lastManualLpBurnTime;
451 
452     uint256 public launchedAt;
453     uint256 public launchedTime;
454     uint256 public deadBlocks = 1;
455 
456     bool public swapEnabled = false;
457     uint256 public swapThreshold = _totalSupply / 200;
458     uint256 public swapMinimum = _totalSupply / 10000;
459     bool inSwap;
460     modifier swapping() { inSwap = true; _; inSwap = false; }
461 
462     constructor (address _dev1, address _dev2) {
463         router = IDEXRouter(routerAddress);
464         pair = IDEXFactory(router.factory()).createPair(address(this),router.WETH());
465         liquidityPools[pair] = true;
466         _allowances[owner()][routerAddress] = type(uint256).max;
467         _allowances[address(this)][routerAddress] = type(uint256).max;
468 
469         isFeeExempt[owner()] = true;
470         liquidityCreator[owner()] = true;
471 
472         liquidityFeeReceiver = msg.sender;
473         poolReceiver = marketingFeeReceiver;
474         devReceiver1 = payable(_dev1);
475         devReceiver2 = payable(_dev2);
476 
477         isTxLimitExempt[address(this)] = true;
478         isTxLimitExempt[owner()] = true;
479         isTxLimitExempt[routerAddress] = true;
480         isTxLimitExempt[DEAD] = true;
481 
482         _balances[owner()] = _totalSupply;
483 
484         emit Transfer(address(0), owner(), _totalSupply);
485     }
486 
487     receive() external payable { }
488 
489     function totalSupply() external view override returns (uint256) { return _totalSupply; }
490     function decimals() external pure returns (uint8) { return _decimals; }
491     function symbol() external pure returns (string memory) { return _symbol; }
492     function name() external pure returns (string memory) { return _name; }
493     function getOwner() external view returns (address) { return owner(); }
494     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
495     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
496     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
497     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
498     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
499 
500     function approve(address spender, uint256 amount) public override returns (bool) {
501         _allowances[msg.sender][spender] = amount;
502         emit Approval(msg.sender, spender, amount);
503         return true;
504     }
505 
506     function approveMax(address spender) external returns (bool) {
507         return approve(spender, type(uint256).max);
508     }
509     
510     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
511         require(addresses.length > 0 && amounts.length == addresses.length);
512         address from = msg.sender;
513 
514         for (uint i = 0; i < addresses.length; i++) {
515             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
516                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
517             }
518         }
519     }
520     
521     function rescueToken(address tokenAddress, uint256 tokens) external onlyOwner
522         returns (bool success)
523     {
524         return IERC20(tokenAddress).transfer(msg.sender, tokens);
525     }
526     
527     function claimMarketing() external onlyOwner {
528         uint256 bal = address(this).balance;
529         uint256 amountMarketing = (bal * marketingFee) / (marketingFee + devFee);
530         uint256 amountDev = (bal * devFee) / (marketingFee + devFee);
531         
532         if (amountMarketing > 0)
533             marketingFeeReceiver.transfer(amountMarketing);
534         if (amountDev > 0) {
535             devReceiver1.transfer(amountDev / 2);
536             devReceiver2.transfer(amountDev / 2);
537         }
538     }
539     
540     function setProtectionEnabled(bool _protect) external onlyOwner {
541         if (_protect)
542             require(!protectionDisabled);
543         protectionEnabled = _protect;
544     }
545     
546     function setProtection(address _protection, bool _call) external onlyOwner {
547         if (_protection != address(antisnipe)){
548             require(!protectionDisabled);
549             antisnipe = IAntiSnipe(_protection);
550         }
551         if (_call)
552             antisnipe.setTokenOwner(msg.sender);
553     }
554     
555     function disableProtection() external onlyOwner {
556         protectionDisabled = true;
557     }
558 
559     function transfer(address recipient, uint256 amount) external override returns (bool) {
560         return _transferFrom(msg.sender, recipient, amount);
561     }
562 
563     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
564         if(_allowances[sender][msg.sender] != type(uint256).max){
565             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
566         }
567 
568         return _transferFrom(sender, recipient, amount);
569     }
570 
571     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
572         require(amount > 0, "Amount must be > zero");
573         require(_balances[sender] >= amount, "Insufficient balance");
574         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
575 
576         checkTxLimit(sender, amount);
577         
578         if (!liquidityPools[recipient] && recipient != DEAD) {
579             if(_balances[recipient] == 0) {
580                 firstBuy[recipient] = block.timestamp;
581             }
582             if (!isTxLimitExempt[recipient]) {
583                 checkWalletLimit(recipient, amount);
584             }
585         }
586         
587         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
588 
589         _balances[sender] = _balances[sender] - amount;
590 
591         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
592         
593         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
594 
595         _balances[recipient] = _balances[recipient] + amountReceived;
596         
597         if (protectionEnabled)
598             antisnipe.onPreTransferCheck(sender, recipient, amount);
599 
600         emit Transfer(sender, recipient, amountReceived);
601         return true;
602     }
603     
604     function launched() internal view returns (bool) {
605         return launchedTime != 0;
606     }
607 
608     function launch() internal {
609         launchedAt = block.number;
610         launchedTime = block.timestamp;
611         swapEnabled = true;
612     }
613 
614     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
615         _balances[sender] = _balances[sender] - amount;
616         _balances[recipient] = _balances[recipient] + amount;
617         emit Transfer(sender, recipient, amount);
618         return true;
619     }
620     
621     function checkWalletLimit(address recipient, uint256 amount) internal view {
622         uint256 walletLimit = _maxWalletSize;
623         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
624     }
625 
626     function checkTxLimit(address sender, uint256 amount) internal view {
627         require(isTxLimitExempt[sender] || amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
628     }
629 
630     function shouldTakeFee(address sender) internal view returns (bool) {
631         return !isFeeExempt[sender];
632     }
633 
634     function getTotalFee(bool selling, bool highPeriod) public view returns (uint256) {
635         if(launchedAt + deadBlocks > block.number){ return feeDenominator - 1; }
636         if (selling) return highPeriod ? (totalFees * highFeeMult) / 100 : totalFees + sellBias;
637         return highPeriod ? (totalFees * highFeeMult) / 100 : totalFees - sellBias;
638     }
639 
640     function takeFee(address from, address recipient, uint256 amount) internal returns (uint256) {
641         bool selling = liquidityPools[recipient];
642         uint256 feeAmount = (amount * getTotalFee(selling, !liquidityPools[from] && firstBuy[from] + highFeePeriod > block.timestamp)) / feeDenominator;
643         uint256 poolAmount;
644         
645         if (poolFee > 0){
646             poolAmount = (amount * poolFee) / feeDenominator;
647             _balances[poolReceiver] += poolAmount;
648             emit Transfer(from, poolReceiver, poolAmount);
649         }
650 
651         if (feeAmount > 0) {
652             _balances[address(this)] += feeAmount;
653             emit Transfer(from, address(this), feeAmount);
654         }
655     
656         return amount - (feeAmount + poolAmount);
657     }
658 
659     function shouldSwapBack(address recipient) internal view returns (bool) {
660         return !liquidityPools[msg.sender]
661         && !inSwap
662         && swapEnabled
663         && liquidityPools[recipient]
664         && _balances[address(this)] >= swapMinimum &&
665         totalFees > 0;
666     }
667 
668     function swapBack(uint256 amount) internal swapping {
669         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
670         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
671 
672         address[] memory path = new address[](2);
673         path[0] = address(this);
674         path[1] = router.WETH();
675         
676         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
677             amountToSwap,
678             0,
679             path,
680             address(this),
681             block.timestamp
682         );
683     }
684     
685     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
686         require(lp != pair, "Can't alter current liquidity pair");
687         liquidityPools[lp] = isPool;
688         emit UpdatedSettings(isPool ? 'Liquidity Pool Enabled' : 'Liquidity Pool Disabled', [Log(toString(abi.encodePacked(lp)), 1), Log('', 0), Log('', 0)]);
689     }
690     
691     function switchRouter(address newRouter, address newPair) external onlyOwner {
692         router = IDEXRouter(newRouter);
693         pair = newPair;
694         liquidityPools[newPair] = true;
695         isTxLimitExempt[newRouter] = true;
696         emit UpdatedSettings('Exchange Router Updated', [Log(concatenate('New Router: ',toString(abi.encodePacked(newRouter))), 1),Log(concatenate('New Liquidity Pair: ',toString(abi.encodePacked(pair))), 1), Log('', 0)]);
697     }
698     
699     function excludePresaleAddress(address presaleAddress) external onlyOwner {
700         liquidityCreator[presaleAddress] = true;
701         isTxLimitExempt[presaleAddress] = true;
702         isFeeExempt[presaleAddress] = true;
703         emit UpdatedSettings('Presale Setup', [Log(concatenate('Presale Address: ',toString(abi.encodePacked(presaleAddress))), 1), Log('', 0), Log('', 0)]);
704     }
705 
706     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
707         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
708         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
709         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
710         emit UpdatedSettings('Maximum Transaction Size', [Log('Max Buy Tokens', _maxBuyTxAmount / (10 ** _decimals)), Log('Max Sell Tokens', _maxSellTxAmount / (10 ** _decimals)), Log('', 0)]);
711     }
712     
713     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
714         require(numerator > 0 && divisor > 0 && divisor <= 10000);
715         _maxWalletSize = (_totalSupply * numerator) / divisor;
716         emit UpdatedSettings('Maximum Wallet Size', [Log('Tokens', _maxWalletSize / (10 ** _decimals)), Log('', 0), Log('', 0)]);
717     }
718 
719     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
720         isFeeExempt[holder] = exempt;
721         emit UpdatedSettings(exempt ? 'Fees Removed' : 'Fees Enforced', [Log(toString(abi.encodePacked(holder)), 1), Log('', 0), Log('', 0)]);
722     }
723 
724     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
725         isTxLimitExempt[holder] = exempt;
726         emit UpdatedSettings(exempt ? 'Transaction Limit Removed' : 'Transaction Limit Enforced', [Log(toString(abi.encodePacked(holder)), 1), Log('', 0), Log('', 0)]);
727     }
728 
729     function setFees(uint256 _marketingFee, uint256 _devFee, uint256 _poolFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
730         marketingFee = _marketingFee;
731         devFee = _devFee;
732         poolFee = _poolFee;
733         totalFees = _devFee + _marketingFee;
734         sellBias = _sellBias;
735         feeDenominator = _feeDenominator;
736         require(totalFees + poolFee < feeDenominator / 2);
737         emit UpdatedSettings('Fees', [Log('Total Fee Percent', totalFees * 100 / feeDenominator), Log('Marketing Percent', _marketingFee * 100 / feeDenominator), Log('Dev Percent', _devFee * 100 / feeDenominator)]);
738     }
739 
740     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver, address _dev1, address _dev2, address _poolReceiver) external onlyOwner {
741         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
742         marketingFeeReceiver = payable(_marketingFeeReceiver);
743         devReceiver1 = payable(_dev1);
744         devReceiver2 = payable(_dev2);
745         poolReceiver = _poolReceiver;
746         emit UpdatedSettings('Fee Receivers', [Log(concatenate('Liquidity Receiver: ',toString(abi.encodePacked(_liquidityFeeReceiver))), 1),Log(concatenate('Marketing Receiver: ',toString(abi.encodePacked(_marketingFeeReceiver))), 1), Log(concatenate('Pool Receiver: ',toString(abi.encodePacked(_poolReceiver))), 1)]);
747     }
748 
749     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _swapMinimumDenom) external onlyOwner {
750         require(_denominator > 0);
751         swapEnabled = _enabled;
752         swapThreshold = _totalSupply / _denominator;
753         swapMinimum = _totalSupply / _swapMinimumDenom;
754         emit UpdatedSettings('Swap Settings', [Log('Enabled', _enabled ? 1 : 0),Log('Swap Maximum', swapThreshold), Log('Swap Minimum', swapMinimum)]);
755     }
756 
757     function getCirculatingSupply() public view returns (uint256) {
758         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
759     }
760 
761     function burnLP(uint256 percent) external onlyOwner {
762         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
763         require(percent <= 5 && percent > 0, "Max of 5% of tokens in LP");
764         lastManualLpBurnTime = block.timestamp;
765         
766         uint256 pairBalance = this.balanceOf(pair);
767         
768         _basicTransfer(pair, DEAD, (pairBalance * percent) / 100);
769         
770         IDexPair(pair).sync();
771     }
772 	
773 	function toString(bytes memory data) internal pure returns(string memory) {
774         bytes memory alphabet = "0123456789abcdef";
775     
776         bytes memory str = new bytes(2 + data.length * 2);
777         str[0] = "0";
778         str[1] = "x";
779         for (uint i = 0; i < data.length; i++) {
780             str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
781             str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
782         }
783         return string(str);
784     }
785     
786     function concatenate(string memory a, string memory b) internal pure returns (string memory) {
787         return string(abi.encodePacked(a, b));
788     }
789 
790 	struct Log {
791 	    string name;
792 	    uint256 value;
793 	}
794 
795     event UpdatedSettings(string name, Log[3] values);
796     //C U ON THE MOON
797 }