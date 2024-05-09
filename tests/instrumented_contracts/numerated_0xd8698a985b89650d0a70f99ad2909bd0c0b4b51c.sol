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
218 
219 /**
220  * Upgrade agent interface inspired by Lunyr.
221  *
222  * Upgrade agent transfers tokens to a new contract.
223  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
224  */
225 contract UpgradeAgent {
226   uint public originalSupply;
227   /** Interface marker */
228   function isUpgradeAgent() public pure returns (bool) {
229     return true;
230   }
231   function upgradeFrom(address _from, uint256 _value) public;
232 }
233 
234 
235 /**
236  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
237  *
238  * First envisioned by Golem and Lunyr projects.
239  */
240 contract UpgradeableToken is StandardToken {
241 
242   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
243   address public upgradeMaster;
244 
245   /** The next contract where the tokens will be migrated. */
246   UpgradeAgent public upgradeAgent;
247 
248   /** How many tokens we have upgraded by now. */
249   uint256 public totalUpgraded;
250 
251   /**
252    * Upgrade states.
253    *
254    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
255    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
256    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
257    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
258    *
259    */
260   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
261 
262   /**
263    * Somebody has upgraded some of his tokens.
264    */
265   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
266 
267   /**
268    * New upgrade agent available.
269    */
270   event UpgradeAgentSet(address agent);
271 
272   /**
273    * Do not allow construction without upgrade master set.
274    */
275   function UpgradeableToken(address _upgradeMaster) public {
276     upgradeMaster = _upgradeMaster;
277   }
278 
279   /**
280    * Allow the token holder to upgrade some of their tokens to a new contract.
281    */
282   function upgrade(uint256 value) public {
283     UpgradeState state = getUpgradeState();
284     require((state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
285 
286     // Validate input value.
287     require (value != 0);
288 
289     balances[msg.sender] = safeSub(balances[msg.sender],value);
290 
291     // Take tokens out from circulation
292     totalSupply = safeSub(totalSupply,value);
293     totalUpgraded = safeAdd(totalUpgraded,value);
294 
295     // Upgrade agent reissues the tokens
296     upgradeAgent.upgradeFrom(msg.sender, value);
297     Upgrade(msg.sender, upgradeAgent, value);
298   }
299 
300   /**
301    * Set an upgrade agent that handles
302    */
303   function setUpgradeAgent(address agent) external {
304     require(canUpgrade());
305 
306     require(agent != 0x0);
307     // Only a master can designate the next agent
308     require(msg.sender == upgradeMaster);
309     // Upgrade has already begun for an agent
310     require(getUpgradeState() != UpgradeState.Upgrading);
311 
312     upgradeAgent = UpgradeAgent(agent);
313 
314     // Bad interface
315     require(upgradeAgent.isUpgradeAgent());
316     // Make sure that token supplies match in source and target
317     require(upgradeAgent.originalSupply() == totalSupply);
318 
319     UpgradeAgentSet(upgradeAgent);
320   }
321 
322   /**
323    * Get the state of the token upgrade.
324    */
325   function getUpgradeState() public constant returns(UpgradeState) {
326     if(!canUpgrade()) return UpgradeState.NotAllowed;
327     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
328     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
329     else return UpgradeState.Upgrading;
330   }
331 
332   /**
333    * Change the upgrade master.
334    *
335    * This allows us to set a new owner for the upgrade mechanism.
336    */
337   function setUpgradeMaster(address master) public {
338     require(master != 0x0);
339     require(msg.sender == upgradeMaster);
340     upgradeMaster = master;
341   }
342 
343   /**
344    * Child contract can enable to provide the condition when the upgrade can begun.
345    */
346   function canUpgrade() public view returns(bool) {
347      return true;
348   }
349 
350 }
351 
352 /**
353  * Define interface for releasing the token transfer after a successful crowdsale.
354  */
355 contract ReleasableToken is ERC20, Ownable {
356 
357   /* The finalizer contract that allows unlift the transfer limits on this token */
358   address public releaseAgent;
359 
360   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
361   bool public released = false;
362 
363   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
364   mapping (address => bool) public transferAgents;
365 
366   /**
367    * Limit token transfer until the crowdsale is over.
368    *
369    */
370   modifier canTransfer(address _sender) {
371 
372     if(!released) {
373         require(transferAgents[_sender]);
374     }
375 
376     _;
377   }
378 
379   /**
380    * Set the contract that can call release and make the token transferable.
381    *
382    * Design choice. Allow reset the release agent to fix fat finger mistakes.
383    */
384   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
385 
386     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
387     releaseAgent = addr;
388   }
389 
390   /**
391    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
392    */
393   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
394     transferAgents[addr] = state;
395   }
396 
397   /**
398    * One way function to release the tokens to the wild.
399    *
400    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
401    */
402   function releaseTokenTransfer() public onlyReleaseAgent {
403     released = true;
404   }
405 
406   /** The function can be called only before or after the tokens have been releasesd */
407   modifier inReleaseState(bool releaseState) {
408     require(releaseState == released);
409     _;
410   }
411 
412   /** The function can be called only by a whitelisted release agent. */
413   modifier onlyReleaseAgent() {
414     require(msg.sender == releaseAgent);
415     _;
416   }
417 
418   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
419     // Call StandardToken.transfer()
420    return super.transfer(_to, _value);
421   }
422 
423   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
424     // Call StandardToken.transferForm()
425     return super.transferFrom(_from, _to, _value);
426   }
427 
428 }
429 
430 /**
431  * A token that can increase its supply by another contract.
432  *
433  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
434  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
435  *
436  */
437 contract MintableToken is StandardToken, Ownable {
438 
439   bool public mintingFinished = false;
440 
441   /** List of agents that are allowed to create new tokens */
442   mapping (address => bool) public mintAgents;
443 
444   event MintingAgentChanged(address addr, bool state);
445   event Mint(address indexed to, uint256 amount);
446 
447   /**
448    * Create new tokens and allocate them to an address..
449    *
450    * Only callably by a crowdsale contract (mint agent).
451    */
452   function mint(address receiver, uint256 amount) onlyMintAgent canMint public returns(bool){
453     totalSupply = safeAdd(totalSupply, amount);
454     balances[receiver] = safeAdd(balances[receiver], amount);
455 
456     // This will make the mint transaction apper in EtherScan.io
457     // We can remove this after there is a standardized minting event
458     Mint(receiver, amount);
459     Transfer(0, receiver, amount);
460     return true;
461   }
462 
463   /**
464    * Owner can allow a crowdsale contract to mint new tokens.
465    */
466   function setMintAgent(address addr, bool state) onlyOwner canMint public {
467     mintAgents[addr] = state;
468     MintingAgentChanged(addr, state);
469   }
470 
471   modifier onlyMintAgent() {
472     // Only crowdsale contracts are allowed to mint new tokens
473     require(mintAgents[msg.sender]);
474     _;
475   }
476 
477   /** Make sure we are not done yet. */
478   modifier canMint() {
479     require(!mintingFinished);
480     _;
481   }
482 }
483 
484 /**
485  * A crowdsaled token.
486  *
487  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
488  *
489  * - The token transfer() is disabled until the crowdsale is over
490  * - The token contract gives an opt-in upgrade path to a new contract
491  * - The same token can be part of several crowdsales through approve() mechanism
492  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
493  *
494  */
495 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
496 
497   event UpdatedTokenInformation(string newName, string newSymbol);
498 
499   string public name;
500 
501   string public symbol;
502 
503   uint8 public decimals;
504 
505   /**
506    * Construct the token.
507    *
508    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
509    *
510    * @param _name Token name
511    * @param _symbol Token symbol - should be all caps
512    * @param _initialSupply How many tokens we start with
513    * @param _decimals Number of decimal places
514    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
515    */
516   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, bool _mintable)
517     public
518     UpgradeableToken(msg.sender) 
519   {
520 
521     // Create any address, can be transferred
522     // to team multisig via changeOwner(),
523     // also remember to call setUpgradeMaster()
524     owner = msg.sender;
525 
526     name = _name;
527     symbol = _symbol;
528 
529     totalSupply = _initialSupply;
530 
531     decimals = _decimals;
532 
533     // Create initially all balance on the team multisig
534     balances[owner] = totalSupply;
535 
536     if(totalSupply > 0) {
537       Minted(owner, totalSupply);
538     }
539 
540     // No more new supply allowed after the token creation
541     if(!_mintable) {
542       mintingFinished = true;
543       require(totalSupply != 0);
544     }
545   }
546 
547   /**
548    * When token is released to be transferable, enforce no new tokens can be created.
549    */
550   function releaseTokenTransfer() public onlyReleaseAgent {
551     mintingFinished = true;
552     super.releaseTokenTransfer();
553   }
554 
555   /**
556    * Allow upgrade agent functionality kick in only if the crowdsale was success.
557    */
558   function canUpgrade() public view returns(bool) {
559     return released && super.canUpgrade();
560   }
561 
562   /**
563    * Owner can update token information here
564    */
565   function setTokenInformation(string _name, string _symbol) onlyOwner public {
566     name = _name;
567     symbol = _symbol;
568     UpdatedTokenInformation(name, symbol);
569   }
570 
571 }
572 
573 /**
574  * Finalize agent defines what happens at the end of succeseful crowdsale.
575  *
576  * - Allocate tokens for founders, bounties and community
577  * - Make tokens transferable
578  * - etc.
579  */
580 contract FinalizeAgent {
581 
582   function isFinalizeAgent() public pure returns(bool) {
583     return true;
584   }
585 
586   /** Return true if we can run finalizeCrowdsale() properly.
587    *
588    * This is a safety check function that doesn't allow crowdsale to begin
589    * unless the finalizer has been set up properly.
590    */
591   function isSane() public view returns (bool);
592 
593   /** Called once by crowdsale finalize() if the sale was success. */
594   function finalizeCrowdsale() public ;
595 
596 }
597 
598 /**
599  * Interface for defining crowdsale pricing.
600  */
601 contract PricingStrategy {
602 
603   /** Interface declaration. */
604   function isPricingStrategy() public pure returns (bool) {
605     return true;
606   }
607 
608   /** Self check if all references are correctly set.
609    *
610    * Checks that pricing strategy matches crowdsale parameters.
611    */
612   function isSane(address crowdsale) public view returns (bool) {
613     return true;
614   }
615 
616   /**
617    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
618    *
619    *
620    * @param value - What is the value of the transaction send in as wei
621    * @param tokensSold - how much tokens have been sold this far
622    * @param weiRaised - how much money has been raised this far
623    * @param msgSender - who is the investor of this transaction
624    * @param decimals - how many decimal units the token has
625    * @return Amount of tokens the investor receives
626    */
627   function calculatePrice(uint256 value, uint256 weiRaised, uint256 tokensSold, address msgSender, uint256 decimals) public constant returns (uint256 tokenAmount);
628 }
629 
630 /*
631  * Haltable
632  *
633  * Abstract contract that allows children to implement an
634  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
635  *
636  *
637  * Originally envisioned in FirstBlood ICO contract.
638  */
639 contract Haltable is Ownable {
640   bool public halted;
641 
642   modifier stopInEmergency {
643     require(!halted);
644     _;
645   }
646 
647   modifier onlyInEmergency {
648     require(halted);
649     _;
650   }
651 
652   // called by the owner on emergency, triggers stopped state
653   function halt() external onlyOwner {
654     halted = true;
655   }
656 
657   // called by the owner on end of emergency, returns to normal state
658   function unhalt() external onlyOwner onlyInEmergency {
659     halted = false;
660   }
661 
662 }
663 contract Allocatable is Ownable {
664 
665   /** List of agents that are allowed to allocate new tokens */
666   mapping (address => bool) public allocateAgents;
667 
668   event AllocateAgentChanged(address addr, bool state  );
669 
670   /**
671    * Owner can allow a crowdsale contract to allocate new tokens.
672    */
673   function setAllocateAgent(address addr, bool state) onlyOwner public {
674     allocateAgents[addr] = state;
675     AllocateAgentChanged(addr, state);
676   }
677 
678   modifier onlyAllocateAgent() {
679     // Only crowdsale contracts are allowed to allocate new tokens
680     require(allocateAgents[msg.sender]);
681     _;
682   }
683 }
684 
685 /**
686  * Abstract base contract for token sales.
687  *
688  * Handle
689  * - start and end dates
690  * - accepting investments
691  * - minimum funding goal and refund
692  * - various statistics during the crowdfund
693  * - different pricing strategies
694  * - different investment policies (require server side customer id, allow only whitelisted addresses)
695  *
696  */
697 contract Crowdsale is Allocatable, Haltable, SafeMathLib {
698 
699   /* Max investment count when we are still allowed to change the multisig address */
700   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
701 
702   /* The token we are selling */
703   FractionalERC20 public token;
704 
705   /* How we are going to price our offering */
706   PricingStrategy public pricingStrategy;
707 
708   /* Post-success callback */
709   FinalizeAgent public finalizeAgent;
710 
711   /* tokens will be transfered from this address */
712   address public multisigWallet;
713 
714   /* if the funding goal is not reached, investors may withdraw their funds */
715   uint256 public minimumFundingGoal;
716 
717   /* the UNIX timestamp start date of the crowdsale */
718   uint256 public startsAt;
719 
720   /* the UNIX timestamp end date of the crowdsale */
721   uint256 public endsAt;
722 
723   /* the number of tokens already sold through this contract*/
724   uint256 public tokensSold = 0;
725 
726   /* How many wei of funding we have raised */
727   uint256 public weiRaised = 0;
728 
729   /* How many distinct addresses have invested */
730   uint256 public investorCount = 0;
731 
732   /* How much wei we have returned back to the contract after a failed crowdfund. */
733   uint256 public loadedRefund = 0;
734 
735   /* How much wei we have given back to investors.*/
736   uint256 public weiRefunded = 0;
737 
738   /* Has this crowdsale been finalized */
739   bool public finalized;
740 
741   /* Do we need to have unique contributor id for each customer */
742   bool public requireCustomerId;
743 
744   /**
745     * Do we verify that contributor has been cleared on the server side (accredited investors only).
746     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
747     */
748   bool public requiredSignedAddress;
749 
750   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
751   address public signerAddress;
752 
753   /** How much ETH each address has invested to this crowdsale */
754   mapping (address => uint256) public investedAmountOf;
755 
756   /** How much tokens this crowdsale has credited for each investor address */
757   mapping (address => uint256) public tokenAmountOf;
758 
759   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
760   mapping (address => bool) public earlyParticipantWhitelist;
761 
762   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
763   uint256 public ownerTestValue;
764 
765   /** State machine
766    *
767    * - Preparing: All contract initialization calls and variables have not been set yet
768    * - Prefunding: We have not passed start time yet
769    * - Funding: Active crowdsale
770    * - Success: Minimum funding goal reached
771    * - Failure: Minimum funding goal not reached before ending time
772    * - Finalized: The finalized has been called and succesfully executed
773    * - Refunding: Refunds are loaded on the contract for reclaim.
774    */
775   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
776 
777   // A new investment was made
778   event Invested(address investor, uint256 weiAmount, uint256 tokenAmount, uint128 customerId);
779 
780   // Refund was processed for a contributor
781   event Refund(address investor, uint256 weiAmount);
782 
783   // The rules were changed what kind of investments we accept
784   event InvestmentPolicyChanged(bool requireCustId, bool requiredSignedAddr, address signerAddr);
785 
786   // Address early participation whitelist status changed
787   event Whitelisted(address addr, bool status);
788 
789   // Crowdsale end time has been changed
790   event EndsAtChanged(uint256 endAt);
791 
792   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, 
793   uint256 _start, uint256 _end, uint256 _minimumFundingGoal) public {
794 
795     owner = msg.sender;
796 
797     token = FractionalERC20(_token);
798 
799     setPricingStrategy(_pricingStrategy);
800 
801     multisigWallet = _multisigWallet;
802     require(multisigWallet != 0);
803 
804     require(_start != 0);
805 
806     startsAt = _start;
807 
808     require(_end != 0);
809 
810     endsAt = _end;
811 
812     // Don't mess the dates
813     require(startsAt < endsAt);
814 
815     // Minimum funding goal can be zero
816     minimumFundingGoal = _minimumFundingGoal;
817   }
818 
819   /**
820    * Don't expect to just send in money and get tokens.
821    */
822   function() payable public {
823     require(false);
824   }
825 
826   /**
827    * Make an investment.
828    *
829    * Crowdsale must be running for one to invest.
830    * We must have not pressed the emergency brake.
831    *
832    * @param receiver The Ethereum address who receives the tokens
833    * @param customerId (optional) UUID v4 to track the successful payments on the server side
834    *
835    */
836   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
837 
838     // Determine if it's a good time to accept investment from this participant
839     if(getState() == State.PreFunding) {
840       // Are we whitelisted for early deposit
841       require(earlyParticipantWhitelist[receiver]);
842     
843     } else if(getState() == State.Funding) {
844       // Retail participants can only come in when the crowdsale is running
845     } else {
846       // Unwanted state
847       require(false);
848     }
849 
850     uint weiAmount = msg.value;
851     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
852 
853     require(tokenAmount != 0);
854 
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
885    * allocate tokens for the early investors.
886    *
887    * Preallocated tokens have been sold before the actual crowdsale opens.
888    * This function mints the tokens and moves the crowdsale needle.
889    *
890    * Investor count is not handled; it is assumed this goes for multiple investors
891    * and the token distribution happens outside the smart contract flow.
892    *
893    * No money is exchanged, as the crowdsale team already have received the payment.
894    *
895    * @param weiPrice Price of a single full token in wei
896    *
897    */
898   function preallocate(address receiver, uint256 tokenAmount, uint256 weiPrice) public onlyAllocateAgent {
899 
900     uint256 weiAmount = (weiPrice * tokenAmount)/10**uint256(token.decimals()); // This can be also 0, we give out tokens for free
901 
902     weiRaised = safeAdd(weiRaised,weiAmount);
903     tokensSold = safeAdd(tokensSold,tokenAmount);
904 
905     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
906     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
907 
908     assignTokens(receiver, tokenAmount);
909 
910     // Tell us invest was success
911     Invested(receiver, weiAmount, tokenAmount, 0);
912   }
913 
914   /**
915    * Track who is the customer making the payment so we can send thank you email.
916    */
917   function investWithCustomerId(address addr, uint128 customerId) public payable {
918     require(!requiredSignedAddress);
919     //if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
920     require(customerId != 0);
921     //if(customerId == 0) throw;  // UUIDv4 sanity check
922     investInternal(addr, customerId);
923   }
924 
925   /**
926    * Allow anonymous contributions to this crowdsale.
927    */
928   function invest(address addr) public payable {
929     require(!requireCustomerId);
930     
931     require(!requiredSignedAddress);
932     investInternal(addr, 0);
933   }
934 
935   /**
936    * Invest to tokens, recognize the payer and clear his address.
937    *
938    */
939   
940   // function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
941   //   investWithSignedAddress(msg.sender, customerId, v, r, s);
942   // }
943 
944   /**
945    * Invest to tokens, recognize the payer.
946    *
947    */
948   function buyWithCustomerId(uint128 customerId) public payable {
949     investWithCustomerId(msg.sender, customerId);
950   }
951 
952   /**
953    * The basic entry point to participate the crowdsale process.
954    *
955    * Pay for funding, get invested tokens back in the sender address.
956    */
957   function buy() public payable {
958     invest(msg.sender);
959   }
960 
961   /**
962    * Finalize a succcesful crowdsale.
963    *
964    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
965    */
966   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
967 
968     // Already finalized
969     require(!finalized);
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
984   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
985     finalizeAgent = addr;
986 
987     // Don't allow setting bad agent
988     require(finalizeAgent.isFinalizeAgent());
989   }
990 
991   /**
992    * Set policy do we need to have server-side customer ids for the investments.
993    *
994    */
995   function setRequireCustomerId(bool value) public onlyOwner {
996     requireCustomerId = value;
997     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
998   }
999 
1000   /**
1001    * Allow addresses to do early participation.
1002    *
1003    * TODO: Fix spelling error in the name
1004    */
1005   function setEarlyParicipantWhitelist(address addr, bool status) public onlyOwner {
1006     earlyParticipantWhitelist[addr] = status;
1007     Whitelisted(addr, status);
1008   }
1009 
1010   /**
1011    * Allow crowdsale owner to close early or extend the crowdsale.
1012    *
1013    * This is useful e.g. for a manual soft cap implementation:
1014    * - after X amount is reached determine manual closing
1015    *
1016    * This may put the crowdsale to an invalid state,
1017    * but we trust owners know what they are doing.
1018    *
1019    */
1020   function setEndsAt(uint time) public onlyOwner {
1021 
1022     require(now <= time);
1023 
1024     endsAt = time;
1025     EndsAtChanged(endsAt);
1026   }
1027 
1028   /**
1029    * Allow to (re)set pricing strategy.
1030    *
1031    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1032    */
1033   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
1034     pricingStrategy = _pricingStrategy;
1035 
1036     // Don't allow setting bad agent
1037     require(pricingStrategy.isPricingStrategy());
1038   }
1039 
1040   /**
1041    * Allow to change the team multisig address in the case of emergency.
1042    *
1043    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1044    * (we have done only few test transactions). After the crowdsale is going
1045    * then multisig address stays locked for the safety reasons.
1046    */
1047   function setMultisig(address addr) public onlyOwner {
1048 
1049     // Change
1050     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
1051 
1052     multisigWallet = addr;
1053   }
1054 
1055   /**
1056    * Allow load refunds back on the contract for the refunding.
1057    *
1058    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1059    */
1060   function loadRefund() public payable inState(State.Failure) {
1061     require(msg.value != 0);
1062     loadedRefund = safeAdd(loadedRefund,msg.value);
1063   }
1064 
1065   /**
1066    * Investors can claim refund.
1067    */
1068   function refund() public inState(State.Refunding) {
1069     uint256 weiValue = investedAmountOf[msg.sender];
1070     require(weiValue != 0);
1071     investedAmountOf[msg.sender] = 0;
1072     weiRefunded = safeAdd(weiRefunded,weiValue);
1073     Refund(msg.sender, weiValue);
1074     require(msg.sender.send(weiValue));
1075   }
1076 
1077   /**
1078    * @return true if the crowdsale has raised enough money to be a succes
1079    */
1080   function isMinimumGoalReached() public constant returns (bool reached) {
1081     return weiRaised >= minimumFundingGoal;
1082   }
1083 
1084   /**
1085    * Check if the contract relationship looks good.
1086    */
1087   function isFinalizerSane() public constant returns (bool sane) {
1088     return finalizeAgent.isSane();
1089   }
1090 
1091   /**
1092    * Check if the contract relationship looks good.
1093    */
1094   function isPricingSane() public constant returns (bool sane) {
1095     return pricingStrategy.isSane(address(this));
1096   }
1097 
1098   /**
1099    * Crowdfund state machine management.
1100    *
1101    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1102    */
1103   function getState() public constant returns (State) {
1104     if(finalized) return State.Finalized;
1105     else if (address(finalizeAgent) == 0) return State.Preparing;
1106     else if (!finalizeAgent.isSane()) return State.Preparing;
1107     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1108     else if (block.timestamp < startsAt) return State.PreFunding;
1109     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1110     else if (isMinimumGoalReached()) return State.Success;
1111     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1112     else return State.Failure;
1113   }
1114 
1115   /** This is for manual testing of multisig wallet interaction */
1116   function setOwnerTestValue(uint val) public onlyOwner {
1117     ownerTestValue = val;
1118   }
1119 
1120   /** Interface marker. */
1121   function isCrowdsale() public pure returns (bool) {
1122     return true;
1123   }
1124 
1125   //
1126   // Modifiers
1127   //
1128 
1129   /** Modified allowing execution only if the crowdsale is currently running.  */
1130   modifier inState(State state) {
1131     require(getState() == state);
1132     _;
1133   }
1134 
1135 
1136   //
1137   // Abstract functions
1138   //
1139 
1140   /**
1141    * Check if the current invested breaks our cap rules.
1142    *
1143    *
1144    * The child contract must define their own cap setting rules.
1145    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1146    * Called from invest().
1147    *
1148    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1149    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1150    * @param weiRaisedTotal What would be our total raised balance after this transaction
1151    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1152    *
1153    * @return true if taking this investment would break our cap rules
1154    */
1155   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
1156   /**
1157    * Check if the current crowdsale is full and we can no longer sell any tokens.
1158    */
1159   function isCrowdsaleFull() public constant returns (bool);
1160 
1161   /**
1162    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1163    */
1164   function assignTokens(address receiver, uint tokenAmount) private;
1165 }
1166 
1167 /**
1168  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1169  *
1170  * Unlock tokens.
1171  *
1172  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1173  *
1174  */
1175 contract BonusFinalizeAgent is FinalizeAgent, SafeMathLib {
1176 
1177   CrowdsaleToken public token;
1178   Crowdsale public crowdsale;
1179 
1180   /** Total percent of tokens minted to the team at the end of the sale as base points (0.0001) */
1181   uint256 public totalMembers;
1182   // Per address % of total token raised to be assigned to the member Ex 1% is passed as 100
1183   uint256 public allocatedBonus;
1184   mapping (address=>uint256) bonusOf;
1185   /** Where we move the tokens at the end of the sale. */
1186   address[] public teamAddresses;
1187 
1188 
1189   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint256[] _bonusBasePoints, address[] _teamAddresses) public {
1190     token = _token;
1191     crowdsale = _crowdsale;
1192 
1193     //crowdsale address must not be 0
1194     require(address(crowdsale) != 0);
1195 
1196     //bonus & team address array size must match
1197     require(_bonusBasePoints.length == _teamAddresses.length);
1198 
1199     totalMembers = _teamAddresses.length;
1200     teamAddresses = _teamAddresses;
1201     
1202     //if any of the bonus is 0 throw
1203     // otherwise sum it up in totalAllocatedBonus
1204     for (uint256 i=0;i<totalMembers;i++) {
1205       require(_bonusBasePoints[i] != 0);
1206     }
1207 
1208     //if any of the address is 0 or invalid throw
1209     //otherwise initialize the bonusOf array
1210     for (uint256 j=0;j<totalMembers;j++) {
1211       require(_teamAddresses[j] != 0);
1212       bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];
1213     }
1214   }
1215 
1216   /* Can we run finalize properly */
1217   function isSane() public view returns (bool) {
1218     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
1219   }
1220 
1221   /** Called once by crowdsale finalize() if the sale was success. */
1222   function finalizeCrowdsale() public {
1223 
1224     // if finalized is not being called from the crowdsale 
1225     // contract then throw
1226     require(msg.sender == address(crowdsale));
1227 
1228     // get the total sold tokens count.
1229     uint tokensSold = crowdsale.tokensSold();
1230 
1231     for (uint256 i=0;i<totalMembers;i++) {
1232       allocatedBonus = safeMul(tokensSold, bonusOf[teamAddresses[i]]) / 10000;
1233       // move tokens to the team multisig wallet
1234       token.mint(teamAddresses[i], allocatedBonus);
1235     }
1236 
1237     token.releaseTokenTransfer();
1238   }
1239 
1240 }
1241 
1242 /**
1243  * ICO crowdsale contract that is capped by amout of ETH.
1244  *
1245  * - Tokens are dynamically created during the crowdsale
1246  *
1247  *
1248  */
1249 contract MintedEthCappedCrowdsale is Crowdsale {
1250 
1251   /* Maximum amount of wei this crowdsale can raise. */
1252   uint public weiCap;
1253 
1254   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, 
1255     address _multisigWallet, uint256 _start, uint256 _end, uint256 _minimumFundingGoal, uint256 _weiCap) 
1256     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) public
1257     { 
1258       weiCap = _weiCap;
1259     }
1260 
1261   /**
1262    * Called from invest() to confirm if the curret investment does not break our cap rule.
1263    */
1264   function isBreakingCap(uint256 weiAmount, uint256 tokenAmount, uint256 weiRaisedTotal, uint256 tokensSoldTotal) public constant returns (bool limitBroken) {
1265     return weiRaisedTotal > weiCap;
1266   }
1267 
1268   function isCrowdsaleFull() public constant returns (bool) {
1269     return weiRaised >= weiCap;
1270   }
1271 
1272   /**
1273    * Dynamically create tokens and assign them to the investor.
1274    */
1275   function assignTokens(address receiver, uint256 tokenAmount) private {
1276     MintableToken mintableToken = MintableToken(token);
1277     mintableToken.mint(receiver, tokenAmount);
1278   }
1279 }
1280 
1281 /// @dev Tranche based pricing with special support for pre-ico deals.
1282 ///      Implementing "first price" tranches, meaning, that if byers order is
1283 ///      covering more than one tranche, the price of the lowest tranche will apply
1284 ///      to the whole order.
1285 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
1286 
1287   uint public constant MAX_TRANCHES = 10;
1288  
1289  
1290   // This contains all pre-ICO addresses, and their prices (weis per token)
1291   mapping (address => uint256) public preicoAddresses;
1292 
1293   /**
1294   * Define pricing schedule using tranches.
1295   */
1296 
1297   struct Tranche {
1298       // Amount in weis when this tranche becomes active
1299       uint amount;
1300       // How many tokens per wei you will get while this tranche is active
1301       uint price;
1302   }
1303 
1304   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
1305   // Tranche 0 is always (0, 0)
1306   // (TODO: change this when we confirm dynamic arrays are explorable)
1307   Tranche[10] public tranches;
1308 
1309   // How many active tranches we have
1310   uint public trancheCount;
1311 
1312   /// @dev Contruction, creating a list of tranches
1313   /// @param _tranches uint[] tranches Pairs of (start amount, price)
1314   function EthTranchePricing(uint[] _tranches) public {
1315 
1316     // Need to have tuples, length check
1317     require(!(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2));
1318     trancheCount = _tranches.length / 2;
1319     uint256 highestAmount = 0;
1320     for(uint256 i=0; i<_tranches.length/2; i++) {
1321       tranches[i].amount = _tranches[i*2];
1322       tranches[i].price = _tranches[i*2+1];
1323       // No invalid steps
1324       require(!((highestAmount != 0) && (tranches[i].amount <= highestAmount)));
1325       highestAmount = tranches[i].amount;
1326     }
1327 
1328     // We need to start from zero, otherwise we blow up our deployment
1329     require(tranches[0].amount == 0);
1330 
1331     // Last tranche price must be zero, terminating the crowdale
1332     require(tranches[trancheCount-1].price == 0);
1333   }
1334 
1335   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1336   ///      to 0 to disable
1337   /// @param preicoAddress PresaleFundCollector address
1338   /// @param pricePerToken How many weis one token cost for pre-ico investors
1339   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1340     public
1341     onlyOwner
1342   {
1343     preicoAddresses[preicoAddress] = pricePerToken;
1344   }
1345 
1346   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1347   /// @return tuple (time, price)
1348   function getTranche(uint256 n) public constant returns (uint, uint) {
1349     return (tranches[n].amount, tranches[n].price);
1350   }
1351 
1352   function getFirstTranche() private constant returns (Tranche) {
1353     return tranches[0];
1354   }
1355 
1356   function getLastTranche() private constant returns (Tranche) {
1357     return tranches[trancheCount-1];
1358   }
1359 
1360   function getPricingStartsAt() public constant returns (uint) {
1361     return getFirstTranche().amount;
1362   }
1363 
1364   function getPricingEndsAt() public constant returns (uint) {
1365     return getLastTranche().amount;
1366   }
1367 
1368   function isSane(address _crowdsale) public view returns(bool) {
1369     // Our tranches are not bound by time, so we can't really check are we sane
1370     // so we presume we are ;)
1371     // In the future we could save and track raised tokens, and compare it to
1372     // the Crowdsale contract.
1373     return true;
1374   }
1375 
1376   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1377   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1378   /// @return {[type]} [description]
1379   function getCurrentTranche(uint256 weiRaised) private constant returns (Tranche) {
1380     uint i;
1381     for(i=0; i < tranches.length; i++) {
1382       if(weiRaised < tranches[i].amount) {
1383         return tranches[i-1];
1384       }
1385     }
1386   }
1387 
1388   /// @dev Get the current price.
1389   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1390   /// @return The current price or 0 if we are outside trache ranges
1391   function getCurrentPrice(uint256 weiRaised) public constant returns (uint256 result) {
1392     return getCurrentTranche(weiRaised).price;
1393   }
1394 
1395   /// @dev Calculate the current price for buy in amount.
1396   function calculatePrice(uint256 value, uint256 weiRaised, uint256 tokensSold, address msgSender, uint256 decimals) public constant returns (uint256) {
1397 
1398     uint256 multiplier = 10 ** decimals;
1399 
1400     // This investor is coming through pre-ico
1401     if(preicoAddresses[msgSender] > 0) {
1402       return safeMul(value, multiplier) / preicoAddresses[msgSender];
1403     }
1404 
1405     uint256 price = getCurrentPrice(weiRaised);
1406     
1407     return safeMul(value, multiplier) / price;
1408   }
1409 
1410   function() payable public {
1411     revert(); // No money on this contract
1412   }
1413 
1414 }