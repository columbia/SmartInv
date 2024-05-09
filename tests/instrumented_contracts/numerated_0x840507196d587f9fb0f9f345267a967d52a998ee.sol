1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
80 
81 /**
82  * @title Pausable
83  * @dev Base contract which allows children to implement an emergency stop mechanism.
84  */
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
126 
127 /**
128  * @title Destructible
129  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
130  */
131 contract Destructible is Ownable {
132 
133   function Destructible() payable { }
134 
135   /**
136    * @dev Transfers the current balance to the owner and terminates the contract.
137    */
138   function destroy() onlyOwner public {
139     selfdestruct(owner);
140   }
141 
142   function destroyAndSend(address _recipient) onlyOwner public {
143     selfdestruct(_recipient);
144   }
145 }
146 
147 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
148 
149 /**
150  * @title Contactable token
151  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
152  * contact information.
153  */
154 contract Contactable is Ownable{
155 
156     string public contactInformation;
157 
158     /**
159      * @dev Allows the owner to set a string with their contact information.
160      * @param info The contact information to attach to the contract.
161      */
162     function setContactInformation(string info) onlyOwner public {
163          contactInformation = info;
164      }
165 }
166 
167 // File: contracts/Restricted.sol
168 
169 /** @title Restricted
170  *  Exposes onlyMonetha modifier
171  */
172 contract Restricted is Ownable {
173 
174     //MonethaAddress set event
175     event MonethaAddressSet(
176         address _address,
177         bool _isMonethaAddress
178     );
179 
180     mapping (address => bool) public isMonethaAddress;
181 
182     /**
183      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
184      */
185     modifier onlyMonetha() {
186         require(isMonethaAddress[msg.sender]);
187         _;
188     }
189 
190     /**
191      *  Allows owner to set new monetha address
192      */
193     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
194         isMonethaAddress[_address] = _isMonethaAddress;
195 
196         MonethaAddressSet(_address, _isMonethaAddress);
197     }
198 }
199 
200 // File: contracts/ERC20.sol
201 
202 /**
203 * @title ERC20 interface
204 */
205 contract ERC20 {
206     function totalSupply() public view returns (uint256);
207 
208     function decimals() public view returns(uint256);
209 
210     function balanceOf(address _who) public view returns (uint256);
211 
212     function allowance(address _owner, address _spender)
213         public view returns (uint256);
214         
215     // Return type not defined intentionally since not all ERC20 tokens return proper result type
216     function transfer(address _to, uint256 _value) public;
217 
218     function approve(address _spender, uint256 _value)
219         public returns (bool);
220 
221     function transferFrom(address _from, address _to, uint256 _value)
222         public returns (bool);
223 
224     event Transfer(
225         address indexed from,
226         address indexed to,
227         uint256 value
228     );
229 
230     event Approval(
231         address indexed owner,
232         address indexed spender,
233         uint256 value
234     );
235 }
236 
237 // File: contracts/MonethaGateway.sol
238 
239 /**
240  *  @title MonethaGateway
241  *
242  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
243  */
244 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
245 
246     using SafeMath for uint256;
247     
248     string constant VERSION = "0.5";
249 
250     /**
251      *  Fee permille of Monetha fee.
252      *  1 permille (‰) = 0.1 percent (%)
253      *  15‰ = 1.5%
254      */
255     uint public constant FEE_PERMILLE = 15;
256     
257     /**
258      *  Address of Monetha Vault for fee collection
259      */
260     address public monethaVault;
261 
262     /**
263      *  Account for permissions managing
264      */
265     address public admin;
266 
267     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
268     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
269 
270     /**
271      *  @param _monethaVault Address of Monetha Vault
272      */
273     constructor(address _monethaVault, address _admin) public {
274         require(_monethaVault != 0x0);
275         monethaVault = _monethaVault;
276         
277         setAdmin(_admin);
278     }
279     
280     /**
281      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
282      *      and collects Monetha fee.
283      *  @param _merchantWallet address of merchant's wallet for fund transfer
284      *  @param _monethaFee is a fee collected by Monetha
285      */
286     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
287         require(_merchantWallet != 0x0);
288         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
289         
290         uint merchantIncome = msg.value.sub(_monethaFee);
291 
292         _merchantWallet.transfer(merchantIncome);
293         monethaVault.transfer(_monethaFee);
294 
295         emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
296     }
297 
298     /**
299      *  acceptTokenPayment accept token payment from PaymentAcceptor, forwards it to merchant's wallet
300      *      and collects Monetha fee.
301      *  @param _merchantWallet address of merchant's wallet for fund transfer
302      *  @param _monethaFee is a fee collected by Monetha
303      *  @param _tokenAddress is the token address
304      *  @param _value is the order value
305      */
306     function acceptTokenPayment(
307         address _merchantWallet,
308         uint _monethaFee,
309         address _tokenAddress,
310         uint _value
311     )
312         external onlyMonetha whenNotPaused
313     {
314         require(_merchantWallet != 0x0);
315 
316         // Monetha fee cannot be greater than 1.5% of payment
317         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(_value).div(1000));
318 
319         uint merchantIncome = _value.sub(_monethaFee);
320         
321         ERC20(_tokenAddress).transfer(_merchantWallet, merchantIncome);
322         ERC20(_tokenAddress).transfer(monethaVault, _monethaFee);
323         
324         emit PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
325     }
326 
327     /**
328      *  changeMonethaVault allows owner to change address of Monetha Vault.
329      *  @param newVault New address of Monetha Vault
330      */
331     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
332         monethaVault = newVault;
333     }
334 
335     /**
336      *  Allows other monetha account or contract to set new monetha address
337      */
338     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
339         require(msg.sender == admin || msg.sender == owner);
340 
341         isMonethaAddress[_address] = _isMonethaAddress;
342 
343         emit MonethaAddressSet(_address, _isMonethaAddress);
344     }
345 
346     /**
347      *  setAdmin allows owner to change address of admin.
348      *  @param _admin New address of admin
349      */
350     function setAdmin(address _admin) public onlyOwner {
351         require(_admin != 0x0);
352         admin = _admin;
353     }
354 }
355 
356 // File: contracts/MerchantDealsHistory.sol
357 
358 /**
359  *  @title MerchantDealsHistory
360  *  Contract stores hash of Deals conditions together with parties reputation for each deal
361  *  This history enables to see evolution of trust rating for both parties
362  */
363 contract MerchantDealsHistory is Contactable, Restricted {
364 
365     string constant VERSION = "0.3";
366 
367     ///  Merchant identifier hash
368     bytes32 public merchantIdHash;
369     
370     //Deal event
371     event DealCompleted(
372         uint orderId,
373         address clientAddress,
374         uint32 clientReputation,
375         uint32 merchantReputation,
376         bool successful,
377         uint dealHash
378     );
379 
380     //Deal cancellation event
381     event DealCancelationReason(
382         uint orderId,
383         address clientAddress,
384         uint32 clientReputation,
385         uint32 merchantReputation,
386         uint dealHash,
387         string cancelReason
388     );
389 
390     //Deal refund event
391     event DealRefundReason(
392         uint orderId,
393         address clientAddress,
394         uint32 clientReputation,
395         uint32 merchantReputation,
396         uint dealHash,
397         string refundReason
398     );
399 
400     /**
401      *  @param _merchantId Merchant of the acceptor
402      */
403     function MerchantDealsHistory(string _merchantId) public {
404         require(bytes(_merchantId).length > 0);
405         merchantIdHash = keccak256(_merchantId);
406     }
407 
408     /**
409      *  recordDeal creates an event of completed deal
410      *  @param _orderId Identifier of deal's order
411      *  @param _clientAddress Address of client's account
412      *  @param _clientReputation Updated reputation of the client
413      *  @param _merchantReputation Updated reputation of the merchant
414      *  @param _isSuccess Identifies whether deal was successful or not
415      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
416      */
417     function recordDeal(
418         uint _orderId,
419         address _clientAddress,
420         uint32 _clientReputation,
421         uint32 _merchantReputation,
422         bool _isSuccess,
423         uint _dealHash)
424         external onlyMonetha
425     {
426         DealCompleted(
427             _orderId,
428             _clientAddress,
429             _clientReputation,
430             _merchantReputation,
431             _isSuccess,
432             _dealHash
433         );
434     }
435 
436     /**
437      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
438      *  @param _orderId Identifier of deal's order
439      *  @param _clientAddress Address of client's account
440      *  @param _clientReputation Updated reputation of the client
441      *  @param _merchantReputation Updated reputation of the merchant
442      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
443      *  @param _cancelReason deal cancelation reason (text)
444      */
445     function recordDealCancelReason(
446         uint _orderId,
447         address _clientAddress,
448         uint32 _clientReputation,
449         uint32 _merchantReputation,
450         uint _dealHash,
451         string _cancelReason)
452         external onlyMonetha
453     {
454         DealCancelationReason(
455             _orderId,
456             _clientAddress,
457             _clientReputation,
458             _merchantReputation,
459             _dealHash,
460             _cancelReason
461         );
462     }
463 
464 /**
465      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
466      *  @param _orderId Identifier of deal's order
467      *  @param _clientAddress Address of client's account
468      *  @param _clientReputation Updated reputation of the client
469      *  @param _merchantReputation Updated reputation of the merchant
470      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
471      *  @param _refundReason deal refund reason (text)
472      */
473     function recordDealRefundReason(
474         uint _orderId,
475         address _clientAddress,
476         uint32 _clientReputation,
477         uint32 _merchantReputation,
478         uint _dealHash,
479         string _refundReason)
480         external onlyMonetha
481     {
482         DealRefundReason(
483             _orderId,
484             _clientAddress,
485             _clientReputation,
486             _merchantReputation,
487             _dealHash,
488             _refundReason
489         );
490     }
491 }
492 
493 // File: contracts/SafeDestructible.sol
494 
495 /**
496  * @title SafeDestructible
497  * Base contract that can be destroyed by owner.
498  * Can be destructed if there are no funds on contract balance.
499  */
500 contract SafeDestructible is Ownable {
501     function destroy() onlyOwner public {
502         require(this.balance == 0);
503         selfdestruct(owner);
504     }
505 }
506 
507 // File: contracts/MerchantWallet.sol
508 
509 /**
510  *  @title MerchantWallet
511  *  Serves as a public Merchant profile with merchant profile info,
512  *      payment settings and latest reputation value.
513  *  Also MerchantWallet accepts payments for orders.
514  */
515 
516 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
517 
518     string constant VERSION = "0.5";
519 
520     /// Address of merchant's account, that can withdraw from wallet
521     address public merchantAccount;
522 
523     /// Address of merchant's fund address.
524     address public merchantFundAddress;
525 
526     /// Unique Merchant identifier hash
527     bytes32 public merchantIdHash;
528 
529     /// profileMap stores general information about the merchant
530     mapping (string=>string) profileMap;
531 
532     /// paymentSettingsMap stores payment and order settings for the merchant
533     mapping (string=>string) paymentSettingsMap;
534 
535     /// compositeReputationMap stores composite reputation, that compraises from several metrics
536     mapping (string=>uint32) compositeReputationMap;
537 
538     /// number of last digits in compositeReputation for fractional part
539     uint8 public constant REPUTATION_DECIMALS = 4;
540 
541     /**
542      *  Restrict methods in such way, that they can be invoked only by merchant account.
543      */
544     modifier onlyMerchant() {
545         require(msg.sender == merchantAccount);
546         _;
547     }
548 
549     /**
550      *  Fund Address should always be Externally Owned Account and not a contract.
551      */
552     modifier isEOA(address _fundAddress) {
553         uint256 _codeLength;
554         assembly {_codeLength := extcodesize(_fundAddress)}
555         require(_codeLength == 0, "sorry humans only");
556         _;
557     }
558 
559     /**
560      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
561      */
562     modifier onlyMerchantOrMonetha() {
563         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
564         _;
565     }
566 
567     /**
568      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
569      *  @param _merchantId Merchant identifier
570      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
571      */
572     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
573         require(_merchantAccount != 0x0);
574         require(bytes(_merchantId).length > 0);
575 
576         merchantAccount = _merchantAccount;
577         merchantIdHash = keccak256(_merchantId);
578 
579         merchantFundAddress = _fundAddress;
580     }
581 
582     /**
583      *  Accept payment from MonethaGateway
584      */
585     function () external payable {
586     }
587 
588     /**
589      *  @return profile info by string key
590      */
591     function profile(string key) external constant returns (string) {
592         return profileMap[key];
593     }
594 
595     /**
596      *  @return payment setting by string key
597      */
598     function paymentSettings(string key) external constant returns (string) {
599         return paymentSettingsMap[key];
600     }
601 
602     /**
603      *  @return composite reputation value by string key
604      */
605     function compositeReputation(string key) external constant returns (uint32) {
606         return compositeReputationMap[key];
607     }
608 
609     /**
610      *  Set profile info by string key
611      */
612     function setProfile(
613         string profileKey,
614         string profileValue,
615         string repKey,
616         uint32 repValue
617     )
618         external onlyOwner
619     {
620         profileMap[profileKey] = profileValue;
621 
622         if (bytes(repKey).length != 0) {
623             compositeReputationMap[repKey] = repValue;
624         }
625     }
626 
627     /**
628      *  Set payment setting by string key
629      */
630     function setPaymentSettings(string key, string value) external onlyOwner {
631         paymentSettingsMap[key] = value;
632     }
633 
634     /**
635      *  Set composite reputation value by string key
636      */
637     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
638         compositeReputationMap[key] = value;
639     }
640 
641     /**
642      *  Allows withdrawal of funds to beneficiary address
643      */
644     function doWithdrawal(address beneficiary, uint amount) private {
645         require(beneficiary != 0x0);
646         beneficiary.transfer(amount);
647     }
648 
649     /**
650      *  Allows merchant to withdraw funds to beneficiary address
651      */
652     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
653         doWithdrawal(beneficiary, amount);
654     }
655 
656     /**
657      *  Allows merchant to withdraw funds to it's own account
658      */
659     function withdraw(uint amount) external onlyMerchant {
660         withdrawTo(msg.sender, amount);
661     }
662 
663     /**
664      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
665      */
666     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
667         doWithdrawal(depositAccount, amount);
668     }
669 
670     /**
671      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
672      */
673     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
674         require (address(this).balance >= min_amount);
675         doWithdrawal(depositAccount, address(this).balance);
676     }
677 
678     /**
679      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
680      */
681     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
682         require(_tokenAddress != address(0));
683         
684         uint balance = ERC20(_tokenAddress).balanceOf(address(this));
685         
686         require(balance >= _minAmount);
687         
688         ERC20(_tokenAddress).transfer(_depositAccount, balance);
689     }
690 
691     /**
692      *  Allows merchant to change it's account address
693      */
694     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
695         merchantAccount = newAccount;
696     }
697 
698     /**
699      *  Allows merchant to change it's fund address.
700      */
701     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
702         merchantFundAddress = newFundAddress;
703     }
704 }
705 
706 // File: contracts/PaymentProcessor.sol
707 
708 /**
709  *  @title PaymentProcessor
710  *  Each Merchant has one PaymentProcessor that ensure payment and order processing with Trust and Reputation
711  *
712  *  Payment Processor State Transitions:
713  *  Null -(addOrder) -> Created
714  *  Created -(securePay) -> Paid
715  *  Created -(cancelOrder) -> Cancelled
716  *  Paid -(refundPayment) -> Refunding
717  *  Paid -(processPayment) -> Finalized
718  *  Refunding -(withdrawRefund) -> Refunded
719  */
720 
721 
722 contract PaymentProcessor is Pausable, Destructible, Contactable, Restricted {
723 
724     using SafeMath for uint256;
725 
726     string constant VERSION = "0.6";
727 
728     /**
729      *  Fee permille of Monetha fee.
730      *  1 permille = 0.1 %
731      *  15 permille = 1.5%
732      */
733     uint public constant FEE_PERMILLE = 15;
734 
735     /// MonethaGateway contract for payment processing
736     MonethaGateway public monethaGateway;
737 
738     /// MerchantDealsHistory contract of acceptor's merchant
739     MerchantDealsHistory public merchantHistory;
740 
741     /// Address of MerchantWallet, where merchant reputation and funds are stored
742     MerchantWallet public merchantWallet;
743 
744     /// Merchant identifier hash, that associates with the acceptor
745     bytes32 public merchantIdHash;
746 
747     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
748 
749     struct Order {
750         State state;
751         uint price;
752         uint fee;
753         address paymentAcceptor;
754         address originAddress;
755         address tokenAddress;
756     }
757 
758     mapping (uint=>Order) public orders;
759 
760     /**
761      *  Asserts current state.
762      *  @param _state Expected state
763      *  @param _orderId Order Id
764      */
765     modifier atState(uint _orderId, State _state) {
766         require(_state == orders[_orderId].state);
767         _;
768     }
769 
770     /**
771      *  Performs a transition after function execution.
772      *  @param _state Next state
773      *  @param _orderId Order Id
774      */
775     modifier transition(uint _orderId, State _state) {
776         _;
777         orders[_orderId].state = _state;
778     }
779 
780     /**
781      *  payment Processor sets Monetha Gateway
782      *  @param _merchantId Merchant of the acceptor
783      *  @param _merchantHistory Address of MerchantDealsHistory contract of acceptor's merchant
784      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
785      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
786      */
787     constructor(
788         string _merchantId,
789         MerchantDealsHistory _merchantHistory,
790         MonethaGateway _monethaGateway,
791         MerchantWallet _merchantWallet
792     )
793         public
794     {
795         require(bytes(_merchantId).length > 0);
796 
797         merchantIdHash = keccak256(_merchantId);
798 
799         setMonethaGateway(_monethaGateway);
800         setMerchantWallet(_merchantWallet);
801         setMerchantDealsHistory(_merchantHistory);
802     }
803 
804     /**
805      *  Assigns the acceptor to the order (when client initiates order).
806      *  @param _orderId Identifier of the order
807      *  @param _price Price of the order 
808      *  @param _paymentAcceptor order payment acceptor
809      *  @param _originAddress buyer address
810      *  @param _fee Monetha fee
811      */
812     function addOrder(
813         uint _orderId,
814         uint _price,
815         address _paymentAcceptor,
816         address _originAddress,
817         uint _fee,
818         address _tokenAddress
819     ) external whenNotPaused atState(_orderId, State.Null)
820     {
821         require(_orderId > 0);
822         require(_price > 0);
823         require(_fee >= 0 && _fee <= FEE_PERMILLE.mul(_price).div(1000)); // Monetha fee cannot be greater than 1.5% of price
824         require(_paymentAcceptor != address(0));
825         require(_originAddress != address(0));
826         require(orders[_orderId].price == 0  && orders[_orderId].fee == 0);
827 
828         orders[_orderId] = Order({
829             state: State.Created,
830             price: _price,
831             fee: _fee,
832             paymentAcceptor: _paymentAcceptor,
833             originAddress: _originAddress,
834             tokenAddress: _tokenAddress
835         });
836     }
837 
838     /**
839      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
840      *  This function require more gas, then fallback function.
841      *  @param _orderId Identifier of the order
842      */
843     function securePay(uint _orderId)
844         external payable whenNotPaused
845         atState(_orderId, State.Created) transition(_orderId, State.Paid)
846     {
847         Order storage order = orders[_orderId];
848 
849         require(msg.sender == order.paymentAcceptor);
850         require(msg.value == order.price);
851     }
852 
853     /**
854      *  secureTokenPay can be used by client if he wants to securely set client address for token refund together with token payment.
855      *  This call requires that token's approve method has been called prior to this.
856      *  @param _orderId Identifier of the order
857      */
858     function secureTokenPay(uint _orderId)
859         external whenNotPaused
860         atState(_orderId, State.Created) transition(_orderId, State.Paid)
861     {
862         Order storage order = orders[_orderId];
863 
864         require(msg.sender == order.paymentAcceptor);
865         require(order.tokenAddress != address(0));
866         
867         ERC20(order.tokenAddress).transferFrom(msg.sender, address(this), order.price);
868     }
869 
870     /**
871      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
872      *  @param _orderId Identifier of the order
873      *  @param _clientReputation Updated reputation of the client
874      *  @param _merchantReputation Updated reputation of the merchant
875      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
876      *  @param _cancelReason Order cancel reason
877      */
878     function cancelOrder(
879         uint _orderId,
880         uint32 _clientReputation,
881         uint32 _merchantReputation,
882         uint _dealHash,
883         string _cancelReason
884     )
885         external onlyMonetha whenNotPaused
886         atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
887     {
888         require(bytes(_cancelReason).length > 0);
889 
890         Order storage order = orders[_orderId];
891 
892         updateDealConditions(
893             _orderId,
894             _clientReputation,
895             _merchantReputation,
896             false,
897             _dealHash
898         );
899 
900         merchantHistory.recordDealCancelReason(
901             _orderId,
902             order.originAddress,
903             _clientReputation,
904             _merchantReputation,
905             _dealHash,
906             _cancelReason
907         );
908     }
909 
910     /**
911      *  refundPayment used in case order cannot be processed.
912      *  This function initiate process of funds refunding to the client.
913      *  @param _orderId Identifier of the order
914      *  @param _clientReputation Updated reputation of the client
915      *  @param _merchantReputation Updated reputation of the merchant
916      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
917      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
918      */
919     function refundPayment(
920         uint _orderId,
921         uint32 _clientReputation,
922         uint32 _merchantReputation,
923         uint _dealHash,
924         string _refundReason
925     )   
926         external onlyMonetha whenNotPaused
927         atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
928     {
929         require(bytes(_refundReason).length > 0);
930 
931         Order storage order = orders[_orderId];
932 
933         updateDealConditions(
934             _orderId,
935             _clientReputation,
936             _merchantReputation,
937             false,
938             _dealHash
939         );
940 
941         merchantHistory.recordDealRefundReason(
942             _orderId,
943             order.originAddress,
944             _clientReputation,
945             _merchantReputation,
946             _dealHash,
947             _refundReason
948         );
949     }
950 
951     /**
952      *  withdrawRefund performs fund transfer to the client's account.
953      *  @param _orderId Identifier of the order
954      */
955     function withdrawRefund(uint _orderId) 
956         external whenNotPaused
957         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded) 
958     {
959         Order storage order = orders[_orderId];
960         order.originAddress.transfer(order.price);
961     }
962 
963     /**
964      *  withdrawTokenRefund performs token transfer to the client's account.
965      *  @param _orderId Identifier of the order
966      */
967     function withdrawTokenRefund(uint _orderId)
968         external whenNotPaused
969         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded)
970     {
971         require(orders[_orderId].tokenAddress != address(0));
972         
973         ERC20(orders[_orderId].tokenAddress).transfer(orders[_orderId].originAddress, orders[_orderId].price);
974     }
975 
976     /**
977      *  processPayment transfer funds/tokens to MonethaGateway and completes the order.
978      *  @param _orderId Identifier of the order
979      *  @param _clientReputation Updated reputation of the client
980      *  @param _merchantReputation Updated reputation of the merchant
981      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
982      */
983     function processPayment(
984         uint _orderId,
985         uint32 _clientReputation,
986         uint32 _merchantReputation,
987         uint _dealHash
988     )
989         external onlyMonetha whenNotPaused
990         atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
991     {
992         address fundAddress;
993         fundAddress = merchantWallet.merchantFundAddress();
994 
995         if (orders[_orderId].tokenAddress != address(0)) {
996             if (fundAddress != address(0)) {
997                 ERC20(orders[_orderId].tokenAddress).transfer(address(monethaGateway), orders[_orderId].price);
998                 monethaGateway.acceptTokenPayment(fundAddress, orders[_orderId].fee, orders[_orderId].tokenAddress, orders[_orderId].price);
999             } else {
1000                 ERC20(orders[_orderId].tokenAddress).transfer(address(monethaGateway), orders[_orderId].price);
1001                 monethaGateway.acceptTokenPayment(merchantWallet, orders[_orderId].fee, orders[_orderId].tokenAddress, orders[_orderId].price);
1002             }
1003         } else {
1004             if (fundAddress != address(0)) {
1005                 monethaGateway.acceptPayment.value(orders[_orderId].price)(fundAddress, orders[_orderId].fee);
1006             } else {
1007                 monethaGateway.acceptPayment.value(orders[_orderId].price)(merchantWallet, orders[_orderId].fee);
1008             }
1009         }
1010         
1011         updateDealConditions(
1012             _orderId,
1013             _clientReputation,
1014             _merchantReputation,
1015             true,
1016             _dealHash
1017         );
1018     }
1019 
1020     /**
1021      *  setMonethaGateway allows owner to change address of MonethaGateway.
1022      *  @param _newGateway Address of new MonethaGateway contract
1023      */
1024     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
1025         require(address(_newGateway) != 0x0);
1026 
1027         monethaGateway = _newGateway;
1028     }
1029 
1030     /**
1031      *  setMerchantWallet allows owner to change address of MerchantWallet.
1032      *  @param _newWallet Address of new MerchantWallet contract
1033      */
1034     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
1035         require(address(_newWallet) != 0x0);
1036         require(_newWallet.merchantIdHash() == merchantIdHash);
1037 
1038         merchantWallet = _newWallet;
1039     }
1040 
1041     /**
1042      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
1043      *  @param _merchantHistory Address of new MerchantDealsHistory contract
1044      */
1045     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
1046         require(address(_merchantHistory) != 0x0);
1047         require(_merchantHistory.merchantIdHash() == merchantIdHash);
1048 
1049         merchantHistory = _merchantHistory;
1050     }
1051 
1052     /**
1053      *  updateDealConditions record finalized deal and updates merchant reputation
1054      *  in future: update Client reputation
1055      *  @param _orderId Identifier of the order
1056      *  @param _clientReputation Updated reputation of the client
1057      *  @param _merchantReputation Updated reputation of the merchant
1058      *  @param _isSuccess Identifies whether deal was successful or not
1059      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1060      */
1061     function updateDealConditions(
1062         uint _orderId,
1063         uint32 _clientReputation,
1064         uint32 _merchantReputation,
1065         bool _isSuccess,
1066         uint _dealHash
1067     )
1068         internal
1069     {
1070         merchantHistory.recordDeal(
1071             _orderId,
1072             orders[_orderId].originAddress,
1073             _clientReputation,
1074             _merchantReputation,
1075             _isSuccess,
1076             _dealHash
1077         );
1078 
1079         //update parties Reputation
1080         merchantWallet.setCompositeReputation("total", _merchantReputation);
1081     }
1082 }