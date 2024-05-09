1 pragma solidity ^0.4.23;
2 
3 // File: contracts/libs/ERC20.sol
4 
5 interface ERC20 {
6     function totalSupply() external view returns (uint supply);
7     function balanceOf(address _owner) external  view returns (uint balance);
8     function transfer(address _to, uint _value) external returns (bool success);
9     function transferFrom(address _from, address _to, uint _value) external  returns (bool success);
10     function approve(address _spender, uint _value) external returns (bool success);
11     function allowance(address _owner, address _spender) external view returns (uint remaining);
12     function decimals() external view returns(uint digits);
13     event Transfer(address indexed _from, address indexed _to, uint _value);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 // File: contracts/libs/utils.sol
18 
19 library Utils {
20 
21     uint  constant PRECISION = (10**18);
22     uint  constant MAX_DECIMALS = 18;
23 
24     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
25         if( dstDecimals >= srcDecimals ) {
26             require((dstDecimals-srcDecimals) <= MAX_DECIMALS);
27             return (srcQty * rate * (10**(dstDecimals-srcDecimals))) / PRECISION;
28         } else {
29             require((srcDecimals-dstDecimals) <= MAX_DECIMALS);
30             return (srcQty * rate) / (PRECISION * (10**(srcDecimals-dstDecimals)));
31         }
32     }
33 
34     // function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
35     //     if( srcDecimals >= dstDecimals ) {
36     //         require((srcDecimals-dstDecimals) <= MAX_DECIMALS);
37     //         return (PRECISION * dstQty * (10**(srcDecimals - dstDecimals))) / rate;
38     //     } else {
39     //         require((dstDecimals-srcDecimals) <= MAX_DECIMALS);
40     //         return (PRECISION * dstQty) / (rate * (10**(dstDecimals - srcDecimals)));
41     //     }
42     // }
43 }
44 
45 // File: contracts/libs/Manageable.sol
46 
47 contract Manageable {
48     event ProviderUpdated (uint8 name, address hash);
49 
50     // This is used to hold the addresses of the providers
51     mapping (uint8 => address) public subContracts;
52     modifier onlyOwner() {
53         // Make sure that this function can't be used without being overridden
54         require(true == false);
55         _;
56     }
57 
58     function setProvider(uint8 _id, address _providerAddress) public onlyOwner returns (bool success) {
59         require(_providerAddress != address(0));
60         subContracts[_id] = _providerAddress;
61         emit ProviderUpdated(_id, _providerAddress);
62 
63         return true;
64     }
65 }
66 
67 // File: contracts/libs/Provider.sol
68 
69 library TypeDefinitions {
70 
71     enum ProviderType {
72         Strategy,
73         Price,
74         Exchange,
75         Storage,
76         ExtendedStorage,
77         Whitelist
78     }
79 
80     struct ProviderStatistic {
81         uint counter;
82         uint amountInEther;
83         uint reputation;
84     }
85 
86     struct ERC20Token {
87         string symbol;
88         address tokenAddress;
89         uint decimal;
90     }
91 }
92 
93 contract Provider is Manageable {
94     string public name;
95     TypeDefinitions.ProviderType public providerType;
96     string public description;
97     mapping(string => bool) internal properties;
98     TypeDefinitions.ProviderStatistic public statistics;
99 }
100 
101 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
102 
103 /**
104  * @title Roles
105  * @author Francisco Giordano (@frangio)
106  * @dev Library for managing addresses assigned to a Role.
107  *      See RBAC.sol for example usage.
108  */
109 library Roles {
110   struct Role {
111     mapping (address => bool) bearer;
112   }
113 
114   /**
115    * @dev give an address access to this role
116    */
117   function add(Role storage role, address addr)
118     internal
119   {
120     role.bearer[addr] = true;
121   }
122 
123   /**
124    * @dev remove an address' access to this role
125    */
126   function remove(Role storage role, address addr)
127     internal
128   {
129     role.bearer[addr] = false;
130   }
131 
132   /**
133    * @dev check if an address has this role
134    * // reverts
135    */
136   function check(Role storage role, address addr)
137     view
138     internal
139   {
140     require(has(role, addr));
141   }
142 
143   /**
144    * @dev check if an address has this role
145    * @return bool
146    */
147   function has(Role storage role, address addr)
148     view
149     internal
150     returns (bool)
151   {
152     return role.bearer[addr];
153   }
154 }
155 
156 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
157 
158 /**
159  * @title RBAC (Role-Based Access Control)
160  * @author Matt Condon (@Shrugs)
161  * @dev Stores and provides setters and getters for roles and addresses.
162  *      Supports unlimited numbers of roles and addresses.
163  *      See //contracts/mocks/RBACMock.sol for an example of usage.
164  * This RBAC method uses strings to key roles. It may be beneficial
165  *  for you to write your own implementation of this interface using Enums or similar.
166  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
167  *  to avoid typos.
168  */
169 contract RBAC {
170   using Roles for Roles.Role;
171 
172   mapping (string => Roles.Role) private roles;
173 
174   event RoleAdded(address addr, string roleName);
175   event RoleRemoved(address addr, string roleName);
176 
177   /**
178    * A constant role name for indicating admins.
179    */
180   string public constant ROLE_ADMIN = "admin";
181 
182   /**
183    * @dev constructor. Sets msg.sender as admin by default
184    */
185   function RBAC()
186     public
187   {
188     addRole(msg.sender, ROLE_ADMIN);
189   }
190 
191   /**
192    * @dev reverts if addr does not have role
193    * @param addr address
194    * @param roleName the name of the role
195    * // reverts
196    */
197   function checkRole(address addr, string roleName)
198     view
199     public
200   {
201     roles[roleName].check(addr);
202   }
203 
204   /**
205    * @dev determine if addr has role
206    * @param addr address
207    * @param roleName the name of the role
208    * @return bool
209    */
210   function hasRole(address addr, string roleName)
211     view
212     public
213     returns (bool)
214   {
215     return roles[roleName].has(addr);
216   }
217 
218   /**
219    * @dev add a role to an address
220    * @param addr address
221    * @param roleName the name of the role
222    */
223   function adminAddRole(address addr, string roleName)
224     onlyAdmin
225     public
226   {
227     addRole(addr, roleName);
228   }
229 
230   /**
231    * @dev remove a role from an address
232    * @param addr address
233    * @param roleName the name of the role
234    */
235   function adminRemoveRole(address addr, string roleName)
236     onlyAdmin
237     public
238   {
239     removeRole(addr, roleName);
240   }
241 
242   /**
243    * @dev add a role to an address
244    * @param addr address
245    * @param roleName the name of the role
246    */
247   function addRole(address addr, string roleName)
248     internal
249   {
250     roles[roleName].add(addr);
251     RoleAdded(addr, roleName);
252   }
253 
254   /**
255    * @dev remove a role from an address
256    * @param addr address
257    * @param roleName the name of the role
258    */
259   function removeRole(address addr, string roleName)
260     internal
261   {
262     roles[roleName].remove(addr);
263     RoleRemoved(addr, roleName);
264   }
265 
266   /**
267    * @dev modifier to scope access to a single role (uses msg.sender as addr)
268    * @param roleName the name of the role
269    * // reverts
270    */
271   modifier onlyRole(string roleName)
272   {
273     checkRole(msg.sender, roleName);
274     _;
275   }
276 
277   /**
278    * @dev modifier to scope access to admins
279    * // reverts
280    */
281   modifier onlyAdmin()
282   {
283     checkRole(msg.sender, ROLE_ADMIN);
284     _;
285   }
286 
287   /**
288    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
289    * @param roleNames the names of the roles to scope access to
290    * // reverts
291    *
292    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
293    *  see: https://github.com/ethereum/solidity/issues/2467
294    */
295   // modifier onlyRoles(string[] roleNames) {
296   //     bool hasAnyRole = false;
297   //     for (uint8 i = 0; i < roleNames.length; i++) {
298   //         if (hasRole(msg.sender, roleNames[i])) {
299   //             hasAnyRole = true;
300   //             break;
301   //         }
302   //     }
303 
304   //     require(hasAnyRole);
305 
306   //     _;
307   // }
308 }
309 
310 // File: contracts/permission/PermissionProviderInterface.sol
311 
312 contract PermissionProviderInterface is Provider, RBAC {
313     string public constant ROLE_ADMIN = "admin";
314     string public constant ROLE_CORE = "core";
315     string public constant ROLE_STORAGE = "storage";
316     string public constant ROLE_CORE_OWNER = "CoreOwner";
317     string public constant ROLE_STRATEGY_OWNER = "StrategyOwner";
318     string public constant ROLE_PRICE_OWNER = "PriceOwner";
319     string public constant ROLE_EXCHANGE_OWNER = "ExchangeOwner";
320     string public constant ROLE_EXCHANGE_ADAPTER_OWNER = "ExchangeAdapterOwner";
321     string public constant ROLE_STORAGE_OWNER = "StorageOwner";
322     string public constant ROLE_WHITELIST_OWNER = "WhitelistOwner";
323 
324     modifier onlyAdmin()
325     {
326         checkRole(msg.sender, ROLE_ADMIN);
327         _;
328     }
329 
330     function changeAdmin(address _newAdmin) onlyAdmin public returns (bool success);
331     function adminAdd(address _addr, string _roleName) onlyAdmin public;
332     function adminRemove(address _addr, string _roleName) onlyAdmin public;
333 
334     function has(address _addr, string _roleName) public view returns(bool success);
335 }
336 
337 // File: contracts/exchange/ExchangeAdapterBase.sol
338 
339 contract ExchangeAdapterBase {
340 
341     address internal adapterManager;
342     address internal exchangeExchange;
343 
344     enum Status {
345         ENABLED, 
346         DISABLED
347     }
348 
349     enum OrderStatus {
350         Pending,
351         Approved,
352         PartiallyCompleted,
353         Completed,
354         Cancelled,
355         Errored
356     }
357 
358     function ExchangeAdapterBase(address _manager,address _exchange) public {
359         adapterManager = _manager;
360         exchangeExchange = _exchange;
361     }
362 
363     function getExpectAmount(uint eth, uint destDecimals, uint rate) internal pure returns(uint){
364         return Utils.calcDstQty(eth, 18, destDecimals, rate);
365     }
366 
367     modifier onlyAdaptersManager(){
368         require(msg.sender == adapterManager);
369         _;
370     }
371 
372     modifier onlyExchangeProvider(){
373         require(msg.sender == exchangeExchange);
374         _;
375     }
376 }
377 
378 // File: contracts/exchange/ExchangeProviderInterface.sol
379 
380 contract ExchangeProviderInterface {
381     function startPlaceOrder(uint orderId, address deposit) external returns(bool);
382     function addPlaceOrderItem(uint orderId, ERC20 token, uint amount, uint rate) external returns(bool);
383     function endPlaceOrder(uint orderId) external payable returns(bool);
384     function getSubOrderStatus(uint orderId, ERC20 token) external view returns (ExchangeAdapterBase.OrderStatus);
385     function cancelOrder(uint orderId) external returns (bool success);
386     function checkTokenSupported(ERC20 token) external view returns (bool);
387 }
388 
389 // File: contracts/libs/Converter.sol
390 
391 library Converter {
392     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
393         assembly {
394             result := mload(add(source, 32))
395         }
396     }
397 
398     function bytes32ToString(bytes32 x) internal pure returns (string) {
399         bytes memory bytesString = new bytes(32);
400         uint charCount = 0;
401         for (uint j = 0; j < 32; j++) {
402             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
403             if (char != 0) {
404                 bytesString[charCount] = char;
405                 charCount++;
406             }
407         }
408 
409         bytes memory bytesStringTrimmed = new bytes(charCount);
410         for (j = 0; j < charCount; j++) {
411             bytesStringTrimmed[j] = bytesString[j];
412         }
413         return string(bytesStringTrimmed);
414     }
415 }
416 
417 // File: contracts/libs/SafeMath.sol
418 
419 /**
420  * @title SafeMath
421  * @dev Math operations with safety checks that throw on error
422  */
423 library SafeMath {
424 
425   /**
426   * @dev Multiplies two numbers, throws on overflow.
427   */
428   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429     if (a == 0) {
430       return 0;
431     }
432     uint256 c = a * b;
433     assert(c / a == b);
434     return c;
435   }
436 
437   /**
438   * @dev Integer division of two numbers, truncating the quotient.
439   */
440   function div(uint256 a, uint256 b) internal pure returns (uint256) {
441     // assert(b > 0); // Solidity automatically throws when dividing by 0
442     uint256 c = a / b;
443     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
444     return c;
445   }
446 
447   /**
448   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
449   */
450   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451     assert(b <= a);
452     return a - b;
453   }
454 
455   /**
456   * @dev Adds two numbers, throws on overflow.
457   */
458   function add(uint256 a, uint256 b) internal pure returns (uint256) {
459     uint256 c = a + b;
460     assert(c >= a);
461     return c;
462   }
463 }
464 
465 // File: contracts/price/PriceProviderInterface.sol
466 
467 contract PriceProviderInterface {
468 
469     function updatePrice(address _tokenAddress,bytes32[] _exchanges,uint[] _prices,uint _nonce) public returns(bool success);
470     function getNewDefaultPrice(address _tokenAddress) public view returns(uint);
471     function getNewCustomPrice(address _provider,address _tokenAddress) public view returns(uint);
472 
473     function getNonce(address providerAddress,address tokenAddress) public view returns(uint);
474 
475     function checkTokenSupported(address tokenAddress)  public view returns(bool success);
476     function checkExchangeSupported(bytes32 Exchanges)  public view returns(bool success);
477     function checkProviderSupported(address providerAddress,address tokenAddress)  public view returns(bool success);
478 
479     function getRates(address dest, uint srcQty)  public view returns (uint expectedRate, uint slippageRate);
480 }
481 
482 // File: contracts/storage/OlympusStorageExtendedInterface.sol
483 
484 /*
485  * @dev This contract, for now, can be used to store simple bytes32 key pairs.
486  * These key pairs which are identifiable by their objectId and dataKind
487  * Such as strategy, order, price, etc.
488  * The purpose of this interface is that we can store custom data into this contract
489  * for any changes in the requirements in the future. Each part of the Olympus core
490  * should have options to add custom data to their respective dataType, by using
491  * this contract.
492  * The functions will always be the same, the implementation of the functions might change
493  * So the implementing contracts should be able to modify the configured address of this contract
494  * after deployment.
495  */
496 contract OlympusStorageExtendedInterface {
497     /*
498      * @dev Use this function to set custom extra data for your contract in a key value format
499      * @param dataKind The kind of data, e.g. strategy, order, price, exchange
500      * @param objectId The id for your kind of data, e.g. the strategyId, the orderId
501      * @param key The key which is used to save your data in the key value mapping
502      * @param value The value which will be set on the location of the key
503      * @return A boolean which returns true if the function executed succesfully
504      */
505     function setCustomExtraData(bytes32 dataKind, uint objectId, bytes32 key, bytes32 value) external returns(bool success);
506     /*
507      * @dev Use this function to get custom extra data for your contract by key
508      * @param dataKind The kind of data, e.g. strategy, order, price, exchange
509      * @param objectId The id for your kind of data, e.g. the strategyId, the orderId
510      * @param key The key which is used to lookup your data in the key value mapping
511      * @return The result from the key lookup in string format
512      */
513     function getCustomExtraData(bytes32 dataKind, uint objectId, bytes32 key) external view returns(bytes32 result);
514     /*
515      * @dev This function is used internally to get the accessor for the kind of data
516      * @param dataKind The kind of data, e.g. strategy, order, price, exchange
517      * @param id The id for your kind of data, e.g. the strategyId, the orderId
518      * @return A concatenation of the dataKind string and id as string, which can be used as lookup
519      */
520     function getAccessor(bytes32 dataKind, uint id) private pure returns(string accessor);
521 }
522 
523 // File: contracts/storage/StorageDefinitions.sol
524 
525 library StorageTypeDefinitions {
526     enum OrderStatus {
527         New,
528         Placed,
529         PartiallyCompleted,
530         Completed,
531         Cancelled,
532         Errored
533     }
534 }
535 
536 // File: contracts/storage/OlympusStorageInterface.sol
537 
538 contract OlympusStorageInterface {
539 
540     function addTokenDetails(
541         uint indexOrderId,
542         address[] tokens,
543         uint[] weights,
544         uint[] totalTokenAmounts,
545         uint[] estimatedPrices) external;
546 
547     function addOrderBasicFields(
548         uint strategyId,
549         address buyer,
550         uint amountInWei,
551         uint feeInWei,
552         bytes32 exchangeId) external returns (uint indexOrderId);
553 
554     function getOrderTokenCompletedAmount(
555         uint _orderId,
556         address _tokenAddress) external view returns (uint, uint);
557 
558     function getIndexOrder1(uint _orderId) external view returns(
559         uint strategyId,
560         address buyer,
561         StorageTypeDefinitions.OrderStatus status,
562         uint dateCreated
563         );
564 
565     function getIndexOrder2(uint _orderId) external view returns(
566         uint dateCompleted,
567         uint amountInWei,
568         uint tokensLength,
569         bytes32 exchangeId
570         );
571 
572     function updateIndexOrderToken(
573         uint _orderId,
574         uint _tokenIndex,
575         uint _actualPrice,
576         uint _totalTokenAmount,
577         uint _completedQuantity,
578         ExchangeAdapterBase.OrderStatus status) external;
579 
580     function getIndexToken(uint _orderId, uint tokenPosition) external view returns (address token);
581 
582     function updateOrderStatus(uint _orderId, StorageTypeDefinitions.OrderStatus _status)
583         external returns (bool success);
584 
585     function resetOrderIdTo(uint _orderId) external returns(uint);
586 
587     function addCustomField(
588         uint _orderId,
589         bytes32 key,
590         bytes32 value
591         ) external returns (bool success);
592 
593     function getCustomField(
594         uint _orderId,
595         bytes32 key
596         ) external view returns (bytes32 result);
597 }
598 
599 // File: contracts/storage/OlympusStorage.sol
600 
601 contract OlympusStorage is Manageable, OlympusStorageInterface {
602     using SafeMath for uint256;
603 
604     event IndexOrderUpdated (uint orderId);
605     event Log(string message);
606 
607     struct IndexOrder {
608         address buyer;
609         uint strategyId;
610         uint amountInWei;
611         uint feeInWei;
612         uint dateCreated;
613         uint dateCompleted;
614         address[] tokens;
615         uint[] weights;
616         uint[] estimatedPrices;
617         uint[] dealtPrices;
618         uint[] totalTokenAmounts;
619         uint[] completedTokenAmounts;
620         ExchangeAdapterBase.OrderStatus[] subStatuses;
621         StorageTypeDefinitions.OrderStatus status;
622         bytes32 exchangeId;
623     }
624     mapping(uint => IndexOrder) public orders;
625     mapping(uint => mapping(address => uint)) public orderTokenAmounts;
626     uint public orderId = 1000000;
627     bytes32 constant private dataKind = "Order";
628     OlympusStorageExtendedInterface internal olympusStorageExtended = OlympusStorageExtendedInterface(address(0xcEb51bD598ABb0caa8d2Da30D4D760f08936547B));
629 
630     modifier onlyOwner() {
631         require(permissionProvider.has(msg.sender, permissionProvider.ROLE_STORAGE_OWNER()));
632         _;
633     }
634     modifier onlyCore() {
635         require(permissionProvider.has(msg.sender, permissionProvider.ROLE_CORE()));
636         _;
637     }
638     PermissionProviderInterface internal permissionProvider;
639     constructor(address _permissionProvider) public {
640         permissionProvider = PermissionProviderInterface(_permissionProvider);
641     }
642 
643     function addTokenDetails(
644         uint indexOrderId,
645         address[] tokens,
646         uint[] weights,
647         uint[] totalTokenAmounts,
648         uint[] estimatedPrices
649     ) external onlyCore {
650         orders[indexOrderId].tokens = tokens;
651         orders[indexOrderId].weights = weights;
652         orders[indexOrderId].estimatedPrices = estimatedPrices;
653         orders[indexOrderId].totalTokenAmounts = totalTokenAmounts;
654         uint i;
655 
656         for (i = 0; i < tokens.length; i++ ) {
657             orders[indexOrderId].subStatuses.push(ExchangeAdapterBase.OrderStatus.Pending);
658             orders[indexOrderId].dealtPrices.push(0);
659             orders[indexOrderId].completedTokenAmounts.push(0);
660 
661             orderTokenAmounts[indexOrderId][tokens[i]] = weights[i];
662         }
663     }
664 
665     function addOrderBasicFields(
666         uint strategyId,
667         address buyer,
668         uint amountInWei,
669         uint feeInWei,
670         bytes32 exchangeId
671         ) external onlyCore returns (uint indexOrderId) {
672         indexOrderId = getOrderId();
673 
674         IndexOrder memory order = IndexOrder({
675             buyer: buyer,
676             strategyId: strategyId,
677             amountInWei: amountInWei,
678             feeInWei: feeInWei,
679             dateCreated: now,
680             dateCompleted: 0,
681             tokens: new address[](0),
682             weights: new uint[](0),
683             estimatedPrices: new uint[](0),
684             dealtPrices: new uint[](0),
685             totalTokenAmounts: new uint[](0),
686             completedTokenAmounts: new uint[](0),
687             subStatuses: new ExchangeAdapterBase.OrderStatus[](0),
688             status: StorageTypeDefinitions.OrderStatus.New,
689             exchangeId: exchangeId
690         });
691 
692         orders[indexOrderId] = order;
693         return indexOrderId;
694     }
695 
696     function getIndexOrder1(uint _orderId) external view returns(
697         uint strategyId,
698         address buyer,
699         StorageTypeDefinitions.OrderStatus status,
700         uint dateCreated
701         ) {
702         IndexOrder memory order = orders[_orderId];
703         return (
704             order.strategyId,
705             order.buyer,
706             order.status,
707             order.dateCreated
708         );
709     }
710     function getIndexOrder2(uint _orderId) external view returns(
711         uint dateCompleted,
712         uint amountInWei,
713         uint tokensLength,
714         bytes32 exchangeId
715         ) {
716         IndexOrder memory order = orders[_orderId];
717         return (
718             order.dateCompleted,
719             order.amountInWei,
720             order.tokens.length,
721             order.exchangeId
722         );
723     }
724 
725     function getIndexToken(uint _orderId, uint tokenPosition) external view returns (address token){
726         return orders[_orderId].tokens[tokenPosition];
727     }
728 
729     function getOrderTokenCompletedAmount(uint _orderId, address _tokenAddress) external view returns (uint, uint){
730         IndexOrder memory order = orders[_orderId];
731 
732         int index = -1;
733         for(uint i = 0 ; i < order.tokens.length; i++){
734             if(order.tokens[i] == _tokenAddress) {
735                 index = int(i);
736                 break;
737             }
738         }
739 
740         if(index == -1) {
741             // token not found.
742             revert();
743         }
744 
745         return (order.completedTokenAmounts[uint(index)], uint(index));
746 
747     }
748 
749     function updateIndexOrderToken(
750         uint _orderId,
751         uint _tokenIndex,
752         uint _actualPrice,
753         uint _totalTokenAmount,
754         uint _completedQuantity,
755         ExchangeAdapterBase.OrderStatus _status) external onlyCore {
756 
757         orders[_orderId].totalTokenAmounts[_tokenIndex] = _totalTokenAmount;
758         orders[_orderId].dealtPrices[_tokenIndex] = _actualPrice;
759         orders[_orderId].completedTokenAmounts[_tokenIndex] = _completedQuantity;
760         orders[_orderId].subStatuses[_tokenIndex] = _status;
761     }
762 
763     function addCustomField(
764         uint _orderId,
765         bytes32 key,
766         bytes32 value
767     ) external onlyCore returns (bool success){
768         return olympusStorageExtended.setCustomExtraData(dataKind,_orderId,key,value);
769     }
770 
771     function getCustomField(
772         uint _orderId,
773         bytes32 key
774     ) external view returns (bytes32 result){
775         return olympusStorageExtended.getCustomExtraData(dataKind,_orderId,key);
776     }
777 
778     function updateOrderStatus(uint _orderId, StorageTypeDefinitions.OrderStatus _status)
779         external onlyCore returns (bool success){
780 
781         orders[_orderId].status = _status;
782         return true;
783     }
784 
785     function getOrderId() private returns (uint) {
786         return orderId++;
787     }
788 
789     function resetOrderIdTo(uint _start) external onlyOwner returns (uint) {
790         orderId = _start;
791         return orderId;
792     }
793 
794     function setProvider(uint8 _id, address _providerAddress) public onlyOwner returns (bool success) {
795         bool result = super.setProvider(_id, _providerAddress);
796         TypeDefinitions.ProviderType _type = TypeDefinitions.ProviderType(_id);
797 
798         if(_type == TypeDefinitions.ProviderType.ExtendedStorage) {
799             emit Log("ExtendedStorage");
800             olympusStorageExtended = OlympusStorageExtendedInterface(_providerAddress);
801         } else {
802             emit Log("Unknown provider type supplied.");
803             revert();
804         }
805 
806         return result;
807     }
808 
809 
810 }
811 
812 // File: contracts/strategy/StrategyProviderInterface.sol
813 
814 contract StrategyProviderInterface is Provider {
815 
816     struct Combo {
817         uint id;
818         string name;
819         string description;
820         string category;
821         address[] tokenAddresses;
822         uint[] weights;      //total is 100
823         uint follower;
824         uint amount;
825         bytes32 exchangeId;
826     }
827 
828     Combo[] public comboHub;
829     modifier _checkIndex(uint _index) {
830         require(_index < comboHub.length);
831         _;
832     }
833 
834    // To core smart contract
835     function getStrategyCount() public view returns (uint length);
836 
837     function getStrategyTokenCount(uint strategyId) public view returns (uint length);
838     function getStrategyTokenByIndex(uint strategyId, uint tokenIndex) public view returns (address token, uint weight);
839 
840     function getStrategy(uint _index) public _checkIndex(_index) view returns (
841         uint id,
842         string name,
843         string description,
844         string category,
845         address[] memory tokenAddresses,
846         uint[] memory weights,
847         uint followers,
848         uint amount,
849         bytes32 exchangeId);
850 
851     function createStrategy(
852         string name,
853         string description,
854         string category,
855         address[] tokenAddresses,
856         uint[] weights,
857         bytes32 exchangeId)
858         public returns (uint strategyId);
859 
860     function updateStrategy(
861         uint strategyId,
862         string name,
863         string description,
864         string category,
865         address[] tokenAddresses,
866         uint[] weights,
867         bytes32 exchangeId)
868         public returns (bool success);
869 
870     // increment statistics
871     function incrementStatistics(uint id, uint amountInEther) external returns (bool success);
872     function updateFollower(uint id, bool follow) external returns (bool success);
873 }
874 
875 // File: contracts/whitelist/WhitelistProviderInterface.sol
876 
877 contract WhitelistProviderInterface is Provider {
878     function isAllowed(address account) external view returns(bool);
879 }
880 
881 // File: contracts/OlympusLabsCore.sol
882 
883 contract OlympusLabsCore is Manageable {
884     using SafeMath for uint256;
885 
886     event IndexOrderUpdated (uint orderId);
887     event Log(string message);
888     event LogNumber(uint number);
889     event LogAddress(address message);
890     event LogAddresses(address[] message);
891     event LogNumbers(uint[] numbers);
892     event LOGDEBUG(address);
893 
894     ExchangeProviderInterface internal exchangeProvider =  ExchangeProviderInterface(address(0x0));
895     StrategyProviderInterface internal strategyProvider = StrategyProviderInterface(address(0x0));
896     PriceProviderInterface internal priceProvider = PriceProviderInterface(address(0x0));
897     OlympusStorageInterface internal olympusStorage = OlympusStorageInterface(address(0x0));
898     WhitelistProviderInterface internal whitelistProvider;
899     ERC20 private constant MOT = ERC20(address(0x263c618480DBe35C300D8d5EcDA19bbB986AcaeD));
900     // TODO, update for mainnet: 0x263c618480DBe35C300D8d5EcDA19bbB986AcaeD
901 
902     uint public feePercentage = 100;
903     uint public MOTDiscount = 25;
904     uint public constant DENOMINATOR = 10000;
905 
906     uint public minimumInWei = 0;
907     uint public maximumInWei;
908 
909     modifier allowProviderOnly(TypeDefinitions.ProviderType _type) {
910         require(msg.sender == subContracts[uint8(_type)]);
911         _;
912     }
913 
914     modifier onlyOwner() {
915         require(permissionProvider.has(msg.sender, permissionProvider.ROLE_CORE_OWNER()));
916         _;
917     }
918 
919     modifier onlyAllowed(){
920         require(address(whitelistProvider) == 0x0 || whitelistProvider.isAllowed(msg.sender));
921         _;
922     }
923 
924     PermissionProviderInterface internal permissionProvider;
925 
926     function OlympusLabsCore(address _permissionProvider) public {
927         permissionProvider = PermissionProviderInterface(_permissionProvider);
928     }
929 
930     function() payable public {
931         revert();
932     }
933 
934     function getStrategyCount() public view returns (uint length)
935     {
936         return strategyProvider.getStrategyCount();
937     }
938 
939     function getStrategy(uint strategyId) public view returns (
940         string name,
941         string description,
942         string category,
943         address[] memory tokens,
944         uint[] memory weights,
945         uint followers,
946         uint amount,
947         string exchangeName)
948     {
949         bytes32 _exchangeName;
950         uint tokenLength = strategyProvider.getStrategyTokenCount(strategyId);
951         tokens = new address[](tokenLength);
952         weights = new uint[](tokenLength);
953 
954         (,name,description,category,,,followers,amount,_exchangeName) = strategyProvider.getStrategy(strategyId);
955         (,,,,tokens,weights,,,) = strategyProvider.getStrategy(strategyId);
956         exchangeName = Converter.bytes32ToString(_exchangeName);
957     }
958 
959     function getStrategyTokenAndWeightByIndex(uint strategyId, uint index) public view returns (
960         address token,
961         uint weight
962         )
963     {
964         uint tokenLength = strategyProvider.getStrategyTokenCount(strategyId);
965         require(index < tokenLength);
966 
967         (token, weight) = strategyProvider.getStrategyTokenByIndex(strategyId, index);
968     }
969 
970     // Forward to Price smart contract.
971     function getPrice(address tokenAddress, uint srcQty) public view returns (uint price){
972         require(tokenAddress != address(0));
973         (, price) = priceProvider.getRates(tokenAddress, srcQty);
974         return price;
975     }
976 
977     function getStrategyTokenPrice(uint strategyId, uint tokenIndex) public view returns (uint price) {
978         uint totalLength;
979 
980         uint tokenLength = strategyProvider.getStrategyTokenCount(strategyId);
981         require(tokenIndex <= totalLength);
982         address[] memory tokens;
983         uint[] memory weights;
984         (,,,,tokens,weights,,,) = strategyProvider.getStrategy(strategyId);
985 
986         //Default get the price for one Ether
987 
988         return getPrice(tokens[tokenIndex], 10**18);
989     }
990 
991     function setProvider(uint8 _id, address _providerAddress) public onlyOwner returns (bool success) {
992         bool result = super.setProvider(_id, _providerAddress);
993         TypeDefinitions.ProviderType _type = TypeDefinitions.ProviderType(_id);
994 
995         if(_type == TypeDefinitions.ProviderType.Strategy) {
996             emit Log("StrategyProvider");
997             strategyProvider = StrategyProviderInterface(_providerAddress);
998         } else if(_type == TypeDefinitions.ProviderType.Exchange) {
999             emit Log("ExchangeProvider");
1000             exchangeProvider = ExchangeProviderInterface(_providerAddress);
1001         } else if(_type == TypeDefinitions.ProviderType.Price) {
1002             emit Log("PriceProvider");
1003             priceProvider = PriceProviderInterface(_providerAddress);
1004         } else if(_type == TypeDefinitions.ProviderType.Storage) {
1005             emit Log("StorageProvider");
1006             olympusStorage = OlympusStorageInterface(_providerAddress);
1007         } else if(_type == TypeDefinitions.ProviderType.Whitelist) {
1008             emit Log("WhitelistProvider");
1009             whitelistProvider = WhitelistProviderInterface(_providerAddress);
1010         } else {
1011             emit Log("Unknown provider type supplied.");
1012             revert();
1013         }
1014 
1015         return result;
1016     }
1017 
1018     function buyIndex(uint strategyId, address depositAddress, bool feeIsMOT)
1019     public onlyAllowed payable returns (uint indexOrderId)
1020     {
1021         require(msg.value > minimumInWei);
1022         if(maximumInWei > 0){
1023             require(msg.value <= maximumInWei);
1024         }
1025         uint tokenLength = strategyProvider.getStrategyTokenCount(strategyId);
1026         // can't buy an index without tokens.
1027         require(tokenLength > 0);
1028         address[] memory tokens = new address[](tokenLength);
1029         uint[] memory weights = new uint[](tokenLength);
1030         bytes32 exchangeId;
1031 
1032         (,,,,tokens,weights,,,exchangeId) = strategyProvider.getStrategy(strategyId);
1033 
1034         uint[3] memory amounts;
1035         amounts[0] = msg.value; //uint totalAmount
1036         amounts[1] = getFeeAmount(amounts[0], feeIsMOT); // fee
1037         amounts[2] = payFee(amounts[0], amounts[1], msg.sender, feeIsMOT);
1038 
1039         // create order.
1040         indexOrderId = olympusStorage.addOrderBasicFields(
1041           strategyId,
1042           msg.sender,
1043           amounts[0],
1044           amounts[1],
1045           exchangeId
1046         );
1047 
1048         uint[][4] memory subOrderTemp;
1049         // 0: token amounts
1050         // 1: estimatedPrices
1051         subOrderTemp[0] = initializeArray(tokenLength);
1052         subOrderTemp[1] = initializeArray(tokenLength);
1053 
1054         emit LogNumber(indexOrderId);
1055 
1056 
1057         require(exchangeProvider.startPlaceOrder(indexOrderId, depositAddress));
1058 
1059         for (uint i = 0; i < tokenLength; i ++ ) {
1060 
1061             // ignore those tokens with zero weight.
1062             if(weights[i] <= 0) {
1063                 continue;
1064             }
1065             // token has to be supported by exchange provider.
1066             if(!exchangeProvider.checkTokenSupported(ERC20(tokens[i]))){
1067                 emit Log("Exchange provider doesn't support");
1068                 revert();
1069             }
1070 
1071             // check if price provider supports it.
1072             if(!priceProvider.checkTokenSupported(tokens[i])){
1073                 emit Log("Price provider doesn't support");
1074                 revert();
1075             }
1076 
1077             subOrderTemp[0][i] = amounts[2] * weights[i] / 100;
1078             subOrderTemp[1][i] = getPrice(tokens[i], subOrderTemp[0][i]);
1079 
1080             emit LogAddress(tokens[i]);
1081             emit LogNumber(subOrderTemp[0][i]);
1082             emit LogNumber(subOrderTemp[1][i]);
1083             require(exchangeProvider.addPlaceOrderItem(indexOrderId, ERC20(tokens[i]), subOrderTemp[0][i], subOrderTemp[1][i]));
1084         }
1085 
1086         olympusStorage.addTokenDetails(
1087             indexOrderId,
1088             tokens, weights, subOrderTemp[0], subOrderTemp[1]
1089         );
1090 
1091 
1092         emit LogNumber(amounts[2]);
1093         require((exchangeProvider.endPlaceOrder.value(amounts[2])(indexOrderId)));
1094 
1095 
1096         strategyProvider.updateFollower(strategyId, true);
1097 
1098         strategyProvider.incrementStatistics(strategyId, msg.value);
1099 
1100         return indexOrderId;
1101     }
1102 
1103     function initializeArray(uint length) private pure returns (uint[]){
1104         return new uint[](length);
1105     }
1106 
1107     function resetOrderIdTo(uint _start) external onlyOwner returns (uint) {
1108         return olympusStorage.resetOrderIdTo(_start);
1109     }
1110 
1111     // For app/3rd-party clients to check details / status.
1112     function getIndexOrder(uint _orderId) public view returns
1113     (uint[])
1114     {
1115         // 0 strategyId
1116         // 1 dateCreated
1117         // 2 dateCompleted
1118         // 3 amountInWei
1119         // 4 tokenLength
1120         uint[] memory orderPartial = new uint[](5);
1121         address[] memory buyer = new address[](1);
1122         bytes32[] memory exchangeId = new bytes32[](1);
1123         StorageTypeDefinitions.OrderStatus[] memory status = new StorageTypeDefinitions.OrderStatus[](1);
1124 
1125 
1126         (orderPartial[0], buyer[0], status[0], orderPartial[1]) = olympusStorage.getIndexOrder1(_orderId);
1127         (orderPartial[2], orderPartial[3], orderPartial[4], exchangeId[0]) = olympusStorage.getIndexOrder2(_orderId);
1128         address[] memory tokens = new address[](orderPartial[4]);
1129 
1130         for(uint i = 0; i < orderPartial[4]; i++){
1131             tokens[i] = olympusStorage.getIndexToken(_orderId, i);
1132         }
1133         return (
1134           orderPartial
1135         );
1136     }
1137 
1138     function updateIndexOrderToken(
1139         uint _orderId,
1140         address _tokenAddress,
1141         uint _actualPrice,
1142         uint _totalTokenAmount,
1143         uint _completedQuantity
1144     ) external allowProviderOnly(TypeDefinitions.ProviderType.Exchange) returns (bool success)
1145     {
1146         uint completedTokenAmount;
1147         uint tokenIndex;
1148         (completedTokenAmount, tokenIndex) = olympusStorage.getOrderTokenCompletedAmount(_orderId,_tokenAddress);
1149 
1150         ExchangeAdapterBase.OrderStatus status;
1151 
1152         if(completedTokenAmount == 0 && _completedQuantity < completedTokenAmount){
1153             status = ExchangeAdapterBase.OrderStatus.PartiallyCompleted;
1154         }
1155 
1156         if(_completedQuantity >= completedTokenAmount){
1157             status = ExchangeAdapterBase.OrderStatus.Completed;
1158         }
1159         olympusStorage.updateIndexOrderToken(_orderId, tokenIndex, _totalTokenAmount, _actualPrice, _completedQuantity, status);
1160 
1161         return true;
1162     }
1163 
1164     function updateOrderStatus(uint _orderId, StorageTypeDefinitions.OrderStatus _status)
1165         external allowProviderOnly(TypeDefinitions.ProviderType.Exchange)
1166         returns (bool success)
1167     {
1168         olympusStorage.updateOrderStatus(_orderId, _status);
1169 
1170         return true;
1171     }
1172 
1173     function getSubOrderStatus(uint _orderId, address _tokenAddress)
1174         external view returns (ExchangeAdapterBase.OrderStatus)
1175     {
1176         return exchangeProvider.getSubOrderStatus(_orderId, ERC20(_tokenAddress));
1177     }
1178 
1179     function adjustFee(uint _newFeePercentage) public onlyOwner returns (bool success) {
1180         require(_newFeePercentage < DENOMINATOR);
1181         feePercentage = _newFeePercentage;
1182         return true;
1183     }
1184 
1185     function adjustMOTFeeDiscount(uint _newDiscountPercentage) public onlyOwner returns(bool success) {
1186         require(_newDiscountPercentage <= 100);
1187         MOTDiscount = _newDiscountPercentage;
1188         return true;
1189     }
1190 
1191     function adjustTradeRange(uint _minInWei, uint _maxInWei) public onlyOwner returns (bool success) {
1192         require(_minInWei > 0);
1193         require(_maxInWei > _minInWei);
1194         minimumInWei = _minInWei;
1195         maximumInWei = _maxInWei;
1196 
1197         return true;
1198     }
1199 
1200     function getFeeAmount(uint amountInWei, bool feeIsMOT) private view returns (uint){
1201         if(feeIsMOT){
1202             return ((amountInWei * feePercentage / DENOMINATOR) * (100 - MOTDiscount)) / 100;
1203         } else {
1204             return amountInWei * feePercentage / DENOMINATOR;
1205         }
1206     }
1207 
1208     function payFee(uint totalValue, uint feeValueInETH, address sender, bool feeIsMOT) private returns (uint){
1209         if(feeIsMOT){
1210             // Transfer MOT
1211             uint MOTPrice;
1212             uint allowance = MOT.allowance(sender,address(this));
1213             (MOTPrice,) = priceProvider.getRates(address(MOT), feeValueInETH);
1214             uint amount = (feeValueInETH * MOTPrice) / 10**18;
1215             require(allowance >= amount);
1216             require(MOT.transferFrom(sender,address(this),amount));
1217             return totalValue; // Use all sent ETH to buy, because fee is paid in MOT
1218         } else { // We use ETH as fee, so deduct that from the amount of ETH sent
1219             return totalValue - feeValueInETH;
1220         }
1221     }
1222 
1223     function withdrawERC20(address receiveAddress,address _tokenAddress) public onlyOwner returns(bool success)
1224     {
1225         uint _balance = ERC20(_tokenAddress).balanceOf(address(this));
1226         require(_tokenAddress != 0x0 && receiveAddress != 0x0 && _balance != 0);
1227         require(ERC20(_tokenAddress).transfer(receiveAddress,_balance));
1228         return true;
1229     }
1230     function withdrawETH(address receiveAddress) public onlyOwner returns(bool success)
1231     {
1232         require(receiveAddress != 0x0);
1233         receiveAddress.transfer(this.balance);
1234         return true;
1235     }
1236 }