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
216 
217 /**
218 * @title ERC20 interface
219 * @dev see https://github.com/ethereum/EIPs/issues/20
220 */
221 contract ERC20 {
222     function totalSupply() public view returns (uint256);
223 
224     function decimals() public view returns(uint256);
225 
226     function balanceOf(address _who) public view returns (uint256);
227 
228     function allowance(address _owner, address _spender)
229         public view returns (uint256);
230 
231     function transfer(address _to, uint256 _value) public returns (bool);
232 
233     function approve(address _spender, uint256 _value)
234         public returns (bool);
235 
236     function transferFrom(address _from, address _to, uint256 _value)
237         public returns (bool);
238 
239     event Transfer(
240         address indexed from,
241         address indexed to,
242         uint256 value
243     );
244 
245     event Approval(
246         address indexed owner,
247         address indexed spender,
248         uint256 value
249     );
250 }
251 
252 // File: contracts/MonethaGateway.sol
253 
254 /**
255  *  @title MonethaGateway
256  *
257  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
258  */
259 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
260 
261     using SafeMath for uint256;
262     
263     string constant VERSION = "0.4";
264 
265     /**
266      *  Fee permille of Monetha fee.
267      *  1 permille (‰) = 0.1 percent (%)
268      *  15‰ = 1.5%
269      */
270     uint public constant FEE_PERMILLE = 15;
271     
272     /**
273      *  Address of Monetha Vault for fee collection
274      */
275     address public monethaVault;
276 
277     /**
278      *  Account for permissions managing
279      */
280     address public admin;
281 
282     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
283     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
284 
285     /**
286      *  @param _monethaVault Address of Monetha Vault
287      */
288     function MonethaGateway(address _monethaVault, address _admin) public {
289         require(_monethaVault != 0x0);
290         monethaVault = _monethaVault;
291         
292         setAdmin(_admin);
293     }
294     
295     /**
296      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
297      *      and collects Monetha fee.
298      *  @param _merchantWallet address of merchant's wallet for fund transfer
299      *  @param _monethaFee is a fee collected by Monetha
300      */
301     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
302         require(_merchantWallet != 0x0);
303         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
304         
305         uint merchantIncome = msg.value.sub(_monethaFee);
306 
307         _merchantWallet.transfer(merchantIncome);
308         monethaVault.transfer(_monethaFee);
309 
310         PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
311     }
312 
313     function acceptTokenPayment(address _merchantWallet, uint _monethaFee, address _tokenAddress, uint _value) external onlyMonetha whenNotPaused {
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
324         PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
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
343         MonethaAddressSet(_address, _isMonethaAddress);
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
356 // File: contracts/SafeDestructible.sol
357 
358 /**
359  * @title SafeDestructible
360  * Base contract that can be destroyed by owner.
361  * Can be destructed if there are no funds on contract balance.
362  */
363 contract SafeDestructible is Ownable {
364     function destroy() onlyOwner public {
365         require(this.balance == 0);
366         selfdestruct(owner);
367     }
368 }
369 
370 // File: contracts/MerchantWallet.sol
371 
372 /**
373  *  @title MerchantWallet
374  *  Serves as a public Merchant profile with merchant profile info,
375  *      payment settings and latest reputation value.
376  *  Also MerchantWallet accepts payments for orders.
377  */
378 
379 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
380 
381     string constant VERSION = "0.4";
382 
383     /// Address of merchant's account, that can withdraw from wallet
384     address public merchantAccount;
385 
386     /// Address of merchant's fund address.
387     address public merchantFundAddress;
388 
389     /// Unique Merchant identifier hash
390     bytes32 public merchantIdHash;
391 
392     /// profileMap stores general information about the merchant
393     mapping (string=>string) profileMap;
394 
395     /// paymentSettingsMap stores payment and order settings for the merchant
396     mapping (string=>string) paymentSettingsMap;
397 
398     /// compositeReputationMap stores composite reputation, that compraises from several metrics
399     mapping (string=>uint32) compositeReputationMap;
400 
401     /// number of last digits in compositeReputation for fractional part
402     uint8 public constant REPUTATION_DECIMALS = 4;
403 
404     /**
405      *  Restrict methods in such way, that they can be invoked only by merchant account.
406      */
407     modifier onlyMerchant() {
408         require(msg.sender == merchantAccount);
409         _;
410     }
411 
412     /**
413      *  Fund Address should always be Externally Owned Account and not a contract.
414      */
415     modifier isEOA(address _fundAddress) {
416         uint256 _codeLength;
417         assembly {_codeLength := extcodesize(_fundAddress)}
418         require(_codeLength == 0, "sorry humans only");
419         _;
420     }
421 
422     /**
423      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
424      */
425     modifier onlyMerchantOrMonetha() {
426         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
427         _;
428     }
429 
430     /**
431      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
432      *  @param _merchantId Merchant identifier
433      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
434      */
435     function MerchantWallet(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
436         require(_merchantAccount != 0x0);
437         require(bytes(_merchantId).length > 0);
438 
439         merchantAccount = _merchantAccount;
440         merchantIdHash = keccak256(_merchantId);
441 
442         merchantFundAddress = _fundAddress;
443     }
444 
445     /**
446      *  Accept payment from MonethaGateway
447      */
448     function () external payable {
449     }
450 
451     /**
452      *  @return profile info by string key
453      */
454     function profile(string key) external constant returns (string) {
455         return profileMap[key];
456     }
457 
458     /**
459      *  @return payment setting by string key
460      */
461     function paymentSettings(string key) external constant returns (string) {
462         return paymentSettingsMap[key];
463     }
464 
465     /**
466      *  @return composite reputation value by string key
467      */
468     function compositeReputation(string key) external constant returns (uint32) {
469         return compositeReputationMap[key];
470     }
471 
472     /**
473      *  Set profile info by string key
474      */
475     function setProfile(
476         string profileKey,
477         string profileValue,
478         string repKey,
479         uint32 repValue
480     ) external onlyOwner
481     {
482         profileMap[profileKey] = profileValue;
483 
484         if (bytes(repKey).length != 0) {
485             compositeReputationMap[repKey] = repValue;
486         }
487     }
488 
489     /**
490      *  Set payment setting by string key
491      */
492     function setPaymentSettings(string key, string value) external onlyOwner {
493         paymentSettingsMap[key] = value;
494     }
495 
496     /**
497      *  Set composite reputation value by string key
498      */
499     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
500         compositeReputationMap[key] = value;
501     }
502 
503     /**
504      *  Allows withdrawal of funds to beneficiary address
505      */
506     function doWithdrawal(address beneficiary, uint amount) private {
507         require(beneficiary != 0x0);
508         beneficiary.transfer(amount);
509     }
510 
511     /**
512      *  Allows merchant to withdraw funds to beneficiary address
513      */
514     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
515         doWithdrawal(beneficiary, amount);
516     }
517 
518     /**
519      *  Allows merchant to withdraw funds to it's own account
520      */
521     function withdraw(uint amount) external onlyMerchant {
522         withdrawTo(msg.sender, amount);
523     }
524 
525     /**
526      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
527      */
528     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
529         doWithdrawal(depositAccount, amount);
530     }
531 
532     /**
533      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
534      */
535     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
536         require (address(this).balance >= min_amount);
537         doWithdrawal(depositAccount, address(this).balance);
538     }
539 
540     /**
541      *  Allows merchant to change it's account address
542      */
543     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
544         merchantAccount = newAccount;
545     }
546 
547     /**
548      *  Allows merchant to change it's fund address.
549      */
550     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
551         merchantFundAddress = newFundAddress;
552     }
553 }
554 
555 // File: contracts/PrivatePaymentProcessor.sol
556 
557 contract PrivatePaymentProcessor is Pausable, Destructible, Contactable, Restricted {
558 
559     using SafeMath for uint256;
560 
561     string constant VERSION = "0.4";
562 
563     // Order paid event
564     event OrderPaidInEther(
565         uint indexed _orderId,
566         address indexed _originAddress,
567         uint _price,
568         uint _monethaFee
569     );
570 
571     event OrderPaidInToken(
572         uint indexed _orderId,
573         address indexed _originAddress,
574         address indexed _tokenAddress,
575         uint _price,
576         uint _monethaFee
577     );
578 
579     // Payments have been processed event
580     event PaymentsProcessed(
581         address indexed _merchantAddress,
582         uint _amount,
583         uint _fee
584     );
585 
586     // PaymentRefunding is an event when refunding initialized
587     event PaymentRefunding(
588         uint indexed _orderId,
589         address indexed _clientAddress,
590         uint _amount,
591         string _refundReason
592     );
593 
594     // PaymentWithdrawn event is fired when payment is withdrawn
595     event PaymentWithdrawn(
596         uint indexed _orderId,
597         address indexed _clientAddress,
598         uint amount
599     );
600 
601     /// MonethaGateway contract for payment processing
602     MonethaGateway public monethaGateway;
603 
604     /// Address of MerchantWallet, where merchant reputation and funds are stored
605     MerchantWallet public merchantWallet;
606 
607     /// Merchant identifier hash, that associates with the acceptor
608     bytes32 public merchantIdHash;
609 
610     enum WithdrawState {Null, Pending, Withdrawn}
611 
612     struct Withdraw {
613         WithdrawState state;
614         uint amount;
615         address clientAddress;
616     }
617 
618     mapping (uint=>Withdraw) public withdrawals;
619 
620     /**
621      *  Private Payment Processor sets Monetha Gateway and Merchant Wallet.
622      *  @param _merchantId Merchant of the acceptor
623      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
624      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
625      */
626     function PrivatePaymentProcessor(
627         string _merchantId,
628         MonethaGateway _monethaGateway,
629         MerchantWallet _merchantWallet
630     ) public
631     {
632         require(bytes(_merchantId).length > 0);
633 
634         merchantIdHash = keccak256(_merchantId);
635 
636         setMonethaGateway(_monethaGateway);
637         setMerchantWallet(_merchantWallet);
638     }
639 
640     /**
641      *  payForOrder is used by order wallet/client to pay for the order
642      *  @param _orderId Identifier of the order
643      *  @param _originAddress buyer address
644      *  @param _monethaFee is fee collected by Monetha
645      */
646     function payForOrder(
647         uint _orderId,
648         address _originAddress,
649         uint _monethaFee
650     ) external payable whenNotPaused
651     {
652         require(_orderId > 0);
653         require(_originAddress != 0x0);
654         require(msg.value > 0);
655 
656         address fundAddress;
657         fundAddress = merchantWallet.merchantFundAddress();
658 
659         if (fundAddress != address(0)) {
660             monethaGateway.acceptPayment.value(msg.value)(fundAddress, _monethaFee);
661         } else {
662             monethaGateway.acceptPayment.value(msg.value)(merchantWallet, _monethaFee);
663         }
664 
665         // log payment event
666         emit OrderPaidInEther(_orderId, _originAddress, msg.value, _monethaFee);
667     }
668 
669     /**
670      *  payForOrderInTokens is used by order wallet/client to pay for the order
671      *  This call requires that token's approve method has been called prior to this.
672      *  @param _orderId Identifier of the order
673      *  @param _originAddress buyer address
674      *  @param _monethaFee is fee collected by Monetha
675      *  @param _tokenAddress is tokens address
676      *  @param _orderValue is order amount
677      */
678     function payForOrderInTokens(
679         uint _orderId,
680         address _originAddress,
681         uint _monethaFee,
682         address _tokenAddress,
683         uint _orderValue
684     ) external whenNotPaused
685     {
686         require(_orderId > 0);
687         require(_originAddress != 0x0);
688         require(_orderValue > 0);
689         require(_tokenAddress != address(0));
690 
691         address fundAddress;
692         fundAddress = merchantWallet.merchantFundAddress();
693 
694         ERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
695         
696         ERC20(_tokenAddress).transfer(address(monethaGateway), _orderValue);
697 
698         if (fundAddress != address(0)) {
699             monethaGateway.acceptTokenPayment(fundAddress, _monethaFee, _tokenAddress, _orderValue);
700         } else {
701             monethaGateway.acceptTokenPayment(merchantWallet, _monethaFee, _tokenAddress, _orderValue);
702         }
703         
704         // log payment event
705         emit OrderPaidInToken(_orderId, _originAddress, _tokenAddress, _orderValue, _monethaFee);
706     }
707 
708     /**
709      *  refundPayment used in case order cannot be processed and funds need to be returned
710      *  This function initiate process of funds refunding to the client.
711      *  @param _orderId Identifier of the order
712      *  @param _clientAddress is an address of client
713      *  @param _refundReason Order refund reason
714      */
715     function refundPayment(
716         uint _orderId,
717         address _clientAddress,
718         string _refundReason
719     ) external payable onlyMonetha whenNotPaused
720     {
721         require(_orderId > 0);
722         require(_clientAddress != 0x0);
723         require(msg.value > 0);
724         require(WithdrawState.Null == withdrawals[_orderId].state);
725 
726         // create withdraw
727         withdrawals[_orderId] = Withdraw({
728             state: WithdrawState.Pending,
729             amount: msg.value,
730             clientAddress: _clientAddress
731             });
732 
733         // log refunding
734         PaymentRefunding(_orderId, _clientAddress, msg.value, _refundReason);
735     }
736 
737     /**
738      *  refundTokenPayment used in case order cannot be processed and tokens need to be returned
739      *  This call requires that token's approve method has been called prior to this.
740      *  This function initiate process of refunding tokens to the client.
741      *  @param _orderId Identifier of the order
742      *  @param _clientAddress is an address of client
743      *  @param _refundReason Order refund reason
744      *  @param _tokenAddress is tokens address
745      *  @param _orderValue is order amount
746      */
747     function refundTokenPayment(
748         uint _orderId,
749         address _clientAddress,
750         string _refundReason,
751         uint _orderValue,
752         address _tokenAddress
753     ) external onlyMonetha whenNotPaused
754     {
755         require(_orderId > 0);
756         require(_clientAddress != 0x0);
757         require(_orderValue > 0);
758         require(_tokenAddress != address(0));
759         require(WithdrawState.Null == withdrawals[_orderId].state);
760 
761         ERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
762         
763         // create withdraw
764         withdrawals[_orderId] = Withdraw({
765             state: WithdrawState.Pending,
766             amount: _orderValue,
767             clientAddress: _clientAddress
768             });
769 
770         // log refunding
771         PaymentRefunding(_orderId, _clientAddress, _orderValue, _refundReason);
772     }
773 
774     /**
775      *  withdrawRefund performs fund transfer to the client's account.
776      *  @param _orderId Identifier of the order
777      */
778     function withdrawRefund(uint _orderId)
779     external whenNotPaused
780     {
781         Withdraw storage withdraw = withdrawals[_orderId];
782         require(WithdrawState.Pending == withdraw.state);
783 
784         address clientAddress = withdraw.clientAddress;
785         uint amount = withdraw.amount;
786 
787         // changing withdraw state before transfer
788         withdraw.state = WithdrawState.Withdrawn;
789 
790         // transfer fund to clients account
791         clientAddress.transfer(amount);
792 
793         // log withdrawn
794         PaymentWithdrawn(_orderId, clientAddress, amount);
795     }
796 
797     /**
798      *  withdrawTokenRefund performs token transfer to the client's account.
799      *  @param _orderId Identifier of the order
800      *  @param _tokenAddress token address
801      */
802     function withdrawTokenRefund(uint _orderId, address _tokenAddress)
803     external whenNotPaused
804     {
805         require(_tokenAddress != address(0));
806 
807         Withdraw storage withdraw = withdrawals[_orderId];
808         require(WithdrawState.Pending == withdraw.state);
809 
810         address clientAddress = withdraw.clientAddress;
811         uint amount = withdraw.amount;
812 
813         // changing withdraw state before transfer
814         withdraw.state = WithdrawState.Withdrawn;
815 
816         // transfer fund to clients account
817         ERC20(_tokenAddress).transfer(clientAddress, amount);
818 
819         // log withdrawn
820         emit PaymentWithdrawn(_orderId, clientAddress, amount);
821     }
822 
823     /**
824      *  setMonethaGateway allows owner to change address of MonethaGateway.
825      *  @param _newGateway Address of new MonethaGateway contract
826      */
827     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
828         require(address(_newGateway) != 0x0);
829 
830         monethaGateway = _newGateway;
831     }
832 
833     /**
834      *  setMerchantWallet allows owner to change address of MerchantWallet.
835      *  @param _newWallet Address of new MerchantWallet contract
836      */
837     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
838         require(address(_newWallet) != 0x0);
839         require(_newWallet.merchantIdHash() == merchantIdHash);
840 
841         merchantWallet = _newWallet;
842     }
843 }