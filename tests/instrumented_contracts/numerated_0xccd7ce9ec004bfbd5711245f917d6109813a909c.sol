1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor()
19         public
20     {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner()
28     {
29         require(
30             msg.sender == owner,
31             "Only the owner of that contract can execute this method"
32         );
33         _;
34     }
35 
36     /**
37      * @dev Allows the current owner to transfer control of the contract to a newOwner.
38      * @param newOwner The address to transfer ownership to.
39      */
40     function transferOwnership(address newOwner)
41         public
42         onlyOwner
43     {
44         require(
45             newOwner != address(0x0),
46             "Invalid address"
47         );
48 
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 
53 }
54 // Inspired by https://github.com/AdExNetwork/adex-protocol-eth/blob/master/contracts/libs/SafeERC20.sol
55 // The old ERC20 token standard defines transfer and transferFrom without return value.
56 // So the current ERC20 token standard is incompatible with this one.
57 interface IOldERC20 {
58 	function transfer(address to, uint256 value)
59         external;
60 
61 	function transferFrom(address from, address to, uint256 value)
62         external;
63 
64 	function approve(address spender, uint256 value)
65         external;
66 
67     event Transfer(
68         address indexed from,
69         address indexed to,
70         uint256 value
71     );
72 
73     event Approval(
74         address indexed owner,
75         address indexed spender,
76         uint256 value
77     );
78 }
79 
80 library SafeOldERC20 {
81 	// definitely not a pure fn but the compiler complains otherwise
82     function checkSuccess()
83         private
84         pure
85 		returns (bool)
86 	{
87         uint256 returnValue = 0;
88 
89         assembly {
90 			// check number of bytes returned from last function call
91 			switch returndatasize
92 
93 			// no bytes returned: assume success
94 			case 0x0 {
95 				returnValue := 1
96 			}
97 
98 			// 32 bytes returned: check if non-zero
99 			case 0x20 {
100 				// copy 32 bytes into scratch space
101 				returndatacopy(0x0, 0x0, 0x20)
102 
103 				// load those bytes into returnValue
104 				returnValue := mload(0x0)
105 			}
106 
107 			// not sure what was returned: don't mark as success
108 			default { }
109         }
110 
111         return returnValue != 0;
112     }
113 
114     function transfer(address token, address to, uint256 amount) internal {
115         IOldERC20(token).transfer(to, amount);
116         require(checkSuccess(), "Transfer failed");
117     }
118 
119     function transferFrom(address token, address from, address to, uint256 amount) internal {
120         IOldERC20(token).transferFrom(from, to, amount);
121         require(checkSuccess(), "Transfer From failed");
122     }
123 }
124 
125 library CrowdsaleLib {
126 
127     struct Crowdsale {
128         uint256 startTime;
129         uint256 endTime;
130         uint256 capacity;
131         uint256 leftAmount;
132         uint256 tokenRatio;
133         uint256 minContribution;
134         uint256 maxContribution;
135         uint256 weiRaised;
136         address wallet;
137     }
138 
139     function isValid(Crowdsale storage _self)
140         internal
141         view
142         returns (bool)
143     {
144         return (
145             (_self.startTime >= now) &&
146             (_self.endTime >= _self.startTime) &&
147             (_self.tokenRatio > 0) &&
148             (_self.wallet != address(0))
149         );
150     }
151 
152     function isOpened(Crowdsale storage _self)
153         internal
154         view
155         returns (bool)
156     {
157         return (now >= _self.startTime && now <= _self.endTime);
158     }
159 
160     function createCrowdsale(
161         address _wallet,
162         uint256[8] _values
163     )
164         internal
165         pure
166         returns (Crowdsale memory)
167     {
168         return Crowdsale({
169             startTime: _values[0],
170             endTime: _values[1],
171             capacity: _values[2],
172             leftAmount: _values[3],
173             tokenRatio: _values[4],
174             minContribution: _values[5],
175             maxContribution: _values[6],
176             weiRaised: _values[7],
177             wallet: _wallet
178         });
179     }
180 }
181 
182 contract IUpgradableExchange {
183 
184     uint8 public VERSION;
185 
186     event FundsMigrated(address indexed user, address indexed exchangeAddress);
187 
188     function allowOrRestrictMigrations() external;
189 
190     function migrateFunds(address[] _tokens) external;
191 
192     function migrateEthers() private;
193 
194     function migrateTokens(address[] _tokens) private;
195 
196     function importEthers(address _user) external payable;
197 
198     function importTokens(address _tokenAddress, uint256 _tokenAmount, address _user) external;
199 
200 }
201 
202 /**
203  * @title ERC20 interface
204  * @dev see https://github.com/ethereum/EIPs/issues/20
205  */
206 interface IERC20 {
207     function totalSupply() external view returns (uint256);
208 
209     function balanceOf(address who) external view returns (uint256);
210 
211     function allowance(address owner, address spender)
212         external view returns (uint256);
213 
214     function transfer(address to, uint256 value) external returns (bool);
215 
216     function approve(address spender, uint256 value)
217         external returns (bool);
218 
219     function transferFrom(address from, address to, uint256 value)
220         external returns (bool);
221 
222     event Transfer(
223         address indexed from,
224         address indexed to,
225         uint256 value
226     );
227 
228     event Approval(
229         address indexed owner,
230         address indexed spender,
231         uint256 value
232     );
233 }
234 
235 library OrderLib {
236 
237     struct Order {
238         uint256 makerSellAmount;
239         uint256 makerBuyAmount;
240         uint256 nonce;
241         address maker;
242         address makerSellToken;
243         address makerBuyToken;
244     }
245 
246     /**
247     * @dev Hashes the order.
248     * @param order Order to be hashed.
249     * @return hash result
250     */
251     function createHash(Order memory order)
252         internal
253         view
254         returns (bytes32)
255     {
256         return keccak256(
257             abi.encodePacked(
258                 order.maker,
259                 order.makerSellToken,
260                 order.makerSellAmount,
261                 order.makerBuyToken,
262                 order.makerBuyAmount,
263                 order.nonce,
264                 this
265             )
266         );
267     }
268 
269     /**
270     * @dev Creates order struct from value arrays.
271     * @param addresses Array of trade's maker, makerToken and takerToken.
272     * @param values Array of trade's makerTokenAmount, takerTokenAmount, expires and nonce.
273     * @return Order struct
274     */
275     function createOrder(
276         address[3] addresses,
277         uint256[3] values
278     )
279         internal
280         pure
281         returns (Order memory)
282     {
283         return Order({
284             maker: addresses[0],
285             makerSellToken: addresses[1],
286             makerSellAmount: values[0],
287             makerBuyToken: addresses[2],
288             makerBuyAmount: values[1],
289             nonce: values[2]
290         });
291     }
292 
293 }
294 
295 /**
296  * @title Math
297  * @dev Math operations with safety checks that throw on error
298  */
299 library Math {
300 
301     /**
302      * @dev Multiplies two numbers, throws on overflow.
303      */
304     function mul(uint256 a, uint256 b)
305         internal
306         pure
307         returns(uint256 c)
308     {
309         if (a == 0) {
310             return 0;
311         }
312         c = a * b;
313         assert(c / a == b);
314         return c;
315     }
316 
317     /**
318      * @dev Integer division of two numbers, truncating the quotient.
319      */
320     function div(uint256 a, uint256 b)
321         internal
322         pure
323         returns(uint256)
324     {
325         return a / b;
326     }
327 
328     /**
329      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
330      */
331     function sub(uint256 a, uint256 b)
332         internal
333         pure
334         returns(uint256)
335     {
336         assert(b <= a);
337         return a - b;
338     }
339 
340     /**
341      * @dev Adds two numbers, throws on overflow.
342      */
343     function add(uint256 a, uint256 b)
344         internal
345         pure
346         returns(uint256 c)
347     {
348         c = a + b;
349         assert(c >= a);
350         return c;
351     }
352 
353     /**
354     * @dev Calculate the ration between two assets. For example ETH/WDX
355     * @param _numerator uint256 base currency
356     * @param _denominator uint256 quote currency
357     */
358     function calculateRate(
359         uint256 _numerator,
360         uint256 _denominator
361     )
362         internal
363         pure
364         returns(uint256)
365     {
366         return div(mul(_numerator, 1e18), _denominator);
367     }
368 
369     /**
370     * @dev Calculate the fee in WDX
371     * @param _fee uint256 full fee
372     * @param _referralFeeRate uint256 referral fee rate
373     */
374     function calculateReferralFee(uint256 _fee, uint256 _referralFeeRate) internal pure returns (uint256) {
375         return div(_fee, _referralFeeRate);
376     }
377 
378     /**
379     * @dev Calculate the fee in WDX
380     * @param _etherAmount uint256 amount in Ethers
381     * @param _tokenRatio uint256 the rate between ETH/WDX
382     * @param _feeRate uint256 the fee rate
383     */
384     function calculateWdxFee(uint256 _etherAmount, uint256 _tokenRatio, uint256 _feeRate) internal pure returns (uint256) {
385         return div(div(mul(_etherAmount, 1e18), _tokenRatio), mul(_feeRate, 2));
386     }
387 }
388 
389 /**
390  * @title Token contract
391  * @dev extending ERC20 to support ExchangeOffering functionality.
392  */
393 contract Token is IERC20 {
394     function getBonusFactor(uint256 _startTime, uint256 _endTime, uint256 _weiAmount)
395         public view returns (uint256);
396 
397     function isUserWhitelisted(address _user)
398         public view returns (bool);
399 }
400 
401 contract Exchange is Ownable {
402 
403     using Math for uint256;
404 
405     using OrderLib for OrderLib.Order;
406 
407     uint256 public feeRate;
408 
409     mapping(address => mapping(address => uint256)) public balances;
410 
411     mapping(bytes32 => uint256) public filledAmounts;
412 
413     address constant public ETH = address(0x0);
414 
415     address public feeAccount;
416 
417     constructor(
418         address _feeAccount,
419         uint256 _feeRate
420     )
421         public
422     {
423         feeAccount = _feeAccount;
424         feeRate = _feeRate;
425     }
426 
427     enum ErrorCode {
428         INSUFFICIENT_MAKER_BALANCE,
429         INSUFFICIENT_TAKER_BALANCE,
430         INSUFFICIENT_ORDER_AMOUNT
431     }
432 
433     event Deposit(
434         address indexed tokenAddress,
435         address indexed user,
436         uint256 amount,
437         uint256 balance
438     );
439 
440     event Withdraw(
441         address indexed tokenAddress,
442         address indexed user,
443         uint256 amount,
444         uint256 balance
445     );
446 
447     event CancelOrder(
448         address indexed makerBuyToken,
449         address indexed makerSellToken,
450         address indexed maker,
451         bytes32 orderHash,
452         uint256 nonce
453     );
454 
455     event TakeOrder(
456         address indexed maker,
457         address taker,
458         address indexed makerBuyToken,
459         address indexed makerSellToken,
460         uint256 takerGivenAmount,
461         uint256 takerReceivedAmount,
462         bytes32 orderHash,
463         uint256 nonce
464     );
465 
466     event Error(
467         uint8 eventId,
468         bytes32 orderHash
469     );
470 
471     /**
472     * @dev Owner can set the exchange fee
473     * @param _feeRate uint256 new fee rate
474     */
475     function setFee(uint256 _feeRate)
476         external
477         onlyOwner
478     {
479         feeRate = _feeRate;
480     }
481 
482     /**
483     * @dev Owner can set the new fee account
484     * @param _feeAccount address
485     */
486     function setFeeAccount(address _feeAccount)
487         external
488         onlyOwner
489     {
490         feeAccount = _feeAccount;
491     }
492 
493     /**
494     * @dev Allows user to deposit Ethers in the exchange contract.
495     * Only the respected user can withdraw these Ethers.
496     */
497     function depositEthers() external payable
498     {
499         address user = msg.sender;
500         _depositEthers(user);
501         emit Deposit(ETH, user, msg.value, balances[ETH][user]);
502     }
503 
504     /**
505     * @dev Allows user to deposit Ethers for beneficiary in the exchange contract.
506     * @param _beneficiary address
507     * Only the beneficiary can withdraw these Ethers.
508     */
509     function depositEthersFor(
510         address
511         _beneficiary
512     )
513         external
514         payable
515     {
516         _depositEthers(_beneficiary);
517         emit Deposit(ETH, _beneficiary, msg.value, balances[ETH][_beneficiary]);
518     }
519 
520     /**
521     * @dev Allows user to deposit Tokens in the exchange contract.
522     * Only the respected user can withdraw these tokens.
523     * @param _tokenAddress address representing the token contract address.
524     * @param _amount uint256 representing the token amount to be deposited.
525     */
526     function depositTokens(
527         address _tokenAddress,
528         uint256 _amount
529     )
530         external
531     {
532         address user = msg.sender;
533         _depositTokens(_tokenAddress, _amount, user);
534         emit Deposit(_tokenAddress, user, _amount, balances[_tokenAddress][user]);
535     }
536 
537         /**
538     * @dev Allows user to deposit Tokens for beneficiary in the exchange contract.
539     * Only the beneficiary can withdraw these tokens.
540     * @param _tokenAddress address representing the token contract address.
541     * @param _amount uint256 representing the token amount to be deposited.
542     * @param _beneficiary address representing the token amount to be deposited.
543     */
544     function depositTokensFor(
545         address _tokenAddress,
546         uint256 _amount,
547         address _beneficiary
548     )
549         external
550     {
551         _depositTokens(_tokenAddress, _amount, _beneficiary);
552         emit Deposit(_tokenAddress, _beneficiary, _amount, balances[_tokenAddress][_beneficiary]);
553     }
554 
555     /**
556     * @dev Internal version of deposit Ethers.
557     */
558     function _depositEthers(
559         address
560         _beneficiary
561     )
562         internal
563     {
564         balances[ETH][_beneficiary] = balances[ETH][_beneficiary].add(msg.value);
565     }
566 
567     /**
568     * @dev Internal version of deposit Tokens.
569     */
570     function _depositTokens(
571         address _tokenAddress,
572         uint256 _amount,
573         address _beneficiary
574     )
575         internal
576     {
577         balances[_tokenAddress][_beneficiary] = balances[_tokenAddress][_beneficiary].add(_amount);
578 
579         require(
580             Token(_tokenAddress).transferFrom(msg.sender, this, _amount),
581             "Token transfer is not successfull (maybe you haven't used approve first?)"
582         );
583     }
584 
585     /**
586     * @dev Allows user to withdraw Ethers from the exchange contract.
587     * Throws if the user balance is lower than the requested amount.
588     * @param _amount uint256 representing the amount to be withdrawn.
589     */
590     function withdrawEthers(uint256 _amount) external
591     {
592         address user = msg.sender;
593 
594         require(
595             balances[ETH][user] >= _amount,
596             "Not enough funds to withdraw."
597         );
598 
599         balances[ETH][user] = balances[ETH][user].sub(_amount);
600 
601         user.transfer(_amount);
602 
603         emit Withdraw(ETH, user, _amount, balances[ETH][user]);
604     }
605 
606     /**
607     * @dev Allows user to withdraw specific Token from the exchange contract.
608     * Throws if the user balance is lower than the requested amount.
609     * @param _tokenAddress address representing the token contract address.
610     * @param _amount uint256 representing the amount to be withdrawn.
611     */
612     function withdrawTokens(
613         address _tokenAddress,
614         uint256 _amount
615     )
616         external
617     {
618         address user = msg.sender;
619 
620         require(
621             balances[_tokenAddress][user] >= _amount,
622             "Not enough funds to withdraw."
623         );
624 
625         balances[_tokenAddress][user] = balances[_tokenAddress][user].sub(_amount);
626 
627         require(
628             Token(_tokenAddress).transfer(user, _amount),
629             "Token transfer is not successfull."
630         );
631 
632         emit Withdraw(_tokenAddress, user, _amount, balances[_tokenAddress][user]);
633     }
634 
635     /**
636     * @dev Allows user to transfer specific Token inside the exchange.
637     * @param _tokenAddress address representing the token address.
638     * @param _to address representing the beneficier.
639     * @param _amount uint256 representing the amount to be transferred.
640     */
641     function transfer(
642         address _tokenAddress,
643         address _to,
644         uint256 _amount
645     )
646         external
647     {
648         address user = msg.sender;
649 
650         require(
651             balances[_tokenAddress][user] >= _amount,
652             "Not enough funds to transfer."
653         );
654 
655         balances[_tokenAddress][user] = balances[_tokenAddress][user].sub(_amount);
656 
657         balances[_tokenAddress][_to] = balances[_tokenAddress][_to].add(_amount);
658     }
659 
660     /**
661     * @dev Common take order implementation
662     * @param _order OrderLib.Order memory - order info
663     * @param _takerSellAmount uint256 - amount being given by the taker
664     * @param _v uint8 part of the signature
665     * @param _r bytes32 part of the signature (from 0 to 32 bytes)
666     * @param _s bytes32 part of the signature (from 32 to 64 bytes)
667     */
668     function takeOrder(
669         OrderLib.Order memory _order,
670         uint256 _takerSellAmount,
671         uint8 _v,
672         bytes32 _r,
673         bytes32 _s
674     )
675         internal
676         returns (uint256)
677     {
678         bytes32 orderHash = _order.createHash();
679 
680         require(
681             ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)), _v, _r, _s) == _order.maker,
682             "Order maker is invalid."
683         );
684 
685         if(balances[_order.makerBuyToken][msg.sender] < _takerSellAmount) {
686             emit Error(uint8(ErrorCode.INSUFFICIENT_TAKER_BALANCE), orderHash);
687             return 0;
688         }
689 
690         uint256 receivedAmount = (_order.makerSellAmount.mul(_takerSellAmount)).div(_order.makerBuyAmount);
691 
692         if(balances[_order.makerSellToken][_order.maker] < receivedAmount) {
693             emit Error(uint8(ErrorCode.INSUFFICIENT_MAKER_BALANCE), orderHash);
694             return 0;
695         }
696 
697         if(filledAmounts[orderHash].add(_takerSellAmount) > _order.makerBuyAmount) {
698             emit Error(uint8(ErrorCode.INSUFFICIENT_ORDER_AMOUNT), orderHash);
699             return 0;
700         }
701 
702         filledAmounts[orderHash] = filledAmounts[orderHash].add(_takerSellAmount);
703 
704         balances[_order.makerBuyToken][msg.sender] = balances[_order.makerBuyToken][msg.sender].sub(_takerSellAmount);
705         balances[_order.makerBuyToken][_order.maker] = balances[_order.makerBuyToken][_order.maker].add(_takerSellAmount);
706 
707         balances[_order.makerSellToken][msg.sender] = balances[_order.makerSellToken][msg.sender].add(receivedAmount);
708         balances[_order.makerSellToken][_order.maker] = balances[_order.makerSellToken][_order.maker].sub(receivedAmount);
709 
710         emit TakeOrder(
711             _order.maker,
712             msg.sender,
713             _order.makerBuyToken,
714             _order.makerSellToken,
715             _takerSellAmount,
716             receivedAmount,
717             orderHash,
718             _order.nonce
719         );
720 
721         return receivedAmount;
722     }
723 
724     /**
725     * @dev Order maker can call this function in order to cancel it.
726     * What actually happens is that the order become
727     * fulfilled in the "filledAmounts" mapping. Thus we avoid someone calling
728     * "takeOrder" directly from the contract if the order hash is available to him.
729     * @param _orderAddresses address[3]
730     * @param _orderValues uint256[3]
731     * @param _v uint8 parameter parsed from the signature recovery
732     * @param _r bytes32 parameter parsed from the signature (from 0 to 32 bytes)
733     * @param _s bytes32 parameter parsed from the signature (from 32 to 64 bytes)
734     */
735     function cancelOrder(
736         address[3] _orderAddresses,
737         uint256[3] _orderValues,
738         uint8 _v,
739         bytes32 _r,
740         bytes32 _s
741     )
742         public
743     {
744         OrderLib.Order memory order = OrderLib.createOrder(_orderAddresses, _orderValues);
745         bytes32 orderHash = order.createHash();
746 
747         require(
748             ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)), _v, _r, _s) == msg.sender,
749             "Only order maker can cancel it."
750         );
751 
752         filledAmounts[orderHash] = filledAmounts[orderHash].add(order.makerBuyAmount);
753 
754         emit CancelOrder(
755             order.makerBuyToken,
756             order.makerSellToken,
757             msg.sender,
758             orderHash,
759             order.nonce
760         );
761     }
762 
763     /**
764     * @dev Cancel multiple orders in a single transaction.
765     * @param _orderAddresses address[3][]
766     * @param _orderValues uint256[3][]
767     * @param _v uint8[] parameter parsed from the signature recovery
768     * @param _r bytes32[] parameter parsed from the signature (from 0 to 32 bytes)
769     * @param _s bytes32[] parameter parsed from the signature (from 32 to 64 bytes)
770     */
771     function cancelMultipleOrders(
772         address[3][] _orderAddresses,
773         uint256[3][] _orderValues,
774         uint8[] _v,
775         bytes32[] _r,
776         bytes32[] _s
777     )
778         external
779     {
780         for (uint256 index = 0; index < _orderAddresses.length; index++) {
781             cancelOrder(
782                 _orderAddresses[index],
783                 _orderValues[index],
784                 _v[index],
785                 _r[index],
786                 _s[index]
787             );
788         }
789     }
790 }
791 
792 contract DailyVolumeUpdater is Ownable {
793 
794     using Math for uint256;
795 
796     uint256 public dailyVolume;
797 
798     uint256 public dailyVolumeCap;
799 
800     uint256 private lastDay;
801 
802     constructor()
803         public
804     {
805         dailyVolume = 0;
806         dailyVolumeCap = 1000 ether;
807         lastDay = today();
808     }
809 
810     /**
811     * @dev Allows the owner to change the daily volume capacity.
812     * @param _dailyVolumeCap uint256 representing the daily volume capacity
813     */
814     function setDailyVolumeCap(uint256 _dailyVolumeCap)
815         public
816         onlyOwner
817     {
818         dailyVolumeCap = _dailyVolumeCap;
819     }
820 
821     /**
822     * @dev Internal function that increments the daily volume.
823     * @param _volume uint256 representing the amount of volume increasement.
824     */
825     function updateVolume(uint256 _volume)
826         internal
827     {
828         if(today() > lastDay) {
829             dailyVolume = _volume;
830             lastDay = today();
831         } else {
832             dailyVolume = dailyVolume.add(_volume);
833         }
834     }
835 
836     /**
837     * @dev Internal function to check if the volume capacity is reached.
838     * @return Whether the volume is reached or not.
839     */
840     function isVolumeReached()
841         internal
842         view
843         returns(bool)
844     {
845         return dailyVolume >= dailyVolumeCap;
846     }
847 
848     /**
849     * @dev Private function to determine today's index
850     * @return uint256 of today's index.
851     */
852     function today()
853         private
854         view
855         returns(uint256)
856     {
857         return block.timestamp.div(1 days);
858     }
859 }
860 
861 contract DiscountTokenExchange is Exchange, DailyVolumeUpdater {
862 
863     uint256 internal discountTokenRatio;
864 
865     uint256 private minimumTokenAmountForUpdate;
866 
867     address public discountTokenAddress;
868 
869     bool internal initialized = false;
870 
871     constructor(
872         address _discountTokenAddress,
873         uint256 _discountTokenRatio
874     )
875         public
876     {
877         discountTokenAddress = _discountTokenAddress;
878         discountTokenRatio = _discountTokenRatio;
879     }
880 
881     modifier onlyOnce() {
882         require(
883             initialized == false,
884             "Exchange is already initialized"
885         );
886         _;
887     }
888 
889     /**
890     * @dev Update the token discount contract.
891     * @param _discountTokenAddress address of the token used for fee discount
892     * @param _discountTokenRatio uint256 initial rate of the token discount contract
893     */
894     function setDiscountToken(
895         address _discountTokenAddress,
896         uint256 _discountTokenRatio,
897         uint256 _minimumTokenAmountForUpdate
898     )
899         public
900         onlyOwner
901         onlyOnce
902     {
903         discountTokenAddress = _discountTokenAddress;
904         discountTokenRatio = _discountTokenRatio;
905         minimumTokenAmountForUpdate = _minimumTokenAmountForUpdate;
906         initialized = true;
907     }
908 
909     /**
910     * @dev Update the token ratio.
911     * Add a minimum requirement for the amount of tokens being traded
912     * to avoid possible intentional manipulation
913     * @param _etherAmount uint256 amount in Ethers (wei)
914     * @param _tokenAmount uint256 amount in Tokens
915     */
916     function updateTokenRatio(
917         uint256 _etherAmount,
918         uint256 _tokenAmount
919     )
920         internal
921     {
922         if(_tokenAmount >= minimumTokenAmountForUpdate) {
923             discountTokenRatio = _etherAmount.calculateRate(_tokenAmount);
924         }
925     }
926 
927     /**
928     * @dev Set the minimum requirement for updating the price.
929     * This should be called whenever the rate of the token
930     * has changed massively.
931     * In order to avoid token price manipulation (that will reduce the fee)
932     * The minimum amount requirement take place.
933     * For example: Someone buys or sells 0.0000000001 Tokens with
934     * high rate against ETH and after that execute a trade,
935     * reducing his fees to approximately zero.
936     * Having the mimimum amount requirement for updating
937     * the price will protect us from such cases because
938     * it will not be worth to do it.
939     * @param _minimumTokenAmountForUpdate - the new mimimum amount of
940     * tokens for updating the ratio (price)
941     */
942     function setMinimumTokenAmountForUpdate(
943         uint256 _minimumTokenAmountForUpdate
944     )
945         external
946         onlyOwner
947     {
948         minimumTokenAmountForUpdate = _minimumTokenAmountForUpdate;
949     }
950 
951     /**
952     * @dev Execute WeiDexToken Sale Order based on the order input parameters
953     * and the signature from the maker's signing.
954     * @param _orderAddresses address[3] representing
955     * [0] address of the order maker
956     * [1] address of WeiDexToken
957     * [2] address of Ether (0x0)
958     * @param _orderValues uint256[4] representing
959     * [0] amount in WDX
960     * [1] amount in Ethers (wei)
961     * [2] order nonce used for hash uniqueness
962     * @param _takerSellAmount uint256 - amount being asked from the taker, should be in ethers
963     * @param _v uint8 parameter parsed from the signature recovery
964     * @param _r bytes32 parameter parsed from the signature (from 0 to 32 bytes)
965     * @param _s bytes32 parameter parsed from the signature (from 32 to 64 bytes)
966     */
967     function takeSellTokenOrder(
968         address[3] _orderAddresses,
969         uint256[3] _orderValues,
970         uint256 _takerSellAmount,
971         uint8 _v,
972         bytes32 _r,
973         bytes32 _s
974     )
975         external
976     {
977         require(
978             _orderAddresses[1] == discountTokenAddress,
979             "Should sell WeiDex Tokens"
980         );
981 
982         require(
983             0 < takeOrder(OrderLib.createOrder(_orderAddresses, _orderValues), _takerSellAmount, _v, _r, _s),
984             "Trade failure"
985         );
986         updateVolume(_takerSellAmount);
987         updateTokenRatio(_orderValues[1], _orderValues[0]);
988     }
989 
990     /**
991     * @dev Execute WeiDexToken Buy Order based on the order input parameters
992     * and the signature from the maker's signing.
993     * @param _orderAddresses address[3] representing
994     * [0] address of the order maker
995     * [1] address of Ether (0x0)
996     * [2] address of WeiDexToken
997     * @param _orderValues uint256[4] representing
998     * [0] amount in Ethers
999     * [1] amount in WDX
1000     * [2] order nonce used for hash uniqueness
1001     * @param _takerSellAmount uint256 - amount being asked from the taker
1002     * @param _v uint8 parameter parsed from the signature recovery
1003     * @param _r bytes32 parameter parsed from the signature (from 0 to 32 bytes)
1004     * @param _s bytes32 parameter parsed from the signature (from 32 to 64 bytes)
1005     */
1006     function takeBuyTokenOrder(
1007         address[3] _orderAddresses,
1008         uint256[3] _orderValues,
1009         uint256 _takerSellAmount,
1010         uint8 _v,
1011         bytes32 _r,
1012         bytes32 _s
1013     )
1014         external
1015     {
1016         require(
1017             _orderAddresses[2] == discountTokenAddress,
1018             "Should buy WeiDex Tokens"
1019         );
1020 
1021         uint256 receivedAmount = takeOrder(OrderLib.createOrder(_orderAddresses, _orderValues), _takerSellAmount, _v, _r, _s);
1022         require(0 < receivedAmount, "Trade failure");
1023         updateVolume(receivedAmount);
1024         updateTokenRatio(_orderValues[0], _orderValues[1]);
1025     }
1026 }
1027 
1028 contract ReferralExchange is Exchange {
1029 
1030     uint256 public referralFeeRate;
1031 
1032     mapping(address => address) public referrals;
1033 
1034     constructor(
1035         uint256 _referralFeeRate
1036     )
1037         public
1038     {
1039         referralFeeRate = _referralFeeRate;
1040     }
1041 
1042     event ReferralBalanceUpdated(
1043         address refererAddress,
1044         address referralAddress,
1045         address tokenAddress,
1046         uint256 feeAmount,
1047         uint256 referralFeeAmount
1048     );
1049 
1050     event ReferralDeposit(
1051         address token,
1052         address indexed user,
1053         address indexed referrer,
1054         uint256 amount,
1055         uint256 balance
1056     );
1057 
1058     /**
1059     * @dev Deposit Ethers with a given referrer address
1060     * @param _referrer address of the referrer
1061     */
1062     function depositEthers(address _referrer)
1063         external
1064         payable
1065     {
1066         address user = msg.sender;
1067 
1068         require(
1069             0x0 == referrals[user],
1070             "This user already have a referrer."
1071         );
1072 
1073         super._depositEthers(user);
1074         referrals[user] = _referrer;
1075         emit ReferralDeposit(ETH, user, _referrer, msg.value, balances[ETH][user]);
1076     }
1077 
1078     /**
1079     * @dev Deposit Tokens with a given referrer address
1080     * @param _referrer address of the referrer
1081     */
1082     function depositTokens(
1083         address _tokenAddress,
1084         uint256 _amount,
1085         address _referrer
1086     )
1087         external
1088     {
1089         address user = msg.sender;
1090 
1091         require(
1092             0x0 == referrals[user],
1093             "This user already have a referrer."
1094         );
1095 
1096         super._depositTokens(_tokenAddress, _amount, user);
1097         referrals[user] = _referrer;
1098         emit ReferralDeposit(_tokenAddress, user, _referrer, _amount, balances[_tokenAddress][user]);
1099     }
1100 
1101     /**
1102     * @dev Update the referral fee rate,
1103     * i.e. the rate of the fee that will be accounted to the referrer
1104     * @param _referralFeeRate uint256 amount of fee going to the referrer
1105     */
1106     function setReferralFee(uint256 _referralFeeRate)
1107         external
1108         onlyOwner
1109     {
1110         referralFeeRate = _referralFeeRate;
1111     }
1112 
1113     /**
1114     * @dev Return the feeAccount address if user doesn't have referrer
1115     * @param _user address user whom referrer is being checked.
1116     * @return address of user's referrer.
1117     */
1118     function getReferrer(address _user)
1119         internal
1120         view
1121         returns(address referrer)
1122     {
1123         return referrals[_user] != address(0x0) ? referrals[_user] : feeAccount;
1124     }
1125 }
1126 
1127 contract UpgradableExchange is Exchange {
1128 
1129     uint8 constant public VERSION = 0;
1130 
1131     address public newExchangeAddress;
1132 
1133     bool public isMigrationAllowed;
1134 
1135     event FundsMigrated(address indexed user, address indexed exchangeAddress);
1136 
1137     /**
1138     * @dev Owner can set the address of the new version of the exchange contract.
1139     * @param _newExchangeAddress address representing the new exchange contract address
1140     */
1141     function setNewExchangeAddress(address _newExchangeAddress)
1142         external
1143         onlyOwner
1144     {
1145         newExchangeAddress = _newExchangeAddress;
1146     }
1147 
1148     /**
1149     * @dev Enables/Disables the migrations. Can be called only by the owner.
1150     */
1151     function allowOrRestrictMigrations()
1152         external
1153         onlyOwner
1154     {
1155         isMigrationAllowed = !isMigrationAllowed;
1156     }
1157 
1158     /**
1159     * @dev Set the address of the new version of the exchange contract. Should be called by the user.
1160     * @param _tokens address[] representing the token addresses which are going to be migrated.
1161     */
1162     function migrateFunds(address[] _tokens) external {
1163 
1164         require(
1165             false != isMigrationAllowed,
1166             "Fund migration is not allowed"
1167         );
1168 
1169         require(
1170             IUpgradableExchange(newExchangeAddress).VERSION() > VERSION,
1171             "New exchange version should be greater than the current version."
1172         );
1173 
1174         migrateEthers();
1175 
1176         migrateTokens(_tokens);
1177 
1178         emit FundsMigrated(msg.sender, newExchangeAddress);
1179     }
1180 
1181     /**
1182     * @dev Helper function to migrate user's Ethers. Should be called in migrateFunds() function.
1183     */
1184     function migrateEthers() private {
1185 
1186         uint256 etherAmount = balances[ETH][msg.sender];
1187         if (etherAmount > 0) {
1188             balances[ETH][msg.sender] = 0;
1189 
1190             IUpgradableExchange(newExchangeAddress).importEthers.value(etherAmount)(msg.sender);
1191         }
1192     }
1193 
1194     /**
1195     * @dev Helper function to migrate user's tokens. Should be called in migrateFunds() function.
1196     * @param _tokens address[] representing the token addresses which are going to be migrated.
1197     */
1198     function migrateTokens(address[] _tokens) private {
1199 
1200         for (uint256 index = 0; index < _tokens.length; index++) {
1201 
1202             address tokenAddress = _tokens[index];
1203 
1204             uint256 tokenAmount = balances[tokenAddress][msg.sender];
1205 
1206             if (0 == tokenAmount) {
1207                 continue;
1208             }
1209 
1210             require(
1211                 Token(tokenAddress).approve(newExchangeAddress, tokenAmount),
1212                 "Approve failed"
1213             );
1214 
1215             balances[tokenAddress][msg.sender] = 0;
1216 
1217             IUpgradableExchange(newExchangeAddress).importTokens(tokenAddress, tokenAmount, msg.sender);
1218         }
1219     }
1220 }
1221 
1222 contract ExchangeOffering is Exchange {
1223 
1224     using CrowdsaleLib for CrowdsaleLib.Crowdsale;
1225 
1226     mapping(address => CrowdsaleLib.Crowdsale) public crowdsales;
1227 
1228     mapping(address => mapping(address => uint256)) public userContributionForProject;
1229 
1230     event TokenPurchase(
1231         address indexed project,
1232         address indexed contributor,
1233         uint256 tokens,
1234         uint256 weiAmount
1235     );
1236 
1237     function registerCrowdsale(
1238         address _project,
1239         address _projectWallet,
1240         uint256[8] _values
1241     )
1242         public
1243         onlyOwner
1244     {
1245         crowdsales[_project] = CrowdsaleLib.createCrowdsale(_projectWallet, _values);
1246 
1247         require(
1248             crowdsales[_project].isValid(),
1249             "Crowdsale is not active."
1250         );
1251 
1252         // project contract validation
1253         require(
1254             getBonusFactor(_project, crowdsales[_project].minContribution) >= 0,
1255             "The project should have *getBonusFactor* function implemented. The function should return the bonus percentage depending on the start/end date and contribution amount. Should return 0 if there is no bonus."
1256         );
1257 
1258         // project contract validation
1259         require(
1260             isUserWhitelisted(_project, this),
1261             "The project should have *isUserWhitelisted* function implemented. This contract address should be whitelisted"
1262         );
1263     }
1264 
1265     function buyTokens(address _project)
1266        public
1267        payable
1268     {
1269         uint256 weiAmount = msg.value;
1270 
1271         address contributor = msg.sender;
1272 
1273         address crowdsaleWallet = crowdsales[_project].wallet;
1274 
1275         require(
1276             isUserWhitelisted(_project, contributor), "User is not whitelisted"
1277         );
1278 
1279         require(
1280             validContribution(_project, contributor, weiAmount),
1281             "Contribution is not valid: Check minimum/maximum contribution amount or if crowdsale cap is reached"
1282         );
1283 
1284         uint256 tokens = weiAmount.mul(crowdsales[_project].tokenRatio);
1285 
1286         uint256 bonus = getBonusFactor(_project, weiAmount);
1287 
1288         uint256 bonusAmount = tokens.mul(bonus).div(100);
1289 
1290         uint256 totalPurchasedTokens = tokens.add(bonusAmount);
1291 
1292         crowdsales[_project].leftAmount = crowdsales[_project].leftAmount.sub(totalPurchasedTokens);
1293 
1294         require(Token(_project).transfer(contributor, totalPurchasedTokens), "Transfer failed");
1295 
1296         crowdsales[_project].weiRaised = crowdsales[_project].weiRaised.add(weiAmount);
1297 
1298         userContributionForProject[_project][contributor] = userContributionForProject[_project][contributor].add(weiAmount);
1299 
1300         balances[ETH][crowdsaleWallet] = balances[ETH][crowdsaleWallet].add(weiAmount);
1301 
1302         emit TokenPurchase(_project, contributor, totalPurchasedTokens, weiAmount);
1303     }
1304 
1305     function withdrawWhenFinished(address _project) public {
1306 
1307         address crowdsaleWallet = crowdsales[_project].wallet;
1308 
1309         require(
1310             msg.sender == crowdsaleWallet,
1311             "Only crowdsale owner can withdraw funds that are left."
1312         );
1313 
1314         require(
1315             !crowdsales[_project].isOpened(),
1316             "You can't withdraw funds yet. Crowdsale should end first."
1317         );
1318 
1319         uint256 leftAmount = crowdsales[_project].leftAmount;
1320 
1321         crowdsales[_project].leftAmount = 0;
1322 
1323         require(Token(_project).transfer(crowdsaleWallet, leftAmount), "Transfer failed");
1324     }
1325 
1326     function saleOpen(address _project)
1327         public
1328         view
1329         returns(bool)
1330     {
1331         return crowdsales[_project].isOpened();
1332     }
1333 
1334     function getBonusFactor(address _project, uint256 _weiAmount)
1335         public
1336         view
1337         returns(uint256)
1338     {
1339         return Token(_project).getBonusFactor(crowdsales[_project].startTime, crowdsales[_project].endTime, _weiAmount);
1340     }
1341 
1342     function isUserWhitelisted(address _project, address _user)
1343         public
1344         view
1345         returns(bool)
1346     {
1347         return Token(_project).isUserWhitelisted(_user);
1348     }
1349 
1350     function validContribution(
1351         address _project,
1352         address _user,
1353         uint256 _weiAmount
1354     )
1355         private
1356         view
1357         returns(bool)
1358     {
1359         if (saleOpen(_project)) {
1360             // minimum contribution check
1361             if (_weiAmount < crowdsales[_project].minContribution) {
1362                 return false;
1363             }
1364 
1365             // maximum contribution check
1366             if (userContributionForProject[_project][_user].add(_weiAmount) > crowdsales[_project].maxContribution) {
1367                 return false;
1368             }
1369 
1370             // token sale capacity check
1371             if (crowdsales[_project].capacity < crowdsales[_project].weiRaised.add(_weiAmount)) {
1372                 return false;
1373             }
1374         } else {
1375             return false;
1376         }
1377 
1378         return msg.value != 0; // check for non zero contribution
1379     }
1380 }
1381 
1382 contract OldERC20ExchangeSupport is Exchange, ReferralExchange {
1383 
1384     /**
1385     * @dev Allows user to deposit Tokens in the exchange contract.
1386     * Only the respected user can withdraw these tokens.
1387     * @param _tokenAddress address representing the token contract address.
1388     * @param _amount uint256 representing the token amount to be deposited.
1389     */
1390     function depositOldTokens(
1391         address _tokenAddress,
1392         uint256 _amount
1393     )
1394         external
1395     {
1396         address user = msg.sender;
1397         _depositOldTokens(_tokenAddress, _amount, user);
1398         emit Deposit(_tokenAddress, user, _amount, balances[_tokenAddress][user]);
1399     }
1400 
1401     /**
1402     * @dev Deposit Tokens with a given referrer address
1403     * @param _referrer address of the referrer
1404     */
1405     function depositOldTokens(
1406         address _tokenAddress,
1407         uint256 _amount,
1408         address _referrer
1409     )
1410         external
1411     {
1412         address user = msg.sender;
1413 
1414         require(
1415             0x0 == referrals[user],
1416             "This user already have a referrer."
1417         );
1418 
1419         _depositOldTokens(_tokenAddress, _amount, user);
1420         referrals[user] = _referrer;
1421         emit ReferralDeposit(_tokenAddress, user, _referrer, _amount, balances[_tokenAddress][user]);
1422     }
1423 
1424         /**
1425     * @dev Allows user to deposit Tokens for beneficiary in the exchange contract.
1426     * Only the beneficiary can withdraw these tokens.
1427     * @param _tokenAddress address representing the token contract address.
1428     * @param _amount uint256 representing the token amount to be deposited.
1429     * @param _beneficiary address representing the token amount to be deposited.
1430     */
1431     function depositOldTokensFor(
1432         address _tokenAddress,
1433         uint256 _amount,
1434         address _beneficiary
1435     )
1436         external
1437     {
1438         _depositOldTokens(_tokenAddress, _amount, _beneficiary);
1439         emit Deposit(_tokenAddress, _beneficiary, _amount, balances[_tokenAddress][_beneficiary]);
1440     }
1441 
1442     /**
1443     * @dev Allows user to withdraw specific Token from the exchange contract.
1444     * Throws if the user balance is lower than the requested amount.
1445     * @param _tokenAddress address representing the token contract address.
1446     * @param _amount uint256 representing the amount to be withdrawn.
1447     */
1448     function withdrawOldTokens(
1449         address _tokenAddress,
1450         uint256 _amount
1451     )
1452         external
1453     {
1454         address user = msg.sender;
1455 
1456         require(
1457             balances[_tokenAddress][user] >= _amount,
1458             "Not enough funds to withdraw."
1459         );
1460 
1461         balances[_tokenAddress][user] = balances[_tokenAddress][user].sub(_amount);
1462 
1463         SafeOldERC20.transfer(_tokenAddress, user, _amount);
1464 
1465         emit Withdraw(_tokenAddress, user, _amount, balances[_tokenAddress][user]);
1466     }
1467 
1468     /**
1469     * @dev Internal version of deposit Tokens.
1470     */
1471     function _depositOldTokens(
1472         address _tokenAddress,
1473         uint256 _amount,
1474         address _beneficiary
1475     )
1476         internal
1477     {
1478         balances[_tokenAddress][_beneficiary] = balances[_tokenAddress][_beneficiary].add(_amount);
1479 
1480         SafeOldERC20.transferFrom(_tokenAddress, msg.sender, this, _amount);
1481     }
1482 }
1483 
1484 contract WeiDex is DiscountTokenExchange, ReferralExchange, UpgradableExchange, ExchangeOffering, OldERC20ExchangeSupport  {
1485 
1486     mapping(bytes4 => bool) private allowedMethods;
1487 
1488     function () public payable {
1489         revert("Cannot send Ethers to the contract, use depositEthers");
1490     }
1491 
1492     constructor(
1493         address _feeAccount,
1494         uint256 _feeRate,
1495         uint256 _referralFeeRate,
1496         address _discountTokenAddress,
1497         uint256 _discountTokenRatio
1498     )
1499         public
1500         Exchange(_feeAccount, _feeRate)
1501         ReferralExchange(_referralFeeRate)
1502         DiscountTokenExchange(_discountTokenAddress, _discountTokenRatio)
1503     {
1504         // empty constructor
1505     }
1506 
1507     /**
1508     * @dev Allows or restricts methods from being executed in takeAllPossible and takeAllOrRevert
1509     * @param _methodId bytes4 method id that will be allowed/forbidded from execution
1510     * @param _allowed bool
1511     */
1512     function allowOrRestrictMethod(
1513         bytes4 _methodId,
1514         bool _allowed
1515     )
1516         external
1517         onlyOwner
1518     {
1519         allowedMethods[_methodId] = _allowed;
1520     }
1521 
1522     /**
1523     * @dev Execute multiple order by given method id
1524     * @param _orderAddresses address[3][] representing
1525     * @param _orderValues uint256[4][] representing
1526     * @param _takerSellAmount uint256[] - amounts being asked from the taker, should be in tokens
1527     * @param _v uint8[] parameter parsed from the signature recovery
1528     * @param _r bytes32[] parameter parsed from the signature (from 0 to 32 bytes)
1529     * @param _s bytes32[] parameter parsed from the signature (from 32 to 64 bytes)
1530     */
1531     function takeAllOrRevert(
1532         address[3][] _orderAddresses,
1533         uint256[3][] _orderValues,
1534         uint256[] _takerSellAmount,
1535         uint8[] _v,
1536         bytes32[] _r,
1537         bytes32[] _s,
1538         bytes4 _methodId
1539     )
1540         external
1541     {
1542         require(
1543             allowedMethods[_methodId],
1544             "Can't call this method"
1545         );
1546 
1547         for (uint256 index = 0; index < _orderAddresses.length; index++) {
1548             require(
1549                 address(this).delegatecall(
1550                 _methodId,
1551                 _orderAddresses[index],
1552                 _orderValues[index],
1553                 _takerSellAmount[index],
1554                 _v[index],
1555                 _r[index],
1556                 _s[index]
1557                 ),
1558                 "Method call failed"
1559             );
1560         }
1561     }
1562 
1563     /**
1564     * @dev Execute multiple order by given method id
1565     * @param _orderAddresses address[3][]
1566     * @param _orderValues uint256[4][]
1567     * @param _takerSellAmount uint256[] - amounts being asked from the taker, should be in tokens
1568     * @param _v uint8[] parameter parsed from the signature recovery
1569     * @param _r bytes32[] parameter parsed from the signature (from 0 to 32 bytes)
1570     * @param _s bytes32[] parameter parsed from the signature (from 32 to 64 bytes)
1571     */
1572     function takeAllPossible(
1573         address[3][] _orderAddresses,
1574         uint256[3][] _orderValues,
1575         uint256[] _takerSellAmount,
1576         uint8[] _v,
1577         bytes32[] _r,
1578         bytes32[] _s,
1579         bytes4 _methodId
1580     )
1581         external
1582     {
1583         require(
1584             allowedMethods[_methodId],
1585             "Can't call this method"
1586         );
1587 
1588         for (uint256 index = 0; index < _orderAddresses.length; index++) {
1589             address(this).delegatecall(
1590             _methodId,
1591             _orderAddresses[index],
1592             _orderValues[index],
1593             _takerSellAmount[index],
1594             _v[index],
1595             _r[index],
1596             _s[index]
1597             );
1598         }
1599     }
1600 
1601     /**
1602     * @dev Execute buy order based on the order input parameters
1603     * and the signature from the maker's signing
1604     * @param _orderAddresses address[3] representing
1605     * [0] address of the order maker
1606     * [1] address of ether (0x0)
1607     * [2] address of token being bought
1608     * @param _orderValues uint256[4] representing
1609     * [0] amount in Ethers (wei)
1610     * [1] amount in tokens
1611     * [2] order nonce used for hash uniqueness
1612     * @param _takerSellAmount uint256 - amount being asked from the taker, should be in tokens
1613     * @param _v uint8 parameter parsed from the signature recovery
1614     * @param _r bytes32 parameter parsed from the signature (from 0 to 32 bytes)
1615     * @param _s bytes32 parameter parsed from the signature (from 32 to 64 bytes)
1616     */
1617     function takeBuyOrder(
1618         address[3] _orderAddresses,
1619         uint256[3] _orderValues,
1620         uint256 _takerSellAmount,
1621         uint8 _v,
1622         bytes32 _r,
1623         bytes32 _s
1624     )
1625         external
1626     {
1627         require(
1628             _orderAddresses[1] == ETH,
1629             "Base currency must be ether's (0x0)"
1630         );
1631 
1632         OrderLib.Order memory order = OrderLib.createOrder(_orderAddresses, _orderValues);
1633         uint256 receivedAmount = takeOrder(order, _takerSellAmount, _v, _r, _s);
1634 
1635         require(0 < receivedAmount, "Trade failure");
1636 
1637         updateVolume(receivedAmount);
1638 
1639         if (!isVolumeReached()) {
1640             takeFee(order.maker, msg.sender, order.makerBuyToken, _takerSellAmount, receivedAmount);
1641         }
1642     }
1643 
1644     /**
1645     * @dev Execute sell order based on the order input parameters
1646     * and the signature from the maker's signing
1647     * @param _orderAddresses address[3] representing
1648     * [0] address of the order maker
1649     * [1] address of token being sold
1650     * [2] address of ether (0x0)
1651     * @param _orderValues uint256[4] representing
1652     * [0] amount in tokens
1653     * [1] amount in Ethers (wei)
1654     * [2] order nonce used for hash uniqueness
1655     * @param _takerSellAmount uint256 - amount being asked from the taker, should be in ethers
1656     * @param _v uint8 parameter parsed from the signature recovery
1657     * @param _r bytes32 parameter parsed from the signature (from 0 to 32 bytes)
1658     * @param _s bytes32 parameter parsed from the signature (from 32 to 64 bytes)
1659     */
1660     function takeSellOrder(
1661         address[3] _orderAddresses,
1662         uint256[3] _orderValues,
1663         uint256 _takerSellAmount,
1664         uint8 _v,
1665         bytes32 _r,
1666         bytes32 _s
1667     )
1668         public
1669     {
1670         require(
1671             _orderAddresses[2] == ETH,
1672             "Base currency must be ether's (0x0)"
1673         );
1674 
1675         OrderLib.Order memory order = OrderLib.createOrder(_orderAddresses, _orderValues);
1676 
1677         uint256 receivedAmount = takeOrder(order, _takerSellAmount, _v, _r, _s);
1678 
1679         require(0 < receivedAmount, "Trade failure");
1680 
1681         updateVolume(_takerSellAmount);
1682 
1683         if (!isVolumeReached()) {
1684             takeFee(order.maker, msg.sender, order.makerSellToken, receivedAmount, _takerSellAmount);
1685         }
1686     }
1687 
1688     /**
1689     * @dev Takes fee for making/taking the order
1690     * @param _maker address
1691     * @param _taker address
1692     * @param _tokenAddress address
1693     * @param _tokenFulfilledAmount uint256 fulfilled amount in tokens
1694     * @param _etherFulfilledAmount uint256 fulfilled amount in ethers
1695     */
1696     function takeFee(
1697         address _maker,
1698         address _taker,
1699         address _tokenAddress,
1700         uint256 _tokenFulfilledAmount,
1701         uint256 _etherFulfilledAmount
1702     )
1703         private
1704     {
1705         uint256 _feeRate = feeRate; // gas optimization
1706         uint256 feeInWdx = _etherFulfilledAmount.calculateWdxFee(discountTokenRatio, feeRate);
1707 
1708         takeFee(_maker, ETH, _etherFulfilledAmount.div(_feeRate), feeInWdx);
1709         takeFee(_taker, _tokenAddress, _tokenFulfilledAmount.div(_feeRate), feeInWdx);
1710     }
1711 
1712     /**
1713     * @dev Takes fee in WDX or the given token address
1714     * @param _user address taker or maker
1715     * @param _tokenAddress address of the token
1716     * @param _tokenFeeAmount uint256 amount in given token address
1717     * @param _wdxFeeAmount uint256 amount in WDX tokens
1718     */
1719     function takeFee(
1720         address _user,
1721         address _tokenAddress,
1722         uint256 _tokenFeeAmount,
1723         uint256 _wdxFeeAmount
1724         )
1725         private
1726     {
1727         if(balances[discountTokenAddress][_user] >= _wdxFeeAmount) {
1728             takeFee(_user, discountTokenAddress, _wdxFeeAmount);
1729         } else {
1730             takeFee(_user, _tokenAddress, _tokenFeeAmount);
1731         }
1732     }
1733 
1734     /**
1735     * @dev Takes fee in WDX or the given token address
1736     * @param _user address taker or maker
1737     * @param _tokenAddress address
1738     * @param _fullFee uint256 fee taken from a given token address
1739     */
1740     function takeFee(
1741         address _user,
1742         address _tokenAddress,
1743         uint256 _fullFee
1744         )
1745         private
1746     {
1747         address _feeAccount = feeAccount; // gas optimization
1748         address referrer = getReferrer(_user);
1749         uint256 referralFee = _fullFee.calculateReferralFee(referralFeeRate);
1750 
1751         balances[_tokenAddress][_user] = balances[_tokenAddress][_user].sub(_fullFee);
1752 
1753         if(referrer == _feeAccount) {
1754             balances[_tokenAddress][_feeAccount] = balances[_tokenAddress][_feeAccount].add(_fullFee);
1755         } else {
1756             balances[_tokenAddress][_feeAccount] = balances[_tokenAddress][_feeAccount].add(_fullFee.sub(referralFee));
1757             balances[_tokenAddress][referrer] = balances[_tokenAddress][referrer].add(referralFee);
1758         }
1759         emit ReferralBalanceUpdated(referrer, _user, _tokenAddress, _fullFee, referralFee);
1760     }
1761 }