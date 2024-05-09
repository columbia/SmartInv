1 // File: contracts\modules\Ownable.sol
2 
3 pragma solidity =0.5.16;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be applied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address internal _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: contracts\modules\Halt.sol
80 
81 pragma solidity =0.5.16;
82 
83 
84 contract Halt is Ownable {
85     
86     bool private halted = false; 
87     
88     modifier notHalted() {
89         require(!halted,"This contract is halted");
90         _;
91     }
92 
93     modifier isHalted() {
94         require(halted,"This contract is not halted");
95         _;
96     }
97     
98     /// @notice function Emergency situation that requires 
99     /// @notice contribution period to stop or not.
100     function setHalt(bool halt) 
101         public 
102         onlyOwner
103     {
104         halted = halt;
105     }
106 }
107 
108 // File: contracts\modules\whiteList.sol
109 
110 pragma solidity =0.5.16;
111     /**
112      * @dev Implementation of a whitelist which filters a eligible uint32.
113      */
114 library whiteListUint32 {
115     /**
116      * @dev add uint32 into white list.
117      * @param whiteList the storage whiteList.
118      * @param temp input value
119      */
120 
121     function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{
122         if (!isEligibleUint32(whiteList,temp)){
123             whiteList.push(temp);
124         }
125     }
126     /**
127      * @dev remove uint32 from whitelist.
128      */
129     function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {
130         uint256 len = whiteList.length;
131         uint256 i=0;
132         for (;i<len;i++){
133             if (whiteList[i] == temp)
134                 break;
135         }
136         if (i<len){
137             if (i!=len-1) {
138                 whiteList[i] = whiteList[len-1];
139             }
140             whiteList.length--;
141             return true;
142         }
143         return false;
144     }
145     function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){
146         uint256 len = whiteList.length;
147         for (uint256 i=0;i<len;i++){
148             if (whiteList[i] == temp)
149                 return true;
150         }
151         return false;
152     }
153     function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){
154         uint256 len = whiteList.length;
155         uint256 i=0;
156         for (;i<len;i++){
157             if (whiteList[i] == temp)
158                 break;
159         }
160         return i;
161     }
162 }
163     /**
164      * @dev Implementation of a whitelist which filters a eligible uint256.
165      */
166 library whiteListUint256 {
167     // add whiteList
168     function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{
169         if (!isEligibleUint256(whiteList,temp)){
170             whiteList.push(temp);
171         }
172     }
173     function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {
174         uint256 len = whiteList.length;
175         uint256 i=0;
176         for (;i<len;i++){
177             if (whiteList[i] == temp)
178                 break;
179         }
180         if (i<len){
181             if (i!=len-1) {
182                 whiteList[i] = whiteList[len-1];
183             }
184             whiteList.length--;
185             return true;
186         }
187         return false;
188     }
189     function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){
190         uint256 len = whiteList.length;
191         for (uint256 i=0;i<len;i++){
192             if (whiteList[i] == temp)
193                 return true;
194         }
195         return false;
196     }
197     function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){
198         uint256 len = whiteList.length;
199         uint256 i=0;
200         for (;i<len;i++){
201             if (whiteList[i] == temp)
202                 break;
203         }
204         return i;
205     }
206 }
207     /**
208      * @dev Implementation of a whitelist which filters a eligible address.
209      */
210 library whiteListAddress {
211     // add whiteList
212     function addWhiteListAddress(address[] storage whiteList,address temp) internal{
213         if (!isEligibleAddress(whiteList,temp)){
214             whiteList.push(temp);
215         }
216     }
217     function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {
218         uint256 len = whiteList.length;
219         uint256 i=0;
220         for (;i<len;i++){
221             if (whiteList[i] == temp)
222                 break;
223         }
224         if (i<len){
225             if (i!=len-1) {
226                 whiteList[i] = whiteList[len-1];
227             }
228             whiteList.length--;
229             return true;
230         }
231         return false;
232     }
233     function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){
234         uint256 len = whiteList.length;
235         for (uint256 i=0;i<len;i++){
236             if (whiteList[i] == temp)
237                 return true;
238         }
239         return false;
240     }
241     function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){
242         uint256 len = whiteList.length;
243         uint256 i=0;
244         for (;i<len;i++){
245             if (whiteList[i] == temp)
246                 break;
247         }
248         return i;
249     }
250 }
251 
252 // File: contracts\modules\AddressWhiteList.sol
253 
254 pragma solidity =0.5.16;
255 
256 
257     /**
258      * @dev Implementation of a whitelist filters a eligible address.
259      */
260 contract AddressWhiteList is Halt {
261 
262     using whiteListAddress for address[];
263     uint256 constant internal allPermission = 0xffffffff;
264     uint256 constant internal allowBuyOptions = 1;
265     uint256 constant internal allowSellOptions = 1<<1;
266     uint256 constant internal allowExerciseOptions = 1<<2;
267     uint256 constant internal allowAddCollateral = 1<<3;
268     uint256 constant internal allowRedeemCollateral = 1<<4;
269     // The eligible adress list
270     address[] internal whiteList;
271     mapping(address => uint256) internal addressPermission;
272     /**
273      * @dev Implementation of add an eligible address into the whitelist.
274      * @param addAddress new eligible address.
275      */
276     function addWhiteList(address addAddress)public onlyOwner{
277         whiteList.addWhiteListAddress(addAddress);
278         addressPermission[addAddress] = allPermission;
279     }
280     function modifyPermission(address addAddress,uint256 permission)public onlyOwner{
281         addressPermission[addAddress] = permission;
282     }
283     /**
284      * @dev Implementation of revoke an invalid address from the whitelist.
285      * @param removeAddress revoked address.
286      */
287     function removeWhiteList(address removeAddress)public onlyOwner returns (bool){
288         addressPermission[removeAddress] = 0;
289         return whiteList.removeWhiteListAddress(removeAddress);
290     }
291     /**
292      * @dev Implementation of getting the eligible whitelist.
293      */
294     function getWhiteList()public view returns (address[] memory){
295         return whiteList;
296     }
297     /**
298      * @dev Implementation of testing whether the input address is eligible.
299      * @param tmpAddress input address for testing.
300      */    
301     function isEligibleAddress(address tmpAddress) public view returns (bool){
302         return whiteList.isEligibleAddress(tmpAddress);
303     }
304     function checkAddressPermission(address tmpAddress,uint256 state) public view returns (bool){
305         return  (addressPermission[tmpAddress]&state) == state;
306     }
307 }
308 
309 // File: contracts\modules\ReentrancyGuard.sol
310 
311 pragma solidity =0.5.16;
312 contract ReentrancyGuard {
313 
314   /**
315    * @dev We use a single lock for the whole contract.
316    */
317   bool private reentrancyLock = false;
318   /**
319    * @dev Prevents a contract from calling itself, directly or indirectly.
320    * @notice If you mark a function `nonReentrant`, you should also
321    * mark it `external`. Calling one nonReentrant function from
322    * another is not supported. Instead, you can implement a
323    * `private` function doing the actual work, and a `external`
324    * wrapper marked as `nonReentrant`.
325    */
326   modifier nonReentrant() {
327     require(!reentrancyLock);
328     reentrancyLock = true;
329     _;
330     reentrancyLock = false;
331   }
332 
333 }
334 
335 // File: contracts\OptionsPool\IOptionsPool.sol
336 
337 pragma solidity =0.5.16;
338 
339 interface IOptionsPool {
340 //    function getOptionBalances(address user) external view returns(uint256[]);
341 
342     function getExpirationList()external view returns (uint32[] memory);
343     function createOptions(address from,address settlement,uint256 type_ly_expiration,
344         uint128 strikePrice,uint128 underlyingPrice,uint128 amount,uint128 settlePrice) external returns(uint256);
345     function setSharedState(uint256 newFirstOption,int256[] calldata latestNetWorth,address[] calldata whiteList) external;
346     function getAllTotalOccupiedCollateral() external view returns (uint256,uint256);
347     function getCallTotalOccupiedCollateral() external view returns (uint256);
348     function getPutTotalOccupiedCollateral() external view returns (uint256);
349     function getTotalOccupiedCollateral() external view returns (uint256);
350 //    function buyOptionCheck(uint32 expiration,uint32 underlying)external view;
351     function burnOptions(address from,uint256 id,uint256 amount,uint256 optionPrice)external;
352     function getOptionsById(uint256 optionsId)external view returns(uint256,address,uint8,uint32,uint256,uint256,uint256);
353     function getExerciseWorth(uint256 optionsId,uint256 amount)external view returns(uint256);
354     function calculatePhaseOptionsFall(uint256 lastOption,uint256 begin,uint256 end,address[] calldata whiteList) external view returns(int256[] memory);
355     function getOptionInfoLength()external view returns (uint256);
356     function getNetWrothCalInfo(address[] calldata whiteList)external view returns(uint256,int256[] memory);
357     function calRangeSharedPayment(uint256 lastOption,uint256 begin,uint256 end,address[] calldata whiteList)external view returns(int256[] memory,uint256[] memory,uint256);
358     function getNetWrothLatestWorth(address settlement)external view returns(int256);
359     function getBurnedFullPay(uint256 optionID,uint256 amount) external view returns(address,uint256);
360 
361 }
362 contract ImportOptionsPool is Ownable{
363     IOptionsPool internal _optionsPool;
364     function getOptionsPoolAddress() public view returns(address){
365         return address(_optionsPool);
366     }
367     function setOptionsPoolAddress(address optionsPool)public onlyOwner{
368         _optionsPool = IOptionsPool(optionsPool);
369     }
370 }
371 
372 // File: contracts\interfaces\IFNXOracle.sol
373 
374 pragma solidity =0.5.16;
375 
376 interface IFNXOracle {
377     /**
378   * @notice retrieves price of an asset
379   * @dev function to get price for an asset
380   * @param asset Asset for which to get the price
381   * @return uint mantissa of asset price (scaled by 1e8) or zero if unset or contract paused
382   */
383     function getPrice(address asset) external view returns (uint256);
384     function getUnderlyingPrice(uint256 cToken) external view returns (uint256);
385     function getPrices(uint256[] calldata assets) external view returns (uint256[]memory);
386     function getAssetAndUnderlyingPrice(address asset,uint256 underlying) external view returns (uint256,uint256);
387 //    function getSellOptionsPrice(address oToken) external view returns (uint256);
388 //    function getBuyOptionsPrice(address oToken) external view returns (uint256);
389 }
390 contract ImportOracle is Ownable{
391     IFNXOracle internal _oracle;
392     function oraclegetPrices(uint256[] memory assets) internal view returns (uint256[]memory){
393         uint256[] memory prices = _oracle.getPrices(assets);
394         uint256 len = assets.length;
395         for (uint i=0;i<len;i++){
396         require(prices[i] >= 100 && prices[i] <= 1e30);
397         }
398         return prices;
399     }
400     function oraclePrice(address asset) internal view returns (uint256){
401         uint256 price = _oracle.getPrice(asset);
402         require(price >= 100 && price <= 1e30);
403         return price;
404     }
405     function oracleUnderlyingPrice(uint256 cToken) internal view returns (uint256){
406         uint256 price = _oracle.getUnderlyingPrice(cToken);
407         require(price >= 100 && price <= 1e30);
408         return price;
409     }
410     function oracleAssetAndUnderlyingPrice(address asset,uint256 cToken) internal view returns (uint256,uint256){
411         (uint256 price1,uint256 price2) = _oracle.getAssetAndUnderlyingPrice(asset,cToken);
412         require(price1 >= 100 && price1 <= 1e30);
413         require(price2 >= 100 && price2 <= 1e30);
414         return (price1,price2);
415     }
416     function getOracleAddress() public view returns(address){
417         return address(_oracle);
418     }
419     function setOracleAddress(address oracle)public onlyOwner{
420         _oracle = IFNXOracle(oracle);
421     }
422 }
423 
424 // File: contracts\interfaces\IOptionsPrice.sol
425 
426 pragma solidity =0.5.16;
427 
428 interface IOptionsPrice {
429     function getOptionsPrice(uint256 currentPrice, uint256 strikePrice, uint256 expiration,uint32 underlying,uint8 optType)external view returns (uint256);
430     function getOptionsPrice_iv(uint256 currentPrice, uint256 strikePrice, uint256 expiration,
431                 uint256 ivNumerator,uint8 optType)external view returns (uint256);
432     function calOptionsPriceRatio(uint256 selfOccupied,uint256 totalOccupied,uint256 totalCollateral) external view returns (uint256);
433 }
434 contract ImportOptionsPrice is Ownable{
435     IOptionsPrice internal _optionsPrice;
436     function getOptionsPriceAddress() public view returns(address){
437         return address(_optionsPrice);
438     }
439     function setOptionsPriceAddress(address optionsPrice)public onlyOwner{
440         _optionsPrice = IOptionsPrice(optionsPrice);
441     }
442 }
443 
444 // File: contracts\CollateralPool\ICollateralPool.sol
445 
446 pragma solidity =0.5.16;
447 
448 interface ICollateralPool {
449     function getFeeRateAll()external view returns (uint32[] memory);
450     function getUserPayingUsd(address user)external view returns (uint256);
451     function getUserInputCollateral(address user,address collateral)external view returns (uint256);
452     //function getNetWorthBalance(address collateral)external view returns (int256);
453     function getCollateralBalance(address collateral)external view returns (uint256);
454 
455     //add
456     function addUserPayingUsd(address user,uint256 amount)external;
457     function addUserInputCollateral(address user,address collateral,uint256 amount)external;
458     function addNetWorthBalance(address collateral,int256 amount)external;
459     function addCollateralBalance(address collateral,uint256 amount)external;
460     //sub
461     function subUserPayingUsd(address user,uint256 amount)external;
462     function subUserInputCollateral(address user,address collateral,uint256 amount)external;
463     function subNetWorthBalance(address collateral,int256 amount)external;
464     function subCollateralBalance(address collateral,uint256 amount)external;
465         //set
466     function setUserPayingUsd(address user,uint256 amount)external;
467     function setUserInputCollateral(address user,address collateral,uint256 amount)external;
468     function setNetWorthBalance(address collateral,int256 amount)external;
469     function setCollateralBalance(address collateral,uint256 amount)external;
470     function transferPaybackAndFee(address recieptor,address settlement,uint256 payback,uint256 feeType)external;
471 
472     function buyOptionsPayfor(address payable recieptor,address settlement,uint256 settlementAmount,uint256 allPay)external;
473     function transferPayback(address recieptor,address settlement,uint256 payback)external;
474     function transferPaybackBalances(address account,uint256 redeemWorth,address[] calldata tmpWhiteList,uint256[] calldata colBalances,
475         uint256[] calldata PremiumBalances,uint256[] calldata prices)external;
476     function getCollateralAndPremiumBalances(address account,uint256 userTotalWorth,address[] calldata tmpWhiteList,
477         uint256[] calldata _RealBalances,uint256[] calldata prices) external view returns(uint256[] memory,uint256[] memory);
478     function addTransactionFee(address collateral,uint256 amount,uint256 feeType)external returns (uint256);
479 
480     function getAllRealBalance(address[] calldata whiteList)external view returns(int256[] memory);
481     function getRealBalance(address settlement)external view returns(int256);
482     function getNetWorthBalance(address settlement)external view returns(uint256);
483 }
484 contract ImportCollateralPool is Ownable{
485     ICollateralPool internal _collateralPool;
486     function getCollateralPoolAddress() public view returns(address){
487         return address(_collateralPool);
488     }
489     function setCollateralPoolAddress(address collateralPool)public onlyOwner{
490         _collateralPool = ICollateralPool(collateralPool);
491     }
492 }
493 
494 // File: contracts\FPTCoin\IFPTCoin.sol
495 
496 pragma solidity =0.5.16;
497 
498 interface IFPTCoin {
499     function lockedBalanceOf(address account) external view returns (uint256);
500     function lockedWorthOf(address account) external view returns (uint256);
501     function getLockedBalance(address account) external view returns (uint256,uint256);
502     function balanceOf(address account) external view returns (uint256);
503     function totalSupply() external view returns (uint256);
504     function mint(address account, uint256 amount) external;
505     function burn(address account, uint256 amount) external;
506     function addlockBalance(address account, uint256 amount,uint256 lockedWorth)external; 
507     function getTotalLockedWorth() external view returns (uint256);
508     function addMinerBalance(address account,uint256 amount) external;
509     function redeemLockedCollateral(address account,uint256 tokenAmount,uint256 leftCollateral)external returns (uint256,uint256);
510 }
511 contract ImportIFPTCoin is Ownable{
512     IFPTCoin internal _FPTCoin;
513     function getFPTCoinAddress() public view returns(address){
514         return address(_FPTCoin);
515     }
516     function setFPTCoinAddress(address FPTCoinAddr)public onlyOwner{
517         _FPTCoin = IFPTCoin(FPTCoinAddr);
518     }
519 }
520 
521 // File: contracts\modules\ImputRange.sol
522 
523 pragma solidity =0.5.16;
524 
525 
526 contract ImputRange is Ownable {
527     
528     //The maximum input amount limit.
529     uint256 private maxAmount = 1e30;
530     //The minimum input amount limit.
531     uint256 private minAmount = 1e2;
532     
533     modifier InRange(uint256 amount) {
534         require(maxAmount>=amount && minAmount<=amount,"input amount is out of input amount range");
535         _;
536     }
537     /**
538      * @dev Determine whether the input amount is within the valid range
539      * @param Amount Test value which is user input
540      */
541     function isInputAmountInRange(uint256 Amount)public view returns (bool){
542         return(maxAmount>=Amount && minAmount<=Amount);
543     }
544     /*
545     function isInputAmountSmaller(uint256 Amount)public view returns (bool){
546         return maxAmount>=amount;
547     }
548     function isInputAmountLarger(uint256 Amount)public view returns (bool){
549         return minAmount<=amount;
550     }
551     */
552     modifier Smaller(uint256 amount) {
553         require(maxAmount>=amount,"input amount is larger than maximium");
554         _;
555     }
556     modifier Larger(uint256 amount) {
557         require(minAmount<=amount,"input amount is smaller than maximium");
558         _;
559     }
560     /**
561      * @dev get the valid range of input amount
562      */
563     function getInputAmountRange() public view returns(uint256,uint256) {
564         return (minAmount,maxAmount);
565     }
566     /**
567      * @dev set the valid range of input amount
568      * @param _minAmount the minimum input amount limit
569      * @param _maxAmount the maximum input amount limit
570      */
571     function setInputAmountRange(uint256 _minAmount,uint256 _maxAmount) public onlyOwner{
572         minAmount = _minAmount;
573         maxAmount = _maxAmount;
574     }        
575 }
576 
577 // File: contracts\modules\Allowances.sol
578 
579 pragma solidity =0.5.16;
580 
581 /**
582  * @dev Contract module which provides a basic access control mechanism, where
583  * each operator can be granted exclusive access to specific functions.
584  *
585  */
586 contract Allowances is Ownable {
587     mapping (address => uint256) internal allowances;
588     bool internal bValid = false;
589     /**
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function approve(address spender, uint256 amount) public onlyOwner{
596         allowances[spender] = amount;
597     }
598     function allowance(address spender) public view returns (uint256) {
599         return allowances[spender];
600     }
601     function setValid(bool _bValid) public onlyOwner{
602         bValid = _bValid;
603     }
604     function checkAllowance(address spender, uint256 amount) public view returns(bool){
605         return (!bValid) || (allowances[spender] >= amount);
606     }
607     modifier sufficientAllowance(address spender, uint256 amount){
608         require((!bValid) || (allowances[spender] >= amount),"Allowances : user's allowance is unsufficient!");
609         _;
610     }
611 }
612 
613 // File: contracts\ERC20\IERC20.sol
614 
615 pragma solidity =0.5.16;
616 /**
617  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
618  * the optional functions; to access them see {ERC20Detailed}.
619  */
620 interface IERC20 {
621     /**
622      * @dev Returns the amount of tokens in existence.
623      */
624     function totalSupply() external view returns (uint256);
625 
626     /**
627      * @dev Returns the amount of tokens owned by `account`.
628      */
629     function balanceOf(address account) external view returns (uint256);
630 
631     /**
632      * @dev Moves `amount` tokens from the caller's account to `recipient`.
633      *
634      * Returns a boolean value indicating whether the operation succeeded.
635      *
636      * Emits a {Transfer} event.
637      */
638     function transfer(address recipient, uint256 amount) external returns (bool);
639 
640     /**
641      * @dev Returns the remaining number of tokens that `spender` will be
642      * allowed to spend on behalf of `owner` through {transferFrom}. This is
643      * zero by default.
644      *
645      * This value changes when {approve} or {transferFrom} are called.
646      */
647     function allowance(address owner, address spender) external view returns (uint256);
648 
649     /**
650      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
651      *
652      * Returns a boolean value indicating whether the operation succeeded.
653      *
654      * IMPORTANT: Beware that changing an allowance with this method brings the risk
655      * that someone may use both the old and the new allowance by unfortunate
656      * transaction ordering. One possible solution to mitigate this race
657      * condition is to first reduce the spender's allowance to 0 and set the
658      * desired value afterwards:
659      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
660      *
661      * Emits an {Approval} event.
662      */
663     function approve(address spender, uint256 amount) external returns (bool);
664 
665     /**
666      * @dev Moves `amount` tokens from `sender` to `recipient` using the
667      * allowance mechanism. `amount` is then deducted from the caller's
668      * allowance.
669      *
670      * Returns a boolean value indicating whether the operation succeeded.
671      *
672      * Emits a {Transfer} event.
673      */
674     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
675 
676     /**
677      * @dev Emitted when `value` tokens are moved from one account (`from`) to
678      * another (`to`).
679      *
680      * Note that `value` may be zero.
681      */
682     event Transfer(address indexed from, address indexed to, uint256 value);
683 
684     /**
685      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
686      * a call to {approve}. `value` is the new allowance.
687      */
688     event Approval(address indexed owner, address indexed spender, uint256 value);
689 }
690 
691 // File: contracts\OptionsManager\ManagerData.sol
692 
693 pragma solidity =0.5.16;
694 
695 
696 
697 
698 
699 
700 
701 
702 
703 
704 /**
705  * @title collateral calculate module
706  * @dev A smart-contract which has operations of collateral and methods of calculate collateral occupation.
707  *
708  */
709 contract ManagerData is ReentrancyGuard,ImputRange,AddressWhiteList,Allowances,ImportIFPTCoin,
710                 ImportOracle,ImportOptionsPool,ImportCollateralPool,ImportOptionsPrice {
711     // The minimum collateral rate for options. This value is thousandths.
712     mapping (address=>uint256) collateralRate;
713 //    uint256 private collateralRate = 5000;
714     /**
715      * @dev Emitted when `from` added `amount` collateral and minted `tokenAmount` FPTCoin.
716      */
717     event AddCollateral(address indexed from,address indexed collateral,uint256 amount,uint256 tokenAmount);
718     /**
719      * @dev Emitted when `from` redeemed `allRedeem` collateral.
720      */
721     event RedeemCollateral(address indexed from,address collateral,uint256 allRedeem);
722     event DebugEvent(uint256 id,uint256 value1,uint256 value2);
723         /**
724     * @dev input price valid range rate, thousandths.
725     * the input price must greater than current price * minPriceRate /1000
726     *       and less  than current price * maxPriceRate /1000 
727     * maxPriceRate is the maximum limit of the price valid range rate
728     * maxPriceRate is the minimum limit of the price valid range rage
729     */   
730     uint256 internal maxPriceRate = 1500;
731     uint256 internal minPriceRate = 500;
732     /**
733      * @dev Emitted when `from` buy `optionAmount` option and create new option.
734      * @param from user's account
735      * @param settlement user's input settlement paid for buy new option.
736      * @param optionPrice option's paid price
737      * @param settlementAmount settement cost
738      * @param optionAmount mint option token amount.
739      */  
740     event BuyOption(address indexed from,address indexed settlement,uint256 optionPrice,uint256 settlementAmount,uint256 optionAmount);
741     /**
742      * @dev Emitted when `from` sell `amount` option whose id is `optionId` and received sellValue,priced in usd.
743      */  
744     event SellOption(address indexed from,uint256 indexed optionId,uint256 amount,uint256 sellValue);
745     /**
746      * @dev Emitted when `from` exercise `amount` option whose id is `optionId` and received sellValue,priced in usd.
747      */  
748     event ExerciseOption(address indexed from,uint256 indexed optionId,uint256 amount,uint256 sellValue);
749 }
750 
751 // File: contracts\Proxy\baseProxy.sol
752 
753 pragma solidity =0.5.16;
754 
755 /**
756  * @title  baseProxy Contract
757 
758  */
759 contract baseProxy is Ownable {
760     address public implementation;
761     constructor(address implementation_) public {
762         // Creator of the contract is admin during initialization
763         implementation = implementation_; 
764         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
765         require(success);
766     }
767     function getImplementation()public view returns(address){
768         return implementation;
769     }
770     function setImplementation(address implementation_)public onlyOwner{
771         implementation = implementation_; 
772         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));
773         require(success);
774     }
775 
776     /**
777      * @notice Delegates execution to the implementation contract
778      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
779      * @param data The raw data to delegatecall
780      * @return The returned bytes from the delegatecall
781      */
782     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
783         (bool success, bytes memory returnData) = implementation.delegatecall(data);
784         assembly {
785             if eq(success, 0) {
786                 revert(add(returnData, 0x20), returndatasize)
787             }
788         }
789         return returnData;
790     }
791 
792     /**
793      * @notice Delegates execution to an implementation contract
794      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
795      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
796      * @param data The raw data to delegatecall
797      * @return The returned bytes from the delegatecall
798      */
799     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
800         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
801         assembly {
802             if eq(success, 0) {
803                 revert(add(returnData, 0x20), returndatasize)
804             }
805         }
806         return abi.decode(returnData, (bytes));
807     }
808 
809     function delegateToViewAndReturn() internal view returns (bytes memory) {
810         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
811 
812         assembly {
813             let free_mem_ptr := mload(0x40)
814             returndatacopy(free_mem_ptr, 0, returndatasize)
815 
816             switch success
817             case 0 { revert(free_mem_ptr, returndatasize) }
818             default { return(add(free_mem_ptr, 0x40), returndatasize) }
819         }
820     }
821 
822     function delegateAndReturn() internal returns (bytes memory) {
823         (bool success, ) = implementation.delegatecall(msg.data);
824 
825         assembly {
826             let free_mem_ptr := mload(0x40)
827             returndatacopy(free_mem_ptr, 0, returndatasize)
828 
829             switch success
830             case 0 { revert(free_mem_ptr, returndatasize) }
831             default { return(free_mem_ptr, returndatasize) }
832         }
833     }
834 }
835 
836 // File: contracts\OptionsManager\ManagerProxy.sol
837 
838 pragma solidity =0.5.16;
839 
840 
841 /**
842  * @title  Erc20Delegator Contract
843 
844  */
845 contract ManagerProxy is ManagerData,baseProxy{
846     /**
847     * @dev Options manager constructor. set other contract address
848     *  oracleAddr fnx oracle contract address.
849     *  optionsPriceAddr options price contract address
850     *  optionsPoolAddr optoins pool contract address
851     *  FPTCoinAddr FPTCoin contract address
852     */
853     constructor(address implementation_,address oracleAddr,address optionsPriceAddr,
854             address optionsPoolAddr,address collateralPoolAddr,address FPTCoinAddr)
855          baseProxy(implementation_) public  {
856         _oracle = IFNXOracle(oracleAddr);
857         _optionsPrice = IOptionsPrice(optionsPriceAddr);
858         _optionsPool = IOptionsPool(optionsPoolAddr);
859         _collateralPool = ICollateralPool(collateralPoolAddr);
860         _FPTCoin = IFPTCoin(FPTCoinAddr);
861 /*
862         allowances[0x6D14B6A933Bfc473aEDEBC3beD58cA268FEe8b4a] = 1e40;
863         allowances[0x87A7604C4E9E1CED9990b6D486d652f0194A4c98] = 1e40;
864         allowances[0x7ea1a45f0657D2Dbd77839a916AB83112bdB5590] = 1e40;
865         allowances[0x358dba22d19789E01FD6bB528f4E75Bc06b56A79] = 1e40;
866         allowances[0x91406B5d57893E307f042D71C91e223a7058Eb72] = 1e40;
867         allowances[0xc89b50171C1F692f5CBC37aC4AF540f9cecEE0Ff] = 1e40;
868         allowances[0x92e25B14B0B760212D7E831EB8436Fbb93826755] = 1e40;
869         allowances[0x2D8f8d7737046c1475ED5278a18c4A62968f0CB2] = 1e40;
870         allowances[0xaAC6A96681cfc81c756Db31D93eafb8237A27Ba8] = 1e40;
871         allowances[0xB752d7a4E7ebD7B7A7b4DEEFd086571e5e7F5BB8] = 1e40;
872         allowances[0x8AbD525792015E1eBae2249756729168A3c1866F] = 1e40;
873         allowances[0x991b9d51e5526D497A576DF82eaa4BEA51EAD16e] = 1e40;
874         allowances[0xC8e7E9e496DE394969cb377F5Df0E3cdDFB74164] = 1e40;
875         allowances[0x0B173b9014a0A36aAC51eE4957BC8c7E20686d3F] = 1e40;
876         allowances[0xb9cE369E36Ab9ea488887ad9483f0ce899ab8fbe] = 1e40;
877         allowances[0x20C337F68Dc90D830Ac8e379e8823008dc791D56] = 1e40;
878         allowances[0x10E3163a7354b16ac24e7fCeE593c22E86a0abCa] = 1e40;
879         allowances[0x669cFbd063C434a5ee51adc78d2292A2D3Fe88E0] = 1e40;
880         allowances[0x59F1cfc3c485b9693e3F640e1B56Fe83B5e3183a] = 1e40;
881         allowances[0x4B38bf8A442D01017a6882d52Ef1B13CD069bb0d] = 1e40;
882         allowances[0x9c8f005ab27AdB94f3d49020A15722Db2Fcd9F27] = 1e40;
883         allowances[0x2240D781185B93DdD83C5eA78F4E64a9Cb5B0446] = 1e40;
884         allowances[0xa5B7364926Ac89aBCA15D56738b3EA79B31A0433] = 1e40;
885         allowances[0xafE53d85Da6b510B4fcc3774373F8880097F3E10] = 1e40;
886         allowances[0xb604BE9155810e4BA938ce06f8E554D2EB3438fE] = 1e40;
887         allowances[0xA27D1D94C0B4ce79d49E7c817C688c563D297fF7] = 1e40;
888         allowances[0x32ACbBa480e4bA2ee3E2c620Bf7A3242631293BE] = 1e40;
889         allowances[0x7Acfd797725EcCd5D3D60fB5Dd566760D0743098] = 1e40;
890         allowances[0x0F8f5137C365D01f71a3fb8A4283816FB12A8Efb] = 1e40;
891         allowances[0x2F160d9b63b5b8255499aB16959231275D4396db] = 1e40;
892         allowances[0xf85a428D528e89E115E5C91F7347fE9ac2F92d72] = 1e40;
893         allowances[0xb2c62391CCe67C5EfC1b17D442eBd24c90F6A47C] = 1e40;
894         allowances[0x10d31b7063cC25F9916B390677DC473B83E84e13] = 1e40;
895         allowances[0x358dba22d19789E01FD6bB528f4E75Bc06b56A79] = 1e40;
896         allowances[0xe4A263230d67d30c71634CA462a00174d943A14D] = 1e40;
897         allowances[0x1493572Bd9Fa9F75b0B81D6Cdd583AD87D6B358F] = 1e40;
898         allowances[0x025b654306621157aE8208ebC5DD0f311F425ac3] = 1e40;
899         allowances[0xCE257C6BD7aF256e1C8Dd11057F90b9A1AeD85a4] = 1e40;
900         allowances[0x7D57B8B8A731Cc1fc1E661842790e1864d5Cf4E8] = 1e40;
901         allowances[0xe129e34D1bD6AA1370090Cb1596207197A1a0689] = 1e40;
902         allowances[0xBA096024056bB653c6E28f53C8889BFC3553bAD8] = 1e40;
903         allowances[0x73DFb4bA8fFF9A975a28FF169157C7B71B9574aE] = 1e40;
904         allowances[0xddbDc4a3Af9DAa4005c039BE8329c1F03F01EDb9] = 1e40;
905         allowances[0x4086E0e1B3351D2168B74E7A61C0844b78f765F2] = 1e40;
906         allowances[0x4ce4fe1B35F11a428DD36A78C56Cb8Cc755f8847] = 1e40;
907         allowances[0x9e169106D1d406F3d51750835E01e8a34c265957] = 1e40;
908         allowances[0x7EcB07AdC76b2979fbE45Af13e2B706bA3562d1d] = 1e40;
909         allowances[0x3B95Df362B1857e6Db3483521057C4587C467531] = 1e40;
910         allowances[0xe596470D291Cb2D32ec111afC314B07006690c72] = 1e40;
911         allowances[0x80fd2a2Ed7e42Ec8bD9635285B09C773Da31eF71] = 1e40;
912         allowances[0xC09ec032769b04b08BDe8ADb608d0aaF903FF9Be] = 1e40;
913         allowances[0xf5F9AFBC3915075C5C62A995501fae643F5f6857] = 1e40;
914         allowances[0xf010920E1B098DFA1732d41Fbc895aB6E65E4438] = 1e40;
915         allowances[0xb37983510f9483A0725bC109d7f19237Aa3212d5] = 1e40;
916         allowances[0x9531479AA50908c9053144eF99c235abA6168069] = 1e40;
917         allowances[0x98F6a20f80FbF33153BE7ed1C8C3c10d4d6433DF] = 1e40;
918         allowances[0x4c8dbbDdC95B7981a7a09dE455ddfc58173CF471] = 1e40;
919         allowances[0x5acfbbF0aA370F232E341BC0B1a40e996c960e07] = 1e40;
920         allowances[0x7388B46005646008ada2d6d7DC2830F6C63b9BeD] = 1e40;
921         allowances[0xBFa43bf6E9FB6d5CC253Ff23c31F2b86a739bB98] = 1e40;
922         allowances[0x09AEa652006F4088d389c878474e33e9B15986E5] = 1e40;
923         allowances[0x0fBC222aDF84bEE9169022b28ebc3D32b5C60756] = 1e40;
924         allowances[0xBD53E948a5630c409b98bFC6112c2891836d5b33] = 1e40;
925         allowances[0x0eBF4005C35d525240c3237c1C448B88Deca9447] = 1e40;
926         allowances[0xa1cCC796E2B44e80112c065A4d8F05661E685eD8] = 1e40;
927         allowances[0x4E60bE84870FE6AE350B563A121042396Abe1eaF] = 1e40;
928         allowances[0x5286CEde4a0Eda5916d639535aDFbefAd980D6E1] = 1e40;
929 */
930     }
931     /**
932      * @dev  The foundation owner want to set the minimum collateral occupation rate.
933      *  collateral collateral coin address
934      *  colRate The thousandths of the minimum collateral occupation rate.
935      */
936     function setCollateralRate(address /*collateral*/,uint256 /*colRate*/) public {
937         delegateAndReturn();
938     }
939     /**
940      * @dev Get the minimum collateral occupation rate.
941      */
942     function getCollateralRate(address /*collateral*/)public view returns (uint256) {
943         delegateToViewAndReturn();
944     }
945     /**
946      * @dev Retrieve user's cost of collateral, priced in USD.
947      *  user input retrieved account 
948      */
949     function getUserPayingUsd(address /*user*/)public view returns (uint256){
950         delegateToViewAndReturn();
951     }
952     /**
953      * @dev Retrieve user's amount of the specified collateral.
954      *  user input retrieved account 
955      *  collateral input retrieved collateral coin address 
956      */
957     function userInputCollateral(address /*user*/,address /*collateral*/)public view returns (uint256){
958         delegateToViewAndReturn();
959     }
960 
961     /**
962      * @dev Retrieve user's current total worth, priced in USD.
963      *  account input retrieve account
964      */
965     function getUserTotalWorth(address /*account*/)public view returns (uint256){
966         delegateToViewAndReturn();
967     }
968     /**
969      * @dev Retrieve FPTCoin's net worth, priced in USD.
970      */
971     function getTokenNetworth() public view returns (uint256){
972         delegateToViewAndReturn();
973     }
974     /**
975      * @dev Deposit collateral in this pool from user.
976      *  collateral The collateral coin address which is in whitelist.
977      *  amount the amount of collateral to deposit.
978      */
979     function addCollateral(address /*collateral*/,uint256 /*amount*/) public payable {
980         delegateAndReturn();
981     }
982     /**
983      * @dev redeem collateral from this pool, user can input the prioritized collateral,he will get this coin,
984      * if this coin is unsufficient, he will get others collateral which in whitelist.
985      *  tokenAmount the amount of FPTCoin want to redeem.
986      *  collateral The prioritized collateral coin address.
987      */
988     function redeemCollateral(uint256 /*tokenAmount*/,address /*collateral*/) public {
989         delegateAndReturn();
990     }
991     /**
992      * @dev Retrieve user's collateral worth in all collateral coin. 
993      * If user want to redeem all his collateral,and the vacant collateral is sufficient,
994      * He can redeem each collateral amount in return list.
995      *  account the retrieve user's account;
996      */
997     function calCollateralWorth(address /*account*/)public view returns(uint256[] memory){
998         delegateToViewAndReturn();
999     }
1000     /**
1001      * @dev Retrieve the occupied collateral worth, multiplied by minimum collateral rate, priced in USD. 
1002      */
1003     function getOccupiedCollateral() public view returns(uint256){
1004         delegateToViewAndReturn();
1005     }
1006     /**
1007      * @dev Retrieve the available collateral worth, the worth of collateral which can used for buy options, priced in USD. 
1008      */
1009     function getAvailableCollateral()public view returns(uint256){
1010         delegateToViewAndReturn();
1011     }
1012     /**
1013      * @dev Retrieve the left collateral worth, the worth of collateral which can used for redeem collateral, priced in USD. 
1014      */
1015     function getLeftCollateral()public view returns(uint256){
1016         delegateToViewAndReturn();
1017     }
1018     /**
1019      * @dev Retrieve the unlocked collateral worth, the worth of collateral which currently used for options, priced in USD. 
1020      */
1021     function getUnlockedCollateral()public view returns(uint256){
1022         delegateToViewAndReturn();
1023     }
1024     /**
1025      * @dev The auxiliary function for calculate option occupied. 
1026      *  strikePrice option's strike price
1027      *  underlyingPrice option's underlying price
1028      *  amount option's amount
1029      *  optType option's type, 0 for call, 1 for put.
1030      */
1031     function calOptionsOccupied(uint256 /*strikePrice*/,uint256 /*underlyingPrice*/,uint256 /*amount*/,uint8 /*optType*/)public view returns(uint256){
1032         delegateToViewAndReturn();
1033     }
1034     /**
1035      * @dev Retrieve the total collateral worth, priced in USD. 
1036      */
1037     function getTotalCollateral()public view returns(uint256){
1038         delegateToViewAndReturn();
1039     }
1040     /**
1041      * @dev Retrieve the balance of collateral, the auxiliary function for the total collateral calculation. 
1042      */
1043     function getRealBalance(address /*settlement*/)public view returns(int256){
1044         delegateToViewAndReturn();
1045     }
1046     function getNetWorthBalance(address /*settlement*/)public view returns(uint256){
1047         delegateToViewAndReturn();
1048     }
1049     /**
1050      * @dev collateral occupation rate calculation
1051      *      collateral occupation rate = sum(collateral Rate * collateral balance) / sum(collateral balance)
1052      */
1053     function calculateCollateralRate()public view returns (uint256){
1054         delegateToViewAndReturn();
1055     }
1056     /**
1057     * @dev retrieve input price valid range rate, thousandths.
1058     */ 
1059     function getPriceRateRange() public view returns(uint256,uint256) {
1060         delegateToViewAndReturn();
1061     }
1062     /**
1063     * @dev set input price valid range rate, thousandths.
1064     */ 
1065     function setPriceRateRange(uint256 /*_minPriceRate*/,uint256 /*_maxPriceRate*/) public{
1066         delegateAndReturn();
1067     }
1068     /**
1069     * @dev user buy option and create new option.
1070     *  settlement user's settement coin address
1071     *  settlementAmount amount of settlement user want fo pay.
1072     *  strikePrice user input option's strike price
1073     *  underlying user input option's underlying id, 1 for BTC,2 for ETH
1074     *  expiration user input expiration,time limit from now
1075     *  amount user input amount of new option user want to buy.
1076     *  optType user input option type
1077     */ 
1078     function buyOption(address /*settlement*/,uint256 /*settlementAmount*/, uint256 /*strikePrice*/,uint32 /*underlying*/,
1079                 uint32 /*expiration*/,uint256 /*amount*/,uint8 /*optType*/) public payable{
1080         delegateAndReturn();
1081     }
1082     /**
1083     * @dev User sell option.
1084     *  optionsId option's ID which was wanted to sell, must owned by user
1085     *  amount user input amount of option user want to sell.
1086     */ 
1087     function sellOption(uint256 /*optionsId*/,uint256 /*amount*/) public{
1088         delegateAndReturn();
1089     }
1090     /**
1091     * @dev User exercise option.
1092     *  optionsId option's ID which was wanted to exercise, must owned by user
1093     *  amount user input amount of option user want to exercise.
1094     */ 
1095     function exerciseOption(uint256 /*optionsId*/,uint256 /*amount*/) public{
1096         delegateAndReturn();
1097     }
1098     function getOptionsPrice(uint256 /*underlyingPrice*/, uint256 /*strikePrice*/, uint256 /*expiration*/,
1099                     uint32 /*underlying*/,uint256 /*amount*/,uint8 /*optType*/) public view returns(uint256){
1100         delegateToViewAndReturn();
1101     }
1102     function getALLCollateralinfo(address /*user*/)public view 
1103         returns(uint256[] memory,int256[] memory,uint32[] memory,uint32[] memory){
1104         delegateToViewAndReturn();
1105     }
1106 }