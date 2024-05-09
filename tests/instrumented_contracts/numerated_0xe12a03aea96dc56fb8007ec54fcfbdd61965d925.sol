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
79 // File: contracts\modules\Managerable.sol
80 
81 pragma solidity =0.5.16;
82 
83 contract Managerable is Ownable {
84 
85     address private _managerAddress;
86     /**
87      * @dev modifier, Only manager can be granted exclusive access to specific functions. 
88      *
89      */
90     modifier onlyManager() {
91         require(_managerAddress == msg.sender,"Managerable: caller is not the Manager");
92         _;
93     }
94     /**
95      * @dev set manager by owner. 
96      *
97      */
98     function setManager(address managerAddress)
99     public
100     onlyOwner
101     {
102         _managerAddress = managerAddress;
103     }
104     /**
105      * @dev get manager address. 
106      *
107      */
108     function getManager()public view returns (address) {
109         return _managerAddress;
110     }
111 }
112 
113 // File: contracts\interfaces\IFNXOracle.sol
114 
115 pragma solidity =0.5.16;
116 
117 interface IFNXOracle {
118     /**
119   * @notice retrieves price of an asset
120   * @dev function to get price for an asset
121   * @param asset Asset for which to get the price
122   * @return uint mantissa of asset price (scaled by 1e8) or zero if unset or contract paused
123   */
124     function getPrice(address asset) external view returns (uint256);
125     function getUnderlyingPrice(uint256 cToken) external view returns (uint256);
126     function getPrices(uint256[] calldata assets) external view returns (uint256[]memory);
127     function getAssetAndUnderlyingPrice(address asset,uint256 underlying) external view returns (uint256,uint256);
128 //    function getSellOptionsPrice(address oToken) external view returns (uint256);
129 //    function getBuyOptionsPrice(address oToken) external view returns (uint256);
130 }
131 contract ImportOracle is Ownable{
132     IFNXOracle internal _oracle;
133     function oraclegetPrices(uint256[] memory assets) internal view returns (uint256[]memory){
134         uint256[] memory prices = _oracle.getPrices(assets);
135         uint256 len = assets.length;
136         for (uint i=0;i<len;i++){
137         require(prices[i] >= 100 && prices[i] <= 1e30);
138         }
139         return prices;
140     }
141     function oraclePrice(address asset) internal view returns (uint256){
142         uint256 price = _oracle.getPrice(asset);
143         require(price >= 100 && price <= 1e30);
144         return price;
145     }
146     function oracleUnderlyingPrice(uint256 cToken) internal view returns (uint256){
147         uint256 price = _oracle.getUnderlyingPrice(cToken);
148         require(price >= 100 && price <= 1e30);
149         return price;
150     }
151     function oracleAssetAndUnderlyingPrice(address asset,uint256 cToken) internal view returns (uint256,uint256){
152         (uint256 price1,uint256 price2) = _oracle.getAssetAndUnderlyingPrice(asset,cToken);
153         require(price1 >= 100 && price1 <= 1e30);
154         require(price2 >= 100 && price2 <= 1e30);
155         return (price1,price2);
156     }
157     function getOracleAddress() public view returns(address){
158         return address(_oracle);
159     }
160     function setOracleAddress(address oracle)public onlyOwner{
161         _oracle = IFNXOracle(oracle);
162     }
163 }
164 
165 // File: contracts\modules\whiteList.sol
166 
167 pragma solidity =0.5.16;
168     /**
169      * @dev Implementation of a whitelist which filters a eligible uint32.
170      */
171 library whiteListUint32 {
172     /**
173      * @dev add uint32 into white list.
174      * @param whiteList the storage whiteList.
175      * @param temp input value
176      */
177 
178     function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{
179         if (!isEligibleUint32(whiteList,temp)){
180             whiteList.push(temp);
181         }
182     }
183     /**
184      * @dev remove uint32 from whitelist.
185      */
186     function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {
187         uint256 len = whiteList.length;
188         uint256 i=0;
189         for (;i<len;i++){
190             if (whiteList[i] == temp)
191                 break;
192         }
193         if (i<len){
194             if (i!=len-1) {
195                 whiteList[i] = whiteList[len-1];
196             }
197             whiteList.length--;
198             return true;
199         }
200         return false;
201     }
202     function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){
203         uint256 len = whiteList.length;
204         for (uint256 i=0;i<len;i++){
205             if (whiteList[i] == temp)
206                 return true;
207         }
208         return false;
209     }
210     function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){
211         uint256 len = whiteList.length;
212         uint256 i=0;
213         for (;i<len;i++){
214             if (whiteList[i] == temp)
215                 break;
216         }
217         return i;
218     }
219 }
220     /**
221      * @dev Implementation of a whitelist which filters a eligible uint256.
222      */
223 library whiteListUint256 {
224     // add whiteList
225     function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{
226         if (!isEligibleUint256(whiteList,temp)){
227             whiteList.push(temp);
228         }
229     }
230     function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {
231         uint256 len = whiteList.length;
232         uint256 i=0;
233         for (;i<len;i++){
234             if (whiteList[i] == temp)
235                 break;
236         }
237         if (i<len){
238             if (i!=len-1) {
239                 whiteList[i] = whiteList[len-1];
240             }
241             whiteList.length--;
242             return true;
243         }
244         return false;
245     }
246     function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){
247         uint256 len = whiteList.length;
248         for (uint256 i=0;i<len;i++){
249             if (whiteList[i] == temp)
250                 return true;
251         }
252         return false;
253     }
254     function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){
255         uint256 len = whiteList.length;
256         uint256 i=0;
257         for (;i<len;i++){
258             if (whiteList[i] == temp)
259                 break;
260         }
261         return i;
262     }
263 }
264     /**
265      * @dev Implementation of a whitelist which filters a eligible address.
266      */
267 library whiteListAddress {
268     // add whiteList
269     function addWhiteListAddress(address[] storage whiteList,address temp) internal{
270         if (!isEligibleAddress(whiteList,temp)){
271             whiteList.push(temp);
272         }
273     }
274     function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {
275         uint256 len = whiteList.length;
276         uint256 i=0;
277         for (;i<len;i++){
278             if (whiteList[i] == temp)
279                 break;
280         }
281         if (i<len){
282             if (i!=len-1) {
283                 whiteList[i] = whiteList[len-1];
284             }
285             whiteList.length--;
286             return true;
287         }
288         return false;
289     }
290     function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){
291         uint256 len = whiteList.length;
292         for (uint256 i=0;i<len;i++){
293             if (whiteList[i] == temp)
294                 return true;
295         }
296         return false;
297     }
298     function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){
299         uint256 len = whiteList.length;
300         uint256 i=0;
301         for (;i<len;i++){
302             if (whiteList[i] == temp)
303                 break;
304         }
305         return i;
306     }
307 }
308 
309 // File: contracts\modules\underlyingAssets.sol
310 
311 pragma solidity =0.5.16;
312 
313 
314     /**
315      * @dev Implementation of a underlyingAssets filters a eligible underlying.
316      */
317 contract UnderlyingAssets is Ownable {
318     using whiteListUint32 for uint32[];
319     // The eligible underlying list
320     uint32[] internal underlyingAssets;
321     /**
322      * @dev Implementation of add an eligible underlying into the underlyingAssets.
323      * @param underlying new eligible underlying.
324      */
325     function addUnderlyingAsset(uint32 underlying)public onlyOwner{
326         underlyingAssets.addWhiteListUint32(underlying);
327     }
328     function setUnderlyingAsset(uint32[] memory underlyings)public onlyOwner{
329         underlyingAssets = underlyings;
330     }
331     /**
332      * @dev Implementation of revoke an invalid underlying from the underlyingAssets.
333      * @param removeUnderlying revoked underlying.
334      */
335     function removeUnderlyingAssets(uint32 removeUnderlying)public onlyOwner returns(bool) {
336         return underlyingAssets.removeWhiteListUint32(removeUnderlying);
337     }
338     /**
339      * @dev Implementation of getting the eligible underlyingAssets.
340      */
341     function getUnderlyingAssets()public view returns (uint32[] memory){
342         return underlyingAssets;
343     }
344     /**
345      * @dev Implementation of testing whether the input underlying is eligible.
346      * @param underlying input underlying for testing.
347      */    
348     function isEligibleUnderlyingAsset(uint32 underlying) public view returns (bool){
349         return underlyingAssets.isEligibleUint32(underlying);
350     }
351     function _getEligibleUnderlyingIndex(uint32 underlying) internal view returns (uint256){
352         return underlyingAssets._getEligibleIndexUint32(underlying);
353     }
354 }
355 
356 // File: contracts\interfaces\IVolatility.sol
357 
358 pragma solidity =0.5.16;
359 
360 interface IVolatility {
361     function calculateIv(uint32 underlying,uint8 optType,uint256 expiration,uint256 currentPrice,uint256 strikePrice)external view returns (uint256);
362 }
363 contract ImportVolatility is Ownable{
364     IVolatility internal _volatility;
365     function getVolatilityAddress() public view returns(address){
366         return address(_volatility);
367     }
368     function setVolatilityAddress(address volatility)public onlyOwner{
369         _volatility = IVolatility(volatility);
370     }
371 }
372 
373 // File: contracts\interfaces\IOptionsPrice.sol
374 
375 pragma solidity =0.5.16;
376 
377 interface IOptionsPrice {
378     function getOptionsPrice(uint256 currentPrice, uint256 strikePrice, uint256 expiration,uint32 underlying,uint8 optType)external view returns (uint256);
379     function getOptionsPrice_iv(uint256 currentPrice, uint256 strikePrice, uint256 expiration,
380                 uint256 ivNumerator,uint8 optType)external view returns (uint256);
381     function calOptionsPriceRatio(uint256 selfOccupied,uint256 totalOccupied,uint256 totalCollateral) external view returns (uint256);
382 }
383 contract ImportOptionsPrice is Ownable{
384     IOptionsPrice internal _optionsPrice;
385     function getOptionsPriceAddress() public view returns(address){
386         return address(_optionsPrice);
387     }
388     function setOptionsPriceAddress(address optionsPrice)public onlyOwner{
389         _optionsPrice = IOptionsPrice(optionsPrice);
390     }
391 }
392 
393 // File: contracts\modules\Operator.sol
394 
395 pragma solidity =0.5.16;
396 
397 
398 /**
399  * @dev Contract module which provides a basic access control mechanism, where
400  * each operator can be granted exclusive access to specific functions.
401  *
402  */
403 contract Operator is Ownable {
404     using whiteListAddress for address[];
405     address[] private _operatorList;
406     /**
407      * @dev modifier, every operator can be granted exclusive access to specific functions. 
408      *
409      */
410     modifier onlyOperator() {
411         require(_operatorList.isEligibleAddress(msg.sender),"Managerable: caller is not the Operator");
412         _;
413     }
414     /**
415      * @dev modifier, Only indexed operator can be granted exclusive access to specific functions. 
416      *
417      */
418     modifier onlyOperatorIndex(uint256 index) {
419         require(_operatorList.length>index && _operatorList[index] == msg.sender,"Operator: caller is not the eligible Operator");
420         _;
421     }
422     /**
423      * @dev add a new operator by owner. 
424      *
425      */
426     function addOperator(address addAddress)public onlyOwner{
427         _operatorList.addWhiteListAddress(addAddress);
428     }
429     /**
430      * @dev modify indexed operator by owner. 
431      *
432      */
433     function setOperator(uint256 index,address addAddress)public onlyOwner{
434         _operatorList[index] = addAddress;
435     }
436     /**
437      * @dev remove operator by owner. 
438      *
439      */
440     function removeOperator(address removeAddress)public onlyOwner returns (bool){
441         return _operatorList.removeWhiteListAddress(removeAddress);
442     }
443     /**
444      * @dev get all operators. 
445      *
446      */
447     function getOperator()public view returns (address[] memory) {
448         return _operatorList;
449     }
450     /**
451      * @dev set all operators by owner. 
452      *
453      */
454     function setOperators(address[] memory operators)public onlyOwner {
455         _operatorList = operators;
456     }
457 }
458 
459 // File: contracts\modules\ImputRange.sol
460 
461 pragma solidity =0.5.16;
462 
463 
464 contract ImputRange is Ownable {
465     
466     //The maximum input amount limit.
467     uint256 private maxAmount = 1e30;
468     //The minimum input amount limit.
469     uint256 private minAmount = 1e2;
470     
471     modifier InRange(uint256 amount) {
472         require(maxAmount>=amount && minAmount<=amount,"input amount is out of input amount range");
473         _;
474     }
475     /**
476      * @dev Determine whether the input amount is within the valid range
477      * @param Amount Test value which is user input
478      */
479     function isInputAmountInRange(uint256 Amount)public view returns (bool){
480         return(maxAmount>=Amount && minAmount<=Amount);
481     }
482     /*
483     function isInputAmountSmaller(uint256 Amount)public view returns (bool){
484         return maxAmount>=amount;
485     }
486     function isInputAmountLarger(uint256 Amount)public view returns (bool){
487         return minAmount<=amount;
488     }
489     */
490     modifier Smaller(uint256 amount) {
491         require(maxAmount>=amount,"input amount is larger than maximium");
492         _;
493     }
494     modifier Larger(uint256 amount) {
495         require(minAmount<=amount,"input amount is smaller than maximium");
496         _;
497     }
498     /**
499      * @dev get the valid range of input amount
500      */
501     function getInputAmountRange() public view returns(uint256,uint256) {
502         return (minAmount,maxAmount);
503     }
504     /**
505      * @dev set the valid range of input amount
506      * @param _minAmount the minimum input amount limit
507      * @param _maxAmount the maximum input amount limit
508      */
509     function setInputAmountRange(uint256 _minAmount,uint256 _maxAmount) public onlyOwner{
510         minAmount = _minAmount;
511         maxAmount = _maxAmount;
512     }        
513 }
514 
515 // File: contracts\OptionsPool\OptionsData.sol
516 
517 pragma solidity =0.5.16;
518 
519 
520 
521 
522 
523 
524 
525 contract OptionsData is UnderlyingAssets,ImputRange,Managerable,ImportOracle,ImportVolatility,ImportOptionsPrice,Operator{
526 
527         // store option info
528         struct OptionsInfo {
529         address     owner;      // option's owner
530         uint8   	optType;    //0 for call, 1 for put
531         uint24		underlying; // underlying ID, 1 for BTC,2 for ETH
532         uint64      optionsPrice;
533 
534         address     settlement;    //user's settlement paying for option. 
535         uint64      createTime;
536         uint32		expiration; //
537 
538 
539         uint128     amount; 
540         uint128     settlePrice;
541 
542         uint128     strikePrice;    //  strike price		
543         uint32      priceRate;    //underlying Price	
544         uint64      iv;
545         uint32      extra;
546     }
547 
548     uint256 internal limitation = 1 hours;
549     //all options information list
550     OptionsInfo[] internal allOptions;
551     //user options balances
552     mapping(address=>uint64[]) internal optionsBalances;
553     //expiration whitelist
554     uint32[] internal expirationList;
555     
556     // first option position which is needed calculate.
557     uint256 internal netWorthirstOption;
558     // options latest networth balance. store all options's net worth share started from first option.
559     mapping(address=>int256) internal optionsLatestNetWorth;
560 
561     // first option position which is needed calculate.
562     uint256 internal occupiedFirstOption; 
563     //latest calcutated Options Occupied value.
564     uint256 internal callOccupied;
565     uint256 internal putOccupied;
566     //latest Options volatile occupied value when bought or selled options.
567     int256 internal callLatestOccupied;
568     int256 internal putLatestOccupied;
569 
570     /**
571      * @dev Emitted when `owner` create a new option. 
572      * @param owner new option's owner
573      * @param optionID new option's id
574      * @param optionID new option's type 
575      * @param underlying new option's underlying 
576      * @param expiration new option's expiration timestamp
577      * @param strikePrice  new option's strikePrice
578      * @param amount  new option's amount
579      */
580     event CreateOption(address indexed owner,uint256 indexed optionID,uint8 optType,uint32 underlying,uint256 expiration,uint256 strikePrice,uint256 amount);
581     /**
582      * @dev Emitted when `owner` burn `amount` his option which id is `optionID`. 
583      */    
584     event BurnOption(address indexed owner,uint256 indexed optionID,uint amount);
585     event DebugEvent(uint256 id,uint256 value1,uint256 value2);
586 }
587 /*
588 contract OptionsDataV2 is OptionsData{
589         // store option info
590     struct OptionsInfoV2 {
591         uint64     optionID;    //an increasing nubmer id, begin from one.
592         uint64		expiration; // Expiration timestamp
593         uint128     strikePrice;    //strike price
594         uint8   	optType;    //0 for call, 1 for put
595         uint32		underlying; // underlying ID, 1 for BTC,2 for ETH
596         address     owner;      // option's owner
597         uint256     amount;         // mint amount
598     }
599     // store option extra info
600     struct OptionsInfoExV2 {
601         address      settlement;    //user's settlement paying for option. 
602         uint128      tokenTimePrice; //option's buying price based on settlement, used for options share calculation
603         uint128      underlyingPrice;//underlying price when option is created.
604         uint128      fullPrice;      //option's buying price.
605         uint128      ivNumerator;   // option's iv numerator when option is created.
606 //        uint256      ivDenominator;// option's iv denominator when option is created.
607     }
608         //all options information list
609     OptionsInfoV2[] internal allOptionsV2;
610     // all option's extra information map
611     mapping(uint256=>OptionsInfoExV2) internal optionExtraMapV2;
612         //user options balances
613 //    mapping(address=>uint64[]) internal optionsBalancesV2;
614 }
615 */
616 
617 // File: contracts\Proxy\baseProxy.sol
618 
619 pragma solidity =0.5.16;
620 
621 /**
622  * @title  baseProxy Contract
623 
624  */
625 contract baseProxy is Ownable {
626     address public implementation;
627     constructor(address implementation_) public {
628         // Creator of the contract is admin during initialization
629         implementation = implementation_; 
630         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
631         require(success);
632     }
633     function getImplementation()public view returns(address){
634         return implementation;
635     }
636     function setImplementation(address implementation_)public onlyOwner{
637         implementation = implementation_; 
638         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));
639         require(success);
640     }
641 
642     /**
643      * @notice Delegates execution to the implementation contract
644      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
645      * @param data The raw data to delegatecall
646      * @return The returned bytes from the delegatecall
647      */
648     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
649         (bool success, bytes memory returnData) = implementation.delegatecall(data);
650         assembly {
651             if eq(success, 0) {
652                 revert(add(returnData, 0x20), returndatasize)
653             }
654         }
655         return returnData;
656     }
657 
658     /**
659      * @notice Delegates execution to an implementation contract
660      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
661      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
662      * @param data The raw data to delegatecall
663      * @return The returned bytes from the delegatecall
664      */
665     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
666         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
667         assembly {
668             if eq(success, 0) {
669                 revert(add(returnData, 0x20), returndatasize)
670             }
671         }
672         return abi.decode(returnData, (bytes));
673     }
674 
675     function delegateToViewAndReturn() internal view returns (bytes memory) {
676         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
677 
678         assembly {
679             let free_mem_ptr := mload(0x40)
680             returndatacopy(free_mem_ptr, 0, returndatasize)
681 
682             switch success
683             case 0 { revert(free_mem_ptr, returndatasize) }
684             default { return(add(free_mem_ptr, 0x40), returndatasize) }
685         }
686     }
687 
688     function delegateAndReturn() internal returns (bytes memory) {
689         (bool success, ) = implementation.delegatecall(msg.data);
690 
691         assembly {
692             let free_mem_ptr := mload(0x40)
693             returndatacopy(free_mem_ptr, 0, returndatasize)
694 
695             switch success
696             case 0 { revert(free_mem_ptr, returndatasize) }
697             default { return(free_mem_ptr, returndatasize) }
698         }
699     }
700 }
701 
702 // File: contracts\OptionsPool\OptionsProxy.sol
703 
704 pragma solidity =0.5.16;
705 
706 
707 /**
708  * @title  Erc20Delegator Contract
709 
710  */
711 contract OptionsProxy is OptionsData,baseProxy{
712         /**
713      * @dev constructor function , setting contract address.
714      *  oracleAddr FNX oracle contract address
715      *  optionsPriceAddr options price contract address
716      *  ivAddress implied volatility contract address
717      */  
718 
719     constructor(address implementation_,address oracleAddr,address optionsPriceAddr,address ivAddress)
720          baseProxy(implementation_) public  {
721         _oracle = IFNXOracle(oracleAddr);
722         _optionsPrice = IOptionsPrice(optionsPriceAddr);
723         _volatility = IVolatility(ivAddress);
724     }
725     function setTimeLimitation(uint256 /*_limit*/)public{
726         delegateAndReturn();
727     }
728     function getTimeLimitation()public view returns(uint256){
729         delegateToViewAndReturn();
730     }
731     
732     /**
733      * @dev retrieve user's options' id. 
734      *  user user's account.
735      */     
736     function getUserOptionsID(address /*user*/)public view returns(uint64[] memory){
737         delegateToViewAndReturn();
738     }
739     /**
740      * @dev retrieve user's `size` number of options' id. 
741      *  user user's account.
742      *  from user's option list begin positon.
743      *  size retrieve size.
744      */ 
745     function getUserOptionsID(address /*user*/,uint256 /*from*/,uint256 /*size*/)public view returns(uint64[] memory){
746         delegateToViewAndReturn();
747     }
748     /**
749      * @dev retrieve all option list length. 
750      */ 
751     function getOptionInfoLength()public view returns (uint256){
752         delegateToViewAndReturn();
753     }
754     /**
755      * @dev retrieve `size` number of options' information. 
756      *  from all option list begin positon.
757      *  size retrieve size.
758      */     
759     function getOptionInfoList(uint256 /*from*/,uint256 /*size*/)public view 
760                 returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){
761         delegateToViewAndReturn();
762     }
763     /**
764      * @dev retrieve given `ids` options' information. 
765      *  ids retrieved options' id.
766      */   
767     function getOptionInfoListFromID(uint256[] memory /*ids*/)public view 
768                 returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){
769         delegateToViewAndReturn();
770     }
771     /**
772      * @dev retrieve given `optionsId` option's burned limit timestamp. 
773      *  optionsId retrieved option's id.
774      */ 
775     function getOptionsLimitTimeById(uint256 /*optionsId*/)public view returns(uint256){
776         delegateToViewAndReturn();
777     }
778     /**
779      * @dev retrieve given `optionsId` option's information. 
780      *  optionsId retrieved option's id.
781      */ 
782     function getOptionsById(uint256 /*optionsId*/)public view returns(uint256,address,uint8,uint32,uint256,uint256,uint256){
783         delegateToViewAndReturn();
784     }
785     /**
786      * @dev retrieve given `optionsId` option's extra information. 
787      *  optionsId retrieved option's id.
788      */
789     function getOptionsExtraById(uint256 /*optionsId*/)public view returns(address,uint256,uint256,uint256,uint256){
790         delegateToViewAndReturn();
791     }
792     /**
793      * @dev calculate option's exercise worth.
794      *  optionsId option's id
795      *  amount option's amount
796      */
797     function getExerciseWorth(uint256 /*optionsId*/,uint256 /*amount*/)public view returns(uint256){
798         delegateToViewAndReturn();
799     }
800     /**
801      * @dev check option's underlying and expiration.
802      *  expiration option's expiration
803      *  underlying option's underlying
804      */
805     // function buyOptionCheck(uint32 /*expiration*/,uint32 /*underlying*/)public view{
806     //     delegateToViewAndReturn();
807     // }
808     /**
809      * @dev Implementation of add an eligible expiration into the expirationList.
810      *  expiration new eligible expiration.
811      */
812     function addExpiration(uint32 /*expiration*/)public{
813         delegateAndReturn();
814     }
815     /**
816      * @dev Implementation of revoke an invalid expiration from the expirationList.
817      *  removeExpiration revoked expiration.
818      */
819     function removeExpirationList(uint32 /*removeExpiration*/)public returns(bool) {
820         delegateAndReturn();
821     }
822     /**
823      * @dev Implementation of getting the eligible expirationList.
824      */
825     function getExpirationList()public view returns (uint32[] memory){
826         delegateToViewAndReturn();
827     }
828     /**
829      * @dev Implementation of testing whether the input expiration is eligible.
830      *  expiration input expiration for testing.
831      */    
832     function isEligibleExpiration(uint256 /*expiration*/) public view returns (bool){
833         delegateToViewAndReturn();
834     }
835     /**
836      * @dev check option's expiration.
837      *  expiration option's expiration
838      */
839     function checkExpiration(uint256 /*expiration*/) public view{
840         delegateToViewAndReturn();
841     }
842     /**
843      * @dev calculate `amount` number of Option's full price when option is burned.
844      *  optionID  option's optionID
845      *  amount  option's amount
846      */
847     function getBurnedFullPay(uint256 /*optionID*/,uint256 /*amount*/) public view returns(address,uint256){
848         delegateToViewAndReturn();
849     }
850         /**
851      * @dev retrieve collateral occupied calculation information.
852      */    
853     function getOccupiedCalInfo()public view returns(uint256,int256,int256){
854         delegateToViewAndReturn();
855     }
856     /**
857      * @dev calculate collateral occupied value, and modify database, only foundation operator can modify database.
858      */  
859     function setOccupiedCollateral() public {
860         delegateAndReturn();
861     }
862     /**
863      * @dev calculate collateral occupied value.
864      *  lastOption last option's position.
865      *  beginOption begin option's poisiton.
866      *  endOption end option's poisiton.
867      */  
868     function calculatePhaseOccupiedCollateral(uint256 /*lastOption*/,uint256 /*beginOption*/,uint256 /*endOption*/) public view returns(uint256,uint256,uint256,bool){
869         delegateToViewAndReturn();
870     }
871  
872     /**
873      * @dev set collateral occupied value, only foundation operator can modify database.
874      * totalCallOccupied new call options occupied collateral calculation result.
875      * totalPutOccupied new put options occupied collateral calculation result.
876      * beginOption new first valid option's positon.
877      * latestCallOccpied latest call options' occupied value when operater invoke collateral occupied calculation.
878      * latestPutOccpied latest put options' occupied value when operater invoke collateral occupied calculation.
879      */  
880     function setCollateralPhase(uint256 /*totalCallOccupied*/,uint256 /*totalPutOccupied*/,
881         uint256 /*beginOption*/,int256 /*latestCallOccpied*/,int256 /*latestPutOccpied*/) public{
882         delegateAndReturn();
883     }
884     function getAllTotalOccupiedCollateral() public view returns (uint256,uint256){
885         delegateToViewAndReturn();
886     }
887     /**
888      * @dev get call options total collateral occupied value.
889      */ 
890     function getCallTotalOccupiedCollateral() public view returns (uint256) {
891         delegateToViewAndReturn();
892     }
893     /**
894      * @dev get put options total collateral occupied value.
895      */ 
896     function getPutTotalOccupiedCollateral() public view returns (uint256) {
897         delegateToViewAndReturn();
898     }
899     /**
900      * @dev get real total collateral occupied value.
901      */ 
902     function getTotalOccupiedCollateral() public view returns (uint256) {
903         delegateToViewAndReturn();
904     }
905     /**
906      * @dev retrieve all information for net worth calculation. 
907      *  whiteList collateral address whitelist.
908      */ 
909     function getNetWrothCalInfo(address[] memory /*whiteList*/)public view returns(uint256,int256[] memory){
910         delegateToViewAndReturn();
911     }
912     /**
913      * @dev retrieve latest options net worth which paid in settlement coin. 
914      *  settlement settlement coin address.
915      */ 
916     function getNetWrothLatestWorth(address /*settlement*/)public view returns(int256){
917         delegateToViewAndReturn();
918     }
919     /**
920      * @dev set latest options net worth balance, only manager contract can modify database.
921      *  newFirstOption new first valid option position.
922      *  latestNetWorth latest options net worth.
923      *  whiteList eligible collateral address white list.
924      */ 
925     function setSharedState(uint256 /*newFirstOption*/,int256[] memory /*latestNetWorth*/,address[] memory /*whiteList*/) public{
926         delegateAndReturn();
927     }
928     /**
929      * @dev calculate options time shared value,from begin to end in the alloptionsList.
930      *  lastOption the last option position.
931      *  begin the begin options position.
932      *  end the end options position.
933      *  whiteList eligible collateral address white list.
934      */
935     function calRangeSharedPayment(uint256 /*lastOption*/,uint256 /*begin*/,uint256 /*end*/,address[] memory /*whiteList*/)
936             public view returns(int256[] memory,uint256[] memory,uint256){
937         delegateToViewAndReturn();
938     }
939     /**
940      * @dev calculate options payback fall value,from begin to end in the alloptionsList.
941      *  lastOption the last option position.
942      *  begin the begin options position.
943      *  end the end options position.
944      *  whiteList eligible collateral address white list.
945      */
946     function calculatePhaseOptionsFall(uint256 /*lastOption*/,uint256 /*begin*/,uint256 /*end*/,address[] memory /*whiteList*/) public view returns(int256[] memory){
947         delegateToViewAndReturn();
948     }
949 
950     /**
951      * @dev retrieve all information for collateral occupied and net worth calculation.
952      *  whiteList settlement address whitelist.
953      */ 
954     function getOptionCalRangeAll(address[] memory /*whiteList*/)public view returns(uint256,int256,int256,uint256,int256[] memory,uint256,uint256){
955         delegateToViewAndReturn();
956     }
957     /**
958      * @dev create new option,modify collateral occupied and net worth value, only manager contract can invoke this.
959      *  from user's address.
960      *  settlement user's input settlement coin.
961      *  type_ly_exp tuple64 for option type,underlying,expiration.
962      *  strikePrice user's input new option's strike price.
963      *  optionPrice current new option's price, calculated by options price contract.
964      *  amount user's input new option's amount.
965      */ 
966     function createOptions(address /*from*/,address /*settlement*/,uint256 /*type_ly_exp*/,
967     uint128 /*strikePrice*/,uint128 /*underlyingPrice*/,uint128 /*amount*/,uint128 /*settlePrice*/) public returns(uint256) {
968         delegateAndReturn();
969     }
970     /**
971      * @dev burn option,modify collateral occupied and net worth value, only manager contract can invoke this.
972      *  from user's address.
973      *  id user's input option's id.
974      *  amount user's input burned option's amount.
975      *  optionPrice current new option's price, calculated by options price contract.
976      */ 
977     function burnOptions(address /*from*/,uint256 /*id*/,uint256 /*amount*/,uint256 /*optionPrice*/)public{
978         delegateAndReturn();
979     }
980     function getUserAllOptionInfo(address /*user*/)public view 
981         returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){
982         delegateToViewAndReturn();
983     }
984 }