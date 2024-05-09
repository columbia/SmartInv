1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Core/Manageable.sol
4 
5 contract Manageable {
6   address public manager;
7 
8 
9   /**
10    * @dev Create a new instance of the Manageable contract.
11    * @param _manager address
12    */
13   function Manageable(address _manager) public {
14     require(_manager != 0x0);
15     manager = _manager;
16   }
17 
18   /**
19    * @dev Checks if the msg.sender is the manager.
20    */
21   modifier onlyManager() { 
22     require (msg.sender == manager && manager != 0x0);
23     _; 
24   }
25 }
26 
27 // File: contracts/Core/Activatable.sol
28 
29 contract Activatable is Manageable {
30   event ActivatedContract(uint256 activatedAt);
31   event DeactivatedContract(uint256 deactivatedAt);
32 
33   bool public active;
34   
35   /**
36    * @dev Check if the contract is active. 
37    */
38   modifier isActive() {
39     require(active);
40     _;
41   }
42 
43   /**
44    * @dev Check if the contract is not active. 
45    */
46   modifier isNotActive() {
47     require(!active);
48     _;
49   }
50 
51   /**
52    * @dev Activate the contract.
53    */
54   function activate() public onlyManager isNotActive {
55     // Set the flag to true.
56     active = true;
57 
58     // Trigger event.
59     ActivatedContract(now);
60   }
61 
62   /**
63    * @dev Deactiate the contract.
64    */
65   function deactivate() public onlyManager isActive {
66     // Set the flag to false.
67     active = false;
68 
69     // Trigger event.
70     DeactivatedContract(now);
71   }
72 }
73 
74 // File: contracts/Core/Versionable.sol
75 
76 contract Versionable is Activatable {
77   string public name;
78   string public version;
79   uint256 public identifier;
80   uint256 public createdAt;
81 
82   /**
83    * @dev Create a new intance of a Versionable contract. Sets the
84    *      createdAt unix timestamp to current block timestamp.
85    */
86   function Versionable (string _name, string _version, uint256 _identifier) public {
87     require (bytes(_name).length != 0x0 && bytes(_version).length != 0x0 && _identifier > 0);
88 
89     // Set variables.
90     name = _name;
91     version = _version;
92     identifier = _identifier;
93     createdAt = now;
94   }
95 }
96 
97 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
98 
99 /**
100  * @title Ownable
101  * @dev The Ownable contract has an owner address, and provides basic authorization control
102  * functions, this simplifies the implementation of "user permissions".
103  */
104 contract Ownable {
105   address public owner;
106 
107 
108   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110 
111   /**
112    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
113    * account.
114    */
115   function Ownable() public {
116     owner = msg.sender;
117   }
118 
119 
120   /**
121    * @dev Throws if called by any account other than the owner.
122    */
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127 
128 
129   /**
130    * @dev Allows the current owner to transfer control of the contract to a newOwner.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address newOwner) public onlyOwner {
134     require(newOwner != address(0));
135     OwnershipTransferred(owner, newOwner);
136     owner = newOwner;
137   }
138 
139 }
140 
141 // File: contracts/Management/ContractManagementSystem.sol
142 
143 contract ContractManagementSystem is Ownable {
144   event UpgradedContract (uint256 contractIdentifier, address indexed oldContractAddress, address indexed newContractAddress);
145   event RollbackedContract (uint256 contractIdentifier, address indexed fromContractAddress, address indexed toContractAddress);
146 
147   mapping (uint256 => mapping (address => bool)) public managedContracts;
148   mapping (uint256 => address) public activeContracts;
149   mapping (uint256 => bool) migrationLocks;
150 
151   /**
152    * @dev Ensure no locks are in place for the given contract identifier.
153    * @param contractIdentifier uint256
154    */
155   modifier onlyWithoutLock(uint256 contractIdentifier) {
156     require(!migrationLocks[contractIdentifier]);
157     _;
158   }
159 
160   /**
161    * @dev    Get the address of the active contract for the given identifier.
162    * @param  contractIdentifier uint256
163    * @return address
164    */
165   function getActiveContractAddress(uint256 contractIdentifier)
166     public
167     constant
168     onlyWithoutLock(contractIdentifier)
169     returns (address activeContract)
170   {
171     // Validate the function arguments.
172     require(contractIdentifier != 0x0);
173     
174     // Get the active contract for the given identifier.
175     activeContract = activeContracts[contractIdentifier];
176 
177     // Ensure the address is set and the contract is active.
178     require(activeContract != 0x0 && Activatable(activeContract).active());
179   }
180 
181   /**
182    * @dev    Check if the contract for the given address is managed.
183    * @param  contractIdentifier uint256
184    * @param  contractAddress    address
185    * @return bool
186    */
187   function existsManagedContract(uint256 contractIdentifier, address contractAddress)
188     public
189     constant
190     returns (bool)
191   {
192     // Validate the function arguments.
193     require(contractIdentifier != 0x0 && contractAddress != 0x0);
194 
195     return managedContracts[contractIdentifier][contractAddress];
196   }
197 
198   /**
199    * @dev    Upgrade the contract for the given contract identifier to a newer version.
200    * @dev    investigate potential race condition
201    * @param  contractIdentifier uint256
202    * @param  newContractAddress address
203    */
204   function upgradeContract(uint256 contractIdentifier, address newContractAddress)
205     public
206     onlyOwner
207     onlyWithoutLock(contractIdentifier)
208   {
209     // Validate the function arguments.
210     require(contractIdentifier != 0x0 && newContractAddress != 0x0);
211     
212     // Lock the contractIdentifier.
213     migrationLocks[contractIdentifier] = true;
214 
215     // New contract should not be active.
216     require(!Activatable(newContractAddress).active());
217 
218     // New contract should match the given contractIdentifier.
219     require(contractIdentifier == Versionable(newContractAddress).identifier());
220 
221     // Ensure the new contract is not already managed.
222     require (!existsManagedContract(contractIdentifier, newContractAddress));
223 
224     // Get the old contract address.
225     address oldContractAddress = activeContracts[contractIdentifier];
226 
227     // Ensure the old contract is not deactivated already.
228     if (oldContractAddress != 0x0) {
229       require(Activatable(oldContractAddress).active());
230     }
231 
232     // Swap the states.
233     swapContractsStates(contractIdentifier, newContractAddress, oldContractAddress);
234 
235     // Add it to the managed ones.
236     managedContracts[contractIdentifier][newContractAddress] = true;
237 
238     // Unlock the contractIdentifier.
239     migrationLocks[contractIdentifier] = false;
240     
241     // Trigger event.
242     UpgradedContract(contractIdentifier, oldContractAddress, newContractAddress);
243   }
244 
245   /**
246    * @dev Rollback the contract for the given contract identifier to the provided version.
247    * @dev investigate potential race condition
248    * @param  contractIdentifier uint256
249    * @param  toContractAddress  address
250    */
251   function rollbackContract(uint256 contractIdentifier, address toContractAddress)
252     public
253     onlyOwner
254     onlyWithoutLock(contractIdentifier)
255   {
256     // Validate the function arguments.
257     require(contractIdentifier != 0x0 && toContractAddress != 0x0);
258 
259     // Lock the contractIdentifier.
260     migrationLocks[contractIdentifier] = true;
261 
262     // To contract should match the given contractIdentifier.
263     require(contractIdentifier == Versionable(toContractAddress).identifier());
264 
265     // Rollback "to" contract should be managed and inactive.
266     require (!Activatable(toContractAddress).active() && existsManagedContract(contractIdentifier, toContractAddress));
267 
268     // Get the rollback "from" contract for given identifier. Will fail if there is no active contract.
269     address fromContractAddress = activeContracts[contractIdentifier];
270 
271     // Swap the states.
272     swapContractsStates(contractIdentifier, toContractAddress, fromContractAddress);
273 
274     // Unlock the contractIdentifier.
275     migrationLocks[contractIdentifier] = false;
276 
277     // Trigger event.
278     RollbackedContract(contractIdentifier, fromContractAddress, toContractAddress);
279   }
280   
281   /**
282    * @dev Swap the given contracts states as defined:
283    *        - newContractAddress will be activated
284    *        - oldContractAddress will be deactived
285    * @param  contractIdentifier uint256
286    * @param  newContractAddress address
287    * @param  oldContractAddress address
288    */
289   function swapContractsStates(uint256 contractIdentifier, address newContractAddress, address oldContractAddress) internal {
290     // Deactivate the old contract.
291     if (oldContractAddress != 0x0) {
292       Activatable(oldContractAddress).deactivate();
293     }
294 
295     // Activate the new contract.
296     Activatable(newContractAddress).activate();
297 
298      // Set the new contract as the active one for the given identifier.
299     activeContracts[contractIdentifier] = newContractAddress;
300   }
301 }
302 
303 // File: zeppelin-solidity/contracts/math/SafeMath.sol
304 
305 /**
306  * @title SafeMath
307  * @dev Math operations with safety checks that throw on error
308  */
309 library SafeMath {
310   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311     if (a == 0) {
312       return 0;
313     }
314     uint256 c = a * b;
315     assert(c / a == b);
316     return c;
317   }
318 
319   function div(uint256 a, uint256 b) internal pure returns (uint256) {
320     // assert(b > 0); // Solidity automatically throws when dividing by 0
321     uint256 c = a / b;
322     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
323     return c;
324   }
325 
326   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
327     assert(b <= a);
328     return a - b;
329   }
330 
331   function add(uint256 a, uint256 b) internal pure returns (uint256) {
332     uint256 c = a + b;
333     assert(c >= a);
334     return c;
335   }
336 }
337 
338 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
339 
340 /**
341  * @title ERC20Basic
342  * @dev Simpler version of ERC20 interface
343  * @dev see https://github.com/ethereum/EIPs/issues/179
344  */
345 contract ERC20Basic {
346   uint256 public totalSupply;
347   function balanceOf(address who) public view returns (uint256);
348   function transfer(address to, uint256 value) public returns (bool);
349   event Transfer(address indexed from, address indexed to, uint256 value);
350 }
351 
352 // File: contracts/Token/SwissCryptoExchangeToken.sol
353 
354 /**
355  * @title SwissCryptoExchange Standard ERC20 compatible token
356  *
357  * @dev Implementation of the SwissCryptoExchange company shares.
358  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/StandardToken.sol
359  */
360 contract SwissCryptoExchangeToken is ERC20Basic, Versionable {
361   event Mint(address indexed to, uint256 amount);
362 
363   using SafeMath for uint256;
364 
365   mapping(address => uint256) balances;
366 
367   string public constant symbol = "SCX";
368   uint8 public constant decimals = 0;
369 
370   uint256 internal constant COMPANY_CONTRACT_ID = 101;
371 
372   /**
373    * Create a new instance of the SwissCryptoExchangeToken contract.
374    * @param initialShareholderAddress address 
375    * @param initialAmount             uint256 
376    */
377   function SwissCryptoExchangeToken (address initialShareholderAddress, uint256 initialAmount, address _manager)
378     public
379     Manageable (_manager)
380     Versionable ("SwissCryptoExchangeToken", "1.0.0", 1)
381   {
382     require(initialAmount > 0);
383     require(initialShareholderAddress != 0x0);
384 
385     balances[initialShareholderAddress] = initialAmount;
386     totalSupply = initialAmount;
387   }
388 
389   /**
390    * @dev Esnure the msg.sender is the company contract.
391    */
392   modifier onlyCompany() {
393     require (msg.sender == ContractManagementSystem(manager).getActiveContractAddress(COMPANY_CONTRACT_ID));
394     _;
395   }
396 
397   /**
398   * @dev Gets the balance of the specified address.
399   * @param _owner The address to query the the balance of.
400   * @return An uint256 representing the amount owned by the passed address.
401   */
402   function balanceOf(address _owner) public view returns (uint256 balance) {
403     return balances[_owner];
404   }
405 
406   /**
407   * @dev Transfer token for a specified address
408   * @param _to The address to transfer to.
409   * @param _value The amount to be transferred.
410   */
411   function transfer(address _to, uint256 _value) public isActive onlyCompany returns (bool) {
412     require(_to != 0x0);
413     require(_value <= balances[msg.sender]);
414 
415     // SafeMath.sub will throw if there is not enough balance.
416     balances[msg.sender] = balances[msg.sender].sub(_value);
417     balances[_to] = balances[_to].add(_value);
418     Transfer(msg.sender, _to, _value);
419     return true;
420   }
421 
422   /**
423    * @dev Transfer tokens from one address to another.
424    * @param _from address The address which you want to send tokens from
425    * @param _to address The address which you want to transfer to
426    * @param _value uint256 the amount of tokens to be transferred
427    */
428   function transferFrom(address _from, address _to, uint256 _value) public isActive onlyCompany returns (bool) {
429     require(_to != 0x0);
430     require(_value <= balances[_from]);
431 
432     balances[_from] = balances[_from].sub(_value);
433     balances[_to] = balances[_to].add(_value);
434     Transfer(_from, _to, _value);
435     return true;
436   }
437 
438   /**
439    * @dev Function to mint tokens.
440    * @param _amount The amount of tokens to mint.
441    * @return A boolean that indicates if the operation was successful.
442    */
443   function mint(uint256 _amount) isActive onlyCompany public returns (bool) {
444     // The receiver of the minted tokens will be the company contract.
445     address _companyAddress = ContractManagementSystem(manager).getActiveContractAddress(COMPANY_CONTRACT_ID);
446     totalSupply = totalSupply.add(_amount);
447     balances[_companyAddress] = balances[_companyAddress].add(_amount);
448     Mint(_companyAddress, _amount);
449     Transfer(0x0, _companyAddress, _amount);
450     return true;
451   }
452 }
453 
454 // File: contracts/Company/BaseCompany.sol
455 
456 contract BaseCompany is Versionable {
457   using SafeMath for uint256;
458   
459   uint256 internal constant TOKEN_CONTRACT_ID = 1;
460 
461   /**
462    * @dev Create a new instance of the company contract.
463    * @param _name       string
464    * @param _version    string
465    * @param _identifier uint256
466    * @param _manager    address
467    */
468   function BaseCompany(string _name, string _version, uint256 _identifier, address _manager) public Versionable (_name, _version, _identifier) Manageable(_manager) {}
469 
470   /**
471    * @dev Get the amount of shares that a shareholder owns in percentage
472    *      relative to the total number of shares.
473    * @param  shareholder address
474    * @return uint256
475    */
476   function getSharesPercentage(address shareholder) public constant returns (uint256) {
477     uint256 totalSharesAmount = token().totalSupply();
478     uint256 ownedShares = token().balanceOf(shareholder);
479     return ownedShares.mul(100).div(totalSharesAmount);
480   }
481 
482   /**
483    * @dev Get the latest token contract address.
484    * @return address
485    */
486   function tokenAddress() public constant returns (address) {
487     return ContractManagementSystem(manager).getActiveContractAddress(TOKEN_CONTRACT_ID);
488   }
489 
490   /**
491    * @dev Get the latest reference to the token.
492    * @return SwissCryptoExchangeToken
493    */
494   function token() public constant returns (SwissCryptoExchangeToken) {
495     return SwissCryptoExchangeToken(tokenAddress());
496   }
497 
498   /**
499    * @dev Check if the provided address is a company shareholder.
500    * @param _addr address
501    * @return bool
502    */
503   function isShareholder(address _addr) public constant returns (bool) {
504     return token().balanceOf(_addr) > 0 && _addr != address(this);
505   }
506     
507   /**
508    * @dev Check if the given address is a majority company shareholder.
509    * @param _addr address
510    * @return bool
511    */
512   function isMajorityShareholder(address _addr) public constant returns (bool) {
513     return (getSharesPercentage(_addr) > 50);
514   }
515 }
516 
517 // File: contracts/Company/SwissCryptoExchangeCompany.sol
518 
519 contract SwissCryptoExchangeCompany is BaseCompany {
520   event ProcessedInvestment(address indexed investor, uint256 weiAmount, uint256 shares);
521   event SaleCompleted(address indexed beneficiary, uint256 weiAmount, uint256 shares);
522   event SaleEnded(uint256 endedAt);
523   event SaleAborted(uint256 abortedAt);
524 
525   using SafeMath for uint256;
526 
527   Sale public currentSale;
528 
529   // Definition of a sale.
530   struct Sale {
531     address creator;
532     address beneficiary;
533     address investor;
534     address shareholder;
535     uint256 rate;
536     uint256 weiRaised;
537     uint256 sharesSold;
538     uint256 sharesCap;
539     bool ended;
540     bool exists;
541   }
542   
543   /**
544    * @dev Create a new instance of the company contract.
545    * @param _manager address
546    */
547   function SwissCryptoExchangeCompany(address _manager) public BaseCompany("SwissCryptoExchangeCompany", "1.0.1", 101, _manager) {}
548 
549   /**
550    * @dev Ensure the msg.sender is an shareholder of the company.
551    */
552   modifier onlyShareholder() {
553     require(isShareholder(msg.sender));
554     _; 
555   }
556   
557   /**
558    * @dev Ensure the msg.sender is has over 50% of the company shares.
559    */
560   modifier onlyMajority() {
561     require(isMajorityShareholder(msg.sender));
562     _;
563   }
564 
565   /**
566    * @dev Ensure the msg.sender is thesale creator.
567    */
568   modifier onlySaleCreator() {
569     require(msg.sender == currentSale.creator);
570     _; 
571   }
572   
573   /**
574    * @dev Ensure there is no sale in progress.
575    */
576   modifier onlyWhenNotSelling() { 
577     require(!currentSale.exists);
578     _; 
579   }
580   
581   /**
582    * @dev Ensure there is a sale in progress.
583    */
584   modifier onlyWhenSelling() { 
585     require(currentSale.exists);
586     _; 
587   }
588 
589   
590   /**
591    * @dev Handle an incoming ether transfer.
592    */
593   function ()
594     public
595     payable
596     isActive
597     onlyWhenSelling
598   {
599     // Validate the purchase.
600     require(msg.sender == currentSale.investor && msg.value > 0);
601 
602     // Forward the call to the Sale contract.
603     processPayment();
604   }
605 
606   /**
607    * @dev Initialize a new sale.
608    * @param rate         uint256
609    * @param sharesCap    uint256
610    * @param beneficiary  address 
611    * @param investor     address 
612    */
613   function initializeNewSale(
614     uint256 rate,
615     uint256 sharesCap,
616     address beneficiary,
617     address investor
618   )
619     public
620     isActive
621     onlyMajority
622     onlyWhenNotSelling
623   {
624     // Validate the parameters.
625     require(rate > 0);
626     require(sharesCap > 0);
627     require(beneficiary != 0x0);
628     require(investor != 0x0);
629     require(token().balanceOf(msg.sender) >= sharesCap);
630 
631     // Set sale properties.
632     currentSale.creator = msg.sender;
633     currentSale.rate = rate;
634     currentSale.sharesCap = sharesCap;
635     currentSale.beneficiary = beneficiary;
636     currentSale.investor = investor;
637     currentSale.shareholder = msg.sender;
638     currentSale.weiRaised = 0;
639     currentSale.sharesSold = 0;
640     currentSale.ended = false;
641     currentSale.exists = true;
642 
643     // Transfer the funds to the company.
644     require(token().transferFrom(msg.sender, address(this), sharesCap));
645 
646     // Enforce that one shareholder will remain majority.
647     require(isMajorityShareholder(msg.sender));
648   }
649 
650   /**
651    * @dev Process the payment from the investor.
652    */
653   function processPayment()
654     private
655   {
656     address investor = currentSale.investor;
657     uint256 excessWei = 0;
658     uint256 sharesSold = currentSale.sharesSold;
659     uint256 sharesCap = currentSale.sharesCap;
660     uint256 rate = currentSale.rate;
661     uint256 weiAmount = msg.value;
662     uint256 shares = weiAmount.mul(rate).div(1 ether);
663 
664     // If the after this investment the cap will be reached
665     // the sale will end and the excess wei will be sent
666     // back to the investor. 
667     if (sharesSold.add(shares) > sharesCap) {
668       excessWei = sharesSold.add(shares).sub(sharesCap).mul(1 ether).div(rate);
669       weiAmount = weiAmount.sub(excessWei);
670       shares = sharesCap.sub(sharesSold);
671     } else {
672       //we care of investors money
673       excessWei = weiAmount.sub(shares.mul(1 ether).div(rate));
674       weiAmount = weiAmount.sub(excessWei);
675     }
676 
677     // update shares
678     currentSale.sharesSold = sharesSold.add(shares);
679 
680     // update weiRaised.
681     currentSale.weiRaised = currentSale.weiRaised.add(weiAmount);
682 
683     //close sale
684     if(currentSale.sharesSold == sharesCap) {
685       currentSale.ended = true;
686       SaleEnded(now);
687     }
688 
689     // Send tokens to the investor.
690     require(token().transfer(investor, shares));
691 
692     // Send excess back to the investor.
693     if (excessWei > 0) {
694       investor.transfer(excessWei);
695     }
696 
697     // Trigger event.
698     ProcessedInvestment(investor, weiAmount, shares);
699   }
700 
701   /**
702    * @dev Finalize the in progress sale.
703    */
704   function finalizeSale()
705     public
706     isActive
707     onlySaleCreator
708     onlyWhenSelling
709   {
710     require(currentSale.ended);
711     require(currentSale.sharesSold == currentSale.sharesCap);
712 
713     // Send wei to the beneficiary.
714     currentSale.beneficiary.transfer(currentSale.weiRaised); 
715 
716     // Trigger event.
717     SaleCompleted(currentSale.beneficiary, currentSale.weiRaised, currentSale.sharesSold);
718     
719     // Reset sale.
720     currentSale.exists = false;
721   }
722 
723   /**
724    * @dev Abort the current sale.
725    */
726   function abortSale()
727     public
728     isActive
729     onlySaleCreator
730     onlyWhenSelling
731   {
732     require(!currentSale.ended);
733 
734     address investor = currentSale.investor;
735     address shareholder = currentSale.shareholder;
736     address company = address(this);
737 
738     // Send wei back to the investor.
739     investor.transfer(currentSale.weiRaised);
740 
741     // Send tokens back from the investor to company.
742     require(token().transferFrom(investor, company, currentSale.sharesSold));
743 
744     // Send tokens back from the company to the shareholder.
745     require(token().transferFrom(company, shareholder, currentSale.sharesCap));
746 
747     // Trigger event.
748     SaleAborted(now);
749 
750     // Reset sale state.
751     currentSale.exists = false;
752   }
753 }