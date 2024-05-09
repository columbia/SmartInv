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
381     string constant VERSION = "0.5";
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
435     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
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
480     )
481         external onlyOwner
482     {
483         profileMap[profileKey] = profileValue;
484 
485         if (bytes(repKey).length != 0) {
486             compositeReputationMap[repKey] = repValue;
487         }
488     }
489 
490     /**
491      *  Set payment setting by string key
492      */
493     function setPaymentSettings(string key, string value) external onlyOwner {
494         paymentSettingsMap[key] = value;
495     }
496 
497     /**
498      *  Set composite reputation value by string key
499      */
500     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
501         compositeReputationMap[key] = value;
502     }
503 
504     /**
505      *  Allows withdrawal of funds to beneficiary address
506      */
507     function doWithdrawal(address beneficiary, uint amount) private {
508         require(beneficiary != 0x0);
509         beneficiary.transfer(amount);
510     }
511 
512     /**
513      *  Allows merchant to withdraw funds to beneficiary address
514      */
515     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
516         doWithdrawal(beneficiary, amount);
517     }
518 
519     /**
520      *  Allows merchant to withdraw funds to it's own account
521      */
522     function withdraw(uint amount) external onlyMerchant {
523         withdrawTo(msg.sender, amount);
524     }
525 
526     /**
527      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
528      */
529     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
530         doWithdrawal(depositAccount, amount);
531     }
532 
533     /**
534      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
535      */
536     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
537         require (address(this).balance >= min_amount);
538         doWithdrawal(depositAccount, address(this).balance);
539     }
540 
541     /**
542      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
543      */
544     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
545         require(_tokenAddress != address(0));
546         
547         uint balance = ERC20(_tokenAddress).balanceOf(address(this));
548         
549         require(balance >= _minAmount);
550         
551         ERC20(_tokenAddress).transfer(_depositAccount, balance);
552     }
553 
554     /**
555      *  Allows merchant to change it's account address
556      */
557     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
558         merchantAccount = newAccount;
559     }
560 
561     /**
562      *  Allows merchant to change it's fund address.
563      */
564     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
565         merchantFundAddress = newFundAddress;
566     }
567 }
568 
569 // File: contracts/PrivatePaymentProcessor.sol
570 
571 contract PrivatePaymentProcessor is Pausable, Destructible, Contactable, Restricted {
572 
573     using SafeMath for uint256;
574 
575     string constant VERSION = "0.5";
576 
577     // Order paid event
578     event OrderPaidInEther(
579         uint indexed _orderId,
580         address indexed _originAddress,
581         uint _price,
582         uint _monethaFee
583     );
584 
585     event OrderPaidInToken(
586         uint indexed _orderId,
587         address indexed _originAddress,
588         address indexed _tokenAddress,
589         uint _price,
590         uint _monethaFee
591     );
592 
593     // Payments have been processed event
594     event PaymentsProcessed(
595         address indexed _merchantAddress,
596         uint _amount,
597         uint _fee
598     );
599 
600     // PaymentRefunding is an event when refunding initialized
601     event PaymentRefunding(
602         uint indexed _orderId,
603         address indexed _clientAddress,
604         uint _amount,
605         string _refundReason
606     );
607 
608     // PaymentWithdrawn event is fired when payment is withdrawn
609     event PaymentWithdrawn(
610         uint indexed _orderId,
611         address indexed _clientAddress,
612         uint amount
613     );
614 
615     /// MonethaGateway contract for payment processing
616     MonethaGateway public monethaGateway;
617 
618     /// Address of MerchantWallet, where merchant reputation and funds are stored
619     MerchantWallet public merchantWallet;
620 
621     /// Merchant identifier hash, that associates with the acceptor
622     bytes32 public merchantIdHash;
623 
624     enum WithdrawState {Null, Pending, Withdrawn}
625 
626     struct Withdraw {
627         WithdrawState state;
628         uint amount;
629         address clientAddress;
630     }
631 
632     mapping (uint=>Withdraw) public withdrawals;
633 
634     /**
635      *  Private Payment Processor sets Monetha Gateway and Merchant Wallet.
636      *  @param _merchantId Merchant of the acceptor
637      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
638      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
639      */
640     constructor(
641         string _merchantId,
642         MonethaGateway _monethaGateway,
643         MerchantWallet _merchantWallet
644     )
645         public
646     {
647         require(bytes(_merchantId).length > 0);
648 
649         merchantIdHash = keccak256(_merchantId);
650 
651         setMonethaGateway(_monethaGateway);
652         setMerchantWallet(_merchantWallet);
653     }
654 
655     /**
656      *  payForOrder is used by order wallet/client to pay for the order
657      *  @param _orderId Identifier of the order
658      *  @param _originAddress buyer address
659      *  @param _monethaFee is fee collected by Monetha
660      */
661     function payForOrder(
662         uint _orderId,
663         address _originAddress,
664         uint _monethaFee
665     )
666         external payable whenNotPaused
667     {
668         require(_orderId > 0);
669         require(_originAddress != 0x0);
670         require(msg.value > 0);
671 
672         address fundAddress;
673         fundAddress = merchantWallet.merchantFundAddress();
674 
675         if (fundAddress != address(0)) {
676             monethaGateway.acceptPayment.value(msg.value)(fundAddress, _monethaFee);
677         } else {
678             monethaGateway.acceptPayment.value(msg.value)(merchantWallet, _monethaFee);
679         }
680 
681         // log payment event
682         emit OrderPaidInEther(_orderId, _originAddress, msg.value, _monethaFee);
683     }
684 
685     /**
686      *  payForOrderInTokens is used by order wallet/client to pay for the order
687      *  This call requires that token's approve method has been called prior to this.
688      *  @param _orderId Identifier of the order
689      *  @param _originAddress buyer address
690      *  @param _monethaFee is fee collected by Monetha
691      *  @param _tokenAddress is tokens address
692      *  @param _orderValue is order amount
693      */
694     function payForOrderInTokens(
695         uint _orderId,
696         address _originAddress,
697         uint _monethaFee,
698         address _tokenAddress,
699         uint _orderValue
700     )
701         external whenNotPaused
702     {
703         require(_orderId > 0);
704         require(_originAddress != 0x0);
705         require(_orderValue > 0);
706         require(_tokenAddress != address(0));
707 
708         address fundAddress;
709         fundAddress = merchantWallet.merchantFundAddress();
710 
711         ERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
712         
713         ERC20(_tokenAddress).transfer(address(monethaGateway), _orderValue);
714 
715         if (fundAddress != address(0)) {
716             monethaGateway.acceptTokenPayment(fundAddress, _monethaFee, _tokenAddress, _orderValue);
717         } else {
718             monethaGateway.acceptTokenPayment(merchantWallet, _monethaFee, _tokenAddress, _orderValue);
719         }
720         
721         // log payment event
722         emit OrderPaidInToken(_orderId, _originAddress, _tokenAddress, _orderValue, _monethaFee);
723     }
724 
725     /**
726      *  refundPayment used in case order cannot be processed and funds need to be returned
727      *  This function initiate process of funds refunding to the client.
728      *  @param _orderId Identifier of the order
729      *  @param _clientAddress is an address of client
730      *  @param _refundReason Order refund reason
731      */
732     function refundPayment(
733         uint _orderId,
734         address _clientAddress,
735         string _refundReason
736     )
737         external payable onlyMonetha whenNotPaused
738     {
739         require(_orderId > 0);
740         require(_clientAddress != 0x0);
741         require(msg.value > 0);
742         require(WithdrawState.Null == withdrawals[_orderId].state);
743 
744         // create withdraw
745         withdrawals[_orderId] = Withdraw({
746             state: WithdrawState.Pending,
747             amount: msg.value,
748             clientAddress: _clientAddress
749             });
750 
751         // log refunding
752         emit PaymentRefunding(_orderId, _clientAddress, msg.value, _refundReason);
753     }
754 
755     /**
756      *  refundTokenPayment used in case order cannot be processed and tokens need to be returned
757      *  This call requires that token's approve method has been called prior to this.
758      *  This function initiate process of refunding tokens to the client.
759      *  @param _orderId Identifier of the order
760      *  @param _clientAddress is an address of client
761      *  @param _refundReason Order refund reason
762      *  @param _tokenAddress is tokens address
763      *  @param _orderValue is order amount
764      */
765     function refundTokenPayment(
766         uint _orderId,
767         address _clientAddress,
768         string _refundReason,
769         uint _orderValue,
770         address _tokenAddress
771     )
772         external onlyMonetha whenNotPaused
773     {
774         require(_orderId > 0);
775         require(_clientAddress != 0x0);
776         require(_orderValue > 0);
777         require(_tokenAddress != address(0));
778         require(WithdrawState.Null == withdrawals[_orderId].state);
779 
780         ERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
781         
782         // create withdraw
783         withdrawals[_orderId] = Withdraw({
784             state: WithdrawState.Pending,
785             amount: _orderValue,
786             clientAddress: _clientAddress
787             });
788 
789         // log refunding
790         emit PaymentRefunding(_orderId, _clientAddress, _orderValue, _refundReason);
791     }
792 
793     /**
794      *  withdrawRefund performs fund transfer to the client's account.
795      *  @param _orderId Identifier of the order
796      */
797     function withdrawRefund(uint _orderId)
798         external whenNotPaused
799     {
800         Withdraw storage withdraw = withdrawals[_orderId];
801         require(WithdrawState.Pending == withdraw.state);
802 
803         address clientAddress = withdraw.clientAddress;
804         uint amount = withdraw.amount;
805 
806         // changing withdraw state before transfer
807         withdraw.state = WithdrawState.Withdrawn;
808 
809         // transfer fund to clients account
810         clientAddress.transfer(amount);
811 
812         // log withdrawn
813         emit PaymentWithdrawn(_orderId, clientAddress, amount);
814     }
815 
816     /**
817      *  withdrawTokenRefund performs token transfer to the client's account.
818      *  @param _orderId Identifier of the order
819      *  @param _tokenAddress token address
820      */
821     function withdrawTokenRefund(uint _orderId, address _tokenAddress)
822         external whenNotPaused
823     {
824         require(_tokenAddress != address(0));
825 
826         Withdraw storage withdraw = withdrawals[_orderId];
827         require(WithdrawState.Pending == withdraw.state);
828 
829         address clientAddress = withdraw.clientAddress;
830         uint amount = withdraw.amount;
831 
832         // changing withdraw state before transfer
833         withdraw.state = WithdrawState.Withdrawn;
834 
835         // transfer fund to clients account
836         ERC20(_tokenAddress).transfer(clientAddress, amount);
837 
838         // log withdrawn
839         emit PaymentWithdrawn(_orderId, clientAddress, amount);
840     }
841 
842     /**
843      *  setMonethaGateway allows owner to change address of MonethaGateway.
844      *  @param _newGateway Address of new MonethaGateway contract
845      */
846     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
847         require(address(_newGateway) != 0x0);
848 
849         monethaGateway = _newGateway;
850     }
851 
852     /**
853      *  setMerchantWallet allows owner to change address of MerchantWallet.
854      *  @param _newWallet Address of new MerchantWallet contract
855      */
856     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
857         require(address(_newWallet) != 0x0);
858         require(_newWallet.merchantIdHash() == merchantIdHash);
859 
860         merchantWallet = _newWallet;
861     }
862 }