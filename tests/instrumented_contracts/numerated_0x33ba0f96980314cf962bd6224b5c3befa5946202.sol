1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.21;
3 
4 interface IdexFactory {
5     function createPair(address tokenA, address tokenB) external returns (address pair);
6 }
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function decimals() external view returns (uint8);
11     function symbol() external view returns (string memory);
12     function name() external view returns (string memory);
13     function getOwner() external view returns (address);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address _owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 interface In {
24     //events
25     event SwapThresholdChange(uint threshold);
26     event OverLiquifiedThresholdChange(uint threshold);
27     event OnSetTaxes(
28         uint buy, 
29         uint sell, 
30         uint transfer_, 
31         uint ins, 
32         uint b3_1, 
33         uint b3_2
34     );
35     event ManualSwapChange(bool status);
36     event MaxWalletBalanceUpdated(uint256 percent);
37     event MaxTransactionAmountUpdated(uint256 percent);
38     event ExcludeAccount(address indexed account, bool indexed exclude);
39     event ExcludeFromWalletLimits(address indexed account, bool indexed exclude);
40     event ExcludeFromTransactionLimits(address indexed account, bool indexed exclude);
41     event OwnerSwap();
42     event OnEnableTrading();
43     event OnProlongLPLock(uint UnlockTimestamp);
44     event OnReleaseLP();
45     event RecoverETH();
46     event NewPairSet(address Pair, bool Add);
47     event LimitTo20PercentLP();
48     event NewRouterSet(address _newdex);
49     event NewFeeWalletsSet(
50         address indexed NewInsWallet, 
51         address indexed NewB3_1Wallet, 
52         address indexed NewB3_2Wallet
53                     );
54     event RecoverTokens(uint256 amount);
55     event TokensAirdroped(address indexed sender, uint256 total, uint256 amount);
56 }
57 
58 interface IdexRouter {
59     function addLiquidityETH(
60         address token,
61         uint amountTokenDesired,
62         uint amountTokenMin,
63         uint amountETHMin,
64         address to,
65         uint deadline
66     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
67     function swapExactTokensForETHSupportingFeeOnTransferTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external;
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77 }
78 
79 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
80 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
103 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         _checkOwner();
134         _;
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view virtual returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if the sender is not the owner.
146      */
147     function _checkOwner() internal view virtual {
148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         _transferOwnership(address(0));
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Internal function without access restriction.
174      */
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 contract N is IERC20, Ownable, In {
183     mapping (address => uint) private _balances;
184     mapping (address => mapping (address => uint)) private _allowances;
185     mapping(address => bool) private excludedFromWalletLimits;
186     mapping(address => bool) private excludedFromTransactionLimits;
187     mapping(address => bool) public excludedFromFees;
188 
189     mapping(address=>bool) public isPair;
190 
191     //strings
192     string private constant _name = 'nsurance';
193     string private constant _symbol = 'n';
194 
195     //uints
196     uint private constant InitialSupply= 1_000_000_000_000 * 10**_decimals;
197 
198     //Tax by divisor of MAXTAXDENOMINATOR
199     uint public buyTax = 4500;
200     uint public sellTax = 4500;
201     uint public transferTax = 100;
202 
203     //insPct+b3_1Pct+b3_2Pct must equal TAX_DENOMINATOR
204     uint[] private taxStructure = [3500, 3500, 3000, 2500, 1500, 1000, 400];
205     uint public insPct=3333;
206     uint public b3_1Pct=3334;
207     uint public b3_2Pct=3333;
208     uint constant TAX_DENOMINATOR=10000;
209     uint constant MAXBUYTAXDENOMINATOR=1000;
210     uint constant MAXTRANSFERTAXDENOMINATOR=1000;
211     uint constant MAXSELLTAXDENOMINATOR=1000;
212     uint public currentTaxIndex = 0;
213     //swapTreshold dynamic by LP pair balance
214     uint public swapTreshold=4;
215     uint private LaunchBlock;
216     uint public tokensForInsurance;
217     uint public tokensForB3_1;
218     uint public tokensForB3_2;
219     uint8 private constant _decimals = 18;
220     uint256 public maxTransactionAmount;
221     uint256 public maxWalletBalance;
222 
223     IdexRouter private  _dexRouter;
224 
225     //addresses
226     address private dexRouter;
227     address private _dexPairAddress;
228     address constant deadWallet = 0x000000000000000000000000000000000000dEaD;
229     address private insuranceWallet;
230     address private b3_1Wallet;
231     address private b3_2Wallet;
232 
233     //bools
234     bool public _b3_2tokenrcvr;
235     bool private _isSwappingContractModifier;
236     bool public manualSwap;
237 
238     //modifiers
239     modifier lockTheSwap {
240         _isSwappingContractModifier = true;
241         _;
242         _isSwappingContractModifier = false;
243     }
244 
245     constructor (
246         address _DexRouter, 
247         address _insWallet, 
248         address _b3_1Wallet, 
249         address _b3_2Wallet
250     ) {
251         // Assigning parameters to state variables
252         insuranceWallet = _insWallet;
253         b3_1Wallet = _b3_1Wallet;
254         b3_2Wallet = _b3_2Wallet;
255         dexRouter = _DexRouter;
256 
257         // Hardcoded addresses for allocations
258         address[5] memory initialAddresses = [
259             0xbe25b92099D428F959549cBE8deab0e20a82918d,
260             0xC9E7c47bF63c71452f50EAA1a69545a170278998,
261             0x85aE03A5846324F053BD07e28D7c14B75e90E26D,
262             0x3Ec897771308c83f3a442ab275a1F0Fec82e365a,
263             0x44762b347bE037d5C0f098530FdfD5370f19E471
264         ];
265 
266         uint[5] memory initialAmounts = [
267             36_666_666_667 * 10**_decimals,
268             25_000_000_000 * 10**_decimals,
269             36_666_666_667 * 10**_decimals,
270             93_958_333_333 * 10**_decimals,
271             146_666_666_667 * 10**_decimals
272         ];
273 
274         SetInitialBalances(initialAddresses, initialAmounts);
275 
276         // Setting exclusions
277         SetExclusions(
278             [msg.sender, dexRouter, address(this), 
279             0xbe25b92099D428F959549cBE8deab0e20a82918d,
280             0xC9E7c47bF63c71452f50EAA1a69545a170278998,
281             0x85aE03A5846324F053BD07e28D7c14B75e90E26D,
282             0x3Ec897771308c83f3a442ab275a1F0Fec82e365a,
283             0x44762b347bE037d5C0f098530FdfD5370f19E471,
284             0x5E1EcF03D1D776CAff4f47150610519dFb014161,
285             0xA576463273E4A459B39a518be7fc79EbecF6B7c7],
286             [msg.sender, deadWallet, address(this), 
287             0xbe25b92099D428F959549cBE8deab0e20a82918d,
288             0xC9E7c47bF63c71452f50EAA1a69545a170278998,
289             0x85aE03A5846324F053BD07e28D7c14B75e90E26D,
290             0x3Ec897771308c83f3a442ab275a1F0Fec82e365a,
291             0x44762b347bE037d5C0f098530FdfD5370f19E471,
292             0x5E1EcF03D1D776CAff4f47150610519dFb014161,
293             0xA576463273E4A459B39a518be7fc79EbecF6B7c7],
294             [msg.sender, deadWallet, address(this), 
295             0xbe25b92099D428F959549cBE8deab0e20a82918d,
296             0xC9E7c47bF63c71452f50EAA1a69545a170278998,
297             0x85aE03A5846324F053BD07e28D7c14B75e90E26D,
298             0x3Ec897771308c83f3a442ab275a1F0Fec82e365a,
299             0x44762b347bE037d5C0f098530FdfD5370f19E471,
300             0x5E1EcF03D1D776CAff4f47150610519dFb014161,
301             0xA576463273E4A459B39a518be7fc79EbecF6B7c7]
302         );
303     }
304 
305     function setB3_2tokenRCVR (bool yesNo) external onlyOwner {
306         _b3_2tokenrcvr = yesNo;
307     }
308 
309     /**
310     * @notice Set Initial Balances
311     * @dev This function is for set initial balances.
312     * @param addresses The array of address to be set initial balances.
313     * @param amounts The array of amount to be set initial balances.
314      */
315     function SetInitialBalances(address[5] memory addresses, uint[5] memory amounts) internal {
316         require(addresses.length == amounts.length, "Mismatched arrays length");
317         uint256 totalAllocatedAmount = 0;
318         for (uint256 i = 0; i < addresses.length; i++) {
319             _balances[addresses[i]] = amounts[i];
320             totalAllocatedAmount += amounts[i];
321             emit Transfer(address(0), addresses[i], amounts[i]);
322         }
323         uint contractBalance = 50_000_000_000 * 10**_decimals;
324         _balances[address(this)] = contractBalance;
325         emit Transfer(address(0), address(this), contractBalance);
326         uint256 deployerBalance = InitialSupply - totalAllocatedAmount - contractBalance;
327         _balances[msg.sender] = deployerBalance;
328         emit Transfer(address(0), msg.sender, deployerBalance);
329     }
330 
331     /** 
332     * @notice Set Exclusions
333     * @dev This function is for set exclusions.
334     * @param feeExclusions The array of address to be excluded from fees.
335     * @param walletLimitExclusions The array of address to be excluded from wallet limits.
336     * @param transactionLimitExclusions The array of address to be excluded from transaction limits.
337      */
338     function SetExclusions(
339         address[10] memory feeExclusions, 
340         address[10] memory walletLimitExclusions, 
341         address[10] memory transactionLimitExclusions
342     ) internal {
343         for (uint256 i = 0; i < feeExclusions.length; i++) {
344             excludedFromFees[feeExclusions[i]] = true;
345         }
346         for (uint256 i = 0; i < walletLimitExclusions.length; i++) {
347             excludedFromWalletLimits[walletLimitExclusions[i]] = true;
348         }
349         for (uint256 i = 0; i < transactionLimitExclusions.length; i++) {
350             excludedFromTransactionLimits[transactionLimitExclusions[i]] = true;
351         }
352     }
353 
354     /**
355      * @dev Decrease the tax rates for both buy and sell operations to the next lower value in the structure
356      */
357     function decreaseTaxRate() external payable onlyOwner {
358         require(currentTaxIndex < taxStructure.length - 1, "Already at the lowest tax rate");
359 
360         // Move to the next lower tax rate in the tax structure
361         currentTaxIndex++;
362 
363         // Update the buy and sell tax rates
364         buyTax = taxStructure[currentTaxIndex];
365         sellTax = taxStructure[currentTaxIndex];
366     }
367 
368     /**
369     * @notice Internal function to transfer tokens from one address to another.
370      */
371     function _transfer(address sender, address recipient, uint amount) internal {
372         require(sender != address(0), "Transfer from zero");
373         require(recipient != address(0), "Transfer to zero");
374 
375         if(excludedFromFees[sender] || excludedFromFees[recipient])
376             _feelessTransfer(sender, recipient, amount);
377 
378         else {
379             require(LaunchBlock>0,"trading not yet enabled");
380             _taxedTransfer(sender,recipient,amount);
381         }
382     }
383 
384     /**
385     * @notice Transfer amount of tokens with fees.
386     * @param sender The address of user to send tokens.
387     * @param recipient The address of user to be recieved tokens.
388     * @param amount The token amount to transfer.
389     */
390     function _taxedTransfer(address sender, address recipient, uint amount) internal {
391         uint senderBalance = _balances[sender];
392         require(senderBalance >= amount, "Transfer exceeds balance");
393         bool excludedFromWalletLimitsAccount = excludedFromWalletLimits[sender] || excludedFromWalletLimits[recipient];
394         bool excludedFromTXNLimitsAccount = excludedFromTransactionLimits[sender] || excludedFromTransactionLimits[recipient];
395         if (
396             isPair[sender] &&
397             !excludedFromWalletLimitsAccount
398         ) {
399             if(!excludedFromTXNLimitsAccount){
400                 require(
401                 amount <= maxTransactionAmount,
402                 "Transfer amount exceeds the maxTxAmount."
403                 );
404             }
405             uint256 contractBalanceRecepient = balanceOf(recipient);
406             require(
407                 contractBalanceRecepient + amount <= maxWalletBalance,
408                 "Exceeds maximum wallet token amount."
409             );
410         } else if (
411             isPair[recipient] &&
412             !excludedFromTXNLimitsAccount
413         ) {
414             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
415         }
416 
417         bool isBuy=isPair[sender];
418         bool isSell=isPair[recipient];
419         uint tax;
420 
421         if(isSell) {  // in case that sender is dex token pair.
422             uint SellTaxDuration=10;
423             if(block.number<LaunchBlock+SellTaxDuration){
424                 tax=_getStartTax();
425             } else tax=sellTax;
426         }
427         else if(isBuy) {    // in case that recieve is dex token pair.
428             uint BuyTaxDuration=10;
429             if(block.number<LaunchBlock+BuyTaxDuration){
430                 tax=_getStartTax();
431             } else tax=buyTax;
432         } else { 
433             uint256 contractBalanceRecepient = balanceOf(recipient);
434             if(!excludedFromWalletLimitsAccount){
435             require(
436                 contractBalanceRecepient + amount <= maxWalletBalance,
437                 "Exceeds maximum wallet token amount."
438                 );
439             }
440             uint TransferTaxDuration=10;
441             if(block.number<LaunchBlock+TransferTaxDuration){
442                 tax=_getStartTax();
443             } else tax=transferTax;
444         }
445 
446         if((sender!=_dexPairAddress)&&(!manualSwap)&&(!_isSwappingContractModifier))
447         _swapContractToken(false);
448         uint contractToken=_calculateFee(amount, tax, insPct+b3_1Pct+b3_2Pct);
449         tokensForInsurance+=_calculateFee(amount, tax, insPct);
450         tokensForB3_1+=_calculateFee(amount, tax, b3_1Pct);
451         tokensForB3_2+=_calculateFee(amount, tax, b3_2Pct);
452         uint taxedAmount=amount-contractToken;
453 
454         _balances[sender]-=amount;
455         _balances[address(this)] += contractToken;
456         _balances[recipient]+=taxedAmount;
457         
458         emit Transfer(sender,recipient,taxedAmount);
459     }
460 
461     /**
462     * @notice Provides start tax to transfer function.
463     * @return The tax to calculate fee with.
464     */
465     function _getStartTax() internal pure returns (uint){
466         uint startTax=9000;
467         return startTax;
468     }
469 
470     /**
471     * @notice Calculates fee based of set amounts
472     * @param amount The amount to calculate fee on
473     * @param tax The tax to calculate fee with
474     * @param taxPercent The tax percent to calculate fee with
475     */
476     function _calculateFee(uint amount, uint tax, uint taxPercent) internal pure returns (uint) {
477         return (amount*tax*taxPercent) / (TAX_DENOMINATOR*TAX_DENOMINATOR);
478     }
479 
480     /**
481     * @notice Transfer amount of tokens without fees.
482     * @dev In feelessTransfer, there isn't limit as well.
483     * @param sender The address of user to send tokens.
484     * @param recipient The address of user to be recieveid tokens.
485     * @param amount The token amount to transfer.
486     */
487     function _feelessTransfer(address sender, address recipient, uint amount) internal {
488         uint senderBalance = _balances[sender];
489         require(senderBalance >= amount, "Transfer exceeds balance");
490         _balances[sender]-=amount;
491         _balances[recipient]+=amount;
492         emit Transfer(sender,recipient,amount);
493     }
494 
495     /**
496     * @notice Swap tokens for eth.
497     * @dev This function is for swap tokens for eth.
498     * @param newSwapTresholdPermille Set the swap % of LP pair holdings.
499      */
500     function setSwapTreshold(uint newSwapTresholdPermille) external payable onlyOwner{
501         require(newSwapTresholdPermille<=10);//MaxTreshold= 1%
502         swapTreshold=newSwapTresholdPermille;
503         emit SwapThresholdChange(newSwapTresholdPermille);
504     }
505 
506     /**
507     * @notice Set the current taxes. ins+b3_1+b3_2 must equal TAX_DENOMINATOR. 
508     * @notice buy must be less than MAXBUYTAXDENOMINATOR.
509     * @notice sell must be less than MAXSELLTAXDENOMINATOR.
510     * @notice transfer_ must be less than MAXTRANSFERTAXDENOMINATOR.
511     * @dev This function is for set the current taxes.
512     * @param buy The buy tax.
513     * @param sell The sell tax.
514     * @param transfer_ The transfer tax.
515     * @param ins The insurance tax.
516     * @param b3_1 The b3_1 tax.
517     * @param b3_2 The b3_2 tax.
518      */
519     function SetTaxes(
520         uint buy, 
521         uint sell, 
522         uint transfer_, 
523         uint ins, 
524         uint b3_1, 
525         uint b3_2
526     ) external payable onlyOwner{
527         require(
528             buy<=MAXBUYTAXDENOMINATOR &&
529             sell<=MAXSELLTAXDENOMINATOR &&
530             transfer_<=MAXTRANSFERTAXDENOMINATOR,
531             "Tax exceeds maxTax"
532         );
533         require(
534             ins+b3_1+b3_2==TAX_DENOMINATOR,
535             "Taxes don't add up to denominator"
536         );
537 
538         buyTax=buy;
539         sellTax=sell;
540         transferTax=transfer_;
541         insPct=ins;
542         b3_1Pct=b3_1;
543         b3_2Pct=b3_2;
544         emit OnSetTaxes(buy, sell, transfer_, ins, b3_1, b3_2);
545     }
546 
547     /**
548      * @dev Swaps contract tokens based on various parameters.
549      * @param ignoreLimits Whether to ignore the token swap limits.
550      */
551   function _swapContractToken(bool ignoreLimits) internal lockTheSwap {
552         uint contractBalance = _balances[address(this)];
553         uint totalTax = insPct + b3_1Pct + b3_2Pct;
554         uint tokensToSwap = (_balances[_dexPairAddress] * swapTreshold) / 1000;
555 
556         if (totalTax == 0) return;
557 
558         if (ignoreLimits) {
559             tokensToSwap = _balances[address(this)];
560         } else if (contractBalance < tokensToSwap) {
561             return;
562         }
563 
564         uint initialETHBalance = address(this).balance;
565 
566         _swapTokenForETH(tokensToSwap);
567 
568         uint newETH = address(this).balance - initialETHBalance;
569         uint ethBalance = newETH;
570 
571         uint tokensForThisInsurance = (tokensToSwap * insPct) / totalTax;
572         uint tokensForThisB3_1 = (tokensToSwap * b3_1Pct) / totalTax;
573         uint tokensForThisB3_2 = (tokensToSwap * b3_2Pct) / totalTax;
574         uint ethForInsurance = (ethBalance * tokensForThisInsurance) / tokensToSwap;
575         uint ethForB3_1 = (ethBalance * tokensForThisB3_1) / tokensToSwap;
576         uint ethForB3_2 = (ethBalance * tokensForThisB3_2) / tokensToSwap;
577 
578         if (tokensForThisInsurance != 0) {
579             (bool sent,) = insuranceWallet.call{value: ethForInsurance}("");
580             require(sent, "Failed to send ETH to Insurance wallet");
581             tokensForInsurance -= tokensForThisInsurance;
582         }
583 
584         if (tokensForThisB3_1 != 0) {
585             (bool sent,) = b3_1Wallet.call{value: ethForB3_1}("");
586             require(sent, "Failed to send ETH to B3_1 wallet");
587             tokensForB3_1 -= tokensForThisB3_1;
588         }
589 
590         if (tokensForThisB3_2 != 0) {
591             if (_b3_2tokenrcvr) {
592                 _balances[b3_2Wallet] += tokensForThisB3_2;
593                 tokensForB3_2 -= tokensForThisB3_2;
594                 emit Transfer(address(this), b3_2Wallet, tokensForThisB3_2);
595             } else {
596                 (bool sent,) = b3_2Wallet.call{value: ethForB3_2}("");
597                 require(sent, "Failed to send ETH to B3_2 wallet");
598                 tokensForB3_2 -= tokensForThisB3_2;
599             }
600         }
601     }
602 
603     /**
604     * @notice Swap tokens for eth.
605     * @dev This function is for swap tokens for eth.
606     * @param amount The token amount to swap.
607     */
608     function _swapTokenForETH(uint amount) private {
609         _approve(address(this), address(_dexRouter), amount);
610         address[] memory path = new address[](2);
611         path[0] = address(this);
612         path[1] = _dexRouter.WETH();
613 
614         try _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
615             amount,
616             0,
617             path,
618             address(this),
619             block.timestamp
620         ){}
621         catch{}
622     }
623 
624     /**
625     * @notice Add initial liquidity to dex.
626     * @dev This function is for add liquidity to dex.
627      */
628     function _addInitLiquidity() private {
629         uint tokenAmount = balanceOf(address(this));
630         _approve(address(this), address(_dexRouter), tokenAmount);
631         _dexRouter.addLiquidityETH{value: address(this).balance}(
632             address(this),
633             tokenAmount,
634             0,
635             0,
636             owner(),
637             block.timestamp
638         );
639     }
640 
641     /**
642     * @notice Get Burned tokens.
643     * @dev This function is for get burned tokens.
644     */
645     function getBurnedTokens() public view returns(uint){
646         return _balances[address(0xdead)];
647     }
648 
649     /**
650     * @notice Get circulating supply.
651     * @dev This function is for get circulating supply.
652      */
653     function getCirculatingSupply() public view returns(uint){
654         return InitialSupply-_balances[address(0xdead)];
655     }
656 
657     /**
658     * @notice Set the current Pair.
659     * @dev This function is for set the current Pair.
660     * @param Pair The pair address.
661     * @param Add The status of add or remove.
662      */
663     function SetPair(address Pair, bool Add) internal {
664         require(Pair!=_dexPairAddress,"can't readd pair");
665         require(Pair != address(0),"Address should not be 0");
666         isPair[Pair]=Add;
667         emit NewPairSet(Pair,Add);
668     }
669 
670     /**
671     * @notice Add a pair.
672     * @dev This function is for add a pair.
673     * @param Pair The pair address.
674      */
675     function AddPair(address Pair) external payable onlyOwner{
676         SetPair(Pair,true);
677     }
678 
679     /**
680     * @notice Add a pair.
681     * @dev This function is for add a pair.
682     * @param Pair The pair address.
683      */
684     function RemovePair(address Pair) external payable onlyOwner{
685         SetPair(Pair,false);
686     }
687 
688     /**
689     * @notice Set Manual Swap Mode
690     * @dev This function is for set manual swap mode.
691     * @param manual The status of manual swap mode.
692      */
693     function SwitchManualSwap(bool manual) external payable onlyOwner{
694         manualSwap=manual;
695         emit ManualSwapChange(manual);
696     }
697 
698     /**
699     * @notice Swap contract tokens.
700     * @dev This function is for swap contract tokens.
701     * @param all The status of swap all tokens in contract.
702      */
703     function SwapContractToken(bool all) external payable onlyOwner{
704         _swapContractToken(all);
705         emit OwnerSwap();
706     }
707 
708     /**
709     * @notice Set a new router address
710     * @dev This function is for set a new router address.
711     * @param _newdex The new router address.
712      */
713     function SetNewRouter(address _newdex) external payable onlyOwner{
714         require(_newdex != address(0),"Address should not be 0");
715         require(_newdex != dexRouter,"Address is same");
716         dexRouter = _newdex;
717         emit NewRouterSet(_newdex);
718     }
719 
720     /**
721     * @notice Set new tax receiver wallets.
722     * @dev This function is for set new tax receiver wallets.
723     * @param NewInsWallet The new insurance wallet address.
724     * @param NewB3_1Wallet The new b3_1 wallet address.
725     * @param NewB3_2Wallet The new b3_2 wallet address.
726      */
727     function SetFeeWallets(
728         address NewInsWallet, 
729         address NewB3_1Wallet, 
730         address NewB3_2Wallet
731     ) external payable onlyOwner{
732         require(NewInsWallet != address(0),"Address should not be 0");
733         require(NewB3_1Wallet != address(0),"Address should not be 0");
734         require(NewB3_2Wallet != address(0),"Address should not be 0");
735 
736         insuranceWallet = NewInsWallet;
737         b3_1Wallet = NewB3_1Wallet;
738         b3_2Wallet = NewB3_2Wallet;
739         emit NewFeeWalletsSet(
740             NewInsWallet, 
741             NewB3_1Wallet, 
742             NewB3_2Wallet
743         );
744     }
745 
746     /**
747     * @notice Set Wallet Limits
748     * @dev This function is for set wallet limits.
749     * @param walPct The max wallet balance percent.
750     * @param txnPct The max transaction amount percent.
751      */
752     function SetLimits(uint256 walPct, uint256 txnPct) external payable onlyOwner {
753         require(walPct >= 10, "min 0.1%");
754         require(walPct <= 10000, "max 100%");
755         maxWalletBalance = InitialSupply * walPct / 10000;
756         emit MaxWalletBalanceUpdated(walPct);
757 
758         require(txnPct >= 10, "min 0.1%");
759         require(txnPct <= 10000, "max 100%");
760         maxTransactionAmount = InitialSupply * txnPct / 10000;
761         emit MaxTransactionAmountUpdated(txnPct);
762     }
763 
764     /**
765     * @notice AirDrop Tokens
766     * @dev This function is for airdrop tokens.
767     * @param accounts The array of address to be airdroped.
768     * @param amounts The array of amount to be airdroped.
769      */
770     function Airdropper(address[] calldata accounts, uint256[] calldata amounts) external payable onlyOwner {
771         uint256 length = accounts.length;
772         require (length == amounts.length, "array length mismatched");
773         uint256 airdropAmount = 0;
774         
775         for (uint256 i = 0; i < length; i++) {
776             // updating balance directly instead of calling transfer to save gas
777             _balances[accounts[i]] += amounts[i];
778             airdropAmount += amounts[i];
779             emit Transfer(msg.sender, accounts[i], amounts[i]);
780         }
781         _balances[msg.sender] -= airdropAmount;
782 
783         emit TokensAirdroped(msg.sender, length, airdropAmount);
784     }
785 
786     /**
787     * @notice Set to exclude an address from fees.
788     * @dev This function is for set to exclude an address from fees.
789     * @param account The address of user to be excluded from fees.
790     * @param exclude The status of exclude.
791     */
792     function ExcludeAccountFromFees(address account, bool exclude) external payable onlyOwner{
793         require(account!=address(this),"can't Include the contract");
794         require(account != address(0),"Address should not be 0");
795         excludedFromFees[account]=exclude;
796         emit ExcludeAccount(account,exclude);
797     }
798 
799     /**
800     * @notice Set to exclude an address from transaction limits.
801     * @dev This function is for set to exclude an address from transaction limits.
802     * @param account The address of user to be excluded from transaction limits.
803     * @param exclude The status of exclude.
804     */
805     function SetExcludedAccountFromTransactionLimits(address account, bool exclude) external payable onlyOwner{
806         require(account != address(0),"Address should not be 0");
807         excludedFromTransactionLimits[account]=exclude;
808         emit ExcludeFromTransactionLimits(account,exclude);
809     }
810 
811     /** 
812     * @notice Set to exclude an address from wallet limits.
813     * @dev This function is for set to exclude an address from wallet limits.
814     * @param account The address of user to be excluded from wallet limits.
815     * @param exclude The status of exclude.
816     */
817     function SetExcludedAccountFromWalletLimits(address account, bool exclude) external payable onlyOwner{
818         require(account != address(0),"Address should not be 0");
819         excludedFromWalletLimits[account]=exclude;
820         emit ExcludeFromWalletLimits(account,exclude);
821     }
822 
823     /**
824     * @notice Used to start trading.
825     * @dev This function is for used to start trading.
826     */
827     function SetupEnableTrading() external payable onlyOwner{
828         require(LaunchBlock==0,"AlreadyLaunched");
829 
830         _dexRouter = IdexRouter(dexRouter);
831         _dexPairAddress = IdexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
832         isPair[_dexPairAddress]=true;
833 
834         _addInitLiquidity();
835 
836         LaunchBlock=block.number;
837 
838         maxWalletBalance = InitialSupply * 12 / 10000; // 0.12%
839         maxTransactionAmount = InitialSupply * 12 / 10000; // 0.12%
840         emit OnEnableTrading();
841     }
842 
843     receive() external payable {}
844 
845     function getOwner() external view override returns (address) {return owner();}
846     function name() external pure override returns (string memory) {return _name;}
847     function symbol() external pure override returns (string memory) {return _symbol;}
848     function decimals() external pure override returns (uint8) {return _decimals;}
849     function totalSupply() external pure override returns (uint) {return InitialSupply;}
850     function balanceOf(address account) public view override returns (uint) {return _balances[account];}
851     function isExcludedFromWalletLimits(address account) public view returns(bool) {return excludedFromWalletLimits[account];}
852     function isExcludedFromTransferLimits(address account) public view returns(bool) {return excludedFromTransactionLimits[account];}
853     function transfer(address recipient, uint amount) external override returns (bool) {
854         _transfer(msg.sender, recipient, amount);
855         return true;
856     }
857     function allowance(address _owner, address spender) external view override returns (uint) {
858         return _allowances[_owner][spender];
859     }
860     function approve(address spender, uint amount) external override returns (bool) {
861         _approve(msg.sender, spender, amount);
862         return true;
863     }
864     function _approve(address _owner, address spender, uint amount) private {
865         require(_owner != address(0), "Approve from zero");
866         require(spender != address(0), "Approve to zero");
867         _allowances[_owner][spender] = amount;
868         emit Approval(_owner, spender, amount);
869     }
870     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
871         _transfer(sender, recipient, amount);
872         uint currentAllowance = _allowances[sender][msg.sender];
873         require(currentAllowance >= amount, "Transfer > allowance");
874         _approve(sender, msg.sender, currentAllowance - amount);
875         return true;
876     }
877     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
878         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
879         return true;
880     }
881     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
882         uint currentAllowance = _allowances[msg.sender][spender];
883         require(currentAllowance >= subtractedValue, "<0 allowance");
884         _approve(msg.sender, spender, currentAllowance - subtractedValue);
885         return true;
886     }
887 
888     /**
889     * @notice Used to remove excess ETH from contract
890     * @dev This function is for used to remove excess ETH from contract.
891     * @param amountPercentage The amount percentage to recover.
892      */
893     function emergencyETHrecovery(uint256 amountPercentage) external payable onlyOwner {
894         uint256 amountETH = address(this).balance;
895         (bool sent,)=msg.sender.call{value:amountETH * amountPercentage / 100}("");
896             sent=true;
897         emit RecoverETH();
898     }
899     
900     /**
901     * @notice Used to remove excess Tokens from contract
902     * @dev This function is for used to remove excess Tokens from contract.
903     * @param tokenAddress The token address to recover.
904     * @param amountPercentage The amount percentage to recover.
905      */
906     function emergencyTokenrecovery(address tokenAddress, uint256 amountPercentage) external payable onlyOwner {
907         require(tokenAddress!=address(0));
908         require(tokenAddress!=address(_dexPairAddress));
909         IERC20 token = IERC20(tokenAddress);
910         uint256 tokenAmount = token.balanceOf(address(this));
911         token.transfer(msg.sender, tokenAmount * amountPercentage / 100);
912 
913         emit RecoverTokens(tokenAmount);
914     }
915 
916 }