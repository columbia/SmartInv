1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.17;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 library Address {
17     function isContract(address account) internal view returns (bool) {
18         return account.code.length > 0;
19     }
20 
21     function sendValue(address payable recipient, uint256 amount) internal {
22         require(address(this).balance >= amount, "Address: insufficient balance");
23 
24         (bool success, ) = recipient.call{value: amount}("");
25         require(success, "Address: unable to send value, recipient may have reverted");
26     }
27 
28     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
29         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
30     }
31 
32     function functionCall(
33         address target,
34         bytes memory data,
35         string memory errorMessage
36     ) internal returns (bytes memory) {
37         return functionCallWithValue(target, data, 0, errorMessage);
38     }
39 
40     /**
41      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
42      * but also transferring `value` wei to `target`.
43      *
44      * Requirements:
45      *
46      * - the calling contract must have an ETH balance of at least `value`.
47      * - the called Solidity function must be `payable`.
48      *
49      * _Available since v3.1._
50      */
51     function functionCallWithValue(
52         address target,
53         bytes memory data,
54         uint256 value
55     ) internal returns (bytes memory) {
56         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
57     }
58 
59     /**
60      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
61      * with `errorMessage` as a fallback revert reason when `target` reverts.
62      *
63      * _Available since v3.1._
64      */
65     function functionCallWithValue(
66         address target,
67         bytes memory data,
68         uint256 value,
69         string memory errorMessage
70     ) internal returns (bytes memory) {
71         require(address(this).balance >= value, "Address: insufficient balance for call");
72         (bool success, bytes memory returndata) = target.call{value: value}(data);
73         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
74     }
75 
76     /**
77      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
78      * but performing a static call.
79      *
80      * _Available since v3.3._
81      */
82     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
83         return functionStaticCall(target, data, "Address: low-level static call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
88      * but performing a static call.
89      *
90      * _Available since v3.3._
91      */
92     function functionStaticCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal view returns (bytes memory) {
97         (bool success, bytes memory returndata) = target.staticcall(data);
98         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but performing a delegate call.
104      *
105      * _Available since v3.4._
106      */
107     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
113      * but performing a delegate call.
114      *
115      * _Available since v3.4._
116      */
117     function functionDelegateCall(
118         address target,
119         bytes memory data,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         (bool success, bytes memory returndata) = target.delegatecall(data);
123         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
124     }
125 
126     /**
127      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
128      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
129      *
130      * _Available since v4.8._
131      */
132     function verifyCallResultFromTarget(
133         address target,
134         bool success,
135         bytes memory returndata,
136         string memory errorMessage
137     ) internal view returns (bytes memory) {
138         if (success) {
139             if (returndata.length == 0) {
140                 // only check isContract if the call was successful and the return data is empty
141                 // otherwise we already know that it was a contract
142                 require(isContract(target), "Address: call to non-contract");
143             }
144             return returndata;
145         } else {
146             _revert(returndata, errorMessage);
147         }
148     }
149 
150     /**
151      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
152      * revert reason or using the provided one.
153      *
154      * _Available since v4.3._
155      */
156     function verifyCallResult(
157         bool success,
158         bytes memory returndata,
159         string memory errorMessage
160     ) internal pure returns (bytes memory) {
161         if (success) {
162             return returndata;
163         } else {
164             _revert(returndata, errorMessage);
165         }
166     }
167 
168     function _revert(bytes memory returndata, string memory errorMessage) private pure {
169         // Look for revert reason and bubble it up if present
170         if (returndata.length > 0) {
171             // The easiest way to bubble the revert reason is using memory via assembly
172             /// @solidity memory-safe-assembly
173             assembly {
174                 let returndata_size := mload(returndata)
175                 revert(add(32, returndata), returndata_size)
176             }
177         } else {
178             revert(errorMessage);
179         }
180     }
181 }
182 
183 library SafeERC20 {
184     using Address for address;
185 
186     function safeTransfer(
187         IERC20 token,
188         address to,
189         uint256 value
190     ) internal {
191         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
192     }
193 
194     function _callOptionalReturn(IERC20 token, bytes memory data) private {
195         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
196         if (returndata.length > 0) {
197             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
198         }
199     }
200 }
201 
202 interface IERC20 {
203     function totalSupply() external view returns (uint256);
204     function balanceOf(address account) external view returns (uint256);
205     function transfer(address recipient, uint256 amount) external returns (bool);
206     function allowance(address owner, address spender) external view returns (uint256);
207     function approve(address spender, uint256 amount) external returns (bool);
208     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
209 
210     event Transfer(address indexed from, address indexed to, uint256 value);
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 interface IERC20Metadata is IERC20 {
215     function name() external view returns (string memory);
216     function symbol() external view returns (string memory);
217     function decimals() external view returns (uint8);
218 }
219 
220 contract ERC20 is Context, IERC20, IERC20Metadata {
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229     uint8 private _decimals;
230 
231     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
232         _name = name_;
233         _symbol = symbol_;
234         _decimals = decimals_;
235     }
236 
237     function name() public view virtual override returns (string memory) {
238         return _name;
239     }
240 
241     function symbol() public view virtual override returns (string memory) {
242         return _symbol;
243     }
244 
245     function decimals() public view virtual override returns (uint8) {
246         return _decimals;
247     }
248 
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252 
253     function balanceOf(address account) public view virtual override returns (uint256) {
254         return _balances[account];
255     }
256 
257     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261 
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     function approve(address spender, uint256 amount) public virtual override returns (bool) {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
272         _transfer(sender, recipient, amount);
273 
274         uint256 currentAllowance = _allowances[sender][_msgSender()];
275         if(currentAllowance != type(uint256).max){
276             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
277             unchecked {
278                 _approve(sender, _msgSender(), currentAllowance - amount);
279             }
280         }
281 
282         return true;
283     }
284 
285     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
286         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
287         return true;
288     }
289 
290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
291         uint256 currentAllowance = _allowances[_msgSender()][spender];
292         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
293         unchecked {
294             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
295         }
296 
297         return true;
298     }
299 
300     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
301         require(sender != address(0), "ERC20: transfer from the zero address");
302         require(recipient != address(0), "ERC20: transfer to the zero address");
303 
304         uint256 senderBalance = _balances[sender];
305         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
306         unchecked {
307             _balances[sender] = senderBalance - amount;
308         }
309         _balances[recipient] += amount;
310 
311         emit Transfer(sender, recipient, amount);
312     }
313 
314     function _createInitialSupply(address account, uint256 amount) internal virtual {
315         require(account != address(0), "ERC20: mint to the zero address");
316 
317         _totalSupply += amount;
318         _balances[account] += amount;
319         emit Transfer(address(0), account, amount);
320     }
321 
322     function _approve(address owner, address spender, uint256 amount) internal virtual {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325 
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 }
330 
331 contract Ownable is Context {
332     address private _owner;
333 
334     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
335     
336     constructor () {
337         address msgSender = _msgSender();
338         _owner = msgSender;
339         emit OwnershipTransferred(address(0), msgSender);
340     }
341 
342     function owner() public view returns (address) {
343         return _owner;
344     }
345 
346     modifier onlyOwner() {
347         require(_owner == _msgSender(), "Ownable: caller is not the owner");
348         _;
349     }
350 
351     function renounceOwnership() external virtual onlyOwner {
352         emit OwnershipTransferred(_owner, address(0));
353         _owner = address(0);
354     }
355 
356     function transferOwnership(address newOwner) public virtual onlyOwner {
357         require(newOwner != address(0), "Ownable: new owner is the zero address");
358         emit OwnershipTransferred(_owner, newOwner);
359         _owner = newOwner;
360     }
361 }
362 
363 interface ILpPair {
364     function sync() external;
365 }
366 
367 interface IDexRouter {
368     function factory() external pure returns (address);
369     function WETH() external pure returns (address);
370     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
371     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
372     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
373     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
374     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
375     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
376 }
377 
378 interface IDexFactory {
379     function createPair(address tokenA, address tokenB) external returns (address pair);
380 }
381 
382 
383 contract TheCitadel is ERC20, Ownable {
384 
385     uint256 public maxBuyAmount;
386 
387     IDexRouter public immutable dexRouter;
388     address public immutable lpPair;
389 
390     bool private swapping;
391     uint256 public swapTokensAtAmount;
392 
393     address public ironBankAddress;
394     address public rewardsAddress;
395 
396     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
397 
398     bool public limitsInEffect = true;
399     bool public tradingActive = false;
400     bool public swapEnabled = false;
401     
402      // Anti-bot and anti-whale mappings and variables
403     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
404     bool public transferDelayEnabled = true;
405 
406     uint256 public buyTotalFees;
407     uint256 public buyIronBankFee;
408     uint256 public buyLiquidityFee;
409     uint256 public buyRewardsFee;
410 
411     uint256 public sellTotalFees;
412     uint256 public sellIronBankFee;
413     uint256 public sellLiquidityFee;
414     uint256 public sellRewardsFee;
415 
416     uint256 public tokensForIronBank;
417     uint256 public tokensForLiquidity;
418     uint256 public tokensForRewards;
419     
420     mapping (address => bool) private _isExcludedFromFees;
421     mapping (address => bool) public _isExcludedMaxTransactionAmount;
422 
423     mapping (address => bool) public automatedMarketMakerPairs;
424 
425     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
426     event EnabledTrading();
427     event RemovedLimits();
428     event ExcludeFromFees(address indexed account, bool isExcluded);
429     event UpdatedMaxBuyAmount(uint256 newAmount);
430     event UpdatedBuyFee(uint256 newAmount);
431     event UpdatedSellFee(uint256 newAmount);
432     event UpdatedIronBankAddress(address indexed newWallet);
433     event UpdatedRewardsAddress(address indexed newWallet);
434     event MaxTransactionExclusion(address _address, bool excluded);
435     event OwnerForcedSwapBack(uint256 timestamp);
436     event TransferForeignToken(address token, uint256 amount);
437     event RemovedTokenHoldingsRequiredToBuy();
438     event TransferDelayDisabled();
439     event ReuppedApprovals();
440     event SwapTokensAtAmountUpdated(uint256 newAmount);
441 
442     constructor() ERC20("The Citadel", "CITADEL", 18){
443         address newOwner = msg.sender; // can leave alone if owner is deployer.
444 
445         address _dexRouter;
446 
447         // automatically detect router/desired stablecoin
448         if(block.chainid == 1){
449             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
450         } else if(block.chainid == 5){
451             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
452         } else if(block.chainid == 56){
453             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
454         } else if(block.chainid == 97){
455             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
456         } else {
457             revert("Chain not configured");
458         }
459 
460         // initialize router
461         dexRouter = IDexRouter(_dexRouter);
462 
463         // create pair
464         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
465         setAutomatedMarketMakerPair(address(lpPair), true);
466 
467         uint256 totalSupply = 1 * 1e9 * (10**decimals());
468         
469         maxBuyAmount = totalSupply * 5 / 1000;
470         swapTokensAtAmount = totalSupply * 25 / 100000;
471 
472         buyIronBankFee = 4;
473         buyLiquidityFee = 0;
474         buyRewardsFee = 3;
475         buyTotalFees = buyIronBankFee + buyLiquidityFee + buyRewardsFee;
476 
477         sellIronBankFee = 17;
478         sellLiquidityFee = 0;
479         sellRewardsFee = 3;
480         sellTotalFees = sellIronBankFee + sellLiquidityFee + sellRewardsFee;
481 
482         // update these!
483         ironBankAddress = address(0x2eE82E0A83282696b96fA8555E4A9823715A4F9C);
484         rewardsAddress = address(newOwner);
485 
486         _excludeFromMaxTransaction(newOwner, true);
487         _excludeFromMaxTransaction(address(dexRouter), true);
488         _excludeFromMaxTransaction(address(this), true);
489         _excludeFromMaxTransaction(address(0xdead), true);
490         _excludeFromMaxTransaction(address(ironBankAddress), true);
491 
492         excludeFromFees(newOwner, true);
493         excludeFromFees(address(dexRouter), true);
494         excludeFromFees(address(this), true);
495         excludeFromFees(address(0xdead), true);
496         excludeFromFees(address(ironBankAddress), true);
497 
498         _createInitialSupply(address(newOwner), totalSupply);
499         transferOwnership(newOwner);
500 
501         _approve(address(this), address(dexRouter), type(uint256).max);
502         _approve(msg.sender, address(dexRouter), totalSupply);
503     }
504 
505     receive() external payable {
506     }
507 
508     function enableTrading() external onlyOwner {
509         require(!tradingActive, "Trading is already active, cannot relaunch.");
510         tradingActive = true;
511         swapEnabled = true;
512         tradingActiveBlock = block.number;
513         emit EnabledTrading();
514     }
515 
516     // remove limits after token is stable
517     function removeLimits() external onlyOwner {
518         limitsInEffect = false;
519         transferDelayEnabled = false;
520         maxBuyAmount = totalSupply();
521         emit RemovedLimits();
522     }
523 
524     // disable Transfer delay - cannot be reenabled
525     function disableTransferDelay() external onlyOwner {
526         transferDelayEnabled = false;
527         emit TransferDelayDisabled();
528     }
529     
530     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
531         require(newNum >= (totalSupply() * 1 / 10000)/(10**decimals()), "Cannot set max buy amount lower than 0.01%");
532         maxBuyAmount = newNum * (10**decimals());
533         emit UpdatedMaxBuyAmount(maxBuyAmount);
534     }
535 
536     // change the minimum amount of tokens to sell from fees
537     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
538   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
539   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
540   	    swapTokensAtAmount = newAmount;
541         emit SwapTokensAtAmountUpdated(newAmount);
542   	}
543     
544     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
545         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
546         emit MaxTransactionExclusion(updAds, isExcluded);
547     }
548 
549     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
550         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
551         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits");
552         for(uint256 i = 0; i < wallets.length; i++){
553             super._transfer(msg.sender, wallets[i], amountsInTokens[i]);
554         }
555     }
556     
557     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
558         if(!isEx){
559             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
560         }
561         _isExcludedMaxTransactionAmount[updAds] = isEx;
562         emit MaxTransactionExclusion(updAds, isEx);
563     }
564 
565     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
566         require(pair != lpPair || value, "The pair cannot be removed from automatedMarketMakerPairs");
567         automatedMarketMakerPairs[pair] = value;
568         _excludeFromMaxTransaction(pair, value);
569         emit SetAutomatedMarketMakerPair(pair, value);
570     }
571 
572     function updateBuyFees(uint256 _ironBankFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
573         buyIronBankFee = _ironBankFee;
574         buyLiquidityFee = _liquidityFee;
575         buyRewardsFee = _rewardsFee;
576         buyTotalFees = buyIronBankFee + buyLiquidityFee + buyRewardsFee;
577         require(buyTotalFees <= 10, "Must keep buy fees at 10% or less");
578         emit UpdatedBuyFee(buyTotalFees);
579     }
580 
581     function updateSellFees(uint256 _ironBankFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
582         sellIronBankFee = _ironBankFee;
583         sellLiquidityFee = _liquidityFee;
584         sellRewardsFee = _rewardsFee;
585         sellTotalFees = sellIronBankFee + sellLiquidityFee + sellRewardsFee;
586         require(sellTotalFees <= 20, "Must keep sell fees at 20% or less");
587         emit UpdatedSellFee(sellTotalFees);
588     }
589 
590     function excludeFromFees(address account, bool excluded) public onlyOwner {
591         _isExcludedFromFees[account] = excluded;
592         emit ExcludeFromFees(account, excluded);
593     }
594 
595     function _transfer(address from, address to, uint256 amount) internal override {
596 
597         require(from != address(0), "ERC20: transfer from the zero address");
598         require(to != address(0), "ERC20: transfer to the zero address");
599         if(amount == 0){
600             super._transfer(from, to, 0);
601             return;
602         }
603 
604         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
605             super._transfer(from, to, amount);
606             return;
607         }
608         
609         if(!tradingActive){
610             revert("Trading is not active.");
611         }        
612         
613         if(limitsInEffect){
614             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
615             if (transferDelayEnabled){
616                 if (to != address(dexRouter) && to != address(lpPair)){
617                     require(_holderLastTransferBlock[tx.origin] + 1 < block.number && _holderLastTransferBlock[to] + 1 < block.number, "_transfer:: Transfer Delay enabled.  Try again later.");
618                     _holderLastTransferBlock[tx.origin] = block.number;
619                     _holderLastTransferBlock[to] = block.number;
620                 }
621             }
622                 
623             //when buy
624             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
625                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
626             }
627         }
628 
629         if(balanceOf(address(this)) > swapTokensAtAmount && swapEnabled && !swapping && automatedMarketMakerPairs[to]) {
630             swapping = true;
631             swapBack();
632             swapping = false;
633         }
634         
635         uint256 fees = 0;
636 
637         // on sell
638         if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
639             fees = amount * sellTotalFees / 100;
640             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
641             tokensForIronBank += fees * sellIronBankFee / sellTotalFees;
642             tokensForRewards += fees * sellRewardsFee / sellTotalFees;
643         }
644 
645         // on buy
646         else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
647             fees = amount * buyTotalFees / 100;
648             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
649             tokensForIronBank += fees * buyIronBankFee / buyTotalFees;
650             tokensForRewards += fees * buyRewardsFee / buyTotalFees;
651         }
652         
653         if(fees > 0){    
654             super._transfer(from, address(this), fees);
655             amount -= fees;
656         }
657         
658         super._transfer(from, to, amount);
659     }
660 
661     function swapTokensForEth(uint256 tokenAmount) private {
662 
663         // generate the uniswap pair path of token -> weth
664         address[] memory path = new address[](2);
665         path[0] = address(this);
666         path[1] = dexRouter.WETH();
667 
668         // make the swap
669         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
670     }
671 
672     function swapBack() private {
673         bool success;
674 
675         uint256 contractBalance = balanceOf(address(this));
676         uint256 totalTokensToSwap = tokensForRewards + tokensForIronBank + tokensForLiquidity;
677         
678         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
679 
680         if(contractBalance > swapTokensAtAmount * 60){
681             contractBalance = swapTokensAtAmount * 60;
682         }
683 
684         if(tokensForLiquidity > 0){
685             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
686             super._transfer(address(this), lpPair, liquidityTokens);
687             try ILpPair(lpPair).sync(){} catch {}
688             contractBalance -= liquidityTokens;
689             totalTokensToSwap -= tokensForLiquidity;
690         }
691 
692         swapTokensForEth(contractBalance);
693         
694         uint256 ethBalance = address(this).balance;
695 
696         uint256 ethForIronBank = ethBalance * tokensForIronBank / totalTokensToSwap;
697 
698         tokensForRewards = 0;
699         tokensForIronBank = 0;
700         tokensForLiquidity = 0;
701 
702         if(ethForIronBank > 0){
703             (success, ) = ironBankAddress.call{value: ethForIronBank}("");
704         }
705 
706         if(address(this).balance > 0){
707             (success, ) = rewardsAddress.call{value: address(this).balance}("");
708         }
709     }
710 
711     function sendEth() external onlyOwner {
712         bool success;
713         (success, ) = msg.sender.call{value: address(this).balance}("");
714         require(success, "withdraw unsuccessful");
715     }
716 
717     function transferForeignToken(address _token, address _to) external onlyOwner {
718         require(_token != address(0), "_token address cannot be 0");
719         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
720         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
721         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
722         emit TransferForeignToken(_token, _contractBalance);
723     }
724 
725     function setIronBankAddress(address _ironBankAddress) external onlyOwner {
726         require(_ironBankAddress != address(0), "address cannot be 0");
727         ironBankAddress = payable(_ironBankAddress);
728         emit UpdatedIronBankAddress(_ironBankAddress);
729     }
730     
731     function setRewardsAddress(address _rewardsAddress) external onlyOwner {
732         require(_rewardsAddress != address(0), "address cannot be 0");
733         rewardsAddress = payable(_rewardsAddress);
734         emit UpdatedRewardsAddress(_rewardsAddress);
735     }
736 
737     // force Swap back if slippage issues.
738     function forceSwapBack() external onlyOwner {
739         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
740         swapping = true;
741         swapBack();
742         swapping = false;
743         emit OwnerForcedSwapBack(block.timestamp);
744     }
745 }