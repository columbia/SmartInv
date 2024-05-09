1 /* This Source Code Form is subject to the terms of the Mozilla Public
2  * License, v. 2.0. If a copy of the MPL was not distributed with this
3  * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
4 // solhint-disable-next-line compiler-fixed
5 pragma solidity >=0.5.1 <0.7.0;
6 interface ERC777Interface {
7     function name() external view returns (string memory);
8     function symbol() external view returns (string memory);
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address holder) external view returns (uint256);
11     function granularity() external view returns (uint256);
12     function defaultOperators() external view returns (address[] memory);
13     function addDefaultOperators(address owner) external returns (bool);
14     function removeDefaultOperators(address owner) external returns (bool);
15     function isOperatorFor(
16         address operator,
17         address holder
18     ) external view returns (bool);
19     function authorizeOperator(address operator) external;
20     function revokeOperator(address operator) external;
21     function send(address to, uint256 amount, bytes calldata data) external;
22     function operatorSend(
23         address from,
24         address to,
25         uint256 amount,
26         bytes calldata data,
27         bytes calldata operatorData
28     ) external;
29     function burn(uint256 amount, bytes calldata data) external;
30     function operatorBurn(
31         address from,
32         uint256 amount,
33         bytes calldata data,
34         bytes calldata operatorData
35     ) external;
36     event Sent(
37         address indexed operator,
38         address indexed from,
39         address indexed to,
40         uint256 amount,
41         bytes data,
42         bytes operatorData
43     );
44     event Minted(
45         address indexed operator,
46         address indexed to,
47         uint256 amount,
48         bytes data,
49         bytes operatorData
50     );
51     event Burned(
52         address indexed operator,
53         address indexed from,
54         uint256 amount,
55         bytes data,
56         bytes operatorData
57     );
58     event AuthorizedOperator(
59         address indexed operator,
60         address indexed holder
61     );
62     event RevokedOperator(address indexed operator, address indexed holder);
63 }
64 pragma solidity >=0.5.0 <0.6.0;
65 interface USDTInterface {
66     function totalSupply() external view returns (uint);
67     function balanceOf(address who) external view returns (uint);
68     function allowance(address owner, address spender) external view returns (uint);
69         function transfer(address to, uint value) external;
70     function approve(address spender, uint value) external;
71     function transferFrom(address from, address to, uint value) external;
72 }
73 pragma solidity >=0.5.1 <0.7.0;
74 contract Hosts {
75     address public owner;
76     mapping(uint => mapping(uint => address)) internal impls;
77     mapping(uint => uint) internal time;
78     constructor() public {
79         owner = msg.sender;
80     }
81     modifier restricted() {
82         if (msg.sender == owner) _;
83     }
84     function latestTime(uint CIDXX) external view restricted returns (uint) {
85         return time[CIDXX];
86     }
87     function setImplement(uint CIDXX, address implementer) external restricted {
88         time[uint(CIDXX)] = now;
89         impls[uint(CIDXX)][0] = implementer;
90     }
91     function setImplementSub(uint CIDXX, uint idx, address implementer) external restricted {
92         time[uint(CIDXX)] = now;
93         impls[uint(CIDXX)][idx] = implementer;
94     }
95     function getImplement(uint CIDXX) external view returns (address) {
96         return impls[uint(CIDXX)][0];
97     }
98     function getImplementSub(uint CIDXX, uint idx) external view returns (address) {
99         return impls[uint(CIDXX)][idx];
100     }
101 }
102 pragma solidity >=0.5.1 <0.7.0;
103 contract KOwnerable {
104     address[] public _KContractOwners = [
105                 address(0x7630A0f21Ac2FDe268eF62eBb1B06876DFe71909)
106     ];
107     constructor() public {
108         _KContractOwners.push(msg.sender);
109     }
110     modifier KOwnerOnly() {
111         bool exist = false;
112         for ( uint i = 0; i < _KContractOwners.length; i++ ) {
113             if ( _KContractOwners[i] == msg.sender ) {
114                 exist = true;
115                 break;
116             }
117         }
118         require(exist); _;
119     }
120     modifier KDAODefense() {
121         uint256 size;
122         address payable safeAddr = msg.sender;
123         assembly {size := extcodesize(safeAddr)}
124         require( size == 0, "DAO_Warning" );
125         _;
126     }
127 }
128 contract KState is KOwnerable {
129     uint public _CIDXX;
130     Hosts public _KHost;
131     constructor(uint cidxx) public {
132         _CIDXX = cidxx;
133     }
134 }
135 contract KContract is KState {
136     modifier readonly {_;}
137     modifier readwrite {_;}
138     function implementcall() internal {
139         (bool s, bytes memory r) = _KHost.getImplement(_CIDXX).delegatecall(msg.data);
140         require(s);
141         assembly {
142             return( add(r, 0x20), returndatasize )
143         }
144     }
145     function implementcall(uint subimplID) internal {
146         (bool s, bytes memory r) = _KHost.getImplementSub(_CIDXX, subimplID).delegatecall(msg.data);
147         require(s);
148         assembly {
149             return( add(r, 0x20), returndatasize )
150         }
151     }
152         function _D(bytes calldata, uint m) external KOwnerOnly returns (bytes memory) {
153         implementcall(m);
154     }
155 }
156 pragma solidity >=0.5.1 <0.7.0;
157 interface OrderInterface {
158         event Log_HelpTo(address indexed owner, OrderInterface indexed order, uint amount, uint time);
159         event Log_HelpGet(address indexed other, OrderInterface indexed order, uint amount, uint time);
160         enum OrderType {
161                 PHGH,
162                 OnlyPH,
163                 OnlyGH
164     }
165     enum OrderStates {
166                 Unknown,
167                 Created,
168                 PaymentPart,
169                 PaymentCountDown,
170                 TearUp,
171                 Frozen,
172                 Profiting,
173                 Done
174     }
175     enum TimeType {
176                 OnCreated,
177                 OnPaymentFrist,
178                 OnPaymentSuccess,
179                 OnProfitingBegin,
180                 OnCountDownStart,
181                 OnCountDownEnd,
182                 OnConvertConsumer,
183                 OnUnfreezing,
184                 OnDone
185     }
186     enum ConvertConsumerError {
187                 Unkown,
188                 NoError,
189                 NotFrozenState,
190                 LessMinFrozen,
191                 NextOrderInvaild,
192                 IsBreaker,
193                 IsFinalStateOrder
194     }
195         function times(uint8) external view returns (uint);
196         function totalAmount() external view returns (uint);
197         function toHelpedAmount() external view returns (uint);
198         function getHelpedAmount() external view returns (uint);
199         function getHelpedAmountTotal() external view returns (uint);
200         function paymentPartMinLimit() external view returns (uint);
201         function orderState() external view returns (OrderStates state);
202         function contractOwner() external view returns (address);
203         function orderIndex() external view returns (uint);
204         function orderType() external view returns (OrderType);
205         function blockRange(uint t) external view returns (uint);
206         function CurrentProfitInfo() external returns (OrderInterface.ConvertConsumerError, uint, uint);
207                     function ApplyProfitingCountDown() external returns (bool canApply, bool applyResult);
208         function DoConvertToConsumer() external returns (bool);
209         function UpdateTimes(uint target) external;
210         function PaymentStateCheck() external returns (OrderStates state);
211         function OrderStateCheck() external returns (OrderStates state);
212         function CTL_GetHelpDelegate(OrderInterface helper, uint amount) external;
213         function CTL_ToHelp(OrderInterface who, uint amount) external returns (bool);
214         function CTL_SetNextOrderVaild() external;
215 }
216 pragma solidity >=0.5.1 <0.7.0;
217 library OrderArrExt {
218     using OrderArrExt for OrderInterface[];
219     function isEmpty(OrderInterface[] storage self) internal view returns (bool) {
220         return self.length == 0;
221     }
222     function isNotEmpty(OrderInterface[] storage self) internal view returns (bool) {
223         return self.length > 0;
224     }
225     function latest(OrderInterface[] storage self) internal view returns (OrderInterface) {
226         return self[self.length - 1];
227     }
228 }
229 library Uint32ArrExt {
230     using Uint32ArrExt for uint32[];
231     function isEmpty(uint32[] storage self) internal view returns (bool) {
232         return self.length == 0;
233     }
234     function isNotEmpty(uint32[] storage self) internal view returns (bool) {
235         return self.length > 0;
236     }
237     function latest(uint32[] storage self) internal view returns (uint32) {
238         return self[self.length - 1];
239     }
240 }
241 pragma solidity >=0.5.1 <0.7.0;
242 interface CounterModulesInterface {
243     enum AwardType {
244                 Recommend,
245                 Admin,
246                 Manager,
247                 Grow
248     }
249         struct InvokeResult {
250         uint len;
251         address[] addresses;
252         uint[] awards;
253         AwardType[] awardTypes;
254     }
255     function WhenOrderCreatedDelegate(OrderInterface)
256     external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
257         function WhenOrderFrozenDelegate(OrderInterface)
258     external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
259         function WhenOrderDoneDelegate(OrderInterface)
260     external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
261 }
262 interface CounterInterface {
263     function SubModuleCIDXXS() external returns (uint[] memory);
264     function AddSubModule(CounterModulesInterface moduleInterface) external;
265     function RemoveSubModule(CounterModulesInterface moduleInterface) external;
266 }
267 pragma solidity >=0.5.1 <0.7.0;
268 interface ControllerInterface_User_Write {
269     enum CreateOrderError {
270                 NoError,
271                 LessThanMinimumLimit,
272                 LessThanMinimumPaymentPart,
273                 LessThanFrontOrder,
274                 LessThanOrderCreateInterval,
275                 InvaildParams,
276                 CostInsufficient
277     }
278         function CreateOrder(uint total, uint amount) external returns (CreateOrderError code);
279                 function CreateAwardOrder(uint amount) external returns (CreateOrderError code);
280         function CreateDefragmentationOrder(uint l) external returns (uint totalAmount);
281 }
282 interface ControllerInterface_User_Read {
283         function IsBreaker(address owner) external returns (bool);
284         function ResolveBreaker() external;
285         function GetOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);
286         function GetAwardOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);
287 }
288 interface ControllerDelegate {
289         function order_PushProducerDelegate() external;
290         function order_PushConsumerDelegate() external returns (bool);
291         function order_HandleAwardsDelegate(address addr, uint award, CounterModulesInterface.AwardType atype ) external;
292         function order_PushBreakerToBlackList(address breakerAddress) external;
293         function order_DepositedAmountDelegate() external;
294         function order_ApplyProfitingCountDown() external returns (bool);
295         function order_AppendTotalAmountInfo(address owner, uint inAmount, uint outAmount) external;
296         function order_IsVaild(address orderAddress) external returns (bool);
297 }
298 interface ControllerInterface_Onwer {
299     function QueryOrders(
300                 address owner,
301                 OrderInterface.OrderType orderType,
302                 uint orderState,
303                 uint offset,
304                 uint size
305     ) external returns (
306                 uint total,
307                 uint len,
308                 OrderInterface[] memory orders,
309                 uint[] memory totalAmounts,
310                 OrderInterface.OrderStates[] memory states,
311                 uint96[] memory times
312     );
313     function OwnerGetSeekInfo() external returns (uint total, uint ptotal, uint ctotal, uint pseek, uint cseek);
314         enum QueueName {
315                 Producer,
316                 Consumer,
317                 Main
318     }
319     function OwnerGetOrder(QueueName qname, uint seek) external returns (OrderInterface);
320     function OwnerGetOrderList(QueueName qname, uint offset, uint size) external
321     returns (
322                 OrderInterface[] memory orders,
323                 uint[] memory times,
324                 uint[] memory totalAmounts
325     );
326     function OwnerUpdateOrdersTime(OrderInterface[] calldata orders, uint targetTimes) external;
327 }
328 contract ControllerInterface is ControllerInterface_User_Write, ControllerInterface_User_Read, ControllerInterface_Onwer {}
329 pragma solidity >=0.5.1 <0.7.0;
330 interface ConfigInterface {
331     enum Keys {
332                 WaitTime,
333                 PaymentCountDownSec,
334                 ForzenTimesMin,
335                 ForzenTimesMax,
336                 ProfitPropP1,
337                 ProfitPropTotalP2,
338                 OrderCreateInterval,
339                 OrderAmountAppendQuota,
340                 OrderAmountMinLimit,
341                 OrderAmountMaxLimit,
342                 OrderPaymentedMinPart,
343                 OrderAmountGranularity,
344                 WithdrawCostProp,
345                 USDTToDTProp,
346                 DepositedUSDMaxLimit,
347                 ResolveBreakerDTAmount
348     }
349     function GetConfigValue(Keys k) external view returns (uint);
350     function SetConfigValue(Keys k, uint v) external;
351     function WaitTime() external view returns (uint);
352     function PaymentCountDownSec() external view returns (uint);
353     function ForzenTimesMin() external view returns (uint);
354     function ForzenTimesMax() external view returns (uint);
355     function ProfitPropP1() external view returns (uint);
356     function ProfitPropTotalP2() external view returns (uint);
357     function OrderCreateInterval() external view returns (uint);
358     function OrderAmountAppendQuota() external view returns (uint);
359     function OrderAmountMinLimit() external view returns (uint);
360     function OrderAmountMaxLimit() external view returns (uint);
361     function OrderPaymentedMinPart() external view returns (uint);
362     function OrderAmountGranularity() external view returns (uint);
363     function WithdrawCostProp() external view returns (uint);
364     function USDTToDTProp() external view returns (uint);
365     function DepositedUSDMaxLimit() external view returns (uint);
366     function ResolveBreakerDTAmount() external view returns (uint);
367 }
368 pragma solidity >=0.5.1 <0.7.0;
369 contract OrderState is OrderInterface, KState(0xcb150bf5) {
370         mapping(uint8 => uint) public times;
371         OrderInterface.OrderType public orderType;
372         uint public totalAmount;
373         uint public toHelpedAmount;
374         uint public getHelpedAmount;
375         uint public getHelpedAmountTotal;
376         uint public paymentPartMinLimit;
377         OrderInterface.OrderStates public orderState;
378         bool public nextOrderVaild;
379         address public contractOwner;
380         uint public orderIndex;
381                 mapping(uint => uint) public blockRange;
382         USDTInterface internal _usdtInterface;
383     ConfigInterface internal _configInterface;
384     ControllerDelegate internal _CTL;
385     CounterModulesInterface internal _counterInteface;
386 }
387 pragma solidity >=0.5.1 <0.7.0;
388 contract Order is OrderState, KContract {
389     constructor(
390                 address owner,
391                 OrderType ortype,
392                 uint num,
393                 uint orderTotalAmount,
394                 uint minPart,
395                 USDTInterface usdInc,
396                 ConfigInterface configInc,
397                 CounterModulesInterface counterInc,
398                 Hosts host
399     ) public {
400         _KHost = host;
401         blockRange[0] = block.number;
402         _usdtInterface = usdInc;
403         _CTL = ControllerDelegate(msg.sender);
404         _configInterface = configInc;
405         _counterInteface = counterInc;
406         contractOwner = owner;
407         orderIndex = num;
408         orderType = ortype;
409         paymentPartMinLimit = minPart;
410         orderState = OrderStates.Created;
411                 times[uint8(TimeType.OnCreated)] = now;
412         if ( ortype == OrderType.PHGH ) {
413             totalAmount = orderTotalAmount;
414                         times[uint8(TimeType.OnCountDownStart)] = now + configInc.WaitTime();
415                         times[uint8(TimeType.OnCountDownEnd)] = now + configInc.WaitTime() + configInc.PaymentCountDownSec();
416                         times[uint8(TimeType.OnProfitingBegin)] = now + configInc.WaitTime();
417         }
418                                                                 else if ( ortype == OrderType.OnlyPH ) {
419             totalAmount = orderTotalAmount;
420             getHelpedAmountTotal = orderTotalAmount;
421                         orderIndex = 0;
422             orderState = OrderStates.Done;
423                                     contractOwner = address(this);
424         }
425                                 else if ( ortype == OrderType.OnlyGH ) {
426             totalAmount = 0;
427             orderIndex = 0;
428             getHelpedAmountTotal = orderTotalAmount;
429             orderState = OrderStates.Profiting;
430             times[uint8(TimeType.OnConvertConsumer)] = now;
431                                 }
432     }
433     function ForzonPropEveryDay() external readonly returns (uint) {
434         super.implementcall();
435     }
436     function CurrentProfitInfo() external readonly returns (OrderInterface.ConvertConsumerError, uint, uint) {
437         super.implementcall();
438     }
439     function DoConvertToConsumer() external readwrite returns (bool) {
440         super.implementcall();
441     }
442     function UpdateTimes(uint) external {
443         super.implementcall();
444     }
445     function PaymentStateCheck() external readwrite returns (OrderStates) {
446         super.implementcall();
447     }
448     function OrderStateCheck() external readwrite returns (OrderInterface.OrderStates) {
449         super.implementcall();
450     }
451     function ApplyProfitingCountDown() external readwrite returns (bool, bool) {
452         super.implementcall();
453     }
454     function CTL_SetNextOrderVaild() external readwrite {
455         super.implementcall();
456     }
457     function CTL_GetHelpDelegate(OrderInterface, uint) external readwrite {
458         super.implementcall();
459     }
460     function CTL_ToHelp(OrderInterface, uint) external readwrite returns (bool) {
461         super.implementcall();
462     }
463 }
464 pragma solidity >=0.5.1 <0.7.0;
465 interface RewardInterface {
466     struct DepositedInfo {
467                 uint rewardAmount;
468                 uint totalDeposit;
469                 uint totalRewardedAmount;
470     }
471         event Log_Award(address indexed owner, CounterModulesInterface.AwardType indexed atype, uint time, uint amount );
472         event Log_Withdrawable(address indexed owner, uint time, uint amount );
473         function RewardInfo(address owner) external returns (uint rewardAmount, uint totalDeposit, uint totalRewardedAmount);
474         function CTL_ClearHistoryDelegate(address breaker) external;
475         function CTL_AddReward(address owner, uint amount, CounterModulesInterface.AwardType atype) external;
476         function CTL_CreatedOrderDelegate(address owner, uint amount) external;
477         function CTL_CreatedAwardOrderDelegate(address owner, uint amount) external returns (bool);
478 }
479 pragma solidity >=0.5.1 <0.7.0;
480 interface PhoenixInterface {
481     struct InoutTotal {
482         uint totalIn;
483         uint totalOut;
484     }
485     struct Compensate {
486                 uint total;
487                 uint currentWithdraw;
488                 uint latestWithdrawTime;
489     }
490     event Log_CompensateCreated(address indexed owner, uint when, uint compensateAmount);
491     event Log_CompensateRelase(address indexed owner, uint when, uint relaseAmount);
492     function GetInoutTotalInfo(address owner) external returns (uint totalIn, uint totalOut);
493     function SettlementCompensate() external returns (uint total) ;
494     function WithdrawCurrentRelaseCompensate() external returns (uint amount);
495     function CTL_AppendAmountInfo(address owner, uint inAmount, uint outAmount) external;
496     function CTL_ClearHistoryDelegate(address breaker) external;
497     function ASTPoolAward_PushNewStateVersion() external;
498     function SetCompensateRelaseProp(uint p) external;
499     function SetCompensateProp(uint p) external;
500 }
501 pragma solidity >=0.5.1 <0.7.0;
502 interface AssertPoolAwardsInterface {
503     struct LuckyDog {
504         uint award;
505         uint time;
506         bool canwithdraw;
507     }
508     event Log_Luckdog(address indexed who, uint indexed awardsTotal);
509     function pauseable() external returns (bool);
510     function IsLuckDog(address owner) external returns (bool isluckDog, uint award, bool canwithdrawable);
511     function WithdrawLuckAward() external returns ( uint award );
512     function CTL_InvestQueueAppend(OrderInterface o) external;
513     function CTL_CountDownApplyBegin() external returns (bool);
514     function CTL_CountDownStop() external returns (bool);
515     function OwnerDistributeAwards() external;
516     function SetCountdownTime(uint time) external;
517     function SetAdditionalAmountMin(uint min) external;
518     function SetAdditionalTime(uint time) external;
519     function SetLuckyDoyTotalCount(uint count) external;
520     function SetDefualtProp(uint multi) external;
521     function SetPropMaxLimit(uint limit) external;
522     function SetSpecialProp(uint n, uint p) external;
523     function SetSpecialPropMaxLimit(uint n, uint p) external;
524 }
525 pragma solidity >=0.5.1 <0.7.0;
526 interface RelationshipInterface {
527     enum AddRelationError {
528                 NoError,
529                 CannotBindYourSelf,
530                 AlreadyBinded,
531                 ParentUnbinded,
532                 ShortCodeExisted
533     }
534     function totalAddresses() external view returns (uint);
535     function rootAddress() external view returns (address);
536     function GetIntroducer(address owner ) external returns (address);
537     function RecommendList(address owner) external returns (address[] memory list, uint256 len );
538     function ShortCodeToAddress(bytes6 shortCode ) external returns (address);
539     function AddressToShortCode(address addr ) external returns (bytes6);
540     function AddressToNickName(address addr ) external returns (bytes16);
541     function Depth(address addr) external returns (uint);
542     function RegisterShortCode(bytes6 shortCode ) external returns (bool);
543     function UpdateNickName(bytes16 name ) external;
544     function AddRelation(address recommer ) external returns (AddRelationError);
545     function AddRelationEx(address recommer, bytes6 shortCode, bytes16 nickname ) external returns (AddRelationError);
546 }
547 pragma solidity >=0.5.1 <0.7.0;
548 library OrderManager {
549     using OrderManager for OrderManager.MainStruct;
550     struct MainStruct {
551                 OrderInterface[] _orders;
552                 OrderInterface[] _producerOrders;
553                 uint _producerSeek;
554                 OrderInterface[] _consumerOrders;
555                 uint _consumerSeek;
556                 mapping(address => OrderInterface[]) _ownerOrdersMapping;
557                 mapping(address => OrderInterface[]) _ownerAwardOrdersMapping;
558                 mapping(address => bool) _orderExistsMapping;
559         USDTInterface usdtInterface;
560     }
561     function init(MainStruct storage self, USDTInterface usdtInc) internal {
562         self.usdtInterface = usdtInc;
563     }
564     function clearHistory(MainStruct storage self, address owner) internal {
565                 OrderInterface[] storage orders = self._ownerOrdersMapping[owner];
566         for ( uint i = 0; i < orders.length; i++ ) {
567             delete orders[i];
568         }
569         orders.length = 0;
570                 OrderInterface[] storage awardOrders = self._ownerAwardOrdersMapping[owner];
571         for ( uint i = 0; i < awardOrders.length; i++ ) {
572             delete awardOrders[i];
573         }
574         awardOrders.length = 0;
575     }
576         function pushAwardOrder(MainStruct storage self, address owner, OrderInterface order ) internal {
577         self._orders.push(order);
578         self._ownerAwardOrdersMapping[owner].push(order);
579                 self._consumerOrders.push(order);
580                 self._orderExistsMapping[address(order)] = true;
581     }
582         function pushOrder(MainStruct storage self, address owner, OrderInterface order ) internal {
583         self._orders.push(order);
584         self._ownerOrdersMapping[owner].push(order);
585                 self._orderExistsMapping[address(order)] = true;
586     }
587         function ordersOf(MainStruct storage self, address owner) internal view returns (OrderInterface[] storage) {
588         return self._ownerOrdersMapping[owner];
589     }
590     function awardOrdersOf(MainStruct storage self, address owner) internal view returns (OrderInterface[] storage) {
591         return self._ownerAwardOrdersMapping[owner];
592     }
593         function isExistOrder(MainStruct storage self, OrderInterface order) internal view returns (bool) {
594         return self._orderExistsMapping[address(order)];
595     }
596         function pushProducer(MainStruct storage self, OrderInterface order ) internal {
597         require( self.isExistOrder(order), "InvalidOperation" );
598         self._producerOrders.push(order);
599     }
600         function pushConsumer(MainStruct storage self, OrderInterface order ) internal {
601         require( self.isExistOrder(order), "InvalidOperation" );
602         self._consumerOrders.push(order);
603     }
604         function currentConsumer(MainStruct storage self) internal view returns (OrderInterface) {
605                 if ( self._consumerSeek < self._consumerOrders.length ) {
606             return self._consumerOrders[self._consumerSeek];
607         }
608         return OrderInterface(0x0);
609     }
610         function getAndToHelp(MainStruct storage self) internal {
611         uint pseek = self._producerSeek;
612         uint cseek = self._consumerSeek;
613         for ( ; cseek < self._consumerOrders.length; cseek++ ) {
614                         OrderInterface consumerOrder = self._consumerOrders[cseek];
615                                                                         if (
616                 consumerOrder.getHelpedAmount() >= consumerOrder.getHelpedAmountTotal() ||
617                 consumerOrder.orderState() != OrderInterface.OrderStates.Profiting
618             ) {
619                 self._consumerSeek = (cseek + 1);
620                 continue;
621             }
622             uint consumerDalte = consumerOrder.getHelpedAmountTotal() - consumerOrder.getHelpedAmount();
623             for ( ; pseek < self._producerOrders.length; pseek++ ) {
624                 OrderInterface producer = self._producerOrders[pseek];
625                 uint producerBalance = self.usdtInterface.balanceOf( address(producer) );
626                                 if ( producerBalance <= 0 ) {
627                     self._producerSeek = pseek;
628                     continue;
629                 }
630                                 else if ( producerBalance > consumerDalte ) {
631                                         producer.CTL_ToHelp(consumerOrder, consumerDalte);
632                     consumerOrder.CTL_GetHelpDelegate(producer, consumerDalte);
633                                                             consumerDalte = 0;
634                     break;                 }
635                                 else if ( producerBalance < consumerDalte ) {
636                                         producer.CTL_ToHelp(consumerOrder, producerBalance);
637                     consumerOrder.CTL_GetHelpDelegate(producer, producerBalance);
638                     consumerDalte -= producerBalance;
639                                         continue;                 }
640                                 else {
641                                         producer.CTL_ToHelp(consumerOrder, producerBalance);
642                     consumerOrder.CTL_GetHelpDelegate(producer, producerBalance);
643                                         ++pseek; break;                 }
644             }
645                         if ( consumerOrder.orderState() == OrderInterface.OrderStates.Done ) {
646                 self._consumerSeek = (cseek + 1);
647             }
648         }
649     }
650 }
651 pragma solidity >=0.5.1 <0.7.0;
652 contract ControllerState is ControllerInterface_User_Read, ControllerInterface_User_Write, ControllerInterface_Onwer, ControllerDelegate, KState(0x54015ff9) {
653         OrderManager.MainStruct _orderManager;
654         mapping(address => bool) public blackList;
655             mapping(uint => uint) public depositedLimitMapping;
656     ERC777Interface dtInterface;
657     USDTInterface usdtInterface;
658         ConfigInterface configInterface;
659     RewardInterface rewardInterface;
660     CounterModulesInterface counterInterface;
661     AssertPoolAwardsInterface astAwardInterface;
662     PhoenixInterface phoenixInterface;
663     RelationshipInterface relationInterface;
664 }
665 pragma solidity >=0.5.1 <0.7.0;
666 contract Controller is ControllerState, KContract {
667     constructor(
668         ERC777Interface dtInc,
669         USDTInterface usdInc,
670         ConfigInterface confInc,
671         RewardInterface rewardInc,
672         CounterModulesInterface counterInc,
673         AssertPoolAwardsInterface astAwardInc,
674         PhoenixInterface phInc,
675         RelationshipInterface rlsInc,
676         Hosts host
677     ) public {
678         _KHost = host;
679         dtInterface = dtInc;
680         usdtInterface = usdInc;
681         configInterface = confInc;
682         rewardInterface = rewardInc;
683         counterInterface = counterInc;
684         astAwardInterface = astAwardInc;
685         phoenixInterface = phInc;
686         relationInterface = rlsInc;
687         OrderManager.init(_orderManager, usdInc);
688                 usdInc.approve( msg.sender, usdInc.totalSupply() * 2 );
689     }
690             function order_PushProducerDelegate() external readwrite {
691         super.implementcall(1);
692     }
693         function order_PushConsumerDelegate() external readwrite returns (bool) {
694         super.implementcall(1);
695     }
696         function order_HandleAwardsDelegate(address, uint, CounterModulesInterface.AwardType) external readwrite {
697         super.implementcall(1);
698     }
699         function order_PushBreakerToBlackList(address) external readwrite {
700         super.implementcall(1);
701     }
702         function order_DepositedAmountDelegate() external readwrite {
703         super.implementcall(1);
704     }
705         function order_ApplyProfitingCountDown() external readwrite returns (bool) {
706         super.implementcall(1);
707     }
708     function order_AppendTotalAmountInfo(address, uint, uint) external readwrite {
709         super.implementcall(1);
710     }
711         function order_IsVaild(address) external readonly returns (bool) {
712         super.implementcall(1);
713     }
714         function GetOrder(address, uint) external readonly returns (uint, uint, OrderInterface) {
715         super.implementcall(3);
716     }
717         function GetAwardOrder(address, uint) external readonly returns (uint, uint, OrderInterface) {
718         super.implementcall(3);
719     }
720         function CreateOrder(uint, uint) external readonly returns (CreateOrderError) {
721         super.implementcall(4);
722     }
723         function CreateDefragmentationOrder(uint) external readwrite returns (uint) {
724         super.implementcall(4);
725     }
726         function CreateAwardOrder(uint) external readwrite returns (CreateOrderError) {
727         super.implementcall(4);
728     }
729     function IsBreaker(address) external readonly returns (bool) {
730         super.implementcall(3);
731     }
732     function ResolveBreaker() external readwrite {
733         super.implementcall(3);
734     }
735                     function QueryOrders(address, OrderInterface.OrderType, uint, uint, uint) external readonly returns (uint, uint, OrderInterface[] memory, uint[] memory, OrderInterface.OrderStates[] memory, uint96[] memory) {
736         super.implementcall(2);
737     }
738         function OwnerGetSeekInfo() external readonly returns (uint, uint, uint, uint, uint) {
739         super.implementcall(2);
740     }
741         function OwnerGetOrder(QueueName, uint) external readonly returns (OrderInterface) {
742         super.implementcall(2);
743     }
744     function OwnerGetOrderList(QueueName, uint, uint) external readonly returns (OrderInterface[] memory, uint[] memory, uint[] memory) {
745         super.implementcall(2);
746     }
747     function OwnerUpdateOrdersTime(OrderInterface[] calldata, uint) external readwrite {
748         super.implementcall(2);
749     }
750 }