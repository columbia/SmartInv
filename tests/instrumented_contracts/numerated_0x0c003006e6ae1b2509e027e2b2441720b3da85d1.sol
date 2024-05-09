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
54     //MonethaAddress set event
55     event MonethaAddressSet(
56         address _address,
57         bool _isMonethaAddress
58     );
59 
60     mapping (address => bool) public isMonethaAddress;
61 
62     /**
63      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
64      */
65     modifier onlyMonetha() {
66         require(isMonethaAddress[msg.sender]);
67         _;
68     }
69 
70     /**
71      *  Allows owner to set new monetha address
72      */
73     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
74         isMonethaAddress[_address] = _isMonethaAddress;
75 
76         MonethaAddressSet(_address, _isMonethaAddress);
77     }
78 }
79 
80 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
81 
82 /**
83  * @title Contactable token
84  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
85  * contact information.
86  */
87 contract Contactable is Ownable{
88 
89     string public contactInformation;
90 
91     /**
92      * @dev Allows the owner to set a string with their contact information.
93      * @param info The contact information to attach to the contract.
94      */
95     function setContactInformation(string info) onlyOwner public {
96          contactInformation = info;
97      }
98 }
99 
100 // File: contracts/MerchantDealsHistory.sol
101 
102 /**
103  *  @title MerchantDealsHistory
104  *  Contract stores hash of Deals conditions together with parties reputation for each deal
105  *  This history enables to see evolution of trust rating for both parties
106  */
107 contract MerchantDealsHistory is Contactable, Restricted {
108 
109     string constant VERSION = "0.3";
110 
111     ///  Merchant identifier hash
112     bytes32 public merchantIdHash;
113     
114     //Deal event
115     event DealCompleted(
116         uint orderId,
117         address clientAddress,
118         uint32 clientReputation,
119         uint32 merchantReputation,
120         bool successful,
121         uint dealHash
122     );
123 
124     //Deal cancellation event
125     event DealCancelationReason(
126         uint orderId,
127         address clientAddress,
128         uint32 clientReputation,
129         uint32 merchantReputation,
130         uint dealHash,
131         string cancelReason
132     );
133 
134     //Deal refund event
135     event DealRefundReason(
136         uint orderId,
137         address clientAddress,
138         uint32 clientReputation,
139         uint32 merchantReputation,
140         uint dealHash,
141         string refundReason
142     );
143 
144     /**
145      *  @param _merchantId Merchant of the acceptor
146      */
147     function MerchantDealsHistory(string _merchantId) public {
148         require(bytes(_merchantId).length > 0);
149         merchantIdHash = keccak256(_merchantId);
150     }
151 
152     /**
153      *  recordDeal creates an event of completed deal
154      *  @param _orderId Identifier of deal's order
155      *  @param _clientAddress Address of client's account
156      *  @param _clientReputation Updated reputation of the client
157      *  @param _merchantReputation Updated reputation of the merchant
158      *  @param _isSuccess Identifies whether deal was successful or not
159      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
160      */
161     function recordDeal(
162         uint _orderId,
163         address _clientAddress,
164         uint32 _clientReputation,
165         uint32 _merchantReputation,
166         bool _isSuccess,
167         uint _dealHash)
168         external onlyMonetha
169     {
170         DealCompleted(
171             _orderId,
172             _clientAddress,
173             _clientReputation,
174             _merchantReputation,
175             _isSuccess,
176             _dealHash
177         );
178     }
179 
180     /**
181      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
182      *  @param _orderId Identifier of deal's order
183      *  @param _clientAddress Address of client's account
184      *  @param _clientReputation Updated reputation of the client
185      *  @param _merchantReputation Updated reputation of the merchant
186      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
187      *  @param _cancelReason deal cancelation reason (text)
188      */
189     function recordDealCancelReason(
190         uint _orderId,
191         address _clientAddress,
192         uint32 _clientReputation,
193         uint32 _merchantReputation,
194         uint _dealHash,
195         string _cancelReason)
196         external onlyMonetha
197     {
198         DealCancelationReason(
199             _orderId,
200             _clientAddress,
201             _clientReputation,
202             _merchantReputation,
203             _dealHash,
204             _cancelReason
205         );
206     }
207 
208 /**
209      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
210      *  @param _orderId Identifier of deal's order
211      *  @param _clientAddress Address of client's account
212      *  @param _clientReputation Updated reputation of the client
213      *  @param _merchantReputation Updated reputation of the merchant
214      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
215      *  @param _refundReason deal refund reason (text)
216      */
217     function recordDealRefundReason(
218         uint _orderId,
219         address _clientAddress,
220         uint32 _clientReputation,
221         uint32 _merchantReputation,
222         uint _dealHash,
223         string _refundReason)
224         external onlyMonetha
225     {
226         DealRefundReason(
227             _orderId,
228             _clientAddress,
229             _clientReputation,
230             _merchantReputation,
231             _dealHash,
232             _refundReason
233         );
234     }
235 }
236 
237 // File: contracts/SafeDestructible.sol
238 
239 /**
240  * @title SafeDestructible
241  * Base contract that can be destroyed by owner.
242  * Can be destructed if there are no funds on contract balance.
243  */
244 contract SafeDestructible is Ownable {
245     function destroy() onlyOwner public {
246         require(this.balance == 0);
247         selfdestruct(owner);
248     }
249 }
250 
251 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
252 
253 /**
254  * @title Pausable
255  * @dev Base contract which allows children to implement an emergency stop mechanism.
256  */
257 contract Pausable is Ownable {
258   event Pause();
259   event Unpause();
260 
261   bool public paused = false;
262 
263 
264   /**
265    * @dev Modifier to make a function callable only when the contract is not paused.
266    */
267   modifier whenNotPaused() {
268     require(!paused);
269     _;
270   }
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is paused.
274    */
275   modifier whenPaused() {
276     require(paused);
277     _;
278   }
279 
280   /**
281    * @dev called by the owner to pause, triggers stopped state
282    */
283   function pause() onlyOwner whenNotPaused public {
284     paused = true;
285     Pause();
286   }
287 
288   /**
289    * @dev called by the owner to unpause, returns to normal state
290    */
291   function unpause() onlyOwner whenPaused public {
292     paused = false;
293     Unpause();
294   }
295 }
296 
297 // File: contracts/MerchantWallet.sol
298 
299 /**
300  *  @title MerchantWallet
301  *  Serves as a public Merchant profile with merchant profile info,
302  *      payment settings and latest reputation value.
303  *  Also MerchantWallet accepts payments for orders.
304  */
305 
306 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
307 
308     string constant VERSION = "0.3";
309 
310     /// Address of merchant's account, that can withdraw from wallet
311     address public merchantAccount;
312 
313     /// Unique Merchant identifier hash
314     bytes32 public merchantIdHash;
315 
316     /// profileMap stores general information about the merchant
317     mapping (string=>string) profileMap;
318 
319     /// paymentSettingsMap stores payment and order settings for the merchant
320     mapping (string=>string) paymentSettingsMap;
321 
322     /// compositeReputationMap stores composite reputation, that compraises from several metrics
323     mapping (string=>uint32) compositeReputationMap;
324 
325     /// number of last digits in compositeReputation for fractional part
326     uint8 public constant REPUTATION_DECIMALS = 4;
327 
328     modifier onlyMerchant() {
329         require(msg.sender == merchantAccount);
330         _;
331     }
332 
333     /**
334      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
335      *  @param _merchantId Merchant identifier
336      */
337     function MerchantWallet(address _merchantAccount, string _merchantId) public {
338         require(_merchantAccount != 0x0);
339         require(bytes(_merchantId).length > 0);
340 
341         merchantAccount = _merchantAccount;
342         merchantIdHash = keccak256(_merchantId);
343     }
344 
345     /**
346      *  Accept payment from MonethaGateway
347      */
348     function () external payable {
349     }
350 
351     /**
352      *  @return profile info by string key
353      */
354     function profile(string key) external constant returns (string) {
355         return profileMap[key];
356     }
357 
358     /**
359      *  @return payment setting by string key
360      */
361     function paymentSettings(string key) external constant returns (string) {
362         return paymentSettingsMap[key];
363     }
364 
365     /**
366      *  @return composite reputation value by string key
367      */
368     function compositeReputation(string key) external constant returns (uint32) {
369         return compositeReputationMap[key];
370     }
371 
372     /**
373      *  Set profile info by string key
374      */
375     function setProfile(
376         string profileKey,
377         string profileValue,
378         string repKey,
379         uint32 repValue
380     ) external onlyOwner
381     {
382         profileMap[profileKey] = profileValue;
383 
384         if (bytes(repKey).length != 0) {
385             compositeReputationMap[repKey] = repValue;
386         }
387     }
388 
389     /**
390      *  Set payment setting by string key
391      */
392     function setPaymentSettings(string key, string value) external onlyOwner {
393         paymentSettingsMap[key] = value;
394     }
395 
396     /**
397      *  Set composite reputation value by string key
398      */
399     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
400         compositeReputationMap[key] = value;
401     }
402 
403     /**
404      *  Allows withdrawal of funds to beneficiary address
405      */
406     function doWithdrawal(address beneficiary, uint amount) private {
407         require(beneficiary != 0x0);
408         beneficiary.transfer(amount);
409     }
410 
411     /**
412      *  Allows merchant to withdraw funds to beneficiary address
413      */
414     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
415         doWithdrawal(beneficiary, amount);
416     }
417 
418     /**
419      *  Allows merchant to withdraw funds to it's own account
420      */
421     function withdraw(uint amount) external {
422         withdrawTo(msg.sender, amount);
423     }
424 
425     /**
426      *  Allows merchant to withdraw funds to beneficiary address with a transaction
427      */
428     function sendTo(address beneficiary, uint amount) external onlyMerchant whenNotPaused {
429         doWithdrawal(beneficiary, amount);
430     }
431 
432     /**
433      *  Allows merchant to change it's account address
434      */
435     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
436         merchantAccount = newAccount;
437     }
438 }
439 
440 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
441 
442 /**
443  * @title Destructible
444  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
445  */
446 contract Destructible is Ownable {
447 
448   function Destructible() payable { }
449 
450   /**
451    * @dev Transfers the current balance to the owner and terminates the contract.
452    */
453   function destroy() onlyOwner public {
454     selfdestruct(owner);
455   }
456 
457   function destroyAndSend(address _recipient) onlyOwner public {
458     selfdestruct(_recipient);
459   }
460 }
461 
462 // File: zeppelin-solidity/contracts/math/SafeMath.sol
463 
464 /**
465  * @title SafeMath
466  * @dev Math operations with safety checks that throw on error
467  */
468 library SafeMath {
469   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
470     uint256 c = a * b;
471     assert(a == 0 || c / a == b);
472     return c;
473   }
474 
475   function div(uint256 a, uint256 b) internal constant returns (uint256) {
476     // assert(b > 0); // Solidity automatically throws when dividing by 0
477     uint256 c = a / b;
478     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
479     return c;
480   }
481 
482   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
483     assert(b <= a);
484     return a - b;
485   }
486 
487   function add(uint256 a, uint256 b) internal constant returns (uint256) {
488     uint256 c = a + b;
489     assert(c >= a);
490     return c;
491   }
492 }
493 
494 // File: contracts/MonethaGateway.sol
495 
496 /**
497  *  @title MonethaGateway
498  *
499  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
500  */
501 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
502 
503     using SafeMath for uint256;
504     
505     string constant VERSION = "0.4";
506 
507     /**
508      *  Fee permille of Monetha fee.
509      *  1 permille (‰) = 0.1 percent (%)
510      *  15‰ = 1.5%
511      */
512     uint public constant FEE_PERMILLE = 15;
513     
514     /**
515      *  Address of Monetha Vault for fee collection
516      */
517     address public monethaVault;
518 
519     /**
520      *  Account for permissions managing
521      */
522     address public admin;
523 
524     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
525 
526     /**
527      *  @param _monethaVault Address of Monetha Vault
528      */
529     function MonethaGateway(address _monethaVault, address _admin) public {
530         require(_monethaVault != 0x0);
531         monethaVault = _monethaVault;
532         
533         setAdmin(_admin);
534     }
535     
536     /**
537      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
538      *      and collects Monetha fee.
539      *  @param _merchantWallet address of merchant's wallet for fund transfer
540      *  @param _monethaFee is a fee collected by Monetha
541      */
542     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
543         require(_merchantWallet != 0x0);
544         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
545 
546         uint merchantIncome = msg.value.sub(_monethaFee);
547 
548         _merchantWallet.transfer(merchantIncome);
549         monethaVault.transfer(_monethaFee);
550 
551         PaymentProcessed(_merchantWallet, merchantIncome, _monethaFee);
552     }
553 
554     /**
555      *  changeMonethaVault allows owner to change address of Monetha Vault.
556      *  @param newVault New address of Monetha Vault
557      */
558     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
559         monethaVault = newVault;
560     }
561 
562     /**
563      *  Allows other monetha account or contract to set new monetha address
564      */
565     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
566         require(msg.sender == admin || msg.sender == owner);
567 
568         isMonethaAddress[_address] = _isMonethaAddress;
569 
570         MonethaAddressSet(_address, _isMonethaAddress);
571     }
572 
573     /**
574      *  setAdmin allows owner to change address of admin.
575      *  @param _admin New address of admin
576      */
577     function setAdmin(address _admin) public onlyOwner {
578         require(_admin != 0x0);
579         admin = _admin;
580     }
581 }
582 
583 // File: contracts/PaymentProcessor.sol
584 
585 /**
586  *  @title PaymentProcessor
587  *  Each Merchant has one PaymentProcessor that ensure payment and order processing with Trust and Reputation
588  *
589  *  Payment Processor State Transitions:
590  *  Null -(addOrder) -> Created
591  *  Created -(securePay) -> Paid
592  *  Created -(cancelOrder) -> Cancelled
593  *  Paid -(refundPayment) -> Refunding
594  *  Paid -(processPayment) -> Finalized
595  *  Refunding -(withdrawRefund) -> Refunded
596  */
597 
598 
599 contract PaymentProcessor is Pausable, Destructible, Contactable, Restricted {
600 
601     using SafeMath for uint256;
602 
603     string constant VERSION = "0.4";
604 
605     /**
606      *  Fee permille of Monetha fee.
607      *  1 permille = 0.1 %
608      *  15 permille = 1.5%
609      */
610     uint public constant FEE_PERMILLE = 15;
611 
612     /// MonethaGateway contract for payment processing
613     MonethaGateway public monethaGateway;
614 
615     /// MerchantDealsHistory contract of acceptor's merchant
616     MerchantDealsHistory public merchantHistory;
617 
618     /// Address of MerchantWallet, where merchant reputation and funds are stored
619     MerchantWallet public merchantWallet;
620 
621     /// Merchant identifier hash, that associates with the acceptor
622     bytes32 public merchantIdHash;
623 
624     mapping (uint=>Order) public orders;
625 
626     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
627 
628     struct Order {
629         State state;
630         uint price;
631         uint fee;
632         address paymentAcceptor;
633         address originAddress;
634     }
635 
636     /**
637      *  Asserts current state.
638      *  @param _state Expected state
639      *  @param _orderId Order Id
640      */
641     modifier atState(uint _orderId, State _state) {
642         require(_state == orders[_orderId].state);
643         _;
644     }
645 
646     /**
647      *  Performs a transition after function execution.
648      *  @param _state Next state
649      *  @param _orderId Order Id
650      */
651     modifier transition(uint _orderId, State _state) {
652         _;
653         orders[_orderId].state = _state;
654     }
655 
656     /**
657      *  payment Processor sets Monetha Gateway
658      *  @param _merchantId Merchant of the acceptor
659      *  @param _merchantHistory Address of MerchantDealsHistory contract of acceptor's merchant
660      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
661      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
662      */
663     function PaymentProcessor(
664         string _merchantId,
665         MerchantDealsHistory _merchantHistory,
666         MonethaGateway _monethaGateway,
667         MerchantWallet _merchantWallet
668     ) public
669     {
670         require(bytes(_merchantId).length > 0);
671 
672         merchantIdHash = keccak256(_merchantId);
673 
674         setMonethaGateway(_monethaGateway);
675         setMerchantWallet(_merchantWallet);
676         setMerchantDealsHistory(_merchantHistory);
677     }
678 
679     /**
680      *  Assigns the acceptor to the order (when client initiates order).
681      *  @param _orderId Identifier of the order
682      *  @param _price Price of the order 
683      *  @param _paymentAcceptor order payment acceptor
684      *  @param _originAddress buyer address
685      *  @param _fee Monetha fee
686      */
687     function addOrder(
688         uint _orderId,
689         uint _price,
690         address _paymentAcceptor,
691         address _originAddress,
692         uint _fee
693     ) external onlyMonetha whenNotPaused atState(_orderId, State.Null)
694     {
695         require(_orderId > 0);
696         require(_price > 0);
697         require(_fee >= 0 && _fee <= FEE_PERMILLE.mul(_price).div(1000)); // Monetha fee cannot be greater than 1.5% of price
698 
699         orders[_orderId] = Order({
700             state: State.Created,
701             price: _price,
702             fee: _fee,
703             paymentAcceptor: _paymentAcceptor,
704             originAddress: _originAddress
705         });
706     }
707 
708     /**
709      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
710      *  This function require more gas, then fallback function.
711      *  @param _orderId Identifier of the order
712      */
713     function securePay(uint _orderId)
714         external payable whenNotPaused
715         atState(_orderId, State.Created) transition(_orderId, State.Paid)
716     {
717         Order storage order = orders[_orderId];
718 
719         require(msg.sender == order.paymentAcceptor);
720         require(msg.value == order.price);
721     }
722 
723     /**
724      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
725      *  @param _orderId Identifier of the order
726      *  @param _clientReputation Updated reputation of the client
727      *  @param _merchantReputation Updated reputation of the merchant
728      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
729      *  @param _cancelReason Order cancel reason
730      */
731     function cancelOrder(
732         uint _orderId,
733         uint32 _clientReputation,
734         uint32 _merchantReputation,
735         uint _dealHash,
736         string _cancelReason
737     )
738         external onlyMonetha whenNotPaused
739         atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
740     {
741         require(bytes(_cancelReason).length > 0);
742 
743         Order storage order = orders[_orderId];
744 
745         updateDealConditions(
746             _orderId,
747             _clientReputation,
748             _merchantReputation,
749             false,
750             _dealHash
751         );
752 
753         merchantHistory.recordDealCancelReason(
754             _orderId,
755             order.originAddress,
756             _clientReputation,
757             _merchantReputation,
758             _dealHash,
759             _cancelReason
760         );
761     }
762 
763     /**
764      *  refundPayment used in case order cannot be processed.
765      *  This function initiate process of funds refunding to the client.
766      *  @param _orderId Identifier of the order
767      *  @param _clientReputation Updated reputation of the client
768      *  @param _merchantReputation Updated reputation of the merchant
769      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
770      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
771      */
772     function refundPayment(
773         uint _orderId,
774         uint32 _clientReputation,
775         uint32 _merchantReputation,
776         uint _dealHash,
777         string _refundReason
778     )   
779         external onlyMonetha whenNotPaused
780         atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
781     {
782         require(bytes(_refundReason).length > 0);
783 
784         Order storage order = orders[_orderId];
785 
786         updateDealConditions(
787             _orderId,
788             _clientReputation,
789             _merchantReputation,
790             false,
791             _dealHash
792         );
793 
794         merchantHistory.recordDealRefundReason(
795             _orderId,
796             order.originAddress,
797             _clientReputation,
798             _merchantReputation,
799             _dealHash,
800             _refundReason
801         );
802     }
803 
804     /**
805      *  withdrawRefund performs fund transfer to the client's account.
806      *  @param _orderId Identifier of the order
807      */
808     function withdrawRefund(uint _orderId) 
809         external whenNotPaused
810         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded) 
811     {
812         Order storage order = orders[_orderId];
813         order.originAddress.transfer(order.price);
814     }
815 
816     /**
817      *  processPayment transfer funds to MonethaGateway and completes the order.
818      *  @param _orderId Identifier of the order
819      *  @param _clientReputation Updated reputation of the client
820      *  @param _merchantReputation Updated reputation of the merchant
821      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
822      */
823     function processPayment(
824         uint _orderId,
825         uint32 _clientReputation,
826         uint32 _merchantReputation,
827         uint _dealHash
828     )
829         external onlyMonetha whenNotPaused
830         atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
831     {
832         monethaGateway.acceptPayment.value(orders[_orderId].price)(merchantWallet, orders[_orderId].fee);
833 
834         updateDealConditions(
835             _orderId,
836             _clientReputation,
837             _merchantReputation,
838             true,
839             _dealHash
840         );
841     }
842 
843     /**
844      *  setMonethaGateway allows owner to change address of MonethaGateway.
845      *  @param _newGateway Address of new MonethaGateway contract
846      */
847     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
848         require(address(_newGateway) != 0x0);
849 
850         monethaGateway = _newGateway;
851     }
852 
853     /**
854      *  setMerchantWallet allows owner to change address of MerchantWallet.
855      *  @param _newWallet Address of new MerchantWallet contract
856      */
857     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
858         require(address(_newWallet) != 0x0);
859         require(_newWallet.merchantIdHash() == merchantIdHash);
860 
861         merchantWallet = _newWallet;
862     }
863 
864     /**
865      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
866      *  @param _merchantHistory Address of new MerchantDealsHistory contract
867      */
868     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
869         require(address(_merchantHistory) != 0x0);
870         require(_merchantHistory.merchantIdHash() == merchantIdHash);
871 
872         merchantHistory = _merchantHistory;
873     }
874 
875     /**
876      *  updateDealConditions record finalized deal and updates merchant reputation
877      *  in future: update Client reputation
878      *  @param _orderId Identifier of the order
879      *  @param _clientReputation Updated reputation of the client
880      *  @param _merchantReputation Updated reputation of the merchant
881      *  @param _isSuccess Identifies whether deal was successful or not
882      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
883      */
884     function updateDealConditions(
885         uint _orderId,
886         uint32 _clientReputation,
887         uint32 _merchantReputation,
888         bool _isSuccess,
889         uint _dealHash
890     ) internal
891     {
892         merchantHistory.recordDeal(
893             _orderId,
894             orders[_orderId].originAddress,
895             _clientReputation,
896             _merchantReputation,
897             _isSuccess,
898             _dealHash
899         );
900 
901         //update parties Reputation
902         merchantWallet.setCompositeReputation("total", _merchantReputation);
903     }
904 }