1 pragma solidity ^0.4.11;
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
203     if (value == 0) throw;
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
421 /**
422  * A crowdsaled token.
423  *
424  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
425  *
426  * - The token transfer() is disabled until the crowdsale is over
427  * - The token contract gives an opt-in upgrade path to a new contract
428  * - The same token can be part of several crowdsales through approve() mechanism
429  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
430  *
431  */
432 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
433 
434   event UpdatedTokenInformation(string newName, string newSymbol);
435 
436   string public name;
437 
438   string public symbol;
439 
440   uint8 public decimals;
441 
442   /**
443    * Construct the token.
444    *
445    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
446    *
447    * @param _name Token name
448    * @param _symbol Token symbol - should be all caps
449    * @param _initialSupply How many tokens we start with
450    * @param _decimals Number of decimal places
451    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
452    */
453   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, bool _mintable)
454     UpgradeableToken(msg.sender) {
455 
456     // Create any address, can be transferred
457     // to team multisig via changeOwner(),
458     // also remember to call setUpgradeMaster()
459     owner = msg.sender;
460 
461     name = _name;
462     symbol = _symbol;
463 
464     totalSupply = _initialSupply;
465 
466     decimals = _decimals;
467 
468     // Create initially all balance on the team multisig
469     balances[owner] = totalSupply;
470 
471     if(totalSupply > 0) {
472       Minted(owner, totalSupply);
473     }
474 
475     // No more new supply allowed after the token creation
476     if(!_mintable) {
477       mintingFinished = true;
478       require(totalSupply != 0);
479       // if(totalSupply == 0) {
480       //   throw; // Cannot create a token without supply and no minting
481       // }
482     }
483   }
484 
485   /**
486    * When token is released to be transferable, enforce no new tokens can be created.
487    */
488   function releaseTokenTransfer() public onlyReleaseAgent {
489     mintingFinished = true;
490     super.releaseTokenTransfer();
491   }
492 
493   /**
494    * Allow upgrade agent functionality kick in only if the crowdsale was success.
495    */
496   function canUpgrade() public constant returns(bool) {
497     return released && super.canUpgrade();
498   }
499 
500   /**
501    * Owner can update token information here
502    */
503   function setTokenInformation(string _name, string _symbol) onlyOwner {
504     name = _name;
505     symbol = _symbol;
506     UpdatedTokenInformation(name, symbol);
507   }
508 
509 }
510 
511 /**
512  * Finalize agent defines what happens at the end of succeseful crowdsale.
513  *
514  * - Allocate tokens for founders, bounties and community
515  * - Make tokens transferable
516  * - etc.
517  */
518 contract FinalizeAgent {
519 
520   function isFinalizeAgent() public constant returns(bool) {
521     return true;
522   }
523 
524   /** Return true if we can run finalizeCrowdsale() properly.
525    *
526    * This is a safety check function that doesn't allow crowdsale to begin
527    * unless the finalizer has been set up properly.
528    */
529   function isSane() public constant returns (bool);
530 
531   /** Called once by crowdsale finalize() if the sale was success. */
532   function finalizeCrowdsale();
533 
534 }
535 
536 /**
537  * Interface for defining crowdsale pricing.
538  */
539 contract PricingStrategy {
540 
541   /** Interface declaration. */
542   function isPricingStrategy() public constant returns (bool) {
543     return true;
544   }
545 
546   /** Self check if all references are correctly set.
547    *
548    * Checks that pricing strategy matches crowdsale parameters.
549    */
550   function isSane(address crowdsale) public constant returns (bool) {
551     return true;
552   }
553 
554   /**
555    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
556    *
557    *
558    * @param value - What is the value of the transaction send in as wei
559    * @param tokensSold - how much tokens have been sold this far
560    * @param weiRaised - how much money has been raised this far
561    * @param msgSender - who is the investor of this transaction
562    * @param decimals - how many decimal units the token has
563    * @return Amount of tokens the investor receives
564    */
565   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
566 }
567 
568 /*
569  * Haltable
570  *
571  * Abstract contract that allows children to implement an
572  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
573  *
574  *
575  * Originally envisioned in FirstBlood ICO contract.
576  */
577 contract Haltable is Ownable {
578   bool public halted;
579 
580   modifier stopInEmergency {
581     require(!halted);
582     //if (halted) throw;
583     _;
584   }
585 
586   modifier onlyInEmergency {
587     require(halted);
588     //if (!halted) throw;
589     _;
590   }
591 
592   // called by the owner on emergency, triggers stopped state
593   function halt() external onlyOwner {
594     halted = true;
595   }
596 
597   // called by the owner on end of emergency, returns to normal state
598   function unhalt() external onlyOwner onlyInEmergency {
599     halted = false;
600   }
601 
602 }
603 
604 /**
605  * Abstract base contract for token sales.
606  *
607  * Handle
608  * - start and end dates
609  * - accepting investments
610  * - minimum funding goal and refund
611  * - various statistics during the crowdfund
612  * - different pricing strategies
613  * - different investment policies (require server side customer id, allow only whitelisted addresses)
614  *
615  */
616 contract Crowdsale is Haltable, SafeMathLib {
617 
618   /* Max investment count when we are still allowed to change the multisig address */
619   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
620 
621   /* The token we are selling */
622   FractionalERC20 public token;
623 
624   /* How we are going to price our offering */
625   PricingStrategy public pricingStrategy;
626 
627   /* Post-success callback */
628   FinalizeAgent public finalizeAgent;
629 
630   /* tokens will be transfered from this address */
631   address public multisigWallet;
632 
633   /* if the funding goal is not reached, investors may withdraw their funds */
634   uint public minimumFundingGoal;
635 
636   /* the UNIX timestamp start date of the crowdsale */
637   uint public startsAt;
638 
639   /* the UNIX timestamp end date of the crowdsale */
640   uint public endsAt;
641 
642   /* the number of tokens already sold through this contract*/
643   uint public tokensSold = 0;
644 
645   /* How many wei of funding we have raised */
646   uint public weiRaised = 0;
647 
648   /* How many distinct addresses have invested */
649   uint public investorCount = 0;
650 
651   /* How much wei we have returned back to the contract after a failed crowdfund. */
652   uint public loadedRefund = 0;
653 
654   /* How much wei we have given back to investors.*/
655   uint public weiRefunded = 0;
656 
657   /* Has this crowdsale been finalized */
658   bool public finalized;
659 
660   /* Do we need to have unique contributor id for each customer */
661   bool public requireCustomerId;
662 
663   /**
664     * Do we verify that contributor has been cleared on the server side (accredited investors only).
665     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
666     */
667   bool public requiredSignedAddress;
668 
669   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
670   address public signerAddress;
671 
672   /** How much ETH each address has invested to this crowdsale */
673   mapping (address => uint256) public investedAmountOf;
674 
675   /** How much tokens this crowdsale has credited for each investor address */
676   mapping (address => uint256) public tokenAmountOf;
677 
678   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
679   mapping (address => bool) public earlyParticipantWhitelist;
680 
681   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
682   uint public ownerTestValue;
683 
684   /** State machine
685    *
686    * - Preparing: All contract initialization calls and variables have not been set yet
687    * - Prefunding: We have not passed start time yet
688    * - Funding: Active crowdsale
689    * - Success: Minimum funding goal reached
690    * - Failure: Minimum funding goal not reached before ending time
691    * - Finalized: The finalized has been called and succesfully executed
692    * - Refunding: Refunds are loaded on the contract for reclaim.
693    */
694   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
695 
696   // A new investment was made
697   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
698 
699   // Refund was processed for a contributor
700   event Refund(address investor, uint weiAmount);
701 
702   // The rules were changed what kind of investments we accept
703   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
704 
705   // Address early participation whitelist status changed
706   event Whitelisted(address addr, bool status);
707 
708   // Crowdsale end time has been changed
709   event EndsAtChanged(uint endsAt);
710 
711   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
712 
713     owner = msg.sender;
714 
715     token = FractionalERC20(_token);
716 
717     setPricingStrategy(_pricingStrategy);
718 
719     multisigWallet = _multisigWallet;
720     require(multisigWallet != 0);
721     // if(multisigWallet == 0) {
722     //     throw;
723     // }
724 
725     require(_start != 0);
726     // if(_start == 0) {
727     //     throw;
728     // }
729 
730     startsAt = _start;
731 
732     require(_end != 0);
733     // if(_end == 0) {
734     //     throw;
735     // }
736 
737     endsAt = _end;
738 
739     // Don't mess the dates
740     require(startsAt < endsAt);
741     // if(startsAt >= endsAt) {
742     //     throw;
743     // }
744 
745     // Minimum funding goal can be zero
746     minimumFundingGoal = _minimumFundingGoal;
747   }
748 
749   /**
750    * Don't expect to just send in money and get tokens.
751    */
752   function() payable {
753     throw;
754   }
755 
756   /**
757    * Make an investment.
758    *
759    * Crowdsale must be running for one to invest.
760    * We must have not pressed the emergency brake.
761    *
762    * @param receiver The Ethereum address who receives the tokens
763    * @param customerId (optional) UUID v4 to track the successful payments on the server side
764    *
765    */
766   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
767 
768     // Determine if it's a good time to accept investment from this participant
769     if(getState() == State.PreFunding) {
770       // Are we whitelisted for early deposit
771       require(earlyParticipantWhitelist[receiver]);
772       // if(!earlyParticipantWhitelist[receiver]) {
773       //   throw;
774       // }
775     } else if(getState() == State.Funding) {
776       // Retail participants can only come in when the crowdsale is running
777       // pass
778     } else {
779       // Unwanted state
780       throw;
781     }
782 
783     uint weiAmount = msg.value;
784     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
785 
786     require(tokenAmount != 0);
787     // if(tokenAmount == 0) {
788     //   // Dust transaction
789     //   throw;
790     // }
791 
792     if(investedAmountOf[receiver] == 0) {
793        // A new investor
794        investorCount++;
795     }
796 
797     // Update investor
798     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
799     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
800 
801     // Update totals
802     weiRaised = safeAdd(weiRaised,weiAmount);
803     tokensSold = safeAdd(tokensSold,tokenAmount);
804 
805     // Check that we did not bust the cap
806     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
807     // if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
808     //   throw;
809     // }
810 
811     assignTokens(receiver, tokenAmount);
812 
813     // Pocket the money
814     if(!multisigWallet.send(weiAmount)) throw;
815 
816     // Tell us invest was success
817     Invested(receiver, weiAmount, tokenAmount, customerId);
818   }
819 
820   /**
821    * Preallocate tokens for the early investors.
822    *
823    * Preallocated tokens have been sold before the actual crowdsale opens.
824    * This function mints the tokens and moves the crowdsale needle.
825    *
826    * Investor count is not handled; it is assumed this goes for multiple investors
827    * and the token distribution happens outside the smart contract flow.
828    *
829    * No money is exchanged, as the crowdsale team already have received the payment.
830    *
831    * @param fullTokens tokens as full tokens - decimal places added internally
832    * @param weiPrice Price of a single full token in wei
833    *
834    */
835   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
836 
837     uint tokenAmount = fullTokens * 10**uint(token.decimals());
838     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
839 
840     weiRaised = safeAdd(weiRaised,weiAmount);
841     tokensSold = safeAdd(tokensSold,tokenAmount);
842 
843     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
844     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
845 
846     assignTokens(receiver, tokenAmount);
847 
848     // Tell us invest was success
849     Invested(receiver, weiAmount, tokenAmount, 0);
850   }
851 
852   /**
853    * Allow anonymous contributions to this crowdsale.
854    */
855   // function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
856   //    bytes32 hash = sha256(addr);
857   //    if (ecrecover(hash, v, r, s) != signerAddress) throw;
858   //    require(customerId != 0);
859   //    //if(customerId == 0) throw;  // UUIDv4 sanity check
860   //    investInternal(addr, customerId);
861   // }
862 
863   /**
864    * Track who is the customer making the payment so we can send thank you email.
865    */
866   function investWithCustomerId(address addr, uint128 customerId) public payable {
867     require(!requiredSignedAddress);
868     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
869     
870     require(customerId != 0);
871     //if(customerId == 0) throw;  // UUIDv4 sanity check
872     investInternal(addr, customerId);
873   }
874 
875   /**
876    * Allow anonymous contributions to this crowdsale.
877    */
878   function invest(address addr) public payable {
879     require(!requireCustomerId);
880     //if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
881     
882     require(!requiredSignedAddress);
883     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
884     investInternal(addr, 0);
885   }
886 
887   /**
888    * Invest to tokens, recognize the payer and clear his address.
889    *
890    */
891   
892   // function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
893   //   investWithSignedAddress(msg.sender, customerId, v, r, s);
894   // }
895 
896   /**
897    * Invest to tokens, recognize the payer.
898    *
899    */
900   function buyWithCustomerId(uint128 customerId) public payable {
901     investWithCustomerId(msg.sender, customerId);
902   }
903 
904   /**
905    * The basic entry point to participate the crowdsale process.
906    *
907    * Pay for funding, get invested tokens back in the sender address.
908    */
909   function buy() public payable {
910     invest(msg.sender);
911   }
912 
913   /**
914    * Finalize a succcesful crowdsale.
915    *
916    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
917    */
918   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
919 
920     // Already finalized
921     require(!finalized);
922     // if(finalized) {
923     //   throw;
924     // }
925 
926     // Finalizing is optional. We only call it if we are given a finalizing agent.
927     if(address(finalizeAgent) != 0) {
928       finalizeAgent.finalizeCrowdsale();
929     }
930 
931     finalized = true;
932   }
933 
934   /**
935    * Allow to (re)set finalize agent.
936    *
937    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
938    */
939   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
940     finalizeAgent = addr;
941 
942     // Don't allow setting bad agent
943     require(finalizeAgent.isFinalizeAgent());
944     // if(!finalizeAgent.isFinalizeAgent()) {
945     //   throw;
946     // }
947   }
948 
949   /**
950    * Set policy do we need to have server-side customer ids for the investments.
951    *
952    */
953   function setRequireCustomerId(bool value) onlyOwner {
954     requireCustomerId = value;
955     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
956   }
957 
958   /**
959    * Set policy if all investors must be cleared on the server side first.
960    *
961    * This is e.g. for the accredited investor clearing.
962    *
963    */
964   // function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
965   //   requiredSignedAddress = value;
966   //   signerAddress = _signerAddress;
967   //   InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
968   // }
969 
970   /**
971    * Allow addresses to do early participation.
972    *
973    * TODO: Fix spelling error in the name
974    */
975   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
976     earlyParticipantWhitelist[addr] = status;
977     Whitelisted(addr, status);
978   }
979 
980   /**
981    * Allow crowdsale owner to close early or extend the crowdsale.
982    *
983    * This is useful e.g. for a manual soft cap implementation:
984    * - after X amount is reached determine manual closing
985    *
986    * This may put the crowdsale to an invalid state,
987    * but we trust owners know what they are doing.
988    *
989    */
990   function setEndsAt(uint time) onlyOwner {
991 
992     if(now > time) {
993       throw; // Don't change past
994     }
995 
996     endsAt = time;
997     EndsAtChanged(endsAt);
998   }
999 
1000   /**
1001    * Allow to (re)set pricing strategy.
1002    *
1003    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1004    */
1005   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
1006     pricingStrategy = _pricingStrategy;
1007 
1008     // Don't allow setting bad agent
1009     require(pricingStrategy.isPricingStrategy());
1010     // if(!pricingStrategy.isPricingStrategy()) {
1011     //   throw;
1012     // }
1013   }
1014 
1015   /**
1016    * Allow to change the team multisig address in the case of emergency.
1017    *
1018    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1019    * (we have done only few test transactions). After the crowdsale is going
1020    * then multisig address stays locked for the safety reasons.
1021    */
1022   function setMultisig(address addr) public onlyOwner {
1023 
1024     // Change
1025     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
1026       throw;
1027     }
1028 
1029     multisigWallet = addr;
1030   }
1031 
1032   /**
1033    * Allow load refunds back on the contract for the refunding.
1034    *
1035    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1036    */
1037   function loadRefund() public payable inState(State.Failure) {
1038     require(msg.value != 0);
1039     //if(msg.value == 0) throw;
1040     loadedRefund = safeAdd(loadedRefund,msg.value);
1041   }
1042 
1043   /**
1044    * Investors can claim refund.
1045    */
1046   function refund() public inState(State.Refunding) {
1047     uint256 weiValue = investedAmountOf[msg.sender];
1048     require(weiValue != 0);
1049     //if (weiValue == 0) throw;
1050     investedAmountOf[msg.sender] = 0;
1051     weiRefunded = safeAdd(weiRefunded,weiValue);
1052     Refund(msg.sender, weiValue);
1053     if (!msg.sender.send(weiValue)) throw;
1054   }
1055 
1056   /**
1057    * @return true if the crowdsale has raised enough money to be a succes
1058    */
1059   function isMinimumGoalReached() public constant returns (bool reached) {
1060     return weiRaised >= minimumFundingGoal;
1061   }
1062 
1063   /**
1064    * Check if the contract relationship looks good.
1065    */
1066   function isFinalizerSane() public constant returns (bool sane) {
1067     return finalizeAgent.isSane();
1068   }
1069 
1070   /**
1071    * Check if the contract relationship looks good.
1072    */
1073   function isPricingSane() public constant returns (bool sane) {
1074     return pricingStrategy.isSane(address(this));
1075   }
1076 
1077   /**
1078    * Crowdfund state machine management.
1079    *
1080    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1081    */
1082   function getState() public constant returns (State) {
1083     if(finalized) return State.Finalized;
1084     else if (address(finalizeAgent) == 0) return State.Preparing;
1085     else if (!finalizeAgent.isSane()) return State.Preparing;
1086     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1087     else if (block.timestamp < startsAt) return State.PreFunding;
1088     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1089     else if (isMinimumGoalReached()) return State.Success;
1090     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1091     else return State.Failure;
1092   }
1093 
1094   /** This is for manual testing of multisig wallet interaction */
1095   function setOwnerTestValue(uint val) onlyOwner {
1096     ownerTestValue = val;
1097   }
1098 
1099   /** Interface marker. */
1100   function isCrowdsale() public constant returns (bool) {
1101     return true;
1102   }
1103 
1104   //
1105   // Modifiers
1106   //
1107 
1108   /** Modified allowing execution only if the crowdsale is currently running.  */
1109   modifier inState(State state) {
1110     require(getState() == state);
1111     //if(getState() != state) throw;
1112     _;
1113   }
1114 
1115 
1116   //
1117   // Abstract functions
1118   //
1119 
1120   /**
1121    * Check if the current invested breaks our cap rules.
1122    *
1123    *
1124    * The child contract must define their own cap setting rules.
1125    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1126    * Called from invest().
1127    *
1128    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1129    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1130    * @param weiRaisedTotal What would be our total raised balance after this transaction
1131    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1132    *
1133    * @return true if taking this investment would break our cap rules
1134    */
1135   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1136   /**
1137    * Check if the current crowdsale is full and we can no longer sell any tokens.
1138    */
1139   function isCrowdsaleFull() public constant returns (bool);
1140 
1141   /**
1142    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1143    */
1144   function assignTokens(address receiver, uint tokenAmount) private;
1145 }
1146 
1147 /**
1148  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1149  *
1150  * Unlock tokens.
1151  *
1152  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1153  *
1154  */
1155 contract BonusFinalizeAgent is FinalizeAgent, SafeMathLib {
1156 
1157   CrowdsaleToken public token;
1158   Crowdsale public crowdsale;
1159 
1160   /** Total percent of tokens minted to the team at the end of the sale as base points (0.0001) */
1161   uint public totalMembers;
1162   uint public allocatedBonus;
1163   mapping (address=>uint) bonusOf;
1164   /** Where we move the tokens at the end of the sale. */
1165   address[] public teamAddresses;
1166 
1167 
1168   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint[] _bonusBasePoints, address[] _teamAddresses) {
1169     token = _token;
1170     crowdsale = _crowdsale;
1171 
1172     //crowdsale address must not be 0
1173     require(address(crowdsale) != 0);
1174 
1175     //bonus & team address array size must match
1176     require(_bonusBasePoints.length == _teamAddresses.length);
1177 
1178     totalMembers = _teamAddresses.length;
1179     teamAddresses = _teamAddresses;
1180     
1181     //if any of the bonus is 0 throw
1182     // otherwise sum it up in totalAllocatedBonus
1183     for (uint i=0;i<totalMembers;i++){
1184       require(_bonusBasePoints[i] != 0);
1185       //if(_bonusBasePoints[i] == 0) throw;
1186     }
1187 
1188     //if any of the address is 0 or invalid throw
1189     //otherwise initialize the bonusOf array
1190     for (uint j=0;j<totalMembers;j++){
1191       require(_teamAddresses[j] != 0);
1192       //if(_teamAddresses[j] == 0) throw;
1193       bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];
1194     }
1195   }
1196 
1197   /* Can we run finalize properly */
1198   function isSane() public constant returns (bool) {
1199     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
1200   }
1201 
1202   /** Called once by crowdsale finalize() if the sale was success. */
1203   function finalizeCrowdsale() {
1204 
1205     // if finalized is not being called from the crowdsale 
1206     // contract then throw
1207     require(msg.sender == address(crowdsale));
1208 
1209     // if(msg.sender != address(crowdsale)) {
1210     //   throw;
1211     // }
1212 
1213     // get the total sold tokens count.
1214     uint tokensSold = crowdsale.tokensSold();
1215 
1216     for (uint i=0;i<totalMembers;i++){
1217       allocatedBonus = safeMul(tokensSold, bonusOf[teamAddresses[i]]) / 10000;
1218       // move tokens to the team multisig wallet
1219       token.mint(teamAddresses[i], allocatedBonus);
1220     }
1221 
1222     // Make token transferable
1223     // realease them in the wild
1224     // Hell yeah!!! we did it.
1225     token.releaseTokenTransfer();
1226   }
1227 
1228 }
1229 
1230 /**
1231  * ICO crowdsale contract that is capped by amout of ETH.
1232  *
1233  * - Tokens are dynamically created during the crowdsale
1234  *
1235  *
1236  */
1237 contract MintedEthCappedCrowdsale is Crowdsale {
1238 
1239   /* Maximum amount of wei this crowdsale can raise. */
1240   uint public weiCap;
1241 
1242   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
1243     weiCap = _weiCap;
1244   }
1245 
1246   /**
1247    * Called from invest() to confirm if the curret investment does not break our cap rule.
1248    */
1249   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1250     return weiRaisedTotal > weiCap;
1251   }
1252 
1253   function isCrowdsaleFull() public constant returns (bool) {
1254     return weiRaised >= weiCap;
1255   }
1256 
1257   /**
1258    * Dynamically create tokens and assign them to the investor.
1259    */
1260   function assignTokens(address receiver, uint tokenAmount) private {
1261     MintableToken mintableToken = MintableToken(token);
1262     mintableToken.mint(receiver, tokenAmount);
1263   }
1264 }
1265 
1266 /** Tranche based pricing with special support for pre-ico deals.
1267  *      Implementing "first price" tranches, meaning, that if byers order is
1268  *      covering more than one tranche, the price of the lowest tranche will apply
1269  *      to the whole order.
1270  */
1271 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
1272 
1273   uint public constant MAX_TRANCHES = 10;
1274  
1275  
1276   // This contains all pre-ICO addresses, and their prices (weis per token)
1277   mapping (address => uint) public preicoAddresses;
1278 
1279   /**
1280   * Define pricing schedule using tranches.
1281   */
1282 
1283   struct Tranche {
1284       // Amount in weis when this tranche becomes active
1285       uint amount;
1286       // How many tokens per wei you will get while this tranche is active
1287       uint price;
1288   }
1289 
1290   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
1291   // Tranche 0 is always (0, 0)
1292   // (TODO: change this when we confirm dynamic arrays are explorable)
1293   Tranche[10] public tranches;
1294 
1295   // How many active tranches we have
1296   uint public trancheCount;
1297 
1298   /// @dev Contruction, creating a list of tranches
1299   /// @param _tranches uint[] tranches Pairs of (start amount, price)
1300   function EthTranchePricing(uint[] _tranches) {
1301     // [ 0, 666666666666666,
1302     //   3000000000000000000000, 769230769230769,
1303     //   5000000000000000000000, 909090909090909,
1304     //   8000000000000000000000, 952380952380952,
1305     //   2000000000000000000000, 1000000000000000 ]
1306     // Need to have tuples, length check
1307     require(!(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2));
1308     // if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
1309     //   throw;
1310     // }
1311     trancheCount = _tranches.length / 2;
1312     uint highestAmount = 0;
1313     for(uint i=0; i<_tranches.length/2; i++) {
1314       tranches[i].amount = _tranches[i*2];
1315       tranches[i].price = _tranches[i*2+1];
1316       // No invalid steps
1317       require(!((highestAmount != 0) && (tranches[i].amount <= highestAmount)));
1318       // if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
1319       //   throw;
1320       // }
1321       highestAmount = tranches[i].amount;
1322     }
1323 
1324     // We need to start from zero, otherwise we blow up our deployment
1325     require(tranches[0].amount == 0);
1326     // if(tranches[0].amount != 0) {
1327     //   throw;
1328     // }
1329 
1330     // Last tranche price must be zero, terminating the crowdale
1331     require(tranches[trancheCount-1].price == 0);
1332     // if(tranches[trancheCount-1].price != 0) {
1333     //   throw;
1334     // }
1335   }
1336 
1337   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1338   ///      to 0 to disable
1339   /// @param preicoAddress PresaleFundCollector address
1340   /// @param pricePerToken How many weis one token cost for pre-ico investors
1341   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1342     public
1343     onlyOwner
1344   {
1345     preicoAddresses[preicoAddress] = pricePerToken;
1346   }
1347 
1348   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1349   /// @return tuple (time, price)
1350   function getTranche(uint n) public constant returns (uint, uint) {
1351     return (tranches[n].amount, tranches[n].price);
1352   }
1353 
1354   function getFirstTranche() private constant returns (Tranche) {
1355     return tranches[0];
1356   }
1357 
1358   function getLastTranche() private constant returns (Tranche) {
1359     return tranches[trancheCount-1];
1360   }
1361 
1362   function getPricingStartsAt() public constant returns (uint) {
1363     return getFirstTranche().amount;
1364   }
1365 
1366   function getPricingEndsAt() public constant returns (uint) {
1367     return getLastTranche().amount;
1368   }
1369 
1370   function isSane(address _crowdsale) public constant returns(bool) {
1371     // Our tranches are not bound by time, so we can't really check are we sane
1372     // so we presume we are ;)
1373     // In the future we could save and track raised tokens, and compare it to
1374     // the Crowdsale contract.
1375     return true;
1376   }
1377 
1378   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1379   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1380   /// @return {[type]} [description]
1381   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
1382     uint i;
1383     for(i=0; i < tranches.length; i++) {
1384       if(weiRaised < tranches[i].amount) {
1385         return tranches[i-1];
1386       }
1387     }
1388   }
1389 
1390   /// @dev Get the current price.
1391   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1392   /// @return The current price or 0 if we are outside trache ranges
1393   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
1394     return getCurrentTranche(weiRaised).price;
1395   }
1396 
1397   /// @dev Calculate the current price for buy in amount.
1398   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1399 
1400     uint multiplier = 10 ** decimals;
1401 
1402     // This investor is coming through pre-ico
1403     if(preicoAddresses[msgSender] > 0) {
1404       return safeMul(value, multiplier) / preicoAddresses[msgSender];
1405     }
1406 
1407     uint price = getCurrentPrice(weiRaised);
1408     
1409     return safeMul(value, multiplier) / price;
1410   }
1411 
1412   function() payable {
1413     throw; // No money on this contract
1414   }
1415 
1416 }