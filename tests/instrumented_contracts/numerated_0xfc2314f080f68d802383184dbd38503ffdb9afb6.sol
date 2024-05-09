1 /**
2 
3 
4 
5  ..  ..  ..  :~?Y5GGGGGGGGGGGPPY7~:.   ..  ..  ..
6 ..  ..    .~JPP5Y?!~^::::::::^~!?YPPPJ!.  ..  ..  
7   ..   .^YGPYY57...:::::::::::...JG5YYPGY~  ..  ..
8 ..   .~PBYJP#@@@?.:::::::::::::.Y@@@@#PJYBG!  ..  
9   . :P#JJB@@@@@@@J.:::::::::::.J@@@@@@@@BJJ#G^  ..
10 .. 7&57G@@@@@@@@@@Y.:::::::::.?@@@@@@@@@@@B75&?   
11   J@?J@@@@@@@@@@@@@5:.::::::.?@@@@@@@@@@@@@@J?@Y .
12  ?@7J@@@@@@@@@@@@@@@P::::::.?@@@@@@@@@@@@@@@@J7@? 
13 ^@Y!@@@@@@@@@@@@@@@@@?.....^B@@@@@@@@@@@@@@@@@!Y@~
14 P&^B@@@@@@@@@@@@@@@G~.:!??!^.!P@@@@@@@@@@@@@@@B^&P
15 &G~@@@@@@@@@@@@@@@P:.7#@@@@&J..J@@@@@@@@@@@@@@@~G@
16 @5~GGGGBBBBBBBBBBB~.:#@@@@@@@^..J555YYYYYYJJJJJ^P@
17 @G:...::::::::::::::.?&@@@@@Y:::...............:G&
18 P&^:::::::::::::::::..:7JJ7^.:.::::::::::::::::^@P
19 ~@5::::::::::::::::.^PGYJJY5B#?.:::::::::::::::5@^
20  ?@7::::::::::::::.7&@@@@@@@@@@5:.::::::::::::?@? 
21   Y@?:::::::::::.:Y@@@@@@@@@@@@@B~.::::::::::?@J  
22 .  ?&5:::::::::.~B@@@@@@@@@@@@@@@&?..::::::^P&7  .
23 ..  ^G#?::.:::.?&@@@@@@@@@@@@@@@@@@P^.:.::J#P^ .. 
24   ..  !GBY~:.:5@@@@@@@@@@@@@@@@@@@@@#~:~YBP~    ..
25 ..  ..  ~5BGJ?5G#&@@@@@@@@@@@@@@&#G5YYGBY^    ..  
26   ..  ..  .!JPPP5YY55PPGGGGPP55YY5PPPJ~.    ..  ..
27 ..  ..  ..    :~7Y5PPGGGGGGGGPP5J7~:     ...  .. 
28 
29 
30 Bull or Bear the question on everyones mind is 
31 
32 ░██╗░░░░░░░██╗███████╗███╗░░██╗  ███╗░░██╗██╗░░░██╗██╗░░██╗███████╗
33 ░██║░░██╗░░██║██╔════╝████╗░██║  ████╗░██║██║░░░██║██║░██╔╝██╔════╝
34 ░╚██╗████╗██╔╝█████╗░░██╔██╗██║  ██╔██╗██║██║░░░██║█████═╝░█████╗░░
35 ░░████╔═████║░██╔══╝░░██║╚████║  ██║╚████║██║░░░██║██╔═██╗░██╔══╝░░
36 ░░╚██╔╝░╚██╔╝░███████╗██║░╚███║  ██║░╚███║╚██████╔╝██║░╚██╗███████╗
37 ░░░╚═╝░░░╚═╝░░╚══════╝╚═╝░░╚══╝  ╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝╚══════╝
38 
39 Telegram: https://t.me/NUKEPORTAL
40 website: http://wennuke.site/
41 Twitter: https://twitter.com/NukeERC20
42 
43 **/
44 
45 
46 // SPDX-License-Identifier: MIT
47 
48 pragma solidity 0.8.17;
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
57         return msg.data;
58     }
59 }
60 
61 library Address {
62     function isContract(address account) internal view returns (bool) {
63         return account.code.length > 0;
64     }
65 
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
74         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
75     }
76 
77     function functionCall(
78         address target,
79         bytes memory data,
80         string memory errorMessage
81     ) internal returns (bytes memory) {
82         return functionCallWithValue(target, data, 0, errorMessage);
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
87      * but also transferring `value` wei to `target`.
88      *
89      * Requirements:
90      *
91      * - the calling contract must have an ETH balance of at least `value`.
92      * - the called Solidity function must be `payable`.
93      *
94      * _Available since v3.1._
95      */
96     function functionCallWithValue(
97         address target,
98         bytes memory data,
99         uint256 value
100     ) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
106      * with `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(
111         address target,
112         bytes memory data,
113         uint256 value,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         (bool success, bytes memory returndata) = target.call{value: value}(data);
118         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
123      * but performing a static call.
124      *
125      * _Available since v3.3._
126      */
127     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
128         return functionStaticCall(target, data, "Address: low-level static call failed");
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
133      * but performing a static call.
134      *
135      * _Available since v3.3._
136      */
137     function functionStaticCall(
138         address target,
139         bytes memory data,
140         string memory errorMessage
141     ) internal view returns (bytes memory) {
142         (bool success, bytes memory returndata) = target.staticcall(data);
143         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a delegate call.
149      *
150      * _Available since v3.4._
151      */
152     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a delegate call.
159      *
160      * _Available since v3.4._
161      */
162     function functionDelegateCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         (bool success, bytes memory returndata) = target.delegatecall(data);
168         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
173      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
174      *
175      * _Available since v4.8._
176      */
177     function verifyCallResultFromTarget(
178         address target,
179         bool success,
180         bytes memory returndata,
181         string memory errorMessage
182     ) internal view returns (bytes memory) {
183         if (success) {
184             if (returndata.length == 0) {
185                 // only check isContract if the call was successful and the return data is empty
186                 // otherwise we already know that it was a contract
187                 require(isContract(target), "Address: call to non-contract");
188             }
189             return returndata;
190         } else {
191             _revert(returndata, errorMessage);
192         }
193     }
194 
195     /**
196      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
197      * revert reason or using the provided one.
198      *
199      * _Available since v4.3._
200      */
201     function verifyCallResult(
202         bool success,
203         bytes memory returndata,
204         string memory errorMessage
205     ) internal pure returns (bytes memory) {
206         if (success) {
207             return returndata;
208         } else {
209             _revert(returndata, errorMessage);
210         }
211     }
212 
213     function _revert(bytes memory returndata, string memory errorMessage) private pure {
214         // Look for revert reason and bubble it up if present
215         if (returndata.length > 0) {
216             // The easiest way to bubble the revert reason is using memory via assembly
217             /// @solidity memory-safe-assembly
218             assembly {
219                 let returndata_size := mload(returndata)
220                 revert(add(32, returndata), returndata_size)
221             }
222         } else {
223             revert(errorMessage);
224         }
225     }
226 }
227 
228 library SafeERC20 {
229     using Address for address;
230 
231     function safeTransfer(
232         IERC20 token,
233         address to,
234         uint256 value
235     ) internal {
236         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
237     }
238 
239     function _callOptionalReturn(IERC20 token, bytes memory data) private {
240         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
241         if (returndata.length > 0) {
242             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
243         }
244     }
245 }
246 
247 interface IERC20 {
248     function totalSupply() external view returns (uint256);
249     function balanceOf(address account) external view returns (uint256);
250     function transfer(address recipient, uint256 amount) external returns (bool);
251     function allowance(address owner, address spender) external view returns (uint256);
252     function approve(address spender, uint256 amount) external returns (bool);
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     event Transfer(address indexed from, address indexed to, uint256 value);
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 interface IERC20Metadata is IERC20 {
260     function name() external view returns (string memory);
261     function symbol() external view returns (string memory);
262     function decimals() external view returns (uint8);
263 }
264 
265 contract ERC20 is Context, IERC20, IERC20Metadata {
266     mapping(address => uint256) private _balances;
267 
268     mapping(address => mapping(address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274     uint8 private _decimals;
275 
276     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
277         _name = name_;
278         _symbol = symbol_;
279         _decimals = decimals_;
280     }
281 
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     function symbol() public view virtual override returns (string memory) {
287         return _symbol;
288     }
289 
290     function decimals() public view virtual override returns (uint8) {
291         return _decimals;
292     }
293 
294     function totalSupply() public view virtual override returns (uint256) {
295         return _totalSupply;
296     }
297 
298     function balanceOf(address account) public view virtual override returns (uint256) {
299         return _balances[account];
300     }
301 
302     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     function allowance(address owner, address spender) public view virtual override returns (uint256) {
308         return _allowances[owner][spender];
309     }
310 
311     function approve(address spender, uint256 amount) public virtual override returns (bool) {
312         _approve(_msgSender(), spender, amount);
313         return true;
314     }
315 
316     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
317         _transfer(sender, recipient, amount);
318 
319         uint256 currentAllowance = _allowances[sender][_msgSender()];
320         if(currentAllowance != type(uint256).max){
321             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
322             unchecked {
323                 _approve(sender, _msgSender(), currentAllowance - amount);
324             }
325         }
326 
327         return true;
328     }
329 
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
332         return true;
333     }
334 
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         uint256 currentAllowance = _allowances[_msgSender()][spender];
337         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
338         unchecked {
339             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
340         }
341 
342         return true;
343     }
344 
345     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         uint256 senderBalance = _balances[sender];
350         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
351         unchecked {
352             _balances[sender] = senderBalance - amount;
353         }
354         _balances[recipient] += amount;
355 
356         emit Transfer(sender, recipient, amount);
357     }
358 
359     function _createInitialSupply(address account, uint256 amount) internal virtual {
360         require(account != address(0), "ERC20: mint to the zero address");
361 
362         _totalSupply += amount;
363         _balances[account] += amount;
364         emit Transfer(address(0), account, amount);
365     }
366 
367     function _approve(address owner, address spender, uint256 amount) internal virtual {
368         require(owner != address(0), "ERC20: approve from the zero address");
369         require(spender != address(0), "ERC20: approve to the zero address");
370 
371         _allowances[owner][spender] = amount;
372         emit Approval(owner, spender, amount);
373     }
374 }
375 
376 contract Ownable is Context {
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380     
381     constructor () {
382         address msgSender = _msgSender();
383         _owner = msgSender;
384         emit OwnershipTransferred(address(0), msgSender);
385     }
386 
387     function owner() public view returns (address) {
388         return _owner;
389     }
390 
391     modifier onlyOwner() {
392         require(_owner == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396     function renounceOwnership() external virtual onlyOwner {
397         emit OwnershipTransferred(_owner, address(0));
398         _owner = address(0);
399     }
400 
401     function transferOwnership(address newOwner) public virtual onlyOwner {
402         require(newOwner != address(0), "Ownable: new owner is the zero address");
403         emit OwnershipTransferred(_owner, newOwner);
404         _owner = newOwner;
405     }
406 }
407 
408 interface ILpPair {
409     function sync() external;
410 }
411 
412 interface IDexRouter {
413     function factory() external pure returns (address);
414     function WETH() external pure returns (address);
415     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
416     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
417     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
418     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
419     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
420     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
421 }
422 
423 interface IDexFactory {
424     function createPair(address tokenA, address tokenB) external returns (address pair);
425 }
426 
427 
428 contract WenNuke is ERC20, Ownable {
429 
430     uint256 public maxBuyAmount;
431     uint256 public maxWalletAmount; 
432 
433 
434 
435     IDexRouter public immutable dexRouter;
436     address public immutable lpPair;
437 
438     bool private swapping;
439     uint256 public swapTokensAtAmount;
440 
441     address public marketingAddress;
442 
443     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
444 
445     bool public limitsInEffect = true;
446     bool public tradingActive = false;
447     bool public swapEnabled = false;
448     
449      // Anti-bot and anti-whale mappings and variables
450     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
451     bool public transferDelayEnabled = true;
452 
453     uint256 public buyTotalFees;
454     uint256 public buyTaxFee;
455     uint256 public buyLiquidityFee;
456 
457     uint256 public sellTotalFees;
458     uint256 public sellTaxFee;
459     uint256 public sellLiquidityFee;
460 
461     uint256 public tokensForMarket;
462     uint256 public tokensForLiquidity;
463     
464     mapping (address => bool) private _isExcludedFromFees;
465     mapping (address => bool) public _isExcludedMaxTransactionAmount;
466 
467     mapping (address => bool) public automatedMarketMakerPairs;
468 
469     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
470     event EnabledTrading();
471     event RemovedLimits();
472     event ExcludeFromFees(address indexed account, bool isExcluded);
473     event UpdatedMaxBuyAmount(uint256 newAmount);
474     event UpdateMaxWalletAmount(uint256 newAmount);
475     event UpdatedBuyFee(uint256 newAmount);
476     event UpdatedSellFee(uint256 newAmount);
477     event UpdatedMarketAddress(address indexed newWallet);
478     event MaxTransactionExclusion(address _address, bool excluded);
479     event OwnerForcedSwapBack(uint256 timestamp);
480     event TransferForeignToken(address token, uint256 amount);
481     event RemovedTokenHoldingsRequiredToBuy();
482     event TransferDelayDisabled();
483     event ReuppedApprovals();
484     event SwapTokensAtAmountUpdated(uint256 newAmount);
485 
486     constructor() ERC20("Wen", "Nuke", 18){
487         address newOwner = msg.sender; // can leave alone if owner is deployer.
488 
489         address _dexRouter;
490 
491         // automatically detect router/desired stablecoin
492         if(block.chainid == 1){
493             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
494         } else if(block.chainid == 5){
495             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
496         } else if(block.chainid == 56){
497             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
498         } else if(block.chainid == 97){
499             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
500         } else {
501             revert("Chain not configured");
502         }
503 
504         // initialize router
505         dexRouter = IDexRouter(_dexRouter);
506 
507         // create pair
508         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
509         setAutomatedMarketMakerPair(address(lpPair), true);
510 
511         uint256 totalSupply = 1 * 1e9 * (10**decimals());
512        
513         
514         maxBuyAmount = totalSupply * 5 / 1000;
515         swapTokensAtAmount = totalSupply * 25 / 100000;
516         maxWalletAmount = totalSupply * 2 / 100; // 2% max wallet 
517 
518         buyTaxFee = 25;
519         buyLiquidityFee = 5;
520 
521         buyTotalFees = buyTaxFee+ buyLiquidityFee;
522 
523         sellTaxFee = 25;
524         sellLiquidityFee = 5;
525         sellTotalFees = sellTaxFee + sellLiquidityFee;
526 
527         // update these!
528         marketingAddress = address(0xc1B52F221fe2462790eD2CEF990cb0B185d14cAC);
529 
530         _excludeFromMaxTransaction(newOwner, true);
531         _excludeFromMaxTransaction(address(dexRouter), true);
532         _excludeFromMaxTransaction(address(this), true);
533         _excludeFromMaxTransaction(address(0xdead), true);
534         _excludeFromMaxTransaction(address(marketingAddress), true);
535 
536         excludeFromFees(newOwner, true);
537         excludeFromFees(address(dexRouter), true);
538         excludeFromFees(address(this), true);
539         excludeFromFees(address(0xdead), true);
540         excludeFromFees(address(marketingAddress), true);
541 
542         _createInitialSupply(address(newOwner), totalSupply);
543         transferOwnership(newOwner);
544 
545         _approve(address(this), address(dexRouter), type(uint256).max);
546         _approve(msg.sender, address(dexRouter), totalSupply);
547     }
548 
549     receive() external payable {
550     }
551 
552     function enableTrading() external onlyOwner {
553         require(!tradingActive, "Trading is already active, cannot relaunch.");
554         tradingActive = true;
555         swapEnabled = true;
556         tradingActiveBlock = block.number;
557         emit EnabledTrading();
558     }
559 
560     // remove limits after token is stable
561     function removeLimits() external onlyOwner {
562         limitsInEffect = false;
563         transferDelayEnabled = false;
564         maxBuyAmount = totalSupply();
565         maxWalletAmount = totalSupply();
566         emit RemovedLimits();
567     }
568 
569     // disable Transfer delay - cannot be reenabled
570     function disableTransferDelay() external onlyOwner {
571         transferDelayEnabled = false;
572         emit TransferDelayDisabled();
573     }
574     
575     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
576         require(newNum >= (totalSupply() * 1 / 10000)/(10**decimals()), "Cannot set max buy amount lower than 0.01%");
577         maxBuyAmount = newNum * (10**decimals());
578         emit UpdatedMaxBuyAmount(maxBuyAmount);
579     }
580 
581     function updateMaxWalletAmount(uint256 newWalletNum) external onlyOwner {
582         require(newWalletNum >= (totalSupply() * 1 / 10000)/(10**decimals()), "Cannot set wallet amount lower than 0.01%");
583         maxWalletAmount = newWalletNum * (10**decimals());
584         emit UpdateMaxWalletAmount(maxWalletAmount);
585     }
586 
587 
588     // change the minimum amount of tokens to sell from fees
589     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
590   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
591   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
592   	    swapTokensAtAmount = newAmount;
593         emit SwapTokensAtAmountUpdated(newAmount);
594   	}
595     
596     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
597         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
598         emit MaxTransactionExclusion(updAds, isExcluded);
599     }
600 
601     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
602         if(!isEx){
603             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
604         }
605         _isExcludedMaxTransactionAmount[updAds] = isEx;
606         emit MaxTransactionExclusion(updAds, isEx);
607     }
608 
609     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
610         require(pair != lpPair || value, "The pair cannot be removed from automatedMarketMakerPairs");
611         automatedMarketMakerPairs[pair] = value;
612         _excludeFromMaxTransaction(pair, value);
613         emit SetAutomatedMarketMakerPair(pair, value);
614     }
615 
616     function updateBuyFees(uint256 _taxFee, uint256 _liquidityFee) external onlyOwner {
617         buyTaxFee = _taxFee;
618         buyLiquidityFee = _liquidityFee;
619         buyTotalFees = buyTaxFee + buyLiquidityFee;
620         require(buyTotalFees <= 80, "Must keep buy fees at 80% or less");
621         emit UpdatedBuyFee(buyTotalFees);
622     }
623 
624     function updateSellFees(uint256 _taxFee, uint256 _liquidityFee) external onlyOwner {
625         sellTaxFee = _taxFee;
626         sellLiquidityFee = _liquidityFee;
627         sellTotalFees = sellTaxFee + sellLiquidityFee;
628         require(sellTotalFees <= 80, "Must keep sell fees at 80% or less");
629         emit UpdatedSellFee(sellTotalFees);
630     }
631 
632     function excludeFromFees(address account, bool excluded) public onlyOwner {
633         _isExcludedFromFees[account] = excluded;
634         emit ExcludeFromFees(account, excluded);
635     }
636 
637     function _transfer(address from, address to, uint256 amount) internal override {
638 
639         require(from != address(0), "ERC20: transfer from the zero address");
640         require(to != address(0), "ERC20: transfer to the zero address");
641         
642         if(amount == 0){
643             super._transfer(from, to, 0);
644             return;
645         }
646 
647         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
648             super._transfer(from, to, amount);
649             return;
650         }
651         
652         if(!tradingActive){
653             revert("Trading is not active.");
654         }        
655         
656         if(limitsInEffect){
657             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
658             if (transferDelayEnabled){
659                 if (to != address(dexRouter) && to != address(lpPair)){
660                     require(_holderLastTransferBlock[tx.origin] + 1 < block.number && _holderLastTransferBlock[to] + 1 < block.number, "_transfer:: Transfer Delay enabled.  Try again later.");
661                     _holderLastTransferBlock[tx.origin] = block.number;
662                     _holderLastTransferBlock[to] = block.number;
663                 }
664             }
665                 
666             //when buy
667             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
668                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
669                 require(balanceOf(to) + amount <= maxWalletAmount, "Exceeds the maxWalletSize.");
670             }    else if (!_isExcludedMaxTransactionAmount[to]){
671                 require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
672                 }   
673         }
674 
675          
676 
677 
678         
679 
680         if(balanceOf(address(this)) > swapTokensAtAmount && swapEnabled && !swapping && automatedMarketMakerPairs[to]) {
681             swapping = true;
682             swapBack();
683             swapping = false;
684         }
685         
686         uint256 fees = 0;
687 
688         // on sell
689         if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
690             fees = amount * sellTotalFees / 100;
691             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
692             tokensForMarket += fees * sellTaxFee / sellTotalFees;
693         }
694 
695         // on buy
696         else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
697             fees = amount * buyTotalFees / 100;
698             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
699             tokensForMarket += fees * buyTaxFee / buyTotalFees;
700         }
701         
702         if(fees > 0){    
703             super._transfer(from, address(this), fees);
704             amount -= fees;
705         }
706         
707         super._transfer(from, to, amount);
708     }
709 
710     function swapTokensForEth(uint256 tokenAmount) private {
711 
712         // generate the uniswap pair path of token -> weth
713         address[] memory path = new address[](2);
714         path[0] = address(this);
715         path[1] = dexRouter.WETH();
716 
717         // make the swap
718         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
719     }
720 
721     function swapBack() private {
722         bool success;
723 
724         uint256 contractBalance = balanceOf(address(this));
725         uint256 totalTokensToSwap = tokensForMarket + tokensForLiquidity;
726         
727         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
728 
729         if(contractBalance > swapTokensAtAmount * 60){
730             contractBalance = swapTokensAtAmount * 60;
731         }
732 
733         if(tokensForLiquidity > 0){
734             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
735             super._transfer(address(this), lpPair, liquidityTokens);
736             try ILpPair(lpPair).sync(){} catch {}
737             contractBalance -= liquidityTokens;
738             totalTokensToSwap -= tokensForLiquidity;
739         }
740 
741         swapTokensForEth(contractBalance);
742         
743         uint256 ethBalance = address(this).balance;
744 
745         uint256 ethForMarketBank = ethBalance * tokensForMarket / totalTokensToSwap;
746 
747         tokensForMarket = 0;
748         tokensForLiquidity = 0;
749 
750         if(ethForMarketBank > 0){
751             (success, ) = marketingAddress.call{value: ethForMarketBank}("");
752         }
753 
754       
755     }
756 
757     function sendEth() external onlyOwner {
758         bool success;
759         (success, ) = msg.sender.call{value: address(this).balance}("");
760         require(success, "withdraw unsuccessful");
761     }
762 
763     function transferForeignToken(address _token, address _to) external onlyOwner {
764         require(_token != address(0), "_token address cannot be 0");
765         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
766         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
767         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
768         emit TransferForeignToken(_token, _contractBalance);
769     }
770 
771     function setMarketingAddress(address _marketAddress) external onlyOwner {
772         require(_marketAddress != address(0), "address cannot be 0");
773         marketingAddress = payable(_marketAddress);
774         emit UpdatedMarketAddress(_marketAddress);
775     }
776     
777 
778     // force Swap back if slippage issues.
779     function forceSwapBack() external onlyOwner {
780         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
781         swapping = true;
782         swapBack();
783         swapping = false;
784         emit OwnerForcedSwapBack(block.timestamp);
785     }
786 }