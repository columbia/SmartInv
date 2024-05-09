1 // File: contracts/modules/Ownable.sol
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
79 // File: contracts/modules/Managerable.sol
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
113 // File: contracts/interfaces/IFNXOracle.sol
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
126 //    function getSellOptionsPrice(address oToken) external view returns (uint256);
127 //    function getBuyOptionsPrice(address oToken) external view returns (uint256);
128 }
129 contract ImportOracle is Ownable{
130     IFNXOracle internal _oracle;
131     function oraclePrice(address asset) internal view returns (uint256){
132         uint256 price = _oracle.getPrice(asset);
133         require(price >= 100 && price <= 1e30);
134         return price;
135     }
136     function oracleUnderlyingPrice(uint256 cToken) internal view returns (uint256){
137         uint256 price = _oracle.getUnderlyingPrice(cToken);
138         require(price >= 100 && price <= 1e30);
139         return price;
140     }
141     function getOracleAddress() public view returns(address){
142         return address(_oracle);
143     }
144     function setOracleAddress(address oracle)public onlyOwner{
145         _oracle = IFNXOracle(oracle);
146     }
147 }
148 
149 // File: contracts/modules/whiteList.sol
150 
151 pragma solidity =0.5.16;
152     /**
153      * @dev Implementation of a whitelist which filters a eligible uint32.
154      */
155 library whiteListUint32 {
156     /**
157      * @dev add uint32 into white list.
158      * @param whiteList the storage whiteList.
159      * @param temp input value
160      */
161 
162     function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{
163         if (!isEligibleUint32(whiteList,temp)){
164             whiteList.push(temp);
165         }
166     }
167     /**
168      * @dev remove uint32 from whitelist.
169      */
170     function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {
171         uint256 len = whiteList.length;
172         uint256 i=0;
173         for (;i<len;i++){
174             if (whiteList[i] == temp)
175                 break;
176         }
177         if (i<len){
178             if (i!=len-1) {
179                 whiteList[i] = whiteList[len-1];
180             }
181             whiteList.length--;
182             return true;
183         }
184         return false;
185     }
186     function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){
187         uint256 len = whiteList.length;
188         for (uint256 i=0;i<len;i++){
189             if (whiteList[i] == temp)
190                 return true;
191         }
192         return false;
193     }
194     function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){
195         uint256 len = whiteList.length;
196         uint256 i=0;
197         for (;i<len;i++){
198             if (whiteList[i] == temp)
199                 break;
200         }
201         return i;
202     }
203 }
204     /**
205      * @dev Implementation of a whitelist which filters a eligible uint256.
206      */
207 library whiteListUint256 {
208     // add whiteList
209     function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{
210         if (!isEligibleUint256(whiteList,temp)){
211             whiteList.push(temp);
212         }
213     }
214     function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {
215         uint256 len = whiteList.length;
216         uint256 i=0;
217         for (;i<len;i++){
218             if (whiteList[i] == temp)
219                 break;
220         }
221         if (i<len){
222             if (i!=len-1) {
223                 whiteList[i] = whiteList[len-1];
224             }
225             whiteList.length--;
226             return true;
227         }
228         return false;
229     }
230     function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){
231         uint256 len = whiteList.length;
232         for (uint256 i=0;i<len;i++){
233             if (whiteList[i] == temp)
234                 return true;
235         }
236         return false;
237     }
238     function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){
239         uint256 len = whiteList.length;
240         uint256 i=0;
241         for (;i<len;i++){
242             if (whiteList[i] == temp)
243                 break;
244         }
245         return i;
246     }
247 }
248     /**
249      * @dev Implementation of a whitelist which filters a eligible address.
250      */
251 library whiteListAddress {
252     // add whiteList
253     function addWhiteListAddress(address[] storage whiteList,address temp) internal{
254         if (!isEligibleAddress(whiteList,temp)){
255             whiteList.push(temp);
256         }
257     }
258     function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {
259         uint256 len = whiteList.length;
260         uint256 i=0;
261         for (;i<len;i++){
262             if (whiteList[i] == temp)
263                 break;
264         }
265         if (i<len){
266             if (i!=len-1) {
267                 whiteList[i] = whiteList[len-1];
268             }
269             whiteList.length--;
270             return true;
271         }
272         return false;
273     }
274     function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){
275         uint256 len = whiteList.length;
276         for (uint256 i=0;i<len;i++){
277             if (whiteList[i] == temp)
278                 return true;
279         }
280         return false;
281     }
282     function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){
283         uint256 len = whiteList.length;
284         uint256 i=0;
285         for (;i<len;i++){
286             if (whiteList[i] == temp)
287                 break;
288         }
289         return i;
290     }
291 }
292 
293 // File: contracts/modules/underlyingAssets.sol
294 
295 pragma solidity =0.5.16;
296 
297 
298     /**
299      * @dev Implementation of a underlyingAssets filters a eligible underlying.
300      */
301 contract UnderlyingAssets is Ownable {
302     using whiteListUint32 for uint32[];
303     // The eligible underlying list
304     uint32[] internal underlyingAssets;
305     /**
306      * @dev Implementation of add an eligible underlying into the underlyingAssets.
307      * @param underlying new eligible underlying.
308      */
309     function addUnderlyingAsset(uint32 underlying)public onlyOwner{
310         underlyingAssets.addWhiteListUint32(underlying);
311     }
312     /**
313      * @dev Implementation of revoke an invalid underlying from the underlyingAssets.
314      * @param removeUnderlying revoked underlying.
315      */
316     function removeUnderlyingAssets(uint32 removeUnderlying)public onlyOwner returns(bool) {
317         return underlyingAssets.removeWhiteListUint32(removeUnderlying);
318     }
319     /**
320      * @dev Implementation of getting the eligible underlyingAssets.
321      */
322     function getUnderlyingAssets()public view returns (uint32[] memory){
323         return underlyingAssets;
324     }
325     /**
326      * @dev Implementation of testing whether the input underlying is eligible.
327      * @param underlying input underlying for testing.
328      */
329     function isEligibleUnderlyingAsset(uint32 underlying) public view returns (bool){
330         return underlyingAssets.isEligibleUint32(underlying);
331     }
332     function _getEligibleUnderlyingIndex(uint32 underlying) internal view returns (uint256){
333         return underlyingAssets._getEligibleIndexUint32(underlying);
334     }
335 }
336 
337 // File: contracts/interfaces/IVolatility.sol
338 
339 pragma solidity =0.5.16;
340 
341 interface IVolatility {
342     function calculateIv(uint32 underlying,uint8 optType,uint256 expiration,uint256 currentPrice,uint256 strikePrice)external view returns (uint256,uint256);
343 }
344 contract ImportVolatility is Ownable{
345     IVolatility internal _volatility;
346     function getVolatilityAddress() public view returns(address){
347         return address(_volatility);
348     }
349     function setVolatilityAddress(address volatility)public onlyOwner{
350         _volatility = IVolatility(volatility);
351     }
352 }
353 
354 // File: contracts/interfaces/IOptionsPrice.sol
355 
356 pragma solidity =0.5.16;
357 
358 interface IOptionsPrice {
359     function getOptionsPrice(uint256 currentPrice, uint256 strikePrice, uint256 expiration,uint32 underlying,uint8 optType)external view returns (uint256);
360     function getOptionsPrice_iv(uint256 currentPrice, uint256 strikePrice, uint256 expiration,
361                 uint256 ivNumerator,uint256 ivDenominator,uint8 optType)external view returns (uint256);
362     function calOptionsPriceRatio(uint256 selfOccupied,uint256 totalOccupied,uint256 totalCollateral) external view returns (uint256,uint256);
363 }
364 contract ImportOptionsPrice is Ownable{
365     IOptionsPrice internal _optionsPrice;
366     function getOptionsPriceAddress() public view returns(address){
367         return address(_optionsPrice);
368     }
369     function setOptionsPriceAddress(address optionsPrice)public onlyOwner{
370         _optionsPrice = IOptionsPrice(optionsPrice);
371     }
372 }
373 
374 // File: contracts/modules/Operator.sol
375 
376 pragma solidity =0.5.16;
377 
378 
379 /**
380  * @dev Contract module which provides a basic access control mechanism, where
381  * each operator can be granted exclusive access to specific functions.
382  *
383  */
384 contract Operator is Ownable {
385     using whiteListAddress for address[];
386     address[] private _operatorList;
387     /**
388      * @dev modifier, every operator can be granted exclusive access to specific functions.
389      *
390      */
391     modifier onlyOperator() {
392         require(_operatorList.isEligibleAddress(msg.sender),"Managerable: caller is not the Operator");
393         _;
394     }
395     /**
396      * @dev modifier, Only indexed operator can be granted exclusive access to specific functions.
397      *
398      */
399     modifier onlyOperatorIndex(uint256 index) {
400         require(_operatorList.length>index && _operatorList[index] == msg.sender,"Operator: caller is not the eligible Operator");
401         _;
402     }
403     /**
404      * @dev add a new operator by owner.
405      *
406      */
407     function addOperator(address addAddress)public onlyOwner{
408         _operatorList.addWhiteListAddress(addAddress);
409     }
410     /**
411      * @dev modify indexed operator by owner.
412      *
413      */
414     function setOperator(uint256 index,address addAddress)public onlyOwner{
415         _operatorList[index] = addAddress;
416     }
417     /**
418      * @dev remove operator by owner.
419      *
420      */
421     function removeOperator(address removeAddress)public onlyOwner returns (bool){
422         return _operatorList.removeWhiteListAddress(removeAddress);
423     }
424     /**
425      * @dev get all operators.
426      *
427      */
428     function getOperator()public view returns (address[] memory) {
429         return _operatorList;
430     }
431     /**
432      * @dev set all operators by owner.
433      *
434      */
435     function setOperators(address[] memory operators)public onlyOwner {
436         _operatorList = operators;
437     }
438 }
439 
440 // File: contracts/modules/ImputRange.sol
441 
442 pragma solidity =0.5.16;
443 
444 
445 contract ImputRange is Ownable {
446 
447     //The maximum input amount limit.
448     uint256 private maxAmount = 1e30;
449     //The minimum input amount limit.
450     uint256 private minAmount = 1e2;
451 
452     modifier InRange(uint256 amount) {
453         require(maxAmount>=amount && minAmount<=amount,"input amount is out of input amount range");
454         _;
455     }
456     /**
457      * @dev Determine whether the input amount is within the valid range
458      * @param Amount Test value which is user input
459      */
460     function isInputAmountInRange(uint256 Amount)public view returns (bool){
461         return(maxAmount>=Amount && minAmount<=Amount);
462     }
463     /*
464     function isInputAmountSmaller(uint256 Amount)public view returns (bool){
465         return maxAmount>=amount;
466     }
467     function isInputAmountLarger(uint256 Amount)public view returns (bool){
468         return minAmount<=amount;
469     }
470     */
471     modifier Smaller(uint256 amount) {
472         require(maxAmount>=amount,"input amount is larger than maximium");
473         _;
474     }
475     modifier Larger(uint256 amount) {
476         require(minAmount<=amount,"input amount is smaller than maximium");
477         _;
478     }
479     /**
480      * @dev get the valid range of input amount
481      */
482     function getInputAmountRange() public view returns(uint256,uint256) {
483         return (minAmount,maxAmount);
484     }
485     /**
486      * @dev set the valid range of input amount
487      * @param _minAmount the minimum input amount limit
488      * @param _maxAmount the maximum input amount limit
489      */
490     function setInputAmountRange(uint256 _minAmount,uint256 _maxAmount) public onlyOwner{
491         minAmount = _minAmount;
492         maxAmount = _maxAmount;
493     }
494 }
495 
496 // File: contracts/modules/timeLimitation.sol
497 
498 pragma solidity =0.5.16;
499 
500 
501 contract timeLimitation is Ownable {
502 
503     /**
504      * @dev FPT has burn time limit. When user's balance is moved in som coins, he will wait `timeLimited` to burn FPT.
505      * latestTransferIn is user's latest time when his balance is moved in.
506      */
507     mapping(uint256=>uint256) internal itemTimeMap;
508     uint256 internal limitation = 1 hours;
509     /**
510      * @dev set time limitation, only owner can invoke.
511      * @param _limitation new time limitation.
512      */
513     function setTimeLimitation(uint256 _limitation) public onlyOwner {
514         limitation = _limitation;
515     }
516     function setItemTimeLimitation(uint256 item) internal{
517         itemTimeMap[item] = now;
518     }
519     function getTimeLimitation() public view returns (uint256){
520         return limitation;
521     }
522     /**
523      * @dev Retrieve user's start time for burning.
524      * @param item item key.
525      */
526     function getItemTimeLimitation(uint256 item) public view returns (uint256){
527         return itemTimeMap[item]+limitation;
528     }
529     modifier OutLimitation(uint256 item) {
530         require(itemTimeMap[item]+limitation<now,"Time limitation is not expired!");
531         _;
532     }
533 }
534 
535 // File: contracts/OptionsPool/OptionsData.sol
536 
537 pragma solidity =0.5.16;
538 
539 
540 
541 
542 
543 
544 
545 
546 contract OptionsData is UnderlyingAssets,timeLimitation,ImputRange,Managerable,ImportOracle,ImportVolatility,ImportOptionsPrice,Operator{
547         // store option info
548     struct OptionsInfo {
549         uint64     optionID;    //an increasing nubmer id, begin from one.
550         address     owner;      // option's owner
551         uint8   	optType;    //0 for call, 1 for put
552         uint32		underlying; // underlying ID, 1 for BTC,2 for ETH
553         uint256		expiration; // Expiration timestamp
554         uint256     strikePrice;    //strike price
555         uint256     amount;         // mint amount
556     }
557     // store option extra info
558     struct OptionsInfoEx{
559         address      settlement;    //user's settlement paying for option.
560         uint256      tokenTimePrice; //option's buying price based on settlement, used for options share calculation
561         uint256      underlyingPrice;//underlying price when option is created.
562         uint256      fullPrice;      //option's buying price.
563         uint256      ivNumerator;   // option's iv numerator when option is created.
564         uint256      ivDenominator;// option's iv denominator when option is created.
565     }
566     //all options information list
567     OptionsInfo[] internal allOptions;
568     // all option's extra information map
569     mapping(uint256=>OptionsInfoEx) internal optionExtraMap;
570     // option share value calculation's decimal
571     uint256 constant internal calDecimals = 1e18;
572     //user options balances
573     mapping(address=>uint256[]) internal optionsBalances;
574     //expiration whitelist
575     uint256[] internal expirationList;
576 
577     // first option position which is needed calculate.
578     uint256 internal netWorthirstOption;
579     // options latest networth balance. store all options's net worth share started from first option.
580     mapping(address=>int256) internal optionsLatestNetWorth;
581 
582     // first option position which is needed calculate.
583     uint256 internal occupiedFirstOption;
584     //latest calcutated Options Occupied value.
585     uint256 internal callOccupied;
586     uint256 internal putOccupied;
587     //latest Options volatile occupied value when bought or selled options.
588     int256 internal callLatestOccupied;
589     int256 internal putLatestOccupied;
590 
591     /**
592      * @dev Emitted when `owner` create a new option.
593      * @param owner new option's owner
594      * @param optionID new option's id
595      * @param optionID new option's type
596      * @param underlying new option's underlying
597      * @param expiration new option's expiration timestamp
598      * @param strikePrice  new option's strikePrice
599      * @param amount  new option's amount
600      */
601     event CreateOption(address indexed owner,uint256 indexed optionID,uint8 optType,uint32 underlying,uint256 expiration,uint256 strikePrice,uint256 amount);
602     /**
603      * @dev Emitted when `owner` burn `amount` his option which id is `optionID`.
604      */
605     event BurnOption(address indexed owner,uint256 indexed optionID,uint amount);
606 }
607 
608 // File: contracts/Proxy/baseProxy.sol
609 
610 pragma solidity =0.5.16;
611 
612 /**
613  * @title  baseProxy Contract
614 
615  */
616 contract baseProxy is Ownable {
617     address public implementation;
618     constructor(address implementation_) public {
619         // Creator of the contract is admin during initialization
620         implementation = implementation_;
621         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
622         require(success);
623     }
624     function getImplementation()public view returns(address){
625         return implementation;
626     }
627     function setImplementation(address implementation_)public onlyOwner{
628         implementation = implementation_;
629         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));
630         require(success);
631     }
632 
633     /**
634      * @notice Delegates execution to the implementation contract
635      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
636      * @param data The raw data to delegatecall
637      * @return The returned bytes from the delegatecall
638      */
639     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
640         (bool success, bytes memory returnData) = implementation.delegatecall(data);
641         assembly {
642             if eq(success, 0) {
643                 revert(add(returnData, 0x20), returndatasize)
644             }
645         }
646         return returnData;
647     }
648 
649     /**
650      * @notice Delegates execution to an implementation contract
651      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
652      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
653      * @param data The raw data to delegatecall
654      * @return The returned bytes from the delegatecall
655      */
656     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
657         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
658         assembly {
659             if eq(success, 0) {
660                 revert(add(returnData, 0x20), returndatasize)
661             }
662         }
663         return abi.decode(returnData, (bytes));
664     }
665 
666     function delegateToViewAndReturn() internal view returns (bytes memory) {
667         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
668 
669         assembly {
670             let free_mem_ptr := mload(0x40)
671             returndatacopy(free_mem_ptr, 0, returndatasize)
672 
673             switch success
674             case 0 { revert(free_mem_ptr, returndatasize) }
675             default { return(add(free_mem_ptr, 0x40), returndatasize) }
676         }
677     }
678 
679     function delegateAndReturn() internal returns (bytes memory) {
680         (bool success, ) = implementation.delegatecall(msg.data);
681 
682         assembly {
683             let free_mem_ptr := mload(0x40)
684             returndatacopy(free_mem_ptr, 0, returndatasize)
685 
686             switch success
687             case 0 { revert(free_mem_ptr, returndatasize) }
688             default { return(free_mem_ptr, returndatasize) }
689         }
690     }
691 }
692 
693 // File: contracts/OptionsPool/OptionsProxy.sol
694 
695 pragma solidity =0.5.16;
696 
697 
698 /**
699  * @title  Erc20Delegator Contract
700 
701  */
702 contract OptionsProxy is OptionsData,baseProxy{
703         /**
704      * @dev constructor function , setting contract address.
705      *  oracleAddr FNX oracle contract address
706      *  optionsPriceAddr options price contract address
707      *  ivAddress implied volatility contract address
708      */
709 
710     constructor(address implementation_,address oracleAddr,address optionsPriceAddr,address ivAddress)
711          baseProxy(implementation_) public  {
712         _oracle = IFNXOracle(oracleAddr);
713         _optionsPrice = IOptionsPrice(optionsPriceAddr);
714         _volatility = IVolatility(ivAddress);
715     }
716     /**
717      * @dev retrieve user's options' id.
718      *  user user's account.
719      */
720     function getUserOptionsID(address /*user*/)public view returns(uint256[] memory){
721         delegateToViewAndReturn();
722     }
723     /**
724      * @dev retrieve user's `size` number of options' id.
725      *  user user's account.
726      *  from user's option list begin positon.
727      *  size retrieve size.
728      */
729     function getUserOptionsID(address /*user*/,uint256 /*from*/,uint256 /*size*/)public view returns(uint256[] memory){
730         delegateToViewAndReturn();
731     }
732     /**
733      * @dev retrieve all option list length.
734      */
735     function getOptionInfoLength()public view returns (uint256){
736         delegateToViewAndReturn();
737     }
738     /**
739      * @dev retrieve `size` number of options' information.
740      *  from all option list begin positon.
741      *  size retrieve size.
742      */
743     function getOptionInfoList(uint256 /*from*/,uint256 /*size*/)public view
744                 returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){
745         delegateToViewAndReturn();
746     }
747     /**
748      * @dev retrieve given `ids` options' information.
749      *  ids retrieved options' id.
750      */
751     function getOptionInfoListFromID(uint256[] memory /*ids*/)public view
752                 returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){
753         delegateToViewAndReturn();
754     }
755     /**
756      * @dev retrieve given `optionsId` option's burned limit timestamp.
757      *  optionsId retrieved option's id.
758      */
759     function getOptionsLimitTimeById(uint256 /*optionsId*/)public view returns(uint256){
760         delegateToViewAndReturn();
761     }
762     /**
763      * @dev retrieve given `optionsId` option's information.
764      *  optionsId retrieved option's id.
765      */
766     function getOptionsById(uint256 /*optionsId*/)public view returns(uint256,address,uint8,uint32,uint256,uint256,uint256){
767         delegateToViewAndReturn();
768     }
769     /**
770      * @dev retrieve given `optionsId` option's extra information.
771      *  optionsId retrieved option's id.
772      */
773     function getOptionsExtraById(uint256 /*optionsId*/)public view returns(address,uint256,uint256,uint256,uint256,uint256){
774         delegateToViewAndReturn();
775     }
776     /**
777      * @dev calculate option's exercise worth.
778      *  optionsId option's id
779      *  amount option's amount
780      */
781     function getExerciseWorth(uint256 /*optionsId*/,uint256 /*amount*/)public view returns(uint256){
782         delegateToViewAndReturn();
783     }
784     /**
785      * @dev check option's underlying and expiration.
786      *  expiration option's expiration
787      *  underlying option's underlying
788      */
789     function buyOptionCheck(uint256 /*expiration*/,uint32 /*underlying*/)public view{
790         delegateToViewAndReturn();
791     }
792     /**
793      * @dev Implementation of add an eligible expiration into the expirationList.
794      *  expiration new eligible expiration.
795      */
796     function addExpiration(uint256 /*expiration*/)public{
797         delegateAndReturn();
798     }
799     /**
800      * @dev Implementation of revoke an invalid expiration from the expirationList.
801      *  removeExpiration revoked expiration.
802      */
803     function removeExpirationList(uint256 /*removeExpiration*/)public returns(bool) {
804         delegateAndReturn();
805     }
806     /**
807      * @dev Implementation of getting the eligible expirationList.
808      */
809     function getExpirationList()public view returns (uint256[] memory){
810         delegateToViewAndReturn();
811     }
812     /**
813      * @dev Implementation of testing whether the input expiration is eligible.
814      *  expiration input expiration for testing.
815      */
816     function isEligibleExpiration(uint256 /*expiration*/) public view returns (bool){
817         delegateToViewAndReturn();
818     }
819     /**
820      * @dev check option's expiration.
821      *  expiration option's expiration
822      */
823     function checkExpiration(uint256 /*expiration*/) public view{
824         delegateToViewAndReturn();
825     }
826     /**
827      * @dev calculate `amount` number of Option's full price when option is burned.
828      *  optionID  option's optionID
829      *  amount  option's amount
830      */
831     function getBurnedFullPay(uint256 /*optionID*/,uint256 /*amount*/) public view returns(address,uint256){
832         delegateToViewAndReturn();
833     }
834         /**
835      * @dev retrieve collateral occupied calculation information.
836      */
837     function getOccupiedCalInfo()public view returns(uint256,int256,int256){
838         delegateToViewAndReturn();
839     }
840     /**
841      * @dev calculate collateral occupied value, and modify database, only foundation operator can modify database.
842      */
843     function setOccupiedCollateral() public {
844         delegateAndReturn();
845     }
846     /**
847      * @dev calculate collateral occupied value.
848      *  lastOption last option's position.
849      *  beginOption begin option's poisiton.
850      *  endOption end option's poisiton.
851      */
852     function calculatePhaseOccupiedCollateral(uint256 /*lastOption*/,uint256 /*beginOption*/,uint256 /*endOption*/) public view returns(uint256,uint256,uint256,bool){
853         delegateToViewAndReturn();
854     }
855 
856     /**
857      * @dev set collateral occupied value, only foundation operator can modify database.
858      * totalCallOccupied new call options occupied collateral calculation result.
859      * totalPutOccupied new put options occupied collateral calculation result.
860      * beginOption new first valid option's positon.
861      * latestCallOccpied latest call options' occupied value when operater invoke collateral occupied calculation.
862      * latestPutOccpied latest put options' occupied value when operater invoke collateral occupied calculation.
863      */
864     function setCollateralPhase(uint256 /*totalCallOccupied*/,uint256 /*totalPutOccupied*/,
865         uint256 /*beginOption*/,int256 /*latestCallOccpied*/,int256 /*latestPutOccpied*/) public{
866         delegateAndReturn();
867     }
868     /**
869      * @dev get call options total collateral occupied value.
870      */
871     function getCallTotalOccupiedCollateral() public view returns (uint256) {
872         delegateToViewAndReturn();
873     }
874     /**
875      * @dev get put options total collateral occupied value.
876      */
877     function getPutTotalOccupiedCollateral() public view returns (uint256) {
878         delegateToViewAndReturn();
879     }
880     /**
881      * @dev get real total collateral occupied value.
882      */
883     function getTotalOccupiedCollateral() public view returns (uint256) {
884         delegateToViewAndReturn();
885     }
886     /**
887      * @dev retrieve all information for net worth calculation.
888      *  whiteList collateral address whitelist.
889      */
890     function getNetWrothCalInfo(address[] memory /*whiteList*/)public view returns(uint256,int256[] memory){
891         delegateToViewAndReturn();
892     }
893     /**
894      * @dev retrieve latest options net worth which paid in settlement coin.
895      *  settlement settlement coin address.
896      */
897     function getNetWrothLatestWorth(address /*settlement*/)public view returns(int256){
898         delegateToViewAndReturn();
899     }
900     /**
901      * @dev set latest options net worth balance, only manager contract can modify database.
902      *  newFirstOption new first valid option position.
903      *  latestNetWorth latest options net worth.
904      *  whiteList eligible collateral address white list.
905      */
906     function setSharedState(uint256 /*newFirstOption*/,int256[] memory /*latestNetWorth*/,address[] memory /*whiteList*/) public{
907         delegateAndReturn();
908     }
909     /**
910      * @dev calculate options time shared value,from begin to end in the alloptionsList.
911      *  lastOption the last option position.
912      *  begin the begin options position.
913      *  end the end options position.
914      *  whiteList eligible collateral address white list.
915      */
916     function calRangeSharedPayment(uint256 /*lastOption*/,uint256 /*begin*/,uint256 /*end*/,address[] memory /*whiteList*/)
917             public view returns(int256[] memory,uint256[] memory,uint256){
918         delegateToViewAndReturn();
919     }
920     /**
921      * @dev calculate options payback fall value,from begin to end in the alloptionsList.
922      *  lastOption the last option position.
923      *  begin the begin options position.
924      *  end the end options position.
925      *  whiteList eligible collateral address white list.
926      */
927     function calculatePhaseOptionsFall(uint256 /*lastOption*/,uint256 /*begin*/,uint256 /*end*/,address[] memory /*whiteList*/) public view returns(int256[] memory){
928         delegateToViewAndReturn();
929     }
930 
931     /**
932      * @dev retrieve all information for collateral occupied and net worth calculation.
933      *  whiteList settlement address whitelist.
934      */
935     function getOptionCalRangeAll(address[] memory /*whiteList*/)public view returns(uint256,int256,int256,uint256,int256[] memory,uint256,uint256){
936         delegateToViewAndReturn();
937     }
938     /**
939      * @dev create new option,modify collateral occupied and net worth value, only manager contract can invoke this.
940      *  from user's address.
941      *  settlement user's input settlement coin.
942      *  type_ly_exp tuple64 for option type,underlying,expiration.
943      *  strikePrice user's input new option's strike price.
944      *  optionPrice current new option's price, calculated by options price contract.
945      *  amount user's input new option's amount.
946      */
947     function createOptions(address /*from*/,address /*settlement*/,uint256 /*type_ly_exp*/,uint256 /*strikePrice*/,uint256 /*optionPrice*/,
948                 uint256 /*amount*/) public {
949         delegateAndReturn();
950     }
951     /**
952      * @dev burn option,modify collateral occupied and net worth value, only manager contract can invoke this.
953      *  from user's address.
954      *  id user's input option's id.
955      *  amount user's input burned option's amount.
956      *  optionPrice current new option's price, calculated by options price contract.
957      */
958     function burnOptions(address /*from*/,uint256 /*id*/,uint256 /*amount*/,uint256 /*optionPrice*/)public{
959         delegateAndReturn();
960     }
961 }