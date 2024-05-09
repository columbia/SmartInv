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
267      *  Allows merchant to withdraw funds to beneficiary address
268      */
269     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
270         require(beneficiary != 0x0);
271         beneficiary.transfer(amount);
272     }
273 
274     /**
275      *  Allows merchant to withdraw funds to it's own account
276      */
277     function withdraw(uint amount) external {
278         withdrawTo(msg.sender, amount);
279     }
280 
281     /**
282      *  Allows merchant to change it's account address
283      */
284     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
285         merchantAccount = newAccount;
286     }
287 }
288 
289 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
290 
291 /**
292  * @title Destructible
293  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
294  */
295 contract Destructible is Ownable {
296 
297   function Destructible() payable { }
298 
299   /**
300    * @dev Transfers the current balance to the owner and terminates the contract.
301    */
302   function destroy() onlyOwner public {
303     selfdestruct(owner);
304   }
305 
306   function destroyAndSend(address _recipient) onlyOwner public {
307     selfdestruct(_recipient);
308   }
309 }
310 
311 // File: zeppelin-solidity/contracts/math/SafeMath.sol
312 
313 /**
314  * @title SafeMath
315  * @dev Math operations with safety checks that throw on error
316  */
317 library SafeMath {
318   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
319     uint256 c = a * b;
320     assert(a == 0 || c / a == b);
321     return c;
322   }
323 
324   function div(uint256 a, uint256 b) internal constant returns (uint256) {
325     // assert(b > 0); // Solidity automatically throws when dividing by 0
326     uint256 c = a / b;
327     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
328     return c;
329   }
330 
331   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
332     assert(b <= a);
333     return a - b;
334   }
335 
336   function add(uint256 a, uint256 b) internal constant returns (uint256) {
337     uint256 c = a + b;
338     assert(c >= a);
339     return c;
340   }
341 }
342 
343 // File: contracts/MonethaGateway.sol
344 
345 /**
346  *  @title MonethaGateway
347  *
348  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
349  */
350 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
351 
352     using SafeMath for uint256;
353     
354     string constant VERSION = "0.4";
355 
356     /**
357      *  Fee permille of Monetha fee.
358      *  1 permille (‰) = 0.1 percent (%)
359      *  15‰ = 1.5%
360      */
361     uint public constant FEE_PERMILLE = 15;
362     
363     /**
364      *  Address of Monetha Vault for fee collection
365      */
366     address public monethaVault;
367 
368     /**
369      *  Account for permissions managing
370      */
371     address public admin;
372 
373     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
374 
375     /**
376      *  @param _monethaVault Address of Monetha Vault
377      */
378     function MonethaGateway(address _monethaVault, address _admin) public {
379         require(_monethaVault != 0x0);
380         monethaVault = _monethaVault;
381         
382         setAdmin(_admin);
383     }
384     
385     /**
386      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
387      *      and collects Monetha fee.
388      *  @param _merchantWallet address of merchant's wallet for fund transfer
389      *  @param _monethaFee is a fee collected by Monetha
390      */
391     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
392         require(_merchantWallet != 0x0);
393         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
394 
395         uint merchantIncome = msg.value.sub(_monethaFee);
396 
397         _merchantWallet.transfer(merchantIncome);
398         monethaVault.transfer(_monethaFee);
399 
400         PaymentProcessed(_merchantWallet, merchantIncome, _monethaFee);
401     }
402 
403     /**
404      *  changeMonethaVault allows owner to change address of Monetha Vault.
405      *  @param newVault New address of Monetha Vault
406      */
407     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
408         monethaVault = newVault;
409     }
410 
411     /**
412      *  Allows other monetha account or contract to set new monetha address
413      */
414     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
415         require(msg.sender == admin || msg.sender == owner);
416 
417         isMonethaAddress[_address] = _isMonethaAddress;
418 
419         MonethaAddressSet(_address, _isMonethaAddress);
420     }
421 
422     /**
423      *  setAdmin allows owner to change address of admin.
424      *  @param _admin New address of admin
425      */
426     function setAdmin(address _admin) public onlyOwner {
427         require(_admin != 0x0);
428         admin = _admin;
429     }
430 }
431 
432 // File: contracts/PrivatePaymentProcessor.sol
433 
434 contract PrivatePaymentProcessor is Pausable, Destructible, Contactable, Restricted {
435 
436     using SafeMath for uint256;
437 
438     string constant VERSION = "0.4";
439 
440     // Order paid event
441     event OrderPaid(
442         uint indexed _orderId,
443         address indexed _originAddress,
444         uint _price,
445         uint _monethaFee
446     );
447 
448     // Payments have been processed event
449     event PaymentsProcessed(
450         address indexed _merchantAddress,
451         uint _amount,
452         uint _fee
453     );
454 
455     // PaymentRefunding is an event when refunding initialized
456     event PaymentRefunding(
457          uint indexed _orderId,
458          address indexed _clientAddress,
459          uint _amount,
460          string _refundReason);
461 
462     // PaymentWithdrawn event is fired when payment is withdrawn
463     event PaymentWithdrawn(
464         uint indexed _orderId,
465         address indexed _clientAddress,
466         uint amount);
467 
468     /// MonethaGateway contract for payment processing
469     MonethaGateway public monethaGateway;
470 
471     /// Address of MerchantWallet, where merchant reputation and funds are stored
472     MerchantWallet public merchantWallet;
473 
474     /// Merchant identifier hash, that associates with the acceptor
475     bytes32 public merchantIdHash;
476 
477     enum WithdrawState {Null, Pending, Withdrawn}
478 
479     struct Withdraw {
480         WithdrawState state;
481         uint amount;
482         address clientAddress;
483     }
484 
485     mapping (uint=>Withdraw) public withdrawals;
486 
487     /**
488      *  Private Payment Processor sets Monetha Gateway and Merchant Wallet.
489      *  @param _merchantId Merchant of the acceptor
490      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
491      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
492      */
493     function PrivatePaymentProcessor(
494         string _merchantId,
495         MonethaGateway _monethaGateway,
496         MerchantWallet _merchantWallet
497     ) public
498     {
499         require(bytes(_merchantId).length > 0);
500 
501         merchantIdHash = keccak256(_merchantId);
502 
503         setMonethaGateway(_monethaGateway);
504         setMerchantWallet(_merchantWallet);
505     }
506 
507     /**
508      *  payForOrder is used by order wallet/client to pay for the order
509      *  @param _orderId Identifier of the order
510      *  @param _originAddress buyer address
511      *  @param _monethaFee is fee collected by Monetha
512      */
513     function payForOrder(
514         uint _orderId,
515         address _originAddress,
516         uint _monethaFee
517     ) external payable whenNotPaused
518     {
519         require(_orderId > 0);
520         require(_originAddress != 0x0);
521         require(msg.value > 0);
522 
523         monethaGateway.acceptPayment.value(msg.value)(merchantWallet, _monethaFee);
524 
525         // log payment event
526         OrderPaid(_orderId, _originAddress, msg.value, _monethaFee);
527     }
528 
529     /**
530      *  refundPayment used in case order cannot be processed and funds need to be returned
531      *  This function initiate process of funds refunding to the client.
532      *  @param _orderId Identifier of the order
533      *  @param _clientAddress is an address of client
534      *  @param _refundReason Order refund reason
535      */
536     function refundPayment(
537         uint _orderId,
538         address _clientAddress,
539         string _refundReason
540     ) external payable onlyMonetha whenNotPaused
541     {
542         require(_orderId > 0);
543         require(_clientAddress != 0x0);
544         require(msg.value > 0);
545         require(WithdrawState.Null == withdrawals[_orderId].state);
546 
547         // create withdraw
548         withdrawals[_orderId] = Withdraw({
549             state: WithdrawState.Pending,
550             amount: msg.value,
551             clientAddress: _clientAddress
552             });
553 
554         // log refunding
555         PaymentRefunding(_orderId, _clientAddress, msg.value, _refundReason);
556     }
557 
558     /**
559      *  withdrawRefund performs fund transfer to the client's account.
560      *  @param _orderId Identifier of the order
561      */
562     function withdrawRefund(uint _orderId)
563     external whenNotPaused
564     {
565         Withdraw storage withdraw = withdrawals[_orderId];
566         require(WithdrawState.Pending == withdraw.state);
567 
568         address clientAddress = withdraw.clientAddress;
569         uint amount = withdraw.amount;
570 
571         // changing withdraw state before transfer
572         withdraw.state = WithdrawState.Withdrawn;
573 
574         // transfer fund to clients account
575         clientAddress.transfer(amount);
576 
577         // log withdrawn
578         PaymentWithdrawn(_orderId, clientAddress, amount);
579     }
580 
581     /**
582      *  setMonethaGateway allows owner to change address of MonethaGateway.
583      *  @param _newGateway Address of new MonethaGateway contract
584      */
585     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
586         require(address(_newGateway) != 0x0);
587 
588         monethaGateway = _newGateway;
589     }
590 
591     /**
592      *  setMerchantWallet allows owner to change address of MerchantWallet.
593      *  @param _newWallet Address of new MerchantWallet contract
594      */
595     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
596         require(address(_newWallet) != 0x0);
597         require(_newWallet.merchantIdHash() == merchantIdHash);
598 
599         merchantWallet = _newWallet;
600     }
601 }