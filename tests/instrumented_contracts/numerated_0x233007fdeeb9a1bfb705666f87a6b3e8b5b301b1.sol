1 pragma solidity ^0.4.13;
2 // Thanks to OpenZeppeline & TokenMarket for the awesome Libraries.
3 contract SafeMathLib {
4   function safeMul(uint a, uint b) returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) returns (uint) {
16     uint c = a + b;
17     assert(c>=a);
18     return c;
19   }
20 }
21 
22 contract Ownable {
23   address public owner;
24   address public newOwner;
25   event OwnershipTransferred(address indexed _from, address indexed _to);
26   function Ownable() {
27     owner = msg.sender;
28   }
29   modifier onlyOwner {
30     require(msg.sender == owner);
31     _;
32   }
33   function transferOwnership(address _newOwner) onlyOwner {
34     newOwner = _newOwner;
35   }
36 
37   function acceptOwnership() {
38     require(msg.sender == newOwner);
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42   
43 }
44 
45 contract ERC20Basic {
46   uint public totalSupply;
47   function balanceOf(address who) constant returns (uint);
48   function transfer(address _to, uint _value) returns (bool success);
49   event Transfer(address indexed from, address indexed to, uint value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) constant returns (uint);
54   function transferFrom(address _from, address _to, uint _value) returns (bool success);
55   function approve(address _spender, uint _value) returns (bool success);
56   event Approval(address indexed owner, address indexed spender, uint value);
57 }
58 
59 contract FractionalERC20 is ERC20 {
60   uint8 public decimals;
61 }
62 
63 contract StandardToken is ERC20, SafeMathLib {
64   /* Token supply got increased and a new owner received these tokens */
65   event Minted(address receiver, uint amount);
66 
67   /* Actual balances of token holders */
68   mapping(address => uint) balances;
69 
70   /* approve() allowances */
71   mapping (address => mapping (address => uint)) allowed;
72 
73   function transfer(address _to, uint _value) returns (bool success) {
74     if (balances[msg.sender] >= _value 
75         && _value > 0 
76         && balances[_to] + _value > balances[_to]
77         ) {
78       balances[msg.sender] = safeSub(balances[msg.sender],_value);
79       balances[_to] = safeAdd(balances[_to],_value);
80       Transfer(msg.sender, _to, _value);
81       return true;
82     }
83     else{
84       return false;
85     }
86     
87   }
88 
89   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
90     uint _allowance = allowed[_from][msg.sender];
91 
92     if (balances[_from] >= _value   // From a/c has balance
93         && _allowance >= _value    // Transfer approved
94         && _value > 0              // Non-zero transfer
95         && balances[_to] + _value > balances[_to]  // Overflow check
96         ){
97     balances[_to] = safeAdd(balances[_to],_value);
98     balances[_from] = safeSub(balances[_from],_value);
99     allowed[_from][msg.sender] = safeSub(_allowance,_value);
100     Transfer(_from, _to, _value);
101     return true;
102         }
103     else {
104       return false;
105     }
106   }
107 
108   function balanceOf(address _owner) constant returns (uint balance) {
109     return balances[_owner];
110   }
111 
112   function approve(address _spender, uint _value) returns (bool success) {
113 
114     // To change the approve amount you first have to reduce the addresses`
115     //  allowance to zero by calling `approve(_spender, 0)` if it is not
116     //  already 0 to mitigate the race condition described here:
117     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
119     //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
120 
121     allowed[msg.sender][_spender] = _value;
122     Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   function allowance(address _owner, address _spender) constant returns (uint remaining) {
127     return allowed[_owner][_spender];
128   }
129 
130 }
131 
132 /**
133  * Upgrade agent interface inspired by Lunyr.
134  *
135  * Upgrade agent transfers tokens to a new contract.
136  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
137  */
138 contract UpgradeAgent {
139   uint public originalSupply;
140   /** Interface marker */
141   function isUpgradeAgent() public constant returns (bool) {
142     return true;
143   }
144   function upgradeFrom(address _from, uint256 _value) public;
145 }
146 
147 /**
148  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
149  *
150  * First envisioned by Golem and Lunyr projects.
151  */
152 contract UpgradeableToken is StandardToken {
153 
154   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
155   address public upgradeMaster;
156 
157   /** The next contract where the tokens will be migrated. */
158   UpgradeAgent public upgradeAgent;
159 
160   /** How many tokens we have upgraded by now. */
161   uint256 public totalUpgraded;
162 
163   /**
164    * Upgrade states.
165    *
166    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
167    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
168    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
169    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
170    *
171    */
172   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
173 
174   /**
175    * Somebody has upgraded some of his tokens.
176    */
177   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
178 
179   /**
180    * New upgrade agent available.
181    */
182   event UpgradeAgentSet(address agent);
183 
184   /**
185    * Do not allow construction without upgrade master set.
186    */
187   function UpgradeableToken(address _upgradeMaster) {
188     upgradeMaster = _upgradeMaster;
189   }
190 
191   /**
192    * Allow the token holder to upgrade some of their tokens to a new contract.
193    */
194   function upgrade(uint256 value) public {
195     UpgradeState state = getUpgradeState();
196     require((state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
197     // if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
198     //   // Called in a bad state
199     //   throw;
200     // }
201 
202     // Validate input value.
203     require(value != 0);
204 
205     balances[msg.sender] = safeSub(balances[msg.sender],value);
206 
207     // Take tokens out from circulation
208     totalSupply = safeSub(totalSupply,value);
209     totalUpgraded = safeAdd(totalUpgraded,value);
210 
211     // Upgrade agent reissues the tokens
212     upgradeAgent.upgradeFrom(msg.sender, value);
213     Upgrade(msg.sender, upgradeAgent, value);
214   }
215 
216   /**
217    * Set an upgrade agent that handles
218    */
219   function setUpgradeAgent(address agent) external {
220     require(canUpgrade());
221     // if(!canUpgrade()) {
222     //   // The token is not yet in a state that we could think upgrading
223     //   throw;
224     // }
225 
226     require(agent != 0x0);
227     //if (agent == 0x0) throw;
228     // Only a master can designate the next agent
229     require(msg.sender == upgradeMaster);
230     //if (msg.sender != upgradeMaster) throw;
231     // Upgrade has already begun for an agent
232     require(getUpgradeState() != UpgradeState.Upgrading);
233     //if (getUpgradeState() == UpgradeState.Upgrading) throw;
234 
235     upgradeAgent = UpgradeAgent(agent);
236 
237     // Bad interface
238     require(upgradeAgent.isUpgradeAgent());
239     //if(!upgradeAgent.isUpgradeAgent()) throw;
240     // Make sure that token supplies match in source and target
241     require(upgradeAgent.originalSupply() == totalSupply);
242     //if (upgradeAgent.originalSupply() != totalSupply) throw;
243 
244     UpgradeAgentSet(upgradeAgent);
245   }
246 
247   /**
248    * Get the state of the token upgrade.
249    */
250   function getUpgradeState() public constant returns(UpgradeState) {
251     if(!canUpgrade()) return UpgradeState.NotAllowed;
252     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
253     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
254     else return UpgradeState.Upgrading;
255   }
256 
257   /**
258    * Change the upgrade master.
259    *
260    * This allows us to set a new owner for the upgrade mechanism.
261    */
262   function setUpgradeMaster(address master) public {
263     require(master != 0x0);
264     //if (master == 0x0) throw;
265     require(msg.sender == upgradeMaster);
266     //if (msg.sender != upgradeMaster) throw;
267     upgradeMaster = master;
268   }
269 
270   /**
271    * Child contract can enable to provide the condition when the upgrade can begun.
272    */
273   function canUpgrade() public constant returns(bool) {
274      return true;
275   }
276 
277 }
278 
279 /**
280  * Define interface for releasing the token transfer after a successful crowdsale.
281  */
282 contract ReleasableToken is ERC20, Ownable {
283 
284   /* The finalizer contract that allows unlift the transfer limits on this token */
285   address public releaseAgent;
286 
287   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
288   bool public released = false;
289 
290   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
291   mapping (address => bool) public transferAgents;
292 
293   /**
294    * Limit token transfer until the crowdsale is over.
295    *
296    */
297   modifier canTransfer(address _sender) {
298 
299     if(!released) {
300         require(transferAgents[_sender]);
301         // if(!transferAgents[_sender]) {
302         //     throw;
303         // }
304     }
305 
306     _;
307   }
308 
309   /**
310    * Set the contract that can call release and make the token transferable.
311    *
312    * Design choice. Allow reset the release agent to fix fat finger mistakes.
313    */
314   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
315 
316     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
317     releaseAgent = addr;
318   }
319 
320   /**
321    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
322    */
323   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
324     transferAgents[addr] = state;
325   }
326 
327   /**
328    * One way function to release the tokens to the wild.
329    *
330    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
331    */
332   function releaseTokenTransfer() public onlyReleaseAgent {
333     released = true;
334   }
335 
336   /** The function can be called only before or after the tokens have been releasesd */
337   modifier inReleaseState(bool releaseState) {
338     require(releaseState == released);
339     // if(releaseState != released) {
340     //     throw;
341     // }
342     _;
343   }
344 
345   /** The function can be called only by a whitelisted release agent. */
346   modifier onlyReleaseAgent() {
347     require(msg.sender == releaseAgent);
348     // if(msg.sender != releaseAgent) {
349     //     throw;
350     // }
351     _;
352   }
353 
354   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
355     // Call StandardToken.transfer()
356    return super.transfer(_to, _value);
357   }
358 
359   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
360     // Call StandardToken.transferForm()
361     return super.transferFrom(_from, _to, _value);
362   }
363 
364 }
365 
366 /**
367  * A token that can increase its supply by another contract.
368  *
369  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
370  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
371  *
372  */
373 contract MintableToken is StandardToken, Ownable {
374 
375   bool public mintingFinished = false;
376 
377   /** List of agents that are allowed to create new tokens */
378   mapping (address => bool) public mintAgents;
379 
380   event MintingAgentChanged(address addr, bool state  );
381 
382   /**
383    * Create new tokens and allocate them to an address..
384    *
385    * Only callably by a crowdsale contract (mint agent).
386    */
387   function mint(address receiver, uint amount) onlyMintAgent canMint public {
388     totalSupply = safeAdd(totalSupply, amount);
389     balances[receiver] = safeAdd(balances[receiver], amount);
390 
391     // This will make the mint transaction apper in EtherScan.io
392     // We can remove this after there is a standardized minting event
393     Transfer(0, receiver, amount);
394   }
395 
396   /**
397    * Owner can allow a crowdsale contract to mint new tokens.
398    */
399   function setMintAgent(address addr, bool state) onlyOwner canMint public {
400     mintAgents[addr] = state;
401     MintingAgentChanged(addr, state);
402   }
403 
404   modifier onlyMintAgent() {
405     // Only crowdsale contracts are allowed to mint new tokens
406     require(mintAgents[msg.sender]);
407     // if(!mintAgents[msg.sender]) {
408     //     throw;
409     // }
410     _;
411   }
412 
413   /** Make sure we are not done yet. */
414   modifier canMint() {
415     require(!mintingFinished);
416     //if(mintingFinished) throw;
417     _;
418   }
419 }
420 
421 contract Allocatable is Ownable {
422 
423   /** List of agents that are allowed to allocate new tokens */
424   mapping (address => bool) public allocateAgents;
425 
426   event AllocateAgentChanged(address addr, bool state  );
427 
428   /**
429    * Owner can allow a crowdsale contract to allocate new tokens.
430    */
431   function setAllocateAgent(address addr, bool state) onlyOwner public {
432     allocateAgents[addr] = state;
433     AllocateAgentChanged(addr, state);
434   }
435 
436   modifier onlyAllocateAgent() {
437     // Only crowdsale contracts are allowed to allocate new tokens
438     require(allocateAgents[msg.sender]);
439     _;
440   }
441 }
442 
443 /**
444  * A crowdsaled token.
445  *
446  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
447  *
448  * - The token transfer() is disabled until the crowdsale is over
449  * - The token contract gives an opt-in upgrade path to a new contract
450  * - The same token can be part of several crowdsales through approve() mechanism
451  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
452  *
453  */
454  contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
455 
456   event UpdatedTokenInformation(string newName, string newSymbol);
457 
458   string public name;
459 
460   string public symbol;
461 
462   uint8 public decimals;
463 
464   /**
465    * Construct the token.
466    *
467    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
468    *
469    * @param _name Token name
470    * @param _symbol Token symbol - should be all caps
471    * @param _initialSupply How many tokens we start with
472    * @param _decimals Number of decimal places
473    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
474    */
475   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, bool _mintable)
476     UpgradeableToken(msg.sender) 
477   {
478 
479     // Create any address, can be transferred
480     // to team multisig via changeOwner(),
481     // also remember to call setUpgradeMaster()
482     owner = msg.sender;
483 
484     name = _name;
485     symbol = _symbol;
486 
487     totalSupply = _initialSupply;
488 
489     decimals = _decimals;
490 
491     // Create initially all balance on the team multisig
492     balances[owner] = totalSupply;
493 
494     if(totalSupply > 0) {
495       Minted(owner, totalSupply);
496     }
497 
498     // No more new supply allowed after the token creation
499     if(!_mintable) {
500       mintingFinished = true;
501       require(totalSupply != 0);
502     }
503   }
504 
505   /**
506    * When token is released to be transferable, enforce no new tokens can be created.
507    */
508   function releaseTokenTransfer() public onlyReleaseAgent {
509     mintingFinished = true;
510     super.releaseTokenTransfer();
511   }
512   
513 
514   /**
515    * Allow upgrade agent functionality kick in only if the crowdsale was success.
516    */
517   function canUpgrade() public constant returns(bool) {
518     return released && super.canUpgrade();
519   }
520 
521   /**
522    * Owner can update token information here
523    */
524   function setTokenInformation(string _name, string _symbol) onlyOwner {
525     name = _name;
526     symbol = _symbol;
527     UpdatedTokenInformation(name, symbol);
528   }
529 
530 
531 }
532 
533 
534 
535 /**
536  * Finalize agent defines what happens at the end of succeseful crowdsale.
537  *
538  * - Allocate tokens for founders, bounties and community
539  * - Make tokens transferable
540  * - etc.
541  */
542 contract FinalizeAgent {
543 
544   function isFinalizeAgent() public constant returns(bool) {
545     return true;
546   }
547 
548   /** Return true if we can run finalizeCrowdsale() properly.
549    *
550    * This is a safety check function that doesn't allow crowdsale to begin
551    * unless the finalizer has been set up properly.
552    */
553   function isSane() public constant returns (bool);
554 
555   /** Called once by crowdsale finalize() if the sale was success. */
556   function finalizeCrowdsale();
557 
558 }
559 
560 /**
561  * Interface for defining crowdsale pricing.
562  */
563 contract PricingStrategy {
564 
565   /** Interface declaration. */
566   function isPricingStrategy() public constant returns (bool) {
567     return true;
568   }
569 
570   /** Self check if all references are correctly set.
571    *
572    * Checks that pricing strategy matches crowdsale parameters.
573    */
574   function isSane(address crowdsale) public constant returns (bool) {
575     return true;
576   }
577 
578   /**
579    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
580    *
581    *
582    * @param value - What is the value of the transaction send in as wei
583    * @param tokensSold - how much tokens have been sold this far
584    * @param weiRaised - how much money has been raised this far
585    * @param msgSender - who is the investor of this transaction
586    * @param decimals - how many decimal units the token has
587    * @return Amount of tokens the investor receives
588    */
589   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
590 }
591 
592 /*
593  * Haltable
594  *
595  * Abstract contract that allows children to implement an
596  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
597  *
598  *
599  * Originally envisioned in FirstBlood ICO contract.
600  */
601 contract Haltable is Ownable {
602   bool public halted;
603 
604   modifier stopInEmergency {
605     require(!halted);
606     //if (halted) throw;
607     _;
608   }
609 
610   modifier onlyInEmergency {
611     require(halted);
612     //if (!halted) throw;
613     _;
614   }
615 
616   // called by the owner on emergency, triggers stopped state
617   function halt() external onlyOwner {
618     halted = true;
619   }
620 
621   // called by the owner on end of emergency, returns to normal state
622   function unhalt() external onlyOwner onlyInEmergency {
623     halted = false;
624   }
625 
626 }
627 
628 
629 /**
630  * Abstract base contract for token sales.
631  *
632  * Handle
633  * - start and end dates
634  * - accepting investments
635  * - minimum funding goal and refund
636  * - various statistics during the crowdfund
637  * - different pricing strategies
638  * - different investment policies (require server side customer id, allow only whitelisted addresses)
639  *
640  */
641 contract Crowdsale is Allocatable, Haltable, SafeMathLib {
642 
643   /* Max investment count when we are still allowed to change the multisig address */
644   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
645 
646   /* The token we are selling */
647   FractionalERC20 public token;
648 
649   /* Token Vesting Contract */
650   address public tokenVestingAddress;
651 
652   /* How we are going to price our offering */
653   PricingStrategy public pricingStrategy;
654 
655   /* Post-success callback */
656   FinalizeAgent public finalizeAgent;
657 
658   /* tokens will be transfered from this address */
659   address public multisigWallet;
660 
661   /* if the funding goal is not reached, investors may withdraw their funds */
662   uint public minimumFundingGoal;
663 
664   /* the UNIX timestamp start date of the crowdsale */
665   uint public startsAt;
666 
667   /* the UNIX timestamp end date of the crowdsale */
668   uint public endsAt;
669 
670   /* the number of tokens already sold through this contract*/
671   uint public tokensSold = 0;
672 
673   /* How many wei of funding we have raised */
674   uint public weiRaised = 0;
675 
676   /* How many distinct addresses have invested */
677   uint public investorCount = 0;
678 
679   /* How much wei we have returned back to the contract after a failed crowdfund. */
680   uint public loadedRefund = 0;
681 
682   /* How much wei we have given back to investors.*/
683   uint public weiRefunded = 0;
684 
685   /* Has this crowdsale been finalized */
686   bool public finalized;
687 
688   /* Do we need to have unique contributor id for each customer */
689   bool public requireCustomerId;
690 
691   /**
692     * Do we verify that contributor has been cleared on the server side (accredited investors only).
693     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
694     */
695   bool public requiredSignedAddress;
696 
697   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
698   address public signerAddress;
699 
700   /** How much ETH each address has invested to this crowdsale */
701   mapping (address => uint256) public investedAmountOf;
702 
703   /** How much tokens this crowdsale has credited for each investor address */
704   mapping (address => uint256) public tokenAmountOf;
705 
706   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
707   mapping (address => bool) public earlyParticipantWhitelist;
708 
709   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
710   uint public ownerTestValue;
711 
712   /** State machine
713    *
714    * - Preparing: All contract initialization calls and variables have not been set yet
715    * - Prefunding: We have not passed start time yet
716    * - Funding: Active crowdsale
717    * - Success: Minimum funding goal reached
718    * - Failure: Minimum funding goal not reached before ending time
719    * - Finalized: The finalized has been called and succesfully executed
720    * - Refunding: Refunds are loaded on the contract for reclaim.
721    */
722   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
723 
724   // A new investment was made
725   event Invested(address investor, uint weiAmount, uint tokenAmount, string custId);
726 
727   // Refund was processed for a contributor
728   event Refund(address investor, uint weiAmount);
729 
730   // The rules were changed what kind of investments we accept
731   event InvestmentPolicyChanged(bool requireCustId, bool requiredSignedAddr, address signerAddr);
732 
733   // Address early participation whitelist status changed
734   event Whitelisted(address addr, bool status);
735 
736   // Crowdsale end time has been changed
737   event EndsAtChanged(uint endAt);
738 
739   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, 
740   uint _start, uint _end, uint _minimumFundingGoal, address _tokenVestingAddress) {
741 
742     owner = msg.sender;
743 
744     token = FractionalERC20(_token);
745 
746     tokenVestingAddress = _tokenVestingAddress;
747 
748     setPricingStrategy(_pricingStrategy);
749 
750     multisigWallet = _multisigWallet;
751     require(multisigWallet != 0);
752     // if(multisigWallet == 0) {
753     //     throw;
754     // }
755 
756     require(_start != 0);
757     // if(_start == 0) {
758     //     throw;
759     // }
760 
761     startsAt = _start;
762 
763     require(_end != 0);
764     // if(_end == 0) {
765     //     throw;
766     // }
767 
768     endsAt = _end;
769 
770     // Don't mess the dates
771     require(startsAt < endsAt);
772     // if(startsAt >= endsAt) {
773     //     throw;
774     // }
775 
776     // Minimum funding goal can be zero
777     minimumFundingGoal = _minimumFundingGoal;
778   }
779 
780   /**
781    * Don't expect to just send in money and get tokens.
782    */
783   function() payable {
784     require(false);
785   }
786 
787   /**
788    * Make an investment.
789    *
790    * Crowdsale must be running for one to invest.
791    * We must have not pressed the emergency brake.
792    *
793    * @param receiver The Ethereum address who receives the tokens
794    * @param customerId (optional) UUID v4 to track the successful payments on the server side
795    *
796    */
797   function investInternal(address receiver, string customerId) stopInEmergency private {
798 
799     // Determine if it's a good time to accept investment from this participant
800     if(getState() == State.PreFunding) {
801       // Are we whitelisted for early deposit
802       require(earlyParticipantWhitelist[receiver]);
803       // if(!earlyParticipantWhitelist[receiver]) {
804       //   throw;
805       // }
806     } else if(getState() == State.Funding) {
807       // Retail participants can only come in when the crowdsale is running
808       // pass
809     } else {
810       // Unwanted state
811       require(false);
812     }
813 
814     uint weiAmount = msg.value;
815     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
816 
817     require(tokenAmount != 0);
818     // if(tokenAmount == 0) {
819     //   // Dust transaction
820     //   throw;
821     // }
822 
823     if(investedAmountOf[receiver] == 0) {
824        // A new investor
825        investorCount++;
826     }
827 
828     // Update investor
829     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
830     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
831 
832     // Update totals
833     weiRaised = safeAdd(weiRaised,weiAmount);
834     tokensSold = safeAdd(tokensSold,tokenAmount);
835 
836     // Check that we did not bust the cap
837     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
838     // if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
839     //   throw;
840     // }
841 
842     assignTokens(receiver, tokenAmount);
843 
844     // Pocket the money
845     require(multisigWallet.send(weiAmount));
846 
847     // Tell us invest was success
848     Invested(receiver, weiAmount, tokenAmount, customerId);
849   }
850 
851   /**
852    * allocate tokens for the early investors.
853    *
854    * Preallocated tokens have been sold before the actual crowdsale opens.
855    * This function mints the tokens and moves the crowdsale needle.
856    *
857    * Investor count is not handled; it is assumed this goes for multiple investors
858    * and the token distribution happens outside the smart contract flow.
859    *
860    * No money is exchanged, as the crowdsale team already have received the payment.
861    *
862    * @param weiPrice Price of a single full token in wei
863    *
864    */
865   function allocate(address receiver, uint tokenAmount, uint weiPrice, string customerId,  uint lockedTokenAmount) public onlyAllocateAgent {
866 
867     // cannot lock more than total tokens
868     require(lockedTokenAmount <= tokenAmount);
869 
870     uint weiAmount = (weiPrice * tokenAmount)/10**uint(token.decimals()); // This can be also 0, we give out tokens for free
871 
872     weiRaised = safeAdd(weiRaised,weiAmount);
873     tokensSold = safeAdd(tokensSold,tokenAmount);
874 
875     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
876     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
877 
878     // assign locked token to Vesting contract
879     if (lockedTokenAmount > 0) {
880       TokenVesting tokenVesting = TokenVesting(tokenVestingAddress);
881       // to prevent minting of tokens which will be useless as vesting amount cannot be updated
882       require(!tokenVesting.isVestingSet(receiver));
883       assignTokens(tokenVestingAddress, lockedTokenAmount);
884       // set vesting with default schedule
885       tokenVesting.setVestingWithDefaultSchedule(receiver, lockedTokenAmount); 
886     }
887 
888     // assign remaining tokens to contributor
889     if (tokenAmount - lockedTokenAmount > 0) {
890       assignTokens(receiver, tokenAmount - lockedTokenAmount);
891     }
892 
893     // Tell us invest was success
894     Invested(receiver, weiAmount, tokenAmount, customerId);
895   }
896 
897   /**
898    * Allow anonymous contributions to this crowdsale.
899    */
900   // function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
901   //    bytes32 hash = sha256(addr);
902   //    if (ecrecover(hash, v, r, s) != signerAddress) throw;
903   //    require(customerId != 0);
904   //    //if(customerId == 0) throw;  // UUIDv4 sanity check
905   //    investInternal(addr, customerId);
906   // }
907 
908   /**
909    * Track who is the customer making the payment so we can send thank you email.
910    */
911   function investWithCustomerId(address addr, string customerId) public payable {
912     require(!requiredSignedAddress);
913     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
914     bytes memory custIdTest = bytes(customerId);
915     require(custIdTest.length != 0);
916     //if(customerId == 0) throw;  // UUIDv4 sanity check
917     investInternal(addr, customerId);
918   }
919 
920   /**
921    * Allow anonymous contributions to this crowdsale.
922    */
923   function invest(address addr) public payable {
924     require(!requireCustomerId);
925     //if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
926     
927     require(!requiredSignedAddress);
928     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
929     investInternal(addr, "");
930   }
931 
932   /**
933    * Invest to tokens, recognize the payer and clear his address.
934    *
935    */
936   
937   // function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
938   //   investWithSignedAddress(msg.sender, customerId, v, r, s);
939   // }
940 
941   /**
942    * Invest to tokens, recognize the payer.
943    *
944    */
945   function buyWithCustomerId(string customerId) public payable {
946     investWithCustomerId(msg.sender, customerId);
947   }
948 
949   /**
950    * The basic entry point to participate the crowdsale process.
951    *
952    * Pay for funding, get invested tokens back in the sender address.
953    */
954   function buy() public payable {
955     invest(msg.sender);
956   }
957 
958   /**
959    * Finalize a succcesful crowdsale.
960    *
961    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
962    */
963   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
964 
965     // Already finalized
966     require(!finalized);
967     // if(finalized) {
968     //   throw;
969     // }
970 
971     // Finalizing is optional. We only call it if we are given a finalizing agent.
972     if(address(finalizeAgent) != 0) {
973       finalizeAgent.finalizeCrowdsale();
974     }
975 
976     finalized = true;
977   }
978 
979   /**
980    * Allow to (re)set finalize agent.
981    *
982    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
983    */
984   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
985     finalizeAgent = addr;
986 
987     // Don't allow setting bad agent
988     require(finalizeAgent.isFinalizeAgent());
989     // if(!finalizeAgent.isFinalizeAgent()) {
990     //   throw;
991     // }
992   }
993 
994   /**
995    * Set policy do we need to have server-side customer ids for the investments.
996    *
997    */
998   function setRequireCustomerId(bool value) onlyOwner {
999     requireCustomerId = value;
1000     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1001   }
1002 
1003   /**
1004    * Set policy if all investors must be cleared on the server side first.
1005    *
1006    * This is e.g. for the accredited investor clearing.
1007    *
1008    */
1009   // function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
1010   //   requiredSignedAddress = value;
1011   //   signerAddress = _signerAddress;
1012   //   InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1013   // }
1014 
1015   /**
1016    * Allow addresses to do early participation.
1017    *
1018    * TODO: Fix spelling error in the name
1019    */
1020   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
1021     earlyParticipantWhitelist[addr] = status;
1022     Whitelisted(addr, status);
1023   }
1024 
1025   /**
1026    * Allow crowdsale owner to close early or extend the crowdsale.
1027    *
1028    * This is useful e.g. for a manual soft cap implementation:
1029    * - after X amount is reached determine manual closing
1030    *
1031    * This may put the crowdsale to an invalid state,
1032    * but we trust owners know what they are doing.
1033    *
1034    */
1035   function setEndsAt(uint time) onlyOwner {
1036 
1037     require(now <= time);
1038 
1039     endsAt = time;
1040     EndsAtChanged(endsAt);
1041   }
1042 
1043   /**
1044    * Allow to (re)set pricing strategy.
1045    *
1046    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1047    */
1048   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
1049     pricingStrategy = _pricingStrategy;
1050 
1051     // Don't allow setting bad agent
1052     require(pricingStrategy.isPricingStrategy());
1053     // if(!pricingStrategy.isPricingStrategy()) {
1054     //   throw;
1055     // }
1056   }
1057 
1058   /**
1059    * Allow to change the team multisig address in the case of emergency.
1060    *
1061    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1062    * (we have done only few test transactions). After the crowdsale is going
1063    * then multisig address stays locked for the safety reasons.
1064    */
1065   function setMultisig(address addr) public onlyOwner {
1066 
1067     // Change
1068     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
1069 
1070     multisigWallet = addr;
1071   }
1072 
1073   /**
1074    * Allow load refunds back on the contract for the refunding.
1075    *
1076    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1077    */
1078   function loadRefund() public payable inState(State.Failure) {
1079     require(msg.value != 0);
1080     //if(msg.value == 0) throw;
1081     loadedRefund = safeAdd(loadedRefund,msg.value);
1082   }
1083 
1084   /**
1085    * Investors can claim refund.
1086    */
1087   function refund() public inState(State.Refunding) {
1088     uint256 weiValue = investedAmountOf[msg.sender];
1089     require(weiValue != 0);
1090     //if (weiValue == 0) throw;
1091     investedAmountOf[msg.sender] = 0;
1092     weiRefunded = safeAdd(weiRefunded,weiValue);
1093     Refund(msg.sender, weiValue);
1094     require(msg.sender.send(weiValue));
1095   }
1096 
1097   /**
1098    * @return true if the crowdsale has raised enough money to be a succes
1099    */
1100   function isMinimumGoalReached() public constant returns (bool reached) {
1101     return weiRaised >= minimumFundingGoal;
1102   }
1103 
1104   /**
1105    * Check if the contract relationship looks good.
1106    */
1107   function isFinalizerSane() public constant returns (bool sane) {
1108     return finalizeAgent.isSane();
1109   }
1110 
1111   /**
1112    * Check if the contract relationship looks good.
1113    */
1114   function isPricingSane() public constant returns (bool sane) {
1115     return pricingStrategy.isSane(address(this));
1116   }
1117 
1118   /**
1119    * Crowdfund state machine management.
1120    *
1121    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1122    */
1123   function getState() public constant returns (State) {
1124     if(finalized) return State.Finalized;
1125     else if (address(finalizeAgent) == 0) return State.Preparing;
1126     else if (!finalizeAgent.isSane()) return State.Preparing;
1127     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1128     else if (block.timestamp < startsAt) return State.PreFunding;
1129     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1130     else if (isMinimumGoalReached()) return State.Success;
1131     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1132     else return State.Failure;
1133   }
1134 
1135   /** This is for manual testing of multisig wallet interaction */
1136   function setOwnerTestValue(uint val) onlyOwner {
1137     ownerTestValue = val;
1138   }
1139 
1140   /** Interface marker. */
1141   function isCrowdsale() public constant returns (bool) {
1142     return true;
1143   }
1144 
1145   //
1146   // Modifiers
1147   //
1148 
1149   /** Modified allowing execution only if the crowdsale is currently running.  */
1150   modifier inState(State state) {
1151     require(getState() == state);
1152     //if(getState() != state) throw;
1153     _;
1154   }
1155 
1156    //
1157   // Abstract functions
1158   //
1159 
1160   /**
1161    * Check if the current invested breaks our cap rules.
1162    *
1163    *
1164    * The child contract must define their own cap setting rules.
1165    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1166    * Called from invest().
1167    *
1168    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1169    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1170    * @param weiRaisedTotal What would be our total raised balance after this transaction
1171    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1172    *
1173    * @return true if taking this investment would break our cap rules
1174    */
1175   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1176   /**
1177    * Check if the current crowdsale is full and we can no longer sell any tokens.
1178    */
1179   function isCrowdsaleFull() public constant returns (bool);
1180 
1181   /**
1182    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1183    */
1184   function assignTokens(address receiver, uint tokenAmount) private;
1185 
1186 }
1187 
1188 
1189 
1190 /**
1191  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1192  *
1193  * Unlock tokens.
1194  *
1195  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1196  *
1197  */
1198 contract BonusFinalizeAgent is FinalizeAgent, SafeMathLib {
1199 
1200   CrowdsaleToken public token;
1201   Crowdsale public crowdsale;
1202 
1203   /** Total percent of tokens minted to the team at the end of the sale as base points (0.0001) */
1204   uint public totalMembers;
1205   uint public allocatedBonus;
1206   mapping (address=>uint) bonusOf;
1207   /** Where we move the tokens at the end of the sale. */
1208   address[] public teamAddresses;
1209 
1210 
1211   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint[] _bonusBasePoints, address[] _teamAddresses) {
1212     token = _token;
1213     crowdsale = _crowdsale;
1214 
1215     //crowdsale address must not be 0
1216     require(address(crowdsale) != 0);
1217 
1218     //bonus & team address array size must match
1219     require(_bonusBasePoints.length == _teamAddresses.length);
1220 
1221     totalMembers = _teamAddresses.length;
1222     teamAddresses = _teamAddresses;
1223     
1224     //if any of the bonus is 0 throw
1225     // otherwise sum it up in totalAllocatedBonus
1226     for (uint i=0;i<totalMembers;i++){
1227       require(_bonusBasePoints[i] != 0);
1228       //if(_bonusBasePoints[i] == 0) throw;
1229     }
1230 
1231     //if any of the address is 0 or invalid throw
1232     //otherwise initialize the bonusOf array
1233     for (uint j=0;j<totalMembers;j++){
1234       require(_teamAddresses[j] != 0);
1235       //if(_teamAddresses[j] == 0) throw;
1236       bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];
1237     }
1238   }
1239 
1240   /* Can we run finalize properly */
1241   function isSane() public constant returns (bool) {
1242     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
1243   }
1244 
1245   /** Called once by crowdsale finalize() if the sale was success. */
1246   function finalizeCrowdsale() {
1247 
1248     // if finalized is not being called from the crowdsale 
1249     // contract then throw
1250     require(msg.sender == address(crowdsale));
1251 
1252     // if(msg.sender != address(crowdsale)) {
1253     //   throw;
1254     // }
1255 
1256     // get the total sold tokens count.
1257     uint tokensSold = crowdsale.tokensSold();
1258 
1259     for (uint i=0;i<totalMembers;i++){
1260       allocatedBonus = safeMul(tokensSold, bonusOf[teamAddresses[i]]) / 10000;
1261       // move tokens to the team multisig wallet
1262       token.mint(teamAddresses[i], allocatedBonus);
1263     }
1264 
1265     // Make token transferable
1266     // realease them in the wild
1267     // Hell yeah!!! we did it.
1268     token.releaseTokenTransfer();
1269   }
1270 
1271 }
1272 
1273 /**
1274  * ICO crowdsale contract that is capped by amout of ETH.
1275  *
1276  * - Tokens are dynamically created during the crowdsale
1277  *
1278  *
1279  */
1280 
1281 contract MintedEthCappedCrowdsale is Crowdsale {
1282 
1283   /* Maximum amount of wei this crowdsale can raise. */
1284   uint public weiCap;
1285 
1286   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, 
1287     address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap, 
1288     address _tokenVestingAddress) 
1289     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, 
1290     _tokenVestingAddress) {
1291     
1292     weiCap = _weiCap;
1293   }
1294 
1295   /**
1296    * Called from invest() to confirm if the curret investment does not break our cap rule.
1297    */
1298   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1299     return weiRaisedTotal > weiCap;
1300   }
1301 
1302   function isCrowdsaleFull() public constant returns (bool) {
1303     return weiRaised >= weiCap;
1304   }
1305 
1306   /**
1307    * Dynamically create tokens and assign them to the investor.
1308    */
1309   function assignTokens(address receiver, uint tokenAmount) private {
1310     MintableToken mintableToken = MintableToken(token);
1311     mintableToken.mint(receiver, tokenAmount);
1312   }
1313 }
1314 
1315 
1316 
1317 /** Tranche based pricing with special support for pre-ico deals.
1318  *      Implementing "first price" tranches, meaning, that if byers order is
1319  *      covering more than one tranche, the price of the lowest tranche will apply
1320  *      to the whole order.
1321  */
1322 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
1323 
1324   uint public constant MAX_TRANCHES = 10;
1325  
1326  
1327   // This contains all pre-ICO addresses, and their prices (weis per token)
1328   mapping (address => uint) public preicoAddresses;
1329 
1330   /**
1331   * Define pricing schedule using tranches.
1332   */
1333 
1334   struct Tranche {
1335       // Amount in weis when this tranche becomes active
1336       uint amount;
1337       // How many tokens per wei you will get while this tranche is active
1338       uint price;
1339   }
1340 
1341   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
1342   // Tranche 0 is always (0, 0)
1343   // (TODO: change this when we confirm dynamic arrays are explorable)
1344   Tranche[10] public tranches;
1345 
1346   // How many active tranches we have
1347   uint public trancheCount;
1348 
1349   /// @dev Contruction, creating a list of tranches
1350   /// @param _tranches uint[] tranches Pairs of (start amount, price)
1351   function EthTranchePricing(uint[] _tranches) {
1352     // [ 0, 666666666666666,
1353     //   3000000000000000000000, 769230769230769,
1354     //   5000000000000000000000, 909090909090909,
1355     //   8000000000000000000000, 952380952380952,
1356     //   2000000000000000000000, 1000000000000000 ]
1357     // Need to have tuples, length check
1358     require(!(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2));
1359     // if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
1360     //   throw;
1361     // }
1362     trancheCount = _tranches.length / 2;
1363     uint highestAmount = 0;
1364     for(uint i=0; i<_tranches.length/2; i++) {
1365       tranches[i].amount = _tranches[i*2];
1366       tranches[i].price = _tranches[i*2+1];
1367       // No invalid steps
1368       require(!((highestAmount != 0) && (tranches[i].amount <= highestAmount)));
1369       // if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
1370       //   throw;
1371       // }
1372       highestAmount = tranches[i].amount;
1373     }
1374 
1375     // We need to start from zero, otherwise we blow up our deployment
1376     require(tranches[0].amount == 0);
1377     // if(tranches[0].amount != 0) {
1378     //   throw;
1379     // }
1380 
1381     // Last tranche price must be zero, terminating the crowdale
1382     require(tranches[trancheCount-1].price == 0);
1383     // if(tranches[trancheCount-1].price != 0) {
1384     //   throw;
1385     // }
1386   }
1387 
1388   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1389   ///      to 0 to disable
1390   /// @param preicoAddress PresaleFundCollector address
1391   /// @param pricePerToken How many weis one token cost for pre-ico investors
1392   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1393     public
1394     onlyOwner
1395   {
1396     preicoAddresses[preicoAddress] = pricePerToken;
1397   }
1398 
1399   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1400   /// @return tuple (time, price)
1401   function getTranche(uint n) public constant returns (uint, uint) {
1402     return (tranches[n].amount, tranches[n].price);
1403   }
1404 
1405   function getFirstTranche() private constant returns (Tranche) {
1406     return tranches[0];
1407   }
1408 
1409   function getLastTranche() private constant returns (Tranche) {
1410     return tranches[trancheCount-1];
1411   }
1412 
1413   function getPricingStartsAt() public constant returns (uint) {
1414     return getFirstTranche().amount;
1415   }
1416 
1417   function getPricingEndsAt() public constant returns (uint) {
1418     return getLastTranche().amount;
1419   }
1420 
1421   function isSane(address _crowdsale) public constant returns(bool) {
1422     // Our tranches are not bound by time, so we can't really check are we sane
1423     // so we presume we are ;)
1424     // In the future we could save and track raised tokens, and compare it to
1425     // the Crowdsale contract.
1426     return true;
1427   }
1428 
1429   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1430   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1431   /// @return {[type]} [description]
1432   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
1433     uint i;
1434     for(i=0; i < tranches.length; i++) {
1435       if(weiRaised < tranches[i].amount) {
1436         return tranches[i-1];
1437       }
1438     }
1439   }
1440 
1441   /// @dev Get the current price.
1442   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1443   /// @return The current price or 0 if we are outside trache ranges
1444   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
1445     return getCurrentTranche(weiRaised).price;
1446   }
1447 
1448   /// @dev Calculate the current price for buy in amount.
1449   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1450 
1451     uint multiplier = 10 ** decimals;
1452 
1453     // This investor is coming through pre-ico
1454     if(preicoAddresses[msgSender] > 0) {
1455       return safeMul(value, multiplier) / preicoAddresses[msgSender];
1456     }
1457 
1458     uint price = getCurrentPrice(weiRaised);
1459     
1460     return safeMul(value, multiplier) / price;
1461   }
1462 
1463   function() payable {
1464     require(false); // No money on this contract
1465   }
1466 
1467 }
1468 
1469 
1470 /**
1471  * Contract to enforce Token Vesting
1472  */
1473 contract TokenVesting is Allocatable, SafeMathLib {
1474 
1475     address public LALATokenAddress;
1476 
1477     /** keep track of total tokens yet to be released, 
1478      * this should be less than or equal to LALA tokens held by this contract. 
1479      */
1480     uint public totalUnreleasedTokens;
1481 
1482     // default vesting parameters
1483     uint startAt = 0;
1484     uint cliff = 3;
1485     uint duration = 12; 
1486     uint step = 2592000;
1487     bool changeFreezed = false;
1488 
1489     struct VestingSchedule {
1490         uint startAt;
1491         uint cliff;
1492         uint duration;
1493         uint step;
1494         uint amount;
1495         uint amountReleased;
1496         bool changeFreezed;
1497     }
1498 
1499     mapping (address => VestingSchedule) public vestingMap;
1500 
1501     event VestedTokensReleased(address _adr, uint _amount);
1502 
1503 
1504     function TokenVesting(address _LALATokenAddress) {
1505         LALATokenAddress = _LALATokenAddress;
1506     }
1507 
1508 
1509     /** Modifier to check if changes to vesting is freezed  */
1510     modifier changesToVestingFreezed(address _adr){
1511         require(vestingMap[_adr].changeFreezed);
1512         _;
1513     }
1514 
1515 
1516     /** Modifier to check if changes to vesting is not freezed yet  */
1517     modifier changesToVestingNotFreezed(address adr) {
1518         require(!vestingMap[adr].changeFreezed); // if vesting not set then also changeFreezed will be false
1519         _;
1520     }
1521 
1522 
1523     /** Function to set default vesting schedule parameters. */
1524     function setDefaultVestingParameters(uint _startAt, uint _cliff, uint _duration, 
1525         uint _step, bool _changeFreezed) onlyAllocateAgent {
1526 
1527         // data validation
1528         require(_step != 0);
1529         require(_duration != 0);
1530         require(_cliff <= _duration);
1531 
1532         startAt = _startAt;
1533         cliff = _cliff;
1534         duration = _duration; 
1535         step = _step;
1536         changeFreezed = _changeFreezed;
1537 
1538     }
1539 
1540     /** Function to set vesting with default schedule. */
1541     function setVestingWithDefaultSchedule(address _adr, uint _amount) 
1542         changesToVestingNotFreezed(_adr) onlyAllocateAgent {
1543         setVesting(_adr, startAt, cliff, duration, step, _amount, changeFreezed);
1544     }
1545 
1546     /** Function to set/update vesting schedule. PS - Amount cannot be changed once set */
1547     function setVesting(address _adr, uint _startAt, uint _cliff, uint _duration, 
1548         uint _step, uint _amount, bool _changeFreezed) changesToVestingNotFreezed(_adr) onlyAllocateAgent {
1549 
1550         VestingSchedule storage vestingSchedule = vestingMap[_adr];
1551 
1552         // data validation
1553         require(_step != 0);
1554         require(_amount != 0 || vestingSchedule.amount > 0);
1555         require(_duration != 0);
1556         require(_cliff <= _duration);
1557 
1558         //if startAt is zero, set current time as start time.
1559         if (_startAt == 0) 
1560             _startAt = block.timestamp;
1561 
1562         vestingSchedule.startAt = _startAt;
1563         vestingSchedule.cliff = _cliff;
1564         vestingSchedule.duration = _duration;
1565         vestingSchedule.step = _step;
1566 
1567         // special processing for first time vesting setting
1568         if (vestingSchedule.amount == 0) {
1569             // check if enough tokens are held by this contract
1570             ERC20 LALAToken = ERC20(LALATokenAddress);
1571             require(LALAToken.balanceOf(this) >= safeAdd(totalUnreleasedTokens, _amount));
1572             totalUnreleasedTokens = safeAdd(totalUnreleasedTokens, _amount);
1573             vestingSchedule.amount = _amount; 
1574         }
1575 
1576         vestingSchedule.amountReleased = 0;
1577         vestingSchedule.changeFreezed = _changeFreezed;
1578     }
1579 
1580     function isVestingSet(address adr) public constant returns (bool isSet) {
1581         return vestingMap[adr].amount != 0;
1582     }
1583 
1584     function freezeChangesToVesting(address _adr) changesToVestingNotFreezed(_adr) onlyAllocateAgent {
1585         require(isVestingSet(_adr)); // first check if vesting is set
1586         vestingMap[_adr].changeFreezed = true;
1587     }
1588 
1589 
1590     /** Release tokens as per vesting schedule, called by contributor  */
1591     function releaseMyVestedTokens() changesToVestingFreezed(msg.sender) {
1592         releaseVestedTokens(msg.sender);
1593     }
1594 
1595     /** Release tokens as per vesting schedule, called by anyone  */
1596     function releaseVestedTokens(address _adr) changesToVestingFreezed(_adr) {
1597         VestingSchedule storage vestingSchedule = vestingMap[_adr];
1598         
1599         // check if all tokens are not vested
1600         require(safeSub(vestingSchedule.amount, vestingSchedule.amountReleased) > 0);
1601         
1602         // calculate total vested tokens till now
1603         uint totalTime = block.timestamp - vestingSchedule.startAt;
1604         uint totalSteps = totalTime / vestingSchedule.step;
1605 
1606         // check if cliff is passed
1607         require(vestingSchedule.cliff <= totalSteps);
1608 
1609         uint tokensPerStep = vestingSchedule.amount / vestingSchedule.duration;
1610         // check if amount is divisble by duration
1611         if(tokensPerStep * vestingSchedule.duration != vestingSchedule.amount) tokensPerStep++;
1612 
1613         uint totalReleasableAmount = safeMul(tokensPerStep, totalSteps);
1614 
1615         // handle the case if user has not claimed even after vesting period is over or amount was not divisible
1616         if(totalReleasableAmount > vestingSchedule.amount) totalReleasableAmount = vestingSchedule.amount;
1617 
1618         uint amountToRelease = safeSub(totalReleasableAmount, vestingSchedule.amountReleased);
1619         vestingSchedule.amountReleased = safeAdd(vestingSchedule.amountReleased, amountToRelease);
1620 
1621         // transfer vested tokens
1622         ERC20 LALAToken = ERC20(LALATokenAddress);
1623         LALAToken.transfer(_adr, amountToRelease);
1624         // decrement overall unreleased token count
1625         totalUnreleasedTokens = safeSub(totalUnreleasedTokens, amountToRelease);
1626         VestedTokensReleased(_adr, amountToRelease);
1627     }
1628 
1629 }