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
113 // File: contracts/modules/Halt.sol
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
142 // File: contracts/modules/whiteList.sol
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
286 // File: contracts/modules/AddressWhiteList.sol
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
343 // File: contracts/OptionsPool/IOptionsPool.sol
344 
345 pragma solidity =0.5.16;
346 
347 interface IOptionsPool {
348 //    function getOptionBalances(address user) external view returns(uint256[]);
349 
350     function createOptions(address from,address settlement,uint256 type_ly_exp,uint256 strikePrice,uint256 underlyingPrice,
351                 uint256 amount)  external;
352     function setSharedState(uint256 newFirstOption,int256[] calldata latestNetWorth,address[] calldata whiteList) external;
353     function getCallTotalOccupiedCollateral() external view returns (uint256);
354     function getPutTotalOccupiedCollateral() external view returns (uint256);
355     function getTotalOccupiedCollateral() external view returns (uint256);
356     function buyOptionCheck(uint256 expiration,uint32 underlying)external view;
357     function burnOptions(address from,uint256 id,uint256 amount,uint256 optionPrice)external;
358     function getOptionsById(uint256 optionsId)external view returns(uint256,address,uint8,uint32,uint256,uint256,uint256);
359     function getExerciseWorth(uint256 optionsId,uint256 amount)external view returns(uint256);
360     function calculatePhaseOptionsFall(uint256 lastOption,uint256 begin,uint256 end,address[] calldata whiteList) external view returns(int256[] memory);
361     function getOptionInfoLength()external view returns (uint256);
362     function getNetWrothCalInfo(address[] calldata whiteList)external view returns(uint256,int256[] memory);
363     function calRangeSharedPayment(uint256 lastOption,uint256 begin,uint256 end,address[] calldata whiteList)external view returns(int256[] memory,uint256[] memory,uint256);
364     function getNetWrothLatestWorth(address settlement)external view returns(int256);
365     function getBurnedFullPay(uint256 optionID,uint256 amount) external view returns(address,uint256);
366 
367 }
368 contract ImportOptionsPool is Ownable{
369     IOptionsPool internal _optionsPool;
370     function getOptionsPoolAddress() public view returns(address){
371         return address(_optionsPool);
372     }
373     function setOptionsPoolAddress(address optionsPool)public onlyOwner{
374         _optionsPool = IOptionsPool(optionsPool);
375     }
376 }
377 
378 // File: contracts/modules/Operator.sol
379 
380 pragma solidity =0.5.16;
381 
382 
383 /**
384  * @dev Contract module which provides a basic access control mechanism, where
385  * each operator can be granted exclusive access to specific functions.
386  *
387  */
388 contract Operator is Ownable {
389     using whiteListAddress for address[];
390     address[] private _operatorList;
391     /**
392      * @dev modifier, every operator can be granted exclusive access to specific functions.
393      *
394      */
395     modifier onlyOperator() {
396         require(_operatorList.isEligibleAddress(msg.sender),"Managerable: caller is not the Operator");
397         _;
398     }
399     /**
400      * @dev modifier, Only indexed operator can be granted exclusive access to specific functions.
401      *
402      */
403     modifier onlyOperatorIndex(uint256 index) {
404         require(_operatorList.length>index && _operatorList[index] == msg.sender,"Operator: caller is not the eligible Operator");
405         _;
406     }
407     /**
408      * @dev add a new operator by owner.
409      *
410      */
411     function addOperator(address addAddress)public onlyOwner{
412         _operatorList.addWhiteListAddress(addAddress);
413     }
414     /**
415      * @dev modify indexed operator by owner.
416      *
417      */
418     function setOperator(uint256 index,address addAddress)public onlyOwner{
419         _operatorList[index] = addAddress;
420     }
421     /**
422      * @dev remove operator by owner.
423      *
424      */
425     function removeOperator(address removeAddress)public onlyOwner returns (bool){
426         return _operatorList.removeWhiteListAddress(removeAddress);
427     }
428     /**
429      * @dev get all operators.
430      *
431      */
432     function getOperator()public view returns (address[] memory) {
433         return _operatorList;
434     }
435     /**
436      * @dev set all operators by owner.
437      *
438      */
439     function setOperators(address[] memory operators)public onlyOwner {
440         _operatorList = operators;
441     }
442 }
443 
444 // File: contracts/CollateralPool/CollateralData.sol
445 
446 pragma solidity =0.5.16;
447 
448 
449 
450 
451 /**
452  * @title collateral pool contract with coin and necessary storage data.
453  * @dev A smart-contract which stores user's deposited collateral.
454  *
455  */
456 contract CollateralData is AddressWhiteList,Managerable,Operator,ImportOptionsPool{
457     struct fraction{
458         uint256 numerator;
459         uint256 denominator;
460     }
461         // The total fees accumulated in the contract
462     mapping (address => uint256) 	internal feeBalances;
463     fraction[] internal FeeRates;
464      /**
465      * @dev Returns the rate of trasaction fee.
466      */
467     uint256 constant internal buyFee = 0;
468     uint256 constant internal sellFee = 1;
469     uint256 constant internal exerciseFee = 2;
470     uint256 constant internal addColFee = 3;
471     uint256 constant internal redeemColFee = 4;
472     event RedeemFee(address indexed recieptor,address indexed settlement,uint256 payback);
473     event AddFee(address indexed settlement,uint256 payback);
474     event TransferPayback(address indexed recieptor,address indexed settlement,uint256 payback);
475 
476     //token net worth balance
477     mapping (address => int256) internal netWorthBalances;
478     //total user deposited collateral balance
479     // map from collateral address to amount
480     mapping (address => uint256) internal collateralBalances;
481     //user total paying for collateral, priced in usd;
482     mapping (address => uint256) internal userCollateralPaying;
483     //user original deposited collateral.
484     //map account -> collateral -> amount
485     mapping (address => mapping (address => uint256)) internal userInputCollateral;
486 }
487 
488 // File: contracts/Proxy/baseProxy.sol
489 
490 pragma solidity =0.5.16;
491 
492 /**
493  * @title  baseProxy Contract
494 
495  */
496 contract baseProxy is Ownable {
497     address public implementation;
498     constructor(address implementation_) public {
499         // Creator of the contract is admin during initialization
500         implementation = implementation_;
501         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
502         require(success);
503     }
504     function getImplementation()public view returns(address){
505         return implementation;
506     }
507     function setImplementation(address implementation_)public onlyOwner{
508         implementation = implementation_;
509         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));
510         require(success);
511     }
512 
513     /**
514      * @notice Delegates execution to the implementation contract
515      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
516      * @param data The raw data to delegatecall
517      * @return The returned bytes from the delegatecall
518      */
519     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
520         (bool success, bytes memory returnData) = implementation.delegatecall(data);
521         assembly {
522             if eq(success, 0) {
523                 revert(add(returnData, 0x20), returndatasize)
524             }
525         }
526         return returnData;
527     }
528 
529     /**
530      * @notice Delegates execution to an implementation contract
531      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
532      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
533      * @param data The raw data to delegatecall
534      * @return The returned bytes from the delegatecall
535      */
536     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
537         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
538         assembly {
539             if eq(success, 0) {
540                 revert(add(returnData, 0x20), returndatasize)
541             }
542         }
543         return abi.decode(returnData, (bytes));
544     }
545 
546     function delegateToViewAndReturn() internal view returns (bytes memory) {
547         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
548 
549         assembly {
550             let free_mem_ptr := mload(0x40)
551             returndatacopy(free_mem_ptr, 0, returndatasize)
552 
553             switch success
554             case 0 { revert(free_mem_ptr, returndatasize) }
555             default { return(add(free_mem_ptr, 0x40), returndatasize) }
556         }
557     }
558 
559     function delegateAndReturn() internal returns (bytes memory) {
560         (bool success, ) = implementation.delegatecall(msg.data);
561 
562         assembly {
563             let free_mem_ptr := mload(0x40)
564             returndatacopy(free_mem_ptr, 0, returndatasize)
565 
566             switch success
567             case 0 { revert(free_mem_ptr, returndatasize) }
568             default { return(free_mem_ptr, returndatasize) }
569         }
570     }
571 }
572 
573 // File: contracts/CollateralPool/CollateralProxy.sol
574 
575 pragma solidity =0.5.16;
576 
577 
578 /**
579  * @title  Erc20Delegator Contract
580 
581  */
582 contract CollateralProxy is CollateralData,baseProxy{
583         /**
584      * @dev constructor function , setting contract address.
585      *  oracleAddr FNX oracle contract address
586      *  optionsPriceAddr options price contract address
587      *  ivAddress implied volatility contract address
588      */
589 
590     constructor(address implementation_,address optionsPool)
591          baseProxy(implementation_) public  {
592         _optionsPool = IOptionsPool(optionsPool);
593     }
594         /**
595      * @dev Transfer colleteral from manager contract to this contract.
596      *  Only manager contract can invoke this function.
597      */
598     function () external payable onlyManager{
599 
600     }
601     function getFeeRate(uint256 /*feeType*/)public view returns (uint256,uint256){
602         delegateToViewAndReturn();
603     }
604     /**
605      * @dev set the rate of trasaction fee.
606      *  feeType the transaction fee type
607      *  numerator the numerator of transaction fee .
608      *  denominator thedenominator of transaction fee.
609      * transaction fee = numerator/denominator;
610      */
611     function setTransactionFee(uint256 /*feeType*/,uint256 /*numerator*/,uint256 /*denominator*/)public{
612         delegateAndReturn();
613     }
614 
615     function getFeeBalance(address /*settlement*/)public view returns(uint256){
616         delegateToViewAndReturn();
617     }
618     function getAllFeeBalances()public view returns(address[] memory,uint256[] memory){
619         delegateToViewAndReturn();
620     }
621     function redeem(address /*currency*/)public{
622         delegateAndReturn();
623     }
624     function redeemAll()public{
625         delegateAndReturn();
626     }
627     function calculateFee(uint256 /*feeType*/,uint256 /*amount*/)public view returns (uint256){
628         delegateToViewAndReturn();
629     }
630         /**
631      * @dev An interface for add transaction fee.
632      *  Only manager contract can invoke this function.
633      *  collateral collateral address, also is the coin for fee.
634      *  amount total transaction amount.
635      *  feeType transaction fee type. see TransactionFee contract
636      */
637     function addTransactionFee(address /*collateral*/,uint256 /*amount*/,uint256 /*feeType*/)public returns (uint256) {
638         delegateAndReturn();
639     }
640     /**
641      * @dev Retrieve user's cost of collateral, priced in USD.
642      *  user input retrieved account
643      */
644     function getUserPayingUsd(address /*user*/)public view returns (uint256){
645         delegateToViewAndReturn();
646     }
647     /**
648      * @dev Retrieve user's amount of the specified collateral.
649      *  user input retrieved account
650      *  collateral input retrieved collateral coin address
651      */
652     function getUserInputCollateral(address /*user*/,address /*collateral*/)public view returns (uint256){
653         delegateToViewAndReturn();
654     }
655     /**
656      * @dev Retrieve collateral balance data.
657      *  collateral input retrieved collateral coin address
658      */
659     function getCollateralBalance(address /*collateral*/)public view returns (uint256){
660         delegateToViewAndReturn();
661     }
662     /**
663      * @dev Opterator user paying data, priced in USD. Only manager contract can modify database.
664      *  user input user account which need add paying amount.
665      *  amount the input paying amount.
666      */
667     function addUserPayingUsd(address /*user*/,uint256 /*amount*/)public{
668         delegateAndReturn();
669     }
670     /**
671      * @dev Opterator user input collateral data. Only manager contract can modify database.
672      *  user input user account which need add input collateral.
673      *  collateral the collateral address.
674      *  amount the input collateral amount.
675      */
676     function addUserInputCollateral(address /*user*/,address /*collateral*/,uint256 /*amount*/)public{
677         delegateAndReturn();
678     }
679     /**
680      * @dev Opterator net worth balance data. Only manager contract can modify database.
681      *  collateral available colleteral address.
682      *  amount collateral net worth increase amount.
683      */
684     function addNetWorthBalance(address /*collateral*/,int256 /*amount*/)public{
685         delegateAndReturn();
686     }
687     /**
688      * @dev Opterator collateral balance data. Only manager contract can modify database.
689      *  collateral available colleteral address.
690      *  amount collateral colleteral increase amount.
691      */
692     function addCollateralBalance(address /*collateral*/,uint256 /*amount*/)public{
693         delegateAndReturn();
694     }
695     /**
696      * @dev Substract user paying data,priced in USD. Only manager contract can modify database.
697      *  user user's account.
698      *  amount user's decrease amount.
699      */
700     function subUserPayingUsd(address /*user*/,uint256 /*amount*/)public{
701         delegateAndReturn();
702     }
703     /**
704      * @dev Substract user's collateral balance. Only manager contract can modify database.
705      *  user user's account.
706      *  collateral collateral address.
707      *  amount user's decrease amount.
708      */
709     function subUserInputCollateral(address /*user*/,address /*collateral*/,uint256 /*amount*/)public{
710         delegateAndReturn();
711     }
712     /**
713      * @dev Substract net worth balance. Only manager contract can modify database.
714      *  collateral collateral address.
715      *  amount the decrease amount.
716      */
717     function subNetWorthBalance(address /*collateral*/,int256 /*amount*/)public{
718         delegateAndReturn();
719     }
720     /**
721      * @dev Substract collateral balance. Only manager contract can modify database.
722      *  collateral collateral address.
723      *  amount the decrease amount.
724      */
725     function subCollateralBalance(address /*collateral*/,uint256 /*amount*/)public{
726         delegateAndReturn();
727     }
728     /**
729      * @dev set user paying data,priced in USD. Only manager contract can modify database.
730      *  user user's account.
731      *  amount user's new amount.
732      */
733     function setUserPayingUsd(address /*user*/,uint256 /*amount*/)public{
734         delegateAndReturn();
735     }
736     /**
737      * @dev set user's collateral balance. Only manager contract can modify database.
738      *  user user's account.
739      *  collateral collateral address.
740      *  amount user's new amount.
741      */
742     function setUserInputCollateral(address /*user*/,address /*collateral*/,uint256 /*amount*/)public{
743         delegateAndReturn();
744     }
745     /**
746      * @dev set net worth balance. Only manager contract can modify database.
747      *  collateral collateral address.
748      *  amount the new amount.
749      */
750     function setNetWorthBalance(address /*collateral*/,int256 /*amount*/)public{
751         delegateAndReturn();
752     }
753     /**
754      * @dev set collateral balance. Only manager contract can modify database.
755      *  collateral collateral address.
756      *  amount the new amount.
757      */
758     function setCollateralBalance(address /*collateral*/,uint256 /*amount*/)public{
759         delegateAndReturn();
760     }
761     /**
762      * @dev Operation for transfer user's payback and deduct transaction fee. Only manager contract can invoke this function.
763      *  recieptor the recieptor account.
764      *  settlement the settlement coin address.
765      *  payback the payback amount
766      *  feeType the transaction fee type. see transactionFee contract
767      */
768     function transferPaybackAndFee(address payable /*recieptor*/,address /*settlement*/,uint256 /*payback*/,
769             uint256 /*feeType*/)public{
770         delegateAndReturn();
771     }
772     /**
773      * @dev Operation for transfer user's payback. Only manager contract can invoke this function.
774      *  recieptor the recieptor account.
775      *  settlement the settlement coin address.
776      *  payback the payback amount
777      */
778     function transferPayback(address payable /*recieptor*/,address /*settlement*/,uint256 /*payback*/)public{
779         delegateAndReturn();
780     }
781     /**
782      * @dev Operation for transfer user's payback and deduct transaction fee for multiple settlement Coin.
783      *       Specially used for redeem collateral.Only manager contract can invoke this function.
784      *  account the recieptor account.
785      *  redeemWorth the redeem worth, priced in USD.
786      *  tmpWhiteList the settlement coin white list
787      *  colBalances the Collateral balance based for user's input collateral.
788      *  PremiumBalances the premium collateral balance if redeem worth is exceeded user's input collateral.
789      *  prices the collateral prices list.
790      */
791     function transferPaybackBalances(address payable /*account*/,uint256 /*redeemWorth*/,
792             address[] memory /*tmpWhiteList*/,uint256[] memory /*colBalances*/,
793             uint256[] memory /*PremiumBalances*/,uint256[] memory /*prices*/)public {
794             delegateAndReturn();
795     }
796     /**
797      * @dev calculate user's input collateral balance and premium collateral balance.
798      *      Specially used for user's redeem collateral.
799      *  account the recieptor account.
800      *  userTotalWorth the user's total FPTCoin worth, priced in USD.
801      *  tmpWhiteList the settlement coin white list
802      *  _RealBalances the real Collateral balance.
803      *  prices the collateral prices list.
804      */
805     function getCollateralAndPremiumBalances(address /*account*/,uint256 /*userTotalWorth*/,address[] memory /*tmpWhiteList*/,
806         uint256[] memory /*_RealBalances*/,uint256[] memory /*prices*/) public view returns(uint256[] memory,uint256[] memory){
807             delegateToViewAndReturn();
808     }
809     function getRealBalance(address /*settlement*/)public view returns(int256){
810         delegateToViewAndReturn();
811     }
812     function getNetWorthBalance(address /*settlement*/)public view returns(uint256){
813         delegateToViewAndReturn();
814     }
815     /**
816      * @dev  The foundation operator want to add some coin to netbalance, which can increase the FPTCoin net worth.
817      *  settlement the settlement coin address which the foundation operator want to transfer in this contract address.
818      *  amount the amount of the settlement coin which the foundation operator want to transfer in this contract address.
819      */
820     function addNetBalance(address /*settlement*/,uint256 /*amount*/) public payable{
821         delegateAndReturn();
822     }
823     /**
824      * @dev Calculate the collateral pool shared worth.
825      * The foundation operator will invoke this function frequently
826      */
827     function calSharedPayment(address[] memory /*_whiteList*/) public{
828         delegateAndReturn();
829     }
830     /**
831      * @dev Set the calculation results of the collateral pool shared worth.
832      * The foundation operator will invoke this function frequently
833      *  newNetworth Current expired options' net worth
834      *  sharedBalances All unexpired options' shared balance distributed by time.
835      *  firstOption The new first unexpired option's index.
836      */
837     function setSharedPayment(address[] memory /*_whiteList*/,int256[] memory /*newNetworth*/,
838             int256[] memory /*sharedBalances*/,uint256 /*firstOption*/) public{
839         delegateAndReturn();
840     }
841 
842 }