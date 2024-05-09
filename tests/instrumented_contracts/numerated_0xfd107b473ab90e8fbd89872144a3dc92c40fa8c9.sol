1 pragma solidity ^0.4.18;
2 
3 contract SafeMathLib {
4   
5   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function safeAdd(uint256 a, uint256 b) internal pure  returns (uint256) {
20     uint c = a + b;
21     assert(c>=a);
22     return c;
23   }
24   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control 
35  * functions, this simplifies the implementation of "user permissions". 
36  */
37 contract Ownable {
38   address public owner;
39   address public newOwner;
40   event OwnershipTransferred(address indexed _from, address indexed _to);
41   /** 
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49 
50   /**
51    * @dev Throws if called by any account other than the owner. 
52    */
53   modifier onlyOwner {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to. 
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     newOwner = _newOwner;
64   }
65 
66   function acceptOwnership() public {
67     require(msg.sender == newOwner);
68     OwnershipTransferred(owner, newOwner);
69     owner =  newOwner;
70   }
71 
72 }
73 
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20Basic {
80   uint256 public totalSupply;
81   function balanceOf(address who) public view returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public view returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * A token that defines fractional units as decimals.
99  */
100 contract FractionalERC20 is ERC20 {
101   uint8 public decimals;
102 }
103 
104 /**
105  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
106  *
107  * Based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, SafeMathLib {
111   /* Token supply got increased and a new owner received these tokens */
112   event Minted(address receiver, uint256 amount);
113 
114   /* Actual balances of token holders */
115   mapping(address => uint) balances;
116 
117   /* approve() allowances */
118   mapping (address => mapping (address => uint256)) allowed;
119 
120   function transfer(address _to, uint256 _value)
121   public
122   returns (bool) 
123   { 
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = safeSub(balances[msg.sender],_value);
129     balances[_to] = safeAdd(balances[_to],_value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132     
133   }
134 
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     uint _allowance = allowed[_from][msg.sender];
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= _allowance);
140     require(balances[_to] + _value > balances[_to]);
141 
142     balances[_to] = safeAdd(balances[_to],_value);
143     balances[_from] = safeSub(balances[_from],_value);
144     allowed[_from][msg.sender] = safeSub(_allowance,_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   function balanceOf(address _owner) public constant returns (uint balance) {
150     return balances[_owner];
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163 
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180    /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 /**
219  * Upgrade agent interface inspired by Lunyr.
220  *
221  * Upgrade agent transfers tokens to a new contract.
222  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
223  */
224 contract UpgradeAgent {
225   uint public originalSupply;
226   /** Interface marker */
227   function isUpgradeAgent() public pure returns (bool) {
228     return true;
229   }
230   function upgradeFrom(address _from, uint256 _value) public;
231 }
232 
233 /**
234  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
235  *
236  * First envisioned by Golem and Lunyr projects.
237  */
238 contract UpgradeableToken is StandardToken {
239 
240   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
241   address public upgradeMaster;
242 
243   /** The next contract where the tokens will be migrated. */
244   UpgradeAgent public upgradeAgent;
245 
246   /** How many tokens we have upgraded by now. */
247   uint256 public totalUpgraded;
248 
249   /**
250    * Upgrade states.
251    *
252    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
253    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
254    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
255    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
256    *
257    */
258   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
259 
260   /**
261    * Somebody has upgraded some of his tokens.
262    */
263   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
264 
265   /**
266    * New upgrade agent available.
267    */
268   event UpgradeAgentSet(address agent);
269 
270   /**
271    * Do not allow construction without upgrade master set.
272    */
273   function UpgradeableToken(address _upgradeMaster) public {
274     upgradeMaster = _upgradeMaster;
275   }
276 
277   /**
278    * Allow the token holder to upgrade some of their tokens to a new contract.
279    */
280   function upgrade(uint256 value) public {
281     UpgradeState state = getUpgradeState();
282     require((state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
283 
284     // Validate input value.
285     require (value != 0);
286 
287     balances[msg.sender] = safeSub(balances[msg.sender],value);
288 
289     // Take tokens out from circulation
290     totalSupply = safeSub(totalSupply,value);
291     totalUpgraded = safeAdd(totalUpgraded,value);
292 
293     // Upgrade agent reissues the tokens
294     upgradeAgent.upgradeFrom(msg.sender, value);
295     Upgrade(msg.sender, upgradeAgent, value);
296   }
297 
298   /**
299    * Set an upgrade agent that handles
300    */
301   function setUpgradeAgent(address agent) external {
302     require(canUpgrade());
303 
304     require(agent != 0x0);
305     // Only a master can designate the next agent
306     require(msg.sender == upgradeMaster);
307     // Upgrade has already begun for an agent
308     require(getUpgradeState() != UpgradeState.Upgrading);
309 
310     upgradeAgent = UpgradeAgent(agent);
311 
312     // Bad interface
313     require(upgradeAgent.isUpgradeAgent());
314     // Make sure that token supplies match in source and target
315     require(upgradeAgent.originalSupply() == totalSupply);
316 
317     UpgradeAgentSet(upgradeAgent);
318   }
319 
320   /**
321    * Get the state of the token upgrade.
322    */
323   function getUpgradeState() public constant returns(UpgradeState) {
324     if(!canUpgrade()) return UpgradeState.NotAllowed;
325     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
326     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
327     else return UpgradeState.Upgrading;
328   }
329 
330   /**
331    * Change the upgrade master.
332    *
333    * This allows us to set a new owner for the upgrade mechanism.
334    */
335   function setUpgradeMaster(address master) public {
336     require(master != 0x0);
337     require(msg.sender == upgradeMaster);
338     upgradeMaster = master;
339   }
340 
341   /**
342    * Child contract can enable to provide the condition when the upgrade can begun.
343    */
344   function canUpgrade() public view returns(bool) {
345      return true;
346   }
347 
348 }
349 
350 /**
351  * Define interface for releasing the token transfer after a successful crowdsale.
352  */
353 contract ReleasableToken is ERC20, Ownable {
354 
355   /* The finalizer contract that allows unlift the transfer limits on this token */
356   address public releaseAgent;
357 
358   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
359   bool public released = false;
360 
361   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
362   mapping (address => bool) public transferAgents;
363 
364   /**
365    * Limit token transfer until the crowdsale is over.
366    *
367    */
368   modifier canTransfer(address _sender) {
369 
370     if(!released) {
371         require(transferAgents[_sender]);
372     }
373 
374     _;
375   }
376 
377   /**
378    * Set the contract that can call release and make the token transferable.
379    *
380    * Design choice. Allow reset the release agent to fix fat finger mistakes.
381    */
382   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
383 
384     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
385     releaseAgent = addr;
386   }
387 
388   /**
389    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
390    */
391   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
392     transferAgents[addr] = state;
393   }
394 
395   /**
396    * One way function to release the tokens to the wild.
397    *
398    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
399    */
400   function releaseTokenTransfer() public onlyReleaseAgent {
401     released = true;
402   }
403 
404   /** The function can be called only before or after the tokens have been releasesd */
405   modifier inReleaseState(bool releaseState) {
406     require(releaseState == released);
407     _;
408   }
409 
410   /** The function can be called only by a whitelisted release agent. */
411   modifier onlyReleaseAgent() {
412     require(msg.sender == releaseAgent);
413     _;
414   }
415 
416   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
417     // Call StandardToken.transfer()
418    return super.transfer(_to, _value);
419   }
420 
421   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
422     // Call StandardToken.transferForm()
423     return super.transferFrom(_from, _to, _value);
424   }
425 
426 }
427   
428 /**
429  * A token that can increase its supply by another contract.
430  *
431  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
432  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
433  *
434  */
435 contract MintableToken is StandardToken, Ownable {
436 
437   bool public mintingFinished = false;
438 
439   /** List of agents that are allowed to create new tokens */
440   mapping (address => bool) public mintAgents;
441 
442   event MintingAgentChanged(address addr, bool state);
443   event Mint(address indexed to, uint256 amount);
444 
445   /**
446    * Create new tokens and allocate them to an address..
447    *
448    * Only callably by a crowdsale contract (mint agent).
449    */
450   function mint(address receiver, uint256 amount) onlyMintAgent canMint public returns(bool){
451     totalSupply = safeAdd(totalSupply, amount);
452     balances[receiver] = safeAdd(balances[receiver], amount);
453 
454     // This will make the mint transaction apper in EtherScan.io
455     // We can remove this after there is a standardized minting event
456     Mint(receiver, amount);
457     Transfer(0, receiver, amount);
458     return true;
459   }
460 
461   /**
462    * Owner can allow a crowdsale contract to mint new tokens.
463    */
464   function setMintAgent(address addr, bool state) onlyOwner canMint public {
465     mintAgents[addr] = state;
466     MintingAgentChanged(addr, state);
467   }
468 
469   modifier onlyMintAgent() {
470     // Only crowdsale contracts are allowed to mint new tokens
471     require(mintAgents[msg.sender]);
472     _;
473   }
474 
475   /** Make sure we are not done yet. */
476   modifier canMint() {
477     require(!mintingFinished);
478     _;
479   }
480 }
481 
482 contract Allocatable is Ownable {
483 
484   /** List of agents that are allowed to allocate new tokens */
485   mapping (address => bool) public allocateAgents;
486 
487   event AllocateAgentChanged(address addr, bool state  );
488 
489   /**
490    * Owner can allow a crowdsale contract to allocate new tokens.
491    */
492   function setAllocateAgent(address addr, bool state) onlyOwner public {
493     allocateAgents[addr] = state;
494     AllocateAgentChanged(addr, state);
495   }
496 
497   modifier onlyAllocateAgent() {
498     // Only crowdsale contracts are allowed to allocate new tokens
499     require(allocateAgents[msg.sender]);
500     _;
501   }
502 }
503 
504 /**
505  * A crowdsaled token.
506  *
507  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
508  *
509  * - The token transfer() is disabled until the crowdsale is over
510  * - The token contract gives an opt-in upgrade path to a new contract
511  * - The same token can be part of several crowdsales through approve() mechanism
512  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
513  *
514  */
515 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
516 
517   event UpdatedTokenInformation(string newName, string newSymbol);
518 
519   string public name;
520 
521   string public symbol;
522 
523   uint8 public decimals;
524 
525   /**
526    * Construct the token.
527    *
528    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
529    *
530    * @param _name Token name
531    * @param _symbol Token symbol - should be all caps
532    * @param _initialSupply How many tokens we start with
533    * @param _decimals Number of decimal places
534    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
535    */
536   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, bool _mintable)
537     public
538     UpgradeableToken(msg.sender) 
539   {
540 
541     // Create any address, can be transferred
542     // to team multisig via changeOwner(),
543     // also remember to call setUpgradeMaster()
544     owner = msg.sender;
545 
546     name = _name;
547     symbol = _symbol;
548 
549     totalSupply = _initialSupply;
550 
551     decimals = _decimals;
552 
553     // Create initially all balance on the team multisig
554     balances[owner] = totalSupply;
555 
556     if(totalSupply > 0) {
557       Minted(owner, totalSupply);
558     }
559 
560     // No more new supply allowed after the token creation
561     if(!_mintable) {
562       mintingFinished = true;
563       require(totalSupply != 0);
564     }
565   }
566 
567   /**
568    * When token is released to be transferable, enforce no new tokens can be created.
569    */
570   function releaseTokenTransfer() public onlyReleaseAgent {
571     mintingFinished = true;
572     super.releaseTokenTransfer();
573   }
574   
575 
576   /**
577    * Allow upgrade agent functionality kick in only if the crowdsale was success.
578    */
579   function canUpgrade() public view returns(bool) {
580     return released && super.canUpgrade();
581   }
582 
583   /**
584    * Owner can update token information here
585    */
586   function setTokenInformation(string _name, string _symbol) onlyOwner public {
587     name = _name;
588     symbol = _symbol;
589     UpdatedTokenInformation(name, symbol);
590   }
591 
592 
593 }
594 
595 /**
596  * Finalize agent defines what happens at the end of succeseful crowdsale.
597  *
598  * - Allocate tokens for founders, bounties and community
599  * - Make tokens transferable
600  * - etc.
601  */
602 contract FinalizeAgent {
603 
604   function isFinalizeAgent() public pure returns(bool) {
605     return true;
606   }
607 
608   /** Return true if we can run finalizeCrowdsale() properly.
609    *
610    * This is a safety check function that doesn't allow crowdsale to begin
611    * unless the finalizer has been set up properly.
612    */
613   function isSane() public view returns (bool);
614 
615   /** Called once by crowdsale finalize() if the sale was success. */
616   function finalizeCrowdsale() public ;
617 
618 }
619 
620 /**
621  * Interface for defining crowdsale pricing.
622  */
623 contract PricingStrategy {
624 
625   /** Interface declaration. */
626   function isPricingStrategy() public pure returns (bool) {
627     return true;
628   }
629 
630   /** Self check if all references are correctly set.
631    *
632    * Checks that pricing strategy matches crowdsale parameters.
633    */
634   function isSane(address crowdsale) public view returns (bool) {
635     return true;
636   }
637 
638   /**
639    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
640    *
641    *
642    * @param value - What is the value of the transaction send in as wei
643    * @param tokensSold - how much tokens have been sold this far
644    * @param weiRaised - how much money has been raised this far
645    * @param msgSender - who is the investor of this transaction
646    * @param decimals - how many decimal units the token has
647    * @return Amount of tokens the investor receives
648    */
649   function calculatePrice(uint256 value, uint256 weiRaised, uint256 tokensSold, address msgSender, uint256 decimals) public constant returns (uint256 tokenAmount);
650 }
651 
652 /*
653  * Haltable
654  *
655  * Abstract contract that allows children to implement an
656  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
657  *
658  *
659  * Originally envisioned in FirstBlood ICO contract.
660  */
661 contract Haltable is Ownable {
662   bool public halted;
663 
664   modifier stopInEmergency {
665     require(!halted);
666     _;
667   }
668 
669   modifier onlyInEmergency {
670     require(halted);
671     _;
672   }
673 
674   // called by the owner on emergency, triggers stopped state
675   function halt() external onlyOwner {
676     halted = true;
677   }
678 
679   // called by the owner on end of emergency, returns to normal state
680   function unhalt() external onlyOwner onlyInEmergency {
681     halted = false;
682   }
683 
684 }
685 
686 
687 /**
688  * Abstract base contract for token sales.
689  *
690  * Handle
691  * - start and end dates
692  * - accepting investments
693  * - minimum funding goal and refund
694  * - various statistics during the crowdfund
695  * - different pricing strategies
696  * - different investment policies (require server side customer id, allow only whitelisted addresses)
697  *
698  */
699 contract Crowdsale is Allocatable, Haltable, SafeMathLib {
700 
701   /* Max investment count when we are still allowed to change the multisig address */
702   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
703 
704   /* The token we are selling */
705   FractionalERC20 public token;
706 
707   /* Token Vesting Contract */
708   address public tokenVestingAddress;
709 
710   /* How we are going to price our offering */
711   PricingStrategy public pricingStrategy;
712 
713   /* Post-success callback */
714   FinalizeAgent public finalizeAgent;
715 
716   /* tokens will be transfered from this address */
717   address public multisigWallet;
718 
719   /* if the funding goal is not reached, investors may withdraw their funds */
720   uint256 public minimumFundingGoal;
721 
722   /* the UNIX timestamp start date of the crowdsale */
723   uint256 public startsAt;
724 
725   /* the UNIX timestamp end date of the crowdsale */
726   uint256 public endsAt;
727 
728   /* the number of tokens already sold through this contract*/
729   uint256 public tokensSold = 0;
730 
731   /* How many wei of funding we have raised */
732   uint256 public weiRaised = 0;
733 
734   /* How many distinct addresses have invested */
735   uint256 public investorCount = 0;
736 
737   /* How much wei we have returned back to the contract after a failed crowdfund. */
738   uint256 public loadedRefund = 0;
739 
740   /* How much wei we have given back to investors.*/
741   uint256 public weiRefunded = 0;
742 
743   /* Has this crowdsale been finalized */
744   bool public finalized;
745 
746   /* Do we need to have unique contributor id for each customer */
747   bool public requireCustomerId;
748 
749   /**
750     * Do we verify that contributor has been cleared on the server side (accredited investors only).
751     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
752     */
753   bool public requiredSignedAddress;
754 
755   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
756   address public signerAddress;
757 
758   /** How much ETH each address has invested to this crowdsale */
759   mapping (address => uint256) public investedAmountOf;
760 
761   /** How much tokens this crowdsale has credited for each investor address */
762   mapping (address => uint256) public tokenAmountOf;
763 
764   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
765   mapping (address => bool) public earlyParticipantWhitelist;
766 
767   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
768   uint256 public ownerTestValue;
769 
770   /** State machine
771    *
772    * - Preparing: All contract initialization calls and variables have not been set yet
773    * - Prefunding: We have not passed start time yet
774    * - Funding: Active crowdsale
775    * - Success: Minimum funding goal reached
776    * - Failure: Minimum funding goal not reached before ending time
777    * - Finalized: The finalized has been called and succesfully executed
778    * - Refunding: Refunds are loaded on the contract for reclaim.
779    */
780   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
781 
782   // A new investment was made
783   event Invested(address investor, uint256 weiAmount, uint256 tokenAmount, string custId);
784 
785   // Refund was processed for a contributor
786   event Refund(address investor, uint256 weiAmount);
787 
788   // The rules were changed what kind of investments we accept
789   event InvestmentPolicyChanged(bool requireCustId, bool requiredSignedAddr, address signerAddr);
790 
791   // Address early participation whitelist status changed
792   event Whitelisted(address addr, bool status);
793 
794   // Crowdsale end time has been changed
795   event EndsAtChanged(uint256 endAt);
796 
797   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, 
798   uint256 _start, uint256 _end, uint256 _minimumFundingGoal, address _tokenVestingAddress) public {
799 
800     owner = msg.sender;
801 
802     token = FractionalERC20(_token);
803 
804     tokenVestingAddress = _tokenVestingAddress;
805 
806     setPricingStrategy(_pricingStrategy);
807 
808     multisigWallet = _multisigWallet;
809     require(multisigWallet != 0);
810 
811     require(_start != 0);
812 
813     startsAt = _start;
814 
815     require(_end != 0);
816 
817     endsAt = _end;
818 
819     // Don't mess the dates
820     require(startsAt < endsAt);
821 
822     // Minimum funding goal can be zero
823     minimumFundingGoal = _minimumFundingGoal;
824   }
825 
826   /**
827    * Don't expect to just send in money and get tokens.
828    */
829   function() payable public {
830     require(false);
831   }
832 
833   /**
834    * Make an investment.
835    *
836    * Crowdsale must be running for one to invest.
837    * We must have not pressed the emergency brake.
838    *
839    * @param receiver The Ethereum address who receives the tokens
840    * @param customerId (optional) UUID v4 to track the successful payments on the server side
841    *
842    */
843   function investInternal(address receiver, string customerId) stopInEmergency private {
844 
845     // Determine if it's a good time to accept investment from this participant
846     if(getState() == State.PreFunding) {
847       // Are we whitelisted for early deposit
848       require(earlyParticipantWhitelist[receiver]);
849     
850     } else if(getState() == State.Funding) {
851       // Retail participants can only come in when the crowdsale is running
852     } else {
853       // Unwanted state
854       require(false);
855     }
856 
857     uint weiAmount = msg.value;
858     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
859 
860     require(tokenAmount != 0);
861 
862 
863     if(investedAmountOf[receiver] == 0) {
864        // A new investor
865        investorCount++;
866     }
867 
868     // Update investor
869     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
870     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
871 
872     // Update totals
873     weiRaised = safeAdd(weiRaised,weiAmount);
874     tokensSold = safeAdd(tokensSold,tokenAmount);
875 
876     // Check that we did not bust the cap
877     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
878     // if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
879     //   throw;
880     // }
881 
882     assignTokens(receiver, tokenAmount);
883 
884     // Pocket the money
885     require(multisigWallet.send(weiAmount));
886 
887     // Tell us invest was success
888     Invested(receiver, weiAmount, tokenAmount, customerId);
889   }
890 
891   /**
892    * allocate tokens for the early investors.
893    *
894    * Preallocated tokens have been sold before the actual crowdsale opens.
895    * This function mints the tokens and moves the crowdsale needle.
896    *
897    * Investor count is not handled; it is assumed this goes for multiple investors
898    * and the token distribution happens outside the smart contract flow.
899    *
900    * No money is exchanged, as the crowdsale team already have received the payment.
901    *
902    * @param weiPrice Price of a single full token in wei
903    *
904    */
905   function allocate(address receiver, uint256 tokenAmount, uint256 weiPrice, string customerId,  uint256 lockedTokenAmount) public onlyAllocateAgent {
906 
907     // cannot lock more than total tokens
908     require(lockedTokenAmount <= tokenAmount);
909 
910     uint256 weiAmount = (weiPrice * tokenAmount)/10**uint256(token.decimals()); // This can be also 0, we give out tokens for free
911 
912     weiRaised = safeAdd(weiRaised,weiAmount);
913     tokensSold = safeAdd(tokensSold,tokenAmount);
914 
915     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
916     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
917 
918     // assign locked token to Vesting contract
919     if (lockedTokenAmount > 0) {
920       TokenVesting tokenVesting = TokenVesting(tokenVestingAddress);
921       // to prevent minting of tokens which will be useless as vesting amount cannot be updated
922       require(!tokenVesting.isVestingSet(receiver));
923       assignTokens(tokenVestingAddress, lockedTokenAmount);
924       // set vesting with default schedule
925       tokenVesting.setVestingWithDefaultSchedule(receiver, lockedTokenAmount); 
926     }
927 
928     // assign remaining tokens to contributor
929     if (tokenAmount - lockedTokenAmount > 0) {
930       assignTokens(receiver, tokenAmount - lockedTokenAmount);
931     }
932 
933     // Tell us invest was success
934     Invested(receiver, weiAmount, tokenAmount, customerId);
935   }
936 
937   /**
938    * Track who is the customer making the payment so we can send thank you email.
939    */
940   function investWithCustomerId(address addr, string customerId) public payable {
941     require(!requiredSignedAddress);
942     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
943     bytes memory custIdTest = bytes(customerId);
944     require(custIdTest.length != 0);
945     //if(customerId == 0) throw;  // UUIDv4 sanity check
946     investInternal(addr, customerId);
947   }
948 
949   /**
950    * Allow anonymous contributions to this crowdsale.
951    */
952   function invest(address addr) public payable {
953     require(!requireCustomerId);
954     
955     require(!requiredSignedAddress);
956     investInternal(addr, "");
957   }
958 
959   /**
960    * Invest to tokens, recognize the payer and clear his address.
961    *
962    */
963   
964   // function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
965   //   investWithSignedAddress(msg.sender, customerId, v, r, s);
966   // }
967 
968   /**
969    * Invest to tokens, recognize the payer.
970    *
971    */
972   function buyWithCustomerId(string customerId) public payable {
973     investWithCustomerId(msg.sender, customerId);
974   }
975 
976   /**
977    * The basic entry point to participate the crowdsale process.
978    *
979    * Pay for funding, get invested tokens back in the sender address.
980    */
981   function buy() public payable {
982     invest(msg.sender);
983   }
984 
985   /**
986    * Finalize a succcesful crowdsale.
987    *
988    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
989    */
990   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
991 
992     // Already finalized
993     require(!finalized);
994 
995     // Finalizing is optional. We only call it if we are given a finalizing agent.
996     if(address(finalizeAgent) != 0) {
997       finalizeAgent.finalizeCrowdsale();
998     }
999 
1000     finalized = true;
1001   }
1002 
1003   /**
1004    * Allow to (re)set finalize agent.
1005    *
1006    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
1007    */
1008   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
1009     finalizeAgent = addr;
1010 
1011     // Don't allow setting bad agent
1012     require(finalizeAgent.isFinalizeAgent());
1013   }
1014 
1015   /**
1016    * Set policy do we need to have server-side customer ids for the investments.
1017    *
1018    */
1019   function setRequireCustomerId(bool value) public onlyOwner {
1020     requireCustomerId = value;
1021     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1022   }
1023 
1024   /**
1025    * Allow addresses to do early participation.
1026    *
1027    * TODO: Fix spelling error in the name
1028    */
1029   function setEarlyParicipantWhitelist(address addr, bool status) public onlyOwner {
1030     earlyParticipantWhitelist[addr] = status;
1031     Whitelisted(addr, status);
1032   }
1033 
1034   /**
1035    * Allow crowdsale owner to close early or extend the crowdsale.
1036    *
1037    * This is useful e.g. for a manual soft cap implementation:
1038    * - after X amount is reached determine manual closing
1039    *
1040    * This may put the crowdsale to an invalid state,
1041    * but we trust owners know what they are doing.
1042    *
1043    */
1044   function setEndsAt(uint time) public onlyOwner {
1045 
1046     require(now <= time);
1047 
1048     endsAt = time;
1049     EndsAtChanged(endsAt);
1050   }
1051 
1052   /**
1053    * Allow to (re)set pricing strategy.
1054    *
1055    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1056    */
1057   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
1058     pricingStrategy = _pricingStrategy;
1059 
1060     // Don't allow setting bad agent
1061     require(pricingStrategy.isPricingStrategy());
1062   }
1063 
1064   /**
1065    * Allow to change the team multisig address in the case of emergency.
1066    *
1067    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1068    * (we have done only few test transactions). After the crowdsale is going
1069    * then multisig address stays locked for the safety reasons.
1070    */
1071   function setMultisig(address addr) public onlyOwner {
1072 
1073     // Change
1074     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
1075 
1076     multisigWallet = addr;
1077   }
1078 
1079   /**
1080    * Allow load refunds back on the contract for the refunding.
1081    *
1082    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1083    */
1084   function loadRefund() public payable inState(State.Failure) {
1085     require(msg.value != 0);
1086     loadedRefund = safeAdd(loadedRefund,msg.value);
1087   }
1088 
1089   /**
1090    * Investors can claim refund.
1091    */
1092   function refund() public inState(State.Refunding) {
1093     uint256 weiValue = investedAmountOf[msg.sender];
1094     require(weiValue != 0);
1095     investedAmountOf[msg.sender] = 0;
1096     weiRefunded = safeAdd(weiRefunded,weiValue);
1097     Refund(msg.sender, weiValue);
1098     require(msg.sender.send(weiValue));
1099   }
1100 
1101   /**
1102    * @return true if the crowdsale has raised enough money to be a succes
1103    */
1104   function isMinimumGoalReached() public constant returns (bool reached) {
1105     return weiRaised >= minimumFundingGoal;
1106   }
1107 
1108   /**
1109    * Check if the contract relationship looks good.
1110    */
1111   function isFinalizerSane() public constant returns (bool sane) {
1112     return finalizeAgent.isSane();
1113   }
1114 
1115   /**
1116    * Check if the contract relationship looks good.
1117    */
1118   function isPricingSane() public constant returns (bool sane) {
1119     return pricingStrategy.isSane(address(this));
1120   }
1121 
1122   /**
1123    * Crowdfund state machine management.
1124    *
1125    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1126    */
1127   function getState() public constant returns (State) {
1128     if(finalized) return State.Finalized;
1129     else if (address(finalizeAgent) == 0) return State.Preparing;
1130     else if (!finalizeAgent.isSane()) return State.Preparing;
1131     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1132     else if (block.timestamp < startsAt) return State.PreFunding;
1133     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1134     else if (isMinimumGoalReached()) return State.Success;
1135     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1136     else return State.Failure;
1137   }
1138 
1139   /** This is for manual testing of multisig wallet interaction */
1140   function setOwnerTestValue(uint val) public onlyOwner {
1141     ownerTestValue = val;
1142   }
1143 
1144   /** Interface marker. */
1145   function isCrowdsale() public pure returns (bool) {
1146     return true;
1147   }
1148 
1149   //
1150   // Modifiers
1151   //
1152 
1153   /** Modified allowing execution only if the crowdsale is currently running.  */
1154   modifier inState(State state) {
1155     require(getState() == state);
1156     _;
1157   }
1158 
1159    //
1160   // Abstract functions
1161   //
1162 
1163   /**
1164    * Check if the current invested breaks our cap rules.
1165    *
1166    *
1167    * The child contract must define their own cap setting rules.
1168    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1169    * Called from invest().
1170    *
1171    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1172    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1173    * @param weiRaisedTotal What would be our total raised balance after this transaction
1174    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1175    *
1176    * @return true if taking this investment would break our cap rules
1177    */
1178   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
1179   /**
1180    * Check if the current crowdsale is full and we can no longer sell any tokens.
1181    */
1182   function isCrowdsaleFull() public constant returns (bool);
1183 
1184   /**
1185    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1186    */
1187   function assignTokens(address receiver, uint tokenAmount) private;
1188 
1189 }
1190 
1191 /**
1192  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1193  *
1194  * Unlock tokens.
1195  *
1196  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1197  *
1198  */
1199 contract BonusFinalizeAgent is FinalizeAgent, SafeMathLib {
1200 
1201   CrowdsaleToken public token;
1202   Crowdsale public crowdsale;
1203 
1204   /** Total percent of tokens minted to the team at the end of the sale as base points (0.0001) */
1205   uint256 public totalMembers;
1206   // Per address % of total token raised to be assigned to the member Ex 1% is passed as 100
1207   uint256 public allocatedBonus;
1208   mapping (address=>uint256) bonusOf;
1209   /** Where we move the tokens at the end of the sale. */
1210   address[] public teamAddresses;
1211 
1212 
1213   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint256[] _bonusBasePoints, address[] _teamAddresses) public {
1214     token = _token;
1215     crowdsale = _crowdsale;
1216 
1217     //crowdsale address must not be 0
1218     require(address(crowdsale) != 0);
1219 
1220     //bonus & team address array size must match
1221     require(_bonusBasePoints.length == _teamAddresses.length);
1222 
1223     totalMembers = _teamAddresses.length;
1224     teamAddresses = _teamAddresses;
1225     
1226     //if any of the bonus is 0 throw
1227     // otherwise sum it up in totalAllocatedBonus
1228     for (uint256 i=0;i<totalMembers;i++) {
1229       require(_bonusBasePoints[i] != 0);
1230     }
1231 
1232     //if any of the address is 0 or invalid throw
1233     //otherwise initialize the bonusOf array
1234     for (uint256 j=0;j<totalMembers;j++) {
1235       require(_teamAddresses[j] != 0);
1236       bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];
1237     }
1238   }
1239 
1240   /* Can we run finalize properly */
1241   function isSane() public view returns (bool) {
1242     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
1243   }
1244 
1245   /** Called once by crowdsale finalize() if the sale was success. */
1246   function finalizeCrowdsale() public {
1247 
1248     // if finalized is not being called from the crowdsale 
1249     // contract then throw
1250     require(msg.sender == address(crowdsale));
1251 
1252     // get the total sold tokens count.
1253     uint tokensSold = crowdsale.tokensSold();
1254 
1255     for (uint256 i=0;i<totalMembers;i++) {
1256       allocatedBonus = safeMul(tokensSold, bonusOf[teamAddresses[i]]) / 10000;
1257       // move tokens to the team multisig wallet
1258       token.mint(teamAddresses[i], allocatedBonus);
1259     }
1260 
1261     token.releaseTokenTransfer();
1262   }
1263 
1264 }
1265 
1266 /**
1267  * ICO crowdsale contract that is capped by amout of ETH.
1268  *
1269  * - Tokens are dynamically created during the crowdsale
1270  *
1271  *
1272  */
1273 contract MintedEthCappedCrowdsale is Crowdsale {
1274 
1275   /* Maximum amount of wei this crowdsale can raise. */
1276   uint public weiCap;
1277 
1278   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, 
1279     address _multisigWallet, uint256 _start, uint256 _end, uint256 _minimumFundingGoal, uint256 _weiCap, 
1280     address _tokenVestingAddress) 
1281     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, 
1282     _tokenVestingAddress) public
1283     { 
1284       weiCap = _weiCap;
1285     }
1286 
1287   /**
1288    * Called from invest() to confirm if the curret investment does not break our cap rule.
1289    */
1290   function isBreakingCap(uint256 weiAmount, uint256 tokenAmount, uint256 weiRaisedTotal, uint256 tokensSoldTotal) public constant returns (bool limitBroken) {
1291     return weiRaisedTotal > weiCap;
1292   }
1293 
1294   function isCrowdsaleFull() public constant returns (bool) {
1295     return weiRaised >= weiCap;
1296   }
1297 
1298   /**
1299    * Dynamically create tokens and assign them to the investor.
1300    */
1301   function assignTokens(address receiver, uint256 tokenAmount) private {
1302     MintableToken mintableToken = MintableToken(token);
1303     mintableToken.mint(receiver, tokenAmount);
1304   }
1305 }
1306 /// @dev Tranche based pricing with special support for pre-ico deals.
1307 ///      Implementing "first price" tranches, meaning, that if byers order is
1308 ///      covering more than one tranche, the price of the lowest tranche will apply
1309 ///      to the whole order.
1310 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
1311 
1312   uint public constant MAX_TRANCHES = 10;
1313  
1314  
1315   // This contains all pre-ICO addresses, and their prices (weis per token)
1316   mapping (address => uint256) public preicoAddresses;
1317 
1318   /**
1319   * Define pricing schedule using tranches.
1320   */
1321 
1322   struct Tranche {
1323       // Amount in weis when this tranche becomes active
1324       uint amount;
1325       // How many tokens per wei you will get while this tranche is active
1326       uint price;
1327   }
1328 
1329   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
1330   // Tranche 0 is always (0, 0)
1331   // (TODO: change this when we confirm dynamic arrays are explorable)
1332   Tranche[10] public tranches;
1333 
1334   // How many active tranches we have
1335   uint public trancheCount;
1336 
1337   /// @dev Contruction, creating a list of tranches
1338   /// @param _tranches uint[] tranches Pairs of (start amount, price)
1339   function EthTranchePricing(uint[] _tranches) public {
1340 
1341     // Need to have tuples, length check
1342     require(!(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2));
1343     trancheCount = _tranches.length / 2;
1344     uint256 highestAmount = 0;
1345     for(uint256 i=0; i<_tranches.length/2; i++) {
1346       tranches[i].amount = _tranches[i*2];
1347       tranches[i].price = _tranches[i*2+1];
1348       // No invalid steps
1349       require(!((highestAmount != 0) && (tranches[i].amount <= highestAmount)));
1350       highestAmount = tranches[i].amount;
1351     }
1352 
1353     // We need to start from zero, otherwise we blow up our deployment
1354     require(tranches[0].amount == 0);
1355 
1356     // Last tranche price must be zero, terminating the crowdale
1357     require(tranches[trancheCount-1].price == 0);
1358   }
1359 
1360   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1361   ///      to 0 to disable
1362   /// @param preicoAddress PresaleFundCollector address
1363   /// @param pricePerToken How many weis one token cost for pre-ico investors
1364   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1365     public
1366     onlyOwner
1367   {
1368     preicoAddresses[preicoAddress] = pricePerToken;
1369   }
1370 
1371   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1372   /// @return tuple (time, price)
1373   function getTranche(uint256 n) public constant returns (uint, uint) {
1374     return (tranches[n].amount, tranches[n].price);
1375   }
1376 
1377   function getFirstTranche() private constant returns (Tranche) {
1378     return tranches[0];
1379   }
1380 
1381   function getLastTranche() private constant returns (Tranche) {
1382     return tranches[trancheCount-1];
1383   }
1384 
1385   function getPricingStartsAt() public constant returns (uint) {
1386     return getFirstTranche().amount;
1387   }
1388 
1389   function getPricingEndsAt() public constant returns (uint) {
1390     return getLastTranche().amount;
1391   }
1392 
1393   function isSane(address _crowdsale) public view returns(bool) {
1394     // Our tranches are not bound by time, so we can't really check are we sane
1395     // so we presume we are ;)
1396     // In the future we could save and track raised tokens, and compare it to
1397     // the Crowdsale contract.
1398     return true;
1399   }
1400 
1401   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1402   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1403   /// @return {[type]} [description]
1404   function getCurrentTranche(uint256 weiRaised) private constant returns (Tranche) {
1405     uint i;
1406     for(i=0; i < tranches.length; i++) {
1407       if(weiRaised < tranches[i].amount) {
1408         return tranches[i-1];
1409       }
1410     }
1411   }
1412 
1413   /// @dev Get the current price.
1414   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1415   /// @return The current price or 0 if we are outside trache ranges
1416   function getCurrentPrice(uint256 weiRaised) public constant returns (uint256 result) {
1417     return getCurrentTranche(weiRaised).price;
1418   }
1419 
1420   /// @dev Calculate the current price for buy in amount.
1421   function calculatePrice(uint256 value, uint256 weiRaised, uint256 tokensSold, address msgSender, uint256 decimals) public constant returns (uint256) {
1422 
1423     uint256 multiplier = 10 ** decimals;
1424 
1425     // This investor is coming through pre-ico
1426     if(preicoAddresses[msgSender] > 0) {
1427       return safeMul(value, multiplier) / preicoAddresses[msgSender];
1428     }
1429 
1430     uint256 price = getCurrentPrice(weiRaised);
1431     
1432     return safeMul(value, multiplier) / price;
1433   }
1434 
1435   function() payable public {
1436     revert(); // No money on this contract
1437   }
1438 
1439 }
1440 
1441 /**
1442  * Contract to enforce Token Vesting
1443  */
1444 contract TokenVesting is Allocatable, SafeMathLib {
1445 
1446     address public LALATokenAddress;
1447 
1448     /** keep track of total tokens yet to be released, 
1449      * this should be less than or equal to LALA tokens held by this contract. 
1450      */
1451     uint256 public totalUnreleasedTokens;
1452 
1453     // default vesting parameters
1454     uint256 startAt = 0;
1455     uint256 cliff = 3;
1456     uint256 duration = 12; 
1457     uint256 step = 2592000;
1458     bool changeFreezed = false;
1459 
1460     struct VestingSchedule {
1461         uint256 startAt;
1462         uint256 cliff;
1463         uint256 duration;
1464         uint256 step;
1465         uint256 amount;
1466         uint256 amountReleased;
1467         bool changeFreezed;
1468     }
1469 
1470     mapping (address => VestingSchedule) public vestingMap;
1471 
1472     event VestedTokensReleased(address _adr, uint256 _amount);
1473 
1474 
1475     function TokenVesting(address _LALATokenAddress) public {
1476         LALATokenAddress = _LALATokenAddress;
1477     }
1478 
1479 
1480     /** Modifier to check if changes to vesting is freezed  */
1481     modifier changesToVestingFreezed(address _adr){
1482         require(vestingMap[_adr].changeFreezed);
1483         _;
1484     }
1485 
1486 
1487     /** Modifier to check if changes to vesting is not freezed yet  */
1488     modifier changesToVestingNotFreezed(address adr) {
1489         require(!vestingMap[adr].changeFreezed); // if vesting not set then also changeFreezed will be false
1490         _;
1491     }
1492 
1493 
1494     /** Function to set default vesting schedule parameters. */
1495     function setDefaultVestingParameters(uint256 _startAt, uint256 _cliff, uint256 _duration, 
1496         uint256 _step, bool _changeFreezed) onlyAllocateAgent public {
1497 
1498         // data validation
1499         require(_step != 0);
1500         require(_duration != 0);
1501         require(_cliff <= _duration);
1502 
1503         startAt = _startAt;
1504         cliff = _cliff;
1505         duration = _duration; 
1506         step = _step;
1507         changeFreezed = _changeFreezed;
1508 
1509     }
1510 
1511     /** Function to set vesting with default schedule. */
1512     function setVestingWithDefaultSchedule(address _adr, uint256 _amount) 
1513         public 
1514         changesToVestingNotFreezed(_adr) onlyAllocateAgent {
1515         setVesting(_adr, startAt, cliff, duration, step, _amount, changeFreezed);
1516     }
1517 
1518     /** Function to set/update vesting schedule. PS - Amount cannot be changed once set */
1519     function setVesting(address _adr, uint256 _startAt, uint256 _cliff, uint256 _duration, 
1520         uint256 _step, uint256 _amount, bool _changeFreezed) public changesToVestingNotFreezed(_adr) onlyAllocateAgent {
1521 
1522         VestingSchedule storage vestingSchedule = vestingMap[_adr];
1523 
1524         // data validation
1525         require(_step != 0);
1526         require(_amount != 0 || vestingSchedule.amount > 0);
1527         require(_duration != 0);
1528         require(_cliff <= _duration);
1529 
1530         //if startAt is zero, set current time as start time.
1531         if (_startAt == 0) 
1532             _startAt = block.timestamp;
1533 
1534         vestingSchedule.startAt = _startAt;
1535         vestingSchedule.cliff = _cliff;
1536         vestingSchedule.duration = _duration;
1537         vestingSchedule.step = _step;
1538 
1539         // special processing for first time vesting setting
1540         if (vestingSchedule.amount == 0) {
1541             // check if enough tokens are held by this contract
1542             ERC20 LALAToken = ERC20(LALATokenAddress);
1543             require(LALAToken.balanceOf(this) >= safeAdd(totalUnreleasedTokens, _amount));
1544             totalUnreleasedTokens = safeAdd(totalUnreleasedTokens, _amount);
1545             vestingSchedule.amount = _amount; 
1546         }
1547 
1548         vestingSchedule.amountReleased = 0;
1549         vestingSchedule.changeFreezed = _changeFreezed;
1550     }
1551 
1552     function isVestingSet(address adr) public constant returns (bool isSet) {
1553         return vestingMap[adr].amount != 0;
1554     }
1555 
1556     function freezeChangesToVesting(address _adr) public changesToVestingNotFreezed(_adr) onlyAllocateAgent {
1557         require(isVestingSet(_adr)); // first check if vesting is set
1558         vestingMap[_adr].changeFreezed = true;
1559     }
1560 
1561 
1562     /** Release tokens as per vesting schedule, called by contributor  */
1563     function releaseMyVestedTokens() public changesToVestingFreezed(msg.sender) {
1564         releaseVestedTokens(msg.sender);
1565     }
1566 
1567     /** Release tokens as per vesting schedule, called by anyone  */
1568     function releaseVestedTokens(address _adr) public changesToVestingFreezed(_adr) {
1569         VestingSchedule storage vestingSchedule = vestingMap[_adr];
1570         
1571         // check if all tokens are not vested
1572         require(safeSub(vestingSchedule.amount, vestingSchedule.amountReleased) > 0);
1573         
1574         // calculate total vested tokens till now
1575         uint256 totalTime = block.timestamp - vestingSchedule.startAt;
1576         uint256 totalSteps = totalTime / vestingSchedule.step;
1577 
1578         // check if cliff is passed
1579         require(vestingSchedule.cliff <= totalSteps);
1580 
1581         uint256 tokensPerStep = vestingSchedule.amount / vestingSchedule.duration;
1582         // check if amount is divisble by duration
1583         if(tokensPerStep * vestingSchedule.duration != vestingSchedule.amount) tokensPerStep++;
1584 
1585         uint256 totalReleasableAmount = safeMul(tokensPerStep, totalSteps);
1586 
1587         // handle the case if user has not claimed even after vesting period is over or amount was not divisible
1588         if(totalReleasableAmount > vestingSchedule.amount) totalReleasableAmount = vestingSchedule.amount;
1589 
1590         uint256 amountToRelease = safeSub(totalReleasableAmount, vestingSchedule.amountReleased);
1591         vestingSchedule.amountReleased = safeAdd(vestingSchedule.amountReleased, amountToRelease);
1592 
1593         // transfer vested tokens
1594         ERC20 LALAToken = ERC20(LALATokenAddress);
1595         LALAToken.transfer(_adr, amountToRelease);
1596         // decrement overall unreleased token count
1597         totalUnreleasedTokens = safeSub(totalUnreleasedTokens, amountToRelease);
1598         VestedTokensReleased(_adr, amountToRelease);
1599     }
1600 
1601 }