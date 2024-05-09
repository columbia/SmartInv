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
215     function transfer(address _to, uint256 _value) public returns (bool);
216 
217     function approve(address _spender, uint256 _value)
218         public returns (bool);
219 
220     function transferFrom(address _from, address _to, uint256 _value)
221         public returns (bool);
222 
223     event Transfer(
224         address indexed from,
225         address indexed to,
226         uint256 value
227     );
228 
229     event Approval(
230         address indexed owner,
231         address indexed spender,
232         uint256 value
233     );
234 }
235 
236 // File: contracts/MonethaGateway.sol
237 
238 /**
239  *  @title MonethaGateway
240  *
241  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
242  */
243 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
244 
245     using SafeMath for uint256;
246     
247     string constant VERSION = "0.5";
248 
249     /**
250      *  Fee permille of Monetha fee.
251      *  1 permille (‰) = 0.1 percent (%)
252      *  15‰ = 1.5%
253      */
254     uint public constant FEE_PERMILLE = 15;
255     
256     /**
257      *  Address of Monetha Vault for fee collection
258      */
259     address public monethaVault;
260 
261     /**
262      *  Account for permissions managing
263      */
264     address public admin;
265 
266     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
267     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
268 
269     /**
270      *  @param _monethaVault Address of Monetha Vault
271      */
272     constructor(address _monethaVault, address _admin) public {
273         require(_monethaVault != 0x0);
274         monethaVault = _monethaVault;
275         
276         setAdmin(_admin);
277     }
278     
279     /**
280      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
281      *      and collects Monetha fee.
282      *  @param _merchantWallet address of merchant's wallet for fund transfer
283      *  @param _monethaFee is a fee collected by Monetha
284      */
285     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
286         require(_merchantWallet != 0x0);
287         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
288         
289         uint merchantIncome = msg.value.sub(_monethaFee);
290 
291         _merchantWallet.transfer(merchantIncome);
292         monethaVault.transfer(_monethaFee);
293 
294         emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
295     }
296 
297     /**
298      *  acceptTokenPayment accept token payment from PaymentAcceptor, forwards it to merchant's wallet
299      *      and collects Monetha fee.
300      *  @param _merchantWallet address of merchant's wallet for fund transfer
301      *  @param _monethaFee is a fee collected by Monetha
302      *  @param _tokenAddress is the token address
303      *  @param _value is the order value
304      */
305     function acceptTokenPayment(
306         address _merchantWallet,
307         uint _monethaFee,
308         address _tokenAddress,
309         uint _value
310     )
311         external onlyMonetha whenNotPaused
312     {
313         require(_merchantWallet != 0x0);
314 
315         // Monetha fee cannot be greater than 1.5% of payment
316         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(_value).div(1000));
317 
318         uint merchantIncome = _value.sub(_monethaFee);
319         
320         ERC20(_tokenAddress).transfer(_merchantWallet, merchantIncome);
321         ERC20(_tokenAddress).transfer(monethaVault, _monethaFee);
322         
323         emit PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
324     }
325 
326     /**
327      *  changeMonethaVault allows owner to change address of Monetha Vault.
328      *  @param newVault New address of Monetha Vault
329      */
330     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
331         monethaVault = newVault;
332     }
333 
334     /**
335      *  Allows other monetha account or contract to set new monetha address
336      */
337     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
338         require(msg.sender == admin || msg.sender == owner);
339 
340         isMonethaAddress[_address] = _isMonethaAddress;
341 
342         emit MonethaAddressSet(_address, _isMonethaAddress);
343     }
344 
345     /**
346      *  setAdmin allows owner to change address of admin.
347      *  @param _admin New address of admin
348      */
349     function setAdmin(address _admin) public onlyOwner {
350         require(_admin != 0x0);
351         admin = _admin;
352     }
353 }
354 
355 // File: contracts/MerchantDealsHistory.sol
356 
357 /**
358  *  @title MerchantDealsHistory
359  *  Contract stores hash of Deals conditions together with parties reputation for each deal
360  *  This history enables to see evolution of trust rating for both parties
361  */
362 contract MerchantDealsHistory is Contactable, Restricted {
363 
364     string constant VERSION = "0.3";
365 
366     ///  Merchant identifier hash
367     bytes32 public merchantIdHash;
368     
369     //Deal event
370     event DealCompleted(
371         uint orderId,
372         address clientAddress,
373         uint32 clientReputation,
374         uint32 merchantReputation,
375         bool successful,
376         uint dealHash
377     );
378 
379     //Deal cancellation event
380     event DealCancelationReason(
381         uint orderId,
382         address clientAddress,
383         uint32 clientReputation,
384         uint32 merchantReputation,
385         uint dealHash,
386         string cancelReason
387     );
388 
389     //Deal refund event
390     event DealRefundReason(
391         uint orderId,
392         address clientAddress,
393         uint32 clientReputation,
394         uint32 merchantReputation,
395         uint dealHash,
396         string refundReason
397     );
398 
399     /**
400      *  @param _merchantId Merchant of the acceptor
401      */
402     function MerchantDealsHistory(string _merchantId) public {
403         require(bytes(_merchantId).length > 0);
404         merchantIdHash = keccak256(_merchantId);
405     }
406 
407     /**
408      *  recordDeal creates an event of completed deal
409      *  @param _orderId Identifier of deal's order
410      *  @param _clientAddress Address of client's account
411      *  @param _clientReputation Updated reputation of the client
412      *  @param _merchantReputation Updated reputation of the merchant
413      *  @param _isSuccess Identifies whether deal was successful or not
414      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
415      */
416     function recordDeal(
417         uint _orderId,
418         address _clientAddress,
419         uint32 _clientReputation,
420         uint32 _merchantReputation,
421         bool _isSuccess,
422         uint _dealHash)
423         external onlyMonetha
424     {
425         DealCompleted(
426             _orderId,
427             _clientAddress,
428             _clientReputation,
429             _merchantReputation,
430             _isSuccess,
431             _dealHash
432         );
433     }
434 
435     /**
436      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
437      *  @param _orderId Identifier of deal's order
438      *  @param _clientAddress Address of client's account
439      *  @param _clientReputation Updated reputation of the client
440      *  @param _merchantReputation Updated reputation of the merchant
441      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
442      *  @param _cancelReason deal cancelation reason (text)
443      */
444     function recordDealCancelReason(
445         uint _orderId,
446         address _clientAddress,
447         uint32 _clientReputation,
448         uint32 _merchantReputation,
449         uint _dealHash,
450         string _cancelReason)
451         external onlyMonetha
452     {
453         DealCancelationReason(
454             _orderId,
455             _clientAddress,
456             _clientReputation,
457             _merchantReputation,
458             _dealHash,
459             _cancelReason
460         );
461     }
462 
463 /**
464      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
465      *  @param _orderId Identifier of deal's order
466      *  @param _clientAddress Address of client's account
467      *  @param _clientReputation Updated reputation of the client
468      *  @param _merchantReputation Updated reputation of the merchant
469      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
470      *  @param _refundReason deal refund reason (text)
471      */
472     function recordDealRefundReason(
473         uint _orderId,
474         address _clientAddress,
475         uint32 _clientReputation,
476         uint32 _merchantReputation,
477         uint _dealHash,
478         string _refundReason)
479         external onlyMonetha
480     {
481         DealRefundReason(
482             _orderId,
483             _clientAddress,
484             _clientReputation,
485             _merchantReputation,
486             _dealHash,
487             _refundReason
488         );
489     }
490 }
491 
492 // File: contracts/SafeDestructible.sol
493 
494 /**
495  * @title SafeDestructible
496  * Base contract that can be destroyed by owner.
497  * Can be destructed if there are no funds on contract balance.
498  */
499 contract SafeDestructible is Ownable {
500     function destroy() onlyOwner public {
501         require(this.balance == 0);
502         selfdestruct(owner);
503     }
504 }
505 
506 // File: contracts/MerchantWallet.sol
507 
508 /**
509  *  @title MerchantWallet
510  *  Serves as a public Merchant profile with merchant profile info,
511  *      payment settings and latest reputation value.
512  *  Also MerchantWallet accepts payments for orders.
513  */
514 
515 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
516 
517     string constant VERSION = "0.5";
518 
519     /// Address of merchant's account, that can withdraw from wallet
520     address public merchantAccount;
521 
522     /// Address of merchant's fund address.
523     address public merchantFundAddress;
524 
525     /// Unique Merchant identifier hash
526     bytes32 public merchantIdHash;
527 
528     /// profileMap stores general information about the merchant
529     mapping (string=>string) profileMap;
530 
531     /// paymentSettingsMap stores payment and order settings for the merchant
532     mapping (string=>string) paymentSettingsMap;
533 
534     /// compositeReputationMap stores composite reputation, that compraises from several metrics
535     mapping (string=>uint32) compositeReputationMap;
536 
537     /// number of last digits in compositeReputation for fractional part
538     uint8 public constant REPUTATION_DECIMALS = 4;
539 
540     /**
541      *  Restrict methods in such way, that they can be invoked only by merchant account.
542      */
543     modifier onlyMerchant() {
544         require(msg.sender == merchantAccount);
545         _;
546     }
547 
548     /**
549      *  Fund Address should always be Externally Owned Account and not a contract.
550      */
551     modifier isEOA(address _fundAddress) {
552         uint256 _codeLength;
553         assembly {_codeLength := extcodesize(_fundAddress)}
554         require(_codeLength == 0, "sorry humans only");
555         _;
556     }
557 
558     /**
559      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
560      */
561     modifier onlyMerchantOrMonetha() {
562         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
563         _;
564     }
565 
566     /**
567      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
568      *  @param _merchantId Merchant identifier
569      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
570      */
571     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
572         require(_merchantAccount != 0x0);
573         require(bytes(_merchantId).length > 0);
574 
575         merchantAccount = _merchantAccount;
576         merchantIdHash = keccak256(_merchantId);
577 
578         merchantFundAddress = _fundAddress;
579     }
580 
581     /**
582      *  Accept payment from MonethaGateway
583      */
584     function () external payable {
585     }
586 
587     /**
588      *  @return profile info by string key
589      */
590     function profile(string key) external constant returns (string) {
591         return profileMap[key];
592     }
593 
594     /**
595      *  @return payment setting by string key
596      */
597     function paymentSettings(string key) external constant returns (string) {
598         return paymentSettingsMap[key];
599     }
600 
601     /**
602      *  @return composite reputation value by string key
603      */
604     function compositeReputation(string key) external constant returns (uint32) {
605         return compositeReputationMap[key];
606     }
607 
608     /**
609      *  Set profile info by string key
610      */
611     function setProfile(
612         string profileKey,
613         string profileValue,
614         string repKey,
615         uint32 repValue
616     )
617         external onlyOwner
618     {
619         profileMap[profileKey] = profileValue;
620 
621         if (bytes(repKey).length != 0) {
622             compositeReputationMap[repKey] = repValue;
623         }
624     }
625 
626     /**
627      *  Set payment setting by string key
628      */
629     function setPaymentSettings(string key, string value) external onlyOwner {
630         paymentSettingsMap[key] = value;
631     }
632 
633     /**
634      *  Set composite reputation value by string key
635      */
636     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
637         compositeReputationMap[key] = value;
638     }
639 
640     /**
641      *  Allows withdrawal of funds to beneficiary address
642      */
643     function doWithdrawal(address beneficiary, uint amount) private {
644         require(beneficiary != 0x0);
645         beneficiary.transfer(amount);
646     }
647 
648     /**
649      *  Allows merchant to withdraw funds to beneficiary address
650      */
651     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
652         doWithdrawal(beneficiary, amount);
653     }
654 
655     /**
656      *  Allows merchant to withdraw funds to it's own account
657      */
658     function withdraw(uint amount) external onlyMerchant {
659         withdrawTo(msg.sender, amount);
660     }
661 
662     /**
663      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
664      */
665     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
666         doWithdrawal(depositAccount, amount);
667     }
668 
669     /**
670      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
671      */
672     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
673         require (address(this).balance >= min_amount);
674         doWithdrawal(depositAccount, address(this).balance);
675     }
676 
677     /**
678      *  Allows merchant to change it's account address
679      */
680     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
681         merchantAccount = newAccount;
682     }
683 
684     /**
685      *  Allows merchant to change it's fund address.
686      */
687     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
688         merchantFundAddress = newFundAddress;
689     }
690 }
691 
692 // File: contracts/PaymentProcessor.sol
693 
694 /**
695  *  @title PaymentProcessor
696  *  Each Merchant has one PaymentProcessor that ensure payment and order processing with Trust and Reputation
697  *
698  *  Payment Processor State Transitions:
699  *  Null -(addOrder) -> Created
700  *  Created -(securePay) -> Paid
701  *  Created -(cancelOrder) -> Cancelled
702  *  Paid -(refundPayment) -> Refunding
703  *  Paid -(processPayment) -> Finalized
704  *  Refunding -(withdrawRefund) -> Refunded
705  */
706 
707 
708 contract PaymentProcessor is Pausable, Destructible, Contactable, Restricted {
709 
710     using SafeMath for uint256;
711 
712     string constant VERSION = "0.5";
713 
714     /**
715      *  Fee permille of Monetha fee.
716      *  1 permille = 0.1 %
717      *  15 permille = 1.5%
718      */
719     uint public constant FEE_PERMILLE = 15;
720 
721     /// MonethaGateway contract for payment processing
722     MonethaGateway public monethaGateway;
723 
724     /// MerchantDealsHistory contract of acceptor's merchant
725     MerchantDealsHistory public merchantHistory;
726 
727     /// Address of MerchantWallet, where merchant reputation and funds are stored
728     MerchantWallet public merchantWallet;
729 
730     /// Merchant identifier hash, that associates with the acceptor
731     bytes32 public merchantIdHash;
732 
733     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
734 
735     struct Order {
736         State state;
737         uint price;
738         uint fee;
739         address paymentAcceptor;
740         address originAddress;
741         address tokenAddress;
742     }
743 
744     mapping (uint=>Order) public orders;
745 
746     /**
747      *  Asserts current state.
748      *  @param _state Expected state
749      *  @param _orderId Order Id
750      */
751     modifier atState(uint _orderId, State _state) {
752         require(_state == orders[_orderId].state);
753         _;
754     }
755 
756     /**
757      *  Performs a transition after function execution.
758      *  @param _state Next state
759      *  @param _orderId Order Id
760      */
761     modifier transition(uint _orderId, State _state) {
762         _;
763         orders[_orderId].state = _state;
764     }
765 
766     /**
767      *  payment Processor sets Monetha Gateway
768      *  @param _merchantId Merchant of the acceptor
769      *  @param _merchantHistory Address of MerchantDealsHistory contract of acceptor's merchant
770      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
771      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
772      */
773     constructor(
774         string _merchantId,
775         MerchantDealsHistory _merchantHistory,
776         MonethaGateway _monethaGateway,
777         MerchantWallet _merchantWallet
778     )
779         public
780     {
781         require(bytes(_merchantId).length > 0);
782 
783         merchantIdHash = keccak256(_merchantId);
784 
785         setMonethaGateway(_monethaGateway);
786         setMerchantWallet(_merchantWallet);
787         setMerchantDealsHistory(_merchantHistory);
788     }
789 
790     /**
791      *  Assigns the acceptor to the order (when client initiates order).
792      *  @param _orderId Identifier of the order
793      *  @param _price Price of the order 
794      *  @param _paymentAcceptor order payment acceptor
795      *  @param _originAddress buyer address
796      *  @param _fee Monetha fee
797      */
798     function addOrder(
799         uint _orderId,
800         uint _price,
801         address _paymentAcceptor,
802         address _originAddress,
803         uint _fee,
804         address _tokenAddress
805     ) external onlyMonetha whenNotPaused atState(_orderId, State.Null)
806     {
807         require(_orderId > 0);
808         require(_price > 0);
809         require(_fee >= 0 && _fee <= FEE_PERMILLE.mul(_price).div(1000)); // Monetha fee cannot be greater than 1.5% of price
810 
811         orders[_orderId] = Order({
812             state: State.Created,
813             price: _price,
814             fee: _fee,
815             paymentAcceptor: _paymentAcceptor,
816             originAddress: _originAddress,
817             tokenAddress: _tokenAddress
818         });
819     }
820 
821     /**
822      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
823      *  This function require more gas, then fallback function.
824      *  @param _orderId Identifier of the order
825      */
826     function securePay(uint _orderId)
827         external payable whenNotPaused
828         atState(_orderId, State.Created) transition(_orderId, State.Paid)
829     {
830         Order storage order = orders[_orderId];
831 
832         require(msg.sender == order.paymentAcceptor);
833         require(msg.value == order.price);
834     }
835 
836     /**
837      *  secureTokenPay can be used by client if he wants to securely set client address for token refund together with token payment.
838      *  This call requires that token's approve method has been called prior to this.
839      *  @param _orderId Identifier of the order
840      */
841     function secureTokenPay(uint _orderId)
842         external whenNotPaused
843         atState(_orderId, State.Created) transition(_orderId, State.Paid)
844     {
845         Order storage order = orders[_orderId];
846 
847         require(msg.sender == order.paymentAcceptor);
848         require(order.tokenAddress != address(0));
849         
850         ERC20(order.tokenAddress).transferFrom(msg.sender, address(this), order.price);
851     }
852 
853     /**
854      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
855      *  @param _orderId Identifier of the order
856      *  @param _clientReputation Updated reputation of the client
857      *  @param _merchantReputation Updated reputation of the merchant
858      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
859      *  @param _cancelReason Order cancel reason
860      */
861     function cancelOrder(
862         uint _orderId,
863         uint32 _clientReputation,
864         uint32 _merchantReputation,
865         uint _dealHash,
866         string _cancelReason
867     )
868         external onlyMonetha whenNotPaused
869         atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
870     {
871         require(bytes(_cancelReason).length > 0);
872 
873         Order storage order = orders[_orderId];
874 
875         updateDealConditions(
876             _orderId,
877             _clientReputation,
878             _merchantReputation,
879             false,
880             _dealHash
881         );
882 
883         merchantHistory.recordDealCancelReason(
884             _orderId,
885             order.originAddress,
886             _clientReputation,
887             _merchantReputation,
888             _dealHash,
889             _cancelReason
890         );
891     }
892 
893     /**
894      *  refundPayment used in case order cannot be processed.
895      *  This function initiate process of funds refunding to the client.
896      *  @param _orderId Identifier of the order
897      *  @param _clientReputation Updated reputation of the client
898      *  @param _merchantReputation Updated reputation of the merchant
899      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
900      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
901      */
902     function refundPayment(
903         uint _orderId,
904         uint32 _clientReputation,
905         uint32 _merchantReputation,
906         uint _dealHash,
907         string _refundReason
908     )   
909         external onlyMonetha whenNotPaused
910         atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
911     {
912         require(bytes(_refundReason).length > 0);
913 
914         Order storage order = orders[_orderId];
915 
916         updateDealConditions(
917             _orderId,
918             _clientReputation,
919             _merchantReputation,
920             false,
921             _dealHash
922         );
923 
924         merchantHistory.recordDealRefundReason(
925             _orderId,
926             order.originAddress,
927             _clientReputation,
928             _merchantReputation,
929             _dealHash,
930             _refundReason
931         );
932     }
933 
934     /**
935      *  withdrawRefund performs fund transfer to the client's account.
936      *  @param _orderId Identifier of the order
937      */
938     function withdrawRefund(uint _orderId) 
939         external whenNotPaused
940         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded) 
941     {
942         Order storage order = orders[_orderId];
943         order.originAddress.transfer(order.price);
944     }
945 
946     /**
947      *  withdrawTokenRefund performs token transfer to the client's account.
948      *  @param _orderId Identifier of the order
949      */
950     function withdrawTokenRefund(uint _orderId)
951         external whenNotPaused
952         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded)
953     {
954         require(orders[_orderId].tokenAddress != address(0));
955         
956         ERC20(orders[_orderId].tokenAddress).transfer(orders[_orderId].originAddress, orders[_orderId].price);
957     }
958 
959     /**
960      *  processPayment transfer funds/tokens to MonethaGateway and completes the order.
961      *  @param _orderId Identifier of the order
962      *  @param _clientReputation Updated reputation of the client
963      *  @param _merchantReputation Updated reputation of the merchant
964      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
965      */
966     function processPayment(
967         uint _orderId,
968         uint32 _clientReputation,
969         uint32 _merchantReputation,
970         uint _dealHash
971     )
972         external onlyMonetha whenNotPaused
973         atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
974     {
975         address fundAddress;
976         fundAddress = merchantWallet.merchantFundAddress();
977 
978         if (orders[_orderId].tokenAddress != address(0)) {
979             if (fundAddress != address(0)) {
980                 ERC20(orders[_orderId].tokenAddress).transfer(address(monethaGateway), orders[_orderId].price);
981                 monethaGateway.acceptTokenPayment(fundAddress, orders[_orderId].fee, orders[_orderId].tokenAddress, orders[_orderId].price);
982             } else {
983                 ERC20(orders[_orderId].tokenAddress).transfer(address(monethaGateway), orders[_orderId].price);
984                 monethaGateway.acceptTokenPayment(merchantWallet, orders[_orderId].fee, orders[_orderId].tokenAddress, orders[_orderId].price);
985             }
986         } else {
987             if (fundAddress != address(0)) {
988                 monethaGateway.acceptPayment.value(orders[_orderId].price)(fundAddress, orders[_orderId].fee);
989             } else {
990                 monethaGateway.acceptPayment.value(orders[_orderId].price)(merchantWallet, orders[_orderId].fee);
991             }
992         }
993         
994         updateDealConditions(
995             _orderId,
996             _clientReputation,
997             _merchantReputation,
998             true,
999             _dealHash
1000         );
1001     }
1002 
1003     /**
1004      *  setMonethaGateway allows owner to change address of MonethaGateway.
1005      *  @param _newGateway Address of new MonethaGateway contract
1006      */
1007     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
1008         require(address(_newGateway) != 0x0);
1009 
1010         monethaGateway = _newGateway;
1011     }
1012 
1013     /**
1014      *  setMerchantWallet allows owner to change address of MerchantWallet.
1015      *  @param _newWallet Address of new MerchantWallet contract
1016      */
1017     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
1018         require(address(_newWallet) != 0x0);
1019         require(_newWallet.merchantIdHash() == merchantIdHash);
1020 
1021         merchantWallet = _newWallet;
1022     }
1023 
1024     /**
1025      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
1026      *  @param _merchantHistory Address of new MerchantDealsHistory contract
1027      */
1028     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
1029         require(address(_merchantHistory) != 0x0);
1030         require(_merchantHistory.merchantIdHash() == merchantIdHash);
1031 
1032         merchantHistory = _merchantHistory;
1033     }
1034 
1035     /**
1036      *  updateDealConditions record finalized deal and updates merchant reputation
1037      *  in future: update Client reputation
1038      *  @param _orderId Identifier of the order
1039      *  @param _clientReputation Updated reputation of the client
1040      *  @param _merchantReputation Updated reputation of the merchant
1041      *  @param _isSuccess Identifies whether deal was successful or not
1042      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1043      */
1044     function updateDealConditions(
1045         uint _orderId,
1046         uint32 _clientReputation,
1047         uint32 _merchantReputation,
1048         bool _isSuccess,
1049         uint _dealHash
1050     )
1051         internal
1052     {
1053         merchantHistory.recordDeal(
1054             _orderId,
1055             orders[_orderId].originAddress,
1056             _clientReputation,
1057             _merchantReputation,
1058             _isSuccess,
1059             _dealHash
1060         );
1061 
1062         //update parties Reputation
1063         merchantWallet.setCompositeReputation("total", _merchantReputation);
1064     }
1065 }