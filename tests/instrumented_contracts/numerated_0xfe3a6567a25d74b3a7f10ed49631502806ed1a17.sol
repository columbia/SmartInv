1 pragma solidity ^0.5.2;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract EIP712 {
6     string internal constant DOMAIN_NAME = "Mai Protocol";
7 
8     
9     bytes32 public constant EIP712_DOMAIN_TYPEHASH = keccak256(
10         abi.encodePacked("EIP712Domain(string name)")
11     );
12 
13     bytes32 public DOMAIN_SEPARATOR;
14 
15     constructor () public {
16         DOMAIN_SEPARATOR = keccak256(
17             abi.encodePacked(
18                 EIP712_DOMAIN_TYPEHASH,
19                 keccak256(bytes(DOMAIN_NAME))
20             )
21         );
22     }
23 
24     
25     function hashEIP712Message(bytes32 eip712hash) internal view returns (bytes32) {
26         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
27     }
28 }
29 
30 contract LibSignature {
31 
32     enum SignatureMethod {
33         EthSign,
34         EIP712
35     }
36 
37     
38     struct OrderSignature {
39         
40         bytes32 config;
41         bytes32 r;
42         bytes32 s;
43     }
44 
45     
46     function isValidSignature(bytes32 hash, address signerAddress, OrderSignature memory signature)
47         internal
48         pure
49         returns (bool)
50     {
51         uint8 method = uint8(signature.config[1]);
52         address recovered;
53         uint8 v = uint8(signature.config[0]);
54 
55         if (method == uint8(SignatureMethod.EthSign)) {
56             recovered = ecrecover(
57                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
58                 v,
59                 signature.r,
60                 signature.s
61             );
62         } else if (method == uint8(SignatureMethod.EIP712)) {
63             recovered = ecrecover(hash, v, signature.r, signature.s);
64         } else {
65             revert("INVALID_SIGN_METHOD");
66         }
67 
68         return signerAddress == recovered;
69     }
70 }
71 
72 library SafeMath {
73     
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77 
78         return c;
79     }
80 
81     
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b <= a, "SafeMath: subtraction overflow");
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         
92         
93         
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100 
101         return c;
102     }
103 
104     
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         
107         require(b > 0, "SafeMath: division by zero");
108         uint256 c = a / b;
109         
110 
111         return c;
112     }
113 
114     
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0, "SafeMath: modulo by zero");
117         return a % b;
118     }
119 }
120 
121 contract LibMath {
122     using SafeMath for uint256;
123 
124     
125     function isRoundingError(uint256 numerator, uint256 denominator, uint256 multiple)
126         internal
127         pure
128         returns (bool)
129     {
130         return numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple);
131     }
132 
133     
134     
135     
136     function getPartialAmountFloor(uint256 numerator, uint256 denominator, uint256 multiple)
137         internal
138         pure
139         returns (uint256)
140     {
141         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
142         return numerator.mul(multiple).div(denominator);
143     }
144 
145     
146     function min(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a < b ? a : b;
148     }
149 }
150 
151 contract LibOrder is EIP712, LibSignature, LibMath {
152 
153     uint256 public constant REBATE_RATE_BASE = 100;
154 
155     struct Order {
156         address trader;
157         address relayer;
158         address marketContractAddress;
159         uint256 amount;
160         uint256 price;
161         uint256 gasTokenAmount;
162 
163         
164         bytes32 data;
165     }
166 
167     enum OrderStatus {
168         EXPIRED,
169         CANCELLED,
170         FILLABLE,
171         FULLY_FILLED
172     }
173 
174     enum FillAction {
175         INVALID,
176         BUY,
177         SELL,
178         MINT,
179         REDEEM
180     }
181 
182     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
183         abi.encodePacked(
184             "Order(address trader,address relayer,address marketContractAddress,uint256 amount,uint256 price,uint256 gasTokenAmount,bytes32 data)"
185         )
186     );
187 
188     
189     function getOrderHash(Order memory order) internal view returns (bytes32 orderHash) {
190         orderHash = hashEIP712Message(hashOrder(order));
191         return orderHash;
192     }
193 
194     
195     function hashOrder(Order memory order) internal pure returns (bytes32 result) {
196         
197         bytes32 orderType = EIP712_ORDER_TYPE;
198 
199         assembly {
200             let start := sub(order, 32)
201             let tmp := mload(start)
202 
203             
204             
205             
206             
207             mstore(start, orderType)
208             result := keccak256(start, 256)
209 
210             mstore(start, tmp)
211         }
212 
213         return result;
214     }
215 
216     
217 
218     function getOrderVersion(bytes32 data) internal pure returns (uint256) {
219         return uint256(uint8(byte(data)));
220     }
221 
222     function getExpiredAtFromOrderData(bytes32 data) internal pure returns (uint256) {
223         return uint256(uint40(bytes5(data << (8*3))));
224     }
225 
226     function isSell(bytes32 data) internal pure returns (bool) {
227         return uint8(data[1]) == 1;
228     }
229 
230     function isMarketOrder(bytes32 data) internal pure returns (bool) {
231         return uint8(data[2]) == 1;
232     }
233 
234     function isMakerOnly(bytes32 data) internal pure returns (bool) {
235         return uint8(data[22]) == 1;
236     }
237 
238     function isMarketBuy(bytes32 data) internal pure returns (bool) {
239         return !isSell(data) && isMarketOrder(data);
240     }
241 
242     function getAsMakerFeeRateFromOrderData(bytes32 data) internal pure returns (uint256) {
243         return uint256(uint16(bytes2(data << (8*8))));
244     }
245 
246     function getAsTakerFeeRateFromOrderData(bytes32 data) internal pure returns (uint256) {
247         return uint256(uint16(bytes2(data << (8*10))));
248     }
249 
250     function getMakerRebateRateFromOrderData(bytes32 data) internal pure returns (uint256) {
251         uint256 makerRebate = uint256(uint16(bytes2(data << (8*12))));
252 
253         
254         return min(makerRebate, REBATE_RATE_BASE);
255     }
256 }
257 
258 contract LibOwnable {
259     address private _owner;
260 
261     event OwnershipTransferred(
262         address indexed previousOwner,
263         address indexed newOwner
264     );
265 
266     
267     constructor() internal {
268         _owner = msg.sender;
269         emit OwnershipTransferred(address(0), _owner);
270     }
271 
272     
273     function owner() public view returns(address) {
274         return _owner;
275     }
276 
277     
278     modifier onlyOwner() {
279         require(isOwner(), "NOT_OWNER");
280         _;
281     }
282 
283     
284     function isOwner() public view returns(bool) {
285         return msg.sender == _owner;
286     }
287 
288     
289     
290     
291     
292     function renounceOwnership() public onlyOwner {
293         emit OwnershipTransferred(_owner, address(0));
294         _owner = address(0);
295     }
296 
297     
298     
299     function transferOwnership(address newOwner) public onlyOwner {
300         require(newOwner != address(0), "INVALID_OWNER");
301         emit OwnershipTransferred(_owner, newOwner);
302         _owner = newOwner;
303     }
304 }
305 
306 contract LibRelayer {
307 
308     
309     mapping (address => mapping (address => bool)) public relayerDelegates;
310 
311     
312     mapping (address => bool) hasExited;
313 
314     event RelayerApproveDelegate(address indexed relayer, address indexed delegate);
315     event RelayerRevokeDelegate(address indexed relayer, address indexed delegate);
316 
317     event RelayerExit(address indexed relayer);
318     event RelayerJoin(address indexed relayer);
319 
320     
321     function approveDelegate(address delegate) external {
322         relayerDelegates[msg.sender][delegate] = true;
323         emit RelayerApproveDelegate(msg.sender, delegate);
324     }
325 
326     
327     function revokeDelegate(address delegate) external {
328         relayerDelegates[msg.sender][delegate] = false;
329         emit RelayerRevokeDelegate(msg.sender, delegate);
330     }
331 
332     
333     function canMatchMarketContractOrdersFrom(address relayer) public view returns(bool) {
334         return msg.sender == relayer || relayerDelegates[relayer][msg.sender] == true;
335     }
336 
337     
338     function joinIncentiveSystem() external {
339         delete hasExited[msg.sender];
340         emit RelayerJoin(msg.sender);
341     }
342 
343     
344     function exitIncentiveSystem() external {
345         hasExited[msg.sender] = true;
346         emit RelayerExit(msg.sender);
347     }
348 
349     
350     function isParticipant(address relayer) public view returns(bool) {
351         return !hasExited[relayer];
352     }
353 }
354 
355 contract LibExchangeErrors {
356     string constant INVALID_TRADER = "INVALID_TRADER";
357     string constant INVALID_SENDER = "INVALID_SENDER";
358     
359     string constant INVALID_MATCH = "INVALID_MATCH";
360     string constant REDEEM_PRICE_NOT_MET = "REDEEM_PRICE_NOT_MET";
361     string constant MINT_PRICE_NOT_MET = "MINT_PRICE_NOT_MET";
362     string constant INVALID_SIDE = "INVALID_SIDE";
363     
364     string constant INVALID_ORDER_SIGNATURE = "INVALID_ORDER_SIGNATURE";
365     
366     string constant ORDER_IS_NOT_FILLABLE = "ORDER_IS_NOT_FILLABLE";
367     string constant MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER = "MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER";
368     string constant TRANSFER_FROM_FAILED = "TRANSFER_FROM_FAILED";
369     string constant MAKER_ORDER_OVER_MATCH = "MAKER_ORDER_OVER_MATCH";
370     string constant TAKER_ORDER_OVER_MATCH = "TAKER_ORDER_OVER_MATCH";
371     string constant ORDER_VERSION_NOT_SUPPORTED = "ORDER_VERSION_NOT_SUPPORTED";
372     string constant MAKER_ONLY_ORDER_CANNOT_BE_TAKER = "MAKER_ONLY_ORDER_CANNOT_BE_TAKER";
373     string constant TRANSFER_FAILED = "TRANSFER_FAILED";
374     string constant MINT_POSITION_TOKENS_FAILED = "MINT_FAILED";
375     string constant REDEEM_POSITION_TOKENS_FAILED = "REDEEM_FAILED";
376     string constant UNEXPECTED_MATCH = "UNEXPECTED_MATCH";
377     string constant INSUFFICIENT_FEE = "INSUFFICIENT_FEE";
378     string constant INVALID_MARKET_CONTRACT = "INVALID_MARKET_CONTRACT";
379     string constant UNMATCHED_FILL = "UNMATCHED_FILL";
380     string constant LOW_MARGIN = "LOW_MARGIN";
381     string constant INVALID_AMOUNT = "LOW_MARGIN";
382     string constant MAKER_CAN_NOT_BE_SAME_WITH_TAKER = "MAKER_CANNOT_BE_TAKER";
383 }
384 
385 interface IMarketContract {
386     
387     function CONTRACT_NAME()
388         external
389         view
390         returns (string memory);
391     function COLLATERAL_TOKEN_ADDRESS()
392         external
393         view
394         returns (address);
395     function COLLATERAL_POOL_ADDRESS()
396         external
397         view
398         returns (address);
399     function PRICE_CAP()
400         external
401         view
402         returns (uint);
403     function PRICE_FLOOR()
404         external
405         view
406         returns (uint);
407     function PRICE_DECIMAL_PLACES()
408         external
409         view
410         returns (uint);
411     function QTY_MULTIPLIER()
412         external
413         view
414         returns (uint);
415     function COLLATERAL_PER_UNIT()
416         external
417         view
418         returns (uint);
419     function COLLATERAL_TOKEN_FEE_PER_UNIT()
420         external
421         view
422         returns (uint);
423     function MKT_TOKEN_FEE_PER_UNIT()
424         external
425         view
426         returns (uint);
427     function EXPIRATION()
428         external
429         view
430         returns (uint);
431     function SETTLEMENT_DELAY()
432         external
433         view
434         returns (uint);
435     function LONG_POSITION_TOKEN()
436         external
437         view
438         returns (address);
439     function SHORT_POSITION_TOKEN()
440         external
441         view
442         returns (address);
443 
444     
445     function lastPrice()
446         external
447         view
448         returns (uint);
449     function settlementPrice()
450         external
451         view
452         returns (uint);
453     function settlementTimeStamp()
454         external
455         view
456         returns (uint);
457     function isSettled()
458         external
459         view
460         returns (bool);
461 
462     
463     function isPostSettlementDelay()
464         external
465         view
466         returns (bool);
467 }
468 
469 contract IMarketContractPool {
470     function mintPositionTokens(
471         address marketContractAddress,
472         uint qtyToMint,
473         bool isAttemptToPayInMKT
474     ) external;
475     function redeemPositionTokens(
476         address marketContractAddress,
477         uint qtyToRedeem
478     ) external;
479     function mktToken() external view returns (address);
480 }
481 
482 contract IMarketContractRegistry {
483     function addAddressToWhiteList(address contractAddress) external;
484     function isAddressWhiteListed(address contractAddress) external view returns (bool);
485 }
486 
487 interface IERC20 {
488     
489     function totalSupply() external view returns (uint256);
490 
491     
492     function balanceOf(address account) external view returns (uint256);
493 
494     
495     function transfer(address recipient, uint256 amount) external returns (bool);
496 
497     
498     function allowance(address owner, address spender) external view returns (uint256);
499 
500     
501     function approve(address spender, uint256 amount) external returns (bool);
502 
503     
504     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
505 
506     
507     event Transfer(address indexed from, address indexed to, uint256 value);
508 
509     
510     event Approval(address indexed owner, address indexed spender, uint256 value);
511 }
512 
513 library Address {
514     
515     function isContract(address account) internal view returns (bool) {
516         
517         
518         
519 
520         uint256 size;
521         
522         assembly { size := extcodesize(account) }
523         return size > 0;
524     }
525 }
526 
527 library SafeERC20 {
528     using SafeMath for uint256;
529     using Address for address;
530 
531     function safeTransfer(IERC20 token, address to, uint256 value) internal {
532         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
533     }
534 
535     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
536         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
537     }
538 
539     function safeApprove(IERC20 token, address spender, uint256 value) internal {
540         
541         
542         
543         
544         require((value == 0) || (token.allowance(address(this), spender) == 0),
545             "SafeERC20: approve from non-zero to non-zero allowance"
546         );
547         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
548     }
549 
550     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
551         uint256 newAllowance = token.allowance(address(this), spender).add(value);
552         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
553     }
554 
555     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
556         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
557         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
558     }
559 
560     
561     function callOptionalReturn(IERC20 token, bytes memory data) private {
562         
563         
564 
565         
566         
567         
568         
569         
570         require(address(token).isContract(), "SafeERC20: call to non-contract");
571 
572         
573         (bool success, bytes memory returndata) = address(token).call(data);
574         require(success, "SafeERC20: low-level call failed");
575 
576         if (returndata.length > 0) { 
577             
578             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
579         }
580     }
581 }
582 
583 contract MaiProtocol is LibMath, LibOrder, LibRelayer, LibExchangeErrors, LibOwnable {
584     using SafeMath for uint256;
585     using SafeERC20 for IERC20;
586 
587     uint256 public constant MAX_MATCHES = 3;
588     uint256 public constant LONG = 0;
589     uint256 public constant SHORT = 1;
590     uint256 public constant FEE_RATE_BASE = 100000;
591 
592     
593     uint256 public constant SUPPORTED_ORDER_VERSION = 1;
594 
595     
596     address public marketRegistryAddress;
597 
598     
599     address public mintingPoolAddress;
600 
601     
602     mapping (bytes32 => uint256) public filled;
603 
604     
605     mapping (bytes32 => bool) public cancelled;
606 
607     
608     struct OrderParam {
609         address trader;
610         uint256 amount;
611         uint256 price;
612         uint256 gasTokenAmount;
613         bytes32 data;
614         OrderSignature signature;
615     }
616 
617     
618     struct OrderInfo {
619         bytes32 orderHash;
620         uint256 filledAmount;
621         uint256[2] margins;     
622         uint256[2] balances;    
623     }
624 
625     struct OrderAddressSet {
626         address marketContractAddress;
627         address relayer;
628     }
629 
630     struct OrderContext {
631         IMarketContract marketContract;         
632         IMarketContractPool marketContractPool; 
633         IERC20 collateral;                      
634         IERC20[2] positions;                    
635         uint256 takerSide;                      
636     }
637 
638     struct MatchResult {
639         address maker;
640         address taker;
641         uint256 makerFee;                   
642         uint256 takerFee;                   
643         uint256 makerGasFee;
644         uint256 takerGasFee;
645         uint256 posFilledAmount;            
646         uint256 ctkFilledAmount;            
647         FillAction fillAction;
648     }
649 
650 
651     event Match(
652         OrderAddressSet addressSet,
653         MatchResult result
654     );
655     event Cancel(bytes32 indexed orderHash);
656     event Withdraw(address indexed tokenAddress, address indexed to, uint256 amount);
657     event Approval(address indexed tokenAddress, address indexed spender, uint256 amount);
658 
659     
660     function setMarketRegistryAddress(address _marketRegistryAddress)
661         external
662         onlyOwner
663     {
664         marketRegistryAddress = _marketRegistryAddress;
665     }
666 
667 
668     function setMintingPool(address _mintingPoolAddress)
669         external
670         onlyOwner
671     {
672         mintingPoolAddress = _mintingPoolAddress;
673     }
674 
675     function approveERC20(address token, address spender, uint256 amount)
676         external
677         onlyOwner
678     {
679         IERC20(token).safeApprove(spender, amount);
680         emit Approval(token, spender, amount);
681     }
682 
683     function withdrawERC20(address token, uint256 amount)
684         external
685         onlyOwner
686     {
687         require(amount > 0, INVALID_AMOUNT);
688         IERC20(token).safeTransfer(msg.sender, amount);
689 
690         emit Withdraw(token, msg.sender, amount);
691     }
692 
693 
694     
695     function matchMarketContractOrders(
696         OrderParam memory takerOrderParam,
697         OrderParam[] memory makerOrderParams,
698         uint256[] memory posFilledAmounts,
699         OrderAddressSet memory orderAddressSet
700     )
701         public
702     {
703         require(canMatchMarketContractOrdersFrom(orderAddressSet.relayer), INVALID_SENDER);
704         require(!isMakerOnly(takerOrderParam.data), MAKER_ONLY_ORDER_CANNOT_BE_TAKER);
705 
706         validateMarketContract(orderAddressSet.marketContractAddress);
707         OrderContext memory orderContext = getOrderContext(orderAddressSet, takerOrderParam);
708         matchAndSettle(
709             takerOrderParam,
710             makerOrderParams,
711             posFilledAmounts,
712             orderAddressSet,
713             orderContext
714         );
715     }
716 
717     
718     function getOrderContext(
719         OrderAddressSet memory orderAddressSet,
720         OrderParam memory takerOrderParam
721     )
722         internal
723         view
724         returns (OrderContext memory orderContext)
725     {
726         orderContext.marketContract = IMarketContract(orderAddressSet.marketContractAddress);
727         orderContext.marketContractPool = IMarketContractPool(
728             orderContext.marketContract.COLLATERAL_POOL_ADDRESS()
729         );
730         orderContext.collateral = IERC20(orderContext.marketContract.COLLATERAL_TOKEN_ADDRESS());
731         orderContext.positions[LONG] = IERC20(orderContext.marketContract.LONG_POSITION_TOKEN());
732         orderContext.positions[SHORT] = IERC20(orderContext.marketContract.SHORT_POSITION_TOKEN());
733         orderContext.takerSide = isSell(takerOrderParam.data) ? SHORT : LONG;
734 
735         return orderContext;
736     }
737 
738     
739     function matchAndSettle(
740         OrderParam memory takerOrderParam,
741         OrderParam[] memory makerOrderParams,
742         uint256[] memory posFilledAmounts,
743         OrderAddressSet memory orderAddressSet,
744         OrderContext memory orderContext
745     )
746         internal
747     {
748         OrderInfo memory takerOrderInfo = getOrderInfo(
749             takerOrderParam,
750             orderAddressSet,
751             orderContext
752         );
753         for (uint256 i = 0; i < makerOrderParams.length; i++) {
754             require(!isMarketOrder(makerOrderParams[i].data), MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER);
755             require(isSell(takerOrderParam.data) != isSell(makerOrderParams[i].data), INVALID_SIDE);
756             require(
757                 takerOrderParam.trader != makerOrderParams[i].trader,
758                 MAKER_CAN_NOT_BE_SAME_WITH_TAKER
759             );
760             OrderInfo memory makerOrderInfo = getOrderInfo(
761                 makerOrderParams[i],
762                 orderAddressSet,
763                 orderContext
764             );
765             validatePrice(
766                 takerOrderParam,
767                 makerOrderParams[i]
768             );
769             uint256 toFillAmount = posFilledAmounts[i];
770             for (uint256 j = 0; j < MAX_MATCHES && toFillAmount > 0; j++) {
771                 MatchResult memory result;
772                 uint256 filledAmount;
773                 (result, filledAmount) = getMatchResult(
774                     takerOrderParam,
775                     takerOrderInfo,
776                     makerOrderParams[i],
777                     makerOrderInfo,
778                     orderContext,
779                     toFillAmount
780                 );
781                 toFillAmount = toFillAmount.sub(filledAmount);
782                 settleResult(result, orderAddressSet, orderContext);
783             }
784             
785             
786             require(toFillAmount == 0, UNMATCHED_FILL);
787             filled[makerOrderInfo.orderHash] = makerOrderInfo.filledAmount;
788         }
789         filled[takerOrderInfo.orderHash] = takerOrderInfo.filledAmount;
790     }
791 
792     
793     function validateMarketContract(address marketContractAddress) internal view {
794         if (marketRegistryAddress == address(0x0)) {
795             return;
796         }
797         IMarketContractRegistry registry = IMarketContractRegistry(marketRegistryAddress);
798         require(
799             registry.isAddressWhiteListed(marketContractAddress),
800             INVALID_MARKET_CONTRACT
801         );
802     }
803 
804     
805     function calculateMiddleCollateralPerUnit(OrderContext memory orderContext)
806         internal
807         view
808         returns (uint256)
809     {
810         return orderContext.marketContract.PRICE_CAP()
811             .add(orderContext.marketContract.PRICE_FLOOR())
812             .mul(orderContext.marketContract.QTY_MULTIPLIER())
813             .div(2);
814     }
815 
816     
817     function calculateLongMargin(OrderContext memory orderContext, OrderParam memory orderParam)
818         internal
819         view
820         returns (uint256)
821     {
822         return orderParam.price
823             .sub(orderContext.marketContract.PRICE_FLOOR())
824             .mul(orderContext.marketContract.QTY_MULTIPLIER());
825     }
826 
827     
828     function calculateShortMargin(OrderContext memory orderContext, OrderParam memory orderParam)
829         internal
830         view
831         returns (uint256)
832     {
833         return orderContext.marketContract.PRICE_CAP()
834             .sub(orderParam.price)
835             .mul(orderContext.marketContract.QTY_MULTIPLIER());
836     }
837 
838     
839     function validatePrice(
840         OrderParam memory takerOrderParam,
841         OrderParam memory makerOrderParam
842     )
843         internal
844         pure
845     {
846         if (isMarketOrder(takerOrderParam.data)) {
847             return;
848         }
849         if (isSell(takerOrderParam.data)) {
850             require(takerOrderParam.price <= makerOrderParam.price, INVALID_MATCH);
851         } else {
852             require(takerOrderParam.price >= makerOrderParam.price, INVALID_MATCH);
853         }
854     }
855 
856     
857     function getMatchResult(
858         OrderParam memory takerOrderParam,
859         OrderInfo memory takerOrderInfo,
860         OrderParam memory makerOrderParam,
861         OrderInfo memory makerOrderInfo,
862         OrderContext memory orderContext,
863         uint256 posFilledAmount
864     )
865         internal
866         view
867         returns (MatchResult memory result, uint256 filledAmount)
868     {
869         require(makerOrderInfo.filledAmount <= makerOrderParam.amount, MAKER_ORDER_OVER_MATCH);
870         require(takerOrderInfo.filledAmount <= takerOrderParam.amount, TAKER_ORDER_OVER_MATCH);
871 
872         
873         if (takerOrderInfo.filledAmount == 0) {
874             result.takerGasFee = takerOrderParam.gasTokenAmount;
875         }
876         if (makerOrderInfo.filledAmount == 0) {
877             result.makerGasFee = makerOrderParam.gasTokenAmount;
878         }
879 
880         
881         filledAmount = fillMatchResult(
882             result,
883             takerOrderParam,
884             takerOrderInfo,
885             makerOrderParam,
886             makerOrderInfo,
887             orderContext,
888             posFilledAmount
889         );
890         result.posFilledAmount = filledAmount;
891 
892         
893         result.makerFee = filledAmount.mul(getMakerFeeBase(orderContext, makerOrderParam));
894         result.takerFee = filledAmount.mul(getTakerFeeBase(orderContext, takerOrderParam));
895         result.taker = takerOrderParam.trader;
896         result.maker = makerOrderParam.trader;
897 
898         return (result, filledAmount);
899     }
900 
901     
902     function getMakerFeeBase(
903         OrderContext memory orderContext,
904         OrderParam memory orderParam
905     )
906         internal
907         view
908         returns (uint256)
909     {
910         uint256 middleCollateralPerUnit = calculateMiddleCollateralPerUnit(orderContext);
911         return middleCollateralPerUnit
912             .mul(getAsMakerFeeRateFromOrderData(orderParam.data))
913             .div(FEE_RATE_BASE);
914     }
915 
916     
917     function getTakerFeeBase(
918         OrderContext memory orderContext,
919         OrderParam memory orderParam
920     )
921         internal
922         view
923         returns (uint256)
924     {
925         uint256 middleCollateralPerUnit = calculateMiddleCollateralPerUnit(orderContext);
926         return middleCollateralPerUnit
927             .mul(getAsTakerFeeRateFromOrderData(orderParam.data))
928             .div(FEE_RATE_BASE);
929     }
930 
931     
932     function fillMatchResult(
933         MatchResult memory result,
934         OrderParam memory takerOrderParam,
935         OrderInfo memory takerOrderInfo,
936         OrderParam memory makerOrderParam,
937         OrderInfo memory makerOrderInfo,
938         OrderContext memory orderContext,
939         uint256 posFilledAmount
940     )
941         internal
942         pure
943         returns (uint256 filledAmount)
944     {
945         uint256 side = orderContext.takerSide;
946         uint256 opposite = oppositeSide(side);
947 
948         if (takerOrderInfo.balances[opposite] > 0 && makerOrderInfo.balances[side] > 0) {
949             
950             filledAmount = min(
951                 min(takerOrderInfo.balances[opposite], posFilledAmount),
952                 makerOrderInfo.balances[side]
953             );
954             
955             takerOrderInfo.balances[opposite] = takerOrderInfo.balances[opposite]
956                 .sub(filledAmount);
957             makerOrderInfo.balances[side] = makerOrderInfo.balances[side].sub(filledAmount);
958 
959             result.fillAction = FillAction.REDEEM;
960             result.ctkFilledAmount = makerOrderInfo.margins[side].mul(filledAmount);
961 
962        } else if (takerOrderInfo.balances[opposite] > 0 && makerOrderInfo.balances[side] == 0) {
963             
964             filledAmount = min(takerOrderInfo.balances[opposite], posFilledAmount);
965             takerOrderInfo.balances[opposite] = takerOrderInfo.balances[opposite]
966                 .sub(filledAmount);
967             makerOrderInfo.balances[opposite] = makerOrderInfo.balances[opposite]
968                 .add(filledAmount);
969 
970             result.fillAction = FillAction.SELL;
971             result.ctkFilledAmount = makerOrderInfo.margins[opposite].mul(filledAmount);
972 
973        } else if (takerOrderInfo.balances[opposite] == 0 && makerOrderInfo.balances[side] > 0) {
974             
975             filledAmount = min(makerOrderInfo.balances[side], posFilledAmount);
976             takerOrderInfo.balances[side] = takerOrderInfo.balances[side].add(filledAmount);
977             makerOrderInfo.balances[side] = makerOrderInfo.balances[side].sub(filledAmount);
978 
979             result.fillAction = FillAction.BUY;
980             result.ctkFilledAmount = makerOrderInfo.margins[side].mul(filledAmount);
981 
982        } else if (takerOrderInfo.balances[opposite] == 0 && makerOrderInfo.balances[side] == 0) {
983             
984             filledAmount = posFilledAmount;
985             
986             takerOrderInfo.balances[side] = takerOrderInfo.balances[side].add(filledAmount);
987             makerOrderInfo.balances[opposite] = makerOrderInfo.balances[opposite].add(filledAmount);
988 
989             result.fillAction = FillAction.MINT;
990             result.ctkFilledAmount = makerOrderInfo.margins[opposite].mul(filledAmount);
991 
992         } else {
993            revert(UNEXPECTED_MATCH);
994         }
995 
996         
997         takerOrderInfo.filledAmount = takerOrderInfo.filledAmount.add(filledAmount);
998         makerOrderInfo.filledAmount = makerOrderInfo.filledAmount.add(filledAmount);
999 
1000         require(takerOrderInfo.filledAmount <= takerOrderParam.amount, TAKER_ORDER_OVER_MATCH);
1001         require(makerOrderInfo.filledAmount <= makerOrderParam.amount, MAKER_ORDER_OVER_MATCH);
1002 
1003         result.posFilledAmount = filledAmount;
1004 
1005         return filledAmount;
1006     }
1007 
1008     
1009     function cancelOrder(Order memory order) public {
1010         require(msg.sender == order.trader || msg.sender == order.relayer, INVALID_TRADER);
1011 
1012         bytes32 orderHash = getOrderHash(order);
1013         cancelled[orderHash] = true;
1014 
1015         emit Cancel(orderHash);
1016     }
1017 
1018     
1019     function getOrderInfo(
1020         OrderParam memory orderParam,
1021         OrderAddressSet memory orderAddressSet,
1022         OrderContext memory orderContext
1023     )
1024         internal
1025         view
1026         returns (OrderInfo memory orderInfo)
1027     {
1028         require(
1029             getOrderVersion(orderParam.data) == SUPPORTED_ORDER_VERSION,
1030             ORDER_VERSION_NOT_SUPPORTED
1031         );
1032 
1033         Order memory order = getOrderFromOrderParam(orderParam, orderAddressSet);
1034         orderInfo.orderHash = getOrderHash(order);
1035         orderInfo.filledAmount = filled[orderInfo.orderHash];
1036         uint8 status = uint8(OrderStatus.FILLABLE);
1037 
1038         if (orderInfo.filledAmount >= order.amount) {
1039             status = uint8(OrderStatus.FULLY_FILLED);
1040         } else if (block.timestamp >= getExpiredAtFromOrderData(order.data)) {
1041             status = uint8(OrderStatus.EXPIRED);
1042         } else if (cancelled[orderInfo.orderHash]) {
1043             status = uint8(OrderStatus.CANCELLED);
1044         }
1045 
1046         require(status == uint8(OrderStatus.FILLABLE), ORDER_IS_NOT_FILLABLE);
1047         require(
1048             isValidSignature(orderInfo.orderHash, orderParam.trader, orderParam.signature),
1049             INVALID_ORDER_SIGNATURE
1050         );
1051 
1052         
1053         if (!isMarketOrder(orderParam.data)) {
1054             
1055             
1056             orderInfo.margins[LONG] = calculateLongMargin(orderContext, orderParam);
1057             orderInfo.margins[SHORT] = calculateShortMargin(orderContext, orderParam);
1058         }
1059         orderInfo.balances[LONG] = IERC20(orderContext.positions[LONG]).balanceOf(orderParam.trader);
1060         orderInfo.balances[SHORT] = IERC20(orderContext.positions[SHORT]).balanceOf(orderParam.trader);
1061 
1062         return orderInfo;
1063     }
1064 
1065     
1066     function getOrderFromOrderParam(
1067         OrderParam memory orderParam,
1068         OrderAddressSet memory orderAddressSet
1069     )
1070         internal
1071         pure
1072         returns (Order memory order)
1073     {
1074         order.trader = orderParam.trader;
1075         order.relayer = orderAddressSet.relayer;
1076         order.marketContractAddress = orderAddressSet.marketContractAddress;
1077         order.amount = orderParam.amount;
1078         order.price = orderParam.price;
1079         order.gasTokenAmount = orderParam.gasTokenAmount;
1080         order.data = orderParam.data;
1081     }
1082 
1083     
1084     function settleResult(
1085         MatchResult memory result,
1086         OrderAddressSet memory orderAddressSet,
1087         OrderContext memory orderContext
1088     )
1089         internal
1090     {
1091         if (result.fillAction == FillAction.REDEEM) {
1092             doRedeem(result, orderAddressSet, orderContext);
1093         } else if (result.fillAction == FillAction.SELL) {
1094             doSell(result, orderAddressSet, orderContext);
1095         } else if (result.fillAction == FillAction.BUY) {
1096             doBuy(result, orderAddressSet, orderContext);
1097         } else if (result.fillAction == FillAction.MINT) {
1098             doMint(result, orderAddressSet, orderContext);
1099         } else {
1100             revert("UNEXPECTED_FILLACTION");
1101         }
1102         emit Match(orderAddressSet, result);
1103     }
1104 
1105     function doSell(
1106         MatchResult memory result,
1107         OrderAddressSet memory orderAddressSet,
1108         OrderContext memory orderContext
1109     )
1110         internal
1111     {
1112         uint256 takerTotalFee = result.takerFee.add(result.takerGasFee);
1113         uint256 makerTotalFee = result.makerFee.add(result.makerGasFee);
1114         
1115         orderContext.positions[oppositeSide(orderContext.takerSide)]
1116             .safeTransferFrom(
1117                 result.taker,
1118                 result.maker,
1119                 result.posFilledAmount
1120             );
1121         
1122         
1123         orderContext.collateral.safeTransferFrom(
1124             result.maker,
1125             orderAddressSet.relayer,
1126             result.ctkFilledAmount.add(makerTotalFee)
1127         );
1128         if (result.ctkFilledAmount > takerTotalFee) {
1129             
1130             orderContext.collateral.safeTransferFrom(
1131                 orderAddressSet.relayer,
1132                 result.taker,
1133                 result.ctkFilledAmount.sub(takerTotalFee)
1134             );
1135         } else if (result.ctkFilledAmount < takerTotalFee) {
1136             
1137             orderContext.collateral.safeTransferFrom(
1138                 result.taker,
1139                 orderAddressSet.relayer,
1140                 takerTotalFee.sub(result.ctkFilledAmount)
1141             );
1142         }
1143 
1144         
1145         
1146         
1147         
1148         
1149         
1150         
1151         
1152         
1153         
1154         
1155         
1156         
1157     }
1158 
1159     
1160     function doBuy(
1161         MatchResult memory result,
1162         OrderAddressSet memory orderAddressSet,
1163         OrderContext memory orderContext
1164     )
1165         internal
1166     {
1167         uint256 makerTotalFee = result.makerFee.add(result.makerGasFee);
1168         uint256 takerTotalFee = result.takerFee.add(result.takerGasFee);
1169         
1170         orderContext.positions[orderContext.takerSide]
1171             .safeTransferFrom(
1172                 result.maker,
1173                 result.taker,
1174                 result.posFilledAmount
1175             );
1176         
1177         if (result.ctkFilledAmount > makerTotalFee) {
1178             
1179             orderContext.collateral.safeTransferFrom(
1180                 result.taker,
1181                 result.maker,
1182                 result.ctkFilledAmount.sub(makerTotalFee)
1183             );
1184         } else if (result.ctkFilledAmount < makerTotalFee) {
1185             
1186             orderContext.collateral.safeTransferFrom(
1187                 result.maker,
1188                 result.taker,
1189                 makerTotalFee.sub(result.ctkFilledAmount)
1190             );
1191         }
1192         
1193         orderContext.collateral.safeTransferFrom(
1194             result.taker,
1195             orderAddressSet.relayer,
1196             takerTotalFee.add(makerTotalFee)
1197         );
1198 
1199         
1200         
1201         
1202         
1203         
1204         
1205         
1206         
1207         
1208         
1209         
1210         
1211         
1212         
1213     }
1214 
1215     function oppositeSide(uint256 side) internal pure returns (uint256) {
1216         return side == LONG ? SHORT : LONG;
1217     }
1218 
1219     
1220     function doRedeem(
1221         MatchResult memory result,
1222         OrderAddressSet memory orderAddressSet,
1223         OrderContext memory orderContext
1224     )
1225         internal
1226     {
1227         uint256 makerTotalFee = result.makerFee.add(result.makerGasFee);
1228         uint256 takerTotalFee = result.takerFee.add(result.takerGasFee);
1229         uint256 collateralToTaker = orderContext.marketContract.COLLATERAL_PER_UNIT()
1230             .mul(result.posFilledAmount)
1231             .sub(result.ctkFilledAmount);
1232 
1233         
1234         
1235         orderContext.positions[oppositeSide(orderContext.takerSide)]
1236             .safeTransferFrom(
1237                 result.taker,
1238                 address(this),
1239                 result.posFilledAmount
1240             );
1241         
1242         orderContext.positions[orderContext.takerSide]
1243             .safeTransferFrom(
1244                 result.maker,
1245                 address(this),
1246                 result.posFilledAmount
1247             );
1248         
1249         redeemPositionTokens(orderContext, result.posFilledAmount);
1250         
1251         
1252         if (result.ctkFilledAmount > makerTotalFee) {
1253             
1254             orderContext.collateral.safeTransfer(
1255                 result.maker,
1256                 result.ctkFilledAmount.sub(makerTotalFee)
1257             );
1258         } else if (result.ctkFilledAmount < makerTotalFee) {
1259             
1260             orderContext.collateral.safeTransferFrom(
1261                 result.maker,
1262                 address(this),
1263                 makerTotalFee.sub(result.ctkFilledAmount)
1264             );
1265         }
1266         
1267         if (collateralToTaker > takerTotalFee) {
1268             
1269             orderContext.collateral.safeTransfer(
1270                 result.taker,
1271                 collateralToTaker.sub(takerTotalFee)
1272             );
1273         } else if (collateralToTaker < takerTotalFee) {
1274             
1275             orderContext.collateral.safeTransferFrom(
1276                 result.taker,
1277                 address(this),
1278                 takerTotalFee.sub(collateralToTaker)
1279             );
1280         }
1281         
1282         orderContext.collateral.safeTransfer(
1283             orderAddressSet.relayer,
1284             makerTotalFee.add(takerTotalFee)
1285         );
1286     }
1287 
1288     
1289     function doMint(
1290         MatchResult memory result,
1291         OrderAddressSet memory orderAddressSet,
1292         OrderContext memory orderContext
1293     )
1294         internal
1295     {
1296         
1297         uint256 neededCollateral = result.posFilledAmount
1298             .mul(orderContext.marketContract.COLLATERAL_PER_UNIT());
1299         uint256 neededCollateralTokenFee = result.posFilledAmount
1300             .mul(orderContext.marketContract.COLLATERAL_TOKEN_FEE_PER_UNIT());
1301         uint256 mintFee = result.takerFee.add(result.makerFee);
1302         uint256 feeToRelayer = result.takerGasFee.add(result.makerGasFee);
1303         
1304         if (neededCollateralTokenFee > mintFee) {
1305             orderContext.collateral.safeTransferFrom(
1306                 orderAddressSet.relayer,
1307                 address(this),
1308                 neededCollateralTokenFee.sub(mintFee)
1309             );
1310         } else if (neededCollateralTokenFee < mintFee) {
1311             feeToRelayer = feeToRelayer.add(mintFee).sub(neededCollateralTokenFee);
1312         }
1313         
1314         
1315         orderContext.collateral.safeTransferFrom(
1316             result.maker,
1317             address(this),
1318             result.ctkFilledAmount
1319                 .add(result.makerFee)
1320                 .add(result.makerGasFee)
1321         );
1322         
1323         orderContext.collateral.safeTransferFrom(
1324             result.taker,
1325             address(this),
1326             neededCollateral
1327                 .sub(result.ctkFilledAmount)
1328                 .add(result.takerFee)
1329                 .add(result.takerGasFee)
1330         );
1331         
1332         mintPositionTokens(orderContext, result.posFilledAmount);
1333         
1334         
1335         orderContext.positions[orderContext.takerSide]
1336             .safeTransfer(
1337                 result.taker,
1338                 result.posFilledAmount
1339             );
1340         
1341         orderContext.positions[oppositeSide(orderContext.takerSide)]
1342             .safeTransfer(
1343                 result.maker,
1344                 result.posFilledAmount
1345             );
1346         
1347         orderContext.collateral.safeTransfer(
1348             orderAddressSet.relayer,
1349             feeToRelayer
1350         );
1351     }
1352 
1353     
1354     
1355     
1356     function mintPositionTokens(OrderContext memory orderContext, uint256 qtyToMint)
1357         internal
1358     {
1359         IMarketContractPool collateralPool;
1360         if (mintingPoolAddress != address(0x0)) {
1361             collateralPool = IMarketContractPool(mintingPoolAddress);
1362         } else {
1363             collateralPool = orderContext.marketContractPool;
1364         }
1365         collateralPool.mintPositionTokens(address(orderContext.marketContract), qtyToMint, false);
1366     }
1367 
1368     
1369     
1370     
1371     function redeemPositionTokens(OrderContext memory orderContext, uint256 qtyToRedeem)
1372         internal
1373     {
1374         IMarketContractPool collateralPool;
1375         if (mintingPoolAddress != address(0x0)) {
1376             collateralPool = IMarketContractPool(mintingPoolAddress);
1377         } else {
1378             collateralPool = orderContext.marketContractPool;
1379         }
1380         collateralPool.redeemPositionTokens(address(orderContext.marketContract), qtyToRedeem);
1381     }
1382 }