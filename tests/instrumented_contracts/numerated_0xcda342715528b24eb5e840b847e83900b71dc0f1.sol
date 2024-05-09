1 pragma solidity ^0.4.11;
2 
3 // Created for conduction of Zaber ICO - http://www.zabercoin.io/
4 // Copying in whole or in part is prohibited.
5 // This code is the property of ICORating and ICOmachine - http://ICORating.com
6 // Authors: Ivan Fedorov and Dmitry Borodin
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
14     	uint256 c = a * b;
15     	assert(a == 0 || c / a == b);
16     	return c;
17 	}
18 
19     function div(uint256 a, uint256 b) internal constant returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this does not hold
23         return c;
24     }
25     
26     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30     
31     function add(uint256 a, uint256 b) internal constant returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34 		return c;
35     }
36 }
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45     
46     
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54     
55     
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63     
64     
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) onlyOwner public{
70         require(newOwner != address(0));
71         owner = newOwner;
72     }
73     
74 }
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81     event Pause();
82     event Unpause();
83     
84     bool _paused = false;
85     
86     function paused() public constant returns(bool)
87     {
88         return _paused;
89     }
90     
91     
92     /**
93      * @dev modifier to allow actions only when the contract IS paused
94      */
95     modifier whenNotPaused() {
96         require(!paused());
97         _;
98     }
99     
100     /**
101      * @dev called by the owner to pause, triggers stopped state
102      */
103     function pause() onlyOwner public {
104         require(!_paused);
105         _paused = true;
106         Pause();
107     }
108     
109     /**
110      * @dev called by the owner to unpause, returns to normal state
111      */
112     function unpause() onlyOwner public {
113         require(_paused);
114         _paused = false;
115         Unpause();
116     }
117 }
118 
119 
120 // Contract interface for transferring current tokens to another
121 contract MigrationAgent
122 {
123     function migrateFrom(address _from, uint256 _value) public;
124 }
125 
126 
127 // (A2)
128 // Contract token
129 contract Token is Pausable{
130     using SafeMath for uint256;
131     
132     string public constant name = "ZABERcoin";
133     string public constant symbol = "ZAB";
134     uint8 public constant decimals = 18;
135     
136     uint256 public totalSupply;
137     
138     mapping(address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140     
141     mapping (address => bool) public unpausedWallet;
142     
143     bool public mintingFinished = false;
144     
145     uint256 public totalMigrated;
146     address public migrationAgent;
147     
148     event Transfer(address indexed from, address indexed to, uint256 value);
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150     
151     event Mint(address indexed to, uint256 amount);
152     event MintFinished();
153     
154     event Migrate(address indexed _from, address indexed _to, uint256 _value);
155     
156     modifier canMint() {
157         require(!mintingFinished);
158         _;
159     }
160     
161     function Token(){
162         owner = 0x0;
163     }    
164     
165     function setOwner() public{
166         require(owner == 0x0);
167         owner = msg.sender;
168     }    
169     
170     // Balance of the specified address
171     function balanceOf(address _owner) public constant returns (uint256 balance) {
172         return balances[_owner];
173     }
174     
175     // Transfer of tokens from one account to another
176     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
177         require (_value > 0);
178         balances[msg.sender] = balances[msg.sender].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         Transfer(msg.sender, _to, _value);
181         return true;
182     }
183     
184     // Returns the number of tokens that _owner trusted to spend from his account _spender
185     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
186         return allowed[_owner][_spender];
187     }
188     
189     // Trust _sender and spend _value tokens from your account
190     function approve(address _spender, uint256 _value) public returns (bool) {
191       
192         // To change the approve amount you first have to reduce the addresses
193         //  allowance to zero by calling `approve(_spender, 0)` if it is not
194         //  already 0 to mitigate the race condition described here:
195         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
197       
198         allowed[msg.sender][_spender] = _value;
199         Approval(msg.sender, _spender, _value);
200         return true;
201     }
202     
203     // Transfer of tokens from the trusted address _from to the address _to in the number _value
204     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
205         var _allowance = allowed[_from][msg.sender];
206       
207         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
208         // require (_value <= _allowance);
209       
210         require (_value > 0);
211       
212         balances[_from] = balances[_from].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         allowed[_from][msg.sender] = _allowance.sub(_value);
215         Transfer(_from, _to, _value);
216         return true;
217     }
218     
219     // Issue new tokens to the address _to in the amount _amount. Available to the owner of the contract (contract Crowdsale)
220     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
221         totalSupply = totalSupply.add(_amount);
222         balances[_to] = balances[_to].add(_amount);
223         Mint(_to, _amount);
224         Transfer(0x0, _to, _amount);
225         return true;
226     }
227     
228     // Stop the release of tokens. This is not possible to cancel. Available to the owner of the contract.
229 	//    function finishMinting() public onlyOwner returns (bool) {
230 	//        mintingFinished = true;
231 	//        MintFinished();
232 	//        return true;
233 	//    }
234     
235     // Redefinition of the method of the returning status of the "Exchange pause". 
236     // Never for the owner of an unpaused wallet.
237     function paused() public constant returns(bool) {
238         return super.paused() && !unpausedWallet[msg.sender];
239     }
240     
241     
242     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
243     function addUnpausedWallet(address _wallet) public onlyOwner {
244         unpausedWallet[_wallet] = true;
245     }
246     
247     // Remove the wallet ignoring the "Exchange pause". Available to the owner of the contract.
248     function delUnpausedWallet(address _wallet) public onlyOwner {
249          unpausedWallet[_wallet] = false;
250     }
251     
252     // Enable the transfer of current tokens to others. Only 1 time. Disabling this is not possible. 
253     // Available to the owner of the contract.
254     function setMigrationAgent(address _migrationAgent) public onlyOwner {
255         require(migrationAgent == 0x0);
256         migrationAgent = _migrationAgent;
257     }
258     
259     // Reissue your tokens.
260     function migrate() public
261     {
262         uint256 value = balances[msg.sender];
263         require(value > 0);
264     
265         totalSupply = totalSupply.sub(value);
266         totalMigrated = totalMigrated.add(value);
267         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
268         Migrate(msg.sender,migrationAgent,value);
269         balances[msg.sender] = 0;
270     }
271 }
272 
273 
274 // (A3)
275 // Contract for freezing of investors' funds. Hence, investors will be able to withdraw money if the 
276 // round does not attain the softcap. From here the wallet of the beneficiary will receive all the 
277 // money (namely, the beneficiary, not the manager's wallet).
278 contract RefundVault is Ownable {
279     using SafeMath for uint256;
280   
281 	uint8 public round = 0;
282 
283 	enum State { Active, Refunding, Closed }
284   
285     mapping (uint8 => mapping (address => uint256)) public deposited;
286 
287     State public state;
288   
289     event Closed();
290     event RefundsEnabled();
291     event Refunded(address indexed beneficiary, uint256 weiAmount);
292   
293     function RefundVault() public {
294         state = State.Active;
295     }
296   
297     // Depositing funds on behalf of an ICO investor. Available to the owner of the contract (Crowdsale Contract).
298     function deposit(address investor) onlyOwner public payable {
299         require(state == State.Active);
300 		deposited[round][investor] = deposited[round][investor].add(msg.value);
301     }
302   
303     // Move the collected funds to a specified address. Available to the owner of the contract.
304     function close(address _wallet) onlyOwner public {
305         require(state == State.Active);
306         require(_wallet != 0x0);
307         state = State.Closed;
308         Closed();
309         _wallet.transfer(this.balance);
310     }
311   
312     // Allow refund to investors. Available to the owner of the contract.
313     function enableRefunds() onlyOwner public {
314         require(state == State.Active);
315         state = State.Refunding;
316         RefundsEnabled();
317     }
318   
319     // Return the funds to a specified investor. In case of failure of the round, the investor 
320     // should call this method of this contract (RefundVault) or call the method claimRefund of Crowdsale 
321     // contract. This function should be called either by the investor himself, or the company 
322     // (or anyone) can call this function in the loop to return funds to all investors en masse.
323     function refund(address investor) public {
324         require(state == State.Refunding);
325 		uint256 depositedValue = deposited[round][investor];
326 		deposited[round][investor] = 0;
327         investor.transfer(depositedValue);
328         Refunded(investor, depositedValue);
329     }
330 
331 	function restart() onlyOwner public{
332 	    require(state == State.Closed);
333 	    round += 1;
334 	    state = State.Active;
335 	}
336   
337     // Destruction of the contract with return of funds to the specified address. Available to
338     // the owner of the contract.
339     function del(address _wallet) public onlyOwner {
340         selfdestruct(_wallet);
341     }
342 }
343 
344 
345 contract DistributorRefundVault is RefundVault{
346  
347     address public taxCollector;
348     uint256 public taxValue;
349     
350     function DistributorRefundVault(address _taxCollector, uint256 _taxValue) RefundVault() public{
351         taxCollector = _taxCollector;
352         taxValue = _taxValue;
353     }
354    
355     function close(address _wallet) onlyOwner public {
356     
357         require(state == State.Active);
358         require(_wallet != 0x0);
359         
360         state = State.Closed;
361         Closed();
362         uint256 allPay = this.balance;
363         uint256 forTarget1;
364         uint256 forTarget2;
365         if(taxValue <= allPay){
366            forTarget1 = taxValue;
367            forTarget2 = allPay.sub(taxValue);
368            taxValue = 0;
369         }else {
370             taxValue = taxValue.sub(allPay);
371             forTarget1 = allPay;
372             forTarget2 = 0;
373         }
374         if(forTarget1 != 0){
375             taxCollector.transfer(forTarget1);
376         }
377        
378         if(forTarget2 != 0){
379             _wallet.transfer(forTarget2);
380         }
381 
382     }
383 
384 }
385 
386 
387 // (A1)
388 // The main contract for the sale and management of rounds.
389 contract Crowdsale{
390     using SafeMath for uint256;
391 
392     enum ICOType {preSale, sale}
393     enum Roles {beneficiary,accountant,manager,observer,team}
394 
395     Token public token;
396 
397     bool public isFinalized = false;
398     bool public isInitialized = false;
399     bool public isPausedCrowdsale = false;
400 
401     mapping (uint8 => address) public wallets;
402 
403     uint256 public maxProfit;   // percent from 0 to 90
404     uint256 public minProfit;   // percent from 0 to 90
405     uint256 public stepProfit;  // percent step, from 1 to 50 (please, read doc!)
406 
407     uint256 public startTime;        // unixtime
408     uint256 public endDiscountTime;  // unixtime
409     uint256 public endTime;          // unixtime
410 
411     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
412     // **THOUSANDS** 10^3 for human, 1**3 for Solidity, 1e3 for MyEtherWallet (MEW). 
413     // Example: if 1ETH = 40.5 Token ==> use 40500
414     uint256 public rate;        
415       
416     // If the round does not attain this value before the closing date, the round is recognized as a 
417     // failure and investors take the money back (the founders will not interfere in any way).
418     // **QUINTILLIONS** 10^18 / 1**18 / 1e18. Example: softcap=15ETH ==> use 15**18 (Solidity) or 15e18 (MEW)
419     uint256 public softCap;
420 
421     // The maximum possible amount of income
422     // **QUINTILLIONS** 10^18 / 1**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450**15 (Solidity) or 12345e15 (MEW)
423     uint256 public hardCap;
424 
425     // If the last payment is slightly higher than the hardcap, then the usual contracts do 
426     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
427     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the 
428     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the 
429     // round closes. The funders should write here a small number, not more than 1% of the CAP.
430     // Can be equal to zero, to cancel.
431     // **QUINTILLIONS** 10^18 / 1**18 / 1e18
432     uint256 public overLimit;
433 
434     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
435     // **QUINTILLIONS** 10^18 / 1**18 / 1e18. Example: minPay=0.1ETH ==> use 100**15 (Solidity) or 100e15 (MEW)
436     uint256 public minPay;
437 
438     uint256 ethWeiRaised;
439     uint256 nonEthWeiRaised;
440     uint256 weiPreSale;
441     uint256 public tokenReserved;
442 
443     DistributorRefundVault public vault;
444 
445     SVTAllocation public lockedAllocation;
446 
447     ICOType ICO = ICOType.preSale;
448 
449     uint256 allToken;
450 
451     bool public team = false;
452 
453     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
454 
455     event Finalized();
456     event Initialized();
457 
458     function Crowdsale(Token _token) public
459     {
460 
461         // Initially, all next 5-7 roles/wallets are given to the Manager. The Manager is an employee of the company 
462         // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require 
463         // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right 
464         // to receive them. To enable this, the Manager must either enter specific wallets here, or perform 
465         // this via method changeWallet. In the finalization methods it is written which wallet and 
466         // what percentage of tokens are received.
467 
468         // Receives all the money (when finalizing pre-ICO & ICO)
469         wallets[uint8(Roles.beneficiary)] = 0x8d6b447f443ce7cAA12399B60BC9E601D03111f9; 
470 
471         // Receives all the tokens for non-ETH investors (when finalizing pre-ICO & ICO)
472         wallets[uint8(Roles.accountant)] = 0x99a280Dc34A996474e5140f34434CE59b5e65879;
473 
474         // All rights except the rights to receive tokens or money. Has the right to change any other 
475         // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the 
476         // round is initialized, the Manager has lost all rights to change the wallets.
477         // If the ICO is conducted by one person, then nothing needs to be changed. Permit all 7 roles 
478         // point to a single wallet.
479         wallets[uint8(Roles.manager)] = msg.sender; 
480 
481         // Has only the right to call paymentsInOtherCurrency (please read the document)
482         wallets[uint8(Roles.observer)] = 0x8baf8F18256952362E485fEF1D0909F21f9a886C;
483 
484         // When the round is finalized, all team tokens are transferred to a special freezing 
485         // contract. As soon as defrosting is over, only the Team wallet will be able to 
486         // collect all the tokens. It does not store the address of the freezing contract, 
487         // but the final wallet of the project team.
488         wallets[uint8(Roles.team)] = 0x25365d4B293Ec34c39C00bBac3e5C5Ff2dC81F4F;
489 
490         // startTime, endDiscountTime, endTime (then you can change it in the setup)
491         changePeriod(1510311600, 1511607600, 1511607600);
492 
493         // softCap & hardCap (then you can change it in the setup)
494         changeTargets(0 ether, 51195 ether); // $15 000 000 / $293
495 
496         // rate (10^3), overLimit (10^18), minPay (10^18) (then you can change it in the setup)
497         changeRate(61250, 500 ether, 10 ether);
498 
499         // minProfit, maxProfit, stepProfit
500         changeDiscount(0,0,0);
501  
502         token = _token;
503         token.setOwner();
504 
505         token.pause(); // block exchange tokens
506 
507         token.addUnpausedWallet(msg.sender);
508 
509         // The return of funds to investors & pay fee for partner 
510         vault = new DistributorRefundVault(0x793ADF4FB1E8a74Dfd548B5E2B5c55b6eeC9a3f8, 10 ether);
511     }
512 
513     // Returns the name of the current round in plain text. Constant.
514     function ICOSaleType()  public constant returns(string){
515         return (ICO == ICOType.preSale)?'pre ICO':'ICO';
516     }
517 
518     // Transfers the funds of the investor to the contract of return of funds. Internal.
519     function forwardFunds() internal {
520         vault.deposit.value(msg.value)(msg.sender);
521     }
522 
523     // Check for the possibility of buying tokens. Inside. Constant.
524     function validPurchase() internal constant returns (bool) {
525 
526         // The round started and did not end
527         bool withinPeriod = (now > startTime && now < endTime);
528 
529         // Rate is greater than or equal to the minimum
530         bool nonZeroPurchase = msg.value >= minPay;
531 
532         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
533         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
534 
535         // round is initialized and no "Pause of trading" is set
536         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isPausedCrowdsale;
537     }
538 
539     // Check for the ability to finalize the round. Constant.
540     function hasEnded() public constant returns (bool) {
541 
542         bool timeReached = now > endTime;
543 
544         bool capReached = weiRaised() >= hardCap;
545 
546         return (timeReached || capReached) && isInitialized;
547     }
548 
549     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then 
550     // anyone can call the finalization to unlock the return of funds to investors
551     // You must call a function to finalize each round (after the pre-ICO & after the ICO)
552     function finalize() public {
553 
554         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender || !goalReached());
555         require(!isFinalized);
556         require(hasEnded());
557 
558         isFinalized = true;
559         finalization();
560         Finalized();
561     }
562 
563     // The logic of finalization. Internal
564     function finalization() internal {
565 
566         // If the goal of the achievement
567         if (goalReached()) {
568 
569             // Send ether to Beneficiary
570 	        vault.close(wallets[uint8(Roles.beneficiary)]);
571 
572             // if there is anything to give
573             if (tokenReserved > 0) {
574 
575                 // Issue tokens of non-eth investors to Accountant account
576                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
577 
578                 // Reset the counter
579                 tokenReserved = 0;
580             }
581 
582             // If the finalization is Round 1 pre-ICO
583             if (ICO == ICOType.preSale) {
584 
585                 // Reset settings
586                 isInitialized = false;
587                 isFinalized = false;
588 
589                 // Switch to the second round (to ICO)
590                 ICO = ICOType.sale;
591 
592                 // Reset the collection counter
593                 weiPreSale = weiRaised();
594                 ethWeiRaised = 0;
595                 nonEthWeiRaised = 0;
596 
597                 // Re-start a refund contract
598                 vault.restart();
599 
600 
601             } 
602             else // If the second round is finalized 
603             { 
604 
605                 // Record how many tokens we have issued
606                 allToken = token.totalSupply();
607 
608                 // Permission to collect tokens to those who can pick them up
609                 team = true;
610             }
611 
612         }
613         else // If they failed round
614         { 
615             // Allow investors to withdraw their funds
616             vault.enableRefunds();
617         }
618     }
619 
620     // The Manager freezes the tokens for the Team.
621     // You must call a function to finalize Round 2 (only after the ICO)
622     function finalize1()  public {
623         require(wallets[uint8(Roles.manager)] == msg.sender);
624         require(team);
625         team = false;
626         lockedAllocation = new SVTAllocation(token, wallets[uint8(Roles.team)]);
627         token.addUnpausedWallet(lockedAllocation);
628         // 20% - tokens to Team wallet after freeze (80% for investors)
629         // *** CHECK THESE NUMBERS ***
630         token.mint(lockedAllocation,allToken.mul(20).div(80));
631     }
632 
633     // Initializing the round. Available to the manager. After calling the function, 
634     // the Manager loses all rights: Manager can not change the settings (setup), change 
635     // wallets, prevent the beginning of the round, etc. You must call a function after setup 
636     // for the initial round (before the Pre-ICO and before the ICO)
637     function initialize() public{
638 
639         // Only the Manager
640         require(wallets[uint8(Roles.manager)] == msg.sender);
641 
642         // If not yet initialized
643         require(!isInitialized);
644 
645         // And the specified start time has not yet come
646         // If initialization return an error, check the start date!
647         require(now <= startTime);
648 
649         initialization();
650 
651         Initialized();
652 
653         isInitialized = true;
654     }
655 
656     function initialization() internal {
657 	    // no code
658     }
659 
660     // At the request of the investor, we raise the funds (if the round has failed because of the hardcap)
661     function claimRefund() public{
662         vault.refund(msg.sender);
663     }
664 
665     // We check whether we collected the necessary minimum funds. Constant.
666     function goalReached() public constant returns (bool) {
667         return weiRaised() >= softCap;
668     }
669 
670     // Customize. The arguments are described in the constructor above.
671     function setup(uint256 _startTime, uint256 _endDiscountTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap, uint256 _rate, uint256 _overLimit, uint256 _minPay, uint256 _minProfit, uint256 _maxProfit, uint256 _stepProfit) public{
672             changePeriod(_startTime, _endDiscountTime, _endTime);
673             changeTargets(_softCap, _hardCap);
674             changeRate(_rate, _overLimit, _minPay);
675             changeDiscount(_minProfit, _maxProfit, _stepProfit);
676     }  
677 
678 	// Change the date and time: the beginning of the round, the end of the bonus, the end of the round. Available to Manager
679     // Description in the Crowdsale constructor
680     function changePeriod(uint256 _startTime, uint256 _endDiscountTime, uint256 _endTime) public{
681 
682         require(wallets[uint8(Roles.manager)] == msg.sender);
683 
684         require(!isInitialized);
685 
686         // Date and time are correct
687         require(now <= _startTime);
688         require(_endDiscountTime > _startTime && _endDiscountTime <= _endTime);
689 
690         startTime = _startTime;
691         endTime = _endTime;
692         endDiscountTime = _endDiscountTime;
693 
694     }
695 
696     // We change the purpose of raising funds. Available to the manager.
697     // Description in the Crowdsale constructor.
698     function changeTargets(uint256 _softCap, uint256 _hardCap) public {
699 
700         require(wallets[uint8(Roles.manager)] == msg.sender);
701 
702         require(!isInitialized);
703 
704         // The parameters are correct
705         require(_softCap <= _hardCap);
706 
707         softCap = _softCap;
708         hardCap = _hardCap;
709     }
710 
711     // Change the price (the number of tokens per 1 eth), the maximum hardCap for the last bet, 
712     // the minimum bet. Available to the Manager.
713     // Description in the Crowdsale constructor
714     function changeRate(uint256 _rate, uint256 _overLimit, uint256 _minPay) public {
715 
716          require(wallets[uint8(Roles.manager)] == msg.sender);
717 
718          require(!isInitialized);
719 
720          require(_rate > 0);
721 
722          rate = _rate;
723          overLimit = _overLimit;
724          minPay = _minPay;
725     }
726 
727     // We change the parameters of the discount:% min bonus,% max bonus, number of steps. 
728     // Available to the manager. Description in the Crowdsale constructor
729     function changeDiscount(uint256 _minProfit, uint256 _maxProfit, uint256 _stepProfit) public {
730 
731         require(wallets[uint8(Roles.manager)] == msg.sender);
732 
733         require(!isInitialized);
734 
735         // The parameters are correct
736         require(_stepProfit <= _maxProfit.sub(_minProfit));
737 
738         // If not zero steps
739         if(_stepProfit > 0){
740             // We will specify the maximum percentage at which it is possible to provide 
741             // the specified number of steps without fractional parts
742             maxProfit = _maxProfit.sub(_minProfit).div(_stepProfit).mul(_stepProfit).add(_minProfit);
743         }else{
744             // to avoid a divide to zero error, set the bonus as static
745             maxProfit = _minProfit;
746         }
747 
748         minProfit = _minProfit;
749         stepProfit = _stepProfit;
750     }
751 
752     // Collected funds for the current round. Constant.
753     function weiRaised() public constant returns(uint256){
754         return ethWeiRaised.add(nonEthWeiRaised);
755     }
756 
757     // Returns the amount of fees for both phases. Constant.
758     function weiTotalRaised() public constant returns(uint256){
759         return weiPreSale.add(weiRaised());
760     }
761 
762     // Returns the percentage of the bonus on the current date. Constant.
763     function getProfitPercent() public constant returns (uint256){
764         return getProfitPercentForData(now);
765     }
766 
767     // Returns the percentage of the bonus on the given date. Constant.
768     function getProfitPercentForData(uint256 timeNow) public constant returns (uint256)
769     {
770         // if the discount is 0 or zero steps, or the round does not start, we return the minimum discount
771         if(maxProfit == 0 || stepProfit == 0 || timeNow > endDiscountTime) {
772             return minProfit.add(100);
773         }
774 
775         // if the round is over - the maximum
776         if(timeNow<=startTime) {
777             return maxProfit.add(100);
778         }
779 
780         // bonus period
781         uint256 range = endDiscountTime.sub(startTime);
782 
783         // delta bonus percentage
784         uint256 profitRange = maxProfit.sub(minProfit);
785 
786         // Time left
787         uint256 timeRest = endDiscountTime.sub(timeNow);
788 
789         // Divide the delta of time into
790         uint256 profitProcent = profitRange.div(stepProfit).mul(timeRest.mul(stepProfit.add(1)).div(range));
791         return profitProcent.add(minProfit).add(100);
792     }
793 
794     // The ability to quickly check pre-ICO (only for Round 1, only 1 time). Completes the pre-ICO by 
795     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager. 
796     // Use only if this is provided by the script and white paper. In the normal scenario, it 
797     // does not call and the funds are raised normally. We recommend that you delete this 
798     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed. 
799     // ** QUINTILIONS **  10^18 / 1**18 / 1e18
800     function fastICO(uint256 _totalSupply) public {
801       require(wallets[uint8(Roles.manager)] == msg.sender);
802       require(ICO == ICOType.preSale && !isInitialized);
803       token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
804       ICO = ICOType.sale;
805     }
806     
807     // Remove the "Pause of exchange". Available to the manager at any time. If the 
808     // manager refuses to remove the pause, then 120 days after the successful 
809     // completion of the ICO, anyone can remove a pause and allow the exchange to continue. 
810     // The manager does not interfere and will not be able to delay the term. 
811     // He can only cancel the pause before the appointed time.
812     function tokenUnpause() public {
813         require(wallets[uint8(Roles.manager)] == msg.sender 
814         	|| (now > endTime + 120 days && ICO == ICOType.sale && isFinalized && goalReached()));
815         token.unpause();
816     }
817 
818     // Enable the "Pause of exchange". Available to the manager until the ICO is completed.
819     // The manager cannot turn on the pause, for example, 3 years after the end of the ICO.
820     function tokenPause() public {
821         require(wallets[uint8(Roles.manager)] == msg.sender && !isFinalized);
822         token.pause();
823     }
824     
825     // Pause of sale. Available to the manager.
826     function crowdsalePause() public {
827         require(wallets[uint8(Roles.manager)] == msg.sender);
828         require(isPausedCrowdsale == false);
829         isPausedCrowdsale = true;
830     }
831 
832     // Withdrawal from the pause of sale. Available to the manager.
833     function crowdsaleUnpause() public {
834         require(wallets[uint8(Roles.manager)] == msg.sender);
835         require(isPausedCrowdsale == true);
836         isPausedCrowdsale = false;
837     }
838 
839     // Checking whether the rights to address ignore the "Pause of exchange". If the 
840     // wallet is included in this list, it can translate tokens, ignoring the pause. By default, 
841     // only the following wallets are included: 
842     //    - Accountant wallet (he should immediately transfer tokens, but not to non-ETH investors)
843     //    - Contract for freezing the tokens for the Team (but Team wallet not included)
844     // Inside. Constant.
845     function unpausedWallet(address _wallet) internal constant returns(bool) {
846         bool _accountant = wallets[uint8(Roles.accountant)] == _wallet;
847         return _accountant;
848     }
849 
850     // For example - After 5 years of the project's existence, all of us suddenly decided collectively 
851     // (company + investors) that it would be more profitable for everyone to switch to another smart 
852     // contract responsible for tokens. The company then prepares a new token, investors 
853     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
854 	//      - to burn the tokens of the previous contract
855 	//      - generate new tokens for a new contract
856 	// It is understood that after a general solution through this function all investors 
857 	// will collectively (and voluntarily) move to a new token.
858     function moveTokens(address _migrationAgent) public {
859         require(wallets[uint8(Roles.manager)] == msg.sender);
860         token.setMigrationAgent(_migrationAgent);
861     }
862 
863 	// Change the address for the specified role.
864 	// Available to any wallet owner except the observer.
865 	// Available to the manager until the round is initialized.
866 	// The Observer's wallet or his own manager can change at any time.
867     function changeWallet(Roles _role, address _wallet) public
868     {
869         require(
870         		(msg.sender == wallets[uint8(_role)] && _role != Roles.observer)
871       		||
872       			(msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer))
873       	);
874         address oldWallet = wallets[uint8(_role)];
875         wallets[uint8(_role)] = _wallet;
876         if(!unpausedWallet(oldWallet))
877             token.delUnpausedWallet(oldWallet);
878         if(unpausedWallet(_wallet))
879             token.addUnpausedWallet(_wallet);
880     }
881 
882     // If a little more than a year has elapsed (ICO start date + 460 days), a smart contract 
883     // will allow you to send all the money to the Beneficiary, if any money is present. This is 
884     // possible if you mistakenly launch the ICO for 30 years (not 30 days), investors will transfer 
885     // money there and you will not be able to pick them up within a reasonable time. It is also 
886     // possible that in our checked script someone will make unforeseen mistakes, spoiling the 
887     // finalization. Without finalization, money cannot be returned. This is a rescue option to 
888     // get around this problem, but available only after a year (460 days).
889 
890 	// Another reason - the ICO was a failure, but not all ETH investors took their money during the year after. 
891 	// Some investors may have lost a wallet key, for example.
892 
893 	// The method works equally with the pre-ICO and ICO. When the pre-ICO starts, the time for unlocking 
894 	// the distructVault begins. If the ICO is then started, then the term starts anew from the first day of the ICO.
895 
896 	// Next, act independently, in accordance with obligations to investors.
897 
898 	// Within 400 days of the start of the Round, if it fails only investors can take money. After 
899 	// the deadline this can also include the company as well as investors, depending on who is the first to use the method.
900     function distructVault() public {
901         require(wallets[uint8(Roles.beneficiary)] == msg.sender);
902         require(now > startTime + 400 days);
903         vault.del(wallets[uint8(Roles.beneficiary)]);
904     }
905 
906 
907 	// We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC). 
908 	// Perhaps other types of cryptocurrency - see the original terms in the white paper and on the ICO website.
909 
910 	// We release tokens on Ethereum. During the pre-ICO and ICO with a smart contract, you directly transfer 
911 	// the tokens there and immediately, with the same transaction, receive tokens in your wallet.
912 
913 	// When paying in any other currency, for example in BTC, we accept your money via one common wallet. 
914 	// Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart 
915     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis. 
916     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract 
917     // monitors softcap and hardcap, so as not to go beyond this framework.
918 	
919 	// In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several 
920 	// transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total. 
921 	// In this case, we will refund all the amounts above, in order not to exceed the hardcap.
922 
923 	// Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published 
924 	// everywhere (in a white paper, on the ICO website, on Telegram, on Bitcointalk, in this code, etc.)
925 	// Anyone interested can check that the administrator of the smart contract writes down exactly the amount 
926 	// in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in 
927 	// BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to 
928 	// paymentsInOtherCurrency however, this threat is leveled.
929 	
930 	// Any user can check the amounts in BTC and the variable of the smart contract that accounts for this 
931 	// (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract 
932 	// on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the ICO, 
933 	// simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection) 
934 	// and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
935 	
936 	// The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you 
937 	// cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as 
938 	// brakes on the Ethereum network, this operation may be difficult. You should only worry if the 
939 	// administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
940 	// receives significant amounts. 
941 	
942 	// This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
943 
944     // Our BTC wallet for audit in this function: 1CAyLcES1tNuatRhnL1ooPViZ32vF5KQ4A
945 
946     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
947     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
948         require(wallets[uint8(Roles.observer)] == msg.sender);
949         bool withinPeriod = (now >= startTime && now <= endTime);
950         
951         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
952         require(withinPeriod && withinCap && isInitialized);
953 
954         nonEthWeiRaised = _value;
955         tokenReserved = _token;
956 
957     }
958 
959     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is 
960     // transferred to the buyer, taking into account the current bonus.
961     function buyTokens(address beneficiary) public payable {
962         require(beneficiary != 0x0);
963         require(validPurchase());
964 
965         uint256 weiAmount = msg.value;
966 
967         uint256 ProfitProcent = getProfitPercent();
968         // calculate token amount to be created
969         uint256 tokens = weiAmount.mul(rate).mul(ProfitProcent).div(100000);
970 
971         // update state
972         ethWeiRaised = ethWeiRaised.add(weiAmount);
973 
974         token.mint(beneficiary, tokens);
975         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
976 
977         forwardFunds();
978     }
979 
980     // buyTokens alias 
981     function () public payable {
982         buyTokens(msg.sender);
983     }
984 
985 }
986 
987 // (B)
988 // The contract for freezing tokens for the team..
989 contract SVTAllocation {
990     using SafeMath for uint256;
991 
992     Token public token;
993 
994 	address public owner;
995 
996     uint256 public unlockedAt;
997 
998     uint256 tokensCreated = 0;
999 
1000     // The contract takes the ERC20 coin address from which this contract will work and from the 
1001     // owner (Team wallet) who owns the funds.
1002     function SVTAllocation(Token _token, address _owner) public{
1003 
1004     	// How many days to freeze from the moment of finalizing ICO
1005         unlockedAt = now + 365 days; // freeze TEAM tokens for 1 year
1006         token = _token;
1007         owner = _owner;
1008     }
1009 
1010     // If the time of freezing expired will return the funds to the owner.
1011     function unlock() public{
1012         require(now >= unlockedAt);
1013         require(token.transfer(owner,token.balanceOf(this)));
1014     }
1015 }