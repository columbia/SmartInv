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
355 // File: contracts/SafeDestructible.sol
356 
357 /**
358  * @title SafeDestructible
359  * Base contract that can be destroyed by owner.
360  * Can be destructed if there are no funds on contract balance.
361  */
362 contract SafeDestructible is Ownable {
363     function destroy() onlyOwner public {
364         require(this.balance == 0);
365         selfdestruct(owner);
366     }
367 }
368 
369 // File: contracts/MerchantWallet.sol
370 
371 /**
372  *  @title MerchantWallet
373  *  Serves as a public Merchant profile with merchant profile info,
374  *      payment settings and latest reputation value.
375  *  Also MerchantWallet accepts payments for orders.
376  */
377 
378 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
379 
380     string constant VERSION = "0.5";
381 
382     /// Address of merchant's account, that can withdraw from wallet
383     address public merchantAccount;
384 
385     /// Address of merchant's fund address.
386     address public merchantFundAddress;
387 
388     /// Unique Merchant identifier hash
389     bytes32 public merchantIdHash;
390 
391     /// profileMap stores general information about the merchant
392     mapping (string=>string) profileMap;
393 
394     /// paymentSettingsMap stores payment and order settings for the merchant
395     mapping (string=>string) paymentSettingsMap;
396 
397     /// compositeReputationMap stores composite reputation, that compraises from several metrics
398     mapping (string=>uint32) compositeReputationMap;
399 
400     /// number of last digits in compositeReputation for fractional part
401     uint8 public constant REPUTATION_DECIMALS = 4;
402 
403     /**
404      *  Restrict methods in such way, that they can be invoked only by merchant account.
405      */
406     modifier onlyMerchant() {
407         require(msg.sender == merchantAccount);
408         _;
409     }
410 
411     /**
412      *  Fund Address should always be Externally Owned Account and not a contract.
413      */
414     modifier isEOA(address _fundAddress) {
415         uint256 _codeLength;
416         assembly {_codeLength := extcodesize(_fundAddress)}
417         require(_codeLength == 0, "sorry humans only");
418         _;
419     }
420 
421     /**
422      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
423      */
424     modifier onlyMerchantOrMonetha() {
425         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
426         _;
427     }
428 
429     /**
430      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
431      *  @param _merchantId Merchant identifier
432      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
433      */
434     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
435         require(_merchantAccount != 0x0);
436         require(bytes(_merchantId).length > 0);
437 
438         merchantAccount = _merchantAccount;
439         merchantIdHash = keccak256(_merchantId);
440 
441         merchantFundAddress = _fundAddress;
442     }
443 
444     /**
445      *  Accept payment from MonethaGateway
446      */
447     function () external payable {
448     }
449 
450     /**
451      *  @return profile info by string key
452      */
453     function profile(string key) external constant returns (string) {
454         return profileMap[key];
455     }
456 
457     /**
458      *  @return payment setting by string key
459      */
460     function paymentSettings(string key) external constant returns (string) {
461         return paymentSettingsMap[key];
462     }
463 
464     /**
465      *  @return composite reputation value by string key
466      */
467     function compositeReputation(string key) external constant returns (uint32) {
468         return compositeReputationMap[key];
469     }
470 
471     /**
472      *  Set profile info by string key
473      */
474     function setProfile(
475         string profileKey,
476         string profileValue,
477         string repKey,
478         uint32 repValue
479     )
480         external onlyOwner
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
561     string constant VERSION = "0.5";
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
626     constructor(
627         string _merchantId,
628         MonethaGateway _monethaGateway,
629         MerchantWallet _merchantWallet
630     )
631         public
632     {
633         require(bytes(_merchantId).length > 0);
634 
635         merchantIdHash = keccak256(_merchantId);
636 
637         setMonethaGateway(_monethaGateway);
638         setMerchantWallet(_merchantWallet);
639     }
640 
641     /**
642      *  payForOrder is used by order wallet/client to pay for the order
643      *  @param _orderId Identifier of the order
644      *  @param _originAddress buyer address
645      *  @param _monethaFee is fee collected by Monetha
646      */
647     function payForOrder(
648         uint _orderId,
649         address _originAddress,
650         uint _monethaFee
651     )
652         external payable whenNotPaused
653     {
654         require(_orderId > 0);
655         require(_originAddress != 0x0);
656         require(msg.value > 0);
657 
658         address fundAddress;
659         fundAddress = merchantWallet.merchantFundAddress();
660 
661         if (fundAddress != address(0)) {
662             monethaGateway.acceptPayment.value(msg.value)(fundAddress, _monethaFee);
663         } else {
664             monethaGateway.acceptPayment.value(msg.value)(merchantWallet, _monethaFee);
665         }
666 
667         // log payment event
668         emit OrderPaidInEther(_orderId, _originAddress, msg.value, _monethaFee);
669     }
670 
671     /**
672      *  payForOrderInTokens is used by order wallet/client to pay for the order
673      *  This call requires that token's approve method has been called prior to this.
674      *  @param _orderId Identifier of the order
675      *  @param _originAddress buyer address
676      *  @param _monethaFee is fee collected by Monetha
677      *  @param _tokenAddress is tokens address
678      *  @param _orderValue is order amount
679      */
680     function payForOrderInTokens(
681         uint _orderId,
682         address _originAddress,
683         uint _monethaFee,
684         address _tokenAddress,
685         uint _orderValue
686     )
687         external whenNotPaused
688     {
689         require(_orderId > 0);
690         require(_originAddress != 0x0);
691         require(_orderValue > 0);
692         require(_tokenAddress != address(0));
693 
694         address fundAddress;
695         fundAddress = merchantWallet.merchantFundAddress();
696 
697         ERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
698         
699         ERC20(_tokenAddress).transfer(address(monethaGateway), _orderValue);
700 
701         if (fundAddress != address(0)) {
702             monethaGateway.acceptTokenPayment(fundAddress, _monethaFee, _tokenAddress, _orderValue);
703         } else {
704             monethaGateway.acceptTokenPayment(merchantWallet, _monethaFee, _tokenAddress, _orderValue);
705         }
706         
707         // log payment event
708         emit OrderPaidInToken(_orderId, _originAddress, _tokenAddress, _orderValue, _monethaFee);
709     }
710 
711     /**
712      *  refundPayment used in case order cannot be processed and funds need to be returned
713      *  This function initiate process of funds refunding to the client.
714      *  @param _orderId Identifier of the order
715      *  @param _clientAddress is an address of client
716      *  @param _refundReason Order refund reason
717      */
718     function refundPayment(
719         uint _orderId,
720         address _clientAddress,
721         string _refundReason
722     )
723         external payable onlyMonetha whenNotPaused
724     {
725         require(_orderId > 0);
726         require(_clientAddress != 0x0);
727         require(msg.value > 0);
728         require(WithdrawState.Null == withdrawals[_orderId].state);
729 
730         // create withdraw
731         withdrawals[_orderId] = Withdraw({
732             state: WithdrawState.Pending,
733             amount: msg.value,
734             clientAddress: _clientAddress
735             });
736 
737         // log refunding
738         emit PaymentRefunding(_orderId, _clientAddress, msg.value, _refundReason);
739     }
740 
741     /**
742      *  refundTokenPayment used in case order cannot be processed and tokens need to be returned
743      *  This call requires that token's approve method has been called prior to this.
744      *  This function initiate process of refunding tokens to the client.
745      *  @param _orderId Identifier of the order
746      *  @param _clientAddress is an address of client
747      *  @param _refundReason Order refund reason
748      *  @param _tokenAddress is tokens address
749      *  @param _orderValue is order amount
750      */
751     function refundTokenPayment(
752         uint _orderId,
753         address _clientAddress,
754         string _refundReason,
755         uint _orderValue,
756         address _tokenAddress
757     )
758         external onlyMonetha whenNotPaused
759     {
760         require(_orderId > 0);
761         require(_clientAddress != 0x0);
762         require(_orderValue > 0);
763         require(_tokenAddress != address(0));
764         require(WithdrawState.Null == withdrawals[_orderId].state);
765 
766         ERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
767         
768         // create withdraw
769         withdrawals[_orderId] = Withdraw({
770             state: WithdrawState.Pending,
771             amount: _orderValue,
772             clientAddress: _clientAddress
773             });
774 
775         // log refunding
776         emit PaymentRefunding(_orderId, _clientAddress, _orderValue, _refundReason);
777     }
778 
779     /**
780      *  withdrawRefund performs fund transfer to the client's account.
781      *  @param _orderId Identifier of the order
782      */
783     function withdrawRefund(uint _orderId)
784         external whenNotPaused
785     {
786         Withdraw storage withdraw = withdrawals[_orderId];
787         require(WithdrawState.Pending == withdraw.state);
788 
789         address clientAddress = withdraw.clientAddress;
790         uint amount = withdraw.amount;
791 
792         // changing withdraw state before transfer
793         withdraw.state = WithdrawState.Withdrawn;
794 
795         // transfer fund to clients account
796         clientAddress.transfer(amount);
797 
798         // log withdrawn
799         emit PaymentWithdrawn(_orderId, clientAddress, amount);
800     }
801 
802     /**
803      *  withdrawTokenRefund performs token transfer to the client's account.
804      *  @param _orderId Identifier of the order
805      *  @param _tokenAddress token address
806      */
807     function withdrawTokenRefund(uint _orderId, address _tokenAddress)
808         external whenNotPaused
809     {
810         require(_tokenAddress != address(0));
811 
812         Withdraw storage withdraw = withdrawals[_orderId];
813         require(WithdrawState.Pending == withdraw.state);
814 
815         address clientAddress = withdraw.clientAddress;
816         uint amount = withdraw.amount;
817 
818         // changing withdraw state before transfer
819         withdraw.state = WithdrawState.Withdrawn;
820 
821         // transfer fund to clients account
822         ERC20(_tokenAddress).transfer(clientAddress, amount);
823 
824         // log withdrawn
825         emit PaymentWithdrawn(_orderId, clientAddress, amount);
826     }
827 
828     /**
829      *  setMonethaGateway allows owner to change address of MonethaGateway.
830      *  @param _newGateway Address of new MonethaGateway contract
831      */
832     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
833         require(address(_newGateway) != 0x0);
834 
835         monethaGateway = _newGateway;
836     }
837 
838     /**
839      *  setMerchantWallet allows owner to change address of MerchantWallet.
840      *  @param _newWallet Address of new MerchantWallet contract
841      */
842     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
843         require(address(_newWallet) != 0x0);
844         require(_newWallet.merchantIdHash() == merchantIdHash);
845 
846         merchantWallet = _newWallet;
847     }
848 }