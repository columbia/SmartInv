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
435   event ProfitDelivered(address fetcher, uint profit);
436   event ProfitLoaded(address owner, uint profit);
437   string public name;
438 
439   string public symbol;
440 
441   uint8 public decimals;
442   uint loadedProfit;
443   bool ditributingProfit;
444   uint profitDistributed;
445   uint loadedProfitAvailable;
446 
447   /** Whether an addresses has fetched profit of not*/
448   mapping (address => bool) public hasFetchedProfit;
449 
450   /**
451    * Construct the token.
452    *
453    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
454    *
455    * @param _name Token name
456    * @param _symbol Token symbol - should be all caps
457    * @param _initialSupply How many tokens we start with
458    * @param _decimals Number of decimal places
459    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
460    */
461   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, bool _mintable)
462     UpgradeableToken(msg.sender) {
463 
464     // Create any address, can be transferred
465     // to team multisig via changeOwner(),
466     // also remember to call setUpgradeMaster()
467     owner = msg.sender;
468 
469     name = _name;
470     symbol = _symbol;
471 
472     totalSupply = _initialSupply;
473 
474     decimals = _decimals;
475 
476     // Create initially all balance on the team multisig
477     balances[owner] = totalSupply;
478 
479     if(totalSupply > 0) {
480       Minted(owner, totalSupply);
481     }
482 
483     // No more new supply allowed after the token creation
484     if(!_mintable) {
485       mintingFinished = true;
486       require(totalSupply != 0);
487       // if(totalSupply == 0) {
488       //   throw; // Cannot create a token without supply and no minting
489       // }
490     }
491   }
492 
493   /**
494    * When token is released to be transferable, enforce no new tokens can be created.
495    */
496   function releaseTokenTransfer() public onlyReleaseAgent {
497     mintingFinished = true;
498     super.releaseTokenTransfer();
499   }
500 
501   /**
502    * Allow upgrade agent functionality kick in only if the crowdsale was success.
503    */
504   function canUpgrade() public constant returns(bool) {
505     return released && super.canUpgrade();
506   }
507 
508   /**
509    * Owner can update token information here
510    */
511   function setTokenInformation(string _name, string _symbol) onlyOwner {
512     name = _name;
513     symbol = _symbol;
514     UpdatedTokenInformation(name, symbol);
515   }
516 
517   /**
518    * Allow load profit on the contract for the payout.
519    *
520    * 
521    */
522   function loadProfit() public payable onlyOwner {
523     require(released);
524     require(!ditributingProfit);
525     require(msg.value != 0);
526     loadedProfit = msg.value;
527     loadedProfitAvailable = loadedProfit;
528     ditributingProfit = true;
529     ProfitLoaded(msg.sender, loadedProfit);
530   }
531 
532   /**
533    * Investors can claim profit if loaded.
534    */
535   function fetchProfit() public returns(bool) {
536     require(ditributingProfit);
537     require(!hasFetchedProfit[msg.sender]);
538     uint NBCBalanceOfFetcher = balanceOf(msg.sender);
539     require(NBCBalanceOfFetcher != 0);
540 
541     uint weiValue = safeMul(loadedProfit,NBCBalanceOfFetcher)/totalSupply;
542     require(weiValue >= msg.gas);
543 
544     loadedProfitAvailable = safeSub(loadedProfitAvailable, weiValue);
545     hasFetchedProfit[msg.sender] = true;
546 
547     profitDistributed = safeAdd(profitDistributed, weiValue);
548 
549       if(loadedProfitAvailable <= 0) { 
550        ditributingProfit = false;
551         loadedProfit = 0;
552     }
553 
554     require(msg.sender.send(weiValue)); 
555     // require(msg.sender.call.value(weiValue) == true);
556     ProfitDelivered(msg.sender, weiValue);
557     
558   }
559 
560   /**
561    * Allow owner to unload the loaded profit which could not be claimed.
562    * Owner must be responsible to call it at the right time.
563    * 
564    */
565   function fetchUndistributedProfit() public onlyOwner {
566     require(loadedProfitAvailable != 0);
567     require(msg.sender.send(loadedProfitAvailable));
568     loadedProfitAvailable = 0;
569     ditributingProfit = false;
570     loadedProfit = 0;
571   }
572 
573 }
574 
575 /**
576  * Finalize agent defines what happens at the end of succeseful crowdsale.
577  *
578  * - Allocate tokens for founders, bounties and community
579  * - Make tokens transferable
580  * - etc.
581  */
582 contract FinalizeAgent {
583 
584   function isFinalizeAgent() public constant returns(bool) {
585     return true;
586   }
587 
588   /** Return true if we can run finalizeCrowdsale() properly.
589    *
590    * This is a safety check function that doesn't allow crowdsale to begin
591    * unless the finalizer has been set up properly.
592    */
593   function isSane() public constant returns (bool);
594 
595   /** Called once by crowdsale finalize() if the sale was success. */
596   function finalizeCrowdsale();
597 
598 }
599 
600 /**
601  * Interface for defining crowdsale pricing.
602  */
603 contract PricingStrategy {
604 
605   /** Interface declaration. */
606   function isPricingStrategy() public constant returns (bool) {
607     return true;
608   }
609 
610   /** Self check if all references are correctly set.
611    *
612    * Checks that pricing strategy matches crowdsale parameters.
613    */
614   function isSane(address crowdsale) public constant returns (bool) {
615     return true;
616   }
617 
618   /**
619    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
620    *
621    *
622    * @param value - What is the value of the transaction send in as wei
623    * @param tokensSold - how much tokens have been sold this far
624    * @param weiRaised - how much money has been raised this far
625    * @param msgSender - who is the investor of this transaction
626    * @param decimals - how many decimal units the token has
627    * @return Amount of tokens the investor receives
628    */
629   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
630 }
631 
632 /*
633  * Haltable
634  *
635  * Abstract contract that allows children to implement an
636  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
637  *
638  *
639  * Originally envisioned in FirstBlood ICO contract.
640  */
641 contract Haltable is Ownable {
642   bool public halted;
643 
644   modifier stopInEmergency {
645     require(!halted);
646     //if (halted) throw;
647     _;
648   }
649 
650   modifier onlyInEmergency {
651     require(halted);
652     //if (!halted) throw;
653     _;
654   }
655 
656   // called by the owner on emergency, triggers stopped state
657   function halt() external onlyOwner {
658     halted = true;
659   }
660 
661   // called by the owner on end of emergency, returns to normal state
662   function unhalt() external onlyOwner onlyInEmergency {
663     halted = false;
664   }
665 
666 }
667 
668 /**
669  * Abstract base contract for token sales.
670  *
671  * Handle
672  * - start and end dates
673  * - accepting investments
674  * - minimum funding goal and refund
675  * - various statistics during the crowdfund
676  * - different pricing strategies
677  * - different investment policies (require server side customer id, allow only whitelisted addresses)
678  *
679  */
680 contract Crowdsale is Haltable, SafeMathLib {
681 
682   /* Max investment count when we are still allowed to change the multisig address */
683   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
684 
685   /* The token we are selling */
686   FractionalERC20 public token;
687 
688   /* How we are going to price our offering */
689   PricingStrategy public pricingStrategy;
690 
691   /* Post-success callback */
692   FinalizeAgent public finalizeAgent;
693 
694   /* tokens will be transfered from this address */
695   address public multisigWallet;
696 
697   /* if the funding goal is not reached, investors may withdraw their funds */
698   uint public minimumFundingGoal;
699 
700   /* the UNIX timestamp start date of the crowdsale */
701   uint public startsAt;
702 
703   /* the UNIX timestamp end date of the crowdsale */
704   uint public endsAt;
705 
706   /* the number of tokens already sold through this contract*/
707   uint public tokensSold = 0;
708 
709   /* How many wei of funding we have raised */
710   uint public weiRaised = 0;
711 
712   /* How many distinct addresses have invested */
713   uint public investorCount = 0;
714 
715   /* How much wei we have returned back to the contract after a failed crowdfund. */
716   uint public loadedRefund = 0;
717 
718   /* How much wei we have given back to investors.*/
719   uint public weiRefunded = 0;
720 
721   /* Has this crowdsale been finalized */
722   bool public finalized;
723 
724   /* Do we need to have unique contributor id for each customer */
725   bool public requireCustomerId;
726 
727   /**
728     * Do we verify that contributor has been cleared on the server side (accredited investors only).
729     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
730     */
731   bool public requiredSignedAddress;
732 
733   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
734   address public signerAddress;
735 
736   /** How much ETH each address has invested to this crowdsale */
737   mapping (address => uint256) public investedAmountOf;
738 
739   /** How much tokens this crowdsale has credited for each investor address */
740   mapping (address => uint256) public tokenAmountOf;
741 
742   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
743   mapping (address => bool) public earlyParticipantWhitelist;
744 
745   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
746   uint public ownerTestValue;
747 
748   /** State machine
749    *
750    * - Preparing: All contract initialization calls and variables have not been set yet
751    * - Prefunding: We have not passed start time yet
752    * - Funding: Active crowdsale
753    * - Success: Minimum funding goal reached
754    * - Failure: Minimum funding goal not reached before ending time
755    * - Finalized: The finalized has been called and succesfully executed
756    * - Refunding: Refunds are loaded on the contract for reclaim.
757    */
758   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
759 
760   // A new investment was made
761   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
762 
763   // Refund was processed for a contributor
764   event Refund(address investor, uint weiAmount);
765 
766   // The rules were changed what kind of investments we accept
767   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
768 
769   // Address early participation whitelist status changed
770   event Whitelisted(address addr, bool status);
771 
772   // Crowdsale end time has been changed
773   event EndsAtChanged(uint endsAt);
774 
775   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
776 
777     owner = msg.sender;
778 
779     token = FractionalERC20(_token);
780 
781     setPricingStrategy(_pricingStrategy);
782 
783     multisigWallet = _multisigWallet;
784     require(multisigWallet != 0);
785     // if(multisigWallet == 0) {
786     //     throw;
787     // }
788 
789     require(_start != 0);
790     // if(_start == 0) {
791     //     throw;
792     // }
793 
794     startsAt = _start;
795 
796     require(_end != 0);
797     // if(_end == 0) {
798     //     throw;
799     // }
800 
801     endsAt = _end;
802 
803     // Don't mess the dates
804     require(startsAt < endsAt);
805     // if(startsAt >= endsAt) {
806     //     throw;
807     // }
808 
809     // Minimum funding goal can be zero
810     minimumFundingGoal = _minimumFundingGoal;
811   }
812 
813   /**
814    * Don't expect to just send in money and get tokens.
815    */
816   function() payable {
817     require(false);
818   }
819 
820   /**
821    * Make an investment.
822    *
823    * Crowdsale must be running for one to invest.
824    * We must have not pressed the emergency brake.
825    *
826    * @param receiver The Ethereum address who receives the tokens
827    * @param customerId (optional) UUID v4 to track the successful payments on the server side
828    *
829    */
830   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
831 
832     // Determine if it's a good time to accept investment from this participant
833     if(getState() == State.PreFunding) {
834       // Are we whitelisted for early deposit
835       require(earlyParticipantWhitelist[receiver]);
836       // if(!earlyParticipantWhitelist[receiver]) {
837       //   throw;
838       // }
839     } else if(getState() == State.Funding) {
840       // Retail participants can only come in when the crowdsale is running
841       // pass
842     } else {
843       // Unwanted state
844       require(false);
845     }
846 
847     uint weiAmount = msg.value;
848     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
849 
850     require(tokenAmount != 0);
851     // if(tokenAmount == 0) {
852     //   // Dust transaction
853     //   throw;
854     // }
855 
856     if(investedAmountOf[receiver] == 0) {
857        // A new investor
858        investorCount++;
859     }
860 
861     // Update investor
862     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
863     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
864 
865     // Update totals
866     weiRaised = safeAdd(weiRaised,weiAmount);
867     tokensSold = safeAdd(tokensSold,tokenAmount);
868 
869     // Check that we did not bust the cap
870     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
871     // if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
872     //   throw;
873     // }
874 
875     assignTokens(receiver, tokenAmount);
876 
877     // Pocket the money
878     require(multisigWallet.send(weiAmount));
879 
880     // Tell us invest was success
881     Invested(receiver, weiAmount, tokenAmount, customerId);
882   }
883 
884   /**
885    * Preallocate tokens for the early investors.
886    *
887    * Preallocated tokens have been sold before the actual crowdsale opens.
888    * This function mints the tokens and moves the crowdsale needle.
889    *
890    * Investor count is not handled; it is assumed this goes for multiple investors
891    * and the token distribution happens outside the smart contract flow.
892    *
893    * No money is exchanged, as the crowdsale team already have received the payment.
894    *
895    * @param fullTokens tokens as full tokens - decimal places added internally
896    * @param weiPrice Price of a single full token in wei
897    *
898    */
899   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
900 
901     uint tokenAmount = fullTokens * 10**uint(token.decimals());
902     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
903 
904     weiRaised = safeAdd(weiRaised,weiAmount);
905     tokensSold = safeAdd(tokensSold,tokenAmount);
906 
907     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
908     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
909 
910     assignTokens(receiver, tokenAmount);
911 
912     // Tell us invest was success
913     Invested(receiver, weiAmount, tokenAmount, 0);
914   }
915 
916   /**
917    * Allow anonymous contributions to this crowdsale.
918    */
919   // function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
920   //    bytes32 hash = sha256(addr);
921   //    if (ecrecover(hash, v, r, s) != signerAddress) throw;
922   //    require(customerId != 0);
923   //    //if(customerId == 0) throw;  // UUIDv4 sanity check
924   //    investInternal(addr, customerId);
925   // }
926 
927   /**
928    * Track who is the customer making the payment so we can send thank you email.
929    */
930   function investWithCustomerId(address addr, uint128 customerId) public payable {
931     require(!requiredSignedAddress);
932     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
933     
934     require(customerId != 0);
935     //if(customerId == 0) throw;  // UUIDv4 sanity check
936     investInternal(addr, customerId);
937   }
938 
939   /**
940    * Allow anonymous contributions to this crowdsale.
941    */
942   function invest(address addr) public payable {
943     require(!requireCustomerId);
944     //if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
945     
946     require(!requiredSignedAddress);
947     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
948     investInternal(addr, 0);
949   }
950 
951   /**
952    * Invest to tokens, recognize the payer and clear his address.
953    *
954    */
955   
956   // function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
957   //   investWithSignedAddress(msg.sender, customerId, v, r, s);
958   // }
959 
960   /**
961    * Invest to tokens, recognize the payer.
962    *
963    */
964   function buyWithCustomerId(uint128 customerId) public payable {
965     investWithCustomerId(msg.sender, customerId);
966   }
967 
968   /**
969    * The basic entry point to participate the crowdsale process.
970    *
971    * Pay for funding, get invested tokens back in the sender address.
972    */
973   function buy() public payable {
974     invest(msg.sender);
975   }
976 
977   /**
978    * Finalize a succcesful crowdsale.
979    *
980    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
981    */
982   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
983 
984     // Already finalized
985     require(!finalized);
986     // if(finalized) {
987     //   throw;
988     // }
989 
990     // Finalizing is optional. We only call it if we are given a finalizing agent.
991     if(address(finalizeAgent) != 0) {
992       finalizeAgent.finalizeCrowdsale();
993     }
994 
995     finalized = true;
996   }
997 
998   /**
999    * Allow to (re)set finalize agent.
1000    *
1001    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
1002    */
1003   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
1004     finalizeAgent = addr;
1005 
1006     // Don't allow setting bad agent
1007     require(finalizeAgent.isFinalizeAgent());
1008     // if(!finalizeAgent.isFinalizeAgent()) {
1009     //   throw;
1010     // }
1011   }
1012 
1013   /**
1014    * Set policy do we need to have server-side customer ids for the investments.
1015    *
1016    */
1017   function setRequireCustomerId(bool value) onlyOwner {
1018     requireCustomerId = value;
1019     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1020   }
1021 
1022   /**
1023    * Set policy if all investors must be cleared on the server side first.
1024    *
1025    * This is e.g. for the accredited investor clearing.
1026    *
1027    */
1028   // function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
1029   //   requiredSignedAddress = value;
1030   //   signerAddress = _signerAddress;
1031   //   InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1032   // }
1033 
1034   /**
1035    * Allow addresses to do early participation.
1036    *
1037    * TODO: Fix spelling error in the name
1038    */
1039   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
1040     earlyParticipantWhitelist[addr] = status;
1041     Whitelisted(addr, status);
1042   }
1043 
1044   /**
1045    * Allow crowdsale owner to close early or extend the crowdsale.
1046    *
1047    * This is useful e.g. for a manual soft cap implementation:
1048    * - after X amount is reached determine manual closing
1049    *
1050    * This may put the crowdsale to an invalid state,
1051    * but we trust owners know what they are doing.
1052    *
1053    */
1054   function setEndsAt(uint time) onlyOwner {
1055 
1056     require(now <= time);
1057 
1058     endsAt = time;
1059     EndsAtChanged(endsAt);
1060   }
1061 
1062   /**
1063    * Allow to (re)set pricing strategy.
1064    *
1065    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1066    */
1067   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
1068     pricingStrategy = _pricingStrategy;
1069 
1070     // Don't allow setting bad agent
1071     require(pricingStrategy.isPricingStrategy());
1072     // if(!pricingStrategy.isPricingStrategy()) {
1073     //   throw;
1074     // }
1075   }
1076 
1077   /**
1078    * Allow to change the team multisig address in the case of emergency.
1079    *
1080    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1081    * (we have done only few test transactions). After the crowdsale is going
1082    * then multisig address stays locked for the safety reasons.
1083    */
1084   function setMultisig(address addr) public onlyOwner {
1085 
1086     // Change
1087     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
1088 
1089     multisigWallet = addr;
1090   }
1091 
1092   /**
1093    * Allow load refunds back on the contract for the refunding.
1094    *
1095    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1096    */
1097   function loadRefund() public payable inState(State.Failure) {
1098     require(msg.value != 0);
1099     //if(msg.value == 0) throw;
1100     loadedRefund = safeAdd(loadedRefund,msg.value);
1101   }
1102 
1103   /**
1104    * Investors can claim refund.
1105    */
1106   function refund() public inState(State.Refunding) {
1107     uint256 weiValue = investedAmountOf[msg.sender];
1108     require(weiValue != 0);
1109     //if (weiValue == 0) throw;
1110     investedAmountOf[msg.sender] = 0;
1111     weiRefunded = safeAdd(weiRefunded,weiValue);
1112     Refund(msg.sender, weiValue);
1113     require(msg.sender.send(weiValue));
1114   }
1115 
1116   /**
1117    * @return true if the crowdsale has raised enough money to be a succes
1118    */
1119   function isMinimumGoalReached() public constant returns (bool reached) {
1120     return weiRaised >= minimumFundingGoal;
1121   }
1122 
1123   /**
1124    * Check if the contract relationship looks good.
1125    */
1126   function isFinalizerSane() public constant returns (bool sane) {
1127     return finalizeAgent.isSane();
1128   }
1129 
1130   /**
1131    * Check if the contract relationship looks good.
1132    */
1133   function isPricingSane() public constant returns (bool sane) {
1134     return pricingStrategy.isSane(address(this));
1135   }
1136 
1137   /**
1138    * Crowdfund state machine management.
1139    *
1140    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1141    */
1142   function getState() public constant returns (State) {
1143     if(finalized) return State.Finalized;
1144     else if (address(finalizeAgent) == 0) return State.Preparing;
1145     else if (!finalizeAgent.isSane()) return State.Preparing;
1146     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1147     else if (block.timestamp < startsAt) return State.PreFunding;
1148     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1149     else if (isMinimumGoalReached()) return State.Success;
1150     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1151     else return State.Failure;
1152   }
1153 
1154   /** This is for manual testing of multisig wallet interaction */
1155   function setOwnerTestValue(uint val) onlyOwner {
1156     ownerTestValue = val;
1157   }
1158 
1159   /** Interface marker. */
1160   function isCrowdsale() public constant returns (bool) {
1161     return true;
1162   }
1163 
1164   //
1165   // Modifiers
1166   //
1167 
1168   /** Modified allowing execution only if the crowdsale is currently running.  */
1169   modifier inState(State state) {
1170     require(getState() == state);
1171     //if(getState() != state) throw;
1172     _;
1173   }
1174 
1175 
1176   //
1177   // Abstract functions
1178   //
1179 
1180   /**
1181    * Check if the current invested breaks our cap rules.
1182    *
1183    *
1184    * The child contract must define their own cap setting rules.
1185    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1186    * Called from invest().
1187    *
1188    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1189    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1190    * @param weiRaisedTotal What would be our total raised balance after this transaction
1191    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1192    *
1193    * @return true if taking this investment would break our cap rules
1194    */
1195   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1196   /**
1197    * Check if the current crowdsale is full and we can no longer sell any tokens.
1198    */
1199   function isCrowdsaleFull() public constant returns (bool);
1200 
1201   /**
1202    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1203    */
1204   function assignTokens(address receiver, uint tokenAmount) private;
1205 }
1206 
1207 /**
1208  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1209  *
1210  * Unlock tokens.
1211  *
1212  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1213  *
1214  */
1215 contract BonusFinalizeAgent is FinalizeAgent, SafeMathLib {
1216 
1217   CrowdsaleToken public token;
1218   Crowdsale public crowdsale;
1219 
1220   /** Total percent of tokens minted to the team at the end of the sale as base points (0.0001) */
1221   uint public totalMembers;
1222   // Per address % of total token raised to be assigned to the member Ex 1% is passed as 100
1223   uint public allocatedBonus;
1224   mapping (address=>uint) bonusOf;
1225   /** Where we move the tokens at the end of the sale. */
1226   address[] public teamAddresses;
1227 
1228 
1229   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint[] _bonusBasePoints, address[] _teamAddresses) {
1230     token = _token;
1231     crowdsale = _crowdsale;
1232 
1233     //crowdsale address must not be 0
1234     require(address(crowdsale) != 0);
1235 
1236     //bonus & team address array size must match
1237     require(_bonusBasePoints.length == _teamAddresses.length);
1238 
1239     totalMembers = _teamAddresses.length;
1240     teamAddresses = _teamAddresses;
1241     
1242     //if any of the bonus is 0 throw
1243     // otherwise sum it up in totalAllocatedBonus
1244     for (uint i=0;i<totalMembers;i++){
1245       require(_bonusBasePoints[i] != 0);
1246       //if(_bonusBasePoints[i] == 0) throw;
1247     }
1248 
1249     //if any of the address is 0 or invalid throw
1250     //otherwise initialize the bonusOf array
1251     for (uint j=0;j<totalMembers;j++){
1252       require(_teamAddresses[j] != 0);
1253       //if(_teamAddresses[j] == 0) throw;
1254       bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];
1255     }
1256   }
1257 
1258   /* Can we run finalize properly */
1259   function isSane() public constant returns (bool) {
1260     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
1261   }
1262 
1263   /** Called once by crowdsale finalize() if the sale was success. */
1264   function finalizeCrowdsale() {
1265 
1266     // if finalized is not being called from the crowdsale 
1267     // contract then throw
1268     require(msg.sender == address(crowdsale));
1269 
1270     // if(msg.sender != address(crowdsale)) {
1271     //   throw;
1272     // }
1273 
1274     // get the total sold tokens count.
1275     uint tokensSold = crowdsale.tokensSold();
1276 
1277     for (uint i=0;i<totalMembers;i++) {
1278       allocatedBonus = safeMul(tokensSold, bonusOf[teamAddresses[i]]) / 10000;
1279       // move tokens to the team multisig wallet
1280       
1281       // Give min bonus to advisor as committed
1282       // the last address is the advisor address
1283       uint minBonus = 1000000 * 1000000000000000000;
1284       if (i == totalMembers-1 && allocatedBonus < minBonus)
1285         allocatedBonus = minBonus;
1286 
1287       token.mint(teamAddresses[i], allocatedBonus);
1288     }
1289 
1290     // Make token transferable
1291     // realease them in the wild
1292     // Hell yeah!!! we did it.
1293     token.releaseTokenTransfer();
1294   }
1295 
1296 }
1297 
1298 
1299 /**
1300  * ICO crowdsale contract that is capped by amout of ETH.
1301  *
1302  * - Tokens are dynamically created during the crowdsale
1303  *
1304  *
1305  */
1306 contract MintedEthCappedCrowdsale is Crowdsale {
1307 
1308   /* Maximum amount of wei this crowdsale can raise. */
1309   uint public weiCap;
1310 
1311   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _weiCap) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
1312     weiCap = _weiCap;
1313   }
1314 
1315   /**
1316    * Called from invest() to confirm if the curret investment does not break our cap rule.
1317    */
1318   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1319     return weiRaisedTotal > weiCap;
1320   }
1321 
1322   function isCrowdsaleFull() public constant returns (bool) {
1323     return weiRaised >= weiCap;
1324   }
1325 
1326   /**
1327    * Dynamically create tokens and assign them to the investor.
1328    */
1329   function assignTokens(address receiver, uint tokenAmount) private {
1330     MintableToken mintableToken = MintableToken(token);
1331     mintableToken.mint(receiver, tokenAmount);
1332   }
1333 }
1334 
1335 /** Tranche based pricing with special support for pre-ico deals.
1336  *      Implementing "first price" tranches, meaning, that if byers order is
1337  *      covering more than one tranche, the price of the lowest tranche will apply
1338  *      to the whole order.
1339  */
1340 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
1341 
1342   uint public constant MAX_TRANCHES = 10;
1343  
1344  
1345   // This contains all pre-ICO addresses, and their prices (weis per token)
1346   mapping (address => uint) public preicoAddresses;
1347 
1348   /**
1349   * Define pricing schedule using tranches.
1350   */
1351 
1352   struct Tranche {
1353       // Amount in weis when this tranche becomes active
1354       uint amount;
1355       // How many tokens per wei you will get while this tranche is active
1356       uint price;
1357   }
1358 
1359   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
1360   // Tranche 0 is always (0, 0)
1361   // (TODO: change this when we confirm dynamic arrays are explorable)
1362   Tranche[10] public tranches;
1363 
1364   // How many active tranches we have
1365   uint public trancheCount;
1366 
1367   /// @dev Contruction, creating a list of tranches
1368   /// @param _tranches uint[] tranches Pairs of (start amount, price)
1369   function EthTranchePricing(uint[] _tranches) {
1370     // [ 0, 666666666666666,
1371     //   3000000000000000000000, 769230769230769,
1372     //   5000000000000000000000, 909090909090909,
1373     //   8000000000000000000000, 952380952380952,
1374     //   2000000000000000000000, 1000000000000000 ]
1375     // Need to have tuples, length check
1376     require(!(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2));
1377     // if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
1378     //   throw;
1379     // }
1380     trancheCount = _tranches.length / 2;
1381     uint highestAmount = 0;
1382     for(uint i=0; i<_tranches.length/2; i++) {
1383       tranches[i].amount = _tranches[i*2];
1384       tranches[i].price = _tranches[i*2+1];
1385       // No invalid steps
1386       require(!((highestAmount != 0) && (tranches[i].amount <= highestAmount)));
1387       // if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
1388       //   throw;
1389       // }
1390       highestAmount = tranches[i].amount;
1391     }
1392 
1393     // We need to start from zero, otherwise we blow up our deployment
1394     require(tranches[0].amount == 0);
1395     // if(tranches[0].amount != 0) {
1396     //   throw;
1397     // }
1398 
1399     // Last tranche price must be zero, terminating the crowdale
1400     require(tranches[trancheCount-1].price == 0);
1401     // if(tranches[trancheCount-1].price != 0) {
1402     //   throw;
1403     // }
1404   }
1405 
1406   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1407   ///      to 0 to disable
1408   /// @param preicoAddress PresaleFundCollector address
1409   /// @param pricePerToken How many weis one token cost for pre-ico investors
1410   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1411     public
1412     onlyOwner
1413   {
1414     preicoAddresses[preicoAddress] = pricePerToken;
1415   }
1416 
1417   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1418   /// @return tuple (time, price)
1419   function getTranche(uint n) public constant returns (uint, uint) {
1420     return (tranches[n].amount, tranches[n].price);
1421   }
1422 
1423   function getFirstTranche() private constant returns (Tranche) {
1424     return tranches[0];
1425   }
1426 
1427   function getLastTranche() private constant returns (Tranche) {
1428     return tranches[trancheCount-1];
1429   }
1430 
1431   function getPricingStartsAt() public constant returns (uint) {
1432     return getFirstTranche().amount;
1433   }
1434 
1435   function getPricingEndsAt() public constant returns (uint) {
1436     return getLastTranche().amount;
1437   }
1438 
1439   function isSane(address _crowdsale) public constant returns(bool) {
1440     // Our tranches are not bound by time, so we can't really check are we sane
1441     // so we presume we are ;)
1442     // In the future we could save and track raised tokens, and compare it to
1443     // the Crowdsale contract.
1444     return true;
1445   }
1446 
1447   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1448   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1449   /// @return {[type]} [description]
1450   function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
1451     uint i;
1452     for(i=0; i < tranches.length; i++) {
1453       if(weiRaised < tranches[i].amount) {
1454         return tranches[i-1];
1455       }
1456     }
1457   }
1458 
1459   /// @dev Get the current price.
1460   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1461   /// @return The current price or 0 if we are outside trache ranges
1462   function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
1463     return getCurrentTranche(weiRaised).price;
1464   }
1465 
1466   /// @dev Calculate the current price for buy in amount.
1467   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1468 
1469     uint multiplier = 10 ** decimals;
1470 
1471     // This investor is coming through pre-ico
1472     if(preicoAddresses[msgSender] > 0) {
1473       return safeMul(value, multiplier) / preicoAddresses[msgSender];
1474     }
1475 
1476     uint price = getCurrentPrice(weiRaised);
1477     
1478     return safeMul(value, multiplier) / price;
1479   }
1480 
1481   function() payable {
1482     require(false); // No money on this contract
1483   }
1484 
1485 }