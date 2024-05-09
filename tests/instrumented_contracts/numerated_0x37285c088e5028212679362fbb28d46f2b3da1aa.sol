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
80 // File: contracts/SafeDestructible.sol
81 
82 /**
83  * @title SafeDestructible
84  * Base contract that can be destroyed by owner.
85  * Can be destructed if there are no funds on contract balance.
86  */
87 contract SafeDestructible is Ownable {
88     function destroy() onlyOwner public {
89         require(this.balance == 0);
90         selfdestruct(owner);
91     }
92 }
93 
94 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
95 
96 /**
97  * @title Pausable
98  * @dev Base contract which allows children to implement an emergency stop mechanism.
99  */
100 contract Pausable is Ownable {
101   event Pause();
102   event Unpause();
103 
104   bool public paused = false;
105 
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is not paused.
109    */
110   modifier whenNotPaused() {
111     require(!paused);
112     _;
113   }
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is paused.
117    */
118   modifier whenPaused() {
119     require(paused);
120     _;
121   }
122 
123   /**
124    * @dev called by the owner to pause, triggers stopped state
125    */
126   function pause() onlyOwner whenNotPaused public {
127     paused = true;
128     Pause();
129   }
130 
131   /**
132    * @dev called by the owner to unpause, returns to normal state
133    */
134   function unpause() onlyOwner whenPaused public {
135     paused = false;
136     Unpause();
137   }
138 }
139 
140 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
141 
142 /**
143  * @title Contactable token
144  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
145  * contact information.
146  */
147 contract Contactable is Ownable{
148 
149     string public contactInformation;
150 
151     /**
152      * @dev Allows the owner to set a string with their contact information.
153      * @param info The contact information to attach to the contract.
154      */
155     function setContactInformation(string info) onlyOwner public {
156          contactInformation = info;
157      }
158 }
159 
160 // File: contracts/MerchantWallet.sol
161 
162 /**
163  *  @title MerchantWallet
164  *  Serves as a public Merchant profile with merchant profile info,
165  *      payment settings and latest reputation value.
166  *  Also MerchantWallet accepts payments for orders.
167  */
168 
169 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
170 
171     string constant VERSION = "0.3";
172 
173     /// Address of merchant's account, that can withdraw from wallet
174     address public merchantAccount;
175 
176     /// Unique Merchant identifier hash
177     bytes32 public merchantIdHash;
178 
179     /// profileMap stores general information about the merchant
180     mapping (string=>string) profileMap;
181 
182     /// paymentSettingsMap stores payment and order settings for the merchant
183     mapping (string=>string) paymentSettingsMap;
184 
185     /// compositeReputationMap stores composite reputation, that compraises from several metrics
186     mapping (string=>uint32) compositeReputationMap;
187 
188     /// number of last digits in compositeReputation for fractional part
189     uint8 public constant REPUTATION_DECIMALS = 4;
190 
191     modifier onlyMerchant() {
192         require(msg.sender == merchantAccount);
193         _;
194     }
195 
196     /**
197      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
198      *  @param _merchantId Merchant identifier
199      */
200     function MerchantWallet(address _merchantAccount, string _merchantId) public {
201         require(_merchantAccount != 0x0);
202         require(bytes(_merchantId).length > 0);
203 
204         merchantAccount = _merchantAccount;
205         merchantIdHash = keccak256(_merchantId);
206     }
207 
208     /**
209      *  Accept payment from MonethaGateway
210      */
211     function () external payable {
212     }
213 
214     /**
215      *  @return profile info by string key
216      */
217     function profile(string key) external constant returns (string) {
218         return profileMap[key];
219     }
220 
221     /**
222      *  @return payment setting by string key
223      */
224     function paymentSettings(string key) external constant returns (string) {
225         return paymentSettingsMap[key];
226     }
227 
228     /**
229      *  @return composite reputation value by string key
230      */
231     function compositeReputation(string key) external constant returns (uint32) {
232         return compositeReputationMap[key];
233     }
234 
235     /**
236      *  Set profile info by string key
237      */
238     function setProfile(
239         string profileKey,
240         string profileValue,
241         string repKey,
242         uint32 repValue
243     ) external onlyOwner
244     {
245         profileMap[profileKey] = profileValue;
246 
247         if (bytes(repKey).length != 0) {
248             compositeReputationMap[repKey] = repValue;
249         }
250     }
251 
252     /**
253      *  Set payment setting by string key
254      */
255     function setPaymentSettings(string key, string value) external onlyOwner {
256         paymentSettingsMap[key] = value;
257     }
258 
259     /**
260      *  Set composite reputation value by string key
261      */
262     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
263         compositeReputationMap[key] = value;
264     }
265 
266     /**
267      *  Allows withdrawal of funds to beneficiary address
268      */
269     function doWithdrawal(address beneficiary, uint amount) private {
270         require(beneficiary != 0x0);
271         beneficiary.transfer(amount);
272     }
273 
274     /**
275      *  Allows merchant to withdraw funds to beneficiary address
276      */
277     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
278         doWithdrawal(beneficiary, amount);
279     }
280 
281     /**
282      *  Allows merchant to withdraw funds to it's own account
283      */
284     function withdraw(uint amount) external {
285         withdrawTo(msg.sender, amount);
286     }
287 
288     /**
289      *  Allows merchant to withdraw funds to beneficiary address with a transaction
290      */
291     function sendTo(address beneficiary, uint amount) external onlyMerchant whenNotPaused {
292         doWithdrawal(beneficiary, amount);
293     }
294 
295     /**
296      *  Allows merchant to change it's account address
297      */
298     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
299         merchantAccount = newAccount;
300     }
301 }
302 
303 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
304 
305 /**
306  * @title Destructible
307  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
308  */
309 contract Destructible is Ownable {
310 
311   function Destructible() payable { }
312 
313   /**
314    * @dev Transfers the current balance to the owner and terminates the contract.
315    */
316   function destroy() onlyOwner public {
317     selfdestruct(owner);
318   }
319 
320   function destroyAndSend(address _recipient) onlyOwner public {
321     selfdestruct(_recipient);
322   }
323 }
324 
325 // File: zeppelin-solidity/contracts/math/SafeMath.sol
326 
327 /**
328  * @title SafeMath
329  * @dev Math operations with safety checks that throw on error
330  */
331 library SafeMath {
332   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
333     uint256 c = a * b;
334     assert(a == 0 || c / a == b);
335     return c;
336   }
337 
338   function div(uint256 a, uint256 b) internal constant returns (uint256) {
339     // assert(b > 0); // Solidity automatically throws when dividing by 0
340     uint256 c = a / b;
341     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
342     return c;
343   }
344 
345   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
346     assert(b <= a);
347     return a - b;
348   }
349 
350   function add(uint256 a, uint256 b) internal constant returns (uint256) {
351     uint256 c = a + b;
352     assert(c >= a);
353     return c;
354   }
355 }
356 
357 // File: contracts/MonethaGateway.sol
358 
359 /**
360  *  @title MonethaGateway
361  *
362  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
363  */
364 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
365 
366     using SafeMath for uint256;
367     
368     string constant VERSION = "0.4";
369 
370     /**
371      *  Fee permille of Monetha fee.
372      *  1 permille (‰) = 0.1 percent (%)
373      *  15‰ = 1.5%
374      */
375     uint public constant FEE_PERMILLE = 15;
376     
377     /**
378      *  Address of Monetha Vault for fee collection
379      */
380     address public monethaVault;
381 
382     /**
383      *  Account for permissions managing
384      */
385     address public admin;
386 
387     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
388 
389     /**
390      *  @param _monethaVault Address of Monetha Vault
391      */
392     function MonethaGateway(address _monethaVault, address _admin) public {
393         require(_monethaVault != 0x0);
394         monethaVault = _monethaVault;
395         
396         setAdmin(_admin);
397     }
398     
399     /**
400      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
401      *      and collects Monetha fee.
402      *  @param _merchantWallet address of merchant's wallet for fund transfer
403      *  @param _monethaFee is a fee collected by Monetha
404      */
405     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
406         require(_merchantWallet != 0x0);
407         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
408 
409         uint merchantIncome = msg.value.sub(_monethaFee);
410 
411         _merchantWallet.transfer(merchantIncome);
412         monethaVault.transfer(_monethaFee);
413 
414         PaymentProcessed(_merchantWallet, merchantIncome, _monethaFee);
415     }
416 
417     /**
418      *  changeMonethaVault allows owner to change address of Monetha Vault.
419      *  @param newVault New address of Monetha Vault
420      */
421     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
422         monethaVault = newVault;
423     }
424 
425     /**
426      *  Allows other monetha account or contract to set new monetha address
427      */
428     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
429         require(msg.sender == admin || msg.sender == owner);
430 
431         isMonethaAddress[_address] = _isMonethaAddress;
432 
433         MonethaAddressSet(_address, _isMonethaAddress);
434     }
435 
436     /**
437      *  setAdmin allows owner to change address of admin.
438      *  @param _admin New address of admin
439      */
440     function setAdmin(address _admin) public onlyOwner {
441         require(_admin != 0x0);
442         admin = _admin;
443     }
444 }
445 
446 // File: contracts/PrivatePaymentProcessor.sol
447 
448 contract PrivatePaymentProcessor is Pausable, Destructible, Contactable, Restricted {
449 
450     using SafeMath for uint256;
451 
452     string constant VERSION = "0.4";
453 
454     // Order paid event
455     event OrderPaid(
456         uint indexed _orderId,
457         address indexed _originAddress,
458         uint _price,
459         uint _monethaFee
460     );
461 
462     // Payments have been processed event
463     event PaymentsProcessed(
464         address indexed _merchantAddress,
465         uint _amount,
466         uint _fee
467     );
468 
469     // PaymentRefunding is an event when refunding initialized
470     event PaymentRefunding(
471          uint indexed _orderId,
472          address indexed _clientAddress,
473          uint _amount,
474          string _refundReason);
475 
476     // PaymentWithdrawn event is fired when payment is withdrawn
477     event PaymentWithdrawn(
478         uint indexed _orderId,
479         address indexed _clientAddress,
480         uint amount);
481 
482     /// MonethaGateway contract for payment processing
483     MonethaGateway public monethaGateway;
484 
485     /// Address of MerchantWallet, where merchant reputation and funds are stored
486     MerchantWallet public merchantWallet;
487 
488     /// Merchant identifier hash, that associates with the acceptor
489     bytes32 public merchantIdHash;
490 
491     enum WithdrawState {Null, Pending, Withdrawn}
492 
493     struct Withdraw {
494         WithdrawState state;
495         uint amount;
496         address clientAddress;
497     }
498 
499     mapping (uint=>Withdraw) public withdrawals;
500 
501     /**
502      *  Private Payment Processor sets Monetha Gateway and Merchant Wallet.
503      *  @param _merchantId Merchant of the acceptor
504      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
505      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
506      */
507     function PrivatePaymentProcessor(
508         string _merchantId,
509         MonethaGateway _monethaGateway,
510         MerchantWallet _merchantWallet
511     ) public
512     {
513         require(bytes(_merchantId).length > 0);
514 
515         merchantIdHash = keccak256(_merchantId);
516 
517         setMonethaGateway(_monethaGateway);
518         setMerchantWallet(_merchantWallet);
519     }
520 
521     /**
522      *  payForOrder is used by order wallet/client to pay for the order
523      *  @param _orderId Identifier of the order
524      *  @param _originAddress buyer address
525      *  @param _monethaFee is fee collected by Monetha
526      */
527     function payForOrder(
528         uint _orderId,
529         address _originAddress,
530         uint _monethaFee
531     ) external payable whenNotPaused
532     {
533         require(_orderId > 0);
534         require(_originAddress != 0x0);
535         require(msg.value > 0);
536 
537         monethaGateway.acceptPayment.value(msg.value)(merchantWallet, _monethaFee);
538 
539         // log payment event
540         OrderPaid(_orderId, _originAddress, msg.value, _monethaFee);
541     }
542 
543     /**
544      *  refundPayment used in case order cannot be processed and funds need to be returned
545      *  This function initiate process of funds refunding to the client.
546      *  @param _orderId Identifier of the order
547      *  @param _clientAddress is an address of client
548      *  @param _refundReason Order refund reason
549      */
550     function refundPayment(
551         uint _orderId,
552         address _clientAddress,
553         string _refundReason
554     ) external payable onlyMonetha whenNotPaused
555     {
556         require(_orderId > 0);
557         require(_clientAddress != 0x0);
558         require(msg.value > 0);
559         require(WithdrawState.Null == withdrawals[_orderId].state);
560 
561         // create withdraw
562         withdrawals[_orderId] = Withdraw({
563             state: WithdrawState.Pending,
564             amount: msg.value,
565             clientAddress: _clientAddress
566             });
567 
568         // log refunding
569         PaymentRefunding(_orderId, _clientAddress, msg.value, _refundReason);
570     }
571 
572     /**
573      *  withdrawRefund performs fund transfer to the client's account.
574      *  @param _orderId Identifier of the order
575      */
576     function withdrawRefund(uint _orderId)
577     external whenNotPaused
578     {
579         Withdraw storage withdraw = withdrawals[_orderId];
580         require(WithdrawState.Pending == withdraw.state);
581 
582         address clientAddress = withdraw.clientAddress;
583         uint amount = withdraw.amount;
584 
585         // changing withdraw state before transfer
586         withdraw.state = WithdrawState.Withdrawn;
587 
588         // transfer fund to clients account
589         clientAddress.transfer(amount);
590 
591         // log withdrawn
592         PaymentWithdrawn(_orderId, clientAddress, amount);
593     }
594 
595     /**
596      *  setMonethaGateway allows owner to change address of MonethaGateway.
597      *  @param _newGateway Address of new MonethaGateway contract
598      */
599     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
600         require(address(_newGateway) != 0x0);
601 
602         monethaGateway = _newGateway;
603     }
604 
605     /**
606      *  setMerchantWallet allows owner to change address of MerchantWallet.
607      *  @param _newWallet Address of new MerchantWallet contract
608      */
609     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
610         require(address(_newWallet) != 0x0);
611         require(_newWallet.merchantIdHash() == merchantIdHash);
612 
613         merchantWallet = _newWallet;
614     }
615 }