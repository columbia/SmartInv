1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60 
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65     /**
66     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67     * account.
68     */
69     function Ownable() public {
70         owner = msg.sender;
71     }
72 
73     /**
74     * @dev Throws if called by any account other than the owner.
75     */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82     * @dev Allows the current owner to transfer control of the contract to a newOwner.
83     * @param newOwner The address to transfer ownership to.
84     */
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0));
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89     }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
94 
95 /**
96  * @title Destructible
97  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
98  */
99 contract Destructible is Ownable {
100 
101     function Destructible() public payable { }
102 
103     /**
104     * @dev Transfers the current balance to the owner and terminates the contract.
105     */
106     function destroy() onlyOwner public {
107         selfdestruct(owner);
108     }
109 
110     function destroyAndSend(address _recipient) onlyOwner public {
111         selfdestruct(_recipient);
112     }
113 }
114 
115 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
116 
117 /**
118  * @title Pausable
119  * @dev Base contract which allows children to implement an emergency stop mechanism.
120  */
121 contract Pausable is Ownable {
122     event Pause();
123     event Unpause();
124 
125     bool public paused = false;
126 
127 
128     /**
129     * @dev Modifier to make a function callable only when the contract is not paused.
130     */
131     modifier whenNotPaused() {
132         require(!paused);
133         _;
134     }
135 
136     /**
137     * @dev Modifier to make a function callable only when the contract is paused.
138     */
139     modifier whenPaused() {
140         require(paused);
141         _;
142     }
143 
144     /**
145     * @dev called by the owner to pause, triggers stopped state
146     */
147     function pause() onlyOwner whenNotPaused public {
148         paused = true;
149         emit Pause();
150     }
151 
152     /**
153     * @dev called by the owner to unpause, returns to normal state
154     */
155     function unpause() onlyOwner whenPaused public {
156         paused = false;
157         emit Unpause();
158     }
159 }
160 
161 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
162 
163 /**
164  * @title Contactable token
165  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
166  * contact information.
167  */
168 contract Contactable is Ownable {
169 
170     string public contactInformation;
171 
172     /**
173     * @dev Allows the owner to set a string with their contact information.
174     * @param info The contact information to attach to the contract.
175     */
176     function setContactInformation(string info) onlyOwner public {
177         contactInformation = info;
178     }
179 }
180 
181 // File: contracts/Restricted.sol
182 
183 /** @title Restricted
184  *  Exposes onlyMonetha modifier
185  */
186 contract Restricted is Ownable {
187 
188     //MonethaAddress set event
189     event MonethaAddressSet(
190         address _address,
191         bool _isMonethaAddress
192     );
193 
194     mapping (address => bool) public isMonethaAddress;
195 
196     /**
197      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
198      */
199     modifier onlyMonetha() {
200         require(isMonethaAddress[msg.sender]);
201         _;
202     }
203 
204     /**
205      *  Allows owner to set new monetha address
206      */
207     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
208         isMonethaAddress[_address] = _isMonethaAddress;
209 
210         MonethaAddressSet(_address, _isMonethaAddress);
211     }
212 }
213 
214 // File: contracts/ERC20.sol
215 
216 /**
217 * @title ERC20 interface
218 * @dev see https://github.com/ethereum/EIPs/issues/20
219 */
220 contract ERC20 {
221     function totalSupply() public view returns (uint256);
222 
223     function decimals() public view returns(uint256);
224 
225     function balanceOf(address _who) public view returns (uint256);
226 
227     function allowance(address _owner, address _spender)
228         public view returns (uint256);
229 
230     function transfer(address _to, uint256 _value) public returns (bool);
231 
232     function approve(address _spender, uint256 _value)
233         public returns (bool);
234 
235     function transferFrom(address _from, address _to, uint256 _value)
236         public returns (bool);
237 
238     event Transfer(
239         address indexed from,
240         address indexed to,
241         uint256 value
242     );
243 
244     event Approval(
245         address indexed owner,
246         address indexed spender,
247         uint256 value
248     );
249 }
250 
251 // File: contracts/MonethaGateway.sol
252 
253 /**
254  *  @title MonethaGateway
255  *
256  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
257  */
258 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
259 
260     using SafeMath for uint256;
261     
262     string constant VERSION = "0.4";
263 
264     /**
265      *  Fee permille of Monetha fee.
266      *  1 permille (‰) = 0.1 percent (%)
267      *  15‰ = 1.5%
268      */
269     uint public constant FEE_PERMILLE = 15;
270     
271     /**
272      *  Address of Monetha Vault for fee collection
273      */
274     address public monethaVault;
275 
276     /**
277      *  Account for permissions managing
278      */
279     address public admin;
280 
281     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
282     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
283 
284     /**
285      *  @param _monethaVault Address of Monetha Vault
286      */
287     function MonethaGateway(address _monethaVault, address _admin) public {
288         require(_monethaVault != 0x0);
289         monethaVault = _monethaVault;
290         
291         setAdmin(_admin);
292     }
293     
294     /**
295      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
296      *      and collects Monetha fee.
297      *  @param _merchantWallet address of merchant's wallet for fund transfer
298      *  @param _monethaFee is a fee collected by Monetha
299      */
300     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
301         require(_merchantWallet != 0x0);
302         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
303         
304         uint merchantIncome = msg.value.sub(_monethaFee);
305 
306         _merchantWallet.transfer(merchantIncome);
307         monethaVault.transfer(_monethaFee);
308 
309         PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
310     }
311 
312     function acceptTokenPayment(address _merchantWallet, uint _monethaFee, address _tokenAddress, uint _value) external onlyMonetha whenNotPaused {
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
323         PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
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
342         MonethaAddressSet(_address, _isMonethaAddress);
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
463     /**
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
517     string constant VERSION = "0.4";
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
571     function MerchantWallet(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
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
616     ) external onlyOwner
617     {
618         profileMap[profileKey] = profileValue;
619 
620         if (bytes(repKey).length != 0) {
621             compositeReputationMap[repKey] = repValue;
622         }
623     }
624 
625     /**
626      *  Set payment setting by string key
627      */
628     function setPaymentSettings(string key, string value) external onlyOwner {
629         paymentSettingsMap[key] = value;
630     }
631 
632     /**
633      *  Set composite reputation value by string key
634      */
635     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
636         compositeReputationMap[key] = value;
637     }
638 
639     /**
640      *  Allows withdrawal of funds to beneficiary address
641      */
642     function doWithdrawal(address beneficiary, uint amount) private {
643         require(beneficiary != 0x0);
644         beneficiary.transfer(amount);
645     }
646 
647     /**
648      *  Allows merchant to withdraw funds to beneficiary address
649      */
650     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
651         doWithdrawal(beneficiary, amount);
652     }
653 
654     /**
655      *  Allows merchant to withdraw funds to it's own account
656      */
657     function withdraw(uint amount) external {
658         withdrawTo(msg.sender, amount);
659     }
660 
661     /**
662      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
663      */
664     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
665         doWithdrawal(depositAccount, amount);
666     }
667 
668     /**
669      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
670      */
671     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
672         require (address(this).balance >= min_amount);
673         doWithdrawal(depositAccount, address(this).balance);
674     }
675 
676     /**
677      *  Allows merchant to change it's account address
678      */
679     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
680         merchantAccount = newAccount;
681     }
682 
683     /**
684      *  Allows merchant to change it's fund address.
685      */
686     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
687         merchantFundAddress = newFundAddress;
688     }
689 }
690 
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
712     string constant VERSION = "0.4";
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
733     mapping (uint=>Order) public orders;
734 
735     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
736 
737     struct Order {
738         State state;
739         uint price;
740         uint fee;
741         address paymentAcceptor;
742         address originAddress;
743         address tokenAddress;
744     }
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
773     function PaymentProcessor(
774         string _merchantId,
775         MerchantDealsHistory _merchantHistory,
776         MonethaGateway _monethaGateway,
777         MerchantWallet _merchantWallet
778     ) public
779     {
780         require(bytes(_merchantId).length > 0);
781 
782         merchantIdHash = keccak256(_merchantId);
783 
784         setMonethaGateway(_monethaGateway);
785         setMerchantWallet(_merchantWallet);
786         setMerchantDealsHistory(_merchantHistory);
787     }
788 
789     /**
790      *  Assigns the acceptor to the order (when client initiates order).
791      *  @param _orderId Identifier of the order
792      *  @param _price Price of the order 
793      *  @param _paymentAcceptor order payment acceptor
794      *  @param _originAddress buyer address
795      *  @param _fee Monetha fee
796      */
797     function addOrder(
798         uint _orderId,
799         uint _price,
800         address _paymentAcceptor,
801         address _originAddress,
802         uint _fee,
803         address _tokenAddress
804     ) external onlyMonetha whenNotPaused atState(_orderId, State.Null)
805     {
806         require(_orderId > 0);
807         require(_price > 0);
808         require(_fee >= 0 && _fee <= FEE_PERMILLE.mul(_price).div(1000)); // Monetha fee cannot be greater than 1.5% of price
809 
810         orders[_orderId] = Order({
811             state: State.Created,
812             price: _price,
813             fee: _fee,
814             paymentAcceptor: _paymentAcceptor,
815             originAddress: _originAddress,
816             tokenAddress: _tokenAddress
817         });
818     }
819 
820     /**
821      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
822      *  This function require more gas, then fallback function.
823      *  @param _orderId Identifier of the order
824      */
825     function securePay(uint _orderId)
826         external payable whenNotPaused
827         atState(_orderId, State.Created) transition(_orderId, State.Paid)
828     {
829         Order storage order = orders[_orderId];
830 
831         require(msg.sender == order.paymentAcceptor);
832         require(msg.value == order.price);
833     }
834 
835     /**
836      *  secureTokenPay can be used by client if he wants to securely set client address for token refund together with token payment.
837      *  This call requires that token's approve method has been called prior to this.
838      *  @param _orderId Identifier of the order
839      */
840     function secureTokenPay(uint _orderId)
841         external whenNotPaused
842         atState(_orderId, State.Created) transition(_orderId, State.Paid)
843     {
844         Order storage order = orders[_orderId];
845         
846         require(msg.sender == order.paymentAcceptor);
847         require(order.tokenAddress != address(0));
848         
849         ERC20(order.tokenAddress).transferFrom(msg.sender, address(this), order.price);
850     }
851 
852     /**
853      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
854      *  @param _orderId Identifier of the order
855      *  @param _clientReputation Updated reputation of the client
856      *  @param _merchantReputation Updated reputation of the merchant
857      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
858      *  @param _cancelReason Order cancel reason
859      */
860     function cancelOrder(
861         uint _orderId,
862         uint32 _clientReputation,
863         uint32 _merchantReputation,
864         uint _dealHash,
865         string _cancelReason
866     )
867         external onlyMonetha whenNotPaused
868         atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
869     {
870         require(bytes(_cancelReason).length > 0);
871 
872         Order storage order = orders[_orderId];
873 
874         updateDealConditions(
875             _orderId,
876             _clientReputation,
877             _merchantReputation,
878             false,
879             _dealHash
880         );
881 
882         merchantHistory.recordDealCancelReason(
883             _orderId,
884             order.originAddress,
885             _clientReputation,
886             _merchantReputation,
887             _dealHash,
888             _cancelReason
889         );
890     }
891 
892     /**
893      *  refundPayment used in case order cannot be processed.
894      *  This function initiate process of funds refunding to the client.
895      *  @param _orderId Identifier of the order
896      *  @param _clientReputation Updated reputation of the client
897      *  @param _merchantReputation Updated reputation of the merchant
898      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
899      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
900      */
901     function refundPayment(
902         uint _orderId,
903         uint32 _clientReputation,
904         uint32 _merchantReputation,
905         uint _dealHash,
906         string _refundReason
907     )   
908         external onlyMonetha whenNotPaused
909         atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
910     {
911         require(bytes(_refundReason).length > 0);
912 
913         Order storage order = orders[_orderId];
914 
915         updateDealConditions(
916             _orderId,
917             _clientReputation,
918             _merchantReputation,
919             false,
920             _dealHash
921         );
922 
923         merchantHistory.recordDealRefundReason(
924             _orderId,
925             order.originAddress,
926             _clientReputation,
927             _merchantReputation,
928             _dealHash,
929             _refundReason
930         );
931     }
932 
933     /**
934      *  withdrawRefund performs fund transfer to the client's account.
935      *  @param _orderId Identifier of the order
936      */
937     function withdrawRefund(uint _orderId) 
938         external whenNotPaused
939         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded) 
940     {
941         Order storage order = orders[_orderId];
942         order.originAddress.transfer(order.price);
943     }
944 
945     /**
946      *  withdrawTokenRefund performs token transfer to the client's account.
947      *  @param _orderId Identifier of the order
948      */
949     function withdrawTokenRefund(uint _orderId)
950         external whenNotPaused
951         atState(_orderId, State.Refunding) transition(_orderId, State.Refunded)
952     {
953         require(orders[_orderId].tokenAddress != address(0));
954         
955         ERC20(orders[_orderId].tokenAddress).transfer(orders[_orderId].originAddress, orders[_orderId].price);
956     }
957 
958     /**
959      *  processPayment transfer funds/tokens to MonethaGateway and completes the order.
960      *  @param _orderId Identifier of the order
961      *  @param _clientReputation Updated reputation of the client
962      *  @param _merchantReputation Updated reputation of the merchant
963      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
964      */
965     function processPayment(
966         uint _orderId,
967         uint32 _clientReputation,
968         uint32 _merchantReputation,
969         uint _dealHash
970     )
971         external onlyMonetha whenNotPaused
972         atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
973     {
974         address fundAddress;
975         fundAddress = merchantWallet.merchantFundAddress();
976 
977         if (fundAddress != address(0) && orders[_orderId].tokenAddress != address(0)) {
978             ERC20(orders[_orderId].tokenAddress).transfer(address(monethaGateway), orders[_orderId].price);
979             monethaGateway.acceptTokenPayment(fundAddress, orders[_orderId].fee, orders[_orderId].tokenAddress, orders[_orderId].price);
980         } else if (fundAddress == address(0) && orders[_orderId].tokenAddress != address(0)) {
981             ERC20(orders[_orderId].tokenAddress).transfer(address(monethaGateway), orders[_orderId].price);
982             monethaGateway.acceptTokenPayment(merchantWallet, orders[_orderId].fee, orders[_orderId].tokenAddress, orders[_orderId].price);
983         } else if (fundAddress != address(0) && orders[_orderId].tokenAddress == address(0)) {
984             monethaGateway.acceptPayment.value(orders[_orderId].price)(fundAddress, orders[_orderId].fee);
985         } else if (fundAddress == address(0) && orders[_orderId].tokenAddress == address(0)) {
986             monethaGateway.acceptPayment.value(orders[_orderId].price)(merchantWallet, orders[_orderId].fee);
987         }
988         
989         updateDealConditions(
990             _orderId,
991             _clientReputation,
992             _merchantReputation,
993             true,
994             _dealHash
995         );
996     }
997 
998     /**
999      *  setMonethaGateway allows owner to change address of MonethaGateway.
1000      *  @param _newGateway Address of new MonethaGateway contract
1001      */
1002     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
1003         require(address(_newGateway) != 0x0);
1004 
1005         monethaGateway = _newGateway;
1006     }
1007 
1008     /**
1009      *  setMerchantWallet allows owner to change address of MerchantWallet.
1010      *  @param _newWallet Address of new MerchantWallet contract
1011      */
1012     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
1013         require(address(_newWallet) != 0x0);
1014         require(_newWallet.merchantIdHash() == merchantIdHash);
1015 
1016         merchantWallet = _newWallet;
1017     }
1018 
1019     /**
1020      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
1021      *  @param _merchantHistory Address of new MerchantDealsHistory contract
1022      */
1023     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
1024         require(address(_merchantHistory) != 0x0);
1025         require(_merchantHistory.merchantIdHash() == merchantIdHash);
1026 
1027         merchantHistory = _merchantHistory;
1028     }
1029 
1030     /**
1031      *  updateDealConditions record finalized deal and updates merchant reputation
1032      *  in future: update Client reputation
1033      *  @param _orderId Identifier of the order
1034      *  @param _clientReputation Updated reputation of the client
1035      *  @param _merchantReputation Updated reputation of the merchant
1036      *  @param _isSuccess Identifies whether deal was successful or not
1037      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1038      */
1039     function updateDealConditions(
1040         uint _orderId,
1041         uint32 _clientReputation,
1042         uint32 _merchantReputation,
1043         bool _isSuccess,
1044         uint _dealHash
1045     ) internal
1046     {
1047         merchantHistory.recordDeal(
1048             _orderId,
1049             orders[_orderId].originAddress,
1050             _clientReputation,
1051             _merchantReputation,
1052             _isSuccess,
1053             _dealHash
1054         );
1055 
1056         //update parties Reputation
1057         merchantWallet.setCompositeReputation("total", _merchantReputation);
1058     }
1059 }