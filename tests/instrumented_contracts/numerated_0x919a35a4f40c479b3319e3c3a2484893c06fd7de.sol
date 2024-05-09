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
113 // File: contracts\modules\Halt.sol
114 
115 pragma solidity =0.5.16;
116 
117 
118 contract Halt is Ownable {
119     
120     bool private halted = false; 
121     
122     modifier notHalted() {
123         require(!halted,"This contract is halted");
124         _;
125     }
126 
127     modifier isHalted() {
128         require(halted,"This contract is not halted");
129         _;
130     }
131     
132     /// @notice function Emergency situation that requires 
133     /// @notice contribution period to stop or not.
134     function setHalt(bool halt) 
135         public 
136         onlyOwner
137     {
138         halted = halt;
139     }
140 }
141 
142 // File: contracts\modules\whiteList.sol
143 
144 pragma solidity =0.5.16;
145     /**
146      * @dev Implementation of a whitelist which filters a eligible uint32.
147      */
148 library whiteListUint32 {
149     /**
150      * @dev add uint32 into white list.
151      * @param whiteList the storage whiteList.
152      * @param temp input value
153      */
154 
155     function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{
156         if (!isEligibleUint32(whiteList,temp)){
157             whiteList.push(temp);
158         }
159     }
160     /**
161      * @dev remove uint32 from whitelist.
162      */
163     function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {
164         uint256 len = whiteList.length;
165         uint256 i=0;
166         for (;i<len;i++){
167             if (whiteList[i] == temp)
168                 break;
169         }
170         if (i<len){
171             if (i!=len-1) {
172                 whiteList[i] = whiteList[len-1];
173             }
174             whiteList.length--;
175             return true;
176         }
177         return false;
178     }
179     function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){
180         uint256 len = whiteList.length;
181         for (uint256 i=0;i<len;i++){
182             if (whiteList[i] == temp)
183                 return true;
184         }
185         return false;
186     }
187     function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){
188         uint256 len = whiteList.length;
189         uint256 i=0;
190         for (;i<len;i++){
191             if (whiteList[i] == temp)
192                 break;
193         }
194         return i;
195     }
196 }
197     /**
198      * @dev Implementation of a whitelist which filters a eligible uint256.
199      */
200 library whiteListUint256 {
201     // add whiteList
202     function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{
203         if (!isEligibleUint256(whiteList,temp)){
204             whiteList.push(temp);
205         }
206     }
207     function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {
208         uint256 len = whiteList.length;
209         uint256 i=0;
210         for (;i<len;i++){
211             if (whiteList[i] == temp)
212                 break;
213         }
214         if (i<len){
215             if (i!=len-1) {
216                 whiteList[i] = whiteList[len-1];
217             }
218             whiteList.length--;
219             return true;
220         }
221         return false;
222     }
223     function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){
224         uint256 len = whiteList.length;
225         for (uint256 i=0;i<len;i++){
226             if (whiteList[i] == temp)
227                 return true;
228         }
229         return false;
230     }
231     function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){
232         uint256 len = whiteList.length;
233         uint256 i=0;
234         for (;i<len;i++){
235             if (whiteList[i] == temp)
236                 break;
237         }
238         return i;
239     }
240 }
241     /**
242      * @dev Implementation of a whitelist which filters a eligible address.
243      */
244 library whiteListAddress {
245     // add whiteList
246     function addWhiteListAddress(address[] storage whiteList,address temp) internal{
247         if (!isEligibleAddress(whiteList,temp)){
248             whiteList.push(temp);
249         }
250     }
251     function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {
252         uint256 len = whiteList.length;
253         uint256 i=0;
254         for (;i<len;i++){
255             if (whiteList[i] == temp)
256                 break;
257         }
258         if (i<len){
259             if (i!=len-1) {
260                 whiteList[i] = whiteList[len-1];
261             }
262             whiteList.length--;
263             return true;
264         }
265         return false;
266     }
267     function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){
268         uint256 len = whiteList.length;
269         for (uint256 i=0;i<len;i++){
270             if (whiteList[i] == temp)
271                 return true;
272         }
273         return false;
274     }
275     function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){
276         uint256 len = whiteList.length;
277         uint256 i=0;
278         for (;i<len;i++){
279             if (whiteList[i] == temp)
280                 break;
281         }
282         return i;
283     }
284 }
285 
286 // File: contracts\modules\AddressWhiteList.sol
287 
288 pragma solidity =0.5.16;
289 
290 
291     /**
292      * @dev Implementation of a whitelist filters a eligible address.
293      */
294 contract AddressWhiteList is Halt {
295 
296     using whiteListAddress for address[];
297     uint256 constant internal allPermission = 0xffffffff;
298     uint256 constant internal allowBuyOptions = 1;
299     uint256 constant internal allowSellOptions = 1<<1;
300     uint256 constant internal allowExerciseOptions = 1<<2;
301     uint256 constant internal allowAddCollateral = 1<<3;
302     uint256 constant internal allowRedeemCollateral = 1<<4;
303     // The eligible adress list
304     address[] internal whiteList;
305     mapping(address => uint256) internal addressPermission;
306     /**
307      * @dev Implementation of add an eligible address into the whitelist.
308      * @param addAddress new eligible address.
309      */
310     function addWhiteList(address addAddress)public onlyOwner{
311         whiteList.addWhiteListAddress(addAddress);
312         addressPermission[addAddress] = allPermission;
313     }
314     function modifyPermission(address addAddress,uint256 permission)public onlyOwner{
315         addressPermission[addAddress] = permission;
316     }
317     /**
318      * @dev Implementation of revoke an invalid address from the whitelist.
319      * @param removeAddress revoked address.
320      */
321     function removeWhiteList(address removeAddress)public onlyOwner returns (bool){
322         addressPermission[removeAddress] = 0;
323         return whiteList.removeWhiteListAddress(removeAddress);
324     }
325     /**
326      * @dev Implementation of getting the eligible whitelist.
327      */
328     function getWhiteList()public view returns (address[] memory){
329         return whiteList;
330     }
331     /**
332      * @dev Implementation of testing whether the input address is eligible.
333      * @param tmpAddress input address for testing.
334      */    
335     function isEligibleAddress(address tmpAddress) public view returns (bool){
336         return whiteList.isEligibleAddress(tmpAddress);
337     }
338     function checkAddressPermission(address tmpAddress,uint256 state) public view returns (bool){
339         return  (addressPermission[tmpAddress]&state) == state;
340     }
341 }
342 
343 // File: contracts\OptionsPool\IOptionsPool.sol
344 
345 pragma solidity =0.5.16;
346 
347 interface IOptionsPool {
348 //    function getOptionBalances(address user) external view returns(uint256[]);
349 
350     function getExpirationList()external view returns (uint32[] memory);
351     function createOptions(address from,address settlement,uint256 type_ly_expiration,
352         uint128 strikePrice,uint128 underlyingPrice,uint128 amount,uint128 settlePrice) external returns(uint256);
353     function setSharedState(uint256 newFirstOption,int256[] calldata latestNetWorth,address[] calldata whiteList) external;
354     function getAllTotalOccupiedCollateral() external view returns (uint256,uint256);
355     function getCallTotalOccupiedCollateral() external view returns (uint256);
356     function getPutTotalOccupiedCollateral() external view returns (uint256);
357     function getTotalOccupiedCollateral() external view returns (uint256);
358 //    function buyOptionCheck(uint32 expiration,uint32 underlying)external view;
359     function burnOptions(address from,uint256 id,uint256 amount,uint256 optionPrice)external;
360     function getOptionsById(uint256 optionsId)external view returns(uint256,address,uint8,uint32,uint256,uint256,uint256);
361     function getExerciseWorth(uint256 optionsId,uint256 amount)external view returns(uint256);
362     function calculatePhaseOptionsFall(uint256 lastOption,uint256 begin,uint256 end,address[] calldata whiteList) external view returns(int256[] memory);
363     function getOptionInfoLength()external view returns (uint256);
364     function getNetWrothCalInfo(address[] calldata whiteList)external view returns(uint256,int256[] memory);
365     function calRangeSharedPayment(uint256 lastOption,uint256 begin,uint256 end,address[] calldata whiteList)external view returns(int256[] memory,uint256[] memory,uint256);
366     function getNetWrothLatestWorth(address settlement)external view returns(int256);
367     function getBurnedFullPay(uint256 optionID,uint256 amount) external view returns(address,uint256);
368 
369 }
370 contract ImportOptionsPool is Ownable{
371     IOptionsPool internal _optionsPool;
372     function getOptionsPoolAddress() public view returns(address){
373         return address(_optionsPool);
374     }
375     function setOptionsPoolAddress(address optionsPool)public onlyOwner{
376         _optionsPool = IOptionsPool(optionsPool);
377     }
378 }
379 
380 // File: contracts\modules\Operator.sol
381 
382 pragma solidity =0.5.16;
383 
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * each operator can be granted exclusive access to specific functions.
388  *
389  */
390 contract Operator is Ownable {
391     using whiteListAddress for address[];
392     address[] private _operatorList;
393     /**
394      * @dev modifier, every operator can be granted exclusive access to specific functions. 
395      *
396      */
397     modifier onlyOperator() {
398         require(_operatorList.isEligibleAddress(msg.sender),"Managerable: caller is not the Operator");
399         _;
400     }
401     /**
402      * @dev modifier, Only indexed operator can be granted exclusive access to specific functions. 
403      *
404      */
405     modifier onlyOperatorIndex(uint256 index) {
406         require(_operatorList.length>index && _operatorList[index] == msg.sender,"Operator: caller is not the eligible Operator");
407         _;
408     }
409     /**
410      * @dev add a new operator by owner. 
411      *
412      */
413     function addOperator(address addAddress)public onlyOwner{
414         _operatorList.addWhiteListAddress(addAddress);
415     }
416     /**
417      * @dev modify indexed operator by owner. 
418      *
419      */
420     function setOperator(uint256 index,address addAddress)public onlyOwner{
421         _operatorList[index] = addAddress;
422     }
423     /**
424      * @dev remove operator by owner. 
425      *
426      */
427     function removeOperator(address removeAddress)public onlyOwner returns (bool){
428         return _operatorList.removeWhiteListAddress(removeAddress);
429     }
430     /**
431      * @dev get all operators. 
432      *
433      */
434     function getOperator()public view returns (address[] memory) {
435         return _operatorList;
436     }
437     /**
438      * @dev set all operators by owner. 
439      *
440      */
441     function setOperators(address[] memory operators)public onlyOwner {
442         _operatorList = operators;
443     }
444 }
445 
446 // File: contracts\CollateralPool\CollateralData.sol
447 
448 pragma solidity =0.5.16;
449 
450 
451 
452 
453 /**
454  * @title collateral pool contract with coin and necessary storage data.
455  * @dev A smart-contract which stores user's deposited collateral.
456  *
457  */
458 contract CollateralData is AddressWhiteList,Managerable,Operator,ImportOptionsPool{
459         // The total fees accumulated in the contract
460     mapping (address => uint256) 	internal feeBalances;
461     uint32[] internal FeeRates;
462      /**
463      * @dev Returns the rate of trasaction fee.
464      */   
465     uint256 constant internal buyFee = 0;
466     uint256 constant internal sellFee = 1;
467     uint256 constant internal exerciseFee = 2;
468     uint256 constant internal addColFee = 3;
469     uint256 constant internal redeemColFee = 4;
470     event RedeemFee(address indexed recieptor,address indexed settlement,uint256 payback);
471     event AddFee(address indexed settlement,uint256 payback);
472     event TransferPayback(address indexed recieptor,address indexed settlement,uint256 payback);
473 
474     //token net worth balance
475     mapping (address => int256) internal netWorthBalances;
476     //total user deposited collateral balance
477     // map from collateral address to amount
478     mapping (address => uint256) internal collateralBalances;
479     //user total paying for collateral, priced in usd;
480     mapping (address => uint256) internal userCollateralPaying;
481     //user original deposited collateral.
482     //map account -> collateral -> amount
483     mapping (address => mapping (address => uint256)) internal userInputCollateral;
484 }
485 
486 // File: contracts\Proxy\baseProxy.sol
487 
488 pragma solidity =0.5.16;
489 
490 /**
491  * @title  baseProxy Contract
492 
493  */
494 contract baseProxy is Ownable {
495     address public implementation;
496     constructor(address implementation_) public {
497         // Creator of the contract is admin during initialization
498         implementation = implementation_; 
499         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
500         require(success);
501     }
502     function getImplementation()public view returns(address){
503         return implementation;
504     }
505     function setImplementation(address implementation_)public onlyOwner{
506         implementation = implementation_; 
507         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));
508         require(success);
509     }
510 
511     /**
512      * @notice Delegates execution to the implementation contract
513      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
514      * @param data The raw data to delegatecall
515      * @return The returned bytes from the delegatecall
516      */
517     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
518         (bool success, bytes memory returnData) = implementation.delegatecall(data);
519         assembly {
520             if eq(success, 0) {
521                 revert(add(returnData, 0x20), returndatasize)
522             }
523         }
524         return returnData;
525     }
526 
527     /**
528      * @notice Delegates execution to an implementation contract
529      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
530      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
531      * @param data The raw data to delegatecall
532      * @return The returned bytes from the delegatecall
533      */
534     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
535         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
536         assembly {
537             if eq(success, 0) {
538                 revert(add(returnData, 0x20), returndatasize)
539             }
540         }
541         return abi.decode(returnData, (bytes));
542     }
543 
544     function delegateToViewAndReturn() internal view returns (bytes memory) {
545         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
546 
547         assembly {
548             let free_mem_ptr := mload(0x40)
549             returndatacopy(free_mem_ptr, 0, returndatasize)
550 
551             switch success
552             case 0 { revert(free_mem_ptr, returndatasize) }
553             default { return(add(free_mem_ptr, 0x40), returndatasize) }
554         }
555     }
556 
557     function delegateAndReturn() internal returns (bytes memory) {
558         (bool success, ) = implementation.delegatecall(msg.data);
559 
560         assembly {
561             let free_mem_ptr := mload(0x40)
562             returndatacopy(free_mem_ptr, 0, returndatasize)
563 
564             switch success
565             case 0 { revert(free_mem_ptr, returndatasize) }
566             default { return(free_mem_ptr, returndatasize) }
567         }
568     }
569 }
570 
571 // File: contracts\CollateralPool\CollateralProxy.sol
572 
573 pragma solidity =0.5.16;
574 
575 
576 /**
577  * @title  Erc20Delegator Contract
578 
579  */
580 contract CollateralProxy is CollateralData,baseProxy{
581         /**
582      * @dev constructor function , setting contract address.
583      *  oracleAddr FNX oracle contract address
584      *  optionsPriceAddr options price contract address
585      *  ivAddress implied volatility contract address
586      */  
587 
588     constructor(address implementation_,address optionsPool)
589          baseProxy(implementation_) public  {
590         _optionsPool = IOptionsPool(optionsPool);
591     }
592         /**
593      * @dev Transfer colleteral from manager contract to this contract.
594      *  Only manager contract can invoke this function.
595      */
596     function () external payable onlyManager{
597 
598     }
599     function getFeeRateAll()public view returns (uint32[] memory){
600         delegateToViewAndReturn();
601     }
602     function getFeeRate(uint256 /*feeType*/)public view returns (uint32){
603         delegateToViewAndReturn();
604     }
605     /**
606      * @dev set the rate of trasaction fee.
607      *  feeType the transaction fee type
608      *  numerator the numerator of transaction fee .
609      *  denominator thedenominator of transaction fee.
610      * transaction fee = numerator/denominator;
611      */   
612     function setTransactionFee(uint256 /*feeType*/,uint32 /*thousandth*/)public{
613         delegateAndReturn();
614     }
615 
616     function getFeeBalance(address /*settlement*/)public view returns(uint256){
617         delegateToViewAndReturn();
618     }
619     function getAllFeeBalances()public view returns(address[] memory,uint256[] memory){
620         delegateToViewAndReturn();
621     }
622     function redeem(address /*currency*/)public{
623         delegateAndReturn();
624     }
625     function redeemAll()public{
626         delegateAndReturn();
627     }
628     function calculateFee(uint256 /*feeType*/,uint256 /*amount*/)public view returns (uint256){
629         delegateToViewAndReturn();
630     }
631         /**
632      * @dev An interface for add transaction fee.
633      *  Only manager contract can invoke this function.
634      *  collateral collateral address, also is the coin for fee.
635      *  amount total transaction amount.
636      *  feeType transaction fee type. see TransactionFee contract
637      */
638     function addTransactionFee(address /*collateral*/,uint256 /*amount*/,uint256 /*feeType*/)public returns (uint256) {
639         delegateAndReturn();
640     }
641     /**
642      * @dev Retrieve user's cost of collateral, priced in USD.
643      *  user input retrieved account 
644      */
645     function getUserPayingUsd(address /*user*/)public view returns (uint256){
646         delegateToViewAndReturn();
647     }
648     /**
649      * @dev Retrieve user's amount of the specified collateral.
650      *  user input retrieved account 
651      *  collateral input retrieved collateral coin address 
652      */
653     function getUserInputCollateral(address /*user*/,address /*collateral*/)public view returns (uint256){
654         delegateToViewAndReturn();
655     }
656     /**
657      * @dev Retrieve collateral balance data.
658      *  collateral input retrieved collateral coin address 
659      */
660     function getCollateralBalance(address /*collateral*/)public view returns (uint256){
661         delegateToViewAndReturn();
662     }
663     /**
664      * @dev Opterator user paying data, priced in USD. Only manager contract can modify database.
665      *  user input user account which need add paying amount.
666      *  amount the input paying amount.
667      */
668     function addUserPayingUsd(address /*user*/,uint256 /*amount*/)public{
669         delegateAndReturn();
670     }
671     /**
672      * @dev Opterator user input collateral data. Only manager contract can modify database.
673      *  user input user account which need add input collateral.
674      *  collateral the collateral address.
675      *  amount the input collateral amount.
676      */
677     function addUserInputCollateral(address /*user*/,address /*collateral*/,uint256 /*amount*/)public{
678         delegateAndReturn();
679     }
680     /**
681      * @dev Opterator net worth balance data. Only manager contract can modify database.
682      *  collateral available colleteral address.
683      *  amount collateral net worth increase amount.
684      */
685     function addNetWorthBalance(address /*collateral*/,int256 /*amount*/)public{
686         delegateAndReturn();
687     }
688     /**
689      * @dev Opterator collateral balance data. Only manager contract can modify database.
690      *  collateral available colleteral address.
691      *  amount collateral colleteral increase amount.
692      */
693     function addCollateralBalance(address /*collateral*/,uint256 /*amount*/)public{
694         delegateAndReturn();
695     }
696     /**
697      * @dev Substract user paying data,priced in USD. Only manager contract can modify database.
698      *  user user's account.
699      *  amount user's decrease amount.
700      */
701     function subUserPayingUsd(address /*user*/,uint256 /*amount*/)public{
702         delegateAndReturn();
703     }
704     /**
705      * @dev Substract user's collateral balance. Only manager contract can modify database.
706      *  user user's account.
707      *  collateral collateral address.
708      *  amount user's decrease amount.
709      */
710     function subUserInputCollateral(address /*user*/,address /*collateral*/,uint256 /*amount*/)public{
711         delegateAndReturn();
712     }
713     /**
714      * @dev Substract net worth balance. Only manager contract can modify database.
715      *  collateral collateral address.
716      *  amount the decrease amount.
717      */
718     function subNetWorthBalance(address /*collateral*/,int256 /*amount*/)public{
719         delegateAndReturn();
720     }
721     /**
722      * @dev Substract collateral balance. Only manager contract can modify database.
723      *  collateral collateral address.
724      *  amount the decrease amount.
725      */
726     function subCollateralBalance(address /*collateral*/,uint256 /*amount*/)public{
727         delegateAndReturn();
728     }
729     /**
730      * @dev set user paying data,priced in USD. Only manager contract can modify database.
731      *  user user's account.
732      *  amount user's new amount.
733      */
734     function setUserPayingUsd(address /*user*/,uint256 /*amount*/)public{
735         delegateAndReturn();
736     }
737     /**
738      * @dev set user's collateral balance. Only manager contract can modify database.
739      *  user user's account.
740      *  collateral collateral address.
741      *  amount user's new amount.
742      */
743     function setUserInputCollateral(address /*user*/,address /*collateral*/,uint256 /*amount*/)public{
744         delegateAndReturn();
745     }
746     /**
747      * @dev set net worth balance. Only manager contract can modify database.
748      *  collateral collateral address.
749      *  amount the new amount.
750      */
751     function setNetWorthBalance(address /*collateral*/,int256 /*amount*/)public{
752         delegateAndReturn();
753     }
754     /**
755      * @dev set collateral balance. Only manager contract can modify database.
756      *  collateral collateral address.
757      *  amount the new amount.
758      */
759     function setCollateralBalance(address /*collateral*/,uint256 /*amount*/)public{
760         delegateAndReturn();
761     }
762     /**
763      * @dev Operation for transfer user's payback and deduct transaction fee. Only manager contract can invoke this function.
764      *  recieptor the recieptor account.
765      *  settlement the settlement coin address.
766      *  payback the payback amount
767      *  feeType the transaction fee type. see transactionFee contract
768      */
769     function transferPaybackAndFee(address payable /*recieptor*/,address /*settlement*/,uint256 /*payback*/,
770             uint256 /*feeType*/)public{
771         delegateAndReturn();
772     }
773     function buyOptionsPayfor(address payable /*recieptor*/,address /*settlement*/,uint256 /*settlementAmount*/,uint256 /*allPay*/)public onlyManager{
774         delegateAndReturn();
775     }
776     /**
777      * @dev Operation for transfer user's payback. Only manager contract can invoke this function.
778      *  recieptor the recieptor account.
779      *  settlement the settlement coin address.
780      *  payback the payback amount
781      */
782     function transferPayback(address payable /*recieptor*/,address /*settlement*/,uint256 /*payback*/)public{
783         delegateAndReturn();
784     }
785     /**
786      * @dev Operation for transfer user's payback and deduct transaction fee for multiple settlement Coin.
787      *       Specially used for redeem collateral.Only manager contract can invoke this function.
788      *  account the recieptor account.
789      *  redeemWorth the redeem worth, priced in USD.
790      *  tmpWhiteList the settlement coin white list
791      *  colBalances the Collateral balance based for user's input collateral.
792      *  PremiumBalances the premium collateral balance if redeem worth is exceeded user's input collateral.
793      *  prices the collateral prices list.
794      */
795     function transferPaybackBalances(address payable /*account*/,uint256 /*redeemWorth*/,
796             address[] memory /*tmpWhiteList*/,uint256[] memory /*colBalances*/,
797             uint256[] memory /*PremiumBalances*/,uint256[] memory /*prices*/)public {
798             delegateAndReturn();
799     }
800     /**
801      * @dev calculate user's input collateral balance and premium collateral balance.
802      *      Specially used for user's redeem collateral.
803      *  account the recieptor account.
804      *  userTotalWorth the user's total FPTCoin worth, priced in USD.
805      *  tmpWhiteList the settlement coin white list
806      *  _RealBalances the real Collateral balance.
807      *  prices the collateral prices list.
808      */
809     function getCollateralAndPremiumBalances(address /*account*/,uint256 /*userTotalWorth*/,address[] memory /*tmpWhiteList*/,
810         uint256[] memory /*_RealBalances*/,uint256[] memory /*prices*/) public view returns(uint256[] memory,uint256[] memory){
811             delegateToViewAndReturn();
812     } 
813     function getAllRealBalance(address[] memory /*whiteList*/)public view returns(int256[] memory){
814         delegateToViewAndReturn();
815     }
816     function getRealBalance(address /*settlement*/)public view returns(int256){
817         delegateToViewAndReturn();
818     }
819     function getNetWorthBalance(address /*settlement*/)public view returns(uint256){
820         delegateToViewAndReturn();
821     }
822     /**
823      * @dev  The foundation operator want to add some coin to netbalance, which can increase the FPTCoin net worth.
824      *  settlement the settlement coin address which the foundation operator want to transfer in this contract address.
825      *  amount the amount of the settlement coin which the foundation operator want to transfer in this contract address.
826      */
827     function addNetBalance(address /*settlement*/,uint256 /*amount*/) public payable{
828         delegateAndReturn();
829     }
830     /**
831      * @dev Calculate the collateral pool shared worth.
832      * The foundation operator will invoke this function frequently
833      */
834     function calSharedPayment(address[] memory /*_whiteList*/) public{
835         delegateAndReturn();
836     }
837     /**
838      * @dev Set the calculation results of the collateral pool shared worth.
839      * The foundation operator will invoke this function frequently
840      *  newNetworth Current expired options' net worth 
841      *  sharedBalances All unexpired options' shared balance distributed by time.
842      *  firstOption The new first unexpired option's index.
843      */
844     function setSharedPayment(address[] memory /*_whiteList*/,int256[] memory /*newNetworth*/,
845             int256[] memory /*sharedBalances*/,uint256 /*firstOption*/) public{
846         delegateAndReturn();
847     }
848 
849 }