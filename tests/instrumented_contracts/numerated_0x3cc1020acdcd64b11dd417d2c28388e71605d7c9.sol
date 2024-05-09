1 /*
2 DogeMan
3 
4 Telegram: https://t.me/DogeManofficial
5 Website: https://dogeman.io/
6 Twitter: https://twitter.com/DogeManErc20
7 
8                                         '└└¬
9      
10 */
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 pragma solidity ^0.8.7;
15 
16 
17 library Address {
18     /**
19      * @dev Returns true if `account` is a contract.
20      *
21      * [IMPORTANT]
22      * ====
23      * C U ON THE MOON
24      * It is unsafe to assume that an address for which this function returns
25      * false is an externally-owned account (EOA) and not a contract.
26      *
27      * Among others, `isContract` will return false for the following
28      * types of addresses:
29      *
30      *  - an externally-owned account
31      *  - a contract in construction
32      *  - an address where a contract will be created
33      *  - an address where a contract lived, but was destroyed
34      * ====
35      */
36     function isContract(address account) internal view returns (bool) {
37         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
38         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
39         // for accounts without code, i.e. `keccak256('')`
40         bytes32 codehash;
41         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
42         // solhint-disable-next-line no-inline-assembly
43         assembly { codehash := extcodehash(account) }
44         return (codehash != accountHash && codehash != 0x0);
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
67         (bool success, ) = recipient.call{ value: amount }("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain`call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90       return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
105      * but also transferring `value` wei to `target`.
106      *
107      * Requirements:
108      *
109      * - the calling contract must have an ETH balance of at least `value`.
110      * - the called Solidity function must be `payable`.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
120      * with `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
125         require(address(this).balance >= value, "Address: insufficient balance for call");
126         return _functionCallWithValue(target, data, value, errorMessage);
127     }
128 
129     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
130         require(isContract(target), "Address: call to non-contract");
131 
132         // solhint-disable-next-line avoid-low-level-calls
133         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
134         if (success) {
135             return returndata;
136         } else {
137             // Look for revert reason and bubble it up if present
138             if (returndata.length > 0) {
139                 // The easiest way to bubble the revert reason is using memory via assembly
140 
141                 // solhint-disable-next-line no-inline-assembly
142                 assembly {
143                     let returndata_size := mload(returndata)
144                     revert(add(32, returndata), returndata_size)
145                 }
146             } else {
147                 revert(errorMessage);
148             }
149         }
150     }
151 }
152 
153 abstract contract Context {
154     function _msgSender() internal view returns (address payable) {
155         return payable(msg.sender);
156     }
157 
158     function _msgData() internal view returns (bytes memory) {
159         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
160         return msg.data;
161     }
162 }
163 
164 interface IERC20 {
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 interface IDEXFactory {
233     function createPair(address tokenA, address tokenB) external returns (address pair);
234 }
235 
236 interface IDEXRouter {
237     function factory() external pure returns (address);
238     function WETH() external pure returns (address);
239 
240     function addLiquidity(
241         address tokenA,
242         address tokenB,
243         uint amountADesired,
244         uint amountBDesired,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline
249     ) external returns (uint amountA, uint amountB, uint liquidity);
250 
251     function addLiquidityETH(
252         address token,
253         uint amountTokenDesired,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline
258     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
259 
260     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
261         uint amountIn,
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external;
267 
268     function swapExactETHForTokensSupportingFeeOnTransferTokens(
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external payable;
274 
275     function swapExactTokensForETHSupportingFeeOnTransferTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external;
282 }
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev Initializes the contract setting the deployer as the initial owner.
303      */
304     constructor () {
305         address msgSender = _msgSender();
306         _owner = msgSender;
307         emit OwnershipTransferred(address(0), msgSender);
308     }
309 
310     /**
311      * @dev Returns the address of the current owner.
312      */
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(_owner == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324      /**
325      * @dev Leaves the contract without owner. It will not be possible to call
326      * `onlyOwner` functions anymore. Can only be called by the current owner.
327      *
328      * NOTE: Renouncing ownership will leave the contract without an owner,
329      * thereby removing any functionality that is only available to the owner.
330      */
331     function renounceOwnership() public virtual onlyOwner {
332         emit OwnershipTransferred(_owner, address(0));
333         _owner = address(0);
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Can only be called by the current owner.
339      */
340     function transferOwnership(address newOwner) public virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345 }
346 
347 contract DogeMan is IERC20, Ownable {
348     using Address for address;
349     
350     address DEAD = 0x000000000000000000000000000000000000dEaD;
351     address ZERO = 0x0000000000000000000000000000000000000000;
352 
353     string constant _name = "DogeMan";
354     string constant _symbol = "DGMAN";
355     uint8 constant _decimals = 9;
356 
357     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
358     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 2000;
359     uint256 _maxSellTxAmount = (_totalSupply * 1) / 500;
360     uint256 _maxWalletSize = (_totalSupply * 2) / 100;
361 
362     mapping (address => uint256) _balances;
363     mapping (address => mapping (address => uint256)) _allowances;
364     mapping (address => uint256) public lastSell;
365     mapping (address => uint256) public lastBuy;
366 
367     mapping (address => bool) isFeeExempt;
368     mapping (address => bool) isTxLimitExempt;
369     mapping (address => bool) liquidityCreator;
370 
371     uint256 developerFee = 0;
372     uint256 marketingFee = 700;
373     uint256 liquidityFee = 200;
374     uint256 buybackFee = 0;
375     uint256 totalFee = marketingFee + buybackFee + liquidityFee + developerFee;
376     uint256 sellBias = 0;
377     uint256 feeDenominator = 10000;
378 
379     address payable public liquidityFeeReceiver = payable(0x499b3DE9Bb31da83c9170C8C4ec5FE359B8D10eA);
380     address payable public marketingFeeReceiver = payable(0x32968429E3595f0d4811CeC5ce73DD6fDd409582);
381     address payable public developer;
382 
383     IDEXRouter public router;
384     //address routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
385     //address routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
386     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
387     mapping (address => bool) liquidityPools;
388     mapping (address => uint256) public protected;
389     bool protectionEnabled = true;
390     bool protectionDisabled = false;
391     uint256 protectionLimit;
392     uint256 public protectionCount;
393     uint256 protectionTimer;
394 
395     address public pair;
396 
397     uint256 public launchedAt;
398     uint256 public launchedTime;
399     uint256 public deadBlocks;
400     bool startBullRun = false;
401     bool pauseDisabled = false;
402     uint256 public rateLimit = 2;
403     bool protectionEnded = false;
404 
405     bool public swapEnabled = true;
406     bool processEnabled = true;
407     uint256 public swapThreshold = _totalSupply / 1000;
408     uint256 public swapMinimum = _totalSupply / 10000;
409     bool inSwap;
410     modifier swapping() { inSwap = true; _; inSwap = false; }
411     
412     mapping (address => bool) teamMember;
413     
414     modifier onlyTeam() {
415         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
416         _;
417     }
418     
419     event ProtectedWallet(address, address, uint256, uint8);
420 
421     constructor () {
422         router = IDEXRouter(routerAddress);
423         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
424         liquidityPools[pair] = true;
425         _allowances[owner()][routerAddress] = type(uint256).max;
426         _allowances[address(this)][routerAddress] = type(uint256).max;
427 
428         isFeeExempt[owner()] = true;
429         liquidityCreator[owner()] = true;
430 
431         isTxLimitExempt[address(this)] = true;
432         isTxLimitExempt[owner()] = true;
433         isTxLimitExempt[routerAddress] = true;
434         isTxLimitExempt[DEAD] = true;
435 
436         _balances[owner()] = _totalSupply;
437         developer = payable(msg.sender);
438         emit Transfer(address(0), owner(), _totalSupply);
439     }
440 
441     receive() external payable { }
442 
443     function totalSupply() external view override returns (uint256) { return _totalSupply; }
444     function decimals() external pure returns (uint8) { return _decimals; }
445     function symbol() external pure returns (string memory) { return _symbol; }
446     function name() external pure returns (string memory) { return _name; }
447     function getOwner() external view returns (address) { return owner(); }
448     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
449     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
450     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
451     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
452     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
453 
454     function approve(address spender, uint256 amount) public override returns (bool) {
455         _allowances[msg.sender][spender] = amount;
456         emit Approval(msg.sender, spender, amount);
457         return true;
458     }
459 
460     function approveMax(address spender) external returns (bool) {
461         return approve(spender, type(uint256).max);
462     }
463     
464     function setTeamMember(address _team, bool _enabled) external onlyOwner {
465         teamMember[_team] = _enabled;
466     }
467     
468     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
469         require(addresses.length > 0 && amounts.length == addresses.length);
470         address from = msg.sender;
471 
472         for (uint i = 0; i < addresses.length; i++) {
473             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
474                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
475             }
476         }
477     }
478     
479     function buyBack(address token, uint256 amountPercentage) external onlyTeam {
480         uint256 amountETH = (address(this).balance * amountPercentage) / 100;
481         
482         address[] memory path = new address[](2);
483         path[0] = router.WETH();
484         path[1] = token;
485 
486         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountETH}(
487             0,
488             path,
489             msg.sender,
490             block.timestamp
491         );
492     }
493     
494     function rescueToken(address tokenAddress, uint256 tokens) external onlyTeam
495         returns (bool success)
496     {
497         return IERC20(tokenAddress).transfer(msg.sender, tokens);
498     }
499     
500     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
501         uint256 amountETH = address(this).balance;
502         payable(adr).transfer((amountETH * amountPercentage) / 100);
503     }
504     
505     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
506         require(!startBullRun && _deadBlocks < 10);
507         deadBlocks = _deadBlocks;
508         startBullRun = true;
509         launchedAt = block.number;
510         protectionTimer = block.timestamp + _protection;
511         protectionLimit = _limit * (10 ** _decimals);
512     }
513     
514     function pauseTrading() external onlyTeam {
515         require(!pauseDisabled);
516         startBullRun = false;
517     }
518     
519     function disablePause() external onlyTeam {
520         pauseDisabled = true;
521         startBullRun = true;
522     }
523     
524     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
525         require(!protectionDisabled);
526         protectionEnabled = _protect;
527         require(_addTime < 1 days);
528         protectionTimer += _addTime;
529     }
530     
531     function disableProtection() external onlyTeam {
532         protectionDisabled = true;
533         protectionEnabled = false;
534     }
535     
536     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
537         if (_protect) {
538             require(protectionEnabled);
539         }
540         
541         for (uint i = 0; i < _wallets.length; i++) {
542             
543             if (_protect) {
544                 protectionCount++;
545                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
546             }
547             else {
548                 if (protected[_wallets[i]] != 0)
549                     protectionCount--;      
550             }
551             protected[_wallets[i]] = _protect ? block.number : 0;
552         }
553     }
554 
555     function transfer(address recipient, uint256 amount) external override returns (bool) {
556         return _transferFrom(msg.sender, recipient, amount);
557     }
558 
559     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
560         if(_allowances[sender][msg.sender] != type(uint256).max){
561             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
562         }
563 
564         return _transferFrom(sender, recipient, amount);
565     }
566 
567     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
568         require(sender != address(0), "BEP20: transfer from 0x0");
569         require(recipient != address(0), "BEP20: transfer to 0x0");
570         require(amount > 0, "Amount must be > zero");
571         require(_balances[sender] >= amount, "Insufficient balance");
572         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
573         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
574 
575         if (!protectionEnded && protectionTimer <= block.timestamp) {
576             protectionEnded = true;
577             rateLimit = 0;
578             _maxWalletSize = _totalSupply;
579             _maxBuyTxAmount = _totalSupply;
580             _maxSellTxAmount = _totalSupply;
581         }
582 
583         checkTxLimit(sender, recipient, amount);
584         
585         if (!liquidityPools[recipient] && recipient != DEAD) {
586             if (!isTxLimitExempt[recipient]) {
587                 checkWalletLimit(recipient, amount);
588             }
589         }
590         
591         if(protectionEnabled && protectionTimer > block.timestamp) {
592             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
593                 protected[recipient] = block.number;
594                 protectionCount++;
595                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
596             }
597         }
598         
599         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
600 
601         _balances[sender] = _balances[sender] - amount;
602 
603         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(recipient, amount) : amount;
604         
605         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
606         
607         _balances[recipient] = _balances[recipient] + amountReceived;
608 
609         emit Transfer(sender, recipient, amountReceived);
610         return true;
611     }
612     
613     function launched() internal view returns (bool) {
614         return launchedAt != 0;
615     }
616 
617     function launch() internal {
618         launchedAt = block.number;
619         launchedTime = block.timestamp;
620         swapEnabled = true;
621     }
622 
623     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
624         _balances[sender] = _balances[sender] - amount;
625         _balances[recipient] = _balances[recipient] + amount;
626         emit Transfer(sender, recipient, amount);
627         return true;
628     }
629     
630     function checkWalletLimit(address recipient, uint256 amount) internal view {
631         uint256 walletLimit = _maxWalletSize;
632         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
633     }
634 
635     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
636         require(isTxLimitExempt[sender] || amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
637         require(isTxLimitExempt[sender] || lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
638         
639         if (protected[sender] != 0){
640             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
641             lastSell[sender] = block.number;
642         }
643         
644         if (liquidityPools[recipient]) {
645             lastSell[sender] = block.number;
646         } else if (shouldTakeFee(sender)) {
647             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
648                 protected[recipient] = block.number;
649                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
650             }
651             lastBuy[recipient] = block.number;
652             if (tx.origin != recipient)
653                 lastBuy[tx.origin] = block.number;
654         }
655     }
656 
657     function shouldTakeFee(address sender) internal view returns (bool) {
658         return !isFeeExempt[sender];
659     }
660 
661     function getTotalFee(bool selling) public view returns (uint256) {
662         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
663         if (selling) return totalFee + sellBias;
664         return totalFee - sellBias;
665     }
666 
667     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
668         bool selling = liquidityPools[recipient];
669         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
670         
671         _balances[address(this)] += feeAmount;
672     
673         return amount - feeAmount;
674     }
675 
676     function shouldSwapBack(address recipient) internal view returns (bool) {
677         return !liquidityPools[msg.sender]
678         && !inSwap
679         && swapEnabled
680         && liquidityPools[recipient]
681         && _balances[address(this)] >= swapMinimum;
682     }
683 
684     function swapBack(uint256 amount) internal swapping {
685         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
686         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
687         
688         uint256 amountToLiquify = (amountToSwap * liquidityFee / 2) / totalFee;
689         amountToSwap -= amountToLiquify;
690 
691         address[] memory path = new address[](2);
692         path[0] = address(this);
693         path[1] = router.WETH();
694         
695         uint256 balanceBefore = address(this).balance;
696 
697         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
698             amountToSwap,
699             0,
700             path,
701             address(this),
702             block.timestamp
703         );
704 
705         uint256 amountBNB = address(this).balance - balanceBefore;
706         uint256 totalBNBFee = totalFee - (liquidityFee / 2);
707 
708         uint256 amountBNBLiquidity = (amountBNB * liquidityFee / 2) / totalBNBFee;
709         uint256 amountBNBMarketing = (amountBNB * marketingFee) / totalBNBFee;
710         uint256 amountBNBDeveloper = (amountBNB * developerFee) / totalBNBFee;
711         
712         if (amountBNBMarketing > 0)
713             marketingFeeReceiver.transfer(amountBNBMarketing);
714         if (amountBNBDeveloper > 0)
715             developer.transfer(amountBNBDeveloper);
716         
717         if(amountToLiquify > 0){
718             router.addLiquidityETH{value: amountBNBLiquidity}(
719                 address(this),
720                 amountToLiquify,
721                 0,
722                 0,
723                 liquidityFeeReceiver,
724                 block.timestamp
725             );
726         }
727 
728         emit FundsDistributed(amountBNBLiquidity, amountBNBMarketing, amountBNBDeveloper);
729     }
730     
731     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
732         require(lp != pair, "Can't alter current liquidity pair");
733         liquidityPools[lp] = isPool;
734         emit UpdatedSettings(isPool ? 'Liquidity Pool Enabled' : 'Liquidity Pool Disabled', [Log(toString(abi.encodePacked(lp)), 1), Log('', 0), Log('', 0)]);
735     }
736     
737     function switchRouter(address newRouter) external onlyOwner {
738         router = IDEXRouter(newRouter);
739         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
740         liquidityPools[pair] = true;
741         isTxLimitExempt[newRouter] = true;
742         emit UpdatedSettings('Exchange Router Updated', [Log(concatenate('New Router: ',toString(abi.encodePacked(newRouter))), 1),Log(concatenate('New Liquidity Pair: ',toString(abi.encodePacked(pair))), 1), Log('', 0)]);
743     }
744     
745     function excludePresaleAddresses(address preSaleRouter, address presaleAddress) external onlyOwner {
746         liquidityCreator[preSaleRouter] = true;
747         liquidityCreator[presaleAddress] = true;
748         isTxLimitExempt[preSaleRouter] = true;
749         isTxLimitExempt[presaleAddress] = true;
750         isFeeExempt[preSaleRouter] = true;
751         isFeeExempt[presaleAddress] = true;
752         emit UpdatedSettings('Presale Setup', [Log(concatenate('Presale Router: ',toString(abi.encodePacked(preSaleRouter))), 1),Log(concatenate('Presale Address: ',toString(abi.encodePacked(presaleAddress))), 1), Log('', 0)]);
753     }
754 
755     function setRateLimit(uint256 rate) external onlyOwner {
756         require(rate <= 30);
757         rateLimit = rate;
758         emit UpdatedSettings('Purchase Rate Limit', [Log('Blocks', rate), Log('', 0), Log('', 0)]);
759     }
760 
761     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
762         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
763         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
764         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
765         emit UpdatedSettings('Maximum Transaction Size', [Log('Max Buy Tokens', _maxBuyTxAmount / (10 ** _decimals)), Log('Max Sell Tokens', _maxSellTxAmount / (10 ** _decimals)), Log('', 0)]);
766     }
767     
768     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
769         require(numerator > 0 && divisor > 0 && divisor <= 10000);
770         _maxWalletSize = (_totalSupply * numerator) / divisor;
771         emit UpdatedSettings('Maximum Wallet Size', [Log('Tokens', _maxWalletSize / (10 ** _decimals)), Log('', 0), Log('', 0)]);
772     }
773 
774     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
775         isFeeExempt[holder] = exempt;
776         emit UpdatedSettings(exempt ? 'Fees Removed' : 'Fees Enforced', [Log(toString(abi.encodePacked(holder)), 1), Log('', 0), Log('', 0)]);
777     }
778 
779     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
780         isTxLimitExempt[holder] = exempt;
781         emit UpdatedSettings(exempt ? 'Transaction Limit Removed' : 'Transaction Limit Enforced', [Log(toString(abi.encodePacked(holder)), 1), Log('', 0), Log('', 0)]);
782     }
783 
784     function setFees(uint256 _buybackFee, uint256 _liquidityFee, uint256 _marketingFee, uint256 _developerFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
785         buybackFee = _buybackFee;
786         liquidityFee = _liquidityFee;
787         marketingFee = _marketingFee;
788         developerFee = _developerFee;
789         totalFee = _buybackFee + _marketingFee + _liquidityFee + _developerFee;
790         sellBias = _sellBias;
791         feeDenominator = _feeDenominator;
792         require(totalFee < feeDenominator / 2);
793         emit UpdatedSettings('Fees', [Log('Total Fee Percent', totalFee * 100 / feeDenominator), Log('Marketing Percent', _marketingFee * 100 / feeDenominator), Log('Liquidity Percent', _liquidityFee * 100 / feeDenominator)]);
794     }
795 
796     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver, address _developer) external onlyOwner {
797         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
798         marketingFeeReceiver = payable(_marketingFeeReceiver);
799         developer = payable(_developer);
800         emit UpdatedSettings('Fee Receivers', [Log(concatenate('Liquidity Receiver: ',toString(abi.encodePacked(_liquidityFeeReceiver))), 1),Log(concatenate('Marketing Receiver: ',toString(abi.encodePacked(_marketingFeeReceiver))), 1), Log(concatenate('Dev Receiver: ',toString(abi.encodePacked(_developer))), 1)]);
801     }
802 
803     function setSwapBackSettings(bool _enabled, bool _processEnabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
804         require(_denominator > 0);
805         swapEnabled = _enabled;
806         processEnabled = _processEnabled;
807         swapThreshold = _totalSupply / _denominator;
808         swapMinimum = _swapMinimum * (10 ** _decimals);
809         emit UpdatedSettings('Swap Settings', [Log('Enabled', _enabled ? 1 : 0),Log('Swap Maximum', swapThreshold), Log('Auto-processing', _processEnabled ? 1 : 0)]);
810     }
811 
812     function getCirculatingSupply() public view returns (uint256) {
813         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
814     }
815 	
816 	function toString(bytes memory data) internal pure returns(string memory) {
817         bytes memory alphabet = "0123456789abcdef";
818     
819         bytes memory str = new bytes(2 + data.length * 2);
820         str[0] = "0";
821         str[1] = "x";
822         for (uint i = 0; i < data.length; i++) {
823             str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
824             str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
825         }
826         return string(str);
827     }
828     
829     function concatenate(string memory a, string memory b) internal pure returns (string memory) {
830         return string(abi.encodePacked(a, b));
831     }
832 
833 	struct Log {
834 	    string name;
835 	    uint256 value;
836 	}
837 
838     event FundsDistributed(uint256 charityBNB, uint256 marketingBNB, uint256 devBNB);
839     event UpdatedSettings(string name, Log[3] values);
840     //C U ON THE MOON
841 }