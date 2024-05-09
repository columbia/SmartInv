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
404      *  Allows merchant to withdraw funds to beneficiary address
405      */
406     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
407         require(beneficiary != 0x0);
408         beneficiary.transfer(amount);
409     }
410 
411     /**
412      *  Allows merchant to withdraw funds to it's own account
413      */
414     function withdraw(uint amount) external {
415         withdrawTo(msg.sender, amount);
416     }
417 
418     /**
419      *  Allows merchant to change it's account address
420      */
421     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
422         merchantAccount = newAccount;
423     }
424 }
425 
426 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
427 
428 /**
429  * @title Destructible
430  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
431  */
432 contract Destructible is Ownable {
433 
434   function Destructible() payable { }
435 
436   /**
437    * @dev Transfers the current balance to the owner and terminates the contract.
438    */
439   function destroy() onlyOwner public {
440     selfdestruct(owner);
441   }
442 
443   function destroyAndSend(address _recipient) onlyOwner public {
444     selfdestruct(_recipient);
445   }
446 }
447 
448 // File: zeppelin-solidity/contracts/math/SafeMath.sol
449 
450 /**
451  * @title SafeMath
452  * @dev Math operations with safety checks that throw on error
453  */
454 library SafeMath {
455   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
456     uint256 c = a * b;
457     assert(a == 0 || c / a == b);
458     return c;
459   }
460 
461   function div(uint256 a, uint256 b) internal constant returns (uint256) {
462     // assert(b > 0); // Solidity automatically throws when dividing by 0
463     uint256 c = a / b;
464     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
465     return c;
466   }
467 
468   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
469     assert(b <= a);
470     return a - b;
471   }
472 
473   function add(uint256 a, uint256 b) internal constant returns (uint256) {
474     uint256 c = a + b;
475     assert(c >= a);
476     return c;
477   }
478 }
479 
480 // File: contracts/MonethaGateway.sol
481 
482 /**
483  *  @title MonethaGateway
484  *
485  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
486  */
487 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
488 
489     using SafeMath for uint256;
490     
491     string constant VERSION = "0.4";
492 
493     /**
494      *  Fee permille of Monetha fee.
495      *  1 permille (‰) = 0.1 percent (%)
496      *  15‰ = 1.5%
497      */
498     uint public constant FEE_PERMILLE = 15;
499     
500     /**
501      *  Address of Monetha Vault for fee collection
502      */
503     address public monethaVault;
504 
505     /**
506      *  Account for permissions managing
507      */
508     address public admin;
509 
510     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
511 
512     /**
513      *  @param _monethaVault Address of Monetha Vault
514      */
515     function MonethaGateway(address _monethaVault, address _admin) public {
516         require(_monethaVault != 0x0);
517         monethaVault = _monethaVault;
518         
519         setAdmin(_admin);
520     }
521     
522     /**
523      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
524      *      and collects Monetha fee.
525      *  @param _merchantWallet address of merchant's wallet for fund transfer
526      *  @param _monethaFee is a fee collected by Monetha
527      */
528     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
529         require(_merchantWallet != 0x0);
530         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
531 
532         uint merchantIncome = msg.value.sub(_monethaFee);
533 
534         _merchantWallet.transfer(merchantIncome);
535         monethaVault.transfer(_monethaFee);
536 
537         PaymentProcessed(_merchantWallet, merchantIncome, _monethaFee);
538     }
539 
540     /**
541      *  changeMonethaVault allows owner to change address of Monetha Vault.
542      *  @param newVault New address of Monetha Vault
543      */
544     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
545         monethaVault = newVault;
546     }
547 
548     /**
549      *  Allows other monetha account or contract to set new monetha address
550      */
551     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
552         require(msg.sender == admin || msg.sender == owner);
553 
554         isMonethaAddress[_address] = _isMonethaAddress;
555 
556         MonethaAddressSet(_address, _isMonethaAddress);
557     }
558 
559     /**
560      *  setAdmin allows owner to change address of admin.
561      *  @param _admin New address of admin
562      */
563     function setAdmin(address _admin) public onlyOwner {
564         require(_admin != 0x0);
565         admin = _admin;
566     }
567 }
568 
569 // File: contracts/PaymentProcessor.sol
570 
571 /**
572  *  @title PaymentProcessor
573  *  Each Merchant has one PaymentProcessor that ensure payment and order processing with Trust and Reputation
574  *
575  *  Payment Processor State Transitions:
576  *  Null -(addOrder) -> Created
577  *  Created -(securePay) -> Paid
578  *  Created -(cancelOrder) -> Cancelled
579  *  Paid -(refundPayment) -> Refunding
580  *  Paid -(processPayment) -> Finalized
581  *  Refunding -(withdrawRefund) -> Refunded
582  */
583 
584 
585 contract PaymentProcessor is Pausable, Destructible, Contactable, Restricted {
586 
587     using SafeMath for uint256;
588 
589     string constant VERSION = "0.4";
590 
591     /**
592      *  Fee permille of Monetha fee.
593      *  1 permille = 0.1 %
594      *  15 permille = 1.5%
595      */
596     uint public constant FEE_PERMILLE = 15;
597 
598     /// MonethaGateway contract for payment processing
599     MonethaGateway public monethaGateway;
600 
601     /// MerchantDealsHistory contract of acceptor's merchant
602     MerchantDealsHistory public merchantHistory;
603 
604     /// Address of MerchantWallet, where merchant reputation and funds are stored
605     MerchantWallet public merchantWallet;
606 
607     /// Merchant identifier hash, that associates with the acceptor
608     bytes32 public merchantIdHash;
609 
610     mapping (uint=>Order) public orders;
611 
612     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
613 
614     struct Order {
615         State state;
616         uint price;
617         uint fee;
618         address paymentAcceptor;
619         address originAddress;
620     }
621 
622     /**
623      *  Asserts current state.
624      *  @param _state Expected state
625      *  @param _orderId Order Id
626      */
627     modifier atState(uint _orderId, State _state) {
628         require(_state == orders[_orderId].state);
629         _;
630     }
631 
632     /**
633      *  Performs a transition after function execution.
634      *  @param _state Next state
635      *  @param _orderId Order Id
636      */
637     modifier transition(uint _orderId, State _state) {
638         _;
639         orders[_orderId].state = _state;
640     }
641 
642     /**
643      *  payment Processor sets Monetha Gateway
644      *  @param _merchantId Merchant of the acceptor
645      *  @param _merchantHistory Address of MerchantDealsHistory contract of acceptor's merchant
646      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
647      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
648      */
649     function PaymentProcessor(
650         string _merchantId,
651         MerchantDealsHistory _merchantHistory,
652         MonethaGateway _monethaGateway,
653         MerchantWallet _merchantWallet
654     ) public
655     {
656         require(bytes(_merchantId).length > 0);
657 
658         merchantIdHash = keccak256(_merchantId);
659 
660         setMonethaGateway(_monethaGateway);
661         setMerchantWallet(_merchantWallet);
662         setMerchantDealsHistory(_merchantHistory);
663     }
664 
665     /**
666      *  Assigns the acceptor to the order (when client initiates order).
667      *  @param _orderId Identifier of the order
668      *  @param _price Price of the order 
669      *  @param _paymentAcceptor order payment acceptor
670      *  @param _originAddress buyer address
671      *  @param _fee Monetha fee
672      */
673     function addOrder(
674         uint _orderId,
675         uint _price,
676         address _paymentAcceptor,
677         address _originAddress,
678         uint _fee
679     ) external onlyMonetha whenNotPaused atState(_orderId, State.Null)
680     {
681         require(_orderId > 0);
682         require(_price > 0);
683         require(_fee >= 0 && _fee <= FEE_PERMILLE.mul(_price).div(1000)); // Monetha fee cannot be greater than 1.5% of price
684 
685         orders[_orderId] = Order({
686             state: State.Created,
687             price: _price,
688             fee: _fee,
689             paymentAcceptor: _paymentAcceptor,
690             originAddress: _originAddress
691         });
692     }
693 
694     /**
695      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
696      *  This function require more gas, then fallback function.
697      *  @param _orderId Identifier of the order
698      */
699     function securePay(uint _orderId)
700         external payable whenNotPaused
701         atState(_orderId, State.Created) transition(_orderId, State.Paid)
702     {
703         Order storage order = orders[_orderId];
704 
705         require(msg.sender == order.paymentAcceptor);
706         require(msg.value == order.price);
707     }
708 
709     /**
710      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
711      *  @param _orderId Identifier of the order
712      *  @param _clientReputation Updated reputation of the client
713      *  @param _merchantReputation Updated reputation of the merchant
714      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
715      *  @param _cancelReason Order cancel reason
716      */
717     function cancelOrder(
718         uint _orderId,
719         uint32 _clientReputation,
720         uint32 _merchantReputation,
721         uint _dealHash,
722         string _cancelReason
723     )
724         external onlyMonetha whenNotPaused
725         atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
726     {
727         require(bytes(_cancelReason).length > 0);
728 
729         Order storage order = orders[_orderId];
730 
731         updateDealConditions(
732             _orderId,
733             _clientReputation,
734             _merchantReputation,
735             false,
736             _dealHash
737         );
738 
739         merchantHistory.recordDealCancelReason(
740             _orderId,
741             order.originAddress,
742             _clientReputation,
743             _merchantReputation,
744             _dealHash,
745             _cancelReason
746         );
747     }
748 
749     /**
750      *  refundPayment used in case order cannot be processed.
751      *  This function initiate process of funds refunding to the client.
752      *  @param _orderId Identifier of the order
753      *  @param _clientReputation Updated reputation of the client
754      *  @param _merchantReputation Updated reputation of the merchant
755      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
756      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
757      */
758     function refundPayment(
759         uint _orderId,
760         uint32 _clientReputation,
761         uint32 _merchantReputation,
762         uint _dealHash,
763         string _refundReason
764     )   
765         external onlyMonetha whenNotPaused
766         atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
767     {
768         require(bytes(_refundReason).length > 0);
769 
770         Order storage order = orders[_orderId];
771 
772         updateDealConditions(
773             _orderId,
774             _clientReputation,
775             _merchantReputation,
776             false,
777             _dealHash
778         );
779 
780         merchantHistory.recordDealRefundReason(
781             _orderId,
782             order.originAddress,
783             _clientReputation,
784             _merchantReputation,
785             _dealHash,
786             _refundReason
787         );
788     }
789 
790     /**
791      *  withdrawRefund performs fund transfer to the client's account.
792      *  @param _orderId Identifier of the order
793      */
794     function withdrawRefund(uint _orderId) 
795         external whenNotPaused
796         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded) 
797     {
798         Order storage order = orders[_orderId];
799         order.originAddress.transfer(order.price);
800     }
801 
802     /**
803      *  processPayment transfer funds to MonethaGateway and completes the order.
804      *  @param _orderId Identifier of the order
805      *  @param _clientReputation Updated reputation of the client
806      *  @param _merchantReputation Updated reputation of the merchant
807      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
808      */
809     function processPayment(
810         uint _orderId,
811         uint32 _clientReputation,
812         uint32 _merchantReputation,
813         uint _dealHash
814     )
815         external onlyMonetha whenNotPaused
816         atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
817     {
818         monethaGateway.acceptPayment.value(orders[_orderId].price)(merchantWallet, orders[_orderId].fee);
819 
820         updateDealConditions(
821             _orderId,
822             _clientReputation,
823             _merchantReputation,
824             true,
825             _dealHash
826         );
827     }
828 
829     /**
830      *  setMonethaGateway allows owner to change address of MonethaGateway.
831      *  @param _newGateway Address of new MonethaGateway contract
832      */
833     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
834         require(address(_newGateway) != 0x0);
835 
836         monethaGateway = _newGateway;
837     }
838 
839     /**
840      *  setMerchantWallet allows owner to change address of MerchantWallet.
841      *  @param _newWallet Address of new MerchantWallet contract
842      */
843     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
844         require(address(_newWallet) != 0x0);
845         require(_newWallet.merchantIdHash() == merchantIdHash);
846 
847         merchantWallet = _newWallet;
848     }
849 
850     /**
851      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
852      *  @param _merchantHistory Address of new MerchantDealsHistory contract
853      */
854     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
855         require(address(_merchantHistory) != 0x0);
856         require(_merchantHistory.merchantIdHash() == merchantIdHash);
857 
858         merchantHistory = _merchantHistory;
859     }
860 
861     /**
862      *  updateDealConditions record finalized deal and updates merchant reputation
863      *  in future: update Client reputation
864      *  @param _orderId Identifier of the order
865      *  @param _clientReputation Updated reputation of the client
866      *  @param _merchantReputation Updated reputation of the merchant
867      *  @param _isSuccess Identifies whether deal was successful or not
868      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
869      */
870     function updateDealConditions(
871         uint _orderId,
872         uint32 _clientReputation,
873         uint32 _merchantReputation,
874         bool _isSuccess,
875         uint _dealHash
876     ) internal
877     {
878         merchantHistory.recordDeal(
879             _orderId,
880             orders[_orderId].originAddress,
881             _clientReputation,
882             _merchantReputation,
883             _isSuccess,
884             _dealHash
885         );
886 
887         //update parties Reputation
888         merchantWallet.setCompositeReputation("total", _merchantReputation);
889     }
890 }