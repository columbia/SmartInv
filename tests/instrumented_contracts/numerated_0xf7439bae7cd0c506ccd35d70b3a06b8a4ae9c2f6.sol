1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4     address public owner=0x28970854Bfa61C0d6fE56Cc9daAAe5271CEaEC09;
5 
6 
7     /**
8      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9      * account.
10      */
11     constructor()public {
12         owner = msg.sender;
13     }
14 
15 
16     /**
17      * @dev Throws if called by any account other than the owner.
18      */
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24 
25     /**
26      * @dev Allows the current owner to transfer control of the contract to a newOwner.
27      * @param newOwner The address to transfer ownership to.
28      */
29     function transferOwnership(address newOwner) onlyOwner public {
30         require(newOwner != address(0));
31         owner = newOwner;
32     }
33 
34 }
35 contract PricingStrategy {
36 
37   /** Interface declaration. */
38   function isPricingStrategy() public pure  returns (bool) {
39     return true;
40   }
41 
42   /** Self check if all references are correctly set.
43    *
44    * Checks that pricing strategy matches crowdsale parameters.
45    */
46   function isSane() public pure returns (bool) {
47     return true;
48   }
49 
50   /**
51    * @dev Pricing tells if this is a presale purchase or not.
52      @param purchaser Address of the purchaser
53      @return False by default, true if a presale purchaser
54    */
55   function isPresalePurchase(address purchaser) public pure returns (bool) {
56     return false;
57   }
58 
59   /**
60    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
61    *
62    *
63    * @param value - What is the value of the transaction send in as wei
64    * @param tokensSold - how much tokens have been sold this far
65    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
66    * @param msgSender - who is the investor of this transaction
67    * @param decimals - how many decimal units the token has
68    * @return Amount of tokens the investor receives
69    */
70   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public pure returns (uint tokenAmount){
71       
72   }
73   
74 }
75 contract FinalizeAgent {
76 
77   function isFinalizeAgent() public pure returns(bool) {
78     return true;
79   }
80 
81   /** Return true if we can run finalizeCrowdsale() properly.
82    *
83    * This is a safety check function that doesn't allow crowdsale to begin
84    * unless the finalizer has been set up properly.
85    */
86   function isSane() public pure returns (bool){
87       return true;
88 }
89   /** Called once by crowdsale finalize() if the sale was success. */
90   function finalizeCrowdsale() pure public{
91      
92   }
93   
94 
95 }
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102     if (a == 0) {
103       return 0;
104     }
105     uint256 c = a * b;
106     assert(c / a == b);
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers, truncating the quotient.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     // uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return a / b;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   /**
129   * @dev Adds two numbers, throws on overflow.
130   */
131   function add(uint256 a, uint256 b) internal pure returns (uint256) {
132     uint256 c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 contract UbricoinPresale {
138 
139     /*/
140      *  Token state
141     /*/
142 
143     enum Phase {
144         Created,
145         Running,
146         Paused,
147         Migrating,
148         Migrated
149     }
150 
151     Phase public currentPhase = Phase.Created;
152     uint public totalSupply = 0; // amount of tokens already sold
153     
154 
155     // Token manager has exclusive priveleges to call administrative
156     // functions on this contract.
157     address public tokenManager;
158 
159     // Gathered funds can be withdrawn only to escrow's address.
160     address public escrow;
161 
162     // Crowdsale manager has exclusive priveleges to burn presale tokens.
163     address public crowdsaleManager;
164 
165     mapping (address => uint256) private balance;
166 
167 
168     modifier onlyTokenManager()     { if(msg.sender != tokenManager) revert(); _; }
169     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) revert(); _; }
170 
171 
172     /*/
173      *  Events
174     /*/
175 
176     event LogBuy(address indexed owner, uint256 value);
177     event LogBurn(address indexed owner, uint256 value);
178     event LogPhaseSwitch(Phase newPhase);
179 
180 
181     /*/
182      *  Public functions
183     /*/
184 
185  
186     /// @dev Returns number of tokens owned by given address.
187     /// @param _owner Address of token owner.
188     function burnTokens(address _owner) public
189         onlyCrowdsaleManager
190     {
191         // Available only during migration phase
192         if(currentPhase != Phase.Migrating) revert();
193 
194         uint256 tokens = balance[_owner];
195         if(tokens == 0) revert();
196         balance[_owner] = 0;
197         
198         emit LogBurn(_owner, tokens);
199 
200         // Automatically switch phase when migration is done.
201        
202     }
203 
204     /*/
205      *  Administrative functions
206     /*/
207 
208     function setPresalePhase(Phase _nextPhase) public
209         onlyTokenManager
210     {
211         bool canSwitchPhase
212             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
213             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
214                 // switch to migration phase only if crowdsale manager is set
215             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
216                 && _nextPhase == Phase.Migrating
217                 && crowdsaleManager != 0x0)
218             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
219                 // switch to migrated only if everyting is migrated
220             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
221                 && totalSupply == 0);
222 
223         if(!canSwitchPhase) revert();
224         currentPhase = _nextPhase;
225         emit LogPhaseSwitch(_nextPhase); 
226            
227     }
228 
229 
230     function withdrawEther() public
231         onlyTokenManager
232     {
233         // Available at any phase.
234         if(address(this).balance > 0) {
235             if(!escrow.send(address(this).balance)) revert();
236         }
237     }
238 
239 
240     function setCrowdsaleManager(address _mgr) public
241         onlyTokenManager
242     {
243         // You can't change crowdsale contract when migration is in progress.
244         if(currentPhase == Phase.Migrating) revert();
245         crowdsaleManager = _mgr;
246     }
247 }
248 contract Haltable is Ownable  {
249     
250   bool public halted;
251   
252    modifier stopInEmergency {
253     if (halted) revert();
254     _;
255   }
256 
257   modifier stopNonOwnersInEmergency {
258     if (halted && msg.sender != owner) revert();
259     _;
260   }
261 
262   modifier onlyInEmergency {
263     if (!halted) revert();
264     _;
265   }
266 
267   // called by the owner on emergency, triggers stopped state
268   function halt() external onlyOwner {
269     halted = true;
270   }
271 
272   // called by the owner on end of emergency, returns to normal state
273   function unhalt() external onlyOwner onlyInEmergency {
274     halted = false;
275   }
276 
277 }
278 contract WhitelistedCrowdsale is Ownable {
279 
280   mapping(address => bool) public whitelist;
281 
282   /**
283    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
284    */
285   modifier isWhitelisted(address _beneficiary) {
286     require(whitelist[_beneficiary]);
287     _;
288   }
289   
290   /**
291    * @dev Adds single address to whitelist.
292    * @param _beneficiary Address to be added to the whitelist
293    */
294   function addToWhitelist(address _beneficiary) onlyOwner public  {
295     whitelist[_beneficiary] = true;
296   }
297 
298   /**
299    * @dev Adds list of addresses to whitelist. 
300    * @param _beneficiaries Addresses to be added to the whitelist
301    */
302   function addManyToWhitelist(address[] _beneficiaries) onlyOwner public {
303     for (uint256 i = 0; i < _beneficiaries.length; i++) {
304       whitelist[_beneficiaries[i]] = true;
305     }
306   }
307 
308   /**
309    * @dev Removes single address from whitelist.
310    * @param _beneficiary Address to be removed to the whitelist
311    */
312   function removeFromWhitelist(address _beneficiary)onlyOwner public {
313     whitelist[_beneficiary] = false;
314   }
315 
316   /**
317    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
318    * @param _beneficiary Token beneficiary
319    * @param _weiAmount Amount of wei contributed
320    */
321   
322 }
323 
324    contract UbricoinCrowdsale is FinalizeAgent,WhitelistedCrowdsale {
325     using SafeMath for uint256;
326     address public beneficiary;
327     uint256 public fundingGoal;
328     uint256 public amountRaised;
329     uint256 public deadline;
330        
331     mapping(address => uint256) public balanceOf;
332     bool fundingGoalReached = false;
333     bool crowdsaleClosed = false;
334     uint256 public investorCount = 0;
335     
336     bool public requiredSignedAddress;
337     bool public requireCustomerId;
338     
339 
340     bool public paused = false;
341 
342     
343     event GoalReached(address recipient, uint256 totalAmountRaised);
344     event FundTransfer(address backer, uint256 amount, bool isContribution);
345     
346     // A new investment was made
347     event Invested(address investor, uint256 weiAmount, uint256 tokenAmount, uint256 customerId);
348 
349   // The rules were changed what kind of investments we accept
350     event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
351     event Pause();
352     event Unpause();
353  
354      
355  
356     modifier afterDeadline() { if (now >= deadline) _; }
357     
358 
359     /**
360      * Check if goal was reached
361      *
362      * Checks if the goal or time limit has been reached and ends the campaign
363      */
364      
365     function invest(address ) public payable {
366     if(requireCustomerId) revert(); // Crowdsale needs to track partipants for thank you email
367     if(requiredSignedAddress) revert(); // Crowdsale allows only server-side signed participants
368    
369   }
370      
371     function investWithCustomerId(address , uint256 customerId) public payable {
372     if(requiredSignedAddress) revert(); // Crowdsale allows only server-side signed participants
373     if(customerId == 0)revert();  // UUIDv4 sanity check
374 
375   }
376   
377     function buyWithCustomerId(uint256 customerId) public payable {
378     investWithCustomerId(msg.sender, customerId);
379   }
380      
381      
382     function checkGoalReached() afterDeadline public {
383         if (amountRaised >= fundingGoal){
384             fundingGoalReached = true;
385             emit GoalReached(beneficiary, amountRaised);
386         }
387         crowdsaleClosed = true;
388     }
389 
390    
391 
392     /**
393      * Withdraw the funds
394      *
395      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
396      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
397      * the amount they contributed.
398      */
399     function safeWithdrawal() afterDeadline public {
400         if (!fundingGoalReached) {
401             uint256 amount = balanceOf[msg.sender];
402             balanceOf[msg.sender] = 0;
403             if (amount > 0) {
404                 if (msg.sender.send(amount)) {
405                 emit FundTransfer(beneficiary,amountRaised,false);
406                 } else {
407                     balanceOf[msg.sender] = amount;
408                 }
409             }
410         }
411 
412         if  (fundingGoalReached && beneficiary == msg.sender) {
413             if (beneficiary.send(amountRaised)) {
414                emit FundTransfer(beneficiary,amountRaised,false);
415             } else {
416                 //If we fail to send the funds to beneficiary, unlock funders balance
417                 fundingGoalReached = false;
418             }
419         }
420     }
421     
422      /**
423    * @dev modifier to allow actions only when the contract IS paused
424    */
425   modifier whenNotPaused() {
426     require(!paused);
427     _;
428   }
429 
430   /**
431    * @dev modifier to allow actions only when the contract IS NOT paused
432    */
433   modifier whenPaused {
434     require(paused);
435     _;
436   }
437 
438   /**
439    * @dev called by the owner to pause, triggers stopped state
440    */
441   function pause() onlyOwner whenNotPaused public returns (bool) {
442     paused = true;
443     emit Pause();
444     return true;
445   }
446 
447   /**
448    * @dev called by the owner to unpause, returns to normal state
449    */
450   function unpause() onlyOwner whenPaused public returns (bool) {
451     paused = false;
452     emit Unpause();
453     return true;
454   }
455 
456 }
457 contract Upgradeable {
458     mapping(bytes4=>uint32) _sizes;
459     address _dest;
460 
461     /**
462      * This function is called using delegatecall from the dispatcher when the
463      * target contract is first initialized. It should use this opportunity to
464      * insert any return data sizes in _sizes, and perform any other upgrades
465      * necessary to change over from the old contract implementation (if any).
466      * 
467      * Implementers of this function should either perform strictly harmless,
468      * idempotent operations like setting return sizes, or use some form of
469      * access control, to prevent outside callers.
470      */
471     function initialize() public{
472         
473     }
474     
475     /**
476      * Performs a handover to a new implementing contract.
477      */
478     function replace(address target) internal {
479         _dest = target;
480         require(target.delegatecall(bytes4(keccak256("initialize()"))));
481     }
482 }
483 /**
484  * The dispatcher is a minimal 'shim' that dispatches calls to a targeted
485  * contract. Calls are made using 'delegatecall', meaning all storage and value
486  * is kept on the dispatcher. As a result, when the target is updated, the new
487  * contract inherits all the stored data and value from the old contract.
488  */
489 contract Dispatcher is Upgradeable {
490     
491     constructor (address target) public {
492         replace(target);
493     }
494     
495     function initialize() public {
496         // Should only be called by on target contracts, not on the dispatcher
497         revert();
498     }
499 
500     function() public {
501         uint len;
502         address target;
503         bytes4 sig;
504         assembly { sig := calldataload(0) }
505         len = _sizes[sig];
506         target = _dest;
507         
508         bool ret;
509         assembly {
510             // return _dest.delegatecall(msg.data)
511             calldatacopy(0x0, 0x0, calldatasize)
512             ret:=delegatecall(sub(gas, 10000), target, 0x0, calldatasize, 0, len)
513             return(0, len)
514         }
515         if (!ret) revert();
516     }
517 }
518 contract Example is Upgradeable {
519     uint _value;
520     
521     function initialize() public {
522         _sizes[bytes4(keccak256("getUint()"))] = 32;
523     }
524     
525     function getUint() public view returns (uint) {
526         return _value;
527     }
528     
529     function setUint(uint value) public {
530         _value = value;
531     }
532 }
533 interface tokenRecipient { 
534     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)external;
535     
536 }
537 
538  /**
539  * @title Ownable
540  * @dev The Ownable contract has an owner address, and provides basic authorization control
541  * functions, this simplifies the implementation of "user permissions".
542  */
543 
544 contract Ubricoin is UbricoinPresale,Ownable,Haltable, UbricoinCrowdsale,Upgradeable {
545     
546     using SafeMath for uint256;
547     
548     // Public variables of the token
549     string public name ='Ubricoin';
550     string public symbol ='UBN';
551     string public version= "1.0";
552     uint public decimals=18;
553     // 18 decimals is the strongly suggested default, avoid changing it
554     uint public totalSupply = 10000000000;
555     uint256 public constant RATE = 1000;
556     uint256 initialSupply;
557 
558     
559     
560     // This creates an array with all balances
561     mapping (address => uint256) public balanceOf;
562     mapping (address => mapping (address => uint256)) public allowance;
563     
564     // This generates a public event on the blockchain that will notify clients
565     event Transfer(address indexed from, address indexed to, uint256 value);
566     
567     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
568     
569     uint256 public AVAILABLE_AIRDROP_SUPPLY = 100000000* decimals; // 100% Released at Token distribution
570     uint256 public grandTotalClaimed = 1;
571     uint256 public startTime;
572     
573     struct Allocation {
574     uint8 AllocationSupply; // Type of allocation
575     uint256 totalAllocated; // Total tokens allocated
576     uint256 amountClaimed;  // Total tokens claimed
577 }
578     
579     
580     mapping (address => Allocation) public allocations;
581 
582     // List of admins
583     mapping (address => bool) public airdropAdmins;
584 
585     // Keeps track of whether or not an Ubricoin airdrop has been made to a particular address
586     mapping (address => bool) public airdrops;
587 
588   modifier onlyOwnerOrAdmin() {
589     require(msg.sender == owner || airdropAdmins[msg.sender]);
590     _;
591 }
592     
593     
594     
595     // This notifies clients about the amount burnt
596     event Burn(address indexed from, uint256 value);
597 
598         bytes32 public currentChallenge;                         // The coin starts with a challenge
599         uint256 public timeOfLastProof;                             // Variable to keep track of when rewards were given
600         uint256 public difficulty = 10**32;                         // Difficulty starts reasonably low
601 
602      
603     function proofOfWork(uint256 nonce) public{
604         bytes8 n = bytes8(keccak256(abi.encodePacked(nonce, currentChallenge)));    // Generate a random hash based on input
605         require(n >= bytes8(difficulty));                   // Check if it's under the difficulty
606 
607         uint256 timeSinceLastProof = (now - timeOfLastProof);  // Calculate time since last reward was given
608         require(timeSinceLastProof >=  5 seconds);         // Rewards cannot be given too quickly
609         balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  // The reward to the winner grows by the minute
610 
611         difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;  // Adjusts the difficulty
612 
613         timeOfLastProof = now;                              // Reset the counter
614         currentChallenge = keccak256(abi.encodePacked(nonce, currentChallenge, blockhash(block.number - 1)));  // Save a hash that will be used as the next proof
615     }
616 
617 
618    function () payable public whenNotPaused {
619         require(msg.value > 0);
620         uint256 tokens = msg.value.mul(RATE);
621         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
622         totalSupply = totalSupply.add(tokens);
623         owner.transfer(msg.value);
624 }
625     
626     /**
627      * Internal transfer, only can be called by this contract
628      */
629     function _transfer(address _from, address _to, uint256 _value) internal {
630         // Prevent transfer to 0x0 address. Use burn() instead
631         require(_to != 0x0);
632         // Check if the sender has enough
633         require(balanceOf[_from] >= _value);
634         // Check for overflows
635         require(balanceOf[_to] + _value >= balanceOf[_to]);
636         // Save this for an assertion in the future
637         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
638         // Subtract from the sender
639         balanceOf[_from] -= _value;
640         // Add the same to the recipient
641         balanceOf[_to] += _value;
642         emit Transfer(_from, _to, _value);
643         // Asserts are used to use static analysis to find bugs in your code. They should never fail
644         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
645     }
646 
647     /**
648      * Transfer tokens
649      *
650      * Send `_value` tokens to `_to` from your account
651      *
652      * @param _to The address of the recipient
653      * @param _value the amount to send
654      */
655      function transfer(address _to, uint256 _value) public {
656 		balanceOf[msg.sender] -= _value;
657 		balanceOf[_to] += _value;
658 	}
659      
660    function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
661         return balanceOf[tokenOwner];
662         
663 }
664 
665    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
666         return allowance[tokenOwner][spender];
667 }
668    
669     /**
670      * Transfer tokens from other address
671      *
672      * Send `_value` tokens to `_to` on behalf of `_from`
673      *
674      * @param _from The address of the sender
675      * @param _to The address of the recipient
676      * @param _value the amount to send
677      */
678     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
679         require(_value <= allowance[_from][msg.sender]);     // Check allowance
680         allowance[_from][msg.sender] -= _value;
681         _transfer(_from, _to, _value);
682         return true;
683     }
684 
685     /**
686      * Set allowance for other address
687      *
688      * Allows `_spender` to spend no more than `_value` tokens on your behalf
689      *
690      * @param _spender The address authorized to spend
691      * @param _value the max amount they can spend
692      */
693     function approve(address _spender, uint256 _value) public
694         returns (bool success) {
695         allowance[msg.sender][_spender] = _value;
696         return true;
697     }
698 
699     /**
700      * Set allowance for other address and notify
701      *
702      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
703      *
704      * @param _spender The address authorized to spend
705      * @param _value the max amount they can spend
706      * @param _extraData some extra information to send to the approved contract
707      */
708     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
709         public
710         returns (bool success) {
711         tokenRecipient spender = tokenRecipient(_spender);
712         if (approve(_spender, _value)) {
713             spender.receiveApproval(msg.sender, _value, this, _extraData);
714             return true;
715         }
716     }
717 
718     /**
719      * Destroy tokens
720      *
721      * Remove `_value` tokens from the system irreversibly
722      *
723      * @param _value the amount of money to burn
724      */
725     function burn(uint256 _value) public returns (bool success) {
726         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
727         balanceOf[msg.sender] -= _value;            // Subtract from the sender
728         totalSupply -= _value;                      // Updates totalSupply
729         emit Burn(msg.sender, _value);
730         return true;
731     }
732   
733     function mintToken(address target, uint256 mintedAmount)private onlyOwner {
734         balanceOf[target] += mintedAmount;
735         totalSupply += mintedAmount;
736         emit Transfer(0, owner, mintedAmount);
737         emit Transfer(owner, target, mintedAmount);
738     }
739 
740     function validPurchase() internal returns (bool) {
741     bool lessThanMaxInvestment = msg.value <= 1000 ether; // change the value to whatever you need
742     return validPurchase() && lessThanMaxInvestment;
743 }
744 
745     /**
746      * Destroy tokens from other account
747      *
748      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
749      *
750      * @param _from the address of the sender
751      * @param _value the amount of money to burn
752      */
753     function burnFrom(address _from, uint256 _value) public returns (bool success) {
754         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
755         require(_value <= allowance[_from][msg.sender]);    // Check allowance
756         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
757         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
758         totalSupply -= _value;                              // Update totalSupply
759         emit Burn(_from, _value);
760         return true;
761     }
762     
763    /**
764     * @dev Add an airdrop admin
765     */
766   function setAirdropAdmin(address _admin, bool _isAdmin) public onlyOwner {
767     airdropAdmins[_admin] = _isAdmin;
768   }
769 
770   /**
771     * @dev perform a transfer of allocations
772     * @param _recipient is a list of recipients
773     */
774   function airdropTokens(address[] _recipient) public onlyOwnerOrAdmin {
775     
776     uint airdropped;
777     for(uint256 i = 0; i< _recipient.length; i++)
778     {
779         if (!airdrops[_recipient[i]]) {
780           airdrops[_recipient[i]] = true;
781           Ubricoin.transfer(_recipient[i], 1 * decimals);
782           airdropped = airdropped.add(1 * decimals);
783         }
784     }
785     AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
786     totalSupply = totalSupply.sub(airdropped);
787     grandTotalClaimed = grandTotalClaimed.add(airdropped);
788 }
789     
790 }