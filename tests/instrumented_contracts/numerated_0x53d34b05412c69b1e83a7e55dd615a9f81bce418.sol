1 /*
2 SHINJADOGE (SHINDOGE) v3
3 
4 Telegram: https://t.me/Shindoge
5 Website: https://www.shindoge.com/
6 Twitter: https://twitter.com/ShindogeETH
7 
8       ::::::::       :::    :::       :::::::::::       ::::    :::      :::::::::::           :::        :::::::::       ::::::::       ::::::::       :::::::::: 
9     :+:    :+:      :+:    :+:           :+:           :+:+:   :+:          :+:             :+: :+:      :+:    :+:     :+:    :+:     :+:    :+:      :+:         
10    +:+             +:+    +:+           +:+           :+:+:+  +:+          +:+            +:+   +:+     +:+    +:+     +:+    +:+     +:+             +:+          
11   +#++:++#++      +#++:++#++           +#+           +#+ +:+ +#+          +#+           +#++:++#++:    +#+    +:+     +#+    +:+     :#:             +#++:++#      
12         +#+      +#+    +#+           +#+           +#+  +#+#+#          +#+           +#+     +#+    +#+    +#+     +#+    +#+     +#+   +#+#      +#+            
13 #+#    #+#      #+#    #+#           #+#           #+#   #+#+#      #+# #+#           #+#     #+#    #+#    #+#     #+#    #+#     #+#    #+#      #+#             
14 ########       ###    ###       ###########       ###    ####       #####            ###     ###    #########       ########       ########       ##########       
15 
16 
17                        -**+=                 .::-===+*  .::                     
18                       -#**+=+-       .:-=++*******##*==++++#.                   
19                       #*%@%*+=+.:=+******###########+++*#%#*=                   
20                      :##@@@%*****+**#################*#@@@#*-                   
21                      =*#%%#*++**###################***%@@%*#.                   
22                      +*#*+++*########################*+*%#+*                    
23                      *#+++*###########################*+**#:                    
24                     :+===+++++++**********************+++++.                    
25                     +-**********************************++-=                    
26                     +-=++++******************************+-=                    
27                     +=***********************************+-=                    
28                     .=*+++*+==++**#############*++=-=++++*+=.                   
29                      :*+-======+++++========++++++======+#***=.                 
30                      .#+==++++%-@#++++*****++++#=%#+++-*+#--+*+=:               
31                       #+**=+++#@@*+*#@@@%#%%*++#@@*++=#**#*=.-+*++-             
32                       +*+##+=++**###%@@@@@@@###**++=+##****+=. :+*+=            
33                       -*+###########%%%%%%#############**-**==  :**==           
34                       .#+*############%################**.=*=+   **+=.          
35                        +*+#############################+* +*=+   ***==          
36                        .#+*###########################**- +*=+   +**++          
37                         :****########################+:   +*=+   -**+=.         
38                           :=****##################*=.    .+*=+   .***==.        
39                              .-+***#############+:       .+++=-   .=**===:      
40                                  .-=*########*-           +====-    :=++====:.  
41                                       :=+####+             ..:::      :==+=--==:
42 
43 */
44 
45 // SPDX-License-Identifier: Unlicensed
46 
47 pragma solidity 0.8.11;
48 
49 
50 library Address {
51     /**
52      * @dev Returns true if `account` is a contract.
53      *
54      * [IMPORTANT]
55      * ====
56      * It is unsafe to assume that an address for which this function returns
57      * false is an externally-owned account (EOA) and not a contract.
58      *
59      * Among others, `isContract` will return false for the following
60      * types of addresses:
61      *
62      *  - an externally-owned account
63      *  - a contract in construction
64      *  - an address where a contract will be created
65      *  - an address where a contract lived, but was destroyed
66      * ====
67      */
68     function isContract(address account) internal view returns (bool) {
69         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
70         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
71         // for accounts without code, i.e. `keccak256('')`
72         bytes32 codehash;
73         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { codehash := extcodehash(account) }
76         return (codehash != accountHash && codehash != 0x0);
77     }
78 
79     /**
80      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
81      * `recipient`, forwarding all available gas and reverting on errors.
82      *
83      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
84      * of certain opcodes, possibly making contracts go over the 2300 gas limit
85      * imposed by `transfer`, making them unable to receive funds via
86      * `transfer`. {sendValue} removes this limitation.
87      *
88      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
89      *
90      * IMPORTANT: because control is transferred to `recipient`, care must be
91      * taken to not create reentrancy vulnerabilities. Consider using
92      * {ReentrancyGuard} or the
93      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
94      */
95     function sendValue(address payable recipient, uint256 amount) internal {
96         require(address(this).balance >= amount, "Address: insufficient balance");
97 
98         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
99         (bool success, ) = recipient.call{ value: amount }("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103     /**
104      * @dev Performs a Solidity function call using a low level `call`. A
105      * plain`call` is an unsafe replacement for a function call: use this
106      * function instead.
107      *
108      * If `target` reverts with a revert reason, it is bubbled up by this
109      * function (like regular Solidity function calls).
110      *
111      * Returns the raw returned data. To convert to the expected return value,
112      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
113      *
114      * Requirements:
115      *
116      * - `target` must be a contract.
117      * - calling `target` with `data` must not revert.
118      *
119      * _Available since v3.1._
120      */
121     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
122       return functionCall(target, data, "Address: low-level call failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
127      * `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
132         return _functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
137      * but also transferring `value` wei to `target`.
138      *
139      * Requirements:
140      *
141      * - the calling contract must have an ETH balance of at least `value`.
142      * - the called Solidity function must be `payable`.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
152      * with `errorMessage` as a fallback revert reason when `target` reverts.
153      *
154      * _Available since v3.1._
155      */
156     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
157         require(address(this).balance >= value, "Address: insufficient balance for call");
158         return _functionCallWithValue(target, data, value, errorMessage);
159     }
160 
161     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
162         require(isContract(target), "Address: call to non-contract");
163 
164         // solhint-disable-next-line avoid-low-level-calls
165         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
166         if (success) {
167             return returndata;
168         } else {
169             // Look for revert reason and bubble it up if present
170             if (returndata.length > 0) {
171                 // The easiest way to bubble the revert reason is using memory via assembly
172 
173                 // solhint-disable-next-line no-inline-assembly
174                 assembly {
175                     let returndata_size := mload(returndata)
176                     revert(add(32, returndata), returndata_size)
177                 }
178             } else {
179                 revert(errorMessage);
180             }
181         }
182     }
183 }
184 
185 abstract contract Context {
186     function _msgSender() internal view returns (address payable) {
187         return payable(msg.sender);
188     }
189 
190     function _msgData() internal view returns (bytes memory) {
191         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
192         return msg.data;
193     }
194 }
195 
196 interface IERC20 {
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through {transferFrom}. This is
216      * address(0) by default.
217      *
218      * This value changes when {approve} or {transferFrom} are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be address(0).
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to {approve}. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 interface IDEXPair {
265     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
266 }
267 
268 interface IDEXFactory {
269     function createPair(address tokenA, address tokenB) external returns (address pair);
270 }
271 
272 interface IDEXRouter {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function addLiquidity(
277         address tokenA,
278         address tokenB,
279         uint amountADesired,
280         uint amountBDesired,
281         uint amountAMin,
282         uint amountBMin,
283         address to,
284         uint deadline
285     ) external returns (uint amountA, uint amountB, uint liquidity);
286 
287     function addLiquidityETH(
288         address token,
289         uint amountTokenDesired,
290         uint amountTokenMin,
291         uint amountETHMin,
292         address to,
293         uint deadline
294     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
295 
296     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
297         uint amountIn,
298         uint amountOutMin,
299         address[] calldata path,
300         address to,
301         uint deadline
302     ) external;
303 
304     function swapExactETHForTokensSupportingFeeOnTransferTokens(
305         uint amountOutMin,
306         address[] calldata path,
307         address to,
308         uint deadline
309     ) external payable;
310 
311     function swapExactTokensForETHSupportingFeeOnTransferTokens(
312         uint amountIn,
313         uint amountOutMin,
314         address[] calldata path,
315         address to,
316         uint deadline
317     ) external;
318 }
319 
320 /**
321  * @dev Contract module which provides a basic access control mechanism, where
322  * there is an account (an owner) that can be granted exclusive access to
323  * specific functions.
324  *
325  * By default, the owner account will be the one that deploys the contract. This
326  * can later be changed with {transferOwnership}.
327  *
328  * This module is used through inheritance. It will make available the modifier
329  * `onlyOwner`, which can be applied to your functions to restrict their use to
330  * the owner.
331  */
332 contract Ownable is Context {
333     address private _owner;
334 
335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
336 
337     /**
338      * @dev Initializes the contract setting the deployer as the initial owner.
339      */
340     constructor () {
341         address msgSender = _msgSender();
342         _owner = msgSender;
343         emit OwnershipTransferred(address(0), msgSender);
344     }
345 
346     /**
347      * @dev Returns the address of the current owner.
348      */
349     function owner() public view returns (address) {
350         return _owner;
351     }
352 
353     /**
354      * @dev Throws if called by any account other than the owner.
355      */
356     modifier onlyOwner() {
357         require(_owner == _msgSender(), "Ownable: caller is not the owner");
358         _;
359     }
360      /**
361      * @dev Leaves the contract without owner. It will not be possible to call
362      * `onlyOwner` functions anymore. Can only be called by the current owner.
363      *
364      * NOTE: Renouncing ownership will leave the contract without an owner,
365      * thereby removing any functionality that is only available to the owner.
366      */
367     function renounceOwnership() public virtual onlyOwner {
368         emit OwnershipTransferred(_owner, address(0));
369         _owner = address(0);
370     }
371 
372     /**
373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
374      * Can only be called by the current owner.
375      */
376     function transferOwnership(address newOwner) public virtual onlyOwner {
377         require(newOwner != address(0), "Ownable: new owner is the address(0) address");
378         emit OwnershipTransferred(_owner, newOwner);
379         _owner = newOwner;
380     }
381 }
382 
383 interface IAntiSnipe {
384   function setTokenOwner(address owner, address pair) external;
385 
386   function onPreTransferCheck(
387     address from,
388     address to,
389     uint256 amount
390   ) external returns (bool checked);
391 }
392 
393 contract Shinjadoge is IERC20, Ownable {
394     using Address for address;
395     
396     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
397 
398     string constant _name = "SHINJADOGE";
399     string constant _symbol = "SHINDOGE";
400     uint8 constant _decimals = 9;
401 
402     uint256 constant _totalSupply = 1_000_000_000_000 * (10 ** _decimals);
403 
404     //For ease to the end-user these checks do not adjust for burnt tokens and should be set accordingly.
405     uint256 public _maxTxAmount = (_totalSupply * 1) / 222; //~0.45%
406     uint256 public _maxWalletSize = (_totalSupply * 1) / 200; //0.5%
407 
408     mapping (address => uint256) _balances;
409     mapping (address => mapping (address => uint256)) _allowances;
410     mapping (address => uint256) lastBuy;
411     mapping (address => uint256) lastSell;
412     mapping (address => uint256) lastSellAmount;
413 
414     mapping (address => bool) isFeeExempt;
415     mapping (address => bool) isTxLimitExempt;
416 
417     uint256 liquidityFee = 30;
418     uint256 marketingFee = 50;
419     uint256 devFee = 40;
420     uint256 totalFee = 120;
421     uint256 sellBias = 0;
422 
423     //Higher tax for a period of time from the first purchase only, per address
424     uint256 sellPercent = 200;
425     uint256 sellPeriod = 24 hours;
426 
427     uint256 antiDumpTax = 300;
428     uint256 antiDumpPeriod = 30 minutes;
429     uint256 antiDumpThreshold = 21;
430     bool antiDumpReserve0 = true;
431     uint256 feeDenominator = 1000;
432 
433     address public immutable liquidityReceiver;
434     address payable public immutable marketingReceiver;
435     address payable public immutable devReceiver;
436 
437     uint256 targetLiquidity = 40;
438     uint256 targetLiquidityDenominator = 100;
439 
440     IDEXRouter public immutable router;
441     
442     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
443 
444     mapping (address => bool) liquidityPools;
445     mapping (address => bool) liquidityProviders;
446 
447     address public immutable pair;
448 
449     uint256 public launchedAt;
450     uint256 public launchedTime;
451  
452     IAntiSnipe public antisnipe;
453     bool public protectionEnabled = true;
454     bool public protectionDisabled = false;
455 
456     bool public swapEnabled = true;
457     uint256 public swapThreshold = _totalSupply / 400; //0.25%
458     uint256 public swapMinimum = _totalSupply / 10000; //0.01%
459     bool inSwap;
460     modifier swapping() { inSwap = true; _; inSwap = false; }
461 
462     constructor (address _lp, address _marketing, address _dev) {
463         //Suggest setting liquidity receiver to DEAD to lock funds in the project and avoid centralization
464         liquidityReceiver = _lp;
465         marketingReceiver = payable(_marketing);
466         devReceiver = payable(_dev);
467 
468         router = IDEXRouter(routerAddress);
469         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
470         liquidityPools[pair] = true;
471         _allowances[owner()][routerAddress] = type(uint256).max;
472         _allowances[address(this)][routerAddress] = type(uint256).max;
473         
474         isFeeExempt[owner()] = true;
475         liquidityProviders[owner()] = true;
476 
477         isTxLimitExempt[address(this)] = true;
478         isTxLimitExempt[owner()] = true;
479         isTxLimitExempt[routerAddress] = true;
480 
481         _balances[owner()] = _totalSupply;
482         emit Transfer(address(0), owner(), _totalSupply);
483     }
484 
485     receive() external payable { }
486 
487     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
488     function decimals() external pure returns (uint8) { return _decimals; }
489     function symbol() external pure returns (string memory) { return _symbol; }
490     function name() external pure returns (string memory) { return _name; }
491     function getOwner() external view returns (address) { return owner(); }
492     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
493     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
494 
495     function approve(address spender, uint256 amount) public override returns (bool) {
496         _allowances[msg.sender][spender] = amount;
497         emit Approval(msg.sender, spender, amount);
498         return true;
499     }
500 
501     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
502         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
503         return true;
504     }
505 
506     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
507         uint256 currentAllowance = _allowances[msg.sender][spender];
508         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below address(0)");
509         unchecked {
510             _approve(msg.sender, spender, currentAllowance - subtractedValue);
511         }
512 
513         return true;
514     }
515 
516     function _approve(address owner, address spender, uint256 amount) internal virtual {
517         require(owner != address(0), "ERC20: approve from the address(0) address");
518         require(spender != address(0), "ERC20: approve to the address(0) address");
519 
520         _allowances[owner][spender] = amount;
521         emit Approval(owner, spender, amount);
522     }
523 
524     function approveMax(address spender) external returns (bool) {
525         return approve(spender, type(uint256).max);
526     }
527 
528     function transfer(address recipient, uint256 amount) external override returns (bool) {
529         return _transferFrom(msg.sender, recipient, amount);
530     }
531 
532     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
533         if(_allowances[sender][msg.sender] != type(uint256).max){
534             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
535         }
536 
537         return _transferFrom(sender, recipient, amount);
538     }
539 
540     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
541         require(_balances[sender] >= amount, "Insufficient balance");
542         require(amount > 0, "address(0) amount transferred");
543 
544         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
545 
546         checkTxLimit(sender, amount);
547         
548         if (!liquidityPools[recipient] && recipient != DEAD) {
549             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
550         }
551 
552         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient], "Contract not launched yet."); }
553 
554         _balances[sender] -= amount;
555 
556         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
557         
558         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
559         
560         _balances[recipient] += amountReceived;
561             
562         if(launched() && protectionEnabled)
563             antisnipe.onPreTransferCheck(sender, recipient, amount);
564 
565         emit Transfer(sender, recipient, amountReceived);
566         return true;
567     }
568 
569     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
570         _balances[sender] -= amount;
571         _balances[recipient] += amount;
572         emit Transfer(sender, recipient, amount);
573         return true;
574     }
575     
576     function checkWalletLimit(address recipient, uint256 amount) internal view {
577         uint256 walletLimit = _maxWalletSize;
578         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
579     }
580 
581     function checkTxLimit(address sender, uint256 amount) internal view {
582         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
583     }
584 
585     function shouldTakeFee(address sender) internal view returns (bool) {
586         return !isFeeExempt[sender];
587     }
588 
589     function getTotalFee(bool selling, bool inHighPeriod) public view returns (uint256) {
590         if(launchedAt == block.number){ return feeDenominator - 1; }
591         if (selling) return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee + sellBias;
592         return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee - sellBias;
593     }
594 
595     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
596         uint256 feeAmount = 0;
597         bool highSellPeriod = !liquidityPools[sender] && lastBuy[sender] + sellPeriod > block.timestamp;
598         if(liquidityPools[recipient] && antiDumpTax > 0) {
599             (uint112 reserve0, uint112 reserve1,) = IDEXPair(pair).getReserves();
600             uint256 impactEstimate = amount * 1000 / ((antiDumpReserve0 ? reserve0 : reserve1) + amount);
601             
602             if (block.timestamp > lastSell[sender] + antiDumpPeriod) {
603                 lastSell[sender] = block.timestamp;
604                 lastSellAmount[sender] = 0;
605             }
606             
607             lastSellAmount[sender] += impactEstimate;
608             
609             if (lastSellAmount[sender] >= antiDumpThreshold) {
610                 feeAmount = ((amount * totalFee * antiDumpTax) / 100) / feeDenominator;
611             }
612         }
613 
614         if (feeAmount == 0)
615             feeAmount = (amount * getTotalFee(liquidityPools[recipient], highSellPeriod)) / feeDenominator;
616         
617         if (liquidityPools[sender] && lastBuy[recipient] == 0)
618             lastBuy[recipient] = block.timestamp;
619 
620         _balances[address(this)] += feeAmount;
621         emit Transfer(sender, address(this), feeAmount);
622 
623         return amount - feeAmount;
624     }
625 
626     function shouldSwapBack(address recipient) internal view returns (bool) {
627         return !liquidityPools[msg.sender]
628         && !isFeeExempt[msg.sender]
629         && !inSwap
630         && swapEnabled
631         && liquidityPools[recipient]
632         && _balances[address(this)] >= swapMinimum &&
633         totalFee > 0;
634     }
635 
636     function swapBack(uint256 amount) internal swapping {
637         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
638         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
639         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
640         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / totalFee) / 2;
641         amountToSwap -= amountToLiquify;
642 
643         address[] memory path = new address[](2);
644         path[0] = address(this);
645         path[1] = router.WETH();
646         
647         //Guaranteed swap desired to prevent trade blockages
648         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
649             amountToSwap,
650             0,
651             path,
652             address(this),
653             block.timestamp
654         );
655 
656         uint256 contractBalance = address(this).balance;
657         uint256 totalETHFee = totalFee - dynamicLiquidityFee / 2;
658 
659         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
660         uint256 amountMarketing = (contractBalance * marketingFee) / totalETHFee;
661         uint256 amountDev = contractBalance - (amountLiquidity + amountMarketing);
662 
663         if(amountToLiquify > 0) {
664             //Guaranteed swap desired to prevent trade blockages, return values ignored
665             router.addLiquidityETH{value: amountLiquidity}(
666                 address(this),
667                 amountToLiquify,
668                 0,
669                 0,
670                 liquidityReceiver,
671                 block.timestamp
672             );
673             emit AutoLiquify(amountLiquidity, amountToLiquify);
674         }
675         
676         if (amountMarketing > 0)
677             marketingReceiver.transfer(amountMarketing);
678             
679         if (amountDev > 0)
680             devReceiver.transfer(amountDev);
681 
682     }
683 
684     function launched() internal view returns (bool) {
685         return launchedAt != 0;
686     }
687 
688     function getCirculatingSupply() public view returns (uint256) {
689         return _totalSupply - (balanceOf(DEAD) + balanceOf(address(0)));
690     }
691 
692     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
693         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
694     }
695 
696     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
697         return getLiquidityBacking(accuracy) > target;
698     }
699 
700     function transferOwnership(address newOwner) public virtual override onlyOwner {
701         isFeeExempt[owner()] = false;
702         isTxLimitExempt[owner()] = false;
703         liquidityProviders[owner()] = false;
704         _allowances[owner()][routerAddress] = 0;
705         super.transferOwnership(newOwner);
706         isFeeExempt[newOwner] = true;
707         isTxLimitExempt[newOwner] = true;
708         liquidityProviders[newOwner] = true;
709         _allowances[newOwner][routerAddress] = type(uint256).max;
710     }
711 
712     function renounceOwnership() public virtual override onlyOwner {
713         isFeeExempt[owner()] = false;
714         isTxLimitExempt[owner()] = false;
715         liquidityProviders[owner()] = false;
716         _allowances[owner()][routerAddress] = 0;
717         super.renounceOwnership();
718     }
719 
720     function setProtectionEnabled(bool _protect) external onlyOwner {
721         if (_protect)
722             require(!protectionDisabled, "Protection disabled");
723         protectionEnabled = _protect;
724         emit ProtectionToggle(_protect);
725     }
726     
727     function setProtection(address _protection, bool _call) external onlyOwner {
728         if (_protection != address(antisnipe)){
729             require(!protectionDisabled, "Protection disabled");
730             antisnipe = IAntiSnipe(_protection);
731         }
732         if (_call)
733             antisnipe.setTokenOwner(address(this), pair);
734         
735         emit ProtectionSet(_protection);
736     }
737     
738     function disableProtection() external onlyOwner {
739         protectionDisabled = true;
740         emit ProtectionDisabled();
741     }
742     
743     function setLiquidityProvider(address _provider) external onlyOwner {
744         require(_provider != pair && _provider != routerAddress, "Can't alter trading contracts in this manner.");
745         isFeeExempt[_provider] = true;
746         liquidityProviders[_provider] = true;
747         isTxLimitExempt[_provider] = true;
748         emit LiquidityProviderSet(_provider);
749     }
750 
751     function setSellPeriod(uint256 _sellPercentIncrease, uint256 _period) external onlyOwner {
752         require((totalFee * _sellPercentIncrease) / 100 <= 400, "Sell tax too high");
753         require(_sellPercentIncrease >= 100, "Can't make sells cheaper with this");
754         require(antiDumpTax == 0 || _sellPercentIncrease <= antiDumpTax, "High period tax clashes with anti-dump tax");
755         require(_period <= 7 days, "Sell period too long");
756         sellPercent = _sellPercentIncrease;
757         sellPeriod = _period;
758         emit SellPeriodSet(_sellPercentIncrease, _period);
759     }
760 
761     function setAntiDumpTax(uint256 _tax, uint256 _period, uint256 _threshold, bool _reserve0) external onlyOwner {
762         require(_threshold >= 10 && _tax <= 400 && (_tax == 0 || _tax >= sellPercent) && _period <= 1 hours, "Parameters out of bounds");
763         antiDumpTax = _tax;
764         antiDumpPeriod = _period;
765         antiDumpThreshold = _threshold;
766         antiDumpReserve0 = _reserve0;
767         emit AntiDumpTaxSet(_tax, _period, _threshold);
768     }
769 
770     function launch() external onlyOwner {
771         require (launchedAt == 0);
772         launchedAt = block.number;
773         launchedTime = block.timestamp;
774         emit TradingLaunched();
775     }
776 
777     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
778         require(numerator > 0 && divisor > 0 && (numerator * 1000) / divisor >= 5, "Transaction limits too low");
779         _maxTxAmount = (_totalSupply * numerator) / divisor;
780         emit TransactionLimitSet(_maxTxAmount);
781     }
782     
783     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
784         require(divisor > 0 && divisor <= 10000, "Divisor must be greater than 0");
785         _maxWalletSize = (_totalSupply * numerator) / divisor;
786         emit MaxWalletSet(_maxWalletSize);
787     }
788 
789     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
790         require(holder != address(0), "Invalid address");
791         isFeeExempt[holder] = exempt;
792         emit FeeExemptSet(holder, exempt);
793     }
794 
795     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
796         require(holder != address(0), "Invalid address");
797         isTxLimitExempt[holder] = exempt;
798         emit TrasactionLimitExemptSet(holder, exempt);
799     }
800 
801     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
802         require((_liquidityFee / 2) * 2 == _liquidityFee, "Liquidity fee must be an even number due to rounding");
803         liquidityFee = _liquidityFee;
804         marketingFee = _marketingFee;
805         devFee = _devFee;
806         sellBias = _sellBias;
807         totalFee = _liquidityFee + _marketingFee + _devFee;
808         feeDenominator = _feeDenominator;
809         require(totalFee <= feeDenominator / 4, "Fees too high");
810         require(sellBias <= totalFee, "Incorrect sell bias");
811         emit FeesSet(totalFee, feeDenominator, sellBias);
812     }
813 
814     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
815         require(_denominator > 0 && _denominatorMin > 0, "Denominators must be greater than 0");
816         swapEnabled = _enabled;
817         swapMinimum = _totalSupply / _denominatorMin;
818         swapThreshold = _totalSupply / _denominator;
819         emit SwapSettingsSet(swapMinimum, swapThreshold, swapEnabled);
820     }
821 
822     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
823         targetLiquidity = _target;
824         targetLiquidityDenominator = _denominator;
825         emit TargetLiquiditySet(_target * 100 / _denominator);
826     }
827 
828     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
829         require(_pool != address(0), "Invalid address");
830         liquidityPools[_pool] = _enabled;
831         emit LiquidityPoolSet(_pool, _enabled);
832     }
833 
834 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
835     {
836         require(_addresses.length == _amount.length, "Array lengths don't match");
837         bool previousSwap = swapEnabled;
838         swapEnabled = false;
839         //This function may run out of gas intentionally to prevent partial airdrops
840         for (uint256 i = 0; i < _addresses.length; i++) {
841             require(!liquidityPools[_addresses[i]] && _addresses[i] != address(0), "Can't airdrop the liquidity pool or address 0");
842             _transferFrom(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
843             lastBuy[_addresses[i]] = block.timestamp;
844         }
845         swapEnabled = previousSwap;
846         emit AirdropSent(msg.sender);
847     }
848 
849     event AutoLiquify(uint256 amount, uint256 amountToken);
850     event ProtectionSet(address indexed protection);
851     event ProtectionDisabled();
852     event LiquidityProviderSet(address indexed provider);
853     event SellPeriodSet(uint256 percent, uint256 period);
854     event TradingLaunched();
855     event TransactionLimitSet(uint256 limit);
856     event MaxWalletSet(uint256 limit);
857     event FeeExemptSet(address indexed wallet, bool isExempt);
858     event TrasactionLimitExemptSet(address indexed wallet, bool isExempt);
859     event FeesSet(uint256 totalFees, uint256 denominator, uint256 sellBias);
860     event SwapSettingsSet(uint256 minimum, uint256 maximum, bool enabled);
861     event LiquidityPoolSet(address indexed pool, bool enabled);
862     event AirdropSent(address indexed from);
863     event AntiDumpTaxSet(uint256 rate, uint256 period, uint256 threshold);
864     event TargetLiquiditySet(uint256 percent);
865     event ProtectionToggle(bool isEnabled);
866 }