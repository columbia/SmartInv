1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/Restricted.sol
48 
49 /** @title Restricted
50  *  Exposes onlyMonetha modifier
51  */
52 contract Restricted is Ownable {
53 
54     mapping (address => bool) public isMonethaAddress;
55 
56     /**
57      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
58      */
59     modifier onlyMonetha() {
60         require(isMonethaAddress[msg.sender]);
61         _;
62     }
63 
64     /**
65      *  Allows owner to set new monetha address
66      */
67     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
68         isMonethaAddress[_address] = _isMonethaAddress;
69     }
70 
71 }
72 
73 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
74 
75 /**
76  * @title Contactable token
77  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
78  * contact information.
79  */
80 contract Contactable is Ownable{
81 
82     string public contactInformation;
83 
84     /**
85      * @dev Allows the owner to set a string with their contact information.
86      * @param info The contact information to attach to the contract.
87      */
88     function setContactInformation(string info) onlyOwner public {
89          contactInformation = info;
90      }
91 }
92 
93 // File: contracts/MerchantDealsHistory.sol
94 
95 /**
96  *  @title MerchantDealsHistory
97  *  Contract stores hash of Deals conditions together with parties reputation for each deal
98  *  This history enables to see evolution of trust rating for both parties
99  */
100 contract MerchantDealsHistory is Contactable, Restricted {
101 
102     string constant VERSION = "0.3";
103 
104     ///  Merchant identifier hash
105     bytes32 public merchantIdHash;
106     
107     //Deal event
108     event DealCompleted(
109         uint orderId,
110         address clientAddress,
111         uint32 clientReputation,
112         uint32 merchantReputation,
113         bool successful,
114         uint dealHash
115     );
116 
117     //Deal cancellation event
118     event DealCancelationReason(
119         uint orderId,
120         address clientAddress,
121         uint32 clientReputation,
122         uint32 merchantReputation,
123         uint dealHash,
124         string cancelReason
125     );
126 
127     //Deal refund event
128     event DealRefundReason(
129         uint orderId,
130         address clientAddress,
131         uint32 clientReputation,
132         uint32 merchantReputation,
133         uint dealHash,
134         string refundReason
135     );
136 
137     /**
138      *  @param _merchantId Merchant of the acceptor
139      */
140     function MerchantDealsHistory(string _merchantId) public {
141         require(bytes(_merchantId).length > 0);
142         merchantIdHash = keccak256(_merchantId);
143     }
144 
145     /**
146      *  recordDeal creates an event of completed deal
147      *  @param _orderId Identifier of deal's order
148      *  @param _clientAddress Address of client's account
149      *  @param _clientReputation Updated reputation of the client
150      *  @param _merchantReputation Updated reputation of the merchant
151      *  @param _isSuccess Identifies whether deal was successful or not
152      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
153      */
154     function recordDeal(
155         uint _orderId,
156         address _clientAddress,
157         uint32 _clientReputation,
158         uint32 _merchantReputation,
159         bool _isSuccess,
160         uint _dealHash)
161         external onlyMonetha
162     {
163         DealCompleted(
164             _orderId,
165             _clientAddress,
166             _clientReputation,
167             _merchantReputation,
168             _isSuccess,
169             _dealHash
170         );
171     }
172 
173     /**
174      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
175      *  @param _orderId Identifier of deal's order
176      *  @param _clientAddress Address of client's account
177      *  @param _clientReputation Updated reputation of the client
178      *  @param _merchantReputation Updated reputation of the merchant
179      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
180      *  @param _cancelReason deal cancelation reason (text)
181      */
182     function recordDealCancelReason(
183         uint _orderId,
184         address _clientAddress,
185         uint32 _clientReputation,
186         uint32 _merchantReputation,
187         uint _dealHash,
188         string _cancelReason)
189         external onlyMonetha
190     {
191         DealCancelationReason(
192             _orderId,
193             _clientAddress,
194             _clientReputation,
195             _merchantReputation,
196             _dealHash,
197             _cancelReason
198         );
199     }
200 
201 /**
202      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
203      *  @param _orderId Identifier of deal's order
204      *  @param _clientAddress Address of client's account
205      *  @param _clientReputation Updated reputation of the client
206      *  @param _merchantReputation Updated reputation of the merchant
207      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
208      *  @param _refundReason deal refund reason (text)
209      */
210     function recordDealRefundReason(
211         uint _orderId,
212         address _clientAddress,
213         uint32 _clientReputation,
214         uint32 _merchantReputation,
215         uint _dealHash,
216         string _refundReason)
217         external onlyMonetha
218     {
219         DealRefundReason(
220             _orderId,
221             _clientAddress,
222             _clientReputation,
223             _merchantReputation,
224             _dealHash,
225             _refundReason
226         );
227     }
228 }
229 
230 // File: contracts/SafeDestructible.sol
231 
232 /**
233  * @title SafeDestructible
234  * Base contract that can be destroyed by owner.
235  * Can be destructed if there are no funds on contract balance.
236  */
237 contract SafeDestructible is Ownable {
238     function destroy() onlyOwner public {
239         require(this.balance == 0);
240         selfdestruct(owner);
241     }
242 }
243 
244 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
245 
246 /**
247  * @title Pausable
248  * @dev Base contract which allows children to implement an emergency stop mechanism.
249  */
250 contract Pausable is Ownable {
251   event Pause();
252   event Unpause();
253 
254   bool public paused = false;
255 
256 
257   /**
258    * @dev Modifier to make a function callable only when the contract is not paused.
259    */
260   modifier whenNotPaused() {
261     require(!paused);
262     _;
263   }
264 
265   /**
266    * @dev Modifier to make a function callable only when the contract is paused.
267    */
268   modifier whenPaused() {
269     require(paused);
270     _;
271   }
272 
273   /**
274    * @dev called by the owner to pause, triggers stopped state
275    */
276   function pause() onlyOwner whenNotPaused public {
277     paused = true;
278     Pause();
279   }
280 
281   /**
282    * @dev called by the owner to unpause, returns to normal state
283    */
284   function unpause() onlyOwner whenPaused public {
285     paused = false;
286     Unpause();
287   }
288 }
289 
290 // File: contracts/MerchantWallet.sol
291 
292 /**
293  *  @title MerchantWallet
294  *  Serves as a public Merchant profile with merchant profile info, 
295  *      payment settings and latest reputation value.
296  *  Also MerchantWallet accepts payments for orders.
297  */
298 
299 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
300     
301     string constant VERSION = "0.3";
302 
303     /// Address of merchant's account, that can withdraw from wallet
304     address public merchantAccount;
305     
306     /// Unique Merchant identifier hash
307     bytes32 public merchantIdHash;
308 
309     /// profileMap stores general information about the merchant
310     mapping (string=>string) profileMap;
311 
312     /// paymentSettingsMap stores payment and order settings for the merchant
313     mapping (string=>string) paymentSettingsMap;
314 
315     /// compositeReputationMap stores composite reputation, that compraises from several metrics
316     mapping (string=>uint32) compositeReputationMap;
317 
318     /// number of last digits in compositeReputation for fractional part
319     uint8 public constant REPUTATION_DECIMALS = 4;
320 
321     modifier onlyMerchant() {
322         require(msg.sender == merchantAccount);
323         _;
324     }
325 
326     /**
327      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
328      *  @param _merchantId Merchant identifier
329      */
330     function MerchantWallet(address _merchantAccount, string _merchantId) public {
331         require(_merchantAccount != 0x0);
332         require(bytes(_merchantId).length > 0);
333         
334         merchantAccount = _merchantAccount;
335         merchantIdHash = keccak256(_merchantId);
336     }
337 
338     /**
339      *  Accept payment from MonethaGateway
340      */
341     function () external payable {
342     }
343 
344     /**
345      *  @return profile info by string key
346      */
347     function profile(string key) external constant returns (string) {
348         return profileMap[key];
349     }
350 
351     /**
352      *  @return payment setting by string key
353      */
354     function paymentSettings(string key) external constant returns (string) {
355         return paymentSettingsMap[key];
356     }
357 
358     /**
359      *  @return composite reputation value by string key
360      */
361     function compositeReputation(string key) external constant returns (uint32) {
362         return compositeReputationMap[key];
363     }
364 
365     /**
366      *  Set profile info by string key
367      */
368     function setProfile(
369         string profileKey,
370         string profileValue,
371         string repKey,
372         uint32 repValue
373     ) external onlyOwner
374     {
375         profileMap[profileKey] = profileValue;
376         
377         if (bytes(repKey).length != 0) {
378             compositeReputationMap[repKey] = repValue;
379         }
380     }
381 
382     /**
383      *  Set payment setting by string key
384      */
385     function setPaymentSettings(string key, string value) external onlyOwner {
386         paymentSettingsMap[key] = value;
387     }
388 
389     /**
390      *  Set composite reputation value by string key
391      */
392     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
393         compositeReputationMap[key] = value;
394     }
395 
396     /**
397      *  Allows merchant to withdraw funds to beneficiary address
398      */
399     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
400         require(beneficiary != 0x0);
401         beneficiary.transfer(amount);
402     }
403 
404     /**
405      *  Allows merchant to withdraw funds to it's own account
406      */
407     function withdraw(uint amount) external {
408         withdrawTo(msg.sender, amount);
409     }
410 
411     /**
412      *  Allows merchant to change it's account address
413      */
414     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
415         merchantAccount = newAccount;
416     }
417 }
418 
419 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
420 
421 /**
422  * @title Destructible
423  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
424  */
425 contract Destructible is Ownable {
426 
427   function Destructible() payable { }
428 
429   /**
430    * @dev Transfers the current balance to the owner and terminates the contract.
431    */
432   function destroy() onlyOwner public {
433     selfdestruct(owner);
434   }
435 
436   function destroyAndSend(address _recipient) onlyOwner public {
437     selfdestruct(_recipient);
438   }
439 }
440 
441 // File: zeppelin-solidity/contracts/math/SafeMath.sol
442 
443 /**
444  * @title SafeMath
445  * @dev Math operations with safety checks that throw on error
446  */
447 library SafeMath {
448   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
449     uint256 c = a * b;
450     assert(a == 0 || c / a == b);
451     return c;
452   }
453 
454   function div(uint256 a, uint256 b) internal constant returns (uint256) {
455     // assert(b > 0); // Solidity automatically throws when dividing by 0
456     uint256 c = a / b;
457     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
458     return c;
459   }
460 
461   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
462     assert(b <= a);
463     return a - b;
464   }
465 
466   function add(uint256 a, uint256 b) internal constant returns (uint256) {
467     uint256 c = a + b;
468     assert(c >= a);
469     return c;
470   }
471 }
472 
473 // File: contracts/MonethaGateway.sol
474 
475 /**
476  *  @title MonethaGateway
477  *
478  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
479  */
480 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
481 
482     using SafeMath for uint256;
483     
484     string constant VERSION = "0.3";
485 
486     /**
487      *  Fee permille of Monetha fee.
488      *  1 permille (‰) = 0.1 percent (%)
489      *  15‰ = 1.5%
490      */
491     uint public constant FEE_PERMILLE = 15;
492     
493     /**
494      *  Address of Monetha Vault for fee collection
495      */
496     address public monethaVault;
497 
498     /**
499      *  Account for permissions managing
500      */
501     address public admin;
502 
503     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
504 
505     /**
506      *  @param _monethaVault Address of Monetha Vault
507      */
508     function MonethaGateway(address _monethaVault, address _admin) public {
509         require(_monethaVault != 0x0);
510         monethaVault = _monethaVault;
511         
512         setAdmin(_admin);
513     }
514     
515     /**
516      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
517      *      and collects Monetha fee.
518      *  @param _merchantWallet address of merchant's wallet for fund transfer
519      */
520     function acceptPayment(address _merchantWallet) external payable onlyMonetha whenNotPaused {
521         require(_merchantWallet != 0x0);
522 
523         uint merchantIncome = msg.value.sub(FEE_PERMILLE.mul(msg.value).div(1000));
524         uint monethaIncome = msg.value.sub(merchantIncome);
525 
526         _merchantWallet.transfer(merchantIncome);
527         monethaVault.transfer(monethaIncome);
528 
529         PaymentProcessed(_merchantWallet, merchantIncome, monethaIncome);
530     }
531 
532     /**
533      *  changeMonethaVault allows owner to change address of Monetha Vault.
534      *  @param newVault New address of Monetha Vault
535      */
536     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
537         monethaVault = newVault;
538     }
539 
540     /**
541      *  Allows other monetha account or contract to set new monetha address
542      */
543     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
544         require(msg.sender == admin || msg.sender == owner);
545 
546         isMonethaAddress[_address] = _isMonethaAddress;
547     }
548 
549     /**
550      *  setAdmin allows owner to change address of admin.
551      *  @param _admin New address of admin
552      */
553     function setAdmin(address _admin) public onlyOwner {
554         require(_admin != 0x0);
555         admin = _admin;
556     }
557 }
558 
559 // File: contracts/PaymentProcessor.sol
560 
561 /**
562  *  @title PaymentProcessor
563  *  Each Merchant has one PaymentProcessor that ensure payment and order processing with Trust and Reputation
564  *
565  *  Payment Processor State Transitions:
566  *  Null -(addOrder) -> Created
567  *  Created -(securePay) -> Paid
568  *  Created -(cancelOrder) -> Cancelled
569  *  Paid -(refundPayment) -> Refunding
570  *  Paid -(processPayment) -> Finalized
571  *  Refunding -(withdrawRefund) -> Refunded
572  */
573 
574 
575 contract PaymentProcessor is Pausable, Destructible, Contactable, Restricted {
576 
577     using SafeMath for uint256;
578 
579     string constant VERSION = "0.3";
580 
581     /// MonethaGateway contract for payment processing
582     MonethaGateway public monethaGateway;
583 
584     /// MerchantDealsHistory contract of acceptor's merchant
585     MerchantDealsHistory public merchantHistory;
586 
587     /// Address of MerchantWallet, where merchant reputation and funds are stored
588     MerchantWallet public merchantWallet;
589 
590     /// Merchant identifier hash, that associates with the acceptor
591     bytes32 public merchantIdHash;
592 
593     mapping (uint=>Order) public orders;
594 
595     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
596 
597     struct Order {
598         State state;
599         uint price;
600         uint creationTime;
601         address paymentAcceptor;
602         address originAddress;
603     }
604 
605     /**
606      *  Asserts current state.
607      *  @param _state Expected state
608      *  @param _orderId Order Id
609      */
610     modifier atState(uint _orderId, State _state) {
611         require(_state == orders[_orderId].state);
612         _;
613     }
614 
615     /**
616      *  Performs a transition after function execution.
617      *  @param _state Next state
618      *  @param _orderId Order Id
619      */
620     modifier transition(uint _orderId, State _state) {
621         _;
622         orders[_orderId].state = _state;
623     }
624 
625     /**
626      *  payment Processor sets Monetha Gateway
627      *  @param _merchantId Merchant of the acceptor
628      *  @param _merchantHistory Address of MerchantDealsHistory contract of acceptor's merchant
629      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
630      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
631      */
632     function PaymentProcessor(
633         string _merchantId,
634         MerchantDealsHistory _merchantHistory,
635         MonethaGateway _monethaGateway,
636         MerchantWallet _merchantWallet
637     ) public
638     {
639         require(bytes(_merchantId).length > 0);
640 
641         merchantIdHash = keccak256(_merchantId);
642 
643         setMonethaGateway(_monethaGateway);
644         setMerchantWallet(_merchantWallet);
645         setMerchantDealsHistory(_merchantHistory);
646     }
647 
648     /**
649      *  Assigns the acceptor to the order (when client initiates order).
650      *  @param _orderId Identifier of the order
651      *  @param _price Price of the order 
652      *  @param _paymentAcceptor order payment acceptor
653      *  @param _originAddress buyer address
654      *  @param _orderCreationTime order creation time
655      */
656     function addOrder(
657         uint _orderId,
658         uint _price,
659         address _paymentAcceptor,
660         address _originAddress,
661         uint _orderCreationTime
662     ) external onlyMonetha whenNotPaused atState(_orderId, State.Null)
663     {
664         require(_orderId > 0);
665         require(_price > 0);
666 
667         orders[_orderId] = Order({
668             state: State.Created,
669             price: _price,
670             creationTime: _orderCreationTime,
671             paymentAcceptor: _paymentAcceptor,
672             originAddress: _originAddress
673         });
674     }
675 
676     /**
677      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
678      *  This function require more gas, then fallback function.
679      *  @param _orderId Identifier of the order
680      */
681     function securePay(uint _orderId)
682         external payable whenNotPaused
683         atState(_orderId, State.Created) transition(_orderId, State.Paid)
684     {
685         Order storage order = orders[_orderId];
686 
687         require(msg.sender == order.paymentAcceptor);
688         require(msg.value == order.price);
689     }
690 
691     /**
692      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
693      *  @param _orderId Identifier of the order
694      *  @param _clientReputation Updated reputation of the client
695      *  @param _merchantReputation Updated reputation of the merchant
696      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
697      *  @param _cancelReason Order cancel reason
698      */
699     function cancelOrder(
700         uint _orderId,
701         uint32 _clientReputation,
702         uint32 _merchantReputation,
703         uint _dealHash,
704         string _cancelReason
705     )
706         external onlyMonetha whenNotPaused
707         atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
708     {
709         require(bytes(_cancelReason).length > 0);
710 
711         Order storage order = orders[_orderId];
712 
713         updateDealConditions(
714             _orderId,
715             _clientReputation,
716             _merchantReputation,
717             false,
718             _dealHash
719         );
720 
721         merchantHistory.recordDealCancelReason(
722             _orderId,
723             order.originAddress,
724             _clientReputation,
725             _merchantReputation,
726             _dealHash,
727             _cancelReason
728         );
729     }
730 
731     /**
732      *  refundPayment used in case order cannot be processed.
733      *  This function initiate process of funds refunding to the client.
734      *  @param _orderId Identifier of the order
735      *  @param _clientReputation Updated reputation of the client
736      *  @param _merchantReputation Updated reputation of the merchant
737      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
738      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
739      */
740     function refundPayment(
741         uint _orderId,
742         uint32 _clientReputation,
743         uint32 _merchantReputation,
744         uint _dealHash,
745         string _refundReason
746     )   
747         external onlyMonetha whenNotPaused
748         atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
749     {
750         require(bytes(_refundReason).length > 0);
751 
752         Order storage order = orders[_orderId];
753 
754         updateDealConditions(
755             _orderId,
756             _clientReputation,
757             _merchantReputation,
758             false,
759             _dealHash
760         );
761 
762         merchantHistory.recordDealRefundReason(
763             _orderId,
764             order.originAddress,
765             _clientReputation,
766             _merchantReputation,
767             _dealHash,
768             _refundReason
769         );
770     }
771 
772     /**
773      *  withdrawRefund performs fund transfer to the client's account.
774      *  @param _orderId Identifier of the order
775      */
776     function withdrawRefund(uint _orderId) 
777         external whenNotPaused
778         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded) 
779     {
780         Order storage order = orders[_orderId];
781         order.originAddress.transfer(order.price);
782     }
783 
784     /**
785      *  processPayment transfer funds to MonethaGateway and completes the order.
786      *  @param _orderId Identifier of the order
787      *  @param _clientReputation Updated reputation of the client
788      *  @param _merchantReputation Updated reputation of the merchant
789      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
790      */
791     function processPayment(
792         uint _orderId,
793         uint32 _clientReputation,
794         uint32 _merchantReputation,
795         uint _dealHash
796     )
797         external onlyMonetha whenNotPaused
798         atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
799     {
800 
801         monethaGateway.acceptPayment.value(orders[_orderId].price)(merchantWallet);
802 
803         updateDealConditions(
804             _orderId,
805             _clientReputation,
806             _merchantReputation,
807             true,
808             _dealHash
809         );
810     }
811 
812     /**
813      *  setMonethaGateway allows owner to change address of MonethaGateway.
814      *  @param _newGateway Address of new MonethaGateway contract
815      */
816     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
817         require(address(_newGateway) != 0x0);
818 
819         monethaGateway = _newGateway;
820     }
821 
822     /**
823      *  setMerchantWallet allows owner to change address of MerchantWallet.
824      *  @param _newWallet Address of new MerchantWallet contract
825      */
826     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
827         require(address(_newWallet) != 0x0);
828         require(_newWallet.merchantIdHash() == merchantIdHash);
829 
830         merchantWallet = _newWallet;
831     }
832 
833     /**
834      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
835      *  @param _merchantHistory Address of new MerchantDealsHistory contract
836      */
837     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
838         require(address(_merchantHistory) != 0x0);
839         require(_merchantHistory.merchantIdHash() == merchantIdHash);
840 
841         merchantHistory = _merchantHistory;
842     }
843 
844     /**
845      *  updateDealConditions record finalized deal and updates merchant reputation
846      *  in future: update Client reputation
847      *  @param _orderId Identifier of the order
848      *  @param _clientReputation Updated reputation of the client
849      *  @param _merchantReputation Updated reputation of the merchant
850      *  @param _isSuccess Identifies whether deal was successful or not
851      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
852      */
853     function updateDealConditions(
854         uint _orderId,
855         uint32 _clientReputation,
856         uint32 _merchantReputation,
857         bool _isSuccess,
858         uint _dealHash
859     ) internal
860     {
861         merchantHistory.recordDeal(
862             _orderId,
863             orders[_orderId].originAddress,
864             _clientReputation,
865             _merchantReputation,
866             _isSuccess,
867             _dealHash
868         );
869 
870         //update parties Reputation
871         merchantWallet.setCompositeReputation("total", _merchantReputation);
872     }
873 }